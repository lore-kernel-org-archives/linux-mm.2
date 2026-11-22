Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4177C606A32E
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 19:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jx9MYo4v
Received: by kanga.kvack.org (Postfix)
	id 27EDB6B05BA; Sun, 22 Nov 2026 14:36:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 230346B05BB; Sun, 22 Nov 2026 14:36:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 146156B05BC; Sun, 22 Nov 2026 14:36:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8FCC6B05BA
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:36:33 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0953FA74BC
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:36:33 +0000 (UTC)
X-FDA: 85463761866.19.CC04103
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7309940007
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:36:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jx9MYo4v;
	spf=pass (imf11.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795376191;
	b=tiu4zqN/vD1pQWm1etvFKZ/BpbvGIgmKqFY5HaclE7g5vw4EcsON34s8oxrXLh5uEt5OVy
	vdJWsT4UvnDYFLXRLL7eO/USrKPJSc/E89yp/tREcfLrub1LCTD0Tz/YGfRpnWurVZvlp/
	ChAAfVoigSaLhILkvG8PG3pGNg0lkFc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795376191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=43MsiEFgIrWkQNcNF+GYEjx93qeN3UcnPDjH27vMBMY=;
	b=WFcbljQizFpJi77yZDO2oXfCungwnSfXBSuKT93v2TmpxrqoOtTVLELscPlhc9MF0Ws+T0
	dMbU4KN2ZZdE9acg3zFXUfVRWZL5Qy3muxr1DLjuGAGHhAbpZAJyjHdJRn61ewQkWc+8Zs
	y4jgKGrmXsUPRkltot4F3JI6h6MB5n8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jx9MYo4v;
	spf=pass (imf11.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 0D7C561B45;
	Sun, 22 Nov 2026 19:36:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1E7691F000D4;
	Sun, 22 Nov 2026 19:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376190;
	bh=43MsiEFgIrWkQNcNF+GYEjx93qeN3UcnPDjH27vMBMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jx9MYo4v5dG6TuiLqqMpwfnCLNp1dU3fsjM0rs7NeUiQpqvCbQkc6zfNZfQn1ceCg
	 dkL6lAYTT/XApYv1EnrG/3bDLes3Ar8rT3NVk6CyizxCjxJOWQr/BQgKMnE4DozfXc
	 6MaZrPMCQKrw6XbZAf3J55qgj9MKKx8nvfOUvGoHcJ7/8yOdGVy1JssCARbZmF8vek
	 6kxEG95kGAihkM4HDqZ8n1mTcg/lmo4gtW2J8GayVKr+sLDzrsuUuDCALp/vF2d+2v
	 BPUR0GZ3wJ2zZz8SvSCUOuV/4ea/j5aB9DkmJvEGCqfWbjjKoyCZJsHY54JfZejPWu
	 dmVhu9cXx73XQ==
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
Subject: [RFC PATCH v7 08/26] userns: Factor out install_user_ns_cred()
Date: Sun, 22 Nov 2026 21:35:21 +0200
Message-ID: <20261122193539.3334213-9-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7309940007
X-Stat-Signature: 3nqrpy193mogkctqnejdyrru44bt6tk6
X-Rspam-User:
X-HE-Tag: 1795376191-482281
X-HE-Meta: U2FsdGVkX19hc9nS9Oh02YMtKQSSCyX3TTgKd4NJ2mipExCu/gxq9K+NeB2OMHM7RkKPZ8uCQCO/6mdnws0ckTDGJ1er3vT+SUim2dyDfwzkCZy6v3ZdybqtT3wWJa0tjjF8fTCiEX3sna/24WoQXOOT38MaMvP1uZWAgcGxkE6ao5wG7miLCFm7pTp6JZOtVZ5IEN+4d4NCpZMr/oUQEtSVCLYelnTrTwINqJVnjsncd6dJnmLT3zz1VqvcJplwCfGc0ESF0soie+r914YXAnCuMtEog6qgffGUSoejulJUkluMzVaVJHJo6xcFPNZvt0je2g9Y+KZ9RJ/lP5+iPVNQZzftT6K48Ze276FDO51IM62ShZgXtLcmmixly5F69NypyndJuFOITqzJss8EnCGBEuwgexeAShq/5d6DkGqye7t3Wzv070aIPnmjPsMfkGJnZx0BM3G7tyTPTpuM5WIItek+l/+FN4Vz5hPHv0rJjE4yi/FSDfqXvoF3Bb0X3kWw6H6rL1Sx+O1kErWj27kjQNKMVN9QQ5SdVKdYW0GWgDStErt8Rn4PcFfNcWQw5Ip7j13JRdJERW55XHzt9fk6FIbsy1RcU0J9qWGdkdS5Xk2Q03Q/4utgaC9XrveHkvfEGskLaUaJhjCdRiadH7QKvkdjRXzcbKt0uKHiI+CPQyRPWICRFVfoAR7q4J5MPYdy+063AL1mr+wPTLBeAq9jFQoHJynpS0/ZblUa7JscCPchXyVDiz/o4sJB8JjdOcfjj3Oet0xySgAbsyanzeS5lzHlXJTdD9Y4MHxjfiUxOnNBIuw9A2xR5MBFIPaFkEU3ZX0GuUw5TC6Eb82gk6WDxEsFY1x3B2vorP9TxFFFdxyVzn0y66PKPNmJ9st7Yuoc//azuw8J1EE0dMJWPXZyxfDTqT9bnmvzEN/naP/ReM638UZM3dWVn+3/Go1R38C9wiwrwVwuzqYBndn
 pMUX/dTD
 cKNIiR+l6lVg0ov86t7Sc8frAw+gMSBHMwfm7CuYn/wIIRTfFvzj61V5XxdJXzUOvKatD26RiL2b/wtSBiNW/1QXfq6Xw6iVs+8Kjuc/yIXAVB3S5M95C2vN/FXRL/o7KvJFx9qVxpMfDpZvJBVpeP9pfHPyLu4G89dO3yTZOub7u7vbJU2E9E3vUjSnqm0MJXnrfGe21ZSK32xQcmTf3dSDZhbj1ZyX+FTFO9jvhZtJssuJfwk5XN5xF1/OOz5d38x7ISuLa50mOJwUZVJG7cSNgsGdlVGBoS/aJksNK3OlmPmvObF1OM9BjOz+7WI8wpmJecwhBCSfP4sfF2ukg2Bo81/LMigjtgyy1kn/X7xHAO1MXC3WYcvJY/T0+4w7U8PJ+Ph2ERp7G+cJZTARHfP4y/lsILFT+zfEg4jADzaNTiDamCdqKxcW9ZGdFU4kt7W8VuNFA5DilyzA9u+E5zCCry453dSrVYFJAhWh52ssoPEc=
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
index 61dcf2fab6f0..218ea4e73006 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -1613,6 +1613,13 @@ static void userns_put(struct ns_common *ns)
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
@@ -1638,10 +1645,7 @@ static int userns_install(struct nsset *nsset, struct ns_common *ns)
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


