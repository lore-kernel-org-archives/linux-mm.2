Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F8F2CA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 15:19:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85CBC8E00F2; Tue, 26 Aug 2025 11:19:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80D6E8E00EC; Tue, 26 Aug 2025 11:19:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 749A98E00F2; Tue, 26 Aug 2025 11:19:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 63FE48E00EC
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 11:19:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 10591831F9
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:19:31 +0000 (UTC)
X-FDA: 83819267742.20.57A4F0A
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf15.hostedemail.com (Postfix) with ESMTP id 32B00A000E
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:19:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="dMc/0FLR";
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756221569; a=rsa-sha256;
	cv=none;
	b=x2OXI3Qn76yiRxPtmHj44THBLj1R5ky9KrcqW8++VtqrSWyf1YGsobM32N4XqWM3aocKnl
	Es5fwPDxakeeljWnXnVNXkk9WpQ2zr7AoKofzvIovl6GMbCJIevrFT8r+B/MVh0szQvTTx
	ECvSYEx/fJ2wiWyEkFWKwSQbhNFWPlA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="dMc/0FLR";
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756221569;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mk27Z11mxSM0SLUMRUU0qRXSfVypcH8V+qxyiNEJm+I=;
	b=SgOJg3VZtkiToGXu111dBbi0jnu714Ai4tWUnikPK0gxFgzFXZ9d2c45Lvr5QDAjKdx353
	5fsa27OIqh2FN9H2vFvxKDNzbj+XvezX9c+PDaBLlV6WnehC0wI0p99aldN6mJvhzGlVwf
	q61IuvfGk45n2jESWRpUOiZGiW6Zsns=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-61a8c134533so11821448a12.3
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756221567; x=1756826367; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mk27Z11mxSM0SLUMRUU0qRXSfVypcH8V+qxyiNEJm+I=;
        b=dMc/0FLRb6L3e1BZCrZ0/HZyN+iP7vU0AxIXe63SEIbxbqY5BcweiielS+Q6LYnpq4
         w8KyXTzZSwhpikDi6CTfFYfAF3d8UKALgYQUrbDz7HRMPOd0aAZOjTXCVNywlGBKruxq
         T0kspJDBB93sdKQ++8WL6XJHkF4nl6ZYgTv9D0bYcXooW7R950WZQKrJz9a1/Uwv3Qxg
         20XfOTnP0LY3Zj5NOsmTTnw98KJVQuRtFWydxf/YquZbNV7YI6ebzc1BiVYArd8I7JIn
         L3T9YYpwIkEwDdHY9tW5rtUfbk72kE6ssHfoWZcVtsnsp66RCk0FD5Hl0AMqGHkOYW85
         VElQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756221567; x=1756826367;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Mk27Z11mxSM0SLUMRUU0qRXSfVypcH8V+qxyiNEJm+I=;
        b=WzSOe5y+UlG1+mknSC26vUrpuhLuvnnKYCpU9qDi/vCKv11QolEECOeZAzQPoK/QaN
         mhZ1uEXTKrRIHWmCAltwOPr2BpaBVolI7uVZPWYEwirxh05FbDJLaxkAxS1kjULoL06a
         Psi0lJqjzTVTHCfGo1mVt0AFTK/HfTPrd0LLlqhF6FY2kPFDzgiaHKFoPDu0B1CR6WzA
         LscCjr1hHGvdul93MIoMjWU7drCwfj+5acD79u6A4ruukOdTgGZ8bJFGxIxWSYGznZu+
         7qKR8qSEH0as4DRwp2oZ47uXaG731EFr51lufFnJF1v68pejv7Kqp4Xy1oTrLt4aTOgo
         GaVQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbSto2BGoFgteuHDPBqxEEX8W3Yd5k4rlsooM0XPglq/nJ7fPgB8j0iXaC3TZD2G17mTnNnQa98w==@kvack.org
X-Gm-Message-State: AOJu0YzIhDyrClqQ9GyqBwHRso1rlouJYkENf0jYVXwtxXVcF8kzjDt2
	vacWrq1Sk4HhkF0MqI3f+ZrrjQtmECJ9q4sx2vpQ4Z4bvMxTP/nJvn5f
X-Gm-Gg: ASbGncuT9OP1/7AiLEAcy7xFQbSHdeOnP6D8jXmVrPVSdOhfRVKWcIdDYETYiNJzDNW
	ThXYRyFVqO2WpNC/gZlGRICjSMwSafM2sGsHTpyXs7zEtL2/wM/GEjqnnjdMGR28MSqiBvZ5J+M
	Mf95kOhnFW0AcKsFpOtasN4jLaQu0BDFMDcCBjP9OPaP1tDkHZqavIvNi2llQMUAXc7pw3gwBh5
	yig8mNuoGz+twdbolYMSaOC/LF4rrRSBVVkfSjzSrVI512uEx5/8yB/iCKEKdkJqgwNtewTVBzi
	xFYN51jDUeLVroG7CKzlNVIPu0M2jb+HnHhpj5+Y4G7T/Annz0IknpEytjXZ5QcVufJBOej+myZ
	8DpC7ic6O/SvjSAEUx6xLAH93+yRFz8p+LSPK
X-Google-Smtp-Source: AGHT+IF83CTbeM4M0jpE5S0XT5KvJm578tjCIPLIPq5mVQutVg2Vcd6tTnPVPqwL1djEmRcRqzzLrw==
X-Received: by 2002:a05:6402:27ca:b0:61c:87da:4be2 with SMTP id 4fb4d7f45d1cf-61c87da506emr3909572a12.22.1756221567274;
        Tue, 26 Aug 2025 08:19:27 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61c316f4e10sm7143273a12.29.2025.08.26.08.19.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 Aug 2025 08:19:26 -0700 (PDT)
Date: Tue, 26 Aug 2025 15:19:26 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, vbabka@suse.cz, linux-mm@kvack.org,
	Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH 2/2] mm/pageblock-flags: simplify MIGRATETYPE_MASK
 definition
Message-ID: <20250826151926.re6p3yemvgcycosy@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250826093148.30190-1-richard.weiyang@gmail.com>
 <20250826093148.30190-3-richard.weiyang@gmail.com>
 <a78883c4-5b71-4880-8d6f-ebaebba7d1d6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a78883c4-5b71-4880-8d6f-ebaebba7d1d6@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 32B00A000E
X-Stat-Signature: 19a1n81ykdznxp49hkm8zdc7ys14roo5
X-Rspam-User: 
X-HE-Tag: 1756221568-670063
X-HE-Meta: U2FsdGVkX1+eA7o7ytQn3CzYhj0I2oC5BK4HxCVsUBEfnkQvLGPKr5G1X28crSIecRq3qgjvtRNC5e+y09JDfONeA7Gj1exnR13wed8iOlSnoy0e4daBWSfM9BFtHuOg33ZvN399FrJWU+65/aTHKfXodbEu9QG+4iZEq0VYPmAXAEo00/Ickw7Qhz1vCxA0T9enuw+r5+DUkjJxkn+XqvxZY1tDFQT3F4lYucJuCuWHQGKY/mBSYKviOQtbK8+oGE9az8Tr39q+CsRp4+I1JS8K4kPvRS3aLvAngqhPHDphv6vOq1mDjC+MWbSjAnYaKn8m8Z/0425EjaSuKoFFYHfGEp4bIpgKZvIE4g0qldYGwZLpzyhtX9YVrHuYTfN0Z8eDgLfncFGlJ7K2gissY4GKQH71G1J/b2ZrpynvChfoDV8m16zQEsa3DmFt/brMY9NsFNtwlqG3p+shtJlYq4sezXmkPnoEN12Wqbe3w1/8qmaorZlvlg1eFQ0mLdjfxcpNKSV7RMbnlaUahmowVU2Ec/84Qz7kw81xTkONit1xfyu5SaxYDYjbLQFxuHwuIF/omI2saURUm17QicYeLVdpDMdYpLAnHqG4NdEhtfE5Kow43dOrZ6tTvAJ9mXBxcGQV+I7LjpDpNML/ilIxerL1/+yBBpKB7o5qMDLctqfa+GYTXF5qRnUrWQ6hJjaZ5n5nThgB/FI7u3SfCF6uEPGH6jshzmEmVxuyEGIihu/+AVo6eM+9qNFZUDzSm8TFSE3dfkyj2wG4wQxk5hBelN1Z7zCwMfnkX096uT4C/cGSqaiUJCNx7crVUt17UYDgXIKO9GWEbWm6TkhwYJJip6CBwe0pKEiQJHZfN8VWalR15eKa2fiDJJllQcqPg8kBMdl/G4A3BWrqKZ9ZLvyWjzTYt3XF9tvJU/IEKZLxj7TysxlUnmLlmtkwOcc6aCa71im3WfAVZHMBFIeBe4R
 8YDPsOmj
 wwyMUfsMQCZiMvnOsdPkl9xrcCJy1fJxFkro4/b+KXYwZdPhEZ15CtWPuhA+R+tCeRKWJtq0ZsPIq9E167VOevZNlWG+H54XsXpAZ+z9EUlG8FKqTLYLygY+xKpDM/exUBfZOR7saMoTipFG+DQ43omTLEGtM3qt542xifnErJQI7a+AjwQv/Fk/bwAe42dXsMt/iDRjDR6DvKDTNv43XNGBVVt9ctuYv/pYNZRp+Ja2BlSWyiV1DrPFyAYel4yeImrPDeLotZzru4u6X5Eg0fnYOkmw+W11wMBZC2pjT0Ml6PfA6/12TcyZsQ6swNZu+F4pvhCjChsqTuupBO5S73pO3AgtdrDkse0CD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 03:34:13PM +0200, David Hildenbrand wrote:
>On 26.08.25 11:31, Wei Yang wrote:
>> MIGRATETYPE_MASK is defined to be the mask of possible migratetype.
>> 
>> Define it with PB_migratetype_bits directly would be more clear.
>> 
>> Also, MIGRATETYPE_AND_ISO_MASK is MIGRATETYPE_MASK add isolation bit.
>> Use MIGRATETYPE_MASK in the definition of MIGRATETYPE_AND_ISO_MASK looks
>> cleaner.
>> 
>> No functional change intended.
>> 
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: David Hildenbrand <david@redhat.com>
>> ---
>>   include/linux/pageblock-flags.h | 5 ++---
>>   1 file changed, 2 insertions(+), 3 deletions(-)
>> 
>> diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-flags.h
>> index 6a44be0f39f4..1489c062a5a7 100644
>> --- a/include/linux/pageblock-flags.h
>> +++ b/include/linux/pageblock-flags.h
>> @@ -37,11 +37,10 @@ enum pageblock_bits {
>>   #define NR_PAGEBLOCK_BITS (roundup_pow_of_two(__NR_PAGEBLOCK_BITS))
>> -#define MIGRATETYPE_MASK ((1UL << (PB_migrate_end + 1)) - 1)
>> +#define MIGRATETYPE_MASK (BIT(PB_migratetype_bits) - 1)
>>   #ifdef CONFIG_MEMORY_ISOLATION
>> -#define MIGRATETYPE_AND_ISO_MASK \
>> -	(((1UL << (PB_migrate_end + 1)) - 1) | BIT(PB_migrate_isolate))
>> +#define MIGRATETYPE_AND_ISO_MASK (MIGRATETYPE_MASK | BIT(PB_migrate_isolate))
>>   #else
>>   #define MIGRATETYPE_AND_ISO_MASK MIGRATETYPE_MASK
>>   #endif
>
>
>Hm, I wonder if we can get rid of PB_migratetype_bits
>
>diff --git a/include/linux/pageblock-flags.h
>b/include/linux/pageblock-flags.h
>index 6a44be0f39f45..70c988dbdddc8 100644
>--- a/include/linux/pageblock-flags.h
>+++ b/include/linux/pageblock-flags.h
>@@ -13,12 +13,11 @@
>
> #include <linux/types.h>
>
>-#define PB_migratetype_bits 3
> /* Bit indices that affect a whole block of pages */
> enum pageblock_bits {
>-       PB_migrate,
>-       PB_migrate_end = PB_migrate + PB_migratetype_bits - 1,
>-                       /* 3 bits required for migrate types */
>+       PB_migrate_0,
>+       PB_migrate_1,
>+       PB_migrate_2,
>        PB_compact_skip,/* If set the block is skipped by compaction */
>
> #ifdef CONFIG_MEMORY_ISOLATION
>
>And then just work with the bits. No magical computations.

Something like this?

diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-flags.h
index 6a44be0f39f4..a09b79a1fb7d 100644
--- a/include/linux/pageblock-flags.h
+++ b/include/linux/pageblock-flags.h
@@ -13,12 +13,11 @@
 
 #include <linux/types.h>
 
-#define PB_migratetype_bits 3
 /* Bit indices that affect a whole block of pages */
 enum pageblock_bits {
-	PB_migrate,
-	PB_migrate_end = PB_migrate + PB_migratetype_bits - 1,
-			/* 3 bits required for migrate types */
+	PB_migrate_0,
+	PB_migrate_1,
+	PB_migrate_2,
 	PB_compact_skip,/* If set the block is skipped by compaction */
 
 #ifdef CONFIG_MEMORY_ISOLATION
@@ -37,11 +36,10 @@ enum pageblock_bits {
 
 #define NR_PAGEBLOCK_BITS (roundup_pow_of_two(__NR_PAGEBLOCK_BITS))
 
-#define MIGRATETYPE_MASK ((1UL << (PB_migrate_end + 1)) - 1)
+#define MIGRATETYPE_MASK (BIT(PB_migrate_2 + 1) - 1)
 
 #ifdef CONFIG_MEMORY_ISOLATION
-#define MIGRATETYPE_AND_ISO_MASK \
-	(((1UL << (PB_migrate_end + 1)) - 1) | BIT(PB_migrate_isolate))
+#define MIGRATETYPE_AND_ISO_MASK (MIGRATETYPE_MASK | BIT(PB_migrate_isolate))
 #else
 #define MIGRATETYPE_AND_ISO_MASK MIGRATETYPE_MASK
 #endif
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e534f31a6b39..7a67250ccfd5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -370,7 +370,7 @@ get_pfnblock_bitmap_bitidx(const struct page *page, unsigned long pfn,
 #else
 	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
 #endif
-	BUILD_BUG_ON(__MIGRATE_TYPE_END >= (1 << PB_migratetype_bits));
+	BUILD_BUG_ON(__MIGRATE_TYPE_END >= BIT(PB_migrate_2 + 1));
 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
 
 	bitmap = get_pageblock_bitmap(page, pfn);

-- 
Wei Yang
Help you, Help me

