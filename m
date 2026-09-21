Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96DC5C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 18:56:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B81686B00B2; Mon, 21 Sep 2026 14:56:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B58F96B00B3; Mon, 21 Sep 2026 14:56:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6ED16B00C8; Mon, 21 Sep 2026 14:56:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 769D66B00B2
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:56:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D26B94029A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 18:56:05 +0000 (UTC)
X-FDA: 85238674290.05.F1CC5E5
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf23.hostedemail.com (Postfix) with ESMTP id E70E5140007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 18:56:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YPcJJuLW;
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790016963;
	b=NvCGFyHLQj85VjlGV45u44/qXwjRqx/RRkwNa7UEVgu04rqNk+NOkxwFwGRnbaf2RI0eEF
	sqa4pma1h31XmIgp+aN2zhjt8c1ZepOggxOCH/2HKlLrZhYfTqEE4pMUVu4uYinBRlGGvO
	37DK+rVmuBG+j6qG4elbQZ0598P9p1w=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YPcJJuLW;
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790016963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BfFXpLin8UbdB73DGs4mouTnFh5xNjHoAQbr3ky7Ets=;
	b=K6mCgxioqMNRTx7Y4w1qHHEUjn2gbpEU6ovsRJCV+dCMF/vtiQZOLkyjEgT/LZgg2WpU4M
	ZipKy1YBqLTlSdfdB1PPDAoy+RfdJHvkDJUUIJwgGix7ro3+ssXkxkW7cRF17j+yzWg/Ei
	4BR+iDcHwDhcRqv8E1LroUe1y3QD/Ek=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485933b2522so2289345f8f.0
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:56:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790016962; cv=none;
        d=google.com; s=arc-20260327;
        b=qRfkFcEUtTApw7YCwhvBWUfHqIvKG1uNMUYKG0YAJGLPuqCxqp0+eHcdp7pdKx2oJu
         4qje7TQMlmR1l9o2zI9tvZQCbcj1z7lfMFEqYJuDzp7up7c10eaYbjTbXsymM8lIkB1C
         xhTtZedEzb5uI6lRtVbXhgneqKKWcwUsdUgcIS8YoztfNjI26qFIga+JJGLp80rzH9CY
         2yjfn2/3bbNn00T00CgqqwHAAW4Lay8BdwLYpENbNooVpnryPGqlq5oovMLL1I2POACT
         EU8lPSHK1d6lqH3VRIdgLoKWKkYwVAnSfDHvMvGcJ3JNwd8rzcTSsRmemEmbMYkN+YhV
         7sPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BfFXpLin8UbdB73DGs4mouTnFh5xNjHoAQbr3ky7Ets=;
        fh=tUzGzXf6AZWbHJ15oDUvYGf8go+bLB9n2Xo3DTYqfRM=;
        b=O1kDyp59fLrzt4zv5D+gEzeDUDQxL17BgMWl7J20zEJ7cWjHYVX3iBfEmLFDnoIeGC
         j5IuMeSKyfBrVMheZDv5ZH5bHNE/zmRloj5jtfSRZqfu9McfIkyCN41LU3jyFAdnmwDq
         2XxQjzWJrbr4mC1foTK0IXATphYcLPP4H/x5wzDUOUEtkF3b3t1Vtn/PsB4lhB/7Azj6
         wQuJzbbk4xxZ6qlGD51LhgbAbYLOqEdQA6vnCmJm2PhwfBW5mGbFRS/+s2d+SgncA21+
         yyD/8vj4LkxsSk3Q8mwlTuN3OTj+K4PHzBwwTT2ViEBnVOppdte/730dHLGsIFdjcB4y
         63ug==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790016962; x=1790621762; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BfFXpLin8UbdB73DGs4mouTnFh5xNjHoAQbr3ky7Ets=;
        b=YPcJJuLWq5JugXtzwzYject4GvKKuvBspY/vbbyJIcIPGY0uqJXFYZeZSpp3yole1F
         zY1c/ExAcOf9iQMoBUjlKM22anmH4YkIY8j+/xjps2uXskIc/4WtejWp0gxzgw+P9bEv
         aNBE9DC3I0Khbdh88SS7+VwTuOrZxo8eSeA9oF60DJVutHl4USGMFffW0bczqMv0aheO
         72sxbPD7Lx2KdaJCxvGrwuxv2YxB/r2mJkUp+JO/+ueFNDfSndsm2okD502v9Y2ONa0K
         QbibOICFojeay2/9lGBw6Qe1QsQNVG2mtbvPFKtGxckqCjX613CxJ6LUbBInQIXWfywm
         PCHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790016962; x=1790621762;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BfFXpLin8UbdB73DGs4mouTnFh5xNjHoAQbr3ky7Ets=;
        b=H4MIGAm7z70AbpTJ7mIZgMsFRKAIFV0dtlFq2nuakM11u+/wBONXQAsQ2OuGgk5pQP
         fHKQXVZw/pWHSLMBngZa0tTV4/YtiViRIFRFnefx0IeSzxZnMEbXpfJSj4i1TXapEcc5
         CiOR3jgbJ6+cvzuW7xK1RRShA6aLHE5GZEaFxihL8qADk5+s1jjRvVlHljd9vXB/CELG
         TbpF4LnvA3AR7jEWKpfu3uhmQU2orzs74DpZ/D99GckeHhaYgbLFT8IM+HpyT+BYpZAX
         MsMAbVuGRb1IE0l4YgTzvBw3jvFTsVJgAga2UzzHz1N/nF+FRqimbqgvJQg4+LSzb4y6
         7VfA==
X-Forwarded-Encrypted: i=1; AKwUvBxsiDwsdKCI0Fk5V2NXQ3tVnULuvPjWomaVso5yWqAVi+G3rT2QQ5RRdYqAWMMbf80hc1wUIES9kA==@kvack.org
X-Gm-Message-State: AFuF++l4E+AOcYxjVYXqkhqRC9BYJriPhgqOEpEgiti3xLZKwnNAEx09
	Kc3RUKR/qfqumJm832JtpcWJB6fQm6B8xKDkzNOkdQEfYI/x8Ko3nNgiWv/7q6gYU9kSV5qDgjw
	uiInjManoDWHzdb7ISF+5Iy9Tng8iHfU=
X-Gm-Gg: AYBFou07M262xPqOaMLpUJyIbV0DVsLsIt9y8OGnixpLde7KY0G4potunRhyEulLrqv
	54OYqYyvoctuR2n2/BHTBMFRlpA7enKeTJAd87cX6NMnNzEQYtmLnOlCR6yJM59p6c9h5YJLFdS
	OroxCnKe5hlzWlyWqRWemWKgJ5pndlRKUiDgXknv4G+FoynZrJofOxGVMSTdtELg91+/brTofZ3
	emF5OMlyZSKC6VPGr8+Abt+JOmhYN5DB5ezDeNtRYaONpitcNY3y5xtA5WcjXFMBslpzJOaBG6H
	fxzRagUzFeGOZQc/ATOd2wsahgs3KOCeHQIA/QUvqp94ZZnGWP0xhGfn50zgomr4cQyJf5PhuAN
	TTfxjmjo2OPQ=
X-Received: by 2002:a05:6000:26c6:b0:487:fa6:d7e5 with SMTP id
 ffacd0b85a97d-4871e386ffdmr22164283f8f.25.1790016962241; Mon, 21 Sep 2026
 11:56:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org> <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
In-Reply-To: <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 21 Sep 2026 11:55:50 -0700
X-Gm-Features: AcwNN1X9C9t6jZ1elLcVhCMK8X-LC57IMfgOb3DvTZPE3O0yZGqwzYORodlnY9A
Message-ID: <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
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
X-Rspamd-Queue-Id: E70E5140007
X-Stat-Signature: fj59yn15aegjz7ffyob45huwqmbwjj8b
X-HE-Tag: 1790016963-324905
X-HE-Meta: U2FsdGVkX1/JB6sJFT5u4Zs6mZyufAZMGXFns8ie2lRZdGQCtWM2xW5luKPjxw7shDuQdYW7K4RbNhvoAoRNIc3I6Cs3edh7z7kMiZ/cR2i0C1gly7eoSudXvJEoKI8CAk6elAA94paEBuVQfceIsI7MAVcKpenrBlLDtRHFcEpdaTfG0Y2SOsvZaxuLWvxl77Fx/IpjA08LnvL0KBG6lRtSfdsdn0+6NnAud1ySM7Ko8nSv8imCUrUXvCYiQdak9iXcapjraFucWjUNDD3oMICWgT2ZcQ+5LgIbGx+75Q8g18XxbO5IB7SFePCTd/lDfaL5ID9Ie4PVNm4gAj28QzJ0CXvTI3xpKAR9qHePLQJSTP3nTA/zoMaYg9OomeT5MIAIxStSCYjdwZp76LQjoHtE842gF+2HacQvqzI6BpXuknKzWy2DTesBwpQ0Gk3OA0S+ZJJveESsLqqskL86HrO1HYdU9ObPVADMpFS40Va8SO1HuyezTrCA38Y0OTiovIG5za/tIQUR6Kh2TOQKv3IcJKU4gEau2DK/iL3qdjVcRKVxH9w0KkqOTUhfMewsmUdL9vB5kv/xlWdffkOkmXqy4Tyk/meCJ4Uf1q//0smJkC+YgyqxBOmtuzVMCbXMn8REZ6dBYz3/eYFszmGMPnBqb+TSZAyzy25H2YtxBCDS+c322e7iNALkEoDRYhv8VkWCvnDTHD6+ePixmijqsFwJgVoUgC/zcEoZSWqTTiKJpBmY7Vzx4ffqrE6GN4CdifGYDm2mBWPI+47pxWATyrj6CBwXvmor9XsLndmGhkYikWV4XRf9z7SpafhDuT3yMWrfip6orM9gZpSwg8MAVffby+OhHd2bHK6AG8m/Q3E1ONUqNMta/n1/hKu4/2aKeBIAS1F7SzTzfposDJZoOqD4vUUD2Ydt7FRARmxjVMhtw8B5zQo2t+jiCDW237e29XZRsgX4JG4cTilk3bH
 OcUF6fgO
 BtY6n6/N6QCfFfy6cgTA7/Hx9V5i+/pPReL6QcaxC5C/iQj/sVb4bxFIs89nGV5EUgusj0AUSlc6SAnZGgAPK7UWRMm1abSBbROLQUOqt48kSMKIqf4KaDHdqS6DnDxWvXp0cSjA7D2IfjaAxP2zXh2jr3Il6RtT3+8Mn9DCpsJyMKWyANIu+cn8ZEP6QUniSMQn7ePNSAq3zPJO+TkAWRNYxqg618KLi6NgSbpvOFTkwg5wYE8vhzJcI+MIjOACI1xndwGNJ4k+Zg4NL44h5ND59+hlt8w1tt3YZviYDczdDbXM3qzIHXO4sXnKlw4xExzmTkUPw8eyY4OPJJkCthboEEramixFt0PKD47JZP9ghmDHiTualb3k+E6H2QCUHzux2H0hM8ES5zGA5z7tnwS9+frPtbQzIxCyOcAV8WPwC7GYpCfjn0fkMnaXIAZGj/9HnE99ZM5Qv+f0oFwKR4dD0Y/rQMxlHFw60SIgcsUz+qSIEFq/VEhNSd/kpuPnRKQgnfI8pxWigEjxmND7KWgOArXQeEpdGnzGC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 11:50=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote=
:
>
> On Mon, Sep 14, 2026 at 10:00=E2=80=AFAM Baoquan He <baoquan.he@linux.dev=
> wrote:
> >
> > >
> > > Is 9AM PDT fixed, or can it be adjusted? 9AM PDT is midnight for the
> > > UTC+8 folks.
> > >
> > > The time is still fine for me, though, I tend to stay up quite late
> > > anyway ;) so that time works fine on my end if the slot is fixed.
> > >
> > > Is there a calendar invite or something, please send me one, I'm happ=
y
> > > to do a swap sync discussion there.
> >
> > Thanks for opening this up for discussion. While the time slot is a
> > little late for me, I am not very sure if I can attend, will see.
>
> No that time slot is too late for Asia developers. I don't think we
> should use that time slot for swap alignment.
>
> We should find a time slot more friendly to Asia.

Any time slot would have that kind of problem. We're spread out across
the globe.

Let's just use a standardized time slot we have for MM alignment sessions.

