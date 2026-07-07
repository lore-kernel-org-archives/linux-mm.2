Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F94FC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 12:14:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 791FB6B00AD; Tue,  7 Jul 2026 08:14:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 768A96B00AE; Tue,  7 Jul 2026 08:14:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A8896B00AF; Tue,  7 Jul 2026 08:14:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3DBBB6B00AD
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:14:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 98140C2339
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:14:53 +0000 (UTC)
X-FDA: 84961874466.29.2E57D2F
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf23.hostedemail.com (Postfix) with ESMTP id A11F5140009
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:14:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dnZX8NVS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783426492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YAAXy536t9SekqRYGrtDkUhq1/DKNIxZvKhhwo2mLyw=;
	b=1gm4oSVaQAucEszch9FVdd8SgAwmHre/qTjERb/8NzhXvyDZSUnuZ+KIS69oIqaDgELntI
	PjEKODFoS4hUyEky59zXlLRJ1FIMgc/a/F8uQe1qdFxu3fTcGLilg2Qrbze4GgqC54Cs+x
	pP6uQ7gElmeNSERatMv6wou82jQvTVU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dnZX8NVS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783426492;
	b=xbWtnFK9oP9+dO1EKBHbfoe5i8g5wV3nLIySbZeqSYDhhwywr/3gPwi5XxLZLQDq+vjRKO
	0SeFAZCNgJuXYvWcQdXds5K9lgRBdjPLpp5Ch1CAg1FHk+5r2EYmJ/xh1b50LFypXpWb8i
	mWREieT1TiVDNM9n14nnNgQ8fOXXqjg=
Message-ID: <7d955bb1-9abd-4ba7-b1a6-a19f999cfa27@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783426489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YAAXy536t9SekqRYGrtDkUhq1/DKNIxZvKhhwo2mLyw=;
	b=dnZX8NVSJ1gWNjwt2iG1RLuceDp2+oztQwYUY4lB/jOrhLw3Yjhyh2vVwsGgLT3sFTLOhY
	z1RAbF46D9HGS9l4eayKo4Gzp9PWmOkCYppkyvGH3Wbbp2oJ0LpI4m90A1osALOFeDV2w+
	SPZJl0PCl0Udo5g3ebVcfieXSV560vM=
Date: Tue, 7 Jul 2026 20:14:30 +0800
MIME-Version: 1.0
Subject: Re: cgroup/test_zswap failed with "zswpout does not increase after
 test program"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com,
 chengming.zhou@linux.dev, tj@kernel.org, Shuah Khan <shuah@kernel.org>,
 mhocko@kernel.org, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Li Wang <li.wang@linux.dev>
References: <c0970cee-42c2-4844-b88e-229853f08e90@linux.dev>
 <akzpi93tZry0cCCe@localhost.localdomain>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <akzpi93tZry0cCCe@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: cu8pgszc75w4ss7uo5jpi8tp5cr5r1ps
X-Rspamd-Queue-Id: A11F5140009
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783426491-432662
X-HE-Meta: U2FsdGVkX19GTUBWor4IydP43kyT5/iecAE8mCqwL2n7VgynKBCWluaAqpN52smEZiYpsKbffozLr3G4jwuDb3UB8XMCFFgdLbSrimc5BiGYzZs9pTI/iR3ylmUCxyatEONxT2zCw5Lqxo6FKs1qstZi1KZwJ0FNjKp23kSG9dcV4u/5+OYYlTp2YEsP+OF2YeVXU5qlMJPEfx8kFdKwjQkxV6NWoxvsEiIUTuIMlxy8Iib5DZ77+KMwY8PWNvqZmhfigLTUSwVgtXe9HhSET8gfyXdm2bqMd6kIaZlqDA4tgcLxsoKMqmHbPoC3E7pkWwPUio+PUSFMg2Oqt7/RaP9igsiVbSNyq9Asoxun/98DYH37okM79kv/G9oRCk53JSAUVsKfxa+5hxxrO2RrR8AQZ+QoZHV5OZcpe4W1iKpuZ3Xauyi6smmyBjAEXYPzy1O9CSdrlvCnmn3sMHXahZIlcKSQxVBEQcheY7C2sF+KGfcMPUoXqPoMEhE9aHcWHd0M9vMD7nRU6HVeZWfNzI5YOA/Oy8c/xKGbJDb79TG990QLMnUUxnVv8OumW/+eyVL5OL8PkwnVbrCjXOfU3pPWv6h7Tbv/XdIeRHkjMkwksm5uObRknM8Q6ADqDVgk1BECZ3fixJl5FyM3aWeiZMbuH/cd4NQW6KAsdkGri5j4uTRvC+LQhBKeJWmoXJ+FR/FoXNzNvJ6HBhKhBJpKZdnYKySgZjkGfC0+atABsyf+0NgFk3P0/mSHBxrX4W20owzPqZMkgBYWRu9+lQtF4v8hqHAQFTy9RX7Ubm1580p5qsgF/Fw2AH/arBWt5ftHGcYSu55ZdzeKcJMTYqklid++iIJisD45iiLfLdIrAbBzPSdkdZZVqY8G/hzKsIylwWvdfHZ5r1UQ5xrUZrjE4xLIbGFO6UKWcPYSydoxTKKlG1MFonHa+Aya8c+If045Dnq4yr4PxuKMqC1UVpz
 GzHrSezW
 cyFfOiXo6XGkeO0LOr8qdD7ouXFNX++V6TQUwTVt+9AfmPbPxJgWwOt5vvbTvhh/OhtYyrOvl05fayLCr4WQE5770Ee0yzelvf7lbG9v52mvUVcU/DzuSsynGZJSAq2f28oQ5j9JRtMLV3p/4uWO09GcX6nboKtrOF1gXRoCKcA5gklHMssOxN7y6N094m6bWnk7kScED1dfVPFFYavohrZ6lllWMmaxiN3/9jI0ayrj8GBt3loakN89Tx0xzmTdcWkxpzSeImX58SiNTMZgzjOPiFXIHB6XVu6zTMihYzhq7XjednxkVk9edKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Michal,

On 7/7/26 8:01 PM, Michal Koutný wrote:
> Hello Zenghui.
> 
> On Tue, Jul 07, 2026 at 05:38:13PM +0800, Zenghui Yu <zenghui.yu@linux.dev> wrote:
> > Hi,
> >
> > Running cgroup/test_zswap on my arm64 box failed immediately with:
> >
> >   [root@localhost cgroup]# ./test_zswap 
> >   TAP version 13
> >   1..8
> >   # zswpout does not increase after test program
> >   not ok 1 test_zswap_usage
> >   [...]
> 
> What version of the tests do you run?
> Namely, does it have the recent patches from Li [1]?

I use today's mm-new [*]

> 
> [1] 83476cc97bc63 ("Merge tag 'cgroup-for-7.2' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup") v7.2-rc1~136

... so it should already be included.

[*] https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/log/?h=mm-new

Thanks,
Zenghui

