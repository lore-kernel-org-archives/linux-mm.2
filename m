Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41AB9606AC1C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 10:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QOVpmjIb
Received: by kanga.kvack.org (Postfix)
	id 3B4FF6B05B1; Fri, 30 Oct 2026 06:59:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 374796B05B3; Fri, 30 Oct 2026 06:59:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B1126B05B4; Fri, 30 Oct 2026 06:59:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0A07E6B05B1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:59:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F233812060A
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:59:53 +0000 (UTC)
X-FDA: 85378997466.30.5497BA3
Received: from mta1.migadu.com (out-221.mta1.migadu.com [95.215.58.221])
	by imf22.hostedemail.com (Postfix) with ESMTP id C06E9C0009
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:59:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QOVpmjIb;
	spf=pass (imf22.hostedemail.com: domain of liu.yun@linux.dev designates 95.215.58.221 as permitted sender) smtp.mailfrom=liu.yun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793357992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vziFBOVKclDdUFksW/8nizqKn6YzugA9FE8OWBNsw6Y=;
	b=dwGgKEbHV7fURzrfbpIGe0AmyjbUHeV8GGm3bPTW0h67qKrkpc+9Xi6P7xY5GCyujYlT6H
	tr3ImF+Isr5Rnu6ziXGSOsqOz5mXp5Kpzl1jMCeWWM4Myi0CzqhttFCvT9DOilINcLErxO
	WbY06OGb4TDHhL6KJBr+NQTauLkgvc0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793357992;
	b=6UtW01T9GhqKlCZnp8Ze7YCDk+hTF7rvdf4x50Z44PzQ8CPb3mkAxqiAVq08fr69uIDTfT
	pEdHrolQHa8C/Cac8Os7zc/LBmAMRC4DmSbuHbCeu4eT5Rikd9oPszugawb8mYKNY4RnQl
	x4ccME1+0PibFRs9Ygk5WFY+FiLgFLI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QOVpmjIb;
	spf=pass (imf22.hostedemail.com: domain of liu.yun@linux.dev designates 95.215.58.221 as permitted sender) smtp.mailfrom=liu.yun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VzDmls3xFLsfubnFzXQlx1U4XfDEnnN9KmRFzEhDzIQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793357990; v=1; x=1793962790;
 b=QOVpmjIbMsK4a0sCC/JyqeXysKcagljWXqo6wT/YtIwC5IZIiJtI9K4F4M2FzFeJ29gi841I
 m6DEK2GK/bTugMSpkdvORaiUuUdBw8T28lZ/fMJyYq97PYkPT0yUGf7p0181+ihSZ4wkaANxcMq
 AKDE46C4cZJCcO/BqsXzH2Yo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5ee6d4bb77ebb1ef;
	Fri, 30 Oct 2026 10:59:49 +0000
X-Mizu-Trace-ID: 5ee6d4bb77ebb1ef
X-Migadu-Flow: FLOW_OUT
From: Jackie Liu <liu.yun@linux.dev>
To: akpm@linux-foundation.org
Cc: palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	glider@google.com,
	dvyukov@google.com,
	elver@google.com,
	pjw@kernel.org,
	alex@ghiti.fr,
	linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com
Subject: [PATCH 0/2] riscv: fix KFENCE pool initialization
Date: Fri, 30 Oct 2026 18:59:31 +0800
Message-ID: <20261030105933.4180-1-liu.yun@linux.dev>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C06E9C0009
X-Stat-Signature: 7o1zyjh69hrjoq6jdumnt1bxscwck8ye
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793357991-452721
X-HE-Meta: U2FsdGVkX1+LYajiz7ndd928/NsRaeH578vlEBbHnNc7Z4VLEcQU4GZqBQttI1P9BLl3WX9SuvN61UKqCCRkz5T7KvGi1qKtUll6ynoDsGGztcLqVixO/iwaz6sYVAtUQUlaogo9OXkLa2hVpYNkEcJrZdKDXU4V2WJ1u27KPe1l8cKROrGkHxtq2qZ0Rb48/1bmc+pOs9oUSH+QOztWEyeKovmDdFIlgzvYqnPsZ7LAqGPot5XB/72kkrE140/X5pqOC3Z82BkstAKK/qHLTzR2lxfpP4NDzt9x0HgLUFzBsIsl/NbjEz57LwCMLIc2TiTdlX63E4YKXKAvWxnCJQu6uOMW7nNlvtnB1T8wNz2OGlhlGu2X8Hhl8L7KQ/Ia578U2CTEsqNxrdOFJyABxV2EJyhg2UneZEmw/Pb4wv8/MU85E8m8+LJFM8Im7tIZvBNsHclNtEF1BB16e9Lka2VD84qf7yUPKKO9oJhB5X8F3UviUqrUeHb4f39YluP7s9/9dxdp5C8WY8o9lrezbN/kcvRKDgr7+U6prIYuUhNsQ0Fo5gbjn+eQeiIxMaTaOrQf8g4sVxPfzlQ7yExfJfmEqnwVXnjgK2avXaN8jH303A08O89Bp63plkPDrZf2OepsYerS3FxYL6U+mbdji8pJq60l21SwQLX35orrNdbWE1Qu9XY6zlzmWkgpLMpocLG0B6wIMsO8kfg2OoAKONFzs3W729YLXlDqHMGJyeIXNbzre8iRSuRr+geW/DcRjhcrDILF3YacqggHvsFGvHig9t18PfBJKfrIVJodDoF6YujFpgfuifMBuieyZ9tL7JcaiwmFe3646q0Mmzg71XlQVOuqMqrc7PIAgsiuvZ56dkWhuZvKmk+Ya0k874G2Ws8ip/gLhNEVz1xXXO7S4Fi5zI3S0SImKkeiAoNRijg7Oq7R45YXb+Z1Ugh3pdVKQeYatLStrW1QFeyAKK2
 YYQLbKF+
 TxyKEGKhmb+hR7SCXyV4zfQEnv9qEfqjpDWI6yWBBDGE1jUTyuXBDSQhL/7h6Zs3u+Lh+wqI02QhnQ6Nw/u0S6/Fwh20/vN6yogWWhkQQISVQypqu1TTcKpd7grQDH16efNyzldLGfUMTXaPJ5NE+N9VNOgPsw8q8ljtt0NnlGybHXhJpO8Voh0uDEZqHNxG+3RpfOZbLvPEQd9Djv5zCLvpF8pWMhq2JGShY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Jackie Liu <liuyun01@kylinos.cn>

RISC-V KFENCE pool reservation failures can prevent the system from
booting. These fixes allow boot to continue with KFENCE disabled and
prepare late pools with the page mappings KFENCE requires.

The first patch fixes P4D leaf detection in the linear-map splitter.
The second uses that splitter to prepare late KFENCE pools, while
retaining the early PTE mapping.

Built RV64 kernels and RV32 pageattr.o. QEMU KFENCE KUnit covered boot
and runtime enabling, pool reservation failure, and page-table allocation
failures.

Thanks,
Jackie

Jackie Liu (2):
  riscv: Recognize P4D leaves when splitting the linear mapping
  riscv: Prepare late KFENCE pools with PTE mappings

 arch/riscv/include/asm/kfence.h     |  4 +-
 arch/riscv/include/asm/set_memory.h |  3 ++
 arch/riscv/mm/init.c                | 23 +++++++++--
 arch/riscv/mm/pageattr.c            | 59 ++++++++++++++++++++---------
 4 files changed, 67 insertions(+), 22 deletions(-)

base-commit: c339f4010dea8b0d754f84ace70cd1b089878ef8

