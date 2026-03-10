Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3030EB1053
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:55:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D49B6B0093; Tue, 10 Mar 2026 07:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96B206B009F; Tue, 10 Mar 2026 07:55:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7452E6B0093; Tue, 10 Mar 2026 07:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1D9FB6B009E
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CDD10137557
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:29 +0000 (UTC)
X-FDA: 84529998378.03.7D004E4
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8D3B2A000B
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b="lEAp/s1F";
	spf=pass (imf25.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0/roifme+WLdPTziKMwbNdr5N/yzFbOWcvPcd+8xFnU=;
	b=RLtkQiLQGnmsoQE/axYMO7x/f6s6OUV4aniOg0UoU5sp5BIurzXzdtlTXzwCtBM4S0eLbo
	tkWD1kVskjdY3y5h1BFBkTzarvizBF1ex5kRjRPnbF6qQteiSqSCrvdDPB5LDXiht+AfEk
	Wzoqsy68+NgYqh+PcEPg7o2HkphPy6Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143727; a=rsa-sha256;
	cv=none;
	b=36GC1lKPxUb2MnktVVKByo1kYqMVAb2hj8CdZPv7uYyd0L/X9t6NTpahhEH+pmIPVpI1OV
	qrw2gSf9FYeCamVN6k2rfYwgqBaJe6StOja/vJrb6hP2ZyDgZFHh6uJosslT6LjG+T779H
	D2k6Y+Yn815fdGPQWc9CLom3cEYsFOk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b="lEAp/s1F";
	spf=pass (imf25.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143723; bh=wq/KSwJcA3hqLetMFo3dTHFYxjONcw4I7Ih9VV1gllk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=lEAp/s1FGs3gh/G3BwLm92E1HCxjGWlqxsQSbz/j1CB+Vlb/y59DpH7suq9qWHqSS
	 sYNh9xzFzAwYyP3SKrKt2sCrYh94W00YkOJHULlnCDrzYXE+bJd6oNQ88ujEwWl/IW
	 WDyVvJrtHTQ4L2Ennx46mVzCXGqAvMhY+uWIILEA=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ab-2367-7f0000032729-7f0000019cd2-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:23 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:23 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:30 +0100
Subject: [PATCH 04/61] ext4: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-4-bd63b656022d@avm.de>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
To: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
 bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
 dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
 gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
 intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, 
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
 linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-leds@vger.kernel.org, linux-media@vger.kernel.org, 
 linux-mips@vger.kernel.org, linux-mm@kvack.org, 
 linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
 linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
 linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
 linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
 linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
 linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, samba-technical@lists.samba.org, 
 sched-ext@lists.linux.dev, target-devel@vger.kernel.org, 
 tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev, 
 Philipp Hahn <phahn-oss@avm.de>
Cc: Theodore Ts'o <tytso@mit.edu>, 
 Andreas Dilger <adilger.kernel@dilger.ca>
X-Developer-Signature: v=1; a=openpgp-sha256; l=2748; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=wq/KSwJcA3hqLetMFo3dTHFYxjONcw4I7Ih9VV1gllk=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAXjBVZQh0oHFoS6hdf46zx6cg9yKqCoM11bV
 3iWUec0h4iJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAF4wAKCRA0LQZT0ays
 29vPB/9f5lFIt+0FtFBJpiKbUGS7UgY9T4E/E6CJ5zu/RqCe6vd531NLZdsmBEosrdFBBXDX57H
 sd8LCXF/sp89Zga6l1XIWkSIeHW4dDtT/UJNpkUGlvpmR4wd6cIocUQ2SKJZm2I5Ny799jzRqsU
 77XwGSzBy8rHgewt3q+d77K7620aLC+ceQfquSvw5IkT7R5aPt+VaJGvb/4d0wK060SD2e3AbrD
 KG5aPg5rty9abqBDIFiMe9sH7jc7Ssmy8RQOhQUuB/vX9zXXRZULMf0v4sI8el0Gl3lDI9uBnpn
 7EXyqizDRxBWqqlsbAFrtlRuPcNXRB2sNpMKxVhp0my3RZH1
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143723-7D482E1F-03DD7EA2/0/0
X-purgate-type: clean
X-purgate-size: 2750
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspam-User: 
X-Stat-Signature: ofmnqj4ieeo4cgwwkbya7x1xx16ak4th
X-Rspamd-Queue-Id: 8D3B2A000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1773143727-722096
X-HE-Meta: U2FsdGVkX1+E4i911rDVx3Lae+oVRKk61Y10wGbp5M0Ypr4utSidP1E27rWrg5IP0j3CqUvTeXtG47iobXkCqLoEMcFMfv3uaLc+rr8R0GctTWuzpJBBvKKjzQXXfmqblNtMVhIVrqnWW7G7+H004jNWnFbf+zUS545FLF1NXu6s2ISndZUTQMy0Uuiu+jz7M5Y3ID4XVJIZpNL/fd1xgoEoQ8Asl15jHTAXfHOJlHBQnm5gOf6QVY3wpAkvnodsJkTasLKYyTpSxnBb/LobwYML414iXBBueB3RTp8qvOPwGdO+0ugOwLgsHb09nbvHTlF1ZJb8SK7VQCg9GncsSvnNthQdbIdabt/P4AmCuVvFi3E6X1Vm+uSRGODfPZ5izivnxgJ05PbR8VlFko21D1oenheebKMn/FovsHMcvy4sH4X8nbPOyLGIHml9WPryLlgC2qlFage9pvxucshFxxJwmWiyzxi5Una43GZ4nX7J+VJbF4pZn+22sLGS5gY1pyZtZSghBggoubIRr7zkkWwqwJBnLBKT3Qbqevn7A+sg2kekkrroxq3VOBbxo9m8LSWW/26rR0Uq2b2JD+GAmlp32nYXK99H2ffu45vjZNpQfYqqlUecLIRM40clEM6vyhny2+NrB0VA7HzdQEZfraLr5x7CXCcbVHX6+oVGUBqrgfeGdjAu9my/SPxhgw8eY3JO1P2GmporIC2rM/g+j2L4DTTZNam1I3xPpHrbd2TRqG4I91AA1hfsXnYJCIYBAKg45y3HifPCVqXO436XRRVjVSRmyiOER64rby83k2nlwTb1MJZ1I4PSiwu0q+M4yrF60P4oCKQdzi8AWPhBjOS/Cgs8ajhTK4r3VExivk69bg15vGp95JWvH1oAORAfgROBadW//KyvPHzee8RmEycHqGwKdtiMGg5C6IvMemRi3/aQ8qkPOY8xUTBhYrZ+7YKsHZbQCpNVqc9BE3v
 qe1T2MRn
 83CYgeM0SxEAaTdeTdgDb4YLCYbZ6uO3yluyQY3PldvdUWIZu9XCD42TNY9ewdfXmpFwHOozmaYDj8UrpRVsejpwLHMGqVHb2k7duA09liGIHQWrAxP4JslEAwD3X2zUjXuhKUZ93RCXn6BDKZwxVhmm7aJbxK/KzjawAXa5LnLER25gUCKnBLPhymW1Tyh9Ep3lcesHXH9TLmCSbq2ICxzpmSWfzpQ455QDcRkJgN0gzm19K+368IkUkaM2An8BEY0o2OiNPAyquoN/GsTnFEYAodJC5WmruZ0vOEbY5A2HV+LTWvxdyx9QP6QNFMb59t1ZlHwp94eR9rRmDJ00hMs6aAsncDWvLa6VPrmnsWi0n3IeoYFSrHPGddP2wMN167Oh2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: "Theodore Ts'o" <tytso@mit.edu>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 fs/ext4/fast_commit.c | 2 +-
 fs/ext4/mballoc.c     | 2 +-
 fs/ext4/namei.c       | 2 +-
 fs/ext4/symlink.c     | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index f575751f1cae430eead31afa4f7d03ade1099d4a..bc69ac1195acb823465e735572b8a21255d485f5 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -320,7 +320,7 @@ void ext4_fc_mark_ineligible(struct super_block *sb, int reason, handle_t *handl
 	if (ext4_fc_disabled(sb))
 		return;
 
-	if (handle && !IS_ERR(handle))
+	if (!IS_ERR_OR_NULL(handle))
 		tid = handle->h_transaction->t_tid;
 	else {
 		read_lock(&sbi->s_journal->j_state_lock);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 20e9fdaf4301b61c9d54401ed95067db6b6b8173..d7f004817c1ff758e4e25f84b2c27238b7420f84 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2870,7 +2870,7 @@ ext4_group_t ext4_mb_prefetch(struct super_block *sb, ext4_group_t group,
 		    EXT4_MB_GRP_NEED_INIT(grp) &&
 		    ext4_free_group_clusters(sb, gdp) > 0 ) {
 			bh = ext4_read_block_bitmap_nowait(sb, group, true);
-			if (bh && !IS_ERR(bh)) {
+			if (!IS_ERR_OR_NULL(bh)) {
 				if (!buffer_uptodate(bh) && cnt)
 					(*cnt)++;
 				brelse(bh);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index c4b5e252af0efbfcbaf83688a32d445327a74a02..4fdfc81f79028a588b3c1f912bff5e8a52cd9f13 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -723,7 +723,7 @@ struct stats dx_show_entries(struct dx_hash_info *hinfo, struct inode *dir,
 		struct stats stats;
 		printk("%s%3u:%03u hash %8x/%8x ",levels?"":"   ", i, block, hash, range);
 		bh = ext4_bread(NULL,dir, block, 0);
-		if (!bh || IS_ERR(bh))
+		if (IS_ERR_OR_NULL(bh))
 			continue;
 		stats = levels?
 		   dx_show_entries(hinfo, dir, ((struct dx_node *) bh->b_data)->entries, levels - 1):
diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
index 645240cc0229fe4a2eda4499ae4a834fe3bd3a66..b612262719ede35d2612c5834d2bef7f18215516 100644
--- a/fs/ext4/symlink.c
+++ b/fs/ext4/symlink.c
@@ -92,7 +92,7 @@ static const char *ext4_get_link(struct dentry *dentry, struct inode *inode,
 
 	if (!dentry) {
 		bh = ext4_getblk(NULL, inode, 0, EXT4_GET_BLOCKS_CACHED_NOWAIT);
-		if (IS_ERR(bh) || !bh)
+		if (IS_ERR_OR_NULL(bh))
 			return ERR_PTR(-ECHILD);
 		if (!ext4_buffer_uptodate(bh)) {
 			brelse(bh);

-- 
2.43.0


