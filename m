Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62E86CA5FA5
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 12:34:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DC716B008C; Mon, 28 Sep 2026 08:34:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B4366B0092; Mon, 28 Sep 2026 08:34:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C96C6B0093; Mon, 28 Sep 2026 08:34:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3FE026B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:34:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CDAC7C01A7
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:34:24 +0000 (UTC)
X-FDA: 85263114048.04.BF36104
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4452040007
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:34:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dSxO6JyX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790598863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=02NkiLZ5Yl+geke3aOQBTOObyOxc3CSY0KX9P536iK4=;
	b=wwh9Hr3ISdMH3wKZ99KefRPRgK4IpZQjUY9h3k1KXFXX0rbtBUO6Aj6rL+YhiqJ6+FthWA
	aWj9HRa4SqCBBrtPciDcj5JTh/h0D7p+XmVPGbzbAoZ8jSVi+GoJvc2kauLsB3hCi3tAcm
	5KUlBWE6GzO/jEirSEfjFqqOh0EkT0I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dSxO6JyX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790598863;
	b=InjT2xaSDZVzTfK/UG4BZTtU0swkkD6BXvS72su0bBaX44ASBuBY01ckcLoVc/NiJaa68M
	TDPXrU6sGPbUA5loLn8fdNU0SPIPqgTJR0V7uOW0FUKUPcHOeb7aBs6Z7Ffh9T5s6u5+/N
	BUbtLelfOM2DhXfGPuVy+ms/TR3OZQc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 89B9E600CB;
	Mon, 28 Sep 2026 12:34:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A6C1F000FF;
	Mon, 28 Sep 2026 12:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790598862;
	bh=02NkiLZ5Yl+geke3aOQBTOObyOxc3CSY0KX9P536iK4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dSxO6JyX9ewpqfSZ/qGL9qzm8jbvHsqhuYPo3dHyEMWQIhnJRvY4ShNwHpBRw8pSz
	 QjOrySNheii0BYuwVrEomHYqkBDbKkeaoIWCP8ah0gX3atVajPT2xkVEVcZY7Y0Thw
	 ydxzxmzbW7ZW8Sb/il6objzy+0mVgWCFdyhKlPlrKRMN1roMU/dVLpOfd7dtszs4LG
	 PDxgQ8MiHla7CtLkxhFA0LdMtP/2amF0J+4RQfh/pR6vyqfug4SAYn51aE/5hzI81h
	 X2hlYP7jETKF2ZNFVOQzpwKatli1h6ubPjMncCvFsBI+CN9UZRN3I5B3oxCvAwRHMU
	 hWoPWx07CR9lg==
Date: Mon, 28 Sep 2026 13:34:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: linux-mm@kvack.org, liam@infradead.org, rbm@suse.com,
	akpm@linux-foundation.org, luto@amacapital.net,
	brendan.jackman@linux.dev, david@kernel.org, liuhangbin@gmail.com,
	corbet@lwn.net, kees@kernel.org, ljs@kernel.org, mhocko@suse.com,
	rppt@kernel.org, shuah@kernel.org, surenb@google.com,
	vbabka@kernel.org, wad@chromium.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-um@lists.infradead.org,
	geert@linux-m68k.org, daniel@thingy.jp
Subject: Re: [PATCH v3 3/3] selftests/nommu: add nommu mmap and mremap
 behavior tests
Message-ID: <1b2fb12b-a342-4ec5-ad24-14fc761e1e61@sirena.org.uk>
References: <20260926010819.604346-1-thehajime@gmail.com>
 <20260926010819.604346-4-thehajime@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="FUgMlfZGbL2nwwkW"
Content-Disposition: inline
In-Reply-To: <20260926010819.604346-4-thehajime@gmail.com>
X-Cookie: All is fear in love and war.
X-Stat-Signature: y3hhyu89r3wd77iowtjor97bfjujgnci
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4452040007
X-HE-Tag: 1790598863-571374
X-HE-Meta: U2FsdGVkX199mRtLCHlNSbTlhvdzj8AZgERXIb+ShEevmLxYiMoim9jCCdhPGoXVyTwqqXf0BkI0CFR33HYtf0FxPF7QoI/MW/Mc3H2iax3T4zB9Yp/lHN7fucK38mgLFpLq89QB3BKUVcDzWRKGKiLP7kZIt8NnIuBu3HOBUGm06gF5CTwGFQCNtQINU3XEoRfGKZTaaCqVWgyluj9eiSQ3nrCyAInuoFmIMxj3o934riRBF0u9/w0rsX/IFqwAEIxsRxIxc08O52iz9tbaYO8Y1pMcqnQTe+5fvkIqmXh2c03fODD+jaqeQNtrJf1rVjiyCyRNhzg/0Mj2arHic+zpPzcyxbLUk4F6GHT+t+p0+v3C5cm1a5AFntqFjLO1bOgNkD/5mMZ87gD5VAR/1Ycq2Q60ClYW5Bd8FxTKGMXIRvpef5mTLdHrfTKLw1rZr9SW0SxZvtIItv8m/dDaOUkj2+cX9kFnlAx0qzv8fO7aAnbasLSbvhygJQQswTJUB0yWIiML4Ad4dtEc1+5siWyvTP3WYpcR5KkWTkljaGMikWWmLXFDu+liFGu6aYoR80nZPsvFnrMrOHV9swg449Ka+CYBWP+ehOGzU5ysSnaKXR17zQzrtUSvBs0gX+9nuTzkU0PSfX4zPxacovyyoWraPd6G+CeXmIwjNOvNYKZbPOgA69/tH8xp5DheoT7jhoQ4Q6iW+Qj54PiZkwZwyBNnw2RN70dlpVREulOHy81qPdh1MSht66Mz5qsgyLtBfDh/D/HnwJRMJaR1Ltw4Hez2CRkmFryBTZ3QZKSfzLGXP0/T2+aepQM47NjXVgi5iX5Dag5K7Y8S+rn+MZ7MVvb0CEwiNvFOqZ6440H6yDg2kC1ScWxbLx59uH5UTMeASHLPdOeAEnX3bKhjm8NthedGnAj2Xz+OFHCuZwxSmFj+nV6wEefCOnjlD8OS2j1b4l/F/yLFRHB3lBZRil5
 DJVdqgmA
 7YcaBDnEz9krRpVLXmQHQ5YHNUsN1NxMztiC5CWSBbjvIWF3LUb5mwgNq1NHeYhCij2lKbsDsaKZvonIND3/77hzCELzkTGocEyKG2DKwbvDLJMkLpq7mPF4DTAJkQ2sH+I6L0ipFMQfWyvZW3NE7wcQ06V2MECDzncBrAmx5+2TrVaNH5LyRnMKYy5LsobrPZvctkZr2VvUMZKJ6LEHP+byhJxcBcBgKci0mucnqTrErvurkDTf8ROU5J9j7FSozjySBXzs3LaksYP8JfGs7uiQ8Kv082BoT3UW8I84PqomMxkvSSSqV0omD1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--FUgMlfZGbL2nwwkW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 26, 2026 at 10:08:19AM +0900, Hajime Tazaki wrote:
> Introduce a kselftest utility to validate memory mapping capabilities
> under nommu kernels, aligned with
> Documentation/admin-guide/mm/nommu-mmap.rst.

> +static int run_mapping_matrix_test(struct test_case_t *tcase)
> +{
> +	int fd;
> +	void *ptr;
> +	char path_buf[PATH_MAX];
> +	const char *path = tcase->pathname;
> +	int rc = KSFT_PASS;
> +	int expected_error;
> +
> +	ksft_print_msg("[RUN] Testing: %s\n", tcase->name);

> +		if (fd < 0) {
> +			ksft_test_result_skip("Failed to setup temp node: %s\n",
> +					      tcase->pathname);

Your test reports should use a consistant string when reporting the
result for a given test, that way tooling can tie results together
between different runs.  Report the diagnostic information with a
separate print.

> +	if (result == KSFT_PASS)
> +		ksft_finished();
> +
> +	ksft_exit_fail();
> +}

Just unconditionally call ksft_finshed(), it will check the counts of
reported tests and exit with an appropriate error code - you don't need
to manually collate the results in your test code.

--FUgMlfZGbL2nwwkW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmq6XsYACgkQJNaLcl1U
h9DH+gf/XjlR+SgNi0hEPMZzdbbYcwqMMLD2xh8C2BKF4e664nTRvVFTUQ4QNNVC
wWPQ+F7q4l0/ZvxPMtcHzH9cNRXNYfVC00Twjn4/rKB06CdAlnug1n1Segzf4nSe
IW0YuguI4jeea+cNPiiG1pXEdH0xhEzS9KQZSByPqg/J10wYT5mki6T952vWEh5s
6uf0QrxiIl8j7gE7buHHahG02LdSNZB9URNdEL7GaPsIN8R3IPLcWE+nvazafr0H
f8k6hg7IRx+gOZ8r60kURDhpP6i8oE6zd/YIp3hqnGLvUEHG7Yl0XY7krzjWpAgI
ylmZrCLJWgbyW+oCgK7db4EHIr7tPg==
=LEi+
-----END PGP SIGNATURE-----

--FUgMlfZGbL2nwwkW--

