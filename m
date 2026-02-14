Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A079EF99E1
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 06:29:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CF2A6B0005; Sat, 14 Feb 2026 01:29:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87D1D6B0088; Sat, 14 Feb 2026 01:29:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7887C6B008A; Sat, 14 Feb 2026 01:29:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 651426B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 01:29:01 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 179A914078B
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 06:29:01 +0000 (UTC)
X-FDA: 84442084482.23.8281F0B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 69DE080006
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 06:28:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=t4UtV5oc;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771050539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wGw4Vu7tCiL3kLSWjSCIuIQilIgi0fpPvCGA80V/pdM=;
	b=1QpKK6FnuW5+6G6+7SV7E4YGUTZQFIzWH7lLbKYeIDV+V8m1NeBDLILAXCQPof/9An8P+1
	LinxDkykRlXLx+kcwCFKeHBFQmGJ8sLYdqlVPtCz2e+ASEaIhb9TCTxQVy9gVmMaxv0XLB
	i9KS1OnP3YcHLZvd5MAlwUrIhVfHiO8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=t4UtV5oc;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771050539; a=rsa-sha256;
	cv=none;
	b=STZuZ7gP07c8sm/0nlR49tfg4KwcgTh6Dr2aqUKrlgjEWNPOqrGX/fw3aD/Ny9TTQzoTpf
	9toVHN+8nJ6/TaJk8WADXNNxIa+MlgilgeLDoxQe0JRT/mZ2zCCYaedLJW1Oe9DlsFapgx
	A66vgrIZUaUKX4l+WFjeqGsgxFZ1HF8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wGw4Vu7tCiL3kLSWjSCIuIQilIgi0fpPvCGA80V/pdM=; b=t4UtV5ociA1M7EnjmH5YrnSsoX
	/Y6jiY3A4S+rX0aR9XMr+JYQsGqW6tQSq1VJLqDrke70scuSZ1gmwn2VUvbwi/hZsrxe66R0vPz5i
	ibY9rc78mKgwj/ClsebpT/b2hPJTTmXbqbNzlVUQXIOi8Cie7oLg1i+ikwd+2bXmwcqIkr6bOmshi
	0M09tVy1j7bDQZcFBKJ28ozFHRJ4ZHVn9aROJqcb9ILJNcotbXeNVTA0cD6Nmu7wBe2ZlGvQPUl4x
	jlLTWhr66rn2jdzM8VbvZ6fMUspdhdZ7+eu3xkpmDAHg7GffnGYbfzuR25dQOM6TySS2PXei/BV9b
	XFKjHcew==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vr992-0000000GrgH-0q3m;
	Sat, 14 Feb 2026 06:28:44 +0000
Date: Sat, 14 Feb 2026 06:28:43 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Waiman Long <longman@redhat.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC] making nested spin_trylock() work on UP?
Message-ID: <aZAWGwZP_Z75YHKt@casper.infradead.org>
References: <d762c46b-36f0-471a-b5b4-23c8cf5628ae@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d762c46b-36f0-471a-b5b4-23c8cf5628ae@suse.cz>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 69DE080006
X-Stat-Signature: ngd37b4pgnde9k6iyedb79zsxefshn8i
X-Rspam-User: 
X-HE-Tag: 1771050538-538370
X-HE-Meta: U2FsdGVkX19SCybXUsZWKsMCoTFl3dhpLm9VADmxz4Ca9DWZV0/7ClAWgjVd4TAyA1b8YkGeKCsvrKHfcq0zpoHoCjEBqctRhkBLS/lQy7IqV//7XlBwbqIToPRdd89wI/p/bX84W3l8r6/P6jPN4Wux36ignD8rThj1Zg7o8SmHq24EmyjDt0V+8vLqC7BJH6cIJJ3DIH4WlK2SwRK/awqxKIGCOlfB76QgmlGexBh0ZQWj6aaycorIjHBnwrZQg+0OMWnU4oSqfEgyPISF1zYiN6MsVdFoie27dcsmvYj7HbnR/4+M2ihNZWKm3zOZNkutOtwnf6sdIb/WBDfwXGqiv56M5zQu8Uu8Zfk+dCoxbSLQVxwpFA+isDZ3riNIsnskbm8bSOeB8MjblBx9B1hYy7rYtBjH4L2ZhdfUn7sWbtI66S3EVyaoVfrC97KWMAfvmEaSyp3J0p6bZG6avAibRvh3S4UFY2SxgAWCSslxDNSvigI34UMeXN1RRnJyqusF/i1vN8XKuXhdWQp7TLeF0TakYJQJdW4xgsyfz0s/tQavwSGDSorFEu5k3MvPOnDYmOiuBBAD6w5U5+D3nHDw0aq52MJWsEqMH7fojSRWBxPSy+u93FCk4nC4w0i9OSniT9VfR+ElBKZPpORKBLtlPSNilePGQuxqjBLBXV4yeLMS0zCr1B9D2brR7S3YIfxvc10cP0/22JqoZiCb4T9pAyGUeqb63GdmI3o6R71G62okgm/bYlPBoLysWap5FQ//7i+Ry6ZmaYi5iLzYEEriY4wJMs5VFmyZsFm9g2JEtGdfis0cIPS/BRQJXwr8CXUppopfICxDD6+4Nb+dUJuyVJZDoUsYI2J0p4fCIMh7tFQOUHXGw0yCYqNm8ntUZvS0pUwhgFAfEjeD+d6M6BSCqzedYGjB2mxhMR//WkaPHfeBqqEbW8EboAfdioM/h01AiHmmuiJ7VGqKHVL
 KDkQgEGV
 j0UHKEFHORGFMaEYfS5Szo3u1PdDlqrUB/KQ+kO9dTSZyLis0X/G87SKUVw+RYTklAuntO9ncG52r628L0JsMM8asbhplXHfzgRob5PYXCSRXTgPFNpgGPOaRtF8JkLhT+JHdQFbKXHROjSVc/eygjkBFsK30oy+FjbNLD/9nG6QNAa17u86jDYUt7o8qt2JF95yce2PvCxWKwzbEGbI9LCTz91zj+EsMcYdDj/aXYrJLxXE/c8LTS65M3l24IKcr0faT8SDp1bvRWEgCcltpORgke6KhpFRPSJp/lAWTajmtZLfZKsr1VALloIQTdBiWKyOh/T4YUGEUmyAdHieViyZQ7JJ+azn15vMKGPQ/lrCO2d3zfEpgLcy0jN6X7co52My3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 12:57:43PM +0100, Vlastimil Babka wrote:
> The page allocator has been using a locking scheme for its percpu page
> caches (pcp) for years now, based on spin_trylock() with no _irqsave() part.
> The point is that if we interrupt the locked section, we fail the trylock
> and just fallback to something that's more expensive, but it's rare so we
> don't need to pay the irqsave cost all the time in the fastpaths.
> 
> It's similar to but not exactly local_trylock_t (which is also newer anyway)
> because in some cases we do lock the pcp of a non-local cpu to flush it, in
> a way that's cheaper than IPI or queue_work_on().
> 
> The complication of this scheme has been UP non-debug spinlock
> implementation which assumes spin_trylock() can't fail on UP and has no
> state to track it. It just doesn't anticipate this usage scenario. So to
> work around that we disable IRQs on UP, complicating the implementation.
> Also recently we found years old bug in the implementation - see
> 038a102535eb ("mm/page_alloc: prevent pcp corruption with SMP=n").
> 
> So my question is if we could have spinlock implementation supporting this
> nested spin_trylock() usage, or if the UP optimization is still considered
> too important to lose it. I was thinking:
> 
> - remove the UP implementation completely - would it increase the overhead
> on SMP=n systems too much and do we still care?
> 
> - make the non-debug implementation a bit like the debug one so we do have
> the 'locked' state (see include/linux/spinlock_up.h and lock->slock). This
> also adds some overhead but not as much as the full SMP implementation?

What if we use an atomic_t on UP to simulate there being a spinlock,
but only for pcp?  Your demo shows pcp_spin_trylock() continuing to
exist, so how about doing something like:

#ifdef CONFIG_SMP
#define pcp_spin_trylock(ptr)						\
({									\
	struct per_cpu_pages *__ret;					\
	__ret = pcpu_spin_trylock(struct per_cpu_pages, lock, ptr);	\
	__ret;								\
})
#else
static atomic_t pcp_UP_lock = ATOMIC_INIT(0);
#define pcp_spin_trylock(ptr)						\
({									\
	struct per_cpu_pages *__ret = NULL;				\
	if (atomic_try_cmpxchg(&pcp_UP_lock, 0, 1))			\
		__ret = (void *)&pcp_UP_lock;				\
	__ret;								\
});
#endif

(obviously you need pcp_spin_lock/pcp_spin_unlock also defined)

That only costs us 4 extra bytes on UP, rather than 4 bytes per spinlock.
And some people still use routers with tiny amounts of memory and a
single CPU, or retrocomputers with single CPUs.

