Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7BCFCAC5B0
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 05:02:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10C698E0005; Sat,  4 Oct 2025 01:02:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E4928E0002; Sat,  4 Oct 2025 01:02:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 020D58E0005; Sat,  4 Oct 2025 01:02:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E11CF8E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 01:02:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8C452881F7
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 05:02:19 +0000 (UTC)
X-FDA: 83959235598.29.517D309
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 821D8C0015
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 05:02:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CaJtdD4O;
	spf=pass (imf10.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759554137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Fi8ohMDCZZaoOzqYB+KAWWzm8L5357GBKGgTQreZfQ=;
	b=z2U4FaoJkktwf7WE/YFp4zmacPYxoALNE77qYLm1YgqXk0yvtdRBYSLdWzBpNKEvh6uBlk
	WrTCh8ny83vQTKuJLEObwDE8O1N21DCAxRZfhzDQ3cHA7WpFbvLUgrXtGugGDOVBooxUYZ
	x7AaaY4SJY2C7Za7u6x5Iarke02XGmw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759554137; a=rsa-sha256;
	cv=none;
	b=7b2G1/dVIvTNsHU4J3roie4XySo1G9MWepLJpKBItKyT3HZxLeFKTm1BnZ50zGWzHMddKu
	3STwhkbP8GjJSNfg/CjGOuHQTfr66Tb38BYlCtzSI89YOpgNmgwhlUg/YtMfmd+bMfaqrd
	O5WWKsnIYj06ZfU3EMwejJ8zDW0zQGU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CaJtdD4O;
	spf=pass (imf10.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759554134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1Fi8ohMDCZZaoOzqYB+KAWWzm8L5357GBKGgTQreZfQ=;
	b=CaJtdD4Ovx2M9yvnWN1+8LmDMPaYkNQ6UjOg2mXhK7xP4QTegXGz47KKM1W8Ou6asPBJJ1
	+7RxzbBLaPZGXE9M5CF6MNOc4vMGZWw5HhrQHO9u4KIamRse65X7U9mEF86bvLqZm0t0Ws
	QBg1Ry+hQEsVSXUr6rO46ZpDaZk9sPM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-214-3m9Wgzl7NXe26kQtiArzcQ-1; Sat,
 04 Oct 2025 01:02:10 -0400
X-MC-Unique: 3m9Wgzl7NXe26kQtiArzcQ-1
X-Mimecast-MFC-AGG-ID: 3m9Wgzl7NXe26kQtiArzcQ_1759554128
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0AEBF18004D8;
	Sat,  4 Oct 2025 05:02:08 +0000 (UTC)
Received: from localhost (unknown [10.72.112.27])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CDC6B1955F19;
	Sat,  4 Oct 2025 05:02:06 +0000 (UTC)
Date: Sat, 4 Oct 2025 13:02:02 +0800
From: Baoquan He <bhe@redhat.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v3 09/10] mm/vmalloc: Update __vmalloc_node_range()
 documentation
Message-ID: <aOCqSrnazd2YwGbe@MiWiFi-R3L-srv>
References: <20251001192647.195204-1-urezki@gmail.com>
 <20251001192647.195204-10-urezki@gmail.com>
 <aOCejd0aghFS8iSO@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOCejd0aghFS8iSO@MiWiFi-R3L-srv>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Stat-Signature: nqzqw4i6pjhz6a99thenz78qwm76hphx
X-Rspamd-Queue-Id: 821D8C0015
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759554135-515733
X-HE-Meta: U2FsdGVkX1/zGKk10cPkTIuIUqPfL4DdPgmyT9mpxKiHwHTpp0juelpZiB5gzR6/e+zC/tL7wsHfNq+zdR9XOddCgR0h7q0Dpl9q+jZY10jjExDkXecyC1RFUFXQUgovgMgaSTc6KnntNE7YIkNcrgPgV7dZDxPr5wjezETkfqouDK3g1Gaym7cq37VgYfkYmtPlVJUOzq8l8thUdLMNeon1M1rw5s+GNpmUOP/rKsvf2a6A0liIjSz7E2GSj/7kYEM6/nEUzsK8Sk2Y7zYMR5DCCBFPjkq4PknxUpJCT3iNi5RshCvXy8ub0EVS+8zCJKviRGNOe2suAGApASvEUfmsr31cqHOuKIZL7qBs0itZufsEDbW9kcjJ3l8O4hOB+hfRywNPR9Ll3USzqLQhTKst6MHYYJyaQetyek3+pYsxki49Dg1t+9ybjZ265m5jQg7myU+MbfM5cIupS7r0aAEhZquOg4gD3EJ9qsH0Sr9wVElS5bg52HA2y2XCohQ1AQruUG5+ed8NYoZi8eMEta0TvxsEcSpo7hz0l+ujjLM5474shIPQcUgoWf3L4TE8AdEqE+ATW0iaZQ8yzwomWWZhOEBlphRfKMMdg1ZheDrncvSZ2sPCISzBHsojLHSKygjxJUYPmDb5vJSSr3VBejrCwYC04vmOnBtgOMwPVannsVb3FS3+QWQzJPx1asPqJ+aQsyEQKBCy67ON/f1DIiMzI7/toZJE/IhhNJwy3yADR1ueCO9Z3LCA8YlMIC1OuQVdwAQh+Cb7jVrmzsSNMbsTKsvWa5TWl7BkI7jdtt2cUv/J5U0LLz1u9jnPnWj8AMY3XH+o/8Hq705WI54bDTvLE7N+ND3pvduh1gickZAMzqGNlRIMtriIwKij7wgNx8387KPDVZR3XmNAaoSwJznYONAtYzPuW31Wxck6OIJj2kHrUX9hgHFiBnn6GnspLRvvCRCbnArFuCiZDWz
 w4+Wx2Pl
 c7eAhZTTaMBI2JSznr4eivMlH10mTdeWtpw6hmD+M1fLXgSyVHWUDERCeNzxxC2Uf5pw668TVlQJ6irf9Sg3thGSvyDIwteeknLiY+NmyK8bJSK/dpUF6rmNETgTyO5MvHk+L+blfRahdWZXBlHm9TvG2G0Cf2YuikuramX0EQY4yjfYRvQmJu5hFhtt/2mZ/anGcbfEq2E6EuAFwo9PBqylSSvFSQM7VMoED84B5ty6QFALR/pZYfD9MalesqDzybCSSk8TKnDu79+XPOJ8NoDXuVjQCKQBsimSCMlW/dilIZgjYYS+61ZjvJu4gpG2JS5wnqdTCgtqCHKOs8vOJiCe06LtckIv9Ge4GnyTeK/uLbISl+bkG7NPczUxaJSUcRQpAMMrW/fiZNOXWitfSsO4xgREVEbGfIY54tjxYkmd1AGapS2FRRXUs20ltggQmhU6P35Hux30NEkU3ni2Pm2SWpXI9y6zsT/pry5yophLt4wqm64RA/o1NbAueL8PerNmS8kE0/Swq8xPqbV4Rvzc28Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/04/25 at 12:11pm, Baoquan He wrote:
> On 10/01/25 at 09:26pm, Uladzislau Rezki (Sony) wrote:
> > __vmalloc() function now supports non-blocking flags such as
> > GFP_ATOMIC and GFP_NOWAIT. Update the documentation accordingly.
> > 
> > Acked-by: Michal Hocko <mhocko@suse.com>
> > Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> > ---
> >  mm/vmalloc.c | 21 +++++++++++----------
> >  1 file changed, 11 insertions(+), 10 deletions(-)
> > 
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index d7e7049e01f8..2b45cd4ce119 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3881,19 +3881,20 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
> >   * @caller:		  caller's return address
> >   *
> >   * Allocate enough pages to cover @size from the page level
> > - * allocator with @gfp_mask flags. Please note that the full set of gfp
> > - * flags are not supported. GFP_KERNEL, GFP_NOFS and GFP_NOIO are all
> > - * supported.
> > - * Zone modifiers are not supported. From the reclaim modifiers
> > - * __GFP_DIRECT_RECLAIM is required (aka GFP_NOWAIT is not supported)
> > - * and only __GFP_NOFAIL is supported (i.e. __GFP_NORETRY and
> > - * __GFP_RETRY_MAYFAIL are not supported).
> > + * allocator with @gfp_mask flags and map them into contiguous
> > + * virtual range with protection @prot.
> >   *
> > - * __GFP_NOWARN can be used to suppress failures messages.
> > + * Supported GFP classes: %GFP_KERNEL, %GFP_ATOMIC, %GFP_NOWAIT,
> > + * %GFP_NOFS and %GFP_NOIO. Zone modifiers are not supported.
> > + * Please note %GFP_ATOMIC and %GFP_NOWAIT are supported only
> > + * by __vmalloc().
> > +
> > + * Retry modifiers: only %__GFP_NOFAIL is supported; %__GFP_NORETRY
> > + * and %__GFP_RETRY_MAYFAIL are not supported.
> 
> Do we need to update the documentation of __vmalloc_node_noprof()
> accordingly? I see it has below description about "Retry modifiers"
> where gfp_mask is passed down to __vmalloc_node_range_noprof() directly
> but have different description. Not sure if I missed anything.
> 
> ===
>  * Retry modifiers: only %__GFP_NOFAIL is supported; %__GFP_NORETRY
>  * and %__GFP_RETRY_MAYFAIL are not supported.
> ===

Sorry, I copied the wrong sentences. Below is copied from documentation
of __vmalloc_node_noprof().
====
 * Reclaim modifiers in @gfp_mask - __GFP_NORETRY, __GFP_RETRY_MAYFAIL
 * and __GFP_NOFAIL are not supported
====


> 
> >   *
> > - * Map them into contiguous kernel virtual space, using a pagetable
> > - * protection of @prot.
> > + * %__GFP_NOWARN can be used to suppress failure messages.
> >   *
> > + * Can not be called from interrupt nor NMI contexts.
> >   * Return: the address of the area or %NULL on failure
> >   */
> >  void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
> > -- 
> > 2.47.3
> > 
> 


