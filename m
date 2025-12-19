Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4A33D7879F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 18:34:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25D416B0088; Fri, 19 Dec 2025 13:34:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 209F86B0089; Fri, 19 Dec 2025 13:34:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1176F6B008A; Fri, 19 Dec 2025 13:34:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F339E6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:34:00 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 98E301A035B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:34:00 +0000 (UTC)
X-FDA: 84237069840.18.B890725
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf13.hostedemail.com (Postfix) with ESMTP id DD49B2001E
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:33:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=N9gDA5UR;
	spf=pass (imf13.hostedemail.com: domain of 3lZpFaQgKCDIXWOeWmObUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jiaqiyan.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3lZpFaQgKCDIXWOeWmObUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766169238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lSNGnEFxOyI19g6eLd2Gx6lTfoT3c263QtqCA7O/6yo=;
	b=P8ysClOLTTY6NLK+TW/nKPsO7uUJVsmQI4o6T+zZM+l19RlvUWHBbOaFQQE2YJiBSkDfO7
	PmcnS5IYzh7XTPjpZgFsnIJxgdTpRwhqtIqSWq0GANvfIymJDaQ69Aq2v0Pbg5UrXdSr0I
	X597mTvT3wTMfpDZZkWhHOe1Bqxqu7M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=N9gDA5UR;
	spf=pass (imf13.hostedemail.com: domain of 3lZpFaQgKCDIXWOeWmObUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jiaqiyan.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3lZpFaQgKCDIXWOeWmObUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766169239; a=rsa-sha256;
	cv=none;
	b=B6w1kk2A2TuOn+nPUdeRQFfNebLM2eTOBnPlry7HTFVkFLjAN9IHBTfxhAKUTZ7bODvMIb
	fUDq2wunblV8P8QPU6nkR9yk3ogW3QRn4OMiqPfQ3z2/Z5LVieWmHn0KnvAO7B9I1ICxRb
	PRzPqGLUlX40rjZhL9Okqre3c7rtViw=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c38781efcso3760681a91.2
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766169238; x=1766774038; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lSNGnEFxOyI19g6eLd2Gx6lTfoT3c263QtqCA7O/6yo=;
        b=N9gDA5URq/UmTncSWiw933Wu/POGTdZrHNgxlS9GwujYHwTLP2+/o0rHL8xriUpuqp
         SHk4ZxshiPsOqIRwh9rBoZdKJIyifSZgc5sB6zQSJYY+dgrzsXrVMu0X8CJOJzdCnQ82
         ihYMuPcBV1Nv0phUF135CnhviD4ktHvzTc+26YTekAmp5tWl9O5Qn91GIOZoTXKaX6+b
         Ox1qQR41++UGymmPrrbhbsfXA77+a2Zyyx704I7t/ljZEVuUkbllO9xgsp6OXrRrTDVu
         NxLZwQ4puYc+n5bIY8uNTRhwLOeHszAsRgPoUed2dBo1RHTBVselLXMAX0860P28iQeg
         aNAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766169238; x=1766774038;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lSNGnEFxOyI19g6eLd2Gx6lTfoT3c263QtqCA7O/6yo=;
        b=f0Zil8ndRya1tGnchdLmyZd7jyjR4L99B4TEPVgSGYnnJsxydXi6p4gX0rLCcOMdaX
         5JoFesdOyvKjb7QZC1MF9EQsZGQ+4vPvlt42E+8TDqrCrTZwfAjmmcKGwu7hq0+ZMeTy
         2e2TgO/8KMsYxD9qN6DPtI+wJrA05qSpE7jp4uTRfxMdNTiQOrsCQqW+kMdBbbCD8dvM
         cw6nToz++VsS20zhvW/IZwlmNwSa++WO3uJm97YrrZLls8YFGSe9vqTIxW49JVpGxcSb
         wWfWURpFM+UL6V5613sO8Gp//seCvTFmKefsSnZbwIwkYxg2Cp5jchTxPo/u4Uh78JTn
         l37g==
X-Forwarded-Encrypted: i=1; AJvYcCWShgFjZiYLdO1sHvpCDVaXlW/eAL4Lvh7RMZtSgcSV9yOmmJ6mEmxVRugWXgPLHhG60eLdtRxtvA==@kvack.org
X-Gm-Message-State: AOJu0YxoTyLwWlC0DDaNfAmbkEbf8C511Xke0aqvH6gDhjDCKcRpmSeW
	hcJSM2vTCutim/n0z3qdYlaSXYRw+9JJmHhFRbKh3UKSEYjHskBAPBTeksedJXwGWAT3FPpwOhZ
	x63cIt4pdkIvAug==
X-Google-Smtp-Source: AGHT+IHlWbEQHHyZMRyN1CJ6TsZ1t3MpWoqaJTHXvpmESrp3COpy16aFWt0kD4JLtuxjkJkbgfBPzAd+vxBxzA==
X-Received: from pjbsj11.prod.google.com ([2002:a17:90b:2d8b:b0:34c:36b0:4e39])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2e0c:b0:341:8bda:d0ae with SMTP id 98e67ed59e1d1-34e921b7334mr2826873a91.20.1766169237687;
 Fri, 19 Dec 2025 10:33:57 -0800 (PST)
Date: Fri, 19 Dec 2025 18:33:43 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219183346.3627510-1-jiaqiyan@google.com>
Subject: [PATCH v2 0/3] Only free healthy pages in high-order HWPoison folio
From: Jiaqi Yan <jiaqiyan@google.com>
To: jackmanb@google.com, hannes@cmpxchg.org, linmiaohe@huawei.com, 
	ziy@nvidia.com, harry.yoo@oracle.com, willy@infradead.org
Cc: nao.horiguchi@gmail.com, david@redhat.com, lorenzo.stoakes@oracle.com, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de, 
	muchun.song@linux.dev, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DD49B2001E
X-Stat-Signature: 7gxurechmpx4seo6kzwfy1zmgr9p8mjf
X-HE-Tag: 1766169238-977270
X-HE-Meta: U2FsdGVkX18FCVo2pc6WKLIqZ30yp1UJ3wwcv7oGc1VY7h63Yc5hNBhRuq44XexFwLCEWtxXGOFt5/vRtJrasCMBA9p7Wmwx6yIb+IVthsUaOnDuU9okGcuA4a7FTvRN2LCVObG8j+HMuZ6M6BebzjqoYrlox2E9ExQS2kk/OAXM0K9QjASsKlf2p1HNPAopoVksOBwjQL1MDL0zlxYguZN5/TqDTdzDnY4P1zYMUB3abE2JohK8jUVqAbWQj/1BahW5taOXOlSxJx5zms1wIWCQK5vBdAGtKgohGOXXSwJnYlnc66OgSb25jHqiQ90O/hBks9FMU2bVNBdNqi2lU9B0teRM4g14izt9HzE1HXEPBJA/0MOjpbmO/OV0vULp/5PjUdJ88iwGWZtXoec+FEZFc/bi8PGuJ0CcFN6DVPTEh68bW9GtT9ifR+d6BZ2iEhTTMR4iOCSoaoz5MN0tVDW3JcM5/3PRnAkY+hBl8zUs2b3cZAgJ7waLSbZhWeZTLBJzE3/asOfZayAI+41NJPWLbPun5kK5LwLTfpzm3932RKgXSmgn852opuDjoVgYPQfugs/HNJZTRHq+8Z1nabRe5G/BD2lXSJ5IpfZH7lhDnluH89K1+mfLI9rMDH23rUeuk+D8ia+vB3pe3aFCqXeY32/ZUkHBdrtKEQWOqXC9H/3sFrdIPjWhomNyjcywzbnhOEq09F6xi3TOwX7onZDkXVjW+q0ZuYQ0J1U8eUSQii5s8VDe0uKIOHo8bg8X9wVp46XkU9dLsAYIF2dA913+vIdv8jZmrkOGSmqAlnmmcstrTfNMk7Gp9NZ6DhYlhcQ45Smy0QchGsohVHhAMgwJrnkKi/bz/WCFtfYyQuNod9E1mRBozYcgnTabhURB9eyVD89CiSRE+kYFy1XZ/pDXIyKvFDpXSBfpV0KqOrGna7/CS1H3W3vacckK05dSASVWweISLLbHFFQKBLF
 Y1NkkgC1
 o1KVsx6dZgC2s4A211F+hXaOdzdMpdHsSAKW4FgdL7IGLdpilEQTIZkwEE6jGNH2sq21D0eh2UKRJFW1pFAX3qMGi54sGy8tUYUGTYVaDqQ+I3dv19fpLa+R205ZSUsq3s19wV8aUcxFCp+QyosfmHxX/69Zoqlehvxwk0/ERA62zMfA8iK4Xf0fEgYVup8Og6kS2djxdoR3QHoCkIUUPdItDegY3DzWb4VRX4+dzU+GMkuEyInh87GtzwrZ9d6fUpjftZuqqoQ+V3pRbOANLEb46PxnCRv9nhjn8RNSUWIoqOjOZCjJymhwI4eI4EZo/613eguNaSA+YpJY/4bMslZtjbQQ6latS+/ufto3uWERVraH6KUWhSG6Ch4AQ6I2Z2otXH4m4T0eYKw9YIFlVfmjd/1xAdIoYfGZ0hti2+BXW3FH5/8mPMQA6F9q6mPo8+cpF7mSw7NsZwSz3Stlus1Ol1xLTycVHLztcwIJGMX0cu6hLsxMfO1yll13+YiXsIkyKET9Gso6+gZO6MNTFwueJlm4AttZkRrnESqGiUEucco0C8wSVQABg7A+/bvTis9L5MEdA7XOZV3r5ZHLNPYdUYk4Y4Pp5/mm8yKc6lrrm2F0XNZ5cj3KwVr23kpYpV7fwDA0HwrZ+t//U63KFcVx2Ak+dz6QJAgRUFD9rjj0i8LvXdJGIyEM2riSSGPJuvJgzCjsaraJzdccUzh8GtzuNJhtFbeVWaZJLfuYW5gS3vz8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

At the end of dissolve_free_hugetlb_folio that a free HugeTLB
folio becomes non-HugeTLB, it is released to buddy allocator
as a high-order folio, e.g. a folio that contains 262144 pages
if the folio was a 1G HugeTLB hugepage.

This is problematic if the HugeTLB hugepage contained HWPoison
subpages. In that case, since buddy allocator does not check
HWPoison for non-zero-order folio, the raw HWPoison page can
be given out with its buddy page and be re-used by either
kernel or userspace.

Memory failure recovery (MFR) in kernel does attempt to take
raw HWPoison page off buddy allocator after
dissolve_free_hugetlb_folio. However, there is always a time
window between dissolve_free_hugetlb_folio frees a HWPoison
high-order folio to buddy allocator and MFR takes HWPoison
raw page off buddy allocator.

One obvious way to avoid this problem is to add page sanity
checks in page allocate or free path. However, it is against
the past efforts to reduce sanity check overhead [1,2,3].

Introduce free_has_hwpoison_pages to only free the healthy
pages and excludes the HWPoison ones in the high-order folio.
The idea is to iterate through the sub-pages of the folio to
identify contiguous ranges of healthy pages. Instead of freeing
pages one by one, decompose healthy ranges into the largest
possible blocks. Each block meets the requirements to be freed
to buddy allocator by calling __free_frozen_pages directly.

free_has_hwpoison_pages has linear time complexity O(N) wrt the
number of pages in the folio. While the power-of-two decomposition
ensures that the number of calls to the buddy allocator is
logarithmic for each contiguous healthy range, the mandatory
linear scan of pages to identify PageHWPoison defines the
overall time complexity.

I tested with some test-only code [4] and hugetlb-mfr [5], by
checking the status of pcplist and freelist immediately after
dissolve_free_hugetlb_folio a free hugetlb page that contains
3 HWPoison raw pages:

* HWPoison pages are excluded by free_has_hwpoison_pages.

* Some healthy pages can be in zone->per_cpu_pageset (pcplist)
  because pcp_count is not high enough.

* Many healthy pages are already in some order's
  zone->free_area[order].free_list (freelist).

* In rare cases, some healthy pages are in neither pcplist
  nor freelist. My best guest is they are allocated before
  the test checks.

[1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-mgorman@techsingularity.net/
[2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-mgorman@techsingularity.net/
[3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
[4] https://drive.google.com/file/d/1CzJn1Cc4wCCm183Y77h244fyZIkTLzCt/view?usp=sharing
[5] https://lore.kernel.org/linux-mm/20251116013223.1557158-3-jiaqiyan@google.com

Jiaqi Yan (3):
  mm/memory-failure: set has_hwpoisoned flags on HugeTLB folio
  mm/page_alloc: only free healthy pages in high-order HWPoison folio
  mm/memory-failure: simplify __page_handle_poison

 include/linux/page-flags.h |   2 +-
 mm/memory-failure.c        |  32 +++---------
 mm/page_alloc.c            | 101 +++++++++++++++++++++++++++++++++++++
 3 files changed, 108 insertions(+), 27 deletions(-)

-- 
2.52.0.322.g1dd061c0dc-goog


