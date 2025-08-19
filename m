Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE71BCA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 20:16:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BB246B00D9; Tue, 19 Aug 2025 16:16:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66BEE6B00DA; Tue, 19 Aug 2025 16:16:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55A7C6B00DB; Tue, 19 Aug 2025 16:16:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3EDE86B00D9
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 16:16:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D698D1401F6
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 20:16:44 +0000 (UTC)
X-FDA: 83794615128.18.9305F6A
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id EB95CC0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 20:16:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jc6p9mvm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755634603; a=rsa-sha256;
	cv=none;
	b=l6faSeudhrrjj+EI0Rrq1GHNw+Dnc2c3uFbvk3LdztL+BYj0f/UZBIm75rLNbwuYP1ibUz
	aPL5Mx1gJ4mBHsSbi06clvMEmYOJMO2fLyKIPmhgKX/xe7HBp+9qUAein1N3E8yt0HKrEF
	CPA7RYOgHQO/VN97bYAcmQSJUDAZN+I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jc6p9mvm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755634603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JqbB3H+IOvqAzvYEg/c7+VdVr8vD6PumH4PG2on0onk=;
	b=Ezad9KE1i91Gakv+oijYak1f3DHMK5lalR6XXCfQObFRsj/yVSh3BI5t3a4M5i3o/K42fI
	7XQLEPr4R4jX/c0nuiFrzFrAjqSmuic+qd0bm0gwH3NVi2QzVpbikZL//54SX9SRgXQ5NY
	W60einoh77PSVFLoddGF/A87KcUnJ40=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755634601;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JqbB3H+IOvqAzvYEg/c7+VdVr8vD6PumH4PG2on0onk=;
	b=jc6p9mvmzAAxtUOk1Rl3nqhHXLTv28gZeOudhcu3Cs/7o0QHDQm830galIumRVJf11TdYU
	MpQhTSYtWIW+fwvpqjeo2YRTOsNkduSprMPk+w3CEXSIF5COP9hRD5+OmtHii7bR32eviT
	BwLcrgjM/id8VJCcmz0+hNbNwbK51GY=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org,  bpf@vger.kernel.org,  Johannes Weiner
 <hannes@cmpxchg.org>,  Michal Hocko <mhocko@suse.com>,  David Rientjes
 <rientjes@google.com>,  Matt Bobrowski <mattbobrowski@google.com>,  Song
 Liu <song@kernel.org>,  Kumar Kartikeya Dwivedi <memxor@gmail.com>,
  Alexei Starovoitov <ast@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 06/14] mm: introduce bpf_out_of_memory() bpf kfunc
In-Reply-To: <CAJuCfpHTtLQR0NpsbFytaOdEc0KqNv6PxVpxNetYD6Ce4sY9UQ@mail.gmail.com>
	(Suren Baghdasaryan's message of "Mon, 18 Aug 2025 21:09:24 -0700")
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
	<20250818170136.209169-7-roman.gushchin@linux.dev>
	<CAJuCfpHTtLQR0NpsbFytaOdEc0KqNv6PxVpxNetYD6Ce4sY9UQ@mail.gmail.com>
Date: Tue, 19 Aug 2025 13:16:30 -0700
Message-ID: <87wm6zysm9.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: EB95CC0002
X-Stat-Signature: dg3kynhhr8qb8t59ppmah3cwzppzc8kc
X-HE-Tag: 1755634602-87239
X-HE-Meta: U2FsdGVkX194wh0tq+b5jNEHTRuf/hI1S6/Sxaz6RNHeeicckYCK5qb2PuxH0SeOx8HBZKn2/mdbZOZBTHJ8bfizMLN++LHf55RsymQM4W01PXrg/Lf+aCWaFLe646hWBMR2eUWZcTaeUzospGXOVdS1dUGD0l2l74dl8eiKXBcEgtPIOwugirbnkkWshKVsVZ8OFBItm+Rwl+/n7AetzWxVRVMx4HJiXaAqZZQ3OxVnwIiuVHL4f/tsVHOMD3Rwc+vFNDhb9hcnFX/HLlsqpSub/QoTfeKblLJHWdvOpfQe3Ra3LbmJXPXXNZNZw5EUV+aBsGJI1ZPUyzdwj13k6/Byq23qUqJLFsgAVjeLTkrZm49pYy4wApUOFccvpBR5PuXGjpK0wHe857xxFSFCe34iVpgzRkXMVSL2wm1VfpT0thwwXgkm8KPjoLrg0fIDPp6QXbkmJqYtxPs2V1Tb22DLAu+bWNihmyuEc+tr0/dLdk1wJAobt8cIQQ+Xh0pI18brCjc9OYegfaZS+qpmSBE7CeBAtQoP5X9dVYq32Ew1eocGPUo3XbSOfcthw+UEwyyf24JckoOeUt0Y8j8yjrXjvpjMx4fqwww2BVWqChTJUCg5aMmjmNFHVgGn8qANTR9R7ugoiuDwtkfH5OldUxv/hjkInny7P/Aq0F8WteGWwS3tAZ/yK0DH09h5yCdt6QzzzYYuzbRMMIc7NiKXts3n5LVh3Qy1Lz228zZbwzbGDeUIVcP3N+dQln5MD56azWIi+i6Q5YoRUD1CmxYh4nuOEbEmm7ZUCY/ZvtnNB7nIXtiJAJIRKTxRUWuTKhK4pVYCRv0lCAdi1e2wd7T/2+KJQHpyd8dNSxIguDTfm3kjsBgDa1g4iAdb29vnZ3sA+Id99P7s8AK9zB3YdkIeSdM567iKVYCdXSfF/F3trzGH22xDNaZf4eeccxhJq4cMYM3N31wekUZrzoOvnth
 ZPO7lP7h
 tnh+xwydle214+J39DiM1MQ8ZOGJo/4x7lU1A3RE+QeXm+2CqzsL/WVLX5cobvsH9AziTdpwk3jw1dNBiCnhDQF+7d0Td4tRC2iNaD6jCCEL/gMmOayRXlZxzftx6A5JpS+nZGGAyuKt/dB5viDgbNmmfm9tveTgoVtd+y/ylrNgyR+xM9oOMpFAOe0xDX5e31ir3A90gzstKK31M7vagkDZEoR1ja+AGpKDpO1G8vVUvijL9dnJqHJ1a0wJd19E5V6Z8ks+Pc89a64vQDqcL3VCxTg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Suren Baghdasaryan <surenb@google.com> writes:

> On Mon, Aug 18, 2025 at 10:02=E2=80=AFAM Roman Gushchin
> <roman.gushchin@linux.dev> wrote:
>>
>> Introduce bpf_out_of_memory() bpf kfunc, which allows to declare
>> an out of memory events and trigger the corresponding kernel OOM
>> handling mechanism.
>>
>> It takes a trusted memcg pointer (or NULL for system-wide OOMs)
>> as an argument, as well as the page order.
>>
>> If the wait_on_oom_lock argument is not set, only one OOM can be
>> declared and handled in the system at once, so if the function is
>> called in parallel to another OOM handling, it bails out with -EBUSY.
>> This mode is suited for global OOM's: any concurrent OOMs will likely
>> do the job and release some memory. In a blocking mode (which is
>> suited for memcg OOMs) the execution will wait on the oom_lock mutex.
>>
>> The function is declared as sleepable. It guarantees that it won't
>> be called from an atomic context. It's required by the OOM handling
>> code, which is not guaranteed to work in a non-blocking context.
>>
>> Handling of a memcg OOM almost always requires taking of the
>> css_set_lock spinlock. The fact that bpf_out_of_memory() is sleepable
>> also guarantees that it can't be called with acquired css_set_lock,
>> so the kernel can't deadlock on it.
>>
>> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
>> ---
>>  mm/oom_kill.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 45 insertions(+)
>>
>> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
>> index 25fc5e744e27..df409f0fac45 100644
>> --- a/mm/oom_kill.c
>> +++ b/mm/oom_kill.c
>> @@ -1324,10 +1324,55 @@ __bpf_kfunc int bpf_oom_kill_process(struct oom_=
control *oc,
>>         return 0;
>>  }
>>
>> +/**
>> + * bpf_out_of_memory - declare Out Of Memory state and invoke OOM killer
>> + * @memcg__nullable: memcg or NULL for system-wide OOMs
>> + * @order: order of page which wasn't allocated
>> + * @wait_on_oom_lock: if true, block on oom_lock
>> + * @constraint_text__nullable: custom constraint description for the OO=
M report
>> + *
>> + * Declares the Out Of Memory state and invokes the OOM killer.
>> + *
>> + * OOM handlers are synchronized using the oom_lock mutex. If wait_on_o=
om_lock
>> + * is true, the function will wait on it. Otherwise it bails out with -=
EBUSY
>> + * if oom_lock is contended.
>> + *
>> + * Generally it's advised to pass wait_on_oom_lock=3Dtrue for global OO=
Ms
>> + * and wait_on_oom_lock=3Dfalse for memcg-scoped OOMs.
>
> From the changelog description I was under impression that it's vice
> versa, for global OOMs you would not block (wait_on_oom_lock=3Dfalse),
> for memcg ones you would (wait_on_oom_lock=3Dtrue).

Good catch, fixed.

>
>> + *
>> + * Returns 1 if the forward progress was achieved and some memory was f=
reed.
>> + * Returns a negative value if an error has been occurred.
>
> s/has been occurred/has occurred or occured

Same here.

Thanks!

