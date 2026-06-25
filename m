Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA8A0CDB47C
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 02:04:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4B0D6B0088; Wed, 24 Jun 2026 22:04:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F98F6B008A; Wed, 24 Jun 2026 22:04:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9101E6B0092; Wed, 24 Jun 2026 22:04:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5FAD46B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 22:04:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C93011A050D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:04:25 +0000 (UTC)
X-FDA: 84916790490.05.30FE4AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1BF3940007
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:04:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RG3jzbS5;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782353064;
	b=7MyxxXZjYIkcJAemOPgMeFePOQYEHC7jl89xzAxup8oDzXmFMxneTm67gl9L8H7QVY5VRq
	FgajFt+OpzzwnB4B35qp2eEI2Hj+CXiSiPTlEfXJQJd8EMo6M3TUTZvOIgkoRTgSL5ajER
	EWkqV5uvBeLNjelRp/XGBKJskv+0ad4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782353064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gx4FZ9NCfUy9OrlH5MNdO/AlD9Nd83bqNCipHSXXq3c=;
	b=zq4Pg3GC0IhVqhJe2O/UShldcKUDDzVYVGjJ8yQleeqxEKRqincz/oVB3/SFmb9TTsRu5O
	UGTyAGfwzmIxmkj21tt6GhSAux5BvskccIg/4eCioR3u0b+WqZje27oDyDciMjrUssN8xW
	RW6zW5cEnZbkrFGP5FygxK16yLtdzB4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RG3jzbS5;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9EF7E60018;
	Thu, 25 Jun 2026 02:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088A01F000E9;
	Thu, 25 Jun 2026 02:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782353063;
	bh=Gx4FZ9NCfUy9OrlH5MNdO/AlD9Nd83bqNCipHSXXq3c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=RG3jzbS5CdNSF7eEF1EJGXAN6ff7HYohVtFudGji+fb6dXeJgTNeXYmvVvYkskaGm
	 XH2VrgskoJpb97nPDrJbFJ8yO+n1+NBFbZaDUKhRydBr8HAlUbSUAmFJz8h+7lcGIw
	 sHJjJ0Vn43uk6rcuKdLZoif2nUQsjQTC2eoWRkpU=
Date: Wed, 24 Jun 2026 19:04:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/page_owner: fix TOCTOU races in lockless page
 state reading
Message-Id: <20260624190422.4d2be6576104cedbbfa0e320@linux-foundation.org>
In-Reply-To: <20260625014708.87386-1-ye.liu@linux.dev>
References: <20260625014708.87386-1-ye.liu@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1BF3940007
X-Rspam-User: 
X-Stat-Signature: r4du5549bc55iniyb1oys5jq5t1jqbi1
X-HE-Tag: 1782353063-181306
X-HE-Meta: U2FsdGVkX18siDRwjrkPs6W6W4RcBbRFhAen1hSMyKBeU7aNWL03a7LiGoKokQw7O0TW85qtHXKMvMaId4P4zbtEvPqTnyMKH9qCVbLGcyrURxhtQP5Vi+/IcKNixh6cxMLUl1iv0VrVtCe5Hd+9PIq7ktXs9mzDs+J3SOaQuogolJVHNI5+3HmsypPE6LJS5r7w4j1F6rV+6TxRcCBn8hD/AmqJZ984R7bXgKmfJVpEGymFkJtsnPLU+ox+qIvY26QfaYxrYUaeLriJxHjXbfN9S1wB0cANKlL5NEiXHBjWTpkC5H3X0D1Lxd9RhJmC6NvIsIQ9cyK+Fr5KaYGm1T0L7KO3JBZMeYnSVQS53Fi6WZ0RHdr6aCWG6LzJ7mqZLo1tkC9r4t8XHQufYeW9LOEu8tpVr4oXS5wqoVlx8MkJazE48UKP+VVNCuooAmzNIGhRu3Zkz07Eh2HHfSj7zt30EiJT+jdPnRAsW3Ma2onyN0QcFAVQL7N2Wf9GYKthOzFK0s2NtChlEG30FWhLU1SC9dg029zQxKxPFrUlZXcgmCyTComQKQ+93M7/PxmACJqUdl1QuD5rdfGinVXh5ZhVq/aBXB+FhAHWMOWXtdoZfmCthnaEBaXEdRZCujbNINLky14yxkJJNtY3odkoYRjg/a1i5kHizZSTMACC3HmFiy4YR18jUsFpAONH/QpMQsQJVUAehSL1t4nqg3j8uyYR+1tI380WGHmqVdT01vztmvbb6MVvIG8iWNbxxjyhhkinHrhTrBXOuS/McAxF6yyl1fFJ0XdICbFBj45aauhG68OboyXw8PZwFDKzA2iq9HwoA0K6zH1rk62jRJJRiktsk+l513fJ82rayESjPim7DMFoVQt3grRGzp/J1yyrpQlGtci2fOGY8nunnarjefXrdfVe9x9ccgx7N+hSPtLHoRsGUz3yeSmjuLIXHlT6IEI9QL8TRYWvl+t1PLA
 l35KRtJY
 GeaCJ9Qe8BKxBVlamnHpLFzkzgJecsuGEZhLB1SN1bxfq/goGf6jbgNsGLOAkIOgl16hxzJRmxqZaLjqxLn412QKGwmOzwZnwlTr079fZr200q3q1rDfkAjLn5PRudRjpMYkw6Xm2mnRPLRDbk80ZWgP9eUWpp2Q8nOPf6niTtpyrwsUow/jd2tpVnPbcJQAhey1ZKaG8p5t+12+OZZ1IAiV9NQHQ9j9287XOmr0CAznnibCAzOee0oXI3lf48TC6ixiAmX/cybEW094+Z8+6VMNkcK3WbbrKjUM2VwGwbuj7D7dNSkl3OJhogl+rVGArn7DH7mtfQeUkyR3bjNBLXGqIXdTnz6N2+eg7na6NQMB2M3G+WLpP/cBeHa7VG8We2uhbyDZ2UoiqxvytRiTfElQVvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Jun 2026 09:47:03 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> Fix two TOCTOU races found during review of [1].
> 
> page_owner reads page state locklessly by design. In two places the
> code reads the same metadata twice — once as a guard, then again as
> a use — and the page can be concurrently reallocated between the two:
> 
> Patch 1: buddy_order_unsafe() in skip_buddy_pages() can return garbage
> if the page is allocated between PageBuddy() and the private read,
> causing the PFN to skip past a pfn_valid() boundary.  Clamp the
> advance at MAX_ORDER_NR_PAGES.
> 
> Patch 2: PageMemcgKmem() in print_page_owner_memcg() re-reads
> folio->memcg_data and triggers VM_BUG_ON assertions if the page
> became a tail page or slab page.  Use the snapshot taken at entry.

That was fast.  I haven't pushed out mm-new yet, so Sashiko wasn't able
to apply these.

> [1] https://lore.kernel.org/all/20260623065234.31866-2-ye.liu@linux.dev/
> [2] https://sashiko.dev/#/patchset/20260623065234.31866-2-ye.liu@linux.dev

Nothing cites "[2]".    That's OK.



