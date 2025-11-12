Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8098DCCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 01:38:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 975C28E0007; Tue, 11 Nov 2025 20:38:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94DD38E0002; Tue, 11 Nov 2025 20:38:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88B2D8E0007; Tue, 11 Nov 2025 20:38:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7685B8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 20:38:53 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 268B713A037
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 01:38:53 +0000 (UTC)
X-FDA: 84100246146.09.5AB4F9D
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1723A100012
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 01:38:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=N9J5jyFb;
	spf=pass (imf14.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762911531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=F2jNYeDr5F6pCBPM7sUJqzwBw4ZiFroYQTaihiWqMoM=;
	b=yi/AcMJwVf7MSbyVWCANO9LkuEe5HnSHQDq5MWwbOX6fpXZFAYlYU9sZigEmGWd08cTCrw
	VPe0AUBBncaAGYCMzAazHUvTVXVpwW4UsefpWe4rpjWRiIqrrkkYJ7b+izvtus8JCCK2S/
	3SA84PHaG+punHX/nvg0/uEFq6AnVfY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=N9J5jyFb;
	spf=pass (imf14.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762911531; a=rsa-sha256;
	cv=none;
	b=b+fLiFqL2yl1ShPH1l+CCSlK28ze50VnowsvsYjzFZ3QSrUGaxakggt1to1xrwYXXMHx+S
	zhngbbKnPqMrjiAKYI0KKkrToiLUcgOExAhDAR46eDAmkNIa3oknCvgyMAfv10GAk0F3JM
	ALbj77xw5OUShft+cxWZsPOSNaCdMrM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1762911526; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=F2jNYeDr5F6pCBPM7sUJqzwBw4ZiFroYQTaihiWqMoM=;
	b=N9J5jyFbFrug4M6VXDdwirXoj57pjLsieWSUH0Z3a8p26X6sEZa0Em+ndB6UjGY/GjWomhC+NazF+vRacrlT7k8/eDdlAqAuVL/fPpcLs2AqlunS3/87JXcf5e1zUN6nFWfn2XNaIcaFlv+O81W+REz6HpiorH8IZNH9Fd8jTXA=
Received: from localhost.localdomain(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WsEIP-m_1762911513 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 12 Nov 2025 09:38:45 +0800
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
Subject: [PATCH -v5 0/2] arm, tlbflush: avoid TLBI broadcast if page reused in write fault
Date: Wed, 12 Nov 2025 09:38:20 +0800
Message-Id: <20251112013822.54334-1-ying.huang@linux.alibaba.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1723A100012
X-Stat-Signature: axcuq1fmpbw67iy3ztrisyszgtzgh5p5
X-Rspam-User: 
X-HE-Tag: 1762911529-165608
X-HE-Meta: U2FsdGVkX1+iS0OoMCDxgaAmYlAAzNmf/EyNxNUmWAJrb0uZJyqhn8MxpdIEBwlm7VaZC+oLD8W9CW3WoVXUDSfikApy1EnZ6KxRp86Qt4SS/W3P3nTMNPGXhnCz8jBYzlXppBV7dtVQ6/Y9DleO73frEHMOIQVkqL+iYCnqaMQ7gNJEIMCQ+qSoViu5bjQ4Ao2ThbgHGFL4jn64c3lkHvzmPPN3Buy8jvINAWrefKDoJ3w8F3CV/cn3COcjLXONn4LMX3LsLTweGVx9iNaR951IPNfDOb2c92qRGVXTw/HFRrWdIXiAOXsz5FmxTJIVlHGdeCmVUGRls9fa9+a3yVBPDff+TVX9thOMJVu4qfJwUMNQRpLKFshcZilVXASvoG8AD3iMp4vQBjKmADOkNKMHd+tLdYrhTEys9ZxGgdrlufPoVCCO+FX0bQ0esfdBb0iDJS3rd19tULFj/icBxy4IXB+DwtxBmu2+AT7SYMVeBqpK67CjYQVuAnLVndaopTTG4KHpKU7XZM9k1rMNc0tm22jSHBtow0J3luYpo5z5kZeQ37y7gp4/depyS4hPHnQ12bly3KiDz0q8qTmOacVjO1j49wCXgQHZSKiK/kShbs42CocIHOyrNB6TNUANeDlLrLVlXc4aHI2A0HSF6FXiNwzw7B27GvpiKB4EwriUl0GdiGWwR3uhcKlaV5SnhIk3LjfTxCk5bzDs+pHf7l9hh/xvz4XIZqaBnE5Yl7aaeflOcOHpQpymCMf6saxab/urQtFz+DjOfQLJ+jwielArosZSw16IBZ2TsZEmu6A73mZGrv52cB7/0f+CHpvBFBdTq/w9PAuN4HZXr+ZFBDEV38mHs/Me6yw920KqxYuW746xWmtN/Sc4ntL/S4hxnUkPAaKCYTyLBOZAhxgowr2cEBn02MMBQ4/d30Ny1NZ5JKWtS0EP1Tslxuo8aI+iftXxwFxUOizyeRa8Xrw
 kFwPgGng
 5UF4++5ShsBZeAvBh4djQbDJDK217sphAqiYZCyIsykal0rtAlA0h95WB84KSL+uIT3p/WxAslAzYG1rQ9zo2RDYM5z9QWyQeh68oUisrEyziJTDnsueXXpOSan8Ip0Vw5KGSJmzflFhNFgiKA9eDaq+8XMn5CvbPZKkp++3Nbt//Rd+zSSbOS/0zt3BJUtch2Ew++hFDhI1Qv/n6cNvBMyup9/MxTFDft1GcGTOLcjCFmC6oOMDY0VGTX3TocKcrGmnUYhemHqqh7OE=
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

v5:

- Code cleanup for [2/2], Thanks David's comments.

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

