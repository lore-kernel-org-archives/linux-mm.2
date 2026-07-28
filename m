Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7C5AC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 13:48:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B39176B007B; Tue, 28 Jul 2026 09:48:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC3A16B0088; Tue, 28 Jul 2026 09:48:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B1806B008C; Tue, 28 Jul 2026 09:48:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68A326B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:48:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EC71A1603E9
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:48:25 +0000 (UTC)
X-FDA: 85038314970.24.BB00A57
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 26DF416000C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:48:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LzSj2fnz;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785246504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=M13c9yrS8i19jL6P1wyYS28jNcW+SVKbY4SPV3JN170=;
	b=w5U6WOnQ7y96vWMAWpN/ULjqaHqlim1Lke79z8zV6XbQezKdPR/wUgC/ei578EX/Q95xUl
	8BZVo+M7tUAeh8H3NPkUiFB4oKj+onX8YjAGJ1YSbqIdk98uOjp0XKcqmLk68c/bn9fZqc
	ipRi5V67ZrsWlyx2WCVtWJLZpgpLxOw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LzSj2fnz;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785246504;
	b=ueH3YxqoZ2tN+wKxkBXmfiusrVQfnqR5WsExoceA4S4ze8ZOQ+8M9MS9zpJjBDr4Cti99J
	ekCWBIy1bSGTlV7HwAvRunC5SP5N8B+ievZdJ3+3+lBDlt6i+7ySAXoVGXVyjUI347Hlj8
	60/EWooaaBhtzBcq8/Q6TFqlS4TaZfo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 48BA84347E;
	Tue, 28 Jul 2026 13:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF851F000E9;
	Tue, 28 Jul 2026 13:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785246503;
	bh=M13c9yrS8i19jL6P1wyYS28jNcW+SVKbY4SPV3JN170=;
	h=From:Date:Subject:To:Cc;
	b=LzSj2fnzFxkDQEz0jAWTEyWdwJtEYTd+w6PpGK9wNAweCVLTU9kBuXBPTm6CFhePi
	 SdU6U98d4FV7WPFrgkswIAfexxvtPTuYw/uEXSQ1yeKRieh2ln0Osk1eRTA98LtnvX
	 JCaHRHIPqUG4MPJO6IUZVt9P9NnCLlvV37ldL1joUcAj2iu7XwNjCF+rK5qyVzJxu6
	 CRNJameCmxNuxLBnMxlw4Kh0p+5vqgAEHFzJYsL/TGLmv+BY4jve/L5d3b7/L/4Awu
	 lbDFiMlSpjFAKqAE5YtH01mk7uQmVPdt7v4gY9FR0X+vQ90tV+CiotyDVixQ1AqmqX
	 pwiUMRxgBhN9Q==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 28 Jul 2026 15:48:10 +0200
Subject: [PATCH] binfmt_misc: don't leak the user namespace when the mount
 fails
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-work-binfmt_misc-usernsleak-v1-1-dbd8d5e626e7@kernel.org>
X-B4-Tracking: v=1; b=H4sIABmzaGoC/yXM3Q6CMAyG4VshPbYGF8WfWyHGrLOTigyzApoQ7
 t1NDt+m3zODchRWuBQzRJ5EpQ8pdpsCXGPDg1HuqcGUpiqP5oSfPrZIEnw33DpRh2MSgr7Ytui
 M2fPhXBGThSS8I3v5/vX6uraO9GQ3ZDJ/kFVGija4Jp8mr9t1sSw/f1SaopsAAAA=
X-Change-ID: 20260728-work-binfmt_misc-usernsleak-c224e596beba
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 Farid Zakaria <farid.m.zakaria@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
 bpf@vger.kernel.org, jannh@google.com, mail@johnericson.me, 
 stable@vger.kernel.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-cca4b
X-Developer-Signature: v=1; a=openpgp-sha256; l=5088; i=brauner@kernel.org;
 h=from:subject:message-id; bh=GfZf4OtiPvKmem6JowvFOniZu3fnPQf7hYId+0iuxks=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRlbFbhnyO8/+nWyrYq9wz588vSZ791rj+53Pvo6/cZn
 lFvHiz+0lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjARVTFGho/bPKKvBacxK99s
 eF144ZaL45d5DSZ6zTWc39JVbW6yBjEyTOIw0vT0dQtVfJ34Z9ka/+YcxtW2x+NSfOLea0S8PXu
 WBQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 26DF416000C
X-Rspam-User: 
X-Stat-Signature: nxqxyyem8amehwgdetkri7zc4sybuxxg
X-Rspamd-Server: rspam04
X-HE-Tag: 1785246503-272048
X-HE-Meta: U2FsdGVkX1/uY7FdUD2LXk5FJ4ZpXYKHnLErPikqjn3Cq+IwGN5U5xzrJOJCRjti+N95YPW9HZ8VEATmfnXSjzG5N37di0bn6G/oUvHdQFx1Q9FeCVTexie//SUFAlQYUzEiYOMALM9F3YSePqVohMJnoq+JsjCYUdBJaYQjEGXXt6mvF23R+AipjWAJ4C4qAw/0XfHG9qABffVjuGzDMwmjH3fdfpBJlhGFpOyuNIuuyMU3RSENicSaV1XPLheOu+XF172CVw1Yhw/44BSsDLBCN5OuvyuXXsGQwqlgjjswgPFWt7OM7bCZT8gV1llXXMwLtMDFJuUIWyfupJoJ2OyL7nGinf6Ej8AL6WfgUbIdPnDtmlyk/n6JEY52H+T0u2KCZTwO9cpqCRCHdCXJBWjECLM+rlKMx7bRjvQlDizzI2KVy5PhPWYj2h3i0f7YFk6tkzv2gPGI7Df9MzADZu9496HeQNPatja2y9zxYzrCWETdKTsMqF8UjG2oAG1JlhzHIanytn5UBcEV8FtFCP3ujEkGt4zLffnmDJH3yOlBixGlVCHzHkAngk9UBE5U9KdCyl9cdoN+HpDvjYEE8BO/3R6BIF74QK/spb7rPk9fecstlhUHiovH5yy6dvCjOHVBSoOGaqxZKXr+poNkXGR7E+r4E6o7utDkEqYJo2hqg/KFSlaoHuysDFJFyeyjZDAk8O3IP7DQRk1AEUr/2jj/4O0FUdQ9agweFKPYvG5IcAmUNyAyYSBa0ra8G3p7YM8hVKN3fwYEBtcRME1EDF0ClCBAfs5yq3xprZU2FdWFKgFeJv1FgEa6eXGpTrglnVuqNeXdrSqod1hu2mAvj3aL8crh1mEuGotrIUUennyqjhkU8A336jknFazQuXLYOIgYceA03uOpbqoMgw4sM0yaNCy8h8Fs0ckejcEAcY5DnxLGZkye9swUPYbN3XHWB2dRAtBeb9HtUbs7R7l
 wnVPZrRL
 X7dyqJz55g6hOW/AnkXzIVdIIk76RJK5tVKMmiFwxpZS9/zi0+elee5VFt1A22xet7XWH13gvs9S114t2YmUOf/9fctrmYpRTR0Y8Oh2B5iI/N07iYAfUSez3YWFFi0xL/RaurxDV2PWVlGZIvXAtF8quvi4u2Gg3EbVWQSC+cnTvox535zwezdc3qjQSXq5fQSDQKqp5OeeDNxR46KJO1gacwHVlL4Egx/TVWonfbw1X45UZJUjJxjy4oRLtG9IjxX42fnxlU5MO7bSYjw1qK3Whh2o7OxPMn5WKYxEc04y1Ws4WtL2mGf+4H8D5jA6nEu1TJsSlIP+ApqZueLYBRfZmjLImaiDKQ67jUaQnSXEIK2haRszLBCFc0USCJr8hBz3JianH1l522gY5XkU0re0qnE5VREvVm9fv4MIELqYLHRg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

bm_get_tree() takes a reference to the user namespace and hands it to
get_tree_keyed() as the sget key. sget_fc() moves that reference into
sb->s_fs_info and clears fc->s_fs_info, so from that point on the
superblock owns it and bm_free() doesn't see it anymore.

The superblock drops it in ->put_super(). But generic_shutdown_super()
only calls ->put_super() from inside the if (sb->s_root) branch, so
nothing releases it when bm_fill_super() fails:

- The kzalloc_obj() failure leaves s_root NULL and the whole branch is
  skipped.

- A simple_fill_super() failure in the file loop leaves s_root set, but
  s_op still points at simple_super_operations, which has no
  ->put_super(). bm_fill_super() installs s_ops only once
  simple_fill_super() returned success, and installing it earlier
  wouldn't help either because simple_fill_super() overwrites s_op.

Either way vfs_get_super() calls deactivate_locked_super() and the
reference is gone for good. binfmt_misc mounts are available in a user
namespace and both the inode and the dentry cache are SLAB_ACCOUNT, so
an unprivileged caller under a tight memory cgroup can fail
simple_fill_super() on demand and leak one user namespace per attempt.

Drop the reference in ->kill_sb() instead, which runs unconditionally,
the same way nfsd and rpc_pipefs release their keyed s_fs_info.

That also stops ->put_super() from clearing s_fs_info while the
superblock is still on @fs_supers. generic_shutdown_super() leaves it
there on purpose so that sget_fc() keeps finding it until kill_sb() has
run, but a NULL s_fs_info makes test_keyed_super() miss it, so a
concurrent mount for the same user namespace skips the grab_super()
wait and creates a second superblock for a namespace that is still
being torn down.

Fixes: 21ca59b365c0 ("binfmt_misc: enable sandboxed mounts")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Note for stable: this applies as-is only from v6.19 onwards. Before
7beafd51c4e1 ("convert binfmt_misc") ->kill_sb is kill_litter_super()
and bm_kill_sb() has to call that instead of kill_anon_super(): back
then simple_fill_super() left the dentries it created pinned and
d_genocide() is what drops them. Taking this patch verbatim on v6.7 to
v6.18 turns every binfmt_misc umount into a "Dentry still in use"
BUG() in shrink_dcache_for_umount().
---
 fs/binfmt_misc.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index a73a37b8a013..c97f10b48b5b 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -921,18 +921,9 @@ static const struct file_operations bm_status_operations = {
 
 /* Superblock handling */
 
-static void bm_put_super(struct super_block *sb)
-{
-	struct user_namespace *user_ns = sb->s_fs_info;
-
-	sb->s_fs_info = NULL;
-	put_user_ns(user_ns);
-}
-
 static const struct super_operations s_ops = {
 	.statfs		= simple_statfs,
 	.evict_inode	= bm_evict_inode,
-	.put_super	= bm_put_super,
 };
 
 static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
@@ -990,13 +981,12 @@ static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
 	/*
 	 * When the binfmt_misc superblock for this userns is shutdown
 	 * ->enabled might have been set to false and we don't reinitialize
-	 * ->enabled again in put_super() as someone might already be mounting
-	 * binfmt_misc again. It also would be pointless since by the time
-	 * ->put_super() is called we know that the binary type list for this
-	 * bintfmt_misc mount is empty making load_misc_binary() return
-	 * -ENOEXEC independent of whether ->enabled is true. Instead, if
-	 * someone mounts binfmt_misc for the first time or again we simply
-	 * reset ->enabled to true.
+	 * ->enabled again during shutdown as someone might already be mounting
+	 * binfmt_misc again. It also would be pointless since by then we know
+	 * that the binary type list for this binfmt_misc mount is empty making
+	 * load_misc_binary() return -ENOEXEC independent of whether ->enabled
+	 * is true. Instead, if someone mounts binfmt_misc for the first time or
+	 * again we simply reset ->enabled to true.
 	 */
 	misc->enabled = true;
 
@@ -1022,6 +1012,14 @@ static const struct fs_context_operations bm_context_ops = {
 	.get_tree	= bm_get_tree,
 };
 
+static void bm_kill_sb(struct super_block *sb)
+{
+	struct user_namespace *user_ns = sb->s_fs_info;
+
+	kill_anon_super(sb);
+	put_user_ns(user_ns);
+}
+
 static int bm_init_fs_context(struct fs_context *fc)
 {
 	fc->ops = &bm_context_ops;
@@ -1038,7 +1036,7 @@ static struct file_system_type bm_fs_type = {
 	.name		= "binfmt_misc",
 	.init_fs_context = bm_init_fs_context,
 	.fs_flags	= FS_USERNS_MOUNT,
-	.kill_sb	= kill_anon_super,
+	.kill_sb	= bm_kill_sb,
 };
 MODULE_ALIAS_FS("binfmt_misc");
 

---
base-commit: 61d2304c0f286fe4a14ec6cee87588350c276d02
change-id: 20260728-work-binfmt_misc-usernsleak-c224e596beba


