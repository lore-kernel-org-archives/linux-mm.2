Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A89DCA0FF2
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 16:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D52EB6B02B6; Tue, 26 Aug 2025 12:23:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2AE26B02B7; Tue, 26 Aug 2025 12:23:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C406A6B02B8; Tue, 26 Aug 2025 12:23:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AE9326B02B6
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:23:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7D478B6F25
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 16:23:48 +0000 (UTC)
X-FDA: 83819429736.30.9F7FE50
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id 95EDF1C000A
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 16:23:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="F60zNd/g";
	spf=pass (imf20.hostedemail.com: domain of ameryhung@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ameryhung@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756225426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mbmFneshoTIpSjsddxrK5zLZgEWoOLU1TnIvwRJ2jIk=;
	b=xH64jfTittCAxCAq+3pgyrFdWFsyM4B6WlZJ+++8QfdUSLT1AnSn9WOqT7lxiPXe0AgyH/
	X3KhfouVbzwfaMJgFPHx+Wu3nZwOj/gZBOsspUrCpLjweb+rszYz9T8idyPOOcOpQu6lvj
	kMFyz8w5War34brq331cae02T6grE/A=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="F60zNd/g";
	spf=pass (imf20.hostedemail.com: domain of ameryhung@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=ameryhung@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756225426; a=rsa-sha256;
	cv=none;
	b=nwF9BWtQ8ZHRkXViIEfzVy8HwD/HPCGoj1KZdzphRMtuaHE6hZ84UQnHKsYQp0qokgsEi9
	edplH/IY8PWMGm25KF+Ak5RFuucmL7RJYvAPxOZUsT8qhTmUpETqrvWh3KZIuDRc4sCI7e
	rmsUqnYvkn6k4oFGQdaYNN+SEde2nYU=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-76e434a0118so6770220b3a.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756225425; x=1756830225; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mbmFneshoTIpSjsddxrK5zLZgEWoOLU1TnIvwRJ2jIk=;
        b=F60zNd/gLxylIdQ9JNikaPCJI+R8vNuFC8pbVUXiCSizpDhEGwCn004rb3BWbSuyO8
         XfK6T/FJxLf5s04u9XHCqISgqN5Uc6QiChGpAKihXhqW4yh5aNe5s91SMW5SsMyk7XzV
         FW4oElafRBT35kD5BYQ7kXiNZ1CWpRleKJevISr95c11Mp5PSFwguMImoqSs6oYMLiiY
         COeoJhlRME9UHLydQfrQdSlXAM81JaTbXGw9lZY6/KuMhE0VCft2llMAZsK1KlLMFJHT
         tpQ6Gry/QgmHM5j+Hvwi+2d6MmvgzabFNGRBYEiGTRVDlDFpIsvnSOWi1C+HzccOBvcm
         wjOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756225425; x=1756830225;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mbmFneshoTIpSjsddxrK5zLZgEWoOLU1TnIvwRJ2jIk=;
        b=jzHoYJEOqvG73YEJQ7qE9natrRJfJSB6YOq0iB86NHdUZZZvy5AI3wYKNzt40r6GQQ
         vFllWdnZft4MNwxdugZwW2J0/fS9eFX4YDWKtYE0oYcGTj8objkikA9dyGHT17xyD/OD
         2942xV13PBBIU4utueqHqvL+mSQy//doGCkuLLTJy5Xx/NbuFMVMmUVSdXNYRt6HMht2
         zbhnnLIc+9Fi4HnU1Fm1LxsE7J3tbP7PojyEsrssixla3EennjDJXimESTAmwhw6MjVl
         lEo0X4O/s43fwDyC6xLc5r28zN210eN4cf3nXAaUg/iplwYa4KV/5LzPUhdIraGRYdoU
         R0ug==
X-Gm-Message-State: AOJu0YwcLDnY5qu/CUcdhfVfPDtbkx49iA2ZlGUD8guEgGb7jAyGEfpc
	OU7poSHPIyaQOv0lE6tbdSUQ6Hg1WtmouL9XueT4e/GsL+VO0257IQkx
X-Gm-Gg: ASbGncsKU889/B3MA6aqI3HPZ5nSO/pCvaa9vKcbtwWqOxSrInY2SE3YvGVLPBPeykK
	JqDQibv37gBSiXOfFZ/VfnO7V9ZVLUTGuWWn3GBqmgpPTFvhlh1CXDWAiRW/17G9rwCgnQw+k0m
	b8u3rE2RbzTfj+kqwc36uPjXtcvQnVsMjRTW6USPb0jKZBMgiS9NkgaLmPob+El6mBCSOgkgIzS
	ueWUGng3wZGlRpdgD8WqrBi0nl91C9SE9As/zHy1wytHxE7i4xsfXVLwOBHz/RfF24MMbspn0fp
	a9mWC1Sx9jhzbpcQa9hynD4jrMxg4D8ODqLsbFmRCADWVWPyol/Ky7fZ/3jqzJalsSl7VV69irU
	HnA53yD7iqCX+sN+00uSmvJQ5xI7Jua8eqRjq4k7m5d7BXIxOM5vrLwr1uikrkzO9aC9Lw6cPdL
	/t
X-Google-Smtp-Source: AGHT+IEH7VEUzI9tKUdXTifEnPc+6oiViRLJY1/GN4MNA6FfwnWXAWpVjWzWt+5dYTW8jJy1IAd/cg==
X-Received: by 2002:a05:6a20:7b30:b0:243:7664:5e43 with SMTP id adf61e73a8af0-2437664631cmr9793984637.36.1756225425166;
        Tue, 26 Aug 2025 09:23:45 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1156:a:14b0:ff2b:98c1:659? ([2620:10d:c090:500::4:9299])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cb8b4b98sm9572268a12.19.2025.08.26.09.23.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 09:23:44 -0700 (PDT)
Message-ID: <6dee135b-bf94-48a4-816f-629de071709b@gmail.com>
Date: Tue, 26 Aug 2025 09:23:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
To: Suren Baghdasaryan <surenb@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, bpf@vger.kernel.org,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>,
 David Rientjes <rientjes@google.com>,
 Matt Bobrowski <mattbobrowski@google.com>, Song Liu <song@kernel.org>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
 <20250818170136.209169-2-roman.gushchin@linux.dev>
 <CAJuCfpF2akVnbZgPoDAXea2joJ1DWvBTHC7wGzEJcYX9xF9dSA@mail.gmail.com>
 <878qjf13gx.fsf@linux.dev>
 <CAJuCfpFT1oo0+9f_XQa29UeZseLNNbwc19pLbG0MOthgxrtVuQ@mail.gmail.com>
Content-Language: en-US
From: Amery Hung <ameryhung@gmail.com>
In-Reply-To: <CAJuCfpFT1oo0+9f_XQa29UeZseLNNbwc19pLbG0MOthgxrtVuQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 95EDF1C000A
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: jr4r5ofp9498q4jfp58tg8w64ffxdgcg
X-HE-Tag: 1756225426-676474
X-HE-Meta: U2FsdGVkX19Jo2NeeYB+DHgM/hbnDTmwtaB/Fu0LUHilmfR+jcLnmuXJdZUCm7NxxQZDBJ6F7bJSP8ywmLUMS33YkMPQgeqWFx2+HXi8Cx0gscVwNja8JEhYVuUI9ccQ/AP6hk9v65diU3C6D4kr0355U0Zmn1hWgl5D72DyvwW+co7HjvX1ZFiqF8M/yWO8J7bvbK1wJX3oihy7UGoD+Dmc+C07D7l4E5dCk7NTodoCMDX62UcztateY4BR/9S+71GrN9C0E9B2Scs1f1SIi5LDJOQ83rvAxZ8CFIMH+/wA7XOSSyKx13rr5nnOTpVYLx8A4iGB7azieAWUHk+a8iaTQqTLIqZ9NM6BtGGifFUrt6aVAvNqPtTpF6cienMW0Ds/9JKVN+bvfRLMDnbvQPtNeid2G6NkQ7sQMSNp5oylFhdP1Ag4D42EFFvYJj/kg9EVL33C/zYEmBZc/6aPYweWn1HHC/YiwQBGInX74nndG2tDBHefUXa4rgwXnDQ19y6hJmtul98u4BQpkens/r3IJbGlLft3D5LC/Li/883wqDReKxW7mVuDZ4EHg9ckQv6NgBlqut2aUm05+6sEsEnT9xDwPHGiC2mbA0bohKN2p8T+41lPqD7jRichuhvqCzLg0LtJWNJfBMe1qJUkMwsdph32Fvcz/jA2c7Nmtk9j6q+Pd87ZKUc5ekGYvAJPggJMXhd+dxrvPIZ7ULaTFRFcu5TiPYcwlQHcj7OAxAfblrwhE0nnpotV3HAJjo8SdUlwCjsg0WOvaDjQetyaylDSA9o04JcKmN190Lxa6SNOgTHIijBw2EXMWgmvfl2TdLf1yMDmt2PJ69/G9ByllaIL69PgrHtIansAsHcQhSsI7VqdpMDlq/gKX9OmySrBl7F9DePPIUEQ6hKJ/+ahge7LYAEMwQG+oHk3hNVWx9B8q00yscCEpRDyugqeRzgQZYJ3+e/HlUDaQpy24p9
 KpwtuUkx
 sG6JnRcuMNfOdUMylHIt2bYs2tocQqAM8UxGubUQyxncgLgmU1nb1z9vW0g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/20/25 12:34 PM, Suren Baghdasaryan wrote:
> On Tue, Aug 19, 2025 at 1:06 PM Roman Gushchin <roman.gushchin@linux.dev> wrote:
>> Suren Baghdasaryan <surenb@google.com> writes:
>>
>>> On Mon, Aug 18, 2025 at 10:01 AM Roman Gushchin
>>> <roman.gushchin@linux.dev> wrote:
>>>> Introduce a bpf struct ops for implementing custom OOM handling policies.
>>>>
>>>> The struct ops provides the bpf_handle_out_of_memory() callback,
>>>> which expected to return 1 if it was able to free some memory and 0
>>>> otherwise.
>>>>
>>>> In the latter case it's guaranteed that the in-kernel OOM killer will
>>>> be invoked. Otherwise the kernel also checks the bpf_memory_freed
>>>> field of the oom_control structure, which is expected to be set by
>>>> kfuncs suitable for releasing memory. It's a safety mechanism which
>>>> prevents a bpf program to claim forward progress without actually
>>>> releasing memory. The callback program is sleepable to enable using
>>>> iterators, e.g. cgroup iterators.
>>>>
>>>> The callback receives struct oom_control as an argument, so it can
>>>> easily filter out OOM's it doesn't want to handle, e.g. global vs
>>>> memcg OOM's.
>>>>
>>>> The callback is executed just before the kernel victim task selection
>>>> algorithm, so all heuristics and sysctls like panic on oom,
>>>> sysctl_oom_kill_allocating_task and sysctl_oom_kill_allocating_task
>>>> are respected.
>>>>
>>>> The struct ops also has the name field, which allows to define a
>>>> custom name for the implemented policy. It's printed in the OOM report
>>>> in the oom_policy=<policy> format. "default" is printed if bpf is not
>>>> used or policy name is not specified.
>>>>
>>>> [  112.696676] test_progs invoked oom-killer: gfp_mask=0xcc0(GFP_KERNEL), order=0, oom_score_adj=0
>>>>                 oom_policy=bpf_test_policy
>>>> [  112.698160] CPU: 1 UID: 0 PID: 660 Comm: test_progs Not tainted 6.16.0-00015-gf09eb0d6badc #102 PREEMPT(full)
>>>> [  112.698165] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-5.fc42 04/01/2014
>>>> [  112.698167] Call Trace:
>>>> [  112.698177]  <TASK>
>>>> [  112.698182]  dump_stack_lvl+0x4d/0x70
>>>> [  112.698192]  dump_header+0x59/0x1c6
>>>> [  112.698199]  oom_kill_process.cold+0x8/0xef
>>>> [  112.698206]  bpf_oom_kill_process+0x59/0xb0
>>>> [  112.698216]  bpf_prog_7ecad0f36a167fd7_test_out_of_memory+0x2be/0x313
>>>> [  112.698229]  bpf__bpf_oom_ops_handle_out_of_memory+0x47/0xaf
>>>> [  112.698236]  ? srso_alias_return_thunk+0x5/0xfbef5
>>>> [  112.698240]  bpf_handle_oom+0x11a/0x1e0
>>>> [  112.698250]  out_of_memory+0xab/0x5c0
>>>> [  112.698258]  mem_cgroup_out_of_memory+0xbc/0x110
>>>> [  112.698274]  try_charge_memcg+0x4b5/0x7e0
>>>> [  112.698288]  charge_memcg+0x2f/0xc0
>>>> [  112.698293]  __mem_cgroup_charge+0x30/0xc0
>>>> [  112.698299]  do_anonymous_page+0x40f/0xa50
>>>> [  112.698311]  __handle_mm_fault+0xbba/0x1140
>>>> [  112.698317]  ? srso_alias_return_thunk+0x5/0xfbef5
>>>> [  112.698335]  handle_mm_fault+0xe6/0x370
>>>> [  112.698343]  do_user_addr_fault+0x211/0x6a0
>>>> [  112.698354]  exc_page_fault+0x75/0x1d0
>>>> [  112.698363]  asm_exc_page_fault+0x26/0x30
>>>> [  112.698366] RIP: 0033:0x7fa97236db00
>>>>
>>>> It's possible to load multiple bpf struct programs. In the case of
>>>> oom, they will be executed one by one in the same order they been
>>>> loaded until one of them returns 1 and bpf_memory_freed is set to 1
>>>> - an indication that the memory was freed. This allows to have
>>>> multiple bpf programs to focus on different types of OOM's - e.g.
>>>> one program can only handle memcg OOM's in one memory cgroup.
>>>> But the filtering is done in bpf - so it's fully flexible.
>>>>
>>>> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
>>>> ---
>>>>   include/linux/bpf_oom.h |  49 +++++++++++++
>>>>   include/linux/oom.h     |   8 ++
>>>>   mm/Makefile             |   3 +
>>>>   mm/bpf_oom.c            | 157 ++++++++++++++++++++++++++++++++++++++++
>>>>   mm/oom_kill.c           |  22 +++++-
>>>>   5 files changed, 237 insertions(+), 2 deletions(-)
>>>>   create mode 100644 include/linux/bpf_oom.h
>>>>   create mode 100644 mm/bpf_oom.c
>>>>
>>>> diff --git a/include/linux/bpf_oom.h b/include/linux/bpf_oom.h
>>>> new file mode 100644
>>>> index 000000000000..29cb5ea41d97
>>>> --- /dev/null
>>>> +++ b/include/linux/bpf_oom.h
>>>> @@ -0,0 +1,49 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0+ */
>>>> +
>>>> +#ifndef __BPF_OOM_H
>>>> +#define __BPF_OOM_H
>>>> +
>>>> +struct bpf_oom;
>>>> +struct oom_control;
>>>> +
>>>> +#define BPF_OOM_NAME_MAX_LEN 64
>>>> +
>>>> +struct bpf_oom_ops {
>>>> +       /**
>>>> +        * @handle_out_of_memory: Out of memory bpf handler, called before
>>>> +        * the in-kernel OOM killer.
>>>> +        * @oc: OOM control structure
>>>> +        *
>>>> +        * Should return 1 if some memory was freed up, otherwise
>>>> +        * the in-kernel OOM killer is invoked.
>>>> +        */
>>>> +       int (*handle_out_of_memory)(struct oom_control *oc);
>>>> +
>>>> +       /**
>>>> +        * @name: BPF OOM policy name
>>>> +        */
>>>> +       char name[BPF_OOM_NAME_MAX_LEN];
>>> Why should the name be a part of ops structure? IMO it's not an
>>> attribute of the operations but rather of the oom handler which is
>>> represented by bpf_oom here.
>> The ops structure describes a user-defined oom policy. Currently
>> it's just one handler and the policy name. Later additional handlers
>> can be added, e.g. a handler to control the dmesg output.
>>
>> bpf_oom is an implementation detail: it's basically an extension
>> to struct bpf_oom_ops which contains "private" fields required
>> for the internal machinery.
> Ok. I hope we can come up with some more descriptive naming but I
> can't think of something good ATM.
>
>>>> +
>>>> +       /* Private */
>>>> +       struct bpf_oom *bpf_oom;
>>>> +};
>>>> +
>>>> +#ifdef CONFIG_BPF_SYSCALL
>>>> +/**
>>>> + * @bpf_handle_oom: handle out of memory using bpf programs
>>>> + * @oc: OOM control structure
>>>> + *
>>>> + * Returns true if a bpf oom program was executed, returned 1
>>>> + * and some memory was actually freed.
>>> The above comment is unclear, please clarify.
>> Fixed, thanks.
>>
>> /**
>>   * @bpf_handle_oom: handle out of memory condition using bpf
>>   * @oc: OOM control structure
>>   *
>>   * Returns true if some memory was freed.
>>   */
>> bool bpf_handle_oom(struct oom_control *oc);
>>
>>
>>>> + */
>>>> +bool bpf_handle_oom(struct oom_control *oc);
>>>> +
>>>> +#else /* CONFIG_BPF_SYSCALL */
>>>> +static inline bool bpf_handle_oom(struct oom_control *oc)
>>>> +{
>>>> +       return false;
>>>> +}
>>>> +
>>>> +#endif /* CONFIG_BPF_SYSCALL */
>>>> +
>>>> +#endif /* __BPF_OOM_H */
>>>> diff --git a/include/linux/oom.h b/include/linux/oom.h
>>>> index 1e0fc6931ce9..ef453309b7ea 100644
>>>> --- a/include/linux/oom.h
>>>> +++ b/include/linux/oom.h
>>>> @@ -51,6 +51,14 @@ struct oom_control {
>>>>
>>>>          /* Used to print the constraint info. */
>>>>          enum oom_constraint constraint;
>>>> +
>>>> +#ifdef CONFIG_BPF_SYSCALL
>>>> +       /* Used by the bpf oom implementation to mark the forward progress */
>>>> +       bool bpf_memory_freed;
>>>> +
>>>> +       /* Policy name */
>>>> +       const char *bpf_policy_name;
>>>> +#endif
>>>>   };
>>>>
>>>>   extern struct mutex oom_lock;
>>>> diff --git a/mm/Makefile b/mm/Makefile
>>>> index 1a7a11d4933d..a714aba03759 100644
>>>> --- a/mm/Makefile
>>>> +++ b/mm/Makefile
>>>> @@ -105,6 +105,9 @@ obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
>>>>   ifdef CONFIG_SWAP
>>>>   obj-$(CONFIG_MEMCG) += swap_cgroup.o
>>>>   endif
>>>> +ifdef CONFIG_BPF_SYSCALL
>>>> +obj-y += bpf_oom.o
>>>> +endif
>>>>   obj-$(CONFIG_CGROUP_HUGETLB) += hugetlb_cgroup.o
>>>>   obj-$(CONFIG_GUP_TEST) += gup_test.o
>>>>   obj-$(CONFIG_DMAPOOL_TEST) += dmapool_test.o
>>>> diff --git a/mm/bpf_oom.c b/mm/bpf_oom.c
>>>> new file mode 100644
>>>> index 000000000000..47633046819c
>>>> --- /dev/null
>>>> +++ b/mm/bpf_oom.c
>>>> @@ -0,0 +1,157 @@
>>>> +// SPDX-License-Identifier: GPL-2.0-or-later
>>>> +/*
>>>> + * BPF-driven OOM killer customization
>>>> + *
>>>> + * Author: Roman Gushchin <roman.gushchin@linux.dev>
>>>> + */
>>>> +
>>>> +#include <linux/bpf.h>
>>>> +#include <linux/oom.h>
>>>> +#include <linux/bpf_oom.h>
>>>> +#include <linux/srcu.h>
>>>> +
>>>> +DEFINE_STATIC_SRCU(bpf_oom_srcu);
>>>> +static DEFINE_SPINLOCK(bpf_oom_lock);
>>>> +static LIST_HEAD(bpf_oom_handlers);
>>>> +
>>>> +struct bpf_oom {
>>> Perhaps bpf_oom_handler ? Then bpf_oom_ops->bpf_oom could be called
>>> bpf_oom_ops->handler.
>> I don't think it's a handler, it's more like a private part
>> of bpf_oom_ops. Maybe bpf_oom_impl? Idk
> Yeah, we need to come up with some nomenclature and name these structs
> accordingly. In my mind ops means a structure that contains only
> operations, so current naming does not sit well but maybe that's just
> me...

Some existing xxx_ops also have non-operation members. E.g., 
tcp_congestion_ops, Qdisc_ops, vfio_device_ops, or tpm_class_ops. Maybe 
bpf_oom_ops is okay if that doesn't cause too much confusion?

>
>>>
>>>> +       struct bpf_oom_ops *ops;
>>>> +       struct list_head node;
>>>> +       struct srcu_struct srcu;
>>>> +};
>>>> +
>>>> +bool bpf_handle_oom(struct oom_control *oc)
>>>> +{
>>>> +       struct bpf_oom_ops *ops;
>>>> +       struct bpf_oom *bpf_oom;
>>>> +       int list_idx, idx, ret = 0;
>>>> +
>>>> +       oc->bpf_memory_freed = false;
>>>> +
>>>> +       list_idx = srcu_read_lock(&bpf_oom_srcu);
>>>> +       list_for_each_entry_srcu(bpf_oom, &bpf_oom_handlers, node, false) {
>>>> +               ops = READ_ONCE(bpf_oom->ops);
>>>> +               if (!ops || !ops->handle_out_of_memory)
>>>> +                       continue;
>>>> +               idx = srcu_read_lock(&bpf_oom->srcu);
>>>> +               oc->bpf_policy_name = ops->name[0] ? &ops->name[0] :
>>>> +                       "bpf_defined_policy";
>>>> +               ret = ops->handle_out_of_memory(oc);
>>>> +               oc->bpf_policy_name = NULL;
>>>> +               srcu_read_unlock(&bpf_oom->srcu, idx);
>>>> +
>>>> +               if (ret && oc->bpf_memory_freed)
>>> IIUC ret and oc->bpf_memory_freed seem to reflect the same state:
>>> handler successfully freed some memory. Could you please clarify when
>>> they differ?
>> The idea here is to provide an additional safety measure:
>> if the bpf program simple returns 1 without doing anything,
>> the system won't deadlock.
>>
>> oc->bpf_memory_freed is set by the bpf_oom_kill_process() helper
>> (and potentially some other helpers in the future, e.g.
>> bpf_oom_rm_tmpfs_file()) and can't be modified by the bpf
>> program directly.
> I see. Then maybe we use only oc->bpf_memory_freed and
> handle_out_of_memory() does not return anything?


