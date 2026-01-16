Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27409D4A5F6
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 03:28:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B6F46B0005; Thu, 15 Jan 2026 22:28:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75CFA6B0088; Thu, 15 Jan 2026 22:28:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63EFE6B0089; Thu, 15 Jan 2026 22:28:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 532FD6B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 22:28:21 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B44B214051F
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 03:28:20 +0000 (UTC)
X-FDA: 84336393960.04.56CF7E7
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id E94381C0007
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 03:28:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kawZwRZ0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768534099; a=rsa-sha256;
	cv=none;
	b=BTJntTJXW9p8uiuJib4L874UsWI+len6i34VZ6Ojo2/nQ9jF09DBQgQrCd2sWWtXX6U2+B
	/9t64LDu4x/X/+QlWmzZnJvcUticvxcRRhjYu4nGAna6cOsIsEkDzgSrANmyLoFnVhbZ3L
	9Gft0gACZ344JATqnx0XxhEOJ38iCHk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kawZwRZ0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768534099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5DzqnhNxvLI0laCKLwCbDwSiE4A2VzYWibr9B0HZ9UY=;
	b=dbl2Po+xEnwYkdfJBPgR70G5LWE7wmkGcDDSJeqUjuTDf/XszcIVyDMor1bnwTGfRuiKfa
	pUrP/QFgsltXjz+ZdnPR0TpInVpBbVHBjknq8oV2GHPGzi1K0LLOUgZiCVa2+Qvkr7o6K8
	N1DQM1iR9W1e3QB7ZCb7vWfks73VQtA=
Message-ID: <19a35b15-b7ce-40fc-8f6e-ed84cff84a17@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768534096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5DzqnhNxvLI0laCKLwCbDwSiE4A2VzYWibr9B0HZ9UY=;
	b=kawZwRZ0yr6J0LNYij00kshaTdb5nuUx2T60E4pjQvKILtWpaKJycNZR71fhyREdb2Xrnw
	+gzfIZeJs9TXKrTUoxf5Y9o6O7rQD1+i0WNl7mXlwmpPfVKn1+64txNPh4r6WZLMfOUWQy
	29o/khTKalijqtl9LKWABLc9TQ6Oa9U=
Date: Fri, 16 Jan 2026 11:27:46 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 28/30 fix 1/2] mm: memcontrol: fix
 lruvec_stats->state_local reparenting
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <b11a0bde9fe18673a61a79398f226ad7cb04a894.1768389889.git.zhengqi.arch@bytedance.com>
 <e5afd1b5ae95d70f82433b9b4e13201342d16707.1768473427.git.zhengqi.arch@bytedance.com>
 <20260115094704.17d35583bbcff28677b5bc12@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260115094704.17d35583bbcff28677b5bc12@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: edyzc7k93otzo9kej8rgutmz84gh6bqi
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E94381C0007
X-HE-Tag: 1768534098-889577
X-HE-Meta: U2FsdGVkX18nuDBB/u/N2SblUc/Bl0hFXlZb2p6BDaLEviHmB9WWFsf8piDsYHRLVgaE9GpcNAwzM/AhkPSfKPNLPrZsak6V30DVtrgY9AXT8gxzS3GvIHlpDy9/f2TlBnp02Ue/pejYxtSuDlTCq/3DsWTwt0Xow+WoZefWx1MIIrB/hbgA9AMuP8ig1L/XCMcb1dlbIFa1mo9ASf1ppRy3q/b3Dt76hLpcwoTb0sLDNlhCfSRHpqdtrlLlPdq4dpYaOA3q4Fr45BQoHDK6CINg9NN6bEmB7pki7KYf4UsFKk/kpJOXUgnrcbLCGVUYwxY/NbUvXiZrnTi/UXHWxWtOMl11dDgucZ7M9SqULw7IM40Dd/qUWIUaJ/NWGxWu47IpL/+B+cfI9GRwkZa+c46kzuNwYHEa33GGFIAv2M596BGwarRhzsLltjcwfsosZ+Jtuix0QqpRkkJDiEeCgRQyvjJQE3Q8wS/FDOxSnamgHGu2GZ5/uRrAMZU/rAeGC8DAgf8hb+Kiq7MP1WAVb2nGw6420BjXrJeiN5Yc5JnhHfLgTj+7RyxVq5X4l2cQYzw1mrior8YWxMeZHPOfR2lvEoZ4jP0ClFtPyZ4Tk8x3b6HxUQpejQ4qkALvFF8veQC1Tm0+hGk+fuqyZtXaQxzDQgOKsVUOqDZCSxpD2n2uDtKn/kzaB+kEid357nrPlTr6lDXV3COiRpDZsaeNESQ/x7oWFBnehmn8EXhDE02sYR4tmbMjDRmwmto6Pcw3uXbcRnzHiR8GPUwmhwurrsUwXeymX4enxTY05esd61d8l/PpcBY7Msaf8m+J6vXgYerXzd6DKYCr9u6FcJkAiffq8mp/SZo9HS3majiGg+lHRfLuTpOPCnT3+oFj4nFCpnkgVO8DT9aUVYKc765qXQwERdKx431oblxdHWRyElCvSasYOZ7DSqaMSVa+HlkojLc6HcQ8TFvapNMgPw0
 TXdI5gpF
 l8XWqHPEm7WdLCankcG0vsnFVwaLZYhC4VKN1eA4znLUU6f2DpUVSNAeli52gt3kv0ZscWix54QtYsWze6sDncyLDSqh/WyEG2dZUFAOU3HiXccYdM5ySoSxobcA4QMcEUjeNsNVGalLbg4h11fylg3dFvIOnB7iGX/GvN7NzWDFwegHQgdggLxcX+fTaKK665feJuho3uEjbnn7AVM29sXOHLcGB0GduCEBwoIVEJpB9aAF3gDvl0vAQZIFi3cFv4WB1vY6QYybJaCPZPOulDWN/HX40dmNHMzo7liXC1ndLfktDKWcE2QkjkGfsIqlsTOUbek5ChqAzazc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/16/26 1:47 AM, Andrew Morton wrote:
> On Thu, 15 Jan 2026 18:41:38 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
> 
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> What was "fixed"?

[1/2] fixed the issue reported by 
https://lore.kernel.org/all/6967cd38.050a0220.58bed.0001.GAE@google.com/.

Previuosly, state_local was protected by ss_rstat_lock. Since
[PATCH v3 28/30] added a concurrent path, [2/2] changed state_local
to the atomic_long_t type for protection.

> 
> I queued this and [2/2] as squashable fixes against "mm: memcontrol:
> prepare for reparenting state_local".

Thanks!

> 


