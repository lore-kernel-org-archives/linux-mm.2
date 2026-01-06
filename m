Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C3B4CE9D43
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 14:56:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D65E66B008A; Tue,  6 Jan 2026 09:56:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D13D16B0095; Tue,  6 Jan 2026 09:56:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C161A6B0096; Tue,  6 Jan 2026 09:56:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B34056B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 09:56:02 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 566FD1A0152
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:56:02 +0000 (UTC)
X-FDA: 84301838964.24.E38FF4C
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf16.hostedemail.com (Postfix) with ESMTP id 338C4180012
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:55:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Sv1vxPBd;
	spf=pass (imf16.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767711360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=48vtN06ZLYir8q2EkdgDzMinaXOPY0b17Zy668Z2E7M=;
	b=461wOXkXroAoIOtk+CCI/BV+N0RgAOxtZNJjGZXNNpSnTEc0DPPXpBNX7RU6OGr2+U3aEM
	kAao9fA46hy/h4UXVsXOv0jPyZmgP962M4SduLCa4HgvgOhHg+Kq/4fXYpCh4FfyJkASWx
	MQef6/zV9u4uUh8thOwndgbcWJkvnNg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Sv1vxPBd;
	spf=pass (imf16.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767711360; a=rsa-sha256;
	cv=none;
	b=Dvzj8y1+KHo952K75jlaXgPKT8bdv4SxQKmO5QOJ5yVr+PGai117+55Y5r2VvnyYzhkh/n
	umB/JKYxD7yqqJYggqw8XMbAxbDq8rEazO7Z1LFYj6VMYYFtomnuTjjRMO+Ek0fL2ihXdH
	20sTqH2ZpIU79Ua4Qkd3Z4FE3CnLbRU=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-431048c4068so649655f8f.1
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 06:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767711359; x=1768316159; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=48vtN06ZLYir8q2EkdgDzMinaXOPY0b17Zy668Z2E7M=;
        b=Sv1vxPBd/l/HR3FtBqOf3XzZOhbKdLVVYxu6VoyMQKq0toF6xIEKdp2Pbe1MmKIwcT
         XtF6fBYyByYwekLSVMZc73njFcBWg0wd0KGC9jnTOWszyW4kXatsjjYHYs/KAt0ZEUlR
         U+FpxkfGTDTM9HYl3lnSg1kqf5I9evNwngz+LxnQA+qogF0qwp6UNH+oRON9qSAR1uvd
         /+6YOwjG6WnO7v5IC+MSzngZ6q3M/cLyw3z62fsmMcjp5kM9XluqyTYzrSjEJ7HadkPM
         636cNyFD/cFRBiM3bM6yzcZDs2aPF+bUdYYyymE5NdCV7on3M4hsVXIAXlHHwmshPiyE
         wBbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767711359; x=1768316159;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=48vtN06ZLYir8q2EkdgDzMinaXOPY0b17Zy668Z2E7M=;
        b=JPGeIUBdUWrUl/Adc0FLJYA/MGPKwedu8WM7d5pG0KLcbplyMwxGQggoQzKQ8FIwjb
         o5YAljzat49UkZKfUooiEd5PZ9QQ+jHAm4apfaFrcJvMreU2BTHYjF8ZNacddFOKMuF4
         rhK+ZgdqPJeNEiI7gOkwdq7grt8YmBGZ7AaGcsMB6SIxOPP5p36cWXVCshXVlGhOjoCA
         LDz64nOt+Bv2S5s9EP+4yTmTR/06F1ti9oaydWQMLojTtBHNjvwoJQ65fG+ulgiEywVc
         upbW7OlUucr55zJYeTQm4nk6StbW0WUTWWj+CwmK+NFWNKZ6KZVKhSR9l48UkGH1zjJg
         CQxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXVr668a76KD5XpmTdi2PpDzGzEE3kkTJ7tmFUMxTMPx6DZqW52XEPtjIzni3UK1lpGhPH9ZYv2cQ==@kvack.org
X-Gm-Message-State: AOJu0YxkUdFBWU+YLnk7sSYCU28uAPrLfh0hp5mX3BQ7MKxzwrPiZdvb
	gwft79GAy99sdTA7fJ4R3DtuvMRt9goEWtDo/TzZ4+tVIRnuMQ8QW6SfkHJEWlEDQnA=
X-Gm-Gg: AY/fxX6+xTiP3SzPpWq5ZNDpiyhnmR79gh6A3pUCkglXt96pd7UBHGgmIKB4rE4i+Az
	wcS+wXcb9oVHr3Z9D5nJ2CLAqrkFLTvxin9PLLbds8XH2Aahkc0+NMfMIVxNnPEKacPP520l0A4
	H9/qAv1u2pebqErZUj5IDgb5oBsP0LP54QbTeGy0CYqtpmRrt0ekF9aBeJdR5YQ1BS302riHoOV
	z5RFMN8voGkOyAi4zcLJULyWzVB4h8u+MbDqMyxQOfS/MOJsiZ/Eb/djm1PtfSxM5Kp+oLHrOpg
	LZ4fV+xxwSOzod06/yJNziQ7D96Hvhtt8T8owaBH2sC+tl80lEPuiC+Aynm5Gg0exgtxamgrahU
	zZs6mD7FfDkono+Dyar2Ph7osI2JHFHfcAcTgpdPdLbX6U5wec73r/oojXl+kJb+pcQpQEqs0ux
	t6/iu3MAG05J436nmBxHzY2vu1
X-Google-Smtp-Source: AGHT+IHhhGmMFo4brBzmqdaikap8XFUd2NZ2e3OzIHLOdjpg5aOZMdc5gOTVtmUPqWIaAEFBQ6dtxw==
X-Received: by 2002:a05:6000:1886:b0:432:c03e:a77e with SMTP id ffacd0b85a97d-432c03ea994mr1875519f8f.16.1767711358634;
        Tue, 06 Jan 2026 06:55:58 -0800 (PST)
Received: from localhost (109-81-90-116.rct.o2.cz. [109.81.90.116])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5df8besm4578637f8f.26.2026.01.06.06.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 06:55:58 -0800 (PST)
Date: Tue, 6 Jan 2026 15:55:56 +0100
From: Michal Hocko <mhocko@suse.com>
To: Hua Su <suhua.tanke@gmail.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Hua Su <huasu@xiaomi.com>
Subject: Re: [PATCH] mm: fix execution order in alloc_contig_range_noprof
Message-ID: <aV0ifCtvKDPvwFug@tiehlicka>
References: <20260105133250.763076-1-suhua.tanke@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105133250.763076-1-suhua.tanke@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 338C4180012
X-Stat-Signature: jcabxz87df9mecfz4wz4684bap3474iq
X-HE-Tag: 1767711359-650684
X-HE-Meta: U2FsdGVkX19N4AdllIrucYhrROs98TpWVmKMmmP4nc9fDlisIifYVkoP0B4/Ckoya5I9IPir6Iw5d3TyJtL4AQ4O8zC84WCm65NTHwhwZmvUbCXp8apPw10aU6XEi7nUOUwjLXEI0DScv8h6gfHRaQwXN8cgHCpaXoknritX52P2P/hZkJoZu/tyLX9sCdR59I12b+a1S2p7UFhBnUdDJwEDsMLC+Y9SI/98zANzI9ubVOQsJbFCoXyDaXswDtBYcspj9WW+KJ5J51dMUvPNYczxh6fkNTYEU7qQvKQSGufXGBdFumxbep/INI/oxLCufyyXGe8nRhNXect5IEwoN1R+bl1ms0pg6Me8UX0q29B5ufW+LywdKOAU0+5eSW+bUVLPyhg+a5pyXYKLKKNxKzcoHsfehqxiBUyHY+ssEcebBUDcKTG6j4MZ1jSTauP+Ye9ZVtIuubtKOn3fQGdr/MZtNQBX67N9VPGXlXmXJO6DB/mXPN9UB0/sy3ZsiCsoNeyf4unf/++Lo1/i7l3ZNlZP+RTIfb4S7TOtURMB3GY3jy3zAz9mFiltRQmAxLVYkcep5zLiWaZdVjJILOKy+9Fd1hYAf0kCoY4YCgBIxs1Sid8ISNfreIA+1ETvtTZzEb6GOV1enPNcM3Jus0s27+TDkwhMo/AIcy9vJoWQvJcJhXeGTDqArh4DKOorMhcfJWrFvFL/hJXLBqT7wxegRK21q0w/hom3aRgjjDevK/zOTOPKp9B6RW94Knjr/vckNEskFHkNAOQkv/bveFpy9VGzcAj6PMYIM/LEG15VyNAkTML5NMfbd95PRWLu1Krhiwe7TnCPch7p5TAyPQt/YE/Yk6OiIXIhvuDuzvfKq/pO3uVpu2CoDQq+pHoJX0pAfglm1nYxYnDrwoSRDCDKEGsk5DWYpmen+lxO+y3i27B+A/LNtWCpxIdW6lWS9Bro5sudQkDzzT9bkrmFWHR
 qhtpPXwi
 aRye/U2NgAZQbQJNp2Xm8WzNFWZTyWwvSOYfXh+4Cj3SeXKbSXqR2OajT2d6mnb62rnG3jAbUzJAXkOkMXKFCepnCgYuI0PIUwkHZqPsoYy6Patp7GB/p80kIjcJI0NE45ZEljql4UQIT+tK37cWjkB0yI/j+m5VwN8Wl8qIXaFEqgQcdsoSPKkvm9T9aGDOL4V8jSCrI0c4kgg0gvpkinqLGVZful421Af5GIW9vj8kZSxW22PnsXlzuAnv1TrosFgSNEYp8uwJet3oWlNw0pDE3+xjyQQB17ieT+Q4skxTHxoGfI9omIP3/xShK/61b+7jJXXgYwCWsfHRcoJxsbjc3OQbLysoYw3Nzby+K+ogPQCqR/eRToGVfSViZ4kVEC9aWdoG2MfPRSHraTHRhrXHwcofz+ZydusX7CkpJ2UQ1KH6kCMrvpO5baN/i/DVpznaPTVHG0oNm5eLEsBnHF2mZBBPMaYaez9T8VQInsC1aN7quAYplBfUdn6hzNFi6RZnQ0ixj0hAUnUE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 05-01-26 21:32:50, Hua Su wrote:
> Fix the execution order issue in alloc_contig_range_noprof where
> drain_all_pages was called after start_isolate_page_range, which
> may be lead to race conditions.
> 
> Based on community patches commit ec6e8c7e0314 ("mm, page_alloc:
> disable pcplists during memory offline") and commit d479960e44f27
> ("mm: disable LRU pagevec during the migration temporarily"), we
> disable pcplists and LRU cache before page isolation to ensure no
> pages are left in per-cpu lists during isolation.

What exactly is the problem you are trying to fix here? Is this based on
code review or are you hitting any real problem. I find the changelog
rather hard to grasp.

> Signed-off-by: Hua Su <huasu@xiaomi.com>
> Signed-off-by: Hua Su <suhua.tanke@gmail.com>
> ---
>  mm/page_alloc.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 6a47443c48ff..d08f929ca64c 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6815,8 +6815,6 @@ static int __alloc_contig_migrate_range(struct compact_control *cc,
>  		.reason = MR_CONTIG_RANGE,
>  	};
>  
> -	lru_cache_disable();
> -
>  	while (pfn < end || !list_empty(&cc->migratepages)) {
>  		if (fatal_signal_pending(current)) {
>  			ret = -EINTR;
> @@ -6850,7 +6848,6 @@ static int __alloc_contig_migrate_range(struct compact_control *cc,
>  			break;
>  	}
>  
> -	lru_cache_enable();
>  	if (ret < 0) {
>  		if (!(cc->gfp_mask & __GFP_NOWARN) && ret == -EBUSY)
>  			alloc_contig_dump_pages(&cc->migratepages);
> @@ -6973,6 +6970,9 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>  	if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
>  		return -EINVAL;
>  
> +	zone_pcp_disable(cc.zone);
> +	lru_cache_disable();
> +
>  	/*
>  	 * What we do here is we mark all pageblocks in range as
>  	 * MIGRATE_ISOLATE.  Because pageblock and max order pages may
> @@ -6998,8 +6998,6 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>  	if (ret)
>  		goto done;
>  
> -	drain_all_pages(cc.zone);
> -
>  	/*
>  	 * In case of -EBUSY, we'd like to know which page causes problem.
>  	 * So, just fall through. test_pages_isolated() has a tracepoint
> @@ -7076,6 +7074,8 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>  		     start, end, outer_start, outer_end);
>  	}
>  done:
> +	lru_cache_enable();
> +	zone_pcp_enable(cc.zone);
>  	undo_isolate_page_range(start, end);
>  	return ret;
>  }
> -- 
> 2.34.1

-- 
Michal Hocko
SUSE Labs

