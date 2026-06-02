Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05E71CD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 13:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D2436B03A9; Tue,  2 Jun 2026 09:39:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A93A6B03B3; Tue,  2 Jun 2026 09:39:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BF836B03B4; Tue,  2 Jun 2026 09:39:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B2886B03A9
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:39:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 99B501C22BC
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:39:11 +0000 (UTC)
X-FDA: 84835078902.17.AFAEECC
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf23.hostedemail.com (Postfix) with ESMTP id 88A3B140006
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:39:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XDJks1K0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780407549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M160foJqrjUQwsy06F1cgSspWzq7hwt5//URt9mKLFI=;
	b=iAwPvbnQnN8mcOvEq+IqDL1O4rLfU1QZgcPCLZZ6S3zSLkd/hWxKfZUSc6EHwh7be9dv59
	W6oKHTFqZN+ePN0zWE2SOZrMWfzbmPhhMtqr7fuF9PNLG9aUq4Xo/g1hpPihnLxnvaYepE
	18P6vz28jO39qmldjcUvakFYmVcuuLI=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XDJks1K0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780407549;
	b=2QmYsuXds+fdsefosN53Ku1YdOlIDX9+PNbHkOJ9q6KXW633To29PGKLbZ7A/wX6m1nxBW
	QgbqF+G7IyLcbSnVrHfgc787FAQvrDV26RC8dn/eD3yadebfGXJQOZCQ0mVtCSjL5cP8CR
	3RV+CVpGRLGY79Su2Ac1aw+nKcRTMI0=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5aa63daf2a5so2954790e87.3
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 06:39:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780407548; cv=none;
        d=google.com; s=arc-20240605;
        b=CmiLg8bOMVLrVV/bF8CHlpCL4CnmSBmyMQp+9BSfy59ibu2btAjuZoKW/1dnO9bmb7
         VWok15MdUTcpMpfaz8ahCrHUyCWuIVG6Z6fEWy/7e0512HmaQjkoUbC1AlMd6DXC7c+E
         jo/kzvBXtpS2Zx2RA6bEUlQB2IeNgxvA/VvK4YB1KcRPcZXxC5lYV3bxHeOH59K58/wf
         3KnSh27LKz6zAMq34FWlbZxUTLdRTFDG25nREW8aOO68oxnJXNSzYDErHFaV1cO1iXL5
         9/tidTt2bygWnt1UHdrMQObw41vuyqUsVhpPl0CLQ08XGeslSa9Mblj35MRLrnpg/2JT
         Dbfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=M160foJqrjUQwsy06F1cgSspWzq7hwt5//URt9mKLFI=;
        fh=zTTScGnqLLcX2iyBrvmlkj+Jsk1kJkobYX2CWoVOYbU=;
        b=C5jc3YzMTLRaKopaYmlulXY362BgobUwcw5Fqe4Yxaj87ZelS9Dk5wDgtt5/JbeZZY
         5HZcvqO15JSTAoyJ+QKCHepKGWSDAmJdlx4ke4r4fk1LejB/ald1DXmU4vnslVwdmwp6
         QaPCR4+Nr8wM8t++JHX9qxbtcXsC/dO0ulBhiY2TRkzrNA2WIrQGJEnjLU2qEiCezBjn
         s/RMHBmaVoq/TxSfBeV9wOYc9/435VPN8ofR6lfZpqBPZ+K2fvCeL7fYEZ/LPYLs5bf1
         v1Lubev6X6n4iHhhUUNZDg4YZEM/F0Mkh8UpjZpWzzwr9wRuE1vYCsa426l2Sh1gTqT8
         P+NQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780407548; x=1781012348; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M160foJqrjUQwsy06F1cgSspWzq7hwt5//URt9mKLFI=;
        b=XDJks1K0G2y1sPxx/d8IYsJgyt6TgMxA9VzqYBxLlx0Qpq4A1+WxVmkN1lE//f0rBd
         Ttwv3hi782ruNJ6Nw9LmMbBvyNm3gOFr8JGQJuDflH9nQyJfQUm+SThoag5bvEzTPVhK
         t2IgkKF9KD6Q3m0PJFjdNIrRwZUXdp3hUFurSnNsaZaEOn5GzahhOVcUy/L6otlHjB7X
         8uG4jPvYiXn3RHVy6OrVZ6m8qtikAWpxHzdP8SUXCVS51nSPEyaOTaJ9+C398WTF+zC+
         MyHoRLRRKpIbZedHDdddFyWeXsRgUqgAeITbq655KxSU1sMEDh9Ty12CJCdpHcVlFSUf
         ip1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780407548; x=1781012348;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M160foJqrjUQwsy06F1cgSspWzq7hwt5//URt9mKLFI=;
        b=Qz1jU2gqSIrvi/+DJPxDDrz1SPzn2OCyRpGFb00uNNE4aqS0OcK71+ZhOx2LkcA0aP
         8Av+xLPB5/NTqux5KoszDJGtsW4BaU3k3fPnSbTJe/vuYP/fJEEuY3UkUbVg6H6PInW6
         cNLbmVHZf8+o08DVxL9pfBbH2laQhyxU/oUiI0PnT78oy8kXWG1cSKlqJbx63fk72wGk
         2ahuMymfaVjG+/IYh7YeK0oREm+rBC9yqobmyPPsSBOHWmj9fQezmBi5sUQuqOh3ZlHD
         5sdzrBX/AKt/dQig45/Dsis358hoZmoypmZsnBjv49E5vdSkxx+9U+wlkHUqY0po4BZ8
         gxXg==
X-Forwarded-Encrypted: i=1; AFNElJ+k69YVyk2vzHuSmNRflqC3UcsU0UaYLmKigbjBo0jKQ98nB9oQcfFZDY1nqTS1MiYqc4lMRA4Ruw==@kvack.org
X-Gm-Message-State: AOJu0Yx3HpCRKYUgctTwSR+VXphcOoow6RsYnVZKn6NohwaFomS8U8pM
	z0G8s4tCr3jJCfqPWfv84bKApwM1eA3rwWotDuslMAM7mM+anFVocPVPlAfj3OOgmMl/zQWiau+
	2Gmcx5kwLqSlsz9BxpN1ojZtHQ0Xq1uo=
X-Gm-Gg: Acq92OGv/aaxI6nwj7ZW/OjIJ6BIK3tPfT7sdldJClzg7Avc5uGE7/+ovCZ58Uj2M36
	hiu1JO3JECe1vgPFfOATALTj2+6aDCnO52uOuDu5dsdxdtpt7w+aEkf0VVx/KHR5omEghp/CIPq
	i20b5Dz2AeKxrzXmzNfiPybGoZ78nXK9NOHYG3pznWi97p5UG/bG79YqRgqOkNI3DbH5pvNaP/n
	CUSb1ujPcaDGy7xoRMF2fOkqVHeNlyVEsIrhI7aXRkW6pIvvXOVmPucVYnohSYNUQWXLKfhrb82
	ryyMUTZwJ17P1b92zyk+7O3WMiKuEELUZr5K4dhjXZkEM2cB9g==
X-Received: by 2002:a05:6512:1326:b0:5aa:6f8e:ffdf with SMTP id
 2adb3069b0e04-5aa73e6ea29mr1590957e87.22.1780407547540; Tue, 02 Jun 2026
 06:39:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-0-5bbb567f8c99@gmail.com>
 <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-2-5bbb567f8c99@gmail.com> <ah6-RRTGIBmjrlJi@MiWiFi-R3L-srv>
In-Reply-To: <ah6-RRTGIBmjrlJi@MiWiFi-R3L-srv>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Tue, 2 Jun 2026 21:38:54 +0800
X-Gm-Features: AVHnY4L8OIdRtM2QivYuUU0xfov3oMOpCIB_7oI9687YvhDnOU8bI-gcu9jRH_g
Message-ID: <CAJxJ_jivzDvDcMWoMeQ--fMxyS2uZEkE4npYOJB_nnaH5=A2qw@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mm: move folio LRU code out of swap
To: Baoquan He <baoquan.he@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 88A3B140006
X-Stat-Signature: 46k6ahisbj98ojkkad9bsz4qpf6n7tmp
X-Rspam-User: 
X-HE-Tag: 1780407549-423334
X-HE-Meta: U2FsdGVkX1+0JYDqsBRHDXS+R1+fdNfWCYlNDJI5NOLYAuW66Uu8Hf/icJmefZI/yJAz7AOnzbbgfnCYac5z3S3jJEeUNW/vvQwm/2KLI5imYlNTT6yiVqclICdfsE/xkqhIjhyR5gK7z0Z7Hj9RQQ5HEDBneJfPAi+ecvHU4mSOP9+5oPB9bB8UlYX3a4L+Oyot9nK1LW5fjKi6Fc8T7uXPH7k0sHYRtxVHJYZNAZTc5QTwgWR7J5fRTrAqKgn5GCRdFICAkB+HdHaoQrExhAni7Dw+ulIdGTjdkrjaX5sB+qyi4uVN6DdlopAAIsSjxlOojYMOitBfDB72CUh5FxwYz5CFkJTukx5zunMGdFmKCl2Ow6lAdErEzEcgva70bYNDPdybAEFpkvryqsXg3cLqQ5KYKXDgqmWzcof4eJ3MY+o9n/Wm9Ooacn+iOGYrsCwfB2EA2gcIWbaNqMl85QkjdwOhvo37fAggSW2pT8p8BwaMxUFLh/hOI0wuPz3JkFysSbQTOZ9+dsWlYARVtTDYAWgtV7AjDvSoRtZ7hsyf+Y+irnb/8/1prnSk3bvHQDdz8aWVEqZ4hk0YaJkXmOOzTZjtaIVfy+F8X+cf9W2i75XvK0sMoWEuBSZs+SEfsyWES8D6fygK3wVu4FiOxXP9pFjhI61FKRcpun90G+zXs8fw9j4sgmqXUAeaoVq6uv7nre6NVV2prmAZmpZP2fKOliwkbGzNSCcFo4GizFjoP4AnkxmeZPF7+cLFcqsS4ArLtFtDcV6olN2ziYfXGUrYXc5OPwhcMJ6wB5YPHOiJsq0tWq8eoS8skB1Gr5E/W3W05dJGDdmV6bYpomqY9e3ic/fKWkdgyYFfI5H3wrdMii8r6fICe8gB9mD978jhkjHjYMBUvvrqC+t3GoPqLuwcAuKuRKntlmuESkdfg6o8+oOZmjeRvP88dT8zInsXhiqaJaFTptvsmPexMcN
 fXq1oEC6
 N1roSju9NIPBdN9D/r/wOQModnpNjMbpG9YDBC/y7YRpfaRtPJ73A4BHo0boyJA5iiKGn2aLNNhVcrHUiyLn4CEtD9JIzRvXJiE20qdzVOBR/ilCQFogvVPsZVv0W+2NOJItsRgeztU0QyqoG3n4UcsDq7OqUDTZUvTG4VjnuMnBqNFsKprvnQxZA3ft5866JvFO5JNk9PcHh+PUJw2jNZ29vsXlmbmi1mnAE0Okzx1iaeUB9NBa4Jr3mjcU7CP2MNlnO98EGxcRpZix89jLZifkd9zK+ZDLYlMmQplBs6307uxMQunWWrdYHUXBZ0ycqFCKnki4ka0Jgtv6BhXf0kg58HUy6RTK6crFR53RTAOb+OzkMRclFdJHkH1zYcCiImFr+l5D6Ve6CQSsAQ9Km/yuTPOv0mbt4r1rsP6+1pnGWo1c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 2, 2026 at 7:28=E2=80=AFPM Baoquan He <baoquan.he@linux.dev> wr=
ote:
>
> Isn't the main action of this patch renaming mm/swap.c to
> mm/folio_lru.c? Why the subject still saying moving folio LRU code out
> of swap? I am a little confused?
Hello Baoquan,

You are right, this patch actually only renamed mm/swap.c to mm/folio_lru.c=
,
I'll update it, The swap-specific was moved out in the preceding
patch, forgetting
to update it when split patch.

>
> Sorry, I don't get what are 'these files' for most of which default
> values and initialization routines can be found in mm/swap.c or
> mm/swap_state.c. I tried to search some of them, they are not in
> mm/swap*. Could you double check if this sentence is still meaningful.
>
This sentence is outdated, I'll remove it, the sysctl defaults are
spread across many mm/*.c files.
I'll also fix the stale file header comment in folio_lru.c and check
other files.

Thanks,
Best regards,
Jianyue

