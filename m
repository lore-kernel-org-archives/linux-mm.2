Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2DFFCCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 13:42:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C81F8E0010; Fri,  3 Oct 2025 09:42:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 104288E0005; Fri,  3 Oct 2025 09:42:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE6EE8E0010; Fri,  3 Oct 2025 09:42:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D6C9C8E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:42:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9A04713BC06
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:42:42 +0000 (UTC)
X-FDA: 83956918164.15.7943817
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id D70011C0004
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:42:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ebtyc4pZ;
	spf=pass (imf21.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759498960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xfXtIfWkcf4xqLvnSN5itUWF/K16TMTPz0JBNVG+WgY=;
	b=0UbJN7stczDAqhvmv6x+u+Z8ZZmmN6sfESJ61aoEjWkt4ugH3bVahIoZLBjliYuuqyVd9z
	VZO2W95i4+r+FEXUxSmh06xYsL18+UHo5THx0SwTeAD8kbY5qcsPb7KJWAX/hZlERiRURR
	P2IvasahX1/2cxaH5eXgzYks5hmWLL8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759498961; a=rsa-sha256;
	cv=none;
	b=UpeE+2yrZnUzfyzP1+uzY2AJpB9wA2Uwhc/PD2YccipVuUEwon3EMLgnosmPhUyvhOIWNf
	Ap//nXyvz1vrWGf6INUQ56m2J87cGYHffXiIkCJ+/nBUPh59Tx4ARBDbsd9ndJagSk+/Zr
	+DCG0Dek/VC/4q9FHSNYhF6DKIyY5VM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ebtyc4pZ;
	spf=pass (imf21.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759498960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xfXtIfWkcf4xqLvnSN5itUWF/K16TMTPz0JBNVG+WgY=;
	b=Ebtyc4pZ01Pb40/yylQv/fb4tIiebyzjBJrVZ5ikbzNCaosBII5BFnAljtohxc94UK1y4s
	s0QrLEIvZG3PvhUZfymuRMesUJWgtm7xkrD+ioKP8RcKy34Xh56EjXW+CPY+sQLEnD0oVD
	dzMeSLfqVuecVFgv2QTRsFKvgolB8ZA=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-634-6BpUaV_fOEO8LMYSqWcAgw-1; Fri,
 03 Oct 2025 09:42:34 -0400
X-MC-Unique: 6BpUaV_fOEO8LMYSqWcAgw-1
X-Mimecast-MFC-AGG-ID: 6BpUaV_fOEO8LMYSqWcAgw_1759498953
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 971C819560B0;
	Fri,  3 Oct 2025 13:42:32 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.64.54])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E0B7C19560B8;
	Fri,  3 Oct 2025 13:42:30 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	hch@infradead.org,
	djwong@kernel.org,
	willy@infradead.org,
	brauner@kernel.org
Subject: [PATCH v5 0/7] iomap: zero range folio batch support
Date: Fri,  3 Oct 2025 09:46:34 -0400
Message-ID: <20251003134642.604736-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D70011C0004
X-Stat-Signature: f5d6f9o9xcwoytau4r75fjirgbomths9
X-Rspam-User: 
X-HE-Tag: 1759498960-550300
X-HE-Meta: U2FsdGVkX18h4eRFyNy0sbAUHyaUVFQQbmR5H8yzpuu45a8zC7fPgL2/9FOGZOjYXxqEY33ypTKzVxwRenBLe9blJZgccZa3iuMpN2PyR7bQR4ImxOi4qRA97xfSNUAIITNsudvVD9OionOB7dK5dzv7S26i4mTVX0AI/BMuFn/Pp2NDPeN+NRAJWvCrJkYbRdUvQY/1ynSRvHT092gKBjqUETBKqVJ/EZzQrUgGratl/7qdU2324rUt98ZlaNQ5Ou6ExKgWDgTNAP6XuU+xXnAjGFRt3gbAW0ZAI2x9xBosnRmJKsF/PAeUeWlMgm9l+7XmuuX8elabWhbLgiZH0lSuOU3U7jYmRHvoRE9NxMR84oW0A3yMU+cPdIY2f641Z3TRRC5RgNORS1cWcecIJJpR7AHtmoiuwx9IUYerf2LnARNGT5Qac89cDS47uSxZ6GZcNaTjwMMYiwG0NTkO6R+ENig00FRQwkQVdd5vgORm/dk1/3aOctSzUM6UNLtnAs/SgDZS7sF0DkuEsXxKDS47Ozej9BIP85R7prdLxPy6bIVusQITj5wlehZmvPYEFg93LoQ2gQfCn+FxdEnb0qq8onp6twaRACIeYoVWO2/6qMzuq/RroX7hOl9Q7gYT3mVonUsvZkhUS7xWk+NSCkaqcNA/nJdU5T5nw5KFr4kEQGfFTXvLG0yKHTcYkdBS//jQgEwb2P59eOfpFafZv3SCsIVdDPWxAVq8e70GI2XuABKq+6cyhIlNz3rnsW4sBJ2gN43e3/LAmNQ9XNOGapcAbuQ8vtfOeIhCzh9WHY0INUjboNLOcZQRNedTyCxQHwSzabWwTp/J7PTEgycyn1c20BEO1jWSi6+nMCZtPOJ6Np4xbr2pHMZWjbSoh3zt6Vof3DkskR8N9YPajtkpi3Vmccin1v3w6yR7/sKPi4mM50+yoav0TT/3sTj0UpJBI4VPN0eOV1LZOui6fv6
 nGQlWlcU
 USvR/Cqn59/MggfYRmRFyYzidkKPAo0cD6GvLtWdplO95f+lCTaPBdOOnOAYjWnGpSr6c112jTrU7fv2cWzFdMcbwbJV40DlcIAwQbc0BqlGXz51TpbeSGT8poiWLa46PJx/PvO3Rw9bRnnj/eM1vlNmEDc9wHCaVvn2E6BUzPvBt1goCU8AYP6wfb6hX6fqlTimjTbmf64yo2uNWKVFVomjkduM7pdR4BIX06CsP6CDPl20+GYXJZ5LgHfnBTg/FjAvLrjVeHPVh/1W9qgaBtUd795oiNNJLaFSaPDcPIb7vDG+Rwz3Uu+KyQlljvBtIOFUhz4kiyAL2ZDCLdcvyVe9/NHrEvpHGwWqd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

Only minor changes in v5 to the XFS errortag patch. I've kept the R-b
tags because the fundamental logic is the same, but the errortag
mechanism has been reworked and so that one needed a rebase (which turns
out much simpler). A second look certainly couldn't hurt, but otherwise
the associated fstest still works as expected.

Note that the force zeroing fstests test has since been merged as
xfs/131. Otherwise I still have some followup patches to this work re:
the ext4 on iomap work, but it would be nice to move this along before
getting too far ahead with that.

Brian

--- Original cover letter ---

Hi all,

Here's a first real v1 of folio batch support for iomap. This initially
only targets zero range, the use case being zeroing of dirty folios over
unwritten mappings. There is potential to support other operations in
the future: iomap seek data/hole has similar raciness issues as zero
range, the prospect of using this for buffered write has been raised for
granular locking purposes, etc.

The one major caveat with this zero range implementation is that it
doesn't look at iomap_folio_state to determine whether to zero a
sub-folio portion of the folio. Instead it just relies on whether the
folio was dirty or not. This means that spurious zeroing of unwritten
ranges is possible if a folio is dirty but the target range includes a
subrange that is not.

The reasoning is that this is essentially a complexity tradeoff. The
current use cases for iomap_zero_range() are limited mostly to partial
block zeroing scenarios. It's relatively harmless to zero an unwritten
block (i.e. not a correctness issue), and this is something that
filesystems have done in the past without much notice or issue. The
advantage is less code and this makes it a little easier to use a
filemap lookup function for the batch rather than open coding more logic
in iomap. That said, this can probably be enhanced to look at ifs in the
future if the use case expands and/or other operations justify it.

WRT testing, I've tested with and without a local hack to redirect
fallocate zero range calls to iomap_zero_range() in XFS. This helps test
beyond the partial block/folio use case, i.e. to cover boundary
conditions like full folio batch handling, etc. I recently added patch 7
in spirit of that, which turns this logic into an XFS errortag. Further
comments on that are inline with patch 7.

Thoughts, reviews, flames appreciated.

Brian

v5:
- Rebased across XFS errortag mechanism rework.
v4: https://lore.kernel.org/linux-fsdevel/20250807144711.564137-1-bfoster@redhat.com/
- Update commit log description in patch 3.
- Added remaining R-b tags.
v3: https://lore.kernel.org/linux-fsdevel/20250714204122.349582-1-bfoster@redhat.com/
- Update commit log description in patch 2.
- Improve comments in patch 7.
v2: https://lore.kernel.org/linux-fsdevel/20250714132059.288129-1-bfoster@redhat.com/
- Move filemap patch to top. Add some comments and drop export.
- Drop unnecessary BUG_ON()s from iomap_write_begin() instead of moving.
- Added folio mapping check to batch codepath, improved comments.
v1: https://lore.kernel.org/linux-fsdevel/20250605173357.579720-1-bfoster@redhat.com/
- Dropped most prep patches from previous version (merged separately).
- Reworked dirty folio lookup to use find_get_entry() loop (new patch
  for filemap helper).
- Misc. bug fixes, code cleanups, comments, etc.
- Added (RFC) prospective patch for wider zero range test coverage.
RFCv2: https://lore.kernel.org/linux-fsdevel/20241213150528.1003662-1-bfoster@redhat.com/
- Port onto incremental advance, drop patch 1 from RFCv1.
- Moved batch into iomap_iter, dynamically allocate and drop flag.
- Tweak XFS patch to always trim zero range on EOF boundary.
RFCv1: https://lore.kernel.org/linux-fsdevel/20241119154656.774395-1-bfoster@redhat.com/

Brian Foster (7):
  filemap: add helper to look up dirty folios in a range
  iomap: remove pos+len BUG_ON() to after folio lookup
  iomap: optional zero range dirty folio processing
  xfs: always trim mapping to requested range for zero range
  xfs: fill dirty folios on zero range of unwritten mappings
  iomap: remove old partial eof zeroing optimization
  xfs: error tag to force zeroing on debug kernels

 fs/iomap/buffered-io.c       | 117 +++++++++++++++++++++++++----------
 fs/iomap/iter.c              |   6 ++
 fs/xfs/libxfs/xfs_errortag.h |   6 +-
 fs/xfs/xfs_file.c            |  29 ++++++---
 fs/xfs/xfs_iomap.c           |  38 +++++++++---
 include/linux/iomap.h        |   4 ++
 include/linux/pagemap.h      |   2 +
 mm/filemap.c                 |  58 +++++++++++++++++
 8 files changed, 210 insertions(+), 50 deletions(-)

-- 
2.51.0


