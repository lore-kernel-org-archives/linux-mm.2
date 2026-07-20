Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8345FC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:35:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 639936B00E0; Mon, 20 Jul 2026 05:35:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 573406B00E1; Mon, 20 Jul 2026 05:35:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EEAA6B00E2; Mon, 20 Jul 2026 05:35:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08F2B6B00E0
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:35:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8D787807DC
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:35:09 +0000 (UTC)
X-FDA: 85008646338.20.0E2F171
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id BD60540004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:35:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CE5DXy4k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784540107;
	b=Kl4O+VsL+j3/N3YHPSz+7M6VpHiX1FXhf9vx+H4hX5A/Z2BxbnZQRR8rHZ7iQ0LTsWdPqN
	6P+fRd4cVK/hdmmhkE4jakt71s+JathIqvOrZcpIQoCska/J1H/zBCT/f8G7kB/DXBB6ie
	lCtwtGWO9IBh0rmoTPmu6jPWWllXiQw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CE5DXy4k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784540107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B6JaCQcV8O+LfMG8OzzqYe5U+TWtCj2Zt7kHSq9d4Fw=;
	b=nsw2HP+Q7eYIP84QzLIU74NML3uHahYXDw9zzKMS0/iO5t24N0xQxOsF0yQL/4rL8pdijW
	d2jeMZWIB7y670HGLTAJAQ2otyuXqoNUMWTmyGs3f+FjCWh9wbCqzMKCfCsrEGd7YGUWbd
	bG1DlV6KFTNASSb3Wn6Ee/8QtPE5oPo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A55B4396B;
	Mon, 20 Jul 2026 09:35:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3509A1F000E9;
	Mon, 20 Jul 2026 09:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784540107;
	bh=B6JaCQcV8O+LfMG8OzzqYe5U+TWtCj2Zt7kHSq9d4Fw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CE5DXy4kPwdEQyYig4MniIz4zKm3a95jCEgF/pbnav0bNwpAoZoL7202DiwyHA3GK
	 Y5J07MvnCijLc3v9yrxtpvcqt6k8nyHtxH62ZzcEpZlNG6sMPcVwpL85VyO+Pp9/fe
	 UsYy5bbGfeq5KL7IBNYrO1BWwWKXZMhphZo8Fh3/SdQo7uBTK3V+wYpJDUKIWdLdtf
	 USp6s14f6bVx2En1DaT6tsKmhB/R1hTYhrgHYdvur9auQFBO4NhPXu7L5bkjReWVR2
	 3p2R6wmlxMdlmsK1bjZZ6cPsduVEQMlWjxyI6sxqROdVhYQDtoEp5XnRdKDTrXI8hI
	 NED8/pNMIt+Yw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 20 Jul 2026 11:33:44 +0200
Subject: [PATCH 21/21] binfmt_misc: document loader substitution
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-work-bpf-binfmt_misc-ptinterp-v1-21-ddb76c9a508e@kernel.org>
References: <20260720-work-bpf-binfmt_misc-ptinterp-v1-0-ddb76c9a508e@kernel.org>
In-Reply-To: <20260720-work-bpf-binfmt_misc-ptinterp-v1-0-ddb76c9a508e@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 linux-fsdevel@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=3659; i=brauner@kernel.org;
 h=from:subject:message-id; bh=0j319FPLkEeRXmctLHltffws9S9bb83D0lCdaC6N404=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTFvm42NDdgDVKvt+Y5aFrkKnDmclOYb3Lyq0un1a5eS
 63TTNbsKGVhEONikBVTZHFoNwmXW85TsdkoUwNmDisTyBAGLk4BmMjDrYwM72cvrFp77PQ3L9e/
 7G/+dMVN2tK93EP7xyEbRlljqxVXvjMyTEjcyDr3YdtR29kazf0bFFxeO/wUmfxUfNfKq9P28Xx
 g4AEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: BD60540004
X-Rspam-User: 
X-Stat-Signature: ze559mtsgk5jdm57okstmq3ekdj3w335
X-Rspamd-Server: rspam03
X-HE-Tag: 1784540107-663597
X-HE-Meta: U2FsdGVkX18O9vw1F1dYsakIXFx/BjbuYx+e651X/JF21rRDDMKzUiyXjGyq96uwfRt9xotP7nMQLTBUj5B/LG482YRQp4c0nzQQ+vBoM5fshBA9n4ZpV4nmQ+p5YmT4kEHbVLKGcokwBrEg3uR3pSd0dk7T702X8Q9/ZsK01eoXxf6artM/skPGa6P/EOn9+9CRkYo9GBfkoiBA+8AIEWrtAutuhIrjejteBClPaoJLhXk6YLEQBQ8iZ2qdMvVHrRz5UfkUUqH0gcXTy+YiUqP6aofeIwkVlAuVGCyuMALX7jUzi7NttTBLUD1CqYLvKPe7O5XDWSgTuu9lFX/d/SVTPr/1Kfm9acHwMP2uRa3wGwOK7HkL7erbaHEl1uCoX1zi6zrnx2HTQIeL4nuz2PdBWlEu576rg8FT2UwYY6TiWi0QvF7ahL8aIdkSKFnsjdcuzvLdIG5b9Ee+rTBGFgCbDrJtYi7d76j4TUNpZE0s3vWfOZLUuM2olHqcIedqt410tUCnFN0J5wgp2iyvXcQjLvbFTRrZGMjMIOOZlGoSPSLe02+V0mLDdCux8cwOsooRPlVPKG/3IvY+mLxKlzmSy3cA8d44LyEA31NJIu+7s3spq0cfsa75E+hvmQT13y+i+6GgddPPKQog3arvWwRMk9avKNyjJvDq/xToGUwBnBAP8AGtiQakNoWX1LG7Io1qfld3x9opGGEcQMKOcpbARNyLRqN6mVfvqftPYNXFaFc1KmO6mv70MpGxDQx59/32SFnmt0gQtVIO4mYAU6PNZVtjKBRpy9vtUWS9ciLvtARnx8hbjfwCMf1pwdNMKfLeRx+KabStem9hpFswxm7dIAcdvbrN+d3cOc//3AEeuoPYvxPxT8rm2BpiEB8g+qOZUSZ7oDXKpdgLP3eYxbgbkCkWKacsb6vXBjS7UNIuaoZ8kIxUv1THHZBShXJgwgS47nwEkO+6801id9J
 KX+1EPcv
 yn0ekv9lIb54JdfFUc/9NRYVg+z4H5wfF7/DvyX9WJiAeLwqF9IgHJgZaHfnuNaDx+05LNoU/EUXkrjq/k13vsDTfS0iT5R57HS3Nu3t1qCbKjtMy4CBBzjgvh2yZfyvJF3dQAn0HlJi660YgwiY4mzKvSOhCRZeGIsAO5VKPyaWmzNJU7ibeFNkprYUZ7L2SQNfIcllvauRJ6ItcYlSeNABm4yVB0y+g6i0Eqa7B6uu+C4FekEANT3GPNSEpSmyrJWmWYpNWFeMBA8sP8WlF5u9eAtiFBrW5LfZZPrj5w3Ex9PqEbzZaOj4M1B8fySqjzMJkt79T4y1OxZw0rHl4omSNun5HpXF/X0qeixmz1v82FGRc/yblETGfQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Describe the L mode next to the transparent one.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/admin-guide/binfmt-misc.rst | 50 +++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/Documentation/admin-guide/binfmt-misc.rst b/Documentation/admin-guide/binfmt-misc.rst
index 8c861bf0c56c..b468a148cdab 100644
--- a/Documentation/admin-guide/binfmt-misc.rst
+++ b/Documentation/admin-guide/binfmt-misc.rst
@@ -100,6 +100,13 @@ Here is what the fields mean:
             ``AT_FLAGS_TRANSPARENT_INTERP`` contract. Combining ``T``
             with ``P`` is rejected: transparency preserves the whole
             argument vector, argv[0] included.
+      ``L`` - loader substitution
+            Do not run the interpreter on the binary at all: load the
+            binary itself as a fully native exec and substitute the
+            interpreter for the loader named in the binary's
+            ``PT_INTERP``. See the "Loader substitution" section
+            below. ``L`` rejects ``T``, ``P``, ``O`` and ``C``;
+            ``F`` composes.
 
 
 There are some restrictions:
@@ -246,6 +253,49 @@ execution is the address space layout. The interpreter occupies the main-image
 position and the program lives in the mmap region.
 
 
+Loader substitution
+-------------------
+
+The ``L`` flag turns the execution model around. Instead of running the
+registered interpreter with the binary as its payload the kernel loads
+the matched binary itself as the main image and substitutes the registered
+interpreter for the loader named in the binary's ``PT_INTERP``.
+
+Because the exec is native, there is no dispatch identity to
+reconstruct and no contract the substitute has to implement. A stock
+dynamic loader works unchanged. The argument vector is untouched,
+credentials and ``AT_SECURE`` derive from the binary, there is no
+``AT_EXECFD`` and no marker in the aux vector, the binary sits in the
+main-image slot with the native brk placement so ``/proc/pid/maps``,
+core dumps and perf mmap records have the native shape, and the
+identity is already complete when ``PTRACE_EVENT_EXEC`` stops the
+tracee. So launching under a debugger works, not just attaching. ``L``
+entries are for ELF binaries of a native architecture. Foreign-arch
+emulation and non-ELF payloads remain the domain of the classic and
+transparent modes.
+
+The override applies when the format that finally claims the file is
+ELF with a ``PT_INTERP``. A matched binary without one or an
+interpreter-less ``ET_DYN`` drops the override and runs natively. A
+file claimed by another format is handled by that format as if the entry
+had not matched. A format that cannot consume the override at
+all instead refuses the exec with ``ENOEXEC`` before the point of no
+return, so the substitution is never silently ignored where it would
+have applied.
+
+A wrong-architecture ELF fails the whole exec with ``ENOEXEC`` exactly
+as if no entry had matched. A substitute that is not ELF of the right
+architecture fails with ``ELIBBAD``. The usual ``PT_INTERP`` sanity
+checks on the binary still apply. But the segment's content is otherwise
+irrelevant.
+
+``L`` rejects the classic-dispatch flags ``T``, ``P``, ``O`` and ``C``
+at registration. ``F`` composes and is valuable. The substitute is
+opened at registration time, so later mount namespace or path changes
+cannot redirect it. As with ``C``, register only trusted interpreters.
+The substituted loader runs with credentials derived from the binary.
+
+
 Hints
 -----
 

-- 
2.53.0


