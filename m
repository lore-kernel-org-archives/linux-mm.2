Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F287606A32D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kLHAsFVr
Received: by kanga.kvack.org (Postfix)
	id 7C1F66B00EF; Mon,  2 Nov 2026 20:36:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 798C16B05B7; Mon,  2 Nov 2026 20:36:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AF346B05B9; Mon,  2 Nov 2026 20:36:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A8BC6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:36:41 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D691A1C2712
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:36:40 +0000 (UTC)
X-FDA: 85392093360.07.F64DF69
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 417DC40005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:36:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kLHAsFVr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793669799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y46+NJ5aqAHpCrKu6VjLDpm+yebJcad5AzOl3gzfzyk=;
	b=n2prIx48aGIBc7hHGSENWJmOXEs8+LKYzTaIG7NMTpCi+0RE+YFs1nnfpbDUFa1vc9Hdwu
	mJjAtSz8ZH1jx6xG7QQQ9eXjAi4xhd9v7AGr7IXIt+szXmU0DJTRpbfGS3hx8skJvDAgNl
	oi2vzaHMZYUSizo46Y9bYrsjqmTupoc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kLHAsFVr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793669799;
	b=z6/uPqqiF0jVfsSQvQ6lHNnKd6OCv12kzy67/PDwcEVC6bxX/t8Hxjfr3hAqn38YOY3GvZ
	n4e0A9piMlV3T2Niptmb9WPtq83DuYkejkPAUaYzMa2thZ/5d5827HrNSEb0zWF4cd9b0G
	dkEKbMw541OMv5Y/DSHRuem2mFFrfZo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 60EF143B22;
	Tue,  3 Nov 2026 01:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5964C1F000C1;
	Tue,  3 Nov 2026 01:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793669798;
	bh=y46+NJ5aqAHpCrKu6VjLDpm+yebJcad5AzOl3gzfzyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kLHAsFVru9ldiCUzwG8pcEIm685zZg5oPrTwKMzUyM60f2CKmLCvXyCfCD+PhWfyX
	 raK/9se8VbJvZy93e+TrAiYYxLvI9wsoDk10fran98JIXZvNChsmpPaXOf50B4qkuL
	 rDIq+NRyq0r+Ky7r9RiZjF6Wb9IYL8RGDnhP4OEicrdtr+PsKcX5L6Oy3cuxuDZJd1
	 XsH+WOWwUM+/VWye+3AUnK7/GSQrUWbQoXl+J/CaRs6gQx+Rf02HRkyJJV6mZpOhjQ
	 TXeDdeNUZFY+rBVzBF+H8d0QVd2LtTB9t/CbMSVa3tW6lCOYMPPr3oVRNUD/Rx1tnG
	 yJXp6nZtlKxFQ==
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
Subject: Re: [PATCH 2/8] mm: remove end_page_writeback()
Date: Mon,  2 Nov 2026 17:36:29 -0800
Message-ID: <20261103013630.94182-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102-page-wrappers-v1-2-e7280bdb31f6@columbia.edu>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 417DC40005
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: f1gkuotzzmgyi4o8bnnbaxbw4ojgcypu
X-HE-Tag: 1793669799-446146
X-HE-Meta: U2FsdGVkX19n3x5JIKk4APp7pKt4yNR46lKzL4ZceKzzlPFPo9KiLst45+MXTNPEAN74wBU5QYxjja8GKRDfVjAijhm6rbgI5nSI5oOh7f0suzoox9k4o87Zm5B1cCD39tmo/uAo8BiSZCSVezunvqE7Mb3HKOIjvtjOKF5Z2m0SiVjILW44ocTi0PNdMboSmBUETjx3IqqiAToQ8p2QMGx3rK5zaoeosefn6nae1cKWGYe0Lh+lN2D3mxLVy5qpHIqkkEJ6Q8BjzfI/BpIvc4EGCyc29r1sucZBonpia0wkcUv9tNnlmw1EO0MuP1e5zSMuhe/TCE5KSGpJnXgDeL2brFXva1Y6Q9Bf74Pg01WGo1OGfd6HlrGcz761HfZy8QbOUSo9Og9DB0IWgYdnSB29W1LfZEGkSzCqTigZnSP+czuswKiPXBENSfOYExsqhM/2C4psSGri+msLuWzkON05MxOzI46a6FMgMFKti1Vpnkrg2CmbkuIVs8Vem4R/faPzlkf3m1tOxCzvuRFxqQMO8yY/CJHq+k0WeHvrMnksmDgQkGSAeJqQ3azNMFL1FKep2qOIep9/Sybt9ttm0A35X1Nl50GL8uDVCxwWbNKtMoggWZgX0LukXDNCwraJfJlTrWz+Bw2z2CCRupE9lxYxfDLqgrWGpNPeBayNurbs2kIJ+9zNcjquYbIjgzCxTsteAmnrJr2tK81Vj+eRd/hJh20WlXRiFkbcdo5s+arYBoL2NCOAk+VTZgIAGLLI7eITIjGzMMYIUFI7sv5pKPaoHssOvLHWrkpT3nTsLjUMz/ifoeKSIwQ5qRco5N83/s8cj9V3pYrLRr3k86jIogVX/AXtfxs0wpDpDM44o7OmrnFmMc2qu9OOMgllU2Hc+x+ZNfqGFSkFBxJlr8eCB+EsrcbRXgmakaApA3+v2YakoAS7BTo6dfSomxj/A3KoG1iVY1+8M14yDgGVUZq
 TkhaFTUQ
 KeN+2D8meHcX0dDKXoM3xzm2hLRMQFD0/pb3tExMdvSoeTZpSuWuGIik+p2k9sfHZ2g7loiAkyELCe+ywcm7pcfoNyDno8AdCVB0W1lE1kzJo8HAU7qo150yD8XXbpzNHghMMj4YaU53Whn0ys6NwiQIQ+eDGuZdw7kUtpJAN/63kpUb125eCufFVKKKtf4agrIEvLBI4nv6BtK8dRI6DluIwCupOHiy/oXFNsIUmDaSX34HpuhKbs4dFDycXNS0Kt/uK6rAMOghiWTohHxkEUyCFzeb2J+gh77eEkT5+t/6Fgn57IEiSIVj33OVkEopudMFA6xJNZ3MGFuMelXvH4a005nBOF5y9CaO9wdByXiOUIA4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 02 Nov 2026 17:54:07 -0500 Tal Zussman <tz2294@columbia.edu> wrote:

> There are no callers left. Update the two comments that still named
> it to refer to folio_end_writeback().

Makes sense to me.

> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

