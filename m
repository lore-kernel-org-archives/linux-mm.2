Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58B9FD29C40
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:30:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B38426B02A0; Mon, 19 Jan 2026 11:30:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB7E06B02A2; Mon, 19 Jan 2026 11:30:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A38B6B02A3; Mon, 19 Jan 2026 11:30:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 84CBA6B02A0
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:30:08 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5372513953E
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:30:08 +0000 (UTC)
X-FDA: 84349250496.23.4066D60
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6E95A40013
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:30:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AWFPBI+D;
	spf=pass (imf17.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4hnkHhj6VpugZZG6VDwQVVf1Gx3N8PdGnaR3BX2i7Ek=;
	b=GHJq1TgEXX6bkJXhkgnNy3J/2bpDghgdF/bt1QHLHDTXGeta3rI9tbc+S+H3q49JhH792w
	7be2shYvBa7J2eD9DF4OpKPUQThpzR7N73yJ2m7g9CX8qxh+Yjbambhfsj6g6NJp+y9y2z
	3s393Sb458IYgxUCqF5dL2UqfUdN1tY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840206; a=rsa-sha256;
	cv=none;
	b=5796DLjEp127rJviCTAP//0ZMNDvvdcQEwE/1WKYbJUxiPPsTFeSPR8d7ZVnIO5WRqyaet
	W7qGHkfM4UiwHoa/YXrutcxjxKaBln+VoJPHbi89MvzCdz/NFlRnnKXoFUt/KBGuzpWWGs
	SUaXEUdPIKUNSVkT97oPfgSQeS/QsWA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AWFPBI+D;
	spf=pass (imf17.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 894E643394;
	Mon, 19 Jan 2026 16:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655B2C19424;
	Mon, 19 Jan 2026 16:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840205;
	bh=vQTd4Jo5nWm0BtlMXBC/zeTqN+exhfZBAyMeslzDnKc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=AWFPBI+DGZ6l+36k9cUcFG0hNFFKJ0WMx66O5cEYb4l62RB3MHZqQrMyu+l8KoFc1
	 TGdwQ1vZg0M8ySuA4DCPjGa2HYdhlWYqJglFLc8XmqEPvUHdJxxXLwvvLRoWe8vbm6
	 0aPh3Sk1rMoZ6/5Omzvw5StQLtIn16fGFg9VDhx/A2qqLLjS4Nqm5rKYDXgHs8gK0A
	 ok7XQ/JY5MkIHVzgoTLqIWhH1U/zaKEFZ2BnohVbeU/Hd0P7u/5wSiCw35RX4erZMO
	 zxVhM5nZ8z9dtS9jXJmWWwdhg+pY0UAUbzMiE5GZfJeJOnjoq3NzGXfuvGSE4FaPk9
	 OHv1hYqPynnMg==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 19 Jan 2026 11:26:40 -0500
Subject: [PATCH v2 23/31] jfs: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-exportfs-nfsd-v2-23-d93368f903bd@kernel.org>
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
 linux-doc@vger.kernel.org, Jeff Layton <jlayton@kernel.org>, 
 Dave Kleikamp <dave.kleikamp@oracle.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=809; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=vQTd4Jo5nWm0BtlMXBC/zeTqN+exhfZBAyMeslzDnKc=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpblteCXSwo2a+8YGLaQolNYDg9J+5h600R9sGY
 lTKG5OkIWmJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaW5bXgAKCRAADmhBGVaC
 FQ4+EACdlT3kWBo+HI6ruDanrebZFrOPBF8E+b+dbln0HfDwLb6pNFCgmgym+bnP/ZirP+ltIqG
 uJNypDGY1ttctOOFStuOce/RWd3J82M2fSTS4KTePxme9FxgWvfzlPqz43ArAM+CIkWGVgeaGKd
 mHaIKzNzUqg1BfEV3B9neORWkEe7FLYHuRjtd1leg8qBCG7g/NAJnxTEf6IhLFb6zUVI8WbEwXf
 SWw8IxyniAcvvpWPhkQEFgLr0JwYPezris3doWzeAyaa2RJuQcnk/HoA9+0NKyT3hW8nQyO4Fe+
 s5DfgIZe23cBvNTYaSp0xBbkqXcHoOX9oowmU7Y8Ke2Qk/sO3PNoy1GWQUlU7U1JMGB+Rh/80vl
 gzuUVkFpOWWFtTFkUayRdJta8LzXqmKzllI5a6Pi0c73/LLUxESAQFBh6barp4IuMUnmulh/03j
 NejtTplGwWPkizI1bVDryTcbMGjt1rPCpyN7gteUKA9FYFCci2pCBozoV8YVMbcgu8bMO0xSBj3
 g8cdqKbuYMp4kjSkuCkG/rs45okw8w7j/eQ/cStRAbHsUL9+mbf3ALihR7DcksQu0or91YqhDru
 hbkk9t9wwE/tcAokrVSpplMMM9ODfSLZ4IZwKUeWEpvMoVv3um/271BHFxRjaAyh2iKbaAlStLk
 7XhpMkBicI0ylbA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6E95A40013
X-Rspam-User: 
X-Stat-Signature: nrnnmicrdabtk6npopzdpmz4e1adzxgw
X-HE-Tag: 1768840206-262124
X-HE-Meta: U2FsdGVkX1/1hs3meVVnHK/fomdGv3QQb+Kjjt4GObeB38GrU6oggz3BsqDTSqc4P/iDcOjNjNT4Vw4kwRGeVX9yxQ9pWM7Pg2eafxl7YzoHf/ugxrPOO9Of2/531l06tIxlVxq+jhwDJLJcVZq1s6yf/RwwoF58TtFUClRYdIqUD6/l1xXnItuwA0KtmN+f1Jefw5c9vOh/CahlQ86iEg0Z+OmoOWWsKK5VlTs2ICdfCmIxTCJKcH8Jr2rMk3Zh5r/DxqVkw1ORUQfpSqyK9igglmZAZD/pJtFEPXIlNJNQnwKFdHN321y3ZsheQCyCrHfD8LKMIcdMX3VwLLCZfHKUXe7c+exMCrz0KR17UkKfCQdrqCm0fYvBtnDkNOUjxMutas5PmQae4Es5BI1UO7voZORRuDnpkU2i4YK5+TByBbXdmGwuNeTJHkO8KCfEsUSqv39ZlnUdNIRTWdboKxa9CeNerJn1ia7ie5gTldbLiI+xU6mbSYRg6lgpkhdKhegSH8L7aPlPkMLW9xdGPkoaTVTvylfzQ9T5//Wweu01N0J6zRoT+WCjFymziWdvAmjQc+05OzLHX9kDPJf6D5tNBAJYVCbL7MLwZFWoDRiLhic+degslABX5ruBwPEpnZcALs0CQlBJuN7LY1xf2IUJvZj0YEgF8WqnKF9o3RJdl3+3KVckCxa9zUDDOjGDFRLexEAsMN/pKABxIFLQfHAo6rFHq6O7Tt2w6c1TP4JAkYFSI9WPVPuYg9QLPHj09HyRvlW/BsQO3ItCtET6/4/mXra2mM0j5LibsPsLsgBBZgAU7bubHcHMzg+L1rs277dYiti4X7+zDWeom6uk0KuzgWwe5B1lGZvWoQIzm9kZjEM4Sv0pbehZdw/gazC7p6GLckHdDL+lVreBbMroRDU+IG44mtw32KoGg2B7V9cP9hrouGNs9qr0SsU+BkhEPC+A9DBLp7ufB/H510B
 qSeSOVGp
 gPWYY979rIuJrXrX04JkKCg7TbL3++xqxnDRyx+0Lm0AVJAWGag/8X6ngNFXzjJH9Irg0UlSt9OakEDafmlQx9sAqR/sy1pz3RvhLAXgeWYgHEO8w/bUHgbzWFeWPvBh5CLgCyTF3VKizWNRBdVlmqSI9F+0DjMTmKNvDoD9V8lvZ+SMKw7ON+S3uj0fbCmBR5P2BUOKZa8Qv9VQM2Mo7zVkf7Lk1xuQBgUJw5HZIKNLvGKrG2d0YIkGsCDGaqO/eUtwr60ZYYHT9pi1T6l50OQqQ4OhAkwISd5sos9wi0Obhksa2ADzMDi/TJn7iM+EMl8E76P6VToFaPy0ECfupkTvE9bCgqt0UhC9hmtzC+U1xQNRS6H5AhMFTQQgY7n5e1k5m4MBI1Hz/M0hiJDiGV4Z4kLVB/61yqAcurtaWgwbGv5U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to jfs export operations to indicate
that this filesystem can be exported via NFS.

Acked-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/jfs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 3cfb86c5a36e8f0c46a2734a24fba6ffd36c7ad9..ac9b6d754f8c203baa7e91362aeb0dc9b3ce209f 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -864,6 +864,7 @@ static const struct export_operations jfs_export_operations = {
 	.fh_to_dentry	= jfs_fh_to_dentry,
 	.fh_to_parent	= jfs_fh_to_parent,
 	.get_parent	= jfs_get_parent,
+	.flags		= EXPORT_OP_STABLE_HANDLES,
 };
 
 static void jfs_init_options(struct fs_context *fc, struct jfs_context *ctx)

-- 
2.52.0


