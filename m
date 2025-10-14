Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65409CCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 03:49:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99E8A8E0099; Mon, 13 Oct 2025 23:49:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94E8F8E0007; Mon, 13 Oct 2025 23:49:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 865148E0099; Mon, 13 Oct 2025 23:49:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 739A68E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 23:49:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C302C0710
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 03:49:15 +0000 (UTC)
X-FDA: 83995339470.14.FFBEB58
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf03.hostedemail.com (Postfix) with ESMTP id 934942000E
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 03:49:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SrmQl1Jc;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf03.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760413753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WVB1k0iyALQBn8mrDij0TlFOM8IGUTNYDz3MNRZQY6A=;
	b=3KO6XDVMpnVSHOqBwkgqYin43fIsBkHTuhMBs3R7vJACgRk9W/+QWXCmfsDGCnC2CqN63m
	RFrNe/373OUapz4PdP/osDjkSmqF/PfrfxtPbrnli6sM6qSetxEiYtn0NMghDbJY89RjPV
	au1cbKN9qPgzbPj9jOLvk0yzRNj1X7A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760413753; a=rsa-sha256;
	cv=none;
	b=XFBYItc1mBBVuiKfh1IMDkXyMl0mvcMgct+1EFJCcFoRM1skgE/eO7+p8q4TNxj2RpppFQ
	WFRb4rjg4VqTKqd2g3woIZO6RnHU+Oru7gmhykLGsklElKp0k+olASXkXhET4beT0x6suK
	NmkwATCJlmSOJO7CFwPsIXh0riz6xIQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SrmQl1Jc;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf03.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760413747; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=WVB1k0iyALQBn8mrDij0TlFOM8IGUTNYDz3MNRZQY6A=;
	b=SrmQl1JcRSh4zT0oJWaJ+lWV0A1sxSV8gIRRhcxl9lhg05ydutuO2Ops7Xzk7rYMjcEYQzpxVH5VNRbWREz3SGmL0E10t8CD3NJITqY5VHVWK5NVDW4KuUhHaFP2eRGBGggIr97sHN9fPCd/ZilKfNVmPTpn3cvrdTjvgH+S/iw=
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WqAD6FT_1760413744 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 14 Oct 2025 11:49:04 +0800
Message-ID: <51b210a5-3967-45d1-a081-465b2c5f0fd1@linux.alibaba.com>
Date: Tue, 14 Oct 2025 11:49:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] mm/huge_memory: add pmd folio to ds_queue in
 do_huge_zero_wp_pmd()
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 wangkefeng.wang@huawei.com
Cc: linux-mm@kvack.org, stable@vger.kernel.org
References: <20251002013825.20448-1-richard.weiyang@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20251002013825.20448-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 934942000E
X-Rspamd-Server: rspam02
X-Stat-Signature: mxuwe9zi5n9udyrr3xy7bd5pg1ndejj5
X-HE-Tag: 1760413751-45385
X-HE-Meta: U2FsdGVkX18FfN+oThB9brLT4X0aUL7BfobRiYNO7lRcScla1qNkdDVMx3ysA9PCN23gDMbKccIIT0tg+ICLxNjWOid9u15/Qm+3IpBE+11RVPW2jxdSFxk07CtGylBzHI18jeqTD/JQUEi56ddPIKmAp+zpyDP0KcmG0YDO/k+i6d+qoTT7wVjZx9l7D0syxe5AX4j6r9XvlkNqOVuxp50rTwu5j1yaVyt1TdTbTNppM012f07lNc6lYaSvyKC0KnV1O6gEIvTcHC5ZoUjMaQ7KjQlxoH8W+4UbSlt5SLkxZpVTO5Zc7U2aDCA5cv2dGAfdR0YG4kgOv6xWUGOxVZDYDbaK2bq1HNe2W8LTHXhnYuHHF5AeKNoiOe8HRJzj2bKDCBPm89f2driHyGqNwu21n7TxWYc9m0JAh1WfsB4oLAKAljygKyM4SMJOHWKKNUIsIY7q0HARf+laXFimVfMVKkEoTIrFDrGqcPTbI276cH383UjRuQdFbD+XT+dF5NYupQZz1sCNDnWlCxzO7RbmwEq/Ck7jarL69GsMC1pELEb8Z4BPmzrjLp3y6F8/GXCg5KaIMwaRckWHf7DAfZaRs0q7zUJLw1+uXXbAs3AXHiDbRdmiH5B0OHH1QuEXv0wnqAcpDRF2NILSiOnOK1N8Jjw/4iWR898IZDcoX+Qc1xTMkQwjitfpIb6D1laUY31pgG/saVbeledsZEzHaocTNRPieQDeDRKEVUF3b1nEv8M54J3vLCMFGQJtNfJQdHDD4P/lLLqNEJBEHFY3D5ghBvV1UjM5pZmUuPLUXwBo9pyVsz+Xz/5C7hix74gpxlt7lu70W/ewPjDgDCKNdGFeLque5+ivWVDw1vHcnUliNAFQAxfE9o8IxmzCYzEiT7+/tTlFu3sYn1Pae6glDbpFnf+i44isLahUZfx+rT+3tt2RqonKrSnl6fjlSKob2GfE3a/XE8HeX+3Ti8w
 sKFv2Aoj
 srTr9B1M8a+jIMyE17UJk0oByFpjYClRKWLUbB+0OztA12adK3BOH56cPWQnpzL/omLQV+kvRbfpiLUtOp9N+xeHs3d+vBNcWLnkzZspWtHj+e4WCQqsjHvzdBL90ctz8zLPhU4DLAVzy7/4tvEL4GOflWF6lxhZcv65cXqTXHnaHrFoGMYp6iGPqGuyrklZ4r2gCXklZTt5nRXLHyFnYeCCO9GV85JMNXLxyOA2U+ESbaOFWxOki8dwUxkc4YiVKtVd/zhmOpX9h/2aLeCK20XXWhERcIpes5u/iujwzqlRQJ6uU2VTxStqTuTbbakeohK2vA42ISFhylLogI4j1TwZrmaxPYrC2EgsddnKifuQ0Or9ZZjLX2ofrzb06r+jh0ZtPVrXlNPDHT+5mn3zNwg/GHVtAuIUCpk8AhEC/ZOgWaS3z5Mp0uHZCe/5gpMamyZ2XZovlmBNRosY2SqIsc5t3XltM0QYy6bv/2XRBWYHJ8Mvo7Q+jKCbAqPA7bckgJpLsmBGurJGrL2yXCGMGYj0cMNQE2/G8T9NjqnM56T+KFyA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/2 09:38, Wei Yang wrote:
> We add pmd folio into ds_queue on the first page fault in
> __do_huge_pmd_anonymous_page(), so that we can split it in case of
> memory pressure. This should be the same for a pmd folio during wp
> page fault.
> 
> Commit 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault") miss
> to add it to ds_queue, which means system may not reclaim enough memory
> in case of memory pressure even the pmd folio is under used.
> 
> Move deferred_split_folio() into map_anon_folio_pmd() to make the pmd
> folio installation consistent.
> 
> Fixes: 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault")
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: <stable@vger.kernel.org>
> 
> ---

Nice catch. LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

