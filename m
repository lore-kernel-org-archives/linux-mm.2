Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95AAA607B2AA
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eWqStoTx
Received: by kanga.kvack.org (Postfix)
	id 833476B0602; Mon, 16 Nov 2026 06:09:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 770F66B0603; Mon, 16 Nov 2026 06:09:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 611CF6B0604; Mon, 16 Nov 2026 06:09:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F3826B0602
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:09:38 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C3BB640966
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:09:37 +0000 (UTC)
X-FDA: 85440711594.08.E24D9B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 641288000E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:09:28 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827368;
	b=AsjV4dY65zVwKJ/CglueJUMStPjoBJom7JUZJpVszrsFYtR6cdS3dezNMcHY5tBFP1AIIp
	ff1kSTA2J72jUX2Sjb70/oJEQ4ApIPplo2MmAQdWH3+iMWZG4m3L9P5ExsjdkflZbvMV00
	+0j9b1ZUZlM6+zzNsAfFKyCbud6KCOs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QuUCHwL/BY1T2vLOc/gPlh6w5Yz8cRxgbnaJubMSr1o=;
	b=x0acbUgQmbO8mEjOL58fmyIhhRIeNTZ7mBBFjBWT8CKZEKIGG+hmIfvu9yeIak3jHvaOYT
	lrXDF/tbC8xzQ4Cryiec5l6ToLW4KaTLUCjOh1mj/1hrG8KBWE63o0rOP49yc9o/UegDPT
	6W6imm07kcWsw2IUsrHWu7suoR3yGgg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eWqStoTx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 003036292C;
	Mon, 16 Nov 2026 11:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D331F000C4;
	Mon, 16 Nov 2026 11:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827367;
	bh=QuUCHwL/BY1T2vLOc/gPlh6w5Yz8cRxgbnaJubMSr1o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eWqStoTxh4NNpgnqJQAbTvc3F6THAiwGDN4VqPjGqWwxK7grKrhzbpvrlHik7rWGw
	 LmyHVzhO9Te46cFwbrOlUqPQT0oF/HXwwsXx3MMepT+0OdecMLBteD88v1YwtZDrjb
	 AXsRBPgBjWNowMrMKNpm7VyBaHOaIj2F5J1wA9g6lYlollu4Lr9qETGzAR3sI2AGOJ
	 TSaw2eCAkAKBPUtB9DzHyshTTMIy6e2o89WZ3qLFdUdLDNqsf7hoK4MdFxBxrCMMKa
	 uJI1F89qP7iitUo0oqG6za1D6pwPB3mJIgwX+N8gUTguZ5WCHqvLiCThVUudhF+1hf
	 dv7ajSbH3o8+g==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:05:00 +0100
Subject: [PATCH RFC v3 27/44] openpromfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-27-8cbbea1cf34f@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=932; i=brauner@kernel.org;
 h=from:subject:message-id; bh=t/2kRMsiGpRT6NTAIUV0TfnxBeUt9A+YVEprnQjtSPo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9elx35JxdT7pgb6K/ULzwVsNHP8XWzVsVbHLnnG5L8
 e7oO9JLOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbSYcjwP2Wj/4MPiqKhcgc/
 6/xyjMmNPSASpr2muGTZGal3tfctShgZfp7MXfTHwc5v6+RFB2fUhtm6Ocdt0Pvk2nTfzPHRZid
 ubgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-HE-Tag: 1794827368-770887
X-HE-Meta: U2FsdGVkX1/xtx56RbPmNwhwsqfl+Zh/7z/abQdLhd4ROU6lxOqNl6a/XidJMqXO7QNzZxhIEpT5luE2ySobXs7aTga9kCZylSDCiGbikTXuO5qfz1/xplHVxrlkaNix/vmizzXMSKQ3aLHz4nuQQ0RA32lBi/ptsgT0GWK5i1lfpwzZl3MDo7KKRG8sPlOUA+pyvp4M6V1VY7RPaxFzHLkM71VGnUh5dy9FEXeLNZrTqChlsChpWTiss+rhnXJ49MTtg4nCFSvfmVoRydCe8Nx99qZU3Ngsz5+e7l28wvnHop+XzkzwLhetDy32dx7NNjLu4J/gc1Vop935rA0uNm1+WGwoJ/6AQt2vJ2M1QaWOsVdN9zE3HZMaoFb7ZUee/VX54ET5jJ9rVJWBYu0bKpANpPbKaVMyI3fGeUZpIDA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize openpromfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. openpromfs never holds executables or
device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/openpromfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/openpromfs/inode.c b/fs/openpromfs/inode.c
index fb8d84bdedfb2..6cd02d456bac9 100644
--- a/fs/openpromfs/inode.c
+++ b/fs/openpromfs/inode.c
@@ -10,6 +10,7 @@
 #include <linux/string.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
@@ -419,6 +420,7 @@ static const struct fs_context_operations openpromfs_context_ops = {
 
 static int openpromfs_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &openpromfs_context_ops;
 	return 0;
 }

-- 
2.53.0


