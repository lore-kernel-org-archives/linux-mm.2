Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74075C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 13:05:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 099F46B00B0; Tue, 30 Jun 2026 09:05:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04BD36B00B1; Tue, 30 Jun 2026 09:05:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECCF16B00B2; Tue, 30 Jun 2026 09:05:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C2B976B00B0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:05:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 424AF1C6EE6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:05:32 +0000 (UTC)
X-FDA: 84936600504.17.09FF8BA
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6A1C11C0010
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:05:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QyqkHfTJ;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782824730;
	b=Tr1VTeT5dO1FMoTa6zObwcyJ2b2lhvqmyu79Xr+gREEMnX6YOmQTcv/pePDOYhxO7KDRFH
	fCDemmnZB+Ii0d+FBBVkdMlnkn8cj+q+19jum16JyEJUQYCnagYU6xX/fMmXy9yThkKoOX
	rVXDrWR533shlGJ6O5kryqF2vB1uuWA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782824730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z1cI5B5Ab1RyoAnl7AMp4M2meU2wzOcYFwePlws/s7Y=;
	b=TpM4zcMkb/r58g7yGmMMTdALNWzQOmRvbgWdpHTqa+dcSmfTJDUsgHfdRq0uVjAJxgI4mG
	ZBAtrgJ9LG8ozEIXOyYFDt3iatuoq5gTvMUVD6k05Qrk9Pct7ZMizn9BSQFUIsUrTxAaHu
	N2zUtljoZomP8br6gTUnGdIK20eN33M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QyqkHfTJ;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782824724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z1cI5B5Ab1RyoAnl7AMp4M2meU2wzOcYFwePlws/s7Y=;
	b=QyqkHfTJ+XAWzZ9M3jg2wk17wA+JCCfj9+kAYl2Ss7BmyfT9mRa7IiFJdJDOtWi1oOXs/z
	Q+LxXZJUZU++ZW88ITGRZ6N9WbLYVz8Wd/c9GvSco275i1rPYACgHiDUSwHilYKZ3fG0OA
	WUWVYpDwYwT7ciQlkAGcDibQxzwxCTk=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: davem@davemloft.net,
	andreas@gaisler.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jannh@google.com,
	peterz@infradead.org,
	osalvador@kernel.org,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v2 3/3] mm: cleanup clear_not_present_full_ptes() and rename to clear_non_present_ptes()
Date: Tue, 30 Jun 2026 21:05:13 +0800
Message-Id: <20260630130513.28882-1-lance.yang@linux.dev>
In-Reply-To: <20260629-clear_not_present_full_ptes-v2-3-96089871a1e7@kernel.org>
References: <20260629-clear_not_present_full_ptes-v2-3-96089871a1e7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6A1C11C0010
X-Stat-Signature: o6xauinme9uuam869ffuwmcf3y39ryem
X-HE-Tag: 1782824728-221290
X-HE-Meta: U2FsdGVkX19XbnXEpJbEzVMZ5eyGC/y0cH68jWkboR1eDXwSiDkDNI7xxIbImsuydSQ2sLxWNOUlCJsbySB5yIMQRLjtd4iiDBGIsnfHwUMTmN0j9rMSSF0maR3Tlv/JxcoprlE6g0CzthFEuYEy9kPpWnrgO3qVESqEnddu7ifPccUK0plFKIYsA9j7c9EvjF0AiE8ScNaOkR8n50qXMBadVaRb3AkIDfx7aLGR8au7uMGB6ZaLq9tvzfvch0wRFCBA0xBcnZMjUYBDG0PkhWQqx1cF2Yfv1onifJHZ0mgUzt8uOBxZxJUXLodaJC0CR05xCWtjkppMRb51I1EGoqg+ISspg3jkiMK8vzwUNhoxCQUVFEYDxuZPUIa1Y471jXa0RrZ06DfgIdYC/s3ohjYb51yplVSJ6dd/gMkgkZ1tYSMzAz0Y+iAzmNqCeWE/KZ1vWQkDPTc1ho954vDpmRHnUMxuhYRhRlIo0RDno8E9NkoKG+XbUqhlbXjggQgQPX5MQL+KlIVlL1Q1XWsiGnVEPaN0aQsIJRouKs2VQbZyswRQsKrCGlVlx1gjcAQqTzzn2C8jnduG7L37rB20evGF+YysSnxSaVzm4OXwWudZ0SjIqPeY843IVfDUtOrRhAnQywzuBSRYpfwztvTTwYfYEZGvGAtFAkVqqA70VdSgwQmAyqLH1q4dv0hGnlFkcM+1I0L370A6vkIpZh4ynWlIszNqC2xKYGB3dAXmX3NcZBG310C0CfBx+xKd5jH0zUdBjYKn3s5H6FLwsvywPwdCY91601c2NztBM9WsmL22XsSI6pLQ/j4Fp9A19ujREEmI1nzgHTpt8Est2pTPoolWeWbmLIOkZWZ76sA7ZtQpEN18PMb+PmqVrw5tOClw2uedOY4WIxsUoH7sEEjcXQqd6GTZkjpxSWaA+K7RPibelT2hIrkS9xm0IiPfu48NoXKFz9Bp9xMKDA7iXoC
 6hPmN3eY
 EQEsKldsBuzwxrmpuLzBa/l0EzCVDQ3BIuPmi83MuOmOLJtI0S0HfeehjSM3nAq2cL7R4QCEwUo5aZKRZKg1BOqmAzOCCANSRQfhMMZap073D4kAcwz1W7FnvrOcJFyGy8q/FimMwXF7BsoceXhGONk46epkln0JBopRuYjABvEjZABGhNV1ANOF3oFQvUvye+bsUdWGwCxdzU1Tli8wwdU1ynlo88CjTD58HhChuu477DJ/bid3TnfnlshfvWKELpzEALnsU24sCmU5Eq5Zp/Ki6lA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, Jun 29, 2026 at 03:49:49PM +0200, David Hildenbrand (Arm) wrote:
>Let's clean it up a bit:
>
>(1) There is no need to pass "full" anymore.
>
>(2) No architecture overwrites it, and there isn't really a good reason
>    to do so when dealing with non-resent PTEs.

Nit: "non-resent PTEs" -> "non-present PTEs".

>
>(3) While at it, call it "non-present", similar to copy_nonpresent_pte()
>    and zap_nonpresent_ptes().
>
>It's a shame that we have clear_non_present_ptes() correspond to
>pte_clear() and clear_ptes() correspond to ptep_get_and_clear*().
>
>Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Nice cleanup! Feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

