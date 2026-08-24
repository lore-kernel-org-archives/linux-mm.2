Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C965CC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:23:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA14B6B0096; Mon, 24 Aug 2026 10:23:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D793F6B00A2; Mon, 24 Aug 2026 10:23:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8E936B00A4; Mon, 24 Aug 2026 10:23:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A3C8A6B0096
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:23:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 33A794017F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:23:32 +0000 (UTC)
X-FDA: 85136381064.24.0C17209
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6C04040007
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:23:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e7dBNqK4;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of hughd@google.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787581410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DAA3AJBckMfL7iDkU5H4UAChzqupIeoXexgfVyLiXUk=;
	b=oDMVN9qeS7AuxVrFc01rFhY8Yd8qDL/2VTdzfgnVgziZDBRPYkgTeHX1zxcUT+5qAaMLJl
	zH7ZaAv88LDhpCBIWK0tcKA43alBCxZ+PZoFVl2Cr5Cp7ijWxCCoBzxG5KxPYA7GG9Elte
	xBA1d18TyKgIcNR5w+BKzuMlZQpBC9w=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e7dBNqK4;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of hughd@google.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787581410;
	b=e65oX/xloaS0l2nHSDeJyiflEQjLZlJ/M8B7+AmPSP2MEAVDATt0hhSqf7bTyzPahnlJ0q
	7UNaaJ283w1YVnK2slfc71mfKCOqOuwNSL0UORYPiRfBLIKNbCJYSfPEtFz0TS2IRvFro+
	nMjrn4d05AjReHEGp9i3YZHtFYdu0OA=
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-8200b55dc47so54636887b3.3
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787581409; x=1788186209; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DAA3AJBckMfL7iDkU5H4UAChzqupIeoXexgfVyLiXUk=;
        b=e7dBNqK4rafiMdypWN6awmIMFlXhYhGsdqH/45F1ArMBj0QZgR8zYbzHKdiOxzuHys
         DUSV9RVnWRMBD//ZxkdR3ijI2ZPhd8WGMk9QMPBWVJbzQeiaASLlIeJ494zgdg8mfw2M
         mhAiGz8w1FwrV091Gn9lVo+xsIEngQbHYNBtm2sAGkyF5ZmsiazVRUTwwoC9UQnUKGwB
         jnLmnyOu5/9O3AR0Y5f2Or8ztXuOQd1tXow87KPr8CHN+YHGY+ke8zje3GWsnrZqhFCu
         +T1e04Jl9ubPg7d0PaDo8E+tJLUB6ogrWk67UnYgtugABSrSmu9s57Ve34iDdPwXHlbn
         RCAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787581409; x=1788186209;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DAA3AJBckMfL7iDkU5H4UAChzqupIeoXexgfVyLiXUk=;
        b=VdKO35Je0JCsGSd0QhXTfjUF5zlp9Ntfs6vMxrroGjZ42oc6rBWTT/ANwg9u+Du2ig
         WV1rjPoRuDKjV0YQj7pbw0d5yXpmQgUBjazgOotc7b9OHOkea7S19dIHyKLrMCfaz37n
         2YXmLv+shxcwL2wysE7r9NpA77Zi/pOJ0sL6K1c8aMJ62niJIybZd0uxpg/Wh/88WopD
         tji2TtjfgeM758e43KIIt0NtBw3gAlbnlQgkM+PBNums94o7r8anXjx3R3/NK+o0mPfg
         TzKb8/H3zSPDOgWezOdxYM0BFWoa1LFpqL3i85RefZLfCMF3YjQHAkYCfQjd66FQOgYK
         Q5kA==
X-Forwarded-Encrypted: i=1; AHgh+RqkGGFMcFIzg9KaZX3EegjGXv8MvQ0sm+FvEwNZwS6cvrH3YA/I3YtPp/5KKT9/v3kNOYy/50jSIg==@kvack.org
X-Gm-Message-State: AFuF++lu49Nz79Rb8YR/Yv2dx27f1bqZwRR3viHc0jwc1D40zA22rW/D
	2OasaVp/6PTRcjPQMmJ+SDYV/8VqKEuG7OnvOGUocVQF60QYxa8phLOiDclPvlQY2Q==
X-Gm-Gg: AR+sD12HGM5RCIfMlGAap1WbKzuOgpxbL06uuA7waaJnjiWnhcsT0n3A3oG3E0KM4Wy
	Q+kxeCgIVSD/oWOSO03s9Kw/N+fsKFJNmkftI+iFZ/MYfD7hXywz4DSL5j7O9dbDdBQ5NU9Abrb
	mKMo3IYLOE6f2buU0t4kCzPhOnTC7AnIFmjVpxOafOlpfFeOwzdNViu9j27C0pvNYxB7d/m4m5o
	SsP9dO5vpLXBhJo5kw/zEf30wAE9X6z8pkqVeygGPnD8pGPbaU46ls9H44fkKXQFFfgzIOijZzv
	0xtWW1KDrnFCMQfYr+4NfCmqn/HD2v6XGTaIOCL4GctyZkC4OV4uV9VWOg8OpngjJr0WEW7mtJe
	G33XLDLZknrTAgd2e96xLKhLWJgiIvWDiDrmXSdQqdDHA4mUrWLr7AmzEOrW8NPu0sRRBQf+uq4
	annDFel25eHSr2dL2Ibwq/gZByw0tXEdyP0jvMK4vFfw8a23CU4bANZ6K0KeYQ6bmPvtDYnHP+f
	C7hjldBEiZCyVmO0k6cgJG8K1zGuMCcU9x0j3T356+CoA+p
X-Received: by 2002:a05:690c:a4db:b0:80d:a249:4854 with SMTP id 00721157ae682-84c99f902c3mr43542587b3.17.1787581408945;
        Mon, 24 Aug 2026 07:23:28 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-84cab854483sm33838647b3.33.2026.08.24.07.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:23:27 -0700 (PDT)
Date: Mon, 24 Aug 2026 07:23:23 -0700 (PDT)
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
Subject: [PATCH 13/25] mm/fbatch: no lru_add_drain() to
 collect_longterm_unpinnable_folios()
In-Reply-To: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
Message-ID: <fbf3fa74-c646-8855-17e4-e8b35dfd9c14@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: rtuxpwbpzh9oguoud4rzx3bbnmd1i5si
X-Rspamd-Queue-Id: 6C04040007
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787581410-751851
X-HE-Meta: U2FsdGVkX196ZlfykIBCSlBIcwk1woDxRdW1gHXETGEfdcsKWOVueLYkFNB9uRVjoZV9ES+cMj5j9tTvSRn/Prv3EpNZJGMC9PZOtZ5ewNg/GELGJK3ri3/OYOQ5KkT0igB/7vniFn6aChxp11DAFW+G2G0Bco35UVbq7128hsoyqHm1lINcuwAdErAFolSO/RCZMc1GGDiYSOvm0hjHrFWNj50IkHWjTUuToRFb48zeZlxX1qrviMZCMTRzLH9l4xibMNb6Qa2MB/hpBy3afB3RdqNdjBAKChEAiQTsQ/m075Y5pyumbtFqFklw6hEeFghP6D2QbsL/q9kJvR+uDRrfNn1VXXAXI5lVg3aHoYYETACogLcqVqM+13cT6uXEqW2xrClgcHVYINRwSrJ9EM+upqA7MmwWR1KU+TDU4EDXa0yPkZhIZMfx7GrvZoodcHsIHGrT8kdl+1j9iP2Jge48wmyigSfe3N176rzo6js2X4Fuiw9ckInRiEaqzUpkyJAAeXbTY6STfGnJQGPcjNHSnyRDT2gw3dTL7guPD7Iebqb9EED61f4OPhayoUFHLgOM+qdILwtW5Uvq9PCrZ9S097/AEvMbW4q/hM2hKAe/h8HX8B/rkCbAwRXaMG6dEF/bl0kSLLPKMoTXpKjw5dQPSJYLDIJQTv9IOucC6j93FE2MfMC3CE+U/glnKh8shomdYuMH26F3l/pM8Idz6tT1TH9LsLbWdpgXmIzm//2jzqkJUD9vXMLVj82WpAx56SKm2/Bd9IOHyqrtHls8d0lgrKbO4Rst6nt556Pgs9gT9w9ppWYCGvRq5S1d7JSfKskIjyv4VS9H7g33uWY9WAqYJk4KKUNAc3WhP6Fv9+T+7YiD2zxVhz32VWNLgWYLArWCjdmLIQ+AM100BIVVKS5lLV6gJAEvlOlj4nwkOC9Sz6Ms921GOPmFaERLRlec0jMUiUGj/1YZHk8XF+n
 RNDSM0L9
 ozo4rctIWRY8DtNEgpUOoq6MA/UOlO8kCCOENjXBpsfx/zX2wOb5ruIloBUFfSvDpVdICz7/e6GgVxuFCD6v9OlA+hwMIgTmhrPafZ58/95sEtarQlixs1gwKBjFMQ3jyQxi/2KWbAri7F51C7YVPa8w7x1TX/1I8oYcRN+szOw0kmTT2uKUFc+DTCS9ic5tVKVnv3Ywqeh1FeicJtDipH3UZLjfLVN/mPwCz2oH5thsMbSAsHs1CI2g5SrR24b6VKcU623ctXhQJwWef79+cPdarzAg7FhwDmk5zo8gvTcdQY/BpfTP0kgAWe0y8qDFidp40/8PfBJLyHc1NILFtJ3REhhmbHAUpuwoNQqEoynWXKvhoT/Uc+gzkxRlP1TwtPM0sDS+UsYrse58kbIqE2/JjvJcDQ+3mf5WgvrB/BNOw6GbI7XgB+RCrzzZUdsvxUgzXxIyWZ+AbAjE4ZOueVbbiFUv9OQHJqFP+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

collect_longterm_unpinnable_folios() has no use for lru_add_drain() nor
lru_add_drain_all(), now that the per-cpu fbatch references are gone.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/gup.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 99902c15703b..9616379ab069 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2268,7 +2268,6 @@ static unsigned long collect_longterm_unpinnable_folios(
 {
 	unsigned long collected = 0;
 	struct folio *folio;
-	int drained = 0;
 	long i = 0;
 
 	for (folio = pofs_get_folio(pofs, i); folio;
@@ -2287,19 +2286,6 @@ static unsigned long collect_longterm_unpinnable_folios(
 			continue;
 		}
 
-		if (drained == 0 && folio_may_be_lru_cached(folio) &&
-				folio_ref_count(folio) !=
-				folio_expected_ref_count(folio) + 1) {
-			lru_add_drain();
-			drained = 1;
-		}
-		if (drained == 1 && folio_may_be_lru_cached(folio) &&
-				folio_ref_count(folio) !=
-				folio_expected_ref_count(folio) + 1) {
-			lru_add_drain_all();
-			drained = 2;
-		}
-
 		if (!folio_isolate_lru(folio))
 			continue;
 
-- 
2.51.0


