Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF5DCEC144C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 14:17:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EC9A6B00EC; Tue,  3 Mar 2026 09:17:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CE816B014B; Tue,  3 Mar 2026 09:17:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0F836B014C; Tue,  3 Mar 2026 09:17:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E08976B00EC
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:17:37 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 903B1B70D7
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:17:37 +0000 (UTC)
X-FDA: 84504954954.07.F43A2FB
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9270CC001A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:17:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=nAHolJpm;
	spf=pass (imf10.hostedemail.com: domain of p.raghav@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=p.raghav@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772547455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yI63eG0TpyudB4EbuxKXYS2S0olMXbkfWRAVH8sYml4=;
	b=Qm6nEIPnqrjVe3bweZxzgPaqFBlcoUlr221A//YxpQLmKHs4J58P66bmvo3BWN7EQN3ywL
	MydFJlcURwUqfw3yVggQMy9nFZd8s8u/RCO3OjEGtK8+7Qu3DglHN+dmHD0o3A/OTrHO+7
	Iv8n2DUfKUqhaDznWYcX9x9yHgyRpDw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=nAHolJpm;
	spf=pass (imf10.hostedemail.com: domain of p.raghav@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=p.raghav@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772547455; a=rsa-sha256;
	cv=none;
	b=pEO+TlrQZWH5EuO4LBummmBknbzb7u7YREpCtkGZissJ0mm7zVZvOIEto/QzTx1m1rVqr8
	A+IRkIjq9bNgQn5KfyzlW3QWPVpO0sjpesKuaA67OcL81gf4ECC3tcOxU0wZq7F6fF0Lvm
	QRanGrWdfN3i6AmHDY+3GugxsxxjVaU=
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260303141732euoutp01c173abc2cbe880404384266f8517678f~ZWoQu_Nea2706227062euoutp01S
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:17:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260303141732euoutp01c173abc2cbe880404384266f8517678f~ZWoQu_Nea2706227062euoutp01S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1772547452;
	bh=yI63eG0TpyudB4EbuxKXYS2S0olMXbkfWRAVH8sYml4=;
	h=Date:Subject:To:CC:From:In-Reply-To:References:From;
	b=nAHolJpmRCQ4gHFFWFKGXTt1mm4rLcsJZwxxRVqII9a8+aRkttC5F2e0ONfQcPxHw
	 3JVo+Gtcdd248Xf0fW4Swmdfb+xq06oSLF0CjoSYEG/BzpexuQVYcWOeNUqJmrX3w1
	 sIlwE2iFK4XGOA1aW7Y+5ZaIEhTK0qNMGjWb6dwo=
Received: from eucas1p1.samsung.com (unknown [203.254.199.20]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20260303141731eucas1p2e2776e83eaddf31d46a04572d08ecb6d~ZWoQeWN_70751407514eucas1p24;
	Tue,  3 Mar 2026 14:17:31 +0000 (GMT)
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260303141731eucas1p294a43af96c9468f35fc3b88ddda944b8~ZWoQMnWCl0751807518eucas1p20;
	Tue,  3 Mar 2026 14:17:31 +0000 (GMT)
Received: from CAMSPWEXC02.scsc.local (unknown [106.1.227.4]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260303141731eusmtip1a2108785e03078cd80aeba1cd79b3739~ZWoQEqtIM1956719567eusmtip1N;
	Tue,  3 Mar 2026 14:17:31 +0000 (GMT)
Received: from [106.210.248.154] (106.210.248.154) by CAMSPWEXC02.scsc.local
	(106.1.227.4) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.39; Tue, 3 Mar
	2026 14:17:29 +0000
Message-ID: <6e86c417-c410-4deb-9b47-08e3d5d9be71@samsung.com>
Date: Tue, 3 Mar 2026 15:17:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 0/3] Decoupling large folios dependency on THP
To: Matthew Wilcox <willy@infradead.org>
CC: Suren Baghdasaryan <surenb@google.com>, Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Michal Hocko <mhocko@suse.com>, Lance Yang <lance.yang@linux.dev>, "Lorenzo
 Stoakes" <lorenzo.stoakes@oracle.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Nico Pache
	<npache@redhat.com>, Zi Yan <ziy@nvidia.com>, Vlastimil Babka
	<vbabka@suse.cz>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jens Axboe
	<axboe@kernel.dk>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-block@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<mcgrof@kernel.org>, <gost.dev@samsung.com>, <kernel@pankajraghav.com>,
	<tytso@mit.edu>
Content-Language: en-US
From: Pankaj Raghav <p.raghav@samsung.com>
In-Reply-To: <aaEsOu0hgCUznzl3@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [106.210.248.154]
X-ClientProxiedBy: CAMSPWEXC01.scsc.local (106.1.227.3) To
	CAMSPWEXC02.scsc.local (106.1.227.4)
X-CMS-MailID: 20260303141731eucas1p294a43af96c9468f35fc3b88ddda944b8
X-Msg-Generator: CA
X-RootMTR: 20260227053155eucas1p2b4b92cca44cefd084ae528fea27419d3
X-EPHeader: CA
cpgsPolicy: EUCPGSC10-065,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260227053155eucas1p2b4b92cca44cefd084ae528fea27419d3
References: <20251206030858.1418814-1-p.raghav@samsung.com>
	<CGME20260227053155eucas1p2b4b92cca44cefd084ae528fea27419d3@eucas1p2.samsung.com>
	<aaEsOu0hgCUznzl3@casper.infradead.org>
X-Rspamd-Queue-Id: 9270CC001A
X-Rspamd-Server: rspam07
X-Stat-Signature: c5jafzft89imkszsspu1hti3iu45ujaz
X-Rspam-User: 
X-HE-Tag: 1772547454-326222
X-HE-Meta: U2FsdGVkX18vfyOqG++bPA2LLBtjdydqYSYpbtF5Cl2kqNnXKzSd4uOiMo20JzxPh70Fad4nfUCU18gFKNJPim7X2EwkFZuSDJvuxYbm5kI7CkPtKYQ115bYoaSyY5fgfQWxKXxIeOrAbms8rzSuN4ppZKO8YymXUqh5b0WcWIUjGdhh7y32kiJf8d6dzR2sdMYji0hSsVrvt53i1VJQ6b2KJMRC7S8YAf35lSHZoYrV1kyAm20BNdq01vUnmYsPcxhTw0g7Uf6C+gV7zyqKnlvXIrI8MbKThc9KWBx8fQt4HCR84BQUur966Koz27EyJQpYihLAb9nOXG/LqJvo8GwGudsfRnsNRjNAzOeFFPZfM1HUx90t6VDhFcjeOCQTFXsIRgWqdxp3GPltdlOGTLmaOjAA+s4cWUVET3hrjXSqj3ANEDmf8u6oaAW8L9cXmS3f6U6+XE0iYOWYRjF4sQ3hFicvrPqYjIg8OoiI3EHwGzkAjAD8uSJ+pi2/gY4GQPPLDWyvrP76sLWm/ljFBLbN5HwFvv9DrlwW/QN/i/YDpRHd81F76fj61F5Bjeg5xAS9XpO5D7ysl9smozwEWu+5iU/zYOZdNmlZvcIT0eNl8c3nMe2j1hNwqn/c+CElSbEnwZ50SFSo/KcRVNOml0ro3QSFOnAtmWxXiBWzthJ3jWzQ9noCqKN/dHMAbnxpi5i9cx5RCraAV4PD3wxx2TkZSjnHvrvhZdxPOTvi3N8SUg71878u/1wpeKa1Yb/Moj7KbriEe7jS+Yj1SyZeFBglcO/kVXa6QhNwJoBRwf4C7wLnoBe8x5zVHUWG/RkSzxTC6/hrukW5KgNUtQJTCV0c5x1Dg/ejvtVhvjOG7hVLx7wvZXGKYb7hi16api9aNiGNb7YTXCd01Kfv0EvGjiV8LUCst/KwARMRHxnCRI2cGbD/9JnP+/oJMyFULLdUDNguklSbS7fNeb+Xq0r
 V3w1MhSQ
 +U6fIDmP+M2WG90hOB1I5Z5Q9OVc0XrfmYNj6+DsRPtVo7LG8y4QIKS6E91/z8AtQe7wq6z4xh7BsHsZOWOeG0m7BB99QBFnSb6JLl4IHDVwTQ7B00nixEDqUSoUKfyujY+7VYx6UDOCYBySuuL0GOJvZG7fBnRdwOL4kPgNQkiqT0WtcemH9nEFCn55+xoGm0fxBsMuQHSYCzaY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/27/2026 6:31 AM, Matthew Wilcox wrote:
> On Sat, Dec 06, 2025 at 04:08:55AM +0100, Pankaj Raghav wrote:
>> There are multiple solutions to solve this problem and this is one of
>> them with minimal changes. I plan on discussing possible other solutions
>> at the talk.
> 
> Here's an argument.  The one remaining caller of add_to_page_cache_lru()
> is ramfs_nommu_expand_for_mapping().  Attached is a patch which
> eliminates it ... but it doesn't compile because folio_split() is
> undefined on nommu.
> 
> So either we need to reimplement all the good stuff that folio_split()
> does for us, or we need to make folio_split() available on nommu.
> 

I had a question, one conclusion I came to was: folio splitting depends on THP, 
so we either need to implement the split logic without THP dependency or just 
make sure we don't split a large folio at all when we use large folio (what I 
did in this RFC but not a great long term solution).

So even if we implement folio_split without any dependency on THP, do we need to 
re-implement or make folio_split available for nommu? I am also wondering how 
nommu code is related to removing large folios dependency on THP.

--
Pankaj



