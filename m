Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 107B0C88E77
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 22:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0118B6B0088; Tue, 15 Sep 2026 18:35:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F05DE6B008C; Tue, 15 Sep 2026 18:35:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF2876B0092; Tue, 15 Sep 2026 18:35:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C098B6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 18:35:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 51A22A057C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:35:46 +0000 (UTC)
X-FDA: 85217455092.08.AEE3620
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7F9ECC0002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:35:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=r7LHLzbd;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789511744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RhTnPDaCLd+U+z7ApKM0YP7sn1aaMXZYDn+8iLwc6eQ=;
	b=PKEvrAnceYP8KjFjUm1cDw7IGeJt22Y6+MUgBoyT7Qu8NnHjNtDdBP1nVN5JrEquBFn2wR
	tZzKqSbs9iaCQL0gRxdKefbBJ/mDryMPhiWRzSv0SF3H14CPZlc3ROdbcloY/gGCJyqtVQ
	Lnn1eFOnMiY9w2RO5+MTfA+MrBPMz84=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789511744;
	b=A4yq9nrmldrMCJzYVeLc+hV02/hbnHaahTURDhZVAmwsriWKXREg31rMyvS1uIMTuJEnvn
	/qwZuQpGDy0vOrcCmA8xVjTfzMmcj4Ybj4f0LhwWZZiZKjtTK6zkE4QpW2AhFifgjKBS3+
	fU57FNpCiGe+I/83euBCdeuOk6oIaFM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=r7LHLzbd;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D83560008;
	Tue, 15 Sep 2026 22:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080761F000FF;
	Tue, 15 Sep 2026 22:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789511743;
	bh=RhTnPDaCLd+U+z7ApKM0YP7sn1aaMXZYDn+8iLwc6eQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=r7LHLzbd0Mx3R5rOXvWP+PpUysVwGELhq01tND4SbqiwRuh/Mcy1MSIKsa7U7icZS
	 UUFaeKBMV0dkcXN8kqoIr3ZGSP8zIrdffHc0AXlo67wZ3OYRQm30Cpvlh5iUHBMuzz
	 hrr4PrWEKFpePZ2nISNQaVbut+HzuB+G2w1VIGOM=
Date: Tue, 15 Sep 2026 15:35:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dima Koziuk <dmytrokoziuk68@gmail.com>
Cc: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: kmsan: fix iounmap metadata teardown
Message-Id: <20260915153542.3b9afbd00f7e6cea87a3350b@linux-foundation.org>
In-Reply-To: <20260915160207.2952-1-dmytrokoziuk68@gmail.com>
References: <20260915160207.2952-1-dmytrokoziuk68@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 7xiye6nfcy7trckhx1h9jz7n65bc8nyo
X-Rspamd-Queue-Id: 7F9ECC0002
X-HE-Tag: 1789511744-832973
X-HE-Meta: U2FsdGVkX1/Dy0wEGs3ZF9q7C7FMpwjM69rhHp5rA7evKAwr840NycA0UcRG+eQ4wB9Cgd5pSTRYfm5Rvhqtw6KVAPOpzLTnN7wgukl10jTf+b6jNP9a9GLOsyKvLleUFwR9+p6uzOgZOeOrAgvZed5V8aJyfSeJrIAn3/6W4dueJFYVJJ+H6vMefrS9WL6QdcJE3E7x5CFW03+WH5bg/zyxUe5nEAdhz9Fi4x0BBFEtehA+U31h1G7yTtkYEdvP4z5wcc3uY1is55KVW/Ld8kgxE7JWiqFB+x/wOTwnHkQk4H5bvUQppJj3NR9h3Uv4595u1vLxEL1+oUPAHMmW0+2AGVl/JEqtpbrA8JQhZNTnJbXYFBKCeCneBvZiSXXh1QCVN7DI4tOlKDjSK/eoRwMuI4jMVnJu4rX8TqoR9BrNR54H0d7AeDuePm71nAsV+k4H2eLdnlcMg8QJ6flXM6n/vMhc254oFsY9ki2pa1lGE0FRBsCNQjDkOq44tke661fTaooyI5+auY3hV/4Mtk1WFvEPqY5usjRYjUB2ZWPOBzc20x3sqKPqDbsqSjeSW0nzWHE4rWa2bEa6Sr1Nab4dPYJLShyJYb9OELDk//aMlnetzFlU0KSZWZ1goPd79lQa8ORdH1REr5az8V4hqM6rK5yUFxnlJxfljAMrNTA29ATaVBdtz4uaUz8vzDFmV4LdDPKWfPPFCG2bb1+KZoWiGL8Hp7G0GKMKRIdBjo6zcc6Y6SKii84bT3QKMwjUwhNmH8HsG38uqz0VgXXYZ+x/nj28L9UduKZ+UHAoYYYv+Apzk3EJr/3ek7fkSUa/2DSFSHHVcHivJRkRkkm6SVtL/pH52n2FwH1x2ZWmqcT+4ODjFfo4pQQ3NAwO/IMP+GyXUmEmskMflJ4YW1SgxEasRT4oa5v8xr0kPUVfEsavfKPn8sVitI3GDqR5UGs2Yc+bumP5dBFFssLdvgm
 MMptXFDC
 joBQQDI4/6HmOdA6+dQw4Lf8BI7EbIunjM/U0wP56FU22XGPnjewn38UEhBGC2BDsZdWVmVQL1LXn6u/VdPifshMkAMbD9lyP6GXTdRJjqlA9pimayAvLJDFxntq25NMGfKy14918SD8tPAv44ynmRKHESUKKu1XQtj2kbUvciNQHWCx5Tx07oBmUkaNNszhbGagtBOWdB6ptIMFhbSUJKpdWpC6rWQ0+3LUKVtMAu2E1fUX8oSqsDWFPVVZ6HkU2shrTQoYO/u/9+jtDnrwpmJ2bU+B5dUH/yi43cQjmENtZhgleJohT2d+D5Hh6Uzqhb4rWcj1PzMjXnpk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 19:02:06 +0300 Dima Koziuk <dmytrokoziuk68@gmail.com> wrote:

> While studying the code, I noticed that kmsan_iounmap_page_range() calls
> __vunmap_range_noflush(v_shadow, vmalloc_shadow(end)) inside its per-page
> loop, and does the same for origin. The first iteration therefore unmaps
> the entire metadata range, removing the PTEs for later pages before the
> loop can recover their backing pages.

Thanks.

AI review might have a found a couple of issues - please check?

https://sashiko.dev/#/patchset/20260915160207.2952-1-dmytrokoziuk68@gmail.com

