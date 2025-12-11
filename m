Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63086D3E788
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 02:58:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ABAC6B0005; Wed, 10 Dec 2025 21:58:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 883486B0007; Wed, 10 Dec 2025 21:58:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C13B6B0008; Wed, 10 Dec 2025 21:58:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 701976B0005
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 21:58:27 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB81013BB1C
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 02:58:25 +0000 (UTC)
X-FDA: 84205681770.30.C08A29E
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf19.hostedemail.com (Postfix) with ESMTP id 240BB1A0019
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 02:58:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=TtcV3cNC;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.181 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765421904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4LfuhWoMqWAloJULoKj1IudIPQc7ilfqshnWS+4Dsvw=;
	b=eDYeP2/J3ZDPPn2gXxNDYlN2KFhjGO9vgbwdRgRwptvFmQE6oUviqAQMJp1cAp5H1UTmiG
	a8Bmht3WuFVDb+KY+r/ZP1vNouCpYNTFtiJ27AxY0ZkNSQBQ2MQSTveuLrKluxrBWUPFaf
	PzUGDkwJr+1Fs+3bbx8DPDCIbGOuE/E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765421904; a=rsa-sha256;
	cv=none;
	b=OxQ5kgH6HoZ3cp7Er/dGHB3Hlmw6TNs/NYpIibbz4UYUIc62oZ2AzdRW/3Tbm8OHHp7x9I
	pgKJ2o1J7Rn3Dh08rort+XkdPS1c8nZR/gRbc5/S4XAausp8PCK4IHLsMQQjfwzE/wlRie
	gXxg8FcjfKb6pqhaHL9tKUYpyHHGyt0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=TtcV3cNC;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.181 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8b2148ca40eso75552085a.1
        for <linux-mm@kvack.org>; Wed, 10 Dec 2025 18:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1765421903; x=1766026703; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4LfuhWoMqWAloJULoKj1IudIPQc7ilfqshnWS+4Dsvw=;
        b=TtcV3cNCDP3XfSeIBVnoSgs3TTvR0Sl8UCxQ2Z0r6idAyLPhBKP6we5QVY2VakoXPb
         S92FmCf6YZ1FhRQNGgYneCRjZVPDbf7Tlv9g/3jwnnkFgv0O0VKNm4IIm5H/38N4KUxc
         8x6NV4ykCt2/bMA5jRsZeNTAZR/fMWdSKw62vpS0WXFXPtCoxaI0BrUWYnAFV7SX9XZn
         U6mqpJoDIteTMluZfBSGUwiYqeouhCNa5mPS/gTbDS5C00UCUb7VdNL6gIoK+n9wRXJA
         sdjwe0wgSMsS3M/aYrBmgWm59Ugdne2Du9y1AW0wL9g06kUrvrJU+GUpjao1BfOpKGyq
         hgyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765421903; x=1766026703;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4LfuhWoMqWAloJULoKj1IudIPQc7ilfqshnWS+4Dsvw=;
        b=tBhq1Y2YQWaDF+F+GnFeEHUuzuEDqTXWGzda118ABRVV7sXXP29aSVnHfB54aXZdZl
         jZ6r6xDX1tePJeNR6kDRMVyvWoSZERUi5qnkgEHRY7OgnhK+RqVzID3vQlWpit9J6MQl
         EOfTtoGUsL4Sx//k8wLCWjm6D0YVbg+v6BmJ1O1dd4OJzyIM3WOhcpFb9FVFkR8sRom1
         l1h8t9sjm3ebVlwVAdEj76iWnhTOzi5Z/vu3DIzbxhzfyNdwazcmR5g6M8jVNJuuJ03Z
         wb3zQK36QQM854SxTEAWhqs0K/g+abz3GpL7+OeXLAyqs0ZL9SVr9GIRN2S7F8LJPlBa
         4OfA==
X-Forwarded-Encrypted: i=1; AJvYcCWtS373ruEr7a+rNqZLUetzGu+zwNinZd6buH6xWGJEuaIZe4NK10Nef2aQAWyHb5W/yFRxmLNOaw==@kvack.org
X-Gm-Message-State: AOJu0YxNZN/b1IXpL14E2K8elgE4dJ/hfWWxXR16oUzfIrdRoWdyctgk
	8Pe370bWN2bWfIdAYD5ow0+GIhZyIm1WcgACkFvjYRcuktZIun6iOiuSKfxajJ+lT6E=
X-Gm-Gg: ASbGncvKWJUmUERHkC0yREpIf/qlq+DX3DiTLDvLPOWlLnMc6htnj9fwtZQxRBcPkld
	Zq2fmEpXdscunI5z+xv6uMNQLIsTWbPcRGfisV2UWfnk0wh8PQaJcVB3DOxcZA/UH3O0ywNeI/M
	txMTJJ+ikrGHHHXXt6GlX44/cU87RrANNa5+9fxXtpllxKyDNdgYlwWHDbLM+w7PqSpHyjIWoZj
	MYdz3qVg/j6qgPEn7mjHefxYzp/DOkEHvZuLeC4L4JpjXheldHyd7aYHrVjgHaU2Lo27Cumg8Yk
	yhJEhQ+OrpgXkYAIcNJcRtBgXaC/H2ceeY8SPKCVKVDDS9s2RzcstNJtKRpyoZM+XQin2z20/8/
	NIAqulEDAtdMmtlwPxeShquvA90a8a4BWqiAme17pT7N6NJ1DFJnTnLveiGtQzs9FBtf/eotsLK
	cpC2LuerRzanw0DDw3B+lc
X-Google-Smtp-Source: AGHT+IFoXwBG0n5fP0BNrUvena3y71ni22tWG0aSIY3lZQj1Rng9OU7AuijjB7Oixr4MMXI+LjJMQg==
X-Received: by 2002:a05:620a:2a11:b0:84a:71fc:a16a with SMTP id af79cd13be357-8ba39d46b56mr689168385a.37.1765421903169;
        Wed, 10 Dec 2025 18:58:23 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8bab47f6f15sm113968985a.0.2025.12.10.18.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 18:58:22 -0800 (PST)
Date: Wed, 10 Dec 2025 21:58:21 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, akpm@linux-foundation.org,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	david@kernel.org, zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	lujialin4@huawei.com
Subject: Re: [PATCH -next v3 2/2] memcg: remove mem_cgroup_size()
Message-ID: <20251211025821.GC643576@cmpxchg.org>
References: <20251211013019.2080004-1-chenridong@huaweicloud.com>
 <20251211013019.2080004-3-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251211013019.2080004-3-chenridong@huaweicloud.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 240BB1A0019
X-Stat-Signature: gqmtzxmmgdzop1aquku5hz997kkzognz
X-Rspam-User: 
X-HE-Tag: 1765421903-502766
X-HE-Meta: U2FsdGVkX18L4yyOAWXueyybjlAhkHEMjkFd+ADpQ/E00jdNfS2nqaOQDGuQ3Ai+qWgtrbIUxQd8gOYKvsTrcmydOxMECejD5R9xYknpC4nhpckJW9LRoqH6nehoB7nSmvF8Et4JCACws63obrMH5Url4OgfOAE71q0B4l9MKTYIdC1iKbdQ8fJRFDgCxM5t8DGVdLh/D+8EeJ+uPtEnwRApFVB7YTRs9OzHibCv2GTDUmg4Na+n8xz9Np5QRwAzv40HAgvqQyCFmPk9sYGN2DSC+9Dpb70Bn8BEDqh0lLR1E/VOsgEysDPvKfCtXOCA5XA67d8um0o6zh7JoENMDawUTQKwUbHAKu1cY1rT1iNYV/jM1L2CFVIQxgVDN6sczWxpiA/Ac+NQcV/Z86dRbi/8uibDmb6WtvJq+VXoCkOFN/45frl2k+YY3AyEM3Ku2Vr7cgh2tCMHSkw3PyMVXf29cT1cek+J9RG/gBbrUNBrO/Vib3ZINBm5l42e4Stos+WE8MJNKmbuQMpfE9HZF5mrVHGaS09E0TbVlxYGhnNwaummzXNaipLxzOV8dBV98YtVDeXFaWnUE7rM9B4mn4r9HETIpGl2iejVU7udiGc8bH2RJ5kjfgPV3i5MNSy/LwFUTIgXwqgzp6v9ZCIYi9ppWlvTDZxM0ol66YuUeU5wTN9Ln7SbVmEIkkyF8FDQFvhbPTS6vCtalfoopQTtjdwjyGzG79P8OCl0Uii1/LZs1BMSFa/4oYTZTkQ3DWNaGhJ1ofrswRxGTsF6Vm3LbA5QNJnZ67N3hPgNBNS4k7Ek4cPmojb5+E2YvNhGQ52caT5Qa4v70+FZYA8wWO6kzhxCF7SZXT5pLlfksVHSVMzphXEoKSqahE4wz82KPGMFd00RZC0CEDRg/SXl6zs689BLJzyVoDLEu6DhFGvtGGGs8DOoULQzEbcXkyE2L79RcbdvXnZBhYgKodIqYMS
 Szfhpwvr
 Tlde9+jN+ONZ4l4XcAps0OLrLckj6g17W69fgSmwZTYhmgiThdF/pm+Dj5tX+3vvw2uxxUtkCNV8tYBvUtdnkLt7PoEUQSW/utYw4ZbPXmTnj+RC5ZQ/RibO7YNgDR7AD6HMFP7NrQ+mqfg+rjs7LecyVrA8RUYRpQ2+y6kkoWftwMzxJc+1dnZnQF/nrIRBJ87D3dkYMRAOdWJMuTuMmzzGzxwk7oeDerfbSBfEU9fhJiC1c0eTdiPhANgiveTCeVkxuYxE9JBICKuQ2zg/zGbousCe8pJlloJkYRiVMLG6atJsLJ+Eql1AD7+oBGwcp6Q2113fOThzLucl6aRRqzU5GKzdMHpLbTub3HMag/h60/m69H5TqReM2f7VUEEPw+OzPfFygPhmkkU04eGQ6raIg6NFUwgrh0zQP0wPhUTQSr0kWsdtg2uiBVu3hSCDgPodq6bBB8POSEwrRD8z+B2xEsvmCj//+NSdXm153pBOqc1rLb7Gw2QiVAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 11, 2025 at 01:30:19AM +0000, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> The mem_cgroup_size helper is used only in apply_proportional_protection
> to read the current memory usage. Its semantics are unclear and
> inconsistent with other sites, which directly call page_counter_read for
> the same purpose.
> 
> Remove this helper and get its usage via mem_cgroup_protection for
> clarity. Additionally, rename the local variable 'cgroup_size' to 'usage'
> to better reflect its meaning.
> 
> No functional changes intended.
> 
> Signed-off-by: Chen Ridong <chenridong@huawei.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

