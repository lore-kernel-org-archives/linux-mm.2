Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1452CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 04:40:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F06806B0489; Tue,  2 Jun 2026 00:40:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB7BF6B048B; Tue,  2 Jun 2026 00:40:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA67D6B048D; Tue,  2 Jun 2026 00:40:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB4406B0489
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 00:40:35 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6CA51162AFD
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:40:35 +0000 (UTC)
X-FDA: 84833721630.26.2CB84DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id CDEBD1A0009
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:40:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AVxln0DQ;
	spf=pass (imf19.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780375233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=srXwF/yhg+rbIcHkVtsiegnwql9Xlps6nvacpPywWg4=;
	b=1DPHeWcBKAJWJmfdS9LwvqEhOHYyrdxfktxWUf4wsLqY8XZp+n0yk+sciPXBZmhp0ekhdP
	6OYK6yMMfAUGofJiSTnc3rl8LHzGabw9Cdhj960wV72r+xYQoX45Lmhl7oNQQFnc3PZteb
	+dwx+w4eNAQJXz0t4diy50n99QYYbAM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AVxln0DQ;
	spf=pass (imf19.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780375233;
	b=BGDpM25KSj1klpSMFIO3PUToh6aMtD3rxuhUsr4yU+3FT8/lwQz+IAZsUfkCTJZfvkMHev
	iB75TNEGrZcyes6GHhBFHk4GlDFrluOv0kAdNzcC8VOZc4xW3dGmc5+r1m3zG2VoKqQt8F
	jwZcrVtWa4rBWh24VefuwyhQp7Jgk18=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 568BC6001A;
	Tue,  2 Jun 2026 04:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B6F1F00893;
	Tue,  2 Jun 2026 04:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780375233;
	bh=srXwF/yhg+rbIcHkVtsiegnwql9Xlps6nvacpPywWg4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AVxln0DQCY1PNRUb9aWahhA0PjWLTKukZTz6gcf/R6ukpUVkqFE8CWcIeAncWYn7N
	 9SVxYIW6aEFeLIlpyYOFHeaEHecDbIuH3q+g5YLAKEHaNn6ZRrgsqJihYLcXVkdG1x
	 u8LM5FkmNtBFW2jPuWRqGDHrJbv/cHyD11bDv+X/qQmKmosro2X4Pg0c151+Y8SSAv
	 hQWSIBG7Hk+uobN/a+cvh066m33eGdPyJnddbAG+dmD9IyBZMt1CDCndeajD7bKPSP
	 7X0uyZ4JancSZq6PFTUoH3q4q3QPPvxzUudeqGg4m53tr/brD9qU9izIXKAOHQBjPp
	 P3lcfQWN227kQ==
Date: Tue, 2 Jun 2026 06:40:24 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	"David S. Miller" <davem@davemloft.net>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org, loongarch@lists.linux.dev,
	sparclinux@vger.kernel.org, Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>, WANG Xuerui <kernel@xen0n.name>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v3 1/5] mm/sparse-vmemmap: provide generic
 vmemmap_set_pmd() and vmemmap_check_pmd()
Message-ID: <ah5euKU9l3pP_8Ty@localhost.localdomain>
References: <20260601084845.3792171-1-songmuchun@bytedance.com>
 <20260601084845.3792171-2-songmuchun@bytedance.com>
 <db8d440d-c8a1-4f77-b5d9-00bab8737f12@kernel.org>
 <0D4AF42F-37C5-4A76-9703-44ACC6374C48@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0D4AF42F-37C5-4A76-9703-44ACC6374C48@linux.dev>
X-Rspamd-Queue-Id: CDEBD1A0009
X-Stat-Signature: 8bbty1jsfeuoxmm78gf83tnyt7d4fjpp
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780375233-602185
X-HE-Meta: U2FsdGVkX19jSbtFpQIYiIHQGWgT2LugwdrsIx640p6ysNvhPM6loVVaYHb1140G/UF4FquR6axbpQG76xlsa0GKALNNrad10LARSqdkNQ5T7b1vazrJRoQPSe88kQQdjw292SoJ/PfEuG+/7Hn3a4g0d+5dD8uqDjNvNSRW1FO4EuYWHnMUNvPrKjrSBK0M17xfMxxaI7BDzjJiZ8bC/5HJSulfoI5MzkyECsKKqM1HeZ5zG9jWJw7eb+7vzb4ZFEAP2j41KgvxUqfOnSIeYdiBQx1ZugPAhTtAfhV+vPQ269R8E0J9AeyB/oVkM5KQuEtnIf1fkRBDT0p5bVUGjvPAsWpWW0LHBJILL4Lr+KO3P9D3f8K7Lq3CgMq9vZDsPNj4FZBMu9wblaskfOYxbK2N5AfUoOTJtuMg513KwMLCDXJLePWnNqMwOtnI1d2ybISPQSrCC9g9JoHAFnH5ggjwtrrbo7/NeE9BGVBdgxj0bzmw6SBHvUVhJYg7tMbxsgHLwTc0OYf9wYUKAhszRU3j5GcWn9OETLRVGPlpe5oUzaaUtiRb8mX9r6XcnswV1xxaScMyWP/4lJXAJTH5qA1q5q+OdP+4QK1rLY//juiHMP7KJ0MHbA/UvQ3rNFdEIFxF4gWYwAonnIq3bmr7o/JDbBYPOY1JA3IJ6hR9UtE2El+wkwpryuKxpWS8Wpz9nvaf9iFAwu4fWqIrvFdg3HswrHzGyiY927VuzmixnmNo7IO7Pe6fB+kj5Uts+iwlGY3+tjhffa3JJbt3bwU6/MhilU1QFOCbam1gx2M0VC23GmEhxTjBWNdzcWkQ5/KsD+95CuXx30ggbTsDEZni1I8RSP/cX6bOhq63cOARvdwzCayEvt1n5E3ezeT/NcdNK5H9pQxizwURC4HfhH9osOIHqf+GZdqDyaGfY2uGGHpimmPCeXFZp1HffvMtyQ45BhUStt8/sq8wepnEpa5
 q7kG+etU
 2V7UN+cdq8pQCv11We1U5Ah+IIVkE4yYfhwjZBDd1AEAzAyaKwl/Y0d+BUm3u5f4HGWoMp5rfSN8F6d8N8pV+WqfFKcwLW2KJlhhDiTAf5c/r6WCdfz+kCJAoSkKynsgkjhSOeLVhuwcCHJoetN1lelbC+CtCkGFotWpXGr4XJ31pD9yX2eWeQGGIULmvMqtPpD/9S324UNl4YsRXuOQR2Ex6lhu+c9WSAvQLh3HOyiE65fWDo6XUPQ2Dq/uSMiludLO9GRrBwTBMihVI9/5xxtmAB2o77SZEQqRuEyONnac2ng14Vica2tAB4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 08:37:42PM +0800, Muchun Song wrote:
> 
> 
> > On Jun 1, 2026, at 20:22, David Hildenbrand (Arm) <david@kernel.org> wrote:
> > 
> > On 6/1/26 10:48, Muchun Song wrote:
> >> The two weak functions are currently no-ops on every architecture,
> >> forcing each platform that needs them to duplicate the same handful
> >> of lines.  Provide a generic implementation:
> >> 
> >> - vmemmap_set_pmd() simply sets a huge PMD with PAGE_KERNEL protection.
> >> 
> >> - vmemmap_check_pmd() verifies that the PMD is present and leaf,
> >>  then calls the existing vmemmap_verify() helper.
> >> 
> >> Architectures that need special handling can continue to override the
> >> weak symbols; everyone else gets the standard version for free.
> >> 
> >> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> >> ---
> >> v2->v3:
> >> - Replace BUG_ON() with WARN_ON_ONCE() in vmemmap_set_pmd()
> >> ---
> >> mm/sparse-vmemmap.c | 7 ++++++-
> >> 1 file changed, 6 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> >> index 112ccf9c71ca..99e2be39671b 100644
> >> --- a/mm/sparse-vmemmap.c
> >> +++ b/mm/sparse-vmemmap.c
> >> @@ -386,12 +386,17 @@ int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
> >> void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
> >>       unsigned long addr, unsigned long next)
> >> {
> >> + 	WARN_ON_ONCE(!pmd_set_huge(pmd, virt_to_phys(p), PAGE_KERNEL));
> > 
> > 
> > Not sure if a VM_WARN_ON_ONCE() would be appropriate. (then, we have to move the
> > pmd_set_huge() out of the statement).
> 
> I think it might be better to keep WARN_ON_ONCE here. This way, we can still
> monitor for warnings in production while keeping the code simple.

IIRC there was a discussion about this some time ago, given the fact that quite
some people out there tend to have 'panic_on_warn', but then again, if we fail to
set a PMD here it means something pretty nasty happened, so I am ok with that.

 

-- 
Oscar Salvador
SUSE Labs

