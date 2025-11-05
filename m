Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5C2BCCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 16:31:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E4B88E0013; Wed,  5 Nov 2025 11:31:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 095D28E0005; Wed,  5 Nov 2025 11:31:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EED488E0013; Wed,  5 Nov 2025 11:31:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DAC6F8E0005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 11:31:28 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 726FDB6CE4
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:31:28 +0000 (UTC)
X-FDA: 84077093856.18.B977E2A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id D837EC0016
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:31:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ijEkyMqm;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762360287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ISOrCuRd02Yg+0AorZ5oECiYPMYRzr6UjuEiHGAV7o0=;
	b=eJUg/XUiG6eGbc+RTpHZCSpIWhF/wVyrfkIPVLcjN1Z+jR3hR2fO5U1lsm83KsD4NGKtYy
	tiG2cH1mOGJBSIYFNbEj40E423QIHes8erkuXl1FBN1tTz/yVcNJmRFBFTswERLwFU855q
	EwjxS2UxIUgGpKd9ukYmFEWMd8zvXjw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762360287; a=rsa-sha256;
	cv=none;
	b=AEqIwzuyTxkOPGRfAxh9HKa/jvY+8HS+WvnjL1DU5My3MqtzD0VCERNck2vZ8WzcFu8GxL
	4qPfDiX4ef5tFZ+7Uf3cHsUMhWgXrnU2gdUFCAhSBr8dKEZPCA3S3GiyapmkAxpt7qTkn1
	USJBpWsGqjtRcJWM7mYoTkUD14t34yI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ijEkyMqm;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 98A90438D5;
	Wed,  5 Nov 2025 16:31:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01482C116B1;
	Wed,  5 Nov 2025 16:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762360285;
	bh=TmRrpB0daG+yPB62aM1A8jn2xEuVx2ZGsuNa8VIp1BE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ijEkyMqmeSjERxDhaNRmHwC2BUD941UDTprg2ZbUH/lkPuqTb6gaoQ7rolMqAh2cU
	 9twtFfFUOOTh7H0k574+fak4UatdGPaPkx19NaI7ix+tBaFaywtHqm1KV8WJ7x0Yv4
	 zG0ogxLM7btV1owwW6q38fT+OA0No40QP6TVlL1dK2sVe7+C2cb9YOXLV2JonKjWSV
	 q/83Kcw4DjS4gbBViscwdwh6UX4a2nFYWsnpbVm3PVmm8qEKq5IzwMOM/lbNvxnfVJ
	 KVXNSVz90pH1NquNUMff6nvLcz6F6aUrKvBZYVZtw5xcdCWpT4fg0Ov0Oluw76yQEY
	 bAonIW4CjndSA==
Message-ID: <cb1d2b13-6eb0-466b-a541-0d97940fc184@kernel.org>
Date: Wed, 5 Nov 2025 17:31:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: fix folio split check for anon folios in
 swapcache.
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Wei Yang <richard.weiyang@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20251105162910.752266-1-ziy@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251105162910.752266-1-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D837EC0016
X-Stat-Signature: m197od43sh3qpzdku7q9q8mq39wb8m58
X-Rspam-User: 
X-HE-Tag: 1762360286-698574
X-HE-Meta: U2FsdGVkX1+Yf7By/yUssDl1bHPaXtI2M3BBAIzywlUpZ5U8anxYr+ekHzRABwEmWi+nqrPcySfMynH2J3tY0fdB/PAvyq3VC+yrAr93xC2gHxC987m8rZyXLEmoCg5ZV5ekJiGIJfT4THSTOJjwrNPfU8zSsrCCiv78QjdicgK53jc6K8kZ4nxmFq6FZRj0h1TQMh2WGzuFzms4gkKimD48xI2sOCnoLA2X5OAbwGA9DdnyFoyW1bZDfjSAhnfq6PHbOuEA2QPtMG0zlsPRBRqIomx3rXiVtBgmu2nhHG6pIdAUWXOrd8hYhfuIHeN/5uOxFUmUDmdnX5nnGvqDYVHVAwNnszSDstm+djvIjLaA5sqyZ+Hh2DlA9joX447F9kN7UEubPBsy3jxQdVXrEFLmq/DDEcUS0EGuZzcmuq6ilAU1poQ65K1j8g/J1FQWwpmRTTWIa2n/gA1D2MexOwXWZ/0XFwlVS+TMQjn925WDzUmxpaPmx5KonS0cpcbBdurGwOCewWT+UTJavyc0l6GdOpKFgsJR/pXgxB9jmlE4vnfUY3StLQNy007dnGMps5IfA3KvF2z82umtgY3BLUaQqsXiiB1A95+goWquJQo5cstqT7rV0H+uxS4L61F5t3G0BUQxEYt7gwrNyZvq5XZI6ZcyX3zOH8vIHCVs+w6fcunWWgFsOy9+r2L/jehcs/LJ98FcEDA0hVIjlsXbJttgSs6rUvG69z9lVHfFzK7g2SmGUTZbIlzYVX//BepMNXdCxfgpYuPnqyPlAGFZhPTm7TIK1xT9i/dVQWGegN/6svrn0Kl6EFXregjNhgytUZBoACW0IgRK+itB5GivJvNYXOi/dYRyATGZ46UZb8X+cXttqbMn7zN/sJ/Nj1Lf1Yj4rUW2nb0f7oJNvWy9ziykrYjkWchcuyXZkHsPjpig7EYE3xZIZcTMhx1Puc7DkZdip+vMS3C1btLEdS3
 LVklM2k0
 JNUnB6fbUvhPLmKD5toEOG8Dkk8r8WdzWxs94GEVXJH+IEDdhHqyiNONSE0IoJ+bCyPV6BazMTcrryKg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.11.25 17:29, Zi Yan wrote:

Nit: drop trailing "." in subject.

I'm sure Andrew can fix that up :)

> Both uniform and non uniform split check missed the check to prevent
> splitting anon folios in swapcache to non-zero order. Fix the check.
> 
> Fixes: 58729c04cf10 ("mm/huge_memory: add buddy allocator like (non-uniform) folio_split()")
> Reported-by: "David Hildenbrand (Red Hat)" <david@kernel.org>
> Closes: https://lore.kernel.org/all/dc0ecc2c-4089-484f-917f-920fdca4c898@kernel.org/
> Cc: stable@vger.kernel.org
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Thanks!

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

