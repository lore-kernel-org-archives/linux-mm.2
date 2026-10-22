Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32F43606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 09:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=TwDUOkBJ
Received: by kanga.kvack.org (Postfix)
	id 34CB46B08F4; Thu, 22 Oct 2026 05:59:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3247D6B08F6; Thu, 22 Oct 2026 05:59:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2624B6B08F7; Thu, 22 Oct 2026 05:59:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F1E2F6B08F4
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 05:59:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7F28A160787
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:59:53 +0000 (UTC)
X-FDA: 85349815866.14.0D6DCF3
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf16.hostedemail.com (Postfix) with ESMTP id B90FA180006
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:59:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=TwDUOkBJ;
	spf=pass (imf16.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792663191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hv6E3isSN5uuykNiknQE/xC/PGsr4qd+KpdT1+FvHPg=;
	b=tcjRIvQby5wzA5XxZGw0/dwPQcZ9CZEc3acO1oDPv73OPqPszPqIJELg20O7j2ArM9Jjyg
	KkihqnvhhNq6EMjfTO6gFT5WcCvVh/Y8dSyjZzz7Y6E5qZ6Q3nEVe7gKcFklZJ9vBtNHGi
	7MV8vOlO27jtfdDsBuHIwXZG3Gp0t/o=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=TwDUOkBJ;
	spf=pass (imf16.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792663191;
	b=lSmpcpsH10EVec4OwQ3oqfUkbKU/Ttn0LCRONZkIq/lfPGz/Beci3dcSc4NL7rFDhCV4CY
	ARTiAvmsEPPTE2I6lcmX54BV6Z0A8QHLaw8VHV1z6SanoklRXPJCitYwtNvgrQF9tr4QRM
	EG1WphnTviP1pkGwJ3tVLZgLoLMNdKg=
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20261022095948euoutp019aa5b81a61bf9f401d1960d4929a85e0~g0awIol_21695416954euoutp01Z
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:59:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20261022095948euoutp019aa5b81a61bf9f401d1960d4929a85e0~g0awIol_21695416954euoutp01Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1792663188;
	bh=hv6E3isSN5uuykNiknQE/xC/PGsr4qd+KpdT1+FvHPg=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=TwDUOkBJDEyu7SeYdo6P6WD0zhjGiXjfOrJTo34Fa163vrYSJ9lozjO3hC44i6CR1
	 B1b5btqypZjIC7sZEuwdnSsDWQalzNLVPmZolO2HvHc5Fhecl9sGyxHiSN8qPNtePd
	 08DumbO2pnoVotKs8EA6rVvh4tW+cDFGH2SvGvrg=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20261022095948eucas1p2590f8e436e6813105bd59ef602218dd1~g0av4_ICu0496304963eucas1p2w;
	Thu, 22 Oct 2026 09:59:48 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261022095947eusmtip22aefc6b2d2d828b6789400add0d11953~g0avJsDCr1485414854eusmtip2i;
	Thu, 22 Oct 2026 09:59:47 +0000 (GMT)
Message-ID: <e42637d0-c800-48fe-b943-4ec6ac540d82@samsung.com>
Date: Thu, 22 Oct 2026 11:59:47 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v3 0/2] of: reserved_mem: use dynamically allocated
 reserved_mem array
To: Rob Herring <robh@kernel.org>
Cc: linux-mm@kvack.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>, Saravana
	Kannan <saravanak@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Wandun <chenwandun1@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20261021134138.GC3667411-robh@kernel.org>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261022095948eucas1p2590f8e436e6813105bd59ef602218dd1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261015082333eucas1p28bad74cde14ee0afac2eea11bbe6696c
X-EPHeader: CA
X-CMS-RootMailID: 20261015082333eucas1p28bad74cde14ee0afac2eea11bbe6696c
References: <CGME20261015082333eucas1p28bad74cde14ee0afac2eea11bbe6696c@eucas1p2.samsung.com>
	<20261015082315.56876-1-m.szyprowski@samsung.com>
	<20261021134138.GC3667411-robh@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B90FA180006
X-Stat-Signature: c5rmq9io88fonz5gz7wis7tqfbq1pm65
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792663190-294747
X-HE-Meta: U2FsdGVkX195YhrGIeFpZpwVAyD/LV1K0H0zbsNhlFUd64s5omddj0gKZtK4GeF+PF9YuKJjM5pN2no1MxNhqn0cWG+ijDMp4k3w5SsFxKYYEVO9ztOW1/8WlTAYPdg1hqzSLQ0z/nstA64/95wnutOKg04/a3uiYrobGh2BHZfPrpWAvLOR2ogpVQMHKr2FYZFEsJC4WwfrrRvyHURIR70V0Xwx7ChPDPFpgesQTegVpoLg2q8PPMhSaEQCC5Z0apAOoJQsFtVVo+v/P/WC7QLpxavdHzX0+vardlJ7s1PourLK2cL0R0D7coMLjcbErDGozhjjdQfiQKlwS9SR5FiaPzP9zvpk9lGf55XUcIKWYGVuXBH/C5+NFYLA2/kBKqsW3TKKT3gfI9v+kd6pYbi9ir4NOP9QVFuLvstmQ19DV0rJgEn6MOAppgc/Vlv6EytqUVWk+eKVPXDEkE/XqBxJtIC7dgDeQoPTzMTZFy6effSIwnR3V+VSiQ8gLYs32I+OqstIG+cncUqsw6mFSMf4b1onfcMwZxtSf/3qd4q0+63UXPkv+JvDyBnRaeDEfgqdgpMyhJ8OtwHOlSzqFA7w3R125tsI/yLJYzCT9pGuPdoE+BlQ1qZ8GVLbrmabz865wEs2jGQ5dDMuMro9W5sqmvbIYEuI9GTLUOJyCFGGU7wAZ79SAgI/WZNLsetRD+qABiUSKItoVhSWgn/RqRSElAl2pvkRfVkIgyY8rpo6ovkU7QploU9kE1PUYyK8RuZwNeE8Lx0KxHImRdOHDaPwP4PqPxYT9a6Hdl+xgfxgFJW+HlmtQq9MF9kXzrUt1Xv/O1RAuzI4mqkR7rHwmJY6IEg8RdjvhHXkA1bUaLX661JQqRafQuGvcVYS/jtzkSlM2ngxWGmEAYUELE0pxzuRazzmji/Sbi77ZHKyq60vk6CWWb9SICWvALYiJhlF7d1154UvmuUk9956bpI
 N7jsWYYJ
 +ZaZLBNbD7jbSh6oEbfqOiIKHi/DYCLoBD94ivgN+ExR0Xzm4fdRVD4/jliSy9Rs166ytxpu7YM7OtYJ2M/BlgxA72ppWQo5Be7y2KJKzrwKV46vI4ebOqZq9P5cvqZiXE/p0DUSaiPhXC7RHZjUvGrfl6+gKgLPY7q+cRZXyjkX5dTQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 21.10.2026 15:41, Rob Herring wrote:
> On Thu, Oct 15, 2026 at 10:23:10AM +0200, Marek Szyprowski wrote:
>> Mike Rapoport suggested [1] how to properly use dynamically allocated
>> arrays during early boot.
>>
>> Use this approach for reserved_mem array during early scan of the
>> reserved regions. Having all the reserved regions in a single array
>> removes the need of the two pass initialization introduced by commit
>> 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved memory
>> regions are processed"), so implement it to make the code simpler,
>> easier to understand and ready for adding proper error checking.
>>
>> Tested on ARM32, ARM64 and RiscV64 based boards. Arch specific issues
>> with early mappings were discovered by LLM.
>>
>> [1] https://lore.kernel.org/all/asc6brs_g0ky0wOM@kernel.org/
>>
>>
>> Best regards
>> Marek Szyprowski, PhD
>> Samsung R&D Institute Poland
>>
>>
>> Changelog:
>>
>> v3:
>> - allocate the reserved_mem array only after all static regions are
>>   reserved or marked as no-map, so it cannot be placed inside any of
>>   them
>> - record failures of the early static reservations and print a single
>>   message asking to fix the device-tree
>> - restore conditional compilation of the early mapping code, because
>>   some architectures lack support for it (C-SKY & Sparc64 as reported
>>   by kbuild robot)
>> - allocate the array bottom-up, to avoid allocating from highmem, what
>>   might be an issue on Xtensa, C-SKY and MIPS32
>> - don't use the early mapping on PPC64, where the scan is done before
>>   early_ioremap_setup()
>>
>> v2: https://lore.kernel.org/all/20261008152403.766439-1-m.szyprowski@samsung.com/
>> - removed superfluous ifdefs
>>
>> v1: https://lore.kernel.org/all/20261008094125.3197971-1-m.szyprowski@samsung.com/
>> - initial version
>>
>>
>> Patch summary:
>>
>> Marek Szyprowski (2):
>>   of: reserved_mem: group allocation helpers together
>>   of: reserved_mem: allocate and map the reserved_mem array early
> Can you confirm the sashiko issues are not issues?


I've replied sashiko review. That are again the preexisting issues initially
targeted by Wandun's patchset:

https://lore.kernel.org/all/20260920092852.614973-1-chenwandun1@gmail.com/


> I'll apply this after rc1. Are you willing to be added as reviewer or 
> maintainer for this code? I'd prefer not to have another entry just for 
> the reserved mem code, so you'd have to filter out the rest of the DT 
> code (not the bindings and dts firehose) which isn't too much.

Okay, I can try to take a look at the drivers/of related code as reviewer.
I will filter it out to reserved_mem related changes locally.


Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


