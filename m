Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CB2CC55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 12:54:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D2BC6B00AA; Mon,  3 Aug 2026 08:54:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95C7C6B00AC; Mon,  3 Aug 2026 08:54:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 788C06B00AD; Mon,  3 Aug 2026 08:54:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E15696B00AA
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:54:38 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ACD7CC06D6
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:15:27 +0000 (UTC)
X-FDA: 85059853494.05.15A23F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id BC97740008
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:15:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FwEjg8yt;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785759325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D2Rl97NSLMDDjgLpCbEgbfCYGpNmImEFbOqRGKOWqHs=;
	b=RWc7hjoWO2uJj+xDUr0s+JNc9gdyYVfx1utKQtLtoJSRB+o62qhA9mE65EJO5HZHIIOT3M
	8tebH6+YnP6pbZpgMGCW2xseBBinCw+EQG7yTRM/lhYV+VCizvRczw5mHMaKwJi6QA5gvn
	cd7xhzT1bH0fEfXZb1Qi4+pOyAdRNnY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785759325;
	b=TiHHkycM/UbZCFf39XEfPC0sC+LwLQzcFtiFzsW7uOLcpiCTu+ajAG/FCVrI5P1NAsPd2G
	2R/PqfUoA9vcx+4iQWX+qClTH94LaWZ687TLPXuwuvqTNokKeT8MbtpE1KlQ8gBrhZT3ob
	+kveYDpkNeiNSO4pm6yQ4YQ/3gwazYU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FwEjg8yt;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B0934033A;
	Mon,  3 Aug 2026 12:15:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14EB91F00A3A;
	Mon,  3 Aug 2026 12:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785759324;
	bh=D2Rl97NSLMDDjgLpCbEgbfCYGpNmImEFbOqRGKOWqHs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FwEjg8ytRRjlCirzGeKDlrIae4cstHl9EMKHUG9MCKw2DQsRDi3lPKQrVIohza5Uk
	 wu9Q4eDBAQfi+hojiTZnRFFKSdaED5+Ef2oBKjWEr6V4pdaj4kfjM75bIay4QsHg6/
	 CnhZDZ0io7WIa0cRCyS6qwS2L3+5zxg0wi2h5nMpNicFipa97ojwaiPdM73ElcNL2j
	 RYFOJ3dSMsPWT+WMmPefyEsL6r3o+EIa7qvsMPUMH3UbsGUcSjTNsZwnku4xVCC3fB
	 TQtsAyqQI0cMRggVIF0zk2wvtt6q10NWnXlOn3qtgeQ92qLEDwtm4YYT0HisHDUeNN
	 WtXKhrxDB2wKg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 03 Aug 2026 14:15:00 +0200
Subject: [PATCH 1/3] binfmt_misc: correctly account pre-opened interpreters
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260803-work-binfmt_misc-interplimit-v1-1-4a2435500bd9@kernel.org>
References: <20260803-work-binfmt_misc-interplimit-v1-0-4a2435500bd9@kernel.org>
In-Reply-To: <20260803-work-binfmt_misc-interplimit-v1-0-4a2435500bd9@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com, 
 mail@johnericson.me, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-f2f85
X-Developer-Signature: v=1; a=openpgp-sha256; l=6690; i=brauner@kernel.org;
 h=from:subject:message-id; bh=PImZ5+k3jMoTX28E8qhoeuXRjw+pYMUOFIcPhrFW/TM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQVtIVlzhR44CkpLMZ09H5Gvth/iwjeXYWypeln6vmiF
 J+kRRZ3lLIwiHExyIopsji0m4TLLeep2GyUqQEzh5UJZAgDF6cATOShGCPD/Zyu+x6LNDlPT5dN
 TLtkJ3ticdjDjSvfP1P+xNAW8vKgMsNPxk2n5Se6J8z6uPHeZya7fxw5nGYSz7S/Lbz8oXqqwJT
 FLAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BC97740008
X-Stat-Signature: puxm31m3ks5pn34nefiuf1du4a3jbwya
X-Rspam-User: 
X-HE-Tag: 1785759325-983175
X-HE-Meta: U2FsdGVkX1+EY0hmrxC1uyctUjFzA1VZ0BJIGUfbfOMVe5RqPu03hzBgLc1YN14BRJ3csaHvqhWi9uqNv/aywIKy1V9A3MH52LA893OHhc0JksA/fCk9QPjc6p3ARc8Bm1u1FxY6WVXT3TNnxaOPHSCHwCapvuzZHoPEHVyOTyxR7Qqbk/CMvIXoSiAwwj9UtlErO2TQXfZg+RGz8i9zoMPlewTTrDrl0XqMK15uw34rQ9ixZ8MVYC1xf+rLWc0dZSszgRPZ+jCv+iwM0n8e2GiP5Qe35qHWpxa6Yi5dEzhGDBoNB0gFhkV+Y1SOynlFwRGox3A0QWMP+JDKuRxzZB3QeQYlXYzscQknAUwIWgriAkk+3mTc429jUxZN/8W1ewSzcGbm9o+YYGxMHFHhoxgnZKAmGpNXaY4bP6JmhpVXALsrSYl1dJaO6c9COXxwc7kAnYFVs2pBtfnJpxYRCsc7YfA7Bhb96BZtmGZE3rYV/2K6IKJdKSqKfCMIO8jCf12FlS2AKeMDbUkOW9LKoozeZhUHCHucnGLPtXp7ks98b9i3ik1TymzhekXIEkV+3Fej1auO9rEvp2EoTs8vS7NJHsNgrh1z8RBT0pO+RnUmnC5fdbdixa+AtifIoe+tzf6GSdV4MAlvyIZtOunUQsFp+HyAB1eOfZHtrfcgRaA0Q9QYWhVaa3eTZdNwgkaXpj7FcD/z9fPiOR3Awrpj5LTMs3rr7yJ1xEUN+jSfDPSwtiQEOP9zh9rriKkeLl+i+8lpAd+9px3sytuNW7Md/woMnpE2vaADeG3/a17Evmlc4IU+1wdelGUHuT3wyBZ+8t6JOQJsR/7/oRWJHSRPAphwN+7T0scf9J07MPTKvT/qNJvrEbaRBiRpuOA+H6/g8T43VzvCeKQdrQMZFPDNiyIz7fzbDhA1yWCK6/7s1NcucW/dlT0L/YVI5xMsbWXBTE5gPkLkTeoY8mY8//x
 wRyRujts
 sJfnSx0vb6Jq/+D4brKAtidy6HucWW/p3RK2kGfRxcif+1IWNnfrhaDMJZl9naqBs258bddh2UFCsZU3XAYq+ougYOflwHM0Jav/Jrw+JjIslgvkcWMsPAoXXmwdqYzFQZh3ZCeUmtiS1i+aqoIIGvuIGt+2OKNqYJyvHXQjFWRLU7bJ681wyqEFcekXbBa9kkC31jrnU2vKmEQGS5JTki2X6KIUiIpj8xrzcQIdEfD3wAV6LMtSvkyBFrWL+Xj04ZrJ5sjtBPYeqBu0CmGJxshH/pkWObn4zs95yNIUtk7XzcH7m6140azwYIFj6M6FqBcmTHkpDZ+yN7sEAjDxTg2rO8UvxyjwfYQr+ml9rbJsN2vdGnOUK7Vp/AQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An 'F' entry, and every interpreter a 'B' entry binds, holds a file open
from registration until the entry goes away, pinning the file, its inode,
the mount it came from and that mount's superblock. Nothing bounds how
many of those a user namespace can hold. An entry binds at most
BINFMT_MISC_INTERP_MAX interpreters, but nothing caps the entries.

Charge each binding to the user namespace and uid that makes it against a
new UCOUNT_BINFMT_MISC_INTERPRETERS. Going over budget causes -ENOSPC.

A per-instance cap would suck. Instances are keyed on the user
namespace. So any constant is multiplied by the number of namespaces the
caller creates. Creating those is virtually free. A ucount charges the
namespace and every one of its ancestors. And a namespace can raise only
its own limit. So nesting buys nothing.

The knob is /proc/sys/user/max_binfmt_misc_interpreters. Leave it at the
max_threads/2 default fork_init() gives a new type. No existing
configuration comes close to that.

binfmt_misc is tristate, which makes it the first ucount user that can be
built as a module. Export inc_ucount() and dec_ucount(); without them
CONFIG_BINFMT_MISC=m fails to link. Export them to binfmt_misc alone:
charging a ucount type is not something a module has any business doing
in general, and the list is trivial to extend if a second user shows up.
init_user_ns and init_binfmt_misc are already exported for the same
module.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c               | 16 ++++++++++++++--
 include/linux/binfmt_misc.h    |  3 +++
 include/linux/user_namespace.h |  3 +++
 kernel/ucount.c                |  6 ++++++
 4 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index ad8c4f64bf10..a3aa42fd5761 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -289,6 +289,7 @@ static void entry_put_interpreters(struct binfmt_misc_entry *e)
 	list_for_each_entry_safe(interp, tmp, &e->interps, list) {
 		list_del(&interp->list);
 		close_interp_file(interp->file);
+		dec_ucount(interp->ucounts, UCOUNT_BINFMT_MISC_INTERPRETERS);
 		kfree(interp);
 	}
 }
@@ -307,7 +308,8 @@ static void entry_put_interpreters(struct binfmt_misc_entry *e)
  * The caller has to have validated @name and @path, established that @e
  * cannot be matched yet, and owns @f until this succeeds.
  *
- * Return: 0 on success, a negative errno on failure
+ * Return: 0 on success, -ENOSPC if the entry is full or the binder is out of
+ *         UCOUNT_BINFMT_MISC_INTERPRETERS budget, a negative errno on failure
  */
 static int entry_attach_interpreter(struct binfmt_misc_entry *e,
 				    const char *name, const char *path,
@@ -315,22 +317,32 @@ static int entry_attach_interpreter(struct binfmt_misc_entry *e,
 {
 	size_t nlen = strlen(name), plen = strlen(path);
 	struct binfmt_misc_interp *interp;
+	struct ucounts *ucounts;
 
 	if (binfmt_misc_find_interp(&e->interps, name))
 		return -EEXIST;
 	if (list_count_nodes(&e->interps) >= BINFMT_MISC_INTERP_MAX)
 		return -ENOSPC;
 
+	/* The binding keeps a file open, so charge it to whoever binds it. */
+	ucounts = inc_ucount(current_user_ns(), current_euid(),
+			     UCOUNT_BINFMT_MISC_INTERPRETERS);
+	if (!ucounts)
+		return -ENOSPC;
+
 	/* One allocation, both strings in it, like the entry's own buffer. */
 	interp = kmalloc(struct_size(interp, name, nlen + plen + 2),
 			 GFP_KERNEL_ACCOUNT);
-	if (!interp)
+	if (!interp) {
+		dec_ucount(ucounts, UCOUNT_BINFMT_MISC_INTERPRETERS);
 		return -ENOMEM;
+	}
 
 	interp->path = interp->name + nlen + 1;
 	strscpy(interp->name, name, nlen + 1);
 	strscpy(interp->name + nlen + 1, path, plen + 1);
 	interp->file = f;
+	interp->ucounts = ucounts;
 	/* Publish the node: a lockless cat may be walking the list. */
 	list_add_tail_rcu(&interp->list, &e->interps);
 	pr_debug("register: interpreter: %s {%s}\n", name, path);
diff --git a/include/linux/binfmt_misc.h b/include/linux/binfmt_misc.h
index 072e4b3dd78d..8045b10dd3e5 100644
--- a/include/linux/binfmt_misc.h
+++ b/include/linux/binfmt_misc.h
@@ -7,6 +7,7 @@
 struct bpf_prog;
 struct file;
 struct linux_binprm;
+struct ucounts;
 struct user_namespace;
 
 #define BINFMT_MISC_OPS_NAME_MAX 16
@@ -21,6 +22,7 @@ struct user_namespace;
  * struct binfmt_misc_interp - an interpreter an entry was registered with
  * @list: link in the entry's list, in registration order
  * @file: the file, opened at registration and never resolved again
+ * @ucounts: the UCOUNT_BINFMT_MISC_INTERPRETERS charge the binding took
  * @path: the path it was registered under, used as the name the interpreter
  *        runs under; stored after @name in the same allocation
  * @name: the name the load program selects it by; empty for the fixed
@@ -33,6 +35,7 @@ struct user_namespace;
 struct binfmt_misc_interp {
 	struct list_head	list;
 	struct file		*file;
+	struct ucounts		*ucounts;
 	const char		*path;
 	char			name[];
 };
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 9c3be157397e..e38d9e60569f 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -57,6 +57,9 @@ enum ucount_type {
 #ifdef CONFIG_FANOTIFY
 	UCOUNT_FANOTIFY_GROUPS,
 	UCOUNT_FANOTIFY_MARKS,
+#endif
+#if IS_ENABLED(CONFIG_BINFMT_MISC)
+	UCOUNT_BINFMT_MISC_INTERPRETERS,
 #endif
 	UCOUNT_COUNTS,
 };
diff --git a/kernel/ucount.c b/kernel/ucount.c
index d6dc3e859f12..ec8b1445e287 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -4,6 +4,7 @@
 #include <linux/sysctl.h>
 #include <linux/slab.h>
 #include <linux/cred.h>
+#include <linux/export.h>
 #include <linux/hash.h>
 #include <linux/kmemleak.h>
 #include <linux/user_namespace.h>
@@ -89,6 +90,9 @@ static const struct ctl_table user_table[] = {
 	UCOUNT_ENTRY("max_fanotify_groups"),
 	UCOUNT_ENTRY("max_fanotify_marks"),
 #endif
+#if IS_ENABLED(CONFIG_BINFMT_MISC)
+	UCOUNT_ENTRY("max_binfmt_misc_interpreters"),
+#endif
 };
 #endif /* CONFIG_SYSCTL */
 
@@ -233,6 +237,7 @@ struct ucounts *inc_ucount(struct user_namespace *ns, kuid_t uid,
 	put_ucounts(ucounts);
 	return NULL;
 }
+EXPORT_SYMBOL_FOR_MODULES(inc_ucount, "binfmt_misc");
 
 void dec_ucount(struct ucounts *ucounts, enum ucount_type type)
 {
@@ -243,6 +248,7 @@ void dec_ucount(struct ucounts *ucounts, enum ucount_type type)
 	}
 	put_ucounts(ucounts);
 }
+EXPORT_SYMBOL_FOR_MODULES(dec_ucount, "binfmt_misc");
 
 long inc_rlimit_ucounts(struct ucounts *ucounts, enum rlimit_type type, long v)
 {

-- 
2.53.0


