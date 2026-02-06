Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF8C3EE20B7
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 16:15:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D68F86B008A; Fri,  6 Feb 2026 11:15:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D169B6B0092; Fri,  6 Feb 2026 11:15:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3F8B6B0093; Fri,  6 Feb 2026 11:15:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B4D206B008A
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 11:15:44 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA150C12BE
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 16:15:43 +0000 (UTC)
X-FDA: 84414532566.11.AF25F0C
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf09.hostedemail.com (Postfix) with ESMTP id 68E55140002
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 16:15:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf09.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770394542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JSKxC7m7gj6p5Mhe55nQ2vOES1X8Uhz2G6OJNKPvZbM=;
	b=xrLtHFH9/yqKwuypRbdy9FHsWzSWSSMIA597sXy4LDASlXrah3fvDzQngmpWmqVYZigCka
	/z7FhKivl43HdIBbfEeZ2qSyzHRs762jDMGbaY9ejASHU1mMM14BGxOXJhPOnseT7vOTQS
	MozQhOD7rDaaJsktffNb9UTGH3DA33Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf09.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770394542; a=rsa-sha256;
	cv=none;
	b=J263ekfNPDXV2rVU3U/IE4n4xKPEtCq7mFakINPQv5L1PcysnOgyMLdvzD2VOzBAxMWdKh
	X3kGcU6Yj2MoaQSK6GKxGHf14iD7kWe3RGK2G+OzvxmTpWDsyLwHFq0gLW61Wah7vEVm7o
	6SBcp7LF8Kf6dMUmoedZLHsxaBK7JT0=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4f6zhj5R6zz8Xs5J;
	Sat, 07 Feb 2026 00:15:33 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 616GFOLT062915;
	Sat, 7 Feb 2026 00:15:24 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Sat, 7 Feb 2026 00:15:28 +0800 (CST)
X-Zmail-TransId: 2afc698613a04bc-9d668
X-Mailer: Zmail v1.0
Message-ID: <20260207001528370-qf6PP2QGXNvcjGdsLTC_@zte.com.cn>
In-Reply-To: <9f75b988-9729-452b-beb5-deab0718faa8@kernel.org>
References: 20260206180132364R_lYZujwOYfhazgKmxArZ@zte.com.cn,9f75b988-9729-452b-beb5-deab0718faa8@kernel.org
Date: Sat, 7 Feb 2026 00:15:28 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <david@kernel.org>
Cc: <akpm@linux-foundation.org>, <chengming.zhou@linux.dev>,
        <hughd@google.com>, <wang.yaxin@zte.com.cn>, <yang.yang29@zte.com.cn>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2MiAyLzJdIGtzbTogT3B0aW1pemUgcm1hcF93YWxrX2tzbSBieSBwYXNzaW5nIGEgc3VpdGFibGUgYWRkcmVzcyByYW5nZQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 616GFOLT062915
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Sat, 07 Feb 2026 00:15:33 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 698613A5.000/4f6zhj5R6zz8Xs5J
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 68E55140002
X-Stat-Signature: beqagax3wm5kqqgitw4e8c8ynzeq5yug
X-Rspam-User: 
X-HE-Tag: 1770394538-173132
X-HE-Meta: U2FsdGVkX1+oF43ZdD37skw4S3KV4Su+VoipEDGc9klLIPF4rNEBjLiEklTbWS6UUb9YJY8VuoqA5vYrbxSnrV3r7/KXTQBtlKd4SReVOC3937sC3QBI2M0yf5nbexG+9NTLhUt+uQ0pHU23/vCe6JTRPHCucUXxMjnIccyx1WRKyByimrnwdObYM4ZDbqwedRKgRZ01wtFQDZbLr9cW023TBwdwTIiXYOJJ77OxabgVOD0HIYrSv/YO80ltazYkQPA1a+i8avALMXL9zYAzOZjBqObqnFvg3bO6E8y2Im6kZaRkkx8AU/KAz8s1ibSuuVncq6Y2iS+MX7ZRtGkOMo9TdagKa2XjTpGgx7lOnQhhtnQyUv9aI3eXInI5282eHpO9FIsCvIasZda7U8rpZIe8DVbbYgHIJU7Kbrb8xG8SNKPY7WM6Cw9Vx1db7FeLHlBtcV3tSyjUZgTFfSMW4lA8/HAsf1XROvDiBxFz4YfcE8vVpC4n+O1tleNn0bQ90f+qe9Otv+CcmKSb17TWwZwxrI1ZQLuSaBuP6G9n6naHm56sBaOwOtk76WyeBNUALtKxrm1xDU4n9Jf8/7O/LXW61rTTdmtBtJnFBwkPwpL27pt9CKT5QzJG+IVpEd4EQOOquX8LT4YFNWCLm5WwQrNZd8PK9sinGPuMhi9xEE7kkDJMjstFH+o0dASfN79phuvD68ilhOLMYtrl9UQ2ioOnm+sa1RNoSeau0Cds7dlJ7jiBk9CdOzqdzkC17P88D/qgtyz1Ecv1NBnEI5l8/u8tHudnwNy63uwPNcjNQawwe/EF+meuV1hTJEE7cVdbyNjf1GAAF7s23SmfQ9Veak5VsVkLVIAGPSZeXXYuP5QAvTASP0YdZIKmR1L2/xUceYAOz6sBsR18ZM5L3+B5Mif3r+1M3BB+i9IKnRimr+1hpXFHpKkTtGfuDdmwWrOrmtDTntFNnG+DMvn5i0n
 GyREuT4y
 iT0C3WA5RUw0kCpFCQtt6rLumTJ+ru6YfZXj6Gpchj0ztmkivdAFKY1aa5AbURHcKfDRQ+QiGNByKrqW/zndumZpiWbBXvDViP1JwvFRc38d7ugP+W43ROTjeIosaWxKVP1fWd7h48I7lcdH/2pDmchLfIMoaaVcw9GYy2ybs2dBy3BsHSgci4ZnahZihhxUdCFXmVi8MGPOVq6mc/YneXd/GX+WgEl2mzv+nlc8omzKITkWLJqhZWY0aO5TpwoyiTm36GKlpKJ47xwC7Fx/bPDG37FVFudjYw5Au
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> s/Reaon/Reason/ or better "Cause"

Thanks. Fix it in v3.

> > In our real embedded Linux environment, the measured metrcis were as follows:
> > 
> > 1) Time_ms: Max time for holding anon_vma lock in a single rmap_walk_ksm.
> > 2) Nr_iteration_total: The max times of iterations in a loop of anon_vma_interval_tree_foreach
> > 3) Skip_addr_out_of_range: The max times of skipping due to the first check (vma->vm_start
> >              and vma->vm_end) in a loop of anon_vma_interval_tree_foreach.
> > 4) Skip_mm_mismatch: The max times of skipping due to the second check (rmap_item->mm == vma->vm_mm)
> >              in a loop of anon_vma_interval_tree_foreach.
> > 
> > The result is as follows:
> > 
> >                   Time_ms      Nr_iteration_total    Skip_addr_out_of_range   Skip_mm_mismatch
> > Before patched:  228.65       22169                 22168                    0
> > After pacthed:   0.396        3                     0                        2
> 
> s/pacthed/patched/
> 
> But I would just call it "Before" and "After".

Thanks.

> 
> > 
> > The referenced reproducer of rmap_walk_ksm can be found at:
> > https://lore.kernel.org/all/20260206151424734QIyWL_pA-1QeJPbJlUxsO@zte.com.cn/
> > 
> > Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> 
> Did you accidentally drop a
> 
> 	Co-developed-by: Wang Yaxin <wang.yaxin@zte.com.cn>
> 
> ?

Oh, yes, Thanks.

> 
> > ---
> >   mm/ksm.c | 5 ++++-
> >   1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/ksm.c b/mm/ksm.c
> > index 950e122bcbf4..54f72e92b7f3 100644
> > --- a/mm/ksm.c
> > +++ b/mm/ksm.c
> > @@ -3170,6 +3170,9 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
> >   	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
> >   		/* Ignore the stable/unstable/sqnr flags */
> >   		const unsigned long addr = rmap_item->address & PAGE_MASK;
> > +		const pgoff_t pgoff_start = rmap_item->address >> PAGE_SHIFT;
> > +		/* KSM folios are always order-0 normal pages */
> > +		const pgoff_t pgoff_end = pgoff_start;
> 
> 
> Maybe simply
> 
> const pgoff_t pgoff = rmap_item->address >> PAGE_SHIFT;
> 
> and drop pgoff_end? Then you simply pass pgoff as start and end below. 
> You could add the KSM folio comment above the 
> anon_vma_interval_tree_foreach.

Will do it in v3.

> 
> 
> If the tools/testing/selftests/mm/rmap.c selftests keeps passing 
> rmap_walk_ksm() should be working as expected. Did you run it to make sure?

Yes, if running tools/testing/selftests/mm/rmap.c, rmap_walk_ksm() can work, but
it won't trigger a high delay of time consuming on anon_vma_interval_tree_foreach
because there's few VMAs sharing anon_vma.

