Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50920CD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 20:55:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29A296B0099; Tue, 16 Jun 2026 16:55:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24AE86B00A7; Tue, 16 Jun 2026 16:55:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1889C6B00A8; Tue, 16 Jun 2026 16:55:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E54F76B0099
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:55:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7B2BC120208
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:55:32 +0000 (UTC)
X-FDA: 84886981704.27.AE0F94B
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf13.hostedemail.com (Postfix) with ESMTP id 99CF720002
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:55:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf13.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781643331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xfzKR7IgypJiS1B45c8sdwSFt3SsDVQtlJzJWnaQ1a4=;
	b=SEO3kEWbt/zuMIljcAMF0imImXRHh3LypxeJBFKGkfFTI0jCWPbiromsX2OUowgGLjiGzL
	z1mmGkRt+XBKMOF+UAAFbEo05uEZkEGswbdvOn2nbhXPqc9rXkNhKb9KksHbjhyaLyB3EF
	9bsZyvYBpmmJgL6vniUYdnO/cLYH/sc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf13.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781643331;
	b=ixHlGGgnZ7EUuNIihxBzcxA+/k7XNNrMth7v0jmxlIkuYKQC20o52t5TLOs5um6Rr6XKZZ
	v3tkTGGKtI4IVOLH9TfWwYXqPsSXA5/thQe2lN/SyxPoCijWnO1aYSq/5AM54SRBFzhzuu
	wW4xt0vRVhHYDL5MkcdCEBjQlRTsV6I=
Received: by verein.lst.de (Postfix, from userid 2407)
	id E2F0E68AFE; Tue, 16 Jun 2026 14:36:46 +0200 (CEST)
Date: Tue, 16 Jun 2026 14:36:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Chris Li <chrisl@kernel.org>,
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
	Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 0/3] mm/zram: route block swap I/O through swap_ops
Message-ID: <20260616123646.GB21024@lst.de>
References: <20260614-zram-swap-ops-block-register-v1-0-6c1a6639c222@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260614-zram-swap-ops-block-register-v1-0-6c1a6639c222@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 45ptugw3nj5rnqoy1sf99noh4psdqocn
X-Rspamd-Queue-Id: 99CF720002
X-HE-Tag: 1781643330-281194
X-HE-Meta: U2FsdGVkX19ibSffJGqv93BLNImkJFLSMehNJNhlMOVOg+p8wiag3mTj3myAOXuO4orHjTcHGdY6t2r6AWt0vRnxqz0pJNuk0H4ZfRcnXfQ8jnabzXUwuyzyrvlDR1eSp/2ncjwi+UJCA3fwVxUB5s9/3au3Y0AYnFQKWgXLzeepfSi17tuX3tmbxOvKHpjeTNUGYc8FNgqRhxbazC1sQwDP+piOJcBl2gYgNNI80jI+Vx0OQyhZiPYscNkT05mba7Z/kpwS7uRG5XDYs9DWPz3EMA/LtTsQod+IEbb7BOVzDrxPK60OWntB3bKDjd7uPCgSOVowC6Nzj24OT5PLbPAzEqEdkjviP3dhbTEZZD2StlKI+2s4Tp7SBIi5SpIapBpscJkZ6jDgsqTPfUvuGEM70R/2lizpVhaloDVVWkssFNDx8GWDUbpWIFpMKj2cqJK8UUUI0tlWE83xtP6qrgI8aecIGLg+d3UxUwI2QZra1WtyZzYc0kjLdIFDBFcZzfxrXE9Y1RSedzeibKqnUifk51q5UDJGiTPMrfAy/UTHNPnCUNFWrCHF9cI5y/xALNfN+7GZ1Wf0jIkDV7/8zYFR9civ9o8g+hXLMRigfBosQgNJC78QHoHZjvlWKzHGGHvBvUOtSH1+ugOFEEQZLx0mUSG3Pj7XqVj3bAH3HPURuagc+jxsYt0D7vK9NmNcgI4KvGpLElFGFehNnnO2/XqNOkLfd8TcZhRiTyPKoF9c1z4aXwB9gk3/Bq/maJd78ox885dfjDqCIUi4patb/xcvWiV0AwMPDyhsW6g9AYb9yOVm57Oic2x2sMI43jOgHfBKmtpOVxe6bpzi/j7TOkTZpCLSZKwVOg+EU5NSc0eQ7kgxOydGJUu1DknU2337jode4FqrXURAHe1VKwLxPcU286grcdj/blNvA0x6cUf+6r4fe0IqV9+NtBxQNgNa7lt8X88Hxq8PNYEhak5
 dPFbQSyM
 Ec/ltwho13fqK3788es9pRICPfCNPhHjmH/RSYYNg9mK2lIJ0ekW81JE2ImPRLM8YMzsgtz/h0PXK6pj1H8IQHWY6S3RWrTnnTARrGKYWJNserFtID7gu5JsNlrm42T6TUavFwOCnS8NMH1k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I fear this is going entirely in the wrong direction.

Yes, we have to keep zram around as a legacy interface for now,
but the right place to deal with compressed swap is in the core.

So please don't add more hacks for 'magic' block devices.


