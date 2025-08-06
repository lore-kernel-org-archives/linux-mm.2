Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C2E1C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 00:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7EFB6B009F; Tue,  5 Aug 2025 20:10:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2F136B00A0; Tue,  5 Aug 2025 20:10:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A44776B00A1; Tue,  5 Aug 2025 20:10:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 956246B009F
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 20:10:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4F9F7B7B4A
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 00:10:55 +0000 (UTC)
X-FDA: 83744402070.27.59786A9
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5335040005
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 00:10:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="b2VGQyJ/";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=AbuodmXH;
	spf=pass (imf04.hostedemail.com: domain of boris@bur.io designates 202.12.124.158 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754439053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qNeHkb7L1un5p2eTx7uIdxYIPGuHDlQVkoD4AYWoiJ0=;
	b=liZVLOtnDfy/gRIqFa6oggHzSsxePatLDnuD/MhP2o8n10lnGmXLCmTz+zuOW7KKEWavGV
	jPNrX7n3ZyLU+kovIhqt8CWoe+1VtOB5a/Fxq53diiII4rs6bhr5WeKCZaiVUr46jRDws2
	Xq/skhX2pLRJRpaKKacCtDobcxAC8C4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="b2VGQyJ/";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=AbuodmXH;
	spf=pass (imf04.hostedemail.com: domain of boris@bur.io designates 202.12.124.158 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754439053; a=rsa-sha256;
	cv=none;
	b=0438ZZwrfGRh6MbaAcH3TzUPMg3SFSv5jNiERWBEgwwlZeYLQRllSNBA/HdRsTFHKrdipN
	TB8roN4Kbbx9M6S/LiVqq256MMPFVQPhLhDdkTIA87+LnvP7102sU5IibiR1ic/zIBMO8M
	oGaeZCJPLoZeBXC+H8pEu9TJXSb70rM=
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 1C31E7A025F;
	Tue,  5 Aug 2025 20:10:52 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 05 Aug 2025 20:10:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm1; t=1754439051; x=1754525451; bh=qNeHkb7L1un5p2eTx7uId
	xYIPGuHDlQVkoD4AYWoiJ0=; b=b2VGQyJ/0bf0SX9w19YPsGuxCZ+3+W0+Q/mWw
	1sFWJJuLiPBbPaG0GXRnwrwky0IoK9AGiyxOyuQMCCk4oqPSik5sk9HiNUkNjuJh
	ZlTW+dLHsxQbngeKWQMneLvE0uYlTEnv5idU1dKne7UW2girqgoaM/LPKaJyQ7rf
	8wlgpw6dsdEBVGvBJs3bvZRB1+hq9iITsp7uWE6HsNEGtMf3igWxxL87kREtPWNz
	4OTXgmYdB7JnLquK6MQ+dFDcqQ+wyNomrE2swadGqeozhS3OADvH0RYedORIiyir
	eZgX510VaLcnwtFYDpVeDIf58NH+J+oPNW3ByYpHvl1eV4gvQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1754439051; x=1754525451; bh=qNeHkb7L1un5p2eTx7uIdxYIPGuHDlQVkoD
	4AYWoiJ0=; b=AbuodmXHTESCuBGgcAe0jaivKpessMpvmMA7tr42LjmiCkQXA3K
	Pc0/r/MmWi6KolnmBDYf1P/XnULiUPUzPuCcyEqxS/4Vzp2JgVEYXMD8jWFU2a/0
	mPAJVEKM5oa802fINCPJ7qUSF+VeqEysYsgCNQZF3NmXUI5AmLXXowRLHK9X0Qc3
	BX/KPIu4nRk5e2LptfEerZ7SY07dPj0PxQbaaTzWF9zlJ4Num5qeHw5ngueD4xNb
	2paju4g8cGHWjTlDfW4kTj9hW6h4elNT/rTpyszZtm4hVecHt3OrtKxIY8Pfp6VP
	m674UmkXfCAgsogZYafTOTIUM/1Zn1F67hA==
X-ME-Sender: <xms:i52SaA0sqWuvQbAftwx1_hVGKq6EVkgelkil3Q1qFLdSlhO9GBj_kw>
    <xme:i52SaO5DTP5V7o8vBxBgJPX559FjReufAUwSd6KeU-UkXbOJn1vDoZXu-D9fBbHQv
    c4k1KNKBVhUV4ysHik>
X-ME-Received: <xmr:i52SaB8gNiEq997kXBLKklCeBgYleu5UtWJ7X3bfkKx0kF-oQaFofKd4OEUnJRpjpst51TyyGYFOH4GBBt5ao2ll7aQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduudeiheekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucgoufhorhhtvggutfgvtghiphdvucdlgedtmdenucfjug
    hrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeeuohhrihhsuceuuhhr
    khhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhepieegleehje
    elfeeifeeiuefhfefgvefgkedtjefhiedvveetgfduleejheeifffgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpegsohhrihhssegsuhhrrdhiohdpnhgspghrtghpthhtohepjedpmhho
    uggvpehsmhhtphhouhhtpdhrtghpthhtoheplhhinhhugidqsghtrhhfshesvhhgvghrrd
    hkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhr
    ghdprhgtphhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrd
    horhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtohhmpdhrtghpthht
    ohepshhhrghkvggvlhdrsghuthhtsehlihhnuhigrdguvghvpdhrtghpthhtohephhgthh
    esihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopeifqhhusehsuhhsvgdrtghomh
X-ME-Proxy: <xmx:i52SaNXiVbelmAyZhA-GZZHs6bXZyZSpJ3mJe4aW5Yfd2xvT24t2RQ>
    <xmx:i52SaMrtIZompcUTUHirU7Eoil2nJRLOOlMmg-KEMlt5Cgig9aRbqA>
    <xmx:i52SaPl42hGL_7meT9BV5_AMx0Ji04Nfd7DSCGEuKZb-mJOffRkyPA>
    <xmx:i52SaM1VKstmP-cGUUXd0Fwfv7tdEd4dJ_HC927XHO_DEietJcgs5A>
    <xmx:i52SaD0PosXDOWilIQRb0GWoPs73cwVx3BSfuVgrTPwVAAbl9wNOh7jw>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 5 Aug 2025 20:10:50 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@fb.com
Cc: shakeel.butt@linux.dev,
	hch@infradead.org,
	wqu@suse.com
Subject: [PATCH 0/3] filemap_add_folio_nocharge()
Date: Tue,  5 Aug 2025 17:11:46 -0700
Message-ID: <cover.1754438418.git.boris@bur.io>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5335040005
X-Rspamd-Server: rspam06
X-Stat-Signature: jn6385ujtowmfbnwx1h6z6p5d67urw1k
X-HE-Tag: 1754439053-194499
X-HE-Meta: U2FsdGVkX19Cfgd1EVRYtPg08KpOSCtxh8oYpbglio6TKwfl6zBkfGcOZ5DJrjY4bOEUz+J/LKnEj6+Lc2KAVTJnKnkyy7M6oALyIfc6AJ1ljMb/4Qxp8NrDZn61SjCx+nGCBihGHI1hn3m8eS6igFy0qfXbPwVyB8jc/+S2zezJO9L6hc6gUpRUPx2Ipwf4Amalq5vfhvqIyX43tZFhkoUq3iwMUMIzX1c9jZeZX6U+LkzsQAZJat8E+UGoaYmHyqoad4ZUR2vtf/tDp9cY9k5gnV6TazNSt/zWMigEKoe1C4OTi8xyBvgeRDS05fCz2dfWXemT63SBN40jV6WJtqvp01hSPUyad7TPXgYCpwHCw7ynu9Vm9kzbe/VEOuyM4buyf7qKA4X/Vaa40y0n0KIhz9MNd9VW/9oZj1F5VYxJdQ17xNJxUxZP9xzvoGchX5hXNMzMBAQvDeFXF/6iWKqMoV6NJmJCJfD3WsU3Nseoi6QnqCVCmuxryUvwvuh73uFohOeITfDlG5DJaKjUGrQkOvNr7dXKhRdnRf/AxxWCtuhBCrc6dlJvjz7P5VAIkHoqbgR4WbhObeJeqn8MEW97VPFAUnpOCFyYQr9G8RB/CIZJQgr6j5uw+qhg/QI2wcG3zykUVBHNdxfL612WDTD6Pl19dfgk5RMqbbvIgTotVvm5VoJm48yuPJSHy9QegOTRmVDvOxt4R/NO95B59RSnDzMWRnuIMm267VaBljUgfa7EvDUpZiG3ciYqPlVMwohjI1Y0rMPzDKhkfb/ZUrBKxMFiYHXsOT/XtF7B9v0cyiT3w27qlmWo02os2vBVKZ+xFZxJ6o80GOfgSwrYVcSAJ0VXPtMtJJEC8f+cCH4TwD65thugWdra4d90La8z5OyI/hLFat+0vBUA9R8zTAjzLuykWEmg0QJ8KdqCGaFv1fs7141EAIo4EcLsw2e/7M5Is+OfG+xdL3T/9cG
 L6a0Mysx
 rlPGwI2wkmt7jkrbfZhYGQiPCu7dfggURFquCBvMBSKFdaihwpuZCZyLnhAIp2Gio457Hb7ip/HuCeDjUWRdkuuys/MRGvEoZQcKeJ+EnIrxpexRByi3FapB0Nhl/+Ez0TqnO3URcVPLPuVOEU0MXoSC2nO7kpqNTEjLSyJxUiPyWpmMVAHF7iuz2ZbZG9BZkVK8bFGah7G1hCNMXAk/aq7yp5aJzqh8Ws/9cMtIhkFnVw8kWvnIIF6rdhB/oQcdVJWqUv6geR3W9gWahhtLgJjodAa44pj98wiqoZdYuEddgbNuZxFn0ZGlg9AWQGa1Yr6ANpp6wFctjKSLF8ysQ5jbrdwM9Gwhszn5qQJ/eOfY0pPIHpQhRbWP2wSfD2GguCfHbaHhNvH1WQZen3c3E8w8dGw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I would like to revisit Qu's proposal to not charge btrfs extent_buffer
allocations to the user's cgroup.

https://lore.kernel.org/linux-mm/b5fef5372ae454a7b6da4f2f75c427aeab6a07d6.1727498749.git.wqu@suse.com/

I believe it is detrimental to randomly account these global pages to
the cgroup using them, basically at random. A bit more justification
and explanation in the patches themselves.

Three meta-considerations/questions:
1. Which tree should this go through, assuming it is acceptable?
   For now, I have based it off btrfs/for-next as that is what I am
   used to doing, but I am happy to re-send it based off the appropriate mm
   branch.
2. Christoph wrote the first patch as-is in his suggestion to Qu. I am happy
   to replace it with his authorship/s-o-b, I just didn't want to do that
   without asking. For now, I put his "Suggested-by".
3. The previous suggestion also requested "proper" documentation. I don't
   know what that entails in this case, and was unable to find corresponding
   documentation for filemap_add_folio() in the code or in Documentation/.
   Please let me know what I should be doing there, as well.

Boris Burkov (3):
  mm/filemap: add filemap_add_folio_nocharge()
  btrfs: use filemap_add_folio_nocharge() for extent_buffers
  mm: add vmstat for cgroup uncharged pages

 fs/btrfs/extent_io.c    |  4 ++--
 include/linux/mmzone.h  |  3 +++
 include/linux/pagemap.h |  2 ++
 mm/filemap.c            | 41 +++++++++++++++++++++++++++++++++++------
 mm/vmstat.c             |  3 +++
 5 files changed, 45 insertions(+), 8 deletions(-)

-- 
2.50.1


