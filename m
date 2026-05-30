Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 714C5CD5BD0
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 08:54:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E4D06B0005; Sat, 30 May 2026 04:54:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 894756B0088; Sat, 30 May 2026 04:54:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D1C06B008A; Sat, 30 May 2026 04:54:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C3756B0005
	for <linux-mm@kvack.org>; Sat, 30 May 2026 04:54:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 71804A02FC
	for <linux-mm@kvack.org>; Sat, 30 May 2026 08:54:30 +0000 (UTC)
X-FDA: 84823475100.27.90B7AF4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8F9961C0006
	for <linux-mm@kvack.org>; Sat, 30 May 2026 08:54:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ST3ciQrG;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780131269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WQV9pECXfNy8qZDbzPWtHWzXZAjY3wnr+7RmoTULxXw=;
	b=TwEXOP2KKX/RqfwV7LI6aiT3pN6naJ1+ZvhYzvNI2rPUMwoL8NA09cnp6/NGZARKYnYYNR
	WlKuvedM2pn+03yhkqLUkt2nXtdZ+kFtSeaK7x+3HWP/3tQY1JZz9tDGWJ7tRMRnho3XIK
	UaMZRzgRU0Iu91i9oA35kKsws/SPdLg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780131269; a=rsa-sha256;
	cv=none;
	b=UWs9f25DREtAolFUeVesSCHAwVV8zQM1EYW8CfVXqkUNJwTDYmJ1YTbLG+LwvOP+9U5t4n
	l+Lu7HXBO6Qp8Vvw9WYhqXnOJ0mWPGO8AWEgXEukJrD6oP8D5p3XcUsdNtTqcYnGPE7rHB
	Ot2EKJ0q4COpvztVS5bQNrwAlyL/0UI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ST3ciQrG;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 360FC3515;
	Sat, 30 May 2026 01:54:22 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C20223F632;
	Sat, 30 May 2026 01:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780131267; bh=7AFxGFpqpXha7B0L7GvZQHPfwNdV8fJ4fRBDaQhzt6U=;
	h=From:To:Cc:Subject:Date:From;
	b=ST3ciQrGj+9vjXS8XcFXi7/AzY57d1bE6O1K9IIOvFGYFYKOtsG96xPkfXdoZ6OP9
	 BV1HHZj+PW726+WmowHvLmI1VO3ZThLu2Z9a7mC9hVpykULPvd/hytd3USMJu107Jz
	 BO7CdWUzAKYJKAVoF353j3hvS2qMmabx12xx2698=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	jgg@ziepe.ca,
	leon@kernel.org,
	david@kernel.org,
	shuah@kernel.org
Cc: Dev Jain <dev.jain@arm.com>,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	balbirs@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kselftest@vger.kernel.org,
	usama.arif@linux.dev,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v2 0/2] mm/hmm: A fix and a selftest
Date: Sat, 30 May 2026 08:54:10 +0000
Message-ID: <20260530085413.1270139-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F9961C0006
X-Stat-Signature: isy8ufday49gjqdp9tked7jgwtt4cd9q
X-Rspamd-Server: rspam06
X-HE-Tag: 1780131268-53487
X-HE-Meta: U2FsdGVkX18X72OXop5M5NNFhLMCyv1sh6pvakLVFvA5xpZwkq2Y43RyF3Lmrk7flYQ5Oe3TioPv0nKBMEpJO/eqw1aSmbr33isa1mq9hMixSHqdd+eMmQ3oo3cvnrYunxE/ud5ezxmqRZ+Sdw+oc9128e/x90KuF3BYfZPVUjIlt2R16t5K/x5n4XhZ38OagfLlqt3YExPSy5nYxC5T9G1RFAxzwUt2nXUNW2aAE9tTQdQuq8MYPRPHhCryjt4ng6RMGRLAer1Xj+uWcWvOSpgBw1ZmHjLy1FGhrEzLAl2thREiC8BAh2U4AKJK90KjbQU/vZMIB7VBZnOmmD/5z/MV6f/fV0S0matAx5JUztad7i3/kCs40fEPGeLAXmkauTm0b7ypVMxFfZBXkRCh2iW60dmUz5NJb6cV9/qwyXqdfhZrKW5n8S4hSCohrXR5m2CtgxAieInwbvnjucRbTLQ/wsg6bjqZGKuDv09vkH+3TGM+dZUYClvqy2RvZWhA4gtRsBbiNqeSSoout25ZKmILBaA+6IG60DFI0cC2iXPBX9WatI9W8zJ7xm6XICFaxAYX4bbO7eyOZa30VByhSdU1/QwxuAniKD0kk+NvbJjBP+2FOo/Se5Fc7JnqfOm1EmjkHR0pFBhc+NS/vuX+SvfAQkGh69V7WNr0J3fUxTzmJoVOMOl8QIiIXFUaAXUc4v21UnEtl8gJiIATBYEo7zcpywue34KGfWor0y4V1C7mIaLi4Kb53lB4VPtrfmmIOZ34NylguXSIWid2NC93K9XTZ0fW1UGfkR5cUJsX5VcpJLqa+M7BEA2rS6NzSXxRiwhbe9+Du+NivuhBD24Pe9EwUNBmLdEa5JiPT0Wwpl+E1hjIyljn4HwY2npJ6d8VJGN6PuLp67sQbMUREmdN9ew+OcPgC93KWeWrXXjFvRA1aSFTKrFoJWhRGFDgMnl1qxMYzsYQYigLpYcRZp8
 KzztoC18
 ddalysL6MmTcsy1Mvnkrg4t9X4LW/KeNaeIkse6TcVi/7LF0fbWNKYr86NQzmwNkl1+S6zPXwVU31x8HaC77KRjkNag6S54a+Ff33CxQX79jzMsuNMK42f9Pu0cX8/XjOeGnhaZ46RXKDArGztbrmvv3vJwngC1YcDm4Q4MJwM0pDsto7XsmS+3spOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Patch 1 fixes a stale warning present from the time when only migration
softleaf entries were supported at the PMD level.

Patch 2 adds some code into hmm-tests.c which exercises the pagemap path
for PMD device-private entries.

---
Applies on mm-unstable (404fb4f38e8f).

Dev Jain (2):
  fs/proc/task_mmu: do not warn on seeing non-migration pmd entry
  selftests/mm/hmm-tests: test pagemap reads of PMD device-private
    entries

 fs/proc/task_mmu.c                     |  1 -
 tools/testing/selftests/mm/hmm-tests.c | 29 ++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 1 deletion(-)

-- 
2.43.0


