Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6524E606D83F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 00:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bY+eryAC
Received: by kanga.kvack.org (Postfix)
	id 35DDA6B05B1; Mon,  2 Nov 2026 19:59:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33CFB6B05B3; Mon,  2 Nov 2026 19:59:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 111956B05B3; Mon,  2 Nov 2026 19:59:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D5DE86B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:59:52 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D3A28402B0
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:59:50 +0000 (UTC)
X-FDA: 85392000540.28.A7238A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3F0D4140006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:59:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bY+eryAC;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793667589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=EMQGjxX/eZN26RByAXsUy+dO4H0OBRJHaPdwIJ0/2MU=;
	b=MaWOn+LVaO6/lCAkBM0a9Q9iKoG4ChF5p1DWTKb2psvkSraGMxNtbSmwEUpghm7BeC27ty
	6hDgn3pY6rBZZVsYHtl/+1DSyYWNZTVzvmOVn2zlvOFNzH+bo2+mWHV+NpiXhTWzPbHxqv
	ZIvIJzBVnAVPjcpkln6obscjZki4Gvk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bY+eryAC;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793667589;
	b=U4cvppNWcsQvfnI++fgO6C/vuLw2mzySEw9pZJp9K9nWkK9osSLHVuY9BOkR/TuiyAVmSI
	sCbtkXcOeTXCBGBuaarb3QZhW2RbpaLCM1zRn/b5qtz+cQyFEUFCWOIkSXSwwS5/4VcsJ6
	FIgv0VwXHnLduJMjZLD9X7gM+/joXSc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6820342451;
	Tue,  3 Nov 2026 00:59:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02F71F0093A;
	Tue,  3 Nov 2026 00:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793667588;
	bh=EMQGjxX/eZN26RByAXsUy+dO4H0OBRJHaPdwIJ0/2MU=;
	h=From:To:Cc:Subject:Date;
	b=bY+eryACEl2Ju3rGWOXwGtk5MbSLvqeAcb/qqLxVlU62vEpTh2HLpsmBKL/zUq7D5
	 26Kdf1ec1fuUK7tv+vNuoWVWRK8IJj6m9hMt1xC+F7/+mISoOjVxYfDW0tIv0AKXJ3
	 b1uNohESqo56M4nLrC2IqaGCzllo+wB2zwC80cCrz32LImecIn2adQws5mExeLvcqp
	 uQaASCxnuEfnN8pTwVGNxei6Js0aAAq/peDeF7xPSHQo9y36a5PatTEb0CgXq1mAEV
	 SyItyvRN3/lyRcER08WcBak1H0eOVjP4SezxxyAcD40GweZYvfrVK1x9bDIo+v3iTU
	 Msbpvhy1aIYfA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Manuel Ebner <manuelebnerli@mailbox.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 0/8] Docs: damon: fix grammar and typos
Date: Mon,  2 Nov 2026 16:59:30 -0800
Message-ID: <20261103005940.91432-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fzx91fcwxqu9zjidrb7917obryigrrdz
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3F0D4140006
X-HE-Tag: 1793667589-379477
X-HE-Meta: U2FsdGVkX1+tJs+24YLOBVA9wYeATDHCFbB3ZPEEwzQQXssL/95Z98mkDIWjV6ctZxc1jDqvqZSVnUkLILGRcrLyJ1Q9MaXGUysa1P5aGQIU+VCzppSFB5yvBcnvOxWlnH57CE1huzb/P9etkO9RbBGuA9fIzlZY641Oca78fp4NM1vnhO7U2rpnA+p4WC+h2oKIji70c/nc5AL4vklGpbHyv9gx7G25MR7RMmW0GPm5NTzmUV3WKjFSDLVCl+/4I2RbrYlFHf8tTwHR0fWg3B4Ik42lJ633QAswfUGHsX89LgEiGb3WRYXjFTuXdmSJ7tGsg2u/OefZsJa/Wm7nCMUGwY5ay4eYRe3VXbfjFmHMdpnvQYirPBTnTftgnTPD8Quobc4Aq3PGEM7tBv3yCclyYHUhsSMczm28h+PnpmSlTxTrcWg3ksVFAGLx7A7H713GuNoFnIKZB2h/MJ+wsnLLF+Apt24ovftIeYuvF94Cn6TyLgJjHqv9R2GAcx3HZmdOfB8nSzQpOGU2Wv7xKOmhJJ8gtNtzYKEHb3SQgDOBx8MFhyf0Uy5Xd+CBivwnnttR8apgLUECZQDoVex4r4yRH2++2IiCHINww8MXDJFpP3JOR6haN5qDwaNnsSkm9pFXW65In6NdVo+W6Kx95BvqlqUd5BvBl9C+81Agp4krOdw3r1XIbxRa5EOetPTEvclkQ+AwQ+XuDZnE7vepS3NSUkV22KPpSBVK0+qDq0DxA3QLgRBeEAvPuT1AH+AxsR7U7nQ/037yDNwC5dHbfqjJiWHRrG+tu87inpyqLVhs8iNLaLQBG7Lnkbw/MFsxyxDQiJT3wOvZlutgsA7N8M1IOHQ3DwLqipkgaxrmOG1F5zgoI6hqwUd9bjk5JJXAM4swZinknLJyf24WxsHN5/8zugNvVCW0hJmGnWPMxvAWOzUnin33GP+O2P1fPij+2YLz8nqV3cF/T0Opil2
 yMgrZGS3
 iGE8lpI0AvJbBcqkIgWXwTWhZqukrgIrDsuRT6ngSTjR17BPQM3ICh/BjBm+cqQhCDgTj1x7j5XRhV5dANUEIbNjyRGnMaysbBwmCi0CmSx8Y59AAwuXwDUjtCA9cmzUT05xQyl12NWzeIZ47N7HXwKQt63UOUTkS0rOv/9cZCSRtfcKGPeYEMk22Pvr7Z+luW3jcZpG6mWZBHbWCDaPpBHGVvgxgh0W/J+uH5bLYH8kwNbXA4KfMj3e48k5q2GBCYoF+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Aveline Noir <jm5905938@gmail.com>

I was reading the DAMON docs and kept running into small grammar
mistakes and typos, so here is a series that tries to clean them up.
There is one patch per document, and nothing beyond grammar was
changed :)

Some fixes pushed lines over 80 columns, so those paragraphs are
rewrapped.  Patch 4 picks up what I think was left in lru_sort.rst
after Manuel's recent fix.

Changes from v1
- v1: https://lore.kernel.org/179301327249.2.4690198998605536207.damon-docs-grammar-0@gmail.com
- Update for Manuel's suggestions with S-b: from Manuel.
- Collect R-b: from Manuel and SJ.
- Rebase to the latest mm-new.

Aveline Noir (8):
  Docs/admin-guide/mm/damon/start: fix grammar
  Docs/admin-guide/mm/damon/stat: fix pronoun agreement
  Docs/admin-guide/mm/damon/usage: fix grammar
  Docs/admin-guide/mm/damon/lru_sort: fix remaining grammar
  Docs/mm/damon/design: fix grammar and typos
  Docs/mm/damon/api: fix verb form
  Docs/mm/damon/maintainer-profile: fix subject-verb agreement
  Docs/mm/damon/monitoring_intervals_tuning_example: fix grammar and
    typos

 .../admin-guide/mm/damon/lru_sort.rst         |  45 ++++----
 Documentation/admin-guide/mm/damon/start.rst  |  16 +--
 Documentation/admin-guide/mm/damon/stat.rst   |  12 +-
 Documentation/admin-guide/mm/damon/usage.rst  |  31 ++---
 Documentation/mm/damon/api.rst                |   2 +-
 Documentation/mm/damon/design.rst             | 108 +++++++++---------
 Documentation/mm/damon/maintainer-profile.rst |   2 +-
 .../monitoring_intervals_tuning_example.rst   |  28 ++---
 8 files changed, 123 insertions(+), 121 deletions(-)


base-commit: 05d3ad215b277a02bf20afb9b30ff2bd15e8e9c2
-- 
2.47.3

