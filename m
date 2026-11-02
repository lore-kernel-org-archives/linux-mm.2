Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0994606A32D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=NJS9yRpP
Received: by kanga.kvack.org (Postfix)
	id D92466B05B1; Mon,  2 Nov 2026 05:02:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D430E6B05B2; Mon,  2 Nov 2026 05:02:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C588E6B05B3; Mon,  2 Nov 2026 05:02:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2FBE6B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:02:32 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3631280C0D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:02:32 +0000 (UTC)
X-FDA: 85389739344.06.6B2356D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4E27F100008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:02:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NJS9yRpP;
	spf=pass (imf05.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793613750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=W9ES0MdL/PxxpQ6IyNXfcZ2egSpleg7sxTTOorn7k2o=;
	b=w0Oux0OkJnhwu5IYYorOoPbSFgLS5A5zhJFiqiT+IjN4V6Dts/ZbOearGDZm6rPK8R5M9M
	J9M3eYlmowsQjhzUFBRHnpLSQ7Mz7qUT9memLBB4G08ZmADyRjGi7r2m7f4WW43AEsoBcj
	A8QJ9NEQtabDJz1rVFG1ulYkF1xsT4s=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NJS9yRpP;
	spf=pass (imf05.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793613750;
	b=cxyjFC479yAW0yAwMdcrL+SdxSxqaHJYhu0w0t+CBF1GWAGr+oBl/jwy/pfN/V6uuoOs4T
	zWFSGHmdA+WBYqGO74AV5SXyoiRcxVJYlXZjq/JlGRu0iIujGrvRbrMZCjIVYFNOfjS1gs
	uS4eEY9PAhmqSsEfY7hKZvwjs0/XEgw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2CFB71595;
	Mon,  2 Nov 2026 02:02:26 -0800 (PST)
Received: from a081061.arm.com (unknown [10.163.156.187])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id EEDE13F59E;
	Mon,  2 Nov 2026 02:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793613749; bh=CWd3JrR/28ban77aC5ukTIuSZHmjR150vlaanvtwD58=;
	h=From:To:Cc:Subject:Date:From;
	b=NJS9yRpPJ0mwANfpaNDgHapiNm0wUXsKOOQhKctdse7NVjXIzOdEVbULyGILaOUUo
	 bJ6sMPgulpbJHri3Ts/Uj7EPudgkIZBRh5e4ApzBD2p8r3x6FzMTUHa1QumtI44Ltz
	 ZMYEaohBrYzoTt6Tdrm3qTvhQ7Q477frqfLJ5Fh8=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Park Tae-sun <ts930@dgu.ac.kr>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH RESEND v2 00/12] improve mremap_test
Date: Mon,  2 Nov 2026 15:31:59 +0530
Message-ID: <20261102100211.141831-1-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4E27F100008
X-Stat-Signature: e4pq9ms6ird5z4dbb9cxthi6s36rw1o5
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793613750-250682
X-HE-Meta: U2FsdGVkX19Mu0DBBed90xnWqzia+vxXD92hg74s2bR3Y7WXKlr9M2TtXOjO+e8Z/eYSilcuqVB33tb+AN2UKT0ro6mSns3pinOuTUALHyUsvCp5ylc7l32P9TBYa8SqnMkT+ZD0ItZ/+GoQtP9q+iGiYPu9o37v7KAvsW51H8JmxcqWjVD4+3S2PaEzxWBnJNw9NZbxC0IAoiqOpSJC2hmmYRUXCCW/9BtkOldrfK8yK2SK2wC9H3YCfO/HPUelkuZgmY0yuJpWUFw6jA0Awta1SZRbhA9qKs41av+q9n6AmSqgn1t4/fjl+X5bTLoaqzhh5kiUgm7hAfd4BlKlYA7cm08paovXXULW/miqJOhgCo8cFuTZCDaA2304FnfN7kCE7ZnOFF+OuDnnG2G3hCabX4V5IXxnBApfnX3RUZ/8lR2iYoAfXqirh+R9hjVZ1g60HMsX5C9SCC2ARkksYgESdvCfkbrLki+1h7LBrJ2C2HNEhUkylIsfP9X51ZvLKJ/ViM7ZSfZEVQsbq+vcz/4NKgJ40DCoEnYo/y46C5D6x4et4SyWW6Rf7Yq24SCiBxBZ6tfrC9qXSOC4vHAaUKJppuRKXoaJ1JG1iutUMmr+iaMFcfUrNU+amsnVsrIkK7C0AQCDn5VBvAOgaOllx1yAMVfOXdlUlp719LDEP4sMHPXM0tEcR2hoL6Uu1Vr130woBF/zQQ84VI81+0jTMEh+0+IqWkF2SM248inyNSj4Z/cy5ownIG3BIKUV5BK2w88LYfC/8rxYhrc4gusy/ykpzamwxpzCNDNtf6oGMhMnjYdkBALnF1Hkizkl3aXKYYfBgvqhMo2mYe8x5mNoMmzRsWwCZ68woiZ3bcgiTlH8GbBrjsrPKwQfBz3EnHq91o8X3MJ3NmMkUhEbQv6IJg6h8hMqrt5+Ua76IpICZNWcF6fBY/TQ9V2ABnB4pc9qXYi/Gubwa40VRflP4Ox
 uHQpJu3I
 vhopU4uShwCKNc9+SEBoWcHlA2NrMwDd3ekLw35AO7e+a4/enfzqjbWXOl0JgVvTGy8n8IGFexbMhha0wG6kx/g+9uKE5xLQOEE4tPxlYKcKYI1Kik0zr7LP1jocyiyBL6EJB+En2J9Lv+ylf8c31iw55z4LgbtS8ytD4qoDYivJVcVkV5qFuyYmNREL0M41jeXNX0s7uFaiCeSqNvr+iTiAHPCyL9hORk87fbcGf046hInjkg1a2jO99T2kK1oPIV7LmB/NBB0jU1HSRu5SOnWqAT3DUEN5YIPhaMk9o36U79MIEohRfnPI52o6TJfo7jgbZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series fixes correctness issues in mremap_test, simplifies its
test infrastructure and strengthens validation of remapped mappings.

Patches 1-3 remove unused command line handling, unnecessary cleanup
checks and redundant errno handling. Patch 4 converts the test to use
kselftest helpers and removes manual failure tracking.

Patches 5-8 fix handling of unavailable userfaultfd support, unexpected
mremap() successes, data-corruption failures and cleanup after mmap()
failures. Patch 9 removes perf tests and timing infrastructure.

Patches 10 and 11 replace threshold-based random-data validation with
sampled validation and a deterministic data pattern. Patch 12
strengthens multi VMA validation by also checking the mapping state
of holes after remapping.

This is a resend of v2 without any changes.

Changes in v2:
- Add a first patch to remove command-line options (David)
- Add a second patch to remove munmap() checks from cleanup paths (David)
- Add a third patch to simplify errno handling
- Drop the "correct multiple VMA range size" patch
- Add an eighth patch to fix cleanup after target mmap() failures
- Replace fully populating and validating large mappings with
  populating and validating 10 pages each from the start, middle
  and end (David)
- Extend multi VMA strengthening to userfaultfd multi VMA test
- Fix minor formatting issues

Previous versions:
v2: https://lore.kernel.org/all/20261006092511.145776-1-sarthak.sharma@arm.com/
v1: https://lore.kernel.org/all/20260924050009.19974-1-sarthak.sharma@arm.com/

---
Sarthak Sharma (12):
  selftests/mm: mremap_test: remove command line options
  selftests/mm: mremap_test: drop munmap() checks from cleanup paths
  selftests/mm: mremap_test: simplify errno handling
  selftests/mm: mremap_test: use kselftest helpers
  selftests/mm: mremap_test: skip test when userfaultfd is unavailable
  selftests/mm: mremap_test: fail unexpected mremap successes
  selftests/mm: mremap_test: fail on data corruption
  selftests/mm: mremap_test: handle cleanup after mmap failures
  selftests/mm: mremap_test: remove perf tests and timing
  selftests/mm: mremap_test: replace validation threshold with sampled
    checks
  selftests/mm: mremap_test: replace random data with deterministic
    pattern
  selftests/mm: mremap_test: strengthen multi VMA validation

 tools/testing/selftests/mm/mremap_test.c | 701 ++++++++++-------------
 1 file changed, 291 insertions(+), 410 deletions(-)

-- 
2.53.0


