Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CA3AD29C41
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:30:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFFF26B02A8; Mon, 19 Jan 2026 11:30:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB8246B02AA; Mon, 19 Jan 2026 11:30:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAD146B02AB; Mon, 19 Jan 2026 11:30:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C94D46B02A8
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:30:36 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 84FDE1395E2
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:30:36 +0000 (UTC)
X-FDA: 84349251672.21.DCD066F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id D17AC4001B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:30:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="N+/nI7pA";
	spf=pass (imf27.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WuwnkLUgDQXbd/SOy/5k80yei661iYq3HAqCi2vEuXw=;
	b=gG1Gj30vivQc47zNzCUH+Qdk6zVRWv3CQKpiOao5PHIQ1BMtVNlkY4Z/jPVL5xq0A9sC88
	cMLrcM91mkptvUh1ndpgoGkZSQpoYclaWoySxgo2AfT10xbO1wS7DFTc6IcZel18LfFcos
	slG99+ZC/uGwswmW57P8AiorUUGE4I4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="N+/nI7pA";
	spf=pass (imf27.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840234; a=rsa-sha256;
	cv=none;
	b=gi37p9EDvOVY4lp70cr43gWkf26cposCBigBpCEUJjTPZxuObMg9JqSyhNESvMmj2a894G
	sVQ1N9wNrFysuR1E1r7BZIfxOvkwii5o1wd195xlG/8uRjBGCYgAUc1dCBFipAwawQ793e
	SyonvktNvvyjpZIgoa2j1Qga/S2kVl0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C5B060167;
	Mon, 19 Jan 2026 16:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22817C19425;
	Mon, 19 Jan 2026 16:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840234;
	bh=tb2VPLHr94Dp22tk5fzRHLdxd/4iteNlVo/o/3ilPx4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=N+/nI7pA5qB+2Wz8qmSRVw4ZurFxnPM9ckLYAe+J8efO1KKkatPx0ewmIZNlxvWXb
	 ehSxxq977A1EuK8KJylqhf1esVoZqPGBZhoZJcBoA3mqYaLaW9B30srSQpH9hhu8Hp
	 PhKT/itkrIVlWPv18zFYArEJrHAxv5Hh5hdum9w4ASu2Koqkh2R0ETKB9RjvkwvnHe
	 ZsPzKT3ukVUd5DpTIIKnZ/kWFchLil9blOQXOgHLTeyPwYzf/prSDarZt0MgmoTCQ3
	 1WFKnzQCCnQHor68WzbSce1iBiR3KYVLHyBpGf+FocFkapRxQcbWCo7gewPvNqKVbB
	 RYKYSblZfnPuw==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 19 Jan 2026 11:26:44 -0500
Subject: [PATCH v2 27/31] fuse: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-exportfs-nfsd-v2-27-d93368f903bd@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=749; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=tb2VPLHr94Dp22tk5fzRHLdxd/4iteNlVo/o/3ilPx4=;
 b=kA0DAAoBAA5oQRlWghUByyZiAGluW1/IaPfueYIufakRk1Wy7VajFvE5Mi0rJeiI8SyJNibea
 4kCMwQAAQoAHRYhBEvA17JEcbKhhOr10wAOaEEZVoIVBQJpbltfAAoJEAAOaEEZVoIV1NgP/3Hx
 4TQHJF/6t36D5pyiFxAckKtnLQWuKxq4WEPD5FlhEh6Ptylt+qeF3wJM2gvcXH2VxwirFBR8cjd
 6bOvlXOHQH+nhfO1lRSkytQlbq6UxY0vPkg30u3xphifyBZ5UaEOu9j18/mTiVDYtgOjthfRJMZ
 ixd2vn9fIZvVGyjLubw8BKozpjyEV42epDShz263DxizQ9ckGpQvOd/lNNLM00tT+zhK1rYHDRN
 uAqizwREj9nMJnsCwEzqbAGURMWTq7KKRWlVJSAU7NcmZsCO06+eW6E00PRDYFP+SqsG2ALbkZ3
 0rdBMRTbkJnt8WWL6dwrqSZnGFnkJhVeyMXXqHaieZau2yPGuevBcMUnHmJfUAcZMZLK02tC4KZ
 BfRCYFjEorMqchCziN1COr5DxREd6c09F5IYSy8V6aRDl+OIhwzO/BVZegkxZI9XsUmExpocSoE
 D8kpU2BZ3GGA+GD6NuzTDTyzE3kbEB+2rbIMCT29YSv69mYy8L9D3tCmVEVSKG1D/amCfPatX/s
 xYwgFAsXGOSnsGGzgCLoU4p/mXsV2cdq0yj5uYa+h3U2/yQIu3OEeNDdsXCTSZJ4XzcSdg8wM36
 DVfZqz28XNdL0SYvbvvCiuQShuu9bYTFT639GxoqXNPIKhIKveBMs+6uqXLUqbbYBYUdDy1RDVd
 kClwI
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspam-User: 
X-Stat-Signature: yi6o1t85m3fwm4qff7erm6osq3jizixc
X-Rspamd-Queue-Id: D17AC4001B
X-Rspamd-Server: rspam04
X-HE-Tag: 1768840234-6799
X-HE-Meta: U2FsdGVkX18Xqin4nOdkrnDps5wIljSEWmmxi+rFfuhs0cCNZFt2fooW0wP4ztE+XHqddl9UCUO4qnuBjUUWTKWKZuRu0brA0bteQXiiHdxXFhfIrx4E8yXCHnjEt+TBb5slJ2AKzV8PBWzvFnGvTAfTMKrbQ3+aCYYvkFOOsqNcezbdYuAQs0nO66k4NSQvZS0fT5PToxgAGhLwIm7jK/X0bRx3y3elNC24I53ugdAeuv28C7GHbxoJic8NgK4ZJsjpwEW1kDMsg+P0KQww2fGmLj2z1W/vQqpMG2SqDjmjTPEVO1PHX9+24W/FCt0UbuSTMvK46UkViYBWcL7zt0kMjksb+k2yr2fU4ETqu5AU1aVd9poXKPJo9ps168JMPVLsYXhMZ+XDvZA3HUBObbJ+/V1cw/eW1StVUbdp7LjyPG/aAoBi25eIz0r0vGkdUcZZSgPPOdHy8+N73EKVPFBTgJ7o2wWlnOI4V3C1As6RZAfqlCKGHJ2nj0CvYAVPGxfvnCQzHQEHUbOnqbpj7aJneHIo6WdBjFwfg/2F4Wk8isSLXxinpM4fjEHltT3ADRDcYVP4gr/inOpugfV+6JVnj0wvTeTgiSF99h9Twz9wDIl9d7/FY0dKstaLcrA9lS9GhCzPJgNVip3tlC1YNIxU3Y0CtgvG6pghkKfxO/OrtbHG6KDZXhIgO4siwvs+9vUhSgYHdhl7KV05iIByHLgWGAErUJSO2/O6asATH16yJlIu0ILarglU/h9tEoCcb7V4Lyl5XsgPpUCcvPD20JohD9F+nSS6skdxbKCaAIGEkm/7Cy3RwMytsMbKmLLuL+E++VO96gFG7zb+gVPIeIOcA1ioBoIBrJgGZopmKsHNC2uk7J27MfOHcAtYrwYSfTi/GJvUbgHc/BgSWnvPJv04S8q3dsd5FpRdmlkVyi5pXnGQbReV/avTcep4BpbZBciRBTlayPS3n7/b4RM
 BHBQld6M
 Sdetm1ta41Ml5ncGaxy6O/rxNp1q7wPK9nWAV4EiemtsHTK/hJV+u3/AX2CiximNHBzkS4BmnXn542OjoM+9WkQIvLE88a6K/37uscnhv1NnUUZ/8c2B0qI99iFHY4nmtD+/ALBhx/Iijd29/LVksP8FIqB28E73AZdwlhgs0TOjoRbv9LjhdjLGYYo5f9N2QLKmbfoqVD7/AKrwaqr8mqukgljIuTTgAAvkWfHeQIcH/gGNayreUw5NjcIpj1oK3N1JUqqiNtFJp44MK4VQL9ic5I8zfmbvUfW3DgQ9k2KNXAOMx9JmtFZYTzqmFD62zmRagYwXQeOZfpoJCXivZebU1M7u7ekdh7wuWwlFgcyCd2WU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to fuse export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/fuse/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 819e50d666224a6201cfc7f450e0bd37bfe32810..df92414e903b200fedb9dc777b913dae1e2d0741 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1215,6 +1215,7 @@ static const struct export_operations fuse_export_operations = {
 	.fh_to_parent	= fuse_fh_to_parent,
 	.encode_fh	= fuse_encode_fh,
 	.get_parent	= fuse_get_parent,
+	.flags		= EXPORT_OP_STABLE_HANDLES,
 };
 
 static const struct super_operations fuse_super_operations = {

-- 
2.52.0


