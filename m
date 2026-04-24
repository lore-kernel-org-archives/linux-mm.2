Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3051FED3DF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 15:34:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0EE96B008A; Fri, 24 Apr 2026 11:34:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE7256B00A0; Fri, 24 Apr 2026 11:34:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFD0F6B00A2; Fri, 24 Apr 2026 11:34:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 899A66B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:34:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3AB061A0223
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:34:21 +0000 (UTC)
X-FDA: 84693845922.12.3691E4F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 37683A000C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:34:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=RR6MS8AZ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777044859; a=rsa-sha256;
	cv=none;
	b=PG9VZztI2dE2aw9TbpAsWP26tVt07JwiXwUMzhVA6vwC+cooeVzXPngvcSOYvZX/4EQeRN
	CYEmejnQGYyM6UaEgkVnjPZSE9kJKK68LDl7KBKdD606t7RgQztL61Thkt2cIejRBhXbSH
	e9bV8gM589ZuBA/AJJHM2bvK5pWnXY8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=RR6MS8AZ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf25.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777044859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a4+pgU+NOVMpYPBvLE6fPcolyKcgS2xdHtxW5mhk/JI=;
	b=Sw/hHpplnjK2fmD8H2iNQ1DiCwKuZtectfLYBybpVrTMg61kmJNMcn2IHoIy3uWSnkLGTS
	mm3cEmPJI81Btnm12dalJTvrI1MMgB5e1TAOuRymZ/oMGF5WCQlCV2+yCqsmKIpKNDSELJ
	tUfBEx0CXVakKgE4t9JTc48+Odm0z0c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=a4+pgU+NOVMpYPBvLE6fPcolyKcgS2xdHtxW5mhk/JI=; b=RR6MS8AZVqxdv9GKFbKJ9/6dWe
	tPPVqT4d/0XBnTmWSSMgDp5pcm+mJWVV5xc4riFRky0ZEx2e6t/5I+lke7VP6zkEOgcmjYodWgiId
	y0TSQCM9ssNO+ROqkh+/WDvxpudchcJPLu9YUloWhtf5JRXJzaIx+FKyCJWrhw2EJG4woWDXHSlbs
	JlNOvpaXgSQb6YRseKGK7wHZYsivOJRut6TPcBAH6rBnKBH4yC5APPF/w98oKyc0AJdIHLQRLJhtk
	MwMsyCWr25G4Tgg+GXG7EWVMZk7uZ3fZ+5wjz0+XTl/sssCBwa5t4fCASKtsk3s5wXqs1vVEVkkHX
	NZgX4Y8g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wGIXl-0000000FQ6e-0GXQ;
	Fri, 24 Apr 2026 15:34:13 +0000
Date: Fri, 24 Apr 2026 16:34:12 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Sasha Levin <sashal@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, corbet@lwn.net,
	ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	skhan@linuxfoundation.org, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/7] mm: dual-bitmap page allocator consistency checker
Message-ID: <aeuNdOmgxA-k9BqY@casper.infradead.org>
References: <20260424140056.2094777-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424140056.2094777-1-sashal@kernel.org>
X-Rspamd-Server: rspam10
X-Stat-Signature: qdyny8ze6dryu34ic94ykkob46ygmgw9
X-Rspam-User: 
X-Rspamd-Queue-Id: 37683A000C
X-HE-Tag: 1777044858-701136
X-HE-Meta: U2FsdGVkX19KZ22huh1XKwmm2fWAZMQPgFjs2YQHHKxSKJly3kmTNIO24WlUEb6Emms07QLFwwU4nlh+V1ultcV9jk+kdRIoaJAOmOg2escDTU6iDJ2dfH5X/WOPxJB9kPKBTvVnNzG4UI852iLJzsy01IdA5PvnI6WL8A8tvzknxmzh5d53znJH3c3HD8MyA+SqHZrTrfvdmScr/o0P5UGMw20xnzISrHjM3CFbBNINbHEQr0MqOUQpt/Sy7wf/eXRekgUmhtoo6X/p1RRJSVBNbFjrkMuCUDjx7CwyOzcJfULhbMTDneVh9udeKJd3gFQJVHHZmZ/agX74ciizP1uK6kbk0Fxbycy8BqZ8J2IO98HBpssIABKxU+1OE+0ypOwBtMA9gxfunWhfHgl8Sz9LDskBeyP25LX0CQEDU/cq8+3+O/TFTiy12HLINpdx+ETILQJVHNXBEo0sofAizBfOCX2wehu/95UKqOP6WxHHKUckousrUmK/XUKg/f6R83VDVmQeMRAWtDme2aNb0OU93kvM+lAGZGhc7YlN+EMLWfldal+Ix7tv3yHUXgo2XIhDU4s2XOG8nAHdT7/Pf9v8h1tGZQU5pW1s4hMW9p4I6Ynl+5eeQUUVdUAOSnRh22RhmFA6kPobPRcq+cRTMtOPRuTUgotXlqjWvXQStrY3CSxTqOBCK+8SepZgUoUziatw2nA989IHWVDwt+lNVaIfZOxiQ+Vi6LJQT/cwxJcyOmbGuUjOO3ci3RBwM4l0ddCDVCPXpdPKaVi0bSMtJm+P2ufjGPPSzZIArnGk6Cmjv/n4qKX6wZQjzdidTW9M/pglgfLOYWyFZK5P8QF0b/joawMUU+lot2paYYvTf4Xo9hXUZh8yTfes73RfB8KfLjNRfSozRkH1C+SFsPU68qrfULe3hEAvH4zqTG8RXaxWHzZ56F4GW4u/gSr4jtDPDGj60BsEyyjwSKFcBS+
 GVQ9T01J
 tPNtcTLJpq5NbbehpuCGER+8YMI7PInIeckD6kDh+q2qYIF5QAEM7jbLaceWFSYoZJMCPTfm1jjRPRMO50UwjxqWI3/FkAQNr5orHeFBvZ2Pp1PFSaD9IQjxNu5OYbL/KVV0V9S6IRZcDLgRk+u8wW1xUKunqjOjyEGg/52zDkBP4zBuxnHu3RTF9L25h4RqK7ofnXr9da76ZfuzHezSnSD4b4J6jgdCH4MpWhoiVg7C9qQlgejYwZLaajl+nJlKwYSgy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 10:00:49AM -0400, Sasha Levin wrote:
> corruption must be detected before it propagates. The dual-bitmap
> implements a way to protect from corruption coming from hardware or
> software - two complementary representations of page allocation state,
> allocated independently via memblock, where any single-bit fault in
> either bitmap is immediately detectable. Performance is secondary to
> correctness in this context. A safety mechanism must be simple enough
> to audit and certify, must fail deterministically (panic, not
> log-and-hope), and its correctness matters more than its throughput.
> The dual-bitmap adds two atomic bitops per alloc/free, but for
> safety-critical deployments this cost is acceptable because the
> alternative - undetected corruption propagating silently - violates
> the system's safety case. The static key ensures zero cost for kernels
> that don't need it.

But doubling the storage requirement in order to achieve merely detection
is significantly worse than state-of-the-art in 1950 (when Richard
Hamming invented Hamming codes).  If we used a (7,3) code, we'd have
SECDED at a lower cost.  Of course, there are far better codes available
than that today.


