Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE1E0606A327
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y8DeQ3DH
Received: by kanga.kvack.org (Postfix)
	id 99C0D6B05B3; Mon,  2 Nov 2026 20:39:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94CAC6B05B9; Mon,  2 Nov 2026 20:39:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 862006B05BA; Mon,  2 Nov 2026 20:39:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5450D6B05B3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:39:25 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99405C0279
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:39:24 +0000 (UTC)
X-FDA: 85392100248.10.8645B53
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 05A80C000A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:39:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y8DeQ3DH;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793669963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AFhkbJPMzn5U9k5NLHoploMNUzWmmmhDgm1FP2cMeac=;
	b=wL1jFOS+c1oreOGojyzNHhmRILl1P2u7rKvTQB32jtR7WkQTtjh9+WxtNN7a/4E2nZTqH3
	CJtzNaZMsouRf7LLeDlCsNEcAHr5hVFMUsJp8jYXIQupCXNdQxn7RJI3ki6+Vn8ZLJm6bX
	B29HNEOPx0znTmGAnOoflPnv73Og14A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793669963;
	b=aEZGB2IlltWvAMq3hzaBLeTraL8vzhjAfHXw7G2224W3BA7/sSQjNm1anMPVhr5WgENnAG
	NiCuDEtZ4b3p07RI3qVKlMyxT6MznHym3Jr0WzWnaVJL2+Lgl5l2TjLZjAt0lmsoNr+I99
	wHiijUqs8AaJojW9OxSogpxJp9PqwDg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y8DeQ3DH;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3875F40BE6;
	Tue,  3 Nov 2026 01:39:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A71C1F00A18;
	Tue,  3 Nov 2026 01:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793669962;
	bh=AFhkbJPMzn5U9k5NLHoploMNUzWmmmhDgm1FP2cMeac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y8DeQ3DHSvYrvKtriFUEeRYjSPgOO/QlouSPNS3ne5GLpGJUyJEvl1fcxUznYmYcX
	 45Ca8tDqNRewgAzscy1SFy/9APiDbUBtCZHjDClrk+okuAVmlGctKzNMp0uM8ecjPF
	 JKMAkZcL2kh6EUyYuD6Q1UjilWNxuTDMFNErEdjm97qM+ojbhnzZLtlQ2b6mypcFjW
	 Bo4jvWkP0wlpX+hiu6/FfrbJ9+HyktJkyF1xaDBdi871mmwZfJLPU7wgWOeP9s6A3M
	 Qw+CvUecPD4Hz9YqutaebRYHeGozC4yXGmmfV9PLKpFnIBKEm8WcukjORQnIZjrPZZ
	 F44DlQzLSmlCg==
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
Subject: Re: [PATCH 3/8] mm: remove clear_page_dirty_for_io()
Date: Mon,  2 Nov 2026 17:39:13 -0800
Message-ID: <20261103013914.94354-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102-page-wrappers-v1-3-e7280bdb31f6@columbia.edu>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: rxtgb17kewtjbap54rkpqbc4dkf8ho7s
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 05A80C000A
X-Rspam-User: 
X-HE-Tag: 1793669962-928120
X-HE-Meta: U2FsdGVkX1/bYjnA49s3x6P2/Ajbss0SD9A+FHHABQ0KmlG5CzP/ER2SZvrZabfxAMvAQVcxl/wE411RxzoqxAsl3QSzyPiCE0oz+pj8DI4InuIk8xqO5rqS8UgG1y8bLsI0IS19ms0L819cOuESPA7K6U2rvDmsDlyYtOXpPfo0bk+KMc/vCRGIK3ivKSLvhzFaQZZzX4D4Ydi1BwoOV/AzX1UzwhIIVsLG2BTRsSSi9FvxCxcAMVv3ze1qe+nLZwjuMvNkkDfypxY1uG2nq6jA2X4zxOD2MSZfE5wfzYEVAscehrryxQGXyw6XYWbQ3zyG1Z9ajkGEpHQScOcTdDY6maFVVqmsAGHItopAU/7gGXob+Jn99uLgUzprd000Upm9sWtKj1E3HIINWiZgbypgUms0oytpspj7siCJrZYOZiu5Vm4uTx2/Pw8pfsmXRp8H07Cm5MkNxA+Ia9lb75eSEOWUJW3Y2ePIl9eMasqh2ONuddf89GUAv83i9dhiMvLRZ3dUqmy8m6nPRm0BxnX+/tAI/Tmogdx85QjpNDkjoWj8MHY5wifP2JNWrhFfYyPWSLZ9N93P27U9rzXtrh15iV9kf/yz4iJ6MDUoNuALfAD7VnOvhWGpumxIx23sIhonk9ymb6tWMZlqk1XKBZqtBn9TM5zugN8yHxJhxz9mrXaZXTiwI60GHi+LzKTYvKfosbAIXAUfg+BveOuWgMzPh31Hc/bitNC0yb0JYwlZ+QysrpTYY+jVBzBypUB0uqncMEhH4OEYKJvdSvigA7NzQdP1WT2Ue63jrxxwz2n+Y3hXu7zHkXIbZs9wJtTZG3PK6xHD8lEj1T9Ipm3c5LnS4qeEGPD56oH99HAYmao4coEZHIb77eERGltov267WZTlWt2hJ1tkxuVdue0ZyqQxLYSdberOqlrktIQTFgpIc09WPGir1OIP0zTVPEFD2VsYhJPCct9rxEov4KB
 NmfWYuHX
 UGzDdvNSQc5KXVLlrFZRFNtvz8beWZrd7R+FIvHAS1U7EoMg5r5as+qyd5R24xF7z4fy47l0JUNAiilp3m462SlvBmwoYG+nLwugHz/LiB5GHFG4XSzjRCSQTG9ihJxacotrC+v+r20IJ3VStgM7FULg41H+PVJVALSfrVfQBalcrkDQNG6oWN3mCFSkHfoRb9ZXCSbnSsidxj1+CT+UqTqrEXfJUGkHgPQKBBuWt2wjjdb80Hrb1zGqnygKegB23q4vhyLay2XgIZoN2lBd/KInfgJRgDDP1cRK+uqc0Ecw1bRP4YwoPOr005CRoJ60l1Tnv4kIC51AAUqZC9Hzdkd9ryw3nR9PnVZwKtJX3ZOtWt7w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 02 Nov 2026 17:54:08 -0500 Tal Zussman <tz2294@columbia.edu> wrote:

> There are no callers left. Point the comments that named it at
> folio_clear_dirty_for_io() instead.

Looks good to me.

> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

