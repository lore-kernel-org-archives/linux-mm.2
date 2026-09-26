Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06777C98328
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 09:32:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8B136B0088; Sat, 26 Sep 2026 05:32:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3BA96B008A; Sat, 26 Sep 2026 05:32:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7B726B00A5; Sat, 26 Sep 2026 05:32:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B434F6B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:32:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 363E21A0565
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:32:03 +0000 (UTC)
X-FDA: 85255396926.04.33A866E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9A43C20002
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:32:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K5QPVHkb;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790415121;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aahV+yzdFExMYzQQ+dk85KZLNDS7wQg/3/bXdqkAuRo=;
	b=bB0Pb2HB9SU3GCyHgj2NS6bp6dD1M3J8hbGyKlP5Tk+O5vqEVs/AvBCEjI6ZVhmKfPLzYc
	DSDFgR+OR1g/ibXaaoyMA58fuifllxtFbnANj1uaFd+fDrq8heeMzqZuyrAstSjmTmU5BO
	PPK2S4BRE7asMj5AYSqoc2l3iinqrgY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790415121;
	b=OmGcWSm8OZnKZMGNjO+BtzrGGc/mifoY3gMK/PWtLKfMm6OmzyiFATGueoU8ggQ3Q3esp1
	TjxNefp+2cwino2fazGIwl7kii4e2EzePVXThkb8Evj+EtziOC1rdHImKQ6c0fdiEJJat9
	aBmafrDS859deo1CRzNmHT5jef/BSOM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K5QPVHkb;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F3F26020C;
	Sat, 26 Sep 2026 09:32:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5727C1F000FF;
	Sat, 26 Sep 2026 09:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790415120;
	bh=aahV+yzdFExMYzQQ+dk85KZLNDS7wQg/3/bXdqkAuRo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K5QPVHkbO0pFLaCwEOWX/lc1IEnhnMfFx2Tvwe9TgoOqETu+9ttswGq7skYIVlyTk
	 vM5UiMK+EADQGe3DrTxeY2XdszOTw1m7zLkuQlLFkF+kjSuQIIcFWmeaqc5M7x0r1F
	 NlP7zcAg7LLrSwxBWhqhDHbvxcssDrfOUPD7nmF9E5o2Z1iJyKC2gMljqaLCeVbNWx
	 q55RQmOacgCAOek1cnAlt470FG6VjJsLjVZRUKzqwULlIbeXvVvNLTxmlDE0PX3Pqd
	 Ls4l3QW875CN/xouc33gBcC4fyAIVk6J7uFPYjqVRsS3zZ86/HzQhloBm8TBEcA2HO
	 hd8JhY9X7bmaw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/2] memblock: use binary search to locate candidate
 regions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tarun Sahu" <tarunsahu@google.com>, dmatlack@google.com, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Mike
 Rapoport" <rppt@kernel.org>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, "Pratyush Yadav" <pratyush@kernel.org>, linux-kernel@vger.kernel.org, dev.jain@arm.com
In-Reply-To: <20260926092448.4090401-2-tarunsahu@google.com>
References: <20260926092448.4090401-1-tarunsahu@google.com>
 <20260926092448.4090401-2-tarunsahu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 26 Sep 2026 09:31:59 +0000
Message-Id: <20260926093200.5727C1F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9A43C20002
X-Stat-Signature: hwixkj9ac8nqaa87kau63j9jkce1shqu
X-HE-Tag: 1790415121-505588
X-HE-Meta: U2FsdGVkX1+xhrPbW9IYYCCz6PlySMA2ncHmtcAtOVY6qxFEJ+we5fNSVnIaJRnfD2MCP3/S+zfw1UMMHMu+B8MOHQI3Fl05Qj8t7cu09ZXXlHNVz1zQTr2XrTwQx+j0hl/ZwX/sKDJ/knQs6jQfWnzI7OYnILi7M2s2HsTuDWvcGIDKzqyiLdQB2gfCG5LB8R2oGfTxVwASLJt7ROwZ/H7yadz7qS5Nm/DHkGQD8Yil/M0I7W1wnHpUHTU5Exos6+OHCFNn/ICktXY8P0EKT1H5BLJ6zO4vF5mH8S0wTJSTe3ELtZqeOlmzheM+vgWSsEpr7eCAQUTAiYiZnDHmrwL5Wj9N3RPzWAdE4wRHQVP/ARAz9ZlGdhxFGLDdduKkGLrb+RKyiKZvW5YE4wYU2R+zvEpwao8pGTjwdl72CQWlLs1lMZAfHVV7TFopVa7sWH6/lreH+3dwbNZ3V8vbYTVEKWl9P3ur1jy9jxLKXipRtAbwq2aDNgxy24tpGlfbvBJxpYgEi0mrlOtDl51aX2uPM3awTVfgev5JN00v66U0B4kIXBxOn/ENkm29am8QRPeNoyj5hDQcsUDmipbPE96GojmcbVeLyiGH+a8CDHfizr1G8XWfTqClOFgzHczbU3oJ2mez/RQXAGaytLjbQLgtGbG+xMwEovefAXOreiZqbFiSgnnuo7s+lsOzX5Q+T2UMFPfkyiZoYxylTn09k0lPAEwkOH95jNQBeKxSq/nSwQzBkt09fitphwxmVBk1MnbVyQvQ/DJwdXwYyDlJg1Y3OxdYVssrzL0KBRRgMvPNQ5V/m8wiPWAqHfV4E+rGXKSPpLAfZNNniPMpssfnXMKHUOIMFv8Xgd+avq8p9kYGFN5I2h7rLi0V0gHpap09zQH7LlA+JUDQ0IwVgm9utGx3NLdlsPbXdfpET5NvetVS9d605J0SGDXmbOoHrsv7RMy7oqQuJWeTBGxhHvX
 6kPZId/P
 Cmffi6+OQREnVcKEL83j5yubjf0HkcAGKPtJuNHfGPPaVgPiqIMyjugY/PaTx4mIL1PD0eH8ANQCGfM0720KHofr9LtAJZ8E1fPl4HHTOXLsvfUL9ofkZvSmrKoY0Q6W1HqWm2mj5EI6cFL/30HNEoC1qDh6OVXlkPwDgvifO5ck4Kl7R4gLLQMKeDqPfT8LWfde1XkR0tzSrQq7AyL4wpJFFSpsZuOiwCfv8okKsx7OhN9mVTN4opf4L8i4c2RcXxlZi1Wl4bNskWRAySbfFJACFse9WOFhdfuKAIXoa3AGwWLZV3MPj4xTnsk82mXyA88Sr5yPuFQGccNnVXXF6okPYmnjzaZI2/9Puoq9g6dLvBl8XW9fPL3X8l80yQI5vTSXhbf4AR41W2Lx14sAhdFaxINiuSvEf5UBcBVccEAZZCgZhz+KuktnJ2i5AXhD0T533TmJNL0uAsPh6WfAh3qe7TMivM91Ha+pdKVMF9jjiqQepxop/v0b4NVutnfu78Cyyd329DXM1T35MkiL84l7TOj478OxyLwFcgxrFiKC4BQDLBJJtCr80lVXoI0T7l9QQ7AKvAaDiWagRXqrbulyX2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm: commit message falsely claims O(N log N) worst-case complexi=
ty
--

commit ffd047af563941b5aabcd86a52d569f9b40c01ec
Author: Tarun Sahu <tarunsahu@google.com>

memblock: use binary search to locate candidate regions

This commit introduces a binary search helper, memblock_bsearch_start(),
to optimize finding candidate regions in memblock_add_range() and
memblock_isolate_range(), aiming to reduce boot-time overhead during heavy
memory fragmentation.

> Under heavy memory fragmentation (such as KHO page preservation registeri=
ng
> hundreds of thousands of disjoint folios), scanning from index 0 on every
> insertion and isolation results in O(N^2) complexity, causing boot-time
> memory retrieval to take several minutes (~268s for 393k pages).
>
> Using binary search reduces the worst-case complexity to O(N log N)
> (and O(N) for sequential appends), cutting KHO memory retrieval time
> from ~268s to ~50ms.

[Severity: Medium]
Is the claim of O(N log N) worst-case complexity mathematically accurate he=
re?

While the binary search reduces the time to locate the insertion index to
O(log N), the regions are still stored in a contiguous array. If disjoint
memory regions are inserted in an order that requires inserting into the
middle of the array, the subsequent elements still need to be shifted.

Looking at memblock_insert_region() which is called during insertion:

static void __init_memblock memblock_insert_region(...)
{
        ...
        memmove(rgn + 1, rgn, (type->cnt - idx) * sizeof(*rgn));
        ...
}

Because this memory move operation guarantees the worst-case complexity of a
single insertion remains O(N), wouldn't inserting N disjoint regions in
descending or scattered order still result in an O(N^2) worst-case time
complexity overall?

The described KHO workload sequentially appends regions, which avoids the
shifting overhead and achieves O(N) overall. Could the commit message be
updated to clarify that this patch improves sequential insertion to O(N),
but the worst-case for fragmented insertions remains O(N^2) due to the array
shifting?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260926092448.4090=
401-1-tarunsahu@google.com?part=3D2

