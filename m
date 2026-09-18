Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A612CC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:20:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B3E66B00B2; Fri, 18 Sep 2026 05:20:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48BC36B00B3; Fri, 18 Sep 2026 05:20:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3536F6B00B4; Fri, 18 Sep 2026 05:20:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 189846B00B2
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:20:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B0E3405CF
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:20:17 +0000 (UTC)
X-FDA: 85226336874.23.8EB1351
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8889820005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:20:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ML/vU9wU";
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789723215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rp+rJmhTE7Df7VsQPiO1xXybhrFkjWSbdjcw3UfOXPw=;
	b=X0IhiV4JyB/GjMOJsoo9wIA+PpIVdSjAsK0Do3cN2tZ9ytv/OnQ3RIZBgYq00pjvJ0LIOK
	skFg5LL1Gb9VS747zSVfKZNAYuleaybz18felJl2YM6kz78Hfh6S9p/wQhn66EoOu0VN63
	ttLYhkZsjLtXj58qxHnPcoohgcic8LE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789723215;
	b=gbl41yz9OvPF5vpnwOMyC73nxBGfEe/Yt6j/926QwUkMK0MsW+BLmO6LcgxWpH00kVWJ5m
	MKlvOYmmd4FgjD7pSNIevj4e6KmodmNE7YHVffIXcL8/OF9NukWoUguPSGRJbNt1zpLKQS
	Yz0WedUuTJ2dP7dHiHWcDsFGVmRqwJc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ML/vU9wU";
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D4BD8447B4;
	Fri, 18 Sep 2026 09:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F691F000FF;
	Fri, 18 Sep 2026 09:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789723214;
	bh=rp+rJmhTE7Df7VsQPiO1xXybhrFkjWSbdjcw3UfOXPw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ML/vU9wUTiV7IpxrbkVbrPIZCCpeS5W9MCafzrH4LCoogdtHsIhfCx/8jLLzjz65e
	 gpiG8/V3KZVETLi/KYkGLg94yjTjgNPJY4LqxVc4RldYsZPHC72JaXcE3yFEAdprK0
	 aTLp6m49wnCkhn6XWaAUZG2gKK3XcaTQNehkOAzRJnY04Mg2qZD5Ab5aIYwTDszWr8
	 b/s+RvHPecLLYqF9THIvZuy0Mka+jhB2Ep2DFQjXD8crxDtyoTNAeYb5oJgpeWHI/Z
	 nrS3jxjehGNm2dBMPqFhSw9I8/Nia46U2gLs683QjkivQmXOm+zOgEiEZ11q9+xMDV
	 5P4BXDIrfMEfw==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 18 Sep 2026 11:20:00 +0200
Subject: [PATCH 2/2] binfmt_misc: fix racy checks in bpf set_interp kfuncs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260918-work-binfmt_misc-fixes-v1-2-647b24bc1c46@kernel.org>
References: <20260918-work-binfmt_misc-fixes-v1-0-647b24bc1c46@kernel.org>
In-Reply-To: <20260918-work-binfmt_misc-fixes-v1-0-647b24bc1c46@kernel.org>
To: Chris Mason <mason@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=5856; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Hnw5hxTi5fYqyBdtFSZVwFO8KP68FjOAa84bLk+sgF0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWStZXK7MefV3Irf6m2zfdU2vZjKuFwiQXpHo6pWacSVT
 8kzz1rKdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEwkcwPD/9Bjil6fOJYoFi7i
 yZvykt9i04GknBuCl3yXfTBYfHqHJgvD/7CN8T8lLZ4x/1wQ1t/x0cj/ZFF0sX3JAvf0ouo+7rK
 /nAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8889820005
X-Stat-Signature: 4f91ngko5cqr47dwatfoj1cfnyje3q14
X-Rspam-User: 
X-HE-Tag: 1789723215-397052
X-HE-Meta: U2FsdGVkX1/7ejMssU2lSPz+l4FbOCATE6TVM91r+iO2TyLKBTFDkWjZHi9GnzY237reBSRs6JsIxhDha1YN7nhNbVJTUR1BQRVjs1XBPFXqYLSVH6AzykitjZ7uTcZPvH1gRDaaIja37NdBezkKKw+ld9iPEOMgG1SOIp5cNc9PErc+ieeXoxzAfxq7FwEeqDYzuvpjVaiEjhTJdfuDJCFPvJMgLsiyZVBOiiV7ZLP2/qWxqBQYsef6Lg+PIJfTFNENQa2ym7mQ3wzn/mGUaGCnypNtJeP9jJ/NdU3casZftbLczDlW/a/P8QSVl+dai6BrhxhT9CaWEsOCP80KRtA1+gVBXvo39ATrTKBJiJNerJVBrj8Bxi/KNHJKYGRns7rVHkdFAuBNkDDRmowGH7Q4CoJww1KBPPpy4k2ZfXuTEoXIuVSuHelf4erhxmxBu+KkdNP4JmvJMADQPT5p8YGb7+3HlVpDJr1MCw2f9GXFibKc/THEg4U+psKVkoxoK46r20tUBTCpesgQ9NhJtkHxvR9CCrJSzXbJUZUTOAuUu2Zbj0fjYvmvCeFvbgESb4LqhBhNgEf9mNHuh/uKTEki1ctl11Ri4fj5RKf8QTwAtDgLhUO+q/17A9m1hxDBeloodktFiqNBCNnEY9YMWYyD23DwFMTLMl/kDSg9hGPjrp0jT8dU6H8bmHIC4C5rQ2wXFuExg7yFL6O+8h+uWUaPQoyI3S3bvrDvq9VPTEOgY7hp+0k1CkbTRHw0sN8dZWEDdU6ZpeH1Q2sRF8rGNLI7qYxQPXdOMLIT7DjpRYlQ11k7qXzJlweMosXk4pMsZxjzQCjZzfyb+kLTSU1cfYWxQj4yHqxy+6sKn2Ur34RpMMzqYM6zjAuzqlqDyxBm1+fc6BNIv38OJ3k5UNIxjWBajRcIWxdVqEwfAOwwyY7ENCD//Cwxfvi+dUjpxTuZp+2fmwg9UKmvuvaR6gU
 O+RX4Lsw
 SbwbMcYRAN0GkbFCsYuO0imxmk5gILHR4FUtuIVXec6zeGpmBxk27cL1mgsWDq1pjH0d5IZKfQrlTpac6CaDkLpuL+zZB0++ExnINJamg2r1Y7SGAbme4CIBBee3zSNOPMfN0RDM97+DsIf0kZrqOzOlzo80ZbBDINCUoLKd+wkKUa68UIGz9VPmLnj2rfG5IqxqaaSdAMyCQfoIXXV+++QhWdoVp6au0XKw/lD0FjXsNe6dJvJ7X2ftVYGrr3SsyISoifqBaWfMdL13gkZMImWSln9U+IORqXBC/bblLIntxxIksV5ZRkEFy/uMMXFRI61Mt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chris Mason <mason@kernel.org>

bpf_binprm_set_interp() tests path[0] != '/' on the buffer its load
program passes and then reads the same buffer again to copy it with
kmemdup_nul(). The buffer can be a BPF map value that another CPU
rewrites between the two reads. If byte 0 is overwritten in that
window, the kfunc stages a relative or empty interpreter path. The
staged path is not checked again, so open_exec() resolves a relative
path against the working directory of the task doing the exec.
bpf_binprm_set_interp_arg() has the same pattern for its "!len" test
and can stage an empty argument, which the interpreter then receives
as an empty argv entry.

The verifier checks the path and path__sz pair with BPF_READ |
BPF_WRITE, so a writable array map value is an accepted argument.
bpf(BPF_MAP_UPDATE_ELEM) on an array map copies the new value over the
old one in place and takes no lock. Both kfuncs are KF_SLEEPABLE and
allocate with GFP_KERNEL between the test and the copy, so the task
can sleep inside the window:

    load program                          bpf(BPF_MAP_UPDATE_ELEM)
    bpf_binprm_set_interp()
      strnlen(path, path__sz)
      path[0] != '/' is false
      kmemdup_nul(path, len, GFP_KERNEL)
        allocation may sleep
                                          array_map_update_elem()
                                            copy_map_value()
                                              rewrites byte 0
        copy reads path again
      bm_bpf_stage_selection()

The test in the load program's column proves what byte 0 held only at
the moment the test ran. The map update takes no lock, so it can store
to byte 0 right after. kmemdup_nul() then copies the rewritten bytes,
and bm_bpf_stage_selection() publishes them as bprm->bpf_interp.

The staged path is not checked again on its way to open_exec():

    load_misc_binary()
      entry_select_interpreter()     returns bprm->bpf_interp unchanged
      build_interp_argv()
        copy_string_kernel()         copies it as argv[0]
      bprm_change_interp()
        kstrdup()
      entry_open_interpreter()
        open_exec()                  unless a bound file is staged or
                                     the entry is an 'F' entry

None of these functions tests the first byte, and load_misc_binary()
hands the pointer to nothing else.

In bpf_binprm_set_interp_arg(), strnlen() finds a non-zero len, a NUL
is then stored to byte 0, and build_interp_argv() later copies the
empty bprm->bpf_interp_arg with copy_string_kernel().

The handler's own load program has to pass a writable map value, and
something has to store into it while the kfunc runs. The allocation can
sleep inside the window, and with a BPF_F_MMAPABLE array the store is a
plain user space write into the mapped value, so a loop can hit it
without a single bpf() call.

Check the private copy in both kfuncs, so that the string that gets
staged is the string that was checked. bpf_binprm_select_interp()
already looks its name up in a private copy for the same reason. The
remaining tests work on path__sz, arg__sz or the local len, and the
copy length is len, so the copy stays inside the extent the verifier
checked.

Results of bpf_binprm_set_interp() with the check on the copy:

- A NUL stored to byte 0 fails interp[0] != '/' and gets -EINVAL.
- For len == 0, kmemdup_nul() returns an empty string, so an empty path
  still gets -EINVAL.
- A NUL stored further into the string only shortens it to another
  absolute path, or another non-empty argument, that the program could
  have passed anyway.
- A path that both lacks the leading '/' and is PATH_MAX or longer now
  gets -ENAMETOOLONG instead of -EINVAL.
- A path that is empty or lacks the leading '/' is now rejected after
  the copy rather than before it, so such a call makes an allocation
  and returns -ENOMEM instead of -EINVAL if that allocation fails.

bpf_binprm_set_interp_arg() still rejects an empty argument before
allocating, so its results are unchanged apart from the raced case
fixed here.

Both new checks run before the previously staged string is freed or
replaced. A failing call frees only its own allocation and leaves the
earlier selection in place, as the -ENOMEM path already does.

Fixes: b4bfe2f6b011 ("binfmt_misc: add binfmt_misc_ops bpf struct_ops")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc_bpf.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_misc_bpf.c b/fs/binfmt_misc_bpf.c
index ce1bc78e8511..a3e26e8a4027 100644
--- a/fs/binfmt_misc_bpf.c
+++ b/fs/binfmt_misc_bpf.c
@@ -141,8 +141,6 @@ __bpf_kfunc int bpf_binprm_set_interp(struct linux_binprm *bprm,
 	len = strnlen(path, path__sz);
 	if (len == path__sz)
 		return -EINVAL;
-	if (path[0] != '/')
-		return -EINVAL;
 	if (len >= PATH_MAX)
 		return -ENAMETOOLONG;
 
@@ -150,6 +148,15 @@ __bpf_kfunc int bpf_binprm_set_interp(struct linux_binprm *bprm,
 	if (!interp)
 		return -ENOMEM;
 
+	/*
+	 * The program may pass memory that is written to while this runs,
+	 * so check the private copy and not the buffer it was made from.
+	 */
+	if (interp[0] != '/') {
+		kfree(interp);
+		return -EINVAL;
+	}
+
 	bm_bpf_stage_selection(bprm, interp, NULL);
 	return 0;
 }
@@ -241,6 +248,15 @@ __bpf_kfunc int bpf_binprm_set_interp_arg(struct linux_binprm *bprm,
 	if (!val)
 		return -ENOMEM;
 
+	/*
+	 * The program may pass memory that is written to while this runs,
+	 * so check the private copy and not the buffer it was made from.
+	 */
+	if (!val[0]) {
+		kfree(val);
+		return -EINVAL;
+	}
+
 	kfree(bprm->bpf_interp_arg);
 	bprm->bpf_interp_arg = val;
 	return 0;

-- 
2.53.0


