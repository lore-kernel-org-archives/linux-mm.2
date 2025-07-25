Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 417B4C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 15:45:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA5E36B008A; Fri, 25 Jul 2025 11:45:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7DD16B008C; Fri, 25 Jul 2025 11:45:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE2CF6B0092; Fri, 25 Jul 2025 11:45:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C309F6B008A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:45:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 77ED0113C95
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:45:38 +0000 (UTC)
X-FDA: 83703211956.21.AA4CEBD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9D461120007
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:45:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JNJdONl4
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753458336; a=rsa-sha256;
	cv=none;
	b=71IjxLiLkA/uw1MTYrynU0pXw9M9qUeeT8n4RY6nzcuR5tfIzJ/aHBGJ+yT+/vOdIHPWHn
	5ZYU255ppgob6VQXnhszJJPnokUdTA3kcSpholaHXyWGwYdl5z4x1jQXfzMFBEPxjQZA7z
	evJ7LZxdXVAymtfYkxTj7djUWpLuXfU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JNJdONl4;
	dmarc=none;
	spf=none (imf29.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753458336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=otUuWz9mfPFiVZUJEvzXYbOISqnMQyxkucKTmIZSSLo=;
	b=pRYziisvHrt2aJkGkmMPp4Mw9e4ZFcOD8nM8HssNl1kmt0Hfp7e3y3hm4W8kqFXo6fooNk
	FMQqGWJmFBsm0EwDcvvdgMh4MEzINaf5mHRBplRtF9Cb7NTU+/XxYT5NOPd6B0zkmIuvfr
	MkGVwwRL2P9jggFsHnuXPHYfQD5Bitk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=otUuWz9mfPFiVZUJEvzXYbOISqnMQyxkucKTmIZSSLo=; b=JNJdONl40Ij0yVJfj0J4ihq/N4
	AzSztQ4QnTxRNAUTMSoHh5dty/pKn0QZ6qoGn6cZQM3OQkPMyMZVrteksH6V4F/xku+IBoEByqCqv
	33KHCTRYK9bZe5ntZPaXv9KU7iCQoqydAUArH8iSFL2ASF4Mo85lAxBbTQrkaQ1IqNLTdW6M15agS
	uGkMR3VcvfHSfrnnWQV7Xt6fYZf1LUjDLPPkfVlk0JnUxqKf7y/4wXJzME8awFABT/iafB/tYCqwa
	+WMpROtkcqXH6M8UoklSQyc4hUD9CH/Spp7BZE62oYDE8Lm46YquCuUJB8kX/wFIekXs6IWIvI2zE
	YnY9o5hQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ufKbz-0000000E1ua-39Sk;
	Fri, 25 Jul 2025 15:45:32 +0000
Date: Fri, 25 Jul 2025 16:45:31 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Xiaole He <hexiaole1994@126.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/readahead: Optimize nr_to_read boundary check
Message-ID: <aIOmm8cejmAyvSZ5@casper.infradead.org>
References: <20250725152834.7602-1-hexiaole1994@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250725152834.7602-1-hexiaole1994@126.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9D461120007
X-Stat-Signature: a6abzsmimmnxc3pzqz6z9tdnx3x9587h
X-HE-Tag: 1753458335-195171
X-HE-Meta: U2FsdGVkX1873Mm+0SFOYe4V5EDc+eIi6+7Nab92ORuXO6BgqzkJY8juzSPT9n3X0ongwrYApWrtrggxcUyBYqkyH+FmlQMwxF09hh8MO0U6WfZzEzmi5q0zFIk+0t6AdjjitFXdNLE0uQFL5y1cgJsyokM/mXfsvCJAGycZiVOBvVrZEkseqf5TyxTgLbRpx1GzjiE4bqtS4egrUBU8ayDfG31fwXrdtpcJXDW2b5m8B14gAb6TsuLeUjsfVjeKVxZPdRlNwARf6+tD4TLsm+lzcRSnQW7vO/JJXVRUutuyhZMPMTYsPwojeYDFpl3CLlJm23ZOCxCmypQLpI98RaXfi0Pdk7MExjt3cLb4kOdD0kqVm/odDVZDRvnpNpCthnaCAHDLFdrWzVPDHV93uW4WRJtTTds/zH7a+yb6Qwjoaj97hjXTwMImS/e7wyoiiO7UeT4Gj/KM3VbiOKSYJeHouqO5dPJqbkR4AHMK4+9kA8pkY5+pxRr0/mMvu5MWCEalztsdVDsb3Z05Diy7cDDY9MkTKl4G02s//Pya/xGC0DWDpZniRzhD6Q9esISCsLQkMUEvORRj+epqCSM+PxlqejWGiUxoVh2NWOmsiFP2ULztz4k5jBAbqm9YLCxu1q6oqEjyq+nNgmLhjnFxtP2IS/7AmYj4MCXeLwYSU491xvGh2MiFzbthPIioaLI1FrDDEf/ZNQoGrnFK+6kBP57ymZJSdhw+YA64UBKi1hq8TcxARh0+cPpUGwYSX4jfmHoJFWcngbYehOwveg5rLpqtzQZHRh4x5SCCdaX3DawN6EnCHvOZ1cQ4LfsF+OFIVzP5PI5Tf4PdhWRhx/HV1pYum6zXQJwCCaUzzfq6ceDnUNAxWIsKi0rNbZ5L5HpigembAYl92KV/npZyu96GlcOuyAcHf56N7nkG2uLttpdO62gqPzHGrXL4i9uR5CV95F45ezEgko/DZHIuCA6
 jpHwFMtC
 PwMjYvJBRcaYu4OufVinnwryfo8LBWI+csGk5CQjTk9K3VNlJlKJ1vqQyQIQ8I/cBWMVSrbJDR3WNIoYue7K+ycpcppJ7gmcB7YvtrHk07aRvgW/0gmDAu6muJ+vuTJfRE3cNn1TTniZ24QwttbFoMti6K5kh6eiM++FZN8Xmk3oKGNZKsExyL+/PGrTCdjex5RFexHXdLA/OA980x+Als/5dh0MYxhdxq1z4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 11:28:34PM +0800, Xiaole He wrote:
> If nr_to_read is, for instance, 3, and end_index - index + 1 is also 3
> (meaning 3 pages remain), the condition 3 > 2 evaluates to true, leading
>  to nr_to_read being assigned 3 again. While compilers might optimize
> this trivial self-assignment, it introduces unnecessary logical overhead
>  and reduces code clarity.

But it makes the initial comparison more complex (by one operation) and
I bet you can't measure the difference anyway.  I'm not inclined to
tweak this.


