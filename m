Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 675A8C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:51:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 610B36B0092; Mon, 24 Aug 2026 10:51:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C1FC6B0099; Mon, 24 Aug 2026 10:51:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B2136B009D; Mon, 24 Aug 2026 10:51:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 23FCF6B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:51:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B1F0EA0146
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:51:22 +0000 (UTC)
X-FDA: 85136451204.15.E125344
Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	by imf27.hostedemail.com (Postfix) with ESMTP id EFDF140010
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:51:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pXbp6+Ap;
	spf=pass (imf27.hostedemail.com: domain of hughd@google.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787583081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oBC/SAP50I4KxaPevcH0bVL/Jm4cuaV8N0/RCICjbNo=;
	b=xDqnou4qEahuLFJqAUBFCH/x/DjhJQnIuO4ENUy31N0nsT+KBAMgjGXbvvYa9Hojld2Psd
	oMH7CroBmHjgoo9J8MRp2aL2etv4lJPW2L37zZCRopjS3WacdAclDoyivrpHguwXK/Wh1X
	XqcTEKTSF3YJzxqrPApQvib9rj13I0M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pXbp6+Ap;
	spf=pass (imf27.hostedemail.com: domain of hughd@google.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787583081;
	b=fu1OFhhnAleDonPUyiDBOmYsCBhhGW3dezdw7BQZkXiPw0WcysMGToWlHmZ/XuN8eiQHc+
	1plGMLzEhJdgJdWR0QaIEDcrtZoNp6kU15xIeWdC/KXtxO8knxPS8jLTPrpEsTUxdf4Oip
	J7nunwPKXu2IxuD46tZ5KSLMCfflCIQ=
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-66c67a73eb7so6826421d50.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787583080; x=1788187880; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oBC/SAP50I4KxaPevcH0bVL/Jm4cuaV8N0/RCICjbNo=;
        b=pXbp6+Ap87+RF0LUsWY1ywsPQy5HEjl9DdTsY/0VNO4jYhnNWYukHS74H8iTBmGI8T
         933SnFKjfQNC52dSnkzskO+cqqccR6pICkEfZDy9JuJlLkUaMG+JYSbh0s7xkweoe8S9
         L2cZreNcWVYQhKfk0IBoe8HiKwrl0c/gViejeqnTbLrPd/Wr+XKlVUY+PElbKOlKvlL5
         vlCetfegF0dP2eUm/uJp81QIx2QlLSlz3BLJwHy4j3aTYOLpX3Ky3pCmB9FHZq06fNGu
         8KDJvzTIQOYVSKZLqNm73MkvT3T01SXnq7vcwvW/9EkAw0VeOn3SczLUsOOIF6jGjiCR
         lpCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787583080; x=1788187880;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oBC/SAP50I4KxaPevcH0bVL/Jm4cuaV8N0/RCICjbNo=;
        b=ljwU33PhemoQGmVI4VOxHpD+kgx0wzkoLlazuD2HzRsycqFjzYhrOVDsKA1gnhcakO
         NCi1/Yh//FMj5UTfZdC2NEZEt2+wxExd3ed0sA6DGBu6GP7NUe3k1KK1fYb2KFh7f0n6
         sHYF6/LYrlmL9DlIt6401EjnsqCJz3/I4QChm+iel5bTa+X41V6qlmG8uy0OK4pwrgVZ
         gD3PUTDtM1GJI1tqO4ETGewN2SBfXBP0OFZXCmmoEHqpBPf7hBsl06Hsxdu4y5NP34ar
         9rI0asV4ZBDDU9E1h/9xgYp1Cl3KVSbcthUwty+Kcue2sNf5trVOh6hk404B/excxOfr
         U6Vw==
X-Forwarded-Encrypted: i=1; AHgh+RrfPZ2l4aT+AAwFSQ3CwdPbEzs2sXgQGu5P9vlM/CVJ1sRKiCIA4fTTpmCwZ+6++zQcrGhM3WDltg==@kvack.org
X-Gm-Message-State: AFuF++kK0of9ZpZsqaBW/+LnFgE0x60W5Kl4kL7xUJ0hP1Q9NxbGb+0S
	Lrw+snLnVWNpIzXpHs0yo6wIZ43rlcyuy2OtgpSfZAVquVjnwg1XQIWEwNP/2uWf3A==
X-Gm-Gg: AR+sD1397Fi3o5z3pqdHtfccM5t+G2yglshywCRwDl0wDxUQs/QOfAOUqMtjbuHETQT
	WVk6DvABXC60ALCFUVAGaabEtLcbmuczLJDcRe0m0LWG1OsrKJqoZaELjShNPSMUbwRbWWZUcq3
	Cf62Y8RMGEGuHvpmdTbiblGtRzmvRNLOrI5G26cs5ZIVmwwikJOWl8I8vwJHtUZezmJlXOg9JmM
	SE+nPdjRdZgfXaisZkUeOpBvQg21F8EICXUNyyGnowLC/fG7vANaVHQ75znQJCtFZ5HgpFUQeaH
	rHgNQIZYC9Ly9/zJqmU7rNmTimVN6NF2Eg8Nr/ZyO/ybT6lxDkPnaz2kCA7hFDWWk3r7OCTB7Pl
	wis28mvyC61wG8+Nnv6XM6cI2mQwseE2N4IOJBH9m95GGE2MTd/FrPpxamhl4uSyqAYExUez/l8
	Yyei0iuoM55SKMIk7eU/s4qtk95hf7YXgPl2+lT9VGA4QK5V8IgOvGcl/pwP+UwSjritxng87v0
	ZF+M3yKoLtTPtXuRtth1r08cmpn3l8FZ2ApMM6mwO3aytwTdxjQKn804yA=
X-Received: by 2002:a05:690e:4843:b0:66c:e378:bd2 with SMTP id 956f58d0204a3-66ce3780eecmr7793232d50.22.1787583079315;
        Mon, 24 Aug 2026 07:51:19 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-84cac01868dsm34817937b3.42.2026.08.24.07.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:51:18 -0700 (PDT)
Date: Mon, 24 Aug 2026 07:51:12 -0700 (PDT)
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
Subject: [PATCH 25/25] mm/fbatch: move lru_add_drain_all() declaration to
 mm/internal.h
In-Reply-To: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
Message-ID: <552d4644-995b-e605-175d-3268b67adb66@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EFDF140010
X-Stat-Signature: 8dc1qcwzuq6zg5zn1huok3otjbpt68ag
X-Rspam-User: 
X-HE-Tag: 1787583080-457208
X-HE-Meta: U2FsdGVkX1/JGAxEuItOgH0WGKb4C15bD5nkyTfaOwLwLIFGufMeGBC9l/N25fCxJ5BwY/6la2hGs7YeBtdtV5TnW75rkrMJM1wAkC8dyxrBdcnvurlJpawDZd0aCHyK+JWXMxdjv26YrKJVRxRw38etkqViTGk2AZ4Pd2SojMhKMRuRJ2jVMp22XsfGLjPTLS5IoVoIB4k7qvVwqCaRkAk4606WFppLxx3kTl1IFA56H6C2Ejk+32e5VoPTJ+IzV2se3YlcwRDLwB81fCcuf7/KusIDeBM366eQY0KvE4TUwMh8rjbuGzEZVvZboXq0fkdGZL8BFgpB8teu/3cGuYC6vhOPz8R5PA10I245lu56pTKineIRqpHZrFSas2W38Plm1lWFPbyzjaLw8/5JGj9uIoZ2QijqxtLQXwRlvMeBCF25KW//I2o+Luyc1bIOfZ+6lvzQiYBYCIYIbkef7p/1geqw9dQ+RgIVyUij+rrzA3xS5FRBm2O5trEhrhSG3w0yc3OxyUWI01WnKFxk4X3HsK1VSmpYItsQqY/Z2W6FStizH/YkajjduvFWUitVNppgxfhK2lp1/jPUtjk7DcztcT7w/d/FxdyJg9uLU5WvgT8Xc4bNWNq0Wrz/Koi+td29xbjNU0bASox9fj9Tos7/4nWDo7x83KFUOj4LTZ9kkCS52ppFLX+jOSCijb4sZggnSESES8STzWSxp+TboYst77WD5b9UeSd6AgrRAtah2KiNTZtqKHnAHIcxMBYn5JB8/3lQfbOl/GHCOh5F06sqC6UwaC6F/D/OsJFLlTK9P1OcKFfBMc1rW85EtImpv6Gin22KjXrRtNaPwqSgdaL0long00QZof2r43on6D9LXyJZHoJ2XpbzwukNwcokwiiColtAafDkGF8afWZMb0iUgXlM/nXH/sXZ3fCg1OVMUTVKvUj+0D3/2nMvkdZ6Nk0AQn9THL70MVGzHz8
 UgjrKXFO
 ZEhgjSGI3GlSjtZmhviVdu4+K6970IZTVlP2ghqKksOdU2t086/6OhYycVxZb74ESKzhlK5hI7QU+BB5W84mosngsih/7cCuZRhBzrABicnCeCuFlCl27/+xYOtVscryQw7xHAnfWfIthtFz6oYWT/bCatK3Xub39s+bv0sSe/WZVSQYZ12iXa2zvAQLx3wWAbLMbTMfMO+3NxX5cP+POz/ykjUIO1rO9dAVH1gKFCLxpEkAQpkCJOkRPPn/zwXB89tStY8XSo3FOx5opiPONg+ktJQtLPdlm25twEF3dp0WG3osj0PsVqbD7jUmpvyt5znu8EpVv5VYfs5q1WvxaWJ3C1smsHUMNbg+vyVZfpV8P+EBLBljNb3gCySgOnmLd0xO8yvW1cdqws9F/cikWXzUVAxZclbLjAX9RaNI2JbFTR7CvGMvSc5A1UOohe6s0VJG9fpv4qs0WcEtR4Cb8/r+JIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Only mm now uses lru_add_drain_all(), in forced reclaim and in memory
hotremoval: help to keep it that way by moving its declaration alongside
that of lru_add_drain() in mm/internal.h.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 include/linux/swap.h | 1 -
 mm/internal.h        | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index ddfd9b7bb861..94b694328ee7 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -300,7 +300,6 @@ static inline void folio_add_lru(struct folio *folio)
 	__folio_add_lru(folio, false);
 }
 void folio_mark_accessed(struct folio *folio);
-void lru_add_drain_all(void);
 
 /* linux/mm/folio-compat.c */
 void mark_page_accessed(struct page *page);
diff --git a/mm/internal.h b/mm/internal.h
index 7a301c401d39..73d618254a3b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -57,6 +57,7 @@ static inline bool folio_may_be_lru_cached(struct folio *folio)
 }
 
 void lru_add_drain(void);
+void lru_add_drain_all(void);
 void lru_add_drain_cpu(int cpu);
 void lru_add_drain_cpu_zone(struct zone *zone);
 void folio_deactivate(struct folio *folio);
-- 
2.51.0


