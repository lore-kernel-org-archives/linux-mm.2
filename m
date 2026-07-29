Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 762DFC53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 18:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 664C26B0088; Wed, 29 Jul 2026 14:28:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 615FF6B008A; Wed, 29 Jul 2026 14:28:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52BD06B008C; Wed, 29 Jul 2026 14:28:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30D246B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:28:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C5021A1C7E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 18:28:42 +0000 (UTC)
X-FDA: 85042650084.11.289AC94
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id BCBD640012
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 18:28:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OYDUqxSF;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785349721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oRnzRJMDZ8iuZ3LQn8T44elp+xM+94WMNYL4egIn6js=;
	b=211qLF6Lwip2H1p72pKsLfAMWjc5xsMxM+lORsHT1cN2IOobwBrrvyxjKJhDC2AD5fefRK
	Dz4mGd5oL4AlHP9IGzjA4Swz8FOySskAekBjaPjBxHjfSETn+0HsJXQA4TUrZcxxPqx8s5
	SIoMC+pb/CdWZeGVJjKlzopSk2oXr/8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785349721;
	b=bhJcrek2hhoMHd677kdCzXo33/gqDj8PCYyX/9xRWyM2/Tx5lK0p0xOBrDQDnAcq0vPvld
	BI/fLBe2/oeQpicXcs+pdF+wJn/XHs+GTEqIU6ikr4uO8D3SeUbftDBXQfMlU3Hwy8cfqJ
	oZfJWfC6ksRf/dZy6yEsluX0INZ9mjs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OYDUqxSF;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oRnzRJMDZ8iuZ3LQn8T44elp+xM+94WMNYL4egIn6js=; b=OYDUqxSFh7l5uF3hrR+GNzddO4
	IFnHCZtBQfpOpowmx1ZA4Twp9S8VJyLoFvJSgAq2/CIs5HvGc3fORKqRYBKscvjuE1pKaTN5HUjr+
	YcGpcJNHV2dD7h11tSd85LRzO5OMKFOL6SV5XvJMe02JDXrEcQqeaHJ1/1TVlh4s8o3ziye5120jd
	JgO285Vd8Cp9lB5V5N2CIObEICB7rPPUDQY25ooiTtOXwuFBoET0CHS+wHsf/Cs3Th+24fOH/2MZ3
	nAlaMJppv6WXN312cZ2yMSEOnlSnTwj02dbWyQ/Fv3A7v2LdO3aC0idqkbUs+oE0Ll0IWg7H7FZZ3
	E7nnsd/Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp91A-0000000Avaq-3Olf;
	Wed, 29 Jul 2026 18:28:36 +0000
Date: Wed, 29 Jul 2026 19:28:36 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Artem Lytkin <iprintercanon@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, urezki@gmail.com,
	shivamkalra98@zohomail.in, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc: make vm_struct.nr_pages an unsigned long
Message-ID: <ampGVI1MLmnLksnN@casper.infradead.org>
References: <20260729175708.7074-1-iprintercanon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729175708.7074-1-iprintercanon@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BCBD640012
X-Stat-Signature: jbr915mtttp3nnz4wggjxgxegq6dqbr6
X-HE-Tag: 1785349720-592913
X-HE-Meta: U2FsdGVkX1/Ql5ardENFZczPhDIrdvRj2P5hmMYo2Xj2/g+BdaSfl+bGfE77YPD2BKQYuHKIGzMMn/JIk+uMHLK9wke2uiWIHV4o9aoAMCE1vf2p3FSjsiNbDLPaiW90fhy/1UBgw1xbaxFR/g/yk60150zzO4IehJyfg/i01uXV3F095h83sYB/Ql7UyjF7Ysj6qOLemxCGb4/TzbvknOrTHvNr4kusG3tPYWhKw+L+S3HSXumfdrMEuSh8PEuFTrWdPYLFByWmMElK5WSq/B56CoyG4WqZXXSG46/NmPPlHP0VcdGOSGEL1fetyCea4jcfj/nuh1LtFgAWG2jFBG65kkTbtCEZt4mde1W4law3I79Z4ELGb3DisrpBFgeo4vmudz+zaXpflnbn5Mgp1d4F8/GD+3bYoapMi7Q5Qkko0FPo2ii5JLkaKAwAuFpPZvFcL9VZbTyoqxkCM9YO2pmL6IwxVe96wyoBbjMdammP4LmoFu2vWUQyGx3eLm3KutdSgJR4vQpQ00UJJk5VDbGuoTgyF2YOlnmWrEbXve0GAGQGoq2eINkj5USXGnAPsE3KrN4+877RXUYN8+j3/7XCJ9lZNmTEjf7/9ZvcMV2IGLwM1XJ46FYwnqd+q9K+uPTLg9ilPv4xxb+6M4P7p79T2zhJW9TWQssc8bTLAOAEKOuhvpIJau01xEcrsnqGWycSHeNWlJbUHb5GiMVLv57pxuXB5+HkPTWaK/+7FqTxdHwLPQ5oIjUJTRAIebfPaJRx8XsGUsLvR4TTvO5LbDJiEWqmr8wZKc/iYvUTz3btRWnoOnG7nbKR5YIgkwwpfNJPW9uozZCRQf06TqhYSmQdKcW9CJGSljRhuGdQSpqCE25okD2/fIbx8WXVhAilINefk51AzVzX2McT6+oEhEqkN5IrkpfDWtMTq1kKR0/p90UBj3aQ9IyNdn1eQ9TD+Pt64OwI715vFpqi6pT
 OWie46qS
 9KRHs4DqcksIP6FpAB5e30ufNrrh0ZavawF25L539wxDFuGuiwNYBG6MEUzXerGzRfMLXqA4zt26G+TahndIZdQ9fODFgn7GTjiEdazFl9Kwd2YYi1xdCHK/IVbQyRtDQc7rKfaW0ZRH2QK5co1iC/c7HWK0Pqy18hUffplM+n5Z+55fVVNrq7YvezWCLq2fDNNV5KFIb0IerK61eVFbkh6N0EZqPfctj3S4ts7haeg7lRABsECQodYgz56gJw1vSN/H5Q2H9FV8DGLgdsz39OtUFlm1go+blnsB9ML8AHnQw1xVRi7YBL/mnMbq9Pel9/J/j2Jjn+Q5V4dc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 08:57:08PM +0300, Artem Lytkin wrote:
> A vmalloc area can hold more than 2^32 pages, but the page counts

I had a "wait, what, really?" moment.  And it can!  2^32 pages is 16TiB,
and x86-64 says:

   ffffc90000000000 |  -55    TB | ffffe8ffffffffff |   32 TB | vmalloc/ioremap space (vmalloc_base)

So we can have _one_ allocation that is more than 2^32 pages.  But I'm
not sure where we'll get the memory to populate it from.
https://blogs.oracle.com/cloud-infrastructure/announcing-oci-compute-e6-acceleron-instances
says I can get 2.3TB of memory in a single machine, which is a factor of
8 away from where we'd need to be to actually hit this.

Intel are adveertising a max memory of 1.5TiB on the 6990E+ (128GiB *
12 channels).  So if you put 8 Xeons in a box and loaded it up, that
could get you to 12TiB.

I'm not saying we shouldn't fix this, but it's all theoretical for now,
right?

