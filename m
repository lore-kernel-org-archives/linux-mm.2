Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8055C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:42:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F5636B0088; Mon, 29 Jun 2026 10:42:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A5FF6B0093; Mon, 29 Jun 2026 10:42:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E3B06B00D0; Mon, 29 Jun 2026 10:42:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 41AFA6B0088
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:42:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AA6D7C04E0
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:35 +0000 (UTC)
X-FDA: 84933216270.30.F716B2C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id 58710140014
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=S8qxdq8R;
	spf=pass (imf09.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744154;
	b=C9EeDsHXOSWR/ZykRqqqP/Y/puzNOabBofoAEvvLmeKZ+uNX7pFaBkHoQqBRwFb6SHhmSo
	taQt/JI1Zj5RpO2VF6JZ3+Y3VLVuJRcPctOg788U5HMMIKdvmb0VXBTmExiWcWvvotSZr5
	OizaP4nHDZNkcyXyR3a7L6qtlZQ5QbM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XJ7xvo2RfbdBOM9gsfFbrChju/6a9W7DWo0XqxsCnck=;
	b=1AOwIb3gHpbfj9XeG5SGAAyjQvPvhEOgaf0G4RLrAD7vkg3MHrW7LbZOnwbLb1Qcsvkdh5
	I64H31si5Q3rAd2YHMibDAVgISH2Cf9H8ALfhihiEmpDfNxpINGQvFFLhv/pre/CnYd4sv
	xS7yCtdnu3ZupuIfCASJlbWb0xt+BjY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=S8qxdq8R;
	spf=pass (imf09.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=XJ7xvo2RfbdBOM9gsfFbrChju/6a9W7DWo0XqxsCnck=; b=S8qxdq8RaMoHIiFpiPVc0r3L3t
	vfmxxEBL13W8ki1NyW57D52gxf4hlpzSgHMATMuFsZD1120LOyildx6lNt7j49zqFEiKkXvdSv4Dn
	Hpje3vcvIP+lieHNyNQYR03VKRpdMrEF2XWXx4GgTZ+AZb445gMj1AMXmnH55pf1ZYga49CTBqffv
	pMP/8j/2OojKVqEPJjz7JWPxNu3wlEwDvAYOD22y/tEnMaLf57Sx3WmkqhFNdWAUnKM31sl2wsiv7
	eX+b+eLpHhj84vAsWXXirty4Hb48DVpqTtOV7CFG/uFbMI3dHBTLiQB5/JTTgRlBCRRtT6/ONLtDj
	HNtSEyTQ==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weDBw-0000000EuWJ-14Kz;
	Mon, 29 Jun 2026 14:42:32 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH 00/18] maple_tree: lock checking and clean ups
Date: Mon, 29 Jun 2026 10:41:27 -0400
Message-ID: <20260629144145.1572283-1-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 58710140014
X-Stat-Signature: are9is7rn9hnsmjjzxacmng9t9dyiuwi
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782744153-817783
X-HE-Meta: U2FsdGVkX18NLY7wkOTlV0swBcM6SgtcoWATwacEmI6ES5dX2WZ36QZYAA7ECDR+kYZDGIcH0tkAmav7sJW0z1vOk9c/QdFPBfHxpD4IHLGG2Y+0JbFbNzm64UA1yRJwQoIDiUEZwrg4Q076quCH3/42dwpJ3lgeDF3DeCM5yMgla8Ac9idCguvxEAFbQPtxDbJrxfQmUmkwxbYYI2oPbGok/NxJ52ob2xOYtmnsiQoaBqWbNmN7uGXoxKpFX6Y55qVW3ZkAj4nqNXpS0n5++tR8wdo20i1KjfUHIftOV1Gc1hKGElWe4z/gey41FQU3MbMnOYxKr6bLbU4aynP9TKhwAbXRxoUsizyILPuAvZQbRcaYH7r2LHLwr1cC0bKVHi3lZRvfCQjE06n57swj6yTVGDIQ3vuV6JcE1ekGIfeC18JRUxtmvcTP9g+G3wCLplab94Kq/onXG/+MpVssLn/7TJbwcXxIF31I1x+jqyo4D/GjsGhe5X1fOwArE1NjbjNrSe34KX1SKXeGpO5zb3I7xku8QHJrrwe0hw7FFCXVKHwq35FMPJUDOxyn6TMJuxA0JwiIwjWGQ/x5TlEPBwWCMVUiuOHf4c/6M5CxklxT69W+RiiGag9PIvcKWYTOXooO0lP5x3gHQV3pY4HOUj13yYKMT1qGJCHfUUts/d0344m80B/F/7jntb2H4/kW9vn0J9Nb/sUbw2de78g0gy4DOTrHibg6Y12Z92nOJmpxgkKzy/uuQJNCXWrMfMd+y226Uq3IMzAg8XeDvu9J5sQh7pa04D04CE2oleXF0IVbzYV0XPAFciRr6EG49lt12qbpQBk4iPWcTumngXPEgWK1sVLXtJlQFWjuYmf9yQEn7p8aEzSl0QzPWcjutqNjTbq43eJbuVXomtIt/tT/eD8WjGLeScd4iw1WijKrCD27QZP6x9xirZZeO1g2C2MmhARxbTiWg6EuDJSiRzJ
 nm4SKBAE
 UUDx7okJWdyF96FNlOqJm9VecFyL0lazdsVMsW6xckMlQNgQpZaBb7E82fuaCxYr45IIeyhSU9x+A9Dx4eQu2hGzamlnwl4usWXXecW74wnkmYbH4/clrrbn4M6uxVQ0sm5WuvP8CUX/QWSO7X1IF7VB9Q6UBTHolVRwOY1cJAFjYglQS1Hu43mh+IHaKgI1RvUPUlYesNd/YRQ11XQGQTQv/XcPVCz3ciQnf8heZP8IGqpvGTJIEN/scBuL9aH0Kocfo8T+R/ywcvZ2dMEJVdaUo4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The goals of this series are:
1. Lock issue detection
  A number of syzbot reports are incorrectly pointing to the mm exit as
  a source of the locking error.  The first three patches attempt to
  help users detect errors in their locking - but they still have to use
  LOCKDEP.  I guess it's still down to hope and prayers.

2. Documentation fixes
  The documentation was lacking clarity, there are updates to try and
  help the users, especially around the erase() cases.

3. Two benign issues
  The cyclic allocator may have a race, although no in-kernel user can
  hit it.
  The erase functions may cause allocation issues if used with the
  incorrect locking type, but none are present in-tree.

Beyond these goals there are some test fixes, some general speed-up
patches targeting extra work and cycles, and dropping dead code.

Liam R. Howlett (Oracle) (18):
  maple_tree: Add rcu locking check when LOCKDEP is enabled
  locking/lockdep: Add sequence counter to held_lock
  maple_tree: Add write lock checking with lockdep sequence numbers
  maple_tree: Documentation fix
  maple_tree: Drop dead code from mas_extend_spanning_null()
  maple_tree: Drop MAPLE_ALLOC_SLOTS
  maple_tree: Clarify comments on mas_nomem()
  maple_tree: Use prefetched value in mas_wr_store_type()
  maple_tree: Optimise mas_wr_node_store() when not in rcu mode
  maple_tree: micro optimisation of mas_wr_store_type()
  maple_tree: Add bulk parent set helper
  maple_tree: Catch race in mas_alloc_cyclic()
  maple_tree: Document that erase may use GFP_KERNEL for allocations
  maple_tree: WARN_ON_ONCE when allocations fail
  maple_tree: Document erase and allocations better
  maple_tree: Change two GFP flags in tests
  maple_tree: Fix argument name in header
  maple_tree: Avoid extra gap calculation

 Documentation/core-api/maple_tree.rst |  21 +-
 include/linux/lockdep.h               |   3 +
 include/linux/lockdep_types.h         |   3 +-
 include/linux/maple_tree.h            |  10 +-
 include/linux/sched.h                 |   1 +
 kernel/locking/lockdep.c              |  49 ++++-
 lib/maple_tree.c                      | 280 ++++++++++++++++++++------
 tools/testing/radix-tree/maple.c      |   4 +-
 8 files changed, 295 insertions(+), 76 deletions(-)

-- 
2.47.3


