Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE309C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 16:46:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D55896B008A; Thu,  3 Sep 2026 12:46:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D06906B008C; Thu,  3 Sep 2026 12:46:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCDCF6B0092; Thu,  3 Sep 2026 12:46:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8FE066B008A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:46:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 23B12160574
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:46:23 +0000 (UTC)
X-FDA: 85173029046.14.94A68D2
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5C82B20008
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:46:21 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=TTAgliud;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788453981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DdNX6dTeBhf9TPydQSxz1SFFzrTi4xL3L0CTsNHdKsU=;
	b=NDN+FOVAc4knrf2WrEplLJpvct2cc3ue/4/bhTssQVBKxCpDbK/oIRoLQrMqQijWBhb5w9
	XW49z6ji/okThwqj6V/e+7StNGe9USTlX6biiEnuOjvFtaowR1YxBtwIqvDKksc4Xqi9/I
	ek+AAYVyTCcZTxLaSO1GvJoPppNtPxA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=TTAgliud;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788453981;
	b=MP3y0K/7mKWnQAXbhXDYkjFSKOjxMwPbjAYWt4gCvcEfwgx6sv0X//SEG5IwWM/tO2KqB5
	5NZ47L21ab2RylvhREpyAU7syrkxCAKT5ywU+ZSclo0fmlpX6fRXF/UCGrDkM7Mfte7imY
	kFL83qvBtu4vJwpK60/FeZ++L9Cz9xw=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51bfad59921so1636261cf.0
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 09:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788453980; x=1789058780; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DdNX6dTeBhf9TPydQSxz1SFFzrTi4xL3L0CTsNHdKsU=;
        b=TTAgliudRSM2aBf0ysDaUfIMNT0BkhzQHK49KpmuZiZ2He2awVswIzSS+OMmV+yH6P
         FDbFwbxxKUgBddN9J/hVTxhxK95rZVHEno8LOGFvf4h+ako7wq0ddRhGveRwRVXYklgl
         waqVwAf2O58qk3Lyu5tFvmQTGHeEufy1qFgc/rbc5+Pc0r/JzY3QL5n+KcU4zoCnFWhK
         hPizAAlNHC0Tf57ouEcSTgzsQxeFBLwB8skXZjCeOKjRpuB0NG4p59tIUwgWbpSybHde
         Varojfcdi9oMrrV9/UUEa3+MPP1dJXNUAeRD2kAueSbG85pW8tiopddJSfw/r5e8y5I3
         7+RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788453980; x=1789058780;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DdNX6dTeBhf9TPydQSxz1SFFzrTi4xL3L0CTsNHdKsU=;
        b=NLHND7+0i+vmjVE+210emsZnodAwCOC8tcowlx8UyLfmPySrCgfP0y8zQ8xUQmGGsx
         o4Ms8Ad/9YELn9dPo9xdMobptjR2gAiSQ1mAcODsD7mTT7osP1xCXaDrexKt/Nq3yEpV
         EVDRoKf/1yxYMe371pgHgmX09sVEIU5doA2ubGWXomjo74EeUfa+isxlMKgkU9QjqvQJ
         01YBv4Hho96v0hCnMH2ODUMZuOwSFk3bF2a9yjv+nVYhOy0IKi/kI+qglJwfZeZVc9NU
         /r04/tuS7AHdEodyGjqG1tUtZUf9D7GKHfRC3JjB1osWTlHgtBK9sSkdrvRH+IuoVTyc
         1uSQ==
X-Gm-Message-State: AFuF++lIBeYlMOBiqjyW088UFGqJ8ySbkPQr5wwPLxb4rExj7x1HWKcO
	C+cDJ5Zd9pCD9hLdsPvXDHVaj9dPK3eUHVHgozQBcBWhzFCSnsJvzIqK5G8VrfCDG1w=
X-Gm-Gg: AYBFou0A+HMiYzcrme5r5sMhM2sD7IywrsK+uh4gWa//o5/qU8o9kOfI/VUyW6UYob4
	plKyzlJOJYwqlVjLcBI3pBGam3laySB9CGm9wVaIUp/YDX34lxQKfXmVh9tbgy6cmDvot8qKBEp
	OdEBkMerpSTh/v/mUYO8Yat4zelQOmi3uXnViLsAReP4i+qGmQ4m1N3qpaR+k63AkSc0zj5YtTz
	nvPqZtzKIMxs40cxVGOLaAifK9fSlJ0ns3wQDRyymdT535mclsGwp9olSRHXACFphZZkeaCyFcF
	w4ZqbrBQdHAqM+y43H1Liz5sHlyd9UwU5DjEjmZ8OpiPhZ3FC0n7vOWXl7a4wlzWYr41q18MQBm
	hLuyrprlG27/E1JfKyZkqq+Fn0c/inPPpcHCFhfMM7JBZksWDJ0A4MV6WWu3xrFGEahfiBRHmcH
	1Gr/ks34bTOY3Ql9egDqK8xQ7XpEL+wBhLEJ1RO1xVHvXpby+nwCf3c8V6BV17xquboI2mEDOb2
	s2uRGjuCRZFakKHOWFqCBSkvJBcWKDAk892QMvX5aEU
X-Received: by 2002:ac8:7dc2:0:b0:530:4310:5397 with SMTP id d75a77b69052e-53043105654mr92555931cf.47.1788453979979;
        Thu, 03 Sep 2026 09:46:19 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5305402a8fcsm1072171cf.1.2026.09.03.09.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 09:46:19 -0700 (PDT)
Date: Thu, 3 Sep 2026 12:46:17 -0400
From: Gregory Price <gourry@gourry.net>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, 
	hannes@cmpxchg.org, ziy@nvidia.com
Subject: Re: [PATCH 1/2] mm: refactor find_next_best_node to
 find_next_best_node_in
Message-ID: <apmkUWQqKHAZHMaE@gourry-fedora-PF4VCD3F>
References: <20260902215853.156267-1-gourry@gourry.net>
 <20260902215853.156267-2-gourry@gourry.net>
 <906bae9d-dcf0-463b-ac9d-81ef8cc2cc2f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <906bae9d-dcf0-463b-ac9d-81ef8cc2cc2f@kernel.org>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: jzccbcquasza8bydcurgh8d8fpxmr7in
X-Rspamd-Queue-Id: 5C82B20008
X-HE-Tag: 1788453981-700285
X-HE-Meta: U2FsdGVkX18BKP26ar18I7Kk4a6QTGddnFbwzFu8SaDI57BB+0DKbMQvXOKNEodyNRBOINnwYaF96W1Q2Y7hBYmBG3QDna6IEoaPKa244MEpJ9ka4HAFD+5x/Mi1Robhq8t1Wd9GF39lx74M4lcMYckJ+9j2P5HRKAFKlYcyI/2FUzZG8RxeFXtYfYC5R7BdJlspOQ95TTfcSioKJlRsxUdvR7iqG/lcEtwPJ2N2edvmH0cvelLGANDhM/GfBgWaOW7YHsmfEina/KEPc0YJBjOtNDvwhYgdFarity2hsnJFaBK9LjPWsNDoeN04jgCtSA8kKIA0Q2ajYWF9QNGoquvPFhNMMThuKI5L2ZWKmLqmpzYoG0avX8DbDAVyzGWBQHKjYFWrc/9fmTo7tX9HGcVCw1N2bvdevimzWKjUaaDvkFAaKi2RZEnldllzk8gc67t8kPLnyUzhHOK1db7GClEY4dQiLbD1Yf+jhQtntd7UB7di/r5JWCqe/VsJ/sgMiKY4dMGKtiW5tOTi937jkeRtiW78O8fzXW7olaKY/SejIuPuFOeeIdvolCyGVgCUjil0mtyoT+r2g4lPAMpSwsu/W5MyT9bkTef+zv526W8LbQ2BgAGrdJXn8LpKPQQiRcREwl2ObdQUDB5QZ/BAIJNUYFLEHZqKrsTLMyyPg4I4MqizP3Jpij/v3Z9SP6nHGTy/p6oUZoR13xZDv8dQD1ErsdymE4MeRtX+UZGZzFOeYesYOkfJawN+5SJwFKW2X4+UsN4Ivhhc35Qy5wkH4DFTQ9eM/uG/XtJO/d3sOkCb+QHEjd14u7pL5GIbMgmC75S+TK+ucjXxFpp/bFHKhokntu5aJ+sMiXaeYvYDox1/VXT9HxKpDTxl9ZHFyw4CmCjtJrXMdp9iT/Brb6UQUOVD54X4nVWZ5LCRhtvHxikzPyR/a52Zfg+E5QW0YVwSKKP5VTQY/UiX5nfUC72
 qyxXyhoQ
 Y3w328T0/7OpL77OJ3V8DW73y25ONTVRkaq7ReL6avlij5Vl4f51S6ZUcCxq2Kx4rT8fegJx7J7IMLyttlnOHR+2pr5I6Kqpf7u/wRc4AGoKLa4WxDdY7vgXvk0z3t96HxILhVO7rDZ6O2NVGgqR7W2nsabvOvu+3+Q4q3ZanpGEnMzuqMhCaQK3BNsCOp6A9qhJmdz/85/gbVKu7YXFBp+RENcfdshUItXN4L75v1ymzYHSbyAoagw/V40yKqUvQYqGZrg50/r92kfYl28ebgtM9lXvDNNfFZwaa/hlTuYjrLbT0fJHQq+yPvsb6O+emlr4mzIgrAD8sPEoOdZPf4U7LVqZ1J8HFk4ymBS8svwm5G9MV8JQEgBWrE7VCLKDwTCISLZat2DaQXfgxLgfY/m7sy/cfEHSCILLWCVSqwmFMuZahh1hu9IPs5ZGAVMeDO8YCN4FRgcmlYSM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 05:15:23PM +0200, Vlastimil Babka (SUSE) wrote:
> On 9/2/26 23:58, Gregory Price wrote:
> > find_next_best_node() picks the next-closest node for a fallback list
> > from the full N_MEMORY set. Refactor it into find_next_best_node_in(),
> > which takes an explicit candidates nodemask.
> > 
> > This enables building fallback lists with non-N_MEMORY candidates.
> > 
> > No functional change: every caller still selects from N_MEMORY.
> > 
> > Signed-off-by: Gregory Price <gourry@gourry.net>
> 
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 
> Nit:
> 
> > ---
> >  mm/internal.h     |  6 ++++--
> >  mm/memory-tiers.c |  7 ++++---
> >  mm/page_alloc.c   | 13 ++++++++-----
> >  3 files changed, 16 insertions(+), 10 deletions(-)
> > 
> > diff --git a/mm/internal.h b/mm/internal.h
> > index e16f1250b25c8..18d041ff5c52c 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -1130,7 +1130,8 @@ extern int node_reclaim_mode;
> >  
> >  extern unsigned long node_reclaim(struct pglist_data *pgdat,
> >  				  gfp_t gfp_mask, unsigned int order);
> > -extern int find_next_best_node(int node, nodemask_t *used_node_mask);
> > +extern int find_next_best_node_in(int node, nodemask_t *used_node_mask,
> > +				  const nodemask_t *candidates);
> 
> Drop the extern while touching a line.
> 

ack.

