Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5E2DCD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 09:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EBF26B012B; Fri,  8 May 2026 05:24:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09D316B012C; Fri,  8 May 2026 05:24:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF48A6B012D; Fri,  8 May 2026 05:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DC9B86B012B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 05:24:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7E3E8140791
	for <linux-mm@kvack.org>; Fri,  8 May 2026 09:24:44 +0000 (UTC)
X-FDA: 84743717688.28.D94F5E9
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id D48A72000A
	for <linux-mm@kvack.org>; Fri,  8 May 2026 09:24:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=orMMXEIR;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf13.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778232282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NEJWTFcrhwXUCuH7FCKk5xX/jw6eM+HVoJCnUbbErK4=;
	b=K2IobTlDNwgZUGFgZRWQEDfnxPryyEqj3HfjNbuREdKeF+92hoOLEXzHuVponJrfLO0kzY
	sT8/35X+sQQmDG1YV6YtZ8bT8DlVSdnabwZpDjoMTf+lWfpitJBt5j/Q/czQQsWvoy/4aW
	k0bfyCVX9Fz18/dGTLJ5e7lEXHDKajg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778232282; a=rsa-sha256;
	cv=none;
	b=lxlmT8LGsykzDYKCcpVYKDzzfOkBIy9yLBDdHpWFenUMwB109uV1bVZO3v/AFEeYuFtw+l
	qMW7mNGJpILEXASJArcGSBnXiz57wytTwi73L5o8tZyEvFkoWOlyXB2HpI6AW7Wj6PGYMe
	43CMGob+TQ2DvbZpDQLo/S0VQZq0lPE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=orMMXEIR;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf13.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NEJWTFcrhwXUCuH7FCKk5xX/jw6eM+HVoJCnUbbErK4=; b=orMMXEIRHSjQfNSsW94x1FUSHl
	3U7rXixUWgG7duBeYeQ5RhQpH9yPmmyj3ey8zfwhxwQiUfqIN3Rse1Fvk+AYJsPFsXSEXs35e+ysj
	FWJJ3mBeOTeKuNxa0kari632HPbDMOnLC/KplX30DFy/MnymExu9ekBpegmdEOqURQ1Ypi6opkFa8
	6wuH4hCXUsPfh9WplsdiSg+g+9uVL7ihKbgf/OrZDFVGvcR3+WJWCe+ThJ3/GlH+tGGM763i1uVvX
	S5KTI8T04i/7k62EfoBQYa2TbEep1/g4hNBbPJl9NpECSBPWuVBoy4TfalMU3KvtUK0tNxHkAzUqD
	npUCz3Cw==;
Received: from 2001-1c00-8d85-4b00-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:4b00:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wLHR1-000000040qm-3OIc;
	Fri, 08 May 2026 09:24:15 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 8B611301C52; Fri, 08 May 2026 11:23:41 +0200 (CEST)
Date: Fri, 8 May 2026 11:23:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Lu Baolu <baolu.lu@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] x86/mm: fix freeing of PMD-sized vmemmap pages
Message-ID: <20260508092341.GP3126523@noisy.programming.kicks-ass.net>
References: <20260429-vmemmap-v2-1-8dfcacffd877@kernel.org>
 <0c20d1e6-1a39-42c5-8c94-9bd2222fb6b3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c20d1e6-1a39-42c5-8c94-9bd2222fb6b3@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D48A72000A
X-Stat-Signature: 8e9zeffkyg8y4b6h3j3wqi8dgepcznze
X-Rspam-User: 
X-HE-Tag: 1778232281-50414
X-HE-Meta: U2FsdGVkX18xpq8P63oQvHCCZMpPGQnaPRoXNQGXeg0mU7Eo21XbvAEs7N0pM168Ael7gJcOPDG6ThOasc2GI1GcHUxL4FWsvJdGHeSKW0KLLytNW4A9eRrR6tgEXO77ScLqRunqs7D40jEIFI3ahEWD8KHgW3+0YSfadFpz5OxdARDdm8j5+AXgwNYlgZ7Xm2cOHAQ7aohgUabx8Om+uNOa88f4X36bC+kdpuwpUkoghsKNp1G/tr8L6bQADCcOr9lF+4XHc7BgYB7KU7l9CncFDGXOvD4N2UaTcB98DLYr1Wbr+VVo+iaca/iDQDVBu8Np7f2Kmu+fN5Kbw2GTdxjjLZFehonfJWfab1kcYgkuw/WpAAmaAgjxNnKCSYIHPdcq80UCmzo2EQYPjHx1c7LSw5Wb/csrJYJjVQBgqZWST58AXcBvRI54KH+uUSjr3RRQoXQxNVBNL9SdWfvKjRIR8w35NJUyEG7sfpEsS10+qj3byVhM7jBrXBsbmhcFJGa20/XO+LtoVbBVoX/CnRtfCCxnS4wuFp3Ls3Sa+ytTOJobiDIplhK54IJ3V/mVtBTjPuZaQ980PqgFSzRaQOjsHSEsVrQqP3/0IUUunlQX1SUbNwWqEvpaRTIfuo5cIKW5gafUnvGD49ZUwQUo8q8FZ8KEScJNfhgBle0K2cT2w5h9DeQIP2bCxHxlxzOBPdp5lTQG3Lbf8xT3QW6BAdQP8iWHduB2823uAkZ1J2MWbgm9bUoewpYCFV07h81XqQG2hVFzxq/Mwj1T5H2OXGiTTPgQ8Upqhp7HhAId/Rdnj1svtfsZrE1/rjtrGiVilC75CfjCSV28l4qArxeSWitJ8eInMhgv8yuZj4fmkSaiBCRm5gu4FCCedkAG3TNS7OIlq5gabvgARairg/jy/cP5cG8vnU1UmEXeqHhPGx4Cvn/dgryR1n+suat2ONkE4ExhjSaFJK+H54Xl5Jx
 FJffX3CG
 5pVoxWlRinwGjwnNiZaRn0eoiSXntDz6dU0Sd9G9gKD2hPVawMAP18gcqqf+Gw4zoCTt7U9Qnu59VYpVwyRBAiR1iZ88P9Vz99I+RfwI62E9T9Xk+4KW21w0uvZKrpXOdaOXxBhVqvA6L86RPSoSvU1TfMjS0KOyb2OVU33uX3ZbJHEyA312k698u8N24nDjrJQbtcSJqbwrlFziwax9MA+O2rJ+tQ9aIU4GuMIszLqyG945tYfIFnooBdYVuNvItqpxD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 11:19:26AM +0200, David Hildenbrand (Arm) wrote:
> On 4/29/26 12:49, David Hildenbrand (Arm) wrote:
> > In commit bf9e4e30f353 ("x86/mm: use pagetable_free()"), we switched
> > from freeing non-boot page tables through __free_pages() to
> > pagetable_free().
> > 
> > However, the function is also called to free vmemmap pages.
> > 
> > Given that vmemmap pages are not page tables, already the page_ptdesc(page)
> > is wrong. But worse, pagetable_free() calls
> > 
> > 	__free_pages(page, compound_order(page));
> > 
> > As vmemmap pages are not compound pages (see vmemmap_alloc_block()) --
> > except for HVO, which doesn't apply here -- we will only free the first
> > page when freeing a PMD-sized vmemmap page, leaking the other ones.
> > 
> > Fix it by properly decoupling pagetable and vmemmap freeing.
> > free_pagetable() no longer has to mess with SECTION_INFO, as only the
> > vmemmap is marked like that in register_page_bootmem_memmap().
> > 
> > The indentation in remove_pmd_table() is messed up, let's fix that
> > while touching it.
> > 
> > Note that we'll try to get rid of that bootmem info handling soon. For
> > now, we'll handle it similar to free_pagetable(), just avoiding the
> > ifdef.
> > 
> > Tested-by: Lance Yang <lance.yang@linux.dev>
> > Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Fixes: bf9e4e30f353 ("x86/mm: use pagetable_free()")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> > ---
> > Reproduced and tested with a simple VM with a virtio-mem device,
> > repeatedly adding and removing memory.
> > 
> > Found by code inspection while working on bootmem_info removal.
> > ---
> 
> @x86 maintainers, do you want to take this through your tree or should we merge
> this through the MM tree?
> 
> I have another MM series coming up that will touch this code (no fixes, though).

I'm thinking this should go in rather more urgent, yes?

It looks good to me, Dave you want to stick this in x86/urgent?

