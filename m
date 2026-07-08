Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E47FC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 14:57:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C048C6B0005; Wed,  8 Jul 2026 10:57:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB5276B0088; Wed,  8 Jul 2026 10:57:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA6506B008A; Wed,  8 Jul 2026 10:57:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 858126B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:57:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 15FD11A01B4
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:57:35 +0000 (UTC)
X-FDA: 84965913270.12.112E921
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 74C9D4000C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:57:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lK6+f+U6;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783522653;
	b=heVRY7SeM6C7v/tHWWdUppAk0GWYCzdyRjV7txNcdtK7DR9jzQzV/MZQWU87zPsUvMydAx
	ztz8eCXpdp+RcKB7vg/iA5CXz44+TzZTFMDDAIbXA3D8RihGqRruT62Fc14Swoj/Y7N/1E
	ifAwsuch5ECAhh8QJpOhkp232YkFp40=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lK6+f+U6;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783522653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GZa8vw9eM2fM+wbCCDp4SpTWaA3yorJgYmnsImoOKjs=;
	b=4k4HIxCnOQZ59+c/fgFpO+XcddpKdTRuw56jMiD4t5OPj3+kHFY5aSlYAU6ixSUo5yOihx
	BMJ1dutq0PhyExFzOqyuTKTJF1Iyi+doLj1inq76Lnnz21FPspd3B/hY0oRQdycMz9/03J
	oj8TJo1aZetguD6iQ8g8u7hk6FHvyoI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 010F061373;
	Wed,  8 Jul 2026 14:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE601F000E9;
	Wed,  8 Jul 2026 14:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783522652;
	bh=GZa8vw9eM2fM+wbCCDp4SpTWaA3yorJgYmnsImoOKjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lK6+f+U6IiymicFHG6iWIRSOroHgN+5rIAoqosSWNtbmDz1NmriUXwRbiIlgiE3X4
	 jOLnUnz+90j7kp2lbKg/spiXA5KayOCjcZ8RRDapUFqkBtb539B5uuQwufA+zh2m+s
	 aOq6Bw79rYv4WrElMbIZ/E7ycNsPzUUmPibLV9Hl6UvOXkB+psoJOL/tCu3J0aLs6f
	 whGMOFz7PXhpwzP8aETbk1hxAxAY9RBJKaGrySn2v7qPPAdExgMvS3CtydT0SlkBlT
	 21ychWsdSEPIzHjG5nnDEybqkkSyCbfYfE/lMIVTTpb2kJqmffC0R88+hBGc0VwoZt
	 RU4tPp7LbNOFw==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: david@kernel.org,
	akpm@linux-foundation.org
Cc: baohua@kernel.org,
	baoquan.he@linux.dev,
	chrisl@kernel.org,
	jp.kobryn@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	nphamcs@gmail.com,
	rppt@kernel.org,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	youngjun.park@lge.com
Subject: Re: [PATCH v3 1/4] mm: avoid unnecessary lru drain for wp_can_reuse_anon_folio()
Date: Wed,  8 Jul 2026 22:57:18 +0800
Message-Id: <20260708145718.82690-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <793fe8b9-f5f5-4458-9150-5edbabde44e7@kernel.org>
References: <793fe8b9-f5f5-4458-9150-5edbabde44e7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 74C9D4000C
X-Stat-Signature: skpsw66zp4bg3crw5odzcdzuhtmzfutr
X-HE-Tag: 1783522653-389951
X-HE-Meta: U2FsdGVkX1/adRDr6qKGf8SmpNJB2+Fe3BSZxS3rCr3E6xrmes9y01rSO6ZfNPu9wIsr3KeIisKHKw2obO+mSedPpJBL2HOnZOpMDw2YDGA2zF7o/CxletzMA+62snfvswzy7gKM7PgPpqnM+g9kG/iJWpWhmZ367D4xKks1te2AGXsvieaZiaQJRN+jQzTLROi+TzLRIz5HNUX2ygSXCR26P3MiwaXckbRN/4wKcbtFzWcjdO3eiZfD3KxQIQq2meuCc/Pg04FGOY3BiH7kvDFvWrAxsqq+X/HjoROWEkp4wRpn/ciGGLOoREOllA2i2H2+At2/PxLj5K1cr7QqkSPDDfJYgf9i9FdV4mjbe4mLz5p2L+EY1739a+F7K4U7Y4KZroSqJ3XnQsbqQDEbYHM57g+N/4NZEdcYKlxqFkGj3Nc0t4iMDY0AWUIFIihRnYpRAlPO9wUmGgJTDfID2FRk1WZkpTaW0MGMvAmZDQf8hKl1BZIuYeKSaOHsivIHs057P8E6fuVvrBj4I9+CW2a4+F1WJvhyekrMbmeeTiXJlQzSoo9QHkgKddRfn/YcqVoU/Jhea0eJDk4t7gv29XOJDrDsDlaZveHE55zEGNxVZjn7tf/LyKhCLkumVDpP5QTmHmXnYmq7zB/nSvPXCxGqVUY1OojNVG18EZ4ZcuK1vR+DY2HIZSsU+PJbPF6a5g/OJhPoZ/V7zz8MM0AXEUyAB7vhtkJq8JcsZt/gEHV0OFLbaJo3hweQC/Ua4krYXSbgvrtOp/3YaHw/4ZM7p1GrA7nD8f3fL8FRZ/xgKua1wu2PxODfA5CxWGoe2JhU9wUFnGrmaOUfztfYuN+UKdgiH/s7j8wO5A2YwOR0vn7T8U/BwhlRIWQbUQ+Wg3ddcjRp+IPDrqp0n+5EaEvVrJQQQDEC8qg49Qnvxxe3RMFgc0O1meLwScwkPYNTQR19mdb3GdlKdqJyNBDyvpu
 QJ+sUXeQ
 Kfqsx7INt5Qs1CHkikOYchL6EOwQmlQVCvvqeMe/eycmPi4zySCmo+yr8BiJ5s+n8qIfUS7w7Bm4qohUve6IfAL4wHV/edxERM6eirErEh/aYVG7555RogT8dkwotUgIM/2NEgGJpJSmUoK07ypu2c+Vcb/d0VIu3sVPgM8zR9XIfmZYmwJ7XVk/8M59CP9o8JuQ8IzxursdaTF/FNPunc35q9blytL0A/KIOOgZevj8nLMqnHGWGQ4TuY0Q9p22ytpM9biidSmFERgTdNW/6c8W0gOqjSgdiQ/1wKMCvzHC6wY3rLe0N890tzE2Soy0mwAkbrRdkFo/V7vLj6JIVZzfTu8uB1Gd2yWsf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 7, 2026 at 11:58 PM David Hildenbrand (Arm) <david@kernel.org> wrote:
>
> On 7/7/26 17:26, Kairui Song wrote:
> > On Mon, Jul 6, 2026 at 4:54 PM Barry Song <baohua@kernel.org> wrote:
> >>
> >> On Thu, Jul 2, 2026 at 4:05 PM David Hildenbrand (Arm) <david@kernel.org> wrote:
> >>>
> >>> The other folks should probably re-review this patch that changed quite a bit :)
> >>>
> >>>
> >>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> >>
> >> Thanks!
> >>
> >> Hi Baoquan, Shakeel, and Kairui,
> >>
> >> Would you like to re-review the patches so I can re-collect your
> >> tags? If not, are you okay with me removing your tags when I
> >> send v4?
> >
> > Sure, no problem.
> >
> > The only complain from me, and a trivial one is that `in_lru_cache =
> > !folio_test_lru(folio)` looks a bit odd.
>
> I was debating with myself a bit, how to keep it short yet expressive.
>
> "maybe_in_lru_cache" could work.

yes. sounds very good to me. Thanks, Kairui and David.

Hi Andrew,

Would you like to squash the below change?


From 4ce3a8e95eaa58ca58291ac8c2986f00e0e4db12 Mon Sep 17 00:00:00 2001
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Date: Wed, 8 Jul 2026 22:46:43 +0800
Subject: [PATCH] mm: rename in_lru_cache to maybe_in_lru_cache

!folio_test_lru(folio) doesn't necessarily mean folio
is in lru cache. so let's put "maybe" prefix.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/memory.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 5689b7cff76c..631c170f812a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4174,7 +4174,7 @@ static bool __wp_can_reuse_large_anon_folio(struct folio *folio,
 static bool wp_can_reuse_anon_folio(struct folio *folio,
 				    struct vm_area_struct *vma)
 {
-	const bool in_lru_cache = !folio_test_lru(folio);
+	const bool maybe_in_lru_cache = !folio_test_lru(folio);
 	const bool in_swapcache = folio_test_swapcache(folio);
 
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && folio_test_large(folio))
@@ -4188,9 +4188,9 @@ static bool wp_can_reuse_anon_folio(struct folio *folio,
 	 * KSM doesn't necessarily raise the folio refcount.
 	 */
 	if (folio_test_ksm(folio) ||
-	    folio_ref_count(folio) > 1 + in_lru_cache + in_swapcache)
+	    folio_ref_count(folio) > 1 + maybe_in_lru_cache + in_swapcache)
 		return false;
-	if (in_lru_cache)
+	if (maybe_in_lru_cache)
 		/*
 		 * We cannot easily detect+handle references from
 		 * remote LRU caches or references to LRU folios.
-- 
2.39.3 (Apple Git-146)


>
> --
> Cheers,
>
> David

