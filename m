Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54194D29C43
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:27:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B90B16B0278; Mon, 19 Jan 2026 11:27:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B515C6B027A; Mon, 19 Jan 2026 11:27:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A29BE6B027B; Mon, 19 Jan 2026 11:27:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 912236B0278
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:27:44 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5E787B3FB5
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:27:44 +0000 (UTC)
X-FDA: 84349244448.19.F01CBA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id B23C0140013
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:27:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fhdBn2dB;
	spf=pass (imf26.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2uKyHe9bvtS4rRqV9g+HwXpIhfVuwz+cxuTdSbT39m0=;
	b=u813WeZgO9CG5nM9vaTzTdx2D49PUmBkNDSX7DJVJ+m7scnWWu2dh2tDvc3mu0oEOQrmfQ
	tQ9i+84i1vYsYrT/u9eXE+XOADPi6jbdYcDSG44CMaDim02ung7tNmNAaFJPM50//VXy4k
	VBZq2mdLloAJrDut/NtezjIp+nWDxiY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840062; a=rsa-sha256;
	cv=none;
	b=m47m9DLhoGZhIw/UE5kikEOtCHQrFAqxU1UslbfSYtFMEjuIjlfUlRhW9x5bGvJPyEO7jQ
	97PE+xZcoN2gI7Z7HBO6gRERoY7uYr57bQCZzC2xFEq7libh56nO/xrKs0WGddTo7Ru9GS
	xWWSDKchdw6sOS18j58+N6XJWBtJer0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fhdBn2dB;
	spf=pass (imf26.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D3F3D444E6;
	Mon, 19 Jan 2026 16:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DEDC116C6;
	Mon, 19 Jan 2026 16:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840061;
	bh=0HPdHuxiDqTtA0YywSuVWS43ZS3BgDMq+Pvu7w00t7Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=fhdBn2dBdU8qsd9fov0W3cRwBs6xrhJwrMmju42vZTu0LzeOcag5Mdd3r7MGvyvhc
	 YG1QDMIXTVtBeBMOaWEDZkVVxwZu+EAfat7NXseb7Li2I0zzhNkCQy7u7LTQqy4eQ0
	 yFx3dacO6OxpJ+t20CfGLKs+fb+h+fjlnywsgqy1yVtebczKM3mdOFE/4kZavk2Q+r
	 UnXmGW0DAKOqCQ10ZePYNiGtJT1Pxx1s5rOAc4Z7h8dPo4CkiHrhax+111awiCI+n2
	 vSLb86fZMTxXENHYCelmDQ1/Gd/cB5QhTtutKl6phJthJ67CysXayb7i1Qe9n7+pWC
	 oI/oX14JZ9AWg==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 19 Jan 2026 11:26:20 -0500
Subject: [PATCH v2 03/31] tmpfs: add EXPORT_OP_STABLE_HANDLES flag to
 export operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-exportfs-nfsd-v2-3-d93368f903bd@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=725; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=0HPdHuxiDqTtA0YywSuVWS43ZS3BgDMq+Pvu7w00t7Y=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpbltZJI9z4X2wT98SLfDh2LLMCfOso9BJWBaSl
 4V78G5vaYuJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaW5bWQAKCRAADmhBGVaC
 FacVEACaj9MFO0nJvhnrbzJlVoaITK++8XVR/P/SlqYInzb6OApdrLCDaYj4o7clJSxoyY2+YXy
 nufOx/AFKfqW2S6FzC3wk0Amea2TLDHxNelOCx/2SIff9t15wvQiA4ZLxpYQVPPFLVxQK2GRK1Y
 GYWpk4R5NQjW8pI6fmnlB1C0Up+pudUOErMNmSgrXnGknVVaCMzqt2Wmc0wQ/KnpYYRDjqWzc9Z
 4aPzlAGV0DjDnRr7i1ILM6O7+x9H1+oqvDf5uPli/I699nETR/nnfhRR9ydxu2O/Y0BcZIQi4L8
 DWiDejEGM1IDAXwNfYeM2L24B9rzknRun4ykATk1QAYlBA8sjY2hW5RA1rtsopmXraY0wgLM+v/
 GF/ZzduMVkxw2L7+3SfIwl9IF4v8+vk8svrrLK2aDrvbA35RDe0QC55Z5Tp+7RGh0S9AL5Tpgz5
 RFL3t9hL/j+ejpsxX+/cYTzdyMe+uIzqVubH4KhniotJHOe3U+wPHnwZXvvfOu0QOutCllL4o4C
 pl735gbPZcgpGxib1cuKMRukAgWC60c2w+jfYn3Vb+VyhwXLbEh8Vg9K7yMsSHYubjYw3a+MP8B
 2PdQ1JkgTqMvc6gHLGaQrzIftI9HQBd8a3otzqg3wULPebh48F1QRniiGaGou9fA4+pe0fcaGK7
 9dnB8OyYRbW/VrA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B23C0140013
X-Rspam-User: 
X-Stat-Signature: 9tuj3zs7tc5ugtacs3s8ezwqndqsbsmi
X-HE-Tag: 1768840062-172784
X-HE-Meta: U2FsdGVkX1+IvZjWJEUgn+JzHCj0Q6dT8dPrIMUrtFD9u3aC+JamfPgZZDylQldtlfIl4KBkhdTII2t5l3ZzmfHg8+6T8Fw44vrTeR+BlR3/OkoLRJyR+gtNiAueZX6tr5duiwHqMlKbA6OsMCcVImVE/z2XPEdYy1BC+HnQ0rwSB1fauo9QLxsQG1z3XBBTK/amtyegAbdejsfbndYf16cGsZhbZootA03kglJQblc5ZTvVRFWJJf9N87T4ND3EpopvWlTCxFA3ETmep3CWVlMDUEnYiNR9Jsu7M474JtWVKn0bP9411UC9XmyYfDunplhtWYD5OcU1gREMo9z3Z1HzmfNmqefNU/QwOYS+NB0GIhA2WZgjvt2hz7cHBIhci5jgnBW6rUUhNNSbIpCm9ehY2W+zgPzFtdbATL2shxoOVCfPjSD7qX0x9y9PsG9yR6sqWN9qERqpaGqyKRqF2E7/w4FhtBgBz9poVcZR+S9eTgpfvUefgK9qUxBfa1UQqT0zjQa0ejwahNgHVkgwSpgk3QblkT0quOB8cZHbGxSVBOFVdIIWwM/8qHTp1QEdP8eXaDbPgMYYJL2XFhdgvAgved2pzVgfyug/jnAHkTMBOL5uhxqXCaBGBW+olA+QBfWq0OSpnmaWc+wzh8PN5O+r5U2sme4doDuTJ2Uvkyy8SJDnzgxLVTd5Lp3lN5Qf4/jRcv3QlLZQUQ1w8PftuDyOj+wuC1NDCxqEXGl/gwR/cM43X5aPQygY88CRFbGjYprywdH4aHs0FY9M9a/yxnYNM7uPES2P+ATN1KdUIWyGjY04tlWe+nMDe7Xsol/VMKhPlok/LhBy/tpb6/TXgDDn+N6ygCLVeq6v/JOCVtCAUbe1uY4xLlL5R/qYksTp60168knFqFjYIAL6910PupJz72JzhJ7yP47fknUrKOopUdDZeg/LuD2GSMx/X2DYABdxfsP0e7djHLlzK8n
 i1kgLuaH
 AhKGvk5gTg/x0IaeNdU5zbv3BSeq4odsqRDZgk1LY0KD9ToLGnr36Jx/Tr0lzxuJ3xfx3EFGSaZhEmtbcR8gdaR59r3T1PjmEVPvxj8Pj+52kInfTcxcBLMkyDnstCl7z40CFL6129nfGjmoThUPLlw7dCpqMtK3pQLRM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to tmpfs export operations to
indicate that this filesystem can be exported via NFS.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 mm/shmem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index ec6c01378e9d2bd47db9d7506e4d6a565e092185..c64c4410b4fd9961599a5ea768b469d8184e713e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4477,6 +4477,7 @@ static const struct export_operations shmem_export_ops = {
 	.get_parent     = shmem_get_parent,
 	.encode_fh      = shmem_encode_fh,
 	.fh_to_dentry	= shmem_fh_to_dentry,
+	.flags		= EXPORT_OP_STABLE_HANDLES,
 };
 
 enum shmem_param {

-- 
2.52.0


