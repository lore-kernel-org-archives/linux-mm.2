Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C451CCD5BA4
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 13:10:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E4736B0005; Tue, 19 May 2026 09:10:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06E446B0088; Tue, 19 May 2026 09:10:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E77F06B008C; Tue, 19 May 2026 09:10:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D07326B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 09:10:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 84A971C0121
	for <linux-mm@kvack.org>; Tue, 19 May 2026 13:10:56 +0000 (UTC)
X-FDA: 84784204512.14.2E99BD9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 32CB6180014
	for <linux-mm@kvack.org>; Tue, 19 May 2026 13:10:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MT5XvfwK;
	spf=pass (imf24.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779196254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hfKyHULyWnt+c43l1s7YrMHg5D6XgPXbD4Wqa8YT228=;
	b=rblby93kkbUMtXUYWjjn4OTkMjCsASTIVjcGocpsqf8tPGOcVoSIwRwlzkcMKCr7Hki1KN
	0A2uMQRUgxVfr7WBUQQuk2DQGppd5Ub/CTtAYaDnH7QlH+BiWWKI46Xp2aackSsai1dl9b
	n8CdL3Y3wY7OWYgSFI/LsyXNM6swI30=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MT5XvfwK;
	spf=pass (imf24.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779196254; a=rsa-sha256;
	cv=none;
	b=AvwZR3hK+BGlkVaDFBTh/YDntWWd2hu/KOLKc2wuZD2Xy7L4957vc6Hi/EBcljcwZnkOWb
	+Dg2iYJqBkSYaj+RYa/vwe8TwngEo2ZmoGt3zDggku+VMQ/VkMP5BJNlhvl8cK+kanBayo
	KW0VQWIRx+YqZWEWeDqyJoFzsAcsirU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779196253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hfKyHULyWnt+c43l1s7YrMHg5D6XgPXbD4Wqa8YT228=;
	b=MT5XvfwK5Q4j59KV/SBMEeCKjJwqHyPAMiyIzVQT86PN777BwIh9tF0QYRHAfNf0VL1x3j
	JTKhR0mhT8a4gUyHcuPZ5sXl+PCJ21DpcEKegWuTxS4bvjX8pzRpkmozZNo3E0fAZzBv4c
	uUnD6AizIRlda3vag7+JH5P+CJGjHXI=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-262-XT7C9vWOPJaXMXN-9g9Skg-1; Tue, 19 May 2026 09:10:52 -0400
X-MC-Unique: XT7C9vWOPJaXMXN-9g9Skg-1
X-Mimecast-MFC-AGG-ID: XT7C9vWOPJaXMXN-9g9Skg_1779196252
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-575427e5360so3093690e0c.1
        for <linux-mm@kvack.org>; Tue, 19 May 2026 06:10:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779196252; x=1779801052;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hfKyHULyWnt+c43l1s7YrMHg5D6XgPXbD4Wqa8YT228=;
        b=YkvAc5ZKMPkIwNN5zuFjpVMQ4qSBw+fTZ0ZEXOSoXnXRiFrnPJ+v3Sa8ZXCAp4rmmS
         ZxcAfcW7K15bLivcKeqwHcKYaykqr/tnPJLCGNjnaZn2/KVjFsbul+hhugVYNh4InRUi
         4DUXUCJd2xTp5AfLJQCArvz7XvqEvcxvLNBad1vk/o/mvC8J4vOhlvxAGOXgKIWF+P7S
         nWPqOgGy8a3WQE87/QGcZ/lcazErVYOFAizvC8iUqHTtOjeLmfcODNXqPvIyMaUvCo+f
         Mwn6AZC3RrSrCHh3uOXAPqixCmsFGxmYi0+4mK+wd1T2Q8Fnh8DlnwsoyJw6SKWL9GMd
         PlwA==
X-Forwarded-Encrypted: i=1; AFNElJ9+vXXSog6xI0xSpHZzbisqAb62FATPU/HyLkDHvvFgqmDmxT7nqfKD2sWXmTVqORXqWTS2oIZ0Cg==@kvack.org
X-Gm-Message-State: AOJu0Yzb+BJqJQWu70zJnFn0OG6pXaBKORwXcCJ1G8dqr15X8S+cYYK1
	YXhlrfFdcKphJNv5q/APk8BFDNy87MG30ZFtUX1JZVxhhbtmNdrNjwf2tp7/IzPdtxJfDM8cMhY
	iOD/LLMXbIy2cMd2gAKDArvYvsSx/IeuRU5yL1hzuLJ/zCuvMtReY
X-Gm-Gg: Acq92OELLkyzbdsDYvrpSeiyAcELydQ/go59Uui3k0gJmSaWK8HHvwwjrdHvUF/h7Kf
	8z3HsRxj0qf8RHTkv2t6SF4hxs6K8ezdI3+gdADDhestdhlYbDq+m/RlKCOOzkP+voKCjE7N8kc
	oZzH3ewgFBHRIeC3HkaQXqEKNZNwxju7oxOvcgz6Xu3RwvOIAtXwoELixzDPCXzjetErxNJyqfQ
	zlUtkj0tCBDbQ03TQQQBq2AakzvbamQ5qNwlRh8jxuxxw+ha7xGMmLKfNUXglfcDL41t+vWDt3g
	f8Qp1Eu5+lN4p3GFKUv8AvjIyZIx9vGv4BGUfmFsLgPW2p6F12uKzq4LACb8x5VHJl4WBVmULZd
	QygjN2/obW5E9wxr2NykqE9u4
X-Received: by 2002:a05:6122:4309:b0:575:fea0:559 with SMTP id 71dfb90a1353d-5760be4191amr9573329e0c.4.1779196251648;
        Tue, 19 May 2026 06:10:51 -0700 (PDT)
X-Received: by 2002:a05:6122:4309:b0:575:fea0:559 with SMTP id 71dfb90a1353d-5760be4191amr9573244e0c.4.1779196251153;
        Tue, 19 May 2026 06:10:51 -0700 (PDT)
Received: from [192.168.2.110] ([70.53.202.134])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9114edfd3ebsm1697995085a.23.2026.05.19.06.10.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2026 06:10:50 -0700 (PDT)
Message-ID: <704ae752-eab4-41ba-b0f5-870f7e9e8f06@redhat.com>
Date: Tue, 19 May 2026 09:10:39 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/9] mm: introduce pgtable_has_pmd_leaves()
To: Lance Yang <lance.yang@linux.dev>, david@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, corbet@lwn.net,
 tsbogend@alpha.franken.de, maddy@linux.ibm.com, mpe@ellerman.id.au,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, x86@kernel.org, dave.hansen@linux.intel.com,
 djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
References: <8d365dfa-98e0-478b-ba6b-377c939865d4@redhat.com>
 <20260517120328.63143-1-lance.yang@linux.dev>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260517120328.63143-1-lance.yang@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TZv4D_6xrPrkk30lX5d8bQSCp07bYisn2ryW-ad7ih8_1779196252
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cnrp6519xt8jcskenuyzs3z7954fp33o
X-Rspamd-Queue-Id: 32CB6180014
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779196254-960849
X-HE-Meta: U2FsdGVkX1/B2DD4N0v0m6gbP3e6JplrXDt3Eh84tkI4ayIGAUcBNyXS+uIVl1P4KaiBnJ40L5BHacyFa05RNCLq/ybEqw9jq/M2ooQ8AHDByBC8TwEjJzppEbzU/aURfk0gZgFggwwIMXxdSkEvXbe9PcqX7dU7sBVrZ7mZbBoMZK4wUH9j4An5jJV91p/0PoM016FHQ1nTJ4s7UEyz+udfoLo/90Z3OLuSudyVW7KLknern5gqubZEFPwjXH5zQ6mzpc7y87SnAEYVDnNBNyUANxR1DFpVQR71bA6peek5Rt4I6desIy0VO8UFHRy7LR8MMFU2LbyBCzbGxFWuvXhmNd8hzaGNWHJkT/lvv8gmYwXZWxFkLuoe8xLS+G+J/8fXK6X2yOC4ELb62M6ZPAVP6U0BdbeQKHFwDuCipXfN+kzzOmYcTopqnUy0PeE6SmlaLS7l/DLqf+t70Qfc+YZ+eoDIdgrWVsrmuxiNJBKuXgfrU1DMZCUYEVtWXt37JFZbA0iA8QDLV4edOunUUkMmQg1Pg9ibwtaef5XAz86/g0MB+HKGla4fxh+ATk6Qey2z/fAEeE0Agz27rw8o6+dxjUsyWdKylAQgVupBM9q5Mlc25QzNK3+S88R/VFA7hXKjJZRsmGePwCpCBh9/ZKKU5QnpMo7Il7sLkRoblYbCg1MQC5orKJXqKOLB5voIPcYEH1+CLeFinSKh2JPc1FnQ/XMzIr48bENrnuxTkM9WlyZG51YXMYaFmI2yeFIo1WpBDYbsYi2x+K1DWrIjkO84jjzk7vT5To9+BW2qWFahy7IbW1rNboE1AORRGM1DI8UXRddQV6fX9lq4f9H5wW4cQl33Stce0mv2I0krEve8VW7W67ConuFRmRZe3ecaTCheSo8zRgwTkW+xZVVqj8PjhyX/OXYorJebVt2YMha4aat/jwdSGk1WUw9oB3HqrcwYGlQOkblQuMKjR4K
 NJa5j8KY
 58AdendrRCTsAa/el1HSfN0AkhIYeUoHY3eqskc2GbFlN1lhrDczQwl1V/pzhlxCN+KS49XOt8GU9GBrH30GOo/iMnNQBukuGg3S3GpTu5y5M7bPcF1CthmAIvZJmQv3lhr0EvqvWad90sdOJ1fGCeDoWuJ7hj1A0in8c7Wo5ujUFrsWwI+Tp8Xgx7xMldIG05gguHyaCN32nGQNlUcSTlzqZ+f/WllopL9BXGiBUwtwt+r12zAMCiKbMVW5Zeo1oAljjlpqC6KuCFR2hM0pWOguRN7f0LQqICJGGqSAOzljcawWW2nod+kHxcd+NM/n0IRU8k9nCwFmqDSvdNb2QTGshj917aggd5eCIK2yDp4oSGCFbs7V+EpydpdVIJGksLIbn9X6FRkWQENl9zPjB648eGlkNrQSahvm74+Jo8BM0jQyWQrxvVWc6+Yy2BBm7IdNeq+zjl2WBt6NGuTslnVTFvWra8lzzSO81
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-17 08:03, Lance Yang wrote:
> 
> On Wed, May 13, 2026 at 09:52:05PM -0400, Luiz Capitulino wrote:
> [...]
>>>>    
>>>>    #if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)
>>>> diff --git a/init/main.c b/init/main.c
>>>> index 96f93bb06c49..eea7c5bdddf7 100644
>>>> --- a/init/main.c
>>>> +++ b/init/main.c
>>>> @@ -1053,6 +1053,7 @@ void start_kernel(void)
>>>>    	print_kernel_cmdline(saved_command_line);
>>>>    	/* parameters may set static keys */
>>>>    	parse_early_param();
>>>> +	init_arch_has_pmd_leaves();
>>>
>>> Can't we do this a bit later from some mm code?
>>>
>>> This feels like something that can just go somewhere into mm_core_init()?
> 
> Indeed. If nobody needs pgtable_has_pmd_leaves() that early, it is
> cleaner to put it in MM init code :)
> 
>> Yes, this can be done. My intent in calling it as early as possible was
>> to allow callers to use the API from __setup() handlers if needed, but
>> since we don't have this case in the code today we can put it in
>> mm_core_init() for now.
>>
>>> There, we should probably call this something like XXX_init(), and prepare it
>>> from detecting support for PUD leaves as well.
>>>
>>> Maybe just
>>>
>>> pgtable_init() ?
>>
>> What about pgtable_api_init()? I'm afraid that pgtable_init() might be
>> confused with code doing real page table initialization.
> 
> Or what about pgtable_leaf_support_init()? It says what this init is for,
> setting up the cached leaf-support check. Today that only means PMD
> leaves, but the name still works if we add PUD leaves later :)

Yes, I can use that one.


