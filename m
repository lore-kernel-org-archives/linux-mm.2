Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C818FCCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 19:24:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F11D8E00AA; Thu,  9 Oct 2025 15:24:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27B3B8E0002; Thu,  9 Oct 2025 15:24:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 143548E00AA; Thu,  9 Oct 2025 15:24:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F3B778E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:24:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AEF4788610
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:24:37 +0000 (UTC)
X-FDA: 83979552594.28.74D7F96
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id F206040016
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:24:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E6A7cs0s;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760037876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xaZG7jkXgOP4+NVZUId5p5W7Wf8gz0gVX+CZPEW0a9E=;
	b=y09ihZu0y1ZDh4VX4hUWnLpOyR9mSCxm91V1Sz/xyWOVm5XL9ImsFz65vCsr92ZihEjcRU
	HLJ/sX74B+HZIWYyVO9H4wSTn9+BDGYS7doC0Q/17sfbMCfs5q8+biSECK2gxUbSetXDLE
	uT7jMuJ/ohnU/dVYy1erwLljKY081OQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E6A7cs0s;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760037876; a=rsa-sha256;
	cv=none;
	b=J17jIm6Yvfs8Zs2Mqk0b01WOxJeT90g+sUkGsiwxj2zlbUjQzc514khqaDAOanvS2l6aZH
	G0u+2nxalDiAaImE8ic5HVJ1QJmdQsokD0inIxT18WtOeBuYRsaRXS8jq8GshZxetIZVSh
	lzOO7v2dHub8tsyoE9pHJG/OTXxCiHg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EB0F640C17;
	Thu,  9 Oct 2025 19:24:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9663C4CEE7;
	Thu,  9 Oct 2025 19:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760037874;
	bh=R7UMgm5DhR2eirTXtSm8DLpDeVeW5tIj/PilGVHqk+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E6A7cs0s3J8ts2bx4mCJCxa4hzcNkg26elMzG7vV5kvuxpFQs8MLO+81GrRw32lLP
	 veXWheAK7H4A8HoxVgMq2nbZEqPoRnZsNST4zfgHM+hyrSZUBQ4cYhn4pRg7GsGkl1
	 HrYzG6TFTh7WBNeapiE5KiC18YBMIurgCb/afeD3ohLqGVB8lxl/G7JYKcXV82YKkW
	 9neydoNB/d3jfvGzU3oLiGjOIj17wMqcox+AN/gwVpC4gRfNPLTtP/KLp7CeAb9JUJ
	 JY3kzT4hCfVz8AYIun17ngtITZPBHhbidZsIfGKozX656RjJ6SQOkKh3maYulmYk62
	 nZfpGBLoE0AxA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Usama Arif <usamaarif642@gmail.com>,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@redhat.com,
	Andrew Morton <akpm@linux-foundation.org>,
	shakeel.butt@linux.dev,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	riel@surriel.com,
	kas@kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 1/2] mm/hugetlb: create hstate_is_gigantic_no_runtime helper
Date: Thu,  9 Oct 2025 12:24:29 -0700
Message-Id: <20251009192429.57910-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251009191149.57652-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F206040016
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ycqd6sc4o17n6g5ugyzhtqsixzs4f5ty
X-HE-Tag: 1760037875-718641
X-HE-Meta: U2FsdGVkX18Wxh4tzBD2XVRTb0CyEidRJBrvJMDlX3XuvM9wMRwmi7Z/+YiTCSMWgzpJORIf6o781joilXQ7ZxtiSfrvFyALfYEyVu4vJF6Ax61Ca8oRPJPxB0edd48wF98ksdRfuo/kAv9Z+/QIT5fBfaeSxGR28FghRrq03Xi6ezOaTBY9tz/5njCjM5SBWdPpXzd2m3bPGOG2M+/siwpttjvYl584GQ2Zy2qpyl2T62IaXgk+FYttkVzZ4iE/SN4lQA7YVgvXFXbKk0ii+ePEOX6DW1mNlOkRffaE5OVZZVsbf7oVvTChNMuJucLsYHe9B41uZyWfQWbWB8KdUOwaZOizsQ3ivLPftys82yrLFGg/2IZOZCwCAqTEGQtgfz9nlQ7I+ZG6nWy/jr/VCi9lBU4bpS+qEu8ltbTcmc/mfdeemqm5xb5yZBnYAcTGMfuYS9ep0H3FdDCgCtw434lJFAHTHXZ9pRB/ayvff4L6kMDsIjyi2ZhSK6zhCUyFbctin8cB4bzYA6oCraiZO+5fGF0RbNQsdiQzzGK8COs0HXeqyo2x/4dWUehf5jH5Hz2OYV7Dr2EvPDFU7gOOAlsUJUkaTfblZNl3hnCnHxDtlSliK8g0yznIob31fUaYGAg9eidkz+OWocw6fT0wZ+Ze8/dwUdrhyeG2cSGz72beJ6bD/3Hvl2/a0TJnUjluOUnImam7zsz+09JRDml4qTr0acAG93Gw8DtdytI/Ak35aHkRPdOxi1z4hcji9qVonXkQZ06OQvH6zpZDY80IDIMfLpITud0Qvon16SX7EHjTBZGVrSE55PaMXTJ0aVJyKdlaN6XnO36KPuDwGO1+0u+VgQQcm070PyhXxHOhLJ57ZWb9JsuBJ4FPo1AU/GJZfUM9WgvZtxyItoxBxQYb1ev7VvSgHjP4+mpScxTCs32pK1GR1nBxSekAYJ8B4yORnUuuXqkOuD/91nYqPik
 VlHABvn3
 r9fORsY919tCYW5K4h914at1ldPrQp5SGL0t7SwNEjdcmZHUTFY8FvEB64O+hac7Dm4q9wjvV281S2APGlH7IirmTPkc8gHeI7WGqnlLUcCs9sEt7BHAqVQyCOduXifAF+3Jp2RwVIlvlmTDL2RqRHhXXU43Kylc8MS9drUCemPferPTs2m3CtLnZwHWm8PnQfHCh8C+IB2wzSAEmx/ou1t5y5Mh6pdybmaxzuh1ZAFbfgXaJjfSb4qYxtY7tHD8fM3YpRCJ4yfADFGcRlZxtIZtJTNlOKX0fuaqX+T8BVfAnvVHVXeOVh/DKhbm2/5aRQQIQ4cqOWf7tmasXN6ZeMXp/rC8cfzz95s/PlTjkacC7hOx+8XN+SEAX3ODmwQPRJdbh5hUn8t3vKsQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  9 Oct 2025 12:11:49 -0700 SeongJae Park <sj@kernel.org> wrote:

> Hi Usama,
> 
> On Thu,  9 Oct 2025 18:24:30 +0100 Usama Arif <usamaarif642@gmail.com> wrote:
> 
> > This is a common condition used to skip operations that cannot
> > be performed on gigantic pages when runtime support is disabled.
> > This helper is introduced as the condition will exist even more
> > when allowing "overcommit" of gigantic hugepages.
> > No functional change intended with this patch.
[...] 
> It seems the new helper could be used for three more cases.
> 
> On mm-new:
> 
>     $ git grep gigantic_page_runtime_supported mm/hugetlb.c
>     mm/hugetlb.c:   if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
>     mm/hugetlb.c:   if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
>     mm/hugetlb.c:   if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
>     mm/hugetlb.c:   if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
>     mm/hugetlb.c:           if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
>     mm/hugetlb.c:   if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
>     mm/hugetlb.c:   if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
>     mm/hugetlb.c:   if (write && hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
> 
> After applying this patch on top of mm-new:
> 
>     $ git grep gigantic_page_runtime_supported mm/hugetlb.c
>     mm/hugetlb.c:   return hstate_is_gigantic(h) && !gigantic_page_runtime_supported();
>     mm/hugetlb.c:   if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
>     mm/hugetlb.c:   if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
>     mm/hugetlb.c:   if (write && hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
> 
> I'm curious if you are planning to do the conversion later, or there is a
> reason why this patch is keeping those as is but I'm missing.

Ah, seems like that's because the v1 [1] of this series is already merged into
mm-new.

Please ignore the above question unless I'm wrong.

[1] https://patch.msgid.link/20251009172433.4158118-1-usamaarif642@gmail.com


Thanks,
SJ

[...]

