Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D53E7C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 19:40:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77EB16B009D; Thu, 20 Aug 2026 15:40:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 755DE6B00AF; Thu, 20 Aug 2026 15:40:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66C7C6B00B0; Thu, 20 Aug 2026 15:40:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 437F16B009D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 15:40:40 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BCD48140189
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:40:39 +0000 (UTC)
X-FDA: 85122664998.30.ED76FD7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id B590340004
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:40:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OIs7PUjl;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787254838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7raBRUfdemgPsYgo8SBrmAB+p4pQirfBqXtOn4YlokA=;
	b=GvE51wjAAOPHkCQeDJNQ7fomGR5teAI1k2p2d2mZv1upAWp98f7v/NiiEGq5nJCQbh8ttg
	WwMUpo3SGoHl9QQlSrioEMi0ZgXpXykteupSQT/+ZxXiHbf/2vZQGmIgblm7LUecPnlFUO
	kVDCNcL01LHmTEsVMvUV/YsFn9GvRP0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OIs7PUjl;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787254838;
	b=WUt2i5UStyt00M6J8aJmyo+7Txvd/0iL4Frq3o9wtZK8WLYhLRRf+Gi3nd5x2kz7SqCi6Y
	lHIc9QeEd4I2V57zRn7sreUWRVnoJtS6NPYc/xQw49Gp5BsWEpRqyD/TR5HLGpICBQQc6a
	rhqgXni9ts0WcNFB7IqdqylMVjUPXOg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 94FBC202C;
	Thu, 20 Aug 2026 12:40:32 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DFB3E3F763;
	Thu, 20 Aug 2026 12:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787254836; bh=7pjEAmcXmpKnIzyuI0Xt2csvEi1hxzh7Ykp3uUVDmPM=;
	h=From:Subject:Date:To:Cc:From;
	b=OIs7PUjlgsvSxEm+4KOPIhXSUEtqz+Dveg3IA6WSTrV09DJzBRAmSh2p2jYzEhnwi
	 ZHbtmhs10iUTaB4haVYZ/hbio7uyPa763254zj4Ui0JB3dxvFix8/Lmjh5Ue/O1sMo
	 hpc/QnbTR2C0OWNI8H9BDVZZJi2DVUgYwEFooaH4=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH 0/2] kselftest: mm: fix some failure of
 split_huge_page_test
Date: Thu, 20 Aug 2026 20:40:14 +0100
Message-Id: <20260820-fix_split-v1-0-ab430c58c7cf@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAB5Yh2oC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDCyMD3bTMivjigpzMEt00ExNLY8vUZBOTJAsloPqColSgJNis6NjaWgB
 DAyKQWwAAAA==
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1755; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=7pjEAmcXmpKnIzyuI0Xt2csvEi1hxzh7Ykp3uUVDmPM=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqh1gwm/jKRe0lLHpiBKW9B83UVm1ikv0xur6vY
 zN6/CFlkFqJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCaodYMAAKCRBt1cPRWsUx
 M27iC/44KXI87DFCucVPVj7t0kMHHMnV1u1Ador5n0t/pcbAdBlu4sxJ4lxoytEylySpm7nFeRr
 Fe/qAcPr18DBZt530yAXyQqO/iQ9mAs66y0zhYhY+GMPaa/qvKBVjbMfkUgONkn/dz2F5DXvoiq
 Jh1gQq0TcAJkeKZpGSheCauvaGJO0PAIv7Pdzr41qvyATk9zMWxb8ndjmfM3UKMOw3H2wdJChGq
 ktET/ddQXL36nihkEwmzwUHnyGGSv/j7jnSqeaIyG35YbCb4D1TlYZi4o8P28DW4nfPA/EYxlzw
 vJp4hdRGPzmpVYhlVE76m/AKKaj4PxexIDSGovO2SBfVa1rmFJLdCk7Ikcbm4mOaC+iIt+3xKhU
 6L7nJWLeaev20itWCB0ZZK7/vWbGlxIYFgRxzp+0ijbooqaMTBQnHODW/T/0mNqryXXWOPfGf9f
 yG+bI94CnXx2g7jTJgrfXKcqcnOYyl8QKiNRWPwu8aevgxkTd+YoeoIoehEaeSmiu1IQs=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Queue-Id: B590340004
X-Stat-Signature: t1m9rncs1sesjan7i4rzdpmt4sfdwuzm
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787254837-312627
X-HE-Meta: U2FsdGVkX1+dljiXZ9otrDWBF42fvA61nqy9V3aA9cNux0davEdrXmgzV5+RX8g68HtwZdQylXQK4P+HLMlYMBO08gt6VnE61LuBNQ6Z00ZWE8qSWVnW6C0tIG9CFvzk9SmpzgpwpXbS/IkcQ/rO8Crg5J280FCuQvU2v99K+qdQw7OdqPc/ZY3Fv8BZJ5aioi5X6YLWJ5DUu44Y6e0R8Poj60yaqMQ92U73wEPMRDiD44s6q74Y7Jb3+KMmhWzQQUuV25CO7T8os/PiFqfNibgKG+bKuHzJCIuxswKSm29NDi5IKwH7BjKHdtBk17tLLqHiJDMmxH4sxi+lI+Xumylvn0bQ5OLQ4Ymx0oSryOPdPGykOiK1ie+vx4daHtj4UgDX6ZILOg2xDh75L/PWjfHWK+yHPSwgy4VrWHw8mnomz2v/n4Aih7qO78sR36p4dUNB3yOFg8Iig90ro+Fnzg9D7c/EYzA9yuOryCJCQfltk4oWUVbcdM8ssfNwm6Us+iB+wvP2IatsiZUzMC4thtzPtKVHmfIECcwrD80yK7S+usgUY3QelavIhTH8OMvoSYMLoZKZ8u39b1RqvR8eC9rF655McdTLsRHYu6d9LCtWLnarniqLSPEshjhBTFEjTgSMZG0H0CKOPQds3do8sN1peeqllGRB2Jo1BF4h+tF9CJuVG+XFTPCQ5YHYp+dPp6rCaXV2x/L4lABa+DuQElfnX0ekZUC9vXFcd2ilHHJyzpjxwrHMNLfoh9EzZrt3iP7xK5jkqC24Myvh81FvUycJsdo2vMDWDloRP0oGCZaFGhqqQyY0lVxxoJEHm8X6jnCiK0Q/mU/ThUiw3e8HrgZJDbv6nylGJpJD1ebU7dyWycM7eHjtDc6xHsF2x9eXaMUC3P17QbYtiHhT9IihQ0ifPv5ICLZGfbrYZXCNPu6a+7VwDiTWRCkHY9G6VFSyU5tL/FB4xLEgOCzEhMO
 DWcM+Go2
 00e7rRqZHHZzr1k1uxURw7JDALv3Oi2ISnn5RSFPD8tqkPgmPCRNLclURQaw1HG7i9BLODiLNHyxk3yFjsW9dGxyozqZAovti6xrhwoNURPe8hKevl9R2TPF3MnHxXp6g9tKfeQO7CzMhP78qaZSWhulrOijIxmtLVACrnLjZauI55KV+Mh7weK1tdZuVHkXqBiNw+9B4bi2+APGdACj6fUh5u4qMeL2Mi1m5Je0MdY7tb4gbwRaPHuDb074V62Z/5cL5418fggKYYR4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

split_huge_page_test can fail for the following reasons:

  1. During the test, khugepaged may collapse previously split pages again,
     causing intermittent failures.

  2. Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
     glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
     made by memalign(). The underlying VMA may start at a different address
     from the aligned address returned by memalign(). Moreover, a subsequent
     madvise(MADV_HUGEPAGE) call does not split the VMA because it already
     has the same advice.

     This causes the test to fail because the check_huge_xxx() helpers
     incorrectly require the address returned by memalign() to match the
     VMA start address reported in /proc/self/smaps.

Address these issues by applying MADV_NOHUGEPAGE after faulting in the
huge page, preventing khugepaged from collapsing it again, and by replacing
the use of /proc/self/smaps in the check_huge_xxx() helpers with
/proc/self/pagemap and /proc/kpageflags.

This patch based on v7.2

---
Yeoreum Yun (2):
      kselftest: mm: prevent random failure of huge page split for khugepaged
      kselftest: mm: replace usage of /proc/self/smaps for check_huge_xxx() helper

 tools/testing/selftests/mm/khugepaged.c           |  26 ++---
 tools/testing/selftests/mm/split_huge_page_test.c |  17 ++-
 tools/testing/selftests/mm/vm_util.c              | 135 ++++++++++++++++++----
 tools/testing/selftests/mm/vm_util.h              |   1 +
 4 files changed, 142 insertions(+), 37 deletions(-)
---
base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
change-id: 20260820-fix_split-f44939ec44b8

Best regards,
-- 
Sincerely,
Yeoreum Yun


