Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92384C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 09:34:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 295E16B00AA; Fri, 10 Jul 2026 05:33:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26CCA6B00AB; Fri, 10 Jul 2026 05:33:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BF816B00AC; Fri, 10 Jul 2026 05:33:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D42C36B00AA
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:33:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 54F77C1D97
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:50 +0000 (UTC)
X-FDA: 84972355020.29.5F0D533
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id A41DC40003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sp+FwLAr;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783676028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HjV5VoEllouOqts4U3VTjiuzsvEpGH8U1hM8bDNPXKk=;
	b=3jnJz3VNVFNOF/RYVAgnfx5NdeJA343GosxWjtrPfX3FMhWGD3JyVYJU4Ayoj6URjSpBIc
	GHyF3kZ40+FFdC+GIrMsGmPqNcY84C3Fzzvy5a7HbPzImzqEIaA8ljXkrbRffcV4uem1EO
	Xeuwgmq5Cj5SxOlJLAc3dsADJ4fAKsw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sp+FwLAr;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783676028;
	b=Cl3up4ftioA1Z5jrBApBTVhCA9P2S0dS1gxnfeLjSh1xG4Q/5X+iFnnIZ7R908C8xMWTvy
	R+gBZmsDphN13JE+9S+ZUp0pRtV9pgK4wCSOzqMiBQiW4FLDxxG839V2vv4K4xTSCvYMXc
	06thHQKyElIX70Vx1g6oVVzacIQLyVo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3CAD760EEF;
	Fri, 10 Jul 2026 09:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6AF1F000E9;
	Fri, 10 Jul 2026 09:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783676028;
	bh=HjV5VoEllouOqts4U3VTjiuzsvEpGH8U1hM8bDNPXKk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Sp+FwLArWMmiP/gI0nr18E+ZEZ258B4LGnmLGFuCa9j+Z9pAhljpCLGqUrKPqNQrQ
	 6nOPPNQHvqXPQ8iYLGysVb8g0x7ZBeCWjSn3nhx/J75eLASjXhgkcvGeXoKAm8haZ0
	 mB4yIQk4MBD7PuvkKZOHnv9mq8tPP1FRRJUYF2mrVxiRqra+dokWqrwjH/PA5408mQ
	 tEY7nLDpmGVGIObSATOugwq52wuj0uPtIFwCBKuTGZ5FSA/czrfAF+YYJgEYwTKz43
	 vU19HNHEIJCOyoeLqy5aGPZRO44Mi5wFoVITvFaF2t3yr1lkOARgWTuy1D3xLDYRcn
	 GoVLEk5wnAkog==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 11:33:15 +0200
Subject: [PATCH v3 14/24] binfmt_misc: rename load_binfmt_misc() to
 current_binfmt_misc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v3-14-a162f7cb58d6@kernel.org>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2970; i=brauner@kernel.org;
 h=from:subject:message-id; bh=BT+3XnPAOqe+UbenBLQo9xtGqAk3t4eTUKJnpezq85I=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQF7ImL0qg+dWJZ0+vDU576vnn6L+q9QwFz2LbtG/OmB
 brYnvVd0lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRHQGMDO2yhW0vn7xz2+r+
 6cznaSEPjWP7QmQmSsUYnuhaX9+dZcHIsDr1b+5O42Tn23Wys16etF0ns0A8jf2UwZGV3OmtiSW
 rWAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: efpxum1bg7517zqu6g797pgsfbsrxcba
X-Rspamd-Queue-Id: A41DC40003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783676028-630586
X-HE-Meta: U2FsdGVkX1/+XQXUVVuNtt6f1VdlpSbZDko18y18YZp8gB58BDoL9WrgPWHg5YJ9FMZhIZFSLyS/lE1Jjabcd/q/lWMHCKrwOfiqz7gfsOdKPJwgFZu33ET3nh6czEPsf2i1/23HzcT68Ch6s/9yzdLeCHBVrRJbQYMI170yY2XLRKClhHiR3lJiJg+nTZPZLQByecV52yT5tBFSx9daJ1SMBDLHgg5veGKvJzlxpBPdCuTvtRfSmAOCklCFQvEz+UIuYm5g92TIsji326sVO4PgR9RAGLHCtzj2MR5iLhpXZ5DxcPnhB1UTuKyYI10J56tOHHZyMlog+hVzNMDOTsGzRWXp7KHmU3gWOI2VZ+d9asEIsXhejmxZbuJxm5lJihgD0AWA7N5U7zt6p8enuOZEI+zPLrdDfTmCNDRNQLiKQmx3c7UktOJZzHUW+D1UCCK4vM4/7Bqt1IRdHGgJI+SyNtc6GN+gvbEJzFGPeFIdUiidRk0SjKI5VZeX5yvC7+1KoCb9himQvOlLeOOIJ/JQoAALqwFw7voneG5rg2MjhBHQY1NooK03glhB5WF6jWAmO77viFCHdlpX1JRlcj7DMdX3iJ67WyRLS3ONAPtiT0YoV8vuABAK9D7ZYGPM4PelBttVfS1gUYtoFJevZj6E0iMZH2DCZt90EeDDDBXqqfKlNJHIeKhsNA78foXYcZu/li9fU7i/7kCkVKHGIyh9TjJtxfVU1KG0J5vT3SmXFZN4zOOFl+qLBDQGcbSwARddTtQMsgyT1hkL33frm86l3WWGOv3GXFDFkb1KRoSZCE7N/ySqniIrKCbBHOR+I0niMwtA/oFLg4qslNL0uE49tIXQQtSE4cYq+SSg6NqBhOyeRFkNeW0LUuqV5Ku2EDJj7EGp/e+aHc4oNVgifIL+e5+eZfXeprG06EuvnLtoeMMJ3K+o+IdUyTZJY7qZcQra30xdHkoPDkr6Rjy
 Rqf7jwSX
 vGVYJ2HNRSH2Kgbsj43hdYayo7zrntsMnVRkVJW9tUNzo5u5sxSYuMEJVDcfuEgSchbWNjMDWZ8MmjM40fN+pk30ZiH2qdZXOHG5UzfBTu8iVsowyn5zvUhI9Kybj+bTfpNESqokNVioKsnK2aAAHDjpQLz/lzHlWggqpiC+unz409ycIlUlPnt7hs27bfny1ZPjevnw7RMR06o8SMZjdRJ1I+jwD+dM9gmMGJKNI+IKlbI6yUkI9Ec7EeQ/hp1/XhlYurp6/dJNQMBUl4bnqDupHC+nT0Gthw3SpwQiYIdQWnOWs8v6DaPRVIQ0cF5A8oX2MS3J1jTvl/bfho4/4av7Z5+ttjm8ZVBpNGdmutUHbZ90=
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
index 6a56f40f23ae..cd5dbf61771e 100644
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
 
@@ -983,7 +981,7 @@ static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
 		INIT_HLIST_HEAD(&misc->entries);
 		spin_lock_init(&misc->entries_lock);
 
-		/* Pairs with smp_load_acquire() in load_binfmt_misc(). */
+		/* Pairs with smp_load_acquire() in current_binfmt_misc(). */
 		smp_store_release(&user_ns->binfmt_misc, misc);
 	}
 

-- 
2.53.0


