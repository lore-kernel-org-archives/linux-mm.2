Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F45CCD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 09:31:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E9D96B0005; Fri, 15 May 2026 05:31:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C3AC6B0088; Fri, 15 May 2026 05:31:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D8016B008A; Fri, 15 May 2026 05:31:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C01E6B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:31:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC8C8140678
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:31:19 +0000 (UTC)
X-FDA: 84769135878.19.C0D326D
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf24.hostedemail.com (Postfix) with ESMTP id 10664180004
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:31:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="DTrL3ak/";
	spf=pass (imf24.hostedemail.com: domain of 34-cGaggKCCYLCEMOCPDIQQING.EQONKPWZ-OOMXCEM.QTI@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=34-cGaggKCCYLCEMOCPDIQQING.EQONKPWZ-OOMXCEM.QTI@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778837478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R0srtN8DhThOPFuT2716WE50Bz7Kq707yBHvPO80zMg=;
	b=zbaIOiuLdkxvRixzo4PZq0h0EjLw9ilSnorEoobjVHhXVl1qLt/SzuK2Bbg9ydBEvbxlbO
	w+FB5PMfTbcpVLfkwAQYrExuC9PgqeRar8JVtzL/ek8tcuUNubesmato1BQbezV5Y33MJ8
	O+gnmjNWwnxH1HnfDkIM99DnoM3fK48=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778837478; a=rsa-sha256;
	cv=none;
	b=33FFeqqnAwaEO+l3a2+OsgLHTx4y7SGGPO2tTGGA37UYutwMGLFEMfaIwtRb1PeMSwt9mP
	kmAyOsczyR6glQ3L/v3ij4LLMrZvzWLTyVwFr5j3rg9aItFdOMLXZlAmFIZ4z9qozn98UB
	M90jDkCcHxyTEZeqDGUUxqekJoPhq5Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="DTrL3ak/";
	spf=pass (imf24.hostedemail.com: domain of 34-cGaggKCCYLCEMOCPDIQQING.EQONKPWZ-OOMXCEM.QTI@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=34-cGaggKCCYLCEMOCPDIQQING.EQONKPWZ-OOMXCEM.QTI@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48d1b294dfeso77643675e9.0
        for <linux-mm@kvack.org>; Fri, 15 May 2026 02:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778837476; x=1779442276; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R0srtN8DhThOPFuT2716WE50Bz7Kq707yBHvPO80zMg=;
        b=DTrL3ak/X7n9kmFep05NSz1Rk/EzAgqE3hrIAUJPUtC0hTjpR3Eqczg6DA4raEFFnp
         fKI+0Ze4zh9+rGKyFJ7UkgFJd/Vn6+As3z/Y07ZiDM4llLj5H10qgrSaQtQ9QdzjdShC
         e181ptq+t5YH4Zl6FldN5kSpfJz0ezmpHpE6ZHc6ljeIG4s8g4BRLUFPgzXg964yvs/N
         bhGDcyboU23NuzQWGl6G6dw3yxK/amAYgpmCGWx+hmuCkKtzl2bs/3kppCbfEdjRAdM3
         CKV0xL0twcgku3n65CdrQpDwqu3dmNTZXNiHn9omknaftJZs8RFN6Vdxrq7GVLeR+kjD
         GPAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778837476; x=1779442276;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R0srtN8DhThOPFuT2716WE50Bz7Kq707yBHvPO80zMg=;
        b=S35hQryNUPEghEsEFRLcms17aj19/PU30BXHBIl61Y7ru1Z0ezawxdbnxt3z69hOo+
         8NUpUrQw6yrC5JRVMo0+x4O5BrY1duSsligTDHifZ3e/WS4XU4hXA1IDxkEdy1L/xDij
         gymIjidHI0BtwEjH+YXOLemxOiNC7Gd8Za1gTDOjZguLrfMtUPpCdOqJskp0asu7S4cN
         eR2FHJHPXniXmMhn9OwA4HNa6fqz1lHiKbrc941rqnXo3dwXN/t4gULuYJlGUBlkBpt6
         6YMBopjsKyJ/hGY4ncGGJ+0dJrNJ3lhcP0VSGu/vaO1D4os3fkbFgZ9i6dURwpZi9UNs
         Z0xA==
X-Forwarded-Encrypted: i=1; AFNElJ82z/AX/oEiIhzCMbY55LK0nTm9jd5e+lHGuiIxQQaP9maTG+8SrABhZ9iX9Q2VPyUIho4/QuwqJg==@kvack.org
X-Gm-Message-State: AOJu0YwG5SGDo5rm+AEVRzUxSygeUdu7EFpzE54ou9y4aMZYKdaUALtc
	JOYd8RXOOwchxO35Kb6MQDFBGJekpx9kd1l7arO2W2/VgNXELD6LRzgbaJMkdw+aqH9hgLdh3yK
	DNF5g7qwNqkvGHw==
X-Received: from wmqn21.prod.google.com ([2002:a05:600c:4f95:b0:488:81f0:1a27])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:46cf:b0:48e:8974:c377 with SMTP id 5b1f17b1804b1-48fe6626ba1mr41289605e9.29.1778837475938;
 Fri, 15 May 2026 02:31:15 -0700 (PDT)
Date: Fri, 15 May 2026 09:31:15 +0000
In-Reply-To: <agS76pNPlPVLgpFA@gourry-fedora-PF4VCD3F>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <agSkMV26nhYukbnK@gourry-fedora-PF4VCD3F> <DIHPURUMTESI.1LP37OYJN1N31@google.com>
 <agS0tVCwESC0rC9E@gourry-fedora-PF4VCD3F> <dbbee174-aeaf-40e9-8942-425580a8ef3b@kernel.org>
 <agS76pNPlPVLgpFA@gourry-fedora-PF4VCD3F>
X-Mailer: aerc 0.21.0
Message-ID: <DIJ59AT4F3Q9.1JN2FOZZ47H4Q@google.com>
Subject: Re: [PATCH v2 00/22] mm: Add __GFP_UNMAPPED
From: Brendan Jackman <jackmanb@google.com>
To: Gregory Price <gourry@gourry.net>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<x86@kernel.org>, <rppt@kernel.org>, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, <derkling@google.com>, <reijiw@google.com>, 
	Will Deacon <will@kernel.org>, <rientjes@google.com>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, <patrick.roy@linux.dev>, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 10664180004
X-Stat-Signature: r5z3qbdcrwysfxe5qj4meyxwk6oyw64o
X-Rspam-User: 
X-HE-Tag: 1778837477-800180
X-HE-Meta: U2FsdGVkX191SIB4IFNlzIW3CKttA6WTjKysGogAQ8Z92yihCs3PaJwmgCFZOeeylHrfE5SRE0ogNUat8sW19+/9kLB9VXkdDVCRINdR1aoEAbZV4Xgdhf8d2xhpFpuqO+S1/Q4DmHh5USkYSZ/8lV8IEn0PZu3dEAieZnWQPaHJYdNg4FmRUUMyAP+DhP5Xsvjwz5YNVnD63ImHXg9XuTV3DjQbBO+HaepG479ZmRPbAspc8TIOo6gRq191rikcrpSHOqgw2cLS8E28NzQe8ksH9ZHP2TOqTikYfKKSkcPajCAyC04KOof5kPncJrAF/CAjmrzMORNRmUPFfJaIHPHyZDU4/Xfv4HjnwL7LWuIq1ZpA45S8b1tI7fRjR93idt9KWUOhKYMdvlTHlP+O6tJ0UaT2JDZ7xgIMTdMa/QnyZglwA6YfsdvKKQaGGWMkYyq5aQs0nP9uucdibETHKu772QwzxCDpjcSOZhVVjndcI2z+b29yv3LJ3Y1TDP9w880HSXkO5BjYXllNSqmoSf9Nivz6PsWMgRgWSi7cfJZz27b0aF8skIMcPs1zqOBhJN/VTg7/BAzlUWvINnUCGj5S5fyc9N0X1bCkcg5SUjwUqeX/K9GysoFtxef1/jb36d4t0IFrtg+TJkBKrAX9sNZ7oArVoGeJ8AEZZKI8yK1YGf+ki0JNjn2uIXevhue0jCQsjrLYcgkT/Zk8FTHp7D6A+h8YMI4rmOug3oYtB8NLEz1ZJX6BkkkSYzpeDMVIdHflUJ5U/rEaLZHmHIa4KvayvlFBWg2Nog1zzZGSP+4RhNGPlF9ozJVQbxEzKOTzjZxvTCQlY2rShQ/MDsE4pkwFk+3SfXjIUyO0ZUSFO8ht3uYy/Qu+Epb+8iZL+cUE1+ITWgGGtQALlCWDWc+dALcizJC/5hOQwTlxZUlJopEgaTmqAbW9dyslwARK4ZDXaljX3XCEIyxtOI8BG4K
 fg7VtWYh
 77K+QH/BewMX4kPp0HJeDtYkA8iteFyNRAdPZxPE0t/t4g/esxw247ptq7IwBJoXqrP1vJTgVxbm/f+fNVZH5ZUJVIm2mkgeQkT8PF7IjtRzLDFs94hC6qRXACLY0Qgc/kNawwjkpKtahBxaCBz8jYoubq2zLwX/WgsB+JkjmdgMZ49l6m8816EWsj9ZJf5yTnwqGoAfWIxG17JxGl9LuAFIr3JoWgUniAguDsNaSmvz8zCJhx931+UhAAN+sKzVtPBBAhtdO7GWE0ArNgWHup957ZqyGXZBLYmtBckn82Ku97GVJmeHCrwGwMFxOaugsADwndpB3cxcHJv6HL1LTsq19Jg8He/SS/OsBRXLBOjT6rbAn0QSkCGZI9VX5t9RBlJtUAWHepqYZv51TuhofgGXjzgrwRgGgeZk2nNfMRTvm9boTpq7pVWeGx7lov6DriyAKwlRJtHK4ibTrmIFO/eO3xW39VFytcDP4m+vr3Rnjc8ADU0wPpsQctBYV49kzEcA6lmfArP1ge6nErDo54UQ9mz5J0UUTmaIrFYpktB9Z3qi9iZu3XOaA1rSkK6hQ+psBIzvsh3v1lXM6PkDWaAoIXbf+pSkisIuqQ2XnEjRckwZB6F/exKzCjYQySLHb4bNCdYkjea3SI1wIC3/cRnhZ80Tblh8dd6cZoRAGuQGnLrFcCZWCFUh7N6wqXqibiz+Clb1BZtyJPvY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed May 13, 2026 at 5:59 PM UTC, Gregory Price wrote:
> On Wed, May 13, 2026 at 07:38:01PM +0200, Vlastimil Babka (SUSE) wrote:
>> On 5/13/26 19:28, Gregory Price wrote:
>> > 
>> > Hm.  I'm not quite wrapping my head around the TLB issue fully.
>> > 
>> > If there's no kernel direct mapping, and there's no userland mapping,
>> > the stale TLB entry comes from... the page formerly being present in the
>> > page tables and a stale TLB entry lying about after the page is freed?
>> 
>> It's the direct mapping, we assume it's always there and unchanged, and only
>> kernel can access the contents through it. So nobody flushes it when freeing
>> any pages. Userspace processes can't exploit anything stale there, in
>> absence of kernel's UAF bugs (or e.g. Meltdown like cpu bugs).
>> 
>
> Ah, I follow.
>
> If everything is default-unmapped, then you don't have to worry about
> this issue - except when a stolen block is returned or an ephemeral
> mapping is unmapped after the operation.
>
> pivoting...
>
> On the GFP front, i wonder if you could factor out the core of
> alloc_frozen_pages_noprof() and add alloc_unmapped_pages_noprof()
> which adds (alloc_flags |= ALLOC_UNMAPPED) instead of adding
> __GFP_UNMAPPED.
>
> I have been considering something similar for __GFP_PRIVATE, but this
> has the added downside of increasing the surface of the buddy for each
> new narrow use case (in my case, private nodes, in this case unmapped
> allocations).
>
> unless of course we nip that in the bud with something like
>
> struct page *
> alloc_pages_special(enum buddy_context ctxt, gfp_t gfp_mask, ...)
> {
>     switch (ctxt) {
>        ... internal-only details about how that case is handled ...
>     }
> }
>
> and just go ahead and allow the buddy to grow internally without adding
> new gfp flags or an infinite number of interfaces.

Yeah, this is what I'm thinking too. I don't think growing the interface
is such a big deal if we can put it in mm/internal.h. For __GFP_UNMAPPED
and ASI's equivalent, we would eventually want to expose the functionality
outside of mm/, but that doesn't mean we have to directly expose the
page allocator interface itself. Do you think it's a similar story for
__GFP_PRIVATE?

Anyway my initial thought was a variant of alloc_pages that lets you
directly specify alloc flags alongside/instead of GFP flags. This is
actually a bit fiddly though since the GFP flags -> alloc flags thing
isn't a clean division. Maybe it should be?

> Of course that means users have to know the context in which they're
> being allocated.  Right now you can kind of "transiently cheat" by
> passing a GFP flag through a bunch of interfaces and that makes certain
> allocations reachable - but maybe we should not be encouraging that kind
> of design for these kinds of allocator extensions?

Hm, for __GFP_UNMAPPED (and __GFP_SENSITIVE in the future), it is
nothing to do with the allocation context. It's really expressing
something about the page, i.e:

- __GFP_SENSITIVE means "We might put user data in this page"

- __GFP_UNMAPPED means "We might put user data in this page, and I know
  the kernel doesn't need to access it in the direct map" 

So, for those cases, I think a GFP flag is actually conceptually
correct, the only reason I can see to avoid it is because of bitmap
space.


