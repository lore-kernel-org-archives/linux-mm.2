Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0D45606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 13:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=DeXdPd01
Received: by kanga.kvack.org (Postfix)
	id E4B786B00EF; Wed, 11 Nov 2026 08:21:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFBA66B05B0; Wed, 11 Nov 2026 08:21:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEDD96B05B2; Wed, 11 Nov 2026 08:21:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A559F6B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:21:11 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 385ED1A02B6
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:21:11 +0000 (UTC)
X-FDA: 85422899142.06.CB90621
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4EFC3A0004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:21:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=DeXdPd01;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf15.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794403269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PYuoCzh2yR7S4/PCmlQnO0kIR6L0HxYUQSPuZmL3Vl4=;
	b=fZPYbUpOp5QZCDx69RryTQp4BlivmIeHWahLLuFAJcS3JZGGdB0D30mRWhTnT7G9DCDGvs
	hBz5RQWqA6C/W6tH3uC7X3eGpdn/KzPzXHSCMiiKCH85Oo80lHPXQzUNmhQyF1MMEN97iz
	MrxPpwwdk20xvkfW6p/mJ9EEK+LzE1M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=DeXdPd01;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf15.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794403269;
	b=M8pNkgfBAf/TTuW0vUS7I7XEXGNMhX48OU+XPOp5AbcwrTHx34flRXA/f47t3w6tt6JbQI
	z8DcTO8aZQenOPAYkLjvYs1ACQX/VOcTbOm7jlgEdGAwAjR7NStSs+ERmzRV8aSF1kAvJT
	CuYw7bj7H8jGmWrEm7bAe652iT9gTNQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PYuoCzh2yR7S4/PCmlQnO0kIR6L0HxYUQSPuZmL3Vl4=; b=DeXdPd01EPNeIA8UkUK400Ft/y
	7Xh+/qbI5mEkmurIwL9kovCfjH7xxWtktMrayqxXXi1u+zjUBqawOQUs5CEN/WeIgYvr6kzED5gl3
	4AK9QA/Jel26w0wUBYKcd/8LFHpoI6FMq1kOaZcOVATD9Bc+DPp3CRKu3qaFfoOzhaaJgqO60ksQN
	lvYq5MuZRecjTfN+HSzgbv9s9rAFQThs8kc/y71jPeI+3Q36Q1o8Je2EP9rNI5J42ItlevQ1WkwpF
	zNQJndoN8RhxVs1fZMdys6nrkrtztyabR2eI/+w7Bcs1zt1jWGZ1P0kF5hpyB+h8wzJTFECOQerKr
	FhgYoKjA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xR8GA-00000009AL8-2l1X;
	Wed, 11 Nov 2026 13:21:06 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 262933005AF; Wed, 11 Nov 2026 14:21:05 +0100 (CET)
Date: Wed, 11 Nov 2026 14:21:05 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Shivank Garg <shivankg@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Ankur Arora <ankur.a.arora@oracle.com>,
	Pedro Falcato <pfalcato@suse.de>, Borislav Petkov <bp@alien8.de>,
	Bharata B Rao <bharata@amd.com>,
	Hrushikesh Salunke <hsalunke@amd.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>, x86@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/memory: drop PROCESS_PAGES_NON_PREEMPT_BATCH
Message-ID: <20261111132105.GJ2668564@noisy.programming.kicks-ass.net>
References: <20261109-clear-pages-batch-v3-1-6693efe18dff@amd.com>
 <20261111124006.GI2668564@noisy.programming.kicks-ass.net>
 <avRnJiDLdGcbSW5d@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avRnJiDLdGcbSW5d@gremlin>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4EFC3A0004
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 6qpp46yh8nkw5mix6fzqadhcq1xx1xt1
X-HE-Tag: 1794403269-611961
X-HE-Meta: U2FsdGVkX1/YkTHM2Yv7okyqL1JlITTXAuVfWoCDGJrNgB6g/DVqju6NOXEZQuivZa9mUSb0de17xPeGf6XYe69VIzhu5gi+globIPYzy5KGcev12Z8x0BBFBgbTe0xG4XasarChZNKpJT4tMlr3pwmnlKyBRK/rnWwhq3tsYMTEZQCujJ3EWxQZGfapub/injxdVSeGKF4o4bdIh/H5zyBXm9dQtFzTlPA38dsOdY/ntcaSqXqhzKvM+YDPGO0DXLVdUcsoLIqds5kLF3dpHKYL5s3bzpgNBavtTA5it8yizXvUg9N2XpHPY0zF0lQUtYt26zdY+4K/boXRvVGInsjiY7v5Sj5l/+20Jun17x+eFNXgl8dJYe7RE98z8XOjoVCRvj5hvIZ2wan3mPtewzjkbOy4W5A1btfM41iYMVdaP7iyFgsssiH96Tz7crVtdBNpAZI4kYrA86G9nA1okAyIFsDK6ocXYnTlR5xDg4d+QamsExJCq3IuoyQZg5bMgohsiXFAdPo0QPb3LIH2ZkvOgVndHFMGcziEsDDGPc6ivmJFQGPOxJrZwCabvBEvvpOMhPTES5cQeu0wH4L5Vn+H/+lZ6I+0Wy3FzuvYCedUoc2PXom0xQpcIyjX5yDWGNGt7TjKXOCar5ZtTqqiFFbJEhfkZyFsgK3krivd4fVIkPDwiKfubM+1KPstkBGchqmUirAhoBrY6RJbLLRjeSJF7b1yM9e75L/S6eUAanUgrbr8KMHP6aHh7haRkAqqs2STnRL9l9oKXfHrM2b9OuNsfMTJ4683qJ9efRWWmqOMSfuC8LmP721wQwwV9BVgHhN50SgBlfWHVvLhnrqALEFoqQDKBy95v0jclpq1pucHPsmlQB/IPYkBIYyYSxCs94ixjPfsrznHJE1c9WKF86q+m4+jI49+19wEWYBNKvYGsMbOrkpKfOhL3uP59uelemFIic1ArOIqgU2hTgs
 E4B/IYIE
 uxInGPJ8V00Y9/InfuzPQ1gutQ7sASTcGItHN4NTEEoZHYR9OSTP3baD8KRtkPcA6O7um21S9Mi4GzN8iobld7vcDjKUZfIGuthIXT4U/5AYAPMxKz1fhTbvW2YQjlK2eWxd/zFsPdcmNAlAHUsXIgw044MOejx5u3EWqwedQXZJsPymhbeRDsVMeipiKK1pxnLw5qmiCOaTSblHelKqka3nF2X3kDi5zdOkhOm/OGFzr0GgyRefzDUKJKS8J0Z2XgW1m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 01:12:06PM +0000, Lorenzo Stoakes (ARM) wrote:
> On Wed, Nov 11, 2026 at 01:40:06PM +0100, Peter Zijlstra wrote:
> > FWIW one could do:
> >
> > 	for (int i = 0; i < nr_pages; i++) {
> >
> > and forgo the earlier variable declaration.
> 
> I guess we all got used to the existing patterns and I for one only
> recently found out (doh) that this was legal in kernel style (because I saw
> it used in KVM)...

Right; which is why I keep reminding people this is now 'legal' :-)

