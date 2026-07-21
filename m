Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF509C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:16:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C614C6B00C0; Tue, 21 Jul 2026 10:15:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C39616B00C2; Tue, 21 Jul 2026 10:15:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4F016B00C3; Tue, 21 Jul 2026 10:15:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 873BA6B00C0
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:15:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1C2261401B0
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:15:35 +0000 (UTC)
X-FDA: 85012981830.17.58D8A88
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4DCDF140011
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:15:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nVBXLImp;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784643333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kYvTUrZeqIK8jpOS7Fwg87PFtSxCz14nJrDSnK4sqE8=;
	b=cnH7zUsWxBUY6aDvAxi8Rfk2JDdjBrb9nBmSplsTnaZy2aHRm8STRny6+56tFpVcDCTMA2
	f5iy6LYzqCwgFv87/idCvi057OggnevnFOq9k/fFcrjwHMPlWCuFe4rP47BLxwRKiXR90l
	jAJy3qTYYx5B/Y6qjNomR7NX/rGV2cw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nVBXLImp;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784643333;
	b=cSwJKUoc1yOkUUhvLmPCLrHacwPziHRdKl/Ve1FFVTz8hF18tWUlpdAj7Tc4sjboOhCOpI
	SyY5fCZzTqQNKBO+va2nGkRNMdxpm4DnU75akW2VcIRJVV8SqYG2vwbrvRn50yiIUt/J1q
	u/d4hgZVE/K5y1Axao9NycggVShyT3w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9BE264349A;
	Tue, 21 Jul 2026 14:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC591F00A3D;
	Tue, 21 Jul 2026 14:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784643332;
	bh=kYvTUrZeqIK8jpOS7Fwg87PFtSxCz14nJrDSnK4sqE8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nVBXLImp5THS6thpR8kxTS7DzmxPTw/3QpkvETQee2p6My9H8nx+oU/IG5DMgfVVj
	 MdFBJRhGM+52qsGFUd62IvvG2b489BldqWFZ2oZnLixO+asMXeUOS2TvVTr4jWsVg4
	 lH1SN0ZSx0SW5oOwn7aCGGhP455kHm1n+axv9bVLGcU7bW7lpScmyM3q3ZLXPAUfEz
	 9n0g7zfs7x5NyM4veZHMHTDMAA/WlAoVG0cA0yuG7POVFnT0EMYgzW8aW5JMRAxam6
	 6g1txzt0mrTxocTA2QE2kK858P9MT2L5d5cVQbMcCOhGck8QZZI11RXZLOyMoWyd1W
	 vu74pOJ1qJe9Q==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 21 Jul 2026 16:14:03 +0200
Subject: [PATCH v2 21/21] binfmt_misc: document loader substitution
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-work-bpf-binfmt_misc-ptinterp-v2-21-e57866e4ae0f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3314; i=brauner@kernel.org;
 h=from:subject:message-id; bh=MUQuvaLG7BH+qnaycY+AeYK2F8Ox0JjhVijX9+ERWfc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTF1x3gCfn+xfClO+MK6XeTPx78Inj/306xnAsdd6u+f
 d6uvel6d0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEEnQZGf55OE7t1WPSWn7i
 8UTGTXsv3RaTbAzp7tnnxNfQ+3l3+DNGhhdVnDWyrhsfB3c+TDoYd3FH5mf5dyp8bzs+s62d6VT
 wgh0A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: 4DCDF140011
X-Rspamd-Server: rspam01
X-Stat-Signature: 1cd64k8fh46z1r9t1qiprhfja66f4zbp
X-HE-Tag: 1784643333-923703
X-HE-Meta: U2FsdGVkX1/CoJxKBM7jIil4bcl7DcXT6sD52Yyx1QOeqS5uGwlWjfURSYUWRWEErMU0VfSqUsrKSa7mqUcJpLurP1qEW3fGo1TWRncEmUyKVtS8xkq66zmIhPc5PpSXsfcYITNSLnSD77TNQlk30GcA+R0e11LJ/wlymQdwcMVxfm2iHHjh0bmexSZQk1qm07TUNTwYvGhBbIkrnGs3Omv4l87qKNjpSl4P5H4ah9lIT4trhJOKlt4lK/s2zBxyZwbFZIFEd4FdK7JID+9LqOx2K3fJBqbJv5/AMlaSzRWGZTpw2MjGrsJDxx6zC4bet+xMLtDPUtxwc437sTHbcp9o78DWaBBrqaN7ROMF4bhbKE8cuo0XXTmV/wulABheDJg0HhzXPVB2u6pSQRBaOYIXOZY3k0Tc/BhPFGS0fAw1LpDGciCJk69SWp1LcR8oX+7eAehSMNTgi9ThK1MXP8Pl3IaMkXsAzdKJMXLfEDS4Y7DLXIB0pQTRx4k6vBjtXyCg2OuXCf12WyNcrIwzhQS4xGLUE7gUZqciCclRGviapQN5kPyq29NPJZYNkJM0lbDc1D9GE+0udwThlwTGqvBthiQvsdNKus2i1JQdI7hLqJ+fOxUGDDrJNjcRQf1gcFuc2lkq4AgjZmuGmXXCkDBvIRXpzALsnmgUwuaJ4vZP/BOX5vInpgFJQRK53nizQI8Co4FuFU6G0eNfp9LpFsdPdyIL/jaW31W+rnh1I3/nQhS+axV7v8sONecUTYMWtJOYlwBfwq027vzDwQ1+KYlqPM+VJsPL1tjLuwRRel36mEa3klVmuW6gYSl2bPpMh2fpJ9stkJa5oob+1y0HxGvaS1ee6GrUPJ9+rmlg9GeAHCQB8sHojDzajJqhzzfzaKz8j788iptzYOfIrHCPz5JQ39wb38qpkK55ZafZ4POJHg4bAQ71xNZDVP08dQ2P4vl1xI1TgWO3jzZMfLF
 bXFPf9be
 HVaHqY8MRC64F6iJ2bRT6YIAJ8/5JWz1phu9IXHTB7EzyWmawmlvQqmHqQY8fY8CVH8HDR7SlbBevgp62Bf208ApSe/422B85eNrEkiyYxAtX1sm0awV6YfnI74ubI0lZySgjtkfx5aCJlF/oLPf9LvU0zIQM+IGw7eFS2uvn0nb7UKdA3W8elX013wq3n+JuFFU0MKEpOH1f9gmhrezVk+UrFM3ZK3HXrQ4UK//K3vNefY9wkbEn3Eqyms6MiOWRSnWCn3ZrQDEmJqeh5NHUxMuFvuyWtHSroftHZOvk90zJgNcNlMCsLOUOY3uINFoekCmaj8ZzaurVo96tlFPNQPSydh8TUgN8esty9/SHIdz/AU5DGIRcLsUiCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Describe the L mode next to the transparent one.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/admin-guide/binfmt-misc.rst | 47 +++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/Documentation/admin-guide/binfmt-misc.rst b/Documentation/admin-guide/binfmt-misc.rst
index 72b389d61f6f..d49809e62a52 100644
--- a/Documentation/admin-guide/binfmt-misc.rst
+++ b/Documentation/admin-guide/binfmt-misc.rst
@@ -263,6 +263,53 @@ execution is the address space layout. The interpreter occupies the main-image
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
+interpreter-less ``ET_DYN`` drops the override and runs natively. A file
+claimed by another format - a ``#!`` script, say - is handled by that
+format as if the entry had not matched. ``L`` is therefore not an
+enforcement mechanism: it decides how a binary that asks for a loader is
+run, it does not guarantee that everything matching the entry runs under
+the substitute. A format that cannot consume the override at all instead
+refuses the exec with ``ENOEXEC`` before the point of no return.
+
+A wrong-architecture ELF fails the whole exec with ``ENOEXEC`` exactly
+as if no entry had matched. A substitute that is not ELF of the right
+architecture fails with ``ELIBBAD``. The usual ``PT_INTERP`` sanity
+checks on the binary still apply. But the segment's content is otherwise
+irrelevant.
+
+``L`` rejects the classic-dispatch flags ``T``, ``P``, ``O`` and ``C``
+at registration. ``F`` composes and is valuable: with it the substitute
+is opened at registration time, so later mount namespace or path changes
+cannot redirect it. Without it the substitute is opened when the binary
+is executed, and the path is resolved in the mount namespace and root of
+whoever runs the binary, which is why it has to be absolute. As with
+``C``, register only trusted interpreters. The substituted loader runs
+with credentials derived from the binary.
+
+
 Hints
 -----
 

-- 
2.53.0


