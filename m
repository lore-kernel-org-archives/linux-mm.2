Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ACCCFF8860
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 09:27:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD00D6B008C; Sun, 26 Apr 2026 05:27:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA7416B0092; Sun, 26 Apr 2026 05:27:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBD886B0093; Sun, 26 Apr 2026 05:27:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B9DA16B008C
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 05:27:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 515E614039D
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 09:27:13 +0000 (UTC)
X-FDA: 84700178346.12.1B63288
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf21.hostedemail.com (Postfix) with ESMTP id 80DB61C0004
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 09:27:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=AOUcSIDw;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777195631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Odp+99JHCbpwHHM6ds3EE8rv22wzvZDnJ+uzSMS+VHA=;
	b=LI0zDYzyDZqh7Yc+Z5rRsD4u+dQtzUzlBbJ8hpzRmMrCUBGH0cixMFaMyl4IiLkp92wxVg
	wpKyFXal6b7VPhKMBMoU/FgXw1oPnAjgPgNLLAYRd7BDhKKJIV2pz9S5evji1qDl/la6Y6
	t5f+ISU+PkQRqgueQ6Zs8bYHqMbuOKw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=AOUcSIDw;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777195631; a=rsa-sha256;
	cv=none;
	b=esjf1tMI1NKynrG2Y8TBRVNDKg+ouDZRkoaHcRc7EfI1SToNcUPjvz4v8iyQ0JKmSGExYk
	TKmS5+XrEoPU7U3Fo2cy53cOTljKzb5yRdvloM1aDPszqiCN/4g74myI+5C7/a+WgF0EF/
	1DCy3p5CeJK0FUznhLiiIylNQyhco4I=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2b788a98557so41725095ad.2
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 02:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1777195630; x=1777800430; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Odp+99JHCbpwHHM6ds3EE8rv22wzvZDnJ+uzSMS+VHA=;
        b=AOUcSIDw4/8++K9EOhk2xY9WjoRTMA+lbLWwC3qFY+XcQSUNcCC1syugP/DfGm8+up
         A72KCsmDwcr+Ysyhzz5eNneoaqS7qEjMh+GreW59SRkDrpUJkeK0K7P4HgpjejnlWzoO
         vupg9x+nBSDe6DrFHn8pkeGpOh3ym9ebXifpNuN1fw+7pll48pgQV9vBOfPexAdUsGDa
         kLazbZ8HPojIdIzNRt7KXmc0M9yhQdpRMuBkqJACD1bcyOKbqo40aVdVOXSzjl+15/vc
         e3rMavFK5lFti8uFQjJZJYU+3YOTlxTh18jLNi2zitqg22gm45TEaNNNmifnQ6X+xZjA
         SC/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777195630; x=1777800430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Odp+99JHCbpwHHM6ds3EE8rv22wzvZDnJ+uzSMS+VHA=;
        b=JVUY45c1XopwKzPMYzkngQxbqwCSDbEisk8q7Wpzw03noRLV1heM4wxJLmeDJ09tIa
         ZmzPrbvGFr50ByHI6kshG2n2hv9BTm2bwL9PJUUUkrF2Nm7I2H0CrAjaOvl9c7og7A06
         vXXl/0449DVWCFH3PcoWyKlb9jsgI35THPoReO5WvPVR46bBoKJIXw5ILOcfS7RT4kWV
         1KiVaSJHBsI5je+QrNUQyjZ1suXZi4aNtR2MWdOUJhbfvwBRNOLP6EfsEfewG5FLpJmV
         BE07+2ahZ2X1+9DA9umNLXg6/04olIDBFzQ3op8KKyJnMuj8uuK8ZcU42nOttvy8BPaC
         /c4g==
X-Forwarded-Encrypted: i=1; AFNElJ+SKgsFrxz9Yq3caOFlePA+pJTuLe9FCyf/RCfUUWQBPwd4pHFRNB5XzdHh0CD3bLvVEer+WM61ug==@kvack.org
X-Gm-Message-State: AOJu0YxwUh7MDg7JaXr2CplFr02UduUDgjkpp5anT36xfaWt0086QTDM
	8ATof4PGDKiyFM1tBkiUK+I6/e+IklPak7l8WsxO+WnnN+3bYp4SsyAreZwAJvBo9CM=
X-Gm-Gg: AeBDieutpFtDa+HunEY5BAaoWcXH22wLNtqX82hsXYAJZ8jVSeeLn0q1PBqcT5nKdCE
	L+ALRj64Hxmcs0az21gS9DAdiDagbNmkjvNvnv8q6zGEHklJO1NDtVS+vDl9Rt3+zFgMcew9ADI
	OdxTqVtiFejbdFes2PQKLmBRsipto8zrDOo3XiJE1vTwaf8FVQJANNNXg/7Ya77Om4LGVM7U/7J
	YQra4p28S01C52ygZyJVGwoSTSFLZ01cnz+eQPmtotwQ0GSIBdnuMabVFvsLkCwIePgf616eKkC
	hK9VTQb036fVSOSTJoQbS0XYLB9NA9RP20j4f5qfdkDDpEgtG5XD8Lw3UlmKGJO9IcvUJFWItYu
	IwEU67Qv4apfmgPL9dq1lAf6J50ZmsQd31uO828k8M1eagOypt8sNocXkw889FZhVWJkbWtP41O
	5f/uurKdyefP5AKb0JW/XnJEwTwio4
X-Received: by 2002:a17:902:cf0f:b0:2b7:a1ff:b239 with SMTP id d9443c01a7336-2b7a1ffb4b5mr144455245ad.14.1777195630176;
        Sun, 26 Apr 2026 02:27:10 -0700 (PDT)
Received: from n232-176-004.byted.org ([240e:83:200::34a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab0caa9sm270352885ad.40.2026.04.26.02.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 02:27:09 -0700 (PDT)
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
Subject: [PATCH v7 1/6] mm/sparse-vmemmap: Fix vmemmap accounting underflow
Date: Sun, 26 Apr 2026 17:26:35 +0800
Message-Id: <20260426092640.375967-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260426092640.375967-1-songmuchun@bytedance.com>
References: <20260426092640.375967-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gzbew6fn75ijjuse6qine57a47wcossz
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 80DB61C0004
X-Rspam-User: 
X-HE-Tag: 1777195631-626377
X-HE-Meta: U2FsdGVkX19tkRsMCGTvNvuVhu8kQVSB2VmHCTxv1Jq+oakxDqG8Re+v7FUHm9H/FNLl9fRUV0jtN+XvtpeLfJtrf2UlgYhMCFvr0X91jJC08E/25iupRG13FBXhB6u6v7C3TuRuUpzrU//PlB6oaLptS/YKvOoI8b+AIa1DdpizPf//+sZxUSVBlMsmqzaiNWLHttw+PNcoQjUamlEV/L6zGBhjOONYWIVii05tAFUTCeR8X9wKoRSaAKpePQZDqR6M5EaqAEKz8qBY/QOY0/1ZT1bygCjIHecQmEn8+IAjhlz97Xac1UbZdRFWXKWG9gVVVU+t/vYsXwTy+tm/jBZlNXOMLQn3WDu7tu//y0Jp5GXI41/MdKQphQsuuex+hG9Qrt7V0QtF6ulsJv/UjdhfLTFtdHgBdtZk7BBRT+d/y5kJYgURjwqtza7mkyWoQ0e/wCMSkEoeQitjlamFHjp8B+jc6XhCt5QedsD4WEASIggKmQSIYAhWkKmlkHA24o9WbSRfcYS9tc2moeSiJpwvmFGaPNCT6rhA7CHLR7YPwuR8fIWWbK2Dy0uqxJ9JZUm+c7lU6P+W5tcH9d4rJIevrojzg67IkmYE4k/9HdPZ+e0dQ+Vo3Lc4k3aaE5ncmVX8KZe6JisIp5qOSw2YLzQvC2iBq16MujVbyUEnkJpXT/qyBzf6n2+cRgowpES/Se2oY2ls6D+66gPIIGo/7lzOUNhWfCthVardfKNhI3e2jDbHFjvm+KlY6P6PInkRoeXnNFiw2H43r4rt5WU7Wmj2fc8tguz7YlEGVSjVtnysiIZGXTvNw6kmxk5yoOHkzRvoTdvJ3gQRSQxV2dMRWULmnSn+DPLhKXnwwfewmInaMDoReqYEOKYveveYWT6ika2G9BNhWl9GI1HUAzpE6LEeaywY6RbOP57MLicCIF6xNcHIEqpfPYNhOxBOW8hV+5HLptbqk8lYoC4Otwe
 flQG3L64
 z4ZdNzp1Z6ZOLk+Plq5uAbSm0jK3IwalCFTZB8yQ/bY394bG8xWxvHHpz1zSJD4ePJlZDAujP1q/qK0rdIxrv4OTtP0JMpdEXjtION+ywipZ5DQ5A8DRq9BOAhY2upA2kNdklV/20LxVICWXB9xLn4/OIS6OTSZOuKF68LNcO0VDbIfzRPp8S3/7H7t3johkGuCOEx5aQKOkqhtTzT61PFidb+LRHvdqAXWRpLqXynyyxj9bXsTn82nyNNdwJlWmTYnflLqDKDtpMR57hh8nFESf+sNIU0LdKOWejAIfuKDRUKSVArdvFIEBHvwauvsRFeeg5FRTogGj1lioG+rjA9LmNtA==
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
Cc: stable@vger.kernel.org
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


