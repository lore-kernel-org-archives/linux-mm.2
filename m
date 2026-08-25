Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E13D0C61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 18:39:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA4706B0095; Tue, 25 Aug 2026 14:39:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7C5D6B0096; Tue, 25 Aug 2026 14:39:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96AC06B0098; Tue, 25 Aug 2026 14:39:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D94D6B0095
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:39:38 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EF0861A0196
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:39:37 +0000 (UTC)
X-FDA: 85140655194.05.D2E25C7
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf22.hostedemail.com (Postfix) with ESMTP id 000BEC000D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:39:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="kXWbp/CT";
	spf=pass (imf22.hostedemail.com: domain of jannh@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787683176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RPvPgg8WrBS502z3EqfWF3DM7etFQasO/Hjw3jKjTbY=;
	b=G0dSXfeW6BKk1nFLOm93xLEqPmospAHXDTuFMhl8crjHkgRvZBJ5zY5prQWSkVfdRn2Y2S
	+qG4SZQQc4EzFHJbQqP7iyiQk6hw4PnKs4NCSDpQHRJ7BPAsbfzARwPfKGGwRNmAsDV3Qi
	qwUtLsbZiidDdfldi5N5Eh/IWltHEG8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="kXWbp/CT";
	spf=pass (imf22.hostedemail.com: domain of jannh@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787683176;
	b=NWRPgOU+xj3xKycWm442YM1IMCRkNaXUBe5YUgAfpaZ+C6/9g9NTcaxv5oc55+Hy5m6hqx
	le38j0IndQ6Yi6dPUHQ68sTYnzm/Cy0lOO+kq6V/H2dQdkqPSuO/3FRgDT9XsqtrWBwlLy
	VhdaefmwEGoYtlkqK0fzTCavqnSKYK0=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6a17c7c3c6eso1738a12.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787683175; x=1788287975; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RPvPgg8WrBS502z3EqfWF3DM7etFQasO/Hjw3jKjTbY=;
        b=kXWbp/CTiCLfj23KIwOPJ+plkm+e5QKqZcqXb+0i5hY5dRNyy9ptMyujgTf86vRRc3
         OLmUYaZKHQqVIA7J5l6JVkRWrjO1zG9wSRtZnf/zax2iQy7XjXpHi8LqzZO0RLTgYuQ9
         uPErsVnJ+PvcTFZnZDPEW3Kx+uu8VY7pShH9z42LZOga67PusqVPSoBjHk9ccpphvrFR
         AIivCni6rumjOCKzxrOpnZWAk/6JNuVfV4mtD8ltpac3xvGaBRsKfohKrX4JAy8fJxBi
         6o8epDKp1BNogYDu6IaUyZi6mjzqLhQVQPvee/xEQvw0kQdYfKYSyadP9Jy4Q35ncnHc
         BzZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787683175; x=1788287975;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RPvPgg8WrBS502z3EqfWF3DM7etFQasO/Hjw3jKjTbY=;
        b=pFIOkHJRNgfOTE34RUn6u3SoHwFI1sJfMh7QE8BAGeJq//SrifHJ3lkv8gzxswBby2
         B5xz6NcYR5cStc+YLsQi+yTFUKw6lzvrnKmlcldRuuWMirjajG7/S72RTZ/F7D9JDKBG
         JkU2tX3/ErmK9U0Ph35VWEYYryn65YzJ8lDcQRvkOi858UYYLvNiRcLHzBgzsOR8lH9k
         kAWqkX809aXNZPCqrzBUbsn5j+QpxQdhB854weQKdIakEs7aowyqyDUNGiqKwpvgjt5l
         K/Ax9rzQWh2+b4BkiI8T35NJHq1FxC/Dl6BeF61uR78L7wq4mSc3bFf5PTc1yyA+GPYj
         PESw==
X-Forwarded-Encrypted: i=1; AHgh+Rqj5etDvUJMTj4RKET4RENBGrYXHOciuOTE7MstACm7L4ui+alL8h+63zy/K6Scp+P5E7ofWMoGkQ==@kvack.org
X-Gm-Message-State: AFuF++l4R29DCGAY5t1pUxWOL01HdRKvTy5bx5aonRtBaJ5/uF/tQP8w
	OJyAaKK8vucjcwr4Un8j+G/0xk8yo3hmw/zeCDIQpb2rv7N9YpU4iEDH0gGk6XNHEg==
X-Gm-Gg: AR+sD10akm0qKupqDOOI/XiUU4h99szQspSvS6ReCo3gveGsDA1mfT1b1IcJEMrmr/H
	MbIpnkYpUDtZBW68m7nxy3NRFcPeKRraj9JMq9/bUX7OFKG82L8RZ0GfMYWLJjkhk9NEG95QwhE
	FEzVa5aL77rCVBSHXymwp3DUbptEEnzyKpB+uqEXQ74wMFTqVa1xEZNLQo6FK/zPU6RcJoBgyNm
	LFA5q2ClfaKj6YT0vmPUiLWjRpIML9ogHkXTjKN60VRkcO3F+A7N5jEMPqYLYmF7UpBdLt/uhlu
	PRTFeoZGscGRQEJoyKnKfRHsAoy+j+Lnl/JUe2uOOETM2oIdnA6pDsIFVQO9rPNYSPe8EF7X9K/
	Cgu1lmmdEFIcLp26SK/XXBjdV/LsgIF4BcX2f3Tk4aGbXZ8UHZpOdkFA3OKAzb0KqsZpT+mQ2kq
	tYqvepzb2lfNNZHV3IEHB6dZ8YSJw67ZXJE7jW2M7fp/WAFktt3s98GhzfgxRProDtfCeG/HB4F
	gxOWEwUAnKrILJbBYWnYYtn+jrYALCADfd4tCqW65Y1eCE=
X-Received: by 2002:a05:6402:2023:b0:67b:7d05:60b8 with SMTP id 4fb4d7f45d1cf-6a5c4a423a0mr72402a12.10.1787683174081;
        Tue, 25 Aug 2026 11:39:34 -0700 (PDT)
Received: from localhost ([2a00:79e0:288a:8:980a:b43:2df6:51f2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c250a702c7asm82067566b.19.2026.08.25.11.39.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 11:39:33 -0700 (PDT)
From: Jann Horn <jannh@google.com>
Date: Tue, 25 Aug 2026 20:39:19 +0200
Subject: [PATCH v2 3/3] selinux: require PROCESS__PTRACE for FOLL_FORCE
 introspection
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260825-selinux-pokemem-v2-3-b46bc64916d8@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787683164; l=2509;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=Ns+udTpi8SWKloYkKMw8Din2oarGSCfqpMuFm48xRLo=;
 b=zeD7wBrHYoqhVh6HblaO+73EuAz1CQeVXst7AZwlAE/ssLvvQw8Ia6UL9q7TkXPnVftUvkutA
 EZh2GLrwyjZCNMAdQM0EcaCQZx1Tr+oTA0Tv+2dWEkEGth/XbX8l9/W
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=
X-Stat-Signature: i5isboi5wq5mg69p1tioixsah5tjb6ce
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 000BEC000D
X-Rspam-User: 
X-HE-Tag: 1787683175-819611
X-HE-Meta: U2FsdGVkX1//a3sjrNrGQ9XoPjFIKAdKyspNJ9vzG1fclCPwO9An0sCi3tPPqycg/KEb0T5Ea+Hzd9ZBHnvqLPuebuEZj7bF9npfXFuzxfdGWZZx6l0Zscv7jyodB/JcofR9ciBtfF81B3jy5YuIR9dVZxmdgKd+8kn/5P4kRHeoaLWqGx5e7g4+cKoIiBz5pJHS8cgyu8C2kRBRKlefIsYxLlt2OnFtuMDrIFNWkLQf94KI93quffITkz8/2GOJV//T/Q1B1lk9pbIRg9GHNMNK4AO9V7fSqadYIRuKI5M6OjBD4G3jsqVqJJqsxqyGZu4rN94SGeMER7ckuB3lVV1akTqjLVdzcCtFRK2ueclmp58jU03nbVR2Bfp9BS9jZvpvMyKJs5ZGMkFX5WtmkibbpRIVT+lZiyndvitEHPO6PXqQ63oD+EYZ/ARvFVho2ahQ6l7/tkaBzSP/UhB9fvB1fp/zt40x5sBQaTDoXlOgEqsk9SARht7xLQqSo/fazsP+lwBnooOnf/RNjyvnMOeprhqbRuOCNqIM25p+UjmM0fIW4kVfEwdtc5xRxPyiO0x7X2LirKOO2PIpMrOJT4NVrF/pPotQTKK0bbEEsKk+6nXq712XvvtHWO9xl3M76L9M3vWLpj2wqoLEwi+W90YhPQTHGdO7PHUgne5j/G9PkZ9l/w1d3yIZiqgeWL1veJW6MHWNQTkSEkSQ9guCIzF/AfJVyPpxjM0ijBFsRIhdfybYyXWGiSxJPv2wIHkARiD9NVz971V5xYVfIme9hZPcvAhBoGRdqTo94uXZDgAVNrBEyrYf0MXEFRVef7LBvXJLg+F/TirtGqAEkCsJHT8GP1G3md6sRyWdVuAoczugec6KpRSUv22mleL3G6Om8p/vv11x9ALfojXxAvGWVSIpIR/qKEKeo68LbKUmw2OLpADJMD9jb3voMcy3JnRglJdrtxp0N1OoVyTHvLL
 CMSR27wF
 8Z2P/ATeWCR+thDArwibW14YueEtkf6b2uiW1DPSVrHS+TdxKz2X8lI4ZT1xrpInTHRi3X1jO5EZx1R6kFe2zKeRqlotUKtNFVBXjMdATelRJ5KhSLVHqvB/KZMK5QCcDAGk3xO9q5cBhk4FaIjp2jm/wko+gAYMPmWCo3xbMKiHXmphC7VxcW2WDA8S2R5hUIjlmNCOaM7hoP0jserM5wwuQnEnbwbW59W6UHW0SSjkkY+FAkA8UUjTHC5mA9sq1nz/b4IChRtU+xE6g8wZPZLRdYm4rpGqcPaPffqWl+wc60BFnkRQ2iAmOUHJVhAjcuVan4fsVNknPdPecJq7AdEqOSOjd41Bj1JqGmymi4kCXYJBCmb61uTbNXZmLyhTHESMu/bLYFhUzfaergo4ZWtp4KnO0RScinzBlm1yn7ak6SKOH+0OM1i8R32QKE5uOf/7KppHFkeSXQO+uLay+TzR9nGAfPxB88F6ZB11E1+4CjBENKFWkGGuH9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On systems configured with PROC_MEM_FORCE_ALWAYS, ensure that a process can
only create anonymous executable memory via /proc/self/mem if it has
PROCESS__PTRACE (like when using /proc/$pid/mem of another process).

This closes a hole in code integrity enforcement that Project Zero has used
in a remote Android exploit chain:
It was possible to use a memory corruption bug in a service without
EXECMEM/EXECMOD/PTRACE permission to overwrite executable code via
/proc/self/mem, which made it possible to load and run shellcode containing
a kernel exploit.

Signed-off-by: Jann Horn <jannh@google.com>
---
 security/selinux/hooks.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 18dd28b2bb13..2c2c60e9e0fe 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2157,6 +2157,27 @@ static int selinux_ptrace_traceme(struct task_struct *parent)
 			    SECCLASS_PROCESS, PROCESS__PTRACE, NULL);
 }
 
+/*
+ * Decide whether it should be possible to read non-readable VMAs and write
+ * non-writable VMAs via /proc/self/mem.
+ * This only applies to systems configured with PROC_MEM_FORCE_ALWAYS, and only
+ * triggers on accesses that are not visible to selinux_ptrace_access_check()
+ * because of the introspection exceptions in may_access_mm() and
+ * __ptrace_may_access().
+ *
+ * This allows a process to overwrite read-only code in its own address space.
+ *
+ * Creating an audit record on denial doesn't make sense here, since we can't
+ * tell whether FOLL_FORCE matters for the accessed VMAs.
+ */
+static int selinux_mem_foll_force_opened_by_owner(const struct cred *subject)
+{
+	struct av_decision avd;
+	u32 sid = cred_sid(subject);
+
+	return avc_has_perm_noaudit(sid, sid, SECCLASS_PROCESS, PROCESS__PTRACE, 0, &avd);
+}
+
 static int selinux_capget(const struct task_struct *target, kernel_cap_t *effective,
 			  kernel_cap_t *inheritable, kernel_cap_t *permitted)
 {
@@ -7558,6 +7579,7 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
 
 	LSM_HOOK_INIT(ptrace_access_check, selinux_ptrace_access_check),
 	LSM_HOOK_INIT(ptrace_traceme, selinux_ptrace_traceme),
+	LSM_HOOK_INIT(mem_foll_force_opened_by_owner, selinux_mem_foll_force_opened_by_owner),
 	LSM_HOOK_INIT(capget, selinux_capget),
 	LSM_HOOK_INIT(capset, selinux_capset),
 	LSM_HOOK_INIT(capable, selinux_capable),

-- 
2.55.0.860.g4b6b3295ed-goog


