Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AA46CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 15:34:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A846C6B009E; Thu, 14 May 2026 11:34:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A353E6B009F; Thu, 14 May 2026 11:34:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 923A56B00A0; Thu, 14 May 2026 11:34:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8393C6B009E
	for <linux-mm@kvack.org>; Thu, 14 May 2026 11:34:28 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 15B948DC92
	for <linux-mm@kvack.org>; Thu, 14 May 2026 15:34:28 +0000 (UTC)
X-FDA: 84766422216.23.06AEAD9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id DFDEE180004
	for <linux-mm@kvack.org>; Thu, 14 May 2026 15:34:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZberkJql;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778772866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E+CWg5lxx32FMjsqcYIsFdKwXQ5ffiqlurIUVj9N3ys=;
	b=1fGXxi3gflLYGkAhHRA4uYwh8UixzmtWKjSe0ERu/G4lBE7ClQMhwqj4xpQCVBP1tlxnZD
	lxdwAobaEw7vPXSr3cUEvsGPCidi+K+pJgFuV7PlXa8iCTZI4IYsQUMoUyXFxZ2ktTALvY
	jzyWsZ9Z37h6cz2YMQIgUB676P5kwvI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778772866; a=rsa-sha256;
	cv=none;
	b=KWSsPIHzLvX99jZUVKAqTTGHrqTLG5IaQMz8ObgyIBabNqZ35Ve4atsgjPeHlKlYe/mjmX
	Es3UzK9QgWMGdYtKVxvLb5gf2TZTqKGGFT5XjZzXqoEwdHXbqysYZwIty1HD33Gqf+aA+A
	FkQzJvs8YDp7TMNOSbqMfagSalCDUZs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZberkJql;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778772865;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=E+CWg5lxx32FMjsqcYIsFdKwXQ5ffiqlurIUVj9N3ys=;
	b=ZberkJqlH3gdIdfD0S9VGnTFTct+76E00n0bxWjtXHpJ3QLHaMrZFt9hBcKPv+5pK32I4B
	CAk6WJhiTBj/Yk5AWxgbZdEjTaz7ZhX43WZS2iNtO5/EPi3jr7v6/zbA7fEET6prMlXVlH
	bk5L6Q7YDR65zK2zHyoslx8uEvRhfTk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-vtCRCh2IMwC6n13gfVWrHw-1; Thu, 14 May 2026 11:34:23 -0400
X-MC-Unique: vtCRCh2IMwC6n13gfVWrHw-1
X-Mimecast-MFC-AGG-ID: vtCRCh2IMwC6n13gfVWrHw_1778772861
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48d144d3428so47678845e9.3
        for <linux-mm@kvack.org>; Thu, 14 May 2026 08:34:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778772861; x=1779377661;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E+CWg5lxx32FMjsqcYIsFdKwXQ5ffiqlurIUVj9N3ys=;
        b=WupaU9HeYN/Fi0FKIjh7hPfn8n4x+0aQ0YLMLJTdMoc8Oq0q5MfvitrnmzK4g4hIci
         rE9aEqBv9PbyQBlbcLNR9JCtJoAgG99/kf7kxrg9PKPp1yBvR8KiHw9kxB23rN/4NRMq
         XTCAgisgm+cUNZk626abMsqAKoMQzOfdwc1WVP7W1SvJcODMAih7MNNuGHjzGvwGHgHH
         3VTVcCu/9uwQ6UmYVjnoJHz5zH1gn/SId6eRI98jnm23ri3C54AYkR6iYfUqotp0QR4i
         m5vQoyOLyQLOz51ZNzaOEeILt3u33XC1f+5k81N2h1XC0E0g77BqDCGA2zyEhwfORn8h
         Ikbw==
X-Forwarded-Encrypted: i=1; AFNElJ/kwR6EG+lGrCkIM8LGdQm3jVmOGwnIcSEoBgBpKHF/ciITIKjoJdDmPJZwsMNwPYJpHQMH1kQpvQ==@kvack.org
X-Gm-Message-State: AOJu0YyQLjLsD5eR0GNuYrDdSj29fLzG9AZwBAJ0OzolbeIkvcVsJeWt
	Grhuy6q1Fa5nPfAg6wiG1v1dPwDVfNON683Iqc7pUvW/C7B4Zz/Xd7rOxHiF11dRFvGtzDhDaLT
	BkbtC6jDs9KxJzQ3tykLffFlf9FSNfHz3oaMdDbL49QxNlkaE7A0i
X-Gm-Gg: Acq92OGBDnJJfcy04yAm6dxd4OQBnwZBCdm7DtwYYth5EhBZEC6QQHs1WDGMR8JV9Ur
	8/RQ4pJGhFaoW0e6fZztHcM0+6rcF7vg8vd6Siebu/5kaqy0u6c6FmWUbVbEKEakXmDGUFFppCz
	zRcQ0/V0deAlfoEbuUDlaKmH+tNgXyDU4KCv0M8fekJO7fm0i2oLkK9N939hbwRvKB/U7iPpOql
	Putlsy2ExlMa7o5Ygb5KRzx28PbWp+XgdtZ/CsOryhwejp5VCK5GHYYUt7c8fnZV7MMFqSV3/UG
	6i77h0swuAz98yMq057F6/UceOfhxm6FJIeWK5V2t/VRZsoT7wn83kKRGzMcgs7CDFsVBOuksDl
	h/Yksw0NJyL5CyUwgk1xvlz9nm8VkmfmHuySdInWf
X-Received: by 2002:a05:600c:348e:b0:489:1f97:6b1d with SMTP id 5b1f17b1804b1-48fc9a5b56amr127677505e9.28.1778772860705;
        Thu, 14 May 2026 08:34:20 -0700 (PDT)
X-Received: by 2002:a05:600c:348e:b0:489:1f97:6b1d with SMTP id 5b1f17b1804b1-48fc9a5b56amr127676625e9.28.1778772860100;
        Thu, 14 May 2026 08:34:20 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fdafb6145sm33187345e9.1.2026.05.14.08.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 08:34:19 -0700 (PDT)
Date: Thu, 14 May 2026 11:34:14 -0400
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
Subject: Re: [PATCH v7 02/31] mm: page_alloc: propagate PageReported flag
 across buddy splits
Message-ID: <20260514113337-mutt-send-email-mst@kernel.org>
References: <cover.1778616612.git.mst@redhat.com>
 <feab82b370b3e66b58b9cfbc1efaf26fe6061d2f.1778616612.git.mst@redhat.com>
 <agW3JyLAwVsCZ2qR@gourry-fedora-PF4VCD3F>
 <20260514104735-mutt-send-email-mst@kernel.org>
 <agXrCinY2HmJmhT6@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <agXrCinY2HmJmhT6@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 59GagdLXXxVN5xX-dbSVbThs8f5nSOArkWJe--LM7G4_1778772861
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DFDEE180004
X-Stat-Signature: rmsj8wqwacf7419me7egozjn4hnzw9jf
X-Rspam-User: 
X-HE-Tag: 1778772865-486999
X-HE-Meta: U2FsdGVkX1+P0nekCfdQn7VSCRAjyw73gtkqZMwNaDL9ClauTpC0PwHDAmJC0rHCSK8WfaZER+lpHXv/PaOR33zfkcJ9jDMAuC995vlDRxAGOfHXjU9RAmpL/bt4rF9lNqf8uXmKXwf/SA+Y47QTR/wz/6P1JLqIK7Paxsv1NZDjCLJF4A1QOT1Lqz+u9NtxZtdNwhLBLX9iEebk+bxu0rttn8vo+IcE7FOzlzPa+4CN5NZnLRoPYqYnA5vISChnxKMASySwvMZJceb0EF5stcdGODDe8ECqKY4pLvPvYfJ3cw75x0UdKtc4LAlo18Ft7ItDDP23UQr9MT39P1p9FvJGXP5AakvGzyfOo19c6UOV8F2hGoNQA4Fh7RZfhMkUK0iMPLZ86i6TgWt1JC1agpPhGNivw64KlkYgHocAJ/URjafXzFFnfPpWt+acywiucVpbyIewsr+DXwaa4O45xQfn8oTOrx/o+z+YRuSruRvWPhvEBWGS43HeVccscPeFASnXsqqt1HfjzZtBVsZKDYUUvbb3L43NxDkajnoC0BKWyyigJYPCETNWjtc863CMV0Pa9ir9P+avg2curIqKMG3fN1fstFrZBl2HCs6x8Ys5mD20PfmBjJA3UlCULE0JBqMsRGHiDuxULBZ7gU8iulkEIJgDXuNG/E8GiVJ9o5fZqTnzFiog6CTMkEwc+eUlIVFiEdwEAarAABA5dHFFerCO0lvoCzDSvgSAPQKnW54Ec341dOoCqdGCc3Do6OWNuT8ptUPo6C2IwTNFVDnIx3TGCIUKw78wfqjQmO202Nm61+0KKZf4NQD37F9uoJtlGPuF4NS/cMMBQQS0AN0Il4AMZB8wVe2AHfwhAvz1mfSJliMNGiNv8YsmlXBHKsUgwBhX1OzL9ZEOyNUSKVNdy1eauxx9Sa/fd/LHlEV3yQlpyGPFhJZ76YDG8fIcefpUse5jbgRguLSUtCtn6P2
 FP7dRHnx
 hIh1AvAjg0bYkv/VWwjlyN1wpoRizZe40LJABUhuzLb5+Kv6agMgJLIBPGu1trCHKGyNJ1WHeyqTdc4X9PQMhF3e07iTnmZ4TPFUMv0KOzrtD9Lv5Hlq9bCBqBhsYicUJRF2Rf+0hLDqCifDQ2++f1w3xZPFDlzWGS/xA2iixknTaSjbhlBx9m7+zKWo5/LrMhWV03AbnK3Eoh55BzHrCFOLDk/HzeClZIu9WUIBHyB8qPv9/G4KZKwzqlHjmeO674DV0NOrT0PJe8WeK1aNIldSepSfMM6395TAa2IgXMLTNL2bMz2iiwFvzoXo2fMAzacdjC6/90f9g04ZrkszVHlRnDtnSIT9KfimUXMaRwktPhE6TFjaY9t/ZPKrn0GkvNGj3ferXjI9zCF1VvOD6QawW+qRZ7FHIvL93//dc9yVJcgNRt+4G8doeLeTo4/KeXzKbfC5TTinBuNwZ4y5ui3pmCIo2Gm8T/S3euMTftX+Ns5U8zG/ueTNh4O9km4V/1wjSr+OQeKirju9lkizzK7z9b3T8Eho4FUnwsgTKdbht1sM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 11:32:26AM -0400, Gregory Price wrote:
> On Thu, May 14, 2026 at 10:48:28AM -0400, Michael S. Tsirkin wrote:
> > On Thu, May 14, 2026 at 07:51:03AM -0400, Gregory Price wrote:
> > > On Tue, May 12, 2026 at 05:05:16PM -0400, Michael S. Tsirkin wrote:
> > > > When a reported free page is split via expand() to satisfy a
> > > > smaller allocation, the sub-pages placed back on the free lists
> > > > lose the PageReported flag.  This means they will be unnecessarily
> > > > re-reported to the hypervisor in the next reporting cycle, wasting
> > > > work.
> > > > 
> > > > While I was unable to quantify the performance difference, it is
> > > > an obvious waste, even if small.
> > > > 
> > > > Propagate the PageReported flag to sub-pages during expand(),
> > > > both in page_del_and_expand() and try_to_claim_block(), so
> > > > that they are recognized as already-reported.
> > > > 
> > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > > Assisted-by: Claude:claude-opus-4-6
> > > ... snip ...
> > > > @@ -1731,9 +1740,10 @@ static __always_inline void page_del_and_expand(struct zone *zone,
> > > >  						int high, int migratetype)
> > > >  {
> > > >  	int nr_pages = 1 << high;
> > > > +	bool was_reported = page_reported(page);
> > > >  
> > > >  	__del_page_from_free_list(page, zone, high, migratetype);
> > > > -	nr_pages -= expand(zone, page, low, high, migratetype);
> > > > +	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
> > > >  	account_freepages(zone, -nr_pages, migratetype);
> > > >  }
> > > >  
> > > 
> > > Maybe mildly out of scope but worth asking:  Are there other flags that
> > > should be retained/propogated on a split?  If so, rather than pass
> > > was_reported, should we just take a temporary copy of the page flags and
> > > pass them all in?
> > > 
> > > ~Gregory
> > 
> > 
> > Not that I can see, no.
> > 
> 
> You do this exact thing again later :]
> 
> https://lore.kernel.org/linux-mm/9a22e0f9bbe1278913754db6df76e291a006181a.1778616612.git.mst@redhat.com/
> 
> ~Gregory

I mean yes, reported and zeroed) Just zeroed does not exist at this
stage in the series.


