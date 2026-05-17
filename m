Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95F8DCD4F3D
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 23:06:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C87006B0005; Sun, 17 May 2026 19:06:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C37B26B0088; Sun, 17 May 2026 19:06:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4E1F6B008C; Sun, 17 May 2026 19:06:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A6AF86B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 19:06:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 36B1FC24E4
	for <linux-mm@kvack.org>; Sun, 17 May 2026 23:06:05 +0000 (UTC)
X-FDA: 84778446690.05.1F5C9F9
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf30.hostedemail.com (Postfix) with ESMTP id 69C3C8000B
	for <linux-mm@kvack.org>; Sun, 17 May 2026 23:06:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ETV5QP/t";
	spf=pass (imf30.hostedemail.com: domain of 32UkKaggKCOwXOQYaObPUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=32UkKaggKCOwXOQYaObPUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779059163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RucpAInGrAJfsY0XRVsWleuNH9XqB7VdVnWXH3TZFzQ=;
	b=TkpWN6+xo0XrkvTlwAMF09Kb4KE/b6UgnvHX1NdPQNDJ0OCp0JE2E9A8ynaIjA+rhQy3Tq
	XCL6alW6QOX1+aHgiYT1PS8HQCdEtPI/gQj/AyhgEf2i1HGK/vJq/mDuh8gtXQyIoOiJnI
	gvv1EA+B5lj0XWU6+YW/EJzRTYOKcGg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ETV5QP/t";
	spf=pass (imf30.hostedemail.com: domain of 32UkKaggKCOwXOQYaObPUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=32UkKaggKCOwXOQYaObPUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779059163; a=rsa-sha256;
	cv=none;
	b=TKDfmm+qfv4eAY1FkNzuA3PyhyuYBgwvvEdZnbsp3/5xU47+wQyt3IBhfhgLsAZZWRwPf1
	PmxcqAX+vWahnsa4r3WiDYkdgdTs8ZztSt+q1AuuNe4BcCP7n980s0TDrHgFyMKTLxBeEM
	Dkjvg7RbUw8vO3SG8VBL6eJFKbxIdIM=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-45e78dd7baaso468046f8f.0
        for <linux-mm@kvack.org>; Sun, 17 May 2026 16:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779059162; x=1779663962; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RucpAInGrAJfsY0XRVsWleuNH9XqB7VdVnWXH3TZFzQ=;
        b=ETV5QP/t6ixwSDMbGwhs2q2s3HErPO7ksUmMC0+L9fN8qH4LTHS90J7yC3mHIyP9gx
         DqHrRb8Zi9WIfX0Y6SCmTqAUHCvDhMTCmANlxUar7n0EASWkuJe8p1RKlg4kXpJHPJnK
         TM57jcl8G66FA812Zfpv8DajdiVkRloO2QGOw15ZVf7qQfpKG0yb84quANqD5kj3LHhM
         XxlES4asMbf/HdzOpOOc2aX/IRSD+iF4yxDVjOVq+49wdsbHZxOLs93x9f4CbmB8Og8v
         8umArn8wZIfaoRWTwA7a7IeDKj7RHLmdYrwh9k3Png7laYeO5vjaxYueoQ/Ef3UbjnqB
         VAIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779059162; x=1779663962;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RucpAInGrAJfsY0XRVsWleuNH9XqB7VdVnWXH3TZFzQ=;
        b=MzZO8TTo2NHDejLMEwLcf9vraGJRUZrEl95+bSrJJsG/wOLLiSD5TAEMN8asIx3Wt5
         OaXUqpwISr85N2uoNegF+nJkg5kXdNDta8txac7sT+JItb/HwqsY5GUJLniuqBOzSzGz
         YqBgws1dKQSYyEuhAzTheWY2WkBWmshboGtFnxlBE+IrZolYM+dDL+mo1xnYPqr6kk+R
         vv3gaWMKZRdhvNbrPALaEEO9oxFNPZFUJ8i8RfPZ8YQ24sJdoGzmJa1a9/SM2Brxjq6n
         Mr25tdLykx76crur1qc8SLqtc/SvFfNf9WDvee1bWbnMDbCsXF1Y4StBfQ1VN1sykOkz
         8EoQ==
X-Forwarded-Encrypted: i=1; AFNElJ8pOQDawE57u1T7wNleT1zPM4CJ9x8uzzQShemc9uaqra3dHI3d6KyeF0iw+K7T71P7yw3SgvLb0g==@kvack.org
X-Gm-Message-State: AOJu0YxNoiFVbbnYZEUEg8qpxlB7h5Y7h7B1XQYoS4hTc66mrmO1ApG5
	EhdPTKYL2JHGJ0dXJJeTRoHmC5eXwxeNFtYNh4JEUjYx+xsNmmnU3Hn1hatiGZ02THj7zfqCisn
	vrU/oArj4H18isg==
X-Received: from wrxn17.prod.google.com ([2002:a5d:6b91:0:b0:43c:f700:880f])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3e1b:b0:48a:8905:a500 with SMTP id 5b1f17b1804b1-48fe60da647mr202718675e9.12.1779059161517;
 Sun, 17 May 2026 16:06:01 -0700 (PDT)
Date: Sun, 17 May 2026 23:05:56 +0000
In-Reply-To: <4074a816-9e75-45a6-8141-25459bcc106b@kernel.org>
Mime-Version: 1.0
References: <4074a816-9e75-45a6-8141-25459bcc106b@kernel.org>
X-Mailer: git-send-email 2.51.2
Message-ID: <20260517230556.590677-1-jackmanb@google.com>
Subject: [PATCH v2] mm/page_alloc: tidy up pindex helpers
From: Brendan Jackman <jackmanb@google.com>
To: vbabka@kernel.org
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	david@kernel.org, hannes@cmpxchg.org, jackmanb@google.com, kasong@tencent.com, 
	lenb@kernel.org, liam@infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org, ljs@kernel.org, mhocko@suse.com, 
	pavel@kernel.org, qi.zheng@linux.dev, rafael@kernel.org, rppt@kernel.org, 
	shakeel.butt@linux.dev, surenb@google.com, weixugc@google.com, 
	yuanchu@google.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 69C3C8000B
X-Stat-Signature: 6xb48u3ifoku5d69gikf3uaythbmp3ic
X-HE-Tag: 1779059163-390840
X-HE-Meta: U2FsdGVkX1/nRA7R2gCcP47Rc1jpgVK9mEo/+R5sahna2qtjgxFIj9TnEiyWb5i8bRptiwYIk1PFZyQrgQdtpB8UPJLWzrZ1tpLpNqPohkp7SW43Oz0PVl1yEdEzS8LSoOqFz6e2engjXJusvSmEv3e2R41y1q0Ag8ELBElPpbMhi9IXYuDAY+bI9+xuk4kxftlmWQdVPtkkG1sLukazABalXVoUWPeOQg3Bv04RL5MNgK97Sy/yIrX4Mw3V3N2eKism25oC32IdxSNuA42iAh5Vj+ar+WqnrEzLcNU12dUtYhAZUvVxfORnxqfDYB3wXVLVS/FmOgQrnGU8Jm57nj7QjXQQOa6GL+aIcc6qv9a22GMWYUMBSHlZ3h4UQDddUXniFdrAsp7yNwY6gEg8j5ku934bRQUXySCOYUz51JOuyY6I01+CW75yUeeh77r4SRstDc8x+LxcsiNmhXpEsPG00QpuAVxfoTV+hRB+gz99amC56PogQU7twapkYVMqa7TDRRXIu+PAzxKnkxhiEUWGAx8FE4Ahmx0zrvybkqBLbLMcHdSRDT+PSZPq8qD9/OF+BPU+m7vm6D0Bjsh25ki7oiXiQr4PPvz3TygKOkrIXaNyzbSH8IjD6ZMGvwClxCEXEdBIllVJjWiKi3FhqL3JP0Zlb8jpONQR9hi+Nb0TMQfXQCA4ENq6Cdp+ZcgZyzlXpxQL2ueCfSX1s631QABTYbT0INC4brGoPIEzOtIH+MuOEGehux6j9P/j0uFl2CJpYF4vo9kEpyYNYlJwo5gMrS+rAVCrQX8frX+nuILGUtVzoPKImGD6XsiYwpEOwVKkzU5xrr5nsxuRR72o4F7wu11l24YzHw0ca7F2lCJKZT5DOEUUCJn//P+UYidsGlHwuLTPIpV8ysIfl4pnDWj0IWTnAcVSp7OEVsojdhDrGa4f8oK3NONu7gWtnHpYJ65zjPVWz+agFjJg8i6
 RB7jUXxr
 eWItAlYEXa2PqOM+XobDn/1/89Ku+FHjsZWzPXCZ5wm8P632+2mjGF7lgQWhtrjSRnNuMdvoFjb0o2scT7BeekfttA/bzpekggd7SheZ8olb06iSpIRcMSU4HE2LYhtuMGQvfFQVtCA+Icw5ssSMoEw0iZRJkFaYL6YnHcMEsqv8Bl/4SImGGgLZQ/QbD84n8XFcP4+iISuNl29QbEF3+3B5v3kgEJrSfXw1MJrxELe5ZhA4HUeeP6nzDhNswOkIxi5SKDHh5WV2u6Cm3JWqJSfeyoU/wBYJv0R0sdaKXRIU0jcMgahClD3Afl/8myclGVzmPVDJYQFup47YsPKRNYtNvXhXW0t06QqAZ3cJe2U8a/V+35SdRGxH7yjcwAzZoEe0wHpf5WaMrNYJ4LXEUbUah0U8pCpBZiP/i+bltqJp/q7OkZcg/EZnhmEEvQsSXGibo3K2AB0MTf4I6NWzMJ04hVvSDDa+cHkJBNSWNCRwTW/La/9/bJ1K9Mt22hp1gCkposwFj/CdKibIr4RiUE4L1xgdaIXgLHtvSEjx0zgaNOhEfru4RkALh4UNgXyFD+u4Rri7C5jbhZ5K0UDTh0oWWveUSUnpH8dWH7oN+b/inWLzvbqgUyp6PsaCNA3kiBUF5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The ifdefs are not technically needed here, everything used here is
always defined, so switch to IS_ENABLED() to make things a little less
tiresome to read.

Also, Vlastimil pointed out that the VM_BUG_ON()s have fallen out of
favour, so remove them.

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---

>> And it's all internal to page alloc so I'd just drop those checks
>> completely at this point.
>
> But, I won't die on the above hill, if people really hate BUG that much
> happy to go with the flow.
>
> In that case, I'd suggest we drop them as a separate patch.

Oh, actually no, the VM_BUG_ONs were the main thing making the ifdefs
awkward, it makes sense to drop them together. Here's a combined patch.

 mm/page_alloc.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5d6144c8860ed..76d5d9464e2ef 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -650,19 +650,12 @@ static void bad_page(struct page *page, const char *reason)
 
 static inline unsigned int order_to_pindex(int migratetype, int order)
 {
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+		bool movable = migratetype == MIGRATE_MOVABLE;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	bool movable;
-	if (order > PAGE_ALLOC_COSTLY_ORDER) {
-		VM_BUG_ON(!is_pmd_order(order));
-
-		movable = migratetype == MIGRATE_MOVABLE;
-
-		return NR_LOWORDER_PCP_LISTS + movable;
+		if (order > PAGE_ALLOC_COSTLY_ORDER)
+			return NR_LOWORDER_PCP_LISTS + movable;
 	}
-#else
-	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
-#endif
 
 	return (MIGRATE_PCPTYPES * order) + migratetype;
 }
@@ -671,12 +664,10 @@ static inline int pindex_to_order(unsigned int pindex)
 {
 	int order = pindex / MIGRATE_PCPTYPES;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (pindex >= NR_LOWORDER_PCP_LISTS)
-		order = HPAGE_PMD_ORDER;
-#else
-	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
-#endif
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+		if (pindex >= NR_LOWORDER_PCP_LISTS)
+			order = HPAGE_PMD_ORDER;
+	}
 
 	return order;
 }
-- 
2.51.2


