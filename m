Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E1E8C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 01:45:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDC546B008C; Mon, 13 Jul 2026 21:45:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8C966B0092; Mon, 13 Jul 2026 21:45:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA7B26B0093; Mon, 13 Jul 2026 21:45:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 908346B008C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:45:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 120B7120210
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:45:14 +0000 (UTC)
X-FDA: 84985689348.24.47A37FA
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf18.hostedemail.com (Postfix) with ESMTP id 51E741C0006
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:45:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=RRpYOdHo;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=xiqi2@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783993512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=++7rftVlakMrFKrEO4lbgQgtkLGmOkhVD/bI4OObalE=;
	b=IVD9MDTvC8nFWordt7SlySxgg0nGkclOD5VdWAVLvd7VrmHeYYfCMeDtYyRPW32LBOlIVU
	2FCcyCUvUgIKwCtBKxgJqgK0h+JUD4VxgmBuyFoReJPtQUw+iZFuVLxqLfp9+3V0ZoCXYc
	XryROc1Hg++dDxnyPgg8dcxKXJt+reo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=RRpYOdHo;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=xiqi2@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783993512;
	b=hFJpL8pFDikDU/eRXU91fyS+FQ1l6FgUx7j9HE1qa6254G7bXoTByU81fue4jQtItAtlPS
	LJ1XNWTFB2iJlZUaFFPxvpJ2JY44CorNZkdDKlw7FYktoFfzY6ExXptb1KU8maNJAOdO1T
	UB9ijM3edCAwYIHS2eXvsXSU7ic6+Pg=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=++7rftVlakMrFKrEO4lbgQgtkLGmOkhVD/bI4OObalE=;
	b=RRpYOdHoz6aig9ixOWmUmHZ6DUP+FRy4yp9nJIvt1oWKQardHIM6lNOfdg4+SQio5nDymzU2T
	g0eQmUzNqJQaSauuPYuMvyl50Fv1V3ReK3mFS0Nw0UBIlRTFUGMMExz1RsZP01r1nA0i4Sf0Rre
	HGmNlL8ajvtOuwDwcP/YmUY=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4gzhhG52WKz12LCc;
	Tue, 14 Jul 2026 09:35:26 +0800 (CST)
Received: from kwepemo200010.china.huawei.com (unknown [7.202.195.178])
	by mail.maildlp.com (Postfix) with ESMTPS id 3A8004057D;
	Tue, 14 Jul 2026 09:45:05 +0800 (CST)
Received: from [10.174.178.56] (10.174.178.56) by
 kwepemo200010.china.huawei.com (7.202.195.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Tue, 14 Jul 2026 09:45:04 +0800
Message-ID: <6a756801-f4a5-44a5-abfd-e9ae57432c56@huawei.com>
Date: Tue, 14 Jul 2026 09:45:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH stable/linux-6.6.y] mm/memory-failure: fix missing
 ->mf_stats count when hugetlb folio already poisoned
To: Naoya Horiguchi <naoya.horiguchi@nec.com>, Andrew Morton
	<akpm@linux-foundation.org>, Sasha Levin <sashal@kernel.org>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Miaohe Lin <linmiaohe@huawei.com>
CC: Jane Chu <jane.chu@oracle.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <sunnanyong@huawei.com>,
	<wangkefeng.wang@huawei.com>, <stable@vger.kernel.org>, <xiqi2@huawei.com>
References: <20260706084118.1284271-1-xiqi2@huawei.com>
Content-Language: en-GB
From: Qi Xi <xiqi2@huawei.com>
In-Reply-To: <20260706084118.1284271-1-xiqi2@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.56]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemo200010.china.huawei.com (7.202.195.178)
X-Rspamd-Queue-Id: 51E741C0006
X-Stat-Signature: wkepmobtmpeqzwstoif576t5mqxj86f4
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783993510-593070
X-HE-Meta: U2FsdGVkX1/SCs3zAqog2ihKjA8DelhRSgle68kUubpUA6PdcUxF6pWms9mLLDeIJclU5mHpvWS3u0JSm9aFdqAmK790aSODXgQ+wkitqO2uwqT458J60xCymCek+xQklbsUNqTKTCygpybTzf+PAMs0co8j0rq5XJaQy9CybiMs2QwcyTDA2DP/XKVPvKuTbYDTqbMlf/JzY4wEZj8yF68ACUI/K40xGDcyzZuhZlr37iRo6Xw9mF5aV5xhIUElNxpBWn59BOtedFirCz1cG4VcPAzLndVx2y57n7wxPJ6EJYWFmc5Dj+9NPa8q8gezARbdKon5yzH/qwHWublIeAJdrfCLtUaLPw3xoF14RnGUW2qXFziEdqySXO4ez3s1cn8deRd6mXvsf31lep62h4Yb3EUN+LFKwEyRB7lsS4VBi15wt/78OK20BWqTcZUE0pvbwx98b+zJm/e4DjGRBRN4TH605Z8E8jTZmztWHPWITAUFLBOhyeA10Wl1qOyXN/35NxmHdsVe2Q10Spwq6ggTdypRdm800N6IML3Xwh8bNydekSYixpkz0D6lWNESLj/Dbi/6hyBTOjr+nlJeNMenfvykHfDrvZTLkGiXKnMGlRRYUgF3JIQDBQzd9kObOCTU80+A7gM4WGQuAi+VtDLoKxWm9q8qkR7ROXvDHFsmkJEAA2KX4F6Y34589QdKJyDWrU/TXXhfVuO6SgL/Jx4mUDF78+oBxDhFXrD2iY/6+6mhzaAK82VTnhqBZiriSiGZ1akSHNYSXBYj7hAWrtORrznAG664LZVx1rjtBPrbEsdNWj4VRaLwcuSG6m4Aye7agzqMgqrCEjvcNHMCv/G2Jp00VihV6UoyXCJlXN+UQuNqSzP5itd5QMAjg9dpqU017F59SsksvBtE5SYYkkEuHapW+v8CoIFxPBqr8WE/oAB/hNer5ADWbbsTsF2gXlKTB3uG6tuaeQaBKZg
 WtCxZkbY
 6/GLnOWH6ppUfJmsjMDHGoztkz0HSqHm5S+jw3FFchY6X0/O0R8WoTsEg0pZqxL7K7s15IwuU7CI+r90u296HCvy0XMXSgsio1rmUL2oeSy9UDrDMKN0qeRNimrl7ba6mbFmQfPCoAjvCx0GoEb4FIiVUiFZSTOPDeHi5+TTIcUVy+y5I0ghCCQF6kDVfePzSFleUQxbse8+BJKCzDGqzRnoD0C+2Mom3zBazA8C4zVaWRzNHWROykLc/LwEQ1ka1HQqcuU6OT4uVPkq/lWQ2G6dQaJaebmmyetfF64bw17rHdsDKBuYLA9zUieRJJYh44Cyg639c9upkQD/HV5RLwEo1Uz5wiqkGX4lp5YMSCM7JJYWLo6O19Qdu1cq+ibtdtAy4eeUFeYEokYc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add stable@ to Cc.

On 06/07/2026 16:41, Qi Xi wrote:
> When a new subpage is poisoned on a hugetlb folio that has already been
> marked hwpoison (MF_HUGETLB_FOLIO_PRE_POISONED), hugetlb_update_hwpoison()
> increments num_poisoned_pages directly, but the per-node ->mf_stats is
> not updated because this path bypasses action_result(). This leaves the
> two accounting counters inconsistent within the hardware memory-failure
> path: a new poison event is counted in num_poisoned_pages but not reflected
> in the per-node mf_stats.
>
> In mainline, commit a148a2040191 ("mm/memory-failure: fix missing
> ->mf_stats count in hugetlb poison") fixed this by removing the direct
> num_poisoned_pages_inc() from the helper and adding action_result() calls
> in try_memory_failure_hugetlb() for the already-poisoned cases. The
> backport to linux-6.6.y as commit 252bb328b36f ("mm/memory-failure: fix
> missing ->mf_stats count in hugetlb poison") applied the refactoring
> (naming, constants, switch-case) but omitted the core counting fix,
> leaving the inconsistency in place.
>
> Fix this by adding a matching update_per_node_mf_stats() call alongside
> the existing num_poisoned_pages_inc() in the same block, so both counters
> stay consistent without restructuring the error path.
>
> Fixes: 252bb328b36f ("mm/memory-failure: fix missing ->mf_stats count in hugetlb poison")
> Signed-off-by: Qi Xi <xiqi2@huawei.com>
> ---
>   mm/memory-failure.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 86cdf36ee3bb..5f9203bf8ec1 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1947,8 +1947,10 @@ static int hugetlb_update_hwpoison(struct folio *folio, struct page *page)
>   		raw_hwp->page = page;
>   		llist_add(&raw_hwp->node, head);
>   		/* the first error event will be counted in action_result(). */
> -		if (ret)
> +		if (ret) {
>   			num_poisoned_pages_inc(page_to_pfn(page));
> +			update_per_node_mf_stats(page_to_pfn(page), MF_FAILED);
> +		}
>   	} else {
>   		/*
>   		 * Failed to save raw error info.  We no longer trace all

