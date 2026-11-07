Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8472E606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 21:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bs7EKf1N
Received: by kanga.kvack.org (Postfix)
	id 3B5A56B05B0; Sat,  7 Nov 2026 16:43:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 366CB6B05B1; Sat,  7 Nov 2026 16:43:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27DF66B05B2; Sat,  7 Nov 2026 16:43:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECA7F6B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 16:43:52 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5F3F2A7F14
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 21:43:52 +0000 (UTC)
X-FDA: 85409650704.24.893FDB4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id BC69040007
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 21:43:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bs7EKf1N;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794087830;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N78A/tFJL2MmiAzsL6G/70rStLyxim8xc/oVb8tqpuU=;
	b=SXnl6ihL4kOgV6AuN4zWAI8DVmL6YOTypge9ZMp3KrUQJH3KF8q4excVCPLnya+1xqIgUY
	MTaweSDiRFvy1k6XqGMwFwPb0k33MLPlNzOp9GXakvAJp+apoFtJj7TSWCj7ginjVKqar+
	8UG+BD7G0IS8sJbEEobbtWYMv7Asjlc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794087830;
	b=zKRChMdisKfRbSohgxKWBxQi3L33DfH0Q6kcZ6aEq1c1KsNHpxEyUSylTSr8Yb+WqvodFa
	sX2k0wlHEqIdtVAVQwWwT2COdblMjwZDm0S7M2B8BNmTQECDFzHep48+oQ5+QEDKUy83VP
	mf2qC9yOQPe1oF5Ee2mF/vPVG5KYKmg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bs7EKf1N;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E295461210;
	Sat,  7 Nov 2026 21:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE20C1F0089F;
	Sat,  7 Nov 2026 21:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794087829;
	bh=N78A/tFJL2MmiAzsL6G/70rStLyxim8xc/oVb8tqpuU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bs7EKf1NrquqVcdeffxNtsF57wBEJNKPQoJVKMNVOjRqdcAKIsmjhcGLpML3JIb4Y
	 7IiPJGfF9omV+XCSkmQ2P04ceU9CB+2NyUbD44tmFC+8Qnv9YrRbuQbSrmY/SKOft5
	 TOcPUaWzCBL4MnDJjLXoQ68VO32RnL06KQO/I6edx/PcWl7Uv5o9c8XJY02qpGuq3P
	 kU++2vSg9WWjzaDlMrfUyoyAHbk0MLABnxK9SBNBKBdgsIftvfpPGe3IIToE3hG/eL
	 HJFlQBsq9eWr6Y1+Ow4jqUhpZuRKb+4EQbzZTJE3LWo/Gd3VbEQioWJL6x3lqrRL8A
	 ackYIt2vyboRA==
Message-ID: <sashiko-outbox-203344@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/truncate: unmap DAX entries before invalidating them
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zi Yan" <ziy@nvidia.com>, "Dan Williams" <djbw@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian
 Brauner" <brauner@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "David Hildenbrand" <david@kernel.org>, "Alistair Popple" <apopple@nvidia.com>, "John
 Groves" <John@Groves.net>, "Miklos Szeredi" <miklos@szeredi.hu>, "Darrick
 J. Wong" <djwong@kernel.org>, "Carlos Maiolino" <cem@kernel.org>, nvdimm@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261106-fix-dax-invalidate-mapped-v1-1-292ce5958d67@nvidia.com>
References: <20261106-fix-dax-invalidate-mapped-v1-1-292ce5958d67@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 21:43:48 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BC69040007
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 6fanxyzp1ejh8mhq9f17hipfeqzw9n75
X-Rspam-User: 
X-HE-Tag: 1794087830-193293
X-HE-Meta: U2FsdGVkX1+LcxzQwz277IdKJ/V2AqfmkIWnVMmBiOLzlnDkIUhptjZCO0qSZYzL7jPMJvLk62MpyX6civs98u9ogiK1yCNH2J6PD7Xw8DLSH8iwa+NRXa6OEWc/kZJSSQy2n89rDDxcSPcl1XIHjEurTBYrOZNkndgPvLJIEf6PpCT0Bv+YVkFdm9YzLk/DBT/qjQ0Q1hLpB2TTx0KGFMarsjlsEkJyyNmVapDeKpd5U5O0YLKRDmZ+7MSkAZPJfpM1fjb4qQm2MunBWw/UO7CF1S5p2rrUezuhZ73v244OtixJhLXXxINdA3T6vMpqIRWl7cn5b8/l5/29ti3YP36uCSsv01NB3Kb02v8iVY4AB2qOwabOvqAlxieutFP6B4I/SaUTlaPpsaEs0NTwh6R7N1Y3HjC3OOXRRWgnxIu5sqB4Rl0pkhNmgy//w3qwB5skveWahVJoIyEC4UFV/xCAKA3DndbLqunmwfPCsNCdbY9wgkk7R2SuSLuvO00BL03ttccKQJXwFok8rYZD4e4DZkeP8GWexVLrVhnqDS6UvMjCqwUDyTSW5YZtn7SCIBkuW4tQKTkqDRTDjbF/eRi3FhuwFH9A0xQAysxF4WNanKlA1Z8vcuXn+utQsACq77VSHCfwu8S42gbOgD1rmuSp+/uChrjFT9bUD1EyYo3H7nBKCjQfw8nGbNlkvxnHaiobkzpMZciycnEZXsV2gf9UnbAdcK4IACSofMesfp/LMRvQQEo+uC7V1UKA1ACwcU6U1J6EKcrZzkkrHXYKLLtx9ibT4re11CKAZe6Jv91wGe6DF0xIi716INc1m/y6FF0anS6Cs+DSg7CqE78J69ha3f0egM4sJ/ydsCDpggaFWx7iwFB4pLK7jEtsxX4z5LZ6R9FHQ7VRT4T04/HVJNLUbtmeYSqqX5OJBYiXjfizNzVVWVEdrPH3FtRThuOKmCmQfWa6Ac3DW8iY6uY
 ofcRRYZE
 rE6TrCfQX24Btmr12OaIh2Te6M5spVzdHWOfLcVFipWSLWYCEtgKc235rw21vBKh+HSQAB32oeQW4Asw/ybtsTnqDxe/w8YQCsMGf8tQpwkMaA7KFBxuwSc+y7gGylqytKh5oOm2DmvPbYOL4bNc10OFhh2bHWX8KnN5quUBTgHpNpGPYhDx2vXGKhXJijhItW+cVwPR/tfD/DQZP5OJfCpVnCoKo7boD+lPDj2fyNgPaLxXJPphOUM9mhtjW1TZ1AJgKkMz3eNzp3pj8yeFJNSw8gM0Ou3KXmNyy6jhXquvt5OgDLSAKzNb8eiFhP70yLuJ7rtW1qv85iF+slaF364R08hcUYYrs8/zyrT1uMtaCX7a5dJhMX13K3pvC5Vxw6g7nanQJ9V5ADbuxxvRN5D406niRDaVS2b5R84FHnTRT6Ex1ksqPHz5pgyey3HJOoNM4sfGbZ7cFoM/EgTglYLzpptDyGtgX7LT2ztJbD8MlCFMZ6c1A8aBDa14TSQ7za8DYq9qJQpycbSPsJtFFa81kxwM5nKiVAIhcZ/9a2RiOYKmGSPcs5SFn8fnmjOTmgn23J/z+5nvB9ursQJ4tU8fuGF+1xVL2Ykqodp1eEIvBzNyNn5NdzwQnU7+sEpoRfyxgPTwWvfWvXBsea8Vry2q2Smgb+j+f0CE5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [High] mm/truncate: unmap full DAX_PMD range in
  invalidate_inode_pages2_range()
- [High] fs/dax: premature disassociation of shared folios in
  dax_can_disassociate()
- [High] fs/dax: stale i_pages entry when __dax_invalidate_entry() skips
  busy folio
- [Medium] dax: cross-file TOCTOU and data race on folio->share in
  dax_can_disassociate()
--

commit cd725b6545b68d39f6ee84c70fd91581edad91be
Author: Zi Yan <ziy@nvidia.com>

mm/truncate: unmap DAX entries before invalidating them

This commit unmaps DAX ranges before invalidating entries in
invalidate_inode_pages2_range() and skips disassociating clean DAX entries
whose last association still has elevated folio references.

> diff --git a/fs/dax.c b/fs/dax.c
> index 94ba41273347c..e448552d8080d 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -527,6 +527,24 @@ static struct page *dax_busy_page(void *entry)
>  		return NULL;
>  }
> =20
> +/*
> + * Determine if an entry can be disassociated. It cannot be if it is its=
 folio's
> + * last association and the folio still has a reference.
> + */
> +static bool dax_can_disassociate(void *entry)
> +{
> +	struct folio *folio;
> +
> +	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
> +		return true;
> +
> +	folio =3D dax_to_folio(entry);
> +	if (dax_folio_is_shared(folio) && folio->share > 1)
> +		return true;
> +
> +	return !folio_ref_count(folio);
> +}

[Severity: High]
Can returning true whenever folio->share > 1 allow a shared PMD folio to be
dissolved while it is still PMD-mapped?

During a CoW write on file A, xfs_file_dax_write() holds XFS_IOLOCK_EXCL
without XFS_MMAPLOCK_EXCL, so a read fault on file A can refault the shared
PMD between the initial unmap_mapping_pages() and __dax_invalidate_entry():

CPU0 (CoW write on file A)        CPU1 (fault on A / truncate on B)
invalidate_inode_pages2_range(A)
  unmap_mapping_pages(A)
                                  xfs_dax_read_fault(A)
                                    dax_fault_iter()
                                      vmf_insert_folio_pmd()
                                      (refcount =3D=3D 1, mapcount =3D=3D 1)
  __dax_invalidate_entry(A)
    dax_can_disassociate()
      folio->share =3D=3D 2 -> true
    dax_disassociate_entry()
      --folio->share (now 1)
                                  dax_break_layout(B)
                                    unmap_mapping_pages(B)
                                    dax_busy_page() -> NULL
                                      (refcount - mapcount =3D=3D 0)
                                    dax_delete_mapping_entry(B)
                                      --folio->share (now 0)
                                      dax_folio_reset_order()
  unmap_mapping_pages(A)
    folio_remove_rmap_pmd()  <-- corrupts dissolved tail page

In addition, if file A holds a GUP pin on the shared folio,
dax_can_disassociate() removes the entry from file A's i_pages while
folio->share > 1, so a later dax_break_layout() on file A will no longer fi=
nd
the entry in i_pages or wait for the GUP pin.

[Severity: Medium]
Can concurrent invalidations on two files sharing a folio race on
folio->share in dax_can_disassociate()?

__dax_invalidate_entry() only holds the current mapping's i_pages lock:

CPU0 (file A)                     CPU1 (file B)
__dax_invalidate_entry(A)         __dax_invalidate_entry(B)
  xas_lock_irq(&A->i_pages)         xas_lock_irq(&B->i_pages)
  dax_can_disassociate()            dax_can_disassociate()
    folio->share =3D=3D 2 -> true         folio->share =3D=3D 2 -> true
  dax_folio_put()                   dax_folio_put()
    --folio->share                    --folio->share (reaches 0)
                                      dax_folio_reset_order()  <-- folio bu=
sy

Both callers bypass the folio_ref_count(folio) check when folio->share =3D=
=3D 2
and then non-atomically decrement folio->share in dax_folio_put(), which can
either corrupt folio->share (a data race) or dissolve a referenced compound
folio when the second decrement reaches 0.

> @@ -853,9 +871,14 @@ static int __dax_invalidate_entry(struct address_spa=
ce *mapping,
>  	entry =3D get_next_unlocked_entry(&xas, 0);
>  	if (!entry || WARN_ON_ONCE(!xa_is_value(entry)))
>  		goto out;
> +	/*
> +	 * Removing the last association of a folio releases the folio, so make
> +	 * sure the folio has no reference.
> +	 */
>  	if (!trunc &&
>  	    (xas_get_mark(&xas, PAGECACHE_TAG_DIRTY) ||
> -	     xas_get_mark(&xas, PAGECACHE_TAG_TOWRITE)))
> +	     xas_get_mark(&xas, PAGECACHE_TAG_TOWRITE) ||
> +	     !dax_can_disassociate(entry)))
>  		goto out;
>  	dax_disassociate_entry(entry, mapping, trunc);
>  	xas_store(&xas, NULL);

[Severity: High]
What happens when dax_can_disassociate() returns false during a CoW write a=
nd
leaves the old DAX entry in mapping->i_pages?

If the folio has an elevated refcount (for example from a short-term GUP pin
or a racing fault), __dax_invalidate_entry() skips the entry and
invalidate_inode_pages2_range() returns -EBUSY.  dax_iomap_iter(),
dax_unshare_iter() and dax_zero_iter() ignore that return value and complete
the CoW remap to a new unshared extent while the old entry remains in
mapping->i_pages.

On a subsequent fault to the now-unshared extent (shared =3D=3D false),
dax_insert_entry() sees a non-empty entry and neither replaces it nor calls
dax_associate_entry() on the new PFN:

fs/dax.c:dax_insert_entry() {
    ...
	if (shared || dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
		struct folio *folio =3D pfn_folio(pfn);
    ...
}

dax_fault_iter() then takes a reference on the old folio from *entry while
passing the uninitialized, zero-refcount new PFN to vmf_insert_folio_pmd() =
or
vmf_insert_page_mkwrite(), which fails with VM_FAULT_SIGBUS.  Meanwhile, the
stale entry left in the first file's i_pages still points to the physical
folio now owned exclusively by the other reflinked file, so truncating or
evicting the first file later calls dax_folio_put() ->
dax_folio_reset_order() on the second file's live PMD folio.

[ ... ]

> diff --git a/mm/truncate.c b/mm/truncate.c
> index 9e9bf029635cf..b03cd99c4bba8 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -732,6 +732,15 @@ int invalidate_inode_pages2_range(struct address_spa=
ce *mapping,
>  	if (mapping_empty(mapping))
>  		return 0;
> =20
> +	/*
> +	 * Invalidating a DAX entry can release its folio, so unmap DAX entries
> +	 * before invalidating them. dax_invalidate_mapping_entry_sync() skips
> +	 * the last association of a folio that still has references, e.g.
> +	 * because it was faulted in again in the meantime.
> +	 */
> +	if (dax_mapping(mapping))
> +		unmap_mapping_pages(mapping, start, end - start + 1, false);
> +
>  	folio_batch_init(&fbatch);
>  	index =3D start;

[Severity: High]
Does unmapping only [start, end] leave PTE mappings in place when [start, e=
nd]
partially overlaps an order-9 DAX_PMD entry in mapping->i_pages?

grab_mapping_entry() and dax_insert_entry() keep an existing storage-backed
DAX_PMD entry in mapping->i_pages when servicing PTE faults (such as in a
smaller or unaligned VMA).  When a sub-PMD write calls
invalidate_inode_pages2_range(mapping, start, end), unmap_mapping_pages()
only unmaps [start, end], whereas dax_invalidate_mapping_entry_sync() ->
__dax_invalidate_entry() disassociates and removes the entire 2MB DAX_PMD
entry covering [index & ~PG_PMD_COLOUR, index | PG_PMD_COLOUR].

If the PMD folio is not shared (or this is its last share), the un-zapped P=
TEs
outside [start, end] keep folio_ref_count(folio) > 0, so
dax_can_disassociate() deterministically fails with -EBUSY and leaves the
stale DAX_PMD entry in i_pages after CoW remapping.  If folio->share > 1,
dax_can_disassociate() succeeds and drops this file's share while those PTEs
outside [start, end] remain mapped, so when the other file drops the last
share, dax_folio_put() dissolves the order-9 folio while its tail pages are
still mapped via PTEs.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-fix-dax-in=
validate-mapped-v1-1-292ce5958d67@nvidia.com?part=3D1

