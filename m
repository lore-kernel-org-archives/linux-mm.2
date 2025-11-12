Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB216CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 00:56:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0419D8E0008; Tue, 11 Nov 2025 19:56:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 019268E0002; Tue, 11 Nov 2025 19:56:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E99168E0008; Tue, 11 Nov 2025 19:56:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D732C8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:56:43 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 73A86C0243
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 00:56:43 +0000 (UTC)
X-FDA: 84100139886.11.949DA85
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf01.hostedemail.com (Postfix) with ESMTP id 71F0840007
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 00:56:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762909001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E03qUQIZf1AxeG3W8Qn7HTvOUzcFZrTA9qDMhntCvY8=;
	b=zxxwcft4o9bMZAypwK+MNQm2haoz4OxkNdeq941pFqW5wK4CRWbuzaggknzQcbfRszIu6t
	TM2jdbmosmf2VGaXTsVFGXLcLXwIvaNpe4obj7bu6VgrJz7dE2bL2wkDC8wTd9vVFs7AZS
	Y/yTIL+tchyZGw/nsxDrMONAwEXS06M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762909001; a=rsa-sha256;
	cv=none;
	b=axsUc2M+mPQy4QAv6VF5HLjgAH8ntNi1brKORQAbldwlaZNmQP18/OWSDEaV+km1Fnr/VZ
	tWG2Mwo6A4b1mfN86bTbPh5w+4uuPJSkto4QT6Rx0+nzp4lEhGkpiZCZAk0AQP/mrYul2p
	dhpSaNzvDRURsNMGXxyLPEGsW4Ot1QY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4d5lMd40dszKHMMf
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 08:56:13 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 637521A1124
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 08:56:30 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP2 (Coremail) with SMTP id Syh0CgBnw3k92xNp7pW8AQ--.37935S2;
	Wed, 12 Nov 2025 08:56:30 +0800 (CST)
Message-ID: <2f43bdf7-5ce0-4835-9e60-39d91f637152@huaweicloud.com>
Date: Wed, 12 Nov 2025 08:56:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v3] mm/memcontrol: Add memory.stat_refresh for
 on-demand stats flushing
To: Leon Huang Fu <leon.huangfu@shopee.com>
Cc: akpm@linux-foundation.org, cgroups@vger.kernel.org, corbet@lwn.net,
 hannes@cmpxchg.org, jack@suse.cz, joel.granados@kernel.org,
 kyle.meyer@hpe.com, lance.yang@linux.dev, laoar.shao@gmail.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mclapinski@google.com, mhocko@kernel.org, mkoutny@suse.com,
 muchun.song@linux.dev, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 tj@kernel.org
References: <7d46ef17-684b-4603-be7a-a9428149da05@huaweicloud.com>
 <20251111064415.75290-1-leon.huangfu@shopee.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20251111064415.75290-1-leon.huangfu@shopee.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBnw3k92xNp7pW8AQ--.37935S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Cr45Wr4UJrW8Xr1fZr4DCFg_yoW8tr1rpF
	W3Jas0vF48tF97Crs2qwn7XryUtwn7WryUWr98Crn5G3ZxKr1akF45KFWYkF9xKr4fCr1j
	vw4jga4Iva45ZF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	bAw3UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Stat-Signature: jrgcxxxhnduixghb9phdb394dm6d8nyc
X-Rspam-User: 
X-Rspamd-Queue-Id: 71F0840007
X-Rspamd-Server: rspam10
X-HE-Tag: 1762908995-103510
X-HE-Meta: U2FsdGVkX19up/gTbcFn9ySqTM+gEFxAJdnkn1hyrssvZL7Hp7wXMg7n4VM+b7tIdXonvSa3qMrfoWaWkib2i2VbGYUiF27G8PfohCdFulw+pS8ODtt+0VOIkmvJ5NY62bjDAfzwPtrZ1cq87iBDs6WumtD2+UnVFQ1B7B5nhTVwvoW0pXXjKSTZAAjYjggCWiL+vrdOoeYFFNhxlQhwzOnkWB8ocGnFMlR7vpdxOyv0NCefiHDV/KxHLuQB57Ky3h7lfFsfccbpprotR9Cxy518O4brxeP4ZJk5pQVqYuxluqRTU+LKuh28DDfFmW0oA9jpwxbo2LwRwm6tsh09owfLl1Kj2zicCYI+z7r9vpDPAmkqLRimKeVR/r9D2Cc22qKHr8kF2/2m/3kUqBuE76PIft0yqJiALkWclsgm329QhLd7boTAkzHnuwY8MblwGpMsQRnoVVfaptEALjXaXye8qiqBGbi1zo6lIBbMHw+z7B05SYEeUXSUWjLdjU8Pr9maDuzcQc638PScU1vgMmLWAy7AgPjiUIOkZxnfCE0/q2KJhLdWt2RwDt6vgRxSV68cBspMpQ9xjruOMAv/rOsUrjzxFEKY+2Hi6KOfYUVG85NdSXXeaBUtJnw/543iUHYU4jWFmTOJyz4h6wP1zYPvsSHPcRjKkCKdXwyhwb1DdsAuudVUxK3U77Xxh8D3BGIfAsaSSOewA2mpt1gHQIdewVlCrwMbz/c0ZBxr6uUFdJtxn8ummot5vm6Cq6kufFDLt4InVO9ryIAuH99gXC+IO1+MXqhnX49x1/swPB8auxCpJsWC4pJPw9WqW7fRaUDsrsZyZa4u7oj6LZ6f3+jm3e7gia5p0xvNy5pFskDi23cw/MTgDSEELcM4nrH5fVcrvaZBk7/XL48AHIlUL7qA7T2XrsU6usgM5JIKO2v95a2URq5t79S0+e+/778L
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/11 14:44, Leon Huang Fu wrote:
> On Tue, Nov 11, 2025 at 9:00 AM Chen Ridong <chenridong@huaweicloud.com> wrote:
>>
>>
>>
>> On 2025/11/10 21:50, Michal Koutný wrote:
>>> Hello Leon.
> 
> Hi Ridong,
> 
>>>
>>> On Mon, Nov 10, 2025 at 06:19:48PM +0800, Leon Huang Fu <leon.huangfu@shopee.com> wrote:
>>>> Memory cgroup statistics are updated asynchronously with periodic
>>>> flushing to reduce overhead. The current implementation uses a flush
>>>> threshold calculated as MEMCG_CHARGE_BATCH * num_online_cpus() for
>>>> determining when to aggregate per-CPU memory cgroup statistics. On
>>>> systems with high core counts, this threshold can become very large
>>>> (e.g., 64 * 256 = 16,384 on a 256-core system), leading to stale
>>>> statistics when userspace reads memory.stat files.
>>>>
>>
>> We have encountered this problem multiple times when running LTP tests. It can easily occur when
>> using a 64K page size.
>>
>> error:
>>         memcg_stat_rss 10 TFAIL: rss is 0, 266240 expected
>>
> 
> Have you encountered this problem in real world?
> 
Do you mean whether we’ve encountered this issue in our product? We haven’t so far.

However, this fails the LTP test quite easily. The error logs come directly from LTP. The issue
occurs because the threshold isn’t reached, resulting in an RSS value of 0. We tried increasing the
memory allocated by the LTP case, but that wasn’t the right solution.

>>>> This is particularly problematic for monitoring and management tools
>>>> that rely on reasonably fresh statistics, as they may observe data
>>>> that is thousands of updates out of date.
>>>>
>>>> Introduce a new write-only file, memory.stat_refresh, that allows
>>>> userspace to explicitly trigger an immediate flush of memory statistics.
>>>
> [...]
>>>
>>> Next, v1 and v2 haven't been consistent since introduction of v2 (unlike
>>> some other controllers that share code or even cftypes between v1 and
>>> v2). So I'd avoid introducing a new file to V1 API.
>>>
>>
>> We encountered this problem in v1, I think this is a common problem should be fixed.
> 
> Thanks for pointing that out.
> 
> Thanks,
> Leon
> 
> [...]

-- 
Best regards,
Ridong


