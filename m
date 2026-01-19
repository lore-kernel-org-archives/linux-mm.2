Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A666D29C41
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD3536B029E; Mon, 19 Jan 2026 11:29:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBAA56B02A0; Mon, 19 Jan 2026 11:29:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBDA16B02A1; Mon, 19 Jan 2026 11:29:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC41B6B029E
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:29:59 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8ED5456902
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:29:59 +0000 (UTC)
X-FDA: 84349250118.17.FDE14F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 048C01C0002
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:29:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t2r46v+9;
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XdhUirb/YWthwGbnbDuSKExYBUqRy9BVrPxpIPyz+0g=;
	b=7H1MU9L+UnVFqnKluLMjOpXTq5N1Og+IAj24rWmExrAkicVBj/hpSPkjK48qpjT8Ud2kUa
	8PZXGQUPPSGR7XdMWIuE4Rgalr6N+cMaJxAI9JP1CY3koBUkuB6d+P8lw49C+IQwqqggdt
	ikXFXaf+ljpY1Pd+EJ0EpbC9lN1Hykc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t2r46v+9;
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840198; a=rsa-sha256;
	cv=none;
	b=jlJUbg2C4shygO7v/goZSqdaQiGhPAR+EaTJyx5+UANbQGMHY7Y/An+FgEVixZicvIho8e
	c7glLfhGpmrhVGEjpyXnrA9gbIAfLtS4ZyCZhElE64vqFa4bKa+0bN2yVFT+ck+14Nn4sY
	oce+MCeCg0IObniF2YlHuqB8Zo+OYCQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6ED9660156;
	Mon, 19 Jan 2026 16:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41230C116C6;
	Mon, 19 Jan 2026 16:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840197;
	bh=ksDOdJgrlY0p5ZvKqSnF6dLYZLuuHG/nH15DeY9s8Cc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=t2r46v+9jsw3j0ykHvirXoon1iQeU5Fue4C2CsU43TaWml76meAChiFKMjw87LUdG
	 juk0q7Rh6yG59pa9K6QokouNNIzjCWmAeqPOvgr1EYnvaF5nOQITGaHkvHrt/rUvgA
	 fEXYEQAyRL3L8oXx3tbS1XeHAc6XZBuQGGIJVyzvBKwidBPPL8Fcsqa5DRBg9TQReL
	 UvqAZHhiaBCIIft95WmbFLD5gtkRNbUXauR8+FuRE+pVkpVRB+y3xG5HnZ0I9sh++R
	 BeJ0YEeVv3b119rg8K2AhsU3ALBbIRiuZsKHtJdlxfj4WLjPW4U0lYNo9Sp8RIRQ7F
	 lMzepaVQcyGbA==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 19 Jan 2026 11:26:39 -0500
Subject: [PATCH v2 22/31] nfs: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-exportfs-nfsd-v2-22-d93368f903bd@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=710; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=ksDOdJgrlY0p5ZvKqSnF6dLYZLuuHG/nH15DeY9s8Cc=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpbltejvI4uCVHlIS2T5Sg9AWKXFFFdc6UAKuPC
 yIPRMUKgvmJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaW5bXgAKCRAADmhBGVaC
 FTCUEACsqv/PKTuNRCX5fxjg+TwKNxbmij5eOneoSqEsTfckElQdAtODhSPDDyCNar8QgaQs7M+
 VXuPS2EI2WkFUsZI2CLVekpCYCUQndqX9wrbqzSuzjy3vnSINM2TO4exNBnjO/erVYxwQjhirKH
 3oI0cBXBHOqDbxYZ4BxvKKL3EzoSapKOG1AycaqjVaS7tSGkd8ErvvpNO5ge1DKKhaFv6SnQv9b
 FER7dx88BVVl6o3/9b2pbxTozggAgRisZBNKhc0V++Nc0TlEUM19Apu+O6ylzKOheaU7DfAYTN1
 Bi0vYNSlhHuDe0mO4uiKEVt13bdyxhSBAqAYffzWra5kfampsjGglFiw4wyUTuPHY7YKYvrU0th
 QLKaE8bFWcJDloaj2gdWRXjNlFnN7noHKGGzh9LK6PoKAYTXHy1j/63W2/O8uQ0OnC+WIuB3e2f
 AIeR7L3FB8HIZilZbF+zOUQ720FHIpZkOvqTxQUcwVKkjXjR5QmK7gBuOJJ3lH0dd7c+uTGqBLe
 LbF6IxDrakDOoOKLHOatndkjqZ78EMx2uzRvgnILErXqa3CLcNn0R943ZowUFuAOh6ZiFn9AV76
 4iQzASFRmeFhWX+P/KS3X4VpLpdTttEFY/0yzEN4+pHCkqJjhtY45bpC7kvUVo6crazXPily8NU
 THxmvjP1Wo0foqQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: 048C01C0002
X-Stat-Signature: o5tb8sme9w759kf61au4trogjm5645jt
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768840197-709476
X-HE-Meta: U2FsdGVkX1/usjbIPWk3vDA77/8ZYdmy2I7PjeSc8sHdeSq38gVlnV2isCChMGNONtD5edMgWqijAalwtSUiriMdAIZQsmSWnOyY+PnQbO4x7C3TKDdD/gGTv7mxWYc9dCSj33Qp7FLrV7QoeTiy0++IFVm/WBQQ/+Tsz43vubUR9Ch6vPhIDftVFKO16gzO5BKtxYLDg9Cs0uPU2v3piAJyBy32r3kohAhiqvOhCh3fyrTiPRK6pU6jEzrlI5izgi3x97LmvtQIE9IuozdOYVETjXg09HO7cgEmt3LTlWjVrlqAdwPi2tCdHBLgEpMNFSp8vjekvW3guYplVWwH43/4qg/hnBEg5w9G3TF0M0ieI0XrYk7phsJ+V/jCTVFLBGCqF0tLnlFqdCotqkL5uqIo5pqWmF9otQWrDAVEHFeA/PTadaRcuOKWOhVWrrimp9/SWui8fYmNc9bR0xVxbb2vsxfOYzY/F/HNSyVjgGQBG75540WjFKq1R74+BUPVl9EIyLrhyWUvFUyZWeX4QDVFWSUGhqJoAyy01EuF8IowJWfkhWwqXBPBmSxvZFUTsOCY+CAWizPLN5GEGJDr0Bl1W8+KK+xzMA8gXacbNNToZPQ43RArDCtnRQpzWl6HIiHQ4Ze0IdeqHMslE809JLfjm4CgkYAmpQCVY8UqDPRd4Yk+aGkO0GbOZYz64M4NKAkI9A+MdBlgIIaqVtxcKf9+Pik7vjruVLAwZepsElZprqgh7d57l+XWw3GEwgQ1It0ekl3lFUsG1K3dSnZQ7w4kiVoikk0hMWEoUxyMdsOl8ZG90Ic5R0v6GyJHH/bDuML3HgFkoF1szEOdSMqfYUL6+XcdSOVe29wwbJvC5T3E+SggWRQt9Q0+/myD6PUHx+r5HhB/qfkb2JbJ4Il7AgJXxlDiOSuLVzXbikBgE9qu7oZhBmrCGrT5ExMIpbu7wL+SR1gMseFxJ6GAsPK
 YMpPKQ+O
 I5HuVucF5umuCnUztDz0QwT1gj9EeioyRxWt0BJ4+F1yLcs7haV/9pyTs/T1l4aHtHOtSFRhZ3D+quqH0T1cO1oiXwQ3PXrCM5jWnXo4lifHCfgGOStMKSRKzmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to nfs export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/nfs/export.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/export.c b/fs/nfs/export.c
index a10dd5f9d0786eb111113bf524a1af8b7da0fb6e..7592ef347a2eae5d6305b64effd22537d5ef5e74 100644
--- a/fs/nfs/export.c
+++ b/fs/nfs/export.c
@@ -162,5 +162,6 @@ const struct export_operations nfs_export_ops = {
 		 EXPORT_OP_REMOTE_FS		|
 		 EXPORT_OP_NOATOMIC_ATTR	|
 		 EXPORT_OP_FLUSH_ON_CLOSE	|
-		 EXPORT_OP_NOLOCKS,
+		 EXPORT_OP_NOLOCKS		|
+		 EXPORT_OP_STABLE_HANDLES,
 };

-- 
2.52.0


