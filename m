Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4EE5C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:20:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9BFD6B0096; Mon, 14 Sep 2026 10:20:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C254A6B0098; Mon, 14 Sep 2026 10:20:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEDDF6B0099; Mon, 14 Sep 2026 10:20:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8AAAD6B0096
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:20:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 10613C0171
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:20:03 +0000 (UTC)
X-FDA: 85212577086.22.FC2654E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9542E1C0007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:20:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aOxl9EV4;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789395601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Xe9pCAP7+znsH3YX32HlW65HgZEqytv0rSrycprzx2U=;
	b=zZ+jRua0v839zB1Sspo39Rzcjosvq+3nEUXV0Vtag3g4aJZ932cZfzbJahkRIprsmpYh0W
	3+0m0FL9/7qnhLpQtkyrQGnkA+yCDN6SXcjt/9nGCENKPw2aMetYUq/IKsnwo9GmpgvjkT
	Em2SmEgtuczUpe/CP2exFbVGpabhRE0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aOxl9EV4;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789395601;
	b=jqaAJM+Q2T5yKuy7WcLroZxvud2KSUey8N7s0HYZwlz3xLAo5xuKGQ1pO116UOYfTclIf2
	P3jlzKxyoZzX301d1a9hQCx81UyKHWepdPKE0lKYDY8aMEp+xrMkTXCux6sRDzoYHa4H3W
	AKsuRmF+TBDX86PhJGnikRJlXswPRFE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 17BA3601EF;
	Mon, 14 Sep 2026 14:20:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF401F000FF;
	Mon, 14 Sep 2026 14:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789395600;
	bh=Xe9pCAP7+znsH3YX32HlW65HgZEqytv0rSrycprzx2U=;
	h=From:To:Cc:Subject:Date;
	b=aOxl9EV4HfSn4CW4ndI8Yc7wmc+68nQ/AG7gNNVkiYH+WZ/fZX/7xfou5DflqaULS
	 lcLmDByziVNq0IgTmy0cqm9KA5KSuXP+p1WglgvPGKksP5/7kx4kEAmyPW5UyheGNI
	 C/XgdTjlg0zYIIFnR69ygbDwuI4DUke3vlA46dbWm8RBXjz3ZC3FtyiISJhTXHcXtd
	 LG8nJFRUTA5UBX+nMAViIamKQ/ShECpxvjzgvLm2u6UgOgFpYhzIxIXLWda3ZXu0gT
	 5L1YRjxd7+KUUPCyMoTJjDYgQ+8U/M3+uvoCct07REl1W6f37ygGoq4imEEiHkAhOg
	 yRh0Y/qG6F0ug==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/6] mm/damon: misc improvements in tests and documents
Date: Mon, 14 Sep 2026 07:19:45 -0700
Message-ID: <20260914141952.91465-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9542E1C0007
X-Stat-Signature: 9z4p7pmba1pfw9zsujyj71w8btseokin
X-Rspam-User: 
X-HE-Tag: 1789395601-144065
X-HE-Meta: U2FsdGVkX1+4y5lUNOVPSb5nSoskUQ31EQx6eYbfBK7/BSMqt3Cr96CkeoZhQVTuphLqzt2uMnVY/AmWpjglTZ8VvhU1hjK+sDd5ScJ57CcP69WKv/qDTg+2UTOlrqUNKRpGRO59QmYG4YkCeJulC9nxm5mGX0ebEgQyo8585gG9KofBteyNWvTtDUCP05Ct8Xt1F/Wz6U34+NPHtgYVuYbWROQHxCOS3xI0XppW7Xi6XayYNttickgDfWR2TvFHcT1KR633jrRziV3tWqdBHZxCFO4oSH9a+tUeZoXmSKYp5puf45cPsK+cYYZ7bmk+5Peu0RUEF3Enees6CsLI/SIDQi4DmkPkVHkRdXj/eL5HC3NtROxW34aAzUo5hdXhr85Epyaqz/n/jl1puzJmcRhXoOFzPBxtQQVIJhPbfAtOW8tcmbFsNvVsWyDF2Tly2jCIKepnPa4MDZmKLD2N4UdEIoJjdNKGT3JBp9HOfAtnjTKG5Gw4vPkXrVjGBxLNky/+Txin6STfDgDaHyn8eSJeAM5eweWtAFVX1jt4h5W+2JPfq/P2waNLYugiVHDrZUGS2muagZxqPZro2S1QYI1z0pkeb6gUxb5d7vvtRKC4jbOXl7kN2lVihTsfmiVTdyojSYe/Pp3cFoRRVC5J1TEsazJT8SU80pFedD4PVcpjdmRbttw2azBBg9vRckVanIhvJHeLlM4aPInvacMxPmHiILTEpWlJQJcb66fu5Stm2PmhUrx+0/eYMYqAdwW+XuXQ1uGWGOr8639oeZu8iGoNJk4pN3XmsfyeEHkf2EcMRMTTZgamoQZnWTGtj3UyIJXUm2t/H13oDSCue9L4uQLHKt7DCpHXvjGUJ5585heYV0MZR5G/1Kat/oly97WhZ/aH/jwk5UfvY6poeFiHeOeFXbW5ZwvzEVyzxNEMTkTN88iKugnAs//o8X/YW0v3FzEzsUmyCK9Ks5CM2v8
 7+V9/6wy
 4h7csbA0wEcA4Jz2Yaqc+ZYFzT+RPQdQnGwbTxVzKPY7gFU9cwsDgxum4EVfooAM1rjC6xG4FaCTvrZvQ/Ui8n8iyEjoQth0Nt1NB9FvxfVtS/3c7BnQjkLzdqlmozR3v2BD9GN9gR0yknti6UX7GXquFTM56ZgJ0J2UywLo7PqI2HTSwCizkasKnmvPu3ke96hQm8quiwcZtfLY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add various improvements to DAMON tests and documents.

Patch 1 and 2 from Zenghui Yu (Huawei) let DAMON selftest to clean up
its state and output after running the tests.  Patch 3 from Eva
Kurchatova makes a few selftest be able to run with Python's safe path
mode.  Patch 4 from Kunwu Chan improves coverage of DAMON kunit tests.
Finally, patches 5 and 6 from Liew Rui Yan clarify and fix typos on
documents for DAMOS quota behaviors.

Below are notes that can be removed in the final commit message.

This is a batched repost of DAMON patches that were individually posted.
Please refer to each patch for changelog.

Eva Kurchatova (1):
  selftests/damon: add script dir to sys.path for PYTHONSAFEPATH
    compatibility

Kunwu Chan (1):
  mm/damon/tests/core-kunit: improve nr_samples_per_aggr test isolation

Liew Rui Yan (2):
  Docs/mm/damon/design: clarify when qt_exceeds increases
  Docs/mm/damon/design: fix typos in temporal auto-tuning algorithm
    section

Zenghui Yu (Huawei) (2):
  selftests/damon: stop kdamond on error exits of no-op commit test
  selftests/damon: ignore test-generated damon_dump_output

 Documentation/mm/damon/design.rst             |  8 +++--
 mm/damon/tests/core-kunit.h                   | 19 +++++++---
 tools/testing/selftests/damon/.gitignore      |  1 +
 .../selftests/damon/damon_nr_regions.py       |  3 ++
 .../selftests/damon/damos_apply_interval.py   |  3 ++
 tools/testing/selftests/damon/damos_quota.py  |  3 ++
 .../selftests/damon/damos_quota_goal.py       |  3 ++
 .../selftests/damon/damos_tried_regions.py    |  3 ++
 .../damon/sysfs_no_op_commit_break.py         | 35 ++++++++++---------
 ...sysfs_update_schemes_tried_regions_hang.py |  3 ++
 ...te_schemes_tried_regions_wss_estimation.py |  3 ++
 11 files changed, 60 insertions(+), 24 deletions(-)


base-commit: d1153a22117b5c6171bdf24d32b7f6c314887d23
-- 
2.47.3

