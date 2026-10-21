Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 245FD606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cUJz5ICw
Received: by kanga.kvack.org (Postfix)
	id 2BF0A6B0640; Wed, 21 Oct 2026 02:21:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26F8F6B0642; Wed, 21 Oct 2026 02:21:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1864F6B0643; Wed, 21 Oct 2026 02:21:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EF7626B0640
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:21:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D73B6C0483
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:21:26 +0000 (UTC)
X-FDA: 85345636572.30.20119B2
Received: from mta1.migadu.com (out-43.mta1.migadu.com [95.215.58.43])
	by imf08.hostedemail.com (Postfix) with ESMTP id CA8B1160002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:21:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cUJz5ICw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.43 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792563685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=idy4s9d6iBtDQAtyhTMscnt10Z0fTlsnZMurIYGFMp8=;
	b=MteBCHu8i4l3pb99hnDSQlRBXoHPyHHjCYjk2QZ5lyir+027PKfgr+4J7QcsTZxkN9xx+h
	2MI7hSRCHa5IdpLNsHPBpD7nu0NI+m+mjeIQGm0H2mLSnTil7zYBaE3y0EHtNfE8gd501K
	Bp9tsy/fbx5+P1gtChGNruo9nswoZoU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cUJz5ICw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.43 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792563685;
	b=rv5P99RicI0VYImjRkAAWZtHKMMxqlJcFlmPJvt1BwMRpE4sKNWnJQ7kAJqFFTTpjp+x+9
	xyNDr2k2BPu70eSaT+gTADIVNBj0PwglmWtCVcS8FIZdgt4qFG/jQVfw5p2uh7zOgnTtEu
	Xy2j4dFC9KrtmlGsd+t0ZkWuB2xgiaU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=SFAOLhY6o0gYlN0SGSvGeoHHTL334YOdzDWz6wR4z1Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792563683; v=1; x=1793168483;
 b=cUJz5ICw/S8xI5ZKgUsME5uoC4MmewYOiUkM1iiR0fOB+3baO9hEBk5DBwqVuFYsbcFTKeB2
 qbEi8u5kdQrH3yYLnvyh7guxFEfKUNWWlkY8Qhf913u9V2SMevFb3+lwesto41DKSb3YWKFhdCR
 YHQW4IZ65E4bD+sB/fSdjipI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id bbe1a9e245e58279;
	Wed, 21 Oct 2026 06:21:23 +0000
X-Mizu-Trace-ID: bbe1a9e245e58279
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH] mm/hugetlb: drop unused mm parameter from
 unmap_ref_private()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261021061901.376104-1-lienze@kylinos.cn>
Date: Wed, 21 Oct 2026 14:21:09 +0800
Cc: osalvador@suse.de,
 david@kernel.org,
 akpm@linux-foundation.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: 7bit
Message-Id: <BEECF345-79B2-4D2F-8F6A-A4D831FD151B@linux.dev>
References: <20261021061901.376104-1-lienze@kylinos.cn>
To: Enze Li <lienze@kylinos.cn>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: CA8B1160002
X-Stat-Signature: tw57ct8fxfut8zqcjjr6mfjhjn1qxuyj
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792563684-575498
X-HE-Meta: U2FsdGVkX1+tyqgux5PUjAPXQg6RUyOgFetPwiUWaE3LqxEOw5Pi/O/Cj2hAyR2+h8cAAIvEu0JuNSxGZCfdoBbX52ISr9JZuQ8tArqRjlBPhbXyoWK4lEJuR/O+VS5deUQJ9031MoWkGq5g5ekGSRzsUiapt2evFgcyLpjzC/0oF+cl+rByxeDE4KuMNVA5aDqAI2yy8YebfUukUwxjCTCey/cJzOBAJlukgnHgkwma2pOUKZo8qgLOBwo4A53Sru78JEu54YaTa+rTa3g+/Iu356iE430lMV5s8qaSvaARkNaN+5Mj7N7PbKQNNTuBhI2f6mPilRvWk3IqOO5x8Fy1XaFgfLeVqMJvig9fsDMG43ESxhZMo7FOs4ScilynwclaBgkXS89KK7yJXP09KyrkrekNsZwimJ99TScbVYG5Q2TPbEOTvey2O+q/Uoqtg/Zbm0oARmvMCuVlBBI/1SMAgGPyn5LzYl9K16TvQaBdyIqgm5VxFDKefsCYcvVw0+VGnY5NuBwb4kJJDqjPWOYbdtJEVVgLbzKM5YMXIrA80myaVShoO2M6aN83AYB2od1fRGyIGfdh2JIEDDTAN5/KbWH1h/K0dUf5ECB8Mq/7qA7/hJDsnajRHRbz/Vn28HfPTyfzxLQ3Ya/ERS+wLSNJ+9cm5MN26wd13FaWwnuPdWPvExOBoDH1/yIemRAyPsNiqsQ9oObn27+O5D+SrS3m5thvLCn7FKAUgNIJKO3G7hzF7Kbw0lXWscfeTXvrf7m9zwmGl6HygSON3jQEctnT/oEy47Vk2oDDy2rxgo3Qm6uUG5cAVAbYGJWKiiRICEiEgWNa5Fn5fjEE+kM4l92kOXxc8szR1bIVATUVsnuQ7FkUCKnnbd5dhphAKFLg0z/R7kBr0QiDBDV+Oyo6vtTqZ2PluwUhxthwIzdU48cibTGPspOmUWZhczsV/dpgpyT3ClbZcgVHZ2IPXCv
 bWrkzdkK
 cbkuWv8norWpPnR6UKQ66VleAyU7adtgHNxmXt7kEStKoYMXNM5b/4ZP8r4wu73NE78/lv+61zF36Dj9zqZ3NjOTes3qg/6RamPiHw5apUYiXufOiUfLOI7s7v4JDSs4y0Rs2Ducpb6afiWosVe8uHnTk6x40/qT02nJeVtWaHQWf/UzAMbWMe9LZgknwwvQWYS5z1PvKq2lBxdV2c0+mFhHTcCr3DqSFsKkkmDom4pqY5T010+0x/NinjwRErLjRMVqKk4t55+e5loZTlWpBtftjdUf2200BVw6JrzNSpO+XuLJX2yZTVyzO+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 21, 2026, at 14:19, Enze Li <lienze@kylinos.cn> wrote:
> 
> The mm parameter has never been used since the helper was introduced in
> commit 04f2cbe35699 ("hugetlb: guarantee that COW faults for a process that
> called mmap(MAP_PRIVATE) on hugetlbfs will succeed").  Remove it and drop
> it at the sole call site.
> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


