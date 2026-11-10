Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1400606A332
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=P9auZXSc
Received: by kanga.kvack.org (Postfix)
	id 0CC016B05D5; Tue, 10 Nov 2026 06:49:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07CC06B05D6; Tue, 10 Nov 2026 06:49:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFDA16B05D7; Tue, 10 Nov 2026 06:49:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D304F6B05D5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:49:38 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7382D1202E3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:49:38 +0000 (UTC)
X-FDA: 85419039636.29.AA77773
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf22.hostedemail.com (Postfix) with ESMTP id ED6D0C0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:49:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=P9auZXSc;
	spf=pass (imf22.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794311376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=38/BCZiYFBdrUt+84du0Qf+VwsVgj9AVlbyv2JcWo+o=;
	b=XgRF2P4CWqbZBd7qGlhNcY+peqcxKeoQcMmwonS0b3GBQQJiI50w9CojOvx4wh2O3ZadKo
	Jjscosg6E022MrH/oeXaJsf4kDpn9Lz0CXdEK1GBpceVSm6WGNXSp94yrgEkvebOqtfvWr
	stBEx1RIpprJtFdb14/aD4TVPRxw1ls=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=P9auZXSc;
	spf=pass (imf22.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794311376;
	b=1LDHoFIGQIoW41NbdNu/pCT2GK41DW2xLqIvKw3s2Zu+ywNltR02/jgaKRE7QBAmszOs/I
	X6/yubMpkpsgFu1ABz4ju2Tsa+AXOGrxPmRIbZenKG0IFl0eIH5HBodQWyyrVEKRQVwtnR
	xGnntjKIASklvJauLe2i3XeZUwcQxJ4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1794311367; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=38/BCZiYFBdrUt+84du0Qf+VwsVgj9AVlbyv2JcWo+o=;
 b=P9auZXScAkzfKb1iAxOKhkv8KXL+3Sc5fNltGKgq8vM1gYeZe9KWMRYqqlXKcs2cRrkYJm
 HNgtrxfHstm9BjWdQzQoJtwpqamGeAJ7UmcxiSnyBlI/amClShNeJht3xWXBrkmY7+BQCa
 rH98Bc6Jl0ZV6Ae7G7EYxSiB3/HbbaV+9/PkAt1tkLIzGUG3JIzL9KbP7bokDFl5hxuKVN
 IUwWPCfJyU+Zrn7yA1jtfKp5JXRJKOMzkNVyjgpGf5ChSRK9Dr+KEoyVFiRh9OvKWgSViU
 RP6fsqLdwN+kj3h3Vai/Pg764H6SRIlMo1i4ZnSdXWP0CjY+1ooESalQuRtEqw==
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20261110114859.76343-1-lizhe.67@bytedance.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Subject: [PATCH v2 0/2] mm: optimize HugeTLB bootmem hugepage init
Date: Tue, 10 Nov 2026 19:48:57 +0800
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <balbirs@nvidia.com>, 
	<david@kernel.org>, <muchun.song@linux.dev>, <osalvador@suse.de>, 
	<rppt@kernel.org>
X-Lms-Return-Path: <lba+26af304c5+0de6bf+kvack.org+lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Stat-Signature: 56z1zfzx6xq44mics9ajthf5wigi556e
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: ED6D0C0005
X-HE-Tag: 1794311372-995532
X-HE-Meta: U2FsdGVkX1//w1zzypDvf7C5E0akvsLBwTc1DPLQy6WzK+NfBRQjlr9X3ecg3jmDNVr3RRtQ6HQRlG5uFd+XzpUvUvJWD4U8jCEKbp6p3yYbByF9oX/rfBciGUNbKU2fMGSjcmENzousg82BbFpT6SY92E3tpdCq7Ux09FVc1pigJanF8hw5GL/Rt36sJt7jham/kRl0/vXXU94OFf1t1rcFroD32zqI5zLwS8rDZkRWlCbdULHYgrQgfFIvLUN1sRGKDVy885URjKcAKAJiNI5r2hOoX36jdU1brPYybzEsAmJeHjhGSb3JH8rD1Z6HE8VrUVBx8d6l1jSIlX61uZ4xjL5L9R8CNmksopmqr3C5KajNIIQVpcCNH8eU0syBoKwvRV781GEjm/wQrlM2QxirTSvmAsVYFqRgUx2r95hMwAgqCOzY4q0/5xbTb2grZgxJw7qzYNt+PmmCQBQbxGN4rlkZfZlkhM/EW4RrELvsFlFR4UJIE7s3fLM2Ee1W+20CelH3jmZaBtEls5kPVqNgxvOThiBSphZcBzSkZeceWDL0TGx2HEiOvr5QY44eI7ZrHUB9Yxfz4sgaKx13uKfgQI3Q7DkenLPVIKJW6zXdWHQgf/RcPuZUIdVAq+7rzZzTAtwklA44z4tZlpryyfVA+qzxzbDagz39ksIs7FezNkf2aM34/R6wT0xfiCttQ6ffZ2+2184qTLtk9nPylMYrdKKvvdYRCxaUgOqvnbTwxpjL5vsrAA+9HL9BRgJwaOcsB4+lcKmNCeALH8WCNPNZy299ELUj2J/eEdeG6AhEy+A+gXoNhh2GcczU7GdRMauV/afPVNSHtmSJ8WRay6xTEDYNupTOF+smJpOjkvGk0FKZlHZu1CNi8PPW39i935ugdKGupqdZNoArg8AXQI1B9MwVMhZBftYYS6u26nehpLpJjDxXq57dlhQnWt2Bzabkzjkz3Ioil7CLMZy
 qkSTiVhV
 jPlJvgMNWyiyfUPx4RpZ/2Fw31xHcrOCz62MaVu7GnyxZoTVG+AHUjqYd4asprqliS6kvrc0Okc8l7iW4Ok6P9qeq0BuNMzs58rBgc6pvBr6yhGUEBG7wHM6aYk5HvsB8QjsCGL1qLQvYx/TckFWEsUJMJRU8zmEIK3//TuY5UwqB/zYoEYTZb5/vZbBXxgx3vGVszPdT4ATLlNysjcZ7Cp/Gi/OBBks9gA52OcaWfxo2LpggLpkLFb5kxjkQNmv3c5EnlIT13t8cM/ibv9jQYC/D5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series speeds up the fallback initialization path for HugeTLB tail
struct pages during boot-time hugepage allocation, when HugeTLB vmemmap
optimization (HVO) is unavailable or fails.

Patch 1 factors the existing ZONE_DEVICE template-copy operation into
memmap_init_page_from_template().

Patch 2 reuses that helper in hugetlb_folio_init_tail_vmemmap():
initialize the first tail page normally, copy it into a local template,
then initialize the remaining tail pages by refreshing only PFN-dependent
fields before copying the template.

In the earlier discussion, Mike asked whether the same kind of
template-based initialization also helps the ordinary struct page
initialization path:

https://lore.kernel.org/all/akfB6Qe-jKDEMUxz@kernel.org/

I tested that direction as well, but did not see a measurable benefit
for ordinary struct page initialization. The measurable improvement I
could find is in the HugeTLB bootmem hugepage tail path, where gigantic
pages can require initializing a large number of tail struct pages when
HVO does not cover the allocation.

Tested on an arm64 QEMU/KVM guest with 4K base pages and 64 boot-time 1G
hugepages. HVO is unavailable on arm64 in v7.4-rc1, so the fallback tail
initialization path is exercised.

Results averaged over five boots, measured with a temporary
jiffies-based printk:

  base (v7.4-rc1):  318.4 ms
  with this patch:  202.4 ms

This is a 36.43% reduction in the measured fallback tail initialization
time. The temporary measurement instrumentation is not part of this
series.

Li Zhe (2):
  mm/mm_init: factor out memmap_init_page_from_template()
  mm/hugetlb: optimize bootmem hugepage tail vmemmap init

 mm/hugetlb.c | 20 +++++++++++++++-----
 mm/mm_init.c | 34 ++++++++++++++++++++--------------
 mm/mm_init.h |  2 ++
 3 files changed, 37 insertions(+), 19 deletions(-)

---
v1: https://lore.kernel.org/all/20261105120615.16817-1-lizhe.67@bytedance.com/#t

Changes in v2:
- Add a comment for the template-before-copy ordering, as suggested by
  Muchun Song.
- Drop the empty-range guard in hugetlb_folio_init_tail_vmemmap()
  as suggested by Balbir Singh and Mike Rapoport; current callers are
  expected to pass a non-empty range.

-- 
2.20.1

