Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11CF8CD8CA8
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 20:08:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50FAC6B0102; Tue,  9 Jun 2026 16:08:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E7136B0103; Tue,  9 Jun 2026 16:08:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FCFF6B0104; Tue,  9 Jun 2026 16:08:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2FA0B6B0102
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 16:08:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C8358C23E4
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:08:21 +0000 (UTC)
X-FDA: 84861461202.25.8743061
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 54A7018000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:08:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y6L2DFGO;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781035699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zl9Z0aJ29Hn9v0DTruTbP6W/2+UyB2iIzr0q5S84UYA=;
	b=LWgzZfeM5JzMq5Qol/ZxBQhm+h0o4sZt2tKjjvjmINV1ZnCLprNIH4UaQtqxgybaMXgN7P
	3caERYOH8TNnKb9r5j6GT61tpfNeuSG4EsZyOu48o/EiNA6zEYF/kRMFQOXlJTI8Z49YQX
	9WeOW+LZdr3xLDUHks07wd5qFsP1jKA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y6L2DFGO;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781035699;
	b=QTuYUU1L4LJyfXUEYH1xe13pv9THPFX2+PuPou0vedQsp1xaezQ9b1ns1jKG3GPCe/4wCW
	mvX50m7klPpyouYrVc3qnBNUlcvJQyTOFy3xTIbwsKj98AgnKj9Y5izBxcZ13uS8vQZ4kg
	5X/Xtht9/kQXG3Rqa4o+9mhiKyTw+NA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781035698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zl9Z0aJ29Hn9v0DTruTbP6W/2+UyB2iIzr0q5S84UYA=;
	b=Y6L2DFGOB5ovTYac4Ib5Mo5Ppk5YBvCkO0WgQb8r+OoqYmyG6Il3qo3HFb1cFSPjhPXYMG
	R4v9z8QZmDpPkiIdzvv+92vWxhODPrXkci6bjHrMbUHYltIQhCtuvZ4FSPUSzpr5bWggbq
	OZIfrXtB5oRI4QuLTefdE1GmxUHl0XI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-478-PKLE9d2HPYyludGQQJeUpQ-1; Tue, 09 Jun 2026 16:08:17 -0400
X-MC-Unique: PKLE9d2HPYyludGQQJeUpQ-1
X-Mimecast-MFC-AGG-ID: PKLE9d2HPYyludGQQJeUpQ_1781035696
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-490a786f987so65552075e9.3
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 13:08:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781035696; x=1781640496;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zl9Z0aJ29Hn9v0DTruTbP6W/2+UyB2iIzr0q5S84UYA=;
        b=ZgaxPOzdlbni8KeaQAAihVCmCxzTczDoKZzoutUlSckjF0WdkVTCAXaRy1Y6mDWYzk
         2Dg/XbYPHwE1/QsVW11w83o/q8d5UwFCbr8eblwruPAfkEEw+QXDRUpsTiaFyiKlg3N9
         agw0phLZ+F61Mr5+KZne5yiU4jZ7+fFWg9FbhYyk58t4b5X7uka5nMyYnOouB0upPuXV
         dyQZvccq5E1XgHPycTtTG9MIpltVbXP1Bf7u+AYNuPisQ94XkYjhRFCYVNErPo5Xzo43
         bF2F8/pVdq3eGdDwzUxCW1nBsBy17lPLiLybQSq4shIiXMFPpmn1S8J9vw/eUn6A+5Hi
         YItA==
X-Forwarded-Encrypted: i=1; AFNElJ+j0p6GyxoUi7mtXZVMMr0CKpVX3kw9QVS7qQO+hoIVME+ZnTwAMV4YAsJBWlvZsCBgf1sjuAFfJw==@kvack.org
X-Gm-Message-State: AOJu0YxQlZ0D3JJXuz0YPSiZYplTwKXR04rn8pmHaoBBxQYtbzxENhfQ
	1uCfmETXMAzPyLUglonKz9AATQfRr7/aBv48utzDMcmapICd7sv7NYChvx0rzmHIobVhOcgK/nN
	bGjo9G33/EDr/hLToNwyT+hKRQVdZrK2aUucTt3nFzdeeISG37ZWf
X-Gm-Gg: Acq92OE90MyyGUzTaTPAzAmqxmuzNAS3C67fqBePmpzo93bRE/rH9eayUc0tdELwLmV
	nBgxylGBqkiVdCXkpog7g9giO5wvLkyKjw7eIabvOWA05a8o4OrmKMCq554GIL4uyNlTF8jXHV7
	U/GvkTUc+mH5MrafVYyqkP4yy2j5640lWWjnrMn1hvEMiKTHcUzIzHROQ9JTQm6PufP8xFllRS4
	DuKa5e++vhJb/VfdNJjZSQbwo2lCoFA8lZ+qgdeOFLARdxhSWXfOtsk5y6/hX4tfyQNfYgY5VM5
	83xYklAtzhnxZGOVg25ZIyxOW4BR3k9SYppx4Kvo5z2qBRZRCFGcOB85VyNkn7/1k/MpxQKw/Lm
	BdbErjPa/vB8Ag1TDamHZgTlA4XzI+cJO8OAp9E+EFlpYwikAVxiCsQ==
X-Received: by 2002:a05:600c:8216:b0:490:c2a3:23cf with SMTP id 5b1f17b1804b1-490c2a323f0mr333475135e9.34.1781035695674;
        Tue, 09 Jun 2026 13:08:15 -0700 (PDT)
X-Received: by 2002:a05:600c:8216:b0:490:c2a3:23cf with SMTP id 5b1f17b1804b1-490c2a323f0mr333474535e9.34.1781035695117;
        Tue, 09 Jun 2026 13:08:15 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f345209sm68785532f8f.17.2026.06.09.13.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 13:08:14 -0700 (PDT)
Date: Tue, 9 Jun 2026 16:08:08 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
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
	Andrea Arcangeli <aarcange@redhat.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: Re: [PATCH splitout] mm: page_reporting: allow driver to set batch
 capacity
Message-ID: <20260609160506-mutt-send-email-mst@kernel.org>
References: <b25ea6c63503f24c8b5b64910a44dc03b5aa610d.1781020302.git.mst@redhat.com>
 <aihRBTaTUmgYmZfX@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <aihRBTaTUmgYmZfX@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tyiH23TC2dotoLUsmfCvEB-CrVzsMSIQ91EvcpwHDIw_1781035696
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 54A7018000A
X-Stat-Signature: ajns89o8sgehtyf57kc14sjaunpku3gh
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781035699-817759
X-HE-Meta: U2FsdGVkX19umqrFRe7M2gyHgDEYiLtyNki6rzX3ain2/nXn02kWqfn785zxErzgWwyU/cims3Dh710PJqCi4nDcPJcJ3gktmQRwXljYX0uoiDsDV7eUgYbW+1ZcvxauixD5limHI0/jMzbv271oIBy3Rz5yQpcj9FKrXMcnL1rdJJtZDAq7nUIvnbLEcVFG75x4R2/Y185B9mYvKtUDoucR8ffu3/xdF2AiKcsEgW0j9Y+uCAEfLFUij49YyYUS9fQrSTW/M6CJPnJhDc8CFff4qF0kU/yTOKOAIF2XAiJJDOPEToPk1hek5bNO4tEuZivR7QYa7+/vNdwNKyq13od5++0fUnlDmcL0v+E5ui3CYBuv313soLRi9s/DO6EjN9B5Uq72HfvdgULRJFyLKYJTvOit0w4NxnhU78AsqD3TUEm4HE4LmiMCR3Usw9+5yH2QRp4oP2UN7L4+/SSSUjtsQ2gVrkhwH/ZAZ+Wf8/3LhCe/8HaFjSGPAZ9JlFHUqPYFnULHgZQyS7i5t1yl/XMQZFDACDMsqs08Di8o8+G6MyriHG+s/LY5kON3VCuZ+RZ8mbcPOjmZ8LJv5Swgw/XuwBJYpFSPeQEhkG4aKkpl9mNImBZ7OEERc2lT8O7/DPpgJ0gTeSPWOa2BXKjLw+5vpSnMzWqCgcxwMg0xFlc0GW+EHkBdrgwA3fp5vHomsrYaEBr6HYEcIpuu61Fy46v6A4PxGiP0LJ3/5dOs5gChUsGCy5eEKJ2ZbsqaIwtIEfhuwsGi4yBP7jz2xJOPG1GThB4/91D5it4AKMdmSjF/zdqmmdUzJ9UIyyl23KulubKuEUrw9GTtxMIZ37wUkZnMYx0mdpxrn9hiN1Azd82Pq0HslVh9so6tXPZjYCSPZkKk2nLBC7kJG0DbDA5YrwBkyg6XXVYPhPi72q5RnDKzGmG76wesASOHzNWYqcd0Cu90zazDoR9ROA7SZd8
 QaGq4NEG
 kQaWFfASzZEX17qXVucWT1jPIUtrnw6ou+HdZR0wZ2+ZXn4S8R9CDLR55yhgSNV/NAa9ZP9xuUaz+4de5EnSh1nFgghIbaiMUWFzykbTQz2UHnxnVtI5ue0n2GiUZ1mHLbkEnmAifUiaiKPJb2sNv9xE0FCEZHdkDwQVC8Mp7qm3aLHwYDfTJLbasUOh2LynIH5keUBOxYrCfJBpEvPAgcO3ws/Pt+xOx9U0p1/7H6QDSbo8EdqyNX8BQTaU6OUwjGIpKoNk0JbS2JeUu4fXJR4f70UiS4U28vytvv9rFcnNsgYvVwIPERcmvLq2PvGYGfPj1aBLxT7SO7j+C3VPNQKiZGHowFgVfR8eqQ+qZmCXOpmFo2yEO8Dkf0brE+bf7Y4QZaZJ7JIl4NcEcvGQ7iak9Qnbni2W7F1gfbIshZyJhiYMuN4lSDIkG9qDZw82/5ZtRwScnibRPBHZXRDEP52//PGM0dMx2uTxo4BBIsupai27TKaUpwPn1RB4vTWnvOYMh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 01:44:37PM -0400, Gregory Price wrote:
> On Tue, Jun 09, 2026 at 11:53:20AM -0400, Michael S. Tsirkin wrote:
> > --- a/mm/page_reporting.c
> > +++ b/mm/page_reporting.c
> > @@ -174,10 +174,10 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
> >  	 * list processed. This should result in us reporting all pages on
> >  	 * an idle system in about 30 seconds.
> >  	 *
> > -	 * The division here should be cheap since PAGE_REPORTING_CAPACITY
> > -	 * should always be a power of 2.
> > +	 * The division here uses integer division; capacity need
> > +	 * not be a power of 2.
> >  	 */
> > -	budget = DIV_ROUND_UP(area->nr_free, PAGE_REPORTING_CAPACITY * 16);
> > +	budget = DIV_ROUND_UP(area->nr_free, prdev->capacity * 16);
> > 
> 
> Initial look - is there a div-by-0 here?  I noticed the old check
> prevents this from being (0 * 16), but i don't see (on first pass)
> the same check anywhere.
> 
> Unless this line below always forces the above to be a
> PAGE_REPORTING_CAPCAITY if it's set to 0.

It does, does it not?

> > +	if (!prdev->capacity || prdev->capacity > PAGE_REPORTING_CAPACITY)
> > +		prdev->capacity = PAGE_REPORTING_CAPACITY;
> > +
> 
> It's worth making this corner condition a little more obvious.
> 
> The code intends for 
> 
> if (capacity == 0)
>   capacity = PAGE_REPORTING_CAPACITY
> 
> but that's not reflected in the changelog as a default value.
> 
> When happens if a driver sets (capacity=0) either on purpose (???)

what would the purpose be? if you don't want reporting do not register.

> or
> because there's a bug (???)

exactly ??? since where are we practicing defensive programming in kernel
APIs?

> and then page_reporting.c forces it up to
> 32?
> 
> There's something to improve here.
> 
> ~Gregory


So I'll update the commit log to mention PAGE_REPORTING_CAPACITY.
And maybe a comment near capacity field?
Should be enough?

-- 
MST


