Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CF51CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 14:29:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA0BB8E0014; Wed, 10 Sep 2025 10:29:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C51718E0003; Wed, 10 Sep 2025 10:29:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3FC48E0014; Wed, 10 Sep 2025 10:29:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9E3B58E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:29:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5EFA0BC12A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:29:30 +0000 (UTC)
X-FDA: 83873573700.04.79DACA2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id D875620005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:29:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kcYPUNok
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757514568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=c8+YJQaek3pLge0l78Tw6TCj16mFm0aeDxRrAI52bP4=;
	b=HGf4LHe0QjkfUfBd8z91AUtpol3tuKf+wO9Wdzbb7G7hID23MbtOvjI4dflI/hmOuq4E7o
	SofOKIQjADo7L7trAXZqYaQSu08uSaYAZgFvrVgxL+GEZcWJ7gDgApgDxoqQZAbx3NrTnu
	xQpqPk5uKx1VFFuMCcau+IZSf3HQEE8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757514569; a=rsa-sha256;
	cv=none;
	b=Cp7Be2+42VRy9mEshSzs5BYWDxeXrMBEL8Vd7qubqJOmd4awFghmgH3HGp8uBWHzZ7x/WC
	ykk3PTvU1W8JladgcRlvvx9XXUcVAyjzh3qiMJ5B9Ra2nBrQ2Ik2W70P7KUHGcOq2h5YBs
	hRcMaZD7AoWKyPedwcFpnnd7ZopPb04=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kcYPUNok;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=c8+YJQaek3pLge0l78Tw6TCj16mFm0aeDxRrAI52bP4=; b=kcYPUNok1BbesrKhCokr0HvlIJ
	9xe7qamka5zZWFVySkqO8i+M2Y7MvSCSjZz9y6sYyzqyhhixVgnTxrENE6pXSARHIqvxaU3MwrGlb
	YqKJHTn1zU9ojUYTYAyY8mMrgV8Q3wAHkyrCSScXu5u2d3k9kC3izJxW1yfysuqOGSwsT/xbGb30q
	rqvXSKHHCiZBURbBCQCxbdqhWuhzNVgV8XLWQHb7LSwE9c3qmjCph2+gzDpiT4MX6VbnGhmR41ztP
	JAijSGU2lWZHxfKQslpeEkIlFypuHVJHfbL0/vGD7UUW6frbkmuyJHJ+ZfvzFoAykVe/j9uvlJ9Nq
	mCxnQKUQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwLp6-0000000ALQC-0nPj;
	Wed, 10 Sep 2025 14:29:24 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org
Subject: [PATCH 0/3] Small cleanups
Date: Wed, 10 Sep 2025 15:29:16 +0100
Message-ID: <20250910142923.2465470-1-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D875620005
X-Stat-Signature: 3ourkxtcao9tsdnd78ronbjmjiaayy41
X-Rspam-User: 
X-HE-Tag: 1757514568-809869
X-HE-Meta: U2FsdGVkX1+CkFHzZOCupKP3zSzC49r9uwJP9BHcN9BNbAJmBENJ1bSC5hdqYZtResLEKem2RQ4eGM+ThfZgtKKUBa7YWSJVB5lneD/D3IcaxlSa4V9BFxv6FUzvEQNqsOD+bCitAp3uwibYAb6mAU/kjpqYPoi6voJkpxI0XptrRPaiaRQpACMXUxdJBVmSp/Pn53Pfy8Z4+uyWyKbJMmS0X/H4khnxVnP/arAqXcOHjeiujzTq97CgrZMAcT9COd1UBdF9av9+GWBgE8l6dhdnFkq4fjBSp2u0yk9pxG5vQOILL2o9yAzCKtwpN41/6pJPHSIxBqXF6AaB0b9Iajcd9tghpstb7lKQrYGcWmn2MbUqqboUigqp84HdWQz+AxpDld7pcF+6wqWy1IlVlyyOKMoQCrkeqRE1LxIKELZWHetQNVryYrWJgTiy9p+A/ExqIDz8jwBi4iulS39xcQm1ztSLnjlo9RrjiXOH8yZ0qd3ntbN5fdLHXN+Zxumom21yqDp23C+w2eNNRcEhu1+DbcTSlikm0MXnmraCMJpPBb8HHMv48aIOlcNnxNYdQM7HiHnDuaCTRFtr1InNGGZFtVIGo2wceOzm9bqdsgWbpKER8PKFBef5LLcyAi4+8cJH1dyFPlUoAtBrp2EyXnQOyxOWxgGYZQDxWiXDhaMlEvUcMvEn/sPkC/Wb9LN1Jmjl9Dgg3yojbW5J3FQ9B3dYky7zv9/4RqHTYZ6NyZ6RVeZmL8qogKhXEokqd7E5D+D2la6OPjGbpmqXZV0Z4Ctt/XwitD1K4DKYj7uYanEceEcMdw+uZOoabRJIR18FZij1PTIj005mvLYTSZyfCRGHdd01k4aecg3DHxN2/515tWDbwRItk8kQ8MqJ7oh+Q9StNe2y/xr6KvNKXFzTDNhxYnc1vcSlJB/6Gs8xLdozBfK+Kzy13CLJggzxQuRTWO7aMV2UxYp3u1qOhIu
 jqrmpyjr
 SHJkT9QV3HHrwPysmPcWZmxZ01N83B4h8z0QL9dLwq3HTNAm2BvddobXm+cQjyjLkG+C7x4j6+gMpJqXy/qOvMtTdF18YkQhusQnqECwrXkNGFhW0VYLFSUx3q2SxVzbw2bYxVGC97dEiWCUMeXm/xLtDIWMLaX+vBboT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These small cleanups can be applied now to reduce conflicts during the
next merge window.  They're all from various efforts to split struct
page from other memdescs.  Thanks to Vlastimil for the suggestion.

Matthew Wilcox (Oracle) (3):
  mm: Constify compound_order() and page_size()
  mm: Remove redundant test in validate_page_before_insert()
  mm: Remove page->order

 include/linux/mm.h       | 6 +++---
 include/linux/mm_types.h | 8 +++-----
 mm/memory.c              | 3 +--
 mm/page_alloc.c          | 4 ++--
 4 files changed, 9 insertions(+), 12 deletions(-)

-- 
2.47.2


