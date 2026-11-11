Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E96A606A882
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=V/Ggeg1j
Received: by kanga.kvack.org (Postfix)
	id 7FD056B05BA; Wed, 11 Nov 2026 06:08:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D3A96B05BB; Wed, 11 Nov 2026 06:08:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EA4A6B05BC; Wed, 11 Nov 2026 06:08:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4ABA86B05BA
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:08:42 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CB06E80283
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:08:41 +0000 (UTC)
X-FDA: 85422565242.24.6AFDA91
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1872D80003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:08:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="V/Ggeg1j";
	spf=pass (imf30.hostedemail.com: domain of 3tkz0agoKCH8ygrqqhiruwjrrjoh.frpolqx0-ppnydfn.ruj@flex--vdonnefort.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3tkz0agoKCH8ygrqqhiruwjrrjoh.frpolqx0-ppnydfn.ruj@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794395320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=laMYshk/IpUNzmzRXv9ltVTwYgsKb/6KaHojH4Vu9w4=;
	b=XQWQRrmZRpUvqSybKA3hJElbOsbfSmx27PBgau7EhgNfkuhaD+znCcJVTug11KMS6pr0t9
	04Jl0yyiGF0xAhbt/BsmBIXHdNyLYYA6gcYfEkZ4pIjlStVBnoNNYexNijmGF46EcAGPbC
	cLCd3E5gPtjU/bU34c93qdXkUmMWBgQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794395320;
	b=RZlf2sZ/6cxsooMNx1lug7yCPJxdaa5iVeCQNiAn49K3fzZ8pViR4o9g/IOX/VNPi4Grbu
	VbGqPqaV8+YaRXkgrFByBPVkYV8tSiQ7ED2uI0lEziq0SCfkmCuiBEXidDhkYItRntyZFN
	skeIA3Ibgqvkh9DTT2NrLar5ZVaNsLU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="V/Ggeg1j";
	spf=pass (imf30.hostedemail.com: domain of 3tkz0agoKCH8ygrqqhiruwjrrjoh.frpolqx0-ppnydfn.ruj@flex--vdonnefort.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3tkz0agoKCH8ygrqqhiruwjrrjoh.frpolqx0-ppnydfn.ruj@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4b9f7cace4bso28429275e9.3
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794395319; x=1795000119; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=laMYshk/IpUNzmzRXv9ltVTwYgsKb/6KaHojH4Vu9w4=;
        b=V/Ggeg1jfqLglWzQQeGDxPvdGTgjCdT+cI1OiI7ghJq8rKtTJvvNsU4N/+86jQ+nrm
         BZtJ/K2kY59Ql2jIPbw4IkC32LBSYZ3Z4nMcYP3mywu7c0T4ZetYMxyOo0/lZAeOiN8L
         PNDmPFj3axBpXvMtVLMQViNaBoktyJZdS8yZmARNvc9ZeYIW0Hc5XNq6Zh61+9cIxoJL
         RyhXCohpShbWviYBZaXXWhEOKTZvPos/2woKpAmqKGh5/lxOdOoWWwWdyuYJEJbULyBG
         wfol3McTU6kAO8PuzSWg3eLhn1u7nZqbfyVojU4hYYbc6DHHyIKj+sLCZFwdFCnts1Io
         Ev7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794395319; x=1795000119;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=laMYshk/IpUNzmzRXv9ltVTwYgsKb/6KaHojH4Vu9w4=;
        b=pBen19sQ64NETEEMDeXGG/AiFSpLeeTXkrbHq2uLwaBsmxBrvjULrj0UXHwc2eNTqy
         KDAseDKC1FpLaXSdM3gm3ZbVSFC3VhFU1O4y142RH/bi1DO604emTK0k/zJDUpdQMeMK
         vu7FpaP47DRyEdDmbmI+1Lw8YxCOxspNqx73g+sqZ74Rhdaap0ZK2tOofb/BVvsdeDPG
         FkY0L5rWtuWlr6/CfOBEuacgsSpcmbNPalQrs+EHystejc0f1jK3umDtzkBvEvP00Ku+
         uKOmPDJQdZFXjDvwuDqlmVyc+LgNpOjebV/wspaMG6si3fdi9r9D3ADtoopSvs0VZtQH
         ElEg==
X-Forwarded-Encrypted: i=1; AL+hErHwGWwiPWbUHcT9vQ8bjZv98F1ye5YgX0QvKkwPDkNWUWImVbmOQZ6SNlqbfZTgq9d2iwLZwu9E2g==@kvack.org
X-Gm-Message-State: APuU4Z869onmGVTrF6SPPf1WL//ksGW7o6r/5vSwW1FoZNZ7CSeDsQiS
	ofAh0mjZ5nzjJhzvezFSEdnX9osZKoyTtNzliaRuyvcDps28qIXiFabP7pjyj0nmw0l01/FRoEG
	X0BPJ0hlctzdspDf8a0r1DA==
X-Received: from wmbgx4.prod.google.com ([2002:a05:600c:8584:b0:4a1:cf4b:72c2])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1912:b0:4b2:612d:908c with SMTP id 5b1f17b1804b1-4ba093d13f1mr36933745e9.34.1794395318533;
 Wed, 11 Nov 2026 03:08:38 -0800 (PST)
Date: Wed, 11 Nov 2026 11:07:36 +0000
In-Reply-To: <20261111110738.872947-1-vdonnefort@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261111110738.872947-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261111110738.872947-7-vdonnefort@google.com>
Subject: [PATCH v3 6/8] arm64: Introduce direct_map_is_ptemap()
From: Vincent Donnefort <vdonnefort@google.com>
To: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org, 
	akpm@linux-foundation.org, m.szyprowski@samsung.com, jenswi@kernel.org, 
	robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org
Cc: mark.rutland@arm.com, robin.murphy@arm.com, hch@lst.de, 
	ryan.roberts@arm.com, sumit.garg@kernel.org, sudeep.holla@kernel.org, 
	ardb@kernel.org, thierry.reding@kernel.org, david@kernel.org, 
	danielmentz@google.com, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org, iommu@lists.linux.dev, op-tee@lists.trustedfirmware.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1872D80003
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 6ofuygtrj5u4fyyteb63idjuzt6oo8o7
X-Rspam-User: 
X-HE-Tag: 1794395319-527555
X-HE-Meta: U2FsdGVkX1/CC2BfSQviwJVAx2vOFW6bYNCdRYGs+408VBt6cUKShZeraXPkZKSl+tMSwDvgAcQHnrScSE+pjFav/Myn7S1YZS3/87nO6P75HdkjVMLYNqKpeQEn7YROyIN1gx8fI8jMGeGHym9Ben6tvEk3PMaQdNYo2PrxH3A0UbhYqz8C9wlyJP/4h9YK1NwUc/88WF2xZZt3LZoN3sMtXp4Y5iwN8KJ8hqGLY8cclJ+C33Aac7AQ8FwknZJvA7T1ABWY+t2xgLgPhwQNeXtrvSF3onpsn2+2twKSWvuHtmOLrPpTX+9wQK35CrjvSPWb71ZAUMvk6L1c0Isye2rg2v7sURgZXh/aVzMhqZIhpwhC9wko++dZS/3FbDGmE8XFMwCqK45Sw+Gch6nv8i1OQaFzA+4LKI7ezATo7Ee8ZvfiAfFPhA/g7PXA82t7cKyBcg+ZPykpdEtI9dcgEpaGUA2Nv+UHRXGDJQQ8XOGCGHh/cEV7JujJVgM79K5NSFy1oI/5PKSfiN2JTkv1YDQuIgYfsSdBZ7Eqt2/FFlckQNADb477rdNdDs7Y3Xvd01roLpXExi3ati3C6HhWpE25WuKvDaibAYGzPOCRONcbQ7AcCVue9tmMiX4pz6RK64l4kDzAUzkCuYUFQedev0dnN4341EesDS8Xnq3gFfXqVrQB3ynCM9npuF3sw47jtnr7CropAzUO1FJCavcp+BGVCRsTkJSebrlcGHhnfgI81vybNyDo/N7TIkyhaYskcHkWd+vRsdyFkdfXmxa3NZKOxZClZdkt/eEOHTLk3kp+fhG1JkaxONfiA9UCsbg1lsPCQvKfhVo0YVrJCMsORhUan2yMo+9/pR8IzwWuCo8yDTokW0TqSDOX8qBoLMkzCsMFeAgtBh5rzL3jV+IECP0s4ZCq9DowlI2Rjojy5sxkDZOynUUj+1ZIeBJFVcGf1op0XIA2UYtp/kcchhD
 5FQQZvAv
 B4Hjy2/FaaYW2pQO2TIfwchvzxoEnzm2ecWQX7l6dopKvX77EneZWIpw5f1KlRYbOpCMDcHs00UVyYmqXvNtY2F0f/jbs/gSG4j6+4LVYAqM5NdqYSVfGsUycBsIkeJjFBv0XUO48npJOUPKKYjdChTUgqoDKC2WOvEs38GRd+rmiIsDwe4AjafpBZTuEfyWi+HET5upi7yQ3h/5ozH3YumLCp3UURgpA/NfPOpIGKJRQE0NrB81/sCG5w+GfXynB6m8Jmi4i00wYpQYtELX+YK4sfupOzH4h0fZtBdp7yJxFvy4vPoqVg1Q2BNxgZmqpeSCdcuuGGgt7MlzEV/ZJhOQPYNoe2WUDyQqAGmTDeRhplhei1EBhneoKafJ7EKriN916ejnjEJrJq+a/ZByD+Xa72BZZRCC1MIhHzQ2jjJKiG0SwHmjVnQ9K5g5SQ1Wln4AIeiflGAJ5rPw8O7KtP8GJdpzqSVZCZLGU4WFE/omqJ/hdW1PjKZ+Kg0HGtHxo3ytYK15Q5i4B9Oec2hz2EkkW2ETiYz5gbrEJF18rKm9qFvRPTgj6T6EjtufgSoWn6JGH6NUhFZ0InMIo4CJHLXAGHsv4n2bh9RzzMiTHTcTrnpqrD9/neoTTsbtjxLhV26lzO4Zg8wAkQcegZ/zuSWwVmeHOFbDXmKpzqmxHLakcNIGV0CjIZqXREetqqKtqZEJk0dsT8WBfyLcSnITMJheqnWe79nldCAgn2EtGa6cO1l+rN4p3o3WuyNYixwciGWLzDmAXTqsYWvA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Regions marked with MEMBLOCK_PTEMAP are mapped at page granularity so
their direct mapping can be modified without splitting blocks at
runtime. Introduce direct_map_is_ptemap(), which walks the kernel page
tables during init to verify that every page in a range is backed by a
present non-contiguous PTE.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/include/asm/set_memory.h |  4 ++
 arch/arm64/mm/pageattr.c            | 65 +++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
index 0091ba12200e..b6ec938703d6 100644
--- a/arch/arm64/include/asm/set_memory.h
+++ b/arch/arm64/include/asm/set_memory.h
@@ -3,12 +3,16 @@
 #ifndef _ASM_ARM64_SET_MEMORY_H
 #define _ASM_ARM64_SET_MEMORY_H
 
+#include <linux/init.h>
+
 #include <asm/mem_encrypt.h>
 #include <asm-generic/set_memory.h>
 
 bool can_set_direct_map(void);
 #define can_set_direct_map can_set_direct_map
 
+bool __init direct_map_is_ptemap(struct page *page, unsigned int numpages);
+
 int set_memory_valid(unsigned long addr, int numpages, int enable);
 
 int set_direct_map_invalid_noflush(struct page *page, unsigned int numpages);
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index de7bf95003ea..c7662fd2fcb2 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -102,6 +102,71 @@ bool can_set_direct_map(void)
 		arm64_kfence_can_set_direct_map() || is_realm_world();
 }
 
+static int __init direct_map_is_ptemap_pud_entry(pud_t *pud, unsigned long addr,
+						 unsigned long next,
+						 struct mm_walk *walk)
+{
+	if (pud_leaf(pudp_get(pud)))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int __init direct_map_is_ptemap_pmd_entry(pmd_t *pmd, unsigned long addr,
+						 unsigned long next,
+						 struct mm_walk *walk)
+{
+	if (pmd_leaf(pmdp_get(pmd)))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int __init direct_map_is_ptemap_pte_entry(pte_t *pte, unsigned long addr,
+						 unsigned long next,
+						 struct mm_walk *walk)
+{
+	pte_t val = __ptep_get(pte);
+
+	if (!pte_present(val) || pte_cont(val))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int __init direct_map_is_ptemap_pte_hole(unsigned long addr,
+						unsigned long next, int depth,
+						struct mm_walk *walk)
+{
+	return -EINVAL;
+}
+
+static const struct mm_walk_ops direct_map_is_ptemap_ops __initconst = {
+	.pud_entry	= direct_map_is_ptemap_pud_entry,
+	.pmd_entry	= direct_map_is_ptemap_pmd_entry,
+	.pte_entry	= direct_map_is_ptemap_pte_entry,
+	.pte_hole	= direct_map_is_ptemap_pte_hole,
+};
+
+bool __init direct_map_is_ptemap(struct page *page, unsigned int numpages)
+{
+	unsigned long addr, end;
+
+	if (!pfn_valid(page_to_pfn(page)) || !numpages)
+		return false;
+
+	addr = (unsigned long)page_address(page);
+	end = addr + PAGE_SIZE * numpages;
+
+	/*
+	 * Called during boot before runtime linear-map splitting, so it is
+	 * safe to walk the page-table lockless.
+	 */
+	return !walk_kernel_page_table_range_lockless(addr, end,
+						      &direct_map_is_ptemap_ops,
+						      NULL, NULL);
+}
+
 static int update_range_prot(unsigned long start, unsigned long size,
 			     pgprot_t set_mask, pgprot_t clear_mask)
 {
-- 
2.56.0.542.g3ef89b7020-goog


