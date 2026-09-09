Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED5FAC79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:35:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C65856B0095; Wed,  9 Sep 2026 06:35:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C166F6B009B; Wed,  9 Sep 2026 06:35:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B06C86B009D; Wed,  9 Sep 2026 06:35:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 77A326B0095
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:35:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 45BF71A018B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:35:52 +0000 (UTC)
X-FDA: 85193868144.29.83303C4
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf27.hostedemail.com (Postfix) with ESMTP id 94F6340007
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:35:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AmcrClNG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of hughd@google.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788950150;
	b=S9BJr+r/LnnWIzRX0wDmnIO+S0KnuxGRKrbdP85APKhecLkBiGjRT9HgaAkSk5ddnm3qds
	Uu22ieVBtl9AHS3qPkGypkGXIIUsg+pdBXE3K9V01nHWBBuY7xIMhRBPdG3/rP4qTMM3kz
	ljP/3k+yklPDEHNzwyNiHxD2Lndm+z0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AmcrClNG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of hughd@google.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788950150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=01Cz/m/rw5yJ2Ele+bEMQyVaRjGaQszVRRuNtZjuAys=;
	b=aAK7ZLOE1VlIVqPG2mKsmvtzJSsZwbpXmBTJNu1LlQxFSn6YZt1Zr+xgTIufWyX3mLy8eA
	EgMYPIyfBq4d1lRvjsxsXch/QrJWFWqqwd7idkqISLxAWUpsIFQdK6vKoJjYY8TMO/pQhz
	QHJLl6r9dIXhoJz+hUvGarsAn5elv9U=
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-861a2ae9c51so67081537b3.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 03:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788950150; x=1789554950; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=01Cz/m/rw5yJ2Ele+bEMQyVaRjGaQszVRRuNtZjuAys=;
        b=AmcrClNGeVY4hIplGTpYfnmZDLmXrIgC/yBH3YbXN9/zWvYieitKaLcIPa/PJKJn1R
         0mwzeBpObXanUanZOGoC25qWeJx7JTxfu1NZtErC5NFplbWKN9fIh7VDXrlSyi6kLgmA
         8ICPfdA51wOqV1K4Y71+mMQFuQB2B/znchJIkHoPjkTYSyZEKFRjukDOu6ScFbhrcDmC
         u/8/Yk2MAVt6VAis82nxnZ3fJH3z5CsRf1UFwDib87Ungw2dGdvIxxlfVm+kMHdIewo2
         2zbefD3gX5+QDwjVUI9HX9nJIiNHVbplp5tg3i4HBrtCRBad5UQf0FF8O2KBEUVZMLo/
         EjSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788950150; x=1789554950;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=01Cz/m/rw5yJ2Ele+bEMQyVaRjGaQszVRRuNtZjuAys=;
        b=ek2W8FXH9XZcQJ264gdAK4x47HrlgGK+8clAqhas6hkcLLWGX5ADs4ZMrWBM3T3UfZ
         1EhIVRqVEfwjT58k4TtloYuxnOptVkSMl2w0DyffJsyesX6UgNY7aZIz9hqM8nJ0vouY
         FyLg7pFG4JYDP1MOxn9+18RYg6YfRuzRFHf6V1TV6Al+jxkek+YIVaSVX02b8apk6auK
         oJAoElg3Wg7V3Zulr7FbTqLFtHsXNt3q4GVe3kniKPJ7vDsE/G5j9QYz4GvgwwMMMfJy
         ev2JMGEB9YcUB4Obuten+oA6ZeZaZf5mh/qT0BzT4Pl9+ymCV48iNvn41X/fx8i/Vy9D
         rGCw==
X-Forwarded-Encrypted: i=1; AKwUvByDKo8O2rrPUHbb+QKFF+8KO/R5SLpHwmc2GpcT3snUHtsf7lafrTR3Di9Ln8CYSgt/69UcdwA8CA==@kvack.org
X-Gm-Message-State: AFuF++ktd+uhA8WlqhZEUVA9s02LUCc6LnvlEKnD6kcPO98Fahob6yc7
	8S9WMoiKbadNZpjmbnfQym2DiaDaOUY/a2JjacDhWQFskW3dYig1FVLm11mkkbilAg==
X-Gm-Gg: AYBFou01MYXNLsAV0QC+bMwWWL6M+WQesIrJNSpTWXfiOZhZatG7GYvc3hOn+Runz1B
	9+U3xd8gvy5Kd13gB3KGhGgIN/pJQGEfjtfmRyZdpt74rImTHQJ2QzaBdAxHINS+P4gG0nupxRy
	fu60U6V1aRfarroeZWqoi0Yu3pga+yKGZZ0cS7OuypsA9VszmZGo0pLBZNUyRglPt4HUfANWL/t
	jWqe5qBTcOnunK4rpWfse54/hHTqnyGcL67MRb55ED+brn09jC2ikEGVa85ySoAlQZ2VXJkLBaw
	UjohhvELQIHGPdo+1xUbUBnR3YEi1rTTdVc7MKlYWv7BBkvRMYzMWHZXD7q15QL3M7K3E/36lhd
	292YTWNGST9jvg25yGgCp8tO8LX1sm6l8X8GxmgLaTUBz/Rdv8hj68t1ZcnuAv5VJl1BJu+aiE1
	fG7yg+XoBrLJw5EslY3DpxGUWUNl8ZlLWT43N1Qfj9P6IDJoII5T7JN7WPzsB5p8Vee4/Py7fQH
	XMbbDwPL8HdAsGgfVqpvs6xM0SMxJdrgkHRd4ZldoONYWQGBzOOdlOnrjxj5v4I
X-Received: by 2002:a05:690c:c50d:b0:873:ea3b:6c08 with SMTP id 00721157ae682-873ea3b77c9mr91382717b3.1.1788950148979;
        Wed, 09 Sep 2026 03:35:48 -0700 (PDT)
Received: from [192.168.1.242] (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-87143ca6ddesm107684497b3.2.2026.09.09.03.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 03:35:47 -0700 (PDT)
Date: Wed, 9 Sep 2026 03:35:42 -0700 (PDT)
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
Subject: [PATCH v2 25/26] mm/fbatch: move lru_add_drain_all() declaration to
 mm/internal.h
In-Reply-To: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
Message-ID: <26b1d94a-497a-fd6d-e700-342ccb65c045@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 94F6340007
X-Stat-Signature: tzatkxt8uf9w7kjf9s9cbmqpoj9zp7bf
X-HE-Tag: 1788950150-721641
X-HE-Meta: U2FsdGVkX19aH/SqNiNxaLfb1OpMdmVgLLfDBylpZcOHQn1PeifZ6z+OCmCfEMdD4MM0+hxRJHvWM4dRvqOQ57BTv5mst8pRfLzunFFI1rSjhg1tcrN8BDkQ/Wxivv2OwrsrDzpzirXReF4mKU8sn8zuyBTAFL0dLcSb3pnJPsQaag4eAsLubUvnYLUVDUWVWV+9U2kD0v6Ob8+/OcxXv5BTsVxsZci6DdXejaFSfdER+FZeP21vO/Z4K17gjAbGHaiWT7Lbnv8j47ptCK5U2Y+PD/9wc5NEAl353u8FKmCPdRDq38+p2Hr99ibQFO1yyrlbPFPeccirrlesmCrlo65QUbkKNNIOl7f6eGqd1F9NasY2IRASdFCIFMu2uSv+Ptk2fQHin06F0iABy7NkUXaW4kssJWBMgscnUiMD0wEpRqRIW4DHafTkw/T2GQl87MI0FzPxKO1qwv600gp/eGVX86vlF3PbGMflNkujqTjdYLZ29tuH+BNPYovA/l6pky0g0hCrNMFqiVuGNYtRGBTaMH10U1jw0KESnHOIharWO8GLUSCYJKUXRNpj8KhyqhWU6vL1cebpfM9mhjMqW7kCr1h/0YCiiFR60OH/ggrlV2KhUoX0mv4UwcF0DIjQ/RVEnAKikWUw67ZKslgL1XJX8MUgnDO0G3xdezFnCn6hU35RTO8VL3rtWoLEsgIp4dIjquaeB+1UxbIqvNUA9VIxKrpn3L1Y4vfpcjEuxtkcfflyUcVZo6/ohvnzQGWRLyxfKWXyZl7saPfXnGWNUqZFy9vxisbrGwnoJkbNnQuv9fEr/nco2dGUgLlgIxRUOHbqlv7vDWYaH1UcOfw2Xbott8d0FAqPKYyPHcoHSJW/dROaPUs3epkSUisC7/SB+HuO3zAh8HqO7biyynW2ZoWWRVYg2ommquEZn5FGz476bJgEruuFiZr2CVBX/4bV58TRBI8T5m/4xBw/pAQ
 tw5oqYjA
 iC2W7tGN17w2oSviOnLByXQB7KgDj4PFPpE+erqwCf2keOqv0L67n+VVeOnPNDKsIPwvwUpbh3uZKwViQDxtlZp3L12M6LjWab8T19IsUH9YAHwPr8gxuAyQ8YckC7W2ECQ+axonchaLN0MFQNnuBKB0icQXvtqi2XFLvso8+pXicmIhpVasarYaZjYdRzABdkJBggFTQPrtzQ/Ok0fC3FHKW2rCLKYL/R/10zH5mu1GBi22KtYBG7zZfQDrlYj5BPk4hEadsJjppxVD3GslQWinHGK6PVODXTINaBgb/6+ciHj+fQwvInUQEjA+Jbh+ex6Px0vVMDB0v7NoXyWu4mkAq4g4JUMGrm/xbbOVNWAHoO2EwJniTjNn39ZACI3wrXuVQ2KF025gVUmWGxTU2zprjjq+yToWYOijS6tL9PjQjBeaTzafddIysu08heFomioviy/+Ar5deDyutjBMA9sbVtO4o8LuU6Uqm
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
index 423d9b669149..dfa6314c0cee 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -300,7 +300,6 @@ static inline void folio_add_lru(struct folio *folio)
 	__folio_add_lru(folio, false);
 }
 void folio_mark_accessed(struct folio *folio);
-void lru_add_drain_all(void);
 
 enum lru_cache_drained {
 	LRU_CACHE_NOT_DRAINED,
diff --git a/mm/internal.h b/mm/internal.h
index d9930b752153..f28fd310455c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -54,6 +54,7 @@ static inline bool folio_may_be_lru_cached(const struct folio *folio)
 }
 
 void lru_add_drain(void);
+void lru_add_drain_all(void);
 void lru_add_drain_cpu(int cpu);
 void lru_add_drain_cpu_zone(struct zone *zone);
 void folio_deactivate(struct folio *folio);
-- 
2.51.0


