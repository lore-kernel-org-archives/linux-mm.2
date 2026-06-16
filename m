Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0389CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 20:48:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB5B56B00A7; Tue, 16 Jun 2026 16:48:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B65466B00A9; Tue, 16 Jun 2026 16:48:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A54F86B00B2; Tue, 16 Jun 2026 16:48:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CCD76B00A7
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:48:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A53B1120248
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:10:48 +0000 (UTC)
X-FDA: 84886868976.20.9D221DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id C80D4C0014
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:10:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HdpaMAzb;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781640646;
	b=qd3H2zL6yg2IJS2xMAbORzbLyVz+Isvfh0HG9ZLrT7VD0rkAo1TRBgAhtwOmTif1n2TsAy
	A+pfEGI4xR/d85qeVGBSl9zcOhm+uaPAcpunoyzjEdf07326LG4h0/6LGCFDaD5p/H5aqW
	U9KKGwaXJQVdxkZiPoh4rD1Vt3MCl1A=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HdpaMAzb;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781640646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0uOtT8/BsfLxeL0Oxfo+dYM0SBRmE8TcCl0uwOZ9IvQ=;
	b=ezzQmty6TsmgZlg78NbXQvBvBXQ/idh+0281S5Q2s+6g+5Vla8iTOv/4JJJ4Vr/1AxRfKm
	Horgn7UJjd+NLvo1MpumPbeOjz33DdbF2ScKTCvxoLnuj8JHMxj3B25OO844EH8F7Ydc0w
	l8xwUhA3oDIcpXTR6umiOsEFnJ086QI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A8C1600AB
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A1B1F00ADF
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781640643;
	bh=0uOtT8/BsfLxeL0Oxfo+dYM0SBRmE8TcCl0uwOZ9IvQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HdpaMAzbdXv+tcQaaH/P3IZUNYftwYZtjZU5eS+rlXYbfJpg3re8v+qZjrfqodXcT
	 BZIciI6/ddDAzuTZcRJPe7LV7ZpNr4hqOaBaHpA1AGaxMILIP899PmPVXroeIwBxt7
	 uOTmQ3QHXXGprl5DaXfS1M7wO/Lhmt+VBrfgWUbyMG+mUV9oG02f9uJc2XiZwWVAH6
	 amkOKGt3oZaDb41BxPIZ84nShBcABl37t4wb8yS/2fgCkW5zgZYRCrncimOX9YbZkd
	 YjfRlZxhjyuIhzGwO0USB8WMBEez2QCRmAivONkUOKpHg02zc6CcH+8p4wswZZcbzV
	 xFL0EhgtVWHBw==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-bec449d0af2so600090566b.2
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 13:10:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8W7VPqUWszjaKvoz+9jqBrAsPLHZcVRI5zXo2gDklaw5SDqW32CMtZGLldbxgx1HIe/KfKs4HNcw==@kvack.org
X-Gm-Message-State: AOJu0YxzfFCBz2Tv0bROVSlbXCx51Rg/J9sHVokGYpndSdd8lOirU7MP
	ozqIQDNhF16y/CJ4XmgLyQ+UU3nEPy4+Tas9pp7TNwhlr0yW0aLr0mKpcpWUO7fBwPwAGWGwSMS
	zf2xn70gAKS7hOmliyMXwUK7NFptb19w=
X-Received: by 2002:a17:907:75d7:b0:bee:776f:4ed3 with SMTP id
 a640c23a62f3a-c05a6ae1d83mr47433366b.33.1781640642868; Tue, 16 Jun 2026
 13:10:42 -0700 (PDT)
MIME-Version: 1.0
References: <aictKA0XWMWbxFdN@linux.dev> <CAO9r8zPvCaCqvoUhPdAN5Oi_Sj0mK-t7DJhOOz3Xf1DT-Wrgcw@mail.gmail.com>
 <aieUQUBHI+E3uNPW@yjaykim-PowerEdge-T330> <airzE7jD9UtyR17J@google.com>
 <aisEWnb3pzmVC4dl@linux.dev> <aiu06fbV7rWqY0Bm@yjaykim-PowerEdge-T330>
 <aiw2p5ANjsQUCIHA@linux.dev> <ai5y923elCSZp41j@yjaykim-PowerEdge-T330>
 <CAO9r8zOVqbJEaBqTHw=r2bYw7Lm1tO0TU9QuG+eH1rfqcTAJJQ@mail.gmail.com>
 <ajCgzNIPLhjTRSXR@yjaykim-PowerEdge-T330> <ajC+FNpkVpI4pbBz@yjaykim-PowerEdge-T330>
 <CAO9r8zMimM8n54BL1viuX3pYzO=wzQU89LhCF1HW0bAv97ZQtg@mail.gmail.com>
 <CAKEwX=Nz9SWcEVQGQjHN8P8OANJY4BG0w+iQOzoNOWuteoVjAg@mail.gmail.com>
 <CAO9r8zOD7XaJ0Uo_LLLDTRKbeTOmAwmM3q8q6rUyH3oS-X3Csw@mail.gmail.com> <CAKEwX=N=Umi94wdKcLxEWOqUwhz6=Lj909pc1Pr_5ivVnZmdPQ@mail.gmail.com>
In-Reply-To: <CAKEwX=N=Umi94wdKcLxEWOqUwhz6=Lj909pc1Pr_5ivVnZmdPQ@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 16 Jun 2026 13:10:31 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMHGFG_jcVeDPgowaQ2RNntp3KankwzQdgrJb9PrWu8_w@mail.gmail.com>
X-Gm-Features: AVVi8CfaFdE_HVpQiLAzPF_cAqyI2J719pmKZCzdgUbBAcxL4DEQvvkOPtjV2Hw
Message-ID: <CAO9r8zMHGFG_jcVeDPgowaQ2RNntp3KankwzQdgrJb9PrWu8_w@mail.gmail.com>
Subject: Re: [swap tier discussion] Re: [PATCH v3 2/4] mm/zswap: Implement
 proactive writeback
To: Nhat Pham <nphamcs@gmail.com>
Cc: YoungJun Park <youngjun.park@lge.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Hao Jia <jiahao.kernel@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org, 
	tj@kernel.org, mkoutny@suse.com, roman.gushchin@linux.dev, 
	akpm@linux-foundation.org, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>, chrisl@kernel.org, 
	kasong@tencent.com, baoquan.he@linux.dev, joshua.hahnjy@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C80D4C0014
X-Stat-Signature: m7x8hg1yf4gq1d4zj3c6p8198umgge9u
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781640646-636119
X-HE-Meta: U2FsdGVkX18w5jO1Pi6dXa83d94qchvNbykn78GJqOZXnyNq+KLy65+4Uaz4SvspLJCFZBtJuDDkapsCZ06PCJdbW/tU4sx3Z4m76DN163cGAyeN3ls7D67zhIwzya+qAfxKuR+bxOq3tFCHr+Hrn9vgOeffOrDXfMNeMnvQXeRIHiVTiAsb3tT/omfr/qhJflem9FRIou3Xnw1fiFXUE9tRxb4bigMcG+yqjjcS+F4LxE5xqtFXKCoqGvY3NlqB9JcYJBPOHp8T8M8raHkVS4JTBxrgBPhiFm1RdUwyQy4bvBB4928ef/uraUVVFEsfHz0/FIkykLSN6s1eRXtxP2KPCmD7ZjqlMcE+FqN37xoqr9OElG6JW9P51ybu/XThIt4XssQ15nzmcJ/iR1/1Mj9fSNt7kADDGLVdo+8x3pyQsqgNXchuD1oJlUAyLxhDYvYeJGnW2GU1kJtJhBffN/LpTva2xTd1EdOZPARsZt2JfgNp3r06KR18WVrLMU5yDQTVTM6G2pwJiCKZtfzD0f19eSN7+Xtc5xXYd3IiTwOj5/vOiLlKANCpqnk9c8qA+bLcBSfY+tBWYsR+LbheAATnAtfuTjOBOozar+LHyiUzR+60WWug7MuVI8kPiEMIBxCo5YkmuD/fO1iXbZt5PAfehbIbbBoshzdsnhykU6F7+Pkv1Ioy1jyHkxOukRY+zGCwds0uInu+3qK+2bZpxFk97U0+xcbuXDlDPqVcIrV1JmJahbgm63bQ9gckUt3/j/FaP9kDAVo2rdu4BSKtHuPbnWtUGGUVKMJI+Z1HyGWCT3Lle07hf0saL+6ImSN15G5BfI3k2r0/J0z18IkEChmRJfn2dkRSwGuV/6eoj4xKOLs7YvLtvOE5o0YaNV3Ol/VqvDk6cewvDKDkpQCKiUdpqNkDBqU8J9Y6k03n4mTEO1B1Jp/Gqz1dVlrThNL1w8Z/K36UWeQZ/pvmBoY
 DhwQxSca
 P8SG2NZe5FAzGLU+BXiOiVA+na1j4pJLGDF6uE0MZZgg5zGUSewhk4VfBcSni4tijRtSKm/nE2wKR3LA2uPsZvZkheemm8DGrEEXlMXjFlI3SRMyfYw+sfXtncJ8XTzhuRLgzGZpADlYoPKYpfxhL130RabI2KCxLrjLre8zRMVOesInQRDGzizrpFFDN6hIgODPrdhSe08fD1l0SgFZ8TJ9Smm47aIwI85XLhrCjXwOANHUsre0lUJWxOwtsGowGmsP1YFgt6eCh7UgKKRiETWr6pz/1fyOKv4dRk3YUw92KMf/5Wvduh5iRGX7DYZtJR6C19Wy/B5oRd1CuAiIhfQp/66M9zC/ioqZH/Phecmk02iFzO0++z3MkYsvU8chz7ogJE2aroJbV9AI4PcfYoUXbKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 1:09=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Tue, Jun 16, 2026 at 3:54=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > On Tue, Jun 16, 2026 at 11:33=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> =
wrote:
> > >
> > > TBH, without vswap, we should not allow setting zswap as its own tier=
.
> > > It's meaningless. Maybe makes it a no-op, and warn users what they're
> > > setting is gibberish?
> >
> > Why? vswap is transparent to the user. Why can't zswap be its own tier?
>
> Without vswap, if you set zswap as its own tier, which phys swap
> device should we allocate from for the backing slot? :)

Today we just allocate a swap slot in a swapfile during reclaim,
before swapout, and zswap will just writeback to that one. I assume
the same will work with swap tiering, except that maybe the way that
swap slot will respect the allowed swap tiers?

>
> With vswap then it makes sense (and would probably be the "default"
> for zswap setup until we enable zswap writeback).

