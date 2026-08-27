Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 135E8C61DC7
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 10:01:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCE016B0088; Thu, 27 Aug 2026 06:01:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7F306B008A; Thu, 27 Aug 2026 06:01:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6D856B008C; Thu, 27 Aug 2026 06:01:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 754E06B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:01:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DEB241203B4
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:01:23 +0000 (UTC)
X-FDA: 85146606846.27.0B587E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 20E0480007
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:01:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qj2sBYWZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787824882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ha8pGPo/Vk1a8vy0u/+G+CsODbW5FM8bJVA0ZN+VeE0=;
	b=0ri+PC12vHLtnpZhrfgYO9fLZi9dn+afU9s0bcef+lSWsHyQ5HyLPlW5owRA8BTe9zG9+R
	3ZbVF1+rqbi+vId3O5aRH86tTlYvftn2SUx2jh+gNji4X5UKhXkcopbpSpiwcLnlA9csO5
	yPY6LRwIU93JmRBRoA2nRnbryroRxHw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787824882;
	b=RlNCQdmJVPwX7pD61+7wzDQiP3DKd8olE7JP3if+iEdgwpSrc4MLmEdUzJsoxjaj+VQHrO
	1qsVK234/yGNaqRgT8erFT6oKM38W2AtNG8/2JBQ6TT1WqcstwmyqfLaKEcjjM0aerVefT
	RJ/38x9z8vjZpy9+SsBxQmpw2mQ8jjI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qj2sBYWZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4DF8840D68;
	Thu, 27 Aug 2026 10:01:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E891F000E9;
	Thu, 27 Aug 2026 10:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787824881;
	bh=ha8pGPo/Vk1a8vy0u/+G+CsODbW5FM8bJVA0ZN+VeE0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Qj2sBYWZwiva+P1NlipMS8mTF7EK090UuLZW8z0ydcveYrZ4KMzL/xnyZzQUMG+TQ
	 dOJ9EO6Dunqza2gGuu+qlSdzN5dAm5a+ZYZI+R2d6+Rx0Uj/El0sAP2C81VvG3JP5Y
	 HyfbO4A1I7j5gOTWAJtN444EBw2IDM1ruWsw/5gWgcgicG/+x8r2JIRGcbZ8GT+k4A
	 TVXd+UhWnYCZPlatanxxo3FJrj/LJY6NX4uGNGXE2G8YWwpbCukoVu0BUDcgLyGyGo
	 bZ+Se7WY+qrdGDODkAHoKuKDLuuGuqNYZ4KeeDT+lOtVEogDAkjOPWWdzM9p04xzyW
	 qkVd4xTFA9niQ==
Message-ID: <dab040ff-e495-4e7f-9932-c60b8299b89f@kernel.org>
Date: Thu, 27 Aug 2026 12:01:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] mm: gup: cleanup gup_fast call chain
To: Aristeu Rozanski <aris@ruivo.org>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>
References: <20260805035847.936054733@ruivo.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260805035847.936054733@ruivo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 20E0480007
X-Stat-Signature: 7coc3joii4hf5kfgnc56pp5rour4tn8n
X-Rspam-User: 
X-HE-Tag: 1787824881-22537
X-HE-Meta: U2FsdGVkX1+pEuaxJi2pJ2FxAQ2KI4SidroVkBfCmQ/UFJww5NQGsORZAkkA9zQJ6ujI9u8n9pd6L+LC/JPgTjUZMUM54cMRSv7qgpnqMiSOTD7+u2fHGEBGIqZS2EcUtZONynyYtRQPV3oj7ERObR8vW+2J/6F8VwGzcRWm9ctisgqdcHxWk1wlpib+cImy3tlog6478duIHA80lbZwXdy+4CAyOokEGImnU+xkA7NC0XnKOwGQn3OSvIssXvrMOUsMGtTnz+yGuwdAdkeda+pLHNAoUTJYKr9w3EGniNxOv220tFzIINsHthR8SrJ1Hp3im/OChU+wI1SdbLldEwULUQ8a+tWlxjV3aSGejRf4h7RRwpqVoLA1FS3k7yTyweMMBa+B3gRaiWQiHm+ztANjc9oaiXiiXwLzoHsKAozpk+JfU1M4/N0NrmQohLk5QIK5kwzwqUggRMJXcXeQ/IRkrpgY4HnMLamzjzIQ6/4LXBEYrrHezmmD17Rb32A+t2ZENouquqwAQEw72PlvqRTs7C4LVsvLAeLxKJQ5H2IG4utmRX7lWpvE1HEUEu1m/9MScp51kqIz87aN4alV52Q1Jg+juFgHLYkxiqN/I8W1wjfuwz6O+84fr32Y3jOXSJZ7i8mv6kN3X0zIPcSrU4HyC0q2CmyGchIbqPyfE1/xX56CS4shYuV0NK7IwbJZxdrGUfUu+mSvb+lEIjcZyO0/CGsVaXePOIjoLrW0r38QZi3wzp3s2s7sBK0iyI6TfOyx6JYsWCBuazngti1IaCTO89WY4LiCdJ0UP8qIl+v2erW727TtzINU9ep28MFoWMxV2VizGbNm06kBTeYDDufhQKnIWFNJTRBp21oxWHvFRt2Ted676/zrzwZ64i6JMnX+fo1weYpP+qV+72becFRn3temTki7oAtGXr5mPuX6o7tVETwk277F68ST1AYNq6LHib7XWc1QXzPIKdI
 FvWZ90N6
 Z9UdKyatVjtOcLzrvo5Y2c7BD9bbMGeWhd60g47KaO+LBE2DgJnFgPvMUoFLWJ15GAYa66IzGFyNAQ9YixvjwkTh/oND8jyBNkqNpLBnOWku+aR4PIuoryninN8ubcz3ZW7I/nLcy5owBb7AXa+SYTC2T2MgPMZv/cH6xbyl0i5NdBMAQGWYbJmFxOSxHN12+uccbj3sZf737JXeebjs06NuB205Fjb40vipAvIYR5j6WZ+zFk4WW8h3C/7gwpP48qEMLhdNEj56OTgbVwaLfwKsvg2Cf9GLKgVGNFL5CsaI8YWWNXeQwK3DpOaFETcSrYXDWM+LB312ebt08fJQop45PbsIdX7XMPRq58nP/Rm1pQne7ZJVK7a/2nkWrglFb2hhmsG7CZfvAUCjDmZcW+EWaOjOVSTEg+yb7JvuY5vvSCIaJAgfgy8eXXenFdmL3VQJww0RPFOQDMTDg1snP1SXJP7TvR/RZTm3zeXVxUv4IkKmej8sqJt9S674jBJr8RZ5v1ZpXYw8rew/Xx7iqQ19FCjSj4VAumvszX65PCGYSAE+HgNvEbGnopmDgcE5yWgwmOoUf3kH+Sti5/KWfXuUkW/qHK2K+JRQy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 05:58, Aristeu Rozanski wrote:
> These two patches implement the refactor in gup_fast call chain David
> Hildenbrand mentioned in
> 
> 	https://lore.kernel.org/all/85e760cf-b994-40db-8d13-221feee55c60@redhat.com/T/#u
> 
> v2: removed unneeded initializations on the second patch as pointed by David
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Link: https://lore.kernel.org/all/85e760cf-b994-40db-8d13-221feee55c60@redhat.com/T/#u
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Peter Xu <peterx@redhat.com>
> Signed-off-by: Aristeu Rozanski <aris@ruivo.org>
> 

CI flagged that some test cases fail:

https://github.com/linux-mm/linux-mm/actions/runs/33031249149/job/98384037627?pr=3620

==========================================
✗ memory failure test failed:
# not ok 1 memory_failure.madv_hard.anon
# not ok 2 memory_failure.madv_hard.clean_pagecache
# not ok 3 memory_failure.madv_hard.dirty_pagecache
# not ok 4 memory_failure.madv_soft.anon
# not ok 5 memory_failure.madv_soft.clean_pagecache
# not ok 6 memory_failure.madv_soft.dirty_pagecache

and I can reproduce locally.

They do use get_user_pages_fast(), so it checks out.

The following fixes most issues for me (there is still one failure on my machine
but it reproduces even without your patches, so might be specific to my machine):

diff --git a/mm/gup.c b/mm/gup.c
index 9b68242b6b602..a4036c02e2137 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3010,7 +3010,7 @@ static unsigned long gup_fast_pmd_range(pud_t *pudp, pud_t
pud,
                unsigned long addr, unsigned long end,
                unsigned int flags, struct page **pages)
 {
-       unsigned long next, nr_pages, chunk_nr_pages;
+       unsigned long next, nr_pages = 0, chunk_nr_pages;
        pmd_t *pmdp;

        pmdp = pmd_offset_lockless(pudp, pud, addr);


-- 
Cheers,

David

