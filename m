Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5949BD61017
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 13:49:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9763B6B0088; Thu, 29 Jan 2026 08:49:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F9D66B0089; Thu, 29 Jan 2026 08:49:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8056C6B008A; Thu, 29 Jan 2026 08:49:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 710B36B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 08:49:51 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 17C9C88168
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:49:51 +0000 (UTC)
X-FDA: 84385134582.19.4F3F876
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3B4618000E
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:49:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BpzwmCNb;
	spf=pass (imf30.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769694589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L2m3MJadzQ92FjJDvV6pbq0LnAGzP5Bc/Tadk16iraY=;
	b=eB7dct1Zr5N+9eyycq2ieZk0qCtuhDCEKn/NeDUhKtLcIe4DcroXhQjY7Vdwt9t3YIZpl5
	xWIZgN7Saino6oJLhX3rbChJvR7YEHs8qUK2SEUMHaZT/DcN+z3S4MNJvdbPPeEKuiM0gd
	92LSUXN13uQEJhIx8dlg7WUsEInTfoc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BpzwmCNb;
	spf=pass (imf30.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769694589; a=rsa-sha256;
	cv=none;
	b=KU3X0hPvLncDDJ7IyIHzOZLQIUrC7GTUzne47JBgn7eqIg7VsBknHrNyNvIzW1HJBT4Cb5
	U27IrEwCZ/yeVVHe/GOkqXsoEZhizRR6SnO8waNAvff+jQDjwoDO6GyAlAifsy65W3AkTx
	03F/XqfCU+K3tcHYnBpXPgwgMuoq4Do=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769694583; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=L2m3MJadzQ92FjJDvV6pbq0LnAGzP5Bc/Tadk16iraY=;
	b=BpzwmCNbfxs5IU6w0dcChDYA/2253fYR8sY5TvX7cCYUROVhlwkL96Yc4eRYg/S+EAYbyWJNhRAAw6ed+NYihMOybnycoov3JoVY/j2GL9CCe8iLc85XBiWgY04cXEoMhKSZ9+9VxeSAXLw2DdPWV86KBCgmmfqtoFMdVcPajIg=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0Wy7d5tv_1769694581 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 29 Jan 2026 21:49:42 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Jordan Niethe <jniethe@nvidia.com>
Cc: linux-mm@kvack.org,  balbirs@nvidia.com,  matthew.brost@intel.com,
  akpm@linux-foundation.org,  linux-kernel@vger.kernel.org,
  dri-devel@lists.freedesktop.org,  david@redhat.com,  ziy@nvidia.com,
  apopple@nvidia.com,  lorenzo.stoakes@oracle.com,  lyude@redhat.com,
  dakr@kernel.org,  airlied@gmail.com,  simona@ffwll.ch,
  rcampbell@nvidia.com,  mpenttil@redhat.com,  jgg@nvidia.com,
  willy@infradead.org,  linuxppc-dev@lists.ozlabs.org,
  intel-xe@lists.freedesktop.org,  jgg@ziepe.ca,  Felix.Kuehling@amd.com,
  jhubbard@nvidia.com
Subject: Re: [PATCH v3 00/13] Remove device private pages from physical
 address space
In-Reply-To: <20260123062309.23090-1-jniethe@nvidia.com> (Jordan Niethe's
	message of "Fri, 23 Jan 2026 17:22:56 +1100")
References: <20260123062309.23090-1-jniethe@nvidia.com>
Date: Thu, 29 Jan 2026 21:49:40 +0800
Message-ID: <875x8kbkaz.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3B4618000E
X-Stat-Signature: o9hdjisxdic8akfqf73yrnw5d3gucuaq
X-Rspam-User: 
X-HE-Tag: 1769694586-846831
X-HE-Meta: U2FsdGVkX18EuSO4t6npeOkEk8kjWXLdUMbnL4GvEngGKCs6FOiv9UCGSSvTSEGAsXhmRBa00UyLsV+9qeEgd7VpgRSroISfqoloEPapYTBR3UfQyw7wIZpsLBS/Q42vCwElf/Qpv9833TvIoCznR1RNb73gLuJKOJuHF3eyXzgQiIsIg/QfLNhlmbLkJ9Uc6W6ul06n1vPEmXhvy4iyruCe6flactl6DJp5K/oLDFp1R3RuNhFnZg5ghEY/QXIaZiiva2k+6cCjsr02Kd4Sd4MHBeZUt3lboX7zRSDyZEqnpnuKN3Fc4qnNI9ZgZomVyBIgxhZEG5CXz1gOsOHdl3gR60ENh0HdbrP38hYk4T8z0ofLJNXK3nZpcmIUrp/IJh1eIURzfXda0Ww+wewXBWa9mHLcmhvkjZdbygy0JOVm6OBtCxjdLqko+FWdZ9lr0fZfs85WlcZOEf+2Hafpu/BcMd8cjl0bHJ5P0SeeKcUOt+nw7hWo/s+rj/aTQuWJr7SgZJ858bbosstc5Ml21ZArLYu/b/dtGakSPvS7Ei1x8PoDtEcqkABur0DgOovSKNWqhIv9uo4Me8irblz7A6jJ8GnF+CRrgoKqsdElhmQmZhWvTRV1gJgIQMa0VPP1Gt9OQRw6gCpOy37yHozAz2ChdEK25xmW/HLSeiAHP5UsvZdgkL3YO7pf+DNcFVr//8mxMqu5CVKJEeym4x0upj+8CjdaRXNhawi6qguwUBL3szGzQlrTGdfgglY2pv9o6gzl7C4LWkbN1KKG95gxByoqlpvpwvrYztD9tkddwN+QCB8Tbm5PwGrQP+y0+tpLuAGK/LV2CmwPJcyFzrUmQKoRJDXvjvXx40wP9Re3zIPQk69C/lM2iQWPbWNmTQICDQJ9KlPye/60athFFCA0+7fG7AQXTH34bMZ/qNceFD3Rhy8BmESuMwqB+C6puytqg+B14RyfeCViHZyW+J6
 WqSyIF8n
 Txkb9Qk2DA0cqkQo03Q60glkOP88lsYsM14NgG+o2V3rFXD706EUYvaT3+GKaFIBLG8GDzVix40Ajnh6W08gn6JyOojyY+I08+0S0pSU+Tx8z83G0uMwiZqAx58/Oy1GNSKDT5paDbXgBdg9HwTZN1Vydc95e4ampqcn+tIlagZuppRy8Hao5J9oKQqov1qNJ4/hXPTOg2vn8QxS4FMeSIiAJaVzVw1NzIx8CKwx5Iaw9iFt4Z+mitMOZrqd0RIdPRW9FHFrlMyKu4qVKLNPOy0mZEvo7Ojz4KqCYnIKpekwqM9Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Jordan,

Jordan Niethe <jniethe@nvidia.com> writes:

> Introduction
> ------------
>
> The existing design of device private memory imposes limitations which
> render it non functional for certain systems and configurations - this
> series removes those limitations. These issues are:
>
>   1) Limited available physical address space 
>   2) Conflicts with arch64 mm implementation
>
> Limited available address space
> -------------------------------
>
> Device private memory is implemented by first reserving a region of the
> physical address space. This is a problem. The physical address space is
> not a resource that is directly under the kernel's control. Availability
> of suitable physical address space is constrained by the underlying
> hardware and firmware and may not always be available. 
>
> Device private memory assumes that it will be able to reserve a device
> memory sized chunk of physical address space. However, there is nothing
> guaranteeing that this will succeed, and there a number of factors that
> increase the likelihood of failure. We need to consider what else may
> exist in the physical address space. It is observed that certain VM
> configurations place very large PCI windows immediately after RAM. Large
> enough that there is no physical address space available at all for
> device private memory. This is more likely to occur on 43 bit physical
> width systems which have less physical address space.
>
> The fundamental issue is the physical address space is not a resource
> the kernel can rely on being to allocate from at will.  
>
> aarch64 issues
> --------------
>
> The current device private memory implementation has further issues on
> aarch64. On aarch64, vmemmap is sized to cover the ram only. Adding
> device private pages to the linear map then means that for device
> private page, pfn_to_page() will read beyond the end of vmemmap region
> leading to potential memory corruption. This means that device private
> memory does not work reliably on aarch64 [0].  
>
> New implementation
> ------------------
>
> This series changes device private memory so that it does not require
> allocation of physical address space and these problems are avoided.
> Instead of using the physical address space, we introduce a "device
> private address space" and allocate from there.
>
> A consequence of placing the device private pages outside of the
> physical address space is that they no longer have a PFN. However, it is
> still necessary to be able to look up a corresponding device private
> page from a device private PTE entry, which means that we still require
> some way to index into this device private address space. Instead of a
> PFN, device private pages use an offset into this device private address
> space to look up device private struct pages.
>
> The problem that then needs to be addressed is how to avoid confusing
> these device private offsets with PFNs. It is the limited usage
> of the device private pages themselves which make this possible. A
> device private page is only used for userspace mappings, we do not need
> to be concerned with them being used within the mm more broadly. This
> means that the only way that the core kernel looks up these pages is via
> the page table, where their PTE already indicates if they refer to a
> device private page via their swap type, e.g.  SWP_DEVICE_WRITE. We can
> use this information to determine if the PTE contains a PFN which should
> be looked up in the page map, or a device private offset which should be
> looked up elsewhere.
>
> This applies when we are creating PTE entries for device private pages -
> because they have their own type there are already must be handled
> separately, so it is a small step to convert them to a device private
> PFN now too.
>
> The first part of the series updates callers where device private
> offsets might now be encountered to track this extra state.
>
> The last patch contains the bulk of the work where we change how we
> convert between device private pages to device private offsets and then
> use a new interface for allocating device private pages without the need
> for reserving physical address space.
>
> By removing the device private pages from the physical address space,
> this series also opens up the possibility to moving away from tracking
> device private memory using struct pages in the future. This is
> desirable as on systems with large amounts of memory these device
> private struct pages use a signifiant amount of memory and take a
> significant amount of time to initialize.

Now device private pages are quite different from other pages, even in a
separate address pace.  IMHO, it may be better to make that as explicit
as possible.  For example, is it a good idea to put them in its own
zone, like ZONE_DEVICE_PRIVATE?  It appears not natural to put pages
from different address spaces into one zone.  And, this may make them
easier to be distinguished from other pages.

[snip]

---
Best Regards,
Huang, Ying

