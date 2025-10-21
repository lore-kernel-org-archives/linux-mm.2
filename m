Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4C00CCD1A7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 14:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29E0E8E0014; Tue, 21 Oct 2025 10:56:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 225A48E0002; Tue, 21 Oct 2025 10:56:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1159E8E0014; Tue, 21 Oct 2025 10:56:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EEFB68E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 10:56:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B1D811A6C4
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 14:56:12 +0000 (UTC)
X-FDA: 84022421784.05.65FF21D
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9CE232000C
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 14:56:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hRQM+nfy;
	spf=pass (imf03.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761058571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yDUKZOmUdpEspEjk38NCEBEi7RBBSKGRQVxFp4ovgCY=;
	b=7SRcBuGWS5tpCddUNscAI4RudwTxdoWksGFEX5Bb2Fx2Xlj/mH+o17y/LwwpBlPkB2cRSY
	wfCaCzfE3pMJBVlRme/HoapdK1mH8UAZP2+16vYo/KGBRpcoToiRfL5hav6olVPCl0YSEa
	y/IG0vZYbohGkX1RuVuafXLScTwXXS8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761058571; a=rsa-sha256;
	cv=none;
	b=OB3W0l0e4QlPf6ek4/YP2Oj5NYcEW0cXv7RYH+qLY7wAjLFlfYXspwS59gJuoL6v92hvFO
	BvSSxgQUPqCdxMIg99PWJC43k59nKjEspAQuB/Kodi3RhuqUjmrMdqSmEbLMqU8tlv0HUj
	pQGjJT/EOpOAbPU6AD8gWAEpZZGDHlE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hRQM+nfy;
	spf=pass (imf03.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761058568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yDUKZOmUdpEspEjk38NCEBEi7RBBSKGRQVxFp4ovgCY=;
	b=hRQM+nfyh7A02n5iI1IGpmRje6J6ewsfaTrZsA+WprPNBIa4qZTZM1++K0BmPWbC6Kwfun
	ea0C9zH9GBjZkWuwO20xZv26CXvWFGlH7XgQSQIfxQ2KzQCBEgMCJuO/rtHsuBiPqYFrEa
	F3wpC1hH1PzYQSO1Fb614Ew/RZEqarM=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: William Kucharski <william.kucharski@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,  Andrew Morton
 <akpm@linux-foundation.org>,  Christoph Lameter <cl@gentwo.org>,  David
 Rientjes <rientjes@google.com>,  Harry Yoo <harry.yoo@oracle.com>,  Paul
 Mundt <lethal@linux-sh.org>,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Remove reference to destructor in comment in
 calculate_sizes()
In-Reply-To: <20251021110004.2209008-1-william.kucharski@oracle.com> (William
	Kucharski's message of "Tue, 21 Oct 2025 05:00:04 -0600")
References: <20251021110004.2209008-1-william.kucharski@oracle.com>
Date: Tue, 21 Oct 2025 07:55:57 -0700
Message-ID: <87sefc5mo2.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: 94d7df8m1nw5rgknqibxhhhzc3xoehbg
X-Rspam-User: 
X-Rspamd-Queue-Id: 9CE232000C
X-HE-Tag: 1761058570-48159
X-HE-Meta: U2FsdGVkX188qfULGrqoPwo8L0IquXNUJTsqqg6S5rrrW+tlNi6vPOGjmovah6TAGDpUA6SZkhKJqw6P6d6yJVQPZkp/2TNcSdoJMB4+vCW3mHrv7jYZw1sdgJnhH5dcp2xY4rQ6OjTdhJIt0EI+Ky272jJ563UNDijZukXehtBGHEeH3KyZc3Xg5/XPHtYbCA+M5IgRd1dIg/UamtXTrcvXrReLdQa3Xp0R5rXIZ26G9QnFNKiMjmacrMpsNAVImKI/JOXmjptBWr44URjhGLIm6T+KgAAo8QExcr4WKPOxsta7qapoN8LWJ9WkAk1EAOELxNGyb1LGZAmH28cY+6sNZ1Rre0Hw/ftIRDYoScT9p3Hi+NZoy1kQdwQvVvnJjNqMWIY1SjPlaXhxd7/kC5Yuoc3HPTKM5f5QvtsHwxY/qenLLL0Yjyg3KoqXnH2k+PnnTLIGjRBhcp7YyxitkZaALS4M10P34ISZPZ31hlcPtZNxHW1xGs+PZ/qmrK2younbpJR5X58oZ16mMA6wNlGCjUlO3b94pQfWxa6WBBFtZhRRIFdWGNkvV4TQ0vWoXI555eiMRC4q+EK/IFiknyNpRT783lYz9wxpTA053+gYjoQYL+SAUvp6pEpY1DqogrSM66tzU2y4JnfYkM0O5iVcQNiDt3DkBwOC/UJ4JBAW2ENKhZYqPRbkt/8r4X50JjNFhuEZQoZnRMQe2zMCO7gO8b2474FvzHy60iyBZZPYasQGH4lR1nc+3WFMEY664eSpc5gUAUkp0CZLGrG8/fJtJZ0oCgM/r7jsBlgTJ2epsBVOZRfDp/4RL0inGjGY7ISVrkZ54jl/AkXE6EGXkJaEqwF5g2h0+CAhDM89nIFJTodBqiI79HPT6X2AjnuOPFem5/M5mIiihjXE5iW8ofZRX5F69FwqjvYS0wfmkCtzC6KIp836UONl0S3jJo/4pk6qZTLEr97ysipCY/H
 LPTNPXwX
 V2qx4GdgCqsnzuoQkbwrVHKcA7G3sx5VYYzUCWyCz1DL+6YOjpnED9hgEEPYdoFxpgkLrQu/De2zX98fNhDyEZ1n0GFItbn9KBkAwwRvksx3EIbp9/AwxeNm0S+R5a+7TlVSostFs7g3WJQOD5TJmRY0lSt4invaE+76bV3HYVEWyvypGt/NV1wc7CNCGfzCBL7J64bJ1PSsdEP4wsOZadY/nZmVL0p+6kyQnFcOmYrsOcE4kpnqLZWCVRizMh0CUAkwHSU+2lU5eE+Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

William Kucharski <william.kucharski@oracle.com> writes:

> The commit that removed support for destructors from kmem_cache_alloc()
> never removed the comment regarding destructors in the explanation
> of the possible relocation of the free pointer in calculate_sizes().
>
> Fixes: 20c2df83d25c ("mm: Remove slab destructors from kmem_cache_create().")
> Signed-off-by: William Kucharski <william.kucharski@oracle.com>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Thanks!

