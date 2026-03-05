Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3B16EEF303
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 05:39:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5211C6B0089; Thu,  5 Mar 2026 00:39:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4378A6B0093; Thu,  5 Mar 2026 00:39:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C49B6B0092; Thu,  5 Mar 2026 00:39:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B99A6B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 00:39:30 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A22688BDC7
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:39:29 +0000 (UTC)
X-FDA: 84510906858.14.18B657A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 12B31140004
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:39:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Beu5N6qr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772689168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Yinq9toHf81NNPBAgtt6YAeIAVkS0SFEIUN/sZrB1/I=;
	b=toVbn1eWuv98jMe8nSi1NhKBO0+Da476KU7jbYI9u5vjNaBDQqQvAvgozbnLXZawUrN1Jf
	WngWe/lWFRKf/weYggsosY6Ox5m2tptHQYAeisjHMiJB22tkw/O9qlECfdVjsFr6RRR4RE
	jFAL9Hi0B7uI/TjQl72KPGDSoo4wjcs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Beu5N6qr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772689168; a=rsa-sha256;
	cv=none;
	b=yBLGyQvhtckSM2mXQgP9Jd2NppG7kmZGtSK8A3mQX9XF3pHAuJk+rACzUPo1uIRl82/hEx
	0v91CzUDqPyE5MxlCvxyql0Jcj3Ydu5YQ9UKU5WXiDB8DE9HKkkGeVzhHxYJjpRCOV6LAx
	T5NXvtR3KZuZs99zhdSZP5RRpknxCIM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C3023429C4;
	Thu,  5 Mar 2026 05:39:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85193C116C6;
	Thu,  5 Mar 2026 05:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772689166;
	bh=tjN9QTx9dJZVMftCXorjoS7yD/zBWFucwNvkhLpPRLc=;
	h=From:To:Cc:Subject:Date:From;
	b=Beu5N6qrZ/HlQz6IOULTQhSTu+OyQqv/v8WhrmTJ2DguF47FuJ1rA1KAUaYp9CCgK
	 Q0iTjzHlqUsmoheGCZrWXw6ogYdoigRa4/Pxt8poc5oXnlyfGiNiesvmcnTrrtuFF9
	 BDOdJcbVvnB9VSpn1esAmMdXB6Zl3veP+F0Rye0K3KZUBKdRHE4qenjSjjtv++Ec19
	 lINYHFkCspg7N4u+0l1cyAXO+SPjiEYcaKa56RO1b2QSST6csSL6gKw3mLPdi7A/fM
	 DdI4Yl5TWw7IIK9b5XUaGhNJ6x+ZwHRW1+/mZa7Gd7BviMSlYmdu3F/c9rBkQ5p+Lq
	 Z+io7O1YINVhw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yang Yingliang <yangyingliang@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/5] mm/damon: support addr_unit on default monitoring targets for modules
Date: Wed,  4 Mar 2026 21:39:12 -0800
Message-ID: <20260305053918.83786-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 12B31140004
X-Stat-Signature: 9k3oc3swwfs39op6z8qzg9grfwpz5y15
X-Rspam-User: 
X-HE-Tag: 1772689167-759939
X-HE-Meta: U2FsdGVkX1+OUGQs1SfQ1PiCp6gSX1bOSkM9tpFCt9xDD0DvuYf443NBlEGwUqFGQ65d/4KKGxzFEoElKR9cDIBAa5QgIeTagqUUw5OoLk/IK1UrQMUhIWbhctBl0uPoCYGh0f2EeT8VIClCERRf0bBnDGCQv7+mF77kS7RcpscJqe1cTb6dQth9AuR7lqI1p6oy1Zlk/Oo6MAf0Qu5oRRFi/TfZWcRmNafnsH8xSGdUMT04IXBL+G4VZBB4OY9AKTj91fZfA+ThcxOMR6nd54XTXLaXoX1lMabpASpiF4aRHmzyjLm8UcGFW7GcK6Qv8QqrM3Oi+gx0OHEJBQ3Hu4PHv5cihkwyWCgLmJM05IvAv7FqzaHJjAc7x/i992efYyFhpb/IIn9T+aFSeKI46h/J3MGKTaBKRpUpwDgJCm+UTYnwt95wBhMXf6P+yEEfs7ARPPu83KQUAZtvGFmtvDwAjyRjDPhLknOlB9MYD30yqOONqhGBZ/MjJtZIbdYUUetzJwgfl8E3jx6ryaCDv085c6BUbs+rQRwErH9NuNMTw1JIpV+OQe0o+qzVtO7juFNY+KCjpQmOK0s0/7JJOklPWKhtK3Hf26ebtjkNw6NAq2BA4CHkW8p/kPEHTGlwm6DOxTuvj+J8WuzHDc7D6pMr7LK3JAPoTL+xrBj2n97JODGNSfbU0msjNcoUn9zK/5qe4SaJPKNgqXu+Vwv5DTdAtUFD/asIG9aRcqKR/OpgI3+hZmv4FLo4p8JAzK84TQCBXkHxh/jwaKYK02gzSuupCL7Lvr7AK9BUV6sztQVjYJu206CRC/8mhCB3wcRXxVixgtaxOQ9fAGLsqmKBYC3EeXSgALwgoMzET1aGE00cL25GD0UbB+Vo23uRO/tnjh3qlfTSsBTjM5N4PF2W+4xQbGs4H8eYNKv9wQIIHtAMIZjO4eWF04AJZYwjGMj1tnDmfQyIzqdyAQtzAbT
 PecKzgLr
 PGbST/Pedl60PLPCLT3fIuOeoW8cBHrQuZ/4+h/E12co09L2n7odG4y/KoJt1gBI29GzRM8J/Yre9EgqiZg/RVilhUOItP1UQywXhz+9/tAqrLHXgjFiVIh0S/H2CCaz46iz6VHcHAZKxnZiuWhCN0fq2Yd16KJoAz0pBexXAJLNF2+0yfKE9R21mVqWpkHzcA+tZcyp1Yh93OSPcZPsQ6m7uNpo3OkKndrnloo/lQB6trk2ZUb+iebsEKHCktqBMQ9pKU2YNgwQPs76Cyi2dUNHvtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_RECLAIM and DAMON_LRU_SORT support 'addr_unit' parameters only
when the monitoring target address range is explicitly set.  This was
intentional for making the initial 'addr_unit' support change small.
Now 'addr_unit' support is being quite stabilized.  Having the corner
case of the support is only making the code inconsistent with implicit
rules, that makes it easy to confuse [1] readers.  After all, there is
no real reason to keep 'addr_unit' support incomplete.  Add the support
for the case to improve the readability and more completely support
'addr_unit'.

This series is constructed with five patches.  The first one (patch 1)
fixes a small bug that mistakenly assigns inclusive end address to open
end address, which was found from this work.  The second and third ones
(patches 2 and 3) extend the modules default monitoring target setting
functions in the core layer one by one, to support the 'addr_unit' while
making no visible changes.  The final two patches (patches 4 and 5)
update DAMON_RECLAIM and DAMON_LRU_SORT to support 'addr_unit' for the
default monitoring target address ranges, by passing the user input to
the core functions.

[1] https://lore.kernel.org/20260131015643.79158-1-sj@kernel.org

SeongJae Park (5):
  mm/damon/core: fix wrong end address assignment on walk_system_ram()
  mm/damon/core: support addr_unit on damon_find_biggest_system_ram()
  mm/damon/core: receive addr_unit on
    damon_set_region_biggest_system_ram_default()
  mm/damon/reclaim: respect addr_unit on default monitoring region setup
  mm/damon/lru_sort: respect addr_unit on default monitoring region
    setup

 include/linux/damon.h |  1 +
 mm/damon/core.c       | 36 +++++++++++++++++++++++++-----------
 mm/damon/lru_sort.c   |  7 +------
 mm/damon/reclaim.c    |  7 +------
 mm/damon/stat.c       |  2 +-
 5 files changed, 29 insertions(+), 24 deletions(-)


base-commit: c33b07ff858e4125f60a2b9e2a49f276b0d7e75a
-- 
2.47.3

