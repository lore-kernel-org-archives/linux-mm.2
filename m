Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9EE9D41D7E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 20:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB7456B0005; Thu, 11 Dec 2025 15:11:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E66866B0006; Thu, 11 Dec 2025 15:11:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7C516B0007; Thu, 11 Dec 2025 15:11:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C46636B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 15:11:23 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5F30F134B40
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 20:11:23 +0000 (UTC)
X-FDA: 84208284846.12.FFEA014
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9A6A610000E
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 20:11:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=t+MNRw80;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765483881; a=rsa-sha256;
	cv=none;
	b=01CPKiltDi/4wK99MWr3/Sf14zinPegiyelKVLVYn5yX0lkgU9XzvK0ysagtGGihkAXVCf
	3a1595y0KpW2Tf2iTJ7Hq0PZxHG9LkKv4cEd7JheRBaOOSy8AG66TFTfe3y+81BAZmXW0A
	1IwyIlh8AsTovZaZH3/+x7PdBjKpGDc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=t+MNRw80;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765483881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iXMCn07pdTFg6hWMUgVjMPRl4KUnIRjEdxDWebh/gNg=;
	b=hq54j35qrDj5qiTKidBltf+7gLJ3x5SVEV1a6WzyDUjOwwVv9wMcjn9dy64cPWRCBrKDAs
	juDv8GjJlsCdb3IsWwL49gu0NUw25Kz3s+3mKy89iWFfheTLwkLEO26Js+zH/uc3KTeODs
	j5aX+RmT6Tq1aMieI+HwPOCKBbW85G0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 709E241B4A;
	Thu, 11 Dec 2025 20:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9772C4CEFB;
	Thu, 11 Dec 2025 20:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765483880;
	bh=hvv30Ubhv2ost49RLGAz7UHR7RNidRTm8ejb5Fnwvcs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=t+MNRw800my4MEFowljyIIUObRxfxjqrgwieAoFEvcCzoYUJJZsGwjXxC+IANhjBy
	 MtltwwlP37apbn4K2x4NXEnCVDz9cQbUoq75lE/DtLsLjahHv6yuae2TRBqyiIogi6
	 Jx1xttCkWrA6C/ZbI6NpswyVnusFemqXqFdlzo3w=
Date: Thu, 11 Dec 2025 12:11:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: <ankita@nvidia.com>
Cc: <vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
 <jgg@ziepe.ca>, <skolothumtho@nvidia.com>, <alex@shazbot.org>,
 <linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>, <cjia@nvidia.com>,
 <zhiw@nvidia.com>, <kjaju@nvidia.com>, <yishaih@nvidia.com>,
 <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH v1 0/3] mm: fixup pfnmap memory failure handling
Message-Id: <20251211121119.0ebfd65ed69b5d5f6537710a@linux-foundation.org>
In-Reply-To: <20251211070603.338701-1-ankita@nvidia.com>
References: <20251211070603.338701-1-ankita@nvidia.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9A6A610000E
X-Stat-Signature: b6ez5i47dbtmr45xxeegd7apa3u1tqu7
X-Rspam-User: 
X-HE-Tag: 1765483881-277929
X-HE-Meta: U2FsdGVkX1/u2CrgxIvWUXFPIzuVs9U9vIQvRbqrVetppRwWF7JL/W0Kur8ZEzeS0SCAaT2yeikxk29QQcmKn+ecbGDTjOLirtNk2An/PQlKv8TXvOVrDplKQz67SFzNMSmre9PmNwVOvY626ZyYsBebc9gWfjQ6DHmzxefDqTPYNy0/Ci0SAS0XVDP/eM18IxUxfuuoYXrOYSpdd8oOI4OQIpwMmAoKxj9F5mIC3SfAJLpeuufGrI1vGsRvFzolI77/bv5EGBf13D4O3+mLY7G0lZSqYAI6GhFpYbPCHbanxzNrYUR7scqsA4WBMGVcOaygc2JfAOAUPEh9RkTqIABIhKIhAPEV+ci+CPW5IOy1zZZcV5NRLUFEGTOlZK0FKl2u4rTlx+N8spjNJNb/lwY7OJv8t+WrshGmsRTsLRxlvRvJj1L6Om+d0sci1/gWX/a+pi8Bqzz4vBw0/9KaYsK4GOEBVFrtjUIrTk9DzAgN+XJd0CRBM7lirLcQS3KUGk3NoLDVLC409mNK/7frjFka8wc3Uh1eYGpeclmhNW9Bi9HVPMoWBMbAprcRnZinGOeXyrJOw1/+MvSsLU/eKGBbYgmmpLNAsa4vYngaokolO8HiS6PyJ6xtRl2zsXoyxJ8jlvdcKajWNoTSx4+l1BgxTuh27MUfpH/VyrlrIZIwF+FdrhUpbisYfDLl6qlBVP1963hS9L16z2lNXhoFC++K2uspf2cpNowbY/ArMk637nONfZvsXsGayqOuh9gbktyMy6locMVLFw12gIJvxnSTMUZjIYgYqItQXomeOoeeA8juUperjlWCOZwhVD6WXkKNGIMGvWbRyjY0LCSEgcWBPaYhOM8nkGhoF1rZiLxg2M1sGSrvz6nPLBqgkLoCJZFoeLjGAelW60eVMVuILRE+F5CSdSuIJmt0pLa70gv2FOWEAjeqNG6qff4SCL5E4fcbRtwLWsLK3m2e5UZ
 WR5vm9HJ
 YhR2sL7iv6xvfxNRXI2vuHHWBrJHllHaSD8m0V8hT8/DoOgZ7lkdfEOmH3R1sAnig7PqwGKeVLQln3zzdEPeSQDeXKO5E67UnS2csKyJ7FF6W9EhE2V+TB6B6XUF7F6hAsPy9Jn1sNZMIpHOvc8Xq6pjXLaXY+PB+E+jmLWS8KYpj2UgMYioro9q+VXpEKrc9JzKnXgTFmezxrZDLiEshGPLgCjA+n01U8CssUPAVFFXfQOcGE9bCtA2HMd7v4tuTChD+7mhDY30H+W9Q07cTQDqodDWqTMGM/FHUaLIRHVaJ4Bbl3dnm9nuk9C2Ao/jsBptaGLWKa7bjWFuVYGGBW6pX4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Dec 2025 07:06:00 +0000 <ankita@nvidia.com> wrote:

> It was noticed during 6.19 merge window that the patch series [1] to
> introduce memory failure handling for the PFNMAP memory is broken.
> 
> The expected behaviour of the series is to allow a driver (such as
> nvgrace-gpu) to register its device memory with the mm. The mm would
> then handle the poison on that registered memory region.
> 
> However, the following issues were identified in the patch series.
> 1. Faulty use of PFN instead of mapping file page offset to derive
> the usermode process VA corresponding to the mapping to PFN.
> 2. nvgrace-gpu code called the registration at mmap, exposing it
> to corruption. This may happen, when multiple mmap were called on the
> same BAR. This issue was also noticed by Linus Torvalds who reverted
> the patch [2].
> 
> This patch series addresses those issues.
> 
> Patch 1/3 fixes the first issue by translating PFN to page offset
> and using that information to send the SIGBUS to the mapping process.
> Patch 2/3 add stubs for CONFIG_MEMORY_FAILURE disabled.
> Patch 3/3 is a resend of the reverted change to register the device
> memory at the time of open instead of mmap.
> 

Strictly speaking, [1/3] is suitable for merging in the 6.19-rcX cycle
because it fixes a 6.19-rcX thing.  But [2/3] and [3/3] don't fix
anything and hence should be considered 6.20-rc1 material.  Yes?

So unless I'm missing something, I'll grab [1/3] as a 6.19-rcX hotfix. 
Please prepare the other two patches as a standalone series for
addition to mm.git after 6.19-rc1 is released.

Thanks.

