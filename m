Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42F98C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:35:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EB646B00DD; Mon, 20 Jul 2026 05:35:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FF166B00DE; Mon, 20 Jul 2026 05:35:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32A156B00DF; Mon, 20 Jul 2026 05:35:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE6B56B00DD
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:34:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 87FEE14073B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:59 +0000 (UTC)
X-FDA: 85008645918.23.7B540C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id D892220009
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:57 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NE29hRwe;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784540097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8HEZ0jJv99WpWqbb2o0FPUdYsrdjjV1tk0iDO4gqEW8=;
	b=uPzr+FYeZCKcg19Dadpp2hz7a/MGkQr9Lf0UMsIvcnbC9NeIzgNq0K+OZxxukgeO4Ty8h/
	fmpuz1Uq6N4QDjzVXZfgHEkpvU+zOJrQmqylrMF9cGk1k91hLqR1OohnnQQ2lmwpst6Yvs
	FWu/tvJi4dlQHm6g7ni6LEBAxinNjp4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NE29hRwe;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784540097;
	b=iDzsBeJ0i9lMv4HFMCzzaBDKn5/m5K8HkPR4VQI4eywrCtIVO8jGSEe52Dgr4xE3ZbLZEh
	2sMFHp6oj7aIYIJmjEE7y2ErVTMphlt8qyopbqPGd8K9cSzrGxkBpDPRpOy0cN4Y5X3rHT
	bEPOljmicA8iMoVHggfztstUJOI+w50=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 81629601D9;
	Mon, 20 Jul 2026 09:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E841F00A3D;
	Mon, 20 Jul 2026 09:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784540097;
	bh=8HEZ0jJv99WpWqbb2o0FPUdYsrdjjV1tk0iDO4gqEW8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NE29hRweMDLceETt/Ju/GZGI1POgRzgLEtxxlp4VXu44XhAgSvfIBzPYXnINwfo0I
	 1sNQt3akWm9G6zUcsb0mCqHZh54+WRL9uC3Z2zgz2mLHmrerkTgAxai2tjfVd8t5vW
	 DHML/MFp6lYYs/pZPcZDu9VsTzUdVhvR4J3bWlPY9B9qUDRcjFHaIR8SyhDEnU3mDW
	 4CZvp+eCXjceuP9y0JeQkiiwbYjOQD/p1PV+cB0urreJqAQffXrGBpteipNxUHEcsq
	 9euBN1eO+JL5wl6q+Npmy3eRPlYz+yai9f9T8tKGVEpZAMHw4OJcvuc+WONbzfr3K2
	 uFu1ugBNwTzdA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 20 Jul 2026 11:33:41 +0200
Subject: [PATCH 18/21] binfmt_misc: add the 'L' loader substitution flag
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-work-bpf-binfmt_misc-ptinterp-v1-18-ddb76c9a508e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3433; i=brauner@kernel.org;
 h=from:subject:message-id; bh=qdVXGI1HLToc0Ta28J+Ik5fzoyHaFdrVcj71f3lCDaw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTFvm7W2rKYafEE78BL+6xixMza/7Zb/hX+z/TnEP9zj
 bCZk7vqO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACaS1sDwT+995cEGn90l3G36
 axKW3D8X2+K+zDr2Sk5ffaXH6idsGQz/g7VKVKVL2c8cOiH81V3/r9WC77UNaU/vJTRct5oyO9O
 aBQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D892220009
X-Stat-Signature: hs6m5myx4cd1zb3cpw5uod7mi1mmii6z
X-HE-Tag: 1784540097-95274
X-HE-Meta: U2FsdGVkX1+7MaVQxiqXbKQ4WXo1inY1xccqX88SF4VwikmySej+SfXRD0Ux6LhJODKlw136jpEc6Df3oar5oW2HvqXFPVhDHIy7Syf532r2XSq3ehSpnO0BbHUr25YMcMcoWt//z9khcxwNgjtrvHgAk9kIqTngcE2TTNXK6wMxDkHnqtUmodiGz3nXzzvUDCOS20i8H9zlXz0jWSUD5AUMH2ZGnXNWQ0aAAkfRFqsNEEhG/Ty8NTr3v7l+daD8YDPYw9Nu1RzCJwa7uZg7L67BimxE0Sjr7v2m+lx5I7v1LKw5Ho2G3dtACYBNAA6LIyf+5uvQWL4vJJyEBCwGIf+tT18jMLhZ9XbJp7mk7JqGasJBOL8xvYTGMNMR0plwj35wAtpXL0oAyGgyG+9BVhYa1tYfmQeVxvzA/WXDY8Wq6zbJoyZZ4nHXZUNlt6hKiSZ2x1/5Ed1ZCfSFJ2zlqmNSE/RaHuBSYUXxY8W0EHmh0C2cxgYljIVSmrTHyUZdSBfHsUQswzSPMrN+xmS5vLzZuD0CQmfIXRJJcDx3QpKO+32gX9BVowU/1mUa5VNsuzrph1Ax81mcKoO5SSVVvOLcyveB8nBaxEqnVg4M8yi2Y9szFZ77li6ZCjtXWt9znJ8v4i50vH8cf2l+2IqSeR6iyIbxfscPBFS5Ky09FITa4TCSVzOF4Uf5/m4RItKZRiQjHdfTD0+0uTkWGcLiXUHtljN+RtEm4yyzGiIiSMlMNTgBYodWo4x0mZCvwBg+xFcSbc4W4eCaUYid0B0ZI5qbgqKY6WvSAUEW5AA95GrxtU5XjnXfFwGtixnPTnnJC56/3GSzUqjVCa1Mpvqh1LV4TeteIpXHEGRDAoCZ3nE5Oi+3N8u8G5xM90vJWZtk5NbjU7IPRkU3Djpko+I+x7AL6mt5ocYePDYMKqDXfY7LejnY25JsqfXoM431Iq+Hh7ONIeT5Gwg3lJaZxtE
 7GSDtOcl
 46VvR+dt9K0WQjTDPaldddPv9ytqwZy5y3Ypkfx2p4tsJtavc7dFrORd7+4W/kXT0yMnj88XZIT3k6RU61Zw4ZcNvKSyO7JTK9TjlgJdaF0t75f1fsIiMZu+2bBGK5gcaQTxY6Uj+o6fuBC6GhSEsWn0Kk+UAJMi3inwjuvrKHJV6Okvayv574ulNagvWDPDpg12y5Y0g6TX7UnCNTazmLsnu2n+S53Wd2tAOYT0mkfqHgOV2OnmSm3UpSXU19supQBibpYy0POEuZ8K13OSy3bh6Hi6TB1DUdEZQYsDFXqxerD6SQcKT4bMhQrrRSCPgr0nfE7P7fvXyr6Y16V1I0NTCkqf9XNaJ78vPhKNBypzoTzIuo4x/qrXH1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the first activation of the PT_INTERP substitution machinery. A
static entry registered with the new 'L' flag no longer runs the
registered interpreter with the binary as payload. It stashes the
interpreter as bprm->loader and declines the match with -ENOEXEC. The
format search continues in the same round. binfmt_elf claims the binary
as a fully native exec and substitutes the stashed file for the binary's
PT_INTERP.

'L' rejects every classic-dispatch flag at registration. 'T', 'P' and
'O' have nothing to act on (no argv splice, no execfd) and 'C' is
subsumed (credentials derive from the binary natively).
'F' composes and is valuable. The substitute is pre-opened at
registration time and immune to mount namespace changes. As with 'C',
only trusted interpreters should be registered. The substituted
loader runs with credentials derived from the binary.

The interpreter open is shared with the classic path via the new
entry_open_interpreter() helper. Open errors fail the exec as they do
for classic entries. Like the other flag characters 'L' cannot be
used as the field delimiter or the flag scan would run off the
registration buffer.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 1cd30dec3fab..ee48dab2638a 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -51,6 +51,7 @@ enum binfmt_misc_entry_flags {
 	MISC_FMT_CREDENTIALS	= (1U << 29),
 	MISC_FMT_OPEN_FILE	= (1U << 28),
 	MISC_FMT_TRANSPARENT	= (1U << 27),
+	MISC_FMT_LOADER		= (1U << 26),
 };
 
 /**
@@ -73,6 +74,7 @@ static const struct binfmt_misc_flag misc_flags[] = {
 	{ 'C', MISC_FMT_CREDENTIALS,	MISC_FMT_OPEN_BINARY,	"credentials from the binary"	},
 	{ 'F', MISC_FMT_OPEN_FILE,	0,			"open interpreter file now"	},
 	{ 'T', MISC_FMT_TRANSPARENT,	MISC_FMT_OPEN_BINARY,	"transparent"			},
+	{ 'L', MISC_FMT_LOADER,		0,			"loader substitution"		},
 };
 
 /* Look up a flag character, NULL if @c is not one. */
@@ -475,6 +477,24 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	if (flags & MISC_FMT_OPEN_BINARY)
 		bprm->have_execfd = 1;
 
+	/*
+	 * Stash the interpreter for binfmt_elf to consume in place of the
+	 * binary's PT_INTERP and decline the match, so the search continues
+	 * to the real format in the same round.
+	 */
+	if (flags & MISC_FMT_LOADER) {
+		/* A native exec has no argv slot for a staged argument. */
+		if (bprm->bpf_interp_arg)
+			return -EINVAL;
+
+		interp_file = entry_open_interpreter(fmt, interpreter);
+		if (IS_ERR(interp_file))
+			return PTR_ERR(interp_file);
+
+		bprm->loader = interp_file;
+		return -ENOEXEC;
+	}
+
 	if (flags & MISC_FMT_TRANSPARENT) {
 		/* No argv is built for a staged argument to land in. */
 		kfree(bprm->bpf_interp_arg);
@@ -771,6 +791,12 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 	    (e->flags & MISC_FMT_PRESERVE_ARGV0))
 		return ERR_PTR(-EINVAL);
 
+	/* A native exec splices no argv, passes no execfd and needs no creds. */
+	if ((e->flags & MISC_FMT_LOADER) &&
+	    (e->flags & (MISC_FMT_TRANSPARENT | MISC_FMT_PRESERVE_ARGV0 |
+			 MISC_FMT_CREDENTIALS | MISC_FMT_OPEN_BINARY)))
+		return ERR_PTR(-EINVAL);
+
 	if (*p == '\n')
 		p++;
 	if (p != buf + count)

-- 
2.53.0


