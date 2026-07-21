Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81B66C4452F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 12:58:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 828D76B007B; Tue, 21 Jul 2026 08:58:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D9906B008A; Tue, 21 Jul 2026 08:58:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C9556B008C; Tue, 21 Jul 2026 08:58:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C3056B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:58:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C692880141
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:58:30 +0000 (UTC)
X-FDA: 85012787580.26.E3A73D3
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf10.hostedemail.com (Postfix) with ESMTP id CB99DC0013
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:58:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=Lu55HiYO;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf10.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784638708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WQ/bIIO+fVLNltTgziHSVBVNXf4iqiNT2wWZgC2YhaU=;
	b=juqqlBwgGGKcBvN9WzwjRGL/Qh6Gjsz2Gh+octL0p3B2tEBcEtNenMur+FOJy+ARsJA9pM
	koUOClu1173qgmtRbJXJZxK4Dv97/Ym2/RfbNr5x2KkFgt3nt0rNaOzvrE+Y58jE2Gkdfx
	e2kDjejglRcqG9JxV6/qp8ymuNgEUFU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=Lu55HiYO;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf10.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784638708;
	b=EBr4rRKIDu9p45pbB9faJAi12RICvDJHw+ZojbXlWvzD/uTlE/mR3mWtRqf1a5kvY4rwho
	T4Y7o8qE4RcIzZCUxr9VSa54cypkJriqrrl7nQNwfvNjuYQZuHtQgXckF/670opWsiLJD8
	2UMApt1E9eGPe5WcMs8cvxdNUvo7jlw=
dkim-signature: v=1; a=rsa-sha256; d=huawei-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=WQ/bIIO+fVLNltTgziHSVBVNXf4iqiNT2wWZgC2YhaU=;
	b=Lu55HiYOJ4+JZue4XXyulYTRzrGLbp8+ldADC/bKhsApTDw8uDXqDBgD55OdwRAPU//nJGQpf
	ZlsVv+/gQFZywoUyx4/MtgqFBCGZxmrqnSkaitEn4AqE9KqpqovtxWyZl8gm32z8CPOTrtVMAW2
	aC8iaLQBuyHu+i8uCxPi4zs=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4h4HVQ156yzHnHSX;
	Tue, 21 Jul 2026 20:57:50 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 5F9724058B;
	Tue, 21 Jul 2026 20:58:14 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 21 Jul 2026 15:58:13 +0300
Message-ID: <524b7d2c-4136-4476-9a84-a3dedcd00c5e@huawei-partners.com>
Date: Tue, 21 Jul 2026 15:58:13 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/3] mm/damon: Introduce a huge page collapsing
 mechanism using auto tuning
To: SJ Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260721035848.147455-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260721035848.147455-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CB99DC0013
X-Rspam-User: 
X-Stat-Signature: yn3afmsenhbbao3f6oqj5puktt64r54p
X-HE-Tag: 1784638707-327738
X-HE-Meta: U2FsdGVkX19rhM3tgpBXAuA1Wc6F6BAjpQp6ZX3KktobI7ro9LpmkALb6vZ+DBHMDM6qkRT9Khvz2hrFFFFbn3oEBs2lrCnLw7JGShNrAH10z0vS7KHL9FYye5VO4o0coe7e9FlJ5+LQH1VBzAoLXiaOPWhts33ke41k5zAYWb/548tqPKExMchWm+u1A4FCzYWrP22Shx1Gt9wm9vWfmefPD2q/q5pP/EHcz/Vo5euu8JfbtUj/r4D+yBOctOVatnGup8zW6JLam5ufNAcTQNjwjoXEPYwVqDbbnXgmxcFsvrnB31DyBbMk44UDL2UnSwdpcFzrSo7u5UTXylLruR1KQ9fCC+YiwODi81qKUFfN1DsxX+9lHI5x16YKSPU+5Kg0rLCzWG3o/BGlqadeZQFtlhAb1sZTAbVtGvnmqNgLUtFraIWLmGnzFimRAvjj1yoiB2frwLyObxiJzym/o3/Z0Zyavw4/dWl8VAOW4Q0jrYGl1YGuTde4xgyuj0FW+tv4OTo/j/QG6U0++mNNhHe9sjfAP+jkK9CYt8EE1qYCWd/lOM6JAxj+sm79/J0JAuZmR/bO9lyUViaGP3XvR2tLHkW8eBvLNyrsydd/DkI+tFZuAdoH/OrZmnhFOxWn2tsluNYpTP2uoi65uDAbKmYDl3VqogMrCSTrfjAVLvam/Hqq0syxJT3ATS0rx6D0nY3d6dgX7TAwxZT+WwbF9cO/c/Sr6RuuxVwDKYQQUdE5WXYF1PdBK4Zs//b9QfwjUSr9OXgR/WOI0SPEc6WAFfPrnwD8RpEsy3lui3W0iExAoxy+RVOZ6+dl8h14qYiB/htgRf8WdyWX2GYgmLSdT2jvWMyF7KHk7K2wNFth6SP/euvhGJ+QUQXQhZ0Vnrn8s0pAe9kU9kpUobPfxdDn3P+bc6/qVwHPWLct3Cjbc0ICGXHTy0MRrqr2u5fxS9l5q5mWUsDGuvTftOBUYXN
 w1tor2QQ
 yX/yN2LHhCCq6X7YlHkSq2gn9gIFqOr1daQEnhedsKFN8m1CyeSAHVDIJkyDcmYysxVrc6BKWU+we3sz031URrnag+QoRtp1nhOwWjMiAqzIHVUbOTbMqOq1UZUI9/ekv7+1hZwa5OSifX0W4kbr8K7EZUUIkJ+lV18ZRpvPc+j0J4fjVk8GhZfGlEZ4ic3lGYGP44JlOydlfN0fr7OTln5GfvSURInVs4/JHXG4/qrysfqGErqSNlUlc0MoOm3aZm50wtZhy7loocL2OgTYrOR3S2uScl/aX6ZaYtwZvzMf964zz16fqc/YsNzBP/7Ph6tnmXPyBmZTzophfwlY21IC7b4kcoVdzwwGa0YLv5G+JkXn2ZNpqdTUWkLIdSzxgw/2kedMS54+95MMnI/9aEreToQSDvrLrN4pd/plxzMuG36eM/bAq0gn5MoP/sw4lCXu8QIkHMEXVonA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On 7/21/2026 6:58 AM, SJ Park wrote:
> Hello Asier,
> 
> On Mon, 20 Jul 2026 12:01:37 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> 
>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>
>> Overview
>> ========
>> This patch set introduces a new autotuning which allows to collapse
>> hot regions into hugepages.
> 
> Thank you for making this series well done like this!
> 
> [...]
>> Patches Sequence
>> ================
>> Patch 1 -> Introduce DAMOS_QUOTA_HUGEPAGE_MEM_BP and autotuning
>> Patch 2 -> sysfs support for the new quota goal
>> Patch 3 -> Document hugepage_mem_bp parameter
> 
> I'd prefer handling 'total' underflow and returning 10,000 instead of INT_MAX
> from damos_hugepage_mem_bp() corner cases.  But definitely that is no blocker.
> For the series,
> 
> Reviewed-by: SJ Park <sj@kernel.org>
> 
> This series is applied to damon/next [1] tree.  If this series is not added to
> mm.git in short term (~3 days?), I will ask mm.git maintainer (Andrew Morton)
> to pick this.  In the case, I will update patch 1 to do what I mentioned as
> preferred change if you don't mind.  So, no action from your side is needed for
> now.  If it seems I also forgot doing that or you cannot wait for my action,
> please feel free to directly ask that to Andrew.
> 
> [1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees
> 
> 
> Thanks,
> SJ
> 
> [...]

Thanks a lot for your patience and help with the patch series.

I will work on the suggested minor changes once the this patch set
lands into mm-next, if you don't mind.

-- 
Asier Gutierrez
Huawei


