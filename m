Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E72A5C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 13:36:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C4206B008C; Thu, 10 Sep 2026 09:36:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04EA26B0095; Thu, 10 Sep 2026 09:36:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E588B6B0096; Thu, 10 Sep 2026 09:36:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE6116B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:36:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 34A541C25C1
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:36:28 +0000 (UTC)
X-FDA: 85197952056.26.3968DED
Received: from flow-b5-smtp.messagingengine.com (flow-b5-smtp.messagingengine.com [202.12.124.140])
	by imf01.hostedemail.com (Postfix) with ESMTP id 39BC14000E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:36:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="J iC/FNc";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=IoUTrepy;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.140 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789047386;
	b=NXeA5iRH4aRaB7SmjbaAyb/V9xiNjO2ssHbYiggbMDU2l/8Pb8cSMHJbLNO7vruzR7Q6g4
	YAPqtvYq/KoVrNqrnS712vJWXyCXt8wIxjj2MYl4wCJWGIyozIOu7fcFJ82GoozYG0TJAX
	BMfgvkGdYCdtt7uVW2+la4cVlYtj68M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="J iC/FNc";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=IoUTrepy;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.140 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789047386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Aix6zD+sWAhHCK96XTqdVIPFcUsbKpScTo8omJZ7kRI=;
	b=n6vrNhTUR/w1U8rOdz4c2K3P3ECLFJ7b/5OmrMZtrsnbqpC5TuXEtRS++TXCxzBdN8qULW
	D/zOiB6uSRFtOIH6gufXbIcsB5k4abgrVqqGdmfThnh+iPMVy7PSNtsKNEG4HpDiEqQXcr
	e1Zw26i5FiAGFFjoZHJFVcmm9h1OU1w=
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailflow.stl.internal (Postfix) with ESMTP id 53394130031B;
	Thu, 10 Sep 2026 09:36:24 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Thu, 10 Sep 2026 09:36:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789047384; x=
	1789054584; bh=Aix6zD+sWAhHCK96XTqdVIPFcUsbKpScTo8omJZ7kRI=; b=J
	iC/FNccl0yH8eZLx8Y1aA3k5KkWHnq/SUgCGyekPoT/VyPpPrQTTHxbCn774XPfu
	y+OtArhkvOMs8178JTM/BKjum34C28rfNShUl9uo1JeCNqmmvZUTIZLXDNM6Im8q
	sLtNlryUoZDEICm2fG/k9QuyUXqjLBLG8a2IOpctkwJfdX2OyW6GP4AlH4u4MugR
	ok5ztUySC4ICl2NqI+95e879rCmMyP3bn2AvtNIKu/QwMFgSyEeOjSZo7UtiKooM
	1UPOyj9+JXZ5Voi1xsXtLKQdq6URhZcljDW6WXHgFudXyh4aI/3QEVQ8A2fu0ycx
	e7fuDH45gUZFIcPEmVYhg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789047384; x=1789054584; bh=Aix6zD+sWAhHCK96XTqdVIPFcUsbKpScTo8
	omJZ7kRI=; b=IoUTrepyYSR/bEiVJoM6S3gFlo/l0qjcU7cPRIJFHAdTeJIL9Tz
	AxlXVqLy4UglZ0QEYVoTgXoVQPc6oK8K6+ic9X5YjPsqMIILcajf8DkK6Cg+m0Lv
	1J/UJEuwOC/cylj5dYO4IWS+eMzcU0G4uzEfv48dMAwRDbNtYsRY1Bi/UKxSCyTl
	srbKccBjrnKKKlvJUNOTRTB+ZgWjkfb0rv6y1L/X32QCq5WAlbCgp9i+PFWMvLxF
	EwEJGDWI6D3jSw/p030sYcVVEHM3bxgzY7JbpciivHKYNlvGQd8g4KZWWK9zHVQm
	Nm26BOEiho6RxJNoK19o8EAsZljaavd1rjw==
X-ME-Sender: <xms:V7KiasHiw0d7B0joUAwkdvU8Bga4XWJHRXpeEZTe_kuhdQGwp3EAbA>
    <xme:V7KianV5efMMkCR84uqLsLP9iF3dRSN08zFokNrRb_iykiESwg0mFmNCHUJ88xX1h
    xzAJzMU6lcoYmRhdIge3qr8eytQ_68Re5KYBMjMfWJB1MjJhFq7WDFx>
X-ME-Received: <xmr:V7KiaqeJ7u0PeZS6fdgBUhpQriOniVjSUV2qnx3uEXOKbKe-DSblJxw4ntg>
X-ME-Proxy-Cause: dmFkZTE/cV7Y3B5vfmq4FxwBW5zjIOR+OZ0Xq5wNE0R+9MV5eEb7Vmg3gWUSzcydLMYKsT
    k0AEiBx5vAV4G3V3qjltmxAKxV5+/EjuIP6hv39fDwwxRv8x0NwLBFQwKfQdcq+44hzyHZ
    3/uAyOhAF7+IUKa8FH5q0canFhSzlKFsCqOHb9P8uJE2LFS6hBfLubEv+qPLaOReHYiNDI
    t7k34surxCm87KQlVrWSwkDE1ybXWYCPpf0JDb1ntZexrcY4FQjImfSwEXvhyEyq9EMbag
    ZRrwqKZ/zrY7HPzA9+r3qwYLqtLJwM3F3LvVn+dQgoholjbS3YyVg7nrSnhOjJXpJWvdAB
    bsesbw6nh2xKNlCbjDZaLS+F1fclhtk/tkGvO8q3VrPNgjZRN8cAr1LvpkeXgLQlTk4eD0
    oBgAWaBpWJY6p3DxNoxJdTkhb1HcO47WICrGjLw8NjRs6Li3q3dAaah3w5GIP6MphuoJdv
    KaZWhP3av+E8Ee6yVrdqcpk5gs3GC0a9ykMnyqXjOvjFeElgQbEXDsGkZo9ImEoQ+bsWUz
    kZI1Dy7J/mPKKtvJ5mXRIkHCWlOuO5LJ0imcYavY5eiQ1kQkbc/VDgMLnSThrB/LeIJo/f
    l21N7br/2Qlm+OfDCuECU3ibjKMGb473+BUWv8mxDr+KQjqxFWJ1rLsrD9qQ
X-ME-Proxy: <xmx:V7KiamTCFHjpmBE-EEinApbKeCrS6JG3nHB4MLcdlUegeDHp7naQGg>
    <xmx:V7KiasBRTn6630SaHyJ8qQzwVrY0YsQiHDfSJ83W053CWDz3RnN5SA>
    <xmx:V7KiassB-nsQ0HGdKsvQQfAE0osTulGGqkk9TyOj2cEUzMFCNLr1Mw>
    <xmx:V7Kial4KoUrfK9nBSFF_muO3jGSz5q9aAxvFhSblQNCsz7bEbrW5Zg>
    <xmx:WLKianwh14UVD3RXq0BoVMyJjbOORFjiIgq0wIdt5yyEc40WI17Hm9lf>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 09:36:22 -0400 (EDT)
Date: Thu, 10 Sep 2026 14:36:21 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Usama Arif <usama.arif@linux.dev>
Cc: akpm@linux-foundation.org, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	Carlos Maiolino <cem@kernel.org>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [RFC PATCH 1/5] mm: let folio_mkclean() report which pages had
 dirty PTEs
Message-ID: <aqKxU5iOuWjK58Al@thinkstation>
References: <20260903182943.662461-2-kirill@shutemov.name>
 <20260909101212.894871-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909101212.894871-1-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 39BC14000E
X-Stat-Signature: 6u8u9hh95oy35f9ox7i5iejkouubue7a
X-HE-Tag: 1789047386-748904
X-HE-Meta: U2FsdGVkX1+rudhTBi10MHgGhHwHw1aDD+VsZGkOh8OD/7B+BHy2MH6U4s9KWPVCggoL9rwJBm+rZHLNPgbm6ZKl++nrlnjr0hi2atiPFWBI/sx+RlMgV07AMu+C5ipuhSTymly5w9DCzSHLy26IaTyJlfIxMCuLDjwNf8KAJceDm+TrTHmDb9HcoIfMYgRuid5uHZXgrnYF7xnabkpz2E4GSbcDJzpfS/lDn81Q/DBPc6F4Gb0I0hDo1f4RCVEleodaRq0g0fGKlCCLuAqaUBJ1WPhejwcKJLmWmwAbynAHOac+pR+4Fv+wNkkhAGaB/dN9aVeammk+utbJh5rnANFZUzeTGUm2xSse/gItaabXhLxQl+t8eAU/selFt6tq6Odidv6AIjQlwEE4IAYitlltiNAZKDW7awtGavuyuKk2IiG8y+Ok9JJ1uOBKLPoCZZShPwXSjem4iahGXiOqtbhLPW7tOsITYJKQRMlLG1res+TOapWFLC/0fG0MG6SLiOaDMKKEpXwys948nYAHZ8rLj2ieiWJ45OgjMUpAJW1rz8xrrwHhTraAkXqMrp8636Z3KoIUSviWAAjO0bjwSbMRtUZ3x/iH4nso852HRiAOT2akfUz+IdWwUOItw4dq6HqLMekrciDr5oJsww3iFB52rK6axskJR8EJGA1jTGXQY8Ag5zi+RNQsZs0E8ujD7mSUizR7FlPa5FECDBKxXBA40QAcRl2g/giTzNHEbOUkUmv3ZO+rSiQptNxsEcTLA87VZ3cUpw95UbwL7BGo25je4oaz8u146wmZEf6adcZxsgEGyTtWBpRt9K+SkZ+aJML33TuqVVMwoZX+fnM99/E2WO9Zca5l176pflFSO+OKNqChJ91UGFJrgFErN45MN13/sb/N2EHn/zT1MFK2FHtmruonbxfEvyqq84mzBeL1SGceFsStL2nOLkUzYMkOtQGXQQDtJjfy7BKuNOZ
 bAg9jvOP
 LYLco9QA52CmODTrvL8KPZTPfaAOkw2XYwnpgDphyx1KFM7s1vNYMObtcXHi+Bu6pzdxdrmldC96+mBWDdhsylcVhfkTpuSsdyQzNCNBfLnXbjCd66niBFDurR2/tb7JZTnbX7iTGo5rzDVAodqfgxWszG57aTrckA7Y4SkOlpnltEOyahwKQm4pqPtYWlVBlaMBEXZw93062xJYKdhbTh3wvqnOyCHvKlMZef14Ej3p+QkiRDAVCHyumzc4TunNUZF96n+qunUS/wId+MDVbSQ3lGWKZiAow4OE5ymcScQ+CkBdDepXOkfiksDj74UQe9u909IZNnQ2hdRnk4imrOGaUF9tNZGXubj22PrLbQNzrDGT/dlfJ1G+ab6tW7piKaGlkueOQL3fdCshXMSGppPlBxmGCWjaUCiuhtCkxSkRkdKGk5/ri/YuNWlv85NQ8j57vdAnMz12k3+mc1NP09Rp0tG31+TYF8YsWQ2HfQ0Vi320=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 03:12:10AM -0700, Usama Arif wrote:
> The old whole-folio behavior did not need to know which PTE became
> dirty, so this timing window was harmless. Sub-folio tracking makes the
> final dirty state correctness-critical.

Good catch, thanks. I should have known better.

Fixup below.

diff --git a/mm/rmap.c b/mm/rmap.c
index aaf45ac79fa8..9b8b9428f802 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1140,6 +1140,15 @@ static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw,
 			if (!pte_dirty(entry) && !pte_write(entry))
 				continue;
 
+			flush_cache_page(vma, address, pte_pfn(entry));
+			entry = ptep_clear_flush(vma, address, pte);
+
+			/*
+			 * Take the dirty bit from what the clear returned, not
+			 * from the value read above. The entry is writable, so
+			 * the CPU can set the bit at any point before the
+			 * clear, and the page table lock does not stop it.
+			 */
 			if (dirty_map && pte_dirty(entry)) {
 				pgoff_t idx = linear_page_index(vma, address) -
 					      pvmw->pgoff;
@@ -1149,8 +1158,6 @@ static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw,
 				__set_bit(idx, dirty_map);
 			}
 
-			flush_cache_page(vma, address, pte_pfn(entry));
-			entry = ptep_clear_flush(vma, address, pte);
 			entry = pte_wrprotect(entry);
 			entry = pte_mkclean(entry);
 			set_pte_at(vma->vm_mm, address, pte, entry);
@@ -1170,12 +1177,14 @@ static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw,
 			if (!pmd_dirty(entry) && !pmd_write(entry))
 				continue;
 
-			if (dirty_map && pmd_dirty(entry))
-				bitmap_set(dirty_map, 0, pvmw->nr_pages);
-
 			flush_cache_range(vma, address,
 					  address + HPAGE_PMD_SIZE);
 			entry = pmdp_invalidate(vma, address, pmd);
+
+			/* See the PTE case above */
+			if (dirty_map && pmd_dirty(entry))
+				bitmap_set(dirty_map, 0, pvmw->nr_pages);
+
 			entry = pmd_wrprotect(entry);
 			entry = pmd_mkclean(entry);
 			set_pmd_at(vma->vm_mm, address, pmd, entry);
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

