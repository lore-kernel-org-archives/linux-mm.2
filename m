Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55D3ECD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 18:44:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE56C6B009D; Tue,  9 Jun 2026 14:44:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B95586B00A0; Tue,  9 Jun 2026 14:44:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAB4E6B00A1; Tue,  9 Jun 2026 14:44:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BEA76B009D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:44:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 411D991295
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:44:20 +0000 (UTC)
X-FDA: 84861249480.16.AAE458F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6B46540015
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:44:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W4+a6Qn5;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781030658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DdO7K/3Q6yqx7PMnrUIh0ElJIvTEEPopWOVJJ4fqrRM=;
	b=jkpNw6tTa9z5JtrHbeRSiTsZeYMACmQUMK6SEDgsAQH9fqe9sKcvmrCcg8oxylHqCV064m
	ZTPr1YK6oz8/TsqKobxyQU6B9fJd9kBHkZJcAGhWhgBFuQcmyc6j2oyM5bg8hOw7y2i4HT
	FHCZtuylfxPYWEP59eLEUxrv20v2cHE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W4+a6Qn5;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781030658;
	b=64zjOyun2qQ/tB31RhfYJTaRQHQx4lJOptvJdwbrozQzcKsh1e7HEzKvPrEvazRNQpG81g
	2vwwGGoBld8DqMMMXGb3vIM8YrApHVqmaWOqZJcwSsjS8Z6WZTzJiu8D0SmqHHq4iSsYF2
	LAnfPIFKOlUwGsPu7z6ynYVkKRhUnfY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 92B384059D;
	Tue,  9 Jun 2026 18:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01F81F00893;
	Tue,  9 Jun 2026 18:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781030657;
	bh=DdO7K/3Q6yqx7PMnrUIh0ElJIvTEEPopWOVJJ4fqrRM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=W4+a6Qn5/q25XVJO5B349TXUyXFz/oD8IhZNRKMpLwW2eauHMULRepfpTJu5KxHIi
	 +tU3vLcUXMQP/eRYlrs6tYqiH/GRbg63VdLYZAOnYVV1umDvkRjKbRDgvkxATJykUG
	 NtHle/rCQrpKFPgU/r8I9LNuVFi2bfSLT7r5XyIN+dkS9rkj49SPJe2RI6iqN40UBr
	 yvs2OmbQmBowO5nsXrfAG7J2ZSLqck75u1gR2CGmhfGKxHuKv9k+q/ocTfRmBGVUwP
	 GuNIXjTSlvTwgMXMqC3DgRxdkrsmjqLwLgAfdUR5gqMukC2MzBIPhUvtY/FZrFkNda
	 S2yj/Cil6jLQQ==
Message-ID: <ea9efe49-dff5-4347-a7a4-64a1c7947189@kernel.org>
Date: Tue, 9 Jun 2026 20:44:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/6] show_page_info: Remove printing of page index
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 Ye Liu <liuye@kylinos.cn>
References: <20260608210618.3437216-1-willy@infradead.org>
 <20260608210618.3437216-6-willy@infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260608210618.3437216-6-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6B46540015
X-Stat-Signature: dkuhisicywitcmiikxnbmtxiq9qnpp3k
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781030658-57342
X-HE-Meta: U2FsdGVkX19+zsa2DN5O8TboUZ19ZXENRmwNCUFdRkvYHDYHYXueLpDEuZOm03Sf1fzGWULxfZyNB7neD5SeoZD9Wog4lHHXwtF9O/uaw+9woHoMBztyc9ZyZHLm4er9AmSePqN1SLJbWquOlQcEMRv1xIb0M+BNUdqpW1ds+HLZdTAqpWfIhLQungcA2TqPcndOOO/ZL8xaLuxtRjo0lS03QT18OWNxs7kUwm6uOcYFsXtkn09SCBMDznn9ABQdlTdETdHnBukXk1mhkU4HJULZnTOi04XomyhIfb1HV6YUfqHBv2q+OazjzrRPzsU1phV7utBlf+f/BLTSwv2HuECPR5jWO6X3QtZN3K3QRrw25153B66XahCZ+XqbhgKnoG1uidS6cmKJkmnR/WqnFx9gTEg/N9g3ES1mijMJrXxZ9SfU1X/MGTJGvgpUzDM4UspvV/P7GFGdLZaD+ApyhnnSz8tqJburse//eX1jwUmqlEgvYd3J6v6RGQ9V1pmtqNRjqtK4hQ8UcfxxqJSIQ7bD/053IwhleSFu92ZdXtNq+GwyEvJJG9A8g0ajU6+AQ1k51BjfJMEe1tKTLVNQBJ7uOr/zLsnc/Ky84H4InK+UC/Wg6MckReTXEAduD9zXSmgWsE6Tx97lNRIGjC5V2UiaJBIezCrIfMB7y8ZRyyGAoSX7IqpqI8beSMUneJQ1olF8DYEVDFPC2ZF4QYCseZ1k9l43zBcdr9WxMZRMdTWaP9cNpxPi1R2H+/YbIMgMKnn3m9Ae645yCem1GryHKsb2MAyB37RqJVqQaUO61/R/E8Vn6KQh5oWy2B7IEHeOq+/oM1n4qEmgTfc5ZHCmCuBBzhvG+JkGGf7pnv7nVVtpYTmm8wfw77xZ/HsuFGUrmsM2ziLOTQ5V/cJUvFcSVYjx/kr8EotZbhvyRotm9c8uXFzOf//r06ztpIddv6PIb21adxQkdvW6ZTU/ixr
 oAcf7xM6
 LEhZ8pMx4xq2uLBmd3lHAJDgqm+IjBp9Wtq7l7S/PzsG9iIfWrit1IxRICMcjnu32pceGtp0ow0q3h2QFH/Xzg5p0EZhXXniRjvB+lZs7z/3RfuWJwsG4vTr9c4mouuraLkfk7dJ8ijyfHWArwKzXOzKbZeOsiU5hMV8FMmQQFqP0iQwYZZ9q8TOKmHcuPnhArDgN6Tzg30PidINuykrcNXlTQQ2Gxr9gOY5lE2uQgSfajOr3d/FPiTvJQheNWJeGXCIGR+rH92HiG3i/LOVHDHjE0FrpTPfEy4kkH/Hc2rJdqwX9mb3PI9dzzCvLxHXpnwvA1FeUoAq/t0Hsy/XSN6x1QkJR0CTvbwfWpHKQuy0DOyAhou9Ldo53LOd4CFDfexbt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/8/26 23:06, Matthew Wilcox (Oracle) wrote:
> Pages don't have indexes, folios have indexes.  Just delete it.  This
> script is going to become increasingly barren unless somebody steps up
> to maintain it.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Ye Liu <liuye@kylinos.cn>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

