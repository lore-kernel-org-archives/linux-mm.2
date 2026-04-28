Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BDB7FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:48:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 801D26B00F3; Tue, 28 Apr 2026 16:48:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D2F96B00F5; Tue, 28 Apr 2026 16:48:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70FFB6B00F6; Tue, 28 Apr 2026 16:48:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 601E06B00F3
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:48:10 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0F342403A6
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:48:10 +0000 (UTC)
X-FDA: 84709151940.30.302979D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5D52E180008
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:48:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LyYmCfUT;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IfwxdIULrvPYbCaT0rC7nJp3cgiUYWThgSOqSi8ytkA=;
	b=MQhL+PQT5MF/6n0b1qY0i/QS9FxkA+GmXI65t/bxf8JH/swXgEHOzD6VrKza6MiePoTert
	gfJul7G0QFlaBPm6sNN0HfEBcbXxkFFjxqocfLzzV2m1mmzAcT5GC42Kh4x8osWTU6UZzH
	ZVnzKzi9SCrhxwEWA8YZT1tDtlDErKQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LyYmCfUT;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409288; a=rsa-sha256;
	cv=none;
	b=gcAfcbHHGet+b/3EBj25ke63OjcU/8ACyLwNXQ4SJuJTrqadUAvqCQXgquxunBlE3vv+IU
	H/zmQ9WHXl/Xiz05icEOSTAHAt2NpZJr0rPXmbdxxYm+oEaKsXY3NsWPuJiSwl+utuow6T
	EPxqqWC0T2RKv1dQcJ0KNHIjgfTEUEs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 815C640064;
	Tue, 28 Apr 2026 20:48:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548C8C2BCB3;
	Tue, 28 Apr 2026 20:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409287;
	bh=n2KgdfeDkv6qGICkBg3Vwdx+MRmhbjeNlFxUjnQTB8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LyYmCfUTY2G4V530dknb3eO7NHTasmxoDpdVvrgwU78AtmHgRv4xF8f3uCPZ/jM14
	 cVswan0mmRYOHVU3VpVJosWpAoVZ1izld0PsVhUgCDUonA7gBWcjJ20emy2Z13ds0E
	 RV2In/aOajeta7CYPc5WrEP+zpmw7j5LaaUOj/IYtlvjB9X0AqYr3dcW51oWC5ytkp
	 KgYQ+54oL8dQ594Y/oteKma0ib+Dq/Derrz8iqbOchVmQYcn8JaMaxTA/K5YnhYnQW
	 9ifHzksHFVo17kV6W4wS8ub864jmzK0/kWbRu0aF7t2Y8XCHe07YkuCFetZvEIdVdP
	 PLPrPgHSd14Yg==
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
Subject: [PATCH v3 48/54] selftests/mm: uffd-stress: use hugetlb_save and alloc huge pages
Date: Tue, 28 Apr 2026 23:42:34 +0300
Message-ID: <20260428204240.1924129-49-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5D52E180008
X-Rspam-User: 
X-Stat-Signature: 6uoe8zxhdomc36e1en79cs9gf8ieezi5
X-HE-Tag: 1777409288-874717
X-HE-Meta: U2FsdGVkX1/g8hf95uyH8I3yiyP/TkIjcB4JpIrxstOxgDrQMGXjd9f6uVLEgW1MHhQVI3wXY+bA1NSHt2HDnHFisdVSQKUgubREzy8c9rK4sgxJWR/eiiTTs6J08kLHJ0XVh1UZoqfQteHseUdDu9NDoWSS0DKxZ0AALJEFRytnSyC2YhlK1jdojWJeBCbS6/4n0SY/4YBmIgB1HrwVXUkAYxwd9Mct1i8ejUzBh05kdwB9ARPimkCucFhQ1Pj1A77ypK4ARGdvIlSRiki8MZ9jIhKEtMuBPOG9mXuMtNlMmr1bOBYqd5Pj8a2MCktwlM5HII2uL/fiPWoiKkrDsHZ4J/DSmXyHX6duAQLYGEu6o3vrc4vCcejzu8IH8yzUK7PyBblpEjna0j0RWMX8qGXn2x9TpJRpavvpU8P95wUchZpTZM2bMuT0r2636Xe5poB7N9OO8zt+45DajP60tfsDkiFlWkHAzkr4Djb/XrHKOBlOaIgOgq0+fXRWEtV0hZnIqP2v7RM3gjbh/ocWXgJ+pkdiUuLNAZGckh/RK18/95u6Vzzy+2isDgUVkmH+ibmQFcE1sTsxF9qXB2Z+6XWMjllOaok44SaEuMs8CIjxvCjensIeDvMQHpartzVft7LtXOsqTcUct19+QTOcpgC6XbxjJHm3nL/sFBkMqe+ATKf1YtSWt3GMR7R5oG91uzmAehPwYA0bDgrjDVy4+i1+xzjOB32K62M+faE4iwIm7rESSMyH8y2w7yH1+a2dPz/okLWEu0WXJbVhxDYnb+lrCoWhsT3weXBKKEwJTT1CwZEk+Bz/QZTbY9Wknv/0L3e88XLftWweiu2ovhC3THqQXXqaFquROFQKXdyb/Dl1U/9P5ZJpv6iGhq3dQomCBDteWVuu64PHKVMyDMhgjisbYNwLD8ApCsFEEeZXyGeAPQvC64/bhoWXnEiOexZrJvObKPdmAlxi5ZxU2Ty
 WU2hPGok
 6uIU6Bu4KAxayNju7yhB9NezjfeSLKPnikJ5FiE0bpySNhtHBsCyACrhfZez2sU9TaSOeSxAb1FP0PrfeBhEBhvSDibdORDtXHvE9SSlyn9KpiXowqM9xOXhbrIzkDne3+9skbyQ/YmgU/D4XpBs5S2yEFlZ8qGmY6y6QmQFbeu1lf5PB5GIB3CfEelGBCIYXyHgEKAenTx6kzq77/bHrq/twRoogx3SPhU6hTyS9lLLEPbfJ7FKNt695lwmRwZzr6u82loKoceSLi1ea/vKeiDg3kjj9YrTcof85
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

uffd-stress skips HugeTLB tests if there are no free huge pages prepared
by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/uffd-stress.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-stress.c b/tools/testing/selftests/mm/uffd-stress.c
index 7e37cf3d27f6..9693d042f16f 100644
--- a/tools/testing/selftests/mm/uffd-stress.c
+++ b/tools/testing/selftests/mm/uffd-stress.c
@@ -479,9 +479,12 @@ int main(int argc, char **argv)
 	 * Ensure nr_parallel - 1 hugepages on top of that to account
 	 * for racy extra reservation of hugepages.
 	 */
-	if (gopts->test_type == TEST_HUGETLB &&
-	   hugetlb_free_default_pages() < 2 * (bytes / gopts->page_size) + gopts->nr_parallel - 1)
-		ksft_exit_skip("Skipping userfaultfd... not enough hugepages\n");
+	if (gopts->test_type == TEST_HUGETLB) {
+		unsigned long nr = 2 * (bytes / gopts->page_size) + gopts->nr_parallel - 1;
+
+		if (!hugetlb_setup_default(nr))
+			ksft_exit_skip("Skipping userfaultfd... not enough hugepages\n");
+	}
 
 	gopts->nr_pages_per_cpu = bytes / gopts->page_size / gopts->nr_parallel;
 	if (!gopts->nr_pages_per_cpu) {
-- 
2.53.0


