Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6674F46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:20:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EE266B00D1; Mon,  6 Apr 2026 10:20:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59F0E6B00D2; Mon,  6 Apr 2026 10:20:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DC9A6B00D3; Mon,  6 Apr 2026 10:20:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4164D6B00D1
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:20:54 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E1F3C1BFB
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:20:54 +0000 (UTC)
X-FDA: 84628342428.30.B1DA71B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 80C8212000B
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:20:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PXlcsjUk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H1liFTyal4bSjbOvk5FshkJIBykh5rg/CLceE50C1rM=;
	b=0cY8gFxrLT7l3QiJNvesFAb6WSb6IKtJMfFJtZn75SwKtsvSDGkd/EqJ8YAbLm+8u3lKTF
	WujMxhy6/sM7OLeHBVXzJbBhZCWcXmrcNe+R+8K6C8pFInXrJiAy1OwodBuYEtILA9vJu6
	ERyb7J54puJJ9BEHbRvVRkEXMuPCcyM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485252; a=rsa-sha256;
	cv=none;
	b=nGRSeigCpyGDavuR3DUvxytMdmBoOgouov/wWGr5OdRlfbcXHcbfDnGGc7bm10Y1XuDoFD
	Jou+5wgiTStlAQGOgrwA9LdxNYyI/Dm8V0/80x6O7UNNsPcvKVtX8HLI59JvqVpLKtZqtF
	hpu8ejxBFzu0tEYspzaOP6P7lU+lqFM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PXlcsjUk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E21B360126;
	Mon,  6 Apr 2026 14:20:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595F4C2BC9E;
	Mon,  6 Apr 2026 14:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485251;
	bh=a9ftjtHwEJ6B9K8hvRWelWOu2y5v4+ZMDsKskwzolFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PXlcsjUkXpGa0plMK4KCSBfUoCbgkCkumdlMO8LDe+jLUERu8ebnt2EKXCiuml7mw
	 olTPeslK3N9IBwibWeLmB/LrB2iD5h07goqgyUG4BDXpcwQ48nK0YaOmBqyzACUdZk
	 WNZunJJUYtXxxpoCsoBjoRIXoBEiXiWGCsiNmhSMbk175XXgtYxyNugZItpBJdJN/Z
	 Y0frwWHHcZvGEUEL0rqBzbdvAvquAI8pOwnd48kyY5NOQzooANLVYpAMeCSmMJgrbl
	 GWESBEl8zXj0VjWvDgxN+0HE/Md61T/GHtzyYANyIywu4zWAcaDtYjcR2p2zQUWn9+
	 iJVj/PbiZjnrg==
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
Subject: [PATCH 32/53] selftests/mm: gup_test: add setup of HugeTLB pages
Date: Mon,  6 Apr 2026 17:17:14 +0300
Message-ID: <20260406141735.2179309-33-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 80C8212000B
X-Stat-Signature: 8e9fp6fw16ycpnwuu6r8oyix3ckxnbqw
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775485252-537946
X-HE-Meta: U2FsdGVkX1/00yIkEoFWakp35p5vBQrYbY1lA6NqPH+yYZVtkZNiymH8RnlcdgivZ5CrOh8Nej0M99vn5Tg0g0FlWSNV5tAKMHcVOqhRrDP5GlBdkEgyAHCyv1A7NKVqPAJ1Si5iooZZ+gnVV05a552jnKgk8TFlnRYMi8yfhN71iaWTFORnfgmj0jEux6F7iNsWBI6xvs5NOppK6FhQSPtzzCMFcU4ej2NL7PkcdLPyINdzTVo13a/1mfzZ0v2XIPSEl/pPezJJ3dmsHGkLBg6TWR0R2FKHLlU8pQFtdUq5MNPVCO4h1ff6EUWu1TTAozDJt/nyCgEs6GsnOPeRFwJ5o+NKbO4W0UTPQUxmvgN05Gi6+GeQoImARmCqYcXigjKCAz5vqtoDMtbpvx0JCjI0I+dXdB1Q6kTAAB4S92FDbNqEq47yJagRNv/jvv92dkUmuRVAfSsULarcSw/7PmTz4H5V6QMZkxgUbQUiC4+iY9zI/NwO8HwUvr91sW2uDeL9AcC/LeLWKBm0xoQ2qQixqpmsCLrftuy/HAyzRK4H3aXrpff0ae5rR9C7bJdlj0fHL3YeLOq4ubf5CRMjyXLn/SR7DTw2AIypWXK3cW2Q29A+OgI+LJaUGMAQP7pVMd0cptPQXBgq1J99JfvsaCGtPT0ZDCb2UU6B0SXAeqMmCz80ZxvkuQ1rCoI5A3UMyH4OX9R03grmpaSpEheNrlyp+PiiWxVt7HS+Fmko+FvGEv3xL+xlqqYHEtdZ4G/daiReSp+g/DaVvgxHbH7K7Mq2IJalGSdYD/Vd8mq8OA8hYFH5sJIEC6e/UG8Ul2K0bynLLztx+jbauNL5ijkugw49zeq1o1gjI/fIo/olMhNh6Byh6uUWojh2DHQuLIoTrasWnNQfbxzvfa9DMZV6i75L6hGh2I23Owr9GYU7QnlNSZifWnSFoCzfS9y1dFezdzMutGNMdiTpTHEpryJ
 /Gxb2Oly
 Yph7OubiVvq0J5OS2rmS5qw5ugNtIq8QEGk4aqtvVoOSnCdWwhh/Daw4BIuzkflTVDpQHyqzAnhxnDLzDH08Ln7ZR3hvsL38BaE93gouaccrrUprZH+bKdG5dv9zOxJ54m6RNn/4Ibl96rdbhj9oMl9zEyfy+uJZ+68xKyaOUzb24JGXve6J4zHOCTSj6LcUWjdp9FafrABlaHiKX3vT7gVUroy1dDe11bIqpJ/5pMYpfj8V+q7OOLxdY/c07KfAGflwhBzm4kdVO8zdOv/p4rf6ZkDkrtDGK+1o1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

gup_test fails to run HugeTLB tests if there are no free huge pages
prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the
original settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/gup_test.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/mm/gup_test.c b/tools/testing/selftests/mm/gup_test.c
index fb8f9ae49efa..ddd239a69881 100644
--- a/tools/testing/selftests/mm/gup_test.c
+++ b/tools/testing/selftests/mm/gup_test.c
@@ -14,6 +14,7 @@
 #include <mm/gup_test.h>
 #include "kselftest.h"
 #include "vm_util.h"
+#include "hugepage_settings.h"
 
 #define MB (1UL << 20)
 
@@ -94,6 +95,7 @@ int main(int argc, char **argv)
 	int filed, i, opt, nr_pages = 1, thp = -1, write = 1, nthreads = 1, ret;
 	int flags = MAP_PRIVATE;
 	char *file = "/dev/zero";
+	bool hugetlb = false;
 	pthread_t *tid;
 	char *p;
 
@@ -168,6 +170,7 @@ int main(int argc, char **argv)
 			break;
 		case 'H':
 			flags |= (MAP_HUGETLB | MAP_ANONYMOUS);
+			hugetlb = true;
 			break;
 		default:
 			ksft_exit_fail_msg("Wrong argument\n");
@@ -199,6 +202,15 @@ int main(int argc, char **argv)
 	}
 
 	ksft_print_header();
+
+	if (hugetlb) {
+		unsigned long hp_size = default_huge_page_size();
+
+		size = (size + hp_size - 1) & ~(hp_size - 1);
+		if (!hugetlb_setup_default(size / hp_size))
+			ksft_exit_skip("Not enough huge pages\n");
+	}
+
 	ksft_set_plan(nthreads);
 
 	filed = open(file, O_RDWR|O_CREAT, 0664);
-- 
2.53.0


