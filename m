Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2788FF8877
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 12:02:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F2526B0092; Wed, 29 Apr 2026 08:02:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C92A6B0093; Wed, 29 Apr 2026 08:02:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DF0A6B0095; Wed, 29 Apr 2026 08:02:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F81B6B0092
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:02:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 53529A01BF
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:02:30 +0000 (UTC)
X-FDA: 84711456060.19.6A4F8B7
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6001D2000B
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:02:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=rjDRlN12;
	spf=pass (imf03.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777464148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CIMfHKzu00bESqaVaEzshiKq4od7yyFz/e0DkVUybE8=;
	b=YfW9ZIbXAyKRKGpQAjZjr8YOvuqryIvxPLcSluoSaEdwFO5IzZVnhqNV9bVC3rUWLeM5Yu
	XZoAN/eBdIQGpN6AWXdeYmoIFbz42/3/VeMj3kYv2UjXd6LAWBwgkKeish3nURZfASgdSP
	9FIdwuVC9kBm4FX7QHkZyOnyjfpKeGw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=rjDRlN12;
	spf=pass (imf03.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777464148; a=rsa-sha256;
	cv=none;
	b=dVolVX4jL9gxf/51MX3ph3/qbWPGEUAxqHSd+m5Afx9Kyag6kye3No/T7cEIEf2fhErQrr
	ikIoK505C8qtE7pg0p2ETWp3cfwnqpy92oYm0BL7QxXbJamVoXn/Z6vtP3FNCkzuV1b0rn
	1kY7QiAB9y+jgVIQd7lEsmGOIodR3BU=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 45A72C7A79;
	Wed, 29 Apr 2026 12:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1777464146;
	bh=CIMfHKzu00bESqaVaEzshiKq4od7yyFz/e0DkVUybE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rjDRlN120+b+yTRJyta7epzJ8i8aBzPyf8KjQobRBrimEcy9gpyYEb2/PvFImB5T4
	 s8UY6eXFGD8UkOHBn4MDFIV4ov0hlnZzIk/Y2+sYR1spgR+9wNiisB4vu8xr90Q98f
	 K3i1XFCN3j8sRKCpDUlcGoKgpRe1DEircd+fiQvo=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v3 0/8] mm: use spinlock guards for zone lock
Date: Wed, 29 Apr 2026 12:02:05 +0000
Message-ID: <cover.1777462630.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <13149be4f8151e18eb5f1eb4f3241ab3cffb373e.1777462630.git.d@ilvokhin.com>
References: <cover.1777462630.git.d@ilvokhin.com>
 <13149be4f8151e18eb5f1eb4f3241ab3cffb373e.1777462630.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6001D2000B
X-Rspamd-Server: rspam06
X-Stat-Signature: r3gcxzw8dac6g15wkpmrikazx4hccexs
X-HE-Tag: 1777464148-400241
X-HE-Meta: U2FsdGVkX18JSiqrRdB2p39FqUCztyp4i7iNDIA+7g4PRW1xal87RfP1dtzNQkT9FCftgQLH9F7ljENEEK9NGDUkSVJeAzJkgSEeyQkbu9GTWk/AMGP4DkdjolKB3rsMtSQgQ0sTMXmKCjuE+98jsaARZQi+2Y6sFl2nLFrqsDU27mUugMHAInOf7LItGHeRwnQvILG6eBK6NFvFSZxlOTrqVlZNu+Bv7jN4LNO7H/NM748TMiWOs/4i7HAo7hgYGrazMWoGkTyhke1ZOVQK9+zZ+S78JfOMJaRMzIk3a/IdefHckw2tzyVxStYUNG5GqOuh/aNMbBKVNXUNcVhDYMGX9YGOc/2DVt6pLJXbUH6PnBqYQ8KRxaECUGoIipBSZJu5GCiKlc8ka8ZTcBvyS0oGfVtpV0Lofn7H5+4RWYAdvTg3QWjBrimuKPI5z/5yhjcoDDH9EJ1vZwYfgOe8LtulBUHa847hLniPybwAnlK4nnTI5zUTaJdcv1gaoVTJpnmAccBTVqi2AYXw4O1G++bbOlSNRy1plhE/jFH5aDRMzjlxJjQU90mUQnW1lKB5c7B19/6TDioxFJD7HZRN382Oz6KXEiq3ZkkhC+ZGd7V42Xp/S4OWTNrVbZ91E1K3kyoxQj5/out9agwTUrs6Xy0jf/vNeOKIkFXRhKVx8x5FLO4C+rv5XJUmaAXsdjmsnK+2e6t9QBCqjnP7yxRTCI+Eh5K2dWpFFhsFhg1lUl2yFrfkodADAbpv9IZXCR2XLywUDAS5LBZY3/MtIM5MLo7uTbLAGYdi6tQvTv29jGCwOjcISYXxVldzbHKTIu0h5wNz7yaoX6B+8r4RODRXU6nfJh/qcQvvctSl/oAT+kAi8t0rwR5QJ3gkBLZhWkAMD6AiA43p5erHTNKi403UhZEARzP4jBcPOPFNoU7S6Nx/57/o9EBpD/TcE56iPt7Xei46JQ4X/sn/67A5EAK
 0lobLDuw
 7IccEV4DiRzvtBbkMfvFdznE8Pyf7/ul+cGwDgbvPC012bbPCT6G8Q5Tc0H/Uu1SCwyHHzjsfkg/tVGQJhbfiiMM0Ea3/8GDr3QpDi8557eTkX0KyAm/NDigbCz+iysYIARApofNwlnzB9SQhtdsYhaJFWDA76V3l12kUCrboyIjsXVNgNihaRMgDdts/gmm4cYIvXVB9iVw7q7zElvfJLSotEMnTyD5QXwxMeQC+R/bwXLZEbFa/6cMwGnrcDiH3amf5WmtLbPipg+Lri5HKSwofRdNHD07lw93S1iPcm+JAUCXx57aCMBkJgzTgaRJs/jsum0w0ipZSS7rMpRgfq4s0LuPtR30ET3SCzmgmg4ekvL36aIPQofVHL/9b62Lg+Mhtd0W7AU+9Ijw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series uses spinlock guard for zone lock across several mm
functions to replace explicit lock/unlock patterns with automatic
scope-based cleanup.

This simplifies the control flow by removing 'flags' variables, goto
labels, and redundant unlock calls.

Patches are ordered by decreasing value. The first six patches simplify
the control flow by removing gotos, multiple unlock paths, or 'ret'
variables. The last two are simpler lock/unlock pair conversions that
only remove 'flags' and can be dropped if considered unnecessary churn.

Binary size increase is +39 bytes, with Peter Zijlstra's fix for guards
[1] applied (already in mm-stable). This is due to the compiler not
being able to deduplicate epilogue and eliminate redundant NULL check.
See discussion [2] for more details. I proposed a patch [3] that fixes
this, but until it is merged we need to assume +39 bytes will stay
(though it is compiler dependent).

Based on mm-stable.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>

v2 -> v3:
- Rebased on top of mm-stable.
- Added Acked-by from Michal.

v1 -> v2:

- Andrew Morton raised concerns about binary size increase in v1.
  Peter Zijlstra has since fixed the underlying issue in the guards
  infrastructure in tip [1].
- Rebased on mm-stable, since the patch this series depended on was
  dropped from mm-new.
- Converted guard(zone_lock_irqsave)(zone) to
  guard(spinlock_irqsave)(&zone->lock).
- Dropped redundant braces in unreserve_highatomic_pageblock()
  (Steven Rostedt)

v2 resend: https://lore.kernel.org/all/cover.1775654118.git.d@ilvokhin.com/
v2: https://lore.kernel.org/all/cover.1774627568.git.d@ilvokhin.com/
v1: https://lore.kernel.org/all/cover.1772811429.git.d@ilvokhin.com/

[1]: https://lore.kernel.org/all/20260309164516.GE606826@noisy.programming.kicks-ass.net/
[2]: https://lore.kernel.org/all/afC5C6fylF4AsITV@shell.ilvokhin.com/
[3]: https://lore.kernel.org/all/20260427165037.205337-1-d@ilvokhin.com/

Dmitry Ilvokhin (8):
  mm: use zone lock guard in reserve_highatomic_pageblock()
  mm: use zone lock guard in unset_migratetype_isolate()
  mm: use zone lock guard in unreserve_highatomic_pageblock()
  mm: use zone lock guard in set_migratetype_isolate()
  mm: use zone lock guard in take_page_off_buddy()
  mm: use zone lock guard in put_page_back_buddy()
  mm: use zone lock guard in free_pcppages_bulk()
  mm: use zone lock guard in __offline_isolated_pages()

 mm/page_alloc.c     | 53 ++++++++++++-----------------------
 mm/page_isolation.c | 67 +++++++++++++++++++--------------------------
 2 files changed, 45 insertions(+), 75 deletions(-)

-- 
2.52.0


