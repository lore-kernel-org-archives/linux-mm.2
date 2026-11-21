Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E254F606A684
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 00:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hCUdNbCW
Received: by kanga.kvack.org (Postfix)
	id E6F5A6B05CD; Fri, 20 Nov 2026 19:10:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF9046B05CF; Fri, 20 Nov 2026 19:10:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C72D06B05D1; Fri, 20 Nov 2026 19:10:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 959916B05CD
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:10:20 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2CF2B14024A
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:10:20 +0000 (UTC)
X-FDA: 85457194200.14.67E5FC7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8033E1C0002
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:10:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hCUdNbCW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795219818;
	b=eyxs9BQ4OpUjpz1ktlgkoRZFGbKuMqUTBJUgPe2p5NgCisIQPxneGFbcbrMcsLpWgpy01t
	BROrISZ6YLQr9w+6h+2p3EiPN8yPvqCWtX6xtCxz5lQN4uRWN7KyrxVS5545qo5MOe9zre
	xcCj5bA07FcKa8PKQHBQiTA08Fn7qqU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795219818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=keQHOqhbQzKnskPEephNWpQJ2+gEr/C+/pBH6fJD4Uk=;
	b=CKnYx5KLU0mmn7EmnoaaZ/ZcIi2gXQ7ZsQzunDPMdcnYgnHnE0ZqaJOyo9P4jSthWJcR3p
	RziqQazJJ4RrBndQGRm61RT9iDVKVcep7QN77GNFGukheJ3SmMWY3BBEzTmlMT23pPiKX7
	LLAQ0xr+w4IIY0w24It6uvFvHvyAMKo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hCUdNbCW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 22133623A3;
	Sat, 21 Nov 2026 00:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EC7FC1F000D2;
	Sat, 21 Nov 2026 00:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219817;
	bh=keQHOqhbQzKnskPEephNWpQJ2+gEr/C+/pBH6fJD4Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hCUdNbCWHBgRryTU5nu551za3xRW0gezc5OnTNZCeYNqM9wRJ/NsAbAG+VMQ80fFc
	 uoQohgRLiSlksCc/Z8OXAbokvEzSj2xFDa8SHwHcHhFa9Mn4xhv1Gww7/2oW4JGL/D
	 I/qlCZrwdXviGnAWdDkBva0/NKmT2NxDqQbqnlGKCmc2i86RdFVhnvMh9gbxbtOdja
	 oyVx0Mgr/BwtKtQ0XfHqiIFV9uqT7kXGDt1GJ6f5Y1qpPeuWjr4cktfc+tNAvXZLSo
	 ArIrP3F4dln8owvw8NahPBsy34x8S7IbeE6gBha8FZ0lmJqFEy+A5PAviI8Yv13P4v
	 viHdX3QpRHJkw==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v5 19/25] ipc/mqueue: Implement ->set_rootns() fs_context operation
Date: Sat, 21 Nov 2026 02:08:38 +0200
Message-ID: <20261121000844.1863324-20-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121000844.1863324-1-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8033E1C0002
X-Rspam-User:
X-Stat-Signature: 3c9ua9mx7cnaapcdz5dqwxpwohzcwpju
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795219818-104940
X-HE-Meta: U2FsdGVkX1/BPUTIVPW34pgkV2XIBGKgDTaUqFZB/rCSUGQBVXluCqy5b9ojTaXS9sQ+vyxF1uEx+eJxLEmoegBfIs4riDC9QDZjmDE6KecLECSW5+Mi7j+AJkU4f9Df8KaQ+LarKtV+8kB0r1x8II6zHzF8J9lUm77DSXHyIVazdF7PAg94zFK7mTpwDtDCl1ljuHulHR+qoCDoMGN+22l7wNAG4oG/NtfH7EZbrBhIC/0S6SUWu+Jtu04AiykNx2Vd4wVKftIgn2l2HMLA5sOhKOGjFHMAUxaAzygXQdaFWUn3VUivE2bbw2dDlp78v7ZAXMdY5NJT8UyuoVMzSqh1cCCX+T+hYPidnjfTKIpbp1YQX9N0aZRocjE+6Cu/NJvzzx6zvc57H/31MhV2Ow+l7BMUoEOYnfSL184uQHitmiCozHjowvkxORXmuqqm4TdExgkb6aEaHX1JBrQi0lQ1FBNWnoSJVee3E/hVjXgXYX+cgSNtfJyqgK7leYbBneWSJAuuXxGO6Z3eZ43QjQX5LVyPtRfRB8vEZds3KyJjw2ELelH4Oo/qi/u1B4TBDUMfojpyP84WlUL3f8c95FWavn/M0OGI9JSXJZ9fH9d2k5QBC6JEXcMS0aTwKMk2YpZKHP7XyMwnBmaEVE2sT/T5+kJgestM/Bbe4noTk9OQ8jfBkDU27jrIfmXninVIRxe2dhI8xewZGm4DZPhYNKNGzVP7CZtfkc7Ox9WjPw+AdEtQkX51oWCRdYzkICm9Ula9z8LGjpA3xIpJAXWSaRirg7ii77Kuo8MgtCNic9Lhrf/+nU/H689HtOukFCIU6mGiqwfmbx3ZphYPu7N61w2Erd5/dc4JxbV61mUPW7hP2Vi9UVZQJn3+Qr/N0yjdNey1zT+xkvVL0EINe+lwPA0r6Cl4t2DuiQSJsBdWkKGdoc2cKAJNyrM4pCCP0LjzfhEs71x6YLKFUhJuIh1
 Ou+NysSw
 BUJMEjLa6jSzAPiLGK5Fc0NE9O0bQoM6WQGLjk7pI6AOZMDG86JSPOIRmj/jPLaPcvzO8HUj64fLnPGRqZMJea0wLkk62NHVIU9c9P3bruJydHs/wBwekmP31rKUNxkOSKhPr5rzqpVFwhiAQoEAwoX1ka5MOUqsRvJMcDB7VH26L+NciOL74kaNdGoGz8ic6zPkpHRSUUyBMxQqDy2LlmBOYmCI4bKz58RFAnbjp0HiinFodk9drKo8eF9EChG0AhaYkrYopfRpkWCr6Hp8sO5hfcsDn+ZnZZUW0xNwG0tEp8ixmOuf98qtGzkT8JRrpFNPBQVTObuaPGkwYFkEdr6fzHdp1yQFyCqkYzQlABlIWo9kPnpkiDiEivy1BcxekU2RPVbZlWSUefSQWvQALhqCYqU+Tqemc07f/+SSZMGsJc/tgce5m/ZxL4Vgbg9g9dqMRhEe/hs0BisEolKVRVyLvgdj4tJU/X5iTIiph2saFkhA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

mqueue_init_fs_context() captures current->nsproxy->ipc_ns and resets
fc->user_ns to ctx->ipc_ns->user_ns, overriding the user namespace
delegated by FSCONFIG_SET_ROOTNS and leaving the context bound to the
caller's IPC namespace.

Wire up mqueue_set_rootns() to switch ctx->ipc_ns to the target root
namespace's IPC namespace and update fc->user_ns to match.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 ipc/mqueue.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 322c3dd98c44..f94e9b566bd0 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -32,6 +32,7 @@
 #include <linux/mutex.h>
 #include <linux/nsproxy.h>
 #include <linux/pid.h>
+#include <linux/rootns.h>
 #include <linux/ipc_namespace.h>
 #include <linux/user_namespace.h>
 #include <linux/slab.h>
@@ -400,6 +401,17 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 	return ERR_PTR(ret);
 }
 
+static int mqueue_set_rootns(struct fs_context *fc, struct rootns *rootns)
+{
+	struct mqueue_fs_context *ctx = fc->fs_private;
+
+	put_ipc_ns(ctx->ipc_ns);
+	ctx->ipc_ns = get_ipc_ns(rootns->ns->ipc_ns);
+	put_user_ns(fc->user_ns);
+	fc->user_ns = get_user_ns(ctx->ipc_ns->user_ns);
+	return 0;
+}
+
 static int mqueue_fill_super(struct super_block *sb, struct fs_context *fc)
 {
 	struct inode *inode;
@@ -1613,6 +1625,7 @@ static const struct super_operations mqueue_super_ops = {
 
 static const struct fs_context_operations mqueue_fs_context_ops = {
 	.free		= mqueue_fs_context_free,
+	.set_rootns	= mqueue_set_rootns,
 	.get_tree	= mqueue_get_tree,
 };
 
-- 
2.47.3


