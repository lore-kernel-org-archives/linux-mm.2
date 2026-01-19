Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9D83D29C45
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:29:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 092606B0299; Mon, 19 Jan 2026 11:29:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05DBF6B029A; Mon, 19 Jan 2026 11:29:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E770E6B029B; Mon, 19 Jan 2026 11:29:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D70586B0299
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:29:38 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A601566E1
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:29:38 +0000 (UTC)
X-FDA: 84349249236.06.75B6B2D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id C7B73C0008
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:29:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CQhJYRGs;
	spf=pass (imf22.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=unQZIMmBuwBESZfWPZUx8aoF/Z64QFhIVbQkTy0DEhI=;
	b=YUkQjpAK1UJ3OUEEZwxuzUdmDMO8tWX1v7046Rf65l7gm9B+E6pvf0fqKXvsgD+kJmrVo1
	HR7RiCnPB+JweHrf/ouyNzcQDb3j8pe59TAzbzmexq3rjT+Q1SntCtVuuPZl1a2q9fQTE/
	UTH6sjX/EKDk/YIlxMfoHxtXY5YjbpQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CQhJYRGs;
	spf=pass (imf22.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840177; a=rsa-sha256;
	cv=none;
	b=RZro621QsvU3GIsBAzS58SeLOVpZqT0I3rwBkyw2zdDXGPAb6/m2y/O7nYquG+DL48swg9
	ahA6I1vBexg1K27PCwBisGrzR3MlFq7xj9MPqQaYyIYyq0KxHT7xLN9JbQ1Jk8440UJElW
	0hSz+zA421u3cZzUUypDf72iKqt/Irk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D049C432E5;
	Mon, 19 Jan 2026 16:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A2AC2BC86;
	Mon, 19 Jan 2026 16:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840175;
	bh=wU0i80DF0FPqjAJHIRj1jzTtyUWnKNMBQnZ9bzzbTDU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=CQhJYRGsl++lczxBHEt0XaGrxt4g+6vUAYPrRcw73aIRch0FVGyVATEdpccesSqs9
	 URiwqrosG0CP1irk12+e/p6RW108GpwftJnbPgTyy2fk2ZtHaWu7YwXKfTUDCT7YYj
	 habn8bLFMPil4Fo9jX+sOzecRJ5OFTjN4cW2L+RT/+8p/XIBqiQIMLfoTEAaz/wSHh
	 doBGze5VI89ZR4tztzP2HdKsw/to1rJmbiB4hBqqDRpYdgi+Dj6yOzMVJaPZSCucM7
	 DQJ25RKNsgdm2ZepzIPIGXX2yldRuLVlW7b4p7/LwXoa0VcVJA9Oumg369d6XFDOIa
	 NZm1zFyOw6MWA==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 19 Jan 2026 11:26:36 -0500
Subject: [PATCH v2 19/31] ocfs2: add EXPORT_OP_STABLE_HANDLES flag to
 export operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-exportfs-nfsd-v2-19-d93368f903bd@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=724; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=wU0i80DF0FPqjAJHIRj1jzTtyUWnKNMBQnZ9bzzbTDU=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpbltdFQ9b2g6zsfezKJIAwvxbngmwk5KhwfiY8
 +38M8QDAHqJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaW5bXQAKCRAADmhBGVaC
 FVVbD/0SRJlTCFiMglDJE7H/jWRUflYuMXEi8SA2hCybpcjI0Lzhq3Dftiwn56jC0/slUH9eZYc
 9ZXJtO5rQMFFiob97e8ROh5R8oMwf9IvoJEgVnpO/91D+7bdk4yz4p7St+51XuIrbzvSEgdGEAr
 1/Ox4Xs2wr1PzX7Nv2qi516wzYN8pn8Mk86h9xYIqx/eEsKln5byAJOYF1JtQ5E+VtXf2hQ98va
 1yxfDCOCcAxWwPhsjwmXIVinqlwfejZj9y0mBOdaJTScAIB9E55sGMOQgTQnqr4rwl2tvvE77+T
 LCr533OwnRhMTIIoQSiysB24g6B8Q9WsZiKtZDZ2FK5VM+7+hGjBnj7WuU5akAKL0Yh+lQlq4wb
 f3Jdhocl0fC/LsL0xJ6Z+hm+GK3AavJw2cOREDtGmzE/+Gm/okWTQBg28Hfn1rfewYRsEUNryaB
 7NpT7W7kYaJB4F0KZJHEpQyidU62CBjmpds4LOuqg5dUwlyf/Cz41R9qEPolEWuxH9vIrOdcjSW
 KY6o65R+9LmUB5hnJ2ZB7baC8zppQdPF82yaEOO17NEB2Z9O755Vwf2eMRV2kyVz+/olzSvhG+v
 RRvie1TZQrd1n31fdwJYNIrYSyQoDqWTEJSqbkLU2i0JJRAjOJ5sGbimADbV2dyDswLBJTKrBDB
 xyY5rmCt0KvYE2Q==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: C7B73C0008
X-Stat-Signature: 5tbjmhp64uy66oobqeyyp8dseaoj9juu
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768840176-211497
X-HE-Meta: U2FsdGVkX1+lTXe13j6m1R6C46UtvGm23AYjWhvGpujFaazFq3qNg+3EdF7CKGaKoK0dwAgK2UbRUgv6t1FYZTKSv/FKn0kQcsw4r4qDP6NgPcgQXBTvp9tAUgGfvv0ajGR4cyXIU5/Al/tmAlLLSvB/GK6QQMIG2NdBSHxrLoYExIDJSGqYtvL3dW0HZkx+/jRc1rAoUVusmFiIh2s8eA9gVoCX7BqQOLnwxuu5RLNbiIqS4MlJaFjieoYfVL/pZWn9ZdoViFZ0GFh9hMK01dKEqzl7QyKUcDgD8QgjcZjor3KMsvJpTbiY9bRZ2LJbOJHHj7sx1nY/TSg9og1B1SUzwljh6Lp4t6apH0M0YPBc0j49pImtLMRqtKsWVsyq/4D/3I6JFok4h5+RkRQukWubKC0wB7lwsCHQwuks5Ktkwx6uG2HNUCtD0hzHpVIFZLaIf1NLODoYiQIr2nX2mOD8utQEkSha792ULFjUc7zxDLsbLhNQ4ap3EqWfPTuNSgRVVU6dIB01c+XxOki4Tyv6cjlRt1Tf6jaX0FRgY3LIdRsDuiQ8xxks3mzAdV+2Se0fxfx1JpHraiIOjkcfJRk4dBveLej99Rj7cifT5JdLSCV4BN1ESPmsGlifhsWWmE59l2ep0B6/PUPscNgoCs0YVLezqR2GZm0fHpXWb3+jYPKDq6siZu2c5xr7Hm000nGTQxPg2yUEgik8H8ToGYij6+1EjYhBgrfdL44L9+DdiqFTa6i3ONilVZzkXeoEFW9Z70Gz2tYhd11qXwmpaltsCO7UOlL0Y8hJb4f6cn0owfu7Gs/tN3Hq+eRzHedoGljMHiMn19zZsG42kIDRopm+acIobhmjTNwDjQBJxOVe1t6SX90RLsEFgtg+hmPZuc95eZq01Z5e/+ZFZXRZxdpq072zwV03NYExnhyoDCBGQhvWoNWRwTcAM2j5W32UmZhwlyH+2ZLI/YsQ7vq
 z/q5Nt5F
 hoyWPD9qQyeMSYCFCdyoExrE13LxkzYyZ4/u9TUmv90DAvZDrDVv4yx9JMUnAZHwiCzV9S26m5v2p4/TFCkuvYopYrxWYWPqkiPH/9mocJCean/CicC1xe4xxMUB4uAbjs0aR7DYLQmOKpjGDzxa3yGD9Tj8NXnudsxlDnqZOph975ghizJVjkiWaV63BxkSYaZmc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to ocfs2 export operations to
indicate that this filesystem can be exported via NFS.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ocfs2/export.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index b95724b767e150e991ae4b8ea5d0505c1ae95984..77d82ff994c86037c14fbf7a1d9706f1dd2b87ac 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -280,4 +280,5 @@ const struct export_operations ocfs2_export_ops = {
 	.fh_to_dentry	= ocfs2_fh_to_dentry,
 	.fh_to_parent	= ocfs2_fh_to_parent,
 	.get_parent	= ocfs2_get_parent,
+	.flags		= EXPORT_OP_STABLE_HANDLES,
 };

-- 
2.52.0


