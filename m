Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C906CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 08:06:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FE426B008C; Tue,  9 Jun 2026 04:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D5BF6B0092; Tue,  9 Jun 2026 04:06:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EB6E6B0093; Tue,  9 Jun 2026 04:06:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E6636B008C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:06:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB14714046C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:06:20 +0000 (UTC)
X-FDA: 84859641720.11.1CEC63C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5E0E31A0007
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:06:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Kiq42VhM;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780992378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mtkf4sgMqVoG+F92sfanLnqPLF7Ap+Es97Nko8xXfZE=;
	b=QOIDBleGcD9yQPwBjjGqmLl5S707LOB6NIVAIUW4yNGexp8AMIBTvEt16P77Q+1ZNk0NYe
	YChjzfJvKekJikCK8i7DsIwgCxatuIVcYYz9pqQVRfi7ftcT6OazSxn7+N6bKmcgG6zL0w
	MBDrYmvgOYF1Krtwlvbac7rsUbHQnjE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Kiq42VhM;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780992378;
	b=f7XWQyl5GlbBaKFUSoX8qA6Vg0Wg+BIwLrU5Qokh8XfPwuVnzvA/3TG3DypvEhl9iNgC5m
	zBQSQmOEW+q+Q4e5c66rJ4BvFawUD97Ti3iIMu56kSr3vOJCA7n0v7ufPhJ11V2AOiUS27
	O69+lhI9IsnPECmUySY0jLnZT2oxskQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780992377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mtkf4sgMqVoG+F92sfanLnqPLF7Ap+Es97Nko8xXfZE=;
	b=Kiq42VhMcVXfGAf3wXnwpx0rSquOFqCSzr2nmMupo6e2aDlUMDfo//4kDd2V72BWVek7Tu
	6xgNyfm1ExW8tvFJW0A7hivT5iLmc1nRBQU+8628cBPLHZDxUVJr4IDNFyP8YkOiLvFWXB
	SfexR1oJTK8wucJrsMT1XIQot1A34cI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-435-K_HsveaBNqWg9gm1nrM-4g-1; Tue, 09 Jun 2026 04:06:16 -0400
X-MC-Unique: K_HsveaBNqWg9gm1nrM-4g-1
X-Mimecast-MFC-AGG-ID: K_HsveaBNqWg9gm1nrM-4g_1780992375
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-490b8adf8b8so47882715e9.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 01:06:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780992375; x=1781597175;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mtkf4sgMqVoG+F92sfanLnqPLF7Ap+Es97Nko8xXfZE=;
        b=V3iM+UxPK/xYNY4YTUylpv5X5un0Q8jggFPCnLTiN+v5NDEI3a4pcOVqriR4RMxfCd
         y6kjQokBdYf7b73tZGvFtdBSgz41C1aSao0/6/Bd8hSXoqpZG0TwlqWwvfPBCiTFMNNK
         JIv5OMvVEeA19H7aEnPR0D9Sk2i6JKBUt6zlwLjGI8VdKpxAvwzSbkjoVnD9svclt0fh
         xD5z2jXRuuNN7PcFzk+1Zvskwv2ycX0+T27CBkwMicf55pStDynKA3jauq6PaFEtzT9c
         hywpGnma6X+Eyh+Wi7V9W7mwUZAVHttdIXVEDnWVUySfrYpuQHrccU7RHHVQMHSfDnN9
         Gl5w==
X-Forwarded-Encrypted: i=1; AFNElJ9FLk+iuRyAIBVkNA7W+4ToyWa5V+Wj6v0NYZ3f0jALAHv5JvvaA/kSZUzA6CSXzMFyTRjdqE4Flw==@kvack.org
X-Gm-Message-State: AOJu0YycHlsRXSrInxtTP6twQ2lckkeq/jVwnUng/F2uqm+98UWBNCai
	DOc/xD6IFTI38E/7Kurg2JSkD7/Yz0teUw7Y75xT+m6ulC1tjPwZGOoy7wxBRB5sDO7nVjFQSNp
	0vLttlxHY2ti9t0YnEHnTnzn4kzqxu/UiwQDtI0wXmmWKUOeTCIN7
X-Gm-Gg: Acq92OHpTSXmiQWNvrsB+Hv1++T75NCEy8BUa3Zcc10PmxbSDPxhS4628Jq/QsNXTbO
	t7N5JsmaQP+9JnzWhW/TNyHPaHV9GTdjGd2UiR1v1/sEIo02pdsAqMBs547tbzq3ThcyILsqFAK
	0kJ3GdAMyszK5zhnCTh/fhYN0AciyogzLaTPGtja18MNwboTW7HUpWEKr17qWnBd0mHZ9qXq9TA
	iPzqrwpL5kD/QX8e5DQag2oybdRYgVPD8Q7wcDMuyRc2qBBvwjq8Vc0Ei54Kw2NjPwPu196+iJq
	Su1UPkIHpqqY6XOKoZWdy6Ft4b2Hh1SQHLFq/0G14Kfppjz2K5jBS+Hygs0txb4oE865GR8jUWu
	BO0pYOJMNCvq9GWv1VYb70u64XUrsjhx5hTHqi+dGpODmCAF1LD7nhg==
X-Received: by 2002:a05:600c:3515:b0:490:b409:94f4 with SMTP id 5b1f17b1804b1-490c2602a24mr294886835e9.28.1780992375120;
        Tue, 09 Jun 2026 01:06:15 -0700 (PDT)
X-Received: by 2002:a05:600c:3515:b0:490:b409:94f4 with SMTP id 5b1f17b1804b1-490c2602a24mr294885445e9.28.1780992374486;
        Tue, 09 Jun 2026 01:06:14 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3d66c8sm440082815e9.10.2026.06.09.01.06.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 01:06:13 -0700 (PDT)
Date: Tue, 9 Jun 2026 04:06:08 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: New design
Message-ID: <20260609033042-mutt-send-email-mst@kernel.org>
References: <cover.1780906288.git.mst@redhat.com>
 <aiePVsiV-w-IZ8A4@casper.infradead.org>
MIME-Version: 1.0
In-Reply-To: <aiePVsiV-w-IZ8A4@casper.infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: C3NeejsChlmMEsm8kmjMmJvgwKwG3dL81jyasnf5wy8_1780992375
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 5E0E31A0007
X-Rspam-User: 
X-Stat-Signature: 7jqye5fx43zsr6fu6pbugaaiahget1fr
X-Rspamd-Server: rspam09
X-HE-Tag: 1780992378-781969
X-HE-Meta: U2FsdGVkX1/7YrVhb1i3Ucu2aAVtqEaW5Y/TO4bYimxG2c2+I2wpAvUccCcNN2bWg5v/kurL2AvSwvWgduDzh7PNgiJVsaumva4JV9AjDe5ijircfCl5lACM305xdhy4d9kXiT2YZQtDRbebSXYEv0yxqG9I4Wyvhh8GqAYXAltWZ3HhL1FPlKCuyDxfWp6+cyDeZp07JP98fLZW7DrmkIN+m1A17pXgvo/voQrGiSfrylkg7AaZkTS4lUtnb3bAlgg/imP5kxDL57BONhi7muHnvf71TAA1KG6vN9u4VuaOrzeSPeDiBblz5i86CAwPZIAp5ReVug9BbRC8DLbOHN5pVEWz56TcjS1TBpq4z0hOnwlNu3doB9hgG9Lh7O2Gtc8U/tFU4EM9+a2t0UGSMAKjxZ6dDuvHROeUIkg9Yp6NDUYIy/n2Bq3dv/CyJSS0Wf9q9D8dsO/xAQqI0wpMyF+J0TKhNRifUwEpwOTeoMJ99Kr1/Mn1nGDQP7eqOeg3etRyh3L2U/16zf4ULubm13xDrxeQ6coycEp3q4p+EvK8tzRFAQfAglqdbeK/VcB+tWof63W7+rp4F9jnBG7edR9Ng0FeJ9uV8ypvFRKVwa9qnGCsQNw6Cfs9WMX1Nc+joYYdM4tBGZkwlA5Yc9+5l4b17pbVkjtudJn1uDqf8H2oQMLthMprUIUDFUCMFVjPd/o+gx2KY51/vZF/wT6Fls0cojrEPKBxskpgQQTOl4nLBYhwzMz/OQK+ifDEnK38uZLF+exHy0O1xE5hfvdU1wPdhNDM1fYXlxahNIKlqS0b/hKjSzbNQazykS0AXxOg7W9D9vDqmDVTkp8izbyN4VKn1kibSPXP7kfZbBCNo7ZJIKsUf1NU/IwxOCNAw5x+7C3UJxXSBzbv4V3iOHVVRSAsACUgCPy0Jm3/DKx1Sk2Jok299uwPscpEZK6eLa34XszAHtvOZcp1yW0/0JL
 H+hUTi2M
 qGr5Dc6+7hY02+eayNGHsBrk0YcIo2xSruaDBW6E3A826LWHoM6kYfoU9BXnU1zsrUwWJJ2bAWmfQ8sfHRb1jVtNAY3CUmX7mhxnh6lqlALbkE1wSF7NcHTQPOSnZOUJPqAWx785PGAlnewbyG0uNe/3htr5II7qVlZrhg6/uxfjJGeEeHwkO7byBxzWn91zPLZzQJmXE11ov1Ev31tp5fUuExOuv+Yx7tl3WV0ZID/5G1KVoPynutZ/5mjrOD1LL9ixlhs6EGU4rGWxofKMdSRTsUPedPfAMKewhTsV9pDJ+/oMMNmOkxss1fya8AZ2txfcDNea5VrMQdHap2u0XAZGeNgynwsSPhVpd/fTh8VYxnsLPKBOwAtJiMdheM48G0tRODLFViTl21dcxTSwaS/IzYl9nM95Z7QyO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 04:58:14AM +0100, Matthew Wilcox wrote:
> OK, here's how I'd structure this:

Thanks a lot for looking into this and writing this Matthew! Looks
workable, let's see if there's rough consensus around this.
Two questions to make sure I understand.

> 
> 1. Introduce PG_zeroed for buddy pages
> 2. Set it if init_on_free is set

Not 100% sure why we want this bit. And I am not sure this works
actually because init_on_free does kernel_init_pages
and does not flush cache on arm32.
You will notice that user_alloc_needs_zeroing ignores init_on_free.
Right?
How about we skip step 2, make the patchset a bit smaller?


> 3. Set it from balloon driver
> 
> https://lore.kernel.org/lkml/c7094de807c0e963526686e1d245bc76193b1a92.1776689093.git.mst@redhat.com/ 
> 
> but add FPI_ZEROED instead of an extra bool parameter.
> 
> 4. Introduce page_is_zeroed like this:
> 
> static inline bool page_is_zeroed(const struct page *page)
> {
>         /*
>          * lru.next has bit 2 set if the page is already zeroed.
>          * Callers may simply overwrite it once they no longer
> 	 * need to preserve that information.
>          */
>         return (unsigned long)page->lru.next & BIT(2);
> }
> 
> (you'll notice this is similar to page_is_pfmemalloc() but it doesn't
> need to be in mm.h)
> 
> This step is going to be a bit fiddly.  We weren't expecting to return
> multiple flags in page->lru.next, so clear_page_pfmemalloc() just sets
> page->lru.next to NULL.  So somewhere we need to make sure that
> page->lru.next is definitely NULL, and then allow both the zeroed and
> pfmemalloc flags to be set in it.
> 
> The important part of this is that it allows the zeroed flag to be
> returned from the page allocator without introducing pghint_t like you
> did in v2.
> 
> 5. Now you can start skipping various zeroing steps higher in the call
> chain.
> I understand David's disgust with vma_alloc_zeroed_movable_folio()
> but that is surely a separate cleanup and nothing to do with this
> patchset.



One other question: would people like to see it as a single patchset
or multiple ones 1-4? Multiple ones would be easier to review but
of course this means no actual perf gain until part 5 is merged. Is that
acceptable?

-- 
MST


