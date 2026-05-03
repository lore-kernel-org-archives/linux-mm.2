Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9E2DCD3424
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 12:35:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 508746B008A; Sun,  3 May 2026 08:35:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DF836B008C; Sun,  3 May 2026 08:35:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41CC06B0092; Sun,  3 May 2026 08:35:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 334646B008A
	for <linux-mm@kvack.org>; Sun,  3 May 2026 08:35:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BBEA412095C
	for <linux-mm@kvack.org>; Sun,  3 May 2026 12:35:51 +0000 (UTC)
X-FDA: 84726055302.15.22843A4
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf06.hostedemail.com (Postfix) with ESMTP id 75F61180002
	for <linux-mm@kvack.org>; Sun,  3 May 2026 12:35:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777811749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=9IsycYRq2sESwgeMkfFiHckUpMm8if12/F8jTCKi5TU=;
	b=MCWcODV3/BcJvVYd8GwG/73MJnkJGYdvk3RwDWR06TFsV/I8tVOLNvTtTLdrCiIWHnfvQq
	c2zdtjp1s7QSVNbRzzYAznHNVraVoHWpYfp4kI00k4dBn/aRS4uSktiKH8G2cG25q1ATzI
	w7MDwrGdfAiCzxCrKjvcDmxgmJRpyB4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777811749; a=rsa-sha256;
	cv=none;
	b=4ATp+4xx1I5+A+WK0KVbZbF98YPc4wfhAskPx9uTSZDyqYL2BSoZeJxvZbfigFz+X6cynT
	Fo+DB2fz47csT61eR1QgJs1GRXFhNK9+lfLVKxmNQN3pAqtvOoETWV1+ZJspZ3EU0Y3ZNb
	6dPoge2kL6l3/vyePvCYtOcH5qELQYw=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4g7klK0C0zz8Xrkn;
	Sun, 03 May 2026 20:35:41 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 643CZacO015769;
	Sun, 3 May 2026 20:35:36 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 3 May 2026 20:35:38 +0800 (CST)
X-Zmail-TransId: 2afb69f7411aa96-4b76c
X-Mailer: Zmail v1.0
Message-ID: <20260503203538194jFwVGloy43M1F3sQGaFt7@zte.com.cn>
Date: Sun, 3 May 2026 20:35:38 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
        <hughd@google.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <michel@lespinasse.org>, <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHY0IDAvNV0gS1NNOiBPcHRpbWl6YXRpb25zIGZvciBybWFwX3dhbGtfa3Nt?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 643CZacO015769
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Sun, 03 May 2026 20:35:41 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69F7411D.000/4g7klK0C0zz8Xrkn
X-Rspam-User: 
X-Rspamd-Queue-Id: 75F61180002
X-Rspamd-Server: rspam06
X-Stat-Signature: 1b77s44k4yyzaqdkmnjc9hcmaz5ajs8i
X-HE-Tag: 1777811747-693173
X-HE-Meta: U2FsdGVkX18NbZ0FDRc9Hdlc3I1R/3BGfEpx2CzoosXvKof3o3m0s8uA3gkk+GL7FxqZFjUr87A+mnt03EqbnhbUnWR5J+v3c4pdyV3pWCKZoKZwjQhw/InV4ujQsWh/czkp9Y566wrLI1Ohnx8V4nGbb7EsCP5W9JEwHcBgHTVfl7AX/jeRW51UgIZh4SWZ1iUThkbw9pgxkHd4lxuA+Z7jQNTSLOshkrwuOpecW1Fkt5NS/7V7h6EzOSxCnB8i5zp7cP9SjoVV4hhenuViFwjdArLCEpnc+d3lgo8tUofSO2IplAjgOCZdThUH/j0ODm7IzI7OkiCibQJH/ssoLmSQDX9Ce8ns8pbfAvwRoQKMFKwb5ljscn2ki1ZCoLnKNss9oX3IIgWr7tRMmY4z85eiWos51SgptKlYC633ombeQqOy/KK9qsqNegf5YrtFNF+zGpWA/GdoeG58bf4gAmk/jSzaBPOayoaBVZd2aeVWU0hpRYPHER94Fwzhq4KCCAuAcsJqoE7fk8JDfjj++TCy68xgLmN4aic1fW9MLYZTqFarGARbS/PZqK4VkcC6uV8/GQ40AuCe3jDp8qU+MVsb4mm1h05hdMcs0rpdnxcizi6wGHJMDDO1eIqaSoMiIql7CDx6mW0hrOpkp1N0kZY64GKHEbLbQlJTB596W3o+rXy5Zgs5OHYFFyuySZzper+HR/nJOnOHzljZ4qkhIvvB8Om3F9d7coPOEQera+B+DqUa33KKoBQ6oQL73EEytotplQ3i6zTQaML8y4Gtwu39pe3f7ssG08aTCoOYmJ8x1O5wA+yNzl4jj6d+mYRSryiNmqxIXeiXGdg0x79oOwU8nfZwth0bc1ZRSmjM+uI0Gd/HIR2TEW0Nib/6Gf7wj8JDLzgtBVOsIzlNLfhpC3qic9z5M4tbdMcl2Jyu1QXm/SONTKK0ZuD7cxAebY+XZBDvZNEWmzMgxUHXa/4
 4eRfuDyI
 2yyY9/sl1Lpl8DhMR2t9gJHV0qM9ESTcZyTtJUa22vstaRKHEFxm7qzA8KipSmNMA5CkCbUI7m13SFgas/kHyN6hFFsFuOQIJ7kHrxoQT9DYEbU7SjiAz1qb+tu6FPNCeCgf/1c0JWEIRHT/3oUEgpFjgbLVM3os4dxS+e9JgcBCS14osExeGheOh+9DFUqlGfEct74sNMZ0mQgxBpsRVIk3rE77nmA5Vv43zeqB3P1ANz86ER1P8FD/+J92os1aPC+lEMruVlGlppvgof3SEdGkOj2uQamhmtqVXWJsFecE6E7Xj8GNmVhGyWDagQEapzI/Gi0cx3agyz74CMu5rO9s0+wW6XVNLD+3t0Vg2gxnu4qxalAliDDK9FoqrQopOZ1Al
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

Deep investigation revealed that rmap_walk_ksm's 99.9% of iterations inside
the anon_vma_interval_tree_foreach loop are skipped due to the first check
"if (addr < vma->vm_start || addr >= vma->vm_end)), indicating that a large
number of loop iterations are ineffective. This inefficiency arises because
the pgoff_start and pgoff_end parameters passed to
anon_vma_interval_tree_foreach span the entire address space from 0 to
ULONG_MAX, resulting in very poor loop efficiency.

An initial immature thought was using the "rmap_item->address >> PAGE_SHIFT"
to be the pgoff passed into anon_vma_interval_tree_foreach(). But this is
flawed because when a range has been mremap-moved, when its anon folio
indexes and anon_vma pgoff correspond to the original user address,
not to the current user address, which was pointed out at:

  https://lore.kernel.org/all/02e1b8df-d568-8cbb-b8f6-46d5476d9d75@google.com/

According to the implementation of anon_vma_interval_tree_foreach —
it essentially iterates to find a suitable VMA such that the provided pgoff falls
within the VMA's range [vm_pgoff, vm_pgoff + vma_pages(v) - 1].

So the solution is to add vm_pgoff field in ksm_rmap_item and use vm_pgoff instead of
address >> PAGE_SHIFT.


Changes in v4:
 - Add a tracepoint for rmap_walk
 - Provide a testbench for rmap_walk
 - Add vm_pgoff field in ksm_rmap_item
 - use vm_pgoff instead of address >> PAGE_SHIFT (Suggested by David and Lorenzo)

Changes in v3:
- Fix some typos in commit description
- Replace "pgoff_start" and 'pgoff_end' by 'pgoff'.

Changes in v2:
- Use const variable to initialize 'addr'  "pgoff_start" and 'pgoff_end'
- Let pgoff_end = pgoff_start, since KSM folios are always order-0 (Suggested by David)

xu xin (5):
  mm/rmap: add tracepoint for rmap_walk
  tools/testing: add rmap walk latency benchmark for KSM, anonymous and
    file pages
  ksm: add vm_pgoff into ksm_rmap_item
  ksm: Optimize rmap_walk_ksm by passing a suitable address range
  ksm: add mremap selftests for ksm_rmap_walk

 MAINTAINERS                          |   3 +
 include/trace/events/rmap.h          |  49 +++
 mm/ksm.c                             |  48 ++-
 mm/rmap.c                            |  14 +
 tools/testing/rmap/Makefile          |  11 +
 tools/testing/rmap/rmap_benchmark.c  | 488 +++++++++++++++++++++++++++
 tools/testing/selftests/mm/rmap.c    |  79 +++++
 tools/testing/selftests/mm/vm_util.c |  38 +++
 tools/testing/selftests/mm/vm_util.h |   2 +
 9 files changed, 724 insertions(+), 8 deletions(-)
 create mode 100644 include/trace/events/rmap.h
 create mode 100644 tools/testing/rmap/Makefile
 create mode 100644 tools/testing/rmap/rmap_benchmark.c

-- 
2.25.1

