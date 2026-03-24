Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56439F532C0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 00:16:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C222A6B00B2; Mon, 23 Mar 2026 20:16:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF9536B00B3; Mon, 23 Mar 2026 20:16:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B369E6B00B4; Mon, 23 Mar 2026 20:16:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A358D6B00B2
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:16:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CCBB160E20
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:16:10 +0000 (UTC)
X-FDA: 84579039300.07.55807D0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 39205100003
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:16:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JIKAbPpH;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774311368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Gx75jnNvcaM6576W+SZe+dNyLWeLhW4qqMK58nkH+E=;
	b=7r/4/yZWz3mkDxJlihJf75PNFagkRQuxeVADpyuEpyaBqNaSsrO9wN3XMxAv21t74dFG3c
	Jv8jC++qHpbDl15P1ustNs44kRCcgxLNyG9L0o0FCWHSI4vRK3rhzuaXmFsXccszPIQCBr
	bURqfWB3Dz5aZewnY/ollx6jU3zVOEA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JIKAbPpH;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774311368; a=rsa-sha256;
	cv=none;
	b=y/f1fWMb5a6mLkt9KsUv5HDlJLVW3D3h51tRqHw0IXyNgYAkWsZ6grHhyYQYSOyFUVTtwJ
	+tAxfsnUE7i8lXsfzj1hJEqxiynJfQLy7wZX1E7mXna5q+OcDUSgkhd+bQtnBYyWwWb08f
	DeCBegC55sE43GdEJlqy7dWzulkDKH0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 30F09444D4
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8FFC2BCC9
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774311367;
	bh=6Gx75jnNvcaM6576W+SZe+dNyLWeLhW4qqMK58nkH+E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=JIKAbPpHGROjBGv7IHh0X1W9lMdaGkdvyWXfU11Lw25fujx26kPAob5bNPyMATsEF
	 DTtOUenelJ2eiNiwIHPn+jC/39bU8ZgRHyBZkqraTHfy+vl09GXfNJ1JErR80MbYQO
	 bmZBniu1Qejnvlu41IsUPEv+3HI0xdWCi0prOOnUwKOzREL1pfMyPl0j5U1zCSuXAv
	 O1ghQeGthh+UtOQUiDjgj1uKXloR4VM/vovM0DqlUlU0BDUUF0i9cnpALxpaqXgZEN
	 hjl00wFRbPaV/l0ZgoHdgyqplYLk6NnokTR5Y0DVf/+0Nn66J3AMT4Ump/RooUJmU0
	 u75XN3cSAWRUA==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b97e6e48b24so149997966b.2
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:16:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXWW/MZfHOCPO0SLbYT4m3dFgGeLII4n7muferaE6wdDuZVCWhOJtBuB2tK8UloXvwuojWNa5yOiw==@kvack.org
X-Gm-Message-State: AOJu0YyWlAfybBBC9menUngbbYXQ+XRKN/R2kGqHuGi2hKVKmELssKhm
	8+3Gf/wYW2ru889QyC4m4fkn8AjM0B377XrvBP5/oS1wbYJixdhOxfn5H64kYkyrBEIxlka4ktQ
	piTiyKWz5miXv2hfkMai/y2Uq3ewrZ4c=
X-Received: by 2002:a17:906:1d09:b0:b97:87e4:7f40 with SMTP id
 a640c23a62f3a-b982f37d43dmr878599966b.27.1774311365588; Mon, 23 Mar 2026
 17:16:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260320204241.1613861-1-longman@redhat.com> <20260320204241.1613861-2-longman@redhat.com>
 <acE2MoIZ0pl7U7PX@redhat.com>
In-Reply-To: <acE2MoIZ0pl7U7PX@redhat.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 23 Mar 2026 17:15:53 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOTYPgqc_7TVWjQ=adn=pH1TLLX2cBNfa1Y-x=TOFJT1Q@mail.gmail.com>
X-Gm-Features: AaiRm52fV4nUPr8f7ewBjl2IN6lomvXA8YiY3qcPBfQuorYLYyMi7pBpBc1tcdg
Message-ID: <CAO9r8zOTYPgqc_7TVWjQ=adn=pH1TLLX2cBNfa1Y-x=TOFJT1Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] memcg: Scale up vmstats flush threshold with int_sqrt(nr_cpus+2)
To: Li Wang <liwang@redhat.com>
Cc: Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, James Houghton <jthoughton@google.com>, 
	Sebastian Chlad <sebastianchlad@gmail.com>, Guopeng Zhang <zhangguopeng@kylinos.cn>, 
	Li Wang <liwan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 39205100003
X-Stat-Signature: qi3bbjgxcgo9ciwacjw6ukanpjhkhkeu
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774311367-155083
X-HE-Meta: U2FsdGVkX18VXq7pZhwtCcz2b7o/cuDC3eNMWnrKOUkl23KF3/8yYJdwcsX7WxurdH9Tmj8pvjXmf4FiJa7jyH/Kyud6hc10uNELYqYU9PBVgIk6ZGPAo6rwnB9hy/QsiIU1740BA+rkLY7NJaXqOWjsDtN8H7mop+zWHvt7AumWnJQKhUjgYUmw0Phwd7QlPqzGbwnbaeXLFqDKvdzP7jd1XjprYUkdNdB4QOgSf60DJotuu6OngPJ6UbxnToxBSdn8mrjSvvhWDLEBOk+gAWIFwNXVJIh5cuMDSAZUJdQIG1LrXmTrCKWSwvjaDL3kjHVah0WPkHEqKIfCt9jPY1t90vD+D0lW+SKx4MxSEuc+ngbxEiXi2yR2ZYfa94ew5iaOIPo6p98KTzYqP41OpsNM2535QdD7AKpeknt0dMISVChi6jOqL0wL5Ars0lQR7zsCw+g7gmkIlojWIAHcN2zc6WlpitccY/R1hm70RUDRZv44/o0cdIvDZe++fJ4tD+wf96jmvVfxpB/PtLpWkbpVpojQziwrLhX+b26guqo8eSDaqrIugkjUIB2HPuTTuXTBF/sJr6qxeK0bsBVsC4Nz8c3s1lGLJH/aoObHirOCtgFpTZfI8oi5INt5cm5e2cVEbEB21RIEGFvb9kaLIF2AG+4Gc+/78F4NqEmqWzFvo0aRmEwrnFGYFY3kuBe+03IxLVwvnqQCtaMH79qfkfBX/0uLxGJZPVuUDkX7hAVB2SRUs5h/V2HvROB7I3iOryoKZupOfnU/H4yzvo0g55rOgEzAWfLPNJNNmcuyfdtn777qClSQ+45TRGOu13Tb4jaqjE7tiR1V2r2CPJggfc8XOEkfKKaHcHlGUagGNZcZr2h95WKYnuE3iTRKTHt+D/R//GwqWRM+8+QFzkvilgFfAwjOaJbP1roufbUAFQwDJ9yKA0Th2Q90P6EzdBAftuPOAw6YsMN46dSBzDv
 V+z5j/UA
 cfawdoWRMDr8R+FUxTc+uHwwFtnujf/M7GSqfirXuV8g0YnsErNySBT2KOBQnsd0OE6BxWkDPlp1TshLjRx7xn+wC33A2OWUfYHDxrjhx1WodKC65UotmVidCTGbsgEDhqzxpYdrYmh7lQei9Jq+VZGjXnkjM5EMrS5pF5cuYGgkPJm5OJ6zuvdL98AoaaCZ1zR1or45u/D31uOiGTtS76zmNEd2vgAkpkBnDJ3WKVk99fLDB3OF/vGWneRqh2XridqRegXjD8wXbblTcsdvV5lL4BFZ+5MAlC5N+VTJnv39Rf6wBFJMpuimdfNvjwmJ5uh4kon34WOA070EBbrNgt4Oc+XrLwcpnq6agsq2pMN042fkeu4h8AADJkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 5:46=E2=80=AFAM Li Wang <liwang@redhat.com> wrote:
>
> On Fri, Mar 20, 2026 at 04:42:35PM -0400, Waiman Long wrote:
> > The vmstats flush threshold currently increases linearly with the
> > number of online CPUs. As the number of CPUs increases over time, it
> > will become increasingly difficult to meet the threshold and update the
> > vmstats data in a timely manner. These days, systems with hundreds of
> > CPUs or even thousands of them are becoming more common.
> >
> > For example, the test_memcg_sock test of test_memcontrol always fails
> > when running on an arm64 system with 128 CPUs. It is because the
> > threshold is now 64*128 =3D 8192. With 4k page size, it needs changes i=
n
> > 32 MB of memory. It will be even worse with larger page size like 64k.
> >
> > To make the output of memory.stat more correct, it is better to scale
> > up the threshold slower than linearly with the number of CPUs. The
> > int_sqrt() function is a good compromise as suggested by Li Wang [1].
> > An extra 2 is added to make sure that we will double the threshold for
> > a 2-core system. The increase will be slower after that.
> >
> > With the int_sqrt() scale, we can use the possibly larger
> > num_possible_cpus() instead of num_online_cpus() which may change at
> > run time.
> >
> > Although there is supposed to be a periodic and asynchronous flush of
> > vmstats every 2 seconds, the actual time lag between succesive runs
> > can actually vary quite a bit. In fact, I have seen time lags of up
> > to 10s of seconds in some cases. So we couldn't too rely on the hope
> > that there will be an asynchronous vmstats flush every 2 seconds. This
> > may be something we need to look into.
> >
> > [1] https://lore.kernel.org/lkml/ab0kAE7mJkEL9kWb@redhat.com/
> >
> > Suggested-by: Li Wang <liwang@redhat.com>
> > Signed-off-by: Waiman Long <longman@redhat.com>

What's the motivation for this fix? Is it purely to make tests more
reliable on systems with larger page sizes?

We need some performance tests to make sure we're not flushing too
eagerly with the sqrt scale imo. We need to make sure that when we
have a lot of cgroups and a lot of flushers we don't end up performing
worse.

