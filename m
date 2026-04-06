Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60360F46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:21:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7F5A6B00E1; Mon,  6 Apr 2026 10:21:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5CBC6B00E3; Mon,  6 Apr 2026 10:21:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6C836B00E4; Mon,  6 Apr 2026 10:21:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A60B96B00E1
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:21:34 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6A201E0FD7
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:21:34 +0000 (UTC)
X-FDA: 84628344108.16.E12C880
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id D19C6180010
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:21:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TAdJCPE9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485292; a=rsa-sha256;
	cv=none;
	b=RE5zKCucTaUvHIz/in4uFsy38+lHtUZz9Uwu4cPa5iYqy9fS3SB3kXzmtauU6e8K/7eZQJ
	0Y7zhTDDevOVgy2illdfVFKIEYPPrTYJzal75tUHNO+/tWA+VjwTmdZddQUG5gfefjtl09
	Au/YSlaeZaGFGWHFl7agYNmkR5RsEeU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TAdJCPE9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EaR8yeTCKZs02E0BVkQWSjQGL8ahxPBCta8dW4kYNk8=;
	b=3DjpnAlHmL8r8JZbynsBTk//vxbmrhthmAbaiIVFgGaW26RLFNufHOc7/RdmqZMHoFAWDP
	SpH+ZuNRe4JByV6Bfy3vDsya7WsTaUVSWfjOf41sgT7HhDGWCEV7XEe6UxEBugp/Bg0cus
	AZ2Xcu2pklNfWaSW8ZkNzuQcv805BrU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 576AA60123;
	Mon,  6 Apr 2026 14:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13EFC2BCB2;
	Mon,  6 Apr 2026 14:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485292;
	bh=53qqY7PQB/uAj+zPP1JxuvnMAG3AtCcj7DDDSb0K5uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TAdJCPE9O8ff2Xunk0iUh1hSJscOC/eHqdSPiWd7BoHpI6bwE61qLpf+8pUD36Skt
	 /oYHytW5tcFZ/DpIjaukljiuLAmI1Wg/ugS7TFYC1FpaKXBrLlBxN1e8Ct0uPMh6GR
	 lrvCUkD88cJ0NNMaT32kx7gYtTvXQ7NOUY3KXVMI/Dv/SFuf7DKY+f+s5KHj+morqF
	 8WKx4mzVHDOmhH55hMB4XTI65CsYhAQRbz46OHqvJGZ7dPYxqhp04NjeMRjCYVSyKU
	 +7hcuINHOe674eEUMlXR+ewBIfct/CTF3w2OvQErftx8uuNzo9watAoW/TOfeUs31M
	 IKeXmLQ582D9w==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 39/53] selftests/mm: hugetlb-mremap: add setup of HugeTLB pages
Date: Mon,  6 Apr 2026 17:17:21 +0300
Message-ID: <20260406141735.2179309-40-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ug4rzitk7t3as1xgfaftrki1jt19e5um
X-Rspamd-Queue-Id: D19C6180010
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775485292-283991
X-HE-Meta: U2FsdGVkX18ELz4LFHkzXGzNr/x4CaBYQN4GDimG95hV0OgVSwujOFhQdXuk0rJzTPHna6IK5s9RiECrNN2gjdBVmIzZWVaYwMoBjfW5i0D/ArQ4lx742K718g9BRtFDgt0EZ23+DDfT54SqL+paSX1s9cpQGjaNuG+vozcasi6qz5iWKjDxascygxJwSbo1GrJjzwOGbr632HVMDMJ4LwKaAn/oXMLsu0JWXYCGl0LtsfCe1etILjcRzG6/v07cP1gPtSqWILAuC7DnLSVtS0QERvmxI8tNDJL5tW83LM9bJiwxvi2SbqXOgQ4Vag6qtL0txQ//AIyG8GBDxTw7ELne9HH7mzHo/NT6HhFvkPs2QqpQGFo8hO0uEFAflqgSbeTtI1SJ5mSm4RVjynAcMMbEy0KlODgXl8orW9l053LrisqbG6MTtJAdj6ACnPSZE9Tnqfxxa0xdAbG4+gvmkG+S0N/yN6Y7RsYVhxnilzFQxDHkNbileZZDK+Al3JW+yNx+EF47Ee80oLzDY90Mse73E33lv58a8DgQfO3wlgH4cg+pvtr5kMqOohTsrZQt/4fuNq/i355NuEPS8xE80oPNSVsNYg+avdVUu8p1w8KEJP28EbWsIWntsx5NAFjJmUFEx5GfhlnvUDwQ7fiRqJCeBs6vIzzjdj5ydlFbpKDl//zF3CzNtN2s9UepTht2zOPcjUQ07l34C2hdQ+L0t96OmjFOv5cNqzB0l7Z/jiCNs4FyLsknGkP+1kQ1KJz7vnvFqCCIui46WEKqUsHSI58nbBJG74piQO1QEDEDGfbGRcpIXOA+av6w3iZARFth7gO1OwFcmk6lZMy4RtuFpFV7Wa//hfweopUF7CVYQtqqMuUTAE3T1Ro3cFOQti4LK9gkUz2F3PFBkR+0tNppqHoQYYTTDrcpoW/G6fhPEWxpVpVYCiiCeJt4LF2Wk+M29RbtFqFNae3b4bciwB5
 lOKE9lf1
 o/aSxFzaMtdSU+Xua4u0nagRIkR4GehK68MhEaFunf5OKgVKnhLbRqJsDl2frrmkILPgywRmRj1JnCBY86lzXDcsj0zzGa+8sgVqGAmoyzwy96NPbkzvsWZdXqvMN+jzrkMFy0uS8w2elpwXtkh3w5RKmZD4/uvkGoNbvC+0GmyoKacNZH5ilXar/t5aIAjygmRtYshBVgN/bn3bgHEDxI50VgqTP63niwLZcnOYTk/KrqZ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugetlb-mremap test fails if there are no free huge pages prepared by a
wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-mremap.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/hugetlb-mremap.c b/tools/testing/selftests/mm/hugetlb-mremap.c
index 1c87c39780c5..09241a279ec2 100644
--- a/tools/testing/selftests/mm/hugetlb-mremap.c
+++ b/tools/testing/selftests/mm/hugetlb-mremap.c
@@ -26,6 +26,7 @@
 #include <stdbool.h>
 #include "kselftest.h"
 #include "vm_util.h"
+#include "hugepage_settings.h"
 
 #define DEFAULT_LENGTH_MB 10UL
 #define MB_TO_BYTES(x) (x * 1024 * 1024)
@@ -108,8 +109,9 @@ static void register_region_with_uffd(char *addr, size_t len)
 
 int main(int argc, char *argv[])
 {
+	unsigned long hugepage_size;
+	int ret = 0, fd, nr;
 	size_t length = 0;
-	int ret = 0, fd;
 
 	ksft_print_header();
 	ksft_set_plan(1);
@@ -125,7 +127,14 @@ int main(int argc, char *argv[])
 	else
 		length = DEFAULT_LENGTH_MB;
 
+	hugepage_size = default_huge_page_size();
 	length = MB_TO_BYTES(length);
+	length = (length + hugepage_size) & ~(hugepage_size - 1);
+	nr = length / hugepage_size;
+
+	if (!hugetlb_setup_default(nr))
+		ksft_exit_skip("Not enough huge pages\n");
+
 	fd = memfd_create(argv[0], MFD_HUGETLB);
 	if (fd < 0)
 		ksft_exit_fail_msg("Open failed: %s\n", strerror(errno));
-- 
2.53.0


