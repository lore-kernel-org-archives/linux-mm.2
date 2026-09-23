Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DBA7C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 07:38:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A0DD6B0092; Wed, 23 Sep 2026 03:38:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 178626B0093; Wed, 23 Sep 2026 03:38:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 066696B0095; Wed, 23 Sep 2026 03:38:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D054E6B0092
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:38:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 40E01120705
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:38:04 +0000 (UTC)
X-FDA: 85244223288.30.9361001
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 745ED40006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:38:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WQoQ2QbP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790149082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t+JD/7Tcgy/5lybTqPMDYJ6GPVVkUaRj+hbtOcdXe80=;
	b=rzRShZ759RD9auPpIs8d/+oXYSfri6O9ZNSDg28jIQiPJ4SkNOABXFseoELWAVOfX0PrTP
	9R49uD0t5MCnpwkGBCgvdLuF1mQYN+MjsjrnEUhfCozIdavAk+BK+gsrHVDxr6J46Ea7MQ
	1kUez1N5k1ex7iCFbc/pSdectPCfitQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WQoQ2QbP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790149082;
	b=BYBL84ap2VAakiY4u1cnvwDZfRENZSWa7YecaSRGNOiL0lFUsLPNYKublRXlVRHyZYgybN
	NJwT9cFW9HrINyAfSLcj59Gx535/+iX2G4rUnkGkhM6ZcK4wTfYGkkmAJts3v0OE0mifM6
	VxbS0VqkSWN/bAuaYkLifGLIOY0UUlk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BE1066020F
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DB51F008A7
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790149081;
	bh=t+JD/7Tcgy/5lybTqPMDYJ6GPVVkUaRj+hbtOcdXe80=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WQoQ2QbPoqGGLb0jX9Z7J1mDTu8MsvOh/Ibh7LcqJkke//dYJpmH6tdDcgX/eFknC
	 T00oeG+czRPKBl97PDh4H8ZHcAtFbyS9yImIzOh5KLiBVQy3uapLFhxwpP5ixQGDda
	 QsqckjOhvusczlD2A6sFr+EPdkSRFVikbaw3XmcPa+JOvsrpcsUIStYIlZcsqioa77
	 V1SEXPDfsnUq1jRfkYV1GaMrc0Ncqh540aCMK+l3SP7Oi4eQWrTqXq03rnUDD02r8G
	 3VnbxAw22uDzFQ+enwXaCU3ShJJ2D8ZUu54gCQeOFQSoaCqzIVhRgzGeVx0zI0eLwh
	 f0GnC82BIPHaA==
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-85d43f9b120so8967847b3.3
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 00:38:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBw5QHmpx96wTm6QL0Sj3L3fNy0A37SM5GpAZs2ZdHwtat5ywcnXJ9D5fGzRr7PboW9wihB2NfFuXA==@kvack.org
X-Gm-Message-State: AFuF++mvaJvtrRE2ElqILDrsc4a3Coi/c98Ua+LVm2WAf5IRyRoDpzoj
	oOntlc3VLPdQIX/ouEVgYaJIFTDb75oZGnfGJWP9AZND/+ZruS/Zth9/Vjxydfk8pNnmurNzevw
	H5ae6XDVOUL+LHWQy3mFCR6HFgGD0ppujouKXt5QXsw==
X-Received: by 2002:a53:ee08:0:b0:672:bbc4:2b97 with SMTP id
 956f58d0204a3-672d57e7a7emr628072d50.11.1790149080540; Wed, 23 Sep 2026
 00:38:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org> <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F> <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
 <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
 <a75b2eac4297ca6b238dde6f9246d2c1807b935f.camel@surriel.com>
 <CACePvbW_-6M63_a7Cp+09dTmpHeMEdj9VDQZf8g8qoYKQD=wvw@mail.gmail.com> <CAKEwX=NrN7-u7gnGvWX3qfHaBQcN6FKsFP-4-k76F=sxM1LJqg@mail.gmail.com>
In-Reply-To: <CAKEwX=NrN7-u7gnGvWX3qfHaBQcN6FKsFP-4-k76F=sxM1LJqg@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 22 Sep 2026 21:37:48 -1000
X-Gmail-Original-Message-ID: <CACePvbVuFULQVvi4UOrvKaJ-5kdWWU5iJH20gH-9nZ-6ZbEqMQ@mail.gmail.com>
X-Gm-Features: AcwNN1V1Nf19r8H9CLvnn_CymxrAvElR4yk3NvHm23MKZiCoXBt2sr9xUuj-IWI
Message-ID: <CACePvbVuFULQVvi4UOrvKaJ-5kdWWU5iJH20gH-9nZ-6ZbEqMQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>
Cc: Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Baoquan He <baoquan.he@linux.dev>, 
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
X-Stat-Signature: uzqqwkh1dmb685yehqryrke9gr8x1gjp
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 745ED40006
X-HE-Tag: 1790149082-549713
X-HE-Meta: U2FsdGVkX1+HG41O3NxPmw7jfuw9eSyPB7xR7ZvBlHxtHQLH7kDTASAII3lJGIi3+6ggXRUDH15FKTWFA2QLLvk0/G3xsZwsSXV8pTxFCx3t8kas8pEUgY6R1DoinJATZ7ClOl7BuBetfdLz/GAfQW8LC45ya3RkdPcS9b4se6dx+R3PuVo4X3ucXRcKfuCuXxyJhQHsnjExH6pIDnPLZNxWlS2dZuToG2zuMHwWabZ3ywvWVXAOuRtW/ej0+bfNY/2X9sBugAf1dZOMMfTZgcVDl6TkZZK9B43bUFvZq+wYuyWdnfF4kEfrfVypeyHdShlRQ/FUhhIc85lmoFhzwX5+9h19JkHeO+Lz+lKz8SeZLEcaIdVQ0Mvfi/FdVZddNbLitS4pwAjAptqMsy+ghFCBboam3exMst7en1raudMSrz4/5x/nDYHSNX7RpGte6JSZo2NzamWzFORS+r/SGRBUCfE8UQyPPFIR1i4iOc0083yBwVjye4Oq3j2bRnhOD6js7zE4kjoAugcomuBV7n+YOIcaXn/XchAS5zynMBheYC1H/JD4tkS07MtGF/HAvRiv5lHzo6EYFrZkvgdZA1m0Lw7RD2nC5ocxiQw2LKaPB5WHxIfOrSon6eea7mdNFgFHqZSzbHb3xLGP9BA9LWRWjNgmx50FLwLDSfdYPgypNwO6XfLEFC9ACEIRtU581zohrySZMeJxokJQDTasgohhzYup2k2yy0HYxLUp679o66bD2FNL6yOw1VT5+wtA/i9+bKOrDBqYWqn2pJNUkda86fL06XV3c1G1TGAYlhr/yOa0zMBPjDgS/tLEdUpc/smW2ulQlHFECM9lDi4EvuEPN4Qs6TGRC5JsI+IXanJTxnktigvfQok12tpB7COlNYyl62GedEnxSy2ZzonkXuvPnzqp5eMsGNdr/U67h31sVmw6zUCXTHG7Utlw+jAnpOORPJbVkEeBT3t9Vwb
 6f9UlDM5
 84QgN0Czq+RTgnlXT/PsSkCMxAJki7a+9VkNGMnl2F58nf8n7KEdGj9Tlcv9bantWd6KcsMlOw8oLQX7xbknYLc69CyoRLVexeYApB8EISS32IaYWmCox8CJhl0Lu8Zmt35FkzW3+4nK6/CjwK1BWQ+PSdd6VWkeMtmev2NQCMQI0DdTeYQgiXwBRvkKdX0nQHIJQ1/N0JDbTX1QRJAIjP4+2TMdIPHeqVWGIhX1/WLEiQUJo7p3/PtEDVAJyVWkyrVF7bCPecCNkYg+DMZE/CtStPuH6xWvqUTJE5hOX8Z6FA9ljPLWN07MH3NMNTbMWXR2QePYdxBWV9SBitMxx1J2B3AfwfGGl53PCChLI6YfIr0ttrCNFiFKoxa8/jXe+bY1SI/mV7P5zzYUouWwc7ywre8Wt3slL3uXo6zPrQyBIEQBmhrMOqBzTfTLVTnq244L4hSFkjnyCGfd8tBLq1+3WERbGzyN4OfU2dmepoza/AtD4ZwDXyUj4bQY24HRhf+fF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 7:33=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Tue, Sep 22, 2026 at 8:23=E2=80=AFAM Chris Li <chrisl@kernel.org> wrot=
e:
> >
> > On Tue, Sep 22, 2026 at 4:59=E2=80=AFAM Rik van Riel <riel@surriel.com>=
 wrote:
> >
> > Yes, I can agree on what you observed. You are using anon + zswap on
> > that app alone. That is not what I originally asked.
> >
> > My original request was for the whole system: what percentage of the
> > total system RAM size has been swapped out to zswap.
> >
> > Because when you have 100% of zswap out, it will likely trigger
> > different kernel code path on allocating memory. You might suffer
> > global memory pressure you did not observe in the single app memory
> > pressure case.
>
> What does this 100% figure refer to? Pre- or post- compression size? I
> legitimately cannot tell.

The 100% I mentioned above refers to the pre-compression size. See my
previous email in this thread for details. I have been asking for a
max(%) number in your fleet for more than six emails now. My point is
that 100% is not a usable metric. I suspect your deployment doesn't
have machine zswap even close to that amount. Glad to be proven wrong
with some real data points.

>
> "Trigger different kernel code path on allocating memory" what do you
> mean by this? This reads like you're referring to post-compression
> size, where one cgroup eats up the RAM of the host, affecting other
> tenants in that host. But putting a limit on the virtual device
> capacity limits the PRE-compression footprint. It is a very
> unpredictable way to prevent the effect you're referring to above,
> because compression ratio is unpredictable ahead of time.

I mean triggering the direct reclaim path because zswap itself can't
allocate memory for the swap cache to serve the page fault.

Chris

> For post-compression size, I can make arguments on why we should not
> also gate it, but regardless we already have zswap.max and the global
> zswap pool limit.

