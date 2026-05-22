Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 315A8CD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 16:30:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BC346B00B1; Fri, 22 May 2026 12:30:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56D3C6B00B2; Fri, 22 May 2026 12:30:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AA506B00B5; Fri, 22 May 2026 12:30:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3C0866B00B1
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:30:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D8C5EA0AAE
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:30:44 +0000 (UTC)
X-FDA: 84795594408.16.8776C53
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf18.hostedemail.com (Postfix) with ESMTP id E59481C0009
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:30:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="LMxJgL/e";
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779467443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gKpPpe4GL/AF8/K5ETy+5C0gs61AGrcVfBSMkf6XxtU=;
	b=wlV0mmVwGQ3F13Iit7Qmljpg0cp3AIPH3POK5Wwbrw4Cg+Wu8QL0POSoHkpsJRNCjzTQqH
	s8RFvKncy5ViQHElHnQhdEA00h34eJ+ZLTCMe4fe6KSUEMPAhm7kFmvSRwDsBGiFlztQjs
	4sp5eDN1WXgMmxDdiw0G/mLyqlamdlQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="LMxJgL/e";
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779467443; a=rsa-sha256;
	cv=none;
	b=gLnx88Cmj6MFS+JHI+av8MSOLNpasyWs+QwiUfPugZQmq/UqytyHtQcxInMS++y8kM8ZVg
	ImsG1rSok2GC6lbHZ51SPCYROTeJ2KH1LEmBWXR7TIl7SspMiINYCKGs4uTmLwjRXFkHCa
	qIY+rNd2j0xKHQOAlKrGl9FoDGe7STQ=
Date: Fri, 22 May 2026 09:30:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779467441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gKpPpe4GL/AF8/K5ETy+5C0gs61AGrcVfBSMkf6XxtU=;
	b=LMxJgL/e+Zm5EdDJJwMV83A0V58TmvF+e9XMAAv62o9k9aHtpJuQzajDHm2KAbNM8GW+3+
	ixc0GBsVZeK4BzdTl/r2qNh+OWUPHnAOzbDW+UTocrK2zdDXdwIKs/nXep3SJy2ZIK/7hx
	MO4H+bja785IzMZyZEYan7pDBkMCwxI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Alexandre Ghiti <alex@ghiti.fr>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Harry Yoo <harry@kernel.org>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH v2 2/4] memcg: uint16_t for nr_bytes in obj_stock_pcp
Message-ID: <ahCEfIJWrPLVpYsc@linux.dev>
References: <20260522011908.1669332-1-shakeel.butt@linux.dev>
 <20260522011908.1669332-3-shakeel.butt@linux.dev>
 <3eaa3522-b41f-4e69-a260-ebfd94fad722@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3eaa3522-b41f-4e69-a260-ebfd94fad722@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E59481C0009
X-Rspam-User: 
X-Stat-Signature: t4pzx8rmexut8wmpueq4w3kzhpz4epoy
X-HE-Tag: 1779467442-564751
X-HE-Meta: U2FsdGVkX1+0XZ2snP/Ep3unvu6uGKbF5Ye3M+8YysribaVp3z7pRN+YSs3zqC6A36Rajy8ms5GTzQ5vGRYvusYT76ICDCnz1H+5DrzHps6lYW+Xva/7QhaUMsQ24R+laKxMQnBxtpi9B0KQO/0qPZOZoAkS1wq9vBAnHgdu8n/VdIvt7v2j05JuO+DOttQ7mdLRxmGP3ojWbCYAc7UfoDPxFadEAw3KwGKetGppMTKYvlZke0xNJ+YdEgZOfKQcoLStnzdptxasWZ3vh9QyWVd76MKHC3IbOz+a7JSlh898UcLc/6sIDUTK3wEp91DmmjXs9lDp19mM3KbB8cpetKNdIwprZV3P0DD1zDYCvqots/0l0FbH4tnQN2U89REIZWakCYfhDgdSnMn9ZhSI7sSHBmvrP5xlGBwdURmdOeUk/h9aUuZt8TAUONlER7krf0FsqPe5NR/OYJCrqi8jxS5l4hZBKCvrS6aJTngF/pbojhCbphVWbivLRVxdbI/EP/RRFkOtRdmEAKRMnXfem6s5ejLpq859j7qVspbDm3SxuBc2qsOGKfbhUHkjK0k7ADMq4r972yDXE/hz3eahoukMdsGrqZxnqtw91ihkOmCVa+eMUy5RsNcasfGMwfTIcpDsZMxC3uNqE2Z/UZvdeukRk7KhtYLjEX5ph7H2DNnLS2wr015HulEEZWk5c0a4tFov+0uiY7Kem1VKuUqY0lDaF5oIbBigCaJPDO5BSX0b7Nuoa6Av1M0jq8NzeX8RHmPR5tEN5qRAlf+pohihXbtK/tzZ4yBFnzP8FxOie8hnZc1dNrr5Ooa22upUC2ITO6vh26OBdJFmjjtYicCOkVjN/0He1XnUyRto0PG1PlEaoC1WStyNB/ewJxigHMkdjv9en69rDyTT3W0NNFKcXtWKgFupUtfJdhHTg9idXd2LKOYzwbxFyRr13TJ4yHVPePvyuqmOnFcCc5sWglr
 J9Gwm1Bf
 7QB0KGI4s0OUpx1FdjD2v328sgWulHag0YB5ajX/gETwPM2ZGLC2toKqELE+EOZF2cYduzidkPXeHB1QxN2gHBuSqyfcnID0V+aQu5GQNxlRRK5UqRjfm2w8baBD60RamqyvrRKbe7F6NtatlXuqm3dt+fm2OzY1sB6ngxo2oWgYb0EA47YCs6/+V0Gyi7lAlKbTKmbuGwB/vSbO2rK0ZosOMLEE53F8SICwllqdSghuP+dC5oqGYpi+e0R8H17DywC2+HxFJzYldG3zIIYTStg0wC1VFV9SRUGhOto6UWFWt9DI5if+kIsa2dy/97g+JNZ7bfhSWWUwzy0jYjFtAYOZYjbyxm3LT3mJnTVmSFIyD6bLdAlmLuAC4Dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 10:23:31AM +0800, Qi Zheng wrote:
> 
> 
> On 5/22/26 9:19 AM, Shakeel Butt wrote:
> > Currently struct obj_stock_pcp stores nr_bytes in an 'unsigned int'
> > which is 4 bytes on 64-bit machines. Switch the field to uint16_t to
> > shrink the per-CPU cache.
> > 
> > The kernel supports PAGE_SIZE_4KB, _8KB, _16KB, _32KB, _64KB and
> > _256KB (see HAVE_PAGE_SIZE_* in arch/Kconfig). After the
> > PAGE_SIZE-aligned flush in __refill_obj_stock(), the sub-page
> > remainder fits in uint16_t up through 64KiB pages where PAGE_SIZE - 1
> > == U16_MAX, but on 256KiB pages PAGE_SIZE - 1 == 0x3FFFF exceeds
> > U16_MAX. The accumulator also needs to stay within uint16_t between
> > page-aligned flushes on 64KiB pages where PAGE_SIZE itself is
> > U16_MAX + 1.
> > 
> > Accumulate the new total in an 'unsigned int' local, then:
> > 
> >    1. Flush whenever the accumulator would hit U16_MAX. Together with
> >       the existing allow_uncharge flush at PAGE_SIZE, this keeps the
> >       uint16_t safe on PAGE_SIZE <= 64KiB.
> > 
> >    2. On configs with PAGE_SHIFT > 16 (PAGE_SIZE_256KB on hexagon and
> >       powerpc 44x), push any sub-page remainder above U16_MAX into
> >       objcg->nr_charged_bytes via atomic_add before storing back, so
> >       the store cannot silently truncate. The PAGE_SHIFT > 16 guard
> >       folds the branch out at compile time on smaller page sizes.
> > 
> > Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
> > Tested-by: kernel test robot <oliver.sang@intel.com>
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> > ---
> > 
> > Changes since v1:
> > - Collected tags
> > - Rearrange fields of obj_stock_pcp (David Laight)
> > - Fix comparison operator (Harry)
> > 
> >   mm/memcontrol.c | 33 +++++++++++++++++++++++++++------
> >   1 file changed, 27 insertions(+), 6 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index d7c162946719..e4f00a8159d5 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2019,8 +2019,8 @@ static DEFINE_PER_CPU_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
> >   struct obj_stock_pcp {
> >   	local_trylock_t lock;
> > -	unsigned int nr_bytes;
> >   	struct obj_cgroup *cached_objcg;
> > +	uint16_t nr_bytes;
> >   	int16_t node_id;
> >   	int nr_slab_reclaimable_b;
> >   	int nr_slab_unreclaimable_b;
> > @@ -3331,6 +3331,7 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
> >   			       bool allow_uncharge)
> >   {
> >   	unsigned int nr_pages = 0;
> > +	unsigned int stock_nr_bytes;
> >   	if (!stock) {
> >   		nr_pages = nr_bytes >> PAGE_SHIFT;
> > @@ -3339,21 +3340,41 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
> >   		goto out;
> >   	}
> > +	stock_nr_bytes = stock->nr_bytes;
> >   	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
> >   		drain_obj_stock(stock);
> >   		obj_cgroup_get(objcg);
> > -		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
> > +		stock_nr_bytes = atomic_read(&objcg->nr_charged_bytes)
> >   				? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
> >   		WRITE_ONCE(stock->cached_objcg, objcg);
> >   		allow_uncharge = true;	/* Allow uncharge when objcg changes */
> >   	}
> > -	stock->nr_bytes += nr_bytes;
> > +	stock_nr_bytes += nr_bytes;
> > +
> > +	/* Since stock->nr_bytes is uint16_t, don't refill >= U16_MAX */
> 
>                                                            ^
> 
> should also be changed to: don't refill > U16_MAX ?
> 
> Otherwise:
> 
> Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks. If I send a new version, I will fix this otherwise I will ask Andrew to
fix this inplace.

