Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24D51D72347
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:19:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CF176B0434; Fri, 23 Jan 2026 03:19:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A6D76B0436; Fri, 23 Jan 2026 03:19:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DCD56B0437; Fri, 23 Jan 2026 03:19:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A94B6B0434
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:19:01 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D0251384CC
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:19:01 +0000 (UTC)
X-FDA: 84362528082.02.402F63B
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5792D140004
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:18:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=XgSZ+KHW;
	spf=none (imf09.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769156339;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gyOf4Vs38CnQQkdPfkNXajZzz23yi3NyTlLdhTK6YlE=;
	b=Yi7dJn6eBG60lxN5hiFtNCeyQPQUZRyC4BNu00GhA+rO6M+Cfh+iRuFrKV2LJHeLLwMegW
	JqjwZ5ktricM9I5OYdTRTNoNBds5d8abUVwuYklN6Yw4yiG2uV6xx15A3bWNnvFhwXO6CM
	fFdlpP/qLOzG2ENa47DXDgXNj2BmYV4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=XgSZ+KHW;
	spf=none (imf09.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769156339; a=rsa-sha256;
	cv=none;
	b=T6kXhx+aXiV0WYt/BYUum+eUjcZNyjsz+XS04xVfDPm/MISL5yEGkSOKYJOEnK2AybvfWy
	ZYaamXN7E+rKIw7qrUSO/Ni9hlNynqwV9sQPzAIxVtq4A7GCNftUo1+z1Md0zy4FmCPU6t
	yMSndkd602JEvl+fSxksMmbjvPr1ULc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gyOf4Vs38CnQQkdPfkNXajZzz23yi3NyTlLdhTK6YlE=; b=XgSZ+KHWw9am7bLdjQkvQgFi9G
	h230R9Tyf03Gx17xy5ULbM879iC16/8ecRhrN/+egahUgXJZa2H1S2vZYG/+jWWKjhl+BtEejHcn8
	TfWC8/oHVJujnSRPCbLb+RA4r+awBKijkDqifBMcKyuxam/TTvy1TpQ7ITjQZmEcCcxd9UNQpUOm+
	3RP0sDPKrmnDcUHimhunWh8EaGrrQiouH8I19OLojGE89Qt8IM1y/055Yf2kYL+beqliFZzi1yMxb
	ABOoK1pP6TltVqnik6RyL3iMClaSM4ScJY0YSF0J5cLyPGIhjYz8qJHfcA1knK5K/wxIo0y41Cx/H
	DO4w+p4g==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1vjCP5-0000000HSa0-3imk;
	Fri, 23 Jan 2026 08:20:27 +0000
Date: Fri, 23 Jan 2026 08:20:27 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vincent Mailhol <mailhol@kernel.org>, Philip Li <philip.li@intel.com>,
	Chris Li <sparse@chrisli.org>,
	David Laight <david.laight.linux@gmail.com>,
	kernel test robot <lkp@intel.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org, Yury Norov <yury.norov@gmail.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Kees Cook <keescook@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH next 11/14] bit: Strengthen compile-time tests in
 GENMASK() and BIT()
Message-ID: <20260123082027.GJ3183987@ZenIV>
References: <20260121145731.3623-12-david.laight.linux@gmail.com>
 <202601221237.soiAkwkN-lkp@intel.com>
 <20260122103337.26473d1c@pumpkin>
 <aXIzpC6wpdv47cSH@smile.fi.intel.com>
 <aXLOELiIG8MHKcIO@rli9-mobl>
 <b49c9993-7676-4d33-a2d6-9f6b77b0fd34@kernel.org>
 <aXMtJ_JurQjvN4tU@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXMtJ_JurQjvN4tU@smile.fi.intel.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5792D140004
X-Stat-Signature: j7u86y53ras6u71boif7kxur18gukjk9
X-Rspam-User: 
X-HE-Tag: 1769156339-969358
X-HE-Meta: U2FsdGVkX1+U+UlXuwiH5di+zqvpWbTOIt4Q+/K4P6Lhe347+sCi4nN82SDnRMSo1DywFnIGzGO9QGshKTX+sgVEeJJYtCRY4ei/w/Ted9uQjE+lBfHVPFkXZsmK18yXGxhRJ5R3Wjr6EP4WT7to8RdsajAlwLu4DComjAHLDoYu/Vwp7JDJuQ97XUGzPLahaYQPoNUSo2vk5aPJZ0ZdYN+8iU3tMecehZbo2zOSAdq1QmUYeu4rPyDzQ3j673otquG6ssc8oV1SiaWG8r1i2tRqJPfwqllXMaVyQGeCwdy6qNShwx291o9JiTEll5NYCW0Rhd59jfkZab1qXoszIX43MOpGRtBngyiQJWPPuO9EFqZ8T52f3OzomOV8s+3Njp/DK3HS54/24S8MnSYk2KfzagCSvY8yTm57x6efMCqo3LqAjG2oe66/hMBpx1fqLN0EF16iggxQmQAy9apKXUbSVoXVNUTRe0JNgHzt4Yl8QMCxg81PdjlkjrCJrexAGl+0aH+vIiajEnoCTxMBncCyX653vsx3l4WtlBdUzpReusUInN4pwJHukjaABSo4fr+JZLlllfhzVX6WAJlifRa70Mt4zVDb4OxG7pJihPglAGool0/2eigPitq7e1U52gxf4QyTXO2fI3qLNp/kB8t2SdNRLYk83hXTkKde2e9nQ+EahBasS2jo08sX3q768KtnDae81sYAbsmrlKxwbAIdJ2ISB6nJLdYlxWcjFeHZp1oIr6XX+aOacWBcWAuIx0Wdoh+A1wiPvHEpqNaa69MgT/dGwXdZze7ZQGW1e36OQ4Rc/IB8NXCQ3ntYb5iDQfs/TsjPdOoImcT+lu+oCET/fTkR2WSeubVkIFoW9Mbekp22msM4Q5gP+eeQ+CULiSTWLupGvYw2v1uKwM54tuY2H80SZxiK79WZNCWqHG2Q3udan4kFmbWO40QSryhE5Q/WxK3WpGdQ85xyU9x
 l71MlvOX
 okn9O+u8QeQGc5J68m5FhFi8h1OAoMppAgsiJRkJehDJ4fBGwIlUj21OWTuhnP92CGGgarfbVxv4nlIni5Ragvi0HYGtY7ImzboxdxnmVpS5zabQVi+KU3RK7VkL2EclSo8+tvNVtpQwGwMWhY7CqNtbfJdAuO6mhVmUHOlAur29aUAkhP/iw2OzZnsvQcKwIB4Oh39QaEv5fc+W2bL3Hxs6Uvg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 10:11:19AM +0200, Andy Shevchenko wrote:

> > Al Viro's fork just adds 8 commit on top of the upstream sparse repo.
> > Wouldn't it be possible to just merge those?
> 
> Ideally yes, but you also should kick the distro's asses to update it, and
> the sparse should bump its version...
> 
> > That would be much less confusing.
> 
> Seems Al become a sparse maintainer de facto :-)

Huh?  What happened to Chris?  FWIW, I do have some followups to that series
sitting locally; need to get that finished (mostly for proper __VA_OPT__
handling; that got stalled on the lovely corner cases where the interplay
with side effects of macro expansion is really nasty - gcc and clang do
not agree and gcc is arguably buggy) and posted.

I've done quite a bit of sparse work over the years, but I would rather
prefer somebody else as overall maintainer, TYVM...

