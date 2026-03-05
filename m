Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63A64EFCE53
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 01:44:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4FD06B0005; Wed,  4 Mar 2026 20:44:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFD4E6B0088; Wed,  4 Mar 2026 20:44:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B09A96B0089; Wed,  4 Mar 2026 20:44:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9D0C86B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 20:44:40 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 31AEE140782
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 01:44:40 +0000 (UTC)
X-FDA: 84510315120.16.00C3C9B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 96DAE1C0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 01:44:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gsgRJd/f";
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772675078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41gT5zlXW8zaQje3NXkKuudNR5RWiMZSuzYkM6d11y0=;
	b=ixYdbfNtxqZnaxxfWVPzVyRqUx4ASEOOTy9O6z1+5JgCW+TmOT0cNoeKeDzvcHzmyGZuWz
	2cG2A1Ka/2XMvnGc9bmTg8DLuGHHJyy5TLYBcybqTNY66fNHhAYy5nXA0CqAhRMPPNFg05
	q/3OTxF3R9tWuwRGMYeokSkQT8AvEKU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gsgRJd/f";
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772675078; a=rsa-sha256;
	cv=none;
	b=s2qWjWWNpPct/GUuwoevw5e4SffnW/Yg/jF8AeThJ9K6FjJseMt5GFTaeo+B3GzNsmz2qF
	f2zKo/KaH5VFHLga2CSR/FpP85yvF0fwkTP+PTZ5dphhCC5CY9lJdGCy0EAtrIwhnRp2Ka
	whrXrrdi4qZoHbXgwEexh9judXuOtGE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D8F8E61339;
	Thu,  5 Mar 2026 01:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A108C4CEF7;
	Thu,  5 Mar 2026 01:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772675077;
	bh=8cK/dAPP5M7ouUdNRMoLceOZ4hK/4N1DjTUvzKkArHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gsgRJd/fvGqycFcJFH1k0m4xF437X0fxd9AGTaJPiu2jK8HBNogzN2hAb1YWKD6XV
	 EwniZ6DDWSqBEaMq14p7Ay9W5OvMdJBRcde7cFqVs2Dfy7MfUnmJA7tfg8abGd/z/V
	 0To0huEjtG6gyzKAEjtlnPuNWlzdjXp6PkvYbgEtfavVZ97C5+6sx5/kZ3BQVXOhOI
	 3eUnqSnIwe5eBPpSrpWGske4bFsrvRVWhsLWbi3EfLuugf1ZhUTNFp93RkmHDG0HLT
	 pY4ReSx9eksJ9pU95MUZhODNJzVO1QyZsJdtfIzeM/BKsmsIYNA28Kun3qp0/wJ5YW
	 /EFAfFACoSPTA==
From: SeongJae Park <sj@kernel.org>
To: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	rppt@kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com,
	kernel@gpiccoli.net,
	Andrew Morton <akpm@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH V2 2/2] mm/memblock: Add reserve_mem debugfs info
Date: Wed,  4 Mar 2026 17:44:29 -0800
Message-ID: <20260305014430.79405-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260304203300.1414286-4-gpiccoli@igalia.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 96DAE1C0005
X-Rspamd-Server: rspam07
X-Stat-Signature: eou1j5s6q6txiw1tgh74twk5r5tomirb
X-Rspam-User: 
X-HE-Tag: 1772675078-580444
X-HE-Meta: U2FsdGVkX1+uenmIGeyZBIkPGITPHSPDmgjMEMwSPLfNn7rmMXPkZAoqX6yamzo3w90aogpbwJ9E0/Q951TyiJ5SuKlTK0EH6JJQdd3VLBnbzBSZEP99+tkjvd9DDrFUtiUwoANYdLVAbuKUtx32SDG4uNPtYGMa4PC2B6/1wpMgOZG11WjcOvrF1cXzItUbhRFoceC1rSQlDcT42++1EFQ/vfz234yb36piwGd8wPsgS9ngYgf3waWOWZh2AmuECncqjb1jb+Ps8fwClbu+gHYTsCxNM2uEFZwLkYH1L06ckIppdaF2ypptaSdR7tkozUZqy1bQnn4/zaoYWfeT14rjzm27qrS/oyolXVbFvIQ7a9Mr3OWL9oEbB1yETHrIk8FI4iob3ykuFaIIzi9eZvL4F9aJN0ke1uXDOWftsMIXtiyyyAZpDmAY+ZItOkREQ7UwB+oYiBbZn0n0VVK0sawipdjMjnMh1WhPl0lfBmSbMd1U6Xu9crTmZDctY07vsWkdBb/AHY2de11i9imsP0MqwbIIf53y/1gQBUJFnUlIkuAOnAbbrIjbEG4AGDjbKstsKiAWGPSkkLlKIvJMp4xAszo3LRajD2eoGQQDWaYeUiDZqMbr9eSDeVVrXGW2XPPxgXhKmfW9phPQyKW83ilh6UGVsp8LrUnG0rDxI8ekZdJXr5GM0T4PvKY9hoee86+nNjbiUi0WCRkvcU23gT2sbJ3i+nmA3Tw4NtSIzPiiz76b2kKJmCqYtERnKRQtHECuWZr3Qbgk5DSlGe4GqAVtXkUgOqNMnc5HcxEODoAlVvblkGAl5MpGTw3FW6a9/TIVgitqz4NGswfi/KmSpmiXZNzEZXd+sjZlxnGNzM/IphjduLOSvQp9NY8xRqow7tfL6O9CD8W0qxSfI23j89GjNqco0MNieYRCOQgs2gbKu57Od798pdrczv6Woq6sONGLdFka9YFneR77GLr
 5qOEm9OU
 +UzulMigL5U+NJbsFu7A43EcQRjInutsluAkV6cv4ZXbFVcC9EK2Nws+am+imhxzqqoWoA2ytYyOdXzLmQnzm8eE3g8VgxutOQf1Q4DEQt+OCEz+ihQxXs6fYVRcMHeCTdS6jebzlBXozNc8g9Qt/eNplST8+Ncb3iuImEmCawaqQBq1PZcFacE18RndszwqW9dposxAs7JRyqlNY+nr06/ixtYvk9jgjsezAu4C+3QU9e2H9SFo13VEWPHTAXxaoTLIauUBv/qSBJRRgVKxeenPa8/mPXb6nRnegdhqO1vDsHq+T4EG/PT3rXND9oBSneZ9WyYodAGjObwHGfEcT0nzlJgxaWvEH+fFW8ounmiyGshQiqekEWfjGSxsEwZROHg1kLCJ5BDAz6zF+J1BmY49G/CGq6VFHP23heKKGkQcEHHkMTPWaPZsWWYgEnk/R49v1+MTlTOBAfuxxi+z4PZpowqWNmqudXHTG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  4 Mar 2026 17:14:11 -0300 "Guilherme G. Piccoli" <gpiccoli@igalia.com> wrote:

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

Asking out of curiosity.  The previous patch has added the error log for
failure cases.  Could checking the kernel log to see if it was failed be an
option?

I think this debugfs approach is easier to check for the user space, though.
If that is the reason of this patch, adding the clarity would be nice for a
theoretical case that debugfs cannot be mounted.

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
>  
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

One trivial comment.  I'd slightly prefer having one less parentheses level as
a tradeoff of having one more exclamation mark, e.g.,

    if (!IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK) && !reserved_mem_count)

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

So, we get two level of nested ifdef...  I'm wondering if returning earlier
when CONFIG_ARCH_KEEP_MEMBLOCK is undefined is easier to read.  E.g.,

	#ifndef CONFIG_ARCH_KEEP_MEMBLOCK
		return 0;
	#endif

		debugfs_create_file("memory", 0444, root,
	[...]

>  	return 0;

Very trivial comment.  Why don't you keep the original blank line above the
return statemtnt?

>  }
>  __initcall(memblock_init_debugfs);
> -- 
> 2.50.1


Thanks,
SJ

