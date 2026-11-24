Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96897606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 04:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=EChO5xkU
Received: by kanga.kvack.org (Postfix)
	id 8C8826B05E6; Mon, 23 Nov 2026 23:33:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 877DE6B05E7; Mon, 23 Nov 2026 23:33:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78E066B05E8; Mon, 23 Nov 2026 23:33:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4A3846B05E6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:33:42 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AC4B0A0AFC
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 04:33:40 +0000 (UTC)
X-FDA: 85468744200.23.4DD41CF
Received: from mta0.migadu.com (out-215.mta0.migadu.com [91.218.175.215])
	by imf01.hostedemail.com (Postfix) with ESMTP id 183FD40003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 04:33:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EChO5xkU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.215 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795494819;
	b=Gm2ULpc2kEksZgCDhBkeu+2xIsE0CAnzG89qxGD9syYM1P2IYrnU5Ywui9U0qZv5fou+jb
	vdeeA6m9Xsrl50wHFp55lEyW6Og7IfwRfb4knkL9Bw+P1FJfVXRn6/62nesngkJFgXdmZ0
	2wMVUcjNnBtFYlPR7IO83hKLmmq+m/4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795494819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qeS+Wqldyca7IlFeTqWB+yHVGIRNOofJMih/xkJzWH0=;
	b=cwjJTV5oH9pP9z2PHzMhbFxO/cvhjhlpuI4BzpKX0Q7IlKDH/UwiL+C8csS4sDD7szUJJ2
	BOtmjRSPTMeJdM6ocdwmx8nIDXIF6w5vuIO0m1m8iA28f0RHl0L/viRh4I11dERj6ESIcQ
	9aKLiiC/2JNJcQ4Y0px1abCPGAuHuM4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EChO5xkU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.215 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=XrJqniAxtYnOjs6qtgcphsG7K6LdaIDb/mHKEP/nTBc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795494815; v=1; x=1796099615;
 b=EChO5xkUCstUOXGGiv9FCZ+/EkSHyKCcChaKP++g+zGEeyhOUnEGUMZvsDHJpcs2y2dHouLE
 b0RxfeAV6fIkbBQc0izTiZA/u8hLON+4WUir1N5L37zz0r5EwLjvahELnjzlOaM76zpU9suNOdu
 JLzoHdnuzLhmAShdbG7m3ZKE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 40e2dd995e1bde24;
	Tue, 24 Nov 2026 04:33:34 +0000
X-Mizu-Trace-ID: 40e2dd995e1bde24
X-Migadu-Flow: FLOW_OUT
Date: Mon, 23 Nov 2026 20:33:33 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Muchun Song <muchun.song@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] memcg: free the private ID of a memcg that never comes
 online
Message-ID: <awUTKy9tx8nWJgXf@linux.dev>
References: <20261124000439.967403-1-shakeel.butt@linux.dev>
 <F39B4A81-BB17-4C5D-851E-2740EBBBBA8B@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F39B4A81-BB17-4C5D-851E-2740EBBBBA8B@linux.dev>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: ifnnge719jrny57c3p8949htezieb53y
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 183FD40003
X-Rspam-User:
X-HE-Tag: 1795494816-337969
X-HE-Meta: U2FsdGVkX1/p0EnIh4rimiqY/47nsXpjrB5GckTfPmhRzcrNxcLstOwTj25NK5VEpCXaCjc9tN7utRpQKib2odKEwPhrDY9I7ouqpMPE98f8ZHBzzr0QrHAL16jPUWIM6uDzrWW93jcwlb7B59XvikAyxnZWtpJkop34VwRN6nkVL6O5eCRPbtrBxPSUs17R9NspVcANKf5ptuLWsruYvyUDMklJYxkPnou+qvpX2FiKP3j0xh9ulWKMFDrocGU6IQHZ8Du20CguoqgWsVt+guS1xrAo4Q0T01TJa+hd0AUGStnwJwNwRWH6iODF25HMqkd62rAOa690hZEO6/TCqzZeTyc2hmMWzRa5EKgWWLwWY0fVGkjYv6m7VrjAzPFa8yBlEpuIa5DOj7jalxb+snv7ous4Lqj0ehTGX7GmNUw1Z7mJgG7GUMeew/+AtCOlGixD+idTIHiTnF8gcOD0tBbmgEkhNT39OlB4GCeccQaw2iSNMLubZSU1ex6hqohNq5vzSbGwawsIbql3oLMpdp9CTvaMQhAUTtpcsmGW1nZtLLWOlXEOzKN9Azns5iQGSQP8RlpPg+qFyuZrmRFmscfdeBsYZY1vZTx8B8aTYZu/eYqjfJO1DLbS7MQyriZetDAm7/q++FarLHgfCr85ztEcOX23unCwyhEN187tY9gTYtiooQUCbDUsXKTqf4Qyc5g6Oi4f8cwwiSr3pw1hL/damAkLfK3pga9hyEfJvIeJB9PkKOq50dAjs8FJ7wvXRw24YZPYNOVmr06+KoEeIYzE6i/0ZXz01YLB0vbtOKX6DnxUtcw6bMaJJMdUmlmcJiIO9r0PA6lJKaxeZ/XjN/JYb52nSYzDM4Az879JAT4jKQGD/x3KncIijIGvLAPE5ZRm2nx1ohCMlYXktYlJmZfQohhFMgDzrfnF2s+7z8BojwlvKv5ps4sZFb93Rs6AEgg77u/kl/v9pC8KmeV
 WIDenS7y
 K4+nKqs+Ut5/wmOVug+j7lLtd4nSSY81Q58BB/jjlUDJoeUPeAzzTP6yUhYLOCWeeznq+jv8TnBi8+VbnFj+UwOdV3KkTvI6y18KXWlT79zuwh1L5/NmPr1sdpo5w2q4CYD9VufnOd/Jr8QYCLXGPH4/5AGPYSD9pIMgnhlc1aVD8+vFbgiO/TuZMY708fc+tfKN4WMN9TRPX6ir/VvSsoevu7Agyq0QJuxMs9Itf2Vi7uurK3pM3Kvv0mE9BcBcH/SSyNRv0nlrkfs6BTiVdP3GkfNzQcZj5tsGm9r52NI9VV3Zb3EJVG9LiW9MIat9BzyDs7vXXs2m45azbfm8MZo+4GpuE2QcQbzC31aFxHZFeCXZCb+MidIuo7Jewz97dHAWBv91LXi8MytLrhMrb5lLyuCaP687OSPG4+ZevzhBMDv4mH2ex7laBAYS+rvDPLdHJfDQeAUmmupL6D5OiD47wfLahdKRFJ4EwBJJiDqq1lvRuGdI4VTccdCqKI5G2K8B4aAKQvgoftQY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 10:50:00AM +0800, Muchun Song wrote:
> 
> 
> > On Nov 24, 2026, at 08:04, Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > 
[...]
> 
> The leak analysis and the fix look correct to me. However, using
> CSS_RELEASED here makes the private ID cleanup depend on a generic CSS
> teardown state, and adds an accessor solely for this failure path.
> 
> The private ID is not needed until mem_cgroup_css_online(), so could we
> instead reserve it at the beginning of that callback? Failures in
> css_create() before ->css_online() would then never own a private ID,
> while failures after the reservation would continue to use the existing
> mem_cgroup_private_id_remove() cleanup.
> 
> This would also make the private ID lifecycle more explicit: reserve and
> publish it during online, then drop the initial reference during offline.
> It would avoid both the new css_is_released() helper and special handling
> in mem_cgroup_css_free().

Thanks Muchun. Nothing needs the private ID before ->css_online(), so
reserving it there would work. But it moves the out-of-IDs failure from
->css_alloc() to ->css_online(). By then css_create() has linked the
css into the parent's children list and css_idr, so mem_cgroup_iter()
can css_tryget() it and cache it in iter->position. A css that fails
online is freed without ->css_released(), so
invalidate_reclaim_iterators() never runs, and the free does not wait
for those references. Today memcg's ->css_online() fails only when a
small allocation fails. With the move, every mkdir on a system that is
out of IDs would take that path. I would rather keep failing in
->css_alloc(), before anything is visible.

To drop the CSS_RELEASED dependency, I can test the ID's own state:
!memcg->private_id_objcg means the ID was never published and the memcg
still owns the reservation. Let me know if that works for you.


