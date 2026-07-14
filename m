Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8664AC4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 19:58:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24EB46B00D8; Tue, 14 Jul 2026 15:58:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D8406B00DE; Tue, 14 Jul 2026 15:58:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C8026B00E1; Tue, 14 Jul 2026 15:58:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C0FE06B00D8
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:58:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 43791140463
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:58:39 +0000 (UTC)
X-FDA: 84988444758.08.82AD01F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 707081C0002
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:58:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=em8WrnhE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784059117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fo19MEO4GrOIxZIeKD3bvDaVcJiR3ZionbZ5Jyq+iHQ=;
	b=XhtUD7MlBknRuOKnr+FiHuutvqC3u2GIrG/9/8aoUYse+GzNFrvPoW/4GyVLcu/Mbwq5o2
	lCY75mWZ026axPf22U2N/FgJpCT+Hzr2IdEZ6OaA9UJqnihZiOevjgs06e9a7ZY1tra7d2
	MH23DO0ZFqLa/2FHSSrnemiWv3xTbCw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=em8WrnhE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784059117;
	b=ti/3ZFybz9hb7vOiI7KIe4ypiFC+RbFtB5JIWtCvk5Q2IXK1oJCi1JwrstBURcJnhROJgp
	5l9JZ+QkLsRZZiVXWzGkWw5RGLVnY1BeXoJi1xqtaxGGB7yeuBuR7vCbjS0HApC7UGJ5ey
	X6eOmoOUCR26b82m9Mrd9QM95QQrLN8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BB55543BF9;
	Tue, 14 Jul 2026 19:58:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407C41F000E9;
	Tue, 14 Jul 2026 19:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784059116;
	bh=Fo19MEO4GrOIxZIeKD3bvDaVcJiR3ZionbZ5Jyq+iHQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=em8WrnhEufL1JxGqY2VL3S+mNr4kanxGWZiaMz5lg03ICE1MlAX+6LBWObE0hSZG2
	 uu/KRfUGPtX6Key8tin/0qFC29HbHAD6/s6lXsZ0jger5GzqFtKFkkjjSKvwbuR9O2
	 Q0sNfgld0yl08Mhope+YY7s4KK9kaR5Q4LOFrKyxyc3RnevZcHGfoGGlwiLDlbcjsZ
	 Thb0OpG0nZ9o9fUrBq+r2Zvccc6PiZ8+wR1PQJKqqv4yIasYM7ciMk57h7NCkn8sVu
	 gQZhlp1zW697aTIVXitTaRuQ7AR8g2xxjBfNUs+n5CzRCFgBrJNwj7QlIEx5uxbSVc
	 0w2zttvVHNODw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 14 Jul 2026 21:58:10 +0200
Subject: [PATCH v2 5/9] bpf: allow fs kfuncs for binfmt_misc_ops programs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-work-bpf-binfmt_misc-v2-5-57b7529c002c@kernel.org>
References: <20260714-work-bpf-binfmt_misc-v2-0-57b7529c002c@kernel.org>
In-Reply-To: <20260714-work-bpf-binfmt_misc-v2-0-57b7529c002c@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, bpf@vger.kernel.org, jannh@google.com, 
 mail@johnericson.me, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2872; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ccCpCBYwz2VmPn9yua5oVLq0KAr9/ocwzydcHJJZhq4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSFTbk8Q3bKSTHN7uVPiv/e+Ll0FfPSLVlyvIpWQpGsz
 499b8170VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRFbYMfwXPVXXut57cvWuN
 btH304ddOtJaty260M83Z2fB8SvetgcY/hcsuFq7qso85E5ukkDjkt4l/6fM3eq2pDVnUUamzxQ
 9Uy4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 707081C0002
X-Stat-Signature: zin1mxyfj4jufbf1gx1onjq4cgxe3xk7
X-HE-Tag: 1784059117-325188
X-HE-Meta: U2FsdGVkX18AYYPtUATfMhnvGreWTZlJefPijZpTSNtOg5mOHBc2oha/bUp8yaO3NGfyvpggfZ/jzAATLOyWWYE6K9lZ2gRP5rWupnz6NGiupO5b++P0uQiD7ATAXRYvXk8YnbUcDU2EZVAyRah/zvlHn9x0TFunqqRueYGh4Tat1fYnye391nAJAM90J/yYX/ghIZ9SGnJqMqIQbEGEJFKH9tlEj2bAHjw61p6Puf6hkjoT0cNHgvhd7GBIWOfQzSnvJ4xg0qiC+5pkqIDD/J/DdkSceCOxgvxENl6FuHuke1lRXlr5NjGb0ZdS+tf8LDrEqbHqPVooLVR+bqjcZvkTEhr3+uxwtvVF4j9LdOPvLeQvO90+0flr4FExE7pRfWgo0g0CDAzmUh8gxCIE//HPLVJexgRndek+aFt1tu7YnM4xkElgkwbaeOMOX0hmZDYQOjo3bq2CGHcNwRfqbwSiknx1raGfRnyA5cqEYaBOFNfHnoLpfOEvudhRubxjgAsFZLckPoKLRJyJM0828rqLEoG+52Bou73XX7uukcWV4xVFOwdqsc8/u77G5d0gXyL2Esg00I0Oct8pY6LSJg+GUKBJ54IdPB8N83OXf62S5cbP7uEgXCadWmhkrpGPtpTO4bE0wAdVDTxc709s0cDD7Sf7Ynp1aUFyjeUzHtQN9wwSUACUnkgLIaEEB1VEqdUhH+pDZ7K5xqaq6lkRQFVFQZFn//tAn6uAqr/OvxAH1x+axdEOKeI9LccLH0dDFMel9YgRJ4ATiZA84Fin4RSId6rlKDuCarbx7RG1I9Ybb65vwtXeZnNn/23IPtZ/xcGtAjXctJzg0Krrzjs9SHxN0Oaozzdkl95Gyx3Nwptd/GEiwI85Z7R13PEZHCwF3ap1QixgM/rIoKzfzbhLOEOg+uSpC8hrKpN9mLH/ByxHTBy5XoB6LXRCYZhKScY9F7we8SWziSiqIsPk5Qo
 yaz1h/VN
 Rbb5OpArHFRi2hLmm1zyBbN05rz8H9YTo01bUNuaalN1kBsjRsWo3ICzNLGvZMkin703CzYyDhpjFeDzX7AlAz2yxAxY3mx4wbuT6flWP5ZslTme2u6fET6ufzMNVHbRNanD2IvM9ODSljAwuxWl/6iCVqSHyRe24yw0R0TfPMHN+MyCVjh0+1JW5j+6aZMv9GODfq4QvYorVnGgyg73uWghoNafH+tog2JQWBtlPfPgZscYumyhbmPQyOFkTfuPD26FlW5CT8XP/npghluMejxfhDZIb7hZNuQqLlgBVnLnkf9ZRjq+JUVqTlYr0TVUZURG1gHBpa/w8+y7cmkNrkl6Oa71bKheXsoLavoQLOMR0j6u6rmFQarcwg+/ZufvAEbcixCOfAsIyo0c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The fs kfuncs are currently exclusive to LSM programs. A binfmt_misc
handler needs a subset of them to do anything interesting: computing an
interpreter relative to the binary's location wants bpf_path_d_path()
on bprm->file->f_path from the load program, and matching on per-binary
metadata wants bpf_get_file_xattr() and friends right from the match
program.

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


