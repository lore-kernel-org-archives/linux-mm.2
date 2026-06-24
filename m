Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12F40CDB47C
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 10:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFAAD6B008C; Wed, 24 Jun 2026 06:15:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A700D6B0092; Wed, 24 Jun 2026 06:15:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 960606B0093; Wed, 24 Jun 2026 06:15:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5910D6B008C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 06:15:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BD47DA02A4
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:15:10 +0000 (UTC)
X-FDA: 84914398380.30.03511FD
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id B36CC140007
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:15:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BqQHRtvC;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782296108;
	b=0MbFhJxUEnNI0XXLtwaWBSFTkOmIRDiY5Cxk3pWRkJbmkDqAewurBlEkLW2ZbILSSMOsR5
	lh7G0Uq/NB4RMpu7gCnwoXFrkZ4hbKcmNjLmZIhSYcLkxaeodeLGtbdvmNFTF7FBlxSH7I
	6Z2YiGc8BeFZi32diRb4YopKv9n1D4M=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782296108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KV6fDYDT6hl+QyYHewqH+8z5UlmxqwcZYogbwstjfWw=;
	b=TCxENLEITRFED/oYAEdYOtF0qjuW7comGrPJlzsFhOKgKBI3a149hHApbE4bcTWn5fDF/O
	NMKM7mReHBV6OOVX7toFd4c2P+5lDarYq85REkyYwJ2zO5l7JmVVFNoOcBAywUhHpR0LCH
	5C0KdZUabDNNTtKoAgNfEGUDwkYDix0=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BqQHRtvC;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c07c67ad9f2so118648466b.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 03:15:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782296107; cv=none;
        d=google.com; s=arc-20240605;
        b=Ozrvwpolgwns69MxGOT0shBZhYTMruNKYsX1FPIAjvn4TEU0nyg5okM3jzsV2d+/qT
         U0dut6uY1GpR6plNDrhJkG9kaS+dGJC2xjfd0ji4Cu6quMgeoMjBI25x+HwrO9cgYZTj
         CELoKVqBcAjk1erCrgBACG7PWQCT/Gjl+HsjWqhe0b3ekQ3VnUtYjXIvq8c8RZdKOwTw
         01jJ8NknMyLtlJgC7e/ParRRaLOxrLMalADZg5nZQeMEv87TsQL3HiYnCMEQQb+b6RdQ
         UUGRM9jl4H4moFLVZJzATMUUty3XP0N1Rkf2nHyHQFJfT4IRDvdmfsVd7VkxxCCp4qwj
         izzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KV6fDYDT6hl+QyYHewqH+8z5UlmxqwcZYogbwstjfWw=;
        fh=HyfF7IuKtXNFgSJXgciqQRyHnPvRCjzNWQkFXGMKnPE=;
        b=aejWKVsRlEXJbGKESPz04MwE11jZ/E6QCgRvlSvQnq8IlBpepprAk/QvNJ6foUSIzm
         FFKwyA/IhWTggosu3p/cDXszTXuwuUAouDxNgSNkzbAjjFUIGbsD83bparrDqyirkwCC
         MCtrGjtgW6uGuYl9+IYTGk6itXJibILBq2xB65nH3uRNAae7aOSz1YbqqjbcROGR+QFl
         KliFNATK0BrcSRMAVI8ftphuvDblqiJEze/+eIgPy8Hb4SoRezqXitXVo+BhArNkBxIo
         sfRO9/lIC3evpC75c7wsdolHGo3vrfpytMhSJ3HarsayjffkKUP7E+cykUiC/AqO8w6l
         ohoQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782296107; x=1782900907; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KV6fDYDT6hl+QyYHewqH+8z5UlmxqwcZYogbwstjfWw=;
        b=BqQHRtvCOHKX8Ecd/Mqbpq0g/do+Z2t9aav6F+I7853DyGVqyZNVZ21Y4DGKOotnV+
         NuCtX2a2Tn/6bWRbWEuiD82sl0yvzCyoNVUUAbl39yf6we2Mr0BD6MkWRBZEtuiftW03
         BHEVVmuPW02oYH60Kf0NHGj8lV8dCEb7l/uRBJd4onfB/zbOwrZFvQDlgjGKQ7A4RmWL
         gvIVocdnlLfjJTdQDJVjmiKgNNiW70VKo7t0eIG5OnR6ZNwU21Fjz6uWMHLkG1Kw5gvi
         GC0gi2JS8WN738OijYGylP47aPXK0r65GXFxD1YXXJRa/E6SfU17wEDwKu3CseO1lc93
         C31Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782296107; x=1782900907;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KV6fDYDT6hl+QyYHewqH+8z5UlmxqwcZYogbwstjfWw=;
        b=FzHDeshHj8eyzSm29RvSWYlKECMaLO0hBMzOLg9NBujsa35XNbzJnkGJX9pUtvd6E5
         NHwUb56rVegpzV8JKiWIwL1ua606loRCAZUwuyt+mvXR9FbyQ7mbQgssD9kjVK8Ms1ut
         J3w9t+Rl8YjflM6CmwKPne/KKt5OGApTPtUNhWIUBa1DT8upFi/jXnCHrl3pzTHD3iNN
         Xys8Tm05uGHbzu5suYsg9qYoJhvGdhENKFw+OJC9zA4FuiURsdx6MHOYwGcJbdf/M2jh
         Zz4XVGYrtVzOrRYVY1ZetvlCQkOVrNW0+gQdxweq+ltCZWEo5wq5PPJuXd4wn6pln/HA
         soLg==
X-Forwarded-Encrypted: i=1; AFNElJ8ZZaV1AoC09lEDhdJNrkHkP1802IfdpWZC72I+eGJRbLJuMTP4GACCJ1KZUG2IEfz6nNesBfZ7sg==@kvack.org
X-Gm-Message-State: AOJu0YxWfk4uDD7I7CN4QyaNbUODgrS7sq0t28OlwW5NUcQHpdrmYiGL
	NbWLw2f/Bg5hT8+PS5GAU5AR79BMzdsAfOUVodWmiQO6HLEGceyyLlAqwgvxGe+khqz/lJQmRDE
	7m4kvfbBKZ5A8HPu8WDXnFky/Afmc0xg=
X-Gm-Gg: AfdE7ckER86AH4KMxFkK7hDbpDyLzMmffSe/yE7m+/Yf3iziu/+rf69z8C6qVx/kZe3
	S0ld0OaKR09dJR5u0QaZKmMgw8OpJ4THPfF0cebemswva9FRN9+dbCtvHBGyZSDCsIFVhX+D8UR
	PUgBjAw+gYMy3LWI2OGpKiuWQ+U29ZWnv7/8bemPBWEqLK9wgEUzA1aK2PnNHIsWyllQeE6NYFt
	Uc4Q5YHjB+oXV31DPD3faA1lDPcP+GLjyg8i/2VXNWxL48Qp0049VbYgJohkL9wFgD15uoXVCqu
	UT5ItSm+kGyevAVPH1fGIhFCI34yo3XMqTGyArwx
X-Received: by 2002:a17:907:9711:b0:c07:6a7e:3a3a with SMTP id
 a640c23a62f3a-c1030ab2266mr427966966b.12.1782296106768; Wed, 24 Jun 2026
 03:15:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260623231635.43086-1-baohua@kernel.org> <20260623231635.43086-2-baohua@kernel.org>
In-Reply-To: <20260623231635.43086-2-baohua@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 24 Jun 2026 18:14:29 +0800
X-Gm-Features: AVVi8Cc6WlHWDKL6uE8pLXa5bohzoTjZDSAuYWQguqEUzcOOj0rvUnmnT0wVcI8
Message-ID: <CAMgjq7B1-wVFCRLrB2A16+oMm2pYead-g6GbryLwGi4yjWitrQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] mm: avoid unnecessary lru drain for wp_can_reuse_anon_folio()
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, baoquan.he@linux.dev, 
	chrisl@kernel.org, david@kernel.org, jp.kobryn@linux.dev, liam@infradead.org, 
	linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com, 
	nphamcs@gmail.com, rppt@kernel.org, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 5q9ypmgpt6b6yqoxhdfkpmi1i7etwc17
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B36CC140007
X-HE-Tag: 1782296108-585300
X-HE-Meta: U2FsdGVkX19ndmRcD0/cBhmwpium3s7xQhMbSSwITNXRuTAOnHI5B06G0ldLeBo0NfhFa5LuX3vVJBjZzkyreLWri2fZWYxLINkQlAI8rEkX5mBtYp0jhhARG0wf/2+bfV6GrjkNscwhZneYV5fCSHzTzonPKL1RZR6tPJXlnTrBAq3GFO/fAprWP5KcWrsKg886890dtQXPc/HRXemKYlPrmGnoFrg/DT9/dkihr1BuE3W3OlVaMtw0eoB2B2LZTevWsZSDAKFTTj2IyY/H+2yh1m4fnsCXVhLtCo2hgWFhB49PCsFfDtbx8aKqh5mk9z7m6TVQ/pK0z0UvJ1rZwy4P0OY5GFE2GTTBBhEYhdY6Rxela1UpO5Axfm0hhSyRuNl55o0nVQmic/GHyjJme86YDDCC0+Yn0LZTlkT7IU6Py+Sl2bbg6GSl1UYi9eFDLZjPhzkGE800xQFZByOZk43KnE+WywsL2+7LOVYdHKdpwjOl9l78dDRcUKGANGHk+SSjtf6ZajbPxzCIxRvzcNOy7krPNm+2xSskkaGGH3mwdRs9Pikp2i+vihUVHkg+z3wuXvGeKCVvigp2/PML6j7W/NX3D81pjWesvSNnV0opSS3AwFMy5wsHU6WNDHZDxuaYqjvMVkjT9SUwQVF5IVbJ2uaFMYtuFEqxt6mPeg/pdiBvW2PErxUOyNkuySjjCOysvZA589sx7IkMfd59dxg62cAsttSXo7QlebFapQZEdmLkejChfEejScKaaup5KjKRa2gz2e1Zuv+qrXcomta/ft+bIJX2GeZq6c7i1HX6p6fX2gOSnj60P07XBxuBJ2h/cZRsUvICvbB/zhVHyauKEzTkvc/SzLe3AmAolVmrJ2d2G437MazI/vKs5feKV9tgDxYWKdT4hZhp7lmSOed4aOmzLMjfyD/uwmRJxfFOPXBhzQbyitvZAQxlhtrk5Sh59UC/tThHhlG08Mc
 nJpvBlcE
 l6mb4BitI7GUVluQ26L+HRSlQw8JxujNfs20Xxze7UlMwcNG1JFuLcDVuLD9O0Vb1CDrkpMf+SYonu1pQ8o/p6lX+A/l1MHYaoqoeXoou5L+ieyBqEbryKlLHAXehXGXPNmiMd1rYB0W5t2U7lseGA2c3SLg+yQW7FeIt/VhpJW0GmUZIcYGPCpCXyOY4Kpmt8rioEcNXDqk1TS8MRWk0GiDScfxHG0kE0NsMk9KwIAbunI+KaGwSjUZvbLHBvDThuwsc7aP3NdRTIALB0SwOAyTpTZlFe9R3ld6RBm9BDntW5I094Iqd5fxDQQALQzkpidALfrgBDkp6oFhqGg/4YRh7pEavpOkn1ZqyC9OvH+d0aeIQG6IcIB75ddD1vIZaicQNNvhk54WO0NS3Zw8JWHDFm7wOWWB9O2JCwNNcwQWhI1Aq2kPyUtrH/wZr/7396Mpp2SKcXMSncqu0ihfimvoxpKufuyq0cmTn7JEGIsPHdw0zhcLi8bkRZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 7:16=E2=80=AFAM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> We always unconditionally drain the LRU before retrying anon folio
> reuse in wp_can_reuse_anon_folio(). Instead, assume !LRU anon folios
> are in lru_cache, and use the refcount to avoid many unnecessary LRU
> drains.
>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/memory.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index ff338c2abe92..f6848f4234a6 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4193,12 +4193,18 @@ static bool wp_can_reuse_anon_folio(struct folio =
*folio,
>          */
>         if (folio_test_ksm(folio) || folio_ref_count(folio) > 3)
>                 return false;
> -       if (!folio_test_lru(folio))
> +       if (!folio_test_lru(folio)) {
> +               /*
> +                * Assume folio is on lru_cache and holds a cache referen=
ce.
> +                */
> +               if (folio_ref_count(folio) > 2 + folio_test_swapcache(fol=
io))
> +                       return false;
>                 /*
>                  * We cannot easily detect+handle references from
>                  * remote LRU caches or references to LRU folios.
>                  */
>                 lru_add_drain();
> +       }
>         if (folio_ref_count(folio) > 1 + folio_test_swapcache(folio))
>                 return false;
>         if (!folio_trylock(folio))
> --
> 2.39.3 (Apple Git-146)
>

Reviewed-by: Kairui Song <kasong@tencent.com>

