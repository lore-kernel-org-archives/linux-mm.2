Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04356CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 05:17:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01C498E0002; Thu, 28 Aug 2025 01:17:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F366E8E0001; Thu, 28 Aug 2025 01:17:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E73678E0002; Thu, 28 Aug 2025 01:17:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D95B58E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 01:17:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7A4ECC0827
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:17:50 +0000 (UTC)
X-FDA: 83825009100.24.AC6DCAB
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3FFE0120002
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:17:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=B6YnN9yE;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf29.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756358268; a=rsa-sha256;
	cv=none;
	b=21wiSssjQCXJ+t1wDOueu/t2xeye127o30Dtg/4KOYdewqCka3N+89SL0r907bUNnxMlkk
	BvUpVThb7FxgqmCjfsza6NiK2m/F4iYbhS+VQq5urhI6uzXefKkwjyiTi06Mhhrz2YRIku
	+Q7dzhm3i72t8NghoS7DF2iVnPST7Bc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=B6YnN9yE;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf29.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756358268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OG1WuC2hheSyViU3tcDLma/6gW2kIJ97ZTkGB1ykit0=;
	b=lDb7IGfOH+veiTxEJr9wE91c8acp37DFwRER7rHPKXPBCavpw1iZ+SX6gG9gmj1Q2kJi8V
	2gKvSt5bdly1ADa20Dzb1IEi+76uNxXwsIRCtHePw3WiFsjMY3SdwHFnGpId/JwoUvilU5
	NjZpTfrhscOcAz6ZSqUwiKJ29TZFSRE=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-afcb731caaaso71787766b.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756358266; x=1756963066; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OG1WuC2hheSyViU3tcDLma/6gW2kIJ97ZTkGB1ykit0=;
        b=B6YnN9yE2avJIrK3C7jymcMT44nZUlvVTZYbY0blYwM7meIn8QWXZeyVmdULOS4hft
         NxYKnwPVeH9o94DBlsa0wtJ0AJnz3HV0Y9Mah7aVuya9zgSH26q96EHvMEXF0BFoAblF
         +hKd5qlGhLf7pOhFfm+5+aXsQBKtuxpX/7BoX+thyLhC/jWSG4oXjfQoyP7WMsqkj4ET
         stzByT4d9zsBrgtFBHNUmX+Qr+IG+Xjmxpdm8N7pQwy8ub5sFQpWtmnJWR0S6Rhyd7xP
         VTQHcbKxik7CEpybb+9tbXinnPzkYOa97bLMpTjqR4P12/0Q9gRhiyLuulzfUSL1kKQB
         nGSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756358266; x=1756963066;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OG1WuC2hheSyViU3tcDLma/6gW2kIJ97ZTkGB1ykit0=;
        b=nyfxdxwtqa0Ij2TSXJIIa+6tfhkeby/OFpxuu42k1r1q18FpDEYxUA8XQuJPvVT9/t
         2Kp/ye5snp8CSh0+KSRUpGBlBJQiWL5ZDKkzDMtj2vaI+Sc0sZVlc4rbn8qFyNVBtPOy
         Uc5TKASDjKGMR9QJLeR9dZ0W1OOQckDzqCfVrKElWFZwVrOhNdBJRjS9G7minE3cIAxW
         WNkZsXzgWp95X+O2RS0+IqB1pr1My57DWuC3WzfnUdoghn3aUCAgnJW3CUiRSCAzu6a6
         36+zg5/dgzPyOqY7pwZBjnPClPwe2L5x6Y9BmHdN2EVtfVqLNTA2Mqoqazw04STrpR3P
         2wcw==
X-Forwarded-Encrypted: i=1; AJvYcCXkgiwmjV6z/EKNHl68CZc9JPDFAl9coeizwZes7/7mgg0fRJW077VUeLvhayptNSFOZdqcDioPrg==@kvack.org
X-Gm-Message-State: AOJu0YyRmYaR7cudX3WAHQWZ9jDVC1AXNTeG22tbOf0JtVjGHZGRfYo3
	sjhju3hAphdAPERPkXgq6CAXMNs1V/EdeHQvEdelMLOskuhjm8vpsev3Pjg70DghZ05cwNsF3xd
	8sb1hCTK4eCWHd4vnz7O8EAUJVC7QvuKtFaLdh/zSIQ==
X-Gm-Gg: ASbGncuvOgPrN3iaRufjKqMLk10TAS2xAxLSXnb1bGyUu8y2qi4pZw26pPI/LVZKUSX
	+Ff8NKgsyO7/gdJpVtqTe7ao725SylLpa4tlZVW3KQCokqO4bcnZ6vII81fIHtaCU5l0gX2YCO5
	DieZ/J1nvqjBZgog1thezwAkorlc0i2sqIDgnBNNsL6MF4qs8Kpi9rK6yTOlHQ0TtxhePANg0J5
	SlOZaJe81TEny0dlcCGjwLvARHCmDiZGtM=
X-Google-Smtp-Source: AGHT+IF8LgvafHMV8UZau80cAyTYYRm10wxMO3zhQW42jodfKJ3LU2Dgpe9FDWXWK2r4Ls++4xgpcdwiUyG7ZsKp2eE=
X-Received: by 2002:a17:907:928a:b0:afe:eb48:2a3a with SMTP id
 a640c23a62f3a-afeeb482f03mr57033966b.65.1756358266579; Wed, 27 Aug 2025
 22:17:46 -0700 (PDT)
MIME-Version: 1.0
References: <2aa3f478-9c87-4102-b83e-bf235372d834@redhat.com>
 <20250827150330.280399-1-max.kellermann@ionos.com> <20250827165309.44e465ff214e45f1a6665b24@linux-foundation.org>
In-Reply-To: <20250827165309.44e465ff214e45f1a6665b24@linux-foundation.org>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Thu, 28 Aug 2025 07:17:35 +0200
X-Gm-Features: Ac12FXz7j6ZCD1KpPsfv9iOBu4iKeV--Ltb4TvtOolpiU2Niwq5q2UQwxZ1pFaQ
Message-ID: <CAKPOu+_EfTBxh7xpaRdypD-hnqAbgj-bSdMTZE4uafqMudxBRg@mail.gmail.com>
Subject: Re: [PATCH v2] huge_mm.h: disallow is_huge_zero_folio(NULL)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, 
	bhe@redhat.com, chrisl@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3FFE0120002
X-Stat-Signature: nraz6gzmqhbdt9of353ip8371mogqisn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756358268-528584
X-HE-Meta: U2FsdGVkX1+Y+pOjjuxXEzw8bwvlz8SHLLSnDGeVuCHUVJYojAUWI3Mk0tTjaMnEVr9y9zSaODZqjHPBe5yn8AsaaKPHtDIlhxkLQLCHnZimGp3veZYyjz7p6UPM1r4sE1elulWDmLo3eG0dTFWCRRjznT207JPmXvAuEVOr84e/2NBny7sryUnjkxPbxg0eXPDvX/XyYpK/j0ZOomUQ0dXrLnE/LAJQ4sa9Itxn2gYhZJZsTwofLFCvgVVoD/bV0SLRfR2djeZPE5nke0cBZBMBfzcLdcJi+a0W6z7MtNUfJc5KKLp2sl7TvSgErTrD8yxE334cWOOzFjRfYWdLIAioZOUy4CwqDpcc3eCSjkjU+4wve42QG7DvW+7RIUp8Fcg6y+yuVOJnuaD+eg6yHb89QGBPsMnQQnPlc52gIS98k6eg8zwp1VDUDS8yVlSvs2WqWTcqtEdN8tkFi/XwfjsNUV5yh260vJtwb7nDlFxmb6MtOg58SisIMyWt+R5K6p8uQ94+79kuE/NJyllF4J1ZFHRHXH8AgGd3azJDLe5xEEi2shj7B0A6+QXu5Yxlnnhn4Dl1J1LkXFHi4TuXRV5t3HyYoORi4TmmsqWM/WG5+MBE5yDdwh/7pEX5Fd2k49RQCdPtZsBsbZ6KK/SN2wO30zMdQIfVsqmpOCQwikr4tmbNNdDR3YAJV9ZEFvEkuD99rRctLGVbPgwL60SDQqqkcKPVbZy+Oqb6lrB3z9jOpYG8PlOiHESnxmFafOEKHJ6+y7OoaydFav3gqx0mkAVjkWk1IuO7TRVnin4NPk6Uj3A93dLII3QHQxosqn9d8Zk2nGM+VFTLCZylYacAHbqwhxMO6ZU2REUJ/UBjFlTuNoKz9Nng4EUuAI2Cr6WgmYx4WUJfZ7kovzxbbl5xC0huTfS3XO0zd75ulU5Dv8qMFzZDnmhz/+aeSwbv3yeuwZC1RsUhohVpMHbVt/P
 ypmdvoJ+
 eh4tc9iifE4QFdyj8Yc77Xt60dq75K4Xj0n2xqFSHYfiAUpHgVHdNeaqjiXkcpJNuqwPcP8fWV505vZ2Mn7Uj9O2QIZqs0Lo4oC0ohJOEUCyPlJ+esEEfh2yIKan3KIG2RBV3OkdHW0X7/CE/Sq0bPtGrYCv98e52na850okWmEGGlHD1KOGSZJQQPj2SdkJ6icjIclRQd1trQgeKPquySbhdM1Be8zAalXklmKNYJjnphQh/eKHW4GEZvTayM61DsDbw2pc7NAVRNcwf3TfbyDp2claMPdXGF4QqX8fiyBPlhBpnN8OQRkAJ8bqjoZHe9N9L
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 1:53=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
> OK, but it remains the case that we have seen code which calls
> is_huge_zero_folio() prior to the initialization of huge_zero_folio.
>
> Is this a bug?  I think so.  Should we be checking for recurrences of
> this bug?

Why do you believe it's a bug? To me, as a newbie here, such a call
seems perfectly fine; please explain.

> Also, sigh.  I do dislike seeing VM_WARN_ON_ONCE() in an inline
> function - heaven knows how much bloat that adds.  Defconfig
> mm/huge_memory.o (which has three calls) grows by 80 bytes so I guess
> that's livable with.

Oh, how is this possible? defconfig has CONFIG_DEBUG_VM=3Dn and that
means VM_WARN_ON_ONCE() is just BUILD_BUG_ON_INVALID() which should
generate no code at all.
Here on my computer (aarch64 with GCC 14), the size (and the
disassembly) is exactly the same. This confirms what David Hildenbrand
predicted.
Are you seeing some compiler weirdness, maybe?

