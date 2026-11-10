Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE148606A91B
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R9v9qHLP
Received: by kanga.kvack.org (Postfix)
	id D485E6B05CE; Tue, 10 Nov 2026 04:17:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8A96B05CF; Tue, 10 Nov 2026 04:17:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE82D6B05D1; Tue, 10 Nov 2026 04:17:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CA896B05CE
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:17:49 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3AA8014011D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:17:49 +0000 (UTC)
X-FDA: 85418657058.24.17DEB61
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8D75740007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:17:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R9v9qHLP;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302267;
	b=77Y3RmfV7KrdA9kdcm8NQwf2fCp2HeAIRZm3pSX7hDmkMaaszWulylMgddwLnF9k1S8qV0
	jqh2Mx0VLBjdu1uz3GEOnOYtSyXoJm8+orhkJNF67BukTlk9DFTiHikB/12OGDvXaV5I+i
	UKzIQcwD7xEfFd6Y7j4bc32FoksHrFE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R9v9qHLP;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l8LDAQNHphQBAnLKVY0j2bP3Ogdq6gK5b5xHcx0dYsg=;
	b=PN+UDDmHW7JovulMhEvg8uxnfjs6lq304zMk3DM1xSNpkrdF7i6HQ+/UWCAY5PE1WEyP6Y
	p6osBue4J/q2WbVobhXr0h5Z8hcmhhuvM4WaERD7DeCCy3ZfMUVlJI7N2jPvEv5wzhksV0
	dssd88YLxSZB7CSZyXrk3AxAHIfNyEc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F16063805;
	Tue, 10 Nov 2026 09:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987041F008A1;
	Tue, 10 Nov 2026 09:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302266;
	bh=l8LDAQNHphQBAnLKVY0j2bP3Ogdq6gK5b5xHcx0dYsg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=R9v9qHLPfZZRHObjYnC3o1mAzO1hP+/9155v1wxmmC7hQDax+NvgTbE4W9xrNan6b
	 z0Sdkmw0b24b+Z76hEcw0ec7fC8rhBm0gmhG32Dr9KvOltCueuenMbGzfKiksYbb/R
	 A6o9Yo/dPlBuObvaZL1En87DLRIXfZzEMhiQLtg8EsJhl2E4mtXzQGo9ABc14bgHRe
	 PZldAZR1cxgMtFhW4nTK2eKI2Yi5t+MGsF5VrX1YHsgpjfxFteN0G7738shRXMLGdm
	 N33HXtEWu+Tp9JkAiYvDDygE7C96rLISq1P2stvft/KA/fCZ0rHgRq5v+c5DMmWCFV
	 ymFNp2JgMpqoQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:32 +0100
Subject: [PATCH RFC 16/41] configfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-16-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
In-Reply-To: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=912; i=brauner@kernel.org;
 h=from:subject:message-id; bh=FZSn8pZNkelWJZuy96PPD0cDLXKTFQ+NnjbEVUus4Cs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erAsoPxm8YvkDfvCz87c1p11JmKH6fuChtd3Yuf8U
 K0rc7F601HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjARx10M/11uxYdrM97avS7+
 mvJWaemvRj2ydif4HQs8FhZrHNFqm8Dw33+Ncnarxkp9i/liZ7b1r790NO6pyta3nhe6A+fNCn7
 EzQEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: u8d18p8nem14acrsbc3n6rom3k37fhtq
X-Rspamd-Queue-Id: 8D75740007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794302267-997313
X-HE-Meta: U2FsdGVkX18HrTnTiv2OeTB6ZgOmBPjZuygLyuZsyc/shFDKVAz1FRVKfC+ejpVbJ+Ahlb7OSN4hWndq5nxpfufqh2GwUrW4kLeYQHul3XmSzhkeP8zRyVRENgrgtzem1hZInVu99sMFqIPw/25Cdh1IaXV2nqacXvalSPWxwk/bWjx6oIp5VJlp6PTFEjDhTGLyHBKlPFYT71F9Sr/IwL8fpJrRArtLjnLzhMVriabrNufF6po++fRciGXkCufU9Q/CNXqOLRz3ePw09i4OqETzMYPHpkwYJb1bv6Iemfm15icISbDSz2y+K7MJydAxZAts/MxzkgsAqUdRVT89OWHqKzfAC5My2FBGXpGYCUDbvFf+hpkjOMBw7JEb+FP546LGaEIdnFUJ50Fbe8dTFM9vXVGXtfMr5WQN5VxUrDUwNGunoPfsbW+9otmx2f/18x96v/cufA1gPRiB72XBDjf5OBBY6h6YSDDBiEWx5+Ll4jsq/kNJGpdiTfN0IDePNqDPpplKPQgUuiIIGaa0pz2mbRXexIHgpg8xoOfWCxvgkFRE+9OyDMXhJaiWR7nVa0OhxqiM5PXYAZNjjwWsc6kdBAk4/LMqj5v5RbSr9Sxu0cGPpDppBT5Yrq5uFSAEdVC3nuN4BvgQhkKEenI00rEf5/kIN72yymANEMyunGcR5u5qtfxGosYqtIOcmLwZff7xVztOMyN+9aHQ4MO0gPTMOmTiKJt9PKUlBfjxNEguG2tDiQqSioAIS5OQWEAXGc6fRIhQZJKzHQZQuseZWCqRki7INK6r5tQkRo9AhdqaEZ10gKpVaSRtHENxaRlMCZkXXERlwmbeWWlZe7fz06wz+CvnWMHncaY0YMRiF4rvKwOjp7hEMcTAqmsxddcDitkZRlm5S4gbBrDsOSFJXan2qf9myd27jeTq1luIidFXFnhzmqWVT6WZifCS8QoTIjCSYscjpNoSyewZAkV
 CrNEz1BR
 E8bghPdWPMulOO3ZOtqmisle5opsCTRcb1dR2YX/jL62xWxWoHd0MYU7IM8EntbFOm7oKGQzk1QT/D+G9z+abUeHDVdCXph1UE/bK+cWJp9N6+xMz/dSneQvvFAkm/+CElvm7FwGVtgYl1UvkmRXKwXE6B7oaN69o8FXX4qSsbkFH4Enp7nWc6LeKmQlUCjhhGuH3dZJxkSZruyoEuVRi8G8YmX4IPlrGRdQ0AgxNZEZESW0uJDY/apZhm3lGkY/lrF4FTnZ+QMzsEwcXbHnMW2+2PEYjc2pEj2x4mHtlgeEpHx7lRmITleX4GPYRJ+eciPDLB6XgOQqUFeU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize configfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. configfs never holds executables or
device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/configfs/mount.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
index d8cac1cbf3bd..60ba24e7ae2b 100644
--- a/fs/configfs/mount.c
+++ b/fs/configfs/mount.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/mount.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -106,6 +107,7 @@ static const struct fs_context_operations configfs_context_ops = {
 
 static int configfs_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &configfs_context_ops;
 	return 0;
 }

-- 
2.53.0


