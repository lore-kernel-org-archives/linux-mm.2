Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F16EEC98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 06:35:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CF116B0088; Wed, 23 Sep 2026 02:35:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87FF36B008A; Wed, 23 Sep 2026 02:35:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76E326B00AA; Wed, 23 Sep 2026 02:35:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F1D46B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:35:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B83B7A0711
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:35:55 +0000 (UTC)
X-FDA: 85244066670.19.C3BB126
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id E948D40008
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:35:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y6nkKtCz;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790145354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0lkUVys8gvUjF/9PcP1iToEGr3wc3OwcQw4hSpUPIN0=;
	b=sAGPh67gJW/4RLfwZvA20r18HrXB36d2am8wdkYHXeITRYpYtvno9p02XTPLFN9ZUivSjF
	mEqa1hz223a+LZWMVwhfYIQFmiOix9Cy1ep5llw9fINYu1LTPqME1LZMxdVksyE/G9Rgwe
	DIXBdOSI+gTw8qBPCwwauPdbuVZoNTY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790145354;
	b=jVA5KKlSETmkOl9CJcsS7OBBXkjquLgvEk0OtR9mv2jIFvzgM9wb1ioLkU005KW0rPR5vo
	enCPUyMwYsHijxoLrna9jdcX5np5P5TRtbizPOhljVITR7E0Bw6eLdBucr4nN21ckaPypu
	GPUpsrtGVm++N9qw6ktDcRNUrnU7e74=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y6nkKtCz;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 29120436F4;
	Wed, 23 Sep 2026 06:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F34E1F000FF;
	Wed, 23 Sep 2026 06:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790145353;
	bh=0lkUVys8gvUjF/9PcP1iToEGr3wc3OwcQw4hSpUPIN0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Y6nkKtCzEeqId9jMLa0VpqG7vVmn6qXI47fFEsnF917E5SKaQy8E14ioPXN/eoegQ
	 CfgIhwCcqL1okZeQtygWog5zd0RFe+uSsZXrzBmPHzWXEJtXG4ypSy+1uD5rFx9Cj7
	 l/9d6pUxhAMnzY4DpakXGPQ7BZPsnQECF3dV0jopfD4LGmhoEGsvCxRlCxIert7RYm
	 IE2KgQ2Xs93KwTdDGmGbOPGanWdhNR0wzp8hJs1oXu/lL57s9Qm0trbH93804Yz3oh
	 kTdqLdQ5HpGG0fDu+C+Zc5TGoeH2uT3I0dfV6+9T45m+fCB7i6NV574TgvmTMJisBa
	 ruNJ0CX+0KYVA==
Message-ID: <7ea6e90a-e2fb-4793-b6ea-e292388bdfdf@kernel.org>
Date: Wed, 23 Sep 2026 08:35:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linus:master] [mm/secretmem] 97d34aa65c:
 stress-ng.secretmem.ops_per_sec 99.5% regression
Content-Language: en-US
To: kernel test robot <yi1.lai@intel.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Daehyeon Ko <4ncienth@gmail.com>,
 Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>,
 Alexei Starovoitov <ast@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Hagen Paul Pfeifer <hagen@jauu.net>,
 Jakub Kacinski <kuba@kernel.org>,
 James Bottomley <james.bottomley@hansenpartnership.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>,
 "Liam R. Howlett" <liam@infradead.org>, Michal Hocko <mhocko@suse.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Suren Baghdasaryan
 <surenb@google.com>, linux-mm@kvack.org
References: <202609230824.7a9189aa-lkp@intel.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <202609230824.7a9189aa-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: knrkxwd93xdcyajhwwxqqksd7m75gj8n
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E948D40008
X-HE-Tag: 1790145353-643638
X-HE-Meta: U2FsdGVkX1+z151n/BhS1k2ZAMBxsa7iotFVkOGfSbl423/MPZ6qjjS2mVpv9CsaDD245Fr60FOZZIu0zW0IS+ZkLNEaLdLsyxuKd7LqmfT2BSt8GyoxiTXVOvR1eRnR3O58Qjl3n1fPc9GM9N5vRSP50JehgFae/8jZZ3+fHosDg1/xN+I6b7UWxihLuFlqep88qwmL239ruMCRMBv9h5FBEbZkG5ZF3ljWZO5li7KsAjUnqdfVXqueZo3BPsLp4XXEEnh7Z7agQVlWPsPtR6A684avmdHVBCyo2GlfNFEUWA0rVA0uimUCYJjPKFINJy9oEJwxBmo2UCCD/IUxkqb5nyQ9CvAI6dIHGFW9PqGbdMfgZ+t1lc5F/XMcXrQ0qAhbZ3hjQdpLsCkOXIwcbxFA1TSPIWxsR7XjH4soQ4K1KieZl4dkJ3YkuJRjyutql1yu5XxT6Io9zKfaDMUHH6DG+VS6AiZSPrDclcZ5uRYkvl6H17Nr9Bl0KrFBrhhzru364CFRWmn08LBTzccAF8EFJ15SIJDTAXq8GH7bHVYu3Pr/WFynKxD4hlEbV4yD7lCNeK8Pc5VDyC1r8Ei8YjZryb4GV9fwTjI69anxW/E2m+dj5NtG5KgJCg9G8BDseXC30C1PIszi8V+EjWkH2ArOW0MQdlHwQYkwyCRYMcAU9xMBbsPmeyI9hyYnts2YJQ92ir7TmYO3yfkTHUKmxfGrYz8udDRQng5oajtXMqoeI1xGPokvZpJ41pM+kFQx3BeBPQfhVmF+PGKnATJ7JBmgTwg3RWyjdnOiTVxzL1KKtL7npLPA+40ntRjyr3+kUfKCOTSKmCNeu08eg2sUtSIYCya1glDyXd6tLyRz9XW0bkYImEoNrxKn7hWGpkDOwV0PxXq+qkhGM+6fL54w4HmS0pMNDpfzhvu1AAavBURKr7EjRR7D/akf4ggte+pFFGXwXVJME28LX1SN5pA
 ZcWwM2zD
 NzfAO5jt5AbTSz3f8WR8H253qG4RlmWSHDbSrDh0mQpfYNT4y6HFLGPLvsePP6vYl28RoEPhAwiFbZdTby7KAgUnvQ6/h3Ql0XwNWblUMdA0en+2LQwZlpZ91RqHoVBefap2r3/uQCqBqlyGdkLyZNHoJoUwwAMI+I4vrw37RdUdDXs2d/0fleHfJ8xn1SxBZOduSjLXazasUR+qfIHoNrz9wJAL6zmdPq6H+S00o9/yqXFcRJ6xXe1sEMEwtdp0Gp2zd71pYxW9vaicGicuY222jNZs9Nz0DDJDlJ6VE36KPc327qHfV6MI0Nlbmtqr7e4M1NdDLhWj4kxpTrKKrh1ERmEpjmQKh/ipaZz3yTxQ5LSh/zwknKMeC9ZoxD4FdD6QlegaZ6zyHNsaF/VPdCjKSsKE7xnYcoZFUwJg6UwmAkwWFPzKEfMPJX7WyCxqwALv57PgsYHlHyqsYPhnTmYE/UDaTVADGPs2j3z9KAScqPRyVOA3xAxb7U/M16A3h6rvO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/26 03:00, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed a 99.5% regression of stress-ng.secretmem.ops_per_sec on:
> 
> commit: 97d34aa65c29cca85e3e9050f4c936389b38a054 ("mm/secretmem: properly account locked pages") https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

Well maybe there is some inefficiency that can be fixed (haven't checked)
but if it's the cost for proper accounting then so be it? I doubt creating
secretmem pages is something userspace would have to do intensively enough
to matter.

> testcase: stress-ng
> config: x86_64-rhel-9.4
> compiler: gcc-14
> test machine: 224 threads 2 sockets Intel(R) Xeon(R) Platinum 8480CTDX (Sapphire Rapids) with 256G memory
> parameters:
> 
> 	nr_threads: 100%
> 	testtime: 60s
> 	test: secretmem
> 	cpufreq_governor: performance
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <yi1.lai@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202609230824.7a9189aa-lkp@intel.com
> 
> 
> Details are as below:
> -------------------------------------------------------------------------------------------------->
> 
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20260923/202609230824.7a9189aa-lkp@intel.com
> 
> =========================================================================================
> compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
>   gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-spr-r02/secretmem/stress-ng/60s
> 
> commit: 
>   35b0fb391b ("mm/mremap: reset unfaulted VMA page offset for MREMAP_DONTUNMAP")
>   97d34aa65c ("mm/secretmem: properly account locked pages")
> 
> 35b0fb391b0df573 97d34aa65c29cca85e3e9050f4c
> ---------------- --------------------------- 
>          %stddev     %change         %stddev
>              \          |                \  
>    6080503           -99.6%      23092 ±  3%  stress-ng.secretmem.ops
>      85584           -99.5%     385.28 ±  3%  stress-ng.secretmem.ops_per_sec
>      71.48           -16.0%      60.07        stress-ng.time.elapsed_time
>      71.48           -16.0%      60.07        stress-ng.time.elapsed_time.max
>      97435 ±  2%   +1276.4%    1341103        stress-ng.time.involuntary_context_switches
>     230308           -96.1%       9096        stress-ng.time.maximum_resident_set_size
>   18401243         +3349.6%  6.348e+08        stress-ng.time.minor_page_faults
>      20417            -8.7%      18639        stress-ng.time.percent_of_cpu_this_job_got
>      14581           -25.0%      10937        stress-ng.time.system_time
>      13.34         +1858.5%     261.33        stress-ng.time.user_time
>       6898 ±  2%  +96037.7%    6631576 ±  3%  stress-ng.time.voluntary_context_switches
> 
> Disclaimer:
> Results have been estimated based on internal Intel analysis and are provided
> for informational purposes only. Any difference in system hardware or software
> design or configuration may affect actual performance.
> 
> 


