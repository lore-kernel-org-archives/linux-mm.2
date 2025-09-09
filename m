Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 156F3CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 12:41:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F8018E000A; Tue,  9 Sep 2025 08:41:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A86C8E0001; Tue,  9 Sep 2025 08:41:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BE3D8E000A; Tue,  9 Sep 2025 08:41:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2795A8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 08:41:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D959613B2AB
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 12:41:45 +0000 (UTC)
X-FDA: 83869673370.12.7130399
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf03.hostedemail.com (Postfix) with ESMTP id 02FC420004
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 12:41:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=TMPwzjkk;
	spf=pass (imf03.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.161 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757421704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XVUdhNd+P9h0gfV0HMy1Y0L0QTg5GkmAtstrPmaFDx0=;
	b=2bkQ6WuhqAImQaOgYSg0DtfZYi/PBS6gx0IP4fKcFJ2zpuAKhYv+6+fDldc9KHVA8VZB3g
	ttxLaSp6ouM6RKhpADujydOzXrLRtcji+0kCCBMY7rAuewekX0u112p88Tk8GRrUgwkQcB
	WglFvF38DHLfXrbK5F+v0L9ltuZq4+c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=TMPwzjkk;
	spf=pass (imf03.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.161 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757421704; a=rsa-sha256;
	cv=none;
	b=1aUyAZSmN+4hG5TL1PX6YIQ2KXtGfdENGlrRhXpvxHDVfbay7lUTzE9VvgyF/IJ0WdBHVw
	pmwRQA498oqDI4cmGI7qcpu3zPxsEYbjJ2CvpfojzlSvtTsNQ09YC9a66puFHIDDyO+o3S
	Ab31YHMgeyYR9toqKVlWlLHjrrIeAec=
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4cLk373gvLz9t8m;
	Tue,  9 Sep 2025 14:41:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1757421699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XVUdhNd+P9h0gfV0HMy1Y0L0QTg5GkmAtstrPmaFDx0=;
	b=TMPwzjkkTW4j8Cvbkqjny5DWR+W7DUefa/Z8x3PwncsEBRVL1pIMr5wxUlg8PNyOoUVgpD
	yM4xxM8fO3Eeacm3Rt7UBHaMVBJgeHXGTcbAbdfH4p2dxQ0tjlZmnkzsf5IValO5qVH7hV
	yfUOamm3A+RxLz8Q7tIcO/GL58wq+pXf83AXRyDtNnoGa2wu3JvzNB/zQBRzvt6M3Q00+q
	U0O0RVkV9eZEzFGwJ53huvwk5A+uUzR95i9D3gf82Z10JGaHFa6+Yundi9r/GN0A9S3XCw
	FYyzOcaQCAHKWHAaHnB8bHwKoTCt95RkgO2gH5qeXYdePoaabfUdK6DfM4qCFQ==
Date: Tue, 9 Sep 2025 14:41:33 +0200
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] readahead: Add trace points
Message-ID: <iruyokxvyziqzq3qrcorpx6mq2pshs6beyvgsokqlcz7loane2@y4bdrxzzitwa>
References: <20250908145533.31528-2-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250908145533.31528-2-jack@suse.cz>
X-Rspamd-Queue-Id: 02FC420004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: oj7z9p3xwpb8seobxh185m8w6gdxiria
X-HE-Tag: 1757421703-441663
X-HE-Meta: U2FsdGVkX1+75t8uKYbDBaBHNpQqYsDUsidrPBWbhBte3REaNScbYQOoqhVJjpDRt2lzXHPDP/MBG26cipueyNUkL/e89+kXXBsgfSBEjORsZPkZYHhydpMZmoQRyZf58agJLoyD1Yv+ECMSXrt5r5XK3/l6xzcgB+TTrGwR/YFcvD8LWPCu7eL1effCWWPPAWyQO0j+YFNxwMBcz1VEiv6hoe18m619oxnSyreQSWzVBMkWYSn16HcYJtVHE4pbcivDrrouAL+XTkqRQ/5izlhMhLP5uvSfivctbau/f95EvnXoDPf2s02mdTvqHGq8RgILwvR4tDHbcyHBwxH4mDjT33dtKRIZuD7JufRvzh9KImrlqOlV8gktI9HglOPeNRpmfCuKkYObvPPV8Hlv6pZOnjzApXvHWYkxUmiGs3BYVb7kgfdwRWCxC08CLPtQLB9vbmzNMXBazmqJKtzLzzFUhSOsRC2FGgNscYFwZw7b71bgXnbwf8j6ZmoCrMf3PrLg9RBwo6LNXA5OQDTPx563McdNDGI1v4G+Yaolu1GgswEKeRaKCh5/rmuqAbWxBZFgVQ6UfEqW853UPaBuQmnRHf9tQ8B7+gKrxxbrNP8WZ2C60I0NArr1LhtR+YXvc6gXu0TsLAumdMXmmGeYtR1yLMN7YMZFd03XxCLu43SUuD5kd1t3p++JFofQh7BDiQg7UpZpdrwGg/D9N7uYqyA85J02rsEWNbph78p7EhjgYC+MsMDho++9OfYL/ZQhHVUeFzNGg+TkMDeU8ayMG7bdv0XEQPXtXTCvzsmekMZ0vcQdeeyWHkG32aBkLZ9TU7hLgasYNrHdfmX4GfzVuncJ4WVVzSVE43pgwbq0XHlrIuUtxk2j0N17HWFxA+A4Fid4a5urbLfCLKtKmjSDrIGsNr63wcOMZz8SBV6S2ZQqQr3VBx5mMZASlaIsbfkFj40qdI62K+wy4m/wtd5
 cs86XiTz
 fScU224xhaow0MV4CLhmlmb5Q1UVy/q1IKrhauBsKQc/qK18JKcJsCpDyVop78OYxUovwn8hvDlYJ1ObNKWpvALxhDoq427aChV+48Y0VjC7ZoOGyY1YQll+z2FwjUvS7zBeDCirl/FHDE/abpfweL8pEd9399O7hidutPcJK7AkolrEaGwrK7TLE4CtfFLcxJEzHOT408YMoXH38AFX0mOPuiXbJfJ+QE/wG0GEW+GGWgdMyBswREQf8F2bLjvSn1RsMKdjA4Y/iHVL4QJggyhr0iS/h0W7oarjU/ZXzi0gSBe4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 04:55:34PM +0200, Jan Kara wrote:
>  
>  /*
> @@ -314,6 +317,7 @@ static void do_page_cache_ra(struct readahead_control *ractl,
>  	loff_t isize = i_size_read(inode);
>  	pgoff_t end_index;	/* The last page we want to read */
>  
> +	trace_do_page_cache_ra(inode, index, nr_to_read, lookahead_size);

Any reason why put a probe here instead of page_cache_ra_unbounded as
that is where the actual readahead happens?

-- 
Pankaj Raghav

