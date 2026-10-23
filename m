Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5E04606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 09:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=ipBrf09a
Received: by kanga.kvack.org (Postfix)
	id C4E2C6B0B23; Fri, 23 Oct 2026 05:11:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1D226B0B24; Fri, 23 Oct 2026 05:11:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5A096B0B25; Fri, 23 Oct 2026 05:11:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8ACDD6B0B23
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 05:11:18 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AD4991C3A0C
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 09:11:17 +0000 (UTC)
X-FDA: 85353322194.10.BB5EFD5
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf26.hostedemail.com (Postfix) with ESMTP id 555AF140006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 09:11:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=ipBrf09a;
	spf=pass (imf26.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792746675;
	b=Ys7OIkR3Kuf2GJ47r21dfH+oo07WBKVFVx2gdpdYycqJsGzOcHSkjYY7P3lE495pvSQIzg
	9JHXkajR2+AsydJFvLXVew+K0RAbgizvJFD3wfGNco0gUGfbSOOtT5mr22RrXhriNYUGSS
	FkZ2gWgKyUCw+MYc2rOFloMuJ6MdnhI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=ipBrf09a;
	spf=pass (imf26.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792746675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y1DpBpNP2E9EKulx/a7BEJDWub7VXoF4Z5h5Ip5x/Xc=;
	b=tPzjuZacf7YzzMm2+TIsACUa6sjRbFLGLwvF8yDUVXAkG/AjaAjBuslEFES77W0VaORBlM
	0iK0nwuBfQt5mkhl3EAhqPs817aXMu95xB5RTkMHJGEes0FR3CLxfmd8zTEGDRWJqpVNiF
	ztPOLFl+QMCduGjKvsjiq6o147dYdEo=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20261023091110euoutp0200a1a11696945b9aab2c9092314d4994~hHZkrXwaA2644626446euoutp02_
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 09:11:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20261023091110euoutp0200a1a11696945b9aab2c9092314d4994~hHZkrXwaA2644626446euoutp02_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1792746670;
	bh=y1DpBpNP2E9EKulx/a7BEJDWub7VXoF4Z5h5Ip5x/Xc=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=ipBrf09aFyhJXVYW9/hXr50G/QMuph7wXeTclCzjyiym+lrcwuGqE74D7Z6YMQ1cO
	 i4KYy9Hoyuc3IlhVwSBIJ5Bng56zvHgQWyZFWVhAIBj9YjAX767wfBvJkxSMvy+fKQ
	 s7nPLkioC+YMc8REU/Q/lExUCIJ+fE1MTDjR4lMo=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20261023091110eucas1p2952cb3709bad99676c7272cb494892c0~hHZkXHS_R1676516765eucas1p2M;
	Fri, 23 Oct 2026 09:11:10 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261023091109eusmtip16c2cf8eef913a9cbe157bb7d427b5010~hHZjnnLda1391313913eusmtip1m;
	Fri, 23 Oct 2026 09:11:09 +0000 (GMT)
Message-ID: <0e452521-582c-447c-ae75-ceb9f66f9ff5@samsung.com>
Date: Fri, 23 Oct 2026 11:11:08 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v3 0/2] of: reserved_mem: use dynamically allocated
 reserved_mem array
To: Wandun <chenwandun1@gmail.com>, Rob Herring <robh@kernel.org>
Cc: linux-mm@kvack.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>, Saravana
	Kannan <saravanak@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Andrew Morton
	<akpm@linux-foundation.org>
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <809fddf5-c4aa-4a78-acbe-c9c39da2d363@gmail.com>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261023091110eucas1p2952cb3709bad99676c7272cb494892c0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261015082333eucas1p28bad74cde14ee0afac2eea11bbe6696c
X-EPHeader: CA
X-CMS-RootMailID: 20261015082333eucas1p28bad74cde14ee0afac2eea11bbe6696c
References: <CGME20261015082333eucas1p28bad74cde14ee0afac2eea11bbe6696c@eucas1p2.samsung.com>
	<20261015082315.56876-1-m.szyprowski@samsung.com>
	<20261021134138.GC3667411-robh@kernel.org>
	<e42637d0-c800-48fe-b943-4ec6ac540d82@samsung.com>
	<809fddf5-c4aa-4a78-acbe-c9c39da2d363@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 555AF140006
X-Stat-Signature: o9q8pywpdqup9nefsfik8uoqjmid7ktq
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792746674-428173
X-HE-Meta: U2FsdGVkX19AwWMhekZeN68gEgQsI4gU1lm5HzDLcQrEi7XF45SNnkhc1S+ucqsYVkWB+Q1bxYMHcQFi9kz7KGHtFCkTJDOOqI0qZUvDzmyu+7/3869bf93otL2h9EqgIMqVEOiPAdIT3lfPttoCTKFEVfEMk83bC1GVm2d/d2w4rYM5RZMzcKcrWftiZ/HPoMlbLL937r0yllnX74fva/lpZQqkFJufmDYIidvkv6iyJJjqdOYYlK7jJTAgKonioYdbq7+IYCnga+gBjLA8+srAASDkDj2tzjf+mCzoXAJOaD1ZSn9Ri0Mkc6g7UZZUgNNpA2Ru5nsVjjRiryBas+Bd1x6n4z7H5jdQ5/S6eqJTZve6PFkrx+YkiDaIFds1rpwmAmb2Y7N3kb1xUMQm18OFKY7fEvl3UXsgyq7k0D+eWieHleLfnNtbqY9uBdRF9fAmAcrujS0yM99HcYpN2bOiCP/shQAOtmQExSrovRPlXOF1RSm5dUBUf1OFyuQKL9P0OmpY0pPUitWR3xrvEggLbObR2bXWr0EdAsAa/V/lHfw8scGtoEu1ByVu5uPakkmkcQx3ubxG0b81HMAetkoU86G06PHOAFXM7rl7JBPn0DdmSG1v4A/lR8150tcjyXbivgw6TERq268oA8qA1Rq43mVQIT8C76hsZGiQhHRsWoApR7Mx88xfcMyLDRpLisZq9chgBu/d8sZslDklOCpGX5qVnYUrcmYXzTIiysTW0wlQsKHgATsanqVe8B7CvE3Fbc5zgTGUo/Sxi6qnXi05UGHMtxtzqE7O3//VoE/moky2rAm/KvuPyMJkANSMfOxYz6qmpqK2WjKRQ5cm+qM+E2lJVdWwjZub3i1nkk8PR9KGV1/91Gve/VzSXOoEHBkfsp0IPkgfNCOCm0fZw2LfQcqI3wTIaN8pt+wTch7mR/1Ho4myB1FRQEKtP1BGQ6cnY/M1uidS4fi0XAC
 RhZH5Rvn
 EKPfxvbuMfNSNEBEevMPg0jeWZ+LtsTpcDKk6JTrA9Sjz6FdyedugsuWrHmT4Lzu6vRvcVWZ0k2oZlRq4by3hXS1C0ViMZzXEsQCJVjFCPuzVnxut3Oxpz7vksJ5nxIw3644/xlRmjs/tfzDUAwTem1ZKJjiampmaFeaoQ0h4fCT+UhY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 23.10.2026 03:46, Wandun wrote:
> On 10/22/26 17:59, Marek Szyprowski wrote:
>> On 21.10.2026 15:41, Rob Herring wrote:
>>> On Thu, Oct 15, 2026 at 10:23:10AM +0200, Marek Szyprowski wrote:
>>>> Mike Rapoport suggested [1] how to properly use dynamically allocated
>>>> arrays during early boot.
>>>>
>>>> Use this approach for reserved_mem array during early scan of the
>>>> reserved regions. Having all the reserved regions in a single array
>>>> removes the need of the two pass initialization introduced by commit
>>>> 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved memory
>>>> regions are processed"), so implement it to make the code simpler,
>>>> easier to understand and ready for adding proper error checking.
>>>>
>>>> Tested on ARM32, ARM64 and RiscV64 based boards. Arch specific issues
>>>> with early mappings were discovered by LLM.
>>>>
>>>> [1] https://lore.kernel.org/all/asc6brs_g0ky0wOM@kernel.org/
>>>>
>>>>
>>>> Best regards
>>>> Marek Szyprowski, PhD
>>>> Samsung R&D Institute Poland
>>>>
>>>>
>>>> Changelog:
>>>>
>>>> v3:
>>>> - allocate the reserved_mem array only after all static regions are
>>>>   reserved or marked as no-map, so it cannot be placed inside any of
>>>>   them
>>>> - record failures of the early static reservations and print a single
>>>>   message asking to fix the device-tree
>>>> - restore conditional compilation of the early mapping code, because
>>>>   some architectures lack support for it (C-SKY & Sparc64 as reported
>>>>   by kbuild robot)
>>>> - allocate the array bottom-up, to avoid allocating from highmem, what
>>>>   might be an issue on Xtensa, C-SKY and MIPS32
>>>> - don't use the early mapping on PPC64, where the scan is done before
>>>>   early_ioremap_setup()
>>>>
>>>> v2: https://lore.kernel.org/all/20261008152403.766439-1-m.szyprowski@samsung.com/
>>>> - removed superfluous ifdefs
>>>>
>>>> v1: https://lore.kernel.org/all/20261008094125.3197971-1-m.szyprowski@samsung.com/
>>>> - initial version
>>>>
>>>>
>>>> Patch summary:
>>>>
>>>> Marek Szyprowski (2):
>>>>   of: reserved_mem: group allocation helpers together
>>>>   of: reserved_mem: allocate and map the reserved_mem array early
>>> Can you confirm the sashiko issues are not issues?
>>
>> I've replied sashiko review. That are again the preexisting issues initially
>> targeted by Wandun's patchset:
>>
>> https://lore.kernel.org/all/20260920092852.614973-1-chenwandun1@gmail.com/
> Hi Marek, Rob,
>
> Since this restructuring and my series touch the same code paths, my
> plan is to rebase my series on top of this series once it lands, and
> send a v4 then. Is that OK?

I think that this will be the best plan.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


