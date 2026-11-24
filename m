Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83980606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 08:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Np6jz+Pz
Received: by kanga.kvack.org (Postfix)
	id 5643F6B0629; Tue, 24 Nov 2026 03:09:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 514C06B062B; Tue, 24 Nov 2026 03:09:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42B6E6B062C; Tue, 24 Nov 2026 03:09:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EDA486B0629
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:09:15 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 52667120A7B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:09:15 +0000 (UTC)
X-FDA: 85469287470.20.EA7FEFB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 77BBD180005
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:09:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Np6jz+Pz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795507753;
	b=8LIEGhlYvuroqyVe11AptNHjb1Ee6XrClRFyh2r6IVdoxDyWy36bHLos268gBCPA46Q/FE
	rHVyMd+o3SI1xRi95+MectEbmZpsQVOoVl+Aps8pU4I15J6KMztY4OY5TQGGhoDsdCJZux
	cdE3wrn3FBNohLHohAx1VV/7x/jokCY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795507753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SNa0jI0FiSQSesqDcSvYF2AIe3+V2OGkbaEUbg4vgtw=;
	b=tRvGz6XJc3874XX78Onxdv0P4fXDkK/piFqZg+FLJ948yVEnquEVS5G5MVmeY7tdKeTW9Q
	YvvL/5Y7y6aDRM8aYeEvNo7ghKW4UJKQ3JLMcn6y8cSpjrUKtEFyg6QHp9k/lYxNICRFMy
	44/RAZTUTffovPudBoJui1MrKttwSIc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Np6jz+Pz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EF58960A05;
	Tue, 24 Nov 2026 08:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412FC1F000CA;
	Tue, 24 Nov 2026 08:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795507752;
	bh=SNa0jI0FiSQSesqDcSvYF2AIe3+V2OGkbaEUbg4vgtw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Np6jz+PzAWLACWRJQadcKkpHuWvjrXsDqYPVTdx8Okon3l+0HK1YwRx1yTUB/ht29
	 2hb4c7sLr7Wd79ciX0oIq88GezZe2NojqjsVL48OSECAezNKEsRzhHYhvGA0i5IjX4
	 uLdRne31MEAhS4XtgviY8yLfmg+EHN1Kb/kfHJ+wufa6yRXLRw2/LiJrdMDDmYxDZc
	 Zd86Yaou/FN8u5MAbEjMRh+GXFv/1cVdml3zRWE0NRRw4ZRErBPxVZyiFHgWhPeqqp
	 sA2XoQ7ZbjzYdANMt9IB7F6jHLUFysQpuvuCOD05rsqWjH+n86T2HnhdXUG2wt+6F7
	 jt/PGiOhLdHWw==
Message-ID: <702af94e-4447-4b09-b7f4-4e4cb32c95b7@kernel.org>
Date: Tue, 24 Nov 2026 09:08:59 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] drm/i915: consider vm_pgoff in vm_access()
To: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Chris Wilson <chris@chris-wilson.co.uk>,
 Matthew Auld <matthew.auld@intel.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>, Rik van Riel <riel@redhat.com>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
References: <20261122-access_shite-v2-0-808d8d2aa700@kernel.org>
 <20261122-access_shite-v2-2-808d8d2aa700@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261122-access_shite-v2-2-808d8d2aa700@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 77BBD180005
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: jhrsyphesw6r5yyxmahi5w36q5ubs6pp
X-HE-Tag: 1795507753-900597
X-HE-Meta: U2FsdGVkX18xTaE9fVyYiGWPpVr73Z5+Vb/BJLCeX5/OJkw5T3xXSSOJmG7EXAghncffeCtO5tQbnLxUPECv0ZsFOYl+V/4X6HP9tDG7PmxZa87EmIUCBnmzK0FYoAJOxotQ+1I53/sBTVmtDovFqjVWKdtFtenBWlKn+WGg2+fv035oJvGtGqO5HIFHZibFZvA9YNjsk8rcGL31pdd5ZtxlPqUgPLVCtrdY5cMv66GTinh2IrVjIPFXLdQectzfmlj+H+qVECfgVHGQPH+tjP6L6bxNkySn2ha6is8WvKTeKv/Q6sTKcsI83zvdRtAjRqFcm3ILKJ44NwJ/N9c25ZAxdmCiLW0TkhHH4JdH0LVn6vc8Ef/BKovrEj+c5tlOJXh0WMlDRH0qzdC6xKEhRczJonX4MlnmYmY24ZCuv4sYE/9zPNCMyPNEzfrffEjg++uT4Zn63fSbt5NIbbrXPqMDPnr/ATqgt0Nzr4S04SUyRs4gLa+/rp5tJKixHgQenpOGDtQ5VsfFSB5zdWZQecGUANcotr4cqItMNH2dTRUlJChXCNCG1BwzFtbpl2D+K95vwRyw9YMAtkGGSOjaIVfyNK8k9P5m87OyI7sLWU2ysvW3l/3te0N2zEH3PKbHavPnoE84HhpdpzAzjuaZzrQsKLHcYeYvRw7FjrYF2uzZOHXWf0u8wgV9foSSPxfFpGDiBUyuPioYdHZmyRffBFCGaWb9WC+EcC0a9379VSv1SsJJKf6UFrMr+VLAFXeipE/el0GEguWNFf1NpxC1t/YjLLxajurFC9wNP2Lv/7Wn4gkjTjKqPTQhRX+W+RPdl1nSzyPIhqgwo7eQKu7RialM2OdAEtcKPGyBfKYQfwcner902Ud8fRHm7/URiF8LqJ7WOdl7WpHvDps+XkZkYZ2RHxg+wMn2d9fkoXVCDo7KUoR6oKbawI9lYQfhVK0yYDxxEVmwgzIh/rKeJgg
 6Zu9Onoi
 DzQ4a2arB/CnH/7/txfzHqObxVEAPnQIN0LEoGXUazguqnQQEQz5EmsVN3OpffwkmghXtO/VtqO9EtlGpgyjcyrtPJXGO3mYXS41wrvJ/0fw4ZOduoKrPpHtMoJsu0GZD2CHe40WmUdfQNI/tsKCAh6bMNk1Yr2nwaBwJ5xK/YkgfHRAL9yQO35nsKrTG5RdaiCm49XtHna9lrP1JAfBAgR/8kMxTAqHMB4U6RU/G0v9tSRg+aoLRfjKl455KJVzNEy6bysPP5nkrNjV7qoB+rk9Oybc+YRAmBkyz1OqkQKUJEGHhyFl2NNITLcjPexzjwYLbFXwnh/t17lUvoMPLlFkHTEgiRxC5daeJENAdCtEWdgisZS5MMuGqEVdVf746PiN2bZ/nQ7hJiuNIvHCWqiaK7LU4YzUXKWTrnq736c3KnJx+/Y2Jz6+U8vvWQ9tV/mlrbpxJZaKBVEOxuTKw+2dOtvvgZWaPklEsn40wQLZM5HoUL6D7B4TDoLaCvX/D0D+alUd3Uu7dg0SGoFmAmTXCjagxaXHPqe+G6QsSLMjwJ3QbmFnKToDpINc8M5cD/7eeiD0EEwcukrK8nWt2kIbp07ZJWC81UJj8X9kscmp+YSsC/oJhIAhYBMwNGIWv7E2r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/22/26 18:55, David Hildenbrand (Arm) wrote:
> vm_access() treats the start of every VMA as the beginning of the GEM
> object. After a VMA split, vm_pgoff identifies a later part of the
> object. Debugger reads and writes through ptrace or /proc/<pid>/mem then
> access the wrong bytes.
> 
> Properly consider vm_pgoff just like the fault handlers already do.
> 
> Fixes: 9f909e215fea ("drm/i915: Implement vm_ops->access for gdb access into mmaps")
> Cc: stable@vger.kernel.org
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  drivers/gpu/drm/i915/gem/i915_gem_mman.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_mman.c b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
> index 6b337684dbfe8..e3b24dc8e94f5 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
> @@ -511,13 +511,15 @@ vm_access(struct vm_area_struct *area, unsigned long addr,
>  	struct i915_mmap_offset *mmo = area->vm_private_data;
>  	struct drm_i915_gem_object *obj = mmo->obj;
>  	struct i915_gem_ww_ctx ww;
> +	unsigned long obj_offset;
>  	void *vaddr;
>  	int err = 0;
>  
>  	if (i915_gem_object_is_readonly(obj) && write)
>  		return -EACCES;
>  
> -	addr -= area->vm_start;
> +	obj_offset = area->vm_pgoff - drm_vma_node_start(&mmo->vma_node);
> +	addr += (obj_offset << PAGE_SHIFT) - area->vm_start;
>  	if (range_overflows_t(u64, addr, len, obj->base.size))
>  		return -EINVAL;
>  
> 

If I can get an ACK on this change, I'll merge it through the mm-core tree.

Unless maintainers want to pick this here separately. Patch #4 might make it
easier to trigger, though.

-- 
Cheers,

David

