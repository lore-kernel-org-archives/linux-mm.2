Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33C07C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 12:26:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34DA66B0096; Tue, 28 Jul 2026 08:26:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FED26B0099; Tue, 28 Jul 2026 08:26:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EDCE6B009B; Tue, 28 Jul 2026 08:26:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E78B76B0096
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:26:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 76A7E40368
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:26:44 +0000 (UTC)
X-FDA: 85038109128.18.D2D3738
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id AC53414000C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:26:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gVs7BNFg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785241602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ayU/6lHRgKTCK80O1xUHS/LH2s1bomipfuf9KK8K20c=;
	b=H4RbTXkcLesyBrQWnLD/m/jyBSbR380Gp+0dKZ2Rw535N6e9f5qr0EfcYckP8PnVefW8Hv
	jl0Kzviwn9Nb6qLavQcOv3fGYjYqn5yL1gYb6YGf8ZDiG1QE8cqxPXYKwibNb2hCF7LDkH
	a3nhUwd7ZpDZyRUpR8hUcIIycR8hstg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gVs7BNFg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785241602;
	b=lCSCf/B6KtqIvJeahEEaiuduOuTurBaMh5w86UWGgyrb6J9NoYauIghJC8QHnvpVTY9nSa
	+eTfguIxxbGbXTRjCksCJbMT5hvhNdvf8abD8+WgyRzXzDmR0Sg5Lt/vfhll+6uNqhea9S
	u8L6EnCEH1bOMD1Ypk5sx1nKnO/WK+k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BA554171F;
	Tue, 28 Jul 2026 12:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58541F000E9;
	Tue, 28 Jul 2026 12:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785241601;
	bh=ayU/6lHRgKTCK80O1xUHS/LH2s1bomipfuf9KK8K20c=;
	h=From:Subject:Date:To:Cc;
	b=gVs7BNFg1PY7V4cwmbpGOMGSnan6Vw42QKmoSZbJT30480I/kW+/T+jtrYnn8OulU
	 o2CUtBZrNjG0hUL9HmQOgcj1b0g6HC3FGxCr5zHYzD4IVdbuZHZdG5woj1zgvrkbkX
	 zwVHguBQ8RKvaUS8JBAfhtVqhKjaidUOFTsavBSTyK5+3vUp7HUABpbVxMcaPNPh8/
	 GNkDCT/HsX6BdKizy/7dMEWwwGTIRp3SskMTDqkl42FYAUA4Fy4cSc/NWfgEy5k6J8
	 28qauiv47nXKp15BNwRZals5F6aeKKZuaP4IEq0J/lMcdagWCu04NugEXajOf79bFG
	 lnHhQQe2eWFOQ==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/2] binfmt_misc: don't let an 'F' entry pin its own
 instance
Date: Tue, 28 Jul 2026 14:26:31 +0200
Message-Id: <20260728-work-binfmt_misc-selfpin-v1-0-74df5daeca5b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPifaGoC/yWMUQ6CMBAFr0L67ZrSiKhXIca0ZVdWpZAuognh7
 rbyOS9vZlGCkVHUpVhUxJmFh5Cg3BXKdzbcEbhNrIw2R12bE3yG+ATHgfrp1rN4EHzRyAHaqnJ
 lfT6QJlRJHyMSf//p5rqxvN0D/ZR7+eGsILhog+/yNJPsN2Ndf+Nr0RKYAAAA
X-Change-ID: 20260728-work-binfmt_misc-selfpin-d55b1794f0fe
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 Farid Zakaria <farid.m.zakaria@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
 bpf@vger.kernel.org, jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16-dev-cca4b
X-Developer-Signature: v=1; a=openpgp-sha256; l=2423; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ddAWSVNTGaeuz2ONnKE+rwJz9pZUjTBmmLP2VAVbfC4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRlzP/XwFq6a84W4VNne282vJziFcf1/AM7V/uDjHmp0
 lqLEovWdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzE+g3Df+dXPjKK+z6kmrgX
 8un4KMWmnFUomHJ65VGfD9s2HTg1lYeRodP89Rw+ltKi7oAHGi5WytO2OM32CF8ga86apz6jbes
 1HgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AC53414000C
X-Rspam-User: 
X-Stat-Signature: kiunygaiybmuixr11686ubsnrcmx8aw8
X-HE-Tag: 1785241602-233405
X-HE-Meta: U2FsdGVkX1/9wiekLW+7hwOen3Iahw/V/BGONllqDpVcaosxM3KGn2lH0dcFZnsrS109B5mxoEaSgLrYPiJmr7wYlPPPUfn14yuOZMURYnbpZdMWvE4KwA6GgW4t296IJ4rlsxIRKZBO2Az66scj56WGm33zKCWtabwR1+kFq+26Vk7gTgjZlErHpXQO2wtAAVHlNWi5IAJeyvmX9efox6EsAisijguxVyXiICOYzVScRmYp/r5DNmx2Br/faYSF8MjAC0L982gZkx8XD54cplLrdGh6OxHyrywKvnb8Cs6DBRmPSUF3epEd83oLJsxx/AhN3e2qbWl4uAy3bejCEKlX7dLrtApfQDTrUP/nbPwFgseo2eepUx5SR8IieIUj9QXAK38dgibW9VDtthRfD+23JgQQHVX2sQvHOGIuGhmhQuojruNDvGFp+naGnFBARsvJTyEppOMXXG4T9/JRckUvYHGWIIgQJfi452s8gBVJ9xUuOIpNjAES156pTbxJkxOtldnNdeTpj6H2I2rJHiqc7mTt7hZSOsTZ0udYIuaJTFe1UDENrV61j5hMy4d/wu+QAXBQCPAfhdWnlXV5u32BanFKVZQ/NOu5P6gxCMl3LOx611S8ER4DemIVVzlfNENLD0Ef4c4Nct4QtBDMItmg5BadLCt+RxXxfnbqPyPe37J/m6Qf+7jzJPZ7D8svn6VVWMkLFloWjLk6/c2v1hGDBqyQX5JZ0XmGR4Y0H+oHLa1PGp+nh7awCDz9wW+U3MKxFVgQuV3igVG5vOWDFWZU7sX7TXuX7aSpJQHNM/1jRk+7/haPMMOMsJ3htcPanF9gP5sGWGiBnx1tnbsMdmOVW4DcG/Omqjk0ORJvZ2mMbeRDEsxAMVSsmvSWPV00Abdh9fKAbb+XHopvbH4oLOECTikwkAoEfzl9UK+hxdxMkawjmtcxiaSRV2YeeoGeZ37jSH21CfI4chRbGL0
 2jmvUl0G
 BZMyxkdAIrB/H53bf4LO3LZWCEH5pTBy76QuviUbp3LRcoigt+XVjgnAC9u1okGda2F4exiX+4D0XzI/svHYF85DkmTTcWEHOYpFtSLf4JdZhtW7Ex32g5B3akR3DtZkmQPWrx/qCpgAmFokK0Tkn3pLa9VbbVEZReWOgfyTHWv2hzFV3bsn0/PfV4KoqOTDJ6rERS1018mFpAXnP3KAUTEjLbQr/AqiTSlx7281DhNJc2RDpt+6UpG91c0G5HhdGIdHaaVx3hl/fZbVLTfRAmpME6mH8posPXlzhJk9WSL3kKfOLsnQQQC4y1Ol2eIxsZlmvu6UFFwV+JAHqgbQtA6zTX0Yl+qqPTVZpaJcYusa6im46YrBbrhLXsXHSULotQ6AmUodo+VDcs+Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An entry registered with 'F' opens its interpreter at registration time
and holds that file until the entry is freed. Any entry nobody removes
by hand only gets closed once the binfmt_misc superblock is shut down.
If the interpreter lives on a mount that keeps that superblock alive the
two pin each other:

    binfmt_misc sb -> inode -> entry -> interp_file -> vfsmount -> binfmt_misc sb

TL;DR the file is never closed. Once the mount namespace is gone there
is nothing left to unregister through either.

There are two ways to trigger this bug:

- Point the interpreter at the instance itself. Its files are regular
  files owned by the mounter and both bm_get_inode() and
  simple_fill_super() leave i_op at empty_iops. So notify_change() falls
  back to simple_setattr() and chmod +x works. We never set SB_I_NOEXEC
  and so open_exec() accepts it.

- Use the instance as an overlayfs lower layer. The overlay superblock
  holds a clone_private_mount() of every layer until it is destroyed and
  that clone is in no namespace. So umount_tree() never reaches it.

That's a DoS. And it isn't only the superblock that leaks. It pins the
user namespace it was mounted in, so every iteration permanently eats
one of the caller's user namespace charges.

So let's just do the sane thing. SB_I_NOEXEC makes open_exec() fail on
the instance's own files and s_stack_depth makes overlayfs reject the
layer before it ever takes a clone. That also covers the ecryptfs and
fuse passthrough variants. What 'F' promises is unchanged.

The stable tag is narrower than the Fixes tags on purpose. Before
sandboxed mounts this needed global root against the single instance
everyone shares, and the change doesn't apply to those trees anyway.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (2):
      binfmt_misc: don't let an 'F' entry pin its own instance
      selftests/exec: check that a binfmt_misc instance cannot be pinned

 fs/binfmt_misc.c                                   |   4 +
 tools/testing/selftests/exec/Makefile              |  10 ++
 tools/testing/selftests/exec/binfmt_misc_selfpin.c | 158 +++++++++++++++++++++
 tools/testing/selftests/exec/config                |   4 +
 4 files changed, 176 insertions(+)
---
base-commit: 744c5dd7c3c92dc7cac84a028934855cd9536a3c
change-id: 20260728-work-binfmt_misc-selfpin-d55b1794f0fe


