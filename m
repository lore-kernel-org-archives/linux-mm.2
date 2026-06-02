Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33203CD6E5D
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 11:33:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 984096B00AC; Tue,  2 Jun 2026 07:33:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95AFF6B03DA; Tue,  2 Jun 2026 07:33:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 871216B03DE; Tue,  2 Jun 2026 07:33:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 751126B00AC
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:33:42 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3EDDB120916
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:33:42 +0000 (UTC)
X-FDA: 84834762684.12.539E3C8
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id 43F9940009
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:33:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Kc9pD+Lp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780400020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JIjyJAxkpOo0qq8iJhBIp/NwJ9Q4HsURAYxn5PS3IMk=;
	b=YQiYZ57LASf3WPfBDU1vnqRrM4Oh/5vZck5u5NVydqpKcCln24yUbdKYDH5zIdWq1qv2IM
	xDJNJNfE4xFNES+MdCxbauL/Gb9D+6wCeacLqEKCr+kEL9IpjyfITeeHC32Z3HrWj6QwPt
	UYiknxi1+OiKf4HrINl42F2xPcu+sWA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Kc9pD+Lp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780400020;
	b=L+648ru8oPMuqbvhxWM5Nx7GHbOOSDiMrD9iQvIAH5jAhnCUpE7wVjSE/DJ0VYQN/hINMB
	+K5OdOUn1BMCYEv+2ORBM3xRwj3Y3eRWwFU4qNpjo5CtN47JSy5nUMCRqqd4tKR7IL1rHf
	z+ObEXF24FoJq8UBarilHEl6s1QB0IY=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c85893bce34so1107942a12.1
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 04:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780400019; x=1781004819; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JIjyJAxkpOo0qq8iJhBIp/NwJ9Q4HsURAYxn5PS3IMk=;
        b=Kc9pD+LpcLQTS23NnxmhuA1mIBf+k6/WLCQfTL5lEmGisJA6SfGTIZtzB4sG742Gsq
         gGzjKWoyVrqb6U0bXHiokZarFFKs/wy7d2jOQYioQwIDZIvM7rHQ/1knW1Ac+IqJiukn
         AvIL+fQ6yrKZdi4kIClyrCzYNLIPsoA1MpAdYeq5aoZgAA8mEdyI+ZwVWDTXB5tgTKS/
         oIEs/0UtxCDpYwR7Wk5VL73HHnM3yhZxpjapIIvm5xGYJC1at3U9JSHdPzIhFI4X/X+U
         HjcXwFEo1SYXxmDIXWU1uh1rq9LJYXERQBsOPEh6y4+GuDh71OY2uWqnL1mqk5flTLWF
         MpCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780400019; x=1781004819;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JIjyJAxkpOo0qq8iJhBIp/NwJ9Q4HsURAYxn5PS3IMk=;
        b=NRdGpepx15eJtahuoycrOoaCIM/tUI72uXo4buMTfEyHbTTpK07boqyftBP8/QSWAq
         a0qjFOJTvpUuA9e8J9Y1I63r3qhTo996J39CvcqicEm0q82NvvlUAPQ1HDdufKIcbOSY
         93S1OhuR91bSoNA1fvdTY5SMLNuj2HF91xq72A8Rtk65+zUUg5XeZg0Yh7Y3+KQKYEUl
         0+xgsOdQ3Af+uPAllv7Ct9Zv4cyL4Q1ZesFqqTUKCOuZiwzZSpJKvomR0RlJpjP1onMs
         hpmsGE8+NI9z/xVoMNkxAeoZZiMcLJEAvkWZv2c1dke+ED3IrRO3mNnEzxOBQVFmIAjo
         ebOg==
X-Forwarded-Encrypted: i=1; AFNElJ9bLxl/ZQFmwuGd3+ltP13mrND+J9BVNIjkKzcJv17hd485EX2wV96WakAcTPkdsUbupFrxQmukPA==@kvack.org
X-Gm-Message-State: AOJu0YxMctymA4Up+NLL3lpQqEUy141q27+WTjNa+g9eDAylD2GSVfLC
	tDSHMGzHs0R2s1wGZhlK8Do52kE+DhAMLE37uFA7AAsW54CN715kJQXz
X-Gm-Gg: Acq92OHbRqPTyFskChNZD8CSZOqxBMDJKeeb8kKEKtxSPMJpo61DKJ4sQyGLLhlvdKO
	v5grsrm/MhyRqXCFD2yauY6rM9O8a+sgAP1kI2wVQG2Irw6udr5Ts0Ad3GcqEKYRLHvHyuep7jQ
	RriwNLAIFSHLLhK6Zk43naXBk+FB8liUCnEZ2MQhWegmn0BLof/eNHcOoGMQyPLNiOwbTIbeV2x
	bAeGYU3SWg5JMojWHGNcIxYRhTIfwXBMoZd+SiZxaAztO0U9JyHfQe7OA2DqLD2UDYegm1iysr9
	1TAigvfZ3EUlAcDtzae0XoeTlrPFaqg/lQxdBZ1mNayHQg8zlGddtDipWfwW9+GHDkKD6v1ycsD
	+SJsuOu8nHdyecMlOD3KRoe+1QCHARFRLDSk6+c+3RGMVuRFCtTyrExXkEdGlqR3pWOYS1jaiEK
	NNd3rohrumMKaqFDywFFqahy8h0aEtkiUVOzb2fDVUzOot07oB+LAQzw==
X-Received: by 2002:a05:6a00:4488:b0:842:2419:6bfe with SMTP id d2e1a72fcca58-842253d0998mr14098844b3a.7.1780400018894;
        Tue, 02 Jun 2026 04:33:38 -0700 (PDT)
Received: from [10.125.192.75] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214ce85d2sm12730415b3a.51.2026.06.02.04.33.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2026 04:33:38 -0700 (PDT)
Message-ID: <ff344c9f-51da-8b3a-e7a9-c4a7f4702ef8@gmail.com>
Date: Tue, 2 Jun 2026 19:33:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v3 1/4] mm/zswap: Make shrink_worker writeback cursor
 per-memcg
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
 nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Hao Jia <jiahao1@lixiang.com>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-2-jiahao.kernel@gmail.com>
 <aho7nepN5jZtKmef@google.com>
 <8c0e60e1-5713-69f0-a687-088c87e75764@gmail.com>
 <ah4ZZGl7GYJf54Wz@google.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <ah4ZZGl7GYJf54Wz@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: doo3sncwspjxhfji4t8ehmun1k4ge7fr
X-Rspamd-Queue-Id: 43F9940009
X-HE-Tag: 1780400020-87054
X-HE-Meta: U2FsdGVkX19omjVQzSG7zqM4hEhwZ5MzVqDuNJoBcglmPMWK+k32pT2pFaXQqVNThRSQMxsybF41/nGRQ9CpO32UacAyrAbRmD2KiTjJwyGbwtMqZkU0QP5yXx6czYunnSHszLPdQQpZwtCj0g24JIuzChvcoz9z9+Qjs5HdNDYNV8rVTs+YqGhocJY2gburohpdC6DJ8GxcPClb9GHT9bEtQBtA/29Je7MWYNodjkqinlIxNctetJn/WSuvqqPodiiV/z6rxT9IBZu9VslbgcNs08zqzvxbadd3uAqAFMdOj2VsEPHmNXfWknNUTmOVNBENqMejkVoB2ylRALgAT0m/WZyZg91OIM9UuDMY2whwKSzL/65LVmyF0O5vPqnboY9bjCpL7XZ5G4UsmQudbS77Nd0O0qCy6hR8K0fGN4W4mK4t8foPm3oli74Knran9/JuX54rZbfWwtXEpyd725M524qj7lcTdRx8YYJKgYi/F4YtdWCJcDep36ZInRFPpnQY92tS+JyypbywbefpsWoG3OiigXsmfFVf2/fR83nCjvRg7R5W+mU+6X/kCckAjvg0oF/unxE+MHYGu/5Qumo3ivw3Jnp9kgnHWScdGJulOdQXl0tFEzeNRSnbx84LufD0rtb1t58/7Y4vpCaadDS945ip3Rj1I9aEhGSfnebhaolfL8YFf5AQQEP4a6cRWqKToALqd282ZI8BDUTIwVTHO2f1XMXJYvvuR3rI5BvrE4wJL+qVYAu9frdsvgkPDx+4aRTAgBY3KZIr+tbdnRdE1PDwAuvaC4bUSEuRGXrbCCT6TneHEmXwX8gdrF3PqLQLEpC5X3ech2GIL47AkuJ9bKqX9yEBG2wzyyqloFkDNlVBi1FoeLpx6bmV76mJmWDf67j+P+PDWkdn5yo3tTdIAJnGLftXsO73QLccw9gFOblJNcAm58WfAGOmj3/5C45TOoeryGeDD5bRjop
 sc7qebpD
 xX26oQUJIYQVnIV388lBb8QmauPJLYH4/+8hU23IjFxPKo5tQ3ehHKOP5FvneM6eh63gfWipgGfI83vlKVwUetxCs5rJaoRtXhSO4eXH3lOn+KFec8yaKHkRRDtTV5l2wuUmpgQ1TJ1griAVH0QwlCKwY38GyHKsf9HQQ9vWnzkI0V+5TVA50hd9tOxlfNrB58ZMBojPH8sc5M+Yo55yYq5+OzxRAIoOLhsBUXaXbaYI7R9yIQ26Vf0kETOLX3x//BJlHSGNuy1n7D/6j/YiEGP8ghl173kV7aJzUAUU4MbBjSme0n3kmhHKQv79ltYNZwoKLveEKMDspzDAKMF0N3QAGoG7SXPoegfm9L2bjdZ769oH5rYGd1OHHijSIflMZH/iedWQcUCaYkrTpyNl3JXIRchc3v/tIbvw2YymyE9ZlZM4EFyzV2WXa8JGc/LdTqTDF6yfCcZe+IWWu3SS8rErCJ32mn9ZHbwpRiFfjo/asSeTw9OqjljCUQ2wPxzX8aVbFl8xwKcW4olZACPrzuOsRFOrvrnAMWVdwF/pUib/NjjtwHqHBPCMYTbjJ3yf41IQn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/2 08:31, Yosry Ahmed wrote:
> On Mon, Jun 01, 2026 at 07:07:45PM +0800, Hao Jia wrote:
>>
>>
>> On 2026/5/30 09:24, Yosry Ahmed wrote:
>>> On Tue, May 26, 2026 at 07:45:58PM +0800, Hao Jia wrote:
>>>> From: Hao Jia <jiahao1@lixiang.com>
>>>>
>>>> The zswap background writeback worker shrink_worker() uses a global
>>>> cursor zswap_next_shrink, protected by zswap_shrink_lock, to round-robin
>>>> across the online memcgs under root_mem_cgroup.
>>>>
>>>> Proactive writeback also wants a similar per-memcg cursor that is
>>>> scoped to the specified memcg, so that repeated invocations against
>>>> the same memcg make forward progress across its descendant memcgs
>>>> instead of restarting from the first child memcg each time.
>>>
>>> Is this a problem in practice?
>>>
>>> Is the concern the overhead of scanning memcgs repeatedly, or lack of
>>> fairness? I wonder if we should just do writeback in batches from all
>>> memcgs, similar to how reclaim does it, then evaluate at the end if we
>>> need to start over?
>>>
>>
>> Not using a per-cgroup cursor will cause issues for "repeated small-budget
>> calls" cases. For example, repeatedly triggering a 2MB writeback might
>> result in only writing back pages from the first few child memcgs every
>> time. In the worst-case scenario (where the writeback amount is less than
>> WB_BATCH), it might only ever write back from the first child memcg.
> 
> Right, so a fairness concern?
> 
> I wonder if we should just reclaim a batch from each memcg, then check
> if we reached the goal, otherwise start over. If the batch size is small
> enough that should work?

Even with a small batch size, for small writeback requests triggered by 
user-space (e.g., 2MB, which is batch size * N), it might still 
repeatedly write back from only the first N child memcgs. This could 
cause the user-space agent to prematurely give up on zswap writeback.

> 
>>
>> Similar to how memory reclaim uses mem_cgroup_iter() (via struct
>> mem_cgroup_reclaim_iter) and the old shrink_worker() used zswap_next_shrink,
>> we need a shared cursor here.
> 
> Right, I understand that in theory we need a cursor. I am just wondering
> if the complexity is justified in practice. Reclaim is a much larger
> beast than zswap writeback. I wonder if we can just get away with
> scanning a batch from each child memcg -- for per-memcg reclaim, not
> global.
> 
> We can always improve it later with a cursor if there's an actual need.
> 
>>
>>
>>>>
>>>> Naturally, group the cursor and its protecting spinlock into a
>>>> zswap_wb_iter struct, and make it a member of struct mem_cgroup to
>>>> realize per-memcg cursor management. Accordingly, shrink_worker() now
>>>> uses the lock and cursor in root_mem_cgroup->zswap_wb_iter.
>>>
>>> If we really need to have per-memcg cursors (I am not a big fan), I
>>> think we can minimize the overhead by making the cursor updates use
>>> atomic cmpxchg instead of having a per-memcg lock.
>>>
>>
>> Because mem_cgroup_iter() always calls css_put(&prev->css), we cannot simply
>> update zswap_wb_iter.pos via cmpxchg() after calling it. Doing so could lead
>> to a double css_put() issue on prev->css.
>>
>> Therefore, if we switch to the cmpxchg() approach, we wouldn't be able to
>> reuse the existing mem_cgroup_iter() logic. We would have to write a new
>> function similar to cgroup_iter(), and its implementation might end up
>> looking a bit obscure/complex.
> 
> What if we do something like this (for the global cursor):
> 
> 	do {
> 		memcg = xchg(zswap_next_shrink, NULL);
> 		memcg = mem_cgroup_iter(NULL, memcg, NULL);
> 		/* If the cursor was advanced from under us, try again */
> 		if (!try_cmpxchg(zswap_next_shrink, NULL, memcg))
> 			continue;
> 	} while (..);
> 			
> 

Regarding the code above, IIRC, both the global and per-cgroup cursors 
suffer from race conditions. This race can cause mem_cgroup_iter(NULL, 
NULL, NULL) to return the root memcg or its descendants, leading zswap 
to write back pages from the wrong memcg.

Additionally, since mem_cgroup_iter() puts the prev memcg ref and gets 
the next memcg ref, a try_cmpxchg() failure on CPU1 might also lead to a 
ref leak for memcg1.


	CPU1                                       CPU2
memcg1 = xchg(pos, NULL)
                                memcg2 = xchg(pos, NULL) memcg2 = NULL;

memcg1 = mem_cgroup_iter()
                        mem_cgroup_iter(NULL, **NULL**, NULL) error memcg
                                 try_cmpxchg(pos，NULL，memcg2） succeed
try_cmpxchg(pos，NULL，memcg1） **fail**



I took a stab at implementing a cmpxchg()-based zswap_mem_cgroup_iter() 
modeled after mem_cgroup_iter(), and it actually doesn't look that 
complex after all :)

Of course, as Nhat mentioned, we definitely need to add plenty of 
comments for this function.

static struct mem_cgroup *zswap_mem_cgroup_iter(struct mem_cgroup *root)
{
	struct cgroup_subsys_state *css;
	struct mem_cgroup *pos, *next;

	if (mem_cgroup_disabled())
		return NULL;
	if (!root)
		root = root_mem_cgroup;

	rcu_read_lock();
restart:
	pos = READ_ONCE(root->zswap_wb_iter.pos);
	css = pos ? &pos->css : NULL;
	next = NULL;

	while ((css = css_next_descendant_pre(css, &root->css))) {
		if (css_tryget_online(css))
			break;
	}
	next = css ? mem_cgroup_from_css(css) : NULL;

	if (cmpxchg(&root->zswap_wb_iter.pos, pos, next) != pos) {
		if (next)
			css_put(&next->css);
		goto restart;
	}
	rcu_read_unlock();

	return next;
}

> There is a window where a racing shrinker will see the cursor as NULL
> and start over, but that should be fine. We can generalize this for the
> per-memcg cursor.
> 
> That being said..
> 
>>
>> Currently, this lock is only used in shrink_memcg(), proactive writeback,
>> and mem_cgroup_css_offline(). Note that shrink_memcg() only acquires the
>> lock of the root cgroup, and mem_cgroup_css_offline() is unlikely to be a
>> hot path.
> 
> ..this made me realize it's probably fine to just use a global lock for
> now?
> 
> IIUC the only additional contention to the existing lock will be from
> userspace proactive writeback, and that shouldn't be a big deal
> especially with the critical section being short?
> 

In the current patch implementation, this lock protects the cgroup's own 
cursor variable. During each writeback, we only acquire the spin_lock of 
the target cgroup itself; we do not attempt to **spin on any child 
cgroup's lock while iterating through the descendants**.

Specifically:

  - shrink_memcg() will only attempt to acquire the root cgroup's lock 
throughout the entire process.
  - Proactive writeback will only acquire the lock of the target cgroup 
**itself**.
  - Only mem_cgroup_css_offline() might attempt to hold locks of other 
cgroups, but normally, this shouldn't be a hot path.

Therefore, even if proactive writebacks are triggered concurrently on a 
parent cgroup and its child cgroup, there will be **no** lock contention 
at all (specifically referring to zswap_wb_iter.lock).

Lock contention would only occur if user-space **concurrently** triggers 
proactive writeback on the exact **same** cgroup. And IIRC, in such a 
scenario, the bottleneck is more likely to be on other locks anyway.


>>
>> So, should we keep the spin_lock or go with the cmpxchg() approach?
>> Yosry and Nhat, what are your thoughts on this?
> 
> I think we should experiment with the global lock first. See if you
> observe any regressions with workloads that put a lot of pressure on the
> lock (a lot of threads in reclaim doing writeback + a few userspace
> threads doing proactive writeback). See if the userspace threads
> actually cause a meaningful regression.

Sorry, it seems there are some implementation issues with the global 
lock approach.

In practice, our user-space agent mostly operates in the following two 
scenarios:
  - Triggering proactive writeback on the same cgroup at different times 
(sequentially).
  - Triggering proactive writeback on different cgroups at the same time 
(concurrently).

In both cases, there is no lock contention. So, the current lock works 
perfectly fine for us.

However, if we really hate zswap_wb_iter.lock, I can try replacing it 
with the cmpxchg() approach.

Thanks,
Hao

