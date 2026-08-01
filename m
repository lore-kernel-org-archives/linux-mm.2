Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96989C54FCD
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 06:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4770D6B007B; Sat,  1 Aug 2026 02:26:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 400D86B0088; Sat,  1 Aug 2026 02:26:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EF506B008A; Sat,  1 Aug 2026 02:26:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EED986B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 02:26:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 628761C0304
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 06:26:57 +0000 (UTC)
X-FDA: 85051717674.04.E058B95
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3541480008
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 06:26:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=owBhPUJe;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785565616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=43CpQuIZFpLERACn4hBgOkuuWdTC9VrCr63pEmkphlc=;
	b=5m2qJQR2im3l+0CZ5mqc6IG2puunNQF/SfBE98sZQfOBqmmorioF9yZmW7qci9rt/ADynr
	tNEaqTUzI+jZktTTwo9qM7cqBfOQzQCfaDeTSKgjhAMtEL8hQExVe+5aVi8Z9UrR/kZBkd
	qc+/YDt2y1R33aAcMhjsFnFP0nN2ZqM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785565616;
	b=KhnXSHHPCS6l3WWx6BdQzkAISZ50GqRergaU89OTfUdDerKbss+cYdCnh1F6SA0KPGVznC
	WnpYxDFfqXQAE73c3gJ467AYZ5SP7Nnj5vf77XfBZrfTZv1kBv716XocUwESACIVE0HaiC
	qGAFMuUEJWBDxhsDVjWAEsgA13RcahY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=owBhPUJe;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785565610; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=43CpQuIZFpLERACn4hBgOkuuWdTC9VrCr63pEmkphlc=;
	b=owBhPUJeVakxkGj6XdgCiOGUm5apTyQFjkZjIUWGYYfrXMXso8aXBwI/ANZMSSAZxusju28V2YqTj4U5s6NcInYDs8t0/qJivnLo8YKsccGCMxyXgPNXaTVxOQKyf5NL1C4FRFnKWyzC7DQTC/fGAuEy+kiP5lVoB2P45bdrXrc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X89cw7d_1785565608;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X89cw7d_1785565608 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 01 Aug 2026 14:26:49 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: ziy@nvidia.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] add anon mTHP collapse test cases
Date: Sat,  1 Aug 2026 14:26:34 +0800
Message-ID: <cover.1785564857.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3541480008
X-Stat-Signature: qn6e5hsfqjzgskuq46pjkqd8myjgciar
X-Rspam-User: 
X-HE-Tag: 1785565612-665386
X-HE-Meta: U2FsdGVkX1+Psj45pq6aWq1yxkjqxmZ8xjby9IdixI5CHUa70A/s4xtSgJtxtYaTw8XoIWKct+scv82RP2bi9BgaqAFnT18Te3Tb0RM6eR56u5RDA5aKW+HDcliyYOws3w5u1Nt1m4QiOVD5GrrowqaBSPkQJRvB44xVXKou8IZytfWjfpExO0MuU917oPi81GGuKDnGxm1LxI1tedOZwTxNXHloXLkiNa3Lngy8KC2vk/nYHEkGa1w7ww2/mAJ0o98IhqhCsfcQwa6R11fUpobNuyo0lt6QGgmCzrBgW/GIoTyA3y29ObiRx5LIbEtzGDTZwdd9Ai+yBwK2xnPeFz60fPs+OoxwkX4LjvHwM/ZmJPJbFF3qL9zafX5adzfXl+bnQCA9Nq8eshEHuNF9i3koKAPDBFSdJW86n7oQgV386QGbRIOIBeOfRnpQp5AIflwsc2a8juSWemJgiEBbgKmItRtexQg1a/8NbJfH51rWT1aJgX/CrAz8nq2QzLrZILW1flMa39jRe/5UuTmVBEiKpnNMF/uPMyyuXukSYxQzZfwLa2S3YypteB5Dp/4ZIpBMjSlTUpntien0k7OifYsmeIfJjDFuge+0q+CSe6wYpwXiCLq6vkQVHV/HYzbSDDivDhiQ6aXiPWX3QrjJIY34mvhFnMxOHEvWwGBQnDwceyWz8zpk3Vxv/jkbSA5q8S/fYyfoEdJ8OY6CBBcF4Fwis0TjT8TtHIeDSZFnDQKDzdetAe87FHQI8RResrGAn+79KgP9TvOO+iyh0Vs+bn74x9HNN3TnwzQJBQr15/fUV87qSvjuAWcwZL3TwCEfPClY+aXpvR0ku2koNZ1j2CbNpxOqnFEiCwlupS2BzMHlxxJTF8OBA5Bo+JWULkcUD+VXJPVV/6wWDpo93vjNO2mgd7Z79JYrSmDV889TtGEm4hpCzYuThFSD03arpbyjfu5D3HW6i2SDHvX728u
 OmtVYikU
 YYSZI96vUnoX/b3qSQy5rWiZURol/Qua7mNlKVpWF0ddIsNzsX+oKKm+rn2cg8t5XZjN82/5wBKUVQhVnDyPiSJDnXZ/C9x8Scp1wWswIXwx7tXK0BY1soCQbKlvQlX+alXZquKzE5m73pZgPMc6VTBX/se/SzJCyNGleFphfGEsaJ0ClVbCglzzENUXBRPR+rJLi0GcTK7/p/2undV6oVRuQcOKLlGYns1B5kOXLVn/YMmnojF2Ax8YjmH2yYELUcgURls1XkcTTU5iyd/kcasthSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset is split from the previous shmem mTHP collapse patchset[1],
which only adds anon mTHP collapse selftests. All khugepaged test cases
can pass.

[1] https://lore.kernel.org/all/cover.1781083630.git.baolin.wang@linux.alibaba.com/

Changes from v1:
- Add order and hpage_size check (per Sashiko).
- Change to use THP_MADVISE for mTHP collapse (per Sashiko).

Baolin Wang (4):
  selftests: mm: extend the check_huge() to support mTHP check
  selftests: mm: move gather_after_split_folio_orders() into vm_util.c
    file
  selftests: mm: implement the mTHP-sized hugepage check helpers
  selftests: mm: add mTHP collapse test cases

 .../selftests/mm/folio_split_race_test.c      |   2 +-
 tools/testing/selftests/mm/khugepaged.c       | 190 +++++++++++++-----
 tools/testing/selftests/mm/pagemap_ioctl.c    |   2 +-
 .../testing/selftests/mm/prctl_thp_disable.c  |   2 +-
 tools/testing/selftests/mm/run_vmtests.sh     |   2 +
 tools/testing/selftests/mm/soft-dirty.c       |   2 +-
 .../selftests/mm/split_huge_page_test.c       | 139 +------------
 tools/testing/selftests/mm/uffd-common.c      |   4 +-
 tools/testing/selftests/mm/vm_util.c          | 185 ++++++++++++++++-
 tools/testing/selftests/mm/vm_util.h          |   8 +-
 10 files changed, 344 insertions(+), 192 deletions(-)

-- 
2.47.3


