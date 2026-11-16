Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B36E606AB56
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YvkLPRy/
Received: by kanga.kvack.org (Postfix)
	id 9BA0B6B05ED; Mon, 16 Nov 2026 06:08:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96A416B05EE; Mon, 16 Nov 2026 06:08:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8325C6B05EF; Mon, 16 Nov 2026 06:08:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E9466B05ED
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:08:00 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC4B780926
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:07:59 +0000 (UTC)
X-FDA: 85440707478.23.21303A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 31E9040005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:07:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YvkLPRy/";
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PqfeLGmjk4y0+kxRkxjSur2IdVXjx1oPYJuREevbBc0=;
	b=a4oQZ4R8NdN6Dt1arLJetMvY9kTbce62QWUlr5MOf5WuFO/BzTYxIHoBhNMUcaRQMJVHfm
	tRdIw6nafXGZLoH9t+DJ0uJzym4iKD491OC75zqINitV6Ob34etmLBMyQC5KbSHwbKKrEF
	ESlEQSYPwLwW4DQLmgWvV1HrN3Abj0w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827278;
	b=TJrhOqiXW8ch6F0cSnBSyNTi62yKQUrpoYIfYxlN93jt8D4CgtlpCsuyKAbicpoUo3INE9
	WmBYQNz6UFRa16oJsTRlqElFcXJzIK7B7swvyByIPXF9QQfwhFQRjfSi3BPQ/grjIAS+k8
	8VxT5f64dnBsYWUprsk5CG4+i8LHo70=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YvkLPRy/";
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 83C1F41A97;
	Mon, 16 Nov 2026 11:07:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D961F000C5;
	Mon, 16 Nov 2026 11:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827277;
	bh=PqfeLGmjk4y0+kxRkxjSur2IdVXjx1oPYJuREevbBc0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YvkLPRy/TdN3pcwscLXBhpcduUBjYfqgxZuCJwXsSL+UDnogKKD+92Xz/+diWB7NI
	 0mqTTOVlCiRH9R0uBfT3YiIB2BmI3UU7ll0jcE3kk2lC7TLroBC6Pkv/qkjCb2pKNw
	 zDc5Qqdo1HgBsZBD3BoeHwLBK/Raft20V7BmIejOzs9J/6v/WXVyn+g9CQ2gGm+AqX
	 J1BdMMjoyxnVFZYvSfydNC+8KMf09MmPJr+eYY10D9OpdtxnRAAZVeQJdaGrm0Le+R
	 4Rzjk+4/AJ7X87jNNtb5qnMUVnAQtEquA0JDBGjIxtZx98uV2qTRkccJqkx7xTRA3w
	 c7AFtct/ZdTHA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:48 +0100
Subject: [PATCH RFC v3 15/44] tracefs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-15-8cbbea1cf34f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1157; i=brauner@kernel.org;
 h=from:subject:message-id; bh=jWsk7jA40wU8aE/ukx0Eq/KUmnvJ+ql3poj8uK0lOp0=;
 b=kA0DAAoWkcYbwGV43KIByyZiAGr643Cha2aEDzogEHXFHDf4ItcyB4+yUL4ANkviCVs/P6sGm
 4h1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmr643AACgkQkcYbwGV43KI/pwEA638U
 1d15U79N804Xlrmzg1WVT0YbKUtsgjGXa9iRx+MA/RH2I1+OACZjxtKr5OTHN7a/GnbvmGcfgyl
 DomehAAUO
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: tugubxu9m58r1dmbaszgaew88r9t6ing
X-Rspamd-Queue-Id: 31E9040005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794827278-623774
X-HE-Meta: U2FsdGVkX18ffgJ0fJSjjvbCHIPJQbkrcnE3tVtU0GTToQfPt+re+oMtGblnJ8n1U9gOtARnK5A8A/VpFMpPoPcEH4zMdwU+7akGllbNmBLyyS+ZJAJQ0KqE0UoWVowO4N7MujClGCSZJCGMH1dHkGoQ5Cbm3TWzjSw+Aez+IfiABn+Ag0bOTLBI/EsDdEsXvfDhLcQiIYBq9cxuYERsMGCI8taOrkyML1WfmIKWoOBizI4hJby0H9yYXdKPDMZa0XqLzEQD/XIctRa6OPxNIjeCtjx1j85y2gyxIU22v+t2HUEW3QFa54egM0G0skpLG4EzGP2WrPU1hMyMOLckbYwmwfkqaD3FzCa1VLNs56VCF0y3jfQDSDi71FbqD8jQB3saL9c9B7PhrazIaZwM9u/1AzHbAM6m0WrEt4YLfiCF0wrXEgpNPLnYuNu01eHH+mFLxt8Djr0KJi/E8rG+8Y/ZEMuuYQUGq9I8b8mKjOsPz4/E1UerkGov41nliC+5DAFk5AOMvtxaMb1MIE6BcF1OUlbr9krzfployl3uqSIgCGNNiyfNPmU0GqWazrus7qKeaCmgDH0BW/UP9/ivlJQlmT/OvmY5ildEQ5l1OvfVIIESJ6uddtLFNy5q3vQplt157vJNws8G/B9NJwczz7da8wNe49LimgpXaKWJEbWzHtoxTW8Gd0wMOuR8s74+6W50BleDQv2VtM22/Q4TAbizBWecf6mK3+3SZMbQ+z7k3zz3oM4MFK3uehROdDv6hP2i/Y5W9Lb4IyJLy0Fz0B/yi5jZ/+R32z4etFelajuer4CRcePld9heSHHyJvguASgMy9Trbxs0+9N8LTnDcSj99MXpzoRmpvhENaV0f6A8zX9fq01FxUAlp0rxHvQq0ApKt72IeGwo8H8sRmnScZHK2QdESiVIj6UDOsgJMkl0MnpRPQXuQlOX6JXl2LTO4bipVG3y+FMUkSy6vcp
 rDXpi0lB
 QVJl3JACqaWKYCg2KLyCtVI6KozOFUWF8W8hBekHjVbdnT5J+BxUIeqocyIODUMp8yHt/2KBHcR8pn3Qj0oWgtlcZiqa12Dcix5HQxJVgDgTGjhFjU5WcAz4xG5D78y9xrsDbNmxZs4eLKKVEyWM/5e0/jsSyGJYGskz+ngS6ZL2r/N1h6GqY/2ul3GGrDLIy5Ab/VwjyWNlkIPsQJ4EQrUP1rBKgU3QgnPmPPA/04LX3e1IHN6tnxLW1CfRPMoZPQ6yynR8TV2ZFhmK+foygS7y+RsNqVugvqdWoC4zera9WLp0umvoLLNWZyChe3Tj7ZFkzM40t3pAnlFTfXjDFfB+fm9t8y6nQKGZa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize tracefs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. tracefs never holds executables or
device nodes.

SB_I_NOEXEC also refuses PROT_EXEC mappings. The only tracefs files
that can be mapped are the ring buffers and __rb_map_vma() refuses
VM_EXEC already.

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/tracefs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index 5020365ca7048..e04febd868eb4 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/kobject.h>
 #include <linux/namei.h>
@@ -510,6 +511,7 @@ static int tracefs_init_fs_context(struct fs_context *fc)
 	fsi->mode = TRACEFS_DEFAULT_MODE;
 
 	fc->s_fs_info = fsi;
+	fc_init_pseudo(fc);
 	fc->ops = &tracefs_context_ops;
 	return 0;
 }

-- 
2.53.0


