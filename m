Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D50EC43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 04:09:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC6EF6B009D; Sun, 12 Jul 2026 00:08:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9D066B009E; Sun, 12 Jul 2026 00:08:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C17546B00A0; Sun, 12 Jul 2026 00:08:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 90E9A6B009D
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 00:08:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1637A07F2
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 04:08:58 +0000 (UTC)
X-FDA: 84978793956.11.73128E1
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id 21FCD100002
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 04:08:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Pf3WaA2a;
	spf=pass (imf14.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783829337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QOcBwZZCQda0ksnOyTTPJoQylHUy+3FzULiJTSWI84w=;
	b=uXIOK8oGxi77Gk9dGuFQOJ7xrLTU52rhiPcYAOOyIOV83Da+jEOmsdOkriU8+upXQMvmY1
	jwBJpEEYHG2GBIMvfVz1I2A8290K+G9GRx/USNJp/eW2tfoGw+riR74ubnCneb9GUIFkzF
	eZ2YGwVopsfuusD8rSZXSO887vOG0b4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Pf3WaA2a;
	spf=pass (imf14.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783829337;
	b=XYckm+KTHQOcmG6VxQGuAfxCc/NG7UhyvtI48K4WlfwrQEPN/+0u0tf66+enHaU9Qqx98L
	dnkWsxaL0NwlzvciPUQbvQQgTvxJehhlEEj2widoiiPrqzW5tayuGN/NVdPiTneDftZ8qX
	9QYK7fkX6w6NA+2tGH/Uwm8rIuNA81c=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-383b4a3755fso2042590a91.3
        for <linux-mm@kvack.org>; Sat, 11 Jul 2026 21:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783829336; x=1784434136; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QOcBwZZCQda0ksnOyTTPJoQylHUy+3FzULiJTSWI84w=;
        b=Pf3WaA2aX6qR9C+AwesTXLinKmTezbC4CPPPldpzcnSRC6k99x12mEJSNoKKO09pQk
         4IUzlQ9TRxGaPaVkFIMq0o45QXuRFbtEuQZz534KQEoxfpJ1buduMWuJBB/C+nfS5Yg/
         B0PfrhZj4808a5dpl9dlctr4JEPtfa65E0aPmEJJCKU74MOVCbCMgGQHqOB9CH0Im1tI
         yydTVy4n4wfOxVa6lBWCwFlA3EZK6jWx/GFWgwxwvS7HciBFgeX9j3VLdn1AjkTSf4y8
         3HqUcgX/vkhXQSk4m/SyQ5TPH63qQh+sDlq9lgndlte/IyaA0okDVb1iqySTXRsMw5wJ
         I8RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783829336; x=1784434136;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QOcBwZZCQda0ksnOyTTPJoQylHUy+3FzULiJTSWI84w=;
        b=Mr/gDfKMqibQ6B5J1kKArMNW9MCbK4NI9o//jFGGGrOzaJ69qX73p6l6TFqyaSTijK
         Mz9SjRvOiyy+AnYMWCalcvJrPrZvBdYhmK3PzDtGmRcWirXouj0pKPKCKkJz+pcc4a9B
         ruFmY5yVd2tT6Ia3rq/u/bVLk1lMMAY+IchlhvUtNJUQdWBHgtQW5sedLQRoPXXkJAxW
         AquROmJPcirf7x9urOYLAjyAaq9Z9mTtjFS/+c/GpH7NosOcFF5bvjbjWpdHCcGd+97W
         KMuEUSCu1+tznia1z+tKWntMs6oxj2tbeDbRZBe371DzvSrJ/rWnOZNj27SpzT5tahA8
         mvhQ==
X-Forwarded-Encrypted: i=1; AHgh+RownTdwVlXgnKIYUc5IW58qcbfLiJ1GvnpiinCigq/XOMRRpYL6R/xuR6eOt1JFcRxXwF0D4vwNZQ==@kvack.org
X-Gm-Message-State: AOJu0YzSwmU+rQi3tn0ym0WWDisetG8xxvHfTGyQXvjXBMbFGbfjZ0ir
	K1gFifEm06X4hfsmSsT4mSbg0Z814Zto1c5N3PPIB33k/TfOSjZRwlxQ
X-Gm-Gg: AfdE7ckqW2a2WMJBCGGbF2r/OMo4unoJi1e1QgEexfFi/lUD3409Ge82gHfwmyKCuZ7
	VK5Ac5ZtXVB9YLow1o0lXjF50Lg1sAZ+Nc54AcwMtI4oBR0A4mJSnfOtcZrOe+CHX6FEu4fdzhc
	NSaa2o2ZMvb5zDBMzsZ+ToetK8UsbXSKZmu5RaTtcvV+ucv6hIXHrZXa85Mmelxx/iELXKi8aBf
	9LabnfK3+AWAQzyEI/ayyFDkbQ1BrIEBDWfZlzt8Ml/I3/ausAtRqetT9dsY50jiofI1GeGz5xi
	liJnhkyczlfUDP5clv6jae0R+WwFBYnU8463oTjfUK7EpXiLh+fmWPZFR0eTIcD2VfJ2jH8guYD
	mgzBZuHiL72a+jcRD75fqYl8IdJgupKnO+Qdi7GBH6oCraAOxz4ZJY64TZ+EWdqqlIBqD2HrPKA
	gitXaeWp0eI6e7DpuT
X-Received: by 2002:a17:90b:39ad:b0:381:abcc:c8e9 with SMTP id 98e67ed59e1d1-38dc73bcfecmr4632607a91.7.1783829335997;
        Sat, 11 Jul 2026 21:08:55 -0700 (PDT)
Received: from [127.0.0.2] ([98.35.8.117])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31174839f89sm56808928eec.10.2026.07.11.21.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 21:08:55 -0700 (PDT)
From: Farid Zakaria <farid.m.zakaria@gmail.com>
Date: Sat, 11 Jul 2026 21:08:17 -0700
Subject: [PATCH v2 4/5] bpf: allow fs kfuncs for binfmt_misc_ops programs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260711-binfmt-misc-bpf-v2-v2-4-d6591ceaf207@gmail.com>
References: <20260711-binfmt-misc-bpf-v2-v2-0-d6591ceaf207@gmail.com>
In-Reply-To: <20260711-binfmt-misc-bpf-v2-v2-0-d6591ceaf207@gmail.com>
To: Christian Brauner <brauner@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Shuah Khan <shuah@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, Jann Horn <jannh@google.com>, 
 John Ericson <mail@johnericson.me>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Farid Zakaria <farid.m.zakaria@gmail.com>
X-Mailer: b4 0.14.3
X-Stat-Signature: s9uu9cqxeo4xcbx43urihbxc3a4xx1ti
X-Rspamd-Queue-Id: 21FCD100002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783829337-568746
X-HE-Meta: U2FsdGVkX18BT9Q2NO/2nHICsohzpElH0dHklemtdIFcOcGAKOjLBiUmQ7r6QnQv0AiBGbt1bn0OuQpxTd0iIjt2yGHIC2q36YFd8jcvapXS2PWJo2wW0AxJ7i1i1T1AgAG7Ra28iCoRc4nFL3uIzoJt+DHJBDJ07ixWzQso74+7Ug+/pkOUpceucR7aWsVqr3siL732eYa3eoa6+tXRAMB8XMwy7Riv+DkPDxBE11GuioLYvt1tOcxtBpmonU9FCm7ry5h6DVM8ZwB+xqrKQdFd7Q9YojGvyyxfZb3f3PP0vq5S0Vsd7rC0mMTBcpOzMdrjK9yts6y5RV6NBATCgQG8T24oHomP1BxviM1/ipnzFuKxCvtZYhW/LYadqxzvG44ByV2Y1SV99PCtza+kYl0WoOGpFwOsXToRTlwwmmQ+A6iuil/2uXYpE+zPpcS2M08cJ2dEDvNbqlwh4e4rWQbsgWORxzCiCQ6o3zn0MzgR0rhILmDsuCn+vLFEW4OjTDDqmuRxQIAoaoLOXDAayYuZLT2cJWvccbrm6dPJHiHxymt9oCe1jL/uviHXi+ZjbkNL8QjDiBGaaIwnuMWKzNROQ2x6TCXjVPi+cn+/zzTcrCACloDj4kpPcWR9dRg9z/pCqKNpLq76cSdR1ExhUEl8oLb+WysaY50uoJEBlrEY1sN427yyBi65jXgUTCim/hSrA6p85UowkSLxh4J3yK6/reA6tEHXRVLdPr1pTt+GHrbrCkPKA9Vfi0OZG+UPA+CZG/PKpuGT55ysBpc1s8sp25nKALoqeMmWGmIO6/CRZWbbjRAz3SCeY+HU177lJt+ri3JpZ00Z3zuvNoQkG4zf0GWSxVn6U5IdrgjhzQNXeQf6TWpiZbL56brLlY3ItM+KCMJDUJoEqlzuAY2SOyWa2hO+VkGIvLvB1TlTrjxajllFkjaDOG0VPdSRYjeHdB58/QHTKgyG5uezFT3
 AVRtX0Gh
 To9xkBCcdi/5rAc+sxuMCGOJ0D+ubIV6qC1A/TB/aLgjUmudl7S6N5Fh4uKMKL8koy+PcY7Fjf7ihFahb6LOeBsqxepv40qID9wmyd0lY3C2lP5pefkpoxjpmE+xcLb19eu8uboQnvA1kW7f8WXV2qMWQxBKWK3gYMKXO0PtOKytpLk4WVIi7aOh11UAggoGSye79fIzOU7e58/linT8o5p7MX3bX0Uay19dv/iw+i639KOe32eRYNSJAsPcJdnNNzKfRBnPrwh0K3WqTvfQbDYaQ9UV+HdeGJBDqtPoaUogmah/1KJNYfJ632fPbKjPB03EycO86ulMDHxniKHBpPvVMBPBCFapmyPIHSHUb9QUiv1nrWrMguwGCSkTitIhPePGon8+YlrCoNFEOI/5T1fP/qKE3oJFaZDM7JoBHUIXAhqzpuHKkBX3kNb0Pz8aBm8y8KebHUJZehzWTMrNoFB5g0uvGgR0ryg9gq983oistLxY/G1jqbwK8DiDw666ZP2lLT3+6zTt/YNXBjZFHmkz4073hvxyME/7/UYpbByvBTXLwJwEQ1G3qDMgFFQuBiX8O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Christian Brauner <brauner@kernel.org>

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
index 768aca2dc..aa1fe988b 100644
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
2.51.2


