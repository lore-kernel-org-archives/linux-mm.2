Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 852A1C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 09:33:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 750206B009E; Fri, 10 Jul 2026 05:33:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7277F6B009F; Fri, 10 Jul 2026 05:33:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A0446B00A0; Fri, 10 Jul 2026 05:33:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 316196B009E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:33:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AC13C169393
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:35 +0000 (UTC)
X-FDA: 84972354390.30.DC5C1F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id E983CC0004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RHUvkILI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783676014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XXSRrY10BTWWPTtPApZMsCLKyKaoPsSPVdND+noa2X0=;
	b=5pWLqiWyacY0d9Aqk7pJwZxuczUvvBMN9DF0zT23d91Gg1AwNXqsiGq7O90NczexKl+mNw
	f2MZ/7xpqwCGD/bRn5bQaNA7X2xOlWa2y4X/YkFRRwJhGJpTsU8ouVJ5hA7/UHPdqQ6oii
	qun6bWiNx0MsBpIvV+Bt8g2BTLu+BRI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RHUvkILI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783676014;
	b=r2MNtfnuODofnQiDrCUyHFW/Q/6k1s2vNsmLwSpPk5WHr3ouZ13c4+g0gm74R/tZBUgf9m
	hC4uLV8xcoBHsGo5PtWewQLfxx5EMqbDrCWAShOuVaeZHBj6KtVQ3CQ8DogLKzQ9S1+Ii6
	6U2AYcBV/3gSfUDlZT6Y9LzhNPYU1hg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 474D643A10;
	Fri, 10 Jul 2026 09:33:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32991F000E9;
	Fri, 10 Jul 2026 09:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783676013;
	bh=XXSRrY10BTWWPTtPApZMsCLKyKaoPsSPVdND+noa2X0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RHUvkILIimAD00TXQtkOHsCfX6EzzGvIr5/UnqBBfrZy2J2sQG3wyAdlE4qeHy6RV
	 9Nspx5EjRwkCSl0MzQzobHoVu2/YFohqhiiBkzTaTt7LZkdXPeyfyn0+fTZBiMqYcp
	 o4tlpvm92DX5uYuqaxaJ9gn+OtuSKhO3n4JoymrU/dpVXjPdu7NbSIkr9aV/H1RlVR
	 WXJCZUWSBJ96I6zOGA1KQBU0EiiDkAXQw3bkErYZfj9CXk6teUFyC33/FYH7B/oNKb
	 pDb+46QVgx6G+5uHBouvlNNPFh0KzwysQxJOqc70YKTQCF8dZj/eFjzWw0AH0c50hd
	 pFPG6Uvt+vSTw==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 11:33:07 +0200
Subject: [PATCH v3 06/24] binfmt_misc: annotate racy accesses to ->enabled
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v3-6-a162f7cb58d6@kernel.org>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1991; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ElK+yid1mO76xrksl5KOw97v5Pu0FLPrm8Gxu0pXJ8k=;
 b=kA0DAAoWkcYbwGV43KIByyZiAGpQvF7I9pE35k3wYvU8CAl5OQ9tSMLRCQINJ2fDN12qZb1D0
 Ih1BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmpQvF4ACgkQkcYbwGV43KIRIAEAm8Yl
 2XP4FmaYgZ87VnCLwf1CEuR7ODGiFx8zAYC3YxQBAPqAoXg9ntG0soCp1E5df1nGe3sYkVwSWWo
 sfd9T0JYO
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E983CC0004
X-Stat-Signature: wyue569xjswyikbo1hfqpeghq8iq9iu9
X-HE-Tag: 1783676013-275183
X-HE-Meta: U2FsdGVkX1/xqB0uOG3x6O9OwiBf3m/64LCBAuFm5kUADHke6/hR6tP4UE5NVWw4oRC3DnV/eJoltKcSmrL59unrxHW1tx+GSn2ECQP5QZA14oPEyyypO1z9ba9NkiQpVb/e+JsnkCHIDGIlUpA8N+lwOTz1HxuLPmbvKtK5i4ZhwY1gRamVuOmO/0sZEfZzLQWkKsQcK7zNpBfN748Yl8sgSBMEoxS3B5x+2/2BvKK67lEc/LSHC7E0pxuY3MV94BO3NUaCoAXWkFBSFUcxD9NMyb/8ggMAzszTyrPIPTzlgvaFlMvdkr1sv0uNboIfEf09OqIMm5VFdWvFxJxcisIFDHgDegXXIyyydmB8dJuaW905kHjrnh4sCMqAbYwCXN8+I1pDj6k86YETsV2wkBUj2w0fN2Drb0QecLkBiJv2D9vw/DtHzqyi5l2WcSqBIRbFzyF2qNCu16JL0Pa6dXZ6BN8mis626pO8UF3ud/evckkzuu67C4eH0Eu1OXYntjO1C9VQwBIo8Qf7c+nsgb7TKHLuk6ZltxZdjaVbiYWQTvMPQzXiEEdg2XEkBNMUlhjYp6ZaZOZdn2zI8hVx16wl1gO93vBbknTT4d/4KZAcq6hWM5+Ydu8ftT5RW0ITWk2bdrcdeqGqV3lj46Wwxg2bgXgDQUDlb6t4cg4haimw8Aqju+lUzRz04Q+U8LOSKd2MtDla/4iMxH6U5085eg8P4uXSboEOxZNdBFmoWTCt29GvJlX25nhg/ZabBs9PLguSDJyKCz6WMRZ5/Nq5qV4rnn5Y3jUsTlPevaG4CIIdpKPEUOdESzgdSC95KTyflfOOeniVXW4jjFb863oCXVz7gAflAMSCoc/U3xJlX1hnlWtWGxxSMrrsbNS1vr7Dr9Meuna6OjLzoowKTBKIQJRta6ftOM1XfZbTsCsWhgGWxgyqS+36lvcS63faVKdSVRvrjD+JwdyUyp756vr
 2H6F9sfK
 8oFsPr/TarubLnNq7vzwpLzcCDSgtCO1Vc0zFLUYZDHamb5upPxzO2ZmIc2WgX6hn5S94CVFCb5O1ya2NnVKMtlntpVB2SWh0F0l/LYupSI8CjGe1r863zZOXbhBOGVnUBBOrW5x5h+xl4AUJXLy7d0rvOm2BQDeoNz2m3pjT3Tb3/s6v8RY1/VFXlbyVymPfnlbzwXAxRvYhOFzXiDhHUtCFqcswcH9P1LyTlfpjkrcM6jq40DJBYlBCfdm9paPa869nZEjhzwV20AQIM0fjnBSkayUlL15fdheSul2XUlik70rwpqu8xTAa90dePURsZDxyc1d9uglqBqcGPLssUbdsybGQvYR5diXYmMYD5tNKG1k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

->enabled has always been read and written locklessly: every exec
reads it in load_misc_binary() while bm_status_write() or a concurrent
remount via bm_fill_super() may flip it. That is fine as it is an
independent boolean toggle but the accesses should be marked
accordingly for KCSAN. Annotate them with READ_ONCE()/WRITE_ONCE().

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index bd7790a1317b..0b9758da1f88 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -217,7 +217,7 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	struct binfmt_misc *misc;
 
 	misc = load_binfmt_misc();
-	if (!misc->enabled)
+	if (!READ_ONCE(misc->enabled))
 		return retval;
 
 	fmt = get_binfmt_handler(misc, bprm);
@@ -875,7 +875,7 @@ bm_status_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 	char *s;
 
 	misc = i_binfmt_misc(file_inode(file));
-	s = misc->enabled ? "enabled\n" : "disabled\n";
+	s = READ_ONCE(misc->enabled) ? "enabled\n" : "disabled\n";
 	return simple_read_from_buffer(buf, nbytes, ppos, s, strlen(s));
 }
 
@@ -892,11 +892,11 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
 	switch (res) {
 	case 1:
 		/* Disable all handlers. */
-		misc->enabled = false;
+		WRITE_ONCE(misc->enabled, false);
 		break;
 	case 2:
 		/* Enable all handlers. */
-		misc->enabled = true;
+		WRITE_ONCE(misc->enabled, true);
 		break;
 	case 3:
 		/* Delete all handlers. */
@@ -1007,7 +1007,7 @@ static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
 	 * someone mounts binfmt_misc for the first time or again we simply
 	 * reset ->enabled to true.
 	 */
-	misc->enabled = true;
+	WRITE_ONCE(misc->enabled, true);
 
 	err = simple_fill_super(sb, BINFMTFS_MAGIC, bm_files);
 	if (!err)

-- 
2.53.0


