Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6C45CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 14:14:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08F098E0008; Wed, 17 Sep 2025 10:14:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0667B8E0003; Wed, 17 Sep 2025 10:14:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E976E8E0008; Wed, 17 Sep 2025 10:14:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D9E978E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:14:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7636C11A792
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:14:41 +0000 (UTC)
X-FDA: 83898937962.19.DD4EB00
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0B8F7180003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:14:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FwJf5Wso;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uwCLR8Pj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FwJf5Wso;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uwCLR8Pj;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758118479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cTQTjSokaGDrNuQ/J4+a2gYgPaSNBVSDKzhuOd4ah1o=;
	b=icUJcnV/a6VLYl4WezpyTtNk1l7uknm1iBVFhCLnaUI2ey4Juy/nbt3rJqNZ3FuZ/qY5iW
	wEM+8v00Zt4gq9QQ+qBpRit3k4ZqEJ/d/uuoLW4DTsIv2Lmcm8LAPumfw2sXz6ADSqRWtB
	eaoP4bE7i6yqXHpWjZ1Ohqx+L7wdtcU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758118479; a=rsa-sha256;
	cv=none;
	b=7Eo35OGhyEYsbeq4KpYuDvon4+Fkwy0abE7xWIscVuXqfZv85803RJ1H8E0shBdCG2x080
	Dg3maQ94U/e1pwaJX47lYESnd+HwhLkqSHiBSZGC4v5NlSsfsUB2u/aE/GkTEZTY2iMSRD
	Xk+j8/MSC8KV/aY8mQJ0v8oz5cf7N2A=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FwJf5Wso;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uwCLR8Pj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FwJf5Wso;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uwCLR8Pj;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5F7A82037D;
	Wed, 17 Sep 2025 14:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758118477; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cTQTjSokaGDrNuQ/J4+a2gYgPaSNBVSDKzhuOd4ah1o=;
	b=FwJf5WsoDOmp0EYNZcXIepoUOp+cdkExwzRDCSZAPTwy78U6cLFTGZKuInxR/vo04JtAd6
	bhAd3oIyp29bW3VisWy2vElKL4SQAJ/EgHUjmRqiEnJlhCmvE+LYrsoQoloJURmxdmRG9s
	BPt0Wf5ZQGHkAtEO7AWugxgYgR0E2Qs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758118477;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cTQTjSokaGDrNuQ/J4+a2gYgPaSNBVSDKzhuOd4ah1o=;
	b=uwCLR8PjYkq7lLQWBRAjxmdb1vtLvWwZdcB7BY294t2H/E6dC9Gq8SrqN62AXMnfJw+p/r
	WKPoToDmlSfZNhAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758118477; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cTQTjSokaGDrNuQ/J4+a2gYgPaSNBVSDKzhuOd4ah1o=;
	b=FwJf5WsoDOmp0EYNZcXIepoUOp+cdkExwzRDCSZAPTwy78U6cLFTGZKuInxR/vo04JtAd6
	bhAd3oIyp29bW3VisWy2vElKL4SQAJ/EgHUjmRqiEnJlhCmvE+LYrsoQoloJURmxdmRG9s
	BPt0Wf5ZQGHkAtEO7AWugxgYgR0E2Qs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758118477;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cTQTjSokaGDrNuQ/J4+a2gYgPaSNBVSDKzhuOd4ah1o=;
	b=uwCLR8PjYkq7lLQWBRAjxmdb1vtLvWwZdcB7BY294t2H/E6dC9Gq8SrqN62AXMnfJw+p/r
	WKPoToDmlSfZNhAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4457D137C3;
	Wed, 17 Sep 2025 14:14:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kUpcEE3CymhOBQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 17 Sep 2025 14:14:37 +0000
Message-ID: <a32bd837-2597-43d0-9da3-1ce5a53b15f4@suse.cz>
Date: Wed, 17 Sep 2025 16:14:36 +0200
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
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-4-ca3099d8352c@suse.cz>
 <aMpxnACqmsQl-lp0@hyeyoo> <bbda8c25-b575-4e98-b1ae-b103c6598d38@suse.cz>
 <aMqcXyKRlZggLxu_@hyeyoo> <6f92eca3-863e-4b77-b2df-dc2752c0ff4e@suse.cz>
 <aMqyn6nenR8V_p1y@hyeyoo> <bf8b4741-1025-4cc8-b9ed-5b566bdcb2d7@suse.cz>
 <aMq40h5iOjj8K7cc@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aMq40h5iOjj8K7cc@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ukqk98b4spab61unmy5th1ogb5xdghsz
X-Rspamd-Queue-Id: 0B8F7180003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758118478-155135
X-HE-Meta: U2FsdGVkX1/40v30hzeYjA6pc/a3dWX53TNtjEdRQfDw0gXyRGQrt3i9Sac0O5OWhfnXpLhIGlV4JClUBiZLXGn+MFgOv94TUzksY7LY+9XQEy5d9f5r9Zy8GK5VnKF/aGf22nQQG+9HPzFA69o2w0wSVEcYekJIhBT2C1VpaId7EHHJBuiLvqTVlMF5s0Nvq5yV0ZyqCTs8ukjgVsRlVxM2o55bzXjZWZ2621FZ7txnmYUl4LBOBomjpMEPYR2uRjcqK5csC2qUlYuqFSssF5uNN1QBHNvP3Jlr9IFca5pkuRrGGVzhRrXo4808s+UFQBLKrOwhZwjZIwM6/TbWqFxnmeXLvW6034IKEKlB2MGD40ZZkWyvMvBfyYM/Tbv3Gnlz5OZtK862VWs/LzRyk/e0ShSQq5ebHuaFHk4ne0HRk5qPJn6IOHr5Mc4OjK7Qcuqg4CR4BvxXYiSefpXTlQHcGsBwTL5GvRCGYdOBCNcdpt0+kb/DhxJrgi0TFtQOmjhKk0pMiP+s40Aztv0zzd/DjFAK0paVVJysmSfH6dPhdICXY05h+3lUDh1sG2dptIIemUsqoQB5oKPYN0dllwE5knGg6bsdDIxTlX+cPJVqcOQ2MoJ7+5kPd2XXK/DjG9HgZDZ2mKgepzF9bEnF39CDw2w7Q38XjtN1qyn8py7vvogMeMrrdyvrmcUY+2vmV3yxmRStdQ1VviKM8xObxyL1epUH1VbiVxlYcnl6dIHO5MwMl5m/UCWqY6/1jl02LeWpCIvJaHX5UZvTQSX2MKEGD1JCGu0n3/O5NjQjhXcuGDPxGj5xAaagC+EFcbSGKaYc4RSPTdPAvaT3Qp89TL/5ME5Fg+RpL2IuCHfTU6Bzde/5krtfU+95NuZpMhltTWSJ9GE7TKK1dWIGJzsU+y+Vy8Jj7hOk8enkuvkPFmMNa2NuzClLwTwrCj62rc31i051la84HOihLIqTzSe
 8RNGf19w
 PC7zpr9MwUEhWmKAf1Q5unmsTfni5E0nF6nqi7i2zhMAxZkdmUYqnqnhphOjpBue62zofC+fAiYnrRa2SQ5lYGXEz9dbH4is1R1jaM9Abo+u66maNEveF/WbMzQPCcjUbT6vjq0rexSP4l8fFQNIM3h/7uNOukk9sTxugZHyhBzhGBmQhltDr3V0EBZQe/r7ytrEZQoozFGh86mQx7baxn5OXCzpp3zhxP/8GSDqkg5RU1/X5nlaO+UXrFZBo/V4VX0CNfG7t/yO7BLAnpqxYnHwwqVXH2pKG3vWicSAdOeSxoFr9TocEyZYvdQkQJvuGqygsTWqadU/gQLQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/25 15:34, Harry Yoo wrote:
> On Wed, Sep 17, 2025 at 03:21:31PM +0200, Vlastimil Babka wrote:
>> On 9/17/25 15:07, Harry Yoo wrote:
>> > On Wed, Sep 17, 2025 at 02:05:49PM +0200, Vlastimil Babka wrote:
>> >> On 9/17/25 13:32, Harry Yoo wrote:
>> >> > On Wed, Sep 17, 2025 at 11:55:10AM +0200, Vlastimil Babka wrote:
>> >> >> On 9/17/25 10:30, Harry Yoo wrote:
>> >> >> > On Wed, Sep 10, 2025 at 10:01:06AM +0200, Vlastimil Babka wrote:
>> >> >> >> +				sfw->skip = true;
>> >> >> >> +				continue;
>> >> >> >> +			}
>> >> >> >>
>> >> >> >> +			INIT_WORK(&sfw->work, flush_rcu_sheaf);
>> >> >> >> +			sfw->skip = false;
>> >> >> >> +			sfw->s = s;
>> >> >> >> +			queue_work_on(cpu, flushwq, &sfw->work);
>> >> >> >> +			flushed = true;
>> >> >> >> +		}
>> >> >> >> +
>> >> >> >> +		for_each_online_cpu(cpu) {
>> >> >> >> +			sfw = &per_cpu(slub_flush, cpu);
>> >> >> >> +			if (sfw->skip)
>> >> >> >> +				continue;
>> >> >> >> +			flush_work(&sfw->work);
>> >> >> >> +		}
>> >> >> >> +
>> >> >> >> +		mutex_unlock(&flush_lock);
>> >> >> >> +	}
>> >> >> >> +
>> >> >> >> +	mutex_unlock(&slab_mutex);
>> >> >> >> +	cpus_read_unlock();
>> >> >> >> +
>> >> >> >> +	if (flushed)
>> >> >> >> +		rcu_barrier();
>> >> >> > 
>> >> >> > I think we need to call rcu_barrier() even if flushed == false?
>> >> >> > 
>> >> >> > Maybe a kvfree_rcu()'d object was already waiting for the rcu callback to
>> >> >> > be processed before flush_all_rcu_sheaves() is called, and
>> >> >> > in flush_all_rcu_sheaves() we skipped all (cache, cpu) pairs,
>> >> >> > so flushed == false but the rcu callback isn't processed yet
>> >> >> > by the end of the function?
>> >> >> > 
>> >> >> > That sounds like a very unlikely to happen in a realistic scenario,
>> >> >> > but still possible...
>> >> >> 
>> >> >> Yes also good point, will flush unconditionally.
>> >> >> 
>> >> >> Maybe in __kfree_rcu_sheaf() I should also move the call_rcu(...) before
>> >> >> local_unlock().
>> >> >>
>> >> >> So we don't end up seeing a NULL pcs->rcu_free in
>> >> >> flush_all_rcu_sheaves() because __kfree_rcu_sheaf() already set it to NULL,
>> >> >> but didn't yet do the call_rcu() as it got preempted after local_unlock().
>> >> > 
>> >> > Makes sense to me.
>> > 
>> > Wait, I'm confused.
>> > 
>> > I think the caller of kvfree_rcu_barrier() should make sure that it's invoked
>> > only after a kvfree_rcu(X, rhs) call has returned, if the caller expects
>> > the object X to be freed before kvfree_rcu_barrier() returns?
>> 
>> Hmm, the caller of kvfree_rcu(X, rhs) might have returned without filling up
>> the rcu_sheaf fully and thus without submitting it to call_rcu(), then
>> migrated to another cpu. Then it calls kvfree_rcu_barrier() while another
>> unrelated kvfree_rcu(X, rhs) call on the previous cpu is for the same
>> kmem_cache (kvfree_rcu_barrier() is not only for cache destruction), fills
>> up the rcu_sheaf fully and is about to call_rcu() on it. And since that
>> sheaf also contains the object X, we should make sure that is flushed.
> 
> I was going to say "but we queue and wait for the flushing work to
> complete, so the sheaf containing object X should be flushed?"
> 
> But nah, that's true only if we see pcs->rcu_free != NULL in
> flush_all_rcu_sheaves().
> 
> You are right...
> 
> Hmm, maybe it's simpler to fix this by never skipping queueing the work
> even when pcs->rcu_sheaf == NULL?

I guess it's simpler, yeah.
We might have to think of something better once all caches have sheaves,
queueing and waiting for work to finish on each cpu, repeated for each
kmem_cache, might be just too much?

>> > IOW if flush_all_rcu_sheaves() is called while __kfree_rcu_sheaf(s, X) was
>> > running on another CPU, we don't have to guarantee that
>> > flush_all_rcu_sheaves() returns after the object X is freed?
>> > 
>> >> >> But then rcu_barrier() itself probably won't mean we make sure such cpus
>> >> >> finished the local_locked section, if we didn't queue work on them. So maybe
>> >> >> we need synchronize_rcu()?
>> > 
>> > So... we don't need a synchronize_rcu() then?
>> > 
>> > Or my brain started malfunctioning again :D
> 


