Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F6BBD30CDB
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 01:23:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4C576B0088; Tue, 13 Jan 2026 20:23:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0DB86B0089; Tue, 13 Jan 2026 20:23:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D448D6B008A; Tue, 13 Jan 2026 20:23:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C2E606B0088
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 20:23:20 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 63EFF160320
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 01:23:20 +0000 (UTC)
X-FDA: 84328821360.24.7273BE6
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf15.hostedemail.com (Postfix) with ESMTP id 090E0A0003
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 01:23:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=H9qVdmou;
	spf=pass (imf15.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768353798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AQpv3Sx7GMJb35dj687B0zUqXll2aCRDAzCen9Siz1w=;
	b=syloAs3KHsMnv6VOzUb7STm+qerop2aX4+vskhKXk8T7v0h8f8ijEMA7UD5TYvMBNQYlCM
	6G95oeAvvv0D+E9RQ0N6jMgBRuAlLGWgAWt2icDG8UUFoDvAzgNVB8qClUnw5URIgp/eHa
	bhxio/tDztRsHnwK7tzIt4UzZ6IPDl8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768353798; a=rsa-sha256;
	cv=none;
	b=nW56zcKhXRs67lW60/ETtY7SgZu/mD7Ro6wEdMQl2LQkQMN8Rx7htlNuNVqvyGo2fhQYLB
	U0kqAFHYCNfskqnt5TxgYZLATONTNQF/KEOI8JapZU9ltfOvAx6sMltps+Giuxb8/yCqUx
	gsGk6gfzX32/QZHITiV4gkYTHTMLKQs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=H9qVdmou;
	spf=pass (imf15.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=AQpv3Sx7GMJb35dj687B0zUqXll2aCRDAzCen9Siz1w=;
	b=H9qVdmouCQU26wygb/kI0dXtf6LVaZ2hTRXhRMqD6oABklbgCoLUQIsfepWFMrJ/N99+PE1Ie
	fynQg1uizS5FbslxvWGdXfg+0HtiKTbNrSK4R2D10ucs8AVzXYAhWTda8Rd95SXe7JXF4FKd9Ye
	y1sQcBuqziwm0dfdUuzbdpk=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4drSvp4JPzz1prMj;
	Wed, 14 Jan 2026 09:19:50 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id E8FC24056A;
	Wed, 14 Jan 2026 09:23:11 +0800 (CST)
Received: from [10.174.179.179] (10.174.179.179) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 14 Jan 2026 09:23:11 +0800
Message-ID: <0863ce26-3fe9-40e8-b6b8-e86ca8ce610c@huawei.com>
Date: Wed, 14 Jan 2026 09:23:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/mempolicy: fix mpol_rebind_nodemask() for
 MPOL_F_NUMA_BALANCING
To: Andrew Morton <akpm@linux-foundation.org>
CC: <akpm@linuxfoundation.org>, <david@kernel.org>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <mgorman@suse.de>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>
References: <20251223110523.1161421-1-tujinjiang@huawei.com>
 <25e3d755-4d4d-48c5-b1ac-ff62d37694dd@huawei.com>
 <20260113163739.902aade0c1b474723e20de86@linux-foundation.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <20260113163739.902aade0c1b474723e20de86@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.179]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 090E0A0003
X-Rspam-User: 
X-Stat-Signature: xbwcm6kwjzrh8i7cgsieokj6irznnkat
X-HE-Tag: 1768353796-123280
X-HE-Meta: U2FsdGVkX196QCCZ3qDFKTCriD71kku4b6FKLDxW+cHdI8wjqax1SnYpyl+x/21ZYp7RUmEtQm1z0/f+z65jxf1UkzLeWPxgIDrZ+0KxMRnZ9j/yoK4C7g8g1iK6WMTOB5yKvZBVpygBdJRHYac6TTKMdiiYXasZfk3SEN/YVg/qiB1d+VPZ4OER4/svXHB5h0o53G/qBAxMbJPvKY6hDg/0vW7qqTQor5z0d1PKnu9/tRPhx6xa2iWXDuwsLQaXOPaNPJifyztSf5ba/5OuVXuud+SN3mARbxe/BIAgYVT1k19sbZbrD8HnN8j+QCsKjDRglFnfon4VBslGN8rf0SIJcq91DI6jo9ZzfFoFUIWLirodRbmSYGSHF0rwLwx05WMd4ph+ROzJMa6PjhcA6BxmPYBp+DsfFOy720I7dBOukF6Dev1IdAgDyJBGNQs6t7XWYyg6vNEJuXIG1gmhqi5hMn+a3ImqX0PukRMw4Y3OEEuCXfKsbIgb/T5v292MNz7RU/Mg4eHsoesuZaqQr1rfYuh2xwrkDri1T6TdkBXvVDK3f3M3vFwOIn8YxbTV/SSRqTiQgt/VGUJuiLWQfsQ14DAsNnz9eFkEsoLtTNsLlpBZxhFQZXJ07MYphB3KSV6TmPkAoWb8K9djkD9FXLEn7KqT7HY5n3SpP7GdBzPblogn/D+k2OIincQPcd9WiYnsBnwtLTHT9Bbd6BiKSpmTkPQsJ+WB/v9kX0XbPcQRPHVc41rfHa1tfemrZ9JSlLb+bkwi/aysbhNSaL9mSigAK84qjOuzw3rT7DqXL+0BWN1B7EnPZXG29lelbvJo/E0TtyqXGwiP//AOgMvGaTKz+q8eD9yj5neMel71w9hQdusTF5OK/8bqH3g4YnqkF4kfPd06wRbQLBNmCd5BFXLwuTQ4qktq+5WF9hrdQVxTOKPGFNf5kYNOONnFI4IroyeznzkPn0qtDvYT+b7
 UIqQJK4m
 cTN0Qbc5K9I1KU0J1+IXknewo29dcRoB26Cy3VNt7TQbu3k8ih1PqMoXw3AjZUi1AyEfcEk85iECfUP950OF1y8jmE91j++SU3Sp/tD3c5+yJUOI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/1/14 8:37, Andrew Morton 写道:
> On Tue, 13 Jan 2026 09:52:42 +0800 Jinjiang Tu <tujinjiang@huawei.com> wrote:
>
>> 在 2025/12/23 19:05, Jinjiang Tu 写道:
>>> commit bda420b98505 ("numa balancing: migrate on fault among multiple
>>> bound nodes") adds new flag MPOL_F_NUMA_BALANCING to enable NUMA balancing
>>> for MPOL_BIND memory policy.
>>>
>>> When the cpuset of tasks changes, the mempolicy of the task is rebound by
>>> mpol_rebind_nodemask(). When MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES
>>> are both not set, the behaviour of rebinding should be same whenever
>>> MPOL_F_NUMA_BALANCING is set or not. So, when an application calls
>>> set_mempolicy() with MPOL_F_NUMA_BALANCING set but both MPOL_F_STATIC_NODES
>>> and MPOL_F_RELATIVE_NODES cleared, mempolicy.w.cpuset_mems_allowed should
>>> be set to cpuset_current_mems_allowed nodemask. However, in current
>>> implementation, mpol_store_user_nodemask() wrongly returns true, causing
>>> mempolicy->w.user_nodemask to be incorrectly set to the user-specified
>>> nodemask. Later, when the cpuset of the application changes,
>>> mpol_rebind_nodemask() ends up rebinding based on the user-specified
>>> nodemask rather than the cpuset_mems_allowed nodemask as intended.
>>>
>>> To fix this, only set mempolicy->w.user_nodemask to the user-specified
>>> nodemask if MPOL_F_STATIC_NODES or MPOL_F_RELATIVE_NODES is present.
>>>
>>> Fixes: bda420b98505 ("numa balancing: migrate on fault among multiple bound nodes")
>>> Reviewed-by: Gregory Price <gourry@gourry.net>
>>> Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
>>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
>>> ---
>>> Change in v3:
>>>    * update changelog
>>>    * collect RB from Huang Ying
>> Hi, Andrew
>>
>> This patch has been reviewed, could you queue this patch into mm branch?
> It has been in mm.git since Dec 23 ;)

Indeed, I missed the email. Thanks.

>
> The changelog led me to believe that earlier (-stable) kernels don't
> need this fix.  Maybe that was wrong?

Yes. This only fixes a minor issue.

>

