Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F27D2E6B26E
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 02:31:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C5816B0088; Mon, 22 Dec 2025 21:31:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A6F36B0089; Mon, 22 Dec 2025 21:31:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D4696B008A; Mon, 22 Dec 2025 21:31:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EED766B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 21:30:59 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9F9C3137CBF
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 02:30:59 +0000 (UTC)
X-FDA: 84249158238.29.2DA6D3A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id DC473C0007
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 02:30:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1QL8f41R;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766457058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Mu9nbMnGhSASaY3bN8+eYi3nCdJ0EK5/7Jtn21L86E=;
	b=sW8jWpG2/sYCEE25YZRjhVnXAHurFXZ+t3tDZ6NmKvCGhxfEAuFGTq9KE8GvYJ480rKgBv
	5/A/2n75Rzgrw+gau6e38zxadUCXpQWNj8N48D9nvdYi9lK2qSLyPsCD7vD1QYhQFKn75q
	Bt9jQe+42NzWEFcsYInXOew/FO+4iA0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766457058; a=rsa-sha256;
	cv=none;
	b=fWIUL5QvFnatOC8GHErjQLceZbEia5EbcmV9jkWoGIH8h1/bw5fkcCt1x7zK0kMbSTtT19
	EKl7hKDBpEKAwfJhQNqZ7bD+D19wqJ+zZm4685jTWbERa4qDlUnf/UOgOAe4ywnkHCnlkY
	//joJvYnToHn9gs5GOPBi6QPtesNDpI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1QL8f41R;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 72C3940711;
	Tue, 23 Dec 2025 02:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23ABC4CEF1;
	Tue, 23 Dec 2025 02:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766457056;
	bh=EGu5F46cvREoMWotC8TtqKlUedKHHiCD44Ca991/ZQg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=1QL8f41Rcexjp5HR46WOg9kxNLNocZNvvEbYU/Auokx8zqa8xA3O5RiDLBnxGF9E4
	 y/C4Lqpm2r02rxa6co5a+BWXUIOB+8WAgimhq2VUTMXekY8F7nwfHvPj/swOESZT8s
	 NHNWrvdZfY2vDa1FW8ZegBx08PWoBohUIHQY3dNI=
Date: Mon, 22 Dec 2025 18:30:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, "Ritesh Harjani (IBM)"
 <ritesh.list@gmail.com>, Sourabh Jain <sourabhjain@linux.ibm.com>, Borislav
 Petkov <bp@alien8.de>, Christophe Leroy <christophe.leroy@csgroup.eu>,
 Heiko Carstens <hca@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman
 <mpe@ellerman.id.au>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador
 <osalvador@suse.de>, Thomas Gleixner <tglx@linutronix.de>, Vasily Gorbik
 <gor@linux.ibm.com>, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
 linux-s390@vger.kernel.org, x86@kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, Sasha Levin
 <sashal@kernel.org>
Subject: Re: [PATCH v6] mm/hugetlb: ignore hugepage kernel args if hugepages
 are unsupported
Message-Id: <20251222183055.88c3cc1f0705c1dc29c7f011@linux-foundation.org>
In-Reply-To: <20251223013045.4579-1-sj@kernel.org>
References: <20251221104907.032abf56c67f3e50c9c94e31@linux-foundation.org>
	<20251223013045.4579-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 77dnftg581461zckbgm3bmexo36a5bro
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DC473C0007
X-Rspam-User: 
X-HE-Tag: 1766457057-441451
X-HE-Meta: U2FsdGVkX1+a3bJL/m3Hvx0gyRnV3hRrms/RGIT63mlClhJkMCpaD6UsSweXK96a8lCMoISYsSczBAMZCQmIx4F9M2R/Y1ipUanrScl5bSZ43irmMgTfcII27t1hkz2ZB1T+R8VUvnrDsjMX9wOgyZJ6BPNpR47v2kTGXCr+CTZzo2dXo1f23tK4CQrp52hMbjc74u+jECIMdwCv78GcVsWkNs/wJHcS9s50SAZ8hVnjSwEKEChXJBpopQNFkumvMSiiDx+ZZjwYyndTTvYbwOVr/IphfBNDf6ufhVfRvM/D+LlqDYUOF566iaNTJmccTc5+20eCN8snVzybG9AEzIuMkg1NzrTmCLFMZmwQ9ctj0X8rZmojM7ZFotLTMAEXqaHC25LjLww0krmF1Qy7CQ8sPmZKF5An4P7wUIJR0X/9VO8H489d9P3ZGvSEoGrcd3Ntl7UgBEa9VQk9Nmx6tzWPhzEwg6iYdTftb/3Uz3zhEkD/xbKDDnR432K1KQOYfaCSDo34681HlNXhouXsGbuggUnNo8AvThpmbtDIK8H7Py1Xc19WYRCgX8WLwLD2kVqS8bgqyVUutJTGZhfvJ4ADXyjC1Lc9WyBkAyVXq+TUemLU3Iiau8HyGaf5CHwaJerHzc+F+zwhAASUFE5V3KEm7N73xuwMMpWZ9h1T5iK8WheIeYHvQY1/cmiYwmhry1z0/hzuFIn5pHis3AJHZGcPsuRDLgtnmB3219zhLWcdztr/KAXrNCK5dhOrAjxFcuEtFq/+fOaroLOKLFxEntBqPeAUZZ3tld26OrgRU1HjJ2UTMRRYKqvLQ/Hg0eLzCniAQMTFJkwUUtvqZAdXp0uom+/eTbM0qoLHbuxgm5CaYLdhafcJLPFrebiAsNcFAYKz6fRPVJ+W4iDY30hWfUavQmLhV8iAUU2EnaHWpt+ruRmENHoodZB907ypHgO+ZJqMdSO1lDm80vFeBfA
 ZCysfFLW
 F3beTgzEhfND63unGr2BrVBQkaeoOYJ4jHA9R3xaSoO3JeSfbJloDvFYS9xbgFShdrBtkIVZOaxIFA7gBnm5E89oPy1PrRQOWZ1jBnZVq+UlfbOupn/qCsdCRq6bnW5woabheW4pVJkuH/nz5maIOcIUWeEeZUouHVId0vRnhTWOoFfOQk+5Ph0Spa8C4ZjDP8/K/M7ohvQRduBtfPP8N6uy9pUOu9I8EKOcBQyERlPYTGrQz4r49d1MifK1eYTOs4NBxIwYbWL9vB2HzJciIn9a9XhwyN5P0iiqbC6CbamqEt4R/26JbJPgjEOslSRmYBBO7vpKY4xtsbRKgBnvzabyeiBO3h23G6Wvc7x9ZyfzVjoLMuQUWJQit8l8Nzke2ZL5qbQQ7O54bJ9Bs8dQ+F6/dGA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Dec 2025 17:30:44 -0800 SeongJae Park <sj@kernel.org> wrote:

> On Sun, 21 Dec 2025 10:49:07 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Sun, 21 Dec 2025 10:22:44 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:
> > 
> > > > 
> > > > My main concern was -
> > > > A fixes tag means it might get auto backported to stable kernels too,
> > > 
> > > Not in the MM world -- IIRC. I think there is the agreement, that we 
> > > decide what should go into stable and what not.
> > > 
> > > Andrew can correct me if my memory is wrong.
> > 
> > Yes, -stable maintainers have been asked to only backport patches where
> > the MM developers asked for that, with cc:stable.  There may be
> > slipups, but as far as I know this is working.
> > 
> > I don't actually know how they determine which patches need this
> > special treatment.  Pathname?  Signed-off-by:akpm?
> 
> I guess it is pathname, based on ignore_list file [1] of stable-queue repo.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/ignore_list#n16
> 

Oh, that's a bit sad.

- other trees sometimes mess with mm/ and they probably aren't aware
  that they need an explicit cc:stable.

- misses drivers/block/zram and probably various other things that
  the MM team maintains.

Oh well, I guess simple mm/* coverage is good enough.  But I do worry a
little that useful fixes coming into mm/ via other trees without
cc:stable will get missed.


