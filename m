Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBAA4E83F05
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 18:22:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FF276B0092; Wed,  4 Feb 2026 13:22:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AD1D6B0093; Wed,  4 Feb 2026 13:22:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ABC36B0096; Wed,  4 Feb 2026 13:22:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 254176B0092
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 13:22:06 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C3B1CC1757
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:22:05 +0000 (UTC)
X-FDA: 84407593410.05.CE5E051
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id F284E140003
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:22:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="d/uRtbkw";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770229324; a=rsa-sha256;
	cv=none;
	b=41SW772qHC9pjw9C4pkQQo0LJR5xbVpHwSkbyJJ2DmoNws8MfAyhkD1s4Uu6jho12aroRd
	5ZVeu/TSHP2USyZ7MdTrieGqObLVZ1mRGsW5PHaNutXw3JM/Q7LjYFwsuSiNL5A9aoMi7j
	PDZHlUg4kal9qFD/kLEx8knvgTb9ig0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="d/uRtbkw";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770229324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wBQi2IHq6aU5FZogCigX9J35/KRWrbQVb6t63SL+sQY=;
	b=H8tC8uPTtFaEKqRBC2+/75UyXQPFkNHnXELQEuWSx298tRkurZaAWXZJ0/ql3NqZ03VMpO
	lyZFQlZJHpEpJL9rMcLSVZSHZdKsuN86d1/YSz9HBKaedUh5YwVJgQYsww5ypyJLYLWLsH
	5/xg+YQR1LsBSuUnSuB4gbvm7oMvltM=
Date: Wed, 4 Feb 2026 18:21:43 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770229319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wBQi2IHq6aU5FZogCigX9J35/KRWrbQVb6t63SL+sQY=;
	b=d/uRtbkwit9hzr9WRSeAlVqDQY6HUb2t+kUSxV6yKZ3URZKHtEiSEngbsWwe8grmSqZIVO
	Z7TBhClohlOnGSzdZKObmZ71tF8ZRjiFuadIteOrw4MhaaRiO5iMsbDkT2/V+2ahIaxG9O
	PpbQNkTyB1ytmvjeCyF4NL6zxeWECZg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, 21cnbao@gmail.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, sj@kernel.org, kasong@tencent.com, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, 
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com, surenb@google.com, 
	kristen.c.accardi@intel.com, vinicius.gomes@intel.com, giovanni.cabiddu@intel.com, 
	wajdi.k.feghali@intel.com
Subject: Re: [PATCH v14 00/26] zswap compression batching with optimized
 iaa_crypto driver
Message-ID: <nlsqmn3x56ug7vfxw3vmpsmlyc6sie2plr22hpu7q6j7jq3adx@jbgg7sza67mv>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F284E140003
X-Stat-Signature: p8y6h6o9ebizozxgaa51wp5i4c6zp3j4
X-HE-Tag: 1770229323-917772
X-HE-Meta: U2FsdGVkX1/vCk6yDDElXc/vXoRJQjJrmsKx15bB9w1aTkiJYKm28a86e+sSF9DjYq5GQsnE9GImE/jbpcJIwsJ2Wa6x/NElcFXd638C8ZklqLK1E/MkfzGu0nzfuttylzzw02Oo+2obybNo470m4WYx4jYalaXlqjvbl1k1OT+exItqj6qUext5RvXacWoKBpvtICLWWzDqgkeyIdd0BKz9M3OjDntoxoPqGHRz0qcod34J36HK7GWoSgEGZy4P/nSGkp6k7V+3XCGXCIkgo8PZTfqlS73he/F1N2U7XdXv7hARBulP+LB+BVBTUg5Dp/ROlM60DuG4aBJGVVYPRCnvd01OA7cMT2/H74qXhSXeVQTiy3KrvUCWyJR2QOIUHtQySiQFLimD/yQ9U9G4GLvbIiIzHPaIikUrreiphRnrvHfBsoGw2hU0Apn+TOlO12Wqyy/RvdRPn35rwKWgr5PB59HWCpHdzP6qi8Fbiy7MHbpizCuN0nlNxQH0lf7QpeiUuVbnau2fe44J8vttQ2TKie525e64KFN97Ydc6Gye/IvMXz/s8MS4VMiPN2+4DBwzGd8w7D3I+ux6cxvu/3hcDdLXYqK1mcGA/ZxqiHXrGT3zCQ2byf94oWy+/lyHFgn7aAc2di/sPM9l67wpBlr3Hpq67Q/At4mA3lRw+wdWOsm1uxV2Kx+fZEirynimM5vqI9RtRTWDhxllws66EQJjDMJAuo/m7ZkHv9V32K5gh4Gur7XPEG1SFHgRBVf6o/cWvCY1UBPKLPKVc0wnIp6w/FtUWVByVW4JE6bog8YpUUk+MTlXc6Eusi+pKB0ZqTUaEx+WUiesA7Mzk4qtQ0IhN7D1WcDOAlw25oq18M1XD2Q9biodhLRX6t0E1reaw2rmhmIA0uGV0VpL1z1GNgZNyTD7wA0rwV/gsE/s1KX1uUfeMkEA16zxlNUAEps3FlZNLXDx8SEj0jPjrUB
 Z6IyEEXq
 G82GEpdp0vl8bfxdlIozUOl13q01ndbFT6Wumm5RNHQQJVoDKP3+ap/V4md6cPaWdUui3hhp8S9lVL8nrPQ7XUDgWeDcTbbEpMQBeppqKxdi5uL+4eEB7GxnyVr9nh4rWwDUnbo1w7mXyg3Dhkg5onCKcwBRcc3UYGAsv9PsywNlfxiTrZl0S3cWHfOx228a06ZswoHaxKCzQ47fHxdQ6cAljGKajR5dd9NJs06jL6sS83RUASMr7qzrn+SPkn+gxwjJw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 24, 2026 at 07:35:11PM -0800, Kanchana P Sridhar wrote:
[..] 

I think this series is really hard to move and respin in its current
form.

Herbert, could we take in the crypto patches separately (if they are
ready)? Not sure if it's better to take them through the crypto tree
(and provide a tag for Andrew?), or through the mm tree. But either way,
most review is on the later zswap patches and respinning all these
crypto patch every time is a pain.

> 
> Kanchana P Sridhar (26):
>   crypto: iaa - Reorganize the iaa_crypto driver code.
>   crypto: iaa - Replace sprintf with sysfs_emit in sysfs show functions
>   crypto: iaa - New architecture for IAA device WQ [de]comp usage & core
>     mapping.
>   crypto: iaa - Simplify, consistency of function parameters, minor
>     stats bug fix.
>   crypto: iaa - Descriptor allocation timeouts with mitigations.
>   crypto: iaa - iaa_wq uses percpu_refs for get/put reference counting.
>   crypto: iaa - Simplify the code flow in iaa_compress() and
>     iaa_decompress().
>   crypto: iaa - Refactor hardware descriptor setup into separate
>     procedures.
>   crypto: iaa - Simplified, efficient job submissions for non-irq mode.
>   crypto: iaa - Deprecate exporting add/remove IAA compression modes.
>   crypto: iaa - Expect a single scatterlist for a [de]compress request's
>     src/dst.
>   crypto: iaa - Rearchitect iaa_crypto to have clean interfaces with
>     crypto_acomp.
>   crypto: acomp - Define a unit_size in struct acomp_req to enable
>     batching.
>   crypto: acomp - Add bit to indicate segmentation support
>   crypto: acomp - Add trivial segmentation wrapper
>   crypto: iaa - IAA Batching for parallel compressions/decompressions.
>   crypto: iaa - Submit the two largest source buffers first in batch
>     decompress.
>   crypto: acomp, iaa - crypto_acomp integration of IAA Batching.
>   crypto: iaa - Enable async mode and make it the default.
>   crypto: iaa - Disable iaa_verify_compress by default.
>   crypto: iaa - Add deflate-iaa-dynamic compression mode.
>   crypto: acomp - Add crypto_acomp_batch_size() to get an algorithm's
>     batch-size.
>   mm: zswap: Tie per-CPU acomp_ctx lifetime to the pool.
>   mm: zswap: Consistently use IS_ERR_OR_NULL() to check acomp_ctx
>     resources.

Andrew, I think this two zswap patches are in good shape, and are
standalone improvements. Do they apply to mm-unstable? Could we take
them in separately to lighten the load of respinning this?

>   mm: zswap: Store large folios in batches.
>   mm: zswap: Batched zswap_compress() for compress batching of large
>     folios.
> 
>  .../driver-api/crypto/iaa/iaa-crypto.rst      |  168 +-
>  crypto/acompress.c                            |  110 +-
>  crypto/testmgr.c                              |   10 +
>  crypto/testmgr.h                              |   74 +
>  drivers/crypto/intel/iaa/Makefile             |    4 +-
>  drivers/crypto/intel/iaa/iaa_crypto.h         |   95 +-
>  .../intel/iaa/iaa_crypto_comp_dynamic.c       |   22 +
>  drivers/crypto/intel/iaa/iaa_crypto_main.c    | 2926 ++++++++++++-----
>  drivers/crypto/intel/iaa/iaa_crypto_stats.c   |    8 +
>  drivers/crypto/intel/iaa/iaa_crypto_stats.h   |    2 +
>  include/crypto/acompress.h                    |   68 +
>  include/crypto/algapi.h                       |    5 +
>  include/crypto/internal/acompress.h           |   15 +
>  include/linux/crypto.h                        |    3 +
>  mm/zswap.c                                    |  724 ++--
>  15 files changed, 3144 insertions(+), 1090 deletions(-)
>  create mode 100644 drivers/crypto/intel/iaa/iaa_crypto_comp_dynamic.c
> 
> -- 
> 2.27.0
> 

