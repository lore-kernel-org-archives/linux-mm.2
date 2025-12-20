Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59BD1E668A7
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 01:14:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE4766B0088; Fri, 19 Dec 2025 20:14:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B91DD6B0089; Fri, 19 Dec 2025 20:14:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A943A6B008A; Fri, 19 Dec 2025 20:14:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 98DA26B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:14:22 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 403A8C0169
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 01:14:22 +0000 (UTC)
X-FDA: 84238078764.26.D8CDB26
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7367C120006
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 01:14:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Dtns4nj1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766193260; a=rsa-sha256;
	cv=none;
	b=MbTu9IN5rcyyP8/fGwAjZDuoz/KHsrjnLZz0J/CfurBFBe+MIfTx7kVSJ1BTFUHNWiiInw
	NkBiVnFnNacbw40LTCYowhrFzZM10pHYZqjDjxzHE2GFhkN0k16Kpn/g1OBAH1LQhB6wVz
	wMUhRt1gYrPzRrJ5dPVURL1QWtIzR+I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Dtns4nj1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766193260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vxC8T+rn7zYzk/KOZEqUCOjZ+il++GuXxMtPIMNg9q0=;
	b=rq61m+zAPgKXddT6Syn1j0Z5/jhrse84u/mz3vWm3gHnSU25s8dCQb/A3u2RzTVvhqk1uP
	MTBjPDLCdeq+Mcj+aQhmGmUTG7XqvBhhPxX7k9y8VIUs6getaFLtO+aMIil94xctvxBiuV
	zrqRqRwVPUwNdt1grBymgohTsf644tg=
Date: Fri, 19 Dec 2025 17:14:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766193253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vxC8T+rn7zYzk/KOZEqUCOjZ+il++GuXxMtPIMNg9q0=;
	b=Dtns4nj1gZMu9QJEiFoWliG7yIBsL+CqKfiT+cqL34Id9Dly3jB4FPjmyxw1MEORyPLanI
	W9bYbDaHiMz9rupETo8XGpT6B46d8o7DrEp72sLTfvWU2vOiPOzuggZzOs0xdUFzWtz6ST
	z962FdLULtNcJR+maixHtF3+WfX2u2U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 18/28] mm: zswap: prevent memory cgroup release in
 zswap_compress()
Message-ID: <yyuvjavtoiszb4ykd6xafyo6nf3gvqk6wsgpmtid2goiqj3vi5@vryj77fitb4l>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <cbd77b6cb5273b75fb2d853f368bcb099f52869e.1765956026.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbd77b6cb5273b75fb2d853f368bcb099f52869e.1765956026.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 7367C120006
X-Rspamd-Server: rspam10
X-Stat-Signature: 1zmnz4t5ode6ukk5r8y3eoa8rx67qrpp
X-HE-Tag: 1766193260-425732
X-HE-Meta: U2FsdGVkX1/aoUx0U3Ljd7PntQG9K2fSEUJEj+5VtuuIS/LdKwSph6pYUwHyVaMP5sMcm01I5fVzimPu8HZagkSWTvY9u5ZmppXETQ4plCzWkjGy+Nza21IjXCC+XB5SBMXWh1eu8eH34DurhCkp9P7ZmQZJVDQj9jKc/HDqmAZ/JpqZlW2EFmoldQDY93VHfIVacLdfzPhrHqX1K+lOXXA0yz274rTGjxhLnIXwH8eGsv1pUhy9Q8tmQiwMp9O9xkTp1xElAoLho/j3w0vQn1gOuXyf1yfNTVFfjschQmjtO3f5EBFtwM0XnNezLslFxsxBy/Ld66y8Oa5V58zAMv2Ad4pC1fpMqssGq7Ii44YLO7O90HtoGqBZ/udwa8/Apz9cpVy6Cw0w73FPDm40BfJM00fXY3kgcF/VsZv9F1WpYFMqwrZJgoInSsZzsAUy/l65wjX8eJlDgqnS6COAb70DNzxFpOH+ZlpnFY+IA0cwxoc1qiUWqawxrztkrSKPu1aeV4oC3VMoR8Eu2z0/gZYqs5xytjYvsnG0jiWj+7d96jo+6nHD6q8NYpYb76LKW6DpPZtXPpr1SPk4yR2IvSJPVjIklGT3FCGwhn/Rlpco5eBV9ox4y4Tubn8+NPx2gk7j5p857V6h86AYg6iI+5olKnriEn/SghU1y6/ldEqzLP3BswTodmXwMHt8vh521fLyYSKV1yhtccbu1MOfQ/0lVm0gAde2Z+SEJikRkF0V5Vgcx2dxuICGio1/TQbcDMV9ejWZX6lJlI+Kei5SojME8moKdC6V6JOHS5xqYb8LBMonE1wS4yMGj6k2pyDvXzorw2PW7zNtTAfrNio5SEKfffqZptAGBbSGMLw00pzbtJLMCi1REpdCw2b29XYabywDZoUV7bjtaYY1dnRxLojCElfNZJ6aDrPmiL/rxJKhoL2Q5s4kK9Lk32ZpFalFb1lkO4P9+uebF3gC1+k
 nUoj0j4R
 iP4img4pPTMU9csC6z+HwxDk2L0Ijl1fdjH0Jj4Pw1on2YjAZJZavaN32TTM3x1FWYXr8lypHXCbWHBjiiChbfzsaeuvH8SpU8VtUgBU3uH135ggNsnaQ0d5zuOKwo+Kzpyjo+XEb9BvpJVRaRCiM4Y2HUp7WmUurvmWDX/uUsM5nrTXDqIBJQAYBe+IsgnBNgx+DlEROpei4nvK5L5jnWZOTQko7ZtCVi/1qoVHX+032KEV8CP+xFhRshmeA7BNogfRN0mZfTbG/mWB/fZ5TeoXCG38sjYp7v6vZ943/sDGp91dYhgm09TwRDQipHm9led0l/fvJA5Wqj7PY2EFqoq0EqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:42PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding memory
> cgroup. To ensure safety, it will only be appropriate to hold the rcu read
> lock or acquire a reference to the memory cgroup returned by
> folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the rcu read lock is employed to safeguard against
> the release of the memory cgroup in zswap_compress().
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

