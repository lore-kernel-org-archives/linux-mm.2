Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AD8FCA0FF2
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:34:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E977D8E000E; Thu, 28 Aug 2025 03:34:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E20888E0001; Thu, 28 Aug 2025 03:34:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE83A8E000E; Thu, 28 Aug 2025 03:34:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B82598E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:34:29 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D6A3160A35
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:34:29 +0000 (UTC)
X-FDA: 83825353458.11.556F729
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf25.hostedemail.com (Postfix) with ESMTP id A25D1A0004
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:34:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FSlpufJr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756366467; a=rsa-sha256;
	cv=none;
	b=hmEWUrJB9GVITMI/OjNep9HXIALSUxDnrm7D0eZHB1bUA5N0vc6U+7uEnGZ1mUdffZZPxF
	dahTjC66xkbLyRwWcBBNLHQHCFLAv0pdFzUlT8KvUkWpXpMHOEiabxx2miYzJW0WWyWtPI
	bX8Spc+CypdWd1VgfDJjdGepQBgApyM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FSlpufJr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756366467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BQYOiNSD0BVFYt8LJn6Fepybq7p8FLHlj9qtf7JwQoI=;
	b=6EvQIOGNFhnz0JKGwOfNQqnH+KGOYVM4V/fYsvi7oSOCFhphcvtBC0PxtpSOavtlvvY6mM
	oUMNHyIFqZw4N0KczP25wtz1PnUT5K4ieqksWIKCenMABLTx1GKExBkTmnfARJ9zZAG7tu
	X31EevA6RXIHBEw/u25AQs5wkYzrvFQ=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2489c65330aso6459515ad.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756366466; x=1756971266; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BQYOiNSD0BVFYt8LJn6Fepybq7p8FLHlj9qtf7JwQoI=;
        b=FSlpufJrG+ENagU7BBkLh7zwp1cFP1+bumujL5X1sWTkIjSw+1dt07zS/Qrl2obZFN
         ZEP+DuvMrBKHpQwSfhXJYvQOo3VzMS/DwEN6FHBMAOpCfetK/LdvJps/xKXlBQlY4AkJ
         /DOeYvbgvs0wi0KYaESL+SXat1+lQzwnwRCNDUXjgGnIZkmWmeu2SZ8Jp9YYHYFxOWEK
         zNlorp/FwoBYQETUV3lKaWEKk+wR7eZk9eo7lf9eWlSGWl3lLYbw5P3HPe+/H3TUSO1J
         JhJLQpVC6pLro82BwVdgIBe2fHGeZUehHjRertjZEmKHLW69iEdV43K1CdQBw1DeA0GQ
         OQRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756366466; x=1756971266;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BQYOiNSD0BVFYt8LJn6Fepybq7p8FLHlj9qtf7JwQoI=;
        b=m/TPw+DXg1J2yqNomMesu4NUqsBCnL9FCf8JHgzuv24bTfvJ5/uNiSvcaU8gJqsUXg
         4qUP47yniQhxZeCFsCqtkrXG3y1dQM/h2iGIIxbMH6hx+FHL4L4ekmcAXEE0qFBFw74X
         vnCWL1qIyVNopAZCjbRxV0G0S1JZGIw/M4MTzCOJD33ySmCkLB6g+D0o2oVuXgrD7sp2
         fM9mAtrohDKpNbpZ6UjLe/rUsQt/nxw6zE5iVH5IfTKjUlSMBa1GxZ+j65ssZase7Cvb
         XOyDEDvGQgx6lFYcYT/eLpU2iFTYVMJcGGQBIjTWAQsYjN+fUfW50vb4rQFdJg5+9HFI
         Xyfw==
X-Forwarded-Encrypted: i=1; AJvYcCUG+m5+FyXQaVUanh1CvYBOqWV622p/IZWffqT4u+MbRBGVNd5mQaTQBMA3rUey2tgTtg47FQDxfw==@kvack.org
X-Gm-Message-State: AOJu0Yykb5GgmukV5iUofT2VLHfZNhLtUvaGc6xNCzepgkX1cp5SeT+i
	PBEfvNkDwPWBUJyl9wzL2wAgvxJyIzSADjIWciNXRcA4NM1w1M7/iQFN
X-Gm-Gg: ASbGncvXKCfIuHpzdk9zsrAPyObjHe7EOYjc6tGtzSsehBPL0J2lxwXZ7++i12QYUnV
	vvnaYDWO/LUB+Mo0TBFK7HFI38Xc2M6tccECn/NqW3VHAgnG0ltTkbF3o5J0jHwUg+seoN5pRqT
	sWOlE5+asJhljAtm0k/Zbv4i4A8GxZR2GsKd7cRadWwyQp9AuS5J4kj5oTl8WkYcI696sSOqel8
	duoqnzBrSuVk4Xg/Z3PkxqfcLl302blpr6EBhF2kGtY2kQQaQTGUJrC7hWZKM2sSXZN4zagQ1Au
	xojbaZ//YwdlaaWqNbiUgVxRHT5yUhZLAxNgDeouYKvrdc2EC7cIgVbhZ6YPLYn5sj/hBDt0T96
	aol/8OgnuQW2kmsqjyWy2EEusQxz+QKjIA55ROHj6YSnivZUO68Voa5RXdhJxq8KgOUhMGYQ=
X-Google-Smtp-Source: AGHT+IE4aRaufJVGsSk9bLtr/W5Lqko9zfUO1kQyEX8W4RgjXYJGEEk+9pgg5qU+rFjRTJfPqxplDQ==
X-Received: by 2002:a17:902:d4d2:b0:248:9964:3796 with SMTP id d9443c01a7336-24899643b24mr70784475ad.43.1756366466373;
        Thu, 28 Aug 2025 00:34:26 -0700 (PDT)
Received: from localhost.localdomain ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cb8afb7bsm13182613a12.16.2025.08.28.00.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 00:34:26 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH 05/17] x86/HWBP: introduce arch_reinstall_hw_breakpoint() for atomic context
Date: Thu, 28 Aug 2025 15:32:38 +0800
Message-ID: <20250828073311.1116593-6-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250828073311.1116593-1-wangjinchao600@gmail.com>
References: <20250828073311.1116593-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A25D1A0004
X-Stat-Signature: eibq9epxkfbgm74ri5zkkkqckb8c6aus
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756366467-432993
X-HE-Meta: U2FsdGVkX197Y34loYrRroyTH5bsKGKUPrzy4oFkUcWrdc+/051b4rru+ubt0tPeThqo+5+ieWjOFcrJlT02UmbH8ir0o3WDO05xR43GM+IW4kkpFQ9ZAfYdESPwQA3HUdEdH1kMZVsksozmZdoNq+Xr0S0P7q1fKJ+Iukcc+ltlgHG86ydiAnUEry6y9dceC766qpQTKUrZpEhX2C6eYWk/GUn2Ycl6DSESco1f3/0djLOUzOZ5nQZFy2DPMNsaSEBy3/HzBv4vKBT2WwWTcuPk4K5/LIjmQOBZH8HV0pd1IEarsgwesOviApqrBfSozOJufUxwQXS2/viq3W+NinZ+TYxtLkJ4G6PX69VWW1bvtKUKwCOAQ8WCJufRNs7XWsonfOxrtDMKwcM7KpAcDhleZ8/Bo3inZnrG8T1xcmKSBEVzEThjJ8/Javbr4xAwIxpv9HuEXHpwzNvZnMB9YAOV1oz6gSEO8NtwUBr+BX0uwZMRIdm78+HMYD967KR2XVwIex4yG/+xmTkntVV4mksEz4oixoC+AHwmrwH3FGa49mSb6U2hEQFJufi267WxF7NK7w5reqEuNaw0Y8FVNpePEb2oFMT0hv/NyIEywrJLzR0KC4AXLrOAhk13lnWsmVQH792Tq1f1mQDoRDzJgljVPESaZp6j1ZUeQx4cyOGvenQ+K5MHiKEKp52vdp8SVBi4gRwO4BNuyE7X29lOnfxlSSa5lEXrB+dMBa9rj8Adfcg1myoqC9+o7HmFkgdXy9XwAfydnOYs5j1ofeyhVsh+x2U2d96HLAApbcu9LirFGgLX+jSvApYc4Dauae+4SnEVIOT6YrHAN9DQqp1zh3h4XwANfZrswBiYPQxIALJbem2JsSEvlcWEJ3fQ8wZdhx6Gok9gu2x6qiPfXkpWCgVy4s2dD78uRc0fse9aGSs4dwhSlOqCw6CK8ADicjMGCtXqHAB9Ea8bwr4QIjz
 Iz+/gJoT
 aRsArVTVKHr3/QK88ou0KKpUz4VUXGfZX0xgzYav4r7uaToT3dkEVg9aw69+sclg6Fcfkw+IHihZ8WOnCrt++1DTXvymxVFSSAg+gPFDslC5lWYfeD6sHPRntsLicpE0ajy1/dIYP/TBDIbR2RQxjK+oqkCNM6J3/2yhLFRodyjZGLQMrevaBAZTUuOTD7rOK8IcvAxgp3JpkgLFftK47IbC9oP16a3s0QIczv4WAlBCE294Czvg1t0fL5f3yEycGhUaDJyEa6xgZJu8iUZdsK4ia3DgppyKVqjTpdsO44ZjZ8zx+YAiWFshF7z2NtZqaw6uNxgvMh2mEwuXV7eyVR4QrICTStV/TsG8mXNPXQK99e/EFcfaOq7zUgEIxPACxS7F33uEMq2R3k+Fidx7d7WfcJMUbymhbS+LBY/UE1HptJu6GgC+14gRhvf6BbMiCNoS4vUsaxEpioKxgVkJ0lbhm3woqLmsck2dS0i5oh+2JIigF+WRfon1jPmrt2y17XWZQa6wBD+5SmxQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce arch_reinstall_hw_breakpoint() to update hardware breakpoint
parameters (address, length, type) without freeing and reallocating the
debug register slot.

This allows atomic updates in contexts where memory allocation is not
permitted, such as kprobe handlers.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 arch/x86/include/asm/hw_breakpoint.h |  1 +
 arch/x86/kernel/hw_breakpoint.c      | 50 ++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
index 0bc931cd0698..bb7c70ad22fe 100644
--- a/arch/x86/include/asm/hw_breakpoint.h
+++ b/arch/x86/include/asm/hw_breakpoint.h
@@ -59,6 +59,7 @@ extern int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
 
 
 int arch_install_hw_breakpoint(struct perf_event *bp);
+int arch_reinstall_hw_breakpoint(struct perf_event *bp);
 void arch_uninstall_hw_breakpoint(struct perf_event *bp);
 void hw_breakpoint_pmu_read(struct perf_event *bp);
 void hw_breakpoint_pmu_unthrottle(struct perf_event *bp);
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index b01644c949b2..89135229ed21 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -132,6 +132,56 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
 	return 0;
 }
 
+/*
+ * Reinstall a hardware breakpoint on the current CPU.
+ *
+ * This function is used to re-establish a perf counter hardware breakpoint.
+ * It finds the debug address register slot previously allocated for the
+ * breakpoint and re-enables it by writing the address to the debug register
+ * and setting the corresponding bits in the debug control register (DR7).
+ *
+ * It is expected that the breakpoint's event context lock is already held
+ * and interrupts are disabled, ensuring atomicity and safety from other
+ * event handlers.
+ */
+int arch_reinstall_hw_breakpoint(struct perf_event *bp)
+{
+	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
+	unsigned long *dr7;
+	int i;
+
+	lockdep_assert_irqs_disabled();
+
+	for (i = 0; i < HBP_NUM; i++) {
+		struct perf_event **slot = this_cpu_ptr(&bp_per_reg[i]);
+
+		if (*slot == bp)
+			break;
+	}
+
+	if (WARN_ONCE(i == HBP_NUM, "Can't find a matching breakpoint slot"))
+		return -EINVAL;
+
+	set_debugreg(info->address, i);
+	__this_cpu_write(cpu_debugreg[i], info->address);
+
+	dr7 = this_cpu_ptr(&cpu_dr7);
+	*dr7 |= encode_dr7(i, info->len, info->type);
+
+	/*
+	 * Ensure we first write cpu_dr7 before we set the DR7 register.
+	 * This ensures an NMI never see cpu_dr7 0 when DR7 is not.
+	 */
+	barrier();
+
+	set_debugreg(*dr7, 7);
+	if (info->mask)
+		amd_set_dr_addr_mask(info->mask, i);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(arch_reinstall_hw_breakpoint);
+
 /*
  * Uninstall the breakpoint contained in the given counter.
  *
-- 
2.43.0


