Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A195D29C41
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C8FC6B02AC; Mon, 19 Jan 2026 11:30:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 880BE6B02AE; Mon, 19 Jan 2026 11:30:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A05A6B02AF; Mon, 19 Jan 2026 11:30:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 694986B02AC
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:30:51 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 243B45687F
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:30:51 +0000 (UTC)
X-FDA: 84349252302.17.01C8F94
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 35FEFA0010
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:30:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kzFgWc06;
	spf=pass (imf25.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840249; a=rsa-sha256;
	cv=none;
	b=Gadyu+BVVYgcHIujEfVlhDnSQaAAjl5Nu+h/mSxGLzK1nVU/HdR5YZdhwCzvTi0Ncs0qJa
	fo2Euz+BkFGKw0vUv6skLCPYI4zIv+92cFmRPALx0QMhpPOIiMTaZ6tfNf+C+tO98v/YA5
	yi3XJ7UMWvoU1LbXPLUjUMfXWVFi1Ho=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kzFgWc06;
	spf=pass (imf25.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sQr/NA267cZ3g24Kg8aAk7oc7aW4N/K+I8syFSJ/ypY=;
	b=o5dup5LsbywYkN32Y2hUxXBWV0H8FD286zplgghdw2IKmy4+q1iQo+NiIsrNYG4cLpZ3n2
	9+rAod8oxhEjsBjxS5ncfWxP8u4Vnd1G+pXncJwy0tJ11pQd7SsWByvHqm8La8wentx0l0
	OgqqXMvmxFhfC+axiVJGcGXFaAf3VGU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 510FE443FC;
	Mon, 19 Jan 2026 16:30:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578B6C116C6;
	Mon, 19 Jan 2026 16:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840248;
	bh=htvmJ8h5f0pVu8ImvWNw/JEkkap4HdmaXUH9XULOP2k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=kzFgWc06aZFuLVxuUIaJbuzx1Q6DRqgjKSqHMG+3rx0WNtTnTeHoViYVYtsdlbnl3
	 lqrIDTwTxIDk6Wv7YDKzD4dGNaMQiGo21SK1N9WTrUnWHqeN1AwccSLrFYhdJKpX08
	 ycTFaGLIqIyp+7Skq1JJqCGRfXe78rqioX1Z8udYIhDTSyBzicw+7Sa93XN89py+wv
	 /X/U3zk+Ly9IpVN15GnuxYN6Jp73g9gDPVq1nFKVgNeYYcrr/bLecAeSadlP3TRH1h
	 98jce/UvFQXzJKk/dBpgJh8cajRnepjcNRKEZtyncNjOfqqNcDV/9L3tiYjSoQZLKY
	 O8avH5/3cPZJQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 19 Jan 2026 11:26:46 -0500
Subject: [PATCH v2 29/31] f2fs: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-exportfs-nfsd-v2-29-d93368f903bd@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=728; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=htvmJ8h5f0pVu8ImvWNw/JEkkap4HdmaXUH9XULOP2k=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpbltgtBAQfQ5kS+MExK3FeETc+0guPdOqIeqKN
 mx8EKEmLxaJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaW5bYAAKCRAADmhBGVaC
 FeM9D/9txHa6W+i5xp+BRxUlC+XVX0On794rY5aGRkCAYEj9G8FgVMxYOjtDjcbiMsVdxqZ3WaU
 8QHVYA+iGrifPnLe1QX5jrXsBmrJOvPE8aiYvQEJ7Kn84fkr501BGqfPYbivwHHqSTW4rWD7Lkv
 CXuWb1ylgYgiLxDtB6YOyjO+VM2ELqQMvKtnKAX8jvpCLPMTNo4h9Egmvceuy+jmkFCZ5S1/RzI
 h8G4P4yUVcSRQCgJBt016ZJS3dhf5ZqlmgJCLYo1Cda1nZN/4jCJwUSpVU0ndR0+wkkzxqwgZX1
 FKc4yHuYOxRorNJe24Lf3LMrClmYnfwuKEtIWQV2PBbjQUnBu28z2anYNz3decQi4GuG8viuV8a
 gOAJXMC3qfw1dABMQg+Hiyw3inAbSxviSpXAdbzB3ZpdheY+I38kS8ZGknXqhYJDMGcKBwLR0G2
 e5NM2E22TFKSYCnu0C2ApdVfQT03Xyd0gWln+3M1Nhh5tE7pk3DmbfhO5r1IhB2eUmAUTbJriOf
 cuIqSl01a9VaIzNVTTXtFLeLIgvWHCIXtobkyWBHyRb4tELIU29i1q5x1NmGttPKaZizPWjN5XU
 y7yhWnW8gdZvuhuuRR3TZCCPT88HqdkSSsjxjE7hzPD7kZmL2+zhn+pRrGWIF682VKp+NBgQsbT
 Hzi+D+FGfINt2mw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 35FEFA0010
X-Stat-Signature: kp7ransbarr5ye5e6b11n7wgtnjcpmoc
X-Rspam-User: 
X-HE-Tag: 1768840249-789845
X-HE-Meta: U2FsdGVkX1/xD5M+bN5V6LxyRFipz+oWC10TkJs2AeohP3mHxQY+ryuzpVWuXYWeZEYhRajTLb6LKf/ek1eVKMP5i8xkJFb34vZeX66wsw/sxjIbguT4iC1KbO562V5WqT13FGWRz4q8F4jgab57wWAAZ3dqbfyjsYILcnuSEWVH1nxS9QWmlMA8sn2Mk0MtwFP8n3PA1qd0JFXQ69druInaqzZkmBSg8gxHUKPWwz/EnHFkVJZO1ADPMiSEEiw8TB8e8zM6bZ2Xys1sDjTbkZyL8R7bfxhrQ0KB9VLaXmJkGYolyDg9Mbsqmn2uoQFLa39FZ0ME8g5muoMutKUyiRZRYaw903nLCG9+FeQu0nsulKjNVu7nAc7DfcFLHjiFZXQG5DLUEvRu4qEVZ/+jdzMZkzwxJreVmBrOrKne4PKCWkRFvDlGtGwUGlttCrJOCNEQ2+j+NrQ8Opm/Zy4/L31DQVUpmr7HkoA0MfZ4NGDnUu4hLrhr+5071m2oPa9e2Wx0jVz7Ldc8THMh6r1dC35Y9Jb5gPHVe1yFUL7gTNgvqHMzf5mdtwMGbiVJC2/AFeBkEJM6jZf6wOUrcBoYiIk5ol1lUWLWZq7wDzIDgbhtyhXqW0BMYT1kOK7liqIz4coVaBmIwEnIKLKJOWLfE5h1wro/N8KmXFuBal4fq2uaHXRyz4i6OrTT9T2yC9HKIeJ1vl8txogLe+R1Mj3gwLwHhc/det581I8Vz5rVwbAiF89nbKhxgkMEoyHlaEH7ChOkB+dzr/+d2oTTmJSFVVhqecN6Zchp47a1hZ8vsww8qa4cBdKt6uSESKPSOO5rEEykYKO/n60yifm6O1CDMDI1NMXQnA0ssQAXdSSHoARJCpO5m0sDxBenLP2zqEtkcOVGjFD2LjWZlsfkHSBnZ/mURGL5JIMypgddw0Tz/dQGZiw85R2Nqg+x3Ego0hmC5eJJCANqM6CFFTtVN2r
 PT9AXrzI
 OFQbQAK2RVN5KrPU8J2czRht1AbR1zrpwXrugHppmCODw9TT3LA8TEocnufr9OHZC9hiCEEe1boSSLUSP+ihVaAd5RohgxHZzH9oFQjTpOk3vtBtJzVuBkZ1ikTlFvVBREj3EIgOhkKWlogDv+YtTAUPKNqt4FZY64Oi2vXRkiD9B6BmTdcmYt0bpAUTMtfVsxtlld5KqpggpS72/zro3aGdcAE8gtpgc1HNNBOPObOcDUNvub9t2DfXTMv3FvNhHonQplZcZZdreOThm/KZpez6ZCMKY1oBKaUfbWMaTfuosn+MbYe98YUuVJqtPCRJlrO8n5uM8O9BvdYiMhcGke2dZtdeRWwFU0SrjGvaHA4woFOuI/A9EEjB+LFxSntAeaHk2wbRw1/cDoDXWFexFrFAJEcP0ANchxFa73awfQnK1cbw6pHPuyZ8aHvk4kMrgg/s9C9jH1Joky/KwLvwx2gunCZIAgER9j5Lwk3iTqPEUTIsslaCOPzQacqkIPSxZNfDpTq3Hk2bPSNY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to f2fs export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/f2fs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index c4c225e09dc4701f009dec4338f2eaba1820ea7d..260c26771c431bbb36e99be8daff6cde40662751 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3750,6 +3750,7 @@ static const struct export_operations f2fs_export_ops = {
 	.fh_to_dentry = f2fs_fh_to_dentry,
 	.fh_to_parent = f2fs_fh_to_parent,
 	.get_parent = f2fs_get_parent,
+	.flags = EXPORT_OP_STABLE_HANDLES,
 };
 
 loff_t max_file_blocks(struct inode *inode)

-- 
2.52.0


