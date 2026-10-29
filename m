Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48A53606A321
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 06:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=D8tmWuWQ
Received: by kanga.kvack.org (Postfix)
	id 6A9216B00EF; Thu, 29 Oct 2026 02:36:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 659946B05B3; Thu, 29 Oct 2026 02:36:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 547116B05B5; Thu, 29 Oct 2026 02:36:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2BC966B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:36:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A3F4AC02DB
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:36:20 +0000 (UTC)
X-FDA: 85374704520.29.93B55F7
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6A01640002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:36:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=D8tmWuWQ;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793255778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BTXYfxfVOBhpvhPnAVq2lfmYKNgysPKxlm4ckRVwZ/U=;
	b=7nTgmDg7s9qXzakoGaDzEO8oOyVANTFeXzdyrdBaiYBxSln5/cPbccT7neMM3Zey6kXRw/
	CFK2oFGHlqt3iOMltaMOP4Kj7roeU4iSEGjx+qzrvX6l2qnDN/Mluqle5Bpfn3JNt+fuCd
	g7Gs+vmOwFZUkR/2v7YbYUvkq2eH3Vg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793255778;
	b=Nx6cnkPchc853rBU2igeNVS/AI0uHIPPJIA9PFSulOR3My8Pca6oXqV3R2GlkzW+5G8juE
	ay0cr2LodzCHr3CDPTMpwU4cLK4aSi2sCEtXP7+SyUSqubWQJ9S8Y9y94nEUoRNBNalkrZ
	Iudv2KqCtye5m3o2iJ9YEeUmx9gZZPA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=D8tmWuWQ;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3adac5c10e3so1027560a91.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793255777; x=1793860577; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BTXYfxfVOBhpvhPnAVq2lfmYKNgysPKxlm4ckRVwZ/U=;
        b=D8tmWuWQYCvAToYIsMPTiC7FEs5pJMpCgcqiChy8p29/5yiZABsDEFi3SiokfBbwz1
         WVPhULAL5ExEoBV2Mfu9giKFQbJBe0ReFyEMzuzqGjngcR9gsGrSQH6h3Vc1KyBn3Brb
         qX0O0DcVgAA2c5/T93roh0BqhFQkYhUnd7ceQNNF7eRBSifl2MYv2EW0998BAhgLc4A2
         +YDVsHBwzsPp6vDKPCtahlygV5TC8OB8stXGxvhuQQmwsjT6//+98fQuCms9k0/rryl5
         Qdw9a6qARW0SqOmDXlL3dBvddj7XPNrfIHeCaySVtWzEKZnpGVR510CwCku5VAl2WEZv
         xCPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793255777; x=1793860577;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BTXYfxfVOBhpvhPnAVq2lfmYKNgysPKxlm4ckRVwZ/U=;
        b=W/v/4J71yY94Tuyoo6s9xU6RnPrDI7pLOXrqXlfO7aXXjQeww7TiVChonJiodIMFF5
         9i5wWwXZIU16Vl8ehaxS+4/uk1I+r3GqR+XUPhw1PLHA2vSl3tQeC73ayWRgBXQIpJsJ
         0IKLJBCh2Bpgz8qBBBqhRYvAh9iZSf8MzfxbyamJZEUTyiuXR5IyYI0J8xdvE7TXoK2b
         GkTNEB44QoLOMhUo/K2j9ShmKmnmRvStmFoqh0mMmLeyCTPTujLvPaMvnV1TAn/dIzdu
         Sc7wJgW8zxckag/ORCNZ7BXU55nebHcKEptHu9Rst3Jug0KdPw8QwWxtcGhRpqdmsYXI
         dSvQ==
X-Forwarded-Encrypted: i=1; AKwUvBwJWwFMvWqp7TIxx2S8RD3XVv8y4xkJ6NMWyP9U5tRwbmSYlSTeD8QxclzGpjuk2DZlMPsnaF6HbA==@kvack.org
X-Gm-Message-State: AFq9FYJPAM35Z8bdVpc5C/iQEd+mifEfAm+a6BJLTmvX2wGdZGBMX7fq
	9abkE5QkodgiSNqAmQmMh8pxpiGYHKr5GYA+SAUuFb+H/cCZVvS4ThEs52Vfz+3oHwo=
X-Gm-Gg: AYBFou3P8n6CQeYqknS77eJv1IrnvSmcSe5NYC1IyHgg2QyX+SST5FIJ1klgo6hNNrX
	1kQbiHovpcTphPZTixEzPN0g+Z+E0+0utGFdkK9igjiSBcdw8I7WKJXloQ5DkLxw2pH+l3azjfw
	KAkuAGxc9yOhBowiV7omPMvu18TM+lWcfi1k7xMzT9sFQhEOUtFiSjAAOY77fblPXzndSzzRi8f
	aVSHHfmBFyTLvZzOjYVMlEQ3+uI9CNcKxZzxFyHxcmBh1Pi8k0folUvXAlyV7HbBG7VLH5mYJId
	L/JE5gcs6ULcg+7PX3oixGmZoRQEYB3ehjNQ2dspuiKFveSPGF7K/X+r/3bHvfs97Ld0TrXN1Ui
	U59pla9fRswLjuG15xL6cJ2yFSP3acKBO2VCnTcS807eY3JvxCXkwZnxqQpjwPGC00JSMsmeF8K
	2y26G+DPyV3rfwLWmxW9isxLJtQkkjvhaQQjV7/cKfjHg+Kq9DkKJ0f/UJKjDHwxP6mKm50FF08
	TjEtxiKpPkJaStE4Nz5+k1v5udl02UpTd72MDND0Ker8YNVdzdSef7vEklBfEL0m/aDasr8FmQS
	dVgbhH75XUGuqRVgbLyjivchMY+5asv7xNVCMsL43LhIFXaARA==
X-Received: by 2002:a17:90b:4d10:b0:3ab:e588:c275 with SMTP id 98e67ed59e1d1-3ae57f9ae1emr3026634a91.20.1793255777049;
        Wed, 28 Oct 2026 23:36:17 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e2a703esm2734757a91.0.2026.10.28.23.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 23:36:16 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Ritesh Harjani <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Pavithra <pavrampu@linux.ibm.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH] powerpc/mm: fix uninitialized ZONE_DEVICE struct pages with PMDs
Date: Thu, 29 Oct 2026 14:36:01 +0800
Message-ID: <20261029063601.1961415-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6A01640002
X-Stat-Signature: zrehsp558gx1bg97j3eec6yqnj448r9g
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793255778-483159
X-HE-Meta: U2FsdGVkX181CoidRcx1ryrO55G/Lx3Nd8icX2S4ugx4LVevxiOBmJOBIe3jqd/v00k1PaafmsKPmWd9H3S0Di0gfDesgE9FBNN4Ylo0UFq8ccWP5a4QhRH/JVZPGi/ik+tBi7oLjVJgJhuKS/dLUz5NkjhuD4u1wAS1IPxiU4LvCiNGZ9vclfx/lauoKNaZNsgCv8RE8/B4fn0ZSYUd+qDDMnQTfSncSpieVJyzKvzDZIMn9a0EbZFvGedBaQ54hD9Igh4FCMHAa8CfDYjwkvF2Y99ngAO19adDfxwZhmRWMzzHaua2q8R627GUa4Z/g55PZCVWH8OtceYZ86Q2HlxvuQFzSe3Y6N6pOGBDBBFtuo0r41NrMZYWbwe4N/Byn1jg8VLZ6LPotLdpvwyTK+a5xPFm+llfSKSctX0V19q67E3fF1RKqlKmT81/hAKv0GIj5AdmS2QcPSlwEIAuTBbfNpeI8AA7rO3uoucIOpmW6wty+pl6uR8VOsBXSdfS0pjcY7ev1WXE+w6Ksn48+M0T3BTjT/cT0tPTl5enNil6s2frtifnrdopORxkqqlK1KOEPPSZE8/gHxdAbU5L1y0PHlvMiUvbiqdb6VTq9naIqgYVZJ7JLOX+ZDaA8j86hTIV3qJA0FY1xWuiqODt8qEJLSeRdr0HPSwRexcGnJk0kdWuqO37fIYfno/zUMqRfbI+Vlxi9kP3WNpgd7Ujx3MX7wRtJw2Slua9IWaAE3JC1tvk2DID4jxQ2HW4y3sJYQLiIa8cc2hSdYLMCpKCsLzF9OLgNDExgmy5pMSqRwL70JRXFcfnI0PKMd9QQC5d/maKHiMXH0cirww3mRsIhb/CH24TQXmV/GYBntNYM65iU23GEab1/xpHFB7KjZ5GU2CJAaovbcZ8DNbMXlaFPSXv1vVf8mLR8ou93PREymhh6q8Jq9YKinWIXZP3tJysDJbjjw2lKYosOiee6KB
 TkmGz9oQ
 Fk+cunQWCA43HKKIbeAXk+Cd2Yc28fvoFqi6/xic5ZRduKHBxMVkcO0PP2wdvMWkcQbsV8m1sBdsaYrEksrMyuSt+q2zCNnl9ySqMH93yY9gysiiIOSCx05b5dkYMloMMD6Nh1/MPVQZqfDKXuiWkDTCwtEBOywHibELhoe3BtXGqlU/28/UkfmFupFGO9zbxqO0ga5dJbmQDE7u0WqXTLHRR1p8LlcAQtlZK6ox6hZ+wWTPWK3t9Oc7d0DsT+MRMQwpYwWXGEozl+VBBzDTBg28S1RKbadWViRg1+fzU1viUwuGpVmF1+uEp+XjzapWWquBTzvYvu/+6YyXaqJM9AkLvGD/cZK5C8zeFQXBfHEHTqskazBqWIxF+j+UGIOFltO6wd0BVeGB/UXu4Ki/API4LBYvAVpkfFbMmzEtapwkLtrh/1/lURa3C+XRTxaAjXAXhkrIn5g0rAy6HF56LF9CdoYe48HcchydsFr6+O4hzbRkzX3FJ4BuHhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

PowerPC radix vmemmap population can reuse an existing PMD mapping while
populating a device DAX range whose section is marked as HVO-enabled. The
reused mapping is an ordinary vmemmap mapping: the redundant tail struct
pages are not remapped to the shared tail page.

Leaving the section marked as HVO-enabled makes later ZONE_DEVICE
initialization treat the range as optimized and initialize only the struct
pages that would be backed by a real HVO mapping. The remaining tail struct
pages can then be left uninitialized even though they are still used as
metadata for the device DAX compound page.

This first triggers a zone mismatch warning in __init_single_page(), then
faults while initializing the pageblock flags:

  WARNING: mm/mm_init.c:600 at __init_single_page+0xd0/0xf4
  Call Trace:
    memmap_init_zone_device+0x164/0x430
    memremap_pages+0x43c/0x93c
    devm_memremap_pages+0x3c/0xa4
    dev_dax_probe+0x264/0x3d0
    dax_bus_probe+0x140/0x1c8

  BUG: Kernel NULL pointer dereference on read at 0x00001400
    __set_pfnblock_flags_mask.constprop.0+0x34/0x160
    memmap_init_zone_device+0x358/0x430

On kernels without these initialization-time diagnostics, the
uninitialized metadata remains latent. When userspace later maps and
accesses the affected device DAX range, the kernel operates on those struct
pages and panics at that point instead of during device initialization.

The Fixes target predates the section-based vmemmap optimization
infrastructure, so older kernels do not have section state that can be
marked non-HVO. Backports to such kernels need to handle the PMD-reuse case
in powerpc radix code directly, for example by initializing the tail struct
pages that core ZONE_DEVICE initialization would otherwise skip.

Mark the section as non-HVO when reusing an existing PMD mapping, so the
section's HVO state matches the actual vmemmap layout and all required
struct pages are initialized.

Fixes: f2b79c0d7968 ("powerpc/book3s64/radix: add support for vmemmap optimization for radix")
Cc: stable@vger.kernel.org
Reported-by: Pavithra <pavrampu@linux.ibm.com>
Closes: https://lore.kernel.org/r/97f85592bb78a273be8519e6897e7f9b9bd31469.1793070429.git.ritesh.list@gmail.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 44868b62b14e..4f75f10ed68f 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1261,7 +1261,16 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 			return -ENOMEM;
 
 		if (pmd_leaf(READ_ONCE(*pmd))) {
-			/* existing huge mapping. Skip the range */
+			unsigned long addr_pfn = page_to_pfn((struct page *)addr);
+			struct mem_section *ms = __pfn_to_section(addr_pfn);
+
+			/*
+			 * Existing PMD mappings can cover the edges of a valid
+			 * HVO populate range. They are ordinary vmemmap mappings,
+			 * so the current section must not be treated as HVO-backed
+			 * when its struct pages are initialized later.
+			 */
+			section_set_compound_order(ms, 0);
 			next = pmd_addr_end(addr, end);
 			continue;
 		}

base-commit: d865f2677c44cb2171b833d6775cf692756fa8be
-- 
2.54.0


