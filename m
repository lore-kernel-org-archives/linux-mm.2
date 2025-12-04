Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F60DD216AE
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 16:41:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A4666B00BE; Thu,  4 Dec 2025 11:41:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87BD26B00BF; Thu,  4 Dec 2025 11:41:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B92D6B00C0; Thu,  4 Dec 2025 11:41:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6D75F6B00BE
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 11:41:03 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 42441583F2
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 16:41:03 +0000 (UTC)
X-FDA: 84182353206.16.7612824
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5957B140005
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 16:41:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GIZtFvKy;
	spf=pass (imf09.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764866461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vXS4+o2Fq+EVRwWvGJTitCnGquHusQLvUPzYznKmUto=;
	b=UvMz9PKqqQtmMrlu2sgJUtAYbNfBj9m/TKeN1QDxHp9DyoDzYYlN5Pbr5o9OyO3SORiRfi
	Pq1fjomufXtOICUqrLegAJ+r4Gt7qnxrtVV6Mxe8WjsxqA7KF9xYFzxwg1kJ3ZjINTApIh
	sYtwNabqbq5H7LzacD6zw3kIfDyhJjU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GIZtFvKy;
	spf=pass (imf09.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764866461; a=rsa-sha256;
	cv=none;
	b=5GgKXb3VAOctPPdzgfbnS9TNJQn+FCxSPGyDwyHUjEGp1JcmI5UAixXZmqhSimn6hKH+T1
	PD7V8adT2tchldXf6284xbYqsEVu3oHC9PksA1PKhQJ4M1qZOw4UGphGxiwynqvIazMrMN
	PYzlu1Q0VwyMU8gbZs6lyEYmTo+JVnM=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-42b3d7c1321so740368f8f.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 08:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764866460; x=1765471260; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vXS4+o2Fq+EVRwWvGJTitCnGquHusQLvUPzYznKmUto=;
        b=GIZtFvKyy75+reM+J1vsQXe+G3yYe5fV5TUM6t1hz5SwXuhW5jrPGdl6Q0Ke2jkSaI
         vv/urXyN1F5+D05OcZszH9TtdEawJJ7eUfl51Ndx8knSR2c+7b+d4gfAiOux+0mfKb7L
         kkpGQNx0ju5r0TAyYbIpCRNlbBus1JATRjcMbUFRQ1KCmd25OzLKcQBqM78INlKJhvcQ
         y9eXXnCbfEa3dWmBPRvJ1NnJyq9teHHik0TEvvPB0IKlEMVFflMFIOv6nLBDJHXsL1+l
         WgVsxDbsbdFF3V7ErvS+Ffi3Su7bjNfX0BarPCQ15Y9SeRU/mjjXofLq6hQLDTKOn+//
         77mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764866460; x=1765471260;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vXS4+o2Fq+EVRwWvGJTitCnGquHusQLvUPzYznKmUto=;
        b=auyWKHhudbOX1zt6ii+bFZ9B9rgoOLmNH6LSqEVlE4/KRDxcvS7NvcWwcpnG9tzGAT
         /bcNyMM6H1FnQpWPQZWXVLhjB5Zcu1VaAa6q10mpTHkZmMz1GIltITmBXOi5zVX4duAS
         AZTOhCjrN2UzxGf8svVjVn8blYmk5ll8cixethjd8+RLF4zZr+vGQKtRI8ITLwy/efeO
         fdXRr3BZC7qFhvQ8fZ+yAtAbgDlKsXA2erLi0GpDz2ev4pbhOIksdOtNPipKN/E/cMU2
         liVvH1Z7h9m3UcuKpDWlvDRIPBJ+qBEhojt3UvUtR3D9v1Xzsj9h8Eu6uKrDbm6gRCwQ
         6/vw==
X-Gm-Message-State: AOJu0YzQdxz6WmoZ7uCvAjRnhU+yQrZSv1m39sditofwpvRU5y/X6KN0
	uEerol5Fcvq5kYK5tKBV7BwqQrznP1Kw8Wj389U43jeFGCPVgkWKl9sqUi5J+U8LE79DvR3XX27
	4HwmT4ajtrzBwsmdnL6NL1bDEgnpdjbE=
X-Gm-Gg: ASbGnctnQ0Pj4+x206jJ3PCeflr3dEDp3Jr6iZwDaf4MkjVQur0kVqa/PPdqS0JwZhi
	H2PVSmyEzTMy6R7PGkuG6DC3bz3X36vLmKpLjzhz0kU8xFV64z5+vqmcoULqihIWioBkrqZ9/8j
	TbEeZCcpMDp0+ig8UR/UfDR+w/i2pFm+Hch512VqyXxIiDbLkQxQ55IcD93Jh8yMFZXplYvrPDb
	mH6xtkDRpX4H/gssHJ+L/KWNoxS5aOIuEtVnY11hetKN3t9BLsrHpcrW9GZSQHWqypumbV+hCeg
	liF4JtigfgB11g0KuaUKBgdq5Dth
X-Google-Smtp-Source: AGHT+IF14EPNbw0mdpWV5SBluMRzFazpxK6xkz22t/kSoBSDcMkFk+7hReZ/2u7DRvKtxZQ8Xd9AGL3Y1VECoWoltus=
X-Received: by 2002:a05:6000:4212:b0:42b:3dfb:645f with SMTP id
 ffacd0b85a97d-42f79858038mr3500253f8f.47.1764866459724; Thu, 04 Dec 2025
 08:40:59 -0800 (PST)
MIME-Version: 1.0
References: <20251128033320.1349620-1-bhe@redhat.com> <20251128033320.1349620-13-bhe@redhat.com>
In-Reply-To: <20251128033320.1349620-13-bhe@redhat.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Thu, 4 Dec 2025 17:40:48 +0100
X-Gm-Features: AWmQ_bmxfZbuU8zhqgeyaLqAy9mjVXVUUmOMRc0g7rdfnIXPuRMuopEGEYYo_ps
Message-ID: <CA+fCnZfw5V4HqHepJUbH5cFSEj1G4yvJMb=1Tjd_7WDBP7uUfQ@mail.gmail.com>
Subject: Re: [PATCH v4 12/12] mm/kasan: make kasan=on|off take effect for all
 three modes
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, ryabinin.a.a@gmail.com, glider@google.com, 
	dvyukov@google.com, vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, elver@google.com, sj@kernel.org, 
	lorenzo.stoakes@oracle.com, snovitoll@gmail.com, christophe.leroy@csgroup.eu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: h44zac41b9q818yszqtzi38fm3ioxrww
X-Rspam-User: 
X-Rspamd-Queue-Id: 5957B140005
X-Rspamd-Server: rspam09
X-HE-Tag: 1764866461-526056
X-HE-Meta: U2FsdGVkX1+LbmKj7+J/WWYE6HH3L2uE4Qxk9Gu1QsFdpwKW5Ml0OpGhOIjcKbA8xoWkVmFUB0qluYWCs3X+RjP++81AAXwP+kjFmSqd6JILMRfmoSHkeBN3qGqBjQc+jLkZvtZ+2qopmkznvRokYwwzd8jwLdKHuL1GF9LMONCaL7IDKjSzXVKoqpK/I9cQLDL6mGy8NtVwTuFSHpmX7RadZs9yYxrP0dLx9QDEuXHOL0l8hq3J++VG/9954LOS0kHwUU6XWNRWvAXcttjPu+kP5cAdli/uYSeC7de2v2wwbwYK0LJ5EkwEq8QbKpNTDJiIZtG22U4bQO3yPk9AIXxg/eRKxTukcgIUq2K12ydyMMM2k5B8shGnAxPNuFh+GoLd/bsRaafckesIe2L2TyjNWIJzDfb9Kg+4/A0t5IIvAi0CE6whXghACVSD4D9WQLmFXmic0SVl21MCaihe8lWiOBbcaY5g4sQkMgnF/fZC4hYsa/KieaFJumSEGcHm9J8SL1htVQ6RQf6AwQyiibhw/GOtN5TiXH/GTZeesG7BDUQ8tIyx4OyRVcn1kRfPwRc/VIPQvYGcWiT50MF4t9XGDZuVAXVNfShVIetHAMOKl+pj181UpISPskd0Cj4dCyeSz15+pUXIThD/60CgwsmaNEnU686OZOr0fcWhQgFrER6XzHN2CaPtmzEiZRI5O6ckoTj1koFt/pQ4bZMzFCoXN67wDVKmt5s3l8ouFAho/LIxf+lCRwEB9hopE0QFXjyUf+6ZrtBOjWvrBl7mGXInXuS2omoDAdeM9b0neg3JjlE1u+cEJAZs0c6Y6MTO1l6eLV2Whzx1Ud8N81/SB1J+37nuOWh5B+7j9SLy+M+rR2FlekA1vNDvpY+4+MP6pbkPNIUKWK+9RScYwbRQS6Av7Pq7oWwnkY9mhNKDIR/57Q1Ud0vA9Hf0K37Cb4IjaufNGZh3FCF5Z5qPVmk
 CUPUhmZC
 Czh0ViNb2VgdUYwTbpNHjdnS//tgCuInqAF6zccdP5R7CqHaeQ90M1ovstpZMNNG2IM82S16/sPLhBgKUY4tZBQZevi0I1rdF/TVp5dgcNBd+kNBJPy4RZK8Jj9/siH66oRHiHfdSKLrsWdQyJmCmk3NZx1Lqii1rRf4sl3cV6oOWV4fHGO5Reb/ZhGz4uoZ4Oi+4ys7pCNKG9zV9TgY28I/hQzxM8uANsQFUTnYbM183kDN3hydOBe7O0h3B+JsLPE4TItB+MEWmu/uBl6OSfPCmM8O/9M70Z9loMXMGSw+u2LPmqrTgCCwJxGPAoK+7OikS80sVQsMVpajbwxKnxmK7w7Ipgksq9rPDd/wo0LYeb2LYc8OCCgeLSSiyxa6uAlKMTg4NVs0a+HTjIzMObpwWN4CbJBfdWEolZKlSpUcSuUP/U56OCN1Av6kw2G0xp4RtqRyjtlgV0n/x7ewBhteshFnJzWT3saIXOopir6r+TLRWZQOL9gkQ+am3+UCRFk80YaOMwwLl+U9J26c6EQuBVP4nWUiqjvm5XI7kiC70SZ1bvqnP9vhTGcJLIJfUXiMW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 4:35=E2=80=AFAM 'Baoquan He' via kasan-dev
<kasan-dev@googlegroups.com> wrote:
>
> Now everything is ready, set kasan=3Doff can disable kasan for all
> three modes.
>
> Signed-off-by: Baoquan He <bhe@redhat.com>
> ---
>  include/linux/kasan-enabled.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.=
h
> index b05ec6329fbe..b33c92cc6bd8 100644
> --- a/include/linux/kasan-enabled.h
> +++ b/include/linux/kasan-enabled.h
> @@ -4,6 +4,7 @@
>
>  #include <linux/static_key.h>
>
> +#ifdef CONFIG_KASAN
>  extern bool kasan_arg_disabled;
>
>  /*
> @@ -12,7 +13,6 @@ extern bool kasan_arg_disabled;
>   */
>  DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);
>
> -#if defined(CONFIG_ARCH_DEFER_KASAN) || defined(CONFIG_KASAN_HW_TAGS)

So do we still need CONFIG_ARCH_DEFER_KASAN? If not, it needs to be removed=
.

But if we only allow kasan=3Doff for x86/arm64 after all (see my comment
to the cover letter), I believe we need to keep it.


>  /*
>   * Runtime control for shadow memory initialization or HW_TAGS mode.
>   * Uses static key for architectures that need deferred KASAN or HW_TAGS=
.
> @@ -30,7 +30,7 @@ static inline void kasan_enable(void)
>  /* For architectures that can enable KASAN early, use compile-time check=
. */
>  static __always_inline bool kasan_enabled(void)
>  {
> -       return IS_ENABLED(CONFIG_KASAN);
> +       return false;
>  }
>
>  static inline void kasan_enable(void) {}
> --
> 2.41.0
>
> --
> You received this message because you are subscribed to the Google Groups=
 "kasan-dev" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to kasan-dev+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/kasan-dev=
/20251128033320.1349620-13-bhe%40redhat.com.

