Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 132E4E9D3F4
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 14:58:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09E4D6B00A1; Wed,  4 Feb 2026 09:58:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 080796B00A3; Wed,  4 Feb 2026 09:58:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEB136B00A4; Wed,  4 Feb 2026 09:58:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DEE306B00A1
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 09:58:39 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 92534C02F0
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 14:58:39 +0000 (UTC)
X-FDA: 84407080758.17.547CF9D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3BF8318000A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 14:58:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=fQGg1kCK;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770217118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QNknsx76IClWty3KOQy5FfqTMhL6dQS75xtJtyVRIik=;
	b=QCgjER8VvahIPddk8Lb4TRNxBmRsjpUBkVmCJSkVC0LEie6tRMMvgPOf7lzGQcVvAlnwEf
	rMvvjX/0TqmL4yna0k5TNU4qQqBwWVqvSzJlAiDR+URrBV1q6ygjtDO6hEc989XzB+hI/3
	J49WjC4VCEXs+kGS9Pwk1JYcS6/pdGg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=fQGg1kCK;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770217118; a=rsa-sha256;
	cv=none;
	b=cZsZuRa1uukLkwrqPqQO1Ce0UlTD/m96V6lAODre6CFFz70k02G70WJccgeekUuL3Es4vg
	+auvAyDqQ7h6z0p14WfALNIHBzuDib2mRed9zY4mRh88yQrsxWwgD3XDVky+hL/ocRJzk9
	QoGpB6q5QxOgrqLQ3Y4/Gh6S4+XNWzQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QNknsx76IClWty3KOQy5FfqTMhL6dQS75xtJtyVRIik=; b=fQGg1kCKsbb9tRmG4D43JVgiWR
	FYwrOuSybbPC5kAkWr8Z5QlTBn0QZch0qYqZTlJ2OpZPc6rVAiowbOrMyL3YAhe2GvRPa0vklXQaq
	V6dGVLPgcuAkeCBB9RGGjpuhVDzH0t0l1RZ3fGhLr+cDJI2Agi4DsD16+CUlavTm0ofRRHQRlq5ui
	oQG9c2oyGo49RQmwd2YXhe3AyCKZ3uehq8Rd8iAtu7TuVo0ifmYEXbeWyBuyS3qgiQ8aHF9+v2url
	6la0Bcfx6hXvJnRSsYuqBBKS1sEZlKYYe97YtkkKEMKd+fsxgQVhP1mOwWKIQ41fs56HP99yXzDVB
	BX8lyEQA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vneKw-00000002EFm-1nY5;
	Wed, 04 Feb 2026 14:58:34 +0000
Date: Wed, 4 Feb 2026 14:58:34 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Aswin Kumar <aswinkumar3301@gmail.com>
Cc: linux-mm@kvack.org, andrew.morton@linux-foundation.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/userfaultfd: fix likely/unlikely annotation in
 move_pages()
Message-ID: <aYNemlPABKnQkf-x@casper.infradead.org>
References: <20260204142350.1642-1-aswinkumar3301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204142350.1642-1-aswinkumar3301@gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3BF8318000A
X-Stat-Signature: gpjqu98feebdncah913xc7s3apbtdpci
X-Rspam-User: 
X-HE-Tag: 1770217116-150181
X-HE-Meta: U2FsdGVkX1+vK8dxIVyKq88viNZ4EZFvW1YzUuisgBSiLZlR0EMZFMbovv2cZr5KeVa313scJr4YaoUEtUSfLbZ4APGYPpk49uYabgm6ig5dUNu2PBXxItC0yVqsKGwtBAaWy5gw399Q3KXyUppNj+9KfO7TxXv5oF98o7R4iL8u5MtFC/9eJhH9+uv+nWG4olkmkjP0sm2elCBdavx4Q6pFwexiuqK6M53wrNb3n6qBqz2OjphKVbaatRmtuN9CMe81RF8OEgifovXWcZybxombvVAIev0kb92X3qsVtZubPE1sFL/51qPnAXGnXmJudvoxFxysoyjTapu4MBeKXbg6a4qKgaixlQkUH3zjdd0dbJz4FUzhKYyAI3G7QgB2Ft31ySifKc24PpHFDE6S5g1imjdfxIkq34k9Uh2eGOefJmfDwRJ6LeRLZRACcMoCvril+smJDbp0aCuz44biSlnZhYrWP7jL79R59iLUPBz6WWvBeR2uK96ayNvctdtxAa7Ax+OoKzVg6lbFxQZukD+clK347iFaHZHYCrdXTr88TZUlcQzmYZ6d5+uqg+QTkYKIeGhs5rIcOyis0YgfPhMcVaTsM8WK0yHTpJgGJoUGPs5bdN+2lDJpzFvAzIQiVSriLf/7mYw9j3Kq/KSTsyR2QQzK8e6nRqW1/DmdbBL+DnYwatLPSzGyePciujyc3Z+/vYvdyo3JtFNU0hHoBLkW0vr8/+GipB3u/csQmvlysiVEvuzoPAarQ78i+volwhw3P9x+dCLOuj2R/bRE2+T7K5zop+rrmBFr048osC0RYCeL1kqgqVIuymMfMcFItLLaMQk8XctajVBlVOQovBwniP4LwpTb5njHcLD7okBL8GF6zt/AFcIYFID9nZYhYuD0cJ7790VQ8nNl4b//7VCv9y195RhJXLpQDmCC546sZSfFl8m/w+sRhajqgx1bnoBt9GZs810cXBcR/ym
 kHp41byj
 bcKhDoffwBxoWhSOOrUKJ1mDD6nOZEEVhTTWgNmTeM4PvKd3dYLheq8N9Iy0rISfSaVJ5S57vTwAOkpHZRMS979Z7nm19xfmdk2Tu7BAZpV6+C7MTRBfYCqS9B6pAiFUecBeU+GC2Ct0daddDPiWw00m8//T/QfC8F8oGnq/hH5Cf53SrOXvUHEa0daIScbGWA5Acv7QiKz7tVfVkBB+D2rt58cj+PUruWqoVVg0rGxrd+kbZnKy13lOYCXiC205nE7YVSGO0z4Mk1yArhu5wGSNscLSEWvsd6vOAH8r3Bc7AEZA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 04, 2026 at 02:23:50PM +0000, Aswin Kumar wrote:
> All other userfaultfd paths use unlikely() for the mmap_changing check,

No they don't?

$ git grep mmap_changing mm
mm/userfaultfd.c:               if (atomic_read(&ctx->mmap_changing))
mm/userfaultfd.c:       if (atomic_read(&ctx->mmap_changing))
mm/userfaultfd.c:       if (atomic_read(&ctx->mmap_changing))
mm/userfaultfd.c:       if (likely(atomic_read(&ctx->mmap_changing)))

> This is a performance-only fix - the logic is correct but the branch
> prediction annotation is wrong, potentially causing a minor performance
> penalty on the fast path.

Can you measure it?  Bet you can't.

Honestly, I'd just remove the likely() annotation, not change it to
unlikely().

