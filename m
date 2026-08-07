Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D27D3C5AC67
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 01:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91FA26B0088; Thu,  6 Aug 2026 21:49:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D1576B008A; Thu,  6 Aug 2026 21:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C1C56B0092; Thu,  6 Aug 2026 21:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5396E6B0088
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 21:49:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AC180140205
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 01:49:29 +0000 (UTC)
X-FDA: 85072791258.04.B98C5E5
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf27.hostedemail.com (Postfix) with ESMTP id 93E4340006
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 01:49:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=AfRRybfi;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786067368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tKmLlK6uJ3edkxIIYSB/SjE+4uEsk26hCxc4VlHPNFE=;
	b=Ci/MSQ1GAXbBQYiSKgb4dSnThFeKoj8xApDNg0w1xLtJQk13w5HbTp+dX8MYsPMesTWI6x
	Sad4t0LuVymAiFgVZZ9xpd3OYkcuiFHegYg5tjVx3SQQT/+7PZJGF9sNBdG7jUpF7Xm+Rd
	HEr/fFcbv5LBhNwcfzQ0DBmTmHF8uUc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786067368;
	b=nns2o4qzsslG22s7Dby3AMW+2jsPaOHfl+Oumk00F03/ixlGfYxIwGdi/Sj7FhAhfJfGfg
	a88li5/ctgwRgqURyIGfzFPvw1q1pBEIWkTrDupfPSBJj96nIpr2Rk8UQuBHiQskuPN/+S
	YWWKv7SbP99vcBor1iMbpBi4G5uP9q0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=AfRRybfi;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1786067363; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=tKmLlK6uJ3edkxIIYSB/SjE+4uEsk26hCxc4VlHPNFE=;
	b=AfRRybfi7p0p+3zHHOiYuolTQgNbOVX6j+0RR01YZjpTZoEDCvRQ0BgTF1m/iqqlpIcxfboxr4ShNuw86WHCVbAPzUv5go81+cPNkLPKBR++qCvE/Fo6b4YhSvZQMb7hyvwk83od9u9E5bD2u36aQTuv+ELzP34/rNBQiXiKkoE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=19;SR=0;TI=SMTPD_---0X8V9VcH_1786067361;
Received: from 30.246.177.19(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8V9VcH_1786067361 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 07 Aug 2026 09:49:22 +0800
Message-ID: <f008965b-bb6f-49b4-9eed-96ef0be30c30@linux.alibaba.com>
Date: Fri, 7 Aug 2026 09:49:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-failure: fix folio refcount leak and
 min_order_for_split() locking
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Luis Chamberlain <mcgrof@kernel.org>, Li Youhong <liyouhong@kylinos.cn>,
 stable@vger.kernel.org
References: <20260806-try_to_split_thp_page-v1-1-a259e3387e38@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260806-try_to_split_thp_page-v1-1-a259e3387e38@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 93E4340006
X-Stat-Signature: ya9i6et5ndwtkxdtx6gribeaaqsya1cj
X-HE-Tag: 1786067366-30060
X-HE-Meta: U2FsdGVkX1/QoefVioHj/eTxBSoYMnlsvur67RiiWAJ7FU/TxdAnkEZLIBItJvVIbNYa2oR6kAL6MSm+hixMccy+3wxSCd0WgBieKQ14e6zpgrsnTClSrWruIzpg4Xst4eFkPMZOSzfwyiRGwMxnrx/UGr5S2gLCN6skTuG5RW7fp2GLwrePAMkYzAWadz4uwmywK76cT4+ukB8loUORL9y+7a/RI81O3TXxME2c+baeMkCv2VMuhU+fqiwwNuagTRQHu0JUNq+Qx+yazym5wrHna2+03TR+G/UTTP5N8XETxxbpUPcB/cndDdnWvI4j87Ifx3oqI0ki/G6riqvAxqX1mA3GKUXqcL9yMSvmwVRowVvNkiOtwCm+qrfrsLeSjfiKKJ4e1tbC3Ntv+fJpAl37MtsghLNy5NgGgSIoxskD3TmAl69PLlVUsuww803d5UGaHn/rFzdSbcm1yZIE8Ur8q+CY9AUtM9H4Q3hsyL3ow006zXrPobiVXSOOxHVwGx6M7DagLNbsY/8lbCLuF3V6Q7U5PuS3qRh2KIfDVP6jBIcJbGKQ55pVDREZp1L8qtgiTT+AUlUaWIHsjw6dfOEP/FqH727DKVFKAx4pcLIn/VU9YbD7VLARLPSH3FJKSpXmRIccjO+/tW/i7kV1Edn0BW8j0lsffY8ZYL95QTMoJXMQz1bQVeLHiN5R51i9aiGKBmItP3CpuiKqZlhsynvpqAQ7s/IRagXzwCeCom5y049G4v9a63UyuN53rx5xN/Zj3qBSJ1UhoMLPQU7/ROFcu1WJFRF575cBg2UgRpkIgbe7kDyEazP4kQKHoSQk3iTzgpHg1HNUYIo6oWG32w/Nmm2FkZ8VLb+ViDLS2ipUC+TG7RLbsoxjoPzhBOm719ttKhMhmAe5ioRTrm1FycWO/p8qtS+6HVgeZN9gqmYJg9BhErX37gvplhl575VK+fVnQSHLMTZtosrrI01
 hxIF8V/i
 EmTXk1xCVX9Mw7QlJt73RhBuR4IiNyCGqwvlehx052aaLIw7aZGHK15TigwNEnAZWJjvSfYbFgX5RFBHBS+8j9U6iq2gxgCftdhwcu2z+jSRqLkZ96oh8pH5Iao/Gx4ku605h9aSTdzbaQNqZEPQBh/6G+1vFB/jkF8cQmspVhtug93LqMUAVywf2Mx8AUFXo1eUhvZt+5o84XW3m7xHbCvtIeUoN9QlhNtY3kJqGnvKOcPtuIAIuzdTK+CWzitI0iYhPu7S2rFrgXHhke0E+Uo2W3gbEfLPw4wdrN8LRUFd14aQwl/wGwvVquRqZjefxJfWSY9ka9aKByVb+uKzHcuew2nx71wcMDZ4XYs4fGKCBP3a5P+H/2Z+xhSl0u9y1egiAi+Y+/wK9188+I5mIWk7TRkW+dPGiV//TvzRWaefaiWjZ4Oxff2lIfjJG7WJ8tIn43gsHECR39WiErTLwD0gZHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/6/26 7:14 PM, David Hildenbrand (Arm) wrote:
> hwpoison code can end up calling min_order_for_split() without holding
> the folio lock. There isn't really something that would prevent
> concurrent folio split. Consequently folio->mapping can get set to
> NULL after checking for "!folio->mapping", and if the compiler
> reloads folio->mapping, mapping_min_folio_order() would try to
> dereference NULL.
> 
> While very unlikely to happen in practice, let's just enforce that
> min_order_for_split() is called with the folio lock held. We can
> significantly cleanup the calling hwpoison code, and just get rid
> of try_to_split_thp_page() to hold the folio lock for a bit longer.
> 
> Just work on folios now, which further cleans up the code. We just
> have to be careful about doing the page_folio() after splitting, which
> we have to do already either way. Do not change the way we split for
> now, this needs more thought and should be done separately.
> 
> Cleaning this up we fix another issue: in soft_offline_in_use_page(), we
> would currently have leaked a folio reference.
> 
> In folio_split(), document and assert that we need the folio lock.
> Drop the questionable VM_BUG_ON_PAGE(!page_count(p), p) check entirely.
> 
> The folio->mapping problem was identified by Sashiko, and Li Youhong
> reported it by sending a proposal fix.
> 
> This likely does not really warrant CCing stable, but I expect little
> conflicts when doing the backport, so let's just CC stable because of
> the refcount leak.
> 
> Reported-by: Li Youhong <liyouhong@kylinos.cn>
> Closes: https://lore.kernel.org/r/20260804035828.2684059-1-dayou5941@163.com
> Fixes: 689b8986776c ("mm/memory-failure: improve large block size folio handling")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

LGTM. Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

