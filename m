Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 030E9103A9BD
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:13:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E2776B0005; Wed, 25 Mar 2026 10:13:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BA966B0092; Wed, 25 Mar 2026 10:13:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F7E36B0095; Wed, 25 Mar 2026 10:13:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 511BB6B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:13:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1EB2F1A094B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:13:58 +0000 (UTC)
X-FDA: 84584779356.29.636291C
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4836A2000D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:13:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vpHIGM3v;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774448036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=saGG4Qei2/D9ljTHLKXPOXlFFn9u3Nykrh8s/nvHDvM=;
	b=uCGbrKJKHhrreYDSW+xMxtIw0Z5GUq8fTwawKyXhehsdl5K0JmM6q+jba5UX93nOugYGKq
	RPvv/Eikw2WEkggnU938EUcyAyHnxR2pgb6Btdr8T16JnkNkIfJ83c2E62Ee+rG9KaQPhv
	jkISRPdBUPh6xEg0VHv+jAaieanAy8c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774448036; a=rsa-sha256;
	cv=none;
	b=COkZElvxY8Jf4Tm+8Oc24TUZKDMzF9ZZBIZQsdCImsnRT5sOhjelzuZ/6UDW2eOBUwVV1+
	J5y91f+cDJ1ULVsUfIXyVI8T5d/TZYHTRJmY0Ymrw5AwVLCOvkt2s2SYlXw8MT1wM+trjQ
	qsJe+rk/W7ugsRfsftRfjUGEr6eTXzE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vpHIGM3v;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774448031;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=saGG4Qei2/D9ljTHLKXPOXlFFn9u3Nykrh8s/nvHDvM=;
	b=vpHIGM3vD8Cj3t5gomLzRm9u+inuYL6O4YHakNxqmTlftLBTERNxXAYsa+cUz1OpMc9H0Q
	NXMTAcwx2RZSNoo9lFWrxv9lHTdCx1dH2NhQTcKQIMLEkLTzI7ZgLQSZ1A0DzgNaXS9N+x
	bat6cR4ITfGma3axr7DekT55xNXc/Sc=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 0/4] fix unexpected type conversions and potential overflows
Date: Wed, 25 Mar 2026 22:13:21 +0800
Message-ID: <cover.1774447069.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: afpx7aqym6o3i91dp1styz4rwgde9j1e
X-Rspamd-Queue-Id: 4836A2000D
X-Rspam-User: 
X-HE-Tag: 1774448036-214018
X-HE-Meta: U2FsdGVkX1+mzDrE/eeNdpfjw69leu5S3Gjkstg/nkSlxPrxXbxUPBnsALH1UvDSawYCm/tVGj/ToeHxqO1ITDvyF4Sz5ChC5kBAvWEe7WBlfLSFqQy3k0QJZ7cDMP+jynB3JGCq0x55i+EN0/jLq6/qnLA/hkXWiwr588XPe1YsFAXPimj7idPiuaXdZtw1yExn2Uw+gcXYuV20R4xcwTWksZEo1GgT3ZmkmtH85afbX3dbWO732O/j1BQD9VGoeG6lJ36+1A7SA2HzG8n+cgjR9RPNYH+ZcDWOeUpIJWpoSSuPAAHkQ2Ef72w2H3yF3jpBVTYIgg9KXmtGVJq3efUqB/BsDIy9tU578NPq+d/bggkHtQ18+c9ewvCm8sGr3Xzc0kX7qTpLajIox8f6JT4wtiHfW4uBXp0OlwJfsfso/pDng/ugL8wPQsESwzei8T+gR5EOHn4IWh+0G/9Q/BM9ixvSgNJw0Uwl5cZxW5xF6EoSpFgjgLHjDZhXh/gZXMKzqbTr2SsW8HE/ptWcSdpHnzOUakpFhiTmdjceXGWvHm8FbO4Cmh0KdZoJN+FdO5yf7AgaPJJ2R/CMvAn5Mk1a1TBGXloqgjc4/KrK2J0sqRiY4HKxk9TgmHZ4V684/LA5OiftMBrg6BepbSXbNlx2J98pZopQnmHlYjzVNbCVN7G9F4hDpaX8wlrti+0Fgzcbm08D7ikr7RkOcQdpPCfc8CX4RCEQ0dgrWQ4q0TEopf5lST8p10ecj5cdEnHxCbItvEiUlbd4Rwgp5hyCXZm+VH2BarHWMAKLVecbEdwfYUqYxJH+VKUMBHFrVxQ34WRrHBQ0a5AP5SBEd6jLMPvlyrNGPxV+0PqhyuFkHyAC2lFaS/p08Ge7K7Ov9uTGi/MYHaIfGgaMr1hnXPCqzXu735K9m2bbcGY3ck8fmWfWBM/1WCVKgail+HZapiKlazBv26HL1liIG6OYMp2
 14a8bkAf
 Qffy/v4H1oO4OD7E0QE5kgoxfbzoJ1udx+4MDgyAq0X6TQDyR9kehQ+PWIk5V41lpsckKrrhPBswOrwzplzIPwz3Ep99AF6+b86ilETHJ+gBuBQQXoI3tZRSq/n7HqWANfl7TLT7gZbUsS0BaeNCJ0CPz/7AeTfi79+Iea5hKvFD1rTA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Hi all,

As Harry Yoo pointed out [1], in scenarios where massive state updates occur
(e.g., during the reparenting of LRU folios), the values passed to memcg stat
update functions can accumulate and exceed the upper limit of a 32-bit integer.

If the parameter types are not large enough (like 'int') or are handled
incorrectly, it can lead to severe truncation, potential overflow issues,
and unexpected type conversion bugs.

This series aims to address these issues by correcting the parameter types
in the relevant functions, and fixing an implicit conversion bug in
memcg_state_val_in_pages().

This series is based on the next-20260323.

Comments and suggestions are welcome!

Thanks,
Qi

[1]. https://lore.kernel.org/all/acDxaEgnqPI-Z4be@hyeyoo/

Qi Zheng (4):
  mm: memcontrol: correct the type of stats_updates to unsigned long
  mm: memcontrol: change val type to long in
    __mod_memcg_{lruvec_}state()
  mm: memcontrol: correct the nr_pages parameter type of
    mem_cgroup_update_lru_size()
  mm: memcontrol: fix unexpected massive positive number in
    memcg_state_val_in_pages()

 include/linux/memcontrol.h   |  2 +-
 include/trace/events/memcg.h | 10 +++++-----
 mm/memcontrol.c              | 37 +++++++++++++++++++-----------------
 3 files changed, 26 insertions(+), 23 deletions(-)

-- 
2.20.1


