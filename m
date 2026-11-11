Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C296606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 08:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SaMHMNHQ
Received: by kanga.kvack.org (Postfix)
	id 7520E6B05BE; Wed, 11 Nov 2026 03:36:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72A9C6B05C5; Wed, 11 Nov 2026 03:36:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6676B6B05C6; Wed, 11 Nov 2026 03:36:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 47F0A6B05C5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:36:47 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DAE801C2C2F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:36:46 +0000 (UTC)
X-FDA: 85422182412.21.603C188
Received: from mta0.migadu.com (out-4.mta0.migadu.com [91.218.175.4])
	by imf03.hostedemail.com (Postfix) with ESMTP id 61E642000B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:36:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SaMHMNHQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.4 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794386204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5xxIaNpSszE+yFqAyJ2Rb4E+WWq4DFNGesE5ueGQKRM=;
	b=Y3tiXkzCqKKjY2+oMTGfF79sZf969/hm253oeOJSHr56Qsd8UdKTmRPBQ+/NFy0ddb1ohF
	GoJYzQZx+n/Xuv+5ZItvzGPMvCXId1n1XQo0rEp66CQtaEKp7rpYdhQ33IniqXuYGIafnx
	Pkiye/wAV4W2p8L7b/uZfmLaf9y/mYU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SaMHMNHQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.4 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794386204;
	b=QDjTHFcMcf9LexZj4T296EjdJjlxFu4UO0NhDQWiodBahMJuRHWkKYr+yTd5FEyKbWXx+G
	pJW5WkX4+26kZ/mWC/GBnuT8lUvWPKMHC3L8Z1Fms7n55w2l1QCuOqOwCnWrAVH7QFdmZn
	HKftCal+tOH2VWoMhF1pDZTNdYKBQ5s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=k+uY4WofA8Sf868/Blel8K6cJ0//MXYQbHMDv5vxkh4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794386203; v=1; x=1794991003;
 b=SaMHMNHQF0bVSsgGyG9oT0DkpM1ywpR6EXqL//INxGPOfDNUgSWKXvJ8dHZhIDWWSLW/DGfq
 TAB4ekSEwqwsG7nVlZS/UJcg9ykxlFtntfeUSsPgRW2/al8mktHy4V1HDZqg7+swoTzbSQ63EzD
 Fnn9QzWQv/bDmtJU+9U/QIA0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id a175cba2f5d7ab7a;
	Wed, 11 Nov 2026 08:36:43 +0000
X-Mizu-Trace-ID: a175cba2f5d7ab7a
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: david@kernel.org
Cc: ljs@kernel.org,
	akpm@linux-foundation.org,
	chengming.zhou@linux.dev,
	link@vivo.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	tujinjiang@huawei.com,
	xiao.wang@vivo.com,
	xu.xin@linux.dev
Subject: Re: [PATCH 2/4] ksm: skip rmap_item allocation for non-zero pages under only_merge_zero_pages
Date: Wed, 11 Nov 2026 16:36:32 +0800
Message-Id: <20261111083632.57199-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <avMKhCLDv-ybpmIZ@gremlin>
References: <avMKhCLDv-ybpmIZ@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 61E642000B
X-Stat-Signature: c1zwk3fya34mitfo37ryij8gu37gk8tm
X-Rspam-User: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794386204-292138
X-HE-Meta: U2FsdGVkX19ZD1C+iLrCsWqLE8kKmqTF5mlDLHvo7kOztGMSkLXvvEAC+C+Hu/zrSUAqJl11aLYB5H2zQICeaItssq3xqyeFqgyoArgS+lCKxRldX2emB6oeYnLJuHE8hNDr55WQaDdjmh3XN+dFJfR/j5Zs5sdgZa+l+wdef0Us6E8PQb6CQXdyQ4UKJ1Q1JrFOj7mnvmZErDsQ4/spLbH8j11JSWSTTCz/8yzmtxbY+b7vI+uYxZVmbHrZS13kc8A9hcyauiejGI1YmzuWw7KTxPPpUFGs8Qm6SH5vfHJdAwJuSBDxqOqP/y5PZgmmCiPpIJJGbiM2pI1xhO/WqZ/fiLYekigMO0klkiL5Mzb+n/tQ404t4DGPR/UqqTwiWZYk2n7tsS0Jkvae4AaaSFry4EGrz2vcdajPbprJfHs1f587yJJQ4Ooy8yOYA2O8b/qu2Wr2o++kJgqx+QS/S4K/QUGXcSiO+qsWhBuRc1p+57IjAz69j7RyV9P/c6aq+eXs565L+xLlA17Q8yhYEBk2KqHmetY0HJ0MLU7/ahScJBnBdnA/M3WASmPeJKwsOIamwKyeHwN5AxwTJc/db6jEs4TJqpyvHkJig2vWlZyFqyxdow1nCRQvKFJy65CB3iOvq1KNHzFleZ//sqy/q1Jz+qWGJCv139jZ7gQBAXkN/7FXF/Vd2db9u75ZlCYAMGpje88P1r77RpC5+ZzGfRf51HbWmtR2wMUKdIkuUoN+mEI3mugD70riZJVm7cAU455tNYW4ZiaZTTzQZcSDW6gJQMrZaq6RG3ibStobgjuIt3QHRqkkRF/6v4KJZ9U3qs8+/26zo7BE40mg4/w9iwEOgewcggUEwFKPuSGYCXRva8CTdXrbB5aey+DTxN9jrSOcVlQ0UgUOmzaqQkAk99DCrw7g/0vxFKSFQVZvnMAgpmJ2eY+se5oYuA012o/8SUibUbPd7IouL03Ap3j
 dcEK0HQG
 lZZvtjo+O58v7jpcsKXOKQIow8/aruhL7xKOpTAoDn3PaVdjKziHaIgTr7o6JN9s3OT7H3t4aJE1G6LM709wcqYAOe5jVAQcaPMMdYfpXosueEOOkp14wyrnkLNMbAUNEVY+9dU1YxF+Nzh21WoW+KW+yYOn7TAO/M5rV7EWUqv2HmZ+8qNfgg/wc61YqpX+bFz6XNTo75nOl11rw+eZn1MwR10OVxFWCP1FvTxxdQuBWqM+MeA4UoWXlwIXtjnaUphCDXv4KZD8HfAHflvVFxx+4MA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> On Tue, Nov 10, 2026 at 07:22:06PM +0800, Xu Xin (vivo) wrote:
> > On Tue, Nov 10, 2026 at 10:05:20AM +0000, Lorenzo Stoakes (ARM) wrote:
> > > On Tue, Nov 10, 2026 at 03:44:49PM +0800, Xu Xin (vivo) wrote:
> > > >
> > > > A page that is zero now but is written before cmp_and_merge_page() runs
> > > > is still handled correctly, because the checksum-based decision in
> > > > cmp_and_merge_page() (added by the previous patch) is the authoritative
> > > > one.
> > > >
> > >
> > > Please re-write this in your own words.
> > >
> > > It seems very LLM generated, LLMs are _terrible_ at writing commit messages
> > > and commits, please re-write all of that.
> >
> > Indeed, the description was generated by LLM, but I thought that was clear enough
> > to present what this patch do and why. Aparrently, you don't like that style, I'll
> > rewrite that by handd.
> 
> In general we never want LLM-generated commit messages/comments.
> 
> I do however obviously appreciate and empathise with using it to assist
> non-native speakers. So that's fine, but ideally you would write it up yourself
> and then have the LLM do simply a polishing layer, keeping the length as small
> as possible, which should give us the best of both worlds. Thanks :)
> 
> >
> > The goal is only to avoid rmap_item allocation for pages that can never merge
> > under only_merge_zero_pages. The implementation is simple.
> >
> > I'll send a v3 with those changes.
> 
> Well let's wait on David's POV on this series for this cycle before a respin
> first thanks!

Thanks Lorenzo, makes sense.

Hi David,

What are your thoughts on targeting this series for this cycle? I understand
you have a lot on your plate having just taken over mm/core.git and are
focusing on bugfixes right now, so I'm fine with deferring this to the next
cycle even though the implementation itself is fairly straightforward.

Whenever it's a good time for sending a v3, I'll make sure to address Lorenzo's
feedback by rewriting the commit messages and comments, and simplifying
scan_get_next_rmap_item() as much as possible.

Thanks,
Xu

