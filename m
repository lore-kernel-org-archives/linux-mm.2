Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4087FEC01DF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 12:25:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 821E26B0005; Mon, 23 Mar 2026 08:25:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D12A6B008A; Mon, 23 Mar 2026 08:25:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C07B6B008C; Mon, 23 Mar 2026 08:25:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 120696B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:25:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BAB8B160B0A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:25:29 +0000 (UTC)
X-FDA: 84577248378.13.40A05BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2E26E100005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:25:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WONIsc1l;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774268728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eqedniYkY+gWX18oUdTKHjEay57dsRI19i92qPgUPcY=;
	b=CWfTmJYuCAC9W0Tif+J86IFsju/0GYfodfpD8NXjHucFiP5gVdiYRLO8haAYqyJJxgBG/T
	Cxmsqw9pC+1JBosT594z3bcoWNJmy62K+0nZlw1w04FvMStQbjh/ac5lSQtktHxxpRw6HL
	4bjLp4n8OuIW5J2RQb7kx0632m2Q0I8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WONIsc1l;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774268728; a=rsa-sha256;
	cv=none;
	b=Pd0ovBftC38sMz0W0Q0icjKUcvSZTbKuZercecwPlMd0HpValEyNO0Xra1H3c8JqJkh4wA
	ygW6PO5ewvwIbN4ywgyGMzE3v1rLqZZmol69JTqJOKMgXskAc2t5MPRhtWJUXPKeG68vqo
	fGAWZu6rGhocElyL7W4Mxkb77eRJjQs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E9D9600AC;
	Mon, 23 Mar 2026 12:25:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C00C4CEF7;
	Mon, 23 Mar 2026 12:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774268727;
	bh=mVUWgOe9lLa+VOf+1norSky46GtkHIE150PlVzhR5NM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WONIsc1lDroD/0B2DmWkU07c304Bgbaz1sDLm4sqC90nX5zNNUlehXG+d/k6WMGCL
	 n1XsU5A4867Yp8O91JLHBXxmirPFn8fnK8bc+q2yicnGX/3eq1cMGZSFR74B+ljsvY
	 9PqGCRnW7WvIn8rAG2XkC9w8zfqBby7axEFF3CLbFM4G0RSNW0ZLv2h87dC29Ov8H1
	 KVSXwlkiOP+ujCOPheBlJv2Es9jtsDFXmanMKq5ryebUtMJk6R80sZLgZX5F5/LZqY
	 VSlQ5nL6eatb8ZvlOCPuwZkme1LE+LjkYNEyatKLbMGGt2JpCEg3Jo1dIjmoyrJsBG
	 1F/u8KGuq8+rw==
Date: Mon, 23 Mar 2026 21:25:25 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com,
	usamaarif642@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Yosry Ahmed <yosry@kernel.org>
Subject: Re: [PATCH v6 30/33] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
Message-ID: <acExNWaaKdhrBH-J@hyeyoo>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
 <e862995c45a7101a541284b6ebee5e5c32c89066.1772711148.git.zhengqi.arch@bytedance.com>
 <acDxaEgnqPI-Z4be@hyeyoo>
 <2d39ea5e-fd69-4acf-8518-a504f5f7a838@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d39ea5e-fd69-4acf-8518-a504f5f7a838@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E26E100005
X-Rspamd-Server: rspam08
X-Stat-Signature: y7nthjrkikqs3sjzf5z8n3gc7c1dii61
X-HE-Tag: 1774268728-388669
X-HE-Meta: U2FsdGVkX1+V/ZWMgvb3qvXZFYCx79QtajjL/tmHVYPDzuBjkDLFaS+vqv9WZ24KnZTkX2r0nqI3AEoyDphMD4K5KjLH/+8JObVngyFpMbPE9m0IB/bVQw/dQEXVMIRqMdqUuycjXwPSYwdIFODAXDWi5/m95DsIJEzusz8NROSpCtXHiXOy2O0Os68zKWNvJG0llgP831bcvG9u4W5c6OvwIkvj1AD8+ZHcyiHZQ/fEdMOblULKXKbvqQmEe5JPgdNzyTFPEfpq6lsSbaPHNbCdb0/7LoSbulHL3xrmbyVVgUB2cAMgY8zByXwPx1bEuQ0Vv5mR0hxSZ0DOXuPbkni+y1UVZPtt9qGy7Aww9WgJR4W0ia1hXFFlRZ/nnzyIazHl6av09Bsi7XElW8+iatCG/mCrU9PGC0DhfA0uaAM5vgNvB1s1U1Z2vblDOOukKtPG53Rtncis2V+tYUt1WRrsAABxLchKNJmgCsb6h0y5ZzlH1BkA6PU3CzmuDMUrnjG49+qqGUGBU/OUKMmpIYvXyW6bvIQA4qOSZWjT76PLeFk/tKU/2SAru2SGr/s+YYKbPvvPf6TOil1+aSBcneXrpcMTHS1DgQXljsa77VIXLn4fEWAl3xfLkvu9HG1YXo1sK5OOeHNkX63SZ2t9CUaWlyCAau3qwLhaHX3eVUy4kckiUzvebDOt5bQDh4aqCzTWXvGGn548iBuDMZpVZStAGB+sRp7EkMVyVIbmCJo6WDMgIYzXlLsvdrAA6VX3oaQM2PJkvYfTBC9db6tGhs6v80R4nXWmVp1WcsD6KDwaAaV+i+m9qbBYu1JSluYfWMqJ+YBVZTgEWNuZuVdefaBSiQD9qsZYbX3MRZEmV3h6DB3AlDPD9+c/RF/WFV/duXpXofJAS+a5ox2hdmypN5ORBlmmjAnikD3etU47VplSRGXmdHklWy+c2/Gk5N1sgrEg4uGOXonK2kKEKQe
 x1256zZO
 FA1HvTDVS3NpVFjqXyRz9NFEfm/3Gm9jnO9xhx/TJR77/GlNUFtVHvK8xDFAVu47qZYiUo1N3raHWzxl2qe1XEWEHOpECoNmwXG8oZ0FsyfN7T1ysYw9URODp1FpcCN6+2MAjHBfILHdMoShJtxV7bSqlsnTHn8qcDLHZzG7zxnUyzywCcK4BV9VAHJAlxbsphFzFDjFNWIIv7T6E4RY0xhieodiffQdgkhrCgMxMzzbBtVzh5GKkrq7Jx+R5st1G0VM42eQWoSTt5Jomr1N0j722xKDOhj3LeFatfP7BY8FRMZI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 05:47:27PM +0800, Qi Zheng wrote:
> Hi Harry,
> 
> On 3/23/26 3:53 PM, Harry Yoo (Oracle) wrote:
> > On Thu, Mar 05, 2026 at 07:52:48PM +0800, Qi Zheng wrote:
> > > From: Qi Zheng <zhengqi.arch@bytedance.com>
> > > 
> > > To resolve the dying memcg issue, we need to reparent LRU folios of child
> > > memcg to its parent memcg. This could cause problems for non-hierarchical
> > > stats.
> > > 
> > > As Yosry Ahmed pointed out:
> > > 
> > > ```
> > > In short, if memory is charged to a dying cgroup at the time of
> > > reparenting, when the memory gets uncharged the stats updates will occur
> > > at the parent. This will update both hierarchical and non-hierarchical
> > > stats of the parent, which would corrupt the parent's non-hierarchical
> > > stats (because those counters were never incremented when the memory was
> > > charged).
> > > ```
> > > 
> > > Now we have the following two types of non-hierarchical stats, and they
> > > are only used in CONFIG_MEMCG_V1:
> > > 
> > > a. memcg->vmstats->state_local[i]
> > > b. pn->lruvec_stats->state_local[i]
> > > 
> > > To ensure that these non-hierarchical stats work properly, we need to
> > > reparent these non-hierarchical stats after reparenting LRU folios. To
> > > this end, this commit makes the following preparations:
> > > 
> > > 1. implement reparent_state_local() to reparent non-hierarchical stats
> > > 2. make css_killed_work_fn() to be called in rcu work, and implement
> > >     get_non_dying_memcg_start() and get_non_dying_memcg_end() to avoid race
> > >     between mod_memcg_state()/mod_memcg_lruvec_state()
> > >     and reparent_state_local()
> > > 
> > > Co-developed-by: Yosry Ahmed <yosry@kernel.org>
> > > Signed-off-by: Yosry Ahmed <yosry@kernel.org>
> > > Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> > > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > > ---
> > >   kernel/cgroup/cgroup.c |  9 ++--
> > >   mm/memcontrol-v1.c     | 16 +++++++
> > >   mm/memcontrol-v1.h     |  7 +++
> > >   mm/memcontrol.c        | 97 ++++++++++++++++++++++++++++++++++++++++++
> > >   4 files changed, 125 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 23b70bd80ddc9..b0519a16f5684 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -473,6 +501,30 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
> > >   	return x;
> > >   }
> > > +#ifdef CONFIG_MEMCG_V1
> > > +static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
> > > +				     enum node_stat_item idx, int val);
> > > +
> > > +void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
> > > +				       struct mem_cgroup *parent, int idx)
> > > +{
> > > +	int nid;
> > > +
> > > +	for_each_node(nid) {
> > > +		struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
> > > +		struct lruvec *parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
> > > +		unsigned long value = lruvec_page_state_local(child_lruvec, idx);
> > > +		struct mem_cgroup_per_node *child_pn, *parent_pn;
> > > +
> > > +		child_pn = container_of(child_lruvec, struct mem_cgroup_per_node, lruvec);
> > > +		parent_pn = container_of(parent_lruvec, struct mem_cgroup_per_node, lruvec);
> > > +
> > > +		__mod_memcg_lruvec_state(child_pn, idx, -value);
> > > +		__mod_memcg_lruvec_state(parent_pn, idx, value);
> > 
> > We should probably change the type of `@val` from int to val to avoid
> > losing non hierarchical stats during reparenting?
> 
> The parameter and return value of memcg_state_val_in_pages() are both
> of type int, so perhaps we need a cleanup patch to do this?

Yes!

and @val in memcg_rstat_updated() too, I think.

> I will send a cleanup patchset to do this, which includes the following:
> 
> https://lore.kernel.org/all/5e178b4e-a9e0-44dc-a18d-8c014365ee2f@linux.dev/

Thanks!

Should that ideally be applied before this patchset?

-- 
Cheers,
Harry / Hyeonggon

