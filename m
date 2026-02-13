Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B94FEDF150
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 11:02:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F4036B0005; Fri, 13 Feb 2026 06:02:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A1566B0089; Fri, 13 Feb 2026 06:02:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A0636B008A; Fri, 13 Feb 2026 06:02:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 54AFD6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 06:02:47 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0E0EEB98D4
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 11:02:47 +0000 (UTC)
X-FDA: 84439145574.29.35DDA68
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf22.hostedemail.com (Postfix) with ESMTP id E9008C0013
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 11:02:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=anFUloTR;
	spf=none (imf22.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770980565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gGY9mjNmnYiEGqmmSKnj+anrGWP6cFH8GMKxfF8SvcI=;
	b=SUSlP7EuhryMDOFXBfI3wwl+nzqMJV92ZQWUBhLdcOwMA2/1HsOEFv+4GhwlaFyAD5SMtc
	IwHcXvCGI8/nNOxIGjwxYnlat7xDDoHQjQNstyyT0S6l73C9nzC5fSZ72Q1mHuRFTJLxP7
	a/Shh4xH6ZEB1Vk4+pndnhHnlaNPn9o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770980565; a=rsa-sha256;
	cv=none;
	b=pxyZa5HYeHG+hAOWC83g4EcX4Phr5TEkqvs/kdIZVqU6cQsHh2wKyTduXIDmxrBkNh1UW3
	p8B99cFOs3xE3VQm3dFitzWpEm4iS6kW+QcurZHJGlEvRQ/UH1vtmUamy2lVQnMo6jDRjc
	zmTG/c5vmMXaYZcQEBS1HiMileb8LbU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=anFUloTR;
	spf=none (imf22.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gGY9mjNmnYiEGqmmSKnj+anrGWP6cFH8GMKxfF8SvcI=; b=anFUloTR5e87QUrovEFgzRlF3N
	Bq0w6Vgz4WwzBvkH/RITWQQJGLciH8j9utNJjniRskXcA2/WRSaUphtk80EuMiQnft0qc/TqP7wrU
	NVgzxh34jK1COkrSmEcZmG4hNYDNie5hjbV5ppNHzCqajhg8yEMexyPS63MjfJ48wnR2txEYGyaWb
	R6UVmqfpGFTaQ857oPuRVhHc/ssfpkafSr/xecuIlZTYzVU0oEizM3epsnwIYSP4GdaP9rsLXZLOX
	cZqaBCdef/VRyTHXhRBjH4xtBCaMjreMqgv1pIKwKfyn6edQbH0oCjtYuOI9CIW0UH9+y/QN9pERM
	APfe3wEA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vqqwX-0000000C7oQ-2xs7;
	Fri, 13 Feb 2026 11:02:38 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 1DC173007B5; Fri, 13 Feb 2026 12:02:37 +0100 (CET)
Date: Fri, 13 Feb 2026 12:02:37 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: John Hubbard <jhubbard@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Christian Brauner <christian@brauner.io>,
	Shuah Khan <shuah@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, pedro.falcato@gmail.com,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org, Oliver Sang <oliver.sang@intel.com>,
	seanjc@google.com
Subject: Re: [PATCH v3 3/3] selftests: pidfd: add tests for PIDFD_SELF_*
Message-ID: <20260213110237.GC3031506@noisy.programming.kicks-ass.net>
References: <cover.1729073310.git.lorenzo.stoakes@oracle.com>
 <c083817403f98ae45a70e01f3f1873ec1ba6c215.1729073310.git.lorenzo.stoakes@oracle.com>
 <a3778bea-0a1e-41b7-b41c-15b116bcbb32@linuxfoundation.org>
 <a6133831-3fc3-49aa-83c6-f9aeef3713c9@lucifer.local>
 <5b0b8e1e-6f50-4e18-bf46-39b00376c26e@nvidia.com>
 <20250501114235.GP4198@noisy.programming.kicks-ass.net>
 <20250501124646.GC4356@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250501124646.GC4356@noisy.programming.kicks-ass.net>
X-Rspamd-Queue-Id: E9008C0013
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: xid3u8fmru3qk7hi35f37drtkjw9p6gb
X-HE-Tag: 1770980564-449254
X-HE-Meta: U2FsdGVkX19ZOcs2mdGG6v9W9vvZcxJy6c6RAO6HKsxksTcEa9nBbp0MVX6Gfr9FGOiYI6X/iCCeNr6uu+NuhZV808cUMl4MbbF3DFoJMU5CfVR/PV0xbnbxrpxDqdGTWyIR9SaHSEu8KZVh6XjpYuvZP5omHeoXP/BkMEn1V1p6WN/Fd/fl3kV4Kw2XJ061L2/J32h5/I0mszbLR0KImRsCzkAFxt23hhjMZ+EERnHqRWYF2vhtb9ERTc5jZoydx+C1rF34tQR2A7lBHGhQACtTjI4PTso2ADRaVMbEZxyjpuQ6TtsCm37r49y2WtcScwVqXAYgQ0huymSgKV/aHG0ddOfJG2M/YXiT5eSy+P+K6YlVv2LTBkAtxfme/l4aBpIPRZGfTCoF9+VBs2dEIoPHldf2GPLz7PeOhORDOrfJ2Q+k59jQ4z5OMrqHBf7240Lp20khVt34s+M01wF5cNhOCOm3YbYfWK9iqZ4hzuLsp/OyqDM5zMCvUsq1+9fIVUaNe4kMQEje3JRzPkYe29OVDxTuNfYj1rvFro5NKKgurgjVmMZc1CTOsbP37wdHFG71NcAXakXhD061Eew5e5uBRLFEe55RNj+pl/iCc6DDcGMuzmLewC0JOj5LtUf9NP2+e1iVRDEeKNiipD/3L3N5BAuU1MhQ5LqgdpKnNY0Ytsse0LzgBb+f9SRwKpemw072+DtkAT4Ko4tiIfJWNPwtoBRIbvaSqw1pZU8nrjQHNxh7irPUYW9OcDi4Qo6X3FrT+oyB3/lxsKZONSK/YiWrfdy+ZCDe6osykYIhPgqVcJ8WLe7yil61Y49YSUOM/xpIP2D1Kr6RRD8c99gzw5QrYKRYE9XzGY8Lw9cAywILNjn3+Oo7G1KQYds1XPk+EYvjtBCahGcNtRFzvbiBWqq6Dl5+EBa9ZWGmsxr3AxQGdlqZSCMXHAfAAILEgkmgqWuq25+pNFRuKgjBJrr
 lT+SmjPG
 ouGZAxwswh9U3mz+oJldUlXNHZ2W5AYbU1Hfb6eTszXzO6h9KzeGH1U5HNt0eWjE49DZkzfct7V7/MHJGypFQV7+N9g1ZJ7Us4C+I8HAM+BqA2L4oH/ZrdBNDLXAClrSvTue7Kud4b30K23Tk2Kn/B8P0BciLK+KHuiEpkBhhYpPKspFS5ca3QbVASzU8XRIFovOm+nT5jYBWO2Y4dH8EtdsOX3GzhLK/i9MFWYI3Sy4+UILDxQge1Z3scUaphK3ks5A5mJDj0yjikaqXZ5ad5f7mFFhTytjtc0Q3wyrdErCr+Ch+WjciVYhMJaKb+OiKvTPmhg4D9qHRXY0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 01, 2025 at 02:46:46PM +0200, Peter Zijlstra wrote:
> On Thu, May 01, 2025 at 01:42:35PM +0200, Peter Zijlstra wrote:
> > On Wed, Oct 16, 2024 at 07:14:34PM -0700, John Hubbard wrote:
> > > On 10/16/24 3:06 PM, Lorenzo Stoakes wrote:
> > > > On Wed, Oct 16, 2024 at 02:00:27PM -0600, Shuah Khan wrote:
> > > > > On 10/16/24 04:20, Lorenzo Stoakes wrote:
> > > ...
> > > > > > diff --git a/tools/testing/selftests/pidfd/pidfd.h b/tools/testing/selftests/pidfd/pidfd.h
> > > > > > index 88d6830ee004..1640b711889b 100644
> > > > > > --- a/tools/testing/selftests/pidfd/pidfd.h
> > > > > > +++ b/tools/testing/selftests/pidfd/pidfd.h
> > > > > > @@ -50,6 +50,14 @@
> > > > > >    #define PIDFD_NONBLOCK O_NONBLOCK
> > > > > >    #endif
> > > > > > +/* System header file may not have this available. */
> > > > > > +#ifndef PIDFD_SELF_THREAD
> > > > > > +#define PIDFD_SELF_THREAD -100
> > > > > > +#endif
> > > > > > +#ifndef PIDFD_SELF_THREAD_GROUP
> > > > > > +#define PIDFD_SELF_THREAD_GROUP -200
> > > > > > +#endif
> > > > > > +
> > > > > 
> > > > > As mentioned in my response to v1 patch:
> > > > > 
> > > > > kselftest has dependency on "make headers" and tests include
> > > > > headers from linux/ directory
> > > > 
> > > > Right but that assumes you install the kernel headers on the build system,
> > > > which is quite a painful thing to have to do when you are quickly iterating
> > > > on a qemu setup.
> > > > 
> > > > This is a use case I use all the time so not at all theoretical.
> > > > 
> > > 
> > > This is turning out to be a fairly typical reaction from kernel
> > > developers, when presented with the "you must first run make headers"
> > > requirement for kselftests.
> > > 
> > > Peter Zijlstra's "NAK NAK NAK" response [1] last year was the most
> > > colorful, so I'll helpfully cite it here. :)
> > 
> > Let me re-try this.
> > 
> > This is driving me insane. I've spend the past _TWO_ days trying to
> > build KVM selftests and I'm still failing.
> > 
> > This is absolute atrocious crap and is costing me valuable time.
> > 
> > Please fix this fucking selftests shit to just build. This is unusable
> > garbage.
> 
> So after spending more time trying to remember how to debug Makefiles (I
> hate my life), I found that not only do I need this headers shit, the
> kvm selftests Makefile is actively broken if you use: make O=foo
> 
> -INSTALL_HDR_PATH = $(top_srcdir)/usr
> +INSTALL_HDR_PATH = $(top_srcdir)/$(O)/usr
> 
> 
> And then finally, I can do:
> 
> make O=foo headers_install
> make O=foo -C tools/testing/selftests/kvm/
> 
> So yeah, thank you very much for wasting my time *AGAIN*.

And *AGAIN*.. this is still the state of things. Selftests are still
hopelessly broken and useless.

Maybe we should just delete the lot?

