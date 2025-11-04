Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4879ECCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 14:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A82BB8E0149; Tue,  4 Nov 2025 09:46:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5AB98E0148; Tue,  4 Nov 2025 09:46:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9981D8E0149; Tue,  4 Nov 2025 09:46:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 887A88E0148
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:46:47 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 36B861A04F1
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 14:46:47 +0000 (UTC)
X-FDA: 84073201254.25.A5EDD33
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf24.hostedemail.com (Postfix) with ESMTP id 79CDC180009
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 14:46:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762267605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M7RreCZVDTCrcefMjqZF2U/Ej5DtLuLty530Eq5kw9M=;
	b=Sp6fx5qoNbpX9eivkxLbbhllUROocL203dWZpcAOuEb1RDPAdahrOabijy9Sw29toZ9kRT
	9h0yQbmXgN3hs32A0VTmyLDNj7FLfw233JtNNWCyQ1GX3Z94zq1Q1pBoG/WQl5OLB1dFMK
	zFKX2oQZaGlKOCcrkOUASVNS+QCe+EE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762267605; a=rsa-sha256;
	cv=none;
	b=6rcX/5w2fuIt7ARoY+CDf3FjDbJsYTW/DvrJVPh6Y0XntgTYsg0CLkT5X25pPJcYxe8oL6
	IbN4u3NEMCQOoeyrtOTmhUQDDmNfgjO/IrPMKsipqf2bDtAkNusg59Y1HD5WjYYhmN0RlD
	BQv3EU9L/QFftxEtltRv1hAaBz7TMIc=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 4 Nov 2025 23:46:40 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 4 Nov 2025 23:46:40 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm: swap: remove duplicate nr_swap_pages
 decrement in get_swap_page_of_type()
Message-ID: <aQoR0MxfITbuj9sF@yjaykim-PowerEdge-T330>
References: <20251102082456.79807-1-youngjun.park@lge.com>
 <20251103185608.84b2d685fe0ae4596307b878@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103185608.84b2d685fe0ae4596307b878@linux-foundation.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 79CDC180009
X-Stat-Signature: ihdwh5ymb3mnenchfgq6jbouesw53be7
X-Rspam-User: 
X-HE-Tag: 1762267604-180990
X-HE-Meta: U2FsdGVkX1/wfuw9xC9l0p8NNr1oCWFUrjgY5kkoq7DLqDmZMFZ4Oh72u53KbjoC6c/yZI5tA586obLNX584KPcQPy3By8bUZ+GxEtyt2//O2QV/GZ7JqlclaL3GYm/corpYay4aPhxXyJYA7MHnACdKf8zvYrSbTAeMR/auEYtXe+2Po2uAiOyaBBnlpMUpbQxPRKaO5XGFtgA3wiCoD/V5aocByKmnbwI5M5+FJbIO0LVbbNXLpaU3PyrhbWXTvAabtMxJjfy3UbV1ZQzb/8L7Fc3lMVHFJrLstFE4dhtKfMARUPxC5eThPpSbxvHSrcgCMG1X0O6WuLRQY+sWezgmvrWclXFwZU6dXsYB5pkQTDgGT1VNoAZCa2PGv8k5GWsA+8OKnyd0si8e6aMDuIc6ZYhGOOnTDlGwnNzJlYFHi5ORFsxWLMZqU6V8bduQ8lv/NrnSL4z/Krjq0pnmvnlPofr+N8Iv1exQXnPxCd/W6QHayuwX5Y1Di0P4HKPI4E7uugu+PQM25Zz068d2Idw/XlSrCOuWtrdrP3XmA8PZF0zH4fisueTBKE/5lGhROYyZYTYSWSX+1UgzKIyYTe38IIelxXE072nikP4lbD+TKiwKBUaGvui9KM1j2K60kkKvguYORmVMTdxOpvxKuhE662Jl9xAqoQghnN6asLs5RZJRYqHb2xwFENUzI8yfibBkaKh0V6UgswyFuVnFx0hj/pstIOVcLa9P9CCcFQ2RCzedFHbJ/9E2/bD9UCP5oHDLXooAXTzpzUDbokspqxuUvijWmtzY15aF5AqAf7fxTISL4YS31Z5DlNytTfOHKUDuB3CSnd+Sh3I0TEhwgi0pb72tJJtF1mtlIAchf1ys747eLI53i36nwssS3BX/3RUpv1matAzp7gNr4VxvmMvzM3IpGQmZ76dwojBc15JX/g9Wk2xTnC0GVLZsHNB0aUjd/GalHEZ9+EoMKa9
 /0+feowJ
 /cFOcq2cVh5wEvJLOkDwIogfMBsy3HoQd7TpiaC+MuBt6wxSXjqd9ZwX5uV8TxqYRr+w1pEQKjzDpMajb3P5qrnC5ykgghTW+vgM1+M0qHwcPvyfAa8HXu99jwy22KtXFSqHeUo7tpvmFqjpJlNQssBFrEG6gAWnyKZ2WqliRO70yyKllYNUQgGBnc9aA9/KezMe+RqtmxLs5AAgETLG6ow9jMn4BwMV80Qo6grz/C1RII4YSsJbUo9zeUkhr1ZTNy/vi1HT26Salt5l3wAJ/jl/pGO/XwsLtiCWHmKL7MA0Z/WUI9eOcQSiTAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 06:56:08PM -0800, Andrew Morton wrote:
> On Sun,  2 Nov 2025 17:24:56 +0900 Youngjun Park <youngjun.park@lge.com> wrote:
> 
> > After commit 4f78252da887, nr_swap_pages is decremented in
> > swap_range_alloc(). Since cluster_alloc_swap_entry() calls
> > swap_range_alloc() internally, the decrement in get_swap_page_of_type()
> > causes double-decrementing.
> > 
> > Remove the duplicate decrement.
> 
> Can we please have a description of the userspace-visible runtime
> effects of the bug?
> > Fixes: 4f78252da887 ("mm: swap: move nr_swap_pages counter decrement from folio_alloc_swap() to swap_range_alloc()")
> > Cc: stable@vger.kernel.org # v6.17-rc1
> 
> Especially when proposing a backport.
> 
> Thanks.

Hi Andrew,

Thank you for picking up the patch. Since it's already in mm-hotfixes-unstable,
I'm providing the elaboration here rather than sending v3.

As a representative userspace-visible runtime example of the impact,
/proc/meminfo reports increasingly inaccurate SwapFree values. The
discrepancy grows with each swap allocation, and during hibernation when
large amounts of memory are written to swap, the reported value can deviate
significantly from actual available swap space, misleading users and
monitoring tools. 

Best Regards,
Youngjun

