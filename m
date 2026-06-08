Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B06ACD8CA4
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 19:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB7366B008A; Mon,  8 Jun 2026 15:43:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D68436B008C; Mon,  8 Jun 2026 15:43:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2F726B0092; Mon,  8 Jun 2026 15:43:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A24B86B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:43:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 480C28CEE5
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 19:43:41 +0000 (UTC)
X-FDA: 84857770242.18.5D66407
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5D66CC0008
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 19:43:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=i1u33ASE;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780947819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kn5+ZpQefRkmWKbevzDNoMTNeOUuJtiAWUOcjYbKJkI=;
	b=MnW8pVuBSUVvEFQmFvKcOT5ms7gc/bIaBDrEGuxYLWjxsaafsbe0jCpqX2pZudck769cQ/
	hy0qmwzz9zeMzfJXs2cPDTlk+CKPpwho4k1FDoQdFJ7uv79Gph7kuFTzWIc4U9lWtsQY1e
	5hgf7bKEhGL47TTP1RPFYk019Tqi61k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=i1u33ASE;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780947819;
	b=XUrqsFqWgv3HeAoKwI076Ex0JxgPcwR92vqGrpPD57EzKuXmApqgp8mG3SlWbaVe3NN/jO
	MYme/MkLUSnIIZw09ap3f+01W6IbI5ANuScgLF4Yf1PaFnWxEJPk5hV84oxL+B1Kagfgnw
	gUkUB0gvYccCVpUdm2aGvPHtYlRMw9g=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8ccf6a63a45so59968866d6.3
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 12:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780947818; x=1781552618; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kn5+ZpQefRkmWKbevzDNoMTNeOUuJtiAWUOcjYbKJkI=;
        b=i1u33ASE9zl6PToRMhacmjIeU08JuTTnhhB/ksMF+F9TmAjCdVRNqaYTVdG/+YxzYT
         l6DsxB1tuEXakvYxhx/QBfT2KGNTEZYbldIrJy7ZsRwD4GPFcp7CVDeLZcORDM4HmgaW
         CnvS2Rb7mNnI33JPi07BxVk7PTUNsy/SlPuxthC5uK93zIcG46iF9re22wAkteHvAc/6
         rVQV6VCawdgq2sP5BbulWcR8fw/r6ERvjVi0twPHoiY1BkHuBQ+dXcS0CYjG/cNm0lyF
         9k6Q8YCZwerMqvA4CTQSwPLT4NYjms2KudfEuPK2npjWm76dqMq/CKlm+L46Bo+vklox
         dTmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780947818; x=1781552618;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kn5+ZpQefRkmWKbevzDNoMTNeOUuJtiAWUOcjYbKJkI=;
        b=F5shmfGPAkpecBuw03T9KPKDAfqps1SzmaAST2ssYiE5poQavYuU4oc7/fLTXPvf0M
         TnUSgrnPBTh81SRnveS0/MqAbsJOyFyBVyawdK3APZn9oS/nhEeNPZd+B/1gyQdrGlSA
         KY+EVp6ZVU3fFlGTSS3SE7XGwrc5axTUde4YfYPkLHwAhoU5WlCyIlbBnPDC9qkFcxvA
         QaXxh4F/fiBaaHFKNHWA9OvX+T+bnqqZOxOfEHeCIuAf8DLj22KvX6wdxJQchstGMd6U
         maV7GdIXyDwxM4wfrKirvivSu3+lANU996H7nzfz8zZtol5Fc0OmVwyOO8LnuWU8WxLK
         dOtw==
X-Forwarded-Encrypted: i=1; AFNElJ/bw9dtx4PAF0Ohk2zIhke/gf8Se1sIIHVSeS38i842/j1UUCWZedmvTxS94CPe+fd5gzvLHIqfdw==@kvack.org
X-Gm-Message-State: AOJu0YxXpQXbNLEgKx7bx2B1Lv2fKYq09P+jfp0vGO7Tb01ippS1ARNI
	4daxBXoVUot9udwm0FLwxF+DCrrJeZ8j3eUKvN13DsP+dqn2BTSlFPLikdLqmOMlSw8=
X-Gm-Gg: Acq92OEokGRzZ0r+7hy7eryfEd3hjafZ+bFZ0FuvgP12LflaFn1OPDaOZyHIwEi3uFW
	SXu01qiregmUSyCr5OkZXC028OzlAEDnvsIsLCHKRXuFqxlrlFqXHgZSmBrQ8swcrTKLmKWRTyy
	G7pY80fSi3EnWicW1PBfJAOTaMLPAXmw8SwwNV38Xzo/nKk1dB4D7VOk8gZnq8n7rzRjom3ISh9
	nFKEXTE08+S6aK3kU8mPNrnV1xJ+cvSiPkphudsRh8d63JVXmYSqy2eAcjhkIwKm1R59REiDWZi
	1AKyLuF5s/Y2qONN3AulTZUGpNKEvA79QcmCKrJB4A+nW0KBQ5cLAowLdina29iuLBpiw/9Zy5B
	Vu//Fc4ADEVhQ3GqDh1pr3P3bkUTCJ9bDbxWdTm9eI0ebcrN1ysbAa5ngixEHPDUq9C71N2scXT
	cok1aFND4XsghCAmsolfKAMS3eOdQtAW2H0qmVfsVwSVgG2Xx93gh6IYZY1TJceeWStERC0iJTy
	CMKfWhUBM9P8XnmRw==
X-Received: by 2002:a05:6214:2c13:b0:8ce:b018:89e1 with SMTP id 6a1803df08f44-8cee628fefcmr267968686d6.32.1780947818366;
        Mon, 08 Jun 2026 12:43:38 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd07629dsm176866096d6.39.2026.06.08.12.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 12:43:37 -0700 (PDT)
Date: Mon, 8 Jun 2026 15:43:35 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
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
Subject: Re: [PATCH v10 07/37] mm: thread user_addr through page allocator
 for cache-friendly zeroing
Message-ID: <aicbZ9lewv1wJqqS@gourry-fedora-PF4VCD3F>
References: <cover.1780906288.git.mst@redhat.com>
 <50d410b47fe3f45327783e05bd306d5eaab75e65.1780906288.git.mst@redhat.com>
 <aiaUDTeHDA45ZXFS@lucifer>
 <64f2e580-aa82-4849-9236-b8ec4208ca24@kernel.org>
 <AEB19464-20A9-4C5B-97B8-681CCDD81031@nvidia.com>
 <2475e4c4-9ba3-4091-9bfd-1c1c15163da7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2475e4c4-9ba3-4091-9bfd-1c1c15163da7@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5D66CC0008
X-Stat-Signature: nsku8e37g9zbojygo84fnk6nn8efkfqw
X-Rspam-User: 
X-HE-Tag: 1780947819-208077
X-HE-Meta: U2FsdGVkX18jIIG055EFkKUi8LNiErLxAsJyaqEhjgivCH+9jJaRcQ9byNVFYlZI4M/7Jt13zAGI//S7t4DEi2xam7U+j5CPWHuc2mSdcWcFUY2bZD1LgMTrfnQXfDRIqw/5oWPBVxedmOj6WxU5dvtnry07qkPzyy3oZUtTVIQn4mmK+aiSfK0XZ1UZJsgXmEy90VUu4x7UmEuUJMbxreFX5YvvxYpDCzSwcjgVan7h5fEGnZPiUQ1OE0x76TzBb/LHz33A83roHt5Pq4LkTtpDpVWmDWbtIiX8x1GOwXZ87NOChRxuIID/8XbfHYgD95jr0mtpsmsOvSJt/NxPHW5B3g5SLwYIDTPJQyZwV3Q4cjopbvbJFNgs+AYuLhQSjoP6ks4/wXUYylQPGBMEgyghc63z6Dbn48Kj9HIhDXMczCdr+Up06rN0vdqZdonElAQopIkW4ItZm53w2m/6KCE/aaMrRmGyRlSh2oufs2mtUHgkZpG12coMmYJRGe59y5EAHtjX191GU+z5JkX9JePBdm5bj1H3az+uLDahe57SFwEv+v/7eDS8NNlfDsZPbrsYxeepnx+pvWqS4C6lzorfbSk/65dvQCWYd81W/mwynWvc2R+Vi12VgzE/GqGMIDohe4GLB6DVQ2cQYgyP6hYgWLz3O6k1lxSD/baCoIvXGsVRmauyl46Si3AxJ1d0PYf7g8j8AdBptl3eS2gQojJ5oObE5DD9BMCdJWixgALzW2zuWT5oDRLvRwWFWOKFfX8Nwa+fc1d/frQ8CvqaSaKjWGoW2dpNMEbzd/XQLg/Rw2reNOC13Ihpxzd2wWFpsuqnttDnGzS1ISDYP27u6ykfm1wHJys0HchEz+iL4PWd3P24O5pDbGmmBbXJZxfQ9bKd94Mp43XPZnQ8AuHmlH2HZLJEDj0ZKleVSkSHuyoPQLrJ96VfK3ADxYBqevdYM+4xm/vhh9xt5xeQ4U+
 wObBM2lS
 JmUfzJkI/BoQ63jN8s7boe+01BLAi4RN39LwyM0MSWxNpDANgmMzuUGd2k4Z7SsLNqugAZtq7TzWu6qVHFEfptKMYqwyJlKjCaoo8hZic6JwmlCsUOw6gFITCWea5cAZurKRcfDs8y2dw9T5Glt2FT/GJhnMvkJa0moURf3iEpxn2w+4yGGvmuhUMq0cUJMH6iFm236GO4LDbTMWd5b7TPOm5Pyyj6q9G5a4hZuGLnB1QZaEna/byooMIwRJNDlLGlJwZ/VTOKNPFMvDIbVlKFPK61/qUfH04xEncK/y5TVLCuGzv5m2FBzC8dPcx8TdpnB1p6zcdb3lXMDrn9GCilfRC3IG/OB6UtKWrmzW+vrWZVkUoLE4rLHyRl0iJXQV8hoBBd+bSTxTgK9c0nX3WfXZP+6LxNYPxks58Z6SGcuJ3gkOTu/5RpwTLU7r8i3I3ZbiCEX4oNq2X5iM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 08:39:10PM +0200, David Hildenbrand (Arm) wrote:
> On 6/8/26 17:27, Zi Yan wrote:
> > On 8 Jun 2026, at 7:08, David Hildenbrand (Arm) wrote:
> > 
> > Or should we defer zeroing after a page is returned from allocator? So that
> > user_addr does not need to be passed through irrelevant allocation APIs.
> > Something like:
> > 
> > alloc_page_wrapper(gfp, order, user_addr)
> > {
> > 	page = alloc_pages();
> > 	if (gfp & __GFP_ZERO)
> > 		clear_page(page);
> > }
> > 
> 
> Not really sure what's best here. I think we'd want to limit the lifting to some
> internal API, so it cannot easily be messed up by random kernel code calling
> into the wrong API and not getting pages cleared.
> 

We're a bit in circles on this.  We discussed explicit interfaces a few
months back and the trade off was:

a) add user_addr to the existing API and cause churn

or

b) add special interface like above
   increase the buddy surface
   leaves open the ability for users to get it wrong easily

If we forget VMs for a moment and break this step out separately, the
core question is whether page_alloc.c is the right place to be calling
the folio_user_zero() or whatever it is.

We seem to have agreed "yes", which necessitates the plumbing of the
address into the allocator.  The question is whether it should churn the
existing interface for have its own explicit interface.

The implications of getting it wrong are:  a user page doesn't get
zeroed.  *oof*

I think that's why we thought the churn was better.  But considering
we're already in the same state now (callers are responsible for calling
folio_user_zero() or whatever), maybe that's not horrid? 

~Gregory

