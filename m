Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76C38606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KJOopPWA
Received: by kanga.kvack.org (Postfix)
	id 9A6C16B05C6; Mon, 16 Nov 2026 04:51:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 930316B05C7; Mon, 16 Nov 2026 04:51:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 845B16B05C8; Mon, 16 Nov 2026 04:51:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 67D226B05C6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:51:09 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E4B26C0878
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:51:08 +0000 (UTC)
X-FDA: 85440513816.26.45D343F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 23379100003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:51:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KJOopPWA;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794822667;
	b=tlK25UMKRZcV/XrYH18ZaGs0e49BXmMHasvabzXm4ewiGuxrv6RlsPnRsIiN/cTQwUg9cx
	yzKc1X/d3dk0xlJY6mLTNz/VE2Huy3XARAyK4MzLwd040WEN6WuH2arlw87E6DE/7c0I29
	myCxniGPgMCbcNNoUXJPgqjNBBNi4Ec=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KJOopPWA;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794822667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WMX9pBMtAClRWJDRxKZww9HYXVLhq0s1qVF2v14nmjI=;
	b=YChWWV8shh7cIVXcB0zrjlwhvE5RqlyA4SRlA+G4g0ZA4aP6Urzv/yOjBXYS1Cua1sVXsz
	SYJQuSQ0mkXvlLv7qeept5xivBRs8pQJDBgXey74TIjh2JRVNdZ47IrAghvxOiMGaQaVmR
	SzzbUiXrJqRHiHJdEVWrces1xgpV/Nw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EF5D43C13;
	Mon, 16 Nov 2026 09:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE9E1F000C9;
	Mon, 16 Nov 2026 09:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822666;
	bh=WMX9pBMtAClRWJDRxKZww9HYXVLhq0s1qVF2v14nmjI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KJOopPWAZuqHeoKTeUi8HT9mhRMwYkIon7mX0IK2FrxH+lIz9w4mIDBtlmGpnVwRU
	 Yznll+D1uDUZyn3BGiguZs2RizD5iLGvUZBE1f/ahPSalGMk7cZl2oQ5Rqiq93s5LC
	 U9Li0n7CY5AN+wKZDFsmsA5wbGI9KypUjjh6u+/eNX8d7vTvDF0XwdYHWY4eW4yCs/
	 UUhi6mBwRxDCZV0B9xlkJgpNLsuBeCZTY3Svx6fZ/8BAuzHZL/zc06sHPQyavE6SoY
	 p+CeKKCxLUfa+oblEr0OQ46h01sLF+sff/BdqPIZamm+212su4blOkJvmv9qKQU08p
	 bamoC2xoNMOsQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 10:28:30 +0100
Subject: [PATCH 1/3] gfs2: don't BUG when remounting read-only after a
 withdraw during mount
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-fs-sb_rdonly-fixes-v1-1-95a25ce917ad@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3170; i=brauner@kernel.org;
 h=from:subject:message-id; bh=F50L2TAgntbYoNLTOVTGw9OEVAO4TN0+aJMweOBfZG8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9uvgn97Lk/4uNB7YmLgq9Hbn82lu9dd2iLLvW/WZLm
 qf1pqr3akcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEWj0Y/hcIGl+at47v4bbw
 /0JhMtYReYZPVCT+SFzwTzzHv2tl8w+GP3zb9rVaJHMW/z6+7PjCrZNr9j1LERb/ECxrfnBtvKH
 qMj4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 23379100003
X-Stat-Signature: 3z548nsxbjo933fbyre6pr5taej6y5ut
X-Rspam-User: 
X-HE-Tag: 1794822666-934580
X-HE-Meta: U2FsdGVkX1+eeRCpac1z9L7X27KonFTt6ANfG/xyZIhGQ3/InlVSac3FuRQv+8Gp1k2zGDeGWV0xe7Azz6eimKGZLN/X1Ct6ZNP/DbLuMAXHp5FM3HjWvpwX2NvbWQcHBnLfPhEaqkxq1CvEfVNXBZcP3GvSySVVSQdTQpOVeY9CGRIySu46ZRctW/YbefxvpCIAFq4iq/icLBS3z+k6GPi8Rc30MXltCnc85iC5AZvuoYP3/wKEW0C2JmBEPDaZYH+/Lz27twBT8KEQl6YlaBkjosal9bey7/qZQF/bLTErP5LkomyCDEujY4K2lmz5RY14LT1Qiyx8j3YTv8Ai+gIZPSxGgh3F5b7uq1JMVbGMN1fcZd7olpdUKhgQrzoK8GpK1gryfMWt90vUEjxcynivzp9waZ5oufN6VP+sOr2RbqKOrHKu4hf7zMuK13HonSJ0WBwf3YX4JxOz+0A3WwrZw4vIxRZIfv45Cjit1JUNNmJKRR4Vtg5i0QfKRYi+nZS/yzYl61ul1qCE8oyzJTJG/EXH21ynXISlt8SyZzC5/fX82b3ppO9fOZkOr//KSuv4c7cqHkA7isnb8uRpAz9lgeyk9ty5e4Rm3Ld2Iy7GezCZqGTn3fp0G6rAXs60MKvg+xlVAtKKbvBPlbuUDnPtg65Axsf0xLN8DLU6w2h7+Jq9WKgpzVUiKPZn5MYfwBJ7x6XHWIFs31ZMR9CzHn8IQuBFeWLaven/e4nhdB9oOVcR28qqY+v9ttJcA6hwlAl+TfL4EXyZjYaqHaC9J5I/a7+mcV4ILIMsdrt1svxRP8ji7CLCVHILVJ4qQ5T+pD+H1T4wTaJQOdySl/e2VZW/Mh4G8Stxyz+bKG8Ol4dUqyWzRB4yG0P5bmG0pJ8yOjozyVVF9BnMLaYLH2QfLvPl4Ik8NgGKwiEGA1VsABZMGHgvXzn3HIu+AZ+DIArF++5TWW3LZ68b5+1A+Zh
 36qHuzWj
 yh/VZkNa40dbiZaoASj26zRmbNfSNEimtlckkGsFdH+oOrvlOvxeElmV3NrPrbBW5cge3DVmqpX22aglY5T59V8W6mOMhOP4iz6b5VzirxLFulOowYjqoB111KOAOYP/uazUmVQZKTEzvvNcJjxfIR0RlMulEdEIGIiQmT0QBw0yr/88x3do+++0rDl8oOUDzuDQpcm8sJjwSJb6GSbOageEIt43v0FVGTrS71dWykK1NkMp1gAtyBZ1MQ61PMplNCqQXICx/OA50WhB8060TQsmlwYjwfZfd/yze
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

gfs2_withdraw() doesn't queue the withdraw work before the superblock is
born. But gfs2_fill_super() makes the journal live before that and a
withdraw can still happen until the mount is done, e.g. from the log or
quota daemons or through the withdraw file in sysfs. The withdraw is
then never processed and SDF_JOURNAL_LIVE stays set. A later remount to
read-only, sysrq u included, goes through gfs2_make_fs_ro() whose log
flushes bail out early on the withdrawn filesystem and then
gfs2_quota_cleanup() hits its BUG_ON().

So queue the withdraw work from gfs2_reconfigure() and wait for it
before going read-only. The work can't run twice so guard the queueing
with a new SDF_WITHDRAW_QUEUED bit.

Fixes: 9c4a3de6cd5b ("gfs2: Asynchronous withdraw")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/gfs2/incore.h     | 1 +
 fs/gfs2/ops_fstype.c | 5 +++++
 fs/gfs2/util.c       | 9 ++++++++-
 fs/gfs2/util.h       | 1 +
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 49cc232942a29..151458e90480b 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -605,6 +605,7 @@ enum {
 	SDF_KILL		= 15,
 	SDF_EVICTING		= 16,
 	SDF_FROZEN		= 17,
+	SDF_WITHDRAW_QUEUED	= 18,
 };
 
 #define GFS2_FSNAME_LEN		256
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 6ec47376aecf2..3bd5702535dfe 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1590,6 +1590,11 @@ static int gfs2_reconfigure(struct fs_context *fc)
 
 	if ((sb->s_flags ^ fc->sb_flags) & SB_RDONLY) {
 		if (fc->sb_flags & SB_RDONLY) {
+			/* gfs2_withdraw() doesn't queue the work during mount. */
+			if (gfs2_withdrawn(sdp)) {
+				gfs2_queue_withdraw(sdp);
+				flush_work(&sdp->sd_withdraw_work);
+			}
 			gfs2_make_fs_ro(sdp);
 		} else {
 			error = gfs2_make_fs_rw(sdp);
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 529c3ec37a18a..5558af374994a 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -238,6 +238,13 @@ void gfs2_withdraw_func(struct work_struct *work)
 	fs_err(sdp, "file system withdrawn\n");
 }
 
+/* The withdraw work must only run once. */
+void gfs2_queue_withdraw(struct gfs2_sbd *sdp)
+{
+	if (!test_and_set_bit(SDF_WITHDRAW_QUEUED, &sdp->sd_flags))
+		schedule_work(&sdp->sd_withdraw_work);
+}
+
 void gfs2_withdraw(struct gfs2_sbd *sdp)
 {
 	if (sdp->sd_args.ar_errors == GFS2_ERRORS_WITHDRAW ||
@@ -253,7 +260,7 @@ void gfs2_withdraw(struct gfs2_sbd *sdp)
 		if (!(sdp->sd_vfs->s_flags & SB_BORN))
 			return;
 		fs_err(sdp, "about to withdraw this file system\n");
-		schedule_work(&sdp->sd_withdraw_work);
+		gfs2_queue_withdraw(sdp);
 		return;
 	}
 
diff --git a/fs/gfs2/util.h b/fs/gfs2/util.h
index ffcc47d6b0b4b..78690fe76cfeb 100644
--- a/fs/gfs2/util.h
+++ b/fs/gfs2/util.h
@@ -195,5 +195,6 @@ void gfs2_lm(struct gfs2_sbd *sdp, const char *fmt, ...);
 
 void gfs2_withdraw_func(struct work_struct *work);
 void gfs2_withdraw(struct gfs2_sbd *sdp);
+void gfs2_queue_withdraw(struct gfs2_sbd *sdp);
 
 #endif /* __UTIL_DOT_H__ */

-- 
2.53.0


