Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A8E2CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 01:20:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A38338E0026; Thu, 23 Oct 2025 21:20:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E9208E0002; Thu, 23 Oct 2025 21:20:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D82F8E0026; Thu, 23 Oct 2025 21:20:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7A9638E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 21:20:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 16F8A129E71
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 01:20:12 +0000 (UTC)
X-FDA: 84031251864.07.5C154F8
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3838680007
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 01:20:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d8UY38hK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761268810; a=rsa-sha256;
	cv=none;
	b=qsy0oHn6kAro3CZ5jTuRpnqu06xhp6Jif82PwrzoQ3toz3YQlVUbiQyCqNLeZpX8KOgT4c
	cFMFj1vtMJzI6y3fUcS4dCiq8K0DIRybLuSuF6zk23v9Momp0km18GAkdLJ0yZd1mOo+yv
	IdmZ5iQvJHYZg78YjQLQsMSCXGZH5OA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d8UY38hK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761268810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cy50PIQ5NMkORVfUN5Id2ZgmraUO4+QWD/JL9v9VhXk=;
	b=nUamW8QoyfdjboqO0ALWISbLYe18epTRNWkWTnOchOosKOmM/YkDZzxjVvQf0sm/7hSQfM
	C/N7TL1OS6w4IRXHU8KszgneOemoyiZTnuEvwUt0iEwZ6zXzWgsXu79zqbRC+4h5MT4YTx
	2yXJmbl9RQsxVl4rk+1938B1Rkp0S9o=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3ece1102998so970049f8f.2
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 18:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761268809; x=1761873609; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cy50PIQ5NMkORVfUN5Id2ZgmraUO4+QWD/JL9v9VhXk=;
        b=d8UY38hK4rgJKh90KZbWnRugp7Siz/sTaGknb6k6RywVNZQLOsjRW14Sn2yU/i4iIu
         najN7d1KEj1qTgBzqp091TxrcC/w8ienROpji+GkeBjzyFqvl+oLnwf5n0bNQkDP6Gt8
         CMkMeod1S/ovf6Zwst6osedJOk4isR2Op4IWFj1gLxIv/xbGRnUjg0h3AcB8vEUUfTLk
         ag+iNZwJ9YKmvUFBX3ywh3g2dcNd/AQZAo+hGOAKafOMSnsw5tuQk7IGAJzFF+7F/k3H
         4zxFpHMDOHDkNGeO5lohf6/9TSGSvoGMM8UEXi3t/eNYlqErUOOw3JVQTuz7G693cpTa
         1FMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761268809; x=1761873609;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cy50PIQ5NMkORVfUN5Id2ZgmraUO4+QWD/JL9v9VhXk=;
        b=QYbXzc9iCzFYqd/uqecvN6/DBO6TiJi2Ws0JG1ixY+LeW2elX79Opdp+DI5LMHZQnA
         6HDMDQmQ6h4/wj+aT+86ZwhJtlBpVtQTQSkB9aF19PJqWABEIWvnxCJVXEQ4l7zVfMUX
         MOf7Jp6oXwb2EYHeIrDHnb0eY++vvGCKpzMNRD6hj1Xo31XujXbFCQ5Drge00cEVjWds
         6OYIx1CU2vQllb6BpoGqCZ6MCOQutbB/8Hxt23pKyL6fp705pSGopjsSejGfE6SIOm8f
         Fiel25LAKM/oO23aCzfURRsAJG5gFwrDSYZ6sybq/4lCr/ogunxrykqLbHrU05cHsXVj
         VvJg==
X-Forwarded-Encrypted: i=1; AJvYcCXpSWZbvtnO0yZ3cUiXF+qqKlOe0o+MEPNjAxhE1h8c0jiRMugsuM3FRhIjK427aiFMPPXb5CjPmg==@kvack.org
X-Gm-Message-State: AOJu0Yz5tRKjStcmiwTDz0WNMrcEhnEFO2w2APcjpHFELYG31xXmoz3p
	9nSehLwNFeAkBhdJX27BC275Womed7ABtBYkTOkJtAOee6OhXOKdrnIudZqsByVN8SnQrq6IqMz
	A1WyPjwZMhfOJG5x2pKOAaNtjtY/tnGM=
X-Gm-Gg: ASbGncv2ewQOxhNwsSBz7x+R/mn7F14t6T0cdJ1NHhiIZVU4NiVzbXqsZLZEJXwv4+c
	rsEwgOWUJjyUQf3DoqhaSou01xp9F7uvUoKOI0Ml36Bu7nONMT8tdXa9XZylRburmx64vv756Fw
	sP3AoHzadrnjPOOUQAzxQRSgYq49HH0jBIXxYPBESDPJYC4CMYUrOt25JkhDlQvtlvnnZO1cc2t
	gQbvLIhKJ/G3sXPisVkL1naaWSCaT3p8HJe+zflyQv9rXVO5/8f2HYeiID3FpRMSdbjukADxrtE
	AZMjuVUZoyHbQv0K7BSlfDMj0qTm2Q==
X-Google-Smtp-Source: AGHT+IFcsv1if8cvL8kTlEejCx/FQgqyt5yCy0bJs0SYJkx4Iq5kMise7FkEaCwdtzjswF2CqR/fouTnY/43pxfDv9c=
X-Received: by 2002:a05:6000:240f:b0:426:d582:14a3 with SMTP id
 ffacd0b85a97d-4298a040705mr2343679f8f.9.1761268808604; Thu, 23 Oct 2025
 18:20:08 -0700 (PDT)
MIME-Version: 1.0
References: <20251023131600.1103431-1-harry.yoo@oracle.com> <aPrLF0OUK651M4dk@hyeyoo>
In-Reply-To: <aPrLF0OUK651M4dk@hyeyoo>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Fri, 24 Oct 2025 03:19:57 +0200
X-Gm-Features: AWmQ_bm41GuiWsYtz5XuMNDIQQhr0EMvmp-bLNyUrjc6_dWg-wZ67Ora4xbHgfU
Message-ID: <CA+fCnZezoWn40BaS3cgmCeLwjT+5AndzcQLc=wH3BjMCu6_YCw@mail.gmail.com>
Subject: Re: [PATCH] mm/slab: ensure all metadata in slab object are word-aligned
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, David Rientjes <rientjes@google.com>, 
	Alexander Potapenko <glider@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Feng Tang <feng.79.tang@gmail.com>, 
	Christoph Lameter <cl@gentwo.org>, Dmitry Vyukov <dvyukov@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3838680007
X-Stat-Signature: skz9g3upyf1qhgowohx9brjsggz1gq6d
X-HE-Tag: 1761268810-629338
X-HE-Meta: U2FsdGVkX19mgHgzRbKF7d9wLEyPmmfiYjdjVgLbB3uKNbZKdvtfK1E6R+FbgCyOhQMDmv/SYeAHYr/5ziHQAHKc6VHNKclv429FfkwJbR86fCj4l1CyxwgP13qwaVpJ4XGOjBCarrgxg31zKC2ENr0MI5PPj3fJHsnHMgonDRp4prPlkHXL6f69E0JGjDxRIQG5hhIgRpaKSWKu82aGTbn/Tyy+0rEnIOjNu7ectFHwWSW54dfNcrgD8N5WHkP6IM5HtDs9s6AJ/shTzqokhzPGgWzZIdu56+yxQjSnUIcZifi/SR00OggmdzG/effYD2nGqm2yi5G25IHqzfo3bIU2brAovvvTBIdgqa6vUzeUe0kur3z5a3LtGlXSLH2KvKP9nn4jqqQrDcxzIX8sIaMVPaXjF3a2HRNZi0XXmPBwGeimSflRIQjqcBL7FquQDNUqtG8GlkH+XLFezXzdv5Hl4T+IP3sXcYkGLCjdlQyVIoKNFx+pWF4y/SN0m+VEVF/KoPGktjRg0pHiNam65qsNSK10Y+Z+3FTXcNvGkb8P+IPbT2M1IKEgVAvxvK+4VEL5TXVoQ4iqXH8xK252YliHRgfI9cW5zTEJKemFAF5JvhTplZ930P+C8CmaWK9AZiPeOSjCOho4oVqW2PkcImxj0enfls76qHaiAhuPaBPaBSyyN8MDKlIr3EIUimxfkmk0yRq97uLCo2XykeqATgYSvVxko8RAJDDQpKQD2uwr6oVl616tgTYa5D+ODtEokBHtA6XAEz3KijbK8V0dJdw8R73SuUAm6lB3vxe1V6y96DNxfBZkztqvQhInelxJAKF5rqf2V8QojW05lz5y8D1pjy0N+s/o6GZ1zQz9VQeFSa638L/xuj7N5pCZooVoRK1PYGlSJvBNwcq2/TlKg2eCXkDGTV3Lmdn2eRWSUGlIlneAw+UTdf2qD9HkDCWp8t0y7iNvPC4FgqGpXtB
 8F7UEsuW
 PaDUnhlaiyIB7cy959Fqz9pvYLNwmeYhEo3LLLCxbx3oC97E6OB22pt8Wk97kcdDnv/thC2eR/hGUKNaNUwLScVQetSzdZSAdaWigx/dYzDnjM6QmOVVKFqXfjKSlO7Sn2Y1HlKUQnjTeFUFxipmAJ8JUWtxkGvpH3YDGQe57HwkeI0zJJNFLK2YZ5SVGFN/4mcI0XNyn6DXDVUZ1Zj2OnEl/D81mCQxlnFU31HVRGzPSPcCmSmNZkfmG14N2AMysnyt1PqY5xdL+WziZZ7GD0RLTUknGhBX5IDJ/WH+pRV049R91UxkBeR9SgtivJ0x2P1Pw9LELLSJ6JIZ0qHnBvXxTCd61n8Hunv6OLVrKahzpYikWhLU7C/Gam2cmBiTSETSEeG4yw0s382nVYsDn7O0BVDg6CGOA7b+31gOyIaRK+HbDYcAXHPw5o0l43OF+yy0j
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 2:41=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> Adding more details on how I discovered this and why I care:
>
> I was developing a feature that uses unused bytes in s->size as the
> slabobj_ext metadata. Unlike other metadata where slab disables KASAN
> when accessing it, this should be unpoisoned to avoid adding complexity
> and overhead when accessing it.

Generally, unpoisoining parts of slabs that should not be accessed by
non-slab code is undesirable - this would prevent KASAN from detecting
OOB accesses into that memory.

An alternative to unpoisoning or disabling KASAN could be to add
helper functions annotated with __no_sanitize_address that do the
required accesses. And make them inlined when KASAN is disabled to
avoid the performance hit.

On a side note, you might also need to check whether SW_TAGS KASAN and
KMSAN would be unhappy with your changes:

- When we do kasan_disable_current() or metadata_access_enable(), we
also do kasan_reset_tag();
- In metadata_access_enable(), we disable KMSAN as well.

> This warning is from kasan_unpoison():
>         if (WARN_ON((unsigned long)addr & KASAN_GRANULE_MASK))
>                 return;
>
> on x86_64, the address passed to kasan_{poison,unpoison}() should be at
> least aligned with 8 bytes.
>
> After manual investigation it turns out when the SLAB_STORE_USER flag is
> specified, any metadata after the original kmalloc request size is
> misaligned.
>
> Questions:
> - Could it cause any issues other than the one described above?
> - Does KASAN even support architectures that have issues with unaligned
>   accesses?

Unaligned accesses are handled just fine. It's just that the start of
any unpoisoned/accessible memory region must be aligned to 8 (or 16
for SW_TAGS) bytes due to how KASAN encodes shadow memory values.

> - How come we haven't seen any issues regarding this so far? :/

As you pointed out, we don't unpoison the memory that stores KASAN
metadata and instead just disable KASAN error reporting. This is done
deliberately to allow KASAN catching accesses into that memory that
happen outside of the slab/KASAN code.

