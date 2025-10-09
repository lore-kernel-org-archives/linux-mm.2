Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A6B4CCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 12:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EEEE8E0093; Thu,  9 Oct 2025 08:59:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59EEA8E0002; Thu,  9 Oct 2025 08:59:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48E2B8E0093; Thu,  9 Oct 2025 08:59:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3750C8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 08:59:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DA59E13BEF1
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 12:59:47 +0000 (UTC)
X-FDA: 83978582814.08.B9E9A65
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf23.hostedemail.com (Postfix) with ESMTP id BE0D814000D
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 12:59:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=X2hT8cny;
	spf=pass (imf23.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760014786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3nmdPEBMpnlMRC3jTqPQ13Bh9/rsLEkTB0f8spndDN4=;
	b=MHRSAAd6/gcL4Nix1gDJGVX/ZjKGaFyYCFkn+RCrPkJ1jc44fOsUIdNeMw9si8RJTLyfs8
	+N8WxfEU9FYfA+zIyk0bR/osKzdcC6Ts/ABkdjugZ3U32czqbPquUoLGbeQs84WoU5E41/
	i0Vhbw1Hvs6ievinwbyrupUoAjdmQRM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=X2hT8cny;
	spf=pass (imf23.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760014786; a=rsa-sha256;
	cv=none;
	b=Ym665PvoOgwMDDHGwhUI4qQG9Ud9XO5vuWwYK2q8p59IAi35kZ6Vqxi/kaEvlGir6kYFiW
	8lHgnd5Orz3UPZ4gBCrE8piKifSRUOlPCCJ0IjBrbCxfEP+IAlRwh24UOM+d5PxuGavxce
	Ckh+1BMxFG4cd9BzNZKvTtOsZDqvVfo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3nmdPEBMpnlMRC3jTqPQ13Bh9/rsLEkTB0f8spndDN4=;
	b=X2hT8cnyKta4IwPwwuurm1oCq3sApJSZWuoiELhh29MSmC6YSU5I6mgBYCVBUqZSQpEQ6kplk
	UEldQqV3rsvxJrXn6NK3gDGywYIa27vH0RmlquJajeFGKU/tAmBx/Sjt4Ddr+PxRaHtrOelMP+o
	7fddfCPGYNYVTEX8NiLpgfI=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4cj8c14qYJzRhrC;
	Thu,  9 Oct 2025 20:40:33 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 81248180485;
	Thu,  9 Oct 2025 20:40:50 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 9 Oct 2025 20:40:49 +0800
Message-ID: <af6aedde-a4fc-453e-a393-3526a1399522@huawei.com>
Date: Thu, 9 Oct 2025 20:40:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH v2 4/8] mm: page_alloc: add split_non_compound_page()
To: David Hildenbrand <david@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, Matthew Wilcox
	<willy@infradead.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, <linux-mm@kvack.org>
References: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
 <20250918132000.1951232-5-wangkefeng.wang@huawei.com>
 <d075fb47-5f87-44e1-8d04-b3311c7b7bc6@redhat.com>
Content-Language: en-US
In-Reply-To: <d075fb47-5f87-44e1-8d04-b3311c7b7bc6@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BE0D814000D
X-Stat-Signature: 1118saam54hyiukazm67bx6cqjrwae5k
X-Rspam-User: 
X-HE-Tag: 1760014784-107206
X-HE-Meta: U2FsdGVkX1/4wN8XMoX0wZHyi/HPZi0Gmf0angcTYX3JI//BJR4xd/Z8V/0dh7zsoa2B+jFcDm080f6csNqqCmzFGm+zUNmfflQZWCqW0kq33GEzI7soiH42Mh8hMAlq9a4Zxp04izzyUROyspjzAVR03fZDA8DCNer9UzML3NxpeX+6BD8VNEGw3SlfsglHh2bP9ylWCBDG+DcYwI6MD84+JzjqruyLFwooKDvj/W9ZK/7AyMWlKY+WVOkxLR/xaYiWdY/hIOE1QiZlBWwbW7sYXiFhHnAf0eBAJR2Ev4yjiAJuqwDexiYv4WNMRaDRD6hIE0ZIfzaCb6Q/fRx3mW/QS3OJZUkAa2trp8qOCJ4T/L+QMC+ZOGhdK+iFbyub9NrhNCf6UsKUas+aTfACDvpZYhVdw5rk2wPu7d0Mc78GXG3ysbjtn/Xma6/kZx8CzqDMjbEIbC5IXNLVp/dOqstZekpk1E0e1N3uENBvS032sWLfgfpePAMTIrHbTjqskNKY2f0n0zzDGU29aUpnvBNzqkF069Y16Ei+UVUGaaAzlIqn5nrvR74ILK3pn2Nfs5+knWcbEaQ7dPkZvRhjoZve4wwOZm48a2Ne/eXQNgY4nY6T5nJZB9c1tSi+4+iNB71zQh353VBitCID6Z6LDp9soUtMw3hdl3svtV0iEP6E9ZAMMx7CM8PfJxtv5YxrKiDYXRcbytityncQBFYQk71tL0BRozRQ4wUvnoan9zSC4lmzw7BZIXTymJbt4AgfqT+gWvDyrem461aH5b3qa55sWunUQfegTwlZOvUkFX9JFTwFAARWS3w3v+/9vNHBOPoav8qIQTzP9m1gq72lri7khM1KDWB84ZwV7ybRAdwBds5tbNdVmLADVI1K5QQW23RCTwewjQEcrdoaDjHfR3cC3BMfVycRwybfQlpVJYjJirzGJ0SHLeQifu80bu6fNiL1jtCYA7su2FvmVy3
 q1bijqI0
 EZvVDpqEBuQZLUghFvBLXIvbFducDI69t4HCtONqBD2/bVxA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/30 18:06, David Hildenbrand wrote:
> On 18.09.25 15:19, Kefeng Wang wrote:
>> Add new split_non_compound_page() to simplify make_alloc_exact().
>>
> 
> "Factor out the splitting of non-compound page from make_alloc_exact() 
> and split_page() into a new helper function split_non_compound_page()".
> 

Thanks, will update the changelog.

> Not sure I enjoy the name "split_non_compound_page()", but it matches 
> the existing theme of split_page(): we're not really splitting any 
> pages, we're just adjusting tracking metadata for pages part of the 
> original-higher-order-page so it can be freed separately later.
> 
> But now I think of it, the terminology is bad if you look at the 
> description of split_page(): "split_page takes a non-compound higher- 
> order page, and splits it into n (1<<order) sub-pages: page[0..n]". It's 
> unclear how split_non_compound_page() would really differ.
> 
> I would suggest you call the new helper simply "__split_page" ?
> 
> 

OK, the naming always beats me, will change it.


