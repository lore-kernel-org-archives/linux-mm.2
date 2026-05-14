Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BAF8CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 13:40:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89F0C6B0005; Thu, 14 May 2026 09:40:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 876856B008A; Thu, 14 May 2026 09:40:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78D1E6B008C; Thu, 14 May 2026 09:40:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A57E6B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:40:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 01C05A02CE
	for <linux-mm@kvack.org>; Thu, 14 May 2026 13:40:18 +0000 (UTC)
X-FDA: 84766134558.23.B340B13
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0904E40005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 13:40:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sMs6L8mI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778766016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UcirupfxPBQzJs3shFv2nK9lIarxk5Jfe1IH9MumCF8=;
	b=aUTxY/XFxbD5bRhcHFjUJ1zvRxDbDHaKynclToX7thDJE0S302q0CYNIO7gABvvSuzr1Y8
	DpEdL8w+ZguhcHpcT0UU25/9tZNuGcYr22H1RQmhXYMlT6+fJwO7tb/OrgOhWgjaUTC4Rd
	7iyXrBaGCVZa43VDktXIE/jX4N+ZElw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778766016; a=rsa-sha256;
	cv=none;
	b=aWE0/WAlhpGzEAuawlcHfQwWGPQ361BUmTzJEhng+H3Ed0eo5i2dXFwmJ6SwU8GLGHqipG
	lV5UVhXJ4HrvLLCcsDLH2gxIxWyYs6ah2pRKN8txU39bIg3zbGhxSsf+LBEIq3w/0YucKG
	ZnDZrPmWrwVcEDPg0YaqQeuM+NqON7I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sMs6L8mI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778766013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UcirupfxPBQzJs3shFv2nK9lIarxk5Jfe1IH9MumCF8=;
	b=sMs6L8mI85LFABgq1nI4z8nla660NI9Pa3FIENgPJdyoosQzy2I0JhilXHQ+C9fPDjifj4
	+4wwd1Zy6+4gcDY+F0BEI9an9TxoTa2GVLXik93wFBWJPxkypYnN72Ep+dYLs6Jq7SFtNg
	8gmsvhU21e+0KIOd58IKisLVJ8ACs6M=
Date: Thu, 14 May 2026 13:40:06 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Shakeel Butt" <shakeel.butt@linux.dev>
Message-ID: <93b7c3f206f158e7387cbb5f0bf5845b59b93053@linux.dev>
TLS-Required: No
Subject: Re: [linus:master] [mm] 01b9da291c: stress-ng.switch.ops_per_sec
 67.7% regression
To: "Qi Zheng" <qi.zheng@linux.dev>, "kernel test robot"
 <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Carlier"
 <devnexen@gmail.com>, "Allen Pais" <apais@linux.microsoft.com>, "Axel
 Rasmussen" <axelrasmussen@google.com>, "Baoquan He" <bhe@redhat.com>,
 "Chengming Zhou" <chengming.zhou@linux.dev>, "Chen Ridong"
 <chenridong@huawei.com>, "David Hildenbrand" <david@kernel.org>, "Hamza
 Mahfooz" <hamzamahfooz@linux.microsoft.com>, "Harry Yoo"
 <harry.yoo@oracle.com>, "Hugh Dickins" <hughd@google.com>, "Imran Khan"
 <imran.f.khan@oracle.com>, "Johannes Weiner" <hannes@cmpxchg.org>,
 "Kamalesh Babulal" <kamalesh.babulal@oracle.com>, "Lance Yang"
 <lance.yang@linux.dev>, "Liam Howlett" <Liam.Howlett@oracle.com>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Michal Hocko" <mhocko@suse.com>,
 "=?utf-8?B?TWljaGFsIEtvdXRuw70=?=" <mkoutny@suse.com>, "Mike Rapoport"
 <rppt@kernel.org>, "Muchun Song" <muchun.song@linux.dev>, "Muchun Song"
 <songmuchun@bytedance.com>, "Nhat Pham" <nphamcs@gmail.com>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Suren Baghdasaryan"
 <surenb@google.com>, "Usama Arif" <usamaarif642@gmail.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Wei Xu" <weixugc@google.com>, "Yosry Ahmed"
 <yosry@kernel.org>, "Yuanchu Xie" <yuanchu@google.com>, "Zi Yan"
 <ziy@nvidia.com>, "Usama Arif" <usama.arif@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <46e9f5cf-34cb-466d-a53a-5778768af4d9@linux.dev>
References: <202605121641.b6a60cb0-lkp@intel.com>
 <agNO8G8tPnPuVrGq@linux.dev>
 <0e1b8994-944d-4dda-8966-3cd43661796d@linux.dev>
 <agSAT4ldp3dzKWPl@linux.dev> <agSJ4ulNDZ17ah8H@linux.dev>
 <46e9f5cf-34cb-466d-a53a-5778768af4d9@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 0904E40005
X-Rspamd-Server: rspam04
X-Stat-Signature: zo6udjonef5urtdbzrhp4kxnh4epzf8q
X-HE-Tag: 1778766015-105391
X-HE-Meta: U2FsdGVkX1/8sblL11LI3gQ65/L2EMHoR+HwHscw7SHZdcjGBLqAmY+qxB6wu3CA8G3g6yiKHTmHX0TfPE5p4l7t6Y5usNwnF5BmutvgFbHX9bk3+wcxPUOOryYi+gHOKgcee7R9qfeDEuARe1di7ar3qZUcZLaJWtgRp/E5GTalt5/pwxZnX8h0iJ4ShYdzpX3j6MpVDLzbI6syWCylWRuCjTJ5eyP+7p4c/8/GJnZoewzOG50+GBnKcug+irV2Lk8nM76JGeq5/0X2FacUExGlQcYNrwMcaF/EhONLaHhghIED/btCbkwYfvQaztH5Np30H4WygMG8BmlUQJtzFR1ShDHDmxxZWNrqONfC8fN5Tqm962T+CFJsTpEFuoFNNK0EAaqsUTWdtdXJvLwyDNqQiVXBV3Y2m840cIKT5BYfYi7B0WByG7wmcD6BrqhwqWHiQH2vGF2cAO8xK4VUJSJe4YllPz7IwJhFaMz8qWVtiWQlG+4P+b3vFk8y+K0BC37N6c1b9lrtbffRlDY6Lh5ayJCv9b5nfFVsKH4noNVYFYgWdaqWG+dsI5KKFgeb8bSpz972zBFe9PfRMCKDwvk2TkhLrukXnwSHQfLQO5Z7yz336q7p149vWAUIoG7m59CQSFP0AfO+pYcV6iW2tcG32ymiGaSxBoLm89x71YR43/ZZo+ZWxNxYHziMIy1cvg+Sqj4nC9KXBVY0r2MLHO+UtMCT40DJs/vnOeAtT3hPYZO1XOz5G+M3SQ5X/YggarglsD3aT1c4vbkZMBGhwdtwmM+HI6SSRR4ftqN2vwfDehLBG/LTrkrLECjIObcQQuKAJ/2Ov2+2vV26WqlRAbGnyaT/9JOnV1RmZCLR+j8+7QaKQAeksVHIVTGCciBhC/nsRNQJgjxafEVyuhT4u8ogcYMkY/U7CTVyXBCyW07zYeZxGb8IWOPLoid+feqDcf2YycxaTXQvf5LzU14
 3/aHrlXh
 e2CITauBn77LEpDo/nOFb/P6AVJqvTg16n9X91TuSqo7JjJ+63Mkzrr5v9DkyqdqauYPgs/A3ckT8HOBs0De/Pwm/rMvlKRcal3iZMAOFnoqwzNxZCDIBxco7t6WxSORyHYcxmpsGdA7wA91uUvLUmgwfx//nG0qQH8pT2hzXu+GL0/PMTK1yzRuOfIuhPIga4Brr56dmntTU3lqM/DsIti7+jPfCiDJkpy9LgSCVbIGyeitpTiKoP/+0HUOXJMm+T3Ex+B7Y/GCbp06TpsktTJ1+6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

May 14, 2026 at 12:46 AM, "Qi Zheng" <qi.zheng@linux.dev mailto:qi.zheng@=
linux.dev?to=3D%22Qi%20Zheng%22%20%3Cqi.zheng%40linux.dev%3E > wrote:


>=20
>=20On 5/13/26 10:27 PM, Shakeel Butt wrote:
>=20
>=20>=20
>=20> On Wed, May 13, 2026 at 06:49:45AM -0700, Shakeel Butt wrote:
> >=20
>=20> >=20
>=20> > On Wed, May 13, 2026 at 10:10:34AM +0800, Qi Zheng wrote:
> > >=20
>=20>  On 5/13/26 12:03 AM, Shakeel Butt wrote:
> >  On Tue, May 12, 2026 at 08:56:52PM +0800, kernel test robot wrote:
> >=20
>=20>  Hello,
> >=20
>=20>  kernel test robot noticed a 67.7% regression of stress-ng.switch.o=
ps_per_sec on:
> >=20
>=20>  commit: 01b9da291c4969354807b52956f4aae1f41b4924 ("mm: memcontrol:=
 convert objcg to be per-memcg per-node type")
> >  https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git mast=
er
> >=20
>=20>  This is most probably due to shuffling of struct mem_cgroup and st=
ruct
> >  mem_cgroup_per_node members.
> >=20
>=20>  Another possibility is that after objcg was split into per-node, t=
he
> >  slab accounting fast path is still designed assuming only one curren=
t
> >  objcg per CPU:
> >=20
>=20>  struct obj_stock_pcp {
> >  struct obj_cgroup *cached_objcg;
> >  };
> >=20
>=20>  So it's may cause the following thrashing:
> >=20
>=20>  CPU stock cached =3D memcg/node0 objcg
> >  free object tagged =3D memcg/node1 objcg
> >  =3D> __refill_obj_stock --> objcg mismatch
> >  =3D> drain_obj_stock()
> >  =3D> cache switches to node1 objcg
> >=20
>=20>  next local allocation tagged =3D node0 objcg
> >  =3D> mismatch again
> >  =3D> drain_obj_stock()
> >=20
>=20> >=20
>=20> > Actually I think this is the issue, we have ping pong threads run=
ning on
> > >  different nodes where though theu are in same cgroup but their cur=
rent->obcg is
> > >  for local node and thus this ping pong is thrashing the per-cpu ob=
jcg stock.
> > >=20
>=20> >  The easier fix would be to compare objcg->memcg instead of just =
objcg during
> > >  draining and caching. In addition we can add support for multiple =
objcg per-cpu
> > >  stock caching.
> > >=20
>=20>  Something like the following:
> >  From d756abe831a905d6fe32bad9a984fc619dafb7e0 Mon Sep 17 00:00:00 20=
01
> >  From: Shakeel Butt <shakeel.butt@linux.dev>
> >  Date: Wed, 13 May 2026 07:24:55 -0700
> >  Subject: [PATCH] mm/memcontrol: skip obj_stock drain when refilled o=
bjcg
> >  shares memcg
> >  Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> >  ---
> >  mm/memcontrol.c | 14 +++++++++++++-
> >  1 file changed, 13 insertions(+), 1 deletion(-)
> >  diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> >  index d978e18b9b2d..01ed7a8e18ac 100644
> >  --- a/mm/memcontrol.c
> >  +++ b/mm/memcontrol.c
> >  @@ -3318,6 +3318,7 @@ static void __refill_obj_stock(struct obj_cgro=
up *objcg,
> >  unsigned int nr_bytes,
> >  bool allow_uncharge)
> >  {
> >  + struct obj_cgroup *cached;
> >  unsigned int nr_pages =3D 0;
> >  > if (!stock) {
> >  @@ -3327,7 +3328,18 @@ static void __refill_obj_stock(struct obj_cgr=
oup *objcg,
> >  goto out;
> >  }
> >  > - if (READ_ONCE(stock->cached_objcg) !=3D objcg) { /* reset if nec=
essary */
> >  + cached =3D READ_ONCE(stock->cached_objcg);
> >  + if (cached !=3D objcg &&
> >  + (!cached || obj_cgroup_memcg(cached) !=3D obj_cgroup_memcg(objcg))=
) {
> >  drain_obj_stock(stock);
> >  obj_cgroup_get(objcg);
> >  stock->nr_bytes =3D atomic_read(&objcg->nr_charged_bytes)
> >=20
>=20This change looks like it should be able to fix the ping-pong issue, =
but
> I stiil haven't reproduced the performance regression locally. I'll
> continue testing it.

Same here, couldn't reproduce locally. It seems like we had to craft a sc=
enario
where the pair pingpong threads get their current->objcg from different n=
odes.
I will try that.

>=20
>=20Hi kernel-test-robot, could you help check if the patch above fixes t=
he
> issue on your end?
>=20

In=20the meantime, Oliver, can you please help in testing this patch?

