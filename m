Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 862E6606A32E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OuWOEBPE
Received: by kanga.kvack.org (Postfix)
	id A56086B05B1; Mon,  2 Nov 2026 20:35:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0D9B6B05B8; Mon,  2 Nov 2026 20:35:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91D9C6B05B9; Mon,  2 Nov 2026 20:35:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 744E06B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:35:00 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 059681C2712
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:35:00 +0000 (UTC)
X-FDA: 85392089160.11.FB93DB0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9162720008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:34:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OuWOEBPE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793669698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=56rap1o7worJIx5XKJcXXzxaY0FYuZMs60jrSq6DFxw=;
	b=MIMWpFu5WkCJXsXY43g+8azgg8n3j7KbAhhO28q3/K1qnajJzbZK/S0LLHHoIobmoWr7JG
	zyP4aDwGhZymd5LVc7p+pMTz/oA8h/kn7Zw+LzjES7sFVOmWhimpwAGlEFUKNYDNpv7aOc
	kKp2i5uurcFwWr66FE149kN+w/hIZyQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793669698;
	b=cbpoJKSrhyb5oEIT9rFXKI23SWna4A/CeHIPHZZVeZQavPoLEtiHKrr+k0FLn0XD46xJEb
	FjMjv4yHJGA7S7A51hKNpcyymMfPLBHdwZTuRaVkgdJ0gSO1nEoKeavFfsT3zPX4rUKwIr
	FxV1UmbJXAhjJwCxoWy4v8Jhwd6XVxQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OuWOEBPE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EE73760008;
	Tue,  3 Nov 2026 01:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29F11F000C1;
	Tue,  3 Nov 2026 01:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793669697;
	bh=56rap1o7worJIx5XKJcXXzxaY0FYuZMs60jrSq6DFxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OuWOEBPEQbnyxrnhhRefJZallXrO2CFILZlBkI/exfpF1YdIQaHjTBy8NgtrRcNv9
	 dlwMPJYGRhhadNj3olCdeIUMd3pEepnEGAkK3Sg9/k385MOStv3+y0tMa74pB6P33T
	 1PvcqV4nt/qb96eyavODI4qydUoRHT1yHv1/jmRcoACCaroPfGdJZAYgmzwTT17lwa
	 Ri/npoqchZfzYoGy9fziJf7Udljsa6F6ewwuPjKb8ZC9tN4k5ODq4qLZI1U1EkO9o7
	 TTBAuA9/aldvTzZOuwrSTv1rtaEeJGdR1/li/lYHwnkaYXfLnpns+V9yoUxxdPKG06
	 mXBbA8jRfHN/A==
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
Subject: Re: [PATCH 1/8] mm: remove wait_on_page_writeback()
Date: Mon,  2 Nov 2026 17:34:49 -0800
Message-ID: <20261103013449.93977-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102-page-wrappers-v1-1-e7280bdb31f6@columbia.edu>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: eksgqei65jef7e74oxf3qotp7j7u7abw
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9162720008
X-HE-Tag: 1793669699-392302
X-HE-Meta: U2FsdGVkX181GUvymSheSRU8mVZas3gl+MinViK118Bf4nDZ3/XPUHEINd2GnOs26Z13RjuS+wmVnsGH81WRaK1kQw81BowiZMjKh2vBlf96ejzWL9CKZMi3EXWwRSMD9trczyHS5M9GoWcXCr2ZQWiH1xGyM4l6l2VmfEecszzxsCztEJjcr865CTdRFrmN9YcVwjWFF77q6x4q+DkhcHvj33CacLiI08RSkPTGguhBZ5Y+mUXh+3jWo49sQWkVR+kGQsEnC8gX5j+5Leidl6l4gewf+WBA1RA7U9Vx4otJ3j0kOr/0S+wdTQBO9y8cbCDPN8fbpkXRhDTJFV8pSiX5EfHjKVZ1fifUsk0kZbizLJzHcDQ2bXdT5bZkmXUvkWUD7yMe3E1hTsF+Zn/yeSJY+tHne2cnOGTKfruQvFNaqKPuFuqWL90h6h7e9Ayl1LReFXsd6gI87trDcmRqc8mpFja+WHrVIQgpn2awOwiFuY+fFsPjVll1Q2oS9yBT7AHQBtsH15FHl3c8z+B0QxdukmWYR9V294mJ1fYgXGmg48fxj4J5/cUiCysc7vJlpNRzQEszEXRtbNXKWZeAUmv58AiBgxTpCqO3gwWB8YK+/ubpWqNh04mXH9/gMRnAlxQywFBmsrCA7QdJA1vbeyEKFnH1yMfEpegTuSsyZDX6J3XMi460/MDOvOb1fjsVyg9q5wEcrAR7OqN5z+dyok9g68B2SerIBzNoz0AGMCtMpim7+5gS3ka23YBrzSqSsUgXtXkq4el+6F6nPFkq208ApcOr6VIa64InY8I8GwV8SiHQ8Mzw+xPHFVrUXz0HSXwf0ACqulgDsSWnHnmYPCx3Az/cz80iBMe72Ayd5iVclh2AOqtdx7Idc1C5yhzKEPPGMTZQMOoVtXA08+jRAoeO+lPdYsvjJ1q9NjeM+C2cQnGzAwW6V9QcOBikIUSzBlkGdE9vqsfz4t9rIHW
 gpE3mFi1
 80b5Emghfjq3G1HMY1uyO732PoElx9eSLRcKIfwKJUci64X95NYmuKEgT7Q2fD76YhTxQZ/vkFOaF6e+6t8oBLc7L+K7rRwKOcRyjTiUwYzzZhPhjDNUdMqvVKVKOV0MCUr42SexDOz/IKJqP1LGnHj+dbtK56ejlaCMH0LT5xr62UUfr/+W7eEV8/nnm2ap7sLy3OB4RLjVHd6W8OqUIIf28k24pceojmGOHlkwWDw7G/2MtDZMaDHaBgpqlLQuMcW+fK3P/Uw217cF0NSSDCGNgO40cDy9u2thusbow74NZqw/e9SmhRfTyR75DYBp6MVnPlUgF5bwNvGARRMdEdvO7ka3/7K3J6QljZfewHiNsYrxxnrpNRpwbx/9dmBZwSVVI/FjW8UmxPR2pTg4FKlC2P9QMDUsYBC7H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 02 Nov 2026 17:54:06 -0500 Tal Zussman <tz2294@columbia.edu> wrote:

> The last caller was converted to folio_wait_writeback(), so drop the
> wait_on_page_writeback() compatibility wrapper and its declaration.

Makes sense to me.

> 
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

