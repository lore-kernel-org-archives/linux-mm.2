Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE8C1606A320
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 12:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=NwL/idF7
Received: by kanga.kvack.org (Postfix)
	id D82DA6B0B57; Fri, 23 Oct 2026 08:38:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5A866B0B58; Fri, 23 Oct 2026 08:38:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C701B6B0B59; Fri, 23 Oct 2026 08:38:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A16A56B0B57
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 08:38:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 227EFC0408
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 12:38:21 +0000 (UTC)
X-FDA: 85353844002.29.D193370
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf26.hostedemail.com (Postfix) with ESMTP id 07990140004
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 12:38:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="NwL/idF7";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf26.hostedemail.com: domain of chenhongfeng0212@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=chenhongfeng0212@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792759099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cp05jW7hJV+9rE5FQ+Ld7f2LCLjbgtBVL5t7Y46XhuA=;
	b=rJFFPiq9WeocjB8BjrX8UJv2hU09qiVf1Vncik6lHyGpUBmt2YZiS/xeoylxj9wvva9/Ud
	E5EczbTwf+KAbAQTf25vxG3YHnE1MWkCV+w7WwCL1urw5PbUFXS60pzjbig4Ju+PR5SecF
	xodfN5jWX8TbwrgmwKjT7BjLhHB9XeE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="NwL/idF7";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf26.hostedemail.com: domain of chenhongfeng0212@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=chenhongfeng0212@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792759099;
	b=AGigCArJUc3neGiKTs84zfjx4ztebf2OA5PyfMeRJ4sHikV8Wmx89GmSCaKv0xahMrG/Zh
	5wUMPrkA3jLngfkeqZwA19YkXdD71ksAiRgPHE1OCfBexomdGT/veSleOPhDy9Ap3maRpe
	LnTIjvs9ZVVhSh+BHStDOVNKICGPPmo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=cp
	05jW7hJV+9rE5FQ+Ld7f2LCLjbgtBVL5t7Y46XhuA=; b=NwL/idF7yLcNVy1Sqh
	wCBArmlZDfE3CETd4QWsLQicQ1DnbCevfOyjT9Nf5WHJ4Txi+50Aq408HisBlz5P
	ukvpaIcil4sCLfPuJ3cgvXk2hEO+rw0CCAVYffw0vh0PIdp9f7+ICJqC9UfRbcWC
	BsU40s1CE8mXgqDsdc2XwQRus=
Received: from hongfeng.mioffice.cn (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wD31_UTVdtq41kmCA--.56769S2;
	Fri, 23 Oct 2026 20:37:41 +0800 (CST)
From: Hongfeng Chen <chenhongfeng0212@163.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Hongfeng Chen <chenhongfeng0212@163.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Wenchao Hao <haowenchao@xiaomi.com>,
	Wenchao Hao <haowenchao22@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	Hongfeng Chen <hongfengchen@xiaomi.com>,
	Hongfeng Chen <chenhongfeng0212@gmail.com>
Subject: Re: [RFC PATCH v4 0/2] mm/zsmalloc: defer object free to per-cpu batches
Date: Fri, 23 Oct 2026 20:37:36 +0800
Message-ID: <20261023123736.1542117-1-chenhongfeng0212@163.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CAKEwX=ONniSwdiZAe_8NT5XwVj=Mmc-WJs_rWE4Y5snjFg2=Eg@mail.gmail.com>
References: <20261016120927.3191690-1-hongfengchen@xiaomi.com> <CAKEwX=ONniSwdiZAe_8NT5XwVj=Mmc-WJs_rWE4Y5snjFg2=Eg@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD31_UTVdtq41kmCA--.56769S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WF4UGw15Xw4kAr4kJr4rGrg_yoW8XFyUpF
	Z3GayxWws5Jr1xKr97Aw48ur18Aw1rGF48JrWSy347ZFn0yFnFkw1kJay8Zw1fAr4Fk3WF
	yFWktw15trsrZa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U2XdbUUUUU=
X-CM-SenderInfo: hfkh0xxrqjwvtqjqjiqs6rljoofrz/xtbC7hXrBWrbVRW5MAAA3t
X-Rspamd-Queue-Id: 07990140004
X-Stat-Signature: puff9pdn6oxzdprcjyumz1houqhos4qd
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792759096-494266
X-HE-Meta: U2FsdGVkX1/hKmq/9oqkU7qfyxNPeI2/cYL6ZYB1+zbm7nowK/kU4Bl2jWtPa9/gHydzg6/jwS5Z+K5I4srSD93dpyLtcCTQ1RrRpmkFHstjYnxODiifx95Pp0WbcbJLj1vVdeqxaKUYd6r52ENmHzL1vfkMZwAG6DtazV3PwDW1Cdv2BsIw2h8y/hQ4gZ4L8b5KlCwQhDl4we4h/hLb63MbqR29jviwmeDkZrDPx0MoEuuY7SOYrWlLwXParE8OSvdBljlu1OZyeBVN7onoAP4D7mdqGeZ7j7H/cBL6QvtlUXTFm7R7A1GQrcGAgJo/uI/EaDwUUdVnkCM25pvScLttmyWazaZeCQOw9tZxjJi0TyQnxwpNATq32bTt5k5ZBh+RR6yP1rYEyiZO3IjzyPHi7MKR7MkLOqcIM41HgIgsSZsC5XE6/CuOY13gKJ+BTGuwQusn2v5x7NKqKRwjdN2WYKwFL1nLWt6FzRov7qF7rl2NC59e9PP1mrUVCjLsOIFh82Ny4xtaJOdl0SXWntXQYWS5866i8pGfkmJFB+xuG+eiszTuhmGLj6CI//F/gCRFMk5C/9cldg1ARxMcoLeKLUa01uTo/2E0dBJfqVxjBn2pgUrgf8gudl+V2jeh1Toic8PrZyLm8AbuElSRviD8kgv2qDHkU+8H7JcpdrejiWfT+yPt5mJ6dvDcOwbI7vkQ9pSx5fOgFmb9yJ+FJPgKMZpbI6dyakOruNV5dGb74MkxPgotjo+nbMg2zfpz9pVX1tGDPpJVi/N75OytdflGXrbe9IkLowwin2at9OOd5XvKePiyrOM7ivnthmGjXpcsEmv4YFGC7VQmPYh4jfsA8WzbPSQUDcwywaQTV/oAa1yZuMdg9932PLLX1+DPODgsC/BySsIWq/qNhYhgFEfMS8BvHxpBxrlE2FYHVB92j6m0ZZB8VsdZwtiWs8GO5RlV8UYsCiwkSqx6y4U
 mdwcL6gP
 9wZv1DLJ1PxFbULcukmrwEFwYcPogj12xpexqfPSE9gurCv4QOTx9H6o/123AtUKv3lyi6lGAo04bSlGaSWF7HJBRs0jgJXc3H6XB+J9b6/2Y6M4Mae2v5EJ6flDYuqnKtlziL9rxyfrJ2VPTHktA/hWdTK65xcZk+VwccLQy3rY4H9aavHxQ9sjHpFaAdDCvmN5PmHVG12la88Ca/RBbAP2tw9baYX3mINQ8Sl9EHv6rUY3LRaYFQUKAgS14SU8qkjaCrF4Jeh5d8sM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Nhat,

On Fri, Oct 16, 2026 at 9:09 AM Nhat Pham <nphamcs@gmail.com> wrote:
> 1. Would memory freeing be slowed down?

I sampled pool->pages_allocated every 1 ms, and measured the time from
the start of munmap() until the zspages are freed. Three cases are
tested: 1 process x 256MB, 1 process x 1024MB, and 4 processes x
256MB. The results are as follows:

  workload                  base      with-patch
  1 process, 256 MB         14 ms     9 ms
  1 process, 1024 MB        51 ms     31 ms
  4 processes, 256 MB       45 ms     24 ms

Memory freeing didn't get slower and it actually got faster.

> 2. Would this introduce isolation issues, especially when this work is
> not properly accounted?

Yes. The drain runs in an unbound kworker in the root cgroup, so its
cost is not charged to the killed tenant, and it may take CPU time
from other tenants. I'd appreciate any suggestions on a clean way to
handle this.

> Another thing I wonder is, how much of this slowed down is because of
> zsmalloc's own inefficiency, and how much is because we just have a
> larger logical footprint

Mostly zsmalloc. I kept the footprint the same (1 GB paged out to zram,
then munmap()) and only made zs_free() do nothing:

--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1455,6 +1455,8 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
 	int fullness;
 	struct zspage *zspage_to_free = NULL;
 
+	return;
+
 	if (IS_ERR_OR_NULL((void *)handle))
 		return;

The speedup is as follows:

  machine                   base      with-diff-above   speedup
  x86, 1024 MB              50.2 ms   20.6 ms           2.44x
  RK3588 A76, 1024 MB       89.4 ms   23.3 ms           3.84x

Thanks,
Hongfeng


