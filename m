Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E92EDC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 22:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 571286B00A3; Thu,  9 Jul 2026 18:30:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5222F6B00A4; Thu,  9 Jul 2026 18:30:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 438A56B00A5; Thu,  9 Jul 2026 18:30:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 165636B00A3
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:30:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8FD7E8D266
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:44 +0000 (UTC)
X-FDA: 84970684008.11.FE9180D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id CAF014000B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yd6LeHX0;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783636242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jgzToBoPZaXqJhNllZ9VkvzOxa1lyDvo+VurACpkb3Q=;
	b=U0Yo+5s9EqE2g2v9mGkBUoDFmaqv/iNCRfAFpfnp21jJLaPCH/7HDv3yxfisXZ3oWiz81b
	qLZWLwcYSA88qL2Jfz+871eV8hNeG/LXvFPZQaHRYksIdsMyl2oeWDqhMexoCDmXa8Aqli
	fHcTb8o7LnQx7DIdjnotJojhLGjpUI8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yd6LeHX0;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783636242;
	b=zJFmy25DpngN7SRXlc7/eEJ8pJsJWylK3tXjfPBawsBintiD/UaJGaqIGPEmCaM/gru8GJ
	3fSNi3oq/1lD1ZPsE2Tm9OQe9O6yvAYkQPImcJz7TZNiFjPxMEG+V/AnnVN3Y1R7Y6ckcw
	z7tnW5yHZRY0A3pntlUvwkczqDxzaCk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6705061386;
	Thu,  9 Jul 2026 22:30:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCAE1F000E9;
	Thu,  9 Jul 2026 22:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783636242;
	bh=jgzToBoPZaXqJhNllZ9VkvzOxa1lyDvo+VurACpkb3Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Yd6LeHX0jPgCcKMENu30+sU2n4fUJ1wU+eM82qp6c019puPvfz5BXgkvMGsoM5/AS
	 sIsUzpKHRTHrz3w1rYcHR9FidpjSnSaxg58cTfJTu/yrzEv8Pydm5pNaGxpWySdaZY
	 fZBBxVHboNV4ndcDm27cts53a5efPC0fQpQY1sbUGXPZbSH14GhOXhP0WTQjBy0TXV
	 JHU2ySIFAzCtRnzS7u7COq0Z6pwwwRMNrQW6AHgY4QzydNXCPPA470q4EGBClqQfsP
	 JDbx5imoxzJH7W6mUvItE+U1SZoZ3kqIJyupBbdNKU+Quj01WTSFJLvLUxyRpuDq47
	 MFb6A3i5NvhYw==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 00:30:08 +0200
Subject: [PATCH v2 13/23] binfmt_misc: rename load_binfmt_misc() to
 current_binfmt_misc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v2-13-2a1c3d4126a7@kernel.org>
References: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2970; i=brauner@kernel.org;
 h=from:subject:message-id; bh=9YI8MB6akQ7CLJBcwsZXPOfDGbuySHjheLxFOPALTM8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQFKHxdFuS2rsfqStAS7jMVFhdbjutKHpbU0Foe7lN5W
 /cS576GjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIn8esnwV+5Llvm7ozPjtCKi
 nC/r5Nk+C+1etqd9t9L7SxMUi5K4TzL8M+QwX/g/3OqUxOvMvJdqcn/Ku4s/TVe3z52y44tE9p9
 CLgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CAF014000B
X-Stat-Signature: 4gr1689z8sqtdkxbgkprmrjdy3koxrmj
X-HE-Tag: 1783636242-757735
X-HE-Meta: U2FsdGVkX1+9C+9xtuN3QwbeGdTpMe87xogkuFwiuf2R2t1i37S1Ji23r/sYnRAelTcpodQrhgh6zl0hE2XSpMfKm9yxBl4z/h8DCatbj6U80yQZ6qlurdu0x2NHszEQPeYqTde53x4dxnt619n5s/Q52TKAY2zYnhZ3pir8uiyFtnRiqB6Y2MulhPQDTX60iJkxiSOgelCZIFZBrgfwXkGVap76FztLIUXVzOSAoS65+mhhoC6eV/z+kpE0Ll6mmaIgy9UZqIim5DWx7waa5daJZA05YBlQQhgGbzF4erYlrYmTGVC38t4IjaXWpKvohCpu2hWBdbh9UEVrH89TCMIsZdPy+OsSE69wqyfZ4q9ax45x5qazBW9oHX3ebRWLUgjq73Fo6bmp0VJ7I2oMLDnSe8dWwH03Yt76+tY2Bg7eACetSCAPlvSUrznoRGY8Ttmp3gn71NorsqOeZb2lPSZgObxMYz7qahXBNuZm6u3ZvXEYEYp2kx02IyZulVO/CXhfvOUrCqxedLEPDlFtgL5elOm4p9vKZqVJfcbacWy8XpCOj7SLoFTX+6Twu3gqgAzQ9IqwIq4e4xvsxiQ37nJB+Qo+tsEjuDjQQA/g8IaA+S68PTuXTPWVQVmSNYRSCWP8T2/r9rLVMd63WB36FTj4Mm0f1yOhXpjsmmrRbEIuVipfcGTr13d61g3oqfSIF5DcHqDYtIFLAq/MwM0P/ap1M6kJwHSROLS0RltgvXXQuwSXpAp/w06CURg2DQuAEh2zjyS86gQhDt/Ev0rpFHys0OZzYy7adWbalicu4jlI8IlEUCBjRWvaZRx2ronKJq4ISGdsLqGKvuxoxJH1hc1wKPkU9fpTFiwCaRLPuU9rv7BvWlxat1oi8Vvie6jo1iicMEqycK0s45S8vt8a5QhXeX/zPkMH0lYxeCjbaReFlD6CuZpJogQlo793qfycajwA3w+L5XrHflFSIvh
 uiqyXHOk
 II+8/xtIVZpj12MTjWTUdjaNL18RADo6wxvbc/cT+7Kq1rrhr6OatufOg0tvZM+qQriMD1ntGcOvssAvWrbMGprVTMq0MhmskFnFaFD7Rql3uudPzS8XjZJJlm2D0RLSZLlORcA537Jt0jTEn5ymd/FA4fspAqikAJTwU/BnBAZMqBt2GZPCfs1B8GCvcfQIEErPtOh6rNxbSPEH7rNCndVSc3i5JOYHyyEJ1VMO2aeeEDHyzVLlFivZHJV9XyB6+b3P1/HBBewyWAJLVMx5eTYXQT1/pnp0rBlq4jxgOzJ0C1zBJzj05e0z0wqLmiibmEndAF8mynX+OeYRAbggXd3FnkT/+xKN8Z6qlBp64ZNKaxX4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

load_binfmt_misc() is one word swap away from load_misc_binary(),
the binfmt loader it serves. It doesn't load anything, it looks up
the binfmt_misc instance of the caller's user namespace, so name it
after what it returns in the style of current_user_ns() and friends.
Tighten the parent walk into a for loop and fix the stale wording
and typos in the kernel-doc while at it.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 688554caef3a..ac2276eeff4e 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -184,29 +184,27 @@ static void put_binfmt_handler(struct binfmt_misc_entry *e)
 }
 
 /**
- * load_binfmt_misc - load the binfmt_misc of the caller's user namespace
+ * current_binfmt_misc - get the binfmt_misc instance of the caller's user namespace
  *
- * To be called in load_misc_binary() to load the relevant struct binfmt_misc.
- * If a user namespace doesn't have its own binfmt_misc mount it can make use
- * of its ancestor's binfmt_misc handlers. This mimicks the behavior of
- * pre-namespaced binfmt_misc where all registered binfmt_misc handlers where
- * available to all user and user namespaces on the system.
+ * If a user namespace doesn't have its own binfmt_misc mount it uses the
+ * handlers of its closest ancestor with one. This mimics the behavior of
+ * pre-namespaced binfmt_misc where all registered handlers were available
+ * to all users and user namespaces on the system. The init user namespace
+ * instance is statically set up so the fallback is never reached in
+ * practice.
  *
  * Return: the binfmt_misc instance of the caller's user namespace
  */
-static struct binfmt_misc *load_binfmt_misc(void)
+static struct binfmt_misc *current_binfmt_misc(void)
 {
 	const struct user_namespace *user_ns;
 	struct binfmt_misc *misc;
 
-	user_ns = current_user_ns();
-	while (user_ns) {
+	for (user_ns = current_user_ns(); user_ns; user_ns = user_ns->parent) {
 		/* Pairs with smp_store_release() in bm_fill_super(). */
 		misc = smp_load_acquire(&user_ns->binfmt_misc);
 		if (misc)
 			return misc;
-
-		user_ns = user_ns->parent;
 	}
 
 	return &init_binfmt_misc;
@@ -222,7 +220,7 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	int retval = -ENOEXEC;
 	struct binfmt_misc *misc;
 
-	misc = load_binfmt_misc();
+	misc = current_binfmt_misc();
 	if (!READ_ONCE(misc->enabled))
 		return retval;
 
@@ -979,7 +977,7 @@ static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
 		INIT_HLIST_HEAD(&misc->entries);
 		spin_lock_init(&misc->entries_lock);
 
-		/* Pairs with smp_load_acquire() in load_binfmt_misc(). */
+		/* Pairs with smp_load_acquire() in current_binfmt_misc(). */
 		smp_store_release(&user_ns->binfmt_misc, misc);
 	}
 

-- 
2.53.0


