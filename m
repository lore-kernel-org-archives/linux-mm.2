Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77466C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 14:04:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C4716B0817; Mon, 17 Aug 2026 10:04:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59C1E6B0818; Mon, 17 Aug 2026 10:04:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B25D6B0819; Mon, 17 Aug 2026 10:04:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 168E66B0817
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:04:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8FB3B120781
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:04:11 +0000 (UTC)
X-FDA: 85110930702.09.00E6800
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf31.hostedemail.com (Postfix) with ESMTP id E07F32000D
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:04:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Xu7X2QLE;
	spf=pass (imf31.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786975449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EthaWre51vm4c4XQ+XHjPvEXxi4SWd7KGNAMp4EnZNM=;
	b=7ku6Jz1BgFdEJNx2+HLOMgMDI+S7gS9rLPcPwAK9jWkOa9PplfQvqtmYjSPHe9awPCUQTj
	haFvKEDVOW2B3M37nHjILUDGteCix2hSVCyMXDFbxgShrixROQEE98+kNH9YpyV4mdiA/5
	paM4lrIxbQL6KIUwPVi49ehkvRQlLzE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Xu7X2QLE;
	spf=pass (imf31.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786975449;
	b=2vZPYMb1wsFquw6R+f07lLW6iPnXCmZnAVvBqmMn9+noYRYBrjTBRUgN4nhDtC8uHDztZu
	aqn7Rq2zEqTPlaLU1GzadV1mqdDKiTfI1JYRQd8buGtyaIGA/RmLsXLnOl2azf5gNRoq/5
	VOX4EMEsdaBKS/IKU+LZCrxUhTcUum4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:From:Subject:To:
	Content-Type; bh=EthaWre51vm4c4XQ+XHjPvEXxi4SWd7KGNAMp4EnZNM=;
	b=Xu7X2QLE3T6INq1REmKc271AiaD6H2fpUf0fJ8rhTAOLh0pfbyqzx9xhhSrQCM
	byF79jZBuHKCSO4vdPHwvZLehVIWRLF2FgzaHt+BUesJmaUy3M+UAioUpVAUEcJC
	zZSkwexp2dKGTVFjJdegOUFNvCYeKeV0Jh4fuqqUsP2iE=
Received: from [198.18.0.1] (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wBXkO+_FINqYOyyCA--.6431S2;
	Mon, 17 Aug 2026 22:03:44 +0800 (CST)
Message-ID: <f5b79009-caa3-440a-81a8-997445598425@163.com>
Date: Mon, 17 Aug 2026 22:03:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Longlong Xia <xialonglong2025@163.com>
Subject: Re: [PATCH 1/1] mm/hugetlb: keep max_huge_pages when dissolving
 surplus folios
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Jinjiang Tu <tujinjiang@huawei.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Longlong Xia <xialonglong@kylinos.cn>
References: <20260814083027.1419487-1-xialonglong2025@163.com>
 <20260814114059.c9fd2ef48f4f1b71a8b437f3@linux-foundation.org>
In-Reply-To: <20260814114059.c9fd2ef48f4f1b71a8b437f3@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBXkO+_FINqYOyyCA--.6431S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KryrGF47Gw1rZr4rKFy7trb_yoW8CF4UpF
	yDGws8uFW8JFyvyr1xtFyjy3W5Ary3JrW8ta43tw43JF15C3srKryfta4Y9ayvyrn5Ja1I
	9rWqg39rWFn0vaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U6UDAUUUUU=
X-Originating-IP: [240e:46d:1800:11e5:b5a8:b25e:4af7:6167]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC+AGwqWqDFMHZOQAA38
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E07F32000D
X-Stat-Signature: 6mbbd4t31zuohdzy5o7o7c9erazpaosp
X-Rspam-User: 
X-HE-Tag: 1786975447-64342
X-HE-Meta: U2FsdGVkX18BFvCmq79tpaq+ey+L11Yo4rrccRA+UGZqSx63Kpo3gWTx2eUf0X7Fo93MTPjul/DbZPgoQboQTvWaJy0nCZQ7g/nRCHVx0fpHa22aP4R9Eo6yebhRP6ubKPMM8O9HJTVSNTK2QIwma5znSKAG6aLrXxa0i9LNhj7XPehoq7FNgoHC4e0S9i7KXrkDOkU4yx3vFlu7jhaxXDhuydRXvQNbeHmr7zGAaXRm2OgQzyTiAmr4WNxuPAHUTBGXrSCPkGmvV/nB6dvx/WJ5BR/u7hrPjykdAGRV7TQuGIY/8OHYo9t2aEV51FKJcYN+QqLBcWxAa6a+Bryd6Vs2vrViwhcgpZNjz4Jz4dZgSjpwyYDGDWnrZO8Dyjagir5bAZ+LmW7LYKTOyHZgZQyHp7FZQ1QYkbBQmWO6yYdHA+ZE5mroXwdPkSmaD6Z5cUSgjuMhFWszh5pRDp1JCh38OoSAUBojr935Ps8i2oFg4izs5FiXWoYYvB4uuj8UrjYhFeQe/Z3mQVF9WyTZYMQiwBFipAW9VmBA/p1NnNEjRSrmF4wCpsVJoQNpX3oXDWGxV8FiEeEGcJjWDU0s0UadeoEVh9B/VhZWs+nPaM8/IeZfsv40Fx56q7JFEV2cB9+RyGnzj1Ot2grtDLUmQcGA1yy5+QWd7ILFWb3DcBWJO92bsNPqSyJ+K/YFooaspVDefD5zh7J3wpzlEr1veM17es0DriqGw7eoO8DYxV/74EbntsWZnV2liQ1gTDv8iDWqlPgaF0CwcC9BomAxS/tpl+R60CD7uDMTru41608XuXbhZGv4G1r+6QHVhdkcBO3bwNXJxteQrvfoOVj4DtDJG8cqxs3NqqQG8hn2w2BzmDIwcj4YWO/3WyyMRxeVi2f+691MsE+k9G2Dg7pwTcrI0nZK7QFpEBWY3hFCp3S6r4tFxyZFkJr0OH+gYKUNDoN9BKaCJ9evYYAs8VR
 5EWwM57X
 4oOGamfzz5pX4ncDlUx+Jm5JZJmWvszxRV+Kyz2m+VId/K1+IiamFuGxPxgb4tgC0YQnYJAXGQ+zJgiWrkVjIy4sGwuqw+EqJUqnO4kQ4mxdxyo1LvDb2F4IbdIcoujrxFiebVpwmLPswdXFyaYcrHn3EdD/p78a6q3RNQt7mVulPtp0MNOFhlcGlar4Br3vkUAA78NfIOKHI9FP4Wrnyz/bRuSMBxOFxgg+5wdE/CWyt229ESyS9ZHZkDeTIIjYseC6piler5ZSh3A+LcP3V/Ho8NRx2L8jCjlZCPkBTH2G2ur0EL9/ovwElEX2x9eI+Wow5pBs71h4gyat+9ZOOrK+ah40IBHA/0rqKiCBl/20nEjE1aTAQE/t+vj1xW6gqXWN9gDgJcFhoWXzBricRtKJnAyldfKV0KOZpa7WlcMxpj9ypTJQxN52ECj+X4SCPQY15IRQfIy0Pf8NZ7i6fWCl6RVR1q90uZnqCmqtJwxg9fvWRAjPU5TBj8tBzBOPYmGGHlc8zk89vmFw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,


I'd suggest backporting this. cb402bbdabca reached mainline in v6.14
and the -stable branches from v6.14.1 on (6.14.y–7.1.y), so those
carry the max_huge_pages corruption;

The fix is four lines on two accounting spots, low risk.


在 2026/8/15 2:40, Andrew Morton 写道:
> On Fri, 14 Aug 2026 16:30:27 +0800 Longlong Xia<xialonglong2025@163.com> wrote:
>
>> From: Longlong Xia<xialonglong@kylinos.cn>
>>
>> dissolve_free_hugetlb_folio() can remove a free folio as surplus when
>> its node has surplus pages.  In that case remove_hugetlb_folio()
>> decrements both nr_huge_pages and surplus_huge_pages, leaving the
>> persistent pool size unchanged.
>>
>> Updating max_huge_pages as if a persistent folio had been removed can
>> therefore corrupt the persistent pool target and underflow it when
>> max_huge_pages is zero.  Keep max_huge_pages unchanged for surplus
>> folios, including the vmemmap restoration rollback path.
> Thanks.
>
>> Fixes: cb402bbdabca ("mm/hugetlb: fix surplus pages in dissolve_free_huge_page()")
> That's a year old, so I'm assuming there's no urgency here.  I'll
> save the fix for later and shall await maintainer input.  While at it,
> please suggest whether we should backport this.
>
> AI review might have found a couple of bugs in the surrounding code.  If true,
> they look rather nasty.
>
> 	https://sashiko.dev/#/patchset/20260814083027.1419487-1-xialonglong2025@163.com

The AI findings are real but pre-existing:
dissolve_free_hugetlb_folio() doesn't check hstate_is_gigantic_no_runtime(h)
though remove_hugetlb_folio()/update_and_free_hugetlb_folio() silently
bail for such folios, so it frees a still-listed folio and, on vmemmap
restore failure, the add_hugetlb_folio() rollback corrupts the free
list. I will send separately fix patch.


Thanks，
Longlong


