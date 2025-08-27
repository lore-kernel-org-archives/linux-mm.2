Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 904C4C8303F
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 06:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDAA46B034E; Wed, 27 Aug 2025 02:43:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB30E6B034F; Wed, 27 Aug 2025 02:43:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC8A28E0105; Wed, 27 Aug 2025 02:43:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BC6C46B034E
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:43:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4A8005914C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 06:43:57 +0000 (UTC)
X-FDA: 83821597314.02.6ADEDFC
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id 416E12000B
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 06:43:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="h/HTrqxx";
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756277035;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NuN0Hzveg1VevPHM5dwXORK9J21yG4BCUS7CzGTa288=;
	b=7kMIIDEeKtr3WA9/wt+RfyJG1sW6Ys3meNSGdFnCrpEvxoUY/QwDvSHdZssMgMpUuGi1R3
	0YcjL188W0rqOt+KEnaW2AC7vL+Oe2YhmztwGd4rn8MSUZbc2JC/uQ9Tdrtt20WM/cpS+W
	QimbfB1DO2pohbc4tEVsKkxdOGZs4Pc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756277035; a=rsa-sha256;
	cv=none;
	b=U+vYmrQobPixFCJ4AKUEJaCJOatuT4Yn7wWMUUccMf4QVGLpn11dQ1FGrLr1xT8llW62QU
	qXT7UKcKaG/+l1UakEB0mvGPqYggbieiIirILPy34QuPmerQSjloqW9p5xpEKZsilGXFJ3
	0tKJBpdaP8WecuVxa7CDNCo4t8yoF+c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="h/HTrqxx";
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-61a8c134533so13183518a12.3
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 23:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756277034; x=1756881834; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NuN0Hzveg1VevPHM5dwXORK9J21yG4BCUS7CzGTa288=;
        b=h/HTrqxxv8QTXAKmniKe+5N/BLwCe3LcddoG1+HzVZiYJ0VQ+Jbbvkv/c0goWsFOod
         xV8EltXo+NucmzUcFk5d3TML+2Q3gNCc6zcz6APg5FltFq7NW7qZHrctAeczYovuJhty
         y5op2/dinFFHHnUALWKPmhfjrK19IBb2vHXkkeaeGg474vQAIsXPxMH6Iu41ef5REXZD
         vqNWw3O4S1rGocN2zpT+4ZdMwkLBf0dcKM7CgQ1oXkCMsTKsgHyPbiIWujLFsnqwLXqq
         PskwURveG3h3dldu500mCecNKnGYQEqegBdxjuoLgIoGgtm/MNrD0/ghshut75GHN6hN
         rinw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756277034; x=1756881834;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NuN0Hzveg1VevPHM5dwXORK9J21yG4BCUS7CzGTa288=;
        b=vgj/4AFGrEmbUHmihQY2bwC0DB4U2uy19ttRVABk0dxk3zEqGJHoHp4RzbCDYZI50v
         nXyvlHytmassKZliyWP/rVdfz1kJEa2CPrnIQ8Me/2yTIaIV3fPTWUh3C2x5AcP0B+ll
         +wliIlRGTkP2Wbf9ua1M0mPMcXgJIrNLw8tyIWIx7JPH+QZYsVqKmFo16MoncPPfzLdw
         41o2Fo+07IIjiAsPZH0Mih3yHlGDPrrZRd6mK9SVPcP4d30l9zIpbXfxIVeMfzMULd5P
         z9+dVMqpk4H5JMx24nuHEUj/7EL4grkZZ48gxSd+MeJkG4Mnr8sL8hWnBzFlgkGBswKG
         IfCA==
X-Forwarded-Encrypted: i=1; AJvYcCUocXsQTE801aGwxvpI5pu5jT0PLPJog1z0g2YJyx7tHE2bFp7ID24Sdf03/VfECHa/aIKbmz2ilg==@kvack.org
X-Gm-Message-State: AOJu0YwDgoBjgUgRNJEDoLPqwdTMtZWHwD8iiiPHHvUzgU+etPj6lZ0c
	LefXt7Tq7WbRQRkQh8Jl3fKlnVS8By0Qe+4wHZSyg8Mfev2XJ9GQf6tX
X-Gm-Gg: ASbGnctncHJnYJJQqlmUjHnDq2RR/7xWQsPzB81zGzbxqOz15pKrEFeE3mV5MATbW8T
	nkpVsx1xqcvKERjjPLCCuy1V+IBo5OLmCIuxss5IS8h83AJdQZ2M13FMfEQGlqRD3fex+ulHtPh
	xXKXY/yQXypw51CdJzneDBynxZuN/D2LXbztQfv38a3coXm82typmezFEvZz/ftDjxB3C9LXxCG
	ZSGKwnrOEK5LtqX1HfGmH93kjIxe06N0DjTn5uVuE+dbrkQRqWCgsKozs81zLNf9YQzeC9eJHgN
	dTm5vIhiCm6z/EpQ/O5N+luog3ywsV8DmgtTh2Jrv2ztg302lMqGs/pvf6ymjcTYENMKBHXK7O9
	ZnDqjE2bBoH5i6fk7JZnDMeC2Mw==
X-Google-Smtp-Source: AGHT+IGLBYfpj6944JQgWpgZIKUQIcLP/2DQFdsOfhIT5XflYlcjeI6fU6SnY7FBz8RFz45ovWKB1Q==
X-Received: by 2002:a05:6402:518d:b0:61c:3c58:7128 with SMTP id 4fb4d7f45d1cf-61c3c587537mr9618169a12.18.1756277033475;
        Tue, 26 Aug 2025 23:43:53 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61c45040d6fsm7296140a12.41.2025.08.26.23.43.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 Aug 2025 23:43:53 -0700 (PDT)
Date: Wed, 27 Aug 2025 06:43:52 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com, vbabka@suse.cz,
	linux-mm@kvack.org
Subject: Re: [Patch v2 2/2] mm/pageblock-flags: remove
 PB_migratetype_bits/PB_migrate_end
Message-ID: <20250827064352.o5vw3f332ptlemrg@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250827021121.13645-1-richard.weiyang@gmail.com>
 <20250827021121.13645-3-richard.weiyang@gmail.com>
 <9D5D10F9-0D76-4C31-B03C-27A3A2B526AD@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9D5D10F9-0D76-4C31-B03C-27A3A2B526AD@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 416E12000B
X-Stat-Signature: qyng5p3bi1ku1p153kaycfk4efumgg7z
X-HE-Tag: 1756277034-860422
X-HE-Meta: U2FsdGVkX1/QLsYFnsD7ORDGR06oB7l5qwPlvUc9AZ6MH/FcGv7ylkH/pyekiSpJUgLVqRwNa85JXZq4VeH6jDlJB7HLnx33J+jdCMDsWJPwVjMVpU40Y+6YJZBgOyQv4zV1YM1zBM8GXSd1F9xhE1hgnc/sM1ECZYk3ahSgdDihSo/0aZvzJz/DySs3NQw2f1SLUSbI6NuAhZ969TO2GNJoDpdAuW4jLc+phK+HyEKFyFAHxZslWswjZtY64wH7rAc30yCdxByW9iA3ROG/wJUQ/DLU94XS0gLH0ViLFjpdgIuCTI0vci9ll1H/gP4aVJdZtziMUKYsaAnmRhG7GNOssN16mUIJorctUbTWnfIeDJXrUuU2RcM04/dmRlvCTGyR/gpPzaS7jqVVu7IeCov/1oYkqAfJm90KD5op1dAEXy/FdIC8j4NDEG5CLBcl0RwNsXH50xp5O8879rVsondXf5AT4vdQL3gJtkv4snz7nfwGwViyINhKCiWZVTIBecaupNaYsqDtBxVTPs7fZPRYw3ekAkFysCKv2fAXTFW9/EfUqiO2C3x+ZRnHeTim7jQcODD5QQ6kSMmhbvxeCNM7FZEQFZGJw1sCtj9zFiMLw3FmQ30BloipwaCMzRSzMCvKZLVsegacIu/gfSv/NISLgEfHdwFW5QP3dlgnqExDr5AaH3tKHl5/FJqepagqCfjdGbWIMKiVV6lBdZ28j8NWlVAxvb5sV7rhTIAie93TIU1VHBp4Yx2ax+uchCH5Gad/Mxpg6e+Mv3zGdz16N+bwCk3qyQ2JCPuqUDEW9X5fglc/1cWSOw2kNr5kyy93yRUZPtyVzhvyptExxymE5LADlGzfcX+63IS0bdAkS4WNDvnTmUbeOyZ5mXQDsNGagQNCf88kQknvXMj/bHXlX7YIPa15JE8IJRs62BtnusLVowa7bJSQsKeP9gvXoIVcTtB5dF90sNk+t4XLXF7
 WCVdRk4L
 vToEXd3xV9vRbxkdzzVZiw1h+dIcp0JfWHem0jeOBqmVKQPMcLLYLuXFUM2hn2zgg8/Z0k2c5LG9t5QyEzwU144ERroOlqizdnBmdsg3CByZxMqbHjmdZ5VIQQn1OZ93XkVRAz7FmRRb++qD4PKXyhRVENWbRXsTM0rb2UaI87WNG1roysQ6XOK7LaxBdpQEYgdoW/vWlOO2mZwnvSDUmeBLLAq4N1VyPQAPYaqeiYN6ck8VdxHViLWdn3wZUHO8az+udtRSJVBHEwPfi2KXXF5aKxKSqYlwssCVbFUk0g4S2VnaG5Dh9CCL/8VckqUxN5neeZSS9y9MNryeHw2lzkZJavq+3kIY4pTdzCOKUm3Dpa3JPn86dyVJ6sGSsrGBptvH71Yzfq0KOWo7Ce01JIYnv5/Z740Y9+rPXaWu9c7GrLJo4F/9Tn42X5u6BGBNT2OAI1IQMqoF2YBp8UbPpf29+j5Gbf/b0o5sOFLbI//tU5xvcLJNXxL1L18YlCauJZnPkleS6jEs13hmu1Q1rMDA7Wuq2VO/zmpOebwE0g8GQW3nU44PcQ3QYfQkKC44LfD+vWoRW5z4d2NHduljnGOqVnQIdsMt0sH/J7dlTYA7RsQ2ndFRjYOKKM6o5hw1H4N2sV2cueETqv2GlXOtMPam7ADnUyg6q907C++l56Z02VMZ2Oa5ckwQIE3LBZexeC3c0eGv0jC1fEQ3bcfgUrzzYAHxQItOMWnUQTCUP77XIbQIv/zth9X/fU8kTSSjNpvJ5E8ym8JyOkOmG3sd2vxc90q1gE/Y6QWKHorbPqdjvtBX9pjWamzN6CQNlRierOHVb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 10:21:20PM -0400, Zi Yan wrote:
>On 26 Aug 2025, at 22:11, Wei Yang wrote:
>
>> enum pageblock_bits defines the meaning of pageblock bits. Currently
>> PB_migratetype_bits says the lowest 3 bits represents migratetype and
>> PB_migrate_end/MIGRATETYPE_MASK's definition rely on it with magical
>> computation.
>>
>> Remove the definition of PB_migratetype_bits/PB_migrate_end. Use
>> PB_migrate_[0|1|2] to represent lowest bits for migratetype. Then we can
>> simplify related definition.
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
>> Suggested-by: David Hildenbrand <david@redhat.com>
>>
>> ---
>> v2: remove PB_migratetype_bits and PB_migrate_end
>> ---
>>  include/linux/pageblock-flags.h | 12 +++++-------
>>  mm/page_alloc.c                 |  4 ++--
>>  2 files changed, 7 insertions(+), 9 deletions(-)
>>
>> diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-flags.h
>> index 6a44be0f39f4..6e4c2da15706 100644
>> --- a/include/linux/pageblock-flags.h
>> +++ b/include/linux/pageblock-flags.h
>> @@ -13,12 +13,11 @@
>>
>>  #include <linux/types.h>
>>
>> -#define PB_migratetype_bits 3
>>  /* Bit indices that affect a whole block of pages */
>>  enum pageblock_bits {
>> -	PB_migrate,
>> -	PB_migrate_end = PB_migrate + PB_migratetype_bits - 1,
>> -			/* 3 bits required for migrate types */
>> +	PB_migrate_0,
>> +	PB_migrate_1,
>> +	PB_migrate_2,
>>  	PB_compact_skip,/* If set the block is skipped by compaction */
>>
>>  #ifdef CONFIG_MEMORY_ISOLATION
>> @@ -37,11 +36,10 @@ enum pageblock_bits {
>>
>>  #define NR_PAGEBLOCK_BITS (roundup_pow_of_two(__NR_PAGEBLOCK_BITS))
>>
>> -#define MIGRATETYPE_MASK ((1UL << (PB_migrate_end + 1)) - 1)
>> +#define MIGRATETYPE_MASK (PB_migrate_0|PB_migrate_1|PB_migrate_2)
>
>I think David meant
>
>#define MIGRATETYPE_MASK (BIT(PB_migrate_0)|BIT(PB_migrate_1)|BIT(PB_migrate_2))
>

Oops, I thinks you are right.

-- 
Wei Yang
Help you, Help me

