Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B936CCFA00
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:56:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A12A08E0126; Tue,  4 Nov 2025 04:55:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C26A8E0124; Tue,  4 Nov 2025 04:55:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CB138E0126; Tue,  4 Nov 2025 04:55:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 47A6D8E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:55:59 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D780A1A0452
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:55:58 +0000 (UTC)
X-FDA: 84072468396.23.418EED8
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf25.hostedemail.com (Postfix) with ESMTP id 50A1FA0003
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:55:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=QCtzdVGV;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762250157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SSHTx/aJBXe4tPj8g9UK0qKsO7sI9oG/c72UXbykh98=;
	b=7W9VLTqfCZ4LTnQRlc3pUuubl2DCsholUmm1HD5qNsG3cMyTtGN44w+eFwJIFl2fBUMEzq
	mzvebLyKF0VvwP9tnp2l5YPo5u46QUNFh9KWg7vjSQWe5t+GT2hGZ4AlDZLpvCkVG2DUJ5
	u01L81TBaKcrtcLdJzVlt5MIJe+mvsc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762250157; a=rsa-sha256;
	cv=none;
	b=Mu3SBj0apsXqISXoVyJM43eaipgYPxEC2S/pNTbyKu3ArO/eG3SZjQ7vv0Pc0riavSUVSz
	CXOWuTtIsLc2tpXDcvXCrryTwANC+ABOpgNY/EeA89AFKqjSMCXdIhyuAuBkrtME6AksN/
	Qr+P1wUXZVWdrWucHw+7ryYQHSypcsk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=QCtzdVGV;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1762250153; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=SSHTx/aJBXe4tPj8g9UK0qKsO7sI9oG/c72UXbykh98=;
	b=QCtzdVGVtJtImm5fGdT/X/tDXnr2tI9KA4sUh8y+wrL1spzZLoULsr+EgYa+lGAhygQiIJ2DVDnFUYWprwfX4nmX5roC9r4V50BkLV34t5AEh2UBqTppJAVorjSVrBp9Wm4RBT6Rduc1gbYnAd5PLzUnVQvjDB3YUtTvcNRxjno=
Received: from localhost.localdomain(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WrgsU.O_1762250129 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 04 Nov 2025 17:55:50 +0800
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
Subject: [PATCH -v4 0/2] arm, tlbflush: avoid TLBI broadcast if page reused in write fault
Date: Tue,  4 Nov 2025 17:55:14 +0800
Message-Id: <20251104095516.7912-1-ying.huang@linux.alibaba.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6fqu1petbjw5e1mnhptohoy6u646rdb8
X-Rspam-User: 
X-Rspamd-Queue-Id: 50A1FA0003
X-Rspamd-Server: rspam10
X-HE-Tag: 1762250155-22100
X-HE-Meta: U2FsdGVkX1/n2/ADYC1OS794wXOS8IApdBtabuT9jx8n3WsQlquL1yLo6a5rHyrdgA0FTILs4HxViUD83pBLYaEIszvf272N6lgVO6w7HPFcJ0Eq71MXgQyl9ZGMhkkxtT5CreKqopB8fcEHhvZ3MlvN/kzUISvzS+p9qdB+ueXc9A8YWNImh5OTbm+aHU+V71YtZcml0Ffp08tJYbn5L5czqvH3bt0y35vIvaDq+Z8siOlb9gPU/ac+i+hvrunbwpGDDCcmVEDbWYgF3MxNYXz+hVZ5zB+FKBi5oDiJbLF5yCTSfLuZupCFyC9Ci0q+qgYECEsyLYpPpbRgG7MTVqtycQIq1M+dcwtIDrLSBexePIs5T+XXLpiTcwK1etwZxWuI9IWEakHtq77+U/xQ4ah//N9EuJhV4rFMkpJQeZi8rGcir1zaXw8QAKv62we96hxIPStaRvJTBRy2SppBYAZUYp4NPRaqfZtbksw0T/eYdRV7aZXJRJBpzJuAoLvrsiLJN2AlMKMMiLpDL8YVcIR3AbMSWQ/rCngO+fxcyt4TS8crSjIwjt+HJL+CNy/RcBIhngmLLIp3adH0LvA+dFAzohjgk782L89K/x3126Dm4FDERDaNJnbQjlyEzkPSvOp/f944ghdrjj0T+ZJWDoh8xx7CKhHCgep4qxklOpJVxUlNieSsy4QWZMdTAkvanYMR6wuuHgb8t44bd3Y22aFoPBi/6W6e1bB5i6Rii7/xLhUm3p203pH0bzYLjPukGPTRbOYdD3U0HYsDhOxrUTrO+3qZ/I42wEeHZIOhWm43SFurGKAoQ5CeP0Uq1A9DkF7QVnZckP+eJ4XqTYNHDXANgU40JnpUmxoGBBj55LrJrCcda9tTa+YjvMzumDwb0FoFfizfsyyvk87A5vzzvYmkhGsZDYoym4PwB13N6MYOAjVytDIVZvREykiVbRLj4zz55FMmZTlIdYjUv64
 /UECZsSD
 1cR7QVH/PpJUbf+dFjtBOIJ3PWMfFMn2pMmGGOTd0hgT0zVD0nXV/aYuTGKpbxxs2LBRDiy7iY4717T+DLzjelLBCZZ9SGZGT9BFKhrNBSI3/yp/ZwcjzQngbBkYIqkQ880oQLxbtYp4DdAyTUQWIPRXWfw//0DctIwNHRrBVROet9sSRIxO7X2saeIwdzmhbNTqsa1ipCcuHqS9LrxQ2cchjIxpfj5UGAizBdst1MZxYuxRKEBZ2stKzO12CrzKTGuLzajATJhOU78Q=
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
 arch/arm64/mm/fault.c             |  2 +-
 include/linux/huge_mm.h           |  2 +-
 include/linux/pgtable.h           |  4 ++
 mm/huge_memory.c                  | 33 ++++++++++------
 mm/internal.h                     |  2 +-
 mm/memory.c                       | 62 +++++++++++++++++++++++--------
 9 files changed, 140 insertions(+), 38 deletions(-)

Best Regards,
Huang, Ying

