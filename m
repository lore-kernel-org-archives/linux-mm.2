Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90B10C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 20:44:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F5546B05BF; Thu, 13 Aug 2026 16:44:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D5E86B05C0; Thu, 13 Aug 2026 16:44:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60A4A6B05C1; Thu, 13 Aug 2026 16:44:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E6C46B05BF
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:44:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BC0314019A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 20:44:06 +0000 (UTC)
X-FDA: 85097423292.25.B0B0884
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id ADA2E160006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 20:44:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tLm+lc4V;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786653845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fdWp8ueXb6s+udO8FKONy4G9LfKlB2Cu4K/pOBUgXWU=;
	b=i94krV51bb7pwJv1T4gMG82aDntaz7hs8XYZ7esB84o3DXfteoXkjNkMPQXvh8T4dB+9FB
	5/1tMnmmo+mNj3J4JuqOTUofL9MGGgPZrI1HRupgoqSdtKUchalSrTza+an/NpTVu7KePD
	Fd9sY9BYjoG9/bBGITMrjIlYJ9RvdTc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786653845;
	b=I49daivbftfa1u/DNse6j6LPm+DeoU4GzQM731LFWa+kH0QKIao4V6/t0BoS9T+yon4mYw
	f2FVEGahXWsYyDVduPV7wZnwWDH5D1ElZVPQ6wyXjsAUdvNZrKKpBxDRtCapMYp4UvEn26
	ZIrBcq5rjRN1J+ZUcRlInYafwm5uZVk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tLm+lc4V;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1315141286;
	Thu, 13 Aug 2026 20:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562421F000E9;
	Thu, 13 Aug 2026 20:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786653843;
	bh=fdWp8ueXb6s+udO8FKONy4G9LfKlB2Cu4K/pOBUgXWU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=tLm+lc4VMjulDbH3IDfdYTiLafdXv9KILpJPabAUWZJZVA8g25lUIoxGD0Kmhx4+7
	 p1OBHCB+Ri3CblTvUY6PUxsfXxdBNA2u4XtPy+C56SeMZfObAnyKd9/JmEp1B5aK5m
	 9TJMEYD3C02tSJpsr8oJgCBOI2C3ptY1DsqUC5bg=
Date: Thu, 13 Aug 2026 13:44:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, zhaonanzhe@xiaomi.com, baohua@kernel.org,
 hannes@cmpxchg.org, ryncsn@gmail.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, hughd@google.com, chrisl@kernel.org,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, david@kernel.org, ljs@kernel.org
Subject: Re: [PATCH v6 0/4] mm: avoid large folio splits when swap is
 unavailable
Message-Id: <20260813134401.a1fb632936fa3b91e454c82d@linux-foundation.org>
In-Reply-To: <20260813075025.1406585-1-xueyuan.chen21@gmail.com>
References: <20260813075025.1406585-1-xueyuan.chen21@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: d3rt6r1cyth3tudsarhaifmmush851ga
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ADA2E160006
X-HE-Tag: 1786653844-212170
X-HE-Meta: U2FsdGVkX1+E2+rq2i4bxP3HIRsF+edBfeniDRsT+K0EcMNSFrfLu64fnn7iftwxBe3YLDAkYoJXbd85BMNCyRP0g1CTK1T5ikYHuULX7uBqNsDyjA4cX2U+WnWoPERvceRm05Tf8e2LjkGjRlTMp5mi3f2yj+jcVToTBXBn1I4v05ATsoQkCaTwkU1dMlghCOs92jiO/NAV7b1caxKEZ0qZulAsoUBzjtE571crOD5l1lDks77cvkTdgSz7TGjm/NU3GS+R5ha9a7GaEsOILNqMaVQWE1PXE3ncS5diKr1Y4I6dAEsUCVnBmLETCrxa4egHhaATbQijLrRB3U5p2e5dLy/Sd7pM1kJMIH41foLgai7np23ummfUFO5docxqdLt4LlvrXVTSkNoOgkVPtUb6YCU1/BclzQaFcMhgFGxobr4r/FMx6N9xLSWTd+2oJn64AL0iar7XxFQgFLD/NxR2Wdd3lWK94KHq+wmx313FPH86XvZQKFT3s1g/WRxr+zBcifSAgOI3+7p8Bnh8pQKsTXpcRji0PAeZ9EZLB4QCFmDCVnTXVOXHKb1fyz81LD0bSgSurLuk2x4vo47EcrGx+nAon202Gt7wCjW3BWBrkj3EU6lgoZ5stFmp6UM/oZ3dPS3QM2E9bCGUlajQ6hinksbo5IhXU9Qpg3ILbxfqrcnlLMok4/trxYKBlbpDJf21H3pyMJOB6o2a9ABNsWmRpSisM2wxxtHuRrtlHKLzGMmZjv5ZQV8wtrKKOz+tEN0DtG0O9U4QZ6Af4tnOnPRzFvGrXeq37P/7RALVeY/7fZcHXrc3YYMVLKF4hZWATJ0QmaC/iDRdGPQ+2IAYVc2nK8ET0z1rx+2X6CtVO2DceSCvCR2K2SooNdLL2DSUER5TcHAyjyisq/XvEeS4vwB5UBgR72ER66DyN4atoJ8bu4GcuJMsBn4M6JSDrhkDvjcqjrMLrY4ccKLN+MC
 Jq0fQGHb
 Dg98/YmB9DjD1Njy1/ZOHejL8JG6Re59eVBXoV+qDsM0HWFsmss/ypNbaQXSLGfX9c3D/bpZlYHTGS0uS8T2i3f02naBm37WUQY3M7/Hz4J7isJzr6JYQ/ULg4Gnguf+a45ii2c55X95jia96JfAYf+ws+MW5kifipG4b8b9tXVCk9aczKlEUrmNP8fqdmHHfNSBHv3VmVqb/7M3h6BCm6T1teexUXmTzznhAJpgBeM7IlNWDHAaKS/LziCjraKld4uDRcWhIi9HXGUxzIBlkFHNm3jDkhJtmbMfPEw2OAguxwloSdZzrjivJ1Qkms8Pz81LqL3AnCpTWwTUj8jtD7vcchwzCSVP9WOOM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 13 Aug 2026 15:50:21 +0800 Xueyuan Chen <xueyuan.chen21@gmail.com> wrote:

> This is v6 of Barry's original RFC patch, "mm: Avoiding split large
> folios if swap has no space":

Thanks.  It looks like a nice patchset and it comes well-reviewed.

However it's super late in the cycle so I'd prefer to defer this until
after 7.3-rc1.

The changelogs aren't very clear on the overall benefit to our users
(please address this), but I'm thinking "minor".  If I'm wrong then
lets consider -stable backports and suitable Fixes: targets.


