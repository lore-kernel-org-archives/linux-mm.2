Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04D7AEA795C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 03:26:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CAA66B0092; Wed,  4 Feb 2026 22:26:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A1146B0093; Wed,  4 Feb 2026 22:26:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A93C6B0096; Wed,  4 Feb 2026 22:26:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4AC456B0092
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 22:26:02 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B5ACD1B1F8A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 03:26:01 +0000 (UTC)
X-FDA: 84408964122.06.A52A785
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4CB194000A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 03:25:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=VF9lGFv5;
	spf=pass (imf07.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770261960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y65p+o5Rps4onC3/jarY3MtWPIWXJrlYtcNOlL4XV0c=;
	b=zjgbLj0zLCpUxPNON60HvehRwNOez6/WM//BX3GH0f1z+IBBNhGxXLq69OKYFD0/FEYSrP
	w4C2TFwx6Qda8mI8/nw7u5eIOgEtNlrw42cnTNr1spLXZKEtgtZQ2i5CIW5s6Sy4gyWeaM
	ZdCdb1QJwG1afh2f3/R2QAV/6OEBKzw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=VF9lGFv5;
	spf=pass (imf07.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770261960; a=rsa-sha256;
	cv=none;
	b=uBgv3I2Q5ow64NBvABsI/EwBp7fbIDLMUw6wwTkuO0AmU7i3PrCRrhL8YdESihq3wComv/
	mAHranE/pS4nJdQ+WPJOgkDb/y37X/o0fItMgkcqbtk90BrnWh2K1oZ1cMfXDykVKbw0vJ
	ePVftCc9Kl3qm/it7aI59Dw3/cNkjA0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Y65p+o5Rps4onC3/jarY3MtWPIWXJrlYtcNOlL4XV0c=;
	b=VF9lGFv5ezS5ST2Z8jHuz7giPo0shjEeRQuFmjCbcALHkfFyUeF39at30GyriLm/q1Ku6fD9E
	uWsKwzbWZhbzZTfIjd+PKkr15lKVzQ4BK0LTeNCCJviHFBSW3Eqjb2iSG8OsN23F5zQLMvadvS8
	2wOqXVeY06X7HyNDBJYm2gA=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4f62Yr6JbNz1cyV5;
	Thu,  5 Feb 2026 11:21:20 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 34BC540567;
	Thu,  5 Feb 2026 11:25:55 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 5 Feb 2026 11:25:54 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 5 Feb 2026 11:25:53 +0800
Subject: Re: [PATCH] mm/memory_failure: reject unsupported non-folio compound
 page
To: Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, Harry Yoo <harry.yoo@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Yu Zhao <yuzhao@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, Wei Yang
	<richard.weiyang@gmail.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, =?UTF-8?B?5piv5Y+C5beu?= <shicenci@gmail.com>
References: <20260205005603.274383-1-ziy@nvidia.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <95bd5396-256c-58c6-62ab-ae95e0cf371c@huawei.com>
Date: Thu, 5 Feb 2026 11:25:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260205005603.274383-1-ziy@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4CB194000A
X-Stat-Signature: acns6g3c3ysdy9spig1n9ebbey76kyha
X-Rspam-User: 
X-HE-Tag: 1770261958-64751
X-HE-Meta: U2FsdGVkX1/87dL+bOJLnNQ+UHBQ4nN947vKjvbBCB4Iv3J3JNLsMbuYbUtk1+2GpacKNrWYiT8yGJG8nvFaJ0+F8AIDV269j/BtFR1xTPfDz3gGlkkMSgi7UMAL3GsS7SbwukQ9Xrd3n0lCA5ii8FG1noOkFaglTmtp9tmeeKnHBNueV19+Jmc1ZEkrGaiMWmKdSCfALyWr3pCBCPyNqxdDzb2yXNgYODR8k65bzmIt1zqCC+EnSMAw6He+Jrb/YPV4R7QMpc2nQeQy/3uzoWj2/M0wurFr6MCeEBXWcVLPMi8M41GXrzBNGozzLM90kTmwDaTVNidF+eVmVw0cvawzozP5bU22uDGW1cV46luGWAP1rbQTj43WfQWkZlxk/v/7PMH81x2OH5Q+LW3HLn90a+Tz+9PG3U8pmtGlFJZVtKXUHAQGt2FAMXeFPcWllzAw9nlFIbJX+vzBC+vqYCQhlIr9gxOp3a0jdG+RxdJLnEY7s1TCZOrH9CXKd5LQkqx4xdOxOSrUHRH2+CVKulzqkB5jZ9uTPTAzvoP7jgRwg6y01Q6sI2IqMBH/MreCiAq/vPjWZ6jGmo8zrWdYFWUFLVv+GFB0pj7ilvCEigwC6GqXWDYMF6s7+3ms6hqxSwSPwAQkS5S5OM8u/+SfuWfNk0B+0R1mw42LoPheECu5ZCl0UlEP0KKnc8djEa5H4fkZKasB/lggbNeCVDwnm5PWkEpX6jkP5tItZM1pshqWljnAhHUasmcAnRHL4F9mu6PXi9P6bGXpQLTuLh1G3UfKwm1Aza4cLbBp0KKZDTUgGAhCRyNxtF8oykNM9f+WYNA+hSHVaN4WRJ5tPwweS0/2p0v4UpdU/onyb+3u0+honDiKhkSQiudR1wqA9T/YwlymgY69Me5PpE8mN5wEYEP0bJSbPVJc/8ISsdNqc+YkPII1pCrdZF8YhrHd+DZvR8zpfrijnFezEb8RNjR
 zVNWPBcY
 onnrW0+qwsZWesf3U6y+ev9JkcXfLjDhKfzKCd1OdcutddMxPlomCPN6T+3DpWLyEXXQ24R1T2z/BR28=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/2/5 8:56, Zi Yan wrote:
> When !CONFIG_TRANSPARENT_HUGEPAGE, a non-folio compound page can appear in
> a userspace mapping via either vm_insert_*() functions or
> vm_operatios_struct->fault(). They are not folios, thus should not be
> considered for folio operations like split. Change memory_failure() and
> soft_offline_page() to reject these non-folio compound pages as
> EOPNOTSUPP.
> 
> Add PageNonFolioCompound() helper function. This function is functionally
> equivalent to folio_test_large() && !folio_test_large_rmappable(), but it
> is supposed to be used on struct page. So open code it instead.
> 
> Fixes: 689b8986776c ("mm/memory-failure: improve large block size folio handling")
> Reported-by: 是参差 <shicenci@gmail.com>
> Closes: https://lore.kernel.org/all/PS1PPF7E1D7501F1E4F4441E7ECD056DEADAB98A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com/
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  include/linux/page-flags.h | 16 ++++++++++++++++
>  mm/memory-failure.c        |  9 ++++++---
>  2 files changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index f7a0e4af0c73..2fe8047f42a3 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -1102,6 +1102,22 @@ static inline bool folio_contain_hwpoisoned_page(struct folio *folio)
>  
>  bool is_free_buddy_page(const struct page *page);
>  
> +static inline bool PageNonFolioCompound(const struct page *page)
> +{
> +	if (PageCompound(page)) {
> +		const struct page *head = compound_head(page);
> +
> +		/*
> +		 * Without CONFIG_TRANSPARENT_HUGEPAGE, PG_large_rmappable
> +		 * should not be set/used.
> +		 */
> +		return !IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) ||
> +		       !test_bit(PG_large_rmappable, &head[1].flags.f);
> +	}
> +
> +	return false;
> +}
> +
>  #ifdef CONFIG_MIGRATION
>  /*
>   * This page is migratable through movable_ops (for selected typed pages
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index cf0d526e6d41..8b6b5950bb66 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2440,9 +2440,12 @@ int memory_failure(unsigned long pfn, int flags)
>  
>  	folio = page_folio(p);
>  
> -	/* filter pages that are protected from hwpoison test by users */
> +	/*
> +	 * filter pages that are protected from hwpoison test by users or
> +	 * unsupported non folio compound ones
> +	 */
>  	folio_lock(folio);
> -	if (hwpoison_filter(p)) {
> +	if (hwpoison_filter(p) || PageNonFolioCompound(p)) {
>  		ClearPageHWPoison(p);
>  		folio_unlock(folio);
>  		folio_put(folio);
> @@ -2945,7 +2948,7 @@ int soft_offline_page(unsigned long pfn, int flags)
>  	ret = get_hwpoison_page(page, flags | MF_SOFT_OFFLINE);
>  	put_online_mems();
>  
> -	if (hwpoison_filter(page)) {
> +	if (hwpoison_filter(page) || PageNonFolioCompound(page)) {

There should be no problem in soft_offline_page(). HWPoisonHandlable() check will be used
by get_hwpoison_page() to reject PageNonFolioCompound folios. Or am I miss something?

Thanks.
.


