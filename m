Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83E9F109E54B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 06:29:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E20056B0005; Thu, 26 Mar 2026 02:29:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAB1C6B0088; Thu, 26 Mar 2026 02:29:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C722C6B0089; Thu, 26 Mar 2026 02:29:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B172F6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 02:29:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 49594140BBF
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 06:29:29 +0000 (UTC)
X-FDA: 84587237658.28.69E47DA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id DEFEB140002
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 06:29:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bwT4yuvK;
	spf=pass (imf09.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774506567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MyI2EYNpZ7Awc0Gl+yjDD05joruwHdulIWYSU2VCVwc=;
	b=CIM3o/laI3FO27Ivf5KLGZ3BRnqtwP0ZkddELPaLDAkYWMXlu+pxsJRDB51UP+OOcgRA//
	iSmmuLXr3lDcGpQYDJ8W7I7Puhy/J7IteFC8TcPO2BhOnM5FDSA11JT95mUaAkR0RakNFo
	wmiSuTrubzDTsD19SnKdU9j3PIvGDXg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bwT4yuvK;
	spf=pass (imf09.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774506567; a=rsa-sha256;
	cv=none;
	b=TfF78BG7vaL2ipPKQQvykjWdBrrLWZjbUUT/VoPd3qhgQvP5mEvZmUFevvOnQNZxZ8Tk6w
	w7hOpsO7U4JRu/A03+/SrzpCoYwqLHaKfgxnkV1c91V+UYnPTl9IbBFSbQC/tQPW6BWO3E
	4l6YKf5fN7b/OcVkCTEdtPqIPXh3Yi8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774506566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MyI2EYNpZ7Awc0Gl+yjDD05joruwHdulIWYSU2VCVwc=;
	b=bwT4yuvKYeKwe95yJS62G/io9T7AhgqTKbtwSzR94pvuEm/YjKR/223A7DzFR+4QNNBEg3
	1vkc8e0VjTV2zO4WkUVSq7J/UA6vviNckpc8SROZp8HFwIpzSfLZPkHa67jecVGNTtutqk
	uL1SIFzdsOYzHa8zNIAS6t6BqC7pN+U=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-t1BZ_FivMOGiRzCOxKsv1w-1; Thu, 26 Mar 2026 02:29:24 -0400
X-MC-Unique: t1BZ_FivMOGiRzCOxKsv1w-1
X-Mimecast-MFC-AGG-ID: t1BZ_FivMOGiRzCOxKsv1w_1774506564
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8230d6d54a5so1791933b3a.1
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 23:29:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774506564; x=1775111364;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MyI2EYNpZ7Awc0Gl+yjDD05joruwHdulIWYSU2VCVwc=;
        b=dFTkTTrVsxCSynYtB+xYbksjE2HLi1OS6KiPL+MtG8QaGz2mUW5OG+41NPw3PK6Q4v
         VZ9IKg3wg/fV229qJlxmrjbe9j0XPkyHfU4sNrc7vrSCuEkiWF3OaoAxDLwhwV8VE2nK
         AWhmWAHcTdqaw5uY6hLEFgT0AHs8gJy7RepCUn5A6zjngdoKbZf1P4Y/kBkCHneyXn/q
         fRqitNl4w2TqWXy/Eb3pFFcMWdycizUS5ZOHH9g3DkqII+gsNt1pIpjw6YMWcgfWacvU
         H9V/3R8uWTCgpMAqww0harPElZIxyCevTvOHe6VTHtA8E4BXzD4D78QqX16wZu+cqlvC
         lp+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWXvTULsyFC4bwtThmpyZ60lVgcuUJ3YaUR4XgslqbSN9gj1LOtCFEbaVwL/9dvdkJ3gaLD66UKaw==@kvack.org
X-Gm-Message-State: AOJu0Ywzzm8BuDohyi3w9HCluwi4G0FNslevUylahFXAnpqC8MSZgdry
	/LYyNcs4YM6oKesLXFpWR0reAP+gZfQqTxAv25OxW00kEnaQNHFAw6jdEueAqMsZhjh8hS3bB9E
	gPuSxINqqYZqcmT0/v9f6Nf6LpDFvpl0dn+DuIGgm52TuEibCrORq
X-Gm-Gg: ATEYQzwDZhBq44iYdk9G5BEzMvOcE9uVbGqUXRSld8VZu1aSGrp0FQ+vzvFgrih+s+z
	6dBvcvGFwiQgMRydRQRIpaUSCwX9p7zbGfjM0F6IQdx7Ie8eJpJ19veurQ7V+4mV92ebcCN2GUH
	lO2kIx0q4v9gKDkDdxBZblNf1aPGuUiTZYFPrfq/yLuu9itCYKnwT3iSpLdZO6qGi3avP5Jp0R1
	LpWUoS2SqWzO9jbXfyxD2MqLU28QxNcYTlYWDVNR/wE9ZpYlj603QvF3GwCvtgejbbVd0tRJb3n
	ODBzmKZi8qs+L6YaMwT5dmkmC8Zl9gPCYhu4VgXOc/ff1R/nXun6UkmYcA4aB1G9oEGXqf7/P1e
	K7hbno6TJ2W4uZ0wq7w==
X-Received: by 2002:a05:6a00:cd4:b0:82c:6d2b:7c53 with SMTP id d2e1a72fcca58-82c869c2554mr386646b3a.19.1774506563575;
        Wed, 25 Mar 2026 23:29:23 -0700 (PDT)
X-Received: by 2002:a05:6a00:cd4:b0:82c:6d2b:7c53 with SMTP id d2e1a72fcca58-82c869c2554mr386611b3a.19.1774506562724;
        Wed, 25 Mar 2026 23:29:22 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82c7d38d7f5sm1553107b3a.29.2026.03.25.23.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 23:29:22 -0700 (PDT)
Date: Thu, 26 Mar 2026 14:29:20 +0800
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org, yosry@kernel.org, nphamcs@gmail.com,
	hannes@cmpxchg.org, mhocko@kernel.org, mkoutny@suse.com,
	muchun.song@linux.dev, tj@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev
Cc: longman@redhat.com, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v5 0/8] selftests/cgroup: improve zswap tests robustness
 and support large page sizes
Message-ID: <acTSQFxTs4-t7P5t@redhat.com>
References: <20260326032658.96819-1-liwang@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20260326032658.96819-1-liwang@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jz1wDgbSK0qgZVw1c-7HALOp6p657J9sVS_isvN1cwk_1774506564
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: DEFEB140002
X-Stat-Signature: iqxi58wnh8bs3op3j3wtzdk3i89m4pf9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774506566-433573
X-HE-Meta: U2FsdGVkX19abxf73iqsxtEOisCpICLIiK5/tXXCRdkIfT3ybOFQpIyx7AxUQTK/RKEXOzohVWK8DEH4l8IL23jVsLKoGmXEWeLMirXjfuJOFvfLywP7dg+fDiweP7BEqc4RxIBT3l48UNJYESep5rZQZbpb1lWmzgbaz0kuG19fhSQMxl7izFxTwii7aRl9hllcsLOSGd1wAmbU4Fq333pKDYrAZ6xfsSieC7sp5QMkFeYXBZFY7xpiziczH+zZVvN9Eh7PClwnw5oV9Vm/O17E2NSmMMGl3czo1d1w5u9/jCF281S4gBA4/0IUnGHXZs6KAIhtXFfDRP7NB1dUV1qwTfN/XcAoV6m5EaoJpESoimz9fvtPDCosaXf0i33odjRcwwL4j2Kxfltp7Fv307UEoxiXdSbg8cLJt0BveYPw34ffLwpdkPJTcg2SXRGp3HYc36yyMY16XWdpsc0we+BjZcpNM3PloXB4o+NRBh7xZIKLt9TufRWOXnxIyzQBLECKwak/4oSwT7ZdSOak1/uqORx8TTc605pi0aUCfWwTt4XGgsh29xancltcmnVPTTgRcuAKGEQxsUvvFbwYgHk55V3TzFvhCmaGz8MlprlSIonOk7ZaqwLkfJepX3j4mDjevoOuvAKNIxnMu0/skqnH93f8EKgEL80Js5Pk4zLahf50vVAVphVdOUxp8O8LpdfnYF6uTjWt4nKNkbH3GI8aFG1m+4W5SEjEaB0TpVkEqI7xkmQJy+j1l5rqtM/saRGToZp5YSOqRyVCMsonAUhR9Ydm0Bguse15boUKsQxjsrwZyUINXSnLDQXDlw5ynehhTlkjuAc/ACFoWluVYueeX6qELB/rAjzSMvZMQLtHqEcu87aaoJv++UUuazQ7vNnVp5keX3Vrsji3UH2EWd/M/L0NlgB/ADM4GyfAkVYUvoP76H1Ad/88+B5bB99ZCbVNcNFqypXD5mJP/c+
 fRiX8nFe
 DYqscH3/u8AAUtIti1n2xX2MeRGHjqNhekaEwZki8aMASr9iv++UBinJ04aK0FJeFRmM9XGcYIqngRnyYUJBEBkOnbymv60tPb3ebNBuyLW4UsuLMtulMsAiU7HJOxz9Ef/6ZUNlEl682LP/fTXlFMg2bm1HqiVoEQ1dyOIry0Ag+ZJaBpxAcKba+voKG4wo3lzSD7PS3ihtmDjy/wFKTTUuO4Xd22jdxhIR2jZURFqR/5IdRMR/dKZWUICM+/0KCJSmln6z2ksReKoEkeuRMCQSneRrvsuQgp4oc9u05BeJMdVZhOIvMhO5iJnU4oFPqlAgk2uOqdE9WsI1Jj1WjkfpMYZBqXyJEcUjgSjQ3ElFHqNRPS70VYDmMGW9K+xAzesSfUzUZSyUhXcFYv0pCzkBwOEqFWmpnFonXGFHkUC6GXW1R/ARgXhc1XSfqjoLl+0+20JZCsEMfhi+VzyL6cN+Hgnj0c5JizVi0av1dXrix0d7daMvBbJXdDTKM7KmMEbCC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 11:26:50AM +0800, Li Wang wrote:
> This patchset aims to fix various spurious failures and improve the overall
> robustness of the cgroup zswap selftests.
> 
> The primary motivation is to make the tests compatible with architectures
> that use non-4K page sizes (such as 64K on ppc64le and arm64). Currently,
> the tests rely heavily on hardcoded 4K page sizes and fixed memory limits.
> On 64K page size systems, these hardcoded values lead to sub-page granularity
> accesses, incorrect page count calculations, and insufficient memory pressure
> to trigger zswap writeback, ultimately causing the tests to fail.
> 
> Additionally, this series addresses OOM kills occurring in test_swapin_nozswap
> by dynamically scaling memory limits, and prevents spurious test failures
> when zswap is built into the kernel but globally disabled.
> 
> Changes in v5:
>   Patch 1/8: Defined PATH_ZSWAP and PATH_ZSWAP_ENABLED macros.
>   Patch 4/8: Merge Waiman's work into this patch (use page_size).
>   Patch 5/8: Change pagesize by the global page_size.
>   Patch 6/8: Swap data patterns: use getrandom() for wb_group and simple
>              memset for zw_group to fix the reversed allocation logic.
>   Patch 7/8: Setting zswap.max to zswap_usage/4 to increase writeback pressure.
>   Patch 8/8: New added. Just add loops for read zswpwb more times.
> 
> Test all passed on:
>   x86_64(4k), aarch64(4K, 64K), ppc64le(64K).

Hi Andrew, All,

I see that Sashiko still points out minor issues in this patchset,
That seems very tiny in selftest programming.

I can correct all that in a new version if you'd like a perfect patchset.

Sashiko comments:
  https://sashiko.dev/#/patchset/20260326032658.96819-1-liwang%40redhat.com

-- 
Regards,
Li Wang


