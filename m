Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFCD1C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 16:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8F5B6B0088; Mon, 14 Sep 2026 12:10:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3A6A6B008C; Mon, 14 Sep 2026 12:10:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9017C6B0092; Mon, 14 Sep 2026 12:10:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 630516B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:10:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CE66AA01C9
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:10:53 +0000 (UTC)
X-FDA: 85212856386.27.01021F9
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf03.hostedemail.com (Postfix) with ESMTP id DC34B2000F
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:10:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="BRRxpu/w";
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789402251;
	b=JUHaqvaj7TTFghooAfLEeINcSea2nze8NEH0aI9df+tkmv1NRwQAmuB7qbYLUjOQvB0Y5w
	8NhHz1evcs361+5j3J202clJSQveUxq6uIHBeX/zJsUgISiOVOpZ5FXKy8CC67lFCUNDra
	TewlL8GnHnQNIN6Y6OKZN1MU7uEtyKo=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="BRRxpu/w";
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789402251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JVDJIFTFgLvCCjRsRRk9CSdls4G/cg4o7is/ZxTdK6I=;
	b=YXdghZgSUycp3GJiFM05jC2VYsnpxCRgPCHuYPYy5JXtsCbIeoR3daKnjX59Q5FJYO2toF
	HAwYS1fxQSLPVCMJIBqW26sgxCX/PC3EMzOmr+/ogRpt7FNi+/9ZGcVOoERyCbH+8M0Mo/
	GkivIodFcS5aAr9GOo7avZPpsJuupWw=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e71cdb22bso13271445e9.2
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:10:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789402250; cv=none;
        d=google.com; s=arc-20260327;
        b=nLYfb+qAJMmKSRIsqCScI724DRj583iU1Ah5aM+kzSSb3bQs8stE4QxIDJ5oxyhKyH
         w52R7x1naNeRsvTUodw9euIyalOp3P4gT0m3+EGqme7o6MusQcZtbnedFUK84yFOe4KU
         hFOPONi5R2RKwK3XdV+qV8Yj9RWiiYgW7/LTegavwD2mvMjUWVmp3FLH0frJv8BA2ndt
         mnGZWKYaubUWxbzMBkIrgddHndGI+M0xosmMcL/1meuKa96czMILPuRYHziv53L4QA/l
         NIpBpLY41S51FgA0jZp+5ZrL9elR3YRpkXJZF1rXnz3qDcoUa9YPDYnngXurqHjtHz1Y
         PDsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JVDJIFTFgLvCCjRsRRk9CSdls4G/cg4o7is/ZxTdK6I=;
        fh=AZnbHWdryQmtvXaCR57vW2B1gkj31NhwJcy0vISc3MI=;
        b=TCl68Ri/myw2CeADFfxWdEN84HwwE7ZS6amT4TOIdIsB8HP4EFkpC1Xw5QooYvp+BN
         muqTZxE6OLvGSJvZjcV6F8cfA5zuf89EDr+5H3/UTcB8ER7P5XHkWgeWMJAHgO/HiOM+
         Cr4nqhYFwZwzDRmyLcbjArBJmiKid2TXrdwjBEnPOYrI8VhWll8JRFbAvodVNK+cVufg
         1zfRlm/gdup/kxxSfdvYBkHHdYjM+m69kwQtwNvIowzxVEaoaqUdgA0lRAd+Oa0HU/Gh
         ioeRnB9KgR5w1ZY8CRJk7EKTL3PD1BdcuBMwRbmd6t1OSShB70qsyWwHeTzLgq22ct2R
         TBjQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789402250; x=1790007050; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JVDJIFTFgLvCCjRsRRk9CSdls4G/cg4o7is/ZxTdK6I=;
        b=BRRxpu/w+HzW0XMmP6GpgRLIQ9d6YH/Bg8McKFg1xwAsyQumhHcDPdrAbolQ6J5Z5S
         37BgXjUE+NsYp8G0UKRq5YxQ4vpo8FKHItzUbQ5oB+t64oj2/Pwo/aHV+NXWECjis7uo
         4JHo4feJyTdItGsYiTWF4kRKh0Gn1NmNOC9D/ubh43Z37jgmTtgMrnUSB2vkzZKcX0UE
         zg6zGYkTsbfbh2XkjaZvcBdZc+YI5b4TqQ1TT/rywRsKR2UQpNKi9UYSkQZU16hb1aX9
         1YhU9hsJ52+UK+2viX3o1RkPl5EKSQM8h1gmShraK5UOFW5iZM48bChiwkxG0AzgFJNn
         Qn1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789402250; x=1790007050;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JVDJIFTFgLvCCjRsRRk9CSdls4G/cg4o7is/ZxTdK6I=;
        b=c7t5axoMrok58PZQYgSxbcxTs2x04jnsBc4q5F4Z7IlRfGFMOKPRzDO5S5n6TCB5C0
         xBK3UM9lhDELdIauFOn88+TKE01ehAMBbMLS/VMhvN6LhBTePE0RfEa4Tt2d0MfzGJeE
         XnEOiUj4ypWHOTs/tz7oXZUY4VQZ1WIuI6AQSgTOkgiqBucq+ht2rfEgQ3Lg07Nrbnk1
         jam/AWFL8P1gEqb45VqF2AlbounJbvdBj5pS4lpEx/0JQkTL8wywkPO69vfJO8R6S0JB
         G58VvbOj0n8WLuMGtmBhMarSNv0meSjYq1I75g355vLQxQBW8ca92WIuMCqJerDw7W66
         03Dg==
X-Forwarded-Encrypted: i=1; AKwUvBxLrazpny81C1fLWWkkTXPPkK5uFYlNsnsonYyxzSYNTCi41zB/+afEo1gNHJAZAHgD1HFnCYr/DA==@kvack.org
X-Gm-Message-State: AFuF++ngEKPOmDPZqvhSTfCiH+qNbDw8O/852CegFP8Bnx6rSXYUZuaa
	PVUFOgfVpvU/0r3l48+A54E0eETfB7pJfq2okUxbDJ1VxCov0kYny7rxdYFmPQGR5N6VrBFg6r/
	EvauARU+1rWtjgkqWNhHgoWay0TvE9Vs=
X-Gm-Gg: AYBFou3j37/hGXWKvGDcQxdVw/CvSdcmf0+dm735INTobTuFfy+Vts2JTn5aMiz62rL
	67MvhQjHy2o0o1GrOsVuoHFpDbu2b43JHwqL6yHndfofrK2BaaGJNEOXzsjPD7SudabUkDObppq
	QFfm6Fi/WdLbHG6q0L2v5XC2a2+CqQTutxTD6rFF6OzK0NjkEVXfhtBMZmZU33emEtkYr90tgAY
	c6qOWKY/Jm04aUdQyanm3fhOQuiLsBk3OkXIWkq/Sdmy44LiszVtQjBfhEy4JjcVB9dAg9yM9oa
	7LNaxuJSxn4nWC4ryfEgcju643YgEWxV8/iavWxZeMXZYGhVUN2xZtPMmhI61g4A5t+I3oCFOgk
	aOJgbCpUlrXsMlIrOs5Ga4Q==
X-Received: by 2002:a05:600c:37cd:b0:49c:fa20:cc08 with SMTP id
 5b1f17b1804b1-49e7a67cdcfmr47809235e9.31.1789402250147; Mon, 14 Sep 2026
 09:10:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
 <aqBT_35E-eSoN_zj@cmpxchg.org> <CAKEwX=N4aaq_oD2agTUNrUNXhaYGeQ9vxu+dywFvEFgWFi4uQg@mail.gmail.com>
 <CAMgjq7AfNBUpMamcv29JFzpX=7ApNYVLtPjWT4Sm8cXjSLYL9g@mail.gmail.com>
In-Reply-To: <CAMgjq7AfNBUpMamcv29JFzpX=7ApNYVLtPjWT4Sm8cXjSLYL9g@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 14 Sep 2026 09:10:38 -0700
X-Gm-Features: AcwNN1UhGBQM2G8axnieeGvN4-f-Y8NhL0mjIZlCfhdtBbLfiYUWAueMcYwHRoQ
Message-ID: <CAKEwX=NZo8DNg70uhhd6CM0BfHH1RAkfuSQwVeTg+77a5-r5DA@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Kairui Song <ryncsn@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DC34B2000F
X-Stat-Signature: tc71z8pwgc79esa74hjdtewcuoj7t3kk
X-HE-Tag: 1789402251-800543
X-HE-Meta: U2FsdGVkX1//ZDOVn+9ENfMynI35GWqCAoKsdEWryhTRXZYVdXPz6gcg/m7/A6yD1FOeeaM8OOPpMQSLBzwKR+IXMYUZnCj7mJVGHCLGb6nOdgtEhVlT4X3idTt3gjEdoWNm4g3GUSCKz/7vDOSBwzyqJ/9ChNgUv3Ts+9tTP6kuaQZpIJTcXuiAf7CsBwyGZQbZbOCn0mvOpozOus8PR5VFW5VCcylE/QudZOyHRUiylrmEts3gQLYcA/kMyJ7Nt3IhnZK0fmdLfAtSURDQd2KdbTD8mmDHJzKB9uKGBRA2ymq+Am9joTeaWrk44bnd1uP7PqMh81KzWLm6aPmRvF5mgfmjT4Q/uBHlSRXUZGQKNSPfCm6zejbihd8K4BNGgtQt4MH9rFknfOWWGmdub3RCg3DwTifvVse6J93KV/3woNpT9l+m6Zt3FBqOtvAfe2HP0qZgxWYcERhhNs9sNve3Kh3+wyA6t2TzAM2lCOkegU5JO1lLiH2fRG/F5B7W2TNJVL11toms4bm6WagNJjo5d1jD2dCVb4HfHzjesOSVQ5cRZ/mpA696gT4fe+I7B6L5J0ZvFoIRTWlWOeUbLIH3TSSluaS1NOumlerWwtJxiT6op5VVPoz79BjaXE221j1uw273Wa/GQ/xOczrnnoSEhbzrFhjs+WV4f8854P0LOPCZweWv8rnVFa8VmB0FF/i5w17dGZBgeuyYJPyB6IeSdAPy3HSzSNkdmQoHPqfAmfx55eAI3qWs8kGAtZG09eB2cgEJxVFCWAUi94aE0zpV9i40TAWHuC5yKHffMlu11YzJ976S32El57u2mqysRncV+TBjrpjPSEfdw+rVA+jcEKVhrKOZwtZK3R7MEB2KfbE+hamZu2QW7HDE/dNiwXGwR5a08SGgoFOf9XjwTjkLjhUKdpFIp5WEB1ITSvZ5LI3dF/23bTs5ki8RQ4TvTEr4MyqMDB/rZb5EU2z
 WRtsIzgX
 q1gCTm4yylfCG/cM/1YsPV3YrzNlkfdKc5TP+yUvIDqLkT3nPwP9xJPuhGa87TCVrm+j1QnCyT7Llu5xvUNnhj1qG54dTio7Ct0dN9w/xuP73Z6mf1C9WWZz69Vkrb8jImjCzVso4rUSTkMqfMb5s4UG6GReUH5YOGA9NUD25roWHzzgBLy5IXcVbaPnGWBWpXg+0auVYJYNE/Q27EM8CWvXWsgs2oupsccNhJH4Y2FjoDE9R/3zscVVSRkl1njbSn/9X1gLjEbnOxG8WhJyMwgrvActlIRJaMv0XslOXyJOXMs4F79agoboK15OduE1Da6T6q9ENxn11VSTx9Kr9zcjqpp0LamE4VJoeKhzaTVhMircOdw5eUPfzx9wfrZMuYlCqmRV62AAkQQvbzZcmzX2vrYLH9TBWF7TPKrscHALbJpFKCjdiQJpJvcFSgnNxrGcO5dWmIlxGc3DtaaGpJ57oAi0D5N71+Z0fwRFYM3baoY1dfddBUr+mP8V7AdPJrM2W71N4hlyqlga9jN87xDzchLO+0PYOn6wgnW01Q3TntNQV8dE5SnuCtLZhqQbWj8ow/bIz5H7stegpGiXWJqnxL6Q/C6HyD7kX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 12, 2026 at 2:01=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Thu, Sep 10, 2026 at 12:42=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wr=
ote:
> >
> > On Tue, Sep 8, 2026 at 11:30=E2=80=AFAM Johannes Weiner <hannes@cmpxchg=
.org> wrote:
> > >
> > > On Mon, Sep 07, 2026 at 01:51:31PM +0800, Kairui Song wrote:
> > > > Where I've ended up is that unbounded growth is a real concern. On =
a
> > > > host with no memcg limit (root cgroup, and most desktop and embedde=
d
> > > > setups), an unlimited pool means usage can keep growing, with no
> > > > admin visible ceiling at all. I'm not attached to xswap's percent o=
f RAM
> > > > knob specifically, but I do think some kind of bound makes sense.
> > >
> > > Swap space is just process virtual address space, no?
> > >
> > > Swap entries already have one or more page table entries pointing to
> > > them, which in turn are managed by trees of vm_area_structs. That
> > > means rlimits apply, overcommit protection applies, and OOM killer
> > > attribution works as well (oom_badness()).
> >
> > I tested this theory. I spinned up a process, and let it spam 0-filled
> > memory + swap these pages out continually.
> >
> > As you predicted, oom-killer picked it up eventually. The host was
> > (and is) intact otherwise :)
>
> Good to know the kill path works. But I think the accounting side cuts th=
e
> other way? Won't that conversely underestimate the host's ability to
> handle memory alloc? Not to mention a lot of application are
> swap  space aware, some built in logics like e.g. with vm_enough_memory:
>
> On a 1G machine with vswap enabled:
> [    0.241906] vswap: created virtual swap device (2199023255040 pages)
>
> a 2G sparse anonymous allocation fails:
> [   46.044002] __vm_enough_memory: pid: 1129, comm: search_agent,
> bytes: 2147483648 not enough memory for the allocation.
>
> The default "Heuristic overcommit handling" policy is meant to handle
> seriously wild allocation (as documented, and it's named as
> OVERCOMMIT_GUESS).
> totalram_pages() + total_swap_pages
>
> Is the limit, the heuristic exists only to make "a seriously wild
> allocation fail" (as documented). But on a vswap-only machine,
> reasonable allocations fail. Common swap devices, zram, or xswap don't
> have this problem. One could argue that the size there is just an
> optimistic guess, the compression ratio is not controllable. But that
> heuristic is a guess by design, and a plausible number serves it fine.
> "Unlimited" seems break that.

Oh yeah that needs fixing - thanks for digging that one out!

I'm not sure the answer is keeping "totalram_pages() +
total_swap_pages" though. That makes some amount of sense when the
backend is disk swap - 1 swap slot =3D=3D 1 page in memory, so it
represents a concrete amount. With compression swap backend in the
picture it's very murky.

I think what Johannes proposed makes a lot of sense. Maybe also
keeping physical swap pages in:

pages =3D totalram_pages() + total_swap_pages
if (vswap_is_enabled() && zswap_is_enabled())
   pages +=3D 2 * totalram_pages();

i.e just RAM x 3 + physical swap pages. I think this is a
"good-enough" gate. If users truly believe their memory is more
compressible than that (and for some reason they really need big
allocations like this), yes I think they should with the overcommit
mode :)

I'll include this heuristics in v5.

