Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E6D6FED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 17:41:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0BF86B008C; Fri, 24 Apr 2026 13:41:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BD9E6B0092; Fri, 24 Apr 2026 13:41:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D29B6B0093; Fri, 24 Apr 2026 13:41:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7AA716B008C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:41:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1AA0812027C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:41:10 +0000 (UTC)
X-FDA: 84694165500.12.CA928D1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id EEC1A140009
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:41:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cPQuVxEx;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777052468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DPp5UqOqR6iEsJzPDlrd2wYkt5VSV6X6hLwp3tQhkDs=;
	b=wNhxiW9h0gPT5Cpbeh3TUCqO4GiuuKjDKjgzZ9jtV0rralgoKt7Ju4cxNl82TXIY51lQp9
	cN2ADYAj8xoW1LO9JHCobqVNJOeq/8kN7XeDSkzsNhz2u1doJ5t0V1AuwCcEYTSCZ5Vm0m
	0yVqBqfK/cbvx+gM0uMBC8ThOftV2mI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cPQuVxEx;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777052468; a=rsa-sha256;
	cv=none;
	b=KYbSlK4Jur3pxfqf7PjxIL/Yf7GXZWZWBEYDau1oGpO5vHA/N8z0WkTwodOxwVlxKrpge6
	A2rPFBXnMr8d+4DOGdOK4WCIDZHkSdUxPcUhgtb3Fd1vqZU0V90jreNPKCpJFKsxuM7KPo
	f3nMQ8OegE8fZccw8iF9lbWiAzJxaUE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3165835AF;
	Fri, 24 Apr 2026 10:41:01 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 76B033F7B4;
	Fri, 24 Apr 2026 10:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777052466; bh=Teo20paGpHrbq1obZzr+ivLwVPOuVk5CdKUvJCX5l/o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cPQuVxEx+ilikHFEHbBAVKhTf7vRHHLLoWB14XBOqWjDoo4pBgHSEjHSse8e2RtPO
	 3Eec2OmUSUZv5Oial8RpzuMfHYSmBrpGQWeJUf9s5ByfOdIZG35t86xdh5x2kNvtC5
	 y/tw5yFTZfb3QB9tMRqplRkgCa2PIkOBKnomrZiw=
Date: Fri, 24 Apr 2026 18:41:00 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dev Jain <dev.jain@arm.com>
Cc: arnd@arndb.de, kees@kernel.org, mingo@redhat.com, peterz@infradead.org,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	akpm@linux-foundation.org, david@kernel.org, urezki@gmail.com,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, tglx@kernel.org,
	usama.anjum@arm.com, mathieu.desnoyers@efficios.com,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH v3 3/3] mm: skip KASAN tagging for page-allocated page
 tables
Message-ID: <aeurLGC4ohFU9Xtn@arm.com>
References: <20260424130157.3163009-1-dev.jain@arm.com>
 <20260424130157.3163009-4-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424130157.3163009-4-dev.jain@arm.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EEC1A140009
X-Stat-Signature: zjyonne1q9y5qthai3gogj5xp5z4f6ys
X-Rspam-User: 
X-HE-Tag: 1777052467-864834
X-HE-Meta: U2FsdGVkX19ydIqEWKpQvPBxpwmjsXZpn3mKmZ9t65/I3Uwag0pDDjoX4AlF84owN0AF98P2P9J3GTFnpzQcd9LgQcXL0CIzTUjk/GCfJhrLRDRi5/6Wx7OXTNDTCEWxqBCa80NYK+HINnSCQTjaIaKWROM518fTc8GWJzQj8aHZAQh+UpoLGUNqvy8f/KKfVgD6uocObQ5eP46ugK9wiowSjkZ8eYWaQy5jkf/6F5GjAYPBowtpjz2mvSv258SG2Wojft2tOkiWYayoshEcMJiDfYR14lMarUjReUsmuItzvGR9+mSt+cNzmawSPkGkwyFFUiJNASCNMy/3fkqDIZmT4FrniVlzD1muo3x4p1Najo9vt8TS/IevX5oE1T+SW3DJ9rU7OfDYTO3BVj81xQM/CXvQnWJckb76anBv3ry+LC+1ZJZkguG5ckWe9qwaM5NuqgyKB5mxheR4ApytV+H2g2DhkAMLmBw+QeY7gr7y+wNWJjtTs5vZc91t1RB1nCnQiZN/utLXDRpgJW/fqEY1faK+Fi1f8iff42x0t5hGy4UooxRXONBsWYS4tZZrpPZRf1voe9jUvbYw2PiIYCa2dB8CgP+RMvGz/c6R0U92Khc9zWZVTHYNAVHRkwImOrqENlusLAKfqjBw2Q81JpUNlKXGovF9XpQy4Sh2U7URCIFF/TFD5OTkmscnssOD5ylp71Md10Vr/crvmFWCwXQU7idmo6e7wknL6QO6VrvKEHuLVjxuBBK8P06U+Mmzbgcbv+vb4FP6vGjksYdDqgrYVOsCDjvrGXyoTy3Z5gOnnt+jt3DbGtm+37YucwjCpMZdlKoBL1d0jtlVKtcPB/Ba6jpm+dGO/em7LnMufb6RJq/DsBJ5C+K+rJ+mPwZMdbJNRG14cDcJ1wvjsCZ/xTmjjPJOl1X+r4OhyaaR3CFnNfBR0nBm9qgMb+YdbdrPoEnDdtjqXefWBWbF6aK
 qH3vXSXV
 Hh/y1otyE3gEx6VSMSV+1mXdPNGVrPgBee0c1NsEFRArq3CDkHDU5T2BGJxmlOmvgoyGaH2W6yNRpTIORyOx11bB0X5/ogRCe5fZmqT8Y6wa2Q5+24HSVwSKv32+QgM2601E61XhHRA7sEjZVaOmdSnwnj5mOonaZQakF5nfepDw88Y1CKnhCy35ogM+u0UN4GMN4ZNQz85pZe4kdKiFNZv7sAdBQBndyod1NDIXsnR91k9WCKBo40aPJa1tLkN0ge3iqxkw6UZlOhy6UmzekWd00ke9BCn5dQ5/AVWQIXO/mnyqLbegme1JB230jCcLks8+l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 06:31:57PM +0530, Dev Jain wrote:
> From: Muhammad Usama Anjum <usama.anjum@arm.com>
> 
> Page tables are always accessed via the linear mapping with a match-all
> tag, so HW-tag KASAN never checks them. For page-allocated tables (PTEs
> and PGDs etc), avoid the tag setup and poisoning overhead by using
> __GFP_SKIP_KASAN. SLUB-backed page tables are unchanged for now. (They
> aren't widely used and require more SLUB related skip logic. Leave it
> later.)
> 
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Your signed-off-by is missing. You must add it if you are reposting
someone else's patches.

Also I only got cc'ed on patch 3. You should normally cc all people on
all patches. Maybe you could skip this if the patches are some
independent cleanups but even so, I'd still cc all the others at least
on the cover letter.

-- 
Catalin

