Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C87E606A326
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g4Q48gX3
Received: by kanga.kvack.org (Postfix)
	id 4F2AC6B05B4; Mon,  2 Nov 2026 20:48:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A22C6B05B5; Mon,  2 Nov 2026 20:48:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36A386B05B7; Mon,  2 Nov 2026 20:48:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0CC486B05B4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:48:24 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 98B0A4030C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:48:23 +0000 (UTC)
X-FDA: 85392122886.27.4712902
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 09AC280004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:48:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g4Q48gX3;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793670502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4J4SCqjjqhtgMVcCb5tIrEEKZXAGW5gdRwbOYNKvTbw=;
	b=mGRIxHNfqd83hnCP40creysTxBIixzEkH/r2GwVBDdOJIS037Knd8iR2jjJx1op5DRBEKq
	B/tBRkRU0v9pG6bu4Xu9DlPeQP/yae1nSmDE1OSYJ+96JKwtETfZfIquoEtLRVuj+ZngFx
	NaF7cUckWFoHozP8oabGDY+Uru//aqo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g4Q48gX3;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793670502;
	b=AOhD5zLXFxNlhC5+DGET3YTK+fWBr/MaodmrkFMt1b3/kQ3Kuw1Gr8DxuoN9zfuOvk4Lna
	1b+cCGb9TR81PLfu8BzD+O7NMlsHDXqvRHrN0+1owPe2UYa5qyGK1lGdTspIquxT0/bIk6
	rTiA7eAWPdApJ78EqCu42ZxVISx8S6w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3327640059;
	Tue,  3 Nov 2026 01:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3353B1F00A16;
	Tue,  3 Nov 2026 01:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793670501;
	bh=4J4SCqjjqhtgMVcCb5tIrEEKZXAGW5gdRwbOYNKvTbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g4Q48gX30SRkNPUGre+5dGkrJ24cinpNbozRWJmUXMl7z87k5wtfFeaH039EJxhTe
	 aaZXJsTlcmZ0ImrFxNKCW95BLooEnLm8QV7Fyse3ZqAFmSksFHdVNMlG4slV2jAul5
	 lfS6YfFsTAbcFRjhwWcIQE4mYcMXpcLNLeItP+4cEYup5qijComg/m3c2nxhqb1i7D
	 9ht6ELxs+5/qYxMYLZdeIHVIEXQAG3LKGCdbLtCKuHCupm8Bb5Pw8jgdHFM00H32pW
	 F6jqoiilzwUe+xbapP/DfZCUxG6uIBNm6hbCDQ2ETV0lVRwgR+WNo/Yj/7oblUSS1T
	 uY46x8C+IFenQ==
From: SJ Park <sj@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: SJ Park <sj@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] mm: remove thp_size() and thp_order()
Date: Mon,  2 Nov 2026 17:48:07 -0800
Message-ID: <20261103014808.95273-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102-page-wrappers-v1-8-e7280bdb31f6@columbia.edu>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: udhrriqmud6cfdbzd1hr87dwdnrb6c7t
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 09AC280004
X-HE-Tag: 1793670501-676783
X-HE-Meta: U2FsdGVkX1/oYFFrsSfI+hsA48CEx14Pq+z4JoNADHUMstSRuAfQF1VLkXqI+M5lzeodad/qhv7FurlmE4btvWGkWsmKLk/1Ry/qw1jNCNTDPdG02hnOU2283hTLmFzz0xZyKcQItQ9OOmkOrRGhSts+quvjloV+FN6J/oKJqS2jd7F31nRGjcM6NGvZnSJ7eSaoLiSXWZVIotlN3KMI4nFe//5qWswQqU8HlhMFOPvROeNL31S+jHo/+Hp7JZUj7bCMTXqZVqJ8zucDtUqrO6na2peVM8MkHNCGbD4cQEfGIEBAxYuevuRawEy5HpIkB6iq2asUn2WlwDLsOEZ2lx79jsEw9LdO3jWagxk7/wk+TuUkwVQFgbglp06b0F9fQeLub4PnOSyRMb5bt2XQ8nM8SSGqrjxASilvG1WjLWoaeq6+y1CU0+Fk+KZsVNWQBXXR+tBtjkfxXc4iMYvGYNF29+sDP+zeeTe1emsMCM1TdBerRcxxDtqd1jAMGvDQrG7RpepLWqZJQh/6/Q3RC910+DqAloODUt73THYeA4u7YRz2bVafeH7YfU86+xSBpmKvwlMFiUNAZGY1HCHI9pavE10XAnYiUAXSDqwBZuufvU5F/Q+VXNc8LPHj8BXzhK95HaADej2i7KwMgoPY0H1hm/1j6y+QTkwqM35fisMN5YqK2Hm+E1dwCDVlBX9wD/Cl5cu7gzWIqb8s0y6n8UOBHkkeKO723P87fyHntQtMc8+wHQ1hD3MV2DD6KED47G25Zmq77AGK69cZdh73aMhKg88jnlHs359NSDJEYMK49Yk+0CScGCNAM/eFq1t18lp/Gsy1e3/zn2c+IvmkeJ6OTf4gZ/lr6qb+isqGZx9uLvYnXFgIKUQEMtfqyLWvDK7awWZ1+rl+/BWLC9G7TqXINaoN2xIyoJixLBhjSkwr17586dvb4JyyVykEny+SBfkr2Z/NBL4452qQjyx
 ffwiV6yt
 rfqmeaOCKiRXO8jHLY6mMW7+cYvSRrGS/ptGYqesu0q6DHLUVzT83Zg+3IG08opWU3AMmeipA0B9SOj+o+btRgBzGhzJ4xp03xrdh4j4eh6oLaaimKqJPAs/nxuccqKFQceem3z8BCWc+bDha/sGN8reHgZ7gPJ3/NCC2lTb7iTrMJk6XdewKNEClebPVNQJ3kPpkp89nZc1E2pVBcyHv/ICKJQX35JYjqAJO9XH1+PwFdJkql4w+P6fLRMXIDzdL+ox9C6OEEXSmfIvf43d4goy5BOnt/a24qfelssL5zotj6GbdJ1rFJZBmx+J+MBm7AgykdMc3zZb6jX+17gowhfiAlJ6JdjHmWx8QKOX1wvpY/Eu008xKKlcVGHa4BF74yGMi99Zdti7lnP4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 02 Nov 2026 17:54:13 -0500 Tal Zussman <tz2294@columbia.edu> wrote:

> The last callers of thp_size() have been converted to folio_size(), and
> thp_order()'s only remaining user was thp_size() itself, so remove
> both.

Looks clean to me.

> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

