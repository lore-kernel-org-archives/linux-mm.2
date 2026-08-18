Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 944EBC5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 19:51:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0804C6B06AE; Tue, 18 Aug 2026 15:51:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0655D6B06AF; Tue, 18 Aug 2026 15:51:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3B1F6B06B1; Tue, 18 Aug 2026 15:51:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B3BB16B06AE
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 15:51:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2F0BA1C1045
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 19:51:46 +0000 (UTC)
X-FDA: 85115435412.24.FB2EEC3
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2D3B820004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 19:51:44 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XsL5kgGE;
	spf=pass (imf31.hostedemail.com: domain of jannh@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787082704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/48NguWRU9bZx//FrJDrEgNODvcpOLG3InPhFqPXnRg=;
	b=qAYMg4MDBMqWFGVWl7pa/OdH3LRIvuEYY2jiAcyO/DyXD0zfpw+5W3Pvdj/1G+jkJuVWeZ
	5HkzH5CRfdI/03jtHhLImY5bE/ZtgP0rsuqTxA3m16eRg8GShVesy94RzHH0hdM7+4j0fZ
	lYzSZttWy+Ik3MbMd2fzgWzK/3wV1HE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XsL5kgGE;
	spf=pass (imf31.hostedemail.com: domain of jannh@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787082704;
	b=R2AqxeXzXENgEaFtuSgBV5yHbT9Tmv8TuDKf7gyq6P6Wk6baCOpeFbikYhDt6N9Qt6Xw3z
	sc1L8ON9zN76DySn5x2Oa10p/amulVt1ETkSkcUer1e7TuW6hHgOtzV7yOnbfyG9EtNw8W
	7Pm2xCjrfv4oAFlv388x/Ko8Ln0nvaA=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4996e2575dbso2935e9.0
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787082703; x=1787687503; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/48NguWRU9bZx//FrJDrEgNODvcpOLG3InPhFqPXnRg=;
        b=XsL5kgGEu+MWVa5Ht8bvVpIdSA9Er2ZnlmR1pWfAHntUVjEQJ9Wb1zKJOXAs2cemFb
         +Kv2mNXSWx5KJyspNLPFcXIh34TMkSWzi+FvvXP4gWVrPFDDAtPqBT83tdpKMQUEYSRh
         J+A1lEUCiOJYH5wjjLNsgZTYEW9rMf9F7kr36KIXRrzQ56CxKRADsY4umu8eTCVrr4LH
         kuJQ3LvVPmctLfRRkXgMyxRSTA7+d7bCr6o5tB3sNnOkuy1FJeFZRLMNswx4jnIWkbln
         wnuNAsccIo4CCUcBNQr2SjTy+ONczuw99VRo/Ep+lmcxHHOw5bgW+fBwvYTkEsozoxMd
         pwrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787082703; x=1787687503;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/48NguWRU9bZx//FrJDrEgNODvcpOLG3InPhFqPXnRg=;
        b=AOlMBWK/KCOvQaCyW2lzJR9vkW7g/WEUeevUm4uMn49R/PDcVdMu/UL8R2mrfTt1Bq
         JKh/J3vPHjVmEeSD8o7ld1yM1fn0+mj7BGvHlADxfifFOsG4+qoEKPvYP4Wx7n8iJXY7
         HvTWyadTHKKmV3N7FXbxiobd6qVhXagpHSU+8gKnZpNVhea08L7caPSpatY8tuNh3Yi9
         hoSdxpAMtVSd4vD3r3pF04QVQGk2CRVYxJtsrZq/eQNVT8EPXQmPgfRGp3DWIZm6FRyW
         +4h66U00LLNzrbfspz2RY+/bSAo+P/wt+EI6hK5bi81JEer9v/FIaU3HFMRwTb+YXvuO
         MJkw==
X-Forwarded-Encrypted: i=1; AHgh+RqBTmE1q3ukuabIq9fKrBu+yq7v029MGiD05J5ebON26AYao9Uvu8lSAMqEiXY6xlNoCvV9SxUEsw==@kvack.org
X-Gm-Message-State: AOJu0YxlAdzDZZsNk/A4oa63AqdDkRdcFg+IC+PM6g9rt/VVrkGg1KRz
	Tcak/UzR2ebT/5ydqkItmwY/gA2MMXbhMCvARifnCjtSnoEkN7HVnv4UcJIOhhFMxA==
X-Gm-Gg: AR+sD105wgJp2LNu2bHd6SoKk8PQsDhWDhMvPFoGlrTaiEiEgbjEmSu/wzfj0gsvTyt
	GCbh1L9+ADCCfT6LNE1u7jxU9pgOCx5J1iaGlKPYApcVfYetmE7dwuU82zSJeV6On8asjv1IXBj
	2c+BNjAZayGuKJwIK7kMJumSFaVhyqOfMM2WxCDIwEU4wGOL929O/gXLFq1js2pxmt1ajspfmUR
	joLRZofXBXIjLjceOp20Yx+WFsGptX5o184tdCd5cJJf/LXchBMwpipaeIQDRhhFsd/rQMY1bJK
	JFu7nTCpOvlx6le5tDoB7aaqmXByGpZicptQOnN90/gggvY1MG8A8JN9k35jSYswjr+Dm+4Gw4E
	Bt1NvsDPjhS4dFf1XQMlF+9PJwQForGb01+kE9lK0ZO152Xob3/UL4YulXEzBi3RRfXtIg89UfU
	3Suws1HEYM08L0vt25G2jEuSxpPJSnd8W4UvFxXqeuNhbwld3+3gfBi/CJblLseHGgjLf9pK1Ew
	+TvLByxHPsuRWzxQPAg1+kk8Xnb9wjKKJo0Jfnx6KDYUnWI
X-Received: by 2002:a7b:cd0c:0:b0:493:a96b:f9fe with SMTP id 5b1f17b1804b1-499a9574768mr34305e9.4.1787082702506;
        Tue, 18 Aug 2026 12:51:42 -0700 (PDT)
Received: from localhost ([2a00:79e0:288a:8:f466:5a15:1301:318d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482a5a3b896sm14946986f8f.16.2026.08.18.12.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 12:51:41 -0700 (PDT)
From: Jann Horn <jannh@google.com>
Date: Tue, 18 Aug 2026 21:51:06 +0200
Subject: [PATCH 2/3] proc: query LSMs for introspective mem access (if
 PROC_MEM_FORCE_ALWAYS)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-selinux-pokemem-v1-2-90cd2357ee05@google.com>
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
In-Reply-To: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
To: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Jeff Xu <jeffxu@google.com>, 
 =?utf-8?q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
 Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
 Jann Horn <jannh@google.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787082694; l=5164;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=9uHRP1QAod/qRgNxXnmI4WhcZ+rp1J5wXAIzmWkxjdk=;
 b=QhCD/dpVyuHUA59IInGgknlAukZUxr309hmljE5BsC20XSQv0XHxJumcEMH0epWxltedJEorj
 9o+qlp6IUXyD/NlvzGKNvAyNi+iK04kMVoV2ZDdmCLoy/D2vjaJ0P/7
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2D3B820004
X-Stat-Signature: pqa8jdq9t336uiompkb1a8guif8xhf8q
X-Rspam-User: 
X-HE-Tag: 1787082704-673781
X-HE-Meta: U2FsdGVkX19/hVrWpACNmR/v5fWyO/nOQEJ/3JzOtKkN5wdzTOaTXVFGCaSmEGkEG6nttOMXmIOvfzlvEVX9IK+WV6FJ98P4zrB9aaJ1RosfMst0t7qUCq6Y0mc+IMOUktlej+a7lq/kqfXd+Tpyz65BWfLDHUNFDDt9B6kcPSEgZBYvxKjsvgd6JihHNbxWJcL4R2WDW2eBEoQ//rQV2I5taumJmusU/60xhGxD944+NAkmF0Br7ycQ42Gicd4lWQ5y2WzVhcQkwS4Uk8IYSOqeozySs0bqV3RV4x3psY2KRtSvF57slbheoxUcR0ETdbTKdGowaxT9pdc/bJozWX4sQ3nsiVUpV1nj90dbfilgxsTs+uPcOmFaNY5LQjM0Pn2mm1NnBeIDJ96NScgLCk5H9QaRDvL7WBiKUgxMwAI7mkj+PkPpdGYmIQArFF3fWV3TrXYfe9moZIIzOdkDgvEd7yYZTMf0zqffad6gKWCRFDzAK2aubzu5jGzPyFmuvRFCRavJfDe79Ccv8p16nDmP/PzXgbpiKNW9ci1t44B8XQhV3j2VDGR/EUfGZecQV0Pu6v/d4GbUargChh3SPdXA8yCFcq/bU5KoA/K3B2apXtDLgMXEDusUan4xeBEP57agUJdi1U4teIfAFlUVZEQOBbG566d/EjVJspYaMmWU/MfeI1JOzDtmVQO9Ds/r/CXzGo3LxAv16Ev4poN6baULYld0e4ztuBLz1gjFQVFV4dP3+M5JKh8+Nlo8IL95Fq4eYc+UkEyNsYX63NqlgZnSQ5+d/esQYerSTElVegcEcXJpKCXRtn5y+S5J6f3sWDi7en9UUG1RSBNcXRzm5lvqK+8eYvirrvyslZegTPWGTgrGE7ZFWE8f/nza4eWGi3ZZDkG8TVHlLG302hgNnAlS5UwnCl03E2FLOhMeDRyYs1FN5HSnuz+PjgcsiKJYPtNiOSuON+A+T4phKhe
 ttnBCNR/
 YF8NBJwWeKa72YD8NBooQja04GfdZe4Xg77pX0dZ9zgJDQ27/kcdlcj5SaEzCdCytjW2sTmgDw+TWgmUS+4CEZe204HB2kYph8xN/WI/L/QAuhfAqTRe9ussM1jmitNkGAMqvlfob6mtc8QVnZyYKfJDClT3IIj6cJCL+J5H0eQmZ9o0MJYhCTlc29Km/p8NJPpAj6Zo7PhR+vNFtgZts1T+1ooxkTrD1OZ1YjrjflwNtwA+pDHCXVA0fBD61huLzxmfdP652TFioKll7GR1dijAyM0rUzr782xGvYBOdbp8na5k5YRF8/TpALvTGQ8yTJQjpE/cPvMVN+c64pqziCkTHPjQVGdQXNOP5cZpJISr1fZPy0FOWFJFg12aeYSmniLu7tl8VodOoywuK12SFtALUCephir4gJgDwNXUrF4tqAdwB03MpD1tBoIVf0joYFRJz8HAZIZbCEhhe4KJARFqZVeGHMB44E0QiR8VrnAxUoIqgRdnSn98Tiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If the system is running with PROC_MEM_FORCE_ALWAYS, LSMs currently have no
good opportunity to block a process from overwriting read-only code in its
own address space through FOLL_FORCE writes via /proc/self/mem.
The security_ptrace_access_check() LSM hook is bypassed when a process
opens /proc/self/mem because this is considered "introspection".

This causes a hole in SELinux EXECMEM enforcement, which tries to ensure
that a process cannot create executable anonymous pages.

PROC_MEM_FORCE_PTRACE prevents that and ensures that such FOLL_FORCE
accesses are only possible when the LSM allows ptrace() attachment; but it
is unclear how quickly PROC_MEM_FORCE_PTRACE can be deployed in
environments running lots of third-party code, such as Android.

So, introduce a new LSM hook that can forbid FOLL_FORCE specifically for
such "introspective" accesses.

Signed-off-by: Jann Horn <jannh@google.com>
---
 fs/proc/base.c                |  6 ++++++
 include/linux/lsm_hook_defs.h |  1 +
 include/linux/security.h      |  6 ++++++
 security/security.c           | 15 +++++++++++++++
 4 files changed, 28 insertions(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index bec6197329dc..3dfaef49bb70 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -851,6 +851,8 @@ static int __mem_open(struct inode *inode, struct file *file, unsigned int mode)
 /* private_data for proc_mem_operations */
 struct mem_private {
 	struct mm_struct *mm;
+	/* Was the ptrace access check bypassed due to introspection? */
+	bool introspection;
 };
 
 static int mem_open(struct inode *inode, struct file *file)
@@ -864,12 +866,14 @@ static int mem_open(struct inode *inode, struct file *file)
 	priv->mm = proc_mem_open(inode, PTRACE_MODE_ATTACH);
 	if (IS_ERR_OR_NULL(priv->mm))
 		return priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
+	priv->introspection = priv->mm == current->mm;
 	file->private_data = no_free_ptr(priv);
 	return 0;
 }
 
 static bool proc_mem_foll_force(struct file *file, struct mm_struct *mm)
 {
+	struct mem_private *priv = file->private_data;
 	struct task_struct *task;
 	bool ptrace_active = false;
 
@@ -886,6 +890,8 @@ static bool proc_mem_foll_force(struct file *file, struct mm_struct *mm)
 		}
 		return ptrace_active;
 	default:
+		if (priv->introspection)
+			return security_introspect_mem_foll_force(file->f_cred) == 0;
 		return true;
 	}
 }
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 65c9609ec207..67452f71bedf 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -36,6 +36,7 @@ LSM_HOOK(int, 0, binder_transfer_file, const struct cred *from,
 LSM_HOOK(int, 0, ptrace_access_check, struct task_struct *child,
 	 unsigned int mode)
 LSM_HOOK(int, 0, ptrace_traceme, struct task_struct *parent)
+LSM_HOOK(int, 0, introspect_mem_foll_force, const struct cred *subject)
 LSM_HOOK(int, 0, capget, const struct task_struct *target, kernel_cap_t *effective,
 	 kernel_cap_t *inheritable, kernel_cap_t *permitted)
 LSM_HOOK(int, 0, capset, struct cred *new, const struct cred *old,
diff --git a/include/linux/security.h b/include/linux/security.h
index 153e9043058f..f8483be58bc8 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -338,6 +338,7 @@ int security_binder_transfer_file(const struct cred *from,
 				  const struct cred *to, const struct file *file);
 int security_ptrace_access_check(struct task_struct *child, unsigned int mode);
 int security_ptrace_traceme(struct task_struct *parent);
+int security_introspect_mem_foll_force(const struct cred *subject);
 int security_capget(const struct task_struct *target,
 		    kernel_cap_t *effective,
 		    kernel_cap_t *inheritable,
@@ -676,6 +677,11 @@ static inline int security_ptrace_traceme(struct task_struct *parent)
 	return cap_ptrace_traceme(parent);
 }
 
+static inline int security_introspect_mem_foll_force(const struct cred *subject)
+{
+	return 0;
+}
+
 static inline int security_capget(const struct task_struct *target,
 				   kernel_cap_t *effective,
 				   kernel_cap_t *inheritable,
diff --git a/security/security.c b/security/security.c
index 71aea8fdf014..d0f790a534eb 100644
--- a/security/security.c
+++ b/security/security.c
@@ -595,6 +595,21 @@ int security_ptrace_traceme(struct task_struct *parent)
 	return call_int_hook(ptrace_traceme, parent);
 }
 
+/**
+ * security_introspect_mem_foll_force() - Check if introspective FOLL_FORCE is allowed
+ * @subject: credentials of the process accessing its own memory
+ *
+ * Check if FOLL_FORCE is allowed for a process accessing its own memory, which
+ * bypasses the security_ptrace_access_check() hook.
+ * This is only used when the system is configured with PROC_MEM_FORCE_ALWAYS.
+ *
+ * Return: Returns 0 if permission is granted.
+ */
+int security_introspect_mem_foll_force(const struct cred *subject)
+{
+	return call_int_hook(introspect_mem_foll_force, subject);
+}
+
 /**
  * security_capget() - Get the capability sets for a process
  * @target: target process

-- 
2.55.0.737.g08866a6d13-goog


