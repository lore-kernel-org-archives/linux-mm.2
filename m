Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EABE6C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 219306B00DC; Mon, 20 Jul 2026 05:34:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17CE66B00DD; Mon, 20 Jul 2026 05:34:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC2986B00DE; Mon, 20 Jul 2026 05:34:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE4316B00DC
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:34:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5B0D41607DB
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:56 +0000 (UTC)
X-FDA: 85008645792.22.124349B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 92FA41A0003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nGj4vUdt;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784540094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0uxigeI5a8sxnmPaz7DRAYhYlKGQhDnDoL1eW8DC+Yc=;
	b=aHD0cjZS2uDQUXeBD4ilecEwGZUnOOH9OcbbrGt3G7jQm+nBlbhXCrdcnRkEAKB1JCJpJv
	aS9vuFbRmpbpmNvVJS1bU4Ezy/Ovm0Xu7rXUOnwluWlvFhDJXRmwfctFKnpXmWODM6/+9n
	urglmQ+HBP6vmKXGOjFqOpqtv8xde/A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784540094;
	b=ZiaorssEbnrgOhhcZPU5ClDm/mAyP6dYU/7kRTBXLEZXBNMyo7gPEq9YOFucx3ZieK0bvB
	swSaY/oDJAAd6UX1GEJHdjuA4YiRgfcGT/c3hsaeeLWqbQruD9Iw0Q6yR5COzA02duDvwG
	62dWyeTcWUqI6L/xpDnPIP5gPOhSNuU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nGj4vUdt;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EDBDB41387;
	Mon, 20 Jul 2026 09:34:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8E81F000E9;
	Mon, 20 Jul 2026 09:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784540093;
	bh=0uxigeI5a8sxnmPaz7DRAYhYlKGQhDnDoL1eW8DC+Yc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nGj4vUdtq3iU0KiO//sBFGNDSF5zCmhfkBhXIr3Vod5LRmxgyqMFf6wiBjCj5HSQS
	 EmU8AWJnxTxhQU7bypvWkOUDWIRyJckvFuz2QkjOFP9p7Jz0rVwNy4Srv4EGa/K/U7
	 4sSB58MTm17tCPH8ZHcv243mFFtGhFhIk4jULZtlgOnHdJqFWe/SdyQ20A3Rv3Wt0I
	 aDUOCEt+O7C4mGxgUsJj3nEuqkHkiJRQxYJNYJk9tg3X7OpQxBVdXK74cheyFaWS9q
	 GYF9EiIrQj6JwQ37yMBxjL536IgVMJs3NIQUG6gKJUMqfMhQ06NQhHepH0yKmaKFgz
	 NGykFQeSW+dMQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 20 Jul 2026 11:33:40 +0200
Subject: [PATCH 17/21] binfmt_elf: consume a stashed PT_INTERP substitute
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-work-bpf-binfmt_misc-ptinterp-v1-17-ddb76c9a508e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1914; i=brauner@kernel.org;
 h=from:subject:message-id; bh=xHwXWmqSGpJLIvfrJ5UTAUuagvvd4JFCHu+wcBQmPnc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTFvm4y6+ZL5nnMMSe5PuBAc9XqX5HrvjiIf2c/Hbtag
 utMf/ecjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgImUXmFkuKH72riw9dJzhf5H
 wiVC07hNmeviG/V8Q2fMWpzotLSFiZHh1t/dvzwO5dWKWq65bC/F/XDL/pfP7uz7031C4IHh9vw
 wHgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 92FA41A0003
X-Stat-Signature: qfpo76dnadnedq4idf8sodyoj984idut
X-HE-Tag: 1784540094-380474
X-HE-Meta: U2FsdGVkX1828c+XtH8FBrCX5wa1aGWWEWpuONWpeEpbQDpMM9/ldqq+YJg+qxYHQOQz+cwCVI8+zaGIlcxkVH1cHYGIPGALMq8I12ZUbimR7H1JdGee9yp8Z2luIcCseLLSmfPZlabRTmWMr7SENQw/e3o0yduip9SFTY0C4ph/CPtrfSWuvIvlWsE6tJt2d2JzmXVfMtG6igK6Q8Jex0WGiHVhVCGMvgfuy2S28BJtQU5qDD836nrJ8oRo5/o7VUwXEDNX+GlCLhiN6ep0DBiq2F7fTfUXTYHBDa1KUGn1LC56x9HInlI/4LYyPsq1q1X43bBH3bmA2jSzpo2eOT5456LeDNc6CntN4eaJThnL9iS7qd3OIxhHT9N/yhUmamWnCHuoyHDljK1KbdeW/X7pOZCxyOksq/wmJX75Sv6mo2UFT3og91OjhqyFvdi01upZ1fy3wTBgNZDe82ubR5NdNeiIA8aKYYA9eMfPIlQvFXk06jFD9ma0UntiIzMfP6Ke+s9dQ1gLZuM3BmIaJyULSfiJ1Cxif/F9wIScVv0L/CmPsuaYgsyoqj2+SAPaFHAVZwgMtmrrXj375I7KsVEnp3NhMvlE7fzRFCiXxn0GR2+DCxfQzklWNkT3WAwODVCIGlLEL8S1dh9RyjPhJFUqWhdj7jcMSYo5h9RMrm+8o69GU3opHirjzxQy2tGXS+SNHFt8m1KydWrk6Ab265bW4+uBA2g2VjCDgqEYpMjV/kF05olyApDQ50Us5DbGYXUzjJkx+oPt0y1tHtb43HzHvK8BRpS5ATuzgAKjWoRvgSLAE6yk95sS9CU5WwgGgCna6EiMIINAsvE7lVRkMpR3m4ynUAG8Pbi5I/2ItZEF+epk8nOhyRX17R9bUI8Oi1CCHnUB0wd89GqkGbQj9BYnh210RYMG+z0dwMW7P3/LRtKjpWCiMaSjJnguqhE2zB4M3FJywTAvJzayTKV
 5a56ZRwZ
 mljaad2eU6G0oZ/bec6RbuAuDkrvbvRBRmNlXuev4dmezozYlzitnFufGUq/GLtf9BbfsfKTBIN/lbiihLNo6p/FCWMSCn0isO2ty11RhmFB1nVMhb+9Q16XOrn+I9m54A7QMLaP8N6/R2UQkF/B0p8DkGYywPOKw+iePghfd9PKK9+WQrkQstS2kPGOfmrgMC4tdd6YFDDx1I3IorBMR9tz9j0V9zTuy1YF6kTgYXfX42rp3R1W9cL+bHuQK4cBs7JNRonRRs5KiOol7Wa+UDEqGioZl55vo2nIErLNqZRueeDGBFqG6XBSgbsNRX8D08by0Nv9tFuaUTKdTENX9UAEqmV4hQLf/AqEN40cQO5iWKzedbYn2btwzKWG4qrveRK/S1o0XVP2NDShbVxmFlRPhWiKrZJo5cwdPHKC2x6u4Hgc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a binfmt_misc loader entry stashed bprm->loader use it instead of
opening the path named in PT_INTERP. The substitution deliberately
changes as little as possible. Ownership transfers into the local
interpreter reference which the existing success and error paths already
release.

A binary without PT_INTERP has nothing to substitute for. Drop the
override at the end of the segment scan and load the binary natively.

Nothing sets bprm->loader yet.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_elf.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index e44230242f3a..3455af6be2b5 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -19,6 +19,7 @@
 #include <linux/errno.h>
 #include <linux/signal.h>
 #include <linux/binfmts.h>
+#include <linux/cleanup.h>
 #include <linux/string.h>
 #include <linux/file.h>
 #include <linux/slab.h>
@@ -907,7 +908,11 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		if (elf_interpreter[elf_ppnt->p_filesz - 1] != '\0')
 			goto out_free_interp;
 
-		interpreter = open_exec(elf_interpreter);
+		/* A binfmt_misc loader entry substitutes for PT_INTERP. */
+		if (bprm->loader)
+			interpreter = no_free_ptr(bprm->loader);
+		else
+			interpreter = open_exec(elf_interpreter);
 		kfree(elf_interpreter);
 		retval = PTR_ERR(interpreter);
 		if (IS_ERR(interpreter))
@@ -938,6 +943,14 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		goto out_free_ph;
 	}
 
+	/* No PT_INTERP to substitute for: the override does not apply. */
+	if (bprm->loader) {
+		struct file *loader = no_free_ptr(bprm->loader);
+
+		exe_file_allow_write_access(loader);
+		fput(loader);
+	}
+
 	elf_ppnt = elf_phdata;
 	for (i = 0; i < elf_ex->e_phnum; i++, elf_ppnt++)
 		switch (elf_ppnt->p_type) {

-- 
2.53.0


