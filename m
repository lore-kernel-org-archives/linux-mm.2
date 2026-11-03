Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78D30606A327
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OGs90L2h
Received: by kanga.kvack.org (Postfix)
	id 6DAF16B05C7; Tue,  3 Nov 2026 11:18:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 667136B05C8; Tue,  3 Nov 2026 11:18:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57B5B6B05C9; Tue,  3 Nov 2026 11:18:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 265E36B05C7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:18:30 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 98F9E120480
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:18:29 +0000 (UTC)
X-FDA: 85394315538.13.C4C1199
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 592E380013
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:18:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OGs90L2h;
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793722707;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dQIeRuBzui31wbj4eqUyrFMPovSWupke/iiwgt/DWGU=;
	b=2Ph2eMVHewY/cokmS+CS7JfRYvr9xpXyy+GvTV1YvXy8qcf5VadC15N1Zv79H41/azMvj2
	/vryTW0iUnobhFJobE6khIW7iiWwMKxvVVDfx8r0b/gmiT7oMNvuAdJfNBbPTYF1d6eJNX
	p4HHCCzqLCh4gEzHbVB7G1+7sgSElNg=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OGs90L2h;
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793722707;
	b=EfYvkppjc4lIGJz0NbLdH4d71ZPNWhUT/xz1ohxf1mL++zB1pxBHQnDYUcRUZdoTbd4Sd4
	cNnKzN0dTOYy/MS0e7XIOKD53SQXigms6r4as6hzLME7Y8i8jpYAcNJUZQzwwFk3xnrF4T
	jgK5+3oNBNaWWigdxpl8L7YLM7q/HEM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A848243BA9;
	Tue,  3 Nov 2026 16:18:26 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793722706;
	b=dqmQYEgayejhLZs5LR4A8kGi6B8RoAh23yauWT9YPttgWdXI7Vzf7htftGScbQT4qIMr
	 UzrLKFlqJG/H027i2waMxxwcFFZR8Eiz0DZ/uycHbLHgNg49aeaAeuIuphMK3utO6EykS
	 1jtWU91y8IkUAcRjRwYPKI2uHJ4xBHueSTE8q/B9zULWrLerwd1XcTIqQu4nt5rCAo0it
	 2ZRVWDn8tVvOseQM0NVt8Im1wgSvAF76EC+Jk2enEZB0Ci9jJj13mn2URzUlw3O+OL1b2
	 1rnKIKqGYUMJNhOWPxfhIQrBfcN4TgcnlU+T1JLq4U58rLHKTGPWMlUH7Ek/0766fXg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793722706;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=dQIeRuBzui31wbj4eqUyrFMPovSWupke/iiwgt/DWGU=;
	b=RPBc7T0MxYAK2lYKvIQMGJIhe6XJ6y+Vs2W+EyTVCtQPGt2curMY0/kVfyC8UoyOYdHL
	 PhmQENa1bp8hd2v2j5dT8e3wwxy1evj+diAmwQDMULnfKiKkcibPQRlqP4UWJaK4F+Mw/
	 GicQ621Oj3Y2VIMRplsc4232VeTUAi9kga3V8KvmlpVL8xd4nHa6jZXg8+6biJ/sVNfiy
	 RlwejQxm+sGRAyHkmCOVVtQyhG0R9xZFl+fkOKRpW/ZMz01tffb/YoA9bfW0Lb3nr+Ops
	 TqOZYIM1FcnVT9PZNF8X3nS7ON+I+Cl2qRbkhwDeDmCXQ+RyeHZ9AdH1/9BpBCkQfuA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id F14C61F000C1;
	Tue,  3 Nov 2026 16:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793722706;
	bh=dQIeRuBzui31wbj4eqUyrFMPovSWupke/iiwgt/DWGU=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=OGs90L2hzATcXQP2/bW5+tIP/v9edzhaR7G25KCA14bv9XsL+RBM8oGK2tmj0ZNyc
	 Jq9s+IXMpevV2gItKxcmYozbQ1vS0b/gl0KMiVDW3/ae+plK6nQ65Vg0W4ykP5zMKB
	 oE/9LyLcG6h8lQWHDKG9oP/xnPtXd4Q3lTfmtEH/BZgkdR7ddERa8OHHNQhlFXxsxt
	 bunX7p+lpxYUB+HpNA6Xkgp4Tq8PDYX1nFtUAy61TeIA1k2qKhzjLv7YXJDPROIAeJ
	 MslP9X1HdgfRCSZkFKtMW5zOgmBS1ET/XBNfkd+qwQoTbImQkCw0ZIGSEg5jCJagWy
	 5xEn1dNtrFrJA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 4BDB446A07;
	Tue,  3 Nov 2026 16:18:23 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH v2 0/4] mm/swap, zswap: fix stale zswap data and swap-in
 bugs
Date: Wed, 04 Nov 2026 00:18:13 +0800
Message-Id: <20261104-swap-fixes-v2-0-204be064be5b@tencent.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/22NOw7CMBBErxJtjZE/IlaouAdKYZY1MRJO5DUGF
 OXuOKGlfJo3MzMwpUAMx2aGRCVwGGMFvWsABxdvJMK1MmipWyWNFPxyk/DhTSyUcy1qVGR9B7U
 wJdqC6p/7H/PzcifM68JqDIHzmD7bW1Gr93e4KCGFNd4ad+i89njKFJFi3uP4gH5Zli/tnpAxu
 AAAAA==
X-Change-ID: 20261030-swap-fixes-1aa6c2c1e7f9
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Usama Arif <usamaarif642@gmail.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chuanhua Han <hanchuanhua@oppo.com>, Mani Tofigh <mt4022@columbia.edu>, 
 NeilBrown <neil@brown.name>, Christoph Hellwig <hch@lst.de>, 
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
 stable@vger.kernel.org, Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793722701; l=3669;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=1IXCDeRv/bOKH81RaUG8b0PYhXau5ZH24z8Ggh2fGYw=;
 b=72fU0+BSPT24/wFgiMMSDPMJtafBrwKYZufCn/PCHxqYJt/BKlSgQzT1KxbY9WpmInfMdUr8U
 xXQf2kIoV1rDbmcMdT2xv3OSdvIpPAxQKzxGdJFhIcjGi+xEuUMjuBf
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: hiafp4egaqs9e6uo7rbdm9iprs5dizkm
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 592E380013
X-HE-Tag: 1793722707-12655
X-HE-Meta: U2FsdGVkX1+el5PaJ8PFt84kdu8CIaU4uGSU6denL69SUwcydAo9xr6EgCwzsQ7y+NKeOvW1Yymo7BbRqSnp9qVamtsrNt18wjI5CcvbzdZiSCmxQSskjXSvL1b8bxjsM1u8jzK7gqVQQALgXw8mquKGmIMDlelwHpA/7gurh6mmjqLlkdCEPOgJCrXC6U4zmYI+kFOG2/Pip0DhIFuqwY/Urz7VzNoDac2cGrkdRAtr9gQ+J5sazjlZ16Or1hMSq9DjVxPaXUR6ZKJ4bMJTcaIosN5maZmG41eGEPZpWDgpWmt+A60NqKx829S6o1/mEvxO+s4lPLflDnqCsKNvSKtuCCIJbLzvBu4iZrL6wEw8bRtHoy89tkOEzEyPGJbAEqZ4ovr8TD4FBjGmxkpZziJPKUn2U9JZsHXWYuXLlJyORSwwSaPRIHlb49lLW2t6ZnPsKsA/TbTsctCkMTxqGAkk+kkBv/761K0ZvAWqDldtMKKlR3Pgz/cZe6h8UF+OsqR6lqRAAyw3y/WbljeO96KPyqzROkny/b4VYAGvItVTELGc1kipC1/XL1jNCa0GcC1AbdnEDrSjC2KjfItqap0BdcXNh27axi9EmgaRjmL6MV3GcZ7TaFtV4NiOoc9La38FStqcWUpiAmSpqSLOTUevXrjBSlu/dq9k28sLfnK2dxSw/a3s5wTx+VPBQoc7WtX3ApWbjXWTumGFzi8wIEL018oXA4ADh1d5nqz0TzTKxBncBIWKCxvuCMUkrM4ehkq3uyiV96HcwHJTwMrNSHbY/ZrA2mlsaql7o/itBKTy4+k2K7V4UHyyyBoufU3fC23Yh/8k9ymX9N16GsgC0ZIv9dsugXtsIDfbXjNnUc7xMm6fIjlmj/g72sa7rcEbehtfVx2H7DZvBFILFzNJywBqTTxVfI+fyRSDG5OH3REYERJJL+qGdChG8LKqJJQVwP2dL+6mH4lU2u9z39R
 pIVRDorv
 eWVQrvXO9YD8pVV25oO8itIPznCQan5dwx9vqByGy6S/Cuki8FvWm6Gf0E2iLods/qNVGmAzegYveqKunwqgww97/NktztiwuPqZVGjH+Yn+mxFttMOiCcWN+pWdtfgrViiS/hReeSunuLJ99dSnFErAc3vKmr3ACP1fByCQz6uGaqDGkXmBU7dDLrFVirxkzrtPn1KJIxYh4A0awnvTfFJD1DkdoS+mUBsDwPzFQ2g+LCvj6p/wnlcPi97KE5CDE2ErzrB9WHYYmjFsVh2SchfAMg/smnLsKDw6edmXX3iyqGfci6zajubhsnirX6k8XImtG4rpaOtERDD4CrKSvsBOljxDgYyj/bTPHnm34wSJOQFLKr3dR6LMiyNRWXp7p5WPF75iUKoyfsZ24uVIPxEnmIpJ+DasX6jXLRMgeBsbC6MYuBQwuDy92k7PZbzO/Fk3C7fUHcA1FOcG7qmYpBAK5RBTzHbUpCrI+gDcQnGJtRcJusilBK8JHXBPUiqgpeVhi8z43MbMSxAsHza7hvHM79Q3J2nLnPFJ9I8FCtx5MGKiB5WZbkFIh7xKowPwREABaV8nTAH1H18H18T7GvHoATsy0kCGAoxKbNA8+vxeYEo1a8EMqpBGMEI00MgJzETL29N4R38a7YKOA48Ivf9yt/RPZ+xJOYpCAH4i2GWJKsXz8G8yPzl4KmUJqmy3gzBVcF0CarOmO380o/0nHaQ8yzliCXe7dUhtV2p9ewbuj/vQEHhfDZcfcSrnhH0GNgw0ASQv+reeq4XOsVROQMvtiGy6hexvNFJgj16om/j08zhqQNbmdFWnxMJe8jFYjrrcVa7FBeF9nD9CRhp8J281GNkGLK/AeFOFakRwkpCOQVbdjR2/gU+d4QRH6OMJILVAcJMZ5GMF2YKe8geikdkyy7CKeBq0ovRAAPzK0LyLx6OIANlgHSGO1XAP5KeLi5gKI/2uEeUjYUUMUv3lNvgUxsaIt
 UagdS3IS
 v1j9uzDEXGQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi all,

There are some bug fixes found by AI and collected by David, mostly
originally from Anthropic.  After filtering and dropping a few that are
already being patched up by the community [1] [2], these are the 3 we
kept.  The accounting fix is in two patches now, the second one from
Johannes to cover asynchronous devices too.

Patches 1 and 2 are marked for stable, they affect v6.12 and later.
Patches 3 and 4 only affect v7.3 and later, so they are not marked for
stable.

The zswap bug in patch 1 can return stale data instead of the zeroes that
were written, so it is data corruption and seems critical.  The extent
fix in patch 2 is more urgent than it might look, as it can also read in
unexpected data, but the setup could be really rare.

For the extent fix, in the long term we might actually want to detect
extent contiguity and allow mTHP swap-in for single-extent swap files.
We already disable mTHP allocation for swap files, so the current fix is
trivial. It seems the most minimal and correct one for now.
Optimization and cleanups can come later.

Patch 3 gives up readahead batching for synchronous devices, as its
changelog says; that only affects the MADV_WILLNEED and swapoff walks,
the fault path never batched.

Testing: tested on arm64 with both zram and swap file over sync device
and async device, everything works as expected, no content mismatch.

Link: https://lore.kernel.org/linux-mm/20261026-swapoff-writeok-v1-1-4f4cd420aa33@columbia.edu/ [1]
Link: https://lore.kernel.org/linux-mm/20260811132209.2862708-3-youngjun.park@lge.com/ [2]
---
Changes in v2:
- The zswap and accounting fixes are unchanged from v1.
- Patch 2 simplifies the known-gap note about the unmerged xswap patch, per
  Nhat.
- New patch 4 from Johannes keeps the swap-in pressure window open across
  a batch so that asynchronous submission is counted as well.
- Link to v1: https://patch.msgid.link/20261030-swap-fixes-v1-0-73f73a59f2fc@tencent.com

To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Chuanhua Han <hanchuanhua@oppo.com>
Cc: Mani Tofigh <mt4022@columbia.edu>
Cc: NeilBrown <neil@brown.name>
Cc: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org

---
Chris Mason (1):
      mm, swap: fix large swap-in across swap file extents

Johannes Weiner (1):
      mm/swap: keep the swap-in pressure window open across a batch

Josef Bacik (2):
      mm/zswap: drop the stale zswap entry of a zero folio
      mm/swap: account synchronous swap reads as memory stall

 include/linux/swap_ops.h | 10 ++++++
 mm/memory.c              | 16 +++++++--
 mm/page_io.c             | 94 +++++++++++++++++++++++++++++++++---------------
 3 files changed, 89 insertions(+), 31 deletions(-)
---
base-commit: 0ea6dc8c4a2192227ec25768625686b8fcd5cb09
change-id: 20261030-swap-fixes-1aa6c2c1e7f9

Best regards,
--  
Kairui Song <kasong@tencent.com>



