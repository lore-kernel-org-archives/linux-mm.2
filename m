Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9575DC88E67
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 05:15:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75E9C6B0088; Mon, 14 Sep 2026 01:15:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70F966B008C; Mon, 14 Sep 2026 01:15:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 625286B0092; Mon, 14 Sep 2026 01:15:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 37C136B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 01:15:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 963CCA1078
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 05:15:45 +0000 (UTC)
X-FDA: 85211205450.19.9FA9583
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2B19A20003
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 05:15:44 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SIoY0t5E;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789362944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GUDBwHEEq7TXUANzZfGT2Bt6VxcKoDJkKvK4JgFLejE=;
	b=khff8G/PlBhM37LZZ0tRUOiqbbW/Y7/BV28JDSilNghEPlnKXlYqw1DAjfGq40LWDWoaZ6
	Jg8Id7xwfmzEaURD2raTYNRK8m1G4IvIluWUP2ioqj+X7x+P/GhGGYC5qgF+PZVQTuB3ya
	tnsxT/q2ffBxnf+upMxnmTLPa6dPZNA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789362944;
	b=YimXAgLsHr/ocewHfVoY9jyUNfm0C4vBR6SKRZE2Tr6UNeHOFv+dBrIjdFdmxAEC0zyPsC
	AQT4rRJ+s0Q2Dr64CsswMz1DdkzyTQsCu+BLJBBXgrAWOmK19Y58Pi5ykuasb6CAPO7vm8
	/6aharbYcOHOvkGE89Ddvi80lXyHcBc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SIoY0t5E;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 422AB61398;
	Mon, 14 Sep 2026 05:15:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CF61F000FF;
	Mon, 14 Sep 2026 05:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789362943;
	bh=GUDBwHEEq7TXUANzZfGT2Bt6VxcKoDJkKvK4JgFLejE=;
	h=From:To:Cc:Subject:Date;
	b=SIoY0t5EzeuOkLvjtAI9DpiOH9foAsEuv9DTc0qYR5BDO1OV/wd0/VbmqSy2Vdhdp
	 /7e+ueiyud+pXuWZDJNoTCWV7nFAhypxY2SJ1TI4e6cM1yZ5ymmsnUIhfKGJ4mci1a
	 7CvIJwB5MPf6Xm8lgC/xTaN6aqouZu7bHV3EV4asRP25wQ2k+vtZPOgD0FY+L5pDwg
	 qARStT88+ooiNtlsaiCHA7gXJ/EEOA/qn55XAgKnjU0olnZYxKN1nUts2XqosOq87O
	 GSYAXWVIp8CFO5C4oELu2GZrswwYoKe/n4B8XIZ4KwgxLWuR5J7FHoM/EikXd5abVa
	 nep++2t735iZg==
From: Mike Rapoport <rppt@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [GIT PULL] memblock: fix for regions display in debugfs and MAINTAINERS update
Date: Mon, 14 Sep 2026 08:15:32 +0300
Message-ID: <20260914051534.4085114-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2B19A20003
X-Stat-Signature: i4od9u6z1ysqsm3uyynj6xqgmugkgyrf
X-Rspam-User: 
X-HE-Tag: 1789362944-234380
X-HE-Meta: U2FsdGVkX1/uXYQKbvtHbuYV8/a9n5D5g0ZdB9GvuAaL82Ow/NuXd43yurCxDdVHuO/9eKX7srJBw8RMue/9APq/mPpcwkJ2hVSafwstZYNX9lBSitoNJl5Iaku9l7kptklTtWBIRMkeYcZBJTR9tS5JxcVM+bzq82ZAZoI/BniJ+4+WRiTqwpNXMYhZTpl9mrUhmobCJ+S1w9keN1TD+3c8pf/OSCtB4dji1V96bgFz+s/VPz1OlKHphRw+VXEOk0MbI6pYITVEvh1YrSxvi4mvq26yuT8mREIISTlz2mfJMs4LmqS/fYSgeVtFt4Pb+8HfpYWxeM2ngZWL0QIciPHuk+ZtAG3+qhqtiiS+3ziWpa+Ttw35dmXTtEMTKQnnjw7GpIAd9nFlnzlwcaVU3sL067w5SDtnyb81kfwyKATo1ARpBlVZpMZh/HaMkwgWpbA7hLCXDKqCRXEcir20JKWyHRQ4I957lh5QqaWdZDlSOh+yJtsBKWa2afFICWTop4BB2rbsB9/GdX0YkyKKY1UFgGvZgUGZGUEJIY0Kr0TPRwZkswBNO+BBTtsXJ/sNaFctT2D+ZcfUCe9uZy2NVHPYzdal1dgBzCwfspQ7S72VnkszJhiIwJgFhthfGQ6M7YmnHLOlTxqe7SIaWTWpbCdXUdZmc6CsdbWduA+q1T0w6HFYe5C3Nc3LIWwaM/qYXRaIS6D/7BixNXYwXq6IHPeGBdGjjyfn4xmImggSqySg+b0MaBAeDcc6ZgdEQpoj/6VyUlvDptQXWy1PsrdoOGzW+vvFvDFMDKLwc/QXz7dXTomKr/cRELKDxrk50r8JKCphhL1SXlSPuz3Sc+kNJj8lpykqf5xYCc/Tb8pNW4II3Pcm2KG93IPTq+DXRBdROTVwDQkkxI8RvPXkazk4i0dq6i11FS9dckZ4MXZn2VAj7Urfu4y2fiswHXFhXuaJ129lJbg2rMbgqY2TVQm
 YpsAplnY
 h/p2GYCn4Puaxd+YsLQGEdJkPQbcLQOhHGBXU3EpcIvr8rw0y75aFGTvsTjh/h8N2prKWOrntqemKbnL3WINhuokpuzIRl44IGarsdoiJ56apZ0wbyf3XyoR744h0teDjmRoBgHxxrC5Ukn7yHrU8vbhLr41B+ks17M5p+GrR0d2O7Y9KCP90jMizCF63E/NcvbJ8zV9zL17dDX6v9Hnbabn2DfYz5ntSRHMkp2+13e3nLvk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

The following changes since commit cee9395acd8043be0644b25c34bfa86623f2b935:

  Linux 7.3-rc1 (2026-08-30 13:34:40 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mm/memblock tags/fixes-2026-09-14

for you to fetch changes up to 6e33dc90df108c76899dc544a42d17adcba61668:

  MAINTAINERS: update memblock tree URLs (2026-09-09 20:28:14 +0300)

----------------------------------------------------------------
memblock: fix for regions display in debugfs and MAINTAINERS update

* Make sure that multiple flags on a memblock region are all displayed in
debugfs

* Update memblock tree tags in MAINTAINERS

----------------------------------------------------------------
Meijing Zhao (1):
      mm: memblock: show all region flags in debugfs

Mike Rapoport (Microsoft) (1):
      MAINTAINERS: update memblock tree URLs

 MAINTAINERS   |  4 ++--
 mm/memblock.c | 18 +++++++++++-------
 2 files changed, 13 insertions(+), 9 deletions(-)


