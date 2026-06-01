Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14FA3CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 16:42:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D2776B0470; Mon,  1 Jun 2026 12:42:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AA886B0471; Mon,  1 Jun 2026 12:42:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C01A6B0472; Mon,  1 Jun 2026 12:42:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AD4C6B0470
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:42:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 957F11406B3
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:42:17 +0000 (UTC)
X-FDA: 84831911514.25.D7F0248
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id D6F8020002
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:42:15 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dN2iZrqR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780332135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=teSdp9I1t1pRWNp/a7/eGoyDMHv3wjAOGwFHd06Ja2A=;
	b=q7gVM/NSsotFZj7QJ/5i6p4ggmjcb/PrjYrRcwKRw6b6No9W0HpmFSmAdi9kfFdlkAktfq
	WMwDSQaqy7zBEDzxmA1LqnG8UVdcSv8eo9wYGIe70CgebKUNuen7L4+hrBbGYsyz5cuan4
	WjQAl/JAtACKjn/P/EpLOyyjtvstpcY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dN2iZrqR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780332135;
	b=G4A/zxttYGAOwRRZeO8b5N3oEHXIIUHgLKLAe7ih1CMXDk2aEYKKaaudPjUvwAkPRKn9wx
	F2Ls73uGe8YjUAf1mQT0Alx4N+78GgQN12oizseny7Bo6+Su+Xek7ZoF57skbs/OsY+M0k
	5U9C0LB5xYM9w2RaDmTiiClnA6ceMpI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0DE94434F8;
	Mon,  1 Jun 2026 16:42:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA65A1F00893;
	Mon,  1 Jun 2026 16:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780332134;
	bh=teSdp9I1t1pRWNp/a7/eGoyDMHv3wjAOGwFHd06Ja2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dN2iZrqRzXR4+E4RaAy6YxsO9Bh+RosZzGkVQQ5KpR8qZlhxfn7UjHG+ybsrgORsN
	 b/LzrLkcE/p4whNsHJV1MbXOOZ/zkgf8WdoYGwawV8FSAwR6H8gBoacmdsOzR8os6G
	 oDH1IUaauW6QHuorSlKqhMjG2U5jxKn4MhGBWT6SBY61/cMFinnp7GrWrrB0O8ZXm0
	 Oj2B/kkHRo4IU/gYxVb0nJPCq3V2F5/Ycp0+POLjcf0bLac7tYCKFXZKrMknrJT+gY
	 E9/TdDDEMRJogiYq811jJR+JlPnFcJLEMKZpjCDGUO55Y5XeBfXqJSK+BqfAYAHAiP
	 Dc2Lva0V1oi0g==
From: Christian Brauner <brauner@kernel.org>
To: Askar Safin <safinaskar@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-api@vger.kernel.org,
	netdev@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Miklos Szeredi <miklos@szeredi.hu>,
	patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Mon,  1 Jun 2026 18:23:24 +0200
Message-ID: <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260531010107.1953702-1-safinaskar@gmail.com>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1316; i=brauner@kernel.org; h=from:subject:message-id; bh=BgJ9kx1/tXUuldxL8l+n8NO5M2/EWoe/peBIxTf96cA=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTJbovatvNLlrOz2euq5KJVS68r/ax6FG7+bO79T8tOz 5zmb8r6q6OUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiVTGMDC9rZr+8fVpQ+U58 ybRti67u4dKZrbrFpkqzdgmD/nptkwhGhssXZ37z/VPKklHqHGjgG1snrZHsoFtm95j5gujhq9w LeAE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: b84ds6k36yehq7y9e7zu1zpiw8pcfot7
X-Rspamd-Queue-Id: D6F8020002
X-HE-Tag: 1780332135-599776
X-HE-Meta: U2FsdGVkX1+n7p9mbTvtJltVgAhqooZr9IHIg4/uBftUhYPQ+sXc5sKCLU/zvleufNj0vRN3iAgq0v/YtqqX9xNSXx4CzGjPAae1uUqAqYdiX7b45o7A2ZmLDfZM7QESnUeFeKkUUK4WljCzj/MZY6aQ/Y30CnaKdaWmSEGfldVtAHS+pfc6tRdHHDxESdxrdCqxvE6KjOWz1VEucPaA8x8odJvyExx7sWQy0lg3ZbtPQQofIO8Cp4zvy+QZYj7kov3Ar/Gx0mqALhhyU8wKF7VjLnk3iBiwmDl12sHwDGidUKB3Vz+9t+TaG4rql49DZFYRBAKD2QYF6gXV28sDr1HVCBRpulL2NXbR5Nqii9WEesnsv3maswEwbCkwQZh5c3H4UoV8ufSC2w0KGgTKXksuTLmANbQv/773d3ZDHXwKyjBxqkh2nqJRinBOL96eAXLEGcqPSe0zWS0MR5MZd+sj9TrnyKH1PqoFppVU7XIQZDW7qDAnTmEv4KU5S5G6uTajspKBHXu05urReVDJQp3b9I/MRleKwQK4ve4mHcAkMQKcxebVvpoGiB/9AQq4odnjPNcGnbA9d1uxaogkCtWEKgrWiV80XdlDUb19JEixMk81BI8THT1JbLh8bt4EwR4uKrbr2IEjNl2/4V1vjzBOzI4J5w2LI8bVnQE9cmA91WHeSaxfSODxzKSx1olhMGbp+5ifuM+t5uJBfDSJnta/ewCY3fVDf5/oohDzUKZdYgJ+H6gK/8mKRZ5gmTwBuUrwCrG7rSjEzhenwyK2na7EEMhpgdC82/NNtLauC+TQpdmp2SgSmt8hy7Lkgqa6xL/F1dSDMNs5ChG3M91r4vSwmYXZ5s7P7N8hr0MNaIZai2fiBAoQdVmmGnjcerYzk/RkO6soeikyB6Z7SDQBSYsUe253b04ShhnRW0ctu/SrF2dOYCk2AEi8H63qsWoula4yMOB8arpKPMXjqkN
 ZEGtFfLV
 XahD2skTHUoc+iUoMAmU2wT1YTTv6V8Yx8689Vvm5iWg/bwZB0dpWMOMuHndcRDvRFDkDx7GdjGNWlX2mlvdaCb6vJ0wRUwuIem/7KxLZlh00HZsIIsbKZ5v8u2N9RHYEBKKW3SsUagVIkgSPvsYM6L9LvzQnMgr5KIiBqe4Bpg8pvvStej7DU9CrSKFI2AF6ZV3JvAlTKMDnt7ZdFGR8eyeZJpMyniG1EwpyjLrB0QQ8HCWeBbEVZ+4Zbv+Ifu/Qxc5BriwqffeXY74k2d2RuiSkbyVaZmGKI+ZtEu+BSUZOylN1sLk0J1WiUVilmHLeYdyLwEV7C0MypWJ3+UGMckrqeami9WvQIt46
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 31 May 2026 01:01:04 +0000, Askar Safin wrote:
> This patchset is for VFS.
> 
> Recently we got a lot of vulnerabilities in splice/vmsplice.
> 
> Also vmsplice already was source of vulnerabilities in the past:
> CVE-2020-29374 (see https://lwn.net/Articles/849638/ ).
> 
> [...]

Applied to the vfs-7.2.vmsplice branch of the vfs/vfs.git tree.
Patches in the vfs-7.2.vmsplice branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.2.vmsplice

[1/3] tee: fs/splice.c: remove unused parameter "flags" from "link_pipe"
      https://git.kernel.org/vfs/vfs/c/a9f7db50ed2f
[2/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
      https://git.kernel.org/vfs/vfs/c/e2c0b2368081
[3/3] splice: remove PIPE_BUF_FLAG_GIFT
      https://git.kernel.org/vfs/vfs/c/7d75aa8edfce

