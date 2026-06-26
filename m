Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07665CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 00:19:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F147B6B009F; Thu, 25 Jun 2026 20:19:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC5686B00A3; Thu, 25 Jun 2026 20:19:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDBCF6B00A6; Thu, 25 Jun 2026 20:19:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B45256B009F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:19:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3DC241A029F
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:19:43 +0000 (UTC)
X-FDA: 84920155446.15.8F0137D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 80C1740002
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:19:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gc2i3YDn;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782433181;
	b=ObscdIu68nMws6W+W9tl+GlVHIhiZkd3JTtLJrrQ1hBuxoz3ikf7hTyyhS+Pg2ZS4bpqOM
	WWbO+MUe02CIHsJpNWqMkOPbkIgBzI1KjVwgTbB0evsM8T47PMQLAOs4muuULFiU/myGOO
	hR6d0UhyIzMKJTQFXwn4fx4g8lDV9nk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782433181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bdmk6ysU5Vfs4V4qQFRsUc7N0ch9cjdG8d7Ue6lHxb4=;
	b=7haQCO031AclovEKu5U+1fEXCO/m9lMxG7UwGe1tCiLXdqPN5IqObhD7sLBbH/APSKL0d9
	vBrFfh4ztou9wTzzoguyTRSg/HPgDpOqdyCdGKDDw5WjzAn0GymSmD+WLMYb4t5tnQL2tp
	/38MspNsgX3E2rJUeaC+5EW/Wdd7er8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gc2i3YDn;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 986C443589;
	Fri, 26 Jun 2026 00:19:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2511F000E9;
	Fri, 26 Jun 2026 00:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782433180;
	bh=Bdmk6ysU5Vfs4V4qQFRsUc7N0ch9cjdG8d7Ue6lHxb4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=gc2i3YDn1nNLN2uJTB5gYqVdMLQIyTfe2yyigsqFYWWAgcE27LRzzuF3hOWqR2Dco
	 YxhfgezIy9svp5og64V0G1sqcSfHSJVhfIMUZmNVDfevF/xxhsnJVCKq3IgL8UvEJc
	 xvfJrQyjlKvQ0fyUj4hXnbwAr/N82rtVKlDdLrdQ=
Date: Thu, 25 Jun 2026 17:19:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yichong Chen <chenyichong@uniontech.com>
Cc: vishal.moola@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] tools/mm/page_owner_sort: free per-record
 allocations
Message-Id: <20260625171939.6b920a87159a1cc695ec4de2@linux-foundation.org>
In-Reply-To: <610C3A89A09303F8+20260612055017.632263-1-chenyichong@uniontech.com>
References: <610C3A89A09303F8+20260612055017.632263-1-chenyichong@uniontech.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 80C1740002
X-Rspam-User: 
X-Stat-Signature: zp56pree1rkndb7si53a76g7pnnn1dz6
X-HE-Tag: 1782433181-108942
X-HE-Meta: U2FsdGVkX1+eXpfqPmNlleIQcVFgrjyrEFPXdm/mdbteUL8cR3bqmwEliXWXilbF/wlYAPALZ0vxqO4znNKz4HTFVDl/wf8V0SQGIck8RJWiYO538EwPrIroolGO1r4zvirOBlehNkn/pIxsaW7e/xOYA8rBurBrQzvj8cna7A3SjNaYETukTDAXN7iXN0CvsOsF9w1riBYBMH9GHVznkZ1FgyjLcnWk+nBqJCAp+j4Jk99D7C026RWuXXXc60nYjwXaDA1B3LHXmFEgHml7tUyiVdQcHK50aQtanxmA2IMTM7LXvhQBeyMBYG0IwhO7tkgoFKnoEntMYzodi6DXy8ijgPp9NCdiJNslRFOBaeFYKDb7qyQd1BxXAkJH/GfCG8XztVWpy2F9Ux/Tq5CqayLH3joVES56grBygIGpvh6SQYZOtowk/F0sWAVXDC9vzSYH9Y768ET+P+uAKAXWI0wU+gUVgNyP849JFBhNE4Eww9jlExshUkKn/YpUg8ziIJMSLiFQGE8isy8Kviyrv1RNVdXvp8qqll1zMUffb394vp8cyReZzdys89vply6fq20GwLq2NRNKGieF2Cm4ZjFTh9yEMu0+BRe+jzxYZUyLfs6+Ah0Cq6NxVG7/BbbIkxvhcaZDXcJV6HLI63k6LJm4KUqCVHvCVN5H1ftGBlYUkRkC1L3qeJV2CJrT9P4D49NxOMbGdKXfSJMs6p62wd8BQegUbfOc3TmhqWRf8qykxketmpKmbWTZAdtttIAcu+RlVqD0CsmiN//L7vkMb64+hx7ury6b+jIuJ6HhuByRLhxvU1Cg1auu2bfMzSzopic2YYpOCqcl1Ip8rbiZ61RFegnvrjTwqf3OuX+OL6twyRf57b/bOrJo0GmxEwDhsmpUT/dAZx3PKSdVXFFgEOMtYpNxXgAFYrLbJ2nHhtgYWm8tFZThfwX+PGrI6G8o2gLNPa1h+NsnTqpc2IE
 VgaPMna3
 +G9yefgyPHWdN6MDdGUEw7qeErxCLO1/CotDSHHakPgfmIJlXdZfRf9ZL7L2GLmQCj8shZNdXGRALyQcHsWwidJdDcTyHPWboKlgGfccOWrHcY4JEWlbXSPicKymT0NKVeKpMWct+GBSuuLeOSegai/x443Aanl5e2K8LQjabnv6kdiH2fJ0X6VDNAUQLMZdl9BZjQQ9HNsP5LYgInVhDC2ksEoQfF878Q50Q+jbAzPC3trZtJa/QNBd6qKOwtB4lsUWfuzjaXeqMdPUbmVZk3VHyGfApTU2LoeFrApOQHtT4qkDyuc/KL6DC5uiNueRQjgmxPNmE0T2Z7HA2NO2yZ8POD5Tp/cjEKyBGl2Z40zthvsuFbJgq1bZGbJNI7gN+SycSF6JWM+dvYb2cddK5DDufBcNL/0FAvG5Vwm5TfIb/Yikit6uTFqBt/XrYVviTLMETart3HtmcSF02SfMKan+WkhWtpnoYCEzM1oOtY+71T3c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Jun 2026 13:50:17 +0800 Yichong Chen <chenyichong@uniontech.com> wrote:

>

(how come so may people are working on page_owner lately?)

>
> add_list() allocates comm and txt for each page owner record, but the
> cleanup path only frees the outer list array. This leaks both buffers for
> every retained record.
> 
> Free partial allocations in add_list(), discarded records during
> culling, and retained records on exit. Return explicit error, skip, and
> match results from filter_record() to handle get_comm() failures.

Well gee, there's a very reliable way of freeing all the allocated
memory and there's a syscall for the purpose - exit()!

Really, everything below the "out_free:" label in main() can just be
deleted.

But oh well, the code does make an attempt to clean up after itself so
I guess we should set a good example.  Thanks.

btw, AI review flagged another (pre-existing) issue which we normally
wouldn't care about:

	https://sashiko.dev/#/patchset/610C3A89A09303F8+20260612055017.632263-1-chenyichong@uniontech.com

