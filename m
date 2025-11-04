Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CEF8CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 12:32:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B050C8E0136; Tue,  4 Nov 2025 07:32:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADCCD8E0124; Tue,  4 Nov 2025 07:32:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F1538E0136; Tue,  4 Nov 2025 07:32:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0738E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 07:32:57 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 264CD14051A
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 12:32:57 +0000 (UTC)
X-FDA: 84072863994.10.B7EFCAF
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id A9FAE1C000A
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 12:32:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gv+In90P;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="ejgqz/Yb";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LLruRLug;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="4tGc/rwf";
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762259575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RIo9l74GvvTaRZ+U5ebxRlVOQ/URHlMRH+W7jHX07Lg=;
	b=KWYV3mptpBzN+hA1qZaHjpR5H4Vo0L3OP2HRYv03QsuqKDEBLR3LbiKHfiiwxwXGr0QFTq
	V7nttASAzzQ4Hv/L7qJSMRLU7AWWa1du991+6dF+rMEHQfILfomc99ngZ+aKoCFhTpXypy
	gy45UqkMUWYHcRwB0HJhKVyGYJaX9Uc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762259575; a=rsa-sha256;
	cv=none;
	b=H8Ec2WjFO90ng4T2437B/aW1c/DHFUXYKU113r6F1iQP46OlJRL6Fuc8sXKB7wqt26ZfGo
	zkj9SzGFDamCaPB2gptyVhTQ07BM0MGicR94B7KQdSJuBzUYTENUC2TxJ4kmjPP8zHxhXT
	U4X/EgYVF3HwkFOABZJ3uGWDWNdHcH4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gv+In90P;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="ejgqz/Yb";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LLruRLug;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="4tGc/rwf";
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CD9412118C;
	Tue,  4 Nov 2025 12:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762259573; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RIo9l74GvvTaRZ+U5ebxRlVOQ/URHlMRH+W7jHX07Lg=;
	b=gv+In90P6mA9CiNxCt/K+Cf29ysMeQ7F7LQMHBw7zoZRhhKNBcwwZqhkL9tbQWSftUWBrL
	i2nrccCaa12HFb6xdSk3zz8f59y8g5P8EZJJrrFv/GkBft68in3jRm+mUheVrx1AwJQRBS
	kgO7Osp5gCtUacUJsSDMkkOvEX7CPC8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762259573;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RIo9l74GvvTaRZ+U5ebxRlVOQ/URHlMRH+W7jHX07Lg=;
	b=ejgqz/YbwiggzdFQ0ROAqSEx41Lipm8mjHu/NQNO8AX7tQQmHFE5LEEDvMLc4Hnu4216dK
	CredYQAcqPimOhCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762259572; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RIo9l74GvvTaRZ+U5ebxRlVOQ/URHlMRH+W7jHX07Lg=;
	b=LLruRLug2kCyDdW70Nwphxzlf4tgGDbei02zXkDbiPKel+mfZy+eLdFlg/Y17K0Z+5UCug
	buHr+ZtCz/DX56y4b9Zk/YJmbB5oeJ0AaoEQVL1LC4yCoUcZ5KMTWTtHS4oLEeE3vLZ/5O
	+RjQrq3BTIBUim7jpM7oKL7g7l6HHK0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762259572;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RIo9l74GvvTaRZ+U5ebxRlVOQ/URHlMRH+W7jHX07Lg=;
	b=4tGc/rwfCjlmdVp/xlnlV1YU5eYvUYmU9MMrM5V9UcsIMucGG+PIeNd3jdeyLvHJzYDtD3
	x97bLXNVfy6VTtBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B60B5136D1;
	Tue,  4 Nov 2025 12:32:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RG9ELHTyCWmVVgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 04 Nov 2025 12:32:52 +0000
Message-ID: <a0015508-e72b-4b1c-9993-7e66076a0a19@suse.cz>
Date: Tue, 4 Nov 2025 13:32:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] mm: allow __GFP_NOFAIL allocation up to
 BLK_MAX_BLOCK_SIZE to support LBS
To: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, libaokun@huaweicloud.com,
 linux-mm@kvack.org, akpm@linux-foundation.org, surenb@google.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, jack@suse.cz,
 yi.zhang@huawei.com, yangerkun@huawei.com, libaokun1@huawei.com
References: <1ab71a9d-dc28-4fa0-8151-6e322728beae@suse.cz>
 <aQTHMI3t5mNXp0M1@casper.infradead.org>
 <fwm7tynepbnpq3db7u2fqrzmeq55gs5472r7wbggxmndap3k26@ngwgdcy26vxx>
 <qfo7raavlfupjqwbgl2mnmfvmn3z5oslnxcehorib3xjdgf4yo@bp76xmxplre7>
 <aQTb0NdyN3tU50ss@casper.infradead.org>
 <k6k5azen4otnvlc35hj5ak7dmz2gxbb4lrgdu7cirewotggnp2@55cywarovlvs>
 <aQTqELGGKCN3JTIm@casper.infradead.org> <aQhf5LJJMlvT-rrE@tiehlicka>
 <9d5790f0-4a07-4cca-9f94-de101084a7e6@suse.cz> <aQh1EmVd8IPHK0Gh@tiehlicka>
 <aQnV73KorhS0AWH5@tiehlicka>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <aQnV73KorhS0AWH5@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: 7r64ugcykrapmq6spddhnhdnowksjqme
X-Rspam-User: 
X-Rspamd-Queue-Id: A9FAE1C000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1762259574-648132
X-HE-Meta: U2FsdGVkX1/3Tl33MVA/nkEdtWCwrt38+tCcAX2Scjx/01M/wT0b2K1QDH3WEsPxfd4Sl8czSSbbIL2RDr2EmQahFr+EEe4jq0U2mz5Yffgd4ewPy9+pBVnxK+FLZj3MR5yfIQEPUfLLwNSdydGepo1QV7c7VetmeyLifOfIVQNnXr0z3eX9dg634x3ghx8oUeaT2mblvk9mj7Sg/bf+0Rju9YEQMEypc81knRlIjl+uXrBGLTeQRb3UmEHMBXTl7S393uueYfRH0q/E61gbJku1c2aYoWu1Do6pwkFobWs5o5hoDHQQAXfh3VvE+dAdE+UeGhW9H5s/apTzJB6mddaAiTj071gntJjYPOunT4CgbUnGfyvXzoQFJ/3B70+x/hDnJAaE0/9upe3hSp8aK9KrB0HbzV+mt7+/7rh7Ux+JIBWDujLu8QsgE8Xq7NIUJBv17+BapbFZawnD3U0tiSDFv4TgEHShDNKBAWbF2DFEhTWC+6n6TLyEDuP1GRbJCbrplXod5AUyg4SA55dALmFZ6CKd49fyKMNblPIyCtzrs3nsT3YeJDWPK+1h1ooGQsJAt/H/cZfHZCJVy1CQmi+GZlQtOHZ7vXr/PGMy2Xl5IuwzLAFYHZBQp342ARRNCclXBFBb9YkNFXeEwEBbNe8XCJCPkxsIUR2/5Sq/SIilmrTgtwb24dY3xyj7O0pqePzP1ejOoHjMCgOOtDqX3227QwLOt/Be7xNR+vKyG5PoLuSXKuGro/nolXsP+B6tKiw5oN/YRPZ6umFcpmSbD8J5nhlTKBOBUqu5DIZyDWBZnJBVWcKz+SDuRhe8l4t3h6Lg3jJomVwNgmz8vHKd/QWgMq5bKmgKl4trK5h8T6qzhopvkWsWtYaxZriqXezoGx7pImwkbveu4jgdkh/v37XhVf9SSr/IX+AyV6X43dNhwFEJhzhnu5RJEUl/ajVN+DbkDmpgbGtxYnr6lje
 ehj7Ay4k
 8x6+o01BttvTKDkWjI8o6PYgkvI8sRAPYKJvyn8UfItZ6RRug+SvxmF9es+LAwK0d9NO2aVJAIkBAassPUgXKeIoGHS+4l4tommn47go7R3FcOZgEpCGSb1KywJORQHafc21kalNUHNxnJ5JFis+JiDKSQEm/l+IBu1W00uhiDphlBQ8pmJ+85U9NPsvkC7kM/B5qS/KjcXNoH4K5SD6M3HkdqYOsPZsWstpvjrU8EUquqZZvDc5I6W9rns1y0B+VJmG/s7CR5BUkxfZOX/aI7IviGj7712d8Eg9Z2Bd0j/0eyK0OXDKipVOwjRVQVX1RWXZYul+xplr3VLM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/4/25 11:31 AM, Michal Hocko wrote:
> On Mon 03-11-25 10:25:40, Michal Hocko wrote:
>> On Mon 03-11-25 10:01:54, Vlastimil Babka wrote:
>>> Maybe we could keep the warning for >=PMD_ORDER as that would still mean
>>> someone made an error?
>>
>> I am not sure TBH. For those large requests (anything that is costly
>> order) it is essentially a loop around allocator inside the allocator.
>> I would be really much more worried about order-3 which still triggers
>> the oom killer and could kill half of the system without much progress.
>> For oder-2 you at least have task_struct which spans 2 pages but I do
>> not think we have any guaranteed order-3 page for each task to guarantee
>> anything when killing those.
> 
> Essentially something like this
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 25923cfec9c6..2df477d97cee 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -1142,6 +1142,14 @@ bool out_of_memory(struct oom_control *oc)
>  	if (!(oc->gfp_mask & __GFP_FS) && !is_memcg_oom(oc))
>  		return true;
>  
> +	/*
> +	 * unlike for other !costly requests killing a task is not
> +	 * really guaranteed to free any order-3 pages. Warn about
> +	 * that to see whether that happens often enough to special
> +	 * case.
> +	 */
> +	WARN_ON(oc->order == 3 && (oc->gfp_mask & __GFP_NOFAIL));

OK, it might not create an order-3 page immediately. But I'd expect it
allows compaction to make progress thanks to making more free memory
available? We do retry reclaim/compaction after OOM killing one process,
and don't just kill until we succeed allocating, right?

> +
>  	/*
>  	 * Check if there were limitations on the allocation (only relevant for
>  	 * NUMA and memcg) that may require different handling.
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d1d037f97c5f..ca8795156b14 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3993,6 +3993,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
>  	/* Coredumps can quickly deplete all memory reserves */
>  	if (current->flags & PF_DUMPCORE)
>  		goto out;
> +
>  	/* The OOM killer will not help higher order allocs */
>  	if (order > PAGE_ALLOC_COSTLY_ORDER)
>  		goto out;
> @@ -4612,11 +4613,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	int reserve_flags;
>  
>  	if (unlikely(nofail)) {
> -		/*
> -		 * We most definitely don't want callers attempting to
> -		 * allocate greater than order-1 page units with __GFP_NOFAIL.
> -		 */
> -		WARN_ON_ONCE(order > 1);
>  		/*
>  		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
>  		 * otherwise, we may result in lockup.


