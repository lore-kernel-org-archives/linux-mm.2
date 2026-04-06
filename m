Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E32FF46C45
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:21:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10E106B00E3; Mon,  6 Apr 2026 10:21:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E5FA6B00E5; Mon,  6 Apr 2026 10:21:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3E0A6B00E6; Mon,  6 Apr 2026 10:21:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E4D806B00E3
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:21:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ADF7C1B7FEA
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:21:40 +0000 (UTC)
X-FDA: 84628344360.03.72338BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id E940EC0011
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:21:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JlreYPFC;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485299; a=rsa-sha256;
	cv=none;
	b=ZNJCLEOuh7cXzd2/SR0fQHT/l+ZwNv8cCSe2XS2NaVaHuHAKnMfj89VQitqjf4qzm6J+P4
	qyintog+IvrAWBWV++YiKd9soK1AvFlFWgSzvk97qe7DGRUFvSc3VzK1eHkE/aCYwZqlCn
	xi4L8+/epk5Ujwx4wA5vKQMU+7pZjqk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PUYzOy/oIyWF+FJuYfujbmuxlVziUD4hD0mgHQDxE90=;
	b=potUabspfyWSJVtUf8VbmMfNDGjfCyA1QpnsAfTQEMDWbauOAH/IKKidePW6i1mwbHpPlL
	icw3mtzy9kfJ6kl4pyo8hUrgHR+QZ4oPKN2tIJ1KKx6t21NqKU/vWHX4q3Iqav0PWr310o
	8iYIL1Pwcj/lZaqXmW+HXmjb9qfzK1A=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JlreYPFC;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E887B40E53;
	Mon,  6 Apr 2026 14:21:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FD4C4CEF7;
	Mon,  6 Apr 2026 14:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485297;
	bh=CuwM0pZ3/JhUx+ejuVCSFOxrDGLqHKrdn9rmOFHqvFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JlreYPFCUZsHB3nh1FuJHqiHLnh//pLb8PeKlos/Koi7YMTF7uhzfyt8q3e6vQrpE
	 knMm1RKbCISOvxmqRr44D89N+IHgp97QFpaCzQfGfm0fK+n9Jbsz5JC1VSxbxtHlsS
	 KyjDUpkERbnBVwRAv6m1XIawR7PiDXl66iq1QEtO2pnkwbGAvzNpzN4Ebeun42iufD
	 D/ln53NO2EkWucLp3YpIBSxOVx6tC9ZPOuzORusCYfm4o48WuezCu/Fhjgo1Bvd41x
	 7pE4GtMTu0trXzmkLuWKLz+D6qPK5MGyQnSUrTmxS35uSwRgE6mNWswtfdKitKHa4V
	 +upLdKtl4ZY2w==
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
Subject: [PATCH 40/53] selftests/mm: hugetlb-shm: add setup of HugeTLB pages
Date: Mon,  6 Apr 2026 17:17:22 +0300
Message-ID: <20260406141735.2179309-41-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E940EC0011
X-Stat-Signature: ehbg3tz1cfguyqqh4789of7sdyim75p7
X-HE-Tag: 1775485298-476131
X-HE-Meta: U2FsdGVkX18Z4rcrA+rQTKMjTVSEWpeDbasOD4nNHhr3gmJ4qF+MNIRvHU4+gZctAWwKFiP62yhyqrBxKi0XzETqO96pDc3tnHprINGt7NGlonY0RJIgMJlYuFniAacrilu/7wB8xKI232CJDZyW6ajxcjN3mTv4R56o98lOYlUMC9nlEasQH+OqNbq7XE+Tso3yVgF0aI5gbP7gYOHdTKD6NrJXKCdPtx0DuaRnxk/mFw2PoSrR30cfuKxagnohQOrNAyI5p+1e1FpzhAgeHSKmDpqfdbwKjYocnHUanP5f/AD7Z5Rl3dek4StzFc0F1Y69CFeqbPTzwsT2gX43eVTR7TcK7SIRbU1HiwNWZKG7j95UDXqBC7GfIcCUn9PLzVDv5cEgljqql5OU9Zmk7urSTOD8Pv4VFFQxYGCXGbyQ2hI7qRYBiXHktk2+YX8WHlkQNXsXn1PnlDKT5UpCrZMiWJGLBceCIa7QAM3Ky6/ALVmMevgLLJekf9uX/8mfH6vHQZ7L/xTLvoO0WSDGr2H03ZWZY0oTU5u3YUyMr8Bvf/QPvHvS+nmwobaHX3lgxNtuCkN8hzfkjdzqx2c8uD3cowbzQ8GYJjXje2NktiTjRhbYLJ0Z/sEriikHwMQ48V0Gc0Zfx/G5+4VDvMTdWDMC6VIOKgJQh2CL3CqELZVL5n6iDbudDp18rRItnkXNUu6h63LSnBfZ7inrUyBEKP0tKTISPoWAuQCJZ49DFCkrLq/cNhQUzCZHz3qnWB9CA/JSeXyosh7zGKBno3hVP9WJP2pPp2Z+AcD/fI/1cqEh5gSt+wyON7dlkDogR8KKzty8kl5jFXL9vYi/gTuE0nbfqr07jBqDNxpLVv/8I96hVxYC1CSoeAEAve99OzEm3RwxaQlWJtik3Us02qaGyLiEPok+nIT7QvFKsMyprayl5JvCkw4TWKiumAEnriGBYI8ExbMqXelQf7U0Xr1
 SVrK1VSC
 xaSP4evuLudI/IRLl7NwNVmxKNsoWgleM0DcHojc95GDKejr1EX28ZOgFskWT6ErNXUihc1ueDKi7g0AfmohvkvL0+SYIIaOP+07/HTFFJGiAleGWUmIgh/53v+Xw7nPF4fhLmgJwbSyCZHkDEq2qmE+qOweZszvbBh0RZjMcpRaArhjFkPGKha1Bnofc04c7wil43rZxn1UWt/OROOpeSL7GW7tE5XSbUdlce34NuaUlyj8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugetlb-shm test fails if there are no free huge pages prepared by a
wrapper script and shm liimts in proc are too low.

Add setup of HugeTLB pages and shm limits to the test and make sure that
the original settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-shm.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/testing/selftests/mm/hugetlb-shm.c b/tools/testing/selftests/mm/hugetlb-shm.c
index 10e4baa091f2..e721ef17974c 100644
--- a/tools/testing/selftests/mm/hugetlb-shm.c
+++ b/tools/testing/selftests/mm/hugetlb-shm.c
@@ -29,9 +29,24 @@
 #include <sys/mman.h>
 
 #include "vm_util.h"
+#include "hugepage_settings.h"
 
 #define LENGTH (256UL*1024*1024)
 
+static void prepare(void)
+{
+	unsigned long length, hugepage_size, nr;
+
+	hugepage_size = default_huge_page_size();
+	length = (LENGTH + hugepage_size) & ~(hugepage_size - 1);
+	nr = length / hugepage_size;
+
+	if (!hugetlb_setup_default(nr))
+		ksft_exit_skip("Not enough free huge pages\n");
+
+	shm_limits_prepare(length);
+}
+
 int main(void)
 {
 	int shmid;
@@ -41,6 +56,8 @@ int main(void)
 	ksft_print_header();
 	ksft_set_plan(1);
 
+	prepare();
+
 	shmid = shmget(2, LENGTH, SHM_HUGETLB | IPC_CREAT | SHM_R | SHM_W);
 	if (shmid < 0)
 		ksft_exit_fail_perror("shmget");
@@ -79,3 +96,5 @@ int main(void)
 	ksft_test_result_pass("hugepage using SysV shmget/shmat\n");
 	ksft_finished();
 }
+
+SHM_LIMITS_RESTORE()
-- 
2.53.0


