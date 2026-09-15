Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3150DC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 06:29:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D329F6B0088; Tue, 15 Sep 2026 02:29:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBD3B6B008C; Tue, 15 Sep 2026 02:29:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B85146B0092; Tue, 15 Sep 2026 02:29:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8091F6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:29:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 805451C21C8
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:29:34 +0000 (UTC)
X-FDA: 85215020268.25.DEE017A
Received: from mail-pz2-f28.google.com (mail-pz2-f28.google.com [74.125.228.28])
	by imf31.hostedemail.com (Postfix) with ESMTP id CA99D20005
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:29:32 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gC9UnAuT;
	spf=pass (imf31.hostedemail.com: domain of matthias.goergens@gmail.com designates 74.125.228.28 as permitted sender) smtp.mailfrom=matthias.goergens@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789453772;
	b=UcFrYzmJgeOPfEMwCeuuw+QluAcFxpxjleK0RVGzI9iKXvAap1/x3y0VyQz+Mlx2r34OkY
	ZmZln/jt/y3L7VXtEULnLtXSSwo9MLfkJ1JUTGNycyQeatlsyXVMHjISQYM5a5Ge+8C6Wj
	50KPhnNTo7HPzC16M8BEXE3Ar0EbRok=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gC9UnAuT;
	spf=pass (imf31.hostedemail.com: domain of matthias.goergens@gmail.com designates 74.125.228.28 as permitted sender) smtp.mailfrom=matthias.goergens@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789453772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Jliu2qQ+Am9D5/J1PCi8w8fiwrrDcbTYHcV6N7E5S9c=;
	b=OcDIQesZgXj/XbNyDhr51sGllvLNo0hhX7iz2Xge4cYoOPAteAI/PU/NG1di2wQRpBUjA8
	6k2NWzIkwaovdhwntuM+itRDrd0OEpXBrwDgrsbAgk/gugSvwkIwTUIEJ39RHcEcRImK+B
	TMJec62LD0PKWhQ4nnBzWV3q8jACLvY=
Received: by mail-pz2-f28.google.com with SMTP id 41be03b00d2f7-cc4ab4fe290so692161a12.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789453771; x=1790058571; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Jliu2qQ+Am9D5/J1PCi8w8fiwrrDcbTYHcV6N7E5S9c=;
        b=gC9UnAuT3PNLlGOAQvdghSyr9iQIqejXEy0Pl3AS5rOWAD2SAIG2wX6bMKbtj66DXI
         QGMbZvbUuuPJGHhQ5ZJKTf9M/BcPh+H++wQdwCiHLW7BxFppFYGYKu/VEV34SmJYqynh
         OeM0s0HggYBXOUH4fF/ONjmYHL+YqooOIjCvK+bhuhrh4z/NtYvXBGysaSxZvBmSYE9Z
         5ICO4+/rmhU/BsCsOl3H/1U9jM+kWBz460ejxne+yUtRifvUDO1GlZPoC95R5rrPR1ua
         wWXI3ewiJtZTH70Fy7sUQeeZzKZ1O8tFZXRrwbztLKVYhBs4Xk26fDnRlGdQm7oIScQP
         S/NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789453771; x=1790058571;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jliu2qQ+Am9D5/J1PCi8w8fiwrrDcbTYHcV6N7E5S9c=;
        b=Bqkr3F2rnVVkZ2tiqrkWXOca7u7uwiMvAk2RYISzO9W/aan6Udzfo5xRo0GH+QIAj4
         eJBeYinPZ4gcXRETOrO9lfSy31kAeDEXXVubMolHLW/4EJsCmB1Sn0bWBuU0brJLfvyO
         aI39qgmPyluY4kOxWvs1eMdTvNgn8SjvZYI6vEvIdLzocqrQhtSg7VwV6LRqUXa4qmfM
         kNLJy8qVOuVVYdH/ayEie3FG0lrMT5v0yDP0CB87Bo77uGGk8na8xxJ8zzJ/M1fVOfQl
         vXWwdYiAXboXk3Z/KvO1noGzhRnmusgSxX+DRMiHAvLwQGM4pUp+ZB1jUExyL1wL0t8C
         3wFA==
X-Forwarded-Encrypted: i=1; AKwUvBzGAWRCV+gUX4pBGt+y/cBDLVDw0qhaDwilU80D2LO2yNYf++tqjyD06QQcq3gHgIv1CZb5D2SuLw==@kvack.org
X-Gm-Message-State: AFuF++k5S5H86/FeqHmxvWb8J+gKBwGQExjSVCuJNE2E891jLd4e3hv/
	7LDuG6PXceorsWJ2m+F+9R3EwhFXGuRWEfKPTxYl89JpEwHXFSdqsz0s
X-Gm-Gg: AYBFou363KeDMb7hbPj7owcaH1lWuu1G4YM4KpF884jMfwSJiKwAExnvaX/l7v1NK2W
	+4ndn5Ba96E6udD3G140WSl9XziuCYuF2K4u3kiAhHtCfs8+CTWQpq9xLA9LEYVdvYtAlAkNcY9
	au3yo0CT158pFqwG3uzpwFfHo+7XhI2afCmiXbeOZysZ+Kk1JD7NZQzbksjFmTeiHu/PZXSx6/P
	ukKkvXPJ9J0d6+kGjneWYsJKtrrOSRzShWY+iVRWeXdN2vyOE6XSsi/LLGVihmOmO/bOgFI5t0x
	Hdny/32maBxCRYZ1RruMHIViDkYDsn8uFERvQtTNcKOA8FL5nRQVH4IgaFHEmmiuULIcyy+BKtz
	IfvtgUzn4rx02zJ/52uv/nznM9lxyNvykcuc8ki6uOEilB5nRkrujDHRCOIwKqkus6XRxfZ7vmT
	wCwnF6PMlVtz3eulX0Hv2L/Wy5L9Zj9/WMnSnOA5PdJKQAGaqQXNwAVcwPLTYLXaVH6/t6nU5bb
	BpzQFoY0VkGSGP7JEuziexPV3Ucakq0UfPpkxNfwGtn3UvMkQk2GIDE3B6gvzvBAse7G7fU/sfs
	V0HI5iQBn2CzwNrBtuut1dk7xvp2UnhGA0uL6OR51TGgYchLCjmg4L9WRz5fTu32
X-Received: by 2002:a05:6a21:3382:b0:39c:4e62:b843 with SMTP id adf61e73a8af0-3db5005bb45mr4318757637.10.1789453771209;
        Mon, 14 Sep 2026 23:29:31 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.252.203.158])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc4c6549d95sm6031973a12.12.2026.09.14.23.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 23:29:30 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Matthias Goergens <matthias.goergens@gmail.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] drm/i915: size shmem writeback budget to the object
Date: Tue, 15 Sep 2026 14:29:24 +0800
Message-ID: <20260915062924.2410550-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CA99D20005
X-Stat-Signature: gqsd5qm5inxojiu3okipa4bndbz7cmab
X-HE-Tag: 1789453772-638249
X-HE-Meta: U2FsdGVkX1+nV/X8Pi7/tBLsHEo9TdpNYiroNyR1R8SEkwgWGGxZ1rQCZfAkGNUlNttSEznHMVNoT/2L1uiTPOk3eZsbtj+RoPHbpGWNZ3QhCVFZ3xHwHMbtmmuHr8EuOLgYiXpuR6sI9uHkIpvWkrSWzwDMPBhWq/VuqbNUgV5RtAQ10uZGhLK+LZAdeB4QZxm8kE/Plwp/XX0bwtow8Mz90tN7D3oZau9oX98bmUaX4WWi+lRMD4ZHj3CF4Tv9KwEaAeD5B2t9HjRR6xZh7OhwlD5oq0VeQgoTSvANGErkCYn4Zv7btIyRKa44Cw18te7aaGW7/G1J+60zieJUNrncRUlclXau+BEpAp7OBxxhDQ1+Q6ZW3w3RpNURH+8aasUQ36yZmlGejPlEyyWlBVw+1ZvQGhiK6ar6FvzLCIXmL+nQqCQ2dCVXkkf3OThUUpLEerYZn1iNOQiFCTa382ZClNmumLPY6JLTg++UCAE/eDk8IE5ZRyToa7KDw2a3OjiWX+S5HYcpQkUHhOZKIXg+5iT+xO6MY9bhvyvw2JaxrE1RjD4ykNZDUbKgmIpwSGTN02OqIflEFjsqQHQgZs+OUAZavFuuJNmB6mTPtqcDKgdS1N/lW4HEWdENzb/z8MZW8ShNQueMSfgj3OE60pPuiJM1D7iTJBJfX9t/RfL5+cT6K9ae9xIHGNg3AO3MbsKFJNAAglSNZLAH53i/fOdq/bZG002/okHqPHANIta8sW5CbW8Rxo2ZRu0ur4/TRiryxaajPYuF8DpR6zvJedgCd/AHBtblvyHIW8ylw2poA/dowDzBt0lx58udfrc468oIRRTsor2KpPJFrIuHsIDhNU8pjUfT3RiCUx8aehyUtf5qOgBIFAlKuL/oNj0/zhcyuSUo7M7jzcMAjyyMQEPD/ybPJG6FfKGX6zHeKw/oc2rjMvpM8w4PJfzOQnPVi2gnZLRUW27RZJ4481t
 HctD1G5d
 7pVEb7o3ad0ZW1oqCqHLzNYmeiAyC8pkIngJE6EVTqklM7cDfn7ovsJCwQ5ds0fmRoS8uxgxNXGYLK6JwlCXuOBl1kreC6UDm5WiPd0DGiU1j8ofFyUayOFeULVsdQy/6hAX0uCMKOUp4mUBxVCtoewRtziXUo6/iJXmZf9S2Ffp8DqvVM2CCTq57CzDBioRqdXXZwoZs9ywZCALB6fdtxUh+uy17w6jU+pPrpEhG9Z9CwujwkTN/voDbR3+D8tMN4MODE6j7uoiobMtCNtemvHZmXHcMotNV5d9d5IiyjQdjuNIvJp8vZBQT2/JaYms8XqmIBkqo/b+Ga4CZzbolH5PswrADJ7QqwPTQApU9vhszxqcTsl9jWLWS4WazCvfUexkUXE8A+YNcBSoEAC8cf2MxuFh5lSFEPlMKBRbf2PbrIZ0bvH8lGvmz7e7i+yaq/A6dykQm5yqnjn02/bYW+UkwCAHd/eHd7zN1tQ25uq/ENbxBBBTEz0iRFmiUn2WK2Fr+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Before the writeback_iter() conversion, __shmem_writeback() walked the
object's page indices using its size argument. The conversion retained
nr_to_write = SWAP_CLUSTER_MAX, which the old loop did not enforce.

writeback_iter() consumes that budget for each folio and stops when it
is exhausted in WB_SYNC_NONE mode. Explicit writeback of larger objects
can therefore stop after only 32 base pages, leaving later dirty folios
unvisited. Mapped folios also consume the budget despite being skipped.

Use the supplied object size to set the page budget, restoring the
object-sized writeback attempt. Writeback remains best-effort; this does
not guarantee that every page is written or freed.

Fixes: 776a853a43c9 ("i915: Use writeback_iter()")
Link: https://lore.kernel.org/all/20260914111511.648711F000FF@smtp.kernel.org/
Cc: stable@vger.kernel.org
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
---
Thanks to Sashiko for pointing out the writeback-budget issue.

This is a separate follow-up to the folio-unlock fix and applies
independently. Compile-tested on x86-64 with CONFIG_DRM_I915=m.

 drivers/gpu/drm/i915/gem/i915_gem_shmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
index e7b18f7f9644..5751bd25c2b2 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -308,7 +308,7 @@ void __shmem_writeback(size_t size, struct address_space *mapping)
 {
 	struct writeback_control wbc = {
 		.sync_mode = WB_SYNC_NONE,
-		.nr_to_write = SWAP_CLUSTER_MAX,
+		.nr_to_write = size >> PAGE_SHIFT,
 		.range_start = 0,
 		.range_end = LLONG_MAX,
 	};
-- 
2.55.0


