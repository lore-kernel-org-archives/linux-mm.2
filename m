Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF823C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 10:03:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CED226B0092; Tue, 15 Sep 2026 06:03:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9E1D6B0093; Tue, 15 Sep 2026 06:03:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8CFA6B0096; Tue, 15 Sep 2026 06:03:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A4B36B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:03:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F28CAC03A4
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:03:21 +0000 (UTC)
X-FDA: 85215559002.03.2DCF9BF
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2F0BA160013
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:03:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SOtA32XK;
	spf=pass (imf08.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789466600;
	b=GWfNrrn67b1GdC4N4BmHX8+xpzt7Ii7blG6MWF+m7+clVBLD4uwLKgYxKj6LiNZltSDnw5
	b2OK3StCyg728S8oQ6u27eUP3Za9ZsnIFgn32OH7fLVwUk4S2vHalzYGnHE7HXrSO284jL
	cWAdy66RH/gvoW7Jw40HYV+eYuyD21U=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SOtA32XK;
	spf=pass (imf08.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789466600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=54+ke4vRrY6qnnzpuHgV9MO2LfJ20YKm3b1bTQuL+qE=;
	b=f+ciVhV8du27tpWd6eJMXsEakMRukVhn+5Y0WKc4Yi9C/28mEDUTIVHruhcx9Uirt4rKcU
	97OB/YAJDOuvLfnkilgL5NVj7rD1T/ISUtuXnVGc1yB4ZkRfG8+spt6Fn92EYWM4aOhI2v
	OOjYs+z3iKthxmrPIyDs6m/bqi0b0Qg=
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1cebad4aeso2683475a12.2
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789466599; x=1790071399; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=54+ke4vRrY6qnnzpuHgV9MO2LfJ20YKm3b1bTQuL+qE=;
        b=SOtA32XK2p/sKyK+nqBKhNMmOKfTW2lX6zAn7OSjcMzpf5wzYrOKyRDDzY1k2Psb+K
         C5qyXADkoR5RWWGBYFbpBS9kMRQxR6nIaikGL736XaAc0nlUN/J+nKrOF0ITruh5bqGo
         8bIVY8pQIfYe3EUW9Ktz6ePHPlu4lAAeYeGJ1PWbIaCYOHNKn25PprHnsmE00nUwNEtZ
         9ssuywm9iMPjVFMzgG5wjG1ivrgPoj/L6bv7kK+Z6+61euDLLQB0H3cQv2/3Vl1s7+IH
         aKQ+PNNnRHwwG+6wTtR5CcDvcJ3N3GBMkvwScoKbiHvVNcI0yx8AAytEDzrCkdY5hR8I
         3uAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789466599; x=1790071399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=54+ke4vRrY6qnnzpuHgV9MO2LfJ20YKm3b1bTQuL+qE=;
        b=RKWkHoZ2MPGM3pXox9CKenhnNDtb1Y2n2Br38IRU4TISpnh7p1AEE381FFkaM6aLbc
         0lVjiLPAFgqX7nANJhUhVK4WBavEvi8mhFlzEOoSoO//z6XjZLj3pciwfXc5IwAgEnqM
         ZaxgiHirqvOxa+IMnHOBc+VufHWL075TkKiui0m3RY0A8ksQhAnohBea4qZwXsm73Hh6
         7G/ROsJ3nKvDKlH0hmvr4dvYP3u57XyX7YrdGcB6HTnbpN1kJfr/LxLmhlMM2zZNptqH
         +Wl1EhJEQZZZm8YTNW01xQoqsGz0P5gjxXlvtnSt4GVzWJjeD1eu8IwtKdwK956S6XxW
         SwUQ==
X-Forwarded-Encrypted: i=1; AKwUvBzrZolw/3NavSK17tumNLtUOBgWFA50x944Ns87HPO+gwLdUNcSyBxst9gP0GiAItkn9RQHQARxig==@kvack.org
X-Gm-Message-State: AFuF++kZ3FlD5Cp1tvYMFW+SutqhcbjJQYeE19OpclcuH0gf3NmBT/3o
	OyWccGQMwchgtGYX9rX4UPBeyszH/C2xiJ21cNeEurEWHC7lchn/OmKB
X-Gm-Gg: AYBFou0Fj4/nzEDUE16vAXmy7VT1/8QD9LKAZ/zV4LnFwPpMKwUAEJpDqYLcZLoPK+0
	rJRvZ5rjgUCWDNvJmjMQ7B03Vw1x3AzEaND26W2awUJZBgsOzoGurB+MBdqsLdPnXCPMCxtDNST
	4WXz1yd5eS3ace4M0AR0aq3JZwW78BYXDVyNGPYkWQPkxwBnN7eg4d2RHAOtWWXkwM2/P+9gOTG
	gkNNMN7rTQFkNhO2Ct7KOVUu8ImPjkHg0rUvKkDPvXB0MJDlIfRPxOSIevZwLkC3v28+lktL4yb
	OiHxx4R4n9XyQY/cNviSTNoZTta+eMQ/mvjseSMqGs4puGVtcxyyyX4BP+tsTvtIjREgyS6s+cG
	yoyokjwX4Jx4mEV9sR2b4Ay8s5CxWEjOjZB78zrImx3hOIrlVzt6mZbLIVVIeiRNsk9hinsWL7F
	x9vF7qb/n0q4lNd1PKcRIA46/hPsItTZjwU7vGNjLAamYOIxwDzOR/G/HTsgg9cF8L3mjsFw==
X-Received: by 2002:a17:90b:4a0f:b0:381:6c5:3f63 with SMTP id 98e67ed59e1d1-39debf7613bmr11610177a91.6.1789466598732;
        Tue, 15 Sep 2026 03:03:18 -0700 (PDT)
Received: from gmail.com ([185.220.238.35])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bbeb053a5sm18120652eec.27.2026.09.15.03.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 03:03:18 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: Kunwu Chan <kunwu.chan@gmail.com>,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	Kunwu Chan <chentao@kylinos.cn>
Subject: Re: [PATCH v2 01/12] mm: xswap support for zswap
Date: Tue, 15 Sep 2026 18:03:06 +0800
Message-ID: <20260915100308.1599989-1-kunwu.chan@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260913075014.1732524-2-hebaoquan@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2F0BA160013
X-Stat-Signature: oxzu4mc89de8375c7js6c4gka4fp969x
X-Rspam-User: 
X-HE-Tag: 1789466600-473369
X-HE-Meta: U2FsdGVkX18xSPk69V6oitUILBfW15vtCXQ0nNK9q+eU6852nCaffPdQv5slMONMn1QCJtnxwTVBqOM6klWCxO99eLzpn7ImwxU6ra3EN0xtziMifK+OMESBPL9lUIPVOzQhbc5tFsGBBSo5oMFAtWm9LxjGRa4ZVq78k0SWarDkP8NyMANpLtZ5Gdd4b4MwOG6J+9E1DWrG+YD3w3SHufwDGfYaBOLMRnW1FzCKjk9MZwYRPov5n8aUmFzjV9PywWo7IE04qpRtfZOgXI6UxmHWnLiOjecTcd8skuW6BD7nziChJKLEIe0ar8Fn5Dw8dgXydDWXnx0FOcW6BgCYLWF9mkT9bNFXFEDlCBE+UM5Zji1nfr2MkUHGbxncHTskAx81SqPrtOO1ospay+d3d3E8u/KRFtLS542xQ4hbfuHWxVXgSFhWlD3iNY1KVuOWtd7DWvEZNyAkIjEuMNXo8QB2GVO0nvLEW8q5A0f8Fhty0QEU269RGaJp5ZJpHrw1MKDCJjChmh7o3YorMe5SUMBChg2WWUOhoq7dwu9mdx8aVykC/CCzOzcGHtWK0eILVHvzRTUjIq5OO4ZF+eLKi11NQbld+rJnc6sKYj/O12ySF0DYvPzav42BgRASL9IRJl1uaGq53EQW5CqZpDQmEqhfJr501ImPIr4J/sIl0+vFnvci9x7Aqu+hG0xEJb4quFIV6HJcmXFg3rRRYcoFuPsmbv5a0ODEBEO8NpH5o7/ZMuPeD0nACjOgtLGMywXXmfFCGgcBhwOe4kD/gqKl7EN6SZ5pDY/S98HlrIsRSPgnm3O95/2+0AISrglbvp6Rg36RXcvSHVGp3Sn1abiFJM1w2HsuGBGXxJWlMESdNxSJG6cxF7QmQ19hXTlqAYp+nKoybsp0ZxE0nFbbvuKFT1Wx3pvCs/pvAnTRFFVPLNyTkiCfR2H2hyESnayQZScqhOXZZRDBDvDWwJWvLXc
 JQwMk4hV
 CBz70fgdvmvqrj8M2x6tVNwHyii4aWFEPTFlYuVfGOft6t799B2bpl3l8RdMA0sCVz6vxmj1Af2lol1tzXl0xfYRLww1EGHtS8lqnW1Na1PocjZWvAgSEr1jEWH4Wo43rt5R8Zm6djLLQcaPLADXedKs9Tv46OEGZUpr9YLhf/uFL4VV7pputC8uK2Y6S++lwQffPVHwB9QcRwlohwVbwZiJbwS1guPRsGIO9HEAgL0+bmtrB9WJtgZtNZ7v6FtHkG7sJa3lrlVvajvZfhybGWHp0IWznXaXa6iAnLb48hrgHnxf1dqyOTdXBHPd/xy8/ZHbhS8Tiu/YPNuftNoFiuPr1DhvnvnfvzaRJufyIDiwsU5P94ty87bvG/Tg/zQINuj98TShdNIIqenSO/pkjP/D+4asmFmyXtoiJXlkN7W4zNUVBVVD08rWtCjVVkwY1zHSe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 13 Sep 2026 15:50:03 +0800 Baoquan He <hebaoquan@kylinos.cn> wrote:

> From: Chris Li <chrisl@kernel.org>
> 
> Introduce extendable swap device support - xswap.
> 
> An xswap device has no backing storage and no swap data section, so
> it wastes no disk space. Creation is via a sysfs interface added in a
> later patch.
> 
> Zswap writeback is gated on whether a real (non-xswap) swap device is
> active. nr_real_swapfiles counts such devices and is maintained at
> swapon/swapoff only, so the gate reflects "a device exists to write
> back to" rather than "a device currently has free slots". This keeps
> writeback working even when the real swap device is full, and avoids
> a double decrement when a full device is swapped off.
> 
> Co-developed-by: Baoquan He <hebaoquan@kylinos.cn>
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> Signed-off-by: Chris Li <chrisl@kernel.org>
> ---
>  include/linux/swap.h |  2 ++
>  mm/page_io.c         | 16 ++++++++++++++++
>  mm/swap_state.c      |  7 +++++++
>  mm/swapfile.c        | 38 +++++++++++++++++++++++++++++++++++---
>  mm/zswap.c           |  7 ++++++-
>  5 files changed, 66 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 5658a1634b85..787fe463dcbb 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -207,6 +207,7 @@ enum {
>  	SWP_STABLE_WRITES = (1 << 11),	/* no overwrite PG_writeback pages */
>  	SWP_SYNCHRONOUS_IO = (1 << 12),	/* synchronous IO is efficient */
>  	SWP_HIBERNATION = (1 << 13),	/* pinned for hibernation */
> +	SWP_XSWAP	= (1 << 14),	/* extendable swap device */
>  					/* add others here before... */
>  };
>  
> @@ -356,6 +357,7 @@ void free_folio_and_swap_cache(struct folio *folio);
>  void free_pages_and_swap_cache(struct encoded_page **, int);
>  /* linux/mm/swapfile.c */
>  extern atomic_long_t nr_swap_pages;
> +extern atomic_t nr_real_swapfiles;
>  extern long total_swap_pages;
>  extern atomic_t nr_rotate_swap;
>  
> diff --git a/mm/page_io.c b/mm/page_io.c
> index 88962571cb93..5483c943e3e3 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -248,6 +248,17 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
>  	}
>  	rcu_read_unlock();
>  
> +	/*
> +	 * ctx->sis is set by swap_add_folio() which is called from
> +	 * __swap_writepage() below.  Since we must avoid the writepage
> +	 * path for xswap devices, use the swap_info from the folio's
> +	 * swap entry directly instead of going through ctx.
> +	 */
> +	if (unlikely(__swap_entry_to_info(folio->swap)->flags & SWP_XSWAP)) {
> +		folio_mark_dirty(folio);
> +		return AOP_WRITEPAGE_ACTIVATE;
> +	}
> +
>  	__swap_writepage(ctx, folio);
>  	return 0;
>  out_unlock:
> @@ -480,6 +491,11 @@ void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
>  	if (zswap_load(folio) != -ENOENT)
>  		goto finish;
>  
> +	if (unlikely(sis->flags & SWP_XSWAP)) {
> +		folio_unlock(folio);
> +		goto finish;
> +	}
> +
>  	/* We have to read from slower devices. Increase zswap protection. */
>  	zswap_folio_swapin(folio);
>  	swap_add_folio(ctx, folio, READ);
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index b76eb3d876fd..2eedb7a3d7bb 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -830,6 +830,13 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
>  	struct blk_plug plug;
>  	swp_entry_t ra_entry;
>  
> +	/*
> +	 * The entry may have been freed by another task. Avoid swap_info_get()
> +	 * which will print error message if the race happens.
> +	 */
> +	if (si->flags & SWP_XSWAP)
> +		goto skip;
> +
>  	mask = swapin_nr_pages(offset) - 1;
>  	if (!mask)
>  		goto skip;
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 53bf01d5f7f1..193b08a54908 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -66,6 +66,7 @@ static void move_cluster(struct swap_info_struct *si,
>  static DEFINE_SPINLOCK(swap_lock);
>  static unsigned int nr_swapfiles;
>  atomic_long_t nr_swap_pages;
> +atomic_t nr_real_swapfiles;
>  /*
>   * Some modules use swappable objects and may try to swap them out under
>   * memory pressure (via the shrinker). Before doing so, they may wish to
> @@ -1208,6 +1209,9 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
>  		 */
>  		lockdep_assert_held(&si->lock);
>  		si->flags &= ~SWP_WRITEOK;
> +		/* Count active devices, not merely those on the avail list. */
> +		if (!(si->flags & SWP_XSWAP))
> +			atomic_sub(1, &nr_real_swapfiles);
>  		atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
>  	} else {
>  		/*
> @@ -1265,6 +1269,8 @@ static void add_to_avail_list(struct swap_info_struct *si, bool swapon)
>  	}
>  
>  	plist_add(&si->avail_list, &swap_avail_head);
> +	if (swapon && !(si->flags & SWP_XSWAP))
> +		atomic_add(1, &nr_real_swapfiles);
>  
>  skip:
>  	spin_unlock(&swap_avail_lock);
> @@ -2959,6 +2965,19 @@ static int setup_swap_extents(struct swap_info_struct *sis,
>  	struct inode *inode = mapping->host;
>  	int ret;
>  
> +	if (sis->flags & SWP_XSWAP) {
> +		*span = 0;
> +		/*
> +		 * xswap devices have no backing block device and
> +		 * physical writeout is skipped in swap_writeout(),
> +		 * but sis->ops must still be set so that callers
> +		 * like shrink_folio_list() can safely dereference
> +		 * ops->flags.
> +		 */
> +		sis->ops = &swap_bdev_ops;
> +		return 0;
> +	}
> +
>  	ret = sio_pool_init();
>  	if (ret)
>  		return ret;
> @@ -3167,7 +3186,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>  
>  	destroy_swap_extents(p, p->swap_file);
>  
> -	if (!(p->flags & SWP_SOLIDSTATE))
> +	if (!(p->flags & SWP_XSWAP) &&
> +	    !(p->flags & SWP_SOLIDSTATE))
>  		atomic_dec(&nr_rotate_swap);
>  
>  	mutex_lock(&swapon_mutex);
> @@ -3277,6 +3297,19 @@ static void swap_stop(struct seq_file *swap, void *v)
>  	mutex_unlock(&swapon_mutex);
>  }
>  
> +static const char *swap_type_str(struct swap_info_struct *si)
> +{
> +	struct file *file = si->swap_file;
> +
> +	if (si->flags & SWP_XSWAP)
> +		return "xswap\t";
> +
> +	if (S_ISBLK(file_inode(file)->i_mode))
> +		return "partition";
> +
> +	return "file\t";
> +}
> +
>  static int swap_show(struct seq_file *swap, void *v)
>  {
>  	struct swap_info_struct *si = v;
> @@ -3296,8 +3329,7 @@ static int swap_show(struct seq_file *swap, void *v)
>  	len = seq_file_path(swap, file, " \t\n\\");
>  	seq_printf(swap, "%*s%s\t%lu\t%s%lu\t%s%d\n",
>  			len < 40 ? 40 - len : 1, " ",
> -			S_ISBLK(file_inode(file)->i_mode) ?
> -				"partition" : "file\t",
> +			swap_type_str(si),
>  			bytes, bytes < 10000000 ? "\t" : "",
>  			inuse, inuse < 10000000 ? "\t" : "",
>  			si->prio);
> diff --git a/mm/zswap.c b/mm/zswap.c
> index b9948d4657d2..064970a4393f 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1000,6 +1000,11 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
>  	if (!si)
>  		return -ENOENT;
>  
> +	if (si->flags & SWP_XSWAP) {
> +		put_swap_device(si);
> +		return -EINVAL;
> +	}
> +
>  	mpol = get_task_policy(current);
>  	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
>  				       NO_INTERLEAVE_INDEX);
> @@ -1545,7 +1550,7 @@ bool zswap_store(struct folio *folio)
>  	zswap_pool_put(pool);
>  put_objcg:
>  	obj_cgroup_put(objcg);
> -	if (!ret && zswap_pool_reached_full)
> +	if (!ret && zswap_pool_reached_full && atomic_read(&nr_real_swapfiles))
>  		queue_work(shrink_wq, &zswap_shrink_work);
>  check_old:
>  	/*
> -- 
> 2.54.0
> 
> 

The SWP_XSWAP flag and nr_real_swapfiles accounting look correct. The writeback guard 
in page_io.c (both swap_writeout and swap_read_folio paths) properly short-circuits 
xswap devices, and the zswap writeback gating on nr_real_swapfiles ensures writeback 
only fires when a real swap device is active. 

No issues found.

Reviewed-by: Kunwu Chan <chentao@kylinos.cn>

Thanks,
Kunwu


