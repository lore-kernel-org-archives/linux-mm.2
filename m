Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4D53606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JBumoDPl
Received: by kanga.kvack.org (Postfix)
	id DC49A6B06F1; Fri, 13 Nov 2026 07:01:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D745A6B06F3; Fri, 13 Nov 2026 07:01:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB0CB6B06F4; Fri, 13 Nov 2026 07:01:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF2026B06F1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:01:44 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 539504022A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:01:44 +0000 (UTC)
X-FDA: 85429956528.11.10F31D7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 77E10160010
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:01:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JBumoDPl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794571302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J7gadPQUzR3XBSmIK0cp3E2gwMCGpvAcu+l4Mgbphw4=;
	b=Thmk6o8OdFmc7stYUu+si8QOHYH4ktLj6pnZrshqqrHC/I/Pdg92/0LNdKJuU+eHhLIShw
	Jyj0kmxba9ZnSronMUjvNGqhNYAobcreCxEpAiR9UwK0C3uzCwnb0r8f4+59Hf3ZUPJgEF
	3DBECJJCLGQvP8Djsc6nu8z9grO26A4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JBumoDPl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794571302;
	b=w+RCV44qaUhS7V+GS1wB/9Ggs6MYeitddfLoYA/0usz7kjC2yXlNYB3Monnv/a9zBxcTiy
	+UTZ+l6TVhSdcj19xECYsqvTurxHVTwQq++/QcLuZBJ5bZFVn/LqC0U5y+SwgwSZEd6gR2
	bjn8GRoDx8Lk/CwrumHyzYk0mYgRZgQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 12FFB62602;
	Fri, 13 Nov 2026 12:01:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D191F000C4;
	Fri, 13 Nov 2026 12:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571301;
	bh=J7gadPQUzR3XBSmIK0cp3E2gwMCGpvAcu+l4Mgbphw4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JBumoDPlxQXXObG+ENpLQRg+t+pJCQJKdzOvzMvcSQDv2bqSEBwDjrp3w1ZJICxEW
	 B0guxIMp38vWFiJoKU7w63N+lTPzPQ2LkjFcT/QDyAAOI1O8kdAnuPRHrl3e3XuVCB
	 TSCr/0rlxJ5nsfX1kLTjNzzFjhDibzZaNloTL/oHrBBCwZYGzHDLviiPSTFD8XRChY
	 LcMmvS1DCAEFQIuJqxgaxVcaUHhhRZW9kBi2CQrHZD8rpXN2eItKeDApeZaNQZo+We
	 C2mGZ3sNNTlqHzUyc8xwf/zv5h4xzePYJAxJHtqB8Um42kkmVDme5JAozP/FP2acNh
	 zuOP4bYJCUSVg==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:17 +0100
Subject: [PATCH v3 21/33] ocfs2: keep the current mount options on remount
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-21-0be92bb73709@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Joseph Qi <joseph.qi@linux.alibaba.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1851; i=brauner@kernel.org;
 h=from:subject:message-id; bh=MPSPYKPscgP2L/4Ifq6qWngN+LUYlTiiBsWETuYkkwI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+71pS1J+tnkA9wxmpgChycfyqj1zb0/6KFzw6bjE7
 hnCRaV7OkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYybSLDf6eO6XvTK9W4zDY0
 sax5OT9H8csGnotPN5zN+rl+52WB/umMDK+4XvFKdtoqFeWvSzSvyZnu/6SE8yzjS4vTtccNdYs
 ncwMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 77E10160010
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 8rgx3h46x437q3jgutpb5z6zoiy53i4a
X-HE-Tag: 1794571302-825462
X-HE-Meta: U2FsdGVkX19L0vMeVHa+W6yoLkyA8BJLAchwwG6aoi0eqAlv+eFQgMvUJJ28zIVuTGNm80Fp17UjyfnBVbVrrN+jk6CyYj5CQytuIMYR0Lu9H0zIMzKeZNu3fGvGPCudA8nTUT288cUPNP+5mHWz+11QlHMviEcwScO1e0JWMylvV90LoDcRt+ChbZqeMt9Q48RBwWBwB6cByd+WPFr+V1APVq01PuWDYXcLhWKkrk2C65bl9bry/0h1SRAPEDumkTcBoF18NqtftZvDA0eUGnoJB6dsjFFXE2CbuvqAZ8VL1CtVpbjVa82DUXlzCPBla84NC2IXprf/oXsUCRki6eDkKsgsLRT/qY1vhRFJvfnKXorqmdFLuwE5tPOS08JD+Cqq/rFoaPzWh1Y0kAcW4nx9G1lP+SeTfMcGlN2LlnuTjevL6WB8+/xmj8Vwoej2CXeSb3fbkU7Dl5rwwOGM2ICMgQvte5KIuHDLD2nb3o1nYaV2TPnC35/EYLA8hUZExKNNkE5QisKDi32gjoDv2fghLHTMGRvYNromyVJKdvVat1Ms5Fse7pTWzZPed/HfFBFIo4MRqqOWybLZ8HWOJeolepKcDjFHzft9ERmwyMy/xXe9Dl4tSAR9CgIQ9wi8WMxrmpI5308Lm09/7BGumB2/17ZYczpICrjD8ZlN9SF4ZnaEaw3M7pOiTE0XfrIm9EBWlW/0zzhQlJddLQs1nXvG6BaHDSv3lirOqOHStdja7gmvkXJKPiOqNfJ9AUAlFmPSq2ZXW/oGLsm5E8PcPHYR3eCjO2LGT3WTYEdSZhFuWEQ97AVnmvKxjxo77RxrNuf1qOK76LXVqXSAYH0xHDa/o8ShDpNw9PTDeqGk7INhEBPiw2a/UnoLhcLx0ZjDMPHI9ylAj3UrNuAakMfUCZ+D34Za4gSsNhouN8HBjJ1didhakfDhvUJc9NzwpiLKbRAVDM9ouzW8SYSzYej
 8C4dB4FD
 bMULKIWzvZRT6dIc1J3er0r9DBrUNDMlexLuLVBw95LAawDxtAd/O8PGJznTW2oLATp5wE58Gd9aXr3v3mDmR3pLD5rf0nYzIS0awJIC8ysM3NYFXl77ji0bpPKSKQnYz7Jv/H4RGl4fnD5CmUqpaFnt2UKWZdnE/ocFU/i3KcUrpgQTrDNOgzvYhqCXxFOWnBWO6DVCQvyR2NYsZAAxpGQXlIrwOSUBGhpxren/rv+8l6fae9yMZT0nEtrHuuQ4GKE/nFHEjaZ5XscybXVLuL2djLarqTS5BciH0ckgauj2w77dqZJpMbXF6ZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ocfs2_init_fs_context() doesn't inherit the current mount options for a
reconfigure. But ocfs2_check_set_options() insists on exactly one
heartbeat mode and ocfs2_reconfigure() refuses to change the data mode.
So every remount without heartbeat= fails with EINVAL, including
emergency remount (sysrq u) which passes no options at all, and that
WARNs for every ocfs2 mounted read-write. A remount that does pass
heartbeat= silently resets every option it doesn't repeat, e.g. noacl,
errors=, barrier= and preferred_slot=.

So start a reconfigure from the current options like exfat and gfs2 do.
Asking for a different data or heartbeat mode still fails with EINVAL.

The next patch stops ocfs2 from setting SB_RDONLY after errors. An
errored ocfs2 then stays read-write and emergency remount would run into
this as well.

Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ocfs2/super.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 0af2245ae3036..67283244426e0 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1222,6 +1222,19 @@ static int ocfs2_init_fs_context(struct fs_context *fc)
 	mopt->resv_level = OCFS2_DEFAULT_RESV_LEVEL;
 	mopt->dir_resv_level = -1;
 
+	/*
+	 * Start from the current options so a remount only changes what it
+	 * specifies, emergency remount passes none at all.
+	 */
+	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
+		struct ocfs2_super *osb = OCFS2_SB(fc->root->d_sb);
+
+		mopt->mount_opt = osb->s_mount_opt;
+		mopt->atime_quantum = osb->s_atime_quantum;
+		mopt->slot = osb->preferred_slot;
+		mopt->user_stack = ocfs2_userspace_stack(osb);
+	}
+
 	fc->fs_private = mopt;
 	fc->ops = &ocfs2_context_ops;
 

-- 
2.53.0


