Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FE43606A69A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 01:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iVfzBuYl
Received: by kanga.kvack.org (Postfix)
	id 0F75B6B05B4; Sat, 21 Nov 2026 20:18:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CF7A6B05B5; Sat, 21 Nov 2026 20:18:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F26DE6B05B6; Sat, 21 Nov 2026 20:18:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C2AB16B05B4
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:18:37 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 46BAB120631
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:18:37 +0000 (UTC)
X-FDA: 85460995074.10.6A3FB97
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id ABF5440003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:18:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iVfzBuYl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795310315;
	b=M0hHOSh2BMtRQJb4dWSAOAhCy5+CPXD2EefGiZaxD3jqN5x0bONd1mceZwCDugofftWQvF
	z2cxyihewCMXDHDdFCDrKIeQm02Xgeo+qx6y1C9gLFnhgGyElXjdUVzUn8oEsMYxO5Oin5
	a32FseP65Q31G4tUC0MuIS1WGFZXdrI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795310315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vM1mKrQLSyzANBNyG1aKfJTP501fkwwz9TXQLi7bGuQ=;
	b=313gbtB1JznVM0un2gaHgQSkAyOIXI5AQsDb5kBC5D2CQtdSib55iZnr7G+6ZQ0bDHGl4P
	Mjgsgsc8b7/70rP3cFeV1lfFf9ltnK6KOAaA0ix6F1lhMCBPOsUJx6q3Ispgjn7wG+PpVV
	qvclQ0tFNwCGVqsrGBQmTZRtCxbShWw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iVfzBuYl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 4AA9160D76;
	Sun, 22 Nov 2026 01:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 537E11F000C0;
	Sun, 22 Nov 2026 01:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310315;
	bh=vM1mKrQLSyzANBNyG1aKfJTP501fkwwz9TXQLi7bGuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iVfzBuYl9D5EBPT4RUFYpdPXpt9xaEmzAk8iNSi3aHEVx0ty4J0tWRQaLEXFojX+t
	 JITv1qQ0mH7a4uMK4X9x3tf7ZAYfr/OcZ8IZJgGYGCeIL8zMeFPqBYvdUbFlOTGs7v
	 IBFX+bLKTFOyKKNRSJpg9qROz3I322jsgCLg1l6aivdJl78o6k17Q+xI9YcBVAsv2W
	 BT/lpVDAofPBfRN973YskRwER2LF2hilLpbaCp/58nYiVsSzE+UorBYbqlJ5ScenuI
	 JVzqiK/VGwCFs3WBI6Nd47ozM9A6ALKSH/3jgsri7hUZljkUdalZ7Va5FpbhKtVJ3c
	 cyqt5wPhz1Qyg==
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
Subject: [RFC PATCH v6 04/26] mount: Add mnt_ns_get_root()
Date: Sun, 22 Nov 2026 03:17:47 +0200
Message-ID: <20261122011809.2667684-5-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122011809.2667684-1-jarkko@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iopz6tfr76p5udo4cn99iuz4wsbb47od
X-Rspamd-Queue-Id: ABF5440003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795310315-165308
X-HE-Meta: U2FsdGVkX198EwmO9DIbx37GkZlmGyvwkYb0X2jKy73VUR+HNZ2kkn+hs63AD0E13lBwMvg+LgpafyypDeUKYCwN5NAkicNm1HgGM2j8U1iHKHDv1R1zQkPlUAEaIZbQ55cMmPb+w5VaQ4dCUDfmwPV3eRl5VxF/bahCoivpZeqafDKQI+yVjj8NTMPTY/eRmhP1Q+1pIQb1iAkZGzEJPSp9DQB25OZ+ETir9xAfaF7mDrGW4m7gausJJ/wSTsddcU1xKvWdwqBWBY1jJDWHtKs+NdtljfAYiXvpqPCoxZ3ReZ1lzNYxaDez4tPmmE7dBfU7RuNkQ8LAwpGU3xdHAfzpHH3F3HB5l96uk50SIBa4x30qk5gi+K5NifAnx9E7vwJIwGX6Xb0ejL5PZphLlddzBVlfVNi/bH5g/jsPt2jTRf7vtLdU1MZQ54NAUGub3uNVlUoGC62ycrUWcYMNIDjpBTQxRkjQs7GgluVcE46WJ4sRrPoODjiGIDVyE//SCOsVehObGth9ChlXZDbZ1k2JHrcJD5a0NRdsSR765AKXZ7EOaNTTh+dd+j9HhWhU9LWvqtiGk5ze+eUveGdaucIhXlKdyYmJAYVX14pdzXCMyEw3tdnfzZMHEbCrfnrLMaqIbDZ73vYUz2QpFPn/t1NPIOVfAkHlXV1CP8smWYFy0bH0EV781tpCo3pKYQecY/RoicvmHuP5/WeX1lAvgbAyAwwDFRiYQ8x9eM4jfj3CG7arnsgaCVsB2SncXlW9q9KajMH2rFxaJKAEYnEO2ssjpi33IjihHTdAkA+aZ0U7q//e81l1RkIFWrGjogRXfhACHgkN4q/GTF6e32vsaXYCZniHToPMkFl4eIEo8rmvoRFwmsD1dl+H5NHfzNZOjl83kfr/J3b18Y0ZTqbfuIfBhO+5wmUv0XVBDsYpxWyJVOe6FE7uhWaKpNN1Hl4Lc3KdYXnAPjG9tifewGO
 PVBh5Z4d
 EdXucNRvnVUCnO8D45SRBF3/87CxBDUsfeYXynV+8boPF/KCp1idLo/406BoNA/5l8JcWA+Yef/3oBMfJSTaD0aET0LsbOE1VI+pqlt3yK1Shwm+yxyiX6JsL/t3eRFK2nHYdrDMRJtYCOho8t8nns+vDWoLON2ca4f27r8PslewDJLa8GBcVwLPMZ7VkyMSMNf023M8dWfSp48KqTHViFyfmPfY+cQxLE/5CWh0aSINjFANAD18xNsTaYwqOPsvlYa8eWGEp3K4WXxIWSCa9xO9f+wZbR7sNUUmIb9CwEIxGXNEBcgQcR4exaXveq3G3iR01GJlvKgS9DecdwtleqAAFcAjXLoSdGPYRTWAF7TMMOM6k9qi0ne+K9xZ+sOHpR0OgRdbQy5c0STofKniTVN1hVaqdKGZE1rXD1WmzYT8gTml0KaQFkY6nJmMUPzlFnFjwjVxz7zZlp/PuG1SmPAWz6kMj/H2LZw3TtE3OfRp3LGI=
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


