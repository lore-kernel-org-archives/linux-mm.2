Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74BD6D2168E
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 15:34:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCBB66B009E; Thu,  4 Dec 2025 10:34:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA3596B00A0; Thu,  4 Dec 2025 10:34:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB98E6B00CD; Thu,  4 Dec 2025 10:34:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A8C0B6B009E
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:34:57 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5EC34132207
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:34:57 +0000 (UTC)
X-FDA: 84182186634.28.9C36218
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf15.hostedemail.com (Postfix) with ESMTP id 438D0A001A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:34:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C3cA4SlY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764862495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G52wAaQsJpBzbRSlGJ+JRlnvopv8+9HkybJuziiObfU=;
	b=dd6lEF1Y/P93XAFZrhcl1/AV9l6LoS78sewwWm52ydcY2P4kLjqimRs4b37YnkphDZciY1
	Pg2+Z7ntW+9aJwJqKTWpSUCc5pFAJelFsQOyE3V+CnVzTVVugKz84iXXU27IXoT9ps+KoJ
	E2pdeHMUGjZyVSwS4gG/QdFOwge96ew=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C3cA4SlY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764862495; a=rsa-sha256;
	cv=none;
	b=1PuY7wpEHR0LFl2n0ZBuiAWgU45ubF6ZiI7lTk1nuyGj1OVa3ceVrtyxckC7o2kEXTElfl
	kQUK5LHiENN8jkBvoUMmcmhkyRRwT53jmJD8f5JbnQX+F21YIfq5p5BBhf3vSLN4yGn7me
	v20Hb29mkj+0pO+svjzPmlIheR/jgGE=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b735e278fa1so195236266b.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 07:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764862494; x=1765467294; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G52wAaQsJpBzbRSlGJ+JRlnvopv8+9HkybJuziiObfU=;
        b=C3cA4SlYJkx2b74HQI110IIVZ2Ph0CWf3R6e6OTS4o6abjv+T1s8NuGeCrFUZbz8VN
         08z5T8NNt62byRQGUAAXceOEngLmDFchXht6ufIAaVn9T/MBMq0Klu1jSK+xfTG66rsk
         gEhBkE0WyfiUhHqAOreOQ8eLnXEMu+W3kGkNvworVn2672+W5ztRrvdOuNomivgYs0e+
         pyJXY8TobHLiKuOsx3lSQsdkIyMaFl9StYqn/76hXcQuur8qETPrbDAzHw6zGRm7wUvr
         VfPFFFawymLUt/6pTPsTzpbQ7j/baumOsgxesm1+2bfRfmcfjatyxGo0M8213Jgzspu9
         qN+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764862494; x=1765467294;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G52wAaQsJpBzbRSlGJ+JRlnvopv8+9HkybJuziiObfU=;
        b=jD7u8qjndz8XpvzgSb5jyKvsgGIp4QkcAOAQHG99EyLwdUlTFamJVtmWF4K9PaP315
         Peeuo92qbm4YkR5NLTrpMJZwTBslI6l8YNb5XUs8p0TnP3vF7nzbOZ3+8NNqZifN3vYU
         N5bNQgt2/dphUXDNUs13hUr0AZtVEY/MNEFxyNP/2xQMIYHFVHv9zD5/+hbeTgsJUCw5
         fYn7w0bHnVFvxqSdXcv6n8l2adeaoiqPxNjT9kTyC5BQMbMtlA7U4ETsTo/qhSfp9NHA
         OYCcXDDfbSRtRFGi1mhF6XQNq1E2KLWlkJq0UTKINVRxR93HpRHZdEC4INwYrU7wuhFV
         3Dew==
X-Forwarded-Encrypted: i=1; AJvYcCV0C33gRNyGAj7v/i9BhG9qWJhErwCUUCBDPgs7rEpiWFKkg4O5eIck8CFPTYsfYZMTxZBNSct7kg==@kvack.org
X-Gm-Message-State: AOJu0YwaZXDMQEhpMkC7PAl6mOUS3GO37J/CSW8VL24D5iQNjCKCBlca
	XHNj6pqY6WhwgDi42u1znSIT2Yd+9G0qNNr+9xld/C6zHC616Z5kudX48tUeH/lRKhBemGL6mBO
	560j/33tr+0VbeOx5g61n+pp88kdO3dY=
X-Gm-Gg: ASbGnctkLz22vDynf4ZRnHMeYiSSldB8keAXPCe1sSVank4WLCCZC28xnJJXG14TdyT
	1OZc1fhy1IGO5oZGQjWKndqRGa+jwacgTXsuaarbJEGgZDVsPObB/n+AGzOC72JptizG9cPYpOu
	rk5aoJpjs6qiSCYfjvQwHytybfQpLwn+2ow+2EF/GbMB+mBzEdPIEQTRppyPXcrgW1mjfTwOgsb
	BO6W6kjZnNOyLOwV+YfbsHkDJ21gBJm5MnWzY3ufHwp1FxKjG47x+/JxSWHzcWiNqhlGkQ5/m1z
	LHpV0LhN3SUfjZFPH7w34VPjMBB5VuD+gilkEBLOyQhdTdbZJ0WfG6GIQ6WD5xO1/zrvVOo=
X-Google-Smtp-Source: AGHT+IGW3DWHy09Os7hXHDrLOqPaftsD1+Uh24TUc5aiHNOpRRiFXjY3AiA/pjALEjSN+EtASYVxxi4DSDrDRJ0tJyQ=
X-Received: by 2002:a17:907:3d11:b0:b73:5db4:4ffc with SMTP id
 a640c23a62f3a-b79ec6eafe4mr430825866b.54.1764862493337; Thu, 04 Dec 2025
 07:34:53 -0800 (PST)
MIME-Version: 1.0
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
 <20251204141250.21114-10-ethan.w.s.graham@gmail.com> <CAHp75VfSkDvWVqi+W2iLJZhfe9+ZqSvTEN7Lh-JQbyKjPO6p_A@mail.gmail.com>
 <CANpmjNMQDs8egBfCMH_Nx7gdfxP+N40Lf6eD=-25afeTcbRS+Q@mail.gmail.com>
In-Reply-To: <CANpmjNMQDs8egBfCMH_Nx7gdfxP+N40Lf6eD=-25afeTcbRS+Q@mail.gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Thu, 4 Dec 2025 17:34:17 +0200
X-Gm-Features: AWmQ_blNq2tKsiaeXqmusYzQlrYj54gbJfHS_HnTcSjJWKKhY3CPArHyaMfz3CM
Message-ID: <CAHp75VfsD5Yj1_JcXS5gxnN3XpLjuA7nKTZMmMHB_q-qD2E8SA@mail.gmail.com>
Subject: Re: [PATCH 09/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
To: Marco Elver <elver@google.com>
Cc: Ethan Graham <ethan.w.s.graham@gmail.com>, glider@google.com, andreyknvl@gmail.com, 
	andy@kernel.org, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, shuah@kernel.org, sj@kernel.org, 
	tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 438D0A001A
X-Rspamd-Server: rspam11
X-Stat-Signature: 57pj7o1fmhirhwuqd6g8hg4q8nbhiw1u
X-HE-Tag: 1764862495-640178
X-HE-Meta: U2FsdGVkX18SeBSlw1i7zqKaMmYw42KxSI2p410GouxQ4CJF0N9UNmUFSlKVSMrDH8G+xRV55Qpp5UMAjRVt9owpBAB1dphuciXE0MTfjsDelqzoDeMkCz3BuVHtxTuhtDlE5jMfJTfluAIazW28hMNfT3LeR3TiOWLuI3iFif1h+f4Zz6JcAQVuJc0QCCnyUCZpN3DPvU/qfbFEM3MztXikBcMWp2pVm+qcY6zB+vbzRsv7QiZ4B1Q1woeQ4g/YgKXhXx4BHChIdnq97AhUcLzO8qN4i6Q+r/Z3Wrc1EpgGmVSrPImeC/5kdFEZKffv5PbyTjVlXhycVVT5zi7Pw9BUjmci7wpEEb52bIlCg6ugNpOsJfmngKpDYQk9m5+XxVzoDJmGmntQxG8JbwLAAI1l7+bt85LzkDaRfOZMYm6uQPYd/3zA9Qyo7HWQF3JKiMqi9m3+ooTn6HgeJpH5f0v1v+benDjo6qPF/5iwF9Nl4GrZ2aEaDTrsuQAhSLAasfXxrBTkgAr0GGb7sEoh8wVD0dNff6CotfdyKITEarQAqljTXpIP8zIJlaZ2DK3DxuQr4d8dr2sqj6r+RHSHu61S/yNETbPeZw5Q74Ecn7njuAUI0Slu+XUufboO5Wr1FarHx7i7yGNsB4YS3jpqVwvEqlkihOJ8asWESjJfVEAUne5oqEoyzr1xQVwcujsjDz2kTbwdeSFierA8cIJo5TrziQinvjvJCNSJXgnLyn9zlZs26Cf9xNJUYT7Z7oUsWW5ScZfAhoGvZ8eBSq1eUK8d/Yt8kxu71r7uuSuGVZujdd/Zhg+xdQJ9vt5WWBddLmTrHooBfON/XC6IkHTZspU02fXgAC9UZbfiXCN+wsTkMmtJI9neuoPMTYeciFUnJuu4yoObyNcj6dfNaX1AvaDZ9ZWvZh5P7lvbdYO28dMpNoLDCTfAsCP5wHz6VuAgq5x8rPljdCdeFmrLUhj
 YmbFc5/a
 /+aqbVTCsTAunl1/Vj7+x2Qbtzt6OAWEbti/mQf/f/Erhf3pqqCQA92+NDsvRSFYCgmIk0UNTA1IssTJ6QZHndVv17wqzSORH86829whx4nyKrAE9KgdSbC/fjnDmhcul5HnWV+rbCxKtHEb5aXhJxPkurna9FIqgFIF2NAE+9AQUMOcQ+xu48cru7UNf1Y4jRrcbd34p+tFW4AebfyY/t/IBAszcKjh4wSI1m2mkLt977upcId76WJ3uQOSWSJ2eaEcPQuVv3cmAi3/0bEq5C1z6Wl6k7WSHBAQS6Tb9UAIn4VefJo1RMX8+9lllaKHA8leGil7Zn92hXJEW4uN9Ft7tNl2/Sfr7kJLqikSH5kLsf9UGyfN+t8VdaC7j5NapjhuyTBEp3VV8A6C8J4ya0MQbgEBImB9aD8NFIA3RBVMWG0PbxvzsKHJnihmlSO2tunYilxXWhfCuLqf9Y8sFgorl6hm/IqXgZ5Nwxu99xLuwUyxImiT4jt+rKYvpLvdZzcTj/pit9Sr81TzBsR8RGX8XwZAhWF6Fd+C30SufcAAdtjibi85ciScQd4sIPQJwDUhCGDQxRBDHLUDIA2It+pHH7mgVnnrrzEkz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 4, 2025 at 5:33=E2=80=AFPM Marco Elver <elver@google.com> wrote=
:
> On Thu, 4 Dec 2025 at 16:26, Andy Shevchenko <andy.shevchenko@gmail.com> =
wrote:

[..]

> > > Signed-off-by: Ethan Graham <ethangraham@google.com>
> > > Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
> >
> > I believe one of two SoBs is enough.
>
> Per my interpretation of
> https://docs.kernel.org/process/submitting-patches.html#developer-s-certi=
ficate-of-origin-1-1
> it's required where the affiliation/identity of the author has
> changed; it's as if another developer picked up the series and
> continues improving it.

Since the original address does not exist, the Originally-by: or free
text in the commit message / cover letter should be enough.

--=20
With Best Regards,
Andy Shevchenko

