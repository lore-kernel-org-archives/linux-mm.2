Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74543D29C45
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:30:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB86C6B02AE; Mon, 19 Jan 2026 11:30:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D79BC6B02B0; Mon, 19 Jan 2026 11:30:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C454D6B02B1; Mon, 19 Jan 2026 11:30:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B0CA46B02AE
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:30:58 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 79F3A14017C
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:30:58 +0000 (UTC)
X-FDA: 84349252596.11.10A9484
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 75163140010
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:30:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aRe9D5Sa;
	spf=pass (imf23.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BVMoZ6aYYtL9nmNsreNI0oxHDB7/XuvSnZNUNgsLjo8=;
	b=Q2N+d5wBETO1ZIYJ5uem33XPlIuq5p4mIx+msKQvcC/NyX6dbmHq7AtGzmv5MficC1jQdo
	thiv+7vI0kOdBZDG9XXpZ/U4WzNZsJxwlGtX4IomX7P7zrpN0WVsFPNGJRQfFN2Jd+UdRw
	ZnygCKHAQZCzW9p2Aae8z69HwomJ1nc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aRe9D5Sa;
	spf=pass (imf23.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840256; a=rsa-sha256;
	cv=none;
	b=cgGrR8o+iTW/JV5L1vOxGMupBUk/7TzCTlNCItDN+d17IJ48Ov0kwj1m4fGlK4gK9bX1cG
	GCvqPDmIZ/qH21OUNbeR+7ViTzZu9A9l72TV0Tl1UmqQNKgih4BhRngpUEcWqKA7Qonjfk
	lDj1zm8AoGFvTMRpuBA+ZuRvwU55Zng=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A92AD44507;
	Mon, 19 Jan 2026 16:30:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71889C116C6;
	Mon, 19 Jan 2026 16:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840255;
	bh=XGt/aZzfGK9zJQOZBzNGqpMmieKmh9kJIK51xGoE3lw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=aRe9D5Sa7gMB/Ryp1GcMwBIJ0XwKuZ6UClP6Ug45QHAha8tYj9mJ1V510E+A9msBF
	 uIhFQ4ERVA2/a/89lazW/TqRbLmJXCbnATean6EIJEuIz/669usXdDh3OAv3cCVNyN
	 153NxFJ5bXU00TkkzzXLWoUrW/pQLk9vKivAvy3EIK99PwQxTlxQfnsqWQCzOs4xkV
	 djsQKErslPGQtEcNguvZIqh3BSoWwOetopyqoeBHApuQa2uwYZV8JERw+NxlC0nR0n
	 fOEHc48tTPF5j3kPLorwmV32bUWcgE0EFzjrgIlJjLHAtcT1r/8PEQ677OthtO1AHK
	 xGnYGFr1AXgiA==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 19 Jan 2026 11:26:47 -0500
Subject: [PATCH v2 30/31] nfsd: only allow filesystems that set
 EXPORT_OP_STABLE_HANDLES
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-exportfs-nfsd-v2-30-d93368f903bd@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2174; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=XGt/aZzfGK9zJQOZBzNGqpMmieKmh9kJIK51xGoE3lw=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpbltg313cW2t8STVH2Q3f6eFFX8webaAfx8DOM
 GA1WXTggo+JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaW5bYAAKCRAADmhBGVaC
 Fd/6D/9j/oMVrJxeP2Mfuffs6X+mbihS90psuLoEJKbrjqZA7FdFGxRNUgHxspeg1JxUtDbEv7a
 uU4kSCajVCH2iOyDZQHDvyYwkkXW1+PdbM5uKZ/7DFLmaIxhriGPZjNE6IzpuJN48O73ngtU1bb
 P2CJLYNkWnxIJsMzVQaL4bwkbCVO8za/peoBtCgsO+8VOphfgjUEt0WDcgBxDOZdExrFOuNZlkA
 yVOd7lxKLAhNKynWzgdAd5sKikhudMp/54M1K2PccQWIGPdcv4xFGVS3GiU/csV9NzJSKjvCtjJ
 /K1MhVCHGVNaobSkaid3Tly/fXK4uha201p7DIspoVEewSSSXnhx5x0x3aBwwrld/gCO/BQlsYK
 5rZ2YOFFh/4TRhu7Gv3uRLHaXPpBIvj1iq70FX22A77FNzSrDm4qhCKISIaOPMyLDSI+t5ru9TZ
 j58AKvcl13B3sxdRak3OQWP4MHJncRuHJGlvXrEQaBf/aD6jxo0U6J/EdF0tJYPIILxRvkYndIB
 QsuTvSgf109v+B3Im9IKplrYJZ1er53jnSi8MzCOscRy3zHvch/igrvKIj0Mqnwjj/FRsnpuadV
 MVNdABzxnuvzbDIRfClDT3ehoVXweeSMvlteptmwg0EHO/sEA5XJWFSZvKdtodlu7Pj5Cn4Pepu
 OBCy4/+aVtv9EqQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: 75163140010
X-Stat-Signature: njy9c95uizw533dzefdgbf5smta8kabe
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768840256-912481
X-HE-Meta: U2FsdGVkX1/m2TOPSLpZLkQozNZ5MbKfc/F/nWAV805JQcdXktWcRfIe08malpoC2Pqa/Ru/7H21XsKfd2/+6ZSWG1pwMfH1McZckgORh6upJz0of+CMf9hF8VBxh0vNUAyl21MtzmMr2lxgHqoPdw3O2tA92e85evpOr4VIFX3CLuTUVthfx4ick+Av7wkwqVvfUq0tJYSnJU99fZnWpbLe37QqthchTBxVqVFWLdOUSUiaAxiDv64kP+EDMOgM/bxyk/xHtlZMiVf85Vj5UWkG650XqcmkZir9UnDE1uAwlTHTbhqvpbTNDUlbQigNbtBd7LDbgIIl0x1Zf9XMlomQw3Bgv+o7wIiqU8vTf7/5mtUuamNQ/pSmlwPebVFMN1oJ231B0irKu+gBWRahyTGQ1pASgIH/k662A9udLbeKC6MHMFSf+k5E+YN3IK+Uy12aTG62v6aab0hB3GkEdK9/7qIhNjjHKtUkvaOO9MYs9uXjkX3qaOLQv9+/1yjf70tiWA4LVoBpKKEcgi1ZwVRw9UgqYicpdU56pF7rBhWB2VppLP04BDBjYz1qmHcWfFpshiTw/0rxQc+9zDPJLBiF/SAFt4MMUnJltVlhFL5FkpE1a/7sjdXBkyiQKiKOQXnvPDetabSwOg7WDCnjLPeFNJV7KWzfB8BeiMvpB4Xck9Qi/B8zht/UKNKwpw8j5f8RyQTZ1cLzTj+DuFeh0KMGNA3VgDB9KaGQ5cPk4hsy+28YW3ars0XgvnRv7jud6D0JYdZNG9rK4wFKx8q7A/jtKGBLv4KMaOJHjIRvSWSbmYgPaiKSOXSgvPpHTXnYyAkEr/48hunGG/U7y7l8AZILANKh786dM6ttAdwP4QJWtlIRZz2EMAqfkrMLaZDeTtNwCXljUZU8JTMScmB2dtSOdjJJDklfu/iS499tBdiPlVg+Mm4UxPOuyq2qagUyVyiFDm2Ci1JQsesHMLx
 jlwKq+QS
 /BetGt0pbqGG0um/W87tAj9FPfpHVw+sDFJBKEo72MYpY9a5HONUct+V981pIFbSsYghA0HEiZuq+GbOu2zXC230zqTdD22YFsC74f7N9JNDbQUbXMuCXvMJ54rWRAnubILKoyZujbxtEcuruW9UaEzvc3UZCyp9e5WUT42jIxMxYH+cgNisLBJ9m1pCUb7hkETXsZqpPoLzdQAoQ6j4nQD3ue8j5ACMy9j4uZcYtOk3wPONsq0NI0iWPcFKAGC/npQaKnpzYiDeuKgb7jH8rAKD32ponafbYua2/GQSHXKHXL/xbqUa0utRjyHfm1yijkL9QQ4v8zbKACvBjGJjXzvNxTl4qkvnd4sWeEjLdDIB/rso=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some filesystems have grown export operations in order to provide
filehandles for local usage. Some of these filesystems are unsuitable
for use with nfsd, since their filehandles are not stable across
reboots.

In check_export(), check whether EXPORT_OP_STABLE_HANDLES is set
and return -EINVAL if it isn't.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/nfsd/export.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index 2a1499f2ad196a6033787260881e451146283bdc..bc703cf58bfa210c7c57d49f22f15bc10d7cfc91 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -422,13 +422,15 @@ static int check_export(const struct path *path, int *flags, unsigned char *uuid
 	if (*flags & NFSEXP_V4ROOT)
 		*flags |= NFSEXP_READONLY;
 
-	/* There are two requirements on a filesystem to be exportable.
-	 * 1:  We must be able to identify the filesystem from a number.
+	/* There are four requirements on a filesystem to be exportable:
+	 * 1: We must be able to identify the filesystem from a number.
 	 *       either a device number (so FS_REQUIRES_DEV needed)
 	 *       or an FSID number (so NFSEXP_FSID or ->uuid is needed).
-	 * 2:  We must be able to find an inode from a filehandle.
+	 * 2: We must be able to find an inode from a filehandle.
 	 *       This means that s_export_op must be set.
-	 * 3: We must not currently be on an idmapped mount.
+	 * 3: It must provide stable filehandles.
+	 *       This means that EXPORT_OP_STABLE_HANDLES is set
+	 * 4: We must not currently be on an idmapped mount.
 	 */
 	if (!(inode->i_sb->s_type->fs_flags & FS_REQUIRES_DEV) &&
 	    !(*flags & NFSEXP_FSID) &&
@@ -442,6 +444,11 @@ static int check_export(const struct path *path, int *flags, unsigned char *uuid
 		return -EINVAL;
 	}
 
+	if (!(inode->i_sb->s_export_op->flags & EXPORT_OP_STABLE_HANDLES)) {
+		dprintk("%s: fs does not provide stable filehandles!\n", __func__);
+		return -EINVAL;
+	}
+
 	if (is_idmapped_mnt(path->mnt)) {
 		dprintk("exp_export: export of idmapped mounts not yet supported.\n");
 		return -EINVAL;

-- 
2.52.0


