Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29912606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 17:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UVWFBB5C
Received: by kanga.kvack.org (Postfix)
	id 4BE346B00EF; Fri, 30 Oct 2026 13:52:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46F2B6B05B1; Fri, 30 Oct 2026 13:52:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3858B6B05B2; Fri, 30 Oct 2026 13:52:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1CE946B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 13:52:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2B2471A07C4
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:52:29 +0000 (UTC)
X-FDA: 85380037218.25.ACC58A5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 69047C000E
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:52:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UVWFBB5C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793382747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/yX4qiCWgActF9QSghl2kesacMQRaDgnsGt0G47KLw4=;
	b=Q/srp6dNuvY3vgZhZ7pTy7vVYbicsvpSmDTVNIIM3wG6Jm+nltSHSKRvnMumtNP9Emp78N
	zq0s/bI/Lj6apno8IDG8jA5LuXebxnpmJkZD9UWiTxzJD7MeYZ6xaioiwCmJ1MUn1z4UHF
	NbHwEim1Jhw8ktWB1k5yfjGbBpRbq84=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UVWFBB5C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793382747;
	b=c5HuPXc9knVhxZ8xTOlHkHjxZDNc6rCxn4Lsh8Tohl8jCLvRfyK6r1CtKS8RBgvG2QfIbX
	y5hVptCzk8R4YI446CbCZ/S17C4B7wc6WQadoiXJZJFVnVvwIl5Cb/Crphe6GckhCxHQfr
	jKJhpXBOLtbOo12KhBQvSSeXFQxebGs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CA530601EE
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:52:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E7A1F0093A
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793382746;
	bh=/yX4qiCWgActF9QSghl2kesacMQRaDgnsGt0G47KLw4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=UVWFBB5CKi30fxDlUFaYsC8UqEi+uMGiIvRARIYLKI5BQBDBW+WV7GWzN+bEaGg67
	 mVKNGcHUfB0x68ao0+tXxn5t7NpPpemE9HPaOUrFEVgFXTML22/dGQN0/XYmvUX9rU
	 9nOuZNw2nLAR5yom4NvefAxXeRwtngrdMNTt1bxUMWlnUsYiPLKocQhGuwCErxwHTT
	 fmdXgMoS5xRZ3iInX5b+C46Y5k5cO3ZtwgH8uusLQLm8FROG9oYGtFmqWqRYri9xQh
	 IJzy66GGvJZerDbNqktWyqgLUH+QGZQVFJx+iPKjwmdjDbivpbUxa90EzPQg4nITzt
	 +uHHSoeaSj8UA==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c3f8d72d7ceso163712466b.3
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:52:26 -0700 (PDT)
X-Gm-Message-State: AFq9FYLnTsdeLg/Cg5UJenIZzRrIwaOosecCAELMeVIlM7WYqI38EmGH
	wmNCvTN8c+74vjAM1RKfORo2MW4jaBODB0qlOeUHAd+Cj2z869i/k2o6TZpcFEgjDX9Dl/FmTYL
	kZa98sV+46j4pqDGirC0WmSNQQa0j1IE=
X-Received: by 2002:a17:907:843:b0:c41:5a0e:3356 with SMTP id
 a640c23a62f3a-c4ca7ab80a6mr283859166b.41.1793382745473; Fri, 30 Oct 2026
 10:52:25 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261030095223.325309-1-jiayuan.chen@linux.dev> <20261030095223.325309-3-jiayuan.chen@linux.dev>
In-Reply-To: <20261030095223.325309-3-jiayuan.chen@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 30 Oct 2026 10:52:14 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMF-cj4StEz9okWGROGjBhQ1XFVW3H2nJj3b8i5Jj=zAA@mail.gmail.com>
X-Gm-Features: AclHuK-Xwo9ow1U129u1DE6bxVDM9ppicXKOIUi8wOYOyhyy4kBbPsDwtTVtbqk
Message-ID: <CAO9r8zMF-cj4StEz9okWGROGjBhQ1XFVW3H2nJj3b8i5Jj=zAA@mail.gmail.com>
Subject: Re: [PATCH mm-new v1 2/2] mm: vmscan: skip anon folios zswap would
 refuse when writeback is off
To: Jiayuan Chen <jiayuan.chen@linux.dev>, Usama Arif <usama.arif@linux.dev>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 69047C000E
X-Stat-Signature: xaqqyw67dx8ooq7tz7ppzwyo317iwux3
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793382747-783582
X-HE-Meta: U2FsdGVkX18evXk6AXImq0ZQmtmkBpAgRCiEsVbrd3gnk+TVPXsqkYV27C/hLBHhZ1Z/wUjvqLeiEA2NadVHBJIi4hDW+KyiCJXyCPk+qWy8JTAKLWA8Wor+NIW3FED4K9dQwSnFDyZiYkveU+qUZR6kB+s97OIEExiu0/SxhBHVKBw9ncIod4qV3QWxNvP1/KUJIgifAnmNpGQ5gqEzB9Vaf/hg7sHeqsh5J/Jz8nL2X1X3rSsTLh9ZcALwCBbrOUFxAs85/ZdlbuF3C4LEedi0Sj30sn7VpaDOuKFFCz86u/KaUIOkmusJO/tENpCjKSJe+MZZps7A/KheTpRz6y3trF/8AL7xrmVE41pYmGiMiOsOeCo781xmzTnviyCdbUdik2+QqViI7Vc1tr42lv+E/Cu+Dobt9vthb9zXAZg0ASV+RRrZv0KfaHMfu164iimsmtADl7xSI8NPaKy3g74mhw/5q9qVo4kBqZ+eCXOpCj3yP57CorjmUGpnvJUAXCT34edF/STT1DT5HZ4d8j5FwiQ4REHvAmpXaJycNSVOa8g+Reg02Vchv1JypkgfMty11/3oy9wnA2EDe68xw+7X6c16I5sm08SJwcbPB98t8h8+qfWS+nc9wo+slEXVCkx7Cl4M9Mpe+aXJWPqMFd9ytHUamnYXD3zO3jqEK49kth9qVB+U2tiHPnDNIm1tjH2JVC12+XL/UZ/dojeCC+8brcPNhJUVOUMNuevJxNidxJF2oER/+/DFJywuMJvbfVdZo8jqeaT12Lxa6O5w5mdrhkN0dQy61nqBeRDwHjrehivb+GeYuRH4AxXWssPs3dvckOYTQcQeF7QW841ejnDgj4JyNV0bJXcvV6QUMTftLS/T2MNziY7nlxTnosqqPSOOEGvpITuoCu8Xn3lvPGKUxotF8mql3BUbQs+bYZyTXr7mrw+ruurJ7bNReERYeiw5XXr77AZILSDS8lN
 548wG+6a
 TrC6JY50Xr5KxgAjtsldJyUEgzhgysqkptSaz+//VL461h+0utM9umHoVnQ54aDWVrmjSVPuGgkxg1YF9tAccyRal7T+9iIjQB+8t/X5hlZIUsfEcUzWQms2Xfl6HLwFjMP6ecAiHxVn/a2IuE9GR84MVF4ILNyFnbENriCvJBeHmh6wdjYznABCkjGo55l/HO6xAzGVtsCWKQ20EXncFR+jYrlJU791VFqnL9OHKZBnoGAxE987QgioUHhBkwJoDHyGLqgqLLEVjibTlBIW+uOGnBgxOi6CyqgHs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 2:53=E2=80=AFAM Jiayuan Chen <jiayuan.chen@linux.de=
v> wrote:
>
> A memcg with memory.zswap.writeback=3D0 can only swap into zswap. Once
> zswap stops taking its pages, because the pool is at its limit or the
> memcg is at memory.zswap.max, swap_writeout() has nowhere to put a
> dirty folio and returns AOP_WRITEPAGE_ACTIVATE.
>
> shrink_folio_list() only learns that at the very end. Every folio it
> picks gets a swap slot, is unmapped, fails in swap_writeout() and goes
> back to the active list, to be aged and tried again. Each round costs
> a slot, an rmap walk, a TLB flush and a minor fault for the owner, and
> frees nothing. The folio also stays in the swap cache holding its slot.
>
> The obvious place for a zswap check is can_reclaim_anon_pages(), but
> it cannot go there. Zero-filled folios never reach zswap:
> swap_writeout() marks them in the swap table and returns before
> zswap_store() is called. They need no pool space, they are common, and
> a memcg-wide "no anon" decision would keep them in memory for as long
> as zswap is full. With zswap full they must still be reclaimable.

I really wonder if we should revisit not swapping zero-filled pages at
all, and instead mapping them to the zero page read-only (and whatever
the equivalent for shmem could be), because yes, the right place is
can_reclaim_anon_pages(). I don't remember what happened to that
proposal, Usama do you remember?

