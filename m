Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F35ACD8C85
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 07:51:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EBED6B008A; Tue,  9 Jun 2026 03:51:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59D8D6B008C; Tue,  9 Jun 2026 03:51:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B2BA6B0095; Tue,  9 Jun 2026 03:51:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A9366B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:51:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CCC8EC1C9A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:51:55 +0000 (UTC)
X-FDA: 84859605390.18.6CCE9B6
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf24.hostedemail.com (Postfix) with ESMTP id 81DF4180002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:51:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Un4O6Gug;
	spf=pass (imf24.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780991514;
	b=TUzV5WtZPo/aBjG46F5KMcHnvLHj560AVbAk4TLoNslB8R/kEeTbKLUKW/3H2I3Bk5qjr9
	4XzLVDvWghw1Yv8A6tQB2tyjJBus665fUc+qIn5Am0LmncYECDKzQvWR/OBksTGkj18/pL
	fu2J5F8CdCiR3RoaxxeWP7ohk5QSDE0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Un4O6Gug;
	spf=pass (imf24.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780991514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2FM4sS/C5uG7Pi6GSiyi+YB4VWpWxENKePM4logKFk8=;
	b=GYiK7lklh+xwOD6e1C+RidbH+WAj1R/xwDmDvtbDC3NXpPp9KZpMPAyRHNfuX8NlgJPVZs
	gBPTd8oRbuopS1D0Zuy41XWiTUFOG8O3p9V9hhP3X9YGdrQG5QmdCqNL2nv/WlGRWJmjhb
	sf9p8ErBiJyWzbRwkJIF1+4xQzLG9Ug=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=2FM4sS/C5uG7Pi6GSiyi+YB4VWpWxENKePM4logKFk8=;
	b=Un4O6GugkBeaXI2tHa2pBYDiDsQNOT3aw8431Ml92QSBu5/2j/xqtEeqpALgdvA7z46KaugH2
	1DZmGtnDu8tDUmW2iNV15nVdEeHyJ1KXdK+HCzE1oRxGwRVFGxLlF4K1jw88UF3b/Pw//53l6+X
	GOLUWCp1IxoyE73b5Suc1Fc=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4gZLWb4131zRhWL;
	Tue,  9 Jun 2026 15:43:55 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id C8ECD4056A;
	Tue,  9 Jun 2026 15:51:48 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 9 Jun 2026 15:51:48 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 9 Jun 2026 15:51:47 +0800
Subject: Re: [PATCH v4 2/7] mm: memory_failure: Allow truncate_error_folio to
 return MF_DELAYED
To: Lisa Wang <wyihan@google.com>
CC: <rientjes@google.com>, <seanjc@google.com>, <ackerleytng@google.com>,
	<vannapurve@google.com>, <michael.roth@amd.com>, <jiaqiyan@google.com>,
	<tabba@google.com>, <dave.hansen@linux.intel.com>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Hugh Dickins
	<hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, "David
 Hildenbrand" <david@kernel.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>
References: <20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com>
 <20260602-memory-failure-mf-delayed-fix-v4-2-a5bc7db5a9b2@google.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <76848661-d3cb-03d5-f351-4ffdf889a09e@huawei.com>
Date: Tue, 9 Jun 2026 15:51:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260602-memory-failure-mf-delayed-fix-v4-2-a5bc7db5a9b2@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 81DF4180002
X-Rspam-User: 
X-Stat-Signature: hr5r7e9cfth8wqwf68o43q44q99btf63
X-HE-Tag: 1780991513-489859
X-HE-Meta: U2FsdGVkX1/j6OMJVJVuum9EB3k5OXkY8b6R6RrTOKifH9pQBHHL8P//GzDKC/oVUhVZEvQvHAzrvA/fsbdmwW2tRpPBhqoxr69VILUOhLFoFbt4dvwbEDaGr/LkxQ7LtHZ74sLDWDxLB9TCFM5mESRuNyHIXMpF6swPJ5GYxzs/41OwzBXobWKfSPcpAA2UylpH/Lmz5FRG9lzxetDusX4ahSKdNaXFmplP5PbKpRnYpreE5rymBPMCcBxQqO/4EkD21Wx1Q5VOHBDTfEAwE6fH6lfFiwR8R0ngwCw24uQs6WkZGSF6hHsMSKOGRxh4TeCg+6xGg3QpuGioOM2/pPehP1lrfqLBceiQDEwZcke30J5AOWouBAW91W6gBZBE13pMeWjlf9aBKNet+FMxq8c3RXrqDuthz0K2Xo76Y+LH/Z1xhQh/3Nuu3C/c6VresoU4WMYG9b85g0gBJemnIxYlXChOns2CmfT0kPj8EOm13j0lB3ePNYZDjnA2wHsU5ZPS4O4qPVW5nyay2fEOO4hR78M0COldVBeG4sWLgxE6oMwy2thjBAXy098AaXAf51/1gAG7EuvoSn5ogGvgsRnNssAfLMC1VWjAPX7Kl4nSRgZymEBuNhUUqxXU2VhV0+BbGUg5AotXh9tJ4t43yOEhpEbOGQE6QRS1RMk+pBAF25IHYZOUy3GOr8SyGC5hl8FetRDuCNsk2xpt3i6mj6PkdUDyX+irSz0Hfp0EA+xapjOBQ4iUz5W2mMvciPCAoaWVeAzfPcvVwssDZW5qPy63XZg2/x8fynFC8zzGOnEB34apJ2M6c8JOt5NQ25QEMlg9hoz1oMIgpYTPVBF0dkC88KWillBGHUmDmoPfgQmMYP8tSKo9+IvS2JqB5DQJ/fIjAJUW+ecL0TnbLEyl6rpTbSZcWIHTwVUIs+I3kza215TY1tA1fOGG8by6Y0VznCPPdiMWHtQCdVfA2mo
 a177tddu
 su3Fe5cqj1emXZZG33gaph7xelOdT6/oi1O2ibbNLhHZGhYBEcjvmmkuz5Eshvgw4qKpKO5Omnz77rtmcmQgGdjGU8xLWm+ulwzibts0c/bNkYcWrcvBPS0ka4EX+1QucTWkN2YZqpkWVqW212nPJT7ALycQ8QFg6zjovL/YyC4Z0dUG9lKUjgpP+5mwtTLjic1qm2WzYkAAaPGypZS35ZCO4WI8NPRxJw55j4TtHkFQNf5vhs5Q94MSmrc+xhdHJZUmcJXJZpFODpeFCsvsok/5KLa5HRbmo4lhMnd34sBGvjPtooZTa9Y6arrJ329IcE54Pv/kczFFNRpl/w154/lCxzFwRQeyCr7REEEmaAdvq4lWLlkca+WCYNGSk4/4L8Kp3PQgFaWLxfGi1M+DKO11pksCFMZ7mWC96nnGQeeBsOT7SLcI1uM6dWrWn8VPoBj3S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/6/3 5:55, Lisa Wang wrote:
> The .error_remove_folio a_ops is used by different filesystems to handle
> folio truncation upon discovery of a memory failure in the memory
> associated with the given folio.
> 
> Currently, MF_DELAYED is treated as an error, causing "Failed to punch
> page" to be written to the console. MF_DELAYED is then relayed to the
> caller of truncate_error_folio() as MF_FAILED. This further causes
> memory_failure() to return -EBUSY, which then always causes a SIGBUS.
> 
> This is also implies that regardless of whether the thread's memory
> corruption kill policy is PR_MCE_KILL_EARLY or PR_MCE_KILL_LATE, a
> memory failure with MF_DELAYED will always cause a SIGBUS.
> 
> Update truncate_error_folio() to return MF_DELAYED to the caller if the
> .error_remove_folio() callback reports MF_DELAYED.
> 
> Signed-off-by: Lisa Wang <wyihan@google.com>

Should we add a Fixes tag here?

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

