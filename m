Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5921F5140F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 06:44:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15B8A6B008C; Fri,  6 Mar 2026 01:44:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03E3E6B0092; Fri,  6 Mar 2026 01:44:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D98086B0093; Fri,  6 Mar 2026 01:44:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C23516B008C
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 01:44:12 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 969CCB9788
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:44:12 +0000 (UTC)
X-FDA: 84514698744.08.0FABC06
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5372FC0003
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:44:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rCHwBcYK;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772779451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CmeKu3kFQGo6glaHzn6GIz9FtScBZUYLt4OdvSQRdYA=;
	b=QInZNHy1qRxWPEJrEmaLeexXadBT9zL0Odbf9aIZX0rU5qlcotEArrAz1qD1g/hjEx5dUz
	NgiGzLQTNfrrilmhZxPM7w4RYdmwTF9zqf05vfS9G8EuACtMBTEiFy3JqNJ1E5TLccEeBb
	3nJpFc1ycye/TXGn3wG5Ukq4VP9b434=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rCHwBcYK;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772779451; a=rsa-sha256;
	cv=none;
	b=sxEwm+uXuHcwGTlCxbycPZOzf9Au64L1+JNjUjesw7GTIfxLIBu5335f61HpRHZutqh/xi
	dxV4D9CyTYWrDqiz94eZDhMN/iRpIxbJ1GZBcHRFi+4OteQEcBf9UeG8gU6DtIY/i6YhWv
	1FSPBfCMI0dNTTOmq6SCVvK49O4peVs=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772779440; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=CmeKu3kFQGo6glaHzn6GIz9FtScBZUYLt4OdvSQRdYA=;
	b=rCHwBcYKYxqqLCgeotDAHfd7ljpsrHI1oCNUdPzZTiQKym1X3GfPq711vD0L8Y04G3uFWqk4Ct5GGpPgDvhfbBSxGls/d2mQ04NYioqIObjlgzFVWNdiwwBobw9yCeBTq8UcA3Ne3ebkVfrL9vpYtllUULKnetXDqzviZZLNTus=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X-ML2rg_1772779436 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Mar 2026 14:43:57 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	lorenzo.stoakes@oracle.com,
	ryan.roberts@arm.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	willy@infradead.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/6] support batched checking of the young flag for MGLRU
Date: Fri,  6 Mar 2026 14:43:36 +0800
Message-ID: <cover.1772778858.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5372FC0003
X-Stat-Signature: w1zfpo9qntfrtj9gqokpm8btycya57jc
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772779449-162859
X-HE-Meta: U2FsdGVkX1/LuMQ0cULDQVcPTGW3cI1hZRPEfv/HiW8pS7nqXBPYDPOK1c99IHsEXEhSmh4TMeW0QIWYhiyf6m42AEY4WM1tx3nYOzNsvujyS2AhYvJoo9Qon5bsGug7SD6FYnVF6zfos6wX9+U0Gmvpav1G+IyTj2aCMIy5FLiWkjn1HCuMGIDj/HXbG+e8BnlCfWBySDHNviyWYlzwpyN8+NxyNP2oBESFg5GbNKuiygo9cz9amO0mcZRKiervN4x+G6L9V71c4UzU3tEvyWMlNDcKZYlrRjNUM24+egIgR2kKoLgH46lm9TzUrcisSC3zKuzORdXqtMdZlQ7H0QbA2rnczSWj7+A1IHZtl3dScmxkeV7jEmtzg6HAt9JkKM9hRxIrpruOtm2FjvyCyENSdAZlPeajx8BzhXkA7e1h9ubGtjtnY05geBOTROav8bWrsLbhd8Wfj884Zra/JOEW+sdYd2spCDCtM0v1701MIGsfhz0gIJ/9EjjTiaMvuOyfe1FMdEtbiZWRBoalie+A7p0t7IN81R4W1vv+HIL2FE+cS2mYjutU8JRSOkhquAdQ4iGqbvKv7YOPI+C6xNbZWY1Ieaky5ZtFRz3XyvkbhQdW8HdBE9Xv4a8QFHjMfqc2kbKFxTZibHORyXJ+9mTs9ezOTBkoeXMh+WkKviET7N5f8pWF+lkSMoe0lpHHBnMQGsSJWmRxZMiIb1S9MgppxNuQbBwtnyT2F/uHzLFQbtWiVhF360LwfXaPrVClB5SqSoNP6Am0wOnI0+uqkhcMzKKyuA9DoWB8dyPTzBhlNVP6sN/fEkfTU4y7cQs7jcxSXiaFob9oT6a0n7ghcR+bHZhEp4OugXO0oWHhnyy+Yuf7wKMSbm9wiD+w9qgdnX6zA1liKyT3qlRPak8SIK+13EadCVv0Sdgmq0Di/R/Sy9jJcCoWIM4d6y2H9U4B2IdGJIssPchY+9j1P2H
 UZL43hMO
 E8N1zfidyY+o42Iyf4GyNlMWaAKnnFxG7bqEjUeILi8u1h3bJ1fc0iGrpoipm0/VzDPS9Gn0Mwo3XBK1g4Qb7fkqBg4/UHsn74PuJLY+9nEJXvzmhF4Inp9Nsxr0hSmbYW0dXRXAlSTrm9N6jkbRfqn40mfdXDfhaQxMcVaMpg2LRRhtIMwWjet7oTktns2lTZ1BHkjD2XJ6tq0ROPg8S11Qjp7u1aO99L5qo4L8mb4jkEOFJamQjiPgAwnb3CjDDbKZxG18Slz+FlO6ZjQ7/ldoHjWLhs7Wby5v/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a follow-up to the previous work [1], to support batched checking
of the young flag for MGLRU.

Similarly, batched checking of young flag for large folios can improve
performance during large-folio reclamation when MGLRU is enabled. I
observed noticeable performance improvements (see patch 5) on an Arm64
machine that supports contiguous PTEs. All mm-selftests are passed.

Patch 1 - 3: cleanup patches.
Patch 4: add a new generic batched PTE helper: test_and_clear_young_ptes().
Patch 5: support batched young flag checking for MGLRU.
Patch 6: implement the Arm64 arch-specific test_and_clear_young_ptes().

[1] https://lore.kernel.org/all/cover.1770645603.git.baolin.wang@linux.alibaba.com/

Changes from v2:
v2: https://lore.kernel.org/all/cover.1772185080.git.baolin.wang@linux.alibaba.com/
 - Update the commit message of patch 5 (per David).
 - Fix some coding style issues (per David).
 - Remove 'cur_pte' variable in lru_gen_look_around() (per David).
 - Move 'ptes += nr;' to the suitable place in folio_referenced_one() (per David).
 - Add acked tag from David. Thanks.

Changes from v1:
v1: https://lore.kernel.org/all/cover.1771897150.git.baolin.wang@linux.alibaba.com/
 - Update some commit message (per David).
 - Fix some coding style issues (per David).
 - Use VM_WARN_ON_ONCE_FOLIO() instead of VM_WARN_ON_FOLIO() (per Rik).
 - Define a generic ptep_test_and_clear_young_notify() (per David).
 - Remove redundant 'nr > 1' check in folio_referenced_one() (per David).
 - Rename some variables' to make code more clear (per David).
 - Add a new patch to rename some functions (per David).
 - Update the young counters with the batched count for MGLRU.
 - Collect reviewed tags from Rik, Barry, Alistair and David. Thanks.

Baolin Wang (6):
  mm: use inline helper functions instead of ugly macros
  mm: rename ptep/pmdp_clear_young_notify() to
    ptep/pmdp_test_and_clear_young_notify()
  mm: rmap: add a ZONE_DEVICE folio warning in folio_referenced()
  mm: add a batched helper to clear the young flag for large folios
  mm: support batched checking of the young flag for MGLRU
  arm64: mm: implement the architecture-specific
    test_and_clear_young_ptes()

 arch/arm64/include/asm/pgtable.h | 18 +++++++----
 include/linux/mmu_notifier.h     | 54 --------------------------------
 include/linux/mmzone.h           |  5 +--
 include/linux/pgtable.h          | 37 ++++++++++++++++++++++
 mm/internal.h                    | 52 ++++++++++++++++++++++++++++++
 mm/rmap.c                        | 29 ++++++++---------
 mm/vmscan.c                      | 45 +++++++++++++++++++-------
 7 files changed, 152 insertions(+), 88 deletions(-)

-- 
2.47.3


