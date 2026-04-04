Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1176BE88D8B
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 12:21:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E63A6B0089; Sat,  4 Apr 2026 08:21:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76F9E6B008A; Sat,  4 Apr 2026 08:21:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 686836B008C; Sat,  4 Apr 2026 08:21:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 59CBA6B0089
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 08:21:25 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EDB271B88F5
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 12:21:24 +0000 (UTC)
X-FDA: 84620783688.18.54153AD
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2041A80004
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 12:21:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HTS9qbUy;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775305283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+4Nvft068bH006LDXNZII5o6Ddc8RwmqN3Jk81Xy5HA=;
	b=SwuyWH/t7nHXVnwCdM/ouhBB0+kGYDrOSSJOac2+3zDoNWeoOZMY8hXSQwTms2ZhWMLopW
	C7BUufwwok1Q07A8cb30Sxfiw6M7wVcvapDzOfy9I1KtlYHCfeJZs4DVcfmzGSgDsshdM1
	ra7gO52KOIWTyJHWqdAjbyTLQ7LAmrE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775305283; a=rsa-sha256;
	cv=none;
	b=O+MMFpkSaiCuI2KVAoNFLIHVcE8y/Y+hNsdQ+NPVBioH+Gl+TUt3/2oQDokgY97fFJZo1C
	Mp04q9mnZMH7m5zSc5mw2rPEKaFYApduPVzQJMORoyjeHNrxENRX3eiMm2S2tG7DTdr/Nq
	hSTIlg0WaChm/JVGH5up9i1OXvnfkfU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HTS9qbUy;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-824c9da9928so1735048b3a.3
        for <linux-mm@kvack.org>; Sat, 04 Apr 2026 05:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775305282; x=1775910082; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+4Nvft068bH006LDXNZII5o6Ddc8RwmqN3Jk81Xy5HA=;
        b=HTS9qbUyt8Mcw2Z2ZE+nnewX/3hHcKYDWsFBbPZoXw3T5+5dZOl7SZneRMSdA0fq82
         4Visx4il7jAF15+/otxvWeoEozTGGsxs4vZBZgKg6krrxYVRTqbXRSet4SKU0NiBkCo4
         NGAMluq7EhHsRRYKBDhS7ZpgVT+owpNJlSQKPyEj44vnH6a3OYCYJL/A+4whfYtFrTDJ
         imWhWmqxsUqJGZLkKbivC2ApQN5Smf6jDM7a81zr2eUabn09UfMd719p1sA6PRnhU72o
         RgcOPBpR06b1wFASTDIEBNn5ef0pFhT6KeH5XityypID2cgrVgi53KlRfDSDLaGlQ3gV
         OpbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775305282; x=1775910082;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+4Nvft068bH006LDXNZII5o6Ddc8RwmqN3Jk81Xy5HA=;
        b=fQkFTjsBsMOhYquPDjaN43XFRdJhyzFZezv76DBtVDUYkNPJXLii5ku+AiA5Gd1vLx
         dwR30dMKc6tzxkLG0jfyQS17trgBiNbqL8JtxqbB3uHqkHNPgruH0Gyb7lbLBA0BESzM
         j+Ep7ixISaNO7XNmYa3+C7zTLau+dLcRmQplXnqQv3WP8MIsynD9HtzcLKBVe/LVfltQ
         KrKDoIuHuM9YFTz20mKPCtQiz06biR81dcyPqPtk/mCt9t2EjoQVIsNn//KG4Bo/Fkag
         jo/Gv3E3Nd9zUKHFQoMkgVYns/5zXYbYHfMkCnYzKVDHFqJpAU+Ts8m9kBKdw2iDtIxO
         AplA==
X-Gm-Message-State: AOJu0YzIIW7AHqnmhLZuPfZ+tqgjAZxy2lgKT78MIIGriYkn0n0g7klz
	05lS6ILutWp8a9XM5mvPZnXVo3Rem+qREdR7moEBGFvFIgkhy1jZB2COahAi9+3Fwdg=
X-Gm-Gg: AeBDievpfUrvrG41yBjKKKqoj6wOUZG3xzNhcyMOAobV2ES6iFVVL8YU2ID72o2lmyg
	zC5C87xiHqilH/L358vpx9ScX3fBaghpIq0CLwNQb1Y+D7dW9DLIZ2QSWENflsar7YZFUgtTpU7
	rXJ6VIfBi0h/yiuJv9Cq3OptaVJNB6lN4XIRugN1ngX+3JdlfCaH+VGAAwZLjmH8HiszUaPNH9/
	BhJ8VFEhoW8Y98w4dPai/8VjJAxwyJ9EsF/BGUCh9PEGrQHXU8e7F7WafGI3v+nBTngScREFrpL
	xXnILukfRDBuGLViw7KW6yXno/7EDA5BLqcXiwzYrSv4a0iLGJMfE5C5wiW+ElTT/nAYxq1+pTH
	4xcv0h58MtCn5wLCb+ayhin/ShmLzoY+fZ2H8lJM8aHmN7D1LJu0sG8hhOlVJPhgWmYcAPd5b4a
	sVFBYVI/NdzykTaI45jHQMqpCc8lMHA5n5BNLzT8J3cV0=
X-Received: by 2002:a05:6a00:4649:b0:82c:ddbb:7db3 with SMTP id d2e1a72fcca58-82d0da8bc37mr6013532b3a.25.1775305281718;
        Sat, 04 Apr 2026 05:21:21 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cfebe5b23sm8327063b3a.59.2026.04.04.05.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2026 05:21:21 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/5] mm/sparse-vmemmap: provide generic vmemmap_set_pmd() and vmemmap_check_pmd()
Date: Sat,  4 Apr 2026 20:20:54 +0800
Message-Id: <20260404122105.3989557-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260404122105.3989557-1-songmuchun@bytedance.com>
References: <20260404122105.3989557-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2041A80004
X-Stat-Signature: ppdmzk5pzsngj3yq9gta3unfs9u5mk8u
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775305282-251266
X-HE-Meta: U2FsdGVkX18RGfRhZFaR/0n8Ezk/IyOYKPg2qRm4wXHyk7LYsX9u+XLW7Q1rsqDCoZpIzEM6KiHyGTvUlxhj5BUDwOcW7/0mMIak51je/E1mtAmG/PfdHeDyG83dgAmjjKUDILDub2L/YnRktZelG4O0ghuzZBK7zqB5fYaBkrOuLd5t16XWLxtmAsGDYei6b5yKfClyEcQkUDIl8i4FNJ+Bd1Uqiyf003yzqaufroUqUfViWiO5pubLAh9PE+zs+7pCTw/0XlQB4le6uRFNK+oO/zaqzxV1yQGjwtARSmz3U8mnI0JXSI8VGqn4geB/kskiCS+OhmXBsRNklHRMMhtTXYJT1RshBr111/ohBiN9rRs3ldC5JszjxkAKhCQVjs7qH7ueTlCD59RSUn6a1NSY5Sp6bgIXRKKRfWi6lh44g0Jzscui1gi2uhaBiEA2Lv0X3CeFw+C3CosPjucR3vJDaeKVE3KKibQ8z71T2vubkk28/VRpx7xRZ6fvf+1JZaJYHjgNcnR5XWDa6RlbBY6gbSrTausJNtKr2sWmwVyk6cg5vqxOzjBkcyNu9zuHKk9h7DAf8fSZgEvLgadtQ28jCzl09n6OWFuyuOXNCkixN3B2tUfkFw+LJKtkiNq2Ta+2Nct5+tflrZD8UT7FZ1cyS+wxz4svLSAFJdj6BzoWnInhL+x6ar7BoaGsbQDEo7u6WDuVjlTp4H1ZPTT6IjX7QpiMQkrsb9fYoYDNcHHqevWz1GvP+hl75FeXanj2ZKKKDBVARQmI8lkNbWMqQYd5xHdrmcj/cJReEyly1i5alFlWmG3AN4igiD2RSbckNvNBYbHYuOJZ09YparY1O0v2d54assttag3a7RC1z2Rx7IxRO5bp+gfTbSs+N/zTB6uV3ZR6cwlvgnq7DUo5CJURw+/03HzV3NDHznbww+/CArayR47kV0sisT/JjzMGnvWITa+N6hEi4FFki5x
 GMRqoVS9
 e4Atj4AZSV9MdeZqVuxGTgZrLrd8I63jFOUHStwFW2+no9zjraqz5Vjac+0mvbK5O8Z+qB6zBg5Y9pYz3vU13F7s+bkFpFIYZy2bXLbdkyYbKcH+0pgEJ4g68k1/ISOLtMrF6QzIhGBmMcr0w3oxxwBXn+yOSgB4Pz4CqiwPK34A6JGsbPPP/FJk8YfS53QjbYL2+j9wHFzMTVVi86IBHtjYD0j2Dx4mYg1Uvtj9WkltH+OlLcLXV/HNMy5817EfVRBLSsdCCAOMKY1JkAu+g4t0fJ3OHub9WD3V88pBe4LCreFDYHJgWyMMJ266Paru1UeuqNK1JAH4FyLqHphBO6XjObkAUKaajXCG0l4kUkqpXPiQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The two weak functions are currently no-ops on every architecture,
forcing each platform that needs them to duplicate the same handful
of lines.  Provide a generic implementation:

- vmemmap_set_pmd() simply sets a huge PMD with PAGE_KERNEL protection.

- vmemmap_check_pmd() verifies that the PMD is present and leaf,
  then calls the existing vmemmap_verify() helper.

Architectures that need special handling can continue to override the
weak symbols; everyone else gets the standard version for free.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 6eadb9d116e4..1eb990610d50 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -391,12 +391,17 @@ int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
 void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
 				      unsigned long addr, unsigned long next)
 {
+	BUG_ON(!pmd_set_huge(pmd, virt_to_phys(p), PAGE_KERNEL));
 }
 
 int __weak __meminit vmemmap_check_pmd(pmd_t *pmd, int node,
 				       unsigned long addr, unsigned long next)
 {
-	return 0;
+	if (!pmd_leaf(pmdp_get(pmd)))
+		return 0;
+	vmemmap_verify((pte_t *)pmd, node, addr, next);
+
+	return 1;
 }
 
 int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
-- 
2.20.1


