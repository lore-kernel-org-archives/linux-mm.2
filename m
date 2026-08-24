Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03BA5C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:16:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F41E66B0092; Mon, 24 Aug 2026 10:16:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F19346B0099; Mon, 24 Aug 2026 10:16:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E08796B00A0; Mon, 24 Aug 2026 10:16:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B09B46B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:16:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D11C1A016A
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:16:40 +0000 (UTC)
X-FDA: 85136363760.05.8821AD5
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id 708141C0006
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:16:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NMwCnhtP;
	spf=pass (imf18.hostedemail.com: domain of hughd@google.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787580998;
	b=P1oy2s9tAijlTyNrkYcdtza3qWwj6FErnAJUJS0wagp7tPVoHHeXbn6wEpY9m+1rcLrRf0
	n2Qd59HOMjGKDQbjEEfB2oafJjDL+V1DMv/LSnFjO57WxE1nYbvnHnrBGWKBOCOM7tFtYq
	wq5n0YNFa1acKneVJHU49CA77C31zx0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NMwCnhtP;
	spf=pass (imf18.hostedemail.com: domain of hughd@google.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787580998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vRQTGUT/r/6sjQRYrNEkhtszeIpWm9eC3zYKRwiMzSE=;
	b=PIXMjTb2k2Hmlt/IX1JtG6qQeaY/XeHSnQssTmGEuM0QtDg5kU09uKfQ0nfjffsq+Qx9sr
	cTTAAXjjRKXjwqn9jexcptBAOPC07KTHa/ttplIYCsvUFwXwPwvFsf8O1+Srn6Ul8FkSdv
	mt/m5e41Fa1tiqgVb1lMzK6/UGjZOeA=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-81dfdbd86d1so45215817b3.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787580997; x=1788185797; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vRQTGUT/r/6sjQRYrNEkhtszeIpWm9eC3zYKRwiMzSE=;
        b=NMwCnhtPe+4rVpMucabrGgYKIfKPXyFaTxJPfqE3sgaB/9YyxzDVOGTiycj7y+Muze
         HlOrw54uH4l1JYT6YVSXKRwWbqRygYdXBhQ0kl7NAm2PmLPb9dNPcyiqlMooOSpXB7Ns
         CfyqUK3fNLI1fDvt6qLmYtRDRw9vUmLiHgfJAZLb5fk9XhIMu8fT96PCbW2gblULy2Bi
         l9Zzgdl+jgLsReVwcbab1Fx3Uy+pHD2vKEKfsFNdvJhOzNadrCeBAEUJD/NEdyLCJCSM
         rRpNKSldg8quY8v4QodL+eWTXb7jMhRLFbmpqD1Wv/W7wJJyegKQUUy0qYqxXNc/A0PL
         uJjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787580997; x=1788185797;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vRQTGUT/r/6sjQRYrNEkhtszeIpWm9eC3zYKRwiMzSE=;
        b=o2YDvSysEY0wHHb3vbs2vmyzyGB1n7Yao7HsfN5BKxnVKOPiK5VL48lFzqB7jx5Izr
         jJxQhRqbCMbUGHg3SNV2aj6NvB7LLgtejq9dNKitycUi3aZjIZ9xKkS+IsH3E8X8KdBR
         nXEHpESbP0W2A9ZX9QBADfknOAhboa2I4oP/1PyKfCYbT5e24rrJefG2JM7geQeHrqIe
         xk04V/zB718BK5hc8Xw8/ejUtVXG+i5t/a0XwMcBYINGSrBGsHD4LdvT368KQH+P4cX9
         d3RhNJk4wcSBgFbMz956LB0qGePqNfweuGRvXK9E1ZqSriNnyH2MQsqpBs2Jpg7+oPx4
         l8lQ==
X-Forwarded-Encrypted: i=1; AHgh+RqcXae5rqiGeLiBNwGpJ8iGPNo1oKKp3ni24JOzVjlWpaQR6x9SrOt8dhLQL/KFGjHhF0fItNHqnA==@kvack.org
X-Gm-Message-State: AFuF++nrf5RRUWKyrYSdKmU9KnU/Zq2zeeaepSJ30Goaflm3FhaYD/oh
	7MfhsaeWFudCERS8evD7HzNzGgrtG2hGuRiOUCeT7Ksf5ZQU5pZjXJX0M1zwTcRfaQ==
X-Gm-Gg: AR+sD11knZhqiMWwdGdrwYiJD+JLmy4jMHXOzr/pWsTReEvs2J4N3aFQ2k+Xo19mILD
	WI7ozb16ihowZVRgH1EKC3gLHIo+1RECfmdIUTte/xlAnaozyMNjzpgePZhZDWvYzfP/0k68ehj
	8HwN9hAJAml+Pn14xypkexOKEj1Wo64wPz5dsISvgu3pHMzT4y3AUCVKm7gJwv29un1JUJ3wgH6
	BCfcrkNq5ASWozEb998K3GplXTe/ltU8KWwwPqAmrVpsHs/zSqXC5pZylkfvzgm5TbRewRcINV3
	1TNTgceJVi1gkp/FvdN1oZ0ECAUopuT3TAE3IXz4RSWgJYRAdPll0nMOZB5HEmz2bC+ZpAg6tcb
	z2MgzPdZfx1r9mL0KdrkDlYwMZDOWlfH35KLRdT4xhwKvzVYtozg282BM5DQ3if7RuBxBMzwneE
	Kbpk7bFPsH7nZ2Tb738AmG4kvIsNGd6Tsbv/C/ARGsDdi76Ym2xUYJk1cUU7iVqhKyYhq9G+lIY
	ArEJSQ9gN4zO3sQIP+4ZqFnuCpUmG0Oa535nN9PE4rzk3wQ
X-Received: by 2002:a05:690c:568a:20b0:844:9f61:92d9 with SMTP id 00721157ae682-849f67acaa8mr75561237b3.17.1787580996861;
        Mon, 24 Aug 2026 07:16:36 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-851e1419e0bsm11879757b3.26.2026.08.24.07.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:16:35 -0700 (PDT)
Date: Mon, 24 Aug 2026 07:16:30 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 10/25] mm/fbatch: remove several uses of
 mlock_drain_local()
In-Reply-To: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
Message-ID: <b0a8293a-3a4d-49ea-f902-e6a2a20e5da6@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 708141C0006
X-Rspam-User: 
X-Stat-Signature: ry54wu6f1fmbnn1s8ikkgfbqq3jfh9oi
X-Rspamd-Server: rspam06
X-HE-Tag: 1787580998-590957
X-HE-Meta: U2FsdGVkX1/lf8sfNZto/Co/OOg68+FYVhthqqqgK7oOh3PgfvzRGGGM0kt7yeI5C1+cq2HnHJ3SX8Jos/tRcmn+F7M6bN3+pk//n9hG3MgASWcH93kWSHpSYEz8MVHHZ0xhTjnrXMX2p57tdZZgCLzIEidjkDAYE5oUUHQCs55mayybLciXXLXVhK5mqNsBmJU9pcl7W5W2KLT2c53BskNkff10p3GvUPkoCIV0Vesa60i2hJAJYfLj5wYaUJqNA0PgVu1qZmxJTJlO648rPTffO4jDV/WRoM5cc/YGbIgeYyBiazboD7Nx7rgvSJptxOtyiyQmhYFwzpKpVmy8GWcgr1j7yMJESdHluQhsR40bXZfkIwsLl3AuCUAFT2JFDB1q3MpkLU9YznQKhGLS1l/GOjfhc4Mq9XKjYrbwa4Go2GAXFtXppzG5VASsTCw1cMF42lsPQU/P3+8nIvywg84aPxpl6CN/l9s2r0sd35Zb8ybB0b6ERdF1w0cuY3uTM41v6FkEY42kIpH5eeNEvjb3nITq86s9FDZUoCtdmMRu0eHJi0R4uPhlFGLpTveyULd8UAjC7TyYCZ3sjKxJXLCpN4LN1Nj23Nvhhh+ecNRTtT7i4CPMpKlVe1lyhxu6oHtT/QscdpkHznS9ax7JxP/8m8aI0WeJvFGUZqBEpFoufxnJ8VRLPeuzMOJ+F45MegMhdhtn+fsFOo6orl/ZQBR/D+RUeiWW6LjrNuddijUHhs9nxwC2XLlM/p/szml1CWSLeeMW7qwo94K61kWLfcZKNKV/PfkCmuEoymHXR7bSYlly2GBHIH4r+Vklqtz8vh1lu5hOCTYVI1rnEtAUi5SmuhSRkZEgcjCJUHsgjWYBNs//pXfZ3O4cGZ2ZpyVny607ONFfGqUPmQAXPDIcpnR5aw74Elc3ormQu+oCKDtmJoxQoHiPLHljw0p+PPoPxGEElvYCffaLawXhECF
 GSvLUpsw
 GL4VbcTvV9DGLU3ekFGtkdCNdr+fe3wHz+KzAd55mGDwREB168o12LSLRTZaKBBwD+rlr4gC1SxZsf9KUyN1rf8wdELw2Q0LzoboUSVeghawOTkqEvtro6AMqiMPBXsjkcm3yO10H7E3jqnIv3CqVnTvUUZo1aRU5vSJ53BGaY1ZENiDO3BvO72dwIuNC59jx3TVyYntUz9CotIMqq0RAZ+LO+HlQEHQbU7eblTAmUvTwyHYKhhNVNDCzkWW+99dS287LbhLBLLiSWJXPLbBB21YAC97ZKFzxUamiptgdrGU1u8shAKzcIg2EmbMdRHSzfjBPJxYI8mNjUEJ9ogeTAlBXrSj1lrvuRwrVaPQS1J32JbrlIHhrq1tasvWGoD40iNzR0cjdqdxluqxwMBserDHdj4LgYC3GFAgnqMcMM0Zvzhu91z2mkqar5o76OUxAAApdXyOfOnOksAn/SvVKq7Gr/wMlcEQsTrb5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove several uses of mlock_drain_local(): they were workarounds for
when that sequence of operations tended to leave folios in mlock_fbatch
with debilitating raised refcount (and no good if the task changed CPU).

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/huge_memory.c | 2 --
 mm/migrate.c     | 2 --
 mm/rmap.c        | 4 ----
 3 files changed, 8 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c7bd99592195..df6bf69a066b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3568,8 +3568,6 @@ static bool __discard_anon_folio_pmd_locked(struct vm_area_struct *vma,
 	folio_remove_rmap_pmd(folio, pmd_page(orig_pmd), vma);
 	zap_deposited_table(mm, pmdp);
 	add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
-	if (vma->vm_flags & VM_LOCKED)
-		mlock_drain_local();
 	folio_put(folio);
 
 	return true;
diff --git a/mm/migrate.c b/mm/migrate.c
index 8aaafcea7bc1..6b71b2415d00 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -448,8 +448,6 @@ static bool remove_migration_pte(struct folio *folio,
 				folio_add_file_rmap_pte(folio, new, vma);
 			set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
 		}
-		if (READ_ONCE(vma->vm_flags) & VM_LOCKED)
-			mlock_drain_local();
 
 		trace_remove_migration_pte(pvmw.address, pte_val(pte),
 					   compound_order(new));
diff --git a/mm/rmap.c b/mm/rmap.c
index 1f72d279ba68..e76823ec4d5e 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2390,8 +2390,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		}
 finish_unmap:
 		folio_remove_rmap_ptes(folio, page, nr_pages, vma);
-		if (vma->vm_flags & VM_LOCKED)
-			mlock_drain_local();
 		folio_put_refs(folio, nr_pages);
 
 		/*
@@ -2765,8 +2763,6 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			hugetlb_remove_rmap(folio);
 		else
 			folio_remove_rmap_pte(folio, subpage, vma);
-		if (vma->vm_flags & VM_LOCKED)
-			mlock_drain_local();
 		folio_put(folio);
 	}
 
-- 
2.51.0


