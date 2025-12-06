Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9FB0D3B7D5
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 23:40:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 215146B0005; Sat,  6 Dec 2025 18:40:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C5906B0006; Sat,  6 Dec 2025 18:40:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DC316B0008; Sat,  6 Dec 2025 18:40:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F18956B0005
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 18:40:30 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 60B305294D
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 23:40:30 +0000 (UTC)
X-FDA: 84190667820.28.F3B4264
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf03.hostedemail.com (Postfix) with ESMTP id 29EA220007
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 23:40:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=hpbCNtBd;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf03.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765064428; a=rsa-sha256;
	cv=none;
	b=LC5IAw89pLToJ9cg4wPYPcc4JBfYBSM7AiHIRv5MChQD3vzWNKPYfTCqjdUf1b4QB5bhEL
	VhpTlgk9wA0jSPxpbSzJmU8CGtVZSYwrWfCGyJOQf8aTTJWyfpZzCHNvZB3xS+GLGmRAyq
	NZjaECSZHLvUwf/oAnaSyrPqsApE26o=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=hpbCNtBd;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf03.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765064428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CgOEk/7K/w1rsAawd3rW0bpN2Y7/qQCS7eHYvBjEcC4=;
	b=TKEhQCndlU1RDDowSh8+Ub3y9eB0KFl0VCQrdKaKoUvv7hyF3Qk2+Ei99pVVh7AYKwtfy8
	AHw7eXOVP3cQdc8qJQ0lWQjbAEeZq/XHn+Hi6NTEGzKxf43WZpmZGNNyZo6dwcYLv8KOWe
	VzvhotZxLj2qHLvVrjIYQxFz5Y0PGKI=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b79d0a0537bso419591266b.2
        for <linux-mm@kvack.org>; Sat, 06 Dec 2025 15:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1765064426; x=1765669226; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CgOEk/7K/w1rsAawd3rW0bpN2Y7/qQCS7eHYvBjEcC4=;
        b=hpbCNtBdNOpq9msI7GB/Rb5gsOTGUp8Q+O3cVk2u6vKT3RSQLg6xU3/d0mOyIYkwBB
         bmS2FvFE43BWu6mKTnnXGiLp38QvyaY/E0Shnux2E/z6207ruT6514hr4QGR4i6DiH0o
         RzxgV+bnHvZ2FolqCl49JgswaCDatIh2Kox0k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765064426; x=1765669226;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CgOEk/7K/w1rsAawd3rW0bpN2Y7/qQCS7eHYvBjEcC4=;
        b=XX4hRxVysYkHZYyfrzQRqFJ2uTHmR44kh3Y6ewfMWx5/ZjAdBXj/70lz6G7cmtvfFc
         dmqXbeNcHulMMQ3XA1sWQAlr85RN7RcLIh/giUXoiMxMUXXI2rlmORLdkH4AFwdc5PXn
         w94JDCJ2J4eUzknzacMYkqcXurpImwgB3TP3ROF0MgMA+qjYQP4mGJWS7i1xR7ZRowZx
         OAsT+aQFdHHihGXJiRi7Q66YhA0t0ES5I5j0zvF92Y37K39jHprGIRbaqo7C3AuvaYDT
         DdFbukh+tPngfZkvkFSSkwfIchNBf8Ooqa7kKvNFfXABpcMgzKqFaPcgWifEsXsqBksO
         U1Rg==
X-Forwarded-Encrypted: i=1; AJvYcCUsG4O2utL9c/HRYRyOr3pdomM2qRnI5iD+i3VjtJTCLDrPvOyIvmpenvMPg5J12KCHefLQ0MTb+A==@kvack.org
X-Gm-Message-State: AOJu0Ywq6fwPbPDNq0lSGKYdur6b1t2S3PzdzY3vF5VnNOKL6K26mwAS
	sx2EVokSCLXRWQFfvmqoqyBdvBf/lnKjg55wzWeueNKSd2EKSR8LLPXyNEjHu+OzdILOCX5iM43
	urUvsJn0=
X-Gm-Gg: ASbGncsa4xXepmuXn/+i1Q+OFBC6IkTuvHa0M543oxZxq8tpgoPzGuo86/AKQN+stXJ
	hetH43G5zn0kZC0u4eMx9+rgVKJ/AKdxtdnwmiNjEL9CSv2+CHiARpUb5OXMiabbjUnjNigv9Rb
	whcQ3ojm5ADJyxXIi6ybx5yRfCY6DKer4Q/fmTL1LyNc54jni87+i5g1+dXxC8DalsxxR5CmEsw
	ZkS9CBFz+UsiNIZFdXWrQwnydHjsRSJGQT18XgEWAzvpHnrOCA5nzeUhJYtfnvuNJ1fQs07SugS
	qMRiv0C3VpreZydNuEt8mVfCUbXQj4FRaHrMZS4ntcLba0edoqwqxHF1M8sPMklbh5Q1zD0yira
	6mnSOt4Ib6rPTFQSpZqB7Wbn8NiPO/10klz1NaQvx0QY702Xv6Mpm2FCSDwU7lErVZ1lD9imJUW
	5yTWao8qSExMLq0EC+yEt0ae54LIPY0xtI8TGW4OPmQR0nFMYmuaFljoDqIB7OVQ8NMaEX6w==
X-Google-Smtp-Source: AGHT+IHXazfrXu1fXcheVsXnpNZK5demPqolGV9ZnkFEIR7EQiy8Byyv3RdDHWnUQCglaYFQfBY3SA==
X-Received: by 2002:a17:907:84d:b0:b73:572d:3aff with SMTP id a640c23a62f3a-b7a247f3ebfmr289128066b.35.1765064426102;
        Sat, 06 Dec 2025 15:40:26 -0800 (PST)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b79f4a53b39sm747081366b.67.2025.12.06.15.40.24
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Dec 2025 15:40:25 -0800 (PST)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-64180bd67b7so4300438a12.0
        for <linux-mm@kvack.org>; Sat, 06 Dec 2025 15:40:24 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX9FQIN/RY5X/Om9EIUixPc5Zo3SztkcvQ28w0G4XYtNjVDoEH8FOgJV+C9ieNdj2/mx+bQvU7u/w==@kvack.org
X-Received: by 2002:a05:6402:440a:b0:640:6512:b9f with SMTP id
 4fb4d7f45d1cf-6491ae1bb41mr2882656a12.28.1765064424663; Sat, 06 Dec 2025
 15:40:24 -0800 (PST)
MIME-Version: 1.0
References: <20251206111533.f1b18ce84d0854b5f6d86a8f@linux-foundation.org>
In-Reply-To: <20251206111533.f1b18ce84d0854b5f6d86a8f@linux-foundation.org>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Sat, 6 Dec 2025 15:40:08 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgG3xqJn1=SVw-npsdwCRtyY=sYbLa7HFkmj_Q0U=vdHQ@mail.gmail.com>
X-Gm-Features: AQt7F2r81xpp64C4WIWsPJhNfCZ5WInUAH3PD60qEkniBigIkEpaAw5wIoan_Os
Message-ID: <CAHk-=wgG3xqJn1=SVw-npsdwCRtyY=sYbLa7HFkmj_Q0U=vdHQ@mail.gmail.com>
Subject: Re: [GIT PULL] non-MM updates for 6.19-rc1
To: Andrew Morton <akpm@linux-foundation.org>, Dmitry Antipov <dmantipov@yandex.ru>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Heming Zhao <heming.zhao@suse.com>, 
	Mark Fasheh <mark@fasheh.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, Pasha Tatashin <pasha.tatashin@soleen.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 29EA220007
X-Rspamd-Server: rspam10
X-Stat-Signature: queejmb7yreyc8cau4g51nrqzdesfnx4
X-HE-Tag: 1765064427-277729
X-HE-Meta: U2FsdGVkX19YKKfkokqi1zTlLYJsq24g9/8ENRed3X0EFRdwUOQjHwvgXOoZ1Vzh2GEiZE40wDye0AZL/8Q77WA+M41j2TDay6m7EplWAKuPPxeN97MbIyodJQYS4djbALBV08wsFV9BC066D+VKOxa3ZiyKDPFvPH8/aL9wUSH9rajLxhh8+rI+EZx85cPbO3pML9kNfOm4Csow2Jrzrl4V9Qh8eDayOJZd1LQuEvN1MdIQXTEJ0dHau00HKhX+ZSaWlPn+txf/H/e4Qn2RMzRteIYVgkC7kkPN32ytCFWirJv2Z5Yqpq/WT+XAGThCsVxGKvEVZpu6SxI7Q3z4xkFqccaSqXzN9QfhoNVQ0iYFgLzGoZRcRuYJLS9c4j8T1gxc+zRe30MSg+lw1oySeSTZfgqaI9YP3u68ulKfdX2HK+O8ajAUF7piZ6kV/tXoOIrrEbcRxIfSTjyAWlAKxE9DcbAMhxbCzWZUZ231vDAWkcNfL/v/T/T3K+HHn+oXPETh2uiMXtebsAyeMzART7QrzsKJ3YVA3UcVO7ou7T16kHFgXdRr/JLQe9RlgB7PCX9vwWmKMovlTrPSex3q97GoqxccBYptDMOZzHpPQNM9oSvV5hmRYp0EhjaZ0geqRqfuCK4MSkbfr1NwMxOw/jvtM7c+Kb2mwFyCSc2bpFlSfutaHOHH2rjg163UTamkgQyJM8tOJ/FoHVZXyXndyDCTB5jtPec2oxmrxo67IzFBWHJp/nHR2JcDTlTGFJPimqahyICvAnmXL2Jl53BIyWcSHuUZmw8WMZL4WsFJjrH0G8IvPHeEQRj+6oMvzNqDUgg0Hfs31zulan3ELRGHOCORAD5sqJkQO9xu/6l8CbuP76qXie4heJ7D8doLE2zRUWM4i9hFioIsc3KD5iN5NSbOS9/w7czHvpFeD618aIejdOQShD9o5baIEsZRdtgCOAzoywIdo85A/FUcxQQ
 5Cl52/16
 POYElXzVzXbzt2OAArrw0DOlTueFLuSsJJUcVn8nI7r/R7nataBvq66xzUQ7BykWEdgcaao6s7Z5UWDP0jFXY/FBFe5cBn60LVKNWzieXQsmThXnXe7X8Iaa9ffQ0xHNWCN/kjGBci7B6DGVrI44B1yUzRsCI4uSkCVP1SU1NjU6e3gVFWc6/hrZznx8l6xaGd0VdP71Uy/8/66WHKnKIGiR8++6Q25c4JwQatTScnh9q2NTq8Gxc6D3DnAg6PB0FP1tcGy37nqErWo/ZGZHEhh50aZtmZQBBMDUfVbSKDqY09cezTE5kphWWHbvUUNB3ToJ4nXXypn8fK8OJyUnFQY9BzcHuyrXTbeURFooThEzs2vZeo3u3DozClTZFCWKCNM02LYYgnZsbhcg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 6 Dec 2025 at 11:15, Andrew Morton <akpm@linux-foundation.org> wrot=
e:
>
> Dmitry Antipov (8):
>       ocfs2: annotate flexible array members with __counted_by_le()

This causes the build to fail for me with gcc 15.2.1:

  In function =E2=80=98fortify_memset_chk=E2=80=99,
      inlined from =E2=80=98ocfs2_reflink_xattr_header=E2=80=99 at fs/ocfs2=
/xattr.c:6365:5:
  include/linux/fortify-string.h:480:25: error: call to
=E2=80=98__write_overflow_field=E2=80=99 declared with attribute warning: d=
etected
write beyond size of field (1st parameter); maybe use struct_group()?
[-Werror=3Dattribute-warning]

And the reason appears to likely be a bug this exposes, rather than a
bug in the annotation. But I really don't know the ocfs2 code at all,
so I'm going by "the error message is horrendous, but I can follow the
logic in the code, and I think the code was actually wrong".

I have "fixed" things.

And I put that "fixed' in quotes, because my fix looks sane to me, and
makes the array counting logic happy, and my fix may well be the
RightThing(tm), but somebody who actually knows the ocfs2 code needs
to check it out.

See commit c06c303832ec ("ocfs2: fix xattr array entry __counted_by
error") which simply makes the 'last' pointer point to the actual last
entry, rather than point to one _past_ the last entry.  So now the
memmove() and memset() in the "possibly remove entry" loop below might
actually work right, in addition to building cleanly.

But again: I did this without knowing anything about the code, just by
looking at the logic.

I _think_ the code used to copy one entry too much, and cleared an
entry past the end. It probably worked fine, because the code also
decrements xh_count, so even if it cleared the wrong entry, it was
past the counted end.

I'm a bit unhappy that this didn't show up in linux-next and that I
had to chase this down. I don't think my gcc version is that odd.

Anyway, it's building for me, but I really really want some ocfs2
person to take a look. Please?

               Linus

