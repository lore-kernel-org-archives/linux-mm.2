Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4582C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:34:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACAA46B00D3; Mon, 20 Jul 2026 05:34:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7BA36B00D5; Mon, 20 Jul 2026 05:34:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96C476B00D6; Mon, 20 Jul 2026 05:34:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71E676B00D3
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:34:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EFD95807D7
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:36 +0000 (UTC)
X-FDA: 85008644952.03.1153206
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 42DDA40003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fym/3b1l";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784540075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EGDTcSWwY/u2lTvfjlboAKTY2F0iAMegCLfkIgM9cL0=;
	b=bbCm99Xg6+y72Sr5Leit82SS3B5oy6WpAF7QO8AbvWMsvNYqx0lzzlycRtCPMS5B4LqGZG
	Q8RUUcsgec51IbqBdbMOAyjYUK08TWaAEJfnB4yUKaKAZcLrxXPyzhdWX9Xz+4N2k6BhiE
	KTa86koKDh56FrvaRqZFCH8KGCoJkWQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fym/3b1l";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784540075;
	b=7+QWoX5sVWActrQARuELTG8wvRZf9rizou/6iwbqvhHUmY5qlrzzDr4cGRL5/7x7NUaU+Q
	NXJn4eohcqmW/ejUHaHlLKpJuwkg0oOD8qqXJ9yQouh5U/Cpx5KUa9FxGreJ4BHPMwEuzT
	ySGnZIkK1mBtUBsEsyjr3z0sJjA2Enk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D9A8560A79;
	Mon, 20 Jul 2026 09:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC1D1F00A3A;
	Mon, 20 Jul 2026 09:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784540074;
	bh=EGDTcSWwY/u2lTvfjlboAKTY2F0iAMegCLfkIgM9cL0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fym/3b1lyAPxhRO9XNhLDfEeiEo6uRvLVxDDYcaM0+n++IiM2/TipR8kWYHKhY3B3
	 oN/Q09k7MgfDzEodITObqAGGWZxuswBHcrqMpsI3F+/MsJLG0rKiXoqEwlrMrkUeUi
	 WguHPmJ6XbwuD5HNHDieQBA1avQRPXYVO+cdy36BmWH6LCZ9Q8hPSRX3BpmWrJ4LAT
	 HXkQ5sF71PxyOgCg2JteAgvFhW6YuChz18jdCcsD1erpdHelR19kwsY/9vsCIO7PfR
	 JgHxodO854f8e7Niged5iEBtnH7lXE0+qT5VSneBrK6yTA9r3AAEFURzUOjBody1R9
	 /3B47xtAz8F+w==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 20 Jul 2026 11:33:34 +0200
Subject: [PATCH 11/21] binfmt_misc: add a static transparent flag 'T'
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-work-bpf-binfmt_misc-ptinterp-v1-11-ddb76c9a508e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3017; i=brauner@kernel.org;
 h=from:subject:message-id; bh=BTEGIWQaX9jff031zmDSWPlSXTNAsmK1AWo7J/WcJjk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTFvm76c3X1C5uHurNeH9TbufzoyRl8OjyHOrVVeOpy3
 Y/b7bPm6ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhI/3KGf6rWJxmO6PHNNu91
 0l++YJn9tY2WS7zUbR7e38X0uX5tcycjw3S1adJqX46sEDNef07Z7srjh+uE0vTUGgrfO/5/tW/
 7fG4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: nnsiaggpaf41m7f3xjoo14k1zzktnrgr
X-Rspamd-Queue-Id: 42DDA40003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784540075-915843
X-HE-Meta: U2FsdGVkX19/rRFnW1Xp5JjRXa7I/vpOl3mPTKYLVhN8l4rSMVQLuxV1ee2e0WYtj7RdcmhojKuCATId6wzLGdzKoMqOg7bPv7wUPQeL5L4FzGFx1xx/X+3ELPYyWFpp9Yf4tsudkz+kAK7zo5liXPh3NpsgEiCZR+1N8KKiWo5mtY0APgQQK6rSd61uwQOyy7omdEFjTl9Abungl9gUu4ksHQJBa/vqlYQ7w/d9ke/QaU1/ZuyLqZWiDU5yGo1xlPB4DHT77LPgqNtKw/tgtXxUft68FuawKno1cnJwZ/6jxsLYTX4amkiw+yDAacuNzAbLaaUeS4LaMkPzEtrF9wrAs1exFmZZh0KuERiwELp5JSEJD3ni3ddfhTlUMnELjntNI8cIBD6OmdGo+v8zmHlXPy2GNouP+hEP7av19TnFh3rW1ga5JTDyYpEuRXqmDGvIlFii9UVegDvn5l/0pjCJU9xOc6HHGP3KJTHHqAU5VJzVDp9SVhtCnGtaUWFzzxjgUH49WcjG0vi0LRsqWF2PuVuYjDPCBwkg2y+MT9cv7MKySjfUZzABlwFfYqyJe/tfs8WhyOjKCAG4ZXX/ChZRoZOt965NvqX/N4ajLlmwIq0v6lvHIA4YY4hZeld5NgTlT1uFJHXAOZFvuNlHfJ8gvKEADuQsNUtQQlBSNZMkGSqX0PQ98Vkt8dK7mlpd5ErvP4cchvnegdYql9qEJUmdC8ZsuyvxhmpqgswuOdkC0WUBTiElGsWbZ4L3qWuq1cebX88PdUnyYssbyCi5dVLOrP8t0hN0qq4oTeeO0tW6aHxChsfeafb+0NckogU9i+tktwijXRZSZdFzvl5IU6TVH1UWVtAqneJnncti2eUuUp4yuD6TgSbz/a86i++HZFP+rTyt16jMftzSEb+UYLaXxrMBg5PzAbV2v82XKBoGOBxqjy1OszDIYKyCtmXfM7teR/RGdPn+va3SatT
 PTX6xpA4
 o5VFC/s5COxzzHXsufLm7IkWs67zjTcIN5AGw+Au6/UXQe9Nxgpubb4+HlRP3TPuy4C9wqR1sWRuZZ/GBx3Ka9kfGncFa0A5Yy9jN2IX42rgQAhieaZlPwwv+je6FEBWn6uPCFXu+4P6pkAQNfkOw0c9PoQdj6N7nxIMzmDZW5b31lNYdPfoFSNcD7t89aRkNojjnX0mGqKQX9r27rm0rULUSGcQi26QRpNcMQFDan0+zPCo5LJXioCjQM4jLq+ALrZAtyMmWy8hj802Abzh+R4deJr0zi9AlguwlhLp1mHfpIgUAWQhCmEJywy5DTv+0mBLyo/zmTjc89yrQXcvM1ix4cIOi9matkqeJFmi1AhivLOebHNliptQ6dA==
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
index c76381a4bcad..c370c72c7dbe 100644
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
index 239cca389e0e..ed5ffb330749 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -72,6 +72,7 @@ static const struct binfmt_misc_flag misc_flags[] = {
 	{ 'O', MISC_FMT_OPEN_BINARY,	0,			"open binary"			},
 	{ 'C', MISC_FMT_CREDENTIALS,	MISC_FMT_OPEN_BINARY,	"credentials from the binary"	},
 	{ 'F', MISC_FMT_OPEN_FILE,	0,			"open interpreter file now"	},
+	{ 'T', MISC_FMT_TRANSPARENT,	MISC_FMT_OPEN_BINARY,	"transparent"			},
 };
 
 /* Look up a flag character, NULL if @c is not one. */
@@ -763,6 +764,11 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
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


