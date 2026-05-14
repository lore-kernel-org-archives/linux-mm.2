Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C08D9CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 13:54:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EC526B008C; Thu, 14 May 2026 09:54:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C41D6B0092; Thu, 14 May 2026 09:54:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1C786B0093; Thu, 14 May 2026 09:54:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E01D16B008C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:54:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7E174C1EFA
	for <linux-mm@kvack.org>; Thu, 14 May 2026 13:54:42 +0000 (UTC)
X-FDA: 84766170804.11.E305119
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id A859D8000F
	for <linux-mm@kvack.org>; Thu, 14 May 2026 13:54:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=M8qg4LcP;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778766880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sc+w8y4pA95T78hoAVZ6GrlC/xHuPVJr/YU1joizSQ0=;
	b=yUhhbxpvsrRwZuu1Xbqnbss6E9VkYiu25LmgGVspvmMcjVgc9LsV5AKzcqNWETo7I5fheG
	luF0CZYzHZUzgmzokxLyo65qLJJs50737QN0dT9ohA7J+QDFYO0c2lGhe/AUtnORe8cN2M
	Ji7LBUSeldG1YSuVGgTCijsjlw8MoPA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=M8qg4LcP;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778766880; a=rsa-sha256;
	cv=none;
	b=V72C0fSFE5ct40Jmu5wSYQ7bUr/oTNXtr7MwSPxZfIehIz7jbh9pv46dJOyxnDQapD2c8R
	GRDJf9jp9rynOD87nrR6GxHN/9wgvClx1t8TJLzv3CTBb+A+hVAxvisokro3qq7a6YbePt
	3ZKkhikKqaj5nrKmndRz/t5gPUTGC+E=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-50faeb8317bso59107671cf.2
        for <linux-mm@kvack.org>; Thu, 14 May 2026 06:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778766880; x=1779371680; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sc+w8y4pA95T78hoAVZ6GrlC/xHuPVJr/YU1joizSQ0=;
        b=M8qg4LcPKwxBv11Jmkes0ODxzUKN47I976H1PE/RwsWyo6J1ZzEIvE7h3t3xU7svxp
         d4INXQb4LZzrbUG3C7FrwWxh5T73kSnxedSdFR5B0y4uNY84U3lwTiGfTCxvPP2hqTz8
         i8S6MuK0/FLWXwoInIUg/ILtnV6AUUGHXW3tZP9QJblcRu4pgVvaY2FbPEGS+rwjeVdW
         Gxc04VR0dIdARAOsKU93aSL03wcrGPhHWRbiAfZTSAG0HK0J0hCfeCOw8DUUVD6lHCkx
         SV5X7IalosPZ6UuyEipxS2+KgTZCf4YDf8SL2q8pb7FSCGD63R4tqmMmtBUl2zDdqX0h
         HFpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778766880; x=1779371680;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sc+w8y4pA95T78hoAVZ6GrlC/xHuPVJr/YU1joizSQ0=;
        b=Ftkz6e1eQquQku/KDn9krN7DC6QXFmXcuJnyfoYzBibHA/9RObnYQ36AcQYag5VHFn
         f/U2apN3eDNayWS+Br575BbLbWe+2E8kH/P3qByQtEsn+uw8v+563UYc+SowvlVNeUlo
         cLkzlIcRLpRpayrVhrkhIpfNQ4qyJ7/YbgJ0uWCFWn/t1EumjlpPdgQIIIGyBkGS5n8v
         CwRnWt69kBe2LdNJ0QOVAI8Q6dmCmOmjna11NdOCP5Gp89RH4e+tPQwIkSqvmvXB/Rv9
         b2i9DpnzU+URirD5mVa+evvNy9dUy2iT5VZVd5Fgsmewll4affkBkODbrUySDrlvBO2X
         pdRg==
X-Forwarded-Encrypted: i=1; AFNElJ8ryarxVRtTV19YRO+wQniBVqjMRrO6L6OBty8L8noHMGKAqTdn+cQodqeDRv+s7QDgZct2s6S6uQ==@kvack.org
X-Gm-Message-State: AOJu0YwO6PYKzeyl8H8t4SKMe+2FcTyaYg6AfvEiiE3w2B7Y9+C9WHla
	ZdCf/kbVvZr0rmnV9DvSP0cvYVTpF7m+BvtsHJo6PwwVBsLF4k9jzYQF4AEUBrZB9CQ=
X-Gm-Gg: Acq92OH49XGlkfFPeXyxSsGRKmlpsw7BtYbmGzJ/k4GRSgas/Kz8CBTi4xPXPTLWWcp
	rNt+ICplk0hK/6DFZVrS46va7R7w0nZUn1560/HVvj4YJ5QsZ2qf3ttVVnpIRlwqVsUX5vUElVv
	w8wRWkFirsLpIrEx7jtaTkwpujP/IztIqDI2Fz0opU6Yg6WFiYnZQ6u6y+hmEcU7CGuf9QUkNhW
	73MRZrZGMbAyclAYR3DKNby5njyiDw5IlGGjxM+m2KHh2P9oQs/gsEDnDaUKZPsJcVM0d41F/Jd
	WdIg34BBfAFuPfgBQIPJDORlmZp437rtVoFdcbYZo8RHsvQHIRtLE+Tr2I/7FTq5/1uLwk/arfn
	rBPiSGLe6jxaQNci3QCpEP/HDRzrROu0IXBU8/R579+RdINSvvlA5Ruk+2WdMYDl6NV5ttdtaUr
	vxPZp67H5740sMeDLkz/er3bAOVRD5gAAWVlzaIPq2D0tlYUS9BmJLqpEMGQ2H7uSVgK8ac64fd
	8EUShxuTWf6KStKu6u0egs=
X-Received: by 2002:ac8:5fc6:0:b0:510:dc4:942d with SMTP id d75a77b69052e-5162f5e3f73mr100495801cf.46.1778766879208;
        Thu, 14 May 2026 06:54:39 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8c90bb80ed0sm23810396d6.35.2026.05.14.06.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 06:54:38 -0700 (PDT)
Date: Thu, 14 May 2026 09:54:36 -0400
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
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: Re: [PATCH v7 13/31] mm: alloc_swap_folio: pass raw fault address to
 vma_alloc_folio
Message-ID: <agXUHItfxSwtriRF@gourry-fedora-PF4VCD3F>
References: <cover.1778616612.git.mst@redhat.com>
 <66119d3bab318d74c1586b99dd70fb74e2da1ec0.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66119d3bab318d74c1586b99dd70fb74e2da1ec0.1778616612.git.mst@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: A859D8000F
X-Rspamd-Server: rspam06
X-Stat-Signature: dfiezbadb6gwtqfa9ua4xdw6ugnwuaj1
X-HE-Tag: 1778766880-340799
X-HE-Meta: U2FsdGVkX19LbH7UtuBCxPbnwen6CVO2wzXMcmLKUq8cDKoIumUidi+85ctw17Bs0dLxibRmDKnZ0RCOWv3Q3aP9O+GdKvCe9B1S2LnbQJezEjctDvj801sCxyiGrEFcLq5Qmq8KwbcgOUQLw1/1tU7ykTo2doBVag27ChiWlLCjMSe97lsdtbXtxDHTUBDBwU6cALr6MZVRWmXWjcb32/xXIgL6X07HiOfe86NjAter6wkO2u0EoUvQUE//qI4VLsG3Wc1qUxC7r/J+BRL70IaYuePfDDCp3u8wD1KkWUuhbRuyd46hfn3jxIH5Yx3Ov5f86IQF4Reh60YPqtos/C5quuPBLgQEBFtu3vn6FxffPzvmcxflJxnipvcqWGFDDzAPr70BqX+NgnSrjcd/6DpUpcXd5SSuxYJMUWCYlAwjbzozKQp8cUPhmswJFBJnF0VjXq9PKX8pg84GVxCesYtCGw6PkYS3oLBmgqbYK4SDIPkxFHRz8Pnx6KLfSizpvXMPXcCsyvjDyxJQJeEIAa1HNuw6T/xFP/1XkmFgLN0P74xhzVNxuLOgQ8UfMXcLTXc53dIWq9Bt9vGugMVnQ3chtrnxsObvYs3Dm/hxTMDXhSxW4nMXTZhg6HgBkJxL2wSc0npA+w6judzca+Egshhhxq1lT8d1XRire9Zh6N9zzT2XvYJlA0fT1YYRuHK+6aJ6ivSvr6BMtOYEGbLqGUEoknOrqMi4OUHyhRtI9uxJLuabUx38QvfOQQovgN7p33rthr+PXBdFNVvXLDrA6QoggN4KZLCuHrH65fgstkNRvq7NodIbMrfUT7C9shpxe4wRxJrtrIK3q68dG57wXTxwblrJ1VomBdhJgTIp1MhlJANxar4AuA1YiofDcu/L+CQdzQpXos3L3lR7otROzZVrmJWRqRxREBOGtUnoBP7R/xNBDw0eNS1IgbSqEYIkU8lLtr8WZTiU6XDX6nY
 gf9XFBlu
 5GWOxTtIJf3htnLweOF6wA4TvoE+gDu9muQpSoihRrDlS5kEQXkgl98yOsMayArCBsINCI50w2BxrztGgG2ZCD+JTEWJvRC2Fxg3EcV8LvQ/7KRdm5AARJTHGAfp+7vtgYSZ9bH5y8Caw7j2rsCclLuxwXoKVqwTPHZ+iPU2qdstj4vFBGeC+Gl2+tqj5bUpedSbaZo7URiIjAT8d1jLgItzCkLWPCUrK5+L0YmTOrBC7yJUYSvBObANzJuyqPnznqptNEqXTURlfzuSYZMcXGihMB4sbP8MaU4ySAon+LU1Bhiz4woEeRoNW5adcy71I6irTZiAfuL9P5fEWmH+zQJPtSUzV2hg2H/Ap8gE3O/KHwLNOdkGicw7yO+WINVLa5R9zNo83ezpMoltGnlz9KUz7vs/ksF3nlwR25Tt97OJyzk2Rj/JZvnW8nDrYhelWpn5XrjfnPZ5B3CzY0FoStq5WRXzkS++A7Pup2fr9Po8mdCOO4MtuTvpruO8vxl4DtPO9psA0c611zc1ck8P4S1zbGHMTD6cZJVL5QZvVcCPWmEsf8v5EA8AVEUODcQW8uYS9Vx6wRjP5aQk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 05:06:16PM -0400, Michael S. Tsirkin wrote:
> Same change as the previous patch but for alloc_swap_folio:
> pass vmf->address directly instead of ALIGN_DOWN(vmf->address, ...).
> 

Rather than reference other patches, just explain the contents of this
patch.  otherwise...

> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6
> Assisted-by: cursor-agent:GPT-5.4-xhigh

Reviewed-by: Gregory Price <gourry@gourry.net>

> ---
>  mm/memory.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 0824441a6ba1..74523bc00d8a 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4734,8 +4734,7 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
>  	/* Try allocating the highest of the remaining orders. */
>  	gfp = vma_thp_gfp_mask(vma);
>  	while (orders) {
> -		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
> -		folio = vma_alloc_folio(gfp, order, vma, addr);
> +		folio = vma_alloc_folio(gfp, order, vma, vmf->address);
>  		if (folio) {
>  			if (!mem_cgroup_swapin_charge_folio(folio, vma->vm_mm,
>  							    gfp, entry))
> -- 
> MST
> 

