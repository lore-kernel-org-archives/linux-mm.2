Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93E2BCCF9F8
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 01:01:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7092A8E000B; Wed,  5 Nov 2025 20:01:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E1498E0002; Wed,  5 Nov 2025 20:01:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61DBF8E000B; Wed,  5 Nov 2025 20:01:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5124D8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 20:01:32 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CEDAF12C628
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 01:01:31 +0000 (UTC)
X-FDA: 84078379182.03.4E1F0A9
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id D3B3820005
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 01:01:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TGxOWEap;
	spf=pass (imf13.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762390890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r6I0TYY3j79BQpKPB1Cj7u8E0I09XzskLvOBfRvxEFM=;
	b=Decj8kMJPFMGsPHtYRXJTk/Qc4OQpI5Eu1dCZi0fzmVhkE7itteyO8h67jwrKAE8xo7xI1
	GrvcvpMush6vBYhtw3pMKEt+SxkPlUU5UzBubisynqoml6k7jfk/DD0MtNKNy4YT2Po5nG
	MfTJ3O6NA+EMJyPSjmupa87CWxkU9b0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TGxOWEap;
	spf=pass (imf13.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762390890; a=rsa-sha256;
	cv=none;
	b=0573EiBiZT+8jtyhZHt3g4GxAzU1HDw9sVlOvZvRijta7x1Sb1wBmTN6EC7e/sCQHoOzVS
	kesQNu2PSXoKCi3IOJtAAxnqxvFd1t3MF+NoU4gPENo+A/D92UIfjX3AwFTMUQKHmGCOTD
	0e5mMtltXhstYgq92xYXlwN48qlhvwE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1762390885; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=r6I0TYY3j79BQpKPB1Cj7u8E0I09XzskLvOBfRvxEFM=;
	b=TGxOWEapKrYoq341HPablULyCiFwCm8jEuTZL9AhqQno5bLNgQvWq1fPAy0n3ckuh2biQ2mnXHiKq0RHT20WqygmmMMchvnQ2CEedELfRzIyUKw3nMGwxgFzDNTonVvoq/UckJmr0/3jYrlHY2+6DlTvNGjL4XB1Vj8KKSZlfKw=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WrnG5nF_1762390876 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 06 Nov 2025 09:01:25 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  David Hildenbrand <david@redhat.com>,
  Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,  Vlastimil Babka
 <vbabka@suse.cz>,  Zi Yan <ziy@nvidia.com>,  Baolin Wang
 <baolin.wang@linux.alibaba.com>,  Ryan Roberts <ryan.roberts@arm.com>,
  Yang Shi <yang@os.amperecomputing.com>,  "Christoph Lameter (Ampere)"
 <cl@gentwo.org>,  Dev Jain <dev.jain@arm.com>,  Barry Song
 <baohua@kernel.org>,  Anshuman Khandual <anshuman.khandual@arm.com>,
  Kefeng Wang <wangkefeng.wang@huawei.com>,  Kevin Brodsky
 <kevin.brodsky@arm.com>,  Yin Fengwei <fengwei_yin@linux.alibaba.com>,
  linux-arm-kernel@lists.infradead.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH -v4 0/2] arm, tlbflush: avoid TLBI broadcast if page
 reused in write fault
In-Reply-To: <20251104095516.7912-1-ying.huang@linux.alibaba.com> (Huang
	Ying's message of "Tue, 4 Nov 2025 17:55:14 +0800")
References: <20251104095516.7912-1-ying.huang@linux.alibaba.com>
Date: Thu, 06 Nov 2025 09:01:15 +0800
Message-ID: <87ms509dpg.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D3B3820005
X-Stat-Signature: zc58d97sr7ca5kjfo1wdt3msfw5kbn5q
X-Rspam-User: 
X-HE-Tag: 1762390888-958203
X-HE-Meta: U2FsdGVkX18OM+tsLwnpmpj2oNeS/eUFTN+TfMW1SxZBYwUoZbjjKLS3q+EpAs/OuxQCA8mAjm267e9KYGuoMZtZFPeDubd3y6jNwxgZJa2zw2w5/86RbzJXDxxxhME41OTW4i9RXQci6rg7Sd7jTK7YTim8fwPO2NSQibTb04bkjXfUtpR3s+p4zAHDi77G67T8+Ej96x0JRxyuqyrQCD1spFA9k+cP3xT/8h1UOZ6w17E6BsAq0ajHDH08anZ6sgmvUWYwtxIU7EzHhSmkhETsN7iHl5qLrXnDTviNd5lNXSQJrPDdKhiADD1Wp7DlvNSd8VvwkhJOrlsAxdhbxyY/w7xcbgwh3VYZZVJN5if7xxqG7A502V9HPhUZuYlGBBxOpcJ112I2+NkM2W2xpujR6OOyKBdFCH/dxJ01r9LnKxUNGe9OpCCNAXSRewtuD+5Nc9HRZJB+kiyzAGnEwxxQ+wTuej0Dx72va2ezJLs8sv5eRezLBjQYjZdkTcg3mp2brThkqysEEsj3JUnZwlqfRzzEO2qKq2m2iEZKPYwZbCaa+00HoBNt5WNuAgETyG5oxdB4Gk/U6CyILpAI+izDx2QADKt7N2x2cUcTl5IP4zxZQnedPSKXiqtlVylNT8FpgCGapBhf8w0kDCBQSByrJGBRUFxfgda07ouoSYQkqldt1GVqxOn4MY0+0/1pqWqF+ERO3Re8vzcBUGnhbw6JN/WCdW4hOCKlQ2xZNwDZwD8phvDPYkhyod7DogcL99waTM7TkXms5ARnVbqFl/HflPqEo0tZFhmDH83ivFAAv58gEyL5GrRKiH93RglB9ks+D//65oEmSXZfEvCgkn3RS3+olAa/R3hxrmdG9fgDQ3jn20U9VzRcKb0EH4kQBd7/EhUWMPTsC+rP/dm8ad6bViO69V6GlsG0IorXkBWS0VMccY3xa4SuqPzsgJPEwvD+DVR5zcASbvqfhtY
 OKz6B1bu
 ngs5VPsvwloEmXd/FFsqyPAnuNLcd8ddSwbzc5lNjJC09VpUoQbrD3a6lL0N86G0wpwqXSzPdf+BGSPQIsCQq6Xu4UoyX79JmZsPIkCttpoohFhZvrpraQM/8HlRkjbMr2SpSe+mgWNuji9WAeVjEorh5bEtT8YstQUfHbysyjPTeDF3wy7j5+1oWJaS6AZNZ16gsZYDQutTSQuR80eBNnIyoMLuPeWVD2Sow5hBUhUvm6hj81F4Xqc/RXSRmeDQgr7nk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Huang Ying <ying.huang@linux.alibaba.com> writes:

> This series is to optimize the system performance via avoiding TLBI
> broadcast if page is reused in the write protect fault handler.  More
> details of the background and the test results can be found in [2/2].
>
> Changelog:
>
> v4:
>
> - Collected Reviewed-by and Acked-by, Thanks Lorenzo, David, Ryan, and
>   Barry.
>
> v3:
>
> - Various code cleanup and improved design and document in [1/2],
>   Thanks Lorenzo and David's comments!
> - Fixed a typo and improved function interface in [2/2], Thanks Ryan's
>   comments!
>
> v2:
>
> - Various code cleanup in [1/2], Thanks David's comments!
> - Remove unnecessary __local_flush_tlb_page_nosync() in [2/2], Thanks Ryan's comments!
> - Add missing contpte processing, Thanks Rayn and Catalin's comments!
>
> Huang Ying (2):
>   mm: add spurious fault fixing support for huge pmd
>   arm64, tlbflush: don't TLBI broadcast if page reused in write fault
>
>  arch/arm64/include/asm/pgtable.h  | 14 ++++---
>  arch/arm64/include/asm/tlbflush.h | 56 ++++++++++++++++++++++++++++
>  arch/arm64/mm/contpte.c           |  3 +-
>  arch/arm64/mm/fault.c             |  2 +-
>  include/linux/huge_mm.h           |  2 +-
>  include/linux/pgtable.h           |  4 ++
>  mm/huge_memory.c                  | 33 ++++++++++------
>  mm/internal.h                     |  2 +-
>  mm/memory.c                       | 62 +++++++++++++++++++++++--------
>  9 files changed, 140 insertions(+), 38 deletions(-)

Hi, Catalin,

Do you have time to take a look at this series?  Are there some remain
issues?

---
Best Regards,
Huang, Ying

