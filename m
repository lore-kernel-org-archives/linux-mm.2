Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 061E4CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 649616B00F5; Mon, 11 May 2026 12:33:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F99B6B011C; Mon, 11 May 2026 12:33:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E9286B0120; Mon, 11 May 2026 12:33:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 393316B00F5
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:33:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 01A681C00C4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:33:00 +0000 (UTC)
X-FDA: 84755683362.03.A4E79E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 596144000A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:32:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kFsFjkef;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3o+/W0v77ysmU9gpS5SJhLyBr9OODG/6VC40mLRRYYg=;
	b=ZDrtjanS4vumFethSAXX/l6U54kg5bVoWNP4CIwknpbitsGDQd99NM7zARxI/7JJV4Y/fk
	AwbklHMg1rB+cq1V/abuQz4hO0oadqe+Spo56lJd74fEiAetOxjQnd+TsQCRUiInjvPdlK
	PqcjYoeFQpTh4TPEY05tkfJwi+F1RpQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kFsFjkef;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517179; a=rsa-sha256;
	cv=none;
	b=ie81TcOtUJmRxM0ZlPKQpn4BuCDnFW0VYadsl6p5T6k676jlHi6EUqfkqMsMaCars3PUM/
	q2wXpMuvPMuoYSuOBWuZDZ1dEz+KAEcxwVbWdjwAeJJPIMwv7TGq3LynRr+cov/+UosCjL
	pfHrDnXiB1L/fY8D/s2E0YcHzi38NAM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CE86F60132;
	Mon, 11 May 2026 16:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410AAC2BCC9;
	Mon, 11 May 2026 16:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517178;
	bh=5yqp0VnRSeTLTeoa76s4B4sERdsjKxOAYdEtPWcYVyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kFsFjkefy6sMqwCaxUf3K3br74SVQV+s9svWMmgSPWtGuUaqhrE3ZTTGFiki3cDsW
	 uIxhwdFiz+Pv9uaUSqPNU3GGCu7tb2ZJl9b0HBDp047RUGDA94yVwsPIJ/Vik/dULs
	 CCPPdHWAWqpRmOLvuik/vhg4nglc8CLwtP2vSLZ3kZUfVLPopjHKWbgmL10yYbXZ7o
	 VNSiglkgYKcPUq9ILqM9vBgCEamwr6pM4Vb64xy2IyfcgFAJEd2Fc0WiNlU6SAu0d+
	 oONvK1EYv4nOKHuROrufoeS8d+10CBFX9sFyuASTsEQ8fXi7Wq/5YhxkfD45i5Go1f
	 KTk4avLX40POw==
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
Subject: [PATCH v4 38/55] selftests/mm: hugetlb-madvise: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:22 +0300
Message-ID: <20260511162840.375890-39-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ty1zeor4ni8hdzjhai97dtwyf5roz8hk
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 596144000A
X-Rspam-User: 
X-HE-Tag: 1778517179-502024
X-HE-Meta: U2FsdGVkX192MrteAqY3as8+Ik3idrLlDWLYd5M6lNuPDNhzfJ/jqKJEZplJmf4/iTLY2fXTS8gYSPcCUNelH7l+xkbfBOQ/8nBVJNS3amF0B65Nl/3fuQK+OBYQ0b3RYuPJK30D2XUwoUI6wRVGgJgbOMmqSycaNP6OL6AqbB3hoEDfqNbvoqRKJ41tNdM6cLN4ZTHLGU8+dCsfYDbywF5n+wXmfKIN9zSeB5euXJMgMLjSGu/+AcaVQ4+7aG1Rksc8RI2ya+RGz0s8yBJxGSjRqP0qmEhFWsCVE9vbjqoSHU4EPr82pwbMCUTZrCQ9LUyxbTgWtW+Cfsrzj2EL99Xge/OG3mMQiC9NrF44GHBRu4tFBndndP9FPhpgH5tqOEOWXDZUMSgXdBWyK/gKoUkhbrBRy98idQ+Ad2xIXwK09mEp7xEQwVuWxjrToMc+2ybFWubaIRGhsQs7L8H4IFRcwp5ifZD9aVH+aaPELJTV/eoNoNhxD4/G7n3Rp9Nho2KzypnJMVRNX3Kd8x909CNBcgP5XuYw3DUad+IA7TwGXh58nYObBCXytW137h/0ElSJmqxLdTgfAmzQofjI3cZvtXwfoRA8oHBKVGW1Dh/OePkXFxMdB5xvo9bCqs3+kZcxpvjdRQac7GCDloDqQj58cqWRma+57XQwxD3TR5AROZOVlIbfJF1B2Q6Nfpk99ex1YDmfsIuQrKlBJ45UT1sKlSHum//egCzeZfBtd8Gtz+3j4ZYeIMX1+pLMoGBZGXPaSafoqJ3Of8aBxvJXeIYNnxteiMqkDO+qZRaI0TWNqjXpXo+ShRnm5rOae7Mv8otnnM5easIhUv7Uc/TUdwDDNHaWTHjRR3LC6+ibNwBhJd9aHcW4MTQGjBfV9xUhhUzue3PEeVeGyPwJnC7tRy4EtbfWaCE6OJ8MxF+trJGFsdUEXepycvl+ye8PVWgcyDLRqlYtCnaLGPRhUTz
 CCnOX7Qw
 4M4r6jBg2/XpKkyzEEvEdoNiN4eKMJ7NmidpGujnaiUgX0yFuCHo99zvladnFW96lbOZkkWmDAOW2pUxlBMB7nlkXmwv0tfELLz/L4Knv97SgJjC2N+5rjUcyce+Y10fcTiaRWJ5Qm8ITfRHDGCDeY88D23eUKBesqPrkEUXRNZ/925xOPRmdSgSZvSd5OC9PFf4Zk2m6iDJXTxVSan9kx5ghCBxjWHpVVGHx18FyFZSSBZ0er2DFI9dbNHCDk6GB3hBy0OmXYFbhUghhms4Ech6dEOpeI8o1EWlUKi8NhFTDC8S+QFqQ3DDl82rBMbgql5+/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugetlb-madvise test skips testing if there are no free huge pages
prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-madvise.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c b/tools/testing/selftests/mm/hugetlb-madvise.c
index 8adcd91d078d..555b4b3d1430 100644
--- a/tools/testing/selftests/mm/hugetlb-madvise.c
+++ b/tools/testing/selftests/mm/hugetlb-madvise.c
@@ -4,12 +4,6 @@
  *
  * Basic functional testing of madvise MADV_DONTNEED and MADV_REMOVE
  * on hugetlb mappings.
- *
- * Before running this test, make sure the administrator has pre-allocated
- * at least MIN_FREE_PAGES hugetlb pages and they are free.  In addition,
- * the test takes an argument that is the path to a file in a hugetlbfs
- * filesystem.  Therefore, a hugetlbfs filesystem must be mounted on some
- * directory.
  */
 
 #define _GNU_SOURCE
@@ -68,9 +62,9 @@ int main(int argc, char **argv)
 	if (!base_page_size)
 		ksft_exit_fail_msg("Unable to determine base page size\n");
 
+	if (!hugetlb_setup_default(MIN_FREE_PAGES))
+		ksft_exit_skip("Not enough free huge pages (have %lu, need %d)\n", hugetlb_free_default_pages(), MIN_FREE_PAGES);
 	free_hugepages = hugetlb_free_default_pages();
-	if (free_hugepages < MIN_FREE_PAGES)
-		ksft_exit_skip("Not enough free huge pages (have %lu, need %d)\n", free_hugepages, MIN_FREE_PAGES);
 
 	fd = memfd_create(argv[0], MFD_HUGETLB);
 	if (fd < 0)
-- 
2.53.0


