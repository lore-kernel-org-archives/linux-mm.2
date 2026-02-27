Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DF61FD7F94
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 11:04:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 768CA6B0005; Fri, 27 Feb 2026 06:04:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 716FF6B0088; Fri, 27 Feb 2026 06:04:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F7BA6B0089; Fri, 27 Feb 2026 06:04:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4CC336B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:04:06 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AE28C8BFF4
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:04:05 +0000 (UTC)
X-FDA: 84489952050.06.EA2A3CE
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0520E1C000B
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:04:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=m0ozLv2Y;
	spf=pass (imf21.hostedemail.com: domain of 3InqhaQgKCO8aRTbdReSXffXcV.TfdcZelo-ddbmRTb.fiX@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3InqhaQgKCO8aRTbdReSXffXcV.TfdcZelo-ddbmRTb.fiX@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772190244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FUnn+HEzz7FxTPfMeOpy8wErtBbGc/VEuKzZnO44vHk=;
	b=G0Y/dEKaUJfAS2DTy9I0i7saRnXg+967GLKURUd1wFtMwIp02oZCug3xkuk2SDs/pZq0/R
	qViPozdMIGkbCZ5E9H1izSL20r/EwbW37z5f8DhsP1bUHwx94c+JFxtyB+T8U6I+oS83aI
	AiRMUVAAYgDb0jdCtXrrasDYvmvBLwg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=m0ozLv2Y;
	spf=pass (imf21.hostedemail.com: domain of 3InqhaQgKCO8aRTbdReSXffXcV.TfdcZelo-ddbmRTb.fiX@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3InqhaQgKCO8aRTbdReSXffXcV.TfdcZelo-ddbmRTb.fiX@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772190244; a=rsa-sha256;
	cv=none;
	b=gXTHOAjh387Otztjmk/ERVtMFnP+FOgCAC7xmyJ+QgMEEgZAe7vg1H2YQbKZxK3l+mArZV
	Flqv6DgmVIc9WSgVYUkZFngbx0vuNAvDxsZDVK7T3kp+k/XcMkYuxProXEWJ9PvXjWVWgT
	QpYr2W6qKATlpqvoGyxXzGjhzCWwang=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43997e095cdso1394320f8f.3
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 03:04:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772190242; x=1772795042; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FUnn+HEzz7FxTPfMeOpy8wErtBbGc/VEuKzZnO44vHk=;
        b=m0ozLv2YdXpapWKp2krm48ZBbBi/XTHkGi05UzssANMa9kNOThJ9XKGdUTyf57ga6D
         yA4PB4QOLuQVZEIS/qz3qagEoCJOhkdydsuMVl6LKP/10JJkH8OAd7o1QoemfN4i9HKx
         MTGYjWmnl7rSpsk3YFJhi8JriXaY9kFtBa5bwcaxiu1d8/YID3b7pRjuTvo4KOWeBGOo
         Ku5Siv2IrY9YmhisFXDJ9xIwoNa1WMJYQDg9AzlrGajcy7uWcT1ppm5uwyhQHpYpXLJr
         5rOSHJqeCEZXcoQlSjnq+J0iLYMHVGs+EiiInOcF5JqFnbdlclbZ/k+VAbLr90l0zIIY
         mI+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772190242; x=1772795042;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FUnn+HEzz7FxTPfMeOpy8wErtBbGc/VEuKzZnO44vHk=;
        b=wAZzKaTvdgNQndIq5AVHboJl5x12LcI5uri/G7nblDtfhJcVVynp1m7LuIy0/aPJ/N
         dlHpr/hfGzLlhJSw42xhGJ4ugTH8bsS7ola8hD3cRjZ6hdaMN7XMtDDBRHUY7WZX/acL
         30agv9qEDRUx5WTqvz7Cf1LMM4GNY5dIfB6XQ8xKjPqCVYOXFHsWHRNaQj6KW7b8lyR0
         huw/ImZoU0aO7CpuUO1ffYWsoYDHEDsGjD6LigNK78hT+WSd+Gu+wCeHsqvxKKAY7IK7
         pjQhaHK0XRKFiFuwWxYeVnHInPukMc2+36y/FxmZlW8ojt/nsIEBHoiUcd+qzcCfRg7k
         XMWg==
X-Gm-Message-State: AOJu0YxvEVr4snjRH7rRWrrfk7Vrp5c16aC/Zvceabe62RB8o5Fae4iG
	3dxXcGQp72mlMRY5soYgmLuXxPLZUyXxFm1mVrAjboWGTlUj1JTqirgnFvBDDc9oBrVDJHc+i/s
	W7jfd6QFF33QLmQ==
X-Received: from wrbeh4.prod.google.com ([2002:a05:6000:4104:b0:439:935b:4f51])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:4021:b0:437:8162:c0f2 with SMTP id ffacd0b85a97d-4399de2ebb0mr3691225f8f.39.1772190242107;
 Fri, 27 Feb 2026 03:04:02 -0800 (PST)
Date: Fri, 27 Feb 2026 11:04:01 +0000
In-Reply-To: <20260225-page_alloc-unmapped-v1-18-e8808a03cd66@google.com>
Mime-Version: 1.0
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com> <20260225-page_alloc-unmapped-v1-18-e8808a03cd66@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DGPP0DOFCGBQ.PZZ9GMPEEPG6@google.com>
Subject: Re: [PATCH RFC 18/19] mm/page_alloc: implement __GFP_UNMAPPED|__GFP_ZERO
 allocations
From: Brendan Jackman <jackmanb@google.com>
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>, 
	<rppt@kernel.org>, Sumit Garg <sumit.garg@oss.qualcomm.com>, <derkling@google.com>, 
	<reijiw@google.com>, Will Deacon <will@kernel.org>, <rientjes@google.com>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, <patrick.roy@linux.dev>, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0520E1C000B
X-Stat-Signature: 57txykpsn6c1asp8niipq7xc99sbnj4f
X-Rspam-User: 
X-HE-Tag: 1772190243-116663
X-HE-Meta: U2FsdGVkX1/R+raeE0VO5fHdfvV+XfCDDrsrljs3TFBFuENid07JhOsGjQ78QXoAd8koRD+fSFMmOVXi0AYyB7f5xxAXR5N/d84FIwzUa9JMmlCLcNYVzVNg+2I6CzrJ1zCxJTp56bSrnjbV2jWzavXK5eZ4qR9W9Fcb735CaOZ3oEej7UoArkZLtTC6RS0Ij1bol7OciyEaFZ1AgQNtXLSv4FGEBnjwAKLu8LhG6l0BTeJDCj01z1Tsncsm9D5MIKFN2v+rly6dbnRmALXA1LNiuINhdCDPz1ELv9bU56Yl+lA7ZBwgEIPB/WlzxIQYqWsjUJCVAEBVXweRiD2Ap6iSd4fZIDPLEjv16jpBOb/0sRhTwzI+bwiKlyrabn2VPfa9iw8uFw8JWaQbgQumz76utkV1vcw+YUk+8zTpWTRu3MRXDvaDfZ35Wte7Q5X5zk5dPExbjce2ihBI/QqHd3ntr90azlJlp8BzZZhZX6G8rq1bA+2FHpBjr0iWqjZLE8ahoach6bSgG+iKVF73F4lDMZdyhw4s4BeBFuqET5jrSkOMeANIEcrQvW5ogjcM+0tEM/RTwbqvJd4l7d00ZXtr2cGNWK7ms7q3gYWwWz7t+iu7T6E1O28zG4hziGry14jBfwhxBRCAMctQ9Yi9+nAGTOsFA5631zyhXYvO/IboOZI90MYQd7VFn1GRIwLPKdlRJcpihbIs6YITK+O2K4YoOZpNqav/k/aohG0aOcktIZbpvyNwwBTEhRYx6fK06oF47q51MmAyH5D1zOLsNh2BGb08TiL0SuzjZj5BsLWYF4ildka7psXP88euvS1oo/wV4LT30MLX79GtS8jiJevBZddIeEDifwXplh+qnMWrnw1q5f0xTEbhWVE6IBWM/vXdpYNPB58GNmR+yKwAdb9e1e9pDz+7SUDKfXFR8jbtpvxyWYRva3dICLJxkDQWs4DWtmJ7d5ao2hWdiFI
 NMRSC8yr
 0Li73IeAeXnRUcbixGfRuD1ZrDAbHIXxRHf4JHkDW6WQF/YOWtcnoVgjPb2J02mydfZdPoiOirwavPlF7XjkVm3nfeSEgOiJzSp/u/zs2n1Xua1pujTWbTtLeTSLnjivjloH4K41vKKzLMyhnsUFvSapKHUPc/h1iJam0yARjEUx8nZmktStWYNh+Vk/dGMo1tdypMSZ5dX9j7KRoW4LALZSchRaAo/FwVmFyRE7nj8ugk/gBy4s5kleTOTnDOn8xGBt+si4QxxBhS2P52w9RJhbKnvizRndOQHA+gn+7i/+RPZ66Hqzo45cFBWqRaVJQfR0/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Feb 25, 2026 at 4:34 PM UTC, Brendan Jackman wrote:

> +static inline void clear_page_mermap(struct page *page, unsigned int numpages)
> +{
> +	void *mermap;
> +
> +	BUILD_BUG_ON(IS_ENABLED(CONFIG_HIGHMEM));
> +
> +	/* Fast path: single mapping (may fail under preemption). */
> +	mermap = mermap_get(page, numpages << PAGE_SHIFT, PAGE_KERNEL_NOGLOBAL);
> +	if (mermap) {
> +		void *buf = kasan_reset_tag(mermap_addr(mermap));
> +
> +		for (int i = 0; i < numpages; i++)
> +			clear_page(buf + (i << PAGE_SHIFT));
> +		mermap_put(mermap);
> +		return;
> +	}
> +
> +	/* Slow path, map each page individually (always succeeds). */
> +	for (int i = 0; i < numpages; i++) {
> +		unsigned long flags;
> +
> +		local_irq_save(flags);
> +		mermap = mermap_get_reserved(page + i, PAGE_KERNEL);

Oh, that should be PAGE_KERNEL_NONGLOBAL. I think this means I never
tested this path as this will crash - mermap_get_reserved() will WARN()
and return NULL and then we'll dereference that below. 

Maybe that's a bad idea, maybe it should WARN() but serve the request
anyway.

Anyway maybe I need to support failure injection to test the fallback path.

> +		clear_page(kasan_reset_tag(mermap_addr(mermap)));
> +		mermap_put(mermap);
> +		local_irq_restore(flags);
> +	}
> +}
> +#else
> +static inline bool pageblock_unmapped(struct page *page)
> +{
> +	return false;
> +}
> +
> +static inline void clear_page_mermap(struct page *page, unsigned int numpages)
> +{
> +	BUG();
> +}
> +#endif
> +
> +static void kernel_init_pages(struct page *page, unsigned int numpages)
> +{
> +	int num_blocks = DIV_ROUND_UP(numpages, pageblock_nr_pages);
> +
> +	for (int block = 0; block < num_blocks; block++) {
> +		struct page *block_page = page + (block << pageblock_order);
> +		bool unmapped = pageblock_unmapped(block_page);
> +
> +		/* s390's use of memset() could override KASAN redzones. */
> +		kasan_disable_current();
> +		if (unmapped) {
> +			clear_page_mermap(page, numpages);

That should be clearing block_page.

> +		} else {
> +			for (int i = 0; i < min(numpages, pageblock_nr_pages); i++)
> +				clear_highpage_kasan_tagged(block_page + i);
> +		}
> +		kasan_enable_current();
> +
> +		numpages -= pageblock_nr_pages;
> +	}
>  }

