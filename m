Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE5F1CCF9E9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 02:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF9368000F; Sun, 26 Oct 2025 22:03:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD0588000A; Sun, 26 Oct 2025 22:03:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0E348000F; Sun, 26 Oct 2025 22:03:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AE3C88000A
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 22:03:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5B5EA12A3D9
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 02:03:12 +0000 (UTC)
X-FDA: 84042246624.20.02081E9
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8C1A44000D
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 02:03:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nhKPw3BB;
	spf=pass (imf11.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761530590; a=rsa-sha256;
	cv=none;
	b=M5zjc2N7p6GEUVwktnUyaZaOlZslZlL+1ciMM5ZF1QFIin5Jr9S6EKYtl8HcoFNK6G0CLh
	Ei9dJ7hvJxVvN+16Op6WWormW3ksUj3JU0g2NSqdjfjS/uy9nEsHneTf6B+zvFUcIUrRKs
	lQdK2xxuAld2RAzjEhw7kcVmgs9uqSI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nhKPw3BB;
	spf=pass (imf11.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761530590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mx+VoEY0CT/CKfx1nDM5Jt1hgguzcel3vSopk965SuI=;
	b=komuA6mAPVBX72Ew4x24abG8qzSuX3H7sRdfoqbrCeDfmowhDAwgQqC+2FRv/QuG2WzeWZ
	ryQxOo0XYncDw3EuN8+mSQmcbhJcsGvapRICsm5MAZEf0IQaKo5103Cf7E0OV39bHk3jbQ
	66dU7dCEJApI7dNCVVEhBy8fv+eIpys=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761530586; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=mx+VoEY0CT/CKfx1nDM5Jt1hgguzcel3vSopk965SuI=;
	b=nhKPw3BBHwGISurGxwZiowwYw0ZzMIplqhfKtTecUWxRZcof6V3ukmaHnoyVa4qePMjTqQklydHgVI1QjQTTOAtD0k116dUoBAA/4/66DSJjfL1dx2RTeUMafZ+x0oMw/KWLYtKZwGS0k4P+e71P4TUtEbBzylISUt5geajHw+w=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0Wr-dZdy_1761530575 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 27 Oct 2025 10:03:04 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,  Catalin Marinas
 <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>,  David Hildenbrand <david@redhat.com>,
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
Subject: Re: [PATCH -v3 0/2] arm, tlbflush: avoid TLBI broadcast if page
 reused in write fault
In-Reply-To: <20251023013524.100517-1-ying.huang@linux.alibaba.com> (Huang
	Ying's message of "Thu, 23 Oct 2025 09:35:22 +0800")
References: <20251023013524.100517-1-ying.huang@linux.alibaba.com>
Date: Mon, 27 Oct 2025 10:02:54 +0800
Message-ID: <87cy69hzjl.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Stat-Signature: qcj8rhk1deq5agqwaostpyzupppzua3n
X-Rspamd-Queue-Id: 8C1A44000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1761530589-980172
X-HE-Meta: U2FsdGVkX1/bfHN0QJ7uvTcXfrFTjUDnYjvbX9y6l/AqI9zAPgVM26ThyD9JK0kzJnjbJY8bW5BoQo7cJP/BT3ZNQUMPNjtQ68stHTW9VT9eMP3q19DfqAwgArpzXMurEZqf/uZBlf8rF6gc6NtlJHazo9l23+8S8Unm8YyZYCdPS5daaHpS4sFrydKAHcZep08CWNrHHJxRsZtUAtpTDeFq+R+2gEKN/siyAd4WdtG0d+KTByEC81HNxgAh0eux6nFfs5h8kJ3pV774hdNDY+9UbhoA3jh8ZopuHKZbcusH1HS//iefvWR/tZqxOcYNUVlWzpTWrU4gqbgR6i67GM1bEu/gOYC+qeqPdgmP/7yIQ3IEzrbEZRGAqmLukJzkj1bC40zuwwtBhpbaUYA8wSLdL8HTXNv2ZOxyW6MxEe8jf2ibeXPoxZk1LJcgkTTEXCS6s+O3HiTQD0wzKMIJYD/2l7RukmDogR+urWW5GKjNHwWikn4zTLqm3ARt/mDIbEGavuX/6pIoKO3QTTGTEIROpGZYmfWJ2+yBG4wGZf77V1IwJO1CtcC426xgXt0ANQUSXSWePOOuRtSi6hv+PRdubqHUkzU/m0NWUbEbX96xSBqDuW24hyPNvfGWBPvDl2/sLBj7emEIpYkll8v5gS8AXxZmDctQfMPbf8JewmD1QQXVbDLiUR9cbVq15DmflMxYQmneZzwqwPaxWkpDg1Xo0n3mGjRgw6J024i6XTkfVSzY1Bi5PFd46va65zZJ5IPOQ6y9JE8xx1zVOWTKdJYiKrflNmT8S1DRgXu1tJJHOjbzyhF66DOf7G6WzZIXzhnEeylFBtvYBaySDjWFWgpZI2IPAJ4Kf7fGifVTuxetyNIXLWtvaOrwclSzz/Vynb9anqoTa4JXbk5IrUAqlVfcPi2D+J5ujD0yg3RPDWZnPttjktJVGcVFM34U+TCc0LRUV4ND6hx2CQHDMxu
 lBIhri8A
 6oMGilsPQxvJObfWdZf1gJzIVhciWAJHT7TnDG14OoJJ+PocgwbqvCbu/Th53Bxm+kXuxYTmThen1k19Z2W3JzbfFDBz6kQ3R9WzWx9qkck56lakBoaiZgaCKHRhuylOn2tP8CWtJ5M1qZ9S/Q2LdAQym0Qo93sSgljYUBKNjIGJh5DuGjWGjLnQRbkvTmoh7VQDj8TOETnwn7CBWQ4ZqInI94nix5D1SX+p1c4D9fMNwlEVpPPrgaKAsS523x/mlUGfg
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

Hi, Andrew and Catalin,

This patchset needs to be merged across trees.  [1/2] is a mm change,
[2/2] is an arm64 change, and [2/2] depends on [1/2].  Because the
user-visible change is in arm64, I think it may be slightly better to
merge the patchset through the arm64 tree.  The opposite way works for
me too.  If you were OK with the patchset itself, which way do you
prefer?

---
Best Regards,
Huang, Ying

