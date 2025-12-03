Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0802D12D6F
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 14:47:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B4F46B0024; Wed,  3 Dec 2025 09:47:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38CCA6B0026; Wed,  3 Dec 2025 09:47:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A2D46B0027; Wed,  3 Dec 2025 09:47:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 192D56B0024
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:47:55 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE93E59E5D
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 14:47:54 +0000 (UTC)
X-FDA: 84178439268.20.2FC2A03
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf08.hostedemail.com (Postfix) with ESMTP id 089AF16001A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 14:47:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LTWZ6UKJ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764773272; a=rsa-sha256;
	cv=none;
	b=J+9/qoeRjWf7EHGWIcLQnUpIGfPCje+bOi/Swgw8JDiEiqC9xwUXjKj9uSo5ZsPtStdD9I
	POqhFzHr4m3wVfGZljv5AK9I3M9kaGSwtMcNg1+s7315kTeY01Y0G3l5JDbCm1W6/mUVYH
	JIpno7z23aPTtG9tpk6sSD+dsc2QVNo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LTWZ6UKJ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of andriy.shevchenko@linux.intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=andriy.shevchenko@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764773272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6StyCEHWWaw9mVmmBkDn0h1dRsO6/C0HhUTT3ovsVbI=;
	b=V372/WOnS8YF1pheMkzVdApJkZwP1atxrVj3fp6E/qZNYOTq9XHN/EJ9H1qjX/K1hFnV3N
	/wt55IK4uYkRZ4ui1nDbvM91gv8l5cZrfXIj9KItFmnCc7qgjGFBw4SQTnBcsit6LJHPHH
	49/ecx/lEaejAz70YwZ8lC2ls4LMPIk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764773272; x=1796309272;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=ONLKaMVDzvuVK/VrJwxFR2Jg+soODJ+V+Md8LMMJBUU=;
  b=LTWZ6UKJFRbpCRcfWLjkRtaqbyPHWqy23J4AkO1+qM13WMeT7ZD7BYuE
   SIr57Y0XkcpEJ2QQn3AzGuxG8Km6zHoCi/Q5jhp0Gc5Cwx39SoXLagY7D
   M6AI1KdGZHIoEs+AgLyC2KF9BRdZLUFzemmmTsbvY/VflcdWrNg5GIyXf
   xD3dDr1HFOMPioG3cyL+yOERcyJa54yZVUiHNL25lUbu1zo0Nvr2bCXYI
   eI0BfE8gmrzZEzBvc0Maw/DDdSB+xcVlwsG8kAdP6p581S3gxxadP9hfj
   Q0XxNLCiUyODHm6QZSkxjN+5cvruIBTgxHoFCSNHOGr6x3IH+MMPWBHRB
   A==;
X-CSE-ConnectionGUID: UoSISKedR3eAhJNmf0hkPQ==
X-CSE-MsgGUID: qoMa1rd+S2yw5dkxM3nNeg==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="66654778"
X-IronPort-AV: E=Sophos;i="6.20,246,1758610800"; 
   d="scan'208";a="66654778"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 06:47:51 -0800
X-CSE-ConnectionGUID: U8l/okhdSQK3xKnNblGeaw==
X-CSE-MsgGUID: XhAC6MyXRxe1UNFYMc0CFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,246,1758610800"; 
   d="scan'208";a="194733512"
Received: from dhhellew-desk2.ger.corp.intel.com (HELO localhost) ([10.245.245.81])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 06:47:45 -0800
Date: Wed, 3 Dec 2025 16:47:43 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Hajda, Andrzej" <andrzej.hajda@intel.com>
Cc: Petr Mladek <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
	John Ogness <john.ogness@linutronix.de>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH v2 3/5] drivers/core: simplify variadic args handling
Message-ID: <aTBNj5HEfejyW5TK@smile.fi.intel.com>
References: <20251201-va_format_call-v2-0-2906f3093b60@intel.com>
 <20251201-va_format_call-v2-3-2906f3093b60@intel.com>
 <aS8K5DnumUA6XUs9@pathway.suse.cz>
 <94c02fb2-3407-4efc-a80f-305140e64b94@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <94c02fb2-3407-4efc-a80f-305140e64b94@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 089AF16001A
X-Stat-Signature: z5waz97xfubb88mwwufarsn9a6r4o8zk
X-Rspam-User: 
X-HE-Tag: 1764773271-43754
X-HE-Meta: U2FsdGVkX18DgB0aSaoOcLT+XUkouss+jz8/T5Xnd2vNn4FdD6iSqhQjRKqPYrYGpk2lNFnz09u9yxIYNMjpDB5n5C8DtJif4AzO9zaXVHohnQGeg1h3gCFvTIhTctM8DITBD6TkEnYFUcek/C7XQNU4n7DynOuNQCjdM5KR2xQQ+nO8q0qTaYsbZncOdmoHgL6sMoEEFG/vZyfGqznb8o6b3Q1H8Sx8PllQF4WLUzZMqwZghmCOBWl6IkDNxg0VM007vYiYVpoPidbT1iAAM/0LNBY9qDPVJKE4U3ERJ0fI5HzwqNRfLL3V1JjeWPRW9rJYiyKZ/GtSWURt1BZuCAx0malO6FQYVVZou3Oz3QWigy1znISmtaME35wfkKaNcJNRbfO9NT2ivOvkoK+eyIZhoJsQpiPqR3kEoQCqPr3cLzxiN26M/w+j4C10E3qSgpNG1G71L+tU8EimoC1Xxk4Zbl3nqQ0lCUYOf1ljIqPnc8J+/MWL0FVdBBFJt0FR9TTjNvlgEtDsQjsDXWbJOs1rgYVTAOX35kkPpbdiyZnNbaCpVfh13wGkkCnm1RF4OufjIZ22AezAYj/tNZ/l2lMbmWb9WTY5ZHWO/g7oPPZeUoBoHJLV3yqgZWiIkLDAv5pUlrfl9paatDjTQtUGRxn6q4yf6bb1zsJEaakmzFJDmk4VBMzDB4eFgxgr1fx/7YnMAaoBmN5nTE1QQ6LRNQ2ifGWZmWSZSx9DZpCqk4n1XLqtpJp6sL4HFLCF6YzarifgbUdUUx6X1dkGcMkY/24cLL5bhDkN1Bje0ISqhc9d98MJPn4IbfsktVNT+b5URsWrhfrypjde+nUQqNwB9E7fz7XC1hsxwl6ynGUfHryyRfRzfr3faC3rjQhSf6pqdq2MWSeiVtUZZYyGrPWnwV1JKmj6gJlsu9EpetrD6GUxi6G00jQALVCwUhn357OfSA0IPylVbSKZvwhtQIw
 J99G/nbl
 g2JtRdk4hKU6jOr/nUbfRHEYrifpRdHqA3SEd/XX3AELz1CtFhplJVsTEbqWAqPibwgvk4Bia8En+lt1+t7QjClcTNLnwFR/xBLApx7hgyv6qI/z8W/ORxEntmlxuYAWbzEXfZ8esq4djz9da41kG0kMeggDaflfi0dzQ2hZ0+Xoe6d7TOST7EupFIQ776YkwFOe5+oiLYzaD/1Z2yhQm6SHJv2qx/UtXj3bp7DgERU83AuxmqO10Z+djFDgoJ7/Ty0tdZSZ4QjlQJqAT7PKSGORRCwGl2kAFzgUaJSMKFZACJ2/Xvv6keBO6CQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 02, 2025 at 07:03:37PM +0100, Hajda, Andrzej wrote:
> W dniu 02.12.2025 o 16:51, Petr Mladek pisze:
> > I am adding Andy and Rasmus into Cc who are active vsprintf-related
> > code reviewers...
> > 
> > You might see the entire patchset at
> > https://lore.kernel.org/all/20251201-va_format_call-v2-0-2906f3093b60@intel.com/

TBH, I don't like the result. There are two problems with readability:

1) macro well hides the actual low-level call, hard to parse from its
parameters;

2) sometimes it has va_format_call(fmt, ..., fmt, ...) which is confusing.

Implementation is also doubtful (to me) as GCC extension. Can't it rather
return an error code and use something like do { } while (0) inside? OTOH,
may be this is not feasible in a clean way...

And what is the motivation? Just make less LoCs? I would really like to see
at least vmlinux sizes, the reports that GCC _and_ clang are both happy with
the compilation as of `make W=1` of this on both 32- and 64-bit cases.

Does it solve any issue? Does it bring any consistency or standardisation here?

> > On Mon 2025-12-01 10:31:24, Andrzej Hajda wrote:

...

> > > -	/*
> > > -	 * On x86_64 and possibly on other architectures, va_list is actually a
> > > -	 * size-1 array containing a structure.  As a result, function parameter
> > > -	 * vargsp decays from T[1] to T*, and &vargsp has type T** rather than
> > > -	 * T(*)[1], which is expected by its assignment to vaf.va below.
> > > -	 *
> > > -	 * One standard way to solve this mess is by creating a copy in a local
> > > -	 * variable of type va_list and then using a pointer to that local copy
> > > -	 * instead, which is the approach employed here.
> > > -	 */
> > > -	va_copy(vargs, vargsp);
> > > -
> > > -	vaf.fmt = fmt;
> > > -	vaf.va = &vargs;

> > I am always a bit lost when using this API.
> > Why is it safe to remove the va_copy() here, please?
> 
> Not very familiar with this workaround, just my thoughts about it.
> 
> It is just va_list is compiler's private implementation, which can be
> anything.
> 
> And if it happens to be T[1], it's type decays to T* if it is type of
> argument of the function.
> 
> So vargsp is in fact of type T*, and &vargs is of type T** and it does not
> point to va_list anymore.
> 
> So in short passing va_list to a function, which takes a pointer to the arg
> is problematic.
> 
> va_format_call DOES NOT pass va_list to a function, so it seems to be safe.

I'm sorry, I can't be helpful here, as I am not well familiar
with va_*() stuff. The idea is interesting, nevertheless, but
see above.

> > The va_format_call() uses va_start()/va_end() which is replacing
> > these calls in dev_err_probe() and dev_warn_probe().
> > 
> > It is possible that the original code was actually wrong because
> > it uses the same copy (&vaf) everywhere, see below.
> > 
> > >   	switch (err) {
> > >   	case -EPROBE_DEFER:
> > > -		device_set_deferred_probe_reason(dev, &vaf);
> > This function processes the arguments via:
> > 
> >    + device_set_deferred_probe_reason()
> >      + kasprintf()
> >        + va_start()/va_end()
> 
> This va_start/va_end is for var_args of kasprintf, not for &vaf, I hope
> parsing %pV uses va_copy.

Yes, it does call va_copy().

-- 
With Best Regards,
Andy Shevchenko



