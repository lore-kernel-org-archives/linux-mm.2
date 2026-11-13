Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50392606A339
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Eop4DJ+y
Received: by kanga.kvack.org (Postfix)
	id 427BF6B0707; Fri, 13 Nov 2026 07:02:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D88C6B0708; Fri, 13 Nov 2026 07:02:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 315576B0709; Fri, 13 Nov 2026 07:02:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EFE1C6B0707
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:02:28 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 61FF4160395
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:02:28 +0000 (UTC)
X-FDA: 85429958376.13.F38A7FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 904C480008
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:02:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Eop4DJ+y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794571346;
	b=7CpY8m8GKCyLpfT+AGiHVfYdzpzuhk4i8cGTcQ0RJ5taUErl5pe7cZmHkimyH383RrzHlr
	huC3F4pjj9FULPRDM7Y1TWiMEoT6eO1OED/SNUT98XaxZHbxt6GNoe+ErMTODWGuo2MJoL
	pozZu4UXtgo8EgPx5Xr8M+6NGuJFmRM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794571346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ys3YMXl5oMlmXRh6V3Opwtt0DjuOynQe0v2BdPk6TCg=;
	b=qTc8hi+I5KKVB6YnjEsos7VkSK/IZsBng394D6aVdnrkURaKFzEKnQk6lMcX8zib6b2Tf+
	IDaOlWG1SkaUpjDWRHhhlwgwkCEvMZqZ7Qg06PXS9vxYyGMUV9t+GLciKgax5bG3oH/Vfy
	msn0RK+2NXyJ8j7uUth+mDNZ7OXdXqQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Eop4DJ+y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E00DD41137;
	Fri, 13 Nov 2026 12:02:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950221F000C6;
	Fri, 13 Nov 2026 12:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571345;
	bh=Ys3YMXl5oMlmXRh6V3Opwtt0DjuOynQe0v2BdPk6TCg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Eop4DJ+yxDliZwyInAuNW8c3JHZf+X5C54FWRtqZtQrZ8ZzgrkakpbSmsnVcEyCFJ
	 uBy2Rr1UZrQWWl4dcr/zHxb3DnQoqEjV//kydM+Z4LWDLA6xrXgz1cvLWobpAqMJoD
	 s6EFw/9Gp9VX/gBBLbwRC0Lh5DJaKGw6dDShXcH+2rqCc78FILZNz5SPyMJ/8rt02Z
	 /Uc6drxqxlb/0B/1hTazmRyYdQPnOshcKXZMTAaXSaJeDakqkIVGljHsPYkwixDDIf
	 SE6uZqlFv8y+n9E/MMjBpudPTsEDkGmMS5LyyNOQolZRvDHUiUhKhYi3kFb1AIR8r5
	 NBVdDdqDKYOPA==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:27 +0100
Subject: [PATCH v3 31/33] ext4: allow remounting read-only in the emergency
 state
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-31-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org, 
 Jan Kara <jack@suse.cz>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2358; i=brauner@kernel.org;
 h=from:subject:message-id; bh=fD+vdKPUstldI8+nFemEF3fb/4i0Xe3BUPEtvaff8Ps=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+73PxbtLyE9xTqkEb1nnpvBAb46ZBnddePYs722qt
 HuqemBRRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwES21TH84W+KMud47KIe7zf5
 5L17f8sPWkjIMB2Y+z3mHDv3ubbTDIwMTVmCIRs8JETqL4azM9raN+mvlAlnzbtd/pHjEOOfA4H
 sAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 904C480008
X-Rspamd-Server: rspam12
X-Stat-Signature: z895kypwykcyx7dsahjam1c93ipb95m8
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794571346-291129
X-HE-Meta: U2FsdGVkX18OcwbiysKyZQDxa4x3YL0AJsAcsII3CbeBpuqIXakIPWEyIVwAatp2t+1GgPdcm0X3MXieuHGwE31cIEuUn4YZBEWIfWzytmN26CMDw0Y8sk3aIlcW9fSVD7ewOQIJeo80QQAnqjnrd2QgNBuxEBo+CMo7r5VKLBEGsh0dp9UhSgEi7IcEL0xeD6W1iyCAU+KLEKA6XWDXaXOOB3waltLWfSKEEwTVkj6sVx8XxVRiJhMQ+998MXFGSa/84WMY7N2wCM1dUDEWTIeAm0z9cbiMzNseJhTLCA6jwLAyhGfB3JQtTLfw/H3f9vKzekh8A+VmkuKextucRkm/OMTftkk1yWLo0UOFL4a9FC9y55R80sX0L2UvX7ppWdIA8RNSq4iUE3Tqe5o1drhDtAcKXWVz4bMD86uluTaPJ/lTd7gstadotN7IOY4a9mfdT1Qe4U4n/4UeH+xZfw9rTmIqofJj3gxkGIOREn8NMNtlmNZ9rGxd6I5MKo9Fs1ad6ItAORsJvDuLFsARI9fiUdF1KtThAAMid3uM3R9Q3bNCCJTr5Ho2aBzMiVraoar0bVmDKB3L7kcYCz9VVh2xJypMOpC3snMWZNXdlfbvpO1c+dEGMfLqEkR3RqvpDTSmAoie6gi0BsNvinCCSsU9lyIVZ+RJelErNPNyXmEdGPPOuiLf6P2odkkn0lJLI8CD+M4Ixd/cC+Xgi4Fa7UsOeysXRBBtM28anYR5n2x+GD9lrzJmSUi8s2mc1lb56OwA02dkmhenDFrvSQGi1UsPF1FhhpmpH7zj44NeJ/WHRn3veiNDf19HAfNBXxOLsefEH5Ek6SHDE9AE6JF4DwUnKQbH1g7XwfavHzvRl9/zKVtl9eqwMxHyF9huIR2uohqvCZaz2SBVL4hMUNMl9zfmAyHQE2FBaL5JyZMxYOqeXmcGpD0BpgXacNUcLdUxH1nEfL6m+J21ZU0PA/d
 GK96Irwf
 zBNVW1/+dTPdkIIub4uCVu4T+3iYHhjh0bDjDJlgDY2AafelWdLV5BntwQlpURP4VCYRygtcWC9BfGndSkN4PEe1Ynd+7bndjAQIl6ziZcJEx2UGzArpQ/XYQwquBlxqZzYfnGxFusCi3EyXky1nRvhWVTs8wiQHOuuxPGWIwcvMSdx9tRv0IHcWFKKhaTCtoFFAZWsolm2aaeLAJneRtBfS3xuHiufe1hIYJa+eL6yEPNDzC2Tfq40hCuILVRH//ONrIWVqQhvPsqMN6KQLyHa7w8S+kydaqqF9iOyc1dk9cm9YtrLKF6ptsb56DeyUJZz+C5+CUmFXLYWEn+mBb8wXu3GSe4S+ED74HtnVKrutREGKJu2SxqwXwfeckrqlZVsukuupoj8YZsybLtxPZaKn6Kj63Zfzm3Q7Rjxi3vZoikwgWFOa5HNBSXCD9l/DrcJmMenMY4lPc4tWQsHQiUcg9TiJ/hli2x76t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__ext4_remount() refuses any change of the read-only state with EROFS
while ext4_emergency_state() is set, i.e. after a shutdown or an error.
Neither sets SB_RDONLY anymore, so a remount to read-only fails and the
filesystem stays read-write. Emergency remount (sysrq u) asks with
SB_FORCE and reconfigure_super() WARNs, a panic with panic_on_warn:

  forced remount of a ext4 fs returned -30

Becoming read-only doesn't need to write anything. So allow it and skip
everything in that branch that would touch the disk: sync_filesystem(),
dquot_suspend(), the s_state update, ext4_mark_recovery_complete() and
the superblock commit without a journal. Going read-write is still
refused.

Note that ext4_emergency_state() only exists since v6.15. Older stable
trees need ext4_forced_shutdown() instead.

Fixes: 95257987a638 ("ext4: drop EXT4_MF_FS_ABORTED flag")
Fixes: d3476f3dad4a ("ext4: don't set SB_RDONLY after filesystem errors")
Cc: stable@vger.kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ext4/super.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9cae52471dee9..ae5ba6823c01c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6761,11 +6761,16 @@ static int __ext4_remount(struct fs_context *fc, struct super_block *sb)
 
 	if ((bool)(fc->sb_flags & SB_RDONLY) != sb_rdonly(sb)) {
 		if (ext4_emergency_state(sb)) {
-			err = -EROFS;
-			goto restore_opts;
-		}
-
-		if (fc->sb_flags & SB_RDONLY) {
+			/*
+			 * Going read-only must work for emergency remount
+			 * (sysrq u) but nothing may be written, just flip it.
+			 */
+			if (!(fc->sb_flags & SB_RDONLY)) {
+				err = -EROFS;
+				goto restore_opts;
+			}
+			sb->s_flags |= SB_RDONLY;
+		} else if (fc->sb_flags & SB_RDONLY) {
 			err = sync_filesystem(sb);
 			if (err < 0)
 				goto restore_opts;
@@ -6876,7 +6881,8 @@ static int __ext4_remount(struct fs_context *fc, struct super_block *sb)
 			goto restore_opts;
 	}
 
-	if (sbi->s_journal == NULL && !(old_sb_flags & SB_RDONLY)) {
+	if (sbi->s_journal == NULL && !(old_sb_flags & SB_RDONLY) &&
+	    !ext4_emergency_state(sb)) {
 		err = ext4_commit_super(sb);
 		if (err)
 			goto restore_opts;

-- 
2.53.0


