Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7666606A6AF
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 19:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MFbZVX98
Received: by kanga.kvack.org (Postfix)
	id 937116B05CF; Sun, 22 Nov 2026 14:37:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9116A6B05D1; Sun, 22 Nov 2026 14:37:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84C0C6B05D2; Sun, 22 Nov 2026 14:37:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 58A3E6B05CF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:37:25 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CDB95A8106
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:37:24 +0000 (UTC)
X-FDA: 85463764008.15.C27B4F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 32E881C0005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:37:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MFbZVX98;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795376243;
	b=enYAeXQ8ou0T4psbkjYrE+uhgnSOgbgeF9w66MTApJd6B7zaF2MH9aQRwxSj2B5MRJYZoF
	Vba07js3abaBZtnlfj79boXL4A8ePWfDjY5cbO6q2rKcqy9qZ0AzwT9aFof3tTq/WUqYyu
	WzUafXxx2orhawq3McMbatuwOGwyMLo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795376243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cgy8beB6sSd/m8AunHL+Exu9SqwXUH4jGUnQFpHNC2g=;
	b=gQjVZueA170ll6dIPEw5VWK/PBUh54hsH+fq+6aBbQd53D99L7woQM7UHcNPaL66U/Lo3u
	1JnC8mOFG+T7LaFfPCFwHc+3uNeUZLLzMe0eFj5OC5PM96QkF7uOUykOM+LrQdH64fvSaJ
	x/KVneFiGc4otNxlnXjUXhQiPe6JyLY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MFbZVX98;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 8177540495;
	Sun, 22 Nov 2026 19:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5680E1F000F0;
	Sun, 22 Nov 2026 19:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376242;
	bh=cgy8beB6sSd/m8AunHL+Exu9SqwXUH4jGUnQFpHNC2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MFbZVX98oz4AbJTw3EE+xuDLG3zdzugZzGHmoYc6hW7eDec0Blnfzxt5edluonBsu
	 e0Ei3/23NPNyGX5cyvRmcFvoeLu1mEnHe0QrQdxIt9XFnxpQeXlfHbYCLtlnjnYWBz
	 Nbcb3MXIwfKxt7e7V4rLH7H0AIyobdyn+16rXrNSmV7u5hbKxwQBPTXwAOWKS4xmiF
	 H7qCkd/Gt3lIwdBEvC2huYCEAP63fMN+dpNDjqiAJDdVcF4aAkl4mObzlIXk8T0o8H
	 ayCiozSV6G0LHbRgmoiRS5toCHJx8Wl+Cu6RyA4Z2dEfujWJDRWtHSGWP8nbnF4Pmx
	 r2J26+nsXFzqg==
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
	Eric Biggers <ebiggers@kernel.org>,
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
Subject: [RFC PATCH v7 20/26] ipc/mqueue: Implement ->set_userland() fs_context operation
Date: Sun, 22 Nov 2026 21:35:33 +0200
Message-ID: <20261122193539.3334213-21-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 32E881C0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: azzctx5nyahfhz7kz83ymnfynjtxhbt6
X-Rspam-User:
X-HE-Tag: 1795376243-227994
X-HE-Meta: U2FsdGVkX18yE3JqrgoRgsK8xtI9aOw3y6yUupH5k4NBgdY9aVvKktYdys6/zVgKI0xno1Uss/IWVaTXn3CNj5uy1liQsYrObmALPT1+vRpnNeegQPL5neK+nwxkgq++JfgJgCDAcnAlwjKVcN3ilPwyoDO2x6JbXRFfNzs8GmOpbhT0CApoFE2p9ogRT/0zT2PNU7Xto79tapjEd2CAqud6Tx+zE5uSlLHkZlv9FE6lCp3lR7k8pa5MlkubvN4kcR889rg5KG6O7NJkFRrajaHW5OYCLOTTThm9ArxI4gCD/ETzG4FGzk5Vc5VawYSPP4uYb3h3J35s+/0xpq9OxVgJW5zNKOls86rp4hHQPnyYe02jX7EVGAz2y7paIQClYG7eqKz1DFfFScFw7QwG6xeihnA7bGQ/Dakbt7kMhAaqE8tlDvNoj+WbWKDBGoIcM9wGcFTA6+rB2v9ZeU3X0iR6oF/OWJyKf89vvT+jNsASFG7WbDH0cxk+t+LOL2Cjw1xAKo1hx9LqKXNUoUutgpIaEnXZECrkZ6i/QiSWuoZP8qDOeE0oICtCyEFCs5TTldIr593N6oqXnbwvKktnONWTj2ACXDFm6FeH3ByIosikgMaDOpr2OvXf+SvteCnrH71SmnOXw88TWeMBOCD9v+MZ8FggVawL5mMrk03+3yyG/K/NbqXMu7gPTOOx/lRVBwx8ZZi2ubjdka5vW6jdOd0bs08D0M/dxP4n4BAWHKI0j9m/RLDvgsvLdpsJU2lgHuUXbWDRgzUSBlRiosj1dzbunEUV4xCj/Pkd4l3iiGrpBxY5IQOeP7DYK6aT5D5hNZE513Qh4L90gUOlQVrjmyEzZnwqnphsIE7ZjH2wqVfCVQVl+hrhMAM9kAOyxjJcbrMMbLeRtv2L3oBnbWbu2H4wEwTlnb014qPSA99s3DDy0zBIHPCYT+SqgDCXcdZPJe71jPfRuV0O1yDjtXN
 uCStPu9g
 M/5PrfND71m4OfQAXI8zU66TksMbLatvcOVbD47Llculw0QIY7fZ7/bkaNQZ7jS5wiBYTWRxaVELAWEDya0A08AHhD5zB66ZjXijFgFjcwZWLzAKcEIQYO1a/DjW38qzOVO8/nYWZGyiLoBFDPag1ClK1bWjtU2WOG92L8RfKQiiHB6arEe6oQz+gKFdhTlBNA6kQap/zWIUzSwEn6Zm1xULs8SmARLeoLt5VPDe6P6k1vaFgqcaWQRcTrhEkW3Z0OuqOOgm0DtKzgyhdxGKNnc3FRjJfS2Kh/SWAcPnTDI74Qe5haO3Jr48KimdSRmi/s95mSQCQcDGRG2Q4ozCVHCuHK+jioa0z8SAReePWckSLM2Y7LJz4HCPv6rxef4SqD6A6I4L59DdEii6FxsjTGrVgTm/ERIYSJiP17Hd37wDVCcTfEvj/5sek7qE475Ij7t45hn3rMvY8rTG8z9g0epSDv43ZfpwnVbDm/uTxejTpv7UYGHjGO2zKBL820sm/kWA+YcCkWVhzUFKJHrOAwCL66aOHdlY9kFFZ5o7kS10wLIGBWsVIV1lHDmLgDp0b7E9tW9TXvkYMALRLcQUwTXbial7pgCjZRTMI2EDcX6Q9v219IJGJNdOJAA==
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


