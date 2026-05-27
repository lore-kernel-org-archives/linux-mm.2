Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42B90CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 19:10:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8674C6B008A; Wed, 27 May 2026 15:10:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83E666B008C; Wed, 27 May 2026 15:10:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 754B56B0092; Wed, 27 May 2026 15:10:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 65D026B008A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:10:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 17AF11C04CB
	for <linux-mm@kvack.org>; Wed, 27 May 2026 19:10:58 +0000 (UTC)
X-FDA: 84814142196.12.BE5956C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id DF7851C000B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 19:10:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C4d5Ijrn;
	spf=pass (imf21.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779909055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fOfRGPugae13jAxurJtrxuSo8jWBso3MtJfxNQrI0Jc=;
	b=j9oOK8Z475aSI+6dNoDvspv1QLjeHTcIbcluiw7eNy2DZe2zWka4dp8htuN4G2h3ID/BkN
	e2Z/CLxckvcREirNffldQMuM0W/NUBHDUXh4RS7WqNkIxi9lzcYo7W62qS0ZRcaEEBwUGv
	CBpmrgNdI/zbxthA+aF7/1FDfAopQRI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C4d5Ijrn;
	spf=pass (imf21.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779909055; a=rsa-sha256;
	cv=none;
	b=g466Fp6iF4XnKJZYJVt0TLN/BVmWzPDk6zMK7MvOp4GG82/5CUmId4L95qkGnKo3GTq0vJ
	DZJmbEFYKvyV22LSYiU+Qiw3EFLDk7FDKQh3Z3+xHVNaDIVvj1zomzmhkmZVFcTJoCsaQ0
	FO9f3WYDzYvFDh2XAjD6L+N9iIStUfM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779909055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fOfRGPugae13jAxurJtrxuSo8jWBso3MtJfxNQrI0Jc=;
	b=C4d5IjrnnswTyr0ijZjxs6/VSbyTX+niq4VyRVk9zuHTr3OTx+Xbf0MlAs4za6esZZ3NPC
	8Pk+dKgWDpekkLx8imBVZAAaGlkBvIgeD9LH++g1SEHxMjN6TQn+MOh9RZS5w7LhkbrGQA
	IyIq06ehoPpCCL349RAC9RfIPPqxALs=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-YZ6OqOb-PIe95cPhwJQH2Q-1; Wed, 27 May 2026 15:10:50 -0400
X-MC-Unique: YZ6OqOb-PIe95cPhwJQH2Q-1
X-Mimecast-MFC-AGG-ID: YZ6OqOb-PIe95cPhwJQH2Q_1779909049
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-5104b861649so35232331cf.1
        for <linux-mm@kvack.org>; Wed, 27 May 2026 12:10:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779909049; x=1780513849;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fOfRGPugae13jAxurJtrxuSo8jWBso3MtJfxNQrI0Jc=;
        b=Gmi9B2DXj4jkhTuCl5z0foOwZjhd++HTGHDMrj41o0NkOkXGNwd5IKQDq6pSOqreIm
         tC6MC+yQS3+O4l42/XolHErs1a7k2823N8iO0Fbp/sXbwj4fwlGjIdN6LmSjoP+pucr/
         reZtuC/HAYzkSFnbCHRe0bxmuzFsE/h1uQ/BWzzZPssxby1FTbRYCc6z5hCuIW7mCZx4
         ow/Xp5vnMoTuclBhV5hxIhfdqDyyiMSIKBi/XCZLBxuum4YM/5nFMWkI+au63q9R6tyX
         BD4Pw1taS+AWjvOHdystNCJU9dcuwgHb2GMTKJL8a55LgS0VQgj/ujCnpJhFdT1aM99i
         wT0g==
X-Forwarded-Encrypted: i=1; AFNElJ8+hbR/Z36sZE3gOiO4uggQGlTagzc6DY1y6G9FtSF7jpr+ZOVk6sXWXWrtbQ+PWXDB66tgcyM1nQ==@kvack.org
X-Gm-Message-State: AOJu0Yzut9usQmCCr9qzlGXkkNnRSlnk/tgllvz6t9R0A8H6wiJ8pJ0Z
	0uVTrvcN8wuoHQmcrHxGcDXG12uZ6fhacVxP0zvObmbO0udtGtQ42fKt5JvgAJ9QkG2Nzc41Z5W
	ia6FXsrps8H0wkwepgeE4mtKPy+dvRob16vdecZUmQAeJBnQfOp80
X-Gm-Gg: Acq92OER61RiwDDDs75VNjI7UoVjfILMsEzeflA1qYPTMNu0nhIYgpzWYkElMgNGpdC
	QK4nn3nHl7gdQMUFjIovo3EGaq1cPJk10GXZYUaW1sMujUY6F/qDsaq2GNrfnvRQKfS3fsgG8iP
	RggVUTavlxqOgx0Lz6WPSNYZv9OFF2ybntVowQa4JvXv1/PwrE/63IxS8Jiy0rmFZSmKOsKD8rn
	/PH/NRAzK79llffax0bKOAohlgo9d2akIsBYjECn+8xH+u+jHItiv+az1vFc9LFG2jLTLg5pdw3
	XBcd7ENnTZEk+0qSN7aGWlBvyNTHceMsm/cmnVTb3R/u12u/5v9pcV2QFdWDtLlnpPwIF57nGA4
	yuFMVe4HZmgDF/DI8gNLY5rDvdDMULQlIBDKSyxnrB0vuY3ng46NPlT8l+nftWSeJrajFy/xch+
	L+
X-Received: by 2002:a05:622a:2d5:b0:516:4fc0:27ac with SMTP id d75a77b69052e-516d43e4561mr348875511cf.50.1779909049472;
        Wed, 27 May 2026 12:10:49 -0700 (PDT)
X-Received: by 2002:a05:622a:2d5:b0:516:4fc0:27ac with SMTP id d75a77b69052e-516d43e4561mr348874431cf.50.1779909048607;
        Wed, 27 May 2026 12:10:48 -0700 (PDT)
Received: from localhost (pool-100-17-21-205.bstnma.fios.verizon.net. [100.17.21.205])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51706adc8f3sm51751971cf.18.2026.05.27.12.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 12:10:47 -0700 (PDT)
Date: Wed, 27 May 2026 15:10:47 -0400
From: Eric Chanudet <echanude@redhat.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Maarten Lankhorst <dev@lankhorst.se>, 
	Maxime Ripard <mripard@kernel.org>, Natalie Vock <natalie.vock@gmx.de>, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	"T.J. Mercier" <tjmercier@google.com>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>, 
	Dave Airlie <airlied@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/memcontrol: add dmem charge/uncharge functions
Message-ID: <ahWfypvuTVsB-pHQ@x1nano>
References: <20260519-cgroup-dmem-memcg-double-charge-v2-0-db4d1407062b@redhat.com>
 <20260519-cgroup-dmem-memcg-double-charge-v2-1-db4d1407062b@redhat.com>
 <ahB7pCu_G4vuswc0@linux.dev>
MIME-Version: 1.0
In-Reply-To: <ahB7pCu_G4vuswc0@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SVOtcHRYb9uRKDiWo3LfECwAHFBesWMz7GsglVktk7c_1779909049
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 5srs1k3jgw8inmeet9eua8x7st6szhfj
X-Rspamd-Queue-Id: DF7851C000B
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779909055-329106
X-HE-Meta: U2FsdGVkX1/rGFxgVpiWiJBV7SKJx2lbRdy1E9eOfOG3g6pCdBJNo4iJjwm8qqQ6PXLVGnZXkwKK1crJintm7ECenCUo8vxCEmt+kdcYuHQw041OrbOOoVlXv6MUp4i59GcHo4SgBra2OiYMRhI2o9x/zDrqJdBpJDXIJLx47MQiVVUaR6tUjFU6TtH5/n0MVEE5uu+Qs+HJwef1GAI+jbZvQMWN5gTjSsftzkhqc/gXfF/zrwihfX15mBDmDPh+w6yS23dfhLsqyRDGZsBKp/iIwoG50DR7V1Y093PX9OtwYuXKbYwUjfpoBcFHQULiYEWVNVq8gI+zgfGrUHybCTgygYwVpyHr63OtpR2VbuWPPHOzk6x0PXTiLJxt/sV+1InR1+xQF4UNi1gkLLZACTV0+xwKXhx3HuYM2uHAxn37yjzepRJnsVdi9kHCEc1SmSDAzIKJK4QTXD3x0B9pFZ4NusIRTKoE6/oP6/dUTRPxOu3b3jVsfb/KIm+WymUGmtq5vmmUqErDCovH7Bmpx3B9yya895IT1v4HiSlDnCBJ8vFE9dR9s1mJkkRiDVzgB0YOrWOV9NbJ0ipFNPynL0oP944NyxoP2jJuctNFj87tAEH+kE7NS6VlHBGXg8PhICC9ByjkktXhvanqG12EhJ2wRzE3ua9BiP6eATLyQxnbuGx4myDIFZeubPuxEaCf/rkGyvIOurXvg7RGWKPsebhlnawfq1lsMS4wrZeQg8OLpuF3TpV8iMBE2HZaEZa7Ylt5REWSbtNJooFgRQjzBwNeYDJgAObuTPVw3Cd2DtcjOeV2qAy/cwaqrq61LNLKWUBbucQDnNKAJKk6zI7jcXyoYDfdh3cYSO0KOFOlil60tX8/i65SqMJJV00HFQEBinWC5jC/uGYfqOwguEe4SUdqhKxwyqQGISFKjyDLOctEBYZ2cR9DiyhFzDQbgotcw6br9aqOhRuvQbw050N
 cSuAZqjc
 jsT8j8QYeU4HOgjzM8EWZqCSkv7uRnadq1uoilC8szdoMT0uwmExjGSsbix4dfmII8oAJgjhfqSi/pO+uB3a6aoPqp2oauq9sSx8GXvxZ695b9RAtbqQDfJyiEI66YHdKot0adlkeTAoSQJXwRQlWAOFINLapGfoD3sveRkoi+LQJRqGDHOLN0bXCIPZNEOzbQxiRe4C9R6bu7hcerW2sqkism+2wBHBcZve88Tx1sfDiQCziejdHLVW8FJZFlOKNPG4zVp2grKCBhJJ8nJLcNAjQBrVhLPfuWmpTJWv6r2agByWsgJEg1K36cki9y+spVA7iG+8R9PWHg34YnstW0cKECOoe/ZVCAlEVzVI4jQ8TDTjBi+7zP8hkEMFTf7dxiWdeBizJ9e9S4rcmbhwXXbD4z+qc0X667uiYlQMXGwoSVIdhLz1kTZV8zgs9v61kpJ84tUAfTK3s+RvN3NFSexpUR/dtsokuIx93cc7Qcyhy5GMN8MP0JxZYsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 08:53:10AM -0700, Shakeel Butt wrote:
> On Tue, May 19, 2026 at 11:59:01AM -0400, Eric Chanudet wrote:
> > Add mem_cgroup_dmem_charge() and mem_cgroup_dmem_uncharge() to allow
> > dmem pool allocations to optionally be double-charged against the memory
> > controller. Take the struct cgroup from the dmem pool's css as there is
> > no convenient object exported to represent these allocations. These will
> > resolve the effective memory css from that cgroup and perform the
> > charge.
> > 
> > Introduce a MEMCG_DMEM stat counter to memory.stat to make the cgroup's
> > dmem charge visible.
> > 
> > Signed-off-by: Eric Chanudet <echanude@redhat.com>
> > ---
> >  include/linux/memcontrol.h | 16 ++++++++++++
> >  mm/memcontrol.c            | 65 ++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 81 insertions(+)
> > 
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index dc3fa687759b45748b2acee6d7f43da325eb50c1..8e1d49b87fb64e6114f3eb920293e14920290fe7 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -39,6 +39,7 @@ enum memcg_stat_item {
> >  	MEMCG_ZSWAP_B,
> >  	MEMCG_ZSWAPPED,
> >  	MEMCG_ZSWAP_INCOMP,
> > +	MEMCG_DMEM,
> >  	MEMCG_NR_STAT,
> >  };
> >  
> > @@ -1872,6 +1873,21 @@ static inline bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
> >  }
> >  #endif
> >  
> > +#if defined(CONFIG_MEMCG) && defined(CONFIG_CGROUP_DMEM)
> > +bool mem_cgroup_dmem_charge(struct cgroup *cgrp, unsigned int nr_pages,
> > +			    gfp_t gfp_mask);
> > +void mem_cgroup_dmem_uncharge(struct cgroup *cgrp, unsigned int nr_pages);
> > +#else
> > +static inline bool mem_cgroup_dmem_charge(struct cgroup *cgrp,
> > +					  unsigned int nr_pages, gfp_t gfp_mask)
> 
> Please follow Johannes's request to pass the actually memory object instead of
> naked numbers.

Sorry, I misunderstood Johannes' comment. I am not sure what to use
here. Since these are called from dmem.c, they don't have access to what
was allocated.

Looking at zswap, it uses obj_cgroup. I thought of resolving the
obj_cgroup from dmem_cgroup_try_charge and keep it in the
dmem_cgroup_pool_state, but that made me realize there is a catch with
this patch set, with something like:
A: +memory{max:32M}/+dmem
A/B: +memory{max:16M}

It gets the CSS from the dmem's cgroup with
  cgroup_get_e_css(cgrp, &memory_cgrp_subsys);
  mem_cgroup_from_css(mem_css);

Which would resolve to A's memcg and not enforce the memory.max limit
set in B when dmem.memcg is set for that region.

-- 
Eric Chanudet


