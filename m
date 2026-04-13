Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0892FF531CC
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 20:32:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FACB6B00AC; Mon, 13 Apr 2026 16:32:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AC0E6B00AE; Mon, 13 Apr 2026 16:32:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F03D76B00B0; Mon, 13 Apr 2026 16:32:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DDFCB6B00AC
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:32:18 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8CC061A02DD
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:32:18 +0000 (UTC)
X-FDA: 84654679956.03.CDC7F24
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3466D100007
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:32:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZhvEP8kh;
	spf=pass (imf14.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776112336; a=rsa-sha256;
	cv=none;
	b=ZSIY5gp4xjsY2xc9qT7BO4LEe/4YVEK+sJRnIeVDpMNbsH9JuHxlpnXho/jNxu55k08oAY
	GUpqcd4el4ShrGxAjeVb/JlSUqUghUEP865/hQUUwXwBraV1UfCc4a3zjGu7i9QXq8vLp/
	mNpX+OcNSsxpj6Ju72zZ4r2hB7n+Y/Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776112336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NWH25+zbxJ7b6HA24/mMxvWwNWDzV+d0yyXTRBBCpp4=;
	b=lEWQalXAE42FDIvqkuA+jidO6dD5ZsoN90E5TlH7YZDYx8Afzz64fUKEVrC/laeczbUNpV
	7K9PVA28mGykx1BCFTFtrP7xeUu0mkGw8C3xJH1E7m66/yz+b8zAMB+CcQqVA7Vwqu3I2j
	UKVJ9kgN0/9jlEXCuv+zWIFtzqfnvn4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZhvEP8kh;
	spf=pass (imf14.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776112335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NWH25+zbxJ7b6HA24/mMxvWwNWDzV+d0yyXTRBBCpp4=;
	b=ZhvEP8khqJ8gLbZ71HT/RpOt+5i2lN7OvPZSOs/lvMU7hgN42guX/14gaHuAuRwh7BslHN
	CC+H48izqxAAmF1my1VUY8Z7zXDoxiBJ6AfPYJ0EZT59ixJ4RMAmT3GIDV9IVL/CFHGXbw
	qaPaFyTiJt1mbHvVjjfJIY89ESxWqs0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-625-SE20wYBEPNyVkekYPqCLQA-1; Mon, 13 Apr 2026 16:32:13 -0400
X-MC-Unique: SE20wYBEPNyVkekYPqCLQA-1
X-Mimecast-MFC-AGG-ID: SE20wYBEPNyVkekYPqCLQA_1776112332
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-488e12db7e0so17696815e9.3
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:32:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776112332; x=1776717132;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NWH25+zbxJ7b6HA24/mMxvWwNWDzV+d0yyXTRBBCpp4=;
        b=THbO45TFrhYoEAaldOOuekzGvd5mfpsUTLrafAUQTiJajND0Gz/XHUXgQtT/u+l2ms
         AnBcU+VQwTQa+IBP1Fms2FPVXTpKNCa/3Vt5/9A12/lL5H1Dmckoaj6BIz6b7tF0lhvo
         TTiNvUDvdMglfNSF5PB44AtnUTzfR1CiHrJkrLmUiluGePOJBQ0zMrv5XH9m8TzMthm0
         Opii7l9xPn9WW0o7UBWHkrKoKKkKg/AUO92tu12IXOx1NN+5UdKhNRfKfWQqvecAx6HW
         dNuT5mktl33YaNUgluolWAldSzZ5tQk87Po14C+SmHK+JPoEPRCZ8yFY8gR4AqhaNm9A
         GosA==
X-Forwarded-Encrypted: i=1; AFNElJ8BLnOgsFM7FyAJ2ogd2cI3qVtaClebYEhs4H44T8zLvumP/VylDcJavozeyE1TdvVyyD1+tz+8pQ==@kvack.org
X-Gm-Message-State: AOJu0Yy+nwLuTkIDV06UNrhMKZETkp7RG36MFwB3qBIPF8gh5Zg/UKZf
	XiL2xmgTX6gidWoW+w1NIbYr9dBhwJqXRHq6lX9V6lhvOBMPRsyG2EvyXTQ7Ve9l4MbFr0eParm
	ApSA9wf12SgOwegQFAoYC2xMNS112BZLFyAYuDqIMmA4BCWi9mbO9
X-Gm-Gg: AeBDiesobesyiKSQJUQ5oSZjv2XdBPpizCrdNTtfJidIRLGZ5rA4k4W6EwAo6z8ksmy
	XLrK72YzC6bKyh1SAtGZBj6eg2YWmH5jwDQ6FTDPYA5Mw5V9/jBbkNnkNZhqb9e3bTCFyE2x7Yz
	73zwfW1Tt2tl6Lh7zEywS/quYS8yUuu4DhedhLazTNhaXB7m9J8RMuC7/nlwuRAvV/NEpqluqPE
	EV9DU2oQHAvzOtWpgq7Jd5VrAn0hGMLit9JQNmpV7By05w5Bgv63VLx63NdfF6o5fcqGA9jrXXi
	xU6ku08LyihQT7Z6F+u0voAz/tOt3x+inv1DdBgmwGFHZP8d+0nVPkMx3LYom5GOD0CoaNaDeO9
	gMHvX5/MtCMAwYNabfspK1H+ny6JcTIt4iC3i5t/CJf8=
X-Received: by 2002:a05:600c:4504:b0:485:3b9e:caa7 with SMTP id 5b1f17b1804b1-488d6864f6dmr201909215e9.23.1776112331889;
        Mon, 13 Apr 2026 13:32:11 -0700 (PDT)
X-Received: by 2002:a05:600c:4504:b0:485:3b9e:caa7 with SMTP id 5b1f17b1804b1-488d6864f6dmr201908795e9.23.1776112331276;
        Mon, 13 Apr 2026 13:32:11 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d5cf2e70sm177712665e9.0.2026.04.13.13.32.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 13:32:10 -0700 (PDT)
Date: Mon, 13 Apr 2026 16:32:07 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH RFC 1/9] mm: page_alloc: propagate PageReported flag
 across buddy splits
Message-ID: <20260413163104-mutt-send-email-mst@kernel.org>
References: <cover.1776033471.git.mst@redhat.com>
 <a74ad3652d9bd68c78fbb5360fa7adfd0606689f.1776033771.git.mst@redhat.com>
 <b330143f-f3aa-4f4c-8467-d91102094e8d@kernel.org>
MIME-Version: 1.0
In-Reply-To: <b330143f-f3aa-4f4c-8467-d91102094e8d@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1NeB_LCUgIJ1EV0WHD3Whvf-bzj1uCBJDZid3NKRmwA_1776112332
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3466D100007
X-Stat-Signature: 8i94swcztmarkyob1aa6shcof675rhe9
X-HE-Tag: 1776112336-177836
X-HE-Meta: U2FsdGVkX1/7EHlldqmcIQNg8kUX1sDh9YqJRZDjizLSkRnLghU/WGYpjhAzEwJv3KxhSSpX6pJYKYxwcjkZkgSbzm2jNnkh3G9yi+YS8MTblOvPkWv8Dl9HRkeBa/ChdLK5vrvKkLJ8RXu0bKkcBEgbFMLnBpHO5gaaVkDGgt5/eKHWXBZWhXi1sQ9svgY6uSxrm6w2XPbs7zmCj0ByiIyESMwhRM9VWEEt2YsiBaNA86JE4PG8xsWBjJpmDFEGF5WatMUr7Az6XlC5Wo0DtQI86Nt6KeU7njoIVlCNQcswRcoIvABnRfhP0QXbEzHMXFg6+7bYSaviSA98p/JsEJWEc72rt4GDLB4JVcCYLp/wujNa1IxWXEOQGsdXFEf+6U7bYjP+IwHF30IP8Pd0Oa/BB1DV8UhX5vCMVkZPcGGL3/y1pMSOihzE4pymoW5zqBkSqmADWQIKZ7Ln0WnXgNMzf3Ej6abf/1KOqM7pIASWavDaNI/ZqzI5VUC8MNL4ARngchgZprDBo/9S5Ka0q3e4+c5pg4f8nFod1iVUS3CRYzAUw4Rsm64GU/koB1FQyn5YUyL0OoWB8Tgzzb0bnFWa1UgriQlj6y45IWJQx0RUxkE7f/iXOvydG43FL/uMChwCB2p7GDSrvQi4I8lN576ckC4HPeL8xgbB589hYNzBMSO/nQUN2y8w+sUjzHj+CR9PVXVrbduUca6pPSl4GIcqtnD6wBVpTXpUY9lfq6Lk2neY+upXCYv89/UnJCRl4ANVIVJbPuEd/AbttScov7PXtNsn9SGdlMBIH2SZqob29VhzWiT9pImYuChuzyEHb7O6ajXdw2cOvsNqnjcfaMyyu7V06X+I57AwesyVMgGcEGM/MevZdiHWnKxJEd9D/lyH3SkTiiwZqwRfVIJhn2ksHRnzn+MUC5P1U4PYh0v3uKWfjENn/2CtX1hpxC1kLqdpA/MPIGUP2/b1JDT
 dru9/AV2
 zlkTgR/VASdVCZcbrdOXZXQlH649ssbH/7NzNrGtqFO1YfGf6iDTnxS9h2AwgxCNMHWY3PSPI1dQSn4nwbtnQXW6OxFDUpwya+WxctDwgo5lTZIwTT27Qx8NABM0f5AAgUt75ybcM+Ww+GP7Rbe6S3Tb6tmTWjrYSPgfV/lxHtIHjEpXv+UgWg98HCNzwrmXmPfm2/u7oyDIOGLl98osnNXni3SFHz2Ym6c3/Ll4oUVUEStWtLgkVY1I2uBjYCEvTvKlvwc7m9NiQ/7j+l2P8FWlXt3blj+CMMGwvybfdz+T2lHNyRmLm1ZxTki6IO48TnoEndhX+1lRp5ZbUYqw1610IxnlyOVqd+fDncP+mUQ4DANvr76EkXwRgRAcaqkmeIUjFZQqPxqyaMA5yig4TsMDtKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 09:11:51PM +0200, David Hildenbrand (Arm) wrote:
> On 4/13/26 00:50, Michael S. Tsirkin wrote:
> > When a reported free page is split via expand() to satisfy a
> > smaller allocation, the sub-pages placed back on the free lists
> > lose the PageReported flag.  This means they will be unnecessarily
> > re-reported to the hypervisor in the next reporting cycle, wasting
> > work.
> > 
> > Propagate the PageReported flag to sub-pages during expand() so
> > that they are recognized as already-reported.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Assisted-by: Claude:claude-opus-4-6
> > ---
> >  mm/page_alloc.c | 17 ++++++++++++++---
> >  1 file changed, 14 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 2d4b6f1a554e..edbb1edf463d 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1730,7 +1730,7 @@ struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
> >   * -- nyc
> >   */
> >  static inline unsigned int expand(struct zone *zone, struct page *page, int low,
> > -				  int high, int migratetype)
> > +				  int high, int migratetype, bool reported)
> >  {
> >  	unsigned int size = 1 << high;
> >  	unsigned int nr_added = 0;
> > @@ -1752,6 +1752,15 @@ static inline unsigned int expand(struct zone *zone, struct page *page, int low,
> >  		__add_to_free_list(&page[size], zone, high, migratetype, false);
> >  		set_buddy_order(&page[size], high);
> >  		nr_added += size;
> > +
> > +		/*
> > +		 * The parent page has been reported to the host.  The
> > +		 * sub-pages are part of the same reported block, so mark
> > +		 * them reported too.  This avoids re-reporting pages that
> > +		 * the host already knows about.
> > +		 */
> 
> The comment is a bit excessive. I'd say you can drop it completely.
> 
> > +		if (reported)
> > +			__SetPageReported(&page[size]);
> >  	}
> >  
> >  	return nr_added;
> > @@ -1762,9 +1771,10 @@ static __always_inline void page_del_and_expand(struct zone *zone,
> >  						int high, int migratetype)
> >  {
> >  	int nr_pages = 1 << high;
> > +	bool was_reported = page_reported(page);
> >  
> >  	__del_page_from_free_list(page, zone, high, migratetype);
> > -	nr_pages -= expand(zone, page, low, high, migratetype);
> > +	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
> >  	account_freepages(zone, -nr_pages, migratetype);
> >  }
> >  
> > @@ -2322,7 +2332,8 @@ try_to_claim_block(struct zone *zone, struct page *page,
> >  
> >  		del_page_from_free_list(page, zone, current_order, block_type);
> >  		change_pageblock_range(page, current_order, start_type);
> > -		nr_added = expand(zone, page, order, current_order, start_type);
> > +		nr_added = expand(zone, page, order, current_order, start_type,
> > +				  false);
> 
> In MM land we started doing
> 
> /* reported= */false
> 
> 
> This raises a good question: how does buddy merging handle the reported
> flag?
> 
> -- 
> Cheers,
> 
> David


IIUC it doesn't: reported pages are never merged, if a page is merged it has
just entered buddy.

-- 
MST


