Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60623CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 06:28:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4B046B0005; Tue,  9 Jun 2026 02:28:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFB8A6B0088; Tue,  9 Jun 2026 02:28:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B38D66B008C; Tue,  9 Jun 2026 02:28:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A53296B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 02:28:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4988AC0781
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:28:45 +0000 (UTC)
X-FDA: 84859395810.14.98B18F0
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8244C180003
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:28:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=L71YJc2P;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf16.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780986523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sQDhEvXvj0vskWG5Nod+8TONy/NcJUoddZ5fD+XBrmU=;
	b=NEUxALGbAGhmzm+R8nEmz+kdsBgta4kKTv0WTv4fAIx4UGVHO6QXx5kKyTq4G8tCoajN6c
	EwpDpZybDY1GqGtampdUPhqVAVI1BcVC4MXPRayI8J9e0+SS18RYazQy3kYOq0iH4GlnXi
	Iyi+FX4Dy+cPXtRvz2WA4SAvFCRURMM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=L71YJc2P;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf16.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780986523;
	b=7+h2T+4WE1DzP9OZc8d1li1nzXqrCdbiaGAvuwLpGRTK/Qap9yMLGqnrPYjFG7I3232+v0
	31whA/BDI3r8Pf2lxd+yh2LfZeNQ6+ZEOFsRXGXIjQGOGHCyX4/2InW/FzPPb2Jsb/eD9K
	TfZTSj060K99jopurx89IREIkJCm2EM=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260609062840euoutp01ed1f89a9a47cb8799874003e23899f1e~3Vc3vQ5eO1811818118euoutp01X
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:28:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260609062840euoutp01ed1f89a9a47cb8799874003e23899f1e~3Vc3vQ5eO1811818118euoutp01X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1780986520;
	bh=sQDhEvXvj0vskWG5Nod+8TONy/NcJUoddZ5fD+XBrmU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=L71YJc2PSiiRY1n+YPatJVjODV3Te89KEOTZimaueovjODrs9pyp0pdbH67JiyEmb
	 wCUwBCsxT9/ecX7Nz8TuuKZuUCBE8zVB1UGNkFc3cWAa9XWukALnBxMuvL1JCRzJEL
	 shJ6fMw0Ilby9yFLoZKS/Rtr8A02ChpckDYrgCqw=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260609062840eucas1p1d49831bfdb3447e38a3cadc803a9afc0~3Vc3M9lZT1760217602eucas1p1O;
	Tue,  9 Jun 2026 06:28:40 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260609062837eusmtip165b8ffd20070283bf8a1cc3770a61ba5~3Vc0aQZiY2875428754eusmtip1_;
	Tue,  9 Jun 2026 06:28:36 +0000 (GMT)
Message-ID: <6a9c0f55-fe98-4063-864b-8f7e1f4fefd7@samsung.com>
Date: Tue, 9 Jun 2026 08:28:35 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v7 15/15] arm64: mm: Unmap kernel data/bss entirely from
 the linear map
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Ard Biesheuvel <ardb+git@google.com>,
	linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com,
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts
	<ryan.roberts@arm.com>, Anshuman Khandual <anshuman.khandual@arm.com>, Kevin
	Brodsky <kevin.brodsky@arm.com>, Liz Prucka <lizprucka@google.com>, Seth
	Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, David Hildenbrand <david@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
	linux-mm@kvack.org, linux-hardening@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org
Content-Language: en-US
In-Reply-To: <a1b27e97-182c-485d-a448-56c19c5de2c2@samsung.com>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260609062840eucas1p1d49831bfdb3447e38a3cadc803a9afc0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260609062840eucas1p1d49831bfdb3447e38a3cadc803a9afc0
X-EPHeader: CA
X-CMS-RootMailID: 20260609062840eucas1p1d49831bfdb3447e38a3cadc803a9afc0
References: <20260529150150.1670604-17-ardb+git@google.com>
	<20260529150150.1670604-32-ardb+git@google.com>
	<a1b27e97-182c-485d-a448-56c19c5de2c2@samsung.com>
	<CGME20260609062840eucas1p1d49831bfdb3447e38a3cadc803a9afc0@eucas1p1.samsung.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: wo8y3kp58ck4365ij7ujn66qt9pp3t8i
X-Rspamd-Queue-Id: 8244C180003
X-HE-Tag: 1780986522-960645
X-HE-Meta: U2FsdGVkX19ZXA6KoVM4wkNDmmGo2zuXy1n3yUQrcmKSsyv4FJnAlmFpaFAX1AIU3G7b8JOFPx4klcF4Ies1LVW92xoR1BUhLzW2chvwDjQWpVzBBAUIn6quKCVvcEKP77ES6Ks9j6nDOT4wf4wej4g18nUEYzVa0cygpltDXKvBZ5s2VROUMxLXq9x7HBOKF7dRB0vuc+7NFGLQZAK79BLq8Rkv8T0/yr7XwUo4alugVlPynt40lZxund29GK9XuKsHADGWk3kT94X4Jg8LfFVylT4r2hoNZziBxRgcR9B6dt3nSmF4of6c40GsOUaATNEPI6ufsYtvRPjWK6/G+3gQrs/MzVi38g/uFWMaLrXWDhYNvK+VE9evAe6qMP3a3jUJfwZLbvS4wI44kQFLc1HC1N1hsy8juoBXamvstzZnNOWl7BL4cZ30aH8a5hbFyKwoysJSeppnYYYWDZn19g7v6rNCbbP5Kowz3yajc1cI1zUhkNG2dkMsB5Myshi28osOQav6r+NZRoob8Oqop0/xzH8OS2O9Sz6au2h0JBo9uftnpetY0V6pl+7oA0/8XGZvEQ4e7pw0SGvy9FSw3cn1GcwsgNN5tCOfbvfquq5jVaOLF5jDkPoM7j/eMJVq18EWkKMSOHtghK7WcywqEfLxehNRmhQkeHDwNopENTzAyinw1f9euxO+zUhIbx2EPXZybGH9P0w6hQWy13aPdreCKq3MrmSSIpHBqoT3Yuwr6u7ya0U+3mpHeDs9/njA5ukQu9HCf7NfzZQZzrJ5WARs/dme4R9Qc8ihGilWajbjSeHNKN7R5Wr2JlAZIf/QoLNSM2Ja4TP3Q7s4M+s/UhK5CCEeEf0BWn5VQSWyj/0j4Ft7d/PaPFtuCdHo+rt9AQ+7T20neulWtzQqL0hxSpGUGUCLBuUvK/mUcGXzLqjE8mf9ujS70UgmlmwEZ9V0XekjTzjEkhshj4Ru384
 RHFdrtO2
 9tNiFCsCrhntKloXE3eJ2sYsI1G3kETCR5OOQiGPstg05VuidXTiaRFUGriIL/j1eCjgTQZZ9+H2mD6SuFITwBDzXCEgLOL69+iIVYfatatBf1ll1Fxz07qFbmI3rbI7cfAnG/T3LDqg0wfIu5b+5RvL7c8O4fnOMyyXeAye7E+pZC/Xug2aRMIgOPA9Tx1DQo0KgtKl2PnrbpLteVC/pDcSuJ0N3UuoafIQzUfHwUUCaTUEcsykmZIq+Cw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.06.2026 08:22, Marek Szyprowski wrote:
> On 29.05.2026 17:02, Ard Biesheuvel wrote:
>> From: Ard Biesheuvel <ardb@kernel.org>
>>
>> The linear aliases of the kernel text and rodata are also mapped
>> read-only in the linear map. Given that the contents of these regions
>> are mostly identical to the version in the loadable image, mapping them
>> read-only and leaving their contents visible is a reasonable hardening
>> measure.
>>
>> Data and bss, however, are now also mapped read-only but the contents of
>> these regions are more likely to contain data that we'd rather not leak.
>> So let's unmap these entirely in the linear map when the kernel is
>> running normally.
>>
>> When going into hibernation or waking up from it, these regions need to
>> be mapped, so map the region initially, and toggle the valid bit so
>> map/unmap the region as needed.
>>
>> Doing so is required because pages covering the kernel image are marked
>> as PageReserved, and therefore disregarded for snapshotting by the
>> hibernate logic unless they are mapped.
>>
>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> This commit landed in yesterday's linux-next as commit 63e0b6a5b693
> ("arm64: mm: Unmap kernel data/bss entirely from the linear map").
> In my tests I found that it breaks booting of RaspberryPi3 and
> RaspberryPi4 boards with the following kernel panic:
One more comment - reverting 63e0b6a5b693 and 53205d56212c (dependent
change) on top of next-20260608 fixes this issue.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


