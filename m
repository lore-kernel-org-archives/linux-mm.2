Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C86F4CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 23:46:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3B4E8E0005; Wed, 27 Aug 2025 19:46:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B12AD8E0001; Wed, 27 Aug 2025 19:46:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A286E8E0005; Wed, 27 Aug 2025 19:46:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F76F8E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 19:46:40 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CC10158B67
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 23:46:39 +0000 (UTC)
X-FDA: 83824174518.01.8ACAB8C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4805B100009
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 23:46:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ferPd0sQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756338398; a=rsa-sha256;
	cv=none;
	b=yRtrRS6Bz9m6UnfBmksDZmZvrdrCkU3wm8UA62x6c0psip2TbZsGYG2Xv6zNdPg8rWJkuK
	a2nbtU6VcUfeVd01+/yxOpT/SNb37qm9Fy8sAjD9MXfgiWFpKtRpjQfoob6Yn02k9hN+rG
	eKbnDCEFE8zVZXDwjrIbRz4TrO8V16Y=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ferPd0sQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756338398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P5F8gpBz7t5sMa3hnf8LHIFEhCjAdRv+NiEXkMZszlQ=;
	b=RGvXd6j8Pnas2MG6JFE+PVGr9JS2XAz3HVEI5CMzZ1s50HGmYaz/3Y58pJt2mIfXDdKKc+
	rAhN2k2n4xbVzQqWnyBq/oWzbdAYc90CHzjnBuhGgvNxW4+79IJr0nbcv9G5IqrwXwD++T
	QdaphKHl/Fsqkmq4XzWTrtZymvWCFS8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756338395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P5F8gpBz7t5sMa3hnf8LHIFEhCjAdRv+NiEXkMZszlQ=;
	b=ferPd0sQAEpOpQXdDmjdKuAnHpTJDV4DEXGcjj3MZEKMiUuVt0Bg/xxrrgPedm3MD5WIm7
	wDgQDXf4dZqnxAxGtzsFeEinuDekZ3TDaSEpc6YGkxiJALixaFlIJcoGnXEydBOgT2zoyf
	URHaAK20t+w59PaA+oSZNcXN5/C3kK8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-688-KQYxMOZTN466KSj7S-_7Ag-1; Wed,
 27 Aug 2025 19:46:32 -0400
X-MC-Unique: KQYxMOZTN466KSj7S-_7Ag-1
X-Mimecast-MFC-AGG-ID: KQYxMOZTN466KSj7S-_7Ag_1756338390
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 01E541800366;
	Wed, 27 Aug 2025 23:46:29 +0000 (UTC)
Received: from localhost (unknown [10.72.112.154])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 29DA91800446;
	Wed, 27 Aug 2025 23:46:25 +0000 (UTC)
Date: Thu, 28 Aug 2025 07:46:21 +0800
From: Baoquan He <bhe@redhat.com>
To: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] mm, swap: tidy up swap device and cluster info
 helpers
Message-ID: <aK+YzeWToVUX3WOY@MiWiFi-R3L-srv>
References: <20250822192023.13477-1-ryncsn@gmail.com>
 <20250822192023.13477-5-ryncsn@gmail.com>
 <aK5/1so7a0i80+dz@MiWiFi-R3L-srv>
 <CACePvbU8pnjWCiWcSXRr4UdpuD_wdtrouLMz_fNB_=KRrdHLmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbU8pnjWCiWcSXRr4UdpuD_wdtrouLMz_fNB_=KRrdHLmQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Queue-Id: 4805B100009
X-Stat-Signature: cu7nozsdh3c8pxafxpafyrk1uwy8uinm
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756338396-560937
X-HE-Meta: U2FsdGVkX1+ccXeXlcXvzmJUO/X4Q4QK7pCVzTwx4ReB1GZ6XBMP4yEI8lYYN0nn7U/pb84mTmMll+UKOOiuWUZkEiR5/iwSrPw+Qq4i01NIZjmlKVtPHGUflrzeE7Ai1IJrcYfHWRxr4KuG6B7bbbGvH/unSdhmEO93534Rpb8HdyP+js5K4uEu03oFQe7edkpAQdogXZjTRmEMb5og/9S/HiKxtYbv7AlRXhHlqjEPZnw+pibTUqJflgMu55OnhX8uQ6FdQ0TLB3zBjM8ooRDUGiYmbVw5zCNdd/SxA34lKtiEsNepSktA4kdW9xpB/b9xGrRy91GKGGTiBQ8+4XaMtNTfXHoeWx0yUGJ3R1dUVy2cSuuOMnq6hrbe1PXRTNYA5BjDtnAmAsdJo4QZfxLxMFn49s2wfy9u+2zpewanSjikr8iP8rekC1KZVH7Ap5UET36OTyuYGFuo4km+nav+FDk42c6bNBLN9PRGWWbVvY9P1i4RKUIUziPKJLyUFKLB5pHJR/W2rlW5C2fHFB1pXhuZ26996b2SPpge7slLbB8iNLXIZelcA4jvKa0flfA2wNfDxwlZpq1eglaH9Ls9OvUvsWn/sH+FQH7d+RmTlFf/rpz624K4xpm2az6Y7Dsj+5Qh9YN8GRgy+btZ8WoE7hxEr90qNJPQYKvbtGVGfIKxIKR8dv//hqDtxy187rLrcptjz+wiuxf+jhw05EiOFZKGgUG1lp0Q8MJtDhmWX5WlCXcJoTgXHco74sUUfhkhbz3lCzBsoi31o0eF6aDoBYa46T9GoeyMul4Gs5JNvEuv+BiP03P4/qHKjqBvXVkG3Apg9pIeygoUy3vdmyt2woC8ZmitBggVn5YWeeu52EjL2qSt1+Vnd1PcnC6JL6ojSxqQCLUGzv3Ya6H+MUPNVh24FPZj/JVehTbz8+cdzvNHvX+lfIjL/Kcj+/30FJTF7pcFttu8I+kuoKB
 9rs7ORTx
 XJU1a8p+0ppzZ73NItnWV00+YmJTrRCq3g8FWG18Q8bAfNuvZ8BecPHl2XSoRUfSICXc/s+lvE7bBbj8nvvtkxz9atuYqIUONujb5xet7oiW6B9T12qNc9i01Cvnue2g4CrnyhOwlw+ccFRvdUpTXJ7REb1Ugmaczvcju7W8VPAeuMN1rdMe6PPFgrjt1JOZEiKLO+O+8mFzs4Q1nKAGdlopm2DRHy4beIRJ5T4dhthXlbTHoKVjUq+ptr358ZAuZtJhVZeSkvQW5ThOHozYlL4gEULNjHZUCYA3b5eWMUfPFw71Uj9HVccuV2tXQvddG3MQaME27/RuUfRvStK3zHLNRwENro6KY8RSjGVJ9pX5VHvwMB2rsKDk2rdqGMVvAYOVI7o8VL7RwxT9ksoUo2SYKY1B8j3tIwexLfe2nlpU1Zq/lCamegEiZY5Wjix0z+2LEFlpn76XOV0Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/27/25 at 10:44am, Chris Li wrote:
> On Tue, Aug 26, 2025 at 8:47 PM Baoquan He <bhe@redhat.com> wrote:
> >
> > On 08/23/25 at 03:20am, Kairui Song wrote:
> > ......
> > > diff --git a/mm/swap.h b/mm/swap.h
> > > index 223b40f2d37e..7b3efaa51624 100644
> > > --- a/mm/swap.h
> > > +++ b/mm/swap.h
> > > @@ -15,6 +15,8 @@ extern int page_cluster;
> > >  #define swap_entry_order(order)      0
> > >  #endif
> > >
> > > +extern struct swap_info_struct *swap_info[];
> > > +
> > >  /*
> > >   * We use this to track usage of a cluster. A cluster is a block of swap disk
> > >   * space with SWAPFILE_CLUSTER pages long and naturally aligns in disk. All
> > > @@ -53,9 +55,28 @@ enum swap_cluster_flags {
> > >  #include <linux/swapops.h> /* for swp_offset */
> > >  #include <linux/blk_types.h> /* for bio_end_io_t */
> > >
> > > +/*
> > > + * Callers of all swp_* helpers here must ensure the entry is valid, and
> > > + * pin the swap device by reference or in other ways.
> > > + */
> > > +static inline struct swap_info_struct *swp_type_info(int type)
> > > +{
> > > +     struct swap_info_struct *si;
> > > +
> > > +     si = READ_ONCE(swap_info[type]); /* rcu_dereference() */
> > > +     VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
> > > +     return si;
> > > +}
> > > +
> > > +static inline struct swap_info_struct *swp_info(swp_entry_t entry)
> > > +{
> > > +     return swp_type_info(swp_type(entry));
> > > +}
> >
> > swp_type_info() is only used by swp_info() in the whole series, can we
> > open code it in swp_info()?
> 
> BTW, off topic here. I really don't like the "_info" suffix. Anything
> you can put into a C struct by definition is some kind of information.
> Same to the _struct. Anything defined by a struct is a struct. Don't
> need to say that.
> The "struct swap_info_struct" gets two of the unnecessary words. It
> should be something like  "struct swap_file" or "struct swap_device".
> Renaming it is too invasive to the code base and it will mess up the
> git annotation history.

I agree. I searched for _info_struct in the current code, only found
swap_info_struct, ax25_info_struct, vm86plus_info_struct. The latter two
are seen in very few LOC. Maybe we can rename it later when things are all
done. And 'struct swap_cluster_info' too.


