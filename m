Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17E2EC79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 14:48:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F27266B009D; Mon,  7 Sep 2026 10:48:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED79D6B009E; Mon,  7 Sep 2026 10:48:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DED446B009F; Mon,  7 Sep 2026 10:48:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD3A86B009D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:48:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 463A01401AA
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:48:14 +0000 (UTC)
X-FDA: 85187246508.05.F9A91CB
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf27.hostedemail.com (Postfix) with ESMTP id 749EB40002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:48:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=LEdbSJ1v;
	spf=pass (imf27.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788792492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ICYiSV43kYcKi3w/xRQ/Uas9brIt0oFdfmwI0JjU7/I=;
	b=PWh2FjUGrN4TJNgoZSaMKL6bMLCiuxSJ0jVaySBI6x3Sas4u6N7clmyBfs7k+BFeBtBMw1
	7yrtHg7t7GNg0/OQblWcuiNmeNtN2paiP1+bNQNuFs/LUyZaHDCU5e0WYHU0MJDj5MiuDo
	WjaO9CCC09IacsNcC3gKplEBufQlGQU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788792492;
	b=b6lLO/sxJ4pX1A+sfijezE61+vRHrjsZrMnCtsNBg6rNOoPJOPhJJqQv2AAeOOkBXgAPXh
	0BfKcmWOdZh9H07yqR/fozQH5YIBr6YX+Cyy+V5NNo9A+YUkDPTLUaX7Yu6y2kuCM8ni9y
	uSBp4DYgVzkllgfd98mv/dpX5a7Cy/g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=LEdbSJ1v;
	spf=pass (imf27.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ICYiSV43kYcKi3w/xRQ/Uas9brIt0oFdfmwI0JjU7/I=; b=LEdbSJ1vptFInpVZGgZaULk+vd
	DQo37X+q6ZRORyORTGdTprPmHsz6SWYLBydsnmvcR/ypYchTuPBNEz5dEaaQ/IlL9wG3KF84rhmLc
	tYOJUtnytxIrIUK91YfkX+U6C5DRjmsM/tF8IFi+i3g11jArKPgR/nAHRe9gSguz3O3uP4ltR70Hw
	p5dNMZ6wBrYxBXHx9Mt+/rGGGk6OOAc6v7KTPJJef7+pNWMRkHPIUiQsJx+UD6l0EZz191tpJvWU0
	m7txRONOs2qSVH/PVsXEBeWVTCCewenoKvSngeUrN2XTnxwZLGCfA5b+3kqhCVoIXvhLnPGWnYAJP
	+2NnDqtQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x3adP-001a5u-0c;
	Mon, 07 Sep 2026 14:47:47 +0000
Date: Mon, 7 Sep 2026 07:47:41 -0700
From: Breno Leitao <leitao@debian.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-efi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
	kernel-team@meta.com
Subject: Re: [PATCH v3 2/5] mm/memory-failure: libstub: install the
 poisoned-memory EFI table
Message-ID: <ap7OBwOs8BKGUJh8@gmail.com>
References: <20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org>
 <20260826-hwpoison-kho-v3-2-6f79c4b605bc@debian.org>
 <apGSy78NoCov0MWr@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apGSy78NoCov0MWr@thinkstation>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 749EB40002
X-Stat-Signature: phpgmud9ai467an9uduxmra8u8xub3ab
X-HE-Tag: 1788792492-836409
X-HE-Meta: U2FsdGVkX1/6vaaaR2GhsjPGyKlhuXjy7sS6g8NgiFRDKM9iQ933hch3onv9v1uRj1E3JdurLzzjBJCn4GfQtxaTu4L97bszgXL3c9E8rbmNnta20ulx15GZKisZQDOKqSpNH2KL7HTFF18H7yLk1vUmVY32FuaDM430NjtCSw4xbWv8Yuz709eUZckFYs+7MUuFxw+D17IVuoG5RY4LcJnTsW+EK1ntPg8uC5DAvrohKG+zBj2rrJbSK52ew8lHjr3KglitOm3bP027JSUsBwiKBg4kzU0zslMAvnEbM9YUIY+Plm8ru6HQjwapZCRDNG5qubYSunsEOy6cOzoznWpXbl88RlxuMNAT/QO4UL5C/GMeGmgQQ4mC9n7A7bBETHEH/kiOQFue4lDkzIRwSQm9xhcBL7BL1zlv9FIsKguy6OnvsUmPNzAmb1U4YtMd9yCH3Kc9LtLaaNw+1QjxOFRsrwQuEB0FkL/NtcuvByOKTxLY6tYeuC/EYx1vPYEEYFWi9n0o3M7wPmzDkK3znWsnFV6uRTMdrl25oUnAKg66inWlltWxIGhKXD5kXwlRbpyEctn0Du0a49o13BdlqfjeLKlk+m4h+CepBwjaWtouuA97p3C4hfxrrS+Cigst+wr68Cnan0GKO18v91ufzdtux/0zYir2me0Yjcq7UVAA+s/b37/BK4Y6olmv/9CSOGl5N5+KwWWilWjEYVeZiB7DrJGBGKxn9PYrzgn6xL5vbevUC82vfYKIr/bRgw6stSt7TAw1eqUzUQVrpKEMDWmPs2I+M9/3xzyE+asO3OE0srQoIP01b62KlrksXyve6uhbpK0d+wq5c9+5VDoFKLMO3WLB/i3PI9pYH8akNFwOcnzr7YDfsuVWIAPd1O4Ta7E02ZaBJEbYjOTx5RjXC5dogPAucUVSgbghQVaSBlP8awZoYrdZMAEWKu8pFmtrfq/5JDQesg8Us7KRHCe
 FofzDDGq
 voLdgKmBe4tLRUdFmTahBiG7b8UWVthtJcYZEDP6+OvC9fcdetG8niS5bZABaj90HNb3SV+NxnkPpTT/NhJGAJxeJlWfzL3U2GMIYA0I4tsR5cmAuZdJ/1OYMJQGdrfVwGq5lRNkN9SzWX3aX/muzANwQGFZ+lpHiigC6X1nVvpa319kf+OCuMXoWnURsG0ZiG1Ia2XwpCIdOf6asdi/oTcuEc6zaeTfM91LDi9rR5g3H88OZ+12kfALbJpyMU3y1wLujZWPoDkNtZ4aqwJcYI30d0yh0wqW6OQUWrKJEUuOAvn4lvOOBwxSNJqJ2AU6yE0RtwEDUaD10WG8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 02:59:43PM +0100, Kiryl Shutsemau wrote:
> On Wed, Aug 26, 2026 at 05:03:53AM -0700, Breno Leitao wrote:
> > A EFI config table can only be installed while boot services are still
> > up, so the stub has to create it; the running kernel can only flip bits
> > in a table that already exists.
> > 
> > Size the bitmap from the top of usable RAM, which efi_get_ram_top()
> > works out by walking the UEFI memory map, since the stub has no max_pfn.
> > Bit N covers unit N counting from address 0, so the table tracks
> > max_pfn. Memory the firmware hot-adds later sits above it and is not
> > carried across a kexec.
> > 
> > One table has to serve every architecture, so efi_get_ram_top() takes
> > the union of the memory types they turn into RAM: what setup_e820() maps
> > to E820_TYPE_RAM on x86, plus the EFI_ACPI_RECLAIM_MEMORY and
> > EFI_PERSISTENT_MEMORY that is_usable_memory() accepts on arm64. Sizing
> > wide only costs bitmap bytes; sizing narrow silently drops the records
> > for every frame above the top.
> 
> x86 and ARM doesn't seem to agree what RAM is. On x86 it is by ->type
> and on ARM it is by ->attribute (anything WB/WC/WT).
> 
> is_usable_memory() only decides nomap. Everything is_memory() lets in
> lands in memblock.memory, and max_pfn is PFN_DOWN(memblock_end_of_DRAM()),
> so the top of RAM there can be a type that is not on your list.

Thanks. I will just ignore the memory types and get the base and top
based on the memory map descriptors.

Now that I need to get the phys base (from previous patch discussion),
I will need to get the range, doing something like:

	static efi_status_t efi_get_ram_range(u64 *base, u64 *top)
	{
	       struct efi_boot_memmap *map __free(efi_pool) = NULL;
	       u64 ram_base = ULLONG_MAX, ram_top = 0;
	       efi_status_t status;
	       int i, nr_desc;
	
	       status = efi_get_memory_map(&map, false);
	       if (status != EFI_SUCCESS)
	               return status;
	
	       nr_desc = map->map_size / map->desc_size;
	       for (i = 0; i < nr_desc; i++) {
	               efi_memory_desc_t *d;
	
	               d = efi_memdesc_ptr((unsigned long)map->map, map->desc_size, i);
	               ram_base = min(ram_base, d->phys_addr);
	               ram_top = max(ram_top,
	                             d->phys_addr + d->num_pages * EFI_PAGE_SIZE);
	       }
	       if (!ram_top)
	               return EFI_NOT_FOUND;
	
	       *base = round_down(ram_base, EFI_POISON_UNIT_SIZE);
	       *top = round_up(ram_top, EFI_POISON_UNIT_SIZE);

	       return EFI_SUCCESS;
	}

is it what you had in mind?

Thanks,
--breno

