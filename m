Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3AD3CD4F25
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 15:56:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B04D46B009F; Tue, 12 May 2026 11:56:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8E2F6B00A0; Tue, 12 May 2026 11:56:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92ED06B00A1; Tue, 12 May 2026 11:56:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7E3846B009F
	for <linux-mm@kvack.org>; Tue, 12 May 2026 11:56:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20BFBA053D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 15:56:08 +0000 (UTC)
X-FDA: 84759219216.04.F79724C
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3D1D040013
	for <linux-mm@kvack.org>; Tue, 12 May 2026 15:56:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JuqxLq7+;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778601366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Su8Okdv9QVtgiODRxP6QoL4RhbVAvigNNa5QAGhM4ag=;
	b=J0yCIWC+P4ii4Cs3c3MMcfboSxjhWgYbbxNQywQ0atiaTgWl0/7+ePQyYl2hvqzXN9FHep
	zu7tD2pIdI6Hla6dnKE0EQHTcD8ado2MMB/YRLTjbM2lSZaxcKTP+fU23kpGybVST6RmKn
	yehmpiEKs5UmJm53zjNr19zPfFD7OUk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JuqxLq7+;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778601366; a=rsa-sha256;
	cv=none;
	b=wVao24Kyn91GU/zK969TjDme0qTB21P4+hgatBTT4UEML2RoAJc/4baBqVFhDlisEEIkck
	mR35s25Mx5O4U6Vpbcn80UhF9qZ4fLTxVW9HbAoc0CIFEAMmBA/u9CzlAL+fR/t1ihCEpU
	QSzoduVMp4UdNiEzNH3k+VmpQvrlQMI=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8b4298d271fso95243526d6.3
        for <linux-mm@kvack.org>; Tue, 12 May 2026 08:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778601365; x=1779206165; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Su8Okdv9QVtgiODRxP6QoL4RhbVAvigNNa5QAGhM4ag=;
        b=JuqxLq7+2CA1rUWwhfXy6P1qEig3eb9Pv1/jF+EIH45n78rQMjFkuJj4FQTkY/YqVQ
         qaDBOgKDsYVzBqdcjEg6pXCbVRvZmGvsmWJEZkMFDQRrlByNCaRoXi5fxhN8q3g/cgCw
         gGw9+wEky2HMI3cfT78RivZbst55cM6bI3qvlBpguaZStvpYMjEaQ5gGG9n6zt/Ye0bx
         Q20jHBu/auRPXZN5I92cr94pTBs9PNxCNOy3Fl/z3A4UrSJ2I4aB5rQOmodEnMDI0IVh
         RFFEc7tc5QQUw3ml5BnWtA+I9w1ko0Elg/+oO2S7+QIX8BtPwYqwNG7+bVCM4dhEkxf2
         Z/IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778601365; x=1779206165;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Su8Okdv9QVtgiODRxP6QoL4RhbVAvigNNa5QAGhM4ag=;
        b=CW2Vp0sdSwmT+iljybRe8iH2hJcpcV1dsyW3Rh/6JLmNvU15cTG4Rn/tHDyVXN0enU
         /1ejW6sbGaGYTkqrHKuBRJxdWZ92zgnaqAi73B3oEs4qVqU4BMxLNntfoNEUHngW5N/j
         YkPUL9Ii3o5JmgKMVj5/R+Gq7QJYVSDKNpcWNK4szjmsH+p6KdhWCR7HtgUaTXG1Rd5R
         S5IUH3y02IZoCOPkciTvDZlnIwRB+jHo7+wCjxoIXjUjqzHYNRVrXxAq4fo5c2ez6sIY
         tFMyH/yEDrepV8xooi/TLv/7JbOtdXvfSYAP7I74TK01sHPLUv32qUVKvsuxeO+Jo6qW
         5G6w==
X-Forwarded-Encrypted: i=1; AFNElJ+Fx4nQrzVO4J9Ujx2cMTDlhG/uTo6mR6C8+u8SvYko4ziOEsXNYAayarekzjHYMvxYz3CVXrmJRA==@kvack.org
X-Gm-Message-State: AOJu0YzX/Z+WHJhZIbNclwURnaVQDKE40k6itrBgEPXqkTwtGVrTTYtS
	5rwNVWgtAMhDk/eTafE21DvCpGmFrF8IO8snvJN5lwMDxm+KK+ffpyXFoMWc/a3cit8=
X-Gm-Gg: Acq92OHRdRqRrYWOW9CvJTqIvEiDYg/4IB+Vi2HDChjDXsX5iG4z5//yKhbpg9bzDj0
	RQB7ELFhgtRDx6jqJ1fOcadVMU6rwjUhdQJXA25IW/qUg9n+gt1edww91QCPzHQ+En/AMTrK/mu
	h4PHCVIly9PDRi3ZD3o9dSJB+svWQqPsjFw3P5eWdNGybzsi8TNlf0vj/r4a8ZuKRLoW08zvvIr
	n932FpouF90WFWntTXqIQy5mPkYTdafKnJ+UkXjz//vC+gmxosW0YozY3aZ6o3Opu+19dVPzZOH
	Q6O2QN6YZyHCAcuAGbY9B1WrhbUTWnAJrnTz9xL1DTfRZQxRm5Cu38dcluW5c8U3HNcYj2KUvK0
	no/hRunX5xv7/tBBn52/j5YL/DusDiEO7g7GEWwub/qi+q6K+bP+S60FBnX2nxBOr0gecvIcYDk
	Vq2PtWK90VknQt1AmqjLW+kOl2unUywH3eapmJ8a3NFmxzea/dDOI5J4RYanBbUfyMmQe9gu8RN
	AUFdL36qBs3
X-Received: by 2002:a05:6214:319a:b0:8b0:2017:958e with SMTP id 6a1803df08f44-8c6614dec3cmr60146186d6.13.1778601365090;
        Tue, 12 May 2026 08:56:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8bf3a438e3csm129340316d6.19.2026.05.12.08.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 08:56:04 -0700 (PDT)
Date: Tue, 12 May 2026 11:56:02 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
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
Subject: Re: [PATCH resend v6 20/30] mm: page_alloc: clear PG_zeroed on buddy
 merge if not both zero
Message-ID: <agNNkvRK128bYhrf@gourry-fedora-PF4VCD3F>
References: <cover.1778489843.git.mst@redhat.com>
 <a09c1848702368c3545b980c17101b5185ab774d.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a09c1848702368c3545b980c17101b5185ab774d.1778489843.git.mst@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D1D040013
X-Rspamd-Server: rspam06
X-Stat-Signature: anrzyshcjg5byenbzo1utjgrt964pi4d
X-HE-Tag: 1778601366-700320
X-HE-Meta: U2FsdGVkX18GBKDo1Tdh8CkqOyRyI1n1LCNi8YmTdTwfLL1/kHOflwh3ioXDcQ25Cb8IzUcG4GoBvq6HJRF3ZoAg0v66363YGfxAS7xF4uh0jp7v1KWPet01mUgcUXi6Usk9zwnvT8cAodWyOnFsK585enbzlDJKuIDUptpUmHvoGv35EpLg/LG+v5Fyi3nDFVeRS+7Ph/3K6v9d0a5XGFh+vH/sJbE+xrSXZTWCgTFVT8ao9189zM4QR91mmRsfPlZlcc0K9A6iBJerYWmNG+eiag+Htvq60HF0tXKR0g+q0W2CZreoAak57iBlYEh9CS6xE0qmNtGcgognl56YEHaIFDEks5Z4ruZJehMTRXvIp0aTgtYib9+YguehZL9uywK283BUPqPQBF9t1zq3XQ9LU9NSBy9elLVz6u+rkms9nC+xw1UD0GDIzDBmzmHFS3KmMPzMw2DRz+cTjOObRVqheIlB3dyfRGtxCma2X2yjuOIgHT6iy6k6dyjZ0tibuUlw7gysVl5lnX2dTBP1Xtfs1AB9ZDpkvQhRzvEELGZfz9gq5w4fsW+Ea1qEuEeZAqtXe3qPh/Znjnm4M7UbeH6285GJnJ2gIUD2VJxXy6tlBnW6qos5EMg+JsYGx3f20bJPGD6Bp4Bn3xLbfKe5TyHhCBqMmyr56/CDBpJyfdwbQ57tB2pNrZq8vNwZrb51/J5AIWoDd36WZky/2VxiXbbJCCrKP1UFTunLVa6I5SFR80n6RLtLklPsH2qQBPB8Mz6HXbhIrR1BVGCfvmNXfoFAJOccDvI6gPcWdSYa7Z/H6KrXZtY4oGcwFs03H+p/WBYHOyGUcXQEp/UV0pQHYEEEVlBJSQKWuJONxK9yQ6h8oScLRCR56UtPMaPHdBN7RacTyOSjzRGZZCudqx0GL37D+2DKtuVnBN9KB/Zx0tNSrachX5IMiI7u13iC3vJdzDBAPWAZ26Q6s8bRxdz
 OjJqu7em
 lrI+DyQJhddHRryYPh1SzwsIXGO0mDH37pxaH5Po+yusQXusCPx4uUgx9bQU6DcO16Kt3LhWja8cku1aC8eeNxKRwW/LzkAPTshvf2erC9cbqTQm18oZANBK47Gc/WvZgHwBOxHtkDajvKcG1i1+dDwls9NvN3899YfT89ngKetQ7dMB8pzHGv8eNq2m9Mxu/okTjt1NwGtsKP10G9m9+KA9pzC2sfu3Cvpq8l1RSVuSBnrl939BHHOZ1L/vr1nl+2bLVKFEDnL/T2Tmyw6ZBVZApYBhNiHwNF5PVkZnqrXIQZobWIHdEff59takMxz12CsZmOmvkkqtvMx+sC3QsVPKVjUHwANeN92SzIRs+LxNDtblpjctOIheIGXa/nlUVIYY9qzJMN2hbnw8NUlMUHlDiyYOfcrJAF4+4UEIAXYVh1Y8qGzi3z8rkTxAPiXX1776y0vmNzbft0M72YQDhKEi7BqVqqF7IQpSpyn2fl5I4LBoJjwjZaRmiT6MrzOfKvcIAGl9M57q5DFVO/9IO6dujsq5DoD1HxwV57OFoQoZdINZpNSP4AUdq4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 05:03:35AM -0400, Michael S. Tsirkin wrote:
> When two buddy pages merge in __free_one_page(), preserve
> PG_zeroed on the merged page only if both buddies have the
> flag set.  Otherwise clear it.
> 
> The merged page would inherit PG_zeroed, and a later __GFP_ZERO
> allocation would skip zeroing stale data in the non-zero half.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6
> Assisted-by: cursor-agent:GPT-5.4-xhigh
> ---
>  mm/page_alloc.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index bd3b909cacdf..d70c9ba6b329 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -940,10 +940,14 @@ static inline void __free_one_page(struct page *page,
>  	unsigned long buddy_pfn = 0;
>  	unsigned long combined_pfn;
>  	struct page *buddy;
> +	bool buddy_zeroed;
> +	bool page_zeroed;

If you want to play some code golf, i think you can get away with a
single bool here:

    bool zeroed;
    zeroed = PageZeroed(buddy);
    zeroed &= PageZeroed(page);

    if (zeroed)
        __SetPageZeroed(page);

~Gregory

