Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4E92C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 22:30:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 682ED6B009B; Thu,  9 Jul 2026 18:30:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BE296B009D; Thu,  9 Jul 2026 18:30:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FCC96B009E; Thu,  9 Jul 2026 18:30:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 186326B009B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:30:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 795F91692AF
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:32 +0000 (UTC)
X-FDA: 84970683504.19.E98EB93
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id AA4BC40005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QmlgicS2;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783636230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TpPIWnB5EGOBygOl5xUSo4Bo31VS4QZB7PjbGgp98j4=;
	b=i5AItuLU/ugLUaDNgWe9ppS/qZeUv7/O7SoKs7CSJqhsRHCu+lwMXJd0LurCH3fKEovqn3
	WSajSa4szA1kNpOAPlhilKETJ4KC4GTca0+clWijgS2Cx2M3Hn6KbI2qANeelNjMu7kW75
	2sTNrxF85Xz8TK5WMmp5NFo76PyfkKk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QmlgicS2;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783636230;
	b=qm96YP5+PPVmrNFmRTJDAU1qpiqMKUNXyRjH5X0E0myIfpqwhEp0M7zr9xEk1Emn712B3f
	T1/V1Rinqd1PZiUC7NvEcnqIZRqTTn9yzvp1xbcK5vVrFqZDmjXKhMoI5EHAHV1gN8kgkO
	06tCnWWZaFAzyipAiyK4Zva+MLeOHdE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0631C418DD;
	Thu,  9 Jul 2026 22:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2AB1F000E9;
	Thu,  9 Jul 2026 22:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783636229;
	bh=TpPIWnB5EGOBygOl5xUSo4Bo31VS4QZB7PjbGgp98j4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QmlgicS2TKnrfmRNI+JacrCDJK6QxRMJ19YOOf83cTetLjtNRQPaVj6OpKpbZFN9V
	 9e+Nj98GnLUcOCQKGOJcWGepLY1JLghFmWFL29iuei8rdVVrcsOFeXP/ky+etVDZyx
	 W1yKKDg0hapQKP0kSh7lzDGpzXBIq9HqWMjLH5R/wH8Q/AcCSiUAfsSdtRjlzpFy21
	 KhNLzbn8XfYOSnsA3CI9EoZiR8ErzjCoA/V0REQN8vKI77WdP5gx7BqhGq9yhQpg79
	 zIBiPAHATlqzdIlEW7jevlw/LNyeenpO0Pd6T9IEeYKkkdgc4BXBcpd71dUFaOWrT3
	 lnZw4VqXXIL/A==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 00:30:02 +0200
Subject: [PATCH v2 07/23] binfmt_misc: turn the entry behavior flags into
 an enum
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v2-7-2a1c3d4126a7@kernel.org>
References: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1363; i=brauner@kernel.org;
 h=from:subject:message-id; bh=oi6YqCiauhLy2SRVgSkkNzs31bAwl53yzw4aBTbiKnQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQFKHzNylDesETCJeBm4M8dM0NsDhxNcdpil2u1Z9a3h
 A9To+6bdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExENIGR4Yh98Yk650M58259
 sM92jw+tLRSPrzU3XTJXUvbXMbaidwz/tLY82lX1Yn/3uRdrnTkmqL9Z/fDKkcAVG18ecPj6MGD
 fDw4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AA4BC40005
X-Stat-Signature: xi9ixp4ihedxi3896s36qegw8fyxdwqk
X-HE-Tag: 1783636230-528386
X-HE-Meta: U2FsdGVkX19a4yvfBvfasweSQvKWaouNAko66REGtZ5jW1gsYYH643JxcASkaoJwzNOJVb5iPprHHUhVvh8engSTyrAF90kZ6k8faTs0oAszLbHgyeHCiE53lXcfkxqn5m2C+5Zt7avwSI0NC0cqb9vQlns1RoRCHc3EMo+l6jlRTlscOzIpFbsluJIUo2oAcc/rGvKOVqbXQE8XJR3ykn7Z8X+I3+Kk60p5tMVFagMJULpArDD7MG7ndfENR8/bKlAC3khttlDq0qHJ9jVUQHD6ziSvHNoOMdSwWU+dABNfHI2HPtf8YitGMBTCFXhB+Cx5iHp9veELH2Cv7ZaRIJMU4LUzsRtS5OBdbOTJwRopM+4sr8kckgwcp8t77Zk0XhfdnG79kLcrpt1F9f9ekaEo0IviELF5LNSFM2PS8wqAg9U1KR3aaVAMK+8bkeG4ucCkajlk4flvkvQL2eegkVhDe97l3lkxDv+AIspoo9WmSULW21eXfkM2Z9+fN+Bdb2V+4ijx7w3vjfe+3G6OMk5kXsttgpr+JrS08g4XVHNfnZ85LU/iu4NffHDJE5aZlw9RaUkEiWJZro/QWoz9F5fAL2zVVWwtkxXGk8eHPU5SEAMjynzvpXd1O8CoE9AHjlWCHHOXntFwazLT6XH4Mw8BwoJof9YIlFiUW0MvtQu5MfBhaXr1Eaf2tW5D8ChpLES5yqTdjJ+JnI/WqJHI4YZ6bqFcWQnfgi68SZU2f84ptPBLrktTsctxBmgOIjHy/ch/O0xuq7yYUUIjoqS1YuSTHInh9mMTT0Zhk2tyUWs6A51xJoLiZBsvdcElA/zywaoq4JXE2g5YVCbtktKoUNPDEU84CrLiT4WkJ9T2GM4vgCoBBWN08pQjhkJk5Bwtx3KfSU8/Det4SAY4rYszBJIsZJsLsNWcjHLigP6RbJt7yvH3J+5WofsVHCLQfAguyM2tZtlGEsjJgG2a+OU
 Vl60gAtc
 SHXKLGMCpn+UgkdSnn+yboO1BbG7B4DbgBEGhROFIqlimPPaKBlqWUmtHiqCn3ZQMCNNUC2UYPsKC7owx5GyJE2v48bk53Nrn471D+XL+nl6zH0oMb3g/u81exjsFaNsexDvrVWTxCEdQIeyXmiIZd0mMsEhqoZBUa6lO3VNuC7c95kYQQupvK+VJAlJOWN/MotKftP36qalSyJwcsEGkRrfxQM5XWpN4fRX70y0W2KWIJzBZcra/VwrHjsfKaFXbNlN0SeHjA36a1AgXULo7Wxz1RsmQALT9iXQWMx/lW0Zep8lUJaF4d/XbdvMojKGGKwFtDv6TIIDu0b80kJiPl4ERHyE9wzyaGtQFoBkxhbJaVDqlQh4Pf2JonA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The MISC_FMT_* behavior flags are macros using unsigned long literals
while the entry bit numbers right above them are now a proper enum.
Move the flags into an enum as well so every flags word constant is
declared in one form and shows up in debuginfo. (1U << N) keeps the
enumerators within unsigned int range which is well-defined for enum
constants and the values are unchanged when promoted to the unsigned
long flags word.

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index f1ad0bce5af1..c722ee54c939 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -47,10 +47,14 @@ enum binfmt_misc_entry_bits {
 	MISC_FMT_ENABLED_BIT	= 0,
 	MISC_FMT_MAGIC_BIT	= 1,
 };
-#define MISC_FMT_PRESERVE_ARGV0 (1UL << 31)
-#define MISC_FMT_OPEN_BINARY (1UL << 30)
-#define MISC_FMT_CREDENTIALS (1UL << 29)
-#define MISC_FMT_OPEN_FILE (1UL << 28)
+
+/* Entry behavior flags, fixed at registration time. */
+enum binfmt_misc_entry_flags {
+	MISC_FMT_PRESERVE_ARGV0	= (1U << 31),
+	MISC_FMT_OPEN_BINARY	= (1U << 30),
+	MISC_FMT_CREDENTIALS	= (1U << 29),
+	MISC_FMT_OPEN_FILE	= (1U << 28),
+};
 
 typedef struct {
 	struct hlist_node node;

-- 
2.53.0


