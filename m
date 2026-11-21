Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2951606A339
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 00:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MCG9Jh12
Received: by kanga.kvack.org (Postfix)
	id 175046B05B1; Fri, 20 Nov 2026 19:09:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 125AF6B05B2; Fri, 20 Nov 2026 19:09:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2ECD6B05B3; Fri, 20 Nov 2026 19:09:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C2C466B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:09:03 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 308BFC028A
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:09:03 +0000 (UTC)
X-FDA: 85457190966.02.0E538C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9491F20002
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:09:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MCG9Jh12;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795219741;
	b=zgsPOi5gz08B90+ClWoUSihvcKXIjoZo0L0LFvf7/tH79Jdq1mvmrRm1KnC3BD48XX28xH
	eRUWqMIvvlGy92/iZdDR1Pte1NMf6s/R+YRfclsO8DV4jKCJZPE0SVbiVNFJ7skT92EAYf
	QMhSsekOSc7eJjmz6qLoSt6AjsDkEVM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795219741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HMiFFGmw0v9nxAge20cDn397wiErWOHZ9jOEttk4raU=;
	b=PrGtibCPN6w3S3txvljF38ar/q0TiccuZEUGB/J5Xw9ZT3k8NV0dEVFC9LGrAy++UYOoQ/
	aDcvP02FLCpQZsfJB17L0mTqnTyhoTlwnH5uwNKy9eqnd/hpXDs0qbl2CYenwCNwFhCZxo
	HLVY9yVouWJJvKpjRcNLNLqppr53e90=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MCG9Jh12;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 4D23761F22;
	Sat, 21 Nov 2026 00:09:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 254671F000C0;
	Sat, 21 Nov 2026 00:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219739;
	bh=HMiFFGmw0v9nxAge20cDn397wiErWOHZ9jOEttk4raU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MCG9Jh1256gFmx/kJBdpvtrZ3dAFy6JucQNKjq+UEDDHvSfsCjIvK79puHbjOkQ2j
	 yLwGkP/zWuSJdgoNpsZpPJQqe8beWIamFh64TiVd3IFdL4sWKjuuMoYrsyBe6B9GXr
	 HxXJuEwWmpevvo9m2YuFz4UqgRwPQqBnef719+RqEXVE7M3RreB4FCdF3wgRro0Wdl
	 xFVLfcZe1dOF6Xy5OXE79lBtJZxDpFc7EsLy4EZbJz29c5cxL2VpA0CJQeacS31Zdo
	 G2VE4SZqQrVeumqNyU2QjuDFDNsNiqZXrhWfoS6+GYb0Qq33QmgNO2NoEm+TVjVmxv
	 f0f7bDxjNsjbg==
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
Subject: [RFC PATCH v5 01/25] userns: Factor out idmap validation and commit helpers
Date: Sat, 21 Nov 2026 02:08:20 +0200
Message-ID: <20261121000844.1863324-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121000844.1863324-1-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9491F20002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: scwcfg1kdgqskrg4esf7u81d1idnk385
X-HE-Tag: 1795219741-233383
X-HE-Meta: U2FsdGVkX1+OH4cjttl6bwQ8k27t5nbQcLBJLvafubQu3FS/9PRPNfygGKWPUsxRSvVN6SQr6LlEty1hTOjEF4kdNszAwcbvng8NkbJZ1XjFUDfhQUnPkdlcNCt4cyNuMpB6mwU36ibMj9G4YkGQe0tFwUYnBnG3ASfm83iER4TbrOA3LMckgryv/O4DN+4bbl0GCT1ResZTGaDU1wcyQMXHobF2QSqhb/2BAm2yiw5F3Er2qJLCSQMkx0qMu0UREhzv5Jvi3qHtGVmanQZhv4CzhjeGJs9U/OdF0y/Q9EfarPRIZuqYcVirfX6HzV6l1Oab6UkXrGamijSkcQIk4krB+Gl4uyyP4PdH6E38JIf4Am1AvRUDmTLtxF3+9oQmDGtHRZjiy9ER8Tj3QPlbSElCiHMajaWRD3OLUKvYga2IsVtvFdvYSvwf7mZw5qLgIhReU3SkNahsIqFPXmgh050b/ALNC64idP3SrjtsXv6ZnaEYQ03jXmIys9UBNQc+5vbALME7Q+JGOrcLKoPBxuMW/H7CTXaTkcOWKDYb7v3NWxx8p6Aj5xWhMVfTa8CjahNMKHVBgFiNBmf/okM5qeYslrsR7SBhwLvjeS2IcsgKKeiJamWNmaTA9AFvUVJwTqiaimo3NlMv6IBX/9xz5ybo7f+q6HoWIUyHympPsmelXHhYeA/KHJyfibUhvqUKaWdnZlcwK1QyG26darSv0SRYux2qyAxVMpQbrGzSLt2pGVbRoBZJE7U5crs8Z1rrA7CLFyyNsEz7n4KbIQ87Isc5Who5TfG5CI0U4432H1vMK7ulAiEksY1yZ97GEbXTLmk9jBUiQxZxVOfE6m7pl5LiGxQH8tzz5IfPqA9WyzdKMsqlBb8wVXFTol8FpjClXOyjNmoPMrdUfR7LdbUi1Wtc4Q/oij/+nkLNOXrNXLv0qvALDaw6jfIbdMQkHoH3TciO2kH766y21TQe2su
 MbTtXJ1x
 yUzylawlAha1qGRIQ1LOZ4WnD1muzP8P/9LCBB0Bfa7O1+AMYdTg+zrarWTHHpgfxsKovfbqgRvjFKbTfAmyd0j9sg8ZWs6tupPO4sAFYWNRnkFzP2Ea0m2Z1PVSa15zSF6zHx+4z3TJ93p4+Axvlq3D5GLEzbDz54NdB8afSfdqlhiHa1VUb3uBn+COQP5TCGBy6oJPlV0cKfrVXRwuaUPajZioK/aUDvzZKkD4llPKNwsK9E/XB7agrO83HF3xF8+4LRRPXO42bvBSmf7CnTEGyk4D3AzzMFdwFn+yz33udLEhHWGiwiXk48LaXES8sEoT1Xj1l7Ycd8I64aWfOh2lTR8X4LZXz0WvVBegkjHmhEH3v55+A68NkgrtS28+/hxUh2pOBWofG9NyKbQcXk9qM0bNzpXYCepnybeLVO9Y538w=
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


