Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBCD7CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 07:33:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0CC06B0088; Mon, 11 May 2026 03:33:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBD1D6B008A; Mon, 11 May 2026 03:33:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD3026B008C; Mon, 11 May 2026 03:33:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CBACB6B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 03:33:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6519340631
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:33:55 +0000 (UTC)
X-FDA: 84754324830.11.445B121
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8FBE31A000F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:33:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IZdOkapu;
	spf=pass (imf19.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778484833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6CufjDIbsHluKLDnrdwi6M4/DWOeucI07hgQwDXDTzA=;
	b=bIb+oS1uuQvJ58SyvDwxLbhbqm7VFlr1NTbK/ty5SOqSbvY0gifJfX2oDfJKX0cspmolb7
	1pXZinlz4kvUQYcl+OQmEXMZeRvMICIGitSm4Z9Iyjv6km/SqmziHcWWOkpTfhG92XxBkk
	OLDu3O/M9HLNoLbMJxFJtEyoLl9ifFQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IZdOkapu;
	spf=pass (imf19.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778484833; a=rsa-sha256;
	cv=none;
	b=RWFMCsXuVIvdy2wLOzSM5gkdpp4JZgVO3WAjDeSkVBVu9DpGDG2Bm365yMZh+NVWXLVmAv
	2De59al9woW4SrNTWKR+bTCjwlQzBYlOWlgIDmxQCUwrs2njdtYLj0NFLYwJtt6pvF9ugH
	0VWs6SM5yfHe9V8MBOUgYZJHGA/IWWI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778484831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6CufjDIbsHluKLDnrdwi6M4/DWOeucI07hgQwDXDTzA=;
	b=IZdOkapusyDwnQPRt6JRPBqB6nGg28KiP14ZABhXymIu8yc6wIOL/RiaErJvEdwDwLAx5F
	ALbuBKpgxPivhc2EDQ1J49h/du88OwvEhKfqYDoRcoZprdodgOPot+l2PQeFplOAzlybXX
	1JVDz24lE0PR09eB0yE6AUnqMJ5MIjg=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	usama.arif@linux.dev,
	chrisl@kernel.org,
	baohua@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [PATCH v5 0/3] mm/swap: use swap_ops to register swap device's methods
Date: Mon, 11 May 2026 15:33:31 +0800
Message-ID: <20260511073334.635682-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8FBE31A000F
X-Stat-Signature: zza56b19jxpb8fee1x31geiagnirby6d
X-HE-Tag: 1778484833-967592
X-HE-Meta: U2FsdGVkX1+0+nizJJGOVNkJNvCRm5FQXI8NrgLQhjvPG79YKO0QOYXQwjA5T2pq77zmtrV5jfAsMtOZKcAuDkgP78qs4fkwLgw7er75nflZRYYzm2Ss1Dsx1Z6GJW3+hdlqncYjTGywug5kB/htMIvP9p34NlFsDy54I2qrM/WVhN/LAyXT8jghZp32J30m3Nwlgjj7jTHYYIR/906iWQ3se9UjPBlu4t8C0lcEserfflzhRczVrKlTr3sVr95bO9syxzsv2fSVglbkpCyVOEiYD184LszlawQkOjviMyFh3uNz7xzFh/ShuA1XjsALETMkDAC2JYP/ioWHCBjcGZWKA2lsGy/sL+vuujICBjZP3ExvuK3TFvPECpNunimUqzz57Du85y5RcRfa7TjUbB3fyWpQ9tAFtzBYL+BeZIm8wOBQyPDl1ds9g81e2y7U4KQ7AIX0UJt/bVMQ4Te1+ovpYm/zMv7LDwWXcpgFJKKvbinQC1e/+QyzsgoDaVsBnDQ8E/a5iPoAWBXE/fyerUHixGtOeUvd82trW7FY7XLEwAmiIQChvBhDoMFXfER58O4N1RW1RBSyVTqQDYP51OVHXP9dreqYnZH7aczxUKlG9648x7Y7o8ozSDId1SsLu2hs4qpi/IAgGj4hicQ5B9HtKTemQPmBzQYP7DLUppXuE+eeWmMSf+b6hATX5Tfr2nCzdpWn6Ua4I7jNkvO9Lvv55koxZr2JqfQdP6ieEMblC/ZSpynl9yAjqysPhLdtASrpKWRp0i0wCfvYdeWXrZRYOUiXwM48tHk2HlQejKGTxHcUVZROZBgkoot5A582xGBr9ZZl5KgX9R2x6cEsTT1FnIBRa+A9PQ1YALykW5oMhXUtlUDG2fRc94PlPGhtMrS0T6f9fee3f8aPLJq1rMUlTCvPzp2OqCH+AE0C4PH/7Goadhc5Y7d1cwiHsaq929AIa9RJkqg+5du3F5q
 /XPRHsLJ
 npyEgnNOdCOy95cYlIaX8+WmyIf5zVcHGL6cdRdnqzQ7RAOb6e3dlIXr3L/9hOnblkXijh8itNKF9BY5Zcj8fubpuYMRCgR1nxPbbJN1Hnru0UDXz3lD08fy3T6eV5txDNSVSwocifN0AT4Q/eTwJX1Rh+s00q0+ah5kMHWRQXJ8J4ZU4WDfl7zVvqLiz2593Ozta5uP0TNSvzV1MqzFKXYpqHvvfd8bsdJABelVgQRtD/jVOiRjHUQal8p/ds0T1eS01O1CXe1RR5sbwG8CmG2PgQAtdxlFiMDEt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This can simplify the code logic and benefit any new type of swap device
added later.

And also do renaming in this patchset:
-------
   file renaming:
   ---
   mm/page_io.c to mm/swap_io.c

   function renaming:
   ---
   swap_writepage_* to swap_write_folio_* in file mm/swap_io.c

Changlog:
===
-v5:
 * Change the return value of init_swap_ops() as -EINVAL as per Chris's
   suggestion and adjust its invocation in swapon() accordingly.
 * Add Chris and Usama's Ack tags.

-v4:
 * Fix a typo opeations -> operations
 * Fix a code bug inside init_swap_ops(). I was taking a change at the
   time, thought the change is trivial, so I only compiled but didn't
   run kernel to test in v3. Now fix it and test passed.
   Thanaks to Usama for catching the above two issues.

-v3:
 * Rename setup_swap_ops() to init_swap_ops() which reflect the function
   behaviour a little better
 * Check if sis->ops, sis->ops->read_folio and sis->ops->write_folio is
   NULL in init_swap_ops(), but not spread them where they are called.
   And once the checking failed, fail swapon immediately. This is
   suggested by Chris.
 * Call init_swap_ops() before setup_swap_extents() invocation. This
   doesn't harm anything and can benefit later adding sis->ops->swap_activate
   method.

-v2:
 * lots of cleanup for patch 2/3: renaming, moving data
   structures, and using const properly
 * collected tags from Kairui, Nhat and Barry

-v1:
 https://lore.kernel.org/linux-mm/20260302104016.163542-1-bhe@redhat.com/

Baoquan He (3):
  mm/swap: rename mm/page_io.c to mm/swap_io.c
  mm/swap: use swap_ops to register swap device's methods
  mm/swap_io.c: rename swap_writepage_* to swap_write_folio_*

 MAINTAINERS                 |   2 +-
 include/linux/swap.h        |   2 +
 mm/Makefile                 |   2 +-
 mm/swap.h                   |  12 ++++-
 mm/{page_io.c => swap_io.c} | 104 ++++++++++++++++++++----------------
 mm/swapfile.c               |   4 ++
 mm/zswap.c                  |   2 +-
 7 files changed, 78 insertions(+), 50 deletions(-)
 rename mm/{page_io.c => swap_io.c} (90%)

-- 
2.52.0


