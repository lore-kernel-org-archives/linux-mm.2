Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A54BD637B2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 04:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B758E6B00A4; Fri, 19 Dec 2025 23:39:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B23906B00A5; Fri, 19 Dec 2025 23:39:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FB146B00A7; Fri, 19 Dec 2025 23:39:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 884D16B00A4
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:39:52 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F0D30136829
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:39:51 +0000 (UTC)
X-FDA: 84238596582.03.0A3C979
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf30.hostedemail.com (Postfix) with ESMTP id 323A080007
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:39:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CM4GWEWM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766205590; a=rsa-sha256;
	cv=none;
	b=RpUn3ySpaW0pvSHqA0ZtmHYm8imMDE+fX8IqKjiGQdlDTP3C47HHw7poURtWNDscN1OpfE
	AN1Z49zb/M+Ypk3HyaCkD0X3J3/C434+keOaS15gFOMQ3ThdlMaahnNWEuLddBiafkjkjE
	fpmCRy3IwmksEnvxJ1+d93xT/wk4NKE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CM4GWEWM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766205590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mjpDIwqwh7awqQg3Av0KcHl6j1llQuC0S7I0UlnqixQ=;
	b=qhrVt0ta6tD8Xa/guxuET9nLJ8oTPyA4SJB6NDNTmFUAxE+9kKKJRm/GtU5IaIJJZJe05V
	iTDTIhKCgGlR+kX8qwjkfh/LBBcF0y3R0tLW6jx/6NowdhL/YvvEztI7Cx4bZmbt7Z5NgW
	Wkt8twCuqEKp3NflfcF0MO9O3QRzzOo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766205586;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mjpDIwqwh7awqQg3Av0KcHl6j1llQuC0S7I0UlnqixQ=;
	b=CM4GWEWMDv80MKD/woyY3hmlF+mdwLT9ORWJeEnvWxuPD0dXeZd2YBNMbq5yl/MLIjsllY
	1T8Cu+9kwGr/OXk4zpla5rNaUNkECwS/42OQABliKhhTt3CrNANOanUVAeU+7ht5DOzeU7
	9E9b6NjSWaA3RD9ej89BHN+lKwfzVfM=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bot+bpf-ci@kernel.org
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
  inwardvessel@gmail.com, ast@kernel.org, daniel@iogearbox.net,
 shakeel.butt@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
 mhocko@suse.com, andrii@kernel.org, martin.lau@kernel.org,
 eddyz87@gmail.com, yonghong.song@linux.dev, clm@meta.com,
 ihor.solodrai@linux.dev
Subject: Re: [PATCH bpf-next v2 4/7] mm: introduce BPF kfuncs to access
 memcg statistics and events
In-Reply-To: <1b78506003b674f5e66bc7ac61f279a363f5cacc8d2fcb615d06abb0316ef00c@mail.kernel.org>
	(bot's message of "Sat, 20 Dec 2025 04:29:43 +0000 (UTC)")
References: <20251220041250.372179-5-roman.gushchin@linux.dev>
	<1b78506003b674f5e66bc7ac61f279a363f5cacc8d2fcb615d06abb0316ef00c@mail.kernel.org>
Date: Fri, 19 Dec 2025 20:39:39 -0800
Message-ID: <873455n4vo.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 323A080007
X-Rspamd-Server: rspam03
X-Stat-Signature: 6ogppzagd5ob56na3ipy74o3bkj51c5s
X-Rspam-User: 
X-HE-Tag: 1766205589-748680
X-HE-Meta: U2FsdGVkX18W6ysm3BaJ1dWS+uZhl2rEQwPgW8Xv4ykkt9Ns0Fertubk0E8UQ+jDEa+4poNzfNhF10cg7gsHYHdzE7KCtTVvA/L6i2X/sgHULZrOxPftH77ZX6Nk9c4SqsrusEAZdAQ8/RxsqJbDWMI88p054Ie3HizN66zVmHxpX8Sr7wcKjXJM6iakrd2oJ/9WEF9tMoZKxFPPZMY/2DDBs1+dRfh1YRR1m1h32PAs+9buQr+IFZ0oiOXpspY+xYkTM3P++dUEplRJdzAnv8BkTLTPWPIes3Ub/2DNy1ha0AZUtEoClNKT8SyEV2Rllz9yIubljD24gfDUdvZ/TXplXknG1bOTddIJBzsfEOyr3CyV/pTtzIXLtX3puMBHL7O8bqYX9cc+3kEoAlA6CFTaHLNF0iVvB57tzEa9eSxo01gBoOmEyhAz4pgWvobn5ROwhidzMNTXgbWKAC4qlrqHTbZVikhPfKM7wyC2/4YlKijG0bvz7Xl/eHwcz3K7glQe0nKrQ+m/EbY6UapjvtnZoOMccgej4wA88sqKdhoq+RJ6HM79avLtFDAAXLhTg7OxSnQ265plEha4UIz8MXa4NNWhOFDKCRAgSp4RmGncAREQ4tNeENXuDSBEnAAQKBB6SbxYD7UEummF8mdrDwIIuUj5WXC/4BPpmlYZHviWdFYFiR2mvb2477ZbOK5Y3+T9akb23mLZmCq8+bUvCJnfhAHVQFOafZmlCgot+/G83Jbz2C2QdgiFqwtHnYuRxAOQZ8CQS9RQbnF28nmMBHONB/Vs/zMa5xttJHLN1eQakb3HQFm8giIGG2zLCMxz5MTJdbXeXR7/jgHeyO7srF0EYrMQJ3pVx5eCYjzdU4J4zMRF7AHeviWIOJ5bXtOma4+WziDOt34/sIFt/TK+u6naSXkosUl3vy/1XnLqiXRq23oVovH3NDvXKh+5qD1H0JRro9Fhdp3ki/ye+PP
 BmcNklP3
 ttDggUnfYzjDKGGtQ0u29tNB/oyv8es4nkchYnXFypDD9CH6IoyUnSb13DyVsaOp3+xdnS2gB7Aebf2IAeS44x8h0nWcMNWUDXvlBPOn2WEWWRFMfc6+kWOC7awxymKh3AhdWQODyhVxkdCqEIQRaRBRNX6mCvyqEH2LitnVx7FsYNBLpIZJ9syDVvF5sGD9DMovLgz0wnwBkz02LgOV5rLfhLwUOGSu4rjwsK2eyKHR0k0PVrJwjIYXustxIoUWTjpRZ49z6sqUotc0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

bot+bpf-ci@kernel.org writes:

>> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
>> index 2d518ad2ad3f..d84fe6f3ed43 100644
>> --- a/mm/bpf_memcontrol.c
>> +++ b/mm/bpf_memcontrol.c
>> @@ -78,6 +78,57 @@ __bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
>>  	css_put(&memcg->css);
>>  }
>>
>> +/**
>> + * bpf_mem_cgroup_vm_events - Read memory cgroup's vm event counter
>> + * @memcg: memory cgroup
>> + * @event: event id
>> + *
>> + * Allows to read memory cgroup event counters.
>> + */
>> +__bpf_kfunc unsigned long bpf_mem_cgroup_vm_events(struct mem_cgroup *memcg,
>> +						enum vm_event_item event)
>> +{
>> +	return memcg_events(memcg, event);
>> +}
>
> Should this function validate the event parameter before passing it to
> memcg_events()?
>
> The call chain bpf_mem_cgroup_vm_events()->memcg_events()->memcg_events_index()
> reaches an array access in memcg_events_index():
>
>     static inline int memcg_events_index(enum vm_event_item idx)
>     {
>         return mem_cgroup_events_index[idx];
>     }
>
> The array mem_cgroup_events_index is declared with size NR_VM_EVENT_ITEMS.
> If a BPF program passes an event value >= NR_VM_EVENT_ITEMS, this would
> cause an out-of-bounds array read.
>
> For comparison, bpf_mem_cgroup_page_state() below validates its idx
> parameter before calling memcg_page_state_output(). A similar check here
> would prevent the potential out-of-bounds access:
>
>     if (event < 0 || event >= NR_VM_EVENT_ITEMS)
>         return (unsigned long)-1;

No, it's a false positive, as explained in a reply to the similar comment
to v1.

