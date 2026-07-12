Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 481ECC43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 04:09:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86EE56B0096; Sun, 12 Jul 2026 00:08:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84A356B009B; Sun, 12 Jul 2026 00:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70EFA6B009D; Sun, 12 Jul 2026 00:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3722A6B0096
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 00:08:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B1CB31C9278
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 04:08:57 +0000 (UTC)
X-FDA: 84978793914.04.E97552B
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id BE4A920004
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 04:08:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="rcsx/8hP";
	spf=pass (imf03.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783829335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aH3kKOMcwn56DSlHVteprYGWMctwEqxrrgXOQeiC+bw=;
	b=CFDsIkGrb46OWcTpE33YOt76OuIOocBmJbajiQh0rwyQ90+/Y+MCXKX78/uFcXr7onN55s
	B//MW5d0IYyOMgx/HWLITEYE/ShP8nQVdyS2orPiyHMRUNIflRjP36QNu1gTIrkmAXoYjs
	zmOJwmUgQNUK+zTHT5FYhOz96JYCazA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="rcsx/8hP";
	spf=pass (imf03.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783829335;
	b=DhgHfrv6SozryPFYzr3mQGJT3dk73Q/vX0Pq+D8bUQByBRpE1j5+54HfhB6V30W9cWEYaH
	ULTs6q8n3azvk0z0rr93nTFGiGxSKgI5g21RyAIJ2iaRtoGgWjBfLOTyIJnk0a2xgzldtK
	xelhiRpV/Tga0mywnd6zhs8CHY6n66Q=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cc61541f8cso38003575ad.0
        for <linux-mm@kvack.org>; Sat, 11 Jul 2026 21:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783829335; x=1784434135; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aH3kKOMcwn56DSlHVteprYGWMctwEqxrrgXOQeiC+bw=;
        b=rcsx/8hPDdioS7Hf/9PMhd3WhmiycTDsuikWIOzIoR91Wcqu9S1mHAZWtqObzXpw7N
         6UkB1sJRqVeLdjGBSb2KXdoVtkUeP2n4YG8eH8YDkzDTalitiuVJaPTdeWBhHM+ydkEy
         lc83xpf7seQ0vtc5gzJ/BIGnmimLWua8PRx7p7bSZMHrgkQ6awQqtO1dV6dwBL+tOn6x
         1U8nNkhwLAO70S+xHOH5fpzze+umtysdfNGr8gffjGbdWDOtQbkolyzmqBCSmDYFBl/n
         tR/AmSwMtDz57LfDeecPMLrYDR7a3ar+43A2UwIOB9BnrtAWzUCSSnMUTL+2fdFwVUYj
         FZDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783829335; x=1784434135;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aH3kKOMcwn56DSlHVteprYGWMctwEqxrrgXOQeiC+bw=;
        b=IN3VPSnA7+Sp5VtrR9hXHzKdyF+A7MKkFvAoG1CX7np2H7iF/gwYee1JZ1DkjASWC0
         HoKhNnF+env23TSkgWRnAsf/CORtPKnSrBb/Ys/wAUQIkoCrZqcElVS/3tWnC7VrV9uG
         1gZFTrLqo5N+TrbPDAxJ0Gx9vAIp6TqNvPXvES/cqr2tWTfiJeKu1sZbEKAKgFKvldKY
         ds11/LV4ES9Mszurh/MiVVbiKFJDrwy81p9BjbkpUkGdnBqK+aSo/AL0nyDbOFKPfLAK
         i7sA/DrDxsEqGCJxVxiJa6Cmo12AjvXwubTcHHnMchokS86QU5SyGvHIiDVxYXzLBHd4
         qPug==
X-Forwarded-Encrypted: i=1; AHgh+RoYN6BHXQ8n4ADR4PRTV631jR14dM0bjxeD+2So7/zIc5+uvtU4g2kgqxX2TtqRYczDopXGb9qT7g==@kvack.org
X-Gm-Message-State: AOJu0YzANxUlbHHBtU87COEg0+vOX+9e3t3Wff4xAh0usF1dCkWT/OH5
	WxzzvzDGB/lMB0mbWwZ1GoAl0Pu+iaPEf8S5ojAW5VkzUnIfGi2C2Ap9
X-Gm-Gg: AfdE7ck8EFPoM8G0pMy3kWDHpMrITDJY72mA60FuPPNRESs4sWYkM5QefDRz2v3I5Gd
	J2fA6YCT5Yae7ki9nfPNTEeWeFcihlE1Gs0ec/5nuaFCzMdDAiJmHTbC+F8O8ys/TSlzo/7W5DJ
	n8cJivSAzvoX+zzFQd6upxHCEmZyxkxvfaegA0hTEhXg5nx+S3pKheDWK6aU3B6Sq1qO4OpkdNw
	3ZG5QBHHEu8p/kExPEg4vnw5+FhmIfWJBv3HViEayif3gxJc5Twt4eNR+MR+XAnzbC47tX/NdCa
	CeVFaxaOwIRyzCGWIucFQ1REJ1hhJ0cqxDCnezr9oiGPB1R6ncSrMYiR9LQscIFGfRmndXcgC6P
	t0NBujswFwZ/axrd/kEJkFefZgsN5qExPMk/vxDiNz8Ybtg60uD2Ge93kXRNq4jAamWhhB4PbwL
	uPU36muG1WzmcAp33v
X-Received: by 2002:a17:90b:3f84:b0:387:d5bd:622e with SMTP id 98e67ed59e1d1-38dc83734a0mr3348857a91.17.1783829334478;
        Sat, 11 Jul 2026 21:08:54 -0700 (PDT)
Received: from [127.0.0.2] ([98.35.8.117])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31174839f89sm56808928eec.10.2026.07.11.21.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 21:08:53 -0700 (PDT)
From: Farid Zakaria <farid.m.zakaria@gmail.com>
Date: Sat, 11 Jul 2026 21:08:16 -0700
Subject: [PATCH v2 3/5] binfmt_misc: wire up bpf-backed 'B' entries
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260711-binfmt-misc-bpf-v2-v2-3-d6591ceaf207@gmail.com>
References: <20260711-binfmt-misc-bpf-v2-v2-0-d6591ceaf207@gmail.com>
In-Reply-To: <20260711-binfmt-misc-bpf-v2-v2-0-d6591ceaf207@gmail.com>
To: Christian Brauner <brauner@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Shuah Khan <shuah@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, Jann Horn <jannh@google.com>, 
 John Ericson <mail@johnericson.me>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Farid Zakaria <farid.m.zakaria@gmail.com>
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BE4A920004
X-Stat-Signature: 57nptzgu15ang67z5suuep8ad49ymwu9
X-HE-Tag: 1783829335-289783
X-HE-Meta: U2FsdGVkX1/fiUSZ6xv8RReLIbhvqR/CsKzdeMgV7Aydh6UeFVTQUZ40hc7Fi9/ZjoYWClwlnp6nIvSBx4ufI1tHdHRMuUw2NFenKLYROvsg2hM9qu15bB5BerneuPOTQ5/3r/yL5xE5e5D6T28PfgLje5RRkpgygvq4V6/MakwwycTUMlbCmRUmKSOQGtuDFwaOBQqloruOxw6IvvmyJyfNySmHmjQng8FOxwvZUVJfWsFfCSmXtvDEnSfvunUHwECOIBn/VIyCmVx2hgKnYFEZmpnKloQLAcz4uLeP/XNybXJMO5VOXttYbL7yMhGm6c/6oyS3NIUQRZNLQZz8J3yAPmYvBRSdle8cmqhnrEJta2elwfB3crLF6H7LW++ytPCc7MnOeM6D+FqbfIqSHLLFkrvYlW/q3xbSFFLbDci1L84yIcvGHh6xwinTvBxZfAnpXFlcdIB/9kTmODPtUfsMnF95TWtwZb8UXm5X9YvLQ82co6X/znlHCVMvNSINUMzUSziCnRXq0tUm+mhs6JNeG2F+oKuSCov313/b0X86Hi/2gBQJ/1dBxDbAHyOyVb/JdmvICHQzKmwb6Zq3BKC13EchSlx+nYBrwdQcxfiiQqKHmY87drSijf4ESnrI+F0wUnhIiRo5oj+twh313LPVMZMbqU3aCU68719eo10MgOgeeXLoCVQNf+HPt0t+D0j/pT/1kZr3qnVyu7fEtf/NpwZN2BIHwHi16wPu75qkej9hmYdcORwZ4Bp4dSoat2IulSUOm+dUyFe+zJFl7TvjPh2vnOJmfhskCEzbMFpQeCtL/aB1SRcWAQ5WwAbnRzB0ICBS9no2Eb4NkMB3ZoVY51D4Z6LC4MZIXkAKukRvXh7kaHAIL4XnFjYfwCS/tZDRaMaljuTWOIS++g/OQ3KhNu5ChMBaGXcDpxZuHRKGAL4i4GEXn+tHyrYrsNvTGoCZETrwB5g+667+hsC
 PNIQ5vEM
 9uUHznr+e/ZYD3JYJcxt0FJrHGrGdYd4sblJXZ4P6RgyKFzKhYiOh3jPyo9V1g4wmBABqG9RpJw2oU9Y1NfpXCGTFo+D21Ev+xauK2gn3Pa5eFhobhFsVRWPCE3jSh0TLtFo4qBsawbSZWUB5R4QOQdw/5DdFhQlaPCITrUrlfeOHV9269hnSVbhIKZKoKB/THP7PlDrxFzWLxCs1NeH3mR1vMstviIdC1ORx6SJIPYeVXeW3wWlaSAVvzeErOELLQi1WoaQUBsINzgLXGpgbZJ4ZqjfV+NJ8KClA3E3PxXjXzmKty1H3DCzwX/ak9zxArID9qONqqTVeYtblAT9B82qTH/RrQVZ+JjRJ/S0wj0T/7hImuW4X8SsiF78WSYp70xlD+cjwNhDbkEW9em1vgfUQ8x9GPSFdKeRdZTMFGlfiV6BRT5IRqcffaZjqI0QpdUInQxQkb6Jg4H8svzIfDaMX5r6B44OwszvG0U7OoKA9cxfTVb84dXITzLBgJtf7N9Fr6jN2E84Zib4X9SIL3rrbnil9KBDqZItUFOiBtPL0HAuDCCAZnF/lwbmZefWQ8kcALLdw1h6bU0L1iyr15D5UubQkmlnaHFnH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Christian Brauner <brauner@kernel.org>

Activate a registered binfmt_misc_ops handler through the existing text
interface with the new 'B' entry type:

	echo ':name:B:<handler-name>::::' > <binfmt_misc>/register

The offset field carries the handler name; magic, mask, and interpreter
must be empty since the program supplies both the matching and the
interpreter. Reusing the register file keeps the existing permission
model intact: activating a handler requires the same write access to a
binfmt_misc instance as any other registration, and the per user
namespace instance semantics apply unchanged. A 'B' entry in a
container's own instance shadows the host's handlers just like any
other entry, and the privilege needed to shadow e.g. all ELF binaries
is the same as for a static 'M' entry matching \x7fELF today; the only
novelty is that matching becomes programmable.

The entry takes its own reference on the ops for its whole lifetime.
It is dropped in put_binfmt_handler() next to the MISC_FMT_OPEN_FILE
interp_file cleanup, which the existing users refcount already defers
past any concurrent load_misc_binary(), and explicitly on the
registration failure path where the users refcount is not live yet.

The program runs from load_misc_binary(), never from the matching walk
under entries_lock: the read_lock disables preemption while the load
program must be able to sleep to read file content. search_binfmt_handler()
therefore only nominates the next enabled 'B' entry and the program
decides outside the lock. A declining program (returning 0) falls
through to handlers registered after it via a skip cursor and a rescan;
entries registered or removed between rescans can shift the cursor, so
a program may be consulted twice in that window, which is harmless
since matching must be free of side effects. Returning a positive value
without having selected an interpreter terminates the binfmt_misc scan
with -ENOEXEC so the remaining binary formats still get a shot.

The 'C' and 'F' flags are rejected for 'B' entries. 'F' exists to
pre-open a fixed interpreter at registration time in the registrar's
context which is meaningless for a per-exec computed path. 'C' honors
the suid bits of the matched binary while executing the interpreter;
combined with a program-chosen interpreter that would let a user
namespace root pick what runs with a setuid binary's credentials. The
computed path itself cannot widen access: it is opened with open_exec()
under the caller's credentials with the usual LSM and noexec checks,
identical to a statically registered interpreter.

Link: https://lore.kernel.org/20260704211409.1978485-1-farid.m.zakaria@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Co-developed-by: Farid Zakaria <farid.m.zakaria@gmail.com>
Signed-off-by: Farid Zakaria <farid.m.zakaria@gmail.com>
Assisted-by: Claude:Opus-4.8
---
 Documentation/admin-guide/binfmt-misc.rst |  40 +++++++-
 fs/binfmt_misc.c                          | 149 +++++++++++++++++++++++++++---
 2 files changed, 175 insertions(+), 14 deletions(-)

diff --git a/Documentation/admin-guide/binfmt-misc.rst b/Documentation/admin-guide/binfmt-misc.rst
index 306ef48f5..de948dae7 100644
--- a/Documentation/admin-guide/binfmt-misc.rst
+++ b/Documentation/admin-guide/binfmt-misc.rst
@@ -26,11 +26,13 @@ Here is what the fields mean:
    name below ``/proc/sys/fs/binfmt_misc``; cannot contain slashes ``/`` for
    obvious reasons.
 - ``type``
-   is the type of recognition. Give ``M`` for magic and ``E`` for extension.
+   is the type of recognition. Give ``M`` for magic, ``E`` for extension and
+   ``B`` for a bpf-backed handler (see below).
 - ``offset``
    is the offset of the magic/mask in the file, counted in bytes. This
    defaults to 0 if you omit it (i.e. you write ``:name:type::magic...``).
-   Ignored when using filename extension matching.
+   Ignored when using filename extension matching. For ``B`` entries this
+   field carries the name of the bpf handler instead.
 - ``magic``
    is the byte sequence binfmt_misc is matching for. The magic string
    may contain hex-encoded characters like ``\x0a`` or ``\xA4``. Note that you
@@ -97,6 +99,40 @@ There are some restrictions:
    offset+size(magic) has to be less than 128
  - the interpreter string may not exceed 127 characters
 
+
+bpf-backed handlers
+-------------------
+
+With ``CONFIG_BINFMT_MISC_BPF`` both the matching and the interpreter
+selection can be delegated to a bpf program. A handler is an instance of the
+``binfmt_misc_ops`` struct_ops with a sleepable ``load`` program and a
+``name``. Once the struct_ops map is registered the handler can be activated
+with a ``B`` entry that references it by name and carries neither magic,
+mask, nor interpreter::
+
+    echo ':qemu:B:my_handler::::' > register
+
+At exec time the ``load`` program receives the ``linux_binprm`` of the
+binary. It can match on the header in ``bprm->buf``, read the file itself,
+e.g. to parse ELF program headers, and derive the interpreter from the
+binary's location. It selects the interpreter by calling the
+``bpf_binprm_set_interp()`` kfunc with an absolute path and returning a
+positive value. Returning ``0`` falls through to the handlers registered
+after this one, a negative errno fails the exec with that error;
+``-ENOEXEC`` ends the binfmt_misc search but lets the remaining binary
+formats have a go. The interpreter is opened with the credentials of the
+task doing the exec, exactly as a statically registered interpreter would
+be.
+
+Handlers are looked up in the user namespace the struct_ops map was
+registered in, falling back to ancestor namespaces, mirroring how
+binfmt_misc instances themselves are looked up. The entry keeps the handler
+alive; deleting the struct_ops map only prevents new registrations.
+
+The ``C`` and ``F`` flags cannot be combined with ``B`` entries: there is no
+fixed interpreter to pre-open and a program-selected interpreter must never
+inherit the credentials of a setuid binary.
+
 To use binfmt_misc you have to mount it first. You can mount it with
 ``mount -t binfmt_misc none /proc/sys/fs/binfmt_misc`` command, or you can add
 a line ``none  /proc/sys/fs/binfmt_misc binfmt_misc defaults 0 0`` to your
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index fcaad14f8..4ece75f95 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -11,6 +11,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/binfmts.h>
+#include <linux/binfmt_misc.h>
 #include <linux/bitops.h>
 #include <linux/bits.h>
 #include <linux/bug.h>
@@ -38,6 +39,7 @@
 enum binfmt_misc_entry_bits {
 	MISC_FMT_ENABLED_BIT	= 0,
 	MISC_FMT_MAGIC_BIT	= 1,
+	MISC_FMT_BPF_BIT	= 2,
 };
 
 /* Entry behavior flags, fixed at registration time. */
@@ -59,6 +61,8 @@ struct binfmt_misc_entry {
 	char *name;
 	struct dentry *dentry;
 	struct file *interp_file;
+	const struct binfmt_misc_ops *bpf_ops;	/* bpf-backed handler ('B') */
+	const char *bpf_ops_name;
 	refcount_t users;		/* sync removal with load_misc_binary() */
 	struct rcu_head rcu;
 	char buf[];			/* register string, fields point in here */
@@ -109,16 +113,21 @@ static bool entry_matches_extension(const struct binfmt_misc_entry *e,
  * search_binfmt_handler - search for a binary handler for @bprm
  * @misc: handle to binfmt_misc instance
  * @bprm: binary for which we are looking for a handler
+ * @bpf_skip: number of bpf-backed handlers to skip over
  *
  * Search for a binary type handler for @bprm in the list of registered binary
- * type handlers.
+ * type handlers. A bpf-backed handler cannot be matched here as its program
+ * must run in sleepable context; it is returned as a candidate and the
+ * program decides in load_misc_binary(). @bpf_skip resumes the search after
+ * the first @bpf_skip candidates declined.
  *
  * The caller must hold the RCU read lock.
  *
  * Return: binary type list entry on success, NULL on failure
  */
 static struct binfmt_misc_entry *
-search_binfmt_handler(struct binfmt_misc *misc, struct linux_binprm *bprm)
+search_binfmt_handler(struct binfmt_misc *misc, struct linux_binprm *bprm,
+		      unsigned int bpf_skip)
 {
 	char *dot = strrchr(bprm->interp, '.');
 	const char *ext = dot ? dot + 1 : NULL;
@@ -130,6 +139,15 @@ search_binfmt_handler(struct binfmt_misc *misc, struct linux_binprm *bprm)
 		if (!test_bit(MISC_FMT_ENABLED_BIT, &e->flags))
 			continue;
 
+		/* A bpf handler is decided in load_misc_binary(). */
+		if (test_bit(MISC_FMT_BPF_BIT, &e->flags)) {
+			if (bpf_skip) {
+				bpf_skip--;
+				continue;
+			}
+			return e;
+		}
+
 		if (test_bit(MISC_FMT_MAGIC_BIT, &e->flags)) {
 			if (entry_matches_magic(e, bprm))
 				return e;
@@ -146,6 +164,7 @@ search_binfmt_handler(struct binfmt_misc *misc, struct linux_binprm *bprm)
  * get_binfmt_handler - try to find a binary type handler
  * @misc: handle to binfmt_misc instance
  * @bprm: binary for which we are looking for a handler
+ * @bpf_skip: number of bpf-backed handlers to skip over
  *
  * Try to find a binfmt handler for the binary type. If one is found take a
  * reference to protect against removal via bm_{entry,status}_write(). The
@@ -156,13 +175,14 @@ search_binfmt_handler(struct binfmt_misc *misc, struct linux_binprm *bprm)
  * Return: binary type list entry on success, NULL on failure
  */
 static struct binfmt_misc_entry *get_binfmt_handler(struct binfmt_misc *misc,
-						    struct linux_binprm *bprm)
+						    struct linux_binprm *bprm,
+						    unsigned int bpf_skip)
 {
 	struct binfmt_misc_entry *e;
 
 	guard(rcu)();
 	do {
-		e = search_binfmt_handler(misc, bprm);
+		e = search_binfmt_handler(misc, bprm, bpf_skip);
 	} while (e && !refcount_inc_not_zero(&e->users));
 	return e;
 }
@@ -182,6 +202,8 @@ static void put_binfmt_handler(struct binfmt_misc_entry *e)
 			exe_file_allow_write_access(e->interp_file);
 			filp_close(e->interp_file, NULL);
 		}
+		if (e->bpf_ops)
+			binfmt_misc_put_ops(e->bpf_ops);
 		/* Lockless walkers may still dereference this entry. */
 		kfree_rcu(e, rcu);
 	}
@@ -224,13 +246,16 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	struct binfmt_misc_entry *fmt __free(put_binfmt_handler) = NULL;
 	struct file *interp_file;
 	struct binfmt_misc *misc;
+	const char *interpreter;
+	unsigned int bpf_skip = 0;
 	int retval;
 
 	misc = current_binfmt_misc();
 	if (!READ_ONCE(misc->enabled))
 		return -ENOEXEC;
 
-	fmt = get_binfmt_handler(misc, bprm);
+retry:
+	fmt = get_binfmt_handler(misc, bprm, bpf_skip);
 	if (!fmt)
 		return -ENOEXEC;
 
@@ -238,6 +263,37 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	if (bprm->interp_flags & BINPRM_FLAGS_PATH_INACCESSIBLE)
 		return -ENOENT;
 
+	if (test_bit(MISC_FMT_BPF_BIT, &fmt->flags)) {
+		/*
+		 * A bpf-backed handler matches and picks the interpreter in
+		 * sleepable context: > 0 means it handled the binary, 0 falls
+		 * through to the handlers after this one and a negative errno
+		 * fails the exec.
+		 */
+		retval = fmt->bpf_ops->load(bprm);
+		if (retval < 0) {
+			/* Keep a program-supplied error within errno range. */
+			if (retval < -MAX_ERRNO)
+				retval = -ENOEXEC;
+			return retval;
+		}
+		if (!retval) {
+			/* Declined: move on to the handlers after this one. */
+			kfree(bprm->bpf_interp);
+			bprm->bpf_interp = NULL;
+			put_binfmt_handler(fmt);
+			fmt = NULL;
+			bpf_skip++;
+			goto retry;
+		}
+		/* Selecting an interpreter is part of the contract. */
+		if (!bprm->bpf_interp)
+			return -ENOEXEC;
+		interpreter = bprm->bpf_interp;
+	} else {
+		interpreter = fmt->interpreter;
+	}
+
 	if (fmt->flags & MISC_FMT_PRESERVE_ARGV0) {
 		bprm->interp_flags |= BINPRM_FLAGS_PRESERVE_ARGV0;
 	} else {
@@ -256,13 +312,13 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	bprm->argc++;
 
 	/* add the interp as argv[0] */
-	retval = copy_string_kernel(fmt->interpreter, bprm);
+	retval = copy_string_kernel(interpreter, bprm);
 	if (retval < 0)
 		return retval;
 	bprm->argc++;
 
 	/* Update interp in case binfmt_script needs it. */
-	retval = bprm_change_interp(fmt->interpreter, bprm);
+	retval = bprm_change_interp(interpreter, bprm);
 	if (retval < 0)
 		return retval;
 
@@ -277,7 +333,7 @@ static int load_misc_binary(struct linux_binprm *bprm)
 			}
 		}
 	} else {
-		interp_file = open_exec(fmt->interpreter);
+		interp_file = open_exec(interpreter);
 	}
 	if (IS_ERR(interp_file))
 		return PTR_ERR(interp_file);
@@ -428,6 +484,38 @@ static char *parse_extension_fields(struct binfmt_misc_entry *e, char *p,
 	return p;
 }
 
+/* Parse the 'offset' field of a 'B' entry: the bpf handler name. */
+static char *parse_bpf_fields(struct binfmt_misc_entry *e, char *p, char del)
+{
+	char *s;
+
+	/* The 'offset' field carries the bpf handler name. */
+	s = strchr(p, del);
+	if (!s)
+		return NULL;
+	*s++ = '\0';
+	e->bpf_ops_name = p;
+	if (!e->bpf_ops_name[0] ||
+	    strlen(e->bpf_ops_name) >= BINFMT_MISC_OPS_NAME_MAX)
+		return NULL;
+	p = s;
+	pr_debug("register: bpf handler: {%s}\n", e->bpf_ops_name);
+
+	/* The 'magic' field must be empty. */
+	s = strchr(p, del);
+	if (!s || s != p)
+		return NULL;
+	*s++ = '\0';
+	p = s;
+
+	/* The 'mask' field must be empty. */
+	s = strchr(p, del);
+	if (!s || s != p)
+		return NULL;
+	*s++ = '\0';
+	return s;
+}
+
 /*
  * This registers a new binary format, it recognises the syntax
  * ':name:type:offset:magic:mask:interpreter:flags'
@@ -492,13 +580,21 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 		pr_debug("register: type: M (magic)\n");
 		e->flags = BIT(MISC_FMT_ENABLED_BIT) | BIT(MISC_FMT_MAGIC_BIT);
 		break;
+	case 'B':
+		if (!IS_ENABLED(CONFIG_BINFMT_MISC_BPF))
+			return ERR_PTR(-EINVAL);
+		pr_debug("register: type: B (bpf)\n");
+		e->flags = BIT(MISC_FMT_ENABLED_BIT) | BIT(MISC_FMT_BPF_BIT);
+		break;
 	default:
 		return ERR_PTR(-EINVAL);
 	}
 	if (*p++ != del)
 		return ERR_PTR(-EINVAL);
 
-	if (test_bit(MISC_FMT_MAGIC_BIT, &e->flags))
+	if (test_bit(MISC_FMT_BPF_BIT, &e->flags))
+		p = parse_bpf_fields(e, p, del);
+	else if (test_bit(MISC_FMT_MAGIC_BIT, &e->flags))
 		p = parse_magic_fields(e, p, del);
 	else
 		p = parse_extension_fields(e, p, del);
@@ -511,8 +607,13 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 	if (!p)
 		return ERR_PTR(-EINVAL);
 	*p++ = '\0';
-	if (!e->interpreter[0])
+	if (test_bit(MISC_FMT_BPF_BIT, &e->flags)) {
+		/* The program selects the interpreter at exec time. */
+		if (e->interpreter[0])
+			return ERR_PTR(-EINVAL);
+	} else if (!e->interpreter[0]) {
 		return ERR_PTR(-EINVAL);
+	}
 	pr_debug("register: interpreter: {%s}\n", e->interpreter);
 
 	/* Parse the 'flags' field. */
@@ -522,6 +623,14 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 	if (p != buf + count)
 		return ERR_PTR(-EINVAL);
 
+	/*
+	 * A program-selected interpreter cannot be pre-opened and must not
+	 * inherit the credentials of a setuid binary it was chosen for.
+	 */
+	if (test_bit(MISC_FMT_BPF_BIT, &e->flags) &&
+	    (e->flags & (MISC_FMT_CREDENTIALS | MISC_FMT_OPEN_FILE)))
+		return ERR_PTR(-EINVAL);
+
 	return no_free_ptr(e);
 }
 
@@ -575,7 +684,10 @@ static int bm_entry_show(struct seq_file *m, void *unused)
 	else
 		seq_puts(m, "disabled\n");
 
-	seq_printf(m, "interpreter %s\n", e->interpreter);
+	if (test_bit(MISC_FMT_BPF_BIT, &e->flags))
+		seq_printf(m, "bpf %s\n", e->bpf_ops_name);
+	else
+		seq_printf(m, "interpreter %s\n", e->interpreter);
 
 	/* print the special flags */
 	seq_puts(m, "flags: ");
@@ -589,7 +701,9 @@ static int bm_entry_show(struct seq_file *m, void *unused)
 		seq_putc(m, 'F');
 	seq_putc(m, '\n');
 
-	if (!test_bit(MISC_FMT_MAGIC_BIT, &e->flags)) {
+	if (test_bit(MISC_FMT_BPF_BIT, &e->flags)) {
+		/* No magic or extension to print for a bpf handler. */
+	} else if (!test_bit(MISC_FMT_MAGIC_BIT, &e->flags)) {
 		seq_printf(m, "extension .%s\n", e->magic);
 	} else {
 		seq_printf(m, "offset %i\nmagic ", e->offset);
@@ -840,6 +954,15 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
 	if (IS_ERR(e))
 		return PTR_ERR(e);
 
+	if (test_bit(MISC_FMT_BPF_BIT, &e->flags)) {
+		e->bpf_ops = binfmt_misc_get_ops(sb->s_user_ns, e->bpf_ops_name);
+		if (!e->bpf_ops) {
+			pr_notice("register: no bpf handler named %s\n",
+				  e->bpf_ops_name);
+			return -ENOENT;
+		}
+	}
+
 	if (e->flags & MISC_FMT_OPEN_FILE) {
 		/*
 		 * Now that we support unprivileged binfmt_misc mounts make
@@ -864,6 +987,8 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
 			exe_file_allow_write_access(f);
 			filp_close(f, NULL);
 		}
+		if (e->bpf_ops)
+			binfmt_misc_put_ops(e->bpf_ops);
 		return err;
 	}
 

-- 
2.51.2


