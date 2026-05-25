Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1E8CCD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 20:15:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04CC56B0005; Mon, 25 May 2026 16:15:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3FF66B0088; Mon, 25 May 2026 16:15:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E56D66B008A; Mon, 25 May 2026 16:15:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D0E5F6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:15:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F35D51201DC
	for <linux-mm@kvack.org>; Mon, 25 May 2026 20:15:04 +0000 (UTC)
X-FDA: 84807046128.14.477EFA2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5A4D916000C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 20:15:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=063cSBN6;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779740103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X56+OZYAIjLFWrSXIXemEupQvyrgRSjAVtfUd6Nv/E0=;
	b=e4aXeppod3gsZ20B7Ng3+XjJxvHjwZZdqA7HVE3HVpF0i1G2blWrUCeRucL7cnl88sUEt2
	+OgeOf0axKPEkDPTsU6WZSAcEjtAmucLDmQkzNn68qSIKBNRaHk1VCEj56blyVKvgk3df3
	uH9L8WnuB5dt/jI9GTwnkjSFQftN/sw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=063cSBN6;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779740103; a=rsa-sha256;
	cv=none;
	b=qI+CPnlTSQrtzaexLwKqs6UObfT30axCq7A8+yEyOxH1GwmLSith1SUtLeCg3c0/doFN5a
	TTxG4XYfTDRGZ8DQQTFm/6y21yOXkdWgo9jPuhdRYh6u2JU7tPq7pKE4jst89IkdrG4o6A
	ANPZQOw3gm6R6FERM/QupySH5/bgTPk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A096960008;
	Mon, 25 May 2026 20:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F378B1F000E9;
	Mon, 25 May 2026 20:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779740102;
	bh=X56+OZYAIjLFWrSXIXemEupQvyrgRSjAVtfUd6Nv/E0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=063cSBN66ZhVXSR8jU9pRhWs7scC5KkfE1+saG+Rp1U0VHMt30U30PfUxJWrRolbu
	 qV4iGw9b4Qpwgu/j4MRqOl6IuU7LZZbPQwhNOHSVEDHOGwHqH9Ec0TqQoGKbrO1z/f
	 qjiMhCeMPO5afMoH7OIQCdqUNIARsOGyWsAlqOIg=
Date: Mon, 25 May 2026 13:15:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner
 <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Brendan Jackman <jackmanb@google.com>, Zi Yan
 <ziy@nvidia.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 Zhaoyang Huang <huangzhaoyang@gmail.com>, <steve.kang@unisoc.com>
Subject: Re: [PATCH] mm: free HIGHATOMIC and CMA frozen pages via buddy
Message-Id: <20260525131501.f232fd3cfb67442d2c284631@linux-foundation.org>
In-Reply-To: <20260525071033.1104929-1-zhaoyang.huang@unisoc.com>
References: <20260525071033.1104929-1-zhaoyang.huang@unisoc.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 91efqtfdxdeptfq7mg37sr1zufo1ybhr
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5A4D916000C
X-HE-Tag: 1779740103-221136
X-HE-Meta: U2FsdGVkX1+09RRwJmlvRtxHiMonuQAF7zIAXYJWFJdC7kPkq03ZhgJWhCPm9uI1iAU8Cl/OwD5qmKfjZT42RIvOa8AfuCsfI2dNxn8f9KJSCidM/HTg6No8G2NPYOpiNz1O4w962yJFHaLtTozzG14kIh2cy/nF6LDfJ4teZz5yQyLIcXpNUT4W66u0V10yx6Z/kDcMI5heiUpYHPtYREZl/TPX2v+ZFYYe2Cj/NRa9WS3tUpR32JhiK/D44RkN4c6hqNW5TS35sYk0tQ3ipB2E3uOw+Nzj0b+pC7n5+cERsXHtGMjy3ft5tkubFJTipETm838vZfmR36JKYTuNCtjV2porjknAlwWgFuxrUnr4KKq5JOU8Wj1Zl/RcIqM/KngP7fz5/H2w9ZoAfkO486Yvo+s527cxagQe57CJiGFW83D78ncQPrp+dyBiCQi3y+8R2btKuxC+swxlfvL/M231u3w7UNjtU+ZtaZqgVHxA7OkQ0tX0idiMMSAbh379rrA4rzLMO0U93WQrBnySk/LhNoorvy5anW6zzeCTDML+HTJjFZEtDEzW7Z94qPmYBIpEedcHbZGXhfdNwV60ZAPkbCa9u/zs9WVu+o/fBaQwtrByGek/FP1+9BzWMxj3tvLjD/530vJyy4r745VlltfN3/6Zdab4AjXap2sKbd/8YmruBuKy7QaXFt2tAY9t8H6kUW6iIqL6OT9UOwvZF567XqG4zKa1UurpUyhplc1frfame8AHI8K7eq3piw8nUOsnMd9gPyobXzmiXzESDuoV2fJHLzIgo2OuZpX21QFQJicKXzNz485+uSboGCXI7qofnXP4FsSlPAsSFhXXyyCBhEzfs/sZLT020kOm3ubwTgUxksaXjaPHZZUgWNFvMHqqrYD17c/pHgi1uq3unwBZ9bjQcZe0uHeTiLmLGHrb8TZVOT3Lm4jlDC0HJqxnIfWRyZ5TKJP6x2IlUHm
 sxfyvgQh
 Hb2kM+zQvSAD6VqwPsySYZKwASX7y+p5mMoKMHcFUwQXPDoN5oa4aBsvnQiZ3FoRPyRljatT12mEBEoF+JaVQ0cpEp0O8mbfq972b9GowQoVNTHSeGe587vk0JYOHqoTi4L+AWpHFIoDcFNv2IuFz4SlvgCxA7wnbM1CHQt1/glAptAB+cYVIARE9U3SoJv09PZSA3xeeCreXg43OmhhaGbZktfS/kCOu3sycgT+tul4E4n8S0pNgazx6v+e7QqLBWATDsE/wQm2sKvokxMbVJJrQmXbEGiU3ZHdEcoKhPnKfRxu28jAhqP5znLXmY/AeANdy5Hru2W+4VMsF08/vR6Pwb3pftOBk3mmP8b0MLG57awnXRSsiQo3Y2pCMxxvj1gvZ2nmQ+rWE0B/smHGUpPUBBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 May 2026 15:10:33 +0800 "zhaoyang.huang" <zhaoyang.huang@unisoc.com> wrote:

> Pages in pageblocks above MIGRATE_PCPTYPES were remapped to
> MIGRATE_MOVABLE on the per-CPU lists, so order-9 GFP_ATOMIC
> allocations could consume CMA physical blocks which may lead to
> cma_alloc failed.
> This commit would like to free them through free_one_page() simply.

Can you please describe the userspace-visible effects of this change? 
Before and after.  And include this description within the patch
changelog.

AI review claims to have found a couple of issues, one of which sounds
serious:
	https://sashiko.dev/#/patchset/20260525071033.1104929-1-zhaoyang.huang@unisoc.com

Thanks.

