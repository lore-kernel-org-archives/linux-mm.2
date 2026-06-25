Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 546F4CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 15:17:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1379D6B0092; Thu, 25 Jun 2026 11:17:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E8AD6B0095; Thu, 25 Jun 2026 11:17:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F41326B0096; Thu, 25 Jun 2026 11:17:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C70B36B0092
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:17:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5A431A0144
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 15:17:54 +0000 (UTC)
X-FDA: 84918790068.11.31E096B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id DD9D612000D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 15:17:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=EYBM9tu3;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf29.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782400672;
	b=3pkCypNpQDxxuZ2BbKHWLUxJp5JGjuF2QmL7bDwy95WLWBLJ6QSkcXt9xhHr1DCXKITDiK
	OCZx/mHPslL9hYotbEBczKxGMu1/j4HVF7pVjAoHX1yTyEJ7TNyx8O1H5k2xu473ujI1OR
	jnVVlLTUu6mjukSZoBaf+AmIY7YFlg0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782400672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ho2osq0XeRu7S5voc4mfyO5ITrtAk2DlnfwLQFYApok=;
	b=AgjdCtqolCWKMQDpMIpIez33tTJx6F0CZpQYah9h6NAhrqL1dti4ZM1yF0pxH6A7wMOd56
	533yKd3JUxbKjjPrBJYUNa13fsEFUsJDTZG4rg4GA8TnRUYjUE8kBE8Ro0iFoKEsAIH+JD
	oh9ZjUMPO6R8GKCGbXyymbwzyqmrgbg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=EYBM9tu3;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf29.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Ho2osq0XeRu7S5voc4mfyO5ITrtAk2DlnfwLQFYApok=; b=EYBM9tu37PTqUUd9H8IHDUvrx8
	PmU+AM5y1CZBwEsTdHlnZoVjJ+HGCeqexTNPWYy+RXdzCvNJqzX/dqaV+9HkbzOCOmLpwA9H2Q+Ws
	stTpKBoCBgm0XS9YDt2UsTXfH0UkM+nWo1bC7kw8jCEpTS1ogKS/udgq0wDgwBJiGZHB5Hr2p2sRv
	AIiK22G7zkdK/yoT+T5Y9Xq2eO4VBNrw9CzHdebe3wmOTEQcwXcXimZknk36ideJRrs4a5rOZgCwb
	ejbIZm/rybKip5TtQ27O9m1CASXOkOe79fUxwEFcxk805v9IJYSfifU6v/omPQOeAYCkSwyV3lscg
	6w/4ZOJg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wclpt-0000000A7Ov-0Iwd;
	Thu, 25 Jun 2026 15:17:49 +0000
Date: Thu, 25 Jun 2026 16:17:48 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Barry Song <21cnbao@gmail.com>
Cc: josef@toxicpanda.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH] filemap: Remove file pinning during fault handling
Message-ID: <aj1GnMERF_j54sFA@casper.infradead.org>
References: <20260622192114.1147198-1-willy@infradead.org>
 <20260624065818.49975-1-21cnbao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624065818.49975-1-21cnbao@gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DD9D612000D
X-Rspam-User: 
X-Stat-Signature: ix8y73ifjrxx1n3zi9n5fyizdjjb84se
X-HE-Tag: 1782400671-60294
X-HE-Meta: U2FsdGVkX1+KP0KTm0Jc8/GBtHLHQBW9bnw9SUGbOa7Cl7lYR9gFMOFeeidEiA5ih5wCac9IbFhse3uOQrpxUz4GuSIvXS8o9L/Jt0JNkbPZTG94QQop8q/fs7Me5Q3ZUqigQCCwvadrp0jDhIEWIOX6XEe9qdpGpNOhEdN6IJ8bZuyW0/7Ykd4pm6WP6b1EApSzlXFAQG34LtvxZu2RxqXcE8Ha88NgYO2hKCybhrBT+ODVC8TuqWHuiKpnQzwMMPDMOaXAL4r6dTNiizk7Y10HPp19yorSdyZQg5brUqsjX3/HzKQx59FsjJHSAxxMS1qhvsT+g1/usmLhXVjGGKx/oZyL17TCb0xTpJIvHUAp1rLZxYrSWlov9odfB8NvkfDUJKrW0jF1Dlt1nEgLJEXt82HY/nwNO+5d0W/F9BWAroMX+JDn80XMq/937plzMNmdHJ3S9QBXkz2KogMgwSWurLtzD3LCG/7yQEzIxnVBGgYTnogXFUJRc8tm4tlmdnAVr7cTntRxYrTrCjdxLffCik65edND75e5HMoJ/FVBPS/epWBUcVIcUEFZ9Bj/oPN0vATOwsd7Ju62R7qACJDQEaGiE3a/w4/LvJWwE0dv+nDDVHsdEWV/jt1OBc9NSY3N1vBivub6vE8fG/maA6UUtNiBlK4RLayV1Mqy36IaQ+NegoWa4yUIkqQe9HOlhJmrU5TNMgl1sNcT2AvxSsVTftUepyQRd+/rL3v7VGTWbZ/fODLSUZR29Vrd6wk0DJsZIOBLdDlvBLOHbSH7wVACO8TMcBCYFFcGmGZgD8WFDVHp40ZMbUuXPNzOgrSFJLaK5V2xFuhRiCell1U40uMVbOGlYEClbTVoRy4khxQ3ZzR0i2L4YtyR+sh4PitYJX/ws8/XoBgBbxCtTNWJrHFTn1LYT5yb7vy9ba8fmBp0LSHxBGrIYXRd1yXLkWg44SC7XPelWmAjueXEQfQ
 c03VO3CU
 HTJKiK/HxQ3CLhYWEjjab80I9X88vRVzWIQAD3UxZv2J3waKCLUu9nKxG3TqziPTZIpkkgPFBm5FgNnc0ZRBeRF9t6ht82QAGgfaqM7/lOhLte4tCVJ2XJM4Y6C2BVeRJ1SUbfz7H+A0bpITe6x5uPDx+7eXMZjiBVDUa2ZIzKqueto3GYfDJv4fkDVj1s2CxvUblOOAf5RypOxpZhllt5Uk207fuwRD9m9ftgRnspMAhk/8EirFHesHJ7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 02:58:18PM +0800, Barry Song wrote:
> > Now that faults are protected by a per-VMA lock instead of a process-wide
> > mmap lock, it is far less important to avoid holding the fault lock while
> 
> We could have fallen back to the mmap_lock from the very beginning in
> do_page_fault(). And for GUP fault-in, we have always used the
> mmap_lock so far.

Your own data showed that this wasn't the point of contention on the
mmap_sem, that it was the fallbacks that was causing the mmap_lock to be
contended.

> > This should result in improved lock contention, although it is possible
> > that some workloads will find themselves contending on the VMA locks
> > due to them being held for longer.
> 
> Hongru reported that 82 of the top 200 Android applications in the
> China market call fork() in heavily multi-threaded processes[1]. It
> would be good to take existing applications into account, please.

No.  Collect numbers that show it's a problem.  I'm not interested in
theoretical problems.

