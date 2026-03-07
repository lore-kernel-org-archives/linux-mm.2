Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC155FC9ED9
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 08:35:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C6296B0005; Sat,  7 Mar 2026 03:35:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 849A26B0089; Sat,  7 Mar 2026 03:35:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74C1E6B008A; Sat,  7 Mar 2026 03:35:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5220B6B0005
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 03:35:23 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EE4251A0996
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 08:35:22 +0000 (UTC)
X-FDA: 84518607684.30.7D1A076
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2FF94C0005
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 08:35:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U1V06B4R;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772872521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QVTkeILTN+3dkrNKz3pIr31h6YitFNNyeop1LfRCmtE=;
	b=fJlZYTskCvd3Qg/Kbh5vB1aEzWyGsuN5wlZLAff7EMPhKpEM7N+0eMDajSHI8uSv5xAlWH
	t2NU7YmVXoru1j3cJXDvNvc9jx0ckRrK3tnqLnp2SMs0JS12ztXSpejCZzpgFeraAzn1t/
	Nv0AXFar3td0HG8f1rR61DHo96m4nBQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772872521; a=rsa-sha256;
	cv=none;
	b=NHY5h6iqGA7zxocUOXxHGw1vqAPfERmp3Aw8v1x/fFKkEgH2pOjr3pBDW1djN+mjRtV89d
	Edmp327xZZdMmimYx6MjWxHXw1MOOx+UmGaveB4/leQwK6Rpv6qK4QS4zRkvzcf2vZ5/uB
	fXHriLQibWO4a59pfP1atZBXTyLrNZU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U1V06B4R;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C604240167;
	Sat,  7 Mar 2026 08:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26D0C19422;
	Sat,  7 Mar 2026 08:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772872519;
	bh=IUec4phBo+gJNl11iivFJAzINunEnkm6/ApxvPCt44U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U1V06B4RqNsdkoHtTSGDFOu1K3g3KGkd6lAeIujivtukZ7J0lvRKG8FmX86lql1vh
	 1EUL8kstKKHpQKm/+CTv5L/EkvH6PGZtqOuz8tPHMi2eERCtRe3+LzjKH9En+UAu8K
	 MhGgl2wwBcfdm+V1sCnc/VgdIDPOm+Tl2Kn6TP59okq3OYhaVYAdF5HtL+Kfr9B97L
	 bCuO4RMnZjwgszr6lY6UXIPxLuBN2UbHVtatHMB/88KvQHr8QRKGRtBqOnCHGAsMhh
	 lGjv9yviIQgwyzjJFNE9IK+YnV54SMW+CahlWMKTzCqIhARqmsuAvq72JylB0dFqFE
	 ClCPJHihLU8uQ==
Date: Sat, 7 Mar 2026 10:35:13 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-dev@igalia.com,
	kernel@gpiccoli.net, Andrew Morton <akpm@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH V2 2/2] mm/memblock: Add reserve_mem debugfs info
Message-ID: <aavjQcA9mHjvIhhI@kernel.org>
References: <20260304203300.1414286-2-gpiccoli@igalia.com>
 <20260304203300.1414286-4-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304203300.1414286-4-gpiccoli@igalia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2FF94C0005
X-Stat-Signature: t4d1poar6zzg59x6rf1xa9j5rm6gmx5m
X-HE-Tag: 1772872520-395654
X-HE-Meta: U2FsdGVkX19ANI4cX/QoTMD4KvZVoSbqiMMj5wSEK9p4jl3Is107vBUCJD4GQUR7lyCewTYYfn8fpQFBut/6hMjyRlh8kXXHtepRiG+iiYchcf6astiRiUTp1XeXddGY96qSrAVI6JjSr+lN7C3aCf2i685FiiZ0fHX62Oq7C/eS0YKma9awWuAhXbWXqXaWA5uq15U/ke7X1l/c1qszuWJTpQmS9IioKOUZCdc/aQCAyH41rbP4zrhUxVp7KnirmyIU8oJKsdwlIFNG7nwMEUKzaq1rnpA+915eIVvth0gUTHCsO/CXy4+KCamDCpKt19UYyTA+ucPKqDKBBWTsJmVYsAaNs/qJ8KpNyd5d8+nJOs62EYC7r0ff4djCVr9kjP2ZgJ2E2+cFeOy1Fb55FRLUSuTRme3IYFv9UwJ94bcaHQCcVKrQLVEcYH1/C6fy/eniXDIDA5lvTu0o/6KJLYpkkv382WL2PUszqAtqflhyfqYFpPXOZxvN7NqkoJ9IRU75IYseldVX4KH2bEMW0AJYtQdHar3hOe3PfuxovGF5V9vVA18sRZsWDyixVCVQHhI2FpVgeyz8jL3GsSetcd/Mw45ure+uFfS8PcaNMdoU6mhJBjfCcWxTZ/NwQWdvDrRK84/D/Bxm32P6PMFiA9gtIdxhhYTm1iinYXbyKx3mirsHOp8HAWAv1ZLR+cswZiw8Z6n4YB4/UMoC/oEEE7ZSipGvfsyWAAp/RYrupURg8crRNJ7/k0qdhZmYYVnct7oI72uU6MURZbvz0SGUD0tl6yYTwk+idtuBi2y4H+7sjEJifZtubPlNI5JlkOhO/DEN+sxZQ1pHyovBmAvLQOK0jWwoE20vJ+AEScTuR67K+ih4SN6V0R+5X0VdbdENnLqZXkyOMkKqV52wkqnj6Eax1u5Plv+WUCdqZDauGo84GkkqqJ0XUwaX+6131biSQ2ekBjpgc5yLHofADV2
 jl/ZyRwF
 eREX9KTyus4M44jjshCxWdNvo2eVSWvTz1UfV5h+DXkHcPLYfp9qfHLuYBNGfKXsdPMJadeQjxgfa3WWsD6xm6tiMA03tbxOz0981ajJ3cqOazZb2+hBnRU3xHVrLhi7GI+dpLs3Qt730fK6YQLCbKpnlXnmamAZrWyP68dZ0s9EtY6Hwc3PyXkiIszj8aA1BHq271mBViRzqOKEICGx7ArDH4EoH25z/yQQhE6I38FDcwVjNFASU60ifdN5zYqq15u4ECnk9qTH/ZWtcfvjWSoFHjY6yiJVfhFRXz40Oxik0Rku/s+fWP54x+jV8QPjpFT4CQFBNjZoZuyvC9JAUapJ9jtpZ5Oo/t4+5YZXq/hdNp4ZLzX4ddm1Lxp7gAexEtwDvHNOQXMgy7jVW6L1MiX6gEH9MSOCIQGMObGGTDKIm/0ApZcpw5rFf6aJJ4e33FMXuj1Srzka7G2ORYuLIAivbsCCqxSJyN4NR/NE5gPsZy8OIT7DYpgxcURfAiaBAhVum8MkY7chPtvg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Guilherme,

On Wed, Mar 04, 2026 at 05:14:11PM -0300, Guilherme G. Piccoli wrote:
> When using the "reserve_mem" parameter, users aim at having an
> area that (hopefully) persists across boots, so pstore infrastructure
> (like ramoops module) can make use of that to save oops/ftrace logs,
> for example.
> 
> There is no easy way to determine if this kernel parameter is properly
> set though; the kernel doesn't show information about this memory in
> memblock debugfs, neither in /proc/iomem nor dmesg. This is a relevant
> information for tools like kdumpst[0], to determine if it's reliable
> to use the reserved area as ramoops persistent storage; checking only
> /proc/cmdline is not sufficient as it doesn't tell if the reservation
> effectively succeeded or not.
> 
> Add here a new file under memblock debugfs showing properly set memory
> reservations, with name and size as passed to "reserve_mem". Notice that
> if no "reserve_mem=" is passed on command-line or if the reservation
> attempts fail, the file is not created.
> 
> [0] https://aur.archlinux.org/packages/kdumpst
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> ---
> 
> 
> Thanks a lot for the suggestions Mike! I'm not sure if you would
> prefer a Co-Developed-by or Suggested-by instead of CC, you helped
> a lot improving the code. Lemme know and either I can re-submit
> (with potential other changes) or even, you can change while merging.
> 
> V2: (all suggestions by Mike Rapoport)
> 
> - Commit message (showing use case);
> - Drop ifdef on include "string_helpers.h";
> - Don't show the address of reserve_mem, only name and size;
> - Fixed flag names inside ARCH_KEEP_MEMBLOCK ifdef;
> - Make use of its own show_attribute instead of refactoring
>   the memblock one;
> - Use sizeof() instead of magical numbers for the size;
> - Don't show memblock directory if no reserve_mem succeeded
>   and ARCH_KEEP_MEMBLOCK isn't defined (keeping current behavior).
> 
> 
>  mm/memblock.c | 37 +++++++++++++++++++++++++++++++++++--
>  1 file changed, 35 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 2d2646f7a120..d816796ab919 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -17,6 +17,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/memblock.h>
>  #include <linux/mutex.h>
> +#include <linux/string_helpers.h>

This will break tests in tools/testing/memblock, please add a stub there.
 
>  #ifdef CONFIG_KEXEC_HANDOVER
>  #include <linux/libfdt.h>
> @@ -2711,7 +2712,8 @@ static int __init reserve_mem(char *p)
>  }
>  __setup("reserve_mem=", reserve_mem);
>  
> -#if defined(CONFIG_DEBUG_FS) && defined(CONFIG_ARCH_KEEP_MEMBLOCK)
> +#ifdef CONFIG_DEBUG_FS
> +#ifdef CONFIG_ARCH_KEEP_MEMBLOCK
>  static const char * const flagname[] = {
>  	[ilog2(MEMBLOCK_HOTPLUG)] = "HOTPLUG",
>  	[ilog2(MEMBLOCK_MIRROR)] = "MIRROR",
> @@ -2758,10 +2760,40 @@ static int memblock_debug_show(struct seq_file *m, void *private)
>  }
>  DEFINE_SHOW_ATTRIBUTE(memblock_debug);
>  
> +#endif /* CONFIG_ARCH_KEEP_MEMBLOCK */
> +
> +static int memblock_reserve_mem_show(struct seq_file *m, void *private)
> +{
> +	struct reserve_mem_table *map;
> +	char txtsz[16];
> +
> +	for (int i = 0; i < reserved_mem_count; i++) {
> +		map = &reserved_mem_table[i];
> +		if (!map->size)
> +			continue;
> +
> +		memset(txtsz, 0, sizeof(txtsz));
> +		string_get_size(map->size, 1, STRING_UNITS_2, txtsz, sizeof(txtsz));
> +		seq_printf(m, "%s\t\t(%s)\n", map->name, txtsz);
> +	}
> +
> +	return 0;
> +}
> +DEFINE_SHOW_ATTRIBUTE(memblock_reserve_mem);
> +
>  static int __init memblock_init_debugfs(void)
>  {
> -	struct dentry *root = debugfs_create_dir("memblock", NULL);
> +	struct dentry *root;
>  
> +	if (!(IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK) || reserved_mem_count))
> +		return 0;
> +
> +	root = debugfs_create_dir("memblock", NULL);
> +
> +	if (reserved_mem_count)
> +		debugfs_create_file("reserve_mem_param", 0444, root, NULL,
> +				    &memblock_reserve_mem_fops);
> +#ifdef CONFIG_ARCH_KEEP_MEMBLOCK
>  	debugfs_create_file("memory", 0444, root,
>  			    &memblock.memory, &memblock_debug_fops);
>  	debugfs_create_file("reserved", 0444, root,
> @@ -2771,6 +2803,7 @@ static int __init memblock_init_debugfs(void)
>  			    &memblock_debug_fops);
>  #endif
>  
> +#endif /* CONFIG_ARCH_KEEP_MEMBLOCK */

It becomes too #ifdef'y :(
Let's put the creation of these files into a helper and add an empty stub
when ARCH_KEEP_MEMBLOCK=n.

>  	return 0;
>  }
>  __initcall(memblock_init_debugfs);
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

