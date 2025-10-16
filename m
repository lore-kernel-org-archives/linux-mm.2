Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3C8ACCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 19:49:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22F2B8E001F; Thu, 16 Oct 2025 15:49:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DFB88E0002; Thu, 16 Oct 2025 15:49:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F57D8E001F; Thu, 16 Oct 2025 15:49:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 012E78E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 15:49:02 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8D02D13ADCB
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 19:49:02 +0000 (UTC)
X-FDA: 84005015724.28.EBCE615
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id DDD98180008
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 19:49:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kEUHIbNz;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760644141; a=rsa-sha256;
	cv=none;
	b=Ti5ymF22ROFErod3egSwNb5hnForGZ+grn+8p3CwT4OjzmvOTsdfEqWubgswcQwXogJkVF
	yPMbXxChVaiOoz1GXQIBK845nEPWPOpxf9Qm9la75KlU0cTYvag1D06y1xCkSojce8VzIo
	ncQv1iT1T/1JaO9IbhvzBL7fWrdcsAM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kEUHIbNz;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760644141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jbT44xupa9HmokEym2A2c6CFNmBwtlb85bL9oZf/VYI=;
	b=YNtHepwi79ZouxN2OLZetUxv/6+sHdf6Vw+aLj2geah/2vSoABQr2RIb40wtCTUvFB/z2S
	UkoORpE60SMm35scL84HwIm1B/44WSoW23Ba56zBCbi3+ONhPN93CPZ76kWLzBKPCUov0k
	IJv7DoSLjNkuhg0Le4BwSNOzvUNCWzY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D3701415EB;
	Thu, 16 Oct 2025 19:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A638C4CEF1;
	Thu, 16 Oct 2025 19:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760644139;
	bh=iWpeYViYVT9Q3c2NgGbuKH0/3JN3NmmA/uSOtQHdCBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kEUHIbNzVacKEiIWE3We6lJnjqsAO2iEPZyWGmwRfasxmn2EEiqxpCGfYxsBecrMp
	 nnOEZLjFdAzwPFNArr6FPy7H0mi+m7yURLGxbEx1fQG7gaK0L3i/pPdKAZFk/Z4rtQ
	 HKpmlTsTh5vIk3mEklgcyzNgydLmZp/kQ7LEjtNj7WXANxBbrM1jVFzfmEWVcTUh3w
	 uRswj1U6SCfqKAq3GXF0lBHAUT8ltxMjGJtCEoXYYzDH6NOUSAt/Pa/5IH6bccrO5A
	 HFyKMD36Xn4S3ocVjN1HL1UGu+CI039D1c3XLAQ0q8CfYOdI4w4wfQzyEhKnPHCZu4
	 rj8P8ntWDkbWw==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [PATCH] mm/damon: add a min_sz_region parameter to damon_set_region_biggest_system_ram_default()
Date: Thu, 16 Oct 2025 12:48:50 -0700
Message-ID: <20251016194851.65981-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251016104717.2194909-1-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: hezxqmy5jrk8gq1gbg8q8gzx8uni71pn
X-Rspamd-Queue-Id: DDD98180008
X-Rspamd-Server: rspam09
X-HE-Tag: 1760644140-956401
X-HE-Meta: U2FsdGVkX1+fLqY/GZG6XiCXCc4L6CibRNvR60W0Grd1mcc68uD1P69bpjpTktF6L/Pgk/vvorfaXNQ6EAxNPfwp0/pZXcpGglgRczpetNkCWbIzMOrpMDhM8JFKHQ/AL7+dOmxJijUCKhQj7ygrSLpTOK/Ib6jzpPGNu9rrmznt7IJOHi5weuEEJCVI6WUJKFZc0iBeidbIhuffLut8NRz3d/wB/yIQlCME543go5Jl3jQ9ykWCsX5rNZDx67HNTtDrwVYtsE/l08wknZQ3CRWr3VuVQXuaTf6E4RJJ/GJAnoXfVxje/vm3Aye6PC2RvHpKLG82yGh7oWfzlI5yPU6DUG1LFVEGySVDQf/qg51kYDWMDCIbFwZMMH8sKUMcHlNt9c9ISjm7Gy1sGbd+A3ZlSo093HcEfJ37DgnQOnHGGkbuIEWMZCCo1x+l0xuvlPhyA+MED0hw0gkZrjgh6croQFzUIAU1vpa9eiIaZE00XGvk97d09aXp1gEohzeDCbE+hx0gEZv8HtDjZwqH5q368hlSIaYenKsH0FVrXCJw5+EdhJkWbmGN1CnNDTd03dgD8wY7udvyvz+/tjkY8Spgq+qRke59bJeTJuegfPj8rN5gzxHRmsrUIjnmi/DbWn/MmNtUmB/NttFaEbwHiG94rNWEBV4Kn7T78B+foKNTFcTLGThg4NXIJ6sqm/9e/0ViZ1J/RC3aldeqNWwEAIWpZpJTUGeSdI/iWy56cWD0+oLJQc3dCcecLXxrokt99GoDFLifwJqY0AoM2rzmAUQphikaptEUqIUg2xetbjRXGQlTOLVDn6m+nDu/ZjNsSBdk8vkPnIBttjER9tdoBeyNWrkxtoMc02MoXOx6DcCnq6Ea0lxEbf+c1QAJKOwiAu8zN68CKLH0L5msIaNK497OpN9AQoiw19SbzN5a58cO/Hc7hKbohIzqDVFXoqMYLwviUNjoACMAOt7OVTL
 7MH5n0Bs
 0/Al18YYkSPrNeqxKh1l7//XuJ/3Ivh7C/QAOrSOt8WNjSfHkvG3AcDZYmR6QebDIr0Z1ejmqoZ6tUADBbtG6j0/J0WzMLe84zVdBFtpEKGUZGhp2gUcnLWS9Uk4OjMHTxRLNn+QYNipQ6EDRFk5wXwR028anc0L74RTGcZJoDfiSwIM4Ft6+kMLpeEpXjsXLSkxloS26r8Ol+hTDdQM95iA/fByfv1f3GLDCFlClZh55bl5+RIIQ2yoELN6c5ZOJxlMZMXdmAMd0l5DOw4IqISiDWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 16 Oct 2025 18:47:17 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> After adding addr_unit support for DAMON_LRU_SORT and DAMON_RECLAIM,
> the related region setup now requires alignment based on min_sz_region.
> 
> Add min_sz_region to damon_set_region_biggest_system_ram_default()
> and use it when calling damon_set_regions(), replacing the previously
> hardcoded DAMON_MIN_REGION.

Can we add more detailed description of the end user issue on the commit
message?  My understanding of the issue is that the monitoring target address
ranges for DAMON_LRU_SORT and DAMON_RECLAIM would be aligned on
DAMON_MIN_REGION * addr_unit.

For example, if user sets the monitoring target address range as [4, 8) and
addr_unit as 1024, the aimed monitoring target address range is [4 KiB, 8 KiB).
But damon_set_regions() will apply DAMON_MIN_REGION as the core address
alignment.  Assuming DAMON_MIN_REGION is 4096, so resulting target address
range will be [0, 4096) in the DAMON core layer address system, and [0, 4 MiB)
in the physical address space.

So the end user effect is that DAMON_LRU_SORT and DAMON_RECLAIM could work for
unexpectedly large physical address ranges, when they 1) set addr_unit to a
value larger than 1, and 2) set the monitoring target address range as not
aligned in 4096*addr_unit.

Let me know if I'm misunderstanding something.

Also, if you encountered the issue in a real or a realistic use case, adding
that on the commit message together would be very helpful.

> 
> Fixes: 2e0fe9245d6b ("mm/damon/lru_sort: support addr_unit for DAMON_LRU_SORT")
> Fixes: 7db551fcfb2a ("mm/damon/reclaim: support addr_unit for DAMON_RECLAIM")

Let's break this patch into two patches, so that we have one fix per broken
commit.

> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
> ---
>  include/linux/damon.h | 3 ++-
>  mm/damon/core.c       | 6 ++++--
>  mm/damon/lru_sort.c   | 3 ++-
>  mm/damon/reclaim.c    | 3 ++-
>  mm/damon/stat.c       | 3 ++-
>  5 files changed, 12 insertions(+), 6 deletions(-)

The code change looks good to me.


Thanks,
SJ

