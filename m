Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 338BEC43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:12:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C85E76B00E4; Mon, 29 Jun 2026 09:12:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C12F46B00E6; Mon, 29 Jun 2026 09:12:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD7826B00E7; Mon, 29 Jun 2026 09:12:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E2D36B00E4
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:12:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 088EC4069A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:21 +0000 (UTC)
X-FDA: 84932988882.19.CA86148
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf19.hostedemail.com (Postfix) with ESMTP id 432F61A000C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WR5bg7aA;
	spf=pass (imf19.hostedemail.com: domain of 3MW9CaggKCHIZQSacQdRWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3MW9CaggKCHIZQSacQdRWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738739;
	b=wSpkPCzWpYfKwYWaPj4hijYVsN+M0/4QeJjQ3LT0RTiBZT+t8N68AT69w57pXDWAEj3J10
	BStPwlwO8nRI7JCLwi50ZX7zt9TqXItT1u/IECxfDSvHbrUq2gtFBR6dWdI6PPgEoZwxdu
	Fq1sNDP5hwAXeFe0gO6QPQ/Fvcm1Btk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kyq+jF6tfnrMCoNpsmlosgu1iRsoA+3mO594b2jRXtQ=;
	b=HeFoGpf95YPoWZyz6/el1nFI7THPP+EgvcexJapOkrZsOBi7ALBhF8YCc8f7/MTt2iqyR1
	RCnsB/LVqHVhfQ4uqSixweKTh+Rx7q0ogDKuGGYbFdFlqC+PDwo7J/3CbTiVOLab9Xs62+
	f8O8T2u5dCv56S8waRMS0vRxQrZFdxA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WR5bg7aA;
	spf=pass (imf19.hostedemail.com: domain of 3MW9CaggKCHIZQSacQdRWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3MW9CaggKCHIZQSacQdRWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-47407691804so380052f8f.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782738738; x=1783343538; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kyq+jF6tfnrMCoNpsmlosgu1iRsoA+3mO594b2jRXtQ=;
        b=WR5bg7aAwqwR3/Vy6MBR7IPYwuw+ssd03/Ehno46umYTM7v/IaZvgi477y0IoNrXsz
         K7i9ifaTbZyJab0mmIo9xuLJjpANt3YGO+dD+qXsHjSMT2eCO+DUpShyDy6/AJZcR0Je
         wVflNF4FFPMtA0IBdUxlnkEPC/OfHIJ++WVPaau69qzIb6F4NDxCgCGJyCUzMe4Dcqn5
         qgGWrnz4eH7nEi1eoS/EUef5wSMN7XmbmdQBQYdnj4o8bqPttdYNygh+2mtjX4IGZt29
         MbfOkU29G/iDVmW3aroN/jTcDV7VvSYOQKfJn0jgLqsBN0zHwvyYnAcjo5H7DKGxQkbN
         2isA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782738738; x=1783343538;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kyq+jF6tfnrMCoNpsmlosgu1iRsoA+3mO594b2jRXtQ=;
        b=dyRgw8vBo1osMtfzv1AXV4jgcsi5Gx9l2RcnorRNELu8hJyH3Trb/5Dies2iY2aBpz
         jJVGN8QlgZO3RJWsk5tyAyUREzXfU+V58XCn63f9kNmiS/TW7dXPunVz4TRUkMYwzylE
         p7kTg6PSzglyCh8zMx3B2gNIiLSSFTFsSsAc+sBE5WkAh4nqvJFW6+U/CaUH8FGJesWJ
         TD7+RJW81subG0YPCDbb/Zh6NaGkAAJf2Fay44HRLKQ1BsXrU0MPDgqmfiy/DhpHYgCd
         NgrH9N3GuPCzz3pPRO1jXQIHDkn7pUqFlns21ImOB4juv8FJcQXbDtka02+oTpYILZHO
         gtUw==
X-Forwarded-Encrypted: i=1; AHgh+RoC5CJiKbNakbUZzRWlbx70Edbjlw0Eyy83Iempu7twxbfnOIJYoL89NvpZOibwb5n3UK/IK958lg==@kvack.org
X-Gm-Message-State: AOJu0YxH7AurVNfH2kCxFiouvPuOvpNg5HPs8amsr/+CpgJqQ8a9y/t7
	io8k5OaIaQEI3eOQTOwas8HlnJYEzzSUhlklEpjaVjAtXDThzK7+J3IAlELxfGJvMR48kuTyRLb
	zMoaJwEpWdM7uNg==
X-Received: from wrim6.prod.google.com ([2002:adf:e0c6:0:b0:45e:f3ae:e713])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4618:b0:475:1583:a414 with SMTP id ffacd0b85a97d-4751583a44cmr153079f8f.31.1782738737575;
 Mon, 29 Jun 2026 06:12:17 -0700 (PDT)
Date: Mon, 29 Jun 2026 13:11:52 +0000
In-Reply-To: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
Mime-Version: 1.0
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260629-alloc-trylock-v3-3-57bef0eadbc2@google.com>
Subject: [PATCH v3 03/16] mm: name some args in a function declaration
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 432F61A000C
X-Stat-Signature: xn9buco674c88rbjmueno3wyzdku93f9
X-HE-Tag: 1782738739-226153
X-HE-Meta: U2FsdGVkX1+zUZ81IqAycqCfrOMaGkMxQlwrYEFuoH1y8SmIiZWq+mhFcRNv6/gCkTFR67aXCb8is9dI5iPmox6sGtEm2czuqOz7GJU89lUBg9wWKRjQMt0Aq6HY2Ire5H8DzyJfhnVIQKiS5eRl8Q9H1QGtgKU9WhZTeEd6BoZSl7DXCjapswEppGO3mqb1CJQ24ic0hNiuo3UzJft/8bIOTPdHr6EYxR6n68G6TdVRf0dAEjMvKzeAxEi5ZyfGOEsqfJF7sLRAIRX5MQU7M0VEOo5cBAU08ocyEn8y69xh1TJOBFZO+8cmAY8yxOikjsD9Yx5h+APqZeGFBDshL73ejYQkkN1i9E2KP0S/R6lgmaYCVqlLK80e1avoLDXIQnmFEyU5AJypOBy/x4TLDJWuMm2Avi8LbcZnfMDHcSNhR0OqZ1tP58ZevTL4quphBDF7Y5XA43AzA23S6OaLhDhatZdnKpaamXrTmfhFB9tkzP8HOKKlhnO6ot4AcwIz9qw395A1wd4FnPjc6Pvru452xjrp4pyqe9ggAqmB6vNEVaC4rX6g+QeDS5Oj4IsjcdDM1F2dyF3e0DfbfLj2/iko5dzqBttHdbrwl3uNPwnfpXBYZhDAu3xpq+omkmEBJ0yODUViVtbYz6RdDql/lCtsQrTV+yniuYbzrJ4S/ED9MUWvQEhCfEgGOPvI20erN2xU5gjK4/gUyDOnO702LLxvoJi5tiHCGg0hfYD8yJK2Il/z6remr/Em/Lcd8IK+fSkHOZtrAZwUfGu+hD6HZeWd/tQsXvzbByNdHR4lBqtDESlTdjtba1j352wKJ8YU0zwZr54Hrrbm3FP6voOXPAZ6KjMQ8g3/qk6T8+cQ3kGSxjWSKYPMr1X1Ao5nO5p8D2BRrD6dKERHpcoiGrJQ69V65xojGiYDtavE9EXqivTo0KTG63BWNrT4lxupcGOoSBEIqrbSDQcBlCptVmx
 DZkDBSkl
 ZLQ0z+hrvXxwOKJ/jdkoVFRL4Hmwr1LzYDmYo3s5vpS6+eW5+vaUctdyQfhjI51wfGCZjgogeZd4a7wg3JXuU6cBuo2azphQkBDPTeFKIoqHPoIkSIdnXpu2sw6zICqbyL5lee0h54AQb+lEMtuO7wMmK3nlmtOZqz6mHvwRQkioCx7HrdDbZM/oBr6pJEO4Pd05wIvuOZreMesqwM7Sn1EG7NlBdgndmFOfYMSVhaT16BwuyWTBSm+9PUzvKtnkqbrHBOqEMHjBuaqgR3d2+OhS1WTNJTM7PGZMCKL6EePo3R2V9alVPUP4zIbujF9nr/PC2VvQ/eQt4PQYoy2DeIOdG1tT/1vdyvEpJZs2fjgsTILH6kBQSOvm/OFaerfv2ARMBMM/Dfe3InavXz4vGQmd4G8zPXd+L6ccieAKuqUdJ73A38AJrWsm9r3aeGH5haUWgii0PZ4Tsy8hPylgEEXsCK5TQD2VAsd0qz4hBOK0f8j/C3moE1ulru0AGQurWi3fwNz0h1a37BwBiGNm/EZRsbfhQ6cH2BqSz5kOiDDWKzM/hOxVsNmdDBpPCYTBwN/7yrMGH7wvHOcOkrPXxhy2xDqE+s4ZIvGj3Kylz6uayn4edyHEDPGMv0o9zQHFuO6PptIsiurzjJgk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Checkpatch complains about this, a later patch will move the code, fix
it so that checkpatch doesn't complain about that patch. Do it in a
separate patch so the "move the code" patch is trivial to review using
Git's diff colouring.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/internal.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 2237eee030cba..8ce59c5664497 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -919,8 +919,8 @@ extern bool free_pages_prepare(struct page *page, unsigned int order);
 
 extern int user_min_free_kbytes;
 
-struct page *__alloc_frozen_pages_noprof(gfp_t, unsigned int order, int nid,
-		nodemask_t *);
+struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order, int nid,
+		nodemask_t *nodemask);
 #define __alloc_frozen_pages(...) \
 	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
 void free_frozen_pages(struct page *page, unsigned int order);

-- 
2.54.0


