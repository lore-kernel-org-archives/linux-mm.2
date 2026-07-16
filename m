Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9CE0C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:34:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1D2C6B014D; Thu, 16 Jul 2026 11:34:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF92A6B0150; Thu, 16 Jul 2026 11:34:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C074D6B0151; Thu, 16 Jul 2026 11:34:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 937006B014D
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:34:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 88ACCA006A
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:54:37 +0000 (UTC)
X-FDA: 84994482594.24.5DF1D24
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf19.hostedemail.com (Postfix) with ESMTP id 938161A0002
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:54:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=MJTWhNQe;
	spf=pass (imf19.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784202875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zb47wRi4sOHO/8LTR4EG3esNvOTJsaH8noXff1aeIwg=;
	b=6BUS/Tb/fpvgLS3d4Hmlp4u1HKE/FwFMkhnen3iIpYHPuqnCTJFrS3jm1DrCcsNVvs27/J
	rt+tY40vKMyo3uNMT+08HIW+QuLpg14QmifET81yp9aeS+LsmhYMwQCSs3zAMwcVJAwOlv
	4pW8W17ndC7pmeDjEZKr1/b2t96Ufo4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=MJTWhNQe;
	spf=pass (imf19.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784202875;
	b=wf1oyPwMS8neNoIlE1h+cKzB000w3JDA29B+AQHD2Q7BZW42qV/h0zRZfe8rSah4X7hFkF
	rMhKMziAxPF8Ox0xsEzPoBCwcXH67nQSDbCGb/EBw0coNxBK6VpnuMhloZ6Yos7I9Fbzru
	X8QOirCKXHO+NxJrSycCNdoWj/a3UP4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784202868; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=Zb47wRi4sOHO/8LTR4EG3esNvOTJsaH8noXff1aeIwg=;
 b=MJTWhNQew6v0eZvRbbfNeS+Vp8cKNtK1qj+MRg5zVU2UWui8OZ2/RLCTrziOi9i3k90KNG
 NP/yOlVKqVw+39ymBCgo2aLs9AhG+OAf7goiBaImNUm2ne4HQqk5MVuDPnpM3SJP1RkK5m
 Ys2DQNtsHrjrxCcSjraHu1SeEABHatb08cml5TFKmLwwWMrKMNycFh3oTe5x7MzQ22jkSG
 4oXA6w43Lorz0Xg/AI2qqj/8PSrMsF1DL/BVc/Mn+j3dh7XqbCSkGI6t9ceQEObXHXgpmq
 jNYnHlTtlTxPG4gM+TQl5Ju9wKjY7wNtjCLRVg8MWbOKIodqH45riJ8H11AfvA==
Subject: Re: [PATCH v6 6/8] string: introduce memcpy_nt() helpers
User-Agent: Mozilla Thunderbird
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
References: <20260709112520.24857-1-lizhe.67@bytedance.com> <20260709112520.24857-7-lizhe.67@bytedance.com> <7bfb13a0-8f4a-4f4b-9df4-da842169f8f1@linux.dev> <abd1f6da-a6f4-40ed-923f-94201bba4690@bytedance.com> <80A0AAC8-DC3C-4FB7-8CE3-EF2EC96EB47F@linux.dev>
Message-Id: <fb1795f0-7dd0-4518-9760-2f14cc3107f8@bytedance.com>
Content-Transfer-Encoding: 7bit
Date: Thu, 16 Jul 2026 19:54:05 +0800
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<rppt@kernel.org>, <tglx@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a58c672+ba8062+kvack.org+lizhe.67@bytedance.com>
In-Reply-To: <80A0AAC8-DC3C-4FB7-8CE3-EF2EC96EB47F@linux.dev>
To: "Muchun Song" <muchun.song@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 938161A0002
X-Stat-Signature: y648dzcg6qpr7u8itmktcsyyomctk14h
X-HE-Tag: 1784202873-366858
X-HE-Meta: U2FsdGVkX1/VKrs/6r1fcGRqi+csj9ht97M+8nQbbdn9A/3J0v8Iiez/PfcvuLA12h5/3AARyfQs11V6k18j0WgoFNcLan7Gj8A/Epepvr3FFrFpkss5Hbn8MLCGpH7viai/s0fKpYqN7Xx2139tKPGhlUcqeUKY15VatErVZQ/XMiCFy2xF83UyGeXpAiy+0myiDsAnkQLXWC02Dz/1HMFtCkKQJV7MknrWfA0TYMIUMAnpQQZUTw+KLw2nf3eccXqmK1Uk1V9+a7zWkYBfOhH1aHQ68wqLn1tfnNSEL4lfoAJ+goWnXh2gJGF58tURKE9ErQhhMJ4vNJpofIMBpYiWImuuk++h5Q9qFWeW4OiHwmPkvlN5LKuWsl6Q0Mj1bPTvFMlPJmu0Bz2a8B0pAvi8Cvq0c3Xtff5wG6gRArtqvmTvHhJGHMApiV2rcQZ/bzXbzwXXeRDYs/4QfxSREECProOlPf5pK9chWiV4FmG+/N/Cn8aoOfqQoL/0JwBri1Rj0Luse9f3aWhVty0Xl0dJn735kcJpIKznwF8I682ZsRfnITxP8UxWj/vK/6TwJkEaPFmIp/UaZr4utRENDtcz5O4YuLy4+LU2smQw5LXLTe2HxTRpqng/sZGUm1uMFesl7HW3pYcRdsMmZ6dHztvsHpCaehJnQp9kSnmw7D6rNUHsPUjjDF5yI4YXOl/ZLT2kv11GHWQewtOjCnScWE8WpzfgsrDk/KmIHVNr//TuJ5nPKr/sKlFyjmUpOaelHYoJ4SiyQnkXIFssI/bCA61QOLSV3631wMsTfAXXQbyc0miqxjhO55wLOLN2zWeTltra59VDNTnxJiEhAFdBLjJKiw27via39cN3boKPqkiY/NoArXU3HyY3CklbgUijS0j6Z22F2DNDoAYClAZc35UbmeeMPrMYD6QOiVyx8unIkJ/BwyVKigHVttW7W6PhvSBD7tHmsXpcmqK77xu
 oDyBM2Es
 1viT4tcp/b8N8FKw5EDh6WTfjOOHeAmuPSl7ddEZoMAoIZ6r6moN+4D528ttJ3/UOIKynLjJPxAkbc3B/Eyj8/vHs7PAGxsUSQ4/WJxFngwM+4ij7CCqLBR/fc4IOG6es6Zk0OwEEJ9d60fCsTGn+2eAXaVRKrlPq5a+jfl5nYjMIUP02ORzErgvYsT1qv0YsrZRtSgr/AMzuTeEYWri9A+Ke32YjSnizx84mQ2ii1Kn+gR9UEFMr8+K0xMoQbECph3lEJJ/x5kTHoWPPBs9dLe0Wrh9MrcZClmwjJQ4XFBquVSUyEj5DPiLQWNbEptukuK9fT9d4P/2ZzB7SReVaaQOY2E94Hko63eoFuKZLo/8qKcIY+94NMvp+3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/15/26 5:33 PM, Muchun Song wrote:
>
>> On Jul 15, 2026, at 14:18, Li Zhe <lizhe.67@bytedance.com> wrote:
>>
>> On 7/14/26 5:24 PM, Muchun Song wrote:
>>>
>>> On 2026/7/9 19:25, Li Zhe wrote:
>>>> Introduce memcpy_nt() and memcpy_nt_drain() for write-once copy sites
>>>> that want a named non-temporal copy primitive plus an explicit drain
>>>> step.
>>>>
>>>> On x86_64, override both helpers in arch/x86/include/asm/string_64.h
>>>> using the usual self-macro pattern, next to the existing
>>>> memcpy_flushcache() backend that memcpy_nt() wraps. The x86_64
>>>> implementation maps memcpy_nt() to memcpy_flushcache() and uses wmb()
>>>> for memcpy_nt_drain(), because that backend issues MOVNTI stores and
>>>> callers need an ordering point before later normal stores that depend
>>>> on those writes becoming visible.
>>>>
>>>> include/linux/string.h provides the generic fallback under
>>>> memcpy_nt() as plain memcpy() and leaves memcpy_nt_drain() empty, so
>>>> architectures that do not override memcpy_nt() do not pay an
>>>> unconditional barrier. Architectures that later grow a specialized
>>>> memcpy_nt() backend can override memcpy_nt_drain() with whatever
>>>> drain primitive their memory-ordering rules require.
>>>>
>>>> The immediate user is the ZONE_DEVICE template-copy path. It populates
>>>> struct page descriptors in a write-once pattern, so a regular cached
>>>> memcpy() can incur avoidable write-allocate traffic and cache
>>>> pollution for data with little near-term reuse.
>>>>
>>>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>>>> ---
>>>>    arch/x86/include/asm/string_64.h | 22 ++++++++++++++++++++++
>>>>    include/linux/string.h           | 23 +++++++++++++++++++++++
>>>>    2 files changed, 45 insertions(+)
>>>>
>>>> diff --git a/arch/x86/include/asm/string_64.h
>>>> b/arch/x86/include/asm/string_64.h
>>>> index 4635616863f5..6cb9e0ac7fa0 100644
>>>> --- a/arch/x86/include/asm/string_64.h
>>>> +++ b/arch/x86/include/asm/string_64.h
>>>> @@ -4,6 +4,7 @@
>>>>
>>>>    #ifdef __KERNEL__
>>>>    #include <linux/jump_label.h>
>>>> +#include <asm/barrier.h>
>>>>
>>>>    /* Written 2002 by Andi Kleen */
>>>>
>>>> @@ -100,6 +101,27 @@ static __always_inline void
>>>> memcpy_flushcache(void *dst, const void *src, size_t
>>>>        }
>>>>        __memcpy_flushcache(dst, src, cnt);
>>>>    }
>>>> +
>>>> +#define memcpy_nt memcpy_nt
>>>> +/*
>>>> + * Reuse the existing x86 flushcache backend as the nt copy primitive.
>>>> + * Callers pair it with memcpy_nt_drain() when later stores must be
>>>> + * ordered after the copy.
>>>> + */
>>>> +static __always_inline void memcpy_nt(void *dst, const void *src,
>>>> size_t cnt)
>>>> +{
>>>> +    memcpy_flushcache(dst, src, cnt);
>>> Why not use memcpy_flushcache() directly in device dax path? I don't
>>> understand the necessity of introducing memcpy_nt here.
>>>
>> The reason for introducing memcpy_nt() is to give generic MM code a
>> named non-temporal copy primitive, instead of hardwiring the x86
>> memcpy_flushcache() backend into a generic caller.
>>
>> On x86, memcpy_nt() maps to memcpy_flushcache() today. On other
>> architectures, memcpy_flushcache() may have different semantics, and we
>> also do not know whether its implementation would provide the same
>> optimization opportunity as on x86. Using memcpy_nt() lets the generic
>> caller express the intent while leaving the backend choice to each
>> architecture.
> Got it. But the 'nt' suffix is overly abbreviated and not direct enough.
> Therefore, I suggest avoiding uncommon abbreviations and instead keeping
> things as explicit as the 'flushcache' suffix in memcpy_flushcache.


Thanks, that makes sense. The abbreviated "nt" name came from Boris'
earlier suggestion to keep the naming focused on non-temporal stores and
to abbreviate that as "nt":

https://lore.kernel.org/all/20260607190804.GAaiXBlGO2eRcfs1oB@fat_crate.local/

But I agree that, for a generic string helper, spelling this out is
clearer. I will rename the helper to memcpy_nontemporal() in the next
version.

>>>> +}
>>>> +
>>>> +#define memcpy_nt_drain memcpy_nt_drain
>>>> +static __always_inline void memcpy_nt_drain(void)
>>>> +{
>>>> +    /*
>>>> +     * Order the prior MOVNTI stores issued by memcpy_flushcache()
>>>> +     * before later normal stores.
>>>> +     */
>>> I also have a question here: why are we using wmb to guarantee visibility
>>> at this stage?
>>>
>>> Since we are still in the very early phases of memory initialization
>>> (specifically,
>>> struct page initialization), since we are still in an intermediate
>>> initialization
>>> state, this shouldn't be visible to other CPUs anyway.
>>>
>>> Thanks.
>> The drain is not about exposing the intermediate initialization state to
>> other CPUs.
>>
>> It is there to order the earlier non-temporal stores before the later
>> normal stores on the same control path, for example before
>> memmap_init_compound() / prep_compound_head() update overlapping
>> compound metadata.
> For a single core, out-of-order execution is invisible to developers.
> Therefore, I'm curious about your reasons for preserving the order? What
> would be the consequences of not maintaining it?
>
> Thanks.
You are right. My previous explanation overstated the need for this
ordering point.

For the intended ZONE_DEVICE callers added later in the series,
memcpy_nontemporal() is used while the struct page metadata is still
being initialized and before that memmap is published for normal use.
The later ordinary stores to the compound metadata are also part of the
same initialization sequence. So those callers do not need a generic
drain helper just to order the non-temporal copy against later local
initialization stores.

I will drop memcpy_nt_drain() from the generic interface and remove the
drain calls from the ZONE_DEVICE user.

Thanks,
Zhe


>
>> On x86, memcpy_nt() maps to MOVNTI-based memcpy_flushcache(), so
>> memcpy_nt_drain() uses wmb(), which maps to the required sfence there.
>>
>> Thanks,
>> Zhe
>>
>>>> +    wmb();
>>>> +}
>>>>    #endif
>>>>
>>>>    #endif /* __KERNEL__ */
>>>> diff --git a/include/linux/string.h b/include/linux/string.h
>>>> index 5702daca4326..a109b2f86ca6 100644
>>>> --- a/include/linux/string.h
>>>> +++ b/include/linux/string.h
>>>> @@ -278,6 +278,29 @@ static inline void memcpy_flushcache(void *dst,
>>>> const void *src, size_t cnt)
>>>>    }
>>>>    #endif
>>>>
>>>> +#ifndef memcpy_nt
>>>> +/*
>>>> + * memcpy_nt() requests a non-temporal copy when the architecture has a
>>>> + * suitable backend. Architectures that do not override it fall back to
>>>> + * memcpy().
>>>> + */
>>>> +static inline void memcpy_nt(void *dst, const void *src, size_t cnt)
>>>> +{
>>>> +    memcpy(dst, src, cnt);
>>>> +}
>>>> +#endif
>>>> +
>>>> +#ifndef memcpy_nt_drain
>>>> +/*
>>>> + * Callers use memcpy_nt_drain() before later normal stores that
>>>> need to
>>>> + * be ordered after memcpy_nt(). Architectures without a specialized
>>>> + * backend can leave it empty.
>>>> + */
>>>> +static inline void memcpy_nt_drain(void)
>>>> +{
>>>> +}
>>>> +#endif
>>>> +
>>>>    void *memchr_inv(const void *s, int c, size_t n);
>>>>    char *strreplace(char *str, char old, char new);
>>>>
>>>> -- 
>>>> 2.20.1

