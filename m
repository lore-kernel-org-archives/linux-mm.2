Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80402C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 13:52:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8835B6B009F; Mon, 24 Aug 2026 09:52:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 833396B00A1; Mon, 24 Aug 2026 09:52:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 721DB6B00A2; Mon, 24 Aug 2026 09:52:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44DD56B009F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:52:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D6E021C01C3
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:52:50 +0000 (UTC)
X-FDA: 85136303700.03.F6AA53E
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2847BC0008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:52:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=b7FRBFh3;
	spf=pass (imf10.hostedemail.com: domain of hughd@google.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787579569;
	b=BdJQcx+PKAN/yAPRS6xK/gtjkQ4uvpJ3pF2Aw8DjH93Dv/YMaIrlHqVIMsXJK0W8dmzDPY
	SwX3K1ZakYmmgY2XM+ohYBRGLq8TM85msI6i2yqcZiMRqhV4nYnCCyD5NtPnLqC1eIAzES
	KKqbZ+SgRrhYBJ6GtW/M6uHnT5+Pxj4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=b7FRBFh3;
	spf=pass (imf10.hostedemail.com: domain of hughd@google.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787579569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n94V7wbjjjBLybhmkw6p8j8STOH0bCJCKxuuQhNVBOI=;
	b=VN+SWTPJs5G8FbLr4sr48S0mpmHKvkIluB3a0catRfYbvJYNSObb3IZ44aZYyOXy+BFIHF
	uQ2UlUjFwX55Jm8q4zULPQZzZXzk551ZiHzng+H1KJUwhlCromLqm9vZ94L/olR8vzer2O
	zY3zbnM2qdlHjrJGMND2gnNDzKtzVuU=
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-66c744a00edso2118741d50.2
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 06:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787579568; x=1788184368; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n94V7wbjjjBLybhmkw6p8j8STOH0bCJCKxuuQhNVBOI=;
        b=b7FRBFh3HoJKJRPG7A7uZCeJAmaYkgZTUwCbRZ8mSshynJxISGwwMsMYT7IL5SYp/n
         uSGm5r5pwKyOBBj1PBnnasLRdPc+l5U2xYq/Cux2iXfeQfZ/NSVcahf73AmMOjzvvE2H
         fUIyEiyQZLVnEGBABT7uEqK4+/pZeb9+LsAnN33wjzzZNRfS1D14HrMMgr+FPLQVt/dG
         MgMYs8Wu6NKhk5Mm85aU2mJqpImccAmbkfU0557hvPUejJCzMN390RuCvjtm37AFoX1+
         fg8+71wqNy79zeWqtrd8XLYxSIWu8bSkDqyRQYpN8cuR4t7VsaBaQ62KyG8/58+OK4A2
         PXvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787579568; x=1788184368;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n94V7wbjjjBLybhmkw6p8j8STOH0bCJCKxuuQhNVBOI=;
        b=CzYD4gV46ZWV58pevwdO0V5+/W69hAn5LTqu1ecClNdJ0YGMFd4nNBuUSdaS/sQGhU
         fZxs85eyqqi1fYI6pxPoaO5VRmxBogZ0Rm2X2wJK1SiN37VXVqTkOAm8xKBCjbb09cm1
         WA2ldpKsmv62dAFPYAYIXMfgn18WFyfXT2me3drbq0QQXRIYJr/TKzYubHYO2J3+kgdS
         Rofpr8ofVT6U8y4QTDbKpp6XiPZk0LRW62QVprrCrPPHs1IE54y8LDA7En6/lOs578WZ
         L88N1n7CpjvxlCjoy5brHv02U/KEHZJuYBTAa2JKAyLX5tSbRvI4bzkXmXZEAHVJcqTE
         o0jQ==
X-Forwarded-Encrypted: i=1; AHgh+RoQGidnLb+UZ8T7TjcsMhIGLF9MqjLHltm1gfVqNnt2gIrf6+7vclI5v0i59f/b4aDlTk8i1EVAkA==@kvack.org
X-Gm-Message-State: AFuF++lBryPzBnz4HJsGxUKvgXyrziHHJsgtA2jxOkJovhqbTB/eZ9jh
	+gzrTWb8LSpxM9kXbCNTGUwdyB79JrF2aMkqSq2T+NHTdNvguVCP9Ph25PrKm/MjZw==
X-Gm-Gg: AR+sD11TarHY+Ot8iHuk7rcUuQ91jHTtW4lL1RRFNtTZm2VzxC2iyFiZjZtZngm4WEe
	LF9IpYWiOzb0QmIGwkAfF2pDQbFWPoOxx2Y9dle1uhJEysbSJjWE3qijYFZoE203YlXN4YnSpyo
	YPhHqj/MguzhIgpS7oB63B0/RXGTwawZWvynHPNAuyqnbADiMb/w1NURDqefWbFzvmhNRRGRik6
	z+FSU/BQO+u4T8JeJVLRsogsDKlAUd8G3gUs31lGINDO9JiS4TNXTLaFEv8QVXik9q3k7csPSvX
	rjQRId0CtxE36T721XfGVAXo9wU8A5btvI0B0CHxFCbKC9s6fU3k4/sjQuIklmWwJ8lEmV7D/gQ
	jf1p1WauLfdgFRwmvl4AZWEe5YedULRJ0hYAqbAHJtIq482VJceBwrlzaSjTP7/t3jYDTUz0vz5
	G/bw5aYBK3L9QUbWhR8Uo51HMlUaXEGoXjMqpSaEmFjvIg4K8I+BDYJx4Ud6zfsHSbwg6pM7u2Y
	2ClA3o5+ZNRJKQ6qMSNjevoWbehfdG7YKiGhWnQh8vBdSB+m9Wf7zZRKKpjX8d6mEu26Wg=
X-Received: by 2002:a53:cdcf:0:b0:667:b314:aea4 with SMTP id 956f58d0204a3-66ce4a56db4mr7162361d50.16.1787579567501;
        Mon, 24 Aug 2026 06:52:47 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66cf4624f47sm3724257d50.4.2026.08.24.06.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 06:52:46 -0700 (PDT)
Date: Mon, 24 Aug 2026 06:52:41 -0700 (PDT)
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
Subject: [PATCH 01/25] mm/fbatch: remove !CONFIG_SMP special case of
 folio_activate()
In-Reply-To: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
Message-ID: <3f18ab7d-c12a-d2a3-4d3e-f9908f94f27d@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 2847BC0008
X-Rspam-User: 
X-Stat-Signature: 9b6tneky199977p7h1qtcfzgprx6frpu
X-Rspamd-Server: rspam06
X-HE-Tag: 1787579569-151194
X-HE-Meta: U2FsdGVkX1+41+oVB5bHTrjwfswaA4Fu3m5M+3AstwxBA0EoOELDJtik3g/pD5Z276vP2rSMugUtoFzx2/dbEVxQlg411y7I9kL9TWiDQkEBLkLI1XI02u29Wq/oj6nkERSPnTfYWX8SmBlNlGVdpjZM4ea3eL1aE1L5xjRfNqKhn9vDvL/qAWxnfhrtctbG7ti8CZTDH/ini5e8ungqtrP6xeDKUfCRG4aHf2x4v5+BbmL8tIAGnFyPbet/VOgxk0zDQwALCQSjpD6vcxOlQTm4ENUj33q8lqPTohTjl1aJ9xkMcbnXYMDjHqfifMGQ/kV1dWNkU90xYUdjddvOAUZsZCOoTrFMbxqZX2utCBWDR8mxZ/QqVBexVzGnrB0Cef8mYXLvsa5IhNLiUWMyKDL0oWOpl7YON9GW5I8dCP1ZXqXBUetuJeyrXK8bksChM2v3fPlHMzpMDqGQT7w4NHKfO1ftbXa+XRy3TIUjqYd55hzKfAKLK6d9JW0Klc/xzCIYSUzYzoWW8qmn46+2iM8HSk3Tm7vBsoWQdR5/+NleHLPHRX6lc2YbNahyTX3TqTQmQY1vbE8dhufoaVNYuHM1Xzbp8ZHiL9JoHHhXYh1VQaqiag85f0snRhPVAHZfGhI/xm7iud95aUg4M/pr2dUfqdErJW5NnSsN9F6iCOyMM1Zra3ISTDh+Ux89K47iEV0aEXmDzCHY7ktkLmE8GWr869M+wU+oOnq7mwZ6mVQQnnf2CIjn5qphfmD1kuNVcg/IVatK9L1GfBt7WAyg04RpcuWTBkWfjVrWVaUe2k0doxhFpMoN3f53u+FhA5c/AF63A861FM+hbQObdcrFGsDT7CwzQFJJ9bFYwf6C2sG5iUnL/0x0GspIf/tCrDYHUo0mks6ReNLLq1IzuamTF879VLGcpuzuY5kKiY1hu8nOOEVGsj89JTDndJOoBlIwGU0AjkcuLoJpdlzk5A2
 C8XHy3UQ
 sij0ONlCVTEdtsnchr5AvE3vvlmX3Bx/IosH/vCCEL69nZdVYRT6YAMEuEZbwal5144wg4bplIWGP3q3eCp2ZaUohz4rjwtkkuO9j/F4EjUeM+dGIqdT/akqrH8AaAJdJziUBzacEyGJR8Wjnf4u6J0+Jj5lAIkVgzVd3Ybz+j10C0KqsXY5Nj2u67PPw0zwea3p66tSMnNuwE3uBi3CcU4M/zfZqN5GJZrrRPgTM5Q8H0/Hx+yd92dIU8D3J1FXrNiqAqphQ/qLaBvRHIbgxuq66gToxAIFUpIlXboNv5jsgcx+AeHS5xeK/1RECf+uLFnuMPcjbdDGZoxES1NdwMVzvHrEIpZp+pos8ygzJETeWB4RvSmRDCsL14/B/gAak74B38w7mFIXFRmt8mqEq92DVQsQhwkYK17IcEFzwBiEMil+xOPRy+kDl3Ww4pddaXn7hsiHiEvZKs5Fwjmxd/QbVDlvN+z+GT9nRGibZSUa7bDDjbr8hr95TUb/RnWxKn/QiexhWU51zXunHxCtUL9pl1+AmY35aWP+M3l6E+zYaJbmTq8ypz60X5GKDvjkJUN8EawrO9bcUKKojJ4W8bz2Z0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

3.0 commit eb709b0d062e ("mm: batch activate_page() to reduce lock
contention") brought in an ifdef CONFIG_SMP around activate batching:
https://lore.kernel.org/linux-mm/20100805140755.501af8a7.akpm@linux-foundation.org/
shows a sensitivity to bloat that day, not any incompatibility with UP.

No other batching here has a UP alternative, and it's a bit confusing:
simplify mm/folio.c a little by removing it now.

Certainly we can reduce UP bloat (and/or 32-bit bloat) by, say, lowering
FOLIO_BATCH_SIZE from 31: traditionally 16, 14, 15, then raised to 31 by
6.9 commit 9cecde80aae0 ("mm: increase folio batch size"); or by giving
just the static per-cpu folio batches a type of their own with a smaller
array size on UP (1? or a little batching worthwhile even on UP?). But
not right now, it's orthogonal to this series.

And I suspect that the old ifdef led to lru_activate being placed last,
whereas it's usually the second most popular fbatch: move it there, to
match cpu_needs_drain() comment "Check these in order of likelihood that
they're not zero".

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/folio.c | 40 ++++++----------------------------------
 1 file changed, 6 insertions(+), 34 deletions(-)

diff --git a/mm/folio.c b/mm/folio.c
index d2937600cf72..62b96c9ce19e 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -47,12 +47,10 @@ struct cpu_fbatches {
 	 */
 	local_lock_t lock;
 	struct folio_batch lru_add;
+	struct folio_batch lru_activate;
 	struct folio_batch lru_deactivate_file;
 	struct folio_batch lru_deactivate;
 	struct folio_batch lru_lazyfree;
-#ifdef CONFIG_SMP
-	struct folio_batch lru_activate;
-#endif
 	/* Protecting the following batches which require disabling interrupts */
 	local_lock_t lock_irq;
 	struct folio_batch lru_move_tail;
@@ -349,15 +347,6 @@ static void lru_activate(struct lruvec *lruvec, struct folio *folio)
 	count_memcg_events(lruvec_memcg(lruvec), PGACTIVATE, nr_pages);
 }
 
-#ifdef CONFIG_SMP
-static void folio_activate_drain(int cpu)
-{
-	struct folio_batch *fbatch = &per_cpu(cpu_fbatches.lru_activate, cpu);
-
-	if (folio_batch_count(fbatch))
-		folio_batch_move_lru(fbatch, lru_activate);
-}
-
 void folio_activate(struct folio *folio)
 {
 	if (folio_test_active(folio) || folio_test_unevictable(folio) ||
@@ -367,25 +356,6 @@ void folio_activate(struct folio *folio)
 	folio_batch_add_and_move(folio, lru_activate);
 }
 
-#else
-static inline void folio_activate_drain(int cpu)
-{
-}
-
-void folio_activate(struct folio *folio)
-{
-	struct lruvec *lruvec;
-
-	if (!folio_test_clear_lru(folio))
-		return;
-
-	lruvec = folio_lruvec_lock_irq(folio);
-	lru_activate(lruvec, folio);
-	lruvec_unlock_irq(lruvec);
-	folio_set_lru(folio);
-}
-#endif
-
 static void __lru_cache_activate_folio(struct folio *folio)
 {
 	struct folio_batch *fbatch;
@@ -694,6 +664,10 @@ void lru_add_drain_cpu(int cpu)
 		trace_mm_lru_add_drain_tp(cpu, nr_folios);
 	}
 
+	fbatch = &fbatches->lru_activate;
+	if (folio_batch_count(fbatch))
+		folio_batch_move_lru(fbatch, lru_activate);
+
 	fbatch = &fbatches->lru_move_tail;
 	/* Disabling interrupts below acts as a compiler barrier. */
 	if (data_race(folio_batch_count(fbatch))) {
@@ -716,8 +690,6 @@ void lru_add_drain_cpu(int cpu)
 	fbatch = &fbatches->lru_lazyfree;
 	if (folio_batch_count(fbatch))
 		folio_batch_move_lru(fbatch, lru_lazyfree);
-
-	folio_activate_drain(cpu);
 }
 
 /**
@@ -825,11 +797,11 @@ static bool cpu_needs_drain(unsigned int cpu)
 
 	/* Check these in order of likelihood that they're not zero */
 	return data_race(folio_batch_count(&fbatches->lru_add) ||
+			 folio_batch_count(&fbatches->lru_activate) ||
 			 folio_batch_count(&fbatches->lru_move_tail) ||
 			 folio_batch_count(&fbatches->lru_deactivate_file) ||
 			 folio_batch_count(&fbatches->lru_deactivate) ||
 			 folio_batch_count(&fbatches->lru_lazyfree) ||
-			 folio_batch_count(&fbatches->lru_activate) ||
 			 need_mlock_drain(cpu)) ||
 		has_bh_in_lru(cpu, NULL);
 }
-- 
2.51.0


