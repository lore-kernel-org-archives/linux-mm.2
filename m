Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27B16C5AD5A
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 01:18:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 958386B0353; Wed, 12 Aug 2026 21:18:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92FF86B0355; Wed, 12 Aug 2026 21:18:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86CB66B0356; Wed, 12 Aug 2026 21:18:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 53D4E6B0353
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 21:18:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A9D9C140500
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:18:04 +0000 (UTC)
X-FDA: 85094484888.01.8CEBCE7
Received: from mta1.migadu.com (out-88.mta1.migadu.com [95.215.58.88])
	by imf09.hostedemail.com (Postfix) with ESMTP id 39420140003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:18:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D0VtnKEY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.88 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786583882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uGLfcut/pIlDidETqIC1Fx//WvsRgAR2gYHdHaIf9ng=;
	b=q7eAlX9b644f4Y9jGdKkIX4W45GUcvGD5EHFSfqAWYki+own+ZIVHpg1+5jvsJR8H3UZRA
	YcmW1W7OAkmIFKqpyqurtCa5S/uO4uMyvMqwaBKDkZ5NEcLO5t8Kf5HucJYRWsS0WXCwbh
	g6sZQ0WMsGQbTHwV6zE+wrUGaSGTExs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D0VtnKEY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.88 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786583882;
	b=GadeRknH/ShvdMm3j9hDiHE0qEzxFZAO1KR/Qxyp7vhU+nqCzzbBqwRcInocUs1bkltl7Y
	AGkAy0u2EazrU54N5NUzvyP+c05REW11J7IXU/qerrngyXznsy9zdJSj8RsncWWXqp1kA4
	OmsJrFitk6gSmoKEQ5SczGxx1gbAp3U=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nE/1oNd9kQaDsPO46DtCOMIjA5Lwh9TsvckbW8AW0ow=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786583880; v=1; x=1787188680;
 b=D0VtnKEY8fLKdnfPKdllHQJyVbtvO2QxM2CmpqeL41MIGdCYsahM+fb31dMsR2aeI5qb0VO9
 9CQEmsDsXT3fxn9h9c/xUUcgxjzBulATYajSOkzsX7fY72s8dGUWWpexHdSfTfVqOLiuRBOIwgh
 Er/CoYq5IwIsHRQ50OIX0KVc=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.63.123.245] (14.29.108.90)
	by smtp.migadu.com with ESMTPS id d068e9a28b48e2fd;
	Thu, 13 Aug 2026 01:18:00 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <5f0e3361-b4e8-4979-9309-2d85e6a9dd54@linux.dev>
Date: Thu, 13 Aug 2026 09:17:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm, memcg: fix memory.peak reset clobbering other
 fds' watermark
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cui.tao@linux.dev,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260807090000.1532495-1-ridong.chen@linux.dev>
 <20260807090000.1532495-3-ridong.chen@linux.dev>
 <anyj4GGPnuU-q2AP@cmpxchg.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <anyj4GGPnuU-q2AP@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ryxncefurrjtk1bw3mohkgutaro3go6p
X-Rspamd-Queue-Id: 39420140003
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786583882-37069
X-HE-Meta: U2FsdGVkX19frIW+KGR/YHRC0cYzO4CbZDx7KzPOBt62Di3692I+4I1plo+0FK3NYN2k6E/1mDXPPP2b5pOheFqyiW5vrN4SkTsKFVeouwxb1kCGebiar7khiafBfgPvv0G/Ey+2HfHPuvuxIAVEMfqbIqzJBgBoV/B7HNA7NbLHIlfdwmG0Ina8u8k4TBxX80nUWqElgR+UjzErsvwaPuTlqqRVvodbkDLAB7gMe+y9xRm903YZ4BpThzCo79KGUh9mjZb6xT2TRhZVkvYPYRzkDQcFbCEEdJBZE0Y4dIwRdl2l1f4/N65N8XNhmCkplDFi83AWA20fwjE9YgxugTdGV0ssq1o+QjpWzE0YnIkIiBwZyCO4SphYNhWTrlbvLE0Gi3S5LiMn1blZtBmstgNXuEd0+vk4r9CIjiiP32PtU9oW3pFeOiSkAJNbg1ASaZ9IUPNEMHBGefMO0pY0q+h5VxgnNdw9B8KnkPSeJ0Nr066njwRi6PBBC/ouhwG1TYbmOMlfmGfcEHtknFVZn2bsdWIvO1L27d3XIrYJ0TnYB6LrzkzwDIQK0s/dcVeLTCLtW8sbkjeDGY+o7QkH+0ZpBP/1SsdaF1VJ5Zj2SS+sTFRk+NH1Bp14P4Qm9c9khcUDMdf+PHYYLljqvqROh4BBEz3B6RPinEfmiVeZdFnyTB5ZbDxD/8HooBEht+IntADVy0h7K6avJ+rbU+tKCG43caPG6IEViZwtsetVqJGb7/ujl5bTteeSHmOxVLvkdPEii7h/tMayr5Kw8HOG5U0Da8+jBRk2qF+LpBVUbTKngf5pnjuRjDOyTOk9R1qJ0OB9Ec5zNRwzQ2aH6n2X8p875C5e6YvUB3dG9Kj6x26ZkqQb55u4JV/mucGfzTgfwuMMizxohQkQ3mBcKgsyrRTnv0cqv4ZAmRGXTLK8RMlHNH11DhDhUmnFfeA3jQ4w2ORzcAv9Htz400OwSPu
 79TmCfJ0
 v5UQgMEFO/Pd9fKfC0elLLhYhZ2bL3QuGHFUA7TRBeRWgj0J93rdSp7yTBdvWzbZF414bj6G9YX0FrR7cqrOEwflPlPwaSeIcPJb7bi2nEOEIEWDvYzxfOWZCMJLkoHuKNIzvi2xsIHn9+OUVIeutTIXlPjLthzZi7F0PJ0OT7iwOiQyPtiN051zekv4/6HKo5aNeKtbBMBJVtqNGeDFDc0vmidsh/P5614H4qomaCjYej+nVU6x7cHkzft2d+UGWOIFkyDZkX0vX8vTk5jxvVLVIKUuEMHRdtpn7+rrhLFH+qo+7LGK/qVpzpue6PaKL+Eg4S4+gwb02HGj6WfxQlnx0TB14Tp/W0EWUdELW1DAajC8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/13/2026 12:48 AM, Johannes Weiner wrote:
> On Fri, Aug 07, 2026 at 05:00:00PM +0800, Ridong wrote:
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> Writing to memory.peak resets the peak for that fd only. Each fd is a
>> watcher and reads back max(its own value, the shared local_watermark).
>>
>> peak_write() resets by lowering local_watermark to the current usage.
>> To keep the other watchers' peaks it then walks the watcher list, but it
>> stores the current usage into them instead of the old watermark. So once
>> usage has dropped from a peak, a reset on one fd wrongly drags every
>> other fd's peak down too, even fds that never reset.
>>
>> Reproduced on 7.2.0-rc5-next under QEMU, two fds A and B on one cgroup:
>> B sees the peak (410624 KB), usage drops, then A resets -- and B's peak
>> collapses to 1060 KB although B never reset. With this patch B keeps
>> reading 410624 KB.
>>
>> Fix: save the old watermark before lowering it and use that to floor the
>> other watchers, so a reset only affects the fd that issued it.
>>
>> Fixes: c6f53ed8f213 ("mm, memcg: cg2 memory{.swap,}.peak write handlers")
>> Assisted-by: Claude:claude-opus-4-8
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>>   mm/memcontrol.c | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 2da55b778ae3..28577beeb3d0 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -4746,7 +4746,7 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
>>   			  loff_t off, struct page_counter *pc,
>>   			  struct list_head *watchers)
>>   {
>> -	unsigned long usage;
>> +	unsigned long usage, peer_watermark;
>>   	struct cgroup_of_peak *peer_ctx;
>>   	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
>>   	struct cgroup_of_peak *ofp = of_peak(of);
>> @@ -4754,11 +4754,12 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
>>   	spin_lock(&memcg->peaks_lock);
>>   
>>   	usage = page_counter_read(pc);
>> +	peer_watermark = max(usage, READ_ONCE(pc->local_watermark));
>>   	WRITE_ONCE(pc->local_watermark, usage);
>>   
>>   	list_for_each_entry(peer_ctx, watchers, list)
>> -		if (usage > peer_ctx->value)
>> -			WRITE_ONCE(peer_ctx->value, usage);
>> +		if (peer_ctx != ofp && peer_watermark > peer_ctx->value)
>> +			WRITE_ONCE(peer_ctx->value, peer_watermark);
> 
> Sorry for letting your previous reply sit unanswered. You made a good
> point on the peer_watermark = max(usage, local_watermark) being
> pointless because that's how local_watermark moves to begin with.
> 
> So what you had before was indeed better. It was just me missing that
> detail. Could you please go back to your original? Feel free to
> include:
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Sure, thank you for your review.

-- 
Best regards
Ridong


