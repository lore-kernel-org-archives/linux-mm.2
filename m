Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A4F7F45A0D
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 23:59:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C19BD6B008A; Fri, 10 Apr 2026 19:59:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCA6C6B0092; Fri, 10 Apr 2026 19:59:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB93F6B0093; Fri, 10 Apr 2026 19:59:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9A1EC6B008A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 19:59:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3E62A1604D0
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 23:59:07 +0000 (UTC)
X-FDA: 84644314734.19.62A7B39
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf15.hostedemail.com (Postfix) with ESMTP id 54CCFA0008
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 23:59:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OK91pp32;
	spf=pass (imf15.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775865545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dhWemnqLfx4SK0GSaKp8xXR/c9DrucaqCAj9RVqX4sM=;
	b=cdmHiZ6P6ZvrpM1+DX7sK5b0lBN71bi14ENv4kKuerXn9Fp1CFnGl2cnOj3IwVGHiOkhUb
	VeH5ezYkpE6PIJTBqZxrQxgu3jrK3+Bl0DmFf88RaRQjypXXmtioH7J+IC2+i6ENM5roB4
	tkW8lOfLT8lxY8ju7QlNO6pG5p3v2Ao=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OK91pp32;
	spf=pass (imf15.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775865545; a=rsa-sha256;
	cv=pass;
	b=aIjZ2+ekh3oKAi9V3DS/QwdhrMGVCVxsa7piA4kOiZTmIkmNa4qbgzjIRSgvT8ejcX/RH2
	ZFvcXTeP2K63uG/8Aamf/GwaU+iJM0q0GJWG0C4bKkIVQrM5oHmr2vcQo8VlELxAJk3WNS
	sV0318nfzGSuf2AlqROcoQZoET2nVGA=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8a5800772f3so21103456d6.2
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 16:59:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775865544; cv=none;
        d=google.com; s=arc-20240605;
        b=jbZpfvka0xecMMrlDh/P33hega1/irgNujbrHTMmonH6l2rt6TTy0RSnofGOr08ZIX
         F0ySGjOj/KU8faaDbX7Z13Hh5vIegjxcTJ0UYKEZEu0qYULxdb/CCpTdPHluU/R1QtYp
         kb37wOKR0d8vqocYA1tWcvlLuhcHOcftD5NgRJgbCAFlrpelTC5HoyBbcjXMaPY/zvAM
         iuBg7o3H9UbHIWBcIFYD6LCCfTOLDYAIrlZVobbRfJnhhCGpJIh8kubnrwRWDc0ffmEw
         7PyaOtdhzazRvYQctplWri+uOZzKAT2vaimUexzaOFVYDsq17G8LqL7T0cKe9ik1hFPo
         dNEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dhWemnqLfx4SK0GSaKp8xXR/c9DrucaqCAj9RVqX4sM=;
        fh=kv6/sDK4+o52y4NVi8khxVyYihrL+BFWC8wXAd2ENgQ=;
        b=aG/pNpDJoA/msKn9zd5uCe1m2A9CKmxhKcLs6zublgit91WRlT09nD8riPy2bLp52P
         r81Fjsdn5zqL9ABcHkdW5Y2i1cDo9s7eAhzycIgfBT2a0C9S20uBC40yuBKvRkKWDfjQ
         eDaHXXW5Qq09VKoee9C6mjkgZnaw5bB1AidoLvzGL/ZM8KW1mAFdPsdO4hc7Ae6ARg3k
         BGakieHHzhsQ3mKBq9HpI/8kU3kPXMVDrEIToypuwBwqYsRc04BuXaUZmmBI671XobC+
         C0dVM60+XLSbhh3hRckRu+7oxuWuldUJlv7qtSJM8ZHb97XMaO4CBMHUgom6HfdcDNmV
         Z62A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775865544; x=1776470344; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dhWemnqLfx4SK0GSaKp8xXR/c9DrucaqCAj9RVqX4sM=;
        b=OK91pp32mDwJOLVm3cQlpuflz37J/1KQrt3yK39PQBAWUWaaTsokJhmqJ/4S3yiIAS
         xlcjvgv3uLRlCfskXQ/WHhT9EUxwhQQGpGoEz9FzS1Y7UCrHivl4PsLdYeU9Nso7USXq
         mkTvpFHc2D9IVRa0ukjEnnBGp4USTWjyhMThTLtxdtTU6FOsOA9BAVNjUYxHfXYeiNnz
         n18BXko35/beErgIQitKe+ySiGRj0uXF1lYfmXgR20tLKKhF5wIMK/tlGc6zF4sJqmAi
         o/QoB2ecQM3CtQbINWPxMOoz1uJUuUyERp2HHDmA9BUU+cem1LOTDZEMGoATpzsERttK
         RMeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775865544; x=1776470344;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dhWemnqLfx4SK0GSaKp8xXR/c9DrucaqCAj9RVqX4sM=;
        b=Ic6DhueCQqROZJF5vC4NHJj63ceOK1hpXpIy2wGNebjQ96a3OmtHs44j37GHa2HclJ
         Kf7K4qEAJOwoLYy+HauT/sdBpwo/ml5Di2mK8GkBQtJEbVXkwsiMY3HvisUUe+QjS3fR
         xjsuETczyk8tGUY6ywjdlIqheHxdDsZaXd4IPqrXrlY+OkW4HzeTEWj0iW+NOXz6/l+X
         Y+8WZr4LOvRo2YIgGhehdK/Cvwf3yGvF2K+qP7Fxaf9PihWeoQrYHSBGDtSjgg1Q4FiN
         0rl1cq7Q68TrCJh6H3hLhVnU3r1YBVuX5tLeq8NLTDL1+znV7JzLMlizfjYIa5WFZjt4
         TMgw==
X-Forwarded-Encrypted: i=1; AJvYcCUsoyMcg9EwlFLVfRqePDVcMO9MYgVmXoQUN4iJta4w4O1j7StA9HFyqBHXHA8a5CK+JLxwZHG6Iw==@kvack.org
X-Gm-Message-State: AOJu0YzN0kSrUXhR1aioXD6rWIhUFyLjdh22xwuchNHisWSYigZhWSLm
	6oIXglUkl3nPpdcEqW0K08kAouQ+l3xhSmoZhxPoEOiTeQ8Nt+VtDUo1ScwrJ+NY041r9eCLmex
	yVpfgcd9HbLcYyhsnIfk1GmWzdhhNnNHorLFdd48=
X-Gm-Gg: AeBDieuN6csg27vByEw/dCETpLqDrXp1EB27QEmVWTi4wj1jK4UL0nxqNf53nF9kg2I
	W45mVWcDOANAEhjYjrmNISw1ARIlcgw3ggQUAnSwRDYVsRM5sybgIU9BzBuIGqmfOE05YBTRpr1
	ZyWoMkKXXr/dW+zsBk6tk9C2p1bovb7M7v4vdzkeu5fs59and+6ohx8ct09UT5pII7/Ore2Jc/n
	irF0LPnPyLapkKYa79IXNnRb8ql+m+zNBJlea/iaZDiQ0pDExm5xwhRrAanw02sAdevBBqmN4Ju
	cRXN7RCozG4F6zkB65uHz2WSQrOMCQragwIATg==
X-Received: by 2002:ad4:5e8b:0:b0:89a:1536:251f with SMTP id
 6a1803df08f44-8ac861ca80cmr86862796d6.28.1775865543753; Fri, 10 Apr 2026
 16:59:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260410-batch-tlb-flush-v3-0-ff0b9d3a351a@icloud.com> <20260410-batch-tlb-flush-v3-1-ff0b9d3a351a@icloud.com>
In-Reply-To: <20260410-batch-tlb-flush-v3-1-ff0b9d3a351a@icloud.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 11 Apr 2026 07:58:52 +0800
X-Gm-Features: AQROBzDP44sZZAPdUd5Hmb94spOIVCaHy2jRXAPflCoMNXItgUM0FvC2dp2kgU8
Message-ID: <CAGsJ_4ytrMg6mBKXNky=jcuKF4KFpwZbCFnFin-7S2XoP93yfQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] mm/vmscan: track reclaimed pages in reclaim_stat
To: Zhang Peng <zippermonkey@icloud.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>, Zhang Peng <bruzzhang@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 7hjkm6h6rojthj7gzjqhgitq3f1gnz1c
X-Rspamd-Queue-Id: 54CCFA0008
X-Rspamd-Server: rspam09
X-HE-Tag: 1775865545-249799
X-HE-Meta: U2FsdGVkX1832s7akcgJqJ+/c0AVCkh3gltHxrBVpSri/IMA+96x8vQZzvMSd2dGn4MO4bBzr9DnxSjjZIJUZL2bpvkbQJ90u4eCAVoXTLCW2RbbKUoIfvkqaNf7FpRlHBJzopArPUAw6AJhNsFeXSGH63vbE3ys8MQfwuvLVTFar+a6ym/oNIVltCf7ANWs3eJNYPBtFZV8QVKMpoGWj2u84jANXPq5dkyUQCJvbl53Ha+kN0WaY0uYAF7FqRR7S7L/0Yne9RZU2VyCZMFZWEitDxVqAgzdO+ESu6Us0cUtZ+6C81zAH8jFyV8229/SiC78goQdcOQN6qg7KRgJxdiFVGqteh3PnE/83gKUX2ED04GGIZaIUy4p6OGc7rlIWHzOxgp14FXTwFbe9NOe5yr+GiWebiwaAGRrlxZ1zDZwky01+gkMTk4P1GiyH8bEkS5lc8qq4oDK7ZYPUxFXC2thlQ4855qb/Q1rx3ic8ShvTYtio8gtj+RokuGZAb8ANAiHgIY8Nu3uwC7/G/YxM/uRZCZnV8RhLZ5BY3jMhWYshhRkb9QCWRfxDLbyZoM+KK25S6KZRdcYtYASvoKzir6xYlw2vd459h0NykTpQw0toPvRgAUaz5bTPJ+anRm8/9wPudODdnow50GRRUdRAONbxUGtJlcfbOpZ+P1eizSozLtT4RBrEfMqfFFkvKET9sOzWzVXgKyCQvzR5nvkb/Z1ySysMeq9HPjzuIFGmHrsouiStVe1siaEcwZfrIcK7+nI5a4MgZ/3IKW2S5zyZK+9NNbZVaMncLAi/RvvilS1wDcTnG77kY4Hvc/3ClwMmxnsWaoSKk6v1GOjzWVkBU2hDH5S9Vlve4ReYWB7JjCB0vKl9C5gI/2n15DE17TnARXoKxrQjGBJL87TSK0D2WNP3er17ATQoTTaSC6qJzxT4EzJtDIZsFRkwzse0wg+RExBFkr6B9rllfDp/jM
 rsOmx2AC
 SHFv222fHKgrB9RT75HAX7hGn86twjWfnEaI/MPXxP7KqEjUy+GfZNEVZwqsy2fR4xZqzSSBYkBVQ6Sv8Eu7RbSPifSZ7Uu4VJWGVwb1b5KCdIw6TU1NlzTM6PtHVuIKeTsmjQBGDr1lTdq5b3UxX/Rjfxd0oolWmvX913r/TaKQxlPioBMGem1BTcC1nqYeyvmQxsibFTQ1JBwfvuAua2+p2o+VDq1PjZ58f54owktgQN86q1sB9NX5hP8CjqY+aOyzF1TCiGsitjjAsGZR4Y9pkh6vE5/NvYSIQeYVntlZ7oGQn9dn+v1rMRI2t2bzvbEWB/1IXffVf2p8zpQpLgTumctrZ8mEeGiAkeKVaaPHEBTWC3Pd/CjHfvGYexJQVWDESjeXaF+XSSuiI9EsokbjaHkS1MtN5Fm/XtQDVRASOKIzDLVvFDJlCP9dFhxNWBYsbNfGUCojL7VyKmnfcdXoWpyXH53sHj4wWD/bU/QBCtZrCRXYIE6fIhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 9:04=E2=80=AFPM Zhang Peng <zippermonkey@icloud.com=
> wrote:
>
> From: Zhang Peng <bruzzhang@tencent.com>
>
> shrink_folio_list() returns nr_reclaimed while all other statistics are
> reported via reclaim_stat. Add nr_reclaimed to reclaim_stat and change
> the function to void for a consistent interface.

My gut feeling is that the existing code is better.
There=E2=80=99s no need to enforce consistency across all cases,
since the function can only return a single value rather
than a structured set of statistics. It is also clear that
it returns the number of reclaimed pages.

Best Regards
Barry

