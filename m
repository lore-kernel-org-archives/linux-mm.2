Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90F44C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 03:58:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FFB96B009E; Sun,  5 Jul 2026 23:58:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B0CD6B009F; Sun,  5 Jul 2026 23:58:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6986B00A0; Sun,  5 Jul 2026 23:58:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E3C606B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 23:58:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 476461C1BC7
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 03:58:35 +0000 (UTC)
X-FDA: 84956994990.28.4853390
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 572A720002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 03:58:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=e5AadE2f;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783310313;
	b=XCpjTwDl1DGLadXqo7S0kbOJL624yakymvw9oRCNkrMEckyNjDXUpl6uPkxwKsxJocI6i+
	uLSn+RHpyG1a/vMoSD0ROl1KBGLa0iHMoO9OlxHQSxmO5CrIQ2uimGtDu9fQF1mHpmw+I5
	zYd81x06xTZKButntLRlvYJaB+qpi50=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=e5AadE2f;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783310313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oPT5GCvBZJJjoFBxUutZLl6TvHZ6APGzDMMZtlpoCkw=;
	b=3rdlss6OAzVXgkdhrWVknz/jbWnBYv6wGUc07BIXdUiXVqhbv/Ti346R8+v2Eg4VTK7W1z
	3nq3MjBn25eSpXkdDdgpMd9wDD5ScMuV8iRyns2FyqlDN0IegmQGbtAFXZ9Kfj46mpP0nV
	dt7ycQj6OzhiSe+cBPE6IhkVzej2w+U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=oPT5GCvBZJJjoFBxUutZLl6TvHZ6APGzDMMZtlpoCkw=; b=e5AadE2fcatFwDztki5HGa+1/w
	ruYgTHD6EzgtoCJFe8FDTdnLA3F3wPwBrKOjvHa7Cd9k2CId4eJNzllfe2WPVV9rBRnQ2fI3KpsSI
	BFmEx/25BqsNOM2ttPLVOiUIjmgGxWW1XIdxkpAYjm7xwMB32fbTG2J9aw4IIF2d0vgvTeNqupAc6
	NFVZ/nmN2C3ZyYDVu9+DK6C+wp53CCbC/8GO7Z9svPt4t1a9Z5RqWKsYEfqE5mcT9UoT3277OFawh
	ubWmItj47cMWlq/w2FsSgxtNJY1iKy19UcvtUN04qT3/z+gdQ9TQUhXrQ3spVbrGqLFEEsk/uK6Gj
	GcGv2VxQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wgaTU-0000000FA9e-1f9p;
	Mon, 06 Jul 2026 03:58:28 +0000
Date: Mon, 6 Jul 2026 04:58:28 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hajime Tazaki <thehajime@gmail.com>, liam@infradead.org, ljs@kernel.org,
	vbabka@kernel.org, jannh@google.com, pfalcato@suse.de,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: nommu: point to the write iterator upon split_vma
Message-ID: <aksn5J8Nr0JIsVpQ@casper.infradead.org>
References: <20260702012546.665383-1-thehajime@gmail.com>
 <20260705152708.582fd8d87561f600da23c0a7@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260705152708.582fd8d87561f600da23c0a7@linux-foundation.org>
X-Rspamd-Queue-Id: 572A720002
X-Rspam-User: 
X-Stat-Signature: yjs65551rtripf8epriahuzmgguiras4
X-Rspamd-Server: rspam03
X-HE-Tag: 1783310312-315851
X-HE-Meta: U2FsdGVkX19NB/AlFo00IppXfvbjg7CaWR99pqoSPxhY+m1lUuX1VKinblCNxJDR61Q0Wtdzh5F2eSEQ5LnnpQSLI2zWnKZCsIVigWpmreGembsyKUZB264EY+iBVWFIxv1NUpyKY0Wro5tylLUSwEEwaL+qt0FpvkS7EGb9w/OHbBPB2U6iXlM4B9B1TCgGObOEkT8lAzC/oqtcNUCyUdGo1K+XvrsaV8lUNTqSlKKZYAfBjsmckGJehla084w7MbMJ9YwW7eF4nLqZc2pIzGSZJ+D65zfy9OZe0oX2+iLLk3q89YMukEQ04N7aZAF2o11O0LcT9SkhKI4BwCG5c41qUESfgjvmyl8nX8+QE57h0ZkhKE1bSnwNiFRxXLqi0nJNtwmNkDvhXKUASu3ueVHeC/8TiJO2KHdXsnXwuA9gmIMH1w8CmDGwmPYVI9fqO+nGp+uxtBafPQzDv9GqrF221/sICcVRUUh5TraVArO3+AGvlsI3GO+9BgIA0GEbnvNiz8QyqPQUw6AzmfnGuGI2Y+GyLSWZrAKGYXS6pk4zrrkJAL4daoM8LBKAffrlmG09SinIhZhO1Y97CV7VIqHYQ/U8UWyIfI0PhVf1o6zjm/PsWyBY9VlHQWlasZDjy+9kscYTV+npW/5XcYKHUbsLQx+WSHYthnY8S61EoBk8HXv0rp3mvkCqVTFDnD6RDld2jbx0XgWWuKTQSS0YIPpC62bz7TxvfPERthP6Bv8m2Oi9HZ0ESgT023Ha/EZ+ALMUrTVvBw2JeFnXTpkZ83o8l48z2JGR2taBuwTDqzjWLx75oYgP/Qqb4PhbWzn+t238he5zBXRrSDzOm6NVyvherme9QZZDSmnc1ktmZNg7FG+nIgovVFKk6vbW7yTlLw3uKBbpOtz8xRYbm38Cxas+WKkIqzSYdovSMuElYkV14WEFWEsARaxfN8BcC4F8fgO49Ach+Zhz5jkU/Jd
 /Xm5w7TY
 KTQ57ieBYYK8aYx/x26oDIevAE36WnInbtHkT1FVbCFfSfQ/4xXBbBjI3F9Alvlx0y4ZkPa/3gCAoAxvnRnFNVNqnOT6qF1osXy73qx8N0ZO8Mp+U1UVqtlVbnPYCAiD9//ramvKdVyaPlnfK7r/j0EhEyAlTkHJ/pC6syvoUQ3yINiJWaftbLVgaBLYdCc6MHrT5UtFJbycXWMkyt8krtyOfGAA6Un8hy7y79/JiqMIBh9rnX+7DB9Esi6x+6jGtvWSiwKlSJx0jq9OG3cWR06DtYffdg7MtdWcqUwCWHOcrwJAfxz9ay6cGig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 05, 2026 at 03:27:08PM -0700, Andrew Morton wrote:
> Thanks.  Unfortunately we aren't very diligent about the nommu code
> (are we?).   Perhaps appropriately - clearly this code doesn't get used a
> lot.

Should we delete support for NOMMU?  As you say, it doesn't get much
testing, or presumably usage.  I have this quote from #m68k a couple of
years ago...

: I looked at nommu very briefly when I had my 68000 board on the bench
: but didn’t get anywhere. Also didn’t try particularly hard. I think
: you are better off with fuzix or OS9 if you want something unixy.

(i suspect Zephyr would also be good, but it doesn't support m68k, just
arc, arm, arm64, mips, openrisc, renesas rx, riscv, sparc, x86 and xtensa)


