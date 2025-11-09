Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74518CCFA13
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 13:50:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8037A8E0010; Sun,  9 Nov 2025 08:50:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ADC78E0002; Sun,  9 Nov 2025 08:50:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67B858E0010; Sun,  9 Nov 2025 08:50:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 50AF38E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 08:50:14 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E310F4C35D
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 13:50:13 +0000 (UTC)
X-FDA: 84091202706.28.B90F494
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf16.hostedemail.com (Postfix) with ESMTP id EDF26180010
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 13:50:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M8RAoQGW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762696212; a=rsa-sha256;
	cv=none;
	b=UGVY9FVkuALq8cFhI+4f/DDcE+7aMaX8o10QwzUiA6CcdvO6GZDh79kYWSVKM9J7202w8T
	IYNRjPz47vKsfSgNtC8dTRwTEmmn50H3aSQbIfC8LyTxuvyUSLf4P5/bP9qzHrDtBCTDF/
	aHGSvFbv08rZKGYN772z33htl3VCiJU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M8RAoQGW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762696212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FkXGQJ0cT+VzRQhQb+dZvS4bvOW1XkCYlyGjGKcSZdo=;
	b=7qR1Vy3XjKMr3/vbyWCySJH/9G+2jZ+lAB2xD0Cm4hp9SzePF72BCfEnPqtkehYotyVYOe
	8Gt6Sh6fDM0bFWL1S9VkNzzNyQkujARKVpdV0NjumkfvO/9sRMRzoYl7DSDqJNpY/9nZg4
	lLAhKGX2OLic9dmIXTNJNqaE/jDV0nM=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-29599f08202so27917045ad.3
        for <linux-mm@kvack.org>; Sun, 09 Nov 2025 05:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762696211; x=1763301011; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FkXGQJ0cT+VzRQhQb+dZvS4bvOW1XkCYlyGjGKcSZdo=;
        b=M8RAoQGWOhJQnoegBpobl/l89J37ZxU7B4pw5B74p5Nd85etvowWi4CM5fr94KWeXp
         kXIs3Pe4oTo9gOMnX58hnstJvTH6v6BqdnFnONKeBSMRSFA8U4zUxngsLgpeonfloezQ
         xi0N3FlEgOoxniJZt37nBz3QrSX2sJ9AWdYp77WAGAhDP6buj4A4MU8PtMBD9y22lkfc
         IBpMt/xYemn2cxKiinLsoqE0XXBy4VX+706c3aVOpRqvhk64lWclhCgIEpsyUT7v0Vnr
         2uImQ5cE4+/0EUyaIPCQbYf6kGuCyvfqGrPsypAjyUP+0hhYMIm68/bOoTuZzFeBcVAC
         E1Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762696211; x=1763301011;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FkXGQJ0cT+VzRQhQb+dZvS4bvOW1XkCYlyGjGKcSZdo=;
        b=wfCpjGiZWxcolTYK66zkeDgmoWXKHRuoKVYdpNuU0JfGbA1nj//ct7jPlOrmmASVxi
         BrLWtDtai9UiTd4zn3b6JFObie2qlbAiqKQSCyS9jBu0bWJbanQ/KRkALkur31ahvABT
         u0HAwY/q68v/FWz1rCiUcFjTRkt8xeAGgSJvJ87DPYZ9N+/+W08N3t1atOTBBt2HCxTN
         tKXn0HCwMkOnQH8txopA6cI/xcz7C96gLVOVYeqh3xg+Zr6igS6V7p1a+boQpGS8+YNX
         1xUlFlkc7jvvchzI+snIIcD9f62Th3V6DB/Ia0Qh8gj7s9QH9CFQcjaWuMOSypqIk5CD
         SSCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXzePruTshVd5CRvW/UkPiuQ0CXro0GsnE263jlNhYIh4c43E6z6pd20XJuvPZdINLbbq1H6t8vdQ==@kvack.org
X-Gm-Message-State: AOJu0Yy+LA4HwPgKSDqFKXYqcx46aIC2I+RWLvB9BLyNczxGYxuB+OF3
	o109ZffQ90TJzNV0tCInoT+njoHDslmHZgx7HsMaZVRckskLTHEz+w3f
X-Gm-Gg: ASbGncshxf3fM4UQZBIvQ6M6ztSYDYZ4EhQW4iFZF3CWAQ9ASEz3Dyl8p33yTJU0lW9
	mF5yOjsxqIHUTp/dntwS2ywt91xbKd8qvt2hEacK+urLE1N2aUU6KKxzXm3B0Z7uyGJsMt68qgS
	AtfE9xTU9pBPg2VfzGCbxR8UPnxOIS/WrmT/vMXcJ7WlP6NMx8GMZqw2AAP2ttTaH0pGi+KfIBo
	kwIbKZPD+e50GrOxr3BehzUBljI+7oVqu2vRPz5WVGoDTmLXEBBhmYv3BKkGhlWQG1zhPEiqA57
	/2Ctj7GhqzrZCL3DcZumTUAhMszmPRn4AeyZ9HAIjcMTHlKZNSEB/B97QjTyV+XRVWgYtc+Lgzr
	r9VFdi9RGeaRXgKTuXQXqTj0ZYuXhZMBpYsihVJtXNS6ZKqMNTQWjYokCmI1aQTnQq+KmuEIhBw
	zc8jhtn0gGd3E=
X-Google-Smtp-Source: AGHT+IHjeVuYYZlBuYzCRgd/i05+TaK7Ti7RdwUSllLIV+6yjd6NQGCJEudAhYXdgoPDVyrh2s/ePw==
X-Received: by 2002:a17:903:2c03:b0:297:ea93:cc58 with SMTP id d9443c01a7336-297ea93ce1bmr58790815ad.60.1762696210761;
        Sun, 09 Nov 2025 05:50:10 -0800 (PST)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29650c5e3c5sm116341295ad.43.2025.11.09.05.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Nov 2025 05:50:09 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id C2CC342BF679; Sun, 09 Nov 2025 20:50:04 +0700 (WIB)
Date: Sun, 9 Nov 2025 20:50:04 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>, dev.jain@arm.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: Guidance on contributing to MM subsystem
Message-ID: <aRCcDI3cdKLUkqur@archie.me>
References: <cb17f29e-b45a-4275-ab2b-1443d909d944@arm.com>
 <20251109141452.7097-1-swarajgaikwad1925@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="o5P0qWO0UkoQwcFB"
Content-Disposition: inline
In-Reply-To: <20251109141452.7097-1-swarajgaikwad1925@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EDF26180010
X-Stat-Signature: m99agc13zp1ua7i6cw57mq4uy4kdwe1i
X-HE-Tag: 1762696211-342101
X-HE-Meta: U2FsdGVkX1+NIkHGi68wsrUfUFsOuhx4eokDKuGYKA3hA8YjkhWfQ06fcGPMWwON7MsR499fY97c6W+MyJy7uh598mLgIWmMph1TmDHxVjK/sKlL2UuTQiNCyZemEz5AbPvSrpTEWwCReMvjtgE5sf2vZyTFoMcckBGyIddEZiI+Ql1+GzTtP54mgS8dgRLR7Na4337fE9vb52KD+Gk5+0Xc9U5o1k2+S3346yfHIysi3czlMU9hwpUPNA4TF4F4sEuKNK37ax0xRWuo67vtSBvpIEOY7I2hfWZyKJmp9dzJQK3GfsmE3HL3aiHYaJz7SHx/1jFbmZE+O4Rz/z16S72w0toGXprxqNeWGShvLQ/zHprF3PtGfzrCL0jUOGXEo2xDc2JoTdJPtLSwY6pY0cYn+BU8yrSyLoyuBbb8TP23K6ltYlsoFQPk3akMNTZD32x8wyl6THsQUg/UMcQch4AXuMQ4rSFe65tInGoPVogkLT0DI8ZnyAJvVA/C9bfJHUo6KNqCgYcRDjZFSUqoc24tFPyM99BTSMYR0wdtX0UPoa2w92MiVXitiBpxqt10+3ZJOpKkgbzzn4ElKOLH7i3imBHS9jWCSe/+4yYMcaNdWl32vRdMU5sitQYjfnZkn6CZPn5WK9QJcL+nMsRM9QhpZECRsz5BL2radjC0Dk00kOGnTr7ckJOnni/OoCz11WxGtY/o910GohsSztZe5GA/QCO1FqeEGJozotPFAtTxgn5RsbRxWHx9tZoEUJWgeolcBdTYZmOGBqmcrjch3h/uApuhBtmptPEv5GgD0yF4tUbJs6khAgRbxP0juEqhCw04SCAzKom++B55T5PI18RRzqw1BniaYoVNz5Hdh7BhS+JtfFB8ydUz5VPfF2mfk4GSQt0aHkfzuJqke2L3bI8xuNwhjiVKyJxj/FwGo203NQ5SWNj4cUHt+cufzKJ0Iw8UmhNXjkoxiIFe8pO
 w2YFw2F1
 ZdoYH6IgO20EThiBtLK2+u/dEQA9azqaRy9d7vB8S+/4yxMGsmLnZMslx0jzC/shhcgnyxiWob3Th36xXQezHKM2Dig1OGkhNHndvIjldOwNoK03E2sX4cp/xRsxxym4ImVw86YDDp0Ku3d/c9a26ce5i6HqHt/jfbkqWh3w2BVImFsDvFekzZIS/Ody5wO7+E5rwffTzY4ND6Ze7FCRVpU9nCwyW0ahOVbkVloeTMSRa5GdKgWtq/SzW3vXkLN+ZFAWvrwqqi0+Qp/57HqoEc7Na68m3L/kb3n5F6lMsSE+0OmUemaK6SAsqGHtFsJi7msnlAPIRwsThT8oVkb0aBTxYi+ApQWWPQR1qPQW1dg1MtXQyTR/qtOYcmIN9RMBnULaB4/hwihPn3BQ2fT1kJtYjGnHAgLjBne4fyVJNSxrLcbVHnIh6y+O7kMdDQtv7FId7be+OLda4B1m/vWRKPhlr+zGnEUStV4WWc2aomj+1cmIjmpG+IaboZtJeQ4uAfC2zf+wYxEjRUMhhtb21ydy85FIIylEJCtcQbJLe8DRH3WlBlVMGMzFbMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--o5P0qWO0UkoQwcFB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 09, 2025 at 02:14:50PM +0000, Swaraj Gaikwad wrote:
> Hi Dev,
> Thank you so much for your reply and for sharing your experience.
> I do have some basic understanding of how parts of the MM subsystem work,
> but I=E2=80=99m still struggling with how to find meaningful issues or ta=
sks to work
> on. For example, I=E2=80=99ve been trying to explore various parts of the=
 code and
> read through documentation to get a better grasp of how things fit togeth=
er.
>=20
> In other open-source projects, like on GitHub, there=E2=80=99s usually an=
 =E2=80=9CIssues=E2=80=9D
> section where contributors can easily find bugs or tasks to work on. In t=
he
> kernel, should I mainly focus on exploring TODOs, adding selftests, or
> improving documentation (especially for new or less-documented parts)? I
> also believe branches like mm-unstable and mm-new might have ongoing issu=
es
> or regressions, but how do developers usually find or detect them? Would
> simply building these branches expose such problems through compiler erro=
rs,
> or should I try building with different configurations (for example, using
> defconfig and other configs) to uncover potential issues?
>=20
> Even though I=E2=80=99m beginning to understand how different parts of th=
e subsystem
> interact, I=E2=80=99m not sure how developers usually identify new bugs o=
r feature
> ideas to work on. Once I understand the code flow better, how can I
> effectively find such issues or areas where help is actually needed?

I can only speak for the documentation subsystem as I'm regular there.

For docs, I'm usually watching linux-next mailing list and looking for new
build warnings report there. If the report says htmldocs AND the warnings a=
re
emitted from Sphinx (look for [docutils] like [1]), I reproduce them locally
(make sure to set up the environment per Documentation/doc-guide/sphinx.rst)
and fix them (in that case, I submit [2]). In absence of aforementioned, I
build htmldocs then wandered through its resulting output to see what
formatting improvements I can make and submit (e.g. [3], [4], and [5]).

Thanks.

[1]: https://lore.kernel.org/linux-next/20251106143925.578e411b@canb.auug.o=
rg.au/
[2]: https://lore.kernel.org/linux-doc/20251107081300.13033-2-bagasdotme@gm=
ail.com/
[3]: https://lore.kernel.org/linux-doc/20251103093817.52764-2-bagasdotme@gm=
ail.com/
[4]: https://lore.kernel.org/linux-doc/20251017064525.28836-2-bagasdotme@gm=
ail.com/
[5]: https://lore.kernel.org/linux-doc/20251013095630.34235-2-bagasdotme@gm=
ail.com/

--=20
An old man doll... just what I always wanted! - Clara

--o5P0qWO0UkoQwcFB
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaRCcCAAKCRD2uYlJVVFO
o4zEAQDYl4qSeekBOaAB9zxtXScuTFp6kvkLpXjcPuU8fui+UQEA6ZcPvcSCi55k
Sqqw2oAAzD39cMDepBDho0hFAAPXrAw=
=/YTl
-----END PGP SIGNATURE-----

--o5P0qWO0UkoQwcFB--

