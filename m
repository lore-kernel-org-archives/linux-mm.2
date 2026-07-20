Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDCBDC44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:37:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE3D26B0095; Mon, 20 Jul 2026 08:37:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E93B06B0096; Mon, 20 Jul 2026 08:37:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DABEF6B0099; Mon, 20 Jul 2026 08:37:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B528D6B0095
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:37:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 40DB5A0121
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:37:29 +0000 (UTC)
X-FDA: 85009105818.05.CB899D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 94F064000D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:37:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GY7bQ3bN;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784551047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=K5qltyN+MfU8aQCuenvbMxWg7poDhOA/J+jqlFW5yPc=;
	b=uQWapVbtOB829iePw7bYM6P3iZiWa1Z2fmSpJcxvcRRg7eCVCIT+Q4eP6ucgRIS9vpU1Jw
	BmZxksBR5c7uI1QqLOICNTwtmktP/DILEep1noakocETXDiLqtsl+zT4mSH+OhvkeQ/s2p
	4hTiaxgtgHuYaHlUL14vBL8SR9XIZcQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784551047;
	b=eNBsHSpN8FFNl2EkLjaAsXbh1ke/SO4qDMgGiYkCOkMhA32rOYQpxWmy4pQh8GiNn22n1R
	mTpFAJiQQCSBXavAg0xUydY9N7f/hThStIaCcBelG7XaQJd61Gqb2M90HsyJicT2YWl6Oi
	MuAPchkQcvXO+PtGsrf2B9vNI59FLXQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GY7bQ3bN;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7AA50418E8;
	Mon, 20 Jul 2026 12:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487B21F00A3A;
	Mon, 20 Jul 2026 12:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784551046;
	bh=K5qltyN+MfU8aQCuenvbMxWg7poDhOA/J+jqlFW5yPc=;
	h=From:To:Cc:Subject:Date;
	b=GY7bQ3bNSoNb1of3AfVAdlHJ9ktb8mfCWC9IazeVyU+pGlqJ0c5td2EXlAWQJgcWx
	 Glqj0qYMMPMZVPOvHvIFSRVyOaETXSBGgBmMRrD7HXZuQFcu0HCb+3IU504UHEX04V
	 3Q1lQ5JxV3lsPBE6iIJnU62ilAY2BgBSWYDrto+JKpJNFAKqK/TfnyVjTpA6TnkGHP
	 UCxjLC/vxD4mcSQ3WONPqjncQ3keEU9JLbLexlsu05rKuSczIQe/7fCTmgOmRDqAcU
	 wHd2Dc4Q1VS3J6uOdVaCyPE4A8UU+GFZ4kbtYelxOdfascgaZyU83cGuRO42y0YVWB
	 EbmX2zLAg5TMA==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
	Farid Zakaria <farid.m.zakaria@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	jannh@google.com,
	mail@johnericson.me,
	stable@vger.kernel.org
Subject: [PATCH] binfmt_misc: set have_execfd only once the interpreter is opened
Date: Mon, 20 Jul 2026 14:36:49 +0200
Message-ID: <20260720-beglichen-kognitiv-organismus-5e1e55326c56@brauner>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2761; i=brauner@kernel.org; h=from:subject:message-id; bh=kj0AZ5A6Jop+KqbA2yhJS4V30yHrTSQgJ33ZorM7qxg=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTFiVWs5Dt2bv61zvhvq3ayPlU//fbNo8386xXu6AiYT c1hSJjg2lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjAR35uMDC9NZtew1vfVX9+x VaVEuqRRsUI4Tz9hkdxeY+3ffCF+kxgZdh9wCJn9qsjQISlJfMPProP2Imra74+ziJildO1cnx7 ECwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 94F064000D
X-Stat-Signature: 97qhuuqakzffdhp3txaigsn9x3zdii9q
X-Rspam-User: 
X-HE-Tag: 1784551047-229424
X-HE-Meta: U2FsdGVkX19UwvH+2wCK9nXzFQZlHxEQsKj8CKPym3QRQzNoNiECykaBdE/jUXTUXa2hKH3ewZu91GRCpUJoAWiMHNZt4VeGLUxqn5CsZ7XKG05on/5F/dyMXpqNFXUGvHT6iSYrNACV/QZmvB80K/WcYrm1TXav7Afh+yhTZox1TtegoeCUYYfT8VWNkt7dJMPtBjAG8SRw1RnXIFY6eF4PMTGRDuVnr/AHtsQOL3NLlFYzVpN/MXx1xe7YmuK8wt9KNzrS9QtSC36G4tr0++0xXd4g8DhMJ4VXEva6Yk3+Vpy1xo/s5e6tEweWSBMrQSxg8nvnPaTGONsFQAHHz5l+VnYQ3sJWdqLCh9XWnT0Itnbfp2mdBt/E1GJxlkSbczKUUFrSWqEIHZARU04/e2WJX+2q2buboTAbuPvVQPbBVHjwc9YEyLZN776G1KZKowy8p0Z1OiDChz7kW7ouAhWXPhwt8Y37Q2I4Wi57wkMucpXoACIHgvRBuejUpI9QwKTKdNMv1VsTXv7+vwLlIF0Ac+ipas2mw10mfQR6tq7OKjCVVyXtRPihE7h6JARI8HKsehuQkIXwEo0JKLMtGJw0bqhIrOIhsC9qez0u0R95PFg5wnITqA+xbrdRz3zSV2QbP8+shDZ/p2f59PimydffrPWqi6wolnZHW6HOsBRFH7fIf9ga6I5n3liFbGQ12LP6A/8SYSess5qH1QW1foyo6ixy9vqflBqZSqP80OzSkrde7sXQw9IGl5W4ET1Ri+CUCdsxC46QzPn7XQyrDnsFttN0l9yCU57qpuK1SixKJLvgSPdoagcuVPgEheZSw5pIUV9eLqbIwyzljaUZhTRN7E3DI9kgIncKvfXUKruC8o8OZFWf3lhZqOzlOk1GL9nWBKUEzihvRkOYEl7EL0eMhY7mq+lI5x2gZVUaq7W64okHEdAwPBYhBFH5rUiYATlItT0Hl8AF8UO2rk4
 l9+MAc9/
 8Fg5fL3flNyauHDbexfldwLeUmRQxMeBJN0mHOias9pdpMiQL2uS9B+YFIXyT8EzvfyGtxuBv52o14fLYKUxOAuTCHJsrUsTDl5zDQaC6pL2nyjBOpmzfHbwqft0ijcti7h3U8helQJl0XowXLSQyFblhopXiVydh7AjnyWH7lu0VowPOsivrC6FMPcusGQjLqGhD1DjJgandbX9osGSydNguV/2zJq2C/Kr3DXtnc3rTznCjPIMP2lpAcfykmf8yQE39cqwPGsTUjPd23i/zB6cc1VfKH6E8mPTz77dXZ3zouWqXCy8Yv6u3sgzx/TPuZOHLVZ5qj4Xq+HrWZ5pNVuWFBlIJE2hKK4qd1wupgvbi/xJECgpKVaSL50ktkQJiuLz8yF5yi/8QLeSQBq9tdwQtae3lKIKPl5n9Io0sUY2hAks4WMc0zMb/VDM45jUvRSThl9WBwjGVv/EpKUSb5uvirQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

load_misc_binary() raises bprm->have_execfd as soon as it sees the 'O'
(or 'C') flag. This happens well before it opens the interpreter. If
that open fails the flag stays set on the bprm. binfmt_misc is at the
head of the format list so an interpreter open failure that returns
-ENOEXEC lets the search fall through to a later format. This means it
runs the matched binary directly having never staged an interpreter. So
bprm->executable is NULL while have_execfd falsely claims a descriptor
is present.

Consequently, begin_new_exec() dereferences the missing executable:

  would_dump(bprm, bprm->executable);

and NULL derefs. Had it not, the hand-off later in the same function
would have failed anyway. FD_ADD(0, bprm->executable) rejects a NULL
file with -ENOMEM. Both sites are past the point of no return so the
exec cannot be unwound either way.

This can be reached by unprivileged users as binfmt_misc can be mounted
in user namespaces. So a user can register an 'O' entry whose
interpreter lives on a FUSE mount, have the FUSE server fail the open
with -ENOEXEC and execute a native ELF file that matches the entry.

have_execfd only means anything alongside the executable it describes
which is not set until the interpreter has been opened and staged.
So lets raise it there, next to execfd_creds, which is already set at
that point. An open failure now leaves it clear, so the fallback format
derives credentials from the binary and emits no AT_EXECFD, as it would
for any native exec. The argv rewrite load_misc_binary() performs before
the open is still not undone. This means the binary sees the interpreter
path in argv[0] and its own path in argv[1] but that predates this
change and only became observable once the exec stopped faulting.

Fixes: bc2bf338d54b ("exec: Remove recursion from search_binary_handler")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 84349fcb93f1..5de615ca7a75 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -228,9 +228,6 @@ static int load_misc_binary(struct linux_binprm *bprm)
 			goto ret;
 	}
 
-	if (fmt->flags & MISC_FMT_OPEN_BINARY)
-		bprm->have_execfd = 1;
-
 	/* make argv[1] be the path to the binary */
 	retval = copy_string_kernel(bprm->interp, bprm);
 	if (retval < 0)
@@ -260,6 +257,8 @@ static int load_misc_binary(struct linux_binprm *bprm)
 		goto ret;
 
 	bprm->interpreter = interp_file;
+	if (fmt->flags & MISC_FMT_OPEN_BINARY)
+		bprm->have_execfd = 1;
 	if (fmt->flags & MISC_FMT_CREDENTIALS)
 		bprm->execfd_creds = 1;
 
-- 
2.53.0


