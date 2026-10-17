Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50F3DCCA490
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 02:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 823366B0088; Fri, 16 Oct 2026 22:21:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D4386B008A; Fri, 16 Oct 2026 22:21:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EA1B6B008C; Fri, 16 Oct 2026 22:21:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B5BB6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 22:21:16 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B3E15A01F0
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 02:21:15 +0000 (UTC)
X-FDA: 85330516110.07.03AB416
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id EECA780005
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 02:21:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oHkyY+Z5;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792203674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9kRCw0sKehKRxmnkhA1oEqDkBNynw9yxGSEEeZ/1H6s=;
	b=TnhCaIBAeUOXsHDfsvPXSp7cJj3Sya0tm86dvm7XqRfcgHPSfEKRxfOD4YweqgcdArV/fu
	eforqSgGRhyGWkqRl7HwTwE2Y6983En1sMhwlGydabUwEJuYQmW3YR7xD5AtPcebBQxJR7
	I9HOYrGke3sEok13jAPMe3hFLT5q5N8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792203674;
	b=c0+6WqFcrhff+luCzmSQghjvAts9Rv6fWFM80dX+AaM/nytiiWW26cvq5yDNkdPGYstyst
	tNioQZs1s7YGhvKS+BfkGmqRH9gaj9p7sco2yF8GQDOmSZcm1Gfe1x7Lt/r7nKG5N4YSDv
	zNsTD9MACWVmXvHPDGkm+EznxPYAkVg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oHkyY+Z5;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC2BF40A91;
	Sat, 17 Oct 2026 02:21:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6271F000C4;
	Sat, 17 Oct 2026 02:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792203672;
	bh=9kRCw0sKehKRxmnkhA1oEqDkBNynw9yxGSEEeZ/1H6s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=oHkyY+Z5Ymkq1XEoRDrm1unXQCYkIsRZyIk+AFZSJ8WFcZ2jRLLrTtiAYqX2wxxBf
	 /C9TjfiWVK5xpPlN2RPaq31PQTQZL3VsQxjp6HCa9nbL/STbOluZD+QFrFEDROKFfP
	 BuP+8UW1QgrBoxAXEEkjw7vavuoZzfdjbz1hrznI=
Date: Fri, 16 Oct 2026 19:21:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Rapoport <rppt@kernel.org>, Dan Williams <djbw@kernel.org>, Vishal
 Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Alison
 Schofield <alison.schofield@intel.com>, Joao Martins
 <joao.m.martins@oracle.com>, Ritesh Harjani <ritesh.list@gmail.com>, Muchun
 Song <muchun.song@linux.dev>, linux-mm@kvack.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: warn on unaligned compound zone device ranges
Message-Id: <20261016192111.cf4b6477a13a711248a8a079@linux-foundation.org>
In-Reply-To: <20261016131334.3419393-1-songmuchun@bytedance.com>
References: <20261016131334.3419393-1-songmuchun@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EECA780005
X-Stat-Signature: e9wmt8wewmgcoffpjom4xifuq1fwkacj
X-Rspam-User: 
X-HE-Tag: 1792203673-736355
X-HE-Meta: U2FsdGVkX1/V3+UFjgCUMTUOk+dSgpRk0FLM3ND1kPbxYFdPEDQk+MJ7DtjdYQrMPDKEuNUMGMVlk21ot1S+YGOLncUkN3dj46bdqQJvFV6nZT/J+r37pqpLs6qg+9z7xQ0f7xxlcRfE3sgOuknDWEN6K+Ff44lRGD05Hebas86qqiHETfGPPKr698w8mylOksbju6E98TYiPNl6cH713h2hdiGz5DOVluPchyXTlvefplFvCxNn3cDQVM7aNBiMwxRwJb8bcq7D4N2RCgEQlYwR05lNjU1Eu4ZvdvdDYuisl2OuH3jhyc88Ym74yI+EWKO1e9+UN3T7wadxVQ+tiSiJzrRpwnJ3CKtceNxJ07yIYZbe//1DqySw93Z5euGivXikvW2wovUQ/xWk0zUDTypNd2URAWiJXZ3phxdPFiZM59jF2PwZ3ww+dZNSb3o6qzwab8mD7qx1ElPfzxyHQpBuk2ZY24ZQHjegLk7ZHf8idWZSDBfwZoKpLEhHZwhCSJ4D35oj4DOJj6npT120dztFr+oZmucCNgLGwyKLiZDUiijuBROokV/SdNEdYmgPmZmAPjS161NlAt9GNnb67HBjJVVS/N7klq8Vh5lNeOJwL0FkC7F3NC3uCt9RSpqV97GmNEtezodRb7FxyQHI0cqyloBU7AvNxRayFGqqVPzrcpmednmugnfeayMn6KcRtCE8OKWaHRM7HDPpOjV6j6/Gg+JrxjIlNxfN/6gv4vAPr2ILraSTiZtzpId5PHTSw1+uARdWN1pjd3ROY7gaFQ093cBXarbah9c8AUgBuXGfx6zUp1/FBelHLMnuAoNdzEdNYntrhz0/wrIjSFc4Y8AyemwIy0HFQcGm8L6zi+xQmkUGajRJQb0Lj6K6vlpAyFTADrUVZ51VIDxAgpOrXP4pU8rKFSfHjiIorOGwHFUOXh91Ly8hXF/8/vl7s148tYBK7HprLTfj/BCK3rP
 a66zJfXa
 tHmW+6iqxYlFofoXDvONlhuten/XseVPgGKSH9C95jWhqEqa92VdqI9tLHVyzbeM8rNNgK57iWDZGlpLFu5YJ0TvRdp+K/6qQ5i11zHU7eeGkL6F6xaKJOxXqunh+F35yCLC1/cmG6I/aKgtJFb9+rYXCJNJpHqetX6PLX6IM7C0WfRo9fQmpAPSc2/dF7yipm/J9EsaZwcoAorhbFmQPxtT1AnLL7mBmK6lSrluBIDJZNWIMT+bk2Oc0wBzTy52U2dBct70iZB7PaFJN/fPi0W71rTZlnl8BXKiPuUWFJJe5a+FdPRDfjgIr7sXHnGtYMaqO4bWOWvY7uqR+y/oE/4T/sOH7HtpJHJ2e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 16 Oct 2026 21:13:34 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> A compound page of order N must start at a PFN aligned to 2^N pages.
> Therefore, a range used to initialize compound pages must start on a
> compound-page boundary and contain an integral number of compound pages.
> 
> Two recent Device DAX bugs were caused by ranges that violated this
> invariant, but neither was detected by memmap_init_zone_device().
> 
> Warn if the adjusted zone-device range violates this invariant so future
> violations are reported when the compound pages are initialized.
> 
> ...
>
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1142,6 +1142,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
>  	if (!nr_pages)
>  		return;
>  
> +	VM_WARN_ON(!IS_ALIGNED(start_pfn | nr_pages, pfns_per_compound));

Would VM_WARN_ON_ONCE() suffice?

> +
>  	/*
>  	 * Seed the reusable head-page template from the first real struct
>  	 * page. The normal page-init and refcount helpers must operate on
> 
> base-commit: 63562804f25cb5b6f5e4f5e3a9f0d1c3c6868596
> -- 
> 2.54.0

