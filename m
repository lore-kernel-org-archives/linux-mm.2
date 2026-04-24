Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42BA6FED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:16:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B2956B0098; Fri, 24 Apr 2026 15:16:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73BFB6B0099; Fri, 24 Apr 2026 15:16:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62B6A6B009B; Fri, 24 Apr 2026 15:16:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 38EAB6B0098
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:16:55 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D934E1A0206
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:16:54 +0000 (UTC)
X-FDA: 84694406748.22.9120EE5
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1A07840004
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:16:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="wKRLG/3O";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3o8HraQgKCCwabMdMVaLOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--stevensd.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3o8HraQgKCCwabMdMVaLOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--stevensd.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777058213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1KThmIRA5a/VHEqSyhfTRNnbsq/aoBAcBxWfiBbrQ6E=;
	b=BVQYCbd2SYc+CDvgujvgKkL8GteJL2r72z54Vk2xmPy7fYT9I/mpoworKfFszAAfhQmlF/
	l8mIB96SUFIODoO39EJQVQ99HyLAzW7vyCbuFNwWi81i/q8HzGCyHuOdmTs+gDu0L+P+fV
	yVx8BNEsYF3oQ/R5TGxS3VViBdELyKg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777058213; a=rsa-sha256;
	cv=none;
	b=zrvY5CTPjvKuJt0+8I3Pnyim52eP4y9UZafLRE9Yjt7LYxwZcKsPnr8qlL41oyi0smYq8E
	Y5BhmWLIprLxHzylSEYu8mpW/4HPE+XaCpxfvwLmt+nSU4FkVTy+qKL+ipZ3wqTp+OlGmF
	rOMNNYYFLhbTlaVjZ15Yfilfm+Jzt0k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="wKRLG/3O";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3o8HraQgKCCwabMdMVaLOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--stevensd.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3o8HraQgKCCwabMdMVaLOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--stevensd.bounces.google.com
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2da19227bc1so17661139eec.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777058212; x=1777663012; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1KThmIRA5a/VHEqSyhfTRNnbsq/aoBAcBxWfiBbrQ6E=;
        b=wKRLG/3OAlazhAImszjBT8KnZ16Nl+Xvkwp5srV/NfMZRXjDK43Q+V75bicT1YIDpK
         hEEUyJ0Z+DB8ntume8Qu9dkva2MkTBir/sChiemimN//F0GMAmJtu87/u1XhmX5XeXvA
         70QrBaoYT7ee4IZTEAgK2OFuHbkT9Cw9wBM8zv6lEfPBKu/tNR0A3n0+yeKXAYi5I+Hu
         uMI9KHWP5Tg4ZGrf0ae5HGkNaU9tmduJru2E8DVu65vbIuGr2C83DCoRXjHEwhr0qo97
         vVLLZK3WaJy6HqhD/WcBr6mC3CoxH4OFzLRy+r6kefcsRCfDIHUI5M0zO53Tc3SLs9v8
         tV+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777058212; x=1777663012;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1KThmIRA5a/VHEqSyhfTRNnbsq/aoBAcBxWfiBbrQ6E=;
        b=BLjsYCQnp3zquQ8jwMFUSgyGee68sSWAOEHUkUpR7yYdBCO7zI18Otws0dhYhNI1ZV
         QTySrTIqQtz9ohAiECmolXNi8wWu9DHb36L+LiT4F4rgghr+I2T25v9mraf2j1DY4IO5
         +hGqeM41L5pf5vn0h+UMdYZnxPS9L8jOuPBgQjMBGAeCKfk8tMF/IC0NlJi6FO6SoI2W
         DR607Y/O1L5KzH59x9jW2Lar4dtzu6w/VPgNko6T0uCIbutsT3i0S1v56QLL0VrC4Dp7
         voOlsnnbXvjw1AmY1gMUDa9Av7YOserQw9eNSkZmec6NEA6q3vuZCbYC4WT8ux0KCgZH
         Og/Q==
X-Forwarded-Encrypted: i=1; AFNElJ92vtHH1s/hlEy6BiAurQTObTkkiBxRT3wSdtyZqqEZYvFL4gZBx6gXFv9YVNXUcQsJKBlUJaX9QA==@kvack.org
X-Gm-Message-State: AOJu0YwZORql+8OFZpEzWlRckR82cvubtIewP2PAsILXwI/lm4eKOYUB
	uWKeklHVlmScyXWzzdN6Rnfjwr2KtjU/ugbhnHrF7nORKq0SiTkkSAPQyGXjvkMwGq37XlGlYO0
	dQAN3pTYygLe0pQ==
X-Received: from dlae7.prod.google.com ([2002:a05:701b:2307:b0:12c:211d:3e86])
 (user=stevensd job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:eac8:b0:12b:ec96:c936 with SMTP id a92af1059eb24-12c73f70bc8mr18556370c88.14.1777058211531;
 Fri, 24 Apr 2026 12:16:51 -0700 (PDT)
Date: Fri, 24 Apr 2026 12:14:45 -0700
In-Reply-To: <20260424191456.2679717-1-stevensd@google.com>
Mime-Version: 1.0
References: <20260424191456.2679717-1-stevensd@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260424191456.2679717-3-stevensd@google.com>
Subject: [PATCH v2 02/13] fork: Don't assume fully populated stack during reuse
From: David Stevens <stevensd@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>, 
	Will Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>
Cc: David Stevens <stevensd@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1A07840004
X-Stat-Signature: zcg97xzie5b3owsccha493gwouetxsb9
X-Rspam-User: 
X-HE-Tag: 1777058212-255274
X-HE-Meta: U2FsdGVkX1/fC7HVTkGyzl5sw1qymACVABIRqdErdQfyFXMJyvvbp+XtGHpySKpQMiV6quDWCrCPgqnNofrKAn61Ur9buHHxQoRsEINvpXh3ZDY4VyADRTR0F4mgfiyYeLtpY+6piGsU9Y7GxGOQrrcH0crQmlq+x71NDezB2K55/Wfbhq3VMXF1EWET+8Z52DpgZqyVWfcSffk2wksR7WYVPzrPUBvTsi8yKZTKf7VuPu6DXGpXSMCAiP5Obe9R6WVLGpbtni2x8QzZ6JalnPYhhZlXkPNEB1TSopsO4Fiv8SW6yp3aIeOyf/TalamZkbbfoZGTTFFvrLvfQj9dqMqg/V8H4UsJE8rc+wGnQZs7hjK5WP25rbKxOhpPeQpP5nJHNBhbkwm2om+XAVG4ofatMeWyERlNU/rknzAvJ05mu8KUSKnHQCxmzzO2mznXKn40wyJeyUMrdn6wCuptRxLbh6y/wg2WOjz0UJ1ivpGQ9L3m3juD+umysSJBQYEuy8Uck6gnTY0HYgBGrM37A5q9Lw9HjlYMpkLzefdmNm56T+Z3iGVcKZ6qXHn4arsdU84ezQO1s826mLP/2aachacVKz1JXYizU/hLcAjSsCjUD4/uoOzB4hCIaUFWicuRD+g7bX4prdTQaYOL8tCe8jpEAlCQqG3dc89qp5gfDaIX25cRm7D8JxMrN7VodxIFe5EIwu7VQPOjpMtU9r+zfldauseVq4RiTGWy4i+MDhNBebx3EDlmIriil0wIEC3ii809juVE0XpicbqDPJYo+fqwMwS4lAfmgZlwTzdICSQBC0eDal1rOKgJ3GY2lpuEXM7ilXy0KdXwWCNc5fM/GrROin+/im1RA+olc7cLTNwnfF6CgdVsDZaLe0n3RryjlCDZfD9Pqd1mGnf5d0ENnQa8jk2m6YpeloZibskoFDQLIHcc6gFScZlyUi308B8R9cWRVoKRrchlMD9QQB3
 lbVUFmFr
 zqRJMCdjUzUrWuC4J2sBPUyo8VggX0XUzVZt0KDgm1iRsdFHyQg0aOAz3WNr7YRKu7/S2KVlQ0LDee5Q4LIuu6n+HLdeFWQWuKe33Iglr3H7FeNZqdiJj44ThDx9lrtl+sQBZR4Mhz9Liv5Vmtc1f3GBzje0kUkfPi1tTyvyADkWFd/zVnBY6ocF5qoZo9IP8R6/36PcZvfbnmHhs9jFDO1dp/s4xVbchjJv8x5CZAJJGzohsx7dWdPJaAX/qytZAFgYDoLYkq+WKe0ExhHvPSD+VQB5A4Pb26cOgG2vHHs+Z77mk8NTpK8BK8N+/8k33rvXWnRhSa0kWFY5T6uRi7LJtMBbi2NwFdcJcGH99wZxlBe29vnrnHvtXljSX0Atri0GiR3DNuxtKc2e+QOkXlm9gTD2ekgoFsSJT8PM7cmUmdvcpmH1PFP3SlHBezQiyg7/UZodIgPN6mQ0TatyuFV9S0OyD/hnHaW3Tt6AUJyN7x2IdDUNsef/Oj//56l57oK/NXDKArtkB1Dd91u4d0GwAeUqB54YiaeVzmEfcVr3QBnWCEmZZYBAJpZUKgmKZJZ+qZYOlFVjoTFwFWQlEGZr5zsxUbzHytP+MrSFxQcWiJUxJQog0eH+KD8G+XM1awMCFrl5wXdcw64o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for dynamic kernel stacks, don't assume that
vm_area->nr_pages matches THREAD_SIZE when clearing a stack for reuse.

Signed-off-by: David Stevens <stevensd@google.com>
---
 kernel/fork.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 8961b895bf05..50772c0cc5da 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -332,6 +332,8 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 
 	vm_area = alloc_thread_stack_node_from_cache(tsk, node);
 	if (vm_area) {
+		unsigned long memset_offset = 0;
+
 		if (memcg_charge_kernel_stack(vm_area)) {
 			vfree(vm_area->addr);
 			return -ENOMEM;
@@ -343,7 +345,9 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 		stack = kasan_reset_tag(vm_area->addr);
 
 		/* Clear stale pointers from reused stack. */
-		memset(stack, 0, THREAD_SIZE);
+		if (!IS_ENABLED(CONFIG_STACK_GROWSUP))
+			memset_offset = THREAD_SIZE - vm_area->nr_pages * PAGE_SIZE;
+		memset(stack + memset_offset, 0, vm_area->nr_pages * PAGE_SIZE);
 
 		tsk->stack_vm_area = vm_area;
 		tsk->stack = stack;
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


