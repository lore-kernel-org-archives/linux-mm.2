Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8317C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 16:16:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBDB96B0096; Mon, 21 Sep 2026 12:15:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B962D6B00C5; Mon, 21 Sep 2026 12:15:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AABE56B00C7; Mon, 21 Sep 2026 12:15:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7F2D16B0096
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:15:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A03FDC0252
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:15:58 +0000 (UTC)
X-FDA: 85238270796.12.12799DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id B3AD340009
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:15:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dufKpdJ/";
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790007356;
	b=XgMh74UZsivKPHgwuKzi4OLfLy1gZmKzxXJ6VLk2HXKA/Dx2qa2H6c8vrXiVrpAOcuaCT3
	hJLb89YaGLeRZ7CFskVEboQp9ggr4eG0DyKYKM3rcekry/mw3snUK9CJWo8r0EmVddy9et
	RWzEZ76iaMjiW3GXzT284LuxU9o+yxc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dufKpdJ/";
	spf=pass (imf07.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790007356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=25PUFMzN+ZwMXSXb/vhne9pPnPAWuE3XEt3wmLQ38d8=;
	b=gjmnY70KuyP8lWOHZEh4mOIZhakEIj4fSbD8EehOEomNdT7g72AOFA9hZfUk5jGWlKiiFH
	BZey/TCWeQKkFYreuOf+U67JD6Y28OkJmMlmps59mjpryob4ldKV54eGxKGuH5J1SlWhJ3
	hFWnMgoWBNfmfwjAFaUmW4UZI0Pk2Og=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E3254444F7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8931F00902
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790007355;
	bh=25PUFMzN+ZwMXSXb/vhne9pPnPAWuE3XEt3wmLQ38d8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=dufKpdJ/rQ4gKIXM/G3xCw5pwf4pfFQnAtEJliObPYwFM/9DjNoosgdCSY9gorEA5
	 vcItnrzgE7+MDpjixc0o3V0VONjTsm1duPbSyUiSMmwcvRQ2sOKHkYFkxC4JNkzg9r
	 Os5+enVYwDusZ1qWs+FinAKKM/oGHJr6bb5rx7e81JYBzS6pso8PEf7yQIKuSWOgpp
	 ID4JwCnlnp1wTsy6aIwqexqglsixOS6t/weUAdiKKQaqHtYT2JfDNpfQUK1SLM/ufl
	 1pG4Anz1GHBB/Q1SDidJRen5R1lMYQNjp668uwriJBYafUfoj1Q6L/t6DgHt4GJcmb
	 3hr+kWdpgcWvw==
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-90cdfcbe207so37554436d6.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:15:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwSxOWni+/Uom39vDPRHX4MsySXk+KJP0gWG6Tq0XNPQzQnbSuKSFv979qUaqAvhbSEecNtAoK0DA==@kvack.org
X-Gm-Message-State: AFuF++mW3R6dGuIzJuHShN0x/RH6PUx2NTvcGm5SzPvoCspbLJGH3ub6
	ghTpOlqxNksl9DDUjda1/1IHacmg0twgs44Z9nhGk84R23aU9EaqrUAOi84XUPR5FQ6lzzyery/
	672NnpJxnm2dJQPmglS1tOib9W4YvMcgkxuQtRm4pNQ==
X-Received: by 2002:a05:6214:5703:b0:912:590b:a49f with SMTP id
 6a1803df08f44-913fc8991c5mr12910046d6.5.1790007354933; Mon, 21 Sep 2026
 09:15:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org> <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F> <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <8aaf1f8101c9e45514af442aaf1969e3aafec4d0.camel@surriel.com>
In-Reply-To: <8aaf1f8101c9e45514af442aaf1969e3aafec4d0.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 21 Sep 2026 06:15:42 -1000
X-Gmail-Original-Message-ID: <CACePvbU0OabajPHyxnzBK_bApdg-dLt7PLwg6T_MgTK2Nk-aZQ@mail.gmail.com>
X-Gm-Features: AcwNN1X6zO48QTCAvGgUYKcds-r_VPR1bmrKxceiJWPap4v_TAW9E70LnkZ53qg
Message-ID: <CACePvbU0OabajPHyxnzBK_bApdg-dLt7PLwg6T_MgTK2Nk-aZQ@mail.gmail.com>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B3AD340009
X-Stat-Signature: aynxcwm9d3r5xdmc5rm77qiypnbheoto
X-Rspam-User: 
X-HE-Tag: 1790007356-842079
X-HE-Meta: U2FsdGVkX1+rt1VaKI5AvsSeh+qyV2xXVn4697trePKsT48G45rWxhyXUedvNtbi1XbDydMg9gMSg6nh+eo0FxpyYKixdLsthMQcyzuI2lxx9vsK3KlC6RL8SsUCkY13mWz5/rGjByBiwOryImJkUHA3NJKvVohk/oxvFWnPoo3guA514t5crBofZRsEPsR5ULXZUlpthl8pk+pJVCsjnb9lbvFWreKF16WOidbW67laDDFYlk0ijKZCKATjN+NvgvlUjABsogCb1cmEUMUPz1gv3lfErfkvDG8yHxg3HrofCbYbZsdWxMMnNbDQZIo0fIHNYpL26FbCneHx5IhRtjwWiaLZ6F9orQj/zK1DQEBjU58iSSkROPR6uaqnMGQmW8bomQvy4W+9tcrGtq3Rzy2ZqOP7JHdoWLmz3DoUjUdWvAVeJ40HgVhrBxtaHKYo8R40IfxaId8LO/Vr4f1IP36XZi63c7g71Nd3ByAPBWN6uU6kBqGv8WEkiHQ5MlbaacKljlAY3OC4FcoporOGYxCXX48SnMunIC/3B2t0p2wU68HbHZDSzPiaUhhB9Zdhi8HArXSGAxQjvKN70PBlMNG56Q739KbkuLNepEMzFGxKrndsvXbsXjQsRlTglPSa7+wJSOWmshNQ+tSdd97LBMF1RNC9P5rdvKSjPGVs/HQ/hQNb2/NaIvp6uNI50A8uw0gtGZWwHTEudP9djar0oC7iVtIwhOYz2wDFU6jxg0QOEaOzTQIvxcje2L+KE+J0iO47YZU2r04RD8oy0qSmm8L9QHSWQw0OCD5xAOy6giooS5asmyUmXGLw+6NT/FE8NxcS8DfroovzbGhu3T8fKgE1gFbC3/KBSsXVAoJeb6xbzPSWJjnoxCL/nDHiXgPVTY08ta2a07pDlIFfGLEYfdQEpbiPBpHFB9Odjobzd7HuSxZxNC7pWLamzfWCT6jx+N4HTPs92ngA/Fshc7C
 AyrUmBQp
 gCLxyhDFdJsQwMzejjL83hnOz+cRrMkphvEW9s39yyWoeIgPHozWD8OlCs7kN8aDkOB50zQEbPusqZpb+KXTLjHRNYskBQHc+L2Ms8YZUJoUNcccETrcsSaVVaMG7xH5YSUGX5OLVs1pmf7e+XOS8w1Q1Butgo7G8r1DkVUwGJNpXJJFBH8Ox5y1tuElnI1eWkq2dDTVQgkBdiaRw/n7pMl0Ixk6zvvOQ8upKa6b/KT4XvYk003CSAClHTNuuP3+B/x96BOi5chMuWHikFBdUimOlKkSD1zlBgNsZo1B4W5Js6w/nvDzpeW6IT/RGaNCGQZOGq5D7IZTW8KrpTtAN6KdI+lAbM/fbOtOYOir1Bi6qZY1rJ3wjOrhHw4LCEN7H3NbvvHx5l1qxXp2EnRRw3YxwagCek6ZuaA6qLV1s09oJnsJSkyLmsJsBUSEUR4KhDEQbY6FX+BZevD1rV8mRXQKqCK4AZJ8tR4hYLx7JiDLthT1tvVVEGI50/Xdh5PhLx9VZE/HZPo057TM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 4:07=E2=80=AFAM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Sun, 2026-09-20 at 23:43 -1000, Chris Li wrote:
> > On Sat, Sep 19, 2026 at 3:53=E2=80=AFPM Gregory Price <gourry@gourry.ne=
t>
> > wrote:
> >
> > >
> > > I want:
> >
> > >
> > >   1) zswap on machines with no swapfile
> > >
> > >   2) without being asked "how big?" - there is no number I can give
> > >      that stays correct, and
> >
> > Because you can't answer a question, we have to bend over backwards
> > for you? That does not make sense.
>
> There are millions of users for who the system
> should just work, without having to first answer
> your questions.
>
> Their use case is legitimate.

That is why I want you to provide an example where people zswap 200%
of the RAM and still get reasonale SLO.

I question how you back up your claim that this is true?


Chris

