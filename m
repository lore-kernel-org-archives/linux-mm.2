Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA7B4FEEF25
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 12:21:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1FFB6B00A7; Tue,  7 Apr 2026 08:21:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD0916B00A9; Tue,  7 Apr 2026 08:21:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBF836B00AA; Tue,  7 Apr 2026 08:21:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B65F06B00A7
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:21:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5E85DC27B2
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:21:00 +0000 (UTC)
X-FDA: 84631669080.21.5F2B5F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id A0909100005
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:20:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sgthcIfl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775564458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o3kLDSVfNpzT6BVW4UKA7/dPjmbkTacLj84V/Z/kQ7U=;
	b=uCj3MCZCZHISJm9nU2x8TaHaLPLDMTWPMzs7Vwhbut2QfIwAAj7eYmwGdXKrKSlaj4lZrS
	iAkkFO0yO890JpgARxDWRuI+dOmEfhcMKiiWs9jLayM2vbsQC0G0tUhKO64+MttaJ/OHKs
	UWdecyyWt3emXUS7ZwK5V+x9SdrzETE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775564458; a=rsa-sha256;
	cv=none;
	b=7csOqf1T+Kxu8vBbhUHqeJgJNFmCQazOBq3pVHNEIcWWefZxGZJKr1huojC6IhJ8PlarWF
	99JYODLlg90XkpsjMVcsY5wbedmKvxP/9GxsX317R++7c5QHFmFzWFkiahNHYghRNzGlFy
	GgfpHHiqT7mE4wSYA58ccvlFAzqqq+E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sgthcIfl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A0CA4443CE;
	Tue,  7 Apr 2026 12:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADC1C116C6;
	Tue,  7 Apr 2026 12:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775564457;
	bh=o3kLDSVfNpzT6BVW4UKA7/dPjmbkTacLj84V/Z/kQ7U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sgthcIfllHzi3NJKHdLCW0ISo7LLxmRs/fYUErgOpg9O6p2VuFW66UyxLLs57RhOO
	 wkbCVzgnH8NLFKC234/Y7IBHpfM9mmPVzqZZc3/dbv8HY3yFJliezDGpFIp63+P+Ut
	 C0uCX593zwzGGd2E4XQFFm2xCWjK/2Hh4GCspiexg7wTZIVaBLg2lNoquADL6W0vOV
	 bs1A4fvRqOHXavJSXkoymxxazdzFmT3Ihvl4rVWwzE9fX5/tsM4HW5t053tb1zjgRn
	 hqvIMGloYSOrSjdmO09J/wkeis5AHGgLwyh7lfj9oa+raswHQO+lkc06MkjvW32Dd/
	 7K/AeiuOGNXGg==
Date: Tue, 7 Apr 2026 13:20:50 +0100
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
Subject: Re: [PATCH 00/53]  selftests/mm: make MM selftests more CI friendly
Message-ID: <94f6d6d0-148d-4760-9e8b-1bcb4684bd81@sirena.org.uk>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="t0LR/773YTDwCZqz"
Content-Disposition: inline
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
X-Cookie: Now, let's SEND OUT for QUICHE!!
X-Rspamd-Queue-Id: A0909100005
X-Stat-Signature: idkhgobfy9fq8sjgcm14bgihzb7bjsni
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775564458-920643
X-HE-Meta: U2FsdGVkX1+NvfLDaI61p6UhEGmHTZB/yZrvNq6iVbq1dBLib1L5OzpsqCnuDIpXiMNJmFrb3oM0GWahZSm2NfBioMiFntLl6g6HXK9jMH3bqdhxGrhyf16l+3+smtw29/qD5NjVhZeu18oeqdt88weyPx040a+kji1/tduTEbYAX8+K1tQB4oR+ILiF8yCnK9QzNZVzuz6hvVLvG/aXMj0WqtazBU/YXWOXk9BoN6IGYpTTLbkeaOYGXZuyYiG6qfA4qQnb3ofO0g+Z0/TdAkcGP2bwppoOzqcn3i3uAeA7CMKbQEJ0tmUasaZDDiQAEBnnh68EAzW3heDIjksrHS2CuIix3d/dviDAJuiQ1YIeuHeCP2zB4ToSz2dMnJdkduQrI/Osxdj+RCfALbmSxLC7tTAk3vy4fu3QAydA2VmOeQWvFbIfzF65SmtMmmO3QQHzhUGAAhUvjhggnGdvYt4S6d8FFHTWJ659fkvdKo2dpgust/lyCnwfNFdjtWmKC+b//dN+AFcYZrbIRIbW+gVTYOTOa7Imdy5ukfK0lL9Dhmpz36K7MKQTdWGK/wAVIuvV6mcSWomdAgPHbx77V+xHD9fU+wXCNdV8gamIXEDQY8SqwFJWJ/hjKJcSFpUkcSSg+W8kYYj1SNChf5yisUTwVVfgOxCYG5ESgbniL/2vG1hwvkWK4xodRBUBSzyweoCAlTMbhf0P4FGJ+f0xorVXnNawCYO5eCOWSS7oVeVSpK8y3CB4LMg4Htv3P+3CLaQWC4VYssc87w7/OQHRAOTS46AHM3yJokH68m8mjEmSWFSyX7jDAa8t5x1b0iJjRS5oPFX60BdPlWPCwvI7vIh+YSbzgt+P347x3/eXH+HI5lA4x9ewveX/EJfL+LnERwHGnsO8MpuUi//3JVRsMaCBLY7AiAPe0+Ri56fJiEJp1BAz0CmBnnHhRuc+MW8UHNT1aRswHqa7fa/OiET
 0idMFgry
 HEPh0sikrwwwBvLejGHePo3m6hpM2ei9i2xPriiojC3Wcel/Wsmg2V3DuntMoDt6JDrJcV2puJBJ/96Mz/LL1XKfI3YT3iYFCm943rNk6GvkOFckAAs+7Xwv3v40h75Vbmjd43ESCp4Qv2vdfvqkdvZvtuzNNx1T+BPwd78xNgfs2CY76cUKGQQ7qY4cUjrVMevbFnxD/KB418R6liYr07UD5V1cu59WNNm8yBhuH3sSDuJbs9/VxvJ8hiIBcghMCruqAbf5f1+7t7Y+qgFXawqTkC5Jz7ewJBh34JJb/Jsmkqw+LfWbao7YcXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--t0LR/773YTDwCZqz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 06, 2026 at 05:16:42PM +0300, Mike Rapoport wrote:

> I don't mean for this set to land in 7.1-rc1, except perhaps the small fixes in
> the beginning of the series (patches 1-4).

It might be useful to get some of the conversion to kselftest stuff in
earlier as well, if only to make things a bit more digestable.

--t0LR/773YTDwCZqz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnU9qEACgkQJNaLcl1U
h9Di1Qf/TeRvBsDh7XTWAMsdbCRsin4+48rk/wKPGrV0+VtMmpSv6t6DyPGtU1+l
N9XKZD0V6+tdZj6uNk2JrSWXXSAHvZeNO+bHUWJLVrqZ7nJrfOUE/+Ez8PH5bjnE
XdrARxyG5s1p/aYAIu5FCXxzwk1FI+mmN8PDxa5BmSzIsaScVMnWcE+LKCI54f6z
6mZn7+HCCvqxjj965QlOQ3WlRkICWCuj01V0Iii92uOGUR6MJ6ME6S3swwYVnFTP
aV1XLdY1X6qcEF+9dv32HzfmamYA/jul13/vVyFZpvO+0bIRD8iMOhYO9z3hVesM
RnZqbJN+gJaXBeSK1k1TcBrLvuSpuw==
=xtd4
-----END PGP SIGNATURE-----

--t0LR/773YTDwCZqz--

