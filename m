Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E996C79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:01:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 855516B0099; Wed,  9 Sep 2026 06:01:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 835306B00A4; Wed,  9 Sep 2026 06:01:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CEA36B00A5; Wed,  9 Sep 2026 06:01:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 458D76B0099
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:01:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 62E0D160177
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:01:32 +0000 (UTC)
X-FDA: 85193781624.03.0F858CA
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7C746A0006
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:01:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QQ3c7wTw;
	spf=pass (imf15.hostedemail.com: domain of hughd@google.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788948090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uNBljcBd5pVR40/qSQbRzR+DUQkxJ6419XWxuVBt6mg=;
	b=FgNQNyEA/zh+DWV0nLHPr5AfAVJJge3NUUeMn80Ep0FrAv/BhVGJ+I1fPk1APgj+emezdM
	1020C6OVc3uMXhjMi3sdP4hCkSpKUbIPjnGVt9YS+FX32pyjE4BCnF8Ty8TaTT4lSrTkCi
	TTSDXIbJ5iRnDAjGSYtUdkuxjVx1DDM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788948090;
	b=CxDka4er0tbk5ai8GADW910IxSHOBvMIffhfDWQsTA18sdBwaCzMeWZVfY1/Vek/j+r195
	HWgeZa7RYKu1BwuJjvtKiHInew38mc6C4Rjt6xwI8CtBfcqkieI714VMAyjsVaw85Xwens
	ywtqdk5B6RlAVj5PfB47X+BefiBhbKE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QQ3c7wTw;
	spf=pass (imf15.hostedemail.com: domain of hughd@google.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-8565d77c277so73317257b3.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 03:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788948089; x=1789552889; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uNBljcBd5pVR40/qSQbRzR+DUQkxJ6419XWxuVBt6mg=;
        b=QQ3c7wTwayM6sGBy7esPtp4o3xm9WbJd60MlAWDCcm+vLCx9UQdgajSQkayhBvGYPR
         pRaFsVKHrRCroCE+b+lylnbZ6ONZEkAQHVVctWK8ZfW9ob5DnC1WJVG5TfDZd5wzb/zQ
         qfpCuyVxzN/TrTX6r61JcGtrf858mcgJ7BW2WAXXFrjTqQ4xRo7b8rFNNpD/phWCFLVU
         M6yDer7HnIWz0BgD4kImAdBHGDPYAKUD+0zbJPl1r+/MNKBI1jvOoQP6c8I+/jjq0z17
         +UFFPdVc+HSdEROqkxMXPhcnDWQDzaSnMzk2H4D0/34UdGSKEZLvg/a07Dr5nKHvRcm2
         0G/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788948089; x=1789552889;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uNBljcBd5pVR40/qSQbRzR+DUQkxJ6419XWxuVBt6mg=;
        b=TnRmwu7uf8p5Y08QqEHMSLVZSp5CynAsgRD6FE93CwxAMPFNx1lTq7x3UnUEUG47Y9
         ELZkUfhdhhcxvsM39klBWpmRxKPp7wIc7N5pUoHsfCj3jFMQG8OIyFlEBh0kZY8byiXP
         HASLe3GnaQE57rJmTmwx/BOnVQQESBGP00sEfOcB5c2aODZwue/1t3qg2fyi7Dl3Na33
         ez9T1BdKgZD2DfJ0MR3gkGMm2PQcIoG4MHEfiwul9unsLM/pVbVLCeclMhVsFjH0MZba
         Yi6hU7mL0SOgB4GKuuDJCNhvpXvSBaUzalfLYGLDzRVTrmkFE9OSiPW3s1FuN6+IFxxI
         vRjA==
X-Forwarded-Encrypted: i=1; AKwUvBziO4ALmmGPvfl+C47ev6fYzfsRxiYEJg0ZVD7hM3tSxfZq+fsrAynjnapRdc3cwVlXYU809GvOXw==@kvack.org
X-Gm-Message-State: AFuF++kY9TWvdX6xnHG5KVOPhNViOk5Hal7ROSTh9S2wnhFtwY00VGgd
	OAR6pRO03AOTa5XHob1KhE0oz3N/WLc8CsHOjUCOBudMUPX2wrLToqSA45w1cTN8FQ==
X-Gm-Gg: AYBFou39epza4eSUZ6dygiUwGY6dCQMowGdK51H3YfOxD0oOuU8uVDtWpm0BreTDxdo
	u4RinZIht3b8Sz1wOmP1EbWPSyJ3gO8UvtPdLzdRz3LyGWfrZXhjY1hBRgCbY2Q7heE0TLABwS+
	nLOdIjnqnwheZef0aYAucWXTA2to0pAVv/NPa+QGvXMxU6zYV9L7SF/Gjif9SXIEnXIDo4QSZbW
	RoP0xGJiZA/IaGHFNqEhH7UZtu/yyscJHdFFLBEvJ39x4rHOZZP10UmYcA2624wKAP427lmY8th
	S0J+cVirStl4G/QoeHXiv5OELp12FTG4nw75gqeATuRv349xrvI9gd14lSZ7DwzgPUbRA0tsr22
	FU/8iMHyV6pFYhhURf+fuyTTdksHquQ8tTHTCao+61BSVWDNu8SU5A70NdZgKEb/yBgXDJa2ua5
	8ZZzv/s/vfH1aDV4986pQe9bOomK/VgLiQqMQ2/jVlxwjHIphgeReLbaOlrjlZ7gOKRyKilRGap
	VpyCIq2woeaf24H0qXGgFM4IBwWMCIHl3cW7IXL4KPdEi9mv4EkoM8w2bQ=
X-Received: by 2002:a05:690c:88:b0:864:6f4d:ef7f with SMTP id 00721157ae682-87121acbbc5mr139590577b3.7.1788948088169;
        Wed, 09 Sep 2026 03:01:28 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8714a0b654dsm107264887b3.25.2026.09.09.03.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 03:01:26 -0700 (PDT)
Date: Wed, 9 Sep 2026 03:01:22 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>, 
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
Subject: [PATCH v2 10/26] mm/fbatch: remove several uses of
 mlock_drain_local()
In-Reply-To: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
Message-ID: <9633684f-e5c4-d92b-8295-5cccaa18fc36@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: w8yuzizz6h4qmirqjrngswt347zfboxh
X-Rspam-User: 
X-Rspamd-Queue-Id: 7C746A0006
X-Rspamd-Server: rspam03
X-HE-Tag: 1788948090-230561
X-HE-Meta: U2FsdGVkX18ULph35MWX/MmhIZTsxFhVPjE+cOQrcKU7xI/zysLJVchnlxLN5bs/4WKA8Do8rYLpl72wAP4LeHhe9zo3yjIe8VZkXmOol3SNfihNvIAa8Tgj3Q4gOZU8R/iyXHBiXySkg2wEVkhafkNkE/vxNljqT0w2bxV+o1CQt+F7AKzipAfIr/peZEcg5+1a/NUhnOjN1t+0pBJ5vy1J6bVkykj1EJcmTcyUGUxoiV5fWJsjRmKs3OE2i5yO/3LGwKdThiIMB1IN4v0uFl+Imc41k7U+zKE/TheUyZ2h2nWwy5abXFktlpA5aUaaZRZE8fUrtqvf3WUqmr6qeKuh/M69bOqbkZGnIPNe6fYLeFU/F7xMkGzt1HU2Vf9AOR/nVxVka92RyA6dLu7ck4u7r0jElqOu7ZD/8jrHjq5qPya27F1w2NOc/1X6ywrcLa0EEdG6rqMC1+SYaIeajyBj1EOeITgLQFlh0ZvDHj5QNW3Hf3ViLwM7a8NrnY/7RmQ0cUKQWnznY1e4VUJ6sTofMSwNwu6jHks0jQQ5x4QQYz1fjx8+cuKklnLTT/eZr8myxm+QlwNY6b46Q0dIoqX2XL97lu/FSrlUklzRbW9CejxwYKDY2wZTXyYOGY1GSG7uzbN3nfVEZMzx1KBsaWedb1MjFePY3+ZyPRXWyR7ZSYKpstNiV5cZGuq+UUCamxvjtsqUrXvSLgKPAMDaBhYsPmAXCyVVQV6QDo7U8aLzIhQUnBfQZpyNJiDLZdbJgoNGL8PDT8RYMnU4K6xLfQpuVx8bCklufxjdg/furmRf5lfQWO/lzijPfhUcXg59BS7vgUbq8ZCRfJRedqLGU2isphYHNMQPpumSAvqp9PKndCMDucO7kQQoeDFQQR9NrbdPYje4DiElgva/pq+Qt0C8LYM88arpVdQQlnrnVkNzRwvNuTGurHrCNKZCVE+VBoKS0+QRrPnBxyYznC1
 1ROCYDy7
 dtQaZa31KFq8oZCaOFI4nHLTskUzEO000Dm7+BLYPW/KesVJOGda044GZc3ufrWcEvT3jExCMujuUrTjYUT1AA/rEcrXKhekRNPw8g4YRxewpOVumEEuKAD+0nUOmvm9wJGzZr/8hiiCqKyHcKIP94nsPAQUqkmqsPLvCKbUYSH/IHuHQUIVf/nY3FgJ0GU5revrGmYmi82++GNaNzyzCRq4qcjAGsf2tCZldzknv3zC9O2u5B+OBx/tdqkmwQrMNa9Fq0CnMUKJW4LNrl0UBrFnXWiz5ddu2Pv0wS7vLk2c3QoxNUEsDL8cTcRacNvIz5JDUCmYynQy7n6HtZbkRwSErvn2CBINCY6Czw3gOUskWTcV5Z/IDjwugc18ye9+70r0wbUzvk3NqvYa91j2f07gIGzx8ONpA8i0PVnXo4KgsaNuNoxm8xYovHo+xHyZ2MfSFGvGyMBZKmsQ7XJy77GG4Dob8RBJN2R9q
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
index d53e5443b802..3628b5bd1359 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3570,8 +3570,6 @@ static bool __discard_anon_folio_pmd_locked(struct vm_area_struct *vma,
 	folio_remove_rmap_pmd(folio, pmd_page(orig_pmd), vma);
 	zap_deposited_table(mm, pmdp);
 	add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
-	if (vma->vm_flags & VM_LOCKED)
-		mlock_drain_local();
 	folio_put(folio);
 
 	return true;
diff --git a/mm/migrate.c b/mm/migrate.c
index 15b45832bcfa..1939d6ed19c9 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -447,8 +447,6 @@ static bool remove_migration_pte(struct folio *folio,
 				folio_add_file_rmap_pte(folio, new, vma);
 			set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
 		}
-		if (READ_ONCE(vma->vm_flags) & VM_LOCKED)
-			mlock_drain_local();
 
 		trace_remove_migration_pte(pvmw.address, pte_val(pte),
 					   compound_order(new));
diff --git a/mm/rmap.c b/mm/rmap.c
index d1819fd69938..1ee42d60d77d 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2396,8 +2396,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		}
 finish_unmap:
 		folio_remove_rmap_ptes(folio, page, nr_pages, vma);
-		if (vma->vm_flags & VM_LOCKED)
-			mlock_drain_local();
 		folio_put_refs(folio, nr_pages);
 
 		/*
@@ -2771,8 +2769,6 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			hugetlb_remove_rmap(folio);
 		else
 			folio_remove_rmap_pte(folio, subpage, vma);
-		if (vma->vm_flags & VM_LOCKED)
-			mlock_drain_local();
 		folio_put(folio);
 	}
 
-- 
2.51.0


