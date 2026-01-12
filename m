Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58B2ACF45B4
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 17:36:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9382C6B0088; Mon, 12 Jan 2026 12:36:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E5DA6B008C; Mon, 12 Jan 2026 12:36:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5646B0092; Mon, 12 Jan 2026 12:36:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A2FE6B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:36:53 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 19A1D13BCBE
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:36:53 +0000 (UTC)
X-FDA: 84324017106.03.6D89255
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2839C40007
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:36:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Nn9/mloe";
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768239411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iIrzuD3V8mK4XZdD49Fp4+4pZSOoDd5AA8lqEVpgoJQ=;
	b=77SnZGie7ac2vP/lhbSJO+t5aAIJ80RClzDi98SKJ2IVchEKdKCXUIl07Lx8f2HQF82X7X
	1ZjycFHcbbM11bVPocWAOHgj96iJwSNqeBavnEHC4lCY2PrrEDb0zrTxVTWALNv5fj70zE
	yJPYzcsTTnhIcvwG/pc2uAB4vb+DX4g=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Nn9/mloe";
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768239411; a=rsa-sha256;
	cv=none;
	b=AeODV9ZwcC3LmSgNL8U81/CDROlm1RTPMbSh8CE9y9ow1WPEpD99HXbA3fT65fIgOQtUf7
	qmGNj+ntbjqOqC5Y/FvCVjsNE1LuKdx7tU439s1h3mEFNFm7F3oskfhbjJZGv/YO9FGGSA
	dTmazmwY+ptOxMQUZkap+FLXwr9iNMs=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4f4cd02f915so49301951cf.1
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768239410; x=1768844210; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iIrzuD3V8mK4XZdD49Fp4+4pZSOoDd5AA8lqEVpgoJQ=;
        b=Nn9/mloed+P6xa+aSLedHvqFMu+Wc8A+TM4HCPhA/4jVPbqUKyolkFmhEibKWBn6YM
         vnpZkcvhA/2AeLiCtcxGMNaEgqn/XFOJYeNOdoo/bbyyNK22O14gWDfApj5pdgEuuvu7
         9tRCVFR1a6xvo6tMB7bOfGob5G3r9q+wUvQNGgGXgSzPUdr0PLCCkdwFD2Ya9O6maiFr
         mVqvZfrzc8txPsfbsjDz2tDa+FM/mnPPhrKV/gayUp18mUEVTIn4IbgqAQ5TrHEWII/H
         QPvBnDBTyiIhJcUh9wLVEKDNIkhQ0fg/eWiZ78jLaFbVb+FuTbq80BqAunT/SBgDDnP0
         jAXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768239410; x=1768844210;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iIrzuD3V8mK4XZdD49Fp4+4pZSOoDd5AA8lqEVpgoJQ=;
        b=ojx7S3yNRP5X9gTXo3cYvHPf1GFH/I0/eM+9AFQVn40uKgsjmbkCgRFnWpkMvG2S0O
         0coFcOr0FPNG423uBO1yces5M8LiUjgmKpGa4Fk25dK69IipPLXcpCpereTpYzRO6Dsj
         H0VqeoOseYdOWeBQ1CltwYfxr1cMS6nwtd/pfiq1svHNM65nn8pc6xe6T2T8reIwmzAK
         P+WwpQJSzikn7VgbIFMCd5SafVubk1/4A6VZxp4E+A0GxPJNqkY1ydsDnFd4BXFdJprA
         if7h5M3HPwWlJijgtlHGOSECk7WZjT7ipC2xReblWqQfrfApE9bTT4pKs0v9wzDW+wW8
         WhGg==
X-Forwarded-Encrypted: i=1; AJvYcCVdca1Um8LbkBj4h71qcwZxsciqynqysHvfIVetVcjLkCD4qioJjSfmrWxkquOpw8jiCXhhtNlF4w==@kvack.org
X-Gm-Message-State: AOJu0Yz2lX8zwbYzhVtLFX4SLGE5IB6jkFhi2PU4EbBQ1BYlAXEv/kkw
	3efqS/HQ55BUZDA91vJueHF7SPaKLL871KFAH1mkErMsbqKZOFVkVfaH5y0d89rFI5A=
X-Gm-Gg: AY/fxX4anbMuBnzHBkZlhp+s07sdfmix8XzRl7hcQzyDCSo3Z8RlQxw8fN57fRPn88E
	Mp9I8Z1oqUPWiJIcbMhcEH7tH4v3J+VXl1uZIVmEGRqTs204dexO+s8ccmNgwu/bMPgEKo2dKK9
	O55yuRtYmSet4p1lKSyLnahdZIowhKnm6huCO3QICxK2wQY/ehItXqgFNiljVDxjzFKwIXDbBNQ
	VkKd2ov3QukCMHqAvVA6FWIRnqcsVT/56j9tpBLrwoPuaafN6xz6tiTOU36R4LCeWe9Ott70AX6
	K18bHSUAprehZ1nZTfo9z2Mjc7VFeyUEwGbX2ypkVgETnXrOL1eSQnJXEVUyf6zK9BxmMyAjb0a
	sFOPfoWzbMk2+xKJUBuMrzL66vXiPosM60NAeNfEpHZH/ECpZdcoe+ohk1cq1ATCcniO5eyYC6f
	JuzRSQ1fXq7deTQlfsphuMOfYedVFkWdW+oPpCg11C7N0V4aFx1JFIHHK5BSC+fXOCNm96xQ==
X-Google-Smtp-Source: AGHT+IFIkZj0kkQefVdB6/+qxt7dAorkKD4y+wc4fxceCP23QaEoHwxiHll6IFZYaJtBeI5hcZkdtA==
X-Received: by 2002:a05:622a:1b8c:b0:4ec:f6d5:ee46 with SMTP id d75a77b69052e-4ffb4af497fmr238029601cf.78.1768239410022;
        Mon, 12 Jan 2026 09:36:50 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ffa8d39230sm131000681cf.6.2026.01.12.09.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 09:36:49 -0800 (PST)
Date: Mon, 12 Jan 2026 12:36:15 -0500
From: Gregory Price <gourry@gourry.net>
To: Yury Norov <ynorov@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com,
	longman@redhat.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, corbet@lwn.net, gregkh@linuxfoundation.org,
	rafael@kernel.org, dakr@kernel.org, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, dan.j.williams@intel.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com,
	linux@rasmusvillemoes.dk, rientjes@google.com,
	shakeel.butt@linux.dev, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, yosry.ahmed@linux.dev, chengming.zhou@linux.dev,
	roman.gushchin@linux.dev, muchun.song@linux.dev, osalvador@suse.de,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	cl@gentwo.org, harry.yoo@oracle.com, zhengqi.arch@bytedance.com
Subject: Re: [RFC PATCH v3 0/8] mm,numa: N_PRIVATE node isolation for
 device-managed memory
Message-ID: <aWUxD6yPyCbUVjlw@gourry-fedora-PF4VCD3F>
References: <20260108203755.1163107-1-gourry@gourry.net>
 <6604d787-1744-4acf-80c0-e428fee1677e@nvidia.com>
 <aWUHAboKw28XepWr@gourry-fedora-PF4VCD3F>
 <aWUs8Fx2CG07F81e@yury>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWUs8Fx2CG07F81e@yury>
X-Rspamd-Queue-Id: 2839C40007
X-Stat-Signature: zcx8q4tne48smcdy7e1wtbkaox9co3nt
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768239410-879075
X-HE-Meta: U2FsdGVkX1+L5mbSe5c8cwEluKA4CjaPeRIoaIn70j11SEWImu2yQL1WGdUOf9Ygh8Tqrq0pWtiihI0wtYOjFWZNVw5vSEHx3zfBO7b2gPvPVR6xJG57/3vjpfFIqsyheFFG1P0NuufHCN8ndEVNPYVD/oUVj8hwK6WjbvMMHWq+lIMcrMIwCkolzSTzgM5VNQbMQ5JyW6OhvQXLjNO2c2Owz1dZvdIuVVJiB0HAccB3of19HazoPB6Lg2oSBDTTyxZRXoL04FcQ8vKR1fjw4MlUKKqnfrrd8f9UbFkgedZhVtjx+Mc6VC+y3fhD0u/XJkS4+t6C4Xg8TK72y2R9MO5Opd+Q32CMJp3ra4eIXOZkL8ljIDnUxrpCctfGncRXHktv9zO7ITMVERBVZ5ruwf7PrC0EGMcuoSrBWTr0tJx+HkMEj6O+h9GCFqE0YiA34d4a2UispSHw7LStT3x/seNVdWa7SnQzcRrg56uTFFeSVRSguBjeizubwyFzp74ytEmXcCQRMZREMogL4w5vOa9Kd9FuGUsT8vMOdENlAYxQ9KBN8xyQhxgX2EjFMu0QH07rTWPkLsZk2m2JevZV/TooxqFRtWLYU159HSp69dWPRRp0dJBhXtNMjAxOGJ4B/K167DEBLUPXGau4Z5oTDIepBsF0sanzK/XSFAgBZpySNiVBtZYuKM3x5p8hFpC/kBzIO7E+9CSJpwn1BMNd0KDbN1TWy0cA79KD93/hRpFLXRwzCf53OqcGAJyrTeRTpK8NkBdO0RgtpdG+FITS0BExqHeg8/jQmoJeQrIt48ZneBzXw3lHx8LJ7CZk2iBQYvqNA0TXXkHqeXg1s5wLxRsms12t5Fd/mDfGLdqug3JOHbpN+5bsQQTE/y+UzvNcwVljq22OTjDDfkbgxu1HQzHpbpq08Xwm9icPCcqN7lNfu+4l2b3zs89vgRkpSS7AzKLJHCMROq8hmPSqdBh
 p/jAXiWd
 fOs4XryPBUXDhtqKrzfOOfJNmBoPt52c8Gp5bfldbNoIHuL998OVdIRofMieszprKR7gz9KZnBy1PKiWiS/hYYfamDH3AxdRXBGm0bKbV0XxjAE9WNYtj5xCPXVbdrKOlA/p5XOqe4Ene1n+3a0VHUdX7h+0GuFInP6NV4PEsh2MhA/OexNCaCLeVPjHhTTqiuCUfr900h7Z59GnrJv2t+AQgqPm8P51ZfiqnoS3AvpQvIPnteq20tMUEHcpZjjUQ/OCVK7IU7sGjUYKh+XT0tbp+4l6sxiJL3FUPWx2nSxcrC3igiD+nzCxvsE1pbDvqOwAIq/75BFcKSwguy6wS+lyoqFzx8Mat2aOpJYMzwat0DDMeB0B3GxOOw3YN4G9BEdb0f75+lZ+z/NWo9URh7li5eFt7T44XNXQC93fpCUmtJfUimKbojckTqackl37Mwrq6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 12:18:40PM -0500, Yury Norov wrote:
> On Mon, Jan 12, 2026 at 09:36:49AM -0500, Gregory Price wrote:
> > 
> > Dan Williams convinced me to go with N_PRIVATE, but this is really a
> > bikeshed topic
> 
> No it's not. To me (OK, an almost random reader in this discussion),
> N_PRIVATE is a pretty confusing name. It doesn't answer the question:
> private what? N_PRIVATE_MEMORY is better in that department, isn't?
> 
> But taking into account isolcpus, maybe N_ISOLMEM?
>
> > - we could call it N_BOBERT until we find consensus.
> 
> Please give it the right name well describing the scope and purpose of
> the new restriction policy before moving forward.
>  

"The right name" is a matter of opinion, of which there will be many.

It's been through 3 naming cycles already:

Protected -> SPM -> Private

It'll probably go through 3 more.

I originally named v3 N_PRIVATE_MEMORY, but Dan convinced me to drop to
N_PRIVATE.  We can always %s/N_PRIVATE/N_PRIVATE_MEMORY.

> > > >   enum private_memtype {
> > > >       NODE_MEM_NOTYPE,      /* No type assigned (invalid state) */
> > > >       NODE_MEM_ZSWAP,       /* Swap compression target */
> > > >       NODE_MEM_COMPRESSED,  /* General compressed RAM */
> > > >       NODE_MEM_ACCELERATOR, /* Accelerator-attached memory */
> > > >       NODE_MEM_DEMOTE_ONLY, /* Memory-tier demotion target only */
> > > >       NODE_MAX_MEMTYPE,
> > > >   };
> > > > 
> > > > These types serve as policy hints for subsystems:
> > > > 
> > > 
> > > Do these nodes have fallback(s)? Are these nodes prone to OOM when memory is exhausted
> > > in one class of N_PRIVATE node(s)?
> > > 
> > 
> > Right now, these nodes do not have fallbacks, and even if they did the
> > use of __GFP_THISNODE would prevent this.  That's intended.
> > 
> > In theory you could have nodes of similar types fall back to each other,
> > but that feels like increased complexity for questionable value.  The
> > service requested __GFP_THISNODE should be aware that it needs to manage
> > fallback.
> 
> Yeah, and most GFP_THISNODE users also pass GFP_NOWARN, which makes it
> looking more like an emergency feature. Maybe add a symmetric GFP_PRIVATE
> flag that would allow for more flexibility, and highlight the intention
> better?
> 

I originally added __GFP_SPM_NODE (v2 - equivalient to your suggestion)
and it was requested I try to use __GFP_THISNODE at LPC 2025 in December.

v3 makes this attempt.

This is good feedback to suggest maybe that's not the best and maybe we
should keep __GFP_SPM_NODE -> __GFP_PRIVATE

> > > What about page cache allocation form these nodes? Since default allocations
> > > never use them, a file system would need to do additional work to allocate
> > > on them, if there was ever a desire to use them. 
> > 
> > Yes, in-fact that is the intent.  Anything requesting memory from these
> > nodes would need to be aware of how to manage them.
> > 
> > Similar to ZONE_DEVICE memory - which is wholly unmanaged by the page
> 
> This is quite opposite to what you are saying in the motivation
> section:
> 
>   Several emerging memory technologies require kernel memory management
>   services but should not be used for general allocations
> 
> So, is it completely unmanaged node, or only general allocation isolated?
> 

Sorry, that wording is definitely confusing. I should have said "can
make use of kernel memory management services".

It's an unmanaged node from the perspecting of any existing user (no
existing core service user is exposed to this memory).  But this really
means that it's general-allocation-isolated.

ZONE_DEVICE is an unmanaged zone on a node, while this memory would be
onlined in ZONE_MOVABLE or below (i.e. it otherwise looks like normal
memory, just it can't be allocated).  In theory, we could re-use
ZONE_DEVICE for this, but that's probably a few more RFCs away.

I'm still trying to refine the language around this, thanks for pointing
this out.

~Gregory

