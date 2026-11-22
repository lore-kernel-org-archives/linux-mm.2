Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7500E606A688
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 01:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C+j1UvVg
Received: by kanga.kvack.org (Postfix)
	id 8472C6B05B0; Sat, 21 Nov 2026 20:18:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AC6E6B05B1; Sat, 21 Nov 2026 20:18:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C1F16B05B2; Sat, 21 Nov 2026 20:18:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F6346B05B0
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:18:27 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 926471C3C9C
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:18:26 +0000 (UTC)
X-FDA: 85460994612.02.C827968
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 017E580004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:18:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C+j1UvVg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795310305;
	b=BjgSb0u+IEmGYNebIOrVUCp33/8irOqf4UJXS0vW6ytU9C7HRn39Hgk9ZvgYSZpQfgn9ND
	xN89eatYz0Fe1FNMLoeNakLlMBrI6GgF/pTeoxCFAANcKYl1HYjBGTLq/4pAMW7NJFBrSm
	iitKjNGEXCHboBa65/jzTGhkluMSE0Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795310305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HMiFFGmw0v9nxAge20cDn397wiErWOHZ9jOEttk4raU=;
	b=pZHMMs3HYw54cfdS2ixyhYH1Z0aadHoFGNTy8PiZuOX3coxm1SvMChuCC2aThKwJtiWdbR
	Ldn7Qxrjiwkv8CtSUSZjPm4rw6s/UvvmpfsxvRsawn7AMfYVYo8ILL5Cw+WSzwVKaAMDo4
	cWrd+qghA8ONeUWpghyzBKwcujpVqKY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C+j1UvVg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id BB9A060DF4;
	Sun, 22 Nov 2026 01:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C33471F000D8;
	Sun, 22 Nov 2026 01:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310303;
	bh=HMiFFGmw0v9nxAge20cDn397wiErWOHZ9jOEttk4raU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C+j1UvVgDWtOAPt8XWSNPgtEmRheZe6p/Zxa5yvM0BnC7U/nigoPkIixtcmaJImOi
	 3bKXBQ3MOJIzEnifXGq/e4j6MycalZFXvzccUFfqe9dI1TGndLSr5PGcnFIe8Jje/c
	 Q45wK8DaPan0bFAhyCLTJ/VugRrIdKTx7SsBmubhLWb71wBhFL+FmC770a6SWMn0p7
	 rb7BVXLInShRYT1vDUWHFaI4l9Zhn+nYRWiuTjtW7hVb3sLAee7jcAxJ9Dsg14rE2M
	 cYT2ig/iuchjBheqZ2yuUXfTO8JDZcnPGiCXGoh2ZP8TLIoxv2Uv3+q/r0KUsU+iO4
	 JD2osQs1N+zog==
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
Subject: [RFC PATCH v6 01/26] userns: Factor out idmap validation and commit helpers
Date: Sun, 22 Nov 2026 03:17:44 +0200
Message-ID: <20261122011809.2667684-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122011809.2667684-1-jarkko@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 017E580004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: rho389f4ehnmcoh3pw9qg4ggy3pdffz6
X-HE-Tag: 1795310304-116367
X-HE-Meta: U2FsdGVkX1/7bWB6XZFf08ZmfuKMU+eHEbM/nrLGItBw/WxRQZyKARQC2P1+6PhbUHPMCpP124jjMfhX3tivAFmBB4rd9pCT2MCgQldWUOQ4iKAT/3sRjbIKgL/xOa30pAEYJghZH8Y1MwHycxLR6tTsrvF4l+dY3KV9UYS/DCqoNohrdZbeV/hCJFvivgS0BjamczXfk1vj5ECN5VIXpZg1Z+GzETZ4cYoFLoPqX5P/+ltyU5ll0JEMizsJ/ebGvn+XvLH/vxXX2ngmOe4TOanlHS24N/eOroK87tIEdypbJicp0QZSHYn3DGeoOVBhCVZ9AmM++u9dVm+2hCq7tmHZrX5V2V0eMR7WTgalRVh6TEpxojw02ZmNUdrI33pRnMEClo2roM/vxrsMBuBkzKpd2OQcrZAOIiBgCdiZcNbCBwcTJjcA6VEnmyYw91LGmCfhB0mCDCSFPq8werVzDrCVmnPOqc0K0NC5wkqDmwBAEhNQpO9zdmbUAWhZ/6uMDmfCapJEIJvTnEr0gbXs6sgwWB1zRNKlPRNYDvprfM2GRtFpoGDnQmhI0Hs/IK40w05m3yyJ8uSEiNH6IlJggvnmpWoWKzuV8tkt4OfWs+nm7khCYOW8iCM3GSSuPet+HC8bfO9Ak1tKzUO1hDWu678YWZQD1oyV0IHuVXi1QOMT6sMN8363l0IhynRUTLUsyN4erCrrFjJJKzT4FZZIRhDFxwIgZhI9QWPuJOqsfHF0BtDwHJViRS4PxJban1Qs3ftVbSdE2hMfLduC7ihiHtMWjHsMG0+dnsbSFDB0Rutih8oXb1NsGZx8KFfKGievNQd+2o4ySsbZVcUPQ/RMN3CaGIE0KFc9Spxw+TqzrCK4ip3tnIkXu0G5CvrD7IV336JURHy61i8I209a8YS6mWodkd/RsZ5Te3lwWyULn9629c+BqkElqqbZv+2G4tE9Mx4mMcnxqAqQAQ09lqn
 vt/K7BwC
 HuI8hdbalGFZYzE0MlUdSuIQWwSGM9f+SeJn8am9hP8jAmL4XTCOIpIOGJrWdpLSWrjJhl3/XIAGh5FnMUUx3AxPHZhWwhFXvCUzLARnNftoXq76XNKRa1rpmeJz9QOuleEzckU9vHeCIMdBngcP9gN/zEK6RBqv2PbgZu9TE/gWY9p+HbY78KT/ai+OO+tSrOMxEac/88kLmYl9wf6SPxyFk2I3XMC4z9R03Y3AKjPw8XlWYVUuYLHSZwmzjJuwj2WNSKJ4aFa+yyr7nok3RHWOMxfHRbH54Hb+C6oju6+m/bqMZ4s5MxuW68Xzsy19WIm3fcbNee7wkqR7P3yEJd6eyRuFekEpEsyqF44uEfMwifKLk/zbaf+6eD191avusgK+c/eSPLgtT/iEJXpfYqsYGPXNYcsiBoKXgQAEgm36BSNg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

map_write() validates extent ranges, translates parent ID ranges, sorts
extents, and installs the resulting map inline for procfs text writes,
preventing non-procfs callers from reusing the same validation and
commit path.

Extract validate_and_insert_extent(), free_new_idmap(),
resolve_new_idmap(), and commit_new_idmap() out of map_write() with no
functional change.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 kernel/user_namespace.c | 159 ++++++++++++++++++++--------------------
 1 file changed, 80 insertions(+), 79 deletions(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index cd748e1cbace..6b9673dcdc67 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -938,6 +938,80 @@ static bool verify_root_map(const struct file *file,
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
+	/* Pairs with smp_rmb() in map_id_range_down() / map_id_up(). */
+	smp_wmb();
+	map->nr_extents = new_map->nr_extents;
+	memset(new_map, 0, sizeof(*new_map));
+}
+
 /*
  * Parse the decimal u32 at *pos, up to the next whitespace or NUL, and
  * leave *pos pointing at that character.
@@ -966,8 +1040,7 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 {
 	struct seq_file *seq = file->private_data;
 	struct user_namespace *map_ns = seq->private;
-	struct uid_gid_map new_map;
-	unsigned idx;
+	struct uid_gid_map new_map = {};
 	struct uid_gid_extent extent;
 	char *kbuf, *pos, *next_line;
 	ssize_t ret;
@@ -1002,8 +1075,6 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 	 */
 	mutex_lock(&userns_state_mutex);
 
-	memset(&new_map, 0, sizeof(struct uid_gid_map));
-
 	ret = -EPERM;
 	/* Only allow one successful write to the map */
 	if (map->nr_extents != 0)
@@ -1052,98 +1123,28 @@ static ssize_t map_write(struct file *file, const char __user *buf,
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
-- 
2.47.3


