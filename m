Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E108F4644A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 10:59:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5FBC6B01A3; Mon, 16 Mar 2026 06:59:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D37506B01A4; Mon, 16 Mar 2026 06:59:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6DC86B01A5; Mon, 16 Mar 2026 06:59:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B34FC6B01A3
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:59:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F0B7B69FE
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:59:36 +0000 (UTC)
X-FDA: 84551630352.23.859AC84
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id CD2EE40006
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:59:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V4VSDzwP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773658775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EbhO6dTmE8yQ+bj5s1qi0JOFi2eyMWftGCJvNxfMHO0=;
	b=SH/FWevP9senq89gRPxU8XuJyS6xldMPdhteTGheBdoY1GF7MOs767qfZExa6rwKehLgdA
	os5ajl6xDYJIWfNqLCT9anczHpmu0uIog4RB+aV7IFqy6J9rqmNQUIVcfx3HOfNq/zbfsF
	FgDRvaP3YJ6sNE/Z1ow1j4DsUnObXHo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V4VSDzwP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773658775; a=rsa-sha256;
	cv=none;
	b=ALj+ICXLZ5GVZ4QP29LYQO2bVpDTTlcFVGWX25oDTyxjrgHqzYSWuox3hNJ4WhpWvq7uuG
	2YC97lJHP3G2YznzQX11Oe2BOkAXg5Nx8ckJ5gSrmQEeeqEfXh3XbJkOiGFJ9Xuz4lCZXK
	GwblfdrlV+qj6H7937L3cIUcE8z4vtc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CE78F43EB5;
	Mon, 16 Mar 2026 10:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644E5C19424;
	Mon, 16 Mar 2026 10:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773658773;
	bh=KSbvaOM7T4lvkehB8ybCCIyypc9grzepYJ4R937Jz7g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V4VSDzwPwBaRFCtyXl8RGn8/zotr9AcFFnrlNOHuHN7cKX3gqOFHZDyYMa5iqeMuk
	 s9d7f4UJF92XGiWtWA7dW5e6Qj6mZ4uTUW0T0DnQxD36dCZ4hWyMXdkYtsx+3TMSDR
	 omULYYva/OpHfwXvMipXKigs0/jIYUUFJo22ePKs+uxBlns0em7XsoAJA4lBeDmE5Z
	 KJV2HcPDErprePHPPGOXy7dl4rYN3S0yRnTlKr8Z3AfpHyn/cf83llU57kyDzejKMT
	 Xiv5VMckPS/al9ql3Pxwr/356st56s4RrtEzpD479Xf1dE8/cq4MyS5Lk/8D5mAPw2
	 7QmCyMIKOCHFA==
Date: Mon, 16 Mar 2026 12:59:27 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: akpm@linux-foundation.org, peterx@redhat.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+e24a2e34fad0efbac047@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/userfaultfd: re-validate vma in mfill_atomic() loop
 under CONFIG_PER_VMA_LOCK
Message-ID: <abfij0twNRm7uYgt@kernel.org>
References: <20260316070039.549506-1-kartikey406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316070039.549506-1-kartikey406@gmail.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CD2EE40006
X-Stat-Signature: 6zriibpnp5oiyaqd3g1k6en19ryk8u5j
X-Rspam-User: 
X-HE-Tag: 1773658774-462019
X-HE-Meta: U2FsdGVkX1/+Jf/Kc1Z+Y2gifQVtKU/9Rj2QYsi3YcALK+tCGzE+YwHXeX9K/EVaksA+O+bOp/niWp/YFCS1WwadxOjEUgDomVESfNDQcuGgb+ZLw9kOD+5InbVY6u39lCcHJZ2hDF+ZZ8pdyYCCf5BxqkosUeMD9O6/+Ds4RqPQtow0X+Dr2fySn04m+zg1iuFtUXZedwU0t5T3s7jo0wnWfORi04K69l2JqivDfVBz8dnvLWYwSIH7qoW6uSnHxzwyy+m/NbdEdm91VMKhCdR3w7YGrPRvHwIM6gC+RGN2nwjy+GAe0xgvOkProEpTVFCW5uHW94uSIglVckhmUvbsvH4STyPl9tVuLrE+9HrY725sMaiQui3F7hj30RJiGnjaxm2xsXa5hOZP1yrJyKW9ET3zLR+FXqDJ24koo9Gj1jzKqKB+gS7kY3wH0bBKmITOzA9Vn/M+xPSY+WsVwmBystSxqg9Ui2IlbPMQM4l710oIkQFampn9moV38O4GPp5i1E6Qv8dvSXk8NfIxBb4Tbbj49WxC5oxgGOFbD34MRifaHqDa66J3SBFZBzmY3iM6THemg5Hd/dqKke3wMmlS2SuhLYQ03he/YqXBIRSXe6lB/qr/NatxRGhYBhBqo6NRYREFLHY6euJ2o0UmPbTM4eTCvtQhziCEk6OStuYYprf7MNV6lbhK6P5vsEC6fzut73WCZKgGM3wIkvRsVatCh/Bl01vDq96uvlWhzIBpHVcfpooekWRScfaYIPdS28TP3Vgd1/hevS7KHrKpnOxKXbLHFw3n2aY8gsQRR76rxbdIFBOgSi8L1vQrArJpXcXHrFLZ0N5WOvmvEqnxLD8McVYvpjqt4vPp93wIyJn40b6MSq6e+QLFMYIEg/UOUtJ/9UM9HatDuN9LHSI+wqmlVofba0ply9Zr/+f8mfEjDZRF7ZlUU/wu/DgMrw1t8qkj4cuiqjqJcsm7ec7
 DOIKyzBX
 K2prACq6lCc2l64TTdrDgJ833rl6/76scZGrO82Q9yMP6fG48YYZz3wJmZ8yY41fFEp9nnqK145tF7MYGGPnuW6+mt7ITZJCmIRuRcaHlSCA2oJNTQbV70lusL6w3+nQqHUVdFRzOL1o3yJByBth4MZCnjDmf1qcsW77fLYEQZ1zPWzshkpedV0s183Bg3iUoJOGHOXq/PixeXu7cPcledVIDpKrAbe1PniC8HZFMzwuBTFtx9KgmcMTqsM+kF2w4XiVgzWQsmn6dthkFmPJ4/IdDEtpblwI+odY3JCPpF1lakmd5F4L9RHU6t6zPFijUtQnxnlgJVPJ+GeCOtsK3BHYS0fnVIXlHsleLC86a3QQ27SVpRxnAFhYrlpoEUPFsCIoRucF200hM/ZPEDzPnUDg+pyROH9kKFkn6To5Lh1Zlt8Ab5z+cP2d2C9Rp0qRzldQoyvIf2NTRdaWrf3EkKW+ULKVCYrJEI25BhUNEHiDKvs25txJ1GXcQo4oaVpS3Tc7MBeLraMZ+Dnh/2g++Joyr5ZPSx6JJxR9j8qfQb0xwdnheZs7fRzGfqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Mon, Mar 16, 2026 at 12:30:39PM +0530, Deepanshu Kartikey wrote:
> Under CONFIG_PER_VMA_LOCK, mfill_atomic() holds only a per-VMA read
> lock across its page-by-page copy loop. A concurrent UFFDIO_UNREGISTER
> can acquire mmap_write_lock() and split the VMA mid-loop via
> __split_vma(), which calls vma_start_write() via __vma_enter_locked().
> 
> The split happens in the race window between CHECK 1 and vm_refcnt++
> in vma_start_read(). During this window vm_refcnt equals the base
> attached value, so vma_start_write() sees no readers and proceeds
> immediately without waiting, shrinking vma->vm_end in place.
> 
> Both seqnum checks in vma_start_read() miss this because after
> mmap_write_unlock(), mm_lock_seq is incremented past vm_lock_seq
> making them unequal, so a split VMA is returned to mfill_atomic().
> 
> On the next iteration, mfill_atomic_install_pte() calls
> folio_add_new_anon_rmap() with state.dst_addr >= vma->vm_end,
> triggering its sanity check:
> 
>   address < vma->vm_start || address + (nr << 12) > vma->vm_end
>   WARNING: mm/rmap.c:1682 folio_add_new_anon_rmap+0x5fe/0x14b0
> 
> Fix this by checking on each loop iteration whether state.dst_addr
> has fallen outside state.vma. If so, release the stale vma, update
> dst_start and len to reflect the current position, and re-lookup the
> vma via mfill_get_vma().
> 
> Reported-by: syzbot+e24a2e34fad0efbac047@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e24a2e34fad0efbac047"
> Tested-by: syzbot+e24a2e34fad0efbac047@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
> ---
>  mm/userfaultfd.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)

There's a simpler fix Harry posted:
https://lore.kernel.org/all/abehBY7QakYF9bK4@hyeyoo

and it keeps the original behaviour when copy bails out if the VMA was
changed underneath it.

> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 9ffc80d0a51b..ab73c2106c38 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -910,6 +910,22 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
>  
>  	while (state.src_addr < src_start + len) {
>  		VM_WARN_ON_ONCE(state.dst_addr >= dst_start + len);
> +	       /*
> +		* Under CONFIG_PER_VMA_LOCK, a concurrent UFFDIO_UNREGISTER can
> +		* split state.vma while we hold only the per-VMA read lock. The
> +		* split shrinks vma->vm_end in place, causing dst_addr to fall
> +		* outside the VMA bounds. Re-validate dst_addr on each iteration
> +		* and re-lookup the vma if it has been split.
> +		*/
> +		if (state.dst_addr < state.vma->vm_start ||
> +		    state.dst_addr >= state.vma->vm_end) {
> +			mfill_put_vma(&state);
> +			state.dst_start = state.dst_addr;
> +			state.len = dst_start + len - state.dst_addr;
> +			err = mfill_get_vma(&state);
> +			if (err)
> +				break;
> +		}
>  
>  		err = mfill_get_pmd(&state);
>  		if (err)
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

