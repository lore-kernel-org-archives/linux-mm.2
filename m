Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C67B5CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 06:57:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B6616B008C; Mon, 11 May 2026 02:57:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18D6C6B0092; Mon, 11 May 2026 02:57:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A5D36B0093; Mon, 11 May 2026 02:57:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB1246B008C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 02:57:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AAB18C22B7
	for <linux-mm@kvack.org>; Mon, 11 May 2026 06:57:16 +0000 (UTC)
X-FDA: 84754232472.16.87E192E
Received: from mail-pj1-f65.google.com (mail-pj1-f65.google.com [209.85.216.65])
	by imf10.hostedemail.com (Postfix) with ESMTP id BEEA4C000D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 06:57:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XbtHMeVC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.216.65 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778482634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/auCAYc3tqtPlVouFd3THFrgX5QomuOAeoe91SPdmuM=;
	b=YqyHnkGf0uKkZR14apKjvP6NcZxPQKs6QPevfmRnUIA5GG7vmRRFOw6cuEDj71Eaae5/Vd
	8Tga4soAoZ+TcnRr0ygn8zK/OVeU4xlzukKdmDEc1UlVcKV4E35Q+064x4bs59rGMTX3wp
	1HRWhOH1UacNBBKvKoW1GBZRz8HqJFo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778482634; a=rsa-sha256;
	cv=none;
	b=H/2oVkFCzYwSZrFTLWk9GySIa4lZB6ssDWYg3MdRDnao1S5Dh1wj8w3OKFLhEBtVXl8i1d
	/IgSNhXuwVGMEY8LF7xxzTx7oofZpjgXXdUMCCfISbO1kmS6yRlFuZ9q4Uf2Y0m3U9vDuk
	5wsWpkDIkdXKaYhJXJPgPc61sT/f/i0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XbtHMeVC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.216.65 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
Received: by mail-pj1-f65.google.com with SMTP id 98e67ed59e1d1-364f7c42c62so3244234a91.0
        for <linux-mm@kvack.org>; Sun, 10 May 2026 23:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778482633; x=1779087433; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/auCAYc3tqtPlVouFd3THFrgX5QomuOAeoe91SPdmuM=;
        b=XbtHMeVCeCOlM4QHANp9Q14gA0K4+0Zo22A1tmJnefhblmu0o12IMNHViHGv2O5o7S
         fskvaBbIcE8biIUMh16tuiQDLRTG20PjHM1j3ucvDl5wXNlv2oCA5DOj4EdXMdY++3fP
         lz9K6YG74iDgn+cbBKVMYhDkDzEkm3kEizg7amLuZMqq3fP205IinMtmRZ7iXHb4R//6
         C4EZKGCZSwW5nKqT5c9op5rNCatg4J9Ns9tQZcfwCxo7xKtQMjH1iPhHLTJlpNSrhbBa
         EeWtaqKccQfUl8ZFQBzn0kSWIFjbpny3Chn0JgfaAZ2MrGJ/L+svr6dDWvwbY9W4OAsi
         WiTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778482633; x=1779087433;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/auCAYc3tqtPlVouFd3THFrgX5QomuOAeoe91SPdmuM=;
        b=RdJQebH33GZ3Zv5UrFwleziWMa22Kh+h4pXEDRdUw12wZlZju5gu+Tt8XtGK6EA0sY
         1oCQoVtIk/ef6VDmijvpQd1HTvETlnnGflHoZmMmPkt1qG1+eKsQzGonwdAsa+TvH80t
         klbkDm/0y7K3tnsnFXLhW5qJ8AnZ2faOZ2jyO0L1IoCdPgGgII91GgmlkkpXMXL9nRgg
         fIvoPELOT5WDRu4lHgQvNPHfjNwAG/Qx8kYlpCj8Ov9xGDEmuwQR041ha4qo5BfIRUFK
         58ij3eEyovRFZbpoyYUu93dludNEjwqo6p0CisTTUbrv9btP9CzU1lHfr7sttDiJl4hv
         nzMw==
X-Gm-Message-State: AOJu0YycXZQhFCgKHBrx+1el0TbCb8PMwemNf8AXHW++3ee9f3lhqp+i
	0PreWFPBI+prF7nbJVDpR8xQQaMkg9wWOKBvjTRbRH1TBeZhFhgwPeXtK+FQ9mHajo7fQGaG
X-Gm-Gg: Acq92OHSD6hPG+0nAV1boPjJXZEHqHC1TXMdaxj/6Nucao74lCJzdM85vlkZjq9+dB0
	xkM/ywwLtMP1jZyiJl+hAfyyR98J22Zs2Ah68PhUihLsXRsfrnXFn1U1IO+v6GCLzV9ettRTfFf
	RtbgL+2QSNY6o0MqciCiyA5tlNpQzo9cTxCLysQSFEiX84Xf0lhU8JBduzWCcFtCscmeIc9MUuQ
	PlDv0mRZgWVbPuxcBqDyeruEB9Ckytcl9WZ4+NYz8CEb0QUD0mLplkuK2TPhpFK7blf0akI9p4s
	1+mFjIxR9Zd5dc+tQ+o6DzxoaIRB2awusDTNDhB3vNdlWhPr5speYVXoyGYx9/kgHXuIZ2OSv8m
	9YHlezyYxkQpc4TtH3ekZBYeZw4LqubEJ/u4dfDiYYi7g7wltj0EOwcyhurcBaR+TvFnRyDgY8g
	uDjj4slSkZJFIdyMUO5wg95TRtz4Pfg/pSMXJ13g==
X-Received: by 2002:a17:90b:1647:b0:366:2e1f:393 with SMTP id 98e67ed59e1d1-3662e1f05b5mr16136827a91.21.1778482632783;
        Sun, 10 May 2026 23:57:12 -0700 (PDT)
Received: from intel.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-367d684009esm6708662a91.11.2026.05.10.23.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2026 23:57:12 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
X-Google-Original-From: Wandun Chen <chenwandun@lixiang.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Subject: [PATCH v2] mm/khugepaged: avoid underflow in madvise_collapse for sub-PMD MADV_COLLAPSE
Date: Mon, 11 May 2026 14:57:01 +0800
Message-ID: <20260511065701.799006-1-chenwandun@lixiang.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BEEA4C000D
X-Rspamd-Server: rspam04
X-Stat-Signature: hoezeih1kojfg5eghj6wotd6gq9wucgf
X-HE-Tag: 1778482634-455230
X-HE-Meta: U2FsdGVkX1+R1wKjx27kBjdcqo490RODwrDq3j027qVXJwawvYShsBAoThgz1rWvrSgQ3rJ2EFAbFqmN8PAXmzDlNyh16sq8NTIVMBTwDDPJvJN7LnLZMb90rzYcAFddMG4K0HlAwvbYxrBRbwShfrhGqeKx2Cbj1tzfzrGr7mMpm8PtljIWag+u30F6C6x9xRwY3dS4ofPyEQUW2ZXngZ4UhpSmjDR6CgCPHanzQ2hDZXZoqXnpO2Taq/gbibC/aNs92vSxlyhbklSRI9NUS9haCbOScjDqyOW16TAAFRhCUqqHtgcONH9hxOjV/BoV+7XrR5Lrh2r5uB82pRMgn1QBBqUSIOYTOPKF80TnMJXJxncr9OIJgImSTvlqTjPP+O2eS/qE8eRPaKhjKyWOkm/R61uTZOk00HvP668QDcc/bh3EfBbh0jC1dbqmSBUs5pJPCudpXH24GrU5DuLY4JESkRKH0cRUIso4iJ5AkylegDeEZMHcuukgsT5ZEf1q+PrCzozVxbDveGXS+rdRnR8QfvLZJVXtNUy4xxqpckzVsQdTzEQTpT7IANOzXOfQk2zZyz7Igq4/a1+oy/RbXE2h4bbBPdTXoD3MOIdorm4P2VAC6lxWu3CxoCrwHSTGn87/iGxLo6Zs3jRirfq9kqPTgsiiLYDDvFksn6OwX1qlHUFDA+3doBi1qdx6A3HHKqvzZ5uFNxpsfH1rUJAzTAtpFEpAhl6KgHMQiI/I1MwNQA4FE0emZ1HJwHwVH+mVkDrdycyU4bjR62r56SfmSRwxE4sr7hRpvZb42P7muNS5yXSADYcUCTMBsBmEAzT3DzTnJGRfzq0Ic3J+Xja6sHaHDsjmHmW46w4QPfabdQ4AdLVMABsE9BxvoUm2ueFvssx2rrHw97BWQv2b4rQRfYzIpxTvSTgggqJ8PUv4TvOvKO80O2yoRc/WsSac8HVyxzTxDaPPrNXTrY6pM1D
 W1WQenIA
 Do4pTG5oqbM53amx7Y+hsN69KKi3mFKKq+zwN0PpZOfYPLBUvBemadbPNwFNNbkI0dG9SPA5VjL3TwF0tZSo+2KWY9rlDamLtuohFlz0IYcrS/z+HPr/aLu3HKb4KWCTSlw9hvTQ9HJj14YAXXn2TpeBqF/9ncGFASY07poZ34NznLFmT/Lvwmn7fx38VxuiUViR8oRZp2HKeVeWeUNoeQrY2x3ZR5tRojk2P3WpU/8O1ODE+ZtjcWnvbSyr+fygrUWa68/Y7L5Yg6UsEz/1L+r3GIi2jfHAXcGwoTMaUyC80KAP5IQnP8Qzi2pDdhod7zxRfEgUe/4KQj5NlLm+SR5/0AhdnWGiulClc2eb/X1RMgorkP3Xp+uApFFlj9/S9gWFeL0WsMZ9KFpUmsJOUUD5OxTylb4f50MnmHuyi0l5Mp7NLA/GbTZsGMWuufiF19FCsuMZMeKvjCA+9Y0zqmIDxCzSjEiGZIYufQL4R4oGhT/S9a33/d868thLOAEhg9nGRwYXsSDpyY2zbgqXH7tBXs/KTx0dNlPEmPwGe50avGL8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Wandun <chenwandun@lixiang.com>

madvise_collapse() computes the THP-aligned window:

    hstart = ALIGN(start, HPAGE_PMD_SIZE); 	/* round up */
    hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);	/* round down */

The following case will cause hstart > hend, and result in underflow
in the return statement, avoid it by returning -EINVAL early when
hstart > hend.

    madvise(PMD-aligned + PAGE_SIZE, PAGE_SIZE, MADV_COLLAPSE);

In addition, kmalloc_obj(), mmgrab() and lru_add_drain_all() are
unnecessary when hstart == hend, so skip these operations by
returning early too.

Signed-off-by: Chen Wandun <chenwandun@lixiang.com>

---
v1 --> v2:
- Rebase and resolve code conflict.
- Return -EINVAL when hstart > hend, suggested by Lorenzo.
- Drop Fixes tag, suggested by David and Lorenzo.
- Updated commit message to be more explicit, suggested by Lorenzo.
---
 mm/khugepaged.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 28a843f30b32..36baab17f098 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2837,6 +2837,15 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
 		return -EINVAL;
 
+	hstart = ALIGN(start, HPAGE_PMD_SIZE);
+	hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);
+
+	if (hstart > hend)
+		return -EINVAL;
+
+	if (hstart == hend)
+		return 0;
+
 	cc = kmalloc_obj(*cc);
 	if (!cc)
 		return -ENOMEM;
@@ -2846,9 +2855,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	mmgrab(mm);
 	lru_add_drain_all();
 
-	hstart = ALIGN(start, HPAGE_PMD_SIZE);
-	hend = ALIGN_DOWN(end, HPAGE_PMD_SIZE);
-
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
 		enum scan_result result = SCAN_FAIL;
 
-- 
2.43.0


