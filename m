Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF440EE2086
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 10:33:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60A036B0089; Fri,  6 Feb 2026 05:33:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E1EF6B0092; Fri,  6 Feb 2026 05:33:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E0586B0093; Fri,  6 Feb 2026 05:33:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3D4706B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 05:33:37 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F1A16C2A4D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:33:36 +0000 (UTC)
X-FDA: 84413670432.11.9269BBE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 58524100003
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:33:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DJuP5dfG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770374015; a=rsa-sha256;
	cv=none;
	b=Qwi6F5nmXjL+h3xPXAlGgOVsH4+VgypLIWGlqSylbe//gQ6DAt/WSd9OxEWejvMv4zyJFh
	4eALDtg7xmrfoMADrWkvRclGU7uXMa/sSlHGl4UQer93wyRdp3boXGi3ZYDud1jaAiosIt
	lF9aFVw44uocW7mzee51dJVvbAc37Ck=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DJuP5dfG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770374015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TkNiKkBVOp4K5FBUBklXQqfMQofsnSmilhOPuHp055Y=;
	b=fiKavdFsNNvsuaSHyGZWxnlDS8XydQQ2Qx8UESP5x+AndYhsrLs02TPtk4AT2FYL2RW47m
	bxjvFNXnDc6W90jnmF95zUuD2ocC0L4Fe6rBBTXdLFKbZXSANzqjUc+ifB/FuJYmi4sbtz
	uHUwF+8o9M8p0sJsqBoRoGWfyzFKXAA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5849144298;
	Fri,  6 Feb 2026 10:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3688CC116C6;
	Fri,  6 Feb 2026 10:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770374014;
	bh=XYo1Bu4Z7S2irBnPmK0cUuY3APoWfsJPzLU5AbVxZiM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DJuP5dfGNup0UecupdTKDOZY/t3DMl65Gvrx8TJiPRtWXi0nV9UAtaWbFPEJkfDSr
	 byvc7MnpZmrG3XMadEmaZKyNCBcNMoloWeQk/YbYTBHTjM6Ajv8ywz3WR9DtxAVu9E
	 giDjB14s84H6d1F2lucnVQiz4zKFuL14jbMIJMyQ2S9tVFJyXzc98QHKhelNGWSJvA
	 756vzzt3HzNDLE5tYqHxwMN8Cu2sdb7mLb32aDFBffCypg4CQD9tVrddgUAtOJ6YNn
	 e75Et3HmB+q9TTZlibROt8vCZbi8HUlPZhMa9skXTUXOlzpmRd/POa/GP5n5tBmA/f
	 eKaT9T+XjBRxA==
Date: Fri, 6 Feb 2026 12:33:28 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-mm@kvack.org, Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH] mm: Fix memblock_free_late() when using deferred struct
 page
Message-ID: <aYXDeN0WGQG8-cxe@kernel.org>
References: <ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
 <aYJBBs17B-SQXFqq@kernel.org>
 <279931074239b7f3812c4cb3969f887303c8cc26.camel@kernel.crashing.org>
 <aYL3zxuTLT8N7C8-@kernel.org>
 <c3769af482913dd7ee9d5302c8afa990255691a5.camel@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3769af482913dd7ee9d5302c8afa990255691a5.camel@kernel.crashing.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 58524100003
X-Stat-Signature: 8uww46kqm7miy4e5axwu7o4mmewn4145
X-HE-Tag: 1770374015-877020
X-HE-Meta: U2FsdGVkX1/MHq849Fo9J37EdgqmSNnCOkIvzNkfXdRW/iJQYtMaKj7i/xCWx7e0ymv69qzvldy3E54CIRpcvUHylRuQE/3ymaVVzel4+fsZBa0MIqJmDD7HimEbGLvNgBNRdaxDC30a1waW8CS0xI/TIg1gVaOyOB5hA33yvXsUPGEzk0OW2q5BpKST0qqAb0a0+fWWASomP0N36ToDmdfN3I7bXKW84+LpeJkzvNa/9K8UxgyT/bwtc4Ww1b6k2+J64hQLb9ctzbJWQTWqc6YUYV7wiJX/yvg93G9H1n50sXCUa5sEUlwUUGn57KeSwWIaTdOuIgo14VOQ+tQdW7Ik+JnK8mZ8V8mQpjgedxQMhFyDvIq0DHVXujXSYOfbJZ0p81Q+ySzXqmyMvuztwf/aGtu76bmXmKa+pPfV2Rzfa6gI1IIeMhEVAWoFMNZw3YnIbH4ugme18TTo3uButcX6WHhPquIehnCP0HE2n0gVMa2v1WTmggSaSIUaKHdUa0onatox5vNQ0a8AaNcmV4hHLLI8Vd/8DXL4a+KzDYeOxlIxJiY5UuXt4UkS0yTz56n494UYc4F0gdZfS9wskcn27jEyiULmntKFnEc3adaAt88F+CBhjXgo+ssQ/2X2Ms5odU7Hz67T7B7xrKa9lDwFjT38Mr5vRWp/m9Nr1rh2K+ffesBKAyW2AgSgIOg9Hg0Ye+ce1QLsJEKBm+Fo5I3H59CeOlbl+4K+s+FzIr1UFUvWmo2tz/sGExrGkvF017lwpj1oNcdaDe5UOduANeLOh5mAF2bvOHeFbzPghfzeXxCXZe72RIkS3C9IuLDuzIvc6azTTHN2rRwpqDlF7VGAxiDBk+Jp4Vu4iushGmFN1rpgKQGHPrOhyisHVefc9nE9FV/+MgVeQxPR6jPklcKS7gA+tMn9at23d3cMBwe/byDveX7nyVnZEmdiAjbWDt+6GWIXAYosIeEE4qY
 C2uo4WDO
 Nc5/TyxX2sRVXABKOuCPm/uBKYtx7jdSf8vAMLmT8NtHBgidlYDGiJhkOJbAg389JIYK6Ev0a3fKLPbpHKpEQ4/Gur9yvXPT8thAEW0dQfyGOyPv3PJivjn7IgvFYWzgyc3+nzGw596Fl8EtLSFgYHWaL3OPMMT7eV5lMAiZ6M8+jMoak8OpM8I+KGI9vLdVPyCX7jPtjQemviRDULFDtEZp/UQmgcGoNYHGJ9HuZL7Ky6NTkYxz6mCEF9JcZZ0lxWF7xcNjxGi49wedGFFodWimr+Y/HtDfzCPmeAV6kQ6ZM9Fc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(added KMSAN folks)

On Wed, Feb 04, 2026 at 08:02:13PM +1100, Benjamin Herrenschmidt wrote:
> On Wed, 2026-02-04 at 09:39 +0200, Mike Rapoport wrote:
> > > I might be missing something but I don't see what would restrict
> > > this
> > > to the early pre-initialized struct pages other than that
> > > early_page_initialised() test, so we can't rely on anything in
> > > struct
> > > page inside memblock_free_pages().
> > 
> > Right, we can't rely on PG_Reserved being cleared for uninitialized
> > pages :/
> > 
> > But I overlooked an easier and actually reliable way: use
> > free_reserved_area() instead of memblock_free_late().
> 
> You mean replace all callers of memblock_free_late() and kill it ?

That would be great, but with all the subtle differences you note below
it's for the future :)

> Or make memblock_free_late() use free_reserved_area() instead of
> memblock_free_pages() ? :-)

Yes, I think either calling free_reserved_page() in the loop in
memblock_free_late() or replacing the entire loop with free_reserved_area().
 
> The former misses:
>  - totalram_pages_inc() and kmemleak_free_part_phys() in
> memblock_free_late()
> 
> They also both miss as far as I can tell:
> 
> 	if (!kmsan_memblock_free_pages(page, order)) {
> 		/* KMSAN will take care of these pages. */
> 		return;
> 	}
> 
> But I don't know if that matters, I don't know anything about kmsan :-)

AFAIU, here kmsan allocates metadata for each page freed to buddy, but it
handles reserved memory differently anyway, so it shouldn't be a problem.
 
> There are other subtle differences between the two implementations
> which probably boil down to the same thing but it's been a while and I
> don't have time today to dig into the gory details :-)
> 
> ie, one does
> 
> 	clear_page_tag_ref(page);
> 	__free_pages_core(page, order, MEMINIT_EARLY);
> 
> ie, clear_page_tag_ref() is done once for the whole "order" (though in
> the memblock_free_late() order is always 0), then __free_pages_core()
> which kind-of hard resets count to 0 etc...
> 
> The other one ends up setting the count to 1 then __free_page() which 
> does a LOT more "stuff" that is new to me since last I looked (such as
> the pcp stuff), ie a lot more convoluted code path, but I don't know if
> it differs practically for that use case :-)

It does not :)
with __free_page() the pages may be freed to PCP lists rather than on
global free lists, but it does not really matter, the pages are free and
buddy can use them.
 
> I assume that the right approach here is to make memblock_free_late()
> call free_reserved_area() instead of memblock_free_pages() so we
> preserve totalram_pages_inc() and kmemleak_free_part_phys() but I might
> be missing something (and I don't know about KMSAN).

free_reserved_page() adjusts totalram internally, so we only need to
preserve kmemleak part.

So it essentially becomes "oneliner" :)

diff --git a/mm/memblock.c b/mm/memblock.c
index e76255e4ff36..6e984bcdf6cd 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1770,10 +1770,8 @@ void __init memblock_free_late(phys_addr_t base, phys_addr_t size)
 	cursor = PFN_UP(base);
 	end = PFN_DOWN(base + size);
 
-	for (; cursor < end; cursor++) {
-		memblock_free_pages(pfn_to_page(cursor), cursor, 0);
-		totalram_pages_inc();
-	}
+	for (; cursor < end; cursor++)
+		free_reserved_page(pfn_to_page(cursor));
 }
 
 /*
 
> Cheers,
> Ben.

-- 
Sincerely yours,
Mike.

