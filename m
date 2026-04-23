Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30996F99344
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 07:19:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D93A6B008A; Thu, 23 Apr 2026 03:19:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 963276B008C; Thu, 23 Apr 2026 03:19:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 851BD6B0092; Thu, 23 Apr 2026 03:19:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 73FA66B008A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 03:19:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F2E3F1203ED
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:19:29 +0000 (UTC)
X-FDA: 84688970058.07.71D5E70
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0A8F5160009
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:19:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DtXEVuHm;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776928768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aXDuw3SgDm2p1+utjq7Iir9F7HkLAKGsFULdDpxe88Y=;
	b=Vxg0iSjqDZAmW60o0c7D4Ed23b7PJfHucRynFcf7bOsBBRqHgdyaRhJ1glo1NHEw+4FPcE
	k39L1xNkioujNafns6HcRSMr2sP74b2ERR2sB9EC44f7WyBlwRNJeCxBS5nGTYVEpyfsAc
	8gjf7I0mg/owZN3zcM8RmCV+P/nDT4Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776928768; a=rsa-sha256;
	cv=none;
	b=KLgPx6TAZmMXvUgfOWMqB8WVYVOgKS+VYbGZkJyeaajrna4CJoqXxkA+ZcOtS8MJTy4IxN
	YlC8GoEhbe9ftOw+FrDTOJOWJsN0K8ARqjS9NoFYxoo0ENJTB8b6b1zjdK6OhUmJNPvYQ6
	fR8WWBy4nsjOYlC6k9UtKKjYq5onu5U=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DtXEVuHm;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3614826eca4so5747770a91.1
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 00:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776928767; x=1777533567; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aXDuw3SgDm2p1+utjq7Iir9F7HkLAKGsFULdDpxe88Y=;
        b=DtXEVuHma6zJ9nVECUs4S25kQz1N0u7yIVD9iO4uuEmFwDKmhPFumBzwkUE4uQbFn3
         ll4xRXtdskLXO7FOdEoWF/cEptkrbXk2fWaIJ6FLQP/+GVoAgJ5u9ke6lbKOfM/vPC7u
         +fcZ6bOHDOlf3vl+3XOGe5QmFx4tBDv8Vf3B3kRQkd6B1gi+Hp3daKeBJBS5rzmAYcEX
         OdX1ypPWZKa9VdfHEmva4QqKEiWwR0oZMQcrPc2Og+82Nv3OjtZmyXI1IxN7H9CXxy66
         UNpiyr9UM/GSBgBZGpbG/IboBUaFSFQaINEs35W03ulPsY/jdwhspEvMCQLA96lgBGso
         Lw8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776928767; x=1777533567;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aXDuw3SgDm2p1+utjq7Iir9F7HkLAKGsFULdDpxe88Y=;
        b=Vg8FtCRfwVGL/hAzvuzwZqfbZ70DnVYxY+q352UtUymqFm49oOOo2UYhbnQLel3P0B
         tmgolsSYDmIXmQknZe7zP1+YO2NdCIGpMQfDM227jMPvU+TLS2aRnX8ido9zG9aZ0vH/
         n+hJ1Z/75tho6k4X6ffAilSV/Lo4v12r3iFKnWr+WJcg1R7L+GcmXG5ROHNXTVSx+GQq
         OnqdeG9yy0u38XK7ZY4vMTunbJq0DC9p7YumcGw0YApdiZk7p+zCvgp8h0svQLosq+mt
         uhtQqCs9q8uFfsHH96D5penLRN7fm2TSQ3uFGH5XzKq/Zv4AFjx+ihQnh7FPziUTp1ta
         a5FQ==
X-Forwarded-Encrypted: i=1; AFNElJ/9qNys6OmjcglwVlhdTU6RAaN93cWBaFpVv7C74lCZu3ZowrIvlTPItsVwZs8ZjDmsevQJ9sDupg==@kvack.org
X-Gm-Message-State: AOJu0YzbQYYLjrQLq7CCRWn1noHEmbiwltxVhR4f/GiyPVzEc3tzc7CA
	pCYIAwt0tqTY8pjNycnmnChLnbYRfSQHaROylrMEoUimSBIrvoL11ZP21/VjrHmvMLc=
X-Gm-Gg: AeBDiesowCcsXI4yf5YEACPkW2ZpOywRCsGly1/5UT1LOVlD/RzX1zMTS9l5zSms4xQ
	PJTSAbCWmUZUN9cx5/W2d6B/72KV6xR1R6/LRSf87jLFWAgXJkHNxuE+kGc84y2Zhub26XW9R2t
	RFmSZh7HbMqPiY8j8z8/LmNs1jaOZbA4l+KzCPa3/xA4GoUJn94skMyU7B472BQoMN68dokGQFY
	jyIVD5x0LxU9DTMpx9MGj3FStQzaAezZYFnESda52KVFsDbGTzIsWo6re5TUr3wEjDsK1tGtUTX
	09LIgwzrRa0NNy59vZROaO3j+IWSyzTimS19pAGGOEXt8rm0CCM8KQF0joUJy6Ac85UYylBY8xR
	NZUmwTdRriHZyqn9siIY9tY49O4SN2Hysogv0DXubMT2ID8flSDoXAZR4FppszzjMj5z+xGadMJ
	ZMRVy39mIJ20QrMIc6HE8enENS/DQmvkRBfsxGYBHsjcFSJiSHaUmfJQ==
X-Received: by 2002:a17:90b:2fc4:b0:35f:b6d3:da7d with SMTP id 98e67ed59e1d1-361404635e6mr24991060a91.17.1776928766629;
        Thu, 23 Apr 2026 00:19:26 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3613fbd970fsm7092372a91.14.2026.04.23.00.19.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 00:19:26 -0700 (PDT)
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
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v5 v5 1/6] mm/sparse-vmemmap: Fix vmemmap accounting underflow
Date: Thu, 23 Apr 2026 15:19:06 +0800
Message-Id: <20260423071911.1962859-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260423071911.1962859-1-songmuchun@bytedance.com>
References: <20260423071911.1962859-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7e1rcnszup6bmm9mzrufpwn5y7hj6p5e
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A8F5160009
X-Rspamd-Server: rspam05
X-HE-Tag: 1776928767-357469
X-HE-Meta: U2FsdGVkX18L7kN9aDMWNElMxhoHQmrOQozsp6H0+Kcp5PvCOA4/CzpsG5yelz91owX+IHT+jB6+jLSJ0xo1Xe0PnT+zi3C42N0CG6BbOEvI5Bv1MRXoNzbNtxherjiwJpEfWx0bsQEIwrBomkrSF4xpfveR9Kx6a02A8m72//fXBsc3vpfpnc3M6Da9i2f48hK4DjJVc6v7MNbVbJWlcj5ZqHvwNbHTDCoheMS4J1KVlPY5qwIzxPZ/d5pbj57m/sdfD2NmyMTyi6AO6aH5usYXUk1917eMmN/QOegyLFUslFgyLZP61KifXOQmz3JkyUXvJDF47n7yOtnllXvcnsr4I/OG9day+CxLP0JZdQD1kdR+HVd6HQjywfkcphonad5JJIpPbeg2DCEMlg9pydHPaqOGcseSP51p3Vfnoo8ds9YBirYxm16tZs6+o+lCLTioOyAMOayMZx4cHXvZgfPSjXXRe3tx0IOATRnJqDB6NlWBfC+eHcThazVAp0ZThmXN8hjq2nL9Cjac8FIbhR98noPaIvFpT+OKpS9gR6u3OLa8fpnm9Vo1ZE0+geYVei3gFuZ4GYx9wTSUrHmbVG3pFwOG2iI7c7lpCkobgD1rOKVCH8YjjjY29esqqDp/BrCNyQ4VRAlwKYPnfi7PsIZG/jqWZ/xdu7dbq+yZkInGHM68yHHD6PumhDqf/8gwfiDY4Ytpw67FBA9rAcPhdKGZp0xV1h3t9t1W7rLxNLxP/wr8+/FclT05yBdgZ2bzXQZkVas086GnTSWBhprSSFrq0lLbry3sNlU60DUlvEBeYQ+70yJr8cPtJzN9Ab7W3fMWkU8vi2Hm2r9qb8YCP38zV08shPHqVcmUDBa72ucMxaGvhfnTwC6CiY9jTHIgWQ+cglphSidFZKeDFs+8Hky2Hvipr2hkIddBSxCZGGLLpgvFJ+1yu+UfSkau+Omf9oY/S47Lc3H+3RJKvT4
 1a3oV3/3
 T2kMx87wL+0zOkrpmCigZ0oJWP1kdJhNrH0FsfrLtbQeoJ5VKZMnUHAGv8W0vfd1d+9a8lY2qRhHZhvkhGhyKqxzewOBV+N1Fsrtja7gqo9BFmdFk6zC6FlBVyA5TAaEOubn+fEd7XOsW5rIAb/3RRhDQiu+UYFAPcrrXedcFRjiCfU6kybCrhTcP/1GVIfW9tfJj0RnT7jufDPNibTljv2nsYT1j6CjrnFhWP9OFAqWA5tXbm0XfcLAp1rxbqCDPCFhMKtCdJEmLoz7RjbFFeT5Ejd6rexuYhSxS87dw1LWKfWD0baFtIaunmhntmfI7YScfTcvGUOqRvyU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In section_activate(), if populate_section_memmap() fails, the error
handling path calls section_deactivate() to roll back the state. This
causes a vmemmap accounting imbalance.

Since commit c3576889d87b ("mm: fix accounting of memmap pages"),
memmap pages are accounted for only after populate_section_memmap()
succeeds. However, the failure path unconditionally calls
section_deactivate(), which decreases the vmemmap count. Consequently,
a failure in populate_section_memmap() leads to an accounting underflow,
incorrectly reducing the system's tracked vmemmap usage.

Fix this more thoroughly by moving all accounting calls into the lower
level functions that actually perform the vmemmap allocation and freeing:

  - populate_section_memmap() accounts for newly allocated vmemmap pages
  - depopulate_section_memmap() unaccounts when vmemmap is freed

This ensures proper accounting in all code paths, including error
handling and early section cases.

Fixes: c3576889d87b ("mm: fix accounting of memmap pages")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/sparse-vmemmap.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 6eadb9d116e4..a7b11248b989 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -656,7 +656,12 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
 {
-	return __populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
+	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap,
+						      pgmap);
+
+	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
+
+	return page;
 }
 
 static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
@@ -665,13 +670,17 @@ static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
+	memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
 	vmemmap_free(start, end, altmap);
 }
+
 static void free_map_bootmem(struct page *memmap)
 {
 	unsigned long start = (unsigned long)memmap;
 	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
 
+	memmap_boot_pages_add(-1L * (DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
+						  PAGE_SIZE)));
 	vmemmap_free(start, end, NULL);
 }
 
@@ -774,14 +783,10 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 	 * The memmap of early sections is always fully populated. See
 	 * section_activate() and pfn_valid() .
 	 */
-	if (!section_is_early) {
-		memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
+	if (!section_is_early)
 		depopulate_section_memmap(pfn, nr_pages, altmap);
-	} else if (memmap) {
-		memmap_boot_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page),
-							  PAGE_SIZE)));
+	else if (memmap)
 		free_map_bootmem(memmap);
-	}
 
 	if (empty)
 		ms->section_mem_map = (unsigned long)NULL;
@@ -826,7 +831,6 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 		section_deactivate(pfn, nr_pages, altmap);
 		return ERR_PTR(-ENOMEM);
 	}
-	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
 
 	return memmap;
 }
-- 
2.20.1


