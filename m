Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7598CCCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 13:17:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE4FE8E000E; Mon,  6 Oct 2025 09:17:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABCD78E0002; Mon,  6 Oct 2025 09:17:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F9CA8E000E; Mon,  6 Oct 2025 09:17:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9107C8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 09:17:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1D347C05AD
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 13:17:58 +0000 (UTC)
X-FDA: 83967742236.02.796118D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 73D1F8000C
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 13:17:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YHC8teFn;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759756676; a=rsa-sha256;
	cv=none;
	b=v682ynh1YXInlDvZcNutxSMLduRuPMuGSGiIlkFJxUoZcnx5sjJhGcp7QLfhagEsyus1jr
	udfmE8drY/NSiPHABW/upmWf8tnqicZzROkJJnNdoV3u/MPtw3lMA08BiAiYXKiNb6g6J6
	OEtdnWJyR5bE2MjPORToU3uvwnn2dXE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YHC8teFn;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759756676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ri2DELPIwhaBKWXFIOC1/rmQDv00iRt2WIKKCb24pLE=;
	b=uKWDxiKl2wuraV+bUVBUT4QlEBadbEXYIK32y18czN3ZwnceMwmvwFmGyip5rifCIRg+ZK
	1sQth1odHs7pqpeTefG39dd4+Rk2TXfUssF1n+G8eTAjFrc5drpGxp0IOj+h9tckk9Zs29
	kuHXwYLaD5nH0IDa/FdBHkd0ZLbaXHY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759756675;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ri2DELPIwhaBKWXFIOC1/rmQDv00iRt2WIKKCb24pLE=;
	b=YHC8teFnm6p8kqSZP0+Vy++TyieoV68Q2Dw+F6l2Al1MPXHHhzcrjNvierr1yeWduYQlzq
	1UK61OnfYu8T6QaadPBgNWKkwAN1nFn0oJ1Z1DhCLosjCr+Q4zT22CItr6L9Exge7x/Lt3
	ysVEIhkYFaakvL5WbVXCDP8+LLZPgQU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-359-d1HY6wbQNOOKqh6vD3C4TA-1; Mon,
 06 Oct 2025 09:17:52 -0400
X-MC-Unique: d1HY6wbQNOOKqh6vD3C4TA-1
X-Mimecast-MFC-AGG-ID: d1HY6wbQNOOKqh6vD3C4TA_1759756671
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C07F8180057A;
	Mon,  6 Oct 2025 13:17:50 +0000 (UTC)
Received: from localhost (unknown [10.72.112.24])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 872961800446;
	Mon,  6 Oct 2025 13:17:49 +0000 (UTC)
Date: Mon, 6 Oct 2025 21:17:44 +0800
From: Baoquan He <bhe@redhat.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v3 09/10] mm/vmalloc: Update __vmalloc_node_range()
 documentation
Message-ID: <aOPBePFxNk5FP/ru@MiWiFi-R3L-srv>
References: <20251001192647.195204-1-urezki@gmail.com>
 <20251001192647.195204-10-urezki@gmail.com>
 <aOCejd0aghFS8iSO@MiWiFi-R3L-srv>
 <aOCqSrnazd2YwGbe@MiWiFi-R3L-srv>
 <aOOUlW0SbBcPM6Mq@milan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOOUlW0SbBcPM6Mq@milan>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Stat-Signature: suwz9ozrx1yshpkaoqghxsbhg5cqtq5r
X-Rspamd-Queue-Id: 73D1F8000C
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759756676-793880
X-HE-Meta: U2FsdGVkX183dQmCONN5V7Ndu6Ay0SbivcIKEq1atF2xptNMlvYgYATX0/7RJ37BqIIhiloRpK9tjFEwhiRmaDCHqDxn1DNK7AW+VjvSYpdIEEhc7GA268a5a8653SNpYdFgIMwiKRwQ6c2/1v/PqNTzZA98ttsBcDVhJ6ofOl2JwcpKNU+Ab2IGIzidPRlR1CaBOShEf1bsBZtlfkZ+efzAaLme3pJxhD6/8hOPaBV1J8bA2VPFB+SGnx47Eq5kUdIwjAc5k/jUo0j5tm6xgcaRHofsSeFL5aqdV6RXGmcuAX2b1VCmeJBtn4KklQtkrp7FRkalBjbojhApvS6ffpBJSC0zrIzX/lemyPWdJKMsyZ9VlZqN4FXuTEEXhuUBG+YiRvVNVL2SggtEDtjvK43hMeR7vsgYM1Thr6JKNIxL126Z4RCwzDeNTxm9uUpaI+ze5UwEwSSbcU6hL0TOpQkolwRn+4LBM+DvLtI5GR5th3wN1mBgnSlWib8v0pKF8dzi13D+dYAv/D8wkBDIVC8mhmpyREuFwqmigAPRoKi57hJgN+I1YELXQmCZKL4OAZovs4CmvQYT2gHs+QjkvcQXotueTg5iUO8E/snuw2X/8quXOmw6L62Jbr7ieQ0U2wycBtx517AoEz9CGNbcZRTtlR552PFWrQwQQKj0toIdlS74cEOB/DuMwd4Dgj1139puKFVhciLPw7bXAPpG32/1HBgGS6k49/yEetIlQ/RQj4BAxFL3MjfVA0oLGRt37r1qwttr+ZMuhTEzwoNh2XwBFbP6c2+TkWysClBeRlNvKWIsFySNwo6o66E7LiMZogvSZcQ1vE3g0FqKU2zMJ0xPGQ914Kr5Q1LpXGhDQq1BurpRvws7B7tZMn2EaOuJoNKTJJ6P7iGsEd7alXjIFUq+58eXNdKh3j27VygqV+MfHeYmCCm1+pgKQYK6TPmGueyqF2t9C0BkhARvn9s
 qu2yy0Fy
 eWoDTp9qtkFqUcPIAMlyDzXDcOvYbSni5ZYVAdZTbpTm20g7piAY+jAVtjzr2ChZB4lnf76QZWS/N6SN2PJPzTiuxKvu4Rg7CE6dvg+xqdtfQykI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/06/25 at 12:06pm, Uladzislau Rezki wrote:
> On Sat, Oct 04, 2025 at 01:02:02PM +0800, Baoquan He wrote:
> > On 10/04/25 at 12:11pm, Baoquan He wrote:
> > > On 10/01/25 at 09:26pm, Uladzislau Rezki (Sony) wrote:
> > > > __vmalloc() function now supports non-blocking flags such as
> > > > GFP_ATOMIC and GFP_NOWAIT. Update the documentation accordingly.
> > > > 
> > > > Acked-by: Michal Hocko <mhocko@suse.com>
> > > > Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> > > > ---
> > > >  mm/vmalloc.c | 21 +++++++++++----------
> > > >  1 file changed, 11 insertions(+), 10 deletions(-)
> > > > 
> > > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > > index d7e7049e01f8..2b45cd4ce119 100644
> > > > --- a/mm/vmalloc.c
> > > > +++ b/mm/vmalloc.c
> > > > @@ -3881,19 +3881,20 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
> > > >   * @caller:		  caller's return address
> > > >   *
> > > >   * Allocate enough pages to cover @size from the page level
> > > > - * allocator with @gfp_mask flags. Please note that the full set of gfp
> > > > - * flags are not supported. GFP_KERNEL, GFP_NOFS and GFP_NOIO are all
> > > > - * supported.
> > > > - * Zone modifiers are not supported. From the reclaim modifiers
> > > > - * __GFP_DIRECT_RECLAIM is required (aka GFP_NOWAIT is not supported)
> > > > - * and only __GFP_NOFAIL is supported (i.e. __GFP_NORETRY and
> > > > - * __GFP_RETRY_MAYFAIL are not supported).
> > > > + * allocator with @gfp_mask flags and map them into contiguous
> > > > + * virtual range with protection @prot.
> > > >   *
> > > > - * __GFP_NOWARN can be used to suppress failures messages.
> > > > + * Supported GFP classes: %GFP_KERNEL, %GFP_ATOMIC, %GFP_NOWAIT,
> > > > + * %GFP_NOFS and %GFP_NOIO. Zone modifiers are not supported.
> > > > + * Please note %GFP_ATOMIC and %GFP_NOWAIT are supported only
> > > > + * by __vmalloc().
> > > > +
> > > > + * Retry modifiers: only %__GFP_NOFAIL is supported; %__GFP_NORETRY
> > > > + * and %__GFP_RETRY_MAYFAIL are not supported.
> > > 
> > > Do we need to update the documentation of __vmalloc_node_noprof()
> > > accordingly? I see it has below description about "Retry modifiers"
> > > where gfp_mask is passed down to __vmalloc_node_range_noprof() directly
> > > but have different description. Not sure if I missed anything.
> > > 
> > > ===
> > >  * Retry modifiers: only %__GFP_NOFAIL is supported; %__GFP_NORETRY
> > >  * and %__GFP_RETRY_MAYFAIL are not supported.
> > > ===
> > 
> > Sorry, I copied the wrong sentences. Below is copied from documentation
> > of __vmalloc_node_noprof().
> > ====
> >  * Reclaim modifiers in @gfp_mask - __GFP_NORETRY, __GFP_RETRY_MAYFAIL
> >  * and __GFP_NOFAIL are not supported
> > ====
> > 
> > 
> > > 
> > > >   *
> > > > - * Map them into contiguous kernel virtual space, using a pagetable
> > > > - * protection of @prot.
> > > > + * %__GFP_NOWARN can be used to suppress failure messages.
> > > >   *
> > > > + * Can not be called from interrupt nor NMI contexts.
> > > >   * Return: the address of the area or %NULL on failure
> > > >   */
> > > >  void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
> > > > -- 
> > > > 2.47.3
> > > > 
> > > 
> > 
> We need. But i am not sure it should be fully copy-pasted from the
> __vmalloc_node_range_noprof(). At least __GFP_NOFAIL is supported
> and thus stating that it is not - is wrong.
> 
> It has to be fixed but not by this series because when __GFP_NOFAIL
> support was introduced the doc. should have to be updated accordingly.

Maybe just remove the documentation for __vmalloc_node_noprof() since
it's only a wrapper of __vmalloc_node_range_noprof()? Surely this should
be done in another standalone patch later.


