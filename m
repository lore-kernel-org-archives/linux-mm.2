Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91D11C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:35:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACED06B00DE; Mon, 20 Jul 2026 05:35:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A07D06B00DF; Mon, 20 Jul 2026 05:35:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80BCC6B00E0; Mon, 20 Jul 2026 05:35:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 431276B00DE
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:35:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D2A1D807DA
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:35:02 +0000 (UTC)
X-FDA: 85008646044.06.6B9F5B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 27331C0012
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:35:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PFpa0F5/";
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784540101;
	b=p1A6J3M+G+YW0IfcWmjSGI4ttDg3Vh6C8WF/bgUrdkF/TPO64FHlAO/q7jwUEmD7TQDkcc
	Sjk+PWAWVyW3jxA9isFGHPVCipLh+2ZYZDH67O+Wy+DbJwc4+iJ3QXwnnXzF5EXtfKz8b7
	cmR5NO8AJgjoP928qCY/UWy7DxBMVJs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PFpa0F5/";
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784540101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HynziS7CVaLQmLs1bVJl54Y4DOs2g3hrDdx+YCwmeqM=;
	b=GsPABHLDdI71fZ5oJbz9JJiz2Jti608Vyo2ghF0RNtcG8xsy9ZR0xX4D2tn446vbybJN/W
	oHfEYGL3k/fLgnrX9vneW7vd5dO8rWnt0KZqGpr8dX+g78ZslWtOx8uF0/vm3WF9PtAczJ
	rP5ME0vOoM3OkR50aunFdrrWOQZWL+U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B848F60103;
	Mon, 20 Jul 2026 09:35:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB64B1F000E9;
	Mon, 20 Jul 2026 09:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784540100;
	bh=HynziS7CVaLQmLs1bVJl54Y4DOs2g3hrDdx+YCwmeqM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PFpa0F5/CB/QfH5q/uNDOfoOoOzibT7pPTXuumMezjfn6sd6r0JQCPQKZ6JaMInV2
	 buQ5YXOW15E0XLhGZyW+MP/0ApTUacgjJpls9U5Vkt9su2DdAgxksjUdw3piNY9+hh
	 Di/Ky3I33PgNtgs8GlTYmF6xiJf/dWCSk9IG3cRNRrXAXKs7niTAff/9FN0i9vLbSY
	 RewBIMo+0HjhY3ovkLbpmwLMY+d0jZv+U/iKGD86KC5u9qbKARyfLb9XqYXPZ/uyHZ
	 ZA1aZ3fi04R8BkvtH2I6GD/19oY4dZqCRfsF9PupMLs47BOnBmeVcxyTnM9+IlLlBK
	 p42GkyFAi74pQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 20 Jul 2026 11:33:42 +0200
Subject: [PATCH 19/21] binfmt_misc: let a bpf handler request loader
 substitution
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-work-bpf-binfmt_misc-ptinterp-v1-19-ddb76c9a508e@kernel.org>
References: <20260720-work-bpf-binfmt_misc-ptinterp-v1-0-ddb76c9a508e@kernel.org>
In-Reply-To: <20260720-work-bpf-binfmt_misc-ptinterp-v1-0-ddb76c9a508e@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 linux-fsdevel@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=4971; i=brauner@kernel.org;
 h=from:subject:message-id; bh=fpnyYgaduuYcnmiRWrnp5KJACtxZzgRt5ZnDAdYlXgc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTFvm5+sZpFsep1jzCna/vkdzcPi7zepCierb7ux+nZe
 9RN9jV3d5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzkwS6Gf7Z3fvjPrO7e06yh
 c3zj8SNP/KY/VfeWXM5ufenYnTOS2jGMDFeOHZix4xdTE8/X5ElpV+b0XZvpmrslupbn/7/tK3Z
 aBbACAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 27331C0012
X-Stat-Signature: gdkxe1eoahwok4a8hzf1nmcb351qf8f5
X-HE-Tag: 1784540100-455605
X-HE-Meta: U2FsdGVkX1//utg+BHx/quSWRKCbY0jnj9rIjW8IoczeIST4sTIJAjdxr5q/SPXyLQuOQIykx5smL1DHT6VXLkxDMI6deMkvuJuyO4OI0Rc76nLvDOIe5TJXGS4nPWI270Gvqr9Bf3pKH4+2E95BRBAvEWlbvQW4V21z5fYSHbHKXv/GkaDCGsVWFFGi+s2NLp2qs4Sk6ZtLLKk8ohF+78uHROtlUDzLEa/BwtRG0o28BkrdS63mcyDpRZroU9vK3oM/TzbO5G9biOoIiZeAlXzh8EBG/Eij4FhssMWWakksNnBp37G2X03l+WlRc60V5mlY/IpwDPxd6aZu39ZfU1DCm80J1cvewKZKrhmFw5inbLIcSpo9TYYCytZXX+99/ZNJJY9dJcTmmISPGIWpustBya4CRBYPgj/0cJlufLLuVAnCVYU3shnjBEhiAZwYaDbxZLOTLNDXpEOMF6IRXA/QEiwyAUnq8S0lSiCAh9V4TuF0Vla9F9oAvxpDwC5zvwhN13x/5ulNHPiAd3ZD27JYo52I5xmJjNLSsC8SZFxygYWXsgRVBUT0Fz/TS5gJcORhsjYsiVKFGSG7UP+Mvzr+dv89KX+0DDRmOw+jqiPaJjwtpDuCZsZI/LAamqVJmUleXu1UWagBAnlBtmZxi6ir5LGGeFdvJ8N4Hg+OwFoe8zRJ50DsE7/cI2nlKzguxtlV7zy1tNeDYpQ7C0D2Od578M7wJQNTSTNvG63CJdX4aqSBHlLjsvQLkyz2yDBSmm7ctxxAgUvhPU6kH/6r+cRmtzZbtcx7noJlnHpHtFMAy8DJS61kz6lXz+Zl2vUND7kNNPmjIIixs0zkCCm1C+oN/goWSvJfsePjGHOtSulJOGAV99XWYMeXZfNFwOCsekmFo3ElZ0WcVpNm/PDtIh/f0GhG1I71Sn92N5N8PvIkjW3k2CcMDds8bwtpC5sdAayGaSFPy7V7qMb5IDw
 neu8Mhk9
 W/yL979HKsX5GNti1EpgejnwDBL70/SrVNmKhsDJ3/0xjBSc0cupOtraxGnhdgwjUo4e6oI154QJ6fbxAVftYMn4pp3eUmFJpRhlUTW4JampbHoFGBOvSNEl6No+1RbIsGzP5jCT1JTEpXGODsifzl9VItp+pd2yuYjVvGCAs/2G0lq3LYhqXOckgbZK4L7Xmgb3Fj7ZYkGAiN56nM9AOTgrYm3c83T8kmpvlghiy9N7Ia5UG4pFtyqanfAFOEGb1YSJXCUTbeBrVW7QUGmFjNPnfoM3X0E5aExdQ7y9OTIuh1GyeQOxawqXTNJkFiB2eDkGOn74Vu5eScvKSgc6wzPxpYnY08W8Bn0zuz2vL5gT20w2ukq5fciWbSj47fktjGrWnb9t1WUeImgk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Give bpf handlers the per-exec equivalent of the static 'L' flag. A
load program that sets BPF_BINPRM_LOADER has its selected interpreter
substituted for the binary's PT_INTERP instead of run with the binary
as payload. The binary otherwise executes as a fully native exec.

A single handler can now grade its dispatch per binary: native-arch ELF
with PT_INTERP gets loader substitution for full native identity.
Anything else, such as foreign arch, static, non-ELF can use transparent
or classic dispatch. The load program can read the binary's ELF header
from bprm->buf to make that call.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/admin-guide/binfmt-misc.rst |  3 +++
 fs/binfmt_misc.c                          |  2 ++
 fs/binfmt_misc_bpf.c                      | 13 ++++++++++---
 include/linux/binfmt_misc.h               |  4 ++++
 4 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/binfmt-misc.rst b/Documentation/admin-guide/binfmt-misc.rst
index 0946ca1923f2..8c861bf0c56c 100644
--- a/Documentation/admin-guide/binfmt-misc.rst
+++ b/Documentation/admin-guide/binfmt-misc.rst
@@ -208,6 +208,9 @@ decide them differently for each binary it handles:
   run a binary passed as an inaccessible ``O_CLOEXEC`` file descriptor to
   ``execveat()``, which a path-splicing dispatch cannot: the interpreter
   has no path by which to open it.
+- ``BPF_BINPRM_LOADER`` substitutes the interpreter for the binary's
+  ``PT_INTERP`` and runs the binary as a fully native exec (the ``L``
+  flag). It excludes the other flags and a staged interpreter argument.
 
 Because these are program choices, a ``B`` entry carries no flags in the
 register string; ``F`` (pre-open a fixed interpreter) has no meaning for it.
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index ee48dab2638a..855b41016cf0 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -354,6 +354,8 @@ static unsigned long entry_invocation_flags(const struct binfmt_misc_entry *e,
 		flags |= MISC_FMT_CREDENTIALS | MISC_FMT_OPEN_BINARY;
 	if (bpf_flags & BPF_BINPRM_TRANSPARENT)
 		flags |= MISC_FMT_TRANSPARENT | MISC_FMT_OPEN_BINARY;
+	if (bpf_flags & BPF_BINPRM_LOADER)
+		flags |= MISC_FMT_LOADER;
 
 	return flags;
 }
diff --git a/fs/binfmt_misc_bpf.c b/fs/binfmt_misc_bpf.c
index d06cacc5c8c7..105c8afbb3f2 100644
--- a/fs/binfmt_misc_bpf.c
+++ b/fs/binfmt_misc_bpf.c
@@ -179,8 +179,10 @@ __bpf_kfunc int bpf_binprm_set_interp_arg(struct linux_binprm *bprm,
  * BPF_BINPRM_CREDENTIALS computes credentials from the binary, and
  * BPF_BINPRM_EXECFD hands the binary to the interpreter through AT_EXECFD.
  * BPF_BINPRM_TRANSPARENT additionally leaves the argument vector untouched,
- * making the exec look like a direct execution of the binary. Calling it
- * again replaces the flags, passing zero clears them again.
+ * making the exec look like a direct execution of the binary.
+ * BPF_BINPRM_LOADER substitutes the interpreter for the binary's PT_INTERP
+ * and runs the binary as a native exec; it excludes every other flag.
+ * Calling it again replaces the flags, passing zero clears them again.
  *
  * Return: 0 on success, -EINVAL if @flags contains an unknown bit or an
  * invalid combination
@@ -189,7 +191,12 @@ __bpf_kfunc int bpf_binprm_set_flags(struct linux_binprm *bprm,
 				     enum bpf_binprm_flags flags)
 {
 	if (flags & ~(BPF_BINPRM_PRESERVE_ARGV0 | BPF_BINPRM_CREDENTIALS |
-		      BPF_BINPRM_EXECFD | BPF_BINPRM_TRANSPARENT))
+		      BPF_BINPRM_EXECFD | BPF_BINPRM_TRANSPARENT |
+		      BPF_BINPRM_LOADER))
+		return -EINVAL;
+
+	/* Loader substitution is a native exec: no splice, execfd or creds work. */
+	if ((flags & BPF_BINPRM_LOADER) && (flags & ~BPF_BINPRM_LOADER))
 		return -EINVAL;
 
 	/* Transparency preserves the whole argv, argv[0] included. */
diff --git a/include/linux/binfmt_misc.h b/include/linux/binfmt_misc.h
index 26da749391b4..4abdfd36b3fa 100644
--- a/include/linux/binfmt_misc.h
+++ b/include/linux/binfmt_misc.h
@@ -19,6 +19,9 @@ struct user_namespace;
  * @BPF_BINPRM_TRANSPARENT: leave argv untouched, the interpreter takes the
  *                          binary from AT_EXECFD (like the 'T' flag); implies
  *                          execfd, excludes preserve-argv0
+ * @BPF_BINPRM_LOADER: substitute the interpreter for the binary's PT_INTERP
+ *                     and run the binary as a native exec (like the 'L'
+ *                     flag); excludes every other flag
  *
  * Set from a load program with bpf_binprm_set_flags(). Unlike a static entry,
  * a bpf handler chooses these per exec rather than once at registration.
@@ -28,6 +31,7 @@ enum bpf_binprm_flags {
 	BPF_BINPRM_CREDENTIALS		= (1ULL << 1),
 	BPF_BINPRM_EXECFD		= (1ULL << 2),
 	BPF_BINPRM_TRANSPARENT		= (1ULL << 3),
+	BPF_BINPRM_LOADER		= (1ULL << 4),
 };
 
 /**

-- 
2.53.0


