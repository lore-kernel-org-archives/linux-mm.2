Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C661AD2168D
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 15:04:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 272F36B0007; Thu,  4 Dec 2025 10:04:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 223836B00AA; Thu,  4 Dec 2025 10:04:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13B106B00B0; Thu,  4 Dec 2025 10:04:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 028056B0007
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:04:37 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AAB1B87CD4
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:36 +0000 (UTC)
X-FDA: 84182110152.01.AE5A57A
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 96481120012
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=V74cBwbg;
	spf=pass (imf29.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764860674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2DDwYlN2TdolRTMzvF0ERtGgzkk3rvSJWuGnqVeCtdA=;
	b=7wJcy313TIkMYz3jwkxf/6Rh3/8eUPZ5TuHTDO/dMnXkjDtlxVeRLJ8EHTTWlNOrTWGTlG
	fqGPnC80pKJiKYuuhDdIQqyGPvmTwgjOal/BBL2VqaKBMjb3EIil+gPgg6is/yTebEW2CQ
	R4qVVoNMou5rJGD/fHxPesBbCo/mf40=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764860674; a=rsa-sha256;
	cv=none;
	b=JiB5JeBT+yM5jZ6/pTA/Q7YvL2E00QZDWWjv8GeonqOXSVE/8ZTapy5KVsYvTIFZLcIXdA
	nKOquRofmanhlr9DxcnjSLJBltbWWj0FuyNiXn6XHGWgl+xvPtZe4KAaRdRe/UwBnd/WsP
	4seueKrKAEMVb7/FFa/ZYvQU0SC8Bwc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=V74cBwbg;
	spf=pass (imf29.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-477a219db05so7648335e9.2
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 07:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764860673; x=1765465473; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2DDwYlN2TdolRTMzvF0ERtGgzkk3rvSJWuGnqVeCtdA=;
        b=V74cBwbgOqWAddD3NZXDi4Io6fFEzYOZ4zl4nTwGdCjd7O4FXDwjBrLVifbplXVIUp
         1194Ti0HBVeqFGuklj0ekXFkHzGaXWrXwmBrhUs8iHVTcQrYfMV4HdbDWE9nQHs5gq+a
         bVl8mW77bRHjJClFySPqcuy3II28zWQdLYPIRP/nOEK+LZFxldBUmnYBqi+++fqowKIY
         WvRj+wtRns26tooysQPtw0FAMtxWAJTbzlmRa3fKfGlxRktW99zpgbxYPar0QjeMo79D
         EDYbHd3WRCXB6HplGOrUD6zPDr8qu8UObbnzsC6CRO0pni8vC4kguAHexBx9vZYe0WAB
         6VWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764860673; x=1765465473;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2DDwYlN2TdolRTMzvF0ERtGgzkk3rvSJWuGnqVeCtdA=;
        b=Ttc8xWSH1xdmxGj52BJS1s2KM8oNMM6yEMf6V3Ewrak0rUsW4ACwq1bKrkUMSuZ679
         hqXcDCPCQQx2js4t4+YngR5+yvhIP6M2fBnv6PNUF6Aou+FYs6pcM7fRIEWfDlAWmLft
         8voHsHmAUUPhCoFMQfYleJkokxWwLgi6bqn5ZZs6ALOJS9l9xe73UjUG2pFQm+EuJVsd
         QPFORJvdaJ922BsGajULY2Q+2G20Wo/J8jFxYA5RV4+rS+6sGyqk3YzZPMv7XxCGHb58
         T5hSwWS6zZ8yJr2LROHnQPjShV2iZbKk5rHAmtSVqP25ffIGqEZKMsIp3UwBCF/Krub0
         XbyA==
X-Forwarded-Encrypted: i=1; AJvYcCUrkN4u8ZNyRp+4Qb27BFizNbDoWhrFakJoLiHq2yD59nV71ZhcVI9Fb2SU4m9uuHZxzVw9YXDTFg==@kvack.org
X-Gm-Message-State: AOJu0Yzp9/6RBn80ke1pgxdoCRJ1RcjTqIbbk+Z31njLWV4rQ/Yu+cz6
	QnGM89+ZddvQop/HLZfVUQFQ921yx8dOGWRDvPiQWqWeBkEVYwiG1bWYcnyooUB9kgEaWKi8mWM
	J2CWn
X-Gm-Gg: ASbGnctuf4OfFjyTZhaAInl8XjKWmm8qExtNzrjZZOGpPszcvBAsGKpxuhAgqkBGBrQ
	QSzsyGdpk3cYrEYACglFQav4hn84lyP5bx+SqseG2wUdn4a8lp7FGRbPgl23UqChHhS2G28S/z0
	upcrczfHNcrD+RR8Yr38z0KzLRR8u0bmBQnThwH7E660c0zZM+Udk8oD+sLQvTRFxv2JGHWkaHz
	8jCHaYIOtp6Rn8Y904gLsbxCSQPBs1Os2RwYHpIoMeI+pOQ6nyETDf9ovrg9j2v0+8vLeCH1JPz
	Z6DCS95Dyn57oAHpUkVdlkPVa93TwWPfOw82UO3aT6gkhPJGwC8HTK7bfaxTR2w0/lmXrLCWdHA
	EwiPS9i88yAA+L+8p6/hI7wpk5fCsSkHDNXolthPculou66HQSpHy8oYyHG9G/9abD+rceBYzPY
	fqp23xB7nEGyM9bZQdvKYvxT8TPeX2Mko=
X-Google-Smtp-Source: AGHT+IH2NIlz/wz6Kqufkv//L8zRMTY07VdB0gJrxPl/jBzW9+fRPbrtuIwMHrwY/OcmxIGtd7X+Tg==
X-Received: by 2002:a05:600c:3b1f:b0:477:8a2a:123e with SMTP id 5b1f17b1804b1-4792af4046fmr57480815e9.33.1764860673050;
        Thu, 04 Dec 2025 07:04:33 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792b02e7fbsm39364055e9.2.2025.12.04.07.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 07:04:32 -0800 (PST)
Date: Thu, 4 Dec 2025 16:04:30 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Guopeng Zhang <zhangguopeng@kylinos.cn>
Cc: tj@kernel.org, hannes@cmpxchg.org, shuah@kernel.org, 
	roman.gushchin@linux.dev, lance.yang@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/3] selftests: cgroup: Add cg_read_key_long_poll() to
 poll a cgroup key with retries
Message-ID: <jp3gp3qbbqmq7nbn5i7qbsgxj3vwquibsxubvvkhc37p3pcc2m@24bljtuw6diy>
References: <20251203115631.947908-1-zhangguopeng@kylinos.cn>
 <20251203115631.947908-2-zhangguopeng@kylinos.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="alsebtq3iwjlaxr2"
Content-Disposition: inline
In-Reply-To: <20251203115631.947908-2-zhangguopeng@kylinos.cn>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 96481120012
X-Stat-Signature: cxuoq4q4uqjwqdz9e5bgkomtes665wsm
X-Rspam-User: 
X-HE-Tag: 1764860674-617191
X-HE-Meta: U2FsdGVkX19TGH0fgboupe3xP93Mzw9OKhfFbYmv/+Tq7wufOXeRzn9CPjaJcs2U9x+4IDZ/2GdKz1H6cqpHMDYRtCQ2vaFajS7BSuUEWjlHGDYCnWY9RU7LS/0IX/sPYW3NZcX6RLHI9dv3jKBT0ikNK/8ySb0Nrw2rApdoay+BmFHyisp9LmYvZL1lcn8TIDqVJO9YHM5Kj5Ewz0dyAtT8YO/T3LKzLX/lsXyv04DybsYVbOihUY9zfv3QjUVAo0g5rmsmioQNgfzn7UeBHeLMvHaupClHaNl8RzvgbqMpAo8YnjnFvodSqY3Y8t89OXeHc0M9sXJ0L0s2qgCVI9PUmrM4diE+NMOK1mzwyH8MJOrwB1I5Uy9jXbuRzFlskLFcS1cMvBNOZBspihcgIaqquUPlafqGkmKgVP3/bBnGS5MMuHWmMOTI2j7RtUUcyTogiOI1BCbINarp0bnez5pZr3RWz28Eib6jr5TMFRvSmqM6NHq8gyRqHLR1qRbMTP0cHlcmL4T3ZMzTfHNxjA4TevrFCRvGoUiioCl2u8HspglLnBqItvzHzlqGVQIgDtfRW2gw8mLZXlLYuJPMAP5OwAMEdYN0e7lXfR/lAvcUCzX8Nj9nRQw/Qf+vJ+36zQun24B6RRVB29I7MQ7SCs1fI67mpD5H63zlpzmnZMpsIn3qML78axwciL98oXC3/W3Um1XnabXiRzlIGgcg9TbKgZZxP2K+B2a+hUrN1yWFZ/RpfvBuPa7A9OqENTQ1psF5tdGTkprp4XwsqOA7HrUylZ1dQdMyzVnwMtAbj36NyHZ+dOn2fbQMGNXJb5sJ/VAawwYSCWlGcm4bpZj4zKRO9U0lU49lAHfGS0urVD1ew1OKuj8fNqZ/yosNhVqyqf31e1aOeZIWLiEVsCKqDviBA+0cB4oRc4ajv01vl/rnzcpE5rViyw44XVNM3LhEzO1z4Czfco0QU8wtqq6
 9FeHQ/x0
 c3Wjp1j0ElSHI+Zcpbe5GQVkd5HrlGE6orhBE1M+YWtc4oqLZNNwp+0Fn8LOikNz7nrstnOfMvfGtcB+kovWr9DMjnSSnW98a3BoSPMAYHMzbhtwzsZGj7XwvZbcIkCfuh923U6gZXFN/EcJcfyR8cj06yn71RWZx4cY4yOAkw0yJTGzMqjGEucBz3glaRlaWX3zdpSZnttGAOpba4BN5/0B+uAm738gjLLc6VoOc6i42hrAKaJENYSmW1PXS1dLUCkaKQFetENEzzaTAkCvS68ILRpF2u6uikDZ+P0yCaOmNc8zX3mMhNJ2cy3secCfwO7JbUG9ofEwcEaUT4rqL8bzIBRf338Jsknsz57LBJ1z7LCii45jTGcOhLo90L2lERQUUODzuASzAQ18zxd0E8VWRRwgK0GWTB9+4QZ/HcpzORrRltuNWZahomjVcN+6awSR3/mcp9S9mXRxQOgTLXfeapW501a1XKySXR/sFjqLV0h4+DO717aiWVcvP49aBFhKdpM2WNdxmYH3ap7WKlGknlHhxwGvToWItTdLk89pTLqCVUwz6nTAEPixQcNi1GtE7CDN91I47MtkhUU/yNKC0BYh2fRcbmKw/aDdbL5nsRT4aDZU1v8XjfUyo8Zb8BQNce8ohrl/2jXEtfT3tLVQoXw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--alsebtq3iwjlaxr2
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v5 1/3] selftests: cgroup: Add cg_read_key_long_poll() to
 poll a cgroup key with retries
MIME-Version: 1.0

On Wed, Dec 03, 2025 at 07:56:29PM +0800, Guopeng Zhang <zhangguopeng@kylin=
os.cn> wrote:
> Introduce a new helper function `cg_read_key_long_poll()` in
> cgroup_util.h. This function polls the specified key in a cgroup file
> until it matches the expected value or the retry limit is reached,
> with configurable wait intervals between retries.
>=20
> This helper is particularly useful for handling asynchronously updated
> cgroup statistics (e.g., memory.stat), where immediate reads may
> observe stale values, especially on busy systems. It allows tests and
> other utilities to handle such cases more flexibly.
>=20
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> Suggested-by: Michal Koutn=FD <mkoutny@suse.com>
> Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>  .../selftests/cgroup/lib/cgroup_util.c        | 21 +++++++++++++++++++
>  .../cgroup/lib/include/cgroup_util.h          |  5 +++++
>  2 files changed, 26 insertions(+)

Acked-by: Michal Koutn=FD <mkoutny@suse.com>

--alsebtq3iwjlaxr2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaTGi+xsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+AiVAQD9GDHbzq27fgmc8XyKGDiK
IgD/7BYZ1+cvN45rEc0/vzoBAMk4RTHxSBm6UOa0ZfWYb1vuWJwjUshDzUhrZvnV
/1oJ
=YEEX
-----END PGP SIGNATURE-----

--alsebtq3iwjlaxr2--

