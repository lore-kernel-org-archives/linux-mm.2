Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94743C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 18:39:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01D696B0092; Tue, 25 Aug 2026 14:39:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F36C66B0095; Tue, 25 Aug 2026 14:39:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D89616B0096; Tue, 25 Aug 2026 14:39:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A58756B0092
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:39:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2B2C6A01A7
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:39:36 +0000 (UTC)
X-FDA: 85140655152.14.83D99C2
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf04.hostedemail.com (Postfix) with ESMTP id 347694000A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:39:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="g8g9un/J";
	spf=pass (imf04.hostedemail.com: domain of jannh@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787683174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1FmJj7cqvHGQvjzRrY8P2RyixQ1zI0rgSWEthVkE6Ms=;
	b=HPFHG32ZjYmoAaT7Y0ib1BM6t6wvxboEFm4eErazUM2IjBBLrNRxVQz4PvENdDS/mFYbyn
	707Es6awxWGI7irtUKBtcTb2S26XdQz1lwUMUP14Q4xyclVlTKlwwd8Y7dn+co0woUExsv
	u5a4PvJ+o/+kQNPVB9IKmBR2pyyARas=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="g8g9un/J";
	spf=pass (imf04.hostedemail.com: domain of jannh@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787683174;
	b=YWy7Y6db562sDU8QXlWVWiow6Bk2TupO71iGuUIzNppVdxXbRtak0xgcZgPkxet3lu1Cj4
	j8PU7uY80Bm1ZJ5iT3H0MLHQL37PysHuqrjPaOZZbte1eOESCivy258YLqJNpqrfwI4zZx
	GE5j5b8YL8m8ru+Ge3JCThV08u05jyw=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a17c7c3c6eso1730a12.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787683173; x=1788287973; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1FmJj7cqvHGQvjzRrY8P2RyixQ1zI0rgSWEthVkE6Ms=;
        b=g8g9un/J8/XwAD6nmZvQQn8furCfFvZmuTPpA7qoCr8vLZqGbvxT5hFqzSmeWv6EgB
         l5IxDjzXoHW/Ka1A4hoEt0H3bZdsguHp3G83LN9UVAURJ4URq9STKga6dkXhOgDVkNIz
         NfRewU1k4mIHYgrKwtLkbTUes5WJkABgBDsS/Bt3lZ0ODGfRXkAXM8752rL1ZIQ4u0i5
         r6Gpy7KYYCLNqWHCPLsTdD7qUxSZGM3rSRZaCsaSOM1r+dgTMJrYP1iX4s3OuCck8oEu
         nMX4O6vW4B6eNiLc/aGAefnEjTuRoxjniGGvJrD9+XXO66lOHeKnodegMTEKRrZCjkIE
         glXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787683173; x=1788287973;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1FmJj7cqvHGQvjzRrY8P2RyixQ1zI0rgSWEthVkE6Ms=;
        b=ZYJdx8y1TjZaDEZxNGfwvM612jI60u7QN0xDxjQmI1DeVKxfNoOShPWtWM9nnXSWlw
         Qgeawp5wHkG5iyksdQZLEWytqL/AQ8XhTwOCHMU6mwq+tQJh96mxzjM/WAtxEC9bMMkB
         vnfPugFsQTwjzvxi0Mcp2s0cqy3Ry768A5pC0jMxl7iHKUW0oSbk3ZlOz+91BvZfnv8c
         D7dJnxqb3xNTn4h+S9k7FkeN/RK+y70QExaM8Sj5bVN1CISPmqS48yWvMTK17K54LMwK
         MDg83nDaWfRIzamtBSkB8ZeXt9YtWrwLWcr3fRTowcRLLos7q2aX7EGUtHB0QLhSKthh
         EQEg==
X-Forwarded-Encrypted: i=1; AHgh+Rpxxn/UJEFfOCtKY7MKNSvXWmkhtPH1tOu1Gl2AMNirUh75OtMEoGIE9Yi8ElK3mzYwva2xgGtWFA==@kvack.org
X-Gm-Message-State: AFuF++lU/nbQ0DDWtm6gEUAK0w/ruWka+bSg/YVjAecxzzvEzM+dfoXz
	d3baBuZZ0r8R8lbbtJeSHzWQBuuwOqN0oDORM5jRNTXmmOKHFjK36rsX1Amr8ZZKoA==
X-Gm-Gg: AR+sD12Dxm/Z3v0cuL0T+VhWqKKQnJ/dY7woORugzNmnjO70jxkk0W2xCtSUYbyj3zM
	zvMpT0n2Cx2y/ABB+/CKJOo57uSX/Zs5oWvFh7Hve31YpWGLzPZAEcQdQh/LqcKHUN4IIz6B7DJ
	68v3dkSk8uI+SU6ruTIxlCGx/3JE/KDSH7zs85zAzOZIornzFZEn+14lMU6Dwi11T5bd6GSKzh9
	aEaKaVTF/yqSCnzl2HxqnI0e0o8VvkYcsrVC/htRYmXuqJzc3GKRCJwnDKiP21JebKgardCeCud
	+rKEWwS+wLVC5n7d5W7EYTE9kHWLFUNbrhDiC5tFVLXMw7rD4IIzA2b32uyBv5wwK7lsBCqqmzz
	NRK71xLeNTKYyyuBVEBFkcM7mneFkVRrSJJZkWRZ30LaKXZRxns0IY2fvSRCkeaYiG3u07amBuH
	SZRpDmcncW2hy97O7H8lsA79t6GW+fQom+b1kiAAFHnEJ4GsA14PSKgs9PeNDpuzO2cpZkhbNaL
	d71mCVbHMZGo0d31jmpyODXIS7GDjcYDbBj+1wbUWq2X5TrWRj+mzbBApw=
X-Received: by 2002:aa7:d5c2:0:b0:6a0:a317:9c47 with SMTP id 4fb4d7f45d1cf-6a5dfc8c1f0mr810a12.3.1787683172270;
        Tue, 25 Aug 2026 11:39:32 -0700 (PDT)
Received: from localhost ([2a00:79e0:288a:8:980a:b43:2df6:51f2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c250a73038asm69027666b.26.2026.08.25.11.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 11:39:31 -0700 (PDT)
From: Jann Horn <jannh@google.com>
Date: Tue, 25 Aug 2026 20:39:18 +0200
Subject: [PATCH v2 2/3] proc: query LSMs for introspective mem access (if
 PROC_MEM_FORCE_ALWAYS)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260825-selinux-pokemem-v2-2-b46bc64916d8@google.com>
References: <20260825-selinux-pokemem-v2-0-b46bc64916d8@google.com>
In-Reply-To: <20260825-selinux-pokemem-v2-0-b46bc64916d8@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787683163; l=5578;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=EvcybHcv68QQFqGtTU8tppP5khSatN4aJvvfORGlQbE=;
 b=igbKCV8hulK01S94Oo+xDmbcq1U99pUxYx+EQ5tzIO8NSfr0cXrRdmwJeGJYn+g/tUpMFtdcu
 FofuUvk4b/7BlRlmB25d4jPjJcAmBINNjve28kApv6HHEGCZVbae/uY
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=
X-Stat-Signature: praqy5niqzio3a6w8zninkc5tw3ztwrj
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 347694000A
X-Rspam-User: 
X-HE-Tag: 1787683174-806789
X-HE-Meta: U2FsdGVkX18MK993z9yT9/D1kPowHfzf8/C8lXdE3+B7drPkUkr1lj/XHZ1BI+lCybTCTYQVACdP3UCsdBnL9rofVKElr+uXGhEYPzAR5Tc5FOcPbF4MWK7o3QXYrx9G0SZfhh66WlKiQ9HwJWMjUOHDO3UQumuwnfMAP+74dVHSYKA7DZku5BJqHtcchXwZ/M3Lod+uEJYrwwjoLdKxbN6UAjtdSOVKW5gslcsH6SN6YUqZDMXiaWTf3NjPfG5NkRHR26AbxJZJgKogHM9uNm8YJbdGetBe8o8I+Ci+leQfqhJMuPVzG+WqW1xtui9uNSs2GfZB8UrwNeiwlreCe5vbibbmtpS9PM6rvptGbbmROx/lgKQWUiiYC3vcYOpuZLUZV0moTGEVhFuRXPCBQKL7ECUSouh76OA+V8KfFJV8js/biXgqQVOO5j2mcJkIsRv7AIu5cmxXAuPoxz27begkfEq0F4derxCZXKEJtnpqp/dvYkncpv1MxvAWFkUslhBUhwxI16zoUSXw2m2Vpxf70Gz4fPFIPAbtBqhStYdPnoabGDfZ5Db4B/rpIBa+Z1BA1UlifY0LlBOylY3peBLsfpwZs120KhAxQUpXAxiIhMcRmwU32AhA9MApTnp9c53cXCftimE2RuVzBk9ZhI2jW9IJjj6HnCy/Y5Xw1tl/7MoIbsDxE1k1zukN6lblsFhJ8RPDizNru9LbOqnha76QWGLRVcFXdrPQlTk4ooRF35lXWwZUnMnv0fEDP6mxVd/Izexof836HdI+2x2YuG1N2HROOedg8bhn9IzTQe09U5MtBEdHHSfeAMXgBLXNoCH1lmhJTCmifTCC7q3TZDlc1G3ZFYYzPio0/15aMvdeoxBwJugfDbgjVqmuBiihMmMaKw14RCxOaI7MkO6xr6jEE8+1sTVa4qJ7+GU12rlaOiHoDxGNtHUgzvXw1Ulr1n1380WClVgKV0q+vCh
 V9tnj/3O
 TsgBcFzbwGKwZSCZje77cv7nXD1PwbGsF5qbXq2Vd9THi6vVMnRGb7fAMhiUV46opY8+zcC30Ou1aFAISw+CHkNARKeXK+X4Xb5gRlDNgfASPyU1wh+PYb2H4kSigAPAALuJgtfP6TxleCPUfPga70EU1JTaUMB7ZnaXSe6QFEpXz5IEF+Z29pOlzR3AIxCUvkcTLh2hpQkqdwrkrYxwhKU0y9tC7BagR4Uw6vD4PDajrgT3Eh3pFnYczSmQJqj5TBf/ZLtwzkfeObewItneDjqqqkE2BIOKQstBecqRJos4b0HEWPyv5eSk4BFIHNFVUy/AvthlO6KMizU9XwjbOiPgEvY4n9eJPlgOwH3jcug/7lKET3U81DtlBQngbp1DGFSiBSRyQBaITRkZ7gM9JGLlHR3YKqH8cL7thWv7CaY3TJ5s76pO+UdAl5dFtaIb2Q4TbA/Tiovm7spS7WpCX3qhAOXHET5s4n206lHZm8F329/5NSZ8/pREH2Q==
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
 fs/proc/base.c                |  9 +++++++++
 include/linux/lsm_hook_defs.h |  1 +
 include/linux/security.h      |  6 ++++++
 security/security.c           | 20 ++++++++++++++++++++
 4 files changed, 36 insertions(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index bec6197329dc..dc6fdcb47b79 100644
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
 
@@ -886,6 +893,8 @@ static bool proc_mem_foll_force(struct file *file, struct mm_struct *mm)
 		}
 		return ptrace_active;
 	default:
+		if (priv->opened_by_owner)
+			return security_mem_foll_force_opened_by_owner(file->f_cred) == 0;
 		return true;
 	}
 }
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 65c9609ec207..50e3f0abc676 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -36,6 +36,7 @@ LSM_HOOK(int, 0, binder_transfer_file, const struct cred *from,
 LSM_HOOK(int, 0, ptrace_access_check, struct task_struct *child,
 	 unsigned int mode)
 LSM_HOOK(int, 0, ptrace_traceme, struct task_struct *parent)
+LSM_HOOK(int, 0, mem_foll_force_opened_by_owner, const struct cred *subject)
 LSM_HOOK(int, 0, capget, const struct task_struct *target, kernel_cap_t *effective,
 	 kernel_cap_t *inheritable, kernel_cap_t *permitted)
 LSM_HOOK(int, 0, capset, struct cred *new, const struct cred *old,
diff --git a/include/linux/security.h b/include/linux/security.h
index 153e9043058f..74eb876054b0 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -338,6 +338,7 @@ int security_binder_transfer_file(const struct cred *from,
 				  const struct cred *to, const struct file *file);
 int security_ptrace_access_check(struct task_struct *child, unsigned int mode);
 int security_ptrace_traceme(struct task_struct *parent);
+int security_mem_foll_force_opened_by_owner(const struct cred *subject);
 int security_capget(const struct task_struct *target,
 		    kernel_cap_t *effective,
 		    kernel_cap_t *inheritable,
@@ -676,6 +677,11 @@ static inline int security_ptrace_traceme(struct task_struct *parent)
 	return cap_ptrace_traceme(parent);
 }
 
+static inline int security_mem_foll_force_opened_by_owner(const struct cred *subject)
+{
+	return 0;
+}
+
 static inline int security_capget(const struct task_struct *target,
 				   kernel_cap_t *effective,
 				   kernel_cap_t *inheritable,
diff --git a/security/security.c b/security/security.c
index 71aea8fdf014..fff26ff65e07 100644
--- a/security/security.c
+++ b/security/security.c
@@ -595,6 +595,26 @@ int security_ptrace_traceme(struct task_struct *parent)
 	return call_int_hook(ptrace_traceme, parent);
 }
 
+/**
+ * security_mem_foll_force_opened_by_owner() - Check if introspective FOLL_FORCE is allowed
+ * @subject: credentials of the process accessing its own memory
+ *
+ * Check if FOLL_FORCE is allowed for accessing process memory through
+ * /proc/$pid/mem in the case where the opener's MM was the same as the target
+ * MM, meaning the security_ptrace_access_check() hook was bypassed on open().
+ * (current->mm does not matter for this; for example, if write() is called on
+ * an FD that was received from another process which obtained it with
+ * open("/proc/self/mem"), this hook still runs.)
+ *
+ * This is only used when the system is configured with PROC_MEM_FORCE_ALWAYS.
+ *
+ * Return: Returns 0 if permission is granted.
+ */
+int security_mem_foll_force_opened_by_owner(const struct cred *subject)
+{
+	return call_int_hook(mem_foll_force_opened_by_owner, subject);
+}
+
 /**
  * security_capget() - Get the capability sets for a process
  * @target: target process

-- 
2.55.0.860.g4b6b3295ed-goog


