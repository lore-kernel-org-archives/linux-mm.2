Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62C93C982C3
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:37:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 586846B00D8; Tue, 15 Sep 2026 07:37:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55E8A6B00D9; Tue, 15 Sep 2026 07:37:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 475006B00DA; Tue, 15 Sep 2026 07:37:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C2086B00D8
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:37:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BECA31603AC
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:37:51 +0000 (UTC)
X-FDA: 85215797142.20.73BDAA3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0CA8D12000E
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:37:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nIsDG6ms;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GNDTkXQI7mGdcVaT7SDrw9M8MIqod2XUSoHG2zw3J2w=;
	b=kqagS0eaPg+C331wzrAF9Fao8FqtCv3E4ChIcsLvQylXKQI8qtdnlH0+grrbOkuu0/j+Fe
	kpeAXYd6ktNGP878r7ayesJlwDIS3i/S0PIq69NxwHUrIITMJjox5kv1gx30mOEC0DhpQg
	2jbXIUbAtG1wuL6k09HsTqQSEjnO3m4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472270;
	b=flK20E1BYvIQuDiDr90xodo/5upJ3Ak0zGdB4xKf1pzdgQYE6If8eqfavIbkSet1pEdzeS
	9O84ol5pc16Qzz1a+ecwjL7n1Cf3rTE4FaGUSJe1ZlCSRVHvZG4qD56ZoCKWwBv3diRg1p
	1ChLVYdV5K1bCLa0KN1SZKi4wfO1678=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nIsDG6ms;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D1E3602C4;
	Tue, 15 Sep 2026 11:37:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE2E1F00898;
	Tue, 15 Sep 2026 11:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472269;
	bh=GNDTkXQI7mGdcVaT7SDrw9M8MIqod2XUSoHG2zw3J2w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nIsDG6msZxm9ifdIIaNBb4DSvDwZjxBexDpBy0k5+c0EEQRfRNHCnvgHTIY4Q0gZ4
	 5Y4GAqy+82PffLbcvJlnpDdJKam2a1RZ/lmTtWzv5yc2Qa3CGs1EC2lgotUwdrCtPN
	 R+e8tN55H2q/lzjefH/7MqxCwUMd/aRzXVOqaq/JIPnIQz/fh1lk4mDieRcetKm0Vz
	 We6QD5SZZpeWs1skjtjC95uTXtri2f8p0027MOwC2PJ2AtBz1eyxEa8oFwDdJ/4IbQ
	 1oi4l5RBwZ4QhEmCd9i4/Ab6QCou55Lo2D/xSrTRR5npBOhYvLPf8mp8Z+7okOyPo6
	 hMky5BV0f8Xcg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:36 +0200
Subject: [PATCH RFC POC 50/50] Drivers: hv: mshv: stop putting descriptors
 back on failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-50-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, 
 Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Oleg Nesterov <oleg@redhat.com>, linux-alpha@vger.kernel.org, 
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-um@lists.infradead.org, Jens Axboe <axboe@kernel.dk>, 
 io-uring@vger.kernel.org, netdev@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-gpio@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 bpf@vger.kernel.org, David Airlie <airlied@redhat.com>, 
 virtualization@lists.linux.dev, kvm@vger.kernel.org, 
 kexec@lists.infradead.org, linux-hyperv@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=3018; i=brauner@kernel.org;
 h=from:subject:message-id; bh=SzeXPqGJtllJZEGwqHGcwxzZWYTunmeJfrbckytXGkI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1KmPkjZIUeG9e+1R07epv8QvrSgMsrt/1D2tpUnF+
 Ty/n9jUjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIlo3mb4Hx4+8+W/E5svyCgt
 bpvwatmUgujlCXflfc2DLyvdmH/HYCPDH44Jiw0OZie7VZtm8ZzaXLrdzmx2uNpNg59n94iEL7/
 iyAIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0CA8D12000E
X-Stat-Signature: w8oui9njdrg4nhd7b6sfxy6mm5j5ex17
X-Rspam-User: 
X-HE-Tag: 1789472269-361375
X-HE-Meta: U2FsdGVkX19qRJTm2354TY8+jLy0YDPypyN1YjPhqHelEbA3WBEhSyHbt5YS+I1gyD6tnLJ5jk6qhrjT1S5GLTvI05ZZSGEoj4w2Xu3ySAipm9YfIK7bWAdZqCZdEi7Cyow9oyMD5SFbD9pJsPXq8SoYe+mBU6LMAtqSgl3mdMbX3q5VST4EBHKWjfVzjDDpl96W+/taOHfBGdcDpa0E4MZdm/zjXLI7O/UbDJ9Ze9C0w+desL+BZayx9VN495wZnr3IOPTczxwW+B/Oi7p+Y0OG9HCHsCzYCfBegy2e77aYK6b/Og4HjQo7pyAn36BOTkz0mTPvARQg0J2lPcltPo3GhONksfV9L0DROUgu/bvF4MFkKFasc+ipj4ok1ehSfYQeJMF/Dm5SBGOYnx/js1V4J+/NvWshwOIHZxyMINK0NO0sZzAtXHA/nSbuM5Y9zcgZbkPmcc0foInHqE+jjL4sebmifBsVrp+gJbFMPeQFL/6uaqwuTDa/LTYOe0HybJZE9a6AHXj2kc4GKk2/rXtbNMqiDP2YtA65EPTuinxet03X5g8rAOdd14ytYIdXtRpkfZ1LsVnorsl0WlIIt9JowQg/QQe46zmFaxqrQb+IckdaeqI4GtD7x4VQQ5KGWOiNVxKZjgigWOMsKxy1O6rCuwk3zix3w0Q4hqBFfNACzEZkVsM3ConNm7s30qRg0YM6gBdnRFE+swcSbK632A53wej3d+fR/AS6U34gmD7+FO+FQ71CSSWTeUO/nDMFp+xj1o2jP3c2Ta36JcZGjS1n8QoMmU1mMg1IEnP1SMG4Fz5mSmYc4I+vWfakJEDJX6/vXUoLEa4cC/75UclBkmHW4XunsOqYyo2TA4mG8zYOdW3JKeIYMuHiZGcYQbJSXq+m/EcxlP2JdKrspq6KNUdHhTCPBkiKkQ6UoCpqxfLZ2Po4CUlSYoiB1TrXwFt776k1ZEIumuzNunWgAUH
 0c7hsKsx
 aqz0tBLnwxwhXSi9WpwxU7kYlUTPY6fD8tkWPR9MR0QmWYflBwwSA/LDo0wlcSlQtXdPOAETtofHDLyQyJdwjY1ftCuaCQ01c94tEow8XVaN8DmJoegz2SqmquuOHFrxwYxe5II4PfoUKpXBS8roG/4uPH8PqDsfTVIUQ8DXMeRCDCdLxnOLsvDuRjvtVBq0QHzPlkd1s6cLQzhtEkY7n6T93SDChEodJ6DnWQvtHDhs2w43uywNR6jfXjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rely on the fd exit path machinery.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/hv/mshv_root_main.c | 27 +++++++--------------------
 drivers/hv/mshv_vtl_main.c  | 20 +++++---------------
 2 files changed, 12 insertions(+), 35 deletions(-)

diff --git a/drivers/hv/mshv_root_main.c b/drivers/hv/mshv_root_main.c
index cc2cfce2aefd..c95cee0bae85 100644
--- a/drivers/hv/mshv_root_main.c
+++ b/drivers/hv/mshv_root_main.c
@@ -1072,8 +1072,6 @@ mshv_partition_ioctl_create_vp(struct mshv_partition *partition,
 	struct mshv_vp *vp;
 	struct page *intercept_msg_page, *register_page, *ghcb_page;
 	struct hv_stats_page *stats_pages[2];
-	struct file *file;
-	int fd;
 	long ret;
 
 	if (copy_from_user(&args, arg, sizeof(args)))
@@ -1148,19 +1146,14 @@ mshv_partition_ioctl_create_vp(struct mshv_partition *partition,
 	if (ret)
 		goto put_partition;
 
-	fd = get_unused_fd_flags(O_RDWR | O_CLOEXEC);
-	if (fd < 0) {
-		ret = fd;
+	FD_PREPARE(fdf, O_RDWR | O_CLOEXEC,
+		   anon_inode_getfile("mshv_vp", &mshv_vp_fops, vp,
+				      O_RDWR | O_CLOEXEC));
+	if (IS_ERR(fdf)) {
+		ret = PTR_ERR(fdf);
 		goto remove_debugfs_vp;
 	}
 
-	file = anon_inode_getfile("mshv_vp", &mshv_vp_fops, vp,
-				  O_RDWR | O_CLOEXEC);
-	if (IS_ERR(file)) {
-		ret = PTR_ERR(file);
-		goto put_unused_vp_fd;
-	}
-
 	/* already exclusive with the partition mutex for all ioctls */
 	partition->pt_vp_count++;
 	/*
@@ -1171,17 +1164,11 @@ mshv_partition_ioctl_create_vp(struct mshv_partition *partition,
 	 */
 	smp_store_release(&partition->pt_vp_array[args.vp_index], vp);
 
-	/*
-	 * fd_install() is the userspace-visibility commit point.  Must be the
-	 * last operation that can fail or be observed.
-	 */
-	fd_install(fd, file);
-	ret = fd;
+	/* The syscall exit installs the file; nothing after this can fail. */
+	ret = fd_prepare_fd(fdf);
 
 	goto out;
 
-put_unused_vp_fd:
-	put_unused_fd(fd);
 remove_debugfs_vp:
 	mshv_debugfs_vp_remove(vp);
 put_partition:
diff --git a/drivers/hv/mshv_vtl_main.c b/drivers/hv/mshv_vtl_main.c
index 6e3c11c68171..f14203d76da1 100644
--- a/drivers/hv/mshv_vtl_main.c
+++ b/drivers/hv/mshv_vtl_main.c
@@ -114,29 +114,19 @@ static long
 mshv_ioctl_create_vtl(void __user *user_arg, struct device *module_dev)
 {
 	struct mshv_vtl *vtl;
-	struct file *file;
-	int fd;
 
 	vtl = kzalloc_obj(*vtl);
 	if (!vtl)
 		return -ENOMEM;
 
-	fd = get_unused_fd_flags(O_CLOEXEC);
-	if (fd < 0) {
-		kfree(vtl);
-		return fd;
-	}
-	file = anon_inode_getfile("mshv_vtl", &mshv_vtl_fops,
-				  vtl, O_RDWR);
-	if (IS_ERR(file)) {
-		put_unused_fd(fd);
+	FD_PREPARE(fdf, O_CLOEXEC,
+		   anon_inode_getfile("mshv_vtl", &mshv_vtl_fops, vtl, O_RDWR));
+	if (IS_ERR(fdf)) {
 		kfree(vtl);
-		return PTR_ERR(file);
+		return PTR_ERR(fdf);
 	}
 	vtl->module_dev = module_dev;
-	fd_install(fd, file);
-
-	return fd;
+	return fd_prepare_fd(fdf);
 }
 
 static long

-- 
2.53.0


