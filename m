Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 919AA60A2636
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 00:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PjkwYkKd
Received: by kanga.kvack.org (Postfix)
	id C24316B05BC; Fri, 20 Nov 2026 19:09:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAD396B05BD; Fri, 20 Nov 2026 19:09:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A75BC6B05BE; Fri, 20 Nov 2026 19:09:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 78D076B05BC
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:09:32 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B33B8A0177
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:09:31 +0000 (UTC)
X-FDA: 85457192142.15.5F48061
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 07D8120008
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:09:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PjkwYkKd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795219770;
	b=mt3QmbsIIioGFXUtlYUvomtjzBj6p43TO/MJRTKHdxo40S/l8O8JGLuctDdBJhHJrYEvdt
	7PZlGyRIx7izkHUa/42xDuBp3nVzOQF9QV4uimC4HjMnwXVZyaKM7+0u8broXgd0RZNYbM
	WlBZkZzLPsDVGPjCu7lkTyep9q49BH0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795219770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QAqFmScxDK96ARrPMkdYt6ltTuR2f/mUkkm/Cf8C8SA=;
	b=qQ8lRBLoZvvbJgj9AVK0cniUYSWu6CeAUl5sbKpPiBZIyIvOEJJr/XMgGRwMCGGT7vcZMh
	2ejyFAiSRgimQ58KBUdtiaUCw0H8F8FX6orREWZMzRnMgJPd1+eV5BW3Q7s3EgDZpCvKfa
	sM05Y9gAGtNmrnzhJ7Jxn/d70LvQQmg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PjkwYkKd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 55A784422E;
	Sat, 21 Nov 2026 00:09:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 999771F000F0;
	Sat, 21 Nov 2026 00:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219769;
	bh=QAqFmScxDK96ARrPMkdYt6ltTuR2f/mUkkm/Cf8C8SA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PjkwYkKdZWa+FpnkuNj9WLihIAT8nxjelhtP8KteYzyEZzcTjBsf2OisnnyMG6tGY
	 QAHoa48bYCuqQz0VDKOTj9nKmMYLKckqWx+bGkMzJy9/CCAehLARI6jDFOS6fkW9va
	 k7PN8OgZ+OrfV9jQovdEyPZbxEZ4+zO/I0/GSVzMnlNssJyniwlZuurB3kjJbDV+tk
	 r40I/gT/wAMqhGqxL4XqL1ay693kqSK++3z4BC4nujf+MC/JFpepQrchSnAHpCWt0a
	 mlyMSXy9N/DKAW5+SGI1/m/LToFbGlsIr6msn1XPYnXuy/NzEEV1++n6OaWkdpoRKC
	 5asuyRqrYhKxQ==
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
Subject: [RFC PATCH v5 08/25] userns: Factor out install_user_ns_cred()
Date: Sat, 21 Nov 2026 02:08:27 +0200
Message-ID: <20261121000844.1863324-9-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121000844.1863324-1-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 07D8120008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: xf5usrsbz43dzt8iq7qzg1amdzqxqykf
X-Rspam-User:
X-HE-Tag: 1795219769-999958
X-HE-Meta: U2FsdGVkX18aH4VrWvsr7Jo4UN6c0MH6+HNQ1h2PX2g6lMoIjCEcTHsIiRVWnoFjNgnfX9QKc4lG6jTY9VdywbMfqOXgu10hF2bzOlg+xweikfK8fYmnHaRx9pcEPl4nOPPd6faMW2quJkOpz9ezsnP9PqVglBxr5gOMwRkamsI29W9ZEq1FDnvNeDOtsxyD+LN1/MGoCt7QEsGpeBIg8XRhXZeGJBWDnrzPWFLlRhB6N65GE4pMqIZsEApjeSNSTJ1JzVQeLgJ77MkqfmNGdP/7neOzcMHo+XoCsgk6QN5qESWY2LDX80c/xSKo7uVws8+qISNXd3N/cLzVelzE8iUXLQBd71U5Rp9osPR29E8//NINhxBzB11qex1aWGTc2as79QARUl9e1Z2FrU2pMiVwFVBiE1QrigczryzNwnMF9gUzU59ujaeADYOeU+W2Kd9Ief0Raze6teQ06tiaJWO5ZH1b4Q7oiVOGbnS0b7qmlgc7fMMiVO/2h3g+9orD7VeLo8WWti6uLNKyJ9t2ZojZaEoXftkohLNlSVc1CRdd50Na0yKSs7mE2qPw3BFg1CTxOZDmlg4BtIlyzNieJdfbpfqMQhXLCAcbgGYZMw7LJtzYF2iL67sBSOSL2kXZxC4/GTq/C37vpDtNeLuy5nNRQLPPfWFLks8WjAQnNk9Wbw+dCQK1s/iwOL88u6M+g88FXSmCrPL3mqtGnY8FoNHtR2YIOiYPE4M4XSq9VUPzXUogstQ+fO64K3gyy2mvJrnaWFmUdnhGknR/e1NMXSbx5pyIBy4LySxTcuzlkcCxPm2zkBCFwq6EuyJaSYIoiCYx25DKbq2dwi/I9IIAM9lDEo4+qCkCu1qHd9zc5uOlWVygqRy9JCfFTqN5O9yZPNA7tTT0NMqgtL8RHfSNbtXeL5fplN/X1VaTrnzbNOYtqCbCkai1OsMdI0hQ+/qrggpfQscNWjeSwbSljgN
 olTHIjbD
 6VbN6l7wMFbE42xRdwjT5I5yJbEWudyhsosJ7rmjnIQd8WF+BWCpUZcquI0MuGlRLkWz5EMIEfYBjjjx1J3T6N3tkqzU0yoPO/9zqHsFgh2ydPNy9MEqd5B7FQN6z93gWlQ1nICx6gKNBfGG8s/kukO8c5vck15LGxjz35gh5/0fZggQIwnkEzg5CO8iTi3CsrlhuE8n7f7G3AqpZjzc0xSifSW7jBVEWuN6h91KKpXTRnN289qALBKWZHCIZI9zLyGxWdovdiaYkEVk/OhquHhp3UHQjG3FoAUsXhCPODbBz+FRaaqZRXOsc7Aw3ePSS+tn5tG6Gs+SkDRRMkS/AboRn5kJZp4BUDPj5JSfPn5NvABN3xTua83c4KVPuN1xiTgivEdoKbOaOqRyAwVjIHRdy812OCar54VEN/9dTaYKXMg6P3yg2asyB3TllyoLe0Ku7jdGXExE8Sr5VCUn0HDWqpAjsvGOY8+BYkHOEKuLZPMk=
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
index 91232053775d..3600a903442e 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -184,6 +184,7 @@ static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
 }
 
 extern int create_user_ns(struct cred *new);
+int install_user_ns_cred(struct cred *cred, struct user_namespace *user_ns);
 extern int unshare_userns(unsigned long unshare_flags, struct cred **new_cred);
 extern void __put_user_ns(struct user_namespace *ns);
 
@@ -226,6 +227,12 @@ static inline int create_user_ns(struct cred *new)
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
index d7f2cad388c8..4cf5d802032c 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -1632,6 +1632,13 @@ static void userns_put(struct ns_common *ns)
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
@@ -1657,10 +1664,7 @@ static int userns_install(struct nsset *nsset, struct ns_common *ns)
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


