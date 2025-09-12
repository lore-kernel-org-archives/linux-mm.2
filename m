Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C45A0CAC58F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 12:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D6D08E000A; Fri, 12 Sep 2025 08:31:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 286DB8E0003; Fri, 12 Sep 2025 08:31:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19D698E000A; Fri, 12 Sep 2025 08:31:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 082778E0003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:31:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8D1271407CE
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:31:07 +0000 (UTC)
X-FDA: 83880532974.10.19A7D95
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf28.hostedemail.com (Postfix) with ESMTP id C1E3DC0014
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:31:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="go/mh72T";
	spf=pass (imf28.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757680266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SSDd3589lDce7mWn/xMfh4M4+Y5+d+3xdB9BqMA2f/o=;
	b=uXifUCQO0bQfk0s/r2xCQByAtOzFAcWtm817STeqLaRbn6lmroZG5+LUfYC3bO3BhZZRay
	Lu15QiJn17DNL4qLgEkmAdmaEDJ12MDetjnNmDN5fjA3FJqroi5hE65tUlJeCgUS9OCvxE
	wAAMRcfhdkMMFRtl7gpIpIW/thQn62Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757680266; a=rsa-sha256;
	cv=none;
	b=zAJHQC43vfRrBsUbUhTFBDOTjhbGhurlQd65IPhhZhRk6I9xGiMEmU/Dw4F8yomQTG9ngq
	8oTX1IPIe7NiNR6PSh89GH9WXKZaTdS5I0GNvyU9aGWXVy/hy5mkkDhaUu5ZLRYErWJPfC
	FnQ1dnFldxog+Jdg7MrSO6/u0i13/s0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="go/mh72T";
	spf=pass (imf28.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1757680262;
	bh=elK2OVkAWNH11BVauJrIqWGv2pByY9tyO9tpXTGnLK4=;
	h=From:To:Cc:Subject:Date:From;
	b=go/mh72TQ1Tn0MxfuBEPSlQZlZ2MAaU5rge56NRLiCE9EFtlPr/l+dtaxj/bq+WMz
	 tcmOVPQt9BIoyXzjAEcICgIw1Dh0/DW1AB6HldjxO6mA4JFGS+UBf+Es5Nv+zaBAdv
	 4+5nlkpXS5MhUD2BW9xzvfqmWe9VM28nfqOdCxydzA0iqJusFNDFeCq2sgghEdkl5R
	 tnZSB4cENJySrHJ7dP8PxBLgqh7TWGFY1m3SGdFnWL7f+0lnjOaQroTrqqOm6J58HS
	 MEULQGyGsF0P2vMYTkTgdNX5qD/91P3Upl3zAP+R3x9CuJXWAVY9XEFg+MbY8oKbtF
	 7H7ESDQ3EI9kA==
Received: from mt.tail9873f4.ts.net (unknown [144.48.130.189])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: usama.anjum)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 4D29117E0927;
	Fri, 12 Sep 2025 14:30:55 +0200 (CEST)
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>,
	kernel@collabora.com
Subject: [PATCH 0/2] selftests/mm: Add -Wunreachable-code and fix warnings
Date: Fri, 12 Sep 2025 17:30:20 +0500
Message-ID: <20250912123025.1271051-1-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C1E3DC0014
X-Stat-Signature: swkmpow6mfrs4fbx5ooqw1hsbqxx8xyo
X-Rspam-User: 
X-HE-Tag: 1757680265-947004
X-HE-Meta: U2FsdGVkX19F8SxtNJoe5s3woRwjqygG+MyIXlyBIRYRILOq+k7YfLsNMUw2AqFvSr0JPrxhb/vyzthPEo3HNeZFwS5R9rHUbhGWjantBXXNONTKdYepPWVnO+mVRZn/7KQIiGs8nUP9uSOc99pgCYnNBwIZNbZ0wjkLNVMTLyGjdklJBDAi0g0R2G0Fa67LJ6iNwq4w9Jkre+Nyow8z9KBJ7pms90xhLmRM20s2qVFcO/oRs04je2sDqlZeBDIq0lDsTuLGmcHNgzCMjB62ELpTqz/XI5+qtxIqahPFd4SjdLlo0vG/eG31nDOGTYyWFdXK6xgzk0qvWu6wTzjTIGysiUfNDRPDZMSJM35GjSwVPgVbWdQsjehFPytlKMvlet8zjVRUM5eC/n0OotvqWWfF6k0jHIrSed/vX2FRaGQHxbRVewA7PL54u81WvUyij/YZkarL/J1BfUfd84tm0J3dwGsxoBQI/wW0/XYockkgCfaHElCFTn+g6PClyXVlzv3uB0L54AKfud/tkKIH23//ZNl3GV6F77XfsIbi+kSvOxSPcDd8l9oVC4HYBR2ZWWPR/b4PJxw8Zidhnf/levNo9QZqM2qfq9iNe/JHYa/ghe9YX3IEaYhy2bWwpOx7w8yo/lSMoM3XVxV5ySNiHKE3D8sYfcqag6Asp7TN7UPnnj36tBgMKfd7/s/l2tmRyO+lF07a0T8Gar6XIlP/90dF3jRbPmc77lM7TPMQaabrYT9uAea3b0EDeBeCDyCGT4KVU3l+mIuLfkpyXoI3IdHtCR36lzXyUqlIcQ+epfjKMQucF17+8M7n5RawoMfcjkPyfFv8v2ude/BRGL3tHgjNJycyr6mKlLubVQBsIuvqEM0jMLvviGiyu5m2QmrYGKMS/KFdJux6C1zz3r01Rt/ZF1w2BGrYpqU84bwS1pdzrheM0Ugy84EoKFszPi6CO7w8cOhG/aINXjWYThe
 S1H2oADu
 qNUr0cw1Egy+E03tUVFHBpDnK85vHaCS/8AR5nBCqKT31O/ezl4nrjIubkTRbj+cIlgGJei92ritVZl+ESnzrGT/CLLnlSBqW75xkFEPd7eZfY0ROKaddNKA5wRqGuNTu9visPKachYisrZOegIo4+27SaQz7KbO7Aemf3AnPCNzQPi/ipNa8hzRzq3IMkaFnXpBy0oHDxahUrgJSD0dZ9IORdlToRVTr0wKe0VD07BpcsdAX0IkpPQ1xj3ZoW81I0/qy1xrNAsdNNsG8sJPrFPJQkIKCGCMaSdkvpNTOH4yTr1tjjSTaiNJ4Qj0E9ATS0Xpp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series is trimmed down version of previous more generic series[1].
In this new series, only -wunreachable-code flag is being added and dead
code is being removed from generated warnings.

[1] https://lore.kernel.org/all/20250822082145.4145617-1-usama.anjum@collabora.com

Muhammad Usama Anjum (2):
  selftests/mm: Add -Wunreachable-code and fix warnings
  selftests/mm: protection_keys: Fix dead code

 tools/testing/selftests/mm/Makefile                | 1 +
 tools/testing/selftests/mm/hmm-tests.c             | 5 ++---
 tools/testing/selftests/mm/pkey_sighandler_tests.c | 2 +-
 tools/testing/selftests/mm/protection_keys.c       | 4 +---
 tools/testing/selftests/mm/split_huge_page_test.c  | 2 +-
 5 files changed, 6 insertions(+), 8 deletions(-)

-- 
2.47.3


