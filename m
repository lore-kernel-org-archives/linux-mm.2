Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2771CCD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 07:49:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47BE96B0005; Mon, 18 May 2026 03:49:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42C606B0088; Mon, 18 May 2026 03:49:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3425E6B008C; Mon, 18 May 2026 03:49:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 24BEA6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 03:49:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 798DA1611B8
	for <linux-mm@kvack.org>; Mon, 18 May 2026 07:49:52 +0000 (UTC)
X-FDA: 84779766624.22.F6247C5
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8B4701C0008
	for <linux-mm@kvack.org>; Mon, 18 May 2026 07:49:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sQA9gAlm;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779090590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fTTRIuI2xioXcBOay/WhZ57PMiS4AlcVkZHDZZirdOs=;
	b=dnMvbZt4iw3STWZYFydHWSBJ2ztmnfEsZuKKRVNm8ukXRKao0HhB3+pP65dd52JVq4isSj
	JizkXxliQXO9wE6TDASD9O/QGyUeAspkGpAfGthNm5aR5OB6PiNaBrV5OWeS0yUSGigBm3
	yKireS8cLXN9jdr/KaoOJE/T7NdLwBM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sQA9gAlm;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779090590; a=rsa-sha256;
	cv=none;
	b=6JvFuh4HNgjSLVPKQ45e0q1Oc1wdyajjy2ug+Zgzb/sXSQvcQpjLfL6a94N42lDOKqK+SA
	T9us2OHqnS7mMhq00l/IY/dfOp8ijIlLoG6Hy6qxwbwzmFaG47kjsOQP1q1D5tC8ZFWCQI
	JHw6ytJLSQntsakMigHt76UC7PrWbLs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779090587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fTTRIuI2xioXcBOay/WhZ57PMiS4AlcVkZHDZZirdOs=;
	b=sQA9gAlmLXajI0q10KUnEdN1uuZqCxucU3NRWLlR3WCTWt4IvAIwwMmL9Yv6cg1ak9LTUk
	GcZJgc51RUZJ7q5loEHLNQ7RZ6YM5RGuq2Q/7SkVZott8sl3sIvYYq4EpVgjv3FmqR41gO
	tjAWCElujIzm29k6iPaM4P/xnC8SWbI=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: davem@davemloft.net,
	andreas@gaisler.com,
	rppt@kernel.org,
	akpm@linux-foundation.org,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-s390@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH 2/8] mm/bootmem_info: drop initialization of page->lru
Date: Mon, 18 May 2026 15:49:31 +0800
Message-Id: <20260518074931.34380-1-lance.yang@linux.dev>
In-Reply-To: <20260511-bootmem_info_prep-v1-2-3fb0be6fc688@kernel.org>
References: <20260511-bootmem_info_prep-v1-2-3fb0be6fc688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 8B4701C0008
X-Rspamd-Server: rspam06
X-Stat-Signature: wqj5c7xu97hcd8qs1wzkorw4to94ahfr
X-HE-Tag: 1779090590-30949
X-HE-Meta: U2FsdGVkX1/ZHJOYEC3ArAudayZoLMYwQfkhse8HJm5D76OXyldA3m9oaeOmJ6FxtEPNogxAcUYWS8FLpYna8WDz0eaeENAOkrt0WwM6DmviXoOKkLyjk2mRCAgWG+jdoTCtQE2FVBGeKm0zs2ZKAO7NKMcC5omOqo/79pFl71YGK5iQpUbBrOVv39zHkBE7J8SwwsT2aUNOD5oGLTRONAHMayB3xuPd62R92Gwlmxvenb1CyuZKtADK4BZjRwOBU9EBpx2BhmT+SQgHFerGycH02XPhX07tifF6K/wgspUwJmr6aY9nZIBmimtAxbSGdRhoWDUye/70jbID6PT1fqH8POVfqeAnf8c40vul7mbmXSohXwsZPiGXsLDgFkQQqjN2i6EHRaYE0fhR9wGT8qRsmSXVa80T/NkBBcsSM/cBPqJyKwSORrGS2WsFPQ6zB1icSyvBeifCpUUgOHNmEoGwxp+FF6l6vUUHy3IiwAgCcqoOl4cRnifKZjx0zX6SmCSxkyasHQcedcqHcaDvjGDZpYVGeU8kZdOelYQV+6V3O2B0oJf5sH33Wer7+T25Iy8YvDsPuQ3VUTxnNYp+KJ7qv/q29aOEQT5aB+CkbFugGcSnP48q2FHH11QJGXsbBH0hblPHDxUGIAbtodjLMhqlGL49urBmbGNU3Hoy32aL0DmS6CPaWNPfLxsrd6Ae+sIn/MLRmUJEUuyFDG61KoUwlwRSRGAqk4oMtMv/D0P3bZXScPg/863rknW9pQWWoJxVcFiv8WA+17jY2sbqNZBkWsvvFgL7e1Z5LvnL24yVimFGLgbyDZ+dJvT7yjr4EiHZXz5WL1d601MJVApeCixEONrQnDLyG0hZeEvPfyfySLy2zuc75mUEzFHROnYjOz0Wsa8D4mLbwQOQ/ztPhmwVztUm5f2QC1F8+LZHFtgWjthRES5b+iQygP4sCsrPWlC97+UD8QCQspDsh5V
 7BlWAAv0
 QIam2cju8pVhoCvyy3W/mS53PqF9ccFPPdQuxg1fyIKYxILVvNcUPHLZHrHc4EF3R+l2QLPIWbPNGo8gFB6LygF68zXTc4jli05C+hvJG6Fnk46+lxSEbcePKllmZnIfxattvrYGh4uX3ovLhm3in98waYhjnPe4MLaRnbLD8O/fuMJfjzW2T21lYzDxjmzhT8aZo1asms3IS43Q+Pdxl6cAmadRsuRA5b5QUxMAzZHUelOz2brobK8kmyIWeolsTE/7RS150or2yjQmc86PjYXUxLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, May 11, 2026 at 04:05:30PM +0200, David Hildenbrand (Arm) wrote:
>In the past, we used to store the type in page->lru.next, introduced by
>commit 5f24ce5fd34c ("thp: remove PG_buddy"). The location changed over
>the years; ever since commit 0386aaa6e9c8 ("bootmem: stop using
>page->index"), we store it alongside the info in page->private.
>
>Consequently, there is no need to reset page->lru anymore.
>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---
> mm/bootmem_info.c | 1 -
> 1 file changed, 1 deletion(-)
>
>diff --git a/mm/bootmem_info.c b/mm/bootmem_info.c
>index 3d7675a3ae04..a0a1ecdec8d0 100644
>--- a/mm/bootmem_info.c
>+++ b/mm/bootmem_info.c
>@@ -34,7 +34,6 @@ void put_page_bootmem(struct page *page)
> 	if (page_ref_dec_return(page) == 1) {
> 		ClearPagePrivate(page);
> 		set_page_private(page, 0);
>-		INIT_LIST_HEAD(&page->lru);

Yep, that old INIT_LIST_HEAD() call was dead cleanup. page->lru and
page->buddy_list are in the same union:

			union {
				struct list_head lru;

				/* Or, free page */
				struct list_head buddy_list;
			};

and free_reserved_page() passes the page to the buddy allocator. The
later buddy list insertion will overwrite the values written by
INIT_LIST_HEAD(&page->lru) anyway.

> 		kmemleak_free_part_phys(PFN_PHYS(page_to_pfn(page)), PAGE_SIZE);
> 		free_reserved_page(page);
> 	}

LGTM, feel free to add:
Reviewed-by: Lance Yang <lance.yang@linux.dev>

