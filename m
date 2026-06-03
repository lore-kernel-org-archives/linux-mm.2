Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ECFFCD6E56
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 10:46:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 133F36B0095; Wed,  3 Jun 2026 06:46:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BD5D6B0096; Wed,  3 Jun 2026 06:46:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEEA66B0098; Wed,  3 Jun 2026 06:46:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF82F6B0095
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 06:46:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A4798161DE8
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:46:56 +0000 (UTC)
X-FDA: 84838273632.10.24D1AE1
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf28.hostedemail.com (Postfix) with ESMTP id 11836C0009
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:46:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SaLIqHE8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780483615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Db5QI22S+PmAf36h4l+5enVOhe4SLTSWaLegqKX8Kk=;
	b=P0soXPlrhoekgbCxiCHZDOqeE7pr96q8WsSWLDxTXr+ZsJbimtgBGvA3jNQGy2fuXj7h57
	r0oceIK+rVKyLN7G5/PUlKK60eXNkUJC8wM9tC7B2PiudWHriV1VhmBhv8DxITy8Wg/s0s
	a7n5YXUMwmlluZKtEkLgqiWMRTcmsIw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SaLIqHE8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780483615;
	b=PU0M1rJBP+cBQHgdPE6I+Ig7AptydbqBKyDDwC1AfszztnTI3tbQM7cyXXgCr5shrBt7b9
	Xvxwi8JRzUHsUNVziO0w4Z8YhYJUIDrbCyZJPLUhwiSJuvjymM6lN9CZfb0gSWKYctby7P
	vqL6XbFCr+rlH1VsxRCuKkXU4qfWGl8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780483613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9Db5QI22S+PmAf36h4l+5enVOhe4SLTSWaLegqKX8Kk=;
	b=SaLIqHE8MVrLhRMMW0UhnyHGHtygmT+8OPgIfrPnznSMLhbnKq1Dva1IY/qFMx5UbuTa7B
	SRRrqJmht8UHrPAlzA+ElUGKuRkKgGHDfJc3y8Frp/EvyIGBjpEgN5lZz3e1bVLojR5plw
	Awtl1jk5pJEwB6evELNS5wwPVEkxrBw=
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: rppt@kernel.org,
	david@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	peterz@infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	xueyuan.chen21@gmail.com,
	ioworker0@gmail.com,
	Lance Yang <lance.yang@linux.dev>
Subject: [RFC PATCH 1/2] mm/secretmem: try to restore large page mappings in direct map
Date: Wed,  3 Jun 2026 18:46:23 +0800
Message-ID: <20260603104624.36390-2-lance.yang@linux.dev>
In-Reply-To: <20260603104624.36390-1-lance.yang@linux.dev>
References: <20260603104624.36390-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: pm6g3amdwabtbn4wpdxaxjceawc7uuwm
X-Rspamd-Queue-Id: 11836C0009
X-HE-Tag: 1780483614-215816
X-HE-Meta: U2FsdGVkX19nR6kfZmynWcMR0d3H5pxJ6NKfdROB8PzzuHlyXLY+okU9GJhdG6c8845/QUTAJ1A41GA/2tLuFC6/dh40U4s+LYQBB3k8r0eoWDXEJ/QoptwrKldoxdNJk5/YLxQMbJwAhiquSIuKmcrucBrloG4gVwPrGFfKYrMfM3cCQoeyT/PQsCOT2+1WnoyTyM78KIzSybFgV7CiZKXzLX6AIgVE9KhbOdGmIufIqbEo4Mv2/QgnxmNirxlvw1dRbgY3EdKqb7UPrAEzGFnjD0uOng90OcB4tjCYW7xSkpem0L30tVDEw5lOZkhyn+in1P6FezQVxA1wdy7gFGcIkrKb3pBbc4aOYdoyhG3nzDtJowKakFB4P+5Vru45s/2zCPkn/vsizgSJ3P6QQSuYY/38GI4uKtID+DFtk/2IK3o1HvpPF72SnOjTAbRiyFsBKmsgu64l92DYR/fvTNq5mxBt6HTxQBbGE06LLeu4pd6m3a0PGC9VTEA5BATMLIcsz0XsDw9avIFOh2WDwOQYsAIyOauTqaNt2pZW2G0/RiW8+2mf4yRmovci3qfmE/uXCaBeieKLtqRxxLS+EX+O0f0LgqNL5dztBbxjqSnHghb4sEmvLFSrBVftQKBWjhBTis2ETxfkGd9Tr6PMQgCgyTfxC95LB+frLlxKyx2gVPzxRaLYV6LzDbEMq4SIv/Cx6wEox8XOr3sAyUPtefPJOGpTs/RvNiJmY0liB7T+8uyrKmARTyx2meaDvQwhhsrC25M65vYRf4JNcycATU/CFTdDT8/MLBjb2u+uuB3SwStfMlrW9MxfVDj9SA5VGpD6ZI46smwxD38lyKMzbdbmvF+B+/pSX2xSzt2Xs15BeR6oCZaHsqfDF7xGfDmRdY+n3uRVI1ImzJPXViqgevSx0WQEK3B3Wk2rzGypkjRiSlUVU3n5QfjH08sZmPmav6FoRofsRjg3A5C4m7e
 TdqZed8M
 fxOcX6Y1CxkS1EqcEmfxWfUn+PhmCqvQ76K3JJZLOwmKLVUhsDeFf+UciXTT9uCgkagBUD2DJ14dZv8e9VOYVLQHaPBV32TnQefJPRM1KTWOiLYN2/qoMdIljlMH2SGK+ar+DKu+smE4IQlMHFON+NtPAyvh9XbScYrYu7F1lMen8mANgZiYXCdR+czX4LeYIX+eM/LlUAETa3oAzm5Uy95Wiu9AzZBCdJhY6kQ0TcnZGbjUuYoKidcFi0FHxVDPeV2TsGuFrVNnfn960qFIvNEiP7ErAADt3fmOjovLSZe067As=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

secretmem removes the pages backing secretmem mappings from the direct map.

Removing one base page from the direct map can split the covering large
mapping down to PTE mappings. Repeated splits can leave more of the direct
map mapped with PTEs, meaning more TLB entries for the same range and
potentially more TLB pressure.

So let's try to restore large page mappings whenever secretmem restores a
folio to the direct map.

Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 include/linux/set_memory.h |  6 ++++++
 mm/secretmem.c             | 12 ++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 3030d9245f5a..ad2fa414a22d 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -58,6 +58,12 @@ static inline bool can_set_direct_map(void)
 #endif
 #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
 
+#ifndef arch_try_collapse_direct_map
+static inline void arch_try_collapse_direct_map(struct page *page)
+{
+}
+#endif
+
 #ifdef CONFIG_X86_64
 int set_mce_nospec(unsigned long pfn);
 int clear_mce_nospec(unsigned long pfn);
diff --git a/mm/secretmem.c b/mm/secretmem.c
index 5f57ac4720d3..82634b99aa2c 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -47,6 +47,14 @@ bool secretmem_active(void)
 	return !!atomic_read(&secretmem_users);
 }
 
+static void secretmem_restore_direct_map(struct folio *folio)
+{
+	struct page *page = folio_page(folio, 0);
+
+	if (!set_direct_map_default_noflush(page))
+		arch_try_collapse_direct_map(page);
+}
+
 static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 {
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
@@ -87,7 +95,7 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 			 * already happened when we marked the page invalid
 			 * which guarantees that this call won't fail
 			 */
-			set_direct_map_default_noflush(folio_page(folio, 0));
+			secretmem_restore_direct_map(folio);
 			folio_put(folio);
 			if (err == -EEXIST)
 				goto retry;
@@ -151,7 +159,7 @@ static int secretmem_migrate_folio(struct address_space *mapping,
 
 static void secretmem_free_folio(struct folio *folio)
 {
-	set_direct_map_default_noflush(folio_page(folio, 0));
+	secretmem_restore_direct_map(folio);
 	folio_zero_segment(folio, 0, folio_size(folio));
 }
 
-- 
2.49.0


