Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63EF6CD98C6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 06:33:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 913906B0005; Thu, 11 Jun 2026 02:33:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C4B46B0088; Thu, 11 Jun 2026 02:33:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78C706B008C; Thu, 11 Jun 2026 02:33:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 65A0B6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 02:33:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 03CA21204D3
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:33:34 +0000 (UTC)
X-FDA: 84866665590.17.B358A66
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 72D1B8000D
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:33:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FGX4EkZT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781159612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nUXcCYB3mg7pVgqNjbUYn7VXuJDevAzArkzYyGeIlRQ=;
	b=JAr3yNid9fbvvHvt+vXfOJM4/uhUH4YcpmQ9zUrtSsmbp6PKWjPu8+WdNealIM21VKiouj
	QiANZ0isij+u1F5HVj3vlusy7poid0WjXcHerzeAplUHRRUEGQFzjXqCMdiCaIkA7iQEai
	UpiakB3jkb4pKBHvwlxD7auHxRgKL9w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FGX4EkZT;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781159612;
	b=mgqUZxYlb+jmvr4jLOk8I7fgGahTAYWvKOy5Cr7m7eHzTnCDbLiCtVImuCbMC5OKrAEFjx
	H7O/SrCj2piSN2aqKTx7DxyzdudQe3taa4ak4iqW3fVX3NKJfe8l+4iiw3jlyxcxbOOR8i
	NkxB5JFmCGk56xn72aNEuBn6+atPo8w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781159611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nUXcCYB3mg7pVgqNjbUYn7VXuJDevAzArkzYyGeIlRQ=;
	b=FGX4EkZTaI3Y9zNCNKkm6xVUq4YtNOgRJuMEk0aDKm1V/fMESUwY+g1mNpTh2r4rk7Huyi
	8JWIuB4MLsqKGaMxjRVhqo+OxNqJ3F8jZFnAWcPqKgc15hQPiaUw6pkDvg8DwClJY55UNS
	3rr9RxmJB5cgC8hd7eEgW0c1CWfq3sA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-80-4qOIbFdqM6uo9L-as6yKNw-1; Thu, 11 Jun 2026 02:33:30 -0400
X-MC-Unique: 4qOIbFdqM6uo9L-as6yKNw-1
X-Mimecast-MFC-AGG-ID: 4qOIbFdqM6uo9L-as6yKNw_1781159609
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-490c840efe6so4551195e9.1
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:33:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781159609; x=1781764409;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nUXcCYB3mg7pVgqNjbUYn7VXuJDevAzArkzYyGeIlRQ=;
        b=KBLVeXqq7NRO1b1ZVX1FuvLOsqp1JrmFuzPb5zXglpRLFnavk9HYQVIKDo1tCbk8UP
         PNTJgdvhsICl56+tZIogtXD0Mtshi1m13m3GWoIVzF8Ct7Zd7ZB0ZnDMF0Ty+SL4bK38
         Kk5dnym9orPD9ohtwE95bzaoOLZs2mSMCcFFwOZ3AbxCuHf9ZXnJb8QGJLSf812BItVI
         DieUIZSpONBA7VItvcTsQ2XjU/ONjUeAUKt7EFStC3mxicKgwAamzPVHOEz8ydreiz73
         ZTvOQsLsuWHoGWvR831OFJLd6pQaAG7zZMzvAMs4+TnPseSs765dsUxcg5ZwMmaGg1dS
         ayMA==
X-Forwarded-Encrypted: i=1; AFNElJ+JPzUFBG50rVEAA08lCnq/SK9jdbPJ2kSeU1G4UkWKL7h8g9NijWmaFjpx/GMGMKUhJYzQXiN9jA==@kvack.org
X-Gm-Message-State: AOJu0YxF2QfkaZmEewiLkRqT/ismGlQZV8rU7JeZBzfzAHBaVnylIdab
	2PeggZ5BgkBH3SulUw4xcfKN7HbNAG0UjZFh7Do/LOQgLlR3ahIc6hACV+lFGbfAV/8TxbfL1/i
	cyse5N3OR2rP5cQN3l2LlnKqiLsFefnLR/Xapc+mr1iFj5f2qeUJ/
X-Gm-Gg: Acq92OHT3ppCQ2mj+i8YcZ4qUkny7RiQ2956qNVy0UJTbfmTVGU+7KfLPSYMDNDrFDw
	oS1MxAoL8AwF95gIrVvTUuRWy7y1xv7lF+rj4OhOxecBnUcF81olA60N355TUBJDgbCEUX6dYeg
	cq+pXAxdi5550iUXbOQYUn54MAcSoeZRwNUWHktoQ263bBnEyJiio7E5fph57C/2ojCsLddhZ7k
	NLt6mMjjf9oh3lfaWsjCElTywy6DpUevco8iOs7GQPyWcYcPk5eU1SA0FxdLTeozw0pJaKav6+K
	teDZU9m+9ZjwjedzxYMTOszKU8EgL7mIAelEGvEH5PRvC59U45+cwEnAVpBTexuVJZknLZ61GVg
	oWyzRSdbr2b8GLi+/aj8tn+06WKtIseDQZo0EbmrvMBdUPK0HJjRxZg==
X-Received: by 2002:a05:600c:3ba7:b0:490:9dc3:3483 with SMTP id 5b1f17b1804b1-490e52cad04mr12572615e9.2.1781159608684;
        Wed, 10 Jun 2026 23:33:28 -0700 (PDT)
X-Received: by 2002:a05:600c:3ba7:b0:490:9dc3:3483 with SMTP id 5b1f17b1804b1-490e52cad04mr12571975e9.2.1781159608179;
        Wed, 10 Jun 2026 23:33:28 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490e52ac9aasm23585695e9.4.2026.06.10.23.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 23:33:27 -0700 (PDT)
Date: Thu, 11 Jun 2026 02:33:21 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	Miaohe Lin <linmiaohe@huawei.com>, Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
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
	Andrea Arcangeli <aarcange@redhat.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH splitout] mm: memory-failure: serialize
 TestSetPageHWPoison with zone->lock
Message-ID: <20260611023208-mutt-send-email-mst@kernel.org>
References: <df06b66fe4ff8e925ee0714955abc2183a727b90.1780998980.git.mst@redhat.com>
 <20260609111020.e88f51a7b6ebc37360d66fdc@linux-foundation.org>
 <8c1f468e-b50a-487a-a267-8d1ea5a61c87@kernel.org>
MIME-Version: 1.0
In-Reply-To: <8c1f468e-b50a-487a-a267-8d1ea5a61c87@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PTfqOt72njZoj8cDkOzacS2ojFCxUZISabBvpI5cwNM_1781159609
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 72D1B8000D
X-Stat-Signature: w31kxfo9zebq9135y81j1cihnm5g6zqu
X-Rspam-User: 
X-HE-Tag: 1781159612-334653
X-HE-Meta: U2FsdGVkX18hfnvvrNOkUBXuEyqgTI9wNdQfeHFF+8d2YrbjZaLKCzsnpOToshcP2eqrdnAdmyrmXr/SRPhfOWE4/Xc/lAu4dEB1RbIty3BCOYs8qmBYLqkzeRow3+9LVcPLnzhLpTqgb8lYKhEp/OGGgqnTTY4HSrsynDqHV6h+inEpcZp8zRfUs8kavF4qgaGKfOekOGJVk6ebHjOHviMiqXGrbS1qENCy7pt3QsBwumis6QB/VEyEdyYVzOL8bNqwoC4PdfcRfsstzX7757ush5e/vIqBWVJgY78Dn3niCUI330hSzExiGanupSVxZyz3piicFq7dV7R3IQUWyXt9+vMGH6BBDBeBk5k6Byallw9fAIe2LrLiPjhl/RzfPXJlo9crNEkahnaqInFvhbeBNAGM3vHuynABkZYaDkTPG0TCda+l/zktzgeY7UM392xbMrbZI7su4zFDMuA4+P3H1omsyRASRrOwRPk3COA69/1JfezNIsBVUZzyqBJiUsB4w0cHkbIwlPiBjzPHIF4ACMwriwEwoKdXOVKLaelfwMKlzE58Gz7Ap5UaPKiK+jpsuwSYSXSAeYgwcoGv++lZzzKXPQc3tbvp/AyDdLy3muDwAjluPMKf4C0PAlr0vNJdS3/sdiYLYgQwluPRh0jl3n+WONC+US3YebZbsjuT/Sq3jCcme7mgeyfiYyGyDf57M0cZ0bjn1fdJE0uOyJP319n6eg+lLpT9GSGAqbkpR5WMwsp61GIackqezJmJUALvZYVpLQGdY+EDWErpg7nM8Ls1o4tMxa61z1eTjo63xemAtFwxWcqkyEfD9Y2H/YI/i4BVYszqrw0obZU//0HqNGfdTXNOOYnm/1jdfjuBo5Yqzd0HP5cRL87O4+78J7F+KJyBymCvSr+r1UO8ra1fmCEhACRJbIRnRVgH6VwAJmhQLocTi3OjHdx6EoavJW79hN2M/KEqXARrvQC
 scBnJYMT
 XUG0vRC9sSEaD+nnBJXzoiAatpU2rucdbZRQB53y8A3AYfg1ws/+rWGZcii48ygLHx0YQ+h9tmeICjXwmg5lkDHlOK3zRAN47wQ0JXGGC2S+zwJjTFHDBj/gXe7w8d2wGM/x4L/p3R5Su5LRR1Svp3o/7NCdPqFwQ34+l3D6lV0Broj+G2N32HLYJIi5xLldFBkJnecI5vMOCPXFAnsQgLr7SpydbnqshB9uTMqG84D5zaRFv26I71NewmhYOPaiIXF1TmvbJcc439ZFOnnuxQSzlHPV3cnV2ZRe+0bLqa0JJlWEnXwH2VXM980WZkrNMjK4gMrHJu/GDE+ICgqfzkWRJhi2//gSsQ59yEU+iV31K+IXFIC9qP+9r+Qy4PEqeO05Gx6pG3zPFW3KKTWFtkCOKX2d4vCtOJkmX2E8EGbhttfan3XXTfi0e4XCx2wBCZzkNRLHcrRo5ncJG5XsvCKOlz++7maXjiwE3MjFSdHl8XS/Q1r6zGgN8YvNkpQQrVdJW9rLpY57uN2yNpOEaE4k5C52mK6xsEGmRMMEMUShHBCeSD5lDhw1xAkFu2S0D65sGEklr0iyD/qQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 08:38:09PM +0200, David Hildenbrand (Arm) wrote:
> On 6/9/26 20:10, Andrew Morton wrote:
> > On Tue, 9 Jun 2026 06:12:49 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > 
> >> TestSetPageHWPoison() is called without zone->lock, so its atomic
> >> update to page->flags can race with non-atomic flag operations
> >> that run under zone->lock in the buddy allocator.
> >>
> >> In particular, __free_pages_prepare() does:
> >>
> >>     page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> >>
> >> This non-atomic read-modify-write, while correctly excluding
> >> __PG_HWPOISON from the mask, can still lose a concurrent
> >> TestSetPageHWPoison if the read happens before the poison bit
> >> is set and the write happens after.  Will only get worse if/when
> >> we add more non-atomic flag operations.
> >>
> >> Fix by acquiring zone->lock around TestSetPageHWPoison and
> >> around ClearPageHWPoison in the retry path.  This
> >> serializes with all buddy flag manipulation.  The cost is
> >> negligible: one lock/unlock in an extremely rare path
> >> (hardware memory errors).
> >>
> >> Note: SetPageHWPoison and TestClearPageHWPoison calls elsewhere
> >> in this file operate on pages already removed from the buddy
> >> allocator or on non-buddy pages (DAX, hugetlb), so they do not
> >> need zone->lock protection.
> > 
> > Sashiko is saying this doesn't do anything "Because
> > __free_pages_prepare() executes entirely locklessly".  Did it goof?
> > 
> > https://sashiko.dev/#/patchset/df06b66fe4ff8e925ee0714955abc2183a727b90.1780998980.git.mst@redhat.com
> 
> Battle of the bots: it's right.

Ugh it's bot against human - I remembered we have zone lock
normally in alloc and thought it helps and didn't double check we don't
have it here . The bot wins (

> -- 
> Cheers,
> 
> Davidc


