Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 189AECA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 21:02:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73F4A8E0006; Wed, 10 Sep 2025 17:02:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EEF98E0001; Wed, 10 Sep 2025 17:02:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DE018E0006; Wed, 10 Sep 2025 17:02:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B0518E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 17:02:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E718913A752
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 21:02:47 +0000 (UTC)
X-FDA: 83874564774.04.9151587
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf24.hostedemail.com (Postfix) with ESMTP id F0811180004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 21:02:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MFjD+YX8;
	spf=pass (imf24.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757538166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K1Cbhy+VanJPMX0Q1u/x/lX5tWRv6IISLLkoD+jnkuQ=;
	b=zbDMw3hIMOAJ7tLXE+eKrD8lQrJnl3qI7mYTInEi+mE4i1AqCByvlXCB0ujg23cQf3j5Zr
	GnqjlzIhjarvKJ5VmRAgWOiOp6MdWNpFfGk2/QLW/J4lKcnSFVPQEZ0a2qwYlMM5mZJGsL
	MZOBULXLHmatGPl5zl3RhAogg5CVQvI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MFjD+YX8;
	spf=pass (imf24.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.179 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757538166; a=rsa-sha256;
	cv=none;
	b=wfhM4/YPvo5fLWLi6Lvmn0fWGOSzrV19y2B0jmIaD2MJBZdUD+eyAKehmz1FXflObAhd6I
	nWp1DzxGzkzC+1C5bs3pUalXwribxLGBlELiY3JVqQqHdFK1BgvW+lT+9x+SisMMKJoboA
	wweYNBZ6P9Zo0NbunxofbNS4wbHtZk4=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8117aef2476so543947485a.1
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757538165; x=1758142965; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K1Cbhy+VanJPMX0Q1u/x/lX5tWRv6IISLLkoD+jnkuQ=;
        b=MFjD+YX8NiFt7Knm6KryzExLGox1zk65s/lrVNGKQc0Kh+cTvyMmlU3dwcjzIT8gq0
         5WyqasmfvQQMu8WZC8H6vlDFboghX71kDOI0zTlgxRNK66vbjoaTxabbQMlJz4+RCgZV
         WynRtGfPH0UsCh0MbsrDJIfS0KCot/eifBS5Yg9Fd7mIbRtXBQH1ynpdW8V4x67LCc2f
         rDRH9jmD7rNH1r4SqQYLC6D1JYfllo0jshj1wjCGt4BZfF0Mxb9nCVbpyzB/docazxEw
         YOoilzxwkhBvHqLFUFZZ7UIpscWJx7nPu+UOpFdhL+aV6NwNbA7ALRYHeGVjh80Y6LA5
         KIcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757538165; x=1758142965;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K1Cbhy+VanJPMX0Q1u/x/lX5tWRv6IISLLkoD+jnkuQ=;
        b=M0AKheU+oG+8dJA4yANKRMGnMVYoCkm2SSEBJBWoY8Wk0oN3sgOB24m08o9ZWpO0cw
         j+Tsp4yXnsxRK3631Kt/UjV6ZF2X/PJ51UyeiJR60evqgg+TeS3jbaVqiHaWV8kBD2GR
         oqSWf8Cfg+4MPdLWY4AHZDHU9VQrtyrA4RQZSlUhO0sXZEkxsweNHhI8jlX1WGzskHnz
         B8GTx085RV0e1jNhv0qLb+WzIBzS/vbsisnkXpiCtHIh4oa5uhT4jQAVhxTd6vNEcmZv
         hoelp7EFDlhHDxaqpmZ5MCMVItCeqVtbSEZqr+Bl6SfEjDyKbATOiUw+lITJFYbYo7UL
         9ThA==
X-Forwarded-Encrypted: i=1; AJvYcCX7Ix0UcgJA2SmLnvTmOeyyrhgf9w5KbG0n6ym1akaSjeHE04gQDWX1IK271vFIfeRWI9ztlACJUw==@kvack.org
X-Gm-Message-State: AOJu0Yy9zI/J4RM2gtZiCGlT1uoQMuZ5sl8zdnPDXbLqR8sHDELIRUBx
	7ulLqaQsai+G7iYKAR12hGeSJjQYTK4SCrudaIe+G8e6XSVTCAJPrz+/
X-Gm-Gg: ASbGncu2kd9QL/n0riwQ0JIJLoeA0xMeTxTfHLTcNLF+NsaQ67M7A1GuIqXLmbRC+sl
	AWY9j9JHIKXjeKwIR5ws4e4ox8xWPwtSHiQ5XX1daSzu6SlqDGKEbNOIzkZKjFMUpM3xuF2hoB9
	3L0jXdewSfQ+eak6k3vslSwojSK4dCMCBc0BMej5zrz+7w0yuq3h92C2P1pvZGSMxeqTdEuoafZ
	rAqLLjfGhSqssZgKliVtsGgj2qrtQDG1Se7t85ow7klwRSHznsLOdCnAj1z4A2PMVghjGRQEQI5
	CadamNBn39VvQekmyV6xqT+zZVtG72LSnX67VCmdTe+R5OfkkKxs8+aJ4Q1Kh4s6zzEFRcPlA/t
	QDZ1WdK8+Eoi5lu+aywEV4j66CrV/IAZBtVJvjrdesY22YenkF30=
X-Google-Smtp-Source: AGHT+IHlZ0IDGw1WASa6aDpHNf8Pgci8L2nEiRJ3kUYw3tN88C1KbvhkOPTx9cwxD3yo7KJ59NQSdw==
X-Received: by 2002:a05:620a:a101:b0:817:4e4a:6969 with SMTP id af79cd13be357-8174e68f614mr1358466985a.78.1757538164867;
        Wed, 10 Sep 2025 14:02:44 -0700 (PDT)
Received: from [172.20.7.106] ([63.116.149.204])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-81b5faec7bbsm353446785a.63.2025.09.10.14.02.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Sep 2025 14:02:44 -0700 (PDT)
Message-ID: <e073e41d-3317-49a9-a2ee-c0e8def66dcd@gmail.com>
Date: Wed, 10 Sep 2025 17:02:37 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
Content-Language: en-GB
To: Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, hannes@cmpxchg.org,
 rientjes@google.com, roman.gushchin@linux.dev, harry.yoo@oracle.com,
 shakeel.butt@linux.dev, 00107082@163.com, pasha.tatashin@soleen.com,
 souravpanda@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250909234942.1104356-1-surenb@google.com>
 <ff28f071-f448-4f25-bea0-17db946e0acf@suse.cz>
 <CAJuCfpFf+D1C9esHXpR5WaJ_4=JmvZkYQMWY7KVYf42JLDTFZQ@mail.gmail.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <CAJuCfpFf+D1C9esHXpR5WaJ_4=JmvZkYQMWY7KVYf42JLDTFZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u37gwkywg8zyn1myfburegmzfnmjojku
X-Rspam-User: 
X-Rspamd-Queue-Id: F0811180004
X-Rspamd-Server: rspam04
X-HE-Tag: 1757538165-675980
X-HE-Meta: U2FsdGVkX1/YxySjX4oDYlt9sKpyeKUqLwJM/FXXmuKeTOQAjx6A9m5zgKlM6/jW3WlB7fsSydklYxzAfNKOLU2/fW1YtyCRgcEsXgqqphczGo/BvAccgmD55WItz6MUGGaZT3ehRtxvhdtVI/oj8C9qK93eb0QlN+KE3E0shsCzdDPCVpV1NrdA4KU4STOHfA3YnbaUcI9JK01WF+88/5N7jrRe5xIgQlIkBwCaNIywgMHwvHmfPGp6nTUVFD+fPjWknxhWOh3Z9Uf79Qcl2l1hImZ30LAS4c7U1rIWBHFkIt1xtJFD8uL5/UbF2MqBAXg/A1IwQbbywZ0RSFk285P7Bh6GAILVtZ50yxeA+WTnl2e7Xy3xEs9Vr1DMLBZHWR1nxkuBiFAVW9Gw9QsDvm2IADT2je2c7qHdDMppGIeyBH/iZgtS//Cl4WEBg9pSb2/VpEb0oxaqyGZfsUy7IlgojLgCe0ESNShHh9hiDPcW9iThZe0lCO73jmDHHHOhJIYRrFxKydzm83uF5dp3ZWNpUA90rrcPpCaPASwG3B3dqKqTwTgI0WJqwPgtWlHV4G2d6qW/WR1mlAiuDRa0QQ6Hm4GFBVWFAfYiNDHSpKR7SqLOZzKpLhxvl3+rBzk4PmmnhXR+9Za+PmrUO6ofyXW/i61gYqPah1o0kOn+G0AFYmeHa+GV4faXCXkfrVcKrxZaMrNN/Ca4BMhbWNwxIeVCSlg2J3epp39MjhOBg1UlX2A3tm4jsBALhFPvWELHCDfIqJZm7vZgS2VVb4aQ//DxsLVK4+XmULdPtU0nSSLbkuhNdwEc9zKrPXNXOk8MqLiNBrbxaKkk78HicDUoXXa5I7U7lZWKwgJMW/HijpRRpxX5oA0lfkDRUHANFrLF0yarRyM7+8J8qVinPaMI5IqyKgBraMMm7+2C7f7T/phm3ZXV98/UI2gg2LsQ9jzPwy1OZecsTVmrICwzYvE
 HzjI01mQ
 UyT0LOdhtxiV4mPjtc5p8FyC8qDvLG+R4z6PEmZ2f+IBAuxpcoca2IidbYLldrI06triHILLwNXjJoj0WD4jgRFhbpTCeRp+2SoNxkSmAXxbd4+5tj7ehIT/MEF4ii3WJ3oWIrF447D8FEIVHcCV06xgMs2MCcolSSdnQR2eI8hJ8kdRb+WSLNliE3AfJAB+VgSQ7BbHoKxeOVkrvmFK4BRaRFu9/npotB05pAUR4LuV6w1Eyd4T8SVAcqn16BC5b5kjIUBbqJiKDWN57oC6wdgF7temtcTJGious3Qr+bUFbXqOt6KZ11P1BleU+pou7THk7NQE3I6tZ4B4YxE2W8KRZMRcFU76gU08fVgTvrPn63IBg6ihEu8XCyPen9HOOOFnjZRm3lhyPnlPQ0mtCMD1cMGJfozdN+OZPYZf2xMpIHW8TTLVfSp6SmRqfRNkrpwbC8Q54LKpWjC8KxuLMe4+XIqKp/HRRDCnRFF9oD6Uw4R6HQggSkOH0/zVe7KOaeYM44lp0foQs7MVmCrknkBW5AHK1DyehCRsw+BHLxyPn0R9L58fc2jo0+2U0YL4A0VhrIRoQp2pjgHmDfyrfERyVGaSSKykKH86sL5oBD8ZtxAkjD1klQz+87q6FdSCke0RIV7aum2aNkgAIqSRyJQOuon1qljk2OuII
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/09/2025 15:50, Suren Baghdasaryan wrote:
> On Tue, Sep 9, 2025 at 11:25 PM Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>> On 9/10/25 01:49, Suren Baghdasaryan wrote:
>>> While rare, memory allocation profiling can contain inaccurate counters
>>> if slab object extension vector allocation fails. That allocation might
>>> succeed later but prior to that, slab allocations that would have used
>>> that object extension vector will not be accounted for. To indicate
>>> incorrect counters, mark them with an asterisk in the /proc/allocinfo
>>> output.
>>> Bump up /proc/allocinfo version to reflect change in the file format.
>>
>> Since it's rare, is it worth the trouble?
> 
> Apparently they are seen in Meta's fleet which instigated this thread:
> https://lore.kernel.org/all/17fab2d6-5a74-4573-bcc3-b75951508f0a@gmail.com/
> 

Yes it happens on memory bound services!

>>
>>> Example output with invalid counters:
>>> allocinfo - version: 2.0
>>>            0        0 arch/x86/kernel/kdebugfs.c:105 func:create_setup_data_nodes
>>>            0        0 arch/x86/kernel/alternative.c:2090 func:alternatives_smp_module_add
>>>           0*       0* arch/x86/kernel/alternative.c:127 func:__its_alloc
>>>            0        0 arch/x86/kernel/fpu/regset.c:160 func:xstateregs_set
>>>            0        0 arch/x86/kernel/fpu/xstate.c:1590 func:fpstate_realloc
>>>            0        0 arch/x86/kernel/cpu/aperfmperf.c:379 func:arch_enable_hybrid_capacity_scale
>>>            0        0 arch/x86/kernel/cpu/amd_cache_disable.c:258 func:init_amd_l3_attrs
>>>       49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create
>>>        32768        1 arch/x86/kernel/cpu/mce/genpool.c:132 func:mce_gen_pool_create
>>>            0        0 arch/x86/kernel/cpu/mce/amd.c:1341 func:mce_threshold_create_device
>>>
>>> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
>>
>> Here a link might have been helpful :)
> 
> Right, here it is and suggestion is in the last paragraph:
> https://lore.kernel.org/all/20250519160846.GA773385@cmpxchg.org/
> 
>>
>>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>>> ---

Acked-by: Usama Arif <usamaarif642@gmail.com>

>>> Patch is based on mm-new.
>>>
>>>  include/linux/alloc_tag.h | 12 ++++++++++++
>>>  include/linux/codetag.h   |  5 ++++-
>>>  lib/alloc_tag.c           |  7 +++++--
>>>  mm/slub.c                 |  2 ++
>>>  4 files changed, 23 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
>>> index 9ef2633e2c08..d40ac39bfbe8 100644
>>> --- a/include/linux/alloc_tag.h
>>> +++ b/include/linux/alloc_tag.h
>>> @@ -221,6 +221,16 @@ static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes)
>>>       ref->ct = NULL;
>>>  }
>>>
>>> +static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
>>> +{
>>> +     tag->ct.flags |= CODETAG_FLAG_INACCURATE;
>>> +}
>>> +
>>> +static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
>>> +{
>>> +     return !!(tag->ct.flags & CODETAG_FLAG_INACCURATE);
>>> +}
>>> +
>>>  #define alloc_tag_record(p)  ((p) = current->alloc_tag)
>>>
>>>  #else /* CONFIG_MEM_ALLOC_PROFILING */
>>> @@ -230,6 +240,8 @@ static inline bool mem_alloc_profiling_enabled(void) { return false; }
>>>  static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag,
>>>                                size_t bytes) {}
>>>  static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes) {}
>>> +static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag) {}
>>> +static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag) { return false; }
>>>  #define alloc_tag_record(p)  do {} while (0)
>>>
>>>  #endif /* CONFIG_MEM_ALLOC_PROFILING */
>>> diff --git a/include/linux/codetag.h b/include/linux/codetag.h
>>> index 457ed8fd3214..8ea2a5f7c98a 100644
>>> --- a/include/linux/codetag.h
>>> +++ b/include/linux/codetag.h
>>> @@ -16,13 +16,16 @@ struct module;
>>>  #define CODETAG_SECTION_START_PREFIX "__start_"
>>>  #define CODETAG_SECTION_STOP_PREFIX  "__stop_"
>>>
>>> +/* codetag flags */
>>> +#define CODETAG_FLAG_INACCURATE      (1 << 0)
>>> +
>>>  /*
>>>   * An instance of this structure is created in a special ELF section at every
>>>   * code location being tagged.  At runtime, the special section is treated as
>>>   * an array of these.
>>>   */
>>>  struct codetag {
>>> -     unsigned int flags; /* used in later patches */
>>> +     unsigned int flags;
>>>       unsigned int lineno;
>>>       const char *modname;
>>>       const char *function;
>>> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
>>> index e9b33848700a..a7f15117c759 100644
>>> --- a/lib/alloc_tag.c
>>> +++ b/lib/alloc_tag.c
>>> @@ -80,7 +80,7 @@ static void allocinfo_stop(struct seq_file *m, void *arg)
>>>  static void print_allocinfo_header(struct seq_buf *buf)
>>>  {
>>>       /* Output format version, so we can change it. */
>>> -     seq_buf_printf(buf, "allocinfo - version: 1.0\n");
>>> +     seq_buf_printf(buf, "allocinfo - version: 2.0\n");
>>>       seq_buf_printf(buf, "#     <size>  <calls> <tag info>\n");
>>>  }
>>>
>>> @@ -90,7 +90,10 @@ static void alloc_tag_to_text(struct seq_buf *out, struct codetag *ct)
>>>       struct alloc_tag_counters counter = alloc_tag_read(tag);
>>>       s64 bytes = counter.bytes;
>>>
>>> -     seq_buf_printf(out, "%12lli %8llu ", bytes, counter.calls);
>>> +     if (unlikely(alloc_tag_is_inaccurate(tag)))
>>> +             seq_buf_printf(out, "%11lli* %7llu* ", bytes, counter.calls);
>>> +     else
>>> +             seq_buf_printf(out, "%12lli %8llu ", bytes, counter.calls);
>>>       codetag_to_text(out, ct);
>>>       seq_buf_putc(out, ' ');
>>>       seq_buf_putc(out, '\n');
>>> diff --git a/mm/slub.c b/mm/slub.c
>>> index af343ca570b5..9c04f29ee8de 100644
>>> --- a/mm/slub.c
>>> +++ b/mm/slub.c
>>> @@ -2143,6 +2143,8 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags)
>>>        */
>>>       if (likely(obj_exts))
>>>               alloc_tag_add(&obj_exts->ref, current->alloc_tag, s->size);
>>> +     else
>>> +             alloc_tag_set_inaccurate(current->alloc_tag);
>>>  }
>>>
>>>  static inline void
>>>
>>> base-commit: f4e8f46973fe0c0f579944a37e96ba9efbe00cca
>>


