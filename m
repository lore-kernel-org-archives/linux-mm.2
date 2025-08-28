Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FEFACA0FF2
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:34:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C74E68E000F; Thu, 28 Aug 2025 03:34:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFD8B8E0001; Thu, 28 Aug 2025 03:34:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A77D18E000F; Thu, 28 Aug 2025 03:34:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9057B8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:34:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 59EA685358
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:34:33 +0000 (UTC)
X-FDA: 83825353626.19.122728A
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9FDA220005
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:34:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hokouIib;
	spf=pass (imf03.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756366471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nhYtCOUm6bvq4qZIRBPhvFj01jBGWvLGzlXSp/AiWds=;
	b=QtZcFhxCrjL3FijlI0MWAWW3PAPPM55U305ru7q3FYznXBTcrwU3lpkX8QkQIYJ9/+3f0s
	i2oGY7onOJSu1Se2WD3hM1RwSiZMxv9mpAxBCRIX3wJgiLcHVUCMFNYTZvBHUGlYAbQ7R4
	1zx06Ia/Sbsid9/9hkMiMxSg15mqd9g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hokouIib;
	spf=pass (imf03.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756366471; a=rsa-sha256;
	cv=none;
	b=vMKsXwS//5hLKR+cL+1W6i+2q7YCsV1KucnYkGhkSNbzaGvIdo+UGW5LIqMSYvYS71Qvyv
	LXL49gt1YZsxpvaxfk7qSXPK0c6lhDON5E3H5sSfvrF4+T2XEoBsQq/vgKM4RZj77nGiFt
	bQxUzFbOpMExtFoi4VbZ6qQF6f0kWOY=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-770593ba164so578736b3a.3
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756366470; x=1756971270; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nhYtCOUm6bvq4qZIRBPhvFj01jBGWvLGzlXSp/AiWds=;
        b=hokouIibVgJ4OuvhYYdBOZ7buixfqm3+vJL/JcRUjH13CMAJP4zvQx9FWE6XMPrBkt
         6794l11DF6M2Qyho156jrurw/vSkCs7Lhr7Padvgy/jS0ssthjdXFpngRxr0341dyrC8
         FrAzdfQM6kdYjAoY0JartjHiKCzveT2YTLjqoa5rumy+4ED7T+sKC+2WY6bGoXxZc6t8
         22JEXMoldiu2MdUM1WlC0aaBbdM6vtcbomfdzFRtTvH9qz1bfNz8uW1LeA6Zy1EIzKft
         f31KMq07hsYfXoupct08kno7g9Qo+wMCZvBYATsqvQpJzcOnEsmXupmZ7BPxA+UUYmo3
         /roA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756366470; x=1756971270;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nhYtCOUm6bvq4qZIRBPhvFj01jBGWvLGzlXSp/AiWds=;
        b=NYsFaURNdFR4CRsGLsdJ/YX8agZw7XbpIZAFSoM9UFHNgYngI02Xd8ha5+uc5c+f18
         ZSZDn6Xf55xaoRrAYRI6UQmjayTRQ3LQLqCJfUaox6D4YsMM1yjFFsCeCL1LNu7W8Soc
         4siWbuPkBMoNqfJwBH95XPwn3yuY43LzNkhFk1sciBR5okXisFg3ryLj1VXrz13wtFWy
         ZjmkjsC9wgwGCDjitd+ssG6hJGQQzTk+wF44zpD8NYF8GMJKWPsH4lJjYqt036n+RyY3
         IjaEVXmIHZhO6aXcP6xqk/taIt3NGTDOS5XBDBgPO0VNzMX/+vK7OYYX5pvC03lNtmwI
         bXNQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxvp1pxKKXfjvAK/nrVIWjh6VW2Nxehf0P5KqcKlfLg6XFipjJ6zRm3AWLUj16qqgK8uReLVPKjw==@kvack.org
X-Gm-Message-State: AOJu0Yy8D49ppKsCggI17bNnggbVqhW+LoWfSzkWo+NSREIRvU3wE4tP
	GOUJmqwAyJCW/jiiiYbgw4ZPRsctuDEPb9KkHTNTy3Nhy4QAHV8cUGNi
X-Gm-Gg: ASbGnctGqDT2Y/vS/4UX4HI7r7qCl4cjyK6hbr1Uncu+Qit5v5UhDyptJBK1xHKN9So
	IS71hhLKgvG0GFweyOYfxPEcNhFuAc8yKd+07Vv9r0U4iMAJFRNsu9YeOyKKFNXDc9JbvQYvQ6u
	UqapDQkISSRDT01vPmNnDcXBBjsh9Q7B4SsXvVPEcCH9uBTijvzQIKLJLN4w1zh3nomf5zHleR2
	yiKZQcNDOVRShZBm2xYnHp/ClnToukkXjoqKdazTjVuqb2TuMvduVU0b0wYZaS4eXzzPWmo1sqf
	G2Mo01BXQ8LFomikVHEvtaAPcVt16rBv3v9rwkUTnXKBobCGcGPIfqHzdXZk6Mgq1fO5lSawFTJ
	v795ubEKz8RhcuySdc0iVP6pCe4JqzGNnqrVgQ+8XJEdl05m9S0jX8SmFqv/M
X-Google-Smtp-Source: AGHT+IGixiCEjVcYHcne/aHNIr1QDzxbqM5oGrgRGi2xpynpf2i3z8+aAxOQ92IXbm+/nHFvDKB7rA==
X-Received: by 2002:a05:6a21:33a8:b0:243:b0fb:7086 with SMTP id adf61e73a8af0-243b0fb711fmr1251757637.4.1756366470529;
        Thu, 28 Aug 2025 00:34:30 -0700 (PDT)
Received: from localhost.localdomain ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cb8afb7bsm13182613a12.16.2025.08.28.00.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 00:34:30 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH 06/17] mm/ksw: add atomic watch on/off operations
Date: Thu, 28 Aug 2025 15:32:39 +0800
Message-ID: <20250828073311.1116593-7-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250828073311.1116593-1-wangjinchao600@gmail.com>
References: <20250828073311.1116593-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9FDA220005
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: urbrwnfrsjox4ugcd6cicdxojj1bni19
X-HE-Tag: 1756366471-221776
X-HE-Meta: U2FsdGVkX1+KqJqizUDzumcISFt92f7S8GNHNKaOlAeVDwFal0IFfydP6N4DJOe7R5WAfDc9rJfiW40DacPLx3jYyngmUE4uYGEi+grlkkCYABNNxWfEM8flIRNjcW/vUju4WnLL3HFSTSB9xHo6b5NkbiOfGuKLUS6r6CVa6SBgdo33hV0KCh3DqADhcwiHzGee7qeOaUZXvEZaLc1Zxo2vcrIOP1jnJwybgJf0DVRSdlMIOyV8MEw59FZyPqLh1dLU/uXqRrF37O82Ft0K06DNGvHSTOaJArZ6JUy/EZq5INGjZaog1hN4I4rwi7bAkWBgj1iTBqOjhTAPDoTxjeRGlHbpl9hTz4xnXGIz+9035hQLeB51mUBCHikIkFs5QFD8nB86pNRIE9l6ts4gCfI+0tLsRDhTexe0aV43vxLvDiDzMeCU5A04xGQmoV2b4FUiLPOmRUULbGf+IxtnkPBh98P39oOcIAQRV8814AMPRXK7hc4BhyL3Q91DLPKqZ5dy0DH2IKP9eTo7Gahefg+6DzJQKVzUO/I6rjmF9VhmcFO4/ksSslT4NPmvg4lR2Lmg9lyDL/dKEhASpxZJVfljAa5T0wDyeIt+kTqiMgW2UgIcDnLgAXCB4j+8fjV4BmpeyY+0oBW2OpOTnx1PYaW/5nPqbZErMitcugyYZE8Dh83BUE1xIKtYXEsStIgZR33T4wLBzeXwvI8dVBVz0mQP0AWGVe97q2/OAJELetPK6vib7HTZLVlsn3tAdQFL7srlGY1nNMYwk/1VdnNVcdRgFx5pBj2i+GYlq49Ty5hb/oAoI1rbe6xzP89AKis76TvmtOcm7pb/8qFIjgGZjTntJnrxzPQf6b9SOfi1kOwuXtS03esCeWLGTQS7I5qnRlhSntEjBs09y2jpLDu+7BYf1iLCgrAd9rOIvBg9UjxvyMD6n7kC2+USJ2JvMlRE4YKQ5le2ss7Y3Zs+ETp
 37c8/4Yq
 k1Nc1V4daR0Y2iLo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support to atomically turn the hardware watch on and off without
allocation overhead.

The watch is pre-allocated and later retargeted using
arch_reinstall_hw_breakpoint(). The current CPU is updated directly, while
other CPUs are updated asynchronously via smp_call_function_single_async().

This allows KStackWatch to switch the watch in kprobe/fprobe handlers.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kstackwatch.h |  2 +
 mm/kstackwatch/watch.c       | 99 ++++++++++++++++++++++++++++++++++++
 2 files changed, 101 insertions(+)

diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index 2318779bde70..13ef8c79f855 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -41,5 +41,7 @@ extern bool panic_on_catch;
 /* watch management */
 int ksw_watch_init(struct ksw_config *config);
 void ksw_watch_exit(void);
+int ksw_watch_on(u64 watch_addr, u64 watch_len);
+void ksw_watch_off(void);
 
 #endif /* _KSTACKWATCH_H */
diff --git a/mm/kstackwatch/watch.c b/mm/kstackwatch/watch.c
index e7ed88700b49..284facaac8fc 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -16,9 +16,21 @@
 
 struct perf_event *__percpu *watch_events;
 struct ksw_config *watch_config;
+static DEFINE_SPINLOCK(watch_lock);
 
 static unsigned long long watch_holder;
 
+static struct watch_info {
+	u64 addr;
+	u64 len;
+} watch_info;
+
+static void ksw_watch_on_local_cpu(void *info);
+
+static DEFINE_PER_CPU(call_single_data_t,
+		      watch_csd) = CSD_INIT(ksw_watch_on_local_cpu,
+					    &watch_info);
+
 static void ksw_watch_handler(struct perf_event *bp,
 			      struct perf_sample_data *data,
 			      struct pt_regs *regs)
@@ -32,6 +44,93 @@ static void ksw_watch_handler(struct perf_event *bp,
 		panic("KSW: Stack corruption detected");
 }
 
+/*
+ * set up watchon current CPU
+ * addr and len updated by ksw_watch_on() already
+ */
+static void ksw_watch_on_local_cpu(void *data)
+{
+	struct perf_event *bp;
+	struct watch_info *watch_info = data;
+	int cpu = smp_processor_id();
+	int ret;
+
+	bp = *per_cpu_ptr(watch_events, cpu);
+	if (!bp)
+		return;
+	bp->attr.bp_addr = watch_info->addr;
+	bp->attr.bp_len = watch_info->len;
+	ret = hw_breakpoint_arch_parse(bp, &bp->attr, counter_arch_bp(bp));
+	if (ret) {
+		pr_err("KSW: failed to validate HWBP for CPU %d ret %d\n", cpu,
+		       ret);
+		return;
+	}
+	ret = arch_reinstall_hw_breakpoint(bp);
+	if (ret) {
+		pr_err("KSW: failed to reinstall HWBP on CPU %d ret %d\n", cpu,
+		       ret);
+		return;
+	}
+
+	if (bp->attr.bp_addr == (unsigned long)&watch_holder) {
+		pr_debug("KSW: watch off CPU %d\n", cpu);
+	} else {
+		pr_debug("KSW: watch on CPU %d at 0x%px (len %llu)\n", cpu,
+			 (void *)bp->attr.bp_addr, bp->attr.bp_len);
+	}
+}
+
+int ksw_watch_on(u64 watch_addr, u64 watch_len)
+{
+	unsigned long flags;
+	int cpu;
+
+	if (!watch_addr) {
+		pr_err("KSW: watch with invalid address\n");
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&watch_lock, flags);
+
+	/*
+	 * check if already watched
+	 */
+	if (watch_info.addr != 0 && // not uninit
+	    watch_info.addr != (unsigned long)&watch_holder && // installed
+	    watch_addr != (unsigned long)&watch_holder) { //not restore
+		spin_unlock_irqrestore(&watch_lock, flags);
+		return -EBUSY;
+	}
+
+	watch_info.addr = watch_addr;
+	watch_info.len = watch_len;
+
+	spin_unlock_irqrestore(&watch_lock, flags);
+
+	if (watch_addr == (unsigned long)&watch_holder)
+		pr_debug("KSW: watch off starting\n");
+	else
+		pr_debug("KSW: watch on starting\n");
+
+	for_each_online_cpu(cpu) {
+		if (cpu == raw_smp_processor_id()) {
+			ksw_watch_on_local_cpu(&watch_info);
+		} else {
+			call_single_data_t *csd = &per_cpu(watch_csd, cpu);
+
+			smp_call_function_single_async(cpu, csd);
+		}
+	}
+
+	return 0;
+}
+
+void ksw_watch_off(void)
+{
+	ksw_watch_on((unsigned long)&watch_holder, sizeof(watch_holder));
+}
+
 int ksw_watch_init(struct ksw_config *config)
 {
 	struct perf_event_attr attr;
-- 
2.43.0


