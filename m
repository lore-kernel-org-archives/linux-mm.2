Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA95ECA0EED
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 08:56:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 504E38E0020; Tue, 19 Aug 2025 04:56:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B5738E0002; Tue, 19 Aug 2025 04:56:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F2B78E0020; Tue, 19 Aug 2025 04:56:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A1948E0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:56:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A927DBA743
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:56:41 +0000 (UTC)
X-FDA: 83792901402.18.8988A54
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id D417440005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:56:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="R5ZUXA/f";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755593799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ibUK4q/Rvy3c7fBEbcTRGpKubTCINpqdPqllT/qlSY=;
	b=zc8LVZ330lwzVXulMqhL5VRqaqIQhEQ4/igStMDmKW9PmGJd+pHltiUc4aF6qrU7wULhZQ
	7dGDlXamaAhDSvYlfFtuvLTHz2riR/0kLkKFuhqCIJwLAQ7MSIzo0T2z1UWFBtFCn7cc9G
	JYmQl2SypI9N15laRAUAQSAidHg/Xgo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="R5ZUXA/f";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755593799; a=rsa-sha256;
	cv=none;
	b=6dXkdxIJoEjxzDGltq7kDH+tq6GPd78RDAq57KglE7dUP2qyG8YDv3JZDdzLd6JEZIbkR3
	FPeoe8QzL3OVxgZhQmM09kIR9VYKD5JrFuP++YGOY3hklRvnrDE1rqypu7KR0BNU9AzWft
	9gRUX8/NWlA0+AaoRHLwjSCeS1yvK4o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755593799;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+ibUK4q/Rvy3c7fBEbcTRGpKubTCINpqdPqllT/qlSY=;
	b=R5ZUXA/fiNxYBsauMyL34+hWZOop05s2otmWc7tYqdOSdbhycdVgAfTaeMCyVnVqymRd24
	QtcW4mrsFiMayBrmp/zdn03Pi2Qw/0QyytQAcT8LUMWVZyI6UkuaxEegO3sMKDvRc+jCV3
	elr7wShVdx1KW594Phg2dR+Rd7BIE18=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-79-1ws7qeZ_Mk-k-aFR6OJIpA-1; Tue,
 19 Aug 2025 04:56:33 -0400
X-MC-Unique: 1ws7qeZ_Mk-k-aFR6OJIpA-1
X-Mimecast-MFC-AGG-ID: 1ws7qeZ_Mk-k-aFR6OJIpA_1755593791
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AB162180048E;
	Tue, 19 Aug 2025 08:56:31 +0000 (UTC)
Received: from localhost (unknown [10.72.112.239])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C2291800280;
	Tue, 19 Aug 2025 08:56:29 +0000 (UTC)
Date: Tue, 19 Aug 2025 16:56:25 +0800
From: Baoquan He <bhe@redhat.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] mm/vmalloc: Defer freeing partly initialized
 vm_struct
Message-ID: <aKQ8OY04a0ACqZ2O@MiWiFi-R3L-srv>
References: <20250807075810.358714-1-urezki@gmail.com>
 <20250807075810.358714-7-urezki@gmail.com>
 <aKKqOzepmIkOJi3i@MiWiFi-R3L-srv>
 <aKMkgbZqOqyGVF1C@pc636>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKMkgbZqOqyGVF1C@pc636>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D417440005
X-Stat-Signature: opiowfybpdzgna8zo5h7qhuoyjja4pso
X-Rspam-User: 
X-HE-Tag: 1755593799-82453
X-HE-Meta: U2FsdGVkX18Pvdvzp8gsifWBB0yja7lVhx1NcLwSlfVHrHoUQE3V5f3IRqS4c5U7a7M2ZlYMPI1gTArPk2p26vWbMLskHuq52k7SyVYDBlE42cRtiiSP42Aq47zqTYLy20okHdSTeEPj2GJcddytAwG5DsqPyJSZGEv9gdR59bbj0U5pWO3Cv3+Z+5C1OOeEqIFwK0FGh3iD0xXv52xbKslYOmDGffGRbo0vYwOewuOPU4xBK5FaLrJ0fv+GiIIvcBa//mGtGUoruQbt7+FQBUTZbA8qzsNYDPLvSsbp1/pAK/YgfzRNNlHa6xMFmGhFhPkGl6H49ibhQ2syPEjgGsWceK5I0LG+uvVYOFBuPj9XtBLVTT4JYNdmzXXq1vmRzB8KcyBHwjmuN9p7x7/lF4sosnmdCIhIldo8XU9cQL9i3hlycuGtC1nV2totQAHN2QALq5pBmAWw4i+eLdXRyW7SIXj1qIkpaNyKpmhm0lpvVdHFBCK1dB4Q3Fkn5JyBxDfJRKTturjNFKWY44lG1GwlDa2bnJHldbIEXrBdNaiLuf+1/KstRzdj2zifcj01NQADbS+WTzsZygpY02T3bcB/Lz4PA79qiYXUx7ifEv970wjytaz6M/aLtv7AXvyR5SEDn8kXRr6gDibmomKlo6t5EJeMD6+psyfotrq11eg4bMicZ8FY4vToX3nxcFF9Se/I/JmFs1bMD1F94ZVyQkZBz/wCCcuna06O3PJ5OiSn+c/iAk72GmG+Cl7piCtLU7n4kkF9Vrl1rWEQpNDBaW+ErEHKVXW3but267BOrCq3tP9/BRxBebuOPfZzQobzEEL1s+Hq6lUoctWDYym36X2s8wDLWEiCqrpgp63eecrkZE6d0f6YSu6gfLxrBq/aEc0qEMBI0jXOCBJKDyRrpTzqfE3108iAFLfnwA/mJmnGUwoGvCIGdy0cbS/ttTDedWcQYx5dpADUisfHbnS
 oKSOjWfC
 DJi1poMfbT9iVvwhmYj+7XlL1TIdGf8pK9Ii0U+mYE3IhGavps63MruG2UJ4eVsjl6EYlN5FZycAL1+3OH6qnoosWn+lSnCkPXtp3G3090Q782HtIthuMGSOGxua1QHc5KOBewvtIGdpOvQJilnifCef3jhDNJYtkhuhItIM0V14Y7V7MBLPx2fnX6voERRJ4jlWdNlynuLaPojlT0tXWVEHkYGvPe5UCxTRRcupWBbDWVcKLngVh4NYRnGMhkQICX0L1vfV0idT2nVa1Uds4uj44pztUo7XQ0ugOBTNm+PUO/Ww3XtnuheF/wTFn0vCg/4Hh55WyOWL3AyVtauytCAlkV0EYsKg/qSzjy9ONmYLDhkIJF6Peip6wRC+1R4Sif6oQQVm9jlLZTsbs7aLPue2MxMpO3ywRKHqbABQ9T1vodK6IzJiA5lRmxmmvaamxJXiSseiI7XLfgeAimcU+Xb/V7rZzqOLIwdPc3NC+OlpKeWaTzsqQYBHGD3frT7ctv4LC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/18/25 at 03:02pm, Uladzislau Rezki wrote:
> On Mon, Aug 18, 2025 at 12:21:15PM +0800, Baoquan He wrote:
> > On 08/07/25 at 09:58am, Uladzislau Rezki (Sony) wrote:
> > > __vmalloc_area_node() may call free_vmap_area() or vfree() on
> > > error paths, both of which can sleep. This becomes problematic
> > > if the function is invoked from an atomic context, such as when
> > > GFP_ATOMIC or GFP_NOWAIT is passed via gfp_mask.
> > > 
> > > To fix this, unify error paths and defer the cleanup of partly
> > > initialized vm_struct objects to a workqueue. This ensures that
> > > freeing happens in a process context and avoids invalid sleeps
> > > in atomic regions.
> > > 
> > > Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> > > ---
> > >  include/linux/vmalloc.h |  6 +++++-
> > >  mm/vmalloc.c            | 34 +++++++++++++++++++++++++++++++---
> > >  2 files changed, 36 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> > > index fdc9aeb74a44..b1425fae8cbf 100644
> > > --- a/include/linux/vmalloc.h
> > > +++ b/include/linux/vmalloc.h
> > > @@ -50,7 +50,11 @@ struct iov_iter;		/* in uio.h */
> > >  #endif
> > >  
> > >  struct vm_struct {
> > > -	struct vm_struct	*next;
> > > +	union {
> > > +		struct vm_struct *next;	  /* Early registration of vm_areas. */
> > > +		struct llist_node llnode; /* Asynchronous freeing on error paths. */
> > > +	};
> > > +
> > >  	void			*addr;
> > >  	unsigned long		size;
> > >  	unsigned long		flags;
> > > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > > index 7f48a54ec108..2424f80d524a 100644
> > > --- a/mm/vmalloc.c
> > > +++ b/mm/vmalloc.c
> > > @@ -3680,6 +3680,35 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
> > >  	return nr_allocated;
> > >  }
> > >  
> > > +static LLIST_HEAD(pending_vm_area_cleanup);
> > > +static void cleanup_vm_area_work(struct work_struct *work)
> > > +{
> > > +	struct vm_struct *area, *tmp;
> > > +	struct llist_node *head;
> > > +
> > > +	head = llist_del_all(&pending_vm_area_cleanup);
> > > +	if (!head)
> > > +		return;
> > > +
> > > +	llist_for_each_entry_safe(area, tmp, head, llnode) {
> > > +		if (!area->pages)
> > > +			free_vm_area(area);
> > > +		else
> > > +			vfree(area->addr);
> > > +	}
> > > +}
> > > +
> > > +/*
> > > + * Helper for __vmalloc_area_node() to defer cleanup
> > > + * of partially initialized vm_struct in error paths.
> > > + */
> > > +static DECLARE_WORK(cleanup_vm_area, cleanup_vm_area_work);
> > > +static void defer_vm_area_cleanup(struct vm_struct *area)
> > > +{
> > > +	if (llist_add(&area->llnode, &pending_vm_area_cleanup))
> > > +		schedule_work(&cleanup_vm_area);
> > > +}
> > 
> > Wondering why here we need call schudule_work() when
> > pending_vm_area_cleanup was empty before adding new entry. Shouldn't
> > it be as below to schedule the job? Not sure if I miss anything.
> > 
> > 	if (!llist_add(&area->llnode, &pending_vm_area_cleanup))
> > 		schedule_work(&cleanup_vm_area);
> > 
> > =====
> > /**
> >  * llist_add - add a new entry
> >  * @new:        new entry to be added
> >  * @head:       the head for your lock-less list
> >  *
> >  * Returns true if the list was empty prior to adding this entry.
> >  */
> > static inline bool llist_add(struct llist_node *new, struct llist_head *head)
> > {
> >         return llist_add_batch(new, new, head);
> > }
> > =====
> > 
> But then you will not schedule. If the list is empty, we add one element
> llist_add() returns 1, but your condition expects 0.
> 
> How it works:
> 
> If someone keeps adding to the llist and it is not empty we should not
> trigger a new work, because a current work is in flight(it will cover new comers),
> i.e. it has been scheduled but it has not yet completed llist_del_all() on
> the head.
> 
> Once it is done, a new comer will trigger a work again only if it sees NULL,
> i.e. when the list is empty.

Fair enough. I thought it's a deferring work, in fact it's aiming to put the
error handling in a workqueue, but not the current atomic context.
Thanks for the explanation.


