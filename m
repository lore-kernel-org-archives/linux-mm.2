Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1384606A91D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KN56aSxE
Received: by kanga.kvack.org (Postfix)
	id D48486B05CF; Tue, 10 Nov 2026 04:17:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1F996B05D1; Tue, 10 Nov 2026 04:17:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C36536B05D2; Tue, 10 Nov 2026 04:17:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A00546B05CF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:17:56 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3FA451401F3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:17:56 +0000 (UTC)
X-FDA: 85418657352.06.0741983
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 898CF40002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:17:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KN56aSxE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V5BWJw5fa84POo80x3ibKreEFrHi8L/+0M4nKiAomaU=;
	b=GeaD7YLw1pHIKBtyah1tS1CG6Qlb6yq3SAiFLdspczcC/1cz8khACY4A3geTl5YihaLFd1
	rcdW3CNdvC2jc3x1B6rfAIrwCLxe61A/gatkbSTeuMusRnGIDSo4W3Fic225Lb+gnHTdc+
	Wl+YMlrCOoHVkvDJ+x+zIAgo1fq0bBQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302274;
	b=Vo9plmZGMVBAIwieyCNCgCvJZocsBGBRnnMIwK0N0KIUl++6SDSe+XGqbDFV8csAE4eEIo
	Xge/XfB/6ZvEHhN9I6l3o+iSiu8hDhq7SZ9BKRgajhnPhCAnvipNftk0JQw5SE4F4gVlkA
	0jBkuM1rljlMPpk/437vRC1UVjbSERk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KN56aSxE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DB08A4359C;
	Tue, 10 Nov 2026 09:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58BC01F0089F;
	Tue, 10 Nov 2026 09:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302273;
	bh=V5BWJw5fa84POo80x3ibKreEFrHi8L/+0M4nKiAomaU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KN56aSxEcIL4HezFtJpqamXDQkWCizrnZgnkUMIpPJsU7rRuUGbPuKCmoeZKs9Z8T
	 KX8yIwO5M/hIAuohYYoYuaalWbYYVGCWyj3OPI2eTlBmHabq5gQXT0Q9S0rZ4F3ut5
	 C4zEnhc+UMJ2cgIQGGeaEL+qrQxNqtC4KAdzr1uwPXxDiu2A5V9MYGtecJfiijcWEU
	 2ZNMp5ydhnhMaivDafrR5m7QBhsQux+h3Tx/1FbSjFTpvpg7tD2QL9hYdoAqvzBL6y
	 XALD9so6bBSasGgjOreqMXh2TJ7gKHcAOMhp27y+3npGTFNV3GX8PCI5KY5SzKdsrT
	 HZkVBu2EyzxNA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:33 +0100
Subject: [PATCH RFC 17/41] securityfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-17-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1036; i=brauner@kernel.org;
 h=from:subject:message-id; bh=MwHP9YE6cjEfGAuH1dNASl/A50wevLh7f7bfLWi2WsQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erD8krTE09Ofz2cIRrPJrvxZXfW5i2mz60HLaz3/t
 aacvaGV01HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjAR0ceMDF3dd12/pYZrKTE8
 Ycgt3jlH/vK/wh9r1zpfPu+pqC78O4rhJ+MXzsV8icqCDBsCp8j+vcN8x+XyLeYvblvbTnJ6hSb
 MZgMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: ipba9n9ygrpeuzw55s7sge5eu683pnnw
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 898CF40002
X-HE-Tag: 1794302274-862665
X-HE-Meta: U2FsdGVkX1+/Dz0ha60vNnWJhUd6a6X2pGOion4/pUpQtNUB8T2n2f40H+nfnnUjMVSC/kSMUnoaivRW60swJU8xAXuLomwSVJgAUwJkj3BKJKp1ZxyZdw7TwYrAXdlPwF0X3LYeWSGaO7ZJDbKLuWiqs6Cop/D4oHq//ZmFxWwrcjiSYmBumXhZdK/d4v7bYeR0N5UpR0vHEbjKfbdvWBeic0+uyNJPNxm2n8WO14lU4jKIDUP8oW0yn+qJi57aI8W7Hn3Pu3TuUFeXvE2/49BEdwTsI4oDUuKTJmu8C9dhpbY4S17Hgl/spm+Vhn2vqZqUSEjRpuu5xd2YEyJaCfuSWZJBCg0ftTgiLYDE0Xs68N26kaxl6aOPeukjfmXKs2nw6/pcwgkQSOlHYPSrXKVoi0r5BWJhM9Mo63n/C/gR2mxeVQwrtzw+YXMPjIdsFw2b/FU2qPXhD8husv8FuJX1YHqK4gDxfhhIMkvZQAozsCppmtgwWMVKX6RKjqqlboZwBzMYT1tubYlvWrQIoN6dYUpYgrWLF/WpP45C4obhdUDMUd5GEnhFeQJGgOZURP2LI72cajlnmyl+V90cyDksTSW9XYvhkJruOAnG11uxZU6WyJsB1VvacSFna88B8OIL3i/0uG95P4VFW40tjOmOthW3rUSA15E5qRFR5oobc0SW6mu6JwKLibwTXZbcwuIcZQmHM8uTP3q2DPI6IeeTUJ2S0soPBZTnxSyFksfperhBgWnv9GVekBD8vVdZfhqXjCkT7hqTfdQQD8As3kvlHr57YciB0ljIpJf+rlqUI9l9ITswqv+505MzcD6mL4zkmMjuoVi8kUZBVRPBAEAx3N//4vcO8Bu3jOb9R7HvmnUuBsLoOssLFzNVO1tSiheVV52Lvz9O0ObwTiT0sDOd/NNIz9+vJcx081ifrxwY8O/D6rDAn+wuNTiwCmfNqUVHF8IdBnmTkDlK9Wf
 9LQDgq/O
 aW9SB3WNJrJUz1Hlnh3pZJRCNBb0PoCKxjV7ywwyObdHrDCeyQX1JUSwmHfhBLYm7B/+8PZeyMLjV+m+EzHaJ5qgotPGeQ5QDOOh51y+rBzlBQK6ZpJJOAOrZUpFN+L4GOQbpPAtQCYUYu/0FFG01rmhnrqrSoeY56LtDqMIpHia0XYs3blTk5BRpnej0nNBrgHy/Q8WiZ03QpNIw+4SPHue+XTOHelNHDndHVK1Si/sAbkRw+g91egMl9yXDVefVrvq1Ut1cbNNSmMbm+YwrwtUpYJugi9WvFdYqHeSXcMEwKt3cdPGZ3uoqWqJKCgitHRNpIJpU6ycaH502VVuaptfCHGlZAOws5SuCm85iugRwiDU=
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

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/inode.c b/security/inode.c
index 080402367674..93997a9f16fc 100644
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


