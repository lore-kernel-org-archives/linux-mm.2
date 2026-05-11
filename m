Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94B8CCD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:30:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 079186B00F3; Mon, 11 May 2026 12:30:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 029FD6B00F6; Mon, 11 May 2026 12:30:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA9C76B00F8; Mon, 11 May 2026 12:30:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DC9C36B00F3
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:30:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A336E1C00DE
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:30:50 +0000 (UTC)
X-FDA: 84755677860.30.F82E742
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id CE08540015
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:30:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K6C3t1ml;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SDzdWmYyXyJR9XnW6em4hkJu+YPKtzfvwSrOE7THgPw=;
	b=SX11IFV3VmWWaun5+25bmXZ1Jsd7sPyeoAdJB21357NAJKQd4lLMjeFz6Eyi86sFvGBTKG
	ejZ6TwrTu2C/mSeXe/FbRRfrrH47A6872WV8nNJIrthq5oebX+0kAHjir129uD+HRNNGV3
	aOHDaIn3L0+N9RIS2XYGQVe2SoqNG+c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517049; a=rsa-sha256;
	cv=none;
	b=10L1XB9MB3yWf85M60DfErb3iobSbitTVgB1WjbfHgaLL5Py5eba/rzlbLAy0pY2v40mXo
	/sQE3Z9dHSwbosTRI5EdFFrynjqNLdSV7b1GmaE/Nmrb3z1YIYsKPO57sVqALNdPMITNIj
	DDT2+F074GHT8NDkiOovLQgzHQZ37yY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K6C3t1ml;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 06085404F9;
	Mon, 11 May 2026 16:30:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8079C2BCB0;
	Mon, 11 May 2026 16:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517047;
	bh=+OsbLUb461dtYPcOPTpsH3a+LL4wXaeYYZI9beSzW7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K6C3t1mlQbzbHhVQCBix0ZarGNuH0rSPqphj5hLzKRLiGXZfjES5IjZNy6PNZX7vi
	 0Aoh1xQj7RdxC85U+M7gI45KtW9m3uTMtOt/ZuLz1V7i65eo35c+muY+Y972d/I+uA
	 KKPv/FLWRh/hZzfd/PkSdVn92OUGU5VOkcdQUpkKZ57JsLcHSu3OUQZGNIT0GUfIMA
	 jBE8qWbnLpbhMrtweHftQxFl/4Wza/OMHnbOnpf5Rj5k4LA4Tsuu05oW39ewQGrvpp
	 /5djdQKUVAy2KLRJiyYlZSGoeCor8gxboEp6pkrnHLs7WF3GbnxkLBwxWIVOOAbr/J
	 kOGRYKKCzuslg==
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
	Li Wang <li.wang@linux.dev>,
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
Subject: [PATCH v4 18/55] selftests/mm: uffd-common: use kselftest framework
Date: Mon, 11 May 2026 19:28:02 +0300
Message-ID: <20260511162840.375890-19-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CE08540015
X-Stat-Signature: gns1x1ha6mb3isw8x7dbrqmr1p4kwdnc
X-Rspam-User: 
X-HE-Tag: 1778517048-699493
X-HE-Meta: U2FsdGVkX1/BGZVyVGBx63UTv1be50AgnFlvZpW3xknuB7TrZynSFVXhE3PEtB1EKAU1kfOD++vCMuABre+88aLzGQ1pSSkd0mSlzXDEdMSk+tsvzLXRSwpm4i/uCtDAohU6XiOtsW2wwqaGBnF3xxSZNZJHlB5DHFT+yHgM79HitaWwIzofW5tSBP9cTZfj7iib0Sm7Wi8q+b8vuu8NCHdDmj8Mi1lewrfPxOrDehrYVbvURemGx47vlE7nsbAXBNkn33NvJqa1IhUaFxRiUCUWNolK1V59pBoNVZgCOv3sl8LCijhPrym2slastIWmQ5MJHhOhOZnWsV5gCzmjqmtNOMRkHptSjAL6bGSK9SvSOPwKSdUX3Z8gYuXut9xTEk9KOA/vDXPDOvZ8gHEpneNRqWWgdQmmhtr3RDS8lCZZsXHB0ws/uqj3W0Po0IWr2GCyvG1x0ga5v25jIlHwg6HdLMXFmyvCuucGMjTTreA/0tlf4sM3dvOB5j2/6pvXAPWmRIuNBuYyQtbqowdwik5f6+RFCoPsbHzFQxbdxB+gFYML7H4tMeIjv4OAxg5zkcSpeIX3nnzb04uepnTp/ziK0yfuKoYONQXNYlIh8oEcoz/JGP/5RYV8EAGnBIah9MR/an4gE4ek23r44g3nT5phLZbS/FqbOoistv6QGeW6Ui6O/urqp68qZCSvJmgWjNN/krrsldetfiUrY72mU7+BApCv0t9urGL9uj6uOBhrFb7KvGIXzuEVFdqTe9tySTqI3/DKMNKOEfppRNYDi11+YsgbEgzjx7pykvIbxzoIBiu4fik4avGr/Xv+iUpCuC7pLy0+/4ZM0pi3YvB4HgfTgnNScEBkgIXlpLFSeKPTu5xMPTEp0AJNfZXi9iLu0TBWgqJ9UawUkD4MN9gIOFYDJZ258OapKA/bFDV+LQOvK8lRxregm2QRDhBbckpMORRex/hRcBWm8z1Qnnc
 5JPb7HfT
 ZeXLwqv1MAzooX2cZHml+xpllnJa0AMXhp2jRJkYR/BaqEHCW7wwZTiCE95okGpOgIQlv6PWnY16UcrfiWipZEntk3JbY3ulOYafOxcO54lJi1S+fYIzxsF07DE9Tnxv3IRaqAmp5O/luXybPvGhUqE/1+Ff7ZI0QPt/T+1Gs7rXSCH8Yl7QD0PhTZnoItoZbfRZRA8F+05+WWvmDTaT7nsGj5GPShU632irwutdzAkfjw4U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Update err() and errexit() to use ksft_print_msg() and ksft_exit_fail().

This is preparatory change required to update userfaulfd tests to use
kselftest framework.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/uffd-common.h | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-common.h b/tools/testing/selftests/mm/uffd-common.h
index 844a85ab31eb..0723843a7626 100644
--- a/tools/testing/selftests/mm/uffd-common.h
+++ b/tools/testing/selftests/mm/uffd-common.h
@@ -40,21 +40,20 @@
 
 #define UFFD_FLAGS	(O_CLOEXEC | O_NONBLOCK | UFFD_USER_MODE_ONLY)
 
-#define _err(fmt, ...)						\
-	do {							\
-		int ret = errno;				\
-		fprintf(stderr, "ERROR: " fmt, ##__VA_ARGS__);	\
-		fprintf(stderr, " (errno=%d, @%s:%d)\n",	\
-			ret, __FILE__, __LINE__);		\
+#define _err(fmt, ...)							\
+	do {								\
+		int ret = errno;					\
+		ksft_print_msg("ERROR: " fmt " (errno=%d, @%s:%d)\n",	\
+			       ##__VA_ARGS__, ret, __FILE__, __LINE__); \
 	} while (0)
 
-#define errexit(exitcode, fmt, ...)		\
+#define errexit(fmt, ...)			\
 	do {					\
 		_err(fmt, ##__VA_ARGS__);	\
-		exit(exitcode);			\
+		ksft_exit_fail();		\
 	} while (0)
 
-#define err(fmt, ...) errexit(1, fmt, ##__VA_ARGS__)
+#define err(fmt, ...) errexit(fmt, ##__VA_ARGS__)
 
 struct uffd_global_test_opts {
 	unsigned long nr_parallel, nr_pages, nr_pages_per_cpu, page_size;
-- 
2.53.0


