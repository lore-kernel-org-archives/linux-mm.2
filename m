Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D4DDC5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 09:28:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 917266B0092; Fri,  7 Aug 2026 05:28:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C7A06B009B; Fri,  7 Aug 2026 05:28:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DEE96B009D; Fri,  7 Aug 2026 05:28:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 527F36B0092
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 05:28:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BF9FDC028A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:28:52 +0000 (UTC)
X-FDA: 85073948904.26.F0CF04E
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf31.hostedemail.com (Postfix) with ESMTP id E0E312000B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:28:49 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=JxRLzjrt;
	spf=pass (imf31.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786094930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RFHzGwHdwARcBeZtvE1HMWPkjaYSc15ZUyxUDfzZkdU=;
	b=Ji9jt88bSbliI77c6HBKsP9aHX0Vkxl7ikp0FiWs2RL8O6PsCRs8/D+obFTzWIHHNTwPJA
	Avy7U3DKzPKXgugRVQsjSYbR+hAtV5vrf2s4EaZZ9NAPz+gzYy4+rXHeyMjZ48ufoq+Pgd
	UQWtIQnjY6m0IFdYKBHR/HHwMCGrqyg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=JxRLzjrt;
	spf=pass (imf31.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786094930;
	b=DPsb+bcgw5vnR3fCXBeensgGMF020XkZQa2htT153GhLFTkfAd9Nbk+X9TunMaKMxNN+Xr
	jWybGerxFU1tMd+pUtoQiikNoZB9gFqVgcnRb9pmBIbO2DUpqFaXPi6VDKDGqd9OWXeqMZ
	xqz2PUcMJfbYrxynDGxOWKGw5JH4hn4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=RFHzGwHdwARcBeZtvE1HMWPkjaYSc15ZUyxUDfzZkdU=;
	b=JxRLzjrtQ2gJGX9brEWGeK9O+LDHpICyegLWadHBXppn3jg2A1OzoUUGhE6+fPKql6mqe68JP
	07LOgFhQreBTpV27hRCFy2i/ez52k561oyJ14dLLDoaXLgl7i5DsOD9EhXskbarTWvVp3+hT9DS
	t4zamR1OA+d9X50TeeXwuqI=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hGdq14t5szmVXX;
	Fri,  7 Aug 2026 17:18:05 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 98C5C4058A;
	Fri,  7 Aug 2026 17:28:39 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 7 Aug 2026 17:28:39 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 7 Aug 2026 17:28:38 +0800
Subject: Re: [PATCH] mm/memory-failure: fix folio refcount leak and
 min_order_for_split() locking
To: "David Hildenbrand (Arm)" <david@kernel.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Luis Chamberlain
	<mcgrof@kernel.org>, Li Youhong <liyouhong@kylinos.cn>,
	<stable@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
	"Nico Pache" <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev
 Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
	<lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Wei Yang <richard.weiyang@gmail.com>
References: <20260806-try_to_split_thp_page-v1-1-a259e3387e38@kernel.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <b726c265-eff3-f185-8eab-c2a9a3bdc77c@huawei.com>
Date: Fri, 7 Aug 2026 17:28:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260806-try_to_split_thp_page-v1-1-a259e3387e38@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E0E312000B
X-Stat-Signature: mpz7quxfm638k873qp43qb6jh9qy9deh
X-HE-Tag: 1786094929-508576
X-HE-Meta: U2FsdGVkX1+aVFCDJiswhOVKg5+ORQnYZp/Cqy3ekUmO1rxxEwG5whaKc2S+4y0SbyHc7MGBQzYRPGUGdUuRKqIamTorXTMr8mVW1CQEVsKAQ81vSYN3fTywLW/nCWdNsR4+Ev3sA2hzDTgQeqUCzbdI+DHaTCeRKf2oP3n+XeLvgxMdpYz3xlTl6dyEjAEuYI2nsTnKE5DClYXguL8MNnp917dyKqu1saD8viLtTnDZgAC1izHSi9f9TSDv/G6iLsX17vGwBcOD9SgXHcAQe08OQBdtLoyCQBghnwlqaXvcAhHhBlZIAmpUKqyF0dtnIuav99WvmtmDs325TpasaFmEqBzL64ojdDDrRzX9ss8NWWgyBMM4IXF1qAEol5eLm04H4e6gyAJdrLy8Vey1a47AU36s1j7q09QBynXHf9+N0m8QgFa7zx6BjpsCPjwdVTOKRdg9cV+B830U3bCoIy19sx2rKYZ5+C1hBfmWgBYbvU1VIi7I5PVr1uLiZMPNLo89Zn5HK9ECXdg1LraBCfid4NQsL9dIlzmOl+/xd4977tA1cTxHD5kshf7iNd4osKOf3/0iSSuyw0TTNgqG7Z29YqAaeQEELbDo17MBz8g/UUwOdI2dNQgI/C18x3P2HhkaYS3EbXbIq1mpL3xsCWBdhByUZI15JrSjBKtT0dAWj9+6AArIhUQMU28LS0rnREFWQ9Kjh3nCFc79lyX8TmjSNxRnxpyKqo+EibWt29QzHNA7QKrW+CNPolhMEeWY+CsUAas1hF7pNjHg/doWlFGb3HUY1+lSPu6O3yV7jdbD70XI5kDoPaKgV2UjRSRKBQlAeMnCMqSAdEuUERFC63EDCEEi5yVkNFk9lraHGsW+WroJmHOvNyLw7uANvk6PeyBAwAxOgzIZ53022u2gR6qxlR/+lMbe8ULPxSLZoKA3y2CDbeDIX6RrncFfvCwiSM3e2CMKN8pBdZ5E3YJ
 Eqi1MhVN
 ZJJNILaYi4dECEdlRkWbKNHtA+RtlM+A4GSSNvAC0lIjHbwZ7kkPTGC9ppeCbmDr24YGlVREzA6zK9ylCV0iEtTQi5Oe/Nayj0FEZeRznEghTa7Z22lCsTP6zXUzKP2psDvJHfETY0cSt5QBTTEjv+xNuwkn4XKuH/f0swgTS3OQxKZinYIIqCHCBxWmGaM7o++hOpbc56E6qp4IJQqnTVopCsR6Ymx5zkEqwIxWOX47I8T15vcS3Mf0tQcUsDsqc8BtLvTMuz1p8ZE8s7+bmySGZo+tqYZdxWQrFxiv42kpRIFk2xqlnC2JrN8CBSMts6kCsO0zGl1S8lv3fy6USt7YbCzVLAjIEXUFy8jxHMNuA6ZWp6/38K4hSNPLR1epzJTDSnTORKo5epf5bpJrKj/fKbmuUM4SyhtE1wSXsgCRJQC6Zgrw9Xs/SkZZlJCFVTlYsHr3wWCIkbGfXis162MXjRK6+SqSyHvN/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/8/6 19:14, David Hildenbrand (Arm) wrote:
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

LGTM. Thanks David.

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

