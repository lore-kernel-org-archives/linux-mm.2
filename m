Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FA33C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 15:56:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38B5C6B008A; Wed, 26 Aug 2026 11:56:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ED976B008C; Wed, 26 Aug 2026 11:56:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22AD46B0092; Wed, 26 Aug 2026 11:56:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 00AC46B008A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 11:56:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7F8C1C0108
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 15:56:04 +0000 (UTC)
X-FDA: 85143871848.29.6423F17
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9D2BFA0009
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 15:56:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aG2+GO6G;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787759762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xv6LvbJXor25svpyF1shB5+LUX7dxOQBbe5g57lme0s=;
	b=QHF6npS03Nq9jOd2rYJmuIlZwC0W+lVBd4h30c7lHpXABLSxfKVIX/86czhNxJs0BKF2hi
	SSFP8uZa0cSbuCR7QpOBQjJd8NiMaoEXhM1tAOVyMvh521cgVdf03drWn7l79xRGw0225M
	zofC3hSN69DbmLIMPjGSJKtWhNOzr+k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aG2+GO6G;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787759762;
	b=C+zZb7hehDhrYDYt44fvwQKJ3vLKq1eMsNzDMH2fC3qM7wtswxAjGxjVukNSW5fbwAXmHQ
	iqG9I2paeK57Bs249dgNZXw3lE6MLiF6AAZI7bzf0kYQ0B8pFkpT7lZiy2xDU772zE4uOa
	Oh4LAgCZR+yF2RGQDp5Pn8lBg4IW5fw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E8D560A63;
	Wed, 26 Aug 2026 15:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3DF1F00A3A;
	Wed, 26 Aug 2026 15:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787759761;
	bh=Xv6LvbJXor25svpyF1shB5+LUX7dxOQBbe5g57lme0s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aG2+GO6GAZcXlhCpgH4qqw7omdbZ3lTajbsgfjPtKnShfu336O/+yok0gpWBwbMyW
	 UnC3yKhfup2dfl8lfHCHm19GXWaVZy3azoYf08PvN+emHgQA68VZmlbExfYvzG4ekO
	 yB1ubax7/mGSYGYh7XcMZqHFdcvDb9Ka7DtDiYl1HMXEsh8yginUNM2seFi/jfnExZ
	 7k42I0xrAC9bIOd8BJ49XyO5DrZa5syu9TCHEDgn3iFFmDyKa3pXDmiSNUkNu4UJoM
	 kUuQEOZyLKlJSMPF63ra2VbzjCIRXHlhL0QFhj6CKWD5OyK1lW4h7TEsF5DE3f6A+w
	 7kQdiwLbw+CMQ==
From: Christian Brauner <brauner@kernel.org>
Date: Wed, 26 Aug 2026 17:55:46 +0200
Subject: [PATCH 1/3] binfmt_misc: only let punctuation delimit a register
 string
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260826-work-binfmt_misc-delim-v1-1-43618adf8599@kernel.org>
References: <20260826-work-binfmt_misc-delim-v1-0-43618adf8599@kernel.org>
In-Reply-To: <20260826-work-binfmt_misc-delim-v1-0-43618adf8599@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-doc@vger.kernel.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1730; i=brauner@kernel.org;
 h=from:subject:message-id; bh=/DI1LeiV4wOLRgjpw4V8nHUf0uW01ksKySY2chdDeSU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT183Qz6cbvOhpjcTr2U+iqQ49fPVTbfn5tje3Mt9t/r
 rkoOeHixI5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJsOkyMkzVKO9/Z66x/tG9
 n8vYinpqf/s85Ft4z/Drr7KZE0WOGl1kZLgotkVbfnXS9FDJX/cXL1pcsXyFxu6F6z6/z+bsteP
 teswNAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: gq5m9h5ruwy6ripygrxom7cw5f3pfd44
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9D2BFA0009
X-Rspam-User: 
X-HE-Tag: 1787759762-464759
X-HE-Meta: U2FsdGVkX1/V7YwAhHQCZwrPb45oqye007zyCfZjsgWQ2SDgfHtWYf56k4WrtBJSG1sP6tzcpWaQN0/LHo4utGnEOyUYesiNXab1lNBLie/ZU8B32EiCUq6Fa5GVOvwFZVVW7MYBBdSB3e8eBOSR6ZA3jNFn31nj4oBkdg5faTV6siNZP3WIgkBJfv7cWQPybDPsIxGrVmqLR4Tuns0UUWiv7TyvNDgePz2a3y1N65AZdoCsh4ggXEWgjhxVq2tdn94/SasfzZ5Px6X5cwYofPciyD12Rb+E5RF8lbt88+WJ5ETuODukHjqiQ6z7y9j5fWFOEuIiOBPBkhA8lCcRdlTcRwtWuSfSR60aveIsylYIB/AMGFuDcaEMHZnYKwJSvnbOuDlFYyLZ8DQC/f2HXKhLnWNypurKXZqF1z2aCghB23Ne6s6ZZGVBd+8CbWMq89PUcaFTmZ8ukbkQMC1o85YJVL9+34SPbkDCLAD7E78kE2dZU1A+f5wGLE3DSdjVLWOt2ZuhtINAb8LBCiht5SUL4A0ZKuzOAlT5dIbgsy670dZOY/EkMOvPpPNQkS/JUrjgZsTUf+8MGADaRbUb+LfWB4tp/gsJY04X3q2SqpwL7x/1Vt21OdtbRX0uJSJFGOWPFJR24twm4wd3VFCyi+DlVVDnknkzsU6u+oQMdjP0Q0gZgFUmZqsPaGRAfy3/DQIMxjDMC49stLeIID1Z3E0hXx4fYvKUBBWwemx4FZIp/j+x0d7wRh8//6kmC4NmKhpl820lMh7ds4wNLobqUDUV4uoPenBh6bqwonEo91QTKjsnzT7YrkFASJgIx57oLmWFo/5n1V3VXaDECR7V1ypRY5lhi+NnN3WKbUGP7kXjrkWpjMb+5h5e7mZANzIwpuZ+nzpvL6WVcQD4EeHSNE5wPlwN3/1n4b7jAkvl8rVRFGoT7+vm1NX70ic+hWrU7s1oc7yw3vKZDcaUvgb
 sIj+HFwp
 mAj12hdPhoZwVEWU6HlAYGjbcHqcG4dnJRQttzvV6hYkj2n3tocnHjEb+rABCamlmigA3oJxaEzpxLd+KcS07GWQSeUr+jVTparpnGBfGylmeLjlAEB/0LPzEwaDLyFsHzVjdOO0HR9oa9u9kt6TItwHkCMsGRXxn/r2MTcnaAfwdKnvnC6emj0oMycwzH+ccWQdDOR1Zg5VpxMtzMnOOUb0n+MV/E75rITlknL3xyYvnUS+2xA7Ukuj88STu3O0MXyDIVwwfn8znNHpVl6SqxXCmENO0YBbfuLRR7EGU0CS59HZd3Vg5+sSkJxyvKyjLnVQUyG6/LkVbCY+eI0KxPGWHa1H99T32DQCZxyXRJqOjKZyHSHDfYh5OgqUh6sQi6RQx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently we accept arbitrary delimiters which really makes no sense and
from looking around it's an unused feature. Everytime we add a flag the
number of possible delimiter shrinks and it makes extensions much more
hazardous than they need to be. Stop it and only accept punctional as
delimiters.

This extends commit 8e85d50ba111 ("binfmt_misc: reject a flag character
as the field delimiter").

Letters, digits, whitespace, control characters, bytes above 0x7f and
the backslash now get -EINVAL. Everything deployed uses ':' anyway.

Suggested-by: Farid Zakaria <farid.m.zakaria@gmail.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index ddfd3aa57ac8..809c91d21b39 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -100,6 +100,13 @@ static const struct binfmt_misc_flag *misc_flag_by_char(const char c)
 	return NULL;
 }
 
+static bool misc_valid_delim(const char c)
+{
+	if (!isascii(c) || !ispunct(c))
+		return false;
+	return c != '\\';
+}
+
 struct binfmt_misc_entry {
 	struct hlist_node node;
 	unsigned long flags;		/* type, status, etc. */
@@ -872,10 +879,9 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 
 	del = *p++;	/* delimiter */
 
-	pr_debug("register: delim: %#x {%c}\n", del, del);
+	pr_debug("register: delim: %#x\n", del);
 
-	/* A flag-char delimiter runs the flag scan off the buffer. */
-	if (misc_flag_by_char(del))
+	if (!misc_valid_delim(del))
 		return ERR_PTR(-EINVAL);
 
 	/* Pad the buffer with the delim to simplify parsing below. */

-- 
2.53.0


