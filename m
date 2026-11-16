Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8E09606A884
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VaZ6rFBA
Received: by kanga.kvack.org (Postfix)
	id C65F56B05CB; Mon, 16 Nov 2026 04:51:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3E0F6B05CC; Mon, 16 Nov 2026 04:51:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B54716B05CD; Mon, 16 Nov 2026 04:51:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 944E96B05CB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:51:18 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 248651A076D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:51:18 +0000 (UTC)
X-FDA: 85440514236.09.3060034
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5A98D40006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:51:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VaZ6rFBA;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794822676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EzogT95rPEGnXO3ATl8QCqS0Fa+QqsMtxOYoDzHb5QM=;
	b=y2LdAnGfWiSPhdUk7qk9mgrF2F5sQEaPnY1k6bz2EIpvFyeEDj0xnua5CjMhjmgMsq6KaD
	nuJR8AdVaKnbLrwlmn/hHS5GX0LpZCn9PhhrO95AU2KoF/cXfJKhIbMs9Y5jKEmG15LhDU
	XPGkPtaEtil9Fe/MxO9urEcd/ThoDHs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794822676;
	b=BEhZEAS7RtaWDtMs+Wovo5JiGn00BsoeARNXfd+8jt3fjoLQNmfH83G/UdBh3PSiYTOO35
	BT/3fmivuTuv9JBfTOmMxoJkKzo9tNEbAFVkLneNWudmFnUOgiUjoXyAxyFAPWKFfmzT3i
	War56G8oeFNv7NYODfDWfoJow7N7SU8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VaZ6rFBA;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AC3AC41197;
	Mon, 16 Nov 2026 09:51:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014C81F000C6;
	Mon, 16 Nov 2026 09:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822675;
	bh=EzogT95rPEGnXO3ATl8QCqS0Fa+QqsMtxOYoDzHb5QM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VaZ6rFBAYjR/HM5+OlC/kYBh9eokBcyBlJyjLDEGD3pr/1owKWYUkIFonZyVuLy45
	 aXIGPPwoZFzAFIrDJPr3o4d1FYCF6gEzK4gRGZMRojP6nXuxOYWP66LFhY7XK4EIId
	 0F9FdRrfySm5SdHKaihGgGUwCpa5ozWOd3R+kAWEW0AOMp5LPHNYZv/BWBQ180WmCq
	 SGYcL6yKiAUlp1bl5aKgR19AOXfXXbOhxIdLs6gAifxrWtNtvWUXEAaCGYUZCiGaa7
	 +ReHVuM/M8xxPRelVNj4Hcpgf82OBXtXi/ghPvFAodx9BDyUzwtyIaiRzYrfov1A8G
	 2aAwCB6uJL+Jw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 10:28:32 +0100
Subject: [PATCH 3/3] jfs: refuse inodes with a negative size
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-fs-sb_rdonly-fixes-v1-3-95a25ce917ad@kernel.org>
References: <20261116-work-fs-sb_rdonly-fixes-v1-0-95a25ce917ad@kernel.org>
In-Reply-To: <20261116-work-fs-sb_rdonly-fixes-v1-0-95a25ce917ad@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.com>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1127; i=brauner@kernel.org;
 h=from:subject:message-id; bh=onsWAswaduk9DxHd2totA7LRgkoacrrwUPGlfjERZww=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9uvg/zPh7v4jJl9XJS1adTMmvc90Wskhx45urIQq/v
 +i4RRtkd5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzExJjhf0I6X6NS5kOr9nci
 S1rdsg7WHb7PbXFnnvjvWZ/2HONbz87I0MOYE+3LnyrOK2+kdcN71Zd5ak/MHTqmCyzTLfcoFP/
 EDgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 8hcdbpbjn4d9cq9111mkqrfjyphw1yg9
X-Rspamd-Queue-Id: 5A98D40006
X-Rspam-User: 
X-HE-Tag: 1794822676-68243
X-HE-Meta: U2FsdGVkX18sPU5idPe/q7e5nsFgRlxGfW5OOvUO0Nrf+kWSS3hiu/WClVli1Z4nhT0GhrLZk5lHtj0lXwke9SSxbCvt6LquaId1ze80qjlgfymQIjzsy2vni3TX8xWJaHb3ml57hHlw0bSlQ2SKq5obQFcGnKVdszhXP/yL670b9kU951iM29inNx62uFYkE8U6KdO7YRc4vOMNYnZ0LFsyfoUg5z89JNqejPRKUCil0lsQKVPlWoN0csqubhXtETeu3VKXGNR1SNDCgDIxz7vPq78j5ImHFyMYp6p9xYI3L436vqneC94IxB04HyLxsuYD68jNwULMipd9k1qSgTlI1xf0u7K0Cdi41Vb6m2RhtsfIGVHKI3WHGoP2mvl4YUg4OI++xoED4jK8niYAYZ3f2HL2u+IqlVvhIbGP8ALbvALDt8vtqd4xDnZpbJIpaA/mXXCk77fevufcvoQv//paT1QMfk+FXTqaVYS//dCsSoUElTj/P6oMizrVl99VwK5pci0Vva2EZ3YV2PSToavswhogvepTOu+IJaDwkZUcvM4KCStYyd42IijB7hm+7e4+WG9PnELbg51rZJFO7sZdjQ78QHNmgxFtf5ex/8/AIK+KXHIC1ViGE+aSpYZZ2KBp0OPKN65AnC8G3mnn/eOIyfLLN25F+pTiKYlBbEgIjIhrUAGljusltgOyamlRwJ5glH/zvqBNMtELibpM7oDAkegobGnaIczGm3zAH9Jv8d+O10HQYl4tlGrKZh0X82njLGuGC5S9gWk9njMTQ+7Y48IclRAvg08oiLlzCxUpwcwHpMvCeuub7/qvw0kRxjyG+8AwDD9A5KbbRGw3LgdqkkACG8pItDhxniPV3kVCzd6EBkH7it4gDoQqDgDxbAWwlCRa7ebrjm6Rt1Xfu//e4YhvPD+SY4MWLc3rISzqqCSjps//snB7YyKkhe+Pn7ERvatGZv0pk7csY1Y
 HyTHVRZQ
 74wzKmUvWYv/wg62BaRgfblx3EwZZeUW8ChxMKnDK0epkm22+AOhu89+ZLBRY3WPQ2JSabAEkdXXBxvMcu+SQNSX2/kEzMirm1jy7DW9Ea6YGegQFndYgZ8owe9WvBaqxT49uRIc5Eup9XixKCVmfeQ8aDlP7DS7bOVojfynPdO1ovJ5+pSu4nh1K9RXGjM9D9Bk1gOS3oaE29uhX6O0b4jtlIwpqHhC0A8slcFupGgur2q3y5Ysj6OisO+EHHAUQqd99HouvtDPEbqymKbCwkoP9j2mn3QX9jUxA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

copy_from_dinode() takes di_size as is and a crafted image can store a
size that is negative as a loff_t. For a symlink that passes the signed
i_size >= IDATASIZE test in jfs_iget(), so it's treated as a fast
symlink and i_link[i_size] = '\0' writes out of bounds. Refuse a
negative size when reading the inode like a corrupt dtroot.

Fixes: d69e83d99cf8 ("jfs: ensure symlinks are NUL-terminated")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/jfs/jfs_imap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/jfs/jfs_imap.c b/fs/jfs/jfs_imap.c
index b84ba4d7dfb44..f88e228d12620 100644
--- a/fs/jfs/jfs_imap.c
+++ b/fs/jfs/jfs_imap.c
@@ -3079,6 +3079,10 @@ static int copy_from_dinode(struct dinode * dip, struct inode *ip)
 	}
 
 	ip->i_size = le64_to_cpu(dip->di_size);
+	if (ip->i_size < 0) {
+		jfs_error(ip->i_sb, "Negative inode size\n");
+		return -EIO;
+	}
 	inode_set_atime(ip, le32_to_cpu(dip->di_atime.tv_sec),
 			le32_to_cpu(dip->di_atime.tv_nsec));
 	inode_set_mtime(ip, le32_to_cpu(dip->di_mtime.tv_sec),

-- 
2.53.0


