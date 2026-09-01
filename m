Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6320EC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 06:55:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 619556B008A; Tue,  1 Sep 2026 02:55:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C8ED6B0092; Tue,  1 Sep 2026 02:55:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 506566B009F; Tue,  1 Sep 2026 02:55:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 30C2E6B008A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:55:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C23F16030D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:55:02 +0000 (UTC)
X-FDA: 85164281244.13.3DAC73D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id AD4861C0002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:55:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iVCF8hbH;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788245701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZqHJxMj9cZZ6xGbdiah9c7VOBxKeP9sXbxqvcW+iWvc=;
	b=6scZ4OXYzRJTYdNqg0kXtS6GdIEWDSSDGvxWoJjUK0vkYl3HCLfXKh81W7apE0QMWGee+a
	LEwJCwPWMmAILhlaHOExjiJ/rMLNkocC+Qf7prPScapBPd5lS+/XfCLlCg1hew3UiR7aBE
	noL8cd9ttggU1Xt3Uguy1Ng9Icb16RM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788245701;
	b=Q14JvJV2Qmbu68iuQCvFMs0hFK+jO+DgMcMaNYDc9yNB8Hn5zJm+7CJtj+LcpC2frldUc3
	jIy2ilCRFxUEgkIPguuqhMnEMNGg7RraTzbBFDVk/dSpoVoM46dz0CU4vIGcYVgIkqiat8
	TC3YyNPQ4IuRQpUBMN1xJgi+dzOYMFU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iVCF8hbH;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BE94D1AED;
	Mon, 31 Aug 2026 23:54:55 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C0D243F85F;
	Mon, 31 Aug 2026 23:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788245699; bh=ce/DLlpHBRa0sOyR5fJVD2nnBUjY9hH50UmSGmi9zDo=;
	h=From:To:Cc:Subject:Date:From;
	b=iVCF8hbH09QwEoLLCy5nDqwnQnUTRnYnxct0R9KGT2fNm28OZNlKPL5y/ZVYyLarR
	 G97VWOjRF0iMyiyBQyL+rUoh+K5lW9l0oQHRuBhT9ntBgfqe+6OndnwbdmNSBBFsWo
	 ltBmtg/ObqlFYO+SYLvq4upKKiNCWbiCa+XhNDso=
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
Subject: [PATCH 0/2] arm64/mm: Standardize printing for pgtable entries
Date: Tue,  1 Sep 2026 12:24:52 +0530
Message-ID: <20260901065454.1906343-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AD4861C0002
X-Stat-Signature: payre6dq3zdjubgwnaqrcaomyhzgy4c5
X-Rspam-User: 
X-HE-Tag: 1788245700-659126
X-HE-Meta: U2FsdGVkX18KOSq677U6sL9A+e3M2auS4vu2pXs2fYKanFyZijudfYbdp3hlaL4RXwesbLgiQ7SvmkKpwQycMk2jBqLkWoIfiodA+WdG/arcRHH5RRfv412zCloictAs1pTSDQ0eSNSP10xYuB9dgosT3PUjWPx1poxMTkI0AsZt26FgapcAK3/lFRl6vT9X4+GTW5XVk/tYND5OzbcodeokC24HTfJC4vUlHhina1rikcvE9PzRr014OORhftJyxLi4VqyK/umWhaG+/qK44P9iFofu2np0g/lsqPG1A1F/ecpjPAReuB5N//QH9hXGhUo6Ia0KJVqfl+gVJ8iDHhC3lnXuafocXlaiXWPmNv3fe1QSbmKzRt0dyPq5zjyFRtzMfbk8Sfw/kBJ53zjPevJQ6cARizrcjEXlR656jMaVa5rq+r+o6xCEiy1qgXlyR5BbnTiptZ59yN2Z+68gGwC1VvldOoJ6C3JQ3f4dfDffN8dvR8/fdpZ981lt48GOmpLNfmLzkFt+CbrOB0Db+D4smawC52hi+/3wrtAQmSE9wc7mC6rr8CFQV9qOsG6f56AhRP51fhcyOAkveZFXfVGdw4YPWaA8cobHEau5s77lKezHcMxgFIB5OhvbMOg+FEUHKg7Iv/zcSoRjkQwI24BNl3HB51Bled2/2J2jR5qJBCNHvgXv7ZtNFl3PljMlWCfhBJbxL79JWpPMk76Z9iP6xVrG4IkYCYy8XmYHwe0MjVyoELVXqAzrOGkvqxmdFu4Tvz0so7OoMHAPquKbA24Jp6g5CYHnVvKPFZjwkIexbALw3tnmtz9YkCnHgER5m878wn7v6lEin2u/P5eM5RKxXCTNYcJ8AXZFFCf1MeSj6FZIIqGTztB7DkW+wDdwP4uVWULYDEKIJclRmaHHjvAoq7uoZv0VUNhpBTp4z+43pBjLarGS1tnmYnuKrRyE1DE8TjQPOJ1u7rlEEaQ
 +nsg1eVR
 Gw8Th8c524t7WB2v88hzBjylUNIVmACoVKJhAxxgOK89vQGs498wJrurHUrgZxVoiLkxZdxHMyOd9mHHpOQS9byz84Fn12DjSKOjoKFd3+PNesBD6o/CTGtJ0KGPeQ0ldh6gAM6rgqqj8ntcVmCk5k3vr0omvBx8bX/M3V5qvADoUd5xn6nlDSxc6HRck18fq8p7t2WY6rlTuuQE9CuRJSgdT+Rs86VKdtk5njkdT8rp/8T7P7YX1MyI0Ci04lQkCsTCWjzYKBMzHD6GCEbQW9mP6WuXwpIwv7eD/33LUr55qUemv7KuAdEcbB7u4uLUXV7COPSkTUDytoxx14QhLxv0yf8QFJCVmVqYKJE/XIsZXi9Ier24Mj0TU6nvRSVsXjpmujCaXZ4S6aKaSzW1GsstiGOcYecBBdzH6H/2s2znCEqNUoeL44PRybhZ3+tvI5VvNTH2Da7yh/WcW7wgNYLNJTXd6E5OqDmlPUFOMO7sfRo4=
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
print standardisation proposal which was earlier part of the D128 series.

https://lore.kernel.org/linux-mm/20260729122452.3797443-11-anshuman.khandual@arm.com/

This series applies on v7.3-rc1 but after the following.

https://lore.kernel.org/linux-mm/20260831054331.625505-1-anshuman.khandual@arm.com/

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

 arch/arm64/include/asm/pgtable.h | 47 +-----------------------------
 arch/arm64/mm/fault.c            | 20 +++++++++----
 arch/arm64/mm/mmu.c              | 49 ++++++++++++++++++++++++++++++++
 3 files changed, 65 insertions(+), 51 deletions(-)

-- 
2.43.0


