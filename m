Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9830EC43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 18:01:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 944716B00B8; Mon,  6 Jul 2026 14:01:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91B776B00BC; Mon,  6 Jul 2026 14:01:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8311D6B00C1; Mon,  6 Jul 2026 14:01:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 614896B00B8
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:01:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA68B1C1684
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:01:16 +0000 (UTC)
X-FDA: 84959118552.10.6C1C47F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 26B5240004
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:01:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QuYeEdVZ;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783360875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hWZjpuO2sPaGmIipjMexjDU8NB6WWh0CicQdIrDnChs=;
	b=EMuX7qZjSeIEJuDf4U3aBk8tYrk9eSuo5DEe+y6Xy0WpSRiiMV/gzc5VfrqeMYiAnZW7F2
	FP+OC0vxkkBDbJi/ScCK3SIC/NFkAVEi85LLUc9S9bpsmO+f4ElkfpLxLjknStBg0vz3Cc
	+SAjcogZnT2eSfJVwKvLkbBPBBTuuRw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QuYeEdVZ;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783360875;
	b=7B9yMI156hyLWDcGU9L/y57Xz1IpFHLuOROTRuqZLnkL/R3paNT+2We2/f/pqOBaRs9SMw
	DHAsA2DVexk4FrnGVeQNy/DRCODWg7S2t8oiaags98E5ILu4gPBpkGH+iToDsl7lFZ8Q0t
	5O+VO5iwI5PCU7cN0w9Ift1z9PBExM0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CD1A40621;
	Mon,  6 Jul 2026 18:01:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17571F00A3A;
	Mon,  6 Jul 2026 18:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783360874;
	bh=hWZjpuO2sPaGmIipjMexjDU8NB6WWh0CicQdIrDnChs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QuYeEdVZteFAk7651khCoJ5T3Iolew8WxaTX7NxIgypW7HEMPS4DCj1l49jlklMjH
	 VRNNxPmfAY3HF+oyaoXzsucNw3ggGtIQc8fG7J1rOYiFOVihU6q9ENINNMJzp+kqpS
	 V+voYUA9VqrVZWgytkGhZ/svsRjGGADEqx3snX20=
Date: Mon, 6 Jul 2026 11:01:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew
 Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory
 Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: migrate_device: fix pte_pfn/pte_dirty called on
 non-present PTE
Message-Id: <20260706110113.920498961e5b29b212c7a199@linux-foundation.org>
In-Reply-To: <20260706111958.3649651-1-wangkefeng.wang@huawei.com>
References: <20260706111958.3649651-1-wangkefeng.wang@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: c3zibsykf676uw8d8bwekidgaoyos7sf
X-Rspamd-Queue-Id: 26B5240004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783360874-460622
X-HE-Meta: U2FsdGVkX19Cy3cUkRvGJwKNVPbT7aFrRp0UZTcGX9bZf/bYBJtBJClfM7vkMrl20v8sBrUomjI7/rpIHosxpVR/Yb+OOk+0aHCZSYYIoet7ldlqPmoHW2r6kXlpXdavKZkElUQqmaxfLLySILW6OQeXj/o5M/F0DvsZy1VVOGoZx7YyVJQLYIRchyZ1ZxpXqIN/bjhRr9Q6Wk+hIh9b3/yUPskx8JptqQ92ZnDjrgDHk8sA22+tXaJc1NTIcCRtelC7SkSF3VrY1D/mbaQUMb4SQLuGWiuiRO49H8YRmJyukmTJLp+jXbVSoIsOWJsNZ+KZ3tXbjqoYpvDwi1Q8T24iQfs7Yu8mO/dTGUwJVmY6lpx4jvE1ilTrSuOLxtHUbXWY9+R8cU0Rw5DimR++zpJeGAEipqLfrlyaLIaktQ9r9okJWAXGboBorSEBqIYMO6DP1JLPnhAaofHFiOHgzqau7Zp6swFFZ2gcDeNkZtUR+bmJ2rUfkW/20NuI5V7swG8oiZunuPFDPdkmaxfgc9T8tLIJKNHxzMcNY2cfO261R6JAJAFdG/++gl9bOmmyPcYSRcAbO1oKlWCiVAQPiNlzn0mfR5YlEn2MgnZsdBjCV1uIpsWe4gUUvLZ5z6gKIoGZq3e1FKp50Wh8ec3FMkl0kCEvcfzm2WniIOuyZRpMejYzDIbjCeqjZz1YMkw4SeAWa8iAsW9SjzqPMSm/d38HSc0nSHq4Cq5IP6WWOsV89VJsunOSSVn20ZbaZ2/5Q/8QhE/VlVyr7fvPQwIgldo+YwXRR7ppMt5k/VIB5JTAnElDvzvt01VSAsKfvibzRTR0de9P4dGu94DMGFKcs0x4GuKFebyY2Bwgk8HDcM8+EBmqwjjgh5f4AG04vBN+ESjmbTQ6vNti/hD+5Np0QWaZ3z9Oi2+o+rojORo3YVvBkRzEEHS89nwuvfLy1Zn4zDgZI84kGYdtuBZlOmc
 zrpRnfMq
 Q/evjQMc7dMQd3vovYuu6L0zAJyLLue8aTFclOQRQepeGfCtgCNk/dMxJzG1uXIruyaehL5fQtFR/5UVkOwHZDhGFynRBJE8A6p5V/cEFTux8fLu8duEU4lpbMqjCsM0jSqAsKqIEVnliilA9cmXusemSMJadaZhlPYIInZ6gsfSWFXdlXuAQ0KSuddbdQy32Q7nOjBNMP68mQhvFSIY7xySOdPEXU80hH9pz2LBQ9eE7iMMcSIKFZcKBj1iAMJMxE0efQ7zzvdUJB0XisUdCbVrw8DKQ873TxcnQN8KvokJvZQ8I2vCO9Aa2XmiBjXcUVx+pmJIGPb1R+kKuEvUmndJfYAzuboCSMKhCrGPNcYIr/KF3V/SwIAEZFjKf5e+6tWVr0PK+HyZF8DP7Toyx/LAv+zFgssUvTjofuHyhRMNIdbOKq1XcditJDLXsxRXQiphlBU1DNgpeTGA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 6 Jul 2026 19:19:58 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:

> pte_pfn() and pte_dirty() have undefined behaviour when called on a
> non-present PTE. In migrate_vma_collect_pmd(), these functions may be
> invoked on non-present entries (e.g., swap PTEs), leading to potential
> crashes from pte_pfn() or incorrect dirty folio accounting from
> pte_dirty(). Fix both by guarding with pte_present() checks.
>
> Fixes: fd35ca3d12cc ("mm/migrate_device.c: copy pte dirty bit to page")
> Fixes: a3589e1d5fe3 ("mm/migrate_device.c: add missing flush_cache_page()")

Should we cc:stable?

Sashiko might have found a pre-existing issue:
	https://sashiko.dev/#/patchset/20260706111958.3649651-1-wangkefeng.wang@huawei.com



