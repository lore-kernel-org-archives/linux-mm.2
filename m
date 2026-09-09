Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53D6BC79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:27:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 689F46B008A; Wed,  9 Sep 2026 06:27:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63AA16B008C; Wed,  9 Sep 2026 06:27:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5034A6B0098; Wed,  9 Sep 2026 06:27:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 371226B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:27:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7540B12017B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:27:49 +0000 (UTC)
X-FDA: 85193847858.16.4ED89E8
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	by imf01.hostedemail.com (Postfix) with ESMTP id A9D9A40009
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:27:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=anhniXZo;
	spf=pass (imf01.hostedemail.com: domain of hughd@google.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788949667;
	b=qj9OxyX6cP36sKIgn+EQRJGKsd3nECqZmKA1v2sm2S0m/9/crGutiGCIhpG2DgS61I5+re
	whBX+97YxomsS9Pr384GDvBxQJAzieuUrK8vUspXakhrK9YeTMicNEqVlcoE2VjpbpbC3S
	1rEGQxvgXhBZGa+PFmEaBNuSQxcQBSQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=anhniXZo;
	spf=pass (imf01.hostedemail.com: domain of hughd@google.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788949667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0mZ5Gk4/1Pu5bK3S+WjW2BlP4j/qxWTHvLM7mSgUCfk=;
	b=Q8mbpvudFeRczOBc3h4zyKSHWbgRooiyOZyz21h8koJWIITCCMNe+XPBjR7IlzwagX0kP/
	J6HHELHgTEzqbN7uyM26EQOv0DRKELjFj3zaRicTDmmKYjL5hlvA1BSZ77iSNg9pGjRsve
	0ljjPKRuNVclFlu7pnIp3SrNKCo803o=
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-66fcf87897fso4336564d50.3
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 03:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788949667; x=1789554467; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0mZ5Gk4/1Pu5bK3S+WjW2BlP4j/qxWTHvLM7mSgUCfk=;
        b=anhniXZo0fY1KlGkHYAKkettXgtBIZF6I10jOIKjUGobBcwNukSIQ7kFJcAi96V8l9
         NpFWj1PFFPZ2NkdnfpKWEoOVuEpTRSBlk9vmk6Pt4ikK3fsHDn/PPsQXXANFiqxDOY1S
         Hj/UeK8fdx78ldxG1SXlN6FRHUAd2OsQBeHrsV+Lcw/Vtijkl6hHtsCC33MYr0fIFeo2
         p93SM5g4XrgQRB9aYU7Fv8Z5osF0f9UJXFYAHEDgUw41N6h8BQ/gDKWkp6D5fFCUPzv+
         Iez4Q0xKTx0bWdDA/5bGStUdtohlaWyEjFi+mQ3wxCTyKfrMQ7UYoWGhwF22MwS9hDwd
         tONQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788949667; x=1789554467;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0mZ5Gk4/1Pu5bK3S+WjW2BlP4j/qxWTHvLM7mSgUCfk=;
        b=M+IDP1XzlTdeEb6WVgHk5P5Y0Tw8BSGnt2Vnm1Kf+u9ixvXaLFTpDo5g/ST77tnFVY
         Yf6x7HsA7UI5YwX6HWcyURCiu1sdzjQUgmiQo4+lHdU48IXN6sWjOdNFuNP1LYm5buEy
         QPKvccDh+VkA9H8EeV2iFtwST5ZOzvWIZmUUq1t/8ERUCZAECjr5zt2Yblw6y6XO1Ixh
         JyA6oARXTJwSaCbfn3e8AYzwNZrMlgMM5ngC310PGxaCaxbTrD2VLD87XRVepSPLWHyq
         d8lmCzM19FDbrTJ6M//wI8Dt5DI7gpDgJVXYw7gvRJ+vq/q/tgcyfiyK/1iYTq56DgoH
         0Z6w==
X-Forwarded-Encrypted: i=1; AKwUvBwfMR4tfOa3Q9+Ric24zkHQl8f7WSF6KhKbgQkPij2vxXso3ZZV1xV8O//0cbjkUBbsig4UviMgig==@kvack.org
X-Gm-Message-State: AFuF++lC5B3Jch4MAJP6oFr85CQri3O+OW7M1F4V4fNoPqIsxOAb5bBn
	tiviPm3RDo8/j3YvGme4M7TLup3KsMuMyu61ev6JQ+99GACvJV07IOQVanMjbKtT1w==
X-Gm-Gg: AYBFou0EDcmgaL8p2qv9VWuukIAQo6Li5TBjOdI3e0tor1UH++hczA9FT26fcaJ0LII
	xS8MEGtnJ68XFxskxVves8Zm59TL7YrrNv1be8mNHUZFFfgnEa9Z8fFP/iSfOLQaP2iW5o8b38b
	7Zz5AuH8t05AdBTTaLIYf/d668mE6+wqlD1cKlD6dwjH2cD+MWEUiMwvvFu/aCgI/5WP41u0oyh
	u4TNd+YOsNDNBBoWJhMSQLBTcm9Fcc9vslVCIpXcooAj2SYMoNcZteYESXtMn79EDd8QU/Ouxo2
	FrXYe8Bsu8Pou7ei8rfFylOdMG6wWV1zMmjy1Vp+8gxSueJU36gjkncKgVm+VI//162FxNnohGS
	6TLhun2Ifs0yfyRcJd3iLLuOoIeutuuB6WKlmjxFSRGT180t1zsAn4i0/KzKkU55NgRsTPZjXWd
	ihMaO8DuvlvmLCaSOMqgcufuFEhthp62/DruJf+ExERgR4shbT3r2rMxljlwULvbFNIxJR1xNjC
	K0E70jYKB+ofmI2SwxshtuKYP18GyMTfti1YvbOaCf9+Cpadl3f3GpkQnRCLTiX5wuJsQ==
X-Received: by 2002:a05:690e:48b:b0:66f:c1bc:4097 with SMTP id 956f58d0204a3-66fc1bc4874mr7597179d50.90.1788949666224;
        Wed, 09 Sep 2026 03:27:46 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-670febedc44sm2584559d50.11.2026.09.09.03.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 03:27:45 -0700 (PDT)
Date: Wed, 9 Sep 2026 03:27:41 -0700 (PDT)
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
Subject: [PATCH v2 22/26] fs/fbatch: drop_caches invalidate_bh_lrus() not
 lru_add_drain_all()
In-Reply-To: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
Message-ID: <75e9b5b0-6a70-06df-ba0e-4d7bf841c0cf@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A9D9A40009
X-Stat-Signature: 3czg94pz1nsb8cands8m38b937ncmyee
X-HE-Tag: 1788949667-794787
X-HE-Meta: U2FsdGVkX19+3fZFg6uK2ce/83m3cVQdlyJApilkWIVm0d4yVU/VQVeDGmQZA6h2tRw1n9EHKogJByHmqerDko2vL/KsXyyyrrBk+F/gJhHemZh2c49OdMh8kORDaPFipI03eDdBwQL+DXMNCcm1lBmc0fWVGyGlcP3dFulvTkckOT2Y5Hm2jyge+qE+NjlwVFcOVIH+h+f9x6fTlUaJBdGbWf12OyYRNesDxhkl51z/BziAoYwzQ9AaTOn9I6B2tQSR5kycrHor3w5NWz8yZwoAYPebAz297UuD5gm8OIK9eR5ko86wl+RMd50FrLKHDjtpAG3aaGYIHI1ydEN1HybyUwejaNk/0uyE44p7cf4jJy7xjV7ifGS1+eErz03yOvYq3toLzP/BbNY36qO5ITRBD9/OrLqCAlIKUVncuQF2l823Ly56HZkiq9ZCkfYTRMpgBrZE8A41JHKyfXwJUd4VmZExqe79+mLNQCaEI9jCCEIzY4jViQKQ8yu/3y13W5GE212W2J18xOEBf1W0R6wlSchyrKvMKtiNKhWjL2oKgSXkofpHIBo0evVXIH8eMOraFa/KIwsc8JMcQSUZ5R4uwREZ9l0Lm38jtsoTykopi5SwFJaPZenuwe4S14F+ikPOSOzaetx8H92Qu/SBAD75n25/A7loEVoHQ9wj7VN+zbyNtOBW0iSRQgWAuV2/7pOf7G72Ac8777PbJUmXQWHE+1VY2CPAdsxtERtwm9S0i+XtD/AC9WSGbJN8yATZ4roL/DpxfrZWrlEAOL1KFt9Q8BWz/+DzOGWSyeHzq3uwSvnwHs9g1zxZt0I1Gb5DUjkqj3s77awBdn+sAU5JNz0bG4535PqtZv9opy8uMfJLtW1P9wYh3URV9OIKqV4sxqOKQvZUIctwpxnmAODF3RJH59ieTosEcbOkRAtvibPj/SDZnrimkqh7WcSe1emXWqR748DE3nOXWnuvtQA
 CZIoF/Ef
 dhLaHHyd4li/b/5AiIl65jYD1Nf1zTpb62WnfJYFNl6+NkzOOqwKON20y93tNZleSCmiJHIOZEUFZ+KCf0PAbHK9iPj/YsplJ2y+OmgvHjWKzP9Qq0loSjydhqhKAMHQlqa2XFuYf5mGN+Q9y7JlsrXxQQWLojRRxMHkEGXhX8H2bK2TIXp5PLe9GEZItSRqQAcu4JnocMY1vAVBoTKITEYOp2KHJ+lg8V3I3HChro0VbxU6fsImxJ9uV21wv0Zpl/4xiFWU+yn9AAjf4dZ+RKPFqi42vrJhyB5oFGrh9cXLcGp6sG/Lgsh1uCDz8dIOIl4hr5FflsuIFviaAJbq6xbNdKjVfLFxCCiGR0jZ0SHuCJAluO34WseVHE/1S/+oxESc+WVVl1qFyfbjIF+Igc6ZepPfM3RAAN6EsRXlirLlcM+xV63FZYUyAyal5bldji2ICW+ult24qQPu48FHJkRnyhG+6wb7pziqmZmkAydjTf3Ud1UGgFGAAUDaSxe2p0OJp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

drop_caches has no good reason to lru_add_drain_all(), now that the
per-cpu fbatch references are gone; but it may have good reason to
do the invalidate_bh_lrus() part of it.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 fs/drop_caches.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index 49f56a598ecb..054af78e6a2e 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -10,7 +10,7 @@
 #include <linux/writeback.h>
 #include <linux/sysctl.h>
 #include <linux/gfp.h>
-#include <linux/swap.h>
+#include <linux/buffer_head.h>
 #include "internal.h"
 
 /* A global variable is a bit ugly, but it keeps the code simple */
@@ -60,7 +60,7 @@ static int drop_caches_sysctl_handler(const struct ctl_table *table, int write,
 		static int stfu;
 
 		if (sysctl_drop_caches & 1) {
-			lru_add_drain_all();
+			invalidate_bh_lrus();
 			iterate_supers(drop_pagecache_sb, NULL);
 			count_vm_event(DROP_PAGECACHE);
 		}
-- 
2.51.0


