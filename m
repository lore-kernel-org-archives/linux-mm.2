Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5785DCA0EFA
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 09:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BC7C8E0041; Wed, 20 Aug 2025 05:07:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 346F68E003E; Wed, 20 Aug 2025 05:07:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BF438E0041; Wed, 20 Aug 2025 05:07:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 060168E003E
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:07:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CB46258F5E
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:07:47 +0000 (UTC)
X-FDA: 83796558174.29.9D49E33
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf06.hostedemail.com (Postfix) with ESMTP id C0E75180010
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:07:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="iB7/AV63";
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755680866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hp0aqN5MfkEUvcDi4Uu976xMEqVAADqjDiv9jyT1Mvs=;
	b=qrd2UD1BkU/gnlzZBQjnELU1hfVz1G854S3s8DzBq7V2NX73khI/J7S66aFKC3gh+MHYsL
	C1j2EFigFNWw997O0mwGj8tSCv2D7L0FZDx6rx2Ue/fhohucRWVTak6Aw+npDN/v9vBxxr
	1X5ZxnJdskj2VIdXELvflaMFsREuHVg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="iB7/AV63";
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755680866; a=rsa-sha256;
	cv=none;
	b=YcwewW8sV4IxVtBiaO1jf3d7DbBbbhKYuhEJjYpnRC2Y3nK9d/cHSr7+LQDnLFHjZvBLXy
	gJPYdF9m6DVbktOkU8F1dWTSlp9N2kyAIe/63hspSF9MsElZ/aUHZHw4VNKStdqBeT/6nD
	Bu8OfSdXN9sFj59m+8JSz2mubDcVy3Q=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755680862; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=hp0aqN5MfkEUvcDi4Uu976xMEqVAADqjDiv9jyT1Mvs=;
	b=iB7/AV63AA8lqUQIyEjavD5wmP0B6PLbj63ZW1wb+rpqlwVk1YiXck6nRJZa9FFB0ktYW8lirdxxY8XMuOTtcq+2tVvBJcmAvHrW+wNG+aznypDdmesU2Bd7Bcg7mC4WnW4TiNyT/3uF7035qX8UtlcLhosu3O1jMklZ3ivbbgs=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WmBEsC-_1755680860 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 20 Aug 2025 17:07:41 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 06/11] mm: khugepaged: allow khugepaged to check all shmem/file large orders
Date: Wed, 20 Aug 2025 17:07:17 +0800
Message-ID: <4cad4cded3f19c667442ae4d89ec03452c42a7b5.1755677674.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1755677674.git.baolin.wang@linux.alibaba.com>
References: <cover.1755677674.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C0E75180010
X-Stat-Signature: mfsh9umg6kspn7j7pf77s7zhhyfidmh7
X-Rspam-User: 
X-HE-Tag: 1755680865-768692
X-HE-Meta: U2FsdGVkX1+oruV0di8Aj9JY5fs5Xs/CgKD2CIySg+yANSYN5EsHU5gnxyxHJkNXHTAo15+Um/vQG4QTGuYs7Y9Jez9KqdNudwa7baTmvSaOHcSad0U/AAU/G5JYUTkbijCgy8KmidUSczC28MfuFYKII64/UbE4Z8fgmbNuhnDMKDWWisbl1u9Kj3Gk1SAuWywueXSJIpMRb+1WeO2q9SYSuR50kz4KUENrrk5tz3QrQbHocn1i2lyc0u0WHcCGOFlUTUSb2R6qw6ReDb/FwoVpp04QEp5+LuggUDvhhTbFzr+69PRDfoFNf38cJlWyRYN0ljuoFtpg8Dc1S+f/sx9q4WbnjJS/q/jv1WLsijQIJB7SgZ+znAMBCwSp9rekUmpC11v3EjtAhNM8DMzOlxbhH4vE0NrC1luvVpoqjxT6NGCorDxJZ8/h8Em/ZKINLc/CuwI7qeN7CPeF7Ey2vFjcRq8e2zLIaVaR5gpBvMUbWtj9rTaZvS3TFedeNM+f9pfGJM1BUMGBO+NsPGZPPbkPEHKESSL64VsdonUiBBBWhf5STpjDPEOGtkeyMCOcIUFgU++zAETbh3b7tPIilKo8WsT+/9NQqre5DGLDtCBQQZJmk+9kOFM5jq2VbUnDBvzM/10++JkK+NHm+UVoW69ovw7wZ+FNcIgoiDQ3tRbrgkcFsrhEKhqTWlAawYmOapaqPsiPG9PKIkuuNsT4B0CDNsxj2rpPS5bJOLu6GhTYNS/TKuVRP9ckDqR1mvk6tQYD50cdgvT19vuN/EosGPK1TqnrB3m2lSRZ48mn67bdHHAC0AF6QobTbwJOWtDRXLZopxG2D8scoN/lzEcpu5JgLXduTy0ZpxJMWcGrNn223XO/tkrcdgfx8pSBJO7ZVBvFJOvWMickKVOTpLyuxqTb+nH7h+5Jip5/jPF+ZBcc9SRMLdx6lRw8Dz7ZEGpFJchtHArydnVS5F9U4Sw
 4Ql8AFuK
 ZSol+amC92rsOHIccKos3MFujfXfcZjq6tUig9kpJqGXmPZRW+doJj/InxNC+xbgC6g0Yym9AB7VROQzu96x6eTFAEkx97sU0KkOVBPghMMAiz6Yx5fwPxUqb8T1NGW274YZjywwkd7+x4zTZsTmdj1JrMWliuudFco7X+ZtsGqn1nk2lKm58fKp6PxRMjwEXPibe3dz5Oe0QwmGgSIUtDB2RcGrUXfBqEgmOoHaRxXeR2uC5ZhgRm0stsjwCorKm8bMzXLIcUJPAKf2jYMMueDCeQcVgfD3fz1We
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We are now ready to enable shmem/file mTHP collapse, allowing
thp_vma_allowable_orders() to check all permissible file large orders.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/khugepaged.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index eb0b433d6ccb..d5ae2e6c4107 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -496,7 +496,7 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
 	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
 	    hugepage_enabled()) {
 		unsigned long orders = vma_is_anonymous(vma) ?
-					THP_ORDERS_ALL_ANON : BIT(PMD_ORDER);
+				THP_ORDERS_ALL_ANON : THP_ORDERS_ALL_FILE_DEFAULT;
 
 		if (thp_vma_allowable_orders(vma, vm_flags, TVA_KHUGEPAGED,
 					    orders))
@@ -2780,7 +2780,7 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
 	vma_iter_init(&vmi, mm, khugepaged_scan.address);
 	for_each_vma(vmi, vma) {
 		unsigned long orders = vma_is_anonymous(vma) ?
-					THP_ORDERS_ALL_ANON : BIT(PMD_ORDER);
+				THP_ORDERS_ALL_ANON : THP_ORDERS_ALL_FILE_DEFAULT;
 		unsigned long hstart, hend;
 
 		cond_resched();
-- 
2.43.5


