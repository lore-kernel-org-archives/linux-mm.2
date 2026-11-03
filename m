Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B658A606A331
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F3yly/uT
Received: by kanga.kvack.org (Postfix)
	id BC5A86B05B9; Mon,  2 Nov 2026 20:43:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B76A06B05BA; Mon,  2 Nov 2026 20:43:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3F556B05BB; Mon,  2 Nov 2026 20:43:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E5096B05B9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:43:46 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7F5B680248
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:43:45 +0000 (UTC)
X-FDA: 85392111210.16.3777224
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id E5EC7180003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:43:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="F3yly/uT";
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793670224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4kniJNifKCcuuGOg4oonNj+llyeJgvvjLzYbyLbb6wM=;
	b=XfKDxK1cYr1kpaOZHpAfbAdHt3Aupg0hXMTZCIYvLMlREEy6KObPr+teWyBwYtdXsQz60O
	cvb8UtMpyJPSwJy+gSEdaiEzAn+9UKUH6LCEhi5qTETvetLXSUzav3R8DWGqIQimD61ftC
	6wHKMbCEzbq1v9rkHoauvYtA217kVbY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793670224;
	b=3pLYwsDPyTIrrR88KOM5l4R/qk0Gi4fgr1XmfXJDR/Wnjb8Ex7hvG7+LDI+XErCx6eBeDJ
	cul7t3aRL6lj4moi8oUjitVx1hch/EqYqPhfIpFVbKNKqpagvM3OIG4srk1b6JeEH4ybKc
	wi1jhQmMo0/Aj07LIMPU7RgeTO4IL0g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="F3yly/uT";
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1CF4840769;
	Tue,  3 Nov 2026 01:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE1C1F000C1;
	Tue,  3 Nov 2026 01:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793670223;
	bh=4kniJNifKCcuuGOg4oonNj+llyeJgvvjLzYbyLbb6wM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F3yly/uT4qmFRgXh1ssn5lW3nMStihnIt1vuNOiyH/h1wLmci+mZmNQPnPKu1y9ML
	 tOlNk2GfCS7IEHxT9jmQzA0sAqBfbZEht4LYUZxABS3IkMhvqzqyAPBK3qfKT+K3iT
	 HHrKvYbLvX+9Pv2DhN5XHkzhow6YuiMoK7FuRbn1lmyoq+czheusOll0aQXuHki13P
	 4NwJirF2GEYOLHRALbT85GFMiTAS+0EJrfaWyZUpV7rG+VCO8m8ZXIqFoQ5ZWIwcHz
	 rnPTDRQNHBagZhjBB6O2QGy8KJHEDyCALkex//7zVRZvykjkCpKVqaeRPUCwsOtkia
	 ux9vyx/UbUd/Q==
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
Subject: Re: [PATCH 6/8] mm: remove find_lock_page()
Date: Mon,  2 Nov 2026 17:43:34 -0800
Message-ID: <20261103014335.94889-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102-page-wrappers-v1-6-e7280bdb31f6@columbia.edu>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 5p5yezbta99j7poy5764h5z3d5q7x5jw
X-Rspamd-Queue-Id: E5EC7180003
X-Rspam-User: 
X-HE-Tag: 1793670223-709400
X-HE-Meta: U2FsdGVkX1/KqGNFhWxjJ0vhMBxhQt3NBcJZVaW6wXe+SKYRzUPg79XRpYt2HLhm+EskadlqiKDHZf6+ou3cDTV1xunQjSMoHuGXjGEOySKgpDlESvHEjV49yhhoaLv1IZfVP4OjCEfeUjm/iSiVmLOMOEDlvRtHiwEdquYR6R76DxqK5XYU7JUgy+TtYO6TMF9B4n2l9F7LCxX45MKpaIbqVlkijrI4ZTzxPtjN6yzBT30t1WqzYp0xBZAk42XkiO/eeoufGraSsnM6jkrfuDGgF94vGMiM903tv7Kg/D4+kMuwx1mwAxWc3H8/kXuoLkcbkghthW4vYYWfw2lcBTzex/NS9P4fyp9PHB+D6LjRM2cUL0S8slbwH5BL7BsMALCOZ/Yva6FHvUIKramdj19cx78YE4XkjDzM6yrbV8NvNO/qXp9CjxVlir2sjvMRLmWpgW17UTL6rPjHdCZ1s+zTUw32LhIQoR6XHkhACl2tTWJdSjh6eP1vG7fx9HV72mTcvCBqmfcrJf6aLX3S7KJblpZNgb+5kJnUhk9wymsJkKTwATVvlJ5zv2+lELBjJYME+lvjGCSjPSk284Qh9phC0JbW7Cg54zTtZCePRSrosngu01ANxTgbMZVWTtTX4tmsW5yuh05zXj/BaD2/bl8dX/l4ZWWmTjrmryAmzdanR6nkNaUmhsviN2ZpmVxQvk4wp1isVsRzv/Ghq9UI+UhGrF6ut9NlInHwOnTcEw+IkOYITpMQINsuGf5J/FMXwA0OtB5EnAyVQeWgJSwHyCFuf13ztNWAk4GikOLHIYwomoL/L8nlOdfzChIN292nyCZMEKlYSxS2bU5IhVZUS41P39uO8h9kHEKSdgkOY+2wWKxYgERP/yjlVZurN5LOzYwAGfhwKFYLW0ja5GC97wGraaxdIg63F4SPhPEUfLmj4slTx4VDQiK5AFoimjmxduu83KF0pgy6hl/F3RQ
 WQ9DFsA6
 sl11oGse4OD9GJoSgwguKtJW1pvZ5keYAWpguezooFRkvdDSed7AFz5XuLaL1+hgl6wrmfHYgVqeC3ZTIiVnH33I9Z0GTdNKnDUMPgTkKE7KC0Qn0Vi8ptm3VpWws6PiqSMDP+yaRxUfbqrU9wWSLuRZd1YcAJS+vAxa2LwY8OoqmMvSEBJh108Y4SynTOdGYqiDOE+9u3BUp6IzLulDhjRaThXYV3Cw0YXeyIULtjNpLDqEFgc1HPVCwuXYk80pNoFcCioj02Clk5GISNxJ+SvScwIAphET60554LKR6pLB6zX646Pi0Y+94gShpwwaBmR9ilbtZdgAroM120sxe7k0n8Fa1FANHCMTkpHqMsQ1mEos=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 02 Nov 2026 17:54:11 -0500 Tal Zussman <tz2294@columbia.edu> wrote:

> There are no callers left. Remove it. The name still appears in a
> sample function graph trace in Documentation/trace/ftrace.rst, which
> is recorded output and is left as it is.

Makes sense to me, the example could be updated later in my opinion.

> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

