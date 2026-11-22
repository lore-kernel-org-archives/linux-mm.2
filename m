Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7181606A337
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 18:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=nkYy5Bs9
Received: by kanga.kvack.org (Postfix)
	id A35946B05C7; Sun, 22 Nov 2026 13:45:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E6586B05C8; Sun, 22 Nov 2026 13:45:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85FA96B05C9; Sun, 22 Nov 2026 13:45:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4EACC6B05C7
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:45:22 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CCBD61C3B6C
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:21 +0000 (UTC)
X-FDA: 85463632842.19.DE0DF6F
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2396340006
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=nkYy5Bs9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3PjgDawoKCBsAK8FL78KFE7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--jthoughton.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3PjgDawoKCBsAK8FL78KFE7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795373120;
	b=1DjXREJF00B05HkBe7mmmzebdeQlYbxD7ipSEF3fnp964LPzHtF1d1gnGE2Bg7jY9l5nGF
	aALqMRwpbHLJIDmTW2UWMaPO9Fe0btpXERlG0xKJ4vuw0IaOgBimI3bze1VAYKWU796g03
	1hCBXjD8Kh85hbATJwbpI4eDBH2vhEY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795373120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JlyKIxCj5zXNoCwp2g1iooTjwoRbShhDI27qMEz7zxE=;
	b=7nS3hxoQBc3HQJikhfjGWr7zvyjVXVfomxYGF4Taz7Vau9gD6WACgTVDeJ3FcqzFFVvTJx
	86x+k0UnfPPOnJJZP7oAuUCZsMp7tIbizA3sFCb4oRIVHH4fmURf7nnTg5vw6tfUmQAE3Q
	AYOtDglEh2wgMeAIw1mcAngCx8rYILM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=nkYy5Bs9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3PjgDawoKCBsAK8FL78KFE7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--jthoughton.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3PjgDawoKCBsAK8FL78KFE7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--jthoughton.bounces.google.com
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ed08904845so37290415ad.3
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795373119; x=1795977919; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JlyKIxCj5zXNoCwp2g1iooTjwoRbShhDI27qMEz7zxE=;
        b=nkYy5Bs9BJHTvQgQShsQu1rB+EZ4I283n7QaFabtxfB6+epeexWYJLZFV+CnejXOqF
         7f/bil7gurtxX45HlQUd+n4ST+zSr0zRVtriTwlYRk9vK1s/ErYcq4oAbE2WfkpPJfH2
         K5n4NLsr69JvsluJrERP7kcFpFuPhNHjMoRMjy1r6NeUmm5Z7Pvvd8ctwr99Oll1AGED
         F5sgc84UxZGEk3M6u5mC40a23srvCkXuZ9SUx9AaIkpflyw6Peav9ljJhN2QF3JFUPPZ
         0/Een/CF1G49FxFdey3MjhfvM0Gz4TkxkxvX7bAYa1hgVxLbIJYGIEGkpq6+OXa7FbWI
         Vleg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795373119; x=1795977919;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JlyKIxCj5zXNoCwp2g1iooTjwoRbShhDI27qMEz7zxE=;
        b=0qAa2DZbSqH8NQ0/44AvW3vJ6AuZfDu0EM7dVooHzpFKo/a0AELG1E1kccC9spJHBY
         l3dWnqqAaElM4xg04n17fhSLXCHAdPf3wwbpvoxqH/tbqRTZ/kDnGqXKdKqI06WAD/V/
         iGT/O6XSW61DlAiiDHtd8S+RCdonRRkW0ix2ZCa2qUmLjobw/ogrAQfljL//LyKe/anp
         X2C5C6rqY29xEMrCogIqTTX6suAK+gup2YBlrQsmKEv1pNCHcJ9d3T0jkMGJdj4Xy3Gu
         KKMOWUkrPcC8gqk+VQJ/wNSAbPJuhLwm25F5k+b2q0Q7Xu+efbsvM+qgNNc7YLxGQLjY
         eQ8w==
X-Forwarded-Encrypted: i=1; AL+hErE3mVY5S8FBKpL2S9KlY70xF1Y/sCTyP4h7g/0rwFkNflEKWAsrQleGCYf6xUH1+NUlimgOVIYWnQ==@kvack.org
X-Gm-Message-State: APuU4Z8610B0X/4oHZIQYE44g0xsyA80+sRJC7rbwVg/t6hYvFmfcOTD
	aFoSjw5kk0iCGrTCsuV3ofi7cH/EYKWjOI0ZJAqZUjIGP5Uua2Ehp9ftynvHbdl+sYbvMoaxqJc
	acaZC8zcFBr6ffu9ebuZX5g==
X-Received: from plbl5.prod.google.com ([2002:a17:902:eb05:b0:2ef:f5cd:c465])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1745:b0:2f0:5b55:edf3 with SMTP id d9443c01a7336-2f05b55ee4bmr55875675ad.32.1795373118583;
 Sun, 22 Nov 2026 10:45:18 -0800 (PST)
Date: Sun, 22 Nov 2026 18:44:52 +0000
In-Reply-To: <20261122184453.2668189-1-jthoughton@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261122184453.2668189-19-jthoughton@google.com>
Subject: [PATCH v3 18/19 DO-NOT-MERGE] hugetlb_vmemmap: Add fault injection
 for in-place vmemmap PMD splits
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2396340006
X-Stat-Signature: kmpgbiamdt83aek7edptfa9seqhk6woy
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795373119-150777
X-HE-Meta: U2FsdGVkX1+GAkbowmniUQUY9E4GZumH2JElXmZCOJHLRFDHl/x+FFLwq4Ultq64C2TcVSIRmxGuok0N2vem1ZAzG+5XM4T2hoQFCWxIQahd1zfg2Cpc/lNGZMzOkmFV9I5QBfYKclA5Ceb0t/L+g/wXxE4KBJDm1c0HEA//PZ3QyNU2gHlS9Uw3FELT6vCN8tPubXdwz1oD1pz4sQeINgQcExBOF7Z023zdXfyarW9EV9iQaV//tvQris49xOi9CKQvuxw8Bbpo5VHEkRA1Cyowr3h1cgaTNY6YBY09QAascP5Y4o5KbngVpaH1wP6kruwrLMHGCe2n50z9u7rROV1+tOJQGrKZ15W+uXC+HnXKb3C4IWsiPDZO/EigpprNJNxjedRtKRRh0Wjh1qXk/ceWyEPkS8GPx+deqE+YU4WHB9TacJtw+kdhSopwirXWZfhSeyT6a6Klwb8/o+5UBKrNEbSTZjXIW9/D5/FVYF6bdZEkrrF+18ABUWmlnJAtLHARyO6zsLgMYYOjhekJ6v045Qcm/rxqTFr+OzLbAS2nvZT6GjJYbaRoiJpKtibcwRE8TOmKC9aJz/lC0hQryKHe9fTH1r3IfZ0WRkyX+3RQjrGEZxNc4Z/pEkYQ9U5vSM8GxO6qcTA4yk+SbwqSfOLX5O28sCmgI7flTJRMaL3BdZM8xwglARqau3UrUjUSaeeMiFdB0NQNwi6Zn9/2A2a40QbB5rcEWBPwHNTLEj01fO9/97dP1SjUCru6kmisqOkrzcyqOZudSWTN1iUkgxirPrbyMH7JUFXqA5cI/3syUwOrammTJxP9aSfEL+YRj4HQHBDbOp9Ikwk29ih1sUFRwYpVnsw0bU6JlZlm4QaIdYq5QWrOoxqvMPFub2P6iBcokLoOd7CY85VW1pf1c7sruPVTmAyuVNhc51GrLGTLUF3nZshTpobMHexkfWgKjMat2qC8OLry28Dudy9
 VomJpv2G
 4GCeijl4qoZNei/ty6cQvw5GNJhwTZOpVNmAzDYtE0xM+f7EIC6xC/XvaX6sDLrPFmJmEcI3o+uLaLTIncaLNTcbsihPdUn/OhVEVFlSkQN9GZKdp07fUWihE8Lm+o+L9Cv7JwvVS1ylwPuPfaX18jO744lGU4DNx5qp5kUJ8eyU5/8D0QTqARPuuN9bviGwqf1nLMS2DLI4BVzrKxyk0d09BAjSkHOog6Rq+6NLfP1oDN3qi/tZnozOjxv73+XdTqpgrdGqsnOdMWsH6DSJ2PkB1c7HZ3msP8F+BRJmkEb2/849FwA+E4qLTeJfvDVF/gJyR3BTXtxkcMhycBlJKpLIjjQ8xRHTtQ0pmFr8SEsR0ovWqvssB7spcOlD9iFUsPplHB8QAJqJSljyuOUeq3ng195BRDiGHEhvHxeAQ0xZxcHbyzneJ30bNjr6b0hHyBtyhM1geKEZ61ELCTiDXX4CLBt9X31OHUgSuwza3Im18RTG7fcUBCFvqs+2RGmGf028Lg89vEa0Y1nbY/5ZqequPUxBRCC/y8w8THxX7lSsirBLxS3XtuFq8a8pYPgDhJVAQP7KFfBpHrK4CGvcszP4s6v6C0ZOuU26FkPiHrE5Ra534Fku9pGSgnF+tT7xUfRwBQwYdTFaG9Y3ho9ak6QEQofKWCjri4W1NApTa8bgSPm7i+v+bICBeJRxAuz5pivXkH1rn7FYzxJYUN1ASN1Fbsmn+zmdoPsE8JPfSTJ2ZxM0TuKLIjPVvEYlbKosToUHoJPgTanNRM4ELMGGAVW/02G4hT0r1JD9gZrKRu2+bAVdkJilxV2EsbnyqdjgvnUXbD19/skpJwtvT7e4oQWXXt+C6VSuu4USd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Like try_update_vmemmap_pte(), try_populate_vmemmap_pmd() may fail,
e.g. on arm64 when replacing the block mapping keeps racing with
hardware access flag updates. HVO handles such failures by not
optimizing the folio.

Add a fault-injection capability, fail_hugetlb_vmemmap_pmd, alongside
fail_hugetlb_vmemmap_pte. When a fault is injected, the PMD split fails
with -EAGAIN without touching the page tables.

It can be configured through debugfs or through the
fail_hugetlb_vmemmap_pmd= boot option. Since vmemmap PMDs are only split
once, the boot option is the most effective way to exercise this path.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 .../admin-guide/kernel-parameters.txt         |  1 +
 .../fault-injection/fault-injection.rst       |  8 +++++---
 lib/Kconfig.debug                             |  4 ++--
 mm/hugetlb_vmemmap.c                          | 20 ++++++++++++++++++-
 4 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index b8a8771631c0..251bd0f4afa3 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1695,6 +1695,7 @@ Kernel parameters
 	fail_page_alloc=
 	fail_skb_realloc=
 	fail_hugetlb_vmemmap_pte=
+	fail_hugetlb_vmemmap_pmd=
 	fail_make_request=[KNL]
 			General fault injection mechanism.
 			Format: <interval>,<probability>,<space>,<times>
diff --git a/Documentation/fault-injection/fault-injection.rst b/Documentation/fault-injection/fault-injection.rst
index 403206645fa4..5cfabea811da 100644
--- a/Documentation/fault-injection/fault-injection.rst
+++ b/Documentation/fault-injection/fault-injection.rst
@@ -16,10 +16,11 @@ Available fault injection capabilities
 
   injects page allocation failures. (alloc_pages(), get_free_pages(), ...)
 
-- fail_hugetlb_vmemmap_pte
+- fail_hugetlb_vmemmap_pte, fail_hugetlb_vmemmap_pmd
 
-  injects failures of the in-place vmemmap PTE remaps done by HugeTLB vmemmap
-  optimization. (try_update_vmemmap_pte())
+  injects failures of the in-place vmemmap PTE remaps and PMD splits done by
+  HugeTLB vmemmap optimization. (try_update_vmemmap_pte(),
+  try_populate_vmemmap_pmd())
 
 - fail_usercopy
 
@@ -269,6 +270,7 @@ use the boot option::
 	failslab=
 	fail_page_alloc=
 	fail_hugetlb_vmemmap_pte=
+	fail_hugetlb_vmemmap_pmd=
 	fail_usercopy=
 	fail_make_request=
 	fail_futex=
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a6a9bc01a320..68244c0e4a81 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2104,8 +2104,8 @@ config FAIL_HUGETLB_VMEMMAP
 	help
 	  Provide fault-injection capability for the in-place vmemmap page
 	  table updates done by HugeTLB vmemmap optimization (HVO), i.e.
-	  try_update_vmemmap_pte(). This exercises the rollback and
-	  partially-optimized folio paths.
+	  try_update_vmemmap_pte() and try_populate_vmemmap_pmd(). This
+	  exercises the rollback and partially-optimized folio paths.
 
 config FAULT_INJECTION_USERCOPY
 	bool "Fault injection capability for usercopy functions"
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index d3230588f31f..95a42f59c16b 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -47,6 +47,7 @@ DECLARE_RWSEM(vmemmap_remap_rwsem);
 
 #ifdef CONFIG_FAIL_HUGETLB_VMEMMAP
 static DECLARE_FAULT_ATTR(fail_hugetlb_vmemmap_pte);
+static DECLARE_FAULT_ATTR(fail_hugetlb_vmemmap_pmd);
 
 static int __init setup_fail_hugetlb_vmemmap_pte(char *str)
 {
@@ -54,11 +55,19 @@ static int __init setup_fail_hugetlb_vmemmap_pte(char *str)
 }
 __setup("fail_hugetlb_vmemmap_pte=", setup_fail_hugetlb_vmemmap_pte);
 
+static int __init setup_fail_hugetlb_vmemmap_pmd(char *str)
+{
+	return setup_fault_attr(&fail_hugetlb_vmemmap_pmd, str);
+}
+__setup("fail_hugetlb_vmemmap_pmd=", setup_fail_hugetlb_vmemmap_pmd);
+
 #ifdef CONFIG_FAULT_INJECTION_DEBUG_FS
 static int __init fail_hugetlb_vmemmap_debugfs(void)
 {
 	fault_create_debugfs_attr("fail_hugetlb_vmemmap_pte", NULL,
 				  &fail_hugetlb_vmemmap_pte);
+	fault_create_debugfs_attr("fail_hugetlb_vmemmap_pmd", NULL,
+				  &fail_hugetlb_vmemmap_pmd);
 	return 0;
 }
 late_initcall(fail_hugetlb_vmemmap_debugfs);
@@ -74,8 +83,17 @@ static int hvo_update_vmemmap_pte(unsigned long addr, pte_t *ptep, pte_t pte)
 		return -EAGAIN;
 	return try_update_vmemmap_pte(addr, ptep, pte);
 }
+
+static int hvo_populate_vmemmap_pmd(unsigned long addr, pmd_t *pmdp,
+				    pte_t *pgtable)
+{
+	if (should_fail(&fail_hugetlb_vmemmap_pmd, PMD_SIZE))
+		return -EAGAIN;
+	return try_populate_vmemmap_pmd(addr, pmdp, pgtable);
+}
 #else
 #define hvo_update_vmemmap_pte		try_update_vmemmap_pte
+#define hvo_populate_vmemmap_pmd	try_populate_vmemmap_pmd
 #endif /* CONFIG_FAIL_HUGETLB_VMEMMAP */
 
 static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
@@ -107,7 +125,7 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
 	if (likely(pmd_leaf(*pmd))) {
 		/* Make pte visible before pmd. See comment in pmd_install(). */
 		smp_wmb();
-		ret = try_populate_vmemmap_pmd(start, pmd, pgtable);
+		ret = hvo_populate_vmemmap_pmd(start, pmd, pgtable);
 		if (ret)
 			goto free;
 
-- 
2.56.1.809.ga0b61035b5-goog


