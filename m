Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A297D29DC2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 04:37:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC5986B008A; Mon, 12 Jan 2026 23:37:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D72FB6B008C; Mon, 12 Jan 2026 23:37:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7F7B6B0092; Mon, 12 Jan 2026 23:37:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B85356B008A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 23:37:28 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 730F486125
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:37:28 +0000 (UTC)
X-FDA: 84325681776.19.1B77582
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id 32972140006
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:37:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="aLz/gxcx";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=UuelFnAZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GDQ+xlHm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=LKADajnP;
	spf=pass (imf26.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768279046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ectBUs8mnN+AKlgMujzQXEve4AjBCENnkmCZtEA1mm4=;
	b=hscv83/j87nzFfOOgT7EMP2OVKI2ch7uwQES4NNfJDeQR+izfVRVDJ4Tr4tzRBCWYGlpwJ
	ZVBgpxgKig2C35ELY38xYwvxQfMZsDUj2KnvDy72XB0Fuc6THLTuTOZVHKazeHpSqVdfhR
	nhh3ti1zyzYmnOLsLhtocGA47Jzu8ZA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768279046; a=rsa-sha256;
	cv=none;
	b=cLvZaJidijc0nNk3zMCa8c53We9L6KbxVTQwee8SQYuUgOiGXoWypPQNyIvyXJfgW9YHwr
	wJ3kIZgtz10tZfXFaJjK+R/D/mCqsiPDHI34OxVnzyUqaIGWj5LgSLaX8dRgcG2nUecuKD
	njx+z8jK+K3T1y0oYkhOZ5b4Lo/vuPk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="aLz/gxcx";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=UuelFnAZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GDQ+xlHm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=LKADajnP;
	spf=pass (imf26.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E0CC03369C;
	Tue, 13 Jan 2026 04:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768279044; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ectBUs8mnN+AKlgMujzQXEve4AjBCENnkmCZtEA1mm4=;
	b=aLz/gxcxR4kFpg1O9if0fqt35djNminYd6wfkzFDgB/GU1aIvbiL+uwmkBmMs9eTbz+UMf
	mf8jBWTyDkVGfvVbP1ujCoTKaBR5307NTvdj4Nb8jnnDgMsS7XzBloRgim7lIRgC5c684y
	9wGVeitX+cpjxEZHgRun/eKNnrg5EtE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768279044;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ectBUs8mnN+AKlgMujzQXEve4AjBCENnkmCZtEA1mm4=;
	b=UuelFnAZwywcJx7xPKjcDdlUB1HMT0VPYxJ0JRvNiPSBuIrl/ac5YNlbw106REGLFOV5T4
	1l85RQDW4HvWKZAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768279043; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ectBUs8mnN+AKlgMujzQXEve4AjBCENnkmCZtEA1mm4=;
	b=GDQ+xlHmdQEaE7VvyZ2+6ihUTu91LIT57bnTBufjPJGv+Z3Brexl43fNa4jGsDdhJvoop1
	IrNoKdT7p0YadU1f1JL0RdRc/W6+GPVwniZg9uKwqM0QTNq6q4htaeearHpiSLkgCWlyEn
	e+Mlsx6XpvSBXL84d1xd/sOTkGk6O18=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768279043;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ectBUs8mnN+AKlgMujzQXEve4AjBCENnkmCZtEA1mm4=;
	b=LKADajnP/9RPKN9YHvOzLYw5VCl3P/D30H/7TvXXo5eWPWfdco2X24l06WSYyVeGTl0hL0
	dYxJEh+vvufq1aDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 391E83EA63;
	Tue, 13 Jan 2026 04:37:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Cb8jCwPMZWkMHAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 13 Jan 2026 04:37:23 +0000
Date: Tue, 13 Jan 2026 05:37:17 +0100
From: Oscar Salvador <osalvador@suse.de>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	sidhartha.kumar@oracle.com, jane.chu@oracle.com,
	Zi Yan <ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 1/5] mm: page_isolation: introduce page_is_unmovable()
Message-ID: <aWXL_ctqTCTdaJHe@localhost.localdomain>
References: <20260112150954.1802953-1-wangkefeng.wang@huawei.com>
 <20260112150954.1802953-2-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112150954.1802953-2-wangkefeng.wang@huawei.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 32972140006
X-Rspam-User: 
X-Stat-Signature: 51s1kidcxh756k1rt5xfam7sebe35s1y
X-HE-Tag: 1768279045-410440
X-HE-Meta: U2FsdGVkX1/tqk1K1EZy8fEVGh0SYCAioTabR+15nYBrPqakZg4F9tt26N1XcGJORoG44YOtqQXbcgyJOXCXe+j45yPL3Rp+lDjQRuoaTKiWzCpCJYis/Fvnacgdbyw9TDRwC4ZWpfAOfftqIMW2aX6EF+8aeoPxfNAElEIu1mUXkqKI11APL+mXE2Si4Z2tbLKJtGYhYPrgSepIB7INUZkUhZcHmn/wpupK+SQRCApqjfU5YvjD5TRNSqoXb6g781ghS4HEbM55mQBnvetj5d9K4Fbm+EiEfm8aHnPZIuOAJUT+JIzZNVzGnoPibma9K03hBY4SGYo9dpIB/iTI9sqKMKPFy3LfGYYltryKcgIgvpIT1ru9yj6OuAWtsX4eqmuTMA8dsMzPd0J6l5GuQC2fBlrYt5SBlRGUcT77JpMa+UEfoZ+oB7h4jWIHjAdSOIoZCyzr/6BUSv9m82Nc5uv75iLX2cKNSxo8J+d1wy/nsbsjMMp99U+5OLgyefjSWGzHqUu6oTD0RnwbzhFt6JcolUWofVY0+tyzl9gaRBUn5F3WeIEZstXPRdVDNs1p4+etT4DeloRYOXpTHJbT83CWc6qHuju+48McyvKr81RJS6RcbHmmRjdEJDP9ue8MrBsw79WNGs8bO0mDdg8NHouW1vx6kwq7j1w5Quld7q59uVuCri2XiIXP1S13fMw2CbMLXTxvIuM+C4KA3ahBZMgZQdA85wOu4eYL+JHx/fC4z9m0J5ewWLlT97NMKfR8Q2Bs4cl/Uw78z/lKSr14bqptI2mPVakrQD7fPOZQUX8R1faKYeGjttxq/YVk9KYfwpBYt/8hyDUnanRCzXiqyUk2apN0wQb3Kgjvy4b4CleFmhBAnJ67fY7W+xMsR5eCGiV8vENADtT/uxNIpLaVkpKbL7pfHONjPE9LNAax+W2zLBLEsstlN69ISnNgJZfKFBWQNFF2KwEwSVLH7oI
 mjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 11:09:50PM +0800, Kefeng Wang wrote:
> Factor out the check if a page is unmovable into a new helper,
> and will be reused in the following patch.
> 
> No functional change intended, the minor changes are as follows,
> 1) Avoid unnecessary calls by checking CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
> 2) Directly call PageCompound since PageTransCompound may be dropped
> 3) Using folio_test_hugetlb()
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Looks good to me, I was a bit confused why we cannot rely directly on
hugepage_migration_supported() without having to check for
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION first, but I guess it speed up
things.

Reviewed-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs

