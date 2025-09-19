Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B00B0CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 07:02:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 035DF94000F; Fri, 19 Sep 2025 03:02:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2862940009; Fri, 19 Sep 2025 03:02:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC8F494000F; Fri, 19 Sep 2025 03:02:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C688C940009
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 03:02:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 95AD9BA350
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:02:27 +0000 (UTC)
X-FDA: 83905106334.28.6A22663
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id 80FD5A0017
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:02:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XLOdRlFl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=racs1IQX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XLOdRlFl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=racs1IQX;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758265345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X+OU5BBTnLHobJcybGck4Ar/gFBtlxoZWMJB7CVL0EI=;
	b=pQPtiIjTncJ1kgGb+dVgj31WVk2pJh1qG05uMPt2fkBrqtqKQ+ZI5TtfIlD2bsUp/9VAI8
	i422Y4caVO0j+ggqZh9e6pvXlxGplxOUQ12eYaBzS45cizCxUXScavPFLC+X7J/KKbPu5X
	nRdX08jbMn5cdt8gBRkvLJH0rbKDjAA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XLOdRlFl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=racs1IQX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XLOdRlFl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=racs1IQX;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758265345; a=rsa-sha256;
	cv=none;
	b=FxKhDWy4x7xIMtZgTQb05nyEu1OVKNI8Bz9Z7gn8QPtQ6Ri4rLbAb0AwmlN+h67ahUH3Rt
	5IuaW0QackALpCTkY3CNXrTGq9zuBUsl68WDnlOMNt1Mde/ARDd6Et3ImESQPmoZJe5bZj
	UQTAzNpLk5WHQTVKcLsMkIXpyahyR+k=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F33C51F7D8;
	Fri, 19 Sep 2025 07:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758265343; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=X+OU5BBTnLHobJcybGck4Ar/gFBtlxoZWMJB7CVL0EI=;
	b=XLOdRlFl683fRR/ac5pZgpBeqUvCuW92iSHrIhk2hnZo96bhw+Yh59knTnPrpsyXx1uyyg
	85iV9SYjiD9XMGtXJXIVxSrDKl1+k2QwX3I5sTRfXQ9z4SVUMtI58PZJIXVKXDSoid/1Ly
	0dlMJ1XOvFQeKtN6S+PoHZ7gMHg1m4g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758265343;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=X+OU5BBTnLHobJcybGck4Ar/gFBtlxoZWMJB7CVL0EI=;
	b=racs1IQXD7oVub/3XFUW5h2uDmlnc3DAwDRNKDZpNhRdTx6Y82HrUsnGeVAzwmLChKlKOf
	oK8a2QXRqUuNRMDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758265343; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=X+OU5BBTnLHobJcybGck4Ar/gFBtlxoZWMJB7CVL0EI=;
	b=XLOdRlFl683fRR/ac5pZgpBeqUvCuW92iSHrIhk2hnZo96bhw+Yh59knTnPrpsyXx1uyyg
	85iV9SYjiD9XMGtXJXIVxSrDKl1+k2QwX3I5sTRfXQ9z4SVUMtI58PZJIXVKXDSoid/1Ly
	0dlMJ1XOvFQeKtN6S+PoHZ7gMHg1m4g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758265343;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=X+OU5BBTnLHobJcybGck4Ar/gFBtlxoZWMJB7CVL0EI=;
	b=racs1IQXD7oVub/3XFUW5h2uDmlnc3DAwDRNKDZpNhRdTx6Y82HrUsnGeVAzwmLChKlKOf
	oK8a2QXRqUuNRMDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C4FC413A39;
	Fri, 19 Sep 2025 07:02:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NygcL/7/zGihBwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 19 Sep 2025 07:02:22 +0000
Message-ID: <a4ca0cf5-b7fa-48cb-abfb-1e1d016c30d0@suse.cz>
Date: Fri, 19 Sep 2025 09:02:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 04/23] slab: add sheaf support for batching kfree_rcu()
 operations
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Uladzislau Rezki <urezki@gmail.com>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org, "Paul E . McKenney" <paulmck@kernel.org>
References: <20250910-slub-percpu-caches-v8-4-ca3099d8352c@suse.cz>
 <aMpxnACqmsQl-lp0@hyeyoo> <bbda8c25-b575-4e98-b1ae-b103c6598d38@suse.cz>
 <aMqcXyKRlZggLxu_@hyeyoo> <6f92eca3-863e-4b77-b2df-dc2752c0ff4e@suse.cz>
 <aMqyn6nenR8V_p1y@hyeyoo> <bf8b4741-1025-4cc8-b9ed-5b566bdcb2d7@suse.cz>
 <aMq40h5iOjj8K7cc@hyeyoo> <a32bd837-2597-43d0-9da3-1ce5a53b15f4@suse.cz>
 <40461105-a344-444f-834b-9559b6644710@suse.cz> <aMz8hk3lrWiPQYnw@harry>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aMz8hk3lrWiPQYnw@harry>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: g7yyeab1xgkf3majpjox8y4uxor6caio
X-Rspam-User: 
X-Rspamd-Queue-Id: 80FD5A0017
X-Rspamd-Server: rspam04
X-HE-Tag: 1758265344-284423
X-HE-Meta: U2FsdGVkX1/ezr4IdYilMCGd+nE5nOyJgCTb/6VW3UP0YmC0hqU9f6i7GYRfdotK4sxlNc5r7TYNUg/AGQA5yUGCNC1Tolv3kC8H3kWJVDVvu7AJC8l8qvKTFkKf0WVAVEq+PpwvGTuaZejw+3JeCbxIsru2Bzf3KKs0rSTV6Uw+MgoBBDmSiDjvmBza506xnnhRpxPcBXAJmzeCBGrfcXXFuAQZw0txXFAo74cvtzJ4IVXHgaAOffyWUaGGj7eaj+EQNBZVs3d76So5evXXwlU+gEccArTeWd/w62rQgNvXjtsLkI5HnKzzVqfr8ki0+UUfFwwRKD9dHzmqkY3KXfSnGQbZRTdIxtXc+oyJIFVQ1+c3K8sLGgOloxtXwpKbr8gVap1DfgXS8Si/uHg1QquRCo1tgK5pC97ntHM5DNLH06LWuX5DYAAb7YNDjn5m4IE1zf/u38N7sI2ClKBjw6HjPa4Zsbd/Z1WM1nQLT7rhxS7lcv3hM2pjULwoVB1AZfp4QPklHtZbqkeJtcQ6vb2Lt9yjWNC+qSK75FFxywxm95Hvi8RSM+sGeFI38BjG+75oituSW3BVdDr9bilO5su+j+qyVpd1uVPVER4tQrYnastO6ZNyOaaQurEZuLhwpGxc/KVB+y1DuqGxqhWle/r9zF4KuPmhM4f87CR00tq6OAQTftiM9ciNA4ZjP4nXExVZDTBdr3QcY3gwVPPrDI/ulhTlvMAQIxQfx8abo4NQ3fU9VS3FTKe0lqM7X5Z/qxUFLSVT0CxKAHsbRSDpnvLOSN2N2gSnYUy09Ftpd+/fWZGN58gNZc+jTk8PLuaUATeeI6eIOB4YGjLl3qxvYj8RQXVXyuPL0+6LPuTSwiaj89ZXJm6x+qpAXfNeJ7j3WcyniAKIHRbgDjY+yTpiLS0iUOXKhYf4vQ9faG2jCeI5RJS+g4KbY7ar/AcT/vISEK30B9dzfgGIOlRBFn/
 EfxfPpil
 xKE18V7x1KfMd4YY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/19/25 08:47, Harry Yoo wrote:
> On Thu, Sep 18, 2025 at 10:09:34AM +0200, Vlastimil Babka wrote:
>> On 9/17/25 16:14, Vlastimil Babka wrote:
>> > On 9/17/25 15:34, Harry Yoo wrote:
>> >> On Wed, Sep 17, 2025 at 03:21:31PM +0200, Vlastimil Babka wrote:
>> >>> On 9/17/25 15:07, Harry Yoo wrote:
>> >>> > On Wed, Sep 17, 2025 at 02:05:49PM +0200, Vlastimil Babka wrote:
>> >>> >> On 9/17/25 13:32, Harry Yoo wrote:
>> >>> >> > On Wed, Sep 17, 2025 at 11:55:10AM +0200, Vlastimil Babka wrote:
>> >>> >> >> On 9/17/25 10:30, Harry Yoo wrote:
>> >>> >> >> > On Wed, Sep 10, 2025 at 10:01:06AM +0200, Vlastimil Babka wrote:
>> >>> >> >> >> +				sfw->skip = true;
>> >>> >> >> >> +				continue;
>> >>> >> >> >> +			}
>> >>> >> >> >>
>> >>> >> >> >> +			INIT_WORK(&sfw->work, flush_rcu_sheaf);
>> >>> >> >> >> +			sfw->skip = false;
>> >>> >> >> >> +			sfw->s = s;
>> >>> >> >> >> +			queue_work_on(cpu, flushwq, &sfw->work);
>> >>> >> >> >> +			flushed = true;
>> >>> >> >> >> +		}
>> >>> >> >> >> +
>> >>> >> >> >> +		for_each_online_cpu(cpu) {
>> >>> >> >> >> +			sfw = &per_cpu(slub_flush, cpu);
>> >>> >> >> >> +			if (sfw->skip)
>> >>> >> >> >> +				continue;
>> >>> >> >> >> +			flush_work(&sfw->work);
>> >>> >> >> >> +		}
>> >>> >> >> >> +
>> >>> >> >> >> +		mutex_unlock(&flush_lock);
>> >>> >> >> >> +	}
>> >>> >> >> >> +
>> >>> >> >> >> +	mutex_unlock(&slab_mutex);
>> >>> >> >> >> +	cpus_read_unlock();
>> >>> >> >> >> +
>> >>> >> >> >> +	if (flushed)
>> >>> >> >> >> +		rcu_barrier();
>> >>> >> >> > 
>> >>> >> >> > I think we need to call rcu_barrier() even if flushed == false?
>> >>> >> >> > 
>> >>> >> >> > Maybe a kvfree_rcu()'d object was already waiting for the rcu callback to
>> >>> >> >> > be processed before flush_all_rcu_sheaves() is called, and
>> >>> >> >> > in flush_all_rcu_sheaves() we skipped all (cache, cpu) pairs,
>> >>> >> >> > so flushed == false but the rcu callback isn't processed yet
>> >>> >> >> > by the end of the function?
>> >>> >> >> > 
>> >>> >> >> > That sounds like a very unlikely to happen in a realistic scenario,
>> >>> >> >> > but still possible...
>> >>> >> >> 
>> >>> >> >> Yes also good point, will flush unconditionally.
>> >>> >> >> 
>> >>> >> >> Maybe in __kfree_rcu_sheaf() I should also move the call_rcu(...) before
>> >>> >> >> local_unlock().
>> >>> >> >>
>> >>> >> >> So we don't end up seeing a NULL pcs->rcu_free in
>> >>> >> >> flush_all_rcu_sheaves() because __kfree_rcu_sheaf() already set it to NULL,
>> >>> >> >> but didn't yet do the call_rcu() as it got preempted after local_unlock().
>> >>> >> > 
>> >>> >> > Makes sense to me.
>> >>> > 
>> >>> > Wait, I'm confused.
>> >>> > 
>> >>> > I think the caller of kvfree_rcu_barrier() should make sure that it's invoked
>> >>> > only after a kvfree_rcu(X, rhs) call has returned, if the caller expects
>> >>> > the object X to be freed before kvfree_rcu_barrier() returns?
>> >>> 
>> >>> Hmm, the caller of kvfree_rcu(X, rhs) might have returned without filling up
>> >>> the rcu_sheaf fully and thus without submitting it to call_rcu(), then
>> >>> migrated to another cpu. Then it calls kvfree_rcu_barrier() while another
>> >>> unrelated kvfree_rcu(X, rhs) call on the previous cpu is for the same
>> >>> kmem_cache (kvfree_rcu_barrier() is not only for cache destruction), fills
>> >>> up the rcu_sheaf fully and is about to call_rcu() on it. And since that
>> >>> sheaf also contains the object X, we should make sure that is flushed.
>> >> 
>> >> I was going to say "but we queue and wait for the flushing work to
>> >> complete, so the sheaf containing object X should be flushed?"
>> >> 
>> >> But nah, that's true only if we see pcs->rcu_free != NULL in
>> >> flush_all_rcu_sheaves().
>> >> 
>> >> You are right...
>> >> 
>> >> Hmm, maybe it's simpler to fix this by never skipping queueing the work
>> >> even when pcs->rcu_sheaf == NULL?
>> > 
>> > I guess it's simpler, yeah.
>> 
>> So what about this? The unconditional queueing should cover all races with
>> __kfree_rcu_sheaf() so there's just unconditional rcu_barrier() in the end.
>> 
>> From 0722b29fa1625b31c05d659d1d988ec882247b38 Mon Sep 17 00:00:00 2001
>> From: Vlastimil Babka <vbabka@suse.cz>
>> Date: Wed, 3 Sep 2025 14:59:46 +0200
>> Subject: [PATCH] slab: add sheaf support for batching kfree_rcu() operations
>> 
>> Extend the sheaf infrastructure for more efficient kfree_rcu() handling.
>> For caches with sheaves, on each cpu maintain a rcu_free sheaf in
>> addition to main and spare sheaves.
>> 
>> kfree_rcu() operations will try to put objects on this sheaf. Once full,
>> the sheaf is detached and submitted to call_rcu() with a handler that
>> will try to put it in the barn, or flush to slab pages using bulk free,
>> when the barn is full. Then a new empty sheaf must be obtained to put
>> more objects there.
>> 
>> It's possible that no free sheaves are available to use for a new
>> rcu_free sheaf, and the allocation in kfree_rcu() context can only use
>> GFP_NOWAIT and thus may fail. In that case, fall back to the existing
>> kfree_rcu() implementation.
>> 
>> Expected advantages:
>> - batching the kfree_rcu() operations, that could eventually replace the
>>   existing batching
>> - sheaves can be reused for allocations via barn instead of being
>>   flushed to slabs, which is more efficient
>>   - this includes cases where only some cpus are allowed to process rcu
>>     callbacks (Android)
>> 
>> Possible disadvantage:
>> - objects might be waiting for more than their grace period (it is
>>   determined by the last object freed into the sheaf), increasing memory
>>   usage - but the existing batching does that too.
>> 
>> Only implement this for CONFIG_KVFREE_RCU_BATCHED as the tiny
>> implementation favors smaller memory footprint over performance.
>> 
>> Also for now skip the usage of rcu sheaf for CONFIG_PREEMPT_RT as the
>> contexts where kfree_rcu() is called might not be compatible with taking
>> a barn spinlock or a GFP_NOWAIT allocation of a new sheaf taking a
>> spinlock - the current kfree_rcu() implementation avoids doing that.
>> 
>> Teach kvfree_rcu_barrier() to flush all rcu_free sheaves from all caches
>> that have them. This is not a cheap operation, but the barrier usage is
>> rare - currently kmem_cache_destroy() or on module unload.
>> 
>> Add CONFIG_SLUB_STATS counters free_rcu_sheaf and free_rcu_sheaf_fail to
>> count how many kfree_rcu() used the rcu_free sheaf successfully and how
>> many had to fall back to the existing implementation.
>> 
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
> 
> Looks good to me,
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Thanks.

>> +do_free:
>> +
>> +	rcu_sheaf = pcs->rcu_free;
>> +
>> +	rcu_sheaf->objects[rcu_sheaf->size++] = obj;
>> +
>> +	if (likely(rcu_sheaf->size < s->sheaf_capacity))
>> +		rcu_sheaf = NULL;
>> +	else
>> +		pcs->rcu_free = NULL;
>> +
>> +	/*
>> +	 * we flush before local_unlock to make sure a racing
>> +	 * flush_all_rcu_sheaves() doesn't miss this sheaf
>> +	 */
>> +	if (rcu_sheaf)
>> +		call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);
> 
> nit: now we don't have to put this inside local_lock()~local_unlock()?

I think we still need to? AFAICS I wrote before is still true:

The caller of kvfree_rcu(X, rhs) might have returned without filling up
the rcu_sheaf fully and thus without submitting it to call_rcu(), then
migrated to another cpu. Then it calls kvfree_rcu_barrier() while another
unrelated kvfree_rcu(X, rhs) call on the previous cpu is for the same
kmem_cache (kvfree_rcu_barrier() is not only for cache destruction), fills
up the rcu_sheaf fully and is about to call_rcu() on it.

If it can local_unlock() before doing the call_rcu(), it can local_unlock(),
get preempted, and our flush worqueue handler will only see there's no
rcu_free sheaf and do nothing.

If if must call_rcu() before local_unlock(), our flush workqueue handler
will not execute on the cpu until it performs the call_rcu() and
local_unlock(), because it can't preempt that section (!RT) or will have to
wait doing local_lock() in flush_rcu_sheaf() (RT) - here it's important it
takes the lock unconditionally.

Or am I missing something?

