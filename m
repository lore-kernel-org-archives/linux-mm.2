Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A00C7C531D0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 01:11:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30D786B007B; Thu, 23 Jul 2026 21:11:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 296EF6B0088; Thu, 23 Jul 2026 21:11:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 162126B008A; Thu, 23 Jul 2026 21:11:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DCE836B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 21:11:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4B8A140259
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:11:33 +0000 (UTC)
X-FDA: 85021892466.23.936143D
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2465380002
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:11:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Yakm3+hH;
	spf=pass (imf02.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784855491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sRSJBzhHabeY3v8/MCt6zskXys5KcGp37U7Whb22Mjg=;
	b=jnARp4eRChXjB5LGs5i410YmmFyHIXPbpJ3VW0zFoftiqARyyTXlEDsG1D2YLKi4BqOsiu
	yOoLj37UBNgNDrG3z1Ux6fPRRfHXEJ5E9ZUHbdJRQk17UxcI4exSUe6iXA8HWTCkmYVHnP
	3VCg+OkYZlDhaVFOhRmPM/msOxjO23I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Yakm3+hH;
	spf=pass (imf02.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784855491;
	b=mNkJPYuCSWwZlOoQCpVyanuabEG4goqpqYMmNS9EVG5bPOCbspAy6Jfr0wuVIEApsb4aaO
	sWo2LMBO+2HwEczCjrdKjq1aKVZRwYXfZT9WL7ffRoGHC62bX3rwDI6cXwD6WJS8At6voO
	oy3wdO/cSFO3JpUmmdrGg9MRsx6DpUU=
Message-ID: <5e8d124b-c96f-466d-8947-68cde3014a17@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784855488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sRSJBzhHabeY3v8/MCt6zskXys5KcGp37U7Whb22Mjg=;
	b=Yakm3+hHVWosoKkIcbUWUVD0bxF53ix1pmcMT+x6uqW2PIiszrBGMV7Xtpxg3rrlMbvLuZ
	dHiedtkB5Ia35jz7DP36wg64XbLQi5ZvAuLhCiA7tY3NkSIJRuoiZxG2M7ZU3aZ/i8NA0p
	+jApLnlffCMhcMdPjHOj+dyomlNsxu4=
Date: Fri, 24 Jul 2026 09:11:18 +0800
MIME-Version: 1.0
Subject: Re: [PATCH -v4 0/2] mm: vmscan: fix node reclaim ignoring swappiness
 parameter
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Muchun Song <muchun.song@linux.dev>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Davidlohr Bueso <dave@stgolabs.net>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Song Hu <husong@kylinos.cn>, Ridong Chen <chenridong@xiaomi.com>
References: <20260723032434.2016749-1-ridong.chen@linux.dev>
 <20260723173418.010e38f655f83850d92c2c8e@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260723173418.010e38f655f83850d92c2c8e@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 2465380002
X-Rspam-User: 
X-Stat-Signature: gj9wpo3twrr8iatpoo6uetm1r5rb13ej
X-Rspamd-Server: rspam04
X-HE-Tag: 1784855490-891671
X-HE-Meta: U2FsdGVkX1+N08gPWLYkHJzcTe/UYA0oTsEQYVNQhfRrCbgXbEfEOQUr/OM4LUQNeBZUjIgMTfEP0jpYMVTwzhYs4e1x4NmUXtiGXuWQSS/FJTqhaaKp3eZ6lUphyR6GN46X1a95twgkcQUGzdOXaa5Ol9U60AVTckCzVHcGItcotmi5lqeZwpVy2iiussRiksJ1U3zWHs7EOBYSvGKhH7P6HtBpyfkDyHlvu2aA9/2+8GGYmCTcBhKWDVOHlFV6MM/mMPMmmqymMlWt/CbXfvpHEHAfWjAbQKPUkV70w7SY3LEO0ucx9o5Wf2C+agVqL7Ug1PvYpZ52lZJewdKZu2fYAAQs+a5HjlzksxvrOtpuhrTh6o4EEKSco9/phQsy70hcyMSPFW0oAVulXc0a3Jg2hUSRkWRLoqdl91wFIQ7Y45qIK8IslxtCDNIEWqVOlwHDy+a3wN+ubfTErek8OxX1D7WR99YBAHXFLkpBW83VMf6iMu6MRnTfQIhrMZ3KNrMDBTVz40LpXD1yT0f+ED8CTH4XGdbKYTPvRFdekLPhJsRe+b1oQkeS/odxsqJRxLTEgV1uuQA74X/gKbz4E9sVE/VoxjZCePq1V8YlUIytkBcAk25ChqJ3n6YWJogx31CqgAGwAWsjEJ6Sc24GQx9geTkMVl1FJ5mRoYZgVzSFZhu0DvWStE+W7ba/RGDuhscKBIv1Yyww+T2/JbDS65hl0vqojFGLY3G4w04tCSQ+mqXBinErzDy2cDfZD78ES3svY11yVSR8+Sv8QWs2hiMxZ8prCHfD9tcJJf27eD9MmdRC+yHzRf3zQIkbfFzGSGJDCE8Pd9lOiTqdIClc4/a5Tlymp+N0GVsXsDqnCCJFwuxXcfoUMEqji87YrKSNC0J3Z6zfLrVzkTNRdRRtwGt8EN8Y802mN8NYIB2TF5qst9ZrkVphn1e5VYHDRsz5+I2dJG++E5B1Me6+heX
 90n2iaz5
 +K0NVp/SrQotw9352PVEFiBzujdkLmLXd8IaR8mbxryizp5O6UuTDIw81o7AHkxLlcYeAKjM910r3c2BKO5DVNJ9qsuSTJ5LlZSzTsfdSAMqGAh5UYkxNI5ldv1H/dFlQSmJwGB3ZP2xPIc/88MvJD8qi6N77/fXowJtq1S0eOvSIQPwtUCrdtAHNGpKJ6ga1bUnW6cXv3x5TjhmXJc4PI1ACd1lcq4tchFgolcBEKbXwivo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/24/2026 8:34 AM, Andrew Morton wrote:
> On Thu, 23 Jul 2026 11:24:32 +0800 Ridong <ridong.chen@linux.dev> wrote:
> 
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> The per-node proactive reclaim interface
>> (/sys/devices/system/node/nodeX/reclaim) accepts a swappiness parameter,
>> but it is silently ignored when CONFIG_MEMCG is disabled. The root cause
>> is that sc_swappiness() has separate implementations for CONFIG_MEMCG and
>> !CONFIG_MEMCG, and the latter never checks proactive_swappiness.
>>
>> Patch 1 moves mem_cgroup_swappiness() and vm_swappiness out of the public
>> include/linux/swap.h into the mm-private mm/swap.h, and makes the helper
>> handle both CONFIG_MEMCG and !CONFIG_MEMCG in a single inline function.
>> This is a prerequisite for unifying sc_swappiness().
>>
>> Patch 2 consolidates sc_swappiness() into a single definition that works
>> regardless of CONFIG_MEMCG, fixing the node reclaim swappiness bug.
> 
> Thanks, I updated mm.git to this version.
> 
Thanks.

-- 
Best regards
Ridong


