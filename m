Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 254B6606A323
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 19:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WwErtu2m
Received: by kanga.kvack.org (Postfix)
	id 3E56B6B05B3; Fri, 30 Oct 2026 15:03:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BD516B05B4; Fri, 30 Oct 2026 15:03:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ABE46B05B5; Fri, 30 Oct 2026 15:03:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F19556B05B3
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 15:03:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8B4C9A8482
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 19:03:41 +0000 (UTC)
X-FDA: 85380216642.28.6EC276B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 71FA7100014
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 19:03:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WwErtu2m;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793387019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G1TbzJA7tvuemQF7QxmCHwR5V4XpxTBrHnE5qnrFYIo=;
	b=Vnled/0Pn6UL1mibcuGtM3ep/1zq1dybkYMKKzExrt8ZeYoeq7SF51n/Wj5YfwhuVqgLaC
	oZYTUF5NLR2s+3dU1ER4bX1j+42HbkMs7BR3xGjnAVVxd+iFLmk09pcYZDHdt7RO1xHffQ
	SnyHkIdB7fO/ryon/ZmUCHnBxfGpc4k=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WwErtu2m;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793387019;
	b=Islt3MQfeUVniOyYAEhaNcqdoAwP7UktWZD5yVfSCQzQoPImGX8XIbZZgMnrWH1xzGZJeC
	8mMVvhgeIuCXnXeXXlz4XrpTRDKaPcZnZys7xhiBPmJF01ZaNaBkzBsmu37LHqxphjuKbV
	fFve2mw51IERMDasxQh/lI8JSXUTiAY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BA23B43FAD
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 19:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05CE1F00A17
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 19:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793387018;
	bh=G1TbzJA7tvuemQF7QxmCHwR5V4XpxTBrHnE5qnrFYIo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WwErtu2mJUucXoHRgjbVcPpda3enOg9yPnS9Q7fNDhjVMRQ3JJ6ByioycsnzZErGw
	 UnV/aw5HdEduCnvv+aqc5YoboEczNs/jPnfOKzfPtnY+o3pDLC/PoWkPctjdLSJP67
	 +87DEgAicYRY8duhif6+kAHDf4jLVE8ls/p8OpJISj1ks0qtzglyJ6fz+vCVTI8Tx4
	 Hh8YbfY/b20SWBQsp9iK3dXCwxd5EWV57CzL3TQIZCnK3hOHfcB72k4W6dTW6CN1yq
	 XZLJ5h2+Wv2C0XJWbej8vf7bj/KL0EbY5eFvoJG6zg7+NNTUpODa+AQRzeVK9Vp7el
	 80sia/ZnEFoxA==
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-9440304604aso111064585a.0
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:03:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxtGVXe6BeE7/FLU4wLQpCcYb0+8BBFRlJ7jUAIogjv694717Ce7aXAIk0i01dxmzSiI3Py+dkvcw==@kvack.org
X-Gm-Message-State: AFq9FYIPAe0HuftZ6TFUzpFTKloJkqNtSBWpuY8nK2tQMe+IvCXKZwef
	amDseZqef2NdmCKUlxxABIm7EeRSyFtKDfI6c0yXrKdbO3TuPN9VKB3EUmJhOmPWH0hoDRFpzn/
	FB94+431JF6jj5N0buW3wCHSofERLycI=
X-Received: by 2002:a05:620a:2628:b0:93e:6e6a:b686 with SMTP id
 af79cd13be357-944133b3558mr986791985a.29.1793387017785; Fri, 30 Oct 2026
 12:03:37 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261030095223.325309-1-jiayuan.chen@linux.dev>
 <20261030095223.325309-3-jiayuan.chen@linux.dev> <CAO9r8zMF-cj4StEz9okWGROGjBhQ1XFVW3H2nJj3b8i5Jj=zAA@mail.gmail.com>
In-Reply-To: <CAO9r8zMF-cj4StEz9okWGROGjBhQ1XFVW3H2nJj3b8i5Jj=zAA@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 31 Oct 2026 03:03:26 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y52-hyd=JrPaX-isNWNFUfX30aLCgbsiCAFjxDzhYs8Q@mail.gmail.com>
X-Gm-Features: AclHuK8xBzWeuCruc8JzhVT3vMx1OiWohzDoQWKMU_5xr1KFbFUn9P3jTc2FqrQ
Message-ID: <CAGsJ_4y52-hyd=JrPaX-isNWNFUfX30aLCgbsiCAFjxDzhYs8Q@mail.gmail.com>
Subject: Re: [PATCH mm-new v1 2/2] mm: vmscan: skip anon folios zswap would
 refuse when writeback is off
To: Yosry Ahmed <yosry@kernel.org>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>, Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 71FA7100014
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: t4e39yuqkghfzte3snw1esrmcgg59uer
X-HE-Tag: 1793387019-626517
X-HE-Meta: U2FsdGVkX1+eNT4EhbA2EN5ByEcihXOuXx0VBa8kT1TyGgH2LrkL+OaCNTMi49Lgq4qWhJQzwNVCv0hWNV7eAh46wd7pthalbJeRe8nChrFLbXci8lq8Ya0el8A9ylg8S1om/dgipGPy5BoHF9xbywPDFz905sREsfjAyJzC1JAD+odD6GCGtmTREl2a0yMZdIzOThed+fdzRVe9Z0u+iLUbFGBRz4nen7EgFOE1Yfo5uEWk2h0b9TrQZ5gTlOzK62qmDLIJFC3//waNNxyx/ac76VNv18R7kkm2pHVWJG/LWeDsH9vEEGtkZ9XjtRRCvtCFjCe0/Yq863jNgVPkydxlxTO+d1lIBA1OJO0C3q9sol/7DrZjdmyW58oTlirWgknakX1dxUxo5ZTeylROPbPIWjZok087JMwi1hV6WITyznkoWKElSr0htp84ONggC9ZV9xfCOnh7c2tiHLLgA+5fDyMXO4laEAwE9QSiwfpc1AwbkhstVw6qPkYYeLs0JHSNxR1hJl4yLoX4b9YkzlV0FUivNTACDCgZVwNSp+aJD/Jz3SbhO/IRtpn+jtbWbhsxYVmHSskNi5pEidbjVROW7zsQRkGcFhvsH2AXq/ZFZ1tgAyCT1JTvVy5gmzNiMnm553eNWxG/ZuW+2F7+LK8bDOyvLUKDUkiwgAUHUOVT2xCRrq9ChDTQClHUqhRUDwlYI51muAQjvaTU/NKJbBhRrCmSBeEcBBUkcxFbJA7mOt6QvGvQoQ+ZbEjgaiCLIASf/lvMyEaQmmk53q54ugAiZc2VWM+aGeZAOwhs8mzAB9pCkTbe//91QDq771d62/uBZ/CNwjywZQWltwfKFrQqZPVW2erdOyA5OXR70sDXQet/e86Hp8gXieUvo+IVdHl5XGhzAzuXjYrDGSY1fXo3dPOfK1Xmh3aVaRltbOzz8nUBqR38PhMtQryMAJglrS7DYAYW7V/V70CMrBk
 YR4afDja
 Id6saeOR1mKM6K1mNVyvmYbGH9Qpp4yZR4ywh0dBzPk88DXBwI4yTLQl8aowzO44rvP3WUkt9qCN+J7OMgGEyW8EZ9hk+PEWXZrT/w5lh/TZZkwgh/Ot0SgIy38Ks5HyhvtxBLEltcKuL2VweNKN+TDhhAR+FQhSOjlFogGYtiL6J58B4We2G9W+1qyI+cI24S0b1UMGgKQGqtt/mQHmMRes7LMHynL9b98Ne4tpwy8gdNZQHrf2jV+R2DCBkaydfn4aJCbh0Pc6B8426GOZxMCx5R4rZTpDsEDZ5hdrXNEqLKX5y5mHhmr5lPWrL0vp9QBilt8IViBMcV/g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 31, 2026 at 1:52=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Fri, Oct 30, 2026 at 2:53=E2=80=AFAM Jiayuan Chen <jiayuan.chen@linux.=
dev> wrote:
> >
> > A memcg with memory.zswap.writeback=3D0 can only swap into zswap. Once
> > zswap stops taking its pages, because the pool is at its limit or the
> > memcg is at memory.zswap.max, swap_writeout() has nowhere to put a
> > dirty folio and returns AOP_WRITEPAGE_ACTIVATE.
> >
> > shrink_folio_list() only learns that at the very end. Every folio it
> > picks gets a swap slot, is unmapped, fails in swap_writeout() and goes
> > back to the active list, to be aged and tried again. Each round costs
> > a slot, an rmap walk, a TLB flush and a minor fault for the owner, and
> > frees nothing. The folio also stays in the swap cache holding its slot.
> >
> > The obvious place for a zswap check is can_reclaim_anon_pages(), but
> > it cannot go there. Zero-filled folios never reach zswap:
> > swap_writeout() marks them in the swap table and returns before
> > zswap_store() is called. They need no pool space, they are common, and
> > a memcg-wide "no anon" decision would keep them in memory for as long
> > as zswap is full. With zswap full they must still be reclaimable.
>
> I really wonder if we should revisit not swapping zero-filled pages at
> all, and instead mapping them to the zero page read-only (and whatever
> the equivalent for shmem could be), because yes, the right place is
> can_reclaim_anon_pages(). I don't remember what happened to that
> proposal, Usama do you remember?

Hi Yosry,

FYI, I recalled that we discussed something similar in this
thread too:
https://lore.kernel.org/linux-mm/20241212073711.82300-1-21cnbao@gmail.com/

It would be nice to see an implementation that maps
zero-filled pages to the shared zero page.

Best,
Barry

