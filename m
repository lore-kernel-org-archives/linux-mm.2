Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01A42C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 12:49:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF6E86B007B; Tue, 11 Aug 2026 08:49:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACC7A6B008A; Tue, 11 Aug 2026 08:49:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A09546B0092; Tue, 11 Aug 2026 08:49:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77E8E6B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:49:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D0A90803E8
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:49:18 +0000 (UTC)
X-FDA: 85088969196.24.2B0FD37
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id C157C80008
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:49:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tWdTgtaD;
	spf=pass (imf30.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786452557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UamYZUrsSttAOWNhw1TD47ovNhb9o9UffL8S0RW1mgs=;
	b=ziA/kt4rw3w4MAI5E/r4yjhsUjTqyE+CASrHaN9ddbDOvBy+yvl8kkQpAc1xlGfSLKxEd6
	KomOyUmvPcl30pIsbtoKRUHnc8P0g/NoWmdx3Snl0L5zWjKpLf8sNOKFucPAHq8fWmjN6C
	NscVWs+dxHu94A4fpiLngS6ccxHhB8k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786452557;
	b=0w39OKI3bkl9t+qX5Nhxgz47yPxNUT+vHBLcjQ1N42Sny+guQ5KJsz00IceYfOroef78Lt
	mq/RVfaxJ5lsotEZrCZdD0n56o/0ME3IAoCPt1rEETwgRUtExxcqXe120F09LMhwKMNNpO
	DjrYtLcrqoxLzt93iQQ/Ot1jy7jVUl0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tWdTgtaD;
	spf=pass (imf30.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786452554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UamYZUrsSttAOWNhw1TD47ovNhb9o9UffL8S0RW1mgs=;
	b=tWdTgtaDWxjpQZYm3brbZjkngTiOXjN/EMtct4m7cpMStiBiLyQUUJ97YmkjX7DaXh05mB
	bL434r206B7yXZiR51fEamNKctmfasLcCeavWOZgDJT5rXWQK/cAb810iehj35xh/6hJ/r
	hkbdeKF27sJjejXwiLl1XrZIoa5Rp7Q=
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Subject: [PATCH v4 0/7] mm/khugepaged: several cleanups
Date: Tue, 11 Aug 2026 06:48:32 -0600
Message-Id: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/4WNWw6CMBREt0LutzWV1vr4ch+GkD6ucNUAaWmDI
 ezdggvw82TmzMwQ0BMGuBYzeEwUqO8yyF0BttVdg4xcZih5qfiZS/ZqY4ODbtDVw4i1x4e2Y+/
 ZEc1J4UGai9CQ7SEnNG3L9+rHIZon2nGdWxsthSx+tusk1t7/lyQYZ1woabVTstT89qYuTnuHC
 aplWb5Z/QuT0AAAAA==
X-Change-ID: 20260804-khugepaged_pte_refactor-5eb76e14b93a
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Nico Pache (Red Hat)" <nico.pache@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C157C80008
X-Rspam-User: 
X-Stat-Signature: rj14sqjxoyu6qpdwq6zt43zy4gawehdh
X-HE-Tag: 1786452556-932649
X-HE-Meta: U2FsdGVkX1+pSHl5ByxzMOa9Su/pnLN3mk/hdVMflDe+LsSI5qKWdaDjwRwXUmDRDXQvqEqLs9jCT0CVt4Yx8eFCix4p2uhoQWQFGLgumQxdw4BDKg6ENScNX8e6eoBmhD1H7xypvLmObLdWZK8/Ht8M4EG27fXOfbOmopQekA+1GLB9wq7VRSOB9Oqxd3v02p5yD01mh2EfOAqV4I4202BGrxtk2vS1s4MyCUs2+0Dmm5VMhItp9VEQ/Ddte5bppCm8yTPFb1xrxG+X5IqOm5OQNpISYRseuzCNFc99xCMIaO46yU2sQLwvUgbOdJt8g/Z8DjpmOLChFwyiW16XXXIQXWWQKsrvXhimE5r878OHC0mNEQFz82ELO+dxQ8AYmt5pCU5dFbdYliu3oHwZtCxSXf8R2106kYwtCIQxnrSDlZVp3sCpl7Ic1YYUVJoXduczX0H5YPGH+VsvkH9bebXUKE3pFr37oUGFJYs64u9kbbKmVcG5LHwDbLt5CS1cxOtFFt7XY2nRYzSqbDUKFQXEsYTz/F7JnPOREJ+04fCi+DKm3KsiSr6UNbGzaHdMMZO23tnokgKXIScRU3h2d9JT7CyX3cabKd4sjzhmViOmwSviX67LD7fwuIDC0e7Mt66dS6vzuMAM/JkQH0mc6pIbaypkC1xmWAQcgbJKOG8bc3YKhU/UpzToad7GGUXK4ok7w+Bm4ncT1+eAWMMsy/TrD7SRQ+xiZypKWkRdSq/UnBlbb7sfdw0A/D0E4WZzlTGmTF5IS1C9vUhfnRW1q3yXu9IcEkCyiL5Qrm8Rai8ENUvcQLeB8rdHrXPCMJFsU3QbTv2Hp9fK/PmMGOOv1hr5rSxuRympqYPiX/Ol2FyezMa2E93ZwN/zPDf8xp6u0OFc9CnLUgjpjOmZU2tlZB8Y5kflchbXMg3s/KNBGK8NQ4WRrH79VhFNDjSAErvYuODDm4gCZFjXZklaa9R
 CC/fp3U/
 wKnqPGkWkXGIJUksWR7Ok8TUMtaiGX0bp8+4mGadeZEQt4+eeIU/xOauZ1Fo3+uwOARjIOCU1eruUQ2zlECwo6br24tFA7CXVpImkNDQPanrxw/zRLnxCkOQ0VxAntauJ4rrB+xFCtbERmWF0C/A72N9tzoO7t/7Rb+AKykw05qB4tL4uROoOHDYAfhoosQK2n9WpbuG2OEHGdZgXdiEI4meTtAiYzZAfha1BaIIS37JNc7+rWDJ7Ix0yybQTkFQamoPU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The following changes stem from a number of reviews during my khugepaged
mTHP support series [1]. Some of these are minor code cleanups, issues or
reviews that we decided to deferred to a followup series, or in the case
of the more major patch of the series, changes [2] Lance Yang attempted
while my series was in-flight and we decided to wait till later to try.

The first 3 patches introduce helper functions to increase code reuse and
readability. This includes a per-scan state clearing function, extracting
the young page check into a helper, and a count_collapse_event() function
to reduce a repetative pattern used across mTHP collapse.

The 4th patch was the byproduct of me throwing Claude at all the
comments in khugepaged verifying and looking for any outdated info.

The 5th patch is based on Lance Yang's commit series [2] trying to extract
the PTE state checking into a helper function. This required a bit of
rewriting due to differences after mTHP collapse was introduced. I also
took into account the changes requested during his patches review cycle.

The remaining 2 patches were review points during my mTHP series that we
agreed can be deferred to a later series.

Thank you to those whos reviews and work I leveraged to achieve these
cleanups.

Changes in v4:
 - Add Acks/RB tags
 - [patch2] rename pte_is_referenced() to folio_pte_referenced()
 - [patch2] keep cc->is_khugepaged out of the helper gate
 - [patch2] simplify/clarify the helper comment

V3 Changes:
 - Add Acks/RB tags
 - rename collapse_is_referenced() to pte_is_referenced()
 - fix count_collapse_event() call-site indentation to match kernel style
 - fold in the follow-up fix so collapse_scan_pmd() always assigns the
   local folio from collapse_check_pte()
 - normalize khugepaged comment references to use parentheses

V2 Changes:
 - Add Acks/RB tags
 - rename collapse_is_young() to collapse_is_referenced()
 - delete unncessary comment for collapse_control_init_scan()
 - merge fixup from V1 (fixes stale folio reference) into patch 5
 - keep original ordering for checks in patch 5
 - merge patch 7 into patch 4
 - conflict resolution from uffd_rwp changes

V3: https://lore.kernel.org/all/20260804-khugepaged_pte_refactor-v3-0-0364cad642a0@linux.dev
V2: https://lore.kernel.org/all/20260715025941.1571316-1-npache@redhat.com/
V1: https://lore.kernel.org/all/20260706154500.39178-1-npache@redhat.com/

[1] - https://lore.kernel.org/all/20260605161422.213817-1-npache@redhat.com/
[2] - https://lore.kernel.org/all/20251008043748.45554-1-lance.yang@linux.dev/

Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
---
Nico Pache (Red Hat) (7):
      mm/khugepaged: refactor per-scan state clearing into collapse_control_init_scan()
      mm/khugepaged: extract reference check into folio_pte_referenced() helper
      mm/khugepaged: introduce a count_collapse_event() helper
      mm/khugepaged: fix outdated comments
      mm/khugepaged: Refactor the PTE state checks into a helper
      mm/khugepaged: unmap pte before releasing vma write lock
      mm: Documentation: clarify where the mTHP stats live

 Documentation/admin-guide/mm/transhuge.rst |   6 +-
 mm/khugepaged.c                            | 414 +++++++++++++++--------------
 2 files changed, 222 insertions(+), 198 deletions(-)
---
base-commit: 005d5c898c17ecadec427819a20640e37c357997
change-id: 20260804-khugepaged_pte_refactor-5eb76e14b93a

Best regards,
--  
Nico Pache (Red Hat) <nico.pache@linux.dev>


