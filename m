Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 834F8C5DF8C
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 08:39:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F6566B0095; Sun, 23 Aug 2026 04:39:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A6B46B009B; Sun, 23 Aug 2026 04:39:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5963A6B009D; Sun, 23 Aug 2026 04:39:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 34AA06B0095
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 04:39:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8C98FC0271
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 08:39:02 +0000 (UTC)
X-FDA: 85131884124.20.EBFBF9A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9E3ADC0004
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 08:39:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fNidCwNi;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787474340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sh8RQ4+LO0vHcH+3EYo20mArA2lH6QjCIsypEu9LqKA=;
	b=TtU4RUMjOTVl1mJ7pgh6Rveg7N3EhCmH7uA0NBk6xV69gZXi+c8s3/MVLZgOPJss8M4MJS
	lssy4X7PU92SzWnDEZAjULAs8BnHHGglxVfJl4k3nuGdud8O0borLFXe33GnfvlsZwUoYN
	sP2kLdDad9oUrEIcvVjRzt7QuwQRO1E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fNidCwNi;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787474340;
	b=eC6cErV35BYHCBOTv2+8fkEwWw/WTr6zBB3hJ230cuac81N769ruoQvTaOWMZeTqmG+9yr
	ijwp6FZ0btSgqY0XZzOEioK/XLQBsCBb44PSHNRbGRmPtQQ2+MiiTSbSZWhBLk13oIvJY6
	yixG3wkOYL/pzOmBH9fAw1FjD1ekG8k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 60CA244E4B
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 08:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4876A1F000E9
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 08:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787474339;
	bh=Sh8RQ4+LO0vHcH+3EYo20mArA2lH6QjCIsypEu9LqKA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fNidCwNi9xl+XRQCBZq/wwu4UnorxMWk1augmIUsDHqIe2To88eVo6QZY6UlSh86z
	 BnnnGrOppgL3pjMmxhJWutdhXCwmsfG+sHbKh38+iSxlIydAJEzxJkzE/hUficAFKv
	 iC0iOghFFMOKeuCtN4k7sUEsgw2ryBvLYQfs18c/HEfnTUxn6vHBTYpEJodNTcaV/G
	 66mdOCYji9mm5BSX9zSsj1AY4787EdSDsAp/29u2rmeazKKldwKQP4Y+ZeOQmfPTMj
	 7ZLOt+u6xSRkUw2jLzPOHXmxGmCIYnHYG9fv6i/fmsEDRNxwrontH02cyHbqojsmNH
	 wKTJZxZJgHbMw==
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-52d58d7aad6so11877651cf.2
        for <linux-mm@kvack.org>; Sun, 23 Aug 2026 01:38:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RporWXUnYelSe3gn+abWfg0N9iTxrXFLody3PXtdzzKtdpK+CD4h4BwY4JbR6TucVix8wbsHD1+LQ==@kvack.org
X-Gm-Message-State: AFuF++kJwCeTaJ7ZgT/nsoCqhEVoowr7QXohrtjsK0mTaxL2HnwGiYz8
	xdPmNZDtpX2uqOgwt4y+ku346lEgy0BzcISJTcfGKxtA6EOfQo/+R1IfZ/BGdt/8tJOhQ6yFvdx
	1K7g7W5g8NwcqLWWmyhnAk2qdFxdTaaA=
X-Received: by 2002:a05:622a:1a84:b0:51c:1967:5091 with SMTP id
 d75a77b69052e-52df5bb188amr162403571cf.41.1787474338252; Sun, 23 Aug 2026
 01:38:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260821093606.2231216-1-alex@ghiti.fr> <20260821093606.2231216-2-alex@ghiti.fr>
In-Reply-To: <20260821093606.2231216-2-alex@ghiti.fr>
From: Barry Song <baohua@kernel.org>
Date: Sun, 23 Aug 2026 16:38:47 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zHcW8oJBRmCDB2WYFc_uv9KP+M0fxOgnnfmA3+x06t4A@mail.gmail.com>
X-Gm-Features: AcwNN1X5RmCuPZ6HzH2ZEMMP4hYSduCy2ZindZ0ZsliEHSk5whiut8UMogU3BgU
Message-ID: <CAGsJ_4zHcW8oJBRmCDB2WYFc_uv9KP+M0fxOgnnfmA3+x06t4A@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] mm/swap: move LRU insertion out of the swap cache allocator
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9E3ADC0004
X-Stat-Signature: 1x9zsjmqc4ynoarbfis66f17e9njbkbe
X-Rspam-User: 
X-HE-Tag: 1787474340-42662
X-HE-Meta: U2FsdGVkX19gkvRkakEMPpIHlmS5qZsNbwNxVI9JggxvQjcMjs6TU84GyUzJzchmvPh6CP5rnEmLKHGRqiEjiTYed5usph63piWafyCmMUBY3JBjVeWlauFUMqdaWl1gLmeeqvrL762NrZyokdViRAxYE/Hz+RjJNX3SOsqtI9QYGt8Jgd7tb5XXz+LiuKlHIoWA5MTY1fnR7QkqmatlFht/M6iQSkDTd/mZANBqQ3edEtcHViLWIYiWifp/NCVUAj0QDpL4PGdM+SHq4j5YcK3yj7JGBxj76mmuBPJYaJcUYFzYacE+ZiUrvujnEQc7EgY4TghgmT4B1tMr+u+5sz9Hs65D6FWt/Ly3HTciRMdFlOzTi/WDrRp3SZQ9vy/7hjtFjMzyO4L6odDib1OWa8c51LdccJZ9vHg3xCsq7FjtDxlqKz8hehkhOi1Y8n9aoip7XpwXfDP14tEsiE8wWN1gbjpMx5C23EF1Z0YPptOSzfcxR8kg9SfFFOShfHmmA9N78mBI4RpjD8iLZISFr+KRTMAAFaBfAkHvTt6GNzRJhipib0yTPLVfuJ9iKvuBOzbgGHGqFDVMm2Wqz2WR0r113e2mAHu2nYAZPk9yd0JR+budjsTTxmwD4yN0gNoBPcZ/raj9qhhRM5Sfssmv12niC6E39lZUl6belkj/DFsPmX8Vbv+Vs0iVnachGjz0nENTvcN6TD9fzx+223LNDS5ZTGBvlhN4bD0M6sIdKZKnUiXl+hOfVnb6yZa0gLBVnm1uG7J9iIDe8sJNf5RMs+R/v0PeUwIM3Bpkx0BEfYchs+jo8eFaJXKYRF8XO5KClNVVCETUjH/YY8DVAcKJa5qLdrqxqXfMZPlOAxWQW8gQx/sEB+WGpO373LlK+SGZTUgTSe96Um2QA4V3JBPDyl79oFAYz1/O3J85AMvWmmYxFfq9R0yN0oYeP8cS9b7nnf97kV0fnpzRVQstFEy
 9TdmHLUj
 rTsIBV9Vr/7TpLssz249AMG/bYv0u9EVWydoIN5F5g+pHVsdSGuSXrR4SGQNsIGxbCa9bo9XbNUYyYS33o0YFfpnyP40wda0wCUjoZ3/X34x7sVJc+XI9X2EqZTvzZ8mHzxcRtiJPtM3kLhByMb6uulurXGOMjSYBHwVoHJhcZJn4uyOqXsWyW/WnEBZrXQghBpTv8ZlgsCXnJ3dnqRPTAY4EnEM8qIMvJzH4wK+jkJ5YA0dTCL3cuv59OQd420Z8LCnPHA5YVyPY2dZ2/qYi6mgeqBp+CY9/UDjQPsIWYKcmTOS95TLczaIl1y2Oasv10gXU4mIev0Xa4XA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 5:37=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> The swap cache allocator adds the new folio to the LRU itself, which
> forces every caller to live with that ordering.  The next patch needs to
> evaluate the refault of a swapped-in folio *before* it becomes visible to
> reclaim, because folio_add_lru() consumes PG_workingset/PG_active when it
> picks the LRU list (and, under MGLRU, the generation).
>
> So defer the LRU addition to the callers of __swap_cache_alloc_folio(),
> no functional change intended.
>
> Suggested-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>

Hi Alexandre,

I=E2=80=99m getting a bit confused, as I noticed that you also have this
patch in another patchset:

https://lore.kernel.org/linux-mm/20260818163221.589352-2-alex@ghiti.fr/

Why are you including the same patch in two different patchsets?

Thanks
Barry

