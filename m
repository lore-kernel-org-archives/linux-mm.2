Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37622C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 23:05:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13F3A6B00A9; Tue, 30 Jun 2026 19:05:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C99D6B00AB; Tue, 30 Jun 2026 19:05:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFB826B00AC; Tue, 30 Jun 2026 19:05:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BEC9C6B00A9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:05:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 290AB1C4E19
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 23:05:51 +0000 (UTC)
X-FDA: 84938113302.02.9D2E48F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id F348E40008
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 23:05:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bHw3MuNC;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782860749;
	b=C+t7FZGQQSEdTBrih4NWMxk42ffcN+/JjCMtV3xvgwe0QtV+jJU1VzW5wPqh5iQr4UzZsU
	Dz8bmXJAbWfIVSnTflpvAmLiXuUZKd0lzYDTuhx9aV1lk1gzpH44r1Mb+/OwdgybUtiCJu
	nFwn2wvEMNqW+LH1VaxTYgwNodk5wEw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782860749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yF7mDtx2AH+vn8tJJ+WL09Iu/3QgFhfiY0Vo7XWhG24=;
	b=zNqTODB0+FQ2bsHMp7Y3q3O5FEFBD3YsOjzF8liyZn7p/oesmfVAWTYT/cGRYjfjH+8BVC
	CwFybHQhx2QrbPED2zdeRqCmP3U6YgZirAiqBEXkTRcuYoVJ56759+9JUgZh22rP0Nl0WN
	QYZb89OM/GVbFZfpdQMPDLuffR6jqx0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bHw3MuNC;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1390742B8F;
	Tue, 30 Jun 2026 23:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8231F000E9;
	Tue, 30 Jun 2026 23:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782860748;
	bh=yF7mDtx2AH+vn8tJJ+WL09Iu/3QgFhfiY0Vo7XWhG24=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bHw3MuNCIP/NOUtn+SAEa2v8rpButWUubbrHpqTfRURs0wCe02+NENOdJi5BpE/pV
	 8lgVHaC9fMGshiNN0Tq9IN1LZaOnl8mdaoePXDduNVDQA9EPnvlyFbwsL46ZYU9Ho0
	 jOekYB5+cuw/Z8/KyxDypDgSIIdvmcnCV87kAp7Q=
Date: Tue, 30 Jun 2026 16:05:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 maple-tree@lists.infradead.org
Subject: Re: [PATCH v2 00/19] maple_tree: lock checking and clean ups
Message-Id: <20260630160547.9a7c131660665f3757599720@linux-foundation.org>
In-Reply-To: <20260630190843.3563858-1-liam@infradead.org>
References: <20260630190843.3563858-1-liam@infradead.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F348E40008
X-Stat-Signature: 85u7iswz3try39gi4qnafmz9sk95esit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782860748-574780
X-HE-Meta: U2FsdGVkX19hpW7RX5TnyuuSD8vkM62YMzFjS9JdvFEL+SuZuYmU50bsFSiZ9bRvlbQx4YSq8uYmqCL50GsEp1zirWSHwGjeRRkEHpq47QFH0UzMnqeyU8aEmRj0xqRA3ygEwN0JtbEQgewMaxQQZOHn8hkyI7D9Mju0ttaY4C0koJ3jXssWFYDqKAkYvWfkmA3ZaR3AI/zXH0UAHu7RD5QcccZiX9cD3WUT8FwJxOV7EbU5BNvmiiudxQZ2B82LbbsXAnAmwE8vKIKj94i3PZZ+dLtsCEZr4mX7J4Ql1NaF7Lbg67VurlbGR2LKqAkF6hmAa4hDs2mS1eTvypXyui6ZuxPLzAIOzf1oozL9fLtKg7qXWsS+Qiu9fBtvzh2Q8eNiepWCFLQiG/fj1oIRNYcKbNJDrityuqeY/rBXeaPBivDa9CDnKCscF5E/KaOC253SETJptiAxPEYdXWcEB70WSqNspxKqsS7OCq4T299/YVwQauRidyCaZP+dBFi1/bOwHTzHtrUKnAUu0xZ87qiN6SSml4+mSgftqbyMw6Uxl0H43skRP8HYaGEpsbALAn9G6HMa7FxgHHANDtJDfzxmEwSssdzZQsGx4hwR1BogybhqYXtrJuV7OZZOMw3xnuCOtlFLZ5LpnUPXMv1ub3GI2fihcfMN1IvWTACromh8VohmC0N62mniYcGVFBsmaL3Nj7z9p3vOc6ncdADNQRIHsh+eRR2tdcONkcxtZ6B/LkLUS5cdi3o9rNeAETa1m7h3nEXw9M2yR1pTiltBDI6bs6ou0JGbQh2RLUTGCEyZNoBtqUK5x29gWi9uOY7C/c1PojX+uStkAtNx3SK4iKtfCE8aJ9bm9LIRQ3wwYa+pYlhvMvlnmaaMOVVZxIUiyxjQAsyYvYTEOY1yG2iOHuQ1QPvWVH83LzskhsUKdQJYsHccwl2sBi13J3/HDwOhuXIDsC2vjWXDtkkyB0j
 j6fO7d+i
 DJO+srDM3GegwP/p8fWN8GghSNmuYg+UqzZJ5mNWC19VgsgBgmH/SwRH1KPNr1lS6490QrNMlwzy3YEp+gamGALD/c6L8XA83O8UYziFB5JoaIAx2SkIUrBMK6mXtZZ3gzR/KB6TWDtPBHsDlyLvWtZf5x4+8MZoO693cfnAjeSv9uC/1+SyCN6SA7CPkLYmZbMEFF3xTXqRiMJrz75bdPK1RRgNcqsJkIkZoV+oWsTPx6hAsstlfgTvKtAhBarOB7uHECKVjoveK/eMbXfejqJ61cNrX74EjAXaagqThKB977J3i57Giunps7ntdCipXWcbZy8bbqdi4xIc713FOZy5Ms+gvWh2bOCHh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Jun 2026 15:08:24 -0400 "Liam R. Howlett (Oracle)" <liam@infradead.org> wrote:

> The goals of this series are:
> 1. Lock issue detection
>   A number of syzbot reports are incorrectly pointing to the mm exit as
>   a source of the locking error.  The first three patches attempt to
>   help users detect errors in their locking - but they still have to use
>   LOCKDEP.  I guess it's still down to hope and prayers.
> 
> 2. Documentation fixes
>   The documentation was lacking clarity, there are updates to try and
>   help the users, especially around the erase() cases.
> 
> 3. Two benign issues
>   The cyclic allocator may have a race, although no in-kernel user can
>   hit it.
>   The erase functions may cause allocation issues if used with the
>   incorrect locking type, but none are present in-tree.
> 
> Beyond these goals there are some test fixes, some general speed-up
> patches targeting extra work and cycles, and dropping dead code.

Great, thanks, I'll add this to mm-new for some testing.


