Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9BA7606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 21:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=pH9QIB8Z
Received: by kanga.kvack.org (Postfix)
	id 945946B07C3; Wed, 21 Oct 2026 17:24:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F0816B07C4; Wed, 21 Oct 2026 17:24:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DF3F6B07C5; Wed, 21 Oct 2026 17:24:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 55B4F6B07C3
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 17:24:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3747E160683
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:24:37 +0000 (UTC)
X-FDA: 85347912594.17.250D1B4
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id 48395160005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:24:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pH9QIB8Z;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792617875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8IEZ9olq160T2eeN056hVBHNHsrJXJMeuGcg8w/hmqY=;
	b=tYaVCWyi8rpWloffAZgsvHAs+NCCqWbDXXp+mgik2KPluQk5pM9760vFW0FtUI8n9tn0uL
	nSEOyEe0Iq0w1ASlnymol3oZ35LRaaKp4S3rTULQbhL2qjTCf/cgU0jiUyWvr7n3yS0qOl
	sfFv2arYxg8vANKCYj7rB4hrm9c/e3Y=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pH9QIB8Z;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792617875;
	b=e69qYRIdJqdo+wZKK7g8ycmOqDyf0GfRTHFuKYWsSM0qHHDqlqMemCqaRYrkbx9nhoOehK
	6aOjmUj46ZieefPPLgUN6fjWh6Pa57tsHlE4r4J7bBYx1F87WzWhOzSxKaMWOwqaZUMc16
	NbPda8xt+anc5Wdu8NmnmaCLo15v0RQ=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-93f079a63b8so121011185a.3
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 14:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792617874; x=1793222674; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8IEZ9olq160T2eeN056hVBHNHsrJXJMeuGcg8w/hmqY=;
        b=pH9QIB8ZnDQjO0T841BXaMLWx2yJnlcIpHJTTQ+tWk/V1A/gvxUV1QrWWr63JAmHLL
         t2Mf4iixwRvuQ24Vba9odWSD8nDtuQLLkATQ/D64YZerR1U03eT4ajYy6F8QrrAaUITQ
         ecwEHU0/5zBsgLmQwSN1mUqHTO3Xc3n0QZr1c9nNQkquhvzXZmKC6W7GLmVynec5fB7T
         6rW1zov4dRZIYdfTdsOaB3sioD+Ye0Rxw8S0SaMwdTcJ7y8FARFEjrQ0WC+ma3Kwf4Da
         EyFzyF4HjKk3GgRIUHmG07WVsJpHYoJOb54qLS/WoyauZv6z8kJ4l1WzyIOyH0LmT42f
         u4gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792617874; x=1793222674;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8IEZ9olq160T2eeN056hVBHNHsrJXJMeuGcg8w/hmqY=;
        b=M5nZ7AFq/gfOpHvmTdYj3eSr0McT2JOVOLeRUg0pZiD2Fs/ogPfv92ODn3dg206F3b
         TaeELHIRwKHt8d/Do5paFinzjgeD7S/j3E0xV/ornu39lynOXde08tuAKBOVbTKu1snP
         A6Su5IO5erw2OLYmW/mguFIWuToXDJdDmnaTHUlb/HBns6x8ywPLAy7DBAhJ8/8yL+Kx
         OPtoJ2yVH7poGNGlJ9/0y9sk9Zud3oYIinVHbcOOjBZ5q6j4Nz4884sCfIpM+V3vhcr9
         iVRh/dQ38U1JbTU/6XLU9ycV3RtS2Ci6QF63AkYIZkRFRFFQgsIxQLnAv9Ayys++AaLH
         V88w==
X-Forwarded-Encrypted: i=1; AKwUvBx2KcrHwTtqaRDPetT6Bq2K+54SB1ffhktpQjhNKzQp0sSI2c/44pu/E2ucifW6nmZtOvhrqjPSpA==@kvack.org
X-Gm-Message-State: AFq9FYJPxuTcA+Ggi6EeWegYzfJX2Yv1LFfXbJqX8DVheVC0KXGJ3hUy
	Swtmw72t/xF3KUSqrf5j/EdMJ9of1xQKsrKg0/BCcGdDXuUS0rGv1icanJ226zRgfxCBYyfIGmi
	OWeIk
X-Gm-Gg: AYBFou2ZqdGtkglRRSY3HfFam3sRL+sUXu9VUqv92n3r0f+FfBXg+Hodqs1Vnm6hEE2
	BA6nB0lanCV5RdoJKmZLGHBTiiteEIyTtmD3rMi68Mtkxrv6DyLzu5hjsFAitUA2KYmS86BI9ry
	grWCCjivVZSC0+FRf1Gw5uABaizpezSmXn2AlaWi8NangszduhDsauBBh91nNNumFEjlwG6bSt2
	s/1Kii0B11kbH+P5t1MxmmHglf6Gp/yrwOtVNpDNDabnplqJKDD8qndnlgv/gN5XbMFsFRO5588
	nSREbkhxYwqbzys8LZE77pNnDg9ClfbhRaXIGSj9q5eu8fHY8cPbdGxoSFGEsfxSQZXjhzS/iUq
	2q66jT+8eFlvZj9CIPIvGoh8k5PSXTVxbyZZdFdY4txLU6rAq9iGaC0124rBxA/SJElvgB2FQb1
	7+7dm0tRrbQfEc1tnWLX5YYlCsIIyHFqlPdAmhYsNM6uzR67uj1/WTARGE61aN+3R+4XME/guwK
	fXfnnIle7HoBKSAyZfL12eWJa5L8veg01wBwoSBmd9TFRJFrzHf/wMeweUdkVnWdy2yOMYSeVrP
	DrRUF40G0rQccJCRU1ZvmE3rt6XiecwyS8hr
X-Received: by 2002:a05:620a:4414:b0:93f:16d4:3bf0 with SMTP id af79cd13be357-93f57f23fa4mr670081285a.42.1792617874277;
        Wed, 21 Oct 2026 14:24:34 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56df2ad5sm349884785a.27.2026.10.21.14.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 14:24:25 -0700 (PDT)
Date: Wed, 21 Oct 2026 17:24:20 -0400
From: Gregory Price <gourry@gourry.net>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Down <chris@chrisdown.name>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH] mm/page_counter: use WRITE_ONCE() for emin/elow when
 parent is the root
Message-ID: <atktYGL3OP088D9P@gourry-fedora-PF4VCD3F>
References: <20261021204818.3431099-1-shakeel.butt@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021204818.3431099-1-shakeel.butt@linux.dev>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 48395160005
X-Stat-Signature: mzim9gk3nwsjiy74bji3np4ikffewwfj
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792617875-659696
X-HE-Meta: U2FsdGVkX19vU85ZCOoQBUSa7sa8M8AOKeNRNjaUtJM3G/gAa2yhq9D0swjsCW7LMXCwLt4G258qTRcQkNADP2BTdVQ6Xx9b9DU7Kh9DmoB21jzL32tnyZaeHF9pdqPL01Z7PAVQuW/nrPhQlSiWl96HkfbpQ47GQlWdpl0Lo04mp30iDFKGpHkmQAcV/dxmFmN0fajRTgfy+34X+ZXjwSvnRKAfBC7Z8zWuYN8VqW5pHViKHSNR/zD7qiMSWTIC8e36Zij0oj8C7/Qws9YJTK/X0mGr9B8g3D2S/DLaJAdPTfYJ6slipECY6YuYSxrI9Uo9MqFP3gr+DsUXVJXZnuo4vBf9Qd+MEmCLIbx9Zz66mOkuIFIkDengqfG0iZsMd9v12Z4ea5JptfY2WEUwdFEF9BeBzmSHmWrpSzmz/BL7qWCicYLs+ZGK25CW1Z/OiWBE2zaMxBi+8mGr9R7l9yn5ts+2XDRr//I9ntwzom/emhxjJtuJqgn2vQD0aLvyi5DPRcgGp/1C+RwbWAm5AGB7pzEg8G6vyz+qQFC3xAd1g5w8gIjPtqKZM/0ksGtXqpzLCUv9hiof78f9KTBNvl/dkxG7LWW6KsHePOAOH9f7518g22GUoEiG/6iG6jui7lawyCjKiLoP/4Fn0rbAOaN+3nkG+Vom8UyakwDt0KYnDLXMXsUB4B3jI0m7zfPbO+l/AkxB0/J09puykz1/SX7yMpD823ixl83GgQZVqSWziGQxdVUeD7gLsrQcgxGkDdk//y3wwzvGgDNsw4bMlldM4O2Lay4+JYEyb1hK4eo/UWMKuAw2CAA5Bt52jZ3vua3WyDBpXZw/4ySmZRedNrEjINhnKxlwqCfqt036YZ5NVIaI2PI5Mfr7SkocHg7BnqTa3GjhGfbgXLRaFwJ31qdclzpZ/9UdK/7FcK6TnLlBopntOMcdLbFjLrcaEFQgyTHwzSwc6dARKkgX08c
 eoxreX6M
 WDLbLjvg9qlobP7B9I5L2X3x9iwzs8oVfdmm1rNBtxR5LtGXZrfmZ6uLgUvbmAL/JmrGlymN/zrFXN3Fy+I0lXZnyZ/ehpZKIcXa7GVl+ihhSk1NjvvusXulC/LODbcq5XU0HolRpVFlQm6O+Nl0jR7kF9VTLrqt+rycO1ej6H4AT6Xb5z2od3/1iTIe86mILwKvF/qvfMoHPi613OsDDir++1SB1bxt/ESFnY8FID6LkiPATxhrahPyrdaBZLBFSHrGInvlF0XTvjpQ3v34CzuIu0ABDkxj2a52kFGmFZtICavDNi2WA375D6bN7FIIi2pzMMHsFUdoOn3yWQlc3In8V9IaXzD81dLw+lVPvbOnkAazmizOlLTgjMTtlAX4K5inziDnnH9tnhnqYBbeA/6a2Vgr4Rn6e18LCG2EYADtaXRo/fhigBsDUwiSIC4ej1jQhR+3NsmvNZ94=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 01:48:18PM -0700, Shakeel Butt wrote:
> page_counter_calculate_protection() runs without locks. Several
> reclaimers can update the same counter's emin and elow at the same
> time, and readers such as mem_cgroup_below_min(), mem_cgroup_protection()
> and the dmem eviction code load them with READ_ONCE().
> 
...
> 
> Use WRITE_ONCE() for these two stores as well.
> 
> There is no functional change. Readers already accept stale values, and
> compilers emit a single word-sized store either way: with GCC 14 the
> x86-64 object code is the same before and after this change.
> 
> Fixes: b3a7822e5e75 ("mm, memcg: prevent mem_cgroup_protected store tearing")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>


