Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C57E5606D7BB
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HIBGA33D
Received: by kanga.kvack.org (Postfix)
	id D60436B05D8; Mon, 16 Nov 2026 06:06:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D38826B05D9; Mon, 16 Nov 2026 06:06:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C759C6B05DA; Mon, 16 Nov 2026 06:06:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A98926B05D8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:06:46 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9A7DFC0952
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:06:45 +0000 (UTC)
X-FDA: 85440704370.08.ECB8FE3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id B545A40002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:06:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HIBGA33D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WxYlM2WrInCj+tZCjOFP8L/ZbkLteejSwwMuIi+k/j0=;
	b=5ZYW0B/1VJ3AzhjtqM5Vg2gF+gdK3Rtw1E5K2yeA2nsalNclmZlbp+WbBAdrEqhY3DXeBU
	oJU7sRx9HwjNzlxO9AKRkw+khzsznxYIdAN3CpR4JV+X0lw7jz1WIreLsPySBkNtRUw1la
	SkpCSlRL2fOK0cFHn+6E4w0/1Jrxr0Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HIBGA33D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827203;
	b=HjnVlWZtzubgl5uZCiYasIi8YRrjW9DobwHPV7l2ts/myLmmsXu8HDTQ05eMDWZZXwPuwg
	CtgM4zltRd8NsPURv2dud0EAZM3+2QivuBaPqCV6odZy2SgHuncy83CECRHHPRdETCHAfA
	6aPKSDs65t0cqhLI8VlrnV5Kg76X0To=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1704740F24;
	Mon, 16 Nov 2026 11:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB091F000C6;
	Mon, 16 Nov 2026 11:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827203;
	bh=WxYlM2WrInCj+tZCjOFP8L/ZbkLteejSwwMuIi+k/j0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HIBGA33DZKK7wLY4NbU1UsuWaQJnkbG0rRCtIKIXDHpO9jDtPSdQhfLQbTHhTKx8X
	 XuX7PnB2kkTJoZriLdQv9iPo7IxfuI5i/hHeh3OnCCY6MHhW/GZMXU7CCCB4IZCpzc
	 q0+u+L41qd9ZOl8lQb+cKh9xYAgLOA471R2AzufTEMSg/dCw2bOSv3Q1XSWzhqjCfs
	 sNXo2m2S8siDOJUurEhdoM/D1hZ2q/5dqT6j4xt/aNAgYhltavLFwce+QkO/Jev9GZ
	 5lfAlzmTs8+9PTfmF1jNifCNVQu/HrVcBF6evkHDFY6UOLA4bPT4TCpN89UIe3t5YZ
	 YxVy/TwqEWNsQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:38 +0100
Subject: [PATCH RFC v3 05/44] kernfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-5-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-mm@kvack.org, bpf@vger.kernel.org, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, 
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, 
 linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Alexander Mikhalitsyn <alex@amutable.com>, 
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1543; i=brauner@kernel.org;
 h=from:subject:message-id; bh=b1WdZIg+OtBecm5NRM4f/C4ttSoZ3Tz9qDg/k3dTDkg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9epzSXe5vEPNi3pbqvoQu08sCwWuePl/0KVmlUibZU
 +J2n/3+jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIn8N2RkeKF7zH9azOs1V6c4
 PRXbZLyiwWHxr3+qnE8Wt7vs/HMxK46RYZuD26pXQUvnGJZWdkpW7OSs237Rws6gNFNVvjjiTew
 fbgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B545A40002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: adz3egq9f9yuxj717acy6o63smuoiwdu
X-HE-Tag: 1794827203-648562
X-HE-Meta: U2FsdGVkX1+Ubsiat/mv8nyGY5vIsTfOqGdbW6QX73o0JPubr9Lyn7e+RzDZJgJn6EOJLPKQN2yMggTsePzdL2OhWFv8FilEp2pIYpaS1+VRDHP6nLsQkZKgpnkLTXuGaPJ7eD9B6BcwfHLHJ+EUIkw8dLpU0VajsdQB2XG01H8byOUvEFIBAYu3QFGTDJ2wa65GwNUzmWz9NCzFrzYFm2vCxPnRmD9a8PSr3VOEIMzXINHJaShLqOzl38rZMK41eMsxhNkERYCPEpUgY2FwrbydXsM/amfxU2MApO38tLjMiKhQoPlQlk/RRWTq0AbLi4rPNRwVWFYwoKjEgvZHMmVRc9vaiREi/sKfvi6wdwG+9cCEfn3aQvpgt4qgQjXzemmh063CSGNylPzAqiAsjn1DOAvKRAj4WCeu3iLgN0Moyc0gmysVEmwrnRSh/LBn5J59HbWRrnmQpdroz/nRwZLZYmcKxyA8JLN8erZ4m/63xpNLOFzRjeNjdUx9c5Rjt/LlIv6MssBGL+Vx2fn2tMf5U6DjPfDhVUHxyKR3eAmCceLkBonzxtdIcxW61Jd/GfuQVJTDHRjNybHQYvTsf4c7fOVRS6+tsbQtzDrdnJVTCRgr1i/j9LLd94w3Mj3QE+JnQ09SPNsIsYWEQ7YoEK26kDcPGEF0IwxAcQDJN2bcFC5fhv9ZrDnxB3b7+C2WSxKnFD/Ij6lYFYVAh2c4vr6+HH9IMRtti7uaNwVsad/TlDIrIDmtwAt6fB/Z4F4auiol9pXxRwFWj5C1fFHRxYbsI+/5UyUFgA1rb4Vcwm0PTsxzfrClD4YT4cUGwRcUpwrNca0Auoku197O0ZGC+bXTAiayVRQ3oX07aN/ur2X8EkSEIf4D/tPX3Be35/68iazniCVVGgWoqrilli1BFGBgRrKbiLyPKUcT50vIAWFxLrtfZTzfuOo+eIO0eLXagCzqOT0MIu2pP7BUjpM
 45dAxB8Q
 8pdaZoKPj9diBOZUYGEHJOiDjBILFGezEKtvxN80Q4C75Sw93w2jaarIgh2Fe8xrheZeGn0gMvrn7TSR+ao1s+JVln9KxJVT7Xl1jRKeXEGeq9Parm7HSXX5C/YTzV0CfOMTjuk2SugNOU7ckvogS58XUUhxFHPTjdra+5cp5zPBk2YFxv1vI7RzxBYugL48yRosr1QYVIisvg42Xs9rVyvOMw5ReDVLmsIH6p5CGu2hvbP664/SqupATXSwgN0YNJvd3U65XuyZPwzaUNgDealKr/0x6fHWkKl2Ze9MtTMi8pTlgqFysM2sh2KPCW0NjAXlgf7+beAu+DR1QtvBW/6F7E6PD8erIfH+I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize all kernfs based filesystems as pseudo filesystems in
kernfs_get_tree() instead of raising SB_I_NOEXEC and SB_I_NODEV by hand
in kernfs_fill_super(). This adds SB_I_PSEUDO for sysfs, cgroupfs and
resctrl.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/kernfs/mount.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index a0be784bfb064..6b60d212b003d 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/pseudo_fs.h>
 #include <linux/mount.h>
 #include <linux/init.h>
 #include <linux/magic.h>
@@ -298,8 +299,6 @@ static int kernfs_fill_super(struct super_block *sb, struct kernfs_fs_context *k
 	struct dentry *root;
 
 	info->sb = sb;
-	/* Userspace would break if executables or devices appear on sysfs */
-	sb->s_iflags |= SB_I_NOEXEC | SB_I_NODEV;
 	sb->s_blocksize = PAGE_SIZE;
 	sb->s_blocksize_bits = PAGE_SHIFT;
 	sb->s_magic = kfc->magic;
@@ -388,6 +387,7 @@ int kernfs_get_tree(struct fs_context *fc)
 	info->ns = kfc->ns_tag;
 	INIT_LIST_HEAD(&info->node);
 
+	fc_init_pseudo(fc);
 	fc->s_fs_info = info;
 	sb = sget_fc(fc, kernfs_test_super, kernfs_set_super);
 	if (IS_ERR(sb))

-- 
2.53.0


