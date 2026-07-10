Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2F1CC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 09:33:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C00E6B00A1; Fri, 10 Jul 2026 05:33:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0989D6B00A2; Fri, 10 Jul 2026 05:33:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F18F96B00A3; Fri, 10 Jul 2026 05:33:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C2A946B00A1
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:33:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5D9068DC91
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:39 +0000 (UTC)
X-FDA: 84972354558.28.AE8FD1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9F7F01C000A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=An4q1j2G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783676017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iwlYheVG6icIHmdmsNMEBkrrzNe9SOaUJzkR1EUgI/4=;
	b=OhmJOYXLrVgTyAi/h1LzAastrskHKV48zi/9ZWg5vUCfl+3PP4WlLf/rR9tWP+DiiyZwM1
	80qxnBO63ILDNufsqAlwc+8InMWEvsdkYBYj4gfJNqwL0yqc97NMkGmgBf7ev/prXcJaC3
	+UDtjern8EyI/KHu/pZyZr4NR6mNCAk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=An4q1j2G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783676017;
	b=1uZmUT6oztAhyrNultsazfv2ASTj8s/YsyWC89Y7IYUc4BKpbmM480VL5cgzuKQmmu9ZNP
	U4B50VklZfsU814DU/Fr1sLJl+CmamvjPrEDfyQ70zLrARA6gLHmtVEiGXEJP0W+OPVz5v
	sIkjP4hyFYe6S6ANH6urej7uumf9WUw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DDEF343DD9;
	Fri, 10 Jul 2026 09:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 695771F000E9;
	Fri, 10 Jul 2026 09:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783676016;
	bh=iwlYheVG6icIHmdmsNMEBkrrzNe9SOaUJzkR1EUgI/4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=An4q1j2GaYhe/VG11utIIbx9ZF3sOE20R2NXRqRhdS54DN/TroTMHWLmwPLDBv29S
	 y1BprT5jdp8tmpe4DdAev4nW+nEEKrWoCqyL5qDaXwLu5u428YlwjFhVWsH2+npjsd
	 EwHM701o3Rr5ZMj/0oC4PVNEqIB+bmcIk9UXDTKTuH7GUaUzoqz66gKsHIeSsxjLBz
	 N+9kxriJZxpeKnSz4bvdyf7QFv/cN3VVVclwCvAn7oZbpcCNaMvKL979chf+Fxai73
	 rIxvEqipoP6/8E2+1sJ6gVdk/1L3FGz8/S/S2wEiJq2TiZGw/8UWq71+H/l1d1sM/x
	 4cfSmT/ZxOFyw==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 11:33:09 +0200
Subject: [PATCH v3 08/24] binfmt_misc: turn the entry behavior flags into
 an enum
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v3-8-a162f7cb58d6@kernel.org>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1363; i=brauner@kernel.org;
 h=from:subject:message-id; bh=+MBgYU1GV0umHJMg17ftmyaxlU63xECEjmXgq5k8HHQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQF7Ilb3TP90MlPzCGiyz/ObrA48e9GotOkRfu2tbae+
 bld2+SmU0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEqtcz/M8W6f0kYPO8bl8G
 /8MHr3l+72/w3fJOubkkXWTe8921X20ZGU4vPL5osahB4sRoZpErPbvOXXlx47pA46po42U5hm1
 tW9gB
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9F7F01C000A
X-Stat-Signature: ukptuusuqqyoogufiayfxraeme1h7wyy
X-Rspam-User: 
X-HE-Tag: 1783676017-401261
X-HE-Meta: U2FsdGVkX18hGzEJKn1YWZ9c5kQKBYIoRmwHUoj8hCuNXrgITlisavjK+Tqoy3I0BPLDJPmFQIA9F5E1fT41vjBJxd18R+sDjL2FIcvmCC8eXWGusKW0Cgg82pRXUZc4Nk/gl5FS39dQb2t6j7j8Hi2e+iAKlDScDRUdeMGfuvtqJfn2DjmTJMjVLavu1/oRt9yI4UVpo7da+mqgvzf2EzPF93c8a9OobbYLWUQQV3/3T5vBUEJkiLvMYuoRd6my6chqaPYuJCHUz1EKRLIyt9p9SDu+XiNLUsQNeG08tYsciPkfCVhBreZEKtEpS6KG/sC9KL1ZDRULoEy1UmywXrjtxpqaTtXDsf5ETxFTt1LEexPnqsg35Hzh/2StG3F9PiRDUaQN2EGivNPvxA6kfbwAu0n0S/ndOw0rIwuUbY0SdWWdDT/VnS360jEYEdefRltVWhLM9hAUVJhDL0yep9w8R4DgOzWx3YAWF34pt6vxhydctLNJsKjvGZ8LSVEvUAOOnjWHFA2Q55Kc0PuzguHHcqxYnl78wGbkSh/KygjR3af6WTuRYPhwwiIfmqOW9ptSYr8/9eBr6gDHtNP2DTKf70pKR25ouX4MUuO41WgbqPFUooSSlcyuwfJzT5b5K7awPyYYIzyp1Jc++/tDjkv+mWw6yD9BAYRFa3QsQVbWxq262dnlksMGnuvC2pUgIMCHmuSJmW451F6iu8m1Tnx6qUGlmuWxyypDEiBBDtOJnqx1yD2gayry+AkkTODmNBcLwxRRfKOP0wMKiCNygj0FimbEYZScyJXFkw+yNvwB5PtsLLHU/WkRsfW6kj6jvZiWyrvJoQSwa0zbA3IjVw80IsJuqIfSmQoNVLkreYr7D1+vlUOISqdaCRQn1rtobnNLylW4NZ0e/a8vUylI8mhspOMZ3y5nIMIzvCw+8XUm+Jt96CDwjBkwzB6lixEiGLB2iujq8VtaWdvcapz
 sPFy5rB9
 p+JUHNgjDKRasmN/Pg5lRHg50/wusVvUc3N81SCVa22PnAwGEFdA8IsYemAchIIEdK9HT4PwmrV+wYCZ4BqfgC9dln88afO0+acSJ3u1X1wZePMxWgKluLVNHPWWpGckFGMfbmQ1xCJ9sHVMeWrSVLMEaXGfq62aJPCtN4J1bsi14kjj1Vk2fyP8z+XZTmCVSXNWR3jpw+13OKh9+FuTAYnP4u3VOz3BCXt0Gq6zI8TA/4idJpR7znKXCSFQr7ZZ8SP7Eud2KdfxCVGsRwvT0yfTO4kggPUVqASF8+C4qUqTSMzeo4SRdGiOmJk+xw0OFrbtkCBUXJ7gsuM9nEmU+r0vj2yJuPmKChcGKbZ4KAbDTId4=
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
index 90962044d19e..98ad1383ba6b 100644
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


