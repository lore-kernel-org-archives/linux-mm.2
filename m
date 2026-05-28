Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D61E1CD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 17:10:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E1166B0005; Thu, 28 May 2026 13:10:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 292486B008A; Thu, 28 May 2026 13:10:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 181B06B008C; Thu, 28 May 2026 13:10:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 06E736B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:10:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8A464C2AD4
	for <linux-mm@kvack.org>; Thu, 28 May 2026 17:10:07 +0000 (UTC)
X-FDA: 84817466454.06.5A189E8
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7DB3040013
	for <linux-mm@kvack.org>; Thu, 28 May 2026 17:10:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="PZcNKx/S";
	spf=pass (imf11.hostedemail.com: domain of fvdl@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779988205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lv6//oA1a7THM67qaA3vuUtIcfPcIRsQ4kQegGGiXDA=;
	b=PzdCKJI3U5XmMMBWRYtifBtmXa5OVtPB0T0R76GKIUjSAVfQePWlUyPatbQZ0i2fYOdE8Z
	gzmbXIBTr+bt5hhqaFtMFNS/b56vL/hwLc4pjkp/7C7LRiT7Ij2rcbhmuAiqUpvsvF0RzV
	kdEjiJ4MvEORBxhje2VqZUxPwTxiU/o=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="PZcNKx/S";
	spf=pass (imf11.hostedemail.com: domain of fvdl@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779988205; a=rsa-sha256;
	cv=pass;
	b=q6ECbs2dUJ/kwu6JV1ReCOb9sqxY6IXeIOt7qB2QGalfsFyqIIWsD6PdOrjv/ffRo2HNLN
	9eKEglEw0IPZgDsoflThb3xSw1HoOYk4hs+yN7rPzmjLiQAD1Uf0mIR3pEtC3um1r3VlZL
	3G5X2FETa/pSShKOFPfFI1vWNtAPCeM=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4903893a0f3so315e9.1
        for <linux-mm@kvack.org>; Thu, 28 May 2026 10:10:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779988204; cv=none;
        d=google.com; s=arc-20240605;
        b=c+uC/8indgrQVvnRXn9v0sfika7O/6jzYEa2GXqTZi/9/l1zht+mzHsy8SBs9TFUZY
         uVXUdfxjc9ADqvlvGCrjX9NOOvAMNTjiEc+Q/tAZ14qB65FVL1ezjhtA3Nz/8IN0XOtu
         Eq+0pXXv0LVnN2Okv5ETwDkBdH2Y+FMt/4CFT7PfvkdvCjBwgA6IkSvrNOM7K5npfGkn
         8hVJI0eW0ECzfZT5HucKnA4FfdfsZWbFWitcmRQPq2Ti5CGdG5B0bdqm7ebRMhbyj2oP
         xDr3+6VR6ssu9lWd5RE0EU9goP7MYh0ZD/t1DvNnYgL1lM3JX1QLi4sPOJOkK2l/hO7T
         RN8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Lv6//oA1a7THM67qaA3vuUtIcfPcIRsQ4kQegGGiXDA=;
        fh=7pOZP876tFdFpommGIYpWWgblPAzbVijbSXS5Nz84G4=;
        b=Wrv7T8NGP46uyOJzwSU9XCjIN2V14vkOoLof/5dH6vSyoUdCqNMo/p8dChj8KDlLUg
         nElgLSvM1sJQYc8vs4zcZbRz5ECKw/oNcZElu7ynDZxY6zAK8cqfFcuQQZyznGz/VwRs
         LDve67VdMPfKH6GQPmMWBD2AkLJkD+bgH8nm8JBmPr96G4ps1Zxp8EgMcH9nGagcs/D5
         JR6CkSSV5QkgD91k3UotOHtV++Tqq6AxX1m8gAgkDSPchMle7+pK6cS1SoZqFcamVVjy
         QVooF9aMXDUfGBS3rYoeKiT/GVYqylRqYjN3DVWCTYa0aVs4G5gd5+y6QW9UQY7CJyHG
         u10A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779988204; x=1780593004; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lv6//oA1a7THM67qaA3vuUtIcfPcIRsQ4kQegGGiXDA=;
        b=PZcNKx/S4omye7nmUhq7Ekdt0Fe9yvLAAqzT/JbUWfbi84uwZOmlE8W7f41v+HoBIb
         cvCBLaMa38YxD5HTVV4fHI/oHlkT5k5tySaACEV6G+xUS0UakAZlr3nh/++MA1TUu2UR
         HluDL9doyNtnNmBTKtXZ+hq1ZxmpvwW0G4TSXe5Citutpi0yrW/9aaWpdtBKcSKc4zvO
         ZE7M1OktB7GY+Em9u5DFg2eMdPGjg9TFZJqs8ztUQQYHYJ09vk1P3KQqOjs59ipxaxQX
         jvPm5uhkX0CYiz3nT95KUedHsbgcA0mX8cl8JZrs5RZBALcDITjYViQPrM1730mPUzzv
         Q0dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779988204; x=1780593004;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Lv6//oA1a7THM67qaA3vuUtIcfPcIRsQ4kQegGGiXDA=;
        b=NCDiJj8dEsFD6ClhZHjW7TudYgCs8HC0baOaoWy23j7DCnYvLZr8VvTsBveGChZFsZ
         zt9ZGdomnddTkTYT4ApQP1IwLi7gJ0EtwhTAAueHdRR4CyNtg15EX1yHAAnNiejfRRnH
         ehWxp88/DohTqG/TuHyOb9DxugRT3aPuLpGGYL89TiCFomHGaRyBKwo04gJjXWFHXDsT
         0r7RTDn8gfXjZrXwwm2ocqFfuIPxW8IJkboqUv9fQa0RRyqGnEk3h6dxDSeFQsItAK7o
         uA7Ma0L0qb/fhNHAYPr8k9O3pzu7Vxgy+ROvxZ+s0eP3wNhL9BZbp3FraIr9+jusf6P6
         ytrw==
X-Forwarded-Encrypted: i=1; AFNElJ9wk46EyOGMfxE7lHa6xD3HiRqpXyAUGT9gkQehKGVM9yix4+pGnKmZIJ21d+t4SK6fDoGyCPcfag==@kvack.org
X-Gm-Message-State: AOJu0YyW2KnHBMbTnGe7hBwtPBoEpG9smuIcZtyj+HekIEdcr7ejJDAU
	3u5x/0g6rJn//HVrKOb9sMFQBE+eV7WAozwXVTfMcJ34Gq8d3DG5WnxeLvKtRnPSYZReoaiWC49
	viEX/uCKZ/qqkTjKfBiMr7KHIzBg7E5eFvruVdsaW
X-Gm-Gg: Acq92OHoNExQEBe18+zYIldsS1HkCRX78SFkP67EBuouKlcR11k6nr5PoSbLuvWN4q0
	y43+w70yE0N62PU6JNRSv+lX8jDHqHC1Mtx0DU2xcQiW1Jqu07SzCPiOqWSX8RLRb5cE4cVdhro
	1aNyDduaDHda3qMPPmdMxHas4WFB907ULjG+niOoU/uTsM7x9mJw+j19c/du+Huv/v6mwyicsi5
	8d8HmqXh3zw8Cwi0/qvQBybudsYRXYr+ApM+Cby/tcm9zGaovXlvT+7nYb+TbbbIqPUIgPES8MY
	6l7QbLjKIQqBvQcHUQ==
X-Received: by 2002:a05:600c:996:b0:483:6a76:11a6 with SMTP id
 5b1f17b1804b1-49093b05d6amr512395e9.5.1779988203502; Thu, 28 May 2026
 10:10:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260519012532.272770-1-jp.kobryn@linux.dev>
In-Reply-To: <20260519012532.272770-1-jp.kobryn@linux.dev>
From: Frank van der Linden <fvdl@google.com>
Date: Thu, 28 May 2026 10:09:52 -0700
X-Gm-Features: AVHnY4JaQxI_tsvRZopVYicRUMLIMjoYxczRDpj5956S8XJzKmQl1fmpdHv6roE
Message-ID: <CAPTztWYuYA3qBTQrnRVH2W5yxyBZt4OM7Ws3vUxmRGNriOeVEQ@mail.gmail.com>
Subject: Re: [PATCH] mm/page_alloc: skip high atomic reservation at or below
 costly order
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com, 
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	linux-mm@kvack.org, usama.arif@linux.dev, kirill@shutemov.name, 
	willy@infradead.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7DB3040013
X-Stat-Signature: f6nix4jj1i68us191ssrkccz5y38yeua
X-HE-Tag: 1779988205-587624
X-HE-Meta: U2FsdGVkX19rgtFF2PbtQN5MqrGXhiohtR7/kRR0ppFjvj/Lr13zNGuglLrx5sI6o8LP3Vq3FZ8VCfe/c7lc64gpY1Dc2/4EhwpVJ7QNHB2RxRIvAUuidbSV/zmvP8YljsvSilR9v4lmmp+4XR4m++AdBh0qt3NkO6oGMj+Vjko/OLtZ8FjMPIzHpcOjIWhjvAepL7/PMqnUEAF3CcVy43uRsIUpn3u5vhuDclNz66o8Y2npctjTdcpJ9ZA4VWr6KeHH6Ea/x0dHLERMD7rxkj3ezEpL3nerMupYNTMSoiXukVZ8gHVlbgO2Nw9q0aOcra6bJJeEiBp/qej0YuR4HFPTANd66tqK+yFB7JcAuNuWRiS+SCyfXvT//tGEJ2SSp9AjY08wpdU9zRF+tNITAaaSHnf+yIwOx9ha8L/dFRNfzl5vNHwMgzZ3/l50HmgSO6yP1FwwjYB0xeVXTZLSb/2XyzXurvWAQpDRtV3mMoR9vnHcK025F73++yTshEwWASsVixWG9Z/YzDJ9LNdKqiYl0qijgRVUbJYEZg8sLWzMjJhX2exfzxRKuqmVc/8lZVBtcvl8BDLAQ4EuYg2b2HX/2AlAB6TI4acr899I8HD7Ypn+spXF53m56tPOrUsIml4/5V/cudkyOpZriXvqKR+q5idZSTguqPmE6jF9OfLIVF0L/IjiJpZ52WChEl1sPW1kFJRG1hNkb1/LpB0AzzH0dbJDIgcU8cdmCJY0D7OX9QfA1VbjgNRX+lVaalTy/sJeRFiHHvUHhLiFQuAJHwFR+t1L/XZdGBsxCNSpFVmss9s7DJzBKJf+N5bqMpvJpy/Tta9uFFDzd1Te0iIvAX5BgiALNqqkWh/RYUOKYa/gDJ9QnGE/Q0tFC4qjXxauvQFljxxXNJijqFqakEoTNYoe/794uE/O0pl+HwK5IVh0O9yYGwrlppfh7N4f3N4mC3PujqzDl7HO9wptRez
 EXq7HOMC
 7N21btrElQISRJMpZifu2v9l9f7+yKVpi4RpvATP9jt0cTkii++MoCmGJtYEDWfU27HPNMO76LEhlS3wIU0Yjm2JA/cZ2Iw2ZGRs4dx4BFbi0jFlWXfUHJAsFpVw3Qo8ku0+SM+yc2m9dWkDmUWgXJqnkBz5wTOOIPvWolrxZw6WS+PCucPvybA55u28jSrHA4JbZIkliCXRfrTpTSIPoTi5TH2sla7ejizeZNsKqjd8KP8P1IwqWvs8G1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 6:25=E2=80=AFPM JP Kobryn (Meta) <jp.kobryn@linux.d=
ev> wrote:
>
> We're seeing a pattern in production where 2MB THP order-9 allocations ar=
e
> failing due to fragmentation and triggering reclaim on systems with plent=
y
> of free memory. Over time, the success rate of these THP allocations do n=
ot
> increase at all.
>
> Inspecting zone->vm_stat[NR_FREE_PAGES] via kprobe on compaction_suitable=
()
> indicated the given zone had sufficient free pages for order-9 allocation=
s,
> yet they were going unused. Drilling down into the zone and inspecting
> /proc/pagetypeinfo revealed why. Order-9 blocks were accumulating in the
> zone's HighAtomic bucket (while zero were present in Movable). THP is
> unable to draw blocks from HighAtomic since that bucket is not in the
> fallback list.
>
> The heuristic for reserving pageblocks in HighAtomic is that any atomic
> allocation greater than order-0 will result in the full pageblock being
> captured. This means that an order-1 atomic allocation will over-reserve =
by
> 256x, a full 512 pageblock.
>
> Gate the reservation on order. Skip for allocations at or below
> PAGE_ALLOC_COSTLY_ORDER. This prevents smaller atomic allocations from
> reserving entire pageblocks, and significantly helps when THP is in use o=
n
> a fragmented but otherwise healthy system.
>
> Testing was performed using an A/B instagram workload receiving prod
> traffic. Each side had ~60 hosts with 64G memory. The patch resulted in
> several gains:
>
> Unpatched
> HighAtomic pageblocks per host: 309-312 (1% of zone or 620MB),
>   ...all order-9 blocks in HighAtomic
> THP success rate: 1-6%
> Compaction success rate: 0-2%
> pgscan_kswapd (total across ~60 hosts, per minute): ~70.2M
> Atomic order-4+ allocations: 0
>
> Patched
> HighAtomic pageblocks per host: 1
> THP success rate: 44-78%
> Compaction success rate: 24-47%
> pgscan_kswapd (total across ~60 hosts, per minute): ~29.9M
> Atomic order-4+ allocations: 0
>
> Note that for this workload all atomic allocations were order 0-3
> originating from the network stack, btrfs, and scheduler.
>
> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>

Was this issue reproduced with a tree that does not have your patch,
but includes b480cbb07102 ("mm/page_alloc: don't increase highatomic
reserve after pcp alloc") ? The symptoms here seem the same.

- Frank

