Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 189DE60A2608
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 08:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nmEtFyZi
Received: by kanga.kvack.org (Postfix)
	id 33CCB6B05C6; Thu, 19 Nov 2026 03:26:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EC046B05C7; Thu, 19 Nov 2026 03:26:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DC146B05C8; Thu, 19 Nov 2026 03:26:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E261F6B05C6
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 03:26:39 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C765809D8
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:26:39 +0000 (UTC)
X-FDA: 85451187318.10.2AD5F01
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id C4C2E4000A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:26:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nmEtFyZi;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795076797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jSCtwnWUqF8YnYGIgXEXWun4ZyiCBhUzU9yeZz4svZQ=;
	b=0p+LyAOOQe1q7zCnbeYtE1yT67Y+DF4IC/PwA6TpzSRYD1JsVRqQXlYgVkwSkTvyqrrx3i
	K/PJ/Jg1x8Z8sKVQbIf5qvGbkqvGYZtwaeJ+2swHgRZjZ3FFHVJbNrjVo1iPVlYJcDLwwr
	6nM3vQuEuK9ylTEhr7DeJ+vuWVGSSYs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795076797;
	b=ypbmpiH9t5IQD4Kdq8eNDk2QvmJqQmtdm6AFj3pXjS6CiaheG2t5QCTZygOKCgvxdgaCoV
	+alAACfEhfZvLA753uuXwjfboukOQyArBVqJq0umxhh35CGE75L6Ss/fS17Yossp6lkVFO
	RMFSu2L4K/qheWLlRCTY9YHs5VBMASM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nmEtFyZi;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BB7A1628B7;
	Thu, 19 Nov 2026 08:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBE51F000C6;
	Thu, 19 Nov 2026 08:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795076796;
	bh=jSCtwnWUqF8YnYGIgXEXWun4ZyiCBhUzU9yeZz4svZQ=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=nmEtFyZiww1LJNKlUpo4ZjlAKUT7UsDEi3xnuE7TENc3M5NLKwSnx/kV9xNf2uKsg
	 JeAcPslwklvyugoXMQxbyHqifsGyAPtdOTHWrUS2PNNzoXMZ7pm6iX8UzczXiaRKcc
	 7tHa2qgTya3FigLBDL/BEeGoVsfhH0ceSXyBU09bGs1M198jn1Apg2Ir40RkzY2vSL
	 IMT9EgkHOaBOdbUWOytTAqNWyserWZwE+VVswtUfYCe6Y80VcnCn4QEfQwpA2MNK2a
	 3gWjbg07bIYFNnx7wcVacHuX2C/kx3dKp7fasreNjzfc67XRyHR+xj4VxBivad1BR/
	 E/mGJ0+/t2qDQ==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/2] kho: do not expose incoming sub-blob contents
 in debugfs
From: Mike Rapoport <rppt@kernel.org>
To: Long Wei <longwei27@huawei.com>
Cc: rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
 akpm@linux-foundation.org, graf@amazon.com, leitao@debian.org, 
 corbet@lwn.net, rdunlap@infradead.org, linux-mm@kvack.org, 
 kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, hewenliang4@huawei.com
In-Reply-To: <20261119063800.698863-2-longwei27@huawei.com>
References: <20261117092951.4017931-1-longwei27@huawei.com>
 <20261119063800.698863-1-longwei27@huawei.com>
 <20261119063800.698863-2-longwei27@huawei.com>
Date: Thu, 19 Nov 2026 10:26:26 +0200
Message-Id: <179507678647.425130.8287708904179232007.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: 19uk17ap9hmrmtu3kagnnbwwh8aradpb
X-Rspam-User: 
X-Rspamd-Queue-Id: C4C2E4000A
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795076797-84570
X-HE-Meta: U2FsdGVkX19872dUHgwajX024Mt0GkzobL28RTROgOE/7GBnoDLyV5Ws82DOmXqTKk5rjhSp4193ZaG4NbCs22UwQs338cJsu086oiVDUpBObROfzbNrDU3hJQQBa3VrHFt9gHLvgXRBb4KCAh8b8bfvgDybjtXphxDDYIVfNFgUou0BucQyeCbrj28BDzEn1swhaF7j+SBN0Aldj8cypQN1AKA7VdCtmmxacClk8jJaXQeSfU0+mI+pWoE4HID/t4EizgsC8SPLKuf+baX+w+wu/VYFolJ35I0pc/Sr9Ahrc0x03NwLrj5vixo7+4VVkJt769/5LYMasE/9rxn6RM95AiwQXKzgmlCu07aEZY1lJb49XeCisPKGxNuv6fuCHTxFH3nHIc+yAfXfHDlnmIqk+/9JaOv1DORqrg8FmH9SsV8x6kbOY22j1RVDg9OH5y/rOr2+59/cAWFKNRvBNjENG2CfYweV+C1C1/Dh5/hkl7DeuQ1qgYV/GoOKTxRkZ1KAHQOJwWc3MIHSH8+dUEPcJSVislhft/N0nRnNWv1Bupj7UTWtZjMroflx0dmQfSAAPYKrhPRLPQ+EC3zCd/48fCVAbJ8oAnNaqRpYdC9awyqBg2A3/eOC/WP2b51HTITicc8uXus7KPQkhitpvPU4nyGFnD3T4XudrSwNjJ/jEiY0NZXp+nadvDLVRVmwAduweQg9cOa3YfkqZVHtxpgkqhTg5tMkTNwoPpmbCE8OfRO1l0TL5oFK2nxkGRjRUCcW6DPU5bQa0pdzwbmcyDrvrDw9xajn6j8dxzF0bSlpk/Bpl2F1PhYxTBQ/U8J5JY3RWX+NAAN9lda1+VSTWBOfVbdRJzlGsQKDPQp809qpB061g0PfYjmCHPWJ61X0C8vWboLhBmGa1/jej38q7n7fUpZb50sx6uOiWTk9QQoECXeEdZDb//ktnVJ7awAPnP4eQ2pfbV97I8+8sAx
 h+XvftDf
 jMCG/GHvQ1SKBWLksexS4FUAflGS8uPW7uO2QQjopdjUTW6rV/NgesHdcSyL9euvxUi7CUqiAEGkHwRL+im3omyD6vbmYiqfkTcD1rDTEjFB1a17gmljLL1dIYCsEpHmotULyIsSYRHLWgiIj8lZbiT92Rt7HNeggpz8Ed209cFLnCVXJo3i9/koAkJVQPChwTMP0AjnC/Ws2Yt0n4QMFxfX6DuUTrGukSv/JZ4vDDEnY8ZJe5xGNi8oAww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

> Incoming sub-blob pages are owned by their consumers and have independent
> lifetimes.  Some consumers, such as LUO, restore and free their state in
> early_initcall, i.e. before kho_init() (fs_initcall) builds the debugfs
> view:
> 
>   early_initcall: luo_early_startup()
>                     -> kho_retrieve_subtree("LUO")
>                     -> kho_restore_free(luo_ser)   /* page is freed */
> 
>   fs_initcall:    kho_init()
>                     -> kho_in_debugfs_init()
>                          -> phys_to_virt(luo_ser_phys)
>                          -> debugfs_create_blob("LUO", ...)
> 
> debugfs therefore ends up pointing at a page that was already handed back
> to the page allocator, and reading the file triggers a use-after-free:
> 
>   # cat /sys/kernel/debug/kho/in/sub_fdts/LUO
>   ==================================================================
>   BUG: KASAN: use-after-free in _copy_to_user+0x37/0x60
>   Read of size 32 at addr ffff88810309c000 by task cat/27436
> 
>   Call Trace:
>    <TASK>
>    kasan_report+0xb9/0xf0
>    kasan_check_range+0x100/0x1b0
>    _copy_to_user+0x37/0x60
>    simple_read_from_buffer+0x77/0xd0
>    read_file_blob+0x75/0xa0
>    vfs_read+0x12d/0x520
>    ksys_read+0xc3/0x160
>    do_syscall_64+0x97/0x4b0
>    entry_SYSCALL_64_after_hwframe+0x76/0x7e
>    </TASK>
> 
>   The buggy address belongs to the physical page:
>   page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x1fd
>   pfn:0x10309c
>   flags: 0x17ffffc0000000(node=0|zone=2|lastcpupid=0x1fffff)
>   page_type: f0(buddy)
>   ==================================================================
> 
> The page is already in the buddy allocator (page_type: f0(buddy),
> refcount 0), which confirms it was freed before the debugfs view was
> created.
> 
> KHO does not own these pages, so it cannot safely expose their contents at
> all.  Drop the in/sub_fdts directory.  The incoming FDT is reserved by KHO
> and remains exposed as in/fdt, where the same metadata is available.
> 
> Fixes: c609c144b0e8 ("kexec: add KHO parsing support")
> Signed-off-by: Long Wei <longwei27@huawei.com>

The change is fine, but the Fixes: tag should name the commit that
made the use-after-free reachable.

c609c144b0e8 ("kexec: add KHO parsing support") added in/sub_fdts, but
only memblock consumed an incoming sub-tree back then, and it never
freed it. Preserved pages that nobody restores stay reserved, so the
debugfs blobs pointed at valid memory. The same was true for test_kho
and for LUO while it kept luo_global.fdt_in.

The page is first freed early in boot by d376e4b55c9a0 ("liveupdate:
centralize state management into struct luo_ser"). That commit added
kho_restore_free(luo_ser) to luo_early_startup(), and it is the path
in the changelog and the KASAN report. It went into v7.2-rc1.

Pasha asked for c609c144b0e8 in v1 because in/sub_fdts never owned
those pages. That is a fair point about the design, but with that tag
stable will try to backport the patch to every tree since v6.16. There
is no bug in those trees, and the code there lives in
kernel/kexec_handover.c, so the patch won't apply. I'd use

  Fixes: d376e4b55c9a0 ("liveupdate: centralize state management into struct luo_ser")

and say in the changelog that in/sub_fdts has exposed memory KHO does not
own since c609c144b0e8.

-- 
Sincerely yours,
Mike.


