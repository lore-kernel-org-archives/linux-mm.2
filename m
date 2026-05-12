Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7326CD4846
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 01:06:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 580776B008C; Mon, 11 May 2026 21:06:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 531C26B0092; Mon, 11 May 2026 21:06:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 447C66B0093; Mon, 11 May 2026 21:06:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 303746B008C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:06:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AF5031602B4
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:06:04 +0000 (UTC)
X-FDA: 84756976248.11.4F9135E
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf23.hostedemail.com (Postfix) with ESMTP id 866C9140007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:06:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=gMa+oL6b;
	spf=pass (imf23.hostedemail.com: domain of yuzenghui@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=yuzenghui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778547962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GU7qv2f6w4gsY9razakdKJCnHrZr7ZxMfRszKHD+pqA=;
	b=bJYPkzjB+RIKSz7WK9+zJdyMN4uogEqZPDImhNh2MZ8ngP1MLpAyERxlnLGMswQMlhkXTM
	tT92Rn94VcbpJuC8sD0XefJloKJEOgkVBi9Tsi2U/68iWjb1LZnbTm3cJYTtfpMvSN1PbN
	XBeg6P/uSvRu/xz6cSBXMxMoiTSacV4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778547962; a=rsa-sha256;
	cv=none;
	b=du0RtmzFrtT6gNkdGkBSzJEIFWmZjjT/7T2em9TxNcJANS1c1U7CHkW7SccuDMQApc6oUs
	PSOl7jgN6LIls8qMN6NH36dEy/QxzP3yO1N4N4mWZ610K25ibvn3bBznndp/U82k0FRFY/
	UFM4bp1KYPOp4AkzPDjuB1a2muTMgSo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=gMa+oL6b;
	spf=pass (imf23.hostedemail.com: domain of yuzenghui@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=yuzenghui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=GU7qv2f6w4gsY9razakdKJCnHrZr7ZxMfRszKHD+pqA=;
	b=gMa+oL6bYuLM9ZLznpmctfu/JvESgss8Fmg/XeayFoUkh1qu4pt9n5+Yn0xcxpJONsxgBIfnZ
	scWiBzhDxBkDqhK6zf2yA00m4rJxnPB/vqcrqpLaCSxc9eN/wCLc5RDzZYMOZ7YmWoDRQ2L5DDL
	6RLnZPbGuomDEk4TyagSYxQ=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4gDyrX6y4czRnZx;
	Tue, 12 May 2026 08:58:20 +0800 (CST)
Received: from kwepemk200017.china.huawei.com (unknown [7.202.194.83])
	by mail.maildlp.com (Postfix) with ESMTPS id E1FFD201E9;
	Tue, 12 May 2026 09:05:56 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemk200017.china.huawei.com (7.202.194.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 12 May 2026 09:05:55 +0800
Subject: Re: "alloc_tag was not set" when running mm/ksft_hmm.sh
To: "David Hildenbrand (Arm)" <david@kernel.org>
CC: Zenghui Yu <zenghui.yu@linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <jgg@ziepe.ca>, <leon@kernel.org>, Andrew
 Morton <akpm@linux-foundation.org>, <ljs@kernel.org>, <liam@infradead.org>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, Alistair Popple <apopple@nvidia.com>
References: <be9a8bae-9223-4966-bba9-2cbe39c8f4de@linux.dev>
 <10e4565a-b416-45d9-a8b0-cd32532b2630@kernel.org>
 <2b46241c-158b-c9dd-9b81-a98366b2c9fb@huawei.com>
 <c16350fa-2f74-4517-8d97-4772def97b78@kernel.org>
 <dff84fe1-ae17-410a-93a2-c5fb921e7f8f@linux.dev>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <1986f468-f8f4-c33a-9e02-4d5f833e3560@huawei.com>
Date: Tue, 12 May 2026 09:05:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <dff84fe1-ae17-410a-93a2-c5fb921e7f8f@linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.219]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemk200017.china.huawei.com (7.202.194.83)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 866C9140007
X-Rspam-User: 
X-Stat-Signature: t8q1y5j87q6jjib495g68ijj88ot9ibu
X-HE-Tag: 1778547961-636253
X-HE-Meta: U2FsdGVkX1+Xd0a+3qsonF9ig8QFxFiGo/8oe8lAYAx00xm5oYSv8bFVvmOw0uI7zYgnOceGcYBnl+6ub7Nn8ZKAhraNSn9luawVSU1RWJ04vpRNzuO02xXrxtfjEKBpFHyGbOT+kS0MLWbdIwrIkHrgEfdRAIo5rdpyRmzMcdLZPoXk/9eSjQkD3VKQS7hY8n08KkoudZLMJIntARQl7wm9i7OpwiISH9Jhm6C/awHVycejHnKhSQ8EY9APc+3UVoXj12dpVxvpRvciB+nLzjqEPGBBOab1Q0o+npBEyzFUAWnhp4eDZDuG9/mYGzN4s/CWaTQmwFxUOTb22BLguwEY8MmEb1IMKJESXxnu+7i9CRWMDmk2HRXNz+WdprfhSULJ/UvLwElHq1lo3utzBjqJmq3I6CZc9pX1H3mhB4YfaI+ESsaMJJBj6aNDnGUkzHEJhKNruKLEFwN8o7zxlG9N1xXk6Ah2NwVzOCG68tOBgTqo5xf5Yvhs04t4AYX3y3zLYui9Cel6Ivn/rLbj1FcP9UXnfOTjM6dzlHdNz9So919ZUjGVEQCTCKEmUCGRngnYQk95J21rLv/VdvacNwsKD5lw3gnBuA9CkluHuF1t5+kTuli9y/rfqIQxiabKiPjYM6jahI7q1GWuoDDNqoWZHOyJP1uHLcgy8i3NYzi03n5C5fmYJvIslLkxrEe59h2IkJ51uUK8R3qlCD6BJ/JbP/SZBuSAGhgnn2HqXTC5Fb+Ph7rEHK5VC6UZT39fubijUO5lsu1wA33CsiG/IDq/dVY0plHffy2O5LTw8UHragGtvy5fhyWJ5PNn+2cKGU+v1JFYwiyXpR/SKw5s4835H76tcFoF6PqY6rxwbjo+nQ4B0aS8+T4x9eB86AZ1BTQ3aWnNYPspW8LhTtg+LBxEqazdJGIBpihll6duvFli9q+jmvdVMMrI/6h7Z5aywTLeyaKhUc3eAMQq5Bc
 ySHw4Cgx
 9XsUQnK0zu0M4ZvX8Ce+nrQyNaplQIXtywOpk+Z/g+gchrbN7NJkiZp15z/oyJNKHAEdq9XUJhT6jpOogiO3h6VtfZipZ12CWWQu33oXFV0A9wUY6jNJOvzNZ78PxWB0jRcXWrA0UAjpBV6O5BZufrz259XET4XmLTB4hYJdNNgICCstNZcMJ2wIv02YR+E4zJxxFnINQvTVvwl1hChRUGax0sTke+JlSB4BqcsOKEtQQAxU5uzA0o7tLriKJk5nMmcaXG5NeZje9Y5DzfmTdk3HRLqvAMo83ou07
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/5/12 0:38, Zenghui Yu wrote:
> Hi David,
> 
> On 5/11/26 8:47 PM, David Hildenbrand (Arm) wrote:
> >
> > We do have a call to pgalloc_tag_split() in __split_unmapped_folio(), invoked in
> > __folio_freeze_and_split_unmapped() before calling
> > zone_device_private_split_cb() when iterating the folios.
> 
> If I read the code correctly, pgalloc_tag_split() in
> __split_unmapped_folio() deals with device private pages' alloc tag. But
> what alloc_tag_sub_check() warns on are real system memory pages (device
> page's backing page), which are allocated by
> dmirror_devmem_alloc_page()/folio_page().

Sorry, I meant dmirror_devmem_alloc_page()/folio_alloc().

Thanks,
Zenghui

