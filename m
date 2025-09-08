Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4C4BCAC582
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 22:17:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B8B98E000E; Mon,  8 Sep 2025 18:17:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 468B38E0001; Mon,  8 Sep 2025 18:17:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3306F8E000E; Mon,  8 Sep 2025 18:17:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1DB048E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 18:17:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 38421119A44
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:17:00 +0000 (UTC)
X-FDA: 83867494200.29.9B06248
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6D6C1100007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:16:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yrKJ55Ok;
	spf=pass (imf05.hostedemail.com: domain of hughd@google.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757369818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zVYLSetMwrX/VynVtA83hBzGTxxW5OBc+rZUcVQE0NA=;
	b=wH/Aqf/He2xg63Fa4CFaGpYdT+tqsTdGLOSxQpb+8auRcAvJ00qvR9eQ2oq1yHKQSKRbmI
	JFRGjdfHq/8hp5KuVoOrvAb77uZ2JvhxebrD7j6WGOEidIc51ulbyb9p8dp0XXvkxBZMsk
	k95wDbNwu0h9Ep8HkOaCvPAARlVte8A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757369818; a=rsa-sha256;
	cv=none;
	b=s3UDovJVQcFn/8zayAF6hKe605sRGkJiaCOpbQtySf+mcZRI4t5yw+h9qzKG9AApCu/vZh
	hTmfauNrzDKYHKsiV/6GObZUl+v6G0Fw5lki3DzJzfx29Yf9NgkfpL7QiRLOg96vteV/EG
	vNt8Vf0dDOE5NxnBqsxvb4N1OjKNLt8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yrKJ55Ok;
	spf=pass (imf05.hostedemail.com: domain of hughd@google.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-60f47bcdc52so1598496d50.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 15:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757369817; x=1757974617; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zVYLSetMwrX/VynVtA83hBzGTxxW5OBc+rZUcVQE0NA=;
        b=yrKJ55OkagjAPT7Yq4Zk5h0jaAHmQfGtdrXd2+ZPHH6ZYXJV6bEaosaE1wMFE3W64h
         6cXlNMNJ+4nyaP7J0xc4FFgz/rixdS7sz0/t+kHdcN5BHjBsw2gD4HXSDRMO2evyvVAS
         FnnadX4caCAsMKjlwzeTApGtgmf414f0JmSntx4nHLfhwK+oFYOgO21382VHkzrn0+aP
         0fGfieoe42tApj/K9z5Y49eJIR/ChE5RLYrOJWGyk50DXN38JtztrP+uAkjfV6Xa53/s
         GjnDM/dqMNEPl9tgS8LOC2xgW5Q+qhwd45Stb0zPoIuXuP7IYRUDltpdJFnB1TBcF7sb
         fMLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757369817; x=1757974617;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zVYLSetMwrX/VynVtA83hBzGTxxW5OBc+rZUcVQE0NA=;
        b=tgcFpTwyDAyzLHku9vi/UdncCkwAy1Lkb/e3His4dXZy8eP+uXd+8nIsKM7CcAsi/U
         5g7OqkJj9Yj4PyHBc7H9SICEeUxmCNgu2TyLDHr4+ap8XyVEG2oReqx7Uo6ST3KaeNmd
         7r2pskhmm+8EB5PYEGE9rywcY4AdPTdyZ2aB1FUBuMfA5qUJSqFmgrEWT8fXP4D6Q3fu
         ID38JUxoWK1wD3B7Nbgvqhk0Z1BKuwPyx7z/k6UD4aSZ0Nb6D41ElAOBxQSNyEHyUjE6
         4yEB5cTmqbx47B06pVl9fDU7bgehG9VRSHrszS76OOPhCPMzuxE8xavLFel+G3IqG0yB
         lqBA==
X-Forwarded-Encrypted: i=1; AJvYcCX1DkO6cqOgfSDlA5t6vCZ0H2NZRY9K+dhtXEvg9kqIKgjE+OkmXPvn9CGpmSeTlyeIbK0j3Dc7nw==@kvack.org
X-Gm-Message-State: AOJu0Yxz6WUYUtDuL4L/geXJd92yx9tllw27e70VXbE/7+WP/bQI36f0
	rp1G1ERUS4MbABRRwy5BZW9u1Sek5HZbmERQpgqSPSEWWUKa9N1WW8+D00/AZKe1Og==
X-Gm-Gg: ASbGncvtvTje9k2nOiLImNjbp47RqbPzUnN8oaDXF18bFFm7BAT2fgAZcK+TK6KADLX
	4pDPSHYwFHZKAji+iPm5JXKvVSNU7AEmjy8EAX6OZVBTQRmwU/sqXGDrotCeRgQbvt0cpmrKj/6
	ixdC41eXmf8f3MEsi8CU3e5uvGE7F3ACJysTJZSqsPkSwBB6B7HZyQj8h978uckIgQaN1Dlv4sK
	KFJWYL5COjlB3VfxwQZEnuVmO0kPMCW+z/cKtWuWG+LXxE4HNscfg4Xzxw3fadc/KetkijgoWMB
	ZjjevW4uwkgBGFbWmq0FstBBKQxkoYv56KJz5CiP/illsBun6zCr0NeS/uga70S8rxVVHYdSyqG
	n1UJz+3Azr4MFzLtt4PR+MTtRgtwLr+/OQgGfy6hh8dF7kHfB8gndjtl6B7GEuCSa8YEluY7pj0
	keYVx09rbY/1dHF1A/1Yg0x6Aa97MO
X-Google-Smtp-Source: AGHT+IEFGtIXAPyyGQ3/HR/zcX4Kvh/xfXBtsgo7O+saKjkOvxNMfjk5bY+RsPrpYJS0IY8LbDuMMQ==
X-Received: by 2002:a05:690c:4d88:b0:724:2cad:8df6 with SMTP id 00721157ae682-727f2ebd695mr84968267b3.16.1757369817188;
        Mon, 08 Sep 2025 15:16:57 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-608110cabd6sm5167388d50.8.2025.09.08.15.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 15:16:56 -0700 (PDT)
Date: Mon, 8 Sep 2025 15:16:53 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Alexander Krabler <Alexander.Krabler@kuka.com>, 
    "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
    Axel Rasmussen <axelrasmussen@google.com>, Chris Li <chrisl@kernel.org>, 
    Christoph Hellwig <hch@infradead.org>, 
    David Hildenbrand <david@redhat.com>, Frederick Mayle <fmayle@google.com>, 
    Jason Gunthorpe <jgg@ziepe.ca>, Johannes Weiner <hannes@cmpxchg.org>, 
    John Hubbard <jhubbard@nvidia.com>, Keir Fraser <keirf@google.com>, 
    Konstantin Khlebnikov <koct9i@gmail.com>, Li Zhe <lizhe.67@bytedance.com>, 
    Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>, 
    Rik van Riel <riel@surriel.com>, Shivank Garg <shivankg@amd.com>, 
    Vlastimil Babka <vbabka@suse.cz>, Wei Xu <weixugc@google.com>, 
    Will Deacon <will@kernel.org>, yangge <yangge1116@126.com>, 
    Yuanchu Xie <yuanchu@google.com>, Yu Zhao <yuzhao@google.com>, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v2 2/6] mm/gup: local lru_add_drain() to avoid
 lru_add_drain_all()
In-Reply-To: <41395944-b0e3-c3ac-d648-8ddd70451d28@google.com>
Message-ID: <66f2751f-283e-816d-9530-765db7edc465@google.com>
References: <41395944-b0e3-c3ac-d648-8ddd70451d28@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 6D6C1100007
X-Stat-Signature: e9opzspf3xnjep3cwy7tro5wm5i9dqeb
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757369818-105390
X-HE-Meta: U2FsdGVkX1825QCmwJo2WBvC9CgobVpwjrV4r+913PUSx8JVySvNHOW+/OrOI+u3sMk9mAOtY2a+1SIMtgYfh08TomRWcWmMnkwnnBfVneYXSr5bReSqy8hiC+vZuIxHY8wM0iATEHLFlnJgnidtANSPDHIOassez8qo7ITkV2pIB2B+iXsCJ6chr8YYhM+iyEOVjSTYUDpXwdGYpG8C5EmkyeSbzfy3ewUFwasrMRRWZwqd0ZgLkzj9o+nzKbYIDsujCO5W/feYnRekFeJdwLluvjFkejPf74n+gMqOTncVbpo05prYxxYUaSIMaQMEjyJ0OQislSLfFHRPl+GyMWndvfAOejTD34TQtr88kX6lHvSq5R69QNQ2olehBrqSJ5CyjCXhNRVTy2+ARBviccBZr3RAGlm6wgESsCr43VOCz2bTVZyx1qaDoqPA+xvKLY1xDy8YL4HqJceMNFuO/BWP3y2NP04SAuoCnrygh6O6NA8jmcqmPFF6mmrXK1cxIWEBp1O8f88rzgUKxt2vpbXvoUqgUZkBJZKcrmZMNL21bCmIlPx0y3G/NXsz659roI3CenoQ7wPyDXOCO8vAhyTkaeGk4Q9L5COnixSEffGKIuo/wr/hFkZ+uxdpVH7SOrdWVXxXAjHjV46THXkYyHviTyl79tiFcLp9dm9ReUvmbF8tzvqxWX5sCyDDB2MrRXwog46NXTq66WSD84IYVcMdZADuUtl2GTFc+d6rloB/iZU+JXM/O/iP2Qc3KHF48HttZrdaymSy4AQa/90SDtKPtS4NKu6Fp+rjHRDXB8F1F/FGd8hyU/5I0w6J+0w870UscqlyHw8S5d3ZYJSYbWEVaAoQ3MmBRWtS6G6Dze3LKuha1wkHE2l43yzarWLyYZjQrNHFY57CzUibCx7Ujp4osJwNAf1VQ2YY8BGfO8C81zy7Qt6LJP1VyqwB4HWvp5Qj6opvMuK71G3PDhK
 0/G9KdT/
 8pyQjnlx/4OxMCBjkzkTbikZ+XE/M93sBIJNBiuLwwSZIapj5YzwIHnI3i7hA+QmxFWsf/RxOW93wCjkXNirfLz24L5qe2Ius3v3ixVjl1DBT8qlUHJwPMGp9vHrFxFr6LsGAuRHY4IoDYvr8WlZ/CPXCbSXh8bHNgCFHSWCuNccX3ZCzWwePOwstM6Z7plwKuOWvueVivt+GsfqXzTs78XmsVpEH4T9wD+W/DcB0TAkf1a3YYZL9pl26kXbufHHmOE00cUqtfA266xUv0XcsTuLJ64hTSOfIdi/M8s5UcA/psNaLXFDOZATov36hDWRtFItG2xhxiY5bPap1sdwFiG9lAwv4DgcqHUC7YvsH0mgf7vJSVXbqNva9XhFMsTS/agWI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In many cases, if collect_longterm_unpinnable_folios() does need to
drain the LRU cache to release a reference, the cache in question is
on this same CPU, and much more efficiently drained by a preliminary
local lru_add_drain(), than the later cross-CPU lru_add_drain_all().

Marked for stable, to counter the increase in lru_add_drain_all()s
from "mm/gup: check ref_count instead of lru before migration".
Note for clean backports: can take 6.16 commit a03db236aebf ("gup:
optimize longterm pin_user_pages() for large folio") first.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
---
 mm/gup.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 82aec6443c0a..b47066a54f52 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2287,8 +2287,8 @@ static unsigned long collect_longterm_unpinnable_folios(
 		struct pages_or_folios *pofs)
 {
 	unsigned long collected = 0;
-	bool drain_allow = true;
 	struct folio *folio;
+	int drained = 0;
 	long i = 0;
 
 	for (folio = pofs_get_folio(pofs, i); folio;
@@ -2307,10 +2307,17 @@ static unsigned long collect_longterm_unpinnable_folios(
 			continue;
 		}
 
-		if (drain_allow && folio_ref_count(folio) !=
-				   folio_expected_ref_count(folio) + 1) {
+		if (drained == 0 &&
+				folio_ref_count(folio) !=
+				folio_expected_ref_count(folio) + 1) {
+			lru_add_drain();
+			drained = 1;
+		}
+		if (drained == 1 &&
+				folio_ref_count(folio) !=
+				folio_expected_ref_count(folio) + 1) {
 			lru_add_drain_all();
-			drain_allow = false;
+			drained = 2;
 		}
 
 		if (!folio_isolate_lru(folio))
-- 
2.51.0


