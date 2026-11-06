Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C937E606A332
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Vrz8qWT1
Received: by kanga.kvack.org (Postfix)
	id DA2486B05B1; Fri,  6 Nov 2026 02:53:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7A9C6B05B2; Fri,  6 Nov 2026 02:53:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB7126B05B6; Fri,  6 Nov 2026 02:53:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A523B6B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:53:20 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2777EA08D7
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:53:20 +0000 (UTC)
X-FDA: 85403928960.11.0D6E744
Received: from mta1.migadu.com (out-29.mta1.migadu.com [95.215.58.29])
	by imf05.hostedemail.com (Postfix) with ESMTP id EAA7E10000C
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:53:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Vrz8qWT1;
	spf=pass (imf05.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.29 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793951598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nfNxFDQT6Xg6nXD5htivaWJyrQFYadRTu+IGG2oGCYk=;
	b=M64OaXjLP3nZjoDDjtjE4wiZobAU/rs/k23Fe3gJ5VfzJOPpSaGYIovPAJN9B/21pyLKVw
	QKt2x+FjdCVnCctjIG/57cg1sBKplro2AKgothP5NnUXER3x0T+KVSEuc5JOTpBmJSwqg6
	I0nxi4qm2K68Dtt3+qeYoGkX+0CQa+A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793951598;
	b=8XHXK6uK/eKPfmAMFiwIZfsEoSlSP4j2uqSQSVS+5WVG0siyQnGMRq36aj8o6TngceFyIn
	UI63jT8HUUVxQQgGSvIlZEbmLso+JC4zHrHG9en/Nk6a9E0DgafWmp5ZzxfSG6wjcO5k92
	OieXxDW8rHO/BVGkvr5WNkugBziWMhI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Vrz8qWT1;
	spf=pass (imf05.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.29 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=n7/NfrBJOVijHE2gqo7g667Jx3EWyuJGPjofeyvSjCA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793951594; v=1; x=1794556394;
 b=Vrz8qWT1P4W9M1nqC7wjtd2uGW5JAlG9erVpQzw06B9GbkT6XnYaHIpRQcPtbd4IOmUWqM4H
 DVyTGInze+DPWjDsu8AJ43BejySZ2F3e/ej9Kc9jOPYkgMN29gUnE8PKXIsR4EeJl0O0LyCjyek
 7yhi2bihAA0XiJytIXTUi6ws=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e8ec85b10918d5e0;
	Fri, 06 Nov 2026 07:53:14 +0000
X-Mizu-Trace-ID: e8ec85b10918d5e0
X-Migadu-Flow: FLOW_OUT
Message-ID: <9a4323e1-a966-41fe-8268-9d6621346fea@linux.dev>
Date: Fri, 6 Nov 2026 15:54:33 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/5] alloc_tag: Introduce IOCTLs to toggle allocation
 tracepoints
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Abhishek Bapat <abhishekbapat@google.com>,
 Suren Baghdasaryan <surenb@google.com>, oe-kbuild-all@lists.linux.dev,
 Linux Memory Management List <linux-mm@kvack.org>,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kernel test robot <lkp@intel.com>
References: <37ae7dca766994d3872fcc65b623a80d5d506369.1793818636.git.abhishekbapat@google.com>
 <202611052344.mDV2DB89-lkp@intel.com>
 <20261105172104.339c6f598a65056ed46e56fc@linux-foundation.org>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <20261105172104.339c6f598a65056ed46e56fc@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 6ajrg1d1oesht5xq486iprk6o533gk8p
X-Spam-Status: No, score=-22.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: EAA7E10000C
X-Rspam-User: 
X-HE-Tag: 1793951597-789576
X-HE-Meta: U2FsdGVkX18Z55igiz5vHRIs+2zo6b/vJZKDK6VIeQeocTtaPuatQdTgFXmvqusI54p0eXauj7RUmgWuvsCuUh75h/JqDVU3yp7rFT4gKed7xHtq6dknbwZaOHtc2fgs3n1NIJBKCXlx6rut0wU6CKYYRs9iURpGsl2hWUtcB0VqJ0obu/oKff3PDO/z4p0VPPkBdNdYKZ+iJjhX2hFPRWNizX6io/9NNUl4DS+YpJcYRKrGhJhLMKXk/e4KA7OEKr8p5HFiKjw+PX+iMruyy27nJXT1cVw+MSOZsG14kN53HKZ4hWDyk/FJr0egbDPAlkcEs1r6qHhk/I9ZeRqwRRi6uUe10zn09DVGQNzYI3XSULvYAzr0h+GhQ29LnkLhRqi967rn8Kb9WQM7WjHmvlYNVebMV4UL9HGBPRAHu6HZrm+676tPkEwXsNe9s8suOY1fV92uEOBLuFaX9/Ppsbn+ykF9FDzqvgio2uuoiFZUNOLWPMyHoRoYhUjWvkkBpEfGMu0pUvW8xiKcxTNLqbGe0JzV+hqJa/fG3OX/SKAdsnRYSvZbYUNB3NV/vgGOUKpiRJlMUYFBbwxzuz08aaoWp8hQTagoBc2lgd98kzkwvKQQUnghfpX8r2LUya8WMrf9fjfDwQHs1ZyFixMrT9quf4LH3msOgX2R5hXJH29PSkj/hlqLY5/ZwTcZAYvTNXDmpkDqeoy5Ylg1MHhgn4ATAsp87t8Yr5O+TIpW7gBQ8HKF4aN9ac+0j/3yirxfnZOOxS4ibgWkjgX5aO0ORAL1mEk4wKa0fqHLlT5U3mvilV11e7u/oo7J1R2pV9nwTM0e2PmM4RtJwEFo6HFdJSAqqi63S6zNpFONteB6r6DFSHwg0WjRDB0vgpQzrLZfML0LTPHpo13WWLN5VJsmd5ePb9iXPxqpPvIEIVahT9nXyswQtYDmZ7CuIM0b2hRvageX8ECdQ/4lA19dr3T
 SwrD3a7x
 KUddOHS+oNWiO1vJ3zAv1/p/U23jzy1iHKFlaVXlTohqjIvAFw/q4S6n0aD7H27TDoVcuoAb0yZVymH6QlfCFjim8lSghQrNLmUMo/V1teONM8RBxY0/fLFeDwzGfkwq/7yXZkQKiQX8R2Wj/zzyxhItqxct4g7S8LnM7QzNM4BfiPdBEWoYRYEJRzI+C4SxOHsetKO/7EqkEAAFtNMVfnY8ALD9DeyW/W/b+4fj4GEgUyjB1vTL/78LGj42iuTQvyDTKBiE4IrvbowF39IXgawOpfEXhPUw8EwVRCu81fNneB0CrzLq2lOdwoMthIAh/Z3aBjQuMsW18lmv7MwAaUQ/2xKJAa8c75Rpu+Jv3ETMjCN6ejKYN1Z3YUkkfU3gQD1hCYN95Xajo0XQTYtVA3E2aKfPA3v3+Q8Bt5qMs7RsPI2Whk5Xc4NyjAEDhSi9biG8Bl+vwxJiHzLz37pSAqv/H1EbpX137Q14pSirMTPze9UEkPHMEJVQWhsBPlasvNfipKtklzxc90hrvU2BdNExpsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Andrew

On 2026/11/6 09:21, Andrew Morton wrote:
> On Thu, 5 Nov 2026 23:15:33 +0800 kernel test robot <lkp@intel.com> wrote:
> 
>> Hi Abhishek,
>>
>> kernel test robot noticed the following build warnings:
>>
>> [auto build test WARNING on bcc036cfa1670a64500f6d857eaa71908b79e3fb]
>>
>> url:    https://github.com/intel-lab-lkp/linux/commits/Abhishek-Bapat/alloc_tag-Add-trace-events-for-tracing-allocations/20261104-190336
>> base:   bcc036cfa1670a64500f6d857eaa71908b79e3fb
>> patch link:    https://lore.kernel.org/r/37ae7dca766994d3872fcc65b623a80d5d506369.1793818636.git.abhishekbapat%40google.com
>> patch subject: [PATCH v5 2/5] alloc_tag: Introduce IOCTLs to toggle allocation tracepoints
>> config: xtensa-randconfig-1001-20261105 (https://download.01.org/0day-ci/archive/20261105/202611052344.mDV2DB89-lkp@intel.com/config)
>> compiler: xtensa-linux-gcc (GCC) 8.5.0
>> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261105/202611052344.mDV2DB89-lkp@intel.com/reproduce)
>>
>> If you fix the issue in a separate patch/commit (i.e. not just a new version of
>> the same patch/commit), kindly add following tags
>> | Reported-by: kernel test robot <lkp@intel.com>
>> | Closes: https://lore.kernel.org/oe-kbuild-all/202611052344.mDV2DB89-lkp@intel.com/
>>
>> All warnings (new ones prefixed by >>, old ones prefixed by <<):
>>
>>>> WARNING: modpost: vmlinux: section mismatch in reference: alloc_tag_trace_enabled+0x2c (section: .text.unlikely) -> initcall_level_names (section: .init.data)
> 
> Thanks.
> 
> #syz test
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: alloc_tag: force inline the allocation tracing check
> Date: Thu, 05 Nov 2026 17:18:09 -0800
> 
> alloc_tag_trace_enabled() is declared inline, but the compiler can
> still emit an out-of-line copy. Force it inline,
> 
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202611052344.mDV2DB89-lkp@intel.com/
> Cc: Abhishek Bapat <abhishekbapat@google.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Hao Ge <hao.ge@linux.dev>
> ---
> 
>  include/linux/alloc_tag.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/include/linux/alloc_tag.h~alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix
> +++ a/include/linux/alloc_tag.h
> @@ -161,7 +161,7 @@ static inline bool alloc_tag_is_traced(c
>  	return !!(atomic_read(&tag->ct.flags) & CODETAG_FLAG_TRACE_ON);
>  }
>  
> -static inline bool alloc_tag_trace_enabled(const struct alloc_tag *tag)
> +static __always_inline bool alloc_tag_trace_enabled(const struct alloc_tag *tag)
>  {
>  	if (static_branch_unlikely(&alloc_tag_trace_key))
>  		return tag && alloc_tag_is_traced(tag);
> _
> 


Thanks a lot for looking at this - and for putting together a fix at all.

Perhaps alloc_tag_is_traced needs the same treatment as well?

Even with your patch applied, I still hit the warning, just attributed to a different symbol:

WARNING: modpost: vmlinux: section mismatch in reference:
alloc_tag_is_traced+0x10 (section: .text.unlikely) -> initcall_level_names (section: .init.data)

Marking both helpers __always_inline clears the warning in my build, and it would fit what the series
intends for the fast path anyway.

Thanks
Best Regards
Hao

