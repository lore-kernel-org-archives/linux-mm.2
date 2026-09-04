Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56697C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 16:01:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 405DD6B008C; Fri,  4 Sep 2026 12:01:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DD446B0092; Fri,  4 Sep 2026 12:01:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F4A76B0096; Fri,  4 Sep 2026 12:01:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 01FE56B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:01:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 66CC21A0137
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:01:46 +0000 (UTC)
X-FDA: 85176545412.23.12BA55F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id B47842000D
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:01:44 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Chil6rRr;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788537704;
	b=ent5EagB5TaEvVg0+Y5lOAxSiHCKOo4PGcoeLB3DUFxFcQUqzfRc5nv/NlHHX9zdn0yjja
	htLQP3J73Xl/OFv1xS5vuM3hnkA6WY/OtrWwMq02XSkJ/issfMm9Yj+4TvefKZR+yO7u/d
	/ukGGtDa8SOlD51oVuibJZ1P9nqpa7I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788537704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8+ocR7sGCB/9B0UdyCqbIbFztIKXJYrXR0zQcU6I5Pk=;
	b=tQc8OAjnLhdOk0L/YS4HWYI9tZM2+VBNprqeVqVWtENWKFpv26MRFne6jhl6lVE0cLhVK0
	gofRBEtm2iP6dQS+9VlCNrE7xQRX9DIrn8GpQxrsDcFWgG2gAcBWzVC08y+AU/4zQnqOCR
	Qe5Opa6J48sIxRwpDnjgN+JGLSabefk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Chil6rRr;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 227C743837;
	Fri,  4 Sep 2026 16:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D48F1F00A3D;
	Fri,  4 Sep 2026 16:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788537703;
	bh=8+ocR7sGCB/9B0UdyCqbIbFztIKXJYrXR0zQcU6I5Pk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Chil6rRr5FT32LVSVmyd3qa03Z6aWYEodRak43Dgt3mp/StVMgtwJgJen31j+J38z
	 HBqo9q1Pvh2oaYpcONL8zfTAcnHYvTPF0SnAc69CT5/OYBlnIEhj5aCjlnpaPQvLjB
	 dcv36lkfAh39srnfz+qlMNJAPlKIom69Ukx5AF4QwkBFtUNtTYq0k9J2nBJESHMNtg
	 RJ+A1XK/QIuaHPP+DMw4cdQd0pDrXmya7Yg23jvT2fBMtLyK484HXXm0pGQ1QXugN3
	 eMVhHRqWzRfaIGE9kfcAtgwYRuvTRbuVD/x0MP+gJFe5o8lGC4ZWwvpgdkHH1rcsDz
	 vdWIzqbTzQheg==
Date: Fri, 4 Sep 2026 17:01:37 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Mike Kaplinskiy <mike@recall.ai>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Subject: Re: [PATCH] mm/madvise: swap in CoW'd MAP_PRIVATE-file mappings on
 MADV_WILLNEED
Message-ID: <aprjOxDy3JCPb2oa@gremlin>
References: <20260904-madv-will-need-map-private-v1-1-6b83cc99fcff@kernel.org>
 <apriM1q4GzAgP7JQ@pedro-suse.tail5790ac.ts.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apriM1q4GzAgP7JQ@pedro-suse.tail5790ac.ts.net>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B47842000D
X-Stat-Signature: 8fry8mboiwbm7zi4deg87rjgcxn9cbsg
X-HE-Tag: 1788537704-413889
X-HE-Meta: U2FsdGVkX19PI6n7SRJwAyX82QZ7/YtFZs4AtGMw6eQo+sGw0An9M1Gg9duEhL/Us5VL2QfslU1CIsj3NqTdrLNm5UPgyTFQqbga3GA7vBHiM+AURqEBcE7fwaqcqxZWakIn51mDoPC/qg/buv0XZUiMqVTj57cuv4Ud2qTMSrd5qLrFgS7jEhW0g+Aj7GYbJRyRui17T3JPAQWzUoExcKH1figYLQ1aH46cPLvP7MfewZQ8lUEe2yZRVIKaox7kGBonj7ycSv0AyJtr3Fl6tCUmO0/e3y+LdJQkTo/fTzlgKH0haHLVHuSf3rqTn22DirJs37heMNDz09JWdXDZGLYMvTQgL1rpk8BKAC0lzCflye6g5AyOPSZChiWVDbs++7lvbRk+FBaX//u5TzQkpDiU0kmWUNTdEZT6rHMHfKhvvam3TN0NR/3rynCqDR2r7eNtjPKmjC8GY1W/5E9YesuT9rEbY+pNtiKpaIMSALE3/gEciQ++JBbP7trmdQAKGtrEprWcDo3H+A5QTcx2G8ZO91LLuc/9L1by9lEWnDwOgiO2VvRaW5mcE0EORUf5N9crmWqlA2LicL4mqUurGTM3WXr+SBFknpWZfAgoxYxDbR4MBJvl8CmqLf738T3Yh/38dYOLIIQRuWIe+d+2zFsBeCMk04h62apN0hi/MxEv9uNZTo5Wtk56+BxpMflfWsal/Qcz0M0pP10CG3j/i/GSYu7VC+5wnnYAX6YWoS+laKeln5M117MD+1tqyEXJAWT+4xxmoeQtdwhHGQzIPLLEtMcdrfc76uFF2OSL9f+YVuSN68DYqBVtAO5ws5jFIqywnnX/L/u9F5hNjPbbr88EbPFYDnY+OYEAsp1MC/HXY43judI3FZ85ZZ3E0cGMeEqoO35oImxt7xa4r54laCHAvORLnSBwqZ4BDF8icWygkuodKeTieAZhrHIrxlRIVFF3Psxx/zgUgyRodpj
 PfegjBgX
 qxFwfs6qLU3vCH42DWgIprSc2msDy7t4n7nGEUY4TB0nJgSrgefpk1xVtDopLGLs/hYoS1V3UiJks15/CMoaqGVXXQSS4ERAZ9RQ33sUqGfqCO6y2P+6GLrpMalVKBa0nyVXys/jXeG6D6buDeRvGU6N+hrjxxzBL9AINr+ZDb5HtmxM2WO3Tz3tJLrdVGHgV2Fp0Dn8aS59BS/PPhwDe+FUDUbXxbf3WwtdP+Y5t7uZvpStN23ubGgk74+Ph4YrhSHHpV4vo/uOHxGDWQoFS6ZPG3rXW3hKlX943DyY/0Ho1rEbIdG/TCT212VH+/n7MUiRsKBHwleg1yPUT75ZjfN9MVRNGgQNZ4SAk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 04:24:59PM +0100, Pedro Falcato wrote:
> On Fri, Sep 04, 2026 at 04:12:53PM +0100, Lorenzo Stoakes (ARM) wrote:
> > Currently MADV_WILLNEED treats file-backed and pure anonymous mappings
> > entirely separately - using POSIX_FADV_WILLNEED (equivalent of a readahead)
> > for the former and a tree walk and swap in to swap cache for the latter.
> >
> > MAP_PRIVATE-file backed mappings straddle the two and currently get treated
> > as if they were purely file-backed, meaning any swapped out private pages
> > remain swapped out.
> >
> > Resolve the issue by explicitly checking for CoW'd MAP_PRIVATE-file backed
> > mappings and performing both walks in this case.
> >
> > Since the logic checks for vma->anon_vma this means un-CoW'd
> > MAP_PRIVATE-file backed mappings retain only the single file walk.
> >
> > Reported-by: Mike Kaplinskiy <mike@recall.ai>
> > Closes: https://lore.kernel.org/all/CABeknB_S2XJSHFgnHdgnN0rjzHhH4oQJs_APq9fvxHztQ_pgiA@mail.gmail.com/
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/madvise.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index 73c2901b9adb..d0510dd49dde 100644
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -297,10 +297,12 @@ static long madvise_willneed(struct madvise_behavior *madv_behavior)
> >  	loff_t offset;
> >
> >  #ifdef CONFIG_SWAP
> > -	if (!file) {
> > +	if (!file || (vma_is_cow_mapping(vma) && vma->anon_vma)) {
>
> Couldn't this all be simplified to
>
> 	if (vma->anon_vma) {
>
> ? swapin needs anon pages to have been faulted-in. Non-cow mappings won't
> have an anon_vma, nor will fully empty anonymous VMAs (and that's fine).
> Right?

Hmm good point :)

Though the

	if (!file)
		return 0;

Would have to be outside of the block to avoid an anon unfaulted (nop) from
being skipped.

And it's a real improvement to have unfaulted anon skip...

But I find that version is documenting what's going on a lot less.

Since both anon and MAP_PRIVATE file-backed are CoW mappings we could just
reference that.

Andrew - could you swap the patch out in-place with below? Thanks!

Cheers, Lorenzo

----8<----
From a706374a1186b6b4409a0e760e8728bcadba0c96 Mon Sep 17 00:00:00 2001
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 3 Sep 2026 20:08:39 +0100
Subject: [PATCH] mm/madvise: swap in CoW'd MAP_PRIVATE-file mappings on
 MADV_WILLNEED

Currently MADV_WILLNEED treats file-backed and pure anonymous mappings
entirely separately - using POSIX_FADV_WILLNEED (equivalent of a readahead)
for the former and a tree walk and swap in to swap cache for the latter.

MAP_PRIVATE-file backed mappings straddle the two and currently get treated
as if they were purely file-backed, meaning any swapped out private pages
remain swapped out.

Resolve the issue by explicitly checking for CoW'd MAP_PRIVATE-file backed
mappings and performing both walks in this case.

Since the logic checks for vma->anon_vma this means un-CoW'd
MAP_PRIVATE-file backed mappings retain only the single file walk.

Reported-by: Mike Kaplinskiy <mike@recall.ai>
Closes: https://lore.kernel.org/all/CABeknB_S2XJSHFgnHdgnN0rjzHhH4oQJs_APq9fvxHztQ_pgiA@mail.gmail.com/
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/madvise.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 73c2901b9adb..963337f93a7a 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -297,11 +297,12 @@ static long madvise_willneed(struct madvise_behavior *madv_behavior)
 	loff_t offset;

 #ifdef CONFIG_SWAP
-	if (!file) {
+	if (vma_is_cow_mapping(vma) && vma->anon_vma) {
 		walk_page_range_vma(vma, start, end, &swapin_walk_ops, vma);
 		lru_add_drain(); /* Push any new pages onto the LRU now */
-		return 0;
 	}
+	if (!file)
+		return 0;

 	if (shmem_mapping(file->f_mapping)) {
 		shmem_swapin_range(vma, start, end, file->f_mapping);
--
2.55.0

