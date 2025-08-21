Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0440BCA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 21:55:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4676E8E0066; Thu, 21 Aug 2025 17:55:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4103D8E0056; Thu, 21 Aug 2025 17:55:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23C078E0066; Thu, 21 Aug 2025 17:55:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0DA698E0056
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:55:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AE433140530
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:55:16 +0000 (UTC)
X-FDA: 83802121032.30.F492C7A
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	by imf05.hostedemail.com (Postfix) with ESMTP id BA8EB100013
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:55:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="Z liUIqZ";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="MyQ/SECt";
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of boris@bur.io designates 202.12.124.159 as permitted sender) smtp.mailfrom=boris@bur.io
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755813314; a=rsa-sha256;
	cv=none;
	b=ZjsvxVLMF2u26hNcz2NGKN4z/KvgOuOl7bCvoBThpuA0bJhTv7jtOnp+Vr+JbmrxPKVNAS
	T59izUNpvm8vwesmdVjoZFa0A0goFXFcxqCmkh9mdsvW1OTIqsJs2qV76ok2u+drtttC/c
	+R/nIj9XOgD6TeKG5mJCYYjfFJUW3AQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="Z liUIqZ";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="MyQ/SECt";
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of boris@bur.io designates 202.12.124.159 as permitted sender) smtp.mailfrom=boris@bur.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755813314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nqjmOG7AetCjXRm+3fjXeKcj0uJWknxrBI8B7x2fxgY=;
	b=UUUSawuXGQFEvazfpYfsoQiXYK5NFFeMQgdnhYboCGJZvQdcfK83QDeqzwISHatB48PDP8
	Wj3kmIpPaPNznFyO3Rs7Y57GMcvOdXESOb9iPUS3MPoqB1LVpRfNPEg4u3kvPqY/i/TQaf
	5waHDOjhpE2hbJbWkr3We9QpxOTzLpo=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id CE3157A0119;
	Thu, 21 Aug 2025 17:55:13 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 21 Aug 2025 17:55:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1755813313; x=
	1755899713; bh=nqjmOG7AetCjXRm+3fjXeKcj0uJWknxrBI8B7x2fxgY=; b=Z
	liUIqZz6ANVuxcMBevSJ7rGSbuVR8NeCuoYlPCyegwFHmgm3kyQwH08bhhh74a/u
	1E/OyFkduL2OKm8oms3pSwAmfngxhora6yLBNS6gbRSYtEFPKU9ytpLKzUvOIINg
	htwv89LSHXgwMWJ0XLmvXuL9NAZfQi1Q/NLtU1O7Y5C52/iBkblcnAv41ZFX8c+U
	FHgDaIS4G7oHPAvOCgl40SaEl1VugPEqRpQOnrlZzSeNuHaPo1tm+cTyDffO3KTf
	gVBnBs/rjR+xk57H0c4KBmFiTGm2uVwJfnwsvAZG21Xd6K6lc/ICXT2btwA5HulQ
	vmO1Y6aG+zDUFF9vd4Ypg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1755813313; x=1755899713; bh=n
	qjmOG7AetCjXRm+3fjXeKcj0uJWknxrBI8B7x2fxgY=; b=MyQ/SECt4H3X6baiB
	2xd7fQp2eTClIWp1ptcXQO/GHsEw0t4K47oeYSfXrSDLv4diOpT9W1jsqW7RRO0B
	WNKFJSOke2goC68FvvRgab3CqTdGuFYz7/z7V4LV1sk0R12N2IUgRTe+3AXRXN8T
	w1JGGECerAePtCFtQzelCSP6Rw067vu3QnH7od/SLsszvQt6fNLOnEoUHWw2wyAU
	OKlSdQHeferfT8vrznXZnkUNjbLHai3sdHO189ukGfEZ9NtHipmGuTimRhO2cpB/
	/j1OMaeTV8zD4mOwa5fcK4W2Z9MmPQDXlX0Bm/Tid1HjQ7y2DNgz1BxOZ2sAOoR2
	3ulTA==
X-ME-Sender: <xms:wZWnaM0qvTgSNrGpqMZBJm_7UW7zhkUzB1Xt1lwtEjcbo9pYgICJ7A>
    <xme:wZWnaMn9hZ7Bo7M78Bssk7Ho3Y9DESaJq9iEJ8zCywNs0CQRgLL0_UR24AsQTmXam
    21K44YFjjdSr7lAYnQ>
X-ME-Received: <xmr:wZWnaD92Wk_0xAhRBtLH6n0-Y76E_or2eEo4bZwR7sD6KhZZO1fJoz0V5u9l1qHZMXo8yrD6QTbrLDGCmj1erQf8qEw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduiedvvdejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepgeduteffveeileetueejheevveeugfdttddvgfeije
    fhjeetjeduffehkeelkeehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopeduvddpmh
    houggvpehsmhhtphhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgu
    rghtihhonhdrohhrghdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkh
    gvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhg
    pdhrtghpthhtoheplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehkvghrnhgvlhdqthgvrghmsehfsgdrtghomhdprhgtphhtthho
    pehshhgrkhgvvghlrdgsuhhttheslhhinhhugidruggvvhdprhgtphhtthhopeifqhhuse
    hsuhhsvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhg
    pdhrtghpthhtohepmhhhohgtkhhosehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:wZWnaKIAbn2E68OZAUwx6keXs5Rr_kJepx0AO6ObYGNPS4Sm-v690w>
    <xmx:wZWnaIhPKqADRjDWWp4pozZa8UsRVGTBYnkYu8vlP53Wnfxkkw_iXg>
    <xmx:wZWnaG8uyPNuWlGt1BlKS_XE7oV1ZZ4pr1wu9s6KOyi4RmIiUZ9ecQ>
    <xmx:wZWnaNMetRvX1GvB9K22w0MTxhUtuu2qhCX642k4DKHNEUSMY2oOFg>
    <xmx:wZWnaDwPub9bf9ZF2lj6heYwwlKWvbm59hn9YYaONVNkH4_tVkmGF48M>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 21 Aug 2025 17:55:13 -0400 (EDT)
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
Subject: [PATCH v4 2/3] mm: add vmstat for kernel_file pages
Date: Thu, 21 Aug 2025 14:55:36 -0700
Message-ID: <08ff633e3a005ed5f7691bfd9f58a5df8e474339.1755812945.git.boris@bur.io>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755812945.git.boris@bur.io>
References: <cover.1755812945.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BA8EB100013
X-Stat-Signature: xqtf7w6373usa58neqq8suyjartueyge
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755813314-995377
X-HE-Meta: U2FsdGVkX19Qj9FwnfAq6It2KJs5DLMafTPNK9CZYB/3DYb/fA5ozq71/J1Jf9jKXkaRdHlOAcugs+OBnI1hEEjqoYTI7zK2Pc6YdrAAoYjtuL5w1r11JDcPpVbDpwF8B9xwWZYdc4wB+ujD1hTzijHjfFkkNOdioBgk/jOrWrDxp1cgKE2CsGpFomC1fbJyT12F9O7p1Ywf3zE3OMcWnA4639Pi+MfqxYkelXhi9NeyYOS4ryocOvS2OHQWpft+lsQqCvmWl2lBk/snytxklpmoVFPqf75uTwif20rOXLa5lmktR5bEr8gqBCInwyJJ51EewFF3BxhxOlnkc+/qocsvk+bsMDBWGLr4aLZf2PIB57bOQQ1dOwgidjKsU59hesZX0mOxNan/b5uQdqrR8wkHcjdb6NSM3tRW7eoZHvneboA0rb/71qbghlgr627u/d5RDhJ1YvJd4BFKN/rUMcvbHX1Q04NLFwC3VbZUaSoHWeCkLDKw9efO0GwVSowR/1ESdm/XOhQVtwg7+5QTGLRf/h8eSKwzRCdtDucyN1dO1JOuEdFDyH2fP9uiPBdYb71MtwoT4FYw7uMOR82362LcG5WYm7B8nWlGYOknvPij0EugnL+vhzShFjkgtis7bYEwNZEq8jTvkA8CQ4Z8UgF1t0hR5iQbzBDiltFBWiINYuMgYFZUaw1g8DIX0Grnw9VyM9vymAdp05vh10Cb9ja9CiXMQmfb9lLsk+7ca75lQwC1QjSnDjEWZMDjlKl8OS8aJT69L+eYMXsm6Mx8VEzIgyNcPBtQd41CXlyHI0EfaJH/SZpUo24HVPqLH6SaplEngirka03TvRzG+oTB768qG9VI+T3P2yBfEdXdWNbUzUzKIQNngSYZnrnstf7Pq6tbOhR3IALtag2vx9XykbB+qJS8WCa+KQN2gMmvC5CnMMMq2Mq5+BJmxEzvCKpw9DLEfPudBGlNUsycafD
 OUiKdc5R
 f0V+YOezz1KVsixL/GU2uzzG7fA638NRJ/OrF1M8Cp2TxQDOz7KD66O7Yl9hxZ2zmG83288cOowKtmUaoRyGaMOUvEQyZ9rX1CSDcw7MttxRYmOu4vmNAePIvSlDecev6xy4SQYjz4d70uWAE7P0dVQKVdcNrBWHfFEQoLOIam+BoHsA2SvwOF4czUdg01ndGd6CrNqkAQ3f8VJ6CId5/GiIqX+ldUh1lVu9M8lsIzvewJiTYqIeBFdAP+UI1kNc0v25aVJihFh77FL/KSwIrOCP8xETC671OxfD1Bdd6lMFLot64/7HIuAJwFcgOlTQv301wT7+F8miO/laRw8MxCFomoUQRvnJdM/E+J2sJGKU1ab78Fl1lNa50P05Lg1INZNykhKKttoYDf6lRVkbbiVjI5wKQnA54Jsmt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kernel file pages are tricky to track because they are indistinguishable
from files whose usage is accounted to the root cgroup.

To maintain good accounting, introduce a vmstat counter tracking kernel
file pages.

Confirmed that these work as expected at a high level by mounting a
btrfs using AS_KERNEL_FILE for metadata pages, and seeing the counter
rise with fs usage then go back to a minimal level after drop_caches and
finally down to 0 after unmounting the fs.

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Tested-by: syzbot@syzkaller.appspotmail.com
Signed-off-by: Boris Burkov <boris@bur.io>
---
 include/linux/mmzone.h | 1 +
 mm/filemap.c           | 7 +++++++
 mm/vmstat.c            | 1 +
 3 files changed, 9 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index fe13ad175fed..f3272ef5131b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -259,6 +259,7 @@ enum node_stat_item {
 	NR_HUGETLB,
 #endif
 	NR_BALLOON_PAGES,
+	NR_KERNEL_FILE_PAGES,
 	NR_VM_NODE_STAT_ITEMS
 };
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 05c1384bd611..344ab106c21c 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -190,6 +190,9 @@ static void filemap_unaccount_folio(struct address_space *mapping,
 		__lruvec_stat_mod_folio(folio, NR_FILE_THPS, -nr);
 		filemap_nr_thps_dec(mapping);
 	}
+	if (test_bit(AS_KERNEL_FILE, &folio->mapping->flags))
+		mod_node_page_state(folio_pgdat(folio),
+				    NR_KERNEL_FILE_PAGES, -nr);
 
 	/*
 	 * At this point folio must be either written or cleaned by
@@ -989,6 +992,10 @@ int filemap_add_folio(struct address_space *mapping, struct folio *folio,
 		if (!(gfp & __GFP_WRITE) && shadow)
 			workingset_refault(folio, shadow);
 		folio_add_lru(folio);
+		if (kernel_file)
+			mod_node_page_state(folio_pgdat(folio),
+					    NR_KERNEL_FILE_PAGES,
+					    folio_nr_pages(folio));
 	}
 	return ret;
 }
diff --git a/mm/vmstat.c b/mm/vmstat.c
index e74f0b2a1021..e522decf6a72 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1290,6 +1290,7 @@ const char * const vmstat_text[] = {
 	[I(NR_HUGETLB)]				= "nr_hugetlb",
 #endif
 	[I(NR_BALLOON_PAGES)]			= "nr_balloon_pages",
+	[I(NR_KERNEL_FILE_PAGES)]		= "nr_kernel_file_pages",
 #undef I
 
 	/* system-wide enum vm_stat_item counters */
-- 
2.50.1


