Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 977B4EE6B47
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 18:13:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1B816B0089; Fri,  6 Feb 2026 13:13:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF2EE6B0092; Fri,  6 Feb 2026 13:13:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1F3C6B0093; Fri,  6 Feb 2026 13:13:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BFCE76B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:13:53 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 607B8C05DF
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:13:53 +0000 (UTC)
X-FDA: 84414830346.01.26DDAA5
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf21.hostedemail.com (Postfix) with ESMTP id 62AF31C0015
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:13:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ldwtKf+R;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770401631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g5Gy1VnuwP3PRcgfNvx+OUQirue6Tb+SWeRbQ4+gTFk=;
	b=ElEtaIV7NI80PJYCvtLurnUhkm5zcDnqPTl8UdkcnRf4bFxGXtUgmty25st3bNlHf5rIZ/
	7gn52gf5mldwbxI1Rz/r7EAcrCSwQaNbrTScz3Kah+LONScUT2qJo2t/ug2KvwCb9QPi4E
	14/ivI2B4fFJ74QuupftXt+jYxV04nA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ldwtKf+R;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770401631; a=rsa-sha256;
	cv=none;
	b=DdWYxO5lfBaNBdLeHp3PK2/lHGpe9fMS6cPAfpmA2cnQqVDCGRCoDoPAAv5rnuXylT6q/P
	BMmJHfAkqFm1dVU4M29vOizF7DnctIpRZZrWPO57mz94+ryPsALnNVZdcQFp28c+1UAMmI
	hkHH7OO/Na5X/EYiarhKmgUHYHVFFG8=
Date: Fri, 6 Feb 2026 10:13:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770401629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g5Gy1VnuwP3PRcgfNvx+OUQirue6Tb+SWeRbQ4+gTFk=;
	b=ldwtKf+RlhBjVz8gW9tXGFBeH8QYbZvKLVfPvUO6+wkMhQ3QSSDUOVoaWpNn9b16Vm4Nba
	tDIeGZvul77SFT9Ck2OrTXNC5bTf8CaDletMpTENThSVk65UomdZufhBvGqEwoAm1L7G8Y
	IIaCLRscj0sRvFK1lyfkq8eFQ1ceYvw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 2/2] selftests/cgroup: add test for zswap
 incompressible pages
Message-ID: <aYYvNq0CibG_ABEG@linux.dev>
References: <20260206072220.144008-1-jiayuan.chen@linux.dev>
 <20260206072220.144008-3-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206072220.144008-3-jiayuan.chen@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 62AF31C0015
X-Rspamd-Server: rspam07
X-Stat-Signature: 635a46tpinr9pihq3a6bi5wbmfm8p5bb
X-HE-Tag: 1770401631-677146
X-HE-Meta: U2FsdGVkX19jb6s1AxddCN1fGeNR6RQkWhjXLvVDknmU1L97bajr52IFv0Hf8APfgmVUQ1nahzH9xzXsyiIKLzR0VIwNMlbkHghwBriM8/n/kx1g6ncMFG5E5EuYMLwFOV/FpolBfx81EBkq7nIK1O/8Xsp7jyS/jgLFshwXl5lVudFsLKmwfcNnFrasohfEMMMwZqUqAWFpMCMW6g5oZLW3ZkwjKM99rkc34SY8Vh6nNNGa7KpEehzYN3AQ1FLz4n7H1nl4emfTnDa13Dnk1oelN/thw+neddqFNkze5XqD3kC0CPgEbrdV/qlkm3wq/DBe1OO/B3fl49sQZ9Lg5vk8t/WzrqmcETAGSAwa1Uiwybq9WLCtihhDTGDLzgQ67roJWL+hROE/Km9MR+u2cn/PwLEd6nzCqx1sYM0m6D23VpGAk0Zyj/KlP/Tq7rKryUTcToYomtEc6WBbjv7qs0VSsErpkva4VxGcAqlEL+SwJzDpN4KV31UA8sucn4+DkkZ3GfCVkUPl7WEUpweJd3I7GD06kdPFIS6IEh9eVHxNMma1JvsCs0SgfLW/7cTf+bRy8cHbtrkleFb0IZF1P/I6dK9Ak7uuUU+/S1ttqSeXJJAvAAniL3+AN3lJ6ny0xFKo8xCTt1MJn+z0grJkWx93wp3nMQH7X5n/mlZO/piAMjKDShhXP/1wRlvF8jnyedYM8xZQSg/vJOSb/MOojobMlMPXnzj8oP/Ap4Rloy1u8Lspazqb4SQhsQiLN5FM29nGEjq/lsetWqH6r1aH2AYwm/AsIcwJZoZGC4ppk2GgXzWt44MAoTG4d7nNqSuTr8Q9Zd0sOkUrQ+ei3GspTYDATXfIyaeqg/pnSVZsywHE8DccaXxWMnQgZ5XEnxgRe6zwLqET/NDBsTREMqKnuc6y33ACINGWNrq7OibM+CTNU8mgwzTEh+cnDDIsq4XF6bkZB9SIIjFsHCOo+fn
 sPqrT5XS
 FJlplZfFUi+sTBas4/lQnnk4EGySoy9tCOo4ag3BasYz5PInctuRkaRuUNT9BBYZSqVecofTMzfCzrks78ptLTSiu0oYH9I226SzHcDw68BniM+cYrXH0rLej/tEH0gzGvaVxbKl4Pz4jMlihHBjy1lLBL6FTZcLPjBVg6Ap1P7U/s2xVvoq2ibdc4Mrw/tDn4PI7UtsJkBi95V3F33Ux0Y51X5cSHMiNMKbVp4nX912uqNOIovuP5S3lENK/PD0tc3m8/nL6anAYRhexAWQaIkeqXA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 03:22:16PM +0800, Jiayuan Chen wrote:
> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> Add test_zswap_incompressible() to verify that the zswap_incomp memcg
> stat correctly tracks incompressible pages.
> 
> The test allocates memory filled with random data from /dev/urandom,
> which cannot be effectively compressed by zswap. When this data is
> swapped out to zswap, it should be stored as-is and tracked by the
> zswap_incomp counter.
> 
> The test verifies that:
> 1. Pages are swapped out to zswap (zswpout increases)
> 2. Incompressible pages are tracked (zswap_incomp increases)
> 
> test:
> dd if=/dev/zero of=/swapfile bs=1M count=2048
> chmod 600 /swapfile
> mkswap /swapfile
> swapon /swapfile
> echo Y > /sys/module/zswap/parameters/enabled
> 
> ./test_zswap
>  TAP version 13
>  1..8
>  ok 1 test_zswap_usage
>  ok 2 test_swapin_nozswap
>  ok 3 test_zswapin
>  ok 4 test_zswap_writeback_enabled
>  ok 5 test_zswap_writeback_disabled
>  ok 6 test_no_kmem_bypass
>  ok 7 test_no_invasive_cgroup_shrink
>  ok 8 test_zswap_incompressible
>  Totals: pass:8 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

