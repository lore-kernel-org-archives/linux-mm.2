Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1F2ECA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 23:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DED06B02C6; Fri, 15 Aug 2025 19:39:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B6F86B02C7; Fri, 15 Aug 2025 19:39:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F53A6B02C8; Fri, 15 Aug 2025 19:39:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2D12B6B02C6
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 19:39:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C3D3C1378BE
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:39:55 +0000 (UTC)
X-FDA: 83780611950.29.CC6A294
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	by imf29.hostedemail.com (Postfix) with ESMTP id D815F120014
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:39:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b=HDrvnGEG;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="hbE4w8/g";
	spf=pass (imf29.hostedemail.com: domain of boris@bur.io designates 103.168.172.155 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755301194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sZ4Ffa9LjIufP3LldpHrc2CPMG78ZFVCnuyEXE80K6w=;
	b=1E3da5VCQTqwbgVs24MmwwiBFanlGc6K7bpw/RQFclWTqqId/+oGl0sbQ0OIwMY2Bnsb0k
	rezjlDNcC5rnmG60cai5vPSLaNyjDAjO74VEnSvW3c4zyvqo+2cOvtsH+7KyULOFYr0sRp
	C0LfTxcIfIGi3xcPWXG96XIlllg313Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755301194; a=rsa-sha256;
	cv=none;
	b=3nCd2zVBx/MzmSDqJBqCeER522yDwCxCgc1EBU1R26TbdKTcp6bFQe8scirjFAFZxrUx1m
	4LcblwUd9v2eHHkhO4mFD4WT067VVuo9bQrhfL7JYLssogXOZj/pgdyYsUMs4pnSkaqvgO
	nzwUFSK8B7Cr3MsX7Ci+ss/MwGCCoFo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b=HDrvnGEG;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="hbE4w8/g";
	spf=pass (imf29.hostedemail.com: domain of boris@bur.io designates 103.168.172.155 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 0CF001400079;
	Fri, 15 Aug 2025 19:39:53 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Fri, 15 Aug 2025 19:39:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm1; t=1755301193; x=1755387593; bh=sZ4Ffa9LjIufP3LldpHrc
	2CPMG78ZFVCnuyEXE80K6w=; b=HDrvnGEGjkl0Jx+ejkHkEaBCQx5AcsEO+ii40
	g/5mfOvJ5V4n2Zgc3gfOdQhkX9Fyo0SpGvKWu33C1sUyoy5zPEvSC/u0/E1Bv6jn
	NNuAk8piVk0seSWBAwoqTkRRa1H2p2Ja2DLq5TTqdDxYsmlsbCLJjRvmuOhP/dPu
	e9u14a52jfOQDMaRZ6ygqk8em1IiMXw5p+kKyIrZE25KVCgtHNVsDZK6CYPfAZ8Q
	lyAuqTm/sZU+tZRN/kVmLRPpHs8gzkVRt2xxN8cUjVSxnHlHyb3nDV+NbVfjPpyj
	K+b7y51hkjLll9uHkBmnaGikei87U4tcd4A0UKbJLwA4NIArQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1755301193; x=1755387593; bh=sZ4Ffa9LjIufP3LldpHrc2CPMG78ZFVCnuy
	EXE80K6w=; b=hbE4w8/gg31GsY51ankoKebjx0j9ytY1l88OWskDjBm5V4RDWFr
	CMqOo7tPDcAFEa7m5KyU8LlMbfQ7OUwKpCvYmYVnMCiX8tk8/kTMqhGXZKZBs5X4
	JCNSQAVv0HFeuvq9yxL0VVL5AmSmhBdUxVViQYuo/z4speSTc/oF00KvdK/zJ96U
	LKwH0shWOGCRHYfMBd+OdFhEWXSOWYO3ikXWjicZxOoiBNuAlhCLLK27SW9PbgQd
	XLoUGlXg2kYfXmQXQueOjfY7VNHX0yCJYl74jZ1uFY/DznNWn/7vyXFtwoenPy4T
	M4rqTLTu+GIVINSjvdonoCm/UckWypgdcTQ==
X-ME-Sender: <xms:SMWfaKc14A97yBhu4P2td-DDLCjev2yovlRtCBuumLQkelRX5h3dzA>
    <xme:SMWfaIC2U8J9L5GLb_t99D83ZBrT6bsGbTZmwYeuxoywxHU_sWgVrV3A4m8Ww5NJm
    8Utj1j0BAJuDmS20d4>
X-ME-Received: <xmr:SMWfaEkU6YMsGYRUK68IQiH4BAsA-xYHzho-AJEQ6xM4Fml9Rd_U7xDlaUyN_6iXepf0wHvK3dEm3aWKUqQGuq0u8eo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgddugeehfedtucetufdoteggodetrf
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
    ohepshhhrghkvggvlhdrsghuthhtsehlihhnuhigrdguvghvpdhrtghpthhtohepfihquh
    esshhushgvrdgtohhmpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdrohhr
    gh
X-ME-Proxy: <xmx:SMWfaLeUnQfpzjgLCkb9aVzWqBh0_bUPE7pAuefD1g8ERS_ujenqmQ>
    <xmx:SMWfaAS30SomTNa0YGBK8NEw9XYGAZF04xQF8tD1MWzGljwG8bZ0bw>
    <xmx:SMWfaKtC9WgEVzTmCxbn4AorxehnTZiosA_yRP8j_GcX1YRODK_ezA>
    <xmx:SMWfaJci4D4nKAfaZO1HP3jubIhBl00leIcyzSQRHZN795thq-vDLw>
    <xmx:ScWfaI98xR2MCZFPU5b8kA57YJ9plX2EWtzu2VaGS3nhSM-GlxUyYf6f>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 15 Aug 2025 19:39:52 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@fb.com
Cc: shakeel.butt@linux.dev,
	wqu@suse.com,
	willy@infradead.org
Subject: [PATCH v2 0/3] introduce uncharged file mapped folios
Date: Fri, 15 Aug 2025 16:40:30 -0700
Message-ID: <cover.1755300815.git.boris@bur.io>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D815F120014
X-Stat-Signature: c46m7ijwmucg44sqkujctju9ysotxi47
X-HE-Tag: 1755301193-584191
X-HE-Meta: U2FsdGVkX19QI5PMzf+2iYArZoBnSfpLhG9AKsGff8lWW/1Tm1daSndy5FSHgjLfYgrX8E9nIDLuoH6Uc6oM0wraAMf6uSSgKExFFBbS2KIOukR/f9CjGvpQDOWXoHNR5VirS91y3jt40M/tdryn3pbX9Ed7tTTxHndH7pRqPS0rMFi+MQv4YdBq7k0kc1pi3tSra7Z0I3ztjZ8S5D3k1rWV4Pi2oH+X3p1MRl+D4jspkEwqgsG7u0IbBuGGsTe3KH6fZ4uheOIaczwxJKG8eQ2MGjvoSaA4GNXjg7KkUxTtFxW5IxZ/8tf2x1Ap+X36Bc2ZhZ6BvFDFACVUD8VKszJgDzhHJH0vDIqxFzpMRxeJc4i/sv23BzYpssiYreNPj+8T1lc6PbD8hn/xq0YppfBGYs1NW1hmAvgqzHn6WXiuZ0fPyLDPx4SE5clpD5DxI67DawK1UxntqoPxuPn21+f3UaCWp0QIY4MtYIv1kgrkOpbIX2EDfq7o77ic4Ts1biMc+dpMgsY++Y5rEFlWsFQ3ey8M9TT+T3OXRR9IsTiwtRdBlgBzFf5Tun6HzAIjSbG2enwocG3gO30XyYOnwqmXtLD/E1PCz2AhcDhkLc4dqnZYvr2rvhSIyxyApEWj5Zo/EeTshqh5wpknDJ/nM+pDvqGzJMP07kVLpJOUzUJGqMvSaltoEtIMryaHLJOUsvIYdo51Na/lingGKoeyOoLb5TqK34B0CY9obO9pkxR4p8YrVIAuYGQmLgvt2Y1RgLOPuWewxaZiY6KxQDtqD5n5mVXmlsgl0EFRMAVEW4/AUwn5YekXNsPNNGHkv/SddY4h6IOcJ9KFZ/4lqmR2OiO+FLxrqyTzRZUL3zL+vMCZYefjHUGHBVzxe8fFJGIG3D5FkuZ3a4gK4ETCjN78pVovkOkyb5n3R29Q8YsmZsnKaKJ36rvpRwjFP9xY40jGkYA3/3243LkNAyYsIC1
 X+m2R+jn
 Hh0UHSmgvPjVsqFBGg90CVXjyPkqUo0nf0yl37hlXKm9qISdph53hFou1Lm2WPpyG2/uNIkiH7WhnsiiC9aqlTkNMr8cOU1OLx7BFwz9zcBNzrYTYaqm8Lc8OfzDJhlzVCfXhh2maR7rQfcY0cQ8HjK3lVZ6D2dzA98R92Bu2s8/aSN8nr+YHPae8cxfEGrqn2eMOeoaC4Z5a7WGFWFZbHQiEKUeyDZyhBRdtyoOe6EsiJty8iYI+yv3GnNF0poP5PL+5+nVzftAbt6I3tULfjUw3m7WdqagBgUep8EFCvzctM5R1UiUiumW3u/edVZZxPIYQb4G/whFn+Veg/QL34Wc9Uw==
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

---
Changelog:
v2:
- switch from filemap_add_folio_nocharge() to AS_UNCHARGED on the
  address_space.
- fix an interrupt safety bug in the vmstat patch.
- fix some foolish build errors for CONFIG_MEMCG=n

Boris Burkov (3):
  mm/filemap: add AS_UNCHARGED
  mm: add vmstat for cgroup uncharged pages
  btrfs: set AS_UNCHARGED on the btree_inode

 fs/btrfs/disk-io.c      |  1 +
 include/linux/mmzone.h  |  3 +++
 include/linux/pagemap.h |  1 +
 mm/filemap.c            | 29 +++++++++++++++++++++++++----
 mm/vmstat.c             |  3 +++
 5 files changed, 33 insertions(+), 4 deletions(-)

-- 
2.50.1


