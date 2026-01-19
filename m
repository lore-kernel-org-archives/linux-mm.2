Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3DAFD29C43
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:29:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F79A6B028E; Mon, 19 Jan 2026 11:29:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 477E36B0290; Mon, 19 Jan 2026 11:29:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 370596B0291; Mon, 19 Jan 2026 11:29:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 263076B028E
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:29:24 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E76711A01C2
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:29:23 +0000 (UTC)
X-FDA: 84349248606.24.923E8BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 56539140009
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:29:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Onl1ff2y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768840162; a=rsa-sha256;
	cv=none;
	b=LXnuOrHczJMB4/yHaZJKXc1Kq79SmIdya6qn1WnaOw6s2hDikLoflBAuuD2Zm6yquHmcvR
	kVPk4UcW9yTm9leCkXRuDYVj30c/5Nwy6+qOmdn1rKF/kOQh9tcbaesbNQ9+HBqj7UXWSA
	vZQPDBzZTS+dENtsHMKCf0UvIF+Tywg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Onl1ff2y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768840162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dtHwIbxkzeWlILopqDXGMY9lSWkvAf9n+BQlvlf3Gu4=;
	b=Za3dT+IcJLIA28RUYrU0gtc7BsnBLPVhch0Ju+Ks7z2ynoLUBt/FMOXWYYJcgLN+fphPAm
	hOnD4rlL0j6T0EhS4bKBAOwbmMqGuUaeJdwP+8kqHBj5T6175RHtYHf+w2nu8FXZS8FtlY
	tY94I+9RPq9OtpzPUsGh1Bnl9yKGi3Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B9EFC60169;
	Mon, 19 Jan 2026 16:29:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97545C19423;
	Mon, 19 Jan 2026 16:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768840161;
	bh=xYt2MSPBN08jqB6aoLGRn9g7bVaaZnkp3x/mAo4D07M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Onl1ff2yL2rsRhbon2DKTICt3E0fC7f5rf9eTx08Plj/priMZPiOxyC95fr9OlZ1Q
	 Tj3bc6+F6jeoOP9lW9Omi57BHdrw9hIQi8iW1rYY2TZujDNAKYQmNHfnJF7TQR4jDL
	 XT2TgTAX8bojPDQ4CH/gyDuKnodpDRa7LoecaI7ZGol1EqqN38/2r2PumyMB6E/3IB
	 gMmbVJ5th0wfE7wFSrWJe7lDVaMZmMsDz/ijztbFWZezeG1mnnhpSefOWhWvGutvnJ
	 8P36f5TeigIVo4DvniWSBYfSlTL5nDQeA0+/f1ooF6OXQ+oRCHpAUeCOKIQg6DXWla
	 m3kUCp2qEriXA==
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 19 Jan 2026 11:26:34 -0500
Subject: [PATCH v2 17/31] ovl: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260119-exportfs-nfsd-v2-17-d93368f903bd@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=779; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=xYt2MSPBN08jqB6aoLGRn9g7bVaaZnkp3x/mAo4D07M=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpbltdbZC4i859npPwVQCiLrrovPH3Ntgd1inG/
 8UBjD2xxyKJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaW5bXQAKCRAADmhBGVaC
 FYjDD/9hgSSTbDWpgx790fD9kUBlypy6yfUjVl/Cwssq2z749eDvf2KH5eMyxgd/6rOZkPqu2+2
 gbdvVNbDvUNY8fz7NspCjYiEDexBIC5tfRA9T62LVeoswQLxGM29wl2ixgPWMPBftcv7lAnPkjT
 S/jzjLHFQyKYcXtCf9pni1rK0jCr3OyBHk3e1lVuA6LafCIrvu6F9+tcmuWu49cVETld5ujnAfQ
 csp0C5d/6qNeeBHIcn/WZrpHMRm9O0eNuS5umBPhLGYss0OC/KOBEcRdZvSuR2kP/ArcVAuAFwJ
 2N5Otod+F4FKciuxVxlhVxmTUtY6RnEThZ3KAP9eUK7KirA4BUgoX4CEFxcARIfClDzwmm53bIW
 EdRuC2b1qkPYYuAWU5Xuu1N3uE8cGu8ytttjPbvB9nR/BBaATi2uwYx179nwZfoBchKvdZ5fGGu
 WC4LLqz6rN2YcqXs4zBkOZJwWzlmTxbob7Ao6GLHKN71Pc7fAWGuHtPXhlCz3lHkPw+aL3hZi/O
 fFRjI7ZBPIzSqYhm8g3W29oI5wMFvKvJjZ/3C16X/0UB/OpbmSgTYhYdc324ukf4fmF8BbqJsyL
 L0Sm7ILgw6KpAnenWxla09O1q8wWMSxHIge9mCAibjD2XvZiStJTbi1YtH8cmAIMhaZwCbrFLwN
 VOQon6cUTc3pFfQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 56539140009
X-Stat-Signature: 7id7twh81zpipzjtaexxmiy34knrgz16
X-Rspam-User: 
X-HE-Tag: 1768840162-463257
X-HE-Meta: U2FsdGVkX18P9axnhB1bh5SNtcNXK1vAfzyhC8wo1xHWTCswQ8V4wysD/SKl8VPeSxDy3OsyhS3ecbbcA00rT8b4kw9pm7+MG6FMYsZiB87WneWBpPiU2tlxhRLLHho67Yh+ZOvA46D7ZvAPqAsGpB0/sA6+5SkVFJrz9UjgQrAdhXE2W0/2dmPODvKR/E1YbTXHoT9Q1iWbyYUw8dq0+tyeidlBipaI+XPOcoKFBp348WP/BVsi4uQKeOOKT42GNhgu0BjZh6ibM3QYcBWw9h/XudJfLLndw5DUqpJHqUZyvbIWfsSHXBkly4b48K1eB4piTsqtZ1AHbZtEyKY7n1bKBxBzw4dlueZgGOFlsQ68bAqOGuvcx3751RcchcHh1rS4wjYx6BUnPjPVbojvvFpmbpXhIQufU0MPUPrzJ23ch2iS7qVvbiCbxLdbTGVS4yfTiwpsANpXJZWY/zdJCmARAqnZOB2NgIymh+nWB5yct1iuR+HKTtNgrXaqr1LMUjS3Wjtn9zXVp2xl8qN48QzG624rC/LbObrd6e34jaukIYU906Koi/Hb9DBibn7nahp533msodXtTvEwDrNilLCEov3tHcTEWj152oh4D1XQaTmu8zkd8BsPs7EaRmTyJoORgGyq9/WOHXEOygTjmy2QOdT/RXaGmkJsLAjkDcrWPys+aaLyo/OaH+VM+r+jM0kC1Y99AsdUEngBfoPLNzg9jFuPUVwUFDo2yKSE5Jfa4HDKu+D4AolzX1VLV7jaRxd5FBg/ayXxvRWTlyfdUThDmBxdUEY8L1mHp7ePusAyq4/Js2xd5aMfMU+++y2Hizolyyv+k3Q/pDdpWoHW/BQjM98kEt+km5wu6ocfCd3EyaIl0YR94VXD/VNlw0pSO5zwBcICcd9nSqqPX8MTsHK8A55q+Tp8usTPwhqdpgLefFiynPasacPUT8D4TWKgDjiA06B91qLx1WCwAQ4
 B7igKcgr
 GXLpyaXpZF+SxycrxCR2ShPSrjcxwiHTcQDGzH9Wz+dRRq3RblLFRk7prTcaTkmMVMIWdg79jBODFKms=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to overlayfs export operations to
indicate that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/overlayfs/export.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 83f80fdb156749e65a4ea0ab708cbff338dacdad..18c6aee9dd23bb450dadbe8eef9360ea268241ff 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -865,6 +865,7 @@ const struct export_operations ovl_export_operations = {
 	.fh_to_parent	= ovl_fh_to_parent,
 	.get_name	= ovl_get_name,
 	.get_parent	= ovl_get_parent,
+	.flags		= EXPORT_OP_STABLE_HANDLES,
 };
 
 /* encode_fh() encodes non-decodable file handles with nfs_export=off */

-- 
2.52.0


