Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 182C3FCC9DE
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 08:34:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6860F6B0089; Tue, 10 Mar 2026 04:34:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 608F06B008C; Tue, 10 Mar 2026 04:34:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50BBA6B0092; Tue, 10 Mar 2026 04:34:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3CE4F6B0089
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 04:34:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DD4081C570
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:34:38 +0000 (UTC)
X-FDA: 84529492236.29.D1707F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1971D1C0002
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:34:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BuH5r2+q;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773131677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SntdUC0RqYa8RMIV5HvbQF8jfR3ieEoKxyleeclZGKg=;
	b=2K7s4kPMBKMFk/GeIEC+cnB/VTksyPnq6yUVQ8F/45QoTq/N0uoPHpQ+EOtGWdRavdx64V
	xZoqJGfdBpi5s2dl3Tn68gQpGYRXvvdOELYHNbv2nr8XTWiLEoCVSItc8w2DND32LSFOkh
	M+Mbni9ShqHM0CiTtLt4i0BMR/y0FGs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BuH5r2+q;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773131677; a=rsa-sha256;
	cv=none;
	b=DUQe6+h81OoBCvUr0n6AF8pJ/AFsgGx6RYjDSyJ8WpB4O6IKI8Es3aCLEWIV+V7vev7AkN
	yVVZ33douwsavxVxSfrnrgbTpgUavVgLIoVBwFpp2sIZxvLCnBZYXGnzBQPoMc0cJlCA+h
	5E6Qvo3Y6XslDeaRP8VriyXJgdgROkI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E80B9438EC;
	Tue, 10 Mar 2026 08:34:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B699EC19423;
	Tue, 10 Mar 2026 08:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773131675;
	bh=HdLgyyWRg3Ajtbl0yp7vza6hydlvyskmgAYsaTbCe3w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BuH5r2+qvbdcG0Nlgp2YlY4awgAwkKADjimq8PyWD91myKfucBx/C+LbTBvBvWf5P
	 Zhx5js0eVawHl3YlssHew0b1FZOPZcOgPMWJV4qp4lpyqY9MAL/jGg1eXcKyHaoJeA
	 WHQ6ec0Y2I/X7KgX5YcpeZqY4KNlsGUqvzwMarCPMedAE/W3x3kR4XRm8GhuyCYiYh
	 Wdm+zsshIN4BG17kZCI0Ygy0YL+kn1/Y0mdQ0lvuKtIjiSnTiOzGxMXK0ZYVMvbyqD
	 ldCmDSEDvsHXQS9O0Bx0UsEL8AJzr5b861ffeupNBqMS3h89rhXLaYpHGZO2GulthU
	 t/gSKxYn2wkkw==
Date: Tue, 10 Mar 2026 08:34:25 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	yuanchu@google.com, david@kernel.org, hughd@google.com, chrisl@kernel.org, 
	kasong@tencent.com, weixugc@google.com, Liam.Howlett@oracle.com, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com, 
	harry.yoo@oracle.com, jannh@google.com, pfalcato@suse.de, 
	baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, youngjun.park@lge.com, ziy@nvidia.com, kas@kernel.org, 
	willy@infradead.org, yuzhao@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
Subject: Re: [PATCH 5/9] mm/rmap: batch unmap folios belonging to uffd-wp VMAs
Message-ID: <00f65edd-5b16-4f9e-a9fa-b923eba052b7@lucifer.local>
References: <20260310073013.4069309-1-dev.jain@arm.com>
 <20260310073013.4069309-6-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310073013.4069309-6-dev.jain@arm.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1971D1C0002
X-Rspamd-Server: rspam08
X-Stat-Signature: bo1dcg1uyweoqtuuxcsxmtsj1tsiheh8
X-HE-Tag: 1773131676-831141
X-HE-Meta: U2FsdGVkX19TQIIyMZ7Eyht9L9YXYDO+fmgkUbhqth5CoP9dSo16asnXDlWnUtWHqIscbDkpmDwoFNnFX8oLTVI+ceH+JIP3Y4i0CbdN/X9DtFwtoCOd8JWn8dD4amRmaOcxCexgXzwBoAzJZflswfUDYInwPra3XTSnwJR91yAtzeLKASSmptAklVv2BRhTDdhebnSC1+zqbYsZIkQ38cnKoqc4O2+kjUrn4D9nSRqRlh456+XeeW9J2Xr4HARCEfmc24RrroiKf0V2ozEA0FPuwldOuWLIrPgzKOmavgT4vA1Ej5OKF1P5Ttp8GC2KO/D9PyyYuQGgo/ptkINjZ2uGSDRAIrE5bUypgk184hmOt6aI4X+x26C7yyjxrRFHFnZAJMVBbkm/Iu6OZwMyiqrp5D/hsRtQaWg/SFWkbbgLd6FPthnWMz5qrm27qwDD4DpCJoYy+OE4ZsQgptXAyoOf4ty+SVcJenAQ5JKAL8wqo0EasT8wWPjNAoJoeDF9XTqF4otG7owEoM0j3dzVUIjrlCQsPNKXm4vJhZmVrwp18UDFv+/8s8VE0ZIBPaTKWnXT7dGUT414lvs0aLidY3dD2ggR7Jwjf1tiufq/bo2hr+Gu2eRyS2zTxvgivT3vxKuPMiCT28USZ6/NP/TNgyxHnYq89iAotAK3dT91uXHB+7lI1zQuvo4FqKOD7XbxFLDi1PbkYQof5Yn4ltVuEKgz3Ro2sAD7Tq/NpUHrl1nUtbeBFm+u/TX93Hq1oYdrDJTN/lMOgAxmVYmbbYmZ31Wt+qCCuyW+HekYV0Hkvj0uVpCl1AHUUeMtr1xxAB93x1IapgAR0X1tPtypqkd4QXdd71kvPR9SG9qpBjS0q+wway61xbTdXYS/7IWT0ZrX241e2HB2t25JeuVUnBsbZ+P7Ja3j6ZD/Gj5eKtSOf5/NmMDC1H2oIMsniTK6iknZQVoWKQdl3B26+sWrmlB
 f+tem5hV
 18eBG3AgnjxS9C2roiQ6AZ5gJo/WtiWgfNtJDiyXJLysQ3HPZKYluDgCC3OaDltnUv4cT5mOXGMiBLRCBYz+JP+45zjspSevT2qE4VFKhHCB8AL7L/wZdG7zpBNw1ccC/6QpdsLCJcAO/2mK6eq31wwtKxHw7KyDKkVr3NTm5V0infMAqc+PbgkmTn/PC4AnvXCSY1wEAcnZ0BAbb8JNO3SHWR9K70KQbzA24wCOzbaYJmiHWG/T2e4Ws3zjYrTzDVI14hz5GQ10b0crocmLLS86Txw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 01:00:09PM +0530, Dev Jain wrote:
> The ptes are all the same w.r.t belonging to the same type of VMA, and
> being marked with uffd-wp or all being not marked. Therefore we can batch
> set uffd-wp markers through install_uffd_wp_ptes_if_needed, and enable
> batched unmapping of folios belonging to uffd-wp VMAs by dropping that
> condition from folio_unmap_pte_batch.
>
> It may happen that we don't batch over the entire folio in one go, in which
> case, we must skip over the current batch. Add a helper to do that -
> page_vma_mapped_walk_jump() will increment the relevant fields of pvmw
> by nr pages.
>
> I think that we can get away with just incrementing pvmw->pte
> and pvmw->address, since looking at the code in page_vma_mapped.c,
> pvmw->pfn and pvmw->nr_pages are used in conjunction, and pvmw->pgoff
> and pvmw->nr_pages (in vma_address_end()) are used in conjunction,
> cancelling out the increment and decrement in the respective fields. But
> let us not rely on the pvmw implementation and keep this simple.

This isn't simple...

>
> Export this function to rmap.h to enable future reuse.
>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  include/linux/rmap.h | 10 ++++++++++
>  mm/rmap.c            |  8 +++-----
>  2 files changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index 8dc0871e5f001..1b7720c66ac87 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -892,6 +892,16 @@ static inline void page_vma_mapped_walk_done(struct page_vma_mapped_walk *pvmw)
>  		spin_unlock(pvmw->ptl);
>  }
>
> +static inline void page_vma_mapped_walk_jump(struct page_vma_mapped_walk *pvmw,
> +		unsigned int nr)

unsigned long nr_pages... 'nr' is meaningless and you're mixing + matching types
for no reason.

> +{
> +	pvmw->pfn += nr;
> +	pvmw->nr_pages -= nr;
> +	pvmw->pgoff += nr;
> +	pvmw->pte += nr;
> +	pvmw->address += nr * PAGE_SIZE;
> +}

I absolutely hate this. It's extremely confusing, especially since you're now
going from looking at 1 page to nr_pages - 1, jump doesn't really mean anything
here, you're losing sight of the batch size and exposing a silly detail to the
caller, and I really don't want to 'export' this at this time.

If we must have this, can you please make it static in rmap.c at least for the
time being.

Or perhaps instead, have a batched variant of page_vma_mapped_walk(), like
page_vma_mapped_walk_batch()?

I think that makes a lot more sense...

I mean I kind of hate the pvmw interface in general, this is a hack to handle
batching clamped on to the side of it, let's figure out how to do this sensibly
and do what's needed rather than adding yet more hacks-on-hacks please.

> +
>  /**
>   * page_vma_mapped_walk_restart - Restart the page table walk.
>   * @pvmw: Pointer to struct page_vma_mapped_walk.
> diff --git a/mm/rmap.c b/mm/rmap.c
> index a7570cd037344..dd638429c963e 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1953,9 +1953,6 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>  	if (pte_unused(pte))
>  		return 1;
>
> -	if (userfaultfd_wp(vma))
> -		return 1;
> -
>  	/*
>  	 * If unmap fails, we need to restore the ptes. To avoid accidentally
>  	 * upgrading write permissions for ptes that were not originally
> @@ -2235,7 +2232,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  		 * we may want to replace a none pte with a marker pte if
>  		 * it's file-backed, so we don't lose the tracking info.
>  		 */
> -		install_uffd_wp_ptes_if_needed(vma, address, pvmw.pte, pteval, 1);
> +		install_uffd_wp_ptes_if_needed(vma, address, pvmw.pte, pteval, nr_pages);
>
>  		/* Update high watermark before we lower rss */
>  		update_hiwater_rss(mm);
> @@ -2359,8 +2356,9 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  		 * If we are sure that we batched the entire folio and cleared
>  		 * all PTEs, we can just optimize and stop right here.
>  		 */
> -		if (nr_pages == folio_nr_pages(folio))
> +		if (likely(nr_pages == folio_nr_pages(folio)))

Please don't add random likely()'s based on what you think is likely(). This
kind of thing should only be done based on profiling.

>  			goto walk_done;
> +		page_vma_mapped_walk_jump(&pvmw, nr_pages - 1);

(You're now passing a signed long to an unsigned int...!)


>  		continue;
>  walk_abort:
>  		ret = false;
> --
> 2.34.1
>

Thanks, Lorenzo

