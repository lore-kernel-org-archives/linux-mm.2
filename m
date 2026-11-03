Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FEFF606A326
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l42pQxJz
Received: by kanga.kvack.org (Postfix)
	id 9ED336B05B2; Mon,  2 Nov 2026 20:40:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C3626B05B4; Mon,  2 Nov 2026 20:40:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D93D6B05B9; Mon,  2 Nov 2026 20:40:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 736116B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:40:37 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EC5C9A030B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:40:36 +0000 (UTC)
X-FDA: 85392103272.22.4EBC0E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 48E48180007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:40:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l42pQxJz;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793670035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lxuID3na6jcmaf0INynZ+Nu/ftUjIft6QCqWcvBvJ9M=;
	b=eaN1VmEYGSJc5uHE4oUTmQdfKfVRFoYHz05E3WmeMcszvFNIak+GjR4PGyAsruEGg0rimb
	+DwnCy0PPsg613JM7Hxt937wSr2pVCB973L3Wom6h5jriCKg2WDpZ2hVPVOyrXB2tdwi52
	MW5pd7dPDvYmAW+WTLkZpudDa/oVwFc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l42pQxJz;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793670035;
	b=G5TKvJXyHHAKaP8NkfUDgznEel4rhxeD09cCYSKmdG/OntJrQOWCRMj6r+6g3r0A+AW7H4
	sr1NQ8jz93Llr/iKf+VPZu3hj+229MjCahEw9G+ZW5d3I1zbvOAG1CCOcdMcwuqXk7m16I
	e1ChwabrxWl4MH+AueFgXy5nIXC0kas=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 74DDE41FA5;
	Tue,  3 Nov 2026 01:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73AA71F000C1;
	Tue,  3 Nov 2026 01:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793670034;
	bh=lxuID3na6jcmaf0INynZ+Nu/ftUjIft6QCqWcvBvJ9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l42pQxJz/NJJJUj2WioihB+JwaAfF2N2Hieh4EES7cYxp8Ln66AXn++rXYnKtdJKE
	 Rg76+im2/hjoX+ffyqCJEfg3Q36qPlLm0IAgV8msk5mun211Mj2r5INr8738kGZqur
	 8xSsxROemxzi5pvr/Jaa9y8A71xX6QSHQbwxXx3iVTqt0FPkVd7+CKXHmJksp1MSYX
	 Wk7lADe1T+lHKAHr4/GORNV7KnXLNt2vq7JJRukMu3yPAsy6U2Ut+nINKncBGIDVfc
	 emsMAB2YDIJgSsfVjlVNR/aAh6AbJzQLxhmCBbJhyG+Mp1h1yL057JEsepD3Db1QvD
	 q0MRWdbEGdaww==
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
Subject: Re: [PATCH 4/8] mm: remove attach_page_private() and detach_page_private()
Date: Mon,  2 Nov 2026 17:40:25 -0800
Message-ID: <20261103014026.94537-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102-page-wrappers-v1-4-e7280bdb31f6@columbia.edu>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: t6diyzjm648x15zcbof8nd4j4cftswge
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 48E48180007
X-HE-Tag: 1793670035-434212
X-HE-Meta: U2FsdGVkX1+20Sb5+mayFHmg1QUp2ED5hZCSNUbSokPxI1SMYHeq0r5MEoQYQaMMuUfcMeB/Nelibas8AihYc46m4pt9evnqZw8qvM+4OpcoH0oUInrPRmKNm/ex/Wyk71HMOtcDU8hYRWFgjdjEtlRdIcVe2ba38egpQ1Mj0Ur8Xl55IoHabrtULhudSOrVwV+8vTOHAWfAgZFhdaSYrRbc9Jabx5FkapYj03FPiNSBAVpHx9lCgIPuyRox+5DPS0lzdQSUJzU+haeALQI8RcDEXknUA70c0iawex+3ULGELTmDnNldWZdoG95rLTO+HTNWRejq2Dwogi+Dsa80zO12yIPxpSdCuGIyM69i3n9JRFtxi8N28YwTb6zL7L95e1Ize7VllBPMt8qEj/1EAt3J/3Qzphhks7zTFv5XQRoxoGb9hwQnInldjXDaIJJfOQ9p6gVtRj6i87S9EItROdZWdHzeXid+x1HJG7uRmT95/3fgBuK4ReF3ODOsvojS9XIQiyX3/5d6WgPn5DNhbsJlt1hJ0pbJZIlOXz+zweCYfkGGeMteg2NMPOgePW+LM8jJAOkPS3oG8ieMZbNxG51LTPhGtvLhCVzxTz+B7Uo+N5g22dxeARX96XN/IkkFwjg1Or/EqCtV/5BInxhkwr8SA5sIGTmM53wbOkpIq/CXO31fuUGKaZGYUmk0+SqJ/PkTKE9r/4lywe6X7AF1sJb8FlY/hwFDcgmGnwuPnPPnELmzVi2BQHVmQrzu+U6PB+4bD3FOpGGS6WsRE3mJ3V0FBLXpM0oVrfX31HwK2UjAa5Lg17Sz7iAanCCusAeXLSz+QcEgqVxUzGeClGemoupFHwxZp3Pyi97PXw0EX6aHRMfHuPJ2xY0wl9j7nOu54gZTworZ0EuNSS+3SxjPuQsz71jspkWFiSJZ/8V0kBZpAKCHo+65V8WM9DexEyfsEigWHopVpAJYpYS0nC9
 HhigWXiK
 PNQ6QPvvxvEOBF1JxP33LsXshvQPJsWlZKKijGhZYVJeXC/15HbGMGYTj3+QzRsaT4tzVuIYQsV5TWLRP3w5jjoPE8fSTI/7yWNyKBi6INjStwIMeNsJmjP3Fo5d7qFOnlkanEqKchrDFYoQqYO0+fK3lNIdDmr/e7iQAru0jaqSzIT/oWm/G1ikYdXavtnYmMD48A3wDA5rCvjvwRWAa+EXzM46B6KzG0h+s94tf8imq74H5DAdSyJy+nSLg+B5l4vwoZ/Y7e3zlvXQmQHDx/vkELWoJAZRfig59iBLbKORMmv+2wcE92mnwgLOb1glDvvbOwXF8CG3IYRPCLPs/4qHkPBT8RGXa0dU8jQCULFqyrUE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 02 Nov 2026 17:54:09 -0500 Tal Zussman <tz2294@columbia.edu> wrote:

> There are no callers left of either wrapper. Remove them.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

