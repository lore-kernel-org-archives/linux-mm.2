Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02F2CE95389
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 11:27:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0378C6B008A; Wed,  4 Feb 2026 06:27:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F27286B0092; Wed,  4 Feb 2026 06:27:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E26046B0093; Wed,  4 Feb 2026 06:27:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CC6716B008A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:27:05 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 303201A0100
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:27:05 +0000 (UTC)
X-FDA: 84406547610.02.7680FC8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 87C861C000E
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:27:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GqnineN8;
	spf=pass (imf18.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770204423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kCoU6BNleQMHoXGlBY0OGVR37jNBFRqIA1S2naG6W90=;
	b=evVLgYFwwC9L3ZFvBqrH8rqG3mD6rNZ2Rm1KqwJ+DcMlCOoFKhE2rpxt23KTXskWXoet4S
	bQZBwf7+4wgZc5Ks/ohTmK+H1jWEvkHwBC8WwehXNw2NV51ixIDSrqqxUc/9ETEPmfE/QD
	7nZPJcnR7s2R49zSr87D3yynnB1wyiA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GqnineN8;
	spf=pass (imf18.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770204423; a=rsa-sha256;
	cv=none;
	b=vj/1IN0v6OJReFK3X4Aa89M20AB9PRz0Xi54mhU11MtAGhrtgCYDqNVhCWtkZXrdKDYyb6
	kflcK6iQYS2zwavAiLsEHtqQzBXUBFVvqSG9yG0P6CxiiFSlLW8cPwA535qUmTfcdV8lZ8
	mko1rhE+9djQ08yy9FMczvQ7bea8sp8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D57C460010;
	Wed,  4 Feb 2026 11:27:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC00C4CEF7;
	Wed,  4 Feb 2026 11:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770204422;
	bh=67+xiOhUAy8ZHXdYxyV0ZxTN94Teb/rCt2o03FasqGU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GqnineN8A0U5/3483dusTDdxv5M41AfF1XwayjJyq75iO/hnIVQEsi/EJnLJfvV4B
	 ZtIJzMvcfzz6aPLrEKPFKQaEB9I2b4J+2rWJzzbyowNVEM7gacY9S9cazBWutVr7K3
	 eXdoYVdVy8c48r+9EUTTns6qvbJm5HANuc7OqYqGaQrObUXt7xB6a6tMnLGGdZKWOU
	 9KH+kNBKK3dQ2JE9Vq/bP2xOyTJRE8mBZLxL2Y55OnK/vArZR7w/IlUhlYcmHanAQg
	 ZN0w/QQaRgsxApteE8kndm5ZTaUq3yWYTBEjNcyG02Oqa9x3ZF+m+lD/5n0KzXZepm
	 8oDK8/oJt7Sng==
Date: Wed, 4 Feb 2026 11:26:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: akpm@linux-foundation.org, shuah@kernel.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	nao.horiguchi@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 1/3] selftests/mm: add memory failure anonymous page
 test
Message-ID: <2028f5e1-e032-4909-8240-15fe0b3c82a5@sirena.org.uk>
References: <20260204073331.899406-1-linmiaohe@huawei.com>
 <20260204073331.899406-2-linmiaohe@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="abbEY5s8WnurDw/O"
Content-Disposition: inline
In-Reply-To: <20260204073331.899406-2-linmiaohe@huawei.com>
X-Cookie: Are you having fun yet?
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 87C861C000E
X-Stat-Signature: 9qmdhbfwdkeipmtcwraa5bhmb6h1ted3
X-Rspam-User: 
X-HE-Tag: 1770204423-428990
X-HE-Meta: U2FsdGVkX1/C0X7QPb/MwicdWxBW/S7zfNEqWKdG+8+BQCUIwCqYJXhSn1PZyHTAR7qhdkcu1j4lgTR96pb2iJbv85Z80uFDgOsuZrfz0Ran2SgLOxqpwl+ZzME58D3STKJR+C8Jc0rxpiP0fiXfe7S8pdFlbSA0lvzFSHR/D464juHxAcssBFvc2Uw3XlK52djuUJF7Vp9bdgFlWtxQYlrqWEE/72fRZX8fXgi/b7UUJyF9noqku37JNUKKxr8tg/SmEP1+FpxaHvfOslCIQBORgyNi8kqSmfx2nO7lv1CszBq5xH2nFxQ9LAKhXwujFE6iJ0FJWrtmBoS3v9EruDZm3eoqMtgRXxCV1XdIjGbkHW+EVSaC3iS8z+KG9GuRD3G2ixo93eLng71O9v0RfM0fz6liZHGHPlVDfwEporSSqOXKwUTGQ35Sq9duqaSMDP3QvTcYLsTQtHvvKwdgx8C3EDWGNWxlttBkCBeDtwt2SWccilebnOmi5M6WOAIxQVOrdFUqhB98kt/Ssj4de2b0FzxPYpq8SSbpc5YPMYSLC2IvR4HlyDUxMUpSdwS7gN4UJiZiHyeZEeAPeKBWIUz8pNeiI2wl50bfCTwNy9rp8OWni/PItivZZXwSwX9C1QTTYZ9eclfxfVC/m4UZpJGN5U+humymbmQFG+b0A7wn5kEZRmCDXo5IqMJOvtPLQlFRtk1Uf+ItidBONWoUUaL0etPgr9SQo57u7ELWkadv6wz5Penunx9yUMrBHJKxnQeudV2a9bpNm9//jKUBi3Tq9PYY405LTMpJKbNZsVz3PK83RuYFpcw3PGGbWVXl8zH8NiVIEthBflqIuHTJKmNaip9nXq2i44ERfoa6doa8hY/LZZYb8Yof/D0zTsA8LK9FjllaWYjY9qOO9JxSs6Oa5Rqi5NIxnKdpchXJhMTzlKdwxoQkzC9oK8mcFwU9IZ+gBHgCUkE/2PWBt/r
 ZtLE1qhS
 fNGRrtoKWLqFxmesds69CDfSMU0T0iyMeVXilsmx6LwGPWrgn3zij2FDamG8WRFjRpFbSei7m1naMKX0pFklloUHq5do4f4Xd4ioFrlYiPXjT+Kp3bVs9m8yag9EMryiuSsgFtCJlcS8jtQOD/4o1Rtcvg79x7G2h/ZYuRtg6iuPb9pWILxFtsVDeUJykAcf80ax5yreYYbRsPKcVXQu6JTTtVFY8HYImX7reAo221oyKKnPG0fU1J/2gXLczIX9p9SobLaR0Ae6NOUl5dMv9E3HlTssdcCyTAempwCfBtLCb2QNF/+LHaJL5FGgjk7IJFnmOIGqUmzlQl+pn/OWi3LBrCdsCleyhLRx/7l3hTy+eOMGTAIqjQki7eOaZiI6kT6Wp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--abbEY5s8WnurDw/O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 04, 2026 at 03:33:29PM +0800, Miaohe Lin wrote:

> +TEST_HARNESS_MAIN
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index 29be9038bfb0..afdcfd0d7cef 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -91,6 +91,8 @@ separated by spaces:
>  	test VMA merge cases behave as expected
>  - rmap
>  	test rmap behaves as expected
> +- memory-failure
> +	test memory-failure behaves as expected

In -next I added a hack with wrapper scripts per category to improve the
integration of the mm selftests with the kselftest framework, could you
please wire things up into that, see:

  6ce964c02f1c (selftests/mm: have the harness run each test category separately)

for details.  It's rather dumb and simple but gets the job done.

--abbEY5s8WnurDw/O
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmDLQAACgkQJNaLcl1U
h9Djpgf+PbySdJPMTJ001ksm8zd44+zqROSj/FgWNpwp8wtHVquGpsqIVpo0rIVN
4CdxpVHlKfsSbq468aJ4PLYruyVwdyzpId9R3RZjaFs4ISEidAE4jAvZajoHKBLU
Bk1RStR2Myefw46L0Zow4K8d6vTV/8RHRvfjQxLSN7T6FOJXFhMAbVX1O2nCst6R
6pqU/YtDBnErDWP0G8jaSM8eKmQwfzW/X9OR4oJnYD2tsUFuyVH69Sq3vrL3ZUUE
AGLo9lhqlRO1zkod5MfLNNigq3idf97jgKFPHU+8f3XzKyzypk6XrNpPFNQRCdaG
rBRMukNS95sCTkzUyFtvTI6h1FJKfQ==
=m9hf
-----END PGP SIGNATURE-----

--abbEY5s8WnurDw/O--

