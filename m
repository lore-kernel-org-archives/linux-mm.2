Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48B90CD37AC
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 01:52:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE3686B0088; Wed, 13 May 2026 21:52:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6D7B6B008A; Wed, 13 May 2026 21:52:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 935666B008C; Wed, 13 May 2026 21:52:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7F1B46B0088
	for <linux-mm@kvack.org>; Wed, 13 May 2026 21:52:22 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2D84CA0229
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:52:22 +0000 (UTC)
X-FDA: 84764350524.21.8534E37
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id CD927C000D
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:52:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MP6FJLdA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778723539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5nvZWCIe8eIErP8hr8TwPvr6Up6QixBNDg3fotBUjkw=;
	b=bPMdNZ2uEcbw1sQbVRIhFy6fwiJRC7n/uPeasrHWWJ64jpavGz7e7lHdPSyyMcM+3bCid0
	u0QT6Sm7/CSM5nu0OWeYqnHXSrpu5WIdkuXulq94hiz4LgAGmpeoepWYGF8uXe0SmkbL9T
	PGpIu2sqFJ6djqmzaReX2qL5EHUdLhI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778723539; a=rsa-sha256;
	cv=none;
	b=5bzPWeCctVnJclhAMNCm0UuwrpZmMqiM2H0Nd31GAa3m2jE8XZyww4wQVJ4C3G8WCWcLYL
	vYUv2W8vWmmpeC4XSeqmWppAM7Nr4MIKYRPWVlIMZ8ZDTt/gBzoLOGT374gLUVQPCojYfw
	TvCW+It4OqosjuDmNEmhz7LDEG67pl4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MP6FJLdA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778723539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5nvZWCIe8eIErP8hr8TwPvr6Up6QixBNDg3fotBUjkw=;
	b=MP6FJLdAb+aMkqDiQhFbEqdE6yNgUm7ozwMyzgSNoG2ELaXtXXKUZ3Hv4r9kXLlzMWzuUT
	zKqgCVwpZjT/7FV6PQ7sf1ISKIzI41FsAfjw3kI5bIk66PoL3KPEaT3gp1u6fmwAAZ5Axf
	7kgZcvxqLg+9J50uwsHOVGsM2Yb7kkY=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-c_EXG9PCMf-v6YKXPYxnKw-1; Wed, 13 May 2026 21:52:18 -0400
X-MC-Unique: c_EXG9PCMf-v6YKXPYxnKw-1
X-Mimecast-MFC-AGG-ID: c_EXG9PCMf-v6YKXPYxnKw_1778723537
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-515224a8aa0so66316821cf.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 18:52:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778723537; x=1779328337;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5nvZWCIe8eIErP8hr8TwPvr6Up6QixBNDg3fotBUjkw=;
        b=SFuf0/mrmyx5YelEDwR5gjJGwKM+T+48sX7Bfe0vA/WdNdybxIreh9BwChB3hvjttr
         ql3jsf61FgbkzhyvTiURjncDdrFp3+UX3+IHUaUv1M8hpU59sA11avILAweTjUQX8NG4
         Lr2ntS1QoJgXg4lwZDZ9u4okvSgnjQ0U2GGZ5leXk6GVLOhNYC8Ss/Hv90C+VtcBQNX1
         rh+JZ9zanSGJLLUV0CGVfoFyqcI4R0EUjLMvhaSkWOYStfyxOz5vRWwmvbZz0i5JBe7e
         RXH/5Z4uYlRf7Yx+prIhXiwROl7zZTVwOkJiaLsPFpXRiAp8iLK4P9zztlfs7Aecpxni
         Xl9A==
X-Forwarded-Encrypted: i=1; AFNElJ/ronvTe1Ad0n+bMzLvNVZ4mlx630QeEFJZ9R2+X/9/iak4JvL1w0+WYlm5FtyM/O8ryed+SIeUOg==@kvack.org
X-Gm-Message-State: AOJu0YyYpTun21Rpc2lTa3pUkqRR011jD3Ra+dvCRgz3BRSYofKmIezF
	v8baPcvbtJr8cMYcY7ffUs3WJcW6DrPwvEj0v+d0KnKtrAm5wdJ5LUjv4uDc36gTWykFd1IVUop
	WNOq/IeM8InuoKaVmCLPMMhkECGyjF7F77oT0uouJnXAxhr8W0teW
X-Gm-Gg: Acq92OEGgLv24BkSY36faaX5I4/9kMHUEDbo/19017JX78Sim1m0Fb/qopcU1Ty/cA5
	bFy7FzN26/ByVW1q69Fbpf9GHXRpC874Cuh+4R0xvpZgr/LsF7UtaUD2+HS/qbWRYnQZwZ2k1HJ
	/DU82qMzvQw4muLoZS6RR/ofMyGJdyRZlmkMP/K+x/2iUZ3r17zG9GI9Cnm7HWCBxShtDcH5yqw
	Qwl7dUsreybHt1EJOrko5AzmRcJmx30J2e/M7VVvLr6zEuE0ImAfq1GhOWDLeVwIcg2LZrvz6PP
	ouybx3hPeW+UaILz6XrgWaHIj+I1tyaKPrNClcRctHW9Ev0sRsZ6p8oNwXDQlcea/YAhIs8grc0
	5ZoEBOLWtWVo5VD+raonGQxZj
X-Received: by 2002:ac8:588e:0:b0:50d:8389:c3f3 with SMTP id d75a77b69052e-5162f66b122mr82859001cf.54.1778723537420;
        Wed, 13 May 2026 18:52:17 -0700 (PDT)
X-Received: by 2002:ac8:588e:0:b0:50d:8389:c3f3 with SMTP id d75a77b69052e-5162f66b122mr82858731cf.54.1778723536896;
        Wed, 13 May 2026 18:52:16 -0700 (PDT)
Received: from [192.168.2.110] ([70.53.202.134])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51645d51f06sm4342921cf.19.2026.05.13.18.52.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 18:52:16 -0700 (PDT)
Message-ID: <8d365dfa-98e0-478b-ba6b-377c939865d4@redhat.com>
Date: Wed, 13 May 2026 21:52:05 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/9] mm: introduce pgtable_has_pmd_leaves()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
References: <cover.1777663129.git.luizcap@redhat.com>
 <2a0bae00cdd2b6ef6b962610b523ebfc97806ba7.1777663129.git.luizcap@redhat.com>
 <8683a04e-54e9-4e8e-8931-69e31d15b99b@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <8683a04e-54e9-4e8e-8931-69e31d15b99b@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uhRXeUEo9wUSh8llOuo4sm8F0H8Qpg7NZFM7zrZSyVM_1778723537
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CD927C000D
X-Rspamd-Server: rspam04
X-Stat-Signature: d97nebf33wuyhjio1fwy4111jhngtef5
X-HE-Tag: 1778723539-135499
X-HE-Meta: U2FsdGVkX19RyYU9n1F/Qcexn8pXfVRKgJCtzpE+lZqNFDg6/fq29kIE3+qSxkwzx3vScEX2+IXvxuRhvh1BDvaiY+WTcIQCiIgMdNkcaBWKeMZdi9vbL3akm40BbKQFm5rVXgXAHzIXKZu21wgb+rMjcrQXfI8ukC355TUQGUPEfSrWyRpr8uDGiI/HDYW8tdhc359gVI5RZxYwyDOaF2CMBCDd27zund3jlh6dOda9kW2MEgwD1ZKvgVEFQmithXRueWuKeZnuzo3CQ6Z5DRgzCzW9PXAhyWB8Ux03/wc6lDqqMRCFt1ix5W7GKGUMaumxCDXCw3FjG6IE2g3VtNVteLabOgw/M8c30jeH23uFxssgZHiOBrYLG760eqAcWOoGyqGo5suW8ZkwpdvvAjY+rnL2q7HKfJNJSVXbdWtoifgik/jmMp9UvxMJX9UKzTsOC8FVyrcly7vP2hNEHva4+5+2HgmOKW1+WPDxd54mWRsWxLgPPfHnlAK6AeDnzHo8FvJH1WyTSCD0HQ8rW5YLTi5i6A8IhO1yuWdxEDpmQO+6MZyNoV5RtkPTobrYP5oZMtxhB6pVqT3H1/0m1pzYdzklBXOuLbOTEP0EufTGGfldqCyXlnlr7Sfy2ty1qECQzR0RPLeRrEN/ikYt3/5//1JWMBF85Nbdnx+l6rmeNAri9cZSjXL7BhcKr+nvBPQumTFnDfFP8Hx3diocmoM1ymDLks77gjNNWQMY3fNJemHmZ1g2W5fXe67p6SNfmHyMEwOszMbiA9X9qK/iFp3BZVzg0KkkmajpzvzUPw35vxvz6bHftbSsCXkWrVyaXPe+iHA/vdnkb6NeqvWRgYYOT+Yl5wMHBjQa7VGGjEZKOZGRvrFxKOo81UoMtX2rcIacv13RobLCR2lMWooMHyIigM9tpWioo1/YH+RWDYwQCpcwxWHZmNXTMmJaBEIL3sdBjsRyggGoPDxNkl3
 82emsFH9
 6htk4eC8fRlRhzhx8mkslBEBSslQiJC2s+d/DvbpDVb/m20pVuF75kyutf3+dlIV2ZBsyHM9IGdGIsHAnJ7C+KmqW1+H1Z+Ai9FycrflfJ1Lur83FGISEpEYc77GNM91Gmynb80Bb0kg5FW6dqsNYKu2jT5wkA3PJmXpkyStnnZf7oTav+vPmWRQktO7EQyyxTigEn1i7uKtpqndWQ4AUZx9in02SEYEdi+nFcKawOuRqfbVWc0bZChdMGhXx79/pqzYsJVv0zOesAjD62Fig6mQ/gY4Mk5njWRDHqkXydTRfCydejza8IcRewAnhLspddqq7BVQnc31ka+akXqnR+rVAIKvfpdHndIWBdq/f+3MfMafGCWDxbQKAR745OQYxvBJaNdZvHST4RgvbcbvshvyU1Puah7Iw8/uDqokqNt5GZBTV7/yLsvt7IL3LdhWAyOIVPqdrwdHytDGeyOIUkzGCsxF5OH1e9qZjre9IdtugUzMhmG7qQl5tHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-13 11:30, David Hildenbrand (Arm) wrote:
> On 5/1/26 21:18, Luiz Capitulino wrote:
>> Currently, we have two helpers that check for PMD-sized pages but have
>> different names and slightly different semantics:
>>
>> - has_transparent_hugepage(): the name suggests it checks if THP is
>>    enabled, but when CONFIG_TRANSPARENT_HUGEPAGE=y and the architecture
>>    implements this helper, it actually checks if the CPU supports
>>    PMD-sized pages
>>
>> - thp_disabled_by_hw(): the name suggests it checks if THP is disabled
>>    by the hardware, but it just returns a cached value acquired with
>>    has_transparent_hugepage(). This helper is used in fast paths
>>
>> This commit introduces a new helper called pgtable_has_pmd_leaves()
>> which is intended to replace both has_transparent_hugepage() and
>> thp_disabled_by_hw(). pgtable_has_pmd_leaves() has very clear semantics:
>> it returns true if the CPU supports PMD-sized pages and false otherwise.
>> It always returns a cached value, so it can be used in fast paths.
>>
>> The new helper requires an initialization step which is performed by
>> init_arch_has_pmd_leaves(). We call init_arch_has_pmd_leaves() early
>> during boot in start_kernel() right after parse_early_param() but before
>> parse_args(). This allows early_param() handlers to change CPU flags if
>> needed (eg. parse_memopt() in x86-32) while also allowing users to use
>> the API from __setup() handlers.
>>
>> The next commits will convert users of both has_transparent_hugepage()
>> and thp_disabled_by_hw() to pgtable_has_pmd_leaves().
>>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
>>   include/linux/pgtable.h | 15 +++++++++++++++
>>   init/main.c             |  1 +
>>   mm/memory.c             |  9 +++++++++
>>   3 files changed, 25 insertions(+)
>>
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index cdd68ed3ae1a..b365be3516bf 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -2243,6 +2243,21 @@ static inline const char *pgtable_level_to_str(enum pgtable_level level)
>>   	}
>>   }
>>   
>> +#ifdef CONFIG_MMU
>> +DECLARE_STATIC_KEY_TRUE(__arch_has_pmd_leaves_key);
>> +static inline bool pgtable_has_pmd_leaves(void)
>> +{
>> +	return static_branch_likely(&__arch_has_pmd_leaves_key);
>> +}
>> +void __init init_arch_has_pmd_leaves(void);
>> +#else
>> +static inline bool pgtable_has_pmd_leaves(void)
>> +{
>> +	return false;
>> +}
>> +static inline void __init init_arch_has_pmd_leaves(void) { }
>> +#endif
>> +
>>   #endif /* !__ASSEMBLY__ */
>>   
>>   #if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)
>> diff --git a/init/main.c b/init/main.c
>> index 96f93bb06c49..eea7c5bdddf7 100644
>> --- a/init/main.c
>> +++ b/init/main.c
>> @@ -1053,6 +1053,7 @@ void start_kernel(void)
>>   	print_kernel_cmdline(saved_command_line);
>>   	/* parameters may set static keys */
>>   	parse_early_param();
>> +	init_arch_has_pmd_leaves();
> 
> Can't we do this a bit later from some mm code?
> 
> This feels like something that can just go somewhere into mm_core_init()?

Yes, this can be done. My intent in calling it as early as possible was
to allow callers to use the API from __setup() handlers if needed, but
since we don't have this case in the code today we can put it in
mm_core_init() for now.

> There, we should probably call this something like XXX_init(), and prepare it
> from detecting support for PUD leaves as well.
> 
> Maybe just
> 
> pgtable_init() ?

What about pgtable_api_init()? I'm afraid that pgtable_init() might be
confused with code doing real page table initialization.


