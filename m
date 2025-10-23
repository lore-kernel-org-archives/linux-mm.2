Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2897DCCD1AB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 01:35:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5566A8E000B; Wed, 22 Oct 2025 21:35:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 504F08E001D; Wed, 22 Oct 2025 21:35:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41A6D8E0021; Wed, 22 Oct 2025 21:35:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2E0548E0003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:35:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C9048BC52D
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:35:56 +0000 (UTC)
X-FDA: 84027662712.30.1C718E1
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf08.hostedemail.com (Postfix) with ESMTP id 84A9F160007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:35:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MTWt++jc;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761183355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Brz/1d/5e1prPBNasD9kS+bWyfr9ZaOpRkHybD/Zb1o=;
	b=Z1pWGo9DLxnJcSLpu3V6xeVzyTYmhwTbrLq5tpsv58asL00YdbEsETH9aaXHv2zZpO7435
	zDeKnjvsEj0972ekVCYN6+0l60LSPiH1Gqz9+ThEXkNetlagzzbxVKWTZFbl7y9BRjXtzE
	KvB0hCBkNYBQfRbtuWlIAJwg7nx2m4o=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MTWt++jc;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf08.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761183355; a=rsa-sha256;
	cv=none;
	b=Qu8GzYqEa+5OzMLHqvN6vbLphHhOVjlm8nrVxunditvFlp7VJ0QeBwKalfa+Td3e9rJcOH
	z6MHCgH+KXMqpq8cfxm1VpOmDtiLkcl97MqJb9tmugURse6zKT1BSU4+ZPLhnT4dVsUscG
	DGtXrNDdYY++Ls8VT4OfT1rrzRWXFGw=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761183351; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=Brz/1d/5e1prPBNasD9kS+bWyfr9ZaOpRkHybD/Zb1o=;
	b=MTWt++jcz69iJaR/85Kwie21VQWVO2eOSXMXhwTLEqDBIECzCbl2jD1nOeIOJoD7x/AMtwbLDnfK1j5xzkbT511bjyE+LgXh6lfh+PZHm5nooYic/1oQZVR4jUTm872AflLiL3MSfhFPTTHkHIVpr3D3T+J4fvrAI3GQkdgtTwY=
Received: from localhost.localdomain(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WqogSeW_1761183336 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 23 Oct 2025 09:35:49 +0800
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
Subject: [PATCH -v3 0/2] arm, tlbflush: avoid TLBI broadcast if page reused in write fault
Date: Thu, 23 Oct 2025 09:35:22 +0800
Message-Id: <20251023013524.100517-1-ying.huang@linux.alibaba.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 84A9F160007
X-Rspamd-Server: rspam03
X-Stat-Signature: oocdc1cn5iox3wjxoss97uuacq3hfuq5
X-HE-Tag: 1761183354-429751
X-HE-Meta: U2FsdGVkX1/3I+6iezU0LDT5JA7Mh1qdQoL7YUo19GHkCi546Yhh3fC6QzcRDFSnm77UBKPwf3SnHcsvJercbi5nmivOq7pMVH4+yUlglRw+4mE7A7IxYoV34y8SMOI5+qgyRoMj6ihCtt8TLIeiOZsB7/w6LDXL3XvyAxlYTkNdGrNzBwnbZ7tWy5n9ZpdO0m7iWVvv2EMR5D7CyR5R0pdhAhjBAmcNWk4/bHeeBIk8lAYf/4vZ6BiQxc0wuLwFoj00yz3pfZxFOGoonvqifxT9/35CWW9JdK1cli1mIbGeX7Z/ixwUOk0aYesYjRJJN/Ib9lIDd3T1LK5zAPXLMSMbMkrdJE9i04ToxQdHEJBcmnTbbUTBNLxiynYwZb7TA52hC2VvokCm3B1Ejon3LOYqx3vgCSir2iZDMefVh59sQno7ys3Gxyya8VxpBTtfR0Sq3YKQweAz7zGatfzTIL758Y5FZh8ocIlhedSpDvBLCkXqoyjekUFUAlB67DrIOcGGCdBnDdM4rPQXZPAb7IhHBmmUJABLwTN0F4c/XzQt/f4ZGMEB6fcFN0fLrt6eFVmXUxnJn9pZyntdd/91Yci9lIV/wGXJqT7z30P6AqbacOeTcIbcgr2ktDcqb9aXCSPtnBbT6JFHINHFDDJNSnProyFUQb9cUgdlhhPgJxBJRK8PQ8doUSTHo0iqzQ04qfVT4RnYsu8fFECzp2wWjoe+Kxn1BA/rNgIqqCBuprdCkrcxeYOnk6eXypC0yw5ZGNZ7zGiuPbQTQEG3pp1G9kr9Mbvz2JOf2+Nl5dxhg/MmcFJ45svL7kHoFa3EKtb85NBuA7WQRY6dsU1UeK8EcDLa0h6cut7eDIUi2tulkQLPIcmi2fuOuFJBwiwJZieP5hQ8maPGWnz7pmvlYD9ISLQRfaTjlic9WlO2nOXQDGaD5NWSbP3Jgut9Z9xZg8jrbd4m2q6roWwiADFoYUh
 bCLKHqIc
 FymN2xXNEDqAJodcpWkrjGp8S/J5VSHHo57Pw069KlQA3mkVIAZ1yBZVKkQrHPNplzWL2OTdYR5RXbaj7mpHrSV21rF6stQXaLKHWK8veSkr+9JqwE9HTIFdj4PHJfxVBSoAc/B01n7i5kkcoYtGVcuTBWhErhAnJDSs5SebGkXBqraL1ROx+uiZLEMlz+4K79saPmSTBPWFYqJllFxRw4BRjCxFQzTM0YpqPKKuYyWCItEpedc6k4IcXDKC8OSINFGlZfbOXbYkTiJo=
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

