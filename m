Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAB6DC531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 18:48:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A82636B007B; Fri, 24 Jul 2026 14:48:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A33516B0088; Fri, 24 Jul 2026 14:48:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9232D6B008A; Fri, 24 Jul 2026 14:48:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E1616B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 14:48:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D04AEA00F6
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:48:49 +0000 (UTC)
X-FDA: 85024556778.01.68AC923
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0E479140007
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:48:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fgzv/HRT";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784918928;
	b=iFMT4Ha4fZs908h1iYO69CYvx0M1VBiDHln68oTvfvcyGx8VSgnbTO0f+sN70q1z/HCD56
	pGm9lcHO8cKqVBzFq42pXlyyAxNJxh0at4RuJSLhUC/577PIrQ22+IEkgN0rCK6gnn0QSN
	Xgxz1PBjnlsSzJyvTAcgerkoq4YrdO0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fgzv/HRT";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784918928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CqEW7l6AG8iqRWq/zb16CXiDHGZlqAaWI/Tl1NSoTUg=;
	b=Or21rKzuwIfDBbSWoQL9F5otQkDpXh57LH5u1FtTVV+U3hdjf7jyfKi9xf9EzG00SI3l3J
	OnZENNrruxIfef0pXsYwy0OapkzRDPWoh+xC3igt+BcyqWDZbUvib4fDSW4BbfhuGEKnHo
	ccOmWWoa2Wtna/KQPHHENRJl7Bdc5R4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2669F414D7;
	Fri, 24 Jul 2026 18:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7381F000E9;
	Fri, 24 Jul 2026 18:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784918927;
	bh=CqEW7l6AG8iqRWq/zb16CXiDHGZlqAaWI/Tl1NSoTUg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fgzv/HRTcwYMAihvkw0CrcHkZXL70ubrFGsRZYmMHdlj+0kbOIucftR6RWdHGK1T1
	 GDhNixpIb6LWRgONJ3vUgxG3l9AmweCzKB2kJJi5M0bxf1wW7xwiUwW675wkkfGgij
	 Sv9m3JIFbws5QKOedwAiI2dynIOupIWQEOechHS+VXK5BU0evODs5KTcwTD9jHShqr
	 QTbxZ9hDc4uJT0e7/Vbl0A0cOa9kXefz13EY9upIWFM8BAGJzKwJgj0tRT9d10WP1s
	 y0C2QtAQue4vsnori8Ir5Pt9THZoxbDHs+1rOWTS3h7adwZTucw/fIdfra9ucSVV35
	 R35jxkCcPTz2g==
Message-ID: <177a1767-c782-4210-b377-44c520c74619@kernel.org>
Date: Fri, 24 Jul 2026 20:48:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/thp: order huge zero folio PFN invalidation before
 removal
To: Hengbin Zhang <uqbarz@gmail.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org, ljs@kernel.org
Cc: ziy@nvidia.com, linux-kernel@vger.kernel.org
References: <20260724100509.2300200-1-uqbarz@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260724100509.2300200-1-uqbarz@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0E479140007
X-Stat-Signature: 4zc94tqofzx8mnug5r5ycm1wj6wpasna
X-Rspam-User: 
X-HE-Tag: 1784918927-754411
X-HE-Meta: U2FsdGVkX1+cfGpX1lzMSlHBiTMtxh0vqtAAMvAc341KwY2eq0vVTMnWCUJdS1YHdaWIk1yOZziJ2xZ+IshrWfP5RU2CCD88obGP+lneMKhie1bCFOriSOxWaTEwFZDcJ1olmWu4PZTvtVmb4WUqHHQ1CBDI6L5ykFUgIYpD16YIYONXUverzzss7s+GgzDkj8hcImyFIBCgexhximodqdlVeHzKLO8NoPaNlc3u/NaBtUHocEM197B1JHosfLQqpU3xwWQRxKQcWnEpXc0L11EPOADSwq+JgKCgf5rumnyfE7TQQDYvsgyWkVbpy0IhynMvsRs3xr4jRffuB1jgUczocNZ7TDI3AQ6amjeH9xTo9AiZWZtquUVrSanNv0Y5N6RRrl9Hl7IIv1WdN531VSSmY4cfkOgc3/L7G1tj+YFVSbiyRpqwesfOTFtSzAg/qTzms3VuG9epJGXlj7+hFZ24CVxycs1euVHuHfbK+iqYOsbAI2K4magGCc/f4aTtOZnVdORsqtE2gxDl69SfHkT1d4FYDqTBjNASaxRZkoh3SOOXa8KRxY93x5HQ/eXsXruXtd8gKTLjaN1uLgK5I5fi07htgf1ayyZZCL7oiCoBo1oWZwzAZCY/liN5j/ydLZP6nvjV7KAqJQKOxu6fLJ0SbPGUn/6ZVN5xbol2OO1Ib2dDBsnIK16TlYITp0KurspNfyfafX+LyBpu2Go9hbYwphIqRVqbDMOwiD8nCVOGHn0j2JvM9whIllqLol4t9Dd1LfdkQJ01QZsZ2R3hGIAulYHSrLc3grIYVWz110H7G1yFou1LVgJyEDuQ55bajPX22uu+vLrxVPs/uBwSrLZHyaUP9LEMpuXcDGSUP1pxdUVAzBNM90tOxjwqWEOaONlqtZa/R6pB2PZq0qqkUURUlVQ1bmyiZK22wv5imxbYSvQ3WnZ/I7GPjiu2akWpHq2ioaXP3ZrV0AMd3du
 /hpj09jE
 zQ9XDaseeKc4N/GcKIXUW7o1uMVvvE5sHFiR0SlDjsTRWvJ8VXlcYjV8WvlVHIauWSZZPV1kIOR2mLZCRqqOP/zN8u53/hVPF3So+8fPzMacAfYsm2hl2YDUjuGnn9bMYW6niU535qFb4jEtndIoV4/akjegLcmwCBY74eKk7yzviQC+bK4iczU9mtlKV2d2FiCQn1k0FcPu8rS7jzQvb/rBmxsHAaRQgrbdJLuQDpLrKr+RskVmXa/u6k/fzWfd5c3EV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

How was this issue identified or observed?

On 7/24/26 12:05, Hengbin Zhang wrote:
> The nonpersistent huge-zero shrinker removes huge_zero_folio with
> xchg() and then invalidates huge_zero_pfn. A concurrent fault can
> publish a new folio and its PFN between these operations, after which
> the old shrinker invalidates the new generation's PFN identity.


You mean, the freeing path does

1) xchg(&huge_zero_folio, NULL);
2) WRITE_ONCE(huge_zero_pfn, ~0UL);

Whereby the allocation path does

1) cmpxchg(&huge_zero_folio, NULL, zero_folio)
2) WRITE_ONCE(huge_zero_pfn, folio_pfn(zero_folio));

Sashiko also IMHO correctly complains about a missing barrier when we re-set the
refcount.

So I wonder whether we should just stop these cmpxch games and just use a
spinlock around updating huge_zero_folio+huge_zero_pfn?

-- 
Cheers,

David

