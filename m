Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1486CCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 19:01:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 007DC8E0009; Wed, 22 Oct 2025 15:01:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFA758E0005; Wed, 22 Oct 2025 15:01:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E10588E0009; Wed, 22 Oct 2025 15:01:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CEEA48E0005
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 15:01:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 795B488BE2
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 19:01:51 +0000 (UTC)
X-FDA: 84026669622.09.A827524
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 96479160019
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 19:01:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DLP7eQuc;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761159709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3cKfhWR9EAoz3TGgIzCCi26XnpwOs4FhECR4gqAhKSI=;
	b=5RFODu+wwhT2T/5wuWW752mS0UG/wBWik4Xr/49d2O/TUmk7L+K/koiyq1zYih67YWVY/t
	nicgDa7A5po3xqTqoiVUIw7JM4Cw91Bn7ZYz9QfNKOIeSQGadz5OmUXb88WqlkyAv49OG7
	OCUB6RHrmKE88+NmqpPUl9+4csT+iCo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761159709; a=rsa-sha256;
	cv=none;
	b=772OrGBPuxYQSqnzQiBGDQ6S92lz4DZ0Fpo8wJha7KhOxnlp9BeBvD610fWbEkpWMjpgQ0
	0Zooi/7I3vophJiTDdZ2Yep9xVenYeh6+g7ajSUZr2Ik1XKZtvJIjAgjEmFb2EtdJnAu3m
	k7OvUHbed62XFUOU/OMP6P7d1K0TDdI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DLP7eQuc;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7AF9843BD7;
	Wed, 22 Oct 2025 19:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69221C4CEE7;
	Wed, 22 Oct 2025 19:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761159708;
	bh=63JTUs9ISlbnK/ywl75Qru/f+JAbONgW7SG760Easek=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DLP7eQuco3iL4+EDDGQaDuup0GPJKZ1mjzs1noT010gML+XFvZmlPNc7QLieETuep
	 RMd7svIb28wljNf91dzLg4ldy4cNp1e/9J09yJyqLdtp3ZIZoH1UGWkvJjYRHgCYG6
	 gLPB83VfK8aUUQBUcWdlUY4ndoUjGeXkiqFLgHNE=
Date: Wed, 22 Oct 2025 12:01:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Robin
 Murphy <robin.murphy@arm.com>, Kevin Tian <kevin.tian@intel.com>, Jason
 Gunthorpe <jgg@nvidia.com>, Jann Horn <jannh@google.com>, Vasant Hegde
 <vasant.hegde@amd.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@intel.com>, Alistair Popple <apopple@nvidia.com>, Peter
 Zijlstra <peterz@infradead.org>, Uladzislau Rezki <urezki@gmail.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>, Andy Lutomirski
 <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>, David Hildenbrand
 <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Michal Hocko
 <mhocko@kernel.org>, Matthew Wilcox <willy@infradead.org>, Vinicius Costa
 Gomes <vinicius.gomes@intel.com>, iommu@lists.linux.dev,
 security@kernel.org, x86@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/8] Fix stale IOTLB entries for kernel address space
Message-Id: <20251022120146.d683b5f1e2e4ca324a92aa8f@linux-foundation.org>
In-Reply-To: <20251022082635.2462433-1-baolu.lu@linux.intel.com>
References: <20251022082635.2462433-1-baolu.lu@linux.intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: a9swdc7mbrknjj16fqqejikpzkhe431d
X-Rspam-User: 
X-Rspamd-Queue-Id: 96479160019
X-HE-Tag: 1761159709-783308
X-HE-Meta: U2FsdGVkX18/aCHhELeZtm3/KjglcDfd/GlYYiqf+RUax3jBCcWBiAItCJfcVxxyiaBXXS4ddYuKd6i+O4b9jAx+Lp6uSBjKGL1YPGNBHKIqHqR6y3oDiXeTNiYMDOEbsmWsY5261f320fUCYT4UfNSyjFNW2rpXLScQxzztbL7lRxBuWPRjSp7+FKalA4i2a7XcAa7MClpWgUz6InmOJKsA0n06G5u/oawUztd9dbq+M4otjPtcG2neownGBQFvnl0QN8uIP18kQM7XeMiS8GbjBbsap58M93lA+0C5NXBl422nhJaQg6gZjMov5UHRpwIsJr/NpcKKDOJ+UKheC/TBDZ/mvihrsp/6EUOYf8+8NXgg3gK3HbJYu54s2ueugGuH8ozJLeNOe3LFkR2gCWXvKNc9xdO2tUsxhZO9EP5LoFozbJ1WS719Hizwa2sIUILMqmRrQrX48Fw6hJ8cBhyHWXkxyGNuOBoHCv1TUvtsb9wKj2I8xTllv36Z2d2YkNHjotVjK+ZKkJGYT9rLpzU9xMDM42XVKJCmPsQr5bo/zJW/kHTu/nQjW77FvZR+U/8PRkO8634YEJxyZjrD+pHF8ZvUwYVhrVr5zFPC9r88vy21cSAk5u5crU7jejlKHK2wpUbYu1RM1+qNCCIfG45m+o1hqcBGIy5KgT0nG4SxS7AZ6sEouCDWmW0Hs+V7GAnMtUKjM9uy9PQ5j2mD3x7NWQs8f7TtunDBvUJZcMMaPXnFigN0kvPG9eUi/QpUr/SlkXAcK5oEUw2C5BLSDy+8LLI5KPv1MNLxMo1Kfkf/Nui8vEyhEQ9PtifoMqPLWTK0Adgq/+CzgnKlV3Qyk8ecZPA2CZStiwl28wPAVx0lFb4/2+xNW9b4gdGCyg78qCGNW9vdYYUgvEBPBaGIECSMBL2pVw+j2xzfGtAYXkGwzuGQdN63bxXapkfBcV389jFfTphRlbUXqtszH+6
 yg1j3xre
 au0PP/XXphYtEdWCBPvBbqxZXWaE3m+rEeqfTl84O/DO/U3wwgnWv3eyFZWQk46hNt3envk8oAofFdr0c3qhDbqxYq/1g58f4Ul8jxWOcoYOzoKDHazW39LPhXIc+0rxqengqe5hZEU/VxYSUYVpXpCVZHHUm6cO7iILPym5FCdu4OhW2zO5LphSYm9LiY7szCWbw0JQSv+9ojacLEuZBDn0HnNzuP7yYWlvRIWud6yBvUXN/OMKv/2XsUGgDBiNNQmSyAe7SZb3McHR/dYU1TuitQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Oct 2025 16:26:26 +0800 Lu Baolu <baolu.lu@linux.intel.com> wrote:

> This proposes a fix for a security vulnerability related to IOMMU Shared
> Virtual Addressing (SVA). In an SVA context, an IOMMU can cache kernel
> page table entries. When a kernel page table page is freed and
> reallocated for another purpose, the IOMMU might still hold stale,
> incorrect entries. This can be exploited to cause a use-after-free or
> write-after-free condition, potentially leading to privilege escalation
> or data corruption.
> 
> This solution introduces a deferred freeing mechanism for kernel page
> table pages, which provides a safe window to notify the IOMMU to
> invalidate its caches before the page is reused.

Thanks, I'll add this to mm.git for some testing.  I'll suppress the
usual email flood when doing this.

The x86 maintainers may choose to merge this series in which case I
shall drop the mm.git copy.

As presented and merged, the [1/8] (which has cc:stable) won't hit
mainline until the next merge window.  So it won't be offered to
-stable maintainers until that time.  If you believe [1/8] should be
mainlined in the 6.18-rcX timeframe then please let me know and I'll
extract that patch from the series and shall stage it separately,

