Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8992CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 09:33:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8EF18E00B0; Tue, 14 Oct 2025 05:33:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3F928E0097; Tue, 14 Oct 2025 05:33:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2E678E00B0; Tue, 14 Oct 2025 05:33:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AF4C08E0097
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 05:33:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 57E6C11ACDE
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:33:24 +0000 (UTC)
X-FDA: 83996206728.18.9E10FF3
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id 67C2BA0007
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:33:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=UYByb+Z6;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760434402; a=rsa-sha256;
	cv=none;
	b=hcF+lgqPZ8+c3ZNGlSMyTANtYkm1eKLp+oGVgSoyryGzs3oscgVbg1m6sQ5L4oj889+gG7
	B8G6N6ZQKCWI+X/Sj7jPnRj2qsZ0a83LgEC6bBuUJqat66xwABnkmR21csaS991RMnOJMg
	y+uplnBp1eOIaf47DD5jpvItLkSvtZU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=UYByb+Z6;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760434402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iOAPJCH11hDS3jLByXOGPi6Sv8SZOPugR5veuhkVP30=;
	b=GLqw6q8lBuGPGSnV90mou3E++Uy9ogfiDenQksUOktFjhInaRESw8e2HaZOEcUWIgljTyS
	Id1YoFT1gEyy5m/P/V9ASLjo1ejkYC+4ht7Xp5o4MAYI0XfFYy82fNFmc0S4Phtm5cU3RY
	Tp4BX9fD00mewlfaRSZcuaBtrrWLKjQ=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-46e3a50bc0fso38024705e9.3
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 02:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760434401; x=1761039201; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iOAPJCH11hDS3jLByXOGPi6Sv8SZOPugR5veuhkVP30=;
        b=UYByb+Z662W5xQOOnVq7XYRuq4w9cRdVeFEEGkIMY7XBji8g715Xc+GFBpvOPoEwqf
         eMUUStUzDk3Gk3Kh6J7XJxcEg8wL0sBAZ8lwNTYjaIpk3UIQRu7PUapLOy7mRSpXJy33
         mWAIK/mZ4f9vI/iSf/O6n3q6YtG8ZkBRIMOzp2C+XTWrw45S3hRCY9Bm0bO+qHyvWC78
         UC1u1eAllAv3jXnT0iptQ3dc4fxzpRG4dzMdW2co5xjcggBytUuiRPlO1UH3imEM2rgx
         ymDxDnf28eobz54OUT19cOxNZULB+5G49lClV11gC1e4MJpPnofWkgPxTD8BWjZKEgdI
         ZqNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760434401; x=1761039201;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iOAPJCH11hDS3jLByXOGPi6Sv8SZOPugR5veuhkVP30=;
        b=hMTWMuSroB+QCNLvM72HwoxzFFyqQePGl2zMPR4GVGWX2nFtHDOvSiBBPHVcEAoeIk
         qhq90wz9e7SgBB79rOkgMNlXCfLQ3f0boEpG/qZuyDSPOEiEApYos+pxSAR8z2iMOM8u
         wKaak7hX3kRsdAp9DiPdIJ1HuGcmdsjKcY1Ok7gnaVpkUkqiClR715nF88RCSzKqOfOT
         NKztKEVLkvQZNxPbAZvbdVYKCdME73u9iIgfxIjSo71aVtfF6SqbvpRsMu3o0cczcHjP
         bSktEvjouPxzk48yatUoe2dQBj2b1mxcIMLMhpWa9ZD7xd6wm4o9smRyEEDcddHAK2fZ
         0XPg==
X-Gm-Message-State: AOJu0YzoJwxL4/jaqwdXSwKZcjdoC4iG8OCYq26s3rtoyv3cEkDc5Wq+
	akwJH1v9cJKFdv09zQVyfNap0Xh46UjgjfUfkeMevqBGKdY5W18NWyIwGkEya3sWydk=
X-Gm-Gg: ASbGncsmvYNLTTT3/JIib0xFDg+Wu71hMMfNApSgbUjx25DqNEcl43Ei/3GGgSKDdf1
	uCRKf0ns00oPI0hclmHyBfFWsSqJHwftw7vUf8OxpGULk09cVrYzrqX6ZPTRwoblXzGi2MriPLn
	GEA2yYZqts2U5Kw+Nmb1PG9I1MI9fHHr8H45QOiWLUXVYrR9c0vHcLu2ISEYhwshqBkU7SabvB1
	GcLp6oaQAupTtz5P6Juc6FcTSj1cBnQB8z/9FEKYMoZr97kNI2iqAih8z2fQA28J166ZPEaEa+1
	6U1lTe+r7YA1rCbsT0RAUA5WrL9haYy8RyX4yp60VhJT8FOlZrP/N5xBTGwsobY4PrqQqf5kMPY
	ISnsqmqklUJWWCarhE1xm3xQtJTSniy7qDcisIryM+SFh1y8BwituWJ2crJDgCts=
X-Google-Smtp-Source: AGHT+IGcTFlotl++DNaOADqQPzPL48+M3MLBrIdj40znL9ulmxpmP8mkq3jzjYz/lQESgVWhNIZdqw==
X-Received: by 2002:a05:600c:5247:b0:46f:b340:75e7 with SMTP id 5b1f17b1804b1-46fb34075efmr133092415e9.8.1760434400686;
        Tue, 14 Oct 2025 02:33:20 -0700 (PDT)
Received: from localhost (109-81-16-57.rct.o2.cz. [109.81.16.57])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-46fb48a60b8sm233103935e9.19.2025.10.14.02.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 02:33:20 -0700 (PDT)
Date: Tue, 14 Oct 2025 11:33:19 +0200
From: Michal Hocko <mhocko@suse.com>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/vmscan: Add retry logic for cgroups with
 memory.low in kswapd
Message-ID: <aO4Y35l12Cav-xr4@tiehlicka>
References: <20251014081850.65379-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014081850.65379-1-jiayuan.chen@linux.dev>
X-Stat-Signature: kxmyixot6jazdz1zswosrgiz6h9tykux
X-Rspamd-Queue-Id: 67C2BA0007
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760434402-788087
X-HE-Meta: U2FsdGVkX19CMXxTQbNlmilMGSEsPahB2ZvSmW0mocU8zo7qUpgCa2vBCIAiiUwX6tdLOMHRZn6z8S15ifrLLEC+A+b57RofeCbxynj1+foxtu8i03qt9n4z2CFKE+IvxlyXcsZlVYL22iJU4tQwTHbE8eMl3fRnFZrVrqQN+8DNBnhlj6G21Va2lwVORZzaQpEbC6dc9C4eN6I83YrgXKX+pq4gN36RU1eY5oEF0Yt8Ftgx1lZXWUGIWnJPKtXxXYWj9Vu+Hp5jATKGHdFiWWG2XEXbP45o5nxcKcQC7DpeY/Q8XfOpJ7LxEyebvkvPzoD8PQOU2mhsdM2D/piDhvGzbqmfov06fzQoQwdQ/n+FJT+ZmVl/xCPvR00BtY5MTIXfZ0xNjZw17y2uXf8SCEfv/hwAXQv8a1ZR+vO3RCk2Ut6end5P1FH6EnAQVVIexvULTBm/4GtQggNXJ34N4ca68jKn2F1K1NXgRlQGtG9oR0QDb2cC6FLJEnkRb3UIucM2DZryBl43w+p7ke5Y0r2usyPyMaXqJ8PPjoDcv4FyuV9CG/LxcC36SxSYMRFc+/TKe3yUSaxviEH66Bu3yzy2DoJVp2bXKsZxuKXUY8dm4JJCzgg8PtfO5ZFTReQHKG/wewjUP/P3Dhnbxq02c2G3vqQWdTsGqwd/A4QPImeIVZqb7bzJm7N7J2g3ICKUvu0Afa0B+v/fBI4V347Cn4e/0knEojoLBUwI558isWeelv1OswY+ZPEZd0Fs9ZG61Cr8DHmJLYodL7RK3udkvIH8D3XKN+kWvuwoSRVQkpy6F0GaYrFsvaQ1AZTZgnet2fbmA4GuFiyglw81XIQ46IfXOh3oUZYkcgKX0KbcDTsEj2YEaXryQ3qWOGpUxMFo8id7bZMvLuFqz9iFY1ekPHW42d7usjMdBN41QE3sSNGqLtchgXfkEBwP2gyPDjLPkZX1Qg7uCAIG6FPfiBh
 6ujC6T/6
 oh5pL+xmPdb+nwFmCompAR7hjoB5el/Jb09bBkJyRx7h31ux1lawvdJeAqB33qi1h6ZnF8DHLYvRO6cU/7DeTGiAurqMTImEQjMlqta20+fcA+wKXiHElKEy5pqBz3kDdMTLftUXilL4Q55InGakcLJ9OCoYnTo/bpJ1PAHPtRF4sF6FLXVOeITjY1NZmwdsD7GEvNTtshd+/pWArfyJOGxFFqWIEOyM8NvivnaxPNLAwWgBcodWtRJYEJYKal3DX316uA+ps0B4EnwAAr3lnjgs2R5/NxtdVvMr088EUqGilG77dd4ad+HaVVwvV82JVWVXT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 14-10-25 16:18:49, Jiayuan Chen wrote:
> We can set memory.low for cgroups as a soft protection limit. When the
> kernel cannot reclaim any pages from other cgroups, it retries reclaim
> while ignoring the memory.low protection of the skipped cgroups.
> 
> Currently, this retry logic only works in direct reclaim path, but is
> missing in the kswapd asynchronous reclaim. Typically, a cgroup may
> contain some cold pages that could be reclaimed even when memory.low is
> set.
> 
> This change adds retry logic to kswapd: if the first reclaim attempt fails
> to reclaim any pages and some cgroups were skipped due to memory.low
> protection, kswapd will perform a second reclaim pass ignoring memory.low
> restrictions.
> 
> This ensures more consistent reclaim behavior between direct reclaim and
> kswapd. By allowing kswapd to reclaim more proactively from protected
> cgroups under global memory pressure, this optimization can help reduce
> the occurrence of direct reclaim, which is more disruptive to application
> performance.

Could you describe the problem you are trying to address in more details
please? Because your patch is significantly changing the behavior of the
low limit. I would even go as far as say it breaks its expecations
because low limit should provide a certain level of protection and
your patch would allow kswapd to reclaim from those cgroups much sooner
now. If this is really needed then we need much more detailed
justification and also evaluation how that influences existing users.

> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
> ---
>  mm/vmscan.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c80fcae7f2a1..231c66fcdfd8 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -7147,6 +7147,13 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
>  		goto restart;
>  	}
>  
> +	/* Restart if we skipped the memory low event */
> +	if (sc.memcg_low_skipped && !sc.memcg_low_reclaim &&
> +	    sc.priority < 1) {
> +		sc.memcg_low_reclaim = 1;
> +		goto restart;
> +	}
> +
>  	if (!sc.nr_reclaimed)
>  		atomic_inc(&pgdat->kswapd_failures);
>  
> -- 
> 2.43.0

-- 
Michal Hocko
SUSE Labs

