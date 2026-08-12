Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFC67C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 07:45:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 030006B00AC; Wed, 12 Aug 2026 03:45:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0076C6B00AD; Wed, 12 Aug 2026 03:45:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E60546B00AE; Wed, 12 Aug 2026 03:45:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCCCB6B00AC
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 03:45:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B96B280304
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:45:08 +0000 (UTC)
X-FDA: 85091831496.08.E72D987
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id DF3C1C0006
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:45:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cdoe8Sog;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786520707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vn1J8IoLYo2N6KRD4KfkmqEuotdaeASG5oGODSKi6Rc=;
	b=d71LskzWq0tDitCcJdpupKdupcj1DahIBfrC5pVGzcA5FfuOUAHimAEemcYKud0eC7IEzA
	UDZ/iGDhJdeOyrWOMcBrPNesnEKOrhlKEOwLBmeHwJTDh3ZQz7A1QOYjn9Z/vP9oHxkoI3
	79X1hGA6n9igYKxItgiymerkmYitpyg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786520707;
	b=B6YAmGGUDfoEC2bnoPmMuTVMhF1zkHSP7pfRlR+gwALrA7s2AJXTKpXUmKrxiWAKxklRsU
	Tvxj6kF5w3HlWaLbFX0cQ1kag9G8X9K8tCKl/Ip0jkZSfTBkUkiLvxRCrzzmbugFSgClyQ
	uRrIqr99Hjn8eXZA0KIjuCfyuw0OGd4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cdoe8Sog;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1611041757;
	Wed, 12 Aug 2026 07:45:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B331F00A3A;
	Wed, 12 Aug 2026 07:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786520706;
	bh=vn1J8IoLYo2N6KRD4KfkmqEuotdaeASG5oGODSKi6Rc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cdoe8SogitqTtjhixyexdwcKe9YPMs+Yv3ALhvXwnPpTpiQHHgtHIU2Kvmf/tvCfe
	 oggcCbIUBuc1VtBD11yBaX6CZV23akWdXHhR7vmvQmTf9FeU/K5HyLx8ScOKOu/MCI
	 mZVRDs6Md72KCznU8b8mf8O0Z19zbEhKf68BLTy+FDmENKL0AwaYnjnOlWTVkl0WKt
	 8CMz31UtTpxFL9X8jC99C23AoooSyF6+LRkHS7pGx5WwJyJinQOaSPCMlxyeGKBEz6
	 TPqa0O29n4BFZtWggM3uYQkqv6LSZBSMsujaW0gwqgStYj7MN1cA/tUmwY8ynxvcMa
	 YZx3Ztj3A1koQ==
Message-ID: <405dca4a-d38f-4314-bc90-4f971e19b01d@kernel.org>
Date: Wed, 12 Aug 2026 09:45:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: replace custom bad page map ratelimiting logic
To: Pedro Falcato <pfalcato@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260811172156.356053-1-pfalcato@suse.de>
 <20260811172156.356053-2-pfalcato@suse.de>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260811172156.356053-2-pfalcato@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: s83d47ax3kyoy5pgw51hrsruomjmix6j
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DF3C1C0006
X-HE-Tag: 1786520706-175397
X-HE-Meta: U2FsdGVkX1+FX2pg0BfGidSWA+8sEz7Lm1cdqx7Jn4n6Bq9Mp6JjJRJ6SFpZwkPJ1d2UAvhd3fn2cmD5Oujr0xxehVrqnHSpDYEKLYWjBwip+DhDg9L7G3q9Gl4er+O8mrXeYW6NLsGQpF+TmVHrw/7xU+Xr3HsnDDGwvgbNTzDVqx4crDPKsRx5kUqycEImwG9/ESA/kxb9khgM7UOqPwLhuqVYymS/YsNvRv1+3PGH1/zC8mOLw0KT0AHEduvSCWCUDSeodRapWkUxQXDMGV+vHjlJOGGnj0VFWXkE4SrojH77h5SB+rrGTUBsW9pwZksLXEcmQ6ztnwTv5IKWFwJekGm16iK7QSauM7mWPRFyZNy7RbLkSHEVCe/Hu48wJq1xVIb2od+7fZuswKPGD3mWyRcENTz0cQoqt4NYyLrMDM9i+S458keX1u1wb09W2s6Hr8ia35GloPLFORYqcFuncwU49WH/NqFchBlHBil7+8j/+2xjel8b1LeGoaFjzKls+IFguExz41V7vfWkL4fxArMp9pRFVrvcyz1l3aBLv/rhoMbAW02z99SbliC+TZcQaW2LDnUdJnucGkeXaXkVgdpy9e9/vZNOz39tllCh6pJ4iNQVSj7prh7QlO9GNriNMsDaBWdnmEdY1o36H/oDvg05RaFaxcAQL0XOzGbSa7RGeY3Cf2HRN36Lx5fu+4Xu3TYS7buum6/jFnmaLSniDXnXX2rRsWEM1tmB1ub/CMYQ/0dyk3kI59U1GEhxl6DxVbnf0FYKisqgJ0TFIotPXxYfpNfOSxdA2GjBLKGqD56wuTfRzVm0uvFWeyQ/jTH3+WANUMFAZJ8RUKAHtc8vmtCX79d/SKMNDu5C6uSlw85I8mq4nn1ZXH6hpn33wDOyoczjK0fq6w/Dh+ehKGX2vUIfhojuwMBzEweJtnFNAkF9a6edTKj2HbUQjSA4mk0+x8CMf5OReAUFQ5e
 R5zBD0vB
 vyGiw2e8nnyHxHAZxnbU8c8OaexJv+zUfD6w+6aP46rAWKnaW19Db50GcABcslUBjRFgGxk2iZObO788eykPqYTXlFBXht0UjQztRkp2i+rh3yailvhvpp9yXau4om1jyRnj989OFYFzZPSgXVLm5/VNo/nAePS48pAwxZqWhdDy69uQJNSQNm3rWoSUoZO82KpvyBxU6dqhuYdiB8RImAfsHCoewLkGrVBQGby1U8WbxWxgPQbyejPtoPuQxyQiEfHdJUpCtPjcfzotiUcOYLZM3gJhCS6haptWz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/11/26 19:21, Pedro Falcato wrote:
> The current logic (allow up to $BURST prints per minute) can be entirely
> replaced by the generic version in lib/ratelimit.c, used around the kernel.
> 
> Do so. The only functional difference should be that the new logs will
> read something like:
> 
> KERN_WARNING "print_bad_page_map: %d callbacks suppressed\n", ...
> 
> But that should be fine enough.
> 
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> ---

Well that's nice!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

