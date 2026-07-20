Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 265C0C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:05:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4F7F6B007B; Mon, 20 Jul 2026 15:05:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD7436B008A; Mon, 20 Jul 2026 15:05:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 977E76B008C; Mon, 20 Jul 2026 15:05:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 543506B007B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:05:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B1D2B14027E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:05:15 +0000 (UTC)
X-FDA: 85010082990.19.5C2154D
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf30.hostedemail.com (Postfix) with ESMTP id F2C4780004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:05:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X0m+OY3+;
	spf=pass (imf30.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784574313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kPMaiKQm/Lrn2+15jJw1Tz84+egEdnjBHflNkHpDaxg=;
	b=M/oqG/O/p5Dg/ioxIsoIpmt1bBbAmtS7co6d1U3qbRuYMKCrlWpMFEwPeB3z4ZAmgvvzQo
	7kig/KfRvjPh9ukQgLcPHL3V7pbkd+GsFV9Lzb7hjl9ObVkIATFuWdm9R9e9U4lanLMhuY
	f3JtaMDhC9+snKJAyim9P6PF1o4mMHw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784574314;
	b=KxESuFN8ZFO7SeYNzNvpboG8OQMOG6EEc/fdBcKP9Gp84/e9MgOD4wX6bNz202dTouV8N+
	FI3jPozegTBh3iUeMBUvb7kPnwZbFa/Zg30ZbGX6dFTZeGwzpbDow6qQNZSEgC1eHi/hFG
	8U11JKDsSFzq369VMmkoO/ybwu48f/s=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=X0m+OY3+;
	spf=pass (imf30.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ccf2360620so64386155ad.3
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784574313; x=1785179113; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kPMaiKQm/Lrn2+15jJw1Tz84+egEdnjBHflNkHpDaxg=;
        b=X0m+OY3+SyN6bzT2p7skeqe4goIqQgWEEwRPOWLxK6jAT/mUYBQ5UaWzA4UjGadXge
         1nCp1nuDWSrs6beHKw5zAx0X60+pypa6VXbHvsluMIO5Aop2fX6fvZrGfkPtuoZ7VRpp
         /wuHVVbbd4rPpY0mOdiCpNJOZtZC0pyFbQAnKIMTvruoekp5ygO2arcSJuMRFvUwJ++q
         2NRHjw5YnIi88Wf7rdGQBUH3jWMSFBlqz06CukpXeQpxqo+AFeNw88ghMa9epS04edjx
         p8uuuAurPTJ46bvdj8oxCAYJiZDMJPgC83tat+2cyGt0liLOBoKo84VuHrvAoPPdSboX
         MvMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784574313; x=1785179113;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kPMaiKQm/Lrn2+15jJw1Tz84+egEdnjBHflNkHpDaxg=;
        b=X8fdJt0bmWm98qUHKPzIrfjFDu4Jld79eQuz1H9mJcu1ut/rpZp2ZrdSB2Ho8/vWfJ
         Znmjuvvc2IbIE7C3zT3mGTexT/MkOVf7CkEUSomEMifTZpP9ttzEdSJ28P73ASWzw0G5
         H9xWXh2igcDwvdoPpW1S6+0z8GQvpRNb/HUyB1RZlsKawOIzVXb30OkzSsTLgVZE74GU
         AyPZLvGn6f0bmvTszlPTsGRYzof9OnvQoXWo0KIVHx80Z/c3CLE+nkNlKc8u4C6RMSce
         KHIwH/cwEV3Ls0QD+BANytQm7woAayqdlPoT0kE8+Q07u4j6M6hg0Lx0h9tP6/FsseG4
         h42g==
X-Gm-Message-State: AOJu0Yy9NCJxhJz4R6ZIXitL3a1BOBOSUBHAiPAtTK1C1+icd9EXP73f
	hOtJWRiYGdZwZryOxmy7M9KVDgFeH1FvNk6ZzswPOQ2YY7pjIWtSaCDS
X-Gm-Gg: AR+sD10elaMCOWh2RQUV+TMzU39/J79PgzWjIGlLVhWA2RkNSuHCrF0ubrUvLD3f3vV
	zFWlw+6OrB19NSij9cjjvUb/b4HkwZUZWxLwWmMAlsW1I4v+mSqdNrxsUN/Vub9sGhljXmTBlzr
	QP48gxdjNKb64OC3iFQbiSVQbe3OMCeNFc1Olvy7Uf2W4PXvyGFphtXFGx7XnTo5MviUOw6nWrG
	sBN8ob949X7q9w5PKjt5+7AwCJZVV+WIdp4yvSyjAz82M9F7s4JtCsfuAA2bA44XnK6pOhyaFzn
	4n5YrhswU82w/I91Vu12ekHNqpF9NB+Z3cyAJi4dS2DZVllh6aHLzdRNoO+7GCGBCZoUH0pdM5p
	qXjT+XKxMwdr6TPplSrqAAnNtkP10qIoo/hsu44VInQjdh3n50ysoSplmBIFOwX+lTFdcq95bp7
	SUIsmQq98Jxm7kuqNyRxRhqI6HNDHoEAgd9g==
X-Received: by 2002:a17:902:f681:b0:2ca:3e3f:4956 with SMTP id d9443c01a7336-2cf34a35445mr164591015ad.44.1784574312756;
        Mon, 20 Jul 2026 12:05:12 -0700 (PDT)
Received: from fedora ([2601:644:937c:6c90:6d4e:7b2d:4a39:fb0c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf3448f73esm60735085ad.16.2026.07.20.12.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:05:11 -0700 (PDT)
Date: Mon, 20 Jul 2026 12:05:08 -0700
From: Vishal Moola <vishal.moola@gmail.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	linuxppc-dev@lists.ozlabs.org, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	linux-s390@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-um@lists.infradead.org, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ning Sun <ning.sun@intel.com>, x86@kernel.org,
	tboot-devel@lists.sourceforge.net, Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-efi@vger.kernel.org, Alistair Popple <apopple@nvidia.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 14/22] mm: set page table page type when allocated
Message-ID: <al5xZHiFwatn518I@fedora>
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
 <20260714-remove_pgtable_cdtor-v1-14-44be8a7685d7@arm.com>
 <alZSwAM4pwmMOeaD@fedora>
 <f3afa5df-73f3-49da-87a6-d75eb5f3610f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3afa5df-73f3-49da-87a6-d75eb5f3610f@arm.com>
X-Rspamd-Queue-Id: F2C4780004
X-Stat-Signature: 1gq3ehh8iiizkq9h653duxg9neufu117
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784574313-501884
X-HE-Meta: U2FsdGVkX18nDvw1YfNmDPZGGushSmFbrQ81cL2/Y9PTVZcNkxa0bUwdD01VCazlTcF1xeB7/UTw7re3/zNsyNdtmY1Vs+G8nCk9V2vjyLGHpyx+u5LT2nOQTP5SVuIKIL1X4cY4pNhwdnLSEaTRCk3tSdZZap5t1i4XDSbS2kAadKmIB3w2r5IAtE4G2Fz7BXvfTOXg+h3P29Mj19KChcejzJ54Fr3MIqsMEms4QTYeZ8cUHmCIMupZAQXD/UBVgrEsE/zh9ugyCTFaNDsCg9B4SOA9fWJp5HoD8s0qLRodhJcQmOv0XUPuYjL1gvRTB4XWDzYA8XZRI0KIt8SWjuCNx1ivxd58BQSrKxZjtWgufDrjXfu/F/Og62jih8ivH3/5WBcSEHm1yuzjmPI/FR5JAh7Aj0ypKii2bB5Pnn9RpJgzaqGDqAkoDlWYGwagp/q+jqSSebMqux3RDimLbMgufh1ehcmcjANSVFoL+d9x8BIQx6kjEudtX1j4YhkI/gGtgVxKpd0JTTMgsX37UQSBqBo2+i9JBbNrkWc8mhzBT8beOsuOrJI/QT3xEP2VcBMMMkTFvuUxg0BVTxBv+a9dOPYaVR8E6Lxld6rdcX31KPfD1iYH4Emlubi0WOq+TsaLyylUrltmR2m3/vUhjtD7KDcbPtfJbUfT+hBGJfPNi4M6c+/wW4haypy3jgC+YeU0RVHcY4bIqsKB+tstMPdkWhU+LIRry+8kizpvN8Qj/bqjeXSmQXFOjPBUgrNYZgdQyuHzFMunN3Gzb4lGV51qp8CVy3NT2zxKqOSZKTCI/EilQn0zAWIsl+R4BABrDXhqo9ZsR4vQua8QX/49ItosXpslklVloO2//7RLzogIFsYZStR0MMeOt6QURwavBk1e+H+kUu91b55ad9RxEOnn89CJvs+0pkQ+6g46PvL7GNjTd/+jk+o73yBQz69zo1U5hWckJ6FdSoLwFff
 oi1trHox
 +SAVorKIeHXAtDFmdtBzyCz0z7GGDewuQqGIS21phVCCe6hF1cGQzjIxLUpyjLJ7+aOcWgsZ3WG9Ae0aZX6V4CA9eSZio+GzMku02rDA+KsE61nNhd9xATcBVUj4l+RZLqmZTBpOqzQ9lErMM2HIrQSz2t7Br04tjB4CkKs57u/BclWxdnGWY+7lCKUdwmWv+qSkGmt2ydL48wJSIrBJUK323Q8XrRS9c6nApUGVhqeITS+ouwaG6Th5BAqP/aXfENFCT6s3TUrldSwcLu9dVLNoBJ5FO6CuRnY1wJnFpbZeE6rYBTfcuq6Cdmg9GezS3j+/RoKVDz0HozSHdzoXU1vWSQC+uPO+cZViwPuFE/6rN094u7k5pynAuM6NZfPH+Zb+Lzxq6bhi25Q0XVod+4Y+3GnDylF+BsW7p74K8gC0OAOIdWXlzoi7M3+fe6Tf4SkS3L3HyPD7eqTYlrOFBfbKbFuehDkC+NuIL3B3H0td2pT1JKGWo+Sm+DEx5oUFVvwq/NqdOdPS53NGl6SoAqKjA7l0NnPGIEDY0+Ao3gx2JW/6J9nagr/J0xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 11:49:31AM +0200, Kevin Brodsky wrote:
> On 14/07/2026 17:16, Vishal Moola wrote:
> > On Tue, Jul 14, 2026 at 03:04:03PM +0100, Kevin Brodsky wrote:
> >> As a step towards removing pagetable ctor/dtor calls for kernel
> >> mm's, move the page type updates from the ctor/dtor to
> >> pagetable_{alloc,free}.
> > Thanks for doing this patchset.
> 
> Thanks for suggesting it :) It's turning out to be quite a bit more
> involved than I expected though! (There are multiple cases where we call
> the ctor/dtor without using pagetable_{alloc,free}, see my reply to the
> cover letter.)
> 
> > We should switch over from __folio_set_pgtable() to __SetPagePgtable()
> > in this patch. Ptdescs and folios should be treated as distinctly
> > independent of each other.
> 
> I sure remember the previous discussion, but my reading of your comments
> [1] is that we cannot really change this as long as pagetable_alloc()
> can be called with order > 0, right? Multiple archs still rely on that.

Kinda...

The concern was about callers accessing tail pages directly for that
information. Using the folio API ensures that we always look into the
head page.

Since we're now doing it at allocation time, we know we always have the
head page, so it's fine.

The dtor/free should be more questionable because the underlying api
uses virt_to_page() which could look at a tail page... oopsie. I
haven't seen any reports tied to it so its probably fine (the
setting/clearing has been using the folio API since ptdescs).

We can say thats a happy accident that makes distinguishing ptdescs
and folios easier :)

> > Eventually, we want to replace the memcg accounting as well, but
> > there's no existing API for that right now. Lets leave that as is for
> > now; this patchset is big enough already ;)
> 
> Yep, looks like there was an attempt to improve this but it had to be
> reverted [2].
> 
> - Kevin
> 
> [1] https://lore.kernel.org/all/aha321ndGSdReBJR@fedora/
> [2]
> https://lore.kernel.org/all/20260225002434.2953895-1-axelrasmussen@google.com/
> 

