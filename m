Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01435CF6AB9
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 09:52:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F28786B0092; Thu,  8 Jan 2026 04:52:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED5B66B0093; Thu,  8 Jan 2026 04:52:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE20E6B0095; Thu,  8 Jan 2026 04:52:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CFBE66B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 04:52:53 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 78FAE160669
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 09:52:53 +0000 (UTC)
X-FDA: 84308332626.08.08FA40E
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf18.hostedemail.com (Postfix) with ESMTP id EA5661C000A
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 09:52:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gUjrkfjA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767865971; a=rsa-sha256;
	cv=none;
	b=j9SG3X+O3As1d+mFirMW8Vwxu+YpRAG5Dv64KrylcK7jQXMbpiP6IDM/Ef3U0XT/ztWJwb
	v0FLZcKZZ7MS7rvVNY9N2QmB95auK1vDwCDboRZuifRf0Up1AxeyYuiVNSlD1kAYML+Gjx
	8IKAj9XHzd5qKpbfFwa2NhCfr35LTvU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gUjrkfjA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767865971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EvzdJy+9zMHN27Ed9/NnkvWwqWU86nRfgPXwwBdMWUY=;
	b=RlRV/EAqy0T19fAsARJrdqkB7F6t2RNIVFmRKVnKC+hasKYU6RuEaxZxsLdk+wuOc5uA/L
	R0mUmAibuCpjkTHvrifIlWHi5PLmerK5Lij2xUYu630tkFeEGOuBKzENj8jpIY1RHNWgOy
	LJitvgyKggTAaHSkcgcdNWjkI5g17xA=
Date: Thu, 8 Jan 2026 17:52:27 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767865966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EvzdJy+9zMHN27Ed9/NnkvWwqWU86nRfgPXwwBdMWUY=;
	b=gUjrkfjAhdKKfbMv/eiJaUta2YOhQyBJ7HZUUfgaP6FBr5rYm01/XZ+qMxw4ZMlMELB2dN
	ibCm1rZ3M7V81o8nDuv4lyG91PsbFGgSzuu2WldMaCvevXx2lSVhYisgFCHJ6tiqFaXxOK
	phROM+SBVI0qFg84BcCLqHKFaox/Il4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, andreyknvl@gmail.com, 
	cl@gentwo.org, dvyukov@google.com, glider@google.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev, rientjes@google.com, 
	roman.gushchin@linux.dev, ryabinin.a.a@gmail.com, shakeel.butt@linux.dev, 
	surenb@google.com, vincenzo.frascino@arm.com, yeoreum.yun@arm.com, tytso@mit.edu, 
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH V5 8/8] mm/slab: place slabobj_ext metadata in unused
 space within s->size
Message-ID: <7uiizca4ejiqw6zegjwmou5va4kw7na7wivy4kxebrju7dsdwo@5brr7vhwf5oh>
References: <20260105080230.13171-1-harry.yoo@oracle.com>
 <20260105080230.13171-9-harry.yoo@oracle.com>
 <fgx3lapibabra4x7tewx55nuvxz235ruvm3agpprjbdcmt3rc6@h54ln5tfdssz>
 <aV9tnLlsecX8ukMv@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV9tnLlsecX8ukMv@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EA5661C000A
X-Stat-Signature: qfe1qcr7eomoo881igxg77dbc4uwsxhe
X-Rspam-User: 
X-HE-Tag: 1767865969-946128
X-HE-Meta: U2FsdGVkX1/LT534kQfLYPEwLdW+984pWXPoRY+7sU526fywXmLQe5JakyEZ+IpVfE+kWLjGzIXjdM6/l5eejF6QvNjYXg660joue8XzIGOGfEKVBfbhEwSK8R05vQKXqKdK3wsQh4Jj1OgiLICfopp1t322JS7o2XwOL8raDvRl/G0tNs6sebRAcMsZX2xk9ZUqLX//NNJh1yFfVVB39/9Chzxb6SWQgsG211WV+OZovMitzAbfRXP5xGTdfh8BoNJz7fQBywIFkldlFEfDmE5bjKI6WZ8Zd9rel3G9Fzn76xBvFwNT1spGyXKUZ9G1fGIoZCeGv7DR5R7reDcdtQofFoz+zH1boC/oxqeBTwRNGzfBHA7gGnRdLz46LEgLQp5sOUNEdP5yuGam00VaDkQ+vDiuq5LdtBKc1N1Xoyy4jnlEbPysbsGj79F4OnKNgXqPCaF3Kh9xmD1ip54fuiSxoEadFj5zZOatxtr1dcOCNcn+mctlIGvRepEMSBQfSZg00TzC72U+igafDrua7m/Q1KYIBFVPEsiQyL5/57YjVo6CvGHSR3llKLac/nCO7dZEeFO6OjSpd9y0HTUR1lBZeu+bWtNTZOIrRou9FrbWrLzJJJM8sR/phWJvwcHStIYs4KSFTW3v5HrCiRDJt+/qAzgxbWmaC7j9flj0FmGzu9bDYQ0inPzWObTMy7SjDtRHuq6nBI6e7eBErjlJX4/jy5tlxE2m4sLREKC74q3+YTcd+A+CpDZfIai7ERfMssK9yYVyU293He23UhUmKBUi80CAZHscaCp6KO6C1JEKQ8plAF7Tig7CvIyJu4Q2inIT5QOwrWZBzvk/85FNCRYTYa6fO1f0FlxruKQML+AgMg98DP5OLlv2v7+T6ZvYRcaVAHefzMI7W3qDGt3VvPmGhTiguie+/2KOD8Siz2Ry3jWeCesXM4xUnH9rAo91dIGEzIfr9MwuS/hLjGz
 ZjhzNiL3
 9JFu9Nrno90sQToADfGwOOap6z4nNCKk9RB/zm+dhsuUgW9P8YSGFARxoK94njuJZp7sue6g9c6UA4c3hCp65KY26MdgSx8eNOFLaJFQx2e2bMLVNZZpUp8nI7aLPFFRVzsmO6XlCZTc/5sHXHPXGp1jIoMHxK644SrfBAUA0DMym7wVaLF/oOYqr/e2r0B6NTkS9Ilm0LN8ndOJpVyYxfQLTWQXpX/X5g9FpdQHp6KVXRdM0O1aUy1Zt/QEQ1TIQIiWeKGgNDnXhMf1db8gBZgq/0cK54kSrQNACtDvmU2iueyflVOVGYPxl8lRh7GR9oxFyv0pSdb83A4c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 05:41:00PM +0900, Harry Yoo wrote:
> On Thu, Jan 08, 2026 at 01:52:09PM +0800, Hao Li wrote:
> > On Mon, Jan 05, 2026 at 05:02:30PM +0900, Harry Yoo wrote:
> > > When a cache has high s->align value and s->object_size is not aligned
> > > to it, each object ends up with some unused space because of alignment.
> > > If this wasted space is big enough, we can use it to store the
> > > slabobj_ext metadata instead of wasting it.
> > 
> > Hi, Harry,
> 
> Hi Hao,
> 
> > When we save obj_ext in s->size space, it seems that slab_ksize() might
> > be missing the corresponding handling.
> 
> Oops.
> 
> > It still returns s->size, which could cause callers of slab_ksize()
> > to see unexpected data (i.e. obj_ext), or even overwrite the obj_ext data.
> 
> Yes indeed.
> Great point, thanks!
> 
> I'll fix it by checking if the slab has obj_exts within the object
> layout and returning s->object_size if so.

Makes sense - I think there's one more nuance worth capturing.
slab_ksize() seems to compute the maximum safe size by applying layout
constraints from most-restrictive to least-restrictive:
redzones/poison/KASAN clamp it to object_size, tail metadata
(SLAB_TYPESAFE_BY_RCU / SLAB_STORE_USER) clamps it to inuse, and only
when nothing metadata lives does it return s->size.

With that ordering in mind, SLAB_OBJ_EXT_IN_OBJ should behave like
another "tail metadata" cap: put the check right before `return s->size`,
and if it's set, return s->inuse instead. Curious what you think.

-- 
Thanks,
Hao

> 
> -- 
> Cheers,
> Harry / Hyeonggon

