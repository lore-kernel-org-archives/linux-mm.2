Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 167E1EB1052
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:55:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3BE16B0095; Tue, 10 Mar 2026 07:55:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90F7A6B0096; Tue, 10 Mar 2026 07:55:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77BE76B0092; Tue, 10 Mar 2026 07:55:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5E4146B0092
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DC5241BE7D
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:28 +0000 (UTC)
X-FDA: 84529998336.14.7D1093A
Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	by imf08.hostedemail.com (Postfix) with ESMTP id DB0CB160002
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zS/lt7IufKQt9b00w4tg0H1pDBP8jbAdIjOpgPRguTw=;
	b=vxEXlKelXYzD4+3KQEo+CBFwlYKG6Q5iyQpH/8Cmm9LegZJWnvhhgWqzDXAmhSNnxuJkIE
	78NlH/9VTjXqYowzxUW0rcQ/1oPNVCmCKS56SnHA52VLhDCWX7Q1pL37y5lXkD0XqwpK2W
	KmCbzk16huyfO9gby/pwNo999khoSO0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143727; a=rsa-sha256;
	cv=none;
	b=0sZtYYSukPhdpyf8KpOERe70GbTgJHCib4YktR1cQde8PeflmakR7oQ6JiVDBJSATmrwYv
	VNI+CqLoR1IQ5TiPhvSqf85vpWwrrzNXJ1WaogYSsSe0iGuDjsQ1P4S/fkPlIeByeXtrwB
	3WrYhLLFtowqDzb5c6oazFuaFsLHYrA=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ac-e21d-7f0000032729-7f000001d9ae-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:24 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:24 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:35 +0100
Subject: [PATCH 09/61] ntfs3: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-9-bd63b656022d@avm.de>
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
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1617; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=0D7JqCvM2HduGB7jcCjsvL2MgPxSPSMnqWoOW6gFXPg=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAX0gr7ZqouZ6B9Y6l873KDZh87VRkMxmLSVt
 AItcTzXYr2JATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAF9AAKCRA0LQZT0ays
 2/XgCACwqNRVP1ceb2sCHMTvH8vznLrrwbRdBid2VGiRwlIoIqclnUBeLwwGZ/n/hBxtkijY1s3
 NziYVgznq0k9VYxacmvzAvuKhhv5805K9y/+itK+PFXmzL3ZRzqmfWP6ng28fVSUYAufwVEc7CR
 9llIbOBq8N4aCpqTBELhb7mwymU8hNLZpMBK934i79wnmNx9OySShuCrTBL+FEQ9g/aUtfHcqTV
 4JM/tu/NHEvIwEfZrC8rjS3HwU+8fz/vbF4We+/TjORw4iEGT1m6VfBdB71QF+Wi1viRKTPIkVW
 Nxf+o86GuJolrkUsNGy4WHdCFW95aUilkAjXyF+7XIpdZkLT
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143724-80E01F2F-4A43AD77/0/0
X-purgate-type: clean
X-purgate-size: 1619
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Queue-Id: DB0CB160002
X-Rspamd-Server: rspam07
X-Stat-Signature: fjm6rb6c797yspoxgm47xoc5babfmt7x
X-Rspam-User: 
X-HE-Tag: 1773143726-72231
X-HE-Meta: U2FsdGVkX1+xsbKschcizoaH69YcHjIa7PGLrRW3wI52JZ9Gj1f98Z6Ka7cPHU8H8HHacBvjZp7QQjHpSpLZHdjEykhPvo7OA1h126rC9dw2VfdA+relntwoyY/VF5/ekdDPIUmqDs3TJNC34A9LhviHyXR0i9eN4/KCdEyNvRDHw8blvpxHR6cftV9Jx8kfYAIuOlZ/cxA+Y0o8YoeeSE7TWTD4SypGj3nP/ccYtDTo3+Hg/MC5GchtJtEGQNTkB4fqfh1l/J4hIlDxFRTV8DSexg79IGKLQxZ1CICerSztX2jlZnb/SrEAY37fYyYcvdhotsw78X5cD785mQfQS0IIg8y/UZk/5GodFOR6ioiqDdtWSjq+lWhkvnUnH1rVKs8WFfjIeTLKC8bn6ts+NJW0bIaTjLNCjRXnMTe1JMFrq2RBm/+gDGr6XFadoYY3L4hL5ebflT2xvpVN5rpxtyPfe3It5EJSaPE+TzaDsr6UnY9YXzRRspjfWu0HE1yP/pynPvpW/OzU6kZIBeUkJImC+BdP3pdqoe9pBSs2alY1/7c59L6fflCyNw62qfH7G+p5rDVYyYoVqxszy8/n+eGXVQjNYv1qpaMLvl0iUFsq4YANiJN5wgk+JgXkImOLzYOTRCzaSYgkKzIKdfGDK7XzmgfN+Tjq6+0PLStb5iENjoJAx/BHNxUUyUlths2eJXMUwtT31RBNQVlfGI44O+Q2gU0l3rrQuWne5F6zJSlOXjqZPY62p0a9LQXIuy6TrreVWRqDRKzjgc9GERb3PZ4eRa/YDy5DKipbc7XQHqbEv4eYLQurudTu7OQ12ZyM8GRifmGLiiPcCn7me4/nNr6WYpjxPXPqyaChk1eROtFS6ldHnDxK3Jb8MMXZPqC8VVrndum8ul7824/J4417v+XGaiVMLHMurPCXYDubFIp6g444olRBrUr2YTmeVJNYoR2cl4siDqMz83EqDel
 EDZuGQjp
 UmX3c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: ntfs3@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 fs/ntfs3/fsntfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index 0df2aa81d8845f21bfb571c408bd65b9e1fb8128..3ced4f95c2e95bac1fe5b334f976b8c8a15cf19d 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -237,7 +237,7 @@ int ntfs_extend_init(struct ntfs_sb_info *sbi)
 
 	/* Try to find $ObjId */
 	inode2 = dir_search_u(inode, &NAME_OBJID, NULL);
-	if (inode2 && !IS_ERR(inode2)) {
+	if (!IS_ERR_OR_NULL(inode2)) {
 		if (is_bad_inode(inode2)) {
 			iput(inode2);
 		} else {
@@ -248,21 +248,21 @@ int ntfs_extend_init(struct ntfs_sb_info *sbi)
 
 	/* Try to find $Quota */
 	inode2 = dir_search_u(inode, &NAME_QUOTA, NULL);
-	if (inode2 && !IS_ERR(inode2)) {
+	if (!IS_ERR_OR_NULL(inode2)) {
 		sbi->quota_no = inode2->i_ino;
 		iput(inode2);
 	}
 
 	/* Try to find $Reparse */
 	inode2 = dir_search_u(inode, &NAME_REPARSE, NULL);
-	if (inode2 && !IS_ERR(inode2)) {
+	if (!IS_ERR_OR_NULL(inode2)) {
 		sbi->reparse.ni = ntfs_i(inode2);
 		sbi->reparse_no = inode2->i_ino;
 	}
 
 	/* Try to find $UsnJrnl */
 	inode2 = dir_search_u(inode, &NAME_USNJRNL, NULL);
-	if (inode2 && !IS_ERR(inode2)) {
+	if (!IS_ERR_OR_NULL(inode2)) {
 		sbi->usn_jrnl_no = inode2->i_ino;
 		iput(inode2);
 	}

-- 
2.43.0


