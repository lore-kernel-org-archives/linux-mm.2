Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02472CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 09:55:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D2D88E001B; Wed,  8 Oct 2025 05:55:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 198D38E0002; Wed,  8 Oct 2025 05:55:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F063E8E001B; Wed,  8 Oct 2025 05:55:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D7D8A8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 05:55:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A8C4EB9ABE
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 09:55:48 +0000 (UTC)
X-FDA: 83974490376.08.1A32CBD
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf01.hostedemail.com (Postfix) with ESMTP id DE5C34000F
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 09:55:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P6fUwfbe;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759917347; a=rsa-sha256;
	cv=none;
	b=P/TnPlegd7MSCmoIoVp5FFizIEc2tgZpY1BBY/1coxzjn67rIptKAqFbQhAom0zgkji9NB
	nS1oRf9gDaMP9mSJ8Nl5EtGltYL2bfMlLSIymBYrNRTuLDUYKz9EJlIQB6YkeU++GUC6MM
	baaUBeb+zz7A4AuJJL3iyP5zO0EF58s=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P6fUwfbe;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759917347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=pDRBkYZdOzZGDYzEgVoLqa44ujNT7h8FiknWLKuaMVA=;
	b=FDKjBQPJaW10m5AOgxvWU6AJ/KhuzPokBW5z2A2jYQkOHUOvOToppgC5WjAw12eg72c5XK
	XMvmU88TEpCbeHMdEGhZrJZFVQ1kcjb3NMfdA+yQ1HWnLk1uH1+fGvOOU+m1d6qNCprgv8
	n8Vwe8W9q1/A9+sZUbVrKKNtM6Zav/Y=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-afcb7322da8so1507053066b.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 02:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759917345; x=1760522145; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pDRBkYZdOzZGDYzEgVoLqa44ujNT7h8FiknWLKuaMVA=;
        b=P6fUwfbeH5opMNr7KmRogsJ9whOJ83mwQpG6GHUBOOQY+8cFRpFNdN5R5kbUdj9rm4
         zE8PD3ZQjvuG4Wx1OjM4iM+m4hi43r7icBo7DFTP9OvgaIWYiO6hMWCd/8spN+XGXvBA
         7H7BZ+tm/eUBoN4WO9VV8Nha7sLnJxXABfVNVvAUG8SDWCdwRAX2WgxvP+bN8Av1Ntr/
         vtMoBcynGtVn6J8gmJXEPSiKGcbmRnl6Ipsghc5KULRgr1gzaJ2/TWIZYmY6ZBw+wHMu
         y2S0DG80fLAC4zeNhrhT1E4XnHScF16lZYsxya3fr5MvnSu0FCKp1ERh/XBS7XQXascR
         RWCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759917345; x=1760522145;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pDRBkYZdOzZGDYzEgVoLqa44ujNT7h8FiknWLKuaMVA=;
        b=WqxXaBvglCQNJxOePqQ30t9O7sHQhQv5FX3ORQvxix9YDvaSTnmEaxlDoXS1WMCPjx
         f8PzrRemUg7FRVLBwNl6/L3Amzwrt9WckbTgGHnd3FJHlMsiia2eAHUCakZgbqIeNy4E
         S427da7/rl1C1WESHB3c4KFKfIJEFPT/meArp0ENtcRAk4YW2lSiLd13h4tOI5s7Ak6J
         NmMVeBgf1SjmvAY8m4AvPuTQD11Edpp370HkcWVTFCjuTdVsdgJzSIbxnB2DWHHC8ESB
         YUsnGqIKcPg5CiGV94w9C51B9SNz/Ur/RBUsUYyDuVCMG8LJr8pfbXMnzdM17sq0pF29
         u8wA==
X-Gm-Message-State: AOJu0YzZ72paHf0s4+vq+sRxnTW/JwBEr6MQ8KPKZ5+f2EupXkoTNy3A
	pVn7ZyuzRogx6EEU16SMQvGhqcWn42MVFMBJIhCzPFSQRhZ8vRYmRMz36Jj3aA==
X-Gm-Gg: ASbGncupup1z/ICGlYiwmoiahWHWLLNAyVIeODsb8jn6gf9sCIZlSoK6tvCLuwTjxBE
	qTbYTjIVdLLyFjqeq9kuiwQ8/Ah2J2q5/i6tPZFUy+AEEyU8tZ90SwqHT4HSAu5+xWRwRf5r/OJ
	s1lMGkFtMjgnn41QFIMP6RG6KJc/J8XHAJnK2ef1KT7QyUIPDJ0SVAQ+SfIAgL4EVJAsdGT84if
	qfKtN/dCyIUJEFlN1aTImODL35r/jAiFZPF9jwdc+P+BP6zT82LWfTwWGJwTTRtyfP60hazWUx6
	wZI8+K12pjtlXRDm711/cZjlARBJr3LRF67J3VZy3CfINScpUJuHZUoVTmuDsubokEf2BLSWWG1
	dDLgwYLJfBHQh52AqbwEuGwnapXmPp4ip/gdvR8dNzIPWEOVVxg==
X-Google-Smtp-Source: AGHT+IES8vgaoCILf24BCoYwS+m5uezp0yX3+AYvqyTN8cEUddNOPvKhWr9uhGYOvdam1IrwoNqe1w==
X-Received: by 2002:a17:906:468f:b0:b50:a067:2d83 with SMTP id a640c23a62f3a-b50ac0cc340mr256921366b.31.1759917345375;
        Wed, 08 Oct 2025 02:55:45 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b4f7eacdfe6sm416425466b.27.2025.10.08.02.55.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 Oct 2025 02:55:45 -0700 (PDT)
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
	usamaarif642@gmail.com,
	willy@infradead.org,
	Wei Yang <richard.weiyang@gmail.com>,
	stable@vger.kernel.org
Subject: [Patch v3 1/2] mm/huge_memory: add pmd folio to ds_queue in do_huge_zero_wp_pmd()
Date: Wed,  8 Oct 2025 09:54:52 +0000
Message-Id: <20251008095453.18772-2-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251008095453.18772-1-richard.weiyang@gmail.com>
References: <20251008095453.18772-1-richard.weiyang@gmail.com>
X-Rspam-User: 
X-Stat-Signature: 9m8kf45xdz64chqbb7c3737kyhdm6ysb
X-Rspamd-Queue-Id: DE5C34000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1759917346-374792
X-HE-Meta: U2FsdGVkX1/I8BXVYu5OguELlpSkiqnOkXHLl9Q1kDYGNUWAZMoeqtIFi2B0dWhKRTJf1gbI19hbzGmCTkhG9ltKRIGs7vx9jKvn++koE1YCRJIlTCsUbbxIVRTZAWeXuLGq2LAEIOx2FFav1Df4NqNReg7ouP2XtdXkCKTIP8Jj37b2l+eFf3IU3j6Jzw4HwlovScHln0bBecg1QQlxl7jxbw21c9y7dKPp8AZBu6djIfMcB94gBseasMi+FaIlYI1+ULT27j+kz94Gta1atwdlrlH7dtYenF1uPbcVPYCo3wXNeXDQh796gMVEcXOy4xo9E+HEPFDDvzeALJYxZsQfJXS7FGCngPhqBmL9HXXtxzX20VTRiRneK40lam4XmpMl5n9GFbKr/WFT9Ko4Cw1FgbkEnUY4fhLU5PS056x3hkcg0qSiorHpb4Y6wA5AHO4UiAHdYABBTZ4xZ13o2G+yFfn6JNlSXuyF5wh+EfMUAjcAz+BXo15EONt7f4Gwk0sbsr9kwUTPjkUgTjTzQnqBhX728KJv1G1VmcIT7DmxZbNNFdiirGUQ4g21O8EEEtyPlyhGadodNJzYtsq71XVudHjX+zWoUMTklZosx15ATXjbhjjdQ5wBgu4nmHM0VpcMAYkxP6GtgNnPqQO35bB/Y/YqSZJ1/OkLgWCLPPCbnJ/c59533X1ruwmV338zqAqSAhMT9M6xMvJL4Dhw6/+OZuAAGDIpP+IESIDkRJISm/mL0VKFxcZ76l2uMvL0Zd8Mu6hQLJAPjFT/BBtn3IhGfiQLF6SI/JSH6ZZjXZVVdpUarcIPFw5xal2EpxrgG+pHAIeC1yIJVs6IKt5q83vRny+++SGZBdoDbnp1ZJ89wpdi34/ju6yXD+wwYmRbkxfLaRXxWljAZtkErvQUQFGTW78g5cwP2NnvydGUCojQh/rUKaeR4bObhjANJpSvAGs4KriUxzTJQ7kB7QI
 cDagNZUW
 ZHV6k0k9pWodTtkhq570l3ZoVAd5ojlS87RUhij3DHY4Uh5bsrmOV339EqbArQq2ajgiuPv3A1VmTA/wu6A5Lg1wD80R7JkIiwO1RaVtE/pwmOwYPaQSezmfOam0LUOmUXbmTgZlZ13hutuq2Cp5EcARDTmkERmi7O1JLMU8xhsQAr1C1huXA7xs/lzLYf0V7NWLgkbRDcqPvs+bn1mn5DO6zrYzUFFPi0eqEk8Z02brVKWq0eJmpvjYbv/3DgjBd5Cmzlqrgv4cIrtJcfVsIb/gOv63IxMF7AQ1t2J60RZEaUCmBM7DtruT6DS0bBlL3ZczCBzpBM1DMLAnnduFrcRaASkGxcCti3WEPGObgGjxvnGDGGNvIpOGvm12PFRtC7EsPwju3f3cKd99R3ydsVXhSkLGGdQciuFhAxJvT7Zkt2RmWoYZNxcGf//7bMo+C0tOpSxSADUrBJKzuso24NlZeSnu+DuZORDEYAoYL49kwKQi4by4H20IrtsUohah/50IhvsEoYYedo9xBrpT1TQ2tIz9eSV4e+SrTC5uEMMwcXqyV/6azuhOd6kHkhFp30SRqrNAXY4pUQ6nubeXedXxRpcshDq4kJOnWE36bwqNG783dNpJkk1/hxZv6VDy2hyRcnySWFkZ7rRFEn4ZfDd0lm699cNrCTWGuOoEZhrlzdmFVLM23+YzgAEhb/Mv/hEpF
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
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>

---
v3:
  * rebase on latest mm-new
  * gather rb and acked-by
v2:
  * add fix, cc stable and put description about the flow of current
    code
  * move deferred_split_folio() into map_anon_folio_pmd()
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 002922bb6e42..e86699306c5e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1317,6 +1317,7 @@ static void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
 	count_vm_event(THP_FAULT_ALLOC);
 	count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
 	count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
+	deferred_split_folio(folio, false);
 }
 
 static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
@@ -1357,7 +1358,6 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
 		map_anon_folio_pmd(folio, vmf->pmd, vma, haddr);
 		mm_inc_nr_ptes(vma->vm_mm);
-		deferred_split_folio(folio, false);
 		spin_unlock(vmf->ptl);
 	}
 
-- 
2.34.1


