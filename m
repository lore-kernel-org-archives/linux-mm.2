Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E281BC5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:53:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 028456B00B2; Wed, 19 Aug 2026 05:53:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1AA06B00B4; Wed, 19 Aug 2026 05:53:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0A806B00B5; Wed, 19 Aug 2026 05:53:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE4076B00B2
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:53:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5B7B61A0521
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:53:54 +0000 (UTC)
X-FDA: 85117557588.26.23F1108
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf10.hostedemail.com (Postfix) with ESMTP id 872BEC0007
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:53:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=cFSFk0jl;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787133232;
	b=a2+I7bVmIb3S2tu6i+6VwS8iyBHYU0SI9D8LCULiP2fC1m7nHs7uzW6BcHc5Cj2RjgTcJY
	uYAu01S3En9wVJ7In1+7j51mJONPKa+B/SsvpcnbvdSfhpmfySUP6T4+h/DGeyXVt+DEJ/
	Hr54YkDwxoN7pyvhZBu8v+NN9tkuM3E=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=cFSFk0jl;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787133232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Ij9dEqKGuikzoEaZ+Dz4+F6pvL226lB4Ua/B4QAWHQ=;
	b=DHRSmMHfedIKFRRV7B8scfS1S8I7Px2A8hFebyySp3Pj9ets5KOHlUCcDXsHeFyY78QwQR
	ZFo5oQswXEqQLvJp1v4WAAwg0aNQmZQ5QvCMTr5p70/bD8BBofzsjvl6yRsWaKH5sDA0GR
	TiBgy850tpOxaxWAC1Y/Ntm43uz2Eck=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cf6d65d8a7so9687325ad.0
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787133231; x=1787738031; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1Ij9dEqKGuikzoEaZ+Dz4+F6pvL226lB4Ua/B4QAWHQ=;
        b=cFSFk0jlZX/5+L/w3hIKNTR9/+fR3CLbebWE64bMeGG0apzhYnVvX1Mr0mTd2RnboK
         Wj/CXze8MkQtz5J8WHRRHqBYMVBpsRjfzoNs7NPLZ4vSWb7li9ZD5Frmk48LI06BctwB
         C3eqaZC9yfmV194ac8IV9lcBLJjhgEMirxjuGHQzPkxsAZSYV2+imQsZwOswX1JVnc7e
         4OVWlxBJw6bdD8R0kCXs/LEzJwTwHaHuxa8EJHv7bwOFq13+QcmSGVHuUE7WokO/Clsw
         DkeZ77rOgFna9ay1lx3hLqW7hrbnPSQaR47sgX5x0D2gOVDHdqTe/MNhDPCCd2EgRNWl
         28GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787133231; x=1787738031;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1Ij9dEqKGuikzoEaZ+Dz4+F6pvL226lB4Ua/B4QAWHQ=;
        b=pybXb93KdLXTEITtf9SeHhp8M897aXHoCRKfD8H5f1upwjwCwd3TladmaxlVTJq3DZ
         DJ+lGeqZYQ/DGkokQt4Z78yZ5PPohIQJ8Z+p3fOdrtqzSSC3Z6G6HSQi2f48W1g1QvWr
         EsrqJBaUl3UT4Mqn82ZpsXFZVgx2f9OW8TE1tMW6nJU+kndY73NE4z+8CGPdybhCMv2M
         ZfrUU2gl2iUdYhCHoLvc/Hgby/g66nMzXjbVbeLRskL4NPvu+IAWDkeKBt9SPrmold++
         1zIzZ/LaHNQnURQxQqixJYDHBILyBoBaj2aOQHSRSS92ZqpI23RsjleZQV6HhTXbFDTg
         31nQ==
X-Forwarded-Encrypted: i=1; AHgh+RpAumDy8mQ+rmwJlZjaHsz073rD3CuQoDZPkkec7zsUPpuas5Hpgos8AF9qgikXOUJIeJgWB9zb4A==@kvack.org
X-Gm-Message-State: AFuF++n7h/Wad/pvJw0A658VXJx3PttwyOcZ6i/yoCbHj/YC6ZkWFgUq
	uBpwO3bGdz6pDXcwt5FBHp9NlSCRJLRB+qRRwo740yQhpU5wJfOZKZxYg2ye05n/TFk=
X-Gm-Gg: AR+sD13IBqBjgn0917PYM5XYoLpN/teXvGuwsauw6OxWyDK0VHlIM+r+ywtuRE0DuYj
	XCx2fgrwI5fVD8h/zsAW9XnIhPdLXisLj9Vr+816760Qrkskha4s4cGOQfL/52ny7Hx6qJ62GHh
	P6nij9oqlha55VhEYOnHRF4+Uda4xXSidm070sWyAyr5S0mXwBCmkd95GtoIbi2UiV5PrQPbSVa
	vP5sYmKnJavJqM+UAUW1+bvZhWyPUD0ntsd8bfBueJTpuLGvPpZR/OzID/N5tFp6bEqq/Kxzf59
	0nLBNm8nEJFdyZzo8z/A3xEnLk+i0IYtlO6qcseDp4cc+hcq3cLEdDzV6ZZhQrOiewugRUwkDMk
	8o215Uc9QO/w4v9s20eVABgN8FLv/ODZNwwynyRtwVyDSN6/IZvOnvH0H61fS6kgf86T/9plaCs
	qHwSQE4Vvy4Kdaa1pe8oYaPIoVhojvFx4wggmW8bXi7nGrjWa2WL/oNYYTDR/V88I2pXDmjTblN
	C0fHXI8J7G6iXJ4OWIs8c2K78QnM6qesUbWzA==
X-Received: by 2002:a17:903:1205:b0:2ca:d91d:d3a7 with SMTP id d9443c01a7336-2d6017649cbmr54047305ad.10.1787133231219;
        Wed, 19 Aug 2026 02:53:51 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5c1e5434esm22504235ad.51.2026.08.19.02.53.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 19 Aug 2026 02:53:50 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v4 13/17] mm/sparse: remove section_map_size()
Date: Wed, 19 Aug 2026 17:51:35 +0800
Message-ID: <20260819095140.17252-14-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260819095140.17252-1-songmuchun@bytedance.com>
References: <20260819095140.17252-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 872BEC0007
X-Stat-Signature: 55z5g54qqmhztnwoxszcogsobjtmz3gu
X-HE-Tag: 1787133232-836219
X-HE-Meta: U2FsdGVkX1/TxZpKiY+b5EYYjbsEEcRB5qs+UhaRNQmotIlcJhIuZ+shTa0cRT2Fwegqp9OvQogKT4eeu5CRE9GudCx7AedffeHf2fLTrNgXZh7HYbI9l32DjUf9qN7s4b5b3feTw5Ys8+FYCUuBI5j9I+z4kbuvv+yUZLkXWaxUXXbdQ/9bbXfM3rP7Am2rfEn/1bosoEO7cgkMEMiOr/Lef+Lvi7bz7UgZ+Zjhc3E1Oa3UuUHeSRoXpeoiz4GzND6xZcgPPPAHGwgYFGZctPk68GAcWDEgzkNuitzp8ALsCoB5KzO/2dUIP9M/yzBS9B8YeOOJl5QggGHxZJ4ulgaZJQGrqpDNua6HpnwwGauAgpPzAFcJv9xf4Qm6xWrUwvwbDtGy8LtU6XGPFmGNF4QiI+Ux3J2CLv7ExKdqJ8rKGNhyEMfcDerx0GdXsqxpHpbeQKC/XnizM4UbrmzLvkbGRaDQtE3zi4rHrEWVp5pV4s+ThiOLfOLLhfNTItTn+Eg0uzS3Jd8Jqf/rowyfDJ9BMqn9SBLp/H44yNg3cHK0nNCsw/anM3vyRKyOoD1EGRaUUXWo3EJS4Z4xqNW3CKFIanK2YHXCdfIR3f79GhC7p9WgPf6txkG/9JXmXkLp7QGsy9hrM+U6uiTViJ5nNPMPVQuhcc0nMEtG8Z+lHkJynay9bB4lAVwhyAcvjVOkvWfEuaCUXK+9bXPwew59mKJywxMMUesaQP4xW/nK2qyyEe5hSVfLZ35TLTeLnPI8tAJCGZgB7RmHCoFrcJQ4+VLXa+VRELKd/W8cHi64BXisnHsr1npGxHEOpCMp9CcerQAY1W6VBZ9u5SGgT4zEwC9t1QBmxBUbcZ0PSLp0SblJZXsQhRqoVE0xSI0eyNzyhwxaJKYX5DcXzxLbUwT+UBSrq+s7lOWR0+JaqjKoNrwcIdBeuBXdcADrYvwttryTl2XfuLcSadqfrYV9xQ7
 QnQ0ZgGr
 AE5RymLGLFqovReLnCvfaAaa92RoBCLy5N+lc6v6d27DcrQ1yMoOJvlkhQ1ZiCRpljgmm3Pit5d8fQwGz+oYq5oHsXIjC6y8al2qStjHoOif0i7k5+dBiRFjajfWN4J8CqfwY568364Sx01w9tgdp645JQGAxxJKQeIPAOweFxd4sxz5dyohDmEiEc6ACoCqd7cyMur9KP7xsuBPu2keuJ/0b4/As4LKGfcWSqVqKB88CtkNz3hHYs+dNuDBdO+fkw93IoN+cTFzCNaYH21l8f+1q17gqPMmueMWXhfNyc83BndC6ARCfa8wq0nKwFu/Soz3lAoxICQ1dtMVGcGCVB4TMIkkDrsk8UNBoMCtXoogZcOzmCtwdZeSrelgVoyXyLqn0e9Szx2/kYNBJuhGuuRRKe7uR0E4d3zlO6iSazqUnDSjvsqjsAF3UU7+Dk2UwKibB21uVRdtplyc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

section_map_size() no longer provides any shared logic.

After the sparse-vmemmap changes, its only remaining user is the
!CONFIG_SPARSEMEM_VMEMMAP path in __populate_section_memmap(), which can
compute the size inline with PAGE_ALIGN(sizeof(struct page) *
PAGES_PER_SECTION).

Remove section_map_size() and inline the remaining calculation.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v2:
- Collect Acked-by from Mike Rapoport
---
 include/linux/mm.h |  1 -
 mm/sparse.c        | 15 ++-------------
 2 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2cad82cc466d..be2865c00cf0 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5140,7 +5140,6 @@ static inline void print_vma_addr(char *prefix, unsigned long rip)
 }
 #endif
 
-unsigned long section_map_size(void);
 struct page * __populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap);
diff --git a/mm/sparse.c b/mm/sparse.c
index 7096d8e13802..9349ed6326c0 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -209,23 +209,12 @@ void __init sparse_sections_init(void)
 		memory_present(nid, start, end);
 }
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
-unsigned long __init section_map_size(void)
-{
-	return ALIGN(sizeof(struct page) * PAGES_PER_SECTION, PMD_SIZE);
-}
-
-#else
-unsigned long __init section_map_size(void)
-{
-	return PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION);
-}
-
+#ifndef CONFIG_SPARSEMEM_VMEMMAP
 struct page __init *__populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
 {
-	unsigned long size = section_map_size();
+	unsigned long size = PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION);
 
 	return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), nid, false);
 }
-- 
2.54.0


