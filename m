Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25F6CCA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 18:33:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EC4B6B0005; Thu,  4 Sep 2025 14:33:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A24E6B0008; Thu,  4 Sep 2025 14:33:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D9656B000C; Thu,  4 Sep 2025 14:33:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 078716B0005
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:33:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 90D5E13B062
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 18:33:11 +0000 (UTC)
X-FDA: 83852414982.28.6B36E4B
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id 903A3A0004
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 18:33:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TQsqtDpF;
	spf=pass (imf15.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757010790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WTK/8VgFFyhV8UKZppqhouh5PDUMUGXFSIseDaDeNx8=;
	b=tuJ9J57+IdAKc5foXcg/9MYJOViYKyOh6K7zO53cRXY10CqYD7DatNZPRC+YPHwSvKh/Ms
	9wyjvt1vKevRu8qOYCb5ryX1nJUGn0XHCiFH045SkU8xbxxl2zrGpsuawRxpxAXleRRZBI
	crNPJ9focuoB0Ue8nd+miFcdzNkZYbs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TQsqtDpF;
	spf=pass (imf15.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757010790; a=rsa-sha256;
	cv=none;
	b=NwvsQRygfxX+VB+/29qfPGkMYZ2BRBRwuKz68IRU015su5t1I+XDNcJVPgJ+xtD0GYQAi/
	HpLhYVMKnrEVlSmkn0UQkq+bvK1cFVvljKsBLBIrOfdOoi0bHAB7cywXySEEkGaakag8aV
	7tJz3AExorK7Gp8uED6bvI87LApb4X8=
Date: Thu, 4 Sep 2025 18:33:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757010787;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WTK/8VgFFyhV8UKZppqhouh5PDUMUGXFSIseDaDeNx8=;
	b=TQsqtDpFpfOc0VcPqaZt8asiX8hKW3riIF99A5aWMAnfqwpo2+dCpWlRs0otMuAzKEcoF+
	7DIl6T04XYjq2MdibKD72dNhziOxbdvXnqrlV6IATfOjwuFiLOSlOubkGO+RfWfc/zQdM4
	J8NZlYzedzt/Ru1Y/Eiu9NavpoB7ZcI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Stanislav Fort <stanislav.fort@aisle.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, hannes@cmpxchg.org, mhocko@kernel.org,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	akpm@linux-foundation.org, stable@vger.kernel.org,
	Stanislav Fort <disclosure@aisle.com>
Subject: Re: [PATCH] mm/memcg: v1: account event registrations and drop
 world-writable cgroup.event_control
Message-ID: <aLnbXSxyzhGYGjks@google.com>
References: <20250904181248.5527-1-disclosure@aisle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904181248.5527-1-disclosure@aisle.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: jo4umdzxgei8tuco1sdy8ktshuk9p8rs
X-Rspam-User: 
X-Rspamd-Queue-Id: 903A3A0004
X-Rspamd-Server: rspam01
X-HE-Tag: 1757010789-269379
X-HE-Meta: U2FsdGVkX1+bUhuq/8NuUHAxAvLIbl3JexODvIVuebsZB2t05SHNuJ3Ew9Dm4yYCX2Patese+etXPJUHOaMya5+QFpEwttNpbuCmmC/+o8OdP6qYuk5JpTq5YsgqM2cfmhti4BCcb6K7oRZAxp6GVoQBNdvmTLJ35Rr5edHYdmHZQj/ClfdiOHiEzJc2TjHjLDurXxOuxpysZnOc44yRKTcUYBLxHl1BpFHBOyitTo1HFtVwAYHamhOU8QMPti/c05b+9kAPXu5P58uDs2jfd+MjWB1LN7tGRgsyfw1dSBfL5yZ0cO0C5OQKJ59YKGWzOHS90g8IzOIcl8OzbYZ+km0HqvumjOBc9R4xZuRp/IW7lkGR6HoIMWYzyftG+aghxMaK5S3mjIChAU1TSNYRlRADisqqYwY1CjMYgDetobd/dmalD4TCWW0774jvPXl0OHS20JxPRxjdi+GGFFu6XaHc2M3FCpnC3AJRIbZjNDmBnZwD9VRERvRqdA0d++fZByujXfsRNJkIdv8MCu/1MlQTywqQyoytDWatMzlVBONQZyPjZnaiq0+3fbRfgWNXHE9fQBdlRJ3yl4Gz3ziFdBL4aCA/Lzpb71G3ZRB07c4J//TZ1BXH7mYXygPQ/tiEDpaF6CB5gpHxtgI42ybZqMfwmja2IDAbgltdBmbvS8rZOxhfrs1sd0Sn1YcbSbbazEU2Qt/9gZGaoxHuD6hIQAzgP3RLcjAi1n+MDn2qBh/MOMYqoxw3nVQGUykWccoa6Tc/axdsciJlmb2xzIwZaLRaFFCG0mMjOxYqdCFSc6GAXQfP9lWGcGqOf0x+kyGPK9gVzo9CemK01/rzO0m9FRe47riPQjS7uG35BToISF+COI8F84FGbJOL67Nu9wgqTXFiXJchU5keiaYIjLvKRwE5GVUPwPOEhuDG1z2ovwrJ+tCSbBQKs/jVZwQ6/0kihq6UMAI8mbnvgR1vkZr
 CfUxLJWC
 LvrXKIenfhg8FXgqgMBZURqweXHI+DdYBb1fR8bOlJGVjilLCxGVwyhUyCQwFWHKc2SuspLIklhr1Bbg11X5+4gGsvUm73NRW+q0i7/u2h5FXtPzof7IBaRew9y6dAbSog+9dVzzKJzi3vZr7EtJSDaCTicATFgQWbzhdC1ajg8pkjC2ZOahnNJ9Dp8pfzfsvQgLuzgzwTLXfaIW3bpn428SAkDYtA6MTLqlS9o5IktUftUspeFxpu8tG9Lv+Gnw+Kg8sCQiWzOdXGU94ceN8WTNIIzUbpUtcfIKedIJiF0F3N0nR3nqhvVKWu2GJMXL5Ppl9PHRRi4Fah5LsWfUTpT0Rk9lmLwtO1sqKaFHi/DosoaTjAn3ca8enrzuto33qJIQQGrKW/GVgZO/2bBF/oRwvNZEmCcTdlczQoyZo0YXAphud4qtrE3QyDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 09:12:48PM +0300, Stanislav Fort wrote:
> In cgroup v1, the legacy cgroup.event_control file is world-writable and allows unprivileged users to register unbounded events and thresholds. Each registration allocates kernel memory without capping or memcg charging, which can be abused to exhaust kernel memory in affected configurations.
> 
> Make the following minimal changes:
> - Account allocations with __GFP_ACCOUNT in event and threshold registration.
> - Remove CFTYPE_WORLD_WRITABLE from cgroup.event_control to make it owner-writable.
> 
> This does not affect cgroup v2. Allocations are still subject to kmem accounting being enabled, but this reduces unbounded global growth.
> 
> Reported-by: Stanislav Fort <disclosure@aisle.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanislav Fort <disclosure@aisle.com>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Small nit: please, use GFP_KERNEL_ACCOUNT instead of
GFP_KERNEL | __GFP_ACCOUNT.

Thanks!

