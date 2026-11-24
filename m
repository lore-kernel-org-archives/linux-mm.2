Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DDC6606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 02:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HeJxvI1c
Received: by kanga.kvack.org (Postfix)
	id 808E56B05C9; Mon, 23 Nov 2026 21:50:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BB596B05CB; Mon, 23 Nov 2026 21:50:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CFFA6B05CC; Mon, 23 Nov 2026 21:50:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 40D666B05C9
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 21:50:24 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C751C1C4502
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:50:23 +0000 (UTC)
X-FDA: 85468483926.19.4FB9266
Received: from mta1.migadu.com (out-114.mta1.migadu.com [95.215.58.114])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3B5F280007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:50:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HeJxvI1c;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.114 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795488622;
	b=K+gWNVKTV1vahMffk+PbEXOymi35E5DASDdaRhtVAFYZBq2P6LdxIxiSyvSi/KjX4jpzA1
	u3W6ith4FCMaaFKBVk2i2Euh3XPXkpoojepJGFPd4D9SV/5SDxV7Mepka500KikcvPYlxS
	xdHY5GJO5MuKCbiAVwkn2hWD4vsM4Mk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795488622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FF+rLemNvQli8Y0SC/xA9vPWVsbRgVrCInJrQ5eKDu4=;
	b=aMExSn5oYiqA67FN23Q321bNiRCohBMmuKBv93VtEjhyhpjfFCxGDiJSuIDyQShJ9TeCft
	/2TQKghV3/RHzLNgGrP8JxBG0vNEqmTQqj7tI0mcvy2iVJFtX043whqO7yRbQQRQKAXjFL
	LbFb2nSb43FEf/r5ByK2ULQHSvsJ+lA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HeJxvI1c;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.114 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=czFmZtebk+h8PB2klgzex5BMJY4BT8CV+nACYRQTDOo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795488619; v=1; x=1796093419;
 b=HeJxvI1cZ2wtHMS3o/BQsChKQVcXS9w8/EbKIcXEtW2rwMONJuEk9KLtUkhkkxtKBsD4S5qs
 SmVyaoUeaZKXHe6sUDpas8eqpiA/4dtzEQ5EFrzLVyE+xUAHcc54aa5HSZuUvMIuTJbN0s9odwA
 s1InIO7EZYASZJvrWPp8VhLk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 41f9a57973e118ef;
	Tue, 24 Nov 2026 02:50:18 +0000
X-Mizu-Trace-ID: 41f9a57973e118ef
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH] memcg: free the private ID of a memcg that never comes
 online
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261124000439.967403-1-shakeel.butt@linux.dev>
Date: Tue, 24 Nov 2026 10:50:00 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Koutny <mkoutny@suse.com>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Meta kernel team <kernel-team@meta.com>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <F39B4A81-BB17-4C5D-851E-2740EBBBBA8B@linux.dev>
References: <20261124000439.967403-1-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: aej1xm5rubqt1iw1hdfpmdyiux8jtwfm
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3B5F280007
X-Rspam-User:
X-HE-Tag: 1795488620-950584
X-HE-Meta: U2FsdGVkX18T0pEAEjaqjIMz2YyS0k3IdJk+4LbiKoX6s7aX6zdG0yL+iJ/k5nN/y9BbWTQvk8sTggNs5ruzkCWWYyUUFvd8hBFTF1Q+nB3LBqIP3uVY6t0VVDynNjF6Qm/5nPqyzyZQIqeeas/n31BOIXyFCS9XtXX95WfLzaBX5XLtQJI89xTxin2P9Ya8cE3oygjsHrr/8+y5dWKG6CPpHlQQSI5mi/2U7fi2IyUtuXbXilqHyiqk1gjPcpRvAh5or/OmDnov4wkeBRs74wkiqOP3bNyqtxOQaVEMeIAqN1Mc4N7KqUVCXuB3LB6i0T2EWoYP6oh6Mxkq0D47ooX9YxO0yrJaVzHL+V6MmNfxEXuf3Pc1bVdEarLma0zeQjGvTD4StSbPLEO7MR/wZ16JneDaopBTVKzVRZQx9JLhOL1lw80JQz6+T/RGhZ4W2OBTc2QkjBs35ljNDfU0Bb99anBBTtaiDjP4NDFQWE/43vKl3dQLJRhhY9sTB7OhDSlS+PeDFpPC1S0qbZ4K3rGBNrrZtiZjPMlrfFHNtwMMkunBqWV3QoDsn7WwuluOB9jS18eeKyJpcp5ngt+K/mNUd7iFzwVoeknJs7/nCzw5/K+J+9FzbmrgXzy5sWVUXbNCsjKFdVrWKPjULcIpqkodCmprCtftWRpEAisoIWMvSZBZr7NeIaFRv+vJ7pkNB+xhLGIS1Hz897peZYTohOG+ZBvmLt4zOEs2Vud0O0BY4i2+5zAaqFhm81kgI5Z0v5SHv2ieQ00wvNVH4Qygt2a/YayRReJK9kiTWtzmp9x59lMX04haoCtpFLZqCwcsk7jsiLY8yH42aT/ZWDR4OpCyeT6OICEEUK0MSWLMBgiJ3R8sGvWD34FUQlXY59yj4qDwbjoYvKufTuDJ7b0Mu6KG8P8Opxgh0DgxYFwXTcojD8SJiOi77GN9eeeyfVukhPt+/i2L1qs2DO4TVPt
 ftL8STTA
 pwHUmZp8PhyZD7N08qXTC1SLsv5X+9AESSLQAq1KAlbOdvUcWwDbTfPDzeGu0VKV1l2vnk6zkBQgDtc41V7JaLvJqPcjNNwad8KDUGAp6lvDAw+VSGvsXsrcm53KEFxaGBKhu1U+rPYUi5XETJ9iqRS3KvoDtQygTrnZ6CXC6+caFZc+E/P2SKxAbp/BgaPpfygPPibS2TKNYiJYpQ9rIxfRoLOYTQq9DRS6Fd68K0fHSL+SLusJskTTq7quzmpy8xbbrwRHBr6u3LOPEX9f2u5eIcNcpjEp8nLCFu9+kipzngY7t7BKItP95THz6Vrx9biMvhILqH+a1dHStLeR8um1aegMIYQ8JtVP0rM5W7C1vdoqa2/X9LtymavtspUXVvmvTYHivTg28FZK+AxBMyAiGhc73ITWfgWU89wEnDKHnKqiqz8moZMTvgjrtU6sIlWXAmar2HuMWJLpVVYT+r5Kp3vOz9PUBbRtq7Xb50p2sx/wp9lbKUUaL8Erm0RzsgreIT26xeiAMvTxkIXbqdNfq1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 24, 2026, at 08:04, Shakeel Butt <shakeel.butt@linux.dev> =
wrote:
>=20
> mem_cgroup_alloc() reserves the private ID of a memcg when its css is
> allocated. The ID is erased when the last reference to it is put, and
> that reference is first taken in mem_cgroup_css_online(). The failure
> paths of mem_cgroup_alloc() and mem_cgroup_css_online() erase the ID
> themselves.
>=20
> But css_create() can also fail after css_alloc() and before
> online_css(): in percpu_ref_init(), cgroup_idr_alloc() or
> css_rstat_init(). The memcg is then freed through =
mem_cgroup_css_free()
> without ever coming online, and nothing erases its ID. The reserved
> entry stays in mem_cgroup_private_ids for good, and each such failure
> takes one of the 65,535 IDs away. With failslab failing radix tree =
node
> allocations during mkdir, 1,500 mkdirs leaked 6 IDs this way.
>=20
> Erase the ID in mem_cgroup_css_free() if the memcg never came online,
> which is when (memcg->css.flags & CSS_RELEASED) will be false: it is
> only set when an fully onlined memcg is released.
>=20
> Fixes: 73f576c04b94 ("mm: memcontrol: fix cgroup creation failure =
after many small jobs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
> include/linux/cgroup.h | 5 +++++
> mm/memcontrol.c        | 7 +++++++
> 2 files changed, 12 insertions(+)
>=20
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 2afb4cb2bb4f..123c713dcc91 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -449,6 +449,11 @@ static inline bool css_is_online(struct =
cgroup_subsys_state *css)
> 	return css->flags & CSS_ONLINE;
> }
>=20
> +static inline bool css_is_released(struct cgroup_subsys_state *css)
> +{
> +	return css->flags & CSS_RELEASED;
> +}
> +
> static inline bool css_is_self(struct cgroup_subsys_state *css)
> {
> 	if (css =3D=3D &css->cgroup->self) {
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 091401cecf39..e7dfc96fd1b9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4545,6 +4545,13 @@ static void mem_cgroup_css_free(struct =
cgroup_subsys_state *css)
> 	irq_work_sync(&memcg->high_irq_work);
> 	cancel_work_sync(&memcg->high_work);
> 	free_shrinker_info(memcg);
> +
> +	/*
> +	 * The css_create() error path bypasses normal CSS release, =
leaving
> +	 * CSS_RELEASED clear. Drop any private ID that is still =
reserved.
> +	 */
> +	if (!css_is_released(css))

The leak analysis and the fix look correct to me. However, using
CSS_RELEASED here makes the private ID cleanup depend on a generic CSS
teardown state, and adds an accessor solely for this failure path.

The private ID is not needed until mem_cgroup_css_online(), so could we
instead reserve it at the beginning of that callback? Failures in
css_create() before ->css_online() would then never own a private ID,
while failures after the reservation would continue to use the existing
mem_cgroup_private_id_remove() cleanup.

This would also make the private ID lifecycle more explicit: reserve and
publish it during online, then drop the initial reference during =
offline.
It would avoid both the new css_is_released() helper and special =
handling
in mem_cgroup_css_free().

Thanks,
Muchun

> +		mem_cgroup_private_id_remove(memcg);
> 	mem_cgroup_free(memcg);
> }
>=20
> --=20
> 2.53.1-Meta
>=20


