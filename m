Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EFAECD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 14:46:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFBFA6B0005; Wed,  6 May 2026 10:46:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DACBD6B008C; Wed,  6 May 2026 10:46:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC2326B0092; Wed,  6 May 2026 10:46:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA4236B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 10:46:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 68C3A1A01E5
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:46:31 +0000 (UTC)
X-FDA: 84737270982.22.C1CC887
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7D8D7C0006
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:46:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VNnFQ8SF;
	spf=pass (imf28.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778078789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FhRqdYrHyU3h6y1BoEgh7cPXGcT5005JLxeV37oLfJU=;
	b=NsJZmYjFCg3cZW8uK3Dp2r4/q4bRnKZa8zlHUnjpxdp4SYixcYDmyRcdnpT4LlXaTo1zgj
	zgSB5sj1OX0K5KXs0+OHYpKgb+3VACbZqDzQrIPwzMnWxC991nb3ojH9z4lv7ar/W4isxe
	Uib9U1UxMClkvGKVwxWp6H81YeAcJFg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VNnFQ8SF;
	spf=pass (imf28.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778078789; a=rsa-sha256;
	cv=none;
	b=zGgi6Qf3tVSyQqyFFix+ZgPumlLD22zzInDtav7gymudWB7feyzEJNOZCXtYEdztADq90b
	eZYAT2I45k0psgzGROmIzOH0uyYHt7Uc8w0nVUpRJhA2sQy4cT0YTSxEXqSq5nEmkpz+dO
	asz/86ZN4/2REpU2jkJXybPWjQKz2oI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 50FF0440CC
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28EE3C2BD01
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778078788;
	bh=FhRqdYrHyU3h6y1BoEgh7cPXGcT5005JLxeV37oLfJU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VNnFQ8SF2RKFgvFfbQMoFmw0ZHA1pLUTJkO1RKmHx92RZOxiobguj0YDco8BiF+9E
	 jTe4W7G5UQZ5N2mZOzkVllMqF+uZZRdVjf7wJ5mrMP7LrZfkZZcvOOH3AhEtR7cTHZ
	 nsmM5BDgABNPn7a/3Q07SZhA1/nRHu73qIGDvdfLDHtd+6QJgsaeR8jC0S7Sxktzgd
	 ApRL+H0TF5NLa5Q9Nj3OGhneG30WXgEhMaFhcdah86a2qqtjVWetGFAq/9f+w9KuGA
	 CcY1US604TuZmhWQfr8/Hhvff/psTGzVtRiHZCMsF12+8AcGYSnz2QOLM7LUPjrUQb
	 QhtPHxHtI9XPg==
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-651b4d09141so1247187d50.1
        for <linux-mm@kvack.org>; Wed, 06 May 2026 07:46:28 -0700 (PDT)
X-Gm-Message-State: AOJu0YyAFcvPcnrFwzTi2QYv3zcsXN3GuvRHXjn9yC5bRyPzvTymRdlL
	MV6fnN4t+uX9nWIzwihLBb7BivGhyZGRMUwgjBHUF3p0NNrgvrb1NkmhLoVkKMuXwJKIsON7TF8
	rOV+qbUTEPzYEM0Ol0207WmEDdD6Bdh0r4maRKYrG7w==
X-Received: by 2002:a05:690e:13c4:b0:65c:71ae:cb0f with SMTP id
 956f58d0204a3-65c7a4130d0mr2891480d50.22.1778078787418; Wed, 06 May 2026
 07:46:27 -0700 (PDT)
MIME-Version: 1.0
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com> <20260421-swap-table-p4-v3-3-2f23759a76bc@tencent.com>
In-Reply-To: <20260421-swap-table-p4-v3-3-2f23759a76bc@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 6 May 2026 16:46:15 +0200
X-Gmail-Original-Message-ID: <CACePvbXf-xUbOqBFh0kjLxj-dq2K0XwvnH-ToX2fUVwiYLgFZw@mail.gmail.com>
X-Gm-Features: AVHnY4L1sm0VDd9qmvk3L0ISgntS0820Z1TRtzcsAJF_-RRUUvvfkseUIvU6Nns
Message-ID: <CACePvbXf-xUbOqBFh0kjLxj-dq2K0XwvnH-ToX2fUVwiYLgFZw@mail.gmail.com>
Subject: Re: [PATCH v3 03/12] mm/huge_memory: move THP gfp limit helper into header
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7D8D7C0006
X-Stat-Signature: yegiaazgt76betmgr3jhjbo88c6yyiqs
X-HE-Tag: 1778078789-320671
X-HE-Meta: U2FsdGVkX1+pf1IuvNcm+N0q9Dnbm+Nu19/GEXpgyDsy1uf9G4+tXmoi5Q6wGvSEmN3mFCbh6tIAPOusKcmapfrNqxyYLigu76mxh2F7jbzqVV19Ygiv/s+sjyc072lzSiQ12NZgdujBH2xD/hiHPvLVHF8bt+AfOCVghtgxEPd76JEOT2v9RxCYchFW1m1lXM7YGONPtfvgH8ygE3pNiRI7K5VuBeiU40mBtQAJkfC18uN20vYhdTTMFVGkkJ+SMstei7J0LG41qlG/PmNq+bnWhukLLSkKOyksAzNLuz2pifaShsmu7JKUO+2NxHKv8kNSwk8ghbPinY5zu4goJmBXG5UmMngaWpAjO3j7cBD0BeU4iEK8ZwXuVI+/7EqfmVH4PVwNiXzV83SYooyH4cn0YZI4T3KdGHOkIqrRUoOpD5kb88p06RbFT03b13gMjEa9+sLrTQVKbU2bRqsTDMZ38hgjZCY0GYQO0OeLYEMZdnD02Q75NG8YKkdEvxah18Bxvc2mfKT8DtoTDDNEuPYkGNXvk3EVIK6Khd3ois7brjSMBaUwyrjw7i9e1k5wCHI2zKckl/9oQkPTcAiPHFWFgyjSoCjSUkiPcdlkSF3YE+SzJOd34d/LVy0Yr/ygauqrtoVY5G2MnhlUlWiHckUk78dVRzhAsMGUlGPTF5U+Ca5ammJDWC4XHKcsXBM9LXcIHnz2SD13G+Ail3aG1RW8RsllstKr6enGb8ZXt7q4uaroLFCwJ9gYfBJFxKDMlFv80iE+inYOq2inRNW5xaR1G1wqG51Qrt+PxwszXxUEuHBHhbOuGY7fgoypcKdeQveV+pQa3o+KUXevZpnRzSNuNpNpUenWzBVekGUr1K2c0eUN4Hn8Ef9i+WYXTa8e+RFZp1NIvacjYvznSkPtTH/YhTCZ7Q82cAVYWKknP4tHpl6X1qTRaSE+yRUQXNKgx1GORG+xfWP4rwzPMfP
 RBTJuRjS
 OHNtpiaBtMzEXtNinj4nUiekcjPy5gC9y9BubjqDdEkXPxlZiiyDB3LX15AZHyf29Gqr5E4M2YZy4FV/p/pIiGe3xrarymjUDivxkiqtEluZkhMfSJH8wMlKKddHrbo2gdt7LTU3DRjYpq/09TBv4AxaG0bF38Z5mhGcS4L4ehvN1LvRVr+8ZhJanb5tkiYAwj/cyzfeJ+v4wmQppvKgl2Eon9TKEEpWK4ZYl+T26Jn/61bKLcrhSEPteynY1BDh0VETGDrAWj29+U5flTUdz9XgNG5QWMEkl3nXP0KY48Nya7bphhmUfit6FAFik8GalIUAJfk7Udq0dS/Wm911wCShDx361GF06HgFlU5kt/tn0RFIKc9wAg2uyUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 8:16=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Shmem has some special requirements for THP GFP and has to limit it in
> certain zones or provide a more lenient fallback.
>
> We'll use this helper for generic swap THP allocation, which needs to
> support shmem. For a typical GFP_HIGHUSER_MOVABLE swap-in, this helper
> is basically a no-op. But it's necessary for certain shmem users, mostly
> drivers.
>
> No feature change.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>


Acked-by: Chris Li <chrisl@kernel.org>

Chris

