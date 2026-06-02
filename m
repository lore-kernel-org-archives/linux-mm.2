Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05BA5C5DF71
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 07:32:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 272996B0400; Tue,  2 Jun 2026 03:32:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 222FB6B0401; Tue,  2 Jun 2026 03:32:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 138CB6B0402; Tue,  2 Jun 2026 03:32:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0557C6B0400
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:32:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B1F7140862
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:32:29 +0000 (UTC)
X-FDA: 84834154818.23.E2000C5
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf11.hostedemail.com (Postfix) with ESMTP id 87C5840010
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:32:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EBdI0X+6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780385547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1j0qfKP1KdBaZMY7Jn9DPIfIqNWUq3HwpWfkfU1xHmg=;
	b=WuiEvs/Td7VFqhp/D25L15ERu2NVgiOxTrdQebNMYepViyLdo63K2wkPrRh4jkqhXqywe1
	yYtadHVYXjapPKmG0mcmt49PG7mMEF4fgRA+ZLGVO1JxA7sL0k1cGYlzUZiKfWJFTRjWWb
	Evt5VmdWHt1/gqZqewN7Cx3FIA5Q+Fw=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EBdI0X+6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780385547;
	b=qwyFfNNLvvtj8bTVtij47ChhwmAdVR2Bp1Woj1+v3eTbXNByUVw8cq2YQsfF41OdSPZn9X
	pfe5NWiIf4Ud7vR7swe48Y8fhSxAMf4E/g10C1eagoDNLiGL3/tbmUdp4UEt/P/yESWXEi
	Pn3tO0gC+Iv4eaTY+peL+gokSYs3tk0=
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-137e836ccc8so113411c88.2
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 00:32:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780385546; cv=none;
        d=google.com; s=arc-20240605;
        b=knJ1D25g/Jd5BCkYWA2SJMVfdwOS1pXtRpH2NcguqJDoWXHqL8/hK1gM96emAdYxK9
         Ny076OP1e7jRm82pkvFnpyQA7B44b9gnAWCT2zTDd4ufRME8DEHl72mfM0rK3BnOWnIA
         BSWojqNUEt5os2BEJOOtTXtUyijU0LKeXpy07DPBhdtDjOsYM9Qcoo4OKktuxZBV1+Pa
         cf+vvYr0kTSkg13KW7hMURnCheoQXV14eKkIX4d906SKfPKY7jnf2soQwkKLE+5O30MR
         vVcZJGXNqgWIgTiSoJh6DG0xytXfjidfuTjhRBqB6Inc1PrtR/1BPg+KKTP7iVeUYorq
         qfPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1j0qfKP1KdBaZMY7Jn9DPIfIqNWUq3HwpWfkfU1xHmg=;
        fh=gfn28iKNZtkLWF7e9iCWMlu7Lepoe38uwAzYZVvgzYQ=;
        b=chjy9kSu+vouOZ83l6zg7NzsL8H1KyuNAzU2PW/GfpsWHI6Q1pk4x4N8UCV9tPU7Y7
         J2SsiVuVa08Nhz6hF9Hb/VYNLc8ezGT6v+7D5yLvJ268ozlSbFiyD5OJexHuKMHxsxXy
         sPoI9/u6ghwSqAtT8ruyE8NF9Q01q1RV5WdH/VMqj6nQhLYlTrcCgepkd9EQoLCPemBM
         OlwlhM1BZTxMrgDzY7SgkoXZYizAj+yxhe1WzdhU2rjlQTjwysrULh0oT4XbJeSkoLUi
         ANN/K3W+SwZkB52JWk2JhnYhuz3vbK/cteLioRrxtT18fy+M19vaZf07ROp3Cf6k4fwp
         3arw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780385546; x=1780990346; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1j0qfKP1KdBaZMY7Jn9DPIfIqNWUq3HwpWfkfU1xHmg=;
        b=EBdI0X+6SUXebyqU9NZFdBbxj7HgSLLmbi0odBQPmFdY3gwnZu/gga2pjl12XAGqhJ
         ppzya4FZeer6DAhLJC8sZj8wsVqTh+9KXIeiHlxZ9k4VocdDYmPZo0gFucjtieXfNsk9
         2+dqj7jgrUurZwl2eEb9ZBZwn21U7ktoDklmx7TgDo2/vLGc+7JDYGuEIaviawRfdfzG
         sn8otpYAZpYKDCaJjEM9FEVEIuC1IruPse2ZmXZULLtSx1FkpM905n1wyU6jy2BxEMrw
         r8mqwYQ92gY5Y0qyFTRVbyWGDNUj+zUu3R2Yx8lITOYswTbJwKkf+Ud2QjP0t8IWtOvy
         XEUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780385546; x=1780990346;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1j0qfKP1KdBaZMY7Jn9DPIfIqNWUq3HwpWfkfU1xHmg=;
        b=RVy0exoMiHEguLX80QGVLDYtjjZDVF5kCyTjXeizsnCNHXJXpIcjbX1UqBNLpkSSmp
         nuK18/x/fuXw5X/gB/DXuE/Y26W0A/751Nw6Rszhff1MNGBpEDLQZkg5sfeDePxffdJo
         f1nnkFeoVDj7+mhpXWRpTHTtWhASxP7WRMA13TDjUl9rV2kxNX1RfK7o2kXGgNoV3rW2
         5LRueA+t7uv83v/75HphSQE5CDQeRJXEd5Gin0hb3sndH4A+PRZLv5EtUNRnMuVNABx6
         /Ad0BMH08m02YuQPSFfVXZYvkpW0otBYkE4ERG7qQPIub6FMZKrSV9UjcIPFaW3ameZm
         mPYg==
X-Forwarded-Encrypted: i=1; AFNElJ8ss2277LoKlwXnrMximQsOTKmodi4TOvqyFstcQUbKR/IZekZCOoAN6m/NhomQDQj6IRodQ4Xdew==@kvack.org
X-Gm-Message-State: AOJu0YwSdEVZD0ZNl7U3dyLlEBEzIM9H5OGToHiR/za3AAm+Ztqflf6q
	x8amHVvaayeSULedvAzyy2ee5YwSipkeoZRegvlSkv0s6PjAddyPbb0ebuCpo+eFW0YaGTnb/m/
	FUsZh9TV1qfUcl4podWbKxrkaJ4KokJw=
X-Gm-Gg: Acq92OFuTR97CSd7A3AB6BiYG3Un/dHtPn6WDFq5/WgW5JEuBM61ZtulV9mVgniUWgP
	+O1OVq+MhGUbGqxL8AAbYTdFZikQ31SZ449zNPcVx6uuQ+Tsc0eontn8TTH96uyI0CaysNzyQ3d
	FYqR7ZwO6CZ9gDzSvSzZAVjGhoSix/NuqihAHquQCvErvt9loECMpQ6E4bHkGClG3BkHt/7hTRE
	E/jVWVmLsNK1AAaX6wk0h6C3oVRETzZpAsh3M8PZyHUQoQrmABsNUWHrmEUWfpq4roZCkuTowjg
	DQFMcH0c7+ZMjeXUq6IO3JW/+xWAnz9chZwrAMnVBqG7wDYM24gZ0R4TLVTB7kZWuzHgPO2Ay8g
	EfNWPmKy8e2FssiuRDsY+j8jfbWF+fKyXsw==
X-Received: by 2002:a05:693c:2d83:b0:304:9b4b:3b9 with SMTP id
 5a478bee46e88-3073604172cmr664806eec.6.1780385546267; Tue, 02 Jun 2026
 00:32:26 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1780064327.git.d@ilvokhin.com> <85fee12eec20abfcf711443518e8f0caec982a86.1780064327.git.d@ilvokhin.com>
In-Reply-To: <85fee12eec20abfcf711443518e8f0caec982a86.1780064327.git.d@ilvokhin.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 2 Jun 2026 09:32:12 +0200
X-Gm-Features: AVHnY4KFvdUeam43ra4W77gIMCiCUGgKOuyNNXapGiGfrnci6cK1Ym-kx5BR1ek
Message-ID: <CANiq72=vaiGXPwmdOuTHDp30Nm62UgjtL1STJx6aj=dDPWTQYA@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] cleanup: Annotate guard constructors with nonnull
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Dan Williams <djbw@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Christian Brauner <brauner@kernel.org>, Marco Elver <elver@google.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 87C5840010
X-Rspam-User: 
X-Stat-Signature: y6tszb9ct1kzoxinb85x5j65nmjobskr
X-Rspamd-Server: rspam09
X-HE-Tag: 1780385547-718477
X-HE-Meta: U2FsdGVkX19Fp+zyYqbHglprg7ngQQRLewbngB/IAKxJiv4p08iSjIn9LeDzZcqZGvbGrQRhnwOT2h4JsD0Twg4VLXP8g2IJborxt3TtvWbz2TQzy39w38/dZePch46OVqb8Z+3kPZM9XlI0ODQGNyUSoyhn4kXLYKCGM/uL6f29OTnqe4iDABt1fqL2FA7h83l2vyo3tzG8DJODt4Zj0YscARs3LJO8hpfZKmSClZ80delpRzbCZZmdbY0ppFzC7FmoaDOPxyA6JXkVERkp78n5I8qoSiP1iTwyz2iImqLUBzm9ymfHaBJR2TegPQBEFrqmD/PF+kFhY0knLN+wufAebtqTcWVxzZRsEyWn/Emhisl33wRlBRWS7xV/iZ+fEGlF7ge6g0EgxOA/0OpHGfNufGx8S9aAAC/nN1gledK8OWaR5z1GldV8Kpam6fv7sSUioLjafusQcXaRh28S9IE4hnHQsCKJ8tDwzD6EH9nkBmIh3rgUp7vemFT997yHfW/ZvZK/sbOwPY8Fkn+s9c/HGQraYT2UHakek4QEV+wJ/1L4pSxNGJCOLHzTIq0FJAFTM4JUfaG/1L+gmPoB/cPyLG3iAm+uY/P+Y6ZgrBcIiTbTInXQJaInxN3OPng8vKv/afTSMpXjw1DAZTrOlIw1CutfTsqawzwiWWQCG7Fmz817hh6QJUQTOn0lwDt9KxRIehD1gosrW5lj5DJGTimzgskcuB8c1jU878o03hZZe8dvXrc4kPx3HgAcCYWAw3GXPQ6HYw5K/NW7cY9+pOCmhjRezv5BChW55Ba/Po1mdzTFWi53Y9+q9mOom1hCDiVssWn76NhGEyr3peFDg4h4XCcvUASuuDGp5XDOFjoRbWTFWKCdsU+ljfTj1MENK0ol058jGs+xR0Dee0O5TOlJOfjVVrsw42o3P0ashWFSZ0A7mpwOCA9szzax0n+Lu4vAOvE9xCZgpXJPUaf
 w9CI6bOf
 hB6dhId9k+vKTm/kJrNX5I4YDELL6aCcqD8LxtNllDiJ0enLaljbEs63KVN/G95/D5A9gPwnFIY0uPlDKwruVSS/skpWlBqKVwsVXKbbL2M29zN78lSeiq1rBXL5ET3kYDWbukbe3TUc9pOyf0KItqUf0SplXVl8d46WGjREPkAPqCloOThdj+ep9VCAChVg180WuwaAhHgOXnPjchCv6xQMPIeAfQc5mqe1ZhEj06bAudwlgSZeIbdB7xwvZ0wIADPFuWyYX4scqdMaM+mgfqa9g0qt+GSMVcsevZwcMfPHrLPtIE6IJsR5Gd8Emwipr3ly4VdEbHBTv/nEFa+EWtYgQWgTTvZwet5hGluUJ5d2aFGOgQpQXjH2vHbtoD0CzTvObYeAwqbLTKM2dbyyOtjV8u5y2r13CYWaQLFcUqBgfr4MEg1jPO86wfbJXHk1p4h5Pbl9s9g3n+4y4qNWuyoHn6FSwYdVVHiehyKtoOJBQBRsPUHWt6Z3n+rbOFn8BDWURacuvzm6LF9Te9DL0mYesH+8H260ZQRR0IwR+NXCryj8wIpAPXbFe5QWUo1JwvdXSD37OkNlgVvY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 2, 2026 at 9:13=E2=80=AFAM Dmitry Ilvokhin <d@ilvokhin.com> wro=
te:
>
> Miguel, I dropped your Acked-by due to the rename. Went with
> __nonnull_args() (over __knonnull()). Happy to restore your tag if that
> spelling works for you.

I am fine with either, but thanks for the caution! :)

I assume `_args()` is meant as "the `nonnull` for the arguments, not
the return"?

Cheers,
Miguel

