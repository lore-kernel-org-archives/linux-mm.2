Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 159BEC98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 17:06:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D16186B0088; Wed, 23 Sep 2026 13:06:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC6AE6B008A; Wed, 23 Sep 2026 13:06:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB7F86B008C; Wed, 23 Sep 2026 13:06:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88BCC6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:06:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 22E181C35DE
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:06:50 +0000 (UTC)
X-FDA: 85245656580.15.A9FD726
Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5547F1A0011
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:06:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tVqYdqm7;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 74.125.224.141 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790183208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5/Q15LjQU6IGrJSXLhgsnwxABxyY9NVXcvoSHf7b9NM=;
	b=8MJ+kKcQJhAGImPSehE0Fch3Uh5OO/zGfbwdgAKGrNJwhsECcMB3FnZiTAddrOjFHwgCvJ
	2qiFVGQg8ax9a/k0lYQbPv9b3i13SZlgp/qcznuUiOyz8QRXYl7iDTAAGGM8rYqGHeMlOQ
	6mg+WO1UiS5tNlJnV7rNZG13FSKW1e8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tVqYdqm7;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 74.125.224.141 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790183208;
	b=UK0afmBUMSxriBCknCEvduwjIzSYXYmcoRWYuBqNdLzb84UiQe9Q3IImchBkW5Qnd+m8Mg
	IrkDhimHvmWTCiU78NJr2S1g76NSi9qsySAWGFvnmMHeydYvHvP/LDobqH9BJqGOvSxWk0
	JSnzq+BHHV6IkdsyOxjzDY4qxX2wPjY=
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e4ab20a33so1254596d50.1
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790183207; x=1790788007; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5/Q15LjQU6IGrJSXLhgsnwxABxyY9NVXcvoSHf7b9NM=;
        b=tVqYdqm7xpih6bye0JS44ewQtk6/uIxnI6X7m4rYf1GjJbPRPaaBtSjZHd343voukt
         mAx4hpvSlWo2Hjj28DQD9wi+Wiaot1/dB7uS/Z1WRwq+waTCMCTxfSU/qNf4lWKRCSjN
         ngOr6qPqKnQt7dsD0Drs7fhp5e7SSUMCNDelNkcGO8GIEEx5Nef/YX0JnXoDnt8ClM1u
         NmhRgR3EBu2XRYVL8t3kzRUrkM+NiPDAy72YPafg8YoPaTVJUQcNEEj00l/eBSBBh5Ni
         tc2nR8xyYCiwiuH+3UWkqa1sqZUqFWsnOb+s2mbb+0L1VKyPO1M2fhwo2yPwBZ1dghlF
         ir5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790183207; x=1790788007;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5/Q15LjQU6IGrJSXLhgsnwxABxyY9NVXcvoSHf7b9NM=;
        b=IbAhNwZrRqaeRbfIrFCnZ1iDnYrv28ILQgR3saVw7WMwamwJQ6QzjeeYABgTfMwNoO
         TNWyrJcwTmTatp72KzaB9rdHOB3K1QTBW+DuZy/k9mFMST0UbX3iAV8nfs9Tk9SXOKpw
         fsyQA/6HjImmHxEukYl20VGUOu3k/kUTfLBiRMuTbxruvpEKxYt/w81sWru9pXZujTOR
         AN9YwOlOmlTngCmFnn/XCro3aAuRfuD2RH++PvI3ysbKeqeMHt5lS2rdejvvGbOVfdXU
         hsPWJAyZ1c0IQYAE/yASjthlYImlHbo6JNwACE+LHUgt3zkSvxDEt+61+vi76YQwsPLv
         PjgA==
X-Gm-Message-State: AFuF++n3mxILiJka2jt2Y2NwC9KkzEDO+I4NcHUfqNdAHZHDDfsltNo6
	LgGGu9s5aaSix3uq17n+m1bgcHcgH3buTyUP9OxeI0gjkzj7Z+fDLCKBgbSbDFq6PAc=
X-Gm-Gg: AYBFou32T+l7iuQ0kscaMacf8IpoKN618ii0UafPAHW5dOovG+n35VEcNJocumpprKq
	hB0PsPLhdpdRJXqpdBwr2p2aWbF1ZEM9KViRBQLe3cnQtc4wquPccmlM1P3UqqX5plWGqC6uMYg
	/wzdPdg+72pcevXk4RL/04h1fFryODKwuZZF6Mc3rX3uJZ3okbPHyyhO/G68IUZynZM3Zh5ZflZ
	kN4UZNGVFWfv78i6bIZiFmy+CDUdwHXcg3z4P3AUQYhoJKIea7ujb+Jg02hw49WzO3WvMDlqh/R
	Zkj04iaooo60qKNiOgw+0BejgkJ43yI7SLsVn0anuvkQ24HE+9kf0ygIc5LddBbAqflazFNQ/Ev
	b76s9GbAaQJrEx0RGCiH4gWkGzoQCn/f5WgJkgxfgr1SpTPKeGVbGd5JeXRrZRLTTuaCpuzzID6
	683Bx/aCdk82sqZl+EKH3dvNnGYh3t9gsTzdZLNHPg65PrNeZFYNgRW7+aeDpFumuU+XaMs0wvn
	olTzmjcJvGcs5u5yRL+EBkulmy4BnqkI34Wqtb3NQLRrOk4+Ty9aAs=
X-Received: by 2002:a05:690e:1743:b0:672:99e0:ebec with SMTP id 956f58d0204a3-672d5956963mr1045386d50.132.1790183207298;
        Wed, 23 Sep 2026 10:06:47 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c248cf620sm269920985a.43.2026.09.23.10.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 10:06:46 -0700 (PDT)
Date: Wed, 23 Sep 2026 13:06:45 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, 
	liam@infradead.org, david@kernel.org, vbabka@kernel.org, jannh@google.com, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org
Subject: Re: [PATCH 05/10] mm/madvise: factor huge-PMD folio processing
Message-ID: <arQGK4RbYWYm4En7@gourry-fedora-PF4VCD3F>
References: <20260922235830.2350770-1-gourry@gourry.net>
 <20260922235830.2350770-6-gourry@gourry.net>
 <arP4Igew3iL9qVKW@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arP4Igew3iL9qVKW@gremlin>
X-Rspamd-Queue-Id: 5547F1A0011
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 68e6hmh95jkg5p6no4t9ud939op1m9nd
X-HE-Tag: 1790183208-562403
X-HE-Meta: U2FsdGVkX1/6wmeTizNgK3sex289T7TlZioZgskA13hGr9uTXe+jQJNTy7jyrwiTpBBjYufuAJfw68gpPXLxiNzkWOkKzdaHQHdcftpEHUBqXAMGhogqJ2pa8urinakPNbQGynsqUMbOeGJdP0Job8yYuLIt5eSh2QdfSGNy97ancatLoNVeG9sFn/Ci1a9eFcaRY+DlDTiEBHXwXcnyGdcxoL1rbi/OKSafC8yxQLu546x/xrwL1dw7JYYr335RpJKEWHpS+xqQH6ovCbxTC85qScG5Ew1kQLAHnrVCZgVbgsQkQJRtfAugBMAr6zdWXEu++WY8cvKROBz0X2fIrrh7/gL24Y8BiK2cOeRtY/xcowbfRieeRG51TpX7Aw2n9grMENwFmP5FuwEjFZEHHmEVhHztAji3YJrItqf7ghOTE2lrAXcV2v8T+NNX6xzFsMpg3J4O9e8fvQCK/lX1kjuyDDXOpy1q+6i5wlwV8wEJpxbX7VwIQRzHNO6cp25Kl7srC0ohziKBmRw5Fwj7LcZk7e6BJa+Oa+B5lO9uKpDIdkygC5mmffWemKhBtZzNl2Du4fCqly6k4OnE4vhACWZ7zJLkeDsnAzU+D7hgNxvKQMw2LOCOm69IwPMRmqk5YmCVVqcUEPcc6Mglr89T1f958mY/68wmToRVsvGiJ5RLfYgwCpnphPzqs9RTH5LWSDUwjLqILyY6zB5TZaOrKdzA5bG/8tFKc1LphHORliKQJQK346WxHqapFYSygb4ZszmM1AsvCq9gsSwoZkhBdX3LJCFWBrBfQpp+pJwQOauGDfqFNWJL/aXrd+VuUuQlcOkVzOkcR7Fy5vgdt8f7BqIPL5ToUGdRQ1myk+iDKN8Bf8JQjqp4gr2I8l7AmmAvNSofmFAg0GDl/+4mzVZo3DDgIXaTvTjByR8WB9UR40IHnBoGF2NEDK0Fth3UH8IRAkyYtBEz2ZeKlu494MS
 Z2fHrD/B
 fZ5HI+fWT8DDZwKsJuZekkrcrn/dTPJkVY2jy95TlrPY5Xu5N+u3DgBjQxq3JaRoKwdKsQI8NdPdnMIUpFxWjyb1TpZU9i64qKtBWdNXBfaTjl0z7ebiZ3D2A78zdkJFSS42twAryvQ33pW1qWus6R/98y1ErwKyW0FydR2EfsvZvrGzTMl6c0DCrc68nVk2IG2ZC1ix0jWHap9e8TxtX7nuc17FIoeTTsenubE7dT3ITp4WdHjlUW4BH7WaZKVDY05yg39IUNcZ9Qj/24jsCCG++Z1YxdaRmckkLj2MIC/sNKLtVYheYp4s1dIg1j1RFvfCBxha0t5MB4Qw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 05:43:59PM +0100, Lorenzo Stoakes (ARM) wrote:
> > +/* Return a locked, referenced folio only when it must be split. */
> 
> I find it really weird that when it:
> 
> a. succeeds
> b. mapped folio is missing/invalid/filtered
> 
> In both cases it returns NULL.
> 
> And it's also weirdly returning a folio in a kind of failure case, or it's
> more like a defer-to-the-rest-of-the-code case I suppose.
> 
> I wonder if the split could be done as part of the function?
> 
> Then maybe have it return bool and document that true means it's fully
> processed (invalid folio cases, success case), false means that it's been
> split and the rest of the code should continue.
> 
> Awkward one actually.

Yes this was an awkward one to futz around with.  I took a couple tries
at it and this is ultimately what fell out and passed the tests.

I think there's some tweaks that could be made here, but I err'd on the
side of "don't break shit" before I went twiddling.

It is at least easier to understand, but certainly this shows how poorly
the original code was structured.

> 
> > +static struct folio *
> > +madvise_lru_huge_pmd_locked(pmd_t *pmd, pmd_t orig_pmd,
> > +		unsigned long addr, unsigned long next, struct mm_walk *walk,
> > +		struct list_head *folio_list, bool pageout_anon_only)
> > +{
> > +	const struct madvise_walk_private *private = walk->private;
> > +	struct vm_area_struct *vma = walk->vma;
> > +	struct folio *folio;
> > +
> > +	folio = vm_normal_folio_pmd(vma, addr, orig_pmd);
> > +	if (!folio || folio_is_zone_device(folio))
> > +		return NULL;
> > +	if (madvise_lru_folio_is_filtered(folio, pageout_anon_only))
> > +		return NULL;
> > +
> > +	if (next - addr != HPAGE_PMD_SIZE) {
> 
> NIT: Maybe could define above as:
> 
> 	const bool spans_pmd = next - addr == HPAGE_PMD_SIZE;
> 
> And then make this:
> 
> 	if (!spans_pmd)
> 

seems reasonable. ack

~Gregory

