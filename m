Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E620FF8862
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 10:36:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9370D6B0088; Mon, 27 Apr 2026 06:36:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90E086B008A; Mon, 27 Apr 2026 06:36:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84BEA6B008C; Mon, 27 Apr 2026 06:36:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75D476B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 06:36:00 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C8140120132
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:35:59 +0000 (UTC)
X-FDA: 84703980438.13.5A9EC34
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf18.hostedemail.com (Postfix) with ESMTP id 95F211C0007
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:35:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OtZhLIsU;
	spf=pass (imf18.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777286157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VSBwWjEGYN+Y/wP1ZGlGUpmkmo77T53zItImG6IG7Mk=;
	b=NsUPDSRc59wOsSwkHzTKswIXuVjkHtPn+vRAqJW/7ZRSef4Yb0NN9+i8Lbp4+a6mXWFq4M
	fWEPNyzOrDNj0I/mhRaYF3JWznaqRHfU4+1TUTNYMoi0ggoJuyhGUSTJFlxzze9MimoBVH
	ycD0qLg0VrTfndyrB3gISjGpJWxw6Mk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OtZhLIsU;
	spf=pass (imf18.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777286158; a=rsa-sha256;
	cv=none;
	b=8Xz6HTKuTTyhBbnqkgs/trFaIqPQxrLT55N3oqzImMq78DmiacacfBKYECl7AInfXYCeAU
	T4xHfQi9PIMC8LRP3D07I9czTohnjelhiXVT9/hPtOI2Q9CXz2vcg6J1z6qKe4f4GHe0nA
	ufOaaIEsf7YcOcrqbv3aVYmqCqZ2c4E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777286157; x=1808822157;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=V8Omf1BCEwp9Lq315j6KjBJnKwAXB6E/0iqdcrGrfJE=;
  b=OtZhLIsU81fohWzfp6N7ND1bCLdlpLjCiTXAI8cpjWMtZJIA2oP3oBE0
   vAZlTe2VStdiY5aDhNOjaEe0Lebiohae/2uK7Pvy+PPh9OTzLvOpYpFf/
   CRawzzXXpkMAqS3eYVlQvL7d3zYw0rPIiwKLdpOeydU86vt8SiazxtJfZ
   ZizFXlhsa7qdtc8vJ9F010ouD2A370ap7prNfKM5M1BLRQCtKtLMa2tjM
   Hx1oLABXvkR3PrTYAvMyGVbshGnSESmXVv2NBYS/Gc/qXOgXs1o86FqYY
   9O4oDGRNLMhNvIy5m9ESyXPLvRnLtkt0I8TZfsD+pOrFbnOeZ2VqPP2id
   g==;
X-CSE-ConnectionGUID: XJMslmJBTlambWSRPRTdAg==
X-CSE-MsgGUID: P0j5HeVsQKanWU0LLnkCDw==
X-IronPort-AV: E=McAfee;i="6800,10657,11768"; a="100826034"
X-IronPort-AV: E=Sophos;i="6.23,201,1770624000"; 
   d="scan'208";a="100826034"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2026 03:35:55 -0700
X-CSE-ConnectionGUID: x0J3iKZQS0Kd9ijvLEpTBg==
X-CSE-MsgGUID: haAKQJ1ZSueUDO0iE/PuBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,201,1770624000"; 
   d="scan'208";a="264017003"
Received: from egrumbac-mobl6.ger.corp.intel.com (HELO fedora) ([10.245.244.36])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2026 03:35:52 -0700
From: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
To: intel-xe@lists.freedesktop.org
Cc: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Brian Geffon <bgeffon@google.com>,
	Steven Barrett <steven@liquorix.net>,
	Oleksandr Natalenko <oleksandr@natalenko.name>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/1] Fix halted scanning of swap-cache folios
Date: Mon, 27 Apr 2026 12:35:31 +0200
Message-ID: <20260427103532.5623-1-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hp3tiooqg5wpmakpmy6ghyuam1n5nsru
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 95F211C0007
X-Rspam-User: 
X-HE-Tag: 1777286156-713859
X-HE-Meta: U2FsdGVkX1/ETyc7QKGVg7zSZRWLCMQ2e/nwcgLBuhT55FTWya4h9gQCUUVe5EwXENTtOAEWda79mnfC3h1HET2Wz0VgWbs51LmhdgRAZTg5cf/TNjBCwIZAl2cEo+i8UAf31Gd6RR2g/6iwJw+XVHt6usUgraOUH9xe7y9bCCZfgjAX7f7CwhiFf4+DNNDzj0BJkTezr1vo2+XoubsOVVaSvuYhrnvxMJjTB1n8ivkXBLQX4s8zEuX9cpbf97uj9ZzC5T/4EgALy3aJpnqQc5hYCwgrHScs3usYDcSP+9araZDyX5/7bU5R0ghBu0WSbPkEC1QwJ/ITXcwDwYIMzTycb0Iqu9asq5QfkRocHkcuaGFITElOv+UyuIkfAU3DNU8an82c88EbmL61NZIw/77ULNCVFwZHWpyKi4sruccwpDuDhYaQ2sEv2iT/oqDWpxYsvyYsGGCsNhn0ZkyqsoymEzmkftu+n+tpDsGe9G2jVw308zzTkDq4j+4/STV5RTvtbEEUvxInK+plazpY6bR3k4YqvOHNM67BbXk9eQepIYF2pqSWyjTs42ammYeb4eiL/ui/0CznhBRx1uVHVP8fSeBDlPj5CEOOkUKIGfV3SwFlUZu7LnbAmOyveW7lCaDeXdQ+SFIhP89ajpc4xa1QWr2f2TZMU4PoPEOZLWq3Bw7YaIZb3vnNempO1g2Lk0PY9CKJ/wmNyIHX7O1/R5zcvXt+Nv9Oou48TwtNlCSg/GfvqcWHGfTTOTLq4EiPcX2XP+FOo2TcEPEWWS2scZzwfwK+Bgs0rz881bU/sN0aE+1b0RvMpO7qBiUkceXbu9aRWmeEbO3HT6/26WuoARlbUvLfB2xDvdcukTxHbp4DbUjJ/x82Rq8SzTdRAKs4wEKlZQICFmdXPyKCLrhLW6umAqvrTEDlEdAYkARzyyrTv47ur/PzLEWJVP/Xjap+w+p6qJbGca81pDrL82O
 meUiYEKc
 NoKAEdv34stNiJ93+TbTSgYqujjJDbElLE6CTGueBJeIp7ifS1QIidg1cL8lm4fdnxR4w/IpLtqhla5E4LVOQU+Upe3DzLa2R0MMulNDNFdK0DUE1L7dUAF2sKuNEjzuZ2aga1Qg0c5nw9CgIMkhfxpvorM+TW7IDG+NM/VoUNoAPDhvgoBgBjbrpt+Jn2RWbWZLoVg8grs8+hn7hYaJ0y3APYDACbd/fGTvXEXht+sAybJVaXCKi1tBGWbmiq+Ptc5qXxe3qKSG8igTDqZd8UsfleOUu2sK1NpUSoJ+ef/r5azjoIqkVPuCrAQ/Plhj+/oBD6m6dTvC01S3A+kJ1Uwnlei0OxPQUGeDH/OWHCak+KeI6ncziwQNudZXiXj5O4QH/mruVYbAK0Xv8zTnZsoxKgLCvhzOz/Ep1fB3yJeIk2H4+0HoVyVY3wjjB2uLpXCF2vABbkPFZwepVR3nDNbjcgvA8YbXXvDt5PcXpHXTxiuE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While experimenting with an interface for inserting isolated dirty
GPU folios directly into the swap-cache for backup, I noticed that
when the number of swap entries were almost exhausted, scanning
and freeing of these pages already inserted into the swapc-cache
stopped.

Apparently there are guards that stop LRU scanning of anonymous
pages when the number of free swap entries are low. However that
also blocks pages already present in the swap cache from being
scanned and freed.

Not sure whether that is intentional, but anyway I'm sending
a patch that implements one (crude) way of fixing the problem.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Steven Barrett <steven@liquorix.net>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org

Thomas Hellström (1):
  mm: vmscan: keep anon scanning enabled when swapcache folios are
    present

 mm/vmscan.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

-- 
2.53.0


