Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 341DA606A886
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=tPJeArKc
Received: by kanga.kvack.org (Postfix)
	id C62C76B05D1; Fri, 13 Nov 2026 16:47:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B96D26B05D2; Fri, 13 Nov 2026 16:47:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C3046B05D3; Fri, 13 Nov 2026 16:47:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 727AC6B05D1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:47:15 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E38921A01A1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:47:14 +0000 (UTC)
X-FDA: 85431431988.06.242358D
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id 064A21C0006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:47:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tPJeArKc;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794606433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kmWJl7xpM9EiZrdM4st9QmllTAXM7O1m5Iu9qvicGyw=;
	b=qIPniiUuskJiWZtFzsFr5ul0PWfYOrj9MbSOtjwdDC5EABXYRXTRbZnjLgjMr81hKK5ojV
	IcfYVFvJxRMNgfR/2SSGJS2TJ/y/fTKgQjhSsvaUX9CXjVpMVN1aS1umN4CteJVnB0MyIh
	SvxzlZ63Z3aqFRCyEYqrHlOgFb/E3Os=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tPJeArKc;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794606433;
	b=sI6+B8q+08ehBcjoA8m0HKM9ECziijLbZMvT9Sxu7JCeKnPG75/FGeFhEiu0y9sEvWqmwY
	pPnDeuEJiiJ5j/KkiG3AeSJRV+W3nXVCbt4TZd0gJguAmtc64Czsb5MCXngbLvcuFERsSk
	ZFyOh3idynShHdEP6owQ8lBtJJXYnR4=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-9495f083657so113112485a.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:47:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794606432; x=1795211232; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=kmWJl7xpM9EiZrdM4st9QmllTAXM7O1m5Iu9qvicGyw=;
        b=tPJeArKcynA7GXT9Zf3mOZZc3F4XbDoa3NGOxWEUxXnKXPdxKWOt6Y4ureZ5oIpBGA
         drnZ6aD8m/6tPauQeK85GWJyhs8TuG7cv5Hx5rNlPb6M8dFHIkh+JVMs/0gchmn/iTAJ
         c+5VU1ZjYdxmU8evC6oOWH54+bF5xZjDIXiTjk5NjY6CMwHMquT1/1qzJ26KQDHrPORw
         r4ZDyXMtvdEAQrK45JBrxpUdjVqA2TYCM1Crh+Oj9JJOi09TDmQk+9l9bf55NWF9GHX8
         kVRI0J3rWqkMzaWYSwMofBvAEwmhWrEN3rn9Gqh+ng8+vvCewr4WbHtPnmABidWEEnB/
         Neww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794606432; x=1795211232;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kmWJl7xpM9EiZrdM4st9QmllTAXM7O1m5Iu9qvicGyw=;
        b=Wjy6CXN7alCSBLe9QJZqJm8+TbhWhvG1HNfBxGzdwmedn7xj0+6zL9q2pSjjnO2tTl
         wY8BjhOjm061iYHea3T+2K65dEuRgzs1kL3qa+AlxlX1AR69JUrXJnRIF6KUYsOhyXPk
         wWi5BC2EK5mFlCJB800O/dlsIfc9WmPjtKyMq/irFWkElbiqhMN8JehxnYU8W8YBUGHC
         lFX+wkj/A2ueOEqNrJohCHGSe44SQ7Ar7siaRpCvKRlLsO/8lNJIV/ids+b5crj4zOFA
         SABaN12rn/4e/ftsVq5B8me65ZMXhOo4JhilGWC/5afjbA0J+vohdonsWtNYlblApUlq
         bRKw==
X-Forwarded-Encrypted: i=1; AL+hErHlxhY/1KaVRkJcQD05fSxmc58GPhZM+4U3ByYzKaxUehShWqEyhpBG1BA2WXuPhfK0h9WeIqeyzw==@kvack.org
X-Gm-Message-State: APuU4Z9fjQiAADP0bXpCi+XG3fgu9zRWzunsQ0KA2nuk9XEfYQuQqcjT
	0ePXdnXm1CLpPI7WhmTgC8nW3ouqzoYBE5lgPc0oJocnJPjdRsot9rVOXGsSWSBSfLQ=
X-Gm-Gg: AYBFou3k7kK2IigCFX1pV+/+GvlnTFgmltbjRMvLuoZTSptu9c/Qksm4VhVAacUSFAp
	8hlxSk+aw0ROyuQmeDj2f9qD83lXpa0WHVStp80FJUCxUqpeXn6MynRu2o3jUtAV7cmEt26K4EG
	fJW23BDeVqqv01vfDJtCuXJTAFETdKExFsxZTWSWl0mDKpcE7LzdZ2S8Bx2rUgGkhCEFheOJxSB
	0TWaDOORFt1SkNmpZgpQYiCkUFSoFZT7h1aD8xb1own0bV4tCuprymiow6zx/hjuh5ezf5lvSj9
	QJi6Kxt19P6U8bwhgV2Js9cEcxdV9vsdcAlMYJFpNqkl1Sr98iPBWDBTg8HjKRHbvcNy1eD4eiz
	dFhg0wIOAPIzvUsNl9kgaf+ZwfOLp2udQ3dGrjAyfpmA0gbpJTsFezlA0kSD7i9EpRYn6DiStSO
	kQ7bXfMRN61u/N3vefGbfI+/MC7Ev6db2VAEMGppjWk3IALNeu3So05/FP9ZNNYdj48+lYozKQe
	0d3wTOBbtSpGE9kkk2C4mLfhz+GNHVJY0Jt5jSCE03wPh1fj7/HrWYgcm0RATMK9666sXyintLo
	DpC799LNZ4hr9+RVr0/tyR26oI9+56CMUtI8e+G41X+IB/yjhLaaXm9ZNmk/oRDqgHSRQ5Nezca
	P2JRo/I4=
X-Received: by 2002:a05:620a:4042:b0:93f:3120:6c6d with SMTP id af79cd13be357-9494bb56dfbmr651566785a.35.1794606432092;
        Fri, 13 Nov 2026 13:47:12 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c8b5c1dsm279333985a.33.2026.11.13.13.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 13:47:11 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 05/15] mm/hugetlb: keep surplus folios when the pool
 shrinks
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
 Andy Whitcroft <apw@canonical.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Dave Airlie <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>, 
 Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>, stable@kernel.org
In-Reply-To: <20261028-fixes_hugetlb-v1-5-a0a033db180f@kernel.org>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
 <20261028-fixes_hugetlb-v1-5-a0a033db180f@kernel.org>
Date: Fri, 13 Nov 2026 16:47:10 -0500
Message-Id: <179460643069.482102.17806419339613384754.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 064A21C0006
X-Stat-Signature: t9n5o1snusxewanjkrwqrxps8mhtk1au
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794606432-213603
X-HE-Meta: U2FsdGVkX18eMUiN3QlrSFqi+SHBvwCn0PKqATXlFo2Qkc3RqWmaJT6jHelXkL0bu6kOSiETwkalR0sJrXt6+ycoVIGR25SaVg8dPHA+El6W5AU6RR2BKzboigUnDKvrvFqGt9iUjVpV9gkJGUztLqOhUvMUZjCg3IzCsYZ1A+FHQeROQS2yX8Fku0/7IfUwO8SXv+r1ybgY3xQEIpFpzh2vd5fo4xdaEgsVvtBJ/BOHQ+3YvikDfT9xkmpMuWzlVxza1epDEqqIm58xFEKFbuPweeynlPsyi0vZLkoemFCsGr5VZ5NPp0CeWxe32h0RVxTt2Fs+xR0wclxcvN+E5zkCkg7AZa0+arcYj/dQ+7jEy1usd/HAoMEOzHgVkUZyzPGaxmiOv7Yi1psp+qBMm1XAiuOsyL0tkyIVm4yaBN+OPeM3cijo3wZ4Z4CmjDvtUyot90szgSJ+P9BEAB2At+DUm05w2Y8ZWeMQ1WR/znK0MpqxU1ZEDPl/pxryYuSpIf2LSukxehYV9u8gU652V9TerSPd1lBaVyN5grhHuRrvGPIjDp/SuMDGjpoWslwl/4M6bfuGSBbaFZcJs0Ae/tvaCQbmV+THreJMZiHPllYVKtoKMx8wT23V2b/thRdgEapHFzyGIhrHsRz/PaLrg9+l4dRn9NpQvZg0dtuaAtMEP2VzSJRmlAS/VNKL9xvHkXbpsUpPlHNpR6s0np/kjQuWblJJA+GXWMljnOdSTyb2sooCcw3iyGYXByVgUrwGYrcM2+UwDeqZmZGQDY3uYVu9f9uHw3Xivx1vmRX/64CrzkR4Tf88NaVSifbdAyb8QrDlTXdjifoGEaUpyGj6V+5oDOALuyU8fwSxQzFWQ+hHvLb49wmnSMAl1XYR0sjmQJa9sY8Hj9JK1Fp4hjEN9W1jaatk4PHjOEdQXAd7+ndp9SWiK+HdxOELvmYovgZw3K9hL1k1z5TKGiBDFk5
 ovCEWUmW
 snIAiOpi5XBCXQSrGh/ciVPL0lzOHDALg2AycuexqnIfDZXYxT8L58EE0k5E3Em0Vtxpawo7YL/syDr5+og+dxv/6B/qzk9jee7pQilNR2n4iAwEfjwc7+OEhbvFvL2hMf+/R0eNvkGc+dK0Ht+SgM/KtZyy1bFdfI3zVsAPLWQO6tVv914nvB6SLlBI86SOrJ66Uy6zBzlh9Rdn+sKvlDwAaUu4Hs/0THNAfuXiVU0uTf0NmdZ/qpfrhSC1QC63gsB9bAOMRMOTSz1DrJUM056RWHyPUuUMkPl2Bj97LbYGlI7P7EUUsW6wRPSoK8LfbiAGCCArlo2XWKRygHf7vF6xuMdCohUphAMh+6zR+lxWSGTYaMmT17Iga04G+CZ7Q4NGOw/PzY30G71F0zL+FXRzPH5fKXzwWBlaDWPqmKdayLtakCPukNdwK5ydWJ39cGpDCHIZ8+fbak6WWCaJoUS7mEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-28 21:13 +0100, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> Surplus folios are accounted per node. When shrinking the pool,
> set_max_huge_pages() removes free folios through
> remove_pool_hugetlb_folio() and accounts them as persistent folios.
> 
> It can select a node whose folios are all surplus and leave its surplus
> count larger than its total count. Free surplus folios can back
> reservations created by gather_surplus_pages().
> 
> For example, with nr_overcommit_hugepages = 8 on two nodes:
> 
>   (node columns show total/free/surplus)
> 
>                                       total free surp   node0   node1
>   mmap() of one page, bound to node 0     1    1    1   1 1 1   0 0 0
>   node1/nr_hugepages = 7                  8    8    1   1 1 1   7 7 0
>   nr_hugepages = 6                        7    7    1   0 0 1   7 7 0
>   munmap()                                7    7    1   0 0 1   7 7 0
>   nr_hugepages = 0                        1    1    1   0 0 1   1 1 0
> 
> After shrinking to six persistent folios, node 0 has no folios but its
> surplus count is still one. Releasing the reservation cannot clear that
> count, and shrinking the pool to zero leaves one free page on node 1.
> 
> A later write to node0/nr_hugepages underflows the unsigned per-node
> persistent count: 0 - 1, resulting in allocation of many folios.
> 
> Use persistent_huge_pages_node() to skip nodes with no persistent folios,
> as adjust_pool_surplus() does. This also excludes temporary folios.
> 
> Fixes: e4e574b767ba ("hugetlb: Try to grow hugetlb pool for MAP_SHARED mappings")
> Cc: stable@kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: cleanup code and description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reproduced the total=0, surplus=1 issue and subsequent underflow, and
verified this patch fixes the issue.

Tested-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


