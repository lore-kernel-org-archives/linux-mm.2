Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FFA0EC01C4
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 10:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 011F06B0092; Mon, 23 Mar 2026 06:47:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2C506B0093; Mon, 23 Mar 2026 06:47:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E42296B0095; Mon, 23 Mar 2026 06:47:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D2AEB6B0092
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:47:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 901A6C34C4
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:47:07 +0000 (UTC)
X-FDA: 84577000494.23.B276495
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id A417180006
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:47:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=th7l9oaM;
	spf=pass (imf02.hostedemail.com: domain of nogikh@google.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=nogikh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774262825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J4sER2GrGUkt7nT+8pQTI5YrRfltUa5SSK35UZE2tZ4=;
	b=0PXx0t7+8eqdJ15oFd2t0w1MKnexQWM3tGD4LSga+YLS1/D+2p7vVo4IIfn0nNFfpbbfcb
	rbKJnJDvS4Ofc60UIsIKYdMQ6ymkAHSVsp9BqSfzHbbultCiTXsHavSbET0aTKgEWFYyYA
	PgTkxDU/jsVcUxHADk4H2b6XTjT2nnc=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=th7l9oaM;
	spf=pass (imf02.hostedemail.com: domain of nogikh@google.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=nogikh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774262825; a=rsa-sha256;
	cv=pass;
	b=cAftSkEWcqV4kT+dtlH/nwCkQmWRybOjL8INi++UA3B/0wJrHMJPey/CJkfXHj0gYegVtS
	dWd5N6niM3GzmIqEGXdvw8bUOn3IxWDACZBjKO5scIIGOd6dQYm1/x/ifb0rW/QhnQZFfp
	cUEPizt+MSOyUsCRt2EB6K+Eply+E3Q=
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-467e8aaa865so15559b6e.2
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 03:47:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774262824; cv=none;
        d=google.com; s=arc-20240605;
        b=N2ECUuU4vlZJj/oPtgb0blwMo0EX8yjfmVXTMNysADb+0qVle1oWBenm9LxLFHoo8G
         9/jXJ75Arz63EIx5SLUIBUOrirmzQIxjja2EXRcffc6IGYkfeqahxtgLT6WY+iBiTw1Q
         AOCPr1UlNv1R+YDTWpG3DGHGqu2b3vQp4mzJH5lM6yP2W6dMJRhGZIE4u8Bt/fPxI9YH
         1otN+yP65chlRi3SMvdenNNPMASUHqyzLdD4oBCKbNJEAs21X4YAS1F/VM6KcZJegHrj
         zzduF7G7gxed+qUwZ55YGQQcVDRUN1jN9bDiFNg8BXYU/44SVZboaN1nTGIXGbTZ10V4
         gxrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=J4sER2GrGUkt7nT+8pQTI5YrRfltUa5SSK35UZE2tZ4=;
        fh=SfoIfq+2pugOx0riIfmC4E2VRkAw0LMZ91J3nlpyIbU=;
        b=IL0QFq3KVDQPzD6Y0zGo6CzlxcczjI43RHlXfQXCYMKiu/bc3jzEi6G83a27RytliU
         q35Y9xq+S6DSejwsPfRXC2Bm4u+CDFeKm1cvhjd7rtzTi+9w/7aTn57NF1TNTmtH0bXx
         aNB8oTLBn+ywiMCFhrHC9KYsWZZWvsKNbqQIxXDXY1MjcTFsPgvhBWum17Pa+KzQ5uT6
         lmCf6/UDsqdK+Ke29jX7Lv9ZuglKwG5MqhWUnHWawLT5rltpEHTwQY0/x65L6zUgYwwg
         /16oGf9KXT8X4JCLueIoaPA84KgLnu8fRGYg17EjhzOsVZFcDr2LuR8pXaDwRBsYZ0DK
         fgKQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774262824; x=1774867624; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J4sER2GrGUkt7nT+8pQTI5YrRfltUa5SSK35UZE2tZ4=;
        b=th7l9oaMWGPHxs74D6QQ78RSCdN7Gyz2QIMVgjqjPbAFB9+umwGSNhebYxPVfBGbRR
         dqv/foPoQf6syL85d+S23kpgjyW/OPWlBhhfnG/oKHh65sGFtJpv5M+RWoWGOGTO+/vP
         mpfc8fmZOFOOBPlVnIjXPpqGeM4/0ah5bqrPXcc4CaGfZJuzsldf/n0AG/c9aF2Oob1/
         Dh/MwQykUZhR6TUtBK2LOxbU9SCodJR60MurSoPHCsdVCCNeBskcZ0/B9N3ypeGWN+NM
         e2dkVpOCKBuffsN3yDBDjaEqXvQaXvC3dhS3T5GkeKh3XtIRl2gJ18Wi6UzlEbxeMQvR
         GYVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774262824; x=1774867624;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=J4sER2GrGUkt7nT+8pQTI5YrRfltUa5SSK35UZE2tZ4=;
        b=RT+i7vnDfEJBqEUFoX7RPE9c++0EylDoY1eYdsJ6T3/F9pLP7hhLKZXWp+h8TLxGWz
         fyoe/cJDlmlxyR2hiDhyxdvoEOpN34Z0tiIX4axTjgKybmEX5L5kp9HNkofHF5Ulhgdp
         00aTEw/ApKUkXAHxSylwpAFDiD+bo/pAqgmgt3M25JDVr0QVScXlHcHAVQpugP2nd7Zt
         BNgwMSw/kTSjYOEkEDroyoYNi9NbQYgKST6pAb6eaXfEq6c7Q1eo0DWOlKZWvHJ3JpUm
         qkhoEwd7RgVezObNgvcRG68kzBEWRM+SdegTN8fav6UwkoJZbVEZkmY7kdGuFow3Rl/n
         /8YA==
X-Forwarded-Encrypted: i=1; AJvYcCU3+apaPlwsp23nePbouS3Gw2sWoZhHyDVnib5uyrxDqWtFYNUPeB8WcNQLKvhMTidNd6u00MomRA==@kvack.org
X-Gm-Message-State: AOJu0Yz1WvThOS/g1HA6T/XIDKIiuobb4Nly05mOY58rDNk25FiC4zvn
	B6bP7RYkNADz1FV+TDTBTY+vGRQWs/SLs11rJ5pN8yb7cPv9abn+m2eDGog2cyZNCBmYvc2FsJC
	7uYNu4uSj/lK6rPWs6JUl8Q4K5sbBWo6z/B2D/+sG
X-Gm-Gg: ATEYQzwos+DY2WrfJXufUefGATNQXt2QrTcFzdPBwu5eKWmUZN7q/2Rv7I5F1hGfh2a
	jfqEh+NqUUZRHphZK/u14j7rir8TUV/yh5/TtoDu2IFJzKVgDZX5ICmx+GaYbQ09J0Lf5LcJm7P
	RDQdxEb6/mM48cIkla6ZCu+hLswKEm1YBBRnv8m2tvvKSZmTY+ool1h8OMi60+3UEsQhoM8aXyq
	x1FYOsh+9ONqTZD6UNOlI+Pu45VsI9+XsQxNnhIj/1aBjNGWH5jX2gwJmvXL5CTdGJgRO/rC3Sk
	d44xZnMlF8p3SFQt+V0+/pchsXPoXvK/2ygO1aaXTl2GTqXRtsK0iDcw0NX5qYvWc7Hlkw==
X-Received: by 2002:a05:6808:250e:b0:460:f435:2a71 with SMTP id
 5614622812f47-467e5f481acmr6504629b6e.46.1774262824231; Mon, 23 Mar 2026
 03:47:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260317220319.788561-1-nogikh@google.com> <20260321170841.179ceada68dc55bb22064fda@linux-foundation.org>
In-Reply-To: <20260321170841.179ceada68dc55bb22064fda@linux-foundation.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 23 Mar 2026 11:46:52 +0100
X-Gm-Features: AaiRm52rx499ExyTFO6GE2_kFEksIg4FROgrnFEqj1WrKjemMDutkpP9UTsNmNo
Message-ID: <CANp29Y52fCeN_niOZsk4dWF66UNXt3qyimam1MXyEp8RiehYhA@mail.gmail.com>
Subject: Re: [PATCH v2] x86/kexec: Disable KCOV instrumentation after load_segments()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: bp@alien8.de, tglx@kernel.org, mingo@redhat.com, x86@kernel.org, 
	linux-kernel@vger.kernel.org, dvyukov@google.com, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A417180006
X-Stat-Signature: hbjzjamqdqmbbhrfh64sen3jt5qiyqky
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774262825-42645
X-HE-Meta: U2FsdGVkX19nt4N8ajVn0Wh0KH9Ons0Zaeioor3wogL8hTV2sqh9z/lRboBFDjyPiWINKbJNtgx97dIzpCqU+m/0hCwUL4Vu6V6K1INKfZTFAvERQSJxLGxpSp3kCM2JMVZ26R9MsGkh532PT9Vn/EE3adgT095QYgEKj6Nhdg1vuujRTilKs3ciG3a7yu38hbT/yRMTSNtDgQ/bNbwuNm5tlNi2NKJB/lZ/gMdVgKGVlhovZGrO4j8jrXZ4pQ1fft+KnhT2ZQEE5V0soZR1RaMq4eOVqpqysJOfhMqPa0hbS+GEhaoe7M7WfTDUHxl1wTNv31vJANTxoTUlf7trKhmbxprTPDFfe6TwcOfYF0PmP4p5nnWv1K7j9KzVcZFUzRLbY7FkjHqgxrbIURArFJmKiAPEQ3hqhAa5YG25xk3VDOPIN7CQcu/6ciWr0mZA3ueVn2Bu8xhd7i6p/ISykb8589rvuK7/DKBlaURH+5eKB0x0sWEgDMmlVEMAIty85Qg3aKoWdSF/FAbOi07Irx10XK4x1xXwo+BTtitOVD5iqB8diDtNgtCKjzWEGS716Gk8sL/SjFszSfE7rnkRs6zHAnlIv4tkhFE674LEX8QIegBDogU7szcZ6I0tVxwBGZZO+YDIxyZuFLWSyUJKcA1ktCWzQvXYjg/aiQC7/zjIsYyrgYZmQz0LwueVf22XaQcHeJ59Ox1S+XKhxl707W5EO1LYX1/HdfX70TuTTuEZl3hrQ/r+28pLOcFDBUo3ERRuFcUq+QGoEWNDebxZh0+GcrwciPjYKmKUm6ffx97FSk4FhdoyW5I6b5RuDpiRmGMvSvemOQC7iTi0YnEAyVaM7DP5PCxnvXkFkUmhZPIIe/nbr2GIPJJ8U5kKG6QgMUWqLgkQG4YtfRKgHmwdKzYz3Ow4SCcOCZVDyfn8RqtLQ1gjGzVXwuzIuTKq1+zT9jA5Lm/5NqgeVgLWbND
 QSmliDWG
 DV7iy6p4xP5L3m7bX6zYbJa8+4S4TeoMjtKmrYw8J8IRgTAfLCi0ry0tDcp1vPzk34YpWr7fgseaRPGVHwenyr62o3w8jHCZF04mtdvTWIW0eBUo/WpnW50KExgixmsm0p4pOyDwREREP9EvioKGrqaOZgV3o4PKOcg2nIdknjlSjeqbX3eICrJIrYwBIKluy9Nozz6FI4p/gNMYFSpP2V7XuuJ4jDQJfOo/ca0cM2hygyY+t++/SicPRcDXUSAso4HMYuPQiCC7t2x3EONjGkx4AGD/mD112tfu66b6GIVRnzzULJJlz5ISg132md6/ovQJ0D3Q8YmyzSMFUa+R2VK8ougv/wsOXTLHeZ56eESfbkRyn6VN7AyBfM9xuF0SzuFIo7m9UEGlqvs7HOGXwNw4E7DiC/aTlf7RH9RR77aoMTj0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 22, 2026 at 1:08=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Tue, 17 Mar 2026 23:03:19 +0100 Aleksandr Nogikh <nogikh@google.com> w=
rote:
>
> > The load_segments() function changes segment registers, invalidating
> > GS base (which KCOV relies on for per-cpu data). When CONFIG_KCOV is
> > enabled, any subsequent instrumented C code call (e.g.
> > native_gdt_invalidate()) begins crashing the kernel in an endless
> > loop.
> >
> > ...
> >
> > Disabling instrumentation for the individual functions would be too
> > fragile, so let's fix the bug by disabling KCOV instrumentation for
> > the entire machine_kexec_64.c and physaddr.c. If coverage-guided
> > fuzzing ever needs these components in the future, we should consider
> > other approaches.
> >
>
> AI review has questions:
>         https://sashiko.dev/#/patchset/20260317220319.788561-1-nogikh@goo=
gle.com

Regarding the comments:

> Does this fix cover the CONFIG_KEXEC_JUMP path where execution returns to=
 a KCOV-instrumented kernel?

It doesn't. The fix only covers the main kexec functionality because
that's where the problem manifested: on syzbot we only use `kexec -p`,
not CONFIG_KEXEC_JUMP.

For CONFIG_KEXEC_JUMP, it should be (hopefully) enough to disable the
KCOV instrumentation for `arch/x86/power/cpu.c`, but I am not sure if
we want to also cover it here.

> Is disabling KCOV for all of physaddr.c an overly broad fix that causes
unnecessary loss of coverage for core memory primitives like __phys_addr()?

Disabling the instrumentation at a more granular level would be more
fragile (this was discussed in the v1 series and mentioned in the v2
commit message). When preparing the patch, I tried annotating
individual functions to resolve the problem, it was quite a
whack-a-mole..

Regarding the __phys_addr coverage: so far, it hasn't been super
important during kernel fuzzing. If necessary, we can easily
reconsider the approach later - for now it's just a few lines in
Makefiles.

--=20
Aleksandr

