Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB6CDCD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 07:10:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D52DE6B0005; Wed, 13 May 2026 03:10:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D03A46B008A; Wed, 13 May 2026 03:10:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C19BE6B008C; Wed, 13 May 2026 03:10:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AC0556B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:10:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 49D17C2781
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:10:53 +0000 (UTC)
X-FDA: 84761524386.04.8B73180
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf09.hostedemail.com (Postfix) with ESMTP id 67DCB140011
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:10:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F3p2boEX;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778656251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D8/96t3AS4EVMM7ngllBmEIAjLU8QFYVrfM+jWZ/9mk=;
	b=GROX3nD35q4jEBsF9as0OrE/45LjzljlfIw5qwHwe5qpYU+0NGIfBrKTbRvCh/5deMCTFN
	+GhxmMSe4hedcBtUdPuvkiRR3dp7sY9s3tzTWyX5vb+saAlVHRNeJYoFByt1m0ClcWhUnl
	Xz2NjqQk1m4/ReXWLJhMkJ7YKKLcHPA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F3p2boEX;
	spf=pass (imf09.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778656251; a=rsa-sha256;
	cv=none;
	b=O70FnR9571w2DP9n17Tiki+iDsCjKuP1hB5SpbZo0bSgiLK5NyLls1XYEActDzwBh/KCvb
	cG93VHfNCAhf8wbKskvpkBY8+EJfOK7UPBnFRj92jaSpV0sUKFQJGd46nD8ghbkaL7N6Jj
	KCYCKx9GQYBc/mN41kpjvlPvQKYHzYg=
Date: Wed, 13 May 2026 15:10:42 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778656249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D8/96t3AS4EVMM7ngllBmEIAjLU8QFYVrfM+jWZ/9mk=;
	b=F3p2boEX6pGL9l/lv1/6QFbtm727U5Z2JiMUU1imi+DkQg4S4WR+4+FxLe81IGT1uCGZrj
	iqJXi4ZkeqDrqszGvv7733yF1IC8SSr/lZYDbWup10ob65hTJxwyadv+OpACjnemBkg4xP
	g1U3VSTOFAXMUgjzxFG9cnOcz8WWnp0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	usama.arif@linux.dev, baohua@kernel.org, kasong@tencent.com,
	nphamcs@gmail.com, shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/3] mm/swap: rename mm/page_io.c to mm/swap_io.c
Message-ID: <agQj8ixCgHZ1V9k8@MiWiFi-R3L-srv>
References: <20260512104201.716213-1-baoquan.he@linux.dev>
 <20260512104201.716213-2-baoquan.he@linux.dev>
 <agQKS17GVeAxXYHG@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agQKS17GVeAxXYHG@infradead.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: xf91oa8sw1cz36uspomx3wkdw9dufp8k
X-Rspamd-Queue-Id: 67DCB140011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778656251-513880
X-HE-Meta: U2FsdGVkX1/rVBvA3/VwE8pJPIS8ezupgVvlz9iA1OOQp25S/V0B27rH3kz6LvPx4hRhW/RLaKdcFxyoVYAUlBcRpi61EKpfLCdAyXEZeqw71BlD9mDU3lEuC1CsjgdWPBbW0zXlTIQa4ioNU4rPLuus+TWX51ZNWNhzUTJ7kZRZGOjXCGVOmxq4z010h+FfgdNpygapMvAN8dXhr5NDw6TIeT5U02MIX4a+5sxIHXBLVCz2TEkn51UqGzCHKUdoAGVpMbXLBXm454smrAXPrzUpoHKaZ4A9H2RoF7maSzPlL3a5d+Y/7ghe+BhZ3HTm3Msy7j5wN8VXL1++7+xUlj5JqmAopTxCQaB/X7A/SgIDS2S5lcbzgN5cn8ycZXf8k4d/AGAvUzxCo7EyEZpmepAjgA9kN6ESY5nilRmW8SbDJY+EKDNGzY9yyVly4atW0AzCgusxyHaeCtAZog9AcmVErASO/OBLDibxaq+vCb93H5ldzeQH04idygPn3xgZHjHPIM54IqaVWwxtB6y4M42w932Hx1j0QidyMdbgdSkdLjVztTh4xVEmFA+ZHGcyu+Tjw0pG2eKeYkxFY4FbbNnx08LLV4h0R4DS8Z3HxTwbOKoGLb0a9qyikHG1YjE/kxdIvDiWLkvdXkYqF6r64bQsm7bVaZm4PV2QiE0UjfulmzNYsEu1UsPBePrLEuU1KcTbei10bHOGe1Y1oEnNQwBm/sbYJsS/4cdF3hhLCoLuppT4ptlBx02fqidFhGptXqNnrAhHruSiwC6XPGZ6IYuNZLumAG8AsopoGHa5O4nYQwvOsmmDd8ZMoBDx3YFaMIDdb7r/b9PyCptPIK1RJp8tq7gZR1ONr4L6ar6t4HWij0nNmuYMpouydnrXt9yJ21lE6Q9I4KKxbeXZa0cSqEJwPzzXyYnWgg8z3x0nmgu8JJTYTsjRAEv0dgYXyp9idFLPxCBIIJhXsbO92GO
 7btPnp9P
 MYxpoh7OlcbGsSZvaAUA87muG60f+eeGF/7ohxBgsC2rIAhoRV33pqNL5Pz3lHamOn+YmQ7/dvqj/xzRPk4ofIbeqF+Y9UxPtz1o3M5dtQ3zN5ivzrkveOCfZK5HIn77RC6YzNX0A1qTK3Lgk9CaCRJZMjqYBWGAyOZWLVP0TLzp1+fMb9vKEvohLfSCrmJwnd0uvhfsjugcRzK9J1AiEDy5GULWgrbNjhqSCq6u2acgz0fHiUtU14kxlN1R52wjy7MPflZlZ7u73g7KkuzfuwXMxnjjIYwXaDQBQ7WpEFPlireE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/12/26 at 10:21pm, Christoph Hellwig wrote:
> On Tue, May 12, 2026 at 06:41:59PM +0800, Baoquan He wrote:
> > Codes in mm/page_io.c are only related to swap io, it has
> > nothing to do with other page io.
> 
> That is true.  At the same time it also (mostly) isn't about all swap
> I/O, but specifically about the block based I/O backend for swap, and
> secondarily a little bit about helpers for the swsusp I/O to the swap
> file, with a little bit generic swap I/O wrappers thrown in.
> 
> So the new new isn't grest either.  And I'd rather wait with this until
"So the new isn't great either." ?

Take it easy, I can feel this abstraction falls into your area?

> we can nicely split stuff out - the rest of this series is a good step
> toward that, and my swap_activate series is another.  After that we
> should be able to stop creating swap_extent structures for
> SWP_FS_OPS-based I/O, and contain struct swap_extent with the bio code
> and actually create a coherent abstraction.  This will require moving
> a bit more code around, though.  My preference for the resulting name
> would be swap-block.c or swap-bio.c, but that's up for future
> discussion.
> 
> Can we just skip this for now?

Yes, I agree with you, and the swap_extent creating thing sounds great,
look forward to seeing it. I will drop this patch 1/3 in v7.


