Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0924CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 06:15:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F48E8E0007; Tue,  9 Sep 2025 02:15:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A5F18E0001; Tue,  9 Sep 2025 02:15:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFD628E0007; Tue,  9 Sep 2025 02:15:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC8EA8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:15:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 88778140391
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:15:53 +0000 (UTC)
X-FDA: 83868700986.06.7068DDA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9739740005
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:15:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757398552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=uDk7pLW5RdL6KRa2+SwVBViRbOT0qnnkq+N3zgnMz0A=;
	b=c9Wb2daXrHAQ6cYMMneEsKpkoap+mxB+/Fh8OKdrhqBFrqjE46PaWkBmR2uruxRioGBodi
	Yns1apver8vwNug9ltJbhverUs2bhC09vevINltp74mkMZvN2Fu6njEkRKKDCAc64MNVgC
	4eOHZrVkIcSLoDX8af6QgiSpKVc0y9Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757398552; a=rsa-sha256;
	cv=none;
	b=kWSKqxtkvmENrxz/m2WHT1oAUYEU3eQqj3y5C8S5pE+wZWTQ+Z31IMHAbNTZE2L0Laee7f
	Ev3MxKeKY+lg0R3w/pe6pg8gfMkxzes+B2nMeskm7AIrgmdqMz72y4CGek7J9/67MfhVny
	4PtoO99YPadYwd4IEtW7pxrn+jCddqE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2590B15A1;
	Mon,  8 Sep 2025 23:15:42 -0700 (PDT)
Received: from MacBook-Pro.blr.arm.com (MacBook-Pro.blr.arm.com [10.164.18.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 52E1C3F66E;
	Mon,  8 Sep 2025 23:15:46 -0700 (PDT)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	shuah@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH v2 0/2] selftests/mm: uffd-stress fixes
Date: Tue,  9 Sep 2025 11:45:28 +0530
Message-Id: <20250909061531.57272-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y3dbbxj5oxpk1y7id43gxz1qseeip7wz
X-Rspam-User: 
X-Rspamd-Queue-Id: 9739740005
X-Rspamd-Server: rspam04
X-HE-Tag: 1757398551-109247
X-HE-Meta: U2FsdGVkX19/MLei2kbIfTb0jm3+Gv2RmBqPD1UqhWw4s5cnSgrEqeGhigQaiPV+iFPJm491/jHMNb92meJxCGD/xI5fzgKYYdDj8/umpn9rjKuZ2RPoTx0B3uOBZ8Cea/mgZowFq/Gv9vLdDduvWiznlAjG3x0HgfJpozmy50Ly0Lr9rF63G0kYzQQGgYIowYt7ZzDxVyxB0U4mzrntQAVe1A16pGeRrum1jPOAlczN2mFJn4FBJ+msFKLI0v5ln05lefijuYxUyg5IA0wH9teSgMCcF90NjV6zxtFtN9w56SQIc/EGtTJ4bWpCnDv+qycIfkMRDRW2B/OwImd9xh/I9EGIotHQEn5/iXIIjJ11aBQpsjLEBBuakB43zRyLk3fvRpP+LN8DxEvbVtfZtU7Q/U9d/cL3K2GItaGLlML+kVP7mw0v3Yypc/bGpwQpeTjjFniO6WlCTggAODIlWqhWVmunVbKmoJLmDBrbsc92MqA3gvz60AJ08d+c+8mK9CV676Wyqdb75VAPm1jnej3/I9p+2zYPAua3KCFYiXX88TRsr2lodNo0mLdnHJ+D02aB/Vgv4A2NdKFOIuKjFc1jXzR/ngC5aIlIZh0Hg/IohVgc0FGzQVc31jTh3XUQu05VXfh9Z8BQNdMpCiSW3FQuk4cgmvc1VASiSXGVfBhaCXX4zVcgryTMkt98u2aCngxfvonCIqepIhQQb4Mk1buQvyyfzkG9vcFPxFFKPzkVj4kAHHlQxeh/b3Jv7XPD7Zw2e6GDDHqMXpdHHYKXd4ITbMeuL1AKrUY+XHUmw127OsTQMYMADQaCRW6b5mOR7q+eqzB3A4GH++RJ7pb3AoWbIlBrsHQ7V3ik+QtGHONAn972N2Um+6SVRJvRwvrN4lk3opGriH9FH9JVdEiX6H7kNThHIuKLtD71KZetVQLXIiew+TNFj81MHO60EgpVIGJHAQ06FT0S8STFf6W
 8hhtl+MR
 5PDQPczTE/6lRovwQXTjGD0J16n66n1MjXIFZz9mLDXqkSRU89ZHsR5uE2AmzwIBC7cJqT97S9hS3WTXYSPPfnBYIaY5MjvDpGu8s
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset ensures that the number of hugepages is correctly set in the
system so that the uffd-stress test does not fail due to the racy nature of
the test. Patch 1 changes the hugepage constraint in the run_vmtests.sh
script, whereas patch 2 changes the constraint in the test itself.

---
Based on 6.17-rc5.

Dev Jain (2):
  selftests/mm/uffd-stress: make test operate on less hugetlb memory
  selftests/mm/uffd-stress: stricten constraint on free hugepages needed
    before the test

 tools/testing/selftests/mm/run_vmtests.sh | 10 +++++++---
 tools/testing/selftests/mm/uffd-stress.c  | 17 +++++++++++------
 2 files changed, 18 insertions(+), 9 deletions(-)

-- 
2.30.2


