Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABAD9C87FCB
	for <linux-mm@archiver.kernel.org>; Sun,  3 Aug 2025 06:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D03B36B0088; Sun,  3 Aug 2025 02:47:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDA686B0089; Sun,  3 Aug 2025 02:47:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C17486B008A; Sun,  3 Aug 2025 02:47:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B2F816B0088
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 02:47:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 09AB51607A9
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 06:47:38 +0000 (UTC)
X-FDA: 83734515396.02.E7AE6DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4CCE980002
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 06:47:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sulPqGIQ;
	spf=pass (imf30.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754203656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BcLV3nNEamOy0YpK5l9Lk4RoB5NHRXwyZO/dOGM+CCI=;
	b=Xqoeijfm7vfRDVvu1FWcJKfD5Alk51Tnheudt17Ln7Yp3rSUSpDJa8edLdmjsjVd4lGWm2
	xL1cp77rTqauxowVwX2vESoTUyTbnf+uLWzCCG/GV1/1ABPNvezZgJR43y9i/uVXsDMWt8
	n78rrWGcSzFlWJBR372BMAAiYW54eF4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754203656; a=rsa-sha256;
	cv=none;
	b=cHivmGPQ0p+fphshYOhO6J7v3dSVCXzajPRlQNw3eeG8sEFkWgcwircuO+sL6CPbLo/wd7
	0Qq5wfwvBJv6NcLCCvC/teuTuT4aYEjSlPBLK6y2jTyZX+d9CHImhSj0nxXg/hZQbaDYzQ
	IBkEjvGeI7zQoQ2OGTqKVp2WnqYe6YQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sulPqGIQ;
	spf=pass (imf30.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 175F9416AE;
	Sun,  3 Aug 2025 06:47:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6938AC4CEEB;
	Sun,  3 Aug 2025 06:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754203654;
	bh=d1CztXE2nxIStxY5iQfmoDrEvdtgUVV7MjZV4daxJbo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sulPqGIQZvDPo/kxDy94EVz3bSUYuxoGHoJokqpytgVkXzoxIQg7kB+hrUBncxzO3
	 RlVDThUlgZIkWbzcxYS5LqCJPnjwFFsbnJVq6D8iBq4mxSxs63f2KmDWR4xRdKm8iZ
	 hbcR+TtWwM5JKECVUz75ery9pguse69UYjJNpV3hEjn28sFBtNua2Vj7iHhT7IJYe9
	 +VSOwl20lS/yq62OpyLVLd60JQh+ZrYpC5mHFEWsm6txGt3xitn0yot6UGjInmENBw
	 rSNQ1Ck68OommRgaaY4xvpXNN9qL2FEZV3qDtQzktOvCdd8YJe5UoGdTeyaGIQibM2
	 Jy8oEGQPdYEXA==
Date: Sun, 3 Aug 2025 08:47:28 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v3 1/2] man/man2/mremap.2: describe multiple mapping move
Message-ID: <ngytuoex4uvu5epsdqhvhypnhqidkr7cpwmmcxrml6kpftgusb@jo5ql6eko2ir>
References: <cover.1753795807.git.lorenzo.stoakes@oracle.com>
 <1fd0223a6f903ffdd8ba644d0b67820b1921671f.1753795807.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1fd0223a6f903ffdd8ba644d0b67820b1921671f.1753795807.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Queue-Id: 4CCE980002
X-Stat-Signature: 5bikhf53mef9jsky55kfuypkdt6ta63i
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754203656-477258
X-HE-Meta: U2FsdGVkX1+gha+AB79JysvELSdZ9CQ+Vnts1lrjoHcr7mjfm6bhRJBuxGAmeKBAyqw0wYvdTNNzzmFbG0/LO/8u0dgw2GH/WaQTLz2KiGiSUPF/KtdCFEMe4tMtiJDUO3Wofv0CU6NBeysaZ1CD/pkEj6oUI4MRnoQPkEl8qMhvuwi75kOoVW6tlbf+SvicGTH/Z6fNUZCIHOCowpSYjE9TeYHP9F9YpzgqcgT1f0HM101jS6Uhca2xHfv2tw0uthgIaTNUuZrGZN4iTL9eJZDHGSftYk6QVaiK4Ss5ebXWyxw7fzSgbriJ4qec5CcvWvqCKkZy49NxSKOud3sgh7SbLFCkqbfV56gqSKCJgWnk/5fHpE9SUVfkxqX8nAUT9TtWWe+ZkMg92BnWZZNnrEjkEQMv5pgPS9b664YeILxOZxA5GDfnQpw2Aaqt/Z4RkMSKorqE/uZtwFV1axVQuxg0Sw/6yRQRZdHHszMoue49Yz6WMS2r1wRyB3Yf59Z1f+gIqJ9p0FS0esyyyWt8rQVls66SU2XNnD5sZDLkJwuacvNMPhChiPxHDPusZWPDyW9lbt7qlfzJC1GP4oJBCTxTF7g+D1QYjDlg4xgFNghiIh5Hs8sVY6ORaAiMnqk5yJnnH8ETYnx3naEYuPIRsNXBwCwUyLPJOMzCxXP7LYi0a2XTtakHvuldpiP91WLXjGKkZ4NdbRv+CHMSHkyZr5JqQJNXiJEXvqszfqqBp2zEGzlCWnYYcn12FkHBWJhdGl4ZKtYlOME7CbsLOtTKHPP+9DPmacVyiUYkrz9/UF8JRmwVoUl2P6PLJm7GHa2NsC6yX0BfiGcPaqSFXmhwekGniHbpdKPH8CBsN4uZYrCgprIRQZg+qY0aX1/UGuHtCzR+gjcKdM2+6Ca6fN9iZsrXYbrrbHeko8yHyTelsjpG0L1SH5KWTyaMOIUmsEnULJfWzIoFb7MxX1rnQz/
 iVVtkpgG
 IXQYZbM8utF9Ok2jlGwfYiPsTDb9ji2BoSgaYMH2n7j6sbtUWdlSvkNb5aKR+Tx/GL+RkbjRaymk26MaZ3QCqoP0Qdp6WVXAKK3hvo1lgNa9z4/yOoOlPv/iJWleVO6yEY/irP90vZ2TW8UZZ350TQa2ZfMysxsXC7xL7vHzLPfvj3Pzrynafo2Jn+259tgdRs8JtEA92ytTMsHg9wWN92Z+5EWLPO8XGIOr+Wy6RpjQS4qMHAHCiT7Jeh+LI8osazlnRzkxOnG0HOaoqcQzNwU5uIcGgaZuTpn99n3TOMLVi/B2feTxcag+wm0nRhh7dvV/k9qBpHWcybhdamUVtdbsNRA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

On Tue, Jul 29, 2025 at 02:47:35PM +0100, Lorenzo Stoakes wrote:
> Document the new behaviour introduced in Linux 6.17 whereby it is now
> possible to move multiple mappings in a single operation, as long as the
> operation is simply an MREMAP_FIXED move - that is old_size is equal to
> new_size and MREMAP_FIXED is specified.
> 
> To make things clearer, also describe this kind of move operation, before
> expanding upon it to describe the newly introduced behaviour.
> 
> This change also explains the limitations of of this method and the
> possibility of partial failure.
> 
> Finally, we pluralise language where it makes sense to do so such that the
> documentation does not contradict either this new capability nor the
> pre-existing edge case.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Would it be possible to write a small C program that uses this new
feature?


Cheers,
Alex

> ---
>  man/man2/mremap.2 | 84 ++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 73 insertions(+), 11 deletions(-)
> 
> diff --git a/man/man2/mremap.2 b/man/man2/mremap.2
> index 2168ca728..6ba51310c 100644
> --- a/man/man2/mremap.2
> +++ b/man/man2/mremap.2
> @@ -25,18 +25,47 @@ moving it at the same time (controlled by the
>  argument and
>  the available virtual address space).
>  .P
> +Mappings can also simply be moved
> +(without any resizing)
> +by specifying equal
> +.I old_size
> +and
> +.I new_size
> +and using the
> +.B MREMAP_FIXED
> +flag
> +(see below).
> +Since Linux 6.17,
> +while
> +.I old_address
> +must reside within a mapping,
> +.I old_size
> +may span multiple mappings
> +which do not have to be
> +adjacent to one another when
> +performing a move like this.
> +The
> +.B MREMAP_DONTUNMAP
> +flag may be specified.
> +.P
> +If the operation is not
> +simply moving mappings,
> +then
> +.I old_size
> +must span only a single mapping.
> +.P
>  .I old_address
> -is the old address of the virtual memory block that you
> -want to expand (or shrink).
> +is the old address of the first virtual memory block that you
> +want to expand, shrink, and/or move.
>  Note that
>  .I old_address
>  has to be page aligned.
>  .I old_size
> -is the old size of the
> -virtual memory block.
> +is the size of the range containing
> +virtual memory blocks to be manipulated.
>  .I new_size
>  is the requested size of the
> -virtual memory block after the resize.
> +virtual memory blocks after the resize.
>  An optional fifth argument,
>  .IR new_address ,
>  may be provided; see the description of
> @@ -105,13 +134,43 @@ If
>  is specified, then
>  .B MREMAP_MAYMOVE
>  must also be specified.
> +.IP
> +Since Linux 6.17,
> +if
> +.I old_size
> +is equal to
> +.I new_size
> +and
> +.B MREMAP_FIXED
> +is specified, then
> +.I old_size
> +may span beyond the mapping in which
> +.I old_address
> +resides.
> +In this case,
> +gaps between mappings in the original range
> +are maintained in the new range.
> +The whole operation is performed atomically
> +unless an error arises,
> +in which case the operation may be partially
> +completed,
> +that is,
> +some mappings may be moved and others not.
> +.IP
> +
> +Moving multiple mappings is not permitted if
> +any of those mappings have either
> +been registered with
> +.BR userfaultfd (2) ,
> +or map drivers that
> +specify their own custom address mapping logic.
>  .TP
>  .BR MREMAP_DONTUNMAP " (since Linux 5.7)"
>  .\" commit e346b3813067d4b17383f975f197a9aa28a3b077
>  This flag, which must be used in conjunction with
>  .BR MREMAP_MAYMOVE ,
> -remaps a mapping to a new address but does not unmap the mapping at
> -.IR old_address .
> +remaps mappings to a new address but does not unmap them
> +from their original address.
>  .IP
>  The
>  .B MREMAP_DONTUNMAP
> @@ -149,13 +208,13 @@ mapped.
>  See NOTES for some possible applications of
>  .BR MREMAP_DONTUNMAP .
>  .P
> -If the memory segment specified by
> +If the memory segments specified by
>  .I old_address
>  and
>  .I old_size
> -is locked (using
> +are locked (using
>  .BR mlock (2)
> -or similar), then this lock is maintained when the segment is
> +or similar), then this lock is maintained when the segments are
>  resized and/or relocated.
>  As a consequence, the amount of memory locked by the process may change.
>  .SH RETURN VALUE
> @@ -188,7 +247,10 @@ virtual memory address for this process.
>  You can also get
>  .B EFAULT
>  even if there exist mappings that cover the
> -whole address space requested, but those mappings are of different types.
> +whole address space requested, but those mappings are of different types,
> +and the
> +.BR mremap ()
> +operation being performed does not support this.
>  .TP
>  .B EINVAL
>  An invalid argument was given.
> --
> 2.50.1

-- 
<https://www.alejandro-colomar.es/>

