Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF6C4E6780F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 17:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 081516B0088; Mon, 22 Dec 2025 12:52:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02F8D6B0089; Mon, 22 Dec 2025 12:52:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7D876B008A; Mon, 22 Dec 2025 12:52:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D6B2F6B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 12:52:52 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6AADA1402EC
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 17:52:52 +0000 (UTC)
X-FDA: 84247852584.24.32D8F78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id A9A592000C
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 17:52:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZJgMsl1x;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766425970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DXY74LvfZOn4UcYWHTmAAzPXjtby7i8uvQhxZnp1eXw=;
	b=w9VYsz1zHK3tXZ0tW3zGOyr7onzW9XahunX/mNVFf+9kyi/TDuCJnay+RJfb26QzOR7yrc
	Wbv87OKRpbv7J/LrZ6LoWklXFhiV5rF7ZIaoMO6SJIJvJcIhkOFfab5mOOaPOKVqLpDZxY
	NRyVzoz6n1ebYlCnhFfG0E2xMXasrG0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZJgMsl1x;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766425970; a=rsa-sha256;
	cv=none;
	b=U4VFDL4V5gkyvwXWxBFOCQX1Tju/ikW+dDTsIw9RvMFFpBUDsPObMf8CwOG7slY+WilWEn
	z/EqSpdJTw1piCVUVvLt2A+45QP2hG9HnYDxOJo8258oYJa0ur4LuCYrhwFVxi+p+XYBi5
	LlUetvbosc7S4OzQrzOnuyJQAwdqa9w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 730E343EC7;
	Mon, 22 Dec 2025 17:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE34C16AAE;
	Mon, 22 Dec 2025 17:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766425969;
	bh=rlzoTfpyf9PpVwlnz01mvkSvaJh6hgnqgbr6vfVuT6Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZJgMsl1xjc76yx5Q4+ZI5wYHijLg4ZFaOjaTyztprEuyHOMymivLJkBSVJT9QlhAX
	 gqxxDgMEAhZ3NPWqh6dQGKnuDI9zzHWMKnKzm16wuLH62BDWML3vPDxbpIt4dGRUnd
	 /NbP+y4KFrmA5wSbLkSAUtaawMf9MI7/6HKmFNqo=
Date: Mon, 22 Dec 2025 09:52:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: klourencodev@gmail.com
Cc: linux-mm@kvack.org, david@kernel.org, Kevin Lourenco
 <k.lourenco@criteo.com>
Subject: Re: [PATCH] mm/fadvise: validate offset in generic_fadvise
Message-Id: <20251222095248.18c4c102abcc8fb4f61c7067@linux-foundation.org>
In-Reply-To: <20251222141817.13335-1-klourencodev@gmail.com>
References: <20251222141817.13335-1-klourencodev@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A9A592000C
X-Stat-Signature: 3tqxi3qmnizrtmrjac5nsw6qmzxpei3r
X-HE-Tag: 1766425970-778851
X-HE-Meta: U2FsdGVkX18/R+LqjUAS42qic96T4orxk0JKI3T6pFdoz63OKqVX4YKnxHdcxDlfiEj89TQxMHULLiJLdgMzCd+jiwlrpzmQZoaJYLGcvDOaeY+z3h2Yh9Z96HPVcDliBqnFnGKFdk3t9KFo/+7BJexJwfsadxIFGlbT1Mgs36uxevrWvRQi+oZ5aysKrzU+842aXh6fOPfEDGU84vKGLHhSwqEGD9HUjkQZ+9LtdzlJTcZNOU/qmzGwVbRNoBLbSL85vnIbz0se4Pa0iO/tIGvpTIetEEyQdksjrhWImw6KUexdfOHkYWV9Ez8kMDlVA+8ImjWqLhn9djWMnLzTn9oF+kKgiHfK8TTDw0jemAsH8iONWtCHbrqGO17Ljv0zRg9RxPqWC2ygzwNxJ6tdUpSojoXAjg05AQboGaFE+Ouj7QimZs81iZz29t8+jg3X66Og2u4zQRSrDsnulP/1qugjdBJOZuqjTainid63q26fdA428TTQbSXuT7jH5BNCLuUvi6MNYZs1gJRj4ybC8SkYfnAswKuL64eLMihZeebe0LO07Hn1R125wzRVHIEZTvPe8OBB+yqtM9lcmbvH5sYlWehOlkZYklxN7cZieQgyukHfxSvV04VqDS6USvdLRTD6aQNEx+awyczDFYx9b1/E262TQ4zmlNXAjX1RhdnhMpF+60oberwS2UDtT4iDPr7VioqWKza2H23kfbXxo4FaGrA6zVYyYwFCBt6OxzZPbUO01bJGU6h+64OAeGGKAR31MHfe5oKnm0h9RK3ouYCi/oEUNlwXAo59KrMW/yGewSTy5/fLSLR0yKrWBoB/rlr5zKbL+uCjmvYv0twg7hXcEinBqxeEnjOYLvjDdrvAuKCrATcsESy1nW3x22zHyI0WzjXIV2L4Z66UtKMBtA9EvW6tTRC8NbM9mSTkL/GNhRDVdvfRyfw0N0DwvIs5JIkViRn/f6rPebj07B3
 SHqFFcda
 HEIeC93mm6PnDPHhOlJpZYcKpWm4/fZpbsNMHr4xFq2+oPV6awOUmE8abS5AtJQLekKNmvfkRJKGZmxaM55HobgFpTVI3cADZTCsB27m6cpbCT3MOBWASoIPdnXEciTe85Jhk1V67S+wC40xk8/sv/A2edQwyq9qi8ToC6YW98ipEGBRl8B4AHMcYnPZxXaKEwyka4kbQXvf9xHj1Itn+PmYN4UroP0Jjvb9uwjKji0p43DVUnpYF4SkCUGL8U/aQF957j6m1ReR0o223VLUcaaBZJs/tQPTKDLtn3feZX56tvrXcn9ninjYZlPA5e6sr/nlQ+GYZTmUTm7yqymAnDScjMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Dec 2025 15:18:17 +0100 klourencodev@gmail.com wrote:

> From: Kevin Lourenco <klourencodev@gmail.com>
> 
> When converted to (u64) for page calculations, a negative offset
> can produce extremely large page indices. This may lead to issues in certain advice modes (excessive readahead or
> cache invalidation)
> 
> offsets are normally non-negative, but the API does not guarantee this. Since 'len' is already
> validated, checking 'offset' here is reasonable to prevent potential system instability.
> 

Yeah, seems this code really didn't think about negative offsets.

	fadvise(fd, -20, 40, advice);

does make some sense I guess - equivalent to

	fadvise(fd, 0, 20, advice);

but whether this is how the implementation actually treats -20,40 is
unclear.  Probably not, and what will filemap_flush_range() make of
this.

ugh.

I suppose I'll toss this into -next for now, see if it breaks any tests. 
But more thought is needed.


