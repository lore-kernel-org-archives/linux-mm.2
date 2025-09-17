Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4190DCAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 04:26:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AB1E8E0006; Wed, 17 Sep 2025 00:26:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45C728E0001; Wed, 17 Sep 2025 00:26:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 372348E0006; Wed, 17 Sep 2025 00:26:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 252928E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 00:26:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BC925866CF
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 04:26:51 +0000 (UTC)
X-FDA: 83897456622.12.CBD2C5A
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf06.hostedemail.com (Postfix) with ESMTP id 04CD9180005
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 04:26:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758083210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DAQs4c71zzsKXsFUveiC4TVPuOdzgC0ETIUj0msKxYM=;
	b=Qqe3pq5FyTrQ/2V+o/mSvKOf5x/Py6hpQ/mZzyLeJGedfYk3wMWDHKCNZ2O2aq9OZbSftL
	NJR4cyNNpqfN0/TLAQPAjkpTF6lpAQnfidFQFff7yPR0VRqWuz8WwGsMmjwqAx3Y7sdlhp
	TdzpRBg2pPk4R9Zr09/TBllrNMrtlXI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758083210; a=rsa-sha256;
	cv=none;
	b=HWQoCsZ7CcHW/7VALV5xjacoGmFo/azJz5xK1TzXRzosEhzKS5erU3PRhN5CCDcBWTLhKO
	8ZWZR5Qzx7s7l41uRT2lvuujvsyo9NptMUt0os5eVc6aptfX0KMtA0cJkqiRwFI8CjAkUP
	HusriVL+YHyoZJRTEREwhmWHsgxntWg=
X-AuditID: a67dfc5b-c45ff70000001609-1d-68ca38860b96
Date: Wed, 17 Sep 2025 13:26:40 +0900
From: Byungchul Park <byungchul@sk.com>
To: David Hildenbrand <david@redhat.com>
Cc: Helge Deller <deller@kernel.org>,
	Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux parisc List <linux-parisc@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, kernel_team@skhynix.com
Subject: Re: [PATCH] Fix 32-bit boot failure due inaccurate
 page_pool_page_is_pp()
Message-ID: <20250917042640.GA62248@system.software.com>
References: <aMQ2ZjZNyNwAiUk-@p100>
 <cf235550-f29b-4f22-b5b5-c3e7a576239d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cf235550-f29b-4f22-b5b5-c3e7a576239d@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsXC9ZZnkW6bxakMg6XnBC3mrF/DZvF1/S9m
	i8+/DzFb3Fvzn9Xi0akLTBaXDj9icWDz2LSqE0h8msTucWLGbxaP9/uusnl83iQXwBrFZZOS
	mpNZllqkb5fAldHz9RFrwSqhiq23HzM3ML7i62Lk4JAQMJFYOb2ii5ETzHy84gQbiM0ioCrR
	ePYJmM0moC5x48ZPZhBbREBDYlPbBiCbi4NZYAqTxJKfP9lBEsICIRLvXxwFK+IVsJBYeWEd
	K4gtJBAucXvGHEaIuKDEyZlPWEBsZgEdiZ1b77CB3MAsIC2x/B8HRFheonnrbLAxnAJ2Eq8f
	QdwgKqAscWDbcSaQvRICW9gkPm+fxQ5xtKTEwRU3WCYwCs5CsmIWkhWzEFbMQrJiASPLKkah
	zLyy3MTMHBO9jMq8zAq95PzcTYzACFhW+yd6B+OnC8GHGAU4GJV4eBNyT2YIsSaWFVfmHmKU
	4GBWEuFd+uBEhhBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFeo2/lKUIC6YklqdmpqQWpRTBZJg5O
	qQbG8oNMQbNY5tXsvnd+d2uaJl/q8QvBXdtupC1/kMd/955P/I033VXaAuWPrXILutRYL97q
	Perw6/k8NiapUv/4pULONy0+S8THTdqysPO87TqNFvUkGbeJfOGXlv6SPPN657lu2TkZz47G
	SVrFq2cGvUpgMt/iKq76U36OtE/N4sYIc82Xi5iUWIozEg21mIuKEwH+2j59fAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsXC5WfdrNtmcSrD4L+KxZz1a9gsvq7/xWzx
	+fchZovDc0+yWtxb85/V4tGpC0wWlw4/YnFg99i0qpPNY9OnSeweJ2b8ZvF4v+8qm8fiFx+Y
	PD5vkgtgi+KySUnNySxLLdK3S+DK6Pn6iLVglVDF1tuPmRsYX/F1MXJySAiYSDxecYINxGYR
	UJVoPPsEzGYTUJe4ceMnM4gtIqAhsaltA5DNxcEsMIVJYsnPn+wgCWGBEIn3L46CFfEKWEis
	vLCOFcQWEgiXuD1jDiNEXFDi5MwnLCA2s4COxM6td4AWcADZ0hLL/3FAhOUlmrfOBhvDKWAn
	8foRxA2iAsoSB7YdZ5rAyDcLyaRZSCbNQpg0C8mkBYwsqxhFMvPKchMzc0z1irMzKvMyK/SS
	83M3MQLDeVntn4k7GL9cdj/EKMDBqMTDm5B7MkOINbGsuDL3EKMEB7OSCO/SBycyhHhTEiur
	Uovy44tKc1KLDzFKc7AoifN6hacmCAmkJ5akZqemFqQWwWSZODilGhivcR8+myy40pdnc/2e
	dTs/XZ6+vypOrX3zsZs3BTef4u59qsih/0J391WnS27ZMgJXAz61n3vQlrb6TnBdnh9L4pzZ
	X3mPMer9n+9qsPvNkj/fNzTlXXjweqvEmS1zrFu8pWYqpl1bWz+B+43OXtNb8dsKdjrrRUby
	NNvw/ppRV9O/cTdX1vwnSizFGYmGWsxFxYkAlYwuzWMCAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: 04CD9180005
X-Stat-Signature: bu9x7ftq9tkkceisyo9zc5d76cgghfyq
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758083208-721288
X-HE-Meta: U2FsdGVkX19zzXrKKelftddfzDHl5V5ZB0oluwfq6xj/uOBexGOKgh4OHJQrp9oHQOOGDEfhS8qLLI69An9CCo3YUKLASZHVyRPn3etHGQOz7Fpy/7YSlAE27kC7WEFhf0KK6hTEnySySqB1eXrlXOEZb3M7QSCs3iuUh1c4TKUj6SN9ppGrBwNwqO1oApgZtavTO9mq0rPTfkoJYqqZo+Is+Q5or22dIiRahiUXCuYhy4gfZO7Rz+w/+mmAWbAY08QDQ4zNOxVfuSOsMp6hk32iPu6Bz2zPHPaYKj/zEt/9G/PBvXhQ5YIHY4r5V7+HcLC6+5YlNyqhstherXE/rzxTsKDtkzPM/91i6ihY2Yj1GjzD1HKRXZQ92JdvaXlSmdSGMOr+fV30TNfRVFns8MCn5Nsw8MkDlUNMoWCQO0fRg24hcYwC99rg7hKgxyqP3IHm2AZNv/C822vnURQORmrR4u7TKnS6TM1UFeDt2jF0jYvBmOsBEGkrIi+Batzdr04uKyeCHnDS15iYPfS983jYyl0+rCQCiaZBjI2xo1cTcWScAU3pwuuXgUUmv/6s0P6G3cPuPyeYO0Ri+OLvpKsaB4hxjAtJI5BkeitaO/IAE1Mn4ht6SJCpRuq7SgtPZXGHhFkVMbXIgB8arXlpVGVWfxwFKJbBS2H1JgxI0F/OGMYWtkW0NfCxcgKsLHBSik66pEiuf97LlHvkKUuezlp6MrnAVwjB4CFB7pJhCL2CWVATPHF7nICyvDh+YK5STUazAyNvayJ9SEOaRpng1jnxPjbKMMH8ygQ2KojF/8/r1hP5xj07r8RKd8FWmCqbx6ZGm6zBXeOBzpfSK2OtkxvGhoYzO+mhmDVCe9K4NCYeVRt7rMl3YDcfsxXxcjPyfVwUyscw+Y5TwIpEEOjjZTyajlbuawPZuzY7dysY3qNDGxDJKa5kXrNHzD9VkRDfF54jrz9MferBafbWgO6
 hbNSn5xu
 j7amcxYzXRistesuXE4WOiirx6Yln4fr+2EL/O8hgcOYh3Wlryq9qhdhaXP0BEas9u6i7AibwKczcyV3A3sEGdWmMMyx40EDPQVBahDOUO3SAfosmYK25fOV7GGLwaYgXBzeihT0Hue7OQTNfXb4mpkhbsSF9PbZghX93C+CiR6Uc2pI3T0dh5Huq2wqIJLclspWZ32yb78Xov0Zw2rZQkCsxOFW1MEQM10HFkjrWkxD1RUY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 05:49:15PM +0200, David Hildenbrand wrote:
> On 12.09.25 17:04, Helge Deller wrote:
> > Commit ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them when
> > destroying the pool") changed PP_MAGIC_MASK from 0xFFFFFFFC to 0xc000007c on
> > 32-bit platforms.
> > 
> > The function page_pool_page_is_pp() uses PP_MAGIC_MASK to identify page pool
> > pages, but the remaining bits are not sufficient to unambiguously identify
> > such pages any longer.
> > 
> > So page_pool_page_is_pp() now sometimes wrongly reports pages as page pool
> > pages and as such triggers a kernel BUG as it believes it found a page pool
> > leak.
> > 
> > There are patches upcoming where page_pool_page_is_pp() will not depend on
> > PP_MAGIC_MASK and instead use page flags to identify page pool pages. Until
> > those patches are merged, the easiest temporary fix is to disable the check
> > on 32-bit platforms.
> > 
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: Toke Høiland-Jørgensen <toke@redhat.com>
> > Cc: Linux Memory Management List <linux-mm@kvack.org>
> > Cc: Linux parisc List <linux-parisc@vger.kernel.org>
> > Cc: <stable@vger.kernel.org> # v6.15+
> > Signed-off-by: Helge Deller <deller@gmx.de>
> > Link: https://www.spinics.net/lists/kernel/msg5849623.html
> > Fixes: ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them when destroying the pool")
> > 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 1ae97a0b8ec7..f3822ae70a81 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -4190,7 +4190,7 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
> >    */
> >   #define PP_MAGIC_MASK ~(PP_DMA_INDEX_MASK | 0x3UL)
> > 
> > -#ifdef CONFIG_PAGE_POOL
> > +#if defined(CONFIG_PAGE_POOL) && defined(CONFIG_64BIT)
> >   static inline bool page_pool_page_is_pp(const struct page *page)
> >   {
> >       treturn (page->pp_magic & PP_MAGIC_MASK) == PP_SIGNATURE;
> > 
> 
> As a temporary fix this LGTM.

Sure.  As a temporary fix, why not.

I need to start the work replacing page_pool_page_is_pp() with using
page type again tho.

	Byungchul

> But I want to hear other opinions.
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> 
> --
> Cheers
> 
> David / dhildenb
> 

