Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B95A4CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 15:58:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F55A6B009E; Tue, 12 May 2026 11:58:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07F436B00A0; Tue, 12 May 2026 11:58:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E62A46B00A1; Tue, 12 May 2026 11:58:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D25936B009E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 11:58:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7A220120330
	for <linux-mm@kvack.org>; Tue, 12 May 2026 15:58:39 +0000 (UTC)
X-FDA: 84759225558.25.80C2B41
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 14350C0007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 15:58:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PeIJBkw2;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778601517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XJW4f8tXo6Lfw2obSKyz1GioGSG/zB4IqguSnk2BuqQ=;
	b=sjd3H1qvtUNhuRgn3mRsEUwoO9RjSc2wWygfhvFPizsj5LOHK6Oe6Yn+5VQ/uwlfavSgWi
	pXqBbZhXARc/RqPCfaAEmQOXxzsxBmL6S5+Pl/KJAx2FNRVAR1Xci/TjFv5lVHGggwWUqN
	AxPpz9u9MrT5QyJtiIdZmwAFrR/bLps=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PeIJBkw2;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778601517; a=rsa-sha256;
	cv=none;
	b=UD4n4stJ1kZvlN/SkpXtlN+M5SutDe+4A64gi/MY0p70d1V+xj9ULdvEPsbZCdj7AgFzQU
	+0D9eBbxQ1OFbbPlTsrNsObBKGyT1xiShP4Nz4IqAuLfhKa6PyD6QeyKCWP8BjaeLg11RK
	p8coWwhi2Pe2txS2mszk0V2/VUH8TFQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778601516;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XJW4f8tXo6Lfw2obSKyz1GioGSG/zB4IqguSnk2BuqQ=;
	b=PeIJBkw2++2FsHg1LRSRKHyaeWtpPa05VL0aCXgw7igSpm2jg5uK8xKdfi2Tj79zwRVvE0
	IfhISITcTs5KX4Ea/d8mq98ub4tLED34z1dC/mSSfVjhFxD6pSoDZOkKj/SvgEOlMqU0qU
	9zYU3xguq4sxOgoRz+u1fbe6jRxM51s=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-448-Piz7Cr0MOYSKfMPbZD8Apg-1; Tue, 12 May 2026 11:58:35 -0400
X-MC-Unique: Piz7Cr0MOYSKfMPbZD8Apg-1
X-Mimecast-MFC-AGG-ID: Piz7Cr0MOYSKfMPbZD8Apg_1778601514
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-43efc93e4f6so3816372f8f.3
        for <linux-mm@kvack.org>; Tue, 12 May 2026 08:58:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778601514; x=1779206314;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XJW4f8tXo6Lfw2obSKyz1GioGSG/zB4IqguSnk2BuqQ=;
        b=S2+5SkR3e7HvPrIYKCyIwc3OcKW50VZGsNVleGW2oNbcMHZgGYQ8a15UH1E97+wCOZ
         YHhuXCPJN/lw52noPjSffRBpJAOYwQFvvefObF4hC3g90/8JOyiZpXRf4x/ZELJ8jpAj
         YGLF7E0gYdi/Qfq3hPChpRxKMkj7Xt2gRX/o7UBYL+YTYN4Ekj376thdSM0qkSJiFx1f
         JCApdNOXS+Y5RX6gZF+ZYKyrHQckox5Moj0TgQK+XLQBS/oM5lJ055IyLCMj3FHR0l74
         oScCTyi18PLB73MpLT4f7D/horF1bJJnmZ7UVANB+JrCW4yazURyuUvTP1p545K/QCe+
         /l7A==
X-Forwarded-Encrypted: i=1; AFNElJ86gm5bNxv5ZG4HuQmtaiGunhPngyqBZ1603x2NHe83YdoFJFuKpcBtAtxMO7iZ6y+4CbaQTTYf8A==@kvack.org
X-Gm-Message-State: AOJu0Ywp9KFpHzLYDee3knUtuqw+aKL2zsrcbxUwnwHvpiYv7sQxHI87
	xYU8f9iTTTVsS6Dzs4gnGmGPqWRDWnk86OT8ZVsGj6wEeitnssOdsVqpCEdfGAxJzWSguwNbn6Z
	kZbDEzv4CFdXldeG4ZsPT51+n3VAcKDwpcdjLrgUHgw9YnlNbnU+i
X-Gm-Gg: Acq92OGVlKmkZ2JlJo3g6PEwI0Q8x5uqNZXnN7T4w2+WxuGcwQCRBP8ktfmZlpNIjHP
	P8AnwjcflLCvoTu9Yk8clndz3qBT5sDL7YuJYPPM971qeLJ/4aVlkWfxSff9PvvBmK6OWcMp9bi
	vmFDULqMQllA3IVSjqa+ooO7iND9lKRAOVLa8rGFeproS3hNeXz5HPKtoWlRuUr7Ckh6fGspL0Y
	p8fr6Jx4vr0xwTNDT6B5oOrr+P0IFCVbTnMYspZuY9v5CksmCcAEYRSl9Y+P4dma51WTx3eTnhL
	VMMN4mSyCDGtPJ+Ju3s2SrevghrSJ4P7cJGMfCjHUpkp+Ppgx6g3uHGPnlCa+WNi/08VN4Bu0d7
	juwVqgFMJxrLje0gyvfeuNNdksivZhsj7PBXQ6UGl
X-Received: by 2002:a05:600d:e:b0:489:ad:7b5b with SMTP id 5b1f17b1804b1-48e706d24e3mr228847935e9.24.1778601513772;
        Tue, 12 May 2026 08:58:33 -0700 (PDT)
X-Received: by 2002:a05:600d:e:b0:489:ad:7b5b with SMTP id 5b1f17b1804b1-48e706d24e3mr228847285e9.24.1778601513245;
        Tue, 12 May 2026 08:58:33 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e8f4247fasm29156585e9.9.2026.05.12.08.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 08:58:32 -0700 (PDT)
Date: Tue, 12 May 2026 11:58:27 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: Re: [PATCH resend v6 20/30] mm: page_alloc: clear PG_zeroed on buddy
 merge if not both zero
Message-ID: <20260512115805-mutt-send-email-mst@kernel.org>
References: <cover.1778489843.git.mst@redhat.com>
 <a09c1848702368c3545b980c17101b5185ab774d.1778489843.git.mst@redhat.com>
 <agNNkvRK128bYhrf@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <agNNkvRK128bYhrf@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: prP_jTJwmVA1elWOwfhjWmgwpISz7oiKYk9BqfxTLuI_1778601514
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 14350C0007
X-Stat-Signature: k1mi4h3knk766f7q1rxpaki65tf5zy4j
X-HE-Tag: 1778601516-644600
X-HE-Meta: U2FsdGVkX1/BQSEJyX2aoE94ynMOlfbKYm9+rTdqlQA49tcM4GkIueyj1WYnT+fJM6xe4gaa3n5/iBmrYYboFY9yEP6O4/jkuoQLgHQ3BqZGTRltSCMf/Dkye3DoPSOYUq2S/iZXbd2KCJI7RPZo0sHgVtIw/j4SnIKUrxj0PhpSJa+C4MdA7fdUBZDfSaOWusYal/DpFP5aygH4JyQ1VP2Oh9Xvvxn3qMl8ujqtnVuehsG42hIJhJj0gf3o0fW38PaOnHlP2TNKtgiNtUsOhuQ7XdGClcSOYeBolBSsvLO3aRU/ZWyvMctGg0qFYOtFaJiO6pFTiC+DcD2SRjmxgQzXLy8ZweTB9Zyjag5ZIoQlTenNtT2zWTmDWZ2MH/6k/AD7XlsC1MysHKmtCHNi47ce1QVD01n57wGk/X1ikxgyuR11wjcFyDvdNIto0WnZaZGWcXQdOo9Tx0GqJIHN+W3RVSJolfhlttq5QeJx98dy+8E8lJI7qwsj+vuAMVOERkm8T2MqBm3AVpptyOmr9JCX1QyY/E2EYT6n6kf1f9FOx3GwpTO17pD5hYn/4uFQLEIJ3qt8QBdY6kwUswHp6W29UFwYEkt917i/sSrPT5RW92+g7jfjwtqvX4yLNRhO2Lup1SZd1stg1TpPuwf6/WSYj/sZz2Rlfu55D5O5TiQcd8WWahuVva5CepquaChniseDHDpd8pEk60xUY7u9bshD1bC7l0lrQMgd0XwmjIjseQngrI1kdbWWvaMMJMo8bfBE2/3NwPCiustm6h8xvHgnthSB8Sj/8PYK3Ud+LDp35GIKPvHJfs0l4BSFjW5uIeTkmN9et1hBE4mENU4ocZdeb2nXiu/iH2oyIKOeXyy+kTu7/ZNZHpDhC+fWT9zJkwBDcfQD87e4pNEMMMpAehZMGUgRO1b1RtAWF16u9kcWmxQ9V7HEmtHA8+YpJ1ssr3z1PHZiEwAuUlPGPUn
 afL4AN8Q
 tZcNOI4Zbu944jr1yxI42rRg1ClKdWIjkvP8cBvlnoaJlMYh8ECtFZqsLhte1pXjCplcHLca1gk6KB11FrpM6AVkUAOA70gHk8XIgaZo3FkGPDGKqjDiezruq38xBMa3F0PFxrnP7r2f1Tr+vDXkaMn0mA8wWYeyxc8VshtrajK3m7ESznGLrDemMEARQK75ApcGsgjelK8cg2BM0xXpmBOdG4h6rd/6+R09NRLfgdiOGbAlvL0nzJOCIpjQpGHYeq7wA8U3fdpTScscJQlhGWsayxeymVCIcxYvAczYlmFilTNQFUX7ZcTfF9VLuSZ88UpczG/aM3vS+2ZBYoBPso/5HBzozv7vfjdSdj4OIphgJg/ixHOGH+3rlME8zkGIZbkMBpQ1amOugMTQUbUJ1WK1Ni57l13RNi0DgqX/+kGB04MUPu78C8GeiJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 11:56:02AM -0400, Gregory Price wrote:
> On Mon, May 11, 2026 at 05:03:35AM -0400, Michael S. Tsirkin wrote:
> > When two buddy pages merge in __free_one_page(), preserve
> > PG_zeroed on the merged page only if both buddies have the
> > flag set.  Otherwise clear it.
> > 
> > The merged page would inherit PG_zeroed, and a later __GFP_ZERO
> > allocation would skip zeroing stale data in the non-zero half.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Assisted-by: Claude:claude-opus-4-6
> > Assisted-by: cursor-agent:GPT-5.4-xhigh
> > ---
> >  mm/page_alloc.c | 15 ++++++++++++++-
> >  1 file changed, 14 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index bd3b909cacdf..d70c9ba6b329 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -940,10 +940,14 @@ static inline void __free_one_page(struct page *page,
> >  	unsigned long buddy_pfn = 0;
> >  	unsigned long combined_pfn;
> >  	struct page *buddy;
> > +	bool buddy_zeroed;
> > +	bool page_zeroed;
> 
> If you want to play some code golf, i think you can get away with a
> single bool here:
> 
>     bool zeroed;
>     zeroed = PageZeroed(buddy);
>     zeroed &= PageZeroed(page);
> 
>     if (zeroed)
>         __SetPageZeroed(page);
> 
> ~Gregory

Does it matter? It makes my head hurt.

-- 
MST


