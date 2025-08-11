Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40F09CA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 09:08:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D46008E001D; Mon, 11 Aug 2025 05:08:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1DEB8E000A; Mon, 11 Aug 2025 05:08:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5B0E8E001D; Mon, 11 Aug 2025 05:08:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B50428E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:08:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 66BF41DD8D4
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:08:52 +0000 (UTC)
X-FDA: 83763901704.20.6EA6717
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8C7C51C0003
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:08:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JqBwC5QX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754903330; a=rsa-sha256;
	cv=none;
	b=mxH9AJq/bQxP+VhVuIE7rjszRH4RjDHI7AFxlonBzwtNEr9npodCIkHpQ86TeayB1EEMgM
	nJjm2ImKuy7eRgZ0qzC6JPdqUN6jKVNksxTgDBb0scj2q2Sc7LShS9rKAxVyukwoNZp920
	+4uTK4qZl59oH0hjWdLx8Py52ucAQeQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JqBwC5QX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754903330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A7w6hRtswdKKWxQGm/mydBnvkPywUGlFP9d4b6AUpcg=;
	b=k+Vc3fsk/COQF+uSWI2+dPqfA8WzbaaH/AQAQb8nLxWHveijM4dttPl1ZLc2uP0NI8U6Ll
	ymwvn2rn21GZDwLHVV70IHd4Qbrbk4WmqMsIeuzK1Lkxah+89JTn7SYLqnhTAbtORb+Ibc
	tB2JotLqt8h4byE1YTAkhvYMjZ+sD6k=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754903328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A7w6hRtswdKKWxQGm/mydBnvkPywUGlFP9d4b6AUpcg=;
	b=JqBwC5QX7WWfgNhX2rH6o/DYC7q4vsktCoWp574FPmy49v4EZw7RbrwHbdc7IhwjH/X9eX
	s/2NGyD5tsmSgtcU3TOHLuFdDZKrFJdwHceF4kjWHBOj+LCJMzjvAnm0RcK69ZprPpExVH
	7CKwOHZrnssG6w05DvrZG0sJm520Glw=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH] mm/hugetlb: Use max() to simplify
 hugetlb_vmemmap_optimizable_size()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <7fb6ce41-a5e7-496f-979b-775b8e30e764@redhat.com>
Date: Mon, 11 Aug 2025 11:08:34 +0200
Cc: Matthew Wilcox <willy@infradead.org>,
 Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <C6C36750-2C87-4C2B-B683-9789F55D34C2@linux.dev>
References: <20250810214745.2368-2-thorsten.blum@linux.dev>
 <aJk2IygsxWKYf17u@casper.infradead.org>
 <7fb6ce41-a5e7-496f-979b-775b8e30e764@redhat.com>
To: David Hildenbrand <david@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8C7C51C0003
X-Stat-Signature: oyawqy6zjqi6bsss9fw19zs4rjyhoufg
X-HE-Tag: 1754903330-411830
X-HE-Meta: U2FsdGVkX1++auAn5QO7EoO3k28QoWx2fXPHGvDOy5KM/kxjW+WGaXu/GIqusHw3UvUxBuR6+/xdOR7Ed4Fu2EDt5BUiZpDb72OLgChDgZvuSET4A6vNyBsK7mOpifN3LlxnjYujiTj/omGskcJQsyLfjp1QHXw0yUPqxvTuXiCezbbUbFG6WIsB2xlqPL2YTG3QWXP9vJpPKwivnhxQRKDqejgGyfx2NujE7F58m0mP01qfemTu2F4Sf+uZjviHNhDVrePR5zpnYH1nziWV9MNuLZhhTzzip4aF+j1CjQ7LqU4VUa1iwwNdfsxE7PZxCNz037N2/wE3Lp88uLeZCsDDp3DAkEjqKBpsAcbg2Cb7YyuDHbZluAOWcuyn66WrWpv2yWGf9hmbZgaIOaxS43CbXxBSchWHo5KpkMZXL2M3ERQu713xoIQLKU9LepP9yYn3lFz1ZhXTj7X1NihRWQ6uCdNRN/JjTx0u5g2e/+/tWfUOuByt+xcsfr9yC5CHV1LmgPWWpRieGh3x4/UFe1yMSxuYDd/Rvki29WKYWhu4UTyNcB1yfxgrKaHu3SW+mG0dAsz7XB3+txCGF/YOkxhH+kpKrVojNG3WmgfiMvZsvDyqsFKnW3SuWJKWbM6GWvnG6GQL3JxhkVzewrotjqG+Lk8xnPMlN5uZNNcyjus7fgcJMHT7cpRUJxU7ItJU9cQ52M2Fai/dlKZU5QFEd+8ylQ4CSbiq41XbzjLsx3TbAkbK0I/MrHubxHOf7dDiGbgxD56pNtBykQMX01SIUjfKLc5nrsnD/v8GmnjQM0cl5u8IEO7NouVGsawfIilyawaLNQgKDGUNWJJ8P+mQhpGJKsoND/0oMuuL+oedVVLQTUk0f1PRVLuoLU+SkIWNaX9MPU73avzoiG4e+yZusBWM9pShujPi7UhpVpUlwGBqm+GxOF2teQ8+zwCU33Wj/JN1D62wyXDTHYwCBMS
 q2P3X4pj
 bB4mww2GzkNYG1Rc3BOF9nkJB2CNWBhwTYylubnl3Jln0UIB8nlE1sT+tXuNS1oq5wawC6vI8K1SZGUMaTs7mpTM51kv8patVbvz3t2VdOrUCpAiQcQRXj4shcf/HS6bGCJmGHucfOqLO1mwe+JXcBRlo1V8AZ0NWlmZuqvu/6tA1+ljEyeUoz+tkVywC+3V15VuZu1aXJ9Yy7FNBM6qcMs0hbPJaAdwzn+ku3phlJ4Q8Up5qHCsyztryERLmT99BAIFc0C8tcGa7lVPQfmNTLFC10BcVcx7xx2fp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11. Aug 2025, at 10:26, David Hildenbrand wrote:
> On 11.08.25 02:15, Matthew Wilcox wrote:
>> On Sun, Aug 10, 2025 at 11:47:45PM +0200, Thorsten Blum wrote:
>>> Use max() to simplify hugetlb_vmemmap_optimizable_size() and improve its
>>> readability.
>> That ... isn't clearer.
> 
> No, it isn't.

I guess it's personal preference. I'd prefer max(0, x) over a ternary
operator any time.

Thorsten


