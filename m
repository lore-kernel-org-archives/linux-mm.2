Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 641AB606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ODEo880n
Received: by kanga.kvack.org (Postfix)
	id 41C566B00EF; Tue, 10 Nov 2026 04:15:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CCFB6B05B0; Tue, 10 Nov 2026 04:15:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BF766B05B1; Tue, 10 Nov 2026 04:15:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E549C6B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:15:55 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 79EC21A042E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:15:55 +0000 (UTC)
X-FDA: 85418652270.25.A0CA693
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id DA6FD140004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:15:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ODEo880n;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302154;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FjEfVvHiE6TItsgfVUv2xXlEv0l2v730UTDllHhPtsM=;
	b=xIB4XsEyV3Bi6stxM6Ux7OnJoLewgIaV7+KLrrMcMgm78NScI1GANGnDc1zOeI1wCpTPYO
	1/EELYtOiBQS1BHn57xJ5LB/iSIgJBmjL4H0ojdnIcUyXdOZPEnGRUo4chArA8HUYeYXOJ
	VQNDictD+fpwVqFweSZgADLkXLlMR84=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302154;
	b=0HICJeyKJLXtQnDyk3AnU1d0u728iP51JvnNb0BgT383iKLCjH8kRI1H1c3cx5wXBlkNvz
	/2uvyOKPhTbGB35eh6ZHVdXt+Vo4NlXmd7n3HJ15SxejIgxmmkCjD5IouTSgxmI6cMng5u
	6OLO3x2Kq6KublCJB3jYO3V4W3c1Ux4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ODEo880n;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 50CA06021E;
	Tue, 10 Nov 2026 09:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1AFC1F0089F;
	Tue, 10 Nov 2026 09:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302153;
	bh=FjEfVvHiE6TItsgfVUv2xXlEv0l2v730UTDllHhPtsM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ODEo880nTW+Sj4ZnJdRYZZ/WyVnqZvULhfLfij8WSbA2h8l492Hr7eLRybcaMNMea
	 JaQVjaJLPwYlZAxbJOUo5dda7PZxkpAgxiA1tZ5HQlwuScVupNQysjewMy2nLXTkox
	 iMVdUqMyCJmrawHtkn97kSrGygRObnr15pnPWE5SR9TMlFpbt8jkJRKk2mDGlehWBc
	 n/QneNoMwFqCSmUYLdN3AtPZYa+PUlOUmFsD/3EDALm+jIbZb7O11cVl3JeyI4nZvB
	 yGSq3il0Hck3jfDjkxnEuaV3uMClLm2MIZR4PvjqAteSkv8B3gg2kJI8B9yhO990eB
	 W40rW+UfIetoA==
Message-ID: <sashiko-outbox-206717@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/filemap: restart mmap readahead on sequential faults
 after many misses
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gopal Malaviya" <gopalmalaviya53@gmail.com>, akpm@linux-foundation.org, willy@infradead.org, jack@suse.cz
Cc: linux-mm@kvack.org, fujunjie1@qq.com, vishal.moola@gmail.com, roman.gushchin@linux.dev, Trace <tracekotae@gmail.com>
In-Reply-To: <20261109091444.128521-1-gopalmalaviya53@gmail.com>
References: <20261105192517.228523-1-tracekotae@gmail.com>
 <20261109091444.128521-1-gopalmalaviya53@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 09:15:49 +0000
X-Stat-Signature: kk65yp94iwjnbub4u4twig7eunpngrg6
X-Rspamd-Queue-Id: DA6FD140004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794302153-926020
X-HE-Meta: U2FsdGVkX1/k/g6qAsQspis8XYcZXOJUlwwArhfqq+pg5jIwztzfiz4r6z08lrlUFzofzngA8oC7z/iDKo2tjM8AGc6kmEeJJmYXGvfXf4sl3VKcLJ0Z7wS8qofPXw7l5QmEc6/4OvO8RBRiVxpkN/lylZyXjlE1olxWBVWBsFy0cmQfiV7lD2aQQ2rYvPMrf2dg0kBFCcQZyRuObuZWF6DfRqZcDT6xROLH7sP4ET/T9s889y45yaWGuGJ4Z9WOE+4JqpBiYg8IuLGaZ/q+nQpKWbPKGeeRA31Cmr8f2Fgqli2/NV/64AUGmerwRPjSkzPqd/5kTJ4YT+Z4Wjj5U3IfPT8b+SOm0oJEHkmfrBY7IdXmfC+JBGDLoV0mU+wDLQCJUCqY5/EU1QlCoZAJVUdQRr9rJ5GoXPScBpH+Gu9Z/IIFMhllfT1J47NoKQYaYL/6JBlKaHwvGRE9/cZoyrgf1zTalfIfGXgwj3+EFGjO4xdgCuvv+lL8gaDumOM6qbJqh8koHpvZswDGQs+opUVDlurJd3p0edToQm+WHs60u1D1zJAOH+F/4Gyh3HBd4tqjlv0Kw8j+IH42/0xgpZJ1QCDxYTJSUxtqfXB3BRbKg1vLgOU+UIWNmnbxW8Xo2UpEvyjFl1mmh3LGGtUjJCcv370oxMX1MfcbwHGA0zgfo+Jg8h+NamJR7+jEalyDhINs28JRWb9y/8VsdOri85vVaRy2eZpDZyRhoa3xqDSl1RuhqvpAjMpGV4jaaERilah0+CbS6X2fmS4/eJusrGvAcvDwoV0VCiLg9vFOB68QJXGgW6lNz8vJNEGp4m1GaVSMun4bQ0zKe8AHEIzPQXdh6ecygHR+KCkCJLFiNJFighnbjNITFmEVX/x12u5rbMoL2RWJD4arWbeFRWEGsoJUHyX0OuJnDDswykJkrJRcKmvc9311gMB3LTvXz3eoMEasJuPXFM36R9IyktS
 +Oxb8L89
 e30TeoxmQzGKLTSKwQaDbEAmyIIgI6VRuylz0375/WUOCnu+o0UVg07UPcnMHOw8rlXxNIizIoRRTwG7MiB5/pZwaMgPA8D6CxbbVBMRFkU+pQSvOrMMkdF6PJuwvXEiP8nlY1weoCRqSCKgLPRYAgoxnuf711enZ2uaGHN3ROSKBLJE/FN7b2gMh7Brjgiky1NdfdeNbQ7e7xPcw5i9RFFO7clhoabWGR6tqwBAgTmHPYOJPnXYEwJg2g8tpn5NjehwUVYoB2S23SXubyNrO3U0Zl4U3TuP7cwgtZA8ItY3P5ALJzBUNjNxhAY2az0uCImW3qqkW2VXSbZDU5qls/NnzAfJXa+js4/v+2hKD1A/AYLAT2AlB9TJlkx7jHV6fVc3dc8d8Po8zeWMwVzJHO3EKahyfBsXfulmu/YZ7KwXZBLWNlJzoAAx50QW4LMly5kYnk8Cx5yC9mBkPWPo8fQ7hhD/h26EgJWH0KLWuL1ky94FWO/ytZhPW6KKDdWNJ2qThQ5On5ghUiDJujykfeH9B4k7aACL4gcKVD39R++W5cgeSkS+Wz1hkkd9BlVxLCZIzmJKm6eAN99GnG4YWk1JA635g35HL/tg/4MmXQzmMPCzXyK4WGGiKBP22hIiGCJ1ELZB0w6IlomxwpxVioFYc4ErTN858oQvt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] mm/filemap: do_sync_mmap_readahead() recovery fails when
  min_order > 0
- [Medium] mm/filemap: do_sync_mmap_readahead() ignores VM_RAND_READ and
  !ra_pages
- [Low] mm/filemap: prev_pos =3D=3D -1 wraps to match pgoff 0 on 32-bit in
  mmap ra
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [Medium] mm/readahead: unsigned underflow of index - start in
  page_cache_ra_order() [1]
--

commit 607714545f8f33b9040290a1fe8d984f2caffeba
Author: Gopal Malaviya <gopalmalaviya53@gmail.com>

mm/filemap: restart mmap readahead on sequential faults after many misses

When mmap_miss exceeds MMAP_LOTSAMISS in do_sync_mmap_readahead(), this
commit records the fault offset in ra->prev_pos and calls
page_cache_sync_ra() if the next fault miss lands on the immediately
following page, while clamping ra->mmap_miss to MMAP_LOTSAMISS * 10.

> diff --git a/mm/filemap.c b/mm/filemap.c
> index 371a4bbd06876..1548021472729 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3398,9 +3398,27 @@ static struct file *do_sync_mmap_readahead(struct =
vm_fault *vmf)
>  		/*
>  		 * Do we miss much more than hit in this file? If so,
>  		 * stop bothering with read-ahead. It will only hurt.
> +		 *
> +		 * But without read-around no hits are left to bring
> +		 * mmap_miss down again, so a file that turns sequential
> +		 * would stay without read-ahead. Remember where we missed,
> +		 * and treat a miss on the next page like a sequential
> +		 * read() miss: page_cache_sync_ra() starts with a small
> +		 * window and only grows it while access stays sequential.
> +		 * Keep mmap_miss at its limit, so that hits on that window
> +		 * do not bring back full read-around for random access.
>  		 */
> -		if (mmap_miss > MMAP_LOTSAMISS)
> +		if (mmap_miss > MMAP_LOTSAMISS) {
> +			pgoff_t prev_index =3D (unsigned long long)ra->prev_pos >> PAGE_SHIFT;
> +
> +			ra->prev_pos =3D (loff_t)vmf->pgoff << PAGE_SHIFT;
> +			if (vmf->pgoff - prev_index !=3D 1)
> +				return fpin;

[Severity: Low]
On 32-bit architectures, can a fault at vmf->pgoff =3D=3D 0 match
vmf->pgoff - prev_index =3D=3D 1 when ra->prev_pos is still -1?

file_ra_state_init() initializes ra->prev_pos to -1, and mmap faults while
mmap_miss <=3D MMAP_LOTSAMISS do not update it.  When the first fault with
mmap_miss > MMAP_LOTSAMISS lands on pgoff 0, truncating
(unsigned long long)ra->prev_pos >> PAGE_SHIFT to a 32-bit pgoff_t yields
prev_index =3D ULONG_MAX, so 0UL - ULONG_MAX =3D=3D 1UL wraps around to tru=
e and
starts readahead on a non-sequential miss.

> +			WRITE_ONCE(ra->mmap_miss, MMAP_LOTSAMISS * 10);
> +			fpin =3D maybe_unlock_mmap_for_io(vmf, fpin);
> +			page_cache_sync_ra(&ractl, 1);
>  			return fpin;
> +		}
>  	}
> =20
>  	if (force_thp_readahead) {

[Severity: Medium]
Does this readahead recovery work when mapping_min_folio_order(mapping) > 0?

When the first miss above MMAP_LOTSAMISS returns without readahead,
filemap_fault() -> __filemap_get_folio_mpol() allocates a folio of
min_nrpages =3D mapping_min_folio_nrpages(mapping) base pages (at least 2).
During a sequential scan starting at a folio-aligned offset, the next cache
miss occurs at prev_index + min_nrpages, so vmf->pgoff - prev_index !=3D 1 =
is
always true and readahead never starts.

Even if the initial miss was on the last base page of the previous folio so
that vmf->pgoff - prev_index =3D=3D 1 holds, passing req_count =3D 1 instea=
d of
mapping_min_folio_nrpages(mapping) to page_cache_sync_ra() sets mark =3D
index + 1 in page_cache_ra_order().  In ra_alloc_folio(),

mm/readahead.c:ra_alloc_folio() {
    ...
	mark =3D round_down(mark, 1UL << order);
	if (index =3D=3D mark)
		folio_set_readahead(folio);
    ...
}

rounding mark down by 1UL << order places PG_readahead on the first
(faulting) folio instead of the next folio.  Because
maybe_unlock_mmap_for_io() drops mmap_lock, the retried fault runs with
FAULT_FLAG_TRIED set, skips do_async_mmap_readahead(), and maps that folio
via finish_fault(), so page_cache_async_ra() is never called to grow the
window.

[Severity: Medium]
When force_thp_readahead is true, can this block run page_cache_sync_ra()
even when VM_RAND_READ is set or ra->ra_pages is 0?

do_sync_mmap_readahead() only checks VM_RAND_READ and !ra->ra_pages when
!force_thp_readahead.  Once mmap_miss exceeds MMAP_LOTSAMISS on a
VM_HUGEPAGE VMA backed by a mapping with large folio support, two adjacent
misses reach this path: with VM_RAND_READ, page_cache_sync_ra() only checks
FMODE_RANDOM and issues multi-page sequential readahead while setting
PG_readahead on a folio that do_async_mmap_readahead() refuses to clear;
with !ra->ra_pages, maybe_unlock_mmap_for_io() drops mmap_lock and forces a
VM_FAULT_RETRY cycle only for page_cache_sync_ra() to do a single-page
forced read.

[Severity: Medium]
This problem wasn't introduced by this patch, but in page_cache_ra_order()
[1], can index - start underflow when an unaligned readahead request
fails on its first folio allocation?

mm/readahead.c:page_cache_ra_order() {
	pgoff_t start =3D readahead_index(ractl);
	pgoff_t index =3D start;
    ...
	ractl->_index =3D mapping_align_index(mapping, index);
	index =3D readahead_index(ractl);

	while (index <=3D limit) {
    ...
		err =3D ra_alloc_folio(ractl, index, mark, order, gfp);
		if (err)
			break;
		index +=3D 1UL << order;
	}
    ...
fallback:
	if (ra->size > index - start)
		do_page_cache_ra(ractl, ra->size - (index - start),
				 ra->async_size);
}

On a mapping with mapping_min_folio_order(mapping) > 0, start holds the
unaligned readahead_index(ractl) before mapping_align_index() rounds index
down to a min_order boundary, making index < start.  If the first
ra_alloc_folio() call fails (for example with -EEXIST when a folio is
already cached at the aligned index), the loop breaks before advancing
index, so index - start wraps around near ULONG_MAX and skips the
do_page_cache_ra() fallback for the entire window.

[1] https://sashiko.dev/#/bug/linux-da6e8836-f808-4b39-9f04-de52995a0162

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109091444.1285=
21-1-gopalmalaviya53@gmail.com?part=3D1

