Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DAA8606A321
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oYdHWF1l
Received: by kanga.kvack.org (Postfix)
	id 3760C6B05B1; Mon, 26 Oct 2026 05:48:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 326C36B05D4; Mon, 26 Oct 2026 05:48:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 264C66B05D5; Mon, 26 Oct 2026 05:48:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 042716B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:48:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7E7DF406AF
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:48:15 +0000 (UTC)
X-FDA: 85364301750.30.7DA3DA7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id DAAA140003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:48:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oYdHWF1l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793008094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SfTZx8Jp3mL9/A9ePS6oiHF2jXSQx2p5MBCiDx+x+i4=;
	b=KLYFSh35YKGHsIdbkkbAZd/3IpYiHIaKEsg9ehT3gcclHOgyvKb9meaiEcflK+jrJwVs3N
	HV3YwThzpSiZY0VldnX/PhZ9IOk8H8wxpQ6w3WSA1yMHoXT4tAC6sC0cJ9j15fVzwJQJkd
	SbPBVNcmnZVfZNcVozRtBtvaaGP8WMo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oYdHWF1l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793008094;
	b=GHzb9tSNodyRLZVGB1UwAlD6WDhBVlnew2FT23B3gSazMsq5Yoq+YsfN+4R0scMhYpBdkN
	tNmDed3F5Qb6YMotoEHhnFv1BZoxsyr3bWXTO+VtpRVY1nUuRW2/6wY21Qoen1ABUBTa7J
	onxxgdn9jNSZ03YMFyXDa7BidJBmKlY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B7D543705;
	Mon, 26 Oct 2026 09:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED831F01828;
	Mon, 26 Oct 2026 09:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793008093;
	bh=SfTZx8Jp3mL9/A9ePS6oiHF2jXSQx2p5MBCiDx+x+i4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oYdHWF1l6Nl9PX9l4oZFhEmilpFs/+8lVaSaN/gEhAO+kjxaNvR9+/9SZd5CrPOaz
	 sZy8pV4wZSgJFHUMaMWO5fbsJDzsmxtOJu/ovl1j/E9preuKa8wU4obawgy3UQ5Ksj
	 qOneI3SnDbPKahn+XZV/bTFPWZabJzM6fSq6J0KYy7yOWiIeFzIRiWJdqH1rof+2wC
	 zQjSgEzKAR7sXtW4U4DBxlHOKC8qO6/p5O+psF+i5yo1XoN1oCNIHNtI2bvsQ9Ky58
	 Ywny02B+XA7B7mSHiUchbyiqOFf8SC1vU3pCu2FPNJTlgGfSdBII/K8yD+gZF8yctB
	 y86rvakIBiOxg==
Date: Mon, 26 Oct 2026 09:48:08 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, Kazuki Hanai <hnkz.64@gmail.com>, 
	Takashi Iwai <tiwai@suse.de>, linux-sound@vger.kernel.org, linux-mm@kvack.org, 
	David Carlier <devnexen@gmail.com>
Subject: Re: [PATCH] ALSA: us122l: mark hwdep mappings VM_MIXEDMAP
Message-ID: <at8hwlpXJlJjZQso@gremlin>
References: <20261023-fix-us122l-mixedmap-v1-1-e7bdd053850f@kernel.org>
 <sashiko-outbox-183642@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-183642@kernel.org>
X-Rspamd-Queue-Id: DAAA140003
X-Stat-Signature: qm5ksezugqka5mqx493mrfrd4d79tqc1
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793008093-534485
X-HE-Meta: U2FsdGVkX1+npHQB90WPZXxjyMXexMyWocsDiSbQR1m0+4Watw+OsHb9eogscxC+iQ+ZyviUlg7L4EMnL7TvQZn+B2RwLyn0sIrJCpwFZ9bWg8aEMUvKWKtJljO/0KLhEAJOHPDblIaKw/vB+J1DrjzVhV6HMmjdSF9Ws29B9Q1RPVK8wa5HABuIxDY3N+SXlsJvIny/Q8ZgmcslJ3dc8SbbWjoz5yhOTR9c8iuujh0Xl86Um+GriMx33Av5Is0jocW++DP5asvbOT6VWk5ThZwtZmDLxYAwc/i5nK+yNIC6/gD6WTUkSxGOx/lmp57wOdlNgJsTdAYHLotAZ2rHqGgNymVTVCuXHejYqf6WHMnJC6P+wU5BWW+jf/p2PfUjyNyq8Khwe7Q4AZDElqiB4FI7KyU+uZmZo0kAXt0zrgBDZK3Rm3JOjNWISwBMXsD9RYdv1hE9mfWIlkqcThrEcHNdRW3EosTglgTrAbgJktf/VSbIArM+vpOlkPtmOkqWQ4ngnVyQzjLid5Py57uWiIQn+aw5QEGs58kvumXg7zfFLRWBsyBNeTuM6++rEw72OHnyELUNoyCVYCcPwy8g0rk/R83IaBTlaQkzZi+aUOlvie5e//r0nBnaNqLimwomQu3vwjyQeFSjXEO1QRy+bLfTsAmMtRgy/1/vKpPVMzOnuEbeD1D5srWHMXO1hMjMT6OzArXmcX0WJmnGBgMAnamCu8ir7h8RysvXMeMSOHAp9Ig755E1WmgXkiq2A8vRA08enhIMTiAT1O9vQibnORxphKm+ASvzUeinJDyaHob5ro9D3dNBSf9/6dXy8Jln+DWb2U7ya7wX9AW8FQdeJajyfVZWHTntAEJ4P4YLoDrxHRd/WWezCyNG4/+In2GWr7hN5btnBU4/Bs74Yn2JWwNn7CYzmOrSCwtAHSUxTuI3veJ9lNj+GjZKLUMVGHZVCxNkVYU3QjToGRAdOJi
 8SAUNyx8
 Z0aG0SjeRL0Qo5l61IHz05I0QdwUsX21Xrxahae9LnfkKMEIHaZffrLr7IGcIuYqBoGUkXr56sPy6gG3Q9/xbRElQxM3vTIzfh33rleXV7oXJUXXMG2KTyrY6GgCa9o1ydRgD1Iru0D25UvQp/zkXfIWE0tLKYOBlr9v02mHG1T6Qi7/aWQIwFsdRT2VFOaJnVb37SpjD9ppKNotp4wd1C8HH5VDwfGO3Yo860wwFomCTkrOQuhWnu1U151lIYZpyR/NtyYAfcc8hmV/NO8YnJNuZtoQmSlk5FpnzIIMSuYzkom69B0grju9Hutg1hk10uwHsVO5TODBWWpUEkqQ/8fQOxG5itXvKGAqfEJM7HEKAamKl/kT39fIuE7fe4nJwUqYsbWtsd1hWcpgIXk6gRaA1yw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 24, 2026 at 10:21:59AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] ALSA: us122l: VM_MIXEDMAP in usb_stream_hwdep_mmap() breaks mremap()
> --
>
> commit c40f3445d293957b8d56aca33b8d5ed4071fcf4b
> Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> ALSA: us122l: mark hwdep mappings VM_MIXEDMAP
>
> This commit sets VM_MIXEDMAP in usb_stream_hwdep_mmap() so that clearing
> VM_MAYWRITE on read mappings satisfies the core mm requirement that
> mappings clearing VMA_MAYWRITE_BIT must not be mm-managed.
>
> > diff --git a/sound/usb/usx2y/us122l.c b/sound/usb/usx2y/us122l.c
> > index a5db0d044ef96..2986a90ea3351 100644
> > --- a/sound/usb/usx2y/us122l.c
> > +++ b/sound/usb/usx2y/us122l.c
> > @@ -193,7 +193,7 @@ static int usb_stream_hwdep_mmap(struct snd_hwdep *hw,
> >  	}
> >
> >  	area->vm_ops = &usb_stream_hwdep_vm_ops;
> > -	vm_flags_set(area, VM_DONTDUMP);
> > +	vm_flags_set(area, VM_MIXEDMAP | VM_DONTDUMP);
> >  	if (!read)
> >  		vm_flags_set(area, VM_DONTEXPAND);
>
> [Severity: High]
> Does setting VM_MIXEDMAP here cause a regression when userspace expands
> the read mapping with mremap()?
>
> In sound/usb/usx2y/us122l.c:usb_stream_hwdep_mmap(), VM_DONTEXPAND is
> intentionally omitted when read is true so that userspace (such as the
> alsa-plugins pcm_usb_stream plugin) can initially mmap() the first page to
> read s->read_size and then expand the read VMA to s->read_size via
> mremap().
>
> When userspace calls mremap() to expand this VMA and the virtual address
> range following the VMA is unmapped, do_mremap() -> mremap_at() ->
> expand_vma() takes the in-place expansion path in mm/mremap.c:
>
> mm/mremap.c:expand_vma() {
> 	if (vrm_can_expand_in_place(vrm)) {
> 		err = expand_vma_in_place(vrm);
> 		if (err)
> 			return err;
>
> 		/* OK we're done! */
> 		return vrm->addr;
> 	}
> }
>
> expand_vma_in_place() then calls vma_merge_extend():
>
> mm/mremap.c:expand_vma_in_place() {
> 	vma = vma_merge_extend(&vmi, vma, vrm->delta);
> 	if (!vma) {
> 		vrm_uncharge(vrm);
> 		return -ENOMEM;
> 	}
> }
>
> However, vma_merge_extend() -> vma_merge_new_range() in mm/vma.c checks
> whether the VMA flags allow merging:
>
> mm/vma.c:vma_merge_new_range() {
> 	if (!vma_flags_can_merge(&vmg->vma_flags))
> 		return NULL;
> }
>
> And vma_flags_can_merge() -> vma_flags_is_mm_backed() ->
> vma_flags_is_mm_managed() in include/linux/mm.h rejects VMAs with
> VMA_MIXEDMAP_BIT set:
>
> include/linux/mm.h:vma_flags_is_mm_managed() {
> 	return !vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
> }
>
> With VM_MIXEDMAP set on the read VMA, won't vma_merge_extend() return NULL
> and cause expand_vma_in_place() to fail the mremap() call with -ENOMEM?

This describes a bug that I recently sent a fix for.

--
Cheers, Lorenzo

