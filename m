Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAD88C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 07:45:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97F756B009E; Wed, 12 Aug 2026 03:45:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 957826B00A0; Wed, 12 Aug 2026 03:45:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8700D6B00A1; Wed, 12 Aug 2026 03:45:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 65AB36B009E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 03:45:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 066721402E5
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:45:50 +0000 (UTC)
X-FDA: 85091833260.26.9605632
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3D23D180005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:45:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H2AjGeld;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786520748;
	b=DSXFinPimNXfQ1QDPvwDzchvpiK6Pht2cQP4Y07YJdLH72h900pf0dQELaj1cLbJ8obJE2
	ZAfj0uhnA26V/p4fWO6MlBaPmtTL7REzieVmINmQBCJbjh+oFAlIrKf1zsr1v+9kK9zjU5
	bWb6FrkSyN4YAssw2OZfHneUT+RzzGE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H2AjGeld;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786520748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Owe0SwLfEcUy2J2+BGOCc0FMltSAhdeyT7ok848pM7g=;
	b=X4Kk4V36xRx80uHnUJNElMDlajDOd/L+Nmeddl2NyuWEEqvo5MPQd/LPMq461tpDLO0EWS
	pcIJ274MnP9MhLly0yUdihjeSAvPw0fFR7gJjwCTq5aePNaBD3SgL0I7F5oEXqhPA9IRb6
	wJZyLe9JEsMbYpr0Cnp3mptp3um99sI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 80E6F4121E;
	Wed, 12 Aug 2026 07:45:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C44331F000E9;
	Wed, 12 Aug 2026 07:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786520747;
	bh=Owe0SwLfEcUy2J2+BGOCc0FMltSAhdeyT7ok848pM7g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=H2AjGeldjS9tQXKTQNsf9qRK87gfVdBp+DqH77DoqccviEyI+Kr2Cy6kz44h77Idv
	 Y/PNSL4HB+kB387pWllkyjUz5OWgA5UWMmX0xvxm+km7FsVCB6XLxfgJnM7BdIFs1i
	 WOcMjEeUmU0a8HUwTTGLq6zJg/ByTNdciEDA486KVv3XzI6MJJBz5GLohyW4fOSydL
	 4FRTMgGdVUfZ57YQ0qTe/BTKGrmB1YcAseiz2MWUtW4N18KGXi5j+tnzrDZECgBdHj
	 q3GBXCccG8XJUaV6Z1P1xwLD0qF/MvpaA2iazSr3Q+zmzWSem0dkurAYFV8UUxP0Kl
	 nDmK4XDLqr3WA==
Message-ID: <2e6382b4-8a0f-4e38-bc7d-3e3bac3a3f59@kernel.org>
Date: Wed, 12 Aug 2026 09:45:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/page_alloc: replace custom bad page ratelimiting
 logic
To: Pedro Falcato <pfalcato@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260811172156.356053-1-pfalcato@suse.de>
 <20260811172156.356053-3-pfalcato@suse.de>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260811172156.356053-3-pfalcato@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3D23D180005
X-Stat-Signature: 1j53489bniqa9qct5s4aidapxs9hbkot
X-HE-Tag: 1786520748-315352
X-HE-Meta: U2FsdGVkX19mHydfHF6H/hy/kjUms/apfTGyvpI69DyT43hK5Baq0grsJryXk0qDG0MZqeRqYg52pALM5tKdL4inpxsizGS954NcwfMy7VFymXF1/cB9mBeDM/Nz8MA46INixttHCJVY/bfFUBGVozXW7VHy8jP2b0niCOC/cEe7opq0SmVJMZtU3UHIRVgOjPPFvFK4MS187SdQNHVAyvCJyAg6J7o+dDHdgUzwgiPnx0r4zUNGirtLEgM6hj3T8LPGZDyxc/TDLs4GJ29oxoGiDhBksodwwHYMkrKoIbR/kJI+kY194GX/QyBhe8+jcYF27eVSTdU2DQN2bSVKhjZjf4MUiP7TYQf8Al7Gh/S9w8aawKl10o4Z5GhrGo4S072pgsx7xD0O1zek1airn+R6ZDtNZvb5tLZNiT0ISVyo7JfOomT0RgA99eTKp1LAVrPjxSvSRJKFdBHEHch1FKc6D1YjnbydA0jmlMDHFEn69JZld4VN8qpunpHbGipHGL+iBsHQcx9PjdfXvt+wrkk1vkV5tIjARivCYAod9tp3cy+VkSoplFYxSYwSlJ+tTwQeQFsxMqXm04hrRRUzfcXDiVXEps6QQkYbWFL5KQtwZyT2VSqOEKyp9+utFIk2jImEFvXIP0CX15bSYNSplp2GgcujiqwmgbyEP4yHT0Mo52ksnvkx+LG1APjNh8I75DSqm+uqTw3wptO+v+0CKiY2FQx8Mr27UQ4Sjq4IM3MLyv/wNKR5+XI47a0wCGXXHQq1ulqre/e4hyfj5QBYUgatVDH4K8KYU2RtLdsyCpuxJHSnAaqV4lwiAfuMSlyzImC0F0BxLns38p5dYjPoQCHvYeFXH60m3nRy5TVd0TcN8Knx8Exp5Axjb5H8ej72xqApdG4MT4GS6KakZM39VymUXlQ2zoMWYEwuxw8x6yogUw5t5AX3ttuo2RKgHKf8m2hWIviQMD1Ogkw0ySr
 BXrEsFGw
 ZmyOqEX58akQs8GXyTiFkAkf2/mjrysPxhFM/rOOZbB0E0ipQajQ9lO/qBko81Fp7VKzy8ZxypwEBqruqIlnuoWO5HiyLUTBC19zeu/xaEjnklZiYPpLh/4L9euZt5Ldec0vGyebKSbWAEo6uT11xkQySXMRVgcMgxJ30xSu7brIqgQf5Cg63mT1jPSZ6fKQ2qAh1znNlH+iFXnGuqrHliTrAthmsnuAdALpYKTTNaAYG5A7fHOUKSESf1PUMy9D5i8QnhEd0hn7+X0K2mWeC9tFjl0x7IXTlFqyacDJvu93tfGKG/wojU3uSy6XMrg/uDk8EU4qWK62kRO0=
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
> KERN_WARNING "bad_page: %d callbacks suppressed\n", ...
> 
> But that should be fine enough.
> 
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> ---

Nice :)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

