Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7F2BCCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 20:37:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEC328E0102; Fri, 24 Oct 2025 16:37:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA2788E00C9; Fri, 24 Oct 2025 16:37:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D64358E0102; Fri, 24 Oct 2025 16:37:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C2AFE8E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:37:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6980B1A0F37
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:37:24 +0000 (UTC)
X-FDA: 84034168008.06.D4FE66C
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id 707D4C0005
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:37:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=taBOYYTF;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761338242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vn4hQEcGul2fUa7R/OzGXx8vWTt9TjtrdGmgBs4cZEg=;
	b=12oCX1gvD00G8DJHaAcguhVGXCOsancLYq/kUb8LLtnnonNtPZAi8tW/cbZx2O4+wCik3t
	pmgMa+fu827ajW1xd1knHqteEqo27lo7WdsyGR/veu93i793dfUr4Eb0r0WUVroSBwRHcd
	ZHpwOLBs9acAN94ATCNpxKfiQty0fSo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=taBOYYTF;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761338242; a=rsa-sha256;
	cv=none;
	b=AfInv4+WYFlAnuq45F2WMUMjOjFSJR2tl6sX894ocssolZsbo1oSIGkuRTUUuWeBwUdqUo
	5aEJlAgI+jHJG5JaP6/TTqEk0KlyW56SVxLTticQv3peGBmQaCM4pRwmNymfeL4L/TulMr
	jz4XhTPpAJFtSguA+l4kATbyezsEJRU=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4eb7f0b9041so18568241cf.0
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1761338241; x=1761943041; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vn4hQEcGul2fUa7R/OzGXx8vWTt9TjtrdGmgBs4cZEg=;
        b=taBOYYTFXnFcpizAjsZ8V41by010lGgQBr9NSq5KGxdS1Y5Qi1GpTL+dxfBHC8pkxu
         7JZ1s7QaCsjvD6z124JBRuNh/SFFUWiAWc3y0Rv89wFYkTXDV7QgyXvbzUaRk3GAX5aQ
         JgR6VmP2vjFHUQP3REWVuADY8VLbiD/NnmuuMAoucPztEEz3oom7jq2fDjugCdwRfebg
         b3eN7+pMRjHB6GsVq7LQoiXS/Ig4fE95KJ4ewAjPhduq/vXuSrA0FmQI2t0acIU49f7J
         brKGmsVN3YCZO19upsn5y01JOaEJA0nd582M1kOg8ClxfbXcoNUjMFGE1rtx0t5Chazt
         CjDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761338241; x=1761943041;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vn4hQEcGul2fUa7R/OzGXx8vWTt9TjtrdGmgBs4cZEg=;
        b=dAsudaXBgO7pEzLIEIa6HTLR7BUNpqHEAlFMoIAFNEmX7V8tZDpE53oJLvHzd14iPe
         anD0V0bRuTXqkldP8fhaPv9v1jTy8w4d/2u0SY3xRH0MjfiD5vfRFkcqPLae1m0TY9HK
         3CJ5vUtNDD/A7nbPYZ7TJ+ByZGCj0F0576MPy1KWIfFQNT+rbNO2W0AI+494MP9Y5B5z
         nOHV/NzopgBaelBNQ04lsClXm+A5A/9OjMQY5EMverqzfYNq283Z/3jkOGcvbtnIcsqL
         0rg/ZS0yQhs0VwnJ79Ttk9frmgQHq38GeTl96tYHoWhlgEeWBdhQR04iv6ZhCJuOXhc4
         wHRw==
X-Forwarded-Encrypted: i=1; AJvYcCW5UyfhuohKE3gOcnHzTKbOCHEpNPjeFhBJ+6JNGqKLuj/2WsAsxgfOTRP1Ne6czoOAWVL6m9y3Gw==@kvack.org
X-Gm-Message-State: AOJu0YxA1AcbC8uCO9ly3bjJg3Ms4x1sI/5RYrz/BkfKTep6KL6OSx2b
	QmbhZZMT9wFVzP6VQXKT4jG83ewY3Jy8mR3gc8Yln01yV/wo1riplCXUUSDcnZyNQ1s=
X-Gm-Gg: ASbGnctQJOC62CselyOl+ys3D70R82SCLZYKQNmgdnSeRQ7i9B0/SimEa+GGv42+scu
	tK7CRlClnXjhH+752XoZcD5rNm/OFeYCwSbOXDgnmiLOtwu8k+labjMs0tzM77lMX1h8+BGbEcE
	/jvSUGW8y0QI1TcyUdveDyXMw3//TWy3832vPvcUg81zts8j4CHrPY1R9faCvRIqnRYMkLf92mn
	fsCuxdjqmuSnPm16B6sVTRQtKZ11XUoFv+5CBBZIrF7zvqpNBQZzDbKoSk8wa4dmEQPq/1aXFHe
	pWr3JG5NpAhndgHaA9nHn+Xd/qkGV332czZWVmO7j7ik4ELNtgzl/+5FLtLCZ2zPgo49vD6E5c1
	HWc6B/DCQSB/+SrwU6TR97vLOgOsy9gX97dZd+i+GCTbmxB8ryCPyLLMZxnj1C3Me01Vu7we8di
	nUyaTGkmgUTm1A8YJIlwn9erU7GQPSATzoRBJBftGGCpMet8+PRMSiHNECaBsLktrj67GYqg==
X-Google-Smtp-Source: AGHT+IEizsVD5MWKlpznZSR+oUAoDamQsr5IFux8tgX6jFrLAoh3hAikSuRK1/9hfCiWycXsqW7SdA==
X-Received: by 2002:ac8:58d6:0:b0:4e8:8ed7:da6a with SMTP id d75a77b69052e-4e89d20680bmr359946041cf.8.1761338241380;
        Fri, 24 Oct 2025 13:37:21 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eba37b96d0sm861481cf.6.2025.10.24.13.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 13:37:20 -0700 (PDT)
Date: Fri, 24 Oct 2025 16:37:18 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
	Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 05/12] fs/proc/task_mmu: refactor pagemap_pmd_range()
Message-ID: <aPvjfo1hVlb_WBcz@gourry-fedora-PF4VCD3F>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
 <2ce1da8c64bf2f831938d711b047b2eba0fa9f32.1761288179.git.lorenzo.stoakes@oracle.com>
 <aPu4LWGdGSQR_xY0@gourry-fedora-PF4VCD3F>
 <76348b1f-2626-4010-8269-edd74a936982@lucifer.local>
 <aPvPiI4BxTIzasq1@gourry-fedora-PF4VCD3F>
 <3f3e5582-d707-41d0-99a7-4e9c25f1224d@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f3e5582-d707-41d0-99a7-4e9c25f1224d@lucifer.local>
X-Stat-Signature: fqheucd85yshjmzxd6zyryecj3k3g3dm
X-Rspamd-Queue-Id: 707D4C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761338242-564823
X-HE-Meta: U2FsdGVkX19LZgLkTQRNngmj8mac7M79JchqjuAWhX6sOzHL2Xogx0wF6zBQ2eLWq85H3hV5NBD3iOtnML+TpVtwuSgLyn7mxTE0h4FJHE8XaFBuiPH0hbKHzkXxNfYirqtBek86l7fgNCpGJTv1TkbTvp/XhFR4YodY6D/F32EaMzj3uz8OrLpnbCSfXA1nFuiFb9RhKmcP/W1y7f+fe8fzS/YQ1Zj4tonhoCLiFM5Y3c1onRBDMv9BXH1VRR+cWLt2nx300wauTpwmI8UJcBtn8968a0goBw2Ye0uUrpKBW7QczHVzRkkbaN6NubFE5mTTD8sAF+5cdFHXdBU0/UvRtuPq4/Az5KKI2+vOs7plSk6q4DCEY2JgiM4oKK2q7MZdlOyccp6MMvo/NVXNzggrHqh0oxs6dSjEv/rpXGt1gPlFEA7xXELcfhm1/Rm9vsXRO8m4wmV2ze4rgCwabnhPdZiQ+VGuYPeQ/UfDe/W9wiNdikk3XL2qWFg6d/Rt9Ybc+ru/NfsTyI9VSfVsNGQsXp4wMyEEwl+AMEYsrAJ8r90nZu5Boemqro/uYeK/kpgwL4GnRHARI5zu1HGnzckp30hCiKqzdpeKM2oAvzt8l7liJhwNhy7w2WlDtnn7iA4NX5ZWgBRiQhJIv/lUctA2fOxf//3sgnCjo8DhiZt8q0w/9roZDaP0jK6XwThaimZmsO/2Qz44wWlSRM2g3oSEuywerQM0Csh8X27Ab9eMAKMEcKXOasbnBljMQjAEKNJaDZ3+0tuCZKuXyO8aqI9Yv8ENCjwh+EZ2BAsrhj3aglrv2/+afbKwI4UYVeoOXKC0sxp+EJYNzX6VGT4+Hcds3y67C2CNTKa/lJpLIOblwYsNQSz1aKvZ37WhEVQY2dfyr2hWf13VEn8pUwdLmEivNLtn7vYy8ffxhBVHRH/8OusKNdpI2ta6dctiowljcaJBpmcm4PnFqN2V4ZK
 jJfYd03b
 MpnF+6ORLYoyFl4E52RjJF01ZOOpe01tBzvnAh8+Jh1e870KChpd4KEpn66Nx0WiXfo+0oK23q3Ojo1dQ5gdh0SQbqPYDrmxoRsiCiFrJKDZDSxf5TQtMLa3cjjRpnqodTFsoo0FeT8a9XpSJW+PPo98HptFfAmYlpl/Ixbs5gKCCYtN4z8xCDH0XXx1feBSxISI7UjgZrZEzHjgpBy5IFR1JydVqvnB7zJ13GtJB08uUwxKTIc3FipGm8uFFtcpRsFdFkIW4Kd+bJ3gVPEG1RfrFuTF703g0i38wMkv0hiu30S/UO86Fs3LBi3AXjGwVoJcZ1BITVWfQciDKV2+n0HSuG2TpC/PVlndDjyyrgHnp4+AC/+cRXWSeSwJxRI8z9JGPmu2XHKTpUWuNVxonTbWHwfDFz8/2ckRfZJ5fgtmsw3Wd57U+ceaepTUzZW1BXxWC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 09:15:59PM +0100, Lorenzo Stoakes wrote:
> On Fri, Oct 24, 2025 at 03:12:08PM -0400, Gregory Price wrote:
> 
> So maybe actually that isn't too bad of an idea...
> 
> Could also be
> 
> nonpresent_or_swap_t but that's kinda icky...

clearly we need:

union {
	swp_entry_t swap;
	nonpresent_entry_t np;
	pony_entry_t pony;
	plum_emtry_t beer;
} leaf_entry_t;

with

leaf_type whats_that_pte(leaf_entry_t);

with 20 more new functions about how to manage leaf_entries ;]

no not seriously, please have a good weekend!

and thanks again for doing this!
~Gregory

