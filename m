Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D372FC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 06:59:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B365E6B00CC; Thu,  3 Sep 2026 02:59:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0DE16B00CE; Thu,  3 Sep 2026 02:59:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4B036B00CF; Thu,  3 Sep 2026 02:59:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 854E26B00CC
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:59:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8B52716042B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:59:00 +0000 (UTC)
X-FDA: 85171548840.10.57028AE
Received: from mta1.migadu.com (out-227.mta1.migadu.com [95.215.58.227])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0B103A0003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:58:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OgzCsGXR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.227 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788418738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+tXkvRu7NxWljtebBqweTA9isI4T0n/CDcQYB7Jt+I=;
	b=slpoBV/n0K+Lf2ENJM2ATQB7S0u3xF4YIvBKou4zd1oprXtxZEQ8pYnoVKCisJDiE7QV3p
	taLtrWJCMUPomUlOaqX76/Ut2JFFadEEGA2qAFwCDV+7l9idHe0PNtIEWQj1ey+Q0PRs+g
	ficy0nRwFnKwrzBEQAIAIpB1twzGOb4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788418738;
	b=fj+GMZAFHv30Opql82g9x6NMFiukuEnF59cMlWkvJbma/gOtV0Tth8TfypZ0BPpV0epCCp
	cgFg9ocRcHr/TgS8nOb6l69WXoyDWdSfTc4RH+PcxO9klSQ6uZUlsXxXrGzizvGCwlG2p6
	LnSuQS90EVAgE5S2xLzd6hoEgO4HMBA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OgzCsGXR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.227 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=o8BUeq3Tc6Gx1WZx0lieJxRX6+dzsYla4Obyg7G5q/g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788418735; v=1; x=1789023535;
 b=OgzCsGXRz2zEtCr+NoWbRIhw6dzGOqVKT6bG7QZIcF/+vjxcIsayyLWFMwWTgWSDh7SGK0DA
 OgNMpmaki0LdnMRTDfSCD7ukum/ZmWASUk+Zkxq2QXLaFd57Rti7udCE3Ug+Lvbpj99B6orNjcn
 T7ZD1T381nEP+z2uRYJ9YpKM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id d042a3bd066a7172;
	Thu, 03 Sep 2026 06:58:55 +0000
X-Mizu-Trace-ID: d042a3bd066a7172
X-Migadu-Flow: FLOW_OUT
Message-ID: <0f9653d1-2467-4e32-ae8c-d5cf7bdf92dd@linux.dev>
Date: Thu, 3 Sep 2026 14:58:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] migrate: Skip hwpoisoned hugetlb folios during migration
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
 Andi Kleen <ak@linux.intel.com>, Muchun Song <muchun.song@linux.dev>,
 Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260701105544.97059-1-kaitao.cheng@linux.dev>
 <20260902193438.232552868db3af5d54ae3fa1@linux-foundation.org>
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <20260902193438.232552868db3af5d54ae3fa1@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0B103A0003
X-Stat-Signature: keygwk4y6b1pez3o4ju6r75cn644ryem
X-Rspam-User: 
X-HE-Tag: 1788418736-630238
X-HE-Meta: U2FsdGVkX1+0CzjnrbUqYfG9VF117aWQoEcYaKLWVYBIvCmIinGfovx1LcKSlTvy4QkGIG1d5JHLsvgM+swJSEJlRITBQp1Pme0InjMtUgIbg+KVyoZxqoRsjLXTJiF9hPzAapmRprIdBNyMRt+BfHMzbQyrs9H//wxhgMEi1twC/g9m1oqLMrODn/XiCyId1v1FzUtJMSKywpOP37ryeqlPaCDCSDYHHbml9AOpYgo43pRGLG2MJBrB58YMcqHX0uA5D0mRACUsYXF0+oByeA13NWD0LoGonBEBJiCNVlv9l/h4Ye4sQ2r/obGXWW/tNUJHkUrHVtLiKnJNYGxM0jUnlZH1oAu+UvHoh4yFyzJD9sspEhlxcahjexju6BAEMkCaKE3bL1NMnyQYsJHVtcDgcx4kMXAshQVnYyfK7xJybvoxCedEzh6hWWHpJDzZmPYh7cL18qitLLmDcDmVZY/8vxnubEr+kTUtKem2hB7E+LRldpBkkdjcqxQgCITp+BsKQ8H/qSQd5+ZABrj79ltD1rXBLFM/Xm+z09YJdlmbw+jWmnKH1B+Nq6cf3CipbziojQ6QxewHW0QlYxrKsH39iDdMDBvlMwmYk2SaM5brK2zv26SATKrV2jivqeT6EarH2isvYxAGR/MzYLm3KnMmN8goF/iP7ZizG6yKPTo6qfGWKKAgMQaC/p7WAWhMKE33Ob+x+R04G11aMZr69bsL+/dvn6pyAq++Op3A79ZV+S9cyMt4oT40fPvAddVvQtOOqEGzFt3xYYToiN+7AvgwSxhMSaAuYIw/1mDxhyeBBC2Gqn3JGJkV4nLKXDJKZS0ap1e1I6qcuGT6FrI057P8Ve1CDf84QuapdG/RdVRugxJIm4feuYbuFy+J7Un5PrWtIpXb01GzdMJy6ohKxxA+fm5Cjceb4OENF+/OW0H7kySqkkI1PIvgv+B5Q1NDSa1PT4rEmpuc0mdnKtU
 AqrJ1ScN
 oOH4rUr5+ndt4/M6ETKqNYmDrH6ZFRvDGzetTMuyyjqOXb90Wmy1x+Zc5S4tE9xu5e6dUtMA1Sq90QrBKYQatdVm8MNZf5X87lnA6Uf8voSxgSsQlWNR+2W0mGIpahk2eTskZwWQilfr2ixcuYu6qa4I50TG6pBcdsnosTgF9+TeHGS8lMXlSkmX/iZ7wbo7WaGgNIzAblDcGW46ed9ra4p1jQM0FYQJDJ9yT4ZjvP9WasTIY1R/KHP+MH933r59DwJINwsFUz/jI9cfCPs3qPRY+P3LgZkXvmF+p8l3r3XdFRyJsSj52wXq3Rpt7BMDfMX2uOOveyL4r9A8vhP8eTUBnHyf9kbPnc+oYYTUBLAmLJpnpMNDnL51SHDALbdmPp53g8W8zOqrVLcbHyUqYoHr4otvsBzn8xA7ULRe6VMPZgsL0rLWHD0nQAkchefBxF2KmUyAQn5yWdlE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/9/3 10:34, Andrew Morton 写道:
> On Wed,  1 Jul 2026 18:55:44 +0800 Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
> 
>> Date: Wed,  1 Jul 2026 18:55:44 +0800
> 
> Well.
> 
>> Hugetlb migration does not check whether the source folio contains
>> hwpoisoned memory before trying to move it.  After the folio is unmapped,
>> the move path can reach hugetlbfs_migrate_folio() and then
>> migrate_huge_page_move_mapping(), which copies the source folio into the
>> new folio.
>>
>> That copy uses folio_mc_copy(), so architectures with recoverable
>> machine-check copy support can fail the copy with -EHWPOISON.  However,
>> there is no reason to attempt the move once the source folio is already
>> known to contain poisoned memory.  Architectures without such copy_mc
>> support also fall back to a normal copy, which can consume the poison.
>>
>> Check folio_contain_hwpoisoned_page() after locking the source hugetlb
>> folio and fail the migration with -EHWPOISON before unmapping or copying
>> it.  This covers both a hwpoisoned hugetlb head folio and large folios
>> that only have the has_hwpoisoned summary flag set.
> 
> As always: please provide a description of the userspace-visible
> runtime effects of the bug.
> 
> Even better if you can present a reproducer.
> 
>> Fixes: 290408d4a250 ("hugetlb: hugepage migration core")
> 
> Oct, 2010.  So I'm assuming this isn't super-urgent.
> 
> otoh, now it's out there and known about, perhaps Bad Guys can find a
> way of triggering this, so the urgency becomes higher.

In the subsequent discussion of the v2 patch, it became clear that the
current fix can only narrow the race window and cannot fully resolve
the issue. I do not currently have a complete solution in mind, so this
issue is blocked for now.

v2: https://lore.kernel.org/all/20260707090136.52904-1-kaitao.cheng@linux.dev/#t

> Anyway, please consider the Sashiko report
> (https://sashiko.dev/#/patchset/20260701105544.97059-1-kaitao.cheng@linux.dev)
> then update the changelog with the above info.  Decide whether we
> should cc:stable (and describe why) then resend?
> 
> Thanks.

-- 
Thanks
Kaitao Cheng


