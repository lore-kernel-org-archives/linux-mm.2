Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6508FCCF9F0
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 09:08:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE35F8E0087; Sat,  1 Nov 2025 05:08:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABB648E0068; Sat,  1 Nov 2025 05:08:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F7F38E0087; Sat,  1 Nov 2025 05:08:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8F4088E0068
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 05:08:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 258E114065E
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 09:08:41 +0000 (UTC)
X-FDA: 84061462842.02.5417C14
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf19.hostedemail.com (Postfix) with ESMTP id 743711A0007
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 09:08:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761988119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qgb7dK1Sx7krlD74iTDgqOZ/y+tMRNaQ9fTj1xEvsf0=;
	b=z6k92N2XSspthqElqpJAeqAc++znmOQklNt45K5+nDEAfeZ+ZIrIpH8ee4b+lDo8ZPm7u/
	WaamcdfxLjRhm8QM7AklYkcC02W6OapBHiHpbrWJ99MpCExbgdBCB/ATb1dGXZagw44fRs
	1X8sOdNYFYY1HhqZe8g9MRn1Yb6LEJ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761988119; a=rsa-sha256;
	cv=none;
	b=KTV2DGXPB/Rngqc1cJ3bPScf5UWthYCwWpTqlUTQRvn8auZTTod70eSzOa7ZzMnSmLFQ5W
	j3KLmFKzzVP/EXeftPbV4KhI6N3l0zjdoYyUBRZSfIpsXqQ3SQ22U+9iq7bHhDlPmxB40j
	G5u7Hi7/zvYPrqDpWsouBXimoImWmFA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 1 Nov 2025 18:08:33 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sat, 1 Nov 2025 18:08:33 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/19] mm, swap: sanitize swap entry management workflow
Message-ID: <aQXOESm58xvqS7sx@yjaykim-PowerEdge-T330>
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
 <20251029-swap-table-p2-v1-14-3d43f3b6ec32@tencent.com>
 <aQWR3fK/GtTkx0kX@yjaykim-PowerEdge-T330>
 <CAMgjq7DtP4j4kQp-bM+jrVSkCh26+8U-TkENxUmPkmEJyZg9YA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7DtP4j4kQp-bM+jrVSkCh26+8U-TkENxUmPkmEJyZg9YA@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: m9hz1h1779aak8pz3j65hcyde6mzjfmi
X-Rspam-User: 
X-Rspamd-Queue-Id: 743711A0007
X-HE-Tag: 1761988117-283270
X-HE-Meta: U2FsdGVkX1/4Q46QiZiZjJRX9sg3nBhkjr5Wt1zw4OUaeSmyNsRKrymCzdLljPFSaBYKbgmiEUJXYLTGnn6/lYm1gVmJeqio5R3REVOrJZuNA2EuA/V1oc6dll3dwB35tHePNeYlukbzhjRbfjBQtWjXp5B+NyeDN09k5pQnPdKLuTp/w/6RlzptIgPo0m9DkEXGkmpSxcyyndNrahSQQXsHx1eM6o2NwC6zatwHGwrErKT7JJ+9FWms8c7Xzvdw2OPZtYfsZdXKQmAtASGack/5RYb9Gh51bxbDqvEjeqrLBSBr4YX79zMhscRPTtmulXPGHw2wqaLMeUnlXOI5jXSHx9xuo1CedVEdMpf9qQEJnFFR6KTT9nXHhjEGknlxDBJlgXtnBJRy3U76n4g37v0E+6ReowIbCNx6Ex3WIG+5AQJOa9X+Q4sweCiK8ue5F+sYVZ67tiZyVKK0aHNFEikSp0LWpu0enlvRp1u3eGgM8fn76ymrtlWrqOT8jwGrwW1ph6iAfMjwaJV5tAIa8wOpA5yNmEcY8E9oXC+CombvRAUrWoMpP5e8Z+VjHG1AD88JePJx8ILwb2cVifDLDvJeeUbtYPL9V9hA632KKaazUx/VrHhAniYBtrPas2+QbiSxQMFuG1tK+MIlCa07GvK17f6TJ+tbmok4AMhH3K2IACwMmw4Gr3XDgIepyg+nELZKwbpVCSHMHLECAVm8zMYFOqudaDvD7nmfPVyndtcZ7sMjASbjTeYB4VtQWImjd4v9q1HwhA6M5a+wGIgXsjLl7yoBY0H5WRMHgMgY3gBaPeJMMkiwXU5mJqOq56GUBxog+wz64JP2ZS0JiFHEV5Kx73j6hIZVhjGceHuWFARL7fanYVZQn8W+h0jObEcJ4IoFJtsdOG3mlE36j3ni+t2vwOZ+wGvzpB+EMQBMqCFN0TXOssuCLWwPVTyXVDULcIHJkLCYpBcj+ASMeeV
 D91G9e17
 oL7W+hPTTfE8QjuGOJQ4ZpvHDlAu6NSSZY8faCuyhryOu+GivEyQCT/BZ0KhieOchme1+BwuVKI19iB5HkAT0FIPldvkD+22kUuCsmISknAUPkOLLr3wAsp3UWoKhMbtbOM6qYoolgCNe+JA8lAalJG+XnIb7zIaEtrJUl754y/xWFBoHb54JkXNf31UFP4huut9QRUAIaKnpZHAJRHMTCtogwSgyvq62X4yJ9wXAGbcRobPfpD9ykh9RPGDMaNJn3t48Gccf6/5pNBJtPKpxBxhzQ3yPAq2CNkbR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 01, 2025 at 04:59:05PM +0800, Kairui Song wrote:
> On Sat, Nov 1, 2025 at 12:51 PM YoungJun Park <youngjun.park@lge.com> wrote:
> >
> > On Wed, Oct 29, 2025 at 11:58:40PM +0800, Kairui Song wrote:
> > > From: Kairui Song <kasong@tencent.com>

> > During the code review, I found something to be verified.
> > It is not directly releavant your patch,
> > I send the email for checking it right and possible fix on this patch.
> >
> > on the swap_alloc_hibernation_slot function
> > nr_swap_pages is decreased. but as I think it is decreased on swap_range_alloc.
> >
> > The nr_swap_pages are decremented as the callflow as like the below.
> >
> > cluster_alloc_swap_entry -> alloc_swap_scan_cluster
> > -> closter_alloc_range -> swap_range_alloc
> >
> > Introduced on
> > 4f78252da887ee7e9d1875dd6e07d9baa936c04f
> > mm: swap: move nr_swap_pages counter decrement  from folio_alloc_swap() to swap_range_alloc()
> >
> 
> Yeah, you are right, that's a bug introduced by 4f78252da887, will you
> send a patch to fix that ? Or I can send one, just remove the
> atomic_long_dec(&nr_swap_pages) in get_swap_page_of_type then we are
> fine.

Thank you for double check. I will send a patch soon.

Regards,
Youngjun Park

