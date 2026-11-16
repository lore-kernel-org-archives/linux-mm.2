Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53FBE606C12B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BELkQgA+
Received: by kanga.kvack.org (Postfix)
	id 6FD406B05FE; Mon, 16 Nov 2026 06:09:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B3636B05FF; Mon, 16 Nov 2026 06:09:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59C0D6B0600; Mon, 16 Nov 2026 06:09:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 31F846B05FE
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:09:16 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B93781408B8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:09:15 +0000 (UTC)
X-FDA: 85440710670.21.5695013
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id DCFAC4000D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:09:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BELkQgA+;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zqQjJrWkVR/wq94sPR8zCRWE0M9y3ORxEXNcQuokekg=;
	b=W4SBXurYRhlrM6fcFkChwg566Bswy49kHImVtiPsTrdWFUaMNngLZetyf/ZAXU1UvAYtbm
	AIZZb5XLVf3vKqYFqeKsa98OcjYSKM3pDmDZRYLiL7lF5cQpBaSHgvCxeAzEYnh7/KynhZ
	O8oFupSaY3sG4s7MgS9ZzW0DsAHUrIk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827354;
	b=vBJ4PdrvyOXBl7BwssJeSchseWnxpFzpyZDjKAnLBH4RHewSDV7qEuvUqYgGGuGTZDvsN+
	LfbK8TauAco0ZfnSZDqEUv79J89Wv97AbFZakAXOSdtOUarLmD9bvhzlRCXtFDPoELt4HA
	jnZMMoK0EJXMVuVyk8EcggxAY0eJ/zE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BELkQgA+;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F85640457;
	Mon, 16 Nov 2026 11:09:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8211F0092B;
	Mon, 16 Nov 2026 11:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827353;
	bh=zqQjJrWkVR/wq94sPR8zCRWE0M9y3ORxEXNcQuokekg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BELkQgA+1uhP4Yh9mY7YTRzmVX1Lt6+NxihYMNiPBnr7kADNw+IhI4iJNZo9qPEG0
	 otvwqWTd3K9hOd4IXPaoimQcgiIHh86c/pl6qJ58qQN+csCVnEbW9PlDtFNCdb/8sg
	 C0f5dm2DnFAB0E7ryhBkhEN4ByuTq2ZHxVh8CovZfQu/3ab/bryqauF8nv8lmMSpr2
	 cXY9HkSOS/eE6IVhvXbI3OnPyyB9ONBOUBa0bRSQfuj0Omm7mW25GibIsbr6SOgLKf
	 bV7Jc68+9XNGqZGg4DoS4vuA98Nss3pthAqpMpPE7+XTwcwxOHz10gzVDbOQrH1VPK
	 2VuLPWB7ZXGhw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:58 +0100
Subject: [PATCH RFC v3 25/44] pstore: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-25-8cbbea1cf34f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=988; i=brauner@kernel.org;
 h=from:subject:message-id; bh=F18L4eFsLQ57uPzxhAOtLLc2F28lfm+14r18Ia/k+iY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9elx9uNrhsNOttDk/Oo9/9Wm5fyW2mvmB2a3prhvLl
 PfOcBN16ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIek+GvwKyx797zJhxcr7K
 hzzhg1u3mpTerPKdujXVdJ8P5+7T6g4M/7Oy/t5WclW2T37im9i/syLTfkoh0+HUry9PxXeqXLx
 TyAMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ahqxzzsd16ngpbrs8simdo4nje4g5kkj
X-Rspamd-Queue-Id: DCFAC4000D
X-Rspam-User: 
X-HE-Tag: 1794827353-678128
X-HE-Meta: U2FsdGVkX19roHBe3kM5T23Fk1X2sDpjis7NOBhN1m1PTSwlLqsGQYX4vbqcIkcVaTPpdmJSRXJZpeNndN8YzyJC8+TOA4uxKVMMOj50JVbVa79z5J9aq/h+Oj+tKtFjiU1B6eNXvwVC0408wzN/QAcVbmnwkba99WbeVekFMZZMBgIIp4JQsE4kyFUsK74Yi5xhZm/zJ9Cg4iiOk5+yv1AI+uhCUEuZdxk0ep0bI/txol/u1nTT5GT/VKR2vPnvgokMN6TKynLePei495WbhCEcACBMFJOukCE4J8BmQ3KrCK4WvEEm7lHEfWaERUN4YKVbtJbDgE5a3HeHGm4kamnLM+H74q5sL6TVa/hmRF2wslY235W4CELkuoJrDwQIPtMODcG+QvMNCEj76dWq1ZBXrLqO1fA9+NzCRBPg549It1yg1gRFpfW5lq8W8k+2oCO3gWr3FlhyGT8jggSIgrPBsNGoKfjOseuWzIocyUH0ahU80+7EKo8b0zB+0LXhZwELEjqnIza2fFdfS44+Hr5meMVxdw2atfW2LVHM8kw6Dk/XpN/fp2f9ZgMZiOHK7NaBa63SPa5kDv4bmffTOOGYjCFPOCMkJv/vO8t/khsBkOXqR0D27WQILR2gEQVyfbtXASa2ZNgjAaf1mzBH0vjirDy/yuoZS4/+Z2kJUGMW1LIulqlqz2iJwi0tz+aaUXQhlfhMG94++b8z80knZFokUzVUfeq6iv3FfueqY8QIqKg+WfuWx8vVw9WUZaxXamYJBFEeGWVSB2wHIbz6XBZONScFU65KtOJGs3hkd2G1Ff7vq4nW+VmtRhM1LNlaaOb7gT+9+uiS7FtYWTDaweyl/8A3XYiNpsI3RQmXG8hAmEUH58MQg1A1l+QamvtcJFnTev6hdr19Sny4f4eiijNPBZ//gPozlhbCPWWk1RRosWNdNea8hzZC2R5IA5QA/5hV/tGx4xeoZA/26qK
 8hcHErkG
 7PtGuavDBjcSVpeuBTaiyd1jAvfE+DRb79cObI6m2411nxam6zZZCSwva75NfqlIxNzNfEhFj7Q8MPhn15ZDDgxcqHACfmDlYTr8/BvTzUH8qf83FL4gB+yAk+LGH657t2cr0ejVM3CconTcmFUMkK/cPNg5MMWKHJSO5vBz7Uy6iP5a9wtEk0uPdyTI9Nu9HgYhO3+tBuJ/84PyX+LHSD0ncDTMyziT+OJf8CaGKqKaJNyvY4poeWhHLFCPOeyhR//5TlI3UWtj/7mA+ei03CWZNgynUAoHAM/oX6rbiMVZSECaxxyvKYePEj7hqgQLG0OPZOrQDMpXEN3wQOJDi6wfJ6eXmPXM20X6+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize pstore as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. pstore never holds executables or
device nodes.

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/pstore/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index cf499ba727026..4658561cf90b7 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -18,6 +18,7 @@
 #include <linux/ramfs.h>
 #include <linux/fs_parser.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/sched.h>
 #include <linux/magic.h>
 #include <linux/pstore.h>
@@ -491,6 +492,7 @@ static int pstore_init_fs_context(struct fs_context *fc)
 	ctx->kmsg_bytes = kmsg_bytes;
 
 	fc->fs_private = ctx;
+	fc_init_pseudo(fc);
 	fc->ops = &pstore_context_ops;
 
 	return 0;

-- 
2.53.0


