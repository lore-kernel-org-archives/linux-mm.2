Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8709CD6E49
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 12:47:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E39E86B0005; Sat, 30 May 2026 08:47:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEA836B0088; Sat, 30 May 2026 08:47:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D00AC6B008A; Sat, 30 May 2026 08:47:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDE016B0005
	for <linux-mm@kvack.org>; Sat, 30 May 2026 08:47:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 47DE78D4AC
	for <linux-mm@kvack.org>; Sat, 30 May 2026 12:47:50 +0000 (UTC)
X-FDA: 84824063100.21.80E139D
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6A5661A0009
	for <linux-mm@kvack.org>; Sat, 30 May 2026 12:47:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P9W6pgiK;
	spf=pass (imf19.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780145268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jmZFGHkVt7mHbF9yyH37d9KR7diDdRIzuk7kL6ilGk4=;
	b=sJsd8B76xbHg+b5tZK1C4k0t6L3W3yWXN/ch3htPu+H2CpSc9dl3qxDXAsueEqDQSnVNQJ
	xmRkfu3XAfRo3UAefi7ZR97D8X7ZX58uRm8YnmrZmMgWAdvdZo3vqQ60aLGNBp5eG7inZk
	5M7dBikdq/JJyh65sYu7Pcf5iJ+z0Gs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P9W6pgiK;
	spf=pass (imf19.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780145268; a=rsa-sha256;
	cv=none;
	b=E4m7OacQHf7ooDuUY1DjM036RLomApe54StG/IUf4gv+FUsfbr+nMo53pnMPqS6P6tr+8A
	6ltkZlWV11xf1zeZD+2EkqiozKl2Sl5MAz/lvoGk7aAZHvmPkNmVd6XIZetYmMQNioStEo
	ZyYAWD1SfxrbnC+oKulr5WMB1QHrdCY=
Message-ID: <5a4aa532-77a0-436a-8f5e-1bbcf2db6bbb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780145266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jmZFGHkVt7mHbF9yyH37d9KR7diDdRIzuk7kL6ilGk4=;
	b=P9W6pgiKwLOp8+0KQOHYH1oVVL3TXmsWfyo95cRaDd9TWVeBVvSZdcxAQtXHg6AKFHPx8t
	GwxVVuJhM+aEhM0mgVIFDJzF+b3TeyMEG8be2fVbmZsM+n3vKeQcgyJUJzfhZD/CaF6gX/
	QSJwp2O3k7pc7kz6cKMfBxRYvoKa6ps=
Date: Sat, 30 May 2026 20:47:34 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] mm/percpu: Preserve NOFS/NOIO scope during chunk
 create and populate
To: Pedro Falcato <pfalcato@suse.de>, akpm@linux-foundation.org
Cc: dennis@kernel.org, tj@kernel.org, cl@gentwo.org, mhocko@suse.com,
 vbabka@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 muchun.song@linux.dev, Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260528132917.81123-1-kaitao.cheng@linux.dev>
 <20260528132917.81123-2-kaitao.cheng@linux.dev>
 <ahlameE6FBEZj_gt@pedro-suse.lan> <ahld5va1b9w8j659@pedro-suse.lan>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <ahld5va1b9w8j659@pedro-suse.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: sfx946izh7d3whwudn5hzzje4g4mu3rb
X-Rspamd-Queue-Id: 6A5661A0009
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780145268-260463
X-HE-Meta: U2FsdGVkX1/x9JBO+krl6bP4Sbz0AHXVyGcmFpcInd683ylFYesMOxzI0eXn170+WpgFj14w/EKeWurrDPAyUW/cGKVhjDjS7HLIzAJW43r7m62+PHLOdQXkmzXZhHQtcethPCu3wknVuoedghFofFf99Y2GxuwApq1ZLVyfkL+IoeHmz+ek++/wY5QPpIxkwxbMNOaW2KmOuwn8znJ0UNovqQGGv9RglvKbAS65zhR8/RiJlOFTmSNWrz9+2DuQQ1MwBsrj2+zzKp1yKIqLvb9mHhkcsFPiEbtVRfLx7+RHcImushLDK6WpukXBlj6+oLgywQ9SRqCds9PwWjW6bxrWEXDSS7qDFNpG0qEAgQp2qa9ZoeV2MZfKLyfG7w+vGYK194uTvdgfc95gTCrlJ4Wm4LvCMw8ZIv6uCXck6vxIjRLyFushqwQuHTrEbVuMHaWbB2632P/W2sHvwPMkMz2vK107oUD/UjHQhHhqJYoxMSXvMC723vTEIiCDfVqbfWtxklsKAevYlQVjEpvqWBVnFzbvWwK0Zcqc3KM/vhPd6jkASJXCFclkNO/bSZXLyr8rF1VjHL7aR2EmiZMNC0q/cKgAdvVO1hIzgKQW7hAJqiURB7Hs3/jx7NGAU4ROb0DQfeOC1s+7gCt+eGEfeUw3+/9ikCk5kXoraXMKsgPUFPwgzB/5p4nw76a9ONV9BGdxeemU/iNAJp9iV17CVQs8GFPNYpcxD0BHfv2JhxliqbThimLwrioUspInFmYcu+cyvQkrucEb3/7wtyqvYRkPUyQFmhChQXeeFOh1gdCBUdh5SpTRntHOBc/FAyc0rS63fiHDXw9lIQOSN9YuOFmW0YK/rFSGHSJ1UCuZiS84JCDSrQLvysZmzzVFh2WwvWS/b6/18pNaQac7QX7RK4/sm7TBR2bav7b1Pf47e84p2THTmd1faSrCAEeJKCmfBFWHcQVpxwXbXoZhsXY
 UtkTMtoP
 4WAHHL7nFLVR5EgUBh55IVHMHejAvExEv3vVTT1PTXLmNKjsX2o2hVKK/Q0+Mru8ySR/2th2cXvyRTB8TmDOb2YtvnsubjVjoVURCZujIkj5MHJg7K+oZ1BqJ5PFWA5AIBV6pGjbxba8MvPVCDeYNivPXCmpRZMEkfqFqChnzfJtXT2p5+Kf897wKPCjeP9L654yOF9A4atH2nooxRD0WINiVHFNTfRUxk/NgxC86HpR2aD4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2026/5/29 17:38, Pedro Falcato 写道:
> On Fri, May 29, 2026 at 10:25:28AM +0100, Pedro Falcato wrote:
>> On Thu, May 28, 2026 at 09:29:16PM +0800, Kaitao Cheng wrote:
>>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>>
>>> pcpu_alloc_noprof() derives pcpu_gfp from the caller supplied GFP mask and
>>> passes it to the backing percpu allocators. This preserves GFP_NOFS and
>>> GFP_NOIO for pcpu_alloc_pages() and for the initial pcpu_chunk allocation.
>>>
>>> However, the chunk creation and population slow paths also call helpers
>>> which do not take a GFP mask and perform internal allocations with
>>> GFP_KERNEL. For example, pcpu_create_chunk() calls pcpu_get_vm_areas(),
>>> and population can allocate temporary metadata or page tables while mapping
>>> backing pages. As a result, a caller which explicitly uses GFP_NOFS or
>>> GFP_NOIO can still enter FS or IO reclaim while creating or populating a
>>> percpu chunk.
>>>
>>> This is problematic for callers which use GFP_NOFS or GFP_NOIO because
>>> they are already holding filesystem or IO-path locks. If free chunks are
>>> exhausted, the percpu allocation can take pcpu_alloc_mutex and then enter
>>> unconstrained reclaim from these internal allocations, defeating the
>>> caller's allocation context and potentially recreating reclaim lock
>>> dependencies.
>>>
>>> Wrap chunk creation and population in a scoped NOIO or NOFS context when
>>> pcpu_gfp has the corresponding constraints. Leave ordinary GFP_KERNEL
>>> allocations unchanged so they retain full reclaim capability.
>>>
>>> Fixes: 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations atomic")
>>
>> I assume you _did not_ observe this in production? As in no reclaim path should be
>> insane^W daring enough to do pcpu allocations?
> 
> Oops, I mixed my issues up. This is purely a GFP flags issue. A quick
> "git grep alloc_percpu_gfp" shows that the vast majority (all?) callers are
> using some combination of GFP_KERNEL or GFP_ATOMIC + other GFP flags, but no
> NOFS or NOIO as far as I can see. So you probably did not observe this?

Right, this issue has not been observed in production. It came from a
question raised by AI code review, and after carefully reading the code,
I found that there are indeed some synchronization concerns.

Here is one example of the scenario [PATCH 1/2] is trying to address:

blk-cgroup after 5d726c4dbeed ("blk-cgroup: fix possible deadlock while
configuring policy"). blkg_conf_prep() now serializes against
blkcg_deactivate_policy() with q->blkcg_mutex, and blkg_alloc() was
changed to GFP_NOIO for that reason:

  CPU0: blkg_conf_prep()
    mutex_lock(q->blkcg_mutex)
    blkg_alloc(..., GFP_NOIO)
      alloc_percpu_gfp(..., GFP_NOIO)
        -> if percpu chunks are exhausted, chunk create/populate may do
           internal GFP_KERNEL allocations
        -> direct reclaim / writeback can issue IO to this queue
        -> IO waits because the queue is frozen

  CPU1: blkcg_deactivate_policy()
    blk_mq_freeze_queue(q)
    mutex_lock(q->blkcg_mutex)
      -> waits for CPU0
    ... unfreeze only happens after q->blkcg_mutex is acquired/released

So the concern is that the caller deliberately uses GFP_NOIO because it
may hold a lock which can be acquired after queue freeze, but the percpu
slow path can temporarily lose that allocation context. The failure
requires the slow path (new chunk creation or population), so it is not
expected to be common.

>>> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
>>> ---
>>>  mm/percpu.c | 26 ++++++++++++++++++++++++++
>>>  1 file changed, 26 insertions(+)
>>>
>>> diff --git a/mm/percpu.c b/mm/percpu.c
>>> index 71a85d7245c7..1bb38467390b 100644
>>> --- a/mm/percpu.c
>>> +++ b/mm/percpu.c
>>> @@ -1778,6 +1778,23 @@ static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off, size_t s
>>>  }
>>>  #endif
>>>  
>>> +static unsigned int pcpu_memalloc_scope_save(gfp_t gfp)
>>> +{
>>> +	if (!(gfp & __GFP_IO))
>>> +		return memalloc_noio_save();
>>> +	if (!(gfp & __GFP_FS))
>>> +		return memalloc_nofs_save();
>>> +	return 0;
>>> +}
>>> +
>>> +static void pcpu_memalloc_scope_restore(gfp_t gfp, unsigned int flags)
>>> +{
>>> +	if (!(gfp & __GFP_IO))
>>> +		memalloc_noio_restore(flags);
>>> +	else if (!(gfp & __GFP_FS))
>>> +		memalloc_nofs_restore(flags);
>>> +}
>>
>> I disagree with this. We already have gfp flags, they're already passed to pcpu_create_chunk()
>> and pcpu_populate_chunk(). It's their job to respect the gfp flags and
>> Do The Right Thing(tm). Can you fix the problematic places? It seems like it's
>> mostly the vmalloc backend that's problematic.

I’ll try to do it.

Following your suggestion, including in [PATCH 2/2], I will also try a
different approach and fix the issue by reducing the scope of the
pcpu_alloc_mutex critical section.

>>>  /**
>>>   * pcpu_alloc - the percpu allocator
>>>   * @size: size of area to allocate in bytes
>>> @@ -1901,7 +1918,12 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
>>>  
>>>  	/* No space left.  Create a new chunk. */
>>>  	if (list_empty(&pcpu_chunk_lists[pcpu_free_slot])) {
>>> +		unsigned int pcpu_scope;
>>> +
>>> +		pcpu_scope = pcpu_memalloc_scope_save(pcpu_gfp);
>>>  		chunk = pcpu_create_chunk(pcpu_gfp);
>>> +		pcpu_memalloc_scope_restore(pcpu_gfp, pcpu_scope);
>>> +
>>>  		if (!chunk) {
>>>  			err = "failed to allocate new chunk";
>>>  			goto fail;
>>> @@ -1931,9 +1953,13 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
>>>  		page_end = PFN_UP(off + size);
>>>  
>>>  		for_each_clear_bitrange_from(rs, re, chunk->populated, page_end) {
>>> +			unsigned int pcpu_scope;
>>> +
>>>  			WARN_ON(chunk->immutable);
>>>  
>>> +			pcpu_scope = pcpu_memalloc_scope_save(pcpu_gfp);
>>>  			ret = pcpu_populate_chunk(chunk, rs, re, pcpu_gfp);
>>> +			pcpu_memalloc_scope_restore(pcpu_gfp, pcpu_scope);
>>>  
>>>  			spin_lock_irqsave(&pcpu_lock, flags);
>>>  			if (ret) {
>>> -- 
>>> 2.50.1 (Apple Git-155)
>>>
-- 
Thanks
Kaitao Cheng


