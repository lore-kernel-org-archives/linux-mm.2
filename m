Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BB30CD5BC0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 04:12:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E5506B0093; Mon, 25 May 2026 00:12:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BC206B0095; Mon, 25 May 2026 00:12:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F9AE6B0096; Mon, 25 May 2026 00:12:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 813E16B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 00:12:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1DE54C0210
	for <linux-mm@kvack.org>; Mon, 25 May 2026 04:12:19 +0000 (UTC)
X-FDA: 84804619998.23.C215AB9
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf04.hostedemail.com (Postfix) with ESMTP id F423040007
	for <linux-mm@kvack.org>; Mon, 25 May 2026 04:12:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=fZBMo+up;
	spf=pass (imf04.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779682337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d4pckDZxFf8QRPUPkIBfBrSh3CifT/9MSlxdT8SrZTU=;
	b=W5RuDvJOWMH8s9bfXaogviAdDVEZmxkKdvOly7AF4lnwGLJFhnQRVuxi7K+7Bw6yiiqzXX
	XiRvU9c7v5+owP8Nwa7DDTgMvt7z2M6muG9HUSuaIFip1JhMDtauPgpiNo7+GtsoOlwkAQ
	ByHX2I6F2+0WcGXdkzonEqrdN58gKiA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779682337; a=rsa-sha256;
	cv=none;
	b=LiZsn5RENLxIOG4Dzi/vPn7R8wFfwoiEOD4BsE1w73S+3fn1nn1/Y7UnPiHK1ERe57bWjf
	OjLEN4MpGtwqkCf2oYb2Mv8xOn/+ElE3TQ+S+3bMhJ0lPPBGhnDz30KJ3NxYS4UsAVpEQK
	e9M/XEtsblGJoOH65/Y2O8BSllYyFvw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=fZBMo+up;
	spf=pass (imf04.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779682326; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=d4pckDZxFf8QRPUPkIBfBrSh3CifT/9MSlxdT8SrZTU=;
 b=fZBMo+upVfv435usR0uWrVYcXDqQqCgLmm4Lwyi/S3s0dxrsKIQOaFE8f66+KM9MkuSnZi
 59V5kATwtCzlw1nH8p5Ibu/JF1Aqu240L4ip3jEhOe9b0zHhwgPWwGp5hlD4Ry96LedkMx
 cRxutn0ZDyEykK2nv84A8fXBWuOiF4nBZ5CDO4TQhY9TKoWAk/7iPObzoEIHSqP1rE/4Cc
 ajRX5kjrlGNyBepH6Os179hlIDMcUx92LcmGPv4nCJfyh1yR5mSKEd59fGXKAwZyOxH0UQ
 HgZ/jNN8GCEPZ+/2xEKgne3KkdXGiwVehuNgWFxE3JNM9zIeMq8vxseIuZjDPg==
Content-Type: text/plain; charset=UTF-8
To: <rppt@kernel.org>
Date: Mon, 25 May 2026 12:11:43 +0800
X-Mailer: git-send-email 2.45.2
Content-Transfer-Encoding: 7bit
In-Reply-To: <177953825220.3959652.6200899011132427221.b4-review@b4>
X-Lms-Return-Path: <lba+26a13cc15+98272c+kvack.org+lizhe.67@bytedance.com>
Cc: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <linux-arch@vger.kernel.org>, 
	<linux-hardening@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <lizhe.67@bytedance.com>, <mingo@redhat.com>, 
	<tglx@kernel.org>, <x86@kernel.org>
Message-Id: <20260525041143.97194-1-lizhe.67@bytedance.com>
References: <177953825220.3959652.6200899011132427221.b4-review@b4>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: Re: [PATCH v2 4/7] mm: extend the template fast path to zone-device compound tails
Mime-Version: 1.0
X-Rspam-User: 
X-Rspamd-Queue-Id: F423040007
X-Stat-Signature: ucc3kp3keru6yjhi3ftor73dx6367m9b
X-Rspamd-Server: rspam06
X-HE-Tag: 1779682336-182521
X-HE-Meta: U2FsdGVkX19ELdYyXuqDq3ro2v5S1PdruFlTVtzX/k0MdQBn1+eaUhsDt79KOq1Q1Fgq9DM6eOECowasagMTctVmhfLD6sx8YesKccGBJ8HBkgvtyv/u5JCCtxTxAO1Xwd0XKQvZaTugoHer6rdobd4yQrHM5Qmpcnb1H/tYpGW9CkO4heTNtXyEpE/MSuSsJA799wU+idneb3VNMtGJu1ppEo4N2/u+Rv03HHbY+9L+ioR4RVsWu+9LDQkHZOCaU6skVqSECe0AqviCA+WYC6fJ5O1bh5E5Qn/rqXQ/FnMkJma8x3Pgg8PpL9xJyYWxbyOeZr98kFFLQRr7mANI44ytp1shVfyyw/tHOqWuilLo0ahTK8oTYDXUro6+lHQ6KZn3L9cUKAa3c8huecBkfe2GBZbW6TTg1rUlepkfW4bJ9bzA+Xb8H0j+RhMbtF3UIlrFqYbh1nFEwy/LE/jBgxBwPgt81ammDxGY1vUBdDvJXvMNURuWs8V7mmuGJZ2kDBoa71WDCXoH1xHBMqQOv57h4Pn4ShgouhKi4b4OaRKPHA28HMBucIKLCtL9hTm612ouCPy24n781racGAAHy/obGlE/vjRL6sHRIA7yRJp33q0jbPfb2ryKIjP1f1r3odb89pejxXjZnV0nEn1zqBfL/MiTmHaplIk5u3/WAR9FUhPl0Ni9r8xk9WXKAZZiPBkd3qj7ji+h6EWt4HKniVQeT8O/hbl/dSz7wKqVREc/LosKje68gf/dH+jWvszdl0T0N1O9ef1TYreycqVfXaionGIUjzM9InI+93ml3fvOvQw6UglVfzWh9djyFmeJllN02TFuO6uIOV1EXGzZABSI3DS5UBbc/cyv+eOL20/47PJ73FHXzCQwYh6ckJib7YAlROF2IxZ+V+vcwy2TM2AqGAGLTkv6Oob3OvmP1ABM1O1YM3SXVnA1EGN7PRzpNwFrNgqaEVKI3O40v8h
 cjadk07D
 Y0CAAXspBQahavzv22UiCw+KXUgCXWaLFlAjnopyyLAdYCs6zJ4QLEfx1CLaFklqgQwN6d1tkVuJYe5gcnOFHR0E8BacIVZBb/YHuRZft7TOZ/++5X5WRWhEljCeQHBWyFQ9jkdTkNNSmk/KMTPWUbvt088Idtuk6QmV5xBTOZNWa4qDvP980XxVoXz9f+645FNB4KdbDQZx3I9QJ1npTNuBTqhxZSFknvpoB4Jw4P1TmzaCcfoW1UzqRY+1ZEkI6KwqN2l98Zo2Zrj4smufyH2Hn1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 23 May 2026 15:10:52 +0300, rppt@kernel.org wrote:

> On Thu, 21 May 2026 12:01:21 +0800, Li Zhe <lizhe.67@bytedance.com> wrote:
> > diff --git a/mm/mm_init.c b/mm/mm_init.c
> > index 2992711351a0..17a84d4cda01 100644
> > --- a/mm/mm_init.c
> > +++ b/mm/mm_init.c
> > @@ -1084,17 +1084,25 @@ static inline bool zone_device_page_init_optimization_enabled(void)
> >  		IS_ALIGNED(sizeof(struct page), sizeof(u64));
> >  }
> >
> > -static inline void zone_device_template_page_init(struct page *template,
> > -						  unsigned long pfn,
> > -						  unsigned long zone_idx,
> > -						  int nid,
> > -						  struct dev_pagemap *pgmap)
> > +static inline void zone_device_template_head_page_init(struct page *template,
> > +		unsigned long pfn, unsigned long zone_idx, int nid,
> > +		struct dev_pagemap *pgmap)
> 
> Yeah, two tabs from the start would be better :)
> 
> > @@ -1156,12 +1166,28 @@ static void __ref memmap_init_compound(struct page *head,
> > [ ... skip 17 lines ... ]
> > -		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
> > -		prep_compound_tail(page, head, order);
> > -		set_page_count(page, 0);
> > +		if (use_template) {
> > +			zone_device_page_init_from_template(page, pfn,
> > +							    &template);
> 
> continue here and there won't be need to indent the slow path.
> 
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks for the review. I will fix this in the next revision.

Thanks,
Zhe

