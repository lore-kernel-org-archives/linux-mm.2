Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 172D6CD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 07:18:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37F176B0092; Thu, 21 May 2026 03:18:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 356BE6B0095; Thu, 21 May 2026 03:18:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 293B16B0096; Thu, 21 May 2026 03:18:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 139DB6B0092
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:18:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC0E5140558
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:18:23 +0000 (UTC)
X-FDA: 84790573686.14.00F327E
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3597E20003
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:18:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=m3aCTD9G;
	spf=pass (imf31.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779347902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lI9FQx8ShFhvPIZrLKYCCXVlmy7Lwsl7O7ulvfACmMI=;
	b=JNDf+C0SLrx9YU5zOQYClXayPhWlmcaCT6+k+KvA8I9A3rZbTmCmyIRoacBsWZRa/0YCl4
	rTVUzD6lJoNrgvo2oQ9s4wUl6ecxsboHV3sjKvIFAQopZuR720RepWguN6foA6EZrWMbeT
	JBuiesICN3zl+/CBju8EpdKDuUcpxWE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=m3aCTD9G;
	spf=pass (imf31.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779347902; a=rsa-sha256;
	cv=none;
	b=B+4ysPx9qHvHuQlWaHE+r14myTdlPig+3xgNVFomoA36aN8GhJEevXFLjADv3IBvAE9fg5
	Np6MTw1kMYv2OYZHnyz4xP81SPwIUJPNjnRfPjo43fmDx+Ix76mrp2c90OGxb7fq7SxOld
	0Z68r4BtOzJ9ClaCjZxDg5H7OZ8ul3g=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 61CFED0925;
	Thu, 21 May 2026 07:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1779347900;
	bh=lI9FQx8ShFhvPIZrLKYCCXVlmy7Lwsl7O7ulvfACmMI=;
	h=From:To:Cc:Subject:Date;
	b=m3aCTD9G4ehzIQeFoi/FvKLPBsCJ1EHAnXHzvu+GkPTPKU1Zk+FZFIiyHJT5NN9/O
	 4xaFY9WoD2K4oG+bVVLIOmpRg2kvfbya+1X0j9jxwpPcqJZ8iQCnBl913Er6ON+ZoW
	 +Rk2N6/Z2GuHOK+P5ltQMW+1IAbMAm3uuBxwc9V0=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Marco Elver <elver@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v4 0/4] cleanup: Remove NULL check from unconditional guards
Date: Thu, 21 May 2026 07:18:00 +0000
Message-ID: <cover.1779286416.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3597E20003
X-Stat-Signature: ucw36bftnq1mihihq8t5n7guihwyuum4
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779347902-870045
X-HE-Meta: U2FsdGVkX19rDhVksO+zD1flt9v4C3Qaqw3MInG4t41HvB8AYazP9sg7reLRkAkKWpHTGQuO4pUGTYhVeZY+PI8LyTTBzFYvprelIkfYTQZSJNSU3JxZTg03VwGJm6G8VkcgmZq+oMVE0xpEp77SAHRv9jhUYtdJf4ECInRUMC6PvUFT2Jrgi3WcXRKeQfBuegtquVJyFKdUtLYzSFrTsDeqXJJ/7MqqBFHOskKzvhhKgwEDgTLZy35NHQ7EvmgHdGDQj1GfulKR93l4dklydRP2YYTCV1hQD1SM7DgiHNVV7nX0RZ+I84flGGKK3juqGqzk6xM1KPmTibaz4XfOhSpTaTUvlN6pfJ/E4di/cOLILF2L/8dwEjka6TG6f97XxqFUfu/YI4Q+AfRjZlCQTubAe71OJBSkWN5/M0MiMdgKVWEVo7MTnQ0Q7LWzgVES2045EUlFWPDBVZ8cTkSMThEB44cZg0tZUGzCdCQYKxhb3sMlkjNd8ZajbwJ176LbJSCGkmkfFROK7eukMVNZRijoDRuigqieKxiDAxa49kpquSBlRx7xBi/J30/tPDnN2LjIgaPxmdGkRKW1krO/4H7tJ80ghJpqnw6dil0bgwtHm214BFj2oP9sFlHF1ArBADMLEbLeSl8LVYeEuMjLEPv/vd2F1I9BB73H5invjyeXoLWWNX3SbrQoHTJivuRMWtAclbCvZMbgZpHJK894mG4r/M4Lzw3RnZYIjNluZb0cyLNlGP7UndXmSUTHjZg5UV2dvRvasmUiiQwV2WEAUBWH7LknDfl305I0SmW3AIXE9tbxErQ/2ylgPfh2lj8NtgiySNY3dr5eP/Xfn1qE8ykI7A/cV6jGwY46B9UzOanB9XR/sDIhkkQYxMgWhw0/xidTCgurSAJX3aybCXdz5du3LxBGll1t2OyFsWVzLeCJeDG5TPfe7ZinXQ20fzEThLy/TfH85SVrOqFoVPq
 x2Oz+ZQ4
 bA6qrrItVI0+wnOxzmBFNJJBAQW8skNZEmCmj2z0blqHZ8VQe3f785zretRba+kiyG7O+P1DD+ZwS0mypRaVUV57+WqIIVlF6dhy2XfVh/ZHR6NZLLKewlmb8NurNzRXMouxuDnRn+6pITdeaz2h6ZWJGwFaBDC1wr7EaS1UdcsdC3uauSSHG/Zds/wEFkuMTFKVKMsWjC2DEJB4U0NcCNq19IRAAkyBMv9iAhMZP//woGbiqlg9E2EIWgQTH5ivsosEV66WeJ1w45o0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Unconditional guard destructors have dead NULL checks. The lock operation in
the constructor would crash before the destructor ever runs with NULL.

- Patches 1-2 prepare guards that legitimately handle NULL.
- Patch 3 adds __nonnull() to guard constructors for compile-time enforcement.
- Patch 4 removes the dead checks.

As compiled by GCC-11 with defconfig on top of the locking/core:

    Total: Before=23889980, After=23834334, chg -0.23%

Changes in v4:

- Re-worded commit message paragraph about nonnull "compiler-enforced
  verification" (Miguel Ojeda).
- Fixed GCC documentation link for nonnull() attribute (Miguel Ojeda).
- Placed nonnull() before nonstring() in
  include/linux/compiler_attributes.h (Miguel Ojeda).
- Picked up tags, where appropriate.

Changes in v3:

- Audited usages of DEFINE_GUARD(), __DEFINE_UNLOCK_GUARD() and
  DEFINE_LOCK_GUARD_1() to make sure NULL check removal will work correctly
  (Peter Zijlstra).
- Moved NULL check into irqdesc_lock unlock expression (Peter Zijlstra).
- Added compiler-enforced nonnull() check for guard constructors.
- Converted nvdimm_bus guard to class.

Changes in v2:

- Expand commit message with detailed reasoning, why the proposed
  change is correct.
- Rebase on top of locking/core.

v3: https://lore.kernel.org/all/cover.1779116497.git.d@ilvokhin.com/
v2: https://lore.kernel.org/all/20260512071510.92451-1-d@ilvokhin.com/
v1: https://lore.kernel.org/all/20260427165037.205337-1-d@ilvokhin.com/

See also [1] for relevant discussion.

[1]: https://lore.kernel.org/all/afCS4d4YccQFtvpi@shell.ilvokhin.com/

Dmitry Ilvokhin (4):
  nvdimm: Convert nvdimm_bus guard to class
  genirq: Move NULL check into irqdesc_lock guard unlock expression
  cleanup: Annotate guard constructors with __nonnull()
  cleanup: Remove NULL check from unconditional guards

 drivers/nvdimm/nd.h                 | 7 +++++--
 include/linux/cleanup.h             | 8 +++++---
 include/linux/compiler_attributes.h | 6 ++++++
 kernel/irq/internals.h              | 2 +-
 4 files changed, 17 insertions(+), 6 deletions(-)

-- 
2.53.0-Meta


