Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00592CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 21:55:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AE688E0064; Thu, 21 Aug 2025 17:55:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 484CF8E0056; Thu, 21 Aug 2025 17:55:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39B648E0064; Thu, 21 Aug 2025 17:55:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 27DF98E0056
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:55:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C58DD118033
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:55:11 +0000 (UTC)
X-FDA: 83802120822.19.DED51AD
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	by imf26.hostedemail.com (Postfix) with ESMTP id D23B514000C
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:55:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b=TtRxgGJT;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=ZvMZ4not;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of boris@bur.io designates 202.12.124.159 as permitted sender) smtp.mailfrom=boris@bur.io
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755813310; a=rsa-sha256;
	cv=none;
	b=mFCEiVYkZqHopPTxcHmW5j5Q6rp3EttLCvt+KsL2Ajz2bJpm3h+3wf+5jtMI4ofPWTQQpZ
	8AhhcxLIXFjIHqQvRDBnOtjT7ZGdIcDq4GRLHVwS7UDEmG9OI4OV9/+h3hnydb/74SHn9x
	lsszv01pbupgiqfMwInKjr3bE0j5UWM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b=TtRxgGJT;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=ZvMZ4not;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of boris@bur.io designates 202.12.124.159 as permitted sender) smtp.mailfrom=boris@bur.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755813310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XtWHWCopUVQb2SD2YU/s0ucRlC4xraBcZGfo9PxpLrY=;
	b=UNoDtUtZtxMuSQJTenZ6KeeUzf6rYDAxD1MlZ2qElTQAjr3kWDDfS8T8CPJA/gdRUJ9qgW
	WQazvmwjtud9RK1pb83juhSIwV1/1ukOi6kSvr3I7S6AUIB2pGojdWLt6mjEvXmwfjRzmf
	YOiPdeNmW7922vgZdVY8cGzagVXZTJY=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id A92E57A0140;
	Thu, 21 Aug 2025 17:55:08 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Thu, 21 Aug 2025 17:55:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm1; t=1755813308; x=1755899708; bh=XtWHWCopUVQb2SD2YU/s0
	ucRlC4xraBcZGfo9PxpLrY=; b=TtRxgGJT7BCqDJxnitfo46+BAatMP7H8Gt4OX
	GD3i+jutYLtWRcT1Vom0jeZxHEXnKqBVJz+S4xw6HbHfcDLI2bd2ei1V+7Ebbeoa
	lbi2x3dPHGOgRGHhTmixNtytihU1xerplil4H+6aZKNki8iA+gCcO/QVuq3zBxKy
	BAj6CTGcCcgsh0P0lgiYzD6r8t1FI9EvJOALii8jid5F1E8Z2PUiwT2s20Fk2YrM
	d+Ut6sAh/C6nZLsN8YWN1ayH+2Gzf2S9bU3M5IQ2U9VDnHBB/Tc4AwKgOtvu5K+A
	x4+dWLSc1PG0fwPiko+Chka3SdUEtT0VcLM9UVtf2YRMK4/Xw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1755813308; x=1755899708; bh=XtWHWCopUVQb2SD2YU/s0ucRlC4xraBcZGf
	o9PxpLrY=; b=ZvMZ4not7qHw0rSobjS2kIjctumomqiFxTuXs6nYBVi7W+lKQME
	OFHgfNDHTUgY7T+QbS/L6RUsRYw+4zdHeyoedy/sEqKuPdDzFziWiJMxevWRmiYC
	xmFdMcD8fpCcNRfyWGVHQNnBCECMU7YAPJmTS4XCJlZOHjnDxNDLZ0iyeEw3Uy2+
	dGh+FIPapwb1qaKXwArCJtv4oQ8s3OQ6/4s0tSq1By4sVLjDO1Pn0eRgGKONQ4mu
	V170j+4KZGAsgWYziIvV4FQ60IcoyJmeOp6JM9zQjTBqIkpksibXEOtWkzuDVc0h
	xMU9Y4G5zgCfpieeXltY0ILa69VguT5/H9A==
X-ME-Sender: <xms:u5WnaLL6ECbe-06Mfkdes9QihAsRdJYcWYpVbubwAQLsyyYLvA9wLw>
    <xme:u5WnaEpAGTVlLTvah7aKe2YrCy5vOZA4inIX56-fZBUHBP1NhRnX5Nr1JCByJ7qw6
    q-TuRfrhOlWNyrZg2E>
X-ME-Received: <xmr:u5WnaCytuebL1fvAOSvZBiC29vEEEh1VzLGb1uc-B3km_HlHVn7_blDPcX_WSHikpppLI3mCZxsloaCTnkpIde86aCk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduiedvvdejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheq
    necuggftrfgrthhtvghrnhepieegleehjeelfeeifeeiuefhfefgvefgkedtjefhiedvve
    etgfduleejheeifffgnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrd
    hiohdpnhgspghrtghpthhtohepuddvpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheplh
    hinhhugidqsghtrhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehl
    ihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopehlihhnuhigqdhfshguvg
    hvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdht
    vggrmhesfhgsrdgtohhmpdhrtghpthhtohepshhhrghkvggvlhdrsghuthhtsehlihhnuh
    igrdguvghvpdhrtghpthhtohepfihquhesshhushgvrdgtohhmpdhrtghpthhtohepfihi
    lhhlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehmhhhotghkoheskhgvrh
    hnvghlrdhorhhg
X-ME-Proxy: <xmx:u5WnaItRzaTziVeon9XijMTWjhlMSNOYJXTznHn0Fl7xQ4bixrR_BA>
    <xmx:u5WnaL0YPasEVfVe_1HejUAnol-cdN0FdwhJX7CC8d8k4GBryk1bYw>
    <xmx:u5WnaAB4af7ttrkD4obF4RvD2ETO_vniZXY5YCkXWAjUvk8BS_mazg>
    <xmx:u5WnaJC3JRo1dywVeUMLc_jLk4vBEEqwFHCdTjDm2ogkV2hS5CwKUA>
    <xmx:vJWnaKGP0zu5PKMd-Rf2prRyEzmOo2kvCqY-wTfm2tVSnxR0GVVky3Xy>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 21 Aug 2025 17:55:07 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: akpm@linux-foundation.org
Cc: linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@fb.com,
	shakeel.butt@linux.dev,
	wqu@suse.com,
	willy@infradead.org,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	hannes@cmpxchg.org
Subject: [PATCH v4 0/3] introduce kernel file mapped folios
Date: Thu, 21 Aug 2025 14:55:34 -0700
Message-ID: <cover.1755812945.git.boris@bur.io>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D23B514000C
X-Stat-Signature: zuwdygiuyzxpgaznbsnsszaurn9jdi1b
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755813309-835483
X-HE-Meta: U2FsdGVkX19u22FSQETnc+ujOYjV6w8UTTninda9gH6xHOPQIKNdyxUgXFh11XCjIxT3yAAYDDp49TQo2ZFt/weua0xX8riVBur59vTV49LO4TLwBJ32LeQSjuTpCPXlrlMyjfPNabTRQ7HJ7rlCXidspLFP5BjggFakMAgmh2cU/rgrnyZMSeAKl6UxOgnMKbbP/pZMpPuI1w5pCni+QeCLkYWjC9bfp+9urU+80N15Wh4Iad8ssxVYN/eiVBYMYsVZcrfY3BkmgtGbiHmuZGqKfogcI/z5hD8e+rv6SnViiRnOjtCKEvz5A4m5MLVwXYnWSeo65+H/YB91gGJeyi5ChVSlAh8pQcs3Bs8mdINqF9oSOrgjoDEspxqKF1TPCpxTW3SU8laktN3hP3C4FHnvoM03XXdpBX6UkH3WbsehMGPeT0vxggPxKucPegTiBgjKQklA/lljPbf08bx1wWYm46UqSrR5BqG1enBioVmJoasO/V8qz5kxgwvXyjlhdGsorIKVgFIa8Rr4g3cBBFkfLp5DOw+atMZ6pXdGIndnS9aBB5dHzNbavU8FqAP74/UgB/qdxbjUi3hXZjLoJ0IPCIJk4tP+xzUIHgu6mLh6+SiwnVv24kIWem+uxJZr8T0F859DbCxS/0S+yuJIwU/NJ5iQjo2RZ3h3VasDDsl1jP3ZW6QxAIBE5hdgaL+7yrI/5EnT/sE0FufvMs09xJs+JVnVJMDZo/eOOnBEhhCyKyydStXiCQGoNHXF/BuyONn5lIQACTFcom4awY3Es+ycnZjWcJFX965AyksdsgyUxeCTaxo5TduzeN//9QMvwt2Bm62l+ynUwT05wrEsf9SWjnyF7BZDI1A99ZAeNtI902xsb3oN5v6diLGbLgTqxrqOCc4LByXjnKUJDJiGuEcbMtP9QsvLXQCQrpx5xpUPCRFZkJdBF7pF58Ev0sywJFJkzPu/g6SaQ1UJ1oy
 7bTCrZvH
 DXH54NUzlz3h0ZsaUCTvkTCyFJVWpTywu12lSR7uWsTLiNtUQeGZ2EXQko92slZD7F4/dPCir5sJz4Tu8ohd1hLCz7GuAZFPtM6Lwf18ztQ/OvKNV6bdS0POD2cVmdIoFNOv7FPHl5faeYLlE4FVCeK1zFuafd+UNxLTCwjWo2bsdAqATdTf1ImdwkeyUbJsSUPZ2AHstpBDvG8/CuvhVntFJZQkTDTr2ag0Aly4vzamOg0g1KymyRyxw/LAIJgpQSMxeuMuWTKkXPYIkeUMzMKZcXhJYeMoDuQBWP6IK3QzkN7q7umt3BbpScO0mTTSLuCAgeO2ULNj7gjDyTla2j28inLWwuVl1twC4ckrbfA1F1lg=
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

I believe it is detrimental to account these global pages to the cgroup
using them, basically at random. A bit more justification and explanation
in the patches themselves.

---
Changelog:
v4:
- change the concept from "uncharged" to "kernel_file"
- no longer violates the invariant that each mapped folio has a memcg
  when CONFIG_MEMCG=y
- no longer really tied to memcg conceptually, so simplify build/helpers
v3:
- use mod_node_page_state since we will never count cgroup stats
- include Shakeel's patch that removes a WARNING triggered by this series
v2:
- switch from filemap_add_folio_nocharge() to AS_UNCHARGED on the
  address_space.
- fix an interrupt safety bug in the vmstat patch.
- fix some foolish build errors for CONFIG_MEMCG=n



Boris Burkov (3):
  mm/filemap: add AS_KERNEL_FILE
  mm: add vmstat for kernel_file pages
  btrfs: set AS_KERNEL_FILE on the btree_inode

 fs/btrfs/disk-io.c      |  1 +
 include/linux/mmzone.h  |  1 +
 include/linux/pagemap.h |  2 ++
 mm/filemap.c            | 13 +++++++++++++
 mm/vmstat.c             |  1 +
 5 files changed, 18 insertions(+)

-- 
2.50.1


