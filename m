Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE466606BA24
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CPIiv7kI
Received: by kanga.kvack.org (Postfix)
	id 210FC6B05D5; Sat, 14 Nov 2026 08:08:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C1B76B05D6; Sat, 14 Nov 2026 08:08:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B0EC6B05D7; Sat, 14 Nov 2026 08:08:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2DA16B05D5
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:08:21 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 85F1AA4110
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:08:21 +0000 (UTC)
X-FDA: 85433753202.07.477C09D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id C7CE180006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:08:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CPIiv7kI;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661699;
	b=Rd42s829fF3S/3gjp+2L/a+TtUiiLQr3vPG7pPFSooKBvahCeDkNUQ24owhTdtOxAHEpMw
	RPWo19euymHebOIcgCjrdCJI9j3Pqyu1jve85/+xT+++zONzH0dwxyjf0zWP3Gaw8/Ylqn
	IMfVNYnnuPDZ91lvJa3kiUHvzafdw8Q=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CPIiv7kI;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YgZhtD2KV2KLabc0QJjPTehcwCNTaDbDvhsPGGFCai0=;
	b=S33wOzMWEPVgA1mLLHHlZLXVWfSOHKaAHtnaxE3/Z9cFIKtDJJy9cUFIOPX7mJnK/JC6/0
	2EIr91dHxPCnetYJELB1O4g9SmWhCmO6EWKiI9V24YyoKgRmRJgOC6CQEa7J0jWZTV48bN
	0/xCNL5rbR+bj4tpeGCi8cxnRiVXLws=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 22816418CF;
	Sat, 14 Nov 2026 13:08:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858C91F000C5;
	Sat, 14 Nov 2026 13:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661699;
	bh=YgZhtD2KV2KLabc0QJjPTehcwCNTaDbDvhsPGGFCai0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CPIiv7kIlPjOab36ov86SnfUDzmkpfa1Y92A6ehKtlVHTIqCbDbxLaSph+jONs2Tb
	 LSgZlgiffCsO/JpMzKSIo4Bqw7ro2iV+VuM8Lgw5HYeaUVevwna4ucvZdgD7CMfg37
	 v6lx11AiyHvyiNlpYuwzAkQ/BLWonAOXTguqBCXfTtmkLsbiKbpecyzp4FMvOPCc1N
	 LbJbBc74lGhQKkHAGY3nQAZK1Lpq3a+xGFZdBwSAXMAUkGq7t2V92c1ukQypIL4+WZ
	 7tsqPrdqgFICsXG2DDkikpnj/7w12eh8JiLWB/4dRGie0/g6rFv4AHXFeK0Bhpqo46
	 xlxuPo0nSGdMA==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:04 +0100
Subject: [PATCH RFC v2 23/42] fuse: use fc_init_pseudo() for fusectl
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-23-98639a2286fb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=951; i=brauner@kernel.org;
 h=from:subject:message-id; bh=OTVHfr96xgBpFGFHGPd9YzWwNGICdkd4ukGHZq7+6V0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iGnwlZ19N+BN1O05M8J1gxnSpkzRP388jOX8mec5x
 cs60+9zdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEyEjYmRYeL2Rxd6LogfN6hX
 6fA32Go6kT/p6w7/aw84omwELm89xs/IcFl3m/5f38aLgdyOZ8p3FPxbt1eR64KN3frP56Qm3mJ
 4xQ0A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C7CE180006
X-Stat-Signature: rq5en5tadz1fyey9bk816mbabye4hppk
X-Rspam-User: 
X-HE-Tag: 1794661699-298191
X-HE-Meta: U2FsdGVkX1/a/Xin3KacMSFFHkQTaVRMXN371cpmf0yY9o5wC2pmgXX6Vgix0N3d56wekX/v/8+giQHPmP7VWNiGz/TRcDxgGwoBq05hjKcUMcWyM+mPvwSvwmAnOKNgOGEJP1is3O/LDepVIaqKa4FQFKohjL3keCnUQ1dWPBDpT0126A2QL/Jp3ttARADp8gIkbfCPda2yZBIEuh8Q5s5lyz1wVqFJQwvZnjFEwLQ4aLwOqwr0QAqclMiskci/+KZ18zuaK7j7EIaOM+3I1CLrahIG3K7Q0GSiDXYcVC8XY0QdykOPEKNUUcup2fUAej9hkgPwaNPh2JQRvnAo9kgSPsVHkinGNLAl17S4ppGD32tIYeXX6fLG2yeBxR1UsWNtY8tXb7oSEF6yxn8WOd5WtLexsUtm06wHu3hJFVKiPoG9omzre1o3cl7X/4Cvna1rBwlFO6V5R2euwgc7khVLZ3m+Dr/YowOPhL1bli41Xo1B/CysXQqcTzkfQjxwFnXbiB11Cdc0lUIFFw9lP/PC3sUEoqFC/Alx1KXgg2JvzwXa1pFtUs+CmStZXJzJE7hb53dq/HUPpWxZTgoUOtv1QQGLaw5Q3L336MSQpB7J802Oz+HKftbKf5qJcDJgXtfrsDmJHzgn2vKaqEpP5Tflm8xfxi2TCgE2CQLFZconCJy6gHFl7rv5KojE9vvDjon/AF3rxV4MH/4R3q7Zn5tIn/803wjGlMa0iJMhGuVxBwHnEsreD9rvCwoUrkTxfHS917pvhsp/NY73vSp3ECalwlyuOfFQcpchAbUlBJFRohjDIh4f/DH6fzjNHa4B3RU4pNHkzZrhLU8bELpenW52+FaFb3Dmpxy0SJEgX9aHB0VvZxYawftxdJiUHXvoO9zHpg0pJbEfxoZ970GskQ7NETKiw5KfQZkcME+K05KC5oolLdOZ3C3CJSOTbWhmFd7Oofr2SXFKIW6M0TN
 PH9AEn+U
 xeuvEA0AeNz2mOp4qhpMbqpYJqXHQ4KzIQGxsNqn7nyLpP2lKGxj7MshkNCm+ryOIKFNBpsJjIrVs5YhDG25tKoIl3Dw/gh8P6ckrpjijhc8tJkdMCrqvIFnUeGaP/mDiGmwfT28+nXfaWmgoOImsizESiYEPBZIOnCVryV2Oihp2wN9MqfJvzK1H8O+Y6e4rxdgzZKJOXTuVs+msE0cgoBgv719TV9GQKf4Pb/x19dJm5l69TnPdvVHuoozYwyKpI93nrJTlKL7LfV0KcZbaSLMWD7N5WBofWCcSbePYuvpUF7HAr/X38fqYVm8G//OG2vWL1X4FFIGVL7R9zjG8r9tRGrMtt0c3GqPe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize fusectl as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. fusectl never holds executables or
device nodes.

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/fuse/control.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index 21ffde596d611..4497362e7df06 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -10,6 +10,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/namei.h>
 
 #define FUSE_CTL_SUPER_MAGIC 0x65735543
@@ -334,6 +335,7 @@ static const struct fs_context_operations fuse_ctl_context_ops = {
 
 static int fuse_ctl_init_fs_context(struct fs_context *fsc)
 {
+	fc_init_pseudo(fsc);
 	fsc->ops = &fuse_ctl_context_ops;
 	return 0;
 }

-- 
2.53.0


