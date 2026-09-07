Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91019C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 21:08:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DE416B009B; Mon,  7 Sep 2026 17:08:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B6636B009D; Mon,  7 Sep 2026 17:08:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CD606B009E; Mon,  7 Sep 2026 17:08:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 462666B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:08:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D2A5D1202CD
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:08:32 +0000 (UTC)
X-FDA: 85188204864.08.BF3EEDA
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf15.hostedemail.com (Postfix) with ESMTP id E41F1A0006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:08:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=b3BlheRS;
	spf=pass (imf15.hostedemail.com: domain of jannh@google.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788815310;
	b=IqbyOW1cWSo9yLpncxmUBDu2fVbo4wvpH6sMK/ooRgEaWukt55n+Rk5xmvX/2pGXbSAPtJ
	haopYC0H/xe4B/Rqe2NfT4S6kH7opXovdKh0vWzUwvnu7xfZFaa32SxJyaFqWBmyZfVC3u
	c0DzZWZAHwmf54GSzKeQUscJLfPAEGY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=b3BlheRS;
	spf=pass (imf15.hostedemail.com: domain of jannh@google.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788815310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=opljs6/yePkUAePwO+BlsImVeSdvbWETq0V3zNfopXk=;
	b=5s3f604lMLzB1p00Gj2KI0qekeHHepQWn1xZS78iLOcGSjDYVqOgJvWa9ZgEznpwVrlnnN
	IlWbXXIzeyEsGlX99ltxdioTWDS9oS/D2419gMOBwMCutmM3X/5Xa0bKorDSnaGzXt8ljJ
	8XkkM3OcmTqH2ClkIwuljYFOaaqKDSw=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b5e50eb70so63405e9.1
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 14:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788815309; x=1789420109; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=opljs6/yePkUAePwO+BlsImVeSdvbWETq0V3zNfopXk=;
        b=b3BlheRScfb0gIqIIfkZxRQB2/d/D6O5UuwGJ/GezHrTOvYNZyMFWdpX4Yj1KbKtHG
         38O9+8ROXI88gnz9RRdZ/vqd8JxpRoKTxLI6ZFgHRrlV2hpqaoxdEST88Vs4QW5fwJE2
         fFIQ2dPjAY/ATgu3VT2tHrnTSUulW/D2sGVm2l20dvmTFh1q3mYDCoRHT5hn7OADeU9C
         6xJAO7xP7AMzLRpRL+/URrHe+C/3LVBrjucv2Q/W8jwzRQLbsPTFPWsRr09si8K1U39D
         xEDTMLOQByLBWqucJ8FAEmj3fgwp48ZVUNT46OKY08G7DD8+fdKKJR0+ZXl/ts4iTsX5
         Yrcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788815309; x=1789420109;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=opljs6/yePkUAePwO+BlsImVeSdvbWETq0V3zNfopXk=;
        b=dmyHhweG3GFRzu8YGQt5ipocQEpZ7j9w2LVjVt1CRBxB0Uuk6jUHOdRyDaIcx4JY0I
         8BU3XQY/lvqYGXJaWzBdnCU3zVn5hvPVb65guYaIBwYcvUtifMDnij6nGgez3ZQTAZxD
         p6rUu7r9dwYjgctueF0S+KBMRckNw2sWI+QjIXYvllO/VHKdfV1LposB+X9Qt0n8h4Vz
         Z9yc4La0pKdlVYi3uJsVRBHfNcyqOo2uTq0Nhpszd/NN3IJZao/o1yGL5r2QsYBx6nhd
         85ml+FsOnGBdgsz+z4vmJ0OHwCGbi0H5sF6H8TNLA8Tvrgcu/4VwzPDOrq5kyrFZtt/Z
         4mEg==
X-Forwarded-Encrypted: i=1; AKwUvBxHuaqjwYsVItIIDEyIZksxUedzmB3BSR9XX0eMaHLKJIfsqFcoJFJrRdfJvRwXxTHO5NOehiEoUg==@kvack.org
X-Gm-Message-State: AFuF++lQb7M6NZ+zlDyHHVcbo6NLPL4tHglueUcMNUpfHDTJl8tQBulM
	5mR+eQHkg+xhf8aJ4RJpAG1ULVaSW3CxYFjY7j8t1Fzqof4Rv9HGMOhd+n23L65lr7+xB6k1Bm9
	xGSKdHvfs
X-Gm-Gg: AYBFou3OjpENW7A2wQmKud/SWLCBanZ5l+kDwrutr22WNHBSmrTN6XiDkz5bjfkV/6s
	eCV94fGcpfUxZheLXYDhiuEcPG26trgSE3FTxtnLyl+jo4etXJszNIzn/0aUDQ9RmQyPe1gXMdQ
	74eydsDtqP1Da606056LTf7Y09mBZpk5sa1C2AIW3KxT3xMmGV8xKUVAzZvEvRSjPi4lnoa/kAq
	0dsx+qJQ7UOgN8HV5mGb+VKaoCiCWO85SZUdTMBayel+NvToRfs3wBoHaqOk+EpyMU8l4Y70yfd
	uFGLx8ktqPykiRdGYKIBqr3j5cOsvf7jF90sqi50GgWzadUeuQ8qDCXF5wNlmHW+hqRZnNQ+1At
	0Q8Blqg1Ajf4GVZJunXifmFfy5dRtz6ANHuicjtwEP3E5Ac7sT6McrNRdU4n5WWbcTG3axx0OAD
	tZ1n1lwVUm1cX39OQNI82OfnGixa3q4BWE5oMzaMaim6hB/TKU+UBEPGN2OHkQQpvE7Gpyx1ee9
	ze388Ub4GUFKiTnxjI7pgeqEGKfLNa6/udaSr3FJ9wgZ3xt6AgLeLaXUBs=
X-Received: by 2002:a05:600c:2e56:b0:499:c46c:adc7 with SMTP id 5b1f17b1804b1-49d17a6bf78mr222815e9.2.1788814828327;
        Mon, 07 Sep 2026 14:00:28 -0700 (PDT)
Received: from localhost ([2a00:79e0:288a:8:437c:9ac6:4a41:e58b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4858bc74298sm27752481f8f.6.2026.09.07.14.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 14:00:27 -0700 (PDT)
From: Jann Horn <jannh@google.com>
Date: Mon, 07 Sep 2026 23:00:17 +0200
Subject: [PATCH v3 2/3] proc: query LSMs for introspective mem access (if
 PROC_MEM_FORCE_ALWAYS)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-selinux-pokemem-v3-2-0bafbaeafe50@google.com>
References: <20260907-selinux-pokemem-v3-0-0bafbaeafe50@google.com>
In-Reply-To: <20260907-selinux-pokemem-v3-0-0bafbaeafe50@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788814820; l=6147;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=dFQPLUrKSushQVlRIfa3+RqE2BxwwVdKHC0sBsQHxRE=;
 b=bGUXccOwcnRIhUpKEynLue6/VH0ISEjKrC+KubetQgYKUv6i7R6h/X7out5N5Yn9is7rXXonE
 38A9kIG8FRAB8evQRsnCLY8MGW1KQbFnMcLRddZZ8sHGqBcSRsMN0G9
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=
X-Rspam-User: 
X-Stat-Signature: rjskjoj7a5fn3sqbxyni9c38oxxjnmko
X-Rspamd-Queue-Id: E41F1A0006
X-Rspamd-Server: rspam06
X-HE-Tag: 1788815310-145645
X-HE-Meta: U2FsdGVkX1+2a8vmnlr43YJqYM0akxiX1D4zhn7QNTqWqN+LG1L9BwuwE7rHgFCT+fai5lmp1+ApPg949S8LxWIlAwE5f0a4A8M++XGAoGzquISIMbTmITm/yeYM4yKkDTn5W0e0OGw1ezIuvhUg4V5RpvAlIsn1eRZ4obYrLHhQRoc1NWBPu2Uli4CajSgbtcUrtShVHXHpLhAcC4AOAaHPaT8CTwTfM8rf658T1Rwty6wk588U38k65vfZ5QyYL+WTqM2FW29hlgrwNXrEcFJJyOKttzb6+/6cQp6B5+JKBAWazs1aMaD8vlyN4jPj3FlQL+7fLGV8M67FAbI0ejU53Lg1y6y0DCzcOlbcNh/ymQrIyXywEgnEY5+YIIFGUlUbSb6jWSpkd0Zc9VSBxi9xSwIqGbdlKco8wRcWre/vQHZ62y/In29VwkGggaOM8yKdneaR/sfOzdT3ZozAM6hYRJDsTB2c60QcnxS+Azy0j0mRXKSKUNN+ncuReCRV3nJGTW5Jcnl9i+1iF/21akEqKzupZ/IIgwymmOxl+Ezdq+0X4xlJG6BAZyusR1x9ZFgbKNwdPPksx+w8OE758feuyCZEuatRxfTA9fvLUM8loVSqUU3Gxpt5/OyYm02Fo0OpRzOXhcEwYvkb5z7MYLv53oBehM4CMVd37vO9u4yUqyT91yUjeHf4G7S5OEX/G6B3J1k64Nu6SGKo1lexAtENCfjHkRcRbItMQO0i2ZQ95HIOR2knJy0r2bF8/BbdEiQH9/Maug3quPQY8W/KCNgvIgCy0OV2dQhG7inmZIIFFKuCzLC6hnjAVGZRIQQpwS1PvpOwqCl/6Q3HOkGRQLYRlYTOwbJWDxjf/zLiBybvI3ZM9RyW7seJxgYhbOgCo2G8Q3ZMEzCqDnVc/Gyo54ZW3QALVCAjQzJCHZkjamllKaOuwNClWWnZgqvbYTHMLBvjvbthWrLUNWE5E0u
 Dt6oxy4l
 m2gQ8c6teGHYzsbvbM2PJjSQQlk+lf2oUXcXA0eDMa4fsFq+oXl5u3pQLtY9xCNslESLsmCHBbi2Uyb/el4rsnhfbJxeJMI8lm2i67zk9RoAG4yIoAkQhrWEVgY1+gTqyhtJ5Qq83cewPaQfWLNXSNbO5orQ7uD3EJhF2/Y+bVk9kr1gXHwGZlXGqAQPA+wJmYuSuFASrLuL4ohLsAKLhKCgj69Vobvi91StKK8zMG1Wapa1RhG9OaNvmkCN8NN73wy8Tv6mWWk0IaVcEqA3G8gOQVvmyIy0D7wibOZ7h5AHjhgMUUiVHOvJZEkLDLk2bmyO1kdjQF2PJdMVxGT89i90G3Sh0DkxxtmPasSjs9d20EQLsQp/X19EB1vgfLdAhEiVm4KerP5AVDqcBu9HlhI6Ma3+MYzQmbwumXaj+q1xf2suX7v/D8qRrP+gJrzii1dYNZahA0fEGEVb8otQg6iDv4OTF4s9X1RVHYDOX4X/yXS2xxxYxcwnlPVIFZhV3U8Zv3KYoN5IIZUY=
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

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Jann Horn <jannh@google.com>
---
 fs/proc/base.c                | 14 ++++++++++++--
 include/linux/lsm_hook_defs.h |  1 +
 include/linux/security.h      |  7 +++++++
 security/security.c           | 25 +++++++++++++++++++++++++
 4 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index bec6197329dc..295b21203c7f 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -851,6 +851,11 @@ static int __mem_open(struct inode *inode, struct file *file, unsigned int mode)
 /* private_data for proc_mem_operations */
 struct mem_private {
 	struct mm_struct *mm;
+	/*
+	 * Was the ptrace access check on open bypassed because the opener used
+	 * the same MM (introspection)?
+	 */
+	bool opened_by_owner;
 };
 
 static int mem_open(struct inode *inode, struct file *file)
@@ -864,12 +869,14 @@ static int mem_open(struct inode *inode, struct file *file)
 	priv->mm = proc_mem_open(inode, PTRACE_MODE_ATTACH);
 	if (IS_ERR_OR_NULL(priv->mm))
 		return priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
+	priv->opened_by_owner = priv->mm == current->mm;
 	file->private_data = no_free_ptr(priv);
 	return 0;
 }
 
 static bool proc_mem_foll_force(struct file *file, struct mm_struct *mm)
 {
+	struct mem_private *priv = file->private_data;
 	struct task_struct *task;
 	bool ptrace_active = false;
 
@@ -884,10 +891,13 @@ static bool proc_mem_foll_force(struct file *file, struct mm_struct *mm)
 					READ_ONCE(task->parent) == current;
 			put_task_struct(task);
 		}
-		return ptrace_active;
+		if (!ptrace_active)
+			return false;
+		break;
 	default:
-		return true;
+		break;
 	}
+	return security_mem_foll_force(file->f_cred, priv->opened_by_owner) == 0;
 }
 
 static ssize_t mem_rw(struct file *file, char __user *buf,
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 65c9609ec207..12f84a1e6fab 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -36,6 +36,7 @@ LSM_HOOK(int, 0, binder_transfer_file, const struct cred *from,
 LSM_HOOK(int, 0, ptrace_access_check, struct task_struct *child,
 	 unsigned int mode)
 LSM_HOOK(int, 0, ptrace_traceme, struct task_struct *parent)
+LSM_HOOK(int, 0, mem_foll_force, const struct cred *subject, bool opened_by_owner)
 LSM_HOOK(int, 0, capget, const struct task_struct *target, kernel_cap_t *effective,
 	 kernel_cap_t *inheritable, kernel_cap_t *permitted)
 LSM_HOOK(int, 0, capset, struct cred *new, const struct cred *old,
diff --git a/include/linux/security.h b/include/linux/security.h
index 153e9043058f..e8bc2e644241 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -338,6 +338,7 @@ int security_binder_transfer_file(const struct cred *from,
 				  const struct cred *to, const struct file *file);
 int security_ptrace_access_check(struct task_struct *child, unsigned int mode);
 int security_ptrace_traceme(struct task_struct *parent);
+int security_mem_foll_force(const struct cred *subject, bool opened_by_owner);
 int security_capget(const struct task_struct *target,
 		    kernel_cap_t *effective,
 		    kernel_cap_t *inheritable,
@@ -676,6 +677,12 @@ static inline int security_ptrace_traceme(struct task_struct *parent)
 	return cap_ptrace_traceme(parent);
 }
 
+static inline int security_mem_foll_force(const struct cred *subject,
+					  bool opened_by_owner)
+{
+	return 0;
+}
+
 static inline int security_capget(const struct task_struct *target,
 				   kernel_cap_t *effective,
 				   kernel_cap_t *inheritable,
diff --git a/security/security.c b/security/security.c
index 71aea8fdf014..2cde1efdb7a6 100644
--- a/security/security.c
+++ b/security/security.c
@@ -595,6 +595,31 @@ int security_ptrace_traceme(struct task_struct *parent)
 	return call_int_hook(ptrace_traceme, parent);
 }
 
+/**
+ * security_mem_foll_force() - Check if FOLL_FORCE is allowed
+ * @subject: credentials using which /proc/$pid/mem was opened
+ * @opened_by_owner: whether checks on open() were bypassed because the opener
+ *                   has the same MM as the target
+ *
+ * Check if FOLL_FORCE is allowed for accessing process memory through
+ * /proc/$pid/mem. opened_by_owner signals whether the opener's MM was the same
+ * as the target MM, meaning the security_ptrace_access_check() hook was
+ * bypassed on open().
+ * (Current current->mm does not matter for this; for example, if write() is
+ * called on an FD that was received from another process which obtained it with
+ * open("/proc/self/mem"), @opened_by_owner is still true.)
+ *
+ * Note that this hook is only designed to be useful in the opened_by_owner
+ * case, where the subject credentials effectively also describe the object.
+ *
+ * Return: Returns 0 if permission is granted.
+ */
+int security_mem_foll_force(const struct cred *subject,
+					    bool opened_by_owner)
+{
+	return call_int_hook(mem_foll_force, subject, opened_by_owner);
+}
+
 /**
  * security_capget() - Get the capability sets for a process
  * @target: target process

-- 
2.55.0.1003.g10538fe699-goog


