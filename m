Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E175E6748D
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 09:48:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09C136B0088; Mon, 22 Dec 2025 04:48:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0887C6B0089; Mon, 22 Dec 2025 04:48:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB5906B008A; Mon, 22 Dec 2025 04:48:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DBAB46B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 04:48:37 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7213DBC9DF
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 09:48:37 +0000 (UTC)
X-FDA: 84246632274.18.14B07A5
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7E7F44000A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 09:48:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fSaOSyuz;
	spf=pass (imf04.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766396915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cpp2j64eyQIDdIrB75XVaxQv4OqlhELwCC5ZDUyvq6Q=;
	b=Mwi8DHRiZXvqd+yxkgQUYafREu8ZkXgiga/z208TJjhUttRGGliFmR+CvfkRi5si8QOX59
	L/ve8APjM0ACR8z7aO+mQvyMuqAebtJtyNJYK0WFPASIwePdU0pgte2jDoSyk+CApa4bZR
	JGpi/PnTcsCo8ysiiY91zpvPc92zFCk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fSaOSyuz;
	spf=pass (imf04.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766396915; a=rsa-sha256;
	cv=none;
	b=5KGRZVSi6dMo1NSd0V5LVmSnBmlRNVN3DWIPw/jnywA/nakEx016la+ouFPzskHFPkxnJx
	vID0Az41zjS5wJ3M/fKT20bJVpyucRlW/LTdOtf7wrNhvhp/0J/BnPrvuob6dtucXQ5xry
	DHy8/oBvzYmaFKbTm79rooXzIGn5iCw=
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-47bdbc90dcaso24728555e9.1
        for <linux-mm@kvack.org>; Mon, 22 Dec 2025 01:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766396914; x=1767001714; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cpp2j64eyQIDdIrB75XVaxQv4OqlhELwCC5ZDUyvq6Q=;
        b=fSaOSyuz3sZOsHucToMTSNEM56a/rMw4jJK2REw9bO/1Epg5Zs57HvkzrfvTf19qDl
         x5tDVPj36LFE+GojvPD2o8vRUgCZDZ3IbN5eRB6IexunutKRQLoB704aE75BCVXwOg3h
         LtlRt84TTrQkPL7jQqL8S6563mqzKHcyt4jquyyN8NZQqdJaKS8iQmuehgH2VtcWoPWB
         Om3nWO0T+30n+2ZOhwFENbTFy9ZTxzxXnzNGjGlAN8efWT0QVcOe9mTNEfKTnuwVGWbT
         4TncBRvgnm6DIBP2Ed6imPyC71C1+i9dbo4b7df5NHRCsbLBhDr4nT6AvQPcAcpRsxzB
         8nXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766396914; x=1767001714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Cpp2j64eyQIDdIrB75XVaxQv4OqlhELwCC5ZDUyvq6Q=;
        b=epAkpmB2AttR23WWM6sOSV3qCEmyItSSSBSDuTRNHNVf/csTslqtofwmNJ1AuXIPgd
         ncK2QWT6i1jYGZRq7lNyS1TeciP+AZCwLKeYprVuUBFTfw96tSyYG3bef/ZpbMOrBDoG
         ok5+NMBv9ZtVLFOd03npVb6WLUTVX5gdCYuS65bHAFHkCqpBLGLawu4JDpuzA9DR4cuq
         2sOBVaBZ3xT2zPTRH7Ib0bCXlHNnMmvnKjSFpusn/GpjoGd/RBFw2WpAiF3NCK1CcFWx
         /koQ80Ptbf6RJ26cJ9IQt8t3oSa6IefyRLV6kwTlpygnOFOLyx2XWLZtQ5tA9aQk4k12
         R7mg==
X-Forwarded-Encrypted: i=1; AJvYcCVhIblaFTLc6oOXXRywx4Xe0Ccgx/KJhsrmjrAxyLh7jegv8scXKn+TjTipRAphhe4ET0G1AGdCjQ==@kvack.org
X-Gm-Message-State: AOJu0Yw2Zd4RYyLgLPt6+oYQTwnqgIaKdNDZyCRpEy0EvJ8zM8UN5Ugk
	0CdLU9VwSo2vMeixJHjA7M9caAenT7GFCx9IGGWX/V3OPMIC1cwjqSJt
X-Gm-Gg: AY/fxX4DOeFo/l8kBAwLhw1gmxbR+T7wDXPRF6sZaFWKkKRmHT/HOfnz3Z++7/fEqdo
	vmWvEOSK56EP3nENupg9rIvia+yJ/kbiXUOLaGuRKFQnyFsajRIGNVDTlemcz+VQYK2t05Fa8JK
	UNI+I9MEYdJnFAh1fUUPycb0G/50YA8RfYhqbereQnhyhxK7R/l+359eKJ6F/fnpVFu4GqRfdKQ
	Dnprb2eW9lFQr4wL+EIqv/nToh272dBUd31QHO6LYt8glQdqkqz2CAmSx6Pws0+jaomDCpJpsHK
	IZotstHcezSQaBpW2Nj/18rl+PQhfUanYuAHeJS0y5v32lqYm3sYC8eGPKLgHAZv9QwI4GP+psi
	b71S0GXo2E+ByF5fzGTHJMPKXB9SEvrlU448TsLNFioEaizwDJcsG00KjgTjGu2lhD6L/GbH36d
	PXuqWy9OjZo9uigtGPUA+OT/EdVMuNksj3X20LDx1TTAci2RTY+eY=
X-Google-Smtp-Source: AGHT+IF6jYkceDSxr0q7W5Uf/me1u68y0/0ia7Af2JYTdBnbk2BDeEsYBndbKG1YGF/M4co0yuY0Mg==
X-Received: by 2002:a05:600c:4506:b0:477:9392:8557 with SMTP id 5b1f17b1804b1-47d1957711fmr98592555e9.18.1766396913629;
        Mon, 22 Dec 2025 01:48:33 -0800 (PST)
Received: from pumpkin (host-2-103-239-165.as13285.net. [2.103.239.165])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be272e46fsm231821355e9.4.2025.12.22.01.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 01:48:33 -0800 (PST)
Date: Mon, 22 Dec 2025 09:48:28 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Li Wang <liwang@redhat.com>
Cc: akpm@linux-foundation.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, David Hildenbrand
 <david@kernel.org>, Mark Brown <broonie@kernel.org>, Shuah Khan
 <shuah@kernel.org>, Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v3 1/3] selftests/mm/write_to_hugetlbfs: parse -s as
 size_t
Message-ID: <20251222094828.2783d9e5@pumpkin>
In-Reply-To: <CAEemH2f40t+4SsjL3Y=8Gid-CBMtf3eL1egsPKT1J_7LDbdWPQ@mail.gmail.com>
References: <20251221122639.3168038-1-liwang@redhat.com>
	<20251221122639.3168038-2-liwang@redhat.com>
	<20251221221052.3b769fc2@pumpkin>
	<CAEemH2f40t+4SsjL3Y=8Gid-CBMtf3eL1egsPKT1J_7LDbdWPQ@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7E7F44000A
X-Stat-Signature: fti59xdiar6n5hrcys61xn38whsgbi1j
X-HE-Tag: 1766396915-893576
X-HE-Meta: U2FsdGVkX1+vmUjLU/voBjtCoJZdQdur3R4bz1+gtSl8EG2qpqfInkQwUd8GtzL1Z/ZsH2bOnVgSDRxAF/mYTMRDmEC5kVgm9NlLRCGWPLyQbaGGaql8RyJLvvQafhvvbqZYnVNDDss9AOVZnRGTayvKUFAgAGQqTzDCrw33KQU5PCA4fhwkcX/HYQMtk/Po2rW82B5xNjl5Qdcno/IuHhVnxIh0QdZPQnrCMghwVMEbFTrI6HGczF6iFpxnikh/mYBpvEqFgF7kuQBbE7jDvBpG1KIb1T4SEi25enpUAzTB7QlAyHR4TFTTe2ozFYzhRpgPUWxzheR32iBe932/8s4DrMtBZ1a+hwnuugMXnMPq9GZkdK5t7zc/TLFJV4Kc2d2N8BK+3gHTOHkXT5uPDpR2HRjH4EqbOxhcg8OvMzD/fvBFtk7jSiyQWAz2y18NkBzfX+7UYC/Zc4iuXHqXU10Z9INashLNQ2EWPVoQ2RLtmL/sg4s9CttX6T9mJ6Xev8h2FliYeqjkwoYYBmpxyImKoW778X1cIPYfonlsqshel4gAZQutOcxAEJuDjcA6O1M3I+Nh3oAYFDxgfPrRXeJQizVMUaRis0lCz1jXmbIv8weBxUggNcQt7QJ7G6HmzzsIxazEszSfai0Bp4CBXbMfRNafKPgbAMW1x4zfkDa76/I3XFLenrJp+uhdvxy9w4ZBejF2FNi32LRZUT6H94bSVGf/7ojJJEdrJ1tdxcXDiILgXVNpyH8CKX7i74csDEyJ83JvbGHZNBraquFygzCo5wZtMSUxTB7TKc7iIcaonzU3soOKkk7zp3nJZaBWc8ctTsmn117b1lFbJEsTNZBbUuvFjkkg2HUWBFZw/3Z0h/Oa/SAv4f9PS2pg3o7vE0ZtZgbW1sX3YNDN2rZ66l3UBuCBtV2LhpWlxMJOKa2Uh/7ehiIEoWo7Xgw9n280yV4kCAKWuB/r35rOAFr
 iWtgcrTZ
 sjP60X9NZ4o7Ht34nlAdFS1qfrhZM0ZZIeBy0tMUcePFmPRUQZvXBALASAG4A80l3jWsR2D4nJHBBRu7utIyrcn4sxfFmOmrQS/6jCcz4d8w6WxOIvT7jhfnFmxmMd/SnYu9/t5EQEZhiVGxkdrJGiLBw4QV2+CB20upsT+6MIgddcPAW3AYTsukAVI54j1UUCE9BvbX4XAjnt8AeD2sgbZHRgtR6LtIbnRDJ/zSSZ/2iHMV+YRSn6+zTI2Qux7kpd746y2GnbrFK0yU6z3xQGudRKGVppclfHQlhNoZLM+mhWpjz8lCWIX31bQYohvdsQNlSoYWCSM5q175dGmTKJto/FvADSKCsI5ALteCVy4CuzdIkgUqkpToopVzvC+gEir4kgbl0aNfGZaxCV4Rjl7ISwqy+wihBdm5puyk2a0qyY59rO39YCf5A8MDXrrgpckdTrcwmtk40kZhw0b1mWUbHfMdmUv9ZKC4Z5odNqwvhykJi4IoBX947J2V32vjBzKgbYFxG2+ydhCspKvlMR5BnGQPfDR3kcfaKibE2MeJLFQt569nIUU/XlksyzT9IzuMJ4CEwPwMwW137M/RPGvYRvf7RzQiY4aa8v9nPTqUnNe1xB8IWxd4tJfTZozjLFdBcjuljxocvYoEOaoirpFwBF7dtWvsHzoGP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Dec 2025 09:45:41 +0800
Li Wang <liwang@redhat.com> wrote:

> On Mon, Dec 22, 2025 at 6:11=E2=80=AFAM David Laight <david.laight.linux@=
gmail.com>
> wrote:
>=20
> > On Sun, 21 Dec 2025 20:26:37 +0800
> > Li Wang <liwang@redhat.com> wrote:
> > =20
> > > write_to_hugetlbfs currently parses the -s size argument with atoi()
> > > into an int. This silently accepts malformed input, cannot report =20
> > overflow, =20
> > > and can truncate large sizes. =20
> >
> > And sscanf() will just ignore invalid trailing characters.
> > Probably much the same as atoi() apart from a leading '-'.
> >
> > Maybe you could use "%zu%c" and check the count is 1 - but I bet
> > some static checker won't like that.
> > =20
>=20
> Yes, that would be stronger, since it would reject trailing garbage.
> But for a selftest this is probably sufficient: switching to size_t and
> parsing with "%zu" already avoids the int truncation issue.

Have you checked at what does sscanf() does with an overlong digit string?
I'd guess that it just processes all the digits and then masks the result
to fix (like the kernel one does).

It reality scanf() is 'not the function you are lookign for'.

IIRC the 'SUS' (used to) say that this was absolutely fine for command
line parsing for 'standard utilities'.

It is best to use strtoul() and check the 'end' character is '\0'.

	David

>=20
> @Andrew Morton <akpm@linux-foundation.org>,
>=20
> Hi Andrew, I noticed you have addedthe patches to your mm-new branch,
> Let me know if you prefer the "%zu%c" enhancement in a new version.
>=20
>=20


