Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFC09C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 09:34:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A36EA6B00C1; Fri, 10 Jul 2026 05:34:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C2476B00C2; Fri, 10 Jul 2026 05:34:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 813636B00C3; Fri, 10 Jul 2026 05:34:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DBB36B00C1
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:34:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EFD651C8994
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:34:03 +0000 (UTC)
X-FDA: 84972355566.21.C8F38F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 407EF80004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:34:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hdWPBX/o";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783676042;
	b=mqqpWAuz+UnV2sGL2IO2NAk87HasH6VY43UvRFdZvV0d6oC73ZgwOuNG9vnzht69qmgRMu
	NIPipM8/7UhmZqUv1jpfbFFXwa75dwcTMGRbB+GnXlDyvcjXifXzQ96vubzdioAxcerSxz
	1x+kA7qdIw1u85xqu/o1TmdUcnVCFx8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hdWPBX/o";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783676042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k0J29d76T8nB5uSo88Mi8R4t30MRslE8/ZOmMKaFA9I=;
	b=YUtYuArIbpBL3cExEpJkXGQlTMmmSv+M3oKVq76JePkyHk9l+AM9zNFC09z5cL9uyxT5l+
	JQJhiGJTRq/urNharAT41MQ5vnVZQbLsN0W7STzFVvoznp3/Z2e+LJf3oSfkDG6qMUdsfL
	QNoskB6pHhBGilbdpKV31BaP32bRf+o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 92D76435C0;
	Fri, 10 Jul 2026 09:34:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA1D1F00A3A;
	Fri, 10 Jul 2026 09:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783676041;
	bh=k0J29d76T8nB5uSo88Mi8R4t30MRslE8/ZOmMKaFA9I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hdWPBX/oyNii0u9yP2GneFTkJ7IFuhUtxEjPB84ocWT9O3FqOR9uyMcx0PDgNbW9e
	 EI0No67nvK3AuDP4wkUMWkUb9jRceORpCNiyPqTJkLYmiA00yXBxz6UA35d57ys15a
	 Uj3jCiFRTabN8zBAJ1a7A/9V4qAP2YhPv5EJU21lOP9ALxFOVXwHaYFHfZLRRxEyIW
	 vesXsCTk+bOsOKFfGZ9igGmIjEUNwRdd72Ocpsk6waS7SrHXY98FZcgqOwPpWg35zU
	 ygFWMqdAe22JBfdEMQexLHvba77jpbYSKyTD5iGeKrWXONEKoBQ1MbLvZaW6Mqq557
	 wo2bm9/NKjwUQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 11:33:22 +0200
Subject: [PATCH v3 21/24] binfmt_misc: use __free(kfree) in
 bm_register_write()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v3-21-a162f7cb58d6@kernel.org>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1851; i=brauner@kernel.org;
 h=from:subject:message-id; bh=V2ZwUb4Psjj4W9n/i3kdwmyYBsECNeStUAKv3jHoz/4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQF7Il/PqOC/TjTxdtJUxb/Tlz07O9KVsm4dZMX878s0
 1flP8vA31HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRBRKMDGvZpQ/difKLPDvh
 e6DClgbBtn+x355MDX83XX15gOL6FdsZ/vC3XXg4kcdjS2n747ANpklTDu7gC4r98ypTavr64vt
 3l7EAAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 407EF80004
X-Rspam-User: 
X-Stat-Signature: y53dcg3ddirue7a6mj5fj5geam1g9u9k
X-Rspamd-Server: rspam03
X-HE-Tag: 1783676042-824933
X-HE-Meta: U2FsdGVkX19yl10bONrVunl402OeNt0+jLZg6UiXTZKkZJBbv5Qd1ox2pQ0gvj46tiTsnzAW8VnN1+IVKuN+euKHOgcqLQ/HBG1mduAGYxAWWPiYx42+v6oClfz1kdJhCw5wIw+aifxLcNkM5vOZHBHM1hoEoMrnniUP/4kLhOmBDwq969Y4UJMD6R6kx1XzruTPOP0+SdtGeWV2Z7xDSVJWukD9+5Fw5IZrGeJOu0a4Yt5lIx7hM60dSp6bTLcTBxf8F1ub28xt4TcFISfXO0tBSzEz7mMRKuc7Jqh0F2E1FiBkX/JASlM3o5RuE5MZ3quUTrSCcuCyYLpP9L1kJFxDTt1MA85MlwtRxEDpBdKG+DFzu6QNS67SXVnHlRK2BAkM5b0La+czFkD+V6o7mokOqneIdfm5DYV0DjDJnWB3guhkaKEBLVRQn5L+ExxpzJCqrX9La7f5FvA3I8cNrtcMJOg6VLHhZvaMyclKC7oLpab7qsKKiF5zT+9fM1Wj3K2Y1tikJeCWRrQcYXGQSzWTYrL02xah/NZU6V7QoFEcNFxfMM9e66L523E0tYlsuTN1Q1JWsxBnR8mUYlrjwlG7RMHPztYdtnET/THDwz1xzxPjI4hwoNavkc70Yh4zxE86STP80AuqKb1jYIj0xOvY9DpS8W1nS8L06/wgtfpswk9ZrN7Zle45GTZdfnWsj1ziAdhtvoI6IheHIz8+KA+8nCvRPaMf2xGkVsgueY19pAZ2aVf6HAvQxAI2WjTyetgD3l4w+X6Y5O2PkNjhMOj+v7MQszATTe1xS8N844FuIE4LFH23E8g79hYp2J8/iiLx59CrmZuCEB5qoGLbT6U1TKJNVV5/sIsp8h4HfEqOrpIwr4/WmMK8815dwbbUtq6nrVl7e2gKowLVfMe4C2dWvWB1NVHCWbp80WUX8ec1YhrY9LRBMI1iFCaMKObGK5ik2hb52FNQm22TdaZ
 sy9sZqXR
 YiXEBLKBRjY44zO2QrYckYfh+O96/C+1RRL90cOct2tmPbMIQHmZdTjgvNUK3jOFidpJYetFBYVuH9oV/GBoZUedqi6occ/bG61vHuESVx3TZw+Z3MuFeTzdHn2bNz075bh2kisQAv952h1xUYXcCwvxuaCF1MapQejvw/4T3cFXJyc9EU1mO0NQQPtMYiFExJbx0/JvMZuS1hX152+Lb8jO0/4Chqy7UOzh6yN8Ea8PVVAKh7Opx2eqjBpx1nY/AMtkUhc3G0lMHTMg4ssiTzayi+bVd3ULEseGq83WBB/FZ28YiAoX+h06LZP6bgG/pEemF3zBfBpTe3bzno3JSOlNaQJb6r/Fscv7YJjv5oI8WpOZIs7qcKQ9jUeznYEE7QW8Jqb32NZecc6c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

bm_register_write() has to free the entry it got from create_entry()
on every failure until add_entry() has linked it into the filesystem
and made the inode its owner. Arm the entry with __free(kfree) so the
error branches can simply return and disarm it via
retain_and_null_ptr() once ownership has been handed to the inode.
The interpreter file keeps its manual error cleanup as freeing the
entry would not close it.

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index a9e1e0bbcc60..eb56aa6a3ca2 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -800,13 +800,12 @@ static int add_entry(struct binfmt_misc_entry *e, struct super_block *sb)
 static ssize_t bm_register_write(struct file *file, const char __user *buffer,
 			       size_t count, loff_t *ppos)
 {
-	struct binfmt_misc_entry *e;
+	struct binfmt_misc_entry *e __free(kfree) = NULL;
 	struct super_block *sb = file_inode(file)->i_sb;
-	int err = 0;
 	struct file *f = NULL;
+	int err;
 
 	e = create_entry(buffer, count);
-
 	if (IS_ERR(e))
 		return PTR_ERR(e);
 
@@ -823,7 +822,6 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
 		if (IS_ERR(f)) {
 			pr_notice("register: failed to install interpreter file %s\n",
 				 e->interpreter);
-			kfree(e);
 			return PTR_ERR(f);
 		}
 		e->interp_file = f;
@@ -835,9 +833,11 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
 			exe_file_allow_write_access(f);
 			filp_close(f, NULL);
 		}
-		kfree(e);
 		return err;
 	}
+
+	/* The entry is owned by its inode now. */
+	retain_and_null_ptr(e);
 	return count;
 }
 

-- 
2.53.0


