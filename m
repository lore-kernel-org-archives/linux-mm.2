Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA17CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 22:12:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DBAF6B019F; Fri, 15 Aug 2025 18:12:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68BB66B01A0; Fri, 15 Aug 2025 18:12:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A2216B01A1; Fri, 15 Aug 2025 18:12:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 465A66B019F
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 18:12:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D4DAD1A02C4
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 22:12:48 +0000 (UTC)
X-FDA: 83780392416.22.709C6D8
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id EBC5440007
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 22:12:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JxjxCkJg;
	spf=pass (imf17.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755295967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7aMzF7zLYEW4cbiDJEQWA8qoxDxBNLq3HfkBAC7ZA/4=;
	b=7+PZgtOqx83LhIpMLCFkkgcCu50Y12NUyimxshXyGu7UoQheazfqWpt3SxyKH+D1lyfMe4
	4paaVPkQYVR+fvwJ6sWYUINtyIT/qbMVuJqE2nwb+vHSAHFVrPrY18eInb6Wbk998BJ6fy
	gh5hPa2jpg3DCc9LPwtQbcT31cujE94=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JxjxCkJg;
	spf=pass (imf17.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755295967; a=rsa-sha256;
	cv=none;
	b=Z8Q0/PN7egVNUcLgNkp2VqM7X4jPUJ6PzAcBNftTkBa3NDd1mOznhQP1P8kyNcl9aOIGPP
	MLOisoFzrJTt6+mU71RiZrSg2ggk5tF/SmWofxsSrVLvBZfcOx0v2Dp8YanGtEGtlN5N9W
	Or3MbxsTvlN5IVVNhpn+T4rdKZWsfNg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755295964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7aMzF7zLYEW4cbiDJEQWA8qoxDxBNLq3HfkBAC7ZA/4=;
	b=JxjxCkJg/4qMeRz3ovAU11EoP3v60Ug/FOMSkRBGceB/7zg+O2z3dM32LXse3Lo2wQklPc
	bDAPS22SJbdrJ3TYHzMEFEPmbaW0/IIeSXBzuOmcmhnEJJQ4LrRanwl9L1THTqw7y2oLnQ
	HuRnRbu4Qc8pMCQi1u1NDNmPqfzx9OU=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  "linux-mm@kvack.org"
 <linux-mm@kvack.org>,  "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>
Subject: Re: Regression caused by commit 4687fdbb805a ("mm/filemap: Support
 VM_HUGEPAGE for file mappings")
In-Reply-To: <aJ-gGXNwOMeLBs0W@casper.infradead.org> (Matthew Wilcox's message
	of "Fri, 15 Aug 2025 22:01:13 +0100")
References: <87plcw8lyq.fsf@linux.dev> <aJ-gGXNwOMeLBs0W@casper.infradead.org>
Date: Fri, 15 Aug 2025 15:12:39 -0700
Message-ID: <87plcwdyjs.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EBC5440007
X-Stat-Signature: suawhb9zz4dwqgecqx3z9d4zidpkcfmj
X-Rspam-User: 
X-HE-Tag: 1755295966-919224
X-HE-Meta: U2FsdGVkX1/fLkgGVedXJHJMAEAQYNz+fAocimx0B0gv2ePuYnV5i4AejDLwPnGcsoW4go1Om4SSaIL884/tEuaEhoTxsG2tS5JX9J0I3FOVBzijCum0+i4fSB2tq2q0fbU/8spEUzqE1R8zwhJ07+hhQjo+BwaJ+6+7VB0cikk8AMqVkXP1mWzQvo7Uy/MFa8DTi20+o/COgeHRSVeL6l0yIYbfBx1Ypp0pgZlmAZHactwBZswUenfc74mzjHA1s+4h9XVBVeDLQfc1+eXlvHhNRpoFANJT4ptkHZv6VnpS9aa/rQBqvcWKWUYJd1MjLMSk1JrqHD1pxSY+MJIV5RucwMBI8YOkYL6AieEyAGPdbr7nYFqDJ+a2qc0V76zsKJoc9+Y5a/WCZRFymLGWiJIwOafbFFrAqA7R9kUg/c2FowhlVCrMUY2e9nC1fTmKU6pxKODUcbbJBpMxYtDUFYs5WvK643rH8mKvDO4S2vIrNVabWRjnVNCU7uSbZuqobhA/CdfLF4QrpI1sTbzyXYqfBnt3/yrFe5qA3kK2VqYY6ajh5CXPs76XVcwM0C9A/gm7y6jrpZZICi1pJwpkcXRZfv1zfbrp2xmGuQhFDsLxcKeJ22+MUk5KI/ccc8wCwoithaOvD+bM6T2JiYe3e+N3ESAWm0zDqBEZLAGN4hsHaHWmuDf7H/JXXS5j50ydqx6n/xri2qb2lG69llKMYl2NrlrAAk/M4Xfgu3cdsaSeh+7iqiX67b+TkQgn0xXQFY/5VnbHwrrTbPULnf0iRBk3tqjNIMHu8jdNVZoHsTMA+lJKebihM6+46Wk/Q3wqss4nN/Vxmmzj6lWCkMej2FJCLm51+acmzDNVCkbrYRnJnjhJdhoX/kXmUl7mbqpWoKta4oRSlq8i1jyLc4QDtKTBONAaCX35JB4ndIPq11ZU8KVvRvyDg5VZaaid+q0Cs/Eo+sGYwipW2LbSekp
 wkl3DTgF
 K30Nt2Y7d6OvEtDcd2T7aZzMuAdoeK9+f7RzVBMLHePKvOEH7U0RybeVT3HZ95xEgMLeMNHU+yNd79lNextfoC1xgNA1EvQfmKEWwO7nHm4LsQMTX6XdJCLRZxSPtB1tYCiIhwc38nZ7kwUjBJVNYOkz4/s6ZZwcUZ9AJABPKbI76qszMqnDcXgv/nLScgNi8i12z9P13b80gKDxH9/lgdSN0XkMKVKnyiNmrQzzNsQMecy1UpbPeh2rC3oSxywkii0F/9I2OmNe4jhLDCisPmQe6ZO1ZaOyD7HPOaVEq+wQ8dHoMuVfcPaJv0w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Matthew Wilcox <willy@infradead.org> writes:

> On Fri, Aug 15, 2025 at 11:43:25AM -0700, Roman Gushchin wrote:
>> The commit 4687fdbb805a ("mm/filemap: Support VM_HUGEPAGE for file
>> mappings") causes a regression in our production for containers
>> which are running short on memory. In some cases they are getting
>> stuck for hours in a vicious reclaim cycle. Reverting this commit
>> fixes the problem.
>> 
>> As I understand, the intention of the commit is to allocate large folios
>> whenever possible, and the idea is to ignore device-specific readahead
>> settings and the mmap_miss logic to achieve that, which makes total
>> sense.
>> 
>> However under a heavy memory pressure there must be a mechanism to
>> revert to order-0 folios, otherwise the memory pressure is inevitable
>> increased. Maybe mmap_miss heuristics should still be applied? Any other
>> ideas how to fix it?
>
> What's supposed to happen is that we should have logic like:
>
>                         if (order > min_order)
>                                 alloc_gfp |= __GFP_NORETRY | __GFP_NOWARN;
>
> so we try a little bit to free memory if we can't allocate an order-9
> folio immediately, but we shouldn't be retrying for hours.  Maybe
> that got lost somewhere along the line because I don't see it now.

Yeah, I see it in __filemap_get_folio(), but not in ra_alloc_folio().
I'll prepare a fix for this.

>
>> Also, a side question: I wonder if it makes sense to allocate 1-2
>> PMD-sized folios if mapping_large_folio_support() is not there?
>
> Um, we don't?
>
>         if (!mapping_large_folio_support(mapping) || ra->size < min_ra_size)
>                 goto fallback;

Sorry, I wasn't clear, I mean we're still allocating 2-4MB of readahead.
Shouldn't we do something like this instead?

--

diff --git a/mm/filemap.c b/mm/filemap.c
index 983ba1019674..e5fb9034118d 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3222,7 +3222,8 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
        /* Use the readahead code, even if readahead is disabled */
-       if ((vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER) {
+       if ((vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER &&
+           mapping_large_folio_support(mapping)) {
                fpin = maybe_unlock_mmap_for_io(vmf, fpin);
                ractl._index &= ~((unsigned long)HPAGE_PMD_NR - 1);
                ra->size = HPAGE_PMD_NR;


