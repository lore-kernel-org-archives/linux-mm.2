Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 837B9ECD6C4
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 16:04:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A13686B009B; Wed, 11 Feb 2026 11:04:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F41E6B009D; Wed, 11 Feb 2026 11:04:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 900256B009E; Wed, 11 Feb 2026 11:04:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 803686B009B
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 11:04:48 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D96FE58E04
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:04:47 +0000 (UTC)
X-FDA: 84432649014.20.9509986
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id 01C29C0014
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:04:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=YBfHC4fA;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770825886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N9ZsmGOHu5DYwJv3dMDY0xSryZqTJu2IEY2Yi2UfgZY=;
	b=hww35lHkU4qkxTMejBzU8833I08q6N3Pili58cXs3txEEdvx0a5Kgs+ctXt0CrhZuB7F5H
	bvsdfeghXSC7D/XI85XubEijiBOkUgHXQ8l2PM79kj0gdP2WJ7qUKFxyCWPM17kGpKWOmF
	4zqZGtJjhiUc4Z27yg38xf/iIXvoqgA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=YBfHC4fA;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770825886; a=rsa-sha256;
	cv=none;
	b=Y2GYbBRyTysIHiIBBVReJuPc0eyLPmfXzypjvk0fRTTyUoz1uHnO/s246wQz58KMPhI2Iz
	KZxsc/6SrZ+xDiN7fYJU8PoOJd/1eUfbsWW08ov09lfaHqOP2pR21186R5LjL9Fn6Y4/bH
	z1gNh40UDnIQPlDueg4/CHPNuZRkuvE=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50334dd44d2so62398301cf.1
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770825885; x=1771430685; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=N9ZsmGOHu5DYwJv3dMDY0xSryZqTJu2IEY2Yi2UfgZY=;
        b=YBfHC4fAWJ5SDzlkz+BbVsO4+Af9atdQukmJpDiA2TGW14kvXiuz0iuNwiju5zP98Y
         89HUS1Hlw1rKXARGfcte4JmYsbwrPLZ5vbaz1h6oduUoLRflK2hfUMeMEt1K4oNWijf1
         sqGLzELEhhChuI3PNwDsdL1x/wkQlubV/VFWNjkdlMczETXB5qcROCWd41blFeLn2V4I
         IUVZoRvlOUs8XzemUWYuaoiM1KW7ekhd/6HlyaBjhMkg80261R6oWpY0GIKtB1or8fm8
         /P1jIN3wDf4ilheN+9JH2zMuX537BOeOMv7e2GpsRiF5ATwnBzbFJnb6TVX+XCQWSCrJ
         lFwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770825885; x=1771430685;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N9ZsmGOHu5DYwJv3dMDY0xSryZqTJu2IEY2Yi2UfgZY=;
        b=Blbj5JqYpl3HjxLMD75hmMm0KGZcH08jh8q+OnrUlJeVS++UK1R7GXUA79x7c6LSOM
         E1p8WZc0oEXMJVBt7Gcv4MGedHUWvFTs7CVZDY+nkwJkvY5tzGr/g6ealfm+5EQUtSTV
         m/xReLPklY3lEfsfed1+/0hA9SJJQimD1fCKB0xfDxBjGFdsUUNxQVKJfx1gRuV3pkqI
         K+9XNrk2pmu6VzMZ9HOdZ2CHK3eVjET7fweYmGS+2ujktOTUqlX9pPK29AJ+x3RuJlIi
         VWAtIJdcBa7qKka6pQN2Z9p2Aujrkgzm0+iuXcmPY0qLngg3LpZ9jAqdJUT2CfNBRvS/
         0bbg==
X-Forwarded-Encrypted: i=1; AJvYcCXHwoJdoK9tvgdfMPARp850Gz0gW1NRElGc0Ep8qzlWp+h+Ec87g4jLPriyeJHE0n1zHEkwts6keQ==@kvack.org
X-Gm-Message-State: AOJu0YwIuZez8/nEhBID5tGBkItWg4xpk4K+1kFPiH9n6Agwu4s92erL
	3JetXB6G8Vsc7+hJPYL3hOn1D2LOn/TfzOcEr14oZ1TjCDApBfATlYqA7HJN9vZzuyKrkbSFsfe
	BK/yl
X-Gm-Gg: AZuq6aJM5uJopwLK4sV+OwwApkPxLMxi5u0PHJsi24Gu9c7XMxIK9EDJqEJQEut9Usb
	9nqwBDbomZg8A3+UWP4GhkwCZIky92ulcmN5pfC1uUKLXVHInca1NvMXcr4GzdBJF700kH0ue+y
	YAzaWcJWgf7bQLdhSGKB1MfSBWbx07B6QD7qNlvIay3/lcjSpy73DpjCitzMFOYqGDh0dLHnasz
	+UafljW3DRnxlwKlomFs3/K3dcfFN6Xh/Vi9NEfGEDXofBYvCyUDSUc4C6eh71KCLolyP8OH53U
	Zpz7/+LBHl4rHIQz+rYwPRy4/WjsIz9ng6O7zw5hDP0X3PZ15jPXeFZqtI5L4yLEHGkQbmFWLKn
	5prhw0NYHkIWPbsj2fHr7fwi5PAo6POHkYRfdmAs5RDwfSF3O228G3wY9CGXuEyYPmPB0wR0jvV
	oe6dxUmK3sQVB3vy4I0hOCLpwcKtk3D+3xJCujiDz1vpP9ImXp8VM1K8Cu8x5MhdkuXWeqbCJsF
	PmcOKe0hw==
X-Received: by 2002:ac8:5fcf:0:b0:4f4:d2c3:b236 with SMTP id d75a77b69052e-50681210fc2mr45915911cf.47.1770825884823;
        Wed, 11 Feb 2026 08:04:44 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8971cdb5f26sm17471676d6.42.2026.02.11.08.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 08:04:44 -0800 (PST)
Date: Wed, 11 Feb 2026 11:04:42 -0500
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
Subject: Re: [RFC PATCH v5 00/10] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <aYyomjsBpZ2KFxKG@gourry-fedora-PF4VCD3F>
References: <20260129144043.231636-1-bharata@amd.com>
 <911f316b-87cf-45eb-8d9e-412473d7176a@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <911f316b-87cf-45eb-8d9e-412473d7176a@amd.com>
X-Stat-Signature: rchb57x8ym9rnwuqci1ze9o3xecnbnx8
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 01C29C0014
X-HE-Tag: 1770825885-464707
X-HE-Meta: U2FsdGVkX1+PTaObZ9e9iVRxuY7c74tYJ5IAiDM7TEOns0dpS38jGjp/CKDtWRxQK2RQak4DK4M5/H4p6OiPU1QvY8Bvyhnqo5ze71TgX3IBW9OoL2SyusePbhWETsqrevtHNCRKwEvmRCgmjh/MT8jyo30tdZmjI/BUeFdV2L8AX9uxNT6GzbKWOa2C3ncA+1maFVvVt0xNC82OvgYpmbc4q79SE7TOUFehgSACcXLBZ7jQ26Jvgz8fwG5EWq8LHpjvZJYPgHm2tMD9c3oWdK/Gkkh5N5IgUv+gFJs6bZtrVHpn3+A6+HoeyZUs2t/dWQrqhnT1Wnew1/Whq0qOn11P1EjNHPij/UMRX/lWiLDzfIJQgdoyuGE+eM8yC/+OI+B2AFP+ST+aZT+dZUb/jb8831/FMpugdJK3K/tLBzWl072K7cx3QMwQN/iqPHnPmdObJxnTaf66Vhk+LX8z+fTiJmk9QA+JXravvCWl3eMssBKejj16UJPCWxY1doV8qg5h4nnqNaPmKdjvr20RQrY5W1dlMSl0KU4e8xYzEenFXCMJkXJwK3LbvUMvNyx70zr+CXl8/y7EU+iKWxwmmgs5E7mD9ERF/k7cnDSnJhhv/fHCV5Oo/BHoTfaJ+fZyVlNFSlwxLMtogcWe/sx/eaeh2pBXPdKpcuB987HsGaYtVdMH1gjRQxLaS4yLKLWAT+EPKwD0qy9SmztCM93BcDGamicXZlQe53hlzxwC2sZJJPO2mdSVaTOKvoYEw5Lin298YqhYFdr327bxH3NUcPa+RzYX3wjIyatZg1kwqUMgwVCjdTDPE5KZYzVOhBqeBkZ/rzLp/zNI5qUKjsP5ARI/vriPqYxRac6yXQJzN8zj9xRDIOkqqqnDrfFQqdVqppLCnR31sf4yeMu8sGVUgzu6423/CamC94ee8rYBV2mvL/RIsN6BieSlLOnOURxK1oBH5OeRS3O4jHWcdfE
 RjGim5A5
 7Wui8x/skQ08b9JhJkLyYK2s46PbvK/XAcgLy5QBekuBcAcLaofQ/fhktLllizkcPFnqCzrIbVnD23W7XRXwpitsa9Vio5JSNNvV0VYf3PTXGJvUM3ZEUvA26sEy3QftKXJfghMudvjZrV1wlfFj8RqV1a7Fu6i2n/s+/pgel5g0ajYwn/vPUkBlsEtYVK3dsB37dhkK2b2JYyrro6JUjbrbT9qCnIAh0kCzDwkszaqtXAnBz9/llziSsX2PWJE6KSVZPfIMidknnYGUhIm0gp00g4Fy78CcYKBv0PBYdAIH9SsORqoL4SrkzblCkpfkO72NpjE0fJrj+Z4GqCqjdP71Ddq1Iyuh50IyweeAA9VJzPp8Re49TJp4CVOptcTsTwbBZlGoY5rRblIyU2KhA4Oxpuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 09:00:26PM +0530, Bharata B Rao wrote:
> =====================================================================================
>                         Base            Base            pghot-default
> pghot-precise
>                         NUMAB0          NUMAB2          NUMAB2          NUMAB2
> =====================================================================================
> harmonic_mean_TEPS      5.10676e+08     7.56804e+08     5.92473e+08     7.47091e+08
> mean_time               8.41027         5.67508         7.24915         5.74886
> median_TEPS             5.11535e+08     7.24252e+08     5.63155e+08     7.71638e+08
> max_TEPS                5.1785e+08      1.06051e+09     7.88018e+08     1.0504e+09
> 
> pgpromote_success       0               13557718        13737730        13734469
> numa_pte_updates        0               26491591        26848847        26726856
> numa_hint_faults        0               13558077        13882743        13798024
> =====================================================================================
> 

Can you contextualize TEPS?  Higher better? Higher worse? etc.
Unfamiliar with this benchmark.

~Gregory

