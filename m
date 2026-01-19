Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABD7AD29C46
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:28:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 086836B0266; Mon, 19 Jan 2026 11:28:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 061576B026B; Mon, 19 Jan 2026 11:28:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC65C6B026E; Mon, 19 Jan 2026 11:28:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D7A086B0266
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:28:34 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 88960889B8
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:28:34 +0000 (UTC)
X-FDA: 84349246548.06.1CCA424
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id ADDDB140012
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:28:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TrsKMHXT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840112; a=rsa-sha256;
	cv=none;
	b=WefRICb0D8s+ez1el/+rTgh++delMPVraiDXWhfC9vJ/luktdEW8msV2rk9vWdcClSsjMZ
	TmVj5KSQDOyC7y5BLr7BWqbfc+2FxFZxhESzV0WSVwe95vurbjRL4Phw4utNP8ZgGavbbm
	wbKIltI/mzws7YumNI8DAun1ueA3n4c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TrsKMHXT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Aie4wuK7gXGDGaR4byHi0y0z34zy74jVcZ0ZTmnF0U=;
	b=X5YxW4VtRJExWTC8eayGDTqpA/l8AfJLmwTshMWqQyTQGzler22KzT4BhjjFlqn/sdMYwo
	2UD7Gp1SkxItvLPvLKpoDI4lKM32jQWON/BjtUE6+ZCS5y5Cbo+gzXFbaLDaEB/qt2R29i
	UGoVEyi3WoZJfmrzs4UACNO5oF74j2o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CB4E643453;
	Mon, 19 Jan 2026 16:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE048C19423;
	Mon, 19 Jan 2026 16:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840111;
	bh=EHb6P72K+L3+Sb6SzLJj1rhREwGw2p+u8b7kNcs5wTw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=TrsKMHXT/sCWcPrmeChQ8L/OZ+Si/PDQhiEM7iDesj6YXekwxdKrB2xnkwdcu92LL
	 HH/uxP2Msg+8sIyiXUDu8w1atUCsdySf5qfsTHdm+lDQKjVYfrF+7BwwTaiLvAFkVi
	 oNHfCi5olIFqrV9QNTwZBWASWLSU/z7pcAmrYhjYdcfvqgE5hKzR5qjswFtp1V9bMc
	 KRNymkwYKSyw01Riv37C0HKrRLEJ2Gi54kMPoML5smsTL5Ikh3az7wic4eVrgz0B29
	 3LAsKLmZoGRnwr4Lgl99QwOiGnsrsk4MrbjL2Z/tqXBta7oDaQAd9r6pLPzwRrSPZB
	 Qh0o/kHlSIPaw==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 19 Jan 2026 11:26:27 -0500
Subject: [PATCH v2 10/31] btrfs: add EXPORT_OP_STABLE_HANDLES flag to
 export operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-exportfs-nfsd-v2-10-d93368f903bd@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=678; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=EHb6P72K+L3+Sb6SzLJj1rhREwGw2p+u8b7kNcs5wTw=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpbltbvp2orig7d9mXjeoPXhSVy0pWJJMG7Y7qq
 gRF3d5VdAuJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaW5bWwAKCRAADmhBGVaC
 Fe+RD/0ZkSh4Nai0BmaiUEvJICbcRTV5b1Lv7WJEwq5JjPI+bTHc3LovjfczVEaYuoGRdG2abhd
 cgg2Bl7HM09V6aZVbhZsyMZIlhRiz9fjdp3BB9kZiBv8QXIWFumRTxtwe+JYKsg33sqzi8iERMF
 s+4mESToF7z7l3CEFigwLlU3h/bDOCbXa76NM+5xsUih79xFHx5c66J/Qpy64Pvxy3SXF2ff+Db
 pYPfkSfWUHFBL0aKVLTX+KO5PJkCQKoAz/h4ytqpFX/swD3YLbUsT+oAtZ+X0fzMqTiYn49Xb3L
 jNYiGvi+iKzQfSf0QFEcNjhFA44Dpu8BmAsuH27BcUkRSbW5XuFrv+SzmIhhSBhhlyrEjqTSAB1
 h4u0eUui+5shxh2+EEhoIoJzAtQ0nhCGs5ixlvEvsekFglUy/wV5aCaKbscbejdIuwgB9SOwBcC
 NaffoK/cGpZB+fBU05w6C0t+4tKDn0S+u1dKfJNSzffOcB27eVll+IR2cI2CH0zNzDvkDVyh6Hc
 tsoqRTfn8CtdfoWs1mYVN/bqJVe9yE25LuB+hvEZNc52LywejSC4iD2wXfw8FkJ8dIf2fsRQgT3
 aaQQFsS1FLzw3naxtye9sdQ4gzqutNjtMU3JZTh8aLQhhnOlMc0MHNgUdEdvHDYBHLPJ0wyPxGt
 Sb5dYA/LEaVyd3w==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Stat-Signature: fgawwtnq3i6z6u78j4kfgodgcoirmkgw
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: ADDDB140012
X-HE-Tag: 1768840112-723037
X-HE-Meta: U2FsdGVkX19J5p804F+WLCYUfo10x73JI5nGfUXBaWIeXW+9T00pAJ1u1QN2upRn095DGAHTwbdmQTfMyd0tjjFytdlDamI+MBpeqr13soggZ/D2ZOtk+vU55bV8mI82La/L61cQb3dGbr7LfJ/jvWt0yPnPdmalYkQKp6rOqAx6xEnLbwM2nDVPPD9Rf2U9cBupVkGLafZUxJPCXjLSNG14A66sX4pOWvVzTJYIlZE6iwzZhI5Db8xGVVESVNIVNaoIYhwZ5KHANFcm4ANBww2vhCysceihYkR7thBhfXbhpT3sBJKhGn9rguWncVArVuUSJkwSpUZaAPT7bTROrzB1Nl1s/kV4wx8dkwqWXZ+1BrWVccOkLT3iW2n+QOEIA9moWLG0F17anVN9DiFpwk0/kCQ5nA85+bdalNuQOQrEm7sVy3yKO3g2Ui0T2LUvjhPZfkk8PZXviznBb+6liWZVfzeSUONi8yglmOwPgHR2j+ex2obOW2XCxnA1618P0TX3c1P9f0im1POxbDLG5NMWPNDKujXGwbZDzJxMWEkMKMIxd3KkwwYf5/yQrXM22t1h1+qDfhwYyfzTrcfcE5t6tncL0VjTwRHePzEjVL9Pqxzq0g+ninMqA/KFNixWiFmoH8yvIU+C9HJ4mc++hvdGvBzKW5mESysCeJQaL8L5fkrZIZeWq+AAK4o7YHWsfAdIJG6+7WJgvsJrTv2yr6hlGMKI7LeUP1H6JwIB/rGUV/DMwrAJFsSyP2+46o2G69ZHA2vo4khX9sLAoqHdnumUbpzLKOPns0SOUUJo07cSWspNaAd/7msnDPl/N+R7m/UZreB8F3yVpXWcJKtqRm0tMY3d3VqGqEqADebCA23qYr/KEVQKJrSldvW0lgaqOrBP9ml/crw2aGgJs5Dxfx2ZSQT6wycVIA2CjQQp12LVUDQVbNgsVxbh3EqjbCVnwt4DWbs4oBZ5X0O+VUF
 zGhkT9dx
 13cLC1C97LmSXPsTP/4Tj2RRtcmtEJnsibeJ7Wsgxn4bdrXTbtpRZPt46INiAd068Ha2aNnOXY9fXzF8IGUzrXMQialafqMgR/FEOsq6hb/ynMBocn++oikJa65L71MxzFdEjeNqGUHCAfMMjKvcrg9rrFuI+99XSIsDxEkInAGahm6+Mw2E3lu5E6GSjkOlyv28mC/03Y6QNRbRK4yUnR4EMnvSK2dzHWeVDQ8oBezKUbh5b1/Rq3ypzC4GK37eZazKhWPRvXI+y/SJ6ubt9o60izk2jbszqzq6jXRIeW/FMzM7wHkAdK86ksO1Rt91nJGgvzQJt9uoIwQbNeMTNHqTVJdgu73c7kHfmtvPAdfJzFRtnnUwoDZFNEVXLMjBfaxV+mu5c3AWXFxX+qjFfqOnQ545X4O6F0+6dGlEpaEKJH15KYkxTzxbk/MhhpZ/yvJ19NtwVr2F+yoKpNTOTTAofz9pbiA5GKvCkR0ZKSiZCu4TGAeXpckZxmuF+fuPD0LsHT/QUh7iyy6k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to btrfs export operations to
indicate that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/btrfs/export.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 230d9326b685c4e12dc0fffd4a86ebba68a55bd6..14b688849ce406b2f784015afced2c29422ab6c3 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -304,4 +304,5 @@ const struct export_operations btrfs_export_ops = {
 	.fh_to_parent	= btrfs_fh_to_parent,
 	.get_parent	= btrfs_get_parent,
 	.get_name	= btrfs_get_name,
+	.flags		= EXPORT_OP_STABLE_HANDLES,
 };

-- 
2.52.0


