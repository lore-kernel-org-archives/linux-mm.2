Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0DFDCA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 23:40:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE6558E0221; Fri, 15 Aug 2025 19:40:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B96E28E020B; Fri, 15 Aug 2025 19:40:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9241A8E0221; Fri, 15 Aug 2025 19:40:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E5688E020B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 19:40:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2B10D1DC66C
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:40:01 +0000 (UTC)
X-FDA: 83780612202.24.67FCE4A
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3DB7B100007
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:39:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="C JkZ695";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=hwPLoMui;
	spf=pass (imf05.hostedemail.com: domain of boris@bur.io designates 103.168.172.155 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755301199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ysxGKdmacR1jImBbFNdapk+E8q3B6D5l8QdS9hmlj44=;
	b=yX5KnmzBeSMQixWmIRLNTvOk3oMdvudDtqVNimORHLZVkLTZWI9WxuPmaLfFBjDuQP50EU
	Mv4YL6dE/zqXggd4eu8UTXfg7BDGuzrYArMknRZ52eRu6S7T5FFGMR+xP1yiR7IW43tNh0
	rrw1D9PvpA3QcRgriX+g0gz9OBwKwwI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="C JkZ695";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=hwPLoMui;
	spf=pass (imf05.hostedemail.com: domain of boris@bur.io designates 103.168.172.155 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755301199; a=rsa-sha256;
	cv=none;
	b=JX6eFCR++hKYl8hmBa/l9e+raTrLls/VfMDDi9iCg6OVgFtiaHtR1zPrXZjhZBZ6dXOGZx
	fIgiFD2LorGWczVr3dlcjKFBY2HUy6jQvOWWLChibHsSd9MkCVrc1pT5QT/QKJZq8/1XqH
	gdRxYZRFUVvM1TZSPbGGRhB1QhfViz0=
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 9FCA014000B7;
	Fri, 15 Aug 2025 19:39:58 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Fri, 15 Aug 2025 19:39:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1755301198; x=
	1755387598; bh=ysxGKdmacR1jImBbFNdapk+E8q3B6D5l8QdS9hmlj44=; b=C
	JkZ6957clUeSfKcNKxIGkBGQ//e2i+bc+P/MxsLr5TgDyoLhilpsWF/ZhD0Dbwbi
	iNVsVo5epgswE/znf0Z8LrLCqlw34SW+Q6FtWVzOeHJ8keIO+9LC/FCFfzCOPMCN
	U6dXoSB0s6oP+/sr8pV/h5UDUqKwYCoRTGRo2tlOJ6dq+NXkkyROYLqyn+K8MMBC
	f4MR1raMln12bS3DjgPPwDSX8vUr6CXfpVZxtZio5PKFk4MeRs9usCdauSyJ/671
	A+WEimWTYEznPU0SwxpvxgCtNEGnZsIyqjmH7SM2LPifSR+gPRobqwwV8XaUSEoP
	pGf4HAfMMCoEKDPA+mdag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1755301198; x=1755387598; bh=y
	sxGKdmacR1jImBbFNdapk+E8q3B6D5l8QdS9hmlj44=; b=hwPLoMuiQt07Dkkci
	eMtO2RMKbh+MxoV8lwzFYBK8zSzrpC0nUKZFH67jo/u4ZlSVKhjS8cBEWPLJt2Xm
	njLCmq3Fd8xpLEoVm8B42cSKiwcfSjHej31mmWa0MdNvwUpdapBzMDMYzgSMOzX+
	rGqus7cPI2839ELlqsnnApaVUri8ktmy99iyeyYXzuSuzFE6kU+7upvI4YsgKNFt
	oBRQgQ8nqpTHSbd4VJtX0mg2Gki5M4wBIyDVWMsQUWb17tZ2QXZePTxQfqB3C6T9
	iv1Fw1e3SwFP6YUB3q3v4SgX/E1mGXGQZeCWZy30loXVk/VeW4e5LiWVRppKIdu8
	6ZWOg==
X-ME-Sender: <xms:TsWfaIOXboGGrI9Uqfdww4PNgu4x6H0UOc9lbnXT6AYQ21bHjjm69A>
    <xme:TsWfaCwJrwb9Ha9W6bQ5ge27E_xAx6v1kF5mVZOnHc3yTFGmno59u5-rqczT9HUBq
    NNYLZMjs8zM93_iAic>
X-ME-Received: <xmr:TsWfaIXPoQnqLohrTuM6IEnHNBGo1quW9utkPCeg-ewAb-39cLNKisFKAR_AX8ha5OnopbYdwXY8jpNSYbd7EreJlAw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgddugeehfedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucgoufhorhhtvggutfgvtghiphdvucdlgedtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeeuohhrihhsuceu
    uhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhepgedute
    ffveeileetueejheevveeugfdttddvgfeijefhjeetjeduffehkeelkeehnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessghurh
    drihhopdhnsggprhgtphhtthhopeejpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    eplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtoheplhhinhhugidqfhhs
    uggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehkvghrnhgvlh
    dqthgvrghmsehfsgdrtghomhdprhgtphhtthhopehshhgrkhgvvghlrdgsuhhttheslhhi
    nhhugidruggvvhdprhgtphhtthhopeifqhhusehsuhhsvgdrtghomhdprhgtphhtthhope
    ifihhllhihsehinhhfrhgruggvrggurdhorhhg
X-ME-Proxy: <xmx:TsWfaEM1zZLipvgxxCkwcntZP9DQ-zmWraG2bnXb9q7atu4CEbSFKg>
    <xmx:TsWfaKDaZqEf3d17c09rfc1jPtAJEnKorgRFfjMTYIAS5yvtLPy0pg>
    <xmx:TsWfaBeUQwA9ZcZR31MQ27FpM7s5XMfiwgSMSSJY4G_FvkAPsOZAnw>
    <xmx:TsWfaJPV778mxHNw7TrZUHgFv8tj8Xya7miniPhSuHD0vQ7DCeS1qg>
    <xmx:TsWfaLtneBBKie269hHhP6VQ_hgwEiGTdLj7TZpLV7U0V-B2tw__WhGR>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 15 Aug 2025 19:39:58 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@fb.com
Cc: shakeel.butt@linux.dev,
	wqu@suse.com,
	willy@infradead.org
Subject: [PATCH v2 3/3] btrfs: set AS_UNCHARGED on the btree_inode
Date: Fri, 15 Aug 2025 16:40:33 -0700
Message-ID: <786282400115bf7701d7f9c6b00a9549f67e29f7.1755300815.git.boris@bur.io>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755300815.git.boris@bur.io>
References: <cover.1755300815.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3DB7B100007
X-Stat-Signature: chdgphh6upprrzxn739q8rp5n88y8xhn
X-Rspam-User: 
X-HE-Tag: 1755301199-309183
X-HE-Meta: U2FsdGVkX18AvvPB+fQgZ6W0Yjx+OXIDNz4XSRptaqo0N2fBFe/z/YB/hgNDf9Sz9G/d1frLtL7wDyyk13ApgFzW5fNMMomC2aodNMra50WhGbPHNQSUk2vShOVHEs0AtpU7XQ6Yda+yHomK/+CPWG8VdkD8iZWl215P5vME24WIeifbnaZUW2bnM4RloRXkb7BX5Z07AIzbzrePqRhO7CskkUagiTYP9SllEOAyBDktssmjMiwNnb4ShWou8+8YmpLfVyJg081LTkDL6PC6ZfL4DffxlwdHQ49LON8iavBrsFAIH+N2FU5NTqFqGgM0PugIA76zPzPzteCmyGgxIuIFNwq4U0qz/1RAu13vswelbv6XSfCWwRUVjwjcGAb7jqxCQDdwLHuUy3Sm2fINM2IiBfCVJ+lvGDtgaDpy+LJiKvNHiCKOsxM9/VR/iCzYDhZZAy22dQ6Cno85QXtL5L4kzqRAZrshD6BoYBsHVXaGS5TV/DCACVh/ntv6RlsiF78VsxiV1JvzTNLwfSMzfwF3a56eQyrJIGapRUhnZ8SOjn1OBLF35YT9irhbXutw2rqLp9N9p0W9vBC63Zu5sd89VSuVWiJi9+zMgY05HiiPlJSO7PODs9uuEj5T0bgDt5ObK+/GdwF2agyCgc6sy3i570D+DhSKhgTZ3Rycbtxk0FO07VYL+g1r45sGUMwgZ69KMfrzuSjngLwx948osYrE60HsrtllUD2N6JS8Cy4mcv83LsHwmLNvDegb+Sne0mz6h1NLLKgHBmpVH4wvI3Wp4WnYa8xG1abg7PdaRnXYif59N1pTmXvJ0fbg69HZgF9UIBTEMaNAyH7t9sM65YqPj54apIJoKpiktPTKrdlcbtaxVG7SXKXWMxce9Naasf2BQ6XpPK+np5vqDYqq+y8S97bkJ9tDmm+wRQd2NXfV9hUCd7LUbjMOqLAiUU+NuJGL69P0QwYKF8w/CQW
 tJfBK83n
 ruaLxQPscYvtovzYXXdXtuZX/Ngyd97uBvWeMIRkk6v8XoHW6T961otxvMAsYf532JCFtSWe+Qw2h5LsAfEX8iVVvI1oLakSonksPB5TFgpoVNaKrT3hVScwhDr4eAWNgk4WgUNF5D+SInIoraY92PdJ/NTYwk0pVkhPQbj5mNKsz91ZDUHt5sZwSkAH30/ektiEL2bqdqaa3mH3ki/MjwPjZaJbOr7ojlJoCecSTBcsyRSgrX1oQUXR32QIjxezmceZA2RrRH09qNfNPefrx58gQlg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

extent_buffers are global and shared so their pages should not belong to
any particular cgroup (currently whichever cgroups happens to allocate
the extent_buffer).

Btrfs tree operations should not arbitrarily block on cgroup reclaim or
have the shared extent_buffer pages on a cgroup's reclaim lists.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/disk-io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 123c397ca8f8..6a6ed8c1389c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1930,6 +1930,7 @@ static int btrfs_init_btree_inode(struct super_block *sb)
 	BTRFS_I(inode)->root = btrfs_grab_root(fs_info->tree_root);
 	set_bit(BTRFS_INODE_DUMMY, &BTRFS_I(inode)->runtime_flags);
 	__insert_inode_hash(inode, hash);
+	set_bit(AS_UNCHARGED, &inode->i_mapping->flags);
 	fs_info->btree_inode = inode;
 
 	return 0;
-- 
2.50.1


