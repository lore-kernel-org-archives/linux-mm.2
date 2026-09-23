Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82BCFC98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 04:32:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12A386B0088; Wed, 23 Sep 2026 00:32:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DB296B008A; Wed, 23 Sep 2026 00:32:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F33AA6B008C; Wed, 23 Sep 2026 00:32:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D46746B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 00:32:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5EF971C3392
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 04:32:38 +0000 (UTC)
X-FDA: 85243755996.02.4B66961
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7B4D320002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 04:32:36 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AVafkVcc;
	spf=pass (imf31.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790137956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6lrOFXGtRWnMkmmCqLGn+zoEvYV7WtEEV3tb/dg1dzg=;
	b=fQCsiYPi/JfcoPDycF7GJ47Q69ZZ7DITtMJoW1kifs8qp3wLRRktAbN0tNZneEdy3KWHAd
	0kHYO0ZKDN0Q8+3J1y01ajXJrfsJ+G3cBxJKjz0pP5MS3Hpzjuralw93Ji0fzpZ16I5wBb
	StuF7JEEvJ+XdqkUC+9Y/faUDAohtiY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790137956;
	b=cW90IY/ir2wQSuxsT1WWP6LnmnM/zO1sz3cxAmCD5zhyaNpz+8CZdFSwaeNVDvm+8jdxZR
	7GKp3YSTjbyFjroZoWTmI2BrvRyNwqeNoxCAPJhB/zJXSRmON06XtvqrKwQxP3XIU7mHMJ
	U9at1TVgCEvUl3BkW4tZwhyZQ2jT7no=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AVafkVcc;
	spf=pass (imf31.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BF1CA1655;
	Tue, 22 Sep 2026 21:32:31 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7EE8E3F86C;
	Tue, 22 Sep 2026 21:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790137955; bh=cfGeDdBc/7PspEKVwTNh0HU7/ywQqRYyVO7lq8n9E4E=;
	h=From:To:Cc:Subject:Date:From;
	b=AVafkVccv/oqCtPz4ef1y7Zons53fH6/HRvELt70+6WCLSFaR9up2j4bG6c7A0GJ+
	 LxWsp+Q/t6PNelQi/3s6xzDv4f6RT1NKsy5ZhdHluy7xZH3WpEH82mgt0R82VDco+1
	 Drocy/z2/CjoNEq3X5dSTtdh336qHOYKNA7aE91o=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Helge Deller <deller@gmx.de>,
	loongarch@lists.linux.dev,
	linux-s390@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] arch/mm: Drop similar platform overrides for pxdp_get()
Date: Wed, 23 Sep 2026 10:02:19 +0530
Message-ID: <20260923043226.331880-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 91zdib49tdcau1eos4nz4eg6jzfoch9q
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7B4D320002
X-HE-Tag: 1790137956-450227
X-HE-Meta: U2FsdGVkX18NVdpLt2c5E2CFFt8kcWpHY9/mz8pqA/cpE41v3VZF/J+4SnuMbhZkDbFJbKtKaL0m7jO3phiift9MpC+cbNSKMych6FXeur7j87Yc75A2RrFb4OrpVzZQf31b2+2VlXMU5InwiiOY2bxXifRpMW73CHdZcGreLX7WRssTnEftuiJELctUqUqt3V8gN9xGTlafh+uZ+zTI9jjScwULN9E38KB8qbVSmFAEBPpkkEzvdG1VkxSyVrGCK+MqqCcbY2yQr8bneiZ3JFYuo8R9XWHO1yYUFQ/somxEJZLReisxZclGWanAAF2LH6GF/mzgubmOQIHQb+urljSgh17zn3PZfdGGK8W6ea2UtlNfm3cWzItj4+SCgBsUSBJAzXmehuvvZn78rfAICN/YuZaNDhZf1GwjuI19jcDrL312a9fzHhx9NZNgKjAGPp+0P52u1teQWRcJCb45ZE/w3p//v90iRylvZ0ty+o+hjA8E2Wr32qKc8v3psjZwmhyeuM9F+M5kKy2oTuvxGu4EvrRiwDYoPQ0doqZGVKZ3JbcHdMBiYz/1FzUo/J1nqacy402/pHwCCJt38y50j7VutGcUx+Z+exQFA/Z6B1BTkq/j1dobid9dvnTJ33PONeYkTXZlYM1tt3Pnv0oaFyUfcpqXqYr/p6iKH2VprvsPTRwlqa556bm2iVOL6xJtUmOEu8SHdUBGFHMsRc/Z29br2K3fhv18ruwRdN2R5F7amgt/9en0ptR96nHhFTT26c/Y2Ty0Fgb2T17Kw5cFs46lzVybQ4uVCcFTPQ5dG5E3hPPJQ2tI8pvchluokbBUH+Yt37NOYvQaEZ01uLv183L44D00pWEduLtZM5f+Gpx6ceKbvActc3Aij4loGCR0e7JtjTGRLt+tI1hnwPmQ5YYujDPHck6wdcdYSZsonEU4w1H3KEhWoFB9UaaMxM1ko+3k7Ikw0I3G9iPGSX/
 yTPlewZq
 Htf+v72047cD5bodQK5sK5r8CqmQKPk/8dJv9pxhh0hqrmK+Xq0jAMloRhrQ8MGrs/qQWpB2riual4aYqgFnRnsyVZXwac41omfB+zRYreYpwisdSbc7Y2lkqlbv4GfHZ4TK4IUkyQW3HAz+RMl6tO9sZRcFszvCLtMMOoNSrxqoXQ7Lv1bjwS1hbIjTC58qGy4ikQHCm+ZyQiI0qZQT+7cM/4lucd+7hlfWI7v3IQsJNxVLkaf038xFyBoahjSwL41SiNoH+JFcNuACK9f6Va4PVzpOU87NuPmo53F5V33U4P+PIU6K5ca9My3lXXa2+h2rDzjS2hDAUQWWMIIkhgslgkCtkFkUkEYp2O3buz5Xu0M6Q241C7PNtfVARd1HrQBxBbSJG/JPH/vS24fXPkd0bajq1/8SL3BFuKKgEvNzFebzGRUUUwCK4rOdHHMoAJbO4MeN2LGW/3Ga1pFrGjMo0lHl45XRxdItISZRatdjFxRLfE2ppyE2g8B8AzDr9rKTGbexjngwrHUqbTZ8FPLce+BLf1tW3qfSTDBR7z1qK7rv+n5DaK46Oev7hn8/gKcE0LzWm9hxFTNDTT7de3xynxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are many platforms with similar pxpd_get() overrides like the generic
memory default helpers which use READ_ONCE() for reading page table entries
These overrides could be dropped safely letting their platforms fallback on
the defaults instead. Although it requires some code movement from platform
headers to avoid build failures.

This series based on v7.3-rc4 although after the following patch.

https://lore.kernel.org/linux-mm/20260918064928.793742-1-anshuman.khandual@arm.com/

Cc: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: “James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-mm@kvack.org
Cc: loongarch@lists.linux.dev
Cc: linux-s390@vger.kernel.org
Cc: linux-parisc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Anshuman Khandual (3):
  s390/mm: Drop all pxdp_get()
  loongarch/mm: Drop all pxdp_get()
  parisc/mm: Drop all pxdp_get()

 arch/loongarch/include/asm/pgtable.h | 20 ++--------------
 arch/loongarch/mm/init.c             | 19 +++++++++++++++
 arch/parisc/include/asm/pgtable.h    | 20 +---------------
 arch/parisc/mm/init.c                | 13 +++++++++++
 arch/s390/include/asm/pgtable.h      | 35 ++++------------------------
 5 files changed, 40 insertions(+), 67 deletions(-)

-- 
2.43.0


