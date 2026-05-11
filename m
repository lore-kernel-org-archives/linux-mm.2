Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C45ECD4843
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 11:28:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3CA36B0095; Mon, 11 May 2026 07:28:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEC8F6B00B9; Mon, 11 May 2026 07:28:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DB5C6B00BA; Mon, 11 May 2026 07:28:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8BB9F6B0095
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:28:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4B9FF1C123D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:28:00 +0000 (UTC)
X-FDA: 84754914720.03.F312A50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5A25F40005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:27:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CIfXIVLF;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf07.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778498878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F0P1PDju6jr9cv9Ksne7vALVWTPLR6/ufkLvnSbh3J8=;
	b=oxcXZ2dHsF30kr2ItVhqUdiAMqC+42rM26YI1n2Vlk/UayxZt81YqlryN+a/ejXyfEctDJ
	JBDlvd9U4amPJ4bVEICQxuJI8/d1+H3UcrItQMiV8ULT3XJxenU1gvl7W0Ln/h0laTw+BG
	Da6ZFqUYcJbu8tDVKvsks8iVJUOd8+A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778498878; a=rsa-sha256;
	cv=none;
	b=n2KZAytnLGdwQmnIgtI6p/UHPaUX3hCM5lJ4jFtF4wdTXGS+sslFibEYPyPaXvYRGk3uM0
	tO85kiyZXFWPXpJE7Utm3XhCBvkYR57svyKfoGf8Fk5F0UIH4JKY/Bnob+h06wNpBWT7IQ
	VtqFIszqE+v03EoMHTZ/TQHz05GhBgY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CIfXIVLF;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf07.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-488af96f6b2so49200945e9.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 04:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778498877; x=1779103677; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F0P1PDju6jr9cv9Ksne7vALVWTPLR6/ufkLvnSbh3J8=;
        b=CIfXIVLFzzSo0sE8LkTTDsEmqxrLm3i1L2/39mBI1DeQIauauMHYrW3wiPTQinJtBw
         QBpYuaHh5tO9awIzbKsehQMZ2ZBCV6zD9Md1NrF1lQLM9fEDdTDRtf4E6bvg+zPtz5Rv
         jtGHXKwaISQauURE1Y5ea/Yy92LVIALsbDyC+TqnfiKR9lPhWneeQYZQUQbFmZ70oBzm
         Glt2eKBHn6WORsXuVx5Y9V7FzljIscJhQFaRkNQx61h8E9e7E60qvV3iZn5xAXtFY/qz
         2h//vuhIAr2YwNcp/Huqf+PKzTa/482yKKL8Kbk3YU8zDKlNc0X3QQT3D3U4m4H5+4V0
         Pa/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778498877; x=1779103677;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F0P1PDju6jr9cv9Ksne7vALVWTPLR6/ufkLvnSbh3J8=;
        b=r4q9lzYp89uzOQgjXog4A4QAIMyHi9ilxSJJepyI/+Iu9dZiMaDzR3JlAjITskUnT/
         XNTu0/56BX/QBWsJZBlcfU5O1tDcJlmzPu9d2aQgqnEbRPRNVB6nEZVSkVUZ154Hp2Rj
         3Y5C/W6muvE33vMUy2W0KNFymkL0pl8TW6CLCHQ+gd/0aeKJAgDLE8tLhX+idUTkmLoV
         q6TU1pLwnXsNT1ktAlnYDt+uC+lJCt/3JeYrtWP/z64gMgiLDcJHP3k9tv+uNqF1yvj7
         8dn/Y4v2N9SvMLDwsC4/ptn+lb+FAgdPHupHtBzGZgln/wpEG8KhjpcOR7kABGgHptRW
         5SRQ==
X-Forwarded-Encrypted: i=1; AFNElJ+3U5KIP6vET7dB1YDquC2LdQjoSMqMbsdm7eh1kT3om1VGorXHm+X1lZQQcXgGtHbiJJa+i7/SLQ==@kvack.org
X-Gm-Message-State: AOJu0YzlAs2vsH7VkFhKGA2q5+BFBW+WkvzELUG+E+ijc0oStsOwGbJx
	c0Zaod9l37x2RAZBGyhcr8txVOd5BJy60d60hPZ5QnK/hgS7jaqpJ/nMVTM/CXqGKeY=
X-Gm-Gg: Acq92OHPm9R6UpWG2lc0GvpJsE2lWzvHoSHOHDoZJHZ50/Z71kodaYEkCyT48tt5ROz
	onu4xkAQarBKG3ak0sauh47puW/G7CDiFuxCdQCoZaE7zY+PKn7V9TaoxRDc5B49CDR6IS819Hw
	G0KY1TbWfu05Be6Wq5PzeYslobZ+OsioKaqipu78qcgY9M7CFdsQvVlbMlPAqHMsWifKZV6gDdX
	bQtcCzfzUZu2L1SilUr/0fKdtwcI2GmD7gVDxBXkLp+gi7FgPska2vqqr44tAVVARExNKhm/O/M
	ElzoWQo0r0JZBGdSLcumqJatWOcqRKMzk67NFwZOaYakJMdcsNUM65DQQUmXZRQQJxgHfxVylc/
	qSlZ0ua1q/o7sBEJ1g3HP5KLBdDQW+NoUBzjiU/UcaWKFwPpfk8suVMtNqdwwCqLJi49yiUiYw/
	ic84lyQ5c/Qaj5hKhJwYu7jTzUqDmWJuJ1pG3J
X-Received: by 2002:a05:600c:4695:b0:48e:5d91:cffb with SMTP id 5b1f17b1804b1-48e706c0662mr144541925e9.10.1778498876533;
        Mon, 11 May 2026 04:27:56 -0700 (PDT)
Received: from localhost (109-81-87-110.rct.o2.cz. [109.81.87.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e701e957asm181011495e9.6.2026.05.11.04.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 04:27:56 -0700 (PDT)
Date: Mon, 11 May 2026 13:27:55 +0200
From: Michal Hocko <mhocko@suse.com>
To: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, linux-mm@kvack.org,
	driver-core@lists.linux.dev, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
	muchun.song@linux.dev
Subject: Re: [PATCH] drivers/base/memory: make memory block get/put explicit
Message-ID: <agG9O2_6nx5eNOCf@tiehlicka>
References: <20260511111800.2181785-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511111800.2181785-1-songmuchun@bytedance.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5A25F40005
X-Stat-Signature: pymt5mxkdag96mg7e78dnwn1fgsnxrmf
X-Rspam-User: 
X-HE-Tag: 1778498878-637719
X-HE-Meta: U2FsdGVkX1+dnWNb+Nq6G1e+qFP8pYswGLdwQRPR/3+BfLlS6jK1s3XCN4Ew/ETC1J+LlWN24kkBa7OqU9pLXa1/OLsDWs25NJkVxeh3WsoqS6FXm1a3UxNsNtqUJIeFS9/603JBrazli9L7O4GGxF9l89DMSzfGdYuS1zqNTjiI9BXDFBpPiKJEKezdQt2cXd9axSQ1+99eFFYBp6lmka6ocG5q/gtMWGRX9nk4skA9+9KcpocLsxKBwCyhqbSFLbVkkj9lV4oFToLlN+jjCcmAkrArOJpGn7Ay37wxjc3gK0tXcgu3LcFEvM9K/DrWN57cX7qioRWNlgBc6j4wHuFm2PiSG9bGvO9VP79+WUtcaUuwAyU79lS3BPWMdgErS7P9y46K12UlRQnRI0zSZRtQEZVO0EvlO0w+PnnBDC97ZlFMpI+VkPKMKyOEMzTOGumn6SjCqs70TMoKpXzL32+MGbc+uaBq1AgbmjK+Tu6yaTUNl+qmnNxZ/CBbPT0yWYGm+A2WnPONaq2cjI6gzD+N4uZn+EJouPEU2Hv8ddJ0T0rJW997xCqdqQWCSBBqB8eMvETFOIwUcqRnR6tk0ZdOa/NCwulXhOqTUlVFCtlMUW6Itg7e8wOBgZupJsTe8e0uOQzJQU7HPUl4C0/zxx+pnzE5pE0vHdXuUa3w01jwXa2EBDqALnQhB4mbfdyGNEuljvpe411+7F0DAhSRQD3qIQ8RaEvTbrnXjAO/vFeEFvD1G1luUDS/LqfUoTyJDqAKCFGG/DFR4+M/RH8el1rau6mdU69Fv5cdSnosyrrgAGrxLescDwA6el+QY3sS6hEIjUlb9cnhRkxEqwxb2nXQBB3jvxVsyGhqaHqS/0jdZzuPMpALRa0NRaolpFr9mEaJyLUfzk1ql2j/wsXBQYTRLYS53ItwEqnG7TMMPwmRxKlhmbW73NWVo/naV46XMiupdaDJ885OHvVmfdk
 /Tu8IaWu
 UF3DjVWolMHNXOSawM9TUK7PG4jFTPGHD1ZKGjU64yvenzmGlzUKvYEqG8Al0gr3S8lBvmPEi2KdYE1+C7mzeMxx95SkmRHRQVnqGg7kCRY2vRbmih21cJ1IbsTtvtcrsiXRAOXwp/L0zmRB/jsaQxtIHk2+SFgRGlSwXqZtXFByvA2oWLOnM7yhMFvsfioDfQnUqCr28ttoHqnFemVsYNKiOiBCkXpUwhTFwhkDNBzWWPk653eInHc/cpmHU49xTReQmjptjOkm0q0hT8ZGD9Ibf+T1BLT2jYqN7O+shdFcyZ+uwpNxxfTNLlwLuTCRrX02AXyhkmfsSKzt9L+mnASyfxE73EwU4A+R8XzeebKleUMCZAp9X8FgyfdFBZ5Zj9T24r2MyD/T/ZteGkYM7GWFTfqltC1WHwo9xobw9snqLN4en7RQ4/TOeZhP0th2eqQNmRe+FxAdrwnUQ52y4jp17rg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 11-05-26 19:18:00, Muchun Song wrote:
> Rename the memory block lookup helper to make the acquired reference
> explicit, add memory_block_put() to wrap put_device(), and collapse the
> redundant section-number wrapper into a single block-id based lookup
> interface.
> 
> This makes it clearer to callers that a successful lookup holds a
> reference that must be dropped, reducing the chance of forgetting the
> matching put and leaking the memory block device reference.
> 
> Link: https://lore.kernel.org/linux-mm/7887915D-E598-42B3-9AFE-BFFBACE8DE2D@linux.dev/#t
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  .../platforms/pseries/hotplug-memory.c        | 14 ++-----
>  drivers/base/memory.c                         | 38 +++++++------------
>  drivers/base/node.c                           |  4 +-
>  drivers/s390/char/sclp_mem.c                  | 17 ++++-----
>  include/linux/memory.h                        |  7 +++-
>  mm/memory_hotplug.c                           |  5 +--
>  6 files changed, 35 insertions(+), 50 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/pseries/hotplug-memory.c b/arch/powerpc/platforms/pseries/hotplug-memory.c
> index 75f85a5da981..94f3b57054b6 100644
> --- a/arch/powerpc/platforms/pseries/hotplug-memory.c
> +++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
> @@ -164,13 +164,7 @@ static int update_lmb_associativity_index(struct drmem_lmb *lmb)
>  
>  static struct memory_block *lmb_to_memblock(struct drmem_lmb *lmb)
>  {
> -	unsigned long section_nr;
> -	struct memory_block *mem_block;
> -
> -	section_nr = pfn_to_section_nr(PFN_DOWN(lmb->base_addr));
> -
> -	mem_block = find_memory_block(section_nr);
> -	return mem_block;
> +	return memory_block_get(phys_to_block_id(lmb->base_addr));
>  }
>  
>  static int get_lmb_range(u32 drc_index, int n_lmbs,
> @@ -220,7 +214,7 @@ static int dlpar_change_lmb_state(struct drmem_lmb *lmb, bool online)
>  	else
>  		rc = 0;
>  
> -	put_device(&mem_block->dev);
> +	memory_block_put(mem_block);
>  
>  	return rc;
>  }
> @@ -319,12 +313,12 @@ static int dlpar_remove_lmb(struct drmem_lmb *lmb)
>  
>  	rc = dlpar_offline_lmb(lmb);
>  	if (rc) {
> -		put_device(&mem_block->dev);
> +		memory_block_put(mem_block);
>  		return rc;
>  	}
>  
>  	__remove_memory(lmb->base_addr, memory_block_size);
> -	put_device(&mem_block->dev);
> +	memory_block_put(mem_block);
>  
>  	/* Update memory regions for memory remove */
>  	memblock_remove(lmb->base_addr, memory_block_size);
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index 11d57cfa8d72..5b5d41089e81 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -649,7 +649,7 @@ int __weak arch_get_memory_phys_device(unsigned long start_pfn)
>   *
>   * Called under device_hotplug_lock.
>   */
> -struct memory_block *find_memory_block_by_id(unsigned long block_id)
> +struct memory_block *memory_block_get(unsigned long block_id)
>  {
>  	struct memory_block *mem;
>  
> @@ -659,16 +659,6 @@ struct memory_block *find_memory_block_by_id(unsigned long block_id)
>  	return mem;
>  }
>  
> -/*
> - * Called under device_hotplug_lock.
> - */
> -struct memory_block *find_memory_block(unsigned long section_nr)
> -{
> -	unsigned long block_id = memory_block_id(section_nr);
> -
> -	return find_memory_block_by_id(block_id);
> -}
> -
>  static struct attribute *memory_memblk_attrs[] = {
>  	&dev_attr_phys_index.attr,
>  	&dev_attr_state.attr,
> @@ -701,7 +691,7 @@ static int __add_memory_block(struct memory_block *memory)
>  
>  	ret = device_register(&memory->dev);
>  	if (ret) {
> -		put_device(&memory->dev);
> +		memory_block_put(memory);
>  		return ret;
>  	}
>  	ret = xa_err(xa_store(&memory_blocks, memory->dev.id, memory,
> @@ -795,9 +785,9 @@ static int add_memory_block(unsigned long block_id, int nid, unsigned long state
>  	struct memory_block *mem;
>  	int ret = 0;
>  
> -	mem = find_memory_block_by_id(block_id);
> +	mem = memory_block_get(block_id);
>  	if (mem) {
> -		put_device(&mem->dev);
> +		memory_block_put(mem);
>  		return -EEXIST;
>  	}
>  	mem = kzalloc_obj(*mem);
> @@ -845,8 +835,8 @@ static void remove_memory_block(struct memory_block *memory)
>  		memory->group = NULL;
>  	}
>  
> -	/* drop the ref. we got via find_memory_block() */
> -	put_device(&memory->dev);
> +	/* drop the ref. we got via memory_block_get() */
> +	memory_block_put(memory);
>  	device_unregister(&memory->dev);
>  }
>  
> @@ -880,7 +870,7 @@ int create_memory_block_devices(unsigned long start, unsigned long size,
>  		end_block_id = block_id;
>  		for (block_id = start_block_id; block_id != end_block_id;
>  		     block_id++) {
> -			mem = find_memory_block_by_id(block_id);
> +			mem = memory_block_get(block_id);
>  			if (WARN_ON_ONCE(!mem))
>  				continue;
>  			remove_memory_block(mem);
> @@ -908,7 +898,7 @@ void remove_memory_block_devices(unsigned long start, unsigned long size)
>  		return;
>  
>  	for (block_id = start_block_id; block_id != end_block_id; block_id++) {
> -		mem = find_memory_block_by_id(block_id);
> +		mem = memory_block_get(block_id);
>  		if (WARN_ON_ONCE(!mem))
>  			continue;
>  		num_poisoned_pages_sub(-1UL, memblk_nr_poison(mem));
> @@ -1015,12 +1005,12 @@ int walk_memory_blocks(unsigned long start, unsigned long size,
>  		return 0;
>  
>  	for (block_id = start_block_id; block_id <= end_block_id; block_id++) {
> -		mem = find_memory_block_by_id(block_id);
> +		mem = memory_block_get(block_id);
>  		if (!mem)
>  			continue;
>  
>  		ret = func(mem, arg);
> -		put_device(&mem->dev);
> +		memory_block_put(mem);
>  		if (ret)
>  			break;
>  	}
> @@ -1228,22 +1218,22 @@ int walk_dynamic_memory_groups(int nid, walk_memory_groups_func_t func,
>  void memblk_nr_poison_inc(unsigned long pfn)
>  {
>  	const unsigned long block_id = pfn_to_block_id(pfn);
> -	struct memory_block *mem = find_memory_block_by_id(block_id);
> +	struct memory_block *mem = memory_block_get(block_id);
>  
>  	if (mem) {
>  		atomic_long_inc(&mem->nr_hwpoison);
> -		put_device(&mem->dev);
> +		memory_block_put(mem);
>  	}
>  }
>  
>  void memblk_nr_poison_sub(unsigned long pfn, long i)
>  {
>  	const unsigned long block_id = pfn_to_block_id(pfn);
> -	struct memory_block *mem = find_memory_block_by_id(block_id);
> +	struct memory_block *mem = memory_block_get(block_id);
>  
>  	if (mem) {
>  		atomic_long_sub(i, &mem->nr_hwpoison);
> -		put_device(&mem->dev);
> +		memory_block_put(mem);
>  	}
>  }
>  
> diff --git a/drivers/base/node.c b/drivers/base/node.c
> index 126f66aa2c3e..b3333ca92090 100644
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -847,13 +847,13 @@ static void register_memory_blocks_under_nodes(void)
>  		for (block_id = start_block_id; block_id <= end_block_id; block_id++) {
>  			struct memory_block *mem;
>  
> -			mem = find_memory_block_by_id(block_id);
> +			mem = memory_block_get(block_id);
>  			if (!mem)
>  				continue;
>  
>  			memory_block_add_nid_early(mem, nid);
>  			do_register_memory_block_under_node(nid, mem);
> -			put_device(&mem->dev);
> +			memory_block_put(mem);
>  		}
>  
>  	}
> diff --git a/drivers/s390/char/sclp_mem.c b/drivers/s390/char/sclp_mem.c
> index 78c054e26d17..6df1926d4c62 100644
> --- a/drivers/s390/char/sclp_mem.c
> +++ b/drivers/s390/char/sclp_mem.c
> @@ -204,7 +204,7 @@ static ssize_t sclp_config_mem_store(struct kobject *kobj, struct kobj_attribute
>  	addr = sclp_mem->id * block_size;
>  	/*
>  	 * Hold device_hotplug_lock when adding/removing memory blocks.
> -	 * Additionally, also protect calls to find_memory_block() and
> +	 * Additionally, also protect calls to memory_block_get() and
>  	 * sclp_attach_storage().
>  	 */
>  	rc = lock_device_hotplug_sysfs();
> @@ -231,20 +231,19 @@ static ssize_t sclp_config_mem_store(struct kobject *kobj, struct kobj_attribute
>  			sclp_mem_change_state(addr, block_size, 0);
>  			goto out_unlock;
>  		}
> -		mem = find_memory_block(pfn_to_section_nr(PFN_DOWN(addr)));
> -		put_device(&mem->dev);
> +		mem = memory_block_get(phys_to_block_id(addr));
> +		memory_block_put(mem);
>  		WRITE_ONCE(sclp_mem->config, 1);
>  	} else {
>  		if (!sclp_mem->config)
>  			goto out_unlock;
> -		mem = find_memory_block(pfn_to_section_nr(PFN_DOWN(addr)));
> +		mem = memory_block_get(phys_to_block_id(addr));
>  		if (mem->state != MEM_OFFLINE) {
> -			put_device(&mem->dev);
> +			memory_block_put(mem);
>  			rc = -EBUSY;
>  			goto out_unlock;
>  		}
> -		/* drop the ref just got via find_memory_block() */
> -		put_device(&mem->dev);
> +		memory_block_put(mem);
>  		sclp_mem_change_state(addr, block_size, 0);
>  		__remove_memory(addr, block_size);
>  #ifdef CONFIG_KASAN
> @@ -294,11 +293,11 @@ static ssize_t sclp_memmap_on_memory_store(struct kobject *kobj, struct kobj_att
>  		return rc;
>  	block_size = memory_block_size_bytes();
>  	sclp_mem = container_of(kobj, struct sclp_mem, kobj);
> -	mem = find_memory_block(pfn_to_section_nr(PFN_DOWN(sclp_mem->id * block_size)));
> +	mem = memory_block_get(phys_to_block_id(sclp_mem->id * block_size));
>  	if (!mem) {
>  		WRITE_ONCE(sclp_mem->memmap_on_memory, value);
>  	} else {
> -		put_device(&mem->dev);
> +		memory_block_put(mem);
>  		rc = -EBUSY;
>  	}
>  	unlock_device_hotplug();
> diff --git a/include/linux/memory.h b/include/linux/memory.h
> index 5bb5599c6b2b..29edef1f975c 100644
> --- a/include/linux/memory.h
> +++ b/include/linux/memory.h
> @@ -158,7 +158,11 @@ int create_memory_block_devices(unsigned long start, unsigned long size,
>  void remove_memory_block_devices(unsigned long start, unsigned long size);
>  extern void memory_dev_init(void);
>  extern int memory_notify(enum memory_block_state state, void *v);
> -extern struct memory_block *find_memory_block(unsigned long section_nr);
> +extern struct memory_block *memory_block_get(unsigned long block_id);
> +static inline void memory_block_put(struct memory_block *mem)
> +{
> +	put_device(&mem->dev);
> +}
>  typedef int (*walk_memory_blocks_func_t)(struct memory_block *, void *);
>  extern int walk_memory_blocks(unsigned long start, unsigned long size,
>  			      void *arg, walk_memory_blocks_func_t func);
> @@ -171,7 +175,6 @@ struct memory_group *memory_group_find_by_id(int mgid);
>  typedef int (*walk_memory_groups_func_t)(struct memory_group *, void *);
>  int walk_dynamic_memory_groups(int nid, walk_memory_groups_func_t func,
>  			       struct memory_group *excluded, void *arg);
> -struct memory_block *find_memory_block_by_id(unsigned long block_id);
>  #define hotplug_memory_notifier(fn, pri) ({		\
>  	static __meminitdata struct notifier_block fn##_mem_nb =\
>  		{ .notifier_call = fn, .priority = pri };\
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 462d8dcd636d..890c6453e887 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1417,14 +1417,13 @@ static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
>  		struct vmem_altmap *altmap = NULL;
>  		struct memory_block *mem;
>  
> -		mem = find_memory_block(pfn_to_section_nr(PFN_DOWN(cur_start)));
> +		mem = memory_block_get(phys_to_block_id(cur_start));
>  		if (WARN_ON_ONCE(!mem))
>  			continue;
>  
>  		altmap = mem->altmap;
>  		mem->altmap = NULL;
> -		/* drop the ref. we got via find_memory_block() */
> -		put_device(&mem->dev);
> +		memory_block_put(mem);
>  
>  		remove_memory_block_devices(cur_start, memblock_size);
>  
> 
> base-commit: e98d21c170b01ddef366f023bbfcf6b31509fa83
> -- 
> 2.54.0

-- 
Michal Hocko
SUSE Labs

