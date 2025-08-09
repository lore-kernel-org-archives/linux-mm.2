Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 696FEC87FCF
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 15:09:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C067B6B009E; Sat,  9 Aug 2025 11:09:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B92066B009F; Sat,  9 Aug 2025 11:09:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA7EE6B00A0; Sat,  9 Aug 2025 11:09:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9482F6B009E
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 11:09:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3ABD1115708
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 15:09:17 +0000 (UTC)
X-FDA: 83757552354.03.53BCAF4
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id 170C84000E
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 15:09:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=QIG3Erz2
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754752155; a=rsa-sha256;
	cv=none;
	b=YAEVHXHWDZq3MpfauDmGGVwi2XNRABlhNy0KiiImTBmee21f2E6dEmxgKI0EXh24er17EP
	YageY3+TRyApmUlpbs5EnS6Ergn24uBz7r0wl5S6p9GjWgQmbBpGUpmE7sivFGWjW1PQ3j
	si8Qt++14Y3yDKqY1bchNA0STMQ1qEY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=QIG3Erz2;
	dmarc=none;
	spf=none (imf07.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754752155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kh5JpPd0ptOiYUOZ9ynxu8RlzVLFZCHO4x+p/YYs66Q=;
	b=jO7Pzq+0HSMPGmqK6NkqY8pt88OFNcmOVuXCVPY3hwkbUT3X+6jFlcuG4cl2ss9xvS/WNJ
	lrMENjpDaeTDt8plKbscVGSYk46YrCLiwBmFjtluJ4eBuJO53tWCG9Xe66h7MQ8k77HfVL
	VmbIkCop3/fFBhyE1Xq5umqmWGy+sNQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Kh5JpPd0ptOiYUOZ9ynxu8RlzVLFZCHO4x+p/YYs66Q=; b=QIG3Erz2tmy2zkOldagaHY1R0w
	YN3ASOLfG+/kOlfs8CwfLaBNXKI+S9An1kE9HNPvrkFgC8flBgVUIrmRk5sD+/1ngGFWjRQBibuKy
	qBOD//Xx7wz5QhjQowZy8eAciZjahDXdgAixcqZTD5KSSXppGf/V1fBi3/2vdfTy/vvVFVfqmOt+c
	A9ANy/l6JSDNpMKdBZzu4BwO0odN60SZiQFcxzug9YbJtRuu4GjAu4VozAZ6Xt3tyBMpSEBDXbziz
	kpdITreN5uz7ZOLCfhTeDz39FBOHu8+y8nwby7inbGhMsCVq5tI0lM25yUIlkjwD+UJVohtowjQEy
	PQmQ/OKQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uklC4-0000000GrcX-0zn3;
	Sat, 09 Aug 2025 15:09:12 +0000
Date: Sat, 9 Aug 2025 16:09:12 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Subrata Nath (Nokia)" <subrata.nath@nokia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: prevent RCU stalls in kswapd by adding cond_resched()
Message-ID: <aJdkmCP41RhNC9FH@casper.infradead.org>
References: <AM9PR07MB78119166E41E86BE5E7DDCC0882EA@AM9PR07MB7811.eurprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM9PR07MB78119166E41E86BE5E7DDCC0882EA@AM9PR07MB7811.eurprd07.prod.outlook.com>
X-Stat-Signature: csunh4aigxqzmdrrjjn7rbwc19ydyoyn
X-Rspam-User: 
X-Rspamd-Queue-Id: 170C84000E
X-Rspamd-Server: rspam02
X-HE-Tag: 1754752154-866742
X-HE-Meta: U2FsdGVkX186uC1/3C3Y+49SLnk2ZRAzhDUTSowv92t9LqmJjzLsky5TuoiV0UR0qx5RHUN4tc5NS8ifaaDqamEmfuYq+L3dBaRzO0W+BzcWRWqIEVUe6mlhCegvVh6/g2J1yYjMsQnFTZEbXdRJXIcKKNX3v0Lppc23+EDh8GTHdXFswSzP6vzFASxk9bJxhO+hVBp6DfTDC2mLwxLdfU7/ztgrqi3ySSm6zV3b3QU1x4o6k0cildW3KOu6bZwwS8stRk60C/Y0XERh3JfWjEPadDxBs7pSkRy0b4STqAFHZQfL/zi8jVTlOofa3DNCdWELUsX6GeMabcsb6oWpwgzS4R2Y4yuPuvZUuarWqZ+q/WCQfBWgs3T9ZTVW0Vte3YX+ZU62OlPHJ274xPNEdox04CTDYMB0UbnL5wxa8kdrPvbf6nSAE2zukNwNC6S2WLloyslhsSK+/V9pf+KfTXC1cVXkuf3LIwFJLWHeCmbtrZjcjm+zONqfZnYBGEFC8AnPU0eI96wK+Z2D/Hb1qldNtnlU3mnbkDV315DsAwh6hoe21NPP/Ok+0gVL+pjqMiK3T0yMPVQbN9btD7XLDi5MeE9kd6hNR+2nW75q76YgSX7RPMlzXALm/oZ/h22WEykba722+KEzdkjnTqFNkj/J9hbPHb0Byh6mD77lzHCZ1qTBpHQErtKk6F7xHi5a7WRoYVS9emg2xl7j6FkCRKbkp8pvN5SNzie0QIn5Me+sxq3LFCfcd0++xNf9PxDZabqCc64NpGfh4Pnb8vihCvdxvsrgFIucoDqUieXiyAJmn/ORpkm8QNaLjo8a/jCThOFN7MDE5Z0XFGBISqwtSSEq8TZ9cv1bJINrCYqW55tuJvLs4e+5IEV5MGy4tWgsdxLTMSy65X4Wan6Tes0Lgd9nGx69j1TArWBzvhgJuTwD4vHYHuopozOvjWRo1EvX800VnjEDtmUlYsd8A9P
 5YELOJne
 VUR83+sbuOXO8a9YFvBjd2dZOG5IgdRTvGxFZbASv9ngjTWLd1pscWdDRN+LlZtM0nweEgm5bH4WhrWyXeHIs85XpM698/kjWXhn+HEtvt2Kf0s9i9sTu1ScNA+I/79P561lcWJXqZyMVBpfgk5ruSAJCtiHWUQ/eCjEP6ZGkyiix88FtaxRlSl2QBbCkttC9e2aphlhJveVXEWxJRFUoe8dnNjKre4TTxlkMv+1AVRxWV0Y13fr1ipHsWhTxKHO/pCZB1s6/TbL557D00HNo4/gEfEWzMc6udlLw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 09, 2025 at 11:59:16AM +0000, Subrata Nath (Nokia) wrote:
> Fix this by adding cond_resched() after all spinlock release points
> in page_vma_mapped_walk() and in the main loop of shrink_zones().
> These calls, placed outside spinlock-held sections, allow voluntary
> scheduling and ensure timely quiescent state reporting, avoiding
> prolonged RCU stalls.

No.  We're removing cond_resched().  See
https://lore.kernel.org/linux-mm/87cyyfxd4k.ffs@tglx/
and many many other emails over the past few years.

