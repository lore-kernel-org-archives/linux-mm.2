Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28390FEEF2E
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 12:58:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 753DE6B009F; Tue,  7 Apr 2026 08:58:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704F56B00A1; Tue,  7 Apr 2026 08:58:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F36A6B00A2; Tue,  7 Apr 2026 08:58:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4AD6D6B009F
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:58:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E2688BB23E
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:58:19 +0000 (UTC)
X-FDA: 84631763118.01.1586099
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4AC3E160008
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:58:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L7glko9a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775566698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dCzEs3qg0xnSM36RtrcEwzUDKBZJSI/6EEeAkBM9P4A=;
	b=B3ak9GpwG8MMrDb5GEHM8kc4j1OZGCztcYgVSNy9LthGG8riGK8WDf4zqjpguaVprIr3CG
	mLlZ0xUJ2HwAYzGz2vHos3o+fB05Iz0sgYjM46FPG0pQRHBDAseMGOIB2lTKylSYaxmt6L
	wW5NCB8tTN3Mqgkte0bqjyN3SMkWVlY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775566698; a=rsa-sha256;
	cv=none;
	b=DcAZcvMms2RjsOXZv53l4MgUvEt2KI1UdLOkdIWpzW7oPlwh0GHqRV3nHtv6VxVCMXcEDV
	Brcb+cyBeDNB53Wl7d+/+zpu2ZS0CbsEtTdW7hOaK2I8ph8kw4JVIA4P4ozUIjYDZ96ITQ
	uOAxKz8WEwGqeL8UMeLBFc2nKQQctEY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L7glko9a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B64DC600AC;
	Tue,  7 Apr 2026 12:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4B5C116C6;
	Tue,  7 Apr 2026 12:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775566697;
	bh=Vuo8khsjxbN2TIURS/5kdF2MhqjcznQQ2wx/2ImFzvc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L7glko9aAohDzvAn7OqsI+J4uDM2pUX3oJQTUL3L9iPAE8bEACZR/wFPmeVFnMSbR
	 97baR5iGmZbOiCGtwp8nv83FX75zrcNoDStHgR3YKejPU1hhULTn/8gUz0gaqBUFXf
	 d9DlHtCR92PKVmymj7Lalmk4VOklwWWA0vPnZ5QfoejbQtgFrkgp6vzG58rP3pO2iv
	 PujV58T2UXEcDOaNnxEz5BqGS7v/M2nGXYIuIQSsoMxlg3NG/+DX6Vnu4yWoJQc1ND
	 25dQvmkMmmNB6IBLiGbLmcpJ7zubOPGKE3d4aYcIxXt1efPbqcIevg79ncUIULDJt+
	 KNGlW5P3nPcfA==
Date: Tue, 7 Apr 2026 13:58:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 18/53] selftests/mm: uffd-unit-tests: use kselftest
 framework
Message-ID: <f07f4e35-227f-4dab-8e05-b6d20f38c60d@sirena.org.uk>
References: <20260406141735.2179309-1-rppt@kernel.org>
 <20260406141735.2179309-19-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ikVDHGOE2eekYHG+"
Content-Disposition: inline
In-Reply-To: <20260406141735.2179309-19-rppt@kernel.org>
X-Cookie: Now, let's SEND OUT for QUICHE!!
X-Rspamd-Queue-Id: 4AC3E160008
X-Stat-Signature: gqgxzrz3s4zgb5yoz3gqynztkcme9ffi
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775566698-850376
X-HE-Meta: U2FsdGVkX197TGJRwTLX5WqIODvtq1cldYB8/ZVxuFQqntSPZHBk13tTziFTxNyzGF4iHZGsvjeC100GD6tgPG40Y6H9NRP32nbGTa1WLqCZHH1VzCkc26gviDLH2uQcoU3IsKpQvoy43w+4gcROZM1tc0ecaWmjYhqb7vcEdLx7ymPXhuCvsEevU7IKUtscCWy4dmjHVVNOmmHpSZsWhykevFkL+KU0LK4kdVea4J5GZ4uZrWRSK6773OlzsE9jy9YezWKmyRd+FpBc8jriLv7YBZCKIIk8XSKGja0t2S0B4IWP4jZM5dC9hYnWrjCkDg33bvT5MyDRKwUUVjGMnstY6dZftEFN1V7nsBK/2gFJZEsVuCHRBmmSRIwfdUTmtq1AlVJvL3xDABTDXQZqNtgSChowzoPq1x/ETw8m/WEIDhzKceBt7BhQTBb7DS6OdpoeKZdKgZ05eb9XO8sUCic2+mzRII4d8c5GMLBNYVUm0LR5DO6zGaP3972UxBjnGTidvLYE33QJE+0Ja17/384gtmeFkLOvmPrxKGAlXQt9rmXFWGPqGTI7uHrezw4gUXQYmc69JgY5p6ezPZsfn4aTC2tmGm3zO8id2wqKlD+kjRbFWrR2ultCkguCFx4kElP7hYlOVc2faOqbCmbadhURax04WcsDDx4/l6KNqqa5DIrdh5xNAuzOPlSvfdfGKOEMqTIVFqveroph2iBO1E1C7VVdPlk9YFCc5Xuv/IzJsLu8hHN7yvPylV6jSkvWyRlSVX5fy5MpCq5dFOW4mpB1S8JiDenT77Vt9VJXmPE7iyJNyPIYKV4thjWdb2SCf9PFjklzIM4if0OMnhppc4FNh7rgSDSRl0vhxNB7sgNduPJLC1vE4DKiEzI1CfLKGFFPQ7fgikuv5HRSZYxZOI8CC+hmUweGFyFhaocENCEr4PVI4hxDLCoFJsM8EOd3jXeJJeBOth761H9BEk2
 R1CUIud+
 YZ4tq2uAs+4nrNhqBpvm9ATJdMRbAK467J8c/+mZ+2np66h3Xli1Sni1oiOWOedt57J5qao8gkPpvRBldASft5SwloaVzl4MIUVCHZfukWOjhfIFLPIKBUqjjB+B4EXkPHMX8aVgGfLPIfkEldGZvWBAMB+Gk4Zrq30R5Ywp61MBv+RnpXnW9MLtzpPu/BsfEOBXyGm6t6zy2wiwv6OnRRC2PMCFJm3YlzuVajcO+RTdPRKXEE4k9KkZQBuP7+e4dpouDdpoiHXpGTnt7464icZQBiZ+Kg+QUTWePURmvtw28KWtXRmORyCagSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--ikVDHGOE2eekYHG+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 06, 2026 at 05:17:00PM +0300, Mike Rapoport wrote:

>  static void uffd_test_skip(const char *message)
>  {
> -	printf("skipped [reason: %s]\n", message);
> -	ksft_inc_xskip_cnt();
> +	ksft_test_result_skip("%s (%s)\n", current_test, message);
>  }

Parsers are just going to take the entire line after the test as an
otherwise unstructured test name so get confused here.  The usual thing
is to print the reason as a separate print.

--ikVDHGOE2eekYHG+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnU/2EACgkQJNaLcl1U
h9AMTQf/Tjoyf2v7TI04cRn0gqsSlJNBuwtdBCBJwY8oUBwToDrVM1CY1f6Tr8t7
GWz1fwqJYEoES7UgyunaglPklV1xmSwIAJuLsvQmW32dWP1P2kfSpwHfxe1fvKqp
IzRu8dHdFV2BXcIHXttGfXJkQSG7YDu+WEnTkwt3T7mOb8ReEjz9n2Zr97uiN9pr
2lSYRVO+s2LTgff3qpjBU4UJ0J5Jt18E2vUJm8qI1iBbyHqdAsoPmazLI4EDXG6p
a2BLjsoTK2Gy6Rt6/5JcrUQNt1o/3RzyVbCgOrYRbkw+4O4sJOdn3psgY5ESZmKn
XoVkNn07wuBfDleIpCP8uGXD3NG8cQ==
=johM
-----END PGP SIGNATURE-----

--ikVDHGOE2eekYHG+--

