Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F93A606A6BE
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 01:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GvIMyozx
Received: by kanga.kvack.org (Postfix)
	id 391486B05CF; Sat, 21 Nov 2026 20:19:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F44F6B05D1; Sat, 21 Nov 2026 20:19:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 209906B05D2; Sat, 21 Nov 2026 20:19:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D6EE86B05CF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:19:39 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 42E1A1A04D6
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:19:39 +0000 (UTC)
X-FDA: 85460997678.01.A45C1E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id AACB7160002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:19:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GvIMyozx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795310377;
	b=kSC/Jm3z/i+RYtW4iJOwt5GhqsdomfaBKgDCEqKCpY+xur672PjhuGtcW7kRnrUcZoQzWX
	uYFAEMhzXsOJw2HzxFbE4HOu1n52RqLOo8TY6gFMoFa8pQ5rWiOk2Ht2YK2ZhcMwpXw4Rk
	DUr1qwhrO5Ag8Q3AX7B9640NdNOFa8w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795310377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cgy8beB6sSd/m8AunHL+Exu9SqwXUH4jGUnQFpHNC2g=;
	b=2OjOda2fXYQig7R5b9AxE6BNGfoevK6IZYMRTLhHRLystGfo56ysRGcCkcqDWH1R/6UkEh
	AMeRHwS4h1HOQptX+pOHl+zUe0WHMOf85fuUDhI4lcSOs3FG7nhU4R9AaxHBs8VX4J7Ryx
	KDI0vlDsTRVo7yr7nWdu4mGttnQqUNg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GvIMyozx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 06BCD4593F;
	Sun, 22 Nov 2026 01:19:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 391951F000C0;
	Sun, 22 Nov 2026 01:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310376;
	bh=cgy8beB6sSd/m8AunHL+Exu9SqwXUH4jGUnQFpHNC2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GvIMyozxQl2DNpJ+i9/m0l+3o6O48P/fEjSwUWnn82fEfSo57NovKzR3OPVk7A61K
	 XjAJSkujQBHcPPxECwi5KwwTiRDcYlNDu+e1PNBcEBWMtssY6WRX5vBc53NYjAPBEr
	 Tv7asu646lnLsM5ppF4enYZnpOkTBolaRtspxeAAY2+udhoECXMsHuGWYNVgQjAmS1
	 /lOu3eEW0QMsdZpW4L2drbyR2+TIDheT6W6B2Bmd8Hq+T56a0D8kNQVnYjX0Tf8qB/
	 tyBn0oOE47SMzTP0+w8XxAU+oaMGQA7nbju/cU/6dLYbzWWGPsssXYB958t127iwjt
	 0eS6dwhezh+RQ==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	bpf@vger.kernel.org,
	containers@lists.linux.dev,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>,
	Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v6 20/26] ipc/mqueue: Implement ->set_userland() fs_context operation
Date: Sun, 22 Nov 2026 03:18:03 +0200
Message-ID: <20261122011809.2667684-21-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122011809.2667684-1-jarkko@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AACB7160002
X-Rspam-User:
X-Stat-Signature: pg8mgu8tu9jrtqo1673mrz3aawjrmp19
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795310377-937398
X-HE-Meta: U2FsdGVkX18U+GmzAoAx33ATglQHSdskR3cE6RgnK1zgxcFq2IDbtU6MrVhE7i1qjDf+1+XslywoBvBbk3wxonHj5zJHWQuim/AELoGLjNQuway7U4lVf6DXwRJaFTzvoDti37lqWXA4Ut8cxAD4VZxWeVihSIin1jhIF/lf1FL7XWB988RZChh5gfyUB6yeW8wmlIBYRccwiqjLsszb81bSiKs2r1HJH7yP/w4/CY5r/ixF9zIgPtP2gM6d/GOZWpIuNLCZs/ZP0+cMjVAnGdzI1SRljqqYTOFtqG0Yu2pFoVwY9SnK39Th9M5XWi+SzWXt7GMx2WYKtw2ka3/YVHn0rQWHrRtOw2IH5eO+xEz8l+EH4KreLglyShsFhk56g2yXRCGpJgOIIzeBlGkBuVu23h3oN4RQfMrc3wZN0naLB4CuxjT2MmJy5pLrDTIYoCBpI518X0vsCRU/EtL7ltw1qPESyFlnPq14CJc+dWYYfuNtDGejI4TsSJm7GFEcZBoGzI8pAJwMMPNfTLgdr3OdveeCgJilHfhBUi5sZWyo5aMwPbUwA0CKocEdLe9w3b6j0q25UU9BDhSHQnEiQdl2q8wxE428x7BO9OAN1lMHD00dYM++hW+gDILDZR6c9vGPZZXpgaMTuwxPnMcL0PTeh42SFYHMOWbIFQa2oxe18y6LQ+PyC8s1TqFd1jLeQU53/hjxuQwDHLWcGz4Z3Or6oBlFqZGjIoCKYZfFDuBdCA6HdQzjvHAdzFulVaFcGhTaCJ6937XF0YEQahdOxLcO0scvRbtDNgsjDfqNAvlFG7ELMaQ0CtopL3oSnePpLMnDiy8RG4doLY1QQ5e+GDCfyYtV1RoIH7U5DhljKFVSzTdl4TfnFzyPmqv9FH7Fjl/4DLL6PGFHj6JV1S3KylpcemX9dhrvMeOmkPQn3ten6G0SwHLrEi7yVyEYAh3AcNDKkrS0Uo97LhrKoTl
 /O2fQcNm
 j5IH7h7ZRCD/npIZ0DtgdQ5zQbH+96QfBi0W1LPgRSgnXBraevR5nREk3+kxJEC9H+04Zu2iWcW29SCDNhHgg40ZoTJs3b6/I2VU/Ey+GRUFVnkxOgiX/K76A/P4LsktJ9sXhO0WVGcAficVWcNwY21K7N/ueNmTcfcX9ugsBUSTVTBAemCad/zQB2rg5zl27nYxK28CblMutb8Pva9kGvxY86M9R0NY8PvnEftsweTdl4hX/jVtUuyY2alxRakBE792Sc/g0OGzkIzpZGhvinIVNaXvUDOfyC3fKuHPkvo86XWQUYYkf7yBVV4o3NcoC7O49PQEABnvSfMIIo0izkJJDAxHPYg6iEpbC353/u2HvddHeIYV7XQ7AP6htcIuQvOelc85+2vV802SjxhrzJZgJvlGlp3HiW8O16Tu1knIwxxwF3quGaf4GWu3j5OuiSy9opGPRaUSNpCidoll+rIrQfLlBrZf8s595PdlgZXcd/t4tLCzA20hTFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

mqueue_init_fs_context() captures current->nsproxy->ipc_ns and resets
fc->user_ns to ctx->ipc_ns->user_ns, overriding the user namespace
delegated by FSCONFIG_SET_USERLAND and leaving the context bound to the
caller's IPC namespace.

Wire up mqueue_set_userland() to switch ctx->ipc_ns to the target
userland's IPC namespace, update fc->user_ns to match, and mark mqueue
with FS_USERLAND_MOUNT.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 ipc/mqueue.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 322c3dd98c44..f3079f7d888b 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -32,6 +32,7 @@
 #include <linux/mutex.h>
 #include <linux/nsproxy.h>
 #include <linux/pid.h>
+#include <linux/userland.h>
 #include <linux/ipc_namespace.h>
 #include <linux/user_namespace.h>
 #include <linux/slab.h>
@@ -400,6 +401,20 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 	return ERR_PTR(ret);
 }
 
+static int mqueue_set_userland(struct fs_context *fc, struct userland *userland)
+{
+	struct mqueue_fs_context *ctx = fc->fs_private;
+	struct ipc_namespace *ipc_ns;
+
+	scoped_guard(spinlock, &userland->lock)
+		ipc_ns = get_ipc_ns(userland->ns->ipc_ns);
+	put_ipc_ns(ctx->ipc_ns);
+	ctx->ipc_ns = ipc_ns;
+	put_user_ns(fc->user_ns);
+	fc->user_ns = get_user_ns(ipc_ns->user_ns);
+	return 0;
+}
+
 static int mqueue_fill_super(struct super_block *sb, struct fs_context *fc)
 {
 	struct inode *inode;
@@ -1613,6 +1628,7 @@ static const struct super_operations mqueue_super_ops = {
 
 static const struct fs_context_operations mqueue_fs_context_ops = {
 	.free		= mqueue_fs_context_free,
+	.set_userland	= mqueue_set_userland,
 	.get_tree	= mqueue_get_tree,
 };
 
@@ -1620,7 +1636,7 @@ static struct file_system_type mqueue_fs_type = {
 	.name			= "mqueue",
 	.init_fs_context	= mqueue_init_fs_context,
 	.kill_sb		= kill_anon_super,
-	.fs_flags		= FS_USERNS_MOUNT,
+	.fs_flags		= FS_USERNS_MOUNT | FS_USERLAND_MOUNT,
 };
 
 int mq_init_ns(struct ipc_namespace *ns)
-- 
2.47.3


