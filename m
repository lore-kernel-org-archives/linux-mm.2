Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CE2A606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 17:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D/zm1wJU
Received: by kanga.kvack.org (Postfix)
	id 917176B05B2; Thu, 12 Nov 2026 12:51:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0DA6B05B3; Thu, 12 Nov 2026 12:51:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 768686B05B4; Thu, 12 Nov 2026 12:51:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1DE2D6B05B2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:51:51 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 30B081204AF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:51:51 +0000 (UTC)
X-FDA: 85427210022.02.3232226
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7DD1BA000C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:51:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="D/zm1wJU";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794505909;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5kFpSJN8OkTb3Crd0koXg3j7fn51mbBO5BVZ7kz15qw=;
	b=5eWY8x5foMHsd0k21tB9h5yU4fmE5bV/VcJ9irEvw+7+dL7VvzCPebR8OMQHY0c16TsI2K
	FQB0syEUA8ENOFA3CnV4Vgpt8DJYFNQ6X6flRHrfgs66tmpScUc28Ou+rhC+eU9mzVuApH
	e6RFtvtMIcISVWsiUCNEpiHr6defY50=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="D/zm1wJU";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794505909;
	b=o+P6GhtyrtE+yCbWfOBRBRP9SXdZDVXL665oY5GO8sqAO+zkDieNRVFpuCuTdp0JLuqcps
	sIi6/4aCN/778RpDaIMHTGl2WoqKD/jLtl0e1Ujie8TsSmPEBmEGJOYEkRLijUxEZpiLnP
	fCFkfcyeQXcKF8+4MGYAeqR2r6TJtFE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CF25A45E4C;
	Thu, 12 Nov 2026 17:51:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F851F000C8;
	Thu, 12 Nov 2026 17:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794505908;
	bh=5kFpSJN8OkTb3Crd0koXg3j7fn51mbBO5BVZ7kz15qw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D/zm1wJUu03vLBSEtkKyBN7YppYT8saCb8X8lDgpIkwaUuhMvWbrj0esAqA1O6y+N
	 DEjPJ1UMTidnCgadLWJhAr+vJyrfxv4FgWP+cRFOt4TTAmlMYcqsUgg8EkaCMi9rcD
	 T/bbqigYJW0e4QLAFmF/B+HOmq9XfCeK6z6OQk1j7FmNdSrluP3XzAaaP5bqRomQMD
	 lUefCQ2xoyY1RzFUCRsG2JCoTFX6YRzZ7DtdQeUIW8VGCKn6xveVS0Iuy3jTwE2fZj
	 Fn2j6bOIFqGoqoaYICZC5EMC8EFQjLdYuGlkDHiyb0kmnuhKeb2JhKi+8vWOCJDw5X
	 gwAvDiouOLTAQ==
Message-ID: <sashiko-outbox-211635@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 7/8] mm/khugepaged: hoist more code into
 collapse_isolate_folio()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pedro Falcato" <pfalcato@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Zi Yan" <ziy@nvidia.com>
Cc: "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, "Nico
 Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Kiryl
 Shutsemau" <kas@kernel.org>, linux-mm@kvack.org
In-Reply-To: <20261111175121.1328383-8-pfalcato@suse.de>
References: <20261111175121.1328383-1-pfalcato@suse.de>
 <20261111175121.1328383-8-pfalcato@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 17:51:47 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7DD1BA000C
X-Stat-Signature: f445aastut3h6dwo3xaxmo1kho9u8p14
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794505909-676843
X-HE-Meta: U2FsdGVkX19y606haghsRqU3cIwS1GOv8b9vrtBxnEg42yFkIoPv7huzG2On+cAsfysdQPc4pHE8LYeZm1Kko9W3hTVNwk2HTkhia6fkG1vnZrVoM8qYm1yyefWt9Kg7KsWrQ4J+t3/71crSYKL8e4YqEb9FRgVOKoeghwBeRJiMMai26WK060w5mCMai+6etsxA4+DVmB2jdEhnK8vpPz6Ls10Nl6X6n78Vgs3MQKlN+5p8EQvttkjRhd1fb3rZndl+YCo0Jz3McJ2sT3pKt8IwcWTmEQUkwfeFzRHioHek7CL1z7RQD3R3cO5Alm+bF5HCFjI+GEVe1PImk7hfVczl9f5xLNf8DcZVRwymT0XvxCBybRUOezEoXJAE4IwkbjBGkDJhqorcbVFowElV1Pg7NGuVAxYcESEX878anj/5pGVNTQ4LnkQZD77urN75iuMdc0y2Re0f+3ynb8UnmK7MnOj65nrI65ZMRf8wXGaqYq++09EEa/BkO596GnmSSB2kxSfk80nkl2Do7lsv0kYa9pd0c6+xC1apG3D451py3rtLK4LjE52Z8wfBS+AqVAlCjzx157Lu4C1h12E8il/l3tHRKSmSd0+q2cMbhezrEp/bnq7t1ZvUGPoiQHNHFFDBhXwf3uAGP0MLzNPj09HxXq+HZW4E7x7KWsqwjggoK+mi4UBzrgMOvAWPuhF0uCH13U+QeU8EgLdKL055vF/fDAp0r1rASSVFErfiW5p2NT/lWJfkAdBXpT7koEFPzQP7ag4W2KAoeShLIjhfAn0iqBuyW+Kpzu+GF9Ia6MeX4p5W4tL2g3B5/a9rI/dq7jOtu7UwtC0QeSoYfPW4ew2rc4ehL1RHxhuj54Y/q4H7tYwNzSl2EdfMbbLen1h67i7wgQFP0B6pRcRAuAzM2wDF9OsB7q5XACuAIs5vjpw+YciSTvr54CrsMrn3++Ly19L07ijkcEBSpYA8RlI
 dviNhxS0
 aFRYexbAzy/mtNKGDtxarzo5Ucq6pt3Rw8PqWhY1r/qijR22uEHAiRANXIeK3CGD5l3ZAI21SvN+KK1QKCoXVpoOrAPmKa8SgJFiipkR4JFT5oYAkdSinOOwTSDZzuGtFVbpLIpsixzcBzaGUjQPdufQRjttHJOnLSb+mJMiRvh61sWUF7RoXRxzzYuvslSdSy3uvlgaH6ngrV9JpOt1EVKBGPCvzTdiA9qWKyv92iBzmTjqFXSG8VLNPpq83J69zX3Bx6PHPkjjhQe3NVTfNkSocrn70oKAoAFkpzqqiPFMKPEfVh3kuMxD6gZVZ7JRHsg0x+ultfxaNX3gpQaod1PfhjGmNwZUsvVhURkA46CGLA+IonDEmHL+qWTbmdwP5mVOviQk2AGhrJ1aLvfbeQaEHGjM3qdl8FONX16Sum/T0MdLdOXs68ALy0SvKVcl32uu/p4XZyimWvSLbTiMhKA2NIbP9OBjwahy8yjn9rFlmigRISdcfvSb2AUL4TVUvJLs/3x2pGWAzJut3TqGYonKp9GZDKOPC71wD5DCM1YM8lEkJxSq5V99iY6NkDZX3VmROz2ZqFOa60W3HQteSACiujOHtb1ugZ0Y3Otxg5Nx54Fc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] mm/khugepaged: missing smp_rmb() in collapse_isolate_folio()
--

commit 1a6c61868f8e8d364cc5be77c89e1e39fd7f5a4a
Author: Pedro Falcato <pfalcato@suse.de>

mm/khugepaged: hoist more code into collapse_isolate_folio()

This commit moves the folio reference count and dirtiness checks from
collapse_file() into collapse_isolate_folio(), performing them outside the
i_pages xarray lock.

> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 1e58ae5b3e74d..accd8b4895d30 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2404,13 +2404,53 @@ static enum scan_result collapse_isolate_folio(st=
ruct collapse_file_state *state
> =20
>  	if (!filemap_release_folio(folio, GFP_KERNEL)) {
>  		result =3D SCAN_PAGE_HAS_PRIVATE;
> -		folio_putback_lru(folio);
> -		goto out_unlock;
> +		goto out_putback;
>  	}
> =20
>  	if (folio_mapped(folio))
>  		try_to_unmap(folio, TTU_IGNORE_MLOCK | TTU_BATCH_FLUSH);
> +	/*
> +	 * We control 2 + nr_pages references to the folio:
> +	 *  - we hold a pin on it;
> +	 *  - nr_pages reference from page cache;
> +	 *  - one from lru_isolate_folio;
> +	 * If those are the only references, then any new usage
> +	 * of the folio will have to fetch it from the page
> +	 * cache. That requires locking the folio to handle
> +	 * truncate, so any new usage will be blocked until we
> +	 * unlock folio after collapse/during rollback.
> +	 */
> +	if (folio_ref_count(folio) !=3D 2 + folio_nr_pages(folio)) {
> +		result =3D SCAN_PAGE_COUNT;
> +		goto out_putback;
> +	}
> +
> +	/*
> +	 * At this point, the folio is locked and unmapped. If the PTE
> +	 * was dirty, try_to_unmap() has transferred the dirty bit to
> +	 * the folio and we must not collapse it into a clean
> +	 * file-backed folio.
> +	 *
> +	 * If the folio is clean here, no one can write it until we
> +	 * drop the folio lock. A write through a stale TLB entry came
> +	 * from a clean PTE and must fault because the PTE has been
> +	 * cleared; the fault path has to take the folio lock before
> +	 * installing a writable mapping. Buffered write paths also
> +	 * have to take the folio lock before modifying file contents
> +	 * without a mapping, typically via write_begin_get_folio().
> +	 */
> +	if (!state->is_shmem && folio_test_dirty(folio)) {
> +		result =3D SCAN_PAGE_DIRTY_OR_WRITEBACK;
> +		goto out_putback;
> +	}
>  	return SCAN_SUCCEED;

[Severity: High]
Without xas_lock_irq(&xas), can the folio_test_dirty(folio) load be
satisfied before folio_ref_count(folio) on weakly-ordered architectures?

A concurrent holder of a temporary reference or pin (such as direct I/O
read completion into a file-backed buffer) can mark the folio dirty and
drop its reference without holding the folio lock:

CPU0                                  CPU1
collapse_isolate_folio()
  [speculatively loads folio->flags:
   folio_test_dirty(folio) =3D=3D false]
                                      folio_mark_dirty(folio)
                                      folio_put(folio)
  folio_ref_count(folio) =3D=3D 2 + nr
  return SCAN_SUCCEED                 <-- dirty folio collapsed as clean

Previously, holding i_pages.xa_lock across both checks serialized against
__folio_mark_dirty(), as noted in __remove_mapping():

mm/vmscan.c:__remove_mapping() {
	...
	 * Reversing the order of the tests ensures such a situation cannot
	 * escape unnoticed. The smp_rmb is needed to ensure the folio->flags
	 * load is not satisfied before that of folio->_refcount.
	 *
	 * Note that if the dirty flag is always set via folio_mark_dirty,
	 * and thus under the i_pages lock, then this ordering is not required.
	...
}

Because folio_ref_count(folio) and folio_test_dirty(folio) are plain reads
of different struct folio members with no barrier between them, reordering
them allows a newly dirtied file-backed folio to be collapsed into a clean
PMD folio, losing the modified data on reclaim and leaving dirty page
accounting elevated.  Adding smp_rmb() between folio_ref_count(folio) and
folio_test_dirty(folio) (matching ttu_anon_lazyfree_folio() and
__discard_anon_folio_pmd_locked()) would preserve the ordering.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111175121.1328=
383-1-pfalcato@suse.de?part=3D7

