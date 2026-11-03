Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 362A6606A32C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bKO8djoL
Received: by kanga.kvack.org (Postfix)
	id 415FB6B00EF; Tue,  3 Nov 2026 03:31:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ED906B05B2; Tue,  3 Nov 2026 03:31:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DC356B05B3; Tue,  3 Nov 2026 03:31:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0F5036B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:31:34 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9C886C035E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:31:33 +0000 (UTC)
X-FDA: 85393138866.04.1300B64
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id E5B4E20004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:31:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bKO8djoL;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793694692;
	b=m7OOypB5GTa8nt2vail5oGNqwO9nOP83sQlfnRjNT1vY7nuWyf9IlkM9gtL8BLQlp0fnKJ
	uDSlgv21TkIsz/Hsd/sPh8mqW+7Us9J4TlT6qZkvJEGVrFgrFsPpxxWgpb0dCjn59VaXzH
	+pc2bHVtCjUfZ8SbgRevGv6M3X8Q5uA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bKO8djoL;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793694692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UkDs9mVbZylk2lLIWKEro/ogRPbHZtRQ5mDDvp1aXRk=;
	b=xRxkgBmlIxf9ThGLzI6LwMwiGnC6To0yUo1XPDcKet8Qaupx3eITg9IMYXgCxCF26j5+09
	CYyy+xGNQIEMMNOctw3ISr7nP5NRLCWRSV9jDOZDROQciV96JUOpdSsfBZ8tTDecZOQden
	gG15ddUPc+xKMzxKMUSOaH4DEyYOiTI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D38643720;
	Tue,  3 Nov 2026 08:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA6C1F00A15;
	Tue,  3 Nov 2026 08:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694691;
	bh=UkDs9mVbZylk2lLIWKEro/ogRPbHZtRQ5mDDvp1aXRk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bKO8djoL3ej9yAn440TcWCS0jyXUfKAd8tJEFkjIzDV8jXsJltCvia5Z//ETqsE1V
	 4weQ+7h56K4uEB/Mbi855D0i5RGU8hWDXUS7C+WZvNOFQJSq9rEehLzGCxNxHeyKPO
	 h3Q9+wUgvhYUcO/pMI/rZKN89WkiBH91n/43UkZHUX6SlugNFQlvcMZegYf/KhCMDn
	 4TZ1vXHU4NfQzaKF6eB5iX94xvtZz3LSVxsHlFFqDnkKnbq58WZtXzKHqaU+shdz7i
	 sAH30di0zRXmY36dKB30OGaqJpRN/NUomOlCSlk5Psi3eHNZHw/CwM7VnDSBuiG6Ze
	 qU7xwuH4biKoA==
Date: Tue, 3 Nov 2026 08:31:25 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2 4/5] mm/mremap: restore VMA_ACCOUNT_BIT if the unmap
 fails
Message-ID: <aumblElDYB54eErJ@gremlin>
References: <20261102-b4-mremap-pre-split-v2-0-d281dd11ad7d@toxicpanda.com>
 <20261102-b4-mremap-pre-split-v2-4-d281dd11ad7d@toxicpanda.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-b4-mremap-pre-split-v2-4-d281dd11ad7d@toxicpanda.com>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E5B4E20004
X-Stat-Signature: bs8pr8icpfff6haz5wyy9gkxu9gyw6a4
X-Rspam-User: 
X-HE-Tag: 1793694691-126097
X-HE-Meta: U2FsdGVkX1/CAFMez3FmWcSx8S3ee9klGH/qwMTJcYWGa8eD47zo5ZxqoFnLAx3bZOOjJ8ShATv8Rie3IRQj2a9lyBSCNbOan+Llg0nN0JkAnNjz7KR1QzcTAdrHj5CYbLIPtv0J2fl8FMyCPK4ODHvZsgYrvsS70dtpanI7r/DQT5I98DzQQSxOIAxVMZ9FIg3Z81+sH0Q1R91CsgLZxzw4neAXxV54aTpy6OsI1EnOMqn6SFHRwcs4F3n/HIgD4pga6v5FWle73NPvrivum6+klekw14dwitJ0apFGrYZAQMxUzkQlUdsUjuUENjNajkk+sosQrCS7gRjuhEGXtx8qQ5ZAVcorOsONgkGhbNodZ9ThoGrFEtXh0IIz+H2zaN43GC6ssYkQTMaETGvM8n5Q0sOpVcex+UQdcN5F2+Q6pYE83LVxZHVhoklOmZKho97GYSgd6V0aPWvQ7LVUZKGix2Ta7Hqix7Zhg2uoZBhCYTf85PnnvMTDpTCRomTZ/C25F4sBb6t6DoPQcFLJO6dCYrMUxJ4FH58LcY4oHUnfIed/mAUgyqOjCBqE22lsjsM/d66rl7Xlur7+a/vOCt8QiLC1wS82Hkwy2cuFbCSdt/Kr4U4TIvTWamKSesF+oCw7+Pf78GL+t24C8PJyyKsIGGbcLrioqr/J1Kr9rOPUbcs4Xmokj+zNQ3DC1mwK2wIRUIzO1aulnvdTKb1j6HKzlge9buOQ35OdD5TopWuDuA6VEoSYZT52ez7+btqPyYXkEveTNOZnQSpXgMemsdY3u4k/UO7gZuHmCLSgq4tiua6QRC1r8uHSGY2mt77YucM7LuaGP1ex+fH6CEeEjbUHNDo1LSXU610WVLjEKoK2k5SsBnzDpcipVLTjZaLx3XhnQi9AtFIbVhwisJrM0LJOH5raRVykoqhVWUjx60ZS1zwczrU/N3ApTs1zc8fcLz2AwQ24p83NbVaGKCr
 R4mBUtr/
 CdcHGjh4BJi0hKsEQ/G2IqNyIBhWvVRdTTQ/xBhE0EWb4pMr9azqfCwY2z9Ao5mb5kyktK6iZiHcexQ6LqF1bGuvzEibLxOOHT9DQZD4aPUQlUBtave2A87HsQHQQwLMebRfwwQdgavL3uprL7WVqXiW08Q+0eLrMFgSeh5K2WViVs6PSbExsfT9IGXoUCXQ+3+zKrsTo1ltYXUdjiVEp11pRUT88eeFCRzK8Yzr125AQSE+VL0aIiRV5/XrFaaYfnRWOHaVLgCkTAzOSZZSTLHHF8zA3Vmlrk5qucDWzefKodrsNjKtaryjKUI0+n3fGx+WlcCz6lsmCGVOeyndU17zf+C2DNJnirTlOhD8Ir0DGHoEAMDZn9zSzSxcKlAPFJauI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 11:46:00PM +0000, Josef Bacik wrote:
> If the unmap at the end of an mremap() move fails, the source VMA stays
> without VMA_ACCOUNT_BIT. Neither munmap() nor exit_mmap() uncharges it
> then, so the charge for all of its pages stays in vm_committed_as after
> the process is gone.
>
> unmap_source_vma() clears the flag on the whole source VMA before the unmap
> and sets it again on the remaining parts afterwards, but its error path
> returns without doing so.
>
> This was reproduced with fault injection: each failure on an anonymous
> mapping left Committed_AS higher by the size of the whole VMA after
> everything was unmapped.
>
> Fix by setting the flag again on everything in the range of the original
> VMA, on both paths, with a new helper. A failed unmap may have split the
> VMA already, so the helper walks the range.
>
> Fixes: 51df7bcb6151 ("mm/mremap: account memory on do_munmap() failure")
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Thanks, LGTM!

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/mremap.c | 41 +++++++++++++++++++----------------------
>  1 file changed, 19 insertions(+), 22 deletions(-)

Nice diffstat :)

>
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 71c9f335bea8..4d1e446620e2 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -1189,6 +1189,19 @@ static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
>  	return 0;
>  }
>
> +/* Set VMA_ACCOUNT_BIT on all VMAs in the range [start, end). */
> +static void vma_range_set_account(struct vma_iterator *vmi,
> +				  unsigned long start, unsigned long end)
> +{
> +	struct vm_area_struct *vma;
> +
> +	vma_iter_set(vmi, start);
> +	for_each_vma_range(*vmi, vma, end) {
> +		vma_start_write(vma);
> +		vma_set_flags(vma, VMA_ACCOUNT_BIT);
> +	}
> +}
> +
>  /*
>   * Unmap source VMA for VMA move, turning it from a copy to a move, being
>   * careful to ensure we do not underflow memory account while doing so if an
> @@ -1246,8 +1259,10 @@ static void unmap_source_vma(struct vma_remap_struct *vrm)
>  	vrm->vmi_needs_invalidate = true;
>  	if (err) {
>  		/* OOM: unable to split vma, just get accounts right */
> -		if (accountable_move)
> +		if (accountable_move) {
>  			vm_acct_memory(len >> PAGE_SHIFT);
> +			vma_range_set_account(&vmi, vm_start, vm_end);
> +		}
>  		return;
>  	}
>
> @@ -1271,28 +1286,10 @@ static void unmap_source_vma(struct vma_remap_struct *vrm)
>  	 * | A |     | B |
>  	 * |---|     |---|
>  	 *
> -	 * The VMI is still pointing at addr, so vma_prev() will give us A, and
> -	 * a subsequent or lone vma_next() will give as B.
> -	 *
> -	 * do_vmi_munmap() will have restored the VMI back to addr.
> +	 * So reinstate the flag on whatever is left of the range.
>  	 */
> -	if (accountable_move) {
> -		unsigned long end = addr + len;
> -
> -		if (vm_start < addr) {
> -			struct vm_area_struct *prev = vma_prev(&vmi);
> -
> -			vma_start_write(prev);
> -			vma_set_flags(prev, VMA_ACCOUNT_BIT);
> -		}
> -
> -		if (vm_end > end) {
> -			struct vm_area_struct *next = vma_next(&vmi);
> -
> -			vma_start_write(next);
> -			vma_set_flags(next, VMA_ACCOUNT_BIT);
> -		}
> -	}
> +	if (accountable_move)
> +		vma_range_set_account(&vmi, vm_start, vm_end);
>  }
>
>  /*
>
> --
> 2.55.0
>

--
Cheers, Lorenzo

