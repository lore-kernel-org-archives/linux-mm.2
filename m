Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EC84CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 23:46:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D24276B04D4; Mon,  1 Jun 2026 19:46:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD5226B04D5; Mon,  1 Jun 2026 19:46:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC34D6B04D6; Mon,  1 Jun 2026 19:46:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ABA266B04D4
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 19:46:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 70DF6C28B4
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 23:46:40 +0000 (UTC)
X-FDA: 84832980960.16.C64D083
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6C4904000D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 23:46:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jKftIS8H;
	spf=pass (imf04.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780357598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GSxTrEFli14IFnuXwIWqxaVISQfFKZYf3xGmPjyUCFI=;
	b=upXpjAizlpRl1dL4qt1eEHERlvRKafJrmGeeYAj8loSIK73e/zIoHvgyxvNHu34manlUrY
	gcFIIZe2FPmofo3warEcmnvEtcJ0Pe7eC3lFD3kBqNIMB4K/IqG3eofmwM9G0pljeMJaeO
	5RpBzdZUaMQDWSzhDfpOgcorMl2FNqQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780357598;
	b=cwhAyjPj5mnegL99lcv/EAOPlvOxsTAMzHIYxZpzQqCf4tvgH2ptF7ruAf6VniHw1Rh5Rd
	WQEDOZgpQJeOnG5vTpyz442D2RpwLSYHzGlUSA4XHoeWtwAArHL8QDzLFgRL/33tTe8Q60
	y5YJexiPc43vWfCdjTtlFqc0Le3i5a8=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jKftIS8H;
	spf=pass (imf04.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5aa5f06b16cso2580581e87.1
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 16:46:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780357596; cv=none;
        d=google.com; s=arc-20240605;
        b=WEW/+bmZ+8h7vDZeCj2v7lpDk5GtoBLsq+cEy8DWPQkLEMS4I/19hIxP1UmbtDLGmZ
         b0iBJ+tx1SwcdV6dsTSr1bQAsCGdq+UfzNPBz+5k/MYJq3eKwcoicURpbfP1c4LNMalX
         cxQgrLmT/F8AbtZGVcEWAjrAobZTTjl3LjWfiQ1ZB6bemhBNlo73S3Svw83woWqCO/CV
         Egn2fhs0c8b9Pe1NVTFKuW+eOFLRDsqWqWjr+2eRE5++2KG6PZ1Z0T2x9LLL85xHDXrO
         HPRvHB7w+MKU+Jh+CPBW4mphsQPZaWd8ISn2k9wpq/Huivve3sjE8Okb4kjhp7M3HIq3
         /MiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GSxTrEFli14IFnuXwIWqxaVISQfFKZYf3xGmPjyUCFI=;
        fh=XgQvbpCCGoaxpTfaxTKIq9JYVFsHx/b0jyyOzHRtVzQ=;
        b=aA91o/xDixcYuErq4evrraS8dtNerMeI1G2yLEsXOIjPEUn/T7B/5aOIz9yIboz3qu
         Hf3ZFyQTh+jNLz51NIL5panj74S2hdKh2dIaIxkUIOXRe2PTeqKaEIseCz9pC0uHyLwt
         6Pe4P9zNjJBLvIF7UZBAUkYxU2XexNtJxUh6rLoGeNTHiZfIafQiCvu22BsgfV4Va6RB
         NUWTMSF3Qm1K4YBGmtXG6eX32HH5F4iajlCPufNrP7Cf/2EuedmSG/hj0WbcBiLxwWS3
         S09ckCwjzp45Ex7kdCKECoo+I2z376MrVOCTkVu70dL+Rj7tzLsZeYKE+pkW5yKIpNwB
         cPRw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780357596; x=1780962396; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GSxTrEFli14IFnuXwIWqxaVISQfFKZYf3xGmPjyUCFI=;
        b=jKftIS8HYsBVKAxIeInJ0LKUeUHJvOATvBoZTGkBGqfCWaNj2M3deG49SMfsnos2wK
         qh6/briZTTdR028Z8f+6UZP738P7/rOVeuArSdoH0i7rxzqy7MY76mbNzxUyDQnphROf
         vcGzVEedxisNPk48f/jLg691Frx8Rm91oc9tu5CBx5Brax6Outv72Wc+FPLv+oXvJA3p
         T5L1Ii35HBGcVhBy/h/cWevJF4zq0UcuE7UK9v/IGCkHcv61bhLCBvXy6bIeRBV7HSDG
         uwOxoNDDaU59ZaB96arEpxQS+egaRzpxjNGB/u1bIXFoop8n9uZ8bblP+cksVboLHQPZ
         vJeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780357596; x=1780962396;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GSxTrEFli14IFnuXwIWqxaVISQfFKZYf3xGmPjyUCFI=;
        b=Gy2XVWC/NjwtHUVkqqMzEext0POseaY7Xn+CcPwdfO2+wcPsZUkSWm5YV2tXkus4zw
         n1tW0MPYki8zC0/sVOwV82dNSFM6DZZj6eeCXthiDvC2zOZRjAV1Ge266Dr0WirtL8rF
         o+zlCpgT2rpVV0XQWYLzh9L5KyBK93js4YESLZXbxP/f/VtP+TtW5bJVNaZh7pFa/Zuj
         BMVn+e6Kthno23Jx2eXGuom9fARNDyR83gXBBFkLxcabDwyvYGAB3oD0lRizvRRrK+as
         Ms0aeW5uKGu1rAkPLteIKAcc8G1FsDpIJh3Ck242HsMCDAvQgB+snjndAJSNISVlrSCA
         DvrA==
X-Forwarded-Encrypted: i=1; AFNElJ83ntfLulx3XDcIFz+8wVrTHvM820qul+UBlBmdtt/XhbVXSy4zWnFgZOcG0pO5hMQ0AJR3QiZLEQ==@kvack.org
X-Gm-Message-State: AOJu0YxTLU04N/j7aOjj/RGcZvaoDI9ZzmkGi1Zt1Ltjt26bhQxNCom0
	udEgLKLl87BptkXpoAc4aV52UlTzU5YP3nCeg60O9IZo27ZbwcPItNoSLAyh/F8L3VUgaGdmbVF
	qaDdDHl17lV54mjmB4c98CwubGYW3Ezs=
X-Gm-Gg: Acq92OEb6cDsYnSFQr59e2p+Td94sOq/qGvwRbRQ6k3Ne6oT3W5J/gbYqA0gAg9qmpa
	QhebdlTGBO59Ex5EaAuy3ti3g4tHkFS7MpiP+G4mzVm1nIk1Tj9P/RqcNJ836L5ZfQpc7Xjx++c
	l97qy13xUUcUuoV3kv0AI5mqYIronEjgDNTjDcDKM5qR9fFp0bPOBnImMUTAfaMbDNUTt4eNPrV
	81xFMMaPgtqn9bG8cf/i4wEVvetSaAZYFuK40IaLhE7BDn+x2sZkZrad69fvcy7InPavyiQbNUN
	TbzOrQnv6xY5pDFjNDnOeyZhFyiqfmdtCeZLZ6EqGcy+0+SKnR1CDpcp1dM=
X-Received: by 2002:a05:6512:3d8c:b0:5aa:6dff:cf0d with SMTP id
 2adb3069b0e04-5aa6dffd1bcmr1992876e87.28.1780357596215; Mon, 01 Jun 2026
 16:46:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260531-ch-swap-series-plus-folio-lru-cleanup-v2-0-1b9a4ac255b4@gmail.com>
 <20260531-ch-swap-series-plus-folio-lru-cleanup-v2-3-1b9a4ac255b4@gmail.com> <23e80c27-320a-4ea7-8c8c-025e06f2161a@kernel.org>
In-Reply-To: <23e80c27-320a-4ea7-8c8c-025e06f2161a@kernel.org>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Tue, 2 Jun 2026 07:46:25 +0800
X-Gm-Features: AVHnY4LB-QEy0b7hfO5XR3oAibVxe1KwI82Pe0U7wfquoH_iZn_JtJDtiKosl5U
Message-ID: <CAJxJ_jh6ZoiQ1+1s8BAw8DoXP40XrFPCW4=ZHWAYHg6eMOxL3w@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] mm: move reclaim-internal declarations out of swap.h
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6C4904000D
X-Stat-Signature: pqzox5uoba5ookzukygceic3ofkzzd4w
X-HE-Tag: 1780357598-217109
X-HE-Meta: U2FsdGVkX1/8nxacEn6UtYdjoIIjalWI9jrjAesx6unYbVHI4MmhJI0I8lb8K7zJX13Xf+DNiWwURg0bAw7JkTQwtkwwUFd2G2wg/ddZiobyZDXKvkj/YHbL8mzmnsCPxzCEbPUbpK/4lFw1Jq/hLmk+BWjMBxO+3k9QUfuwNjyEszwNUe9IEn60oeEnbxkB3x91EYdS054v4xPYeGEdnMYf7j3TYqI8vnNJvB4VUlQOblJ5TEbV7Lt6OENN3p749kftrx5CtjKlgfn/OXASIoPjD21zaMlBjhOGfYm6gLORP14stkS2tmCLtf4uqWZo0KvQkKemLBJhvK+GTVH5zbxeXz4g4VjT5gtoqxlmycHlhgNpcQrnmkB2AqdYVqQ1ayAurzNob5YhpNLe4o/JjQ2X4B6l+XcAeWFdHD8YpIJQo6ZpdIHILquUEqfFd1lQuQXtOA/0cT9UFCxHfoWLkDH0DB/vZx+G2JSVP7Jy0M/PslFoaEJ/FU2ETVASqbL2zMcj3K592DARPL3CrsuRILf3BH9Vykhngt4Quh8/NrRgObz6CixEnLBP3z20duGjzIlMslJ7CpRlU1rEMoflMwYjXUYttmWQNvY2UiKwIMe5JOhiMLPfSA7C2dVDZU8SAYOzOzn9C/aok/L3c5dPclzkJD9L3bj/PdzDln312MMFYLs7x3UYecOhX7L0uczLj+X1G+QlBqla05j0pU2AIX6vVfbd5+62lty5eT8fkc0CX8uPp/SP7BG095dm03qeUG9L3xesJKU7CzOJENOwQI8xf+LJr40v+7C+6CNkWgekOeoBSKUJrmrfIpn59dmvGaBxnCuOL/tajKm5WfTf72S3Asgir5WBBzijne48WckYPCu/eW/CPnrEjEt+7pOLoyPVVMGtfotojXYhiFHjPhhmTjuDQxc/Wm7ehxtF9RSoGOeCNrs9zAnRwcCMafNo7sZo36Rk6dzD2eV+fgk
 Dnhw/OGB
 Fcj2VYVa64ErevgOcY9PRSAL6hVchTONYJGqbCCKUmDXt8ly61lS2AHUyUg5Ds12XZCkAM7JMO/dbneIn1PV+TWJqIYHjPeSVMRROFCk1CU0sZhO2MXshzT5ux2etZbmRYwRz6M8OFAqi+SpPWN/e8v/jMMiVCP58TSlWmK3F4O0VEjhG1f5AKOVGKSucuRdlMFDAStVTbIPwysDKQ5l0Fw651FITnQgb5Oikky5NZI6AmeljxSk26JYZVyDBAOKqIJX59R4ksxkopyW0zq+EFQsNsrzjH7C280iV+W077hCMnoxnMrjWWC0MqBQNM14hvp0jMD7ltO6KHxdv+NvLSu0s1SI+MCRYNaKUGqSAJjym3yEIX7KPQzybJiWQIZuXw+Q2rJwOsVKd2q8T+t8vLoRVjzX2X7xQGMpyc/awDM80MzZBCDt33xgELZcS2aLudEMWGIyXsM3PZgc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 10:57=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> Skimming over this, what a confusing function name (having free_pages() e=
tc in
> mind). In particular, that it's interesting in a single high-order page j=
udging
> from the interface?
>
> I wonder if making it clearer that this is a direct reclaim interface wou=
ld
> improve the situation.
>
> "direct_reclaim_...()"
>
> Similar for try_to_free_mem_cgroup_pages -- which actually consumes nr_pa=
ges.
>
> Just a random thought ...
>
> Moving a lot of stuff out of swap.h sounds like a good idea. I do wonder =
if
> mm/internal.h should be split up as well (to minimize future conflicts).
>
> --
> Cheers,
>
> David

Hi David,

Thanks for the review.

Good catch on MAINTAINERS =E2=80=94 I missed that in v2. I've updated it lo=
cally:
- MGLRU: F: mm/swap.c -> F: mm/folio_lru.c
- SWAP: drop the stale F: mm/swap.c entry (swap code is already
  covered by swap_state.c, page_io.c, swapfile.c, etc.)
- Docs: update the remaining mm/swap.c references in
  Documentation/admin-guide/sysctl/vm.rst and
  Documentation/core-api/mm-api.rst
I'll include those in v3.

On try_to_free_pages() / try_to_free_mem_cgroup_pages() naming:
agree the names are misleading next to free_pages() -- they trigger
reclaim, not free owned pages. The order argument reflects the
allocation request that triggered direct reclaim, not "free one
high-order page".

I had a quick look: try_to_free_pages() is only called from
__perform_reclaim() in page_alloc.c (plus a comment in fuse/file.c),
so renaming that entry point would be a small follow-up -- something
like direct_reclaim_pages() for the page-alloc path. I'll keep the
existing names in v3 to avoid expanding scope; try_to_free_mem_cgroup_pages=
()
has more call sites and I'd treat them separately.

Thanks,
Jianyue

