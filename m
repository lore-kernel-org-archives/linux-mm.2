Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D002C44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A11B6B009E; Tue, 21 Jul 2026 10:14:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 978AA6B009F; Tue, 21 Jul 2026 10:14:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B5456B00A0; Tue, 21 Jul 2026 10:14:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 624226B009E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:14:49 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B3632C01A0
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:14:48 +0000 (UTC)
X-FDA: 85012979856.18.AA3DAA5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id EE1AF14000F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:14:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CuvplyGD;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784643286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wxkLWep5VFtYgEm6sKvmi+7h5j3tv8fHaNY2zfaitRA=;
	b=PujC/cl7V2zPGuAB4+CtocJ9yxOA8HfGrBe8PAnsllPH84Ozue6n37qNjxucTci73o0gbS
	6FLLe1rfoPyNx0KpqMJVg/wFBV2+DKEm57FCGYjCGp/I5/VwQK7bR8Vzc5JR6x9pJhiKWY
	YDgXb/EMab/A4SQnO/CKSCRN3lOUt8g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784643286;
	b=RWqcvBzoJkPMsWIOclpnggSmJ0aEHHHfn6YdWRSUBIFw7K8hg3gO5eC+mijMGUZUTWimpO
	zbCyI55/W0FEthFv0DlgnfFNlrqGyEsz+m3RDyhEoRjUxYq6bfm3rLtYWq4sZQSAUZ+4bY
	EvlcXwqE5bsaOs1QMO+yFGSRlhPUAbs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CuvplyGD;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 84C1260204;
	Tue, 21 Jul 2026 14:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ECA31F000E9;
	Tue, 21 Jul 2026 14:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784643286;
	bh=wxkLWep5VFtYgEm6sKvmi+7h5j3tv8fHaNY2zfaitRA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CuvplyGDyiHknI6ZZQm/KoAxwwhS1a9bTYsgo72rx1bC6sBqyiHeSVFaF9xrMqZcm
	 8yXTwJwtzy1Zrum/wIhcxLCl1dqkye8g4nnF/JGIFMuQPE6cfwnBqRWMDIVbyt9EW6
	 P8dOx0VkIEIapmsHtOwvmbT+tG23t0/yl0xP1U3YKBcQtLXLKR/CzRs89ej8fbq1Oa
	 SVlcOrX8dk48vC4MYSR7JLk7EPdQQ+lw0OVWO1I8FZpxrY5DvSWQhUwiSFSNiBjJkx
	 RaDb+B5usm247fasankfgqS4/ehXng7ru8uPSVeva5qgiMbmldLw8Ft3f47Rm3ESw2
	 yUx0ZshQGXwdg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 21 Jul 2026 16:13:48 +0200
Subject: [PATCH v2 06/21] exec: release the replaced file with
 do_close_execat()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-work-bpf-binfmt_misc-ptinterp-v2-6-e57866e4ae0f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1262; i=brauner@kernel.org;
 h=from:subject:message-id; bh=lHTPa0Kuv7ZBQP62Z8DPWg8DZoMxaet8DMO+ZA80gC8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTF1+2fteMG09TlmvtEFxoyWx/1m3BJ/gNrvNXcoieiX
 rXX+JJlOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZyMpbhv/djHxPD1YfvK6ct
 nnJ5ljrjsQlndAsSm2/uuLX5yHM1hqkM/ysVP870cDyYVXDjqINIePWvYx2ml4sE51tJrU6pa/m
 6nREA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EE1AF14000F
X-Stat-Signature: 8bwc3omeyqguk9qqcsdcue1dsjwdfrnh
X-Rspam-User: 
X-HE-Tag: 1784643286-939533
X-HE-Meta: U2FsdGVkX1+nxKd9uN9UB4/OYDFZSQiBeuHHdez1MlBX3lggxf6GC25bSbpefZSARmf5s06l1o5eHVcvsbvBRkDsTdzgRDBYIq7JpKLCQjEMXI/gucaZ29Hxxhs4I3u7mZ98iObhlwagH86hv2gHxIm26H2dpZYFV+Ioli23WARtD09LlFkKhLgZ7iaDW0d6QkZajIInLKFHwKI9snUsXAtj3oTMlAGFtDpJ4AKiLSfTc1HoQULmNhXQncaLbuVizMH37GvMkoWTlFyYkgj2Q4sROysggO/jzF5KBpUuul8Bi80MUSjSz97UnfBu4IsZmmICRbtQr5Sg5zYapvLytrctcuzeI+ddt0pLm7b2YXh1UxieDgyETbTzWuZ3+kLjqBKFXNW7/tvMwUwvgax6xe7mprKHK89CMcDz8lftCQ+1cAgDG5DTLjZM9du0NlPHueaRAVicXUjM/uCcwhu/qUYzr8YxJi/H7qmvq44MRQaY2DITF1HOMYUdqjqCONzWPbSs/S7WJqmtA8pkPaLN6K27KbWOwg/JR2iZK/rTSZ3aJLzjtbkVO0QKMltM/fgNYeykx3AhqJHl7x3HeTqhtDESv5eIzv5ChIgv6uxbcS7aX+yPb5+bUVwSStudaCAfaTubRZM/ewR3GPvCzzhs34Un5cjRgYNOnUbwIb/N1K1USxpiEMj7O1vJMsWG44dNf19Y/HwJlbvY2WDV4Nhvvtcas8VyKamXoARvnpXqVexlt04JyPDgg8yRj+Ov1q+DErYFC1wG1+Ki69hTVRe5lTkk5lsGCJcpIoWeEOfKZ7OWqb5Jsgwk+gydaE4Q89G018XJKjij6UKJDpDUf8vndXvHZfOicEspd+DTO2QKCqmtoCs52HCqQoHaA6DlYBJ6dgsrCy0AWySvndDbAmC5RXtdiYrNtDFUUhWY/9pgQiHIMA1sPw4Um9+15Q9NjFKujtQnZO2VPeXQki66uER
 FJQcKFii
 IgOCH7WobTdnKagxRO3uwESq4gD76r6EwbhmE1TUsTfPFIk3SUxq+4yG2/Sx2SZ0djmzwSMOJeNI4nZvUAuSjn9QendnSgEw35zkeN2gsUI+pyxmwau+sBaMmx9kleVbLk+eiL/qvngLONVDenN8CG3JTSHngKOJQ67sW3miUBftpncQaTBU88Y4uxxLuz1iPbihgWRkbBj5XetWa36LjMATgsA3/aFClwH0y9unFlNUF331bgrxaAFVnyN2Zu0UDuPfxS08kZGNXOiCIKub4NgRyT4UZX1X558IvWz8h8YMxdUiAKeru0ro1HRlzu5H6U7pXNlg9nBhK8QaTC/ltnJ9adOSYVDjIzc0RUPLaEbvputo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the format search stages an interpreter exec_binprm() swaps it
in and releases the file it replaces. Dropping the write denial the
open took is done manually ahead of both release paths. The one path
that keeps the file silently relies on it not being called.

Let's just use do_close_execat() on the two paths that release the file
and drop the denial explicitly on the one that does not.

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/exec.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 41e1684d999c..061e0f9fb4ef 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1735,15 +1735,17 @@ static int exec_binprm(struct linux_binprm *bprm)
 		bprm->file = bprm->interpreter;
 		bprm->interpreter = NULL;
 
-		exe_file_allow_write_access(exec);
 		if (unlikely(bprm->have_execfd)) {
 			if (bprm->executable) {
-				fput(exec);
+				do_close_execat(exec);
 				return -ENOEXEC;
 			}
+			/* Only the reference is kept, for AT_EXECFD. */
+			exe_file_allow_write_access(exec);
 			bprm->executable = exec;
-		} else
-			fput(exec);
+		} else {
+			do_close_execat(exec);
+		}
 	}
 
 	audit_bprm(bprm);

-- 
2.53.0


