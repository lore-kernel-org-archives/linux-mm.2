Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07249C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 09:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0B566B00AF; Fri, 10 Jul 2026 05:33:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE3306B00B0; Fri, 10 Jul 2026 05:33:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B00CE6B00B1; Fri, 10 Jul 2026 05:33:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85E3F6B00AF
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:33:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 25EC11C3A65
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:58 +0000 (UTC)
X-FDA: 84972355356.14.85E2990
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 63DFDA0004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VcmdBwVs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783676036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h2zpwyUcEr/QbPM9WrOrK2LoYTyvNqLM5laWV7rkoLU=;
	b=yLlqJG5HZYXT8XekP6bgKXYfZloPDAt1yPunZdpXonB9ByzSF/OSRr1mlmuJMycG5R3icr
	AFXgXay2Ba5dDt7Sn1+R6beHVLtgI25aSNtlgFRH2sPkhbBOtl9D+0FPueHGlfgYwEFi43
	s8EVwxCRnrxEr3d24lV7uoh9Y/vz9Qc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VcmdBwVs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783676036;
	b=apPwP/GksLIqkCYvNolpw9FI8bWzD/i6zb9FQySvquOSqUV91nIy2IWzolrqZcc1jE4+eX
	qp1rr5ZLBpM0vb01956Mj90QyvxQs8mpbSNwyaZK6DWHvwLPDeydS6FWv4VQiVlmWr33zx
	9G4vUfSjP4f2UIc49WRYkk2Rxp+h8qE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B930B436F6;
	Fri, 10 Jul 2026 09:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4344A1F000E9;
	Fri, 10 Jul 2026 09:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783676035;
	bh=h2zpwyUcEr/QbPM9WrOrK2LoYTyvNqLM5laWV7rkoLU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VcmdBwVs0lS00LbjDRFH0RgJkW9rxnzcfZkk2WRAOuYxJiLkShmc7+K2ZE6do9Ar4
	 YD1+iRukJ+AGZzumc2eHlCvRUdCuFED/NuxxRwgdPbcdu73qwri4J3XfF8DNMMWOCG
	 VcSDWYrPm3O+z/sd2NCu7eZddbxRvVRPKYtKksb1XJD2+ru+gP1xt/iUF0nqRlBXNS
	 W4qm1eWaTUsoCG1NoOh5epYllLKncIP2c3gCmqTJrlRsnChCxMqtHXudQ6UMURmGzS
	 Y37FgCqoQ8DprXOMjIQu/aeRT8TNERbEdmhDh1G6aN+hSAMzf98SWv9VjEdnXAa4mT
	 AFrC67RbBU+FQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 11:33:19 +0200
Subject: [PATCH v3 18/24] binfmt_misc: simplify check_special_flags()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v3-18-a162f7cb58d6@kernel.org>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1679; i=brauner@kernel.org;
 h=from:subject:message-id; bh=JtQhDe27O2U+ZmKmCXJomowDYtVwErLVfhHki4PCl94=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQF7Im/ans90NhHIXMlB5vFQh6eGpVFHjfLlNob7Vpu3
 ffaENTSUcrCIMbFICumyOLQbhIut5ynYrNRpgbMHFYmkCEMXJwCMJESTkaGhV/eHGTZJ3PH+33K
 QkY1sf79v6fxRWz9eOvnv+NSF2vF/jMyTFw67/f62f9mVxx6VpX+IP2uqtyqCd4LA6e/UNl4/+m
 d+3wA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 63DFDA0004
X-Stat-Signature: xkxxpfajm3o9xeod46kxct4xdjqehbaj
X-HE-Tag: 1783676036-461853
X-HE-Meta: U2FsdGVkX18BFTZpgGDMhgY2xsy6BPvVCoPrBOnwDd+9pqI1qrpnjjkFVgbqwloU8eEB98RIm0aPGSGIyQV3ntmw/pfkzlZkVKbxw+nZLZg0yW73B8TM47O6qgXJVu0MZ3HqkkZkYZRqmaTvie+tOyZdEonmctQK+Hf/Lp71eRWpE2NXLsGMBMigbV5u/HPZYMaPNN1ObxyynNt/ITqSuXdWqBMJ9k68+amj9Q+/caJ4KJMsta9P6U+wftD1uJ9TXO5fO87OiXO3Cw1yUTUa6m+D4AricFG6kpuqH6mW++gDAkk0c6CARUXuJ5TD8Ze516mREPMti+rzo2AA4Cdxj3fzlQ/sFofnA/bJMKgPZhG2woAab6mVIKgtss92POl8Paam+/k4CYSjtlc8QpaB2SEkEjiIGDHK8f8U+122lK3cBF5xM/Wf+FBbTrbZSWCDS1CsDcFdn7ejYbVi4gzkIVjrLOD3hq3XGqp3xfMTyMFIDRPs0NapIYzVj+FdoD3ocW0fa7JNlQAPDNLS0CszAGO8x6+S1IoIGNaIeLQIHgiPoB/C8Oh7C/HFe5L5WXH0o7yZO0QiETUJnCu9K7zC+1lo2jaE9X7TQeWWnsekA+v3dJSSLsyDtHAHImhIocheFaGIIyRrEmGtFRXQxahXe+o2k18TqtZhcpfm6hdR9AQBAZo000JLwbfc9gHRHy3PHfP5NJ0atgJ+KjymSUvpDuouXl88o6kHouKMepj6hYAIV7syufzmrh5kdVBWlhTKaMdoiL2flgBJCp+4ksX2GRC4zBIh/YLHlfi/ra6KzGWVePKhkQEZ65ZCPhBLr/th209v3rkc82wbDPcOkDAFHvrFP5HgdxOrzIUqFOjHSbXz/6EvU75KyVk6IufiKv7lH/DWWSEPuZzck3QMYXyUw4iSVsPNxaSGjoHH1u7W6VSDhiWSKd8x6ugBQ8Gdd+/kuJ/y15J9h1skxoBXYjD
 vot5IVdZ
 K9Gogfn3FPuip9wYOqVSO2NORztvOaVyuy3XtgifABYif6lVEo71rGyhxImDTSNsjpLGDQeFSbDoJ7Ub6GO71kyJJknU4fuk0/r1SusaHozpHbgAh8SsgTtUAUVYpkkoA+4nQoF0xtcscXJrajf3jzw9OpQFSYnqKWNjp93FjMv497ExmrfoMd3R9S6mYl5LA7+b8mwpzF8mzmlMWWcy5EjMx9wJUyTO2dhq+kqstGpu2qSMxr/7uEztSzaCmUFu+wbnlKLNdCqJwA8yftv7MmtwuIgV1DvtBwMyZx0DPlri9baMC9GaPWZtop4C4ZmANUoGUEGfvOvY6MDnGKfGaE5LLAfJDwhiOIusKR69tuGp7PK819UkUCz+D9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the cont flag and the pointer increment repeated in every
case with a for loop that returns from the default case, and shrink
the multi-line 'C implies O' remark to one line.

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index d6bc2abc4a7f..d9dc9546d199 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -309,43 +309,31 @@ static char *scanarg(char *s, char del)
 	return s;
 }
 
-static char *check_special_flags(char *sfs, struct binfmt_misc_entry *e)
+static char *check_special_flags(char *p, struct binfmt_misc_entry *e)
 {
-	char *p = sfs;
-	int cont = 1;
-
-	/* special flags */
-	while (cont) {
+	for (;; p++) {
 		switch (*p) {
 		case 'P':
 			pr_debug("register: flag: P (preserve argv0)\n");
-			p++;
 			e->flags |= MISC_FMT_PRESERVE_ARGV0;
 			break;
 		case 'O':
 			pr_debug("register: flag: O (open binary)\n");
-			p++;
 			e->flags |= MISC_FMT_OPEN_BINARY;
 			break;
 		case 'C':
 			pr_debug("register: flag: C (preserve creds)\n");
-			p++;
-			/* this flags also implies the
-			   open-binary flag */
-			e->flags |= (MISC_FMT_CREDENTIALS |
-					MISC_FMT_OPEN_BINARY);
+			/* C implies O */
+			e->flags |= MISC_FMT_CREDENTIALS | MISC_FMT_OPEN_BINARY;
 			break;
 		case 'F':
 			pr_debug("register: flag: F: open interpreter file now\n");
-			p++;
 			e->flags |= MISC_FMT_OPEN_FILE;
 			break;
 		default:
-			cont = 0;
+			return p;
 		}
 	}
-
-	return p;
 }
 
 /*

-- 
2.53.0


