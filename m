Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6549EC88E73
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 07:42:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D0576B0088; Tue, 15 Sep 2026 03:42:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 381DC6B008C; Tue, 15 Sep 2026 03:42:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29DD46B0092; Tue, 15 Sep 2026 03:42:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08AAB6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:42:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1C81E802F9
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:42:16 +0000 (UTC)
X-FDA: 85215203472.28.EF5E509
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf20.hostedemail.com (Postfix) with ESMTP id B96B71C0005
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:42:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789458134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MHtEgKijEy5QaF+aPuLhigQXKl7vWw+ZK5ig6sWkJF8=;
	b=OaxDjXNQGJa6NIh7Uf+rPE2uC1XXI9nQMSt8n30mwLd+GraDYoPwZfIhDP55rbX6RvdnHQ
	ZW0Fp2/6woVxLcuTaemH5KOVV1HG99fySWT4C/5JOQ0v0pygiXkW4mNmN+T9ngVjpVs6rL
	oNjsaoII177EZvs3DqqFsDrxV7Gk/fM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789458134;
	b=vODoql72zvWeLiJjzE6TwY4VFc156WHuh4pRegKCyxrE9XFw/loEeaNyBvevLdAn/+kvzZ
	1/Yf1eC/jYEKeJhG0o/wM+G4g4TH2EPi35RDbtGKS+phcsCbXOSk3oUsc95ZwvxT/srE5g
	3L8uHzvFBnbEpy4xqECBo2oLKXrHdqY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
X-UUID: f28fd274b0d811f19a56ed5b684f684d-20260915
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:b152c5bd-7a2f-4ada-813a-7530dbb6c21a,IP:0,U
	RL:5,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:c92542d2913318dabd5ee757778a38e8,BulkI
	D:nil,BulkQuantity:0,SF:80|81|82|83|102|865|898,TC:nil,Content:0|15|50|99,
	EDM:-3,IP:nil,URL:99|11|95|82|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,CO
	L:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f28fd274b0d811f19a56ed5b684f684d-20260915
X-User: liuqiqi@kylinos.cn
Received: from kylin-pc [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <liuqiqi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 281404417; Tue, 15 Sep 2026 15:42:05 +0800
Date: Tue, 15 Sep 2026 15:42:02 +0800
From: Qiqi Liu <liuqiqi@kylinos.cn>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev,
	hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/page_alloc: apply per-task GFP context in bulk
 allocator
Message-ID: <20260915074202.GA246486@kylin-pc>
References: <20260914080451.294896-1-liuqiqi@kylinos.cn>
 <b932c690-7ab0-4521-a7d2-5ed5130379b8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b932c690-7ab0-4521-a7d2-5ed5130379b8@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B96B71C0005
X-Stat-Signature: ppj8fricqmhxdq77rypcaho4xjhptidy
X-HE-Tag: 1789458132-230236
X-HE-Meta: U2FsdGVkX1/GE5ZXEZID/e1uWFT8OokftxzRxoPnZm8sZpCRDPu/K235hv7FMGuTj4InEszuq+ghGrQ+13X51TBqC77vPg2vEEylQwmLFJfeOpQk6o4iwxn5MZEKErjuR5cYoXNfWbOS/vLuhm3OCutVki8ll4UjGirioLHFsOse3d2FBl6yw1vDFxB0OzaUsZ0ptKTNfw+qnC8bhrtMguMNdw7JjiY2FdYk010FPcnXei7oLF8pUkhy9oxh0TfB7K4zZxGMvGq3oIhxG/z+x1fJiphKdRuzJFujYEU/YfFaFewneHQ51RMKfDvkemasfOJKxa/Mh+jc1ZrU4xdKIu7bW5quW7UmmYrh97/mBIRhDXLn1IobD3tQV1QU7lbJUoIZsumXVewMNbmu0tZFcKe/IlSzqRZEBDvbWwQc/KYKKbUBoqYj0khdeCd0N4+QSang9E6o8GGpECWQyeEhbDG7d0dQ968xYjVH+I/+vBDuJwUzSAw3ZMzxGEM3SeFMQThLvXeVXxNKh5wofDYCZyR3vAg+wNaS8L2UgKuxG+QOdxaueYuUHTMOzNzrGQqdIF1ROl4A2PwV96RJlK1xWV2dR0gFJvTUml2OQHppA2HUPHuybn4yslBHFoboChrPdHd67akkaFKPS9qFWJ3DpZDvskJRRNUZ3yn/0kb3RbvUzFLec1H4EFM039MaLLyuAHoYDLTKArC4DaTYDH9i0rMQSQv2Kg0k9pzD/tStBpAvZn3VjB7v8BoPTzOZwm/CZaKFys6GTk+hrqNr/LMZaXngZ3wG60USsekPYc8MKaYJg6rno2IeInkA4SriqPJecag1GDyoxU6Stc82xG8XcKm1YlmikzegAdItHgduwHiNf3Z1KzraMblet0XbdIfuiQQVhaaGZ0aSdNfUbJrTMY/EsB6TsbhVT1hGucpthdiij0w+JR3ealVdskuTHenVa3XFr75jhrS86vVZ00Q
 XMtYDLXT
 wlaRzZF+FbyEfnavd07pLeQZm09pDYaiM9rqMNhgNr+0m1v/n9dQcXfwgAmx5rRRG62ore87Di+KP0H6+3pKpvv510tWBzPjKbkVFWYfG5qG0JwzVeSJICQzWpqRuKQ7omp100POC89yZvSKjgESNrH2vREs81ZkqGOkDQc9Eakx1oIM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the suggestion. I'll fold this into the commit message and send v3.

Best regards,
Qiqi

On Mon, Sep 14, 2026 at 03:01:14PM +0200, Vlastimil Babka (SUSE) wrote:
> On 9/14/26 10:04, Qiqi Liu wrote:
> > alloc_pages_bulk_noprof() does not call current_gfp_context(), so
> > per-task scoped allocation constraints (PF_MEMALLOC_NOIO,
> > PF_MEMALLOC_NOFS, PF_MEMALLOC_PIN) are not applied on the bulk fast
> > path.
> > 
> > The most direct consequence is PF_MEMALLOC_PIN: without clearing
> 
> I'd say ignoring PF_MEMALLOC_NOFS/PF_MEMALLOC_NOIO also can have a direct
> consequence?
> 
> Let's replace the line above with:
> 
> By ignoring PF_MEMALLOC_NOIO and PF_MEMALLOC_NOFS, the allocation can
> theoretically result in a deadlock.
> 
> Ignoring PF_MEMALLOC_PIN also has consequences: without clearing ...
> 
> > __GFP_MOVABLE, prepare_alloc_pages() selects MIGRATE_MOVABLE for
> > the PCP list, and a task with PF_MEMALLOC_PIN set receives movable
> > pages from the bulk allocator.  Once pinned, these pages can no
> > longer be migrated but remain in MOVABLE pageblocks, violating the
> > mobility contract.  This can increase fragmentation and interfere
> > with compaction or contiguous-memory allocations, eventually
> > surfacing as higher allocation latency or allocation failures under
> > memory pressure.
> > 
> > Found via review of the bulk allocation tracepoint hooks [1].
> > 
> > [1] https://lore.kernel.org/all/20260907120949.418450-1-liuqiqi@kylinos.cn/
> > Link: https://sashiko.dev/#/patchset/20260907120949.418450-1-liuqiqi%40kylinos.cn
> > Fixes: 387ba26fb1cb ("mm/page_alloc: add a bulk page allocator")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
> 
> LGTM.
> 
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 
> > ---
> >  mm/page_alloc.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 12fac9084c48..3be7288a1aa7 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -5207,6 +5207,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
> >  
> >  	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
> >  	gfp &= gfp_allowed_mask;
> > +	gfp = current_gfp_context(gfp);
> >  	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp, &alloc_flags))
> >  		goto out;
> >

