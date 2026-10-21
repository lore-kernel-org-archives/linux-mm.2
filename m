Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC4AB606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 18:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=Y0nGvAzD
Received: by kanga.kvack.org (Postfix)
	id 18BB66B075A; Wed, 21 Oct 2026 14:11:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 143BD6B075C; Wed, 21 Oct 2026 14:11:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1ED56B075D; Wed, 21 Oct 2026 14:11:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C37216B075A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 14:11:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BE906160649
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:11:18 +0000 (UTC)
X-FDA: 85347425436.17.D3EDA9E
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf22.hostedemail.com (Postfix) with ESMTP id DD6CFC0002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:11:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=Y0nGvAzD;
	spf=pass (imf22.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792606277;
	b=Ik4nLt1uZKikEZpK1LotK4ybim3lhFG6qJqWoVZ9gMNmHvnVvKzPWs/sk0VeaekHjpBd1G
	q94b6p6rRZpssyfmxELn47CvaqG9ZNmuLSPtHUtZIyDU51OdrJGvNIUCM1y5033jcUvIUJ
	kXToxNgBSrUr3qSsIaD34u7g8jfcJJk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=Y0nGvAzD;
	spf=pass (imf22.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792606277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SBcAfdk1AvTqfXhE/cLVYMH0/26jRBw6wDx068f64L8=;
	b=WYXUrObKGgifm5Xqa1uDM4g+jqjbY0I50O4VuZOJXJmIcY7qxWJkIH0tlTnpWJ26iwX85Y
	ScjMcgCEDd0GSLealZKZfP8V/gYggoO+G1pYF6sO+Dia+Qw0nZtS9gOa5/Z25OZoxU7OU2
	PT88ldqmYOe+bWyjBS05s3DW55ifxQk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Message-Id:Date:Subject
	:From; bh=SBcAfdk1AvTqfXhE/cLVYMH0/26jRBw6wDx068f64L8=; b=Y0nGvAzD9q/QlX076wT
	H2f//OoLXdbANexbqcrmpWSPR9oNkB2XZrtg3dQZ8y6KGI0BdpYPef7z2Ujb2z17R8ODE4V+DSrO5
	tQUXQC8uEKqI0mFKvHnexfbZdrKcepz4y9BniXxAqTq6ynhhPsZPsDoAtf5/DaxO5Nq0k+R4mZxmL
	/NZlV5D8yyq+YS+7AxmP2s1/zi0GcK7GDnNGarXWPNCoXA3Fvu0eV6ZXJzSBLXa2TSpJtjVmqS0Ww
	a1OvwhBIqvdJqudA8D5dJrfDxBEhdgCyvE3slHgCYGHijsAI07Rzk2YdKzYHmvJzKUD84Wn0vPcmL
	YiDq4MV/zjlikIg==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xJaif-00ANvl-0p;
	Wed, 21 Oct 2026 20:11:04 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: [PATCH 0/2] mm/huge_memory: take a reference on a device DAX PUD
 copied by fork
Date: Wed, 21 Oct 2026 20:10:52 +0200
Message-Id: <20261021-vstor-150143-copy_huge_pud-folio-refcount-v1-0-8bd88551f9be@virtuozzo.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACwA2WoC/yXNWwrCMBCF4a2UeXYgiRovWylSajptRyQTcilK6
 d6N+vhx4PwrJIpMCa7NCpEWTiy+Qu8acHPvJ0IeqsEoY7UyGpeUJaI+Kn3Yo5Pw7uYyURfKgKM
 8WTDS6KT4jNQbeyFrz+akoP6FuvDr12pvf6dyf5DL3wBs2weyRX6cjQAAAA==
X-Change-ID: 20261021-vstor-150143-copy_huge_pud-folio-refcount-ea269e668270
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Dan Williams <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Konstantin Khorenko <khorenko@virtuozzo.com>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2640;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=u9/28GqAiRcjxN3gSB/+og/EEsQKnoWl2BqSCLQbuXw=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq2QA38h+Jm/HpSxjoZpvbreseAaPuYo90VD7VG
 Wcb5XtQjcqJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCatkANwAKCRBRlgpH+WFc
 Kg4lEADGj9dohxRIf7msa+ab+qR251KQGQWsoZ160OAxzAbbcuxLeuNED8iLrada1ekOGqlIALq
 9TeT8csTn+1QtEppLfRD3T7G9aM7gSGsdfe7u0qgXj8d37mer0svdAirPkw97VXbAf8nVEtuH2i
 5+Dj1pBnuIUG3oRyLz7Lvmp7WNGmNFlfjnT8NpSMoAc6b7b+2Ws2EVokRSwghtZ5L0ufxWQ+uzr
 7Pe7/Lm4sTM6C9EwY6W+8xP7epOz/wm7d/RiMDd6zkAww7CZvU8lPXW3ZRm0FAza0YgWa3oqQE5
 lZ8uPyun37txmrB/e/3kngt3VLlpwnphMBYYWqoSs3LJfGh4JfWsRM7c4lHwP4uvRi3CfXfZTAq
 RaNeTW1IXsIJP7edjxZb2LcadEhXbq7gbmgE+ix9l3kAOPtXdyL+5re75E9o0QF/uAh28AFDNYD
 0dfO53P/W3BcEsRwCaUP/QoLPHwX+b44oONpstxfEGeN76Ho52xzm9HGVNijxF/sFcPh8zbYUyI
 X1OdK/NYrbs8hRsjwRRS0xdOcW6vZnG0/tJUpH/nGT3cinC88aIuGwV7b3uv6Y9mCmIDu9zTFdQ
 RB96wlBCgdyrUwX0UC7Itu172JsXEcaUXbCkitF71D4WJ1oJDp+G/XYHa3p2lWg6Bq05MRSY9gc
 B7qrnxk3a0hPLUg==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Stat-Signature: rh6eabmqewhsdur3kffk7htqhjawt8de
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DD6CFC0002
X-Rspam-User: 
X-HE-Tag: 1792606276-245973
X-HE-Meta: U2FsdGVkX1+8iUyWx2kXk4MLQ3E9SbwHqXV7SXH2x487Tba8DqK/0q1HZ7ns4LLmWqZRiZgr+60Yqs9t1D3YNwMg+nkoiTcNa8E0KBKxvl4bCbpVA35iOodpPVkySOYpD+S7Zd2GEE8FkbMUYgq7xFbGMckDhxFyUT3Dn7Ym7JQBsGYowTAjD6nD5D/uvn9M8qIZ0UhwLRtXjnlZh0acj8OptRAm8bxNVZQGRGFbPLEvgBXCkJzcFROsfqBomGWk+c9fNr2/1kq4ZxrxNoyfWpUA1YbAeY/7F8RDVbm+twosGYwLVRehAQUJb5N3N0yGupJfChBu29H5E7iwppM+s6XvQbBD3adhugScbbzuV5yeIXDlLauNWnYmCQh1BgHk+QEY29PGPbFuHF4uvU6HDB45fN4MveZgSGOy7WemzLont5IEGlO5/OONxkPhN8GaBhYGDJ+/1nphJ3Bs61k/esOa7XFkXrG3cdx/2n3GILYQ/5+OXtLevPLWowAd9dXhnQMYPUmCtMvx6tD9BDO+RFmOfSl4mVa7KQ5glTrZ6XUMW8dy/RJkMDJBSecT+UbmnNV6ffpgf4cpJYU6+gkwDIe0D4XpaKM0EG0+PcM0USzziC0JrkSFvDT2TIlg5Vzp5W82hwr5Uosp2YH1qFhgM9gAyw8eSkKNvN+mG+jsTTH56Aib6BojmTxK8RFfwOc5XyLUJHzfzA5wZJaQTTzr187ihCwIqXYYlltrVOsk0tuq7ULcGegkZAKTiiTwPwDbzXvX+XRTBlO18FVeAZ8jBhSfUdjSpcZYqpiqF7hxXq8q2RgNRxQOM39ImVBWeDAED2CVINYg0FQrzIJrDY5Q2ulNVS2u759pYqRYSaMns+vA//HDpKsPiJEVaYOHIMPCynEKwYxlTlLfCoFzXIR1aWq3Yz+jfiNkNv/womSmAb/ulKFlkmfn8Qc6Pa1Y1u9kji8jFrfQMGTbdDp02W2
 7/Ph6Fcs
 NXJXM0RfpzdBkLtT/IT9lAGbTBmiTpSxXpJ8H4DT3S/3fudVfQruJh1PjCNl13i3dPJ3Sj5Jr3NiAee/6xHnoiK2V9euxeu2+TFfOHuuyChRCWG1FOb0XQAiHsT3bzAlbyurDWw7wwha/jE5fMOaB6nzS7VdRgoC8bRXGLQZNiH3SzjZJYaagMEfQPaPveqVQtbTGES6ugELb6a+FiMzCNe3LgeZNQb4JGyavalV9oA+7FZZfyGpG4CB0BCotvUOuj1e1G0jebywxWDYQZoqlPPSD4GGrjwvfTAKW9LyU3z7WzZXzkDrFfIXM2mCIORXIzFt11OmXgpixlKRXf32TK1N9HtcKHfZK5e9K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

copy_huge_pud() copies a device DAX PUD into the child without the
reference, rmap and counter that vmf_insert_folio_pud() took, so the
child's unmap takes them from the parent. fork copies a device DAX VMA
once it has a guard region, so it takes no more than:

1. map a devdax instance with 1 GiB alignment and fault in a PUD;
2. MADV_GUARD_INSTALL a page elsewhere in the VMA;
3. fork, and let the child exit.

Patch 1 is the fix, patch 2 a selftest for it. I found it while
reworking copy_huge_pmd() for fork after David's review [1]; it is
independent of that series and applies to v7.3-rc7 on its own.

Testing
=======

 * v7.3-rc7 x86_64 KVM guest with CONFIG_DEBUG_VM
 * pmem from memmap=3G!4G
 * devdax made with "ndctl create-namespace -m devdax -a 1G":

  kernel              fork_dax_pud   log
  7.3-rc7             not ok         BUG: Bad rss-counter state mm:...
                                     type:MM_FILEPAGES val:-262144
  7.3-rc7 + patch 1   ok             clean

A variant that writes to the device and forks three times also hit,
on 7.3-rc7:

  WARNING: ./include/linux/rmap.h:159 at
  __folio_large_mapcount_sanity_checks+0x90/0x150

The selftest only runs on a device given in FORK_DAX_PUD_DEVICE or
argv[1], as on an unfixed kernel it leaves that device's folio with a
mapcount below zero. On pmem emulated in RAM, with
CONFIG_X86_PMEM_LEGACY and CONFIG_DEV_DAX_PMEM:

  boot with memmap=3G!4G
  ndctl create-namespace -f -e namespace0.0 -m devdax -a 1G
  FORK_DAX_PUD_DEVICE=/dev/dax0.0 ./fork_dax_pud

[1] https://lore.kernel.org/linux-mm/20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v3-0-85eaec8417f6@virtuozzo.com/

Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
Konstantin Khorenko (2):
      mm/huge_memory: take a reference on a folio PUD copied by fork
      selftests/mm: test fork of a device DAX PUD

 MAINTAINERS                               |   1 +
 include/linux/huge_mm.h                   |   2 +-
 include/linux/rmap.h                      |  22 +++++
 mm/huge_memory.c                          |  13 ++-
 mm/memory.c                               |   4 +-
 tools/testing/selftests/mm/Makefile       |   1 +
 tools/testing/selftests/mm/fork_dax_pud.c | 136 ++++++++++++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh |   1 +
 8 files changed, 175 insertions(+), 5 deletions(-)
---
base-commit: a804c5742bff224d4cb4d25dd383554d598be32b
change-id: 20261021-vstor-150143-copy_huge_pud-folio-refcount-ea269e668270

Best regards,
--  
Konstantin Khorenko,
Virtuozzo Linux Kernel Team


