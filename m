Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0364DCAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 03:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30DDA8E0005; Mon, 15 Sep 2025 23:23:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E52A8E0001; Mon, 15 Sep 2025 23:23:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 221A68E0005; Mon, 15 Sep 2025 23:23:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 109288E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:23:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A1813C0805
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:23:48 +0000 (UTC)
X-FDA: 83893668936.21.06F5D54
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3410220003
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:23:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ULJFTSLE;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757993027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RZNXQchncEh6YZP8UPNPAxyjnSFPIeBSxhTNgs0G2Lo=;
	b=K5BRBfEr+rS+4clMtj7PmCrs4QByv7PCurcLeFs/ZjsS+t3s1YewFdBFXVMwzDZM8+2gxY
	E6Dlq3s4b40AoRSUW+ejLBBuuE2wOZPmRVq6k2elaNG+oQRRUZZHgLb+WYKUC/7HEwc18A
	mdSZ4lcHGQZb/pewGwZgSlJegZOHJ+U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757993027; a=rsa-sha256;
	cv=none;
	b=3fC+dP+WIUEySKPEamnxwCahIkDsYLBFWJd+yXrXRzoxxwpBCHZnXvfzLSzoSG7Yo/i9xj
	wEMiIUDT3tiO7w7uIzoHsLnLYMsbOzs7j8RlHC7swcUADr4n5wQhlX2emyMklRV7Sg/pUE
	Abuk+SfVOdEffA443fGjHswfa3L7rbU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ULJFTSLE;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 94CFE60054;
	Tue, 16 Sep 2025 03:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03CAC4CEEB;
	Tue, 16 Sep 2025 03:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757993026;
	bh=4jBYgC3B4Dhd303wNeVwtug9xXIozvpiLACdj/mfJYQ=;
	h=From:To:Cc:Subject:Date:From;
	b=ULJFTSLEjhLTnYaJ8VomtdHFO0MK/5GOkZ22GgT+1bTFxtoBt8+GSa5nq8l+JSY1f
	 2Y0nDf2wb4/7+ttj3lRbssKPjo1MyXHGF6inHxMejvMLrP3n68iBYHREs7X8G7V1lm
	 giNsIqwwFwaan3hOhWzCB4mcR7KcQcrr1gbTrrXRImM3lBqj8zTPva1CSisUxEvZcs
	 OuaEHZ0w6ex5GE50uPoNp7Jc4lHxS7dtNYdI+H14S62t31ACopua7aXA0HeOCFxyoM
	 CjYlfVciNMpRRP7LEVbC461b4yb1YyeKbGHkZAUuKIB3+tkJglb3ilx64ZhE/QwyPp
	 o8S6g+oqUbS6g==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 0/5] mm/damon: misc fixups and improvements for 6.18
Date: Mon, 15 Sep 2025 20:23:34 -0700
Message-Id: <20250916032339.115817-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3410220003
X-Stat-Signature: p8gjuyc66898nck7xcmq793icbjnjo75
X-Rspam-User: 
X-HE-Tag: 1757993027-923869
X-HE-Meta: U2FsdGVkX18T6cr20mMyBmO9hbIm58ZqRYRJDaPln4r0W2VjQ3AjRRk9r7dQ8tZKql0J4IpXpMtYWgbUNy3hspvTZhejY7gGzdoj3N/k/6T8Uc9m+pEgiF9pJl001WK6NTxsrX0oMYUaaymi560I6SetjdtelkqBNel5yP3BtnaJehEf8wf/Hfz9pb/TvoS05t51w3qDUg9axfX6SOVkv5RqUwTrvIpplMUufBhQtHTZLxB9UUqgq1ugU2aO7JnJeGz2XhfOp6jESSc9NkGRkZyH39YByr5VIPQKpcNvttoh/oNZ2n5q7gkUFJdUFyxJXJzyiMfhJS5WunV6OylNYUAJeGuEDBXk2L4NoFdMjwDnYXFA4ogsOCWL0+g7eKbt5+3MaiqSgHO/oTa2RhWFskgVebO/vofZN+182pmUFd0tNHggeutHmHaKNcAJItnMYrUEVsja2fZDzXX/pwFlD+6vek3XxjIBnYJVj4S7Uts25qpbYeyjZoQPYPt3x7w+3QjPSWNzUCMnVca6cDn3H4m+IXJ5husa/UjAFPiEB9kHC1cgw0LV8OF8C8ri+AElEveKGo3jaf0tqqvmnvOrmVpNUK0lAHl8xm+OwZnhSBbrXmSUT1xlU5zszvqrVzf1jMgVdQF6rAMsnwdgLItXrPqb+mVQgxdjLgYkUV6+pKpfcFAH9xTkFBV8Vr7lVuRIUJmdD5zyMTcHIz02XIe6ADy7WbwKXsrp30md0cS2O0d8mh8KTeFSWdgWCUM0aAZd1MNr2McPR54pFm1Q4vmrtHb1KVmdQaUKofzRvr77a+/nbg7RlV9L1R9fZE4mE/0zaxhYuQS1iIXTi0iXSdRiGldz0Z0BW3hkzH6DrL/hIKLPkKxbSjdeOeUFa5DGJU5mmuwdhoY1Ew2PQAPRa15Piz0GsI1lsra+ipktDHdbEeG/wCf2Drmv8UCAgNI9y8Pf0M7zi0a3qlhHPBpVxH6
 mEtYjCvs
 D5WA+IK+2knRc/mTi/jVTjbLc2MIJsDldrCiqQ2VqlqGdc4BLlHN9tTqDxKPubDiaHsNxO61ApUMZ7s5MgliukLfduDB9wSKOyTICjBnv373KgOSgLJdpsInqcTzcKVew0UBzr/qqMONIdb2K9g2E5hbX6fMFhKW1Pnm1v0pMt8tIYCPGjM8egbXiT9If6LWbj0DyZkFvtow9TPfMMG2NmTrFpX5swFgcqOjggNSlaKf2fMo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Misc fixes and improvements for DAMON that are not critical and
therefore aims to be merged into Linux 6.18-rc1.

The first patch improves DAMON's age counting for nr_accesses zero
to/from non-zero changes.

The second patch fixes an initial DAMOS apply interval delay issue that
is not realistic but still could happen on an odd setup.

The third and the fourth patches update DAMON community meetup
description and DAMON user-space tool example command for DAMOS usage,
respectively.

Finally, the fifth patch updates MAINTAINERS section name for DAMON to
just DAMON.

Changes from v1
(https://lore.kernel.org/20250915015807.101505-1-sj@kernel.org)
- Separate [1] damon_attrs param_ctx usage as a hotfix patch
- Make nr_accesses reset condition easy to read
- Collect Joshua's Reviewed-by tags

Changes from RFC
(https://lore.kernel.org/20250909034353.7064-1-sj@kernel.org)
- The RFC was only for the first patch
- Rebase and wordsmith the first patch
- Add a few misc fixes and improvements for 6.18 to the series

[1] https://lore.kernel.org/20250916031549.115326-1-sj@kernel.org

SeongJae Park (5):
  mm/damon/core: reset age if nr_accesses changes between non-zero and
    zero
  mm/damon/core: set effective quota on first charge window
  Docs/mm/damon/maintainer-profile: update community meetup for
    reservation requirements
  Docs/admin-guide/mm/damon/start: add --target_pid to DAMOS example
    command
  MAINTAINERS: rename DAMON section

 Documentation/admin-guide/mm/damon/start.rst  |  2 +-
 Documentation/mm/damon/maintainer-profile.rst | 17 ++++++-----------
 MAINTAINERS                                   |  2 +-
 mm/damon/core.c                               |  6 +++++-
 4 files changed, 13 insertions(+), 14 deletions(-)


base-commit: 4178fb3b4a5145053746caab556b1c5f5538bf3f
-- 
2.39.5

