Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1B45CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 10:42:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC3896B0088; Tue, 12 May 2026 06:42:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4C246B008A; Tue, 12 May 2026 06:42:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3AF96B0093; Tue, 12 May 2026 06:42:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AEF946B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:42:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 60225120444
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:42:14 +0000 (UTC)
X-FDA: 84758428188.15.8E64BE3
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf09.hostedemail.com (Postfix) with ESMTP id 829E914000F
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:42:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="qH0KX4/d";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778582532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=g2ehNE9gEwYk4+HkxtBJsq7JvVMi5mWHz3WbHgieBuE=;
	b=VNeBMEQCBNxgBP+SmVoUzS1gfFQrsxwwI8+JHiBpGIa3Tn1lgg68oFc2hLiSsibHcfggWo
	UM+urZHFT9EzpH5S0zupkKVp7kzEcBylB4QoljuGFStqaY3BhSrV5NQWmfaUf6onf/anou
	mylCJksFAYDCyEABLmAORcNnWQF7e88=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778582532; a=rsa-sha256;
	cv=none;
	b=Lt/F4s7YNShvHWeytbyOY38SLfsN18gUVuLoPTVuqVSVPO3KKfcz479X9qI6CBi6V9S2IL
	Rdv/th1YckYLUJI2QS6SEWpLEOo6yC5gFP9jUS3qWcYyScmq8EILZQe7VmeRJ1pQ09Ji9d
	n8smU6bnSXcha7J3Jc587kLJB9sIkoA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="qH0KX4/d";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778582529;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=g2ehNE9gEwYk4+HkxtBJsq7JvVMi5mWHz3WbHgieBuE=;
	b=qH0KX4/dVPYp0SDCd6fI+E7z3Cx36QoMUdvchPbgNe+4oVHL0nFqetofyklMwfDxZEFL1c
	9AzxSYvPDdu72zP97BNr3Ab7pSmy+93c86ruQ75m/ow5z9Tf7M1GkzErckZbn+Bnvu8Nw9
	1ZMuYAOiuHUOhEny9gwUsWYuONagvJc=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	usama.arif@linux.dev,
	baohua@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [PATCH v6 0/3] mm/swap: use swap_ops to register swap device's methods
Date: Tue, 12 May 2026 18:41:58 +0800
Message-ID: <20260512104201.716213-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 829E914000F
X-Rspamd-Server: rspam04
X-Stat-Signature: mbx9c73d688ga5jbwn5uh5wmcujodowg
X-HE-Tag: 1778582532-773081
X-HE-Meta: U2FsdGVkX1+xfBK2ktBythuQpySnPIfg/YM5YzZbCD+QiWIfjHD3LQ50tuyNIYACfyO7v2vlDZINf5+bsbv+e+ptvo3iHHI5v+bg6jSyvuUNEIZ7MLJ3mgqhmFza8nBDYSUMZ6ULG6OGwuPtB0D4CUAGQyAsWyX2YphyLo0pus67NLVBZOGje4Jhyb2k/SE1xGyRJjwHJP/nkxC76Xo0RHJFAgAQdkVRg7O8y2VZdtO5o0JNdporwfW0MF/X8ZFbeT2FEzLTC5zfpe1fvQbKZQNX6Bx6lnkxiQnQZdWH+4ta2n7nazTY7pVW6CRl2GpZv0oUM5imVbplZaskDckDPOuKyyYlxKCr+zxH29IQD1QOI6yKjL8WzHyIts6VKkFNtBGDydLyG5Ak4fGz0pEyI+YDR0NEyFMSRqTEQASmEvU9W0InoZ3zwtZx96IY4YArhG77HpaMNrAZAborD+R2uWkjK1uF/H1/BvSRfF7QtPE1Dt8rKhin+z1GnLGuu/HEqw4baGs+z8iG8B11shT+8EKmgQ8Sj9r0Uwk2IoXzoFsGSM6wqGPTYAuat1GYCvf2DBuQlqsvnu0mzB3eO8QOeUAt4ew+yn+fn4ay6/i5FjIkbMgTlLICpVubpSMKXk0645y+VIeOXemExHWzO1mFXwKL2dABRyQ6tLvHYtn2kAR6iOsJShcSMmsyMJ9XM9dOc5njGw/kz9sovwaGsVgyJhZe8jFpqkcTM6CC3QXGUQr8b8ZB1ibGPRcjh5wiWkGepZgtc9JU1dZb/TDZ9Jny4txzECRaBebz3DqwRBODKoNUGGH125d/Lda1nzp5YEUGafVKJ3VjpdDHfTx7BMkJxLoFIFYbVBxPZCRl4tFqvPqfgPKWYNCBKpPQr/7pBmaF+Py9YE4L3XOEE5tHUNd5v0PlUPO4hwcN7WS7epZvHfnxp3o9k788lX68LBu9/gZQpkSCDSl36P+7kOP0ntV
 LfFNcFho
 tG1rWN+Y+PcRGbvaZv+ocEYc6M1q+aZ7iDmKd5y1hJhW/f3/t9PyX37vnZpUo2D+37ej+SIcqQT54nVvhY12/ryR+tmDnag4ZOXPQSLAOIK+hgCiE6BTeQz+b9Hod9QhN6po4b+0/rXFN+iTBB7Ke+qiWY3+4Gks5JZs9hgLufhDId2kxWww3Ce/P94/7h1UWTegqPYwKJuVVqWA41qPkyFZWpg8jEuBoyHJ4apqzW71xtm0Y3KE/Po+v85K590eEZD4M+3Yz3UuwXPSq136gEOr+pVxORjDlAMzI
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
-v6:
 * Fix a code bug Kairui found out when reviewing patch in mm/swapfile.c
   in patch 2/3. Has fixed it by moving it to appropriate place and add
   comment to explain.

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
 mm/swapfile.c               |   9 ++++
 mm/zswap.c                  |   2 +-
 7 files changed, 83 insertions(+), 50 deletions(-)
 rename mm/{page_io.c => swap_io.c} (90%)

-- 
2.52.0


