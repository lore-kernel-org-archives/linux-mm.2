Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53F95D12694
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 09:42:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EE866B007B; Wed,  3 Dec 2025 04:42:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C6426B008C; Wed,  3 Dec 2025 04:42:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DF0F6B0093; Wed,  3 Dec 2025 04:42:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A7C76B007B
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 04:42:34 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F32ABC059B
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:42:33 +0000 (UTC)
X-FDA: 84177669786.08.07A2B68
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id CE6FCC0010
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:42:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NPVzaN8+;
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764754952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=boQ69Ybh1wYDqumvtIviIzfcc3zlXtCv/CYxGlxCowA=;
	b=t3hoSVlGHSNN27ddZ7ObKvNsl/qawa7/QyefEz2oTuhLsmsyt4TvMx+n870bgV2bcyIRuA
	gisJ46AfJzz0t98z+8WgZyiRFQluBRGi3VqPjYabG70fcYNC7PF9b+SYUsp0TaKw75CrbF
	c9iST4HZ8jXeUu8cA82zg8KRhCO8/wU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764754952; a=rsa-sha256;
	cv=none;
	b=6R5631yYEDQ0a7dqHu4qBmieP7ATVkSm+PKVO/aD12JQnkTKSYAbEPEI4lSc6EfiFknjkk
	cH2yxGB9hsKXsb2+YLacp8PXgY2WZ/nE1DaLvdEQSZHhqF8F9ev8mBCh7ty5+jrshRPhWG
	7WO/OFul5k/C+d9MP1VAWMbu2qBQEME=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NPVzaN8+;
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b739ef3f739so460628166b.1
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 01:42:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764754950; x=1765359750; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=boQ69Ybh1wYDqumvtIviIzfcc3zlXtCv/CYxGlxCowA=;
        b=NPVzaN8+JX6VW+sp99Yf+azLlM9884WoMaZ0N5NR15aJ+wpboOf3Vj7LZ3PJ/uhh9r
         InxMdZYKe+ARuQd0brwEekIaZUNuJPB4e/44q03UCk4U7O7zX7X9I1PSq/nrjxXhxWQ6
         LNvutobCbUjv0njK7JKiOwCcohXyPGCt7Rq1Q92tgV0rCe+oEvlxL1FEuZfcPzJGW2uh
         dCLPliduiUT/+p/+/ptaJKhqASF6p+h6nCHw13UEgqiJun4PbRTPtD3ZsQz9PlSZ0F0O
         pY5kdNFXSyPSQzd5l905Uc4AkOMglXMo/d76NEIz9NeljCvnuOiOWSOGWVR/Pkwp3WSm
         PWIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764754950; x=1765359750;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=boQ69Ybh1wYDqumvtIviIzfcc3zlXtCv/CYxGlxCowA=;
        b=d7so6cuc1Ig3cEd0VPHIOBwkxGtnX0ofC5QO+BITEf4EA84dwZ2mHl4RlGme8MYWhq
         P2JXDZdLvid0/Af17YyaA22Lpch6lLO/vj1W5ruO1H3iJ9w2+dyu6Tr24oxsGtivbzyQ
         D98zr4NwgxGw5Q9c3JbZsU3tUoJfX8ENdMVccxuUAH5YofQ9mdYqSXE1+UqsDV93/8W+
         SB8iV2fJtEnzjfS+QDa7umH9NL6ER0wgpj86HVDecuf+70W05viCGO2GLcujb9h5ttKv
         KuvdCd8mfGABF2RZYesxO22DTi2lpga7TgswNzBhLM/BK/AHf+w+7WR+rkqmpvh+60nA
         kogQ==
X-Forwarded-Encrypted: i=1; AJvYcCWI6TEfLHFwk9BvHUXSIVe7OpfvGRzKjhtESQipYnGPnHmnD0wHJqeWNL4ANP6NhPQD47335BPnKA==@kvack.org
X-Gm-Message-State: AOJu0YxAT+uCbvr/TaCyhKd3uvSbFkZVygk2uDyiCr0mv8HjK/yTE8IQ
	x2EIxInApeHep9nsH+iOddI95aHr7e0lKOPKO0oXLETHh+lfKa4CSl2mj1oTN1m2DSE=
X-Gm-Gg: ASbGnctkd8FOf1dPijU3/vIrwrSDhoSfoKG1VEP5qzZhbj3OaCfNhb2yhYEbzzHu3Z0
	UDSbO7CJJbP/3dnRcoyaDP25qWEbqzuEeiPf41lu8iyfmjO521ReGI/d9LxNZdgroQqDGR1VgZK
	iAqkEjfHbHka8FnIr9T4fDfUcRWA5qu983Zc3Dq8KXs1C6U71p9NHFnJnk6h+Ofx5HNwRPYPxvM
	04iObBTsKY2BgFbJJenY/97aJwq68r20zK9QcxudTq+jcl5odP9ZApib4FDJLSfxeKSVZRZ2z53
	kZVkLhJxMfXjhto7/lwsjYvhlV1cetynnPtM5KKeU+fdYZ0L/LdepXa5VeFqP0rpgkENuuSlmb7
	a0O12WxqUreH0GP1XezxAtEAdLHU0ixrllCzS/rXGScoTIEz6uDYkqBcf80Dz0ZGOtFT1EEAdo+
	QjeJBAoh/KFCAFEWYLJg2ARgD4
X-Google-Smtp-Source: AGHT+IHcwn95HVY/NChXlCfMvTjFUudFZ0VlJry9IHn85kRDo7Eua7qdhWEANQT1O7oNQyl1uYTssA==
X-Received: by 2002:a17:907:3f96:b0:b79:b6c9:516c with SMTP id a640c23a62f3a-b79dc51b552mr181031766b.30.1764754950171;
        Wed, 03 Dec 2025 01:42:30 -0800 (PST)
Received: from localhost (109-81-89-155.rct.o2.cz. [109.81.89.155])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f4d533f2sm1749804166b.0.2025.12.03.01.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 01:42:29 -0800 (PST)
Date: Wed, 3 Dec 2025 10:42:28 +0100
From: Michal Hocko <mhocko@suse.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>, vbabka@suse.cz,
	surenb@google.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Oscar Salvador <OSalvador@suse.com>
Subject: Re: [PATCH] mm/page_alloc: make percpu_pagelist_high_fraction reads
 lock-free
Message-ID: <aTAGBPuS_iUAWNKO@tiehlicka>
References: <20251201060009.1420792-1-aboorvad@linux.ibm.com>
 <20251201094112.07eb1e588b6da2ee70c4641d@linux-foundation.org>
 <aS_0bgCs2qE0y1bJ@tiehlicka>
 <aS_2Z6ROtrxLQcRN@gourry-fedora-PF4VCD3F>
 <aS_4E2H5aJmSvWF7@tiehlicka>
 <aS_8BgwR3R_geayy@gourry-fedora-PF4VCD3F>
 <8b89bb59-6b6a-4a79-a571-e97b9ae5287f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b89bb59-6b6a-4a79-a571-e97b9ae5287f@kernel.org>
X-Rspamd-Queue-Id: CE6FCC0010
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: mzksh9nsoidf6cnj3mmpx1y6mnmieik8
X-HE-Tag: 1764754951-106314
X-HE-Meta: U2FsdGVkX1/qRpbSRZdXnquUqKNA1wlLWtgjkIhyfFD2uFrcNiYMuN/5trY7wxO2dvCKArib8RpkWRcg1FhGHwdk+aQpjInw0JTq8KZbabLcaxzLD5yzW21W0CM9R2AhHShIBquzaEfMoKQYLqcC+BI1OrrG6hKO/wQEaQpC32d+oiXyJlQvag3eFg/3CdXdqcW/XELspUy7K7VEh03BWa5RyuqgwixQSLfsrUXXklgqxvjAHULD+ZwPwkDifo1sZqt3qcYua7IPHDWfDma7GdvTMbngpt9fY3fgMA7HGb0bEDIQoiqeCcqxI0MbhB6lautfesbRmDCfxipmzT3WITeo3Hu/JFRWK07xm1cnyo0W7TxO55H8sZNEukJeW+GRBxn9JToY/Ez9hFoeESgSV8/Ky/drAv0G9ZIjRwSuBkM4m95Gla1GuDKMmY3PRj6Xx9t0KSAC35LD+PXRaHcGsZro3yeI/y4pjwX/T06Qw3xHD1y/rLPiXfy7LqhyzOVRiJjoLYzP8StYVUuPockyG1jDEBPUek4XcUlOvSsDiv/ZkG2ayW0EOfRUwCfObdAY6N6nGOiDqvq01XkWIwHkatMROltZI7KzXxQmVeTWD1xAPWPKAfbZ8Oj9vpjX042Eujlnl/lM3mfhd0toubZpjBpoFgcvXRLTDUip+nv79P+eelGShMDu2UrHr3x1YpGVrXkzOH6k8GpuydSp8lF+xxqk4hAeKvVuA73oRUBCH6fdQMyU8ybeUPY1QzQV84D5neXFRKdB5HxwRYroDulv8wk3obkOvGirMwDlAw2D47UbSEeDgxnGXzNhiRW6h71DgAc9G65ZK6AlnhAE2B1Jmd2l376N3AAebeoDBqRbdBr7dFq0SnVRKVKrzv7orcg2w0JPV5kMal3L5a45lbxQc9bQ6Wh5NoS2CvEVTHQeA5t4Jp/GZQ93kY2qiSW80V9Llinaf7Yd1NQ9Ehc+Jbu
 40N+bpB9
 TZ5FDfn8EP/T7JOn5bxXSgftsBmIQgUkWtDboy2BM1OKfiQOUQ5kiKn247fqgwV47hRfcLmVuC8UCkPkmZYvuUt7T4boUOoeigDl2a0+++9AznMH2D7BrGmXV9W5+VIBcs14+IIisPRklWbCKMsXkX8YSvPwQMRHQSvrW29EJVJMhO9CA3ZDvyPjJTYVMPWVWSRWScHRqJBwOZRPV6/x+Fr6qYUZT3guQ+ZKPHaau4JHvVd/PX2r9tg0ng8UWLdoBKhSmlO69yhx/RFQSTUaWgzV//uwJtW8FgyVbrC6zfYA/66HDZSeYgD+h/r03TgqZPVMbFcQTZCiVoPmzxLbaf19ozvkh0gNztJnwZo63xOEEYk59DZ3imPp8Z4+a0Vsyxyt2FIYynCedj/eLTcvBDkkJeQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 03-12-25 10:15:04, David Hildenbrand (Red Hat) wrote:
> On 12/3/25 09:59, Gregory Price wrote:
> > On Wed, Dec 03, 2025 at 09:42:59AM +0100, Michal Hocko wrote:
> > > On Wed 03-12-25 03:35:51, Gregory Price wrote:
> > > > 		if (!ret) {
> > > > 			/*
> > > > 			 * TODO: fatal migration failures should bail
> > > > 			 * out
> > > > 			 */
> > > > 			do_migrate_range(pfn, end_pfn);
> > > > 		}
> > > > 
> > > > Maybe it's time to implement the bail out?
> > > 
> > > That would be great but can we tell transient from permanent migration
> > > failures? Maybe long term pins could be treated as permanent failure.
> > > 
> > 
> > I see deep in migration code `migrate_pages_batch()` we would return
> > "Some other failure" as fatal:
> > 
> > 	switch(rc) {
> > 	case -ENOMEM:
> > 		...
> > 		/* Note: some long-term pin handing is done here */
> > 		break;
> > 	case -EAGAIN:
> > 		...
> > 		break;
> > 	case 0:
> > 		...
> > 		list_move_tail(&folio->lru, &unmap_folios);
> > 		list_add_tail(&dst->lru, &dst_folios);
> > 		break;
> > 	default:
> > 		/*
> > 		 * Permanent failure (-EBUSY, etc.):
> > 		 * unlike -EAGAIN case, the failed folio is
> > 		 * removed from migration folio list and not
> > 		 * retried in the next outer loop.
> > 		 */
> > 		nr_failed++;
> > 		stats->nr_thp_failed += is_thp;
> > 		stats->nr_failed_pages += nr_pages;
> > 		break;
> > 	}
> > 
> > So at a minimum we could at least check for !(ENOMEM,EAGAIN) I suppose?
> > 
> > It's unclear to me based on this code here how longerm pinning would
> > return.  Maybe David knows.
> 
> I would assume that additional references will always result in -EAGAIN.
> Remember that we cannot distinguish short-term pins from long-term pins.
> 
> We should never have longterm-pins on ZONE_MOVABLE, unless something broke
> that contract and needs to be fixed.

Right. But what should the hotplug code do under that condition. Loop
for ever or fail reporting the broken contract? I would lean towards the
latter. We have never promised that offlining will not fail ever for
movable zones. We just guarantee that the operation is resistant against
recovarable failures.

-- 
Michal Hocko
SUSE Labs

