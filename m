Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DFF7606A32C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 00:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E6eFWkLN
Received: by kanga.kvack.org (Postfix)
	id 6A6A26B05B7; Fri, 20 Nov 2026 19:09:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62F266B05B8; Fri, 20 Nov 2026 19:09:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F6DE6B05B9; Fri, 20 Nov 2026 19:09:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 199456B05B7
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:09:19 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71CE4C028B
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:09:18 +0000 (UTC)
X-FDA: 85457191596.12.6F641DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id D17B41C0008
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:09:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E6eFWkLN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795219756;
	b=0c7khpmLUfPEhTG0QF69TcFpWjTzNpTO9wZsP96GWvr5nfyD+P/UWtYtLtsVFK1oW03fUk
	v3B2Ma8FxufWYJtgQQJzaEYHNGUJ5+ZSvtL8SNs4eFLaJSEjUYm6MSTGQzsw30qTO21lab
	AcrWZmTgZcfb/6s0LKi1t6LX2fUY1yk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795219756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ltCLnFz06IQQ3SZ4JmjrUpmJ3OSN/eK/CX4oIn1dBP0=;
	b=2xdLQ8zLp5cJ2kprQwEAmjBdTxG4TEnA2LyInDhaMVnyQyke6j45jv+GFaP9UPRMPh/UHr
	+40OhMIDj5jQMuMbvkMInKti4QfTcOefM2iTzF5v+eFzZ9BiBU72VWuKE6dxJea93A7vkD
	3p2TYSlcxcjgEMT2hrGdq1xVRjIwZYk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E6eFWkLN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 60C646220B;
	Sat, 21 Nov 2026 00:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8CF171F00A3D;
	Sat, 21 Nov 2026 00:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219756;
	bh=ltCLnFz06IQQ3SZ4JmjrUpmJ3OSN/eK/CX4oIn1dBP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E6eFWkLNbxYCdzsPwOHpyhJa3fnhM106kVy1noUevOAjD4VRTNpQprlWqpZx0fk9F
	 fPF3K1sj4lenh8sHolhHTqIM36IyPEf7cGQaODb5Y53NPblxs29R7VON//kvE2qbEM
	 wuHini2ovvVt2ou18JLHSOqfANgPURVWLcJYlVH4INaiuK/4LLRT5vgtkoxte5VySt
	 uv6RrE3r94o1hWJa+cPjqvsAuL9r+veLWGak6PzpxNj1rZ/bjsM88K8eeetMSJh9YM
	 vLhBUKAbIqBW4k2jHWIO76idMrVIlAHOeHbBjv3v6XSHe54WGSo4QcA1pSR9LfCA3/
	 sPQCkmMFn0LvQ==
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
Subject: [RFC PATCH v5 05/25] mount: Enforce mount_too_revealing() for foreign mntns
Date: Sat, 21 Nov 2026 02:08:24 +0200
Message-ID: <20261121000844.1863324-6-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121000844.1863324-1-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kruhypmrao9ykrrfxu6uya614uckzd4e
X-Rspam-User:
X-Rspamd-Queue-Id: D17B41C0008
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795219756-339910
X-HE-Meta: U2FsdGVkX18Xrm6NPMUrLzSEJ8uuMWbOBruOHrYNMPYH8gc1lYqvafNVh1ctzbIWw0szn/Uf7vwyQsOp/7xtLt0NzUeN1giFUmrie/B+ouNHIVeQ7roVAaMtPStiE7gdVednhSnXa1fe8XHxGWt4UH8ooM5vhhWBkHGCjR9xF6p34Qs9Bv1JJOdCdF6HSOUqPS0XxLGDAMzmxWBEVtqC4ZgDMR3qY0EWBCGr2+hrY4rfsvDJ7LtdZ1H7bKXNh3t8NYUzpj6BxJEnU6dEXIBg8UsUJFWbZMkspUfyD4Q20yTtvfn4Jh/y7OCHW3uSsxDH8lJqhZMpTygQo70fC+mW72ftssFtLBD6S+/Q9sM4p76mT0EzmaHACEdXQ+ryBZqoMOlWY3KcZ7RjXzcYiPq8psstQNBcB5o4qQUIemJO8mw/a4bxpSFLDkp0J53QPgvp/PGWUOWtIdIVyy+puvg+emiqiswtWfeo1yfRwM8wK94pUG01eENCGyMbQUFFGNYfxq4eyODdbKpn95no1QTMCZjH/nvfPebxPJlpPCnflb1TUeImquKYd/JhJaln2jETXvEpbgeG8zF3t8tXaTe1KO1pWDj1VkF0QvCoP9VvJWyKnA3hqPhp20/dcfxxsucZTzQ8YNJcS0DU9eG2njFfs3jHUgBZCwwi2Cd8Iz35hbV+hDmtNxBjH7J7phzLwFOmZKZqv9P2gHe5TMwyQhdeTgGs8kc5ajY6H4TGas9jOuoffP5Ye0NQslJDm8cajp5OTTvnqwv0Hy0y5dh+eIXC7SHq6XFTVCo0Iogi4JydvLfmUPoF4d6yN+aUKx69s7R68vvpNdzRf83V3Y7ELsbrmwyzhfqIKel3i6KL6F4FrK2aBABuQkBirdbgIgMtibehSwa80wDhGyDZBjCnjx3Kl3AKPPuXb2vNAbAoGl9itfYKnf+jfl4R0ih/82NEcnWfJfY1bjy8N5hEdxeQnHW
 l4Wh3PO4
 l9STlwKMA6jd7pXX48X+Ty5eiogL/d4c+n4ULOexxxY+iTgk2T4L1LayXdLCvE3oqq+iQDRehrL82k3MIksgpOQN+NL3uMh/uZhwuvVX13yaWiQY4p4o9g+ZIf90PDNUMy2l0+91Z+aW1DXrZ0L6oZcglRJIoHpq6LnPCHKBixqEH+QjrV1GzD4j7YgsY5VLIL0yKaLzJOM9Ny6Mwxjgs1tkJzz1wA9kgKPhDIE6ekaxn/OLktDQGGVhXciA77H85ztrE50iiP+juzLzTxqbVFlLggxELfpcszWg6XePy0Yr5awJfNmAj8W1/K5KfFPSDJv7SnFsZtB4GhEBivzf2I0MOxJsiCKZ+vLzUS3PMAQxb65dybY1GH/XmfwcWJT31FaeIWmFkv/zvojyBcux9IwrLSHnTmFCBmOPkMSitnaN1QeKwglj4DKK2lpAbccpeUPwdgra/vxJB/wUGOwqu2w0jJjFs/x2WZm97SYimyecx9Xw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

mount_too_revealing() skips visibility checks whenever
current->nsproxy->mnt_ns belongs to init_user_ns, assuming the caller
holds CAP_SYS_ADMIN in its current mount namespace. That assumption does
not hold when an unprivileged caller creates mounts for a child user
namespace while running in init_mnt_ns or another foreign mount
namespace.

Require CAP_SYS_ADMIN in init_user_ns before bypassing
mount_too_revealing() for init_mnt_ns, reject chrooted callers lacking
CAP_SYS_ADMIN in their current mount namespace, and treat existing
mounts and child overmounts in a foreign mount namespace as locked
during mnt_already_visible() checks.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/namespace.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 781380945d78..b2dc84c0d0d6 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -6582,6 +6582,7 @@ static bool mnt_already_visible(struct mnt_namespace *ns,
 				const struct super_block *sb,
 				int *new_mnt_flags)
 {
+	bool foreign_ns = !ns_capable_noaudit(ns->user_ns, CAP_SYS_ADMIN);
 	int new_flags = *new_mnt_flags;
 	struct mount *mnt;
 
@@ -6606,11 +6607,16 @@ static bool mnt_already_visible(struct mnt_namespace *ns,
 			continue;
 
 		/* A local view of the mount flags */
-		mnt_flags = mnt->mnt.mnt_flags;
+		mnt_flags = READ_ONCE(mnt->mnt.mnt_flags);
 
 		/* Don't miss readonly hidden in the superblock flags */
 		if (sb_rdonly(mnt->mnt.mnt_sb))
 			mnt_flags |= MNT_LOCK_READONLY;
+		if (foreign_ns) {
+			if (mnt_flags & MNT_READONLY)
+				mnt_flags |= MNT_LOCK_READONLY;
+			mnt_flags |= MNT_LOCK_ATIME;
+		}
 
 		/* Verify the mount flags are equal to or more permissive
 		 * than the proposed new mount.
@@ -6629,7 +6635,7 @@ static bool mnt_already_visible(struct mnt_namespace *ns,
 		list_for_each_entry(child, &mnt->mnt_mounts, mnt_child) {
 			struct inode *inode = child->mnt_mountpoint->d_inode;
 			/* Only worry about locked mounts */
-			if (!(child->mnt.mnt_flags & MNT_LOCKED))
+			if (!foreign_ns && !(READ_ONCE(child->mnt.mnt_flags) & MNT_LOCKED))
 				continue;
 			/* Is the directory permanently empty? */
 			if (!is_empty_dir_inode(inode))
@@ -6650,13 +6656,18 @@ static bool mount_too_revealing(const struct super_block *sb, int *new_mnt_flags
 	struct mnt_namespace *ns = current->nsproxy->mnt_ns;
 	unsigned long s_iflags;
 
-	if (ns->user_ns == &init_user_ns)
-		return false;
-
 	/* Can this filesystem be too revealing? */
 	if (!(sb->s_type->fs_flags & FS_USERNS_MOUNT_RESTRICTED))
 		return false;
 
+	if (ns->user_ns == &init_user_ns &&
+	    ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN))
+		return false;
+
+	if (!ns_capable_noaudit(ns->user_ns, CAP_SYS_ADMIN) &&
+	    current_chrooted())
+		return true;
+
 	s_iflags = sb->s_iflags;
 	if ((s_iflags & required_iflags) != required_iflags) {
 		WARN_ONCE(1, "Expected s_iflags to contain 0x%lx\n",
-- 
2.47.3


