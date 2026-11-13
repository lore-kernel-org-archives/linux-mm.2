Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6590E6075E22
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 17:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nj+gYvOx
Received: by kanga.kvack.org (Postfix)
	id 1889E6B05C9; Fri, 13 Nov 2026 12:33:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1392E6B05CA; Fri, 13 Nov 2026 12:33:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04FB06B05CB; Fri, 13 Nov 2026 12:33:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D13CD6B05C9
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:33:42 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4311D120180
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:33:42 +0000 (UTC)
X-FDA: 85430793084.09.05B5E8B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7577616000E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:33:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nj+gYvOx;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794591220;
	b=aKEqEBX31Cvh3arATp3qAk6a+mq62E4tUQXWRWz2RkFo2tTRzBSqvUctmTeRATds74G7+8
	yfjWJdKfFPJk3zLATWSVKlfel7twoZo1cB0//2u+W7gBdP9y06m4vhR/Kz5dj4qAXf572Q
	g/m3bJfAZHvn0BkBgLhQNt57xIkmLMU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nj+gYvOx;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794591220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kv7BDGPBwuPWEZQhR2InhXR34RPBwAkzXgdKO+ZahP0=;
	b=CycJTQDaTLCFLmR9+naN9jBI65ouY9nAXgtdXRyzZtef6sIFtLv3nwdS/AjwDPcC1ZeIaP
	Z+Kkjd1oxQWEKbn3ZfgCTQfHLFgyCUmeoTGHnQaXotWWzGgWuPUjOs0kP3sESa40UEAH4O
	ZNi0gimyaHBeezHBqMIwEBEVk+OkVlA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AE35C63276;
	Fri, 13 Nov 2026 17:33:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEB71F000CC;
	Fri, 13 Nov 2026 17:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794591219;
	bh=Kv7BDGPBwuPWEZQhR2InhXR34RPBwAkzXgdKO+ZahP0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=nj+gYvOxuaFa8U1PjQSbesNMnJI3ApEvBsFxziUXX9m3XAIWX/O/zj/09CAgFUjDi
	 7J7qLXRvj/JULay/QFLajS4qrGhpc7sB0xJSMHNMj3FZmdk7mmRsP1VLuF7h8C0I1p
	 BnQHlmoGn4aZPQk98/laiaoOkBUu5s2YqcuXYP34=
Date: Fri, 13 Nov 2026 09:33:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, Linux
 Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
 "Liam R. Howlett (Google)" <liam@infradead.org>, "Oscar Salvador (SUSE)"
 <osalvador@kernel.org>
Subject: Re: [akpm-mm:mm-new 307/308] mm/cma.c:493 cma_find_free_range()
 warn: always true condition '(start < (4294967296)) => (0-u32max <
 4294967296)'
Message-Id: <20261113093338.c9ac760d6f6010f8108d4cba@linux-foundation.org>
In-Reply-To: <202611131415.4Nn1yaIf-lkp@intel.com>
References: <202611131415.4Nn1yaIf-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bwbsprjzxwe9zsi7h6so5ks58jxnuwjn
X-Rspamd-Queue-Id: 7577616000E
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794591220-237669
X-HE-Meta: U2FsdGVkX18bQereP5icjB3HGGAwKONICZpIJCopUJ/vLhNvrfWCqVWHM0RyWHwgHEpt+gUJtrogILsBXIttS7hg5quxHhzsrorXtZ833ObvLwc9BJfkCgi+6AUXvd6otaMPsYuM0E9e1iPbmwV6VKjHo5ZwT86IcxZGTyScYZskWJkOyvr8Oa94TNf2DuSf8gDOZquSTob/8p7k/TtCV8uqAJatjLhn5uUNyk/rW1uHEr0e7/MJul5qKhEXhLFCSHa/00O3LKmN1g3SbpTiYp8xFeahpfOZLeVSEKFLwmT6ITyCOS2q+0PUuGG/XivW2WhMDv0b6nr3jK5jSN97L0QBI2LlaeGmpISDLwHwbDGWWFgzi5PbBh8pEQDcjF9ScxbE30v7CI//i8bAYOX1yd8sR3U9Xz5yl7qDVged8jc7GE5vdPeA8NlVVh/+xsDabqLrGA9AOvqjbC88Euzx2S/8q1XmdGRFNOcSJuCaXmbehkEFxTeUIBUTJGRQbBF0AcTGn0hy/5voikcptw9h9FQJfpIwzp7uir3huUGRiRQr4MZfozeYYWW8nZTPn1t1eavFOhXP4CmFMo79h28/FnK+L73x5UtDCKSefsheiw/lD28xNRDTcZI1l3ZmsuHUSKTMrHWs4kbPevDxnPh4ssci3QwpcjL7rcEnd9Ec1/XofIfmJYKSNSdfqKB1KyvNSYap4cUTmzZaPYLvAzqUMXR38H1Xbe2+d8EyiZRBhbQjrFdAkBodCpVjuiHen38QMQnGncNda86Shk2tlPQ73LLGN8CIV3pJrspjjeO4586wGGmC52LLgOIaNQWbdpaT2rCotGZ4hnthV6OpbH2U8LRCThJsQrOLjRmWGmqcLcORfaE92Q+aaNwuO8rSAbT4q09Xqr1CKsV8vQ7hjrs+wbdt6jSEGhCOrFAV4ZbD71/xMES3nRJlS0EnIuFWOhlybbFawj16dO2lAAa521S
 0japShzm
 e/I1aZ3AdbsbKIcukRx3cQTMfab8dGeLEzH5Gd5571DYOR9bxUdptV3qUW2m0ly4VRhWYnb5649Bs71irTP2cKqmoyaLDSloLlDBGPQBcpQulw8LqfH4FvMK4cYHKNs/Dht2ijUCuhVLL11xre9Y9mwoPPqLHfap9RLurAdwILfry60/WUajxSOonur4lWZ1618pHPbdzwtdHQvSXb+39hYYLqmL6/XSyC+IsQ8p6MsSe2fRnd0jF19VixYoCXn1ikhU539bbDWt6sUnRfJpy9oXeGTtXgu3yQR061Zmpx8Yj+ZTraonw8WmW2RIiufhNbVvBMVpLrfPQp8AEjhv+DCfzkCYRSncVJplDOuXEWhnDstXOf+S0TlU+2wgPGf7iyaQ1Zb2NsOa//IDQPx1bRnNihDfOEKp0d0gc1VhAxiA0zs8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 13 Nov 2026 14:29:18 +0100 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   31a696f9c37defab0f28f774e00ac7f135889ec3
> commit: 4cbc68cde0e185ae7cefed74c1b56e61cfe13277 [307/308] mm/cma: simplify cma_declare_contiguous_multi()
> config: um-randconfig-2200-20261113 (https://download.01.org/0day-ci/archive/20261113/202611131415.4Nn1yaIf-lkp@intel.com/config)
> compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 8621950157210c1fa68f20f0614cb51310ec9dff)
> smatch: v0.5.0-9187-g5189e3fb
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202611131415.4Nn1yaIf-lkp@intel.com/
> 
> smatch warnings:
> mm/cma.c:493 cma_find_free_range() warn: always true condition '(start < (4294967296)) => (0-u32max < 4294967296)'
> 
> vim +493 mm/cma.c
> 
>    476	
>    477	/*
>    478	 * Find the largest free range above 4G that can hold a part of a multi-range
>    479	 * CMA area.
>    480	 */
>    481	static phys_addr_t __init cma_find_free_range(phys_addr_t align,
>    482			phys_addr_t size_align, int nid, phys_addr_t *basep)
>    483	{
>    484		phys_addr_t start, end, size;
>    485		phys_addr_t max = 0;
>    486		u64 i;
>    487	
>    488		/* no point searching if the system can't addres above 4G */
>    489		if (!IS_ENABLED(CONFIG_PHYS_ADDR_T_64BIT))
>    490			return 0;

silly smatch.  But I'll fix that typo!

>    492		for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &start, &end, NULL) {
>  > 493			if (start < SZ_4G)
>    494				continue;


