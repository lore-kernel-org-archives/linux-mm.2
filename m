Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65DC3C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 00:19:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ED876B00A0; Mon, 24 Aug 2026 20:19:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59F566B00A1; Mon, 24 Aug 2026 20:19:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48DBE6B00A2; Mon, 24 Aug 2026 20:19:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 21D116B00A0
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:19:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9BF9B1C142D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 00:19:47 +0000 (UTC)
X-FDA: 85137883614.02.50AAEFF
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf19.hostedemail.com (Postfix) with ESMTP id A90871A0007
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 00:19:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nJXPN2r1;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=jthoughton@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787617185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oi2XJsVVO+vc7c1/zrjvYVUavZv1Bhhh2/RTVMd7WoQ=;
	b=OCMU02gs8+IAI+uJPHgKUQhsWXvzMwjCeVJ6QoVy2i1VeKcOAoKs5INcws9nxtjRWjHEYM
	cBLpwmWwPUDbiStW1ryGPoDtYXjbERmSnsKlDMhuEwyo12Q1qFj2z0C9G3ItPTYOgmKWg1
	zp4k2+L+AfGw4vI1BP2dIO9dJ5uMhyQ=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nJXPN2r1;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=jthoughton@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787617185;
	b=R2fk6Z4MnahHqyV9gqYdOKww7EspTo03c5WG2Flw1yLDNd/Eb1VYtdf/6n15Au4ojg321B
	8rm90MsafYeDfHK/N9SvmcfqfaNq+xU9mWj6v9mbUiU/0d6xe+/3wFL5mHIjwzTfDCYB+k
	r1dM3tmWPYkPpV1CipUEGYNQsrbEReM=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c1712a04ddaso695838666b.2
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:19:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787617184; cv=none;
        d=google.com; s=arc-20260327;
        b=RaoP2N/POHnQyK4pUtd8q7wQrEjO/1QteqGl0bQtPRZFOxHpyKcrHgNaalfjug56NH
         eK84D7Fc7HDW/EQkCj81i56HjJuhmGNnIJUIVZ06z01BYOosGfS0CS8hp8Xic/ymC9x2
         8u8kzjx3SrfqusECC2N4W9rZvD5U1keo1fZkzILHN1fhzmVVyHReXE7d9V4DDDfdMFGu
         HseqZKV0vRgf/1/PPtv4QFTWIqKwMX15Hr+uYB1Cu/QbJWUIFDThz4jqJMpqvMpHoXGh
         i+nVgBDUKFfUEQZNosyY58vtzGVdSB4bHEed2ZxZMHLfvrY/meq85vcvvsifUTncPgJ8
         mPEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oi2XJsVVO+vc7c1/zrjvYVUavZv1Bhhh2/RTVMd7WoQ=;
        fh=FqVyFTeH7S2n+r+6XhPqYXDbM6e+x54L+SEIjrC0Gc0=;
        b=RtnTyVXrbZdiN2FTpg1gtXtfgImnd118MhkYcVoUpobQuLKt5fcCS0L0n5WalXm+DD
         XTw7nDyx/0eoUIH81cqUNiRqXvtGXS96qePeBAKvKsa/nttb6oElErkmDZUo93hlvJz9
         14zfiAtEpuTvAbOXVl6Xeba8ouQpNrdrrv6RSumJj6jGIIGU+Xa/pgUk9BP3jzCstDbC
         wP9LKvS5O9BlcgnRyzh0T5qIZWqbmdSLuEIOwuNzxbNQe6DwcFQ4SSAVVutY7hLSTQXl
         HVzqYos1R9ryWrVvG4YmRKn/Aq4Hyof68U6QjJlrF8DWY5os06gEaEYjqva5i8oZtClB
         GOkw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787617184; x=1788221984; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oi2XJsVVO+vc7c1/zrjvYVUavZv1Bhhh2/RTVMd7WoQ=;
        b=nJXPN2r1cfwe1gi8DOjge/lt8XIpDd6vXMTIMO0B037dgSjFlCI0ldzstxT3KmlAYP
         o+6jFfe2jOigEbkpHvVbAQUISqjhEBWnu5WYZjeJqoUhe5ZcGtZKgEHNfMmPFlBPYY8m
         N6+IuF+yHXlG1J7hFmzRzZL3Yq+8RnJ6+OuiT64HpL4n0rBETWMjX4bvBqGKR6IipTx1
         IbGua+3AWBRdE3YDxNTBY7BXXGXGMDPVvB2ahQH9X/c8LsqmYYMqlzXbtVBA64NYHIbG
         6tXKsjHYA+VPwtvZJ6K1pV5DARknZJPi9Q0d5OU6V+NSwMROEOtnLFV3dWhQwiXl3Lcg
         OPQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787617184; x=1788221984;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oi2XJsVVO+vc7c1/zrjvYVUavZv1Bhhh2/RTVMd7WoQ=;
        b=OvGRQLWXzdevVDIraLCIImV3tPX15UEQGeFzf04CV2V5XrMEA+o2qPq9zrsD2fsiWa
         WDdw2YVrc3ub8I1YJETjMOrGoToooMG6kHUM8ZRoQgBjPtW36UAL05XKoTdFX1ssaZ06
         7mocJCAtfdFztbIzXYkhkSm3fl/sfVun7yHOOwiypTAfV0CjIExHc37gf9BD97WJdlTA
         pGv+TYEPQ/FlsYEFW3PWdeUr6CcDyo02y8iWI4Z8qv0won6dm9laqAg52SLnKety8glR
         MHcSVu5UKeXAEXtJSh76DOeV+2KUA2/TSfABazEGoRrVqjuQBZYyQO1ToFjpPDoAdC3P
         GErw==
X-Forwarded-Encrypted: i=1; AHgh+RplCVslXnaS7e8OLBDe4rPvJtMY5GYdEzG9B+AanymuoFq3SruA6z8OfI3aNvFVzZJu32lJsfvUrA==@kvack.org
X-Gm-Message-State: AFuF++ll8F9YHitSdJfWKSq4JBNwWLT8KfLllUgfHP/RSgQOX61DZhcV
	zryEmk7rAXjkrWu+TvG80PCWELLOHDSDihxheEbumRyXZtNFR9Q6lu8PyrneFBGTF80FyxoZlFz
	B9mOtyGVG+oiNucAv9gAxV4xgm7o9CN7vu4wZhyRZ
X-Gm-Gg: AR+sD12Rq3mNxWxyhg12WBK3DctySKa5gzM0f7xe7Q2+wvoKDDK3ml1jroamwr/3GVb
	d91+mL4gqeASHWiiHz/nMlHyy3mj8/fh2by6DN8vmi/G7/IW5aubu0wxuylmu7zmHdAlQAcatYC
	/mXAeMN0k3x7mu5Smf3bGt+usp75cL1SR4MlItdPEl5DFQtXYURfVyXDn1XeD/KX5OMS57xnpzU
	vBo76cfjbcMReBxd97Vq767Vnp2CBBDYsVtLtw5RZMcQe80TZOTmP2Fik41HFk1J0Tyk2q2DMPh
	s97b1QgKVBHMAXSrgGr3mXTn0oVuW+AcibPTirMA7rpF2R6cc1P+KPRNOpxmwMc0F7CqrK9qv/Y
	YMWQ4DlZZqb3AyXBcRYq3DFVxlZAmYoWKdW4A8WZQxPAXd9NQt9DSSTxWO2Z25sgL9Cw06N4rgY
	LWcbIUshKWtS1a
X-Received: by 2002:a17:906:478d:b0:c20:31d1:a89f with SMTP id
 a640c23a62f3a-c24921149camr2175651466b.24.1787617183877; Mon, 24 Aug 2026
 17:19:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com>
 <20260708031129.3503195-4-jthoughton@google.com> <aoRnHjaQ9Y61OB5Q@arm.com>
In-Reply-To: <aoRnHjaQ9Y61OB5Q@arm.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 24 Aug 2026 17:19:06 -0700
X-Gm-Features: AcwNN1UQZKYyQWHzZvf5pN87Sz8ZppUU1k5HLeGcPZGcMuCryj8aeaANnsSFHi8
Message-ID: <CADrL8HXGZxkOhz5QVNzvJhh98akCzrGJd6sC_Nj07CMCXCJUSw@mail.gmail.com>
Subject: Re: [PATCH 03/18] hugetlb_vmemmap: Leave pages partially HVOed upon
 restore failure
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: bqdmb6mw3ifnc5amzwm3go8q55nrs94w
X-Rspamd-Queue-Id: A90871A0007
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787617185-44210
X-HE-Meta: U2FsdGVkX1+an7wXcJSeuvIEVqa5WOBTtLoxwueWj6mawYJMXpMiexplODMUYjDU2Y3I7TS+j7lScfE7UVHI/CGhuQQawBr4W4NO10bZB1e+4MG0Oz2Jh67yfFlHyCkL3hSq5f9Ri8SDhR0jKeTpgJqYuWmitWjPDX7lm1gHSiOexxB08jFgm3fw5UJPg5m/h+Pmqw4VBcQI0iYpdOHbIWiil7yAswkd79VbcIP6tuws5RW6WmDUirW+p7GLSBhsn9o7QnOQc85mYn0pK7rFhPp9Qdv3xBjoDKT7sHmY3LYl00ZfgQavDjYPeBV1hGwl8OCUtMEPZYu0NfRV4qEOeusstkMj59WHtX+cZ8oilACoNZQkBHpBaoa6+df12GWDSPyQQJeb7mN4dVALR4xrsOI0m2I7iNUcyWC95nc878Mpq6rYt0AlNmMblFNspsdtte+tK4Tlr2Zgt0fKhYTHZYxfDg+OgxlJu7ehoobvcg5dyFCxPjtqAFsE9ArXuro1JlBl1+hf9P3dXi5HhlFeHKTAYyYJULSMBo6zDJzG9zDj2MEf84//7YXF9AJ/Y1uaAWlJNtYpd0TQHaNvhhX3c41K1T4RnidSVjS2aWweRLL1QRiCMH83BCT+TYhq+qHiLmU1h+2EFdtnfZ2WPm8tORA+d1Ouf2P5pgzgsRecQaqOL9zVDofPtC5kyjyd//tKhpQS05LNmtSlEWrvR9sKa1F+r2alLGFbM0hsDeBAv4BDNXeKlNy3D5oQn+NKESOZSR20BN+m0bvAVyibqnLLTqp2bn5wdLeRHzIcVJOvPomNqO0nFUrmq0yTLtMBEZV7NJIQoFqgRxyY+HQmQuHm8RzK1K5YAlnh25zVbFId9muUZMmm+G3/dD798Yzck5pN3tnBOlpr9QrPCK5Uf//GkTDZhA7pkNlt4XIROEub/pDqq2A/0pz2z2bZ+IbER4KJjSx8UT7g3nZOnoG08nh
 djG95Fbn
 QSWUsYr8Z0bZVIzyGDipMgURVTxOcPIDWA+UM6nyBsSF2Nzog6twJ23GjxtHnu1uMfOckTjNBs/eSefJPWbzDnKnlMoTf/AKY9vCnC8cBwpdXQlLLlPcWdqWDSlMZuaalmn0mfRC1vj7vOgMjRPi6+ohxsBoFUAehvReBwDKD0wONBoI0UO422zOlrh9pEZlhryTsw2tmLGe+iz2jruzGpXMMQyLi4Ju8oP4oDCURbwAbsJrWifDp8yaAuHlM5u2bqYnTtfpARfJBHiG+JE+KpT8eEoH7ppi26H1SOTO89nLUuIimxVzo+vXH6tfBGtxVBLVJJiUltBr2iV5G3s8tvMzVWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 7:07=E2=80=AFAM Catalin Marinas <catalin.marinas@ar=
m.com> wrote:
>
> On Wed, Jul 08, 2026 at 03:11:13AM +0000, James Houghton wrote:
> > +static const int VMEMMAP_REMAP_INCOMPLETE =3D 1;
>
> Nitpick: I get it's all within a file but a static const int feels a bit
> weird. I'd use an enum or #define.=3D

Fixed now, thanks.

