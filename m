Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82324C624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 03:20:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B00B6B009F; Wed,  2 Sep 2026 23:20:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 839EE6B00A1; Wed,  2 Sep 2026 23:20:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 701136B00A2; Wed,  2 Sep 2026 23:20:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 424806B009F
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 23:20:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1411C140401
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:20:40 +0000 (UTC)
X-FDA: 85170998640.04.6C1BD8C
Received: from mta1.migadu.com (out-197.mta1.migadu.com [95.215.58.197])
	by imf24.hostedemail.com (Postfix) with ESMTP id 16DB2180005
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:20:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QwwUeiRs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.197 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788405638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IbzcryuiRhqJoXacRSH4hXOD3+b71jYBe/VPgGMU8UY=;
	b=Ca3ZAwLzsO2rh2O7Of0vfM8GF6Y4FT6QIoQVFGIc3a+k7CgB2Xt5w+ScplBB7bthnwe1KZ
	HLujoDTXYFUmZmaew/gyGvCB9ZU1JpEVCXCCeJ6dGRT0an8sMAigBudMrMUJ4nqiF9k9hi
	rqqbyMYfdNlo00Det6oNmo+yr/sn+C8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QwwUeiRs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.197 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788405638;
	b=2fHZjVXgkL2eOTBhOCWp9OWDdx6b12moKrmSRgXzKroBnMX/u5Sra5qLBHPStISjJchagl
	p26tbww5CcuZXrFTySc7sCQk0VBtX93Qh4jZ9ZtPy0PSh+MCKtTWN+S+QGCv+bp4qZqqt1
	/wPaJku8ft2OADN8IeSD6UaEdok/2FA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=WriMjLytZ29spS2Jm+A0Dm4d9IUfhmOtVaV0HWcwC/c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788405635; v=1; x=1789010435;
 b=QwwUeiRsQR9RLuoRiuZOodHeOCECXgfpq2XBBwh5FLhfzgN0m4tuQksf8wtWk9wpySIIzo5b
 p4aOOjaUs9zcFxSTsfC2kxswz56ivLAT4KQNeQwtYHxuXlTexREp8hpYB2ZbjkA2sFouJ5ZzRvf
 V7IsamE3isPwgREoL83X+6JY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0634c6904f5800d5;
	Thu, 03 Sep 2026 03:20:16 +0000
X-Mizu-Trace-ID: 0634c6904f5800d5
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Chris Down <chris@chrisdown.name>,
	Tejun Heo <tj@kernel.org>,
	Yu Zhao <yuzhao@google.com>,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v3 0/2] mm/mglru: fix ineffective memory protection for non-kswapd reclaim
Date: Thu,  3 Sep 2026 11:19:50 +0800
Message-Id: <20260903031952.1120321-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a8u48kpy8m6fgpg7hw1ujs3ozjxzoz16
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 16DB2180005
X-Rspam-User: 
X-HE-Tag: 1788405637-920665
X-HE-Meta: U2FsdGVkX18QcsgM5qEUvtoKabJmz5CulHOt8X4n6o1l3M8VDSphYHtdz7a1G4R8XHExyifMmLzBdFDpxgP4XkCpFX6xvkgfsA/Xtc5ikzXj0eoFsOQuCP/HAf8hhVxn5IPYH3G8/phVfWPdDd32SEBr/512feRs7jdiVLsaLAXKn7alsFmxTNmIBGMOCFLGSVegz6V4mne7P1NZXLgnCRjdwQO7AXjLRiSnubKM6CqTIuANK4yThhnZv9B2wU2L4v1A11dmf1e5GWJnBSIY1VhcbTGY6KMDyKji0u/kfHESP/py0/9lUDmUpwSrrS7S5Qbb0owlzJiW1qTXwaRy5SbzsWW8qf8OI9kzJbe/w46zYnJLVnGEW9wggfwfVv4U7sVFNS7FSpDlmxKpZ5qXLt7vOMx+QCbC4WOaWkEdXfmLHPx3yThNAVuj5WMBCIy5gfcPcKcx23RwPVdO6HdMmqgWu+FH1STx8LgGKe6iCa24nx1K+fPEqr8PWCwAbjemdLxSZYp4O5urlF8/pq2NWE3sb4P1gi3U02/B6ePHq3ZhKhA4kv6cKOotFkWXEBV6cIrzn6vRfoVP4gFN6sctENJmu7TxjvKpWFXs4dYHYBpiIOofLQwVj5vWTLxKINr+Gc32LxQwaQCfzQMa2sQ4sanoc0mjZHVys1UvsxZSIlHBrEr3G0E8GJUcvNR0QVHjhv3ba37L/CfbrqG+69XrT6Ud5mHd3N3kX5CopUH6QRYGcmMgF/p8LTpBnBySqW7R/QEBT6UQu2S6eMgZPOTUw5BKhlUQbYgtLEeYT9/jPnaLbiYx3c80aIqmLVxMeu9XbOCatc7b4gHQtGMF3LGedBVC3kmbyIX7ejPw5e6645Nd6EKb6OIl3jnFk5OI2jJPo6e3eOpKeHzyrz5DOyauCtRatxH6giAFx3g81+Eb4N4ouDXQ1cAbzu0PsFjf9YjFKGd93GOSvt+E+qh7jAQ
 a3IC24+U
 bgw4W6hnBogr0q5CeHR9fDPs0pgIUgzdVdSjGH4j4BIzDCdZs0nJ+xnPNwTLJ/Ch5ATVytxzpDj5Lw//6SEpdtb+/BtuhCRCFp1k+Lvf+goZA9222mIOS4yUpkopeoZ6VRWCyw4x6zmRzeQbu6RPi/glYlKKfyaWK30oIgRGGa+X9hAWSn/vaq+M7X6CjCY0duh4ryJPkJX6sPVUJADiZkfVWDMZjAFkSLRN3fdlNsrFjG851NkUsDA93JhWxFh5zyOpEUv3EvZf5B1zKUZJ3X/CkhtLXZrAZ5ILkjF41j5lbGweZMTFW5uzPG5Zc0YqUG+7MUFejX6Xdr6mmtfrm3ZBoYawEaFFCatigE3eTXr1i/dHt3XHGzvTN01KBB+l7G77P1Mq700RPCHGLx+o7KK7u4+Kz9pVhpjs5e2BNjrdHGkq87tZjAZRsEpIC3bZhOraVExhYI8l5ZjaoDoXJAYq3l6DZXB/54F+zHW2fI/ETmdxM2gNhwu852TzU3asv0lm2dCG2Yfa5G/uZk4LCjR2pvqjSRlY3WYTCC43aoU0sWzVia+KA6ys8tiklLimcR8M85em+sXXqR6SiRAJAsNtRUgXdVxQeqkc14tyX2+n2u3zTZwtH1P9CpWTyM7kPH097UvMoc34S/1qaTCVahO68486tZWSAfeWgFqvYm5Px6jm9XKq6gXUYxQc8cWe6J52Na2iXjQG4lW9Y7/HgiPkLfoVa2nCCiPlZKexvcIHs6kU4qAX/0ufJPr+TsNcqqLtl7mNX7UQwD0XcEHA6jCIbQOS1dEdRBGdQzuXliv6HzU8UDyHuc3XJMa+0ANWd1nn40JdZCYCFwx7Cjq49yIY7fxOXEdXUEr50
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

For MGLRU, memory.min/low is not honored during non-kswapd global
reclaim (global direct reclaim and root-level memory.reclaim), because
these paths shrink memcgs using stale effective protection (emin/elow).

Patch 2 is the actual fix. Patch 1 is a prerequisite: an integer overflow
in effective_protection(), spotted by the sashiko review tool, which
patch 2's new caller would also be exposed to.

---

v3:
- Per Barry Song's review comments

v2:
- Fix an issue caused by non-atomic read races in patch 1 [1]

[1] https://sashiko.dev/#/patchset/20260828092432.1257917-1-ridong.chen@linux.dev?part=1

Ridong Chen (2):
  mm/page_counter: avoid integer overflow in effective_protection()
  mm/mglru: fix ineffective memory protection for non-kswapd reclaim

 include/linux/memcontrol.h | 10 +++++++++
 mm/memcontrol.c            | 45 ++++++++++++++++++++++++++++++++++++++
 mm/page_counter.c          | 19 +++++++++++-----
 mm/vmscan.c                |  8 ++++++-
 4 files changed, 75 insertions(+), 7 deletions(-)


base-commit: 32b6ef9a5d0eca44f9cd91f52f4faa89f145a0de
--
2.34.1

