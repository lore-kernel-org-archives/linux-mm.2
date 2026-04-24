Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56A83F589DF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 02:56:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDE506B00AC; Thu, 23 Apr 2026 22:56:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8FA56B00AE; Thu, 23 Apr 2026 22:56:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A80116B00AF; Thu, 23 Apr 2026 22:56:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 91F556B00AC
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:56:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 235681A0BE6
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:56:20 +0000 (UTC)
X-FDA: 84691935720.18.EC49336
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3D2F380008
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:56:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fGqG8ZrI;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776999378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C94hv/3Q9yeZJL9WguueLZ0Nxmqh1CO+hZjQa23mqmc=;
	b=1bqYE5DUn7obwha6Q5XOidOpW3hDpTp8otrKcM8CBblCvM71pKpRZAcu4WyI/jSv0ZVDDn
	vD9pjyd20nxss4LfauMyb9zz74gQsAnCS+VL6I9T+MlGVOspBx7Biu1voRVocPNWwRDeDo
	yFl0vKp5ZUMyDhzcPtqXQ59siRcnOUw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776999378; a=rsa-sha256;
	cv=none;
	b=gnWeUxY5rWxzfByqyIbj9LoIjkkOHYyloKx/5VVwmJDJInT1bQkKGiT/VEDB2auynYnz3X
	678Pwwk+DzqwJQASy5XUO85KRZ3OET3ch+I4qCFUf2QsgZWddpt5eQhYYcXPyNx6trd2da
	0aYWEqLHy/APcg4CevlKJzv/X/W/i8A=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fGqG8ZrI;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c79467f128cso2760632a12.3
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776999377; x=1777604177; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C94hv/3Q9yeZJL9WguueLZ0Nxmqh1CO+hZjQa23mqmc=;
        b=fGqG8ZrI7/uU6ezqFrulYzHVmWML9s2mpT/hAoIMgvmC2rpkW6BHgYQXhUXRJqymod
         jhB3t1AIzDCi5xU3Jobh/RpTq8GUGh1mKP/H/uoAriHSV8meeCKq9FjXT0ifs3llTaZ5
         PEEIa2GgMrgqBpgfIcFE20b5oL3fVuORDdIHSMFSmwxNpHOFBRGXfsWEf7xaOBTXvy+Q
         5F74XgILFrcs+HGGmmLVXtNRfwz0OIKVQk4ROa6OA8/bOXrw5bqBkoHcReQsDRUDR+QB
         BAUr4wuXT4Lm/4DGj1xLeLQ5Tnfvwv8ecjIC5JBCKEk4DwEcLEuN+lBj9520hQPLiXlq
         CzNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776999377; x=1777604177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=C94hv/3Q9yeZJL9WguueLZ0Nxmqh1CO+hZjQa23mqmc=;
        b=MjmEHiKiZe7DjyVJ9Lqxn9aa7uSsnI9Rnh5q5josC1tc/lEce2HIZ5EV+mQQ4fxIwT
         v0hCp0dUQ3NGJKzFQTovHfZn4ZBDhHkpA9FXOiQWNtzctPQbrK6mgh5GY9duJnUkJrZl
         EwurkDzIkl8egsVSR7O+hVAyW4WcndZGOYEnaR5E1QbZsPT9foYQvA4qNYgBXuI2EYzZ
         QnH1wN63+xIVWAxFIxLCIcJb0abqK4jX1oZv63eWJTpgii52DoCtPXMqyYKocF8+tfLY
         MeRcIqC0ZhUWzz2saNKo5rZabNTjVBlemm8kIOtZleI7LisSmCpSG3gYj2abYkBS4JFl
         yeig==
X-Forwarded-Encrypted: i=1; AFNElJ91Bsvy7xv1ZwAlzsq8Hs3Naf/3rZwtYTDluDJ/JU0OIR0NTdJulpc2gp93rIxfur/e+zhyOxKKEw==@kvack.org
X-Gm-Message-State: AOJu0YxT3lDH9kqCZUqcaaNrK6FqZIsmCndfq95LvmUJMFmk9YXvBBPr
	6HhAr2sy/Cu70Aj9IVq9RN2ImWP5Soqmz8e93cLrONJJABwTyeqjrIyyfJucqY4cepA=
X-Gm-Gg: AeBDiev/+SfGZR68sToag+9xWxLLwy04s5+LwuUPVl3BEBZj9KGsd0ULTNmxIuwVJtY
	Osez7HolFgOibfjDF7PT7y3KkCaIg0a5jUqieY0eMGzsYxI89Wdhp+SodEb9jcM23wF3F0jkIHK
	OxXr2Gkg0iEp38JSYOWVFN0LrJjILchlYNyS4u11WV/4jgl2ZMoBGecM5VYBSZ/02At5QSp3Dpm
	iMNEXxyYt+YarwZgEeaAxJE5hhh87pq7N7SloOwD9k3PHRXv1yrlxK2js21iXMtBnG1t3QyhMFy
	xexuCIO0qc5IEbd8M00ELNoxZOQtUEkcnNq0aC1+dDKsfhoXitGipCDu2z1O1XRb/jRjUHp6neb
	IWhdoIagDt0lLr2U6J9Tp+uS4Pwv5oPhyotMDrn8ZlM7d4hZH4C9vgzDDJ58PFlZmnCctEpN+8Z
	dUzu37A2W714yli5INS+2htI10suHsAl5Tr4Q+6SwCbYehk64OHBiyO40=
X-Received: by 2002:a17:903:28f:b0:2b4:5309:2c14 with SMTP id d9443c01a7336-2b5f9f3ad64mr324239485ad.31.1776999376914;
        Thu, 23 Apr 2026 19:56:16 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab20d33sm221668325ad.63.2026.04.23.19.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 19:56:16 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH v6 4/7] mm/sparse-vmemmap: Fix DAX vmemmap accounting with optimization
Date: Fri, 24 Apr 2026 10:55:44 +0800
Message-Id: <20260424025547.3806072-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260424025547.3806072-1-songmuchun@bytedance.com>
References: <20260424025547.3806072-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: aoeurq5oagsnntyrggkq65fe1kh4no1z
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D2F380008
X-Rspamd-Server: rspam05
X-HE-Tag: 1776999378-77730
X-HE-Meta: U2FsdGVkX19KLXL2qD4+J4P2G2uLacapOGycH77SK+UPg1IXnKRHN8fxuyKHnLszsHRAFrublkxZpKbNWEOnJ3PM0eWmuMKbccyUY+w8d8GHg/SbUTT4VKTjiiQppoySSPWox9LFaf0Bm69lyyguzv+9sNaJQuReDqRYPNdfj415Exv2+lLMyBNxtkwEwxktnPoRyUFCrzj/65rO++mUxZqmMhG2deliK37TNm5kABS+PknWQh3FVKcgRyEj5RqvyOlMviiJnjxa7Fxh9IQUsj96CBf3svKFtsL/plDlzjAE5yj+rWzKnRzYAvO0ROm3RLS6p0o6SsTUSVvRPwHYs1xGZ02cBJYeWPLqVwrYpqXBYTWNzLX2fNnVbZ1fnLeiy2Puwhu1Qc4iAXn2yqKxCqoi2UxImM1OS6cbhSNbtZy2Ii5EcV0/9cJT9Z7xcoryJP3rHuCvDz/4n+xOAW4XMbnTZge9b99wgaNBOV7batYXYxid9EriumvfhlFjbKkorttn3VRvSoDRw8pJ41/FN8CDMNpavIe7MMGqS9WiKOKcNNjPYuI+B1Z9Agtz14kB4mty8pfAnUPv7/nkV/xhPiM66X+N8Ug5KWY5WR99YzAPlvHdLIFaapHMuug2xxiBAftfmz7bQBDmpxxXEchNZfTpLD/nps/emhpZmtIM0sGF/tsD/d+D1wiPvvqQtQtFO19ymj/uEjluVTcEaYmkKk9yeORkC+s96+9oJQk1FUDvnEjthloVIUxoIAI3dp5yKNoT1mAgbQS6jfgc6v2JNhaHpRD78G3N462ss4FZiE01hhbbJyEpwIT2afT77zXK9mbDTeuf0vZ0gtYMfDLYDH5Ctpnk+TG9z1/Dd2WuVKcZasZ94WBBiqbe+CRHmp+Blc3/O2GVp+MzZ6YA6tl7zCw9LUZXorKxTuG0aud+G3P3o9mf/LQ+zXXhihctuFjQ45UhYVKqX3dDLi7gHpx
 qGdFaGkS
 7DZTQlqRqQCbpb4b+UWqGnNQR+A23CpQGmFa6UeNZfU97h/IcVpRE0Gd7q2/jZQZYh/7qGJoUAyqsXqLF4z+MdaUXKU1bX9KhAIKI1iKBDi2vHMhr+GnKhuDmUCTzXS+QARCEItP8QAj6PNO0w3hwKiITb2bRsk8KN7L3Re1JZaVUOT0P7pAQnLmkBcQm5NnWVx9NL5FBLsSeAEjMhHLMt+HjVLHoR+HZM+l2hEqMoU1Ywm2wilFc+z9kZQ3FM0mqqldkJoyg6kcou/5UhdL8tTgE6NVWKuG9kgv6H4sWxz1/7KbhFiawJe+0j4JTlI2JMDnqeLDQW8ZSfEk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When vmemmap optimization is enabled for DAX, the nr_memmap_pages
counter in /proc/vmstat is incorrect. The current code always accounts
for the full, non-optimized vmemmap size, but vmemmap optimization
reduces the actual number of vmemmap pages by reusing tail pages. This
causes the system to overcount vmemmap usage, leading to inaccurate
page statistics in /proc/vmstat.

Fix this by introducing section_vmemmap_pages(), which returns the exact
vmemmap page count for a given pfn range based on whether optimization
is in effect.

Fixes: 15995a352474 ("mm: report per-page metadata information")
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
---
 mm/sparse-vmemmap.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 3340f6d30b01..2e642c5ff3f2 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -652,6 +652,28 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
 	}
 }
 
+static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+{
+	const unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
+	const unsigned long pages_per_compound = 1UL << order;
+
+	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages,
+				    min(pages_per_compound, PAGES_PER_SECTION)));
+	VM_WARN_ON_ONCE(pfn_to_section_nr(pfn) != pfn_to_section_nr(pfn + nr_pages - 1));
+
+	if (!vmemmap_can_optimize(altmap, pgmap))
+		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
+
+	if (order < PFN_SECTION_SHIFT)
+		return VMEMMAP_RESERVE_NR * nr_pages / pages_per_compound;
+
+	if (IS_ALIGNED(pfn, pages_per_compound))
+		return VMEMMAP_RESERVE_NR;
+
+	return 0;
+}
+
 static struct page * __meminit populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
@@ -659,7 +681,7 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
 	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap,
 						      pgmap);
 
-	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
+	memmap_pages_add(section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
 
 	return page;
 }
@@ -670,7 +692,7 @@ static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
-	memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
+	memmap_pages_add(-section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
 	vmemmap_free(start, end, altmap);
 }
 
@@ -678,9 +700,10 @@ static void free_map_bootmem(struct page *memmap)
 {
 	unsigned long start = (unsigned long)memmap;
 	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
+	unsigned long pfn = page_to_pfn(memmap);
 
-	memmap_boot_pages_add(-1L * (DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
-						  PAGE_SIZE)));
+	memmap_boot_pages_add(-section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
+							NULL, NULL));
 	vmemmap_free(start, end, NULL);
 }
 
-- 
2.20.1


