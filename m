Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC4C7CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 08:28:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EBE78E0042; Mon,  3 Nov 2025 03:28:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 274898E002A; Mon,  3 Nov 2025 03:28:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 163C38E0042; Mon,  3 Nov 2025 03:28:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 020398E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 03:28:58 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BFFCC894ED
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:28:58 +0000 (UTC)
X-FDA: 84068620356.24.CE9FA06
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id D2F6B20005
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:28:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=kernel.org (policy=quarantine)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762158536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0ALGggkqCFEX0FeZvPrEJORb6xgYMLiTbPKW+HWNC6Q=;
	b=MU577cGLui12cq0Uf24CSSmdStq6pUMGJ6KP3RdxNWxmQ+Ik/L/DSGTrHbPVgX/Fh+w15k
	xqI66Kcz/w1FO5J3ua/u5Pa/+r7XkAF34X8rXTX4K09ssqQD7YoF7YNCQya1ZTjmr7r48D
	ofjSgpfm+OM49WLe9lFefDqjh8l7CNU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=kernel.org (policy=quarantine)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762158536; a=rsa-sha256;
	cv=none;
	b=Js/wDDh/qkL8D8uMtbbutbej35KdOIs+LgKZhI3MwARJT5WOYG0VRxeRrdekImXAVZ1VQy
	M3kAiPJHkXuNzYKaUkcrcKT4/xNflFGY+0X6/9JsCmUxwrcjovFOMlFMbauKrZ//WJR+9i
	iFpDeMWn1F4d1b5CFkc6XhBd1K8AalQ=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-89ed2ee35bbso665812385a.3
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 00:28:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762158536; x=1762763336;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ALGggkqCFEX0FeZvPrEJORb6xgYMLiTbPKW+HWNC6Q=;
        b=lkplN+6rEie6uZlsr/B6XdHcMjACISooF3hOpQOeMcummybFxJJR7nmRZygO72YsZ9
         ehrWm2rJ5mugWa8BDblRrUjv9ZMwWOUO+7WWtE9fzQiamYCzLmKCPE5TklvBTIfqMv6L
         WCjowF4ipYV6BE/VSF3QH6RCMqMUMSBruwDY8Gkcla5rE+rYU7SfvqmFDp/R0OlWkeno
         Ri0iYgaIalnA9rrbbZ+XJqPkjlifoEIAIFDjZT0bejjwtdtHE5DAQMSQmQgLYzDCUpfV
         19BsSZlNtqqxrCyM318qHFpnBz+fky7hP0bNLLrV4evqaP+65JuFwuprZkOfPmZsULkf
         FguA==
X-Forwarded-Encrypted: i=1; AJvYcCUldIla2NqgTc/jIzuTY92SMixIM6TaUsrdkTjAcNDWebqtdSKvgZgMhsb8uiryPSb6ve0eJFP3nA==@kvack.org
X-Gm-Message-State: AOJu0Yy79rl0k4Q7WPJK3aRGwMMCt8Zk5TAWC85f4CX4PO5fxsnG+Qnl
	p+vuFzrq65G3OCO7kKtqOPzPFbIkZkg/hRz0GAl7mYMfB4x9CdwQYr1P20vC1w1jVUDVpb/PC76
	9Gc9qMX/VSsW7wg2eiUVX3N+0A0HRVjw=
X-Gm-Gg: ASbGncuBel+KIiY/pu8tLtu5eZmOUzIw01orw4DEXpXeQu2g3Fhf2O+xrDoVgQVt/ic
	9UFm/7WgREyS8emb+UVPVg7q5llTU0S4Oh3l2v3kZW7X57MGgVi/CevLpLppuYbHo2yd09snRvI
	7uMyL1e3cs56SmiPTpTimz1kk+heIGZ46APqKY0xzWteDdrcvzjCOYvfARs6D7BFCBH78Fxl+sS
	vcak5PB3s/nH79+zzdzrPIRleYpJ4I30vW6n+FcyYudgztWsTCYoEMcuzy0yNrrOs9qgpNP9O5y
	wTh0opTK4mTTYt9U8RGRhHLzTk0=
X-Google-Smtp-Source: AGHT+IHzeD+UNIt9JhvaMBK+8a14XleqJaL023J0/r9cZgmbQDIdVKFc9aV5c6PSRSKtUe463r+vYPTbq6U5YNNz868=
X-Received: by 2002:a05:620a:17a6:b0:82e:ef43:38f0 with SMTP id
 af79cd13be357-8ab95d76bc6mr1447433485a.0.1762158535685; Mon, 03 Nov 2025
 00:28:55 -0800 (PST)
MIME-Version: 1.0
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
 <20251029-swap-table-p2-v1-1-3d43f3b6ec32@tencent.com> <ufy26fqfvaxqjywneec3hcuky7ozpa2fm63pxcuuberrvicffv@bkblomeix35w>
In-Reply-To: <ufy26fqfvaxqjywneec3hcuky7ozpa2fm63pxcuuberrvicffv@bkblomeix35w>
From: Barry Song <baohua@kernel.org>
Date: Mon, 3 Nov 2025 16:28:44 +0800
X-Gm-Features: AWmQ_bnPTtOR5hKwFnBZ9byfQkqRpfXOBNplM_TV2TQxxp4f9EWRpSuU8LoARD0
Message-ID: <CAGsJ_4x1P0ypm70De7qDcDxqvY93GEPW6X2sBS_xfSUem5_S2w@mail.gmail.com>
Subject: Re: [PATCH 01/19] mm/swap: rename __read_swap_cache_async to swap_cache_alloc_folio
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspam-User: 
X-Rspamd-Queue-Id: D2F6B20005
X-Rspamd-Server: rspam03
X-Stat-Signature: 6hrnhto8t67o5giigds8mcetpib8ohep
X-Rspam: Yes
X-HE-Tag: 1762158536-311238
X-HE-Meta: U2FsdGVkX1+Agf2XGuC+vTnUh9186w6Nw1KQYoZA/gB/y4cfbVMF6Um4OX4UimvJ6JhXzvwqJrr1CaJT0qwsmxF2UQbFdn9bGKLept/sR3ObCGiQ7iFhMWoEFE+R1KOszbzifY3TYKnPsFSm4DWnOM20TE275kuHVRmZAHCBo14cB+dfxPcBj+P6oqPW5gx9vVw/GdfJ0lu/ghHsUZ5xnmsQNnLMBw8ddKX2EmdHZvSaN4O808A8xJTLELbimgybU54xUWn6r5wPjiEdn2I2HjsleUzEuDjUK4uv7BVi9Vp74ZeIV2oqJ7pOxoHloq+uWaouiJOlZcfhCTmpsF2tYvXoYuWt5r0qbzMLZV5U26NQfFRn2tkf649zwDn+xW8NIAT9W+Rzjnb3EwxwAN6hl4hGz5LoiTj5S/f0D7cNLVE8H8OSsku8JHcXGln+GMQXQFT5pYdiAG7TzNLbnp1Vo1KDuEkb5gvtu9qHBPuKFunfHUXSbGKl/uFi8Dz2ljPvA8gXeyLlnACFkjaJYk4mQMRKrlThd/DmkszwwCilOTnYHbAeQWyu/ILlB7ijL9R9ukEdCwCUKU1twaSTAy6NZhvvHLri2RLFS0FRPl8RB0cdgb7u/UXruZMt/b0DkqWfGAN2QYR5XmMRiWwUPIblAAC+5NabmxR+LlSOeoIEPdzVLulPDzRK+Y3gKXSo1K8QmrZpGForaW4IMaEYmtveVw67G2xDM5dAfDoh9pRN5a/QEwb+a3S0Oe72Kt1PmGQjBc8kghJfH6aMYZDN5IpZ/Sy/FHzDuTZyg298pz9crswlQUgC39itu6nXzxWzhY+bJ3hFGPy+so0vyNddB8inaY2OtGT4alX9k3isH+1sl1MAJ5mvDU4NUNS13XoWs3GRZMSR/9vEV2qwEWh/V+oU8oVYb3evLQb56/hEFSV6sSiDM/Ak9j8YYNa4dDn7sfE8pJ5aoXQHe6oCxcFLZGC
 4+x1+6DE
 b334enKENS1k5spii7Vpd03t8h8J7P5cyUXn+/4viP/5wdV9PnnnYiYzjn2pljJOcPK+JMnKLkFMG7mAdZORXToWuNQuW3zU9WnqwDm1K4lBj+kKjQQ3tBVKH5AxTAkw+r1IRdyVdxvb+JoJETRmWP+QgEpFU6VeaW38eKFoiDhqGHMUS7E7EogA7G1SQ8TeG3WyUNHZnnGAufZp33obKxBMrl6Pta0Re9ww/oWP4yjsyhxAjA/yIy3sxHPePBlTK7fQvb0eZThbvyI4TdIPR43Lkq1j8ZJNrClMdtT2tbA9vGqMZR4uLb/7L2kM+JXgJbsO3IIkkM/bcEi9bwz9WbAAyjiWPjw6Z1Lp3y9QXVzyZBsdrOTL76H9BGA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > +/**
> > + * swap_cache_alloc_folio - Allocate folio for swapped out slot in swa=
p cache.
> > + * @entry: the swapped out swap entry to be binded to the folio.
> > + * @gfp_mask: memory allocation flags
> > + * @mpol: NUMA memory allocation policy to be applied
> > + * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
> > + * @new_page_allocated: sets true if allocation happened, false otherw=
ise
> > + * @skip_if_exists: if the slot is a partially cached state, return NU=
LL.
> > + *                  This is a workaround that would be removed shortly=
.
> > + *
> > + * Allocate a folio in the swap cache for one swap slot, typically bef=
ore
> > + * doing IO (swap in or swap out). The swap slot indicated by @entry m=
ust
> > + * have a non-zero swap count (swapped out). Currently only supports o=
rder 0.
>
> Is it used for swap in? That's confusing because the next sentence
> mention that it needs to be already swapped out.
>
> I suspect you're referring to the zswap writeback use case, but in this
> case we're still "swapping-in" the folio from zswap to swap it out to
> disk. I'd avoid mentioning swap in here because it's confusing.

I assume you mean avoiding any mention of swap-out? As for swap-out, we=E2=
=80=99re
swapping a folio out from the LRU =E2=80=94 we=E2=80=99re not allocating a =
new folio.

BTW, this sentence also feels a bit odd to me. I=E2=80=99d prefer removing
=E2=80=9Cswap out=E2=80=9D from
=E2=80=9Cdoing IO (swap in or swap out)=E2=80=9D.

Thanks
Barry

