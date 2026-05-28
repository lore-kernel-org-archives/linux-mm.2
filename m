Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98C77CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:55:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD50B6B00A4; Thu, 28 May 2026 05:55:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A85806B00A6; Thu, 28 May 2026 05:55:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C2996B00A7; Thu, 28 May 2026 05:55:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8AF9D6B00A4
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:55:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3748FA07EE
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:55:02 +0000 (UTC)
X-FDA: 84816370044.27.5AE3582
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5F0BD4000D
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:55:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=AZwYKVo1;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf04.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779962100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Np1g+dFsamPmY41icpk+vIarybQaXo3ssE2KjyjvCss=;
	b=ri2gWX2aYlstGpy1Zk2BbSeSkmwXdqFWGeuFHwSd5W6neaKv4an2e3KfQqQE5cDixrRkGk
	nmtpoPt9K/QLE+xUItwActHOmgAM1qQTwJvQE0xhf/aH07XoRfFJOZDYHNFh+QrpG0k2w/
	jocXndwJIQzrhmBW7LrYbypw1e2DSug=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779962100; a=rsa-sha256;
	cv=pass;
	b=oCEJF/V6ulOg1mbHmeq6hXdkSBU9aABkdHfnzgWxbSm6OypNs3X0iXfaTKIbKPT1NKuJrY
	XWDNz3GiTkp962xqxPB2AOPSwZujsoPO2G+peYZZyC6Pqpm1ejdhN8Ajot8Q3CkJ5cq77s
	dVg8oCsMRkvtcQlKTGvAYEJ9aEtVtpI=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=AZwYKVo1;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf04.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty
ARC-Seal: i=1; a=rsa-sha256; t=1779962010; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=UJp74+WitwbRvyhSh1bqMHpblUO0MWbE7UlDr3begnbJB617OdDR2gfunQADEykfa5B0CE+3TWDnE40e3516+m/qPveTsAPszR0aajiboyNqWDPimeaX4e4lNNSkev3dWBbu2hyF2ts3NeqWS3N+u/DIbVIRjbgWGgs0eeTrIMQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1779962010; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Np1g+dFsamPmY41icpk+vIarybQaXo3ssE2KjyjvCss=; 
	b=F7bPn+uWftD68aLJkbRNnr397A+9eEYyvV2g2crEX+VJTQfeKVSDBvtI9IDVgcDvS193Ze2dUHGrKym8ulTYxWTaMq0lxaUcC2l3XndZUAvIGrG6ZwDXCNjXgaIYNJaLISjUYbh0DV9akOZOUQVclWuU4l0b866uCKCa1cB85Mc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1779962010;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=Np1g+dFsamPmY41icpk+vIarybQaXo3ssE2KjyjvCss=;
	b=AZwYKVo12OW8IbAxRwRL7CFelimmkb7ycFOc6bfBdDKMfCWY/i7OrbyNEOJs02Gs
	EOFTusw+Sg+ZbqsMzB5Gz1dhRJ44nSHYnWrGTYjBw7Y9et5/2bGYYQ2uKbWeDPygQAh
	cOZyCXAyXl72jvaM82H6qpYb8hKnfM0GxlXMO8wo=
Received: by mx.zohomail.com with SMTPS id 1779962008110241.98298131178922;
	Thu, 28 May 2026 02:53:28 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Christian Brauner <brauner@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	x86@kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Li Chen <me@linux.beauty>
Subject: [RFC PATCH v1 04/13] exec: add spawn template UAPI definitions
Date: Thu, 28 May 2026 17:52:25 +0800
Message-ID: <20260528095235.2491226-5-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260528095235.2491226-1-me@linux.beauty>
References: <20260528095235.2491226-1-me@linux.beauty>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam11
X-Stat-Signature: k5bt7gf6ftgdgg7wymkm5o4abinzyys3
X-Rspamd-Queue-Id: 5F0BD4000D
X-Rspam-User: 
X-HE-Tag: 1779962100-16653
X-HE-Meta: U2FsdGVkX19eHr4vYs4vQq9VmH12c2sIPNdmRe5NRWsL/5C/yuGfAfUVUqdA9jdldlFhDElut3FnJvtak1eLcZ9owRTN9Z3NHEnl3rUSR7R2tj/GH5/ZGZvzBdrCHIQfUIQF+oj6e5RpEzFESBj/bLfhiXmhvAJrmC6nrA3S/an9Q2cFx9+fd4CB5p6KojbBoZgyAYwZDDrlIm0Z/VILn5yaz/Rim7OIPSFpJ7wEjPa3mv9o9yNDxG8S7AUqz0sgl+IfzbmcOmfMU6UnQY27LmHJY1o8fjNHtrZj09ZCAEHRO1BfdCJlIWWZ6+youDzNcIlApL+HFqWJmfaY1gQIycbwXMXDbQEayup87P4cwneDbLDAKIci/wHj5jMIKdq38/flG7MZs0QiVoc3xHXtn0mXjqLvpYB0llo5uuclHjw/KmENe3KNqg6hEu2I5HWxlLBUjtmjg2aQmd6xoK3dayrlnaT/hR5KI67N4iLMKraEcAfd/FqMFSfCt6IaFtTQZ4U8IL/JxoLaws9rIf5nZSR2bAXroUAQSQU3ign7mVJdN+0c/z+Q+uEShDEJN43vx6yFPMGCDaDrOu5Yw2Zg+VZfmaF2Rx1Pb2cRljT85LODVJB6gvvmNRRIGk10Qyf2oV+FSxOiOt48eLqEo3qt3uvdnouIuqe1+283cvIMvBAPtH5brPiC+Gi7jcmBhYWvl5bp6+OmPiMl1xu42WcYAfqyMl/ikrQUfn2dDY17UJlpqqZ4Iax6J/pFSgMyymmC5krYoU+rPvXO3Gj99+3aypvTNx0OfiLGg6Wca9pPVbe8K54+vuxAS3FNkYUKyhgQjFT7sDfaCMfaE+7+dP0vdlmdU0h4IqifPQUyUIXJVgX/ssLKJc6Tdg6C0TAFO7e7LzGjDPKE0JIRK4VMhl88kiWqmCmFq8+gOSPmxT7ag3RtjTxdvP6aHRQgt6i5cImsVU5ZY7aiM6HbtKP7OY8
 hrASf9lU
 w6Qwi0xjjMd10VuOgffqYYaivWVHHmXApbg+mbWBEeFVWtVSAs8KHPUxHuMWEuNMVuxbh+bCBGhjA5byj50N2uXnCtGbTlASZiAeg6VbkNS+tcIoguuDSAYN6mg3G0Gpx+MIr8LUjg0givXF3UfHxcrvflP1BTXDtYpqYijJ46qe9kw8Ab/PulZKskmeb8ZZ/AqTb1IQO9EgF1WNZBE5aaEWxStOYKrA+G1yO7akPLzlvTWieA/dmW8nteYq3VoZqJ86AR+kxwSxMUZ3fkmtyRGlprfvlrDioiMP58WP/1iDpzITWK0GQgDLvY/MNQUzXldfRhTpg0lDSudJfSfLXi/VWr6Ku9dnFFJbBylDJOann3X6j6dvcAi9SY2HccgJWJ+4/fYWfYYqS3hMEFpAnYDoeTJ8DAgn4r/QS700L8ZSYO4+kOA2ckEO1PNUc+AGvr5irZRrnu27jcXBQbG7qPLahnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the userspace ABI structures and flags for creating a spawn
template and spawning a process from it. The ABI carries argv, envp,
and per-spawn fd actions while leaving policy decisions in userspace.

Signed-off-by: Li Chen <me@linux.beauty>
---
 MAINTAINERS                         |  1 +
 include/uapi/linux/spawn_template.h | 62 +++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)
 create mode 100644 include/uapi/linux/spawn_template.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 3dd58a16f06a9..d7b1191e33ca0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9739,6 +9739,7 @@ F:	include/linux/elf.h
 F:	include/uapi/linux/auxvec.h
 F:	include/uapi/linux/binfmts.h
 F:	include/uapi/linux/elf.h
+F:	include/uapi/linux/spawn_template.h
 F:	kernel/fork.c
 F:	mm/vma_exec.c
 F:	tools/testing/selftests/exec/
diff --git a/include/uapi/linux/spawn_template.h b/include/uapi/linux/spawn_template.h
new file mode 100644
index 0000000000000..84f026fdf9090
--- /dev/null
+++ b/include/uapi/linux/spawn_template.h
@@ -0,0 +1,62 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_SPAWN_TEMPLATE_H
+#define _UAPI_LINUX_SPAWN_TEMPLATE_H
+
+#include <linux/openat2.h>
+#include <linux/types.h>
+
+#define SPAWN_TEMPLATE_CREATE_CLOEXEC		(1ULL << 0)
+#define SPAWN_TEMPLATE_SPAWN_INHERIT_FDS	(1ULL << 0)
+
+enum spawn_template_action_type {
+	SPAWN_TEMPLATE_ACTION_CLOSE = 0,
+	SPAWN_TEMPLATE_ACTION_DUP2 = 1,
+	SPAWN_TEMPLATE_ACTION_FCHDIR = 2,
+	SPAWN_TEMPLATE_ACTION_OPEN = 3,
+	SPAWN_TEMPLATE_ACTION_CLOSE_RANGE = 4,
+	SPAWN_TEMPLATE_ACTION_SIGMASK = 5,
+	SPAWN_TEMPLATE_ACTION_SIGDEFAULT = 6,
+};
+
+struct spawn_template_action {
+	__u32 type;
+	__u32 flags;
+	__s32 fd;
+	__s32 newfd;
+	__aligned_u64 arg;
+};
+
+struct spawn_template_open {
+	__aligned_u64 path;
+	struct open_how how;
+};
+
+struct spawn_template_sigset {
+	__aligned_u64 sigset;
+	__u64 sigsetsize;
+};
+
+struct spawn_template_create_args {
+	__aligned_u64 flags;
+	__s32 execfd;
+	__u32 exec_flags;
+	__aligned_u64 filename;
+	__aligned_u64 actions;
+	__aligned_u64 actions_len;
+	__aligned_u64 reserved[4];
+};
+
+struct spawn_template_spawn_args {
+	__aligned_u64 flags;
+	__aligned_u64 pidfd;
+	__aligned_u64 argv;
+	__aligned_u64 envp;
+	__aligned_u64 actions;
+	__aligned_u64 actions_len;
+	__aligned_u64 reserved[4];
+};
+
+#define SPAWN_TEMPLATE_CREATE_ARGS_SIZE_VER0	72
+#define SPAWN_TEMPLATE_SPAWN_ARGS_SIZE_VER0	80
+
+#endif /* _UAPI_LINUX_SPAWN_TEMPLATE_H */
-- 
2.52.0


