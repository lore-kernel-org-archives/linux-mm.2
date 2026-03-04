Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E29FEFCE3B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 19:01:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB9886B0005; Wed,  4 Mar 2026 14:01:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B67626B0088; Wed,  4 Mar 2026 14:01:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A65756B0089; Wed,  4 Mar 2026 14:01:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 947EB6B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 14:01:09 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 34E011C95E
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 19:01:09 +0000 (UTC)
X-FDA: 84509298258.19.B9E66D0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id F2A994001A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 19:01:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Ux/svElR";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf01.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772650867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wh9qbG+FlyiO8UJnUIqCRxZKnSQBC+n2Ht087H8Gkjc=;
	b=MakEVu1mVn7rOMYvFuZvjABAAv4RSy8C82AKZ4iwKlYMV5hi14xv1ayWHrJ34nhmlcU8uA
	WAwP7m2Srle+Hpc6D/Tr6SBIx+QSwb3IOVboak1nPB+v+Niz2LvaiStJdNmN7v2Hvx4UZ2
	sOOmsZwxWC4U34JZVb7/9f/Q6qZnmCE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="Ux/svElR";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf01.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772650867; a=rsa-sha256;
	cv=none;
	b=mRW7JeXZqPxM36V9Kw8WwZe2fBfqSBigAWJwg+x6UXplUdJoxplKnK41mPBlpO1jhRX/Qv
	vVi2Fpd/vy/zqeh9H+8ByDCBvfRHp4j1tWPK5145jZ3QJm8ZNoLh7wB1McA/rGY9DzAfXj
	NfuuJqVhjYeYODASSvpcRWVTGqTjuZ0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Wh9qbG+FlyiO8UJnUIqCRxZKnSQBC+n2Ht087H8Gkjc=; b=Ux/svElRXHueLOyBqfF1CjH034
	pVIaaWu+XZ2IzFCkCimQhpcWBz9HZWxXo3fVhBUVfsKzd83PTHdpBmtxIBz/2mEOeJwJMgHCUTHYY
	zPBWTxPIV4MAJw9I8nQsZAl2i/EIG2gVB/J7B7ks4SVOi2uD4WQdtxAPSGwNJpKbiEYLofE5P1cNw
	dG5JNemsOusR9NtxvbnEYiu3NLsng+pstSqqwC//Jq1omGSBxGMvOZNQi1if8OH7Awpt9YFIxf5u8
	gl/KAQsccjpTpyVG559RaXJAx58uOAdor3zwhjmi1zoJUGXCJCAxO1aPyYGmZS/S754Y4GFoZ8vQz
	cSkTSC1A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxrSh-0000000Dl6K-15gd;
	Wed, 04 Mar 2026 19:00:47 +0000
Date: Wed, 4 Mar 2026 19:00:47 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	vbabka@suse.cz, jannh@google.com, rppt@kernel.org, mhocko@suse.com,
	pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com,
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org,
	borntraeger@linux.ibm.com, frankja@linux.ibm.com,
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
	agordeev@linux.ibm.com, svens@linux.ibm.com,
	gerald.schaefer@linux.ibm.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: Re: [PATCH v3 2/3] mm: replace vma_start_write() with
 vma_start_write_killable()
Message-ID: <aaiBX5Mm36Kg0wq1@casper.infradead.org>
References: <20260226070609.3072570-1-surenb@google.com>
 <20260226070609.3072570-3-surenb@google.com>
 <74bffc7a-2b8c-40ae-ab02-cd0ced082e18@lucifer.local>
 <CAJuCfpHBfhKFeWAtQo4r-ofVtO=5MvG+OToEgc2DEY+cuZDSGw@mail.gmail.com>
 <aadeHiMqhHF0EQkt@casper.infradead.org>
 <CAJuCfpFB1ON8=rkqu3MkrbD2mVBeHLK4122nm9RH31fH3hT2Hw@mail.gmail.com>
 <aael1XWaOJN134la@casper.infradead.org>
 <76aff8f9-1c08-449a-a034-f3b93440d1a8@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76aff8f9-1c08-449a-a034-f3b93440d1a8@lucifer.local>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F2A994001A
X-Stat-Signature: hk8ga5sgdr8r6gqxqs9eda5tquijtrg5
X-Rspam-User: 
X-HE-Tag: 1772650866-263198
X-HE-Meta: U2FsdGVkX1+X5BUvl7oqs0EyC9/4kKBJY2629rDeqWob5uvERa7SKw5QkfOBXthHM71nJlCnQHWF54cORlTlv7g9GgbfKT/juLpTxV8znz4RqCCJi/QHB8EPBHLnWEKqAuKecFo4m/5aP4bUDZf1fduILwn8BBQwCcyzay8O2B9cZE58PT4lmptsuyeUpbgZIWjMgd9b2I3rjHgH/xb8KKqMpIcA8zp8NUE+4LF7Woy71ElP854cLxhKkU9TlV0LR8+VssLVhYbdlVfzLkaF87WHyAgX8Kbm+DPf6GdvN0EPh+jG/xfNtRFf/MizS5+Tb7tPSpGeRMdYsW8rw4qOz9zwN3kyim+T6jxb0WbQ/7iV02LaSrlleVVHGueEqhB5j0KjbeT5bd2tYmaYXvvoL9hW5d8ebFYvu6khZ3oX5qT/uGCwxF4wo8d8rrocBkxHWM/imFH6FpJv7Fa7wDfEu9oUIteRpFYqME0aCpY973kQyPKroiczTqZx7PSVrs2GuOCUtyxT95bawWR4T+G2Z0Y6hu31LwJrtKYdICPG2N9uGgRv70xjkdrHEgH1NvwYh82cG8oI+VTbRQSzUcq8jJ80AsYCJDxk7CvtL4WHHyMyiZYHEzR3dzOL4f8J+kbExlwzZXv0272YI7mo7Rt9LbHBCUb8DuHoQUpiWxh0WXPmAtlC6ZqxcNpbxPxnVpuGuZjficmVjWr1Evoa7cYNfEZmy6zJvxSo302dNBusUo+grm4zpe9z6a+9MNz6kmhUyiVGG+OEgXDjdzjTxrlYHbzpINftr+dULeEIW93kVm6txnHBHD+BWI01FBM0sOfh7ON4SfhPlXtrqifdTxfHmjvGMismtfGoZl+ZvM4v2RNeiyFZMymWEyiuB4cMb8XQtLLZb7w4F61fDUcMjpOQPMXQLcENKAtZu28Y+3GblFu3j6FjeJ2ur6C492ex3VApfJ3+SfQ4Oi0+G/tTrqJ
 izEiNFPl
 eleTHzFAcTXAYoUtQiW+rsojlNPLJA5bfZ4S6ItmXTw7U3BqbV7fdW/PYswJwDyu8NBHWq1GemgwguIB1Lby8Vl8rucqB1W0NSSFVWpvm5KSl+Usf2o2La8tqSVbSZZH77Ng6LwVZ8izWa15i9C1IGBRVrRm0PhjTpm/st50bzFNBhXKXL4CfF8YTfNoyWKOrH6zeq2R/z+u+ke8wUR+wfL1WDjWVRCAGkJxA71gGfHYz1q5cI6RMA7UT1nmvGg6gmHmVCB97qfJhjaefk0u5s2bZ0jMaT4EAn1w3i+XdXYnNtZYXzkWrb0QIX0w/Lq+anLokstC+N1kHKnmlQg9e9MbRWkLDEo7fkQg3gzkuadN9o2B+8Ydz+FfSSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 04:53:27PM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Wed, Mar 04, 2026 at 03:24:05AM +0000, Matthew Wilcox wrote:
> > We could literally return any error code -- it never makes it to
> > userspace.  I forget where it is, but if you follow the syscall
> > return to user path, a dying task never makes it to running a single
> > instruction.
> 
> Thanks for that Matthew, that makes life easier then.
> 
> We can probably replace some of the more horrid if (err == -EINTR) stuff with
> fatal_signal_pending(current) to be clearer as a result.

Umm.  Be careful?  fatal_signal_pending() may become true at a later
point, so you may have acquired the lock _and_ fatal_signal_pending()
can be true.  I'd need to audit a patch to be sure that it's a
reasonable replacement.

