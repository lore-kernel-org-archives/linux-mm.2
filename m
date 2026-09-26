Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71A48C98318
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 10:41:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34FF66B0096; Sat, 26 Sep 2026 06:41:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28B2B6B0098; Sat, 26 Sep 2026 06:41:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12C086B0099; Sat, 26 Sep 2026 06:41:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E310E6B0096
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 06:41:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 79327A6F72
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:41:43 +0000 (UTC)
X-FDA: 85255572486.07.FFD3345
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id D236E1C0004
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:41:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MkhDvrQX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790419301;
	b=jUZwX0xSZVfITgQmT8ZmIAIA1axutnKUpDXqUjbyzfC6T2zWQciCcUKfZp5cwPN0cattEq
	MlROH1ywEDeaLRsx68LnfGjr9shK/05wf8FSOrGbnvTb0QI9J4478a/i+exGid3uWLhxVx
	XcTwy3XzPHTi8V9xjbz2D79YgEDpXVY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MkhDvrQX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790419301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aQCP/RGStuokn2DCJldKlFoQS/NAG439I5XCm0HrfBA=;
	b=Ptm24abMQt7mcpg7/stLpKGpJu2yFnYgba7X/AKz1jScQsgfI2v5yXIz+jBEIkzQFz4pI0
	7JpDFZADDsb4uoX9wTVIbYNYTJe3Fh+x9QG7XSJjamRQHcgKgRQ5QPS+tVmQtApjQUs2Uz
	B+QbbNGY1R2kKtxVSO3DfUTWckl5VmM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7810C6020C;
	Sat, 26 Sep 2026 10:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F7A1F00893;
	Sat, 26 Sep 2026 10:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790419301;
	bh=aQCP/RGStuokn2DCJldKlFoQS/NAG439I5XCm0HrfBA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MkhDvrQXuv9JOaMsXDAdZkfkT4/bjmBVm1p1REemnjkeT2v349wvKImcqPzjUo0Iw
	 Q0Ei/ujBO70eern1dR2uQYG3D1cMExprZHDJSmgLnWGjAGpBD11LKaQ6Ox1GPfEhIH
	 jZ2Glvuv6ootNvJOTRdEqlqwav+86NjBJ/jDSLEM1p5PzMNB5ji9U97l0lEnK+6c8j
	 S+Pf/rZg+szpsDfvxVxGh/Y1IVoZYv0WZ9Um5tnOYfJLX8e5jISzonG5Nwkmg96N1d
	 FPUtpWNp/0LXZMas5UcGeEBoArSFzAfdovuADUTpxf3BLIYpvjiaZreWb+iut5MIyo
	 vET36C2fklrJw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 26 Sep 2026 11:41:09 +0100
Subject: [PATCH v3 4/6] mm/vma: make MAP_PRIVATE-mapped /dev/zero mappings
 truly anonymous
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260926-map-private-dev-zero-v3-4-d4781e84ccfc@kernel.org>
References: <20260926-map-private-dev-zero-v3-0-d4781e84ccfc@kernel.org>
In-Reply-To: <20260926-map-private-dev-zero-v3-0-d4781e84ccfc@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=8542; i=ljs@kernel.org;
 h=from:subject:message-id; bh=tQKEi/KzTUO/OdLbSMm1OOLfFloz60wF+Nv8nqWY5CE=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK2L/SRYVy0j+vcsmV3DHmi/ZSeTJUtkrrl63iE+ZvWG
 o86Y52/HaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZiI2neG/27rFFIPnRWJDy/4
 P7VQYn/WpVNpifskuz4m+hyZdnrTgcuMDHfWeB3wvLm73yGB/2kSGz9Xk76B2pVNXaci5C61XtU
 o5AQA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Stat-Signature: g1fzoacr7956ffzxhg8pemxjnbnfyts3
X-Rspam-User: 
X-Rspamd-Queue-Id: D236E1C0004
X-HE-Tag: 1790419301-546469
X-HE-Meta: U2FsdGVkX18OvRHOIdEOt8ZDstdeqvD/LsGKPlVjcdwqQQrA1YUyRqu/C7CRPvtXbgdnLO00lLgDVSNnfr6mxeAQAgzUfK7pu0uSvQ2926aUXkILhofEYMXaovYfOLRKMh2MdbhV+2ig3esx5z4nv7wDUrE12n9+Je0TOg9Uc9J7xr3um6X+kV1T8W8r1sl7N+vjn/ledisY8XB3A7whTCuFggMdAshZL/CgGRj4jcdzjqMeBxJ72cDku1O1MgN/QdM/ba6shh77JzHnViIQfxgU3aV/CLNghJDJrdvjX06q+T1DzNnznufPcf3y4LeOwrVnu4LlqLeTwgEWWohARIm45VxmLHh6jZqTBQFL3t1P08I5eIeLY+eaYQNXBcY9GtnfHzT70gRNZZ6zhkZLorp4WzTVYfgsFjVuJfTxf2jMMoHibUguVPe80ExRBK2Yl+XiOAdH07f4IG7gLkwB+ntsFibHOUshzCkARqYrWaRegR4R5DUMl345UHH6a1FuY6Al7GDAaq/yazVKZQ50QGmA2/SsujnyJVeK/xL7zw748/gG/wFhssGM2yKRlB++Nm9VgX4i362RB3VzjBiUbxkmanAOVGueS9iR8o6P/PsC2TipQe7IHv7ivlS6ds0VbyoYn5MaY+rej6EHpztz5VVycH5hrNCA1pDvseHfWmiBG1TYb0Vb55HO4EgQFONX9rdML2mwjYVKlzcftNwaenQMY8pxo39IhuyC3PUhaX3NI0H24fVk5ah1FOFXGsld0VpSj/FMh9RXBzgKXEOMJ8lWGgz3qTYGTiSeriYBKg9FeMmXzCM8cX+QbAKB9Q+kRwkmO7ROlrVYOCfqJYm4gausETgGGukv64rd5f5bKVukC3AE9G7vWH8t+ISfaLJ5k2C1WmTMsFRe1dU8oWQ/AVYRbCwkJtbk4gqDxH6VWxeyDLLJm9OOcVoWC+4V3snqRDgHRL+aKLDKXyH7ddb
 42B7kxDh
 VZtU1mbWMz7r3xFHGg57I/lBJ910kB6va3AEAWXOPIK6tyiFNgEoPNy6ifdHOLKNnxrWM/bsRJNBVThXKq34CChXOPDEis4pDpVLFljInQ4UxvU2CJYMVZdxZ62/aqNPNbEqchOx+IS4T1U1dSjzH/786OQf8QT2YBhoLA61dkr63UOv/3uPCQ2NONb4z7iBv5YAhAUSiKEl2Xi9omVq7Y70n+C6A9LE871DYAOUhWnL1BUYtd/0jEKTFdin8bfdKLw0AmoZ5I8R94n8Jj+9U2OBbc6Sf8LbuESkJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When mapping /dev/zero with MAP_PRIVATE, one ends up with strange VMAs
originating from Linux's distant past.

These have vma->vm_file set but NULL vma->vm_ops, meaning they satisfy
vma_is_anonymous() but otherwise resemble a file-backed VMA.

The introduction of anonymous page offsets and their subsequent use as
indexes for MAP_PRIVATE-file-backed mappings mean the rmap does the right
thing with these but we are left with inconsistencies.

The vma_start_pgoff(vma) == vma_start_anon_pgoff(vma) invariant is true for
all other anonymous VMAs, but not these.

These VMAs are also observable as files in /proc/<pid>/[maps, smaps,
map_files] but otherwise behave like anonymous mappings.

Therefore let's make these VMAs actually anonymous at mapping time which
will activate the anonymous code path for mappings.

This means we no longer have to account for this discrepancy anywhere and
no longer have to think about these at all.

This is user-observable, as MAP_PRIVATE-/dev/zero will no longer appear in
procfs as a file-backed mapping, but the impact of this change should be
low as likely nobody is relying upon this.

However in any case, in using MAP_PRIVATE-/dev/zero they are explicitly
asking anonymous memory, so no longer seeing these as file mappings is in
fact correct.

A previous commit gave us file_is_dev_zero() to positively identify these
mappings, so we expressly only do so for these alone.

Update assert_sane_pgoff(), the comment for vma_start_pgoff() and
linear_anon_page_index() to reflect the change.

We make this change in call_mmap_prepare() alone as /dev/zero has been
converted to an mmap_prepare hook and we do not permit nested MAP_PRIVATE
mapping of /dev/zero.

We also remove the now defunct vma_desc_set_anonymous() and eliminate the
temporary bisection hazard fix from the previous commit.

Also update the VMA userland tests to reflect the change.

Finally, update the procfs self tests proc-self-map-files-001 and
proc-self-map-files-002 which both intend to map an arbitrary file
MAP_PRIVATE then assert procfs state, but happen to choose /dev/zero.

Fix them by updating these to /proc/self/exe which is guaranteed to be
present if procfs is mounted.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h                                 | 10 ++-------
 include/linux/pagemap.h                            |  3 +--
 mm/vma.c                                           | 26 ++++++++++++++--------
 mm/vma.h                                           |  3 ---
 .../selftests/proc/proc-self-map-files-001.c       |  2 +-
 .../selftests/proc/proc-self-map-files-002.c       |  2 +-
 tools/testing/vma/include/dup.h                    |  3 +--
 7 files changed, 23 insertions(+), 26 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1b28e6fc8d5d..9238b7d52198 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1539,11 +1539,6 @@ static inline void vma_set_anonymous(struct vm_area_struct *vma)
 	vma->vm_ops = NULL;
 }
 
-static inline void vma_desc_set_anonymous(struct vm_area_desc *desc)
-{
-	desc->vm_ops = NULL;
-}
-
 static inline bool vma_is_anonymous(const struct vm_area_struct *vma)
 {
 	return !vma->vm_ops;
@@ -4405,9 +4400,8 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
  * If @vma is a MAP_PRIVATE file-backed mapping, then this returns the
  * page offset within the file.
  *
- * Edge cases: nommu does not abide by these, MAP_PRIVATE-/dev/zero satisfies
- * vma_is_anonymous() but has file-backed page offset, and MAP_PRIVATE-pfnmap
- * regions have their page offset set to the first PFN in the range.
+ * Edge cases: nommu does not abide by these and CoW MAP_PRIVATE-pfnmap regions
+ * have their page offset set to the first PFN in the range.
  *
  * Returns: The page offset of the start of @vma.
  */
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 0adfa6605653..939f3a5e973f 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1128,8 +1128,7 @@ static inline pgoff_t linear_anon_page_index(const struct vm_area_struct *vma,
 	const pgoff_t pgoff = __linear_anon_page_index(vma, address);
 
 	VM_WARN_ON_ONCE(!vma_is_cow_mapping(vma));
-	/* Account for MAP_PRIVATE-/dev/zero which is only semi-anonymous. */
-	if (vma_is_anonymous(vma) && !vma->vm_file)
+	if (vma_is_anonymous(vma))
 		VM_WARN_ON_ONCE(pgoff != linear_page_index(vma, address));
 
 	return pgoff;
diff --git a/mm/vma.c b/mm/vma.c
index a31942c0ad2a..9ff02fbde16c 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2621,6 +2621,13 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 	return 0;
 }
 
+static void map_set_anon(struct mmap_state *map)
+{
+	map->file = NULL;
+	map->vm_ops = NULL;
+	map->pgoff = map->addr >> PAGE_SHIFT;
+}
+
 static bool map_is_private(const struct mmap_state *map)
 {
 	return !vma_flags_test(&map->vma_flags, VMA_SHARED_BIT);
@@ -2628,10 +2635,7 @@ static bool map_is_private(const struct mmap_state *map)
 
 static bool map_is_anon(const struct mmap_state *map)
 {
-	if (!map_is_private(map))
-		return false;
-
-	return !map->file || file_is_dev_zero(map->file);
+	return map_is_private(map) && !map->file;
 }
 
 /*
@@ -2663,7 +2667,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 
 	vma_iter_config(vmi, map->addr, map->end);
 
-	if (is_anon && !map->file)
+	if (is_anon)
 		vma_set_anonymous(vma);
 
 	vma_set_range(vma, map->addr, map->end, map->pgoff, map->anon_pgoff);
@@ -2681,10 +2685,6 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 	else if (!is_anon)
 		error = shmem_zero_setup(vma);
 
-	/* Temporary MAP_PRIVATE-/dev/zero workaround. */
-	if (is_anon && map->file)
-		vma_set_anonymous(vma);
-
 	if (error)
 		goto free_iter_vma;
 
@@ -2813,6 +2813,14 @@ static int call_mmap_prepare(struct mmap_state *map,
 	map->vm_ops = desc->vm_ops;
 	map->vm_private_data = desc->private_data;
 
+	/*
+	 * MAP_PRIVATE-/dev/zero mappings are an ancient way of getting
+	 * anonymous mappings. Rather than allowing these mappings to be odd
+	 * outliers, simply make them truly anonymous.
+	 */
+	if (map_is_private(map) && file_is_dev_zero(map->file))
+		map_set_anon(map);
+
 	return 0;
 }
 
diff --git a/mm/vma.h b/mm/vma.h
index 024fabe63560..e97bd2dfa786 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -267,9 +267,6 @@ static inline void assert_sane_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
 	 */
 	if (!vma_is_anonymous(vma))
 		return;
-	/* MAP_PRIVATE-/dev/zero is anon, non-NULL vm_file, but has file pgoff. */
-	if (vma->vm_file)
-		return;
 	/* If faulted in, could have been remapped. */
 	if (vma->anon_vma)
 		return;
diff --git a/tools/testing/selftests/proc/proc-self-map-files-001.c b/tools/testing/selftests/proc/proc-self-map-files-001.c
index 4209c64283d6..bbca9f9e2743 100644
--- a/tools/testing/selftests/proc/proc-self-map-files-001.c
+++ b/tools/testing/selftests/proc/proc-self-map-files-001.c
@@ -51,7 +51,7 @@ int main(void)
 	int fd;
 	unsigned long a, b;
 
-	fd = open("/dev/zero", O_RDONLY);
+	fd = open("/proc/self/exe", O_RDONLY);
 	if (fd == -1)
 		return 1;
 
diff --git a/tools/testing/selftests/proc/proc-self-map-files-002.c b/tools/testing/selftests/proc/proc-self-map-files-002.c
index e6aa00a183bc..5786cdffbbf6 100644
--- a/tools/testing/selftests/proc/proc-self-map-files-002.c
+++ b/tools/testing/selftests/proc/proc-self-map-files-002.c
@@ -57,7 +57,7 @@ int main(void)
 	int fd;
 	unsigned long a, b;
 
-	fd = open("/dev/zero", O_RDONLY);
+	fd = open("/proc/self/exe", O_RDONLY);
 	if (fd == -1)
 		return 1;
 
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 0d1a2ac88922..16c09dac59d9 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1635,8 +1635,7 @@ static inline pgoff_t linear_anon_page_index(const struct vm_area_struct *vma,
 	const pgoff_t pgoff = __linear_anon_page_index(vma, address);
 
 	VM_WARN_ON_ONCE(!vma_is_cow_mapping(vma));
-	/* Account for MAP_PRIVATE-/dev/zero which is only semi-anonymous. */
-	if (vma_is_anonymous(vma) && !vma->vm_file)
+	if (vma_is_anonymous(vma))
 		VM_WARN_ON_ONCE(pgoff != linear_page_index(vma, address));
 
 	return pgoff;

-- 
2.55.0


