Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D21C4CAC58E
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 02:39:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BAF76B000E; Thu, 11 Sep 2025 22:39:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06BA36B0010; Thu, 11 Sep 2025 22:39:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC38D6B0011; Thu, 11 Sep 2025 22:39:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D81196B000E
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 22:39:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3CA201DF448
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:39:53 +0000 (UTC)
X-FDA: 83879043066.10.282ADCD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id DC05B20008
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:39:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gjp2JOSR;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757644791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OxPRC0JPzK9oqtUJ2KItt4zovI4QHZE7U6KyrzIXQfY=;
	b=E692SraFI9iHG6UW4Ga4XTDNZvWxLYtp+WPP4qpFKMMDANrwR9Eeu8zQVuioSIDgvKPnQk
	0bUQhFmSznytv7Dy+uOYj1SboNqRiwsnma20m0M64rKMGvyOMOELEdLxRuidrksyBW30VA
	blkMqgAzZALvLlTXtL1r2a4KGbBCmCE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757644791; a=rsa-sha256;
	cv=none;
	b=k7vrv5WL8U4HUxG+VensO1lEsSQHlxIxSoK6XQy5I99oWyrroVfLQFkCRFfUc93R9ljoGJ
	RiThC5GYxW8V0JFmumn31GACJtPBLQJapODuyaUudAVWslCoGhSqSoFw7sTvlJFENC3QTn
	ySltPI/lwBysXCmOXa+CZMKbRZsqcEs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gjp2JOSR;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2529460147;
	Fri, 12 Sep 2025 02:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5ED9C4CEF0;
	Fri, 12 Sep 2025 02:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757644790;
	bh=yE3VMp+2UTdfVTTFqOV7Z0nyOpwlVrjxuafiWpvqlwE=;
	h=From:To:Cc:Subject:Date:From;
	b=Gjp2JOSRRHGG1CZXw+/9INztzNXz/8KDImRW0yh5Zhks9Rn2VEaug46cf/LgKim+t
	 IdkB9zeKcEuZu98IyCGoJwkNKDDVjQz0k/QZO0yt33T0SuXthd2Bqli/G7TvvSLK+Z
	 5fzwzmLEpRDpuT2MpxUpsdBQ60oL9L9oJn3nYxft0PU1T19DaIfaaFBCWSWJoTmMuN
	 YUkkraVh3TH9aG+g0WpI7SuHmtMLDZFgSkUojfd4D7GG6rjrrU2wSnxH5M9tKJEdfL
	 hheXBau+mIXeqrSVhSb3eI0tw5cy2I/qyqgvBglqy6LOH8ewK4PoD29OC4FMk/BTqd
	 uVQEADXIseP7g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/7] mm/damon: define and use DAMON initialization check function
Date: Thu, 11 Sep 2025 19:39:39 -0700
Message-Id: <20250912023946.62337-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qpuf7fzkbm11m7t7hbjd561nzun3ppas
X-Rspamd-Queue-Id: DC05B20008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757644791-452728
X-HE-Meta: U2FsdGVkX18dF8ltB6dj4zY/Mz6n1zFJiByp+qZbp1UswTixDOuUE8geGbK93aAVr8TsaDnrNKkk88nA9oskqi5YelvR+qohLKMyFCB6foANe/paG+iEy/UEpUTLBzk271uxyro9oLRXSJCCCv4hIo521EAE/WAuMYgPRpRGiwj49dMAl8KW5TGjjFmAFyjEZ79jZ9pW91LdaHYoYrMPu/YGLJxOS21VAaiZIYAjdc+pEwug1xkyCWR9IJg+A00wtt2pgWHjBmPqfV1u8Jkqioz9F5k9ytEQex8yApDJL7YfRjcaI9eJQIwlJrfMA6QdlEg9LUATAU0rxXdtkLicZkOcTXhHg2QU/QYNeJh9amAkBXQFG8WV9JuOWejtrCJy9bt9kzSxthVTD4IUz04mD3DyTgLtStRX9TOI4e3yzmTLTXz0XPO++tHtgtzRAF2YBdnuB2COriEBK9U5ygzds6hxrnHrDkJs6Da23MH9ecCkXZse3HcE1lZHmJTm8Uh4JpNRUGzAOkIB+eJhLGUI1vHWMMTr70FabLe5gLtbrAB/tkOz8mVMt8IZaTe/FuHtDFNSCEHpgTDFAObEPgEgeO31/v6nUHISv3dDcWdlVD/ilKrsY5+9ut4u9oi+1S/WOjFCr0R8l+H/OPvuQBy5xIyqr/yvai5nqgcp0KHuu0CpUXJCx6sB+Ma8v7/1P1u1TzA05npUh0O6L6Fa35rxtL5pCW7r5R3tx/AtejSLOtq+E3grb8lJSvEBNqaYd7pFNdMdKDeQZ7qphWpfNW3N5FiTAPT71u07kW8ape8VDSyFYsGKA0IB8npSQwAXXXlfqv4FEowvSzcQqmVfVb1Nbw3JO7envZy99OUuKRkMc3LjPGazrLoO9YWqhmT/ggF1s4bozWXeKvVeatz0MypRHY5tKGSzJbLJqrjbb8ToSaHHWRTtSei4zg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If DAMON is tried to be used by its API callers when it is not yet
successfully initialized, the callers could be crashed.  Such issues
actually happened and were fixed [1].  DAMON API callers are therefore
having their own hacks for seeing if it is safe to use DAMON or not.
Those built on an untreliable assumption that DAMON should be ready to
be used on module init time.  DAMON initialization could fail if
KMEM_CACHE() fails, though.  Also those are basically duplications that
make their maintenance difficult.

Make it reliable and easy to maintain, by implementing a new DAMON core
layer API function for seeing if DAMON is ready to be used or not, and
replacing the hacks of DAMON API callers with the new core layer
function.

[1] https://lore.kernel.org/20250909022238.2989-1-sj@kernel.org

SeongJae Park (7):
  mm/damon/core: implement damon_initialized() function
  mm/damon/stat: use damon_initialized()
  mm/damon/reclaim: use damon_initialized()
  mm/damon/lru_sort: use damon_initialized()
  samples/damon/wsse: use damon_initialized()
  samples/damon/prcl: use damon_initialized()
  samples/damon/mtier: use damon_initialized()

 include/linux/damon.h |  1 +
 mm/damon/core.c       | 10 ++++++++++
 mm/damon/lru_sort.c   |  9 +++++++--
 mm/damon/reclaim.c    |  9 +++++++--
 mm/damon/stat.c       | 10 ++++++----
 samples/damon/mtier.c | 11 +++++++----
 samples/damon/prcl.c  | 11 +++++++----
 samples/damon/wsse.c  | 15 +++++++++------
 8 files changed, 54 insertions(+), 22 deletions(-)


base-commit: f115189b48629e7a8aa707112190b7ccf9928d6b
-- 
2.39.5

