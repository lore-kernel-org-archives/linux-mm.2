Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96413606A339
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=IhdNOBCZ
Received: by kanga.kvack.org (Postfix)
	id B80D16B05B6; Thu, 12 Nov 2026 04:03:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B312F6B05B7; Thu, 12 Nov 2026 04:03:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A200B6B05B8; Thu, 12 Nov 2026 04:03:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D5256B05B6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:03:09 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1815F8043D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:03:09 +0000 (UTC)
X-FDA: 85425877698.04.0F622CD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3470020005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:03:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=IhdNOBCZ;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794474187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VFkjE7hl/1Y+MIeA6I1Mbsc5quayUb/zf3n6+YoAoZA=;
	b=5qvmmgRcxdX3TItN+JyZHqmah47vrVPnps7Pkhv1O/ZAgx93n5AJ7ze/XS4TglliOtAa40
	+s5DRTez30NpCKSS1DAe0jtDv3VtpDY7g82MqzmapOOtKCUhukkRakL4Odft5HWqiCJo+h
	dzMEY/gL9UwjJAc7LLlrVifLy537ElI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794474187;
	b=OG6pWhT++GgFyjKarUOoGAuhLixheAs0smPZdTmDO/2nq+rABJTueZVEpyGZVVhTnJO0IP
	L3ckT/E0pk4jcEc+JKONP3kKbp2n5ygoUoLPLgPZGYQheZpmRmHscWYO6kG47x9Xd2Ws/+
	5gGIbovgr2sBAMVjEvR0xeEVwGO794w=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=IhdNOBCZ;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB1CA339;
	Thu, 12 Nov 2026 01:03:02 -0800 (PST)
Received: from a081061.arm.com (unknown [10.163.169.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 498733F632;
	Thu, 12 Nov 2026 01:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794474185; bh=ypZh11Db/XggA04FeV2gzYgFOL4PpiInmAMkq7Td3OQ=;
	h=From:To:Cc:Subject:Date:From;
	b=IhdNOBCZekiKgqKy2zdq4fN5Eo5epr0ImKCXrbew0Y4SkkZusj9zkAshr3fH/ceWz
	 078/HWVuKDQWstIBxdRn8PRVUWH5rzCLcfSXVxRnkPidGUHMtpguIbGwBras7lCpni
	 qhIrxzx+MFrAM+Z9oKW7tAAt0vD7w2jPaDf/lu3o=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH 0/4] selftests/mm: replace transhuge-stress with a THP compaction selftest
Date: Thu, 12 Nov 2026 14:32:46 +0530
Message-ID: <20261112090250.334344-1-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 67x171k67533hggn67pbkynsw3u78ffj
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3470020005
X-HE-Tag: 1794474187-914795
X-HE-Meta: U2FsdGVkX1/k0zgy9na1NufmaLdmkH+NJ04br2vQ/mxWbnY9hN/cJTBmWzqCW4C4FPrSEoSAztibrvk56gEOlnriSfgzkQTGhwwp6RcKk8+KBwTd8HZ+NOb5m2/QzBK2ieByhfOANuyZNqiMEhZMV7yzuc66stmC/d3DLUbfcSjJlpCW0BtSSXQ0EK4+hkOO+LMGIviPaYw9GFUiw9hfa02vVAt87utySAJd/NR6g4KqQJr+tRlD5IzVZ3W+bUMtTL2GIPa0vzcTcXYNaI7rsq0+JZxn3bUcRX+JuIn1nf6+6vHOdgcnjamDkKR7luQX+YAzvm6v1xcjSiT9qNng3+68NUFE2GTi4wpwOljrnGBGOLn6OZX1eBhFdUdc+qLpP2KedcsF5E0DMjwdWOmm4vOsRo5ThwcM1uLYfGfcYzqpRQbelFVnvA6lZnO+WPM2WIGdapBm4YsU+outWlQn0LfDwIGadcYO76k6yIfHACQbTgoSZ1cXq0d1vTplS1dKBorBII7I8msQSlUKjgUTRp7JzM5sIKzaiBsR7ioJuou3Z6TUfcHU6zLhFQ49qitlM72TJaJWBUODBX2PWhKwHACUQDd34XWBzQJnMarI7avolWW3LiNgyUbqsQi5F5XVlYQaEO5s5L+Ux7sUsDdZABfp+yUEnjh1Qkzr6l2s12PBUzKU3N/vC8ewRuX2EUZo81iCE/g2o5xQoYrbcudmJFmBA5LSAMMGPgD3RogBjx6a1HZiD+QTCkHMoj9RHfdu8EySLDQJdiOl0LRSYBsc03QD+q1221sNXr8yl76eu1j42Yr3f6IW4MHMQBrDl6F3+aSumlhkW8PC7hFL9oUX/DGuvfCn5tr9aTLZWfiPdS6EbfIuf2o6ISXvUGSBD0X5uayzdpcezBw9r6c6KvAGJ4+I0i856ycnh3vkxlnfK/CNspl8cof3z5YI3/HSbnyTea7WqZvCxBuXjz+W/y9
 Br+KwMG3
 OZhrlW4SPKFu3wvx2bLsiU176sgXfl8cIienjZXuXtzD6cClnz8PVFuF6LBUkDPaRRK0CA3613M8XbQWDZSyM6+9F3o4TMOB4e/Ze2+EXQmMqk5PEls3L8mZRBZMYK98uGNnfajHFtWO6dDWSICAU7yMhFUlfMtcONE54Kl99tAwoukXMQR2BmI2XTH6Vhb5dKv/so0kt3jY6tDqUocsQFbSaJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

transhuge-stress is a stressor tool that repeatedly
allocates and splits THPs till a specified duration. If the
duration elapses, the test passes and fails only if a setup or
system call fails.

This is not how a test residing in selftests/mm is supposed to
behave. So remove it and add a new functional test called
thp-compaction.c, that allocates THPs as much as it can,
splits those THPs keeping one page retained and discarding
others, and then retries allocating THPs, which will test
if THP compaction is working fine. If we are able to recover
more than half of the initial THPs, the test passes. Otherwise
it fails.

This was suggested by David earlier [1].

Patch 1 removes the current transhuge-stress. Patch 2 adds a check to see
if PFNs are being masked due to no CAP_SYS_ADMIN in the initial user namespace.
Patch 3 factors out THP split helpers from split_huge_page_test.c to vm_util.c.
Patch 4 adds the
new test.

[1] https://lore.kernel.org/all/94ace42d-8d60-4475-953e-74fb3dc23774@kernel.org/

Sarthak Sharma (4):
  selftests/mm: remove transhuge-stress
  selftests/mm: detect masked PFNs in allocate_transhuge()
  selftests/mm: factor out THP split helpers
  selftests/mm: add a THP compaction selftest

 MAINTAINERS                                   |   2 +-
 tools/testing/selftests/mm/Makefile           |   2 +-
 tools/testing/selftests/mm/ksm_tests.c        |  26 ++-
 tools/testing/selftests/mm/run_vmtests.sh     |   2 +-
 .../selftests/mm/split_huge_page_test.c       |  45 +---
 tools/testing/selftests/mm/thp-compaction.c   | 215 ++++++++++++++++++
 tools/testing/selftests/mm/transhuge-stress.c | 146 ------------
 tools/testing/selftests/mm/vm_util.c          |  65 ++++++
 tools/testing/selftests/mm/vm_util.h          |   6 +
 9 files changed, 313 insertions(+), 196 deletions(-)
 create mode 100644 tools/testing/selftests/mm/thp-compaction.c
 delete mode 100644 tools/testing/selftests/mm/transhuge-stress.c

-- 
2.53.0


