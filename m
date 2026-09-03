Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE534C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 15:50:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF9D66B008A; Thu,  3 Sep 2026 11:50:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAA276B008C; Thu,  3 Sep 2026 11:50:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC0656B0092; Thu,  3 Sep 2026 11:50:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A7E686B008A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:50:12 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3C54F120588
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:50:12 +0000 (UTC)
X-FDA: 85172887464.04.9DEB6F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6D7CF20002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:50:10 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EN1nzsXw;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788450610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=WI9v6/C6AUAbqLBrww4pmJZ6/5xnMiZgra3ebIh6xvI=;
	b=gV7hZhMAmt14SsDNnNseiFnVhKqEb91PyxP/gKGF+IP1Xb+zQpOjQsNHH0mmelnhNxLGmx
	B9aU4i5S4fNqYO3Ny7Khut49DYS6T63gcGsmhGX2h9j7+29OjsR0c9EOsoXKgHVXEO+xrb
	urHkLCa2QXt3ramidBe7vNmEMA9OyBw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788450610;
	b=E2qNVR6B2TJmubEVqi9/A5FVF1/1YYaW4oopijyiBeBJDcHcsL02u/mWigpQKPrk5DJHC5
	b/9ySZTCQtCnD8vCfV5u7UdsnVD09H1zJlJDURNThUvaZnXtaGkvQA389xqb2ZrP+HN50l
	nuEdKgW9tYhiTvTAPGXbE+P8VQq72bA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EN1nzsXw;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D08A40B90;
	Thu,  3 Sep 2026 15:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6821F00A3D;
	Thu,  3 Sep 2026 15:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788450609;
	bh=WI9v6/C6AUAbqLBrww4pmJZ6/5xnMiZgra3ebIh6xvI=;
	h=From:Subject:Date:To:Cc;
	b=EN1nzsXwXgmMd/6TIBOaO7frmhJOfdmraNCi0fc+jLFNArdjnT4PCQm1ustRBCfQC
	 iUBkCLenUEQRBaJTtLBqJTYOig+539m95ixFJ2q9/niMeBgfe6WCXB1mpd9SPc5pwu
	 4fY3uTaBfjOk5u7R/feI8Cku0/+fr144lZ9i6D2twlOCZ1OlBL8jGM0U6L5mLGo38y
	 AMzkLegVvk4D+Fo9uYrU4q4ev+jFJV6WPPhQv+PJ7+mSN2SM2Ts+YbQ7sDlWRIXkMU
	 ssuP2bgQGTi3DXBz63NVw7uhhDe0BGGLGxgXiIw61Hz2kwzdNVZuABvJ+G/aHCACYF
	 ganCIuxkZFc4A==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 0/5] mm/execmem: fixes and cleanups for the ROX cache
Date: Thu, 03 Sep 2026 18:49:57 +0300
Message-Id: <20260903-execmem-rox-cache-pmd-v1-v1-0-11beb2a3d249@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/0XO0W6DIBTG8VcxXO+kgEcQX2XpBeBhsgV1YI1J0
 3ef2qa7/Ajnl/+dFcqRCuuqO8u0xhKncR/io2J+sOMXQez3zSSXihteA23kEyXI0wbe+oFgTj2
 sAqwzurfSY62Q7edzphC3k/68Pne5uW/yy+EdP5wtBC7b0Q/H00u+rAkKLTBTTuXiEJZs/c9Lz
 PR72xuXJ/uf2FVnYCvUO/AwdupkYOUgwVlqUVsMCkO31u8EP6UUl65q0RiHChuvgzBGc90Ijkp
 obUIr+7bRtSSNkl0fjz9YgrDaOQEAAA==
X-Change-ID: 20260903-execmem-rox-cache-pmd-v1-ab97da2c4364
To: Andrew Morton <akpm@linux-foundation.org>, 
 Benjamin Tissoires <bentiss@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, stable@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Stat-Signature: kajz4b9e6y56jp83p3m4tz9bmncj97o6
X-Rspamd-Queue-Id: 6D7CF20002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788450610-524999
X-HE-Meta: U2FsdGVkX18IfWsBGw1DTSnjxvKAjDnG5SQW48q3KBaTumxlaj1aIptT4iguouyrQjeLFvguT/9Hj8wc7KGvlrljhhTZSp/XNapjkmi5AVFUA/TNUxA4hr6NIHQIGOXo7mzVVNY6hDELq28pb/SXB1aUMVr+NA+ASTcKmYB0gOTOEK8ooAdCySV4Zfr7pLL6N4/UZgnGG05GENHSkRozcQb+vLLuiTOeypan1i9ieXKjII6YihZcNRMXKCBqd4bedLtSu27yb6WpYdCyVRFU7L5A+ZonVJHzusjkM/LnqPmOlsfO7B7emVf9tuHJ2D2RMBXMg1jRITzM6lbvMEtEZsLkD9ARlGkTk2e6ftWWxN0HcW+8oRA60L5nJFFjdbwb/8wLzPwwwIw+DznWrBZ2cWlxiw8yc2JfP/Hnrad2WNw2j3ovVubVsqkOI4Mz7NhHjn9rI4ON8vDYaIuq/IOC1nL+MIROU5gdBQpn9TV0R7Nrk+uJ/WND8lB0en2mhsHlzrrKo4nt6UOFIAERn0UDyK1s/1bU77SwEoGlkLmuA+fEo6syrhkJGMrGCb88lcCZRuGrlhSiVjaffeeALuxtqmRjDm6wkskJmPQo62VDp8Ys15u6xkn+4leS/TzUOrBc9vVRHtihsv6HWDCDArl1r7jAccmgP5et86ZNnFyZxXqPXHYfnuhgy6uofurbCl3Qk78dnTGQTaDB5+dNCbCg7bYVkmRs6i4rfVpsbJQfPZjfxPqEeuDd8tl4lGamOLCMeABl+Kil4ODAC9o7oCzrFVnCTz4n2fE8NwIVUBw6Sz0TLYWh7J5noGSYl6AmK2OVMN53VRBaZbpKrBeaRWaF6oHcA0nkON97pbz0S0YKBfGQVF3dhfYG9a1t8MWoGhofn2fk3aXV6CHQWP3Aou2f6XkWXo/lrb1Y8bI0MeuZJ09khKEU6uCVBoO/yrE98I9DdgDNDJB/oUqscKafGmb
 +ySVjx8p
 TKFSRzeMb8IJhaDB4xLU7kAj8fJO88BS/23DIPgku3CUbpMK/r670iH6Ykz3f5YrCV36LeSeSIlOfZ4lYF+/b9ZrRWLkYSJyc5YlCnh3vkUBybbaIsqYvxd4Ne8IvvlSvyYexMj3DCMARr2clF3EgaKMwlPahLqjTwIBpLPk9I6ncK/i27xYNrNCw5hN5GmTyEL8QAe9q36bBYupZWMGuOL7sjQG1dByqRk/XTWJxUpM52Si+yPPubkr6AA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko review of the ROX cache refill path asked what happens when the
PMD_SIZE allocation fails there. Pulling that thread uncovered a bit
more than the fallback.

Patch 1 fixes a real bug, although rare bug: execmem_cache_clean() can
free a chunk that is still partially in use, because a PMD sized and PMD
aligned free range in the middle of a larger chunk looks exactly like a
chunk that nobody uses.

Patch 2 handles maple tree allocation failures in the cache. They are
unlikely, but silently dropping an area from the tree is not a great way
to deal with them.

Patch 3 deals with the fallback that started all this. The cache exists to
keep the direct map free of unnecessary splits, and the fallback happily
filled it with base page mapped areas that could never be freed from the
cache again. Ask vmalloc for a huge mapping or nothing, and serve whatever
does not fit outside the cache.

Patches 4 and 5 convert the ROX cache to scope based cleanup.

The series was tested on x86 with module load/unload cycles, with PTDUMP
confirming that the cache is using 2M mappings, and with nohugevmalloc
to exercise the uncached fallback.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
Mike Rapoport (Microsoft) (5):
      mm/execmem: free ROX cache chunks only when they span an entire vm area
      mm/execmem: handle potential allocation errors in the maple tree
      mm/execmem: make sure ROX cache always contains multiples of PMD_SIZE
      mm/vmalloc: add DEFINE_FREE() for vfree()
      mm/execmem: use cleanup infrastructure in ROX cache functions

 drivers/hid/hid-core.c  |   4 +-
 include/linux/vmalloc.h |   4 ++
 mm/execmem.c            | 124 ++++++++++++++++++++++++++++--------------------
 mm/vmalloc.c            |  15 +++++-
 4 files changed, 92 insertions(+), 55 deletions(-)
---
base-commit: 8499b4645c7f199707510461779f82d85732e742
change-id: 20260903-execmem-rox-cache-pmd-v1-ab97da2c4364
prerequisite-change-id: 20260816-execmem-set-vm-perms-v0-2-bae847a4f64f:v3
prerequisite-patch-id: 4d8c7989581fd5f4aaa2e315bfc903a9f0aadedc
prerequisite-patch-id: 211c002f2501d5aad7dea733fc6273c76bed910f
prerequisite-patch-id: a328539ba621866e4a63b39ab72a54dbfb3ed0a1
prerequisite-patch-id: 991f843051a913188e0cb671f3e8768682f895e5
prerequisite-patch-id: c05688baf37b3e80a57fe85d351f997f017acea2
prerequisite-patch-id: 36038f3f55748416fe56dc990d3836f70e851f59

--
Sincerely yours,
Mike.


