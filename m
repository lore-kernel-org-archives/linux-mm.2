Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFEF2C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 18:11:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 788B16B00C2; Mon, 21 Sep 2026 14:11:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7604E6B00C3; Mon, 21 Sep 2026 14:11:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69DEF6B00C5; Mon, 21 Sep 2026 14:11:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 444F16B00C2
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:11:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2A4AA027A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 18:10:59 +0000 (UTC)
X-FDA: 85238560638.23.3BB2F3A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id D26BD1C0006
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 18:10:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MChE/Jnx";
	spf=pass (imf18.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790014257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wuTO6WkU+BVPbOKs1CY34gM4QOwUjJ4/vjC8gwb3pGc=;
	b=e/xg2L+tYnlS5R42YBkrzc5xf/HCN0VvB5gXvNF/EcY6G2p/niMgU0XBlDKn4TrPnsoBsH
	UMuYTof6QfQbXISBUJ0SjpKBFG0qbKHfHNXwi+vBN7hTKkUQxdMKIlUiQbmhTKCP2FVcWK
	O5r8Af3viEr+0S4PL3hI0WglSOoksJE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MChE/Jnx";
	spf=pass (imf18.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790014257;
	b=bC26ujyavpB0gPIRhbU81qNK/zbXbmm6LWuu1yCMi0V5N6ixCE9qp99dhThgpkLZ72e9rP
	KDebdCv74rC25n0YjoDJxjUX+QwmBd1ui6WurIed8BGVECKUyTnypPBw07BxiEGjrJAky1
	FZDpoP4RKuiUIyFFCHYAf/TBD6VTsWA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 11704447E2
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 18:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8231F00899
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 18:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790014257;
	bh=wuTO6WkU+BVPbOKs1CY34gM4QOwUjJ4/vjC8gwb3pGc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MChE/JnxobCbG9JoZ+GkmIXjHA4YnhuT8P2bFG6NLvzH+rlgWKR4v5lUxFSSI1eyw
	 KIKZ1V+6HQoTkcnA51udmDXFM5pgv2Zet4mAoayqBbm/4/OgJjLQ0Lo5gIgr065/pl
	 JeDnNRxlkioqRmA3+ilDrwGYYfv59THw2QbzI/QSWZtxTUvgwF9rSdJeCO/FembWIz
	 nkGf80ayMvDQjrCqt0fSoXVGNKjQuVGDLbe+iDT4NC7uQwuihjgoxwxTYlrt62q0A6
	 o+iD7nfrHAMWHswGWyAibl3fhsDvGMGurAh7HYaOQaTpS4m5b3YrB7xZe6l7BsJxvY
	 Kka5XUl5HLOLQ==
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-672beabd8a8so139470d50.1
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:10:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxofIKkv4uq5Rbag5+sg8s3o011RQ7a3aaB5D9SixETZk3Qud42K3bWiz2g15MXw3x2qlcVL7pnFg==@kvack.org
X-Gm-Message-State: AFuF++ldjl6mNH8EvQiDXGiVLz+tJW28k2F601i7Co64+SEuI0/xPkZT
	Fgt1YGdUILZVD/u6yol5xbsHQyze2/gEfD++K009c449MGzll+wpulTbiA/cbJpR0Tm5pgtQOtT
	YxjxWMJj8hzksLLTZqNf8op4DD4rZMwEoC21SbmPZKA==
X-Received: by 2002:a53:acc3:0:20b0:66f:c1bc:4054 with SMTP id
 956f58d0204a3-672c2ace221mr196906d50.28.1790014255888; Mon, 21 Sep 2026
 11:10:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org> <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F> <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
 <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com> <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
In-Reply-To: <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 21 Sep 2026 08:10:44 -1000
X-Gmail-Original-Message-ID: <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
X-Gm-Features: AcwNN1Woo8T3qId4JZp_7iimts7F23BOwDAY_HBZQCCsQ8GnkQO5p6KKJ1Z6pBw
Message-ID: <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>
Cc: Gregory Price <gourry@gourry.net>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D26BD1C0006
X-Stat-Signature: hea7q65hxsqp3sk7y15k7rczn591e61q
X-Rspam-User: 
X-HE-Tag: 1790014257-550415
X-HE-Meta: U2FsdGVkX18iW1a6sxexNfCYYBUqcOKkUhtTshS2t1Jmd3qwljyMyi190xgLkFAmH9Fb0T1A5ufsuXUXzp6Kesh7FBSUSyccxNyiIGWog/TnOFHcl3o0dLLGXD4x5qXEBSd1eYO+iaJ7y2d8PY/y1W3WgK5IDsVyk4+ANfYPaBDwHjSmpglaeP3ZBpIhSZ0SW66ZX8C5A0vsRcTOsfe60oQRaCsqVVWkd6KDGbDCVKF5VxN1+PqR6F5+0hWpTu928Orf67ijzTEnsOjKDCmPdeZVV3OfdThO7Aw1Iucf7wHNExPTog4YWYNVBPhc04bNDrvlzbsP83Ixx2diM3hvvBUOhS/z7HVji8gEeMHD7lH5ypHyONctR16ir9xpqV2pcS1ro4SmrjkaUfGPY+3NWe3s/wDoTqDsXrshVFiLtEmmEaFz9oMJZobJVAsp+NlbUlnyqwEOSvILOB1Ve3bQPiFjgBcCYhbQ3HmPYEC4x55fnbpq4DCP0L3qIed+FA2/RsFMWoR70ggaO3McaMZ3sTplVGcJ338UpKcHv6pr9J0qY3e1SGjsq4j1Lh2SyHNVD99UJd8CJ1J7iNZ8Djo8bFg9/PNlaY0A2VN2ynDy3g+4+wyl1l0ZkNipFNONAXbvs9W/j2NxTbpMMwbW3s02vab3n+ZWXlomCO8nr91rKE1xgX0mZULvxrDBbl5VyEcPyw/Lo1oYvDZVSdXdKSdyn1cA+IC1FwMC4+2e4AlbfhZauc3t/y4Kkk/NubKH2Ke7E6ua8TXwzTc9aMWXSgHYY2j3IQUJkyiQ+oPuiVM1VkBwsLdlpVDWMKvFtHw60zFxW+W5Q0HWcjegBct3SaR97knPkubc2nS0LAB1Qi9veofdGTZQaedGEHCKUnrM7r4OKnt9RqftUVjylyDfYF5i0zDtjij5R5LMxBeYt9jzY6UjHlntx2EeMFkYylofd/MAXX5On4WtoTwyCHEpEcc
 jOlkWyRu
 aoK45Sn7tDkVLC1fFrIoHyOfGCZ/qd2UxZmrHceHNqF60RyzeQmTlYc16fLa+CStq4iSSAfUH5ASw9L4r3DqeiWqPyXLS/mcPet8+lwVRapZCUVtfk5Ghibuyq/nc9G845b0iu7+nXTEpkrZbpsuf9+Z9cijQl96qUQh9Kl8sjXSyeuQ6qVwdJSe59t1oCvmpsrF5CVYAx3Tx3+VFay/RdY+Y6qAxprfdE0ZzvYs3iyfUf9sw3Owh/JZMdKQNVoZYA6Fbix+LrYPOPRemF0avn0Ej7DSAb8mB6ZvyCLP+GS/XEc3SYgKHOodOUViSU9ftl78UJXyiNounnd/HJtygyb+LpV2Pjoxa55cwkOXMWve/hUghZH37HVhyc02DUFeE+YugUw4jJMjPWYX7p+cR2TFAaBZpjQzxTgAUz+8Gb/W9gXRJNxn5l1TTPaor6xAF8naUGfIVkV9h6eoixM7zbvKz3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 6:40=E2=80=AFAM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Mon, 2026-09-21 at 06:31 -1000, Chris Li wrote:
> >
> > Give me some real-world examples of people hitting this kind of
> > limit.
> > e.g. MAX(%)  > 100% and still have a usesable system. I suspect that
> > with 100% zswap usage, the system becomes unusable. Please show me a
> > real world case that proves me wrong.
> >
>
> Here's my desktop system right now. The amount
> of Zswapped is more than twice AnonPages, and
> the system stays perfectly usable.
>
> $ grep -E '(Anon|Zswap|GPU|Swap)' /proc/meminfo
> SwapCached:       252340 kB
> SwapTotal:      41523604 kB
> SwapFree:        9802088 kB
> Zswap:           8812236 kB
> Zswapped:       24927876 kB
> AnonPages:      11615760 kB
> AnonHugePages:   1402880 kB
> GPUActive:      13112428 kB
> GPUReclaim:        95980 kB
>
> This is also an example where I cannot really
> predict how much zswap space I need, because
> that depends on what AI model is loaded,
> which drives the GPUActive number, as well
> as the number of browser tabs.
>
> The system is perfectly responsive.

Great, that is getting somewhere. We are talking about actual usage. I
really appreciate that.

May I ask what the total amount of memory (RAM) in your system is?

I am not asking zswap compare to ANA memory. I want to get the % of
the total RAM.
I assume your desktop has more than 8G of RAM, right?

Chris

>
> --
> All Rights Reversed.

