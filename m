Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EC3FCE9D46
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 15:05:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0403B6B009F; Tue,  6 Jan 2026 10:05:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00ACD6B00A0; Tue,  6 Jan 2026 10:05:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4C576B00A1; Tue,  6 Jan 2026 10:05:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D208D6B009F
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:05:54 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 70AC41AD46
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:05:54 +0000 (UTC)
X-FDA: 84301863828.23.188980B
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4AEBF14001D
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:05:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Wh7vj6qd;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767711952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ih/MVF9hcG6o3ffasttP2xSTsAYulJAzGdAShorFulo=;
	b=OzZLsTBxJDW7Or2LK9vyvsKH+Z0D025uHzJFx/aBf7e2ruj+4LuTtNnmjHS8Nia8orXp6O
	Z30ovh01ki69YQHD1Qdi/ip+vPL7QjA4I4S+dkp/xJcz9HS61Y0ydASBvI+4l9bvxZx/F/
	boBJIzf1bFlK2aPmEp0t0DzzuBdtE84=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Wh7vj6qd;
	spf=pass (imf26.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767711952; a=rsa-sha256;
	cv=none;
	b=LUhB9zSgI/5iBPnN7cxX//REZUipFd6+a5/q9I0X09RSdvMJPgAs7VThs9LmjrAlxZpQ09
	UM0TiKPpS8wqoNhTvMN9rPplJXZGVL0xrCxte5i66KApxaIy02IOpwysqrH8fdo3DOu0nu
	pf64a0n3qKCOa07VzAq8TeR6F+QkRh8=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-477ba2c1ca2so11198365e9.2
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 07:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767711951; x=1768316751; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ih/MVF9hcG6o3ffasttP2xSTsAYulJAzGdAShorFulo=;
        b=Wh7vj6qdKp2SsgruRs4CGy/yP5M+GQQqY8GFf4XZVJmZy9JfcZu41aWD8T1aIghokz
         qDmv99pKOm8WOXrDJ8mQOJeyg/MV2WYErAoZmI9GDI9/cOsM3s6+68nwRV9goXp3pimQ
         K8iP1CeUDTR5/eiIFKOuX/cL+R82tlVplYWxPPEsBcT/RAYrytBjyfNzb6BWx7n4RGRB
         W5tR5okOfeSnJLPhg2VYTQ0d1WCyKg33pbPHxu31VLJFQOD1kKwQGcTFosgERd/XlsYN
         ozgC7Sk1+mkMG6i4rTHaMkVrE2FkqayPsUiUhUTvAt3mfx92eBOfud0lPmmxe/5gMkyA
         +6+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767711951; x=1768316751;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ih/MVF9hcG6o3ffasttP2xSTsAYulJAzGdAShorFulo=;
        b=wNl7u3D8QYK0oCTWIKGbNPDwyMP0ohzY1gWSbBzu0y+XbkKoHQEVrH2g/lKg/gIN8g
         R9MQlktC0QyuKMvg1hN3aJw6VGm0Q2S6bFMRDSBRi198wAHIwcF+dty8UDJ9Y5wriOPM
         FZ+D4qL540HKqNrxnEYR5vosVqExqxDRDzG5DFQiQEQ6Sa4rnPwvdhBHCXfCDuttjVaZ
         jXp6PYltdTxWMAjxkBeVqfxbFSALBNMnn71tT1hc5RqE+RpdtdZk9qmqWa+f4Q1dStUn
         xiH8sKT2w0RE5x7NEvP7ta/6JDikc2vmpfvrmiQDji33pmZv0rPv1fxTTW/UEsuF/URL
         IWTw==
X-Gm-Message-State: AOJu0YyYs4wxeysxTXaZQLYKKlhPNHV946YhctISJJ8HuBy1ZEu3+rBV
	dGtvXPYrVwDMJA2po2l5wekaeNDDcQmrZ4YnBy4dkfz94fL+AAh8lCbjdEU1eCQnGug=
X-Gm-Gg: AY/fxX47lNorL2m9Gt9qd+Cqsw1FP4BmCz5WERuloMxX4nHNA1U8tTKAQANJXsLtRL+
	Ejyo13p/80px4gcTNB2ittFpfkyonP3UhMTd9K4D2CA21FzrfMNvWdLdcHEpGkTECf/WKiocD7b
	SzGhoCn/Pfd+kRg8t6k19zlgLoit0ttPO1OCMMBLXBRGWWXFV4tmSxOhSFhrU3n8mDLKAJwhEJ7
	UtX/Zs9odnt22yTedmvuoC1XPLHJyc8O/e5dv1hurlpz2wP2VDESakBm3KCecf22yyj/ustfxCh
	rXihrHNYXolCRjGvaZsb05WXPWXgrrr2z7cLZl4bhLSsCTW0aPfNhYGUmW9daLiJDVSB6Elpacx
	bixnWsI6/Qpq+5ooH8ARHXRYK6lzpFrCTKXJa2tKF8JAZ4RjJB0WGf5Gn3G/uIOi+bu2gOGUkfX
	fpXMgdBaKqy4XyQXSIPDFFjy4C
X-Google-Smtp-Source: AGHT+IGGY4QMf7Vmj2DO9sOVzlCcpkgE7/x2sMUminVefVSu/zv6TU4CZM+xAOFU1F8EI6fpRdVj5w==
X-Received: by 2002:a05:600c:46ca:b0:477:7a53:f493 with SMTP id 5b1f17b1804b1-47d7f0980e2mr37962255e9.23.1767711950535;
        Tue, 06 Jan 2026 07:05:50 -0800 (PST)
Received: from localhost (109-81-90-116.rct.o2.cz. [109.81.90.116])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f69e802sm47611505e9.8.2026.01.06.07.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 07:05:50 -0800 (PST)
Date: Tue, 6 Jan 2026 16:05:48 +0100
From: Michal Hocko <mhocko@suse.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	david@redhat.com, osalvador@suse.de, gregkh@linuxfoundation.org,
	rafael@kernel.org, dakr@kernel.org, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, hare@suse.de
Subject: Re: [RFC PATCH] memory,memory_hotplug: allow restricting memory
 blocks to zone movable
Message-ID: <aV0kzBxg57Mlw8mx@tiehlicka>
References: <20260105203611.4079743-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105203611.4079743-1-gourry@gourry.net>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4AEBF14001D
X-Stat-Signature: xo63xsg6h87339wmzwauea4jsiunygg4
X-Rspam-User: 
X-HE-Tag: 1767711952-114425
X-HE-Meta: U2FsdGVkX1/WlS7J3f0qkNQey/hHmH6+UTDzb1xCcEUfXGeWWIuVR+pOjWU2ZhrpZk0ovDOvVx2W48Ee3HGGtYryDOYN2c4TgezOjNdc11Kaklfzyxh9hMmU8CaqrvguCPi38xhKkA7a5P/0TEY0KrCsWEZ8CN5oXWur6DoCOwfxa9bH4Ivjv2euG7LK6L7o09QhrJVgw986hAdTrcA72/cBaHmpAGnHhtdLXQcThPoA/l5ohN6qM81+pwvhAgdzBCqJVEltst7vp5EmZLVi2QYHkfhq7I5pUtsGqk6RCCty0VysTbgptyR2ctkRGNOv8a8gCTRsOEzbpBnYr5nW6fu6GF1EGsf3y7n+C0ARLrKws+m1ywVxS7EAmWPnLb+IKfbhrvfhzrFSSHRHXg3E+binFBFd5p1gK4ubTHptefOb0+1LRajyyikS+RoVuGG+1zUNXm7qHpCoKeTohVxzxxsfjPXhSRrNEyR3z3Rk44ysuzuaXxQFkVVBO9JqDjWMHq2pOW8XqDC2oqAz3QzEWkS1BEVdAb9hKOfUpOgDeztd/Q1AHLAp/yCmCZcf7+ZaIL6kcUTWDZs/0Y1JAX8e94mPpyNBso6dFJAuV5QKU29B954+vFCcLPtM/Fw0iFbegC4e185b7K8j+hhpoSrw9iDgyw5UDUPxue6syUv9rRFSkUBDHQxAaZIE1wyZR7lBgDihLoRhwXQM+X3xL9KL1176uPY7Y3zrP/aQquVHQUx5iygA4Zld1RCSuvvZGwuHw/kpV8ZYyje0MIH8MnlpeV/oVcBpe0b2c31ox6JwUbATHM0GG9m/p7rtwfqtDzliRxzHNbmWDZqaPK/oYIFUuHnhR2hjI+/XCyH0PM1e/WD0ltKHtHuqeuLOZPbjxlhmXtqrllFgb80WJ2VxrHhMGUJ63m7CgNFhkqSqBcQiNgxF8hKPZ6QQO5+ifSj97t4vPwMphb7ZiOPt6KwvvhR
 awTv7Xt+
 u9/JDeUzxD63xOtRHwKp6Rj9l56UTpyIdk5BGmC2PL+ENlwJlElneHBYN/byRWZXidpC4Sq9rheH4wjCmvvMKQVsg223eo2osY+SEAsyYFUlrWDQhgmkQFf17szbYxIhYkz2y79gNDdK1qtwXsCZFvEaxQLrT482JoAEfDSkFi1SfEay0f1KUxSHNEI9LqCGiLwM5t6ee+2QRqRLU7pE6NCNhagV1ohK/hqohAL3gg89+7rvVp2UAmytIL7m0r3BdXVv7hvwHprkCb8b/jgPcdhAEQnZihsZps4verenG5Vg/DwNENsfhbGqgmz6amueh3qZAc/GSUj2yAO9AMREkqIdxhesTzg0pdA+arpMBNvhKQPDg2yuBiFQsrYxyVATuUAe5OTaA2+gx4SRcY771z5WWlnoJsCLffdSySKH4Jq0TWm48W/Qbqsd3reuyDpXPg7wkX9nEfIg8yTU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 05-01-26 15:36:11, Gregory Price wrote:
> It was reported (LPC 2025) that userland services which monitor memory
> blocks can cause hot-unplug to fail permanently.
>
> This can occur when drivers attempt to hot-remove memory in two phases
> (offline, remove), while a userland service detects the memory offline
> and re-onlines the memory into a zone which may prevent removal.

Are there more details about this?

> This patch allows a driver to specify that a given memory block is
> intended as ZONE_MOVABLE memory only (i.e. the system should try to
> protect its hot-unpluggability). This is done via an MHP flag and a new
> "movable_only" bool in `struct memory_block`.
> 
> Attempts to online a memory block with movable_only=true with any value
> other than MMOP_ONLINE_MOVABLE will fail with -EINVAL.
> 
> It is hard to catch all possible ways to implement offline/remove
> process, so a race condition here can clearly still occur if the
> userland service onlines the memory back into ZONE_MOVABLE, but it at
> least will not prevent the removal of a block at a later time.

Irrespective of the userspace note above (which seems like a policy that
should probably be re-evaluated or allow for a better fine tuning) I can
see some sense in drivers having a better control of which zones (kernel
vs. movable) can their managed memory fall into.

That being said, rather than movable_only, should we have a mask of
online types supported for the mem block?

> Suggested-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  drivers/base/memory.c          | 15 +++++++++++----
>  include/linux/memory.h         |  4 +++-
>  include/linux/memory_hotplug.h | 13 +++++++++++++
>  mm/memory_hotplug.c            | 12 +++++++++---
>  4 files changed, 36 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index 6d84a02cfa5d..59512e4b8d62 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -374,6 +374,8 @@ static int memory_block_change_state(struct memory_block *mem,
>  
>  	if (to_state == MEM_OFFLINE)
>  		mem->state = MEM_GOING_OFFLINE;
> +	else if (mem->movable_only && to_state != MMOP_ONLINE_MOVABLE)
> +		return -EINVAL;
>  
>  	ret = memory_block_action(mem, to_state);
>  	mem->state = ret ? from_state_req : to_state;
> @@ -811,7 +813,8 @@ void memory_block_add_nid_early(struct memory_block *mem, int nid)
>  
>  static int add_memory_block(unsigned long block_id, int nid, unsigned long state,
>  			    struct vmem_altmap *altmap,
> -			    struct memory_group *group)
> +			    struct memory_group *group,
> +			    bool movable_only)
>  {
>  	struct memory_block *mem;
>  	int ret = 0;
> @@ -829,6 +832,7 @@ static int add_memory_block(unsigned long block_id, int nid, unsigned long state
>  	mem->state = state;
>  	mem->nid = nid;
>  	mem->altmap = altmap;
> +	mem->movable_only = movable_only;
>  	INIT_LIST_HEAD(&mem->group_next);
>  
>  #ifndef CONFIG_NUMA
> @@ -880,7 +884,8 @@ static void remove_memory_block(struct memory_block *memory)
>   */
>  int create_memory_block_devices(unsigned long start, unsigned long size,
>  				int nid, struct vmem_altmap *altmap,
> -				struct memory_group *group)
> +				struct memory_group *group,
> +				bool movable_only)
>  {
>  	const unsigned long start_block_id = pfn_to_block_id(PFN_DOWN(start));
>  	unsigned long end_block_id = pfn_to_block_id(PFN_DOWN(start + size));
> @@ -893,7 +898,8 @@ int create_memory_block_devices(unsigned long start, unsigned long size,
>  		return -EINVAL;
>  
>  	for (block_id = start_block_id; block_id != end_block_id; block_id++) {
> -		ret = add_memory_block(block_id, nid, MEM_OFFLINE, altmap, group);
> +		ret = add_memory_block(block_id, nid, MEM_OFFLINE, altmap, group,
> +				       movable_only);
>  		if (ret)
>  			break;
>  	}
> @@ -998,7 +1004,8 @@ void __init memory_dev_init(void)
>  			continue;
>  
>  		block_id = memory_block_id(nr);
> -		ret = add_memory_block(block_id, NUMA_NO_NODE, MEM_ONLINE, NULL, NULL);
> +		ret = add_memory_block(block_id, NUMA_NO_NODE, MEM_ONLINE, NULL, NULL,
> +				       false);
>  		if (ret) {
>  			panic("%s() failed to add memory block: %d\n",
>  			      __func__, ret);
> diff --git a/include/linux/memory.h b/include/linux/memory.h
> index 43d378038ce2..bab24f796d3d 100644
> --- a/include/linux/memory.h
> +++ b/include/linux/memory.h
> @@ -80,6 +80,7 @@ struct memory_block {
>  	struct vmem_altmap *altmap;
>  	struct memory_group *group;	/* group (if any) for this block */
>  	struct list_head group_next;	/* next block inside memory group */
> +	bool movable_only;		/* If set, only ZONE_MOVABLE is valid */
>  #if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_MEMORY_HOTPLUG)
>  	atomic_long_t nr_hwpoison;
>  #endif
> @@ -160,7 +161,8 @@ extern int register_memory_notifier(struct notifier_block *nb);
>  extern void unregister_memory_notifier(struct notifier_block *nb);
>  int create_memory_block_devices(unsigned long start, unsigned long size,
>  				int nid, struct vmem_altmap *altmap,
> -				struct memory_group *group);
> +				struct memory_group *group,
> +				bool movable_only);
>  void remove_memory_block_devices(unsigned long start, unsigned long size);
>  extern void memory_dev_init(void);
>  extern int memory_notify(unsigned long val, void *v);
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index 23f038a16231..ca51ef2ad0cf 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -75,6 +75,19 @@ typedef int __bitwise mhp_t;
>   */
>  #define MHP_OFFLINE_INACCESSIBLE	((__force mhp_t)BIT(3))
>  
> +/*
> + * Restrict hotplugged memory blocks to ZONE_MOVABLE only.
> + *
> + * During offlining of hotplugged memory which was originally onlined
> + * as ZONE_MOVABLE, userland services may detect blocks going offline
> + * and automatically re-online them into ZONE_NORMAL or lower.  When
> + * this happens it may become permanently incapable of being removed.
> + *
> + * Allow driver-managed memory sources to restrict memory blocks to
> + * ZONE_MOVABLE only, so that the truly degenerate case can be mitigated.
> + */
> +#define MHP_MOVABLE_ONLY		((__force mhp_t)BIT(4))
> +
>  /*
>   * Extended parameters for memory hotplug:
>   * altmap: alternative allocator for memmap array (optional)
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 81ba5b019926..1a184bfd87f6 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1346,7 +1346,9 @@ static int check_hotplug_memory_range(u64 start, u64 size)
>  
>  static int online_memory_block(struct memory_block *mem, void *arg)
>  {
> -	mem->online_type = mhp_get_default_online_type();
> +	mem->online_type = mem->movable_only ?
> +			   MMOP_ONLINE_MOVABLE :
> +			   mhp_get_default_online_type();
>  	return device_online(&mem->dev);
>  }
>  
> @@ -1449,6 +1451,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
>  	unsigned long memblock_size = memory_block_size_bytes();
>  	u64 cur_start;
>  	int ret;
> +	bool movable_only = mhp_flags & MHP_MOVABLE_ONLY;
>  
>  	for (cur_start = start; cur_start < start + size;
>  	     cur_start += memblock_size) {
> @@ -1478,7 +1481,8 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
>  
>  		/* create memory block devices after memory was added */
>  		ret = create_memory_block_devices(cur_start, memblock_size, nid,
> -						  params.altmap, group);
> +						  params.altmap, group,
> +						  movable_only);
>  		if (ret) {
>  			arch_remove_memory(cur_start, memblock_size, NULL);
>  			kfree(params.altmap);
> @@ -1506,6 +1510,7 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>  	struct memory_group *group = NULL;
>  	u64 start, size;
>  	bool new_node = false;
> +	bool movable_only = mhp_flags & MHP_MOVABLE_ONLY;
>  	int ret;
>  
>  	start = res->start;
> @@ -1564,7 +1569,8 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>  			goto error;
>  
>  		/* create memory block devices after memory was added */
> -		ret = create_memory_block_devices(start, size, nid, NULL, group);
> +		ret = create_memory_block_devices(start, size, nid, NULL, group,
> +						  movable_only);
>  		if (ret) {
>  			arch_remove_memory(start, size, params.altmap);
>  			goto error;
> -- 
> 2.52.0

-- 
Michal Hocko
SUSE Labs

