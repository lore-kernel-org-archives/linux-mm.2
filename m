Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 766D7C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 12:17:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BF356B008C; Wed, 22 Jul 2026 08:17:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 149526B0092; Wed, 22 Jul 2026 08:17:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 011056B0093; Wed, 22 Jul 2026 08:17:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B1D536B008C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:17:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1F6234015F
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:17:05 +0000 (UTC)
X-FDA: 85016312010.16.BC86ACD
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id 52D3F20004
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:17:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=sP7YFIlM;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784722623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5mNAYCNl+PvzQVOY++arp3TkG6k570KzmUdhkjTUZ24=;
	b=EPCkTFfg3payE6tT4eAYtIA6+c+Z+kE7bXGg5Ng5JBjVR4rxhxSLu1CBu+j0inGXAE4j2B
	Eji4ijE8opAu95QtaEDmlXiO4Z8pvqIN/2Mkdur6a/3g3xf4XLePFwSWCY2NRCPCbYgi6C
	tmUSpny4DYwIDdUTyrTKAKDJwhc6FUs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784722623;
	b=8WWLpIgSxCXgdulvzUjrREzWF1CFdB+AKfzgQhI3hIwqoW1YzCDk0h5wZ6ajJryGwp1ew+
	v5zoMX88dnOBAb/wdaC6nLh3ri8VDEvWHJJr/+NdN8RF9OBM6G+qpj593w1jYZNnKMxU0O
	ceb/Gyos18C7wTI8KjK+XjiK10aedaY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=sP7YFIlM;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-930f618435cso70501885a.3
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 05:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784722622; x=1785327422; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5mNAYCNl+PvzQVOY++arp3TkG6k570KzmUdhkjTUZ24=;
        b=sP7YFIlMkTQ78hykcC5mulrhFp5968a9I+geMRC9QRLNAIlwt7c0PJtidm6uy2JyyX
         Trs+vPb/R2+Xu0dEgI/TIShLGG4dzrEZAOb9P25DtCrLDj6hEOa43XO4LqV6nj0L8z+y
         ix+X8OiNNIlzxIDIAzKK81Wf/779mDMGnoG5SttQLmv+qnSnlWbTHdp+S8ZVSBOqZ9HG
         eWIy9fZEwDIX5DWF5a/cmvXwvsOlHw4cMfimstC31hLOuuOrZzikq5ATOu4La6w3r40O
         z950A/keCHcYxMY1RP3oTXWS2i75NG8lITIwKpfhDYZgLx8PEElAWhXyLIsfXwdufjeX
         DrBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784722622; x=1785327422;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5mNAYCNl+PvzQVOY++arp3TkG6k570KzmUdhkjTUZ24=;
        b=iNFjzU/u+qfXsFkHWAfIdrBxOijGDb6D1TWT0LEQ2eLI4YzaxAG/Qh2aVs/Uucp1OK
         C78KPO8he7UAdsfeJrNKq/bnBwZllt3MqYfx7k2RrevB/L2AxQHaSrAnQ6KnjBIdw3IB
         MgGOWF5eyvIVw7fwQ+pHlfVi2rxMWmilClVpwJj0h0l51jO49c5sx23swnxHUbVuQNOo
         YCtK/zueKqjsrDbGTP8aIkDNFf+Hx/6jqaTsE4eXmrlIVAXYKblc96uMye+i2XOm1DP+
         rIX3z2lKYP9csML5Eoll2UrnvRfq7PiRAnr96nZF9+x+WyDyif5oz8A2mRRTn5INEOIE
         B3AA==
X-Gm-Message-State: AOJu0YxJzHeztd0O7Swg7q6oxKi7geE6ahwQi4ErOB6XybOzClDZY/KY
	WvyCCNlxBTAWzDSFo6tki7XTjm7WiNMOoKcNsdhZNsdTEVFh6/8MeTE9lnRk1K/kYfE=
X-Gm-Gg: AR+sD122Q+9RLZ2ChCe0APm14qvq0qhFlfjRa8IzZENbKVBp19iQNYK71JKIgncwX8b
	3ZTGtf7kzlPT6SAUwYVMDIrusrnoGUY/rK52wgYi2EJGhDJrk644pcu/RpZTMuq3+D5RLR84yhe
	rBaXo8LcZ2ufc0VGzN7LIh1ogZOYJ67EQL9gnsdkVlw2y/JtDaSZaocytXikIamWn788rnohASQ
	xjWcD+/LT5are1Nq1YAbTA5H9Bj1J83s5MS8T6HQKsPqb9RDoJ+B9aYmW9AQ8LkKI863Jbf7D1b
	yB9ChAGW9l9OiGFvQMD03ytEn0NlOZ4zkZUGsS3+pnWp3No8fWp5CRXB+ysKXHqC/5pqVQspNMr
	H/ijvs/0WohQKEDRBW81bR/ftLo9p9AhqlPXxu6wx6T7pumsHQIKyrOVzZp5NxQqbMIDF8yG3+E
	MlEAGQuVLZAgaTLgnc1TBpgkKsqnBDh9UCEAFV/GGK/p7cqs2+NahdygsI0w==
X-Received: by 2002:a05:620a:700a:b0:92e:72c4:152b with SMTP id af79cd13be357-930b43155bcmr2298496985a.71.1784722622381;
        Wed, 22 Jul 2026 05:17:02 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930f6a03834sm149477885a.30.2026.07.22.05.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 05:17:01 -0700 (PDT)
Date: Wed, 22 Jul 2026 08:16:56 -0400
From: Gregory Price <gourry@gourry.net>
To: SJ Park <sj@kernel.org>
Cc: linux-mm@kvack.org, arun.george@samsung.com, balbirs@nvidia.com, 
	brendan.jackman@linux.dev, yuzenghui@huawei.com, apopple@nvidia.com, alucerop@amd.com, 
	matthew.brost@intel.com, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, djbw@kernel.org, 
	vishal.l.verma@intel.com, dave.jiang@intel.com, alison.schofield@intel.com, 
	osandov@osandov.com, jannh@google.com, pfalcato@suse.de, jackmanb@google.com, 
	hannes@cmpxchg.org, ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com, 
	linux@rasmusvillemoes.dk, longman@redhat.com, ridong.chen@linux.dev, tj@kernel.org, 
	mkoutny@suse.com, jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com, 
	baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	lance.yang@linux.dev, usama.arif@linux.dev, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, driver-core@lists.linux.dev, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, linux-debuggers@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v5 14/36] mm/damon: skip private node memory in DAMON
 migration and pageout
Message-ID: <amCzmkdOr6AFv_kQ@gourry-fedora-PF4VCD3F>
References: <20260720193431.3841992-15-gourry@gourry.net>
 <20260721234644.149401-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721234644.149401-1-sj@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 52D3F20004
X-Stat-Signature: q5k18ufwt7hpjmce1efi3cfg3w4zdnsr
X-HE-Tag: 1784722623-127422
X-HE-Meta: U2FsdGVkX1+Ra8YN1Txu1vej/cxFW9EwuMxUdQOYeGXNbo9BffIWf4gI887ae1Gf8iAEbOoWwAM275Q5KSPU4hsSXoIeBRJpRpydwTDaxmXgqbN2QfnrokaCg4284IFZC4wsXZGpLwY82zoCNxjaTy2fHT2VxcinH6ay99XxKZFxGKb0slzVqEQlqxz0sBprpehBnaIWTxnQ3dlTiqmVcjx5mW8GCoeDv7Y7bbvwn7fHSJh2CNgdRkl6dO8UhGQ9TRLDbcT3+Kgbm0TD6EhhWBOZ0cFjaK6d11RaSl2rcuxuFPqCcrEA+rZpZKNxm6p+000YP13GnvMjoU5TR75Z0BxCEaOMBLxNjfC3jl087nHFibLf/WwBPO2WSUO11mG5l9MAECDF1VpdJnG+LM4cft28Cxiyq99fzJdCb7YqiVbtxZAoiFxR2gWl/0pEOWXGNsnqv08MkINBQIX6uq4Mo9inzAEqvx7d5sQkDClMdWFouk/yQe4Hbd+KZ0Mw++RmwV20QG4RSgaENkqL138R0da7KCyzcJuc7L2FNCFyhrICII7WgsPgJVDxU994cQuPhOsmGa9/9dlY2zHJ6fgQ5VTkwfXgbJ0fbAUZ2ypl+W281W+A03XXIGxex8ZXn8D5n698VkEFQT9M4u4ka/LLRdkKMXNP6esV3DeLAJBHyK8ybo8/VkvaV4QjUP+pp2epoPQvMhkan5kXviM5lmQDV+m9IiUTDOxo14NT0MNUwqSlPD9FRasPWVKz0AuymISZcJJIFbXtK27de9RyWQ0m8sr2BB2EMGttBUtFaHyQRrVtUVMpD0Z95Zb30SaOJnHNhrWw8iyDHZBhg/+n7VqZEZebrCHgdyI07kFI5FCqbtrTyP9nwQxE18+poDvizaAuj0aGlllbD4dvqAeg40yVHtDabpba2cNO5HF0NYRhJKO2m/LJzo1XAHjrbqMY5fsasGTV/bGTy0dMOIyqgE0
 EoQGCO4t
 MuNRdUjKBifDi8E+tTyI97xwY1U1B3KqDA+T1JyEaHpAH6yVwvbaqIedHAfk36gHIlz0/SHH9JrqYaNJ7EXosUDLHJejOmgC686GmDT0Y/9ECDofRTl/qjHisBemk0WJoOOQUULr9j99AtQ5gwYuBCkazB7IeuSDsaXjCnt/3vcfHAMOMoNPPS6rCvZAr6v8VVhMi7lLex+C9I2lKteDsCJmK+cM2gTVjZOux11xX1d1/+nSSwOyQ3Z+97P+L9FGNPCrfkNgE60ZRxX1iTurLhGMZwzFsvhyZnjCJnU1+k/LoN1vA9eSolb3GTyo0pP3eZ0iQ5q+aFV5Nt2PBZ4Y360Arcxvg4PIwdYu2j1BoFzKScscuxvf260DB6I+D2UWMSQRmXYbwr5G7/16Q4T5RnbC3ZXIYVoGc73zI262tnZNNd/F1PkybmLMZQkaMA2C/Y2Iq5uVDKMlJbsMUsifj4WPrgby/xvchWguCU0IKJJ0dFUQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 04:46:43PM -0700, SJ Park wrote:
> On Mon, 20 Jul 2026 15:34:08 -0400 Gregory Price <gourry@gourry.net> wrote:
> 
> > DAMON operates on physical address ranges, which can cover private
> > node memory. Skip private-node folios in both DAMON's migration
> > and reclaim paths.
> > 
> > Signed-off-by: Gregory Price <gourry@gourry.net>
> > ---
> >  mm/damon/paddr.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> > index e4f98d67461f5..c741a94319750 100644
> > --- a/mm/damon/paddr.c
> > +++ b/mm/damon/paddr.c
> > @@ -12,6 +12,7 @@
> >  #include <linux/swap.h>
> >  #include <linux/memory-tiers.h>
> >  #include <linux/mm_inline.h>
> > +#include <linux/node_private.h>
> >  
> >  #include "../internal.h"
> >  #include "ops-common.h"
> > @@ -250,6 +251,10 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
> >  			continue;
> >  		}
> >  
> > +		/* private node memory is not reclaimable by default */
> > +		if (folio_is_private_node(folio))
> > +			goto put_folio;
> > +
> 
> "by default".  Does that mean it could be reclaimable in some situations?  If
> so, could we check if it is reclaimable?
> 

See the damon changes in:

https://lore.kernel.org/linux-mm/al-pkvmgIxGu3LzM@gourry-fedora-PF4VCD3F/T/#mfb99303c85dd9d4c3f58832dc28fc55583a7217a

> Also, what happens if we just try paging out the private node memory?  Will it
> simply fail?  Or, make some problems?
> 

user controls for MADV_ commands that affect private node folios would
skip those folios - exactly same as ZONE_DEVICE folios.

Which I'm not sure damon actually handles correctly presently (zone
device).  I remember looking around damon and thinking to myself "what
if this is a zone device page?" and not being able to find a satisfying
answer.

> >  		if (damos_pa_filter_out(s, folio))
> >  			goto put_folio;
> >  		else
> > @@ -344,6 +349,10 @@ static unsigned long damon_pa_migrate(struct damon_region *r,
> >  		else
> >  			*sz_filter_passed += folio_size(folio) / addr_unit;
> >  
> > +		/* private nodes do not support migration by default */
> > +		if (folio_is_private_node(folio))
> > +			goto put_folio;
> > +
> 
> Same questions.
> 

Technically there is nothing in migration core to prevent migration
operations, it's done on a service basis - hotunplug, reclaim/demotion,
user numa (mbind, migrate/move_pages) etc.

Operations on private nodes/private node folioes are refused if the
capability bit is not set.

~Gregory

