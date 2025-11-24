Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AF02CFD350
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:32:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6469E6B00B7; Mon, 24 Nov 2025 14:32:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F6F36B00B8; Mon, 24 Nov 2025 14:32:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E5CF6B00B9; Mon, 24 Nov 2025 14:32:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 363B46B00B7
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:32:57 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D81EE140567
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:32:56 +0000 (UTC)
X-FDA: 84146498352.20.ED288F0
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf19.hostedemail.com (Postfix) with ESMTP id CC4D91A000D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:32:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ToCpZQ5p;
	spf=pass (imf19.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764012775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HfJ/7gmREKNmMCoZgXv58Xs71gVw+RoOwjVhCTe6jU4=;
	b=m6qnGMKY58FKkD3Dvlo8E7wqIn2qEovrasuTfNddEVNlbdGF8seRCkyOXQTeSeZHa6CwNh
	NwXd3x/yz0m9K3CyyAWhow+rcegrmvhPAmapR5yO5Dx8qQJEnDGcybb9StGs7H5a8sROae
	qDeGJWqcnVwqMridKAA1tF51K8LuEF4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764012775; a=rsa-sha256;
	cv=none;
	b=sMUyPyJYHdbikeEMwKq8N1Mg6SyYiBwgPN2uz/N81QAtK5Nt2X143F1tIv1M8fpvC22PVt
	8xn3fboxwM8giXuPJJF+GnpCHDsPJ7z5fmMXBPETVGUZqch7TTFe+vRltmKChV5UQ4wl5E
	EIbrCHhFX4JHT04UMLNw4NRNW/+tRnk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ToCpZQ5p;
	spf=pass (imf19.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764012772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HfJ/7gmREKNmMCoZgXv58Xs71gVw+RoOwjVhCTe6jU4=;
	b=ToCpZQ5pvyg+y5sXi+cm10MYcSQrEEBVjDVtNzMO/Hvn98hM8xvyhSidtArSjJ7xk/NRq4
	Sx2m/Hp2k0mcosZACu6tYAU8psUFJW5EYbl6UAYVSAqXDEljNQB4k7PHiIMCntOt4r+TE3
	qhB2wAlRiymUH9MbYF5HW+30lQ4dmp4=
Date: Mon, 24 Nov 2025 19:32:46 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yosry Ahmed" <yosry.ahmed@linux.dev>
Message-ID: <2a8fd7bd35939b9aa4a7267c93e1fda995137966@linux.dev>
TLS-Required: No
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: "Johannes Weiner" <hannes@cmpxchg.org>
Cc: "Chris Li" <chrisl@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Kairui Song" <kasong@tencent.com>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>,
 "Baoquan He" <bhe@redhat.com>, "Barry Song" <baohua@kernel.org>,
 "Chengming Zhou" <chengming.zhou@linux.dev>, linux-mm@kvack.org, "Rik van
 Riel" <riel@surriel.com>, linux-kernel@vger.kernel.org,
 pratmal@google.com, sweettea@google.com, gthelen@google.com,
 weixugc@google.com
In-Reply-To: <20251124172717.GA476776@cmpxchg.org>
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org>
 <20251121114011.GA71307@cmpxchg.org>
 <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
 <20251124172717.GA476776@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CC4D91A000D
X-Stat-Signature: xoc6im3cupg6qkyn816cqnn41rsj7zh5
X-Rspam-User: 
X-HE-Tag: 1764012774-76433
X-HE-Meta: U2FsdGVkX19MJaTxxdNYkg3M2N7ABJfrJe5BlhIlawyZ+0ObGqsJSoJAlEm5oSG/5/VGlYONVt0AlbeJiOd3R6ItQ+IkUwHsbOxU/TcHdGjdhkcGTzcJVSGTdxDigXB64V3j2bQDaYROxwEFPWc+gFzeuoLUGpeh7JIQlySLYSVD41TwChfeC/wGeeaxUvP5skddqi2L0n8Ul6q/g3KQXesxGNvIskztR2MedjVt11tGUo+cgr8GZ/HymqvrsHJbzTwhSILC/ea1JAhDCVUcf8wPQ+UAJORnSkVXkLShzucjP6NFvTgdNg64nE0EFreLBuaMJYcOaLbr/C2lysp7OAZGN2gLYME5XizY/cRpDCA57wp9KqyGCKY1R5AI2V/rEPYe1ybuMuCHt8UJdU+ohC0AoA8jRgtNHXFNPoqmKhhpQHzm+iTrlg43CV9CvBND43wu4U7yKiVAAQ/OJU3vUB22NQY5naGoGy1mz/ZtMzI41YSN9ul5t0lqXJ3GrzCWG3L1EphTErr8Ajw4XbcVpCb/w0wX4w7vQI4ku/TTjIgQU96K5W7eJM2Ospqx6GpaBFqXJd36lB6LjtD50xxHdybp0oOcsA+NwGTbLqG8z7VzLYjK1z/kJ//wnjeALnkkF+JLX+kGcZp28WDdDdz6kp/oljRR5Sw5w0t6b66NrT4ATVk98BWnlO6TlPtT/a75rwYyvNnrJs5GBAeaap+P6Blw3QLw4wLZnU3O+k40a3m+N2VeNSWEmKQWfRDYb/FEgGuU0D4sp877vYBMEr8yPBL74+zd24B2R3i4wRQG/LXqMSzsE9OTcs0pOeggZIbH+QegrXoaW8NqowZdzWkYH73UODT7Sak1W86uMVriaW0G3ej/3SkhqlUKrpujrNqPuRwYxsPhnHgvSrMuGxkpkKe5CyvrmlR6nPhDg/9H/P7srlyvePz4RvoV9QiBziK+/G88qtqZqb4zk/uSYrn
 0Xotl0wt
 JszX4CnXd91fY1G7Jt0+gRG/JgOkg1eCNH1mhjofIvejbuIMh8p8GkJQqp05dtmVLJasgH3GjfRMBrJrEM495W5RG8I13U1Q6b8N339hT3CDm5a+FnoV3mI85dSetgsZrToYjMqnXM63YI2jlUOH6MwriPBtAmkuaVBPngetmE51MYsvI+lRU+xg+AIGioc0DdejIgjYNC2ltINOko+NUgvXyM2TvwPz3AqpZgkR+bpZ9TH3q4BxswdBY2rnwjGdHkXVMpEfcUphd2lY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 12:27:17PM -0500, Johannes Weiner wrote:
> On Fri, Nov 21, 2025 at 05:52:09PM -0800, Chris Li wrote:
> > On Fri, Nov 21, 2025 at 3:40=E2=80=AFAM Johannes Weiner <hannes@cmpxc=
hg.org> wrote:
> > >
> > > On Fri, Nov 21, 2025 at 01:31:43AM -0800, Chris Li wrote:
> > > > The current zswap requires a backing swapfile. The swap slot used
> > > > by zswap is not able to be used by the swapfile. That waste swapf=
ile
> > > > space.
> > > >
> > > > The ghost swapfile is a swapfile that only contains the swapfile =
header
> > > > for zswap. The swapfile header indicate the size of the swapfile.=
 There
> > > > is no swap data section in the ghost swapfile, therefore, no wast=
e of
> > > > swapfile space.  As such, any write to a ghost swapfile will fail=
. To
> > > > prevents accidental read or write of ghost swapfile, bdev of
> > > > swap_info_struct is set to NULL. Ghost swapfile will also set the=
 SSD
> > > > flag because there is no rotation disk access when using zswap.
> > >
> > > Zswap is primarily a compressed cache for real swap on secondary
> > > storage. It's indeed quite important that entries currently in zswa=
p
> > > don't occupy disk slots; but for a solution to this to be acceptabl=
e,
> > > it has to work with the primary usecase and support disk writeback.
> >=20
>=20> Well, my plan is to support the writeback via swap.tiers.
>=20
>=20Do you have a link to that proposal?
>=20
>=20My understanding of swap tiers was about grouping different swapfiles
> and assigning them to cgroups. The issue with writeback is relocating
> the data that a swp_entry_t page table refers to - without having to
> find and update all the possible page tables. I'm not sure how
> swap.tiers solve this problem.
>=20
>=20> > This direction is a dead-end. Please take a look at Nhat's swap
> > > virtualization patches. They decouple zswap from disk geometry, whi=
le
> > > still supporting writeback to an actual backend file.
> >=20
>=20> Yes, there are many ways to decouple zswap from disk geometry, my s=
wap
> > table + swap.tiers design can do that as well. I have concerns about
> > swap virtualization in the aspect of adding another layer of memory
> > overhead addition per swap entry and CPU overhead of extra xarray
> > lookup. I believe my approach is technically superior and cleaner.
> > Both faster and cleaner. Basically swap.tiers + VFS like swap read
> > write page ops. I will let Nhat clarify the performance and memory
> > overhead side of the swap virtualization.
>=20
>=20I'm happy to discuss it.
>=20
>=20But keep in mind that the swap virtualization idea is a collaborative
> product of quite a few people with an extensive combined upstream
> record. Quite a bit of thought has gone into balancing static vs
> runtime costs of that proposal. So you'll forgive me if I'm a bit
> skeptical of the somewhat grandiose claims of one person that is new
> to upstream development.
>=20
>=20As to your specific points - we use xarray lookups in the page cache
> fast path. It's a bold claim to say this would be too much overhead
> during swapins.
>=20
>=20Two, it's not clear to me how you want to make writeback efficient
> *without* any sort of swap entry redirection. Walking all relevant
> page tables is expensive; and you have to be able to find them first.
>=20
>=20If you're talking about a redirection array as opposed to a tree -
> static sizing of the compressed space is also a no-go. Zswap
> utilization varies *widely* between workloads and different workload
> combinations. Further, zswap consumes the same fungible resource as
> uncompressed memory - there is really no excuse to burden users with
> static sizing questions about this pool.

I think what Chris's idea is (and Chris correct me if I am wrong), is
that we use ghost swapfiles (that are not backed by disk space) for
zswap. So zswap has its own swapfiles, separate from disk swapfiles.

memory.tiers establishes the ordering between swapfiles, so you put
"ghost" -> "real" to get today's zswap writeback behavior. When you
writeback, you keep page tables pointing at the swap entry in the ghost
swapfile. What you do is:
- Allocate a new swap entry in the "real" swapfile.
- Update the swap table of the "ghost" swapfile to point at the swap
  entry in the "real" swapfile, reusing the pointer used for the
  swapcache.

Then, on swapin, you read the swap table of the "ghost" swapfile, find
the redirection, and read to the swap table of the "real" swapfile, then
read the page from disk into the swap cache. The redirection in the
"ghost" swapfile will keep existing, wasting that slot, until all
references to it are dropped.

I think this might work for this specific use case, with less overhead
than the xarray. BUT there are a few scenarios that are not covered
AFAICT:

- You still need to statically size the ghost swapfiles and their
  overheads.

- Wasting a slot in the ghost swapfile for the redirection. This
  complicates static provisioning a bit, because you have to account for
  entries that will be in zswap as well as writtenback. Furthermore,
  IIUC swap.tiers is intended to be generic and cover other use cases
  beyond zswap like SSD -> HDD. For that, I think wasting a slot in the
  SSD when we writeback to the HDD is a much bigger problem.

- We still cannot do swapoff efficiently as we need to walk the page
  tables (and some swap tables) to find and swapin all entries in a
  swapfile. Not as important as other things, but worth mentioning.

Chris please let me know if I didn't get this right.

