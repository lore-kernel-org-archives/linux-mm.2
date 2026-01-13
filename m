Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B094D2D10F
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 14:41:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 805B76B008A; Tue, 13 Jan 2026 09:41:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B3946B008C; Tue, 13 Jan 2026 09:41:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B56B6B0092; Tue, 13 Jan 2026 09:41:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 574FA6B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:41:25 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07C3EC0110
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:41:25 +0000 (UTC)
X-FDA: 84327203730.04.038842B
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2DA6740016
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:41:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="i6Ow/LX0";
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768315283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c0FlqHagQMeJGdRJ9nDuz6Meh5pThtbUe/VNTB4XIpc=;
	b=n4WMHmNzTwQiV8D+Cvzi9Tg7iLaFPHQrE2QeQ2aUTsUFnDE7/GUNC+VNpUUzNPlGiqzmG5
	oFMbSuVioVEaGhP9aL7Ai7k/dyIKzlqs1OUJmNWMhsZlTsY7qqB9V0NzsBFwJfARqwGIhq
	aOTozZ8SuNPOIXH3XPwXCvGx8M5UQQo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="i6Ow/LX0";
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768315283; a=rsa-sha256;
	cv=none;
	b=Xz3K8Wy/6wgd5sl86LEiQaXGagZPOhcyUClCPMADqhPVcSaKhoFSKBK5VmWUCQFk70JeUr
	wbliy9PumbUXqTl1jP1aJcknNNEnhwFCSrDYAJzW4KF2ttd8iuCCPZm2uXoKTtdMYJfCj9
	UJ90caUbGFipGYS/AJCe0aAFqvDN1t0=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ffa95fc5f1so77511411cf.3
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 06:41:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768315282; x=1768920082; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c0FlqHagQMeJGdRJ9nDuz6Meh5pThtbUe/VNTB4XIpc=;
        b=i6Ow/LX0+ONbb5GyLSRzjKWrkKGVXzJ28f1ZiBBGRSDQiq507r4oULtlAME/Om/nwf
         84h7W7BCNRpJFGgpvnkE91CfWnZ0BYImu80Tv87vMfpNe8EMJGdaQmROMnGRMUpNFm7n
         qt/HzSGIS9VNnZrBX6DWNvY25o//aelVGm8mR2Kc2OCqWq/4r54auWN+WzgUVmBJONEF
         GgxPVvlmaG3NPxmnyDtc/BKfePxhzXP1Kb8PNvg8WwhAToTKuKLGCvA/w0NIVbF6ggRv
         DfNeJMBmCNcKiBlVlsVuhLeE7riFkz/77VoIzc8kPlQbkn2IGotRPu4Gw3p9VrRXR6x/
         rNjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768315282; x=1768920082;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c0FlqHagQMeJGdRJ9nDuz6Meh5pThtbUe/VNTB4XIpc=;
        b=Uxy2Gwf3nWK5bhwQHJPg/tcls5bJ/2MyIgvxkPrfhwJkcA8gBjL3va6hXQ8n/O0oiQ
         HMwewyZNlXkf6lkCqnDJV70fyjXyNx1A6XxvEYMANoJZE9umtCArTHuLiaCt6kPDaCXx
         Bs9kT8lDgDf8qn3mCIgFCKG8rgYx1cviTf8X2mAcqKSVDZo6iQyMBuL/cuJv3aC8SZRm
         YTUbH8DRx6X3gBlZbjVOiiuwL7AQiCt+IYiSiFvMr7Rl/exgAwknLtQ3cBSb5Nor89t7
         tQRg4YnzLbShy8/SfA4K15xCPb36nOD5vpZ6c8gDzvmgvLFfdMTB3y0+Yr6UFglJne4y
         KP5w==
X-Forwarded-Encrypted: i=1; AJvYcCWPoTXozT+GcDEGLGKETQlzkBkO0x372QcJPLSfdzSGowl6LY/b+nQ6nGjxTEg2wkVNkvGv+pT0zw==@kvack.org
X-Gm-Message-State: AOJu0YwLXoqyKD4w9tnOJLT3hs5UiQTNOWOFdMxBjqRsIHWZDPYrL+DG
	dQQmAXfMfFFS/OtU0coyCmuKeoKXi7aeTEQyTlW1VXz20AstcBuC6hq0ERMMjAYylBs=
X-Gm-Gg: AY/fxX7sw+/FmONDFy5E9W9+cs0iSXWmLgv/fGWms88BbI2rCI26z7pc0jnoH14YjCT
	k7CLBXL0cQ8NI1HyL1r6NpunNunFYN4wmA0toT1+C8rDL5/pepMttyEZ7QLFJ5QG/s6DdB6KkTy
	m5srqbUosojtP/GkAHPpKzSszrN0zKLGcwWjwQKLgZHXmJDAy7thmxG8fky/ro4X0+OwIUrg2pN
	hpMqKdnYqXeq6RX69CbEHfx6bVhA+fZq6810MqRkB9vWfbOPu1+SdUXPmjH3Tp9c1M2RaNbQ/+l
	OET2HKAsxw+phSZgV/4rMBZNWbbK9OQt1eb7kVKz/eUcheU8cjBbqV6bcSykVRjzGKE4s+KELlB
	oDfN35IK2TqEcesBL3ZBmQZfHr+gui74bfK4KX054tUv0ZgaU/0SJqt6jRPwtrjg8Y6wyr/Retl
	PnH0DYAQaf3xOd9E7/33CstP53QmOIgZqADW+3vLUtBOr/oP8KaGtXZRb6ONMV6saXh6KDWw==
X-Google-Smtp-Source: AGHT+IEW7sMBkHfjIrfSvFJJKwklqPXb27yIiyNBAvmRQDK22qTfL6fZmpNCHKGuXEukQBwbKTKjYA==
X-Received: by 2002:a05:622a:40ce:b0:4ff:a46b:3af3 with SMTP id d75a77b69052e-4ffb484b140mr324896391cf.16.1768315282254;
        Tue, 13 Jan 2026 06:41:22 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f51cf95sm1746353885a.33.2026.01.13.06.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 06:41:21 -0800 (PST)
Date: Tue, 13 Jan 2026 09:40:48 -0500
From: Gregory Price <gourry@gourry.net>
To: Bharata B Rao <bharata@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Jonathan.Cameron@huawei.com, dave.hansen@intel.com,
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
	raghavendra.kt@amd.com, riel@surriel.com, rientjes@google.com,
	sj@kernel.org, weixugc@google.com, willy@infradead.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, shivankg@amd.com
Subject: Re: [RFC PATCH v4 0/9] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <aWZZcOFxhniDpuj3@gourry-fedora-PF4VCD3F>
References: <20251206101423.5004-1-bharata@amd.com>
 <aWZVqpyzO3BikuJM@gourry-fedora-PF4VCD3F>
 <b9aafed7-f250-4ce9-b8c4-ec9053f30348@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9aafed7-f250-4ce9-b8c4-ec9053f30348@amd.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2DA6740016
X-Stat-Signature: wwhz7dmn8grdsaogzyj6yxg4y59536s3
X-HE-Tag: 1768315283-37461
X-HE-Meta: U2FsdGVkX1/+/0+/2McbSBHj4NpHH5Ey51OPt+saMrFYSzcQuyTKYRBIcGrlFFUzpARGozJaXqtdYVrOPIrlUwhQn5WbfVRy/8WvuEKUfyO9RCpIeBDYGCJXulR0zUhxoxGNo/BtKeDEKTvR7xK+x1+oJJUeKGlzplsrZQAq9LAB3X4uNQX+bXdNeqfUV5lHqu9mUTlW9uMIkVwhUGyheT2Gyk32rmaCfTDJ3a+0xSsPglga9XBCT6dZA2UUTmzjnc7/602oZGdQ+uKtAoUizR6Ga6yKrhFbAL+va5GL9dfweCmyG+dKYf+z+IwbHpxoLmCLPJSf1dKwJMd4OE5QTcphsMORR9gGMiJWisUvkSEU9FfLOcJC++JQo89JfpTSyMHK5QrLxWy4fQsdzCDU41WKAsI3pIopXJawi24Ok/uh4K3cjnTeIWhyGkr7YXQ9ww9kkcFkUiMrO6m3TDjpJQghp+ZV3OC/3ix0vFWLdidctIzpLOY8Wz5g6t854tJKxsjB14UecQC+rL5s0/4g957HlmuJNG9zOZds4mz7YoU/fYGNEAAGkzkvwCSUFw3jnj4aI/SlCxUKw5648WsCCTGK36KExfi3B2FBJywmod5HrLz3sAtzQWy0bN4sFs56/rdDHIJBY1GCTxzYqCK8gL4Yt9AF2yK696DZPpntxTlXgapIx44+BOzHxnM/c7aXHUqEwk6N+S/mi6BgU8mnNWn2gazIbT7f9zUwsceGGVHb6VZQpfxRghP+jRkD5val1wEj0WshZ2WafvEWB+b0qSExMoJCE0X+Dgxzf9cCWKfBNW6Z295e91XGVEeoVmyBqCAzwHl+a4jW8xyodPUewOJ+KnY0F459YDrmfYd+ROJl0op+YnZxwkOJG6TWxNtjrP1gJQGXLXv+f5FCdyDBQaj43VIYz+dJuaKSG6UG0Os5QwAAN0WS82uU51ca44/JSaK0zGKuv29rr83R6OF
 5Y+1vL/M
 D+Y1BZS7wpWj5mu7iKfs95UH5AyKgdSpWw9QQq2VKdtQ0+JZJ23XvrOuejk5MHSjakcO0N+F4k4XO2xKgB3EyJn23DjTiipTh0ESGN3zob+AClH6jxZOQkGji/nR9ar3LRKjnAzgcs7DJGHHGDfbfKYFGAWtx1cm3M+VLAPP0b/HeffJOi5e5aZZ+ed4JpgFktIs3KrRTggXZGXHQx84M2sqfJjQau+UwhkDe3UfNPeqnc3l/l3wJGKXCWg7IqMX6WBWqsHCqRCc+TTZkGxEoBa/bnjnjJ2JJkBS5XYVGxQ7aulNNh2G0BbL23CMNlVQxO5e7dJS267vRewji8w8bD7d6IPUtI/3OG7ndSEMXTpXLsf8LrUJpJ21VRI8eVkviKXNJ7fgMm/q9eQMGrOEW8QsEzA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 08:08:34PM +0530, Bharata B Rao wrote:
> On 13-Jan-26 7:54 PM, Gregory Price wrote:
> > On Sat, Dec 06, 2025 at 03:44:14PM +0530, Bharata B Rao wrote:
> >> Hi,
> >>
> >> This is v4 of page hotness tracking and promotion sub-system pghot.
> >>
> > 
> > Just fyi, we haven't started real workload testing, but we're setting
> > up the process soon.  Just wanted to let you know it's on the radar.
> > 
> > We want to test this at the same time with some fixes we've been
> > working on for multi-tenant fairness in the demotion/reclaim path.
> 
> Thanks Gregory for taking this up for testing.
> 
> I am working on v5 with following enhancements:
> 
> 1. Default mode: 1 byte per PFN for storing hotness info. NID isn't stored but
> promotion will be done to a default toptier node(specifiable via sysfs/debugs).
> Frequency and time are stored but due to paucity of bits, I will have to use
> some sort of bucketing scheme for storing time like how current hot page
> promotion logic does.
> 
> 2. Precision mode: 4 bytes or 32bits per PFN where NID is stored in addition to
> time and frequency.
> 
> 2 is completed and 1 is in the works. Once I get it working correctly, I will
> post v5.
> 
> Since there were a few bugs in v4, I think it makes sense to start testing on v5
> itself.
>

Can do, thanks for the heads up, we'll wait for v5.

Cheers,
Gregory

