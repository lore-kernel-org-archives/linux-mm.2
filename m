Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10AEECA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 12:42:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 087626B0088; Tue, 29 Sep 2026 08:42:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 037606B008A; Tue, 29 Sep 2026 08:42:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8F3C6B008C; Tue, 29 Sep 2026 08:42:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C238E6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:42:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 596301C3275
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 12:42:05 +0000 (UTC)
X-FDA: 85266762210.25.CABC786
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id BAC2840009
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 12:42:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lCS/AK5K";
	spf=pass (imf04.hostedemail.com: domain of xiang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=xiang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790685723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+5qKJBvL/vGEVpTlmAaiJVS2DeSeFABrj9kSripxmHQ=;
	b=4t7L/5oIp4xLbW/byM4fjRs+C+SRVJE/MlF48sf4IXlwBMN9G7FEhadjexWKjOFGAQZSIv
	p2kSwU5yvbUQw87M0FfLxFOmX6vdzXYWO3I+ICKQ9KlapILOv6UE7LeaUQKDRHaSmpDLS+
	OBrRdjaOME1smTPMYO9AcDpI6PwmNL8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790685723;
	b=FCVhF+PoqWLvzuOEaTUiB4FnSGwgeg34mSMXTpXBqvE5MGG4/mGtNzy1UTRhiJdsyzaCdk
	+js3sOkCR+e1SVEftDxGJ8KudNWNLhuE3Z6+YH+uBsImzSfApVuWdS7PAouZe6QJGRGNZl
	vdNel72TtFVOVpjd9I8b7Ou3LfOqWKk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lCS/AK5K";
	spf=pass (imf04.hostedemail.com: domain of xiang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=xiang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E835642202;
	Tue, 29 Sep 2026 12:42:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EAF51F000FF;
	Tue, 29 Sep 2026 12:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790685722;
	bh=+5qKJBvL/vGEVpTlmAaiJVS2DeSeFABrj9kSripxmHQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lCS/AK5KZzNI93Rs6dsarMtPm/dSSopx9xP+oI1XF63w2ZX6aGxPaa85OYa2488QB
	 IJoB5BbUPQudDT4crDX5YMO8dIA0x7qgxBgC6hv62yyG5ehq1X7L5o6BSf53uCAd7S
	 Mtj/09anZZbpdFSSbTjxONc0I6o0IQUl7TvIc++zYGXnAbk0PKD2ZNTX1SGlWPHpYm
	 lzvGkzIdvB+KXdPSTcqYS9FJD/SSElF7kZYINGXULAyRPCBVxClYpOvlDIxU1UlJlo
	 g2FwQ5GH0x6BIBTsIYS0LYdxdKSFiX/dv3EiQGQHMF4kgl9yzKUiYm4DJD0fXwmE7c
	 5r+BUWzyc1gEQ==
Date: Tue, 29 Sep 2026 14:41:56 +0200
From: Gao Xiang <xiang@kernel.org>
To: Jialiang Huang <huang-jl@deepseek.com>
Cc: lance.yang@linux.dev, baohua@kernel.org, damon@lists.linux.dev,
	david@kernel.org, kunwu.chan@gmail.com, lianux.mm@gmail.com,
	linux-mm@kvack.org, mst@redhat.com, ryncsn@gmail.com, sj@kernel.org,
	virtualization@lists.linux.dev, xueyuan.chen21@gmail.com,
	xiang@kernel.org
Subject: Re: [FYI] DAMON and virtio-balloon in DeepSeek's DSec paper
Message-ID: <aruyFPzEe3pS_Qzx@XiangdeMacBook-Pro.local>
References: <20260925054408.10431-1-lance.yang@linux.dev>
 <20260929123241.1408414-1-huang-jl@deepseek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260929123241.1408414-1-huang-jl@deepseek.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BAC2840009
X-Stat-Signature: kzdb49ptcs1hjrn599b5khiwk9srjjeh
X-HE-Tag: 1790685723-466906
X-HE-Meta: U2FsdGVkX18thCiDXsGgkxnm5FqfIKjfRHO3J2aE3GaEYvYbe/Keg2DPu46mj4SJZOGB7BgYLKQKgiXJKrHDh2OqBblrr/dRCH570jVK8y4MkYGxK2je9ksUcRFP9naLy+cb8SHCsmK3sE8fkTaA5SCS6VqTSX0s+WaQdNmANneR/2lYii4IsPvCkYuV5dWSJAc5/aAlBR3Ajf/KMxCGAtPqbEmMYZKu7BmDkpCxQk7BDE7CFFAUhzL2ROGhC1Ng9QrqQkUmzbC6iqivUYC6SuQZDQ3iIV/3InQw3jDnBW5YTjOAg7LF4Qm830zp7BWI+EK7SPOW9UHdN2e4uFMOLtJ3Vf1EIADR0S6O6sAJe8JSoWsTbRlxRHWgbRXqntvD00c+nQDxA8jlzh+oJbgkXM/I5l2GaoL1QWUtCcl/VjAw0U9vVOnyXUjVjqkykiQ5Dm2fYb9A+MW/khLw8vE01OUxirgBckV5b99rOIIsMQEkw7FWOjQ0hY83Sp8au2j24GawA+sYPcw0Q1a6474JYiOy+Kl3ZbVdGvkSvDVVHFeygQypwKAe/OU61G7XhwIl1sUmYGALCs/NBKRjOMvSNIR5B1qKRnyBUCqnBOs5IMlcp+R7BnEzCE2LThsMBOh50wMaSVMSUIq/kyVhN5VIYl8s/szJd8ZbhA/qNAwsSPRNGvfy6jf5J8Oe05R7IXpd/FqcIEB5NDSrzrM2tWhYlXEqayRlu1riXPsCWBKtbvF3sqbCGaLIQD2Sc0FhjDPYoG+b2LcL+d2L7foSsYZOo8wOP26sit+rT6i3gcu3ScUTYnaguRKOWl/Mvw/70WyUEKSgSJbVOVSCeoRQZpAU07Mh7y6HYR6iCdZlUzQByyWjt/q/mXrIT37G70goEEcnG0NWwmYyaM+A4ojtgmuqguI+vhWzjM1hKhu+c5A725Rh0+djIat9+5IZCPjVu4IR3gNY2SYbNyTWBO561oy
 fny2EsF3
 0TDflrmIb7ivZ6PFy+mU1opMLe6kVJtrTVG4zQiH8W8gcz1Td6VWyx26cWwft/JcFQhR4u2IqExt1yKG1Y3L4oHhcFiHMl5hPekFKVYYkMNojfP7NMhUTIqC6xSiZ0Dqff/FzkD27HksoscgEiWlu43Ms45qQPMKMHfNbEl9D6OIq/YKWHB+DlzSvCRZXEqbTKHu2Ar/qN1Iu3XuRKEMwd33vigYG8oCwg+fCq5jNnYuAvJ0UdXw/A8zlN5j5xscE5xeV34yMar9rhPcEDADpKTaX2bfygNnEUzNebMfv35w+Et4gAgtzFyFEYi2wCHJWYZVALMKWrEnccew=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 08:32:41PM +0800, Jialiang Huang wrote:
> Hi all,
> 
> I'm an engineer at DeepSeek. Thanks for the discussion, and thanks
> to everyone working on DAMON and virtio-balloon free-page reporting.
> They have been very useful for our workloads.
> 
> Gao Xiang wrote:
> > It can cause sync 4K faults on the host in the worst case
> 
> This is one of our concerns with virtio-pmem as well: moving I/O onto
> the page-fault path can introduce performance trade-offs. The other
> concern is the substantial struct page overhead for large images.
> 
> For now, we enable virtio-pmem only for moderately sized, frequently
> used read-only images, where there is more opportunity to share the
> same host page cache across sandboxes, as Gao pointed out.
> 
> Muchun's vmemmap work is also interesting to us. My understanding is
> that it allocates private backing for struct page metadata on demand,
> which could help reduce the upfront memory overhead for large images.

Although I haven't had a chance and time to look into that, the main
concern from me is that mmap() access will call
"dax_fault_iter->vmemmap_materialize_page()", and malicious sandbox
workloads (or not malicious, just valid mmap workloads) can cause guest
memory OOMs due to "struct page balloon" for large rootfs in the worst
cases and cause the follow-up mmap access failure, because the guest
memory size may not even fulfill "struct page" for large rootfs.

Thanks,
Gao Xiang

> 
> For disks without virtio-pmem, DAMON with virtio-balloon free-page
> reporting lets us reclaim cold guest page-cache pages and return
> the memory to the host, without those virtio-pmem-specific issues.
> The two approaches complement each other in our setup.
> 
> We have not yet fully explored how best to tune the DAMON and free-page
> reporting parameters for our workloads. For example, the kernel's default
> free-page reporting granularity is 2 MiB, which is fairly coarse:
> reclaiming cold pages does not necessarily produce free blocks of that
> size. We still need to evaluate how finer reporting granularity and
> different DAMON settings affect memory savings and workload performance.
> 
> Best,
> Jialiang Huang

