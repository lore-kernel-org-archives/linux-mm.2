Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BF3A606B9DD
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iQA/sxsh
Received: by kanga.kvack.org (Postfix)
	id 757606B05E1; Tue, 10 Nov 2026 04:19:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72EC86B05E2; Tue, 10 Nov 2026 04:19:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61DFB6B05E3; Tue, 10 Nov 2026 04:19:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D0046B05E1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:19:13 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C421680363
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:19:11 +0000 (UTC)
X-FDA: 85418660502.25.E6224E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0D243C0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:19:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iQA/sxsh";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5VuE4/weECRM9eIO6+lamMRzkXENJc2tSdRrjKtP/6E=;
	b=U+mT6rjgumqk39GFc9MPXFf23AnTKRUW8t+lrQrvRubhNeGf4AvuNtavo+tD5B2OdQ/eDA
	6GPJ4tL3cH/NiCm2qoogrC3+9evBA+bMD9bdQdqaHxcpYdRy6xDS8B1ijfKdfO+8+RdWv0
	aB9p8gDUzo9Qhvy+bqJd2/HQTrmbOpE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302350;
	b=yLUc3OS3hmBgUIHfk4uM22QK7BbtzRtzmvZb9Ktq0P3xRq5oOxbFZnmRzZk7Zx8YEhgNer
	LshcBffhWIyL3UTpgBMcD9N+dmK4ZhPK0Yxblssf+SN6DgiX5Sl6qCutTAA6O/0ZQCyFJO
	yHIDTY+6HTYqPHhhd+EdBayJmTur/+8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iQA/sxsh";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D6824487E;
	Tue, 10 Nov 2026 09:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77511F008A3;
	Tue, 10 Nov 2026 09:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302349;
	bh=5VuE4/weECRM9eIO6+lamMRzkXENJc2tSdRrjKtP/6E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iQA/sxshAM8lgjVZtwQBlBlt6Ccgq/KLZUd+ak37Q2oUOuNb3EKD2IEz5QKL7HSuJ
	 PzfYZUUU9t4mHJQyXpGh/FegWtFPckXXEaWIZpe18Dzveuhdh412cFkoYX9U6GHhAs
	 FA3mIwVRbXfRG/foFS7hgF8f2XdzXBVoA2mbPV/1dW+mNpe42vnBoqn1KQUo3a7IH3
	 OShJM3zaQPTgLbpL8PYQYa3MhajH2yuDWbFWTSzcixuX/GpsV21irhlminf8YwjK3i
	 FcMM/10RV269QdY1WwY6VGtRQ1P449Wk5bY3A8Uk5z3MdBjKp3IUMwp4dCZ2nOAdUX
	 a+oxx0hQk158g==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:44 +0100
Subject: [PATCH RFC 28/41] ocfs2: use fc_init_pseudo() for dlmfs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-28-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=909; i=brauner@kernel.org;
 h=from:subject:message-id; bh=IdNufAsq5EGNNcdE9WV9rVN1DCJjWbb8v/riZT7kRA0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erDl3LqF3BIxnOW7s6R69N3au4r1m0WSo7rUW0tPb
 d3ziC+no5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCJLTjEydK1aEV6R03Dp6Qur
 9ReajrtK9AT09OsHms5fHf0wofDSUkaGzj38rmzbCz87b5+14Zu8c8plz01rglO+aJ1tSLofN8u
 eDQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: p3h8mca1snb5ho1jtj3bs3ckt7wa1jza
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0D243C0005
X-HE-Tag: 1794302349-563540
X-HE-Meta: U2FsdGVkX19a476uVGy7laIa2HDSBJDswz5Zl7NkV9W4XrZ4SFWD3Oq+GT0liAca+Au2VvfXVew/yPFVL9AxAMDMVqXcF3JwqY3XXkqXauqzhD7RuWwdjeizvdu+MNhH5txC+evE1ZXEpEdNkhlq1sV/t3BfOkbSmx2NkJqdDdVBynlnK6L+6E9smLA9W27Slu1cTYdiLfeQMcnHFDC/hliTeFKlEikX35c2taXFg3/IgoG0rKMsWXnPTBWHWOmiEMVIaILw4+ATS9RM0tjgY75J8FM7ClTJ5QdnkTgtEvdk9j8Hj6CUqP78aAZIhADEbyVWo3GB9YpUj/0qT4QNzu4I50gAIC1qSkU8ex1MbZXGh50tmth7wwiOO3fNf0DOUu4bLGveH+65enVEgML/rXsszIU73FGr/LGQt24WokhhBWK0mbEAgTAmo4YhVmzo5yk5UmXpdJWb5Y07iwFeL4U9ouspsPppOcwA8Y31AwxpOsAtrCcB/eYnIK3x357mAcZHLUzh9Tt1zIGch+E0mcXmI54D463uyLT9+aswjeg4aCTrv+xKABJc4ovZnVgyWRHj2tszsIEIVIFLve/KfEQWM2EBahaDSWlW7tPqb0qi3Ln6FhNbzHoZfJ1tlEzhdDIjos70MHIL6sUi7p8UWbyCI5p1QTMd87bvCaEYSU/xSC0oltOwl11wplau9Q2O9z4Pc3feyzWsj7POz/RRplYlLJxjB5xguNLel2cZfBF5SeGNI6eOHW45Gchx6D8LSsJA5fIV32n0bI024cJMo6DuB7tUnrVq9fNE3uTtOoguecIR9rN7yV5MmSJHKxhe6ui7hyc9k4a2hi9RzcdYIMEzutewisXoDWbbQO0h677CBvPWejiMV3sV34RivAIALZDHzYiotM75jLTaT1w3aXtKLD0RNgqo39JSgVEGj/tLpCxLkZ2VUMbxusJhHIhfLBg/4LNrvVliJOZVhaD
 nC+aukhT
 2yO1vIKTAww8gGHahVHxisqkqTfQz4q217o0PHYrZLDVzqjYrrzIfDqDnc4EdkkIpIkQHsK9mM30EN0od2GIwSUUiVbIocirVYuVudNRPyAgViztDmsxU13s6NGAOnGmWd3uDzrFOPK++5pYGpC3NnOns0Noycf0rv63mFjf1Jt97TtBBZmbG9Yms1aqkMqrEP1XPpkfYg60HSaMx/S/tmmcQRvYhE6cOL7hXgdnTWVXBrNUVF5Fne7HMdmDbi2Y2Ceqx1fMfhjGHZC0mxRPF3GLU6W9E66spNmDgTGGGYUE2tYwZ2w7Ggp6bYk7tStDa6SoF+0RpCD6cr2M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize dlmfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. dlmfs never holds executables or
device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ocfs2/dlmfs/dlmfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index d3bfcada3e3b..1789ec96dc13 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
 #include <linux/types.h>
 #include <linux/slab.h>
@@ -563,6 +564,7 @@ static const struct fs_context_operations dlmfs_context_ops = {
 
 static int dlmfs_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &dlmfs_context_ops;
 
 	return 0;

-- 
2.53.0


