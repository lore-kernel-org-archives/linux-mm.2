Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F9F8D46607
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:49:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 881626B00B3; Thu, 15 Jan 2026 12:49:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84C496B00B5; Thu, 15 Jan 2026 12:49:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7416F6B00B6; Thu, 15 Jan 2026 12:49:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 636A36B00B3
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:49:44 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3F9FFB97ED
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:49:44 +0000 (UTC)
X-FDA: 84334935888.04.B10A1C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8764D40007
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:49:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HpFXXnu7;
	spf=pass (imf27.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=62aIKj8tqE3sD4tyHvRw8zo3NxgE33Br/5r/nClLzsQ=;
	b=Etp0WoyWzNzstyQzKIiNdAtawGo22XFVU3VsP9ofNDreoNINZ+lLm2cFJ7IT7RDM8zvet4
	R+DEnE9C3+amh+ggYmevl5VaLMdsEMrV3NiYN6PoDxihDAh9g4qw7OjRo7l+C7HNNnLice
	hRZXq/koX1ZK+6nv8t716rDzws5rxzI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HpFXXnu7;
	spf=pass (imf27.hostedemail.com: domain of jlayton@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499382; a=rsa-sha256;
	cv=none;
	b=JTs3wIx0jsVX7oQcuimGLhWXci/yeOLTGGiy98O5XsJoZjzJFXIVuGUul0Lvawt1QjJyVC
	wVHakSi9mNbmmPe4IhPfV96lxkRDqb3iJ4XrrKYMfH1CYAqqFzoevLCA0Ot56ZR/OfkY+5
	oNF2iHMzL53Ny9XBx7wCAzHGje3XC7A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ED4F9601D3;
	Thu, 15 Jan 2026 17:49:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA99C116D0;
	Thu, 15 Jan 2026 17:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768499381;
	bh=3GhJ/qRusFZtrc5r83Yz5fW+XL13TprQK4YWfiaNH7c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=HpFXXnu7ERkPUAIQm1ZPAcxGId6eeLxlE0JRxT5UA4b8o91JC6MhQ6hmR8WhJIGya
	 u0ZPgVTfRojyBSEkyDYI3DwAmQo9WILZExRwe2UwHFCiNlmisjZ+6bSd+aE7ib61oJ
	 kNhQchrck1aUUpJ+OwOj/fCqXIwNg0ZxkdeofNkXA7xP2g7DfotgAEoSVqgkuY6SM5
	 Wpz8EZYj9+4Xj3LStuJyRf3j5Keqh7naAgj8vpr+lOmqqV4kroZVB7N0Bl859ATYgI
	 uzM5fmBJ5J7caSvvjP71MlmxnFVv4DuzFN9zwjzsgrw+/9iNkIATGHL5NAfE8fKRC8
	 k5qPRrxpUVgbQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Thu, 15 Jan 2026 12:47:46 -0500
Subject: [PATCH 15/29] smb/client: add EXPORT_OP_STABLE_HANDLES flag to
 export operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260115-exportfs-nfsd-v1-15-8e80160e3c0c@kernel.org>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
In-Reply-To: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
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
 Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-ext4@vger.kernel.org, 
 linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org, 
 ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
 linux-unionfs@vger.kernel.org, devel@lists.orangefs.org, 
 ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
 linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
 linux-f2fs-devel@lists.sourceforge.net, Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=733; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=3GhJ/qRusFZtrc5r83Yz5fW+XL13TprQK4YWfiaNH7c=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBpaShHXNqSO0AaJtAQ6e0iebWGL9gXuZogZL4NQ
 nd3994d03SJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCaWkoRwAKCRAADmhBGVaC
 FcJZD/995y2baNrZV9uOL0TNknTnSY1b+KmL3xbwd6ELV1X5P9GTRow0w8qgNhTp6DEdep17Xnl
 lV5nNz22mRp/8t/3leQwRnNobdVyWDmG+86VPwmUWRp3avVeIoa2Hq0+unljlviLLfMZvqyYy/P
 Kxs6fTJykAgSKjLX6C+rJOV1Mp3siFq7qgMalb81NvBiX9zHp1owHcyMqSQLk6dnRVhBpwvq8Yr
 HCE92A8xDJ3Ip129dtLuJhd2DRJMhmD7P0OezVt522x2tAQ1uGW9+y22/6QjAyty5uFASKCHvSI
 w3UV0CUln2DLh1/ExYGFtAVStJTrIxdzaoVBW95Wv/hqgnHPTA5ZPK9Mb7x6p1hGhTPsJyTJD+D
 ZfwxsjYG9BWi0T9CmUy63xFCzNqUQ2yS/5IVjEWwR90w95fFyvbdRWQqfBLXJR7156JlOwG9lmm
 LvYK/T5yQAN1YkPNeGXb/ojuDS1Qhax9xPuYWlGmJhpq9kmhgnNhCBrmeRxuXoSdsL8s3e0HFVx
 wPMeDrxdnCq4FIgMAjIVmEOYsxOVRowPOzVRxqVmY6La6z0MHQ1RC9VLmEOUHKcW5IQjJLDb2ld
 98lJr3+W1h6zW0rigSWwt4z1k87pChOwiG5A2qRhX7v35TRycTLzvQDQnkxDqIXyxoiRfeYXqGm
 8SLFEajMop9ifew==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Rspamd-Queue-Id: 8764D40007
X-Stat-Signature: q1gk6nn14fbaeu6xnwz7h39m1hthq3cn
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768499382-698688
X-HE-Meta: U2FsdGVkX1/aNfbLuiPF9elvQtoGWUZyW8gqmFOWxMr/9G43xjqWVI+Ur8YV9+JgAR33llQCEL6D0hbFuw0XTKdCE3TPEzvgbDtvtGMxhYNgmthJ4KpU1ND/tC580kyrtxQYcZIwlLSkqOAOQt/jr5E6TrrsDlv+XSXjib1MyYo2pntDxZJeZ+IKx0ybCr/M3VGAZWOF1GeSpJzGQrtrEJemd9WFWE+9RCok2hpRTvzcJk3EHTIz6ZWcZX+17j8htX3yGheK959ydcV9DKDbnbhDbwUFeyLaBls93WrO48UwR1mNB8jj3dKXYBOGpiux8rrpu13r3TODFMRlchDun0KjcJvkjw71nOXPjaI8baBrrM25AE1UBdA5Mwm7hrzrdwIlObNfjLHr0UfYaZcsZJTkKFzcQE6+vR3srlaJQzjmjzqlGwgIOLqVoDc9JxY2Xdb61iurKqvVEe2SSl02gy63TZWgnWKqwFUEZp83jt4qHJAJspltR23b/KUnSXcRzoZcdLwpsjc3wo7vwvkpFMmEVboSGKoHucU3anrG4FlNbXDbjyl/roxSi4q4A0r/wbRb7RpmiB5XHXuYqKa0/UmfqD1spxKEYMXpmS/QnIemeqC/HB8ogKPmMSQd5G4dr/0TuSx4jaBHMrspFVWPo7WOVum+eGNIdFlEdfw429HwCw8eftPy4C6gfc2UKJzaPB/Djfc0HUpKzZrmpU3/aUHGiJWiFM9/KV0QWc+Wym9aGhTOOptmav108Lxd747PuqTXQtGHjwBcVo1mKBOmU1uHTOXN1jY/h6CGYzsigL2Keu9n+0iMfxGUMl1Fa9OjodgfuFsPFfeuepsmwaetk2/f2kTlqQlw5pSSmC0eDd5Ri7jlDVZUxF9Igt0jtiVhgddqdbLCLzVfA8OEBOOm4Zcr4Boct2pyipAPbVBQsBank8P9dG3wpFMCZfMXf5FEJdisDPjfMAgeFjRjemo
 HTkKYWgv
 OvenrPV5FZh2uNDvZazlpyrjDp4+cNeJiAOLLZmspq72HV3qVecNhqq/4HHSQJ4Tk2Qpv9zPoadV2USv9PeZ1ki3uryeH25/Xr0+h4GXk2EJiN3ADpRHiIzl7cmOYQHj8d/HPjzhaAtrCPBTGKoT+XcVHCqdFsI2OL2QMDh4g7j11YptjnJHH+2zmd+bXPpLbK0Fsgr7lTLaBeaMXrFVW0RjWO1qKq7u3XVj7JoJiS5pEAkfybfkZ1PZ6e4ZRfvW1getnqad5GViTh2zNgHwPai54aBVrRyV7Rsk43S33QLX0YAPdt5G/fBZ9a6po5DOnt5j25hj1nYx/jw4AFQhmt61Jxn4OVu/WytdPXGMKMLxJGjY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the EXPORT_OP_STABLE_HANDLES flag to cifs export operations to indicate
that this filesystem can be exported via NFS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/smb/client/export.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/export.c b/fs/smb/client/export.c
index d606e8cbcb7db2b4026675bd9cbc264834687807..c1c23e21bfe610f1b5bf8d0eea64ab49e2c6ee3a 100644
--- a/fs/smb/client/export.c
+++ b/fs/smb/client/export.c
@@ -47,6 +47,7 @@ const struct export_operations cifs_export_ops = {
  * Following export operations are mandatory for NFS export support:
  *	.fh_to_dentry =
  */
+	.flags = EXPORT_OP_STABLE_HANDLES,
 };
 
 #endif /* CONFIG_CIFS_NFSD_EXPORT */

-- 
2.52.0


