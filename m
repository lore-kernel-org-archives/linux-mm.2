Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4582CC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 16:12:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 462726B00BF; Mon, 21 Sep 2026 12:12:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4131E6B00C3; Mon, 21 Sep 2026 12:12:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 302636B00C5; Mon, 21 Sep 2026 12:12:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 05A8F6B00BF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:12:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8893A140228
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:12:03 +0000 (UTC)
X-FDA: 85238260926.05.569EC9A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 87A8210000B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:12:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RgdVCj8Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790007121;
	b=Ah8NPHzbpfL9hE31lx8sGxv0/Ujr8aMlFWrvhihCzfwpamsO7GZKqKubhoqtKxhFcSDWKN
	hwthTzoesdonjNUft/18ffKUC9OB3z5XGkeLAVSYXFYXYO4MmMpxJ8nJykwCBsdmtQklcX
	2YEJAdR7/wBRa5qCwhmvmrER9J9z32c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RgdVCj8Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790007121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bp3IBrDxSg3j2mpmgJ6jbKGXoqJCAZK/XpOEiySiNrk=;
	b=TMhwyQFK6Is91gAwSTTZjJU6mA5Izw3anW/1T7W0UpC93Zp3T3LvmJI6Y2zOQXqFeVCr2v
	ewoBVppsJn0x8WArChrq/ZDPUG8uZ91vy+mgUTBKHy6cOecTx48CrMidx9vzXhFdqXzx3f
	+kQUb0o5va66SyyBazfTH+YBBClXGC0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F07D044501
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:11:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73FE1F000FF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790007119;
	bh=Bp3IBrDxSg3j2mpmgJ6jbKGXoqJCAZK/XpOEiySiNrk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=RgdVCj8Y8MEZpnY8Ynmtz5Dy2UDP7d9xzKnUit65T6xk8+YMxnlM7DSiiYU1AOpBR
	 zvWmmx/kpNPrEVC3+dkPUlbTSKUBrMFc4ZXp95XtAlJPh4JJw1/U/vjJiKx1N5IYmX
	 zlPLV+yHk5U49q14WR5l0zjfqYYW3OTrPp4bOCWFyv6a7UtVjfKNC70fnTTvYnoCq1
	 0vbvbfWNLVfS6U4cWKSFf5HBZQKiOxDqOVIvkjcb9Vui3oPDdPCOzkzSdH9s20LCGn
	 JVgWNC0h3NP3RpXUOHAGfajyXdsgDKXaOL8ztYwgAbjK8lb6758XnPMpoAtLJUp/th
	 u1ZKVFeYiv9Eg==
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-91059280d58so27663686d6.1
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:11:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzxvL43osPQ1F0h+RlSRuwY4Okv90RrNGYPRPFlx/gslEdoSXXIWW5Yh5yaqC3u9WPvsQ2YuLOMjA==@kvack.org
X-Gm-Message-State: AFuF++mfbOTRXYpqHH5a/fyLjZ1IYMuAw3NoOqqOWN24r0RVjoyEy9vn
	yju0aer7z+qaIxysqsgIj79ZNhir37fUWVonz9uSD9+puM9VUh7b6H01vI0/NZCGADMQrW7bIg8
	7cOHwBxxEElDEcUATOAgl+jK17EiW7BBheiWjEtC0vQ==
X-Received: by 2002:a05:6214:d88:b0:912:517b:7bc7 with SMTP id
 6a1803df08f44-913fc9691bamr12933946d6.38.1790007118678; Mon, 21 Sep 2026
 09:11:58 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org> <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F> <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <arEVDBlfsUYKK004@gourry-fedora-PF4VCD3F>
In-Reply-To: <arEVDBlfsUYKK004@gourry-fedora-PF4VCD3F>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 21 Sep 2026 06:11:46 -1000
X-Gmail-Original-Message-ID: <CACePvbXG5kjZmRsdd0a4HfbnNa6w5s9b_1OCySbwvY+HuCqOVg@mail.gmail.com>
X-Gm-Features: AcwNN1XW2qPwRKFrDJtBwtgJeNORhYpDb8TYjJkQ0_71FBj_TGhnmFQwOxcat7E
Message-ID: <CACePvbXG5kjZmRsdd0a4HfbnNa6w5s9b_1OCySbwvY+HuCqOVg@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
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
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 87A8210000B
X-Stat-Signature: q7aye3xrjddgrichz85wph4r5kbodeyb
X-HE-Tag: 1790007121-889117
X-HE-Meta: U2FsdGVkX1/1ByJHlzQgm+Ac/L8GTpTfqFipr8iKL97DTg/KmQmqVM84yNZ7K06fsYTzF2PO3EYWa86qOksTmW1XFQKo+5WNmJbTuDVT639Q3uwUUoP2O3bNGwGifzsd2S/qFeEgW4FtNUNcpULYhuwDHTpJjEnjAg+KfwJuVEwuPir9eprl/m1zueBr0y7hIu8Ms9RdbbmBLi551Ykbyp40VgbqXCtWqyGG9nPBLkLzv2B10boSaGpP84pgnlpCqKw+Gy2x1q2jEF5cSXEhhQmdmJTzLKOGlCgL8lDsqm+8YfHFjxbi3XEoEWn35ZR3s0PPoU0ft5sDHZKae2F9hIQ/npf2qloOc6iW6rSA2yJ+T94gtdFy4KkTVorC+GPuB6A3EjUCWcico5mAY8jLldbQP1DkANONVl39TZceAX6Ydvx7l5Va/xD4T/D0n7KBS5oDO4Or7hjTA97En0ZnI/48lvnq29Ae6Fn3Hxb2PbupqeUwwGg3GM7T1k2YRW6RkDMOr7r6/t5hwn3s4TtFDIMUw5Y3s6D+oup8MWoLeI0G6XnWaGdawc7GQm0lbX99V73jjsNu4g5UVkFRFi3Y2Dp42bJnTRBgLVBSRVA4IZ5/Gv3OFkgiA+lbpk8GeWI37EWYiVWy4oM1ItQ3r53iNUR4m9JJezHj4W8NgA32+lcJZ/uL6f18uhezM3YLz3IYJZqQJxefJC+gGwV2BhUhtioAUzdFA7hwnFWpe7AIIRdODzeKeMmX42M9wwNdhfggrPFOAlK8dKQ2xYOqyj+gnPk9w3tDNadNMTKZIqiX3kxwygp7huLNHo3Ce+h+LgArktOheNVDvFiqUxOK+ESXYQjovoDb9cyj84Ko/1dPwbXKrleO7839FZVLXzV8rIA0XsCBVNcOjZATt2FYknk4OV4W8PAa1dxv9AiyntLAuVd1zSV1U2xzHhd6+0miKBf6vkaWPGiDyDbXIRMd+cq
 phR4KFxf
 y8e1PXhShHuONGOz4tomIEI0Yno47MXcK3MiOjAksHrT8cmvCI34QdPe6GEtAGhXzVJTZfKGWk2Z8rLBaTUNSmSTQpVxjRgtcQMGc3eTe0u7FZR/U0LcJhV0BnrJd/DAX+baBqhBrnH+3F62cVl6Lr+bDPnaxYzsQ4qncyYFrOgwr+7bTw4N0cHCaQGtL/FnhoBauHwlpCAZuubCsKB1AvqyoczUSsEm/PxZQc4grz59QFiAf6WPlyxJiYHpIAg2Jx9jeb5zRkDETeaQq1SDYPc1/z43kX5W8lDt309Kzq3QGEqpL8ddqWL9hvW2G/Vx4/p8Hd3wTKvZYmP5ZYYl16lVTdB8CfogD8m1G1oRRSCepvAigUP0I7zAx7SFKJHrSlDXhBRqg6E5kUXdDqVC/nkXOWetj00vbGU/Th7U4nMVTd4T1phMqMXsXO8FKk2uqNevXku+IglWE5sIh8dGo2jRg8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 2:53=E2=80=AFAM Gregory Price <gourry@gourry.net> w=
rote:
>
> On Sun, Sep 20, 2026 at 11:43:59PM -1000, Chris Li wrote:
> > On Sat, Sep 19, 2026 at 3:53=E2=80=AFPM Gregory Price <gourry@gourry.ne=
t> wrote:
> >
> > Let's start with the real question: on your fleet what is the max % of
> > zswap memory compared to total RAM?
> >
>
> You're asking me to predict the future.  Any number I give you today
> will be wrong 3 seconds from now.

No, I am not asking you to predict the future. I am asking about your
history. What is your current trend.

You can not even provide a single historical or current data point.
Do you have historical data points to back up the claim of this max(%)
large swing?
>
> You can't know the compressibility of memory until after you compress
> it, and requiring a user to predict the future by forcing them to limit
> the total amount of workload compressibility does not scale with the
> number of workloads of variable compressibility of data.

You likely just need to pull a SQL query on your fleet to get that number.

> That should tell you that your model of reasoning about this issue is
> ill-suited to address the problem.

That is what I'm suspecting. Nobody in a sane mind would want to zswap
100% of the RAM and maintain reasonable SLO.

Chris

