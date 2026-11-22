Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B920606A692
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 19:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ML3xN9f1
Received: by kanga.kvack.org (Postfix)
	id A6E7A6B05B6; Sun, 22 Nov 2026 14:36:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A44F76B05B7; Sun, 22 Nov 2026 14:36:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95C056B05B8; Sun, 22 Nov 2026 14:36:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E5CD6B05B6
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:36:17 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A9D2F140738
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:36:16 +0000 (UTC)
X-FDA: 85463761152.14.A701B47
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 16AA940007
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:36:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ML3xN9f1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795376175;
	b=Vpa2Mf1a4XX2pC5b1fO9t9+2XsVGi+KLLTQfo3hApRxqwTNA7TIdvJdqyn54asp0KUJEg2
	t4JSstNKym5cpP6lkuKOFVxtJ/QKKoc8iOEq4OMqjdhxkHMWURDoI/86HO2XsJwsjsBxsc
	T4qogUwwDgJLzGMva2sSvqYICwHOqGk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795376175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vM1mKrQLSyzANBNyG1aKfJTP501fkwwz9TXQLi7bGuQ=;
	b=LWF0diNGaL7/1s66qvSsz4S8VeanKYMouS6+LASsSHzMFhYX11rEIJwI3np22v9YhVHlzO
	zIGFR4KUjZ7trMNmyCCGBduuV2ZTxw3cpaeuzED1OWl75ikLm8B7YCVdEoWS+Qno4K9i9f
	Sfxox6Fa7PwbkN0ZLw+xSEpFMl2Pq+k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ML3xN9f1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id A64BA61DA8;
	Sun, 22 Nov 2026 19:36:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AD8231F0093E;
	Sun, 22 Nov 2026 19:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376173;
	bh=vM1mKrQLSyzANBNyG1aKfJTP501fkwwz9TXQLi7bGuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ML3xN9f1NmOT9C4XtO9B3G/pEraSCkk+fGaUGxmfXkMSy6TKIXwr5mJ/3Vb0BQdJx
	 bc4Zgm5HzTPW7ytnpBWX+mvGnJJToKTeHouV6VOQ4K0ixbrEDJTitMQrGpBFHfl/YQ
	 Uupc2uCAxIGiBsYzn50mAhzkLjT7HECBIIA83ovrkQSr1W0+ZEjB4dtS+3WxjZm+DD
	 WUEB8tzZ2u5Ytdu9lYsERqyGEtHbrar1iun2ztFzU6sHSkfUhgdjFFouEhwNv/3QaK
	 mjpaCN5iKa1Kot+n2y5Rwu+az720n6eoCHJuGinUAhRjNbLRwVb6KGTnrvVjvRx6Kj
	 1lk1dgq8Y6CjA==
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
Subject: [RFC PATCH v7 04/26] mount: Add mnt_ns_get_root()
Date: Sun, 22 Nov 2026 21:35:17 +0200
Message-ID: <20261122193539.3334213-5-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 16AA940007
X-Stat-Signature: q88ihziqce7byhmzxdr1kanq51igf78g
X-HE-Tag: 1795376174-239941
X-HE-Meta: U2FsdGVkX18f9CIJTS9FJAAoZAXaSVv2DO74bv3LwPBP7pcshF2OoaXwvGMW3tKcAmGO8NWfWxekl2xNH/4IC639HWg1yESHAE1GqaMX48RtQakv/ElWyRr7Tuly2eraxW3Q/GguRp/Mk9It89cuZvd8CO4gFNjPX8zU+PDq15sD5KQX7F4dLP0prAgMw6+nts00quNNntI0Jflwn57iGQWYFI3VDwxqcJTCQHFs+WtwG8MFNQj7Lut00rkGMXT5gasWGj3gtMYz9RFlQCXKTJBAm+dhud8vE8wbPTI2k6ARqBKPGwj/gJbPzIsG+KTuXCk1dKp5kuZBIwnByPrfj7L5SANcbRwR+Ohm4DrIuqpojVtTpTijMNU9zCRDbJZH8yPsIYt/xHR6VjvJP7myiMpc7KRbpsrH2JjxI2bSFwQq5+xKXlMzROmST3kCGc9xw5XAQpeevqa53LHLH/bM5O7/65JNUr9fzcDJlM7ESf3mvYcvdueIUNXG9//W+OnxH+qE5jyKsBvJk2Iy/c4zWc0SB+smr4pakAber6NA833O7cTFuVwYYbK1fMXh53q+CMbGc/klQhFuqH4wf1o1btJrbKnp70sat9/WBLc33SWuvF2Hs9adp9Lmpzg2Px4CFpWXvXxihtDES3oXM6RZp7knQ4spaJd3yN5CZ3wyo7fLGOMlTjYfwh8zZTxIwkWczvJlKubDvjvNaqkAND1rwdhC54NKaqzIprYcEJf15tj7XcKq8LJBcCG6RpVYKHuvC3QUat4rJMjjGNZicbbCBLDOZMu71KcE++LTC5LeL9Uk4JIKF+3gQe8dpLp260WnwKY46kPGG1cJ1UdRq0VfXVBpAm+PKJz3o2YNaWElq9fJOeOQ8Y831KI24mWbSTmSQ31LoOqpjZ2e5YmmB1LvAMys0kGpSyYWuXQkRvaWvdD60rHi9LJ7JD7OiPBoURzLFNqHmLMIi2AC++yFygp
 +kTCJkjU
 NYMg0Lb6yuJi4SU6W6zBB6BMCkja62D6E+utTNUUlqV5sP1dmpc3Iv7W9xMjjtqscFhbw7goTt6H6kbuVvNKvYujHOT7KhunaodHd/s7eyhPWpEPE1tVTsPIcA8vg+NEgUGHo3WjXazmVd5yw5QzXo7737pfOJmi05gwghw59XStTqplciedzmDLSnqCIKmXebxWqA5pTf4pwQQtkGSAVKCmUI1p2F2z9iY+gE5EIa0QaKYuxLQAH5mKtKoB3pvppQJMgVkodKsPHElZ97kXrfEgg/ZucjxSf19ctPh3Ssf9U0FZ3A9p4wZPw4LIcx7RTBtw3SbVJahrTemMmn15AKXXk3E2QbyIv56M1x5K9zoCA6iOeY6hZvEOf/Tg9GIjn4tEVpsuDfcMIiwtDl5EhtwzO+n4C8jXcz6Um61ZNrAvlOvyXnqnBeU7oRNC2bPrEfuNio1x9fQZ3Q9DezNSfcDsBuOCu+ukWzsVacexN7HMfjM6+BSVzMqtUSIETQsL8NbxNsaEbfNng7f/2+tEnpKSANZt2+DsXmQFwpsdUyRTaEL+bCFW706HGmtl8kc37stoxRKozY70CZ5XgRqVNoa5SwGkBGYN9dAJ4KVY0NQ+Xg5ToLnEsxZN4KQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Empty mount namespaces created with CLONE_EMPTY_MNTNS start with only an
internal nullfs root mount until a real root filesystem is mounted over
it, and external callers have no helper to resolve the live root path of
an unentered mount namespace.

Add mnt_ns_get_root() to look up "/" with LOOKUP_DOWN from the mount
namespace's base root mount and return -ENOENT if no filesystem has been
mounted over the initial nullfs root yet.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/namespace.c                | 16 ++++++++++++++++
 include/linux/mnt_namespace.h |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index aecd05ac0170..781380945d78 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -6708,6 +6708,22 @@ static void mntns_put(struct ns_common *ns)
 	put_mnt_ns(to_mnt_ns(ns));
 }
 
+int mnt_ns_get_root(struct mnt_namespace *mnt_ns, struct path *root)
+{
+	int err;
+
+	err = vfs_path_lookup(mnt_ns->root->mnt.mnt_root, &mnt_ns->root->mnt,
+			      "/", LOOKUP_DOWN, root);
+	if (err)
+		return err;
+	if (root->mnt == &mnt_ns->root->mnt) {
+		path_put(root);
+		*root = (struct path){};
+		return -ENOENT;
+	}
+	return 0;
+}
+
 static int mntns_install(struct nsset *nsset, struct ns_common *ns)
 {
 	struct nsproxy *nsproxy = nsset->nsproxy;
diff --git a/include/linux/mnt_namespace.h b/include/linux/mnt_namespace.h
index 0acd1089d149..98188d1f7428 100644
--- a/include/linux/mnt_namespace.h
+++ b/include/linux/mnt_namespace.h
@@ -8,6 +8,7 @@
 
 struct mnt_namespace;
 struct fs_struct;
+struct path;
 struct user_namespace;
 struct ns_common;
 
@@ -15,6 +16,7 @@ extern struct mnt_namespace init_mnt_ns;
 
 extern struct mnt_namespace *copy_mnt_ns(u64, struct mnt_namespace *,
 		struct user_namespace *, struct fs_struct *);
+int mnt_ns_get_root(struct mnt_namespace *mnt_ns, struct path *root);
 extern void put_mnt_ns(struct mnt_namespace *ns);
 DEFINE_FREE(put_mnt_ns, struct mnt_namespace *, if (!IS_ERR_OR_NULL(_T)) put_mnt_ns(_T))
 extern struct ns_common *from_mnt_ns(struct mnt_namespace *);
-- 
2.47.3


