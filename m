Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8723606A6A4
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 01:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kgP/2/6s
Received: by kanga.kvack.org (Postfix)
	id 95BD96B05B6; Sat, 21 Nov 2026 20:18:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 933AA6B05B7; Sat, 21 Nov 2026 20:18:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 822856B05B8; Sat, 21 Nov 2026 20:18:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5AE946B05B6
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:18:42 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CEF5680604
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:18:41 +0000 (UTC)
X-FDA: 85460995242.01.9CB5D71
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 41806100002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:18:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kgP/2/6s";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795310320;
	b=bimkX1CNjqg6u33K42rlcL8chTLM206RO9kplv5IZUvqm/nYaT7lPONGWebn1+8Aa/Hq9u
	WTcbjJygIrFgtIabK5gJdaunqB5bvk48gi8+KmcvvlrpNfppAhptYLpB8JS0xcdz22PwAY
	G7e70S63ffutuovIuHyR4FoiPq1ak9c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795310320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ltCLnFz06IQQ3SZ4JmjrUpmJ3OSN/eK/CX4oIn1dBP0=;
	b=d+IJzxD9s5JCpD504RZf2vPlCDNaMlpxERK6lDE+yFYSXLM1dj/Woaum3mR6U+NF/z/WF5
	yTvagwLAl+EI8RMa1lOQIaxKPJUlMITMfldwZvFniY5gs/UB2MVQuV+FtutB51BjcyIdEc
	xhwuGMBi8/g8y+1ynfmlX4XRkliOtIc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kgP/2/6s";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 617BD60232;
	Sun, 22 Nov 2026 01:18:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4EEED1F000CF;
	Sun, 22 Nov 2026 01:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310319;
	bh=ltCLnFz06IQQ3SZ4JmjrUpmJ3OSN/eK/CX4oIn1dBP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kgP/2/6s7spLqnf+9wMSyz4rEEZTRyT+B+YkDBhkt50gtPY+vgrIGcVhtKCrkLRFD
	 0f2TJ3D7eb/66eUajBQSuTi/fbl8VRvUv25a5lt8QxW+oq/QqpzAMtr3BhPptZ0j5i
	 3kW5sabhvAZySVfrnN6bJyajveSB6ITeCvGTqK5veb2w1g2xbX4xKOGMMc4+GYvvr8
	 EMRR/HfWrBOhDIla3WYo95eeveTxI0eMLnSe03JMHIIvWFMZ8OIizWNrWwv+7r/z/D
	 KlSGsb410AtNh5e/TSaDB78vVeHXyRexH3UeeV5hcfhavPGsM91d/HPvOkbt6OMZDE
	 HiqUj0/wbi5cg==
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
Subject: [RFC PATCH v6 05/26] mount: Enforce mount_too_revealing() for foreign mntns
Date: Sun, 22 Nov 2026 03:17:48 +0200
Message-ID: <20261122011809.2667684-6-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122011809.2667684-1-jarkko@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 41806100002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 9ax45rcb6yyrj7ir33n4qzwgtj7a3csn
X-HE-Tag: 1795310320-171873
X-HE-Meta: U2FsdGVkX1+Ea6T2oTNBQ+dMejY1vgrD368xTzmYCdWSea5TFBx2xOhvEd9gW0/C4s/hgGnuG3oeKUh1OFveSvwwodi9JN7ZyR0BbVR3pK3s0lk5LWu1pRKuONSfV9cKP5BkWwWz3fZiqXyjjvtOH5569MMcjF29w97k1SzYWzoQ6PMj6sqrG89Z+b5/63V5M0+sM/3FC0pLjy7WcPqrZ5MJM9edbGdkR+y92vkdtUNXO33cWROWSlqmXEY/Jp0G5Xzo9XQLnFO+TacZAgRcR0WDxPJXvC6FMWpmMZcoCwFRmoIIlWnZguoetE/dJTw5zdpJjsJjIMIQgwaNMkJZpPRPNQdc1NgG1FYDWyue5embm5AjtX0myZ2HGocHewjQQxfZ093lly9Hwmk6stuR9r7ymUW293B6IG05TnFD52Y4W1peA+nEv1FCINGtxsZfu5UUpcAkJd1ErSEBE6KRmdW2934N600bFGAkJiNFSUDbwh7dv4IPMzdgtrVRaNj8j3n+978WG6BSZxeAvNYbOsEZNoWNwX6LgmM6sZLttSFSNOWj1m99YnabD2btHFKRwQtNWK+NMF3sksPwJZIOOMtpqq3mIGlrSRZsfxOB5eqPnk6P/2KFtTpJdsDiER81GqUDDv+7vVknXyVBWLQbQRMiUtP6QWbiI/9fulN3NA9iPAVSnLOc6RZlvACaEWgFaBbbpf7F2KWCIEgzg801IFrGySd12ozIJPGPNDQh2OlGUOLvxBa8aJEFhqIOBk4I5xuUx7q6GSOXYEvffTacEikxzRjf/hJUQ2+9dmyHPu+qKuhLxKSjEFazmsX8BWhqPA92O7ByXiD1SxJ+V4D8uFLfNL5TfNIcNPzsfq69C4Jo9nL8cj3BuEvhGYShgA8zIaRvnu53YuRPjIFxgRNTcet3sGpx+DZJiB1B8vFC7drsbhRnK7OMg5h1DYudDYWOjBRCCnLY1J8hK+u5KNX
 cIcODvyq
 tOWzdOiVXWqKUeoURKh6GfZvN8vf7Rzsk9GNL7GA/E1y5K9W4CWVoP4AIeKkSBQnWHzjYvkePf75ROtUvqmqQWc/2M6Jmdn5O1D6+kVmsi9qO3KZZFI9EEkTF83TkUw+oaGThljumqJuHz2zI3khQ83HNGOze2+PhMeLzA78yzm2tovNCGnWewMWODahDovbB4AOnqlUsfkmAM4Nia06wvf5ul09TCUhSVnzX4jEgDNzqAVTTgoGA5rvctGMayEM7monlgXaGb64BDNDmTTehhyfk//PpLIObVLtnAJiUwBSGzS9b6quJVBYoy6sKtIA5YuVEWPG5dnYBFwemTWzwX/XX7kzTjFxamH0HXZSYfAmcH9nWUOEO6zYkyfEQw+F0aIGEDZjju0nbr0kw9i+mWpxkyTt0dsoKn6EOYMPCRa18bIAV+SKMAnNrat6bY1hC5u9DdBF9AsT2l95KJ4ygRrjHvE3qSZyziCvB0GgnzXHzrCM=
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


