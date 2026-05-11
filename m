Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF894CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 21:41:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AEB66B00AE; Mon, 11 May 2026 17:41:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 387016B00AF; Mon, 11 May 2026 17:41:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29CD26B00B0; Mon, 11 May 2026 17:41:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 180F86B00AE
	for <linux-mm@kvack.org>; Mon, 11 May 2026 17:41:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A5C431602A1
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:41:02 +0000 (UTC)
X-FDA: 84756459564.29.9E1FCB5
Received: from mail-oi1-f226.google.com (mail-oi1-f226.google.com [209.85.167.226])
	by imf22.hostedemail.com (Postfix) with ESMTP id D41EBC0002
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:41:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amlalabs-com.20251104.gappssmtp.com header.s=20251104 header.b=Z11MqJBI;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of souvik@amlalabs.com designates 209.85.167.226 as permitted sender) smtp.mailfrom=souvik@amlalabs.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778535660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OsyEmMEatHl5JGOKxvyMcGRrS7mW1Z+dscSdDt5bxRY=;
	b=zevT4dSz9A8ydKkgkoT/JPmqjvf5Gfr3v42Ag9jGJ3QdDgzYWlBBzMf3dw562MRTOKlEse
	UVYXATgWY64JSq5bOLDlrdIahN541M06UofTdf6z5t6wgSCbS8ZVfUPm+RjIbEzzPRtmsC
	51XWROW7hhMaq2tnaqqr/q0xW8PBTtU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778535660; a=rsa-sha256;
	cv=none;
	b=d5GM61IfYQfu4jHqHR0HlM165h44tQl/aMOKCkkDdYTil/S7HOobvZg6oJp+02f+WuRuVC
	67TDKSHzzwgrhOz7FzFnlwHnuLj1Q4b2Hgd/kTiIo8w3AGGi4VU/rP7tZPeLirYCDJnR56
	y9qzVZOheP9tJzG7sopYoIysm0vTydQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=amlalabs-com.20251104.gappssmtp.com header.s=20251104 header.b=Z11MqJBI;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of souvik@amlalabs.com designates 209.85.167.226 as permitted sender) smtp.mailfrom=souvik@amlalabs.com
Received: by mail-oi1-f226.google.com with SMTP id 5614622812f47-479e4835e26so2834023b6e.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 14:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amlalabs-com.20251104.gappssmtp.com; s=20251104; t=1778535660; x=1779140460; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OsyEmMEatHl5JGOKxvyMcGRrS7mW1Z+dscSdDt5bxRY=;
        b=Z11MqJBIy7gyRDUGmJMu12aEp0dY71KwjW+JtBQYnLZGxNkuuoorJVto5TRumf5Uin
         B8EP5yPQVAAmC1MZtw0+fAtaBBbo5YUevFxfBDmB1JpEEqcAIQbaxCvaEkMfhAnTNgwQ
         BpiPVmZ1I4+B4xoQdfFRZPqOBI4rCtAme75Ti7ceFs/bIsRwk2Wn6yjJ6qX8c/jEbjoe
         4zSNjfLywVEuzFlN5B9fDstSZ8gEVNSAf/3WHhD2ztGZXTthWl5Y/pL6ormdbcy9PrSw
         SatDYLKQNRtUNwDkvS2mS9JvoyQZhxqArcjcBY7Y98NwMJS6mD9/iAqb94LVhEJ1UdAh
         Qe+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778535660; x=1779140460;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OsyEmMEatHl5JGOKxvyMcGRrS7mW1Z+dscSdDt5bxRY=;
        b=rlLcJ0rKheWbhLCyvq1p8Uk8uxoRwZF8IHKm2CJUCwFItM2dLNIKnPVUgWJ2Dxn2vI
         xSGdmXJBJ4pYL8uq4hgwLr2JTlDTjsUKuDzTzpaZ4CIKRlQ1GX1IfrWqG7ziMi4Qy+N3
         14Ih2/kltGaD+iKNi0wVtu2ujsGoYvbrNSyOzvKQeJEA4uONzYowh5x2VAB5YlQtPGjJ
         Lz2U+GSkdiKBxYPLJn7KEBNH07Mj+yQ8EFZkrd+p+DdTSIQotVoEc+XQtryZn3g+QOf3
         JItsdKS34Ty3n2KJm03HfqJ+yR+oQiRiee00ljuKGrQHY3p8SZhh6jiuyNAlS8YOh2VH
         2Zdw==
X-Forwarded-Encrypted: i=1; AFNElJ//gpffatj29c7jCta+8UqoWPLHmxVom0U2qJTkCN9CfpXODDIsL+naOPwf9TqXW4VKNYt4fBEPLw==@kvack.org
X-Gm-Message-State: AOJu0YwrSN7NS7qHLlGJz7LN3yWzTSnx/ANCQR/lMNFtZ0IIhr3tEuYr
	cyZtKZevEpH3cdEF2d0SqbNDSzMQYox2lWmJGJ0m+Pn8jsBy+YffiAgUcZZgW83vgMYL9SsuFtz
	dKjbE5vp39JDnXXIjg/2LefKD/sNAv4Qms64kCjA=
X-Gm-Gg: Acq92OGFTICmTucZAvidcQROx9lL/CPCjDOO23+mYngll/WhZ8GTv2qKFDf2bM5gC7m
	E+5Urrx/8dxa6LdechYrVhYSgXdYWWHndxpCnPchudHbPjjpdaDsng/iGKetJjejnR/OzjzHSy4
	OOTeMoZvG29BJJTgLEXI5b6sBdPJyyRdmhn7FRnwOJzjnvyUPQWdkvaPEUrYxuG9gpp0HzcMT8+
	8HI53NyCwXsz6sIlzz6uORe6kYbbQ74ImrryfOtHnNe5lk+Q7w86f5BNKIQOMh2tFPgCys97bm9
	zu9VYZPAG45GB5jxi4L+C4sLCBrTQCzmcUHgeRklOay4ZQOM6c0G9aTzE907K1UBEHzdGEZVf9q
	vtppX0n/MiMrstpZWisKlzombteqSQMjTF1bxLOxe/Lnkv12jK5Ax1MdWR6Eiw/Zu2cwXv725NA
	==
X-Received: by 2002:a05:6808:2e45:b0:47c:3415:3726 with SMTP id 5614622812f47-48297388e0fmr335122b6e.33.1778535659807;
        Mon, 11 May 2026 14:40:59 -0700 (PDT)
Received: from amlalabs.com (104-10-255-95.lightspeed.sntcca.sbcglobal.net. [104.10.255.95])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-435f250853csm538701fac.10.2026.05.11.14.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 14:40:59 -0700 (PDT)
X-Relaying-Domain: amlalabs.com
From: Souvik Banerjee <souvik@amlalabs.com>
To: djbw@kernel.org
Cc: david@kernel.org,
	willy@infradead.org,
	jack@suse.cz,
	apopple@nvidia.com,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Souvik Banerjee <souvik@amlalabs.com>
Subject: [PATCH v2] fs/dax: check for empty/zero entries before calling pfn_to_page()
Date: Mon, 11 May 2026 21:40:20 +0000
Message-ID: <20260511214020.208939-1-souvik@amlalabs.com>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D41EBC0002
X-Stat-Signature: zwgpbq47uet6owgzdqhsqoaa58xhpjex
X-Rspam-User: 
X-HE-Tag: 1778535660-353848
X-HE-Meta: U2FsdGVkX1/hG2oi/+cBifUp3J0/Qb1/dMKfi37apSb4lK+ShvuiPalPeyfFtAgP5XsD8mGPzMKjKegYmXI90VcdoteMV9ohVi0P0voBHmk9f4GX8tZXlCAwOUCegTpmpL85pYZIZg4Z0ULYfr1yZutl2UVlC+FPLgHOcI1IPi1JKsKkg0wCQ/rhtWElNOQL1pqKuruIvx62Pf7vZ97QU1awPAbcrsxwF1ARoqZqed5XPG7gDoOZ/1yy1FbjAIQ4aeSJYtuMAW2GLucWpKU9awtvQKCNnrJlp0wYwsqBfmuZISoLAQWP3S3MOTjvDQJCcIbypBhqB9GbayeNKF590E9bw9takzMcIeRpwyf8ODyOy2NqYFa8WSxl0LZECdTYCYlhVdQKdras/AdVgwM3pN2FguTiJ3BVKat6tiREzKw8ZFKUucTYFuKJD/Y6nc+hEP3LiXJ3tc7xmOv4nrSLxmiAnKuZan4ulc9Wp06SN0SduX5WEL7ZoM47jt4oGC97IanJ9uSVmn1Xg4/Uv1zZs61ydmISniucx9tVyUkIDp03IKpN4fny3lsC3UIqYUTQ4LZ5LU7lFtQ7CPeYzt8KH0YgUbAT/IKUHQ5XaLL+m9QVEHVuVVLSLfLU5kwDzeFm2h2BHU71u4k/hjXL+hiJwRRNrXM5o6RFe1di500THR6lXmwqlUzRlfXovZxXOcWVjvF94ka+Wa6DWrG0CrJRw3zk3oBdmBLnZt0mmWX9ZKBx2ZWTjLS8PI/4SirvWn0D8Tyb5giWXUPK80fhxfn8iKG3sbLaWjSI9+5qi6E7S1kY3G9aE/u0KozP7h6LwyZPW996Gd/uM6kijy/2uMOZ10Aj1X2AxxHvB8FiyFkE1FcIckW88Fu7VtSDX2/f8YmI2PO1l02wngqPyzFHP06wnzaXOt5t8GPgWyCDkYNes9RMZI4mxNAmbVhlJOidi8JCncZlht1c5Yj5O8k3rQO
 mfg5scZi
 UaJUPq7suFNozwTf6aiLQvfSzqfcM98iMwY3pA2s71B9wTJs1lopiBjvKQ1rAZnZeYbueX1zK0xc5y9YJgPlOKb6ywUJ6pTPKeSkfUPHWZ05LNupWTSawhGmRzX/gLItSQw9V/QvoirkId7MvzPjdNmj9jKlSakac0iLiS0gjPdIcTlkCewoKuuEHMRCZtQv9n1+8c1mEzOZjIoSSvfS3CwnMjnMiteS7aDF7jl5jej62FkN5OX9w7ebvGSs3k1kEamJJzpo8iJcNej3VfdbFuA2X2vEM2LGzD2hjefeBazNsZXumUvW9wGpmFjnqBNGTmydORm8SrZLvdfHW/jvEJPBAGy0nEHkWuHpQjehiCfOgGChYhOCmgYy2E+WiRqdQ5SyV5ITULf2H5EwJtJGsIuLghpF7DRcHFJG2iLVt5K3sgLIhBUkOth51MZuSb9Hfz3gjz9WfZCQNKfoDBOXOlWvZqFgGrzDZstKXEXXcGmYF63o0/1xKTywA9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
added zero/empty-entry early returns to dax_associate_entry() and
dax_disassociate_entry(), but placed them *after* the
`struct folio *folio = dax_to_folio(entry);` line.  dax_to_folio()
expands to page_folio(pfn_to_page(dax_to_pfn(entry))), which calls
_compound_head() and performs READ_ONCE(page->compound_info) -- a real
dereference of the struct page pointer derived from a bogus PFN
extracted from the empty/zero XA value.

On systems where vmemmap covers all of RAM that dereference reads
garbage and is harmless: the early return then discards the result.
On virtio-pmem with altmap (vmemmap stored inside the device), only
the real device PFN range is mapped, so the dereference triggers a
kernel paging fault from the truncate / invalidate path and from the
PMD-downgrade branch of dax_iomap_pte_fault when an entry is being
freed:

  Unable to handle kernel paging request at
  virtual address ffff_fdff_bf00_0008 (vmemmap region)
  Call trace:
   dax_disassociate_entry.isra.0+0x20/0x50
   dax_iomap_pte_fault
   dax_iomap_fault
   erofs_dax_fault

Close the residual gap by moving the dax_to_folio() call after the
zero/empty guard in both dax_associate_entry() and
dax_disassociate_entry().  Apply the same treatment to dax_busy_page(),
which has the identical pattern but was not touched by the prior fix.
dax_associate_entry() is reachable with a zero entry via
dax_insert_entry() -> dax_associate_entry(new_entry, ...), where
new_entry can carry DAX_ZERO_PAGE (built by dax_make_entry() in
dax_load_hole() / dax_pmd_load_hole()).  dax_disassociate_entry() and
dax_busy_page() additionally see DAX_EMPTY entries created by
grab_mapping_entry().

The remaining users of dax_to_folio() / dax_to_pfn() in fs/dax.c are
either guarded or only reachable on real-PFN entries, so this exhausts
the anti-pattern.

Fixes: 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
Fixes: 38607c62b34b ("fs/dax: properly refcount fs dax pages")
Cc: stable@vger.kernel.org # v6.15+
Cc: Alistair Popple <apopple@nvidia.com>
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Souvik Banerjee <souvik@amlalabs.com>
---
Changes in v2:
  - Also fix dax_associate_entry() (Suggested-by: David Hildenbrand,
    confirmed by Alistair Popple).  The same anti-pattern existed there:
    dax_to_folio(entry) ran before the zero/empty guard.  new_entry on
    that path can carry DAX_ZERO_PAGE via dax_load_hole() /
    dax_pmd_load_hole(), so the dereference reads a struct page derived
    from the zero-page PFN before the early return discards it.
  - Audited remaining dax_to_folio() / dax_to_pfn() call sites in fs/dax.c;
    no further instances of the pattern.
  - Updated the page_folio() expansion in the commit message to refer to
    the current field name (page->compound_info via _compound_head()).

v1: https://lore.kernel.org/all/20260501233933.2614302-1-souvik@amlalabs.com/

 fs/dax.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 6d175cd47a99..4bca6e2bc342 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -480,11 +480,12 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
 				unsigned long address, bool shared)
 {
 	unsigned long size = dax_entry_size(entry), index;
-	struct folio *folio = dax_to_folio(entry);
+	struct folio *folio;
 
 	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
 		return;
 
+	folio = dax_to_folio(entry);
 	index = linear_page_index(vma, address & ~(size - 1));
 	if (shared && (folio->mapping || dax_folio_is_shared(folio))) {
 		if (folio->mapping)
@@ -505,21 +506,23 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
 static void dax_disassociate_entry(void *entry, struct address_space *mapping,
 				bool trunc)
 {
-	struct folio *folio = dax_to_folio(entry);
+	struct folio *folio;
 
 	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
 		return;
 
+	folio = dax_to_folio(entry);
 	dax_folio_put(folio);
 }
 
 static struct page *dax_busy_page(void *entry)
 {
-	struct folio *folio = dax_to_folio(entry);
+	struct folio *folio;
 
 	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
 		return NULL;
 
+	folio = dax_to_folio(entry);
 	if (folio_ref_count(folio) - folio_mapcount(folio))
 		return &folio->page;
 	else
-- 
2.51.1


