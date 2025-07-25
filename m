Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA1DC87FCC
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 03:15:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1DD36B008C; Thu, 24 Jul 2025 23:15:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF5096B0092; Thu, 24 Jul 2025 23:15:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B38256B0093; Thu, 24 Jul 2025 23:15:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A3D966B008C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:15:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 51BB5BA438
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 03:15:31 +0000 (UTC)
X-FDA: 83701321662.11.8F20D28
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf10.hostedemail.com (Postfix) with ESMTP id 48655C000A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 03:15:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf10.hostedemail.com: domain of zuoze1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=zuoze1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753413329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eKyiF05z26VXB/eaq05m4MvC4a513z/hOjclrw/Vp1Q=;
	b=tNK4p8GvyzUpw0hfJtc9/UmD2DtMhiWpqvR3Z9P9AabetvHIdO0Agg/wlArkRD4HrvJYag
	rVSd5M0cMgAspWO+siCqF3KsMxSxgmXzv2WnryYsnwdhxiL2aVVPSBwMRD9qyjuGmp+hdw
	a+YsMWiEjRbUGC5y5sDPXfPLmjOOyv0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753413329; a=rsa-sha256;
	cv=none;
	b=SdDFmf6cBMBfsgZWcMMDYIawo3gb/w7TnzXHIKmOaCrr0kmw+2RJQ2TR6SYkSOunr8Ff2p
	irl4whR79b5HjH997Oknab7+3jiMzywyxtfaEunOn8weLwlOEjs/P5X5EARjc5ru4oOYf+
	4M1vAUqHZNotu2P1Nn6fTNah3/F9q40=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf10.hostedemail.com: domain of zuoze1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=zuoze1@huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4bpCYl3PMkzYdNB;
	Fri, 25 Jul 2025 11:10:51 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 591D81402CB;
	Fri, 25 Jul 2025 11:15:24 +0800 (CST)
Received: from kwepemq100012.china.huawei.com (7.202.195.195) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 25 Jul 2025 11:15:24 +0800
Received: from [10.174.177.186] (10.174.177.186) by
 kwepemq100012.china.huawei.com (7.202.195.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 25 Jul 2025 11:15:23 +0800
Message-ID: <a5c871c8-dc52-4245-8513-94ccc2b46c94@huawei.com>
Date: Fri, 25 Jul 2025 11:15:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/damon: add full LPAE support for memory monitoring
 above 4GB
To: SeongJae Park <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>
References: <20250422174301.58953-1-sj@kernel.org>
From: zuoze <zuoze1@huawei.com>
In-Reply-To: <20250422174301.58953-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.186]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq100012.china.huawei.com (7.202.195.195)
X-Rspamd-Queue-Id: 48655C000A
X-Stat-Signature: wafmegu97x9xkwtghcipww3jnbtxacy8
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753413327-716244
X-HE-Meta: U2FsdGVkX1+j8ShBlPHB0LsmMHQYOOb3bRwrgXlc/ZnP1eVr+xPtvlP2wquWOdNIZS2uDC/t1FZpyMSsmfB6qhondlMxZ81iWRhEszJgNou78mEVpTq0NsLAhWY2vQnmfSeoKlS5vzYmfvru7Fk15EhFdIWYVwboLE2WByE0JWkPaswr0aWH+oB4b0zMc8W9v7ZFNnjl66LRiro51mc4VPlftm+2nGrjXRarrqb9j0kF3VEx8C8Jp9RA2VwFr5uZakk7FtZYYzDIrV2b2aotSybQM3aEKGqbx62iAfUfjWNWDt5d30OuYPk7vRl76CXsVcRYvUJxH9cWnjACKfjbvGTt6T9373qfy2g6QpQB/v7rYdqBdvAETcM+ae4fgbZZcGkqv5jy5nJoffCTS0uy+R4tscjwG0W+P/EAg3a4ahZ0J4YULlqPJgVF1iqeX7hTN/h/0xAxkhPY3baUQk9KC2s4wrQOgFAvl200RUiMNeeOrDm7HqER8CrgcuxnGLnmQ94t/jzS/Ulf2BMYAEYbjkS5kSaWJGfzkKeqXmnPc8hV7gTC1M48eE9PY2q3z4yTI0cgGOJelOR3TxBk1HNW7aN/bNn4VGH+y+/w3a+XmYVE0CA/z9rgXyYBakX/KTkz9F4fyhlw6XbjKDHh3ddCPHbMN43HGiNjO5Y0YUjvxYqLhXcdsxXbEYt4glaEZ1uH89y8lhd6O6jFX4AHC902HyaHIxReQT4E/+csH5As4KpFR3FR7LPvUpUDhJ6cQOPvzRxh4mCtynUrZLn1kjl+GMrSr8OQB66RRQvskWssiuNwxsGh3jg2srbRWebq8kIHu8Dza51GT5jctNznB/Um4am3xTIgbTbsXHVZyGwUGVRi3QGsWCaJRnhE9E9ysmOissHRaSqo8XvQfCx1glrYHevVlscFvjVRQyAt6uIL/5LIwpu9vrmqZtzF6Y7c6gAnYa4xvhVl7H4daSTUomn
 hLSMvImY
 SKRVWxKzMFpAaKzzLSzRBgZOI/svLT2eiGLRuoKYo9KQoTo+zabqhFaUNisY/P7ILIZllvnPj8DJcetb/23BgpU5QgLPz3MYad9HoJbExHPssVRJAidgKVbg8ct28ken0Mq7dgjUAiqFhQh0uMULfKqxY/Hke84bEvVPXvACgnuBEz3pqNEsZ08Gs1U2GrzRZevx2Mne4HEEUyHiNSXKa/r6YaIhvU3MfK2cUAp2niLb5gL5Bs8O7HRsZGl93PwESQzCPtfS+nLLFZhU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/4/23 1:43, SeongJae Park 写道:
> On Tue, 22 Apr 2025 19:50:11 +0800 zuoze <zuoze1@huawei.com> wrote:
> 
> [...]
>> Thanks for the patches - I’ve noted the RFC series and user-space
>> updates. Apologies for the delay; I’ll prioritize reviewing these soon
>> to verify they meet the intended tracking goals. Appreciate your
>> patience.
> 
> No worry.  Please take your time and let me know if there is anything I can
> help.
> 
> I think we can improve the user-space tool support better for usability.  For
> example, it could find LPAE case, set addr_unit parameter, and convert
> user-input and output address ranges on its own.  But hopefully the current
> support allows simple tests of the kernel side change, and we could do such
> improvement after the kernel side change is made.
> 
> 

Hi SJ,

Apologies for the delayed response. We've verified your patch in our
environment and confirmed it supports LPAE address monitoring. However,
we observed some anomalies in the reclaim functionality. During code
review, we identified a few issues:

The semantic meaning of damon_region changed after addr_unit was
introduced. The units in damon_addr_range may no longer represent bytes
directly.

The size returned by damon_sz_region() now requires multiplication by
addr_unit to get the actual byte count.

Heavy usage of damon_sz_region() and DAMON_MIN_REGION likely requires
addr_unit-aware adjustments throughout the codebase. While this approach
works, it would involve considerable changes. What's your perspective on
how we should proceed?

Best regards,
Ze Zuo

> Thanks,
> SJ
> 
> [...]
> 



