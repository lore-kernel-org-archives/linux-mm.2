Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 637B9E87842
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 16:27:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 992846B00C4; Tue,  3 Feb 2026 11:27:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 916CE6B00C5; Tue,  3 Feb 2026 11:27:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 815276B00C6; Tue,  3 Feb 2026 11:27:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 696756B00C4
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 11:27:10 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D1AA1A02A1
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 16:27:10 +0000 (UTC)
X-FDA: 84403675020.19.2D34E6A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf24.hostedemail.com (Postfix) with ESMTP id E556518000D
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 16:27:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=TCCIYGAo;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf24.hostedemail.com: domain of BATV+86a917d310add611ad46+8199+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+86a917d310add611ad46+8199+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770136028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ihGhxkBey6kFkwXRM9ITv8oPknMKk924ge/1joU7ljM=;
	b=xA5FM1xbUnSqpJo/2vuvNOVaKO3a6UMa3OTAXZPUHoB0GNpe3xjcRSwAocvhINvIEFad7u
	zansxQUJmX3B8ob4XjJrxNS5f6U6FeXreSNoMkTJVC3enxLs8N2Q/Kwbr8zmgHbU9zF5zk
	zYjVKwIPSboBDUIEj1XgUR4oUi5ytFo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770136028; a=rsa-sha256;
	cv=none;
	b=55S5h+OnxgyviNLkW7PLM7CNPPKsN9E+I8HHTXfaBh3pKqXjr7xteoKuAjyWosKmNdlXNq
	yQjVZbM+71/DMNXhGA3lRYFKUpUwsETV6fioyrFttfd+7IGSnVESELo3krJxOmnY1EJJdK
	LslEE6Y010p4Sgqkrya9R2xKYmogcBE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=TCCIYGAo;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf24.hostedemail.com: domain of BATV+86a917d310add611ad46+8199+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+86a917d310add611ad46+8199+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ihGhxkBey6kFkwXRM9ITv8oPknMKk924ge/1joU7ljM=; b=TCCIYGAoplBTxL6XkOxRvOvNi2
	UlLDnjKkx/25zsC+QoCIOgNcPp5da1kybz4nlM06M5gCgJtrZs/yPGT0MIg5/mMjFxeZU4k6iQgj7
	rGlgB6Yq8EYJYaAY9s0Jx0uNvYpqM9xz+jYofGDNotF7yr/Lb1PNv7E37bfm93rX7dhO09n9kYlUZ
	N9BlXspmYgizFF/m2xp2LMbdOv1JPWigOKkhXbb8bKt9BgulFyGnchxLc2+flp4lxc7h2V7WdQExw
	DL63UjGshaGMhxPRfERbSnW23i2MG6lstrdmrotBjHGJohLb/VjLATOpysG1lLmstp/nKtO7yNodT
	eowXEsvw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vnJF1-00000006wqF-0RFm;
	Tue, 03 Feb 2026 16:27:03 +0000
Date: Tue, 3 Feb 2026 08:27:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vernon Yang <vernon2gm@gmail.com>,
	=?utf-8?B?5p2O6b6Z5YW0?= <coregee2000@gmail.com>,
	syzkaller@googlegroups.com, vbabka@suse.cz,
	akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com,
	roman.gushchin@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [Kernel Bug] WARNING in mempool_alloc_noprof
Message-ID: <aYIh1wPm7BrId9dk@infradead.org>
References: <CAHPqNmwK9TY5THsXWkJuYCdt7x+mZHPq65AUOLZJeMp-FdAMvA@mail.gmail.com>
 <aYBiza9L1hmhmXbb@hyeyoo>
 <fwutwpejyptpo6gqv75zanqciv3fmxvillomwcjvtz4auebbc2@vazub2ct7pa2>
 <aYHFZ5OxfL4j-_ze@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYHFZ5OxfL4j-_ze@hyeyoo>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: E556518000D
X-Stat-Signature: d5mtag484tn5bodsgcujctronbcrs8rw
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770136027-410948
X-HE-Meta: U2FsdGVkX18LgA9p8qT/F7aASsBTu706J0dDQwaqpg3hlosxhoPJsiboWD8I9kcGtspWGeFlhp4ZN/T4oCiD3OTPC9hB7XR1ShX4NR3T/yuNcwC6+LtpxlIpOxVm6XYJ/d05cEyJ4Z5+d1+oV5J5IJ5sPDcHFR1X7oG3BfFrHlmhWAsgBtLvrxJ+qQ4vMW+1y7IKIUjucZygMHNDhGKE7u+usUMpYzOo/Nqq66Pg+YQk7VQgphOgUUWVRQ5VHEg0A329K++vIbZoqvCvQPrHE2B/xKHBVY8iUiQJfmToIV8fkJyaTtzAN04eO53arf2SUmfPxO+PAnY+kVU9DDQ2WXNauxx2vkh8Bn6Ev4NpFK7DDH/iLXtCcrHAfj5Ce7/AWkFc8pmlHxRlTIQgEORzfRJyungCEmvUAsKT4Cd9hKci8Ei7H1aaxTw5EI+BuxiBMttPuvr5bVJM7gz2UiQTHGRhuMU/SzDFwfu2TKbjgPRW1cIrGnhmlQyQ1j832OntjxqfDmmqMPcPcTMXq2J0jXoxnCGdK/8kP3cZ3ILIaCpelM+mFz2qHIRie3vFF6AiIVsh9NKPi59p7veBNwf3v0woRrKstHpE+LvEYRivRSE3qv7lhBb5wPU1DYTwVFDAugp+k+jmCvRac/X+//Bqk4/q2DWGnIve1pCZfbtEIC155ez6s7B44/1eB76CqSwwxoI8wEJA29SM1LVlaguUVbAC5QoAbvApCfvWq5rNti+zpwO/pZJ7t4B908N5vEIhGq2HMgM075K5Vl2ys5XUrZq1wmoU8ytGCBQ0YfZAkXH3TnZV9mNeEbvpMdQrFSQWC8g8fOxk+WQcC6813v8AJELekjJxb62KD9uamjpuXfAObhW3UGMp/MlZwpOWnOCTr5Ezv7h+9Alc9UbAtwefSCWpsrK4X4DvfO1Bo3yBnHLs5FhCWoK6iKH679urHesHn1uKyg9FKU38DhpeB0S
 pmczMBSa
 uANhG9mEWgLr5yYtx+wThkYlerBNNu7gL5kFymTulV973B3oiNAgAssVYZGb0/NwH8D2ykWAPQiSAHa9O0MZ+j4JywKsS/pS/LDrK9zNiAd4aA1c2aYpXEzspGo9StG32l5n2nMO0CJBnd3j20TQca/AMADrqOT4NEkEyNOYRRpvihYw9KJRTp6ra1AcpFIIZeu8PDX8u7W74xz0/A1oui/2PxLmq8SNxoUJmVQGiXqQdco1W7ajEVh2hI3LF45qnEWUgfNDYO24+7ksxKyjMHrLk9Tep2tLE0geefxCcv3MSMXHtmtwJaM6Azc9RTtTufBjqAq8Qz/c3fhIKq1AKXknRJ/m0jLqDWzspL4ArIk1VMkMUOB3xZg4ncj+MYS6tEbdKY1vjnjBOBbiw8P+xVr1uCE62PyFyq9mutZoOefcR/E/Uno9oMZ1xyiP2gbKKWO5GmQ3Avbln09vQRWrBgpy1RvU67KiLN1fBPpwgNJiqtfOM0iwdzgy+sisoqq2cTQzqXuAbt04Z/b2mwp2drPOIRH6Wj4/M/o6Fb0ZJFf5GShY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 06:52:39PM +0900, Harry Yoo wrote:
> Maybe the changelog could be rephrased a bit,
> but overall LGTM, thanks!


No, that does not make sense.  If mempool is used with __GFP_RECLAIM in
the flags it won't fail, and if it isn't, GFP_NOFAIL can't work.

So if there is any work in mempool_alloc it's that it should warn about
GFP_NOFAIL.  The fix is in the callers to not pass the flag, assuming
current kernels still do this.


