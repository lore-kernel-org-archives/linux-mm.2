Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25146CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 17:45:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DDDD6B00A7; Fri, 22 May 2026 13:45:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38E326B00A8; Fri, 22 May 2026 13:45:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 256396B00AD; Fri, 22 May 2026 13:45:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0EE9F6B00A7
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:45:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 945261C1DE4
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:45:46 +0000 (UTC)
X-FDA: 84795783492.07.B2D9A44
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf15.hostedemail.com (Postfix) with ESMTP id DB904A0005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:45:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=duXOZxoX;
	spf=pass (imf15.hostedemail.com: domain of 3R5YQag0KCA4opvw6vsypo3o7u22uzs.q20zw18B-00y9oqy.25u@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3R5YQag0KCA4opvw6vsypo3o7u22uzs.q20zw18B-00y9oqy.25u@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779471944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RUhGNhxD0QOUIs2ABS/Rux/YDmNy6ndLUdXOBB/mJ3M=;
	b=mMMlYwCnvbyQXbonv3RehZThFrNBYUI5WKQEGjmgP8oveZaUXelZXDrTIzuAp5yLWbD3me
	fGhM5WTtBhgTx84VMiOpF+dQV1IomSWzQeN8mjbYPenKIg+/leb5tQ/CjCIuWHJIrcluQd
	i0KITN685se9/0JnIPxLEMQ7g5FmIgE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=duXOZxoX;
	spf=pass (imf15.hostedemail.com: domain of 3R5YQag0KCA4opvw6vsypo3o7u22uzs.q20zw18B-00y9oqy.25u@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3R5YQag0KCA4opvw6vsypo3o7u22uzs.q20zw18B-00y9oqy.25u@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779471944; a=rsa-sha256;
	cv=none;
	b=Szm8AeqkH/LG61CEjxX53Tqev663eS9GJsUDbVlr/dnTkikelzw8SfZkZ9Lg/AQ9ht1SXy
	NL4O/fxW3KQTVImLMtf+BWNL3l1HuS0VoCnibnHaMz2Mc+LxOaZGa9il+c3jBEJ+HQw64L
	LKWa4Munu3KeSycERgRNYrnvn9GmM0k=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2fe1cf409a1so12590738eec.1
        for <linux-mm@kvack.org>; Fri, 22 May 2026 10:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779471943; x=1780076743; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RUhGNhxD0QOUIs2ABS/Rux/YDmNy6ndLUdXOBB/mJ3M=;
        b=duXOZxoXpnJCI6dwd0PAofXYRQ2fKjEgwueq6rvsFnF7fbOoa3iy0ihpw2MjiilPDF
         9LTbQrwSo4kn7QfgwfrWPcYAsmBF4sr/A5uRTeKjAPmpWqvW/2Rxlq2JoPjc4+SAlbv2
         cYg/3vBg5epM+dZHWSdip4mWWqlRSwOdaTwZrnD7Jk3VIU4ejeFoQM+Aa8Mmo6HrR1ZI
         WBea8w8XtXsJPiEYOt1zIQjGZxJlOcAbGVe/yCYrwmA0456ypLKgeIAaasCEBFlIIg+8
         JBiavxbTnF0x/S0PDnalAGeh86yPxgDCiyEtb9sT1prPpwJZgFw70l141UuBIpjHwfDW
         rlGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779471943; x=1780076743;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RUhGNhxD0QOUIs2ABS/Rux/YDmNy6ndLUdXOBB/mJ3M=;
        b=mWMYwGc1EkxE8MDOHapM9JSErMBASGzH8tfZIOt4IpNZ6V0P7nS2TbgNiVAefg5MCz
         +Gd0swMt4LXsP+Erxt0kCZ7STDXOw5DZAosUO3z+QthY8OqSTNzYMTd0+fvbP4ZqEZir
         M2LidrPXA/OtshscBqnOI57wFP9fGVHGzG8z2psajtwuw8yX8LSA0IDNQkZhALKtysOv
         4xLqUZD6oBbj0O+CoiZiSju00FlF+0NISeZ7Fz6DGNuF3qG5wAdw2LjQLpzbEcbSLRPr
         HWB+izCPO9J5MtbnMSB5uAuoQuq9bWM0emeZO/b/Px0a/rZMXWwtUEhMQg5rYJO/XjkQ
         dFmw==
X-Forwarded-Encrypted: i=1; AFNElJ8oZEjmckqBpMberoROZUETtgYwZqyQliqOzphvXTl959pZI7Us1azMaOAsn5g+fIGK+omTUMqejg==@kvack.org
X-Gm-Message-State: AOJu0YwALuZQmsnnx9UHjFdwCAr5qwKQ99qgc/1UOT0/m+m8uoAnF3i5
	EYVcDkR+pR98ZMzoQMOsdbCVG/P7kDNVjwpHmFW/NkSRFiuTee8EZBCfa44ASM8cC04YLVsnBEc
	Fowo/yt107XMmyeb8laPiLDsIv+LU1NLTyg==
X-Received: from dyev16.prod.google.com ([2002:a05:7300:4310:b0:303:c170:9611])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:6588:b0:2f2:1b3c:d824 with SMTP id 5a478bee46e88-3044904df42mr2422519eec.7.1779471943340;
 Fri, 22 May 2026 10:45:43 -0700 (PDT)
Date: Fri, 22 May 2026 17:45:32 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <cover.1779471082.git.abhishekbapat@google.com>
Subject: [PATCH v2 0/6] alloc_tag: introduce IOCTL-based filtering for MAP
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DB904A0005
X-Rspam-User: 
X-Stat-Signature: 8quecoqqyeh4yekqi9s85pk6cnbo4jq9
X-HE-Tag: 1779471944-624379
X-HE-Meta: U2FsdGVkX1/objgoVzLvIkFdw7NUIyJzSvKsvbjNHZDgEO6IRfA0kzqCf5RCb8/bJOKX7ngSj/5pfNtL+yUPPC8Mc2hrNbPb1L7iI8PBJZ9kjvzLvCWQ9D009XN6wL5UyY1kI9D2CcVXdTIrr8SFbybvCamCYd6Qx9lUP8qJhLeYEqLXxh0hyHIVtg018ay6Z5OwQnGebXVfg2uC16Rw9EYiujwqkJwLGodom/ZJCd2m43zC8hJBGGt329O2P1v8Kbx6SEvOtPPeDWCO24YeLvNLBHHiiCOJfGrzm2Mp7Czl3dcOwWS+XBiE0yqNL1HuHg+byldO8iySRpE1zZyw4ytie0h4cxRC99T22oIhLjIQv2UtXozy52Wmld8tUgvUupYH1c3CqH3cIyGPpj6tFeO52zw/cSLntW6SDz7Iy/41Qd0bopBJvczlJr38p5P5cURtUItHYWCMw/49EhE4fKdHoJvmcDtBJ3KgJKbUKHWQHX6Yis4jJwJDsI1Gm6PqQyAMswEDqkkLQ61/WkxwoTdfbsh4hVa/5e31vyvXDzc5Qr9CnOk83KB5b4DH22t7S0ILb71h1VA+DtdLtOlSxpPW5GRyPFDFjC9OUbN4UEPBYkSykPlBS8dXHlx0Fl0gm7D4SPz7u3Zfmglli0dABlMkwMpCegnlkB2w2HwyceVq8CcZDAKhMScA2/D5WjnJBsLVNnKUykHS2QmT0vedX7pXUEajzsD2ZUcgr2Iu/hd38VbnRkOSnQ0TDL9bPxBHgkUFP8lz7Y6K/DylPDNajTolcBVAmlmrs0HjYRrDdgWCVhqKU/QnRLtwyakeZSt2JPNNTM+V5wrDmWYwStorxTysS5deja4fMocMagVbKmgqO7rPkz2aP3MLa7v4fufkkfGuBvxhqKo+vH3JYOZQHYC38fKi8NVoTK2jjntQbEzTzupNJW+3fx240iPWBLqv3xjogX8EB/NejQZ9Wpf
 kC/DXM7U
 C3ZVswHzafXElsbQlvHXgADU0fZKpVAXYanv+3lW5iqluYWV79/BQJbUzILSD48g9SHBqJbcJBT4WlA9FlGRWqFguSwJ7HXGfs3mu01Keeg1NaX/+qBAaZPClLrqc8eiOKr1wBiypdgQIeFB+gTnouUtHuKbgTumQLvod/5w0x/qhYvnUKysud39jTvRpMmIbFiUDBLGY1yF3ZrHml5xO9NOcYsKylp1wjWgN0n4A/yxL2TvAXwBS9Zd/OqCUUn9EomCV+esYMv0ZWiuDE64ZSo+Kil/I7ePZbxXS8yDlCE5WJOX4hqu5pZqD7tqzLM3uXV/ppM1Ec5TfgOFHXpEKMvsBB/ItWaolsmw0xBxCVW7GD5XfV9KNF0zuEkVFaU4Ag4bwSof9x0Y09IotPFqz/Ss2gtwBrqOjms8/7E7LvVrHdUSQDenTBJl6CxGDlqygstj08HDaNPBOv1mhCJpRjTGl9B8pbOdU0dxTHxG9cy2jcIxb9PwTaliVAyUYYF+jQfKGU1zBmnYlVpjBmeCj+dWYf/oJwyGSVM8bTdsbHX1OB70W5pGnod5pTI2IBK6vldNXc+lYjk3rebqf1gPsL3x/MajH8jmtOawB0Se/3RgdURKoCvwBRHJ3n68vXjJT03Ufu6wrMeGUWnruazpzl1BJNXyk+K1BXHUcsYASDXPyfkSrZvgYhFVUyL0DRwcWai/lQON+DeQn/LtNaeCr7KH1qlzrxhrMH0KK9FhxugK5x3c=
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

Abhishek Bapat (5):
  alloc_tag: add ioctl filters to /proc/allocinfo
  alloc_tag: add size-based filtering to ioctl
  alloc_tag: add accuracy based filtering to ioctl
  kselftest: alloc_tag: add kselftest for ioctl interface
  kselftest: alloc_tag: extend the allocinfo ioctl kselftest

Suren Baghdasaryan (1):
  alloc_tag: add ioctl to /proc/allocinfo

 .../userspace-api/ioctl/ioctl-number.rst      |   2 +
 MAINTAINERS                                   |   2 +
 include/linux/codetag.h                       |   1 +
 include/uapi/linux/alloc_tag.h                |  87 +++
 lib/alloc_tag.c                               | 303 ++++++++++-
 lib/codetag.c                                 |  11 +
 tools/testing/selftests/alloc_tag/Makefile    |   9 +
 .../alloc_tag/allocinfo_ioctl_test.c          | 505 ++++++++++++++++++
 8 files changed, 918 insertions(+), 2 deletions(-)
 create mode 100644 include/uapi/linux/alloc_tag.h
 create mode 100644 tools/testing/selftests/alloc_tag/Makefile
 create mode 100644 tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c

-- 
2.54.0.746.g67dd491aae-goog


