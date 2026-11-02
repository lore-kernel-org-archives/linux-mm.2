Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCC09606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 13:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kE3ByZ6H
Received: by kanga.kvack.org (Postfix)
	id E3A696B00EF; Mon,  2 Nov 2026 08:38:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEA6A6B05B1; Mon,  2 Nov 2026 08:38:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D00EF6B05B7; Mon,  2 Nov 2026 08:38:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A3AA96B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:38:49 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 348C780C6E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:38:49 +0000 (UTC)
X-FDA: 85390284378.25.38FD6E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 96BA71C000D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:38:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kE3ByZ6H;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793626727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xVuV4v6n2XUh89lpYtmkE+io2T/w8S2Ccr/8/0fuilI=;
	b=nBWi2ujeNsU8pQLz5yLfArnrPS8yj+Rh1rC+5fGQw2a2JjQQ/Doh2077yLVRbhKYQmbbqN
	hNkdT9+PvhDl12KzrzyBDTuuWAV7qc5Mnj1Au+0Chw9AudESF/8wtoAxyy4Q2GE8AWA847
	KiX5G2a3T7xIH5mgXeabSxBGgN6yzW0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kE3ByZ6H;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793626727;
	b=oiLMWCOcPXExN9059NmufJuHu48Aji36jl5p5HzNiR+CrM6xD7OVuryEGd3q1EQV4NLCcu
	EoXQnzwB2tnsEOJz1+bww7njUTNgFGxpv+dtt84e/C0h6c6fUaQxIhrCNB9RGvhurk0d0F
	rpHTxgFbzvMd/jsP76oU33X9r4S9phw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D5CA7605D4;
	Mon,  2 Nov 2026 13:38:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA001F00A16;
	Mon,  2 Nov 2026 13:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793626726;
	bh=xVuV4v6n2XUh89lpYtmkE+io2T/w8S2Ccr/8/0fuilI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kE3ByZ6HWhR04udaslk6PtqeinslZISISnUFBdoS5OVRZV4/a4J5e/XZJljlyZHM2
	 c5t9OgQZdqPXmpPKOXeqkJkjoQ6AY1f+dU8/31CZWZpcNfCebP2uKNPHDQ6z51AYot
	 K+xIt9G1ZveuQbllOUB3qJOAem1tRyNgJ6VyuGp3Iyg57i7IotD53zqP33r1QBh1sw
	 dO4yOCGMgGcz8JVJ2z5sWO/ckxy9jw3xVeqfoRKYtnoI6jJOEne1BiU/yZ/FCYJ7yS
	 sLcxE1BAm3GHCGfSOcHRm98yfzixEWBY8bKg54qwykA2iWQOtY+YAT3l/HGHHY4ZXL
	 vWY1CVIrb+8yg==
Date: Mon, 2 Nov 2026 13:38:41 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org
Subject: Re: [PATCH 4/6] mm/mremap: restore VM_ACCOUNT if the unmap fails
Message-ID: <auiNiMvxR8U36BTH@gremlin>
References: <20261030-b4-mremap-pre-split-v1-0-c1829811aed0@toxicpanda.com>
 <20261030-b4-mremap-pre-split-v1-4-c1829811aed0@toxicpanda.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030-b4-mremap-pre-split-v1-4-c1829811aed0@toxicpanda.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 96BA71C000D
X-Stat-Signature: i96i8ykg1bkizc7mtfnsw3uen747nmig
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793626727-261882
X-HE-Meta: U2FsdGVkX1/sc0m1QU7xalNC/n8rBI4jVOIgIwPqLpbpn4WQlNDdfrziFMRd20/UDadL8M4SyjQSO5SUfWSuNbwLKEiLdIhYPRWArfk0hedPxWibU56N0Cd/6OX8QDyukq90K4US3e8uzxMXyXiSUnR4RkC03w/5IFEpj/ZfpX+EXOgM7eGoxL0TjYxbFJYcL44hkjz2/Ychqk1u26qK264qQQs5lX8EFIPlp2E5gSvkCH6LAvNMF3XVwxP36EpM6unMc/ADs4Bp8mxNSsiOEnSpbf+b88vtB23m1mHhmlnnaGzLGCU8ILBgygQkFBziZRRY5uyp/+ekxYNl20ZcNSPDJ8TRH8CkdoyA7mFdpzsNuPy2HMFlI62G7EIAEvKLCGaG75AINgDFU2NbvRpTxhTyN9nNujXYbJBqn79jDmBBI9ZjktOSurws7CwmJOCINNYXA+z/01Cx340K9mGSmtFN1jUzPVR02Gw9wArU+ByTHf1cmGubC/OCAMcGCXWHj6l6CTFJxW21OBu9R1Dmlpc8QTPqOJ1xbA5DKbT9dPwv+rr4LnHmr5ABcP5j1b6RAKbvf8H+Sn7CCoYdZbVvfXov4jgfuclF07c0hkG3CKzz4cJTmD/TLv60n4Z+Wei5Tx8VcVSSmikpjBrtWuVi9LAtgPmwZEJeuBj5QUfRkaKKYl9EM+lFzw0jHZmJfBIQg8mikZZP77Fl7ol5oQjeDyYF9D1xWGHHlpLSbpzJxh9VqvvzHwF9x+XEnHMiqdSAj/UaqwEvaV3nlxNa4plK4SGl/u+nzeVp/H/gLs9Wgtx6o2ya/Ye9k38tlnv+8Ul7IYSokFO6UIQb47pOIjKNeVg5axe9a2lnrsPsw1P+JZ8kdYHEKl1bUZjdUW03TwiFGMCR1QWqO2NEyTGAWN5vPCS7LVw5LwMC8LMBvWPhkweYOF3O+vIRqx5ZlYuznsVhQiUme/+lL4RVrdcxH49
 frUmHAWh
 jrdiOnCPScQc0PhrcdRRKZNQQlhR2WGE+Nsop9WG/cMzDJ5bZaE44zl2wRcBx/UOSJyMxWMzRcBdO2mN20iursULpQPS35/NxUz61sE4j9Zlmzk5b2vdMnhrajnjlw3UHs41EftS1Ejjt0nwir9GvoAYQnIv6XxO/HlsMh3qX0tKnOcxvA2MPPD1SzfJhJS+CaBmjkk9QiGpl0gEPd4Sf0S8v6ZsUzrKOo+aaM34rBPI4xYp/IBBgdHoSFni8n703X648AWOg3XAfO6gPIfGXycTGcs8dqpQyjfiBlOsPsneob0W5z5zPckDNmJSxnzKDPxBPx+ryKPLiciEeEkQ+HwDGOtEbAQFsISq1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 02:42:49PM +0000, Josef Bacik wrote:
> If the unmap at the end of an mremap() move fails, the source VMA stays
> without VM_ACCOUNT. Neither munmap() nor exit_mmap() uncharges it then, so
> the charge for all of its pages stays in vm_committed_as after the process
> is gone.
>
> unmap_source_vma() clears the flag on the whole source VMA before the unmap
> and sets it again on the remaining parts afterwards, but its error path
> returns without doing so.

Yeah this whole VMA_ACCOUNT_BIT removal/reinstatement is a total hack and I hate
it.

The real long-term fix is to change that to something not terrible I
think... :)

>
> This was reproduced with fault injection: each failure on an anonymous
> mapping left Committed_AS higher by the size of the whole VMA after
> everything was unmapped.
>
> Fix by setting VM_ACCOUNT again on everything in the range of the original

It'd be extremely pedantic to say 'VMA_ACCOUNT_BIT' here, but it's the
kernel, so here I am being _that_ nitty ;)

> VMA. A failed unmap may have split the VMA already, so walk the range.
>
> Fixes: 51df7bcb6151 ("mm/mremap: account memory on do_munmap() failure")

Again, this requires crazy memory pressure, fatal signal etc. etc. so yes,
no cc: stable is valid.

> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Logically generally OK, but I want you to rework this as per below.

> ---
>  mm/mremap.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 6f941aeb1b5f..256eac721a07 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -1246,9 +1246,20 @@ static void unmap_source_vma(struct vma_remap_struct *vrm)
>  	vrm->vma = NULL; /* Invalidated. */
>  	vrm->vmi_needs_invalidate = true;
>  	if (err) {
> -		/* OOM: unable to split vma, just get accounts right */
> -		if (accountable_move)
> +		/*
> +		 * OOM: unable to split vma, just get accounts right. Both the
> +		 * old and the new range remain mapped, so charge the range a
> +		 * second time, and reinstate the flag on all that is left of
> +		 * the VMA so the charge is returned when it gets unmapped.
> +		 */

This is quite schloppy. I don't think we need this bit.

> +		if (accountable_move) {
>  			vm_acct_memory(len >> PAGE_SHIFT);
> +			vma_iter_set(&vmi, vm_start);
> +			for_each_vma_range(vmi, vma, vm_end) {
> +				vma_start_write(vma);
> +				vma_set_flags(vma, VMA_ACCOUNT_BIT);
> +			}
> +		}

I'd rather separate this out into its own helper. That also means you could
share code with the bit at the end?

Like:

static void vma_range_set_account(struct vma_iterator *vmi,
		unsigned long start, unsigned long end)
{
        struct vm_area_struct *vma;

        vma_iter_set(vmi, start);
        for_each_vma_range(*vmi, vma, end) {
                vma_start_write(vma);
                vma_set_flags(vma, VMA_ACCOUNT_BIT);
        }
}

Then the above error path becomes:

        if (err) {
                /* OOM: unable to split vma, just get accounts right */
                if (accountable_move) {
                        vm_acct_memory(len >> PAGE_SHIFT);
                        vma_range_set_account(&vmi, vm_start, vm_end);
                }
                return;
        }

And on success at the end of the function you can reduce that bit to:

	/*
	 * ...
	 * do_vmi_munmap() will have restored the VMI back to addr.
	 */
        if (accountable_move)
                vma_range_set_account(&vmi, vm_start, vm_end);

Which is nice :)


>  		return;
>  	}
>
>
> --
> 2.55.0
>

--
Cheers, Lorenzo

