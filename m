Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ECB0CD3447
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 19:35:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A075B6B0005; Sat,  9 May 2026 15:35:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B7A66B0088; Sat,  9 May 2026 15:35:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A6296B008A; Sat,  9 May 2026 15:35:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7534B6B0005
	for <linux-mm@kvack.org>; Sat,  9 May 2026 15:35:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E987140261
	for <linux-mm@kvack.org>; Sat,  9 May 2026 19:35:28 +0000 (UTC)
X-FDA: 84748885536.13.958D328
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id B7086180004
	for <linux-mm@kvack.org>; Sat,  9 May 2026 19:35:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X8bYcSra;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778355325; a=rsa-sha256;
	cv=none;
	b=eOG3DVYrqVvwkv4jELoR6sDnF2asIKqzXZ1p5GJCboh7dBW3Zle1DC6OuAMJ31oPIOGkRE
	AfQXl/n+iTMoyR/b8H8sU5nunKkVHxbi+ewNMGlU5iJ17yUbpFJJtdISkIvlE21YrYVs7x
	ZLAYV+fgRSGPlJbZVv5SAVc7VdUUdsY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X8bYcSra;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778355325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JgaTNNWn/gKwcOXFu2ZjkcVejLP2jhNPD5DFZN/synI=;
	b=T3h+lIMcmdl9FSwb8WZqMBfrxHYpbETtM21wzrPSoY0RQt49uWz6NlhC5c6ssU3FidWlW5
	Fa4TcN6PNJ2hU6uV5nnwkgZ1Yjsf3495p3xoqbV1WKYVM/Z4yql9Hw/Aa3Zp0tF0kF7NvG
	jYsjE3Z3r9V0k321oVCwGxnISydcv2o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778355325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JgaTNNWn/gKwcOXFu2ZjkcVejLP2jhNPD5DFZN/synI=;
	b=X8bYcSraIap4qurlsvVYMWe3HB4HPMm/XIRWlpO98uY+UnvntRBKGvisB4E5HzCxMO9p7W
	6sR8hTDLiCHGYWPTuxQDeXLfGeJVl40JYu8wJRBk9USUG2TTMYWSVlYgdWACPZ5hRg8gpE
	JmAfJojJWq+4lcs36VeLtw79q0+ZcNw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-190-LhivFuUMMIOGOp7-26b4xQ-1; Sat, 09 May 2026 15:35:23 -0400
X-MC-Unique: LhivFuUMMIOGOp7-26b4xQ-1
X-Mimecast-MFC-AGG-ID: LhivFuUMMIOGOp7-26b4xQ_1778355322
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48a589c7879so31739085e9.1
        for <linux-mm@kvack.org>; Sat, 09 May 2026 12:35:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778355322; x=1778960122;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JgaTNNWn/gKwcOXFu2ZjkcVejLP2jhNPD5DFZN/synI=;
        b=niUhBodYaZuI8dugbPqDG/JqO2xKqgU3/yYzzcLCpfCiGVPXvLteBeDq8R0zCdRpSI
         0sKGt1w8tD95MPUcCS+aqeTbo6cEebWlgPXBfRWIt9iitilWRl0oaGd+gP+xiUK6U1Ri
         JPhAtmpnuwwABO864/12BuRk+R17jd8aW4QMhYY3G0Go28A4I2n9dObRKkBthfhkFGsQ
         i77aUj2u51yzXlWgKmQ9dnIRpJYKnnMgmXrrBni0MLUmsypAC888Rzu2RHNpi2A/v04S
         nTin3DGamDxWQr7JNDzH3eX6oG7AmNInblFl3c/K6zoosWxw073NA7ROjQDBYOZxo0lF
         vFqA==
X-Forwarded-Encrypted: i=1; AFNElJ9F8IuoxIz5o20tSLWkQ+LTzTUqWfAZhgB1Suu13NQ3uR1pvDg5nR5aaQWf+WLhQWSjFGekKnsY3w==@kvack.org
X-Gm-Message-State: AOJu0Yxgf3ZpuXyLw7lz9oF8PKzJQcfXXCM7StMEQ1Nj19w2nEmB8xT3
	cF6xZsdekIReOnnYEf1OX/7oB8eZEfecsOpONi/haunWyfy6W4EaWIcKeWDzcHI1tC/+/Q0hDBt
	nFdDLsQqtGQ0oqKGH/23y5YTtXev08Lwn/QUEoAqAZgUhGFJQCWXv
X-Gm-Gg: Acq92OHCz46c3nXbI9I4cbeWJDB75tDOOojgKRUPtajWzOTYeuNzdRZ08RnpogXFr6J
	RmfDezu+13xVpsw0pKP/mygG4QwfzHz6oZBmpE9HMkpjxj6h3ZNdDjMjWcKxqrWNYnOiF4gdwnO
	4eJFPqXosi0/H/iewAwDfU693200aF67o0yTBAwwzUOUDkQCm1zrkvNLhRxjXTDUSxItHicBz9/
	A+6s+ONDCh5cKmZS1rW7hRDsX0LO49AFPfiKCurmK6wZ7M4eapcgcXskJmnPa3TSxN/rjOuqxgF
	sWoLQFT5buNNJ2w3ilg9DCUhOfFONOKtn2JvCwGXx5toegBZqvpw78thdbFHQsxd1Urc/NqFqGE
	hjW3OHPf1rE0UfVGagDRmmvHBaSIWymJznHwzP5IR
X-Received: by 2002:a05:600c:444f:b0:489:32b:ac0b with SMTP id 5b1f17b1804b1-48e5dfd6a6amr184198815e9.6.1778355321787;
        Sat, 09 May 2026 12:35:21 -0700 (PDT)
X-Received: by 2002:a05:600c:444f:b0:489:32b:ac0b with SMTP id 5b1f17b1804b1-48e5dfd6a6amr184198375e9.6.1778355321211;
        Sat, 09 May 2026 12:35:21 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e6d8d6988sm27079425e9.5.2026.05.09.12.35.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2026 12:35:19 -0700 (PDT)
Date: Sat, 9 May 2026 15:35:16 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org
Subject: Re: [PATCH v5 09/28] mm: vma_alloc_anon_folio_pmd: pass raw fault
 address to vma_alloc_folio
Message-ID: <20260509153434-mutt-send-email-mst@kernel.org>
References: <cover.1778192416.git.mst@redhat.com>
 <96a2f5a938bf65315ac95e75b4e7741bae018cdd.1778192416.git.mst@redhat.com>
 <db7cc3a4-0070-47b3-bcf3-540d0e9d3baa@arm.com>
 <af3gUBSl4UQ6NfVp@lucifer>
MIME-Version: 1.0
In-Reply-To: <af3gUBSl4UQ6NfVp@lucifer>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: D1oSaOflawlXSnj0Jwz8plh2MqNMmhgS4nf8XWzZgIo_1778355322
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: hhyad8kzoyu8xk5x4thjqr5ycur8b7md
X-Rspam-User: 
X-Rspamd-Queue-Id: B7086180004
X-Rspamd-Server: rspam07
X-HE-Tag: 1778355325-485444
X-HE-Meta: U2FsdGVkX186bvPfnYgam6J6wxzW4zWj5HUW53fUlCDsHHT888fYLPyB4IoPDde+GBGLE5VKO452Z6UuR13A5d17MLgNp1H4xGRTz1so+RzvEzNSsn9FvAT8IylC/yd2PVsHoEkz5AelfbWpRxAWQu1QxtSGY+HOoLNaUywJQ57Gn9XgWAiqZ/UlSBiHrOxTkyBSa3fP3T3pUrCMmTSAiaOoGRwwUDGjJTeIBCXvPnlLFEdStbcONuZPS1iReEP4jONv9i4oHIYx6oPhIURaAnMiJaiLyClJtd0eHxrJg5AmrsStn1iYP0JUPzpgOcKhpv9rZGVgWthbRYYvJQ8LJCpYkeA1xeX4E2l9Xjnb0kPr1BClaT7QiE+VKD5wrOEvPZgMnr3IK4eRnWsjJCfERYN/BgFRVSO5TYPkvA9VVax3bxQ7hR7i5AuoMVH0+WGEGCyM1NRgARP8ApyZ3l1Jjv28vK9g4tKaMQ8eGZnIJq45ZdxwNpxBsa5tR7wtdR0COjBtxW5vSe0OYrExmMkSAGwPdrtzy1AqGEoH+A5LuO9+VQLt1ntwPzmEpplYjK1Vm89RTrxxhlUXcIENnw6tTHvjVcN2mFwy9szQV4s/xgOhQrSlmlWCMXDEBWMYxOZH48sT6zOOV5PCCGsrYR6FLHfSZSU7STcq4gXTtBWOWG9J9wKWLhHqGbxlcwGMcDhQFzMNyGV+872yvLzqQNReepNqMVstjdiRuXRaRjs3Y6Rbbc/Nx+ojYp2qZRNsIF6/quBm2IccvzmyLoVs1lZLw3MZ2lxSdIe37yf9AgvwOjbK2PWog5ILCBIoPcrCJT4CEtHKA3pT6kwDeakjGzApBvZmNlk/WU2jwsCVCCz80FDCFpe13G/zKIBZCATZVLw4I89xFvikgJAA5HvTgXiNDlJfDWB8z2H9DjTMQpwBMgSH/H/SUNcqhT028vMEkh7HsdJY+oFF/5o56ELtRCT
 ISsP0bW8
 MS6UUYA7xteV5loudtO1ZtCpE31dOhw7eUj20FAYYXx2YPFPCQW2hgjmal45CMQZFcqiDf4aV0uqO7iM8sBDWoXf+FF51UQCJQFoJ1CCkm5IVT0ZkFQ7gaM6SrLs0qQWLmxEeyEePUJh+Rm1OedAPf0aTR6tWPVraZPXxIrm3J1S4pqgA3kwShy7LNbT3imlHaYcxk7o08rZ1pyVLApaD7n5PqocmXzjwJVShxznRrWSndtnW/P3nTheeyIuRRJ5mq4uKxQHFBBwoaAFcNAwImFkDEbyMLPWGiylEh8gZHVaXxJbylhH1W1txz0V0d0BWbNvHu5OYsleeZWLQbgkRhcOSy/BWldDjWNhtPKa/LWUoSdgrJTGlIKtecqlL1g765OtEOZT8zK4yQyrKrvCsYZiU3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 02:12:00PM +0100, Lorenzo Stoakes wrote:
> -cc incorect email addresses
> 
> On Fri, May 08, 2026 at 09:06:22AM +0530, Dev Jain wrote:
> >
> >
> > On 08/05/26 3:52 am, Michael S. Tsirkin wrote:
> > > Now that vma_alloc_folio aligns the address internally, drop the
> > > redundant HPAGE_PMD_MASK alignment at the callsite.
> > >
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > ---
> >
> > Hello Michael,
> >
> > Could you please send the whole patchset or at least the cover letter
> > too, to everyone CCed on at least one patch? I only got two patches
> > from the patchset in my inbox so I have no context :)
> 
> Please resend this with the right people cc'd on everything.
> 
> You're using an out of date email address for me and Liam (at the very least), I
> mark all mail that ends up at the old address read without touching it, so saw
> this by chance only.

Donnu, I just used get_maintainer.pl. I will look into it.

> It's been a couple of months now (predates this cycle) so I'm getting a little
> less patient about it, people do change their email often enough that it's
> something you should really be on top of for a non-RFC series especially.
> 
> I co-maintain THP so would prefer to see this in context please.
> 
> Thanks!

of course.

> >
> > >  mm/huge_memory.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > > index 8e2746ea74ad..f51c0841ce91 100644
> > > --- a/mm/huge_memory.c
> > > +++ b/mm/huge_memory.c
> > > @@ -1260,7 +1260,7 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
> > >  	const int order = HPAGE_PMD_ORDER;
> > >  	struct folio *folio;
> > >
> > > -	folio = vma_alloc_folio(gfp, order, vma, addr & HPAGE_PMD_MASK);
> > > +	folio = vma_alloc_folio(gfp, order, vma, addr);
> > >
> > >  	if (unlikely(!folio)) {
> > >  		count_vm_event(THP_FAULT_FALLBACK);
> >


