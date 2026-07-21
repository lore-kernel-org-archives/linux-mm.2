Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 361C9C44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:15:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C121B6B00A5; Tue, 21 Jul 2026 10:15:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE9FB6B00A6; Tue, 21 Jul 2026 10:15:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A65746B00A7; Tue, 21 Jul 2026 10:15:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B2E96B00A5
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:15:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 126A5A02C3
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:15:04 +0000 (UTC)
X-FDA: 85012980528.04.6F0D430
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4F17A1C0016
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:15:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ItKCh1+8;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784643302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1MU+7JSdoi6orVVaIMQYqvBSkSC7CWSYlhT848v7s9c=;
	b=KxG2mNTz1XqLLB0X3H3PmkAtHkaflkehcwpVBpj0Jcli/VVFGgEVLfTiBoK18nClw1f59O
	JSBa+qTs0HgU/UXofU0Grna21+AEYFx4g3lIfxlSt+6C0UBDlf9FOZPVfRVves7Ff+GwS3
	V3dsUkyQZBt7AzogVPT9QsN6Sb3izz0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784643302;
	b=XS9w9QAtZrucK6f0yVNfBfVnRd7QAnjk4ghjJpoxutTTcb4ZUPtUhV4I+QVmPit6rOSC1r
	kdIPzvWMIpjNpiDFjwdUX9W7Jr2Ep6BpnMojZ9HokkBAihNtre0N93FPwNGSPqUT3Kh6Gg
	3S16NMg4qbdulTUlH0IbjEBmyDu7pyA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ItKCh1+8;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DAF8860204;
	Tue, 21 Jul 2026 14:15:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000D61F00A3A;
	Tue, 21 Jul 2026 14:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784643301;
	bh=1MU+7JSdoi6orVVaIMQYqvBSkSC7CWSYlhT848v7s9c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ItKCh1+8+Evtct+V4b8WoIioxv2P0XTOQ2/kg4rULAUBa4qeYBbLarLaxd2LHzvSU
	 GX58rIA3wZsKhdaO+vdKBfe3MiHllojsvwWCxa7nKtvCVIuLvstfrGCTxKF9RHbc6W
	 VQfcAHXBQmddmXWdDQft3P0B89mRgTQvQd1InAQ3zN9ooXth1NI1wrwtvxRnzDlT29
	 Nnme9rbKIdDgC7oiKLIeFL/OiYgGPkMa9pa2Ihk8+lCrIpoTAtjCPlBQhuzjoR0m2K
	 UQjK6F6Vl2AD6dymt+HeZ3z0Wso8+RmI3Y+Z8ypUfqBgjpTK4Vk2uS+VR1GzeFDPZy
	 aespPJbFsaXGQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 21 Jul 2026 16:13:53 +0200
Subject: [PATCH v2 11/21] binfmt_misc: add a static transparent flag 'T'
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-work-bpf-binfmt_misc-ptinterp-v2-11-e57866e4ae0f@kernel.org>
References: <20260721-work-bpf-binfmt_misc-ptinterp-v2-0-e57866e4ae0f@kernel.org>
In-Reply-To: <20260721-work-bpf-binfmt_misc-ptinterp-v2-0-e57866e4ae0f@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 linux-fsdevel@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=3017; i=brauner@kernel.org;
 h=from:subject:message-id; bh=xQkD7EvYlbnkQP6t+SOqQeUbRjqO8LeVxW0pS0icYbE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTF1x1oXjz3mW/rxyeufn8k5M52bl9fndzUYWvKw8b8V
 IHxPV9YRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwER+P2dkmFwhndPxpZDbbMG0
 3czB2k8SpdVckoKiGm//Nq1/XpOqxfA/NsuydGqDWcDTMJ33Kx9v52SIfqMyZ9mCrOfSPAtvRni
 xAQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4F17A1C0016
X-Stat-Signature: szikfnxbnke689snywsurh88fytwu4f8
X-Rspam-User: 
X-HE-Tag: 1784643302-198562
X-HE-Meta: U2FsdGVkX1/3zHTBEGa4b9BXhOCXfSPypO4yaxWvxPpx1EOnUXgMNFrJETsmEjnR6XfnZXxPma6ImUe+yoCpN5ifP4wn8/soYhRoxVvrmarcTB/4udO6FBxM97A8nx5nCh2Jgp92zbTRiNJFYzJSs85eLs1hXWUBdQLyXZ/5QPDSYO+wfK7I+wb5qq0INE24nWvYxQPkDgxEzhfR8Lbayra+0D7XkVX38XY8z7j8l9Z+gWTRw+maWw1Xvo0LQlexplpxD3uVkUSa4GdHCVMF7OvD6yMb2n2hKnb5WUrIklJT5W1NpOeoAWbLQHsc37hlOYwdo1jUa4i1k1u6KNvHbVbrlPmmgJDnWYr4hIS7EcsObINi+Imxp87Ot5Ep+4UKYh1Mj6MdWMfJbSYFXxVWE9l7dNwSWZVFgBZXTQM0qkl7MSy2jzhwVVs09Rjc82kNCuX7W4VJGkbWlzRnzAvJ2Rm23K3+DxVRMInRJiDSYvPGlAEEUb/a4htix7o9/6sAXuZHm3KCtlSFthzOM83y8xYwcnj2EAOpbnw9JLpnMnlHCvBjgCghv6tm+ISqXqllYD5jBOXtDDw4tdMtO12wZFt5pgHBM1Sw4pwO6ZSKXa8s/zuDKsb2XXu1depRkaRtv32BZ3XnkSErmtDWl98PzdmRroD5Fi7JNURe6FreZEYq/BPKYB4e/pE31FetmygSSdpFeOxM+sMOJ9HPxeqloAdoKKv1OB0eLE+G7UAjMeOZzNyQXhzAa5kUsuOInp86n+lscd1vsCrQfQ37R7C1OT9YUHknZvxeEhCSL8wAuU1rSHacjigWP92bGLA/z9BMrlsFEIkg0ZtcHQnoqJBfCaYC3Ah5fxgvg0lBkeZoAnPoB/QEuP4ByOIbb4HS37gNnV5jiyTZQLDBXbngavZnZVqRTtsPmECuDYpXMaW4JCo8fNxKJzuXRVnd6fqFcf1BnaiGDGILb+cRD4/3KXD
 GLoKUG/A
 AbpR7pNpfoESKsUoB1QCEzHeh4yB1bNRVXr4apbPTiYq3eubpgudzCg5+o5vHDx7V3qdG8VeC8+aX9sOytRpEHyZDwdMOPBI1daAdLOFdAJSIr3AsmaddDs6qLfkYQJHBmKpZPgCensm6sbDL0AkYlIqCWKi+LR707qYdLRhnZUeCU5NJKtiv80UOAsq7/D2/4dX4irWC3ChwCqFa2lUo9mRll1Est1pstpYyju8a0vsBkdPpBJPNRICH58Fo04g91wtJDVwMehW1EtuwyDrv1tZ++2EmiNiTXcm0X2OM4LsbNQcjKXxHLrP5uUDkTjJL1Pb7WkEhpa9haNqwfF4rir2L9lTX8NhC1scx9aZ3h91dgJ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let a registration opt into transparent dispatch. The 'T' flag lets a
matched binary keep its argument vector and is sent to the interpreter
through AT_EXECFD. The process's identity is the binary's.

'T' implies 'O' exactly like 'C' does. 'P' is rejected in combination
with it. Transparency preserves the whole argument vector so there is
nothing left for 'P' to say. 'C' remains an independent choice and 'F'
keeps working. A pre-opened interpreter is orthogonal to how the binary
is handed over.

Like the other flag characters 'T' cannot be used as the field
delimiter. The flag scan would run off the registration buffer.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/admin-guide/binfmt-misc.rst | 10 ++++++++++
 fs/binfmt_misc.c                          |  6 ++++++
 2 files changed, 16 insertions(+)

diff --git a/Documentation/admin-guide/binfmt-misc.rst b/Documentation/admin-guide/binfmt-misc.rst
index d689f21858b2..f0a0bdb681fe 100644
--- a/Documentation/admin-guide/binfmt-misc.rst
+++ b/Documentation/admin-guide/binfmt-misc.rst
@@ -90,6 +90,16 @@ Here is what the fields mean:
 	    emulation is installed and uses the opened image to spawn the
 	    emulator, meaning it is always available once installed,
 	    regardless of how the environment changes.
+      ``T`` - transparent
+            Run the interpreter transparently. The binary is handed to
+            the interpreter through ``AT_EXECFD`` (``T`` implies ``O``),
+            the argument vector is left exactly as the caller built it
+            and the kernel labels ``/proc/pid/exe`` with the binary
+            instead of the interpreter. The interpreter has to load the
+            binary from ``AT_EXECFD`` and follow the
+            ``AT_FLAGS_TRANSPARENT_INTERP`` contract. Combining ``T``
+            with ``P`` is rejected: transparency preserves the whole
+            argument vector, argv[0] included.
 
 
 There are some restrictions:
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index e5a17ca935ca..71833b976131 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -72,6 +72,7 @@ static const struct binfmt_misc_flag misc_flags[] = {
 	{ 'O', MISC_FMT_OPEN_BINARY,	0,			"open binary"			},
 	{ 'C', MISC_FMT_CREDENTIALS,	MISC_FMT_OPEN_BINARY,	"credentials from the binary"	},
 	{ 'F', MISC_FMT_OPEN_FILE,	0,			"open interpreter file now"	},
+	{ 'T', MISC_FMT_TRANSPARENT,	MISC_FMT_OPEN_BINARY,	"transparent"			},
 };
 
 /* Look up a flag character, NULL if @c is not one. */
@@ -764,6 +765,11 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 	if (test_bit(MISC_FMT_BPF_BIT, &e->flags) && p != flags)
 		return ERR_PTR(-EINVAL);
 
+	/* Transparency preserves the whole argv, argv[0] included. */
+	if ((e->flags & MISC_FMT_TRANSPARENT) &&
+	    (e->flags & MISC_FMT_PRESERVE_ARGV0))
+		return ERR_PTR(-EINVAL);
+
 	if (*p == '\n')
 		p++;
 	if (p != buf + count)

-- 
2.53.0


