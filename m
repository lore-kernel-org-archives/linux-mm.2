Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE577D65C63
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 22:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07EEC6B0005; Wed, 17 Dec 2025 17:31:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02C166B0089; Wed, 17 Dec 2025 17:31:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E42AA6B008A; Wed, 17 Dec 2025 17:31:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D13966B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:31:00 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7788A160C6D
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:31:00 +0000 (UTC)
X-FDA: 84230409480.15.918A31A
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8FB7A180017
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:30:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=VIrWdxTP;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.47 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766010658; a=rsa-sha256;
	cv=none;
	b=ThxGIg2vZYs+XI5JkqXhBb/Uliffy+rYK4fR8PMvFH9Q7T6/ZYC5jF2RPsRTKyyFICv5WM
	9XuMmCab5CymMnxZ91JhJNHHb3GjvVGppCCbG0h4sShM19jI8iiPZvYsxqIpdisiusCgeb
	oKdb7mlkla2nceWl/kwNrVesuRp85tQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=VIrWdxTP;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.47 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766010658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jN/djI7PKvnyyAXbKKGr0jMJdVuI4zAsGj0vnDi1JaA=;
	b=ALt6eiHRCvyWgSA50Bff816ch/z6+TG2iPlImczrQ+NHfoZq9QfuHK2qx6A+9u8MV3c4u7
	Af9qa1KhJX4kPxEODnO/V8t2JXkB0Ixq/YZAbp38BAxTlzGKLPHnQes+9aKqOkmcev0B4d
	TQyc1D+o7dRQ7Ym3jx1DAWrHMei7Hlk=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-88a3b9ddd40so88706d6.1
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:30:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1766010658; x=1766615458; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jN/djI7PKvnyyAXbKKGr0jMJdVuI4zAsGj0vnDi1JaA=;
        b=VIrWdxTP30Jz9ThMoTEXjf2y8kV9r4bDQSfS+vHyn+SX9Wz+p7/FUOG1xcbu9EdEG7
         nY57jUQhXoSNimuwTV9zsVyztn5QcAcZzMdCURivVXO2RW99jkaCpVI3nPcRlMsCMwcV
         uxUovTEQ54kdQCmnfbCYq+pzZdBmjue/oTsJ7g200WMHeKvkn2UlB59HccUVqIpI/Tcy
         5XAXtulG6EdX0ubsyflych+xs8vVkpsmkFNI5PK0wLxKvTLW5uTuDsTUDLktIaSE7pFP
         tayJK6QCjNvSwV99Dseble3ktXWwFnsl7aEwc9GxWet1w+P/5tq09MpGRycjnw9a74U8
         hwMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766010658; x=1766615458;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jN/djI7PKvnyyAXbKKGr0jMJdVuI4zAsGj0vnDi1JaA=;
        b=vPLyUrOEisIwuV8WpwWjtC5LKCHgSuZGj/B/SC1SSAvPTjYq5vyQBTXLDQ6GGqlaxU
         sJpwhVAnUh74owikqDNXK6Q5FaMIo5lgQdRhyMRQkFYuGg7Dhw8EimwQg9ZAote4wY85
         K2Xe/hpjgHsC2TlwTHXSpgO9O9gJW9TuzN1XWO6TKV3sHnChyVM0nLzQ3F9ivMOymDzb
         UJG1DLEFw57qcgHFuN1c63i5zWLi6aHgwjezt3PftM3pL/l5yT58067iw/UZJrD7HWjU
         jTyuQdlu9pZnr8ZybJNVKGF3/jz4dmy4UKIZ3iGMqDqVxgzsoy4zT260sxR3gTYO0D0z
         pczQ==
X-Forwarded-Encrypted: i=1; AJvYcCWulL40iX1YAczG0hfVtND4U8oM7nNYh+cgvU7MLyIPL2rj+FItwz9A2s9rVACN7OGX2FAtwhLfcQ==@kvack.org
X-Gm-Message-State: AOJu0YyN16cBCMhM9rgQhrOms8EaNTOrMacFqa2W17lBMuakiEr2s3mY
	BzXU0vO5uT0YadqsJA2Q0QF9U+MhAUMs5gj8g2zx6Jir/Kgkmkjc1pKZ2FINkydxy0k=
X-Gm-Gg: AY/fxX4VI9a7AszvSeo/WFVZMjZxo1XtM2UxESDxRE4U75dooy1E3cHkyAcwjBO3koR
	F/UAyaVEiiG8J9rgkv2ULT9z/x9hs2Hlxv9RtSFp6W4Z8E+S2NkWlqvmpwHa0Fo4uJxRvFPt+Ak
	03F9v4KD1dOBEyVYo+pu6UHgwO3gaK0wJUfjQO+/jAOLtpX6KmCgWwc8/CLliIA5VhHE2P2CZuj
	pwMEOrVXctS2Su5aho5NN8GGLDeEZFGubz3JGLkEhAKtZkyRHNS6G4rWPZU2pUdIyipEVsjKq61
	Od4+lYTZVnLotio/TXysWYcLsTzn89udy2Ppu5Pp/EsIL6Sq0hle26xgp4MklG2je9xt6wavype
	tvyT+QWOLVo+kSIJgEdcPDgLFu65kugCM/JikQK3d5nb7bRXSfIDQLjcSEkbLzoRDJwgHeDDk7X
	oyn1F1O3FZDahP+1rM8SPZ
X-Google-Smtp-Source: AGHT+IEM1wpyl7hzMfn/vufMseel5JojAcvDcHhdXICuQpH+dbIyJ3X9YcY+bavocYvdz16v3ln15w==
X-Received: by 2002:a05:6214:568e:b0:880:5851:3c5a with SMTP id 6a1803df08f44-8887e44e9d4mr292735096d6.31.1766010657686;
        Wed, 17 Dec 2025 14:30:57 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88c5db7ab76sm4653466d6.7.2025.12.17.14.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 14:30:57 -0800 (PST)
Date: Wed, 17 Dec 2025 17:30:56 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 19/28] mm: workingset: prevent lruvec release in
 workingset_refault()
Message-ID: <aUMvIDRJegSVSicB@cmpxchg.org>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <1b6ad26b5199b8134de37506b669ad4e3c0b6356.1765956026.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b6ad26b5199b8134de37506b669ad4e3c0b6356.1765956026.git.zhengqi.arch@bytedance.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 8FB7A180017
X-Rspamd-Server: rspam10
X-Stat-Signature: tprkyyr6mte5phmf8howqyjz5cdyq9dd
X-HE-Tag: 1766010658-822347
X-HE-Meta: U2FsdGVkX19uqMUmf+Fj+dM5COybjMf1RTYiioujgomYlIIirkIJ4EQ7T2h0TbfKUmHmQi5eMOz9DvRH3xcnmJudVhsZDTSvyTOuv7xQYKcjp85Js63HImSkPMFEXZncauMIrAupm5YDjXZTP4VijI8RdLJGNNbY97dtktTQCgeGm0QFU3NGVtAqBpuwjv2zf8yGLxzjPz7JKPlDZYtg/9ka7B/QYqrBMPYQU2TU3/2taVlYvSE2//m4EHjVuH2rN9UJ0EgTS/RdgUdbUGC5+0MKMX3xJGbrjRa9F74DpUNhST3S+Cv5hn3iOh+iScySy0hB7zsfbXHETjNJqR5Q5k+dcQ6enojcSH52gHpweh4PxiPrpkY8VUQ8EhfoDrYVj+8s6eZygB03APsioo7NxELH1Gk++/MPoRryxZUS4Ov80BYgV8Q4oH2C6UZPLX1WENH/UFkGljWhSWAUsTzfaBNtsu5kMwbLhpnvXtHTTCone6FiYxV8yB/860MuvM4LNa9nhYwEMFYEYz62GAS5BOwcZvgdBtJnHjelciTs8tdwFmK9M1HKXnv4pQi8d5tY/LnYoJvMFPR46woOsfkP35JgARCnJBSpPrmFbar06mia1E0qwqq9Q22VVRW3hcBcyszOCbvO6ezBBErgBSEgms1ADblnDGw9uGwYZ0ojywig6esYXOtHEBZ1WaSwnGhjJGJ2wOIa44SdGKLv7SloEQy9LYLBNDfvgg39IE61LuyArpq+3eAsf+7wAF21q4sjNv9l4yFeRFqvtzfOZvLDifXez3bDwRl+alnfb6kFpMjjXGh314gMfbLdmqswRfpIs/rn18CNUmciusNOX721oxpNLSV0T8h6msJfV19Htx5ZlVXikZ/MC+HL2CJ7fr9D9Lw124RSk9vgI0l0eKxX0BUezH61EXq/oYFUEXEM/XfW/zupF4URVAwsszXDzfrBqnkYjK+YWLrf9uwyFlP
 i/MmFxdy
 InVjvmABiF9tmqCuNVt3p2N8lzLiy7B/mAtqsRQaffsZ/kA3JnnvqVjs0Q2kRlBqq0AiVWbKrIvd0N7cxwNIVqlslgUoDLqVwQBYWOAdlXYR/kF+3N81waPsBvOSiCISzxSXKAfLESFa3dNhvju12NHdufs702ilqVzH3ztQS42wqk51I30EDG6kxLA7F6lcCEdEvbh59jGgdjsv+y2lLQXOm5GeLDSUIdzSAY/CPubaYXoDeJrAfhTKWqE/MHe4yAqxFlte0EKJF1TPW4iQr4Uf//+U5zP+XPs/U425FFAJEC4z8ccb9SCKb7MYOhNxt0ccHsLY7wnhzVLGYV9ZqVvfSKSCjmIA0OKAKU2hKD8uavZHQYen5LJVLtMCyJlruvwz4K9eWrFkqdX9I3OGL+8KZIQGxgoEmCneNjv+e5mn7Bp5iLcj34OfJWyWSPD+VEtO3GerBZQZT/p4O0p42i2qvP8i3njiykPDRCLu9oWZRVQ8LwPHS8267kw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:43PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. So an lruvec returned by folio_lruvec() could be
> released without the rcu read lock or a reference to its memory
> cgroup.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the lruvec in workingset_refault().
> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  mm/workingset.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/workingset.c b/mm/workingset.c
> index 445fc634196d8..427ca1a5625e8 100644
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -560,11 +560,12 @@ void workingset_refault(struct folio *folio, void *shadow)
>  	 * locked to guarantee folio_memcg() stability throughout.
>  	 */
>  	nr = folio_nr_pages(folio);
> +	rcu_read_lock();
>  	lruvec = folio_lruvec(folio);
>  	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
>  
>  	if (!workingset_test_recent(shadow, file, &workingset, true))

This might sleep. You have to get a reference here and unlock RCU.

