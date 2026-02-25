Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE251FCEE8A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 11:29:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA6B06B00A9; Wed, 25 Feb 2026 06:29:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2A426B00AD; Wed, 25 Feb 2026 06:29:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2CC56B00AE; Wed, 25 Feb 2026 06:29:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BF1406B00A9
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 06:29:33 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6AC531C477
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:29:33 +0000 (UTC)
X-FDA: 84482758626.24.197F6DC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id C36A2A000E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:29:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PWpiXD1v;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772018971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=goqZuLkGy8gEkMCmvwLpiqHZftleNYKDe+rhz/rSVO4=;
	b=wvBoNPVv8by4YJRO1e+pyGklJJjH2qykz2l8hENquiCRu/iqPXZ5L8n50tx1ZXYN8FQR9u
	yVUh0BgiaeCcTrVCjo0jlbPBEud5z99Zgv3hSHs4MWTDFlc8j6a6DpeSeUorGgtU8xtMts
	fCo7jtNBRiUr2bz5Zx0IwayGTUKJqeM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772018971; a=rsa-sha256;
	cv=none;
	b=RHhbaBAVYtH7IBIdtd9vHD4XdrT5DvDA5BCWvgSGMrJDcPENpuHMUBvdIM4WnsgLRwrNur
	YtXfhuyjsssX8ZJlEGhyl/gr4k+zBiPCxbFgA1grloFNKC5qpPB3WQMtPc982EWSxHx+pB
	tcS/AZehV/ME9JtzkyFxw2/LnSn1Swg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PWpiXD1v;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C6FA4170A;
	Wed, 25 Feb 2026 11:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DA3C116D0;
	Wed, 25 Feb 2026 11:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772018970;
	bh=ZoMjdr0T6OM95kTpTHlHC/FoYXWZ4T8BYxxD5K3H2Qo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PWpiXD1vPXYvxvOheOYqV1U5YoimDIoPoi+fFNBTpYbOOXaZz5UfXmpwYuZG158E8
	 40GGsVEDIH7wfNfv0tFBHRGOMHZBRK4elGleYsKFoaJMG5qjfuSYF0yzqkVV8/7zBt
	 2wTnop450r3CkoMM58GF+dcSJ3/+WHYWJw5tmKOubTtfrHoFuXZ2k1ttVqdYOMPSDi
	 oi7Tsn+TURZe/oRzDmMdFCVytlfba2ab6DDYgXZRbvYgRVPFyDKXRCzwF1Dg30+EGE
	 VFocWPZ7GYHPLjDZZB7d4Gm0IkS7klHUd2KkNL+eJiyiveZ0ChhDoq2Mbs7imb5mL/
	 JTad5V2+X7U5A==
Message-ID: <f3a26a8a-a3db-4133-83c0-7a70faacee9c@kernel.org>
Date: Wed, 25 Feb 2026 12:29:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Regression] mm:slab/sheaves: severe performance regression in
 cross-CPU slab allocation
Content-Language: en-US
To: Ming Lei <ming.lei@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>,
 Christoph Hellwig <hch@infradead.org>
References: <aZ0SbIqaIkwoW2mB@fedora>
 <5cf75a95-4bb9-48e5-af94-ef8ec02dcd4d@suse.cz>
 <724310c2-46a2-4410-8a5d-c69dcc8de35d@kernel.org> <aZ7BbosIr2FvZFAe@fedora>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <aZ7BbosIr2FvZFAe@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Stat-Signature: f6qd535za3osw6ubakpejnmowxtwmw8c
X-Rspamd-Queue-Id: C36A2A000E
X-Rspam-User: 
X-HE-Tag: 1772018971-509629
X-HE-Meta: U2FsdGVkX18/PSYSEng9A2nYeWTSMtXHI3IpkWMOIQ6GIcc6+yLF3AkX1hb3Qkwq5ijFo6s3oNOuSQBtu4HlbGVac7fZ/mkx7GvIBsRuhG6ftU47mR43Di6G5B5n87kXEWBlfObpEuyEqdU3Bq0az81WupBbC8PhzwMDFzR0TL9ksh1ALP36AttXsM5Oak2F8kJ4IH+zHcsmg6l04TUk5+brqzKdfSyEyO35nkyKRoDZeBYq4JInndoqg4WueKIHs7QdSwxPYng/9+RwbxgjiQKbvBND2iQL+TO9UCjjUaLsIXVru22+wTOgLIdeCSVQ6VsAiTQ8UPFRHzRpein7NVxIaCjyV0DPcak1PqsRcwWU5kyzIgUSU7caH+8T9FJYikZdMc+UYMKJPCKIxPBgtpyttH8AnztP0Wbfg1zJOn/pbdigIzNSXisJU4Mes9go0vJGRHbypHwx4BmOHZ3ozoqFfV3TVlDZnOsBxIBapNVeP+Bcj3x+g3KXyDCVE1Y5VEORc8SZGeiyQIE3v9e87wRkM0hlyteHY1hzbFoHzu30WgJBLVO1ZoOaPxjfwA8BX8QnC7zqdf1JWZ7aZJ1oz5+gpH6y2vkf1a15C1ME36iFxmbFXXgLdZxqBQ9R+2ZnFWT7Xb+z+qUmjM61cYI+zUE1WjdudxJCsX9iw/va28SSuCvrHGFk2a4R3qeNo0Tk2sGM5ed3LKBiOYjFTta+qegVigymI+WfXG30CIjeS6B68xqFLL2SPgYxk1qVdH8aFMRUcNhnm+Tk7odIOLyCk0yMGQWYkuYl39jCzydDhlsTUmAgGD3lGjUeNOXOgli6vIGK+AMoIegzGlvQLWogjMz8UhX3mbtjDpvFUxbQaNCaN3PcGEBy4t32aNkgmFMYBRJj4jEFFBbQ+/TxR+0TcPF2sb/A1W+VYNEI0UehoXTKKoeT6vEVug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/25/26 10:31, Ming Lei wrote:
> Hi Vlastimil,
> 
> On Wed, Feb 25, 2026 at 09:45:03AM +0100, Vlastimil Babka (SUSE) wrote:
>> On 2/24/26 21:27, Vlastimil Babka wrote:
>> > 
>> > It made sense to me not to refill sheaves when we can't reclaim, but I
>> > didn't anticipate this interaction with mempools. We could change them
>> > but there might be others using a similar pattern. Maybe it would be for
>> > the best to just drop that heuristic from __pcs_replace_empty_main()
>> > (but carefully as some deadlock avoidance depends on it, we might need
>> > to e.g. replace it with gfpflags_allow_spinning()). I'll send a patch
>> > tomorrow to test this theory, unless someone beats me to it (feel free to).
>> Could you try this then, please? Thanks!
> 
> Thanks for working on this issue!
> 
> Unfortunately the patch doesn't make a difference on IOPS in the perf test,
> follows the collected perf profile on linus tree(basically 7.0-rc1 with your patch):

Hm that's weird, still the slowpath is prominent in your profile.

I followed your reproducer instructions, although only with a small
virtme-ng based setup. What's the output of "numactl -H" on yours, btw?

Anyway what I saw is my patch raised the IOPS substantially, and with
CONFIG_SLUB_STATS=y enabled I could see that
/sys/kernel/slab/bio-248/alloc_slowpath had substantial values before the
patch and zero afterwards.

Maybe if you could also enable CONFIG_SLUB_STATS=y and see in which cache(s)
there's significant alloc_slowpath even after the patch, it could help.

Thanks!


> ```
> 04cb971e2d28 (HEAD -> master) mm:slab/sheaves: severe performance regression in cross-CPU slab allocation
> a5a9cf3f020f mm: fix NULL NODE_DATA dereference for memoryless nodes on boot
> 7dff99b35460 (origin/master) Remove WARN_ALL_UNSEEDED_RANDOM kernel config option
> 551d44200152 default_gfp(): avoid using the "newfangled" __VA_OPT__ trick
> 6de23f81a5e0 (tag: v7.0-rc1) Linux 7.0-rc1
> ```
> 
> +   49.03%     2.00%  io_uring         [kernel.kallsyms]       [k] __blkdev_direct_IO_async
> -   38.66%     1.16%  io_uring         [kernel.kallsyms]       [k] bio_alloc_bioset
>    - 37.51% bio_alloc_bioset
>       - 34.98% mempool_alloc_noprof
>          - 34.87% kmem_cache_alloc_noprof
>             - 33.82% ___slab_alloc
>                - 30.25% get_from_any_partial
>                   - 29.59% get_from_partial_node
>                      - 28.42% __raw_spin_lock_irqsave
>                           native_queued_spin_lock_slowpath
>                + 2.16% allocate_slab
>                + 0.60% alloc_from_new_slab
>               0.51% __pcs_replace_empty_main
>         1.58% bio_associate_blkg
>    + 1.16% submitter_uring_fn
> +   35.16%     0.30%  io_uring         [kernel.kallsyms]       [k] kmem_cache_alloc_noprof
> +   35.13%     0.12%  io_uring         [kernel.kallsyms]       [k] mempool_alloc_noprof
> 
> 
> Thanks,
> Ming
> 


