Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06EBBC624DA
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 12:03:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 231E86B0088; Sun, 22 Feb 2026 07:03:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B58B6B0089; Sun, 22 Feb 2026 07:03:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C1EB6B008A; Sun, 22 Feb 2026 07:03:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E82AA6B0088
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 07:03:28 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EEB8D1A063E
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 12:03:27 +0000 (UTC)
X-FDA: 84471957654.19.756BCA4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id DCFD618000E
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 12:03:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HpRaxvcc;
	spf=pass (imf24.hostedemail.com: domain of ming.lei@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=ming.lei@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771761806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l+yw+qtv1w/l9LpTV1w9IMNGubX7SibUQexR33hlLcA=;
	b=6EZKjZr8939G7aQeUU9EHPWNOLu/G1wgUSV0HrNcTHeOcLBwQIb71GeuC2argaCAb67tTV
	1ghJvSE5TJutCEiANoGl0ev+CFoIMZ4VeA/F9E3jqAMkn+U6cgX02N8PnUmOUJSm7J4OD5
	qFpfKb0HmAqvL2+l/AGzf2c3ou1I0Pg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771761806; a=rsa-sha256;
	cv=none;
	b=iq8dOM3X6aVyBH1YmQzrgmInx/5UheashQieUWYB05a+wP/92nEVhcWb7pKl7aAE7cfg3r
	Y0/2QNnAD8SZGRDKU57iBSQ1XNFGRHny3zPIWNws4GV0eDppb7zWFy2VxVZ54YGXVN80RE
	le/iwF3AqZEwi9vOKz191m3AFvquMKc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HpRaxvcc;
	spf=pass (imf24.hostedemail.com: domain of ming.lei@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=ming.lei@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771761805;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l+yw+qtv1w/l9LpTV1w9IMNGubX7SibUQexR33hlLcA=;
	b=HpRaxvccTBjauSGXuntIG2cewoTTT1sin/ri6q2g8BhUsn+NwJwmoAJR7QPan/DtqSZSKl
	uk80VNYA9rWtyb9gWW4gk2cqXV0GsEkRtRbEGsT8RNAzpHrQ2rxjKfu/rdk5+xgaSzGIN4
	XnO1QSJtquplibayZciVR/fyNc+LRCc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-104-leSndRU3Nf-XQVbNMtRUig-1; Sun,
 22 Feb 2026 07:03:20 -0500
X-MC-Unique: leSndRU3Nf-XQVbNMtRUig-1
X-Mimecast-MFC-AGG-ID: leSndRU3Nf-XQVbNMtRUig_1771761799
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E4E51956095;
	Sun, 22 Feb 2026 12:03:19 +0000 (UTC)
Received: from fedora (unknown [10.72.116.34])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DDEAF1800465;
	Sun, 22 Feb 2026 12:03:15 +0000 (UTC)
Date: Sun, 22 Feb 2026 20:01:46 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix NULL NODE_DATA dereference for memoryless nodes
 on boot
Message-ID: <aZrwKt8hS5EBn_It@fedora>
References: <20260222054451.3261-1-ming.lei@redhat.com>
 <aZrmxmxyLhm_Cq0Q@kernel.org>
MIME-Version: 1.0
In-Reply-To: <aZrmxmxyLhm_Cq0Q@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: g22oDh-2akTKhk6-iIEiampDc1OFIeK0DQq1QkARIZY_1771761799
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Stat-Signature: cd93ujb18reyti37ggkhh89dbu1cttnb
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DCFD618000E
X-HE-Tag: 1771761805-840902
X-HE-Meta: U2FsdGVkX18INhMXTaKtSUyWZ0rVhbFIpHloPw6gkp5UbrlC4HDWUIGjiIBdouHoxRMO8kKvxyKLA7hIq1kyHmhwY4iw7PPsYAeHaeqYaEutppjYhiaUJ8nV/OBp5M7bUZ0IdgEecyONKxcqkTGUqYMcypcxAWBCSWdkF+Ha0totaAR+IlmZme4+NiR1IFscflq4AE/obPtjYZHpe3/f8LmawzMdQRY4UaQE6AvtxMx9u+hUuUfTWdMBLNOc4XI5Iga9U4WDNPUxI61klrL+0zlrhCcefXV/DnXxbXKCku2LvFnT7HZ6Uuwg1YJntVrXIHkUl4TnkJa1ehSxpfdKkBcMb+Djh1DHgdqzBz5wHpZxW+ziWvwEt12hU7Tb0vgyAJ/qAhahZSwujIYZdJoQmTvD56lx6o92Xmg2D3L8jfUi17UbUZQjLN/uNNdgPeuDI8qxokWakofYtfTIUP1zQtbgoHlyfLmtV60/WoHeI+pr2drYQgztIPtj3Ast9XNZNu2oU8hXwXc4UIIKbMS7zlE1Cwg8VgSabLwjM+rKKmNDfMQWltyfAXxnZd3iDLWZrLwptxiiCwgrqdZk2AnMzT6pA4NML8Z9szjfAD58c32P5L6vslQGvt3bSGM3NvpuI0Fyu2SfKUyUjuny6pTq/6uJIPo/9+h8pZ02ZtPM4yESjdhftcs5Fxiy0HqSo3lYMeYzoPgVR5gcaV1wcEz5VO0bJFRL/qDYMXq2fyUj4kv8OS5ROJsyn/hquzbABjC1fGNhouYextBjD1iqI/D5tbMCcyMqjHp1WS0z3C2ljlZn4/cWb+8AxDMfo9UdGAsJGXeSFJOSujhNvdS30ePEgAGGflErFNSo7LeKCF2dHbOzF/amtgSmSxz7GTbyFwPjiWk3minwhCkiXSMgfg2+ZLC20tBfs4gRvQA/7DK1cHAVT5Q2z7mu937z1JAf1C37TTzxGVj/eyZpoobP1nW
 kDBin5zg
 /gKYc1af/d9rEVs0gnr00QIIX6CpoUSrtuvYID0jTxeHHFeSYhUqsuNZiJ79i9uryJx50Veh4l3AGd+DPE5sf1tbRmqq7kXu9dEF85pwNl+IDEU4SkoAWZd4//os8P0c/tC1NOpSZIgRIVegETgDSzN24KmCCtj1kgVR+5uwF5GHVpFpHpKgl0n814xne5k6sOEz8jxVr6ICrWZYoir7NiivWXUOel5DKVqtBtPxTUx3eg+fEl6mvT0WTKCIIiK3n60y0psm/d8PVc76t7nlBU7cccWRKc7QJFLEX+ekgEpnJ5avf47TZ2teGdHxbeh33DJhnhZmv6o2QN/NCcxGZsQhH8pLuQiZ1yb6TSmxVvhck9RqCpOrl/JZGRIzzAJqmwg+VIsWpuh0C4Ml65ob0qps6DQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 22, 2026 at 01:21:42PM +0200, Mike Rapoport wrote:
> Hi,
> 
> On Sun, Feb 22, 2026 at 01:44:51PM +0800, Ming Lei wrote:
> > Commit d49004c5f0c1 ("arch, mm: consolidate initialization of nodes,
> > zones and memory map") moved free_area_init() from setup_arch() to
> > mm_core_init_early(), which runs after setup_arch() returns.
> > 
> > This changed the ordering relative to init_cpu_to_node() on x86. Before
> > the commit, free_area_init() ran during paging_init() (called from
> > setup_arch()) *before* init_cpu_to_node(). After the commit, it runs
> > *after* init_cpu_to_node().
> > 
> > On machines with memoryless NUMA nodes (e.g., node 0 has CPUs but no
> > memory), this causes a NULL pointer dereference:
> > 
> >  1. numa_register_nodes() skips memoryless nodes: no alloc_node_data()
> >     and no node_set_online() for them.
> >  2. init_cpu_to_node() sets memoryless nodes online (they have CPUs)
> >     but does not allocate NODE_DATA.
> >  3. free_area_init() checks "if (!node_online(nid))" to decide whether
> >     to call alloc_offline_node_data(). Since the memoryless node is now
> >     online, the allocation is skipped, leaving NODE_DATA(nid) == NULL.
> >  4. The immediate "pgdat = NODE_DATA(nid)" dereferences NULL.
> > 
> > The crash happens before console_init(), so no output is visible without
> > earlyprintk. With earlyprintk enabled, the following panic is observed:
> > 
> >  BUG: unable to handle page fault for address: 000000000002a1e0
> >  Oops: Oops: 0000 [#1] SMP NOPTI
> >  RIP: 0010:free_area_init_node+0x3a/0x540
> >  Call Trace:
> >   <TASK>
> >   free_area_init+0x331/0x4e0
> >   start_kernel+0x69/0x4a0
> >   x86_64_start_reservations+0x24/0x30
> >   x86_64_start_kernel+0x125/0x130
> >   common_startup_64+0x13e/0x148
> >   </TASK>
> >  Kernel panic - not syncing: Attempted to kill the idle task!
> > 
> > Fix this by checking "if (!NODE_DATA(nid))" instead of
> > "if (!node_online(nid))". This directly tests whether the per-node data
> > structure needs to be allocated, regardless of the node's online status.
>  
> I believe that this change is fine for !x86 as well, but it deserves a
> sentence in the commit log.
> 
> > Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Fixes: d49004c5f0c1 ("arch, mm: consolidate initialization of nodes, zones and memory map")
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  mm/mm_init.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mm/mm_init.c b/mm/mm_init.c
> > index 61d983d23f55..9d63cab36204 100644
> > --- a/mm/mm_init.c
> > +++ b/mm/mm_init.c
> > @@ -1896,7 +1896,7 @@ static void __init free_area_init(void)
> >  	for_each_node(nid) {
> >  		pg_data_t *pgdat;
> >  
> > -		if (!node_online(nid))
> > +		if (!NODE_DATA(nid))
> >  			alloc_offline_node_data(nid);
> 
> A comment that says that if an architecture didn't allocate node data, we
> presume that the node is memoryless and offline would be nice here.

Hi Mike,

All are addressed in V2:

https://lore.kernel.org/linux-mm/20260222115702.3659-1-ming.lei@redhat.com/

But miss to Cc you, sorry...

Thanks,
Ming


