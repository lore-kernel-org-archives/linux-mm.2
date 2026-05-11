Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62CD0CD37B9
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 12:22:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9F536B00C8; Mon, 11 May 2026 08:22:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C76A46B00CA; Mon, 11 May 2026 08:22:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8CCA6B00CB; Mon, 11 May 2026 08:22:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A78D96B00C8
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:22:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4D30B1C05D6
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:22:37 +0000 (UTC)
X-FDA: 84755052354.24.0309207
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6245B180005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:22:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DmpuWN7u;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778502155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mnd9gwvyRXwmE2qLowSxqIaA64S47ubc4nBaZPf34yM=;
	b=wSS/vfXlSklRzDUR+prCBWN4BH9XC5bTcwIxn357PVG76XOLyGK9tZDMm3Dwwf6rcp6XyK
	k4Zp/Qy6XCnqqB7tJAKiZwqYqO6htywLRp8M5i+tmaEPKX6xfyvnSVupg9XBXm8Qv9S4xM
	OepLwA+KoI2IoyWiVoqTzajRi/tCQx0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DmpuWN7u;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778502155; a=rsa-sha256;
	cv=none;
	b=mdR+hxUNBqVioTOPzNwv36Cs02jZSMHFF2F5KlQlgG0YJoJSgQvNtYkQAc5NGYNEC3PqJj
	v5VU3xulFUK1F+LvGcxL+PtPpXsKcu4Jwod7gqWc4Snzwl2/t7+YAi5GjKZlTRBRrdIQrk
	wxkD4Fjdwe2FJ+W/QorJRboh6NO2Sew=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 329D144339;
	Mon, 11 May 2026 12:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9B0C2BCB0;
	Mon, 11 May 2026 12:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778502154;
	bh=2rnwGRjBmZwkmLDXWbAeEC18DQrH8JRTazD+yQeB2OQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DmpuWN7u/aNBrVr6S4NCkSG90RyEDQAwy7lT0bv9sOkf4cV9XeoheC1A+79QFzc77
	 2g7hKN8WPGTp1DiUYRMLZJ038Z+LDME0/WD0UKJv9UXsKa/GZ+TVjIAB+SDrElauVB
	 HED6EoEQjsgmKHoQIRxXQaOnzwQvWJIbgJPIpJ9jv1Kj4+8NLmgiswpBngzzgFIgcq
	 OLERCeDC3g2q0BNmFYtvjbpUtiziHBsc2tgUuOjRrbvQgl9n6EJAcywhaaeeBHVuQK
	 aE2qXLF/yKnZQC1yR375kwEolGQq8uzvLq/uMJzP1bQYrz3z8kGnWPx1H4d/QGHYAE
	 dHKRtKsmaCJIw==
Message-ID: <2841f424-580c-48c6-bb26-de30e4397b7f@kernel.org>
Date: Mon, 11 May 2026 14:22:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drivers/base/memory: make memory block get/put explicit
To: Muchun Song <songmuchun@bytedance.com>, Oscar Salvador
 <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, linux-mm@kvack.org,
 driver-core@lists.linux.dev, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
 muchun.song@linux.dev
References: <20260511111800.2181785-1-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260511111800.2181785-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6245B180005
X-Rspam-User: 
X-Stat-Signature: 9qjbrxei6zk9ur81cce4yh4phioft3tr
X-HE-Tag: 1778502155-798742
X-HE-Meta: U2FsdGVkX18smyQRURAYFuiYBw24JPeyBSbz8SqqVuGI+TRKC20UYxCH2b3LIXoh38WOAuaiZ4iQolEPY8SOfd8XwQh+9LOnd1OGq7w+hduoQF/3myUYZ7WpNoxZZqdnYxzTjmGwgFwGAOrHx+A5qzky65yrLCr3wH5O40Z4CTjfQEroEctv+Tdg5xEMQc78Gjb7JosrqDjT8OQGTanTx0+ro7swnsQp03P4seV+jhwNFNx5geIqoiBmALV2EpqPvotIyGhvvBDa2HEKWy05HvgHc+WzZKE1WwLWaPeIsKxKZjrMGxhoZvocy3BPZpdWECSYls9gRGBZeXZ5c6JFWA/inxgT8x0oM7vZm3AnubUFCN6dQcZVDMnZg+s5V7WFIY6xXdCSCUzLLXcEwZOYrntUJ4ZT2QTENLds4VwLXLfa84oyKNw2kyBQtE0ojHdE/8zHUkHF+SApl7+2lPtxAtqmcZNtnQDqtlwfwpHp+3QYVtulL+LjW4aY8C0T5vOhFn0OtkgIOp6hN3k8zYHjrJkuwpGI7OQ6uEG62jDNGDLwDBOWFk/aJkSewpbTX8q28jeVdzcrBRS9TTQhbl6PYDRcQn68F9ps+cxpmeYfoIFLIN7LAl2ov3dSt/3AOAiTh/deTPwfcCpZaZgFipG0mVU2FKt98UFx1lWc9xKYghjA/Rk+FeRRdHYsWg46Ya7gec6K7njkQcuYOR3Hp5x0DVnKomZEjki8Z+TP5Q1s4LEHRLoglxGRxODsv/m5T+DtsbMsn9QwNIODNq6L91wIl8SHGvn28L2pidOfDLKLaunl94ZRIfjd3fb0rF0FakBOOFvFwo729Kc/RqV1rY05F0PU7+WXdNsIvfvqEkOn1us3lLBPnwqTcj8ztGnFYJFvkcBcaPDQbvMqamY47a78vvJ1eu7eXxrd19151I9x0gpOqBiQI2y6UQ7qhbUSUcJQC4xUUDeEvf6fCtO//ZV
 /Sz+/bXB
 3qOijgz/ql79B6A3va7fjHtq30j8jdDsj7JTm63K4KMEDhTsASSKMuLpyegqtYLl4r5p4bNfSWDc41bIZKSJPWv6n9xLfuN4fxwhnz4OrWP+xVXTNOCTkbG2lce4wFyz5YaZEkCGOVDpH+UOXXcO0/cMaqa1bpCBFf0vKySU9ihqHkbEa4m1P4Mvlnx4Qew3lKyTw4ZN5Ry4nJrZaeniUZv1UbTN5fAo5/VOSMNoamnDMzdJaKWC5TfF+pd6rHZjWxignh0I+FYzZ1I9vKDIXrvKum2sN+McbZDQr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/11/26 13:18, Muchun Song wrote:
> Rename the memory block lookup helper to make the acquired reference
> explicit, add memory_block_put() to wrap put_device(), and collapse the
> redundant section-number wrapper into a single block-id based lookup
> interface.
> 
> This makes it clearer to callers that a successful lookup holds a
> reference that must be dropped, reducing the chance of forgetting the
> matching put and leaking the memory block device reference.

Better mention some of the other changes here, like removing find_memory_block().

[...]

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

While at it, please drop the "extern".

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

Would guards come in handy here?

In general

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

