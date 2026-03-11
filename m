Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6180E1125858
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 17:26:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEE166B008C; Wed, 11 Mar 2026 13:26:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBA886B0092; Wed, 11 Mar 2026 13:26:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A99386B0093; Wed, 11 Mar 2026 13:26:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 95CFD6B008C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:26:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4C8E98B33A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:26:06 +0000 (UTC)
X-FDA: 84534460332.05.83B5D0F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id A65CCC000E
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:26:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="e/YBSoHr";
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773249964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v2ppPHWTLnrY2+U13f4NeK7IUvWbd5GHr+nFb6Gwh3E=;
	b=5yNUEzbQuN+0xbWOfgw8ltt7/9CbTRI1BPtT+eBQ47kUFi1wIAAf5IAopcMShophzxrjmS
	9NkKESoAWIfYKQDT4OTvRziorM4xOC8M5jkMYMRNYJ7QVbJ4ltOjnUUx9vLoHYATb4D7u8
	kccLUUk/hYyyk4r5uVjAH9zeWmLvQME=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="e/YBSoHr";
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773249964; a=rsa-sha256;
	cv=none;
	b=Rs5Ja0kGMDp4fcnH61EG22DlxM4xhbi5WV5TbjJ5C3n0PBWEbmCtqQtXF90GDaYny3apJy
	DVbcEPHYL91ryaFqaxae/NnAT+PlVL7MUlw7wYcljG/uFAoeXp3J7UXgVyoTSeZUlLEPLx
	pZ75fUax981S1i2sO42xyCrq5y5X9Hk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E1F961344;
	Wed, 11 Mar 2026 17:26:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 770FEC19424;
	Wed, 11 Mar 2026 17:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773249963;
	bh=WuYiqZxOOUSTMj+uHG8hKRHfxCYiMKZgeLbdCYDg2b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/YBSoHrZXvKVCaNm1I2qkdjbYiDv4/SkTfvR+P+e9LZNC4PqrJ6Xu7bpJYGnVgHR
	 nUGgMnFVOBXtq6x6+J89y7wKr/xkxL4yK0Gl09zt9Zoak12vspkZab+XovBojPoWFu
	 TCtlfuq02+d9qr/N4n22xYFCN4asrtUGDWMcTFtpZdl3jUMHV5Ksq280e83UussN6U
	 seaex4c1N6UM2Ztsyn64QYmrfKccf3GcdVQ+U/4+6CApe1YjaMwpw2bEJstyn2+1ZU
	 PsuE37hUMKVQch+kCocRB2YDNXuTdgV/VWz9P+tnO4LgtduJOxX6ZJx8XANv0VTpb4
	 V8A4+pjMgzobA==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Jianzhou Zhao <luckd0g@163.com>,
	Oscar Salvador <osalvador@suse.de>
Subject: [PATCH 3/3] mm/mremap: check map count under mmap write lock and abstract
Date: Wed, 11 Mar 2026 17:24:38 +0000
Message-ID: <18be0b48eaa8e8804eb745974ee729c3ade0c687.1773249037.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773249037.git.ljs@kernel.org>
References: <cover.1773249037.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A65CCC000E
X-Stat-Signature: 51mkj73r19h3ybefteofdb9bhxqxbff9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773249964-386
X-HE-Meta: U2FsdGVkX19LQ/T+nFBU4uRAowzSWBQZeGAs06GEebBePnYPDQJT1xF44UecEFp5/D3dcnqL/CPqmdBzOJYzm7Iwn+Lgc/gqUXn4BVq8O484HIT2GkWildNrlTQOQpNBAm+e7sWA0f57eEwnXTtJc4Gg8VxzeoH9gWxNlEsoQNSjJWp3AzqLx99vatiSkghIAcURUVTC1Rs2XOvFpgh2laQ6b2zJrFasWJNym9uK1eQ+fQvlAv6k2t3u1w05or4lVfqL05MfjwCC/alEMgE0I9FrH/IlvPH1arqqgU4Kwm6ZM2Ai5G1wc7Ab2Cc3IfkAtFPxI3GAvYN34XiPKhJhJzFm20GJBNXF/RG4CuSTMHWBEE20GekFMR90OLxKDDmZXtKJJkSF5xmL/AaJdI/3Tg78Qq6Kw1h/hjljP/o47FHrKKLtQckEGhmF0XFsMH00WPzig9BpnHD+8bO1ZoMTI644j5qYfiywt1Zd09pbLCAh9valrlRqbiw3lj1Pi2aPrA4ptA58wMbaCOEJESKa7a20SE9ySJ3leglTiwZaSvjzjgD1r/becin39O/X4PHlQQeBgKCpfHsIJ4oWZBfBIjMV7aLxXg4eEDkGxWFDFOmYsRpc1ZqP8ES/aWVueBcSh2V3s5CGfnaPI3XzuzfVS2L79trGCFn0tFQ8hXHWrNihr5OR6jqQXJehUxYDDlNoMSf12j2YmOC0K+K4XMa+pNrE8+PY5Z6PHSh0VrPLWvSfGRvE1j7qeIUl84cqnhWfBVCbWDa9YgUX+oKvVv4LV3pJPfuTIp+vDaVcwki/YGJ/yGdFJ7tlq1/sV5FWcBWSZoPYyQBrYF9OlAWzJb+tmfM2+igs/S//5NcFy+G48pDSpHlysrkaQacruAyJd87CKeh/HfFNgSBM/wg7kWGVLUBFPR+C7WCCt4oHvsy/0y8ZqABB14ge+Gqil/x3kbHddLnsvv6LFwhf8VLNDjt
 wPaP/Kzf
 yRHvqMpjSEKbi+NYalOBkd/TgEZKlF6h/elihU3zdC4ZYZHcwOHkiVTAv+NxL+P6KaiLXMHHezlo3pq2nUsHXQ6/QVgJ2e8BFKBhqbkugydwOP+ecONZe/xLI2CywfsG4WgjQzQvLnm5sT1V9tFB2UNIMZG121aKA/eXkUXvlxul8KJYVzo2m4j31X8H2sZc18rL8A+L6GBJmQcBewiu23gnU+vENL6IqnWBf+lm0vU0beidnyD/evQAXIEVHcvWPf7hn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We are checking the mmap count in check_mremap_params(), prior to obtaining
an mmap write lock, which means that accesses to current->mm->map_count
might race with this field being updated.

Resolve this by only checking this field after the mmap write lock is held.

Additionally, abstract this check into a helper function with extensive
ASCII documentation of what's going on.

Reported-by: Jianzhou Zhao <luckd0g@163.com>
Closes: https://lore.kernel.org/all/1a7d4c26.6b46.19cdbe7eaf0.Coremail.luckd0g@163.com/
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/mremap.c | 88 +++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 75 insertions(+), 13 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index ba6c690f6c1b..ee46bbb031e6 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1028,6 +1028,75 @@ static void vrm_stat_account(struct vma_remap_struct *vrm,
 		mm->locked_vm += pages;
 }
 
+static bool __check_map_count_against_split(struct mm_struct *mm,
+					    bool before_unmaps)
+{
+	const int sys_map_count = get_sysctl_max_map_count();
+	int map_count = mm->map_count;
+
+	mmap_assert_write_locked(mm);
+
+	/*
+	 * At the point of shrinking the VMA, if new_len < old_len, we unmap
+	 * thusly in the worst case:
+	 *
+	 *              old_addr+old_len                    old_addr+old_len
+	 * |---------------.----.---------|    |---------------|    |---------|
+	 * |               .    .         | -> |      +1       | -1 |   +1    |
+	 * |---------------.----.---------|    |---------------|    |---------|
+	 *        old_addr+new_len                     old_addr+new_len
+	 *
+	 * At the point of removing the portion of an existing VMA to make space
+	 * for the moved VMA if MREMAP_FIXED, we unmap thusly in the worst case:
+	 *
+	 *   new_addr   new_addr+new_len         new_addr   new_addr+new_len
+	 * |----.---------------.---------|    |----|               |---------|
+	 * |    .               .         | -> | +1 |      -1       |   +1    |
+	 * |----.---------------.---------|    |----|               |---------|
+	 *
+	 * Therefore, before we consider the move anything, we have to account
+	 * for 2 additional VMAs possibly being created upon these unmappings.
+	 */
+	if (before_unmaps)
+		map_count += 2;
+
+	/*
+	 * At the point of MOVING the VMA:
+	 *
+	 * We start by copying a VMA, which creates an additional VMA if no
+	 * merge occurs, then if not MREMAP_DONTUNMAP, we unmap the source VMA.
+	 * In the worst case we might then observe:
+	 *
+	 *   new_addr   new_addr+new_len         new_addr   new_addr+new_len
+	 * |----|               |---------|    |----|---------------|---------|
+	 * |    |               |         | -> |    |      +1       |         |
+	 * |----|               |---------|    |----|---------------|---------|
+	 *
+	 *   old_addr   old_addr+old_len         old_addr   old_addr+old_len
+	 * |----.---------------.---------|    |----|               |---------|
+	 * |    .               .         | -> | +1 |      -1       |   +1    |
+	 * |----.---------------.---------|    |----|               |---------|
+	 *
+	 * Therefore we must check to ensure we have headroom of 2 additional
+	 * VMAs.
+	 */
+	return map_count + 2 <= sys_map_count;
+}
+
+/* Do we violate the map count limit if we split VMAs when moving the VMA? */
+static bool check_map_count_against_split(void)
+{
+	return __check_map_count_against_split(current->mm,
+					       /*before_unmaps=*/false);
+}
+
+/* Do we violate the map count limit if we split VMAs prior to early unmaps? */
+static bool check_map_count_against_split_early(void)
+{
+	return __check_map_count_against_split(current->mm,
+					       /*before_unmaps=*/true);
+}
+
 /*
  * Perform checks before attempting to write a VMA prior to it being
  * moved.
@@ -1045,7 +1114,7 @@ static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
 	 * which may not merge, then (if MREMAP_DONTUNMAP is not set) unmap the
 	 * source, which may split, causing a net increase of 2 mappings.
 	 */
-	if (current->mm->map_count + 2 > get_sysctl_max_map_count())
+	if (!check_map_count_against_split())
 		return -ENOMEM;
 
 	if (vma->vm_ops && vma->vm_ops->may_split) {
@@ -1804,18 +1873,6 @@ static unsigned long check_mremap_params(struct vma_remap_struct *vrm)
 	if (vrm_overlaps(vrm))
 		return -EINVAL;
 
-	/*
-	 * We may unmap twice before invoking move_vma(), that is if new_len <
-	 * old_len (shrinking), and in the MREMAP_FIXED case, unmapping part of
-	 * a VMA located at the destination.
-	 *
-	 * In the worst case, both unmappings will cause splits, resulting in a
-	 * net increased map count of 2. In move_vma() we check for headroom of
-	 * 2 additional mappings, so check early to avoid bailing out then.
-	 */
-	if (current->mm->map_count + 4 > get_sysctl_max_map_count())
-		return -ENOMEM;
-
 	return 0;
 }
 
@@ -1925,6 +1982,11 @@ static unsigned long do_mremap(struct vma_remap_struct *vrm)
 		return -EINTR;
 	vrm->mmap_locked = true;
 
+	if (!check_map_count_against_split_early()) {
+		mmap_write_unlock(mm);
+		return -ENOMEM;
+	}
+
 	if (vrm_move_only(vrm)) {
 		res = remap_move(vrm);
 	} else {
-- 
2.53.0


