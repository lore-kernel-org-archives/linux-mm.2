Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EFD7CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 10:32:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B8626B009D; Mon,  8 Jun 2026 06:32:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 090216B009F; Mon,  8 Jun 2026 06:32:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0F0C6B00A2; Mon,  8 Jun 2026 06:32:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E20956B009D
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 06:32:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 88F3293346
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:32:37 +0000 (UTC)
X-FDA: 84856381554.08.E203431
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id CB7CE1C000C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:32:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qEFmRZ4S;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780914756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=E85acveXIkGtboEc+F6mN/q9TqdUyYo+bZWprhj/gQs=;
	b=JpYg2V3TO+AA2u3YKeLpvEZ668LTJb1BBdaDe+DioMeBFv7J1ZQ7sHFbu+0g+Kqljn7ldf
	QWEJCFVxynI5s4GGXuu1V23F4kBpQmFGtp+01hekTF5mttSx0zaxbBnQvtB29YYNq06H7e
	Nxk99di5Xdve3BlhhQBYAm2DifAl9e8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qEFmRZ4S;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780914756;
	b=BQkLT2PSKuLMSA820gWZbfhxa7KkNU79v2pnAivUgg21wGtwQXFDRzbF63tKIHA6VrxRsA
	apJQcbXn6HVSNo6J51ntrvXt+CFdo4lASvV5ihGJKmzMIfTsg+8bngC0dLhIJ+NXa0h3nF
	z0ygoggcG/1+iIf4JRHjze/+369Zj+E=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A493C1F91;
	Mon,  8 Jun 2026 03:32:29 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.82])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 865823F62B;
	Mon,  8 Jun 2026 03:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780914754; bh=BHohjbZbGokKxuhzeEPMqgB3NmgFH0MxP3ZLy7lt3zk=;
	h=From:To:Cc:Subject:Date:From;
	b=qEFmRZ4SNoZLJslFZ60m9VmaAf7ydO83aqFlsu4ciNX1guMKLtLq3b8iGahi/iSXX
	 RwOG0PBCpTG+P+pEhn8FP3i8tcUAfvTvWiAy+c0HVnUpX4X0KMmOY8Tlg9Bk3BqQvO
	 4uRErH4c0Gx9fCkhZ1X0SZL9vJI40WBFK+9zKN7o=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Mark Brown <broonie@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH] selftests/mm: fix ksft_process_madv.sh test category
Date: Mon,  8 Jun 2026 16:02:24 +0530
Message-ID: <20260608103224.344101-1-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CB7CE1C000C
X-Stat-Signature: ihocrbf6c1ezx5egtbmzr4ork3oj4kys
X-Rspam-User: 
X-HE-Tag: 1780914755-5940
X-HE-Meta: U2FsdGVkX1/vCs4Y4wpCqaSp/la339xYcu2LjHAf2TsCiUUVJ0W3/ofeQreYUqIpYw3YN9YjRH/IOQT5kDuVrdFO38Y3cIREFYlYkjnN0CTSlsdyO3LfyvmsJdqZznBgjnHA2w04qgYIoF8/UdF/QQA+EmR0goaW7pHZqFjcdDIBcz8I7+GCrPceys5beVtxrNXwFX7hQ+syWcNwGU2kqOHfL0KxN4T9IiJ3qY0cckK5pw5uIG0trtB60T6++0v/0fuNmQRx3K+YcRreOyAXmsnU1gtEZtfqRvzax2zdCEO5+SBV5UfFNMFqWOMBtIuZWLW6yO6q6PQbKR3dhYfctLlgNbXoprMC/0kLz6IftIDLogEdw+8KqeJofkqE5heqqqsX3zQeqVDooUHqcKXD2x0OVnavJs9g+xxLzyNIvM7r7QosjyJahk9/TCTl6rMnW/ayxFEms7wikRvhIfbd73FjeftGdyLIP7ErWfohccwXr2lq8Rt41C7rHcvrRH9cvLiwxvo/yAfcs6xZVPQIrrtoRztTQJzfFabFL91GoX42B7ZJIToVYNImkp4NeYvqHQGBRsfWK0CwqWO+z7yG+WW8UrlNIGWGEXXZmrGMH64boIJ5vDNgbkZw645uefrDbrIkpgpCt7WFWtw3xxZ161avl7w4k2OzGUNiSq1emdRITiEDzU+3e5PCP8LgIO2bZ5mWbUoDPRNXOUI8fDIQaE9fQDUnE1oU25IMApehIc92RkZCSb2D5J1kdCfzQfIx/PJWvdnPEEju9X8wFw8jiq8eF+uJmikT16ueLOPmVTcNmqVrqe3Vbn/3mdWjh9cKXRa+J+aCigTdlfQ2d4ezEjYOEcO+A12ZSuM68tO261vL4ADFanQtQ036V5ZTdH5q0dvYXpV7caK65z0n9Ibgk7fhHGFpdIJhkilVN7qTwqCQgohzWf3z3mzU+034r60az1zQL5Tjy7dUbq6GBM2
 ZbVpWQDX
 dAt9XUSzvlGJv5gD6Gc1h24THLayW1k6udsj0PAY31YpAlXGSa80WOvtwCFv7tVTNdNDfICwS7slxB1jpX/YcZwLdojg7B9w9q4WkdNNwmsXhI1VmrpL3JCBleuzVMAEX6uhFJ4dG7usex+owE1Z7RWwyjAGxqwL+TzgJgEIKOJQOJTOKrFsXHqp4euBoWqcAc4K/ZHlEBC4Fvm1TOvWIBtKGDMIutqSuiE2V9PLkrCmuQzI7g1QWAPPItGl1oBH46GJ0xetWlhlltLrW9S5QdDYhLozYtU2MxArt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ksft_process_madv.sh currently runs run_vmtests.sh with the
mmap category. Update it to run the process_madv category,
since ksft_mmap.sh already runs the mmap category tests.

This avoids running mmap tests twice and ensures that process_madv
tests are run through the kselftest harness.

Fixes: 6ce964c02f1c ("selftests/mm: have the harness run each test category separately")
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/ksft_process_madv.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/ksft_process_madv.sh b/tools/testing/selftests/mm/ksft_process_madv.sh
index 2c3137ae8bc8..edad2d2d888f 100755
--- a/tools/testing/selftests/mm/ksft_process_madv.sh
+++ b/tools/testing/selftests/mm/ksft_process_madv.sh
@@ -1,4 +1,4 @@
 #!/bin/sh -e
 # SPDX-License-Identifier: GPL-2.0
 
-./run_vmtests.sh -t mmap
+./run_vmtests.sh -t process_madv
-- 
2.39.5


