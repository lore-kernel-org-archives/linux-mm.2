Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8143F606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 16:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NhD/xOlx
Received: by kanga.kvack.org (Postfix)
	id 6D0666B05B2; Mon, 23 Nov 2026 11:10:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65BB06B05B3; Mon, 23 Nov 2026 11:10:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 521B66B05B4; Mon, 23 Nov 2026 11:10:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FD9C6B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:10:31 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 980A2808F5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:10:30 +0000 (UTC)
X-FDA: 85466871420.28.C490D5E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id BCB6A14000D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:10:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NhD/xOlx";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795450228;
	b=oaFvcsl/eI2LpLqmIYl03RMlAL0Ypg4dWz+ZWrwjn1cdaKv09ZN+0/RJCURvhBu4lhXfPq
	kmeDeHuF1Dz9mj/iz/0Iv07siK5p6mCdxS+OwnwqcU4bJozRkf93S/oASwV4WSWcOl86wQ
	EJCPqVdU+mNDoxRInBQK9SiIMAKFDfQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795450228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lfsfc1WMfSC0QgUpwbLULjOQXGicAPKLtwLK5uI441Q=;
	b=uJ9ZmMe7GxUJQuE9R6tPNW8XX+16D0TS61QO75q8JZ2LQNCjQTLaHl2ew6AdYAT9g/Urok
	Pp80xMpw25oNpfwBj2BkXL8CiA07cVi8wlJ4o/mHLahMEoFBgrPq676JtSvAYq1XHA+Gmc
	rRW/EwX6jbUP/ODNWZeh+1bPmNe2MtY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NhD/xOlx";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A73B540A71;
	Mon, 23 Nov 2026 16:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8501F000D0;
	Mon, 23 Nov 2026 16:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795450227;
	bh=lfsfc1WMfSC0QgUpwbLULjOQXGicAPKLtwLK5uI441Q=;
	h=From:Date:Subject:To:Cc;
	b=NhD/xOlxcASeAudQuKlMZ5sD5z16j33iIQmWBQdrZ1Ow2Nf7X+7PfO2DUkpTg21R7
	 nI/DOR4DG37WrAXucBV+4HOr35ErWqSjeoGz+MaPylglqsCDsP/ce+LF590mrE0XKK
	 tp5beo3JoCjT52hiBgqbCBkgqM/BCEO78gNWk8axoKED1j3Pv47haxy6oux2MagLnm
	 3uDj7LBiga/vtH4LX2Y+OiNVc2Oa38GclNbw60zKndLhA+WJS328ZNEu3Q2gYtzDwU
	 WG7oULkRLPJYfERHt+jeRINzYumS0C3FBBPBjBNP+0rzGWUj+gX3C014V6U24hTUL3
	 uQv6yk7AcazJg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 23 Nov 2026 16:10:15 +0000
Subject: [PATCH v2] mm/rmap: correct VMA write lock position in lock
 ordering
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261123-fix-rmap-lock-ordering-vma-locks-v2-1-11b04646abe4@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/5XNQQ6DIBBA0auQWTuNYDHBVe/RuEBAnWjBDA2xM
 d69qTfo9i3+PyAHppChEwdwKJQpReiEqgS42cYpIHnoBKhatVIqiSPtyC+74Zrcgol9YIoTlpe
 9JGOrtGnurRlGbaASsHEYab8Wz74SMFN+J/5cxyJ/+ke8SJRotHK193pwjX0sgWNYb4kn6M/z/
 AIMNe4M0QAAAA==
X-Change-ID: 20261121-fix-rmap-lock-ordering-vma-locks-62593469bf59
To: David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org, ljs@kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3465; i=ljs@kernel.org;
 h=from:subject:message-id; bh=JFN3XXJROK9z0GHrDq6eqZSloqOW75UtPvr8ButN3P0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZUrN9Epjj/UR614id1zhvIph3tpNPeIV2Gr+kot9s6
 /idX552lLIwiHExyIopsjz/Ir4/SCRsXucFfzeYOaxMIEMYuDgFYCIbJzH8U36SlhZUujN8o9fs
 zoeXjywVMLlj6e1468eaP/tO3k4+as/IMF/5pnXQ9yzbJ5t/rBbZcezXETn9+//Dyjd4rZ5lmWC
 WyQwA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: gribguepk3jt8jcpwpidaarn1g83sznf
X-Rspamd-Queue-Id: BCB6A14000D
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795450228-893511
X-HE-Meta: U2FsdGVkX1/2V0Vbn4pe+Na6K5BN2zLtAZtKrtYRcVZqOgjySjyu627JnxZ/FGFfBYv82eoHS2tXF13/uPj9U5d8eAL4h3uetI5XCBuKZogz4Zm66y3CsTbYwBhYoMy6gLF99tXWs4+gtjkCwZm2nA4e5bFqasUIxZUINYRwALK4vnhKvMd8HXnMJSP5A3HiyWlL88Y4D05mfyq2Ibf9i6TjwbL487O9f50caYUUNWtUFla0LpY0HExSYsKvxRc/EmNCZza3TYMNutCkCgOnTOnJsE/hPq9kc+DxCFe/yKw5pW9hV7/AHgiPKlNK+9d/yBkLsfsY/5b6f9+j0xoJCwwIuL4oFjiDu2P8Cs6IPRF0FEo8ovQHkn6o7DcEJD3S9A5dlqdMSjcJPGzKBd9lLZaaUfODneXHjWX9l6B85B4OE83kfVvalL73mTmA3BfexoQzwYZdVPQeH2UixzlsAtJ+jILyKuUzqfwsHQJ1BlRtER4wWtOLikBfTGNHi3DuJE7JpuZwmKXQAzozkt8QH+WLmgKhyUCY5ymFyfkcXqQOXND3zuRZBSeE4dZECKbEdjGV+WJM6nUeAPGJg0xUSKR5a4C7mcJESMp0eIb6Z+5jnhX5yJ2FK13u5n6VGDHnI4GI3ZtqlrFTRlfmFji3JzG8cL11WHgHro+3MB47b2RmiXKVEwYmATUWH2/touyT+2817KFUQ8z6YHFakY9WkbUhPa8XgmOKODLEjYwA7o+Ha+dwcb+DsuCqMuYwLyW3JiRGzjOYoMWP2b1bWfhPr4aoePfXKfIift0TyiJ0E4otXudP4yVEYMXZ6i7PRerMFqoN67JFh2F9bZeLjFwcvVuk+EnTN4jUPFGcV+I3XBe08gSivy7bho08PXUgl3ekksDVt4azLZmbzeJOwFAmV4OjW+NBM0LW3Ov+eu7rhq+skdQNJ29lY1kDR3F47FMXPxeiUYml19F9NbEeF44
 mNx7uU9f
 8AC/WCLyLn4t4IgEJxYe860TWu116/EJaoSiZEDt3dUPMYGlo0aR1xf1JrudzYbuBkzwaBCnfCs94y6UfNP7bnRCHHTywHS7IsSp2zBGJzlYBOV4OZ4DpWhZYd8i4Vi4vdpKfHvnPnnI8TXY+T/p0wfwVc6NJeESVjEYeyoicEFKJG45mtKVPe3jvWoEgXZbl9HmDCq+3o3SXkaes6t/iMd1BLCMdfWaazKBbnaNFlL2+ycq6wdJDWtVlkk0s/8McodtufRRXZn47kkgKbiBei2oFtLBKT3WCVKQ/qXEyVdZdCx8HEiZyB5OSNx80HLUFJBu4ZvE8S9ys0u0XMU8adIHW2gzsMrfW281ZunAoMwt6lHzuftvpYNGhD53ih67h9FVz0WTczr66GVKgV8BvEwDPMqW74s2U8aFetnHVn5FTN6CPFZ2u/2gLzvAwJ8imvBnC/EqDwDxwaKeICbxDn2nvIxsu/GdnGDZd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The list at the top of mm/rmap.c is taken to be the canonical order in
which locks must be taken in mm to avoid lock inversion.

However, VMA write locks appear to be misplaced. These were added there by
commit 55fd6fccad31 ("mm/khugepaged: write-lock VMA while collapsing a huge
page"), which was focused on expressing the dependency of locks after VMA
locks in the ordering on them, disregarding those prior to it.

Of course, a VMA write lock requires an mmap write lock to be held, so this
leaves three locks to consider:

mapping->invalidate_lock (in filemap_fault)
folio_lock
hugetlbfs_i_mmap_rwsem_key (in huge_pmd_share, see hugetlbfs below)

Each of these locks is either downstream of a VMA, or is not able to
acquire a VMA lock at all (e.g. in an rmap operation).

This is because accessing a VMA's file (thus mapping), traversing page
tables to a folio, or interacting with hugetlbfs requires the VMA to be
stabilised in the first instance.

Nothing in the kernel takes any of these 3 locks before a VMA lock, and
indeed in each case that a VMA lock is taken it is taken before - so the
kernel is already violating the ordering as-written.

So fix it. Also add [_killable] to reflect the existence of
vma_start_write_killable().

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
v2:
* Updated docs to reflect change as per Suren.

v1:
https://lore.kernel.org/r/20261121-fix-rmap-lock-ordering-vma-locks-v1-1-952c0dd5bc3a@kernel.org
---
 Documentation/mm/process_addrs.rst | 8 ++++----
 mm/rmap.c                          | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/mm/process_addrs.rst b/Documentation/mm/process_addrs.rst
index 04b649818cc1..40be3a46a521 100644
--- a/Documentation/mm/process_addrs.rst
+++ b/Documentation/mm/process_addrs.rst
@@ -418,10 +418,10 @@ ordering of locks within memory management code:
 
   inode->i_rwsem        (while writing or truncating, not reading or faulting)
     mm->mmap_lock
-      mapping->invalidate_lock (in filemap_fault)
-        folio_lock
-          hugetlbfs_i_mmap_rwsem_key (in huge_pmd_share, see hugetlbfs below)
-            vma_start_write
+      vma_start_write[_killable]
+        mapping->invalidate_lock (in filemap_fault)
+          folio_lock
+            hugetlbfs_i_mmap_rwsem_key (in huge_pmd_share, see hugetlbfs below)
               mapping->i_mmap_rwsem
                 anon_vma->rwsem
                   mm->page_table_lock or pte_lock
diff --git a/mm/rmap.c b/mm/rmap.c
index 65646ed6fc45..55367e7d3eec 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -22,10 +22,10 @@
  *
  * inode->i_rwsem	(while writing or truncating, not reading or faulting)
  *   mm->mmap_lock
- *     mapping->invalidate_lock (in filemap_fault)
- *       folio_lock
- *         hugetlbfs_i_mmap_rwsem_key (in huge_pmd_share, see hugetlbfs below)
- *           vma_start_write
+ *     vma_start_write[_killable]
+ *       mapping->invalidate_lock (in filemap_fault)
+ *         folio_lock
+ *           hugetlbfs_i_mmap_rwsem_key (in huge_pmd_share, see hugetlbfs below)
  *             mapping->i_mmap_rwsem
  *               anon_vma->rwsem
  *                 mm->page_table_lock or pte_lock

---
base-commit: d12eccbcb79a4fa35c3aa588eb79056af62eb859
change-id: 20261121-fix-rmap-lock-ordering-vma-locks-62593469bf59

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


