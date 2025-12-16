Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA308D5E12A
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 11:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38EFB6B0005; Tue, 16 Dec 2025 06:00:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33C796B0089; Tue, 16 Dec 2025 06:00:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23C6E6B008A; Tue, 16 Dec 2025 06:00:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 11A8D6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:00:26 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BB866160572
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:00:25 +0000 (UTC)
X-FDA: 84225040410.27.EF724F5
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id A75504000D
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:00:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fo4rjX6Y;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765882823; a=rsa-sha256;
	cv=none;
	b=vV3KyHBuzKMOSeOs1XNSw5/RBl5sBUwobaXqLfs0+irIK6eKq22Dk369q7XbHKdgv2jPgj
	t1NcTBCbout0AT0vKJRoH92EilJwW07aBAHj2DRB3G6hPIComCPwn0HEJCaWaJnGoCqJuC
	FZquMGGIib+yBOU35lFoiWttgflIqto=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fo4rjX6Y;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765882823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nwnbHUt8FwPMGR5zEBs02t3SwzZTk4LvLl9pDB4t8Yg=;
	b=101rPyFGPkhWy4TXWsRh0b5JRhWAd4DrJso8LmM+f+xA4ECCZCgjEXPS489YQNBtEIpVjw
	TdceyaSNWaO2noSCaljVcyOrzzIuJYVTbRzeJ44y0c+nTKj++s2qqEWcUPK5m/KS2E03H9
	glq0fo62myBtF/U1uJaghKVMU2Hmj9I=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-641977dc00fso7130399a12.1
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1765882822; x=1766487622; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nwnbHUt8FwPMGR5zEBs02t3SwzZTk4LvLl9pDB4t8Yg=;
        b=fo4rjX6YErv4yMZCEe65ctKYeONZDtAcCHdnCnP4ehNfDPiYDQe2HBw+jjWiOkkT8W
         Uap0ZHWMsJM4e/XfTeEktRL6TDdc69aG4keTdYDzzpXnikgA+2wlU6HhZyMZjlLh/eVk
         yVkIO8Tri2cZ2AjzPGnwSWjzqCmWZ8UWiRizBLAKzUlPCRnwf0/WvN+rocqDEPSmq+is
         X9EdKlZ+n+RtUVYg6aXo7+VykWYKYFNWNvtKTOVAGw3oHsVKijXZTl3fu9/8K7G46IbB
         gYqZM3mM6fBnOqRV0jtdQMO7Adcz+1CdZ04poEyKsPMQryR+ziONfKiQU1b4ftJRvcaf
         pLVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765882822; x=1766487622;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nwnbHUt8FwPMGR5zEBs02t3SwzZTk4LvLl9pDB4t8Yg=;
        b=wEmCMIEwRe2kdac6qgSDdTvf2yravubNeSjYfck5BVRgpVmWpijIsM4M2NTnyuXuh7
         PSyFAykh/yCiDfhkj+rrDeGcOskIBjguiQkUMKZCzZitAARQk6EpisMFcVpTSBbgFbZq
         dyze6NIqzuEn/v3EydjTH8UE8xL+nofjb0w/YyT3xM6tZMKijf//hxA7WzAilRzmRV1b
         Y+R+TcnjgEQ5jxUeP+++75sMnmqeD7w+6O5yzdyp7+xNwnsQB++iK022RX4XhWHiIbdi
         Ev+xkkIHYxIzF0YC/Vs+x+jgAojSWyi9OOcLeQ3FqV7ABauA8mwWOABi/O1xhbwtHqkT
         cz0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXppJPMRUBc1M1d0/0gp2hBoXB2o038cWUeHoIScWmIz2ZBEhHgHHBBaNsRbcMgk7NpNbqshrgmzQ==@kvack.org
X-Gm-Message-State: AOJu0Yy3nckyH1iL9qPA6XjWprcAz3qcQmkVnHrJgO09XkINV7v6lr07
	6orjpD0HYOxgkWsLOkpjqrkI6F56iv+nMZChlHksCtIkVU8ZjJ1m1bXrOUF1mcbjOm+PDL9xejl
	4sgKiNfdWa6Jf4467qextcrFR/y5EwgZkJYZSkz/imw==
X-Gm-Gg: AY/fxX52PbKhK11t+jDwVF0z3+gUlAA0QlJjmWpTVsNCjVOEAUFFhFeoYSvmxcswWMF
	3C1X6Cp4287ygJzHx6ghrQhVw/XuQkBajeOaQXAK9Z9jZyRwqs+4Jw/2DvgPFHOKXcCHuak9JP5
	6Uk6Gx9VBVrSpLZAnqooZ2yaPdH24U2TO0MnElFTyYkLKUFzdWJ7PGtCL8JZIVsEE+ok+VX2v+t
	Jqe/dcNigtDnH5PDsncudOQUGI9x5yP/UElP4aHaHDjZrZ0wsdWEJAZMuHBt2yonLr1vF6FryZc
	Rim3IPk5wPhza/X7ZvAaUUjs
X-Google-Smtp-Source: AGHT+IHe9jgtfFM7Qc6zeEO8dBHCnRGVv9zMmqW1J4ecojexXOkQ0I+gWFpbhh/0kCc8H5IhTix8cpujcdlgDux9le0=
X-Received: by 2002:a05:6402:5108:b0:643:129f:9d74 with SMTP id
 4fb4d7f45d1cf-6499b110064mr13972297a12.7.1765882821364; Tue, 16 Dec 2025
 03:00:21 -0800 (PST)
MIME-Version: 1.0
References: <20251212071204.398788-1-pratyush@kernel.org>
In-Reply-To: <20251212071204.398788-1-pratyush@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 16 Dec 2025 05:59:44 -0500
X-Gm-Features: AQt7F2ov2UA3P0tt9OB3YzI2ABkvyFk5SEu8vsN3nea8eX6SWcu2ncLggHlZ12M
Message-ID: <CA+CK2bCSknk-r+nhue70Fn5gb=u=Xdnvpb7ORksrmpVgCC6j_A@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add ABI headers to KHO and LIVE UPDATE
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: A75504000D
X-Rspamd-Server: rspam04
X-Stat-Signature: fdzf3iers77eds1j8zpm6smm7hb3wz1z
X-HE-Tag: 1765882823-819798
X-HE-Meta: U2FsdGVkX19bAoyfCjfhYd33JCjiRxQbjqeqBCZz4UhlpvMd2LS3fisvvJSDj7HN2Ni1NWHVZ/nZBDVShrySXtzRxfvA3fgNdCKi/c6QlElF9H6NPB6JWNToQ7Ifr9254JpkD+Y1EKPy354lcs0To+tqJtNlhKFngP5Gt5Vm9GxSyZHq7GEK7NrEWHJG8DVCKfWL9tENtjURnH1tITo1l31fkM7pxM64CwhCSKbSOiarY9pJo2zAzeKgfFpOTrZIj+vk/eD2oPigPUAEj7XqiVX0cCoJKPNYcc5jM1YAPHKQefhbQqp6nLEX8EjrS2+br0f/ryo03bbxjjzY1JwknIW4qW7S80+h680DpxnP7GDw/ihCWwAa7yisNg9YTRLPAsiYvhfkrsOTfrte671U6NArpcVYKV3lVydMdhXhIzdT4nWF7wwlkY0Zhe5Ppox4m1d5kM0BmyFbNZiqUWM/VgG4zo7DVviwGNiiq7vLxocddTPiq1XJAAinAyN2DsmTn/gfK5kTJmU4UeVL1T//xEDs4sfnXHpaDfM1GjI9CLxB054e1gXorGqUgIEKkALyZES2yjTIjadS+mujxObeBulh0n487URTO7fC0PhJXzvyTyTdwuAqwfQAR+RgCUmI3DapzHghSm9VPeHxGrZSLKho5SbhtHhMXsjFseNliPPwZBPUy+Nt6SBZ9z1EN3xjj65TiTgBMLtCpV7ro4y8ajDhOAk3TAAeUdHZ01prGhs+6ZD0tP5wgDZesC5k80dw3AmEQzXWKcxS27S2+79bUophl3MHkQDa9kdAQ9us8UpQVcONwDXpT4EZfjWUE6UIm2McuASjRKdcOzaJq+WPgDK10TiLmUQ5cS+HknrQNAh35bJUhV/+7QdgQlIQN3afOvDQlHZuHVQnBVxwJWYShBvKuuaJmsWWzxcSlyB8hnjG08JcYN+9KOIpp+Mi3tR6nlU+UzeKxIJsNQsBB/9
 1/czic7N
 CvIQeB7hJHSjMrhfj7uP78vM9lAK+9DqvYoQXDng3SwNON92txSLtn9NmMoUiZWRksvKRDtrlw66Uc08ji03O2jlhDgx1hsNU6xQVYTDKak9ztqauydArZFqI7nV1d+WL5x0cBarWZCSQ3HF+aYfFpx8ibfU2807nx7TQkrjVd7Kw8X5nYIHy/JYSWWx7sIlatmarOosNtZYjcl+Rplm0mgJMPAILtQaUyYimE0/3+fnzn757zUxzIaTtKIL34nIOgy9+DNsfCS/2TSu8aFXBImEGs3SiTxLJc2RQwUvVviJaWriNJeFJwHMhMy59PMuysbtBcaG4eoWEMu/CXCCXoauiKU0vthUrlq7R3u+A3saAt6PB2TX4L/ZwarR/9Ih+9jJ0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.001042, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 12, 2025 at 2:12=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> include/linux/kho is supposed to hold KHO headers. Add it to KHO's
> MAINTAINERS entry so the right people can get patches to it.
>
> include/linux/kho/abi contains the live update ABI headers for LUO core
> and memfd. It will also hold ABI headers for other upcoming file types
> as well. Add it to live update entry so live update maintainers can get
> changes for it (currently they happen to be the same people).
>
> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Thank you,
Pasha

