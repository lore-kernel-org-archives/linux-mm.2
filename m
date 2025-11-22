Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10137CFD307
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 22:16:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4168C6B0010; Sat, 22 Nov 2025 17:16:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EDC96B0023; Sat, 22 Nov 2025 17:16:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32AE46B0024; Sat, 22 Nov 2025 17:16:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 220526B0010
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 17:16:19 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B3FBB13BF41
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:16:18 +0000 (UTC)
X-FDA: 84139652436.07.F6D8AE1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0A590180004
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:16:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="aP/XIbRp";
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763849777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BvzfunR3ZaR9+UrbzhrKTxulXV8xFtq1RNEqpKvJ4bs=;
	b=4qzIEmoOyRwy1Z7Q81uTr9qEYiQlR9n7CXnmZ86BU8OLHE53hmmlMiIo2uPPxVpv270w9P
	ufvxa2hRlBeRhKToopNr0HbpPNPcQ2clRsJ8GBM+bQBCKuMG0L+mHIPGyrn7LPn9wAAelD
	5kp1MAInHFJKW+BIJqX8h2ceEGHTTPA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="aP/XIbRp";
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763849777; a=rsa-sha256;
	cv=none;
	b=xmLCA5R3EX/H1DzQCpcFzN+I9MSoVgdR3a/8R/iqTnXjuikMkpmnapgHMeB0cMjiumWkCz
	trmxVorBAlf9PfCH5GFNC2FrT9ztbXy1Ok4a6ylVNQMbeGXmyUIh2k0/ELRI+7Zb5JUJQ6
	G1/3ucV5dppe5sfsVVYGVTWmZNrPzN8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3653460154;
	Sat, 22 Nov 2025 22:16:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC8BC4CEF5;
	Sat, 22 Nov 2025 22:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763849775;
	bh=oJdmGsiGca/DIx/SjiqaVDSIgtR8inCTav2QsrGYsnI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aP/XIbRpSAXDDN74W5EaeT79d59eTeWrpONNYbuJxY47A6IOURTJuJDS/lcOqDMFJ
	 kLmg01OK1IHPznETCSTp6gTrZCInPoI9U3cnZCndSAEGo9eB/CuHQmvOeNt67yrPrZ
	 ty04hbqr2KmmVv3VlLRbNS6ArXo29SI61ReubVpA=
Date: Sat, 22 Nov 2025 14:16:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <kees@kernel.org>
Cc: Bill Wendling <morbo@google.com>, linux-kernel@vger.kernel.org,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, Nathan Chancellor
 <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Justin Stitt <justinstitt@google.com>, Miguel Ojeda <ojeda@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Heiko Carstens <hca@linux.ibm.com>,
 Marc Herbert <Marc.Herbert@linux.intel.com>, Uros Bizjak
 <ubizjak@gmail.com>, Tejun Heo <tj@kernel.org>, Jeff Xu
 <jeffxu@chromium.org>, Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Thomas =?ISO-8859-1?Q?Wei=DFschuh?=
 <thomas.weissschuh@linutronix.de>, John Stultz <jstultz@google.com>,
 Christian Brauner <brauner@kernel.org>, Randy Dunlap
 <rdunlap@infradead.org>, Brian Gerst <brgerst@gmail.com>, Masahiro Yamada
 <masahiroy@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org, linux-hardening@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH 2/2] memblock: annotate struct memblock_type with
 __counted_by_ptr
Message-Id: <20251122141614.80f1a845cd694b1b470107ca@linux-foundation.org>
In-Reply-To: <202511211525.05CB7E1AEC@keescook>
References: <20251121193957.1655580-1-morbo@google.com>
	<20251121193957.1655580-3-morbo@google.com>
	<202511211525.05CB7E1AEC@keescook>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0A590180004
X-Stat-Signature: 5b6s8o4q4a11uiywnzcaa1d6zns693ri
X-Rspam-User: 
X-HE-Tag: 1763849776-515318
X-HE-Meta: U2FsdGVkX1+YJ9ITaRHx7LBHPFV7/oav8Zl50wIrVl8s0fNrWFFd1DefUegpDgI/OjiKm/Pm2ByyrMe8nnQO+w8hRGiS2ngbEwz+7KKtWYqEOqwQUqUNw/ITEy0bfEzHmY02il1M4a4uuq+IrdJ7a/9TS9q0jfsIyCp0TmZNH5vsaSmeS05yVBuJoBXf+ISK5GypP+/NXwAbPuD1rOEAMy9ekqbleFMjJLflv9TA4yx6EIlC13U00BoQIm103YcmkiVKN006og0fXchUCPR2Lpuxx4JGfbsR7v41LZGLYN5U+3wv+drU2+E5r/q6+WV6zQ5cdpU9HWeVigTPUFWf/Qsf9lGqCNzECKbIpoXL1KiCEBYcu5BVw2i5kKPsI/y3LxBjiDm9L4btqQ6S9PNg7QBDoYmbs8kzlwptDKRXy0wYhuAE3w0+e8WoT2z8tG/hQ8KqObd78gTCvQ6D0Wu/PBWw37g7SZgiBhDCy9NjsV6wNwNQzWK3hWZ86FnAVksMEyVqIvfNm0i49a8+MHHwxLYPOxAbX6H+LSCEtlmzpShqGwz7rwdjp1wHyQx6/ZSxP4mMsZXYInIK+oXHIN9oD/5oEURUOj+nhmotYFjAar0xqMgfW4Y9H6TUZeYej0buMtWslOf4S7StqejjVZ4/y8dsffU3uc+JAb2FNoPAYR6KJANPbGO12qaLK6i+uN5lPerp+ILnrujSY6w8icgYcVQF5qrHE8CrA5zq+xLkdSPkFIEcF3ZmbEIs62JUja9brIHtWwOVEAQP/8BXBmeg6i3mEXGZ1coLTUldFROJQdMmG8++CCThqQcwJuYXg0l9YTZMwzAcdYiHKUJOL/u9Qsg068Uh+qaUx//0mzBMquTb7d9u0AyhXCf7cEsQtoGsSyEKiBiLhhc/9UJgVDYwfCeXMvJz5bkGQfptge3SJr+mPiz3Yb0rdNDaQ5Zm9z9YEyI5pAoflUDWjkPu/PZ
 R0zyqB9E
 +10PMJ3OxV0PCXEOnuFnmrlXvizV2BCZxMVzb2LnOEGsRC/pRHkg4hIQIVpcFmFUCqCdCxQgaRbgEBDpJZKIk74mcHaA+ImctVZdErkWj1FcifRSAlce6swIxZk53n5DxR4AA+IcZEdhXDukStkwpO9WQ4YGBRZXSd4p+VezAtqWSoyU2lOmhzQRN1Es7e5/bQF27imMSBWsdn8Yd7RHI0wZYl7V5LfKSMGk6prMDHJsGxfymTWmo9k98bS1CzALTL6mc3QPcidi1FZerSUCuQxaZlonyrdIoGkdlFu9mS+38KeJGs74Y87D1G0PIuwz33EDUdGUmQAuZOGeGvidVwAb252m6Fw5nK0GAHPH71hqm1vlXI5ExYVq+AhEmrvdbZPL20S6MAkHiLXM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 21 Nov 2025 16:30:43 -0800 Kees Cook <kees@kernel.org> wrote:

> On Fri, Nov 21, 2025 at 07:39:44PM +0000, Bill Wendling wrote:
> > Add the '__counted_by_ptr' attribute to the 'regions' field of 'struct
> > memblock_type'. The 'regions' field is an array of 'struct
> > memblock_region' and its size is tracked by the 'max' field, which
> > represents the total number of allocated regions.
> 
> As part of any counted_by annotation patch, there needs to be discussion
> in the commit log about how it's been shown to be a safe annotation
> to make. e.g. in this case, if all allocations of "regions" have a
> corresponding "max" assignment, etc. If just "git grep" can't find them
> all, using something like Coccinelle or CodeQL to search for struct
> memblock_type::regions assignments can work.

How is anyone to know these things?  I can't find anything about this
in include/ or Documentation/ or in the relevant commits.

There should be a comment at the __counted_by() definition site, please.

And possibly write a Documentation/ file then change checkpatch to
direct people to that file if they add a counted_by?



