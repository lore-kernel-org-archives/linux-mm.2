Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64A32606A9C5
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 16:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LBGAP223
Received: by kanga.kvack.org (Postfix)
	id 8220F6B05FD; Thu, 29 Oct 2026 12:09:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D2806B05FF; Thu, 29 Oct 2026 12:09:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 710076B0600; Thu, 29 Oct 2026 12:09:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A8456B05FD
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:09:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C3D9B16030C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:09:35 +0000 (UTC)
X-FDA: 85376149110.08.5BCAE8D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 117B820006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:09:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LBGAP223;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793290174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Pp7M5kHXjNf3+1q9VkVlIi5dRXg3Q7oc/xEP3VOCsw=;
	b=lt3HxCkwyU42vp4daFiGotTAOlKmpdiAXR9OiNLrrRk7iyhfbRZ8L1yR0M9BxaxFsB2m61
	SghIS+TDPEsJ7QZB+K1FNotYCkcnbDfHW5Pt9cMy10xII8CeSFSYjjyVS4ryPGjK3+6DQO
	6D8tL91xO3UaLsXeofjjl3X4X8PP3fY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LBGAP223;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793290174;
	b=E4/7cEL2jnmdNExTEm7mbcsZGAREzXWkw1QA1tEfEC5qbpZZ4ex5pRuXoBXHaBmYyD0BXq
	6awrSKp6SZeKx01sejkrWO+My7E2FMZ7CjoFIWcdg2Y4GnHFt9/cxHLwmrO/S0Z/ydjH4M
	S/KoVkTcusT6jot3ahXg2JlUK6gW2ns=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD3E460627;
	Thu, 29 Oct 2026 16:09:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFD41F01825;
	Thu, 29 Oct 2026 16:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290173;
	bh=5Pp7M5kHXjNf3+1q9VkVlIi5dRXg3Q7oc/xEP3VOCsw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LBGAP2234hdWhTWmkiwtcNBNLZv3kdKW7A12H240APspISuOw8K0/DrAk7cojALfy
	 eCHxkuc1RjFeg9gL9Niid947L2sIZw0O1vp4xM3WSlJ/cIZ+6GJwJzAmYhb1pUSigM
	 elffXST2g2mTJoisTvyydqNgN1fAMiS9HWcTtk4UGR/v1R9ojlbwgaxL0cJDVDkGH9
	 fLOAD9/SI1nCadBee7QduMMaKKYC16TUXwXDzVE2+RpABZBbICCzAn71NbYDalAJBA
	 xiIoaKYRb9NGzWeBGBwaNy4g1sVrHEexNQhZrmOdcjHIG9gTW2Z0Jjt2hJygAQl/kT
	 0cCHArmLVPfmA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:22 +0100
Subject: [PATCH v2 31/34] ext4: use the generic emergency read-only state
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-work-fs-sb_rdonly-v2-31-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=980; i=brauner@kernel.org;
 h=from:subject:message-id; bh=QT9bEmgMx7HOZfltPAgtswWtwVjCWwJIOMw37FP7ctQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9zjeY/8T6pH+S+Yw5W3oCW1aZtRdPydBI8eCT75jgs
 r9D4FRARykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwET8kxkZDm07O8G75MpxzcAF
 s/+9sTCSZFr/8Vf0/KXT3zcKLp8yg53hf0Dn32fFXMe3rvnJUbozJu2VU4WVc/3d0K9vLs7e8dD
 mBxcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 117B820006
X-Rspam-User: 
X-Stat-Signature: g5w34mc79d5f3sudktusc6hg4ozohkc4
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793290173-635064
X-HE-Meta: U2FsdGVkX19ZSdpDS5oyCWuWyRz0IAPcayamu8Ap8/cZQJxD+hjPzGRvvAtPmSaV5zH45FAqiz0WlU+YSn6+2pBy3SEiKKFh2RCACznuX19DqGANZv3r106nuBxAO0/51Mi94PSwxRn4MIXui1Ueye1M/RcQG+FdrDFTOeMtbBl3gGt+pmmBqYnGX5YMJXKjMENdA0ZdEa67DDlkrfd2IQdTwhkwVD48wXf1Ol52HaoR3v5uaLzolx69AIp/Ym0ODvz4am31onC7Lfhjto8jHZPKdGB+Jt1wcM9i/EOaFE2DrFLD8aLwgEhrUn6DhBHrellp5QyMfJUhw/8L3htqj2FrWU6rV7oMbxDAzLSugg+H+DUiANKRL6HJAAuId+RUag7J8G55XIYIWwAMa8na5fWkyU2QW54bxBLKrqx73zz03xl93+/qtOHxOWc4ZSKb5z6BIjRkbjEJedHtldl/Ty4pd8yLWhPm7vtZZBF9tN7w3wEjjA3hCBLVnos2ThQa2ycPV4sSSvw8se1+rK9884OE8+aiRDJNsfYcnmK7DlG0RG0cRl06TqXKOBZFq6TLjnf8CzG+R1E/X3IMbu23otFCs+ppG20+L1V+G42Ssf6sGQPKjw9kgr88UtTjK1JnbdrRLbLSzljxwVftFnmlGSGLmO0wf73dPRYoaKMvV9PLs/QEAMNGkSSHawFIBQkvOjcUXvdaBA7YWJKXUOalItLZbdyorgTlno/0hsYBwd+v4bfPTfr2VvCZvaLae32fXNdrWvCZApuAMF2JDguqxCztKDe5OM8Rab0fXtMPh3OT8LC+PzmYVqo4MWJzlNxfobE/x9ey6zfqMH78o01qNxDQXeAFiw4dQQI0PTstA69UUHd1k5VUWdnDTpS6Q/MLazzVOpXN/YOSk751+J4q+KozEfhW9g75vJpIztTPlkNplyQoo8yIf3uYZDnYdXwyEjKC79rrtj5iu3x7GAD
 Ea9PVWTx
 rpidm1V6ENZzORaNK7/1Bb9bLogoej5qTqO2SiM/31tF6oSgCd7WlYH1jp7KgKxqy9g7gSCeXaLAdwP3+hUm8bb/7XVeYO4hRj6QIN2spG1WN14+jBT2OCBuC4V4Sye6IrpYoKmSQE9L7EFw23BWv4LQt7iaqe8oYjeHZWmj5ofhjSXQm7aAJE9zjT9rjPPyLxQn1P/ez7qUoIT9F4g8P/zd3eV0bwBJbMOSo+50vT0ZDhA4ZJW52TImVYUMoVHFPgXg6uoSRLP5CPXwcmd5zyXStAcMUE0jcbrrZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Set SB_STATE_EMERGENCY_RO next to EXT4_FLAGS_EMERGENCY_RO when an error
makes the filesystem read-only. The VFS then refuses modifications
before they reach ext4 and reports the superblock as read-only like it
did when ext4 still set SB_RDONLY. The shutdown state stays ext4's own
and so do all of ext4's checks because they cover both states. ext4
keeps showing "emergency_ro" in its mount options.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext4/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ae5ba6823c01..afbdbb607b14 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -757,6 +757,7 @@ static void ext4_handle_error(struct super_block *sb, bool force_ro, int error,
 	 * and other problems.
 	 */
 	set_bit(EXT4_FLAGS_EMERGENCY_RO, &EXT4_SB(sb)->s_ext4_flags);
+	sb_set_emergency_ro(sb);
 }
 
 static void update_super_work(struct work_struct *work)

-- 
2.53.0


