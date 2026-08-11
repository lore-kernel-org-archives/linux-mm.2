Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35D6CC5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 14:42:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BF866B008A; Tue, 11 Aug 2026 10:42:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 222726B008C; Tue, 11 Aug 2026 10:42:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09F726B0095; Tue, 11 Aug 2026 10:42:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD5816B008A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:42:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6B03A1C1288
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:42:26 +0000 (UTC)
X-FDA: 85089254292.30.8021E29
Received: from relay.hostedemail.com (unirelay03 [10.200.18.66])
	by imf05.hostedemail.com (Postfix) with ESMTP id AEFF7100009
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:42:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786459344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gcSfS7QNtE6S94cqoaez+NvxQo3hToTMKglv3I/la3A=;
	b=u3jh4i/NUY76sNKtkjKYi9s6QyYNWcumOuNdME+PL4jN64WyG/4RQMiIJS6R68lkI09fgT
	y5ogSuedbKy4YiOUMX+IaON+MQWSn0roxn52Bq8ob/Zu7QSGu6WJEdImZ7gqrNWFBn+m/C
	lW20NnQz7QPdvDhc5dqAlBHRwXPhQ94=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786459344;
	b=yyeupxgzShOzBGv/h5LnZSrYS0BdQj8X/vFDqStuLu2IWHe1elLz+Gbx4AK6xbM2KUBEFU
	j0pjEcn7tqJsSVMmQHOscatbRboBQ/sd3jUp7tXBkzAlGSMUmQdR6Rydk35akzgCyMCeG5
	TJhNnTuWWGS/USHbX4x6G5Aef4eh36s=
Received: from omf06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 80210A04AB;
	Tue, 11 Aug 2026 14:42:22 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf06.hostedemail.com (Postfix) with ESMTPA id 1BDE720010;
	Tue, 11 Aug 2026 14:42:18 +0000 (UTC)
Date: Tue, 11 Aug 2026 10:42:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand	 <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett"	 <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport	 <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko	 <mhocko@suse.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams
 <clrkwllms@kernel.org>, Simona Vetter	 <simona.vetter@ffwll.ch>,
 =?UTF-8?B?SsOpcsO0bWU=?= Glisse  <jglisse@redhat.com>, Christian
 =?UTF-8?B?S8O2bmln?=	 <christian.koenig@amd.com>, "Paul E. McKenney"
 <paulmck@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo
 Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org, kvm@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
Message-ID: <20260811104229.72fdd928@gandalf.local.home>
In-Reply-To: <a552b227e18ddbb3fa1f2edf2d1cb30ee6ccff13.camel@infradead.org>
References: <a247c49dd61af1df7ddc4dcb1cccbcb36b04d9d5.camel@infradead.org>
	<20260811135537.GC544626@ziepe.ca>
	<1d669aca4ffee797b9c29215382444a5b23624b3.camel@infradead.org>
	<20260811142730.GG544626@ziepe.ca>
	<a552b227e18ddbb3fa1f2edf2d1cb30ee6ccff13.camel@infradead.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19dAleZhUOu5jMhgkH99lyj0Dn95BWTID4=
X-HE-Meta: U2FsdGVkX1979J+Q3OdtvU+zN/hhYl9JQhI0wFYQuN1ZrCOyLwM835zzoagX5l163DZzohmxYfjMQMg9LMvXrD6bg3AeHd1TrLiR6S1r8L72HAN+v3XhoxZRX8xO+2I0Jc1dgxN+O60SUmzois9+y6MU9QJdwUAoXwKZYXZvgflOY5MkQGkqp/ZeTZ3GzgxqRZ0WF8S3WS8LB8o7TyvqBGXiA98/d9imuVuTVh0RKt7dphRhabMtXLx1CHkUp+8F6TrPt7w6fDOjixFfwzPAI0/VQK18sVl3nuIRCZ+fXGfIeFWakblsUYrcuLOfrE2v16Fx2y20k2tKyfUJUKu/Aa1kEnu9UsWEY7fVgeGUG4kiRo2q1nZuksArsq2JybJg
X-HE-Tag-Orig: 1786459338-307469
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AEFF7100009
X-Stat-Signature: oxypg9f677wxwcpnaarkrfp38fcwugwo
X-Rspam-User: 
X-HE-Tag: 1786459344-107451
X-HE-Meta: U2FsdGVkX1/kAuQBQKZ2jg7djF3EZK1gmAygtqdndF5b1dMUOdvarAV1kdCbraQocI5omZiImjzkh6Ttiao/mTp4EHSWIqrApk0s9FbQPR49LgLy1WFlQwnhfgQ9Lh1oK5r9T8EP9frRkTbXEcfGljiejJuImkQP56+EvXcfq/audD8eg9wIqg9BByo0RFHoYh/0j/2Ip3OL6S71aRO6TfBbytsU+FTjbvbB1Lln0tJN/EXMnr2MIdwBOHqmKl87+KawliED1KcQ6x5fMpVF5nCRutQK90WVJCprA3TCRT/0/rKDMfrvNTIHhTg77QSFgllSBQhjYjjgJ6tnMR3GX3d6yDjCjvRcrUGbynClIm4X+npfvogFIHkG8GWi/6tnPzTtoJv1KpwSGCCHifiq0+vQrXdXS1gwSge6jmohFipvIQUDbD3SKLw5jqT+k9IHCXLUSzoLcTR8tLb/4O8bT4c9hJW+e9lpbo4U2CfCjwFPd2gx+3biDvSasRf6jvWxVM+O0P3lfSLuJFnuOvUIq+QP8Usr0gGcLN8Hmclv5i7aXQc4imEbs8N9JSPn2q896zVDbzJO7+3unu/dyjAwRaW91XdHyIYs1qUmXdHhCM+UfVbNWyEUefpTzH/XtrHC0wTDK4Hch9lAlsIE/2vBt1tygfj6SzCwlvlu55ce9GEZIIhLZsSfuPs4q1l37yrwDSCGHp3t8uU5u9mEB9dm02Eg/EkNKt20JKPTBpy9ut2xBohGaFwMtP66pNuXx4/FWuARQ1A8F3+HpbmfKEvgj7rWpbr4dxiEWyctXZnP6n79tWBFEdEHZZFCq6PbIi6hanQjv2zWEm+1cw6T47QQQyq59Q31zIt6m04Py7zZw7YOasUaaFcG8XcQ4Hp1l78VPdmrutDqWYWzZ5kII0A9BTFladCNPFMZ0vLjdhhYyHqsEE3EO4lfBPamrEXi637QJqNm0bK4umCuxFrzHlQ
 Jrh4cfMc
 IPF3J7QHL1AS1nwwSldNTcVv/c7fbqfCrAlXJCqwAM3oVQpvsRKwJLOvKDJhQH9FvOedIOnPRV9zJdog=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Aug 2026 15:33:18 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> > If might_sleep doesn't work sanely at all in preempt_rt then just
> > globally turn it off?  
> 
> Turn might_sleep off? Or PREEMPT_RT? :)
> 
> The RT maintainers are on this thread if you want to pick either of
> those fights... that was not the course of action I chose to take.

I guess the question is, what exactly is the reason for sleeping to be
prohibited? In RT, sleeping is allowed in most context because most context
are threads (like interrupt handlers and such). Now, you still can't sleep
in NMIs and hard interrupt handlers that were not converted to threads, but
I'm not sure that's the case here anyway.

If the non_block_start() is just a big hammer to make sure things are fine
in non-RT, it will likely still be fine in RT even though it may block and
sleep. But what it blocks on are sleeping spin locks that likely would not
cause an issue here if they didn't cause an issue in non-RT.

Thus, perhaps something like this:

 		if (ops->invalidate_range_start) {
 			int _ret;
 
			if (!IS_ENABLED(CONFIG_PREEMPT_RT) && !mmu_notifier_range_blockable(range))
				non_block_start();
 			_ret = ops->invalidate_range_start(subscription, range);
			if (!IS_ENABLED(CONFIG_PREEMPT_RT) && !mmu_notifier_range_blockable(range))
				non_block_end();

?

