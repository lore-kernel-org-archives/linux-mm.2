Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A193DCD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 07:13:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9BFC6B00A0; Tue,  2 Jun 2026 03:13:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D29396B00A3; Tue,  2 Jun 2026 03:13:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C67716B00A8; Tue,  2 Jun 2026 03:13:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B30DD6B00A0
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:13:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 60A54162AFE
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:13:33 +0000 (UTC)
X-FDA: 84834107106.19.7521F05
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf21.hostedemail.com (Postfix) with ESMTP id A441A1C0013
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:13:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=U9TXoKy8;
	spf=pass (imf21.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780384411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0qtKkckt9JyUfNuorH5TPUvvCM0+T6UIOHmjMyEJuIc=;
	b=jtXIHb2n3vgWMogiDngvPq4Az3I8/AHC+dW8X0QMv4Bt/k2lP3tf/UJTF4Ctr/SZ2Hdwh+
	SdIzoQ4PrXFwN0Z5aWQycMAxSv4Ny486qFX8jWh2gwTAzzoZSR7URzfbS+m6U+4o0mifrK
	uBQxBbO6DRTOhE/niNfIkAKgPHh6FEc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780384411;
	b=8Qps9WEQ1jHVh1OZDEkHRPivBVO+1r+D4knCu6SMiEXUZC/BGHLeUEYaxQ0YE3bN825oGm
	PfOFfvj/sWJWkq4krxBU9ETbjfFqbVBcAIFRz7+pOivSVPtJNwFEHyUXLv4JTpmu5jpmKG
	hB5QLo1af++nTgmdMfLn7ngq2n8/9Fw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=U9TXoKy8;
	spf=pass (imf21.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id E7874D0F5F;
	Tue, 02 Jun 2026 07:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1780384410;
	bh=0qtKkckt9JyUfNuorH5TPUvvCM0+T6UIOHmjMyEJuIc=;
	h=From:To:Cc:Subject:Date;
	b=U9TXoKy8bydOm/pB7jK9QzuMctLVKJB4ktSSjzPQi+i+j8sTGV0drs4RBpxeE2Sjo
	 RoMD99yfnZ2kPt9WKe2MfIzhrBeyINbBpFfp6qhjNpRIkmuR2E1R2YBLinHLChGmtf
	 8daVng1/FTEMqeLDiy1XWycaTB5WQpoaEhRAqq1o=
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
Subject: [PATCH v5 0/4] cleanup: Remove NULL check from unconditional guards
Date: Tue,  2 Jun 2026 07:12:49 +0000
Message-ID: <cover.1780064327.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A441A1C0013
X-Stat-Signature: ke1tgprq31aaajmy583s3rt6pu1niq8a
X-HE-Tag: 1780384411-901571
X-HE-Meta: U2FsdGVkX18D1Nb0epXp0ZhXrfHz2UxjdDk2Nhlvbqs+gYJpSGyjwW80dc4YjgIoctuvJ/9QaNJLGASLifMlRUbHrYeYqUrZRiz8oj8L2Vo9egK4iJO/Dzbq71qY0FZ14MoKn0ZaJiC1zTpcyAd0ocAORxwR0ZD3gbtaJFYjkYXKhO+QyF2IdaVD/ys0fIL84H7Sg7naaoqHJVh+NoVCqe3mXu4HGevdFwpIa6tV6kzhc4WrTU29wyWksWhmZgXzelfpL+eLt0kZIcSis5Qwdi6OaGpU53miwmihF5IxihQvPgh+MGBY+TSkyy6DH+jAUmgRE6Mgv8L1fhK637gsewfHyc43v38AChe/XkGdYIa/9F8zU3hLTXkrXYriU8ZGZjDI/PfQZdSFhd+spOX663ZnidNLBsi1ckkGI2z8wOppRIVwJUjpS6zLwUzwF3zlGf9ZN/bwLnNWiqiRCh6SVCYWjmeCMSnfsxdDdofA0cNQaWhbJ/royY0ycNGF2ADb9d7o489MqDWBAyoneQCZuYeC3yprTf/DuxRKU/qMb1HJLxUvlQRM4KMLXMjw7F20YZ4nxvvLpFuE+h1Mc8U/tNxmD9ywz9pu2izu3xxQx/vYbfZN4qtNcDCSB9ASaBoJCrK5w8dLwtIFusY7l7ykdv909sNyzkwGZlYRLs97SnPi70fW7mRVPmc7lKr1gTnM7T/rHdlam+PK8WrbkF/qNpwX8NSGyOmj/O98/ZUJH5F5yN92L1ZHxQl5cAGLwk7kEL4E6tFE4gdgHTwZ4pmrG2A2wGsPXVYvGnOnZjYVN5+E/LD6Gv6h4m1Uxk1oYaQBiFZk6L5TKBUQ1Jie4lVneQ9p1WLcllnH1NcLp0qvQ5ldhyICsCuHd+uu35tgePCAABNqgqTsJBVu5hab8itBi4IGpbhFPWx3Xt+O5U0LwOS+kI/KgnMeDXsW0t4kQRVnrbys0n+pzDauwmKylnq
 dpkAfo7o
 d4Xfd8f53B+J0hEn5r7XARkC4EUoQwXsUWZkQqJlJx+DY40LoSfmaCvMFyGW5jCOaS1DxSKEzTWPXitUjxynDS5kg80R/wmvj+KOYdq4+yvay+wKxiXUo2uGFM6EDlNjaUgXJ2mIAITg6+jFara/9Uvh89LtfiumQ612dFd8DDTmArYu1nf+36tdA65PSQBoSHIVLDBkITYc/zYSnrEbdYfXDK8DA/AruVPzbH8TrN7PI9jEGCnnjBhUuOfSv3MedkhqXVAP1eNi16gg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Unconditional guard destructors have dead NULL checks. The lock operation in
the constructor would crash before the destructor ever runs with NULL.

- Patches 1-2 prepare guards that legitimately handle NULL.
- Patch 3 adds __nonnull_args() to guard constructors for compile-time
  enforcement.
- Patch 4 removes the dead checks.

As compiled by GCC-11 with defconfig on top of the locking/core:

    Total: Before=23889980, After=23834334, chg -0.23%

Changes in v5:

- Renamed __nonnull() attribute to __nonnull_args() to fix User Mode Linux
  build failures (kernel test robot).
- Dropped Acked-by tag from Miguel, since I renamed the attribute.

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

v4: https://lore.kernel.org/all/cover.1779286416.git.d@ilvokhin.com/
v3: https://lore.kernel.org/all/cover.1779116497.git.d@ilvokhin.com/
v2: https://lore.kernel.org/all/20260512071510.92451-1-d@ilvokhin.com/
v1: https://lore.kernel.org/all/20260427165037.205337-1-d@ilvokhin.com/

See also [1] for relevant discussion.

[1]: https://lore.kernel.org/all/afCS4d4YccQFtvpi@shell.ilvokhin.com/

Dmitry Ilvokhin (4):
  nvdimm: Convert nvdimm_bus guard to class
  genirq: Move NULL check into irqdesc_lock guard unlock expression
  cleanup: Annotate guard constructors with nonnull
  cleanup: Remove NULL check from unconditional guards

 drivers/nvdimm/nd.h                 | 7 +++++--
 include/linux/cleanup.h             | 8 +++++---
 include/linux/compiler_attributes.h | 9 +++++++++
 kernel/irq/internals.h              | 2 +-
 4 files changed, 20 insertions(+), 6 deletions(-)

-- 
2.53.0-Meta


