Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECB62FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:43:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 645F26B008C; Tue, 28 Apr 2026 16:43:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61D8A6B0092; Tue, 28 Apr 2026 16:43:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 533886B0093; Tue, 28 Apr 2026 16:43:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 424006B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:43:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E07694044F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:43:00 +0000 (UTC)
X-FDA: 84709138920.04.5CC0586
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3912980003
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:42:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FlakYzFG;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777408979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aPhewVopcZgyuNnvZor9eUMfbYUXNp7puYe2VCiWTAc=;
	b=eY3juAmdhc9ruMXtqJ1vE0yS9gAdsAWjUmOczt7AzBDjePphBZM1p1bxzj6Tj1NwrY0uCT
	jzApy9OFL8L9M9YDdQaoXhK5tSDIOE5gJqZ3yUMRr2i1uIpcWX6OTNlUSpgu8TtfKdQI+F
	cWE9UDf2Kc4ed8LRdJS4MI5YJ3bEcKU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FlakYzFG;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777408979; a=rsa-sha256;
	cv=none;
	b=kFDh3A3X25Hm0ex7gSiBabrzqQrKcobjAm/mShmeS3COkAhLweUa4g0+VF9yGp/VrMuIDP
	TNcDmEWoLMLLpXRiNqHwIYfuqISgTfy7BCaAyHRV6FydA9R4X7OFG9VJ9r5R56uJxNFXRN
	FrjunvdnpD5fwIoLGmDoR/zMB+SlZWU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E15FF42A2E;
	Tue, 28 Apr 2026 20:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4119C2BCAF;
	Tue, 28 Apr 2026 20:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777408977;
	bh=9Wa6cmQ8SR+FAIiSEI++oU+tCSCF1FiRlP76nYdhufU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FlakYzFGRiVmn0uV4gIwdSBEOWZkQoAdQSVzm/1V6MlS/ZqTqb5SIDMHqBjY1+40J
	 8HEnx0nNE4umIeaMl7XnC8OMFE9S07ldbrhokMGfvPLF29zW6dfzzd0ggUKfT/pIHk
	 dKH//u72yXeZhMQ5L7hVKQziZdKfzaKJCD87y7AmeAMnhTunWQ2o/j6FxVtrsW6HKP
	 dnNoVueV/JfBBgSNlrYmJheNe5nRwJN6Qkrx710AbfSMr1zk3oEm1V1ltKnclL+nK7
	 akJQ9C55LTnO3cN32mS3ww0r5mVaGm18NVren62WP7pKY3v9wTsEkqJj4mZn17rKTC
	 qgYQgPCQXxbWw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 01/54] selftests/mm: hugetlb-read-hwpoison: add SIGBUS handler
Date: Tue, 28 Apr 2026 23:41:47 +0300
Message-ID: <20260428204240.1924129-2-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3912980003
X-Stat-Signature: arua5baqydbo4aznhtiawn55d9o4tz1o
X-HE-Tag: 1777408978-531193
X-HE-Meta: U2FsdGVkX18hVEMh9gJAfDY+qCTXU4ZssAdqJ1SaMBI3+V6JMiEXlv5PTlXz2n1Ne7jKExAGDzEHdxJ46ckc/iQZlYVsY/k1Wr2cnnc77cbc5Y4zodeNTGs0kS9wmSLCxN4lr+yA+hdVwVsDaPHprwUhNCtlQh0xU7bBiA4XSKArLQ3iiw0GyRQaqnp47AgqQf4VeBwbDFA2jEVAAdpkTTXIsfpZPdTu6dg8AmnXsVw282GaYAl+tCpE/OcwREorx15TB2siJ0S1MFCm/qfs0CgMIqCEj8Wsoj1A+ywHM1xY7a/cqMPKN8/i0qZ9jOCH7XQYSG4XJcv0/IVcf+YqcxmaOOTNsUmL1V4pLfWEIz3TC4TS+2fa/xg19h6ZzMZZeSJyOTkjmri/UcB2rSysbl+VWMqXiXOSoIIrqZ4XfJEiMFpjbcUbxGdQsLpB6S/05WVlw+z25NYMeuBKiG6lxn2k2tRtg0SwT3Lc9+BY528bc5DAyQVgmto4RZaRuQ5vSpJ6hVh5ZZYhz6pStJRZMfRB+AKYgwUeowxi9de8jplWesqNaFlhANfCs1c3z4I8YtpMDNrxW3cf3m9QNeLqAFJaCgsxY5i2qdzctW+A6OsdO/FtamYf7rjjRP6B0rYiALDk+nZoe1kM37VjPFWg5B41fS+qNdEIRQY5OalPsMx+bweZg4f+ZzyhvBZhcrBQqD6wlzoSZnnWCimQs99J/YmL7l3+2B2fGewrMaylKUIvHILYh8za4CDL5PlzoVbrp1+e+My/SJhy80+Y7Wea0MUZ2D9Ph22+GXT/vk9yqImne2FX0R7lD4lKOahfDGTOdgyepv/2tF/4ZDVtP+jyc/pDOTpKHBijiKLaUodtSeIeHvNWMNFUtKzLH/6oiIOo5NZvh75j2aCo1hVRHEwBeS9OaHNZjwwXf0VooFrw8I+TgMVX2yS8dwOdaq4x0JxsZ7V5tMIyIolULQY6bdD
 VswMZr54
 H+meGkh+ZOIS2r24pZ67CAb6k/9lbNkYGR98Kv3ujw6jOUmV0Rb+QQ2w0B6C/aBIw1f38Wpfdul6kSdowYT1M9C/SQu+SSv761yEC8kN66lBmSI0cmJKpkhQrNFd90avZjtsmP8inzQJWOgs047h4uViRmOUnU0KQtgSeDG4UEa9I9yNgYLeAnlPEO/SkGWVUNAsPqYLzpYhuiSr3lNxJN0ZMrev0oRqdIf2UWGXPhZbPYcgwfFFz4TUVgdPwS/bL2Co1x+YWtQJpFBdwYbj/WLtPVDmx2//5YOum
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Access of poisoned memory causes SIGBUS, which terminates the
hugetlb-read-hwpoison test prematurely.

Add a dummy SIGBUS handler to allow the test to continue regardless of
SIGBUS.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-read-hwpoison.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c b/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
index 46230462ad48..6bbf15f78061 100644
--- a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
+++ b/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
@@ -10,6 +10,7 @@
 #include <sys/statfs.h>
 #include <errno.h>
 #include <stdbool.h>
+#include <signal.h>
 
 #include "kselftest.h"
 
@@ -261,6 +262,11 @@ static int create_hugetlbfs_file(struct statfs *file_stat)
 	return -1;
 }
 
+static void sigbus_handler(int sig)
+{
+	printf(PREFIX "received SIGBUS\n");
+}
+
 int main(void)
 {
 	int fd;
@@ -273,6 +279,7 @@ int main(void)
 	};
 	size_t i;
 
+	signal(SIGBUS, sigbus_handler);
 	for (i = 0; i < ARRAY_SIZE(wr_chunk_sizes); ++i) {
 		printf("Write/read chunk size=0x%lx\n",
 		       wr_chunk_sizes[i]);
-- 
2.53.0


