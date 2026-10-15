Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99A65CC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 15:07:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ED5A6B0088; Thu, 15 Oct 2026 11:07:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69E826B008A; Thu, 15 Oct 2026 11:07:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58CF76B008C; Thu, 15 Oct 2026 11:07:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 350376B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:07:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AEA9B160986
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:07:39 +0000 (UTC)
X-FDA: 85325189838.06.50656D8
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by imf01.hostedemail.com (Postfix) with ESMTP id ED4704000F
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:07:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Qu1YceQs;
	spf=pass (imf01.hostedemail.com: domain of 3N-zQagkKCLAjQhkdiQXkWeeWbU.SecbYdkn-ccalQSa.ehW@flex--tarunsahu.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3N-zQagkKCLAjQhkdiQXkWeeWbU.SecbYdkn-ccalQSa.ehW@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792076858;
	b=QvYnAKeLdO1JDAjb8Vn9SJFuUGxCzOCRtfbZQ3dmsp5L43/xhphcK1UzlUI1/d2VSW0F0n
	kzifgv+qBQU9ylJe7jU45VwGCOdbzKC+T2t2ZNAEHZ9GeH8gzw0DKVmgyZhSzsijBG211g
	LOajf+t9dMyK6AkvFjt94zR9c292W2I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Qu1YceQs;
	spf=pass (imf01.hostedemail.com: domain of 3N-zQagkKCLAjQhkdiQXkWeeWbU.SecbYdkn-ccalQSa.ehW@flex--tarunsahu.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3N-zQagkKCLAjQhkdiQXkWeeWbU.SecbYdkn-ccalQSa.ehW@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792076858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IC5Ct3FOhi968am1MRf06lj4teeqkFZmOqPC0DoSw2E=;
	b=VBCUk54whjiS95XMtuwJ2qz2xbA9stQymSqFff1prTXuq4lnrIo6l1pWA1sAsQ6DXP8L6B
	otz7oFBGR1DN25yNayWF+2O9N+gcsTD32ACeYCd3B3GVGXIVc4+1WATs0oecHmiy35JZ01
	JGc/4CFiz3dHJI9UKNZ/sOKE8eqiNXs=
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c2e8c76334fso218213466b.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792076856; x=1792681656; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IC5Ct3FOhi968am1MRf06lj4teeqkFZmOqPC0DoSw2E=;
        b=Qu1YceQszQwpgIYFzA51U0LTVVWYEzfGAPebR+EExn/PK/EDxWr6OBznAgDmC8bYhD
         aDSIkHdssmxKqALGWa1SL+V6AzfVHYgB9pPad1bZ+/fx8ukL6A1Lu/DOY45LkpO0jOpD
         J5NutCNDyFq/yZe1o4PkvxjPxzGn2pXuKEEXZTiOi0KNKUitbnCw4B71oTsBstpd8sTH
         lQrXOeCDRNLZ3e4C2A7/Va6DxOodq/rttOUI3NGkfN0I768GRMkHVea+JZb/Ko4iHMr0
         1ONDq6lQ4+QyOGFH5d/JPNbXqxtuY9iYs8ezAAaQW+jSgQ9t7eGDFcJcYMjsCn1c7nIc
         1Nsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792076856; x=1792681656;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IC5Ct3FOhi968am1MRf06lj4teeqkFZmOqPC0DoSw2E=;
        b=q9Hl7UqE7LtaNaXBDX0Vjhw8cJA3eTm3LFVRqIi+x1th9ANDPeHY+zvxqN5zm94ftI
         kV6aKCeTv0xWbEPwKawpMuKXn2gZNp6C+FR6h58N8KeV5bgNCUNMiR/xXVYHFO4c/MwI
         Ie4D7sYysnEgTPJp96/qqSiE7b64lK3SYEmiWQ5zy3meArUU2uy8FArUUWq8wZY+FvO0
         TYrSrdxMS6Q/+pxUYZW+Sp0EHQSCJc5lEd/VcNTm/J8x6KsxOeOV1UEEzdNkiDzNfUYB
         tGb1CGNWWTYTxqcMvC5B7UXXZxbaQ8ltgSQrXwJxeQ5IyWtuxsCBQhmxxJFbMNQh89Jx
         ZttA==
X-Forwarded-Encrypted: i=1; AKwUvBzx8INlKTnDUNHstywp8y6vHo7kBTCFa1k/piQAkPechECJI81YdrjSVDSfU86uu+uHJpOs5FG/Cg==@kvack.org
X-Gm-Message-State: AFq9FYIV10HslkxZlkbhI15H4ozLs8brN5efyF6uXc+nMbXCor9AG7mJ
	ctUM8gpby143YrYeMt4QIGVhLcHCtu97bTLlT5lf8yS/kqXSesWt/H7NVhEEWpPMTaar/Iew0ZU
	KLkJ4YUpcwZgu3Ll+jA==
X-Received: from ejbbq18.prod.google.com ([2002:a17:906:d0d2:b0:c2e:1f38:d81a])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:9615:b0:c24:adf4:5c73 with SMTP id a640c23a62f3a-c31a9a28825mr1772701566b.1.1792076855746;
 Thu, 15 Oct 2026 08:07:35 -0700 (PDT)
Date: Thu, 15 Oct 2026 15:07:34 +0000
In-Reply-To: <2vxzzewfgno2.fsf@kernel.org>
Mime-Version: 1.0
References: <20260903023452.721732-1-loganodell@google.com>
 <20260903023452.721732-2-loganodell@google.com> <2vxzzewfgno2.fsf@kernel.org>
Message-ID: <9huzqzhrhuix.fsf@tarunix.c.googlers.com>
Subject: Re: [RFC PATCH 1/3] luo: Move to feature flags instead of
 compatibility strings
From: tarunsahu@google.com
To: Pratyush Yadav <pratyush@kernel.org>, Logan Odell <loganodell@google.com>
Cc: arnd@arndb.de, pasha.tatashin@soleen.com, rppt@kernel.org, 
	pratyush@kernel.org, graf@amazon.com, akpm@linux-foundation.org, 
	pbonzini@redhat.com, maz@kernel.org, oupton@kernel.org, seanjc@google.com, 
	bhelgaas@google.com, alex@shazbot.org, jgg@nvidia.com, kevin.tian@intel.com, 
	dwmw2@infradead.org, baolu.lu@linux.intel.com, joro@8bytes.org, 
	will@kernel.org, robin.murphy@arm.com, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, iommu@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ED4704000F
X-Rspam-User: 
X-Stat-Signature: 4gjyek69j8ozabytzp7dzo59jq7ek84q
X-HE-Tag: 1792076857-363781
X-HE-Meta: U2FsdGVkX19c4QfOK8svuPd7J/5Ce4vXAIyQXZSyja09pNKmtw0FGP3R3wDHP5LCibZpzXQIUPUmJySFMn/B9X0xackywOrVSO0UtqSD42iVJeOA6p1bEXyn1hRbFT31DZ3h0aDMlTm4SZN54uepupbj/4bKIA0F0hVKx4wkC8G8xI3byH//bY5ntjJ/E+sSwQS25fF/6Gr7SieDDSpZnYpa8OFCIb6b+uw3StxKkXLjQp3WGR/EizNiTWD3BzyvwGZJ71oQX41LLBqpqV8JZ7dyB3RsCbOoLxMXD6vlUEk+ViF484MUB3tlF1FkVeqiy5jAyroW+aaMbE+QuOYp3tfXL+fLD76dOEKX6OUo9+FOLLDwBXflIUEz7fWmg3UW7g6dHDsedV7CWe/V99cbMr8j5rwrl5vZ7wODW67bhMAnaw2/xOlRyMn4db+b5FDI4m/gK8Y1K5xDK5mvwD1TbbtB2n/FZRm3147scGGsQILmPoDAlVOGcamT7/kr0RVc5yONeyfGVmHDowMqdF0g3KSNOrv72Y0BgfzAWTevIOpMSQTT/TG/0cqPeLnVkRBKBADEXOttEOg4kBPdvF5jhAd3R+eFORFwfIicnYm+UbSwdOSHZQFfWswDXSlcgJE1vQcZ7HfjkNSgG8b9JEJrumh2ZJJ20XwrMqagG6Lq+2hv5zp4Ryi8Q6tLUMOT4uwMB9x9k1IOzXREhlFOArdEjDdQhd5INr+zdQeK6LeZf88xJgbz/+Yb5YuDzD7L1ZVVUJS771h/j8xylQdU5OwEMIm3MAC2LN34FmCMH6zM1sfaVuQPSlljA1cUnLi+UyWg2hDTv1Zq6ThlzHh1mOlvJ+/TufnyXGuNYH0o+jKVTX89BGwaVEDkFeEC/xBc8vc4b4ZiIYX4k6b46fjeFYaTGs0jYhHs7Wz8Aveos7EGyrABQQn+raj0JLNSxek21aNTyoVl5vaegTo/QGr9rsI
 CARJAbek
 ITtM25Av3UOJE9AMtrgr6EdV6gN6thoxoP06P9UhbQCBN3s7h+II+Ng84vdCsFI4PeYuKQOcvR/Dimv3UXCS6snsd9Sov2TGZXuaHhKcVEBfptnMfralWhDqG5atsxsmkAtiYCnD4ff0kO8IfxyzOgJtPXhYVVhy9TedqtYeJUPsvmjxJeOx1xEjaJ8YcikoURbhKKCn5BwwZ2LtrV+9whN7dRrp+v3bldP5JxJGkbU4/uURlOCXguk6xcfLj/pfkl8Z+ASqRm2Rs/FIcuvl3mN/CLNmP5kRx5YS2YQVADRvPOSDBJiZ3XGvM07ty2aqFuqzH9y2aHD9INf/xBWpCTuXiz4uw5RSsOItXIJFMfFkNncjnQpQZQw4sUVuZYQcIGe5YCnm3CCwlsTSigW3BkryT+OE3PaxsftY+qEfpDApLbaopRl9LECwYGERMvX85a4iJ9UjEO2foEpdPngedDFWHTGM9TuyzhLPBYSdOgN7plNZLsETVxsvkmn+UCDG7j8BDbzdQyVpvezyzARtVPNX9uz6fdn9uB1FU0d24Huwq7iyfUAztPcZ62Xp+PXUAYyy4RW323laT9qyQ2ZF7L0ax2vydRxFNaJdf4aLuKIfEu98=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pratyush Yadav <pratyush@kernel.org> writes:

> Hi Logan,
>
> On Wed, Sep 02 2026, Logan Odell wrote:
>
>> Define a 128 byte header that can be used by all live update serialized
>> structures. In this header, we reserve room for 64 features with
>> supported, active, and required bits. Update the top level luo struct to
>> use this instead of compatibility strings. Previous versions of the
>> struct had smaller sizes, so add a minimum size check to avoid
>> collisions with older kernels.
>>
>> Signed-off-by: Logan Odell <loganodell@google.com>
>> ---
>>  include/linux/kho/abi/luo.h  | 74 +++++++++++++++++++++++++++++-------
>>  kernel/liveupdate/luo_core.c | 44 +++++++++++++--------
>>  2 files changed, 90 insertions(+), 28 deletions(-)
>>
>> diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
>> index 288076de6d4a..0a7662a0cf9a 100644
>> --- a/include/linux/kho/abi/luo.h
>> +++ b/include/linux/kho/abi/luo.h
>> @@ -13,15 +13,17 @@
>>   * kernel. The ABI is built upon the Kexec HandOver framework and registers
>>   * the central `struct luo_ser` via the KHO raw subtree API.
>>   *
>> - * This interface is a contract. Any modification to the structure fields,
>> - * compatible strings, or the layout of the `__packed` serialization
>> - * structures defined here constitutes a breaking change. Such changes require
>> - * incrementing the version number in the relevant `_COMPATIBLE` string to
>> - * prevent a new kernel from misinterpreting data from an old kernel.
>> + * This interface is a contract. To ensure the stability of moving between
>> + * kernel versions, any changes to the structures should only be additive
>> + * and should utilize the feature flags to denote the supported, active, and
>> + * required status of the feature.
>> + *
>> + * Features that are entirely optional can be added with the supported and
>> + * active flags both asserted, and the required flag cleared. Features that
>> + * require that the next kernel supports the feature should only be added as
>> + * supported to allow compatible transition kernels. At a later time, the
>> + * active and required flag should be asserted.
>>   *
>> - * Changes are allowed provided the compatibility version is incremented;
>> - * however, backward/forward compatibility is only guaranteed for kernels
>> - * supporting the same ABI version.
>>   *
>>   * KHO Structure Overview:
>>   *   The entire LUO state is encapsulated within a single KHO entry named "LUO".
>> @@ -30,7 +32,7 @@
>>   * Serialization Structures:
>>   *   - struct luo_ser:
>>   *     The central ABI structure that contains the overall state of the LUO.
>> - *     It includes the compatibility string, the liveupdate-number, and pointers
>> + *     It includes the feature flags, the liveupdate-number, and pointers
>>   *     to sessions and FLBs.
>>   *
>>   *   - struct luo_session_ser:
>> @@ -58,19 +60,65 @@
>>  #define _LINUX_KHO_ABI_LUO_H
>>  
>>  #include <linux/align.h>
>> +#include <linux/bits.h>
>>  #include <linux/kho/abi/block.h>
>>  #include <uapi/linux/liveupdate.h>
>>  
>> +/**
>> + * struct luo_feature_hdr - Feature negotiation and versioning header.
>> + * @supp:     Bitmask of features supported by the producing subsystem.
>> + * @req:      Bitmask of features required for safe deserialization by the
>> + *            receiving subsystem.
>
> I think you are mixing two things here: description of the payload and
> description of the file handler capability.
>
> The payload that is handed over via KHO should have the active and
> required bitmasks only. It doesn't need the supported bitmask, because
> it doesn't matter what the handler that produced the payload supports.
> It only matters what fields it populated and which ones are mandatory to
> understand.
>
> Similarly, the description of the file handler can't really describe
> "active". Because the capabilities are static and the active bits will
> depend on a specific file.
>
> So I reckon we should separate these two. These should be the same bits
> of course, but expressed in two ways in two different places.
>
>> + * @active:   Bitmask of features actually active/used in the serialized payload.
>> + * @reserved: Reserved for future use.
>> + *
>> + * This header can be embedded at the beginning of any serialized structure to
>> + * provide forward and backward compatibility via feature negotiation across
>> + * live update.
>> + */
>> +struct luo_feature_hdr {
>> +	u64 supp;
>> +	u64 req;
>> +	u64 active;
>> +	u64 reserved[13];
>
> How do you plan to ever use this? Say I want to extend my bitmaps so I do:
>
>     struct luo_feature_hdr {
>     	u64 supp;
>     	u64 req;
>     	u64 active;
>     	u64 supp2;
>     	u64 req2;
>     	u64 active2;
>     	u64 reserved[10];

I thinking this is too spreaded.

We can do somthing like:

struct ABI {
       u64 size;
       u64 flags;
       u64 flags2;
}

where flags is extended to flags2 if flags MSB bits is 11.

and each flags is formatted like 0b 00 01 11 00 11 10 11 11 00 00 11 ...

each pair represents 0b 1 (required) 1 (active)
Getting the details of the feature is just bit manipulation, so
proper macro definition similar to the one this patch has implemented.


~Tarun



>
> But when I go back to a kernel that doesn't know about supp2, req2,
> etc., how does it know how to interpret these? How does it know what the
> values mean?
>
> Is your goal only to be able to extend the three types of flags we have?
> If so, perhaps something like "if bit 63 is set, the flags continue to
> the next u64"? It is certainly harder for the parser, but seems to at
> least be extensible. What do you think?
>
>> +} __packed;
>> +
>> +#define LUO_FEATURE_ACTIVE(s, f)		\
>> +	do {					\
>> +		(s)->features.supp |= (u64)(f);	\
>> +		(s)->features.active |= (u64)(f);	\
>> +	} while (0)
>> +#define LUO_FEATURE_SUPPORTED(s, f)	((s)->features.supp |= (u64)(f))
>> +#define LUO_FEATURE_REQUIRED(s, f)	((s)->features.req |= (u64)(f))
>> +#define LUO_FEATURE_IS_ACTIVE(s, f)	(!!((s)->features.active & (u64)(f)))
>> +#define LUO_FEATURE_IS_SUPPORTED(s, f)	(!!((s)->features.supp & (u64)(f)))
>> +#define LUO_FEATURE_IS_REQUIRED(s, f)	(!!((s)->features.req & (u64)(f)))
>> +
>>  /*
>>   * The LUO state is registered under this KHO entry name.
>>   */
>>  #define LUO_KHO_ENTRY_NAME	"LUO"
>> -#define LUO_ABI_COMPATIBLE	"luo-v5"
>> -#define LUO_ABI_COMPAT_LEN	ALIGN(sizeof(LUO_ABI_COMPATIBLE), 8)
>> +
>> +/*
>> + * Bits associated with the luo_feature_hdr values.
>> + */
>> +#define LUO_FEATURE_NUMBER    BIT_ULL(0)
>> +#define LUO_FEATURE_SESSIONS  BIT_ULL(1)
>> +#define LUO_FEATURE_FLBS      BIT_ULL(2)
>
> Nit: please give the flags full documentation on their semantics.
>
>> +
>> +#define LUO_CORE_FEATURES_SUPP		(LUO_FEATURE_NUMBER | \
>> +					 LUO_FEATURE_SESSIONS | \
>> +					 LUO_FEATURE_FLBS)
>> +#define LUO_CORE_FEATURES_REQ		(LUO_FEATURE_NUMBER | \
>> +					 LUO_FEATURE_SESSIONS | \
>> +					 LUO_FEATURE_FLBS)
>> +#define LUO_CORE_FEATURES_ACTIVE	(LUO_FEATURE_NUMBER | \
>> +					 LUO_FEATURE_SESSIONS | \
>> +					 LUO_FEATURE_FLBS)
>>  
>>  /**
>>   * struct luo_ser - Centralized LUO ABI header.
>> - * @compatible:     Compatibility string identifying the LUO ABI version.
>> + * @features:       Bit mask of supported and active features.
>>   * @liveupdate_num: A counter tracking the number of successful live updates.
>>   * @sessions_pa:    Physical address of the first session block header.
>>   * @flbs_pa:        Physical address of the FLB header.
>> @@ -78,7 +126,7 @@
>>   * This structure is the root of all preserved LUO state.
>>   */
>>  struct luo_ser {
>> -	char compatible[LUO_ABI_COMPAT_LEN];
>> +	struct luo_feature_hdr features;
>
> Do we still need compatible here? How will we ever do breaking changes
> if we really need to?
>
>>  	u64 liveupdate_num;
>>  	u64 sessions_pa;
>>  	u64 flbs_pa;
>> diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
>> index 1b2bda22902d..6add1ecc463f 100644
>> --- a/kernel/liveupdate/luo_core.c
>> +++ b/kernel/liveupdate/luo_core.c
>> @@ -107,26 +107,37 @@ static int __init luo_early_startup(void)
>>  		return 0;
>>  	}
>>  
>> -	if (len < sizeof(*luo_ser)) {
>> -		pr_err("LUO state is too small (%zu < %zu)\n", len, sizeof(*luo_ser));
>> -		return -EINVAL;
>> +	luo_ser = phys_to_virt(luo_ser_phys);
>> +
>> +	if (len < sizeof(struct luo_feature_hdr)) {
>> +		pr_err("LUO state is too small (%zu < %zu)\n",
>> +		       len, sizeof(struct luo_feature_hdr));
>> +		err = -EINVAL;
>> +		goto out_free_ser;
>>  	}
>>  
>> -	luo_ser = phys_to_virt(luo_ser_phys);
>> -	if (strncmp(luo_ser->compatible, LUO_ABI_COMPATIBLE, LUO_ABI_COMPAT_LEN)) {
>> -		pr_err("LUO state is incompatible with '%s'\n", LUO_ABI_COMPATIBLE);
>> -		return -EINVAL;
>> +	if (luo_ser->features.req & ~LUO_CORE_FEATURES_SUPP) {
>> +		pr_err("Unsupported required LUO feature (req: 0x%llx, supp: 0x%llx)\n",
>> +		       luo_ser->features.req, (u64)LUO_CORE_FEATURES_SUPP);
>> +		err = -EOPNOTSUPP;
>> +		goto out_free_ser;
>>  	}
>>  
>> -	luo_global.liveupdate_num = luo_ser->liveupdate_num;
>> -	pr_info("Retrieved live update data, liveupdate number: %lld\n",
>> -		luo_global.liveupdate_num);
>> +	if (LUO_FEATURE_IS_ACTIVE(luo_ser, LUO_FEATURE_NUMBER)) {
>> +		luo_global.liveupdate_num = luo_ser->liveupdate_num;
>> +		pr_info("Retrieved live update data, liveupdate number: %lld\n",
>> +			luo_global.liveupdate_num);
>> +	}
>>  
>> -	err = luo_session_setup_incoming(luo_ser->sessions_pa);
>> -	if (err)
>> -		goto out_free_ser;
>>  
>> -	luo_flb_setup_incoming(luo_ser->flbs_pa);
>> +	if (LUO_FEATURE_IS_ACTIVE(luo_ser, LUO_FEATURE_SESSIONS)) {
>> +		err = luo_session_setup_incoming(luo_ser->sessions_pa);
>> +		if (err)
>> +			goto out_free_ser;
>> +	}
>> +
>> +	if (LUO_FEATURE_IS_ACTIVE(luo_ser, LUO_FEATURE_FLBS))
>> +		luo_flb_setup_incoming(luo_ser->flbs_pa);
>>  
>>  	err = 0;
>>  
>> @@ -162,7 +173,10 @@ static int __init luo_state_setup(void)
>>  		return PTR_ERR(luo_ser);
>>  	}
>>  
>> -	strscpy(luo_ser->compatible, LUO_ABI_COMPATIBLE, sizeof(luo_ser->compatible));
>> +	luo_ser->features.supp = LUO_CORE_FEATURES_SUPP;
>> +	luo_ser->features.req = LUO_CORE_FEATURES_REQ;
>> +	luo_ser->features.active = LUO_CORE_FEATURES_ACTIVE;
>> +
>>  	luo_ser->liveupdate_num = luo_global.liveupdate_num + 1;
>>  
>>  	luo_session_setup_outgoing(&luo_ser->sessions_pa);
>
> -- 
> Regards,
> Pratyush Yadav

