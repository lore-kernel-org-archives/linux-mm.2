Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9362BC44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 13:03:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65C8E6B0098; Wed, 22 Jul 2026 09:03:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6339C6B0099; Wed, 22 Jul 2026 09:03:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 526536B009B; Wed, 22 Jul 2026 09:03:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2190D6B0098
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:03:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 87A971C0108
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:03:34 +0000 (UTC)
X-FDA: 85016429148.14.3F33F1A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 87338140018
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:03:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CygOMo2V;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784725412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JRfF13UFkjWB9XMLyhGUN/vcON3pZ0DNP+lpiH2kmuY=;
	b=VRpaRc3G2jzV7/XbfdPrkuTmdqcJes8NmbFH+h1uqX/D0Ymg/mDDNVGX0iOJwODebMsZM1
	4j7V8+V31AOr9le11Veil6UCDM0kUyNtu+hsOAkmWfK9YrXkfmfsSnZ4j8+jZFcL6KZRu0
	v6hSJtMxlEysEPpg74jipWQbMARXJc8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784725412;
	b=IQjudD5KjOo6quQCLaDY4BBvpt9PGgQD867ieW5BqbbDi3OCV7QcOLWgYj4wgneaIqvjtw
	90RDQLyg34ZyLC7lkP1sN+Ro8P0D2rmy21JPyx9jOW03x7PeH6KtAO64GZMa/6Ge2zZ35Y
	HcmR929SaUIOTyOsYKqTW+eAmVa7pfk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CygOMo2V;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 82A184066C;
	Wed, 22 Jul 2026 13:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C665F1F00A3D;
	Wed, 22 Jul 2026 13:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784725411;
	bh=JRfF13UFkjWB9XMLyhGUN/vcON3pZ0DNP+lpiH2kmuY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CygOMo2VwhqUmyaRw7RaAbN578oGAARrfgEKiHOG1cxtBu1Biz34WtFNZpTatxOAl
	 Ce4klrajL32teHPFSJgOh7V7x8U6tuk3xpVI4SypunO0URRGKAi5QUYyThnrWD6O5E
	 zzYzPdJSLE0178bxQjnkkkGIWKq/zgEMbqwXMgqzrzFFgjNXeJQBusT0r8Sy0Ozp4b
	 xAUrSbi6KyeuO3Mvkagd5nd77dNccqkhv2gbfeHS3gff0GLidUF5tA4zgaEKg2hoJV
	 3YVfxJWO+6KP54mKLr+aI5rcHOPw5ro1f9W0suOZPwr6s69loyOn7/wlQ/CJMpl6Ne
	 yaOgJn40xGI2g==
Message-ID: <675d1677-3736-46a8-adac-fba1349217fa@kernel.org>
Date: Wed, 22 Jul 2026 22:03:25 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab/for-next v4 7/8] mm/slab: introduce
 kfree_rcu_nolock()
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
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
 <8d67a924-9c1f-4e93-9e2a-4d71001167a2@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <8d67a924-9c1f-4e93-9e2a-4d71001167a2@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 87338140018
X-Stat-Signature: tkji5zf83th4iraskrp7row6ekdkf5hz
X-HE-Tag: 1784725412-478345
X-HE-Meta: U2FsdGVkX1/gCyy4mBjEV6z5BbiiiE50hSjEUml+n9liBDP3gul07jaDhsn1rDpYNH8Wqn968haNs7aj2F0xiV1pCdTZfeUv8mn7FfsejXIndhuzUT4/0urtKQnBPdKDxVf8qS4DzdXtXvZW6zWPrda4Kr14NF9WRvoK4JN4YMJqfHNiS0Hz8GgyMqKVJ0/UoE9dh7m1pvuGhBJ77RnHWyQ6+ynlCNpsJ/e1UdFZyV6QIhldt7YwAsxwGzeO+Z0+ix7ZZRd4iQRDiqaYrfrA97inXsw0suZz6vjvPxR2xYy0jZRr44LJsXSaClogQ3ReTnhlnWIKFMhkkpsaph3bQUsSRX5KrWH2dfwt4llc/h3MMFz+JsaxsA23TBsn8WmeyrbRkwCO/j2rcTxlrZBHLlpL8CAM7puWLehTYfaI2KVTDRgXrm/cL26TAtFKD6JnLTwsYMSMqAzZ+VML0bRu7/dBXk1z9UlE4haSuaS0pIi7FKr1ToyI7iRHZLNLuJFlgkIUAM82Jgxq78G/RAx4BUONprN1QUpUAsvT096gJyZx9ot7ja+FaNShrkol1s3tKUhxoiHWK4iiwAlZJyeBUVKl/N6HyWG3Xf+pD+McoTEhFO+VmvYcWuIHogxcA9eboN/f/ci0EC/c16WoN0Klg7aCh4DyWGyEPqv9j0gI6oWPj3zyPZAgkGM1rEpjoJ8Mo0rR3mx61Yxcm39V4iWTEbfESEqJYB9X4aWk+HkIZ52ryfsKGNc/yeVICG1BFJAT2Otyi8AjmMAJZuhRXuJAhQYDxT5wkrv4+x5+AcnnBCStfTtgOg0YhvsErO1Rrp5XzyGQGZtCl9JxWTSAVIiy/ntQV5VnojQ0qLxPSkj79tlbY/mdMzDMRtkP1NFC6SThca+WUYyJbf70+IchiHG5pErgF7wiTzYrkCMLb63EbjU/BPncYW3ZmgLzJXyA0DyGIYJGqGuuczogfjgRue/
 uPK8WCTP
 DmQeKaCW50DPBT19xvQMzHr84hwDS5/8UU8EHUpEUgS6yQSoLgLa58nG+NHf7wN08RACeN5dNpiCtldNRowltw+aoUYiU59k0M66gFJEgwAgYU25UiIin/VAq7a93w1/gCXwSdmLP3NJK4F09e4LxbkpEqEq9uqaH6FoNcdWPMSvtbsk4P/VvrAeoArUoEoNyAc6Urqhb3Xiagb/iNvwAViN/SYhfWZQe5RpqvfmN9EKJzLGqFioV/+elD8ng6MZc3WbaIvrnn3Rvnbw6qo3ni7F6ERK530UKqxmn4hugCGdrfS4yUUomsJbGFj4caiQlC6uALMlosCBt7hw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/22/26 7:05 PM, Vlastimil Babka (SUSE) wrote:
> On 7/22/26 10:15, Harry Yoo wrote:
>> On 7/21/26 10:09 PM, Vlastimil Babka (SUSE) wrote:
>>> On 7/20/26 14:44, Harry Yoo (Oracle) wrote:
>>>> Currently, k[v]free_rcu() cannot be called in unknown context since
>>>> it could lead to a deadlock when called in the middle of k[v]free_rc=
u().
>>>>
>>>> Make users' lives easier by introducing kfree_rcu_nolock() variant,
>>>> now that kfree_rcu_sheaf() is available on PREEMPT_RT and
>>>> __kfree_rcu_sheaf() handles unknown context.
>>>>
>>>> kfree_rcu_nolock() falls back to the kvfree_rcu batching when sheave=
s
>>>> path fails.
>>>
>>> From the code I would say it falls back to defer_kfree_rcu(), which i=
s an
>>> irq_work that does kvfree_rcu batching?
>>
>> Indeed that was what I intended to say, but I messed up while
>> writing it :-) Will fix that.
>=20
> Thanks!

I'm the one to thank!

>>> Otherwise the sentence would contradict the following:
>>>
>>>> In most cases, the sheaves path is expected to succeed
>>>> and it's unnecessary to add complexity to the existing kvfree_rcu
>>>> batching by teaching it how to handle unknown context.
>>>
>>> This talks about trying to perform the batching immediately without d=
efering.
>>
>> You mean the earlier sentence "kfree_rcu_nolock() falls back to the
>> kvfree_rcu batching when sheaves path fails", right?
>=20
> I was trying to point out how it contradicts the wording above. To be c=
lear,
> with above fixed, this part is fine.

Ah, Ack.

>>>> Since defer_kfree_rcu() can be called on caches without sheaves, mov=
e
>>>> deferred_work_barrier() and rcu_barrier() outside the branch in
>>>> kvfree_rcu_barrier_on_cache().
>>>>
>>>> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
>>>
>>> Other than that and a comment correction below, LGTM.
>>>
>>> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>>
>> Thanks!
>>
>>>> ---
>>>>  include/linux/rcupdate.h | 19 +++++++++++++++++++
>>>>  mm/slab_common.c         | 28 ++++++++++++++++++++++++++--
>>>>  mm/slub.c                | 24 +++++++++++++++++++++++-
>>>>  3 files changed, 68 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
>>>> index ef5bb6981133..ce0fd401352e 100644
>>>> --- a/include/linux/rcupdate.h
>>>> +++ b/include/linux/rcupdate.h
>>>> @@ -1099,6 +1099,7 @@ static inline void rcu_read_unlock_migrate(voi=
d)
>>>>   * In mm/slab_common.c, no suitable header to include here.
>>>>   */
>>>>  void kvfree_call_rcu(struct kvfree_rcu_head *head, void *ptr);
>>>> +void kfree_call_rcu_nolock(struct kvfree_rcu_head *head, void *ptr)=
;
>>>> =20
>>>>  /*
>>>>   * The BUILD_BUG_ON() makes sure the rcu_head offset can be handled=
=2E See the
>>>> @@ -1124,6 +1125,24 @@ do {								\
>>>>  		kvfree_call_rcu(NULL, (void *) (___p));		\
>>>>  } while (0)
>>>> =20
>>>> +/**
>>>> + * kfree_rcu_nolock() - a version of kfree_rcu() that can be called=
 in any context.
>>>> + * @ptr: pointer to kfree for double-argument invocations.
>>>> + * @kvrhf: the name of the struct kvfree_rcu_head within the type o=
f @ptr.
>>>> + *
>>>> + * Objects that are not allocated via kmalloc_nolock() are not supp=
orted.
>>>
>>> Is this true? If __kfree_rcu_sheaf() succeeds, rcu_sheaf is either fl=
ushed
>>> normally (call_rcu with rcu_free_sheaf()) or via the irq_work doing t=
he
>>> same. The defer_kfree_rcu() fallback ends up doing a normal
>>> kvfree_call_rcu(). I don't see any path that ends up doing kfree_nolo=
ck().
>>> Am I missing something?
>>
>> I added this limitation because I thought it doesn't make sense
>> to support this when we don't support large kmalloc and vmalloc in
>> unknown context.
>>
>> Perhaps too limiting than it should be though.
>=20
> Hmm right. Maybe we could just state that it handles all small kmalloc(=
) and
> kmalloc_nolock() allocations without deferring as much as possible, but=

> large k[v]malloc() allocations that end up being large_kmalloc() or
> vmalloc(), will also work but be always deferred?

That sounds good! Will do.

>>>> + * kfree_rcu_nolock() supports 2-arg variant only.
>>>> + */
>>>> +#define kfree_rcu_nolock(ptr, kvrhf)						\
>>>> +do {										\
>>>> +	typeof (ptr) ___p =3D (ptr);						\
>>>> +										\
>>>> +	if (___p) {								\
>>>> +		BUILD_BUG_ON(offsetof(typeof(*(ptr)), kvrhf) >=3D 4096);		\
>>>> +		kfree_call_rcu_nolock(&((___p)->kvrhf), (void *) (___p));	\
>>>> +	}									\
>>>> +} while (0)
>>>> +
>>>>  /*
>>>>   * Place this after a lock-acquisition primitive to guarantee that
>>>>   * an UNLOCK+LOCK pair acts as a full barrier.  This guarantee appl=
ies

--=20
Cheers,
Harry / Hyeonggon

