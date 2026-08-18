Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CE72C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 19:51:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7CFA6B06B1; Tue, 18 Aug 2026 15:51:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B54316B06B2; Tue, 18 Aug 2026 15:51:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CE7F6B06B3; Tue, 18 Aug 2026 15:51:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 710A56B06B1
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 15:51:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B7A64C033B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 19:51:47 +0000 (UTC)
X-FDA: 85115435454.06.707E074
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf25.hostedemail.com (Postfix) with ESMTP id BED09A0006
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 19:51:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oYkUvbzg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of jannh@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787082705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cgP6lQOibHlCVKVmBeaw+pleu+P2xINjgIC2sMiWwBc=;
	b=osvUcS2gzt+m+LwM5nf4VpJpnzBu5Ro42lbDt9VZ7R07ahKhvvjcczhN91BfhJfQmofMmr
	LL5JehMgVRwT5ulT8X0Ni/uiLjSbRVtuh/Vl4gIYArolKo3xNA4ACmyITg5vcgD/5vW0s1
	eW9qOaUS8GdRrzomYjteWHJn2gYZCx0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oYkUvbzg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of jannh@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787082705;
	b=qx5yIC1Tb4Oa6+TiL5utG/JxCqnF4ANbxf1jpHirHlBHNKoTpr/diubZWJR3z2mgOKGAK6
	pE6SPdjiac0YJ6ngqa4vr8CrOrkrZqfIsSUl7+pUuguHHDXL3Gtv22G8JfPvolgcoapOed
	zszd1zaqwF8zUJ1j5xlQmUHHIiXPySk=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4994d67d260so2195e9.1
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787082704; x=1787687504; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cgP6lQOibHlCVKVmBeaw+pleu+P2xINjgIC2sMiWwBc=;
        b=oYkUvbzgq6ceQ2M17IF697uqL3mVhhOisCL6o3i/z57W6DYb7fTspOBdb2ygLlL4PE
         1ElqsbIBb1u9ib6r55a69u94l3xeYMWOZKh4LoZU2VE8uOntOkSO/bYxIieTAlvn7muc
         m4uG+DgHohg2HbcwZdXZHsl5Xbkt8EOzs1e9sDFHWuocH38xcbvgYqawFT6fRKJKx2yT
         70/2AWjP7QPSitY/mjaXdMQpf1GKDF4UEXxlYdPyMCgcCx2dTA/Olja8de5Ix4gCNpGw
         kOXZ49yGeFf67LfVx/K3F5qopsPDBFGR0hXQZAT9Ny3glWOpGoO8zMh81PLtUbnTtjnx
         xyRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787082704; x=1787687504;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cgP6lQOibHlCVKVmBeaw+pleu+P2xINjgIC2sMiWwBc=;
        b=UgGzHYQe9AmbX0xkKsP7rQEGPT/9H46nSsgTffNjL0b1AqsT7drmXhO3wN6wgCS3E4
         rjrRfopw3PKRJgWLt+APgx2WctyAPsY/YERLrTFM28mOof4ZHhW0XOtiX5Qyi83cEQlz
         B4ixj7tY9mzRSyMwnIxS8GgscYakB/EcMbrHuWAtkrirtMG3mkRPVZPI9Ju4BOP9Z/Bv
         cdBzyZHKAUcYSMgNZyUVcY9XSspCQPujSvV934L7LX5J7HD64CWdloK0WT9NS8iTWw8v
         85RQ7g8Zd7fF678s1CDomlx7P02rtaVF8wz15QGI+U0D5h9boBVHIzwlDFGKoWrSgsOP
         f5ng==
X-Forwarded-Encrypted: i=1; AHgh+RqsPDpq1IKXB00dOEDHfMmipgKi0N/YTpbgM5l8C9V07O4UdTN0smTd2PlNpxnJPi73ss1QcoNrpQ==@kvack.org
X-Gm-Message-State: AOJu0Yy8M3F3G5Y3NhVfGzGQF0ojIhSX7T4CQ6EE94J0rN7xJq9DnyQ8
	FRtdb8b5FS/D3HgSi/hXeN0GA0qgqmPi9fBsawC1T8813jiqPiU5o8DbkGF4acBMdDXn8E9z6RS
	O7aTRiKzZ
X-Gm-Gg: AR+sD133uU+Ze7OlNBwOQfGhhvdjLsJX6rhqV8oNgRDli/ufyJBEoQrg1t0V3IGrOpj
	VTRYXexZYjwcSaXJ0/zQffm3S/u1m7YSqnXVonbH50VaB2uts1eDVDhECZjdLi7QRr8kliQmHy7
	nnkN/d/U2eIUrzwPCELlvzMDYrPdYf2530Q13HBBR14Rs4k04I9IifV0loqmwiJP/5AHEKw/wyO
	qXIcB90wHqTcL8ehvpD+eSdKFzXlq2LdVLScljeC7liKXER+0B7mXm4XK0fYonpTNlC+ZGTRt/h
	6MZzGty+YkB2c35vmFTZFBsRLGHfmOkqZKVRaJufEHuMH/k91VcDZ53YZQef96yhxJWjXnPuF1r
	3pItyHE4bUcB0JsPknnp8QADXUWs56t0DVzXU23k1oMK3Ay+D/bCzOTdgA0unri4H3rxneiP4Qo
	+VqlLjLfebcCRjIFxXD2PdbVimSG7NDHDR1V4GRVgp4RYyNaw2srypaNaN2SpwexSyoB5oip1yp
	n7ijH1aX1ME/wTNiKRRBEccAuTpSJINLYxRrcMdw0luK6cn
X-Received: by 2002:a05:600c:8905:b0:493:b169:784d with SMTP id 5b1f17b1804b1-499a98b8974mr38235e9.8.1787082704117;
        Tue, 18 Aug 2026 12:51:44 -0700 (PDT)
Received: from localhost ([2a00:79e0:288a:8:f466:5a15:1301:318d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482a5b77f41sm13393110f8f.27.2026.08.18.12.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 12:51:43 -0700 (PDT)
From: Jann Horn <jannh@google.com>
Date: Tue, 18 Aug 2026 21:51:07 +0200
Subject: [PATCH 3/3] selinux: require EXECMEM or PTRACE for FOLL_FORCE
 introspection
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-selinux-pokemem-v1-3-90cd2357ee05@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787082694; l=2735;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=zSdAoshV6PguyX7bw95N4A7c09eJSx5mBc5Ua6Jl6bA=;
 b=Lyhniy9H5W1G2wuKZtV9Z+ZJwr+oTZ4Wxkivk0swGQT5TVkCUpGEnUh4di50Ud5ofYDrM8FV3
 hG088NQOnE8BjBxCnVn9kU0SPcGSVr57AdYgL4wVzDxIO+bERsoFvU6
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=
X-Rspamd-Queue-Id: BED09A0006
X-Stat-Signature: 6ux7pgkna6zjpu64dknzd8xts9ixtysc
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787082705-394566
X-HE-Meta: U2FsdGVkX1/uOlCZU7V45TkLgyLbiLyxZHPNQse+AlJaXnUbv0ETirXESc66Vq9zXBph/tOp9QA1WG7yaXjYqOd//W5HIjuB3fm35vr49cl+7e9qR+EO2PWuoBFxral6XHiny+w/xk9Ak4JmFhjaiVQlcWJfQPi857KrggwFO1ElCNx2mWWdEX7/TyO8a/RhSYr3IO+tTUkmyX3z5ehESl3SV+wzL9xP/Z57zCPrfJWy+osW8z9JaMTiJYQ12lISeIarupWtya4BDt98dHwXMuOptdPSAH0LBAhHcBPvaS9rhXJJEhUM+HaOAY/XGNH62sVV8WbK1pNDzTx5HZwfNhNHJHhmZE+PQKN77ZVUqXKVHFSz6+XaWaza/YogRQK1VvZ/oXJ8d3AO+GvY+YfsUnCn02zEwB9ssXanxRl4Qx6b1ZMGC+/H0higwPCvN0DiJ6Lw/f2oX+rSkXE+Lr4wM7X6axkcKWKWvQX0nCV0eH/yB22Ba127JVrLOgZE4tOqG/PCHB0qUi2XsfVkERb3eEnd/owDsubALDgfvafX/gQ4VfWgAzk1E1Ri1hh/dcFjGjoL+SYXqrsbavcpHa18QbV1DWS8imYTUpGPLICoKl+7P73DM2T5T7i99aBFtmXgEsBej5uwmT+XnHYtsQGy9tklB0vSwJWiJ5fuQE4qFKIPAwqeqJgsY9smzyJB+jyweXZqdEZYKtRlXWHV6c+CkziURk0vuObf2LxovrC0MwDvnMsFSulxpfIzkF6Ieq9x3Cnqn6gFAGjqWthliEWWFbmIe5McIxLOF5jDOihTDLZpWZSalabyUgJFPuu8mJNjRCy7pbYUvjYW3kBYGH1laAsQueLP7y0Y/DR1/Sl/NpV4UJMuAO3++1rOdcG/4fZYks2XnzBpHCHM8p1MAp0nCaT3nr3NNz5EhJM0cMveQsQ22VQkkTycQM29QJuTzg0rnqDwPPNYBeRFUepnPyd
 gSYjJn64
 l34WE+h7QlQvglxMYTe+Q1TneSuj0INXcRDbtMF3I54E51PCSA+nVxg7Cx8ea2DDQ3+87sO9c36R+wb8ilcx3EjSnbuOFoR3ZTq29rkxhvaSpq2KoqzH+WBGTNCIze752D8sdm/pFvmBN039XuDDrjrWTyyA4AAwzxtAk98gwjmJbZVdk7BLu2IQFd2N8ZpUCXT/yJhLcLNCJsq58BxrUPzvleLXpcgSEbfv05ohsRqjd2hEaRDbAE8SqHzU4uW3EV6fJe4oyZquJxfBEyobC2l4B6MAAFI5zR5AerkdvDoDNISZ8XLtb1wqLq9vtn3ldmITbxZ0xTLmOrEnphIgyXhPKkD2z+mDhWRdX+qYMNJHpOWHFon5ZpwWnSF9p26vbBLKAiUyE1KlGc0N79vWfx9wMPGIQmLNwEqAEqTC88s8EmQJxeML1zrMIqJ7ikV+w7igL5Cj/D8IoEXC+jkPN935rbCimVk46suIbygxIV81ZFOuvtn+LfjQ3Aw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On systems configured with PROC_MEM_FORCE_ALWAYS, ensure that a process can
only create anonymous executable memory via /proc/self/mem if it has one
of:

 - EXECMEM (like for other methods of creating anonymous executable pages)
 - PTRACE (like when using /proc/$pid/mem of another process)

This closes a hole in EXECMEM enforcement that Project Zero has used in a
remote Android exploit chain:
It was possible to use a memory corruption bug in a service without EXECMEM
permission to overwrite executable code via /proc/self/mem, which made it
possible to load and run shellcode with a kernel exploit.

Signed-off-by: Jann Horn <jannh@google.com>
---
 security/selinux/hooks.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 18dd28b2bb13..905137c47321 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2157,6 +2157,32 @@ static int selinux_ptrace_traceme(struct task_struct *parent)
 			    SECCLASS_PROCESS, PROCESS__PTRACE, NULL);
 }
 
+/*
+ * Decide whether it should be possible to read non-readable VMAs and write
+ * non-writable VMAs via /proc/self/mem.
+ * This only applies to systems configured with PROC_MEM_FORCE_ALWAYS, and only
+ * triggers on accesses that are not visible to selinux_ptrace_access_check().
+ *
+ * This allows a process to overwrite read-only code in its own address space.
+ *
+ * Creating an audit record on denial doesn't make sense here, since we can't
+ * tell whether FOLL_FORCE matters for the accessed VMAs.
+ */
+static int selinux_introspect_mem_foll_force(const struct cred *subject)
+{
+	struct av_decision avd;
+	int rc;
+	u32 sid = cred_sid(subject);
+
+	/* Allow if the process is generally allowed to have executable anonymous memory. */
+	rc = avc_has_perm_noaudit(sid, sid, SECCLASS_PROCESS, PROCESS__EXECMEM, 0, &avd);
+
+	/* Also allow if selinux_ptrace_access_check() would allow it. */
+	if (rc)
+		rc = avc_has_perm_noaudit(sid, sid, SECCLASS_PROCESS, PROCESS__PTRACE, 0, &avd);
+	return rc;
+}
+
 static int selinux_capget(const struct task_struct *target, kernel_cap_t *effective,
 			  kernel_cap_t *inheritable, kernel_cap_t *permitted)
 {
@@ -7558,6 +7584,7 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
 
 	LSM_HOOK_INIT(ptrace_access_check, selinux_ptrace_access_check),
 	LSM_HOOK_INIT(ptrace_traceme, selinux_ptrace_traceme),
+	LSM_HOOK_INIT(introspect_mem_foll_force, selinux_introspect_mem_foll_force),
 	LSM_HOOK_INIT(capget, selinux_capget),
 	LSM_HOOK_INIT(capset, selinux_capset),
 	LSM_HOOK_INIT(capable, selinux_capable),

-- 
2.55.0.737.g08866a6d13-goog


