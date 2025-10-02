Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 606F8CAC5BB
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 01:38:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64BD68E0003; Wed,  1 Oct 2025 21:38:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FC478E0002; Wed,  1 Oct 2025 21:38:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EB628E0003; Wed,  1 Oct 2025 21:38:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 398428E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 21:38:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B5BBD86669
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 01:38:32 +0000 (UTC)
X-FDA: 83951464464.10.76DE914
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf12.hostedemail.com (Postfix) with ESMTP id F3E4340018
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 01:38:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RC9rbsrM;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759369111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=BDDnGBDOOGji4bOsQZ3Ul8bZ6/fdo9llPBcLLrM9Xhw=;
	b=7tmKY5Hgzolfzys69wVZrA4/XnjKRSXAbyhf98Ggtf8kbaaXVsDe9vhNcCYWHWIUkV1Pu/
	8UkngG6+SD1T7JRwg/RP1j1+RXUf8drXz0/kHBSX3ujJ/fM7tEiHKV2U+ejhaPr7xU5SMp
	G2sX4SN761EMjWST8vee9XtjAGVxZT8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RC9rbsrM;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759369111; a=rsa-sha256;
	cv=none;
	b=J9f7isXRew8J8q/8hQmxnQIKEh3VGHfrhT9h75a2y2d67cWPmK88U2lY0SHxy8KCbLDLSE
	ra74CUiqrLh3w6CFZhe+ii2Ndu7FQ4CO7uh+iGtyhErh/Vcmdh80mfF94TOZHXvqEHTA2m
	PIPkJeP5wc/daKYgpWWRPhnGG4TnDzU=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-afcb7a16441so90645866b.2
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 18:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759369109; x=1759973909; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BDDnGBDOOGji4bOsQZ3Ul8bZ6/fdo9llPBcLLrM9Xhw=;
        b=RC9rbsrM3W+llrIt5Tgn9ylG4OCR9LYQBb3E96SUG7T8mIuF+XsWsZN2b7+zuQOJQ3
         BT4fDxrlp8cQO/xInrsSHISirqp/awCvLK2ZEYIhfHBeaFE7gGEBE/NKvXVhw4GEc/Fp
         io44h/JUlWD1JYjWb7IKkNZd6TyCm53E13Tkj7srI/Htq1KWcb9LTyOzb+g9UOioZRKn
         WzKkAasi6NeBjtJ1IcVYGXS/vgjzJ6+G9RAYqpWg5RTdvSnMB/xWqc01nUOXb78k1Xg+
         v9Pij1P6nSsDb73boCvLoH3y0eDOsURJuXgR4e0VGPnzxE8bCHmJqf9sh7JawNXKvItO
         zfmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759369109; x=1759973909;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BDDnGBDOOGji4bOsQZ3Ul8bZ6/fdo9llPBcLLrM9Xhw=;
        b=tkyRrvjwvLVDb2huUbgGI0OPrAl0G9ZbJu9jq7bkusIZA6JFA6lZzODTGVk6UnuiKe
         1Go8iAJE0VjuCvmDuIqEXxNWJApFdT4wIkHVk5XvZitYpHLlOrGkXkM79HXRG9U08AFx
         H6DNzxOepXlDSDWW/Z+ibCBTUp/SFf5QShzMRjgx6giEbLqEQ+YeXPKPl8K6UAGyQcse
         Bew6ZMtKjj9VD8iqYviO4j42lu2nAupD5y1jb9pWDSP7MrKg/DNd+H/vwfmuU9Ngip7o
         op6vqAriY8EKpiruJNlM51ka7nQoa51krzj2hbaVn5P+UvLm68HYLnifmrxotrpwq/K9
         D+eQ==
X-Gm-Message-State: AOJu0YzyyqEVAUCAAU5px63iEagpLx2Qh3LlNCOWsNhzWTUBpZImgct+
	UTNIR3+CcOSSULyzG5jZ0KjpSXMD2EQUJSLyLtz/rIjLLGNdRj/nSb4n
X-Gm-Gg: ASbGncvlTEdilfUSPBfq16t/+BaQwMD97J1j2TggZ1FcRy6rP9cNM3sNnJo4Q9HKN6d
	A9Z9mxdf6Ziu2n27Or7/2kq22ic53GJFCfegWclqSFTFgywAjL70oui/d0GfApFJHP5eC04VuSh
	rlPLv08sQKpJsUZhy98xbNoqe22bjr2Yh6cvoHnchg3qw3+3KnRyow3c7T1tZicIh2dEYuEeumx
	WrIYGUOfmqqqM6jUBnD0QNiwdFi5yEdg8eIORJ3iofC00LkSyEarxx4GPblk+awgwqE/4UX8Pr8
	2KqVa1jst7u5lVqU7XbYBA6gQbbwbyAvBA9qTwshBQwz/yfxBxriPzICDoSeycmHbGjP9F2zOUU
	2CTACRWxe3IOjtVrI6s7RUVrriQe1GDCt3Tg4QB1FWVY0TWu2VA==
X-Google-Smtp-Source: AGHT+IGYkhK9D83thDffjxtcF3fdgyIYZDpOc53LuXBxHq3bDwX85vgQKbTPEoz+O+2+HOtqs+z6Qw==
X-Received: by 2002:a17:907:6d0b:b0:b46:abad:430e with SMTP id a640c23a62f3a-b46e47910c6mr675645966b.37.1759369109107;
        Wed, 01 Oct 2025 18:38:29 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b486970b32bsm87824466b.50.2025.10.01.18.38.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 01 Oct 2025 18:38:28 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	wangkefeng.wang@huawei.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	stable@vger.kernel.org
Subject: [Patch v2] mm/huge_memory: add pmd folio to ds_queue in do_huge_zero_wp_pmd()
Date: Thu,  2 Oct 2025 01:38:25 +0000
Message-Id: <20251002013825.20448-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Queue-Id: F3E4340018
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: scag3wynx4yb9e3haicmq3umx1454s1a
X-HE-Tag: 1759369110-309983
X-HE-Meta: U2FsdGVkX18hKue6FltBwp5pE8iGaozfzu38XCoBX+jbpbYoTrsDFieVpdroEun6W4D8Pt6u3jjtv203hhgiPtlJbNw9Z22kcEezWtal/MLFIDKkdTPr3oe/epSynCCm2wsGHgPRDuiUoG+PlJbfNNeGGOWs7EJjiHIgDv5cxSmUW+jed1nxdiops8Hy9OGla9EmHYDsG2uRh8eTJiv8Xn9hFF9v7KCPV4x03uSiM5l2cOOLkAIYJVAHoatZsmqx2LlUZEI65EC5A+N8L3r9ZPQMhXLKbYtnx/Of7B3qEe2NQMc5ozBoStUvzhV++jEx7Epb0VSMJts11SoXZNq6YSfXEORa4be58rvtFLwu0t8eEJ/4lhAmIqIcXrITFGsoNu25uRlXn/VfTBIAW30JZyTRlBxAHTfSJF1K3C4Vl/dRKOQ0+3G/4uKH91m39DabmgsBaZ+nvCt9U7rSpCS98NbdXF40K5b1L63abixjRqgkYu3RxTqY3ts4KjRy0L4YxV3HjnvgmYl0Bkt3yHil0AphP0Nb76hyS0yuMNzTimLldPFJ+3zNWdvfdopXW8qvljHuAwYhOoN/1d44RfCq1qsS5nW/Th6l9V0WhUBjpfS+dWa5ZRL9oWpExGV2UONK96bl8wn267qy5YGN6UIsezA5v5dR0lSZetUVIksylDCZXNTks5Hhap4TH41WC0cOnX1OyMUNX7LuTTtLrim4sha6ltggIUvrl6wJ4VNvlS+rQTznxbzVd1qZqLBkCYZxe642Lma4QG47+Fpy1DH2I1VdHhaxRyqtqhLYwzcx3Ijxd1zhXIlXgKxDHy0iS6Ky5IkH5xUiXgmiqFsGqIzrwjqMfcIWZPbNTEVBpNi3uXYnNigaefqzZchf762M7e1q0aSzKpkTcbX8Gcpb/ZwJD3MU81pL+Zg4N8mPKs5cMp3B2ZKNczNEeC1eEVr/dsDvPmLqwEo5iqMcPOgwsIt
 e5mJ3dMn
 hDTClR7f6USjC4Vd4Q4HLyTFiNWFLccAxyTggf10cuXAxD+lvpewvd74duEP0aBZTbvdzqbRd5ZnFzW+70Xx9b+swAPwMu+3UeLzc4xRfOgmykANKZikL8pvVb6HZbZFXMW1CapY63yClnDg4bdst1fjApPxho01ECxISG1fBRIukgcJhQKlHU7MgtCc9/c5n3XSehgaFdpfGB5JohELWagTgfIe24frfqdNKOwv/Mv/MS+5P7pdSAK6UeP1YiS6K/kvKVoI1eepOlnhbwC1EsvchLoG0WnqjgX3ajjRLqlujekeKeqDVnTyi7t5v8H+5O/kle1nRx5sm1+5zy8GvYstKQGDJPWaVzxAmdkviJbmmZikytWYw9qpMZ3/REW6I+mqLtkRxmJIM6OJXvemtEaiW4xG+1V/UCPuICKJKraHAcCLb5GazZ3CGE61M5l8gmaix66A7wY5dXRKQUAMrkr+opdZw3+PrFALHrnUcVJWZ60xvDHtH3qx17RLV9o4xS9gjpU6l4AyUsIDAicJgcMMJRerQdu66Y/t93OV4E5KWSG0Zk6wCV8L9ThfDAL3bkm3CgpFnAciMZTBONa5cySXMSTe0JVSGq1Xj85TT0XCmSZhpgedPaAK5fzPcPgSzUsOKaJPKAasW0eo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We add pmd folio into ds_queue on the first page fault in
__do_huge_pmd_anonymous_page(), so that we can split it in case of
memory pressure. This should be the same for a pmd folio during wp
page fault.

Commit 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault") miss
to add it to ds_queue, which means system may not reclaim enough memory
in case of memory pressure even the pmd folio is under used.

Move deferred_split_folio() into map_anon_folio_pmd() to make the pmd
folio installation consistent.

Fixes: 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Dev Jain <dev.jain@arm.com>
Cc: <stable@vger.kernel.org>

---
v2:
  * add fix, cc stable and put description about the flow of current
    code
  * move deferred_split_folio() into map_anon_folio_pmd()
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1b81680b4225..f13de93637bf 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1232,6 +1232,7 @@ static void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
 	count_vm_event(THP_FAULT_ALLOC);
 	count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
 	count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
+	deferred_split_folio(folio, false);
 }
 
 static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
@@ -1272,7 +1273,6 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
 		map_anon_folio_pmd(folio, vmf->pmd, vma, haddr);
 		mm_inc_nr_ptes(vma->vm_mm);
-		deferred_split_folio(folio, false);
 		spin_unlock(vmf->ptl);
 	}
 
-- 
2.34.1


