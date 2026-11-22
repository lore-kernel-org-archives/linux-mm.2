Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BAD0606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 19:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DFiqTxJB
Received: by kanga.kvack.org (Postfix)
	id 675676B05B1; Sun, 22 Nov 2026 14:36:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 626536B05B3; Sun, 22 Nov 2026 14:36:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EDDE6B05B2; Sun, 22 Nov 2026 14:36:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 228616B05B0
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:36:04 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A552C1C4126
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:36:03 +0000 (UTC)
X-FDA: 85463760606.17.0737CA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 07401C0008
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:36:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DFiqTxJB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795376162;
	b=EwKTP/q1VFRIYQ9lG+2jG/JkpKK2tzAzXHfjrw4gE7+Qt7kr7CHKi/GFEwIi00F0nmn9gB
	H0XDVszhvUCaPmHhwNyjXnzQWzS9XWmLDxR49zidbvmnwIw6a9WlzuYm1k+VdkiCvRP9cR
	+ktDq85iH8HCCY1l4hZdFODQe8sgZ+w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795376162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PxWsspzEioIIwUqnuiIeYKp1fTe5D8PzGx83Wd5XdHY=;
	b=N5S7Ptza3Q9dj2n/CrNl6o/sT2zemS66pYq6nRCLfg3Dno/bejBRb2KW8OWGNblSDIQENE
	RqgxJOJV/GeKypvJ5HGNeMYDtKHDsDfHOKegUksq3trjrvwpogedL4F5+OA/8RJ2OA5ZCW
	U50e0To+NsNbPYl0PgS3Wst8VvDb/Uo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DFiqTxJB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 06561443A8;
	Sun, 22 Nov 2026 19:36:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C697E1F000C0;
	Sun, 22 Nov 2026 19:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376160;
	bh=PxWsspzEioIIwUqnuiIeYKp1fTe5D8PzGx83Wd5XdHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DFiqTxJBeq3OOH2VDJJY2sRb16klNa8m8RHt5Abh/YsPImOZ5nu0uM/UuMH+1ycLe
	 S+SXiQ9ZdkEJGKkPN8frshQVWuicTWsoG5qYiFtE16U0SbJ6N0d/pprgRSmcbMWB0L
	 0fc+vdB1MX5xOtwmvvCKQVbCxtNDWEr972W+bhnrLZB08bFuYj96P+xs8sX24UVzV5
	 vR6e0SgrDbPp5c3KER4nWHsM3H80dhGu3haKOn8CZtqET9eS+adDfRk0TJeYI2DcSh
	 DNDD/KxSNtFTnTtbxIpVpUpwPU2Jqbe3L0B6Jmlu7Ie34V9iCvX0vbkLcG4h/jk/TN
	 FUckdOsdfl/JQ==
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
Subject: [RFC PATCH v7 01/26] userns: Factor out idmap validation and commit helpers
Date: Sun, 22 Nov 2026 21:35:14 +0200
Message-ID: <20261122193539.3334213-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 07401C0008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 8hpsda9eteuncghgh9nncg3a9g48hd7y
X-HE-Tag: 1795376161-943007
X-HE-Meta: U2FsdGVkX19nC6nBFjvyL7IzGypTUo1r1MhEKSaW3mtKTgZZq6ur4ZaAxgdmNbKAeYZCmTuaDEoz0PlAeIvPcTd6qQguT/6Mqv7VAC8t+CMVs3eMNw4qTKUjKKj4ZauWkYFRAs6/SjSc2Jngt8Q0Q5xnUPTwFCFDOBIxGpLNp3jstjaIMxa/Yk1z4TJircfxxUXT70CPkUouhoPbcT8nRpmgMBmSTjqtNU7bCqgypszR+qyepeBR4l7chPF4gWEBj8hqU8zzf5iAb1Q/Ofley5zkTI5tyage8lbGHKXil6Fchj13kB653n25kXpw8mGFHH0W3T/gR4WIPdO63ro/ZavyDvqRe3ehFHmqroy0EHpqi6HJCgh0wQzVj7v8+HCWqmkmqBdEBH/QzctJTW12CyqTCU8pYjZxTErEwEPFqaGS9xZMxnrA1R+mtLw2eSIZZIfNWBe0YNqPtc9tCq8qjPKXrB013hU/3+gPEcDtach6Ut/zjh+OEx/WLif6fC9tO4mChWS1Amdd1KQdqHOxwvJzqmSn44Bq1kWeUPSXpps0ygOPZpVY7rXCnyiPDPGng7crK5eRmUMZlFUR/Xwejnvr7hlU/4ai6k0rwVBXGKgEbx8jFGYnJ/bF3tmAkqFqPA+4YJVjbMbzvaRpnODigsQWmaeSOcPjM7myhKoi/ImpSoL8YfGJM2dJP1wHP6lHNnEGnjNIC0DeVFobOsd/ACiTO3rMTPMUivti8Wn7kIfh/YHt9Z+z4zUAskNNJ+6TCNC5F2kcciuxAPWKBpOx497e/Rl0LB5EY8He12qniK5tmIiNbgdVl0sg0VERBf2rg+sln3pQKrDD0QY3QPq9VkoY0PC/oeMc+pObe1wP+sfFbsevX3X+4dG3mrFcrL3lyj6HdrEldWYWp03l8NDt3m3lWXEMe5TsnRh16GGZDiDDgrbngSo3ejfd9meIRCUSBpAoXWERzc8HVJiy+1q
 O9oiTD/T
 EWLPjXpH8RJos32JJ0tHt8akjE++w7wRUrZbTicadllAs38qHPsiEnChmwXBYR1h+Z83C+a+0nHghdsZ1FGHknO3vAlseZFE5ZT7CheVkF/oPxU7CZB+JnaJ0sH/9/XCiMFxKcyfN0U50CTW0CZ/0n9OvPx8LtDHFuvvNlDxeCPPjKEtul2wWfmOAO63ziq68nSlqMgUmkaigY6p3gFsvDlULtVom+E/oR4Q/M4833egtl74qgIS4/5Aruf569pj/LZQjYQGyaWtkcEjjyGC3BSFL9wjpftDnHGTXoKwWcSYDVBJquP8C8QfeRuW40AqmlEGLmgHQGDdiv5UQa7WirP9+SJT3hBC7KhiEdETUJPyFxa67MeFSuSSq0x7Ogl3yORykOCwQbp8vQTBWjbhR/QKXgi80hdpsJ2hwRwDpcKDwM7U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

map_write() and its permission helpers validate extent ranges, check
root and unprivileged self-mappings, translate parent ID ranges, sort
extents, and install the resulting map inline for procfs text writes,
preventing non-procfs callers from reusing the same validation and
commit path.

Extract idmap_maps_root(), unpriv_idmap_permitted(),
validate_and_insert_extent(), free_new_idmap(), resolve_new_idmap(), and
commit_new_idmap() with no functional change.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 kernel/user_namespace.c | 229 +++++++++++++++++++++-------------------
 1 file changed, 122 insertions(+), 107 deletions(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index cd748e1cbace..caba2ac33077 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -884,6 +884,22 @@ VISIBLE_IF_KUNIT int uid_gid_map_sort(struct uid_gid_map *map)
 }
 EXPORT_SYMBOL_IF_KUNIT(uid_gid_map_sort);
 
+static bool idmap_maps_root(const struct uid_gid_map *new_map)
+{
+	unsigned int idx;
+
+	for (idx = 0; idx < new_map->nr_extents; idx++) {
+		const struct uid_gid_extent *e;
+
+		if (new_map->nr_extents <= UID_GID_MAP_MAX_BASE_EXTENTS)
+			e = &new_map->extent[idx];
+		else
+			e = &new_map->forward[idx];
+		if (e->lower_first == 0)
+			return true;
+	}
+	return false;
+}
 /**
  * verify_root_map() - check the uid 0 mapping
  * @file: idmapping file
@@ -900,22 +916,9 @@ static bool verify_root_map(const struct file *file,
 			    struct user_namespace *map_ns,
 			    struct uid_gid_map *new_map)
 {
-	int idx;
 	const struct user_namespace *file_ns = file->f_cred->user_ns;
-	struct uid_gid_extent *extent0 = NULL;
-
-	for (idx = 0; idx < new_map->nr_extents; idx++) {
-		if (new_map->nr_extents <= UID_GID_MAP_MAX_BASE_EXTENTS)
-			extent0 = &new_map->extent[idx];
-		else
-			extent0 = &new_map->forward[idx];
-		if (extent0->lower_first == 0)
-			break;
-
-		extent0 = NULL;
-	}
 
-	if (!extent0)
+	if (!idmap_maps_root(new_map))
 		return true;
 
 	if (map_ns == file_ns) {
@@ -938,6 +941,103 @@ static bool verify_root_map(const struct file *file,
 	return true;
 }
 
+static int validate_and_insert_extent(struct uid_gid_map *new_map,
+				      struct uid_gid_extent *extent)
+{
+	if ((extent->first == (u32)-1) || (extent->lower_first == (u32)-1))
+		return -EINVAL;
+
+	if ((extent->first + extent->count) <= extent->first)
+		return -EINVAL;
+	if ((extent->lower_first + extent->count) <= extent->lower_first)
+		return -EINVAL;
+
+	if (mappings_overlap(new_map, extent))
+		return -EINVAL;
+
+	if (new_map->nr_extents >= UID_GID_MAP_MAX_EXTENTS)
+		return -EINVAL;
+
+	return uid_gid_map_insert_extent(new_map, extent);
+}
+
+static void free_new_idmap(struct uid_gid_map *new_map)
+{
+	if (new_map->nr_extents > UID_GID_MAP_MAX_BASE_EXTENTS) {
+		kfree(new_map->forward);
+		kfree(new_map->reverse);
+	}
+	memset(new_map, 0, sizeof(*new_map));
+}
+
+static int resolve_new_idmap(struct uid_gid_map *new_map,
+			     struct uid_gid_map *parent_map)
+{
+	unsigned int idx;
+
+	if (new_map->nr_extents == 0)
+		return -EINVAL;
+
+	for (idx = 0; idx < new_map->nr_extents; idx++) {
+		struct uid_gid_extent *e;
+		u32 lower_first;
+
+		if (new_map->nr_extents <= UID_GID_MAP_MAX_BASE_EXTENTS)
+			e = &new_map->extent[idx];
+		else
+			e = &new_map->forward[idx];
+
+		lower_first = map_id_range_down(parent_map,
+						e->lower_first,
+						e->count);
+		if (lower_first == (u32)-1)
+			return -EPERM;
+
+		e->lower_first = lower_first;
+	}
+
+	return uid_gid_map_sort(new_map);
+}
+
+static void commit_new_idmap(struct uid_gid_map *map,
+			     struct uid_gid_map *new_map)
+{
+	if (new_map->nr_extents <= UID_GID_MAP_MAX_BASE_EXTENTS) {
+		memcpy(map->extent, new_map->extent,
+		       new_map->nr_extents * sizeof(new_map->extent[0]));
+	} else {
+		map->forward = new_map->forward;
+		map->reverse = new_map->reverse;
+	}
+	/*
+	 * Pairs with smp_rmb() in map_id_range_down(), map_id_range_up(),
+	 * and m_start().
+	 */
+	smp_wmb();
+	map->nr_extents = new_map->nr_extents;
+	memset(new_map, 0, sizeof(*new_map));
+}
+
+static bool unpriv_idmap_permitted(const struct user_namespace *ns,
+				   const struct cred *cred, int cap_setid,
+				   unsigned long ns_flags,
+				   const struct uid_gid_map *new_map)
+{
+	u32 id;
+
+	if (new_map->nr_extents != 1 || new_map->extent[0].count != 1 ||
+	    !uid_eq(ns->owner, cred->euid))
+		return false;
+
+	id = new_map->extent[0].lower_first;
+	if (cap_setid == CAP_SETUID)
+		return uid_eq(make_kuid(ns->parent, id), cred->euid);
+	if (cap_setid == CAP_SETGID)
+		return !(ns_flags & USERNS_SETGROUPS_ALLOWED) &&
+		       gid_eq(make_kgid(ns->parent, id), cred->egid);
+	return false;
+}
+
 /*
  * Parse the decimal u32 at *pos, up to the next whitespace or NUL, and
  * leave *pos pointing at that character.
@@ -966,8 +1066,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 {
 	struct seq_file *seq = file->private_data;
 	struct user_namespace *map_ns = seq->private;
-	struct uid_gid_map new_map;
-	unsigned idx;
+	struct uid_gid_map new_map = {};
 	struct uid_gid_extent extent;
 	char *kbuf, *pos, *next_line;
 	ssize_t ret;
@@ -1002,8 +1101,6 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 	 */
 	mutex_lock(&userns_state_mutex);
 
-	memset(&new_map, 0, sizeof(struct uid_gid_map));
-
 	ret = -EPERM;
 	/* Only allow one successful write to the map */
 	if (map->nr_extents != 0)
@@ -1052,98 +1149,28 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 		if (*pos != '\0')
 			goto out;
 
-		/* Verify we have been given valid starting values */
-		if ((extent.first == (u32) -1) ||
-		    (extent.lower_first == (u32) -1))
-			goto out;
-
-		/* Verify count is not zero and does not cause the
-		 * extent to wrap
-		 */
-		if ((extent.first + extent.count) <= extent.first)
-			goto out;
-		if ((extent.lower_first + extent.count) <=
-		     extent.lower_first)
-			goto out;
-
-		/* Do the ranges in extent overlap any previous extents? */
-		if (mappings_overlap(&new_map, &extent))
-			goto out;
-
-		if ((new_map.nr_extents + 1) == UID_GID_MAP_MAX_EXTENTS &&
-		    (next_line != NULL))
-			goto out;
-
-		ret = uid_gid_map_insert_extent(&new_map, &extent);
+		ret = validate_and_insert_extent(&new_map, &extent);
 		if (ret < 0)
 			goto out;
 		ret = -EINVAL;
 	}
-	/* Be very certain the new map actually exists */
+
 	if (new_map.nr_extents == 0)
 		goto out;
 
 	ret = -EPERM;
-	/* Validate the user is allowed to use user id's mapped to. */
 	if (!new_idmap_permitted(file, map_ns, cap_setid, &new_map))
 		goto out;
 
-	ret = -EPERM;
-	/* Map the lower ids from the parent user namespace to the
-	 * kernel global id space.
-	 */
-	for (idx = 0; idx < new_map.nr_extents; idx++) {
-		struct uid_gid_extent *e;
-		u32 lower_first;
-
-		if (new_map.nr_extents <= UID_GID_MAP_MAX_BASE_EXTENTS)
-			e = &new_map.extent[idx];
-		else
-			e = &new_map.forward[idx];
-
-		lower_first = map_id_range_down(parent_map,
-						e->lower_first,
-						e->count);
-
-		/* Fail if we can not map the specified extent to
-		 * the kernel global id space.
-		 */
-		if (lower_first == (u32) -1)
-			goto out;
-
-		e->lower_first = lower_first;
-	}
-
-	/*
-	 * If we want to use binary search for lookup, this clones the extent
-	 * array and sorts both copies.
-	 */
-	ret = uid_gid_map_sort(&new_map);
+	ret = resolve_new_idmap(&new_map, parent_map);
 	if (ret < 0)
 		goto out;
 
-	/* Install the map */
-	if (new_map.nr_extents <= UID_GID_MAP_MAX_BASE_EXTENTS) {
-		memcpy(map->extent, new_map.extent,
-		       new_map.nr_extents * sizeof(new_map.extent[0]));
-	} else {
-		map->forward = new_map.forward;
-		map->reverse = new_map.reverse;
-	}
-	smp_wmb();
-	map->nr_extents = new_map.nr_extents;
-
+	commit_new_idmap(map, &new_map);
 	*ppos = count;
 	ret = count;
 out:
-	if (ret < 0 && new_map.nr_extents > UID_GID_MAP_MAX_BASE_EXTENTS) {
-		kfree(new_map.forward);
-		kfree(new_map.reverse);
-		map->forward = NULL;
-		map->reverse = NULL;
-		map->nr_extents = 0;
-	}
-
+	free_new_idmap(&new_map);
 	mutex_unlock(&userns_state_mutex);
 	kfree(kbuf);
 	return ret;
@@ -1213,20 +1240,8 @@ static bool new_idmap_permitted(const struct file *file,
 	/* Don't allow mappings that would allow anything that wouldn't
 	 * be allowed without the establishment of unprivileged mappings.
 	 */
-	if ((new_map->nr_extents == 1) && (new_map->extent[0].count == 1) &&
-	    uid_eq(ns->owner, cred->euid)) {
-		u32 id = new_map->extent[0].lower_first;
-		if (cap_setid == CAP_SETUID) {
-			kuid_t uid = make_kuid(ns->parent, id);
-			if (uid_eq(uid, cred->euid))
-				return true;
-		} else if (cap_setid == CAP_SETGID) {
-			kgid_t gid = make_kgid(ns->parent, id);
-			if (!(ns->flags & USERNS_SETGROUPS_ALLOWED) &&
-			    gid_eq(gid, cred->egid))
-				return true;
-		}
-	}
+	if (unpriv_idmap_permitted(ns, cred, cap_setid, ns->flags, new_map))
+		return true;
 
 	/* Allow anyone to set a mapping that doesn't require privilege */
 	if (!cap_valid(cap_setid))
-- 
2.47.3


