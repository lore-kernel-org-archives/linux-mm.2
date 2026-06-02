Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C74ECCD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:30:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 133CE6B03F6; Tue,  2 Jun 2026 06:30:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BE066B03F7; Tue,  2 Jun 2026 06:30:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF0576B03FF; Tue,  2 Jun 2026 06:30:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA0DC6B03F6
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:30:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 824621A0839
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:30:54 +0000 (UTC)
X-FDA: 84834604428.08.B063188
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id E098E120002
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:30:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u2EPKLzt;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780396252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WeWM3R8w++Ct8ALkI/TqIhD4KtusBC5CW8qyXLrBO2w=;
	b=VYK23xMdhH9TFWRindDQZOJsewuahknpkHZEfVSnQ52cEPqJ0A5FE2tLoPuBdZCwL/9L04
	nR0e7+h0szLv66c+NjDe8lNj38c90ObfFs9bwKw2C0h+lpQfAkPhvUFV+F8b9sbD8ZA9OR
	KOLcpi2TBU+BqYDyQjrYMPSZzMV9r1Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780396252;
	b=QGoxYq9IF8rNH/dNQjnw/GnjfPCZwLRw6smXJTsY09KBBpBguIBHFnF0VitQmo8fawPKxi
	frJxaE1xJaAgQOn6mA2nxlhc0Xtk2KeU2NyXO3D9VsU8MDyCV2t+BOQQ5xeq1ZHzlvRf8R
	5I0iwclJJ/j2p9dhoflnT4spH8Tfjf8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u2EPKLzt;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <23946ec7-4728-4716-af18-29e303ac19e1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780396247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WeWM3R8w++Ct8ALkI/TqIhD4KtusBC5CW8qyXLrBO2w=;
	b=u2EPKLzt0Z3v2rcql7TOgWehrPkMllyaNOXrqTqR+GqsmvE78N09MGDQ71S2qxrh65tKQ5
	cgFE/fVvfOm/o41xxsWlUb3Ikfsv5buSFpHUCblfiIMFzpJY7HjbzgdE/3IfxO+oZgLh+P
	OGzgw8wuT5p9hluWBD+HX4Lu9XjKiKs=
Date: Tue, 2 Jun 2026 11:30:36 +0100
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] mm/thp: clear deferred split shrinker bits when
 queues drain
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: david@kernel.org, ljs@kernel.org, shakeel.butt@linux.dev,
 mhocko@kernel.org, david@fromorbit.com, roman.gushchin@linux.dev,
 muchun.song@linux.dev, qi.zheng@linux.dev, yosry.ahmed@linux.dev,
 ziy@nvidia.com, liam@infradead.org, kas@kernel.org, vbabka@kernel.org,
 ryncsn@gmail.com, zaslonko@linux.ibm.com, gor@linux.ibm.com,
 wangkefeng.wang@huawei.com, baolin.wang@linux.alibaba.com,
 baohua@kernel.org, dev.jain@arm.com, npache@redhat.com,
 ryan.roberts@arm.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260602043453.67597-1-lance.yang@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260602043453.67597-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E098E120002
X-Stat-Signature: 11ecgnfo1wchkix3qjc4879geupjxjhz
X-HE-Tag: 1780396250-780569
X-HE-Meta: U2FsdGVkX19o6DGVQH+UlUCjCM4lANod6awqldBlD8n0FhbXeeGpwjAbO9Qg3Bn+avs8G/xIyUjN4c2lKo1kKE0mhi6MtI1VO275qWLYsWtKO3cu050hsJjGnrq/00t1AjnKcZ0+RXdkzx9m1vXZ8doMHL2PYsQYi8RsihuJ9Su7BY8ZHDYNpPrleiJChaLunmv1L9F50jgvbiS/08Wk+7WNg6PBP3KOJf6Hvv3yjNzHYb7tWiowPVOGIrmR4KLpeSjCvGsc/Rg4MDN8ToyMOaMPf+GfmMqSshKraY9qgAHNbfmbMrKh+VyCPgIxhSVJHHs9+8outF82XWBGKX++yfwP79YMj5mcKEqUvdFNgrRLl28/mPzFJOVvNaFyDASNCbv2P/WxN0yYRST89dgezC7cNNm1cH2ihduCJr6eMma/k4F859bHdT7KZMXQIfgSoXwR8yf0LsJxUMbnond/vlHhqlow9n4yAROywrG8NACRPRChDMtsd6RDKSYgBEBUFFB1mmC//zwtJ3iFDNptrL2mBhlfTl8qu/T2m2TrEek5oCc1zoixOMtIYkB5g+HtO4Zi9hqR7Tc9EBW/PSB6cXqhyVtCMTrrwmXxPQPgy1gvmXyZ5kvbheF5rW8uyn9CIqHG0dfm95HMJqDNNaBzJsDtO6EKLXZOkxHthJ1epXuifPZiZhBThYQY5W42Pt0q2UaX8M636xOx66wQPmkBnpqmQ8E+pBHjb6mQ7jm8IBca2WLq1J1yTClW/8NbTEBsp8ZVtajXo61DMtg364x0NQ55uT8R8NpWxUV6exXmnPM0DBOwq+kD1ai9Lzgs+tgpNNPJsNuxs6QHytHwAR49yxeU3yp0DSjX87lZHHPntFgysv344VqifymKwe1kZZ2QqtnpJU12cHue/7YmwzIrM6S759eiSyRQT383mz0HeEvMTyc2/Q3cxt3UJwf/jP0uO8r953yKqbv7Ss2BO2u
 x7ivZS/7
 29GhHTXsXlArlrXonZI1HOQZc1FpgO+CHjGudgPCRWLwXEmoazQG6ccvqj9PHd//mltGijA8ZSobon5WY8vjAgEUU6/A9IcC5ReQPGif+bLAnMYnNGRHd0nz5JHbV0opA0D7M921KOFiXYFCjnXqgZoToWzTHj+YXvstVTZXEmEBO8lgFl4ZL/qcw2C8OtfXg9Vsjcpol71wOQ9KMoZDQoXl2Zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/06/2026 05:34, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> deferred_split_count() returns the raw list_lru count. When the per-memcg,
> per-node list is empty, that count is 0.
> 
> That skips scanning, but it does not tell memcg reclaim that the shrinker
> is empty. shrink_slab_memcg() only clears the memcg shrinker bit when the
> count callback reports SHRINK_EMPTY.
> 
> Return SHRINK_EMPTY for an empty deferred split list, so the bit can be
> cleared once the queue has drained.
> 
> Signed-off-by: Lance Yang <lance.yang@linux.dev>

Same as slab, workingset and others.

Acked-by: Usama Arif <usama.arif@linux.dev>





