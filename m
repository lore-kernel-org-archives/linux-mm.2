Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A20C2606A327
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 12:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=i/OUSg5+
Received: by kanga.kvack.org (Postfix)
	id C03FE6B05B1; Wed, 11 Nov 2026 07:40:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8C276B05B2; Wed, 11 Nov 2026 07:40:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A54E56B05B3; Wed, 11 Nov 2026 07:40:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8016B6B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:40:12 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1598CA02BE
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:40:12 +0000 (UTC)
X-FDA: 85422795864.12.B368EA7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id F35811C0009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:40:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="i/OUSg5+";
	spf=pass (imf20.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794400810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qgplpSXFt9kNZV/HSecSD7mDG6E06HWpXDTh4/+g358=;
	b=SC+i3KmrAEimVO1gCGxVbPu4wVTi+093gMtf23HKOCtcX0mMJqp8IsyY8CLfGbfVOelbqj
	f01MqtRu6T9JJ6WvtknMVbPopCqUoHYBeWCo3ZW36h3X6TMMb80vb1AWSpjhDKWNuQJSEQ
	sZl8ddDMX2NIFwcIqlPsGcWYU7mmRck=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794400810;
	b=uXeK0l8jJN1nCLbGQZLXsE/MnHc0H7H8vz/18w4I+FhIVbedzGp01dbYMrdYex0Yp/j6TN
	xaR4305xFQDJM4DV8uK/50OBB3Vie/Ye0fRPH9PEI5m2AUu0H4pL1yYKwOZi/Y8b9AXisR
	kt0pRvYeTu2yM4PrYLSER8Z81pMmbAM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="i/OUSg5+";
	spf=pass (imf20.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qgplpSXFt9kNZV/HSecSD7mDG6E06HWpXDTh4/+g358=; b=i/OUSg5+TWZLA3ta+dWabCdJVi
	jY05z81FkSAAcSbMoB29HH0MA37UEyYshhkkQgNWPlCbrxAb/v4xM4M/M1SDmLsCBIDKayH18b/7i
	U+sIAp+35gY2bayXcIthW38UCXVTVqbbmebLp1h+CMkep3t2A5U2Y/utsr5bZ+C+xVZIqYRvtZJ0l
	zDBoSXGAoD+cGGObD8w9k7oHYQdD0uFAcVoF92iCT68qZ7MQ+Bgotwsz6iA2UdzP4CHb1K6Q7jfMb
	11YO7tO3KrUSX488TbUxn0euCie3ZRlbCNgHtPYZk5+rKUocYl9xcNPQJrHDeDbP619XQNF45ObDQ
	ZiYmtjGw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xR7cV-00000009pUo-101v;
	Wed, 11 Nov 2026 12:40:07 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id C10C8300969; Wed, 11 Nov 2026 13:40:06 +0100 (CET)
Date: Wed, 11 Nov 2026 13:40:06 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
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
Message-ID: <20261111124006.GI2668564@noisy.programming.kicks-ass.net>
References: <20261109-clear-pages-batch-v3-1-6693efe18dff@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109-clear-pages-batch-v3-1-6693efe18dff@amd.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: dyr57g9973yt5d8n69qqk8zhjx9at4jf
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: F35811C0009
X-Rspam-User: 
X-HE-Tag: 1794400809-847995
X-HE-Meta: U2FsdGVkX1+c2byeDXurbGKLdiJVFqnOLS+3Re6D9v5M741PFJMcjM3cUscVd2xiNmt305+hDsYAgg5Y47nViN+NAOAX/PvfSrSsH1bdbPXi5DpN5l0IS6TQ9F6MH8I9r6aguCvMAhgYp7c4fW0gMxkN8mMMuKQ4apcyhq9akmbPhTlWNsD5/T+fNaP8aZ6zaX8coelEXYQPlrTjNn+CyZaFDyhvgV10TzwbaDT9ij9y7bAt7/4J0zL/ZlH1UismfxjjFNKUqZnelkQWIxPpbFqJlm9yb5cKnIZh9JgSj+6SrQ0v2O834EMUM6f76CQy4BXlCmVkp24JOEPoPwg+ASGCZddn3xnfRXk70rRE/ZWK+rlffl7A5lM66aggcj3B+zDecr9IFc17Ng276V10SXaTUwK5GblUamFhg0nzA7ME1V9lOcUMV/QclmF0s7OYy88OFqmszmURLAgSbDUDhhBlaxaVpeRxhRi+iO7QSWIGWnTZh7OTdWxtsxGKzoJjQZeStp2xCOK48TSLV4fvyaKCEaTrYtZPyhgSHyG8Z8YzkFeB8NmcSzDoxqKQ/cdLfHuCr+39UovUe/WMwu5kckzYEFCc4FYA6F+z541lJSrsjghXebiQHAfn0GnyLtYUfLRiLcs5wtFERqPCCIK19n97IDmENojLoRbE2jFM7/1WdoKoKhP7qpETQY+we2cj2scBTX4nt2sskbkMWEv+KxfclO7m13zzvFHEP4fx4rgbRI1cnEWS4LR0v6Y5Hl6nux0fIWCSZx2jj02X21gWrbs6zBrMhe59OjViHykXgxJQZOfQJ3dq614oP1iQx9I6CSDjN+CwQ5PnpAEB8x5shOT3lPMphh0k7TDYvIpzyKlKmJFfFIjRL0GPIbcasLHEJ9/asiwCwLuv/h6K1HZAICDjF0K7GeufBj9l1efVbd7RhLhm1MQsgsCtEFiGzJS4eP1zI1+sbyoHD2omMp8
 GQaw9dPI
 ys9PQijO0qsZt25g1vhnQANXzF7280K3b9ZMh0GXWlSj1OtBJxYuEsQ4I7ABNx5BW2/1zJN32KRQKW2IQ8VcObVojhEiLKaGw5cJUOj3YJjuuX840Nc4zEl8OUMrgXtwwd/QEObwpsFWA6IaHbWuBQlHynJBd0CxvQgscUWNZQ7u2nBeejT84SdJfD66nzKr5CrijE7Lg1E2/fbzONXfBukS1i0c17gOY/wlEArnTB348Uo3azx/JDpqSbALPu1vphy9Cq84ZtjH2o26vX6hbxDd71mxEWs3J6AOz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 07:15:51PM +0000, Shivank Garg wrote:
>  static void clear_contig_highpages(struct page *page, unsigned long addr,
> +		unsigned int nr_pages)
>  {
> +	unsigned int i;
> +
> +	might_sleep();
> +
>  	/*
>  	 * When clearing we want to operate on the largest extent possible to
>  	 * allow for architecture specific extent based optimizations.
>  	 *
> +	 * clear_user_highpages() (and primitives clear_user_pages(),
> +	 * clear_pages()) do not call cond_resched(). That is fine on
> +	 * preemptible kernels, where the scheduler can preempt the clearing
> +	 * at any point, so clear the whole range at once. Otherwise, clear
> +	 * one page at a time and reschedule in between.
>  	 */
> +	if (IS_ENABLED(CONFIG_PREEMPTION)) {
> +		clear_user_highpages(page, addr, nr_pages);
> +		return;
> +	}
>  
> +	for (i = 0; i < nr_pages; i++) {

FWIW one could do:

	for (int i = 0; i < nr_pages; i++) {

and forgo the earlier variable declaration.

>  		cond_resched();
> +		clear_user_highpage(page + i, addr + i * PAGE_SIZE);
>  	}
>  }

