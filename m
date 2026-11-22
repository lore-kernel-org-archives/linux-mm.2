Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B85B60A6F69
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 19:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n5gU4g52
Received: by kanga.kvack.org (Postfix)
	id 00F7F6B05CD; Sun, 22 Nov 2026 14:37:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDE116B05CE; Sun, 22 Nov 2026 14:37:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA41F6B05CF; Sun, 22 Nov 2026 14:37:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA1ED6B05CD
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:37:20 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2EA34806FD
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:37:20 +0000 (UTC)
X-FDA: 85463763840.26.5C71652
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9307440003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:37:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n5gU4g52;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795376238;
	b=fOF2TASt3B8Ofucgtx3/T69ds9GBsx8K84dleXAldj0vYkKykcYwWD8EWjwRT01qBn40Xr
	YcrorTp/SkkRLpeXuUTixdjbUIKdgo7iTdyqlGVVEnphE5HBkE/9yTnbQg9AOLDj0UInX/
	k8iILuTEz+Uy2OftQLxj1NGpMBLu07c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795376238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jfv3MMg/O7UN8A+W1NHYimNXqqAkPIDpKwh6yDT3Yps=;
	b=8Sz69SCASThDsiatcn6a+RiRe+KW4nKCf87+b2hadexTHHHQ1gS3jvsnXFTWkUZIhWrWW8
	w5Mb1Nc3XNLLn5HcunFhThg93Pjfo/nxV5XI5NrTfU1uKqdeAcj+m4C1UA1vHb8v/HGDNj
	6WNQ4tupNhBJ2grpN5rkE3PHyv6zoM4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n5gU4g52;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 472D261219;
	Sun, 22 Nov 2026 19:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DB0961F000EF;
	Sun, 22 Nov 2026 19:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376237;
	bh=Jfv3MMg/O7UN8A+W1NHYimNXqqAkPIDpKwh6yDT3Yps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n5gU4g52v76arg2qLN1/ypN62ZK2xci1H49qauQnRD1ZQ4gQRiaGYjG+lO9PfDqlW
	 JaNR9IvTfBSu/9qDydT2bch63eLvpP4T1EDPgHW8Mzoto0p3nO+szhaHzKbf0skjP8
	 /oEkzdVR1WlrXz4CBqyZipi3lB4p4mouk96KgWm56giD5yEchAfUB5dWsIpwvq5/SO
	 eFtzo8KxT3hJ5NmYppp9kdPQ1v715sI0tizcf/CAez1gsnUTR9o9L7Xqzl9uV6h2dk
	 aX+ZhnyZudMcQlmfslgweTo5EdDIU4iAKk/S4ZSGZENNEbQqlJTvaN0c/FeqdYoMKS
	 vZPBDfzIqGCmw==
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
Subject: [RFC PATCH v7 19/26] proc: Implement ->set_userland() fs_context operation
Date: Sun, 22 Nov 2026 21:35:32 +0200
Message-ID: <20261122193539.3334213-20-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9307440003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: a1m7nfumfkp81fn8igtbemx716n5htf4
X-HE-Tag: 1795376238-661206
X-HE-Meta: U2FsdGVkX19m8JQ9oiu2bvKrHglyck4jh9NxgUE0ycwciFUkaZAsdwMVicJvj5/gE2fNZksVAdKPLGssHmmln947Nb3A5mdCVqHH6t+U2l0c7n3TSHeBQFMGvKYO1lUIp1EPNTUUvcqRGOmYy29q63wMYNISpg+4DZOW1Vg1Gd3/O3F+Ukxgb4BizXCAzWl4f2BeQvCBKaFgqa/uGynwEuFyqppvCr3rlgzNCJwW34FZ4F1pLvVpgfjOC27KYx09OuglMr76B64pf7j6rh9vWgvMkEmq1IoO3pQ1jG5nl0gqQ6TEJmzg69INR5C8+DSIEXvGv39db6VJWXojeFd9WfKO+pShJj22efGuTT5kT+VsXeAn/KcWdsPiBg+d6S4CTDcFviunpdpTRo4/Yc4WR0sLRxRi+ZrU6mvLXEHkivg279v6ERy0H/F9yHNPfY0MAgz5ULdGftK3cj1OlbHmP84vFQZ/8Uf6j8HD336tIc/lN/WcYbRXQyMIEbBhR1W+7exg8q7IOP53112Ibh/1Q3vpGzq97oTwi7JBfzSJdiiprykdUzQvHvLFGCZQoVvAhrZPZJeNA07DYBKaKecbPIUj0qfEKvIcMhHID/Mtco+aEn2NI3CcO1m4F1/YaR9edp4QVTTAmddBLJRCwvvz1Vsh8pOov2ezL1SsrBf2l3goWkQ1sav20mL61hdDRVXu/A1AbJqt43MbPfg2ddUgCLVmUBMPTNbIBb3DSHVwb+FKcEqYejKWyk6P0TGBlBMeNyTBn8g8c46fkyNup+FGGVV6yPGJcJqxIUX59/S46HNnhSUftXGQeaun/kEHig2iqMbmV7JXkBXGdfgdX6c6R9S8IM32SbR3iTxOuALHSsZo+hyWN7sME5ce/0dYQueAP3dzdzOeS/fwYfLTlPn5dhwjJ6j+xFqwAaSHnWaVmHig2lBt9FnL8dsuks3nNRZE6Tehz6Zne+RckSiyzW1
 jUAc1KAn
 Sed1wP+LdP19ahipoW4EcY26HbYk0yNXaTzgUdn8hC+QAOY2sSVuFsoYhGsONyGj9cJ0T0JpdF86Z30nALCIQQ6hl2d7XzueEsaaDzm/IK7NOFcBsYeZZFnVQmz5orlzkVZx7kioA0xSuXgwKnpe54/x+0q34/CP+P5lz3dyrrU1cqKuElTZi4lJqz7fxTBJQM4F1KwNPopoofo3d+awPWq7qOvPZrgcVF+gF8xZEccf6D73SpIYlYyv51XeRfS+mRuYj64GBRruviVP2kcvQ7hpT4HeWRD0Qny4x7JTCES6EBm4gnIbA615UAcBlg4l8YHxgoIi0r7pAAYMb1LXwJiPAChmgx9v+aws3lYrfTdHn/Gi0xHrMxKihB6bfJvAVwDmwljnOiHbIMAadLHXY/ys819mwHJXNdxMrj8j/95tAajpoVecUNtqFaIaGoJ3Pbn3vk070sW51vV60RDLoW02xlB7nsqJZ/BfIF8YCOzb/OXxXP+r9PBoFbZl+FE0y17vVKkbFyLvKjoRYTRJkHP2AYlcVefqNOMwZaV+z2fNihJfW3W5Lm3xcO+n4pcW4YAEErKe68hMB5v3Kfoaeqfd5BEgqZnUrQpOmOuew1c7X5s40t2oFYgHRYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_init_fs_context() binds ctx->pid_ns to task_active_pid_ns(current)
and resets fc->user_ns to ctx->pid_ns->user_ns, overriding the user
namespace delegated by FSCONFIG_SET_USERLAND and leaving the context
attached to the caller's PID namespace.

Wire up proc_set_userland() to verify that the target userland's PID
namespace is a descendant of the caller's active PID namespace and
rebind ctx->pid_ns and fc->user_ns accordingly, and mark proc with
FS_USERLAND_MOUNT.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/proc/root.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/fs/proc/root.c b/fs/proc/root.c
index 7fbbe92bf73a..e61b1a559172 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -15,6 +15,8 @@
 #include <linux/sched/stat.h>
 #include <linux/module.h>
 #include <linux/bitops.h>
+#include <linux/nsproxy.h>
+#include <linux/userland.h>
 #include <linux/user_namespace.h>
 #include <linux/fs_context.h>
 #include <linux/mount.h>
@@ -206,6 +208,10 @@ static int proc_parse_param(struct fs_context *fc, struct fs_parameter *param)
 			errorfc(fc, "cannot reconfigure pidns for existing procfs");
 			return -EBUSY;
 		}
+		if (fc->userland_bound) {
+			errorfc(fc, "cannot override pidns on userland-bound procfs");
+			return -EBUSY;
+		}
 		err = proc_parse_pidns_param(fc, param, &result);
 		if (err)
 			return err;
@@ -323,6 +329,21 @@ static int proc_get_tree(struct fs_context *fc)
 	return get_tree_nodev(fc, proc_fill_super);
 }
 
+static int proc_set_userland(struct fs_context *fc, struct userland *userland)
+{
+	struct proc_fs_context *ctx = fc->fs_private;
+	struct pid_namespace *target = userland->ns->pid_ns_for_children;
+
+	if (!pidns_is_ancestor(target, task_active_pid_ns(current)))
+		return invalfc(fc, "cannot set pidns to non-descendant pidns");
+
+	put_pid_ns(ctx->pid_ns);
+	ctx->pid_ns = get_pid_ns(target);
+	put_user_ns(fc->user_ns);
+	fc->user_ns = get_user_ns(ctx->pid_ns->user_ns);
+	return 0;
+}
+
 static void proc_fs_context_free(struct fs_context *fc)
 {
 	struct proc_fs_context *ctx = fc->fs_private;
@@ -334,6 +355,7 @@ static void proc_fs_context_free(struct fs_context *fc)
 static const struct fs_context_operations proc_fs_context_ops = {
 	.free		= proc_fs_context_free,
 	.parse_param	= proc_parse_param,
+	.set_userland	= proc_set_userland,
 	.get_tree	= proc_get_tree,
 	.reconfigure	= proc_reconfigure,
 };
@@ -371,7 +393,9 @@ static struct file_system_type proc_fs_type = {
 	.init_fs_context	= proc_init_fs_context,
 	.parameters		= proc_fs_parameters,
 	.kill_sb		= proc_kill_sb,
-	.fs_flags		= FS_USERNS_MOUNT | FS_USERNS_MOUNT_RESTRICTED | FS_DISALLOW_NOTIFY_PERM,
+	.fs_flags		= FS_USERNS_MOUNT | FS_USERLAND_MOUNT |
+				  FS_USERNS_MOUNT_RESTRICTED |
+				  FS_DISALLOW_NOTIFY_PERM,
 };
 
 void __init proc_root_init(void)
-- 
2.47.3


