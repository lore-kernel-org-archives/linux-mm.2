Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AC98C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 22:30:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E72366B0099; Thu,  9 Jul 2026 18:30:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E498B6B009D; Thu,  9 Jul 2026 18:30:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5C2C6B0099; Thu,  9 Jul 2026 18:30:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A43446B0099
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:30:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 260BB40314
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:30 +0000 (UTC)
X-FDA: 84970683420.09.B8EDACD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 70803C0011
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lqw7KnIf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783636228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7TfSZ6IW6EVUOTLu+a8V1x8AdtgO5MINp4HOFsWyE98=;
	b=n5sDcqn77SO2b/GE6IzJwJfHYzVqkV9cJ4Z7GTNwCUIvvSmD0eodK9IIkq4sgMI81f4rYN
	QAxRsVsEKAUNPvOe/3SkqYvkP6qd33pEDT91mRuYNozaWpXAhPvnVzE/H9G+oWhyfo3rns
	G55fbf388REUGrBIq6ToUWsNSkO6Pd8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lqw7KnIf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783636228;
	b=JTlOuAWLQGQyJ7n3Wdn5qLdNnrWhfhuNsMFK0b8f20fl3yoUGQRKqkdnZiJsc6ZvB19vp3
	llZY1k4W5iDJ6ZX1LvAdBuZWkySyQeme+VQHftb7vNFJfJkpfPk/we7SzaF/oz+1DvbjnO
	4y5k/ZEsL9gEo/JUGUVB32SbHBtaZzI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 037E36138A;
	Thu,  9 Jul 2026 22:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F871F00A3A;
	Thu,  9 Jul 2026 22:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783636227;
	bh=7TfSZ6IW6EVUOTLu+a8V1x8AdtgO5MINp4HOFsWyE98=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lqw7KnIf+yaT1BLIPiQxYYc0ifpBkl6XS0pK/SzC1m2NVk7pvpRJNYxIIcDALVOzt
	 DlRtmQvp5JNG1YWpIZFE/WZ7JYUib0C68wNTVk638OtyJbcxxmIw6ZCmRpIFlH9b8P
	 NQ4gUv4OiN7lC3j/tp854fUUpZqXVq2aee+OgMkC9dLM7xM9uJ6KhxlmEPh4WGX3pQ
	 aMaFXQlzENRj9+O5futEOWTZzHDWRzHnFXGfVxMc4X+JZv1mM70waslwOB3VQG9Mm7
	 L7rMFQQFYFgzKEUEicSaKpEKeOOtq7HL07MVznfqosRDrua1K0jWXr5MRrsrQc7ufy
	 n0jCzCczmCt4g==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 00:30:01 +0200
Subject: [PATCH v2 06/23] binfmt_misc: turn the entry bit numbers into a
 proper enum
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v2-6-2a1c3d4126a7@kernel.org>
References: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=3324; i=brauner@kernel.org;
 h=from:subject:message-id; bh=z9QHeXcMB2NP6cxIN0CnxHAFiQBh0+c9XtYMXdoWbAc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQFKHydXqOVJjcpw7O28pyvsvQC9cvyrDxplqYv+N6Eq
 vie2FzWUcrCIMbFICumyOLQbhIut5ynYrNRpgbMHFYmkCEMXJwCMBHpakaG58oefqs03fUv/Uz7
 23je9vT7jfa5W/rshasvztn9tb/dluGvcHjLObFTcVcn+u1Za8tqmfy053DL1obDl7mfrb2y6tw
 xJgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 70803C0011
X-Stat-Signature: c7oe3fz9gs3bxmsacxhejpk4qnrtka5w
X-HE-Tag: 1783636228-625882
X-HE-Meta: U2FsdGVkX19ipYd31ZIQ959FbGBqdWswQugOmSP/fA9Ry3q8tz53d0nFvTua+zVkN64qqwiL/NfoXTFOVOR8o0KRCKalmupUEWBJzIvhnsNMQaHPcW/xVwbGxcGzj5sHndU5wFq0tD+hrUDbltVlJ9/XTv1YVFXzRTnXOvob1/rPUahBkP7N6QNAns9l64s5onIWBvMyTfygCnKBAjz3tXCh7uOrLnd1YwSjA80YDHHOukOQ/m1qFR48Nb327nwHFEd/2chedK0A9Tncm+fcWILbNhYALoiSz1LqbOrpJqWgpsYGIomQOYMD1lO5R+AGJextKxtt4GtPeXQ3zsDDHKSw6fnMwlqDEDFWmDGVp3tZo2wq1qM4DlHqAVTPIy7qWg02JJM9MtF4/YraetKhSs/sIhLx6Q/QwTnS+AZTm8v772WYJQvy8nk26rhDYFofBIlr/I8R4wzS/9spINY3vO9I1/dfiEZxQ7JqqtSqNDlLKAm0UOZDAbcqNBbDGmaPaGPbaQejcfya2ZcsoU2MtPS8XC0DVwoKAN02KPi3/96pjIQaeyJ/648MgcTFdAKuLTLh30dwX20EYDWdgv22rZet2E7u6b7BIR43oALSk8HeFcJFoVMTLYakctnAEJtgeIpYBHiLlpr4XFhJvb4vA9PCEXeB7xBXXw7l9y6YyTtWLM0/GQKNZfoLpQfgO9wLyoPo/zbB/gE5TGoZrOEMJUSrHbP3nsiMhAkDSGwcjs50/wEFq618X7Khfhmnxn4OOMyB1eHk7NnXADGDHXEubhOiEirEnE8nfk5raKf3lf8kKsYBY1I4B9RDcqD7n/NkHFIqkAoBNxjenSA27UlgR789IIG+IG4PCGiXYpqOxlh4FjBtP9NIrJT7i+2C2x6ENQeM6SC2vgOIm1V5otVQI/MKAUAby2hJ6pJF2xEBTXQKKqK52PXRxRUGClfHuP59ocnRi2kDMgQwLWp4Ld6
 Q/zz1szg
 TPrKw+uiNlDNqB48PQHTXfy1GYqzUEqsxKGXQz5X+ga51DvYlCHvQ8Rte7jWC41sB0GZmHM5UeIaDNPCCMmRrqXTfudFIglInoAP0YwXwsvrrJI4ZQOVz9ObOlZ2kD4a+ZhBguNKE16FBZlhN8aGsQpvTvoy4vydFyxi3jDQbU94SqXeENcEHyFo323WZLpDWTVTKj/gy5KAuS6lLoMZe2IBp7asStmRDjDgnJ+hBcrwpswxn0PKxp2h9yLzIn30aON93IFgN/+Mv3DI2r01d5KglozFxHhiHu9dfcvuYG46xYVV7af7RivguZzi+D3ix/f2cifiRGoFUczML3/HIp/z4XXJzFeVd+F7UFERTCd3+ABE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enabled and Magic are bit numbers in the flags word of an entry but
are declared as bare, unprefixed enumerators with implicit values in
a style that predates the git history. Give the enum a name, explicit
bit numbers and namespaced names and use BIT() instead of open-coding
the shifts when building the initial flags word in create_entry().

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 2a9025627f6b..f1ad0bce5af1 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -42,7 +42,11 @@ enum {
 	VERBOSE_STATUS = 1 /* make it zero to save 400 bytes kernel memory */
 };
 
-enum {Enabled, Magic};
+/* Entry status and match type bit numbers. */
+enum binfmt_misc_entry_bits {
+	MISC_FMT_ENABLED_BIT	= 0,
+	MISC_FMT_MAGIC_BIT	= 1,
+};
 #define MISC_FMT_PRESERVE_ARGV0 (1UL << 31)
 #define MISC_FMT_OPEN_BINARY (1UL << 30)
 #define MISC_FMT_CREDENTIALS (1UL << 29)
@@ -104,11 +108,11 @@ static Node *search_binfmt_handler(struct binfmt_misc *misc,
 		int j;
 
 		/* Make sure this one is currently enabled. */
-		if (!test_bit(Enabled, &e->flags))
+		if (!test_bit(MISC_FMT_ENABLED_BIT, &e->flags))
 			continue;
 
 		/* Do matching based on extension if applicable. */
-		if (!test_bit(Magic, &e->flags)) {
+		if (!test_bit(MISC_FMT_MAGIC_BIT, &e->flags)) {
 			if (p && !strcmp(e->magic, p + 1))
 				return e;
 			continue;
@@ -413,11 +417,11 @@ static Node *create_entry(const char __user *buffer, size_t count)
 	switch (*p++) {
 	case 'E':
 		pr_debug("register: type: E (extension)\n");
-		e->flags = 1 << Enabled;
+		e->flags = BIT(MISC_FMT_ENABLED_BIT);
 		break;
 	case 'M':
 		pr_debug("register: type: M (magic)\n");
-		e->flags = (1 << Enabled) | (1 << Magic);
+		e->flags = BIT(MISC_FMT_ENABLED_BIT) | BIT(MISC_FMT_MAGIC_BIT);
 		break;
 	default:
 		goto einval;
@@ -425,7 +429,7 @@ static Node *create_entry(const char __user *buffer, size_t count)
 	if (*p++ != del)
 		goto einval;
 
-	if (test_bit(Magic, &e->flags)) {
+	if (test_bit(MISC_FMT_MAGIC_BIT, &e->flags)) {
 		/* Handle the 'M' (magic) format. */
 		char *s;
 
@@ -595,7 +599,7 @@ static void entry_status(Node *e, char *page)
 	char *dp = page;
 	const char *status = "disabled";
 
-	if (test_bit(Enabled, &e->flags))
+	if (test_bit(MISC_FMT_ENABLED_BIT, &e->flags))
 		status = "enabled";
 
 	if (!VERBOSE_STATUS) {
@@ -617,7 +621,7 @@ static void entry_status(Node *e, char *page)
 		*dp++ = 'F';
 	*dp++ = '\n';
 
-	if (!test_bit(Magic, &e->flags)) {
+	if (!test_bit(MISC_FMT_MAGIC_BIT, &e->flags)) {
 		sprintf(dp, "extension .%s\n", e->magic);
 	} else {
 		dp += sprintf(dp, "offset %i\nmagic ", e->offset);
@@ -741,11 +745,11 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
 	switch (res) {
 	case 1:
 		/* Disable this handler. */
-		clear_bit(Enabled, &e->flags);
+		clear_bit(MISC_FMT_ENABLED_BIT, &e->flags);
 		break;
 	case 2:
 		/* Enable this handler. */
-		set_bit(Enabled, &e->flags);
+		set_bit(MISC_FMT_ENABLED_BIT, &e->flags);
 		break;
 	case 3:
 		/* Delete this handler. */

-- 
2.53.0


