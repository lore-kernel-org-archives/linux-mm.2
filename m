Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7183BCD6E60
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 00:14:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D07F6B0005; Wed,  3 Jun 2026 20:14:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 881276B0088; Wed,  3 Jun 2026 20:14:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 770306B008A; Wed,  3 Jun 2026 20:14:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6214A6B0005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 20:14:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 059521403BD
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 00:14:54 +0000 (UTC)
X-FDA: 84840309708.24.F221070
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2E2554000D
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 00:14:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GogIS8WD;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780532092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n4YC7t4GlSKsGsaODNCP0HjzaOKMmCDpq3XlidjCdvk=;
	b=o+f5SFKTpQXXrF6OnrfU+VqhLX7WOQEw1K8r8fvWKyMB8hgsT+v6wj3aFOGcXLpJJDVaNc
	F4g00DyFGYaCxTeXBClq6R/2+VUv214eVbyQnhliW8GmG5pgx//NEaNzORxx83HcpQTg1I
	f4g6anO/GNNOUzjzlGryZjGIiMoydgU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780532092;
	b=5msMjTTWNIQf8+v+nmQYdJKtxRND/dAYU8fE2ZBuNgiGTRnH8Gp457fjvrwLG4JkwuxGqC
	D0ph5qi0bLFHx6qkFiAaOF7veW0n6iEhwEZk1oFBESgBTNPP52p+bS2RET09/JtwguBBOB
	XdY8ITKmRNMe0n13UO3SJ7wgVM/u1Qc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GogIS8WD;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9533E6022A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 00:14:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB961F0089E
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 00:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780532091;
	bh=n4YC7t4GlSKsGsaODNCP0HjzaOKMmCDpq3XlidjCdvk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GogIS8WD2PzsR8if7BjsUpZWNxHr0bw8VZoLPMUXHCAnE+Dlo2DAqxu5JqaRHKVQN
	 r6suCVGiluHrbzba01BoLLVlJA7aGnW5ft+6hl6+xUDWbYEop9UAblYXFYYrTFYVSm
	 G5HrvOBO6R+rPucdnSELB8x5QnRcrPZyAVeB+Sr8Q8oW/tpnKSa1Xc8cuJhgZ/fqjk
	 64W6l9Y3EmnKGn1dGfrHLUYS4OlEn9EU7fS/ZjSC/0EfZQnxUxsOTQ31M8OPzHDtJj
	 wogwflS/LVG24wWn6w6tsw9ahuAnt2Zcn9wEPi+zAZndAYVPmS0xZ1BqIRyhTvDZSx
	 Fkwx7YaCqHIJQ==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-914bfa75911so144996985a.1
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 17:14:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/oSdMFp5FjZtzbfdP5aAJoxEYtN0pTPVbSWQ2Qw2T5bndU3iroZko2uNw3IOY4cIlDTDPUImyHBw==@kvack.org
X-Gm-Message-State: AOJu0YwqQ/kdd7zq6j8sRDwv6TsymqejRYdekl0fUPunJkll5jaQ5+VN
	iUgQ31WoxvcZpmEq0f8FDRaULqNkhlUwQ0CWpO+nXojyVpzn/ItqklPgU/wqGFCpXS9OuMz6gHr
	Zgicdz6JzdV4Ndwn8GDG+B2MUs/k8XYo=
X-Received: by 2002:a05:620a:2994:b0:915:8e2b:e5de with SMTP id
 af79cd13be357-9159ae6c1bcmr267493985a.7.1780532090478; Wed, 03 Jun 2026
 17:14:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-0-ce0219e100d9@gmail.com>
 <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-1-ce0219e100d9@gmail.com>
In-Reply-To: <20260603-ch-swap-series-plus-folio-lru-cleanup-v4-1-ce0219e100d9@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 4 Jun 2026 08:14:39 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w-TxtJN=k9zQLYnRkMArTG8R4TVDoOCpjizi-uiASz3Q@mail.gmail.com>
X-Gm-Features: AVHnY4JapO8_ekxXZ1OEskQ-uXsmOhCdlaQcXY6K-wiwXSYgC-VpzegHnhchd5w
Message-ID: <CAGsJ_4w-TxtJN=k9zQLYnRkMArTG8R4TVDoOCpjizi-uiASz3Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] mm/swap: colocate page-cluster sysctl with swap readahead
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2E2554000D
X-Rspam-User: 
X-Stat-Signature: xe9hfhzjqiu99rypjgx1o9t1ejzbjbqq
X-Rspamd-Server: rspam08
X-HE-Tag: 1780532092-191493
X-HE-Meta: U2FsdGVkX1+okmLQ0D00PNkhRdLNAB+ikpeVueHnFvvKART7V+P7W8s5oftJ3l4NIeaABLxcotQN9QlDIhLLOeVdySe/yUHW161ajWlNyPnoLzCCOaOgF1Whj4rdWYaqdquO8XyQd56Pb9VWMxDEQaMriqw5oxeMhjvPahVfmufi5sizpNzoic1tk/8Y555bWAGoBUOfwPofXiboSk8VSshXi/vUEHsMkK94HYyyRl2EKaHP6tygOwYn7CSEV9j6ngAeXitL+sjxU5prFhjduaiSMJo7QQIckVkOzjwwDmP0rLYuconn1AzokkFUxmLcs6ImCTFCKqXfvXoddPbPc4q+1BONtlw/RxltMxl1wRnTI8JC4DV73Vh1wguTUV7JZYslAWaN6Dj6d5sdQUSb4c7/UzAuUXe81hNxypCW7a3jVriV3U4xdDu3f6LTHK9sA1oRP711LDQtn6TE0lybFioudxih2JB/dEe1QA2jl0WsuCaP3vcgwOkLR5ntLMQUnWT208bcoIQ7ACb4+JOpsq/5pCTJ5YrLc1Mez+4XREktZz/APXp6cZqzC2G4htWFvmAeGAP6E9ZJaV6kRXJqtmblsWhy9RNn/1dhudG8Yn/hGSbTTsKaVBj8MyLAlfD8/e/HjsFWgdsnPIJphzp9fzI7WEu8Z6oHfAcpA0nYYm9/OWNfg92zCnEpL8SMQ+rUlADKCTjiq7OLSuRj+i0XKQOd/R1B524Roo3BAYqBtOjFS352djUB8x8zxblcfieE3auvyX6z32SAZPhzN3Y4HERPvfUC10FSMPOs6EhYPnCW/10zGdP3v7LOFqmsmrqV6T6f/dvPdLOjX23cTgg3Jwm1vS+QReqlg4av5a6oYDIUzMGFRMXle+ZEERdZX6Gx2x1aPxYZhDQbA3fokHpASW89BPet1wFso7olsvhLUknFfxYDFKlJ16/+Bn39LHxi5x7UtOOLlFeG3ercHid
 jG/6d67t
 hM1F/Llyt61uIPsouPgpws+MPwyCiGsaA9gGEaL9J1IGIAmrqgSfTcDrgtfsWawYiqoRewoyB0IF6kdsFxnZNLfnPmI0CpO+rttPAh1BLDWVqsPRH3OTL7Q5eqB5nXJhcMh5pc+aTCgJ7LEfQWMxxCFl29kZIxHQsVkvHw8gVCBMzendnE4z++K44xjNdf5LPvSGhYvI9Sjwwzy3rJnYsY8BrSQDC0uia3RmiwvfBbVHfzan8z8xyfBnonWAAIOpfbK3dNWXKQl2lXm2UL1EdKdxtg0nxfePBLhkhZKoBOkWjZ2xJ4xIzmF50DU3ZHwcNnsJMbqgaeVgS3F1eCnFV+GIDy4Vln1kfYloV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 3, 2026 at 9:05=E2=80=AFPM Jianyue Wu <wujianyue000@gmail.com> =
wrote:
>
> page_cluster and the vm.page-cluster sysctl are only used by swap-in
> readahead in swap_state.c. Move them out of swap.c together with
> swap_readahead_setup(), and make page_cluster static to that file.
>
> Rename swap_setup() while moving it as well. The helper is internal to
> MM and now only sets up swap readahead defaults and its sysctl hook, so
> the more specific name matches its reduced scope.
>
> swap_setup() previously lived in mm/swap.c, which is built
> unconditionally, so the vm.page-cluster sysctl was registered also on
> CONFIG_SWAP=3Dn kernels. swap_readahead_setup() is now a no-op stub when
> CONFIG_SWAP is disabled, so vm.page-cluster is no longer registered
> there. The knob only tunes swap-in readahead and had no effect without
> swap.
>
> Suggested-by: Baoquan He <bhe@redhat.com>
> Suggested-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

