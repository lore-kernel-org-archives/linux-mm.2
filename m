Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82E4BC44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 10:06:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F9A56B007B; Wed, 22 Jul 2026 06:06:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AACE6B0088; Wed, 22 Jul 2026 06:06:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 671846B008A; Wed, 22 Jul 2026 06:06:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F6276B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 06:06:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AFFBC1C081E
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 10:05:59 +0000 (UTC)
X-FDA: 85015981638.09.C274D5C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0AF7C1C0010
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 10:05:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l8yQoO+D;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784714758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D6xRJg1cx2MApnHZbTatL/7rofeEJ41u17Yfn/n5svk=;
	b=1X3eNtHbniBVgdcVkb9Q+TpGFpxCPiGSLmhC7p50BV2dtbQ/+ynYW9wY0JreFqYwHt3cKt
	OhwCp4SMzsdIDdKDRy3g/dJHKI60FfkU9auc9KFWqnCPIAfpitrSiA9mcdznQB4G/9J++F
	KR67vxqGy3gWO4LodrmyrfG4qnEPzC4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784714758;
	b=Byr5U39CHVOdM9HYr6MtHnOKEQPx1Nt29MtnTh2qR8qIrZmLhD0OcSWUOp8YgETBe3ljHi
	gi7Wu/M9maINF8Bsoghcv9KA6ns9v+55IVNNyW5WYtxulhbqgcpKM/5EGzaFaFOWmosXQ0
	/b1R4gw23EKOsV8Vznk56m9wVI24M7s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l8yQoO+D;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 96967600DA;
	Wed, 22 Jul 2026 10:05:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D871F000E9;
	Wed, 22 Jul 2026 10:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784714757;
	bh=D6xRJg1cx2MApnHZbTatL/7rofeEJ41u17Yfn/n5svk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=l8yQoO+Dlue8vZ1yUqfeSgih4Rs9yNiQyqVpA7436Ssb9aTi4vw/bCvaoY28YmbhN
	 nLUIuZnMQr4FsWHmbhjWhO5aO0g3mlmNM9IfG0Gj8lINAdf14fcSQ+wlh2m5vLg0gZ
	 8KMR6onERgLKAlrQfNIDBFCZxcA+z8KS4SjAJvBXKWCJRgD6dQ8FPKhYSy9W0mZ/ru
	 1VCvvamIr7Eu6raA8FcnBQe0BtPNHSqP4tYmdTzhYsN+hG0ne8bwgSbs6Mg9UGYyyN
	 4ir3qvSYcZtHmZWysW5Spo+OLmUs9gFWMBWojk7/VC7IXPC6Fr9oywbavW0lYX4HwW
	 n9jfuNl8SxFmg==
Message-ID: <8d67a924-9c1f-4e93-9e2a-4d71001167a2@kernel.org>
Date: Wed, 22 Jul 2026 12:05:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab/for-next v4 7/8] mm/slab: introduce
 kfree_rcu_nolock()
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>,
 Shengming Hu <hu.shengming@zte.com.cn>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
References: <20260720-kfree_rcu_nolock-v4-0-964e03c41a4e@kernel.org>
 <20260720-kfree_rcu_nolock-v4-7-964e03c41a4e@kernel.org>
 <c7607f25-5336-4f64-9244-9476dcc8ff3d@kernel.org>
 <734ecdc6-f415-41d8-9357-7fc11379e4da@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <734ecdc6-f415-41d8-9357-7fc11379e4da@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0AF7C1C0010
X-Stat-Signature: quoq71rbr51eopptyby7uurab9bhjx8z
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784714757-724799
X-HE-Meta: U2FsdGVkX19wIH/HacV4H7sdfXIZaI/l4KPpAoSBHQmr9R4a33DH2kWYacGSnOLrfck5CZriM2SyVBR+Y6WGozL9GO+7ODLS9xJIAl+qLxQVc9//hdtmiv4VCxUNco4J4y5PRbpSwU7+/ghLFwIsMdt+ipAuUq09Gyxqa7zH+8icFA50ZIZoX7c8tvertqO7AkYa9IzXpxxnYZEu1w/6odQx7F9xFcNJamLNTmKzfUHsrU0NCHbmafiTTyY7DjWxkmfVHIHD7PF+QJcGNofYFPiACjAhJVMhmJfsnCoiF3l4tvtyt/+U9+wxnx2jkGBYyimcvsZgD0lVOBYM6UN8pzKJTrYn6DMAuzKOZKFWFcrJEYImea4SMMPcgvZseV2ONVLx1jvLNRSxVOY+5+xR1GhWfpTvruYlrJSl2PwZwDN3t6WwXWskZZ8hCq/MKJzixiOExOvgqyNAGIW8iZAD82wcLF9hMkfieaIunU6RVinki+K5wa4ZoVoVXRKTLp/5tbguAwif4YTVChl0EALF7VOKiekfVEnlUdaibhcTFTA0K8WL/BhhF2aHreOfSACSNem/yJpsZGI03gfD6Tv/9PpB38Fl99QMpotpcHEZAIo8Aa0vJDVp08H/bqeoC91gZw/OHA5PK0iyH9cw6x7HQan6QxKY50tsIZfvzbEBIlhaZ21zU0AufCuh7wo01zebWQ4Fo19CkCxrU9wTipVhn2UhgC6ac3L3pEHJXyPa5PD64VgToAHqvyJET1ABcjpkG2d0MkoilcaZZzY0a/Ty61P68IlmwEX9/0zbIFoMpuPwP4WhoksT7bffJ9qy5v8gxcMooR5VDWsgRvUJB2dT/pjOQyb36ybQISugzbQVN/bRMkqw3m3tlaTVE4K35T6SDmyMPRd9UzWYFnERC62RL47fw10numNCe3xl155uWDGZxk7RSHjy6dTH1j0BxqciIILUP95ilrgEuIFo36i
 LzP1B4nm
 GwrI7AcoLsgKPjDhcCfiwEjQhlfmRlF5TTy9VoT0jimPlpG0tv3D2dESbJ9xzQ8Xi5QbnYJoFAx6x4TfXdrlj1WaD8+VVQgGSzxvw8cSdknpY2vctKLYC900NfGQ/gL/uJrR8CsRM847mcov8nd+lbI01ix2ziOQY+7/byg3xr9qPi9ye+0CF8BpAfdebAFFTKO/XgHpKYK/gcpaqQuMjlVvKmjhwr5kX9n9+w3u8bEcxnaXqAvzHz/J9dwp4z8knTQ8++oAW5Y+xecm6aWAbA8kOktk4xqoCImyZ2c4kXEuKfrYg+BjCjSpVuJtEWOaKn/l8Ir3Kt0f+InU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/26 10:15, Harry Yoo wrote:
> On 7/21/26 10:09 PM, Vlastimil Babka (SUSE) wrote:
>> On 7/20/26 14:44, Harry Yoo (Oracle) wrote:
>>> Currently, k[v]free_rcu() cannot be called in unknown context since
>>> it could lead to a deadlock when called in the middle of k[v]free_rcu().
>>>
>>> Make users' lives easier by introducing kfree_rcu_nolock() variant,
>>> now that kfree_rcu_sheaf() is available on PREEMPT_RT and
>>> __kfree_rcu_sheaf() handles unknown context.
>>>
>>> kfree_rcu_nolock() falls back to the kvfree_rcu batching when sheaves
>>> path fails.
>> 
>> From the code I would say it falls back to defer_kfree_rcu(), which is an
>> irq_work that does kvfree_rcu batching?
> 
> Indeed that was what I intended to say, but I messed up while
> writing it :-) Will fix that.

Thanks!

>> Otherwise the sentence would contradict the following:
>>
>>> In most cases, the sheaves path is expected to succeed
>>> and it's unnecessary to add complexity to the existing kvfree_rcu
>>> batching by teaching it how to handle unknown context.
>> 
>> This talks about trying to perform the batching immediately without defering.
> 
> You mean the earlier sentence "kfree_rcu_nolock() falls back to the
> kvfree_rcu batching when sheaves path fails", right?

I was trying to point out how it contradicts the wording above. To be clear,
with above fixed, this part is fine.

>>> Since defer_kfree_rcu() can be called on caches without sheaves, move
>>> deferred_work_barrier() and rcu_barrier() outside the branch in
>>> kvfree_rcu_barrier_on_cache().
>>>
>>> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
>> 
>> Other than that and a comment correction below, LGTM.
>> 
>> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 
> Thanks!
> 
>>> ---
>>>  include/linux/rcupdate.h | 19 +++++++++++++++++++
>>>  mm/slab_common.c         | 28 ++++++++++++++++++++++++++--
>>>  mm/slub.c                | 24 +++++++++++++++++++++++-
>>>  3 files changed, 68 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
>>> index ef5bb6981133..ce0fd401352e 100644
>>> --- a/include/linux/rcupdate.h
>>> +++ b/include/linux/rcupdate.h
>>> @@ -1099,6 +1099,7 @@ static inline void rcu_read_unlock_migrate(void)
>>>   * In mm/slab_common.c, no suitable header to include here.
>>>   */
>>>  void kvfree_call_rcu(struct kvfree_rcu_head *head, void *ptr);
>>> +void kfree_call_rcu_nolock(struct kvfree_rcu_head *head, void *ptr);
>>>  
>>>  /*
>>>   * The BUILD_BUG_ON() makes sure the rcu_head offset can be handled. See the
>>> @@ -1124,6 +1125,24 @@ do {								\
>>>  		kvfree_call_rcu(NULL, (void *) (___p));		\
>>>  } while (0)
>>>  
>>> +/**
>>> + * kfree_rcu_nolock() - a version of kfree_rcu() that can be called in any context.
>>> + * @ptr: pointer to kfree for double-argument invocations.
>>> + * @kvrhf: the name of the struct kvfree_rcu_head within the type of @ptr.
>>> + *
>>> + * Objects that are not allocated via kmalloc_nolock() are not supported.
>> 
>> Is this true? If __kfree_rcu_sheaf() succeeds, rcu_sheaf is either flushed
>> normally (call_rcu with rcu_free_sheaf()) or via the irq_work doing the
>> same. The defer_kfree_rcu() fallback ends up doing a normal
>> kvfree_call_rcu(). I don't see any path that ends up doing kfree_nolock().
>> Am I missing something?
> 
> I added this limitation because I thought it doesn't make sense
> to support this when we don't support large kmalloc and vmalloc in
> unknown context.
> 
> Perhaps too limiting than it should be though.

Hmm right. Maybe we could just state that it handles all small kmalloc() and
kmalloc_nolock() allocations without deferring as much as possible, but
large k[v]malloc() allocations that end up being large_kmalloc() or
vmalloc(), will also work but be always deferred?

>>> + * kfree_rcu_nolock() supports 2-arg variant only.
>>> + */
>>> +#define kfree_rcu_nolock(ptr, kvrhf)						\
>>> +do {										\
>>> +	typeof (ptr) ___p = (ptr);						\
>>> +										\
>>> +	if (___p) {								\
>>> +		BUILD_BUG_ON(offsetof(typeof(*(ptr)), kvrhf) >= 4096);		\
>>> +		kfree_call_rcu_nolock(&((___p)->kvrhf), (void *) (___p));	\
>>> +	}									\
>>> +} while (0)
>>> +
>>>  /*
>>>   * Place this after a lock-acquisition primitive to guarantee that
>>>   * an UNLOCK+LOCK pair acts as a full barrier.  This guarantee applies
> 


