Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16C93C61DB4
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 10:38:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 091BD6B00B4; Tue, 25 Aug 2026 06:38:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 042786B00BA; Tue, 25 Aug 2026 06:38:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9AD46B00BC; Tue, 25 Aug 2026 06:38:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB0BE6B00B4
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:38:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6C8061C18B4
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:38:23 +0000 (UTC)
X-FDA: 85139442486.05.F55C954
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id A3304180009
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:38:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KAqlGJg0;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787654301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tGt9QkkIZkOpgxyzezPzdqLO3Es6n+KkX1u4t75qrqU=;
	b=XCNS4EiYKKy5EiIJDT1rMsBGXDsWQdN6Jmd16WgE42iSe81d7qfrLQXY8+LzzUi2VkVzb4
	xC7cgl7aJqp4dIIyKexYhODAhlxbbj8+jnacpbR1sEZ9/bec3yXJe4l608Np9LMmS/UKuP
	0cGW6RCvTKCv2X6djIt+MHanxy7ykAg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KAqlGJg0;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787654301;
	b=hXOFyRGc/Kt+Usv5/Gvs0p5rhNiO2kuAzfd/0B4wQHPXJToH8+5LpU6yBQmHBFRKA6M2LV
	DNk423pNDbb4QhALAIOPIZfrYyqZ64nWnZmYVJMK/VFyyguoTyIpDq++3zn585ywytk+lT
	VzS2Uwpv044uad1i1bXagoF2czRARcE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EF6FF41FBE;
	Tue, 25 Aug 2026 10:38:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12CE21F000E9;
	Tue, 25 Aug 2026 10:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787654300;
	bh=tGt9QkkIZkOpgxyzezPzdqLO3Es6n+KkX1u4t75qrqU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KAqlGJg08//w1rP7YCSEN94YBMNVBxh0lbr/5p0jfr84sMcj0fBdiub5lSeQGS6xb
	 8plH0qlz4u6suogMkywM9mAu1FB3E4+gPIR4IbhuECe+xF13CfYanOmIQ+1nSFKdQn
	 +nr1ms4FPZcGKXTTitz6PpdtO3k07TwY9wktUts8IeN4WVhLlej/QU+QU/qhB0Ol6y
	 T5XlNw5eDmPz3tNhZKdGQt2m8LxLfSMsdnQHR7Iz6uJvyCDq50yhxNj+8Pq04otkc8
	 JmOtQ9WOX733vFmotMeW6Cz4PrDLhGNRm73A+dbs4QOk4tzM4HKlqMERKNCHAcnGDr
	 sZyBRrm3o9rmQ==
Message-ID: <7fc80ce2-23c4-4a3e-8e67-101cde58ec6f@kernel.org>
Date: Tue, 25 Aug 2026 12:38:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm/memory.c: simplify error handling in
 insert_pages()
To: Avi Weiss <thnkslprpt@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Soheil Hassas Yeganeh <soheil@google.com>, Arjun Roy <arjunroy@google.com>,
 Eric Dumazet <edumazet@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1785847364.git.thnkslprpt@gmail.com>
 <ffb2c5669a69aeafa6c95ce792326caaae938ace.1785847364.git.thnkslprpt@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ffb2c5669a69aeafa6c95ce792326caaae938ace.1785847364.git.thnkslprpt@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A3304180009
X-Stat-Signature: rfeiwwictf7s4i7ekby86r743h1ky47p
X-Rspam-User: 
X-HE-Tag: 1787654301-382060
X-HE-Meta: U2FsdGVkX1+tnAopiNlnvyF4lSCKj+11vZD6nOTVMo6zMb2l42Zl7tQstDZGnujpoJ7A0FQH4KL3KhRRt3/vo61WDz0N2+ba5kDcL15vgH5D9j8rljOrKXZHAQ85Xc64ZjPgi9Mf/OBpK5z7I5Y1kf7cftnTRellGPEb9IJ0hl9UdAT7CiHxRgl+BYD5EPN4ucFTZqGRHb5o+/7/LxdooRIS6E+7VNTMYVhfJSJ/f1DzNq2bLRpYP0tWhUtmEGgW2ETbGormGBbKzRboaXj//keXQsZfGtdbfno4qM0pGmNM7zzcq5y2WZsgq7g9aOhT34XPKuE7sCxcQvVwqSDbetgfOei6CMbH5Fj0VpMgneboGpDZw+5sSzZC3M/h/YA3k2eurqHdl2zG2s2TFuuoEKtHT544THE8MWVDos1Hj8qHPazgPdk7vN66aJYzUXrr7WE2WYaeQnQWhHkzs2eS5VJatBPifeilA45PTAiWDoXXH4GAuFL0gkmcPM1Jy3sg2YUwb6ygV8GyKfQjdzaNANYJ/X0KgyWOJWTNyS6P7IcsW2bbyPzB8EbCK0tLR/MkV4BqFCQALOfvKdo5oVfbpswgUgrcOYY2fPC4DslWK0BQkBX6amksph5jpzzlZ2tQUZuaA2KsCkU4qMSuOSfzqzEpu/QhGVgbM7BUy+TNnixQwi+SKTqCOjtBLfmR/qkN9XeyQU6VSAEcHZAECw7ww56v9Ai1NVZQP99DZijp3oI8ulFk610iflFvf6bAfDhnh/WIU8pVvuupMAzv5iG5tj2MKlLO+kKJQPzpv+Fbv+2GPoFZyXAcq4Ou1yVDZV1B9uD27Ry4ArgoaCfNReDnGHvb3pmsgRWumWo4/jPnUEbumZrTAC77PkBPS03iGw8WS4gDtKci9rmODWpiIbWu/vEhkUf7tEK18+RYHmJ2sD19qMzbTUcz/D721IifLtey9TWoGIEVuBEbMd3TLxM
 71OIMl5X
 x3KLlpvaKt/dch1cfVFKbw1AIE8IFvjREb0df48CCoDac+gzxpsg/sgZ5OdtBfRB4lO/R2O912hEGaTqhrK4YhI0agyqsl3bAmc0+FjNO5/IuAUE5fytrytC4XrSVYeEBPlB626oB/HadK8xV86UyJxFCzVFAwEzfUqCxnyJJoAVPTF3QSnYRpTW/whdZgTt1mhwlE7wNSredE4jLS/5KZu/DlCA1nL6dpq+LVb0Xgw8azVp5k5TKfIDKy7PyLnnMbVr/XxmABEkWUliHYa4drylwe9ZZqO4UlgYe67j1T5WU5P3Wkj0H/oPyddR+R4f20EDBHzrB5GC2XXE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 16:42, Avi Weiss wrote:
> Initialize error return status to zero and then set it as needed at each
> point of failure.
> 
> Assign -ENOMEM explicitly when pte_alloc() fails as the pte_alloc()
> macro returns a boolean.

Subject should be "mm/memory: simplify" ...

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

