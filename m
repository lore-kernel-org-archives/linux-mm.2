Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54304EC01DF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 12:25:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA24A6B0089; Mon, 23 Mar 2026 08:25:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B529C6B008A; Mon, 23 Mar 2026 08:25:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A69536B008C; Mon, 23 Mar 2026 08:25:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 961F86B0089
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:25:09 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 626D1BCAFA
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:25:09 +0000 (UTC)
X-FDA: 84577247538.24.F4D7872
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id D11F680003
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:25:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=drHbWPoW;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774268707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FReTsBEorcKUV1ztUSO8zZCuKrB7TDZZteXHSc8z88M=;
	b=6xyXKB8b+Pg45N4DW12fkZohUWgOlAIBQP9MW5aL0NA4uimJS05Bp1lAQXpRS8SFF+Hdn5
	z0F+7cz3u2p06bWnBLl79kR1WJfQkYiF/Tp0XQLUgt9NRp96/Fx+SuRrjDNB6yrHWNP5UO
	ozdrGTe07PJb3sDG2Ut+eckyyZ7cbog=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=drHbWPoW;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774268707; a=rsa-sha256;
	cv=none;
	b=5Q+LRZBbus7uS/mjsTAZpIHA4d+fMQpXWIwBE/MNh2bVxjlsAY3Y62S5JmEPtaXKs3Ybop
	54rrWv05lbf8Jc2cYfNp2gotNJms56giRu/7DZmANkrLLQeUOcL9aqLHL4GIiEXCduYNJ8
	kJoLWjI5jX0pS5LUPk3K7hGztqai96s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3BC9E60051;
	Mon, 23 Mar 2026 12:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF36C4CEF7;
	Mon, 23 Mar 2026 12:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774268706;
	bh=ZaVyichs/RRfk2MX4rNXjPKozCC5RWlOoxEpm8yp1+Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=drHbWPoWQ/hFqgM7MrihWQFuhhqCFbPKQFrNzl7qxK5i4OL5xfLUWmkPc7ZyOuOzL
	 iDAVSG+TvprLudKR1MO/Zl3GzZ9j/6j/3bubSysOBaAHTDVeWGMzF5H8V88qwhqVYY
	 uDb5wrSFTOvG0s2ZgPpui2JVL8eolZFmXvvfglD3ghhJwLwaDpLKDr7aCPV/vn5d8j
	 0MmBvOQxBxha8J+zMBxhSs0oIlocfdfyWqh82XyH9sxHqiN9oFjNrdPf9rDM5k/7f7
	 TLAMCAqGq1BF6KdwNl09I925tA3F+4mvAma9DVoNbVXUJCQ/ay1F3dxxcbngIsUDLm
	 2W2plRqaVx/fw==
Date: Mon, 23 Mar 2026 12:25:02 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 13/13] mm/huge_memory: add and use
 has_deposited_pgtable()
Message-ID: <0a917f80-902f-49b0-a75f-1bbaf23d7f94@lucifer.local>
References: <cover.1774029655.git.ljs@kernel.org>
 <f9db59ca90937e39913d50ecb4f662e2bad17bbb.1774029655.git.ljs@kernel.org>
 <97a35411-3482-42d5-b0ea-31a5994956b2@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97a35411-3482-42d5-b0ea-31a5994956b2@lucifer.local>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D11F680003
X-Stat-Signature: n5eompjms1jiuw3dxu8b6aa5kbso49zz
X-Rspam-User: 
X-HE-Tag: 1774268707-10124
X-HE-Meta: U2FsdGVkX19rBw0h19o9+rJQHfoyPLWT3WGpW47e+iI1O8XEHwlVfX2t2bSmKsAcsdWVIN2QUmoaRU9xMSdx/A7HIiEaDU/3X0VUN8rHbpYdV7oIzN4KSelOClKYRiCwXy1QDFxjjU6aIoYZZym7spMrD/McqkjPG6s5dPwWgwgyWQLcankuOD5/SiS9gfOx8W+Il4l20JlwTJ85eEEqbGXb99U61W/RDTtb7a74znEYJDKt9YdHryhys87vy/mseEQAXDHnb+VVz9pA+7U+XOg1AiqijgRw5zBZfDG/JPvI6Fz8+TGIxuL0ilEjHwheRyOdorNJtSFMvXQCxXs75IVnevs44e6TZ69/byX26iVtD/1tBlJpGffygsgJr3o/HfeDeI4/HDd+s479JF1cRQBhH0UPXNId6IWT6+dchTeo1SORr/dKLWHbZdS8S886H71MVTjCf3I4LIgPZ8j3nWLjN4P6VrIc7us024E/jdL/NMWZTJH8uERJrOp/n+pAjSBmpi29hCo96IV3oHKEXT2Q5+e/0il+XEO31N1HvmTyBXWmImAH9lnqBrtiftD+KhA+MIGWi1A1+aqkyz2KReMC84BUeArUyh6kol8hPRnefByh2opSwvwjx4lG4zZPi4nI1YDU9XuZtoRO7g8Ve1UfNMDM2NEwUD6YOB+VP/gFtxvf3ovisZ7J+2w/NVOk1efxV52veBt9j+Wci/fvprnm/o/UbhVMD1qG8q/RswCFZvsJ0GKwa0nR0tlkbXDEam22trpI9y5si/yqazGMz2xo2XbEE39HWJCxJdVlwXN2WM8Ohdz9I7x6Gr9R3uIzMpbLno2KdNmiAuHWE6SeuCDF6aTtd4Fend4CZcpCKuXlPfK7bw2QTHsrKYsn3+Uc8xQRuEEj9oHd4vpYy9/m8ntRWmDRe1CHi3cgw+mPTNpxCcZom8rqHmTfcr7pzIlkCjHXTOVUvdi+z3nL5Sl
 4ZIYFQr9
 RWXZI3scUjkYAKcTeBssKOEh0QRUGW6CK7brjT8CCpv2zfkb6P1ZaDBDujzPjXYHIBzJoTfuBZSAbluQDLxSyKlbOwgm/CzJoJzbOrEr3VSUCrYusy6gfAPfMsXTpfFhRlDISGvfyihqhPNKNO70HealuYiAPQCEBMSr6KXhomW5UZnr9ToDvtO5dVE+wvAGS3RZ21WGdFdle1iBmxZsxL8IRUw/kuj/yq+h7uECdNUcG+8hriQdVw+l/e6WkNloCr/hWwOojSYbRx5f8dyi0Th2hUx91B4xfoFNv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 11:45:23AM +0000, Lorenzo Stoakes (Oracle) wrote:
> Hi Andrew,
>
> Could you apply the below fix-patch to resolve an issue with us performing
> folio_put() on a folio before checking it again to see if a table was
> deposited, as per Sashiko.
>
> This patch resolves the issue by storing whether or not this is the case in
> a has_deposit local variable (as used previously) before invoking
> zap_huge_pmd_folio(), then using this boolean to determine whether or not
> to zap any deposited table.

Oops this is wrong...!

Please apply the below instead :)

Thanks, Lorenzo

----8<----
From e6d58747d00dd954c605201e97f8b769b2ba8cf8 Mon Sep 17 00:00:00 2001
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Date: Mon, 23 Mar 2026 11:42:01 +0000
Subject: [PATCH] fix

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 610a6184e92c..b2a6060b3c20 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2397,6 +2397,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	struct mm_struct *mm = tlb->mm;
 	struct folio *folio = NULL;
 	bool is_present = false;
+	bool has_deposit;
 	spinlock_t *ptl;
 	pmd_t orig_pmd;

@@ -2418,10 +2419,10 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,

 	is_present = pmd_present(orig_pmd);
 	folio = normal_or_softleaf_folio_pmd(vma, addr, orig_pmd, is_present);
+	has_deposit = has_deposited_pgtable(vma, orig_pmd, folio);
 	if (folio)
 		zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present);
-
-	if (has_deposited_pgtable(vma, orig_pmd, folio))
+	if (has_deposit)
 		zap_deposited_table(mm, pmd);

 	spin_unlock(ptl);
--
2.53.0

