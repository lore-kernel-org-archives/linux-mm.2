Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39AA0C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 08:51:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FF666B0092; Thu, 24 Sep 2026 04:51:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 389126B0098; Thu, 24 Sep 2026 04:51:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2526E6B009D; Thu, 24 Sep 2026 04:51:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 00B0B6B0092
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:51:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 856BD1C1C3C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:51:51 +0000 (UTC)
X-FDA: 85248038022.03.3BB6E7D
Received: from mta0.migadu.com (out-240.mta0.migadu.com [91.218.175.240])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8A4CE140002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:51:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CpLGmZbH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.240 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790239909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7CKXx5XgyieYtGojHnlmroTYIqA6X2e/LtrDCN8V8CY=;
	b=HiFPRnwx+cJ4ngqA93QLBhzG4KFtExM3Mtg7UEVV8jon0ZWxrHzQs9sNqDcrCDOzXNeM1n
	66n4SllTNWDIQpVy54Q5wFE8fz5J+aaeHj2k+YXBbvHpJeuThFolB7rzlk4W4EplHyStM6
	z1bJVMEYJ28Hp2yvQIs0Gz75Ajk8q58=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CpLGmZbH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.240 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790239909;
	b=vALaRaFxJcpxV0SDVq8RWbWYwZzH2A59zlXDzgdj7xNnJOK9bWButruRpIV9Ji7GvTR4gu
	ceNJ7M8VGHmj8ur06CJIz2Us2Ihup5nB4AT5dp7pBFKJTaiTDZdSNwSG8858nTslMksh7u
	FsMWheSoiCAp+IhEHkKaZFKPHRO41Pg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=CviuPqAogpjkevgINuLKWVWxQ4ifJ0EssNBV97Y1Xro=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790239906; v=1; x=1790844706;
 b=CpLGmZbHqb8QhRyiT+fqu8Q7FPiKdK6TbvCQ3u2Tcr5McqHtvmrnuUHsPPCu163SdESjyTPH
 ddEbQLOSkWNIvDbgr9it5O6GALD8TP63H7vPtPHabBqIaE3W2axMNjJ42zQQnLzcmhyHqycNiu4
 mk/9CAfm0NAQJFkU2oOmYpPk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3762d0d9dc2c72df;
	Thu, 24 Sep 2026 08:51:46 +0000
X-Mizu-Trace-ID: 3762d0d9dc2c72df
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Subject: [PATCH v3 0/2] mm/vmalloc: fix vmalloc_dump_obj VA lookup
Date: Thu, 24 Sep 2026 16:51:38 +0800
Message-Id: <20260924-vmalloc_dump_obj-v3-0-5bdee3da37b3@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJrktGoC/32OzQqDMBAGX0Vybkqyij899T1KkZisNUUTSWqwi
 O9eIxQ8lB4HdubbhXh0Gj25JAtxGLTX1myQnhIiO2EeSLXamACDnFU8p2EQfW9lraZhrG3zpKp
 kFSuzrEjzimza6LDV85683TduhEfaOGFkF0Nf36FQ8bzT/mXde38g8Cj92QqcMloIkTFQAJlqr
 70203xWGEjcCnAIAP8RgBhIW4lNiorL8hhY1/UDBG2lphABAAA=
X-Change-ID: 20260916-vmalloc_dump_obj-d80908447369
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Stat-Signature: xima1u4igzm61t3xo84qgx3pqwyxz9ai
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8A4CE140002
X-HE-Tag: 1790239909-984924
X-HE-Meta: U2FsdGVkX18bycAgZKR+Zj4ZHLLCsK636an2IU+8xWKxKc6GSfa3gcGAYUkiwLMQK4OhdbPS05Dk7hrJ5/yQ46fjwXlcK7j+7iiGQ77F8S5V0O6FKWbYYt1nqQOiEeHud+wDvizVpUKm6PD+nxIzVhIcEbkDRIJMISx+rf0ge/JLnWyoG5FVeIbwR3q7r/9R2an/P5Wyh/ljhQfCdMdS3qPwoRBDoSONF4jCymS5nvmyJEkUhmLHpQ7oUO3dvnmIiaKUJ59kBb7dlvWp2go2rwsGQMpQnN56C6TY3V7tqwGaqKq/nBdeWrGXxUHktVcDr+F7QIOnzwyW/1nagJrazSj/sHy1QY2rOxgREE/aX6ibiEcj8dTnKEQ0RgDmcuY58k9k76JVQG4peDD1550YwSJFscIbi6VvBlxH/W5L6PHA6Zka2FehnE5oJ/ESY0kdodgiVF2ZycZBKruik8z2rpxBpfOrE3LcNxhji1fdQahH/jsTV97SzgHFdxoQZHcUEMIwaY+0oGX0RE9adIX9svHKYOMyNOSigjjBSchpFvuuwJn2VJtLYdNZn5dD8bimt3xwTmJhAaMrR56IVx/jRZA1KCCBVzVT8TgmFDuftWriD1aKOh1wJ0W1SZ+UyhOuX3B1e9er3DiWhGCW99K+ZsvQEHCfsKIT2NdFADTvs41/Catf4wvmQ9fs/SwRrdO9Ctzv2Ahm8V3GYohLVI5l79YktytZnMlJpueVw046zkO6NyR75hPdnazNQDEH5bCqncx9XhUuIbwg1Epl+GROc+RDLgLfmjeBctbbAPn6HhA9C4GpDsk4HDN8L3p6YB+NTnJcHG1z6/uARuaZcaUjRxaJsZkoefNZZ+hYoqOv2i5w/DDL78XmtY/h9BG3VPjvALsaNL89AZy15sanmk7PkFlEg55n4VXKZggmGiExG6yMsmJAfS3jEZF4Lhgl2ToCwS+y/9+j+I4lalKgReI
 /OyyA9oC
 jeaeS4dvpN5ZWmalCBauN3L37ecFdv0ZdBQhMROy9j+Skjx8uio2SjjC6RqOZwDs5bRi1YYyGqpAvKtLbrcaBzINEKCwMdnboFnqTnTaEtYIWCUH/nPg/KDsHe51ggCteTjXWvoc6tM/1DKmXKtgzEi3O4zZ+Szy9vhlwyemZNhjWmIIuHxjh1GFw+NGutLpsO2ZNQtOwL6hbbTe/jHsbcUm6MZGvwvzZX/IeG3E1IqAjeDr0rjKedV3hDMx7IXtcJ47H+LqOmXF2ZDl8chp7bS5O4eHWBDAvDpMUiR4GTb+gN5/iFVkZBQiqAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmalloc_dump_obj() has two bugs that cause it to miss vmalloc
allocations.

  1. PAGE_ALIGN() rounds up, pushing last-page addresses to va_end
     and outside the VA lookup range.

  2. The function searches only one vmap node, but allocations
     larger than 64 KiB may span multiple vmap zones whose VA
     is stored in a different node's rb-tree.

Patch 1 fixes the alignment, patch 2 fixes the cross-zone search.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
Changes in v3:
- Patch3 drop.
- Patch2 Extract find_vmap_area_lock as a helper to simplify the code.
- Link to v2: https://lore.kernel.org/r/20260921-vmalloc_dump_obj-v2-0-73fceb3ed1c8@linux.dev

Changes in v2:
- Use is_vmalloc_or_module_addr() instead of is_vmalloc_addr() to
  avoid filtering module/BPF/execmem addresses. (sashiko-bot)
- Link to v1: https://lore.kernel.org/r/20260916-vmalloc_dump_obj-v1-0-7aa402d224df@linux.dev

---
Ye Liu (2):
      mm/vmalloc: fix vmalloc_dump_obj address alignment for last-page lookups
      mm/vmalloc: fix vmalloc_dump_obj cross-zone VA lookup

 mm/vmalloc.c | 113 ++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 70 insertions(+), 43 deletions(-)
---
base-commit: e6e35979777d646fe3c7c94dca7dd32fb25d45f4
change-id: 20260916-vmalloc_dump_obj-d80908447369

Best regards,
-- 
Ye Liu <ye.liu@linux.dev>


