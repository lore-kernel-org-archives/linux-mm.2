Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB15EEB1052
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:55:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E3D16B0092; Tue, 10 Mar 2026 07:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A47D6B0093; Tue, 10 Mar 2026 07:55:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFBCF6B009E; Tue, 10 Mar 2026 07:55:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A41DB6B0099
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 70833C02E3
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:29 +0000 (UTC)
X-FDA: 84529998378.08.F86E384
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	by imf18.hostedemail.com (Postfix) with ESMTP id 352D51C0014
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=rc8Hq89F;
	spf=pass (imf18.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JuC1mSy0wWf/HA7nrfH8vcHZny+hdINtD1gY837dpg0=;
	b=hQxG3E7gja4jBUN05yRK0x50+AZdqpDLt2WRltGhdK1tDUdC9eOfryZPsuieBbpoKItfpZ
	mnDn8G3+gdQI7V6BCNuie03fb7dDTCR83nZ98QgKqPQaNjq9cpVAZlDnZZNkPosf+9ylXc
	TdxVx/dijSF9Ma+QAejDrO5HwL1NzkU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=rc8Hq89F;
	spf=pass (imf18.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143727; a=rsa-sha256;
	cv=none;
	b=phE0Wvp+bpI8pMtmKsdb4FvTshT5/kwxOCZGaWsTqkuqFvFz1UAyKtNrrMiJHg6FWLqhAe
	aEFKu097702PKQ/aceqdXCYhSK6pUolzxZF8NUIjU70fgSO+sG24UbSat3BQk0w8R3bk+w
	3UUPMZ2lLz4M/OW3pVMcUnEkIlgCKno=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143723; bh=DGbCaZBy1FpfvXwgzKpSCwa07WA8CY/Qb4IJHso0Te4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=rc8Hq89Fb5fz3t9XGAV9DEbHVf5dfp7yp00Gf9MYpCbFElXUliv8K0TJ88EegoebM
	 lMHRZL83a9AqjbASsPk3qVgNFrp4VheSaUprtXI9vxtui90WS9FjZFrbxSMEBA+AFT
	 xc3KncdB3VgIsSI2EjPb3pbBX8z4jE0V+gxrfv0k=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ab-2367-7f0000032729-7f0000019cc4-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:23 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:23 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:28 +0100
Subject: [PATCH 02/61] btrfs: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-2-bd63b656022d@avm.de>
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
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=3017; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=DGbCaZBy1FpfvXwgzKpSCwa07WA8CY/Qb4IJHso0Te4=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAXVP8rQiO4oClcWoVpEQy4tTT6UufgJ8AjmW
 meFZ085mAaJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAF1QAKCRA0LQZT0ays
 26ZTCACM3Mi9LEMEAWgAR6v8SxUVk3um+/46scAm+wvRfrMWEFwlnMkQBbCGIGZUNkKB1Pk7uvR
 q9d3fZ689cKMySmmjPCYjQ/WgGDVLcywEn6In35Jwnklhlj4dYJLSL6WxXsza+vlAV93TQDvaTs
 OFlLEsZ2j+XY+f2mrUOcVwOk+301k/goYUacbLoVSw0YZnroo7kAB2acRVGhOGAOOiJoiVAdHNU
 Yf8QURa2qrPqHMwGd4SQRV57t+Grw+zEItF3L0eYw7mf41TaJcLeP7Vo+0nFp2D9QdrMND4nUec
 WhX0remRDcBywCJPWh7SmqRiZyiXDaIfp9JkUkUr5yx6Wacb
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143723-80C85E1F-0AA4A985/0/0
X-purgate-type: clean
X-purgate-size: 3019
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Queue-Id: 352D51C0014
X-Rspamd-Server: rspam07
X-Stat-Signature: cq3z5kmwapfgqk3weuthyauiomacbeuj
X-Rspam-User: 
X-HE-Tag: 1773143726-254851
X-HE-Meta: U2FsdGVkX18H5YlHbFh8+7RWDIIDQTByzrqfxuqcSY3BSZCz/CiBU9EyvtQi930swlsuSvWXQND1saMaLhJ2wgOi9qaS7Vx9389jWB2quOFRbHAzmG1a7nfz1BUiZzXiQy8ZJ34efdPrd9Odh5Y1l/CC9uDJkjvxcxBaCzcDTMnWVQplfGeiZNOx33Zbzi6zMB516L3otMyjK8SK7fFxwsYT1J3vQ52fG3tjwgFzqmXD84GjlQc3pTTZvyHsV2+/EPsYg3cxPjxHDSG0+MU80pXIXgtKpUsjjvqTJ9Romj8fr6EyjK3maUE0GuEpbXFfZ0RadHtlgNbtPoJzdKop1mL/8swQ5TU1f5PCZWZrBp+3cKMdZgnl3g2dje7aY6Ea1nPriWpnnJIdusCUdB2NYWsAbTQWXECVga4Ex4s1NfpNWEMm7tGthRHa1HrnWR8Tju87aaCXQWZc7WZKTkS0TrqpuScFdlKtWfAveYwRx6LhMfFKIjVv9jTB/72yFCEUCAwdxmgnubN4bTUIimTWcXJIEpN3cum1s2MrTxM6/oCLPw7xDA3u8ZkopwIjKb7itQeLOOaExGzt3ape7PvlPYOqAFZiC/z/pCDPeuXTrzaKHc20M6k58ZE7kJT8EC+yfoFz5EwGljHK0SAb2juxRNePICp6Rkc4za/K6GS7naZCtD4IGydCfR+GUeEBqTm/hRuDR9leRY2mrWbNrn2woZzUUqCLCi7Y0VKUNYr+302Uyp98Gb9wLBVp8ybUhb0bA1Vgs+UcpDVhOjCAy0AQHfwU5qforlmAi7ucuR1CyniP/BEXL+jLQL73KYxJkRBQ7gZQShd61SqEeF0VqW0ZrtWRQt7+84d+Ml+vmGSrPxeRN9fROK6duFY4l584SLwdKuibBlr6bf6LUUjbDfYJL5eZTD4KDUw6acvHKmWl2Bggn+MYUEjWN3oBiaHPfclnxFOsmlkiAXz2QgbqAD/
 E9JCx7xb
 D00m83VmKb8xnQHNdHzuu9vq++FLEbNTgDGlkd1BafL9T++ldZjdeMaPYqK48Z93VbabaBCBkVltprdhKG9p2QEs/l4A6yHrGxhWM2kTsB928aBmNHssFVYi4ZPmtK7J4uW7hmMfofHvS1bKmFRGTKoXZhjZW7qwJJFWZNhZt5AqRQt8GbTj9jsnvz3gxjGKKtAN9avQowv2rYItdn6Ah4rktFHnVi+pXcMpX8SD/vA7xW9Mu3vREUadAJHBxTowFCSckMPlppGOYIiEOzr7FbyAx3qDmhOqYrq/UH/udwGBzx+8umEorqKXLSkOGJzECsOtfCrem68tj3rn2lugyZ6lA0dVumaiRc9z1aZ5ppOpakmxs26iRpX6VSJ0GoDCqeISxt7ueP8n339yNK1cPiIE2247AxamojDZPx7sHvHcbVOy5eQsKqI2CaLldnAuxcWhGyzDn3v25RvilgtkQoeC3pQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

IS_ERR_OR_NULL() already uses likely(!ptr) internally. checkpatch does
not like nesting it:
> WARNING: nested (un)?likely() calls, IS_ERR_OR_NULL already uses
> unlikely() internally
Remove the explicit use of likely().

Change generated with coccinelle.

To: Chris Mason <clm@fb.com>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 fs/btrfs/inode.c       | 2 +-
 fs/btrfs/transaction.c | 2 +-
 fs/btrfs/tree-log.c    | 2 +-
 fs/btrfs/uuid-tree.c   | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a11fcc9e9f502c559148cf33679014fb83b0d3b0..7c26a0bf56bf7309e2ce8256854d760b2d64b16a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4683,7 +4683,7 @@ static noinline int may_destroy_subvol(struct btrfs_root *root)
 	dir_id = btrfs_super_root_dir(fs_info->super_copy);
 	di = btrfs_lookup_dir_item(NULL, fs_info->tree_root, path,
 				   dir_id, &name, 0);
-	if (di && !IS_ERR(di)) {
+	if (!IS_ERR_OR_NULL(di)) {
 		btrfs_dir_item_key_to_cpu(path->nodes[0], di, &key);
 		if (key.objectid == btrfs_root_id(root)) {
 			ret = -EPERM;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 7ef8c9b7dfc17a5133b6d2dc134e288975ed98d1..40b83037725033d3178dc3fc2c1e347ad2c597f7 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1737,7 +1737,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	dir_item = btrfs_lookup_dir_item(NULL, parent_root, path,
 					 btrfs_ino(parent_inode),
 					 &fname.disk_name, 0);
-	if (unlikely(dir_item != NULL && !IS_ERR(dir_item))) {
+	if (!IS_ERR_OR_NULL(dir_item)) {
 		pending->error = -EEXIST;
 		goto dir_item_existed;
 	} else if (IS_ERR(dir_item)) {
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 780a06d592409b05fb42dc8079b019d23fe0cdfa..2e07ae393cf9d16f562047dd4cbfd7b4b9f2952e 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5750,7 +5750,7 @@ static int btrfs_check_ref_name_override(struct extent_buffer *eb,
 		name_str.len = this_name_len;
 		di = btrfs_lookup_dir_item(NULL, inode->root, search_path,
 				parent, &name_str, 0);
-		if (di && !IS_ERR(di)) {
+		if (!IS_ERR_OR_NULL(di)) {
 			struct btrfs_key di_key;
 
 			btrfs_dir_item_key_to_cpu(search_path->nodes[0],
diff --git a/fs/btrfs/uuid-tree.c b/fs/btrfs/uuid-tree.c
index f24c14b9bb2fd7420b06263a5a0c4b889a859bc6..c497b287f3418933e532903b326b969416ae22cb 100644
--- a/fs/btrfs/uuid-tree.c
+++ b/fs/btrfs/uuid-tree.c
@@ -478,7 +478,7 @@ int btrfs_uuid_scan_kthread(void *data)
 
 out:
 	btrfs_free_path(path);
-	if (trans && !IS_ERR(trans))
+	if (!IS_ERR_OR_NULL(trans))
 		btrfs_end_transaction(trans);
 	if (ret)
 		btrfs_warn(fs_info, "btrfs_uuid_scan_kthread failed %d", ret);

-- 
2.43.0


