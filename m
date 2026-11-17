Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04E84606A331
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 07:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Gk/GgABe
Received: by kanga.kvack.org (Postfix)
	id 9311D6B05B3; Tue, 17 Nov 2026 02:06:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9086F6B05B4; Tue, 17 Nov 2026 02:06:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 844C86B05B5; Tue, 17 Nov 2026 02:06:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 49A346B05B3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:06:30 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5F05A0353
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:06:29 +0000 (UTC)
X-FDA: 85443727698.20.60ABCA6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id C875D140005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:06:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Gk/GgABe";
	spf=pass (imf09.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794899188;
	b=LQasjADNcotTjZk8alJD3aUVPjySGEheMEm/PTnVAkJoWKPRrFi6eIXXbxG2du1GUdyuNP
	d5+pvZiYRUZbFtycknXb6hiQCFSD0XRPGR2lyYBzUjmZoJzVqpq90U6vr/Db8PlqfnJUgG
	mO6+XhCjgGrr+4axpfF+QgTmgfw/VOU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Gk/GgABe";
	spf=pass (imf09.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794899188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VxFcy8PKx6V8No66MGrguMxDSfTLhEbknnyi//iZI3Y=;
	b=UdbVG3SCOTUeGh0exLn0tJTfHrIwqD8I2TG3aBaqESbclXq8VELydLpxWWIKufcPzfHnk2
	AOE4st9vmeDK3I6uZjYTfUx/Y63zeX67XF8oPIlWS3eyygej+RJD7zC9f/q3qxUI6SNmp9
	ld4X3fHmheFbUTQ349QIZnUG9opQhv8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C7D231682;
	Mon, 16 Nov 2026 23:06:23 -0800 (PST)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 07F5C3F763;
	Mon, 16 Nov 2026 23:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794899186; bh=UnzSilSlVS1NCHSUp1WoAnzaARkiHzJI5hnwnTe1Uzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gk/GgABeD/14pTTFfV8US9VkS+al86VX97bJNhClt48hihMIMCHnDOwsnerG6mef/
	 cRpa/tnybrxi2dQnTabQoqeO53w83vN4bVAYSq6N+OmWWEPZdUnw8O/sH5aIwwurRB
	 przCzd31v1+SlkZJUi2Wso50DdEIRR6zW77Dkvko=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH V3 01/14] mm: Add read-write accessors for vm_page_prot
Date: Tue, 17 Nov 2026 12:36:00 +0530
Message-ID: <20261117070613.1183243-2-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117070613.1183243-1-anshuman.khandual@arm.com>
References: <20261117070613.1183243-1-anshuman.khandual@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C875D140005
X-Stat-Signature: xh5debiy1roqk11nzwsua6p9wxoqduzu
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794899187-400806
X-HE-Meta: U2FsdGVkX1+c5EQD0mCzSoNYWx4g1oJ/Mj3uajjOmNa95OG4S0L2tRvI6FratVMuyhW/whC26TZxcmnBkvaZqF4oIORWo7MpaAGOGB6y3iUQ8xhnHRlb+f4FLrwgkHnmzOa8DpLDSqL18rgg/BVuhEQdLd1yIDAUP3GnNSZU5xBgRuy1FPsOBVddXBmE1l4pcQhwYTCzYf9XVQnDbmOHqaSLXTPFAPiStS5KY+A3N1y0bhdHEb3e205abpxYdxgitUK1y/3hwRcObu8vN/Qd9DBOX+mxXV6fD5L6h7T1Sg3p8qJAwqmdLHrYDkVfAC4sgDNSMhPZ6GSWjTSzXZsDm4vvsZiWHUL8uzf2bJnsjdTCrgOjfhA3dRE4YeMiJkNUtkoSwxK2tMhQp7mO7+DkKqO1CcSsCgTJeIlf44Zg1KnAueGJvIwS9aZ+MOpTT0AmS4DaoLg9CPbx9wvSs/ZQCPUIQWZ82eUbRKwDSXxG5KpbFmYcVoQ6DqkGzUTDyCFylYFtBJB2+Xd34d7J8Jo/CMD+KxacAFlAjl5J35VXZz/wHPDil3baQ3Ygc2oGUaM0wJOHOzNmORZr/QQb4BrWHHg7SkUCM9V+LwyY0nnveBLj1hBg3Fw/YbN9ygwyx23jGy3ZCaNA26rpPNZawib1qRKiyrYHdmOCjg03NSVSOmly6bqPvxa8L8QdHdvitO2L56lblWyNdtZ4P8MReZHKt/IaTzf6Of9EDY1xD1HMAudOQXw+eDy2mMhCKJ970E9HwmhnUAMfoTnNUgPULgV7RActuF224mtSqC1atE5LtA1v3porOHZBGJcXZeFp5UpJJO43ZzsCQoIyO9Z5gZo7vCfb1uHL/QMxlGia8WrWban2BFDKGXmFBWr/xZ2yDfvXUWliERF4IcEndLnpO1Fx34RNnCZNjMK6lB6AGShFyQ1inmL4/eoVeJrZkHbdpABlEUP8GdHrEi9/0QcufSN
 ToqpoVai
 GGiNiUhRlABC4JyTvhbFmG1UhcnycFHKdECqaUyESmgnuhMmj3QNMeiDeijDg0Rzld+RFuAREPUA7tHsGs8A1lcac+1xZ0l8qttS5YqXr/U/lFqYo4FvLremtZyHCX/Tg3C7IvOxV6OkC4un3MDVtMjBp+yKjfVNur3s+NePsj94rNvtH5w9AWVYRphDw/3oCqlVK1a9sMZux81eQdCZWjruT6vw6jaQW2v7uySeG+a+Sh/fY7AjGAZpI27vdtSCzjWlGXHJZhXgVL4mEXuVl8UD4A6bAYPw9sHSvKr2OmfksLqvBPF4N24NlcjWvqeT0idVfyMNl1JTnTZDknnZdg6DesuYYMAGxqCky4geRAQ808ppF6QO+JnTPc/IbIxvLF/wdEIQ9fc2BcAqbDRQ7Rnck7gLOooT7JMXW0mXn4CO5gG1hKcz6YBGk72gXD/u2lXeQzXsMUNSe7ZToU5F43fxacSDusTC36T6BPHvajpl6MBXzvTDNmSHwedX5nFQXIPiO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently vma->vm_page_prot is safely read from and written to, without any
locks with READ_ONCE() and WRITE_ONCE(). But with introduction of D128 page
tables on arm64 platform, vm_page_prot grows to 128 bits which can't safely
be handled with READ_ONCE() and WRITE_ONCE().

Add read and write accessors for vm_page_prot like pgprot_[read|write]()
which any platform can override when required, although still defaulting as
READ_ONCE() and WRITE_ONCE(), thus preserving the functionality for others.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
Changes in V3:

- Add const pgprot_t * in pgprot_read()

 include/linux/pgtable.h | 14 ++++++++++++++
 mm/huge_memory.c        |  4 ++--
 mm/memory.c             |  2 +-
 mm/migrate.c            |  2 +-
 mm/mmap.c               |  2 +-
 5 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 780fe849ff8b7..3e3d76d6d058d 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -524,6 +524,20 @@ static inline pgd_t pgdp_get(const pgd_t *pgdp)
 }
 #endif
 
+#ifndef pgprot_read
+static inline pgprot_t pgprot_read(const pgprot_t *prot)
+{
+	return READ_ONCE(*prot);
+}
+#endif
+
+#ifndef pgprot_write
+static inline void pgprot_write(pgprot_t *prot, pgprot_t val)
+{
+	WRITE_ONCE(*prot, val);
+}
+#endif
+
 #ifndef __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
 		unsigned long address, pte_t *ptep)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index eb913acb03b74..b1988adde11e7 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3438,7 +3438,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	} else {
 		pte_t entry;
 
-		entry = mk_pte(page, READ_ONCE(vma->vm_page_prot));
+		entry = mk_pte(page, pgprot_read(&vma->vm_page_prot));
 		if (write)
 			entry = pte_mkwrite(entry, vma);
 		if (!young)
@@ -5217,7 +5217,7 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct folio *folio
 
 	entry = softleaf_from_pmd(*pvmw->pmd);
 	folio_get(folio);
-	pmde = folio_mk_pmd(folio, READ_ONCE(vma->vm_page_prot));
+	pmde = folio_mk_pmd(folio, pgprot_read(&vma->vm_page_prot));
 
 	if (pmd_swp_soft_dirty(*pvmw->pmd))
 		pmde = pmd_mksoft_dirty(pmde);
diff --git a/mm/memory.c b/mm/memory.c
index ec3d9d99ccee2..3912608154762 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -915,7 +915,7 @@ static void restore_exclusive_pte(struct vm_area_struct *vma,
 
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 
-	pte = pte_mkold(mk_pte(page, READ_ONCE(vma->vm_page_prot)));
+	pte = pte_mkold(mk_pte(page, pgprot_read(&vma->vm_page_prot)));
 	if (pte_swp_soft_dirty(orig_pte))
 		pte = pte_mksoft_dirty(pte);
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 875079464930a..a40f83196499c 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -387,7 +387,7 @@ static bool remove_migration_pte(struct folio *folio,
 
 		folio_get(folio);
 		new = folio_page(folio, idx);
-		pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
+		pte = mk_pte(new, pgprot_read(&vma->vm_page_prot));
 		if (!softleaf_is_migration_young(entry))
 			pte = pte_mkold(pte);
 		if (folio_test_dirty(folio) && softleaf_is_migration_dirty(entry))
diff --git a/mm/mmap.c b/mm/mmap.c
index 7618e72766a52..57ffe5a94ee50 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -89,7 +89,7 @@ void vma_set_page_prot(struct vm_area_struct *vma)
 		vm_page_prot = vma_pgprot_modify(vm_page_prot, vma_flags);
 	}
 	/* remove_protection_ptes reads vma->vm_page_prot without mmap_lock */
-	WRITE_ONCE(vma->vm_page_prot, vm_page_prot);
+	pgprot_write(&vma->vm_page_prot, vm_page_prot);
 }
 
 /*
-- 
2.43.0


