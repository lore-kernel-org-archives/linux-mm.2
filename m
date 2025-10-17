Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A8B7CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 17:00:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19BFE8E002E; Fri, 17 Oct 2025 13:00:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D78A8E001F; Fri, 17 Oct 2025 13:00:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBAE38E002E; Fri, 17 Oct 2025 13:00:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D34938E001F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:00:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3D2418667D
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:00:17 +0000 (UTC)
X-FDA: 84008219274.03.8172307
Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	by imf17.hostedemail.com (Postfix) with ESMTP id E5A4740014
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:00:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="L YEeNVU";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="lHyF/q8a";
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760720415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FHeABDDNpBcuH/HxHTgtiS8h1Pih1w3YqjzpkSvYXEk=;
	b=ozKzgR01J2WItcoDPRVAzBeySh/a30YXpKOCD3v790zA5ESEPSIlv3u8Ug2gU9ORK7eIT9
	gRb5oVjOrMyrMQ08qLHpS+q6uEaKxHLejuNDf9scDOgksB3uEtlgJ6Hs7Mrz7/IHQqFgZx
	JltzGJ8i46BDHmlh3GjAoOxsEqxh8+4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="L YEeNVU";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="lHyF/q8a";
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760720415; a=rsa-sha256;
	cv=none;
	b=b4Y7rUi0CS1S7qgSyHN70zWy5EXEaTYrC1wds6p62v0D9m0KGOeKA6hX9jqFXUoMoNLCO8
	gGHDaMXh5wOzbrGcH7/N9kofbj6ljFz43x9vcpMqJADPz3pnF2+fY02lhNKEb2k3/vI4+R
	YEE4sMFl9QLjOEZ2XbYKGVsTiURFW/o=
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailflow.stl.internal (Postfix) with ESMTP id 8DE74130074E;
	Fri, 17 Oct 2025 13:00:13 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Fri, 17 Oct 2025 13:00:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1760720413; x=
	1760727613; bh=FHeABDDNpBcuH/HxHTgtiS8h1Pih1w3YqjzpkSvYXEk=; b=L
	YEeNVUi/9EqRu8aINAmTgi97ip/bfdsnzAod6qhb1fATOgyYJOymJ61PJdRpLbfz
	KE/5rtXyrO5mxjBAgsf2XX3uAK94kscXmKkAo692H/rdYW7750fgVEN5LeDXAO3u
	AkPKykEO4qGIMy8DckWtbE1xfKTdbn3fofU5VYQklmK1Frt2YdfNWM/rszptGF3D
	MSCLY6wSin1fAd9CsjADQ6V3M5lEZ7T9iP0/3i/i+N5Q8K+Go4bG+RrV3B9e0g9W
	z3b0Rzc7mJnWPN0ADSKWFWrs+F+uDRGb0k+DO7vhv+anGTDmvqxkYBHqDTW15p0f
	FaWEKXHczG1iXljTUT0iw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1760720413; x=1760727613; bh=FHeABDDNpBcuH/HxHTgtiS8h1Pih1w3Yqjz
	pkSvYXEk=; b=lHyF/q8auVcPkYBtF/i4yGzZNyGpmUeLbBTOhY5tXfkGtWcrhby
	brA66/eRwRTjQKfL86nlHFYvvCFfG8+PEiBZrxAKSzH/FSQEfizDxoAcgXv+tFun
	MpLiM1IytVS5i/HtEIS5isZWtzPG/OFZarK8ww0lwqQwpfytffqF10i67BSJxUFD
	T/mGFZKDepkl1wqRcIuqAt+QrdFJMg4Nx2lrWhZ8n/Paz9WtYah+O9k4sR8eJFCJ
	WlbibUAIwLR7PUzzr3OZqdnL1HXqP9KhAjMgHQzMEbpX4nko66NejRuGljWVfyU9
	dJxJjv6ed17yPYjslzVmDMPdLOZ/kB92Bwg==
X-ME-Sender: <xms:HHbyaF50ErfQ7-IyA2sJ_MPN6iRS1Wbxo11_-S2HR4z9pPDS6Sx2jw>
    <xme:HHbyaDXHfG0R7heMApuKjBTsSfdt4TEWE1c-2XKTXxikp4bkfm3cIcY3xFiJxo4ud
    KIkGOL2BPG9h7X9skeG7MGcu6ROqDDY21XMp4FlyEu_DCP_gPReIeA>
X-ME-Received: <xmr:HHbyaB6ztCj2bQSfrFMoqKlCenY59AGw9wcmDhJ2v7JFc9fR3UX-hoong955Ew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduvdeljeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedv
    vddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepughjfihonhhgsehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehtohhrvhgrlhgusheslhhinhhugidqfhhouhhnuggrthhi
    ohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugesfhhrohhmohhrsghithdrtghomhdprh
    gtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepmhgt
    ghhrohhfsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehprdhrrghghhgrvhesshgrmh
    hsuhhnghdrtghomhdprhgtphhtthhopeiilhgrnhhgsehrvgguhhgrthdrtghomhdprhgt
    phhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpth
    htoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhg
X-ME-Proxy: <xmx:HHbyaMGOveeNjZzAudyjrneAsdQGCnxByQQ3CeT6yrPQXV1mM_U-sQ>
    <xmx:HHbyaM-mmumzQdSLYF_ohtJW-tIDdjFEnZRfFZiRd7Put-BzBVmH9w>
    <xmx:HHbyaGUHVMec6kjyA4moEn1w_zq_DjqTYrS7npJoD7GOn0HPmlX34g>
    <xmx:HHbyaGHJSStwXVZPq5lbZP0eP8Y8sp0bv-dbLF7I2qita5FdKSZl9Q>
    <xmx:HXbyaGDxeFYyep87XcNsuCiogm5tjteWZHVpNxCOXMXxQ3J93r6agDIe>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Oct 2025 13:00:11 -0400 (EDT)
Date: Fri, 17 Oct 2025 18:00:09 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "Darrick J. Wong" <djwong@kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, 
	Matthew Wilcox <willy@infradead.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Pankaj Raghav <p.raghav@samsung.com>, Zorro Lang <zlang@redhat.com>, akpm@linux-foundation.org, 
	linux-mm <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: Regression in generic/749 with 8k fsblock size on 6.18-rc1
Message-ID: <r74wgxke6ewkt3okbkrnd6lbatjrms4rcxws7dhvfwf2oi4yb4@g5aev2vz4nl4>
References: <20251014175214.GW6188@frogsfrogsfrogs>
 <rymlydtl4fo4k4okciiifsl52vnd7pqs65me6grweotgsxagln@zebgjfr3tuep>
 <20251015175726.GC6188@frogsfrogsfrogs>
 <bknltdsmeiapy37jknsdr2gat277a4ytm5dzj3xrcbjdf3quxm@ej2anj5kqspo>
 <aPFyqwdv1prLXw5I@dread.disaster.area>
 <764hf2tqj56revschjgubi2vbqaewjjs5b6ht7v4et4if5irio@arwintd3pfaf>
 <20251017160241.GF6174@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017160241.GF6174@frogsfrogsfrogs>
X-Rspam-User: 
X-Rspamd-Queue-Id: E5A4740014
X-Rspamd-Server: rspam03
X-Stat-Signature: p936iwmc3m3zgbcw98asy7b3mng8hq5b
X-HE-Tag: 1760720414-422115
X-HE-Meta: U2FsdGVkX1+yotEpIRPMXadVHFF8P4Uloshpcpl3PvTmhFuVTg/v20aFrgaBngto0zZSrg2vvpkal6QIw/F4Y2DC+Hh14Qsiv/57EJtJ22Q8cpCe8FngsWRTY1ARu3f9jXFqOkmwakQEo6kDcAYfV+q/YjSKyJCKEfDJ/JcEzNFEt9qmKJACitJZVfMegiN4fKVufh/jTkYRuDKHRO9HBUk9w0Ufw8iCyq8tXsJC7BYaqUTKWjwUIy2V+cOCW4uNhr/VJEGdPswS7jCf+ehDM2oerHli+3yMLW/lvThMYUMnwuTzxKf3TkjnQP5Nn1udCy9ZSdB8khepItDxYY8MDd1aSTCCrfZeS4wMZuX/+jteKHrt4tOtKLehIA8TJWQTyziKt35W+IdbvVyrhNKaWvXjUVs1nCMSUNwXLc1i3ScasHopOUur75UcG1PuUoHs4x2UpJmyqZY3uyWjAipVVb1ZWfCLMRXV1Jgv7pHfE5xORPRomNI3ljdwZd6WX5pU0wqjm6N2ZfeRwWpiuNKsrrwhTNyhNcdcQKPIe0AcdDW0++/YAqK2IxJWUmu5gXTlQPf3mkG/hMyCSQrRLd2GuW7h5sbhJWMWmYBTzZTSz6idSBQ1SREIYWV2ejdlAAqpjIVEqrxej2xIFEcinpY1SWgRAYZ7AnZmDsP6tyzKUaXxDWRZP2lFRpsx0godYyhjiyEpvpB3MumCCZtSnzu1EFauL+9rPyfg5p8feihg9q2JAhiTTdsBjo0o3NKfPIGUbiG6AUhGNByizyOln4A2wX7/ZZ415hvXKpR2VRib5E3kVjGKpXijD4kv01YpPvOwL9OPeonTSaUCLL835sU1S+CL1fzdFRAYm1eNxFcH4UIcefG1ZJEWE7HBICiB3BXH2dyAstzugWph2yDr/P8OiilS3tfyGueaL7H02/uyKEGCiWsjVMhX/Vx6lDKcl1fGXSMD70LH08D49b0aphO
 2E9Sk5wT
 5kYBnZgeUKgECUIigGwlt7LTB/BBFrDIX/MAU/0NT1S15SdWDEb8Oc1MzHVTQk5O+CeuEqsEyw412c5uEAmK6TRXfLyTtN6VITViZKhdZL2cmFHYUti7xkcvg9xE8nx8RFlWGN2dV9EDWwwC7ve9o8ja+8wVvLAYWCT4Zkm8DLm8ibin690H/wAjyxa7fMcuoyevjznyTIxfCO6Zwnu94nzQrfskssv4aGdsNJ6GdSK0gyKCf3Vi/ApZRBRejhER0QBXkPYpoLVaxPGCrPGH+ek8TcNuUwgsL0bGjBh2luJdvNkcluN38yLK3/JliJMYHTsubcHogTMHlDnsRB/jfKy9JR+1lg0ogK6UDSxuK2AJiz+A0YbYcLji/EhHQPoMEyo/qtXjuiQANuvkWP99bwGT2kpf6Sx/aBT2HUO2jjAl2oSLh/AWpaVl+m9+tpbeDBUOa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 09:02:41AM -0700, Darrick J. Wong wrote:
> On Fri, Oct 17, 2025 at 03:28:32PM +0100, Kiryl Shutsemau wrote:
> > On Fri, Oct 17, 2025 at 09:33:15AM +1100, Dave Chinner wrote:
> > > On Thu, Oct 16, 2025 at 11:22:00AM +0100, Kiryl Shutsemau wrote:
> > > > On Wed, Oct 15, 2025 at 10:57:26AM -0700, Darrick J. Wong wrote:
> > > > > On Wed, Oct 15, 2025 at 04:59:03PM +0100, Kiryl Shutsemau wrote:
> > > > > > On Tue, Oct 14, 2025 at 10:52:14AM -0700, Darrick J. Wong wrote:
> > > > > > > Hi there,
> > > > > > > 
> > > > > > > On 6.18-rc1, generic/749[1] running on XFS with an 8k fsblock size fails
> > > > > > > with the following:
> > > > > > > 
> > > > > > > --- /run/fstests/bin/tests/generic/749.out	2025-07-15 14:45:15.170416031 -0700
> > > > > > > +++ /var/tmp/fstests/generic/749.out.bad	2025-10-13 17:48:53.079872054 -0700
> > > > > > > @@ -1,2 +1,10 @@
> > > > > > >  QA output created by 749
> > > > > > > +Expected SIGBUS when mmap() reading beyond page boundary
> > > > > > > +Expected SIGBUS when mmap() writing beyond page boundary
> > > > > > > +Expected SIGBUS when mmap() reading beyond page boundary
> > > > > > > +Expected SIGBUS when mmap() writing beyond page boundary
> > > > > > > +Expected SIGBUS when mmap() reading beyond page boundary
> > > > > > > +Expected SIGBUS when mmap() writing beyond page boundary
> > > > > > > +Expected SIGBUS when mmap() reading beyond page boundary
> > > > > > > +Expected SIGBUS when mmap() writing beyond page boundary
> > > > > > >  Silence is golden
> > > > > > > 
> > > > > > > This test creates small files of various sizes, maps the EOF block, and
> > > > > > > checks that you can read and write to the mmap'd page up to (but not
> > > > > > > beyond) the next page boundary.
> > > > > > > 
> > > > > > > For 8k fsblock filesystems on x86, the pagecache creates a single 8k
> > > > > > > folio to cache the entire fsblock containing EOF.  If EOF is in the
> > > > > > > first 4096 bytes of that 8k fsblock, then it should be possible to do a
> > > > > > > mmap read/write of the first 4k, but not the second 4k.  Memory accesses
> > > > > > > to the second 4096 bytes should produce a SIGBUS.
> > > > > > 
> > > > > > Does anybody actually relies on this behaviour (beyond xfstests)?
> > > > > 
> > > > > Beats me, but the mmap manpage says:
> > > > ...
> > > > > POSIX 2024 says:
> > > > ...
> > > > > From both I would surmise that it's a reasonable expectation that you
> > > > > can't map basepages beyond EOF and have page faults on those pages
> > > > > succeed.
> > > > 
> > > > <Added folks form the commit that introduced generic/749>
> > > > 
> > > > Modern kernel with large folios blurs the line of what is the page.
> > > > 
> > > > I don't want play spec lawyer. Let's look at real workloads.
> > > 
> > > Or, more importantly, consider the security-related implications of
> > > the change....
> > > 
> > > > If there's anything that actually relies on this SIGBUS corner case,
> > > > let's see how we can fix the kernel. But it will cost some CPU cycles.
> > > > 
> > > > If it only broke syntactic test case, I'm inclined to say WONTFIX.
> > > > 
> > > > Any opinions?
> > > 
> > > Mapping beyond EOF ranges into userspace address spaces is a
> > > potential security risk. If there is ever a zeroing-beyond-EOF bug
> > > related to large folios (history tells us we are *guaranteed* to
> > > screw this up somewhere in future), then allowing mapping all the
> > > way to the end of the large folio could expose a -lot more- stale
> > > kernel data to userspace than just what the tail of a PAGE_SIZE
> > > faulted region would expose.
> > 
> > Could you point me to the details on a zeroing-beyond-EOF bug?
> > I don't have context here.
> 
> Create a file whose size is neither aligned to PAGE_SIZE nor the fs
> block size.  The pagecache only maps full folios, so the last folio in
> the pagecache will have EOF in the middle of it.
> 
> So what do you put in the folio beyond EOF?  Most Linux filesystems
> write zeroes to the post-EOF bytes at some point before writing the
> block out to disk so that we don't persist random stale kernel memory.
> 
> Now you want to mmap that EOF folio into a userspace process.  It was
> stupid to allow that because the contents of the folio beyond EOF are
> undefined.  But we're stuck with this stupid API.
> 
> So now we need to zero the post-EOF folio contents before taking the
> first fault on the mmap region, because we don't want the userspace
> program to be able to load random stale kernel memory.
> 
> We also don't want programs to be able to store information in the mmap
> region beyond EOF to prevent abuse, so writeback has to zero the post
> EOF contents before writing the pagecache to disk.
>
> > But if it is, as you saying, *guaranteed* to happen again, maybe we
> > should slap __GFP_ZERO on page cache allocations? It will address the
> > problem at the root.
> 
> Weren't you complaining upthread about spending CPU cycles?  GFP_ZERO
> on every page loaded into the pagecache isn't free either.

+Linus.

True. __GFP_ZERO is stupid solution.

I think the folio has to be fully populated on read up from backing
storage. Before it is marked uptodate. If it crosses i_size, the tail
has to be zeroed. No additional overhead for folios fully with i_size.

But if you insist that is inevitably going to be broken, __GFP_ZERO
would solve problem with data leaking at the root.


Whether to zero the memory again on writeback is less critical in my
view. It could only have whatever legitimate user wrote there and is not
a data leak. Or am I wrong?

> > Although, I think you are being dramatic about "*guaranteed*"...
> 
> He's not, post-EOF folio zeroing has broken in weird subtle ways every
> 1-2 years for the nearly 20 years I've worked in filesystems.
> 
> > If we solved problem of zeroing upto PAGE_SIZE border, I don't see
> > why zeroing upto folio_size() border any conceptually different.
> > Might require some bug squeezing, sure.
> 
> We already do that, but that's not the issue here.
> 
> The issue here is that you are *breaking* XFS behavior that is
> documented in the mmap manpage.  This worked as documented in 6.17, and
> now it doesn't work.

As I described, it was broken, but in a less obvious way. Order-9 folios
are mapped as PMD regardless of i_size before my recent changes. They
*usually* get split on truncate, but it is not guaranteed because split
can fail.

We can "fix" this too by giving up mapping folios as PMD (or coalesced
PTEs) if they cross i_size boundary.

I think it is bad trade off. It will require more work in page fault and
reduce TLB hit rate.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

