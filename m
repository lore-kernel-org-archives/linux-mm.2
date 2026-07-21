Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CBB1C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:14:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 338796B0092; Tue, 21 Jul 2026 10:14:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C2466B0093; Tue, 21 Jul 2026 10:14:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18A176B0098; Tue, 21 Jul 2026 10:14:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E58A06B0092
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:14:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 68D301401B1
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:14:33 +0000 (UTC)
X-FDA: 85012979226.29.659E291
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8D03AA0012
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:14:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ljCGZaoj;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784643271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I3oigTmZnwy5xnugZzpIrg+tDjNJLifyi9eemUipPCE=;
	b=NTY5/VF9U9DulgL+rrJDxhPmnv6dRCYc5hrohBpWnF3FUv2wuiU91zSSSaNZ0/tTOccLXE
	mtnLcmYSpvXUDvz3vBehdmbCWV3htA7wbzrNH8eQ33V5ZWMtVNksPk9Gvh2a8dGKlqkeAb
	dO0Yll3rzwKNhBUgOdg496+lJwJyngI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784643271;
	b=6JUNu8taiWtow7XyW/uK2KSsrJDvBaO5/GSeQt7F5Lvr5GUevgFlUMtd2Wkwbi3vh1ahVV
	7+76GKoYK08AcAIaan3Yg7M3MKnvLEyPOGmH9ADsTZs/0kmUoebI8iBgr9qq8VLkz/MLDJ
	iKTpDT4qpNGsOLb3Pu/3lII/3knTTFA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ljCGZaoj;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DFF4643632;
	Tue, 21 Jul 2026 14:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313F21F000E9;
	Tue, 21 Jul 2026 14:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784643270;
	bh=I3oigTmZnwy5xnugZzpIrg+tDjNJLifyi9eemUipPCE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ljCGZaojX/13PbiNPonTLtcNWX0L56IZnorW1+uaUFuVjaIigPKV+mPVjpgKZPDKo
	 jdkOFmi99ojgzx8L/qJWZqCuVz3Q7LlQF4PegLJwnIRixUScDKN9Ko8RL5lxZENK9V
	 A4iJ7eLCUS8Fi7tkWXDK14g1bsoVuZvIM5wIrf+EOeToS4E1mj+kzj9NJF0+TMwbZQ
	 5eJQU5RY1xGNrgsrlTlMBEpXhgAYvT8lctUMK1oySiepelBF3VSYmmi4sGVGTeboGY
	 gCB1j2wxO1cWJVL0KXA0vD5T5GJyMb+ZmzXIm1+TkXHWdhHnxNnL2lgvOse9p2X85V
	 oUhsqO2G1TMjQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 21 Jul 2026 16:13:43 +0200
Subject: [PATCH v2 01/21] binfmt_misc: require an absolute interpreter path
 with 'C'
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-work-bpf-binfmt_misc-ptinterp-v2-1-e57866e4ae0f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2584; i=brauner@kernel.org;
 h=from:subject:message-id; bh=/HZE81y7c4y9rwUi4c213k7Nn2GRcvgIbHRiATHZsXo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTF1+3f6/2lk/2pwo03b7kczijqJazfdsBgZugb3nAOP
 huG5dY1HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABNJbmdkONqz8B1vAtf2J1Eb
 n6dke7Ptb9xjbmp0Pv+IRmH2j7fVcYwMew96126X0K9jnK0T9nVNnpELp+lVqW3ZRwNWqji217A
 wAAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8D03AA0012
X-Stat-Signature: d4outgagmbftcc5xpem4uutaq4qcwc1g
X-Rspam-User: 
X-HE-Tag: 1784643271-660817
X-HE-Meta: U2FsdGVkX1+Kt6UlBkIIrMBAXH45chymF+2mGal70aJnzwzu6rDn0XNQFBGD6K7Er/6uGhrjjOAs12iUDnVrnbi/3Lu9BFNcP9FZPlgk2kxh0q1FM3hoa7D/3ABo/7rRrQDNMFLRACwuhQyVIaHHj5IMgE2OREDL6HVOaCnSMDNEA60Eydb07lda4Fw4tPekIHshbYk69OqDzwhCgg8gjTP6z0t4CRS9bOcMItHt1NDt7iEwslHiDUiR7AAUGmgtbIksEpZD1tLV7hyA+NWyMkDx8wdsKIEpX3FHPby3DkTpesSv8OQfXuDfFKSHGN3DsKyGS+ugeLIz7P9R5frzjgc7YqLYIe6KbDzuNeiQJXIgJ44nCD2fWyCGcHHGJ5Fn73AujdqtZIRtj8tersD20KCRmjw2BvEcfsejU9rW9iXhCiW3D4/gbl43XcRJkIz+UaxRp8p88yQCCDhC3aKBhJUczlDxUcz+aBMDXqZXxpwQSVuguULKeLVqrX6J35+MGrfXFETtaTs2zjQeus3/d6Ubf3Lcrn3Fr0FTzpUamENy2eKPe9hZJbHhMoevFnUeGyz741JUAJ+qRzkBLmn3CJo/6ge6i9Yx15Ag6hDQjmVqFVOvLkIMmtU0IvQGQosQy5IuVHEMBrBtkSjm0wKjz3nELN7A5+OVIAVFdKGzgaH0djzCrFVhQUlWp3q/9Ih3mQiIhJxkvSjxNfIlCDXigmywr874ZnXkfaDAYa3SpUYJ4kTjTAyBva13z9bEZ3lsdONeELGhBBxnq7a60GfIRg3mJ3LWqZl+uW0jjLQe+L61BPk3pAoEfQNuKVkZQH6rb2bQZKh35oSqrjVCoGs3x/3X3ickT/Vm448Lk2HqYf5nTJt91Y+dgdYCBGs+tY6fBKeOTpkn57nZuwQGCYnT9qJGV4jUfcAcwGMBmdDIX7C1jilRIiW84jGTbTTFa4adzvSGdrbfvMVw519UVd6
 eYouiba1
 +5rIV+Mlilfke0XmO6/QrLTZSpRxmjyNI7o5ircDoEj7Zc10rvNQKDZ7jdNbUfUcjysn/wYKTJa1vlhXSgu6Osr8uc/i6S2b84HpotWsj0CK3UeCF3Yb1ur2gkzVMT1hVpYTQYuifoZgOLF3cxefwsMKIHSmMpfAQkwjJQAPCDC/L8VWN4Gf0im/smr3dl+lRD5vP9t4byQNNQ9FAEYVGpbjmuk8GH976lNPmyMfk7liigJot6aG4S97TzyKepXXff3n7VE2bRxAroV1EPQJbHi8bAAhS7AeYUVkVe64RoKxARKtdPWPat7cgWCwQWSJtJD9iLDMeAOUYBQLJCkhgzkxPYsoeFKz0bV+1L31oMjn81KSoE6vwDZgPps3RSlst4i64z3pWeaT33aA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A 'C' entry computes the credentials from the matched binary instead of
from the interpreter. So a set*id binary hands its credentials to
whatever the entry names as its interpreter.

Without 'F' that interpreter is not opened until the exec happens and
open_exec() resolves the path relative to the current working directory.

The working directory at that point belongs to whoever runs the binary
not to whoever registered the entry. So :x:M::\x7fELF::interp:C lets
every user who execs a matching set*id binary from a directory they
control run their own interp with that binary's credentials.

A relative interpreter has no sensible use here to begin with. The
registering task cannot know what the working directory will be. Make
the register string reject the combination at registration time.

This does refuse register strings that used to be accepted. The 'F' flag
covers the case where the interpreter really is meant to be resolved in
the registrant's context, and it resolves it once, at registration.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/admin-guide/binfmt-misc.rst | 4 ++++
 fs/binfmt_misc.c                          | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/Documentation/admin-guide/binfmt-misc.rst b/Documentation/admin-guide/binfmt-misc.rst
index 7f42abf9cfba..ce94c8c36534 100644
--- a/Documentation/admin-guide/binfmt-misc.rst
+++ b/Documentation/admin-guide/binfmt-misc.rst
@@ -98,6 +98,10 @@ There are some restrictions:
  - the magic must reside in the first 128 bytes of the file, i.e.
    offset+size(magic) has to be less than 128
  - the interpreter string may not exceed 127 characters
+ - an interpreter used with ``C`` but without ``F`` has to be named by an
+   absolute path. It is opened when the binary is executed, so a relative
+   one would be resolved against the working directory of whoever runs
+   the binary
 
 
 bpf-backed handlers
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index c06cea00a6d6..bfe30fe532ba 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -683,6 +683,12 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 			 MISC_FMT_CREDENTIALS | MISC_FMT_OPEN_FILE)))
 		return ERR_PTR(-EINVAL);
 
+	/* Non-F opens the interp at exec against the caller's cwd; require absolute. */
+	if ((e->flags & MISC_FMT_CREDENTIALS) &&
+	    !(e->flags & MISC_FMT_OPEN_FILE) &&
+	    e->interpreter[0] != '/')
+		return ERR_PTR(-EINVAL);
+
 	return no_free_ptr(e);
 }
 

-- 
2.53.0


