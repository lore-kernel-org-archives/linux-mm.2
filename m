Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDF35C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 13:12:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FBA76B0093; Mon, 14 Sep 2026 09:12:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AB406B0095; Mon, 14 Sep 2026 09:12:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F03426B0096; Mon, 14 Sep 2026 09:12:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D7CE46B0093
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:12:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B1AD4160139
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:12:14 +0000 (UTC)
X-FDA: 85212406188.04.9A47742
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 406FE140015
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:12:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Adlr7QH9;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Adlr7QH9;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789391533;
	b=CZ89ixZQg/APUxK4gh4KalIxUVdhy4/K1P9Y9aF5qLgWZGlxWYdoDUPJZ4MnpSXN4J0jRN
	NGeYmag9+oAeQSuuiIzYzCnFQMYHw8O+7kZtjMWAN1XCryLWxlnSICsyKSsgPA7JCxXLhF
	am0h9hiLXEFWXU30ZtZUwuTPqaqxeGo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789391533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BSkgsCXXSaTPgBKl80Odrr1kR+LQr21Smw9P9P2OQKU=;
	b=pzJU0nmZOPDzbVTEequeKo3AaimE5e6/z7dg0FtQIu1q1RG9kwKpGF1wEwNufkCfvnG4kE
	YqpS+/BLrA/LbWksIyejOxE313IeSlgcPCkeC5lLYeUcXSD2jPTK5nwzQkapLB435UsWMX
	p4Af9Yy27XOJG3ZHrNZMzcHJLy0WhS8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=BSkgsCXXSaTPgBKl80Odrr1kR+LQr21Smw9P9P2OQKU=; b=Adlr7QH9fR3pIyxrg02sp5cY3s
	zrb/yKefwMnh/aUgYSnMP0tUKjZa0ZeX5KoFX1azL1106iEZ5iKmUlcgEeCEXv8oW6apO/fMT7HVh
	x/sj9m8V/sCBQPfvZe0YqGhW8FtmvCBK4E5B0X5zd+JRrwrCoCnl9QT4HqRBVDfqzPfmSNinFPbT2
	dCFWt5ry2V4Aj8T3T0V7nmEit5nFYPEWi73zTno9YFsQIRNqBwcRUwZAphIEXXxeMSD3RyIlDUZAa
	fOCchdZ3act8kqJaznWmg+nqzKp8k4GPM03sjllak/qQPrM7iobgHa3gopYFywF1YajhaZ7+RtBjH
	+ptAO6aw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x66Te-0000000B5ND-0kYQ;
	Mon, 14 Sep 2026 13:12:06 +0000
Date: Mon, 14 Sep 2026 14:12:05 +0100
From: Matthew Wilcox <willy@infradead.org>
To: =?utf-8?B?cWl3dS5jaGVuKOmZiOWQr+atpik=?= <qiwu.chen@transsion.com>
Cc: "rostedt@goodmis.org" <rostedt@goodmis.org>,
	"mhiramat@kernel.org" <mhiramat@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"david@kernel.org" <david@kernel.org>,
	"mhocko@kernel.org" <mhocko@kernel.org>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v3] mm: vmscan: rework lru_shrink and write_folio
 tracepoints
Message-ID: <aqfypahso0rVnJS9@casper.infradead.org>
References: <20260914072433.39636-1-qiwu.chen@transsion.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260914072433.39636-1-qiwu.chen@transsion.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 406FE140015
X-Stat-Signature: 5emkr46npdboggijyjfcb9s5o3uyojs3
X-Rspamd-Server: rspam01
X-HE-Tag: 1789391532-677285
X-HE-Meta: U2FsdGVkX1+45RJx8fthw6ZrfjM7gT1LaSgfUlD8fYklfcpM2RP+goeofzEQucqrO1mEGy5ctaJOMykHhmwDSFSPnOFy60Yi4Ggq4RrqK/PFq3rXX0xEIQkfQZSHI5ZdPoCM6DWClqxm2nDxUWDF0YHhoaRe2D5NCPq1LYcA/ZMOmill3esQsi8gpzRShQMPR0wupw71SRwNx/3b7TwZ3xa0SUUoYnw2EgQybzWGAt52FigP8z/Ibw5uhtPMSXvMktqrftxZH6lZToUxLuN/nWDTl/2vz9UYajS6ge0cmVRIKPRq3Ftmdpp+plfaHluNfezSsv/CAb25o6xCSR1ubteJlpolN3kJ/XZZl9Bw3mFEWWwvdoFaLQzvXvKZnjZL2RE/y0w3eqtPBZrUHIaDwCXEn/bLaxrWnwYPBy75hLOxqYA5x191hm5LtsjCPv3m8YkqMAxZU5GXtP7z5PoqqQFb6HrY2ABXbWdjSosPB5hJtgtvmW56x8E99eqpWg8T2++poGIyxbgXDgb8VKAsJeFqYg50c+SsmrGIJrPGSTSNqHvcforDPKYjXyqlnPJFIbt16tjc4rEVkRWWau5XqDQA0QsSK1JXDNq0KFrDU0oMHmopi/3p60LKnBowX9K81EGP0BSyvl2Dvb+0OMPjEnmH3yCsEdsFoJtcvl5CPKN8dPy9c5ULMPKx/QF3K7HDr6nwL6ZgDb1pbDLiIXRk5LSmaKhboKOTMVV/W1f5MdJikj+D8toNP2ARCRghs0wTxTVJ2yH4pZqQouQZ2mOxO6cYXYvHDi5lqtqq94gd4tuyEkHT8p//pfZI161ec4apnVIVtcvyHMnG2b/p2Ydj0oTq6NK4l8by9lgWYwbLa90khFIFhRSPAbXZdiTNJFBWMtLImPOxsLSmJTQaFGvDZMDCyA0y9U24Hj799wVt83GJM/e/0K7008Waygnql2hkWVEAi0eS3QXTn7FpXYt
 iM/vmS39
 PtautgymLU9v69A93QRO3eBcZuYfsFAKR/ghsuALEepatSFPdkEQ54D1OCxKhNvIV4qGJyK0ReaQerwCUc1IMxe19rZTmkAvUuTxO7PJEQ3RLlJHzRqlO4glf7tTVGy6Za015TM3wxniZuFzt18M/La8XrGfKv9zjYcZj9p14Aq9yyOHBSpZ/r+EWA9yu6jjwIXnZZapdDidS/DrCifuFZ9OW/QqQCACaExGIpPIazDU+1p9+tjxMhFgxxR6yjHUox8PvwtdkPPv9UIjRyumB8CQUhveO4pYQRp5IQ0LgzM4a+Axx2A7uMjRhEcTuq8OjO6r7pHDuBtix8K4Y+bfyNrWO7xydzOiFb1Pe19775VmOJ+qI9Bz4k6el+vDMU4Snrw8e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 07:24:37AM +0000, qiwu.chen(陈启武) wrote:
>  
> -	TP_printk("page=%p pfn=0x%lx flags=%s",
> -		pfn_to_page(__entry->pfn),
> -		__entry->pfn,
> -		show_reclaim_flags(__entry->reclaim_flags))
> +	TP_printk("folio=%p lru=%s",
> +		__entry->folio,
> +		__print_symbolic(__entry->lru, LRU_NAMES))
>  );

Why is it useful to print out the folio pointer?  Printing out the PFN
made more sense to me.


