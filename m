Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20D13C55173
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 17:36:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DD5B6B0088; Sat,  1 Aug 2026 13:36:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18DDE6B0092; Sat,  1 Aug 2026 13:36:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 006996B0093; Sat,  1 Aug 2026 13:36:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D51B26B0088
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 13:36:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C937D120331
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 17:36:06 +0000 (UTC)
X-FDA: 85053403932.12.7766C98
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 58AEBC000C
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 17:36:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b7g2jA9x;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785605765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DgoWkAGslNq32y7wpqOrv1OO4q/c8+5GUJCCC3yQcNs=;
	b=wWSz+7Y8ERpjpb1QXTbuIKCjaMjX1SQdeQQRfwaQHwVotdc9RI4Pxx0NqlJqmwnfIScQRa
	mP6G5VcnhmatE270lAJmi/hG5D64abzw6FYZOf0eusOE7KAcNtTz0GkzWe7LWqPGEXffqC
	rpF/+zHN6D0qsmxfUemnwM/IbtBlL8o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785605765;
	b=iv5qi+/p4PivR9C8w2wdNIEOnLY5JyK4xOgglLnHVthFIrtlreBXZuHm6Ij7cpw5G3CZs3
	WkSbesGccTUFC2MTwps9KflCNdbuaObSqd62nN6TQ1UpwARb1oCOjPvTkmjvbQf07VDYpf
	ysz/wO+/TPd3UnJ7IybTnU159zpdPsk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b7g2jA9x;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 921B260A9C;
	Sat,  1 Aug 2026 17:36:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014F31F00AC4;
	Sat,  1 Aug 2026 17:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605764;
	bh=DgoWkAGslNq32y7wpqOrv1OO4q/c8+5GUJCCC3yQcNs=;
	h=From:To:Cc:Subject:Date;
	b=b7g2jA9xQ7iYK3VMelhLVoJeebvUY96cXG/MeGKOq/UQPEnD+NxHxwaks8lW8S2L5
	 D1pCq9LBVzmVWbPK6yaG38mkb8sC0nwLwPo/NPcB4Ep1Bm7cT50zESoWO8eAdZlPlG
	 QuyP56W0C9huQxfwO+t2XMLOSTtZyZQGQfHUTz4bDz3+mc+9OHDV9nZDKmxAXSA/ub
	 7w6VIZNttEIL3coUj9bMzlxrVjghVEfQ35ms9aNF2gpznNW0iVKoCU7l2r78v4MaBp
	 RMZwlTWxf5GHK8RqgUuZFFa9qslkg0qDhC+iJzRlN3I9lrXuaAC8llrqP0xmdNYSFL
	 sYKblaRZiNGBA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Yueyang Pan <pyyjason@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/9] mm/damon: fix DAMOS bugs in core, paddr and vaddr
Date: Sat,  1 Aug 2026 10:35:43 -0700
Message-ID: <20260801173554.94710-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 58AEBC000C
X-Stat-Signature: nr3ichjarm5aigsdmh5w8y37zmeub7gu
X-HE-Tag: 1785605765-311555
X-HE-Meta: U2FsdGVkX18vrUw6IdUWgT1y8LLb/JQK6x7FYvdKimqRbYOwPO7Htg6GGSCImHQx1Zdmxh/ZLZLLv72t+rwSIwwwPTcMW0gfRhBmmzsaoKSZbIehnz1gYUr35p49m4HaO+IxVb7CujeTI1r9cJ67yLEvgvu+BK4ScEvtvkUXMokCWus45iHNcOspLFVt+tWr0FyLfZgTAneIT9eLoxGTxSOatWxWyP+rj7lvH3gJi4NUAaDToaunM32lCH7XgLzcqXpVh1Ivy4CWVhpvpQQcEhdQDuk5RV7fd5bdjDePfLDdY/a95g7d4h4qRtc/RkqfXIrtI5nTmftAlLKbbO1g+6ynHT4BwZrnptav+3BtUESh9Qqtu1AQ0xqHmcZ8zZFvDvjoj8FjZjjgz5Y4JCVFBUvgkupESgL/01QqxO4sfAljJ4LyyJe4Bno7HwTlhaJF5jdITkzgj3MxZWx31adUSuzA/JpMAjBo6s4mTXKtS1LjVHSYr0mYycev7y5kpxYiCrVqdSftgEHJQB5wMMyxPJFT/G7fbNt5j3FzznjlfNL15TdiCPvG8YJ8lBA61GtBbUbEq7i+5qoJnwe/ae22qH8l5+RzTCP/wB0ztEwqnu+bgQZZM501U9beQnJKZlblzo+nunVLF5zfiAWmVQYW0tJZly6leGWV1NFn9grlxkqMhF94Tw81cn0/Nbb7wfg4QOhu9txUIYNQZOtVHm9BKtiRtuTtBJsQlctB/oUZE/eS/zS31a3LJ/WKp/mNYGGXvEDZ94no2YCOCiMSdhh9qiyF1GBlM4Pc7NO60/8oGntY6rdfM0biGMyk7ZXl624KgirbDphctTEHV1hiseC8qSnCugCsFfmOQtPaf5SQGJe1BVF91dHvmOHBjViOinCimC8cJAXBz8gmlyRV9YgJgvN237WDZO/Hdizkc+4t2DB9X9YewR3+LWxmNCsySHe+Tjx0zXIpLPz92pdl4Zt
 ii5T4CDD
 f96ZpvSkDigEUTt9iotRfUJIOQdywUPdQNTYW25StCNCCLIxZbLZPoCyRJ525DoHpTFtkxCWB7NiTrdBVZIKWJhv8aQj2s5sycTntLuMTknndTcmLDK8WTcNTDz0K/Bx+zPpfw3iDJjxkuE/HLIZkjx4SjfY2DrlW1FsAF7fT6iHw1VxEZVfcDRNWGOTOdUfwuSt1kqld2V1lD6I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix misc bugs of DAMOS.  Patch 1 make DAMOS less stress memory allocator
under extreme situation.  Patch 2 fixes wrong DAMOS quota auto-tuning
feedback loop start point for PSI goal.  Patches 3 and 4 fix wrong
folios walking in DAMON_PADDR.  Patches 5 and 6 fix wrong folios walking
in DAMON_VADDR.  Patches 7-9 handle extreme and unlikely memory
situations that can cause divide by zero and underflow.

All bugs are discovered by Sashiko.

The bugs are not very critical, but better to be merged sooner than
later.  Since mm.git is closed for urgent changes, I aim for 7.3-rcX.  I
will drop the RFC tag after 7.3-rc1.

SJ Park (9):
  mm/damon/core: skip applying scheme if region split for quota fails
  mm/damon/core: initialize damos_quota_goal->last_psi_total
  mm/damon/paddr: respect folio end for DAMOS_STAT
  mm/damon/paddr: respect folio end for DAMOS actions except STAT
  mm/damon/vaddr: respect folio end for DAMOS_STAT
  mm/damon/vaddr: respect folio end for DAMOS_MIGRATE_{HOT,COLD}
  mm/damon/core: handle extreme memory state in damon_get_node_mem_bp()
  mm/damon/core: handle extreme memory state in get_node_memcg_used_bp()
  mm/damon/core: handle extreme memory state in get_in_active_mem_bp()

 mm/damon/core.c  | 29 +++++++++++++++++++++++++----
 mm/damon/paddr.c |  8 ++++----
 mm/damon/vaddr.c | 10 ++++++++--
 3 files changed, 37 insertions(+), 10 deletions(-)


base-commit: 70802c13e2c9a0ab52605035e2d63b964afe6add
-- 
2.47.3

