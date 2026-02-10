Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8183BEA3F35
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 10:21:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 691086B0005; Tue, 10 Feb 2026 05:21:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63EC86B0088; Tue, 10 Feb 2026 05:21:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F5D06B0089; Tue, 10 Feb 2026 05:21:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3E5896B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 05:21:22 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B258BC1E50
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 10:21:21 +0000 (UTC)
X-FDA: 84428154762.28.9F3AD36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0D3D780008
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 10:21:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K2V61gcz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770718880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tdSVFD+eqyw6LmIc3hIm8jtl1lwhIpFlYq2huT/SlJk=;
	b=OJbxegVRc/2VKX2tbzCH4tBx5AjwCGtaDm+cU8LfN5LJjdKgbugTD29Mzzy0WyHDmbGk8A
	SLQGEx1870GUn8oZFZnl2oDiJJrmiGXX529HcT0SaG1uAZFm9qZ/FyA9xi0vQGJc8hwHvE
	gybPTkHiIaBwYEqaOFvd/AMfL7W46o8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770718880; a=rsa-sha256;
	cv=none;
	b=AFKahTteWLOFQGhpMvrfW5qS7JXlMP3qYGL9dvuPgkUTwH9+t6PUVQTHWEQYgbulWREwAI
	cIskO09hGFi+dxF4zGQYmT0+KBNK+Zt9tLDSzrgZfVw5wygjdJMmlAtZhEPGqL5Vu5S0Jf
	YPafHg2JuGhXEOafW73yCSPMT1FqwFg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K2V61gcz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D730B43983;
	Tue, 10 Feb 2026 10:21:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EECEC116C6;
	Tue, 10 Feb 2026 10:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770718878;
	bh=zIn+Ar08sfB/iJ55gVJ3hoXwhvcc4p91EBdxhI1ELPo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=K2V61gczJQDuv5DHlDgrJKIYav4q4jYkT82bUyUYCJe/YQMhYNyOX38XwgtX2zmxF
	 KX22K4i51w7jyVDoOBR5/IuFiM2eEDFsjqAqOl/hpOs+x/+Yu9w4KF4vua92y72q7L
	 B8Cx8Alxy1hZo700F432EVix6ckP7ATNrQzWBtRoce1kP4Q2x0Aen0PPczbq3sSucy
	 jEcVyYvz673UTThXRXjadauq5t1Z+/TnP5DFQkZUkawLPY+hopNQrQdhI3fBl+HvS6
	 NqyurpzMlRT5tKfLF2bzKqJaMGLRIM80tP4OpAkp67zVau8alMFlxsAggGfj51ckcp
	 p2LShxVRIw4/A==
Message-ID: <a2985ffb-6f00-4b0b-b29d-22b39ffc9eb0@kernel.org>
Date: Tue, 10 Feb 2026 11:21:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [stable-6.6.y] mm: khugepaged refuses to freeze
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <gp3foqukne5ukrssvx64svhcpogmrskyyzjatofstfrl3vplrk@onxbnxdjrswu>
 <3d0f189b-faab-4452-b9cc-8f4e7a15025f@linux.alibaba.com>
 <jujsgu5ed3srhetch2pbpdrt4tnf2alodrk4nfo7idxmhsq772@lirvj7ftvxgv>
 <h3bbxn4omwe2jv32vyjou34me73x5nwg6ai57goqo2qlntq73y@ra75spa3tlzr>
 <1179320d-6bab-40a4-a7ac-dbcfbab24623@linux.alibaba.com>
 <c225864f-192c-4cf0-a5fb-411de8c22eec@kernel.org>
 <70ed2de7-3e66-4a23-85bb-e0a4c5b61088@linux.alibaba.com>
 <af21afa0-2a30-478e-ac9f-6bd431af6502@kernel.org>
 <gogfqtdrd2lfoiwfetql4v2pjehof6q42oewn2tphddobzawf4@efiyrhjyzm7o>
 <a6e73466-030f-4b9d-a0b8-502916c139f8@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <a6e73466-030f-4b9d-a0b8-502916c139f8@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0D3D780008
X-Stat-Signature: kwt1mnxkwxjqx76ezn9gz6kahbikq69u
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770718879-931145
X-HE-Meta: U2FsdGVkX1/i0q6vSyD/YbODk15spgXDTs90CYXEq6UKBrnsbX/T9TyoanCYYMs+C2Uc0SaK9RH/EEZ6LdJSbQ0zA+5skUpaIocY6QilDYAqIcylfFefStWx9zLTPq3CWeHuzq18OaJG/vL5O/vBV+kjCBRPvuer7UCXS9zUjgy9JXUEOJZSJliN0apOzCV6CUJUyTT4D6puLF1jJC9Y7P5IslwUsTjltuJ9Ubu62zNlCWe9wp6clDAvng6dpk/bNVMyIKG8P9dbCae2GlxAIdgVYMncdinVlta/ktPqr08umTWl6sasTlgjFtbnP5xfXoBJ8n+KgLeNN+iwoPrv6YTk352djIyMiozJJXqcigg/aHBqKS9dnLSi2VbcxqeRNqpIZwBDqR/PKmeebaoS9/E3KKqJ7RUx3Gq9XHgSdbomTBHNRKKHYWnIKzCBtLEsKfeAM52D+/ufmgDRenC73cEMBo5TDU6uXiGFVA65M4fIrMNZwMjdaXo6Buh5cwHhytb0YMX4ps7LXZkoPhGVsiWakyP+GU18+yrrXnSn4TIE5Zi0Ly9C559LqUyNzsT0JRHfzn3FSOAh34qtj1gHaiTUkXy3Z5L5haNfFvk6ppNXmZdr+xdLyDKH+4MsiCKfgeBmoeujAj3Kzm6WR+6v+LAKmt27jW5SUpodkr7NgdFOmPhHoJd2+0GywvcygKS1jMLm4/4jOVRvkCzkFgTHCoXGsmUPw5+W4+8YHST1pANL10a2kgON43OG7jOQ4jP3lcfObxOSY0mMgPW0ptdG/x/z3AX8UdDjyMqtmzLfs5bDp/+G6t3CegS3wapcKtkGCoUKG7OCojtIlOx59YmuaI3pZGGB+MP8h6PewxddiPjxg5Uvd/WIQAY0GmrTHvW3VCrYOGOTCKZOqsihZOq9rziphuoSimJ6vWLtQnmGxo98xUdV1e3kRO9pOjCAabf8G27+9guyl0WuhFj5D7s
 eJg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/10/26 11:07, Baolin Wang wrote:
> 
> 
> On 2/10/26 11:21 AM, Sergey Senozhatsky wrote:
>> On (26/02/06 10:00), David Hildenbrand (Arm) wrote:
>>>
>>> Right, mimicking what kswapd does sound reasonable!
>>
>> I may be missing something, as I'm not seeing dev_pm_ops in vmscan code.
>> Would something like this work?
>>
>> ---
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index fa6a018b20a8..c5d89ec223d3 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -394,8 +394,12 @@ static inline int hpage_collapse_test_exit(struct 
>> mm_struct *mm)
>>   static inline int hpage_collapse_test_exit_or_disable(struct 
>> mm_struct *mm)
>>   {
>> +    bool was_frozen;
>> +    int ret = kthread_freezable_should_stop(&was_frozen);
>> +
>>       return hpage_collapse_test_exit(mm) ||
>> -        mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
>> +        mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm) ||
>> +        was_frozen || ret;
>>   }
> 
> Since the hpage_collapse_test_exit_or_disable() can be called by 
> madvise_callapse(), which is not a kernel thread. 

Which raises the question whether we should forward that context 
(khugepaged vs. madvise) to hpage_collapse_test_exit_or_disable().

-- 
Cheers,

David

