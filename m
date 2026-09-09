Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F190C79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 09:31:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 789E16B009E; Wed,  9 Sep 2026 05:31:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 714686B009F; Wed,  9 Sep 2026 05:31:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DC546B00A0; Wed,  9 Sep 2026 05:31:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 307A26B009E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:31:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 65EAB1C03C6
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:31:54 +0000 (UTC)
X-FDA: 85193706948.23.C6EE9FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9B4F81C0003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:31:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FAlhbD7/";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788946312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NFgdN8VYLiotA1X6CX/YGSNfCUyM0k24sUOYaVWvi8s=;
	b=yxHVlds8XsmXJ3FNOzufVx38qKQohCbSlUChsDRmFjh3wMWkXvCS75wY/a+ENmb37XHhme
	B+ak+6SxPEgbxIa5/HDQzMmtJZnS8fHdRsR//xdvLWtwqEIxfTJQxWCSg0GxFNbDo5jEHh
	NoIKN55NjaW2cL97h2OnCkdzlAKgFsQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788946312;
	b=R8eCkPUl+V1GVsu38VVWritO8anQQx3TW3pKUz5zo5UoCfHUs+Y/Ulm+KN6jXXOFrRN/vu
	iqV0M7eCBV1UM8A6X8CuAD9Tz8TM1avw2ZuG90bQ58g0RBaXUuDdxQH6p9mL0gs2sDvqOk
	rbHIHMuVDHlT4s3qBm6N03hnbqIa/GE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FAlhbD7/";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE47540B70;
	Wed,  9 Sep 2026 09:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3211F00A3A;
	Wed,  9 Sep 2026 09:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788946311;
	bh=NFgdN8VYLiotA1X6CX/YGSNfCUyM0k24sUOYaVWvi8s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FAlhbD7/F+IcjEEV7rddqYf4nNhaQaTfs5c3xo21KMjITdNOeFjAZSWZVKaNaYWmL
	 wMocD3eSNpcoYKMuoMoziizaDhGoMMmvjgIMXen0QypHfn/FnFlyqPvwjm8m8Ash0b
	 2124ADpW42GpbGrOhi0VlcZFAMz346d5LY354EuLixaAlJVI/pJfGkfdksC1RuudwS
	 x9F0o9gyEeInbzy1PuRoJpJrsFxH0vBJCu3TmD7guzmA0kyF1m9Lcv5JvbykUJdUrA
	 4RCiNmgSQaL5maYkDiBZroV3NlgMq3ZyMIArG0LpIEX10pNHdftre2gqAgLp2S5gwg
	 4m/K1qxZswUeQ==
Message-ID: <5562d89f-29fc-4a35-aaaf-b8aaf49f6cdd@kernel.org>
Date: Wed, 9 Sep 2026 11:31:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/17] mm: Introduce section-based vmemmap optimization
 for HugeTLB
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260825084608.47437-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 6o96nwdqinhebmamwk5b438hb3uwta5e
X-Rspamd-Queue-Id: 9B4F81C0003
X-HE-Tag: 1788946312-152415
X-HE-Meta: U2FsdGVkX1+878zVs+R0Hv4sO2yp5EFW9PVyxOXKY8KtyYNRUCGH3V3TF+dA3pDxI3EH1pRyjMQlUAUudhF9/jRe7/CO5Zc0wIu11iW/bRnbfZ7Xq2vZ8P4q4d5GkJEgWMEXjZK1IzDtpPkmgu1upzvHo2LMCINP9pyEcX3KSMb57Cmv/mIaFidzsHn19uIFBrV3neTeQ/Lm1oWnqntSJg1XNfGBlZ0SrdSPUjjYe3WaLv9zx4eVe4Xo/ZFmrK7CYP4PM/XVBF4DTuhwf7ngQr53ZUxSUjdnROGBSkBiK4K2rLfIIaT+RcEX00YX5akmyK2bfqyBNrAH+zHxZxCuCOUhCyNL8Ug9hFH4dZOBQvvVCwquhM/176uguXxsNjzG/oW0kSaqmHyyJmZxqUTXmaV6HjExLqzrpOFHb/0VP20AihGiPDBfB+P+NRprZpDp1HpQubjytvLe/4dv6Iafe/vG9nrfBrGb2D0DoT4LQP0KxdYjDs2MK8R3GDyL691tupz6kEkGQtgYaVS5abtLAOtiptfJpnsiGF8JOyykFevl79gyhHs84LUeiCj2fRa5ix3AwFOLLLHROxD0jOnPBoveqPjVmzpnw5YBpzLa7M8xzMejw4YqAAurkV0ZdJZ0m42oWvq+fuUVDKMLrS2UtN0r2qN9U1viYVssiSHqygat3c4M7RHHmvPNaJ8nJWAtRyYwnVyr7w6dKsk907qLegSp01k9DVlJ5jHwymK/Mc4VCIyKj1xDI6h1pK72Uveq6iNNjG9vI792aB0IUisfP1Iw6jHhIsEDRbnNs/gIrI+EeTJfZQkyGXk7bU/0lqiteZo5x8fODH1LckRbQzNKTq1kso5ZLWHtWmp3dPP+z8RZPcYCEpOzgO6PMtOQ8iQxMco+cIcChY5Rg/bt9rlxol0kpCStWNJ+oPjJsqekn2qNs/2N/EhlAD7OucRM5aaKtVy7XtPu7aHPNkt22JN
 64XZ3N+p
 mluKEbxTlw89R5SnBjPZTcqmo5qF2MzXtiyQ3ZfJUWuwTyHG89CiVUXoXT3HIhPoDn4cs2E8E32RHVmAxkwgrIgYMKS5HKofx2hMyjFSgqs6r48gTf3xLC8b5Gl+ntDex/Y8XyaY+NAre44S9yL9kElfSww4FJkQ/PWSqz8HqfuBLwdLPfCgCk9vLIm/IszhAKVTNZmkPOGrTHRAUpWqut3DGTHNdkgyBg47cL0mcbMawPddjn+GoRpu4I5SgEbnYPdb1Vas6Q2md7ImdGqzgOvpPEsXT2azfrYgOVpJZrA0HLMr6hz1GrIgh8gX6IsZyDJH/NlvR4VVWeQhyUV2+dbBeUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/26 10:45, Muchun Song wrote:

Rebasing some of my sparse cleanups I have pending for a long time, I stumbled
into severe conflicts with this, so let me take a closer look.

> This series is split out from the earlier, larger series "mm: Generalize
> HVO for HugeTLB and device DAX" [1]. While the parent series generalizes
> vmemmap optimization across HugeTLB and device DAX, this subset addresses
> a single, self-contained step: making the generic sparse-vmemmap code
> section-based optimization aware and switching HugeTLB bootmem pages to
> this path.


-- 
Cheers,

David

