Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9278FCD8C85
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 07:21:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8A8A6B0005; Tue,  9 Jun 2026 03:21:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B62096B0088; Tue,  9 Jun 2026 03:21:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9F236B008A; Tue,  9 Jun 2026 03:21:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0406B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:21:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1F57C1A0464
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:21:27 +0000 (UTC)
X-FDA: 84859528614.09.6D49D1F
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf25.hostedemail.com (Postfix) with ESMTP id 00464A0006
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:21:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=mhb3fKWO;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780989684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8+Be/msfBZtJukRPzLQLXA2fKfRd2kL8+CeLPELdzpE=;
	b=QahE2wDsf2kyHeSLcWg1DBCR4s5K7u9Z811HIrYHkE9wr2eg85UxG6q+Gp0UtbWdNhfb/M
	Eou97p75dYpmsfglUP9paDUxN3ENXSb4iykbLAQ+bhevNPFjn64N0aveinYcmmx3HvhTWO
	ZmIlBJmGrotE/5uUzOfha0vF58rzT6I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=mhb3fKWO;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780989684;
	b=dM94sM6PWZn5gTbAmJWowF3xBaoJinJSMYpZlutMKz40ethsRuH+7azAC0Hkvna6y+yuhX
	F8RLWy7gGWwGnHCJUgHLyGgdUoNBHGxLczOFIrwguQbS04TvNl1b8FX77/ZIkOSPeAmtU7
	Hk+cnQcDG7b7vnVOdbYR+gS2L7KiKDI=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=8+Be/msfBZtJukRPzLQLXA2fKfRd2kL8+CeLPELdzpE=;
	b=mhb3fKWO/56GBarof3VIzwDq4Ng27oqkB3jO36ZmpJe19CzqDmNrUTVjxaw0EUxSU+AfyI/6K
	SkalN3jk6NvMbMsSYGJTE2jc+jTD1oykmTVPbDyfqxUMTNaUI+CLZSw6IONzRGImI8YgYNqxWX5
	bkP/2K1c/ynwf4MQI8hZc4w=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4gZKrK5clbz12LHT;
	Tue,  9 Jun 2026 15:13:21 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 1E4BE40569;
	Tue,  9 Jun 2026 15:21:14 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 9 Jun 2026 15:21:13 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 9 Jun 2026 15:21:12 +0800
Subject: Re: [PATCH v5 3/4] mm/memory-failure: skip take_page_off_buddy after
 dissolving HWPoison HugeTLB page
To: Jiaqi Yan <jiaqiyan@google.com>
CC: <osalvador@suse.de>, <lorenzo.stoakes@oracle.com>, <jackmanb@google.com>,
	<hannes@cmpxchg.org>, <nao.horiguchi@gmail.com>, <david@kernel.org>,
	<william.roche@oracle.com>, <tony.luck@intel.com>,
	<wangkefeng.wang@huawei.com>, <jane.chu@oracle.com>,
	<akpm@linux-foundation.org>, <muchun.song@linux.dev>, <liam@infradead.org>,
	<rientjes@google.com>, <duenwen@google.com>, <jthoughton@google.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <shuah@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <boudewijn@delta-utec.com>, <ljs@kernel.org>,
	<osalvador@kernel.org>, <ziy@nvidia.com>, <harry.yoo@oracle.com>,
	<willy@infradead.org>
References: <20260531055829.3636554-1-jiaqiyan@google.com>
 <20260531055829.3636554-4-jiaqiyan@google.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <d9621684-6300-457b-d0ad-9bbbdd576b9a@huawei.com>
Date: Tue, 9 Jun 2026 15:21:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260531055829.3636554-4-jiaqiyan@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 00464A0006
X-Stat-Signature: a1ytdehm8473cmeyfbu8x1qmiubj5xdc
X-HE-Tag: 1780989682-355153
X-HE-Meta: U2FsdGVkX1/NZE2ZbjiLrQvi+lCfJJw20QkCTouFKUSLvZQSIau5cKEfaO8zYHDvPuFeHLU5z76vtp96xMYK02xa7GdbT4JNqAg+XoNqVtf9hfJFY4tDZNQ5p0QObaseDEdcOIxzpIH/IqPWpwe5b172XD1PhtwOaOwUHxlG6MH6eryw4N26ObMHG3YKfEWlLzzItxbJb/PcSuJ+nLK4fcFo5v486LYdfFaLIWUTb1GgOZlmXCUVTg9z1cyra+uHU1gnJSACt+AAZxJKkDRBq0qnRLQGrByLNVJalJ1c0WTHAcUxc98BN1hG+eZL/06ER2mTkSolSRAmDRuEpkHCQhr4tMltckCjTN07wS2Rf5/41HDyAjBKpYEpU99ujUdXAfI71TY3hqa0urpGD8rQt8Ugenq3x0Viw+xifym5aZYhXdBfxIuubm6oAh3C40toQW7fSU4WAUCklhzYWgQt1eRchPGl2RhQGRJQqie1kw+0sRMz016rS8Dn1h421qx+i2DnwNGC+Rb5JmW9ZCIhSkeuJu7QkoQwianN7UWeaGdRfOEUQY+T60OqdZcXKEXmovK6b9BJdwBvX1B4PDyGZg+W0wcTf+vAlST7T+RFBDi/FfyGTSL3aiOzgaqttMc3CVYtGxnmZQn+5UkHUEkh8u6y81JlNGkJuH3/7ZkvgxZR/JwkG0V6DBZnAG6sWaPB6C5/4cEPD9XPqeV5GzW+v3Y4n0dDOYzqQUNkVCARP/RdjMtN9KnJnBVbYQRw7DFGk0gPMRQYH7qUjsZKA6rcYGEUBEzQI7VvNBDlPmthbwN2IdrdTlpw6SxKAUmzINUJZF9QTuFWC22n4NIXG20Kr8mUIXixq4LSDtMQmg7aAaFD/lL60MAJ93zvG1O/aikwFZNsRNM2pOG5iOYwMDnHXcdLEY3F9sONWHCV9Wei6G0zehsDST5XogOS3CUSshlfQ232hGkYEt5ZKm/jpgC
 EX1PAOJ0
 Boxf4n9nQldWNn+FcIEYa8UJDkmMinnQl1QUL0SNHdrpmqi/eq3uKHkhqeAJ93KpZSHYLqLvFoJPkJe1EtC4tOKtcywAqhl42EPwkAoUD8U9pzTqcLjOIrql4ZB8CTgXhWm8E2q2XFS88d/nzZ1MtW1gIxqckhtfWvd9GfoVL5uI8Jgki+24D3oeP9+b/rtwVuqkraLFMkJNQr+XOCbLl4+K+Wkx27594MTYB+KO4J9cX7XaxYOo8RSaeaChNLd/ati3/uAB0kl7VJCVl8xZvZPqYHd+vCXlceNRg3hpGqM4lz60JXQTlF06YU7+eANF4BOmIV4LxYx+apQbvf7rh5QsJbmt1NjRp71t87g9OTowqj2XseDeFQw3xLHGHVSFRY76vsgfRtUx6E8eBDcyD2k6bKkqSxwrRg5lpkVYGb7H+NQo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/5/31 13:58, Jiaqi Yan wrote:
> Now that HWPoison subpage(s) within HugeTLB page will be rejected by
> buddy allocator during dissolve_free_hugetlb_folio(), there is no
> need to drain_all_pages() and take_page_off_buddy() anymore. In fact,
> calling take_page_off_buddy() after dissolve_free_hugetlb_folio()
> succeeded returns false, making caller think __page_handle_poison()
> failed.
> 
> Add __hugepage_handle_poison() and replace __page_handle_poison() at
> HugeTLB specific call sites. The being handled HugeTLB page either
> is free at the moment of try_memory_failure_hugetlb(), or becomes
> free at the moment of me_huge_page().
> 
> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> ---
>  mm/memory-failure.c | 36 ++++++++++++++++++++++++++++++------
>  1 file changed, 30 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 95979b7995c1..098c4407e818 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -163,6 +163,30 @@ static struct rb_root_cached pfn_space_itree = RB_ROOT_CACHED;
>  static DEFINE_MUTEX(pfn_space_lock);
>  
>  /*
> + * Only for a HugeTLB page being handled by memory_failure(). The key
> + * difference to soft_offline() is that, no HWPoison subpage will make
> + * into buddy allocator after a successful dissolve_free_hugetlb_folio(),
> + * so take_page_off_buddy() is unnecessary.
> + */
> +static int __hugepage_handle_poison(struct page *page)
> +{
> +	struct folio *folio = page_folio(page);
> +
> +	VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);
> +
> +	/*
> +	 * Can't use dissolve_free_hugetlb_folio() without a reliable
> +	 * raw_hwp_list telling which subpage is HWPoison.

This reminds me that hugetlb_raw_hwp_unreliable folios can be freed into buddy yet?
Should we handle them too?

> +	 */
> +	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
> +		/* raw_hwp_list becomes unreliable when kmalloc() fails. */
> +		return -ENOMEM;

If folios have hugetlb_raw_hwp_unreliable set, hugetlb_update_hwpoison will return
MF_HUGETLB_FOLIO_PRE_POISONED thus these folios cannot reach here, e.g. me_huge_page.
The only way these folios can reach here is that they are hwpoisoned first time so
hugetlb_update_hwpoison returns 0 even if hugetlb_raw_hwp_unreliable is set at the same
time. In that case, we can simply dissolve the hugetlb folios and then take the sole hwpoisoned
@page off buddy? But this might not be a good idea as it is really fragile...

Thanks.
.

