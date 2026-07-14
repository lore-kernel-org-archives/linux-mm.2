Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C11F6C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 02:10:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2C056B0099; Mon, 13 Jul 2026 22:10:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A03596B009B; Mon, 13 Jul 2026 22:10:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 944256B00A1; Mon, 13 Jul 2026 22:10:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B1456B0099
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 22:10:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DA1CA40278
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:09:59 +0000 (UTC)
X-FDA: 84985751718.03.22E841A
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2B3B3180003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:09:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pOTIrFDv;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783994998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oe29OFRdQWxJG3Qa1xsqDVWRullOweBuH8zwQOt47ZU=;
	b=02g+asZSfPu9wyvsDAAk2alV+T7mxPlZWD3FROG7dMj/5f+oscBAfQ+80ORUZhZD34a1m2
	FVARMRQDDkczHVWm/7SOofq1ajn3IMX4K82RTrYhY20tjH0WBwRyHfnIjsSbkXShoYaw0B
	FXfDASkc1/bFkunz5ecm/UomO+U3lF0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pOTIrFDv;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783994998;
	b=tDnkJ+oeRPpwW9XySWBjFvEIpzARtAW95ZHc/e7sGj9rqC06R8ukI/Ggb9eiVxzBOqtGyq
	KIVsw9RyVa/o2twvOOR15Ppb32kvN0rQxSsD8VwpnAZAJYRmHU9J/+mpaGtE4ibfX65JS5
	pxNk9BTj7Q+tlGXw2ieM28LeP5xNTOg=
Message-ID: <d39f8258-66d5-4ce3-8080-69dc4e2ab197@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783994996;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oe29OFRdQWxJG3Qa1xsqDVWRullOweBuH8zwQOt47ZU=;
	b=pOTIrFDv42shfz0GqiuCI0/zTy5N++vrqD4K3ff7oohYi86VnOG9XBajIscXw1p+JVsfbO
	0X1+teKSyDwqVoKUvlT4KGfdQHHrzM7cMtJy5FntL1v+23Hjb491lk9x1zAlbb6iHwMMl5
	mAiHSfrz4kFTtflqlSt/VVu2EBvFe+g=
Date: Tue, 14 Jul 2026 10:09:26 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] fs/super: skip non-memcg-aware nr_cached_objects in memcg
 slab shrink
To: Usama Arif <usama.arif@linux.dev>, brauner@kernel.org, jack@suse.cz,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org
Cc: hughd@google.com, boris@bur.io, clm@fb.com, dsterba@suse.com,
 linux-btrfs@vger.kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
 shakeel.butt@linux.dev, hannes@cmpxchg.org, riel@surriel.com,
 kernel-team@meta.com
References: <20260609123047.1948242-1-usama.arif@linux.dev>
 <4752c658-7b61-4636-ab5b-bd172e11a42c@linux.dev>
 <a0c0a578-9334-4540-b469-4c368d07953e@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <a0c0a578-9334-4540-b469-4c368d07953e@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2B3B3180003
X-Stat-Signature: bhs7wnkpbn6wqisjogupxmgega4yzswk
X-HE-Tag: 1783994998-763946
X-HE-Meta: U2FsdGVkX1/ueHzu/7Xv83e6fBP2GxEsy9SQCy0fMNOjZlE/uvYsx7eRchPOpvSdmyu5RdcW6O3s9yJ4oCAfd5/aOiY2gGGWO+n2rHN7KL4fgkQQto5euN4x2nrGyfmiSoCZleT53PIrREZJgA8Pqsn3MOs8r9K+XMvoJxPqBe/B0PIbPUBPi/CllGfrIHIFsnisuW4YqI/lE0oaibgZFjsANm818JtriQyavpzB4IZYPlz/rNR6FoT28tplckFT3xw0f5QHeqec75HQYDp0M1+vtCW9NIv6V8+N7PfUxuR+5zlkISKTiOS9HbCJk6Zk2GbMm9Jiz6kn0/hnDUWBYRghqMeKk4fyV6ya1BPn40cN99fvL3nIBkHDrv/KXIXXN2WVz4cZ7XxGJMhq1l0tUy2A2Ldm2oteM2RCQPpNxbdJityudU/XH5k56k7yk9dTIGxT5GiisdPZkF6oBmKDCUPerx1Thdrjw9LOH9MH+HV+BVJZWXcmBgdzy0ljhNrXbfyRzvUs7ZQQq3dCkM3Ku/pBsehkfpOHkTGZObfLMH/Z/Vm81AdUgEIfu+eGLFlrra8JM5xPs4iWhdlqhmY+cppNzi9p9dnuItccWDzUSe5tmhyx3ZBxDNKy2sglgaGz9stBRGBr06WKGOnLs7serKY03EUB4957B9/6ZmhEgP6SNzGj63Zfec48/uBdiGw/oYFMkiLP6hT7c5qDny6V5cP333FigHRXWJkUyk4X399S/xPcy9lgTiCk2Kw6djisqCILqSlBqPZyshTC8KUiPEX8buoePlvaiOiMkE4bEQO5M10NOxNf9ELxTkdPdekDOhzRw6Em3lOZ3QmEdR4enI6CSYeB/MZzoQcAoqAURFQmhpPOtaxIIZvVNLX6iRyLnyhqf5pozEeujn3w4tvijVB7/60HXWKe/rpMoVVA0yFeqLQq6dFieOdinpOjGARSjs2eZ1ofmIEuFTroU+8
 u2eH+nkC
 MbRxn+YZJGwV/mNd5bNdhHfdtyspe/W9Efpw7v+7Nr0eEFCvil1qdwqOpX7x9Mpd0fLXlZYx39kUPeqAxfRRsncYfIseBxN0g55frwXREJADIFHB+0jLRIWXGChPt2YTRTYJTkCGFbXS9xHE3cVMXMHRTuRKfRuV9DYSRi4HKmraTEcP27gZ3Rj6ZMKgDIFlkX9UyrLr95/RRv0jkiidAWwdJ8cpGaovhU/ayk8wQ+wAa7BI/nF/iLo/9We5OpS/dXqDu0XB/n6B5F3H0redI5corCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Usama,

On 7/13/26 11:34 PM, Usama Arif wrote:
> 
> 
> On 13/07/2026 14:12, Qi Zheng wrote:
>> Hi Usama,
>>
>> On 6/9/26 8:30 PM, Usama Arif wrote:
>>> The super_block shrinker is registered with SHRINKER_MEMCG_AWARE because its
>>> dentry and inode LRUs are memcg-aware (via list_lru). But the optional
>>> ->nr_cached_objects() hooks that the shrinker also drives are not memcg-aware:
>>> btrfs extent maps and xfs inode reclaim operate on filesystem-global
>>> state, and shmem's unused-huge shrinker walks a per-superblock shrinklist.
>>> None of them filter by sc->memcg.
>>
>> This makes sense for now, but how should we handle this if these
>> shrinkers are made memcg-aware in the future?
>>
>> I've recently been working on making the shmem huge shrinker
>> memcg-aware, but noticed my changes broke after rebasing onto the latest
>> tree, which led me to this patch.
>>
>> As for the shmem huge shrinker, I can work around this limitation by
>> making it a separate shrinker. But this feels more like an overall
>> design decision, effectively meaning that all nr_cached_objects are
>> precluded from being memcg-aware.
>>
>> Thanks,
>> Qi
>>
> 
> 
> Hi Qi,
> 
> Thanks for raising this. I think the alternative is what I mentioned in
> https://lore.kernel.org/all/cfdb8620-ea55-4226-98bf-d006820e6270@linux.dev/
> move this down to the fs own callbacks instead of here. Would that
> be better?

Yes, I think this is a better approach.

Later on, shrinkers that are converted to be memcg-aware can lift this 
restriction themselves.

Thanks,
Qi

> 
> Thanks,
> Usama


