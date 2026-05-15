Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B948ACD4F3C
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 01:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E53F46B009D; Thu, 14 May 2026 21:57:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E04646B009E; Thu, 14 May 2026 21:57:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D19CB6B00A1; Thu, 14 May 2026 21:57:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C12A16B009D
	for <linux-mm@kvack.org>; Thu, 14 May 2026 21:57:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5F1561A05D0
	for <linux-mm@kvack.org>; Fri, 15 May 2026 01:57:50 +0000 (UTC)
X-FDA: 84767993100.17.868E3AD
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3E25314000A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 01:57:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BzWog3VZ;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778810268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yUT+3E2sed5W08N7+AqBJgGJHLA+jsUduhXtueyYFlM=;
	b=iITZ3qpOhB39NPcazlyHrf3EL5nt879/Zvi1HQFXJLpDA7LE/3oUjLaCUL+HSSDxuNRT5K
	nNf8/1DXLbpLp+PCI8fkjki4Y+iJhvoAZ+1+MAj2NduL3Lrk+mfOHeSkQYeedaO6G4NqiS
	cAPSswaBZO27PQDfnOCjUNdJfH/L72Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BzWog3VZ;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778810268; a=rsa-sha256;
	cv=none;
	b=OHdBQOrqYGcE+TbYQ+O+LFcZiMcZF6RokB/v/fFvY8LndZz4lhuROnhvTpNGx1BmvYIS95
	XImrky22ppmrtgbk6tKuaLilpT+oGLIJH74kX6wco/xeChFDIYFFPss3UNE0yp7ywu7ags
	1SxLOI0MDSBM0ZrmRIb9OvE3GVGRmyI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778810266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yUT+3E2sed5W08N7+AqBJgGJHLA+jsUduhXtueyYFlM=;
	b=BzWog3VZraCpxCy7iqr0T3VPijOXg+cx5QKGfz9cBdjut2/UJO5t3Er9arNG258boa3G9o
	KHgCPUnve/FTapPpB4E7Cky0CbrisrZEJU95ZW8Gy/qSY1qygURvefOUj944oVDFitQ3DA
	RCBWIvqwfR6hH2TKvqGSXH0kGK3z6ns=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	usama.arif@linux.dev,
	baohua@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	hch@infradead.org,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [PATCH v7 0/3] [PATCH v7 0/3] mm/swap: use swap_ops to register swap device's methods
Date: Fri, 15 May 2026 09:57:34 +0800
Message-ID: <20260515015737.890994-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3E25314000A
X-Stat-Signature: stcqwdyzypxx1wx4477kuxxwe7df85yk
X-HE-Tag: 1778810268-717441
X-HE-Meta: U2FsdGVkX19Pj0clnLXkIMBsyWZ48EOSInfnSM8mscrO1Ovqsc+Y5Cx9+PlTTsXNcDho3HxWnOUYFdeuiKyos2xeTzmxTxLOKLSDwPYiA8UrrEP6tKhXmHSc5kRsW5WNKPaKcX/4MTMl53rPzP2JXHWIOpFryUtwQgTp+PMEksaGMktTHhjegkFKueh3gK4NMDa7XyOVQ991hUHib5BRqNy+BR3YaRFxaGmknCNTdgghESbXjPIVdgM+G8PFiaHAdZR/wfHDvz5n6zSq/oyOl55hXUQlRGq3nn6SaXFDbIrX12UPzi8OCDgQxhlSHHigSmkZfIdOcc/IhwbyjY8xAnzDvy8q6ZR/ebXuXFF4OVwdWgRwhhMhwb8OqN5zL/NOp3ct5QOEdVFF6msMyXspoJJyGMgpwqFCuB4cU8PnYhzUuo1iQcfwD1TkWGCnvv/FPE3hSOhzgdEAqtDn0U4RPvKY3GuJkHx8WHo12CiZfDyxQBLAnDpi0QKInK0VmT8/luIferQRmrU2IeAR9eVXE4XAAjZC8DnpR8mPl+L1Q2+4QyApP9ncxOegXsx0WvfXEej3sMWKgZ5vhP7Rh7HJSOJvsD/vGcWzP6/NJMNayOZT7k2mCUDIwfNouud6XFbAmPz7TKIEJh51+gzw4SOPsk6NZXulSp9m1jzbO8PkChbWTpqzttM4Nx77CUxiZylg9ooduk80zEyHUv4c4q3kHzamVd+q9/k1UoDvifSxbcfwdEVsaFAz6zH9gCQIy4YuCt7oaamkzTGtQDcjdN12CkAYFkhIa9jEDHqs8AfVF/9UXWw6H78o8xptwElDV0OfgsG2s8sduVAWUkIVyvATNmwNZ0H810hESTb2IG1BycN2lLIA99nlUpbFiIAXQvDv/OFdpPbPVWQXGuaMRA8s35SmLIbRCRjlVQdxXF+7MVBhKJGzZKF699jpPpEcc+wvJw2B/Dj6680IWBDYT7X
 oYn4FNkA
 gKL2whNt5NNxki1K1gs2PBe0m1041C3k9qsRQpZWO6lpCcTZG2rrg+ZYjOG2T49/7IC+sQBofgCd0qV87rIgcb7kT3dxVk1lGiQDBnejsp13bBt/Uwfv6kGM0nzyQQxtDtCWq4su84yoQMM5LjQ23Bb5P+J6kQWPDXFGfdKAsISZiCkaLSPhrf7bNiZCtoNmaW9TlFFalzGgqLTWY4cDVO34HGLAeh4ihrm2T2IcnfBlwpXUeb+YDJl7p/uTiaWxlSyUc8s6Ow8i20T7wAXhIs5+AX7y/vpxGRujV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This can simplify the code logic and benefit any new type of swap device
added later.

Patch 2 renames the page_io functions to a consistent
swap_<backend>_<op>_<folio> naming convention. Patch 3 fixes a
leaky abstraction where FS swap unplug bypassed swap_ops, adding
an .unplug callback and dispatcher.

Changlog:
===
v7:
  - Drop the old patch 1 "[PATCH v6 1/3] mm/swap: rename mm/page_io.c
    to mm/swap_io.c" as Christoph suggested.
  - Add the .unplug callback to address Christoph's review about
    the leaky abstraction.
  - Minor cleanups and fixes per review feedback.

-v6:
  - Fix a code bug Kairui found out when reviewing patch in mm/swapfile.c
    in patch 2/3. Has fixed it by moving it to appropriate place and add
    comment to explain.

-v5:
  - Change the return value of init_swap_ops() as -EINVAL as per Chris's
    suggestion and adjust its invocation in swapon() accordingly.
  - Add Chris and Usama's Ack tags.

-v4:
  - Fix a typo opeations -> operations
  - Fix a code bug inside init_swap_ops(). I was taking a change at the
    time, thought the change is trivial, so I only compiled but didn't
    run kernel to test in v3. Now fix it and test passed.
    Thanaks to Usama for catching the above two issues.

-v3:
  - Rename setup_swap_ops() to init_swap_ops() which reflect the function
    behaviour a little better
  - Check if sis->ops, sis->ops->read_folio and sis->ops->write_folio is
    NULL in init_swap_ops(), but not spread them where they are called.
    And once the checking failed, fail swapon immediately. This is
    suggested by Chris.
  - Call init_swap_ops() before setup_swap_extents() invocation. This
    doesn't harm anything and can benefit later adding sis->ops->swap_activate
    method.

-v2:
  - Lots of cleanup for patch 2/3: renaming, moving data
    structures, and using const properly
  - Collected tags from Kairui, Nhat and Barry

-v1:
  - https://lore.kernel.org/linux-mm/20260302104016.163542-1-bhe@redhat.com/

Baoquan He (3):
  mm/swap: use swap_ops to register swap device's methods
  mm/page_io.c: rename page_io functions to consistent naming
  mm/swap: add unplug callback to swap_ops to fix leaky abstraction

 include/linux/swap.h |   3 ++
 mm/page_io.c         | 115 ++++++++++++++++++++++++++-----------------
 mm/swap.h            |  11 ++++-
 mm/swapfile.c        |   9 ++++
 mm/zswap.c           |   2 +-
 5 files changed, 94 insertions(+), 46 deletions(-)

-- 
2.52.0


