Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D8F1606FB23
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ISqS1X59
Received: by kanga.kvack.org (Postfix)
	id 14D2F6B05CA; Sat, 14 Nov 2026 08:07:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D74B6B05CB; Sat, 14 Nov 2026 08:07:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F07226B05CC; Sat, 14 Nov 2026 08:07:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD07A6B05CA
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:07:39 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3BD451A03C9
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:07:39 +0000 (UTC)
X-FDA: 85433751438.16.73308E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7733EC0009
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:07:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ISqS1X59;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=++ggQwwawp+5fpIFwG3B4KdeRqD55EsEpWBb7WM/wus=;
	b=SahXfHWqf6dnGZaZtggiVb1fzELtKXLo6RZDFFCv7MlojbHua2ZqTWXm5ctlq4GdQf3m99
	SZON+9DyZlsMMxoDmpa7icLyOeqPaaYWHCwmVmEDpJCfuSDhfXZlWi3Sy2wiqvONbQHXsZ
	oh7Zxwk8EbN0j9qVWc5NHKlIUmvDvq0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ISqS1X59;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661657;
	b=ZNutSsNinvTYQvqNsl6fCk6M7PEl8ebTOnDrbcU+PMkQf6gBWrBpBOtlo9FkoPHnKejBh4
	E7wXzQnTg3cbDJbcm4sYiYlysTiESuimfDOUQgAM/u7fB8BzbHIbAExX3o13RhNGrUumFi
	04Cv+CNRW5EXxOsBwr1Bq5Q3NKyGQ9o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C2CCE464D4;
	Sat, 14 Nov 2026 13:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6731F000C7;
	Sat, 14 Nov 2026 13:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661656;
	bh=++ggQwwawp+5fpIFwG3B4KdeRqD55EsEpWBb7WM/wus=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ISqS1X59OqSfExtxsOiSjr1wpv0Z7FsnoV/unXwmI2iC0oAeE1CZBnUm2rpLbQChY
	 UlVbIerFORk8Me/5GU683vDPV9tRnmC60uPE2FjWgnWj28UM6HQcw92GM6dJnxpsla
	 EP0uXvdgCUnVRc67H/T1UGcUcSsgA+crZYnm8xvt2wJzIa3kLO4Fm6nJf9PjOQCsNv
	 FSz8gs4T9BgUNPq3f8HpnSRTAiJYTu/lTuBvbPvos8+G1tK0oFpzC1YL2EUS2ey9zn
	 SEWINxYSWGGXxTx69tavZlufHiP8xSylFop7fahaOM11VSh8OruW5Bhgixy7FFv+V+
	 ODZZedD26ol2g==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:58 +0100
Subject: [PATCH RFC v2 17/42] securityfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-17-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
In-Reply-To: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
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
 Alexander Mikhalitsyn <alex@amutable.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1094; i=brauner@kernel.org;
 h=from:subject:message-id; bh=FF9e/eJ7LhW9MgInOaUNZ5e/JVsIh5RgAJXPuTh0Dg8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iKnMnrLSQPUw2yXBp68+bj4dIDU/cEGPtJHXzrJlj
 K0vlnZd7ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhIwjxGhufubMVtdsLcrI83
 V3z50Gdhay43R1RMqFp4dcnRaZXmXYwMLWe+THc1O5jMduZaU5272ykVxUsi197p3xOIjl0gESb
 NCAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7733EC0009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 54bdd5mxh7pygwy8ubg9cob75zedjhyn
X-HE-Tag: 1794661657-372218
X-HE-Meta: U2FsdGVkX1/s3l77ZJgZw+/X+c6oHLzoly+xODBFQ7xmG6bhBK3hbcGt06rCRongxZc/dO+byi++zQoxgY6794GhPSRYKTRvwzeXBil45OQqycohLdt5orD12KuEogg1Whjaw3EQjKtd1M2CFEOBNFETfws6KTIS+ZxCRH23nDvokFRLS/c//bEfP0aJQScDsX2B/gRlNvrn5TylgQ7F3oj/3S3ExLUc9wPQ1kk6zqUWrZ3qoiodZYPwSdwtXaU4uSUM576OOEXEUwZg70DUeSVgrhNrPY89XCl8XrlfhDtwTq6dGkjpOYVqdWt9cRTfqOk3sZfzL7rJ1jkDSx8WnqZs5XNiiRs2kvFwkwUCTVepg+RQLiAbF4H3JGu/VwfpE3aWTQqfvEoJrek3pwtMJNsQngm7EIFDrVB404oZa5AQqznhmQumyOSb6qlg4UPuHQhBIdcs8LIekeDSVPqtvik0hAOaFnp11qtX9TsWdY03pyPPKGgpa01jVPGnXaby2pEQR05srxbyd2ujUzrUcEUcYHZOEUPDnQO3wKcs7V8GmsilPpTWAxow47Q83BNlG47A7/KGQK3/58BVb0rKKiaNyANb3CU3eeITWu0CIA95jJ4vTZVOMRQTZNrXY0OWoUR46nOwHZ95qK6vxq3+nB4zJF1yr76y0+lw4CCzg4iwdB6L0qTi/0ResLQVmVh6DAPLMk6U2s2lye3WgtOWzNIbun1eMJxL7e8y+9kJmNi0fG9m4BXYwgtnY/2p4gVeHu06ZXYHPZ6fcUGJ3m2+j3ypuma+jJqn7Zw3W3A+YCJfHTRFPHpY2DzOziCyPkVuTtc/W3ra8s9+xzAqZuHG08fuG4+5GF1UX+eOBaedHFXuyoRkT5bXnSBVzCl18aiTKLT1U3ZtFt7/xmTtI/MZnq9GiO9X3i4W7XAkXXVSClOkjhBT22Tu1JbhnUcv8Nto1DQ+PzCxJXusedZlyt7
 Z40ReJOR
 +z8iTN7JyZv67a6AcT4RRPR4eau94fQdygKP5tc/8TLcEOfO8HenPGEjTUsXmZyCA90R6JDROqTKReS8qsPIXjLhlaHvlADAsWnbJI2clSJ0YTw9YSEg0LxeuVdRqDqmjT2q7+2Ycpcqy1U9PIY00a4IbynIuhQFHQZkkLcIaePJy+v/p3kuXrokrlzIXqpam1UcJ0gOZGWScAQphZ3F1AAJM2dMOXGeu0CJqnWy/MAH8FDOnsZ+0PflWw4g02bcQXOBsDAOrWqxdPpS0SiXNm7a9GQbsZ2M7KvxMn16UOHjlobXIYn9BMlGHy5Wh8b9J/OMyfN1zLbtgpGY++I2/vklRlzZxKvo025Qc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize securityfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. securityfs never holds executables or
device nodes.

AppArmor puts a .null device node into securityfs but only ever opens
it via dentry_open() which doesn't care about SB_I_NODEV.

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/inode.c b/security/inode.c
index 0804023676741..93997a9f16fcb 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -14,6 +14,7 @@
 #include <linux/kobject.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/mount.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
@@ -64,6 +65,7 @@ static const struct fs_context_operations securityfs_context_ops = {
 
 static int securityfs_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &securityfs_context_ops;
 	return 0;
 }

-- 
2.53.0


