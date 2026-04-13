Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BEE8F34C42
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 11:48:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E81C76B0089; Mon, 13 Apr 2026 07:48:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E593D6B008A; Mon, 13 Apr 2026 07:48:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D969E6B0092; Mon, 13 Apr 2026 07:48:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CB1D56B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:48:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5ABF4137FA7
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:48:45 +0000 (UTC)
X-FDA: 84653360610.12.4FBD911
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9A48D100007
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:48:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=yYd4zdpn;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776080923; a=rsa-sha256;
	cv=none;
	b=w6+TjDzSFCOd87RdkeGv/tcTk3inVVOpEYusrg2MJH1i+qRR7aTXwUlcxmltyH7BqhCJd4
	KYOw7kWli/J2FO1/uyyT1xrk+Vgfd38gfbPzZhJe6V1LhMD2H/clVyoGlYUHA34+oqHu/a
	8a2RsiEmp02LayhxcyJMx/ccHobUmiM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=yYd4zdpn;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776080923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5bIyFtZevOlWJJtQOYjmineyJGabrQz1O42l7hIuFeE=;
	b=KO/W6k7uO4hXOHJPP3kCkaBg8TpCYEyP+Q+EFOdNkEjaYcSiCm7s/xDWJzb7YhIzSRWqn4
	GIb+7zbaaCdUHRbdK5V9V9zcYeLQYbeHKGiL22E90TT5Lbvi03nilu6YZPbRbWlxPRveAP
	dilFodOpj8+4K+Nz4jOsw16U4P4nV2Y=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=5bIyFtZevOlWJJtQOYjmineyJGabrQz1O42l7hIuFeE=;
	b=yYd4zdpnu7pyUMZhMTOR3q9BYpmDqiI1jW6R3cMAOPr75xQxxN0yXtI1mf/S6uXhpEFkEnDjd
	Nei5m8aQGEjGSYJYPdSu7Bhu8hDfVbTvPZLEVsdC2uF15mtEy1v3ss6FUrQhL5I5ZodNzfzTIDf
	7qivL0kLem8Lltx7ZMCqTjQ=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4fvQWJ4D2Mz1T4Gh;
	Mon, 13 Apr 2026 19:42:36 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 8ECA240576;
	Mon, 13 Apr 2026 19:48:34 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 13 Apr 2026 19:48:34 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 13 Apr 2026 19:48:33 +0800
Subject: Re: [PATCH RFC v3 0/7] mm: Fix MF_DELAYED handling on memory failure
To: Lisa Wang <wyihan@google.com>
CC: <rientjes@google.com>, <seanjc@google.com>, <ackerleytng@google.com>,
	<vannapurve@google.com>, <michael.roth@amd.com>, <jiaqiyan@google.com>,
	<tabba@google.com>, <dave.hansen@linux.intel.com>, Hugh Dickins
	<hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, "David
 Hildenbrand" <david@kernel.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini
	<pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>
References: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-0-718f45eb7c75@google.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <c308144f-e240-153c-d6d4-bf4ef4db0457@huawei.com>
Date: Mon, 13 Apr 2026 19:48:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-0-718f45eb7c75@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: 9A48D100007
X-Stat-Signature: 97k568hyopmswsuy5qux5c1qjkcn49ty
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776080921-886884
X-HE-Meta: U2FsdGVkX1+KdpP1gDulkCGEism6haZOlDjRfhsBB/8QcDxer/SN1FWbFMtlV9JQTiuKVeTGsWuSYtPF5TXExaaMftlHUjkOA93ocvgw1TtwR5bPpY9EHC9PFfsXhfMX8OZheJ4bjGovY+43dS5/7NPyt0rWtugSAxPQJYlq/XK+etd34on1LPShV4fGt/SjeGDpMVXMrdS/YeDuXf7i/nx6sgvhVqQO6vH9nzYXTU75RrqLp3hbkgYHKBOSUCU7u0xXije1ITYVpa/gpyJUzdaW2Hw+K7SXAZgAIMf/Ba2uX5Q0qWsp9fKhYToyu6NRq3Ib1xQA15l++wWvKsbVlmg6o8PA0hBwIjsUtbMI/70Do9jmChDjh2v6r/y30v7hMGCILg/Z/Mw82kQX1K9ccFnsrUnOYNkNKWFbW8+Nw/t4j7ZJ4A0nj5XorxYVSl1yY7emhcdJg/FP4YC2PHzSnBslp4ElEIb/7RDYJnBpS/pLptz3pfT5HN2AI9za00m6LI1biTPE5IQYSTBMTgFFk2/D0PnjztXIttUXaZJ8dzcf/K2LeXbmSPLU8FK77WWw4Hd1XLREBdUilm/vcefhi5busQ0t0hGGged2UBKFaAwhl0YL4TqFhOFQRffCoQ3NW0FA5nci1b58Di09X8uY2Yc/pXeOitw4PoQ3bQFNUdg5fYSw3YtXbCjUNBOJTmk8Jb7HorKySoU0a8FPC92PSG0VW+UEpNWo/FqccFoYKolBb1dAJihIeqFS6QmJ00Bsb1u4Jw2N00BD1ec2y7kFh8MMIyVFP4cqb/myHmpA02/QFDzQIakdMj3ZvkDSdzGGEfe69U7zE0AHucqSTzGuDRVDImERECVKCAs80j4whvaDUS3YabZmzuRIXIGylGP3BwsuxSDmN438CTIjimYZW94yUF+i4oBeTbYbQR+tGPtFU85hZFeDQopq2dGCpU9ytwDY40hGyUy8CSwO4wL
 qXsO1wSh
 36Iimt1V9RKB6wDZm05I3XepTMbrJrqGKA6FbFIjynD9sxJqdyQcjWgKLCCOvS0OE66dRPbFgwDPLaQqjRleFYa3MDWKyWZIzkAzut+woNXUlMoKVAeUl+PgKgRVrDYBMO/MOvgZsTmAn1Q0uatpB46JHaIT1lPNI+8n+jImaZ3idncob//LiiE9lpe9lG1v5vMsTQ/Tg9395ljz7/XeOusnwkvsiLTxzerKvcQA0sCW5foM2ura+dquI6I6cgeTiMXhBS/+1gcHPsSMpnCefHH43rU4aCISNtdXmXGEAWOnTKtsWGSoQ5AYr+vaZAJEoZoffFiSgRPAkACUVlB4HBHU/dPCySJAFb4EDcTuDetlsV/6cbjxcJ/ePQpgunM9BVsdxl5y7nnZ4n6MJmHk5xEjdamHDXyNyUqDr8a0RYZeXFQM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/4/9 1:24, Lisa Wang wrote:
> Here's a third revision to fix MF_DELAYED handling on memory failure.
> 
> This patch series addresses an issue in the memory failure handling path
> where MF_DELAYED is incorrectly treated as an error. This issue was
> discovered while testing memory failure handling for guest_memfd.
> 
> The proposed solution involves -
> 1. Clarifying the definition of MF_DELAYED to mean that memory failure
>    handling is only partially completed, and that the metadata for the
>    memory that failed (as in struct page/folio) is still referenced.
> 2. Updating shmem’s handling to align with the clarified definition.
> 3. Updating how the result of .error_remove_folio() is interpreted.
> 
> Changes from v2:
> + Address the comment about fixing the typos and clarifying the
>   'unmapped' status from Jiaqi
> + Address the comment about merging shmem memory failure selftest into
>   memory failure selftest from Baolin
> + Align the consistent style in truncate_error_folio suggested by Miaohe
> + Fix some bugs found out by Sashiko. e.g. set vcpu register when VM is
>   running.
> Thanks!
> 
> Would like to request reviews from Miaohe and Baolin regarding the
> selftests:
> + Is adding more TEST_F()s suitable?
> + Are you expecting refactoring to reduce code duplication in
>   selftests?

IMHO, when there are more and more memory failure testcases, we will inevitably
have to refactor the code. But for now, it probably isn't necessary yet.

Thanks.
.

