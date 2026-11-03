Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C3BA606A32C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dpcXJpf3
Received: by kanga.kvack.org (Postfix)
	id 514206B05B2; Mon,  2 Nov 2026 20:45:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C4206B05B3; Mon,  2 Nov 2026 20:45:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B6AA6B05B4; Mon,  2 Nov 2026 20:45:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 16F356B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:45:54 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A11B880248
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:45:53 +0000 (UTC)
X-FDA: 85392116586.21.718C291
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 16DFC180006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:45:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dpcXJpf3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793670352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BbaPiTL6H4WZ6GFGaPfwscrQ5Ch3cEIZJw2AtO0Rfzg=;
	b=aLpNr7ahWacBmrk1RYDpIX3w62wW+9Ckq4fk8y0xB/Yn5kM8GXDF6wdvLKExA6D4HbuV1P
	0BhcKgt+hQRtc/rml6O4Mrff//KgovWfodAPhVEVeEUxbQ0dV/BvLkt7zDcP7QdFhcvBcC
	PLFOVcEIgKDcS2mxttv1qaizLaTGZ1c=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dpcXJpf3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793670352;
	b=1DPG5F9leYAVS7KQBqFaBgTGTRmIZNNbpfsRakLHl5wcFPKXEhNNPPFBqj6vlNtH/F0ZsZ
	dC8AJ6+3JoQgwxxuB61mhqrPZHkdDMxFsUGXW6dPrDcow9Kw/cvzsXgNWstS51G1F/7iV4
	VivZ6wd3kJ8SK8BYZRNNPBYdSsIdiDA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E88E6020A;
	Tue,  3 Nov 2026 01:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658D91F000C1;
	Tue,  3 Nov 2026 01:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793670351;
	bh=BbaPiTL6H4WZ6GFGaPfwscrQ5Ch3cEIZJw2AtO0Rfzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dpcXJpf3sD52gbowRF5to8CVEa3gg7C4pZ6ZzkTS+oYLeqnitL3DqyRwsZpvEi/4G
	 vBv154anEQfZac8igzhp52gFAzw+k5xqzjKlfXNKF0Jrx1qjCWBbKv4KMow3cbGA3g
	 4loLaeE474JG0TvLZqUjAMX7xLsJHnlwlAPlO+UKDFmzBgD7SX3of/zx/p8ETOA4NO
	 PqRXULOIGOEtaOGeJC+0H0rIg9Lif7yUfJOl6P6W5EID7iwrUd+rHVU130VVK6/Wjn
	 9ayoGPQ1CfNqGsxeS3ZLPpavW4wvUWdTGOt6fVjdEDiszIbp4nDwOIgF0oEdOYOk66
	 W9OjmsCymJJ6g==
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
Subject: Re: [PATCH 7/8] mm: remove read_cache_page_gfp()
Date: Mon,  2 Nov 2026 17:45:43 -0800
Message-ID: <20261103014543.95070-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102-page-wrappers-v1-7-e7280bdb31f6@columbia.edu>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 16DFC180006
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 6p8dgq8157y39ri4tdrex637sqqkna14
X-HE-Tag: 1793670351-867919
X-HE-Meta: U2FsdGVkX1/GSAacfuQybwKHt/Kees9X5SFsuNfGjWS7t/b7efTqqm3/sN3Uuc0KU32DFKIA9CDrjZM4+r3ih6ev2O5zh/BiuXxxk0HN48+fJ3KEE7Sf056EoDEPniuz1u/CBLczK1dUMJzrBFUhb9GIssW5OaKsP/3jZBnMqpDn9yx2DCiKI0vuAabzNW1HdeinZJlRNbREAD4FMqeR6a8tkBVBataBRIP/GJcoXKqEKtRaNiq6GiM7VT0EJ5zY960qvgA3C5w4Qorm1AK9uVlhLI4IYoSABbjprVZ9bnpx44ADZFvccisCVjFcM7/oHWONTzAcOE76qwuJMXajBsiYu3VD8GbW8b7SfUQ+vEByhXknrVgMY3rKFUTYS2Ns5aNxilLd2nhccs+UKKzSaHuO2/8o6hGUId3oPhleIeVyZfF7tUOg56To3hDTEFIM9oEJRWv2QkmKjSOrLkiGX3uvKcpYKvCcLoQd0WEmb9HqBntH/aLbywbNyN/PlQtdpcXuAHxaTIokOZT3emtuaX9JdhiccjQa8OzmOG2xdeH2mkWyDTQTv1r7FZZL4t6ibMR7O1oyS1FF8lPqlz8l08z3cI/XNFgMCu2tRJGLJ/uTb7zntG1YT4E/e0y3+3CnHFrzWr2OmfKhldw47kVydtePLksPwtROXR/orqtztb25csFb8oQ66tEfNLQzHBh6t0z7pHmdCmCnPVwKBWf4+F/eZyMLFmmhbwiJoITobeZ/ctiP1T/hG4SHbxO0MfLw8pRhHqYOpZ4Ns9Hu0wXfg2hLWCbJ+0ombenzazcACIiMpsYs4McNJ1eOx6dFik5uSov4aO19OBxgolku4ccgorVBtG3git37sX8rar4tbKq+z/5oCl27f7aAG+wAR1kgElFnlXXUSZHLZ2A+l3xwAcZDB9y52GeEiT1ruv96ijgUZhYd3cFTAV/k+YEipiDZsOAfdZ4j+6br6HP17O6
 w0XVtL9K
 EcKmv/ULXfhPU5nQLIJngpNtnGe3D954mAduB/mpYQ2B0I7gX29V+lOwO94C5Ku2mpXuW2injLSCk94N8y9V+WbN9wcseSUJf2syV1zcYz5eTEXO+orrQtDghhgid9mt1QrH5woAfxBT05+oFnDwPVQ4bcVcRxZlzOguDloN44iOoT8wC56vUBvdZQOH7+ZftjzYvfREKfxH6efUJWobkDj2Yxps28gAH/H9VYlNogjqWlIbe4b863FXKsTTuRMP/mbKy6Qdz5b6/QnDYvb68Dar26lIZ4WuILdaQ2mq3M/5Ezh0y1QOOnUOUYA3ExXoicy1s7COBoZ/TwMxMVoBhvdjLwHz4DceyZ+CI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 02 Nov 2026 17:54:12 -0500 Tal Zussman <tz2294@columbia.edu> wrote:

> There are no callers left. Point the comment on shmem_read_folio_gfp()
> at mapping_read_folio_gfp() instead.

Looks correct and good to me.

> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

