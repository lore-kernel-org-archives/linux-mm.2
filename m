Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C86BC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 09:33:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0723D6B009F; Fri, 10 Jul 2026 05:33:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04AA76B00A0; Fri, 10 Jul 2026 05:33:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E554F6B00A1; Fri, 10 Jul 2026 05:33:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BC0F56B009F
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:33:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4326FA03BC
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:37 +0000 (UTC)
X-FDA: 84972354474.17.473DA31
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id A316C80005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WrEvJv4d;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783676015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m89br04tyLYQ4I/MwspJogYMJTjB4GK+VbNn92eUW0o=;
	b=dIVeVfYL6nfCfV1F7jJvlZYTDdUMWKBr3DpKVEgsuz7Cgs23/Rj1SyIyUfav0HSOv0RSkD
	+QnucE8nfL7tPIrYIQgjIIDtFNaeTTQH/XCJoT7T/dUa+iimqG6d6v3H/Dmvl1FvTwrVUf
	dnx4d4Dt6/HviwBG8rejT8gnBgGjevk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783676015;
	b=FTmJuZGhjwaPmPGxHsaYl5aeBgithKWJ/Vy28iJ73Bf9mlHmCPma93wKWd5QUzJ/W9Jj6/
	Okx/YKRI6utVkilOOwUm4iSe8eNpBQdRVjEqW3sfIZ5wFoN/Adg5Vr5FhrR04T+KfwtfkQ
	hTpuwtJczqYO/ATqXsRH9T1XyayWxgI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WrEvJv4d;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 43CC060EEF;
	Fri, 10 Jul 2026 09:33:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973441F00A3F;
	Fri, 10 Jul 2026 09:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783676015;
	bh=m89br04tyLYQ4I/MwspJogYMJTjB4GK+VbNn92eUW0o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WrEvJv4dawq0XTUD22FYy4GaQKuvTC/DFfO/ZywhSl3RTMbyy28JLhjxg6Pb5zE83
	 qVJqZAkPeTM8ykGx6C+ZXOh/cZ/a47HSJ+K6A3cYEJsZH3UkU6GhyhDSE0yvBY+Px/
	 F8MOCEkRaSrrlE+REf2yqCvlP9EHL/KRFUiQiqONr6EL/ZS0dlEMEaPOiYUQnLm4Q/
	 n0/PAsn/eqjPVnCAv9T8tn5P4YutxcN7E//zAOCHAUoiRx30wEBdLXwv3EtCuFDaQ5
	 LrqQ5rQEVjaz5JvuziSnC1EBUhjzmCaFbpAeLw4EvdAQnXu9bu0i2IPUzJnMLsEiV+
	 9ypru71iVq12A==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 11:33:08 +0200
Subject: [PATCH v3 07/24] binfmt_misc: turn the entry bit numbers into a
 proper enum
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v3-7-a162f7cb58d6@kernel.org>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=3324; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Dcrt+QSqAlata86DaTvTin1H3ls8seBaxje2cS4eFWk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQF7Inr3zDlkv6eQD65A41Bq/TyjwmbnduQbHHFd4P1M
 vEky85ZHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABNZ/YWR4VO6zg4H4Y83jp+9
 e2XB4i+/mXX3TbaZVXzIcLb4+7CFkWqMDM9/fzydvY6r0+TfkgkezFV93WZXM8vuWB1Y/v+hYTz
 fTSYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A316C80005
X-Stat-Signature: ub7eqta8snwogh14adxtg4us3pxnxbgn
X-HE-Tag: 1783676015-403160
X-HE-Meta: U2FsdGVkX1+m3igU4HMM7lbkFq/6G3Z5icD/an4Ydhg9kNxQ00SWXoCK/e8GArWygB1i6b4b9cRW43W0tQMe5BfF5BzfbGw2et5faUljlBXg9y+BfpIPTqZSzdkn1SRyIry5huO62p7Z5hULOjEFQl2/DdEblZBBxfShkj4v+PmyB4MCOj/iwU7oCwBxlPMxAuWgAAvIKaRQV9JuKPRpD4NaLjOWZixixLzxgUOEJB55v9oZfOYPnL5QVvllJD1xEFRO5umXkn0r+Ntey5o9zID4yCgUaPMkm9dPFefymfmzL6l5bh0CYlOb8FzXP1Ndi+m7Vv5HPZEOHqxO9fBQg2V8zk2pzP9cm6WH3svxmzyT0NwRcI2+7anuPrjZJzJ1nkYMqhzsF7K3XLpChYT2PQy1M/ME0YzFo1UQoCjgafLODmW7GjPy+hbInRE8Isf6tlq+BiW6ADmTohtyi69cp0z7rxbonXTZt8f0in8GxZ1AtTOcE3i8Fum3mSXsKkxf46IbGLhAMGQmml9GYHyZaPwPTyqFQ5fLuYYEXY7o6nx5UdcSjdwmiJ61YdhEv4uSHrioqoP3nT+21lPiRjWV9VgEdUHM8sFsMZkRUQw3mTvuV33sc1Qa8yjGPmyCWbxJ/4XmAuIonFlSPdRYrKSRd1gdYqAc//TFXADBWX/SeLMIW9ic2BxqAyeUmwet0do0qiwJXVaiMbPWRw1YyKNzDgvUKpcn3hVQOVJ/iqdJdtVMoZEygW7tq4IsBXm7ogaYYgRJSEx2nZjV6T7JEljEJqscpnys+iOYuD2Xa+bf4UqDtlh3W1jxO3OQ6jL1dlhHsHESWO3bEOI8CrepGWk0d5BnZKD/W9MxU4j+p7R7sw+q1AbInv/m5Zrwxdo0nrSA+c6is94Da8RCvtnkzvQQC8NTp0Rp/MPJ5O9hOiUjFqMJCMEUIjqH6Uqou+7ueOLw5zsQ0KRg5y520td3J0c
 9nbd8haZ
 lW86vMI71V7qd4l/gjKewPyCcbKJI5CF8zMjxFhU7IxenlntQDyxlt9YODJeAs80nl1L/N8Nvlb8FEip1hmI+7DN5cU7aggpcIy4KAwL08XoL6sCWr3sbR1PkiQ7Je80UIEOj+IJGHPLd29CbvyTABiWfsxp23RmiWnoUpOLDzIcCFg1rQIrDoGBbL3+5hJl9uwsWm3p8sGm0cHIlZ7jyeA/6TQEMR2B8vhDG3k4UxiKPRBLdH2bL8zrnkrhAczI4L8lBZzUPM9yNH/MsHvYYI4ZfHaguRbvaUuA0HyOfGnjFuxaoZ0IF+1BKdricZubpIYJHp2IqVHKqSbX/XhNZfH6ttrK1JfkhH0b6ISns2IDy6Zw=
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
index 0b9758da1f88..90962044d19e 100644
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
@@ -417,11 +421,11 @@ static Node *create_entry(const char __user *buffer, size_t count)
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
@@ -429,7 +433,7 @@ static Node *create_entry(const char __user *buffer, size_t count)
 	if (*p++ != del)
 		goto einval;
 
-	if (test_bit(Magic, &e->flags)) {
+	if (test_bit(MISC_FMT_MAGIC_BIT, &e->flags)) {
 		/* Handle the 'M' (magic) format. */
 		char *s;
 
@@ -599,7 +603,7 @@ static void entry_status(Node *e, char *page)
 	char *dp = page;
 	const char *status = "disabled";
 
-	if (test_bit(Enabled, &e->flags))
+	if (test_bit(MISC_FMT_ENABLED_BIT, &e->flags))
 		status = "enabled";
 
 	if (!VERBOSE_STATUS) {
@@ -621,7 +625,7 @@ static void entry_status(Node *e, char *page)
 		*dp++ = 'F';
 	*dp++ = '\n';
 
-	if (!test_bit(Magic, &e->flags)) {
+	if (!test_bit(MISC_FMT_MAGIC_BIT, &e->flags)) {
 		sprintf(dp, "extension .%s\n", e->magic);
 	} else {
 		dp += sprintf(dp, "offset %i\nmagic ", e->offset);
@@ -745,11 +749,11 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
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


