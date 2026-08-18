Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89FC6C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 07:11:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 816476B03D0; Tue, 18 Aug 2026 03:11:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EE566B05A3; Tue, 18 Aug 2026 03:11:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DD346B08F7; Tue, 18 Aug 2026 03:11:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E2276B03D0
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:11:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CE02540ADD
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:11:08 +0000 (UTC)
X-FDA: 85113518616.23.9FA4280
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 487A720002
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:11:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oPYKmsqs;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787037067;
	b=khgHRRc3NgvcCZao8GHiYvJrdcYRYLFRhhEf9h2mnuYnhNFA39+9l75ev2oRUdXmEf+FKR
	+OzdqEGiUL0Pp5zaHgH2FOklu4wGVrXVebb9xOsoXvlQ6424cy5lYOphqQXiOlzY+bJSli
	+munAZuQQvZbUZgWwS6cvYHvIiN9EO8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oPYKmsqs;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787037067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hcKP0GI/8MCMjQwWzxd7ikqJRzxxF2VaTggnrgcABlk=;
	b=2vNDma6L+TUBInKIRM7IM7uM9Dm/vJDyK5PV0rzG3nYx902a4+p/pd2z6eZx4clZG/fC9O
	iIeb5rxW64ygKGdl34x6oOix/YsKSMKafDWD5kNg0dssl514+kBlPIJFtZDDLyN/lVoR1T
	ijwEYr8W7ycOkfo9kg+5p+vEVoCgOko=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C6DB0601DE;
	Tue, 18 Aug 2026 07:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA731F000E9;
	Tue, 18 Aug 2026 07:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787037066;
	bh=hcKP0GI/8MCMjQwWzxd7ikqJRzxxF2VaTggnrgcABlk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oPYKmsqsTLaYnsgF4u2veT2txSMhhZZUUeSbMLopLJAqC1cViPnqitdh0VU4sCxJZ
	 vklK8cfYEd5nYknsnbskjjNjSIa6ENmFxsP2t8+k0M1MnDOQgrQyzFscoufJnlpEW9
	 dIM/7z3OD59/ZOB9xWtYhkoWHBSrR4dsgH8v9/embqCjrftRIwyza0+3Lbb6ujyUxk
	 RqL099o+eCBsjeevXNzG8PQVIW8LwJvaHrMgwpJZr6gxxd77FX8/lnjdCPwYiFnBMB
	 yUIjqeXM+iybkw3rjWcPvKruuM3Gm0yVXoFNGuFSQPkhL2sTyG+f7T+D32f2i8ZDxo
	 jyNOnApjgnwRw==
Date: Tue, 18 Aug 2026 08:10:46 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, hughd@google.com, 
	vbabka@kernel.org, annh@google.com, ziy@nvidia.com, liam@infradead.org, 
	nico.pache@linux.dev, dev.jain@arm.com, ryan.roberts@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: fix incorrect vm_flags usage when checking
 allowable orders for tmpfs
Message-ID: <aoQFTrWDqIEOvZvv@lucifer>
References: <7d5b5eb27be798f89d563b06254c947ff53db0b2.1787020910.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d5b5eb27be798f89d563b06254c947ff53db0b2.1787020910.git.baolin.wang@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 487A720002
X-Stat-Signature: dj5imr8anromtdhnmd9o6bgh6xp66x9k
X-HE-Tag: 1787037067-618640
X-HE-Meta: U2FsdGVkX1+r4Jz+PpfLjGGHG7PyChO96afRJf8HooDV9F5dzua6riA7qZCueOkdgLuoW0Nlm0zNMZ/0A7Ehnt70B6kn5w07bHTGHYvNTCMPcOs/dScHzTL8T1EDOWgzycc/pE24WvdMBvnMpE5iMtqe7zJxoUobOWq65Y58SmccbT8zCOYYLuB0TDkKLG1b7oiD6qduFirf+YlbaWkyWEbdGqcdA814wrz13Nw0sqgOohw1D5Aig0WVN+GCGyu6fXv/eNaY3ILLCMw+dtIgtGE7ZHp/V1g8EIZS5yPzcNV9K5qrsVQKfVs3mVPXcpetsFfVlh2Vf/cF8Vd2vuIw/1xP47oH9WnnkfAUhsx1jWc4mRQTfjlPPbOLgzYAvGG5KfkrdTFrt53n1ZsB4mDjF/T1k79BPxj8hGS6Oes/+HKD/0EeLbc+3CM1i3sOj3uU6ZxrcSfKuvReXYJ9Jh/+H4B3fjaqJBrCGwu44Mq1qDXDyKmBbaBKqVaN8J+PWZR95zz3zQLPdHWXWaOeVKi4bGFoYdu6Izh2dHtstyp+9GZ/0ThigArSMvN7PehFpFjXmFAhioR+qIhzJlcZfcndJsITk/4AOP1QSIYtOPVTVxiJaD2TdSoAN4Umq4UkaPvTJ7Zvd48CMAv2BQfm+QacLlOPt4HJmzehvGM3bXSDqmpru069ErgAxXqM79R2iYy+oDAWr+dOaa4n/FH2UtEbECUPjMrFlw14FHba8zLtq/kIoSpou+SmD6kgIdnuVnZfiUg4UOwuBXdvv3Q1TO6xjkI1n4VzzE7l2TJipcaWyVBYsuapN51y9PLJeL+ToikOx7JA+LdG48jqV2+VwEm6Fh3aCIv4vs0RNuKlyoqCWmV3sFigpNyQzBlQIaMUPGIxB51nDUDDJZWxXg0f9sUlWV3UwOXXdTAFok7yoNOcVAvDeFoe3Ra8ULAHLEJfrvJJ4KvK7SM5Fp/idZm+TcA
 SmfO6bUG
 4guJPsnbnYF6hEo5ch59A2YPkEX99M1HjqcYOUhh32tn8dl4ERACIjW4+S2Y4xQb+sj7RofZ5hrywyT4zUR7YHY0FvKJdOUa2A0TnU2rrcqrhKaQTtY+oF4l/pbnq4KhVQmXyeKLUpev1AeFe87Oc8m7PpHqj1zAJjSNvgVpQ0BH5sjtWwpzcONZi3UFb9h3m8nEAqzdSAtQteeBrWS6Yi3vN/JarH0XY5V5FzXuQxEx4+LNd0I89t8KoPDr/kwhyS+3xtabhcZ/Hzz1RlaOZnYcyJffWUrWwZ3yRRkW2ZrsYInl+H4dMbQ956SGIF9BJWvDMhK1GrVdmB5Sc0GlHiotwaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 10:47:26AM +0800, Baolin Wang wrote:
> Lance reported that when nothing else causes the mm to be considered for
> khugepaged collapse, an MADV_HUGEPAGE-advised tmpfs VMA alone does not trigger
> scanning.
>
> After commit 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled() into
> shmem_allowable_huge_orders()"), the shmem/tmpfs allowable order check reads
> vma->flags directly.  However, when MADV_HUGEPAGE is handled,
> khugepaged_enter_vma() is called before the VMA's flags have been updated,
> so the check uses stale flags and incorrectly rejects the VMA for collapse.
> As a result, khugepaged does not collapse the tmpfs file into PMD order in time.
>
> Fix this by calling khugepaged_enter_vma() with the new VMA flags in
> madvise_update_vma(). Meanwhile we can remove the khugepaged_enter_vma()
> in hugepage_madvise().
>
> Reported-by: Lance Yang <lance.yang@linux.dev>
> Closes: https://lore.kernel.org/all/20260815181632.21453-1-lance.yang@linux.dev/
> Fixes: 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled() into shmem_allowable_huge_orders()")
> Cc: stable@vger.kernel.org
> Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Thanks LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> Changes from v1:
> v1: https://lore.kernel.org/all/ed34ca03ae7d65e89467fb87bc961f5497049c00.1786948410.git.baolin.wang@linux.alibaba.com/
>  - Update the commit message (per Lorenzo).
>  - Call khugepaged_enter_vma() in madvise_update_vma() (per Lorenzo).
> ---
>  mm/khugepaged.c | 6 ------
>  mm/madvise.c    | 8 ++++++++
>  2 files changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 5a06e3942e88..79effd3f3da4 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -454,12 +454,6 @@ int hugepage_madvise(struct vm_area_struct *vma,
>  	case MADV_HUGEPAGE:
>  		*vm_flags &= ~VM_NOHUGEPAGE;
>  		*vm_flags |= VM_HUGEPAGE;
> -		/*
> -		 * If the vma become good for khugepaged to scan,
> -		 * register it here without waiting a page fault that
> -		 * may not happen any time soon.
> -		 */
> -		khugepaged_enter_vma(vma, *vm_flags);
>  		break;
>  	case MADV_NOHUGEPAGE:
>  		*vm_flags &= ~VM_HUGEPAGE;
> diff --git a/mm/madvise.c b/mm/madvise.c
> index c179938097bf..cb93cf82d8df 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -178,6 +178,14 @@ static int madvise_update_vma(vm_flags_t new_flags,
>  	/* vm_flags is protected by the mmap_lock held in write mode. */
>  	vma_start_write(vma);
>  	vma->flags = new_vma_flags;
> +	/*
> +	 * If the vma become good for khugepaged to scan,
> +	 * register it here without waiting a page fault that
> +	 * may not happen any time soon.
> +	 */
> +	if (vma_flags_test(&new_vma_flags, VMA_HUGEPAGE_BIT))
> +		khugepaged_enter_vma(vma, vma_flags_to_legacy(new_vma_flags));
> +
>  	if (set_new_anon_name)
>  		return replace_anon_vma_name(vma, anon_name);
>
> --
> 2.47.3
>

--
Cheers, Lorenzo

