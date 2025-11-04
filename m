Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 273E7CCFA03
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 01:23:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 808908E00D5; Mon,  3 Nov 2025 20:23:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BA658E0058; Mon,  3 Nov 2025 20:23:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CF048E00D5; Mon,  3 Nov 2025 20:23:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C8658E0058
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 20:23:25 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E6C7BB8C9B
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 01:23:24 +0000 (UTC)
X-FDA: 84071176728.30.80833E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 36A3CA000B
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 01:23:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EdgYUvAY;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762219403; a=rsa-sha256;
	cv=none;
	b=loax0M3iYnKWTajrJZ4U93eXROCr9LXfce0WER5gLFfuFADdixjzQwN0F6Ztc1JdtfL80g
	nzTn87lqYnQcaHpKd9BWDwkOwpb8PLKP7AtwVyYE3I0S6J6wsCSqXEm61umPxVnwR0/tZw
	I1mmpaoTq5QZdMXKy5SjXkMqN8rH+tc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EdgYUvAY;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762219403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L9ajnhOoxDRiGFYl3wuL64nz1f19StQBd281qP65M3o=;
	b=gpRXUyLoN/j5YkOa68AUO6Ve+2cFw04JuLKt+Rs8nuA17/ithyJVPSXQprInCb8c4wYdmC
	xsjO+xbnfAFSJnkmq9dFzz+s5sZaNXBw3b1cdWIb8MF4VEs9b62VwXvUYOlE4WioECQ0H9
	BgUbudNd3YgcG88MR1IcDEU+qjWRF7g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F0AC641876;
	Tue,  4 Nov 2025 01:23:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 926DEC4CEE7;
	Tue,  4 Nov 2025 01:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762219401;
	bh=O+EbnOruKhiIrqCFK8PK7/fd3bCIQqLDIo8Gmu5gXD8=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=EdgYUvAYaqJ4iE8rYLjZnK2QIlkPprTnCr88K3m1l6ewi6mUMHyNC3jl/5qjpCZmJ
	 rSlcoRH1V4Ijowsw6+XnYbz7c/pJXq2Yz/Xu0h3elPEQtBgNAfiYr7X3LN5LDSum1g
	 wpRnmKi1RJbzz7C859LT39PqK9okofTjRhUCsP3w=
Date: Mon, 3 Nov 2025 17:23:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pratyush Yadav <pratyush@kernel.org>, Baoquan He <bhe@redhat.com>,
 Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, Pasha
 Tatashin <pasha.tatashin@soleen.com>, kexec@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] kho: misc fixes
Message-Id: <20251103172321.689294e48c2fae795e114ce6@linux-foundation.org>
In-Reply-To: <20251103162020.ac696dbc695f9341e7a267f7@linux-foundation.org>
References: <20251103180235.71409-1-pratyush@kernel.org>
	<20251103162020.ac696dbc695f9341e7a267f7@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 36A3CA000B
X-Rspamd-Server: rspam07
X-Stat-Signature: gudju14ikmhii7adcojf91jokz8nj8pf
X-Rspam-User: 
X-HE-Tag: 1762219403-615363
X-HE-Meta: U2FsdGVkX1+Dn0AhGmeCtOh/8Umg0mH1i1sJlaHBWN92X96BLH0+LNauxSADFHxIgK6zSwB7kriwYG0E3fhagERALeylhai4WfDOpBJi6Jb5Jq+dNUPXvneeAASdE1Dj0arJ5OvRId+uOD/T2CKR3Xhj1RGqAiHHVfDM4lYDDflbFRNxLw9uH+7enXx+sbiT4nP3lIqV946iyKgGaNsQcED+QSkjQoNk0lY17to2eDntuNuaF+SCAHozOST1mmHHNHor3CD90wAkepDRsKipqiq1bSDJPPeUzOogZQlDDMw/iENZuF0yLemMKvyCSSfiAgZlN6bO2zReH6eL/qUdR68IW71NPAlxokEq/UQK1AWUxBCTUYwh0B7uJwDAUR6R6eoN3i330mZcHHdepX+W8+kZNf2RkEyKtt1S+eh77AFAeFeCVd+on4/yPgt1a4g6thxuFQP8WCWV5Ze1GIRdIZaY1wzKhV6oAHOdhUEvg3BvmwB+mRumVD37vnKPaerYzchmiY1K4waNtUC0JS1KSYRhRDoj4NJnREoFiljjC9KZXT871iov4S0ul0u6jmeMvLp8hckeoSBj8Ya4aKeRaVzuIJqu75Np9lnFuIc/KFepMiPsvJQnA1TL8g7wpOOL0qhRz2qyd7jDifACKWgfbjuv/PBs8ee4Narfz4Zl/9GH26h8kA2zoCvd3lSHZ3WDrkbJ6uSTcw5XfLr4FSczjBk/I1Hdzm3ska0PzdZhiNMZ2+zKYy8+Q+yF17k9rtnDiLIKgYYOwPqbtPQy3Q0YzNKNMx0UsARpBd+WaBph53N/CT7MISJy6lC1zuPPfYq35m99kpYcLbXFA+9BheZBR/MOHdSGJHTxpBDU/+Yh5JfesvR7nl/juTy9fABnLnnpoIJ/xN5GTZ1uzs3sXXbZAtJpmIlkzCZkkjfhtI7QbmDa6rE7MBGzhXVFi0aNTwfsmyhHlqqrdSQBKUxE7GT
 cqAhyZWt
 76j5JLee+XtoG0d6qQ2KYech8NMqopJlQ/KMheF6EckFsLcJKO36IWrVap+g0/wSpyCkAx1oTVLKUsA21/DoB97+huowv5DJpXfBnyKFRPra9pkJP8WOFEWtzhMQh5VFRjSOtvTFW/8yakJEbwcQkFIyWmwg0WejZ7EIs7Eqjq6Hoj/L5kG3ynP/oxvohEuZDoWq/uYeLLYgUnKR2F1aItsYwrnjbXtSVvBShCob71lEqw1pyg5ulm50NCiBKYGdZyoC4Fj8z6DKNHx4RWyiA/c/lFJMHM6PvlTvtH1vC7ACAS8HPDCY/QKMkHZm3KkhUPyIcAIa0tPrOVgU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 3 Nov 2025 16:20:20 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon,  3 Nov 2025 19:02:30 +0100 Pratyush Yadav <pratyush@kernel.org> wrote:
> 
> > This series has a couple of misc fixes for KHO I discovered during code
> > review and testing.
> > 
> > The series is based on top of [0] which has another fix for the function
> > touched by patch 1. I spotted these two after sending the patch. If that
> > one needs a reroll, I can combine the three into a series.
> >
> 
> Things appear to be misordered here.
> 
> [1/2] "kho: fix unpreservation of higher-order vmalloc preservations"
> 	fixes a667300bd53f2, so it's wanted in 6.18-rcX
> 
> [2/2] "kho: warn and exit when unpreserved page wasn't preserved"
> 	fixes fc33e4b44b271, so it's wanted in 6.16+
> 
> So can we please have [2/2] as a standalone fix against latest -linus,
> with a cc:stable?
> 
> And then [1/2] as a standalone fix against latest -linus without a
> cc:stable.
> 

OK, I think I figured it out.

In mm-hotfixes-unstable I have

kho-fix-out-of-bounds-access-of-vmalloc-chunk.patch
kho-fix-unpreservation-of-higher-order-vmalloc-preservations.patch
kho-warn-and-exit-when-unpreserved-page-wasnt-preserved.patch

The first two are applicable to 6.18-rcX and the third is applicable to
6.18-rcX, with a cc:stable for backporting.


