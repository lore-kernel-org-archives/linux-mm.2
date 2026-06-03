Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A199ECD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 12:30:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD8166B008C; Wed,  3 Jun 2026 08:30:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3ADB6B0092; Wed,  3 Jun 2026 08:30:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB4286B0095; Wed,  3 Jun 2026 08:30:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A6BB46B008C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:30:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED26014034B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:30:02 +0000 (UTC)
X-FDA: 84838533444.03.A59A869
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id D2704120009
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:30:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ZLA/n943";
	spf=pass (imf29.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780489801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=duRU+XTWZy9V+6yizZ+aF67cXhfBVAa/7YRAp16BSTc=;
	b=7M96wR4pFdceJujw5zaN8UzaXwUPItxIatA73ddSQO5qu/hn+p3Vl701Roh9kWzcnJKpgG
	sWRNs2T8Y/y4J/z7LP0Z7hHGVILauV48wyOqrZbE3Z/4se/iebf0yPEKcgi7ntP6Q1R1CK
	IrEXSAzcryFrNQ1nb+fdRBz4PT2ae00=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780489801;
	b=jHq1shLW26bir1LZI9YK9AycfSZqytC5nBlqtgpoFcP27B3m8580h2qQzyIz7GdlHEHvai
	2tPXJIB2/u0zYFYJOEJMDEHBf1WU+To/fWrbtCnZTKULfti95ZindCpurgzdBVLbctFZa7
	TlJjq/CUydzX/iumuPeANmWvUTQg5KM=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ZLA/n943";
	spf=pass (imf29.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-3966c3dbf10so41249931fa.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 05:30:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780489799; cv=none;
        d=google.com; s=arc-20240605;
        b=hcidvpT63jdVP9VmKFTX42Uk/f4b9T12iFa2BJVZe2sNhZTbAzuGJAzcSfQMNboTOR
         Hl53K9837vsnY1gCwFNUtZRCb3Jlxc0YjVstY/9WJLyxw6S8iJqaELNtMEGNo1oAW3dJ
         bWqg8Q85mhA5z3J89J0EbupkL5Lx3HujiUm/p1vDbgHNHdJ7JW9YYboC9XRYkQY29bkP
         y6DuvvEiGKgimeuHl9kF5pGsRQjFKuDJc5M0Cgxccajrz5pffN1BdBuq8KBHUoqjPXQf
         f4bf8RgpNz4LmgbU4z2RWox2vHfRKrqAnvmVOG3grJ9IKZxtIrEjatPO6hIpAXMe71sS
         XUcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=duRU+XTWZy9V+6yizZ+aF67cXhfBVAa/7YRAp16BSTc=;
        fh=W7ZDRHPHdqW3VhUz9e60HoNPyB8Ciyg39J/O8JhX/2Q=;
        b=LoQm3rhOxEcQvy+uST+l81oU4g4D/Cz0PtM8RSyh9SqkLOEzTgqQCXLe4a+fRF9U5R
         jMtGJWKcV+yuP+7rCoqn37KLqRsiGAss7D+aeUXk/hu1j9W8MrKqQJHb7CMoMuHooHZ5
         T8fN9MWCkJ7KTtkjNgCM58YYqpGVsQMsMUKj3WJvrr5LT77gpYZj1BtbZOeWst99ru6O
         xmr4H6dMSdDH0dfstJE0u1mqLNGmr6qqnwZ1zQo1msVsoUNnK2f4cOLE7OwvYjAqUogS
         0TEWHspHA9vf7kIPO0URaDslQao9EhDGFya4eE6giZ7yT39MZ2R25gTrZLEw26UZYLeo
         KH/A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780489799; x=1781094599; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=duRU+XTWZy9V+6yizZ+aF67cXhfBVAa/7YRAp16BSTc=;
        b=ZLA/n943/ZoKO3NnzcDmtvGhpNTG9YpaMDwsSL6KO5EuloXCX7JiQIkMLVJMSX8lLS
         aTA7HMDPCb7Sf6qeqYRWGiIUR4mM1Y18Lqq+tI7WboAyLzyOh75vPJOTUXYAXl+kILg2
         bA/7MuhgsdLBGK7WNK9KDpCpnj8iUxCkv8+vcCYTFKaVFmk4lLqZp6juevKHkdkvkDC4
         //DceagTZcwgXPen39D7cm+JfSPEmT4La9ug6rohb1Dn65BLrtzKVE8AF31WRHw1Gx35
         tguWO3+x382TgsJbyBqhcJxqyIF3MOlVOeowweMphFP4Wtw8SXTkv/lsI4gvlvBc5nqK
         m7fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780489799; x=1781094599;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=duRU+XTWZy9V+6yizZ+aF67cXhfBVAa/7YRAp16BSTc=;
        b=Ut8EicM/bV1jM2wLUu0USQDna4UB+zUAri0v2pyGydgsg/muHdTU4VHczg9DCLHvpA
         dG0prDWaXuft/wTQP0079xrQ/FoP765ckWbxLYaV1pZJxyltCA6+O+QQFDpsznZkO5tL
         FZyWppxD/eClYwRfpOmfPPOAJxnqXwEOewKPEnTOWtC/KhOe+9L4jYJ3fZZPmavLI2O5
         Fj8Wa7cAwhh3y6kz6sXWcYGeE++mS/zqesXdpM4WYoUoMr5LUKLJmJCQ6aPDLb+tfIpn
         A0B8Ol8ydgTOS2QHeB7h3oxTIW72S0fAOomdPrKSe845xh+6T0PKD0pc1zkpLH807oEA
         BrSw==
X-Forwarded-Encrypted: i=1; AFNElJ+p9KGXiID7tVEtGXwh+vlozeekUe4jTrs8k8ruJSFjQEe1jlbKi5XRcKAE8VwdoYfG042ZeuvtcQ==@kvack.org
X-Gm-Message-State: AOJu0Ywbyt0tjUE1SJN64JZHuu4B63XYsjocrroNLy7OeRlgHzkff/iJ
	C0yQfpXS/pzZCrMYYBhdr41ggGU2cuwKaJQ6y7/KJtv0Bhc7923IDOggktiLwy6I6oV7rdXJJW0
	02CaKupP+YX3/z8avdlR7k+OkxxqBx0w=
X-Gm-Gg: Acq92OEFqubVM2HCBP6JfGtdEho72vTcomrpQF+1c+LWgHPqeyjkrV2TurzmidnKYV+
	oIW7NtU/uAyCVBaPGzUzp1L7zYffckK+nKGo87FWbwY6L7irLb+qrZ3dooYP++ORJ724im/FntN
	J+hiGkjupj+O2Ech2nP44ssesBi9qSnAVVfo8CroZdNJghMPdRIZGP20pPSC4ZIY5TiD97JHF/Q
	1fVpZ6dIYBw5PzPmgZdZxwLfigLqpeGLPjop85WqHwJiSzxhP3oigTKLI/dqwteliBRJ5i60UbX
	KpV6jxuTrNCqkowsr3FllUl7IGyLjqZi89nFpsFlV4V82owe
X-Received: by 2002:a2e:bc02:0:b0:393:c6b5:9930 with SMTP id
 38308e7fff4ca-396af4f4273mr9995701fa.27.1780489798671; Wed, 03 Jun 2026
 05:29:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-0-5bbb567f8c99@gmail.com>
 <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-2-5bbb567f8c99@gmail.com>
 <ah79c9IIuXt51ybs@casper.infradead.org> <aiAGrJsNm_uAf1qu@MiWiFi-R3L-srv> <aiAXwQQz0MeGrD1x@lucifer>
In-Reply-To: <aiAXwQQz0MeGrD1x@lucifer>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Wed, 3 Jun 2026 20:29:44 +0800
X-Gm-Features: AVHnY4K-WfBwFo8C7f6lVkYSPVYenGUo91iKV-cU3zaS4im6lYN9ecKF3sLdTPo
Message-ID: <CAJxJ_jhTAS3gbo5AoLPGCUSchUPTsUVzkNVprg9pfzqXFpPEaA@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mm: move folio LRU code out of swap
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
	Tal Zussman <tz2294@columbia.edu>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D2704120009
X-Stat-Signature: f7zwg5cgaizdmbx4oscagxff59a6yyet
X-HE-Tag: 1780489800-455509
X-HE-Meta: U2FsdGVkX197aiT8CyfOHBp9qWeEi1rdJKjOehbWDl8tRSeDVvmuTGa2Q9Nv5ylFvrzxglXH5qEj24OObw1OhhtA1pMobRFtQX5R/wLQIL+ihi5IFf4w/7IJZxlg+b+xIgFs6IP9V3JoeXWKhv6rP/9R5dGBt2MiJEcO9ebfCCxlvO8pLYklt2WPxGVdAmZv6HFLKBauaIZvEoL+aQS8BBSPV9cSEWyaKI0dT3xkBfkgyB3UWUPGJQsLuG+q7qkcJK7DrNzFvzG1oQlu4hNoH8ZqqaTs7liMSNvMegNI905g/vcv6dIdOF4s2JTptvNX/UU21r0ReB6h02Ksayd0NsxddG1743basyz1Wl9F2WCCuQporxyTwEfDKF55qqgDphTeRAJmPnTmDiyZG6NGxahhyePfqd18MV2KfnPyvXni7QlQSSfWUSo2fRQRhnZRy3jhvKOllzouI88JE5S2JOhCcBB3KRMN20Qhax6iLu//PH5VIWpxOs9ciYRlqJKxFLq67t6blVymqFzaFVOM0h6guUbTROaBvVtGIUJclAdF8SwGNaPhypF++aAMxvel9AnZ+4r8d12L1wVLXgpAMx1dtE5MDkTyjq8nSlFMUx8h7fMsnIXFjk7aqrxIrb03IkoGVfpzFweVaHSF/Whfn/t1GXPcNkftL53psNmm4MnDe/cSrW8SxkrensrpPhRH5QcwAZqzaTJxWkcXnD9z93QG6WbmoXONgBOtrfhkB0XIElzjhZ35/PZ8S65vjYrtGXKFfYPKipynfkuJW6KB/ZsyWFAxr44ZzWE2O7U1pYh6YXTVUHMolb0ZEGhqQQr1cwjO9seIX+H2HEul5VtX3xcIpUnykaDGuEp7GTnnxoFqjsZOc3EVBKruogBGsR+D+UUSMfRCubIxfuEtP6bfsibuyCQrO3f1Bo2mQOdfCulO1JlynJjdGKzPnBkLqwdzngeKdIZDb/mVJguqETa
 rJnCgBnW
 suhzRvRJ2+NKG8upjFPNUY1ysTt5sUZg9UG6VYJCu3ZpvnU2CJm0CGReSuO0yFHv+nZYJbFhzd768HJpZ43Ho1hfQTM4JYhzV0rQb9hMUxujTKxIlv1Oxy0MejkmYWDNBs/+PCi4R5d1LcwSQSjJu38Tf/MgvavIDaQPMdITilUPxm7DsK2UFP4P8mwct6ZdDV1dw6NngOu/5nhU9qJwzjwz7dfh9OcQBpSpJNQDmhhgsAmKeONCCbtdvgt+uzQ5DCC8NSiqUXBdYLBj+fvrDF2wyKpu+q94MICWhK2lnexqi/YAjfjX6wAacuwdW1VYdkD6ly7In4Z6mBjvakk1wjK1hPsyEefMPfhrf/mgUkI3NUwPA+k7w2+87a7IljgVW5YAzJzOZyH15uklopT4tUOnAmkMOrADaKk6UwIi42zu1O1i66rXywZDhAb8IPsA+ydaG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 3, 2026 at 8:03=E2=80=AFPM Lorenzo Stoakes <ljs@kernel.org> wro=
te:
>
> On Wed, Jun 03, 2026 at 06:49:16PM +0800, Baoquan He wrote:
> > On 06/02/26 at 04:57pm, Matthew Wilcox wrote:
> > > On Tue, Jun 02, 2026 at 09:01:16AM +0800, Jianyue Wu wrote:
> > > > Rename mm/swap.c to mm/folio_lru.c so the filename better matches
> > > > the code's main responsibility.
> > > >
> > > > This keeps the implementation split from swap-specific code without
> > > > changing the published LRU helper interfaces.
> > >
> > > At the same time, we have Tal trying to split folio_wait.c out
> > > of filemap.c.  https://lore.kernel.org/linux-mm/20260520-filemap-spli=
t-v1-0-c36ddc2b6cf2@columbia.edu/
> > >
> > > I wonder if instead of folio_lru.c and folio_wait.c, we shouldn't sim=
ply
> > > have folio.c.  Tal has 700 lines in his diffstat, you'll have about 1=
100
> > > lines, so that's about 1800 llines which seems like a good size.
> > > There's some functions from mm/util.c that would fit nicely too --
> > > folio_mapping(), folio_anon_vma(), folio_copy(), flush_dcache_folio()
> >
> > I think folio_lru.c and folio_wait.c are better than a single folio.c.
> >
> > A single folio.c with all of them would have no clear boundary for what
> > belongs there and what doesn't. For comparison, page_alloc.c isn't call=
ed
> > page.c (we have files called mm/page*.c).
>
> Well page_alloc.c doesn't only contain things that operate on struct page=
 *
> right?
>
> Whereas folio.c is strictly operations literally performed on folios whic=
h seems
> like a good match to me.
>
> I find folio_lru.c and folio_wait.c far more difficult to figure out what=
 goes
> where and there'll be a bunch of miscellaneous stuff all over the place.
>
> I vote for folio.c.
>
> >
> > >
> > > Other people have thoughts?
> > >
>
> Thanks, Lorenzo

Thanks Matthew, Baoquan and Lorenzo for the naming discussion.

I'm posting v4 shortly. It keeps the rename to mm/folio_lru.c so this
series stays a small cleanup on top of the swap_ops work. A broader
mm/folio.c (together with Tal's folio_wait split and the util.c
helpers Matthew mentioned) will be a separate follow-up
once there is maintainer consensus on the file boundaries.

Happy to help on that follow-up.

Thanks,
Best regards,
Jianyue

