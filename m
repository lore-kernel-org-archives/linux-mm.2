Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5280B1093190
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 08:57:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB9D96B0369; Fri, 20 Mar 2026 04:57:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1D586B036D; Fri, 20 Mar 2026 04:57:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90C196B036F; Fri, 20 Mar 2026 04:57:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7B8966B0369
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 04:57:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47949C2A46
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 08:57:08 +0000 (UTC)
X-FDA: 84565836936.16.8E1968B
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf29.hostedemail.com (Postfix) with ESMTP id 15E5E120012
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 08:57:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xCSliBrt;
	spf=pass (imf29.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773997026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oxfwqG3HFzxboAnR3RF+cyCy+AoEPrF9T1H8MVxjK/Q=;
	b=xuuKxqkyfUku7t+dUc+sTDBQ07z2Mk8881OHaDkpyWXmK9yGvR0nWUPm4nX6QkyWeuQEMT
	KKKOpgoevqiyVJuZozg6WHKvsjS2x5FtlD2zANy+N9bHbW0/j+dzDa8or4aqxyAvkrVdJ7
	LmeVr5s6pWqWyWGllfRNb29WSnmr9no=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773997026; a=rsa-sha256;
	cv=none;
	b=AWsW5HUHAxD0vxMcz98AzPHPgQRyK7QX24uKqAG6tBCCBujD32K2HPMg6lRPClJgDt3ouc
	C98n3pqW2UoWGKwBMrrNumYtjmjOYoQdH/1ooKxtbgTpUfgdklw3kxLkY5eBFMzDn9Hrvv
	SlrKi2f6jx5KVwcQFzdjFDXiPZ+QHVs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xCSliBrt;
	spf=pass (imf29.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=oxfwqG3HFzxboAnR3RF+cyCy+AoEPrF9T1H8MVxjK/Q=;
	b=xCSliBrtiSLeruzJqtitv/cWXhkmh7Qtpssh8ugLNLMrUZxjSAU/QYz8S1T4LHwM/ZrIsXDjd
	/3mvJYBLGjUv0Lw+y1PIgSdc9iFleLMRNvdXIzR40Bn/WQ7UwtrAIVeXcZO8HVwFHHYarFANK8g
	9nGERhun2WBAqJ4LvZj5tMo=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4fcbsW4NRBzRhrj;
	Fri, 20 Mar 2026 16:51:59 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 8D51A404AD;
	Fri, 20 Mar 2026 16:56:59 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 20 Mar
 2026 16:56:58 +0800
Message-ID: <f6e30243-8253-444d-9665-9dfa33eda9ce@huawei.com>
Date: Fri, 20 Mar 2026 16:56:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/huge_memory: fix folio isn't locked in
 softleaf_to_folio()
To: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>
CC: <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <baohua@kernel.org>, <ryan.roberts@arm.com>,
	<linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
References: <20260319012541.4158561-1-tujinjiang@huawei.com>
 <20260319155101.f7a62c04a7bcfc838b63824c@linux-foundation.org>
 <d9d50263-a69f-4a16-b409-caeec93c423a@huawei.com>
 <37a204f2-796d-4d15-b21b-09fd4a9e77c2@kernel.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <37a204f2-796d-4d15-b21b-09fd4a9e77c2@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 15E5E120012
X-Stat-Signature: c76nntr4496bdj9c4iq5dhkzdpjcwh4b
X-HE-Tag: 1773997024-448020
X-HE-Meta: U2FsdGVkX18yLC72wQKapBtLWZ4hzgQFjCwZWxn2VJa2JHpprrTMd9vK5xswXDFx1Dq5d6gpYsPRbVmBF/mto8jRMpouDP/4aflXe85qC6Ibv/hvPW1WZpvaea2tOnHKTuJhHwWGA+RYSZ643/0ZRWu/U5/5zMdBszSq/76a8pXrRy+QmuvJpPDJBiWUgEUVpyREeD5A0U1Z2S/3LeKOTPi4/cpMTcj24Ulf4gwNI3agAdpZgutyJo4cmirgu7FmG7q1Q2kKPCNhsN3exSkvTvWyo7yI424UtN3zlATvYWVxqX3eQt5WJvK7TXCR4owMuvEUiKE3Wf7NGPeY6f2vgtR8rKY4Ky4ENOUxZ8j7LfTKKDJ7SYV+WKkQUNvN9o7Rq3TZa7iw6Qo+mRd+ZKXsoED7gVKjykLvOO9nwTsaeFKB7u6c9s2iKqN4EPtZMbp/0jvqsD4UPox3sY3K3adhxzeDByGHS6gxwekJPbX+GxYEPfzWKPOxb3phWRWKS2/sL+O879WQArl+m0el2MBugAB6PflUpYzjPmKlZvx9xpAooYRlxmOw9lRP8IzzpT0kvq6zCqiwPuGBmLX6+zMABfPAFIsGrKYvc0cxsKANyEJugdmNaTO4hIULJXybnr3uL+TEJXCWPa0UeO56uQJMUdSFGyNk20u0SaLSnCORsc+TLCMZHtAgKixMBA4asahIiHkbiOXbSXh6UoIE7vB9YuZXQnxHZXdnT0P9mCCP74oNPOCjf/1OVMaBaerT7XlDnzWEGhBKi9FZv35ahOjlZ493aeAUeSvK5o5qp814Sv1snDzQqyBxdy/0Of3zl98/uY6fLrfdLDkzqLZogirQrOxUFspXM1jMi5pDqveQrmRzyVmKaS39jvvJCM/BflEPPbZjSKI6FvxUSAR/tTdNvf+FAdoe1NAaHDEuYbH52ncTbhuIcUmWFfbS1qztcv5b+5Ydr0S0cSKuhZannSa
 8gL+YnRK
 //gDyfT3gJmCw8xL6abBfH5g+5GoYxqmY1UYj052F9R2JNv6Hxbn7WWgcepK4h535sg0WYLaP2qjq0WIH0CzJSFdMjtjUWqirRD1Ag78JeFIuR7JEN8jabJ/YDrVeitYjBVbfIiqki/ToZezfB9NfOCNPr2zps/bz/XxduZvlDLR32GSO8XkLzDUO8jramGUFE1Oqbai+O/lUnDYCeqrG6N+44+HA9LU+mjw3sJyobGnEw2Kshv26nwLcH3rU1vDr+Ig+Xfew7ts5ROsmzKloLKg4eQZO/CDK5IMldm9wlIWicG2AcDh1GizgzDDh+ewbi5Y/GvJNHEi+SEpLXRWi2BpeD7SD5I46bItbTmoJKOJcFObl2cJz8Yi767u2JS/JAQww/bfjfDh/OxNYinVREGP+fk8TMn2AnxUF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/3/20 16:10, David Hildenbrand (Arm) 写道:
> On 3/20/26 02:52, Jinjiang Tu wrote:
>> 在 2026/3/20 6:51, Andrew Morton 写道:
>>> On Thu, 19 Mar 2026 09:25:41 +0800 Jinjiang Tu <tujinjiang@huawei.com>
>>> wrote:
>>>
>>>> On arm64 server, we found folio that get from migration entry isn't
>>>> locked
>>>> in softleaf_to_folio(). This issue triggers when mTHP splitting and
>>>> zap_nonpresent_ptes() races, and the root cause is lack of memory
>>>> barrier
>>>> in softleaf_to_folio(). The race is as follows:
>>>>
>>>>      CPU0                                             CPU1
>>>>
>>>> deferred_split_scan()                              zap_nonpresent_ptes()
>>>>     lock folio
>>>>     split_folio()
>>>>       unmap_folio()
>>>>         change ptes to migration entries
>>>>       __split_folio_to_order()
>>>> softleaf_to_folio()
>>>>         set flags(including PG_locked) for tail pages    folio =
>>>> pfn_folio(softleaf_to_pfn(entry))
>>>>         smp_wmb()
>>>> VM_WARN_ON_ONCE(!folio_test_locked(folio))
>>>>         prep_compound_page() for tail pages
>>>>
>>>> In __split_folio_to_order(), smp_wmb() guarantees page flags of tail
>>>> pages
>>>> are visible before the tail page becomes non-compound. smp_wmb() should
>>>> be paired with smp_rmb() in softleaf_to_folio(), which is missed. As a
>>>> result, if zap_nonpresent_ptes() accesses migration entry that stores
>>>> tail pfn, softleaf_to_folio() may see the updated compound_head of tail
>>>> page before page->flags.
>>> Please describe the userspace-visible runtime effects of this bug.
>> This issue will trigger VM_WARN_ON_ONCE() in pfn_swap_entry_folio().
> But the impact is bigger, right, when callers rely on folio_test_anon() etc?

Yes, the impact is unpredictable if CONFIG_DEBUG_VM isn't enabled.

But for stable kernel before v6.19.9, this is a BUG_ON



