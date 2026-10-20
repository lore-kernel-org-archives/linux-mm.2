Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8690360A4AD3
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 11:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=d0QKAMPa
Received: by kanga.kvack.org (Postfix)
	id B05186B015A; Tue, 20 Oct 2026 07:58:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB59E6B015C; Tue, 20 Oct 2026 07:58:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A3D86B015F; Tue, 20 Oct 2026 07:58:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 71E776B015A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:58:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5DCFC0128
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:58:36 +0000 (UTC)
X-FDA: 85342857432.11.480496C
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3A4512000C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:58:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=d0QKAMPa;
	spf=pass (imf13.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792497515;
	b=OHWAfFvSa4gVm/OLHHRjpagc6WP9C/brfmUq84+Z7fIRYKoMXw3fd6zFitP56OVflawQDW
	hEc7iImnnmECmyWcbwfnG4epN5TzzSpIcDfSjysfge6fc27cbbtnE943IUZPzmUIyxFD+H
	VjFR3+bVA1UyM/yvd1y4bv3gG66VRXU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=d0QKAMPa;
	spf=pass (imf13.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792497515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jpuez3gyskb3VAlGg3DcMx9gb6CiW0/rZ3601UfyRuA=;
	b=SVZa9VEFIYojXu3SFXe82rPRT9k0bFt5nTuFSfAXhJ5b2WI1PjypAdo62fT801y6zsJEtE
	7jHp1Ly8qfO5z6miBo4rAou5kZizVQviibZIpp/hFxp3/7/f5G3brQ209Umv/7CY6qT3GZ
	iMWk4JnrUBElN4U5SN9uSnEL9+gKWi0=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2e5d0ee1951so20473305ad.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792497512; x=1793102312; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jpuez3gyskb3VAlGg3DcMx9gb6CiW0/rZ3601UfyRuA=;
        b=d0QKAMPaszif2s1fPNIUzoi1ILxG+jUZmE9LftnOtPvTym3tpNfpY6ZMEkGlebu19B
         /eiiSz/2a9Z+qOVbLkZZBmsvz7NphesXmK15swgx0J9tDUlQYlMNcjhra9f/ZoxcUUCI
         eQYPqBuwZGwEi/VVVbseXLaA4mz840JPwwL7A1bM8a5uuL5cYQd8WRA0PEyP+Gm+hy8R
         SXuUmnZ4rYyihFOCQ2yf2Hjdf+IQ30+NtKWmcW7Z4fcfrbsr1XBnfb3OY2QhAmhoJFqV
         8NAfUs9C3dRsXpzN3uBJbblz7hJf/lmE4BhpoiVZhQI98//KVV0Up0Y4nhz6KC0ccNGS
         oVmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792497512; x=1793102312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Jpuez3gyskb3VAlGg3DcMx9gb6CiW0/rZ3601UfyRuA=;
        b=H+LdgQXW2W7pEcRysObTj3ZXfneds6UrE2W1AXn2uQvjwUJ3TzmQ3s0xcO66HXW68J
         BCgxHyxJMBPqWPn850tXS7gVdpeB+AO8zPki0VvztHWRNZzyk+O4b5X+wdqlZllYglRp
         VjJPZnlBVtYbVHunfo+JqbB8sc3XYA7pdBgOL7lnEuBECHV5veyAcyRIW+Y96UYDbeC3
         OoPtLvnbz2mWw7CVOLl4lkTrKOuEDwINqt+2J+rR87+tYKSizn7o8bFfnfAXlzmg5vg/
         0uYt5MizVnC8uzogJGLXVSoo5sr8zty2seyJMAa011Atpp3dtx6Z2tGTXjqQJOKCR0KE
         1Aiw==
X-Forwarded-Encrypted: i=1; AKwUvByX/Raxktr+c+azp7VPFn6G5mhEb8UXJOwmD/CcMFfbBK+1HJ94D5MLSfzekgbcCRd2Lcon7h0pzw==@kvack.org
X-Gm-Message-State: AFq9FYIX1aQSvIlJimzzsDV1yXdakAq8WQfpo528ds5dlQwOMO/NqUC2
	Axe3nUrI3bWpyVGNo5W2xLkv+o6+TYN4mdLBEKH/yAaAKIzj7dwD6oW0+i/csXiaMaQ=
X-Gm-Gg: AYBFou2iwP+qa3aGpLGtgKHWxMdEa8C0OI4l1oJ9dwvlqXXpiVFvnXI+cyJ5fs8L98a
	1peMqEShGT28msWPqpioxdz/Jak+oyb784rsc6oiwm3jTL0U4QSZ+H0+uraze1GBtSTzK+GhNUm
	SFRw8Oa5JtPuoagTyRjasRxlISUIgSVx6qO0q29k0XPaDIEBqFgKz0GDAAieDLOKdX+vDAdHAp1
	Ptbl64gucvxwSFo5J0aVh2HnOE3AWQylmCRRsOE16CY3NkaQ/3ll2Ax+Gi2hJgGUbKqrr05V4mM
	KKkzpkKgF0VZin/EZLcVW9775IujJ3eQYDOUaFrOEzcE8NOwIA5lfUHb7BbUvbVrlzcweHjB9VK
	g+JjotUox+gzaL8GKvepKBehgsAq23icJy3vYW71ukr0vtIyG6m1j9cpeJ1WfbVv5A5DpqC2LbR
	rVmxYAz2RYi2gwU9DHJoJ3pewcpvZbDXN6bHgzthLVtMP/rRDxvoxwaJbQ1e2HLHFTD9ho6xIUR
	l+c6XnHKBGG/fsEOh+QPhgmYKf8SH9z4o0jL2FYeIEci0rYZaI0Y2QWMWk+UxGTcYB6cgKxcbtT
	5Q==
X-Received: by 2002:a17:90b:1d49:b0:3ab:1e1c:837f with SMTP id 98e67ed59e1d1-3acef56d593mr8517817a91.47.1792497511899;
        Tue, 20 Oct 2026 04:58:31 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad60274fc1sm3448095a91.0.2026.10.20.04.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 04:58:31 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 02/12] mm: hugetlb_vmemmap: unify VMEMMAP_{SPLIT,REMAP}_NO_TLB_FLUSH
Date: Tue, 20 Oct 2026 19:58:14 +0800
Message-ID: <20261020115824.823278-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261020115306.813483-1-songmuchun@bytedance.com>
References: <20261020115306.813483-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: csgrmdnm4p9x6yrmrqdgsp4sidr6b9b9
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3A4512000C
X-Rspam-User: 
X-HE-Tag: 1792497513-465323
X-HE-Meta: U2FsdGVkX1+IJjXvrc3IfQ8rb36i+8SsBErIMdPJIcus7bVmakvhBLE8tUDJuZaJBS8grnIe6dQJW+jZe33jKtlfV2NQAfd8d7EBmAbr7L5MNKHzNfKDhpzv8JvGsiHbGHmwZ1rxf6/kbDjocjgvWht4EkItR8nPfCOEQyjCAJ/yjcuujbqMtuEjgFMOQuCsOaZ/9tKRW27q9rOT2VOnZoemZN1CUQhca5ZADJwZhuCHOIqk8A3+GeXmf2iYrnpMWGakLSYj+oNsxBZTSRsV3AuAGUxzTIaAHEqNCvLhxEOzfXMfinLdO0Kph1NVGSyWB3SOMqsswsUuiZCsnINn6MH8o03pKF/m2qYugQdL7LdAfXTqakV4+GQhGFmfN6k5Dlbify0op2dIG8PMpjwWOApu44znt9p1FuO8+l7OWOCtPgVq6+IVxFeQ9p+gnixr2k6um5gqQdLoElz5JEKUM+s2c0LgsTN1hMc+e4hdg9sBLB2jViQmWWPFQpgejcWsKRmtwUc2JUne6YlmNaishyeh1PaAY0gE4z51n3qiPYf/zciKSCb9SUJg1LyxHkyySOezpP1z4RVbK4oPYYXAWqdjtjW3DdtWN2joGRj+xsoS7aY1LHNgs03gLCi4KBaflz9IeD1aMvy+/1UhpFK6PZ+aKfOngApxudL51HBbYGs+pL17AwugsBeJBvj3Mf4B3r8TxacRB1nldGxF45LOpToqDYS2wOlRV5DJ/1ftK0JkqixNbMocJn2G98atbXIpkOHMqyb0yq+8BXDT4+4fW9GcysO/wL7j0k6DW5Aw6Zl+7S98RQ7Qwc5IiWEaggNPnGxAwWRP5lhqJs3/Ch+MQ00QYhbzYtK+nJqass02eIADKeSCbe1gQX53fITSxNp301BdFZzEHr4jZoC41G8K2re4jTgv6lPk2lGLDwy3+9iLG1BsUUV2JhZb/XMvkvCJ/0zs9IPMR0UC2vx79IL
 PKiMXptC
 2g/n2p1G5hcJ+tcr4YPuNKbGtjrhvlPveQgt0fatbbBCZzABywgNPne7TcDyB/0Cc527Rik4zauOu9FXd6BY1ADp8ujsvvSDdfi8AL4wHp07j+37Rfv7SXlrJj/rYKAAyCmXVI/AqAou/4nF3pY5LzavjqHgev2ekMFBoM75iTsgLnetf4DmB84BYLqRJp8navkDMml6j4hFZa12oxaKrWflzaF69AX2aN9Y9Mpmx+kPmn5X3s/Hhc+B3kpU3iSNso7CUM03tISoEvzy4gcW4fP57S1z3HA57b2Z64/Tl7NGDWi16O9lPxNFhx9sKpZGI5pxe2A12qRPuJjvoqIuxcN83wRl0a1le+VRFcSGd+eIKwLc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

VMEMMAP_SPLIT_NO_TLB_FLUSH and VMEMMAP_REMAP_NO_TLB_FLUSH do not
describe fully independent choices. A split-only walk can defer the
PMD-split flush to a later global flush, and a remap-only walk can
defer the final remap flush. However, when a PMD split is followed
by PTE remapping, the split flush must happen before the PTEs are
changed, because stale large-page translations must not overlap with
new small-page translations that map different physical pages.

Replace the two flags with a single VMEMMAP_REMAP_NO_TLB_FLUSH flag.
Keep split-only walks able to defer the flush, but force the split
flush whenever a remap_pte callback is present. Callers that batch
HVO work can still defer the final remap flush and issue their own
global flush.

Current callers keep the same flushing behavior.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb_vmemmap.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 1105aa925acc..8b3abb562599 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -42,10 +42,8 @@ struct vmemmap_remap_walk {
 	struct list_head	*vmemmap_pages;
 
 
-/* Skip the TLB flush when we split the PMD */
-#define VMEMMAP_SPLIT_NO_TLB_FLUSH	BIT(0)
-/* Skip the TLB flush when we remap the PTE */
-#define VMEMMAP_REMAP_NO_TLB_FLUSH	BIT(1)
+/* Skip the TLB flush while updating the vmemmap page tables. */
+#define VMEMMAP_REMAP_NO_TLB_FLUSH	BIT(0)
 	unsigned long		flags;
 };
 
@@ -85,7 +83,12 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
 		/* Make pte visible before pmd. See comment in pmd_install(). */
 		smp_wmb();
 		pmd_populate_kernel(&init_mm, pmd, pgtable);
-		if (!(walk->flags & VMEMMAP_SPLIT_NO_TLB_FLUSH))
+		/*
+		 * Modern MMUs allow overlapping TLB entries with different mapping
+		 * granularities only if they map the same physical address. So
+		 * remapping must not proceed without first flushing the TLB.
+		 */
+		if (walk->remap_pte || !(walk->flags & VMEMMAP_REMAP_NO_TLB_FLUSH))
 			flush_tlb_kernel_range(start, start + PMD_SIZE);
 	} else {
 		pte_free_kernel(&init_mm, pgtable);
@@ -272,7 +275,7 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
 {
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= NULL,
-		.flags		= VMEMMAP_SPLIT_NO_TLB_FLUSH,
+		.flags		= VMEMMAP_REMAP_NO_TLB_FLUSH,
 	};
 
 	return vmemmap_remap_range(start, end, &walk);
-- 
2.54.0


