Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D51BCCD194
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 10:22:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C20B58E0017; Thu, 16 Oct 2025 06:22:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF8E28E000B; Thu, 16 Oct 2025 06:22:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0E418E0017; Thu, 16 Oct 2025 06:22:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9E2DD8E000B
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:22:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 69842C026F
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 10:22:07 +0000 (UTC)
X-FDA: 84003587094.05.DE6BD56
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1B564A000F
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 10:22:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="V 0H7RB8";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=P2jcDerb;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760610125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4cgizSnh8FyjftsIcMN/5doeb/L5sYJZzPBngz1cPTs=;
	b=4QlxSYWBwJYYeA6NGHRXwlD60Mq4jA+4ARqfHvDfPU4JY3qpE6aqsf4SWiy+6fYR6rDVHG
	APuN8VqryeZJzkqj+HwU4Zszvj4E1EwLGcUP+JgolahFmEO7gJ5NEQdj9yACkn1VgtlanL
	zhDXb/F/CcFv/PdH2p3hxSvAsGMB8tg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760610125; a=rsa-sha256;
	cv=none;
	b=WTAAX4CYyt0ZsIUpnF8QwGA4KFRZDfKA3rFJbFYdlpPfy9YDqvldNo+XPK5F29Olx3hgz9
	FelK8pDJI8Ja9iy+no6UsohWfTDzs3BMeBFnZdlvoKwosq/YhR10EBHZhWk17oyLNiBrL9
	fj9km3yRdo82J7IJNHNIk1o/W3hyWjg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="V 0H7RB8";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=P2jcDerb;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 608701400208;
	Thu, 16 Oct 2025 06:22:04 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Thu, 16 Oct 2025 06:22:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1760610124; x=
	1760696524; bh=4cgizSnh8FyjftsIcMN/5doeb/L5sYJZzPBngz1cPTs=; b=V
	0H7RB8kX6dTe4pJfkGYa84CFGKQi7NQQwlIG5JtdXa17rPgjGU7VP1Im0x2JCx0C
	erNolu6GR6GrwirzS9l8PkU+m7UIbkA7XvpPXC7ZFyxsPYDEIbw1RrFzpxGqkE0I
	XSX2c5KYOu4R22qernV1tzWejdNPVpiF6l4acfHqHponV+OQwKMyBJBac6s3srED
	hFX3UEvTtKGF2/OHDDBf5m2oNLPo9+mcCfSWNi51R4gTtStNacgN9I+rh/zOeCdI
	bzeQI6SB+IMUgCVz7V3V15HPW5Ew/NXITdHFdAV6G//4gfIEajOAOqA9Yzk/TrTw
	tQ6ZnYipFhCaAm0qTeNoQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1760610124; x=1760696524; bh=4cgizSnh8FyjftsIcMN/5doeb/L5sYJZzPB
	ngz1cPTs=; b=P2jcDerbD5gusICBdwO0U719/hGR3gBgsrnEyk/uej3H9tIAQJG
	v7VgnltT3EvGvGG8+qrHW8D01JayYRv3okQbhAmUsijIbYrDIUKZ6S3S5/B9uLUr
	sSSx+QliS0zx1jH0Gxkvh7EyhpBHhERXy7acCWQLVRCPtOoRUXrp0MEcdkW7nZjF
	p/YgXjCydO23+cAAi/nmtPR0J1TjbTgQCUbErZT3E3/AZQlhYg8dzAaolvdkjNEN
	dC7i/NUPFe6YIqVV+eM8q9ZRv9QGFDBjT52AcCsxFfamN6djOIogNSb9V9SX4oeH
	phBvOoSe7RTOsP15zKrE1xGb5EaNosPQYkw==
X-ME-Sender: <xms:S8fwaP4ttjK6p3ef3wmSGFlFfKLtlDlXeqs087EFm0bPMRMUebjRmQ>
    <xme:S8fwaKboqjlnMreOaFW1YHCqKvbBO6P2TuqFlfh8IEkjbZQgdM9xKqtWmQfsXMwBa
    eyyGchYRW-Yp0dAfXK-Z_Zi10RRSNQLw7RbhXPhlaNigx4QAxQo1g>
X-ME-Received: <xmr:S8fwaOzJ7OkTL37tgtZuF7fDFCGl3u50u-MZSNoL7SAdZxEofOAvPqJ-qotFZw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduvdeitdegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedu
    kedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepughjfihonhhgsehkvghrnhgvlh
    drohhrghdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghp
    thhtohepmhgtghhrohhfsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehprdhrrghghh
    grvhesshgrmhhsuhhnghdrtghomhdprhgtphhtthhopeiilhgrnhhgsehrvgguhhgrthdr
    tghomhdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorh
    hgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtohep
    lhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtth
    hopehlihhnuhigqdigfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:S8fwaOPAgsDds0-ECl8Xyiqk0Z-xHO-Y5a8K0wNF6vpeVGcbwlcHDg>
    <xmx:S8fwaE7JMiDYacnKnQrAKBYRmKVV46Zunrxozt_3-856GxaGppyfZw>
    <xmx:S8fwaMfTCaQfJZvxTeKiGbOA4RU1D_fhU49T0yoOfv8RAIr7fuoCpQ>
    <xmx:S8fwaFJTy47n8Wuhx5FhwgBa-ro_YtmFJybzJQGxDhY7vB3dhQVNMw>
    <xmx:TMfwaHOsd3ep1ugD0EAPyXlN6Es_j3EWvKWJGeCH2CtZJr8affGgsJqb>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 16 Oct 2025 06:22:02 -0400 (EDT)
Date: Thu, 16 Oct 2025 11:22:00 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "Darrick J. Wong" <djwong@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Pankaj Raghav <p.raghav@samsung.com>, Zorro Lang <zlang@redhat.com>
Cc: akpm@linux-foundation.org, linux-mm <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: Regression in generic/749 with 8k fsblock size on 6.18-rc1
Message-ID: <bknltdsmeiapy37jknsdr2gat277a4ytm5dzj3xrcbjdf3quxm@ej2anj5kqspo>
References: <20251014175214.GW6188@frogsfrogsfrogs>
 <rymlydtl4fo4k4okciiifsl52vnd7pqs65me6grweotgsxagln@zebgjfr3tuep>
 <20251015175726.GC6188@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015175726.GC6188@frogsfrogsfrogs>
X-Rspamd-Server: rspam01
X-Stat-Signature: wkuya6jc8hqrds6b38jz4rt3j5jctwx3
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B564A000F
X-HE-Tag: 1760610124-923682
X-HE-Meta: U2FsdGVkX19LLlpNB8tukNuPA6fHHPD/OpXgGspSibiPgfWNfuxDwhmlHsUgiheM7uiSExZBZYij5haLMjl5nEICeyRcF5pbk1FBYfVGWq5v6VpqU5TykVfnMaZwBhz0aPMT9uJ6F08AqoVflsXjZvuK0V9Lh/MSCSmaBEkJ4bQie2B0Wshr52T+13odpoMU/cr5f9+iDsf+70By3FVrFrQjUzGFKz3tydJeQTn6SpRkulMJcE3OLmhizlq+yPDje1UxJCzUapkELW06MukUOgCjtHF+H5iUmunbGI9dz4U6pSRVi1WThmTjd7wkGYgYNgv8gZJOLloBCIuroZQN/mgca1/SeEdgCsUGrdqPF5vcoNhHaGtTotVYHobggJZx2DAHQIM/UpR5XBEbRzK5ZGs2DjY5E4HW/LZGTTxrmdmnloe+c4XHTP8O/CB0+TcETP1xghjCZou19qOkhTHXo7LQ+txCrpUo1ZSsFJVo9R0fwfrPVznVKZjryWZ02BGsDvPd06DruMUWfW3igRofYfI2/lIRizto7mmevw2IN2WkGxZh7kRgqPjXwNNq/97Q5xLV0fCxu83GYVLOD1yuVLS7K+DscS+8ajRiBVG2IFtgrG63LRiPPER1zrkx99wLtBKRN6EVpEJalioV139iio70BZ5aYnsNPVdTeYSZeOMdTEtJnKMnuWNIm9Nhsdog8GRoob7PMCu1ne962rB8YrC+fN0CbBpF+7iqNMCEYupXkeROMYfjjS8VX3agWFQvMYLDJ6K+TekKEfcCKHen98ThqfPn4/YobHHcc/ih79MFKOyLA3nwWWCfd5+qDvkh/++gFt4cegXvw3SNxvi/k+jDGXFyM6UMWrN7UfL3PjU0T1IVOX2JSdAnDYHusKZ6W1U1c2gIS1Eot/cxsnYauaBj4HrCPk/+8YNT8nsD9D8RS7NHja55+S3OHSk2gCtpbv0WTnwv+Oz4grE+Hh7
 0BlCNMuu
 ytHyDXW41rsLK+Dk9LANwwiRBwdYtSAoZDCPxulgQRHqpGeu9vU69Wtfb71nl41uwpCkpeso0MwheVSlTIUOf6j8BlxRtuBBxE6sYsYaoBIkn4Qvx5kvTebMj+Nq0cJK8VKwbjx9kvthsBk+pBuA1tU03oeo/d+qOYfdRvQ3gn7C5kM4E/OC4123VhknGWiOEK5FmCabIWOPhV8Rhu0DXsSwHnuYP8BrFYlyVIm4+SiKkXlXV7HoD9n73OQzVKwC3AWZGFd4aq/bXNj66SHE27zQDwMs1S72fSqOVm2DwSBu8u9v+WL6WquzsQ+WzP3ErveBkgbzdTDtfgoP5XzkoMsMp+whKIdudJSWgsYJaOM/0Vn2v/o/0y8RLthPeVR4BX8Oe+SPS09H+MJjPjYZU4hxxgg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 10:57:26AM -0700, Darrick J. Wong wrote:
> On Wed, Oct 15, 2025 at 04:59:03PM +0100, Kiryl Shutsemau wrote:
> > On Tue, Oct 14, 2025 at 10:52:14AM -0700, Darrick J. Wong wrote:
> > > Hi there,
> > > 
> > > On 6.18-rc1, generic/749[1] running on XFS with an 8k fsblock size fails
> > > with the following:
> > > 
> > > --- /run/fstests/bin/tests/generic/749.out	2025-07-15 14:45:15.170416031 -0700
> > > +++ /var/tmp/fstests/generic/749.out.bad	2025-10-13 17:48:53.079872054 -0700
> > > @@ -1,2 +1,10 @@
> > >  QA output created by 749
> > > +Expected SIGBUS when mmap() reading beyond page boundary
> > > +Expected SIGBUS when mmap() writing beyond page boundary
> > > +Expected SIGBUS when mmap() reading beyond page boundary
> > > +Expected SIGBUS when mmap() writing beyond page boundary
> > > +Expected SIGBUS when mmap() reading beyond page boundary
> > > +Expected SIGBUS when mmap() writing beyond page boundary
> > > +Expected SIGBUS when mmap() reading beyond page boundary
> > > +Expected SIGBUS when mmap() writing beyond page boundary
> > >  Silence is golden
> > > 
> > > This test creates small files of various sizes, maps the EOF block, and
> > > checks that you can read and write to the mmap'd page up to (but not
> > > beyond) the next page boundary.
> > > 
> > > For 8k fsblock filesystems on x86, the pagecache creates a single 8k
> > > folio to cache the entire fsblock containing EOF.  If EOF is in the
> > > first 4096 bytes of that 8k fsblock, then it should be possible to do a
> > > mmap read/write of the first 4k, but not the second 4k.  Memory accesses
> > > to the second 4096 bytes should produce a SIGBUS.
> > 
> > Does anybody actually relies on this behaviour (beyond xfstests)?
> 
> Beats me, but the mmap manpage says:
...
> POSIX 2024 says:
...
> From both I would surmise that it's a reasonable expectation that you
> can't map basepages beyond EOF and have page faults on those pages
> succeed.

<Added folks form the commit that introduced generic/749>

Modern kernel with large folios blurs the line of what is the page.

I don't want play spec lawyer. Let's look at real workloads.

If there's anything that actually relies on this SIGBUS corner case,
let's see how we can fix the kernel. But it will cost some CPU cycles.

If it only broke syntactic test case, I'm inclined to say WONTFIX.

Any opinions?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

