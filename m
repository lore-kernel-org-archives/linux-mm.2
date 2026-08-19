Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFBBFC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 21:25:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 555C76B008A; Wed, 19 Aug 2026 17:24:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 505B06B008C; Wed, 19 Aug 2026 17:24:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41C196B0092; Wed, 19 Aug 2026 17:24:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 239116B008A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 17:24:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 18D1B1A064F
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 21:24:57 +0000 (UTC)
X-FDA: 85119299034.01.7B2BC68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4047140008
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 21:24:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SUI3IiA/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787174695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zNqmDH6Jq1rIZyagW0x3hDwfycUXlIykI4fUBBHVlfw=;
	b=AX09/QPqOPBIt46lo2lLt3FiU0ZomjxsHhtz3X4T4NPSyjhtgnO/X1C+Oa0Mnxej3kW7Dg
	lIr/B/vi17OR3oDbVMofZn4wEEYC4V5eHvUnN9f7+RrSf4v8/8FjVgUF6Otxl8OGcmUkk3
	vTKSgLQFgnzuJSAAvRDuzZdRvJr2ezg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SUI3IiA/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787174695;
	b=GI75O5fedVZeug2FLv0+szSsRkMEgQyzgbBWi5+TJtdISUe7HoeTspnKRNCmjuKRcY4pBk
	GqSmbeUIzYX9cO7TgqSfxMtVnOXqcXlDH8euhJpbcaT03+6E/0gC6J5elbWF39uJeJltCs
	O3/DbrTLCbOq1xyOTUsbYigWGNpgKLs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6DE7143E23
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 21:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D871F00ADB
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 21:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787174693;
	bh=zNqmDH6Jq1rIZyagW0x3hDwfycUXlIykI4fUBBHVlfw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=SUI3IiA/1vevgZp9vqFX8HwwBHOS2iwj0lvrt/dLO/QHDWVPR7WoxRa3vauhhymbt
	 FmZlir2JsgFBd0JtVWMWcrPR2o3EI35HCIZWJJrOHitsWT2xnLydWu3POjklIYSRLP
	 LREGAlvahABDbjFU6PZqVPco+hD6HQhu7ULgtECMbNE0sCwYLk8rsKXuICPGQ+GJHS
	 S4E1KE2b3mSUCEgFoIAqrZcOPogRMgtlqVL0uhpabsbDRsvd2bbjGPFT0WKAD8QlyC
	 pzXq7siuDG91CfPYh1ttNNgq687VMtRHU5JOBg5ULNtaoUCHVHjRZcDXpT12E+wRkk
	 ZHREQEj6jG6AQ==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-92e50a650a0so91853485a.1
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 14:24:53 -0700 (PDT)
X-Gm-Message-State: AOJu0YzB6PSvhZM+ie6hsaD41GRRb2g3Vx2l74+GqljYEY5n+LZDZvIe
	SAosjrGWIP0g2+12My7+rMeKPzN1i561eCkUSacCRtc/QY57LRdI4eu4g9888/rvCxjU1/5A1uE
	0zDz8XDDgjirjI97SjOzQmTwFSQfEUNM=
X-Received: by 2002:a05:620a:1a02:b0:936:eb7f:d2c7 with SMTP id
 af79cd13be357-9371e309725mr741046285a.27.1787174692543; Wed, 19 Aug 2026
 14:24:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com> <20260818-mglru-flags-cleanup-v1-5-8dbbdac0d28c@tencent.com>
In-Reply-To: <20260818-mglru-flags-cleanup-v1-5-8dbbdac0d28c@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 20 Aug 2026 05:24:41 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zC7-8OgMEep58TEt0gfcShUSsKeYBGUW5BGEk8U+m8Jw@mail.gmail.com>
X-Gm-Features: AcwNN1UbkL73D6-D0dw7N0OHp_q_gWFKVpfZWkoMrTN9W6bJic7KHpRg9Xi_EFw
Message-ID: <CAGsJ_4zC7-8OgMEep58TEt0gfcShUSsKeYBGUW5BGEk8U+m8Jw@mail.gmail.com>
Subject: Re: [PATCH 5/7] mm/mglru: use explicit tier range in read_ctrl_pos()
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4047140008
X-Stat-Signature: 5nuhrqbugw4i51orf9ubqsubds5ucujm
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787174695-14709
X-HE-Meta: U2FsdGVkX19JGgEeBwUXIJy7xfXmdL2lgzJZT8bvJ/d2WZvBkFM8W3qwADWwWB2lBvlB25vite0IaCNhftAHA0G8Omd5j018tdQAo8/iQSLMTY5zo6cIrTrQ/yk+g/z+k0i8yWEwqOyA6gaCnzqS7fbcUcqYC8le+SaNbJPlHHVIaVIwP/FhP43V63nLiMNYLZ6zp0pEFDDd1Wgv+fVBWyN0lHzPHYhWTWjjFpz9spdOcJMmG8l+GoGASyoEAT7TSo781RqWYTYPsICitV591X5Gad99UHapZF18hY7/uX+BceHtKWi7ePuj/AijdDqeS/od9RevXpZ9+jajyy+GiPBk3GzdJte/+OEKbFDXOLUbwFmwno67dA0eiva8Xn4I8H60ToiEVNjihVWlVlpZwnK4Zm1ve9MecQhLAuGRLwTq4FGxLskWNaRWiPmp7GBcrNyQHEchK/CiVwIIqumi+9RSatFCscP2hlUtRv/48xI+qlxj1uOEBBRKZuhuMX4TNwTJE/D7Nl/OhhHx4afP6mYIvCzkceHtL8xpoO779B31kiL5rPd5Yz+eEAT0sAnPOYY6WWEQu5lCdLBX9sp4+4DqEX4+nQszp5EGb4dm2T8bAe3ZIGO0vcliOUpcNOu0niwNWoacIaKw8KBi/ZXcbr/HvqKwEvowtwxP1nSQ/xpzhz23VMA9qtG8/+syBYzcKa6DH3Xx+AdujZl1Dl3FBYlXYDDSApDsplHLob1EzDfC5J6fEG+E5D/YLMLd2qbeMV/g8QVbbhCJPoTgJecfttQJ1yA4LJgyXnO4yNF0jQHkCyIsLnH68t7OPzal5PwqxWTlRky+FvKHf+31PXdjLNWGTfwrOsbFniAeS5ag8m9+BrPZM8RNr2Jc14g1+qCgucCdCJfjulHOsqDQeK394G4ea4B+U93hUytaCenJmoxYEVU6XIiiHlrulojG+eOR+tCxy5HOTH2QQeSuzma
 GaA5kB3R
 uc7eCcfdes5Jo+Ypss0R28CqcH3VVw13icSSCsQNqLEioJ4iW4LnOrJqkwVDYqQyX7JfN+0ttomDJI/oM9LadsHPSZdHqt4m1eGKEyqEDm5gE/5+qnvYc1VOBMom2Bq5E1+yrzNlRPJDUf8xzuXU5Rz0i/HAAlE943RSzXiiu6kqeHIf303VGM8Ra0VMPxeGaQ3ILAo5vs4RrQPX5HtA0uQjp6wWKPSIeQzp7hn372NTzCNrGx7Jkesr58X3RuL9hTwQTlyxdAlJRu3qWjhtuSie/filY2M9binrXnQaQxUeVI0nZy7ctC8GzBZy/c0mFoHmDOPRprbEOWLZrE7iWVVUYJ6HBbCInuDyk3aueNGV1ezGBnc7KsrfeAOFfSk/MQG0v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 1:38=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> read_ctrl_pos() encodes the tier range in a single "tier" parameter
> via "tier % MAX_NR_TIERS" as the start and "min(tier, MAX_NR_TIERS-1)"
> as the end. This is hard to follow, maintain, or extend. Tier values
> 0..3 select a single tier, while tier =3D=3D MAX_NR_TIERS selects the
> full range.
>
> Replace it with explicit (tier_min, tier_max) parameters using a
> closed [tier_min, tier_max] interval, and add LRU_TIER_MIN and
> LRU_TIER_MAX for the tier bounds. The call sites now become
> self-documenting:
>
>   - get_tier_idx:   (LRU_TIER_MIN, LRU_TIER_MIN) for the first tier,
>                     (tier, tier) for each subsequent tier
>   - get_type_to_scan: (LRU_TIER_MIN, LRU_TIER_MAX) for the full range
>
> No functional change.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

