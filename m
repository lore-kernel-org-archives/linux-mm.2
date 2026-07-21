Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C04C9C4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 16:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EBB36B00A5; Tue, 21 Jul 2026 12:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C3066B00A7; Tue, 21 Jul 2026 12:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 800466B00A9; Tue, 21 Jul 2026 12:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 445A26B00A5
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:24:39 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C29591C00D2
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:24:38 +0000 (UTC)
X-FDA: 85013307036.03.ED019E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 34B5CA0012
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:24:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y40sTc2v;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784651077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s+fAGwkj37+ME7Pb0rsrK6LPOBZGydYbqjFxeMM43qs=;
	b=gOImrnpsltpX8UNrtieSNoRy7a618U0uVfc3oy0sXa6EvI80ovoxIiRtAN/kiEyMlRDXHV
	Kj1dldh+00wjEyNPRr68N2VYKxLmAACAtvKNd2PEPl3ofrXXQjrwZVVHlKA+heusytR4r8
	91hFad8qpntz4+zaBHPmtrNhryu+ngg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784651077;
	b=Q42GnG7umzCSI/av1EIxbmFdMv7UIX2iIIxS1SdYuREtivfe+2zi3rocaFWuKQCQPzt6wP
	O8PlHPTcgwHgrydNtApAcFjchk1OIM6Zvf8EAXnVr8WIpdRoFheo4ww6kOY+FquwQaLepP
	t9Gi7zN03i4rebwgUO8zvIvZjiVVUqc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y40sTc2v;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D253760A65;
	Tue, 21 Jul 2026 16:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370D11F000E9;
	Tue, 21 Jul 2026 16:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784651076;
	bh=s+fAGwkj37+ME7Pb0rsrK6LPOBZGydYbqjFxeMM43qs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Y40sTc2vrbeiNxDRxijWQmoLZupCjYYBLIzRIrURtoo3cDYHr5ZhKX2eqWO5Ns/9M
	 VWE7/yT06n+QRfyjogcDC45ebqMMD7SdkLyRKsNKmMuL5obaqIIuDsCjanWsgfwzrw
	 cNesCrWBJcDQ75nQP1mhcRx593LcEO94fvoZMWlfhl1r0xwzsbMZ9+NX+FEMYVsT+F
	 mKy8et9CuedtDDog/EjWVPYtVcr1/Kaiz0PWF3WoioZkDaWdkK8y+MHKL1arlrbJeB
	 Ph2fAs7rl++yRte5vI2YNioSX3LdjWLts0yl4+kaXBmoTOVKSN+a2vBm/IfjtVTZq6
	 sZT1yAdoXsXcA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 21 Jul 2026 19:23:31 +0300
Subject: [PATCH RFC 08/18] x86/mm/pat: use cpa_split_data structure to pass
 split parameters
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-generic-set-memory-v0-1-v1-8-2c1fc62306b3@kernel.org>
References: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
In-Reply-To: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
To: linux-mm@kvack.org
Cc: Albert Ou <aou@eecs.berkeley.edu>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 Brendan Jackman <jackmanb@google.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 34B5CA0012
X-Stat-Signature: g3t6hopw6nnfknje3p1t9a8bez1oqjce
X-HE-Tag: 1784651077-857180
X-HE-Meta: U2FsdGVkX19UXRpzR3aILIECb2ZC6m3cLMdnWhii8tZsw684ux+HDkpywAHvaa+/nGC3QJgKxdraT6cAYZlWZSloAUV1TMN0HvjgwHxL8564l3ZYGkgG4AuYHbmCSTG5whwbdJ/yCf0uMUtPe/W+BF/jzMnPF0CYLzqng8BZefhKEQSTMMTMoF9XAAOXwZFvD+uNCkD5/u+KIWjWoz7lAv7dSM9W820YT6UIfgGsSOyUE/skLTh5szFOK/fGxxyWb4ZWq/Wp/mGIC8Vncg76sGJv21hH6NHEcpK3PEo1hORoJxuwuhRyZcEq166xtLPrwAWOh3OOWRyotT80FvnNqPa9nIQW6X2QK8y+4EvERlEK5VGqGTXSd9Kz4mOtElbSgNpxLcHsYyjwLS/EixXYCanyOyRDa7+UO25r0nCD9Juz6E/BobOTIf1KlbVf4KnCIghVP+zv+4+EAyceeJFgofiZXJYtpjgb2X3l2KrEjtVPshZ6XcP9lGVo8i4NbiMcLKPjozUXC3I957Ol2FX9xp1MTdhIWPp0J9TxDm8X/2/HLfXmdAy5SpeiVNrjtwjtfGX6jHaSspo5qIJZy0Cp69EfTWEAZFnznjnnNtQVJg45c0Ycs3W00b12ENRLHixHc+RMESLRPYRUXPth/SsRNQtMT5m3+AcMBhzuHVUnkRnjeYHZTQHeo/96jbuQ9sfJHlsa73MEOCH4Uq9/7mVjYbiUI+9k0cylnfYQsYAdkIRgu4cqXZSlyIWb4t427cn8qjUzXOOUfc3ZtmXPKTw8IW/QBDGHUMgaLa9onwLX2PY1mGXTQniiDVoXfaFFVuPuRWN/uXOTFtec+v082sMqD7dplztQx5tRvkmRKL6kicpaFUgyjpW3pfcYmO+As5t8sykFEFaStm7clT8Y+/asF8E9wtjssMfPfBuyZNIjtBvLHBQc8KrHSIoxWltry4/TpqQHHbSdqQKtgnjZQK8
 1TcxaE7Y
 4RmdYbl+Eb4f7VcZE7E8JCQUjZ/9Rm+uhyBS9KZ4Y7vkfZfgKknovPfp9ztMF/+gs/4lQtK8MEw05ikshjqddwHAUF8Fn7GTbv1fG56iR4pLdBrG2BhZ4mcgSEwpqEnIYo7eTLdasmP97wB1AD0eIFYher5Gv7DnLr5/J+JpOaIXDcoHZBCtt8NHes/+rD67ijvjoDe6yNhGdeJOxc7D/5RjnoWIfTcL+ejGwHAlH5Zp+0RIDr8lMVtJLdlbwohdKCo5BCH3wd7hO9HENEz1EEzWnGt/Kf0oIqmFvbmOSPbT9QSQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Keeping all split parameters in a struct between
should_split_large_page() and split_large_page() allows maintaining the
split state that is initially established in cpa_handle_large_page(),
then this state is updated in should_split_large_page() and finally
consumed by split_large_page().

Start passing parameters between should_split_large_page() and
split_large_page() in cpa_split_data structure.

As the first step only pass the existing parameters in the new
structure.

No functional change intended.

Assisted-by: Copilot:claude-opus-4.8
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 49 ++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 18 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index a9d270e986ff..c2a72cd8b832 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -53,6 +53,15 @@ struct cpa_data {
 	struct page	**pages;
 };
 
+/*
+ * context for checking for a split a large page and splitting it if required.
+ */
+struct cpa_split_data {
+	unsigned long	address;
+	pte_t		*kpte;
+	struct ptdesc	*ptdesc;
+};
+
 enum cpa_warn {
 	CPA_CONFLICT,
 	CPA_PROTECT,
@@ -869,12 +878,14 @@ static pgprot_t pgprot_clear_protnone_bits(pgprot_t prot)
 	return prot;
 }
 
-static int __should_split_large_page(pte_t *kpte, unsigned long address,
-				     struct cpa_data *cpa)
+static int __should_split_large_page(struct cpa_data *cpa,
+				     struct cpa_split_data *sd)
 {
 	unsigned long numpages, pmask, psize, lpaddr, pfn, old_pfn;
 	pgprot_t old_prot, new_prot, req_prot, chk_prot;
+	unsigned long address = sd->address;
 	enum pgtable_level level;
+	pte_t *kpte = sd->kpte;
 	pte_t new_pte, *tmp;
 	bool nx, rw;
 
@@ -1016,8 +1027,8 @@ static int __should_split_large_page(pte_t *kpte, unsigned long address,
 	return 0;
 }
 
-static int should_split_large_page(pte_t *kpte, unsigned long address,
-				   struct cpa_data *cpa)
+static int should_split_large_page(struct cpa_data *cpa,
+				   struct cpa_split_data *sd)
 {
 	int do_split;
 
@@ -1025,7 +1036,7 @@ static int should_split_large_page(pte_t *kpte, unsigned long address,
 		return 1;
 
 	spin_lock(&pgd_lock);
-	do_split = __should_split_large_page(kpte, address, cpa);
+	do_split = __should_split_large_page(cpa, sd);
 	spin_unlock(&pgd_lock);
 
 	return do_split;
@@ -1067,13 +1078,14 @@ static void split_set_pte(struct cpa_data *cpa, pte_t *pte, unsigned long pfn,
 	set_pte(pte, pfn_pte(pfn, ref_prot));
 }
 
-static int
-__split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
-		   struct ptdesc *ptdesc)
+static int __split_large_page(struct cpa_data *cpa, struct cpa_split_data *sd)
 {
 	unsigned long lpaddr, lpinc, ref_pfn, pfn, pfninc = 1;
+	struct ptdesc *ptdesc = sd->ptdesc;
 	struct page *base = ptdesc_page(ptdesc);
 	pte_t *pbase = (pte_t *)page_address(base);
+	unsigned long address = sd->address;
+	pte_t *kpte = sd->kpte;
 	unsigned int i, level;
 	pgprot_t ref_prot;
 	bool nx, rw;
@@ -1174,19 +1186,16 @@ __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
 	return 0;
 }
 
-static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
-			    unsigned long address)
+static int split_large_page(struct cpa_data *cpa, struct cpa_split_data *sd)
 {
-	struct ptdesc *ptdesc;
-
 	spin_unlock(&cpa_lock);
-	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
+	sd->ptdesc = pagetable_alloc(GFP_KERNEL, 0);
 	spin_lock(&cpa_lock);
-	if (!ptdesc)
+	if (!sd->ptdesc)
 		return -ENOMEM;
 
-	if (__split_large_page(cpa, kpte, address, ptdesc))
-		pagetable_free(ptdesc);
+	if (__split_large_page(cpa, sd))
+		pagetable_free(sd->ptdesc);
 
 	return 0;
 }
@@ -1194,13 +1203,17 @@ static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
 static int cpa_handle_large_page(struct cpa_data *cpa, pte_t *kpte,
 				  unsigned long address)
 {
+	struct cpa_split_data sd = {
+		.address = address,
+		.kpte = kpte,
+	};
 	int do_split, err;
 
 	/*
 	 * Check, whether we can keep the large page intact
 	 * and just change the pte:
 	 */
-	do_split = should_split_large_page(kpte, address, cpa);
+	do_split = should_split_large_page(cpa, &sd);
 	/*
 	 * When the range fits into the existing large page, no split is
 	 * required.
@@ -1213,7 +1226,7 @@ static int cpa_handle_large_page(struct cpa_data *cpa, pte_t *kpte,
 	/*
 	 * We have to split the large page:
 	 */
-	err = split_large_page(cpa, kpte, address);
+	err = split_large_page(cpa, &sd);
 	if (err)
 		return err;
 

-- 
2.53.0


