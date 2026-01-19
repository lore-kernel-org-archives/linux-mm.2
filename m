Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6551D29C41
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:30:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BFB86B02A6; Mon, 19 Jan 2026 11:30:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 177066B02A8; Mon, 19 Jan 2026 11:30:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 096FE6B02A9; Mon, 19 Jan 2026 11:30:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ECA846B02A6
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:30:29 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B6395B6A2C
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:30:29 +0000 (UTC)
X-FDA: 84349251378.25.7F96187
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id CE5E8140015
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:30:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z5mgImMY;
	spf=pass (imf23.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840228; a=rsa-sha256;
	cv=none;
	b=wH4p6ZXz/2M3xpxzsvpHPoQlxizZK//2YQMaT7aIvOVeFgT3JpV8j7jZEGZ1lBYPABouMI
	DrpnN91qkdsagI1SSel89PAakCJTnVHIv8Dwmn55J7wKA6iHSjkMe2oprewA5o+jguCR9H
	0bKBAKrVeH02U4t99CV0J8C1loz6H3w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z5mgImMY;
	spf=pass (imf23.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ehBSJ++W2cPkB0J1WK/qzYleqmCU+xmhuZ52acFYXD4=;
	b=WO1xEqLJuc0d28/HFbRyc/yAKEBClPq14bDyiwxXGZ/yJelB9rJLm8LVedpOdVOnp3b4vG
	IU+tYJw6RNX7juKvRsxcpy43+Sn5MOcVUmqtI0qlkiKJvr+Wq6TW+d3en5xg4oEbPLf9Xn
	n+u2kAJniKBTQv/u+tkgwm5hR/LJip4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0479143394;
	Mon, 19 Jan 2026 16:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD2BC19423;
	Mon, 19 Jan 2026 16:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840226;
	bh=Sci10TD3wPs0X/nu0ytauQ8Ud8Tj5YY+K+HKIyo6zgs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Z5mgImMYuu+vDaC5OsfyoFU4eAFJAkeUyQjSB6CRWktgD4KibfHiZ5CUg7Ays48l9
	 EjX1kGAqQQ+zZZ+UE7TUs/w3PWzjdeI3SjHaQUfxMbdJQjJNZGwYgqnowTGdH9AvHx
	 HdNKl9RxTyhrRJRxujGvwNkZ/Ifho0GuYndVwdirg+j36y+QMn0GE/ZUUpUPsm/s53
	 6Q3Rt2Tm7RurcqvI08fLVS7BsOgFE8BKgiHmQBA4X/eT+4hE4wfXAxn5WbcVQwMCyX
	 vSUrwRUb76V4rU/VmlnCa1I+cPShEEdWszkToxnNVTYZmhAyoHZLsmqagjwkUUQ9IL
	 vBJ2dSWQ0auqQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 19 Jan 2026 11:26:43 -0500
Subject: [PATCH v2 26/31] gfs2: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-exportfs-nfsd-v2-26-d93368f903bd@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=670; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=Sci10TD3wPs0X/nu0ytauQ8Ud8Tj5YY+K+HKIyo6zgs=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpbltfAB1NrPj6vyLXaIZcARRV83kUQ0X6tnkqr
 rSH7KQc5nWJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaW5bXwAKCRAADmhBGVaC
 Fc8YD/0T6/loL/0QUUXJpbqWAX29+wqZxsSH2ChHCMfmatnCljrw6rJW3ydd07PbCixgYxwa7dH
 zSI0UF2LvqlhJ4mr0JxiBXQN7XS8u4Lo+ji3M/Bdy7P9S2bcTQ01P8NbN7pWDALsXrOr4UwH/O5
 eIGCDRIvfIgg/JtilUi5Xw9J+WnBRW2/K6XL++bUEq7yaQpKuM3ExrBRnr/pLhRRW8KEbhOaXjk
 niizneAenTAevWvDRARxsjp4DCTlaVlWjnR5NKvqzsWbG8yNALPj3vH3g7tXi/JMieDIoovTugr
 zXQbQCushHy74btLy45zEvS0yxgoctX+LagcmgmtXgvYi7tksxbpXuTkNIpjTVPubcoN1wK5lVG
 0f4yqTtexJUdRyM6ZQSxbaCuvTulJy9+m/X0PvdfOBbH60lbjJfdkrY0CPVfwbzPiGqA7MzVo5u
 1is7wiL/+kvOlN4wDqKpE5hDJGZ7rlEOp+CAjjGKBYuWUsfMEcZ2aNC7ux1WmiW9qSjYbit4/Ua
 qnexquVoCAxIWVeOuXSEcbt+cpR3DW+9+uBYKgAINDiLSKyVAZvtG0z4IyOHVSCZ8BqpFOD1OEd
 pYVBEwtKLQpy/jKqBhtFB4GzhRaWAE8rKVayjBX06AYj+r+wYbEdOiHXCjjVbuo0EaMrsZrTArA
 /DiBfK7BTM2dyIg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CE5E8140015
X-Stat-Signature: r8jfqitu7kfxqho9rwndrqhqdpkgry6q
X-Rspam-User: 
X-HE-Tag: 1768840227-703259
X-HE-Meta: U2FsdGVkX1/sn+ddzRdIISBqjEDzxbR2Wt7IhtBvp5jHi496AlVNUYgCH25UvKes8Ay80iMblUvRKs9X+nVlV9MgJTtkykoA7ywgKLP0kt2JVQKzBnoR2l6F4UsLY06SuGw0mSPyzSnCxToWN3XSa7+ncfD4CZnXooFXdgorOM4XTOvjbycmrxO5a21Ip3UAhBb22RugVnVU+bYOGbZVtfRSCylycZ1u6/R9qbA6nGGQSqYjzQlQEV3L3l747fNIBF+ZYaiyM1KqWTI94CkY6OR2z6ox9JAUted6GaL16OMiea5FE6yuvdG4l5dxDOzdyWLvLeSW3Q8GhYYQmjWq4BLraXT6xKCpWrUzm/GKhAZzkqTbUG01gfELNP8qNt+1+sMzusSCJIouDvqgZ1fdcgTahrrl4Ggdm8qUBbVNDrIH+OxAfXuBAox53C4AdAbYE8iQIim+i0+OSAwmsrbMA1C+ZtlV3PydyUfBHThmhxx1mVOAd31Kx9EPQHEaJ8L0Z97QGLf+47Ezawyjn7iIke9vMWUKHoUpTwCLRQfwjN+QffP8sMtvT2NB/IZgaKapsUozQbD+eV3gnq6zRnbdyw1IyMpkjijGqHxg+xM9jiFnAHJl3anL7+RCLLYk9VRbmNuAlXI+uGI0vpukppy5rXHMFz8OZr66XM7wQLIrtx+Rq6k/YBvwFRH/5Ok77g3G30EDwCZBlk8XCvaG6eJ4Pt3PE2K5dZgL3Ci4ZvmeAJMqA6MOJZaCO3nmzOYG7yCwUoCT3R1eQmxENgbCeocSOz2R2TbOnp+IFRsi0H8kVeUeYOl72dpAEZbKoAKJB/1EugYzR9bH5u5iF0AZrGv47t1wF8IdyvqeXUL/Xbs8EPiYi97iRVBr/GS9yiEUzt/xspqgytWmxb0ZW4qC+oxbeLTAdkjug5nBhdQK7Dzk3Jq1q5CVdMgckmxNnWqJUgQ83LqavuNruEuMbbeNtnB
 8USCM4bp
 KfyDyrVGcQsYKeDaETZY2FYthrDDrAkb5gczN0ETUYBCYv/CHd5gfG4z2n1EYi5dLKE4GIKPVRY472cWXg3Y+8caGuZ8fwRB6Q8waQe/gZ2Xw/3DB44PNIabX3e068nLBgAbg9xN7f3ZFzXAxE1VUqgnayfUxFJctm6bHcNo86D5C5fS8BlTQtwxZ1gZFqj1o+AeDudmX5j/yPcDw0GtIOVMC1fX0aqeYLYup3y7EMJMuOw8uMWB8ny5vTfItzfcULwqFkqkD3+Ac7bHMjzwPOQvghwLBrLpt2e1toQvWf6zdsHeSKM6PEU+/tlZwOFEY6U7i2nyPhFwA3Lw295mnfEUgLUzXKPsBXIFXSmbFN+dEleKM3Ek2fgqNl2PqUezbqJZEM37Z//W650BkNKZmohL0q2WUYH/terjqMc1dnoo4BvqRL+WyS8f2h0qWYg31/jczcdUVp+l1zL3d4GWZaP29qj/FtzbIWxJG9TxvuTVrldpHnJwsiaVzKLuMm6yxDTvy0L+IiuPjsuk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to gfs2 export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/gfs2/export.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/gfs2/export.c b/fs/gfs2/export.c
index 3334c394ce9cbe26969809874a94e79bf068b11b..43fd2203b34fb0894d2b71e50278e5cd68216ce7 100644
--- a/fs/gfs2/export.c
+++ b/fs/gfs2/export.c
@@ -190,5 +190,6 @@ const struct export_operations gfs2_export_ops = {
 	.fh_to_parent = gfs2_fh_to_parent,
 	.get_name = gfs2_get_name,
 	.get_parent = gfs2_get_parent,
+	.flags = EXPORT_OP_STABLE_HANDLES,
 };
 

-- 
2.52.0


