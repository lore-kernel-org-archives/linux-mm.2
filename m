Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3114CD3427
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 23:36:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD4016B0088; Mon,  4 May 2026 19:36:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BABB96B008A; Mon,  4 May 2026 19:36:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC17C6B008C; Mon,  4 May 2026 19:36:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9C4AC6B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 19:36:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C889A1402F5
	for <linux-mm@kvack.org>; Mon,  4 May 2026 23:36:30 +0000 (UTC)
X-FDA: 84731348940.28.A4FC12F
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1BAC34000A
	for <linux-mm@kvack.org>; Mon,  4 May 2026 23:36:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="hGdAh/TJ";
	spf=pass (imf17.hostedemail.com: domain of 3ey35aQ0KCBIstz0Azw2ts7sBy66y3w.u64305CF-442Dsu2.69y@flex--abhishekbapat.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3ey35aQ0KCBIstz0Azw2ts7sBy66y3w.u64305CF-442Dsu2.69y@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777937789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6SVtzc1b2hNmp2ps3pkK8pPFTjVWAOuceZgJhvLk1yE=;
	b=b5qEsro77t78OnOeaKjtVCCGKf1UAqL+4svwWRL/uNLKzyiFfVKoaWsUvNr5UHJc2ZxU/2
	wSqY1Lxedp41HJbSBznZlHNFjMAu6usBw++qOValg6gUVSzhVUhVAI3WAaeiNA7Ex1oCfj
	qNiDDe3xQ5tGbrCeRr2LS95O6JyULPs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="hGdAh/TJ";
	spf=pass (imf17.hostedemail.com: domain of 3ey35aQ0KCBIstz0Azw2ts7sBy66y3w.u64305CF-442Dsu2.69y@flex--abhishekbapat.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3ey35aQ0KCBIstz0Azw2ts7sBy66y3w.u64305CF-442Dsu2.69y@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777937789; a=rsa-sha256;
	cv=none;
	b=1dJ82952u36J8mhbkHei5REoQMpNVvQKLdTXSfg6vITpAEQYozD8LhHecMsb1kKq/dxTdo
	Q+ydSHpuf1caPDpKdKe4g6eZ8V1GLAYRUvrgTwW2/JN28YCty71Ksw0rgb/AUJXbcoMLft
	lbBmPvFr6QcviJG8B69LHy8w4uJgtqo=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2cc75e79b97so9758736eec.1
        for <linux-mm@kvack.org>; Mon, 04 May 2026 16:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777937788; x=1778542588; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6SVtzc1b2hNmp2ps3pkK8pPFTjVWAOuceZgJhvLk1yE=;
        b=hGdAh/TJ/iEuii8aB3pFOSOTxeLO8aJEzkLvvxKjrSTzxeCZw+4UN9ajQEngRX9ACL
         X1UsgIN7c2XUJP+r6tFE6IZmEaMmsznKbKeBD0Z7T2vRO/HC2hR48FPv6MEUZLdNKJau
         b+3N4BDjwMx1J3I4nWzPjq/hSHqnIGsdv4fwGV9xTrE2CeLfwV5NgF3YXh3piAkJmujX
         eJoz8veTVg94eb4w0aATeI9Olr65FJvbaWXl/wM7cO43VrpiEOQRpN77m1vNOfpdcuj2
         HE659Eb+WTVwbHWDk/7C0suQXnIXOPxy11A7QzfWNrMzzQ5PI9CasUy8woVfRo2B05qO
         Txkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777937788; x=1778542588;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6SVtzc1b2hNmp2ps3pkK8pPFTjVWAOuceZgJhvLk1yE=;
        b=Z9cJnHJ/dNuK3cSzUZwA6u3c+TDDB5lO4E8VkThTrHk6oQnr/m2Tj2MoThtY7lKAo+
         Xmb8yZlBZC+CGstGxN9OPFhstapFjCzOFACl8zX0yNQFxFCfOWryJJLF9CJXRgC66UUB
         EGYt4pDNpvPGHE6r/YNKU65sbut4NOX00Irwdb5fucmdg6UrGJtEESLUFz1HCspFm583
         4bbM2TCdhB4gdHAhBgUlAETmUTF8DxwBDcOtmyFtAcbxtW35853sjSIlxQC4CFamvDVR
         D4XwS+rMBg2Qj+SMIcj4rL3Vl+OjgjqLwHEI5ymcDkjQThEbzepbuGKNidbZfrFJKV/M
         ovOw==
X-Forwarded-Encrypted: i=1; AFNElJ/Ds0PtNsEHqjz3e1/sjljyAsd+v2k6yGRvtVX2OFFsFkPkNRu/BTB8/F2xbZYJ88cMNmeI/pg7jQ==@kvack.org
X-Gm-Message-State: AOJu0Yy5m3UbkPGyJnaOMS57uzZbyiOsqlW8s7LoLqWwXX+5YJ1IYnd9
	mUuBPWIRyTLW0WT7n3erqXXWsCI0UeRuvQwKwzHqkNf6oDRVPpg9e2/wm5HPa6EKS5Sv0dM6IN7
	mBuFcYJjiaZDsgZtCf2kcenENcL80en8OYg==
X-Received: from dybcr21.prod.google.com ([2002:a05:7300:ac95:b0:2e2:2088:dca7])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:6592:b0:2ed:e12:3771 with SMTP id 5a478bee46e88-2efba5a4258mr4958847eec.33.1777937787455;
 Mon, 04 May 2026 16:36:27 -0700 (PDT)
Date: Mon,  4 May 2026 23:36:18 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <cover.1777936301.git.abhishekbapat@google.com>
Subject: [PATCH 0/6] alloc_tag: introduce IOCTL-based filtering for MAP
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 9bz7r1p85x5xwtoi4df41wwq7gbah3gr
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1BAC34000A
X-Rspam-User: 
X-HE-Tag: 1777937788-51266
X-HE-Meta: U2FsdGVkX18GkDEzW0Ehp9qNLraCdaO5e6wTVbDOmNBG/+pkGtlV4c68mcYfugYbJRe50NnKyYu0f3a6gXb+BPPqsSThxZYqVHsBABPllTHVxmcTEpgvzuXCrIxQhVJTrqL7Z9SvOEDcBqg/bDrEbUlzV6wJYF8VzNvx7WwWdPK6x2eMBn+7kLYYEPio56y9qtS98u0F5wFV8XacrIEngXZlpixOoVoOv6gYE3WL50MFv1yPJ3WRzns4CHhnPgyMn6xKwtv8opCWJjIhVAGiGRNVQdbNZeIxwcZAAPNM4+SS5j/zFcBUDYBmJS2Yk4z8iXhfHMwGT9Y5FvUKQOWGuyZ+iFG+dqhO8zvTaKPbth5cgW3Ocu9Ph2GM30HAqZBSwyFR74PTiriE0f1V15KJrDTYdvq3LXpYzQgfq0zDoUtWYSlxxHe0PMMeN0GICCTD63vgjUmtxqoTQVmQNIYg/PTCjg9mn+YKb2FbbsXuuVPSZ7BBbbUFcFBN6TXzxuLEVfD8/qdA37rbfbt/PCAmp58Nw6OnUw5Z5RzqGKbjHH22k98nF5xbJQOhYI6YpYeXVjrjCkbSuggtSmqdI5+WrZPcHdlvqqIbR29E8XyJBV+IDk/yfPeg+2XN97czlLbmSq7Vd5HcAYIT/qmfOaJdj8ipHKSju5IgMG28L0DF/IYDZNDIa+G2kJaLXnilWlV/Pgy8iWIUEAh5T6xf2vpHNE7zO+fgm4qk7RW10OiqHGoH0o3ccqYc3dLnQo+YJ0xEqGkNz5yGNzkG9hNvgkRwaLRC4q1HcF0A0SWH8d7o40/GPgC1wBw9zo27VEkhM4Y6m2cSWTHO2kapeRYGvxZ7M291U7WkOnoBoT7f3PTlZzi4FaH96qK8Q+kX+SBYj2xH5x/b57vwdbZjxOZjDk2TYpoTnQc2ajmBdNHZacIJlQR7QcwkW1y3FjsSin3FU2o8BeVY9+wl3hUanWu8fBJ
 HGTob9r/
 PvYKRE2ymqoT2ua5axNVt99kAMfKOzudYiFNewqfC+3zcuaXGEDRo+xq3N952eogoS9Xz14AanY/rXWaEsKxIMM3L55rIXA/66wYf1kKfNV6wtH//dWD/MIQv84yFtNwZ0GJB0t6SyOuMGIn/Ec7sv5Ca3/0DZdfqOkZS4Z+Y+G8IBQvhmo4AAKKkBWujzkPVeUfGs9KWjMcXil+JyDzmkAmHj4Is6sm/jKMxzAwwA6QSf0RxQjSXQeHxj3HnnfGWHYp9Y/jbN3fgv8dIGX/CuKvZhZXz2SS/por9HKyDc2hIbywIaypFIl4/+6xt1KlbSxtBTW0iVCNO+3JWFhZlgXIb7hoWmDb7O/0wRyDL/rmOcxw8hq4MbfhDX9VqBRnDnf2s1MsW5D0Wi5Fg7yME94ChDqaRWV8CSW11J7oQduTYjQgF3uwIRGBgvRoBzADxjpWWU3luQzc4fX6l6y9rM57eP/9pTFmOLY7SnJZQTgqC+8efJbj0aD+9UUBNbTv71WXiOahdPSAnB612UeundiPZUIzj8SFfwBUR1TDOf+lfO56Nl9tFQ9mhbThzsvhXciIsNjVFO3Iah5w4YDtu9OciIPGCPBXUIToGhaWV+nyEdz2IWwfzlhcCeUmzFmHTCd3W7KitTPROjNgBDTkTPJGF5Gggsna+G6gZJfp8IXzxWeNr6dD4FECxTF5TW83OcebtZ07UqjlLYAdlaELLQh6Oo3I7cItZw+fXnKGuyruOmWE=
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

Abhishek Bapat (5):
  alloc_tag: add ioctl filters to /proc/allocinfo
  alloc_tag: add size-based filtering to ioctl
  alloc_tag: add accuracy based filtering to ioctl
  kselftest: alloc_tag: add kselftest for ioctl interface
  kselftest: alloc_tag: extend the allocinfo ioctl kselftest

Suren Baghdasaryan (1):
  alloc_tag: add ioctl to /proc/allocinfo

 .../userspace-api/ioctl/ioctl-number.rst      |   2 +
 include/linux/codetag.h                       |   1 +
 include/uapi/linux/alloc_tag.h                |  87 +++
 lib/alloc_tag.c                               | 249 ++++++++-
 lib/codetag.c                                 |  11 +
 tools/testing/selftests/alloc_tag/Makefile    |   9 +
 .../alloc_tag/allocinfo_ioctl_test.c          | 508 ++++++++++++++++++
 7 files changed, 865 insertions(+), 2 deletions(-)
 create mode 100644 include/uapi/linux/alloc_tag.h
 create mode 100644 tools/testing/selftests/alloc_tag/Makefile
 create mode 100644 tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c

-- 
2.54.0.545.g6539524ca2-goog


