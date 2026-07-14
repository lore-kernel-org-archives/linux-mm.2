Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16CFEC44507
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:31:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D45E56B00D7; Tue, 14 Jul 2026 14:31:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1E496B00DA; Tue, 14 Jul 2026 14:31:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C33786B00DE; Tue, 14 Jul 2026 14:31:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 96B2C6B00D7
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:31:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 10A95120491
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:31:02 +0000 (UTC)
X-FDA: 84988223964.09.EBA2019
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf17.hostedemail.com (Postfix) with ESMTP id 436574000A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:31:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="XCew/xq8";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784053860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XbJ+trxR7t2GCSYkV+uASOu7DEK0LHp1KcDwbXdFB5Y=;
	b=Z4zgIsTrdQtMQj5SsifV8BPoZrVAJJcLMSDqks68aUg5Rjf4m10XnAHzH605A/Op7NR5d3
	WzMJH/bQm5agtjYsRd39q/rBFZxDSaI+jTjPAaCIrUJXDVOqxnox/g5VlAyo9xerbLezpI
	H2sCkLtTKhi+l+wN4++1jd6gBSU8OSY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="XCew/xq8";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784053860;
	b=sgMrJyCbqYmIR+g9XxkthHBUkSlcWEdV9EGm3FP83bsfuOK8ihI9qO8eZ/ALovY8WMd0D+
	jOBoVnYU3WaZLZZSdXV+q97ayp/2q7V8HqHaobN7eKhhsuLktNXkCj7JwFfgEsLsZu3HTY
	sHRHYZHY4Zfcn66RatSmNzKr3LlnDRI=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51c01089e8aso10169591cf.2
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784053859; x=1784658659; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XbJ+trxR7t2GCSYkV+uASOu7DEK0LHp1KcDwbXdFB5Y=;
        b=XCew/xq8iuBlmMk6zzDwT+RC3mSq/J3UeUAngek4zHhxi6Izh0n44QsKc4xEG6e+eF
         Hqu5fO/1Pr1qex/kp/ztuClgTWb7Tw5U8pH79s6Y7SaXBpj2uhOB5w8xNS8sp33Ne2xZ
         JXqSOgryFH2G+gFPtUa+K5rrWNdC3oQ0/TEUKdgGTePX30UBNbaQax1Hv/nLrc1XLaus
         VvT6BiZxxixNHbtUcKnYN5CRlPAvA7+IcEDZbXr2fzPPxbr1ybzJclIG92OpCKqT5IB4
         pjzdWnW7uXcNvUOeVqnmfNerMW5Sox9xOfHrEGL1Ni1B2hUbR/QiN8yg4bQmV4hkO888
         52Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784053859; x=1784658659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XbJ+trxR7t2GCSYkV+uASOu7DEK0LHp1KcDwbXdFB5Y=;
        b=McEuW7/yrn1fU00apco8s1rOYm9LuEhES22rmshd6ekziGfOFEU90mLDR2LPALbiUq
         ZiB3/GaJuWonzJYUbItRQZySLK/dYDbxhBV0al2bIt/mQGm0Lnjlzds/MaoNWEKCZhbv
         J/Ggap07HT/Sux2LYRyeoo1JdYJQzxKqxWSidycuNb4vdbekbaWNikr7/gZeNbZgNisu
         i0mmuamNPI2o4kIwqfx6Tf904ipBsVGJOgiussEJEbyTPSsIOoI1DGy579FZfES/wk4E
         pcSxd/n4Ysvt6WcaG7KKC/pfDC78Bps/4VWB41wbwbhBtsLvBfGrgJr5Muu+4MGrVbt0
         b1cA==
X-Forwarded-Encrypted: i=1; AHgh+RpcddDCNHEAy7ZUWTufItbZHqB/EYVYEvKcyRg4jfTEG5BHkewhYgTTO51AxL83jrom4+ohqW6SZA==@kvack.org
X-Gm-Message-State: AOJu0Yxjowl4ZJM0PhRcGQXMURx8jIBAXAPE7aQxYb1k1FHbg+Duw3qr
	CECqjlbNAr/mMpI7Azqzl+mlDCctN20cU6URuQL6Cw4axr4qsV6j+CC8
X-Gm-Gg: AfdE7cmQ9hxYUwjgBIcS1HpIb+5pVhs1hHJeOlQVblKWF1fumAvx2On3vmZLAif7P4Z
	BwlaXoNbVgz7anzGCK4MZd7etal1fBv26RjondVIpw65gnXj+MwhnZicDYa/LbF7Iy+EzwF7KkV
	hlFlRiQV+ZlCpPdvsslmNj/9XFVJ0DFPfukn8/PrrvrVSBKNX3hneA7NKx5bl6TbG8/k5rFkJH9
	Qae/D7lrQsZaqO2RSYUZ9cUki9lBO0o7CJsru27tSOCJthM3kqcqdzfQTEFfdJh8F9Ex8B8S407
	8djEdaKxTOOedhhU+EK+/QXo/zyy1uFEYRKtYoO5R7XWd77f5onTVAnxstBRKqMTuh+8LcIUd9D
	giiGQmifQiqb8zZfEeWOJ69e12EaXQYC+Se++Pg+v2MnB6mz5nFtFI0PJqFLpB/JMxDKr2RLTl8
	SoVd1UboOtxpxzEi7nEZcGD5RaZmIiZ6qyCqU45QPxvPK1Osrq5w4=
X-Received: by 2002:a05:622a:1f98:b0:51c:84cb:b9b0 with SMTP id d75a77b69052e-51cbf301566mr148948911cf.81.1784053859166;
        Tue, 14 Jul 2026 11:30:59 -0700 (PDT)
Received: from localhost ([48.45.163.146])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51caae24d04sm117191211cf.18.2026.07.14.11.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 11:30:58 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Matthew Wilcox <willy@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [RFC PATCH 04/13] HWBP: Add modify_wide_hw_breakpoint_local() API
Date: Wed, 15 Jul 2026 02:30:49 +0800
Message-ID: <20260714183049.12383-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260714182243.10687-1-wangjinchao600@gmail.com>
References: <20260714182243.10687-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y9p4swe4xko8f7r1b4fkn9iz31znwmem
X-Rspamd-Queue-Id: 436574000A
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784053860-667215
X-HE-Meta: U2FsdGVkX1/WlvOsdf0KVIxSAFyfhuJvx7PnHjNiGaC0HzsV43QBTD/kclE8JPE3PCGs+QdeNkzMN9SEGtp2h4wGz/a1eT+m8BQpPSw5HPfLVUmBxrccVJHvyAJazrHVf1wSWj9CA9w+Refn2JV7vpJ9u8KIDPppbjtGEjOyKiGFZl5IggxEIZTD06TPUzw7JLcQOYeuGehYn6z7IKVsjJCV1581dhthpWyi9HuIPh2XOew35YvdovwcudjNR20k30C0E9nJ6kyZ5eaY0E7CJLoz/MUMXKHQPQPkooCDg6QTCZFAemIP+YEtEm7RKPNPLxeYB8OPzGBCa1uX1czIeGGXj4IWNzrgJURCc3bPok+DzK6FQKk+CG7Duk7vKL7N8C0Ff047f1m7y8H1wYHVPi5HKYPEo8JPDYohYATpWue7NZrWgfn3wIEFL8/Deii8z4yETX8fju1JRgjVqmTV0IWR5c2LdvCQDtJOwqVX08BNQj/95CYCJnxqZgod16ffLV09B8SRQ2d3bhWz4H1EmPP8DAkg2gmWkYAECiGg0YDGTEQ+n6mREESLZaJOYHURZEEjcu+LpFJCfI75MCFUD1a4Ix3KXc42FphPxJoutqAcpwRPuN2mDWLv6MKqy7rgyMnBm2DTNoK07fMbsYLHMCDP0Wx+PS9LLbSthKM5V/++mH5ehtBveTNF/JJqQraow2Qa5MJMz1R861eU28z1cjahtHdlbr4lvY+XaRrcQHsZ8+oniQTaflHZGKR6yJhH1apC9XQEogYgCAmK4yWZ7Jp6HuLYbuWnk2jiYho76/6JzoGRCCA/LewhdnclnQnvAx6f7820MRUU+sgiuyFPGUmjIoh2VXK0c4bFDobhDydrH8XFZh6lX5w8/gKabtBSyQkktlLF6VgWqcRQgeKOoVo+9L1zkxjOKagIfYN84BWOdC5otfii2k7y+8fHi8i2ByMRRe7ttcHG0Hbyv6l
 RIJbPszH
 5Gn0wxjh8/vdkat/BsDs3OUMywa+5/rnVoYLoTPFIkBVO2QFIdW/H2nHQT/gCxeXgDgJcg2ZijsBgkEpxo1Jw5ev/Bf6lti0QYBP54x+P/qI2MFQmJ2humgxBb9QfN6GFcfJ9x1EM6w2pdIQFdZaLEUo//EcYLh0PMek4m0n3sf9eBfDdRJc0f4NbmeSSWnX7AHarzJ98jBXtHdAIiamE2qcPkkIWCbVhbadlIJqb3SyRAoPCbWyqRP/pVXqa95U3f9b/hmgD9IYh/vuxqMus13dsAp0SP/AjLpaOjTzBKu1FYJdqA2syEzoiqHgLKkIIu9i6ABLRrpsXsULjqX7gp38bHzxfSrMCl8cmOXiGlXXaDLtRqEw4ciJdeh+wAAB1biwesECrKBbanvpcbCsjQO2c4XzRnr6UNClrAXCJInGKbyBCQv7oEEAw+43V4QiWQ5uT30JOFAjk5EMBWY2vmgFjF6O8tSY3rRSn1T7dcTptDpReLVIZcV8WQSCNBgeHgu+XRCPpuJD1e0A36F83bCbg0bhwF+4Dkx9aF18oxIKDDiWb0Uh1RAkExw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>

Add modify_wide_hw_breakpoint_local() arch-wide interface which allows
hwbp users to update watch address on-line. This is available if the
arch supports CONFIG_HAVE_REINSTALL_HW_BREAKPOINT.
Note that this allows to change the type only for compatible types,
because it does not release and reserve the hwbp slot based on type.
For instance, you can not change HW_BREAKPOINT_W to HW_BREAKPOINT_X.

Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 include/linux/hw_breakpoint.h |  6 ++++++
 kernel/events/hw_breakpoint.c | 37 +++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index db199d653dd1..ea373f2587f8 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -81,6 +81,9 @@ register_wide_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered,
 			    void *context);
 
+extern int modify_wide_hw_breakpoint_local(struct perf_event *bp,
+					   struct perf_event_attr *attr);
+
 extern int register_perf_hw_breakpoint(struct perf_event *bp);
 extern void unregister_hw_breakpoint(struct perf_event *bp);
 extern void unregister_wide_hw_breakpoint(struct perf_event * __percpu *cpu_events);
@@ -124,6 +127,9 @@ register_wide_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered,
 			    void *context)		{ return NULL; }
 static inline int
+modify_wide_hw_breakpoint_local(struct perf_event *bp,
+				struct perf_event_attr *attr) { return -ENOSYS; }
+static inline int
 register_perf_hw_breakpoint(struct perf_event *bp)	{ return -ENOSYS; }
 static inline void unregister_hw_breakpoint(struct perf_event *bp)	{ }
 static inline void
diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index 789add0c185a..20ca64f30508 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -888,6 +888,43 @@ void unregister_wide_hw_breakpoint(struct perf_event * __percpu *cpu_events)
 }
 EXPORT_SYMBOL_GPL(unregister_wide_hw_breakpoint);
 
+/**
+ * modify_wide_hw_breakpoint_local - update breakpoint config for local CPU
+ * @bp: the hwbp perf event for this CPU
+ * @attr: the new attribute for @bp
+ *
+ * This does not release and reserve the slot of a HWBP; it just reuses the
+ * current slot on local CPU. So the users must update the other CPUs by
+ * themselves.
+ * Also, since this does not release/reserve the slot, this can not change the
+ * type to incompatible type of the HWBP.
+ * Return err if attr is invalid or the CPU fails to update debug register
+ * for new @attr.
+ */
+#ifdef CONFIG_HAVE_REINSTALL_HW_BREAKPOINT
+int modify_wide_hw_breakpoint_local(struct perf_event *bp,
+				    struct perf_event_attr *attr)
+{
+	int ret;
+
+	if (find_slot_idx(bp->attr.bp_type) != find_slot_idx(attr->bp_type))
+		return -EINVAL;
+
+	ret = hw_breakpoint_arch_parse(bp, attr, counter_arch_bp(bp));
+	if (ret)
+		return ret;
+
+	return arch_reinstall_hw_breakpoint(bp);
+}
+#else
+int modify_wide_hw_breakpoint_local(struct perf_event *bp,
+				    struct perf_event_attr *attr)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+EXPORT_SYMBOL_GPL(modify_wide_hw_breakpoint_local);
+
 /**
  * hw_breakpoint_is_used - check if breakpoints are currently used
  *
-- 
2.53.0


