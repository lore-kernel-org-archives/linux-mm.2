Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71F64CD4F52
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 09:19:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA0826B0005; Mon, 18 May 2026 05:19:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A50DA6B0088; Mon, 18 May 2026 05:19:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967BF6B008C; Mon, 18 May 2026 05:19:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 87D606B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:19:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 27B4416154C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:19:19 +0000 (UTC)
X-FDA: 84779992038.06.2A87ABD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7A10D1A0002
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:19:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DmeFjVJj;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779095957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FjOg4wR8gsCXBEFfiM7+PUmcoA4hSAoLw/7/kb46+ow=;
	b=IWyQS7BLPGmK1RpJs5PDVfQ+vtJY3C1gDnXnIYbXxVQQzn3I+2Se0ubVJ+vyT94CMi1+y6
	AXjR7zWcLRoY8RuyAf9SzeJQiOeN2ldxp+wmk4Er+g7ishp8yuGLcfGXGbRHIuJ2yGx1Lp
	Dnng8DVWH78eO339lNuLwujN/9QjbNg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DmeFjVJj;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779095957; a=rsa-sha256;
	cv=none;
	b=IueK76kOhPl5KYI6hi1K0q8jq6ChVrWsxD75nY9nJ47k+4Bjc6YmvF9daapuWt2SVpguAx
	6F0cU3ZHy0rrUzPAcOSWATAaCiSWMu/ljiROB5JUOUcnaecEo56OA2SKxJ3xkRwu2c0kpB
	eP93KYM+s2Ye0BVZJ9HowYty3Jwax9E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C316260055;
	Mon, 18 May 2026 09:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D56C2BCB7;
	Mon, 18 May 2026 09:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779095956;
	bh=DZH+aw/YsPdELqq/ZeNgILgKIH8IjEFBwfkEm5V3O5A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DmeFjVJjtefk47ml+OBCuiYk+M/deTJHfRailg4G1HPYGg9Uk0oAgtmkt+E2rgWUV
	 UR5QxI5l/5kup/gRXBGL4QnxlcKPg/Kdc8+0e/6maJ5bMxUU9SmBOdFl7+0vuPUj0b
	 idktPUqVpacEMef/F23Q/fEQHKaSohRCJQxIAbLDn8waNljOZAapuhO4YwM+SaNlmi
	 jiZOjskkqYtmf111mu87RKXVxAot10n6CEyPLxSH/w//XQbKPDi2N/yaj5DyblCoFN
	 lPcqXqb8DPw0lswaMDD5p660b8wil/wgh1bUL/T6RkXBAu4kl/D/zvDGag/c19MVt4
	 dQsuakRl4XunA==
Message-ID: <7d54b6b1-1f22-483c-9629-0f4310ca97e3@kernel.org>
Date: Mon, 18 May 2026 11:19:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/5] ksm: add mremap selftests for ksm_rmap_walk
To: xu.xin16@zte.com.cn
Cc: ljs@kernel.org, akpm@linux-foundation.org, hughd@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, michel@lespinasse.org
References: <202605161030201132-29L7DohlwP7mqnZJRgt@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <202605161030201132-29L7DohlwP7mqnZJRgt@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7A10D1A0002
X-Rspam-User: 
X-Stat-Signature: uzfdy7thfkrzixaojbbbureh15ntrpee
X-HE-Tag: 1779095957-269706
X-HE-Meta: U2FsdGVkX1/JwHAOt4lGNZscpsSDeEfs2lbH96nv1JkYFSzTbvN2zmgFuSwQzHOTyQeUhqaGbI2sI3OCFRtZP1YYeYfftcXm9H+jrW9DmNswytaPkwj+4Olsfjbige5Lhj07WuKBq7M1RtsAuXh4HqDnPLwDM/9wbCoTcgG/rka3CcWvBADa9gJyjHnZ2czwQw148ahpqqjokETI6sX3ULdKZui4PXTe175NoLhE7kxRAAZqAwf0pA3wgkZpFYioSczkp2xsHNl5QRnd5szDN5ulkUjsIUArj6pC0eEqBuhSl/dtlxZtT3FOo0NvUolRiarH3D1QizvzAACPaTN675kulODB9Uf4JDSkbNH5a7IMvaQzad3WlftpPxSIir4sUt51PxTiw292BU+27OHX5Sn6czX4ohQdDCU/4Ilz5VDSlv95xQJOoBnrzgx8Kde921TInqees5FyPr+ZmpxsmT7ymqaVLe0GDth/w6dJmA3yX5eKeCl2sYt6dyawB+KqmCKKqS9SPiZJT0pszzmPBr8otg6mbDmCLI01SwyRHLy15W9mp5HAD3FoXR4FFcnCsf5UKeGACr2N/7YMx3pFIIY7f01RlvEL0ISk4Fo2DBbWPFue8H7aOdjUIbY/Df91Kd1EsAHhgHXhnR/lZI/ZWAGaE3kDrgKxHs0BoNXjQm2tEPnUNqG2oCeZBz+ev2CM8eW/lJXJalxDm7DDl5GwjdNqsrofjGK4SwI09OU8F3N8R16/rKPGt9sEEBm+xPQkHrK9uVYKQcmhSs/2z3VvwvJ2vP+rUzjoCEm/t0GW8twq1csR4bzc6wGDwOxudcUw/Uf0I11RS9ivbHZZniEz8o+i7SiSEKaQf6Q3uc504gfOcIURLstRej20bsqxINYhP74ehkBXlGwyRuv2GNS/tlWaoirrbyHwikwDXbACMHGrJJKFpJE6T/QrO+TX2JG4anoLSGceFPjxQ74OICa
 I96bq+yA
 ltX3HJ9rzqyyEGgWgD+fkiJdDIbUGpDfnZTlTbaRZct5jmE/L46LFnVCQpTSU52K2K+8q7O8QvhY9QhABDpuZva/mFn8urndur8+Dz862DZWARBLv8ugN/QkHkaY/PY0Pv6x4XbL3maA8XMSL/0FMpSNnRudnAq7Ef++PwACIGxDwftvqREv9wKX1z/yTjjkE+OoAl2DIRftrPTUWXFQijubILBGmmxl5AETxKmO6chbEB/ITSdeBmeNLXIBRowbHIOeGVGiqc49Xq36r8k3+KkZCSTCnZnssn+IdKrQSJUgTMC2NhAfOwaNcnPY+m6WyYkjj2B4qKd170nSU5vvenYGn+Xs4+ICyFHSRCyjDEKUtv/E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/16/26 04:30, xu.xin16@zte.com.cn wrote:
>>> --- a/tools/testing/selftests/mm/rmap.c
>>> +++ b/tools/testing/selftests/mm/rmap.c
>>> @@ -430,4 +430,83 @@ TEST_F(migrate, ksm)
>>>  	propagate_children(_metadata, data);
>>>  }
>>>
>>> +static void prepare_two_pages(struct global_data *data)
>>> +{
>>> +	/* Allocate exactly 2 pages for the test */
>>> +	data->mapsize = 2 * getpagesize();
>>> +	data->region = mmap(NULL, data->mapsize, PROT_READ | PROT_WRITE,
>>> +			    MAP_PRIVATE | MAP_ANON, -1, 0);
>>> +	if (data->region == MAP_FAILED)
>>> +		ksft_exit_fail_perror("mmap failed");
>>> +
>>> +	/* Fill both pages with identical content to encourage KSM merging */
>>> +	memset(data->region, 0x77, data->mapsize);
>>> +}
>>> +
>>> +static int mremap_merge_and_migrate(struct global_data *data)
>>> +{
>>> +	int ret, pagemap_fd;
>>> +	void *old_region = data->region;
>>> +	unsigned long page_sz = getpagesize();
>>> +
>>> +	/*
>>> +	 * Mremap the second page to the first page's location (FIXED).
>>> +	 * This effectively overwrites the first page, leaving the second page
>>> +	 * unmapped. The physical page originally at the second page is now
>>> +	 * mapped at the first page's virtual address.
>>> +	 */
>>
>>
>> But if there is only a single page, why should it get merged by KSM?
> 
> This test runs in multi-threads, So there are not only one page from this thread but
> also many other pages which are mergeable in all other threads.

At least the test did not reveal the problem in patch #3 :)

Can't we just use a single VMA (e.g., 32 pages), fill it with pages of the same
content, let it merge, then mremap half of it, and then migrate a page etc?



-- 
Cheers,

David

