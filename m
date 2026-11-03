Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 445CB606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=sC4V93ww
Received: by kanga.kvack.org (Postfix)
	id 501106B05B5; Mon,  2 Nov 2026 20:56:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D7556B05B7; Mon,  2 Nov 2026 20:56:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 414C46B05B8; Mon,  2 Nov 2026 20:56:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 231166B05B5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:56:11 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 279CAA4F63
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:56:10 +0000 (UTC)
X-FDA: 85392142500.11.D9798AC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6B81B80007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:56:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sC4V93ww;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793670968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/yEmlIGT8Rm47P5/YaksZujPOe2/Vjk0RWJKshG5qqM=;
	b=unnQglt4tBzV4dFkgKNxwntnu6gn+5HZRn9sl62Si6X0NBnFaDl16Gho8Ntx1an8lno+rd
	SXgwUa+5HKZVuxDA/WNjNz9/a6XGs8CVEkQ2mMnF8l2/fPKxyLVJUxTA6EmiWCoJwpKMHF
	iTGw/En5eM0ZPpNTeZqUOKvwvwW8xJo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793670968;
	b=qWXvvzijNl2zYKWTVPsXzhp09LXq+Gqq+S47BmKIVA7aYA0K/5AnvZxnFbHaySIxTJOfcF
	RRnI3Hy465Zf6Ighj3vNWGSLy/dtGYTv+v6Eeb9IEXo5FmT8T4GprHl/YW+bI9h3Cqx/PN
	79bdm8Uo0Zu7hG+X1WYmJN8532gxl64=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sC4V93ww;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 31DFD429F2;
	Tue,  3 Nov 2026 01:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524B01F000C1;
	Tue,  3 Nov 2026 01:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793670967;
	bh=/yEmlIGT8Rm47P5/YaksZujPOe2/Vjk0RWJKshG5qqM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=sC4V93wwNcAEqLkI5tERpnFGjyTFE/S7+D0PuojsTyfZtKBtUMHkOnNhI598gNx9f
	 ZNuZjjfJBBjamVORdQd4cPVcMwjB1xQRT+bRH6a6iRkbNyypZrP9Hlqg3FRTecSDXm
	 lNzKIn8M4Nf2nS5PpDpoBb7fi0J0bjWNCvuoCMF4=
Date: Mon, 2 Nov 2026 17:56:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara
 <jack@suse.cz>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Zi Yan
 <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, Joshua Hahn
 <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
 <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard
 <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Hugh Dickins
 <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] mm: remove newly-unused page wrapper APIs
Message-Id: <20261102175605.a0d9caee8279ffb5f6fdf15f@linux-foundation.org>
In-Reply-To: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
References: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: kwdizazya5uensrgsktk7hu7ytap953y
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6B81B80007
X-Rspam-User: 
X-HE-Tag: 1793670968-185590
X-HE-Meta: U2FsdGVkX1/ad//1bMuJcCCRJreOwuB/kpGKoz6yadABK4rOFp9o0aAdih7wCjHgTZbQ3ARHJQ9nURxvvcJ5lDqJfQo8QWh+K1IavPnX8NOHrJmtBc6Wn6cEpLpxZ73gKuEZkiVlyBKZCQmM8Vo8/sjx53q8HK/wleXV5C51LGMZStlxuROL1qfC3oR/RFsq6vXrpCSkH/PLYRDrTtmBGxpJToDB5X4JP8MyYaZ0IGeg3HFAQgZtPrSnp4b87V4Va/ix/7ECB9l1AdwoygMQAWgixhTcMNGKzbef2aULvKYDlg+itpX38sNi7226q8015tb150xlaDe9O8r9BQUTyoB7bfIvLvfG0zlf4xyqw5TqXDbtg5Yres9czwupJWc7TtfL48/cujmJiABR5bowdUnZeSd0JCKpof5NUWefkadG7TW36MfQy6aF03zK33DGB9N04CxnKDPDADWVsYNhKivvzaSpJDf5t9ZWJBB+QzIgtVeKV3ZkBTYBoa5YwaJeuT0KUJ25CYZYN1/P5q2TP1OXB+LXdiSwQc4zkKMr2y9dTr3wrOeRubHW6/CTwczypuo4RIiYMBKgiH7JMMeGFRTAc3lCqYcmwKEb/C9kNK2sFq3gz6R9o1hX18ghYEkchphldN/v6Q7TSPbXrpcf7DLpETuvb3aX5OFfsKAbjGF0qo8+fJ51QZ+q9lef7hFE7bYSHtSKOhsZEjtqX1AIFa2OM97VK+Stk9TCOtcXlUwGZxPEiTCaxsmoHhP2gW2/4S00KLb22zu2kxeYcHSBPfd3e32uN8lJmTFNAP9leXBSfp6xNz9k4MqpnLuFO3nmadSZKVN6Jb+0L4Rlu6fXnVSbJAZCPfAi0Nhf/zrl/7eAznrEztY5dXcQ1kLBalZr4aVIQccg4HJ7aLacLv7E2QjtxfKvfmsr5T3gTgT+AMkd0ikpoYOsJYK1NxmQHQsM+uinNDseCU17oun6eau
 xT7fM86O
 Z6MQBi8US1eezLRlYRWGwzYfzq36625bMQyO5X6o9Z5xPYvh7KtrmmnlfTZ9uayqrXCt/0dPRVfoVxiDXGP5KuhxPysZTydBUU9FGQE8XJqsUHIN5W4oYPr69qRvcoWuOY4/fbpkUTZdUPBManbwRXr1ZJKAQ1EJHQDSsIJlLrOy/3o5m/jFy876ppzNS3E4QYrMnHrJ7s//UjvvTghAZOn7cg5sO3F1Lgm1sRb8+RdCcMXAH0MF1DL5s8EpBdy7WUvgJxjbw/jDCgrW2i+MlZuShUW9p+eismuJncnTUz/cb43sWP/NFyelXqoA96+3E8WX/bWcG4UWRoOk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 02 Nov 2026 17:54:05 -0500 Tal Zussman <tz2294@columbia.edu> wrote:

> After some folio conversions done last cycle (namely ceph, f2fs, btrfs,
> fuse, and page_io.c), there are a number of newly-unused page APIs.
> Let's remove them and update comments as necessary.
> 
> Patches 1 and 8 are taken from the ceph writeback folio series [1],
> along with tags.

Thanks.

>  9 files changed, 8 insertions(+), 110 deletions(-)

Tal, you obviously haven't been following along ;)


This development cycle is not the one for cleanups and new features,
but this one sneaks through!

