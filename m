Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8B87606A335
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 01:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HLKngoZc
Received: by kanga.kvack.org (Postfix)
	id 982EE6B05BB; Sat, 21 Nov 2026 20:18:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95B096B05BC; Sat, 21 Nov 2026 20:18:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 849606B05BD; Sat, 21 Nov 2026 20:18:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D3556B05BB
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:18:53 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DF7A412059F
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:18:52 +0000 (UTC)
X-FDA: 85460995704.12.96E54FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 555A5100005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:18:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HLKngoZc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795310331;
	b=acJlJXEkei8PFTzy2vJLrWX23SxkG1phuFz30/w8YS9mMlPzolqVk6QfD+gD4xmlFozhsf
	Tx0s+CNu5hu8tQNUVKWARFQaBPafMvhKnraxxWT84bd3uJ4bDG00FW9h+PlA/FFlp8f3Wl
	lWnSkBz84UMujJ4CYVhm4aMkhjO5i3A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795310331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7i1ZKyYWLmxMooUHWzodPLxMUmlmO8vdX8qUIBZhiHg=;
	b=SJG82LvcHj4Wvwzn/hAASOtTr7+ut0c8cgsxF5ujdzqVt9kjYqsKzNCgaQTMf5BDInFXVs
	6EHBXqd+AIv4ENvAtGomY8XG3Jw9OoQOxnWI8H2jpTYvbLG/VmjnoX3cpj8v9vNYF1KY0i
	K1DSSp5Gn30M6PPf6jFVV9LBDtshbDg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HLKngoZc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id AAF9A4347D;
	Sun, 22 Nov 2026 01:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DE3B91F000D4;
	Sun, 22 Nov 2026 01:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310330;
	bh=7i1ZKyYWLmxMooUHWzodPLxMUmlmO8vdX8qUIBZhiHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HLKngoZcXVDJegov6aUSnuW5rbhlxkfcJOWqXdXeFpgr81zwLzn+RDL6dabXOaOY+
	 4Vl58atGb0z4/aDHm0RJriTd8jDGqSL/XPulb1lFYW535a4R3kNlg5yytA0FNOONfk
	 3ZRis0tF//jE8/AEQGNMiao1qfBvwHiIM8N+hagpBDQr6xdrNsFQV2eF7z43nGwmO2
	 LKza6buMaUQRxhzsdkKVjyKPu5B7gnovypqe3hg1bNykCnsJKYgshHffYlBykB5XDV
	 o/FoxZbNxE27GbjxKULDw18duEr39TWl8nhY1fVwxxFcDcmKruTZyVEqVipJ6ApeCs
	 BcxM2zdM5GvrQ==
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
Subject: [RFC PATCH v6 08/26] userns: Factor out install_user_ns_cred()
Date: Sun, 22 Nov 2026 03:17:51 +0200
Message-ID: <20261122011809.2667684-9-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122011809.2667684-1-jarkko@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: t3zmigionhkjahk6kdqstweraagmbhsn
X-Rspam-User:
X-Rspamd-Queue-Id: 555A5100005
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795310331-138796
X-HE-Meta: U2FsdGVkX1/usPScIRg/tKAdZ7nnVLshWU+Y2GzdXQbYWRV+Zv15C+Q8w7eE2W4h1MefFqXPjCofmJEsvWBPeVcd1kdh4J1qsXXjAEJGPEseBQfAGYf2U7tbeE4t/CqZv8KGXZ46/3KkgYH/hgqrOhDp7rA5gHw5PkBE4Drfa89uva36EcjsLzWYUb98GUgQcUbGl6IWSJXM7nI3Q0A926qBvMQ5mxus4toyZkbRbrwUuzu5e3HDf8t8qxehjlVWxyvR2PNYFgKITXcsyccg6KXWBEatROg/BfYZISDGZwgKSSK0WmvL4HHPDrwnCsYmCgMKa6LXe21i/6EAPsP5sPpkxxXuqzwe0yU5wyg3u4Y9oIMIo8tFU9a2wza6y5xDJxXRs1N681iRcimDUDY/9vM/9KVQT8SyHch0Yq5Ga2kk8XS8SfkWHWmwmJo3nsbP+PK529wA/k7f7hdIXsM9domNJqekiwkbcHUuUEc0ZRL8VX0f30e5nhUu0cSxBOu1y+6N6IlJwOHbjJw7mjfsXAd3vHy1Hae0CBkvEpq9pjzdMObLWbslJkrxuvFYAaRybdXcW911pcq6lx4NuM8hz2ooQ6uB6BV2rjE1xVb0MXxEO886GCwJhPsFxyNYGshfq7kTkxQdrTZm9HlANubZGThBGiUIyAZmmHAMi9CMscogdWHuVQHKwSnmumkRvsentGw+qOHb3WAld/mOhTHfMv0eDfVxeb63rGDt8bLlzg7vq5pDaws3wtVby2ve4PJXSxUebpMal26MX5Fc0T5OHtyeLXwLd8+V2quz5lJezSCrataO6LfYWScwzKkdH/nbpY9LeCqgDscmc5XbFSmikWqVXejkBePyUoEMLJtX5UWMLOIZArzNfzgmqctiKKcUFsIGTe0QAm3Bb2VYG0GMYhUn7GyGI3n/8OCYD/gRsqxs0UY2F+y4H2G9BsZhwk1q3BZWRj8A8+3J7XnZ4UQ
 JqfPaP7f
 rZxwbV9HC1Q+Fz+g9Uxk9s4e2pLNPBAfo9SsaBQ8VxIfTx94SC1oKBhFaksFpVn41dXGqNZ7dIvDNyQtJ0cHTlfo5jnXbIrjdcwgjmSuaQutxvsS++avQA/MKqIBn7aErUOADtCJX98pOnYK/s0ZnN+HXPCCclipPo4/6zBhK/ORXF0Yfva3ZalRmG3C94Xxv1sh355bA/TsD+02GbrtY7oVtdVzQLtfengXkaluL5xjSR8kk5BZm/dCgK8cmFCk9J76ke/98w1vh74iw4/tPaiVLBSm4pgnKbqSCff40ifMi35DGhfiRXvMwl1Omsy8j4+4ZO6gJ2GNRSXXYoe+V8Vxg0/r/C8h4hUbkCvYts5r0PRsQE0Fz4zq+vuaKtsqR0wiMiIaQSUIV+U16yR/T0z4efJXRPcwgd39VVA3c/CSxzg0C8M/aXgDYrWHY+RrRL465gIiE2qcRzNbunV2gVuBuHpQicVChdJ9StwJR6D5ispY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

userns_install() updates a credential's owning user namespace and
rebinds its ucounts inline, which cannot be reused by fork paths that
switch a newly allocated child credential into a target user namespace.

Factor this logic out into install_user_ns_cred() with a !CONFIG_USER_NS
stub so callers outside kernel/user_namespace.c can install a target
user namespace on a prepared struct cred.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/user_namespace.h |  7 +++++++
 kernel/user_namespace.c        | 12 ++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index b4a50edfe003..ecee91aa2257 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -182,6 +182,7 @@ static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
 }
 
 extern int create_user_ns(struct cred *new);
+int install_user_ns_cred(struct cred *cred, struct user_namespace *user_ns);
 extern int unshare_userns(unsigned long unshare_flags, struct cred **new_cred);
 extern void __put_user_ns(struct user_namespace *ns);
 
@@ -224,6 +225,12 @@ static inline int create_user_ns(struct cred *new)
 	return -EINVAL;
 }
 
+static inline int install_user_ns_cred(struct cred *cred,
+				       struct user_namespace *user_ns)
+{
+	return -EINVAL;
+}
+
 static inline int unshare_userns(unsigned long unshare_flags,
 				 struct cred **new_cred)
 {
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index e151ffc1f708..4a8a2ea67ddb 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -1631,6 +1631,13 @@ static void userns_put(struct ns_common *ns)
 	put_user_ns(to_user_ns(ns));
 }
 
+int install_user_ns_cred(struct cred *cred, struct user_namespace *user_ns)
+{
+	put_user_ns(cred->user_ns);
+	set_cred_user_ns(cred, get_user_ns(user_ns));
+	return set_cred_ucounts(cred);
+}
+
 static int userns_install(struct nsset *nsset, struct ns_common *ns)
 {
 	struct user_namespace *user_ns = to_user_ns(ns);
@@ -1656,10 +1663,7 @@ static int userns_install(struct nsset *nsset, struct ns_common *ns)
 	if (!cred)
 		return -EINVAL;
 
-	put_user_ns(cred->user_ns);
-	set_cred_user_ns(cred, get_user_ns(user_ns));
-
-	if (set_cred_ucounts(cred) < 0)
+	if (install_user_ns_cred(cred, user_ns) < 0)
 		return -EINVAL;
 
 	return 0;
-- 
2.47.3


