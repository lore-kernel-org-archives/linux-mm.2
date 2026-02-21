Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8788C61DCB
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 08:52:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06D7D6B0005; Sat, 21 Feb 2026 03:52:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01B156B0089; Sat, 21 Feb 2026 03:52:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E69166B008A; Sat, 21 Feb 2026 03:52:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D4C106B0005
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 03:52:46 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6A1461602A3
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 08:52:46 +0000 (UTC)
X-FDA: 84467848332.07.59CF49E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id CDEBC40009
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 08:52:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NzhTaumS;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771663964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cRBo0RxqaUPUOOgsI0DNWOWjuQSH2Sw/5vvxe/Ta19w=;
	b=mEjnInDhBL71iu1gp09WNmrmmN76vyfeXihbhYXfkeYpbS+TtkEmFIdwPL0gVLiMo+78lL
	UR06H300NaJriGwQYVpahjQBugFGtnqNr6hUsqrn8EHg2eUobsLBkY25Cwry4Y6u5SpiqQ
	6IV3qNOZMPt9+bxqmwdoqJgFWcm58qY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771663964; a=rsa-sha256;
	cv=none;
	b=mnIqAwxrUt0MhkI3feYd2YjExpMT+egM7WsqN9OXJK2LdZLTTrJdp6xUWhjIf9XZ1QllLz
	OzrzLks9scMOwyaMZKD+FMshNM2f2m3a5hGhoWfzupUw+6gA5vtvjKsm9QvgO4am0rGGyT
	PNBk2ZP9ZvEqORSGd42XZiTOcRPCRLo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NzhTaumS;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BC92B436F6;
	Sat, 21 Feb 2026 08:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0598CC4CEF7;
	Sat, 21 Feb 2026 08:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771663962;
	bh=LVxpq5LSIJt0tx8mSURpoTHZALrogPMRrn+LIjNyQno=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NzhTaumSzl77yt0uRhsXCatJgbXXp8qZkaYbO8lqPNQAJPW4eHHoFRQeN1eN3//NS
	 /0ApTf4179bNiEoojPbuhM3EhTkhsu41x6qQvowOFkRSU8AvQSliW8OOZBEk81W26j
	 RXdLikfGLHewb9Go3BBPS8CjPT32bxZVqP7qbYDgJU5cYGe2vgIeqacYUjWelflctX
	 nRd+6WWblveZ1FKEwfFhEs9nLRy0dZBAMkVO2bsbYhfViXqiqdAICBlJTYeW7Bs0PZ
	 /cwSpyeqAKeHxgepBqvgGmq7/uZSO8L9JISZEV5OgAgDcdQzulc2eFkgUiravYwH6l
	 ZI+xL+VTGXuIQ==
Date: Sat, 21 Feb 2026 10:52:36 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-dev@igalia.com,
	kernel@gpiccoli.net, Andrew Morton <akpm@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] mm/memblock: Add reserve_mem debugfs info
Message-ID: <aZlyVHwUdxg5WZBe@kernel.org>
References: <20260217195816.861684-1-gpiccoli@igalia.com>
 <20260217195816.861684-3-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217195816.861684-3-gpiccoli@igalia.com>
X-Rspamd-Queue-Id: CDEBC40009
X-Stat-Signature: coz4scynhr8axyg7cgriidwer6fwah8k
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771663963-988604
X-HE-Meta: U2FsdGVkX19gJn8Z44pQsbbLslbZiNxa9KLFIzSo/++/QFN0yhqltZBy0EerjZ1nV5S181xvFjZEz5/eATPZL1/V4K1jFCwTGhvx9v9siY8QhkBANSYQi+06hv7+2roim4Aq5TVVZv7xRWNn+PgUY336wByrW4Or6Zl7/Juq4uOBoQqllI+b8nmW9+Zj6OTVY3O8uMkRhwciG/k5/P6hqgGtf31hnIUAhbHqENJEUPdrO3S4pQMjhoF4jnssnGvLicmSxeiFjGZvIvQ70UTCNnDdBgQmmQYqrlA5fJt7X+FdroUZ1/E7yacIvJ08a1Vhw/8mIAmxgrZFICbH6g2c6+k+iUFmxlOwVSChqWkD2g+Reo4VOyBFhuHdgSdenBexIqvVn9HAzTZOvrYM8u97gYZrrRbscX8wpzPb4J4KTXIwPyZNDSfMq4ewDNKWotJwlbXToPLequ4yx5dyTksBAIc1yndjFVHdeLKI+CYublQwV7MsFEpnHGCow8HSNRJt1Cywx8h6JMzPLhMRaVxM3wDk92+zwgUUoYYPzkXc4MVb/m9eAeTALqsYgESjpi8K9iJL2InxW087r8URHYynrwNkkdqWpag3saln5hcF1W6VW/NdmF5ZWYD4EZRd/JqOqwEppHbjLC0+RG8TsS+25uEvJq0XOTwdmRSX9bTntsETgRSfdYjv0eKT6CFtAew63FI3suRHwMxI/NlCprrF5GddZUEwTks6ns74VzITEcE8oJVNRSu3RRqs9WvUg3ycRGOMErXbwarg+RwtimW11sTq/DnXhJbZhamUQIkZK0Ae9T5lX2MGcZ5dPwZWEaRdVg/RvDfOHN0d36D/p6UD7fTKZj0d/xrz2djaR4W6tJ9sFG/pai8Qp8UGypmlpg0ZFrBoh2/UKZbtT+h133daJkfVLtlw5xJXD7fbvQl1CWhxUjLY1P7y3k86KXarBmcD6abkbcDCjlM0DF4DJqn
 dmTOojbL
 XUsTc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 04:45:07PM -0300, Guilherme G. Piccoli wrote:
> When using the "reserve_mem" parameter, users aim at having an
> area that (hopefully) persists across boots, so pstore infrastructure
> (like ramoops module) can make use of that to save oops/ftrace logs,
> for example.
> 
> There is no easy way to determine if this kernel parameter is properly
> set though; the kernel doesn't show information about this memory in
> memblock debugfs, neither in /proc/iomem (like unused memory "set" using
> "mem=") nor in the kernel log (like the "crashkernel" parameter does).
> 
> Add here a new file under memblock debugfs showing properly set memory
> reservations, with name, address and size as passed to "reserve_mem".
> 
> Notice this addition makes the memblock folder *always available* under
> debugfs, regardless of ARCH_KEEP_MEMBLOCK and even if there is no
> "reserve_mem=" setting in the command-line.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> ---
>  mm/memblock.c | 37 +++++++++++++++++++++++++++++++++++--
>  1 file changed, 35 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 2d2646f7a120..58439de0a59b 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -18,6 +18,10 @@
>  #include <linux/memblock.h>
>  #include <linux/mutex.h>
>  
> +#ifdef CONFIG_DEBUG_FS
> +#include <linux/string_helpers.h>
> +#endif

No need to ifdef this, a small additional header is not a big deal and it's
anyway included in seq_file.h.

> +
>  #ifdef CONFIG_KEXEC_HANDOVER
>  #include <linux/libfdt.h>
>  #include <linux/kexec_handover.h>
> @@ -2711,7 +2715,7 @@ static int __init reserve_mem(char *p)
>  }
>  __setup("reserve_mem=", reserve_mem);
>  
> -#if defined(CONFIG_DEBUG_FS) && defined(CONFIG_ARCH_KEEP_MEMBLOCK)
> +#ifdef CONFIG_DEBUG_FS
>  static const char * const flagname[] = {

Flag names only needed when ARCH_KEEP_MEMBLOCK is set ... 
>  	[ilog2(MEMBLOCK_HOTPLUG)] = "HOTPLUG",
>  	[ilog2(MEMBLOCK_MIRROR)] = "MIRROR",
> @@ -2722,7 +2726,8 @@ static const char * const flagname[] = {
>  	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
>  };
>  
> -static int memblock_debug_show(struct seq_file *m, void *private)
> +#ifdef CONFIG_ARCH_KEEP_MEMBLOCK

... so this ifdef should go before the flagname declaration.

> +static void memblock_debugfs_files(struct seq_file *m)
>  {
>  	struct memblock_type *type = m->private;
>  	struct memblock_region *reg;
> @@ -2754,6 +2759,30 @@ static int memblock_debug_show(struct seq_file *m, void *private)
>  			seq_printf(m, "%s\n", "NONE");
>  		}
>  	}
> +}
> +#else
> +static void memblock_debugfs_files(struct seq_file *m) {}
> +#endif /* CONFIG_ARCH_KEEP_MEMBLOCK */
> +
> +static int memblock_debug_show(struct seq_file *m, void *private)
> +{
> +	if (m->private == &reserved_mem_table[0]) {
> +		struct reserve_mem_table *map;
> +		char txtsz[16];
> +
> +		for (int i = 0; i < reserved_mem_count; i++) {
> +			map = &reserved_mem_table[i];
> +			if (!map->size)
> +				continue;
> +
> +			memset(txtsz, 0, 16);
> +			string_get_size((u64)(map->size), 1, STRING_UNITS_2, txtsz, 16);

phys_addr_t should be casted automatically to u64 IMO.
And please, no magic numbers.

> +			seq_printf(m, "%s\t\t%pa\t(%s)\n",
> +				map->name, &map->start, txtsz);

Let's not expose the physical address, name and size should be enough to
see which reserve_mem allocations succeeded.

> +		}

You can define "reserve_mem" attribute separately, and leave the existing
memblock_debug_show() as it was.

> +	} else
> +		memblock_debugfs_files(m);
> +
>  	return 0;
>  }
>  DEFINE_SHOW_ATTRIBUTE(memblock_debug);
> @@ -2762,6 +2791,9 @@ static int __init memblock_init_debugfs(void)
>  {
>  	struct dentry *root = debugfs_create_dir("memblock", NULL);

No need to create memblock directory in debugfs if there's nothing to show.
Could be something like

	if (i!(IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK) || reserved_mem_count))
		return;

	root = debugfs_create_dir("memblock", NULL);
  
> +	debugfs_create_file("reserve_mem_param", 0444, root,
> +			    &reserved_mem_table[0], &memblock_debug_fops);
> +#ifdef CONFIG_ARCH_KEEP_MEMBLOCK
>  	debugfs_create_file("memory", 0444, root,
>  			    &memblock.memory, &memblock_debug_fops);
>  	debugfs_create_file("reserved", 0444, root,
> @@ -2771,6 +2803,7 @@ static int __init memblock_init_debugfs(void)
>  			    &memblock_debug_fops);
>  #endif
>  
> +#endif /* CONFIG_ARCH_KEEP_MEMBLOCK */
>  	return 0;
>  }
>  __initcall(memblock_init_debugfs);
> -- 
> 2.50.1
> 
> 

-- 
Sincerely yours,
Mike.

