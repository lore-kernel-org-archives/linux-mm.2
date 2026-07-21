Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A355DC4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 19:20:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D2C26B007B; Tue, 21 Jul 2026 15:20:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AB436B008A; Tue, 21 Jul 2026 15:20:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 299A26B008C; Tue, 21 Jul 2026 15:20:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E708D6B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 15:20:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6AD20A083F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 19:20:10 +0000 (UTC)
X-FDA: 85013749380.19.045BD07
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id A28DA20004
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 19:20:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SYK1MxMD;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784661608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fbtv0vw1LlTZUCiZD8t3HdgT+DZEZ+c4X5oV0q2qGp0=;
	b=15YNu4VPZHWKRCDNpZNBHCMH0WPUuPMyQUj7yJphBw3q/OscjMH4JEjACOIxSq4U5x3qJ/
	LLIW9U0HUqFDYvdLNZKshD9lHCNBOBQ+ZT1/IDl46MInSt4d7bduBiT7vkFIpnT9spDw25
	pex5asIXsilxAYxdSPqy4HQFA/j2fvs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SYK1MxMD;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784661608;
	b=cXdiCUaBNnTQOfDYuqUJnuUzM9fEnZFKEGWs292xSTeo5l4/hucAemW9bC8KdG4YdZ4A5l
	1c/ty9K2omZqgy1BoIzdI4YkZ5Xa5MAOmSx3y76/+jE9E5dqKLwYHGdYQAOzPoielkz2Ao
	Q6BJF3fUaQwuyylm/Q/M+RN7+dvOTIc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 20E7C404E1;
	Tue, 21 Jul 2026 19:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36DF1F00A3A;
	Tue, 21 Jul 2026 19:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784661607;
	bh=fbtv0vw1LlTZUCiZD8t3HdgT+DZEZ+c4X5oV0q2qGp0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SYK1MxMDQ4Ju4xurEh0nrhuHZHxv4A0QZ1Bge1pFLQOi9VrJbPQfw3EqoddRVH9IO
	 6qInYd0gsSaFvE9ucIK/mVz1sGl/97DH+imBNDenFeN7hpzhC120OKnvcYr2t1IyWa
	 nIzrT1Ud8MvuGarRrIfFx7677btQhuLafF+A+z7w8x55g4FkmQfrt42NQW/Slyu49P
	 22gtk6y36rTnkTapLdn/0cWqAdHD5ECZom4JJCrIS+zi/+YqPRDqBrpBegikW7jyIC
	 FT9IrELkmXzXY+JvPJ4YvLcfCJYg1V3xYawMu/U2m+vpNvLzDUeyZPcZ/BL7uX0fBH
	 YRPirVPljhpIA==
Message-ID: <5a43053d-8d08-4fda-82e3-bda10ca79c92@kernel.org>
Date: Tue, 21 Jul 2026 21:19:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: Add unmap_mapping_file() helper
To: =?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
 Bjorn Helgaas <bhelgaas@google.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>,
 Manivannan Sadhasivam <mani@kernel.org>,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Dan Williams <djbw@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Simona Vetter <simona.vetter@ffwll.ch>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 linux-pci@vger.kernel.org, linux-mm@kvack.org, driver-core@lists.linux.dev,
 Christian Brauner <brauner@kernel.org>
References: <20260721185252.1670958-1-kwilczynski@kernel.org>
 <20260721185252.1670958-2-kwilczynski@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260721185252.1670958-2-kwilczynski@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A28DA20004
X-Rspamd-Server: rspam01
X-Stat-Signature: pe5uixxf33kwue7a3rca1ax6rssk58i1
X-HE-Tag: 1784661608-988194
X-HE-Meta: U2FsdGVkX19Ror1W+ARi1sNINlNjO4iqdPjpcE4aNnh2tuSHRNWuKp1MCzkiRbIdWe1E/UaQkahElhUI9Cx5AsLXYZR6sKdNKTSnZq7Fc7gqVNYWi4Zcb4qndYKuHxcMr1m5sMu7r56OHZSzBg+2tktG3PDiUgsfQShowhfhPAnu3DEQHxw8EI2pCM1qBwZVNGE/vw5xftt4hBSIKHzLDqP/H+sgPgVOOaHu6Zx1ST0w6nDB5nl9UOPYT/wx0A43RD3rU8HmyoiVDXpY1JKKb6FBeFhiRGMtEwykoGCMytSbThUtxrvRmvq8AvLKvblV/SiBNyB+Odp+tbsOvXFLzBR5PG1EXsQTUeIQF8wqtvU4RUcE2VRaOOsUJqWVoON+8fe/dTSWX/vk8r6mHUxO7bAK1ZWj+Zufic/4iHC1M0FIZy3a97g6tCA+SDEw3tqgrzXNpimP0C+xj6Jlkw7eZvdBqBhzHvaOYH/q7GgPpfP3M1m+sh4S5wNRSvfAwTrpsAeIZdX1FO49AKf6ck/e5pH92s2+J9/TC7eOEbi6KupLANGxC6IiT59/L9n6aOd+9WeBsOPBxi5vIqEU71PYkkGEW+Q4qd3DeIUdvFdKKRXs0/uL+M654WpMsKAQteDtDL51SBKtwv5XUJ7x67Q1TP4FQLzbMfWpuxdTHYyHdOLxIYcfkYk4UMtaAubDAgQNqZfzqdoVebI6xHNMBpQRM/bme+V3zBkM2+jWfR16cTi3nKezy5abIz6T1+UKVw3+W24FPQ3PNKiADlDUC3iibrKQ29KW1AmtUS3tOzWKbOQiabQu8yIPXny/2rNuSCJmUd1daIgk5Nr55aytG31VC8iNGIJKDEGvWvPXfkv6T/uO8qWvYznfCC9hLgxQ6m28AOxgP4DZG9/pG83zdWjH3nmMoTMpCNNCsWTFTIDdiCMo4vNafBnggypr/koX37sbeCNJ6CXEF8roDo6UHcu
 wu/Xs6XC
 DffBo0yKXYcszqur80Wasv42+K31n/xrR8EYM9w4eEeScds3fpRR2tPHoDPnjQ/FHElU+jIewafKmRvhMIFjvN9LNiDfXqtzzcYe0fgmdXu/2m4NjccwpHmKzOXwanqJifqnRkBiDssAiZGeUG+5GruxxFtY64CQ5eqRX5E1MCQy9KsU+IwU57SNhgvh7nER55EZFg1TYDrKEvRv0mrrHQ6ODc0R+WuBC34egDULXbYYgtG/a/yY6KkBY0YhzOP2X/VFNemJRJ8sqzGqL9alx2ZCiRtwLWLPD5OlTVpAYOH4Ww5szwNyZSurteHXHjntQfaoXfAaQWrrjRVRsxxYUCBTknc2cvHc7nUXD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/21/26 20:52, Krzysztof Wilczyński wrote:
> Currently, unmap_mapping_pages() and unmap_mapping_range() unmap
> a page offset window of an address_space, and teardown paths such
> as kernfs_drain_open_files() rely on them to remove the mappings
> of a file that is going away.
> 
> Files with f_mapping swapped to a shared address space at open time,
> such as PCI resource files using iomem_get_mapping(), have their
> VMAs attached to the shared mapping instead of the file's own inode
> mapping, so a teardown that unmaps the inode's address space cannot
> reach them, and they stay live after the file is removed.  As such,
> the only correct discriminator for these VMAs is the originating
> struct file recorded in vma->vm_file.
> 
> Add unmap_mapping_file(), which walks the VMA interval tree of the
> file's f_mapping under i_mmap_lock_read() and zaps every VMA with
> vm_file set to the given file, using the same per-VMA zap teardown
> as unmap_mapping_pages().
> 
> Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
> ---
>  include/linux/mm.h |  2 ++
>  mm/memory.c        | 26 ++++++++++++++++++++++++++
>  2 files changed, 28 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 485df9c2dbdd..e882a03eaddd 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3183,6 +3183,7 @@ extern int fixup_user_fault(struct mm_struct *mm,
>  			    bool *unlocked);
>  void unmap_mapping_pages(struct address_space *mapping,
>  		pgoff_t start, pgoff_t nr, bool even_cows);
> +void unmap_mapping_file(struct file *file);
>  void unmap_mapping_range(struct address_space *mapping,
>  		loff_t const holebegin, loff_t const holelen, int even_cows);
>  #else
> @@ -3203,6 +3204,7 @@ static inline int fixup_user_fault(struct mm_struct *mm, unsigned long address,
>  }
>  static inline void unmap_mapping_pages(struct address_space *mapping,
>  		pgoff_t start, pgoff_t nr, bool even_cows) { }
> +static inline void unmap_mapping_file(struct file *file) { }
>  static inline void unmap_mapping_range(struct address_space *mapping,
>  		loff_t const holebegin, loff_t const holelen, int even_cows) { }
>  #endif
> diff --git a/mm/memory.c b/mm/memory.c
> index ff338c2abe92..f9cfb88ac4f7 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4423,6 +4423,32 @@ void unmap_mapping_pages(struct address_space *mapping, pgoff_t start,
>  }
>  EXPORT_SYMBOL_GPL(unmap_mapping_pages);
>  
> +/**
> + * unmap_mapping_file() - Unmap all mmaps of an open file.
> + * @file: The file to unmap.

We are unmapping pages/folios, not really mmaps.

"Unmap folio from all mmaps of a file." ?

> + *
> + * Unmap every VMA with vm_file set to @file, regardless of the address

Again, we are not unmapping VMAs, we are unmapping pages/folios within all VMAs
that map the file.

> + * space it is attached to.  This also covers files with f_mapping
> + * swapped to a different address space at open time, since such VMAs
> + * cannot be found through the file's own inode mapping.

God this is confusing :)

Sorry for the stupid question, but why can't we call

	unmap_mapping_range(file->f_mapping, 0, 0, 1);


What is a bit annoying is that you now do in the caller:

	if (of->file->f_mapping != inode->i_mapping)
		unmap_mapping_file(of->file);
	else
		unmap_mapping_range(inode->i_mapping, 0, 0, 1);

Shouldn't we just have one function that takes care of that internally ... so
it's harder to get wrong?

-- 
Cheers,

David

