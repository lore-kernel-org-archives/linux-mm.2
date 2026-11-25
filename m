Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23240606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EQ6L+uHU
Received: by kanga.kvack.org (Postfix)
	id 3987D6B09A3; Wed, 25 Nov 2026 05:31:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 349596B09A4; Wed, 25 Nov 2026 05:31:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2109C6B09A5; Wed, 25 Nov 2026 05:31:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF1F36B09A3
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:31:13 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8B588160D52
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:31:13 +0000 (UTC)
X-FDA: 85473274026.04.0987704
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id C5BF2140006
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:31:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EQ6L+uHU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795602672;
	b=muXDi97jK6URKNIFPoLZH106c5Y6xoAKyMlJo233s5Zt3Mz3iBe1IfAZHa4ecnYDNq+F4w
	vcWco8P8WpXW10X1Ay22DryFze8CB9A3JPP0Wn1caL2xp2qP5NhgYlDnMHwWjnacNgZ0wm
	ICVL7q1HU/FPdQsp4iZx2WzlEak1TLo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795602671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fDmos8Vna2SN/uNWyI2u7cpxgaVth0M1BKouMEUDkY0=;
	b=EZ8efcC/WZYV8fv1sZnr+DmzhsZOmISufD8G6r1S3ZuwlwjTfyuDVcZkYYRVe8Kwl1lQ9u
	LpvaMNhECKzpFCa5+V6Zcl63GFRfkJaUS4kLRIIaOtAgcJK5maf4pqT0Y/fn/9GbIjs+Ep
	Z5u1cMA6+glCsFtPrb2rqttdxv67Etk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EQ6L+uHU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EF35140F04;
	Wed, 25 Nov 2026 10:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9DD1F000EC;
	Wed, 25 Nov 2026 10:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795602670;
	bh=fDmos8Vna2SN/uNWyI2u7cpxgaVth0M1BKouMEUDkY0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=EQ6L+uHUmjexoUrsV8WJNJv0NDxdt9hlsXM5FujgrvKem2xH1SjtDMUjR71QA6zrk
	 FvzaejGEncx87/TmZrfEHFoi6KHCtHwf/TtgNlW6ZLHrJW7Lz705cBDxGRlzsVJ+se
	 LgFEJUl+nD2oEKOOAn8BtjMUfqqrscUl+hqVxfgEyT/5u5OTIV1gq8K9AoUIB3GLbH
	 bWJkb0QViqnahkP1pZfAfgaq/FCEZ4ML+4wpf/eo6ybzWD4Eq+/pM+n43VmXrlNnAQ
	 SRSvQHm/BGdkL/6RCZ55Oe4d4CZnelXmGQnIaIgAfsCC6cAaG0iBqgcRiy4jVDkhcN
	 vX6ffd38sGjSA==
From: David Hildenbrand <david@kernel.org>
To: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Heiko Carstens <hca@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Miklos Szeredi <miklos@szeredi.hu>, Joanne Koong <joannelkoong@gmail.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org, 
 Chris Mason <mason@kernel.org>, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 Chris Down <chris@chrisdown.name>
In-Reply-To: <20261124-migrate_reclaim_deadlock-v2-0-03cc147e1e36@kernel.org>
References: <20261124-migrate_reclaim_deadlock-v2-0-03cc147e1e36@kernel.org>
Subject: Re: [PATCH v2 0/2] mm: fix deadlock on the folio lock when
 migrating and splitting folios
Message-Id: <179560265875.4197.7576246208223051275.b4-ty@b4>
Date: Wed, 25 Nov 2026 11:30:58 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: C5BF2140006
X-Stat-Signature: ksikapij4oeaexfycsfzixhk76gpfmcn
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795602671-171972
X-HE-Meta: U2FsdGVkX18Gym46xwaWob8Qn4+9Glp7DoaIBNltNG8BrQoIj84CQzL2QogQDMRhGvrGqGcHK4aaSatmawYZQ0fBtPTu8QDf85wLVEzuCERFGpJ9ayL2ynbZWmL09ET4Yo6/o/MfZzx/92z+ecYPP5uAlSCU962iaCvlpykcPCi7SBgz2q9rZRBiX+6Dyy2V9RbphzffGVHYhK/Nodue4JW3V9rVmh/bnAC/l+aI+MnHfg7Ysy/KyBqQLbbOsF4mvj3LRat1nIintcHp8I/4gjX/QglFRfD+lTgT0dnS/NK/j6erRTtnBmfT3Pm7U+qAHq0lqiwXbDvY8xL+qSK5OitQ0B1QXwlpxsioTRnP1OnJuvImhLjt66EFF5YtbYldtrCIrfLfhNO1QI9kLzHtbQg8vSTy2Ef65zVg/IX1qsifhW8tfxRCdQyyjHMH9BkmE14GuSZxGQYFhSmQFCugqXKyA2bszGAyBlwIwPUAG5cbcS7iFYFPcHEQobqNTMldQ0igA8QvTmEyXX1mdY1xPOmQmy6HQk2p4xkzhQmJzWhed5OyGwaKTzBdDPgaPEKXFvwVae4JA59hU1CTMKrAmPOBsbJlxQ3L9eqdhO025sIN9q9zloPPDXKq7OEA3nV6KmYr1eMVSST614sMkdU0Q1Mw1G6JP1H0YoXonPg6w6dQjPWEOgaKh8L06QGA4PMpL/se3dFTFaWU4962djoTS6zNCYISO1XYBQG5TMBaRcynWEz6YEYw0NZDoex/+m+DWPyS38Oxh8yb+xT9t1fDOIm8XaascCT6wPO0Oec7QQStYAOudz9s8uWO95BwWWHKixzdQxKoEYPfFoDWP6qU4NwrqsYkh2wMNjoYIG5TdRxU+jlScukLq7Q4nTeuyQHSvJIvLPZKCEKMUd+09i8lNBCEG/7OiVSCpieHAjgrgoA6Zoqs7uEBOHKGeOvHqRibcnnuzHdpSNQOgADMtk/
 FKuvoAbj
 UWmRkLWHtlERMls9LLhAC4VTs7rLIux/xEGlhhHH1PDJKZLQcv/Paormflitu+Ia2pYSxaElrMH28+WSc8HU0laCbYygG54j8uZQdzomf64bIICAeN+iJriKqhp4CGkuys2RITUk4waBsljMcNNXYk5a1r1xez9FWKqZuaDbqRCKnmGSa102ahLVzzxMpquKuxfunpdn0WT+LFLuKm8RRb5DoIbLb+U9XsbRKTFAGdVfPInPSgqK35yiHZgR8fxfLRkR9JKHzvbyU3foVOnnbHu4Illk2ZCjqC71oloYDlJS2Jxb+Mt6qxflfpCCoOJ03QywC0de5FxoRSyd1rIBbJeC4kI7R+MqA38df6G94k7lrpjaOlNsn9oIn+MgQKGuQM859zdoxvX/mIiNT9k2/Te/zE49Z2v6A38kwfjgHGTnMuqoyWcHlymuc01YPr7SOV56i5OTTZnJ2KhzZDVGpFuwiPk1rl6wye1QAZ3jG9Nx0fjOpjIocZ1K1hwcURRhPEnFAFdktd5JYmqPdqrKgzqEkhmadCze9R++/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 24 Nov 2026 08:56:42 +0100, David Hildenbrand (Arm) wrote:
> Whenever we allocate memory with __GFP_FS while holding folio locks, we
> can deadlock on the folio lock when triggering direct reclaim or
> compaction.
> 
> For example, evicting inodes with a populated page cache takes folio
> locks, and if we happen to need one of the folio locks we already hold,
> we'll deadlock.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: for-next-fixes

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/2] mm/huge_memory: use NOFS when allocating while splitting folios
      https://git.kernel.org/mm/core/c/b4f63023
[2/2] mm/migrate: allocate destination folios before locking a batch
      https://git.kernel.org/mm/core/c/51fdc28d

-- 
Cheers,

David


