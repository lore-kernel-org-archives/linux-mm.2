Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60968C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 10:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53DD26B009B; Mon, 27 Jul 2026 06:56:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EE9B6B00B5; Mon, 27 Jul 2026 06:56:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4075B6B00B7; Mon, 27 Jul 2026 06:56:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1DA536B009B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 06:56:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B40511C0E77
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:56:22 +0000 (UTC)
X-FDA: 85034252604.02.84D26D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E10072000B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:56:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Uls/En61";
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785149780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WxHYI665dp498Hf8ogNlHr/1ERykc31Umcr1WaIqIjU=;
	b=E3sZspN7r8d06PKo/JQ20TQ6E/iEk9AK2iNWVnAfa33GmPb9bg/SIfpl3HAfpd5VkbPVuF
	6R93C/LDwOp9YlLU1lwKXL4L1xn6COLZY8+5UwnWJQ0UPnIs7qhERFMsWWApdWLa/cdTQY
	HVo9tSY3dzfvs6Gntg1Urio2kQ/0x+g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785149780;
	b=BnervScxX02bLhzpd1honnWBmz7kMesDaV+nmgB3VOPAq5Jcllo20MSrCow/HUv9PVMjaA
	JvzHE6Crbnv9k54o6oBQJ4uNUrABMMkb1MX9f/vzru7+bI9rjuFcJrnL5uHx/+WT/R4DYs
	rcUf5TjMMxWNAqxbWjn0HDODHaMIq20=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Uls/En61";
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B756D60A97
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC851F00ADF
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785149779;
	bh=WxHYI665dp498Hf8ogNlHr/1ERykc31Umcr1WaIqIjU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Uls/En61eAu6DSrRd5J1k6BGxPhVIHLmLt7m0Eob11dJoM5xHO+Eg8LlsxUhHPPXF
	 CXsnFAcSdd2TL1BmX+jSbBoFMesO213HmORAUbwpqKKBtz68yyQ97kFTY4mmkcb/2b
	 i/00S8uQMZ8vLJ/O67Y86u7u4J7cU6Ti4+Ykc1quN5BI8xSeZnlEgyFTyY3kI+4EUL
	 ZXN82/V+u1I6j7SR91pijYioRVp/HstHyUVnq2lxCFKw11MTn6ZsN8QnbJMgRtzL0G
	 K2D1wHNKgEB+s/JbfQ42A8eWsa4EwpSf610eTm0dtFAnr8ipy+5OTs6lVrooH0d0Ug
	 cGzcQ6/I7fqNg==
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92e53581361so128972685a.1
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 03:56:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqdTCnDtgVluhv3+LS9wNEChuQ9letGgU4Ke2Xo5uq/dBBsKQLmqqCUvsoPtJb4HLWIoOqqDETMeA==@kvack.org
X-Gm-Message-State: AOJu0Yx+jef+xcvnjlOeXrvzHBKgR5MHf+HKyHp280wikulIDW9wVIam
	PMZbRXj49NuQOGyQDNBqFWGNO3XA2bdWcPmcsoIZC5KR1Sh0zLVFr5K1GAk7K7xpHnzhDprDVzy
	EFaoiWDBRqiTDgjLRgglCVdutztaQ4do=
X-Received: by 2002:a05:620a:838c:b0:92e:d7c7:7de9 with SMTP id
 af79cd13be357-932df6767ddmr738034685a.8.1785149778642; Mon, 27 Jul 2026
 03:56:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260724033435.2573323-1-ridong.chen@linux.dev>
 <20260724033435.2573323-2-ridong.chen@linux.dev> <amcUqfpjE9lnXkn_@tiehlicka>
In-Reply-To: <amcUqfpjE9lnXkn_@tiehlicka>
From: Barry Song <baohua@kernel.org>
Date: Mon, 27 Jul 2026 18:56:07 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4znMXrSYEjWOP0jA11=paJWmWu9fOPAfZD6iP11viys0g@mail.gmail.com>
X-Gm-Features: AUfX_mzG_sZxq5gF2Skzn7k7DesyvTKqkl5R0WB19rMS2U-Hgt5OKvwDEtE9hYM
Message-ID: <CAGsJ_4znMXrSYEjWOP0jA11=paJWmWu9fOPAfZD6iP11viys0g@mail.gmail.com>
Subject: Re: [PATCH -v4 1/4] mm/vmscan: fix anon-only reclaim evicting file
 pages when swappiness=max
To: Michal Hocko <mhocko@suse.com>
Cc: Ridong <ridong.chen@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Zhongkun He <hezhongkun.hzk@bytedance.com>, Muchun Song <muchun.song@linux.dev>, 
	Davidlohr Bueso <dave@stgolabs.net>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: gdy95zgejob79q37sy57y7jfwxxkqd5r
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E10072000B
X-HE-Tag: 1785149780-334098
X-HE-Meta: U2FsdGVkX192us7Mu/bZ1QsZ3+yoCQcDW4IJlO5swjuTt86f2MUDHTcujFx20HiIiF4Hgk0uINHSsTh1lz3LSFpJE0K36+e2mJvqBSimW1xIEqgwM27zb0QQ+SxH+F/8g2+G3vtwv8WRL+zZAEnaU+TgE2LEKCIFzv92jESxXSae9ZrsvW1L2CgLDzxZjNvHuZRdZEq6z5tAm4kmUstiaWQkACiwPjiHPulPSXXohPvu/CkbOjBJVO33LPL4GlMQPQxCQrIzqUI0wm17yo7BPdJ2K0QsxK4GRrCNdTeGY7N3btTu2ld/2MsU/kpL+5A4utp6vhK+Bl5oO7YAt9qXO7DLLtLItbr7x8lmoM/u1dEIc5rXQwRGVWo/JGMG+CN0js4G2oL2T1Jx686KzCLLnt6TiKugLyGxw4ltoHISNoIwVVaFBjXGVSdoXAEcQTqUQD+yhRVP7tQnm/xuv9V/w419CiPh5eoWJCqS/EdDLckNg9EVXRYR+uv9DFCU4GqtksnKkyBBuJ1YDywzt3vD2gEeaYqdgV1jMzohwU4kT7GNGauuIEynNwoA/NhXM/OLpWIf8+M9YdbuFY1lNib0iMQ9PHAOgY2nTy4t6mQFkydTpFOYgcH0lHJ7fk8m+2eY58WUS3Z04hc2AKgNyvdzbRpZuTG+RtdUVSX5+ZteMuMQG6/0L/Mi3tPrECrZM6sTZfja3777lWuyDW3qnShtjkVuzNc3Ni9kjg6cxlhWGT/skvCmphXtE9HaQhbp0u7wDy+CMPi8GTb3/6jz6AFVIw9lSUftPyVzxGyD1YgzjBfim+swYDW22ZdiAxDj7CCHGUWftGzIlX9rwiR+P1H3oomPTxBIYVS5mINQTW+Kfj/gynWNE9yymTUuTN1KMMd14NZf8TtBQ8W/UO1mZsXlGf6AMzk+RTg2uUsKPU3GokD1+svtr2szIZ/fme2O9toVxyH2R0DSOEdAJBsL/LR
 KrJvWLut
 RDmJW4DoysqSfT5L2wFKHDE2LonqF5qYwL9EyzEavHxS4VFK4OtotZNx59iDxbQeU/sMarr0TVkMkuJ1M9Jy97b562Q5Db6wRIom5fUPRSgCMTe8CGouwlpYCCJQfODoEiUzSJ6e8rtPi8S+YQ/xKIkhM5s5cvBjL8+IEqYon/i3h1FqyMiGUPeOXlY9TXjxOqOjPlnTzlLzNSUCuwS8KQ3fgmMW2Q26meySlr4ii9/f+I3izjtDR+3ZhDqIUEAIvM5+WaTz3QG1loyPn1mA/PojQEwhkenXpD8HKNNKGc2R9/HmQSXI0xFqv+Ca5sRK5gQcoMLRiYRFjfnpin8p3ZWPHhSSQmsF4VTr6YckcIhgLgmIOgbqNbWCbpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 4:19=E2=80=AFPM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Fri 24-07-26 11:34:32, Ridong wrote:
> > From: Ridong Chen <chenridong@xiaomi.com>
> >
> > As Qi mentioned [1], when swappiness=3Dmax (SWAPPINESS_ANON_ONLY) is se=
t,
> > the reclaim logic is expected to reclaim anonymous pages exclusively.
> > However, due to the current ordering of checks in get_scan_count(),
> > file pages may still be evicted if can_reclaim_anon_pages() returns
> > false, which contradicts the semantics of SWAPPINESS_ANON_ONLY.
>
> But if can_reclaim_anon_pages tells us that anonymous pages are not
> reclaimable then it makes no sense to try that, no? What do you expect
> to see? An OOM killer?

This is proactive reclaim rather than direct reclaim, and
SWAPPINESS_ANON_ONLY is only supported for proactive reclaim. It
therefore cannot invoke the OOM killer.

If I understand correctly, this is exactly the issue this patch is
trying to address. Instead of falling back to reclaiming file folios,
it returns "bash: echo: write error: Resource temporarily unavailable".

 After (file cache is left intact):
    # cat memory.stat
    anon 200704
    file 67178496
    pgscan_proactive 0
    # echo "64M swappiness=3Dmax" > memory.reclaim
    -bash: echo: write error: Resource temporarily unavailable
    # cat memory.stat
    anon 208896
    file 67178496             <- page cache untouched
    pgsteal_proactive 0
    pgscan_proactive 0

Ridong, please correct me if I am wrong.

