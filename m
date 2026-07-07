Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95753C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 19:37:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 982F86B00A1; Tue,  7 Jul 2026 15:37:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9354D6B00A2; Tue,  7 Jul 2026 15:37:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761626B00A3; Tue,  7 Jul 2026 15:37:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F3796B00A1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:37:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B9E03168F2D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:37:22 +0000 (UTC)
X-FDA: 84962989524.29.5AD0AA2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id EB6D2C000C
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:37:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n1YSoy+L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783453041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NdXDOxsyu1F5h/+GeY4wpi+0FA2AfuOSIvwjDrH3T+E=;
	b=Y5KHzNLr2GaFAc3i7IhY5VfdnguutQaYN8FRJygPdqCKwdFb5alyzkzVi1xU19Wrec85Xz
	l2T3Ir9VKNADI90dEJZ8V6fM59KHyqDdPm5drqiqxdOqlA7uhHzT5cKFoRK5Ii3w9pXrf+
	kP16/swc0BRe9heceaj4JpHrn5w100Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n1YSoy+L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783453041;
	b=PX6+n+WAjgWrxkELzRZ77TMP2VUvkucppejYZYUsNmAmuzT2hMS6/zsEPiuAVeKHPzIktA
	RwJ8exr3wAPRXXb+UfHjVucy4mB4n+3XdWtd4C8u+2PvPJhJcEOFgMgGEtKRrxGjSj3Ary
	QbmcvZd0DyQRvGUsV7ASUgwnQTztrgE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 49DBA43BD6;
	Tue,  7 Jul 2026 19:37:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A5E1F000E9;
	Tue,  7 Jul 2026 19:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783453040;
	bh=NdXDOxsyu1F5h/+GeY4wpi+0FA2AfuOSIvwjDrH3T+E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=n1YSoy+L4RPfRGgqyLgaXdMaChn1+sLhk+EF1OhoEwNObgYeL1tLyQdph1MituyWF
	 3r0fhnPd+kgIDIoqVlJt6XHQO1xRJWhK05klTcaRJ5oEwFZ3Q/e+w4MFxw9E5aEqjx
	 SV4bbiQR+AKNKQjqnC6Ao0aPZowcBVeFkowrGfiZVCez0XyvL3Er3WmXUJMTZ2N8j9
	 rfNdNZj3q7/9cyZHjpM/HUAFGcsOba2M7whbD1Vlwi/6C29FmJHIcCeNNjr5m4kowK
	 qHPoa8lfH2YoriIMQLQ1jhiy0c2LYdx6gh03u6blKwV/ocU68+tMhCTi5+9+D6Okbu
	 j/GIRykCsgwlw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 07 Jul 2026 21:36:48 +0200
Subject: [PATCH RFC POC 4/4] bpf: allow fs kfuncs for binfmt_misc_ops
 programs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260707-work-bpf-binfmt_misc-v1-4-74b995c84ec1@kernel.org>
References: <20260707-work-bpf-binfmt_misc-v1-0-74b995c84ec1@kernel.org>
In-Reply-To: <20260707-work-bpf-binfmt_misc-v1-0-74b995c84ec1@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 jannh@google.com, linux-mm@kvack.org, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2829; i=brauner@kernel.org;
 h=from:subject:message-id; bh=WrSENH+5tMwx8U3a+mcJ71xVE4chcPlq2GvrRcLbaCc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT5hiZ0V0S6GO/pEbObbcBiabC0pke2++Z9xmeeV3t6H
 pvliHB2lLIwiHExyIopsji0m4TLLeep2GyUqQEzh5UJZAgDF6cATKRwNiPD7vlldy336y+90aCy
 p21d6d2Opo1MF8T/uIbqCN/qXzzxG8P/xC3blbKfKf9asil6n/nyUwcZleZeenVxvtCJ1R1zXfZ
 rcgAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: s3ugijcuqnw37df9iq6zhu44ac7zjnb6
X-Rspamd-Queue-Id: EB6D2C000C
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783453040-403365
X-HE-Meta: U2FsdGVkX1/GiwliNBxxuuXapZNfemx2t/3b2Fcey3hMlyCv3A+++0r/VkJqF3LLg9sDL6YM6Lfvbqe76/BoA1ykrjUNS+fn75uMJM+W+VqN5wWXtJvQ4CQN2TGsOxzNNrroB+c0nBpgpkypyyY4pZDrKdC3JkMq/m4ItfFySb7h5H367l3HBpkRhiC6V3Lk2/wvi2NiTGnk/kcXT1dnTS72Gk8J35c4Obkx8Bcg97BNfsHE5doPnDbXZzeIK8e5MiL/8pjR2RGNTw+l/SvsOXE+360pmmGrob4Ez9Tjhl+XVHRs/8B9NkeimPGU9V3KiVhKiWvEtB8lS19cSEYfxo/7H/n4zO2RGd9Bve2wEUBi0OkyGWqEtq7I31dPn+SnzHt0KUnhLw2+65F8Haj7DdmhynobNOzFe6CrsOa1sFcJ0Wwya2WpbBgsMc5PZ1mnR6Ra7hPevLKd1FTkETsnNEqFUcXGgXsXliwOWvkBpRXGfEtbztWJgcrODirUr9FJn4eMh+S7S8zv+UfoDEf5EQcYnEgBZ5Arzln6kariuvVMxKqLj1ron/+WbJESVof77uBk1jmfBnidQV99ZJ4DCA2PhVKiX8HO6JXyX0GdzNsiXVCSP10ciZQGJLKJwMrcGxNS1tXntRNjBBS1b6XdoyGCyX6PSgRG4jsf1qGWV25OP0fcZUuTqR3yfGvFjNXQSGzKTioB2ulCnNBe7qYEapxqZa1LDDOlbj49RZh0MKqzOftgVtOR/UIsBtZmTYBw5j7I541flYXMszGn9ntz5Vrw5TUbe6siHceshKZiQkHcmOZI+vPoYWRiDi/MCBTLurutMPcSRYTorA8DZAHNewnlxz5vzysQ4JLoOx4IXzzJQsMMhfTyRT6QsGQaFKk7zhhCD+wrzUvsrCvrqg7ITnPKGWxYfsIZi52fThYpDT+yhybJt92pPR4Lcz4Kaag778Affxer+aI63izjvgy
 Vcm7XgQu
 Hj3+wBZaV/ayBIEB4jUbfUEgcs+29QRek0q7qDAiavUIJh8gfCib0wgMVlXkBuS+vt86psORzcXpdjLHjC7iqsdi/6UTiGSR5g7M5KmHk2dgU0d98xeX4Nv4DGiJMMH2CXd57NutAZ4JEH0eTfbkVNPqo91JZmaUbbqKEDA+7Y3/CoINltgeteaY2um07fk48aqH/XxoU8hfzmydPcFRWB6z4JkGGd+NpLcNF1MH3cztBwLzMHhlChOkJ9oNxNGHlPk4Ge+9xwrTuc4UI3P0ozYtZk45vMT4Yr7e4FWwe2rA7zaywmlBzdDnfvhzwNJJoynG0QyRxHbiG9fD3d+Vl1b3vk+XXrhVLGbsiaZhcOHG4hf5cBGMrE5aZ6ZpjUArDWS9MzPEDLf3xnqA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The fs kfuncs are currently exclusive to LSM programs. A binfmt_misc
load program needs a subset of them to do anything interesting: to
compute an interpreter relative to the binary's location it wants
bpf_path_d_path() on bprm->file->f_path, and matching on per-binary
metadata wants bpf_get_file_xattr() and friends.

Register the fs kfunc set for struct_ops programs as well and extend
the filter to admit binfmt_misc_ops programs. The xattr setters stay
exclusive to LSM programs: a binary type handler decides how to run a
binary, it has no business modifying filesystem state.

This only takes effect in builds that have the fs kfunc set at all,
i.e. CONFIG_BPF_LSM. Without it a binfmt_misc handler is limited to
bprm fields and the file-backed dynptr, which are provided by the
common kfunc set.

Link: https://lore.kernel.org/20260704211409.1978485-1-farid.m.zakaria@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/bpf_fs_kfuncs.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/bpf_fs_kfuncs.c b/fs/bpf_fs_kfuncs.c
index 768aca2dc0f0..aa1fe988b6d2 100644
--- a/fs/bpf_fs_kfuncs.c
+++ b/fs/bpf_fs_kfuncs.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2024 Google LLC. */
 
+#include <linux/binfmt_misc.h>
 #include <linux/bpf.h>
 #include <linux/bpf_lsm.h>
 #include <linux/btf.h>
@@ -387,10 +388,20 @@ BTF_ID_FLAGS(func, bpf_remove_dentry_xattr, KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_real_inode, KF_SLEEPABLE | KF_RET_NULL)
 BTF_KFUNCS_END(bpf_fs_kfunc_set_ids)
 
+/* Side-effecting kfuncs that stay exclusive to LSM programs. */
+BTF_SET_START(bpf_fs_kfunc_lsm_only_ids)
+BTF_ID(func, bpf_set_dentry_xattr)
+BTF_ID(func, bpf_remove_dentry_xattr)
+BTF_SET_END(bpf_fs_kfunc_lsm_only_ids)
+
 static int bpf_fs_kfuncs_filter(const struct bpf_prog *prog, u32 kfunc_id)
 {
-	if (!btf_id_set8_contains(&bpf_fs_kfunc_set_ids, kfunc_id) ||
-	    prog->type == BPF_PROG_TYPE_LSM)
+	if (!btf_id_set8_contains(&bpf_fs_kfunc_set_ids, kfunc_id))
+		return 0;
+	if (prog->type == BPF_PROG_TYPE_LSM)
+		return 0;
+	if (bpf_prog_is_binfmt_misc_ops(prog) &&
+	    !btf_id_set_contains(&bpf_fs_kfunc_lsm_only_ids, kfunc_id))
 		return 0;
 	return -EACCES;
 }
@@ -433,7 +444,13 @@ static const struct btf_kfunc_id_set bpf_fs_kfunc_set = {
 
 static int __init bpf_fs_kfuncs_init(void)
 {
-	return register_btf_kfunc_id_set(BPF_PROG_TYPE_LSM, &bpf_fs_kfunc_set);
+	int ret;
+
+	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_LSM, &bpf_fs_kfunc_set);
+	if (ret || !IS_ENABLED(CONFIG_BINFMT_MISC_BPF))
+		return ret;
+	return register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS,
+					 &bpf_fs_kfunc_set);
 }
 
 late_initcall(bpf_fs_kfuncs_init);

-- 
2.53.0


