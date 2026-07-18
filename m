Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCBD2C44520
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 01:29:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A17AD6B00AD; Fri, 17 Jul 2026 21:29:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C87B6B00AE; Fri, 17 Jul 2026 21:29:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 904F06B00AF; Fri, 17 Jul 2026 21:29:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 65A716B00AD
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 21:29:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E03911602F2
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 01:29:50 +0000 (UTC)
X-FDA: 85000165740.21.86071ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2315D1C0004
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 01:29:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aYHkjg99;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784338189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nGP1qpw+teL8hrbVXIODrPReZTXoSMVoPewT58BkKRk=;
	b=64PgaSgcdmaUaiqzJchhc7K9agxkT/x2cLaL89PbenlLwgb9sFKU3K/AYJug7k83O68kFy
	xff0Jj1eRsaWwnX5ZTCHoigNPZROhWbpt5s2iXMwr1CwCaXDhg/Of59HbQBr8Nbocrh4UJ
	YIxegZ1j3gtg5YhYyIAKgpC+UQEXQak=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aYHkjg99;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784338189;
	b=QVJFR94R7pFLvMK35vYR6cpzYv9ACuEokZMx7tZ79TX1l36DDJ4vQmpE3NvwerZNVuI59A
	8nomQ64FVW+/aD+ivMAq8ibiT7B6B12Uq9woXfwaZQiDVq8Wh2NKKO+KsFNfeiDyC9Otb+
	aNpmSO8tua4fx84AM1CIkHlpbikUBLY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5169041529;
	Sat, 18 Jul 2026 01:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABEBC1F000E9;
	Sat, 18 Jul 2026 01:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784338188;
	bh=nGP1qpw+teL8hrbVXIODrPReZTXoSMVoPewT58BkKRk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=aYHkjg99340LaoEW+nC6j/pobLTfRsTslXzRUwPXTHiNjEJadkub9WwJRQgp86jFn
	 5+NJNrQuZhOT5lp9Bw4Sj0JMFtWWc4BWUXkQ6wlqgwBPxG+QcXQbg+Gzm3pm0QIhlE
	 LVQ5wOhwRIK1Md1rIdk9Eo4FSl5T/rwYi7n+OXI0=
Date: Fri, 17 Jul 2026 18:29:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nico Pache <npache@redhat.com>
Cc: Barry Song <baohua@kernel.org>, David Hildenbrand <david@kernel.org>,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, willy@infradead.org, Oscar Salvador
 <osalvador@suse.de>, Zi Yan <ziy@nvidia.com>, Matthew Brost
 <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
 <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
 <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>
Subject: Re: [PATCH v2 0/2] mm: fix PMD level mTHP accounting bugs
Message-Id: <20260717182947.534af296aaa1831d13f8ae6d@linux-foundation.org>
In-Reply-To: <20260717064502.1980173-1-npache@redhat.com>
References: <20260717064502.1980173-1-npache@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2315D1C0004
X-Stat-Signature: efwbgaessdfe4rj853jc4ck7kccqj3ao
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784338189-306211
X-HE-Meta: U2FsdGVkX18XhVjP0uENgvBK0Y/5wm04SXp82/UVCqmSv8SmFBzooqSKSlwVP2MK7lPasOsjXEk3Sut2mX2fe6JcLptygsjj5LeGyk/r+8zJVg0Qhv7/LGGUYHDTWyFxN0wq4cu/dNFIwOqkHsemB6XMhR0ksZnI4F6lsUVr4zfBaYNU9NUfFtVxD92T6MOrDcKpn+9YxxKyhTFQTb57mWtEiFZgZKoc5bHGCWGQiOrMSmKEBxRj3KXTkHQWWHrewOcHNlrLG7cbrGBV1f5ixLLLKQjpRLNBVeT6/lHv1uCmEYJ8pPxq2S3o8q9Aub/DRE4NRunM6xETXOqnxv++kCfWRBriG0G2D4uTO6r0SAOoVRofPDOmisnYHIrGkb+uB3w26QfIafJ53AcDwCRCDkMlYXn6bk6eLh0eQJ26hh+d1fDyr+IM6CsNX5PPhv6pa1e4lPzAv7bt/mWjvdlhf4zCGb+wf5Xj9cnuUhdE1abM5rms96KHBhTrX+PTVkuXSBu9i0xSgdRz5hA8y/D9uXkRdlF/aJAMAOsLZ23GswMtwZwW+rU1V7f5s4WuKtXd5URvZYz+PcgmiW3ryG77UKPglARARWKxdsJYzjlVZvn/qgxpzZZYgNPsgJl0jg3MSbrX263fgtvhHmoFBiMmHHmLIpoMxKMZ0B2WnSO7qdxlYKogY/YQc5v3EIR5VJp15/w82xKmM4muY2AD/WTei0zBdyndgcTgHIwvLOou4Wf9Y3TiYM6hK2G9rKRGBJQFVPV3cyzoodH/PDtS4UZnUnXTrw6wmXmmdoefKLy5iBiZjyEzELlysSrZQi3mHqtFyNIdBA8LhAHGyuiM04OwYWcM2aq4VdnTLmzhH+svD/jMxiSYpJhLYLhMj6Pr7kyrUim8dup4O+IDEjbBHp5AkavkoBGBe3VNjLrOSQ4jXe6XJJm1Dd/YpZ+02Sn1MbfQ+S57VfUFgxy/UMr5OfB
 oCZXGYUm
 S7k8RxWVC3lmv5Z1FWXTuV0mUhcALPJPNo/TLSSY9zIflvf6gEuOUfVr9fpiDlpSLqF55UtngXbHap008Ua+pvUPxGlEUoGIZUNSzn5edCCGR1Ivi0l8xnhsc1XTJmhnwn/NSwXMcPQSpnXfE4U42kcIsDFy7hKuxKK8ktk6MPx/WrvY74cGnqwMNJdhFxNBT690jlyychk+ufwFfaw1bYydyzmXeAJbHRyPeEi2RyoWx13L2zVS8ot8WIM0qAgs4exMoa+Aw1QCjjn4Yc6TpX/hUFUBt0YEZX/lBhKuneleQptUjrj5M4m+Nz1Yk57B/WLzMjJIGWD78ngR3JxAwEUpI7cHwHgKU3YKfjd5wlfaDuUQJYyjL96AZCel2Waaz4zW7jTUV1edkt6qlB3BhvAHrJOiQj2uotSDL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Jul 2026 00:44:58 -0600 Nico Pache <npache@redhat.com> wrote:

> While running selftests I noticed the PMD level per-mTHP stats (nr_anon)
> remained elevated after each run. After further investigation I noticed
> this accounting error occurs for both the migration.private_anon_htlb_test
> and the HMM tests.
> 
> In the HMM case this is due to folio_add_new_anon_rmap() incrementing the
> mTHP stats, but never containing a corresponding decrement in
> free_zone_device_folio(). We solve this by making sure to decrement the
> counter when freeing device memory.
> 
> In the migration case, we are incrementing this counter without first
> checking whether this folio is a hugetlb folio, which relies on a separate
> accounting system. We solve this by adding the proper hugetlb check before
> incrementing this counter.
> 
> With these changes in place, the two tests no longer cause elevated PMD
> level accounting issues.

Thanks, I've updated mm.git's mm-hotfixes-unstable branch to this
version.

Sashiko is worried about the existing code ("list corruption or a
use-after-free panic"):
	https://sashiko.dev/#/patchset/20260717064502.1980173-1-npache@redhat.com

> 
> V2 Changes:
>  - add RB from Zi
>  - Drop unnecessary check in __folio_migrate_folio(). HugeTLB has its own
>    migration system in hugetlbfs_migrate_folio().

Here's how v2 altered mm.git:

 mm/migrate.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/migrate.c~b
+++ a/mm/migrate.c
@@ -624,8 +624,7 @@ static int __folio_migrate_mapping(struc
 	 */
 	newfolio->index = folio->index;
 	newfolio->mapping = folio->mapping;
-	if (folio_test_anon(folio) && folio_test_large(folio) &&
-	    !folio_test_hugetlb(folio))
+	if (folio_test_anon(folio) && folio_test_large(folio))
 		mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, 1);
 	folio_ref_add(newfolio, nr); /* add cache reference */
 	if (folio_test_swapbacked(folio))
_


