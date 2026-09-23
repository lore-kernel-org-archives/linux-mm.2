Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B495C982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 06:11:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 804536B0088; Wed, 23 Sep 2026 02:11:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B4796B008A; Wed, 23 Sep 2026 02:11:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67C306B008C; Wed, 23 Sep 2026 02:11:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 365266B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:11:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 62719C06AF
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:11:10 +0000 (UTC)
X-FDA: 85244004300.13.5896BE5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6E37040004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:11:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YsC81ZtB;
	spf=pass (imf27.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790143868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=36DkvQ40d2yR8/sYsHjVsChpTAqtkzflfa13QYZVKCI=;
	b=MsvdmcAyf1HGSsfcNnh4VNfLF+yjbmtCib+gIUAFH3RAPohjNeW6d3BKspEa19o82R0Grd
	EksEhv6wqgRIG2hVKz7PMRfGuDnf1eUZKOIJw+Byo8UBCRGk1ve/2cIic/eZNGkTZtz7DB
	KSIRBAZZ75g/6EumJgiCWHj16Cppwkw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YsC81ZtB;
	spf=pass (imf27.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790143868;
	b=8LOjC/0mQ26KquOLVc0SJIkXLmj7saTemouCk9+U0L1KvSK16W8cJHXQ0Ai7fAi5xQxvuq
	ZNyX4pvv5pMBvrFpTZQNA+VlE8Eh+lsT/7ewa5Ab1Yx2FMhb0vaG27sTC+4Rjx0tqG+MaB
	RmAt3uBWnEh4wv12ONRzlg9jSjzq3sI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A350F44841
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7623B1F008BC
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143867;
	bh=36DkvQ40d2yR8/sYsHjVsChpTAqtkzflfa13QYZVKCI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YsC81ZtB6p7Ye8J46St0nIWpDIGBXr6BqfcMKpWBw7i7WWStGXBNu4rTz+xt2hrr/
	 DIAGBS33T1UQMR78d9BXCabEGL/VmdMdKbKAmx276njXWB+srosYnd3yS2QLyNets9
	 jqiTOmvWxS3e3PzL7oa5QfPoLa012fZUlplwW2/6VE+kD8jMTNMyQyH5julGBbVHUa
	 j09h5z94LvTKm9AAQO/XfK5gEiSXJ7nK3KQkEv1kDrtIvkoRnwmRyUzFEKkqMGKRfG
	 nP8IE5JX4twuozutakMC9Kj+bBcZZNkEA21DOYZEpPCf56PaVqtjUeIFIXOE5kOnqv
	 s6fsaaWCsL49g==
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e4ab20f4bso633980d50.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:11:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzqmI5xWFrHKF5Acm2MQKFWG9ovbALyvtdSTx7qEBvVeXdNZG7aP9M1uULOEcBA5BxKRhfQq35HAQ==@kvack.org
X-Gm-Message-State: AFuF++nQF6iO18DvklWLienxH2k+SYtytYKQ+hR+MPQvgUsU1H3gxvyS
	WtCSs1TwdSivb3F87K0mUw7C69g9veqcrz/Z0vdwaIec1jI2d8M+nkOzy/+uLeD5IR0XoXJexSD
	zAZojNJifoY2l1zXxCW1EkId+lvg3g3PYOmaLAeXUxg==
X-Received: by 2002:a05:690e:806:20b0:671:4a50:cac8 with SMTP id
 956f58d0204a3-672d57377eamr504474d50.32.1790143866547; Tue, 22 Sep 2026
 23:11:06 -0700 (PDT)
MIME-Version: 1.0
References: <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F> <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
 <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
 <a75b2eac4297ca6b238dde6f9246d2c1807b935f.camel@surriel.com>
 <CACePvbW_-6M63_a7Cp+09dTmpHeMEdj9VDQZf8g8qoYKQD=wvw@mail.gmail.com> <arKiK06mfWTw9I9a@cmpxchg.org>
In-Reply-To: <arKiK06mfWTw9I9a@cmpxchg.org>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 22 Sep 2026 20:10:54 -1000
X-Gmail-Original-Message-ID: <CACePvbWaNGKSZHdWtUw6JvaydvPqKmcUR52j+7CXt4_9w4uYuw@mail.gmail.com>
X-Gm-Features: AcwNN1V7JRD8IWTWDQf-4vF0gQsA2D-aYRiLEM1ny74LPtNp-fFSHWF5S-AZcVU
Message-ID: <CACePvbWaNGKSZHdWtUw6JvaydvPqKmcUR52j+7CXt4_9w4uYuw@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>, 
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6E37040004
X-Rspam-User: 
X-Stat-Signature: dt84ki4yt3hwkb97xwb8sc7putx9ftan
X-HE-Tag: 1790143868-537793
X-HE-Meta: U2FsdGVkX18Bozd27zLchzd+k9XsMC3RemJm4aAzVaujjXOaOaLtPkMWefeAMC0yIfImqYniAMe/fgUb/udez+6wTS+y0keZUYXf9Wm72H0FJaTjtvMQagnJSLyni2MXW9ie1gAghAWe0uNeRijx5xM7/IxB1YHUeeh/rddQF06aojAp4fHvr5jo7wAeBmvDkt50v7p7hdK8pQfMykbWMXBYVzLq3yi/xKj0j+zjZwNrTdav7BUhApADTGQPdCPDdXfPGOaZUwzZ/orADi+fUwZ0W5cLrsiB9PqtG+pQSUb2UfcZcfe3NAkLzNRY1WQfIKxeEHr1Hsw2iBp7PCEDGNNo+KGXAf/KH/5+TDI+x5mZMZVHi4gbv//FlLRUfn4vPPlIRCkfjLMjn3uHdOBh0L86rf4yq4STg85u1iFoZsMAI8TtPtcBRtH93r3uHsNKWftuhYXtBXo+B4X90AlgrUgemaF3uoB6szpXoKB/+I0MqXmJAcDuxOt2CoFeHEtUb9xQalp0fBz7zh4/fuo07QuxlRITXKbAG5Xf3Gch2C6wGDKXEz5OwqOlVoTGmFDoeP3zn3yGffMx3Gjc8+zdOAhq+9JDoRpghrToqJ7+Ft8kbRO57ymT5qxQU7aCtRgcRSJIklIQjjgq53w7A9hcDwaK7Devi+nGXFXBID4GRohzlEh9Gv8k18J+lPcIoZUvicGbQwKrPtJ8lGrzE+DKEhZCpw81JtKMAgedNlsKY5tpd+j0lgzjyhRXI+IyvNzL3G7NjfH28arHQMBHMRrLSAFUNyWtbQ1NIpfXbyVew2ndevs3xMEwg4rEN/fXOtzzk/nQO0r3+Y5JvsjTf6t/ZzrX8gUTTVuKNzwYWLZgoe8DLTZ5UXa1q/G1zM6OeDhDRTrPHwgNQ2MR5bYGT4417B5y85uW8H5JQ5NkE5qnMYbE2gDKCa9/c+fkHUu6A0TvSlLIb2yfO0TRqb2Neiz
 UQ+pcprf
 iY4TZR2dFTtqpjaNxUhIWh7YPs5Jj4f5DCdNNrW5zJphL6Svk2omU/LCqnxhLr0oG29s3Aod0EjLIMnihDxzor2uazmCNdWmWqf8u7Re4fXMTfKipg6/BiG39PWDlYOA9yT7B9W8hN73vVYNYgJqGN/jtXQhfU26Y0cbg9F57PRyQqaZcAgal5Iq2sH4HMwLdE49Ba1lu7lE+wZ1k6ZYE8VbaBHeJuZwPUPt8oL8Dg18tkTHj1bsej6XB5lphQ6CIzf35n2s/o+bnqW+MF2brgIN359xks+msAq9JAwK9CsxQUwNu40Bhb4I0tOip4pv2JSX0QmSxfoYXMt1ixy9Z88B3fFTagrdujR6tC8mtqrAZX0jovHJm5UavJDxzRfpdGWOF/6QvsY5TzsxDRSq3mbnlrKJ5WbDZQh3QoghtuR4k3QwhlBbk/GdUpeh/3piy0NxXJvimdWm3Bae1TMdmTADOog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 5:43=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Tue, Sep 22, 2026 at 05:23:31AM -1000, Chris Li wrote:
> > In my experiment, 100% is already way above that bound, which is why
> > I'm curious about your data point. How do you run and test your system
> > at 100%? Please correct me if I am wrong, but it looks like you
> > haven't.
>
> You're conflating machine size with workingset residency.
>
> Rik showed an example where the compressed set was twice as large as
> the anon set, and it worked fine. And why is that surprising?

Where did I say surprised? I am just saying that is not the metric I
am looking for.

> We know many applications have long tails of cold pages. Idle tmpfs
> files and shmem segments. Things that get rarely used. memcache style
> workloads have a small, hot index and a huge data segment with poor
> access locality. Even if large parts of it are in compressed space
> that's better than storage fetches.

So what is the max (%) in your fleet based on my metric definition?
>
> Your "this will thrash after 7-10%" is an average based on common
> workingsets that are actually hot. It doesn't mean there aren't cases
> that benefit from much higher overcommit.

That is what I have been repeatedly asking for regarding your
deployment setup. What is the amount of memory swapped out to zswap
relative to the total system RAM? This should be a simple query on
your end. Nobody has been able to provide a data point where that
percentage reaches 100.

> Why even get into this? Why even try to find some universal limit on
> something that just costs memory anyway, when memory containment is
> already a solved problem?

Because I suspect that if that number goes above 100 the machine is
unusable. If this statement is true, then nobody would want to zswap
100% of the RAM. I don't need to preserve that much a space. Asking
for too large a value is ridiculous.

Chris

