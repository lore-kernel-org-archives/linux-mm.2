Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DE7E606A699
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 00:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PfLEaZMk
Received: by kanga.kvack.org (Postfix)
	id DF9A66B05CB; Fri, 20 Nov 2026 19:10:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5C6B6B05CC; Fri, 20 Nov 2026 19:10:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFDF06B05CD; Fri, 20 Nov 2026 19:10:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A15B06B05CB
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:10:16 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 88063A6B38
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:10:15 +0000 (UTC)
X-FDA: 85457193990.26.47457E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id F3463140003
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:10:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PfLEaZMk;
	spf=pass (imf26.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795219814;
	b=5Q+3WolGG3ElXdEW11wrakbezFpD/G7CMJP9Ih4t04qN47cMgzGqteJEIw4hf+zj5fb6+n
	nM8SsQ5mJWaJuYHsBzmY9hDDnKi4STns9tpd0iXN3KmkiyKTA36sg6WUZrFNLjDVhqKXMn
	OimaC2Nh68VjH/+Ynr7+eaT2sbyWGKI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795219814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yqfEnWFETbmbQSAYIEm1u3Lu6ctO7/ZcmaZ3U4EI6KI=;
	b=Qf57To79ACDK65bLZuTeUB9Kt+xisoPeemWZr/JmIuziNS8qta4JUysu7BiB4v4hjHcrnQ
	ubAmPaa+UIYOtzuI+sRt0PMUQkwnfXW/ociBtMkUnKV+auAf1DjuXVJxDS7jjuXgESGLeU
	o00Gn8qd5yCHpNLG384viVDdS1Xaxs4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PfLEaZMk;
	spf=pass (imf26.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 9A61D623C2;
	Sat, 21 Nov 2026 00:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9E8971F000CA;
	Sat, 21 Nov 2026 00:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219813;
	bh=yqfEnWFETbmbQSAYIEm1u3Lu6ctO7/ZcmaZ3U4EI6KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PfLEaZMk2QFj36evDxl3k1fnD+CD+VA6Vsnq2kjvgAfxg06Pb861t+pQVRmkQVDYO
	 1sdYvwiIUk+goQzVebUrpINkVMoGEAUMXDrt29X8HwKyc+1oiBAYwrGSkNAr++i8pe
	 8RZVkAJSI46+nj0Q1+ZnlWauiSZsXeQRem+HKa3HxR0jpUhiUOsUJbgcB6/ZZrFDI8
	 77qSlfwFBb5Vvt9v70DMzx6Z/v1p8BW0ko2egGIOaVZYXlnGGdVHse9LwsE84FlPZZ
	 uv2TEt4sDBgrv2CY0MVZcu2kgnVWdam6Abt57m99cHBej9vMpuSTe5EnOEwDAUJOfi
	 AmrxY/sUZEy2A==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v5 18/25] proc: Implement ->set_rootns() fs_context operation
Date: Sat, 21 Nov 2026 02:08:37 +0200
Message-ID: <20261121000844.1863324-19-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121000844.1863324-1-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: F3463140003
X-Stat-Signature: um1qfufb3y1xeqjbs4ubu4ojbfs4ppdg
X-Rspam-User:
X-HE-Tag: 1795219813-164193
X-HE-Meta: U2FsdGVkX1/d9Jv7gKQLX+qNBZxzLUf48wQEqkMTalbDlvto0nzxQkVs7sVmoX7y8VZjJ1BmhgYCxgTzplYG3/v7WeetdydxNVOnDiuJYdrfWFhXl3ryhTayVAR5ojmpRdAjgYF388QHVRE3b6v5E0NH7kE2Su+9B/O6Mas0m1Ek0ZDTh5ldAFGb0dQ/wL494ud1emiOJ4CNJbpIbiIVox75ZVwu30MlFisLNGFCX+6LrwctUVwV35KYR/5w4dl0FJ5ICIaj2iIcxh/Sg4pFILeSAzh5UXHMt2HUOkshDJaD7jgjjj++nvRhO0XQqP9HwZKyZeymkRm1p7ZZDC4/ZJ/6CML5rHca3xIX7fYYaN4M/pQJhgM+eUiq8QcSbBCRmpl4TGqR+bsP02FpLNxNPuvv486OSH/xH6j1/gpry/LClZOnyj2kZ5jMPcoXQ8AXQNu/JYnZb2OF989qgDi8+h5X2q1xKnfIqf7SVXoIJwpww1k69beQ8sddWUIt83hlW97GGHuRokhyA5j23PzADRnZM6+vvUcr2YotVwFKTcaOEN0Nimrtq3J0r4Se1ZaiJVeW/PdP2Heloef42CrQFRoImSVnW20z2nx8X2VuuCigzYjBArXMJlA9g6R65FzTTCeQCqNv2rTbbUU1TMaG3MRWlsmR4UpQAKMJrs8scwRFertcChdjghr3LcFm+L4IifNXfm82TSD5DOaO+za5FcE05V7lJjCLNV1Gt4B+u7bBk8/RddvtzGxYegJ3yi0zmCje5dmqBPKaTCdMKaP0TdrzJ29on9856RxvrExeS0xUrLlHhnvWxoM0cjXuSF5GyT9jSZyGt2CYBvgiBlqlburdeed8NQcB0/1joAmWV5KRZWGuZpFjXzFomJEmB8y5oBz2oR3mnn0cQw076x7GJqukWyF8S6VTVuGyxWV0h0DA/aWp54bf5dIfBgwF55xq4mahwbEpm0OLN0Z5kS6
 HSiRsAEy
 sySWLygRj86AX+JJRI31J9OXZO7LgDUmWtCoOG+MTMOMmUHR7JzotzDQRsGN98znhzlwJvTBCXau1qXwQHk3aF3qAkuSOYWWUZAMaIuiUWzjSjsX6tUiO0/RZC7dzRrZEX8vIy/gzXGf1DyzzXnjkT4KIUZWI3OtFFZs3wRv027EafnD6EVPxuK5L0uQqqP2GbdEEXEnG+VkuA4guqXx7ViRNRDVv/bNXjLUdcwJZBlqVJoeLdG6BB6zZV06AtsvyPcXjFoMOkm8L9/DvIYiMxCWrTYOKUH43dAZski6rMjtx2E0ARozjB4KOAS6ezTLeThsBTned4jeH3hOWliLZf3/N6QCAhlqWrMJcKNzrKEDW+Ttx9sqOzoZNf4FWF3/hWjaK2gXS5kMCGRTHjuKiP1hGGLQAYGD+cDZiUqUaygh2wca4wEdWljMtIKb3W+34CDU8Wpsx7IlsLpnKD70IVYDKFe2ciNygf0myPWXbgI62oGA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_init_fs_context() binds ctx->pid_ns to task_active_pid_ns(current)
and resets fc->user_ns to ctx->pid_ns->user_ns, overriding the user
namespace delegated by FSCONFIG_SET_ROOTNS and leaving the context
attached to the caller's PID namespace.

Wire up proc_set_rootns() to verify that the target root namespace's PID
namespace is a descendant of the caller's active PID namespace and
rebind ctx->pid_ns and fc->user_ns accordingly.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/proc/root.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/fs/proc/root.c b/fs/proc/root.c
index 7fbbe92bf73a..8d2b9bbfa1c1 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -15,6 +15,8 @@
 #include <linux/sched/stat.h>
 #include <linux/module.h>
 #include <linux/bitops.h>
+#include <linux/nsproxy.h>
+#include <linux/rootns.h>
 #include <linux/user_namespace.h>
 #include <linux/fs_context.h>
 #include <linux/mount.h>
@@ -206,6 +208,10 @@ static int proc_parse_param(struct fs_context *fc, struct fs_parameter *param)
 			errorfc(fc, "cannot reconfigure pidns for existing procfs");
 			return -EBUSY;
 		}
+		if (fc->rootns_bound) {
+			errorfc(fc, "cannot override pidns on rootns-bound procfs");
+			return -EBUSY;
+		}
 		err = proc_parse_pidns_param(fc, param, &result);
 		if (err)
 			return err;
@@ -323,6 +329,21 @@ static int proc_get_tree(struct fs_context *fc)
 	return get_tree_nodev(fc, proc_fill_super);
 }
 
+static int proc_set_rootns(struct fs_context *fc, struct rootns *rootns)
+{
+	struct proc_fs_context *ctx = fc->fs_private;
+	struct pid_namespace *target = rootns->ns->pid_ns_for_children;
+
+	if (!pidns_is_ancestor(target, task_active_pid_ns(current)))
+		return invalfc(fc, "cannot set pidns to non-descendant pidns");
+
+	put_pid_ns(ctx->pid_ns);
+	ctx->pid_ns = get_pid_ns(target);
+	put_user_ns(fc->user_ns);
+	fc->user_ns = get_user_ns(ctx->pid_ns->user_ns);
+	return 0;
+}
+
 static void proc_fs_context_free(struct fs_context *fc)
 {
 	struct proc_fs_context *ctx = fc->fs_private;
@@ -334,6 +355,7 @@ static void proc_fs_context_free(struct fs_context *fc)
 static const struct fs_context_operations proc_fs_context_ops = {
 	.free		= proc_fs_context_free,
 	.parse_param	= proc_parse_param,
+	.set_rootns	= proc_set_rootns,
 	.get_tree	= proc_get_tree,
 	.reconfigure	= proc_reconfigure,
 };
-- 
2.47.3


