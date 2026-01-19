Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED6F5D29C47
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:27:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41FD16B0274; Mon, 19 Jan 2026 11:27:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C08D6B0276; Mon, 19 Jan 2026 11:27:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27B7D6B0277; Mon, 19 Jan 2026 11:27:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 13DB26B0274
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:27:31 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A99691A01B2
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:27:30 +0000 (UTC)
X-FDA: 84349243860.21.1AE3880
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id C7D5CC0009
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:27:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EZByvzF3;
	spf=pass (imf22.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OdRHeWuTnv3lLxMUOwBSJHWHutyQwfmJkGw3KK+X/ns=;
	b=t9kKvgKNjfWXT3f1s6Kvf/lQmo5H7vgWAPbifwDz80wRtYeVcBjw6yaUzHZwZs4PoVLk65
	5hluvTrOj8sBShwQF5BMYRvC2o184f2GBvvFJC6Ln36tXTaGY+PZ79fe6/L2hu+O7ZTNfQ
	9PHFfoU5+8VGtVoa64BbEZN4oLfdFBo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EZByvzF3;
	spf=pass (imf22.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840048; a=rsa-sha256;
	cv=none;
	b=hk98FnnW7eRX8TAPuGlVADCyLEdpc1zq61KEm3TKGG5rdEauFzySC/5mfvz1vo7BYGulEM
	JC0gTe0wIZ87zptIZnWgXqxakWRNlnNlmz2vDr9zEFYUzjSwBnFrOtwikZHENgO7Mulg/a
	mSBKEnO7BhzUWvrDoSE664FG8PNxxng=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8487F44514;
	Mon, 19 Jan 2026 16:27:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84ED7C19423;
	Mon, 19 Jan 2026 16:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840047;
	bh=kHox+Z6m0SGAxt8eN704T4oKG2yhOc62IdYplYhE+GM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=EZByvzF31znoQEmDHc3SC4xaf0M/35g4xjcVwooMk1FV61HXxLESS5MiLKX6tWFeo
	 Hv85bBuLMqHqez3qHBscy+CtxbnArxV4QeHTrTHLdSh1NMKPN6CGz094DCBrAFgM+D
	 AjJf/kL6odSToXoYbC0BwY2wXW9BcS3BGnPOFuFUygBqW+EJJ8lAxaO4a8DC3mSQ8J
	 aALSFez2K6qCZWewncoJbLr2GlmdBWTKm66qurJ4sNUMMc6kZedy35j6ubnv3HJVKy
	 Bvebe3CcZHZIgOiFzpF4s1XQUiXn7842k1apwk6XDZswZtqbHhYTTAxje/WAZfxElR
	 uszu+UWz9bfRg==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 19 Jan 2026 11:26:18 -0500
Subject: [PATCH v2 01/31] Documentation: document EXPORT_OP_NOLOCKS
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-exportfs-nfsd-v2-1-d93368f903bd@kernel.org>
References: <20260119-exportfs-nfsd-v2-0-d93368f903bd@kernel.org>
In-Reply-To: <20260119-exportfs-nfsd-v2-0-d93368f903bd@kernel.org>
To: Christian Brauner <brauner@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
 Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, 
 Tom Talpey <tom@talpey.com>, Amir Goldstein <amir73il@gmail.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, 
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
 Chunhai Guo <guochunhai@vivo.com>, Carlos Maiolino <cem@kernel.org>, 
 Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, 
 David Sterba <dsterba@suse.com>, Luis de Bethencourt <luisbg@kernel.org>, 
 Salah Triki <salah.triki@gmail.com>, 
 Phillip Lougher <phillip@squashfs.org.uk>, Steve French <sfrench@samba.org>, 
 Paulo Alcantara <pc@manguebit.org>, 
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
 Shyam Prasad N <sprasad@microsoft.com>, 
 Bharath SM <bharathsm@microsoft.com>, Miklos Szeredi <miklos@szeredi.hu>, 
 Mike Marshall <hubcap@omnibond.com>, 
 Martin Brandenburg <martin@omnibond.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Dave Kleikamp <shaggy@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
 Andreas Gruenbacher <agruenba@redhat.com>, 
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
 Jaegeuk Kim <jaegeuk@kernel.org>, Jonathan Corbet <corbet@lwn.net>
Cc: David Laight <david.laight.linux@gmail.com>, 
 Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, 
 linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
 linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
 samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, 
 devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev, 
 ntfs3@lists.linux.dev, linux-nilfs@vger.kernel.org, 
 jfs-discussion@lists.sourceforge.net, linux-mtd@lists.infradead.org, 
 gfs2@lists.linux.dev, linux-f2fs-devel@lists.sourceforge.net, 
 linux-doc@vger.kernel.org, Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1145; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=kHox+Z6m0SGAxt8eN704T4oKG2yhOc62IdYplYhE+GM=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpbltZnWuxHPCsFVnqSKxTO4m+b3RG7VE55J4gy
 EWLrXp3yVmJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaW5bWQAKCRAADmhBGVaC
 FVjvEADKTq3x5BhOtt6Qj64fRRaPHGOm6Bc07y6w5GpnNyCiIQM6aVpcn4F9ORvzukxMQVO/XqV
 Gc7pRAymSYI9s+GWvc1x0IU9sGCQpVsndLJ1eMMzaSgzVz8dIezRd7/k/HS4GGz8KNiZ2jDVfnp
 c7wjN+XdRQXpWC2qRBgezSkBBYO58OTuQjDA0xv+b8CbjqBJCbdapflO/lt7ryNb+3XN8JC5dOQ
 YIhjhVdYU3nTYtg8Wq9oRME1R8VCziBOEPSM7OnYvrhhboCQUKPUNwsEEk7C876Ssr6Xwhzg2+s
 rf7n0oAe2dp7xo79Mjf3XuKcCwQcCR0nZmAb0xVbxOvXhbG+BzkFDnwcv6SPu/LgL+Bz3eELxNT
 IvSpL94cTKsI653HKrBxtZAfiJvm/rxot2mjA7pmc+6jWNOm2djCX+Y0VXRCNe8OqjqjcrEnjQT
 IkV/uSXMwte2MxayRUcDLG1rzsUFA2DoS4bR5w6/iwIQIQWtu9+KsQ1oV9LMsta1GV4E2apvumM
 uiSLYCUypySFenb1mq+t71sXvuaLDoDMml58ewc9RqEz+RxUC/4UtXeB2VmTwzcs77p1HyNq6fH
 inBJXCW40vznVwdr14HUSxVYt3p68U3UNWanqZKW2184K08jTVhLuH2KEneZ9ix1b63/moRMZVz
 RNyBzV2Fd0KgbIQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C7D5CC0009
X-Stat-Signature: aqktorwjdjpfy8ds5ehg66gu15t9hjbs
X-HE-Tag: 1768840048-437599
X-HE-Meta: U2FsdGVkX19AwzJCBv+w9fw38EyYj2XPIlrRD2y8EEKjDT+wdFO51ZGAI8jKASq/TTbtTPmDrCu2TWVrWVI8CZQ/Ld7g6p9kObgbrk6VxSOnTRp5npD6Lf/KHeTTJ/DhTg26pZAA99vwl8xLCdcJZLR4nLyD6i6RCVWWE+vicnhTirTqqR0pdNgQwLBefZSK+IZXRMMAbTohbYjV+7KEB+ul7BWxdC9B8crCRpjqRjh7iAY1mB6qu5n/iCQx8fd+2yu1DI/uJ/WYM7qWaqesTYskLRrjYevMnvGzcn6ozMnUURQueR8CBeh/0l4xmwXXNnq+23/st8LWA3TLRhn1BAzYH9wnby+V38+/Q9tdZsx4B9jOU93vsW2qThrv0DRLTAwAGIPn27avDHxNXcZG2R6NXsjIPG2Cv0m0b5uHJmDDp8NLch6LLtklESbkDJ76hg8E/x7wvQS7kjCB11uqrrHOq7/V+ZjpEnwA++hkNcnUlyXpe9R2WYm8wfRDIMJp+o6eaaUJjg+YWf56rXvqgGHY5cKXd7SMk+W3PDmirf+0oLcAFv9vEEDMxzN+SXQ6l+0XNZlqe+31PsXVb+abpfRZ4tvSVvQYCFXVle01Yj4VK2PtUbn/a0F9OSPul9MlbN+Rvuz20aGRi1+Hm1JdftN46cm6E4C4LMVvE9P4AxRbtZt+F3G3N621tiphPjWcP98B4+Wq6pfoGkFqHsI4AY6IPMPLYyui4apcGArdSP/qD1hqPvMyaB6NtQ7cYWLHjgpjVZXgUvuBFDSwRJL4SXYxwMCTs8Ek5BSmVDNKEnxwxiIGucaVu4GJkc2/I7a97ox7j9c5Bus6RqPFd/Yn4HhvThz3wReIfHz4SQVvdFktpbIxM/ugnw0IAvlbGcFMvlHyiaMn3n7xlHZfAWE5pPnAMWo9fw7/IukATZItd/Rd2RJ2oEVtIm27qvB7Lj50w8DZzMIYEt7Prd3+wHD
 03Rs0Gri
 +9uleTgETZ52fb/GFgPuVEfXFf1tn2xOARokyHs5VFPMBo+1gOv80xXCyL8Wpk5BZwuHxgPa4jZpst0bQvqjOoh3m7bNjKQ3ZZjfX3RgsmwkUlY7x+ryMGCw+v6777f2p3o1g70lQIDOo72dUQvp7L5sVBJSww6BIu8/SKvE0vmb4C6ekfJhD6JkcQkU8JiEmqx+l8kOIb1GvygNDgBkyh3wRgCFQQ/sEkhdtUjLxV3M1cHJz9m/aGvIcEKnP6NUZizZlhRK537IMoCQ6i1zOAMGCybVXwsJ5FOvbuPWDU7BnY7ZVfbOOZK1gORb7P2ddNsBVq5u2P9FjYT1y9jchfqfQMjGeqmfzhJuD5WPGJ04OWBM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This got missed when the flag was added. Document it properly.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 Documentation/filesystems/nfs/exporting.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/filesystems/nfs/exporting.rst b/Documentation/filesystems/nfs/exporting.rst
index de64d2d002a204c5460980c898d4ec41fd43d47a..0583a0516b1e3a3e6a10af95ff88506cf02f7df4 100644
--- a/Documentation/filesystems/nfs/exporting.rst
+++ b/Documentation/filesystems/nfs/exporting.rst
@@ -238,3 +238,9 @@ following flags are defined:
     all of an inode's dirty data on last close. Exports that behave this
     way should set EXPORT_OP_FLUSH_ON_CLOSE so that NFSD knows to skip
     waiting for writeback when closing such files.
+
+  EXPORT_OP_NOLOCKS - Disable file locking on this filesystem. Some
+    filesystems cannot properly support file locking as implemented by
+    nfsd. A case in point is reexport of NFS itself, which can't be done
+    safely without coordinating the grace period handling. Other clustered
+    and networked filesystems can be problematic here as well.

-- 
2.52.0


