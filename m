Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2144CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:54:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 025186B00A1; Thu, 28 May 2026 05:54:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F17C86B00A2; Thu, 28 May 2026 05:54:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E552F6B00A3; Thu, 28 May 2026 05:54:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D40746B00A1
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:54:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A664A1A07EE
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:54:10 +0000 (UTC)
X-FDA: 84816367860.01.B310BD0
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf02.hostedemail.com (Postfix) with ESMTP id A1A7780009
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:54:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=FKKbwuBs;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf02.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779962048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uH9yEaUapIEKI2lfJ5G4DMQBlkpv8yAmGkbHJEgDnPY=;
	b=ZymRvBK5zBUIi8VZ365m3xgqbws73871UGdtjg4zPeZdWlCchHBUDPrEKiBA6vo+Q2i5u7
	ZKWBrFL27k7SfrPk6UGJFdyiCudFuA5Q6bATxjh9/J6pk+C4eMz56xHAcSXediHZshLHUG
	lIGiuvo0waojY6MV7dxd0wj4P5MbmK4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779962048; a=rsa-sha256;
	cv=pass;
	b=EfQVuoafvjeIcyuAMtH7vukGq3do55naqoz1c46XrYHao5+q30PRJucXhc/n6/WaC56ytp
	XiwSgu5j5i3FfSWxIykbmfrOf7IAYuv0bhzRvip/JhKzd/Dv2rNdXRE8e9wh3NaOypVRbF
	/kPSpfIxdBrT4lEWI2OC7AfIkMoRDq4=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=FKKbwuBs;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf02.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty
ARC-Seal: i=1; a=rsa-sha256; t=1779961994; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=fDeGWFaxxrrcS1qDKS05XqYcZzPAF01/g6Ak+RwWXKG6FYNj6BVMIC2k1nfJlv9eCj/s0FbAfJpHieo3i1Swx5WlwiqRPBKygY5640jds3ncz/DYai8sGCYUrmxYIFgCE3yLzx5waC19lcH9Snx1b+7P7scuC6flfGDqY7Tn7gw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1779961994; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=uH9yEaUapIEKI2lfJ5G4DMQBlkpv8yAmGkbHJEgDnPY=; 
	b=i70+iVLUuxtknOMvAep6Ruv5rjjsgfLk1c82C16zVQh0uezSHlhefm7AlpayC8ym7VXJTsrbLgKE5mVPBifuDHpZOxFtAUIGqP190L18NuoWkmxR5oUvtGSlH315OORF34vvoWlGUaqpDsAws5MP5zQjsKir/NjNZVEuTQ+d+iY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1779961994;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=uH9yEaUapIEKI2lfJ5G4DMQBlkpv8yAmGkbHJEgDnPY=;
	b=FKKbwuBsJ5SfWsLpJFnsM7vEveFkJV6vaylgo+rqg2tpHfGqwr57fWuWpcJm7bbJ
	qBZMhrSsxhYOglTquuejNbzWJlrPcY4tno/duHtpdTwL/pNStDGh69hDDzmS4J6rnm9
	b621M0QFh8R5OtuzBHeDxesjLPgFqUEPx3PnfBio=
Received: by mx.zohomail.com with SMTPS id 1779961991167186.94687791742058;
	Thu, 28 May 2026 02:53:11 -0700 (PDT)
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
Subject: [RFC PATCH v1 02/13] exec: add an internal helper for opened executables
Date: Thu, 28 May 2026 17:52:23 +0800
Message-ID: <20260528095235.2491226-3-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260528095235.2491226-1-me@linux.beauty>
References: <20260528095235.2491226-1-me@linux.beauty>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam11
X-Stat-Signature: s5fo13gtxb5bi7xokt1kaob56ibg3rr8
X-Rspamd-Queue-Id: A1A7780009
X-Rspam-User: 
X-HE-Tag: 1779962048-971203
X-HE-Meta: U2FsdGVkX1/udi1iBA2et7Urum9AMS4fZ9weXbkITEM0u7pK8dDMKZqKQH6QdV0QnSTVDneS+6zyQatAS/V+y7+3YCSGyrPrCP7+jUG8/QFaMs1XkuAvSf9ARj/iJcEY4V9AZYwo7reoYqqaV7LhGjlfTIR9oU10LIZ5OVQ23zyguU4haHV/VMXtFQcq74ZuIOPwpfknANJHz0Ggc+pMQsRceFNf3FCweEbqFz65X3S0X5QpR8AwIvtGaTUWIQB/qQGj0QDQLlhhBnEGzYp57QlmIKAGcMbitG9pdIS1PzmfGsIIGhcO0CuG47qpStxal2Ehjggcy8nv8cAh9LWzwAE/N46mxuA5MgrJsZ4Zg6UnM5/PMVD2thVCXs8GCMD1yHY+YSZxFSMF63vpR/XdD3NUNpPsA9xyp9iccXqc55HkL9GAp2WfU7buV36z8MhHYciLH3V9T3d0FWelJap1f4x+6Gu8EjLeeIIg6hAKSFUextt2qtF2y3bWIov/RIeMEGTfAqgmqjaBt2UBknmYtNRgKwI+jNM3zMSU/sOGbYDfTAA0VfmZ0Q9BdR2vI/W2UV0fhO45V2YdSvZ0oyWUPbCCfczuEes7VoXLo6xm/sdiiXZoEh2bGpAHmxKr0VCgBCFOgiov07MQwhjrUBVfhTwQSXPiOxjk9L6n5WPqJK7+XXmSe6tyjV7RCNHTiHYzLyKQ8HkNYfOfxe/7MB8NhPmfOfQpTdEKxhp5YDLlDpoRVZ0UIwvporMlPPJKqXVuZ4QDaiCUGjVJGKylYFYBcaor2ihhylqjOL4trLbjiF8M0PLBX4QW2/s/oO/3tmMfCaUeoJ4Fm0dyBd8QxMA7sD+LtSHJb5AGUBtT/g1qY+Y6ubbe3nYXxKkvg+7VvepRKyTdTtgA4eSoBhLHuOei0P4IsdQoJpWsQNESnU8VKgrgZ56cA0D6IH4n3qByCe90l2NjkwtaLwTJ3xfXIAB
 6eif6z/h
 EDYx3XXxPD1LJA3RtHQP2dxtZWgpwJ8BvQIgu05/NrOT1rDj9lSpTNTfPu7jhaGHKfQNtvnHYhDU6n/FWpct7H/jHzc5D0AUJlAjM4H1lJfASZdlwAfLC7qZL5gqTA/SWi3OoQMLIKUQrzas2lnnwHW3xg+Qke+Y9IQIAtwIMfyEelisUpeE/ZglVa1LZafjQ4No6JfAFF4+33bTfF/AzoWv7JAUOCFjgAVzFXOY/VtqWm8nSs/MJqEdv73d3Mr9/pXfyRSVSye0c1ffR9tsrnnMggbFDSGoGc2VvORgh7t175Ktk+JkWRiAq//etbVLGqxe+cjB1MZvrszZJt6msVpQ1U+IFoav3vV1BVtymHK+lsbWCluK4k5eqEAtQWn4mh1YLn6aRdLSx0M6p6irmrVX2uAtJLE5Qnk3zt/S7HsLt90GPhQA89KUkPBSSKHqBbLtvJjKXRzzu+3wdLgSiHj8Cnur+q01xgq6+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Split alloc_bprm_file() from alloc_bprm() so internal callers can build
a linux_binprm from an executable file that they already opened.
Add kernel_execveat_file() for in-kernel users that need to execute an
opened file while still using the normal execve credential, LSM, and
binary-format path.

Signed-off-by: Li Chen <me@linux.beauty>
---
 fs/exec.c               | 78 +++++++++++++++++++++++++++++++++++------
 include/linux/binfmts.h |  4 +++
 2 files changed, 71 insertions(+), 11 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 53f7b18d2b1ea..5b91a9b208a77 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1392,16 +1392,13 @@ static void free_bprm(struct linux_binprm *bprm)
 	kfree(bprm);
 }
 
-static struct linux_binprm *alloc_bprm(int fd, struct filename *filename, int flags)
+static struct linux_binprm *alloc_bprm_file(struct file *file,
+					    struct filename *filename,
+					    int fd, int flags)
 {
 	struct linux_binprm *bprm;
-	struct file *file;
 	int retval = -ENOMEM;
 
-	file = do_open_execat(fd, filename, flags);
-	if (IS_ERR(file))
-		return ERR_CAST(file);
-
 	bprm = kzalloc_obj(*bprm);
 	if (!bprm) {
 		do_close_execat(file);
@@ -1463,6 +1460,17 @@ static struct linux_binprm *alloc_bprm(int fd, struct filename *filename, int fl
 	return ERR_PTR(retval);
 }
 
+static struct linux_binprm *alloc_bprm(int fd, struct filename *filename, int flags)
+{
+	struct file *file;
+
+	file = do_open_execat(fd, filename, flags);
+	if (IS_ERR(file))
+		return ERR_CAST(file);
+
+	return alloc_bprm_file(file, filename, fd, flags);
+}
+
 DEFINE_CLASS(bprm, struct linux_binprm *, if (!IS_ERR(_T)) free_bprm(_T),
 	alloc_bprm(fd, name, flags), int fd, struct filename *name, int flags)
 
@@ -1901,6 +1909,59 @@ int kernel_execve(const char *kernel_filename,
 	return bprm_execve(bprm);
 }
 
+static inline struct user_arg_ptr native_arg(const char __user *const __user *p)
+{
+	return (struct user_arg_ptr){.ptr.native = p};
+}
+
+static int do_execveat_file_common(struct file *file, struct filename *filename,
+				   struct user_arg_ptr argv,
+				   struct user_arg_ptr envp, int flags)
+{
+	struct linux_binprm *bprm;
+	struct file *exec_file;
+	int retval;
+
+	if (flags & ~AT_EMPTY_PATH)
+		return -EINVAL;
+
+	if ((current->flags & PF_NPROC_EXCEEDED) &&
+	    is_rlimit_overlimit(current_ucounts(), UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC)))
+		return -EAGAIN;
+
+	current->flags &= ~PF_NPROC_EXCEEDED;
+
+	retval = exe_file_deny_write_access(file);
+	if (retval)
+		return retval;
+	exec_file = get_file(file);
+
+	bprm = alloc_bprm_file(exec_file, filename, AT_FDCWD, flags);
+	if (IS_ERR(bprm))
+		return PTR_ERR(bprm);
+
+	retval = do_execveat_common_bprm(bprm, argv, envp);
+	free_bprm(bprm);
+	return retval;
+}
+
+int kernel_execveat_file(struct file *file, const char *filename,
+			 const void __user *argv,
+			 const void __user *envp,
+			 int flags)
+{
+	const char __user *const __user *user_argv;
+	const char __user *const __user *user_envp;
+
+	CLASS(filename_kernel, name)(filename);
+
+	user_argv = (const char __user *const __user *)argv;
+	user_envp = (const char __user *const __user *)envp;
+
+	return do_execveat_file_common(file, name, native_arg(user_argv),
+				       native_arg(user_envp), flags);
+}
+
 void set_binfmt(struct linux_binfmt *new)
 {
 	struct mm_struct *mm = current->mm;
@@ -1925,11 +1986,6 @@ void set_dumpable(struct mm_struct *mm, int value)
 	__mm_flags_set_mask_dumpable(mm, value);
 }
 
-static inline struct user_arg_ptr native_arg(const char __user *const __user *p)
-{
-	return (struct user_arg_ptr){.ptr.native = p};
-}
-
 SYSCALL_DEFINE3(execve,
 		const char __user *, filename,
 		const char __user *const __user *, argv,
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 65abd5ab8836c..c0715678c9a06 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -141,6 +141,10 @@ extern int transfer_args_to_stack(struct linux_binprm *bprm,
 				  unsigned long *sp_location);
 extern int bprm_change_interp(const char *interp, struct linux_binprm *bprm);
 int copy_string_kernel(const char *arg, struct linux_binprm *bprm);
+int kernel_execveat_file(struct file *file, const char *filename,
+			 const void __user *argv,
+			 const void __user *envp,
+			 int flags);
 extern void set_binfmt(struct linux_binfmt *new);
 extern ssize_t read_code(struct file *, unsigned long, loff_t, size_t);
 
-- 
2.52.0


