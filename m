Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA58FCA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 21:42:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E75D8E0010; Fri,  5 Sep 2025 17:42:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 297D58E0001; Fri,  5 Sep 2025 17:42:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D5678E0010; Fri,  5 Sep 2025 17:42:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0CED68E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:42:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B936F1A0331
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 21:42:15 +0000 (UTC)
X-FDA: 83856520230.23.47E561E
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id E8E96100003
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 21:42:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t2KycOcQ;
	spf=pass (imf05.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757108534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JdQSZQn4Ae0lf5/FOhW87b1E1rxb0mDC0qFKSsqhQ4I=;
	b=dth9efLLCqVYfjkGAPEVUsDwyavO/T7a5RjBmEAHYg7VPjGdsf+eghfvSnTa7wEqdioPsB
	ID0H05PbUx/Z4coLzuGRdeU2NWBeyCbKVAGRN9qB6ao72UHptnb8aPeHUoLoacw1wEpCNi
	P7AvfcQx4WIUGzC2bbP+P/iwUwh7FrY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757108534; a=rsa-sha256;
	cv=none;
	b=rvhTQSQOW0Dub6j99jLtzPIrL1fPAR6xVYFkDAa/FWYvkgXCDKPQSZ+krTJCK0JGhxelYm
	O31GLDMJz8iXsjHfNeQvra1Ex/0TlNSQriyrUWj1isxOX7qCw9mxWWzLVWb7zj9pWZuJSv
	9Vrn9wGdJNvMhuRbbJH5ljxnjSQb/KQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t2KycOcQ;
	spf=pass (imf05.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757108532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JdQSZQn4Ae0lf5/FOhW87b1E1rxb0mDC0qFKSsqhQ4I=;
	b=t2KycOcQC6+Wj1X+FCLqCY3UI+yAR/kc8EnpBUKQbcoiI3YaZw2E1d0/VODIOXL7PgHDxn
	cx8ZeTr9MJKBB+M9Js3cGU4Q+EWNRrxXAo2+/JlZABHc0nnNHLckybReBlDjxAcxjFpJGM
	v9oWfeEywqHvK8z6TmlnCITZK8pSRzs=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Tejun Heo <tj@kernel.org>,
  Johannes Weiner <hannes@cmpxchg.org>,  Michal Hocko <mhocko@kernel.org>,
  Muchun Song <muchun.song@linux.dev>,  Alexei Starovoitov
 <ast@kernel.org>,  Peilin Ye <yepeilin@google.com>,  Kumar Kartikeya
 Dwivedi <memxor@gmail.com>,  bpf@vger.kernel.org,  linux-mm@kvack.org,
  cgroups@vger.kernel.org,  linux-kernel@vger.kernel.org,  Meta kernel team
 <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: skip cgroup_file_notify if spinning is not allowed
In-Reply-To: <mai3ndkvqrpkfpblkazbyejvpkizrp7dh22374tpkmepfji32o@3troawzsuvqe>
	(Shakeel Butt's message of "Fri, 5 Sep 2025 14:31:13 -0700")
References: <20250905201606.66198-1-shakeel.butt@linux.dev>
	<87y0qsa95d.fsf@linux.dev>
	<mai3ndkvqrpkfpblkazbyejvpkizrp7dh22374tpkmepfji32o@3troawzsuvqe>
Date: Fri, 05 Sep 2025 14:42:01 -0700
Message-ID: <87ecska85y.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E8E96100003
X-Stat-Signature: ypoe37ma1sf8kmgo59e3go87oiunxbt3
X-Rspam-User: 
X-HE-Tag: 1757108533-152007
X-HE-Meta: U2FsdGVkX19fAJf8tA5Fkl3kccCzxirOBMmN7mC6FmFwKEzJhrHTBVTzssazNLxXsldoOEM5QbUmGtONkIBd+pPPBLGHU2LlSi/o9s7LQeyljr1l/R28PKgnPDHLqSHOufOCdwNBmZAC92zqe0x62S/8p+bCsHxrnaIGXKSTM0gX4S98E9vZ1VhKml70L7I/7d2pIw8Ml5NLrtX+lcNWxEBrw17Fskf0h6K8PDzRALmPljWELeW+/hAQpvOcto6O3n4y95sHalXTUE3yZO7rcR76FXRA640CKYHDHwcvLfLxVmCCGg+LCAThnTZ7XodToDV+iopdqhMghf1KQOSHMS9e+asd9OE2qkjqsDV+AtiZR18vg+CrPhM988rth6BumqMaM2AHLVViGfcYk0BtjgUutJJ0TFFtHc43P5lhdnZWcyM8sk7cvbqEC040CXHTgJyUE57dEYblmEWr19aJh9CKUuZGNno6cgn25K4SaaMh7YljDVE9sbJsjjC+mmZ2CpinC5vY5GLebWZPMdSOhcDe7hmSTWLmuFRE0QcTNW9hHI9yeKKnFThirH3UwpsAN1RqUhWjfVVu6I9TMYbLd95pXxqQKMxBo16uLxgZG8nNjviXLCCuffro+4rbvXgvlFSmRLwOsOl/75XeM8Urt3nGA3I+L1DtYasqg8JauhQliCdvYKxYiVxPlMdAKSi/7TG1Lg3fJ5E0VXLHEfkTje4RJ5EbsYVNEoZKWCxUttq30h0wmANzk4juVAGnzAmAABQvTcyxCQyfZQ8CTlR5rUVJ6lHuupT7a0SH0eMgh9zDCbZqb1X1ndi34k3cs3MmL2PhQn0RmQwIhcLYj6dbxiUP/DbrKlSjpMWB6qCU1/n10IQP0JzF8wT4l4UW26QjOZ6NYI7RrVHDYnegWtZawkC+aK5c6CXp+vNwEpj119HtmsRaDZIcQS5lf1EIBQPAkXHeTFA3KRvz+2HUZdO
 FuD00o1Y
 hseXshTBTR+YZstk1RQ55BN5eO8z/aA3He9xwpL3V2gTPmLFd2c1dI66if0b6XgAqF5nDrQ6q2vGuuwnnJJSyG1aodnhjAMtXNQcJTCVbAMQCqme5qeM/SryNvJL8Hvvmd7c3zkWm0ErjUoUyh9fhBQka3D6LoOtdHwzg6pw7ridmBkIz3H3s27t5x3R6ILGQVnrLyEh+MtD/PnM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shakeel Butt <shakeel.butt@linux.dev> writes:

> On Fri, Sep 05, 2025 at 02:20:46PM -0700, Roman Gushchin wrote:
>> Shakeel Butt <shakeel.butt@linux.dev> writes:
>> 
>> > Generally memcg charging is allowed from all the contexts including NMI
>> > where even spinning on spinlock can cause locking issues. However one
>> > call chain was missed during the addition of memcg charging from any
>> > context support. That is try_charge_memcg() -> memcg_memory_event() ->
>> > cgroup_file_notify().
>> >
>> > The possible function call tree under cgroup_file_notify() can acquire
>> > many different spin locks in spinning mode. Some of them are
>> > cgroup_file_kn_lock, kernfs_notify_lock, pool_workqeue's lock. So, let's
>> > just skip cgroup_file_notify() from memcg charging if the context does
>> > not allow spinning.
>> 
>> Hmm, what about OOM events? Losing something like MEMCG_LOW doesn't look
>> like a bit deal, but OOM events can be way more important.
>> 
>> Should we instead preserve the event (e.g. as a pending_event_mask) and
>> raise it on the next occasion / from a different context?
>>
>
> Thanks for the review. For now only MAX can happen in non-spinning
> context. All others only happen in process context. Maybe with BPF OOM,
> OOM might be possible in a different context (is that what you are
> thinking?). I think we can add the complexity of preserving the event
> when the actual need arise.

No, I haven't thought about any particular use case, just a bit
worried about silently dropping some events. It might be not an issue
now, but might be easy to miss a moment when it becomes a problem.

So in my opinion using some delayed delivery mechanism is better
than just dropping these events.

