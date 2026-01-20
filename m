Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38971CA5FBD
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 17:47:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AFEE6B046B; Tue, 20 Jan 2026 12:47:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9464F6B0474; Tue, 20 Jan 2026 12:47:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 873526B0476; Tue, 20 Jan 2026 12:47:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7591F6B046B
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 12:47:50 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 41C5E1A0344
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:47:50 +0000 (UTC)
X-FDA: 84353075100.23.5004E91
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8B5EFC0013
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:47:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tjfohsLY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768931268; a=rsa-sha256;
	cv=none;
	b=sRTlV52YlnXP5RdPRGClXwwlAXT4SRLby5uz9EQIpncT8kDdZjrOXiP1GHTWvEW9NpJ4qc
	CI2ed0B3OFep6B/1szWzkkKhJ0zo0qP3LG80r2m8XqDIxCjjjxgLS7/947xsr6qSV0tQWy
	7aT0h7XnuIDz+kPaN1xLNZ+o2OxTrxo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tjfohsLY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768931268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=buh3AgwE6eEq11741pBPAo1tMuqYqSxOmLQ1xeWQiB0=;
	b=Up806Xfq36+mEUFjB6ykotXlMOTJzj7RS9VKrJJogy1fykXolMAHpm3X7n6K3B7L6ybCjl
	ODGWJ2p3x4RPhl4YYaN5gVRthL/SLobLofDKqWACPfHDSYfJu5W70mJQsw5G1aJhmmRdmu
	beuhA4lzrzwYj7mo49i5Fb8GrgMdS0Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C1C1443C3;
	Tue, 20 Jan 2026 17:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB3BC16AAE;
	Tue, 20 Jan 2026 17:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768931267;
	bh=kTyxrUC6CLXmKB4WiPhS98nLWRKe80cbQkubQV09cw4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tjfohsLY2n3lhzlLuIaem06nUrkrYK25Vsr8jtE1qJtX1GFAV1ahjAEdbWd4kV6pQ
	 IF1iIU9wRnJoD6xq4YBNabtMvcGIWI8oaps0JECB6JdQ2JalO0BfrnxJTAzt1O6ftU
	 5yinsTx7AGDH5VCtkADKuBuBkQYlyCvZBQe8egdKsBvUznDBTiWs14r/ysOETfQAKG
	 4glBF1fE23o83O9JW2VRy/mI8fL/8DkWMZoZUbizml8OvJv6FP6PMgE/lLAEOXSFxa
	 S9FEeTEMvOHgtci1B/GHxiYzxIVfGNR1yk5YttjkuKi3lMwirEfn/UmS9zxRxrLDut
	 6ivA7ZI8oihdw==
Date: Tue, 20 Jan 2026 17:47:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Have the harness run each test category
 separately
Message-ID: <aaa9cdf2-8fd9-4073-8c5e-f4ae3762a1bb@sirena.org.uk>
References: <20260120-selftests-mm-run-suites-separately-v1-1-a4334f0cbb3a@kernel.org>
 <20260120092252.8597a496ed1cdebe5e120fb6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="QDSOccJa/e7tiZgO"
Content-Disposition: inline
In-Reply-To: <20260120092252.8597a496ed1cdebe5e120fb6@linux-foundation.org>
X-Cookie: Slippery when wet.
X-Rspam-User: 
X-Stat-Signature: 8pq3kmp5jo6q4wkf589q5s567qgqjf9s
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8B5EFC0013
X-HE-Tag: 1768931268-463700
X-HE-Meta: U2FsdGVkX1/gxPAuwKdV88Zc7iBoTmJeTrMnf/GuR1LPiHgST6GhIJtW3XzA0PirTv85tUbuRji5PtDj0KQ7yq9Jcme7kZZ9bj3kcxqdramwYiPK67+XA4fqatjSoFJOxYgOPmmOXv/i4wQUM2b6f4GxBiuU+zX3VTSfh2OewmmRj16u7gzRXGPzjOBGzj4+nWcygJw/feJO1VEL5rZ0Et2NxgrlgvKHaBC4Ux5zdUtPKyPMSvV/Q4UHxPJ2+XkRRMIrIluxu//fyUCczvYJRZtsL2NSGnxMA6qu/bFDKfQCkhbJNlNZD08uOVpp+sCPwF5a3xFHVcOwoBOllfalEJBycmbuK+ZfZkgeaO3hL3hNmvpiKTg2kOF5JJ4f39DZAkpwhXnwFV51agTsmkmr1tV7rgUBqVl02v/nCd9K4wJRquvOpH7yYgCgZublJfGuSW1q99Z52xZtiU2UptUOl3gygdWsyC1hkTiyqFfiDf0Edk5lddSvUwxRhnDW+wMmcVf+qZ2LsXaWl96I3FCgicwrJVFSyoLQ/LJr0OzYO7hBbBuSXSMXV1anIu+i0dU7Cp6U9C9chhNAeulzyKk8ifJWS1n/H066lnuW966nhgLMiMbQsPraENXKdc5K9GnQ77qsZx7gUZTS3XtEu+O1tU/Bb1L6488c55L5nJtwxlCpo2uMZnBoMnmPrXShs4GebviT/loSwM9b91axFqjsmvbaC4ojCzCPgScNkzg2wE+Kmpr6K/NggMjUV2B4OPw2oHTsYGhWTv9x9P3o/75A9Elu8T6bQ8sPfAnqr48HcXKcxBl6HL51QUygH9TiNaCpTsqjhkqPswXAxg/mP30r2nRgb9oHVKUFUgNsoRKe/TAAAgg0nFcZCGWm2Nggp8O+sTEEe9aoAPPVgvT2eKf+xfmMmW6GvNxZN61inhAj/STPDeFOqvCMzlua0lTpPj4FtJa+ULOkuLlm6yX3sTY
 M+0ZT68P
 hrT3Q3pDy9ELSNobpIRPtY0/IprZlDrmVByTv0y864BUanfzURF1z7I3gicbsCS87r8LzRK2CJRACHltrCOaeElMBQj15RIgHIUa/wDKpU2fdx/kTo7IzVrwnwojXgIQgLWDi1fGCnrwasc5ncb+JUd68K54pyGiCnVMeStcU+ZZ/M6uE6F4V9LIPq+Uj7OfEN79XKdn3zai3F4tsWGZ/eS/H9H56NxHroQNA1HQIVqjEv6KHt2UGaAVh8O1koHURsFRbWwbPXlWnTf7kR1dKPVgV3LKPuVNFnVc/gXEneLCbqAsMNcHkbi0IEOLXlTXxRDPxCQbD+heqEN5wVkhBBz3xxURvcn/y3TvPN14S1WZOPuU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--QDSOccJa/e7tiZgO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 20, 2026 at 09:22:52AM -0800, Andrew Morton wrote:
> On Tue, 20 Jan 2026 13:25:32 +0000 Mark Brown <broonie@kernel.org> wrote:

> > has separately.  Since kselftest really wants to run test programs this
> > is done by providing a trivial wrapper script for each categorty that
> > invokes run_vmtest.sh, this is not a thing of great elegence but it is
> > clear and simple.  Since run_vmtests.sh is doing runtime support
> > detection, scenario enumeration and setup for many of the tests we can't
> > consistently tell the framework about the individual test programs.

> Thanks, let's see what people think.

> What happens with tests which are newly added but which don't integrate
> into this new framework?  eg,
> https://lkml.kernel.org/r/20260120123239.909882-2-linmiaohe@huawei.com

Anything adding a new category will just not get run by the kselftest
harness until someone adds a wrapper script for them, they'll still get
run if someone invokes run_vmtest.sh with no arguments directly.  As the
changelog says it's not particularly nice, but hopefully people don't
add new categories all that often.

--QDSOccJa/e7tiZgO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmlvv70ACgkQJNaLcl1U
h9AngQf9G3Ze83SF/F3V1fpJUOzG1cp7X3rxRdHXAD3jPIkkxrcJBCsPUCQ6ezUM
5ZpepjtIZTHUbOT+PP6W+2TDPgctkyjvPjhsHpzP2Sp6zX6jQsL8xK6oHf8uFyDu
mQldN1NgIN1UyG51gK9fuIK33+6U9s4q5f2ZW8cHaK9G4waMJ8syYWzaX1lUL694
8aUZUaKUyadQHoOfII3lpsTgSqQa21DhoAvOhm9oPuQ2aw0oCFlaH0wi216JJuhg
oM8qQ0sWPHjfV2focUPtnCa2sBjv9ZExJZUgvXYdfi9HKHVyYRcENjE9UCDJVa6p
9T6VXv0OEPvmur6nlJC1UbW5ak0BeQ==
=ABcn
-----END PGP SIGNATURE-----

--QDSOccJa/e7tiZgO--

