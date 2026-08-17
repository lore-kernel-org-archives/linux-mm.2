Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B22CC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 19:04:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4949A6B0108; Mon, 17 Aug 2026 15:04:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46C456B0109; Mon, 17 Aug 2026 15:04:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35AE36B010A; Mon, 17 Aug 2026 15:04:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F25F16B0108
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:04:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6799E1403FB
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:04:08 +0000 (UTC)
X-FDA: 85111686576.02.CB41EEB
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf21.hostedemail.com (Postfix) with ESMTP id A92B11C000E
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:04:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YBZXvXnH;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786993446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OTqKSZ/aVNz2Amr3R57w1RzJlBPcvOnk4JI+4enPmBg=;
	b=77Rfn8pIHBlIVa+aCwwfEMjpRMrSkG18+3OJTbSuUaEya4OrI8SqgndIao7YOtLab2G/6Z
	3c1Z98Ck8ejKvoZcrgLn7WddpzxRfKl0zfnWUqFqkmGuAPg2bGxSiglICxDQZDymbAqQZ6
	1PmNHBnvdoSGdY8YMe5BLORNwRxEYQs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YBZXvXnH;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of andriy.shevchenko@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=andriy.shevchenko@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786993446;
	b=S+SUq7DoeWBikRQx8mwUihxCdFZXOmKgHcjhCpbb2bf7S3Xc1hqa9GheB6trmusFZWgDGM
	FHLW+SyrL+EHI0aH1sbAlX5DIe1j3y/mMuZhHl6skZSI8ywlpg7ZIkKUwfemGrgQ+nq12G
	5VzCZqYwN+j0GzxLh1winT6RPQIylO0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786993445; x=1818529445;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=nfWTqloCCpBax5eOufLIQF4jh6VR6S2dgMYQznZQ+H0=;
  b=YBZXvXnHkzsqlg94M8I5FvURoFxfYVj5Ob/9uX3D3eTlXfPjQSE6xc2f
   ecxsqwLXL8eTZyRHsYOYNCuGOenSNnXw71AZg7JwDhoyrPIdPxtoAFefa
   irgTDDgN+KIIsXmgYP9P6HUMte+KRB8BJwAAOWQJ9BevX7eV24MP/2+bg
   HJSm/leoEQD4E4UcCTQuLPCA+6JaZwvj3jTMOr/Ea4QjHO3+2xF5Y6Zb/
   n8RDTot9jqz6F9kRl+0fqAFCw3l0TqGQOZBR6W1jdX6D+1dzSKu8KZoBA
   gXUtPuJrpML8PfFhF0eBit7q857eKOtqCnvr+6hVOGGXsrAn/xzE/PRw0
   g==;
X-CSE-ConnectionGUID: 4VJRSwcpQSGyS5/8HrXLTA==
X-CSE-MsgGUID: p5BfE6ObQXyau7ipzS3JwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11878"; a="91349007"
X-IronPort-AV: E=Sophos;i="6.25,229,1779174000"; 
   d="scan'208";a="91349007"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 12:04:04 -0700
X-CSE-ConnectionGUID: JQkNrAYrSoqBk7KiJNnKYw==
X-CSE-MsgGUID: Hc7ZFPPnT+aAgX5eDxCvdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,229,1779174000"; 
   d="scan'208";a="264537815"
Received: from klitkey1-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.67])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 12:04:00 -0700
Date: Mon, 17 Aug 2026 22:03:57 +0300
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>,
	Yury Norov <yury.norov@gmail.com>,
	David Laight <david.laight.linux@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] vdso: move offset_in_page() from linux/mm.h to
 vdso/page.h
Message-ID: <aoNbHbfZyNfA8QKT@ashevche-desk.local>
References: <20260521090655.160282-4-thorsten.blum@linux.dev>
 <20260521090655.160282-5-thorsten.blum@linux.dev>
 <ag7pFxHpMGU0zLvq@lucifer>
 <ag8cvjwDGCt_14pY@lucifer>
 <CAHp75VcJJtfnSYFA8vhtsuZs1gLo+Jpne3TU2WgMZxLiB+95yQ@mail.gmail.com>
 <ahAzPTUMwMZfW2kx@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ahAzPTUMwMZfW2kx@lucifer>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Queue-Id: A92B11C000E
X-Stat-Signature: s1sn4h91w3yym4dj1c3nt774wr46fkit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786993445-554671
X-HE-Meta: U2FsdGVkX19rpKlpTI42Moll0LpXoqxjK2zQgROmAZpWSH8urFo3TQVUdFNPrxC/Kwlc2n+ksIUOU9sUWllahlmxuqZUKu4/Kq2lYrCqwirCmij/LZHslH5g3gS5tVZD54zaTFNEqFsfGf+of9wQeSAppQRjrm/wVk3ZHHPBlb5BtJGLjm8UkS3afz8KH+mJz3hKMhzq8zOqXUJprInr2dBAdwoBxYbM7O+Ruhw+WFXRd9AZ86P9LbbbANi+5UHR8N2H1Bpaaaynf+rUu/IRj1VbudIPWkVAlMcFiNADfuibrfAdKCj+CiMf8HsTI8/y2VYj3sroX2JwQRJkpH2WBRm9biDLuxQoBCBV4gO/M9RniVtWbLyCMIfKZQEUAHXCtQZ8Rk8R+F14/ct8B4s+iYvrv8PvX6XMT/83nijAQ7B4lc7sH+dnYbC3KX8IIeV+U11rgur3TqLML+SLEZF4U8XeLSeasLby3hYw/k/8gfq5uaruFFb5fYfZ9ZDJGWvgRW6XT7cDNzr4JQd6HHgkkjgQ26BxrQuJLHVsXrbWTKHfO84o2zkCg/NWn8Asz0BZwNRh9YQqWBNqVZfldIVzPfe/oQ34oVHHEugCmQjjoxacxQj1wCObH7UsrGbIYi7ggmIPTo/xPrzmYcSsavJLjjrx8oOgCKjmRDcHXaI3yCD2xdeqsIT1T2sfCvp+Zw7jvQWibzutOwiVv8VWAGawkpBwwzoZlfSNY3JxG8C0ZRpKdUyhXIQsURp0FSWOlxvv01b9dq24qaDlo12s7vgi8YkapTNeUw6jrG3mmXYlJQe5+1Wd1FWdeHV6PcTSHxhwm7zHBRD1g0SjUiRwLsOBm+OnEksKjEeS2kLmydS6eUK5aE+zIqU17IBYK9m25gC/Daa/f7jYpDdt1mvtLW5pBclqW7TZYrQeFZ5H8ikK7dpKvkF0Ob+lbFTt+zCf8u3sAY+uRMUK73pxcwFF5KQ
 Evv6WCgR
 wKAxyYAZq+UM/WLcAVH1t0e76ZfXNA8xXLtSGm+CmlZg9k5oQwVvuUwQQEgUbEjCrWWdKXAma+N4cQFQlE0OadS0U4EqItFKIfElK1UsqDXVLVYVwK0RtIPLfy0NaRelHk6rARIFkrcG9PCiUd2mqS35iRg6KFgPSBM0KKvIQUIKL9xklWibn/Ing5gvEefMJQKoN2/QwR+6XXmsHe/Cgbvbo1sFk4JSS174RFFAoQC/YmKsKxTtwbgUls6RYJ8smJQUXUWue3Da/SRFFyPcqbVm31CgBhjv8KgRuePnF59KvXiIANSHGhm592lg/WtiEt0T6a2i7v8lFZliEicF9QuWFHcV8rD1GBQozAkuZtlhb18Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 11:52:58AM +0100, Lorenzo Stoakes wrote:
> On Thu, May 21, 2026 at 09:34:57PM +0300, Andy Shevchenko wrote:
> > On Thu, May 21, 2026 at 4:56 PM Lorenzo Stoakes <ljs@kernel.org> wrote:
> > > On Thu, May 21, 2026 at 12:16:00PM +0100, Lorenzo Stoakes wrote:
> > > > On Thu, May 21, 2026 at 11:06:57AM +0200, Thorsten Blum wrote:

...

> > > Unless a series can be put forwards that sensibly justifies this, not some
> > > random change somewhere, I'd rather we not take it.
> >
> > The problem is not only a compile time but more generic - the mess in
> > the Linux headers. People who want to use this match need to include
> > mm.h which is a bloated header with *tons* of unneeded dependencies
> > (for those pure users) and increases chaos in how the headers are
> > split.
> 
> No question the headers are a bit of a mess, and I've had absolute headaches
> with dependency chain stuff there.
> 
> > If we don't care about it, then provide an "INCLUDE EVERYTHING" header
> 
> That's a false dichotomy - the series isn't upstreamable as-is. I've provided
> feedback that's not been addressed so we won't take it.
> 
> > and let the driver just include that. But of course, we don't do that,
> > we do modular headers for a reason. Currently I see no reason to have
> > that simple helper to be mm.h as its use is much wider in the cases
> > where the whole hell of mm.h is not needed.
> 
> We also don't want to have wildly divergent overly-specific individual headers,
> and series have to be upstreamable.

No objections on this.

> > So, the best course of actions I see now is leave mm people alone and
> > simply duplicate what we need in the headers we want to see
> > (util_macros.h as a rough approximation, but maybe something better).
> 
> I mean I feel engaging civilly and constructively with people who have taken
> their time out to provide feedback is a better approach, but obviously what you
> do elsewhere in the kernel is up to you.

Yes, but it's may be due to my blindness to see how the whole mm.h machinery
is useful for just simple macros that use PAGE_* ones beneath. I'm for whatever
(much) smaller and that has much lesser dependencies, so people can use it.

> > > Also vdso/page.h is a VDSO-specific header by MAINTAINERS, offset_in_page() is
> > > really an mm thing so that's another reason not to move it.
> > >
> > > (A justifying change would show actually build time/binary bloat/etc. numbers +
> > > involve actual substantive changes).
> 
> Overall this all feels like a storm in a teapot, this is a very trivial macro
> and the use case seems nebulous at best.

It might be more users found, if we start looking into that with tools like
coccinelle. But I don't know.

> A series actually addressing header issues with _a justifying reason provided_
> (I am astonished that it still hasn't!), would be more useful, as long as it was
> upstreamable and didn't cause other issues.

Sure, justifying reason (one of?) is a very baby step to clean up the header
dependency hell we have. I know that some people want the problem to be solved
once for all, but it's impossible to achieve (remember Ingo's 2000+ patch series).

> We in mm are friendly and accepting of good series, engaging positively will get
> a positive reception :)

I believe this is a standard for maintainers in the kernel independently on the
subsystem. But thanks for confirming!

-- 
With Best Regards,
Andy Shevchenko



