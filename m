Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74368C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 11:54:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E8576B0095; Fri,  8 Aug 2025 07:54:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C0656B0096; Fri,  8 Aug 2025 07:54:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF0C96B0098; Fri,  8 Aug 2025 07:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE4026B0095
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:54:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A7D331D9B2B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 11:54:14 +0000 (UTC)
X-FDA: 83753432028.22.AF8FBF2
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9AB52100008
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 11:54:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FVnsPCRZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754654052; a=rsa-sha256;
	cv=none;
	b=O/k1RSl1Ll7LHnKmqtgmr4M33lPsqlZgxy2M0q2YnQmJ/r0Oyp63B/dVi89uZICbc/0gON
	FfAu19BZ3r4Cx/A5REYlowHikRbdu0fxNuAo0ox8YuAPHGkNYBlh5TyjyikLrSCa302hxJ
	sF5cU7I17R+NsC52BcCJj1lfXdmKl2U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FVnsPCRZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754654052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Z87KtuYTYFFBg3Z4T1TS83oRHuynTc7l5TeBpmr4G0=;
	b=RgB7bAflcT3Ry36mxmms3+blLaUEj/4oacin9gJ7DC/bBhflJPOCeUP+ESplz+HzHyPd7k
	aq6NXLFln1ipHkN6KAzxgr1jknFPs1eT0Q+szJvmU4edSMc1NwQIFxGunmTwPM/K411b3z
	xDJlGOD/ozl2MgEQn/nGxEi/iPE+Aqs=
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-33226bac198so16664171fa.2
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 04:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754654050; x=1755258850; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1Z87KtuYTYFFBg3Z4T1TS83oRHuynTc7l5TeBpmr4G0=;
        b=FVnsPCRZiPCO2m34B+tw/pdUkLdLlNC5UAB1YVzgqhDenRjZtPvbezO5tOvMfdBCIo
         pjYxdvLd6yXihqH8fY7BaJhhtlYxRpVvcFjmNv+taanwVkncg9xlVyZOvWT0hu1otOC1
         Vs9e27UiZLFYvyhZtLRuYEPGM8PDxUxJymxhtpCi0ilt/UDfUm8HUUGK+fxdNQrkrUgz
         eVLOkCs810sfhqDh30Ds5gTemMJ+8StbXwn1IYmcwYvTTWx+bC06p1v7y1m6ePqBFOj3
         ZvKFrZjWjuKCZJSTnP982zIsy0MKWepxFZcc4tTB94YURwxtbs3otOe41ShNwxNBOeEx
         Cqqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754654050; x=1755258850;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Z87KtuYTYFFBg3Z4T1TS83oRHuynTc7l5TeBpmr4G0=;
        b=tdiEVSu81B6DZtZZCKhSdXFkFd1COvM+/BSlHNcVCIsHzRJm2f5Fxzig6KcrkWumlx
         Sscbeg9d75PZpOkEVBzsIARG0JBlPf8qhosNpOEpoZq9s0s3Z5BSsmRDwUiB7/imXyma
         1Oc/fQUT73yqFHknGfJ7o2di7Abvvj7UXFFg5GYyD0Qy78/onDegxkpfKglEbhMnL8Qg
         cnMuJigbJ7QpXv7UJ7nk3YHwmhRCTnhbGhS8ntrVDvBtBO+yvtomCSU5Myk3uUfqP4GK
         +iljBPp+LsoBNIHVFhZWbJNRYbDxHzK3unXqJj2Q888/28TEw0OL5V1457+zWRa3VmXP
         qagA==
X-Forwarded-Encrypted: i=1; AJvYcCXRFWiKMbXF5UkNU0YQ6ZpUJmX2aG1k5Uz+PSodo0yYp/q8Mx+c02VhSdxnNikAFekdmAvjAuRMTg==@kvack.org
X-Gm-Message-State: AOJu0Yx8lz/uGJKgMA0a3Pudlm49CoiFnuKbTnPwWXAExzMRnEYvX4mJ
	WZAZt7GD0xbaIhkSOcP2V1XpI1ZQl9ADDNKk+Ny10YJwN2G+OkaFlu9G
X-Gm-Gg: ASbGncuhi4r+x+69Ojm6xDwedEqD7qrwbBqZafjHihfKDNRK19BI9v1sv6keh4Usf7d
	HI0PMGbo1HuRiJERdraK5dX2VmOyefPXXfEzydBrRYLyK8OXlHnFktFGLRLVkuyNTbUtmTu2jY0
	BGeqkQjZwbNlHPKCt5nTHdcHms2094xEM6vdvTu+7yxh9ffoYAo4YE8uEly40iYIyLeYOEPUlQW
	eK5JT9OAVzcWXnE/ESyckZPuN5s229n6I9teThVNHoVLjkf/8Nh8sEJC/QuIr3LgJy0loeht3pN
	ObJMeVZ1fTrLBljjEmdl2y+yKh+bJYMy/JVm6zc8zzwLCGWQMar7Y0Vd85Gv3fgOATyGdr6DTar
	Jzpni8ZeTZlqPBJAlxQv1Fihh8PCo+aZWZpjdwqbt0R+TndLWGg==
X-Google-Smtp-Source: AGHT+IGTlRX32W/66W5mgyretpQulwmybCU5oV0rZLF1gNKD0bCCz7gtRG+Cn9bV9vAJ/GiZCjPktQ==
X-Received: by 2002:a05:6512:3e1f:b0:553:3407:eee0 with SMTP id 2adb3069b0e04-55cc0078ba4mr760428e87.4.1754654050035;
        Fri, 08 Aug 2025 04:54:10 -0700 (PDT)
Received: from pc636 (host-90-233-217-11.mobileonline.telia.com. [90.233.217.11])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88ca2d29sm3067058e87.124.2025.08.08.04.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 04:54:09 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Fri, 8 Aug 2025 13:54:07 +0200
To: Michal Hocko <mhocko@suse.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] mm/vmalloc: Support non-blocking GFP flags in
 __vmalloc_area_node()
Message-ID: <aJXlXzxDUo_i3c8u@pc636>
References: <20250807075810.358714-1-urezki@gmail.com>
 <20250807075810.358714-8-urezki@gmail.com>
 <aJST7TnermwROX41@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJST7TnermwROX41@tiehlicka>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9AB52100008
X-Stat-Signature: 73wthahix8ojk1msrektfg8abnfqnkc4
X-HE-Tag: 1754654052-717441
X-HE-Meta: U2FsdGVkX1++7nIw+jYoczrOOqlgc62VmH0frj9lcEGS6/QI56tR9q2n4RgreYJpoANcV9d5M1rsyeO8v82I1ztqbiMkeqknDbsEHJDETI0peHSiIkcVvPq5VnILoeqIhzuEJuFLXQcWhgSOxmLHZPcGuLFp1D8jMbKuFn95diSwG+YH2TMZ9EYTUU5IWKKBP6po+lM4aPtmC4r9b4r+BDW9to37vNbDG13YSFm8d3vfze8NWPmpTcdtbFZjvsW+FZGF0uiqbcVklLkM81b4omo9aWGr+G0BzkVObrkI7rO7EboCMMyYsKUu8po+Ua9GJUmH/xDSkm+lrYZ9UjIWQe7c0aHy5+VuphZRuC/Y1cTYwYwKJOAtzPpKSUYtXkBY2bA9m1Ks9j2za3s9XPQdpY9JMbvZw7mg19IhXV4OLJja72/UzQGvaUeLa3qm7d01TLq71FunD3O88wFwHPr3GvoBe1C/pxmj23q/GrnNBvgocKOKJPmaa+MZncU6AudpNCSCg0vsEjuMA0RAxIJWYECWXAsdP66dpVBYomoux8Zu23Emvcrtyrfner/dHOoO5PgZPAAiJzUd9a7I4wh6PDm0mTSnMkIXBUq141Yeo3oIBgmdE9z/kj4vKRYrEGC/QEAl2mx8c7nYYwZXHYV6w6jzCfk4D87wzdOXWgUb8UrBSpEqJ7K6QleXk7VyISoXagCPj/CaAGXnLRbovN4S4n4jfEOE8sIXENet0v+M8vEDNJ+NfuPi0SmkM8qbsnS1YecYHqYCWNzJUpeTN7ONgreRMkoyXj2QpUPEZyrG4kd/XU5ZE7VJ90hqppJ5NTS3Sj9j6ejo31a5x20/GwSbciv+jYoyjpV2h13SN/BV8poygB7z7gLJ8vtNmFKpg7HAkg62NiK1mD8BT6tklClbYUXeg6UWl6XpbTxphsehYoRffruq6txS+7TIANZjsyd+nfgzUbx7vZ10BYR9TPu
 YMcwO9sc
 tVGV8LjvPku8CHBm5iAii/pLzEevL981PKryTRW9KXAmPnd8G105xOhNY1GYAaSMTkEHoVUU2qPKGYsZ/GUvt/hYfefROy8KeaKAy8WlAJCnRJM727QsgGQ23fr4NTlfiY6SoeWonIq6d6/Tyj0Vjr5KCFKpqlUlX1h29vA53jkZPoMQEE7MTyt3DaIn/XApxu3YhZY7gBAsBgtSktPQmX+3QCNKjEfJnipCGga61Wa92bteh1cFXs6zOn9FcBXaiTd3UwpKDtPyvT3aurcA1hcWkjEUf2pmCJVhWllkkQuDxrm3GC88bEo/GK4XkbOScd7pSX//zx5YhzLhqf6mop/PfABvBN+P0e9gHKSwEOG7klj5o3drr6EbHHuNqvnWQYaTdnkp45QF+ZnpXSSJhfP1I8TQJDBP8A8Wvl+Cq/AwjIGDKuJSG+qJBBduAjZEr5g74Q8n7WoDZaL/R6hCld6TeCPPyQZNQmPI8jL1w5KYL0QaFhLcDGcCjvB2rdOBsmcuWF7aQY4b6lcLhrayQMYmBmpal0EOHjbT+cka7XzOCoxd8p2Kuhmj76g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 01:54:21PM +0200, Michal Hocko wrote:
> On Thu 07-08-25 09:58:09, Uladzislau Rezki wrote:
> > This patch makes __vmalloc_area_node() to correctly handle non-blocking
> > allocation requests, such as GFP_ATOMIC and GFP_NOWAIT. Main changes:
> > 
> > - Add a __GFP_HIGHMEM to gfp_mask only for blocking requests
> >   if there are no DMA constraints.
> 
> This begs for a more explanation. Why does __GFP_HIGHMEM matters? I
> suspect this is due to kmapping of those pages but that could be done in
> an atomic way. But in practice I do not think we really care about
> highmem all that much for vmalloc. The vmalloc space is really tiny for
> 32b systems where highmem matters and failing vmalloc allocations due to
> lack is of __GFP_HIGHMEM is hard to consider important if relevant at
> all.
> 
Thank you for this note. Yes, __GFP_HIGHMEM is about 32 bit systems.
Initially, in the RFC series, during testing i saw some incompatibility
kernel splats when use together with non-blocking flags.

Whereas i do not see it anymore and now. It looks like i messed up something
when testing pre-RFC series.

I will not touch it. I mean i will keep it as it used to be, i.e. apply
it if no (GFP_DMA | GFP_DMA32).

> > - vmap_page_range() is wrapped by memalloc_noreclaim_save/restore()
> >   to avoid memory reclaim related operations that could sleep during
> >   page table setup or mapping pages.
> > 
> > This is particularly important for page table allocations that
> > internally use GFP_PGTABLE_KERNEL, which may sleep unless such
> > scope restrictions are applied. For example:
> > 
> > <snip>
> > __pte_alloc_kernel()
> >     pte_alloc_one_kernel(&init_mm);
> >         pagetable_alloc_noprof(GFP_PGTABLE_KERNEL & ~__GFP_HIGHMEM, 0);
> > <snip>
> 
> As I've said in several occations, I am not entirely happy about this
> approach because it doesn't really guarantee atomicty. If any
> architecture decides to use some sleeping locking down that path then
> the whole thing just blows up. On the other hand this is mostly a
> theoretical concern at this stage and this is a feature people have
> been asking for a long time (especially from kvmalloc side) so better
> good than perfect that his.
> 
I agree with it. Unfortunately i can not control the PTE kernel allocation
layer.

>
> That being said, you are missing __kvmalloc_node_noprof,
> __vmalloc_node_range_noprof (and maybe some more places) documentation
> update.
> 
I would like to fix documentation in separate patch. That was deliberately.

> > Note: in most cases, PTE entries are established only up to the level
> > required by current vmap space usage, meaning the page tables are typically
> > fully populated during the mapping process.
> > 
> > Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> 
> With the doc part fixed
> Acked-by: Michal Hocko <mhocko@suse.com>
> Thanks!
Thanks! Applied.

--
Uladzislau Rezki

