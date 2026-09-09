Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19EFBC79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 04:00:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC1A86B0092; Wed,  9 Sep 2026 00:00:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9F3E6B0093; Wed,  9 Sep 2026 00:00:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D65D6B0095; Wed,  9 Sep 2026 00:00:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 73C8C6B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 00:00:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E12E51604B5
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 04:00:12 +0000 (UTC)
X-FDA: 85192871064.14.7D23160
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1BBD4160007
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 04:00:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WcoNR6XE;
	spf=pass (imf08.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788926411;
	b=ITvFTC01QxwgZRR1PFhuTRwwES6PRW71tU9Y1LRerjUEeOCq3fssnA1gfuYTsoTm3wRmog
	0E8Kuvsl2ntofDI1w4KcozcXL/66dl9lrZy6dN8zwBXbrhpDmbJTfKFGKuF3fxpkSkXgpS
	2JYsN105V3UewjONfHxczQix2rC9yRY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WcoNR6XE;
	spf=pass (imf08.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788926411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BbdnUPB/cYL/92Mb4MbcETmIGU9T6CDvSLKwOH/WTE0=;
	b=cdcoMKc2gLCu9cRhV627JjhzJBzZoUX3I4zgJn0Wd3h2wtI+WnzQ3FPM3YkNxVLXWxWB3v
	VsYksRPTHOE46wbRWbPwXqngEwO6XbhUxFriwOqGNNuNk5S5w3sD6RPQEHdKzPN6D+zv6V
	YFn+HD2y+NeSbcoPpeixM527he0JIM8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 60AB21477;
	Tue,  8 Sep 2026 21:00:06 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5062F3F528;
	Tue,  8 Sep 2026 21:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788926410; bh=fvXoG85F5/DIeDwKRFU1PyImr4ixDymncFRNXJ2Iea0=;
	h=From:To:Cc:Subject:Date:From;
	b=WcoNR6XE6XGo9IOR2K17IuWcYUDsN/fgpriNQjIfIRuqLomuIVODjrYxQDFVakUH5
	 oL8YbK6IqNKbk9Op7A+xaFaBkbUUJx0SrdTm9Oe5c8PweXTDzxFRWfqgKIOkdZh0s8
	 mXW28fwzlzshyNwhPV5godjgmNztrI7jFZgCFSEI=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH V2 0/2] arm64/mm: Standardize printing for pgtable entries
Date: Wed,  9 Sep 2026 09:30:03 +0530
Message-ID: <20260909040005.4148136-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1BBD4160007
X-Rspam-User: 
X-Stat-Signature: ugisx1ccdhykjthtaw9tyndrkjd1nkxe
X-HE-Tag: 1788926410-64747
X-HE-Meta: U2FsdGVkX19rUvkxUCstwOTmPrpKZ8cotnhkj0UxjQaAop87etIDp38pn/BaHkceInjqp/iVnnsBR4x7yH8kI13Tn8qBBl7Ssx7+a9IRKAg4SM/x3kyRRuHfwqnrCdZtsvlrCp2Tn7nqfraBKST7mVmBUWiX6fqrcdM5ii5EER7iDY/+Zd6bupnwDwA0Sei/XskHNxJ87jHOxgUPq8ooeiXqINDircdY14i9ZAEbu83tczl2tjsSDy3/rn2WAN3NiOY7ymCJ9uqV6GCyBu1R2Gma0/uubyw4DSROi9hItjkFTKDxjKMl3vMv8xv9Y2mV9HUAzYADvWlLra0FMcSBLJiYMqIykBbDuKOYnoIJKTLos3r4PAUUnc4v0OnCMLcKtohAAeCLZ9VZrDbKUqpz4NqkXAqyQyfcsMjj0duLN0iIHbg3A0HUbUTPPJgFtWih0mT+aYI4zS4gNDd5tUCtvsLnpwLrvjqbb3aKpA6NF7W+J6F/NX1rlhVPd31WrAGiV84m9Y6+IMElht0YrrPwEU5xjIMuo6kDCh0o3/j83aJkG5DVemtmjbaU5G5CVsZxL10OklmDHHkLSz0sYQHXAd3xJh0Rx9OzOTHAHWAv+pZ4Cr97ZYiSJz9wOzk1akZZffMcuNL3SNZZGlGSS6nllZ9pNKdwsMGoVDXDDaJ/DchbZUZ8XwnLfEQQMdOTQc8Q/KXGLeTlxigJbNDPLZlALqEXP2BbZNqibiU+j4iMgYjediFE516M+7OE3V+VqQNj200Ac5dwF8SKIyZyVEFjVHa85Guu+DhQW4e6NSKzxPT88g3/R/pe1G63YrUT3XAJACZXtzFhTeFcp3OfCqJp3snxSRGj5z8YYFJtxnx73ZWHpCXPy/gNR3oSkj/QxunbaU5OG5Tf/OOu5WYGjCSdnaKOrVsW3FvdvnP7HKWCDE8iPrlKYUOkRQAYmXZ4nYWS0fUbWHYKyn2vzC0enq8
 z7uTbZ+7
 rqK7qyIsYs5WbLE78dtrCjbxbWu+EtLb3ZOYuYEWmdzZstq//oGVeeCVfxoCaVRUPDRxYTk/wbw07CD4YnM90edPWX5xyqqqdZhRqlyEcy6zrYX9gejv8EHobNe6idsv5fCs2loInUyG32YsKO2KO1cNTJ+wAs+7+byH5gVAy7lmgYN/NiFAbLEWGtssdBuqcGRSRQglopoSWAhJvQKqmV/23U5/JIs11vsiaXvF7MSgTVlqKwycnKSXYn+t59Xih+M2UG1ptFLNZyFvBDriQ9N4W2gB7waIIkFEQO9rACdXWFINXJGUjdCQdLLnsduXDSKtm8rE69sB4q0F1WQEFqIqNkyrJQnXMVKWOcUUW8c8WgzVNe0vOmT2JgYnrzYe3lTDeNckx9tUmD8/osaqRimtGIQiM4BEdGWyBLvz1Ow2RPmzHbGer841v3UqRmDU8ZP+rE47jceP2aVNrzdlHYa2H3MGP5SorWE/ivyS1HhYHoyI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Standardize printing for pgtable entries using recently introduced generic
helper ptval_bytes_to_hex_str() in core MM which automatically enables 128
bits entries when added later.

But first move __check_safe_pte_update() outside <asm/pgtable.h> to avoid
a cyclic dependency while accessing these afore mentioned core MM helpers
defined in <linux/pgtable.h>. This replaces the original page table entry
print standardisation proposal which was part of the D128 series.

https://lore.kernel.org/linux-mm/20260729122452.3797443-11-anshuman.khandual@arm.com/

This series applies on v7.3-rc2 but after the following.

https://lore.kernel.org/linux-mm/20260831054331.625505-1-anshuman.khandual@arm.com/

Changes in V2:

- Moved __check_safe_pte_update() inside #ifdef CONFIG_DEBUG_VM
- Added empty stub for __check_safe_pte_update() when !CONFIG_DEBUG_VM
- Dropped IS_ENABLED(CONFIG_DEBUG_VM) from __check_safe_pte_update()
- Replaced pgtable level specific strings with pxd_str[] in show_pte()

Changes in V1:

https://lore.kernel.org/all/20260901065454.1906343-1-anshuman.khandual@arm.com/

Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org

Anshuman Khandual (2):
  arm64/mm: Move __check_safe_pte_update()
  arm64/mm: Standardize printing for pgtable entries

 arch/arm64/include/asm/pgtable.h | 49 ++++----------------------------
 arch/arm64/mm/fault.c            | 16 +++++++----
 arch/arm64/mm/mmu.c              | 48 +++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+), 49 deletions(-)

-- 
2.43.0


