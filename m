Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47A67F8925B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 11:02:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82C0D6B0088; Tue, 21 Apr 2026 07:02:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DC656B0089; Tue, 21 Apr 2026 07:02:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F36B6B008C; Tue, 21 Apr 2026 07:02:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6017A6B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 07:02:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 32BD4160D72
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 11:02:58 +0000 (UTC)
X-FDA: 84682275636.03.18D00CF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 90A234000A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 11:02:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="GFtayXn/";
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776769376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vksUTAgLZXCLiaTdmCAAJxD5+zyj0BA7+dBKIpxydSo=;
	b=bLq6m+nliT6xLAFuJz0hn1+lBd19HXqMtTglZ6qilTwhZgmt0ot/URwP6+isFJLpcabZdD
	qXizzXCycEJjPD+yDoUZhbrE+z+nKcTQID+/xOGg5WeUI7sRO/WE55JgSEfWOPUFcP+hjZ
	jHSwPEBT3rVgHKHFOVEHKp6nSb8mb5w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776769376; a=rsa-sha256;
	cv=none;
	b=pAq9dAEsGS9lbrXkRQ365PkHCoLqv+Pnbcyrb/UVmMfmVc9TE1sglu0fuJSvjXWzWuBuOI
	M4DoJpuVxG/oMJ+mDgd7NJ5KH1bz0VR4Bgjv9UfmJsRKBIgVXov+Hr1zHXVX+SDyXZttzz
	JTDRxnwtEyj4Q1pPOuig8zaNu7PF0Is=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="GFtayXn/";
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0206860121;
	Tue, 21 Apr 2026 11:02:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4B0C2BCB0;
	Tue, 21 Apr 2026 11:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776769375;
	bh=Mit3d++puFieDkYFiFSR5MLYsiwR/pliP6/RpT1qDsE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GFtayXn/xyAWSKM3nxHS9I00rGB4QSlbKFd0XxmKa6XJxsSeaKsETqmsbCHcSYFwj
	 3GotQgqxxYRaw3HaVEKkXqX4YofTeRXNMEAS/fT5rmWDHZGprsL4gxz+Y4eu7lDIXS
	 0BOueZ5Xv4gjvzFlGKOxtZIYqevTCaQuCS054OuT9uwCrOd13Eet1pZ3hH9o02k5eH
	 U33+QmMZfMQrIHpQlyHR6OXgCC+QSw9lSCcYh+2On7N9AYk54jGJ6/gOpjHCvjK/xS
	 LTmhgKOaN3eZaJghcNHLP3j3UGHO/3hRVnRMiPfM+wwzEQ2pNXfu8g7kSi/08Stw+j
	 Qo8zG6usKxQCg==
Date: Tue, 21 Apr 2026 12:02:50 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes] mm/vma: do not try to unmap a VMA if
 mmap_prepare() invoked from mmap()
Message-ID: <aedYzieYdjw4MKY-@lucifer>
References: <20260421102150.189982-1-ljs@kernel.org>
 <l7dsbewodomciockueakhd4d5ncxldhue7ysvs6n3aqbof2wys@revnmkomdpsy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <l7dsbewodomciockueakhd4d5ncxldhue7ysvs6n3aqbof2wys@revnmkomdpsy>
X-Stat-Signature: ateh3typ9fpugn7a1qrqw45ez8ag54ck
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 90A234000A
X-Rspam-User: 
X-HE-Tag: 1776769376-802353
X-HE-Meta: U2FsdGVkX1/8T78AoM5STPsjm892FQalpGUBNNEGURdPuKOLV23im51BEPEaMJzP3pIZ4SceUV6RVztFg8IGHqMqICQPPHonzZC2GvPnuGItVSrSBfvHk0Gi9iSipNrdJUnH6ROZCyjkke2LQRzm/8MXBdOn4PFMDB1B3TRG51gh/qkcApc/g8XOIm2n/Yj4NnOccxgowtJxULiSAkGYJj/QcZ/iJk6nlk22lwBWX/eS8KSf0TLIQv2F2QS3fLVLEw9R/otrMW/A6IVhjP5ITwrvc+S7+mMi7rXAjGvMDs3bAFTx1K/0eBhas0DMM9jR0X2TBA6hGAKLDcdojyq5DDb7K8LithU6kNpgGZ9bBKPPqrBJiU6PP9IxyZBVAOg8r2Bo2dE2FT38sL/R39tP1dCLTQ5g46AFIQ5ba9PVKObeHaOzy7r30vCFaXWW288neIzq2M8cZ1fwiUdmuFROaSTyZZdun01eOVik9mNB6vGsOH/sqdodziiwHHZri4dMFXUKqNsTvqRWshs24G7qlu0DGZ2IcCQIbv9uIplY8ceFxXTJbYg7iZrN/NLssShe1tNCRk72u4MWRPtd0bBP+3ddHWkBeRd4YioxiyULhJ+UQHoVRtldEBC63nXLsVTi6uLNdjZp0m+sXWYaK8Gc5y3L/Uz0c0LEPQiW2rUXuTUiYuHZTRIkJ+1tJgs2n0WnnUXnuroxajp59VJuY6lamwR1BRwmMzw8keNhujl++PJVSfNtlEpsJIJrco/0xZpk3gr7pFp/Xj1RNevL6mukqz/96j+N0lSphhls9k+kX+YstTbHUrt7cQOyvexiX9TcYKIpd5wTQoFvSkNiismQPZYpOvbzDL8WbWIhW0LPlLiubnARHHPByVPqoazo8vGPDMX5UOxGJapR4mi/87oOSqbmi/W2XWCAGTyLiAtaNwG9YEZDRAdBBeIxtGZuMdIHUPS4YedJ6i+GNUbfp1Z
 q49BhkFP
 fUtwIR3wyEf2tQztKUDjSId7RdUXq2FALwvXgLHPpullXbyR+BY4eFWf7yo7lGES+vcy76rilEWUhzTKDy25XbXAuMzEfZtuqfpPFLcucr+h82dyW8lFXyj/v9ppfFzS5DUdLexwMxouJkVJg6bnyLMQ4TAWHMBjh/IH7aluiLyGRnDHCKGFXNBHkOvDOXv+71sDb/soIDzlnBd2r5/iBshi7FwhJPImsijM97aB852pUHHhYPQpWWFdKg77hzjxdEbPfUGE28GGmKrqAZAw/af0jAnsVXf34z2IemnVBjFXlHez67Kvknzk8EvmwV102oUAxubX7NcHgMNL4AKgFcyidt6sCRRghRkggE6e4+Cc6eQRtv/ZDjYMBa2IaKsTVp9AoKjE+FzHMHPoZ0yn8eDyk8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 11:52:23AM +0100, Pedro Falcato wrote:
> On Tue, Apr 21, 2026 at 11:21:50AM +0100, Lorenzo Stoakes wrote:
> > The mmap_prepare hook functionality includes the ability to invoke
> > mmap_prepare() from the mmap() hook of existing 'stacked' drivers, that is
> > ones which are capable of calling the mmap hooks of other drivers/file
> > systems (e.g. overlayfs, shm).
> >
> > As part of the mmap_prepare action functionality, we deal with errors by
> > unmapping the VMA should one arise. This works in the usual mmap_prepare
> > case, as we invoke this action at the last moment, when the VMA is
> > established in the maple tree.
> >
> > However, the mmap() hook passes a not-fully-established VMA pointer to the
> > caller (which is the motivation behind the mmap_prepare() work), which is
> > detached.
> >
> > So attempting to unmap a VMA in this state will be problematic, with the
> > most obvious symptom being a warning in vma_mark_detached(), because the
> > VMA is already detached.
> >
> > It's also unncessary - the mmap() handler will clean up the VMA on error.
> >
> > So to fix this issue, this patch propagates whether or not an mmap action
> > is being completed via the compatibility layer or directly.
> >
> > If the former, then we do not attempt VMA cleanup, if the latter, then we
> > do.
> >
> > This patch also updates the userland VMA tests to reflect the change.
> >
> > Fixes: ac0a3fc9c07d ("mm: add ability to take further action in vm_area_desc")
> > Cc: <stable@vger.kernel.org>
> > Reported-by: syzbot+db390288d141a1dccf96@syzkaller.appspotmail.com
> > Closes: https://lore.kernel.org/all/69e69734.050a0220.24bfd3.0027.GAE@google.com/
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>
> How about something like the following:

(Normally I'd love helper struct stuf but...)

I was going to say in the commit message as to why I'm not doing that :) but
thought maybe I shouldn't spell it out.

But to spell it out - I don't want to do that, because it could be abused by
drivers and I don't want to add any possibility of doing that, as it defeats the
purpose of the change.

And adding checks to make sure a driver didn't mess with it complicates
everything.

I'd rather live with the added param, it's temporary and can be removed once the
mmap() hook is removed...

>
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index a308e2c23b82..c29165de6d5c 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -868,6 +868,12 @@ struct mmap_action {
>          * completely set up.
>          */
>         bool hide_from_rmap_until_complete :1;
> +
> +       /*
> +        * Set if this mmap_action is part of compatibility with ->mmap().
> +        * Internal flag.
> +        */
> +       bool compat_mmap :1;
>  };
>
>  /*
> diff --git a/mm/util.c b/mm/util.c
> index 232c3930a662..5134f879566d 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1229,6 +1229,7 @@ int __compat_vma_mmap(struct vm_area_desc *desc,
>         err = mmap_action_prepare(desc);
>         if (err)
>                 return err;
> +       desc->action.compat_mmap = 1;
>         /* Update the VMA from the descriptor. */
>         compat_set_vma_from_desc(vma, desc);
>         /* Complete any specified mmap actions. */
> @@ -1400,7 +1401,11 @@ static int mmap_action_finish(struct vm_area_struct *vma,
>
>         /* do_munmap() might take rmap lock, so release if held. */
>         maybe_rmap_unlock_action(vma, action);
> -       if (!err)
> +       /*
> +        * If this is invoked from the compatibility layer, post-mmap() hook
> +        * logic will handle cleanup for us.
> +        */
> +       if (!err || action->compat_mmap)
>                 return 0;
>
>         /*
>
>
> We have plenty of free bits in mmap_action and this is a little nicer than
> passing is_compat bools down the callchain.
>
> (that comment over compat_mmap is really... vague and bad, but I couldn't
> think of something else)
>
> --
> Pedro

Cheers, Lorenzo

