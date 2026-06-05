Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43187CD6E7E
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 23:37:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 442996B0088; Fri,  5 Jun 2026 19:36:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F35F6B008A; Fri,  5 Jun 2026 19:36:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E23D6B008C; Fri,  5 Jun 2026 19:36:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 166E46B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 19:36:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A9CAC8D06E
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 23:36:58 +0000 (UTC)
X-FDA: 84847471716.20.65AE7A8
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf03.hostedemail.com (Postfix) with ESMTP id EC37C20004
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 23:36:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="wXi/t++F";
	spf=pass (imf03.hostedemail.com: domain of 3l10jag0KCDgUVbcmbYeVUjUnaiiafY.Wigfchor-ggepUWe.ila@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3l10jag0KCDgUVbcmbYeVUjUnaiiafY.Wigfchor-ggepUWe.ila@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780702617;
	b=7PxSENFZsLEiBb91fw4m/1CJH4wqhHdvcwsIKJrPGioQiZZAIejOH60+nhlq/JcYuLqbXo
	KkZPQyzLcRAbfmYPuKIkWe5jSaMNzpBtp+MiQn4nZeFs9JMeM8ICiOOlITNY1nKGdYEkO7
	MHOD/24EN7ag14oMsE9SgsvMrTq4XFI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="wXi/t++F";
	spf=pass (imf03.hostedemail.com: domain of 3l10jag0KCDgUVbcmbYeVUjUnaiiafY.Wigfchor-ggepUWe.ila@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3l10jag0KCDgUVbcmbYeVUjUnaiiafY.Wigfchor-ggepUWe.ila@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780702617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TP1Gw/FZpMqPW7LfLc3jMLRgJ8WESnfISTEPmikAWZE=;
	b=6M3ZFdifw3hACvWfUvrLrksbPVg0zsHruJsAXMYqdL/M4kDpMKP0gTs7bQc1NJmrx2NaHq
	ZY2NFgxl5RIzzQIAwBVTfS4ufA8xEr+pNxHhgUmD08uzHl5GLIx8Ygzq+toM+aU1FUktNK
	O/MyWaAj0rowdV3zUZ/zMeyePvIrMvY=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-3074797dfa9so3480471eec.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 16:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780702615; x=1781307415; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TP1Gw/FZpMqPW7LfLc3jMLRgJ8WESnfISTEPmikAWZE=;
        b=wXi/t++FDsWxFNTmjIH8jl+l2MNExDQn23hlfAZc0RHJahYqAnzExsOhCtFecjm44r
         YxjlhQ1dr/Nj28dWqqrCo/+ksClLSZHolAVfeOR0RGmCW+hcyM4Wz7tj+o2jxRu+kiBN
         uBKCvKMOfvvDmxLJAKgTT90sHebooqUTrmJTVpoT+SftlxOZ0f6ZRPUaNzbyd53SojaT
         hIGVZ/A9PPMm/lcFcaQynoW2x1cZzl/faLfqviDn68zsbK5sp4rhOgltAagHvhW8LgdK
         4+51EgrYOZASBt0ZR727RpLZC7CEEXQFT+LAy1XCl3QG8O2TALxZMYtvfkQ25D0jzXtT
         x7zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780702615; x=1781307415;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TP1Gw/FZpMqPW7LfLc3jMLRgJ8WESnfISTEPmikAWZE=;
        b=WtbgGnhcdz9W9E72nNMQJYze6E1nI9e/RwHHXa8eE5KamjbaGHlnfkXbb4P2giXDn0
         vRbCa5PjkAKmln6kwxA5S/0ZWj+1kv2syngxbeLETs0Nm2FRf730r8/ShlB+soDAOPiN
         WSvt9nGeKxfaBvm/1ItUxP/xzMlNQNSVh0k3D9205pXj4XytPFZeoI+2C52azr1GCngl
         sVl1BL7Ziyd5yBGTN9/A7s0qrMBA26JGfwTDdB8BLiVrAHqJ2IYhvxVJ4VlaO0VyiB3U
         fzikZSFqIFhr/kwAjG9ovW4rIpYRBM/qWcnlIr2O/75xpFMzEaIZl2IEYLaaUehpTpwP
         xKRg==
X-Forwarded-Encrypted: i=1; AFNElJ9x9TUtudCAxS0pxmO/YrV0ONAS50q79KQHt3Bzc9xCaqUPXLgG7Hs6aN6xDOVPlHt6bDPpPttaqw==@kvack.org
X-Gm-Message-State: AOJu0YxE4slTpAiOieOBfttCNpLU/QgjrLcSi5zvjBhRgK7D28ws1jdl
	iEHuDeGfhsv7cCF8nQvlbi2nx3px0qCvmbQN8hp/UwR6lSHkLU0jCHP2RzqdqCU/JIP9aFtTgFa
	nq6l5KyrM2vhdwF1fnr6po231Z9czJ/Tagg==
X-Received: from dyvp27.prod.google.com ([2002:a05:693c:885b:b0:303:3f37:eaf5])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:1287:b0:136:e639:9c05 with SMTP id a92af1059eb24-1380670db9fmr2750057c88.31.1780702615144;
 Fri, 05 Jun 2026 16:36:55 -0700 (PDT)
Date: Fri,  5 Jun 2026 23:36:45 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
Message-ID: <cover.1780701922.git.abhishekbapat@google.com>
Subject: [PATCH v3 0/6] alloc_tag: introduce IOCTL-based filtering for MAP
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: EC37C20004
X-Stat-Signature: 3xunay4sscn1whj8tftqm8qd9wfs41qm
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780702616-726387
X-HE-Meta: U2FsdGVkX18HA1aKs+PSKpOMDGItcjLv0O7Ws72eq/PQ3c0ywo1RFjMUGCOppeJ5vEWBd57eu/FRha4CqGgyNSOL3IJmSDnuPiRVphGu20989tIDq0fvDNidUsr+p5N4ZOmHTiFNpgBULTlkPmEZHm3unyTqRKXDNTzRoTsOzwJbuMxziBeEFwU56+TimmSRfaHxr0rebLVDaBTFt5+OI2l+/Zf9UaJS4CymppfWagiEjN+sF97PbiLe5ObK3SSEBzZtGRhiqNm41q0ZpgAvqLpoIpFGBYTyCbYKLvdaugkP+9JwUlCqqAKTYEEca5jxEQppInfxICtkoTrXfMqwp/AIwqtSqlNzb5olafw8Eip0bzcRkOHnk04xkItiux4fCN+wbpBKYbBgDpuKh4qWODF2naeMCbFPP7BOrhXy6/a+/dZI1zUtIlR+L2oJpFspEjtJ5CfV7856MhVZIv1IJWKf1zIFfPtalBLceuQp5o4CbSkBp1Nm9IhGf90vlekDeZTrfjpQkzCm8Izf8ySs01Ty+C9Vb/UatPwABU5CFm5nphbzAaEZqXGEdBU7WBASvvM5Ss3p7a9Ea7rwuHvZBO4fXU5mg2jUI+kdA6/+etx934tCYZYLYa1K3luQ7wbrdlA27r9FTnpAtPHeNcby6ihLJH/tKIlPRdLeqNv6EyX/VzIewz9BR1kGS1Plti7DZLnRHm69abtb5/Qcae7uB09ll/WBdTIeqrdwojiNCT2iwF6cRDUPVaiRvGKmnQIEloxGmJUBLecy+qr2cMrRE5J+z6Y/mKJt1FozO2lw6nv2oOwAzI4T2ChELZpUC2L3z6k/LQ7E13ugvb2tx5dWO7D7r7QVPu+66cufLTT22VTX+gh2J9EPJvn3R2uVy52F3RV4VmD6g0qdaVgcXVqiCCMhA3WlaE2pFapGRZZm6SIopnFaU62jLvtI7NAV1KePlw898fIaKiTvyPAG2jQ
 J1bXFFrK
 lzd4yKp6nJq6CAKbfOuwiHNTXEJTFdDVmJt8gukMCxJn9zu5MCIRJKsnaB4Cbb2xAtmOyMblz97hyPrw92VAFMTovsbcBFPiUXKm/iUAAY+bDrrQhZOivPSsDdMDBaLjIaLTH2fa5JPGdE0/PcqXnoZdOb/yzJp9Fvds0XAJOCUMClI7sucyZLut55vmwrwBpArrVppqDHAuVHFNje7PsCjHi/yjK8YGxn+pAAIRAmZqkZFu++o6kpCnKeFVi1mABUowQKYq2bwn6qwWAzbDV+K6ZIHlFtYm/aADUYmvQo1SAu2UICgEaDL45oxX9bHPHa4p9WU0xitBFNmZjYlu9bIw5mC89JMt9fIzyD+NuyT0M7Lc54Ee3LnyHQdGV+cR1Tpc+JzdR8JqjFlr7o8TRUJDFqJfJnlsHqE89SYeBRviOSkgmE50N3moKpbUUcWz5t4DBx7ETs86H5Lb6FZRBF8TXvbGuWAbMWsD6yKeFHyv4tFJ983wKxu9l0Fns9RGEPV1hxWx2grUfdW8zuO3j0D/roH+V7yQKTiuJrisl9GBcIT8PNbQrbORo0omi8A2XZ7hw6Y+8ItiC9KeiU0RW0y33N0K4rUuAM52grnXdSKNHb3jXxJwrX+Zr7hQJHyqT2bxCm5pfJjgsOz7ruTWEV/TnbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, memory allocation profiling data is primarily exposed through
/proc/allocinfo. While useful for manual inspection, this text-based
interface poses challenges for production monitoring and large-scale
analysis:

1. Userspace must parse large amounts of text to extract specific
fields.
2. To find specific tags, userspace must read the entire dataset,
requiring many context switches and high data copying.
3. The kernel currently aggregates per-CPU counters for every allocation
size, even those the user intends to filter out immediately.

This series introduces a new IOCTL-based binary interface for allocinfo
that supports kernel-side filtering. By allowing the user to specify a
filter mask, we significantly reduce the work performed in-kernel and
the amount of data transferred to userspace.

Performance measurements were conducted on an Intel Xeon Platinum 8481C
(224 CPUs) with caches dropped before each run.

The IOCTL mechanism shows a ~20x performance improvement for
filtered queries. The kernel avoids the expensive per-CPU counter
aggregation (alloc_tag_read) for any tags that fail the initial string
or location filters.

Scenario 1: Specific File Filtering (arch/x86/events/rapl.c)
1. Traditional (cat /proc/allocinfo | grep): 22ms (sys)
2. IOCTL Interface: 1ms (sys)

Scenario 2: Compound Filtering (Filename + Size)
1. Traditional: (cat ... | grep | awk): 21ms (sys)
2. IOCTL Interface: 1ms (sys)

Scenario 3: Size-Based Filtering (min_size = 1MB)
1. Traditional: (cat ... | awk): 21ms (sys)
2. IOCTL Interface: 14ms (sys)

v2 changes:
- Patch 1/6: Introduced locking for m->private. Also included the new uapi
header file in MAINTAINERS list.
- Patch 2/6: Handled the case where ALLOCINFO_FILTER_MASK_MODNAME is
passed but ct->modname is NULL.
- Patch 3/6: Moved min_size and max_size outside of struct allocinfo_tag
into struct allocinfo_filter. Added validation that min_size <=
max_size. Prefetched alloc_tag_counters if size based filter masks are
provided to avoid assimilating per-cpu counters twice.
- Patch 5/6: Removed the hardcoded logic to skip the header, instead the
test will skip lines that don't match the format. Also included the
newly added alloc_tag selftests directory in MAINTAINERS list.

v3 changes:
- Patch 1/6: Modified Documentation to indicate that map supports
  ioctl(). Modified struct allocinfo_count to use
__attribute__((aligned(8))) instead of manual padding. Removed
redundance type-casting. Added comments for static functions in
lib/alloc_tag.c. Introduced a new seq counter for content_id that gets
bumped every time module is loaded / unloaded. Introduced logic to
validate user specified position is not greater than number of
allocation tags and return early if it is. Changed strscpy to
strscpy_pad to not echo arbitrary user data back to the user.
- Patch 2/6: Handled the case where user wants to specifically filter
  for built-in modules. Included some comments for static functions.
- Patch 3/6: Modified logic to only fetch per-CPU counters for codetags
  that satisfy other filters. Included some comments for static
functions.

Abhishek Bapat (5):
  alloc_tag: add ioctl filters to /proc/allocinfo
  alloc_tag: add size-based filtering to ioctl
  alloc_tag: add accuracy based filtering to ioctl
  kselftest: alloc_tag: add kselftest for ioctl interface
  kselftest: alloc_tag: extend the allocinfo ioctl kselftest

Suren Baghdasaryan (1):
  alloc_tag: add ioctl to /proc/allocinfo

 Documentation/mm/allocation-profiling.rst     |   5 +
 .../userspace-api/ioctl/ioctl-number.rst      |   2 +
 MAINTAINERS                                   |   2 +
 include/linux/codetag.h                       |   2 +
 include/uapi/linux/alloc_tag.h                |  87 +++
 lib/alloc_tag.c                               | 342 +++++++++++-
 lib/codetag.c                                 |  18 +
 tools/testing/selftests/alloc_tag/Makefile    |   9 +
 .../alloc_tag/allocinfo_ioctl_test.c          | 505 ++++++++++++++++++
 9 files changed, 970 insertions(+), 2 deletions(-)
 create mode 100644 include/uapi/linux/alloc_tag.h
 create mode 100644 tools/testing/selftests/alloc_tag/Makefile
 create mode 100644 tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c

-- 
2.54.0.1032.g2f8565e1d1-goog


