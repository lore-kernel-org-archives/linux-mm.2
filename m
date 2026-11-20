Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A551A606A333
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 19:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tl5fHy7u
Received: by kanga.kvack.org (Postfix)
	id C0F2D6B00EF; Fri, 20 Nov 2026 14:22:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBFBD6B05B0; Fri, 20 Nov 2026 14:22:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD5AA6B05B1; Fri, 20 Nov 2026 14:22:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B97E6B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:22:42 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 15380A7139
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:22:42 +0000 (UTC)
X-FDA: 85456469364.01.5BDCE09
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5F71FC0003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:22:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tl5fHy7u;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795202560;
	b=Ao3tz1uFGHT2tElloS/YOg376yxRNQx3i82ww34kkUSmwaRFBrTeZiog2lAtOkZOLgRGyj
	5SmSNP++ZSiVUQGC/M/oWZgXKURg/YGzorBz5qCHGZhgCkBhitJNXVKutyd2FSWS3yuQBo
	vXt2YtPnTU+t1jPUwHFNgWVjiqneSIM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795202560;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lo9W3l+M35Js/gSurx5HD3GUhzTLhnFuZqKTD/u6pl0=;
	b=jwQyc0Zjv8YgubZnRxfrrtQifKc+j7rZ2hxiRmmoSj5b80BNecLjd1GFC0ySa5pKu7sArQ
	tvaE56WjPdZyyb10CJmzMehWeFjvLdZ25c9w/PIfBRA+/9BUrwvYkqbZfjIGQkFAas7QV/
	S6xFJMYtHNeym39nX7lx/ThFvCw24Kw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tl5fHy7u;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 836CC43A72;
	Fri, 20 Nov 2026 19:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01EC31F000C4;
	Fri, 20 Nov 2026 19:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795202559;
	bh=lo9W3l+M35Js/gSurx5HD3GUhzTLhnFuZqKTD/u6pl0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Tl5fHy7uInn3q6/j4L1nw9oUYewiDd98LdEgtwcJeYyVEwetsSZWYyWJkohS3AP5R
	 rE+XD5RYrCg1QZENMIOQxnVCjz2CpyucDsxpk40UbDSEoJ14MKchK/J70cb78IRFtZ
	 M5nrvtH3DlBA+moJUDtId/wRIlXp+vcaKqsGyJHKMfOg64bfgXrZvlWfy6vaeD8CZU
	 cEVMXJ/wa8+uyiJzcAq7tZcxH3rrWjO2v+P/phsahIhe6CpILHbdC/jiQvJut5L7EL
	 dS8NNZPuDc1iNTFi9I/PCaeHHjFbIFgj5UARD87tcN2gkDGfaCM85mDFWwSbMJuDtv
	 OseGZRz23ZADA==
Message-ID: <sashiko-outbox-225922@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] hugetlbfs: respect F_SEAL_GROW and FMODE_WRITE before
 growing i_size in mmap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dominik Maier" <dmnk@google.com>, "Muchun Song" <muchun.song@linux.dev>, "Oscar
 Salvador" <osalvador@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "David Hildenbrand" <david@kernel.org>, linux-mm@kvack.org, dmnk+artist@google.com
In-Reply-To: <20261119192209.2651562-1-dmnk@google.com>
References: <20261119192209.2651562-1-dmnk@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 19:22:38 +0000
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5F71FC0003
X-Stat-Signature: ihzya8xqxenkxewqkdj91imbuwq3yoq4
X-Rspam-User:
X-HE-Tag: 1795202560-976911
X-HE-Meta: U2FsdGVkX190n7ftXLX9KmbEtBRuoEK+9xPNuNPaO3z/l5d7fGmJ+BuAk/iEPdM+KLOasnK2rI2UhcaWPs6Hql2k+Ye0Zz/a78577CbGYEweL6t30UBOx6Zqn1DGCbsrmwGKr0a3ok7y9hRCr8xOXvURwumJIkY2EMvTlfLcAWwi7viHJ4hdafVV++CC+v4oKT8A4nJVRhNWUxbouApvqrk/LCqJzPyF24R1jguSnkfUkGPflgsitm31H9pI/sS7DAo3Vy6Jtjp9hnOGOClgjBTT9ZmFhnBI0r3f5prBl+Kv5ntsfWETz5uFr2jy5yFv0JZC5EwxdpJM2EWcLtT1IgRxSiKJP/P41YHf43qyQc20FvcDJEQ47VJgH/vNtu7aooFU565g/kYEsUzEFskBIDMSNMFHwe0ZuyxFbndAt6DdpG9spUCJG+dsaYYByg5ZvgNOv+amUwUNHr2YK3TBJHiHb485HHMnSZ7dfwO6gjh1CufSGvi9cri36azfXs7RPKnAc4RTHydj66AO49UyGwMEnbxSJEmJUyTsqW6rGq08ySsVpUD+fDMr0mLZiYujTw8F0Ym6B4m0Ng9OwelXfNCzIj6ax22iyywRQqI5L+THdqeW6GG/yG6xFCqW5gGTEY9LS6z3bczjaSG7Kp9s/zka4FWL6x1sNSRARY2SBMLtvo7A8Zw2QGwpW8R3aUp7u21SzjL9ml24ekYYxX01qzPFc6AhGSUfmFDKbMxh2ekU5OI4OF25l6nP8HZt0RB0DNJe0+dVRzNNKG7MLuXR4uDV9yRzizWZojVInZZAfBHX/FbKsJdPUc+4IeHszcSU6ZaDq0D8yfz3GdjJzb13muj29v87nziMNuHMfU1KTJ8+wnZKeLAJPV7nj+amdv8SHcv/G92nIiACQ/R/YV4dLBWjoLfc2XskXtf7AenNQdvXwDo9U59xiHzIWhGNncvEgO199yb7IXR7veyKbgH
 RkfEGzUk
 qsKjjTBSXWjMtge+oTcXdGOG7FbnZZs5SXyqdMnSgucigLOvOD6Ys9AAs85lpaIl8siA1FU300BK8t7F+xZNyZ+xrUsxhECw7K+P7fFAfPh+ZGxxTiWalNE5gIoCMUq9aQm26mQpCXz2EiemJM3AFzoAV9Kh6s3YjznO66VooZyI8IeJUTsdVwfqqiUUQa03PhwlE0Eb+a58P2iwxMGzYb1buKOusXMAaIrxXixFOsyUBMfjYmk4gRO5afylhTXG+cdiZra9C+Y3UB4fwo6qWhKJDIpw0yzHGrVAEMqXKiC8dVDzHMzAgnFWkdFPmAZ0o4v1Scd+gOiQM5y1GDt9/rXEEOxLB5h7HAiriL+UPEgWffmfzeLgaWwrBTNTXszwadTBnjZN+dsMAAoZC/lRS0xfYg6kbNs+liUHGn9N4g3Nm/q6NoeVIaxg/ICv1M8FdtWQR4rQ/8lHh1ZeO1Y5H47Uy3J30Csy9PE048F4DOk1IJXPUIYen7o6XbAzQi73HsxwCTUdjtpnEbTgVPnk95XEypBtr+Qtf9KA4YeolzYBMtL9erMpOy+UQj0AytSizkv1VFMm3i1EKyQjr/+3j77nsmw1QnvHMpyYdSrncVTewlMcE70TRggT2KF5PI+qsSIrzTfmTMtdJ80yrpGL7VwtJQJddMjKsvJx/P5CkEgMtjoURCdvAH1QKrC+HPi54mRfh8dg45N4+5C/gqO1R8y3I0G/rSx9syyttmu/cCeNS81dxl70DQn36m2kEzX5pmrrv9jSMxmGXrjMLv0QzqnRk9GsJMUHJ7OZcGx9OtPtiHpPuTnUbmU2G3CNGxuby0ggGUu8slnRqj/CeTrTAJ/RxbqRVet4o9yBt3hRByXI7eE4KDazRJl9uafGsLWNTFxbTlsYIadgVNOimJYzRiWJ43/7Meh4AtzyRZAwZ4iyL7VXVoZPXb1S5bPR045HZK068d6lo7L0AKpl/BHtdzQTNAtVx
 zY/ygSld
 kxTXLETibwQgIfV1x7OEvg==
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
- [Medium] hugetlbfs: non-fatal inode_newsize_ok() in
  hugetlbfs_file_mmap() sends SIGXFSZ
- [Medium] hugetlbfs: missing write-seal check in hugetlbfs_file_mmap()
  shared branch
- [Low] hugetlbfs: inaccurate Fixes trailer 045c7a3f53d9 for MAP_PRIVATE
  i_size growth
--

commit 9d1ca8a773e4ed12af22f0ee1ea69a706da80ecd
Author: Dominik Maier <dmnk@google.com>

> hugetlbfs: respect F_SEAL_GROW and FMODE_WRITE before growing i_size in m=
map
>
> hugetlbfs_file_mmap() expands inode->i_size whenever VMA_WRITE_BIT is set
> and len > inode->i_size, without checking whether a shared mapping
> violates F_SEAL_GROW or inode_newsize_ok(), or whether a private mapping
> holds write access to the underlying file and has no active write/growth
> seals.
>
> Because do_mmap() and memfd_check_seals_mmap() allow PROT_WRITE with
> MAP_PRIVATE | MAP_NORESERVE on O_RDONLY descriptors and sealed
> MFD_HUGETLB memfds, an untrusted IPC recipient holding a read-only or
> F_SEAL_GROW-sealed hugetlb descriptor can inflate the shared
> inode->i_size to multi-terabyte values even when vm.nr_hugepages is 0,
> causing trusted peers relying on F_SEAL_GROW to hit SIGBUS past the
> allocated pages. Similarly, MAP_SHARED | PROT_WRITE beyond i_size on an
> F_SEAL_GROW memfd (without F_SEAL_WRITE) bypasses the growth seal.
>
> For MAP_SHARED | PROT_WRITE mappings with len > inode->i_size, reject
> F_SEAL_GROW with -EPERM and enforce inode_newsize_ok() before reserving
> huge pages. For MAP_PRIVATE | PROT_WRITE mappings, keep allowing the
> private VMA itself while only expanding inode->i_size when FMODE_WRITE
> is set, no growth/write seals are active, and inode_newsize_ok()
> succeeds.
>
> This issue was discovered with an AI-assisted code review tool (ARTIST)
> and reproduced in QEMU/KVM on an unmodified v7.4-rc3 kernel without
> kernel modifications or error injection; a standalone reproducer is
> available upon maintainers' request. The fix was verified against the
> reproducer in QEMU/KVM, compile-tested with -Werror, and checked with
> checkpatch.pl --strict.
>
> Fixes: ff62a3421044 ("hugetlb: implement memfd sealing")
> Fixes: 045c7a3f53d9 ("hugetlbfs: fix offset overflow in hugetlbfs mmap")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dominik Maier <dmnk@google.com>

[Severity: Low]
045c7a3f53d9 ("hugetlbfs: fix offset overflow in hugetlbfs mmap") only
converted inode->i_size =3D len to i_size_write(inode, len).  The commit
that allowed MAP_PRIVATE | PROT_WRITE mappings on O_RDONLY descriptors to
reach the i_size expansion was 1e8f889b10d8 ("[PATCH] Hugetlb: Copy on
Write support"), which removed the early check rejecting writable private
mappings.

> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index ca63a530a26a1..c75f9ea4c9043 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -100,10 +100,12 @@ static const struct fs_parameter_spec hugetlb_fs_pa=
rameters[] =3D {
>  static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct =
*vma)
>  {
>  	struct inode *inode =3D file_inode(file);
> +	struct hugetlbfs_inode_info *info =3D HUGETLBFS_I(inode);
>  	loff_t len, vma_len;
>  	int ret;
>  	struct hstate *h =3D hstate_file(file);
>  	vma_flags_t vma_flags;
> +	bool grow_inode =3D false;
> =20
>  	/*
>  	 * vma address alignment (but not the pgoff alignment) has
> @@ -139,6 +141,24 @@ static int hugetlbfs_file_mmap(struct file *file, st=
ruct vm_area_struct *vma)
>  	inode_lock(inode);
>  	file_accessed(file);
> =20
> +	if (vma_test(vma, VMA_WRITE_BIT) && inode->i_size < len) {
> +		if (vma_test(vma, VMA_SHARED_BIT)) {
> +			if (info->seals & F_SEAL_GROW) {
> +				ret =3D -EPERM;
> +				goto out;
> +			}

[Severity: Medium]
Should the VMA_SHARED_BIT check also reject F_SEAL_WRITE and
F_SEAL_FUTURE_WRITE under inode_lock(inode), like the MAP_PRIVATE branch
below?

memfd_check_seals_mmap() in do_mmap() checks seals without holding
inode_lock(inode), and memfd_add_seals() only calls
mapping_deny_writable() for F_SEAL_WRITE, not F_SEAL_FUTURE_WRITE:

CPU0                                  CPU1
do_mmap()
  memfd_check_seals_mmap()
                                      memfd_add_seals(..., F_SEAL_FUTURE_WR=
ITE)
                                        inode_lock(inode)
                                        *file_seals |=3D F_SEAL_FUTURE_WRITE
                                        inode_unlock(inode)
  ...
  hugetlbfs_file_mmap()
    inode_lock(inode)
    if (info->seals & F_SEAL_GROW)
    ...
    i_size_write(inode, len)  <-- bypasses F_SEAL_FUTURE_WRITE

A concurrent MAP_SHARED | PROT_WRITE mmap() can therefore bypass
F_SEAL_FUTURE_WRITE after the seal has been committed, growing
inode->i_size and creating a writable shared mapping.

> +			ret =3D inode_newsize_ok(inode, len);
> +			if (ret)
> +				goto out;
> +			grow_inode =3D true;
> +		} else if ((file->f_mode & FMODE_WRITE) &&
> +			   !(info->seals & (F_SEAL_GROW | F_SEAL_WRITE |
> +					    F_SEAL_FUTURE_WRITE)) &&
> +			   !inode_newsize_ok(inode, len)) {
> +			grow_inode =3D true;
> +		}
> +	}

[Severity: Medium]
Does calling inode_newsize_ok(inode, len) as a non-fatal condition in the
MAP_PRIVATE branch send SIGXFSZ to current while still succeeding?

When len exceeds rlimit(RLIMIT_FSIZE), inode_newsize_ok() calls
send_sig(SIGXFSZ, current, 0) before returning -EFBIG.  Because this
branch ignores the error and continues, a MAP_PRIVATE | PROT_WRITE mmap()
on a writable, unsealed file delivers a fatal-by-default SIGXFSZ even
though mmap() returns 0.  If SIGXFSZ is caught or ignored,
hugetlb_reserve_pages() still reserves private huge pages for the full
range up to len without growing inode->i_size, and faulting those pages
later fails with VM_FAULT_SIGBUS in hugetlb_no_page() because vmf->pgoff
is past i_size.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119192209.2651=
562-1-dmnk@google.com?part=3D1

