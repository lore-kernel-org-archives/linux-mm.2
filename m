Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91011CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 14:28:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFCA18E00A0; Fri, 17 Oct 2025 10:28:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD3E78E003B; Fri, 17 Oct 2025 10:28:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE9E38E00A0; Fri, 17 Oct 2025 10:28:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B67388E003B
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:28:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 701D4C010C
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:28:39 +0000 (UTC)
X-FDA: 84007837158.29.3246C33
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9A8F9180005
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:28:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="b jh//T5";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=RITuW7EI;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760711317; a=rsa-sha256;
	cv=none;
	b=41uYll9VK40LhQy1ACespV1yICYsEBM6KSaPOuX+PRraKS8PKDyhc7c7ilJPzQccxyoYAG
	rAQL2UiAhVWevcUqmfU0Et8VfBPng2TJSxPOC1P3HJrTE6er0CouvHp/B1BljkAt5bRVeK
	lh+K0rdK2ZZPBlu2QIIYg7FMpRwxmpQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="b jh//T5";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=RITuW7EI;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760711317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fOUvMhyzND8SMM+3QM7//4J9ZC4R57kXKY5ct5iBbmI=;
	b=YttD3pF89oTFowU6BajyA+crpjUSy0YnZgPFWFGcUTA/Ulz3HdVkpKesqxFF4eXyMutgLz
	WK62qHEKS8mWa6TjySmnJksDUjuMBCO8fE87EiLthCyBePIgpm9jhW6nD/XmsxFa9A6KHd
	695RRL+1vZXpdxcNtHENXclhNHWVcwQ=
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 5DE807A010D;
	Fri, 17 Oct 2025 10:28:36 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Fri, 17 Oct 2025 10:28:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1760711316; x=
	1760797716; bh=fOUvMhyzND8SMM+3QM7//4J9ZC4R57kXKY5ct5iBbmI=; b=b
	jh//T5gYDmcxKURMENlhard0U76Q5lY8oEELDXAh1qIh4/u+3OARgGGXBUoNXkb5
	lSbjKnE0BqY9k8t8vMhyPguIBImltkFnXODmIlTSqqTi2ehUT8KqwigAfsIosrmd
	whzvydxgbdrBzaRlyqegjMpp9J+A+oagJaj4ZN0Oal1D7smHh/DKWc1cuqqdvyJ5
	COySGiSqe3IqAiM/dLWzrUdKzsxbxmeZWtex1NHjPBT0D/tvR4gr3Aw5jUs2LA5t
	QtsiCi/PPlVGwBuINlMSz+xPW6Ygx8Y9ovOthzs61/yMSTZ5Fhz6z8mwFQnX/6KG
	E19UT63dbQowZszuS7eAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1760711316; x=1760797716; bh=fOUvMhyzND8SMM+3QM7//4J9ZC4R57kXKY5
	ct5iBbmI=; b=RITuW7EIxxQVsTC7ZCYZer1u1Q7uJgoypwI6+SQMGJOFB09kT69
	IPph0sKr2MxWAjt7Jn3xS+WbOFFn+tYL2vhEYrbx5ehky3V9xylDSN3U8AXqUhWr
	iY+gMmnns6DHrq0m86c1ebNnVn01DeQd8+mzig583j4ebQZrbNHSyaKe1RdQm6NJ
	qFx6y0wCZAcmCR1Du4mhqDQHy2+VD6Q2sf9wYTBNX+TZIOBcCX0hKI3fTVVL9PvU
	vjiVKtmCsK3ItARBFBWyAkD0qfgFDGBmmTIJRWBxRrzB1Yn4LOUenptZU6DL+J7n
	XG8xCCQn+lIY9NgU8QY4CweErdaug4MD3Kw==
X-ME-Sender: <xms:k1LyaAj1Odqo_C2-_8Nk_hUenNkz0_p0XdBxXL5CLKmjRS8xylZn_Q>
    <xme:k1LyaGtrRtlfKJsfOdiI4Q74A15jruqbjlBgAJQ4MIX4pQ5JgTY-0ZhKAEs2C0-rU
    A_KQQC6GHx5GpWiiJkIDjUrYRkbrn7GsQT4taHFTGffg3crcr8WjNM>
X-ME-Received: <xmr:k1LyaJ3IlOtN3z_O20hIRkzG9YqdnaBAyCn4Dn2H_z20K5pO5HDevjdAsZ5UNg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduvdelgeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedv
    tddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepuggrvhhiugesfhhrohhmohhrsg
    hithdrtghomhdprhgtphhtthhopegujhifohhngheskhgvrhhnvghlrdhorhhgpdhrtghp
    thhtohepfihilhhlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehmtghgrh
    hofheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepphdrrhgrghhhrghvsehsrghmshhu
    nhhgrdgtohhmpdhrtghpthhtohepiihlrghnghesrhgvughhrghtrdgtohhmpdhrtghpth
    htoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthho
    pehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopehlihhnuhigqdhfsh
    guvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:k1LyaNwxvozgb9ulil_-fdPW4iUhQhCf4cJctnltxPe6VyelIvJCYw>
    <xmx:k1LyaEV58ky8AODoEyF2iw127ag2NWtOirtR380GUyU0fgpeYCsJMA>
    <xmx:k1LyaPDBl0ezsw88WgTMdyg5VqCkuuauMepjqZmz7Bt6fF4R1BdfUw>
    <xmx:k1LyaF7nKYe2UWjApQsTE3ynoxs-YbphWTvEac7w6iWLt0QWtvQ0cg>
    <xmx:lFLyaKdRBX33i2NfuLF_QffZ2vE5ImnL07iMFCruCD3NNf4Ok2AdM9X->
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Oct 2025 10:28:34 -0400 (EDT)
Date: Fri, 17 Oct 2025 15:28:32 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Pankaj Raghav <p.raghav@samsung.com>, Zorro Lang <zlang@redhat.com>, akpm@linux-foundation.org, 
	linux-mm <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: Regression in generic/749 with 8k fsblock size on 6.18-rc1
Message-ID: <764hf2tqj56revschjgubi2vbqaewjjs5b6ht7v4et4if5irio@arwintd3pfaf>
References: <20251014175214.GW6188@frogsfrogsfrogs>
 <rymlydtl4fo4k4okciiifsl52vnd7pqs65me6grweotgsxagln@zebgjfr3tuep>
 <20251015175726.GC6188@frogsfrogsfrogs>
 <bknltdsmeiapy37jknsdr2gat277a4ytm5dzj3xrcbjdf3quxm@ej2anj5kqspo>
 <aPFyqwdv1prLXw5I@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPFyqwdv1prLXw5I@dread.disaster.area>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9A8F9180005
X-Stat-Signature: jwjezmuw88xs1obk69184byjhogp3fij
X-HE-Tag: 1760711317-654741
X-HE-Meta: U2FsdGVkX1/sKkU5F9/LOCGEgJA59jrGDz2ezB4jLcFXEKdiIXYtyBLNF0ixeTUsdHd2gFbtJ8Er/5hDXJG6mX9T7+0u67txjosmkC0w3Sx5eqvOdHIzGYKPcml56NlW7AnCx+HjYXAjU9El6PNr7Ayk/3C1mF8t2GrTvVkrV21YW8A3enJIRIEwCs/prLAsAmGJMYTiPpjnNFROSFDqCXzmbhD9rsF4jkbLE1QryAFJJ7F29i19h2c/MEUtLqbCRhrgj0JiYJb+ByObBTF1P7AIFAYbUjE9Exmlq2f3wNi4O8pvgEaJnxaeiBC5dkqZntpo7WbT0ssHP2M84YoxUohNbEUPW5EGwYbrEBLJ0dwULwL6YSIZH/hYlfwFjgP5T1hT98gFk5QEuDMi9NAwQr1lwhzvUzgJOMzDy8n53i4Ccg+9UWZyHiq4SWQPLxtBND62EuLltNO05fy9we2J4sEdvTInG6DKl0RVnsW6FRQuT3XoKcJe53dSgghTUwhCDHmR395Yi8pG0Dq264XcfBszVY5/NsYDsvWaA+5f+/kmzEMpfUXL2lyvJpqfT/tUeqNAOG6hPdW9M8jnTqNE/8RnuPzONDwTCaDVAyTiDr4Fmao+6KcTWQ/Kw8CncOqSTvOq7BUTTUP1OvXiK7MEGqOaozm06jY7CGPjNkiMz7Larv7wuq5JcFp49SZmr+Pg+ZGYTd8/GaWUZwTVb4FuazvKlrBoNzoV8bG6xpdhlLqN50gITevdafE9FsXEv5SF3AuFIGgrjJT6+6u14BkI/WFXNE9asbAB4Wv6d8Yki0G73v/4QZN7clkK6IZwm8SPB1+Ikj+Cj5podgMcs2qeIkXTD58/J15XIebtzC6puHtMMwvgY3vbRZJzbjZN8DDnFCL80WYiFQUZ+X2ltmRYIFjxuTZJYacdU0oIVaaHIcoZZGuuNniH36+Fcixt+WJ4YXccdwHjkCOlKkqAAcZ
 e2vX6UFe
 qGp6t
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 09:33:15AM +1100, Dave Chinner wrote:
> On Thu, Oct 16, 2025 at 11:22:00AM +0100, Kiryl Shutsemau wrote:
> > On Wed, Oct 15, 2025 at 10:57:26AM -0700, Darrick J. Wong wrote:
> > > On Wed, Oct 15, 2025 at 04:59:03PM +0100, Kiryl Shutsemau wrote:
> > > > On Tue, Oct 14, 2025 at 10:52:14AM -0700, Darrick J. Wong wrote:
> > > > > Hi there,
> > > > > 
> > > > > On 6.18-rc1, generic/749[1] running on XFS with an 8k fsblock size fails
> > > > > with the following:
> > > > > 
> > > > > --- /run/fstests/bin/tests/generic/749.out	2025-07-15 14:45:15.170416031 -0700
> > > > > +++ /var/tmp/fstests/generic/749.out.bad	2025-10-13 17:48:53.079872054 -0700
> > > > > @@ -1,2 +1,10 @@
> > > > >  QA output created by 749
> > > > > +Expected SIGBUS when mmap() reading beyond page boundary
> > > > > +Expected SIGBUS when mmap() writing beyond page boundary
> > > > > +Expected SIGBUS when mmap() reading beyond page boundary
> > > > > +Expected SIGBUS when mmap() writing beyond page boundary
> > > > > +Expected SIGBUS when mmap() reading beyond page boundary
> > > > > +Expected SIGBUS when mmap() writing beyond page boundary
> > > > > +Expected SIGBUS when mmap() reading beyond page boundary
> > > > > +Expected SIGBUS when mmap() writing beyond page boundary
> > > > >  Silence is golden
> > > > > 
> > > > > This test creates small files of various sizes, maps the EOF block, and
> > > > > checks that you can read and write to the mmap'd page up to (but not
> > > > > beyond) the next page boundary.
> > > > > 
> > > > > For 8k fsblock filesystems on x86, the pagecache creates a single 8k
> > > > > folio to cache the entire fsblock containing EOF.  If EOF is in the
> > > > > first 4096 bytes of that 8k fsblock, then it should be possible to do a
> > > > > mmap read/write of the first 4k, but not the second 4k.  Memory accesses
> > > > > to the second 4096 bytes should produce a SIGBUS.
> > > > 
> > > > Does anybody actually relies on this behaviour (beyond xfstests)?
> > > 
> > > Beats me, but the mmap manpage says:
> > ...
> > > POSIX 2024 says:
> > ...
> > > From both I would surmise that it's a reasonable expectation that you
> > > can't map basepages beyond EOF and have page faults on those pages
> > > succeed.
> > 
> > <Added folks form the commit that introduced generic/749>
> > 
> > Modern kernel with large folios blurs the line of what is the page.
> > 
> > I don't want play spec lawyer. Let's look at real workloads.
> 
> Or, more importantly, consider the security-related implications of
> the change....
> 
> > If there's anything that actually relies on this SIGBUS corner case,
> > let's see how we can fix the kernel. But it will cost some CPU cycles.
> > 
> > If it only broke syntactic test case, I'm inclined to say WONTFIX.
> > 
> > Any opinions?
> 
> Mapping beyond EOF ranges into userspace address spaces is a
> potential security risk. If there is ever a zeroing-beyond-EOF bug
> related to large folios (history tells us we are *guaranteed* to
> screw this up somewhere in future), then allowing mapping all the
> way to the end of the large folio could expose a -lot more- stale
> kernel data to userspace than just what the tail of a PAGE_SIZE
> faulted region would expose.

Could you point me to the details on a zeroing-beyond-EOF bug?
I don't have context here.

But if it is, as you saying, *guaranteed* to happen again, maybe we
should slap __GFP_ZERO on page cache allocations? It will address the
problem at the root.

Although, I think you are being dramatic about "*guaranteed*"...

If we solved problem of zeroing upto PAGE_SIZE border, I don't see
why zeroing upto folio_size() border any conceptually different.
Might require some bug squeezing, sure.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

