Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D8CFFF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 09:33:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFA156B0095; Mon,  4 May 2026 05:33:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE6CA6B008C; Mon,  4 May 2026 05:33:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C4D46B0093; Mon,  4 May 2026 05:33:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 74EC36B008C
	for <linux-mm@kvack.org>; Mon,  4 May 2026 05:33:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 585C11A018C
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:33:37 +0000 (UTC)
X-FDA: 84729224874.12.DE1CEE6
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7E29280008
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:33:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=31e3QaS3;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=7w72VJSi;
	spf=pass (imf30.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777887215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zQAG7CVmsWKVP7u5YLgZP2CRjHSITjRICazIKHci/JM=;
	b=pXQBxptoG8Sm7R06f9u0zL7viPWP8p87wNYBefjZCihXuARf+yl9PrbDCIfaY6kPnhsNoM
	5kQcKz5qEuPAG8IgDou+QlU/fu2o5DB3cOTRWuKo2/g6JChMESzhDttHFoJRieEgHKuK2t
	JVs96fvxh8Zl6Mzuzy4P4V1RPTglltc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777887215; a=rsa-sha256;
	cv=none;
	b=VnAKujrDGrIoE2AhU5LxYkk5UWtkiYmxrAJ8zHJZVz4j9mqFQF0D3RER2GiJ1tCNQOO1Un
	IKV4D4N7cp87oSDZ1nxWinszhfBlg5L066AZZFfAETH1GO335eZw3gEVNPkh3IGiiSHsbO
	zU2gQXMssTHI+s1kBQMRjOjSCVGjPlQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=31e3QaS3;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=7w72VJSi;
	spf=pass (imf30.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1777887214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zQAG7CVmsWKVP7u5YLgZP2CRjHSITjRICazIKHci/JM=;
	b=31e3QaS305TiIXvNkEsYdXEq2eU+zYNch+6P5rkxUluCBQJPcV7hVEaDkKYyYeIL3C+Yt1
	osYMcLwRsWWX+q5WCdjKSOqe7XfwCjUVKwqAop/pWZXx9VHZ3a2YSmNKcwkmv4A3qaF4+/
	7O3UurhRVwY0qOVaPlAyIZsaSqS4yED8MO8Q8tEVXoGLRIceH7ByYMrruwARg4v6VVJBw4
	W2ZmJGNVh5qODK2gltQSGap0jHN72aMhS002NHIfI+W/tsnHmguGPJ5iqtsHXLHO2ew2o9
	MBkh6IVMUZEn1UkxqgRMfrqaKKbIfEA9NB5Op7hEiNr+wVNevfQuw7cUaWdEmQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1777887214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zQAG7CVmsWKVP7u5YLgZP2CRjHSITjRICazIKHci/JM=;
	b=7w72VJSiZ5PXzKa8n3vn+sDeCdYJDKrqfyShNuVyd9tO+RxOtuTTMMTgwPN8tdVccUOYJm
	CDuB+hzrPiZiI8Cw==
Date: Mon, 04 May 2026 11:33:18 +0200
Subject: [PATCH v6 02/11] exec: add dirfd parameter to kernel_execve()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260504-kunit-kselftests-v6-2-712d3d526d97@linutronix.de>
References: <20260504-kunit-kselftests-v6-0-712d3d526d97@linutronix.de>
In-Reply-To: <20260504-kunit-kselftests-v6-0-712d3d526d97@linutronix.de>
To: Nathan Chancellor <nathan@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>, 
 Brendan Higgins <brendan.higgins@linux.dev>, Shuah Khan <shuah@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Nicolas Schier <nicolas.schier@linux.dev>, 
 Kees Cook <kees@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@lst.de>, Luis Chamberlain <mcgrof@kernel.org>, 
 David Gow <david@davidgow.net>, Rae Moar <raemoar63@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
 linux-doc@vger.kernel.org, workflows@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
 Christophe Leroy <chleroy@kernel.org>, Nicolas Schier <nsc@kernel.org>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777887211; l=2639;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=n0bgWJFcNKpR7u48Mrp0bvJ0+QUs8bWyY+A+fgnbBQA=;
 b=Iv+b/AJAUhxlOTF9z5Z/INA2wyJRCzy+sdAo250bsF4VV1rrH0mVXbVA7E8pS7XEdlsgRzsjV
 Y0RMQJeyPDnA1ttbX0DCypA1WPwqFMqXkH/2F3PqTAa3sXcWYb8gpni
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7E29280008
X-Rspam-User: 
X-Stat-Signature: qpw1xha7cekq87t7jm7y61rmob4y53nq
X-HE-Tag: 1777887215-873374
X-HE-Meta: U2FsdGVkX18zYZU9F449fHWkdFn3DIvi7C59HLbDJr/pOeh6KYUQoDwNM9R/6LRFXBGPiDv4my1QLnViagwd2/5o4OPvVMfBwn54nbDjMO/0MFexyoIQpEWYSXJeaOQ3K5f9/N9UkYyp0y2vnLzDyVD+aVkcd16/YK/b7BKicD+vp7vBF0bw75zjmJoRDZgkw1DPfL2PFxKYSsBake2SDpaioe4PnfxY9B4F8ACBCkajvhX4/+BM68QgugqloDMhYxmoGfoKz0vTAAFWc3cLjKpjJdCOKauZESqe5k6GhMtONOghaX9xKfdLN9gkf2N92OETS/byA6LXEj06+RH44bzJ03CxKuZhFY34RbGb6jjIAf1ETU/2Rl1frfY0fFov3nb88n1eoLwdfVsG9esuHiQS+oZ3CmHjPN50L9zqEJUTpCbLZ0xIawYAO95+CBSJQyeIWNGwm9b53J4fGNC40RiKfvtWvK59RecMmoxKUzjdcd1Nxu/raHy9V6xAs0giwR/8PEb0kmMzyBcP3Cxwe7B/qoGzP2cuuhdTmzzeShSBQRxFJBlGi1JhC3yMcl9n+2G0BndTig5oJres83svCbUG/uI+ij6lxT3NK/9ltCcRkMml1UasBCduR3IlOxjAVh40UPBiUXrk53O3q59SzR7WZz1+ytOXLc2dJ8Dh5VvHw/BGFtYSvCxWvNjyZQB986VrAL2Dx9P6EBw+YO50Dm4sTCqS3JOs8vqjp/obeZeA2EplNoVDUneh/dzoHK1nIwrLDcxrudmvwzeFGQZieWlXgKxk7JRYWbAGXItZmnRU7Ck3l7p1V9UgJ6QaKgSaSOlP12UA8X7sWjaGLYpF0o5JHmLpUE8ev9gigVZDh/xwyUhE8bfHdMC4lnXm4e1R60cvCFhbc8ePV2wlWU5s0bgxo37fTD7pGL46JPxJhudxpOtG8ZlKxno/AT9BKSAxyqe1kIOLcucxlLqdJlU
 YsYpfHVe
 fGkNluZNarUIELMgPCzDRyV0UdzM7PJmwlYHaWDyvXPh6EZH95L2pp/JilhdzW8uDJrZ5f3jcbMzQG9xVnfmPTazfoW8AlGhHabrRkDg5zrn4gzZbG8zg5rk6/OeaMHAhvQ9S8W/PooRfH7hwakN8wXgHCxhvKpMj/FtyTqF0EqxTDbw0SlBJaKWiaV3y64S94cTZNK4IZZUGFKXuEcR2A9Zizk06hyNk9M2UEk51Jt7+U//XGOaUly1F/dJGXSsmSfhCcAfhXVZC0duEMApC9ePbjEwxbWBNI9U/hRe2bNKjScpVAg55C3gZC9n6ViueAlZuUe+WJ6ccXikxFXCVQyGqSp0EwOWg2eL8ElVKTpWirLUpBiWgLHj+eNDmqTSW4i+hgX5rk3Wio8f6OQ9QjGjxmot2dpEVNEozFUPamKIhCG93ygF0nmmgSbmkKzS/6P9u7AfVjXqS+POunhUw7wxpQeimrr0fyHnm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow callers to specify the directory against which to resolve the
program filename. Enables running executables from private mounts.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 fs/exec.c               | 4 ++--
 include/linux/binfmts.h | 2 +-
 init/main.c             | 2 +-
 kernel/umh.c            | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index ba12b4c466f6..affae4b4f6f6 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1846,7 +1846,7 @@ static int do_execveat_common(int fd, struct filename *filename,
 	return bprm_execve(bprm);
 }
 
-int kernel_execve(const char *kernel_filename,
+int kernel_execve(int dirfd, const char *kernel_filename,
 		  const char *const *argv, const char *const *envp)
 {
 	int retval;
@@ -1856,7 +1856,7 @@ int kernel_execve(const char *kernel_filename,
 		return -EINVAL;
 
 	CLASS(filename_kernel, filename)(kernel_filename);
-	CLASS(bprm, bprm)(AT_FDCWD, filename, 0);
+	CLASS(bprm, bprm)(dirfd, filename, 0);
 	if (IS_ERR(bprm))
 		return PTR_ERR(bprm);
 
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 65abd5ab8836..04e2b7a85b2b 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -144,7 +144,7 @@ int copy_string_kernel(const char *arg, struct linux_binprm *bprm);
 extern void set_binfmt(struct linux_binfmt *new);
 extern ssize_t read_code(struct file *, unsigned long, loff_t, size_t);
 
-int kernel_execve(const char *filename,
+int kernel_execve(int dirfd, const char *filename,
 		  const char *const *argv, const char *const *envp);
 
 #endif /* _LINUX_BINFMTS_H */
diff --git a/init/main.c b/init/main.c
index 96f93bb06c49..551d03681234 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1511,7 +1511,7 @@ static int run_init_process(const char *init_filename)
 	pr_debug("  with environment:\n");
 	for (p = envp_init; *p; p++)
 		pr_debug("    %s\n", *p);
-	return kernel_execve(init_filename, argv_init, envp_init);
+	return kernel_execve(AT_FDCWD, init_filename, argv_init, envp_init);
 }
 
 static int try_to_run_init_process(const char *init_filename)
diff --git a/kernel/umh.c b/kernel/umh.c
index cffda97d961c..bab134fa8c36 100644
--- a/kernel/umh.c
+++ b/kernel/umh.c
@@ -106,7 +106,7 @@ static int call_usermodehelper_exec_async(void *data)
 	commit_creds(new);
 
 	wait_for_initramfs();
-	retval = kernel_execve(sub_info->path,
+	retval = kernel_execve(AT_FDCWD, sub_info->path,
 			       (const char *const *)sub_info->argv,
 			       (const char *const *)sub_info->envp);
 out:

-- 
2.53.0


