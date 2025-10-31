Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23FA3CCF9EB
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 07:25:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 608378E00C9; Fri, 31 Oct 2025 03:25:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B8CD8E00A9; Fri, 31 Oct 2025 03:25:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A7E38E00C9; Fri, 31 Oct 2025 03:25:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 336F18E00A9
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 03:25:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0083649A1F
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 07:25:05 +0000 (UTC)
X-FDA: 84057572970.17.6C143D3
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf03.hostedemail.com (Postfix) with ESMTP id DDE8F20003
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 07:25:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZagFReHr;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761895504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lohvLpll6vsyFk4ShQMHpnqTTssQwRpAOT4Fwwfc1jE=;
	b=5oNQ6Ib/s8qDkZK5g5/jDm+yx+e2igdi2j6pQw38caDhKFXXT7tcs4Xp7Yuzj8GMRgYsDR
	TEOoff9YuNAj8jVkoCzxMTyQTxH4zKWmFQm9zPaCX3juVG2PXuAwRX246BSGkDCtt4MLPk
	BmP+Dq+MREpKu4/k/yNMYfq/ZFwZiXU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761895504; a=rsa-sha256;
	cv=none;
	b=QlZDCwG8Ml4x8C6HfUUMn7nfr4GJqhl0dUcSOM2EwsC8vlqVG3eaoHp1HQGuyqn3KKP9tH
	RrGk96EXjjMCqqmBwOPB8qHWoJy+wiPviFBr6oaaLAxJJdpoxaYVAP9Up94mSJj2pD2i0e
	V96Fdwp/I5LzfRr8+MIiZIt/NB88FOc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZagFReHr;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-426fc536b5dso1193380f8f.3
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 00:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761895502; x=1762500302; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lohvLpll6vsyFk4ShQMHpnqTTssQwRpAOT4Fwwfc1jE=;
        b=ZagFReHrigDp1xjuZWiJ41a3Dn9XwwB7Pq+D8M6OMFi62WYIDJW6YjgJJAQOH86ZiB
         4njHljCr2ClhxGARk3deE0SjqS4F8kKGVC5K+wa2fLRF/ijS1bgKO3k1cihz7E6Ac4K3
         ZNoRHTJ1MjG7ac3wJhr/qiU1z69JYfaVycRR6OvTz2aqC85wC33BWqBUhYswR8NsUpgp
         czdIgzCDxn18X2aMEav6rExm2+Ijie29eRV7/7OumW01Hzw8WrxvaDxf/DnIskuifCK2
         mu1hTzwTzuH0cucPn3Iabn3n8+Ijk/sT6huSaJTpA1O5hR+PCJAj36SRoEguknixwIXa
         k4zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761895502; x=1762500302;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lohvLpll6vsyFk4ShQMHpnqTTssQwRpAOT4Fwwfc1jE=;
        b=WDAKO39DMN2yCBJvBCGmCJMJP3cf6h5N72s8vgizFqeFSftV6v9hx8WPw4smYw4Gef
         eVa11HSK0eAO/dbKFVKapvBqjAmG4DIm8kYbrXo9ZAoa7YnIst/H7/mEyzLA2OThI0Rl
         /5ysgnggTmoZukVzLSBs2u7AxLwGr6p7XmEB535xCCT7Pam7yL6hdKQ20Zg61+xA2sG1
         qDsgNzEHKYC60hnU5NWqJ6XUzpeq96S+y+rp+3Y7EoAdc5wu8eZgI3OIG3mh21gX1ouP
         p4GrqhQDQCv7rIvsfd6iO1RVe7X4FKlSsfcWFjfpp3LP2ZOSDKdr+haGSe9lomrLZBx3
         UUuQ==
X-Gm-Message-State: AOJu0YzYsCv3X0Sm/+WMrNr7U914J0rHoNoQrggwPkSS2xrv6j1RRC6k
	38FuzoiE8FtYRnCK6GE8dPc2LSxGR+r9bY8cEWxmgF6yKOq2A981doGFWlmBjPcjt0A=
X-Gm-Gg: ASbGncsrAPXDoWWR8mtacaF7ElzmxQVd1vkmeQaX8JSg0+vUwH6P2quq1ApSDbihzk/
	yZIxLCC6Bh+D+r2oegd/s0FRzZOh9D/zkhWmjWFTPXd0uVdKMWp4L/2mVU55RUpdbPa1IDKl31o
	PAWVWIL2iHobEP2SydS6AN9/pW1xSTA51IGnA8fRpzcLIQ7rFKyK8I0Vl73rRUk11+CahFSllzg
	SNEeuWk9ORjQBXMG26zBf04+UPZY8r6xe8A7l/XZAlv3KNLNAaqXtJJMSGW+6clyCUpE6slvVcH
	ORfCiYAbw63ySGQCloLC0KIH99ITb9gEyP1aK+h59SHED0YxXObYcrng4H4od9VmiXGpi9wNFHu
	YpFc5TGzHlx1uM8yDxx9N0fbNS4DHLK6oZISVsQWTJLp/oOkC9sm2E6XGiKAUNWNTdYScTgeccS
	45u+ceEzypO+jHAg==
X-Google-Smtp-Source: AGHT+IGU8tyymBcC1b7YyJEsl3ZG80z0iONG8om34CQfRnTMWYHsyHHMU9XDPRjHaix45FNiDQ3+YA==
X-Received: by 2002:a05:6000:2082:b0:429:ba25:5b1b with SMTP id ffacd0b85a97d-429bd6be67bmr1735525f8f.63.1761895502216;
        Fri, 31 Oct 2025 00:25:02 -0700 (PDT)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429c13f3278sm1881851f8f.42.2025.10.31.00.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 00:25:01 -0700 (PDT)
Date: Fri, 31 Oct 2025 08:25:00 +0100
From: Michal Hocko <mhocko@suse.com>
To: libaokun@huaweicloud.com
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, vbabka@suse.cz,
	surenb@google.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, willy@infradead.org, jack@suse.cz,
	yi.zhang@huawei.com, yangerkun@huawei.com, libaokun1@huawei.com
Subject: Re: [PATCH RFC] mm: allow __GFP_NOFAIL allocation up to
 BLK_MAX_BLOCK_SIZE to support LBS
Message-ID: <aQRkTKTm08lSJZZi@tiehlicka>
References: <20251031061350.2052509-1-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031061350.2052509-1-libaokun@huaweicloud.com>
X-Rspamd-Server: rspam05
X-Stat-Signature: aoxic9w5puk9y9kbif9shx9yt81utfkz
X-Rspam-User: 
X-Rspamd-Queue-Id: DDE8F20003
X-HE-Tag: 1761895503-393329
X-HE-Meta: U2FsdGVkX1/aS8DCl5MqFlWLLW3NbWS0EBFJJLLlfaXP2wWSFcvjz4RBcS48GayR2VSc2QJ/VginXyW0WVYX3zWoK5twTSBYfAv4AgaQ8KY1iMsHDWPC3m6uGno8r/Od6nOn+QMJfu3mw8HC3L+i+EEi7oixOrqW8uSFzLD9Q35ast8rVsNB7OgFRDYLrdihI26fMfJLMH0YHsxoHV+36VlePcAm4nksGxcniP38WyYSHQ+6wcYjQj6V0DPL72tgpXynnPEOPsjUPwYL3oSCPfvtDUj8XBGTqJWqkIIIkjwrSUOT60EX9nV54tV2EIIF2MAf49WtCauRKfLMQl2fS82fInzCpI7Kl+gzOGEfM+gWDAKGzekWRktnC5x592+fO+0iQyfzof9bwNtPDwWmJc6/8O4+Y1fzvKGzklPhtcCx+lunCUvgTPpvPl3l8pcv7BUrHUL9/w1K3g8ut9H7X/C3ieYkaHJ+bVH5hw2ukueDbPvpIk4dKd2gG4X96AR+gywShBjUvv4TQG6HlPuzT7ZED8q0MOnbmJJjpWunEnO32JTVHqbIoRAnqXRKc+siD4ADKL8UlO7cUH0mDFELdFa1W+4T8lz2TnxaiZtF7BUKYiPxiMUJz85a9cIwr/SG0df0qpJmGmxJR+oN4oABvmYQeON36wJScpMLMNo5tm+Dr05amj7loTF2rWt8J/AKS86uY4jWFNMkKdKR42NlKfbKFOfKRjY+He5zINuW4XMoDwWeI/eqQVTyzoMkoIBrP1QaaOhQAM8Gxwh0sl7ilH1fsmz20eqs6hrR3+BF+uzC3KvSs5geA1ZLHseGk9ddi8EV4yYwhf24ZoYX3apJJTUy3kgXmLDitYlB2gBXZpoTFQGMmiQrsbiwvdM9h1F0zLtQ18wiZwzjZNy8EdwOOkFSo4fKkisW854cNWWFxS8+g5eFIsCSockLUdTUF+GameBLdlLOf5RQdTWbZhJ
 Tmx4wG9Z
 b2/oi7YbE60CSZNCNIAtbRj4UCgu45kmjYyFioJ3yDEppkvcUDgFb9eozcx/1ORDzs2QeTg7vGBfhLi4IuJkP46bXVLQPAhkA3OMEJDN2iUgXpijlWr8KHncIhLTmHcp+zPaEn6+zljMNWfRo511OUC8ryM2vC6zEf/xtJu7Vv2JpyQZgFezzd5+rW2iGvDftMyd7yEQeimLCmQYNPNyEhMzukeCrTP5/xzb2zmQ13lSzpAcEkjyR4kAWWLT+V6DDE6BYq5yDuZ1+8aZwL6GDdj+sgsXpPnWVPOjiTHFSxYStHe77h/1MvkCZJGVCm0e4bU16Moz4XaRp8gjVYNRx/sVgvwh89EjqGMYTyje6qtI+g+XQuAXof0fzC6afrkaSUQM+snnZGmIrU92y/ocLVmtkFBsvYlmGOERbuKEa/sKRV2D8PZo5kr2M1yfaAmOA7H3wm1lbDoL3viO7pjSdAmEcIk3b8B8EZ3gQ/rtQb6Tp69FIBO778erCYM4jTFA4r+dhORA7VVaL9ec6lTJkkUHmJQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 31-10-25 14:13:50, libaokun@huaweicloud.com wrote:
> From: Baokun Li <libaokun1@huawei.com>
> 
> Filesystems use __GFP_NOFAIL to allocate block-sized folios for metadata
> reads at critical points, since they cannot afford to go read-only,
> shut down, or enter an inconsistent state due to memory pressure.
> 
> Currently, attempting to allocate page units greater than order-1 with
> the __GFP_NOFAIL flag triggers a WARN_ON() in __alloc_pages_slowpath().
> However, filesystems supporting large block sizes (blocksize > PAGE_SIZE)
> can easily require allocations larger than order-1.
> 
> As Matthew noted, if we have a filesystem with 64KiB sectors, there will
> be many clean folios in the page cache that are 64KiB or larger.
> 
> Therefore, to avoid the warning when LBS is enabled, we relax this
> restriction to allow allocations up to BLK_MAX_BLOCK_SIZE. The current
> maximum supported logical block size is 64KiB, meaning the maximum order
> handled here is 4.

Would be using kvmalloc an option instead of this?

This change doesn't really make much sense to me TBH. While the order=1
is rather arbitrary it is an internal allocator constrain - i.e. order which
the allocator can sustain for NOFAIL requests is directly related to
memory reclaim and internal allocator operation rather than something as
external as block size. If the allocator needs to support 64kB NOFAIL
requests because there is a strong demand for that then fine and we can
see whether this is feasible.

Please keep in mind that 64kb > PAGE_ALLOC_COSTLY_ORDER and that is
where page allocator behavior changes considerably (e.g. oom killer is
not invoked so the allocation could stall for ever). So it is not as
simple as say this just going to work fine.

> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Link: https://lore.kernel.org/all/aQPX1-XWQjKaMTZB@casper.infradead.org
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> ---
>  mm/page_alloc.c | 25 ++++++++++++++++++++-----
>  1 file changed, 20 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index fb91c566327c..913b9baa24b4 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4663,6 +4663,25 @@ check_retry_cpuset(int cpuset_mems_cookie, struct alloc_context *ac)
>  	return false;
>  }
>  
> +/*
> + * We most definitely don't want callers attempting to
> + * allocate greater than order-1 page units with __GFP_NOFAIL.
> + *
> + * However, folio allocations up to BLK_MAX_BLOCK_SIZE with
> + * __GFP_NOFAIL should always be supported.
> + */
> +static inline void check_nofail_max_order(unsigned int order)
> +{
> +	unsigned int max_order = 1;
> +
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	if (PAGE_SIZE << 1 < SZ_64K)
> +		max_order = get_order(SZ_64K);
> +#endif
> +
> +	WARN_ON_ONCE(order > max_order);
> +}
> +
>  static inline struct page *
>  __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  						struct alloc_context *ac)
> @@ -4683,11 +4702,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	int reserve_flags;
>  
>  	if (unlikely(nofail)) {
> -		/*
> -		 * We most definitely don't want callers attempting to
> -		 * allocate greater than order-1 page units with __GFP_NOFAIL.
> -		 */
> -		WARN_ON_ONCE(order > 1);
> +		check_nofail_max_order(order);
>  		/*
>  		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
>  		 * otherwise, we may result in lockup.
> -- 
> 2.46.1

-- 
Michal Hocko
SUSE Labs

