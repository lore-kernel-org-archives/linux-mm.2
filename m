Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4469B606A899
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n3xZEqU6
Received: by kanga.kvack.org (Postfix)
	id 686846B05F2; Mon, 16 Nov 2026 06:08:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 637806B05F3; Mon, 16 Nov 2026 06:08:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5260F6B05F4; Mon, 16 Nov 2026 06:08:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 34FE56B05F2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:08:23 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C29301A090F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:08:22 +0000 (UTC)
X-FDA: 85440708444.05.F9B81EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 12AA6140010
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:08:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n3xZEqU6;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827301;
	b=Jj5OedCrCOd4ozmrnkmgNP1giNmlmbvPpzrrT+6Bv5Ep3tNVDaOklA+8IfxY91oQPOEjHY
	kpAN/waluARRzGGPCpu/glPaoQmdXnSbA3BeMgmnSF9fnXdFFf8PGJw13xJu6bibg6Es2s
	ReNOcR1a906oM5b+GqucGAU++NXHwxA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n3xZEqU6;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k+rbFcxgT2EPiG1gD5Wu4tqvE04bfZXqi/+LfbvH2H4=;
	b=X6USEKnOc8yIjrvBSgu3ysTpqMUVn133Pbk7LzejuDwszbgRNSo3TjxqqIUOZsreivzY+P
	Xa5qWtJ4m7nCsC6hPccOmyT9DFBr0izlf/bCj+oZmrY9D+CFhJQo7K5bEFpt8qAe7Ybkk1
	acpxjgWYSK+HwQk2k6ekGzr+j3pQZWU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9CCF662490;
	Mon, 16 Nov 2026 11:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503861F000C4;
	Mon, 16 Nov 2026 11:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827300;
	bh=k+rbFcxgT2EPiG1gD5Wu4tqvE04bfZXqi/+LfbvH2H4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=n3xZEqU6XY4VKj2JfBKMMo3+df0Fkah0k6jpDyketh4r2NsNIN77d6hS1qtEJaI2t
	 CM87/lPYWdrPRVJdzWbXQTrjaMCLPqKbS2oHS7ydxiWYX62Y+7YW+ZVInsRA7OF9Wi
	 3H8k+rk7nsizYUQ1bxYtjYuy3sF4k/9OqzfXYkMsXgqolmq8VCvYCIhe+ZvTAEYueE
	 yuIiuJ9M/w7KKxsE/OsZuq9HDHqmG3Ru+31sM7ogCRX/1A9ZQ89e17STph1yNpH08f
	 kQypB2FVeOeup6PKODk/DmV88y7yZvUULJAMIbHFen6I3nQUPyNmWOjwrvMaaP9uXE
	 k7xjjslMTKrbg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:51 +0100
Subject: [PATCH RFC v3 18/44] selinux: use fc_init_pseudo() for selinuxfs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-18-8cbbea1cf34f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1737; i=brauner@kernel.org;
 h=from:subject:message-id; bh=gT/HcjIZqPifb3zDIelox0P+62F/BZAADM/3OxuNQAs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9elysqXHt8eyrtRsm/Ox4eW5iyOGsraJ/fULvlk0tX
 Rv2Zmfq445SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJ/F7GyPD6SvC/04u//NTe
 mXJbP+/Jte152iKB/S/6xKaqxUXEvNVlZHh6wvByS2PQk0JtWR03yeKrl68v8BTNc14oK7MlZ5O
 WLR8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 12AA6140010
X-Stat-Signature: qocrfnzm4kdmcje69h6ifz1b7ary1ach
X-Rspam-User: 
X-HE-Tag: 1794827300-840472
X-HE-Meta: U2FsdGVkX19wJurPA1ITYO0F4JQKrTsCBNc9+YX7Z7dTHO2eFPDFFmjnt2fBx7EWvd3kb38lyaRZQ7B87DHr1UigFCo8OaLI30tYeTHvf0QCgUoiG6u7i1l2D1nyMtxSAK8h1sTdusTz0qgTgBTwP8Afk8kZPJ6a+UfXl0+btN/6I52RWEpqoWQm/dBS7znNVurAF6q48vKidUA5PhzsOxxX5mSRNE/opjagaiQ19FWVn/wEUc7XUhMjR+Rt6GxuWENPUb3qKiw2uVqhcQ6yXU9AjHdzcvIMgj4qeCJNPjHgwCYATjpaGYUvbh4jWkB65TEBUW2J3pe2mXaQiYHS7uQ2F+GuJ03Eqmrawii52B/JMHqAg7v86sPU7NwHRViXUWi7aI2r150elxVMP1UqkJ/g+uJ+dVPVoBvU/RUfBkN4XtSRf/wmoyswaLlAD8gr5BivnlRX/AM4tUcvtL/MhX3ijJoB65sXKHRlqwoKCFzh0i+ldK50qSvZJicMWkzToUfcya2uGtyhz6lF7RM8WX5IgsbIbEefmFSv2cs7RISEUNg4sx+Y8xN7Ijjl9IvzyUQc4VuSZbopspGxl/zuiWHkRDuK3F73EBpnStomABXcW57i7KzaWRn3++EkdCHmpdzbGnBhNJvuOshqZfBOX9iIO7Tk2XcBU9lhItJF1nt02MBvNGPusaayhK6S9JKweiRKZO9vHqI3XWqZE6LgvMWUacNOh89GHMeWkrOOVHJFiFlz/ZciAuTeaRDrbf5oMzWjd5OCTDuKca7UVZQOPfqGSECcWJQ2bp5Hf5Ns0csnlbsmSMs0nYcQj+aA6d314Xx4Qnu0OdZ1y27y+g4uzIHARshZhKMEthXAykXCSrn8FSQ7t+QgGtyWpQgcr8Dm61zvDPzzvX6uGloBREuwPa8x3rm4LCpqU3dIy1EhIohROyW/rgcYmD0oRO4K1MeGvCeRI1m9+058/aTrH1f
 EAm6Jm3+
 Zi+S/cN9CifJ/8peQu/e8ApBVYxqagBfjkfrxcbqZBg88Z3R3M2vV5kEFxEO1Fp5Jm8N1mGp8D7XXeGP5vr1bwfunvsw4Npwa3uMuxEfiAe+Au5QcH//FUjDL+IKlUkri/grB5GzNRr/a5yHL0RroSIzz+4ML4dp14+EQr3sKk9BK6zGI9ixOww3kpUnlVPZfrdXtSBbssaBS8+VI+S/c7lJu4/59BziTHakSnmxxxjRzn8bDAcA+qGChGmi9eyvdOHjJ02UYQJe4OE/FSwiPqphbzKTCNxKQOaclwjvmxEaVKPFnPGBmgNjJRFzcIiI08ZZLNgDZDpRtJxgFjuPRsMgQHcRHcoRs+0vl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize selinuxfs as a pseudo filesystem. This raises SB_I_PSEUDO and
SB_I_NOEXEC. selinuxfs never holds executables. SB_I_NOEXEC also
refuses PROT_EXEC mappings but the status and policy files are only
ever mapped for reading.

But selinuxfs needs device nodes. The kernel replaces file descriptors
with /sys/fs/selinux/null on exec via dentry_open() which doesn't care
about SB_I_NODEV. Android init however opens /sys/fs/selinux/null by
path as /dev/null doesn't exist yet at that point. So clear SB_I_NODEV
again in sel_fill_super().

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/selinux/selinuxfs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 310e19efff1d0..d7ae853b6d685 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -18,6 +18,7 @@
 #include <linux/vmalloc.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/hex.h>
 #include <linux/mount.h>
 #include <linux/mutex.h>
@@ -1852,6 +1853,9 @@ static int sel_fill_super(struct super_block *sb, struct fs_context *fc)
 		/* last one */ {"", NULL, 0}
 	};
 
+	/* Android init opens the null device below by path. */
+	sb->s_iflags &= ~SB_I_NODEV;
+
 	ret = selinux_fs_info_create(sb);
 	if (ret)
 		goto err;
@@ -1955,6 +1959,7 @@ static const struct fs_context_operations sel_context_ops = {
 
 static int sel_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &sel_context_ops;
 	return 0;
 }

-- 
2.53.0


