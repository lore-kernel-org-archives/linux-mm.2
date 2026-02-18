Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 820A1E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 11:41:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98E226B0088; Wed, 18 Feb 2026 06:41:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 911AA6B0089; Wed, 18 Feb 2026 06:41:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F32C6B008A; Wed, 18 Feb 2026 06:41:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A4AF6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 06:41:21 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F22F91C516
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:41:20 +0000 (UTC)
X-FDA: 84457386720.13.2E2DCF4
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0B301140009
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:41:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Hwy4Tryh;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf09.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771414879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KWI2yBEIPJGjVA9CHlFoX3qIQQ07WCxmd9bYX3FXatc=;
	b=wQXcddlRXifq0uFZGdWqVwGMzQkzjKmFejeqn5X0GZjdgVo5XJuI7JkUJlLPDn7V+wNcCe
	msvXkL4gTdIRHWp08+YpZGpfzdI6Ljqqm9GrzmgsJJcUj0JCFnzilEsNH9/GVGSgMxA6mG
	xcv1m41lSlwkMfqC+q9uXdgXNM3djx0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771414879; a=rsa-sha256;
	cv=pass;
	b=Wu3RsBqbMs31b0DyQwtlqHZWQZPQE9E5qrzMbAC+H2yDn9ZjoxRBnTTiPJgcRNR7gwGfZo
	OrFjHbnuJQ2cpY6gLqsw9gnGyUj45hpqp9SiRrGM/mw+S3CwfYwh18tYe9apa90uli9XUs
	7Od+AtiHGwR1z/mUGsAeKJ4ho8TJ/cA=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Hwy4Tryh;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf09.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1275750cfadso121540c88.1
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 03:41:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771414878; cv=none;
        d=google.com; s=arc-20240605;
        b=VbnqVM1/qd6qIBkBz8u7o4/UW0humUVKrM6HHFjW862WyFR2UNV6eNmbIfIuIvvZ06
         UAvYrxSaOE4HZUhquCcN1+XgEuU0lHFW4drSCRLlzhirmhZTdfCwhWzPR6QXMJ90X002
         fTbbBRbgIeqqBEp+q6vBDcuf1StsWx53T3VmZfuUdrD3Et5uZw3Ym3oD9lDajgzYxApG
         qfNKGj6M057nRsmuQYABGrZoOADWg65x5/NKAfJWEOGG3L0W5n0dS+ZKk8bRbriS6TqG
         d89OGgWFfmQ0TSaIzlaaKTkHxK+DEPVPtVFxbm02DVHvWT9wSemOQSv2VQLN5NhJCBw2
         C1DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KWI2yBEIPJGjVA9CHlFoX3qIQQ07WCxmd9bYX3FXatc=;
        fh=VHjxj32KQbiTKg0KLOTBgx7JjOm9nq3So6XRGvxMRDE=;
        b=ghQ1aQ5DvI7h69cBFQ9uCzfn1pR62gujmpMJFMdC7wD7sg7Qcc3o7OKJmtfUXR0f8T
         rKlajxhdxFYdZ89oVZU5TwtTQt0hZi9JomxkK/vLtwKv2+ZZUB3VkiHTJ/okStMR8nnc
         9WDMWtVO9Yyha79iIqvHslriNKdC1wfGSX22GClLnD3bz0a22WROqE05Yq2a5tu+X+Mi
         NYGtG4sJIJhRte45W42JopRpBGSp2GElZjxBpEtGubrdIAKGEP3QspXL0y+F10u9lk0o
         T8tTZoJ3ZWZHWtFjpmZtO8Q08pu3s44x+Giy5zqB8sFGug8jLtbD8bfsFAcET3gmO7r7
         lgrQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771414878; x=1772019678; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KWI2yBEIPJGjVA9CHlFoX3qIQQ07WCxmd9bYX3FXatc=;
        b=Hwy4TryhV3pI1tr9gjf6fMi/z8/faR+v0DXCkX4zCB39zKmY+PWk5r7cA7lDV1drxF
         mpiaZYjDh2JJApzut05i1MZ3naPwnZLwgxaMhdO390TuHjq/LXRTeyz+v1yXtH0UTTE7
         cVZNlVWxmLWl3w8SnrY6DBkVEIzY3lagYwtor8ReLZyyS4blcN5wQHLpLp4X6ktMAYFK
         vOJT5NVMp/wMNF3O5aW5gEirzF1fS5LjGz+TV+bwq3OuNbmtpL9n2Exnel0bUqBOSF39
         WawHYhb/xv8+cPORCXe3D1UXU0RGEiUBNvI/qiPmPAwDz0fVNM+7qj+d+4UQ/JFeEHRw
         3/Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771414878; x=1772019678;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KWI2yBEIPJGjVA9CHlFoX3qIQQ07WCxmd9bYX3FXatc=;
        b=qj73dztySRPA/QmMJB7RfNt0SXnwV1s2VIJb+E/fO3TAmi//8mrip/kreBI2NSGp6T
         KwV9TfHirl179VH98EeHvTVzxjXmiaAenO7/6IUWzcDO/Lyf9dqMQvSf8FtDbr7D3xRr
         Gqk2Xrtn2tZJT/B/g8JuPHO9zmQp554NbguyA2nhphdsxID0pifx/gva2ALLwPYP+Jj4
         6myFupCkSfXjSKkuBxKjizBbs5jGY0xeqtEkJteep9l2lMYLFyfqVSQaF35WzJ57ZMgm
         HUByKD5pEY4yS0NgyjNTWcNmaXxYhh113ExolkjTmlknxAtB9YTBeyqAfcw7qHJljuS7
         TIDw==
X-Forwarded-Encrypted: i=1; AJvYcCXIjJJRwM1ZwbwbXkknfqrZfKigSqnkdEDjJmNMSKwy27vPPDZ2vrgtDG/ISf7t8v2G49jGIbM78w==@kvack.org
X-Gm-Message-State: AOJu0YyuCZnQegFnSZTxz0uujY+pbsvCFKPOuYev2SqEOjkTmIfVpzLi
	5XWiuCDN+znZUs1Oo0JC6Er7ZzJaoYd5HUxkUkmCuuhAX4b8MRkD2opnYg9BKIkwFyK3eHtiAzM
	gWbFVDpviVisnvdH72GDksSMBfxfhFmY=
X-Gm-Gg: AZuq6aJghllFujidBovXNIpum+pRsy+bxH0wOMXqaGdgpME3cKNF2wdS8VdMv6HkprL
	jneGUzgO4qO3e9IryerJ+hBiI/UBF342mCi+b3UD5x94jHqlA7N5UrdTZcpGWrGz97/U7gxnV9a
	N+EeigvPN1YW424jFCTjmQQlL0a/7vx8o/uJe4jfO322sxDADtLH19I4RPO1LywPNmijXNVFOws
	3z9NwIrdupP1YSqreQKPQEscibxRpxMU+tl5AjL/lQB1CtJnaD+2RwwEc16auZXUdDaqSKSahCH
	OIw3GQo96BJAYl2InyK6CWP0IADVHtCpEF1Zx6IvV2U9hrsrKgV9hBTuEwEzPt9NuxriEI7jzmH
	j9X4IhSPVua6qjOokjEVKl2MC
X-Received: by 2002:a05:7300:d709:b0:2b7:24a1:865d with SMTP id
 5a478bee46e88-2baba03c364mr4070873eec.3.1771414877472; Wed, 18 Feb 2026
 03:41:17 -0800 (PST)
MIME-Version: 1.0
References: <20260215-page-additions-v1-0-4827790a9bc4@kernel.org>
 <20260215-page-additions-v1-2-4827790a9bc4@kernel.org> <g4ihY-XQwSZ3ysINoU0v3jFzzJG7Uzonq0b6C-EYEYDx4pbJWHHJ1hYmQsmGATIDzexHv6NFea8YNikY6zXq6w==@protonmail.internalid>
 <CANiq72kovxkiF1Kj66yVyQYKx1OijjtTGB6UN5M35th57UFFeQ@mail.gmail.com>
 <87ldgteftm.fsf@t14s.mail-host-address-is-not-set> <RHTfcS8-6wqboBRd0aNAk2RG-phiMsedyL_E78rwI1FbLtNzmdCAlk5Es1KyQMPV_-KAtJw_-ImmDchI0Mp0Gg==@protonmail.internalid>
 <CANiq72kZQiu9DbQgkHXDDjHORwUdTm7oOhZOE4Tr8eHiyW7RbQ@mail.gmail.com> <87v7fubdeg.fsf@kernel.org>
In-Reply-To: <87v7fubdeg.fsf@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 18 Feb 2026 12:41:05 +0100
X-Gm-Features: AaiRm51hD4BfD-fBvJQ5turW2JocX7sPSRpb2NYOD_IsynfSnDIKMk_bFB-5v0E
Message-ID: <CANiq72=cf=p-ORX6BO8LPhFK06TRS-o6PiYHxcPQhLAkrdCgaA@mail.gmail.com>
Subject: Re: [PATCH 2/2] rust: page: add method to copy data between safe pages
To: Andreas Hindborg <a.hindborg@kernel.org>, Benno Lossin <lossin@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Stat-Signature: dzif8a5wyoe31rspbmprt463im1498zj
X-Rspamd-Queue-Id: 0B301140009
X-Rspam-User: 
X-HE-Tag: 1771414878-138651
X-HE-Meta: U2FsdGVkX19S/VdWabPrvfs83Em/HPOmNy8ywOe3tNdpBl8CZOXf5XrEldZNY1ab35vpotp52nLAFPHcZTkvDgMJe3XuaeC6bA4tE3nTtJJPpDaOUn7fMjXrGFL13yvGQvL6aZ0eNuCDLU7BtGA3L+bOfrrMr+ywAX/cWRVewv0bP2jc3/Z0TqxILSRZCxPbjhFZ58bH4Zy9HWAI00hOaT6AnmCVA/1KQRkzpM4sb/j2NA91ZS7XrWjss+BD2gEdkyK2wnp1thn+vOqaxlq0b2H7BGnaw3ibhES6hV1YMJAAt/FnwYihlu4EjVrOVrV20IFF7e4WT6XgZlq4HdBvrLU7/T4yfaufiVK0HbH9wWSfQpeiVq9G7SM6H7bXRxkIP7Smmqi9DKLWGU3y22xbU/bYB2utQM/qossT6sUXvzM/+9COA7AzdU5bDTcPUejuBod7QCsuj1Y0Ysm4mg4bcP1ip0O392gf+HedgBwNLbDEOfjtfyi3k7CbmsN5Cv0bAM+Af+68m+m0mQJQgRWLniB0RW+FE/bOH+rUw2B28RhoDdTBcBzs1aIIUKD/koURyfpUl1CpJH+34m2OlLWX18ryTu8Fk5MVhVmAa+Kgkagw2KozeyGbp/kTFoIPFwKt8GZaZL/J+pS1/fJ4RMvGCWTcPVllTRQYAgnFdRFEcvtjMW5dgQp0wR84nR0ARexU8Dmdnvpzyvka/Ao7LbjzPBSZ1a9gugj+kNbWDNuX0BMytHOz2tsAu2wWFPv1SZpxT9l6KmRvXNmNHbanR0t6faP9OUxXdOdFdwlPpmZ71Vlp/12IzGZWKJRgZKvpPoP2RnQLRc4KOsYUuPwOJESY9WDIVfxtq7BiWIl4SBo1P74TIpIrMu1xc141mkZwQlaiikMw84k0I3tq2lkOMvTjp7c98h9518qa8pQqmQfffFxerR5Vmlw1y5Ok773LyI3F6TohbaajlMdtg2xDUIy
 f+mgC9VN
 XS7BHip6mPNQCNlga0o100lHGp0EQQEiloj7fvQkknTCjjOH7ZlGO/FN+yORm+YYyJPgofOcPyqUmsR+zGZRk+y3SHsi/jjG4bf7H4iYeZBOPAIfAG0aT3a4Ili9oJFNq88qJMhJb6Gzfow4LF8sB+aKgatNuD7AcFvQLNazeSCq+F6XdQ412INSD0p7SEfFqQMI+XR93q3pn3JIGomedPGiuomqpRUx7Gt8JyCmjLQBMztex4kJQESJuC6sRhw7AKDpu2ucytP+73YpyicHp0SewpC9c9KHVgRrs5lD/pn4d6susib5LpY+025bd/eaWUFUCLeUQRHh02IPdFZnpqOqJY9xhaVx+5Gn/d56mVpCyxl4qdiu0nXR8P533tHArNVwHCIQjMw46sNcDKbUI1pvhvrsdGeJmHqtYiuSzreI9EVyssJlKAjIXyfWnlvl69zff2KWXH87V7Do4VH8k9HxmSblbUDI93b7UsI+sO5Q+5rAmEgXoACpE8X6/pe7FVQ1n5AaF3NmLGOU9vz6Sh/k7swuDcX+dBZi2UlGLYipYcsk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 10:37=E2=80=AFAM Andreas Hindborg <a.hindborg@kerne=
l.org> wrote:
>
> If we picked a style for documenting argument lists, perhaps we should
> add it to Documentation/rust/coding-guidelines.rst?

Sure, I will. (In general, I recommend following the overall style,
i.e. only 3 places in the kernel use such an argument list, vs. all
the others we have.)

> I disagree that the bullets should be swapped. The second bullet at the
> call site:
>
>   // - By type invariant and existence of shared reference, there are no =
other writes to
>   //   `src` during this call.
>
> Maps to the second bullet in the callee safety requirements:
>
>   /// * Callers must ensure that there are no concurrent writes to the so=
urce memory region.

Ah, I see what happens now -- that second bullet is not in mainline,
but I see you are referring to this one you introduce here:

  https://lore.kernel.org/rust-for-linux/20260213-page-volatile-io-v3-1-d60=
487b04d40@kernel.org/

Is that new bullet needed though? Don't we already exclude data races
when we state "valid for reads"?

  https://doc.rust-lang.org/std/ptr/index.html#safety

I asked Benno about this -- let me put him in the To: so that he is in the =
loop.

If "extra clarifications" are needed, then we could put them in the
safety standard (Benno already has a table there with the shorthands
etc.), rather than introducing redundancy in `# Safety` sections which
can be quite confusing.

Cheers,
Miguel

