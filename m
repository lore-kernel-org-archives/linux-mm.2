Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1712BCA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 06:42:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 240098E000B; Fri, 12 Sep 2025 02:42:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21B968E0001; Fri, 12 Sep 2025 02:42:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12DB08E000B; Fri, 12 Sep 2025 02:42:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 02B7E8E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:42:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B1B22BAA54
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:42:34 +0000 (UTC)
X-FDA: 83879654628.15.AB65151
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id DAA48180005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:42:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DVPxsXAP;
	spf=pass (imf06.hostedemail.com: domain of glider@google.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757659352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NiDw3YhiRCuiqX3s8Sx2YRwxOWOYND2WGqxePm5DDYE=;
	b=fMCG/f8gxfngrQcFVtr5ja+9pTbgTtJo10pIsr4C0J0trEBdntjGdHU5EnLDimagt5bzDt
	sGxy2sR8s+PgLC/TcHTNRf8YKela5uhleHOOSFbIIFV0oY7ZrAnU9f/PQjq7AREdUfmj9d
	QJxT7nNhZ+QzYkB2NF19nVvpKWp81KA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DVPxsXAP;
	spf=pass (imf06.hostedemail.com: domain of glider@google.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757659352; a=rsa-sha256;
	cv=none;
	b=amfDIyzFHbew6H+/1xnRf+PG5Bt81FUXieT4WXxHqzIIFoU9jAEcKzZAW6EQ3oSyXx6bLw
	dhiInJJzAMlf5eC2rBFuRkPg76p96LccWQuX8M/3Qby29T9FsC6C7cofeQCGpG7+3ppyC2
	/7JswvqlEG5eQrwaPdGlT1iMAmK84yc=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-7211b09f639so16925766d6.3
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 23:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757659352; x=1758264152; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NiDw3YhiRCuiqX3s8Sx2YRwxOWOYND2WGqxePm5DDYE=;
        b=DVPxsXAPgGcBLImDC/Wnkcp1px+MX6G1QB7vSqMtXI50fAuSyKtC3VPe5UHSOduKjL
         GFFX7CuYSaaagz2GJLa/vGAqnu9GhWWk9cHokRmUtWlS+gY4mT5rlO0qS3pSP7YKiWHc
         Vcirz1F+H86wIzNHkF5xhNBXUT+6grJpfue5XPt5nSaadzSWzVjpqupcNaTwJeYEyfE3
         wYLA8WHmeR865K2xvrY746ZFZrp1pmfLkPz3tHiLOXSelBZzBtvx6TcVe0Ka6/my72ge
         730nMXEHHOBvf2dgysUPHl7fKG/wX2Wtl6qpzJrQPFUG9qDdkpjdrwNjmOvdLo6tMpJQ
         jVFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757659352; x=1758264152;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NiDw3YhiRCuiqX3s8Sx2YRwxOWOYND2WGqxePm5DDYE=;
        b=WO2ienqve/aqEMu4n3Ti3Qo5bJIrzYevW/sHb5fTemmHV6M+++cYL6HbLHMJGyiqfJ
         EHj9G0CRoJRP5cKQ7gifqd72bqDQNra6PWsw6RFhDgbk6i6sE2qIqciZwRuWk9Vm50ZF
         wdZjwEW57bCuRNBca1dLPNhdy3Ci1ZZN5QNM3p8Pnm2deTnT49ofB/sh6g5B8lwCAWGW
         kTTTdAx5ti46+cRt5qxEMqM0Mm3XzaRQS+UFuNyvJEBydvwAAydICwZY03XJLISxsflD
         aS0oBHeHGQ/6DfW9Otlr9iwgvGGoT11KovyeINQ5oKC/8HIJKXiBwcB/rMb7PZhRUCVu
         RxhQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0j9J6GI+ItXz/bGFSVTCO79mnCgvlyebIGBpFtwCI4IaX1RTkHIbu4QqsEFyLfPhPNo8YX+zH4Q==@kvack.org
X-Gm-Message-State: AOJu0YzO+uL2N5jPXJV4I1MSxoMfAOLeN8NJ/fsEiMdIUMC0InELo1Ds
	oSlTX1g9VhBXnCPrKgsjc0Mj2CrDZpeFeTmiBbstIMAa2FQiDKJYPYFC2oCpchxl1H51k97gnIj
	hr3mBmZF5EYVPmi/XdWh0tEf4VuT8R4eV5DJabP4r
X-Gm-Gg: ASbGncvowjok9wN1c19+NH9iMmuY/T3qS3UvUk4Vc+C2Z17nlEqshZW2m/7SFHmYuw0
	xDK/fnjiKgTTWXJJdw7dqMI4vep5fOlFpnCpLA3fGNkqabph1wmXz/yIFR8siDktaT+j4JtfxWx
	RaFA500K4sff32Qdk53DiRiyM6B3ipIkdVaOxlfI+avMT/afPH9SdQ3WxWUqPHQdsQJzM5amQAN
	VEJ6q9u2+eJ31UTvrsuHhpMPljRcj8huNIDLYVKUvTK8lJ+NtnXte2YJaSdMw9HKQ==
X-Google-Smtp-Source: AGHT+IEySOSJPa6hD6RP73UcA+EVycB47r1tHjCeHNXYQHml1cj7aZJMRHV/AJ60ELcB5pCg7c1N2toT6ZWS7YO29Ps=
X-Received: by 2002:a05:6214:410d:b0:742:1ea2:b5fa with SMTP id
 6a1803df08f44-767beaa719cmr24286056d6.27.1757659351417; Thu, 11 Sep 2025
 23:42:31 -0700 (PDT)
MIME-Version: 1.0
References: <20250910052335.1151048-1-wangjinchao600@gmail.com> <aMO07xMDpDdDc1zm@mdev>
In-Reply-To: <aMO07xMDpDdDc1zm@mdev>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 12 Sep 2025 08:41:54 +0200
X-Gm-Features: AS18NWC5FlcfxTDi4nqpRg0jzSdo_HN5yk0SuuDRYsNBfDIot3LDMm7TkcnabIg
Message-ID: <CAG_fn=V5LUhQQeCo9cNBKX1ys3OivB49TuSeWoPN-MPT=YTG6g@mail.gmail.com>
Subject: Re: [PATCH v3 00/19] mm/ksw: Introduce real-time Kernel Stack Watch
 debugging tool
To: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	"Naveen N . Rao" <naveen@kernel.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com, 
	"David S. Miller" <davem@davemloft.net>, Steven Rostedt <rostedt@goodmis.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	"Liang, Kan" <kan.liang@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DAA48180005
X-Stat-Signature: 3zb8irmu5gcsghwo3pghkz196opw3s3k
X-HE-Tag: 1757659352-128207
X-HE-Meta: U2FsdGVkX19l/Ofhfp56uW4cju0W0gf5onBFNpZ4AMukY+jH2IgmNJsVo06VjjooGmoy50i5QltLkYGUFtmwfsVuiWwT3T/AVxv8a9/forARbEcgVRbBvPWM1hL1Zsy2olyCnP7uy6pTlMPYMMaWe9sq4/VcCsyLxGHEXb3ijNfuH6ciaOaPSYUU2fqb9uul2o3SuhW/1EK7IZrKoRIAcBhSvuuDXE40WkiS88Xdfe/mM63h6WxQeJ/JgklBhVcvl0nA+g+nHlPXrvZ9r799z2MVd5ckkIa6VdXd/09k8PfHuaLaf7yoyZpnuTOl/7scGlEN8tnrlk7K51MiZu5AmvXGl9uZ/cWjYABWE+xVkrwNaySYhEj1NiyT6nKf1KyLJcRlAW2acq3NnK2UpPOKWcgW3pK/FKnlVh55YcZpQLjomaUrfj/Tm/32EMWXY/kRGTEkFnInYxUWa51aIig8WlLmOj01Ld5uz/Tg1uLf8yh4jxxVPmIUbISjhI6Zdy10ggGZeRqLv+T2WEyzpcGrmXukkAstSfvSat5tvsP64sgp/pBgwC5aeGmy/aji83SkuLJDmeXu/pbhhLRfPEZW7gHTjyZ3MONX3HYc8X6Vtm75Gk4XrV8JOy+qprkbFQ2E6bfbnYoB/CZx7DJFJ5rRNHs8Ny519NhUIN15WPn4HWEF4an1qhJ0Ke4QbGeL47Jfyt3FiYtVahgQfGqxAe5Nl25deumF9LzK0nsb2Yi/tBdu/Xwi6vUFBLliHYM8TV1MwVoekJRiBoihLj5oTJ+PNau0mXfpkp2g9I/L3PbX/rv/ThDRKxwLBrupDl1TPdBbh8Wgr+MjtfkWi6P5vCTa2XflpkBGvta7HZr7lHil0kfZBA1x0Bh37VeNqnVFTSH+C8jUSvptokLK8h+3hpJJaH7rO8lO8qKhjUPGcKG6bFzr19zpUlVKNKveGnFZE5tRHM995dsgUS3SOQBRRAD
 +e+G3ga5
 ZsNB0n3CmiNxtlpdt8yCiuVOcb2P6Kq4lJS+z4M6er8ZCu3lRMaK1VtfkYUp6veq7lm6FThhLttB0+7jA41m++dEMipiuO0+C69+Jt3wGAXYvhDRZqKqd+sBo6rbuSu7zLrH45lZZGDmt7NOLLOt9O+u7lX49Yo/dF70Cv+n1FqVDDFR3TRZjSUZ/QAkaRQoK6+B0AALRGqX/gmQNllkVu9MAF2E88iLzyzK6U8jTKeUKy8Xj5QjnEPpeoE1hpOa1wmg9bySEYLRftsulWl0M5VQ3LRcILV0ywnV3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 7:51=E2=80=AFAM Jinchao Wang <wangjinchao600@gmail.=
com> wrote:
>
> FYI: The current patchset contains lockdep issues due to the kprobe handl=
er
> running in NMI context. Please do not spend time reviewing this version.
> Thanks.
> --
> Jinchao

Hi Jinchao,

In the next version, could you please elaborate more on the user
workflow of this tool?
It occurs to me that in order to detect the corruption the user has to
know precisely in which function the corruption is happening, which is
usually the hardest part.

--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Liana Sebastian
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg

