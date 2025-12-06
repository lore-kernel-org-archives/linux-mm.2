Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43D0CD12692
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 03:09:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C93E6B0344; Fri,  5 Dec 2025 22:09:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 354A86B0345; Fri,  5 Dec 2025 22:09:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21BC76B0346; Fri,  5 Dec 2025 22:09:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0977A6B0344
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 22:09:13 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C28811403B0
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 03:09:12 +0000 (UTC)
X-FDA: 84187564944.05.1A67E35
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf18.hostedemail.com (Postfix) with ESMTP id D414C1C0004
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 03:09:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=samsung.com (policy=none);
	spf=pass (imf18.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.161 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764990551; a=rsa-sha256;
	cv=none;
	b=2TCAqYl7Qgk+ZZBb27iOSvVsqMlIcCuahqAZyh+Yyzh6SipO/kVnOYURH7Z35WrKBnW+CN
	+bWEgMZTl5XXUbP28ihCEJgHi6wPzcssPfd/zptFSyhjvZGxrXXytPdkGsIl7EadrDjx7C
	hdQUSWKR14HQuADa7lV9zkjhVUNpMPs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=samsung.com (policy=none);
	spf=pass (imf18.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.161 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764990551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=7kprrnU00QK3OrfniwlON+JlnZWdz4OM1+ufa4YUTeI=;
	b=f7HovWjgbUpjtGGexXw2qCgpxNPs6BMC0CT96ESc7z7zTApZMZ7GLuHV0bOS3+6jKqyVli
	tPc/X4d582wGIsIV3vCBMEN2d86Bf5bPgtnN8LwPoGbTGDXk67tloSWjIAfvyFG8+1Y+eN
	g/m2kl+ZWfyfwjuXPCXEknTGf2kU35s=
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4dNY9s6173z9ttb;
	Sat,  6 Dec 2025 04:09:05 +0100 (CET)
From: Pankaj Raghav <p.raghav@samsung.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Michal Hocko <mhocko@suse.com>,
	Lance Yang <lance.yang@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nico Pache <npache@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	tytso@mit.edu,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [RFC v2 0/3] Decoupling large folios dependency on THP
Date: Sat,  6 Dec 2025 04:08:55 +0100
Message-ID: <20251206030858.1418814-1-p.raghav@samsung.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D414C1C0004
X-Rspamd-Server: rspam10
X-Stat-Signature: bqc3dumc4gtewp71xep1w4b1tgtwbjd8
X-HE-Tag: 1764990550-672760
X-HE-Meta: U2FsdGVkX19f9C3J3uxMd+jP14Zw9GfZ2ruapLnieOHcTUNgNQwC4SySBqfwE3IDrNVnUKSS1v8serWmr+aun4wW/rdLSvTxt3MiswAUcixa4TBpypLfOERTluN9tsokzOL3lAHiws7GCzNfbDwmczKI/uz4ZfmBci6qnmkx/7Seej58TgFxZ3h9uUD0J9iidfex3tDwO6QXwKhLt6k0Uya1QAzpLuCWMs10wFZzReBrDoc/nXpIpqm2mFpQ3bk7pJl9fxdo+DkYiQ9/EhEor0zyh71/BecVG7PwsxMUASmK9swtD/+//f7pvyG1/yrD752fco5iWUla7qSXznjZRzxprbAJiDIpqVYnGM8AwONjUP0fz6asvxjm1Uo3rJCbQ2PrBjpXQYBLvJm6reY8VsFp1FsAYoEU0Mi6ObJvDIafHFVX1k1Y5jj+bWWU40EXRUaoFBhglL3lbwEEe11SF2Z8TPazErzeMU+y/aVuZayq1EvrWohVidQAmTjCUAWFXWYda7ok8TVSac7e3BNW0G5SSesvEMI8DnIV8HCIFzghjPh0bGh6nDZ76FvyNF/ytyV689K+rJQCSfopvt78zib4C1RgO3EKx5tG33HiNWGJPhFGk6ZEJQUa2zdq1aEw1p88LogfEx94c8VOea41WXHPqSmccfm9FYQ4lCMt8rQfzliJP+DcqfgyfclirVYIuiGc1dX/K6676qQjvPhGrROZILN1L91X+6F9p2RzCklc3J7FCPuRo7+4fOze5H7p2LLIqyOiaFHcw/NRwlWZnIHRdjzCjc3IxTGZD49mbXjdx4dGyw4WPj/cHdxiSUL51zcR4xsJxFI1Gf+wgUcvj2PT7tIc/50c6eOcSbRjU1VfWJS+Ntx0n2pliDR8XKV8JkEFVLyEe9y655slVN8ZZIlc3K5aiFYcBB4CcrpypjVQmd/KNYd0G86liNjFsDkTsT6O/gOGKQBqmkvl1ro
 mNVv7vZk
 eMBYBhJ9QcT9XGA6qOqpxX4K58WUsjE1JfibdbQshqDRFMz8SNCaEfbBV3700yGo4R2D2AFB0lVQVOyyCoAiJGen6IBbORNNbNQ4KkoOwtVbTs0ap0xWghCReeDDulA3ridE3T0/uHwrjVnCp6jpfpuTM32Fwfj5kGy6tK7oYKfHXDNQuTViCn98LxXurSa+u0g4lshLI2OSbnARprrjoL5tTkEa+teW/C1oFaPcCKeEYuSG8HOFbyemH02gijyT3dml/kdOk50eFs+pk6UF3gYckVOlCjkiEDAe414Kgyufrhz/h0aDo3qAacwGtFZXIozsg5plGNEqx+VS3grXNUqENsTGcKeEcBR1uNQCZIrvs+It6k6aAktUyOtdLkbbihd0DLuLTpbNLtKSjv1lp4B1ySgssy532j09Iyasz1JX9J52C8TBmvdEme5BL0Vm/V0c4whO5/5ca8hmml2mGYnPOkPvNlgo/QK2GweEDnCXzzDJjfsBhMyKuMOw8HDN8PXVFvwMEE5UsNaPXsuuGw8Sn9Sjb+0sTiJgX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

File-backed Large folios were initially implemented with dependencies on Transparent
Huge Pages (THP) infrastructure. As large folio adoption expanded across
the kernel, CONFIG_TRANSPARENT_HUGEPAGE has become an overloaded
configuration option, sometimes used as a proxy for large folio support
[1][2][3].

This series is a part of the LPC talk[4], and I am sending the RFC
series to start the discussion.

There are multiple solutions to solve this problem and this is one of
them with minimal changes. I plan on discussing possible other solutions
at the talk.

Based on my investigation, the only feature large folios depend on is
the THP splitting infrastructure. Either during truncation or memory
pressure when the large folio has to be split, then THP's splitting
infrastructure is used to split them into min order folio chunks.

In this approach, we restrict the maximum order of the large folio to
minimum order to ensure we never use the splitting infrastructure when
THP is disabled.

I disabled THP, and ran xfstests on XFS with 16k, 32k and 64k blocksizes
and the changes seems to survive the test without any issues.

Looking forward to some productive discussion.

P.S: Thanks to Zi, David and willy for all the ideas they provided to
solve this problem.

[1] https://lore.kernel.org/linux-mm/731d8b44-1a45-40bc-a274-8f39a7ae0f7f@lucifer.local/
[2] https://lore.kernel.org/all/aGfNKGBz9lhuK1AF@casper.infradead.org/
[3] https://lore.kernel.org/linux-ext4/20251110043226.GD2988753@mit.edu/
[4] https://lpc.events/event/19/contributions/2139/

Pankaj Raghav (3):
  filemap: set max order to be min order if THP is disabled
  huge_memory: skip warning if min order and folio order are same in
    split
  blkdev: remove CONFIG_TRANSPARENT_HUGEPAGES dependency for LBS devices

 include/linux/blkdev.h  |  5 -----
 include/linux/huge_mm.h | 40 ++++++++--------------------------------
 include/linux/pagemap.h | 17 ++++++-----------
 mm/memory.c             | 41 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 55 insertions(+), 48 deletions(-)


base-commit: e4c4d9892021888be6d874ec1be307e80382f431
-- 
2.50.1


