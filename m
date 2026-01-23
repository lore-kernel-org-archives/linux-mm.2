Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F01C6D6CFD1
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 12:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 444C06B04BD; Fri, 23 Jan 2026 07:35:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 402826B04BE; Fri, 23 Jan 2026 07:35:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F19C6B04BF; Fri, 23 Jan 2026 07:35:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1BE226B04BD
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 07:35:15 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DF4FF139D61
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 12:35:14 +0000 (UTC)
X-FDA: 84363173748.23.1B1F62B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 50C1418000A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 12:35:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fjkcs5dm;
	spf=pass (imf24.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769171713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fbdBoFrshhwhQwU+kNui3YMy8AiMuVDGypFhDxaoLlU=;
	b=LhfZ/3aog2rUNX8WMNsseL5bB66HvtoJH0iJIEDXrZ7KSwHgBw3Pd23O4erTGjLoP1o1ui
	wXDJx/SakxCZuskhS9OtAWu8XWFkJTH+ta5F9eSmN+IdsXOPxdn/aQSzpiqmiEYWibJsDa
	Zp9yM/qhCpjLPPIBVLAyYAbwgCHKygs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fjkcs5dm;
	spf=pass (imf24.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769171713; a=rsa-sha256;
	cv=none;
	b=7ldEEYDD2xMhgNxj4ZEE7JfI47XTgMyj/4ddLYtzB8XaZv5fqhPGdPk6UULFNAWZnEmGW9
	swSlC8X1YcV+m0gt1ND+59kp+ervZWSodsQPq6DsxZfBxmyMUcVZ2/dcVabdVjpbgjAF37
	w/9oFwJoxrwkNqlZ11Mf5MtGVXSPHuM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 08FD0435A4;
	Fri, 23 Jan 2026 12:35:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F10C19423;
	Fri, 23 Jan 2026 12:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769171711;
	bh=Y0RUWLkH/P5b3HJWSokvO8jdgqHAxHs/mzXdH8gbm2w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fjkcs5dmq7GFL5PDSx0R7qRgmXWUsqdKC34r+wLQLZaDjzsZJIRuwTeKmkeGzD6bV
	 llBbuEB/LKA8HIRCxb7QzD+LwUmWuP2LVag2WIcTpBBWkURJIIQ1pqXkHMvCrkbWfy
	 u30Xy92fCCq97PV1ElaWQFKoZwWXsROHHbLBp2NBHBU+df/XRT/9vEMcnJAPaant9Z
	 pahAYDZqYOPCTK1AnQijJVQcVEvLHRizwXAK2FkmOZYWbaZtfWUpO8CsWdaTdxmO7m
	 7UOe9uLUCf+QFm7DT2uBN2B+gLWRWoEo7g+eX1Hs/HK8eRgYWRafbDwV1vjMXg/dbk
	 fogiSRZ91D8Mw==
Date: Fri, 23 Jan 2026 12:35:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Have the harness run each test category
 separately
Message-ID: <56e2d214-fe48-48b0-88a2-287294520cb4@sirena.org.uk>
References: <20260120-selftests-mm-run-suites-separately-v1-1-a4334f0cbb3a@kernel.org>
 <897e1bf9-d29d-45da-926f-0c28558f8990@lucifer.local>
 <99b95c45-7bd5-4fc8-892a-cf9c69335706@sirena.org.uk>
 <04fc8a05-245a-4422-9e27-704ae2d2894a@lucifer.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Y3LPgYbgI7DEAkHz"
Content-Disposition: inline
In-Reply-To: <04fc8a05-245a-4422-9e27-704ae2d2894a@lucifer.local>
X-Cookie: HAIR TONICS, please!!
X-Stat-Signature: q9dnss1buw9srneij8fzgcbzf4a5ch7a
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 50C1418000A
X-HE-Tag: 1769171713-342672
X-HE-Meta: U2FsdGVkX18aZ268trlZRqyU/ZsF69Su5HE7T0InMYj7aYREWE/3WJ6HxyLNsvUbgi3sggIEEa0YWDeafP2qoe9pLpCqfOD8KzSZKEEJTGQkUAWggzKo038ChsN1fLKl+40OK+1OMny+JSAWqPcsCCb0ZTnUgmgFLOQvnzzfvfU1rfZ43SF1jRHHyLQ7t87X+2+dR4M0i3nRDKcJDrKQGReDyWlqjMdn6vw9lMtMrSptVlg6mCydJsoy54C/goDRdKCHqz4Oek0/K9LcSYEmyLIsDibn6UjD9S9SkSvd5E7uF9uyipdlhMIlRwo/kbD56dYMfP+h/vSdLkeSrb//bvWm0rinaRN5/wt3XuAZz/46MxoQ+wdwm80T+SVjvk+G+ICHJZwMcHrvoVq0XL+gjthBY8huywHfMzu8lMScrN2hFBZVLT4Z1yGe7LuPkV5ZfKM8T213gQgEBu43hmWZo5Cqxl7m/g0N07Z6HVvRGHW0WITfWW5R5zjOCGvhofzIGZdM6DA3AJCWiUJ85mvCvdEQXJpSFJFLq71opVH3nq36Xj5JYQBQsnfJeUQYzPKGl3AzzZuwiXL/unRrLVVGXrkpAU0GRJ9CR88fn3kKXp9CVsyZSwAtrKmjFvVjxXRrFoMzW6UiCj6rEz14L1A8x7T12Ksuc4u8vJD/bMZe4zRAp8UHh7MK45QweqrkswTS7alKWWhqBvnRwps3TZwKCKjJPTxnRz5RFgbBI0TDua0c35mpBchXTr2BeqOqNn3ItYCYVCdYZNPtJjECsTx1upFId1Ehq/j8ch7E4+3PFt3Gr74NUIib0mlITECNHIcLlNKpaoeNLmnOrkiW7ziYnuo7WEs3qw/o5apRBFeW7AbcvaG24AzVyb7LozE63QcnpHaaHnXnOpr/8AAtMg+LXnBRc6HbzwmrkVQt11fdk5arAr4XxAZOyW9sBbRPlvCaBzaRcNrT2wo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--Y3LPgYbgI7DEAkHz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 23, 2026 at 12:09:52PM +0000, Lorenzo Stoakes wrote:
> On Fri, Jan 23, 2026 at 11:21:39AM +0000, Mark Brown wrote:
> > On Thu, Jan 22, 2026 at 07:13:06PM +0000, Lorenzo Stoakes wrote:

> > > # IMPORTANT: If you add a new test CATEGORY please add a simple wrapp=
er
> > > # script so kunit knows to run it, and add it to the list below.
> > > # If you do not YOUR TESTS WILL NOT RUN IN THE CI.

> > Is the Makefile the place for that or run_vmtests.sh?  You don't need to
> > edit the Makefile to add a category.

> As I said, you have to edit the Make file to _add a new test_.

> The point being you will necessarily see this. It'd be fairly odd to add =
a new
> category without adding a new test.

You do, but adding the category is actually done in run_vmtests.sh and I
can see someone doing something like adding the test to the Makefile to
build the test while still developing it, then going back and hooking it=20
up to run_vmtests.sh when they're satisfied that things work and
deciding at that point that it doesn't fit with any of the existing
categories.

> And since you'd need to update the Makefile, putting this comment at the =
top of
> the file immediately next to where you have to put it makes sense.

I guess.  At the top of the Makefile or right next to where you have to
add the tests?  There's about 50 lines of setup at the top of the
Makefile before you get to all the TEST_GEN_FILES.

> > > > +TEST_PROGS +=3D ksft_vmalloc.sh

> > > Is this something that only kunit will interpret, or will it impact t=
he
> > > build in any other way?

> > KUnit isn't involved here?  This is just how you specify which programs
> > are run by kselftest, this is a Makefile in the kselftest framework.

> s/kunit/kselftest/.

> I use the mm selftests locally by running sudo ./run_vmtests.sh directly.=
 So I
> don't know how TEST_GEN_PROGS interacts with anything else.

If you're not invoking any of the kselftest infrastructure it's not
going to do anything, nothing execept make looks at the Makefile.  When
you do a build it'll result in the specified binary being built (and
installed if you ask for that) but not otherwise interacted with by the
generic framework.  See:

   https://docs.kernel.org/dev-tools/kselftest.html

for the various variables that the build system has for suite Makefiles.

--Y3LPgYbgI7DEAkHz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmlzavkACgkQJNaLcl1U
h9AJqwf/XS13Yx64IWDW4Hcgo/ro9qk0S/cUYSWCjBV39IKoIWwZUTMGgW7RTyhO
GIoeTrdDasHzOUsbQlHXEn3ChdwjVIgVoHxYFj5iDajZNZMmFiCJK6p1CP/y5coQ
mIyyr35LszVL6VsV0uFeL5byyzo/jTP3zi9KyarxdFi8zqQus5x9TqMOposdQzhC
vFKCcZ2Fzg3DG/REUPfLhkw61fcdCbjIkGTsBElznV4NDauyfzfXy8jfUIL6tNva
I2RZ6ghueb5AA4JcFQFzI4q6TvM9MIxG3YxLUQBc8vt+m1PLq53aSfokuKFARcw2
LAWQs9o+tqrI82RsjS0A1Dbzs3vdSA==
=3TvK
-----END PGP SIGNATURE-----

--Y3LPgYbgI7DEAkHz--

