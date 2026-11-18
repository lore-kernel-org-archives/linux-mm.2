Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5780A606A332
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 18:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i1vriKZp
Received: by kanga.kvack.org (Postfix)
	id 7AC3F6B00EF; Wed, 18 Nov 2026 13:36:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 782776B05B0; Wed, 18 Nov 2026 13:36:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6986C6B05B1; Wed, 18 Nov 2026 13:36:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F45F6B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:36:11 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BE4A8120855
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:36:10 +0000 (UTC)
X-FDA: 85449094500.18.0080F75
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	by imf16.hostedemail.com (Postfix) with ESMTP id DDAAC180009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:36:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=i1vriKZp;
	spf=pass (imf16.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795026969;
	b=RY+00pdWLYKzXucXRGj4J5epl7fNWqpofYcDtTPLpCdZKRLFBmQg73gluerummNv/qipDD
	lRR7DAYe4DUwUdt/Mmq9qq4l0aRn7Er0nqYTJRIxY4OpxoYdYbKa9hfgEVirr/3wV1w2C3
	ueKqcqv70dUvS0flbIV3id9HT4QZryc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=i1vriKZp;
	spf=pass (imf16.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795026969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LWsePn//34GWKr66eI/3X8mjEEJpdHv2YAD5pLDzxFA=;
	b=r0bpMx5gWP3a+/LHjHhtd5uv2XWHIz9THVsArzw/li79MBWlbhqV8UOaKYoG5V2FKHV//X
	8WFSg0wkB4M3n6jgCHTw/NsZieU8bx7KIMj2FNmkixC8CDa/wF9WhBE0mXRI6W/4/Fubig
	IRAE1DyNa/64bZFxNFiMBOldo2WBiF8=
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-55650fe1f0dso657618b6e.2
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:36:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795026968; x=1795631768; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LWsePn//34GWKr66eI/3X8mjEEJpdHv2YAD5pLDzxFA=;
        b=i1vriKZp8Z92WRHatihPy5JjrP4bVMgdNOhU6e4VktDYZYN8hk6fXzCIQ/PKClWUpk
         rCSH4uo6Xe/BqKmgmUnrJ444uzRkC5oqGNxJz9mAbQ9jZVjYCwRqRvUlcz1gFWrzOdKd
         F0iYMUrz2PymCWl7R5V/1x2PPOP284IVardt5FBIHUvZ9XveFnxMJTnbHAYQ6/8+cVkh
         cVtzKvKiGVX7jaaAcJAzr57hC3B58In9nqf14NE+RKd7QUT/+OcYWac3hL+rD612+e/B
         JQRqnvSuLAbeH1Ov7ZrCFX9/s7YFeSdSLqb5IBeyidRi8y2ss97i/CPfnINv+VOQZiz6
         9ywA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795026968; x=1795631768;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=LWsePn//34GWKr66eI/3X8mjEEJpdHv2YAD5pLDzxFA=;
        b=e8pCNZUJ9XnwZvZ+h25MWv0vYFx6zvupiesm5kMlmYLgOn8395cTRbHUmdr7Cishpf
         9D7OAVGwt8fmHi6NtTRcMspEgPnXCrVLdq8hUPSDc/a/r++/lxO4ehh0a0k/HIPgiLSw
         PWY3wY4BajwdcuG9auriq18KHt5ciRMiIURMC1LZ36D51bqbyhVLBDqrlrxtEGBgn46c
         GhXhz/2QqiCY9jczPAB+1VfLaSzfRIL/Kw7ZkzrbheZJbeTyA0A8MwNSKHFvrkBIy4Z+
         tK4+i18iTaf+0z5N1njzMesYUt22X+MKnF3tlOjLLI/V8GPrM61XQoXGkicD3kJHbWKv
         m+CQ==
X-Forwarded-Encrypted: i=1; AL+hErHJDKaA8M0PK5UVNNf5/CdLfv957y9ZtR2xKPB7eKAkL8d3EPeD1DAe7mVy48evFdgMrLHDwcnkyw==@kvack.org
X-Gm-Message-State: APuU4Z96Jr4XeLFXGTlnNr5xVAgFfTGJTIay7Q9+U5wr/GkGX+8aRXqg
	3l4VtX0GYQJm2L3GfFCF4bsIkbNFgkUAxHQ/nE7/QdSoA31YHQ38yAd1
X-Gm-Gg: AYBFou15DMHsXC3kZgRJShrmnypwRLNNHgVJ6ESv03qt6EeB7BRVJuUcMe5KC8Lf4fS
	Adz/NDFivAa6rHvNw3Df8FlCX2rhO8MXGukxRoTgOprRw40JQoGOvJ2A//WISqgPJYBqtQAO2iJ
	/d3zFJuiAaTPHf3AzeCsSF+cfmOLAcKJAi4TNxZOd/wfmLLTN96PZhebaTNbfG0+6CsWzMJZfo1
	ECbyiyv0MQaIKMG7vP4x6jO2QeG54ispdTlKbcYF6Mr00e1wAgA8QcS9aNRZ2xkvaUAG1+HqBud
	wA8CsTbV1OayKZcAqQCZSaIqiGinhDJO6HXca5MJJ6GYWuhym96mbYhXEta/UmK8TFNEpHPrVWK
	MeKhGhri4A72RH0TiUaylP4+rx4iKD9qmDYscS2VwMCeJCmbhYGnFakMkAzoQ9NCP2I3tCjEWtI
	HDj/j6EJJPwgbdOibRLX6uQ6vdRekpfS1MDra1zsQX67Kd8KzS57iMVKqoFoeAbdhOFs8vcyWtw
	sfjkrK+t4GkUiqHWcDDtByg4XstgVZbpcnBID3Y/wRxQu3fpIe8E4CeP8oX+HvzLaFpxEgDDg4d
	LV+VGJ+VhvrvYiY1Qr4wTEOBKQg/F+RlrUg+DDFU/zsYfMO3telSRSPbd5GL
X-Received: by 2002:a05:6808:250b:b0:4e9:7d56:846f with SMTP id 5614622812f47-5773e750e7bmr4246129b6e.41.1795026967884;
        Wed, 18 Nov 2026 10:36:07 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:40::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4b74412113asm2969800fac.8.2026.11.18.10.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 10:36:07 -0800 (PST)
Date: Wed, 18 Nov 2026 10:36:06 -0800
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH v2 1/3] mm/page_alloc: drop unused gfp_mask from
 zone_watermark_fast()
Message-ID: <av3vX31XxmBT6uh6@devbig011.atn3.facebook.com>
Mail-Followup-To: Dev Jain <dev.jain@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, Kiryl Shutsemau <kas@kernel.org>
References: <20261116232346.788145-1-joshua.hahnjy@gmail.com>
 <20261116232346.788145-2-joshua.hahnjy@gmail.com>
 <b2093f38-e3e3-494e-a27b-afc91c578053@arm.com>
 <7770de02-3f4a-4db8-9e02-5e95b148b809@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7770de02-3f4a-4db8-9e02-5e95b148b809@arm.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DDAAC180009
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 9s1nwcj41d7y54wuu76koc84ng3h75pn
X-Rspam-User: 
X-HE-Tag: 1795026968-720892
X-HE-Meta: U2FsdGVkX18oMbeIGNxUVDI8BR6erwFDcRYT3j+Xn+ohhf0UAwI7LzGVREs9xKZ/2PRbRaRJBNX+TBMcK5VInAq0iMsQV6uMcfMcgpc+YqfyDCzG1gy4Da/kkq8aSci/Zy4OP4fD8otEhMsr49JPYMARnLkKyEDkNvnFx+Hwu0KPnbxwYlP1d0bcpHpQePTt3BGQSkKIMlXSYagKdiRJtBtLwqy6KOg7AhrLXl9uaHMvhg2Y/e8zX2siEZQ/vOZZ1RNGWpdGDkv+0AfxJmoW0RUrUUWR8xngD4jhHk2jZmnlxwWEoYfX/P4zGwh8k8kjwxHUsfp0eNwlU+ZG1op0iNub6nUhVk1ZY/oM0K2N+2LLzjLL667tZ8sBGnf577Cnvqx67nXj83OM4qFulZgr3c79uI4alMk/nXqZRBd0qdgU38gJZVXpIJjrDZ3xIC4bar7Bz8fjBE5ntUO5XHtiudqXHE09jCKMYedMFIduOtxqiHOGqhpSHJhjDarONP7HzWda9skcwv6P4Vp8J9oF64HLcoAmHvPSGg+sY7mwBIF3RxxR5AG9yCOFv92gaBj3T+eCJilw93GA10ujri0EfJ5SZrplL2TvFKQK3vSeCQ0QJ3eTcFz2jKxzrC5F6DQsAeZ3Bo4/hb1RrnMmGXUfFgnsnBM/XGZN+lXbNvWE4LI6gY+nVGqF3txqjgqz1yB8R6PUjIKWTMOavU3uFSXEspEI3D24mcPSSPR6CmmUsAf9XhWt7Aoik6a07j8JGJB6ox0JRRAWwHM/wqhLdSecjvwCnBnk6YV9kbCp/lNgejqi4UIKFmBpVwXmBjgUfexpSgCYnjeFuGSoae8uzfarEttmf3N8UJwyTB5umBhGUESppgUZIwBUTwg2bhdE+XGQ45A23BVx8MhCLj0iCHmy9276GmNMavM9Z8X3bmUNxreQ+O81/ChJ9WcgrCymBRKsPOaTkjEbTkkfFMjb+lz
 RXWZtsKZ
 mnUpNELSRkaJx+c6JT3MFxUgs8B9qgIFLjRfPlsT20wUzFk2vbFGCQYR8QwLcbE3ofGO8PWuuMSN3vuIluRURf4y/o/on5KbEmoxxy7IQqvN2M8PPU7weo96Y+H2IKIHIbvUWT4VqV9sMTuP9tElLbOSxm/PH4vQmdVaEnAyNzpBbLRlo4/oOKb/0VERtiLpaIZIEw1H7bYET1OmTlrDE7dJKEP4qPdUH5VCpwf2HMfL+6e5hozjjQCntvVGFKz11MOeKrDvEKU4dBPe++TxrZzwc4Zd845AEg/kShpi3g+aVPmxnX2A5y+BNA/HVX96HTuLuuyyiIt86QyNHN/R5v43psmbS3Uc0YLbmLKupZkMUFoRIzNrK/ltpWBZMS3OziKnR4FCkE3KuDHEzK1GibNy82ZEof4vNXNSPiXf/jE0kTlBjDXRVu2oWqEnpQS/69L+99Jpq2Wm+fM8eEPc7TtoUfQT9gq/U/K3sABaZnME8OTsBVGXfFZqNU8k9Km/zZufD3JWqzJi8N+6Bsi2f4FfC+kKng4MvEfTToiR1TCVJ2iBZJNOH4Fu9nUcVEQAl4X/bnCUFiDK0t+UINfwdVpVYpP6bcixPNd+VgT3CI3AkgG7eYzbdT/etmrxGre7VMoAUDNKwhznHTOI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 09:12:51PM +0530, Dev Jain wrote:
> + Kiryl if he has different opinions
> 
> On 18/11/26 8:29 pm, Dev Jain wrote:
> > 
> > 
> > On 17/11/26 4:53 am, Joshua Hahn wrote:
> >> zone_watermark_fast() has not used its gfp_mask argument since commit
> >> 2973d8229b78 ("mm: discard __GFP_ATOMIC") switched the watermark boost
> >> check from __GFP_ATOMIC to ALLOC_MIN_RESERVE.
> >>
> >> Remove the argument, no functional changes intended.
> >>
> >> Reviewed-by: SJ Park <sj@kernel.org>
> >> Reviewed-by: Chris Down <chris@chrisdown.name>
> >> Reviewed-by: Zi Yan <ziy@nvidia.com>
> >> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> >> ---
> > 
> > Note that this series:
> > https://lore.kernel.org/all/20261116125103.2894162-1-kas@kernel.org/
> > 
> > needs to use the gfp mask. So perhaps drop this patch? Otherwise we will
> > just make noise on the list by adding it back :)

Hi Dev,

Thank you for your review on the series. Also, this was a really good
catch, thanks a lot! I'll just drop this as it was just meant to be a
cleanup if there was no new user, but it seems like there will be a
real usecase.

Have a great day!
Joshua

> >>  mm/page_alloc.c | 12 +++++-------
> >>  1 file changed, 5 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >> index 9e1261521b6a3..4d829e5eac49d 100644
> >> --- a/mm/page_alloc.c
> >> +++ b/mm/page_alloc.c
> >> @@ -3675,7 +3675,7 @@ bool zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
> >>  
> >>  static inline bool zone_watermark_fast(struct zone *z, unsigned int order,
> >>  				unsigned long mark, int highest_zoneidx,
> >> -				unsigned int alloc_flags, gfp_t gfp_mask)
> >> +				unsigned int alloc_flags)
> >>  {
> >>  	long free_pages;
> >>  
> >> @@ -3877,7 +3877,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
> >>  		    !waitqueue_active(&zone->zone_pgdat->kswapd_wait)) {
> >>  			mark = wmark_pages(zone, kswapd_watermark);
> >>  			if (!zone_watermark_fast(zone, order, mark,
> >> -					ac->highest_zoneidx, 0, gfp_mask)) {
> >> +					ac->highest_zoneidx, 0)) {
> >>  				skipped_kswapd_nodes = true;
> >>  				continue;
> >>  			}
> >> @@ -3897,8 +3897,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
> >>  
> >>  		mark = high_wmark_pages(zone);
> >>  		if (zone_watermark_fast(zone, order, mark,
> >> -					ac->highest_zoneidx, alloc_flags,
> >> -					gfp_mask))
> >> +					ac->highest_zoneidx, alloc_flags))
> >>  			goto try_this_zone;
> >>  		else
> >>  			set_bit(ZONE_BELOW_HIGH, &zone->flags);
> >> @@ -3906,8 +3905,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
> >>  check_alloc_wmark:
> >>  		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
> >>  		if (!zone_watermark_fast(zone, order, mark,
> >> -				       ac->highest_zoneidx, alloc_flags,
> >> -				       gfp_mask)) {
> >> +				       ac->highest_zoneidx, alloc_flags)) {
> >>  			if (cond_accept_memory(zone, order, alloc_flags))
> >>  				goto try_this_zone;
> >>  
> >> @@ -5245,7 +5243,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
> >>  		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages - nr_populated;
> >>  		if (zone_watermark_fast(zone, 0,  mark,
> >>  				zonelist_zone_idx(ac.preferred_zoneref),
> >> -				alloc_flags, gfp)) {
> >> +				alloc_flags)) {
> >>  			break;
> >>  		}
> >>  
> > 
> 

