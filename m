Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B94D8F3D5E0
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:53:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 114996B0089; Sun,  5 Apr 2026 08:53:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EC626B008A; Sun,  5 Apr 2026 08:53:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 002016B008C; Sun,  5 Apr 2026 08:53:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E66BA6B0089
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:53:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 823421405B9
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:53:31 +0000 (UTC)
X-FDA: 84624493422.29.3D5D5AC
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id 97432140011
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:53:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PWgjhHhR;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393609; a=rsa-sha256;
	cv=none;
	b=aZbkzv1jL8klh9fDZVAdFjvkBU0J/E5hf8EYmubu2+q8UmitUbaHdwHr9Z6drFfGUvB6bx
	zDl4+rfiAf4ojYe8RuDk/UTa1vSeZBF5a2iiy0IRsUWN29RzbwSRB8nO1b5qzinpdM8949
	OhuFrkaqcqPf95eSuOu97Rlce7oD9rE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PWgjhHhR;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iSQZfRjRjpxozRWOnZuEHxRe4aXVCopNiKXhl9pDTQQ=;
	b=wCvHDdz/uA01ySnnaXdlJJJ82uwd4jFmr2vqPGUPIcO/M8dKw+3oNp9yXYralv1orgGiVr
	WtsmXomwTDRfFjnvFIwOCd7Od6qRz4XJnx2rkvUPE/0FMBg8M+tIdAw5LtIWH4SPUna+cw
	jxdIfh0TdIF8ln7ch3Tp7OxOqsAnxWY=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-35c124d2613so1749892a91.2
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393608; x=1775998408; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iSQZfRjRjpxozRWOnZuEHxRe4aXVCopNiKXhl9pDTQQ=;
        b=PWgjhHhRRQYD+PmiJqhvEIx3wM6mHzlmZ2uwFbYLOynlIDlz6nnwAQ+5oJL8JRb52g
         /oL/j0SokniT+wl59xE4WWuvSVyuS6jSEchCl0fxE8UznY7VYKp5S6MU6Nc5Oo0nZpfZ
         JHm1YHaK2j/eWI0Yct49Rn5jLnKDmSN+22iHhMOl3uozkQ4atVwvxDHm7k1rNqRZKysq
         WsZS+kKL963hVighlzE0p7dV8V8NIMz81yyNOQikX0cjeCAlp2uYOKd3qyRh7G7gTktt
         0qN0x6/SWpEIizz/Yche8bIi3vlUhdA6d6qo7rSBiGs53u37J25y9gNqBxuPUOw/o7Wm
         8RuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393608; x=1775998408;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iSQZfRjRjpxozRWOnZuEHxRe4aXVCopNiKXhl9pDTQQ=;
        b=CKb4jBX2Q2pTHzeOKJvTyvpLvO2j9H6MmP+GUhf4uakbYTi87bLkNnIOCjtWq0nNRw
         Rr9IuyZE1IAAMtn1HvwFQYe8JA5iicRQsuiuQMIxbXio55B0xV7sXK5b3lO/cfCYvvo/
         AdqoLqn+v6Pb4Faf2mmdFJeRTT8MtRa1TDyHNAwfh0KCsbOVOG+bc7fAfQlLAfWD+GOQ
         MHCG59jBl3KIBn0WdSACgLcthgKBmfB4JzhzF1/qlNepXuqwWPC9ihvJ0zzBX8XrInEK
         YNinDSz9zB+Uh5YKrgmptWXpu9FgCtvexetu8ej2ehCundtNFDSWgLLvDMdwnAXiK3vt
         PrEA==
X-Forwarded-Encrypted: i=1; AJvYcCUhBIolsH7cQr+5grCnnM6fRTgckR0HuM+FcNRwOEzzCxQ9dCFaJ3Uyv2KWt2PV9Mc9KrViRIhkzA==@kvack.org
X-Gm-Message-State: AOJu0Yy0UqRsVkhEKwCKnsDWZEOoMHEa4m7Q4UxE0AJMsNvY3oEDFgdB
	ObpUvPaalnxhZ7OtL+posH8rRembdfd5ykyRvNW5YU3h4KbDGDP74shfdpiL+c0/fCA=
X-Gm-Gg: AeBDievMo6q2jLzJhia7nVl+gRpvwZ/a85UK1UUmFda03pROKUvI7YKSM5HDZmYHPW7
	+IaRdxA3EHa9mK/FF4PFBsPCASXaGTN7Y0kw4kE1Gipq1biI5Zu/JPDNr0hLvCma9x6Lt9r36TC
	l2d2LIXZbWxOPtQKARRC2B1XcRMAWj8Gsz9tQl7PUh7FISklLpLFJVpE5o62GDWINgl6Cj92ffa
	ijeUtNFRZisaZaEGmww/qPmwxfGDUs0+OZ9OsK9PR9gXyfKOGwuohPHqpyyoQeRqbkT4RroakW8
	bITlYHvTUYKMwWJzinZ33iz31/FaUxsNosQ8RdA+HntlQBJ+3167hMTTCLW2D5/1mIPlNwd8Lyy
	i9BR/zM56/99TYr8Kd7zB0Pk8zXIBh4YxQSN1h+gjXT6KFUUp/MSnQWP2MlzL/uUMzLwAjQcZ7V
	7jk8oRNuapuPfGEo8Pi+yrj+knlURx3tkP32ZuMwp9Pao=
X-Received: by 2002:a17:90b:4c4b:b0:35d:93ff:2854 with SMTP id 98e67ed59e1d1-35de680e77fmr9867916a91.8.1775393608080;
        Sun, 05 Apr 2026 05:53:28 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:53:27 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 01/49] mm/sparse: fix vmemmap accounting imbalance on memory hotplug error
Date: Sun,  5 Apr 2026 20:51:52 +0800
Message-Id: <20260405125240.2558577-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 97432140011
X-Stat-Signature: 7ek61y5jt65t1ws85qrnezqj64f13c9p
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775393609-77
X-HE-Meta: U2FsdGVkX1/IT5y5bo0KHcm0Y6gUMzilU2TUE2WlSWj2ZBN2QdkH5+4UtbM0GtroV1U2CareYp2OnqSrK+eDT0OyrBTmtiVc9LYnLjVAXCT1y8uwX90cPHQ8TcLv4eUVk5nTFe7C3xHLiwiu9cEqvAPCDLkRWkypHB3NrM8iZSXguSyzgDklWPaq2wtudFv7hlFehIVQl8LI+H4erRirovmxTm14aEwI8ywW25V+ej/z31kXd7DxMYaK306iwKlO9lHQckHnqTuq2pb+Lj9c4fGL+oXzhlUSzLJl9jMy2x47/wbGHiNsfwgENmq82ba3URw2MjFyJky8IOuFUz+Igb4Uz00oyqX7p+eT7IuvixwLtO3/zhtB/Hk3udDtP9GKGs5CAmg2LUq4MQrnXGiIq2npbez056XxS8ISFHYdh7L+/hkiqUusp3bIAUUJcJOilpZ9r5UVbhLOlX+8IkM5sec1jpfN8CGFLsceBxYQzlzrwNVjNyTZARKubwrt+5kLiLab6fCgykjhVGBWSKlFdS20yULvFqSdrVggX/SMoFfSKe4spYJmlvjy9yv0kN7VxqPRh1h6F2wkt9jC3oCMuP2iX1/kpF2Tpcz+23A/q1nG2VoLE6AUc6U7UcyWKGTPoVFyEUV+DzJFdIhIQ92tbftcA90GiT1mqB0J9bq2sRIB+tA49MMZsYOmr1VZvM2StQdeuCDnIyxZtPmQh5+ENA0BDwWhy0a5u6l9s5BqLTA+qfcj2a+EOeqFOWNWEuFTXmEggvBVn2OqQWBrbDNhi/RL/uuePX8U4VLzEr48H0FoOcWBb3FAWrefl8nXGXCAXDThWJkTQPodQNtmZBTYEZ3LUBmdM9oue4ZjZOORLVDFm9U0gcXAwYQZLf/UEK/zgFF21BMlB7mOx3GezV/Lr6fzW/DW8JTna/Trq0dI1sTjrZGNJ2y/5Sd0I+Xom8cmZOlbnNYSW440t2ko6rp
 I5VjgILN
 A6N8otp3XllX5a/BtFBKUEmSrmklszhO6a90m5gHpvvoRA7RGEF8kIBzgrqYCNnWa1AsZxcKqAGs/BCS2g7WVl5V1RJ9uM09Ux6tdikDgCuDGO36XSrhoUZPlHXLBA6+2V/RE7zqIm4WtPIhtbsHmtbLzWBmIg/rHO7FIaV9QY2s5F0cOgUY9C/4NsAhnlE2ZBFhGvaq/u5Ujv7ygJs58H1pOfdSdns6K8ROjSvEgACMEaPy3HzLZnMGYZaqlSiutkUkIzT0aXYKt63meYzSdUzXBBINLhX6miSm0zXCqjMVmq8e4t7VpUMs3tQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In section_activate(), if populate_section_memmap() fails, the error
handling path calls section_deactivate() to roll back the state. This
approach introduces an accounting imbalance.

Since the commit c3576889d87b ("mm: fix accounting of memmap pages"),
memmap pages are accounted for only after populate_section_memmap()
succeeds. However, section_deactivate() unconditionally decrements the
vmemmap account. Consequently, a failure in populate_section_memmap()
leads to a negative offset (underflow) in the system's vmemmap tracking.

We can fix this by ensuring that the vmemmap accounting is incremented
immediately before checking for the success of populate_section_memmap().
If populate_section_memmap() fails, the subsequent call to
section_deactivate() will decrement the accounting, perfectly offsetting
the increment and maintaining balance.

Fixes: c3576889d87b ("mm: fix accounting of memmap pages")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/sparse-vmemmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 6eadb9d116e4..ee27d0c0efe2 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -822,11 +822,11 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 		return pfn_to_page(pfn);
 
 	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
+	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
 	if (!memmap) {
 		section_deactivate(pfn, nr_pages, altmap);
 		return ERR_PTR(-ENOMEM);
 	}
-	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
 
 	return memmap;
 }
-- 
2.20.1


