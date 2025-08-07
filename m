Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAB6DC87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 14:43:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 412E68E0002; Thu,  7 Aug 2025 10:43:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C1BF8E0001; Thu,  7 Aug 2025 10:43:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B1CA8E0002; Thu,  7 Aug 2025 10:43:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 129528E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 10:43:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8CAED140F28
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:43:24 +0000 (UTC)
X-FDA: 83750229528.27.04B9292
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id D4E4818000C
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 14:43:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eSwiX6+a;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754577802; a=rsa-sha256;
	cv=none;
	b=57PI1LV6d9BIyXC2v3U3do/ka+nkKKJdnphdMnf7X+iW+jAqCF+q7fHAl7VF7lAnhRx0vW
	iLkn68Z+QgaBAUh1DE9dbkg0A9RPnaKtooInHXDdbXbprYjPr+zMx0noxEYZh2or0mdWhO
	fTVeBEoZQg2MtLLWmh1FBhpcYws/I/Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eSwiX6+a;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754577802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=72xM8cfk7cqW6yETU8RQTaHJlsVsZhPXqGL0jRvFS9s=;
	b=0V9btTsvefy5m1J+F/lgGByG0yDeRKz6Ls3KqassFKx1yo3jaGKApZZwNl3zNaeAI2w239
	7wdAjF6CyYXsafclsMIT4GHzvBOy4dd/RH5XPQfTwGF7MRL4VmoeQEHzglq2kbflXqcU1g
	o9GAn3TG/nezaL8srgvxaFX0NWYrnQY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754577801;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=72xM8cfk7cqW6yETU8RQTaHJlsVsZhPXqGL0jRvFS9s=;
	b=eSwiX6+a1ciVpkoOFyCPgFv5b458Ki0wmKMw1VoswVyg2FHRj2g71wZcVPFuNdWFZJtXaT
	t5kmFNakuZE7OnVFNcc1tjsjurSbPqM/TzkfgLJh7vdkh3sjl5VfxqCgf66vBaw34smWMi
	YEfBa8SCX9g00Yvj/nx6trSprST++5E=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-154-L9x5TAzvNrmc6sc4ftewPA-1; Thu,
 07 Aug 2025 10:43:18 -0400
X-MC-Unique: L9x5TAzvNrmc6sc4ftewPA-1
X-Mimecast-MFC-AGG-ID: L9x5TAzvNrmc6sc4ftewPA_1754577797
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 121071800292;
	Thu,  7 Aug 2025 14:43:17 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.88.68])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6FF02180035C;
	Thu,  7 Aug 2025 14:43:15 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org,
	hch@infradead.org,
	djwong@kernel.org,
	willy@infradead.org
Subject: [PATCH v4 0/7] iomap: zero range folio batch support
Date: Thu,  7 Aug 2025 10:47:03 -0400
Message-ID: <20250807144711.564137-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D4E4818000C
X-Stat-Signature: cykgrmsnub1wuff3ree8j9d3o6q6en7i
X-HE-Tag: 1754577802-724866
X-HE-Meta: U2FsdGVkX1/e0nMW+OodJyDpPj74eB2y8T6UAfEy9qyr4o7Puzx4Zto/YcENV+ZnAhcmidjmzyizhZvhE3tZNU0YxFeB6bdueWegHH7t3KvVzlzuYVC40ZHWxosbFPHYQ/doIONKIJvzXNkIOK9I9zRp4xg8VznvJ7vEjf+sHrw5vWL46/8djmyzDb0ksBWBwdKiEvVkY4hejyT9xqFYkNbWMKCbzYGTBHJFKJlyETHQks/wGcUfgVS3Tcyi7KQXIHmCQFhr/TKuizLS1KIVWXVBUD00g8Gg+VPwiQCbMgsTfgJ7dbl66NyCw8IWjZ3ZAN/DzOkShTAS18wYZlbypVi4k81GiXpZ6kYt6dYVb5ePlCkfVk+3KxWmob3nQ6u1VbVoiXaJtPZWah+1Pl0tI0MVQ62UtCmCuUs7CR6ZV00WQXWypHyGh6AtwKJMAcT1SFAqgJAqTjCWxu7ysGe44AepsVpePVVi7jRdxGjAEWdOtrLsNGA2pZGbPFuYEjtfnx0BGLlWijYIeDXGCMA6hrwQHI4Cwr3I70mufKpuBU7gjFP3OKqdIOCzji8QmtPWb1KVsAXtCdlxJ/yRzrVGcFoQ3KllLVgZ41Hd/qYgnSEyzCcZ2VH3mMzYUlLLznuwS4VeLHDu9PZMQSQYZqvJHbYnieqgNft+x0ywrOJwWO782M7nWNkHCttECE4kbvRKMIlGyoQn4Cb8RwX3cP5lo2tWCBqEWKIb0BpoXGm4JSymPXd1+Ik0d1Ea4irOkUbU7MpzU83Xoaxbn3MZcCvlouBJEiEJsSZoK/tLsVhDM5qT/wdZuT3mjgqe06gF3WpwUD3ww5lXQAOtKRjXYrPvM6x6gQnH2XRUQkE3LHKyab201TNaBkuSMaa+DxAybsiJEm06ei/MRaoLlkfO4QpU36l8fTaY3YkQ1TBFFyqank+Lux/W2KY7fogz8+G0J6ZK6sbG6+HtozM6MgBOU40
 9tojLBva
 rlOMya2M246VYc+sDgc89IeSsMYvAmVEFbEmPtQOlhTXMSdL14L5ZjLKbOxTkN7Pnu8h4Ao++EU5ceWz55QbxOLm0c4uu/9l/Jurmp296oEjFGAATNofgLcQStG+zD9PtVUq6M1UXuqq0nTEvcUGHLZUnJ1Ni//FwXEDiOR1/PPlklvu+R1BEjLA6+OgM/pU5TSp9EexXfMjucGDHw1qWOsdLaZzdpIHqsBUK3lsuGNsXqR/khwMCujj9FYOAwaQ45dQCcOHeptoiSHP5a/M/uNJp6XnZ0zlj6v2TXeBHx0M9ZD7gVUZ1TaGTRG6P2aod7/G4xyGUckDoCGE4Ig4/N6hDiZw7h7xmG9sX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

No code changes in v4. I've fixed up a commit log description and added
the remaining review tags. I've also cooked up the fstest to go with
patch 7 and will post that shortly.

Otherwise there's been some discussion on v3 with Zhang Yi about some
outstanding issues with the ext4 on iomap work that is under
development, but I think we've agreed that those things are ext4
specific and can be addressed in a followup series. So that is my plan
for next steps.

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

v4:
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
 fs/xfs/libxfs/xfs_errortag.h |   4 +-
 fs/xfs/xfs_error.c           |   3 +
 fs/xfs/xfs_file.c            |  26 ++++++--
 fs/xfs/xfs_iomap.c           |  38 +++++++++---
 include/linux/iomap.h        |   4 ++
 include/linux/pagemap.h      |   2 +
 mm/filemap.c                 |  58 +++++++++++++++++
 9 files changed, 210 insertions(+), 48 deletions(-)

-- 
2.50.1


