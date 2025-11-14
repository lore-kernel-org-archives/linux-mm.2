Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B251CE7A8C
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 08:54:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE5D28E000F; Fri, 14 Nov 2025 03:54:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBD9D8E0002; Fri, 14 Nov 2025 03:54:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFBAE8E000F; Fri, 14 Nov 2025 03:54:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9EE108E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:54:28 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6257CC02B8
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:54:28 +0000 (UTC)
X-FDA: 84108601416.02.A6746D4
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf29.hostedemail.com (Postfix) with ESMTP id 89AAB120004
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:54:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=AjFSYPyR;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763110466; a=rsa-sha256;
	cv=none;
	b=d1sHfaWQ+xfyRPJGVSpUoecift02p7SMgk9180R18g2AAOTCXcsafO7ecI5+ihSbtO275O
	Wtpv3jX6tjaV2covAY8mggfsS7u1k5sM5Arjn192LsonKa27s0P/cIppyZvfmZj3zdhpY4
	tdpWFUGAB9SfdJgzk0OL0bFuJw8yuuQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=AjFSYPyR;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763110466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XyGOdB7idn1b8/brWtbuVsRu7Ehn6oDN9fwlNDOi6og=;
	b=Qw8zECVm6KmYj70UdaEk0ARDlWvRN8aVKrz6udTLjWmT8hbqYCs/Nb8YC8yJc6dR2C61ij
	Tx6Cn4WKzZq1TljCKikFgxpKXTYBqyWcyKLE4kKf4sL7sd4EoUax90Hc+njDkjwPdvwpwy
	nfkj78kSEFU0DFsGrb4A6yDI/eiFIJ4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763110461; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=XyGOdB7idn1b8/brWtbuVsRu7Ehn6oDN9fwlNDOi6og=;
	b=AjFSYPyR8snc88TfxJPgaJFJtoJ/gxUNK73/MeZBUVPG96WiVAR/GhHpQVubBnWo/vDZSp+22pJqAF3ifAYe+4EB3imPvMDgKm6fY5ldR2gqEJczVydzACqMiQX8APG9ArQtlD0dY/Yf4vSbfk+sekb1Jc5KIg8me82wBK+9PmU=
Received: from localhost.localdomain(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WsMaAYg_1763110455 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 14 Nov 2025 16:54:20 +0800
From: Huang Ying <ying.huang@linux.alibaba.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@linux.alibaba.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	"Christoph Lameter (Ampere)" <cl@gentwo.org>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Yin Fengwei <fengwei_yin@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH -v6 0/2] arm, tlbflush: avoid TLBI broadcast if page reused in write fault
Date: Fri, 14 Nov 2025 16:54:01 +0800
Message-Id: <20251114085403.101552-1-ying.huang@linux.alibaba.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 89AAB120004
X-Stat-Signature: ce1w1f3ssg547bnmu7zgnpib8jfmupy9
X-HE-Tag: 1763110465-688763
X-HE-Meta: U2FsdGVkX18bm23iUSwvi3271ZjjYrWSG8MyyDqw2vwJqpz5zNF2vv68d0cf8zwaK766n0hdX+f6nqp9buvkwPmZdQ6qX1ERNKSEtWnFN2YtFrd01DD7TLYbjoComJn8KTQf0fivlg8wSS8JInI//ZGga/uCOTZlbwT7YKBOAx/5S5QPkENU4nLfSkHzF6znOI6yxVwJPql4pSOOI4/8vDZQ/pDANLc9+8dfK3OhSdrSBvQhswnZou+qew0WVBv66cJsSaiFukx6xnp6Hmx30CdD0mGh/KlD6dLluwatTxAA2KHMvM62YDuWQkAuff/7WZbwu2LD2w2N2XX2Sq1LrDlEueqz2g9AQ1+5uxJenuisUfpWNSGTxuv2tWaobpGMqpY8l+N4BX+1kcKOwzUVM4HHttjIYh7Gy40RVvoln5fOWxsF7OblqQsyy/tsq/Yl3a2PYhpWiviBpRlKsxJZ7Cs8S1YqoFQ/pA4XarqW1L7/S0zwlwL2ZZ/6P+68GXca5SJ3wyyLJ8gQF4NhFQzaaBlhns1X6Z32Zc626jtV5gAaw+XDYrzJZ2FzUvETNtDoAMiZgYp2/cJs/YqsoxXBIOeuo/C6evKSW4RoBwi8PSQKCMFUxXU5zGXLwtSriHtLgUvtMRtmcGyrTsBBo5i7vkXz0yMpDMEERoda9SlK3PL58HT57A4PtBY9Uuh/z6oAh9jswL+tBszohvEdBdS86yNI6gzWeE1CHFN6UrHVLefb1BdVLhn6NjIfjKBYrQ1XoGvdQvAw9T7AztD50CUTJzZ3Y9p2UG5bKdeKY1bPCLLNMaUckXznnm2+jTOQ3wt7LKeYa6mrPXtJ/fYv1GdKoNORf5T5zL9pRbJ4/W4RteY3jHbcUCvHwaYKg54ixypC321zRoW2PiPZQbYJSBHRy7AnJa0m0wD0EQrTlYYYC8Sy6/R0/2xF4xVlBFdD02DosADMF1iSWrLCGPwgeyf
 0+fvwJH2
 mDMrTK7n4PeumNI83Jr4kp4gW/qqR6/g0blj8rnqf7DQN6IzQQ6wgwxPCewhQuXINWTNEznk8KMJbA34FnjO12rsQXmca9Gcd/CySHsw+9fjcm6pUUPIASexJTcjo2g/vQl4r4jZuLtf/hwqIVYTk0JeOHiva2qPtwETeUCIAy+gvye/Rz3cVzocB0N1xcN0SfFcEtQRondWnxMLg8W1ibqQ12zrUnT1qyKUFrJGX7S+gMRabf7xyfjf9HHmXL26keoYaxr4yfye2LKI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series is to optimize the system performance via avoiding TLBI
broadcast if page is reused in the write protect fault handler.  More
details of the background and the test results can be found in [2/2].

Changelog:

v6:

- Collect Acked-by, Thanks Zi!

v5:

- Code cleanup for [2/2], Thanks David's comments!

- Rebased on v6.18-rc5.

v4:

- Collected Reviewed-by and Acked-by, Thanks Lorenzo, David, Ryan, and
  Barry.

v3:

- Various code cleanup and improved design and document in [1/2],
  Thanks Lorenzo and David's comments!
- Fixed a typo and improved function interface in [2/2], Thanks Ryan's
  comments!

v2:

- Various code cleanup in [1/2], Thanks David's comments!
- Remove unnecessary __local_flush_tlb_page_nosync() in [2/2], Thanks Ryan's comments!
- Add missing contpte processing, Thanks Rayn and Catalin's comments!

Huang Ying (2):
  mm: add spurious fault fixing support for huge pmd
  arm64, tlbflush: don't TLBI broadcast if page reused in write fault

 arch/arm64/include/asm/pgtable.h  | 14 ++++---
 arch/arm64/include/asm/tlbflush.h | 56 ++++++++++++++++++++++++++++
 arch/arm64/mm/contpte.c           |  3 +-
 arch/arm64/mm/fault.c             |  8 +++-
 include/linux/huge_mm.h           |  2 +-
 include/linux/pgtable.h           |  4 ++
 mm/huge_memory.c                  | 33 ++++++++++------
 mm/internal.h                     |  2 +-
 mm/memory.c                       | 62 +++++++++++++++++++++++--------
 9 files changed, 145 insertions(+), 39 deletions(-)

Best Regards,
Huang, Ying

