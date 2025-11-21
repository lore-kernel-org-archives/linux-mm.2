Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0599FCFC266
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 12:43:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C8A06B0098; Fri, 21 Nov 2025 07:43:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3789A6B009E; Fri, 21 Nov 2025 07:43:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2685E6B009F; Fri, 21 Nov 2025 07:43:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 117F46B0098
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:43:57 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AA47D13B471
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 12:43:56 +0000 (UTC)
X-FDA: 84134581272.20.03E0141
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5252810000E
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 12:43:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=UE6FRZgk;
	spf=pass (imf14.hostedemail.com: domain of hsiangkao@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=hsiangkao@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763729034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UXNEr7vcm3thFtEulF8bEeGgEGO9nmCn0v+aGXpJLHk=;
	b=R5DyZI2lexPqcMK+lbWY1+kJpehAHOonlcXWtHfKXOuuD0ZtCerjzyChmYucmQjcRdpXar
	CmFkpkRUtVAecw4ftN1sq6SLu7oVCkHKEQ1poArNwBo8Ip2CPlJIuU6H3KZjI/jADVIqqW
	abnQq1cEU95g6eu9BJzcgN0V84EZbCk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763729034; a=rsa-sha256;
	cv=none;
	b=7mX6DvO/DNTE5A5xTUXGV9uByilsppqml4kvDy5Ee1eRitJddojBse7VOXDxi39ceLd4v2
	TixctDNrPMN9PPg8h6idMLprlex4tYi+bLl5sB9N5XsxdhbE4Dk50Xde5yni9p9e3tPOhZ
	rG0l78y0EnEuR67kvY9gIFtwCK5CVAE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=UE6FRZgk;
	spf=pass (imf14.hostedemail.com: domain of hsiangkao@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=hsiangkao@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763729029; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=UXNEr7vcm3thFtEulF8bEeGgEGO9nmCn0v+aGXpJLHk=;
	b=UE6FRZgkiHBXbinsrDj8k26o4FnINr+H7Aogk7R3lvWG72XHnD/atRsndpq8RdAlJbxIP6Um2vJ0RgIrUCjJuXeJAtbzJJ/5a89xHbOBv2rXl+OL57MKPkCHg1Fe0LOi8AACSBtEglYTIQHnjZwQf4n+BPSomX8/7D8lEPjyzD8=
Received: from 30.170.82.147(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Wt003i5_1763729026 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 21 Nov 2025 20:43:46 +0800
Message-ID: <d7140963-3b21-4b51-9a9c-bcf8362bf1da@linux.alibaba.com>
Date: Fri, 21 Nov 2025 20:43:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCHv5 0/6] zram: introduce writeback bio batching
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>,
 Yuwen Chen <ywen.chen@foxmail.com>
Cc: akpm@linux-foundation.org, bgeffon@google.com, licayy@outlook.com,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, minchan@kernel.org, richardycc@google.com
References: <ts32xzxrpxmwf3okxo4bu2ynbgnfe6mehf5h6eibp7dp3r6jp7@4f7oz6tzqwxn>
 <tencent_865DD78A73BC3C9CAFCBAEBE222B6EA5F107@qq.com>
 <buckmtxvdfnpgo56owip3fjqbzraws2wvtomzfkywhczckoqlt@fifgyl5fjpbt>
 <8c596737-95c1-4274-9834-1fe06558b431@linux.alibaba.com>
In-Reply-To: <8c596737-95c1-4274-9834-1fe06558b431@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 5252810000E
X-Stat-Signature: 6xeg6gkcdpz65raunir59c89kcjpo5e9
X-HE-Tag: 1763729032-851425
X-HE-Meta: U2FsdGVkX1+TD0CiITFEoKfnKRkDt7h3AGtoy2W5QFYSaKQJhtlU4VNPNpKY3oGzW4dlRgJYPtCBj3210iGFN8KGmIpOjgdg1WrFS5VP44NuvgUAgnsFAf/uDXUUd1Jn/JrBOoorauGrtX0/Ni1veyj2lvO0uKqohp9XVKOluJcRu3PE8zU2MupZKndFiiH6wwDWLioux/JCdRIhBFgTzb6iVtvSX9Nh95LUtQoDiDehDTrScoFZhwFcJbVk+g4n4m4G//zT/rEnqMl7FvkNyeWztVdf+a/VH9bzJ27l+ndlu1aeF4WbasAARyyFQORR08YTxrr9ML3Vq7JXlxijHVL+Rh7fNJyhY90JoAbuQlKi+CtI9ONeAZ+Xb/ZrwZgeQlvR7r8csJjMD73AKeUOL6vZoxLYK+fhZZyeJZJ5zoVK7HMhnmwWPLdd8hvpabzzvAKkBCtpwvZ7rzhZsNf0mcXBuCrdYGzYmpmVv9Vki7a1nS1j3XlgogUVlVvRaVmuTIO8Y5iY96eD33F5LxIooqF17PUXTMkuK2pFxQZrguzi/M2o5Yj/wkkfOWqIFV4dr4A3YiZDs6E388pfLLtsJ12h3gRfSPyY1Y/Oclw9B8TBcfI1UHuTI2yjVNy7cSDoqRyEw5iZXyEjd7LHjYKM/1Msz659gxhlvBOb95EnwLFHFSdlhGuJBBsWvb9VhYvLvJx1GN72CKN3Us+Asw3sxQtS0gLGzqU/zQInBCDquUvmy+G/GCav3aRd8zcQftF2V347qh6/ro0X4iidRNhfhzEAH9uI0kuqdddDjM76vSdTUfpxkd/wUeqqXtvCrdn8hKlcNXrY/PzutVCrCOW68IGUBKjAk3AB26rNhKBABo57oe0xbastop62ayXEYmrcSNcfXW2jKjiqBuFlcsUJ0gCfxw20Y2JLRhd+ShvmNa6ZZezNYxgkEbE1GZXvb0+RoPZ9heTAfgNYChC/AVf
 SDxmWvTF
 KNkgRKUlddamLKOxms4luMS+lJ0PhHj7pNZXE8LX16JLbIesrmvvFKJn5FnXIYu62jTehubp50FAZ7ZslVTDSWdXilOk7fYQOFPaTlhYcLVKOcmkE1WKvyEnex/wr4Ks888u5KY7jjOb7RK+cMEL6p+RJ9ieqDDyjjoTe30ts2+K3AbPbChgHjErRhvjHO2xFP1RxRgcPwCprmHIavxay7GO/EAf4T2l/ZjHiW51gbboe0N07qKdc+c7R+5a5QzUScxWND1cFid4R9tansDlfxtGDWmxiSL79dAsHdOmKxmq7dJWJc9mBIbOqQjzg1iat7h5W86cz4WqF+LzuZilP2nIkIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/21 20:21, Gao Xiang wrote:
> 
> 
> On 2025/11/21 17:12, Sergey Senozhatsky wrote:
>> On (25/11/21 16:23), Yuwen Chen wrote:
> 
> ..
> 
> 
>>>> I think page-fault latency of a written-back page is expected to be
>>>> higher, that's a trade-off that we agree on.  Off the top of my head,
>>>> I don't think we can do anything about it.
>>>>
>>>> Is loop device always used as for writeback targets?
>>>
>>> On the Android platform, currently only the loop device is supported as
>>> the backend for writeback, possibly for security reasons. I noticed that
>>> EROFS has implemented a CONFIG_EROFS_FS_BACKED_BY_FILE to reduce this
>>> latency. I think ZRAM might also be able to do this.
>>
>> I see.  Do you use S/W or H/W compression?
> 
> No, I'm pretty sure it's impossible for zram to access
> file I/Os without another thread context (e.g. workqueue),
> especially for write I/Os, which is unlike erofs:
> 
> EROFS can do because EROFS is a specific filesystem, you
> could see it's a seperate fs, and it can only read (no
> write context) backing files in erofs and/or other fses,
> which is much like vfs/overlayfs read_iter() directly
> going into the backing fses without nested contexts.
> (Even if loop is used, it will create its own thread
> contexts with workqueues, which is safe.)
> 
>   In the other hand, zram/loop can act as a virtual block
> device which is rather different, which means you could
> format an ext4 filesystem and backing another ext4/btrfs,
> like this:
> 
>    zram(ext4) -> backing ext4/btrfs
> 
> It's unsafe (in addition to GFP_NOIO allocation
> restriction) since zram cannot manage those ext4/btrfs
> existing contexts:
> 
>   - Take one detailed example, if the upper zram ext4
> assigns current->journal_info = xxx, and submit_bio() to
> zram, which will confuse the backing ext4 since it should
> assume current->journal_info == NULL, so the virtual block
> devices need another thread context to isolate those two
> different uncontrolled contexts.
> 
> So I don't think it's feasible for block drivers to act
> like this, especially mixing with writing to backing fses
> operations.

In other words, a fs claims it can do file-backed-mounts
without a new context only if:

  - Its own implementation can be safely applied to any
    other kernel filesystem (e.g., it shouldn't change
    current->journal_info or do context save/restore before
    handing over, for example); and its own implementation
    can safely mount itself with file-backed mounts.

So it's filesystem-specific internals to make sure it can
work like this (for example ext4 on erofs, ext4 still uses
loop to mount). The virtual block device layer knows
nothing about what the upper filesystem did before the
execution passes through, so it's unsafe to work like this.

Thanks,
Gao Xiang

