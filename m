Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64D37CFD316
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 21:45:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96EC56B000C; Sun, 23 Nov 2025 16:45:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 944E36B000E; Sun, 23 Nov 2025 16:45:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 880D36B0010; Sun, 23 Nov 2025 16:45:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 772546B000C
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 16:45:27 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1FA3086CE6
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 21:45:27 +0000 (UTC)
X-FDA: 84143203494.25.9345B17
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id BF6BA20005
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 21:45:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mCiU0wos;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763934325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vizaUFYQGCAL3oKV+7FMV++yDiuY68t3L39autjn1Ps=;
	b=VmWuBESCv71jMjQChGxDwmoFW2XASIUVpeKjPHpnbe+RLJVpMtYbwkY3AfSV3OWnDYGKwM
	KiqhjpihEiXNRtjggODedMzshyqje//fyVsdwr1HCNV9LxF3H9O9xQpBUS2m2Y/mokL6Sl
	IV5L9aGhuiDeQ8P8C4zLZAMxUMRH6hk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763934325; a=rsa-sha256;
	cv=none;
	b=gZrcAzdAX+I1FUILYdJn1Pp0Qqa723D0H7Ed352fyig9db1TcBM0dLoc16o2r3Q1SBw81T
	06peqZ+LOU47Q5Dkqbyp/xBVCmvbLqZISknwRvhZMP+9HLUvI4Il7KDM9cR6S5QJh12Voi
	teqs4ouQjb3TbNVS070tahymFabdQVs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mCiU0wos;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vizaUFYQGCAL3oKV+7FMV++yDiuY68t3L39autjn1Ps=; b=mCiU0woslSrHvuhY7PtosZkaAH
	fUE+xRcz3gSABrILMU9HeYIM9ykFaLvcrtiL9hLX4DyPkGFivzbmSQG18WQkeYirOf2ASKYmRfBgE
	SWmblGnbf5WbuEJdagVUWpUR2zXZqom4cYpJCuoqz1IyIKvJcI6lD7AOksu32AONqVU/KLcjLqS0N
	d4Nkk+Bo2gKubxxnQfL2cE0laUJ+j8BsrfdIUcWAAjSdGbzCjoGFE1cZioSqFCjn4bxWWQQHB6dep
	g4/0tmqzFghXkwvC0u80gXLbWhC4TVTk+gwJegcCca7BabNADHGWYaJ6pxMEGnFwy2NeC9DNIGdFy
	2BeOTwBg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vNHtY-000000063SD-2OPY;
	Sun, 23 Nov 2025 21:45:20 +0000
Date: Sun, 23 Nov 2025 21:45:20 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: oleg@redhat.com, brauner@kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/3] further damage-control lack of clone scalability
Message-ID: <aSOAcMSYsQ22kPid@casper.infradead.org>
References: <20251123063054.3502938-1-mjguzik@gmail.com>
 <aSMhj2Q6BTMNSsA4@casper.infradead.org>
 <CAGudoHFjqRPao2DOF35rHrYDOAjVC+dcWJ2kGm+7JqnMNk=o2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGudoHFjqRPao2DOF35rHrYDOAjVC+dcWJ2kGm+7JqnMNk=o2A@mail.gmail.com>
X-Stat-Signature: dcogh9zgfjpy18k8ggmqkrxrui5aeyu5
X-Rspam-User: 
X-Rspamd-Queue-Id: BF6BA20005
X-Rspamd-Server: rspam10
X-HE-Tag: 1763934324-432729
X-HE-Meta: U2FsdGVkX1/4Y4MyIQIhEruBE5W9vqojzyFaDv48SaFVFRqiVcYCTRERw26AOTHgSyK9dEHYqEYSFrtT9Z95LJJ4N0MxT4QRBdbJp5A/RkbVLkeL0KelvP2I+tUOmqCyXjio7sMzMYMSdjP+wx++qh7Q8/91Cv1AkzdHQOQhBhjoCCsYD7yRAOAXbIWnIcWScxU3kFAN4sMspSz4SnIGKZpmyH5VMv7I6/IP0AePVIR+z1yE3D4USCZY2CAq/fLxwyH70zz9wDxaTYmPgFk2c/4L+Ham3Da+nwEOo7Uyx/j/CstVOzWYluMn9TB0c2VNsKB31jdsjOtrHL1bVfvZXXj5vOMdN8ZPbS7b+kLQ39yOXS6KUGLzN/NFnLov7vLuvf2/SuGsGolatFoYE08WD3G7EGRtTlJcJ382Kj24JR5+yr/5Rvbn44fLFgKiWHlKjLauzyhSnrDqgWziV80XupLOh/16n5VlqjDTPYzATaJ0mtfGvke/qy//rYCqH9S3Ujsuzmf9Gzp6xmnDzHSVCnvdrUVWMYSLU5w2uSmHlfhSbti1Pyp0EpMNjOYSF50zTOSMj6192v1ccI59cCgHT+pnqETzNtycnqCLnoJNd1iyVHdx164eMSx7Nv3nDFGzyD8golb/rynPY9MyyfUc7QB70SY2g+nVO396eWv4fhSRPSxKGSqfuDxHOR66Y/2rpCnZY3V0EUMXqgQvOCS/fc+t6F2+8ifJ8Yng33Jloef/k19eUAJcGfi7LWeTZQQkh1o39D7hRivVL7PgqPnhu2P4yyCgj8ebY6qP4eB6Xrj3OFRkStZ4bYMMR5XyW7ABvqOM5g49i0lSxguDrMg8g3fPEwerjttApGJUh4zIHd/jXmRyDqm2W+agvdvzdr0gwbNg/nloO/AKw8tIW9j7SQsY1otH03pPiA+sNApW1NXo842FtOFZUlgb4SnJ6vqCPtgcJ5sPtnW4dQCdcgN
 DydoYPLM
 oVPwE6mA0foQDcwwqyHFYWXNseO0Vl//Cb1CZVmDl125Qq/egTT4zwsmpmw2XKIe+vQYEYsfLdd6gkpj7qwuwSta5Z8kz8eZWjw8habZyjBmVTXiDMuAC8Mvs8XwR3vRAOxxlHQfIPTGbbeaRcu0p4371ZwiVab1YnN2yaXbNIBl/cLmmWNCl1YD/XktD4w0lex+vK4guPEH6Z9IQng8rTYo95EgBSnwZoesIULlj744Gb4+HjdtitT2caA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 23, 2025 at 05:39:16PM +0100, Mateusz Guzik wrote:
> I have some recollection we talked about this on irc long time ago.
> 
> It is my *suspicion* this would be best served with a sparse bitmap +
> a hash table.

Maybe!  I've heard other people speculate that would be a better data
structure.  I know we switched away from a hash table for the page
cache, but that has a different usage pattern where it's common to go
from page N to page N+1, N+2, ...  Other than ps, I don't think we often
have that pattern for PIDs.

> Such a solution was already present, but it got replaced by
> 95846ecf9dac5089 ("pid: replace pid bitmap implementation with IDR
> API").
> 
> Commit message cites the following bench results:
>     The following are the stats for ps, pstree and calling readdir on /proc
>     for 10,000 processes.
> 
>     ps:
>             With IDR API    With bitmap
>     real    0m1.479s        0m2.319s
>     user    0m0.070s        0m0.060s
>     sys     0m0.289s        0m0.516s
> 
>     pstree:
>             With IDR API    With bitmap
>     real    0m1.024s        0m1.794s
>     user    0m0.348s        0m0.612s
>     sys     0m0.184s        0m0.264s
> 
>     proc:
>             With IDR API    With bitmap
>     real    0m0.059s        0m0.074s
>     user    0m0.000s        0m0.004s
>     sys     0m0.016s        0m0.016s
> 
> Impact on clone was not benchmarked afaics.

It shouldn't be too much effort for you to check out 95846ecf9dac5089
and 95846ecf9dac5089^ to run your benchmark on both?  That would seem
like the cheapest way of assessing the performance of hash+bitmap
vs IDR.

> Regardless, in order to give whatever replacement a fair perf eval
> against idr, at least the following 2 bits need to get sorted out:
> - the self-induced repeat locking of pidmap_lock
> - high cost of kmalloc (to my understanding waiting for sheaves4all)

The nice thing about XArray (compared to IDR) is that there's no
requirement to preallocate.  Only 1.6% of xa_alloc() calls result in
calling slab.  The downside is that means that XArray needs to know
where its lock is (ie xa_lock) so that it can drop the lock in order to
allocate without using GFP_ATOMIC.

At one point I kind of had a plan to create a multi-xarray where you had
multiple xarrays that shared a single lock.  Or maybe this sharding is
exactly what's needed; I haven't really analysed the pid locking to see
what's needed.

