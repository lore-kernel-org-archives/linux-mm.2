Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F1FCD68BF4
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 08:54:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13E646B0088; Thu, 18 Dec 2025 03:54:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BFF36B0089; Thu, 18 Dec 2025 03:54:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0DED6B008A; Thu, 18 Dec 2025 03:54:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DFE216B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:54:42 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8F9FF5D4E0
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:54:42 +0000 (UTC)
X-FDA: 84231981204.02.8040937
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id DF1454000B
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:54:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XrTsMpU7;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766048080; a=rsa-sha256;
	cv=none;
	b=h2YHXiSYwTBFGCgVZIhIDJVVx8/ZO9ciDt/TBrFcnaj0fGU6KmygZVoePMNZz7mQMiiDkC
	tH2s5pE6y3ZSNOuM9/jS21I4eqvZn+fpIllszeXvZCXmdtbRQg5/+ZoE/U4XZJ0qhr4+gd
	rMEM1sWRrCOcp/9/ZicRWGrO6+GYxQw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XrTsMpU7;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766048080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r5+IG+UAl75cZNp2GjRVKWNSzto/iGu0BRRiC3FvDDU=;
	b=go5NrF0a6oo09QPi0+6bCsQnInmcUNqSxUC5ieVGPSuypk8L8/w1np4f1LnHTOsRvnh3Nt
	QADdRx3wRuhNmcgayF1nKi87kpxySuc8lnJ7Gcjozv/Su8QAcAA/30cWKIEtADzBFmmpfZ
	X62WvIpeWEjk+dEclTzDx40bOJPVIQY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E93B600B0;
	Thu, 18 Dec 2025 08:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A109C4CEFB;
	Thu, 18 Dec 2025 08:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766048079;
	bh=+qNn/OJjWWHP/A0urQ0xX32Xkqv6pMC2TNNdJPZPvyY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XrTsMpU7hllhZ04KswkkiRAm06vv33hh3vVu7hHjiwrS6MOBlg5cz44P6Pt7JF1Rv
	 ENfgZDfCn2LVf8z4m/hXaPOPAxxpH9QeSPYYBamwWnfUS6TItgeZ3Qey94JFbHWD0w
	 3FQFSegoDFA1lk8DCx2p8yUzI0WPcrCJCtg4GDWYN3nI010FN1zcqn3fQsIHrrOajB
	 Of5neRDjWPRC4CJZVAg6a3e8CvluVYtqhIZH+y9X+FeRS1u18WkfmAj4Jxk3TNB3do
	 c0uUqV5D0aLM5EdD4kc7se6IW6vgbjYzC3YgGmv0cxWACYKMCPXrg8dbAoiEVTxR/X
	 oITCvGrbiH6ag==
Message-ID: <b5c3c6ba-ae4a-488b-be37-bbb612bb414e@kernel.org>
Date: Thu, 18 Dec 2025 09:54:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory_hotplug: Cache auto_movable stats to optimize
 online check
To: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Cc: akpm@linux-foundation.org, david.hunter.linux@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, osalvador@suse.de,
 skhan@linuxfoundation.org
References: <20251207231056.71294-1-swarajgaikwad1925@gmail.com>
 <20251218064159.7230-1-swarajgaikwad1925@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251218064159.7230-1-swarajgaikwad1925@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DF1454000B
X-Rspamd-Server: rspam04
X-Stat-Signature: d5t6w89pe7w9q9q7yrnfxqhuy3kc7kmo
X-HE-Tag: 1766048080-696889
X-HE-Meta: U2FsdGVkX19d91N2ISecgfHQGDo9/YhvoPxwG48nltvr6J5zQTzm1lKzKtyFfjN07z+17yMYKRDqrig9l8J1OhP/syFSa047qMl0DqMSlEvy4kUi7JkQ7GXMTj6DDOK4Xv6vvl7aPRsqE1mLk2CRcgtjWdyuvhPJpfwjhVkLZrgmqw3fJ2ru5UB/AkmvUki8VYlTbdEI9TIEqU8sZDcQYdxd/gHIB72wppRxot4FtwOoE7GWunzxnkdrufguaI9BruD5A0uu17yFgBeTrjjJzrohGiSp5W9QsbLZQYltmgez8fZzVbO5tBQUARUW7qtIji2f3UbjenHba6D+GkTwFYfM4JDy0BTMxyrhmdSVzPMQfHGoZazlQSGJqfKTOVKaJ9j0Urjfu1MPsMEqS2W5YYB+Ix12dJFauM6wZoTRzbKBWiqUpqQ95wqGbxCTN9b+XUecNTeJLbkkhKn5i/izeQYt9a+5/iusBF2jnl1KU1bQqVXXGEMTB+WDZbDSTm/HGZex07HOcF3dOPLVV9w68jRvaJ56C6Q9RTPtIYColYEIN8SfIUwzws1vGoEMV2teMYpbuxe7Nryy2l7scMSP6dkQGRN0nzRodtq7n2emuAvKw89dVgthsMuNJlJZpIe6EOSZ9bRGPpNUnXP3Rpsb7hXuTL9JDvmHKKkrlyn/DZowQo38IbfHkolV52XuW5AQ5qJWTNCc71hRb0F9Z7wx9+RgOP6F8xX+74TNqLgWoz8QBe+UsorXC/KyeB4+wkN5SbkTBaf2Tx4+5vNMwIdPrVvEA7zYNk8rSbO5twQMNUQupgiJvGwhMGy0o+PkfF9z73kuQBfKpdaxd0hX0Li2l9Yywo+ioYB2n97JnecxIzonYw2M2BIA7wyk/uVtFrsVJGIQT9B5gpqM915NnJ9C8ygxlnPzSjEcWi14mXsywDM7A/jInbOQ1akbK6RHcyscy2Ej0gmVviw1ynQMpR4
 ZO0VNLDy
 LG6AN1bQA+VitxoYWRJfv4lkfqSaXodB+3ZO9xKCCTca93tkQ/9/iXCTemDw/zmRXU8Eh7VqpkhqO3V2tYr++hoRf1cIdQtSMETwzeag5P1+YrVtB1O4k6rQPcbiTQIeykx1uxBdN+P00PtOHzKSyIHkjKLYHv641r0u2BQrLl/BUcf0h1I+Z/DPoJPKj0MwZm92a+sppBgfnfifujSwMFwEQefmIq9G5FLAkBjunDJJiDkIbX6Ehkye9jYbbtX5nfY4K5iWGBzXVyodhWYqkh+Uih2m0AL5tsTfc9U9iOPXCKcdPotyTOL1sE71BCe6SpENxsTKEou6YcLnMM3bQcWB1Uu0Feg5+FCZ29t8z4CjbWqvWgfMW48ZEG5FwjCZ2umq2jUDLy/Df108=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/18/25 07:41, Swaraj Gaikwad wrote:
> Hi David,

Hi!

> 
> I’m just checking in on this patch to see if you’ve had a chance to review
> the benchmark results I shared last week. 

Not really, still traveling and this is veeeery low priority :)

> To recap, the caching reduced the
> execution time for the NUMA_NO_NODE case from ~2402 ns to ~453 ns in my test
> environment.

Yeah, but these micro-benchmarks don't really matter ... at all. What 
would be interesting is what happens when you hotplug a lot of memory to 
a system with a lot of nodes. I suspect it won't really be a problem.

> 
> Please let me know if the performance gain justifies the change in your view,or
> if you would prefer I send a v2 that simply updates the TODO comment as you suggested.

I'd prefer if things that are not a real problem would not consume my 
bandwidth while traveling ;)

Anyhow, there was a kernel bot complaint that you are using "struct 
auto_movable_stats" before the compiler knows about it (and its size).

When you resend, make sure to better describe the "why" we are doing it. 
It cleans up the code a little, so that could be used as an argument.

-- 
Cheers

David

