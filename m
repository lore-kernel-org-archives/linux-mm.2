Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCDDECA0ED1
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 00:47:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EE6D8E00A7; Mon, 11 Aug 2025 20:47:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C66A8E0045; Mon, 11 Aug 2025 20:47:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0036E8E00A7; Mon, 11 Aug 2025 20:47:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E3B558E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 20:47:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 832C9562A6
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 00:47:49 +0000 (UTC)
X-FDA: 83766267858.16.4C2EC2A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id D6753100006
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 00:47:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uRIxrjnA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754959667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BDCTmWqkQjWZEj20LtieZUDpWVtK8WiKRsnpVGkHzFQ=;
	b=2OFRb7a8gU5daty5F1OkQ4VHCcHTQzMkGU6sDJPlfYWUQWRgVFMR/zAHCr/NTL9YUeerpD
	HwEpRS+CbuNTfnxNNaZUuxS+oGcom5TrASh3ynWyEfrGpOqfo+MKPGbstOTLCtxB0dR/oM
	vkDMGdL+s13ApwA82scEygRtW4B5QqI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754959667; a=rsa-sha256;
	cv=none;
	b=QF1ttoZ8gh77ZH64kmjgVOiusSaStR2T7YcVHv3QdLpb2Zqfsc9j3VDJLRUHYW8wIOOyyj
	Cxkyz1IPqaceuAWxHQi9tbuglvkEJD1hO8hQGyAhfrxtCz4oDyCnWfsiAsuPG7vDcm7KT2
	wLTcRP1rWX/eEAiXwW2G2IODY3U3VvA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uRIxrjnA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 00C0161160;
	Tue, 12 Aug 2025 00:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91C5C4CEED;
	Tue, 12 Aug 2025 00:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754959666;
	bh=MiSIs1rnDHHU/+k/Z0JgED1xlZ7cCjxh1VZ0AZ2BDT8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uRIxrjnA3BXLDmoa/+xkrvzFkUSvGstXPnHQMBeyCTbbsPm2yOho/HshYUtjiT3nh
	 Rp7qhKMW/N4SboRZxJQy8pMaZJihOn+k8pl0p8hoiBVTRYL/fFzcU1DE1lR0R78FxE
	 8d7FNucqi/vstujZJP2tHn182Wf51rcykaLMck3vrB4kawhydoj/AVOcIIgooT6C3O
	 80mAEoNAW2Lp0j2ka+qYHnITX0w217G6MAlKyUthaqkkNOdD7F32YjK5GyJl5l8hlW
	 fcaBRyBfPRlulaFal+WGHFr1iRueER3xzFnbu4rLx+3Xmx/o7BgPaDjb6XdZ8Dbqcb
	 bllYFPQvP4vkg==
Message-ID: <33b6c9a3-3165-4ce8-9667-afdbaff2c3ae@kernel.org>
Date: Tue, 12 Aug 2025 09:45:02 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION][BISECTED] Unexpected OOM instead of reclaiming
 inactive file pages
To: Oleksandr Natalenko <oleksandr@natalenko.name>,
 David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, John Garry <john.g.garry@oracle.com>,
 Christoph Hellwig <hch@lst.de>,
 "Martin K. Petersen" <martin.petersen@oracle.com>, linux-mm@kvack.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Qi Zheng
 <zhengqi.arch@bytedance.com>, Michal Hocko <mhocko@kernel.org>,
 David Hildenbrand <david@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
References: <5905724.LvFx2qVVIh@natalenko.name>
 <199fb020-19ee-89d1-6373-7cc7f5babab8@google.com>
 <15056829.uLZWGnKmhe@natalenko.name>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <15056829.uLZWGnKmhe@natalenko.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o7csx6u7wizsj8jpx8uunzofpjcgysq9
X-Rspamd-Queue-Id: D6753100006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754959667-564585
X-HE-Meta: U2FsdGVkX1/lCpAx7l1p/YfdO0/xgwzGh+u5xxls8YNpwDA58GJe+1kEXGVH2TzzFRVskENgh7gM5oj95sbq9zAb/qnqj/WHaCrOHwxh5nTeMpd7LqoszSbf+C2kHQKjONdO6k9yEknWlFAMbzOcNqv3UoLFWqVlpynvY43KCJiGnv03atFEzRTyl9xYX8LQgEkrblOjdm+xMYSlP4raK2xFkxAtQQC6c9KQec9nsVb+A5SIbzb0ubaPtehkSQGzKJHU12SRPQ/H20NT1zj95tmBgCb4W5xA04Go1ZMmXs+a2dFadoDWxw5a3uizKc/cBntihnMpOe6Q2ua3cDQ2OvVGB9ZySL2XBx2eYQpZXA64N59vVtgYo6emO1RVNruE4iRTGmS0kcf1wWW3siAVgj4E17YRYX8stRDqLUGmrUXryTwBuxOOwKYMG8/Y8lt55vnfij7eXvU0eVnHY1YAwfNIUbE3J4SHhoMf60jlfU3CdbqDr6omOHket9DWMSod6uo6wqum6CH3DeSWQSLZTdTtxIHm59pIWAcW7LMiz5NPK63rDcaPsgPI2IWCs+3oObSxNrYyO9eZI8ZVJkFvL4kliOCpmUIk2Cmw74ltqkQ4E37eFPgB7c8eVEa+x44ajtLm4JYLMxUwiQxxxhBBpgCsGWWgUxjPKNrWPCfGYwbNaxzXII2FX//RqQoWhXpygHotJGwmiw+CwyWtBkz0X+NTNhbPU4B59XXiKP6W/dSV3Z58SOxPOYTSoFl0yAGykxPLdvSB2QlSkegUj6QU4QjcrUXPpCBhtqeVr4h1Mz8XEOKHZX3F8uKViGZ7b0fCtjwvQiPtLHUeWWfEbN3eXZF8DuzTs97y34Eu8JNnMqFESKbDlYC+XlNAB9uReoJI9SdDNM9qKGbsqhYhnCTrGjVCNt++68lwYigTaOIHeo860a+n7zf1a5CO1ALm8JPAyJtjVKv94OFJEFTfqI3
 vWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/12/25 5:42 AM, Oleksandr Natalenko wrote:
> Hello.
> 
> On pondělí 11. srpna 2025 18:06:16, středoevropský letní čas David Rientjes wrote:
>> On Mon, 11 Aug 2025, Oleksandr Natalenko wrote:
>>
>>> Hello Damien.
>>>
>>> I'm fairly confident that the following commit
>>>
>>> 459779d04ae8d block: Improve read ahead size for rotational devices
>>>
>>> caused a regression in my test bench.
>>>
>>> I'm running v6.17-rc1 in a small QEMU VM with virtio-scsi disk. It has got 1 GiB of RAM, so I can saturate it easily causing reclaiming mechanism to kick in.
>>>
>>> If MGLRU is enabled:
>>>
>>> $ echo 1000 | sudo tee /sys/kernel/mm/lru_gen/min_ttl_ms
>>>
>>> then, once page cache builds up, an OOM happens without reclaiming inactive file pages: [1]. Note that inactive_file:506952kB, I'd expect these to be reclaimed instead, like how it happens with v6.16.
>>>
>>> If MGLRU is disabled:
>>>
>>> $ echo 0 | sudo tee /sys/kernel/mm/lru_gen/min_ttl_ms
>>>
>>> then OOM doesn't occur, and things seem to work as usual.
>>>
>>> If MGLRU is enabled, and 459779d04ae8d is reverted on top of v6.17-rc1, the OOM doesn't happen either.
>>>
>>> Could you please check this?
>>>
>>
>> This looks to be an MGLRU policy decision rather than a readahead 
>> regression, correct?
>>
>> Mem-Info:
>> active_anon:388 inactive_anon:5382 isolated_anon:0
>>  active_file:9638 inactive_file:126738 isolated_file:0
>>
>> Setting min_ttl_ms to 1000 is preserving the working set and triggering 
>> the oom kill is the only alternative to free memory in that configuration.  
>> The oom kill is being triggered by kswapd for this purpose.
>>
>> So additional readahead would certainly increase that working set.  This 
>> looks working as intended.
> 
> OK, this makes sense indeed, thanks for the explanation. But is inactive_file explosion expected and justified?
> 
> Without revert:
> 
> $ echo 3 | sudo tee /proc/sys/vm/drop_caches; free -m; sudo journalctl -kb >/dev/null; free -m
> 3
>                total        used        free      shared  buff/cache   available
> Mem:             690         179         536           3          57         510
> Swap:           1379          12        1367
> /* OOM happens here */
>                total        used        free      shared  buff/cache   available
> Mem:             690         177          52           3         561         513
> Swap:           1379          17        1362 
> 
> With revert:
> 
> $ echo 3 | sudo tee /proc/sys/vm/drop_caches; free -m; sudo journalctl -kb >/dev/null; free -m
> 3
>                total        used        free      shared  buff/cache   available
> Mem:             690         214         498           4          64         476
> Swap:           1379           0        1379
> /* no OOM */
>                total        used        free      shared  buff/cache   available
> Mem:             690         209         462           4         119         481
> Swap:           1379           0        1379
> 
> The journal folder size is:
> 
> $ sudo du -hs /var/log/journal
> 575M    /var/log/journal
> 
> It looks like this readahead change causes far more data to be read than actually needed?

For your drive as seen by the VM, what is the value of
/sys/block/sdX/queue/optimal_io_size ?

I guess it is "0", as I see on my VM.
So before 459779d04ae8d, the block device read_ahead_kb was 128KB only, and
459779d04ae8d switched it to be 2 times the max_sectors_kb, so 8MB. This change
significantly improves file buffered read performance on HDDs, and HDDs only.

This means that your VM device is probably being reported as a rotational one
(/sys/block/sdX/queue/rotational is 1), which is normal if you attached an
actual HDD. If you are using a qcow2 image for that disk, then having
rotational==1 is questionable...

The other issue is the device driver for the device reporting 0 for the optimal
IO size, which normally happens only for SATA drives. I see the same with
virtio-scsi, which is also questionable given that the maximum IO size with it
is fairly limited. So virtio-scsi may need some tweaking.

The other thing to question, I think, is setting read_ahead_kb using the
optimal_io_size limit (io_opt), which can be *very large*. For most SCSI
devices, it is 16MB, so you will see a read_ahead_kb of 32 MB. But for SCSI
devices, optimal_io_size indicates a *maximum* IO size beyond which performance
may degrade. So using any value lower than this, but still reasonably large,
would be better in general I think. Note that lim->io_opt for RAID arrays
actually indicates the stripe size, so generally a lot smaller than the
component drives io_opt. And this use changes the meaning of that queue limit,
which makes things even more confusing and finding an adequate default harder.

-- 
Damien Le Moal
Western Digital Research

