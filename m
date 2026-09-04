Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD9F3C61DD6
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 03:38:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA3576B0088; Thu,  3 Sep 2026 23:38:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A53DE6B008A; Thu,  3 Sep 2026 23:38:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9417E6B0099; Thu,  3 Sep 2026 23:38:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 750826B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 23:38:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 170A7A4918
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:38:33 +0000 (UTC)
X-FDA: 85174672506.02.AE590AD
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf05.hostedemail.com (Postfix) with ESMTP id 41FF0100006
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:38:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="cr/bVGZm";
	spf=pass (imf05.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788493111;
	b=F4kgwr4w0xzkQA0QQrxtM/do0lLS5cH2UXIKehbNzskJTzwrFCtlAqCt0Ros+S41YI9T2e
	pvkdLmo/dIFFxumIANrGVypOmQv9ToFGEgKv9Uqg7hQBYNQHyEvPoLISN9fcMiMn3LaFtH
	YFsAaTtZ2dx+7lW+nQqh9L0ZLR7DwYc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788493111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=biC4R+3LhAPGPOqKjajgQ9ft5Kgc9aWgzDMercUsc4o=;
	b=dmLo4oZXp9k3vAfZd4umeFO9PYblRsSmtg7Ay1k411aYtvFrYPLMAj0i5suTYbI7YlYuiv
	b+q2td+dKGZHbNUnCZDBm4W/JYHTHpm3fpRAWO9iUEwCiM8KUPlvSsNuhBO8ZWg591YLVC
	GhRGPNI2BP43QgYNjuBNx6xFkBjTQZo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="cr/bVGZm";
	spf=pass (imf05.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=biC4R+3LhAPGPOqKjajgQ9ft5Kgc9aWgzDMercUsc4o=;
	b=cr/bVGZmvR+Db/oP0Dj9tZ6ueSc2zbqdvTsKUvCJhO/Jdi3VIzzceDdmWB2g/An67Vy4ZH3Y8
	+gJOaHYmE4iydXuWUh4hQZ+eyXPc82AtoKa5SMp2lCze+3HMM6sddWsmMFg7q+shXnewtB/pxGq
	Lep5wAs7BZItzX3UODjNGeE=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hbhjS5kvszKmVp;
	Fri,  4 Sep 2026 11:27:24 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 8931040572;
	Fri,  4 Sep 2026 11:38:19 +0800 (CST)
Received: from [10.173.124.160] (10.173.124.160) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 4 Sep 2026 11:38:17 +0800
Subject: Re: [PATCH v9 02/15] memory-failure: Prevent hugetlb freeing during
 unpoisoning
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
CC: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	<linux-fsdevel@vger.kernel.org>, Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>, "Gregory Price (Meta)" <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>, Jane Chu <jane.chu@oracle.com>,
	<linux-mm@kvack.org>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-3-willy@infradead.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <616d673c-3428-24c4-c3f8-ce93b950e142@huawei.com>
Date: Fri, 4 Sep 2026 11:38:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260805210557.1118966-3-willy@infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 41FF0100006
X-Stat-Signature: fcejnuzcwxidud1e99itsd1bzoznx7zf
X-HE-Tag: 1788493110-689541
X-HE-Meta: U2FsdGVkX18UaOeKyGb8fM8D2uJITmC9iBUe9vaILJqLPgwSKRbmiWH06yGhN3bSMfStjwaLjf8bAc32orYptMb86b86VU47VcYEkWI4ynOrev8DNw9qJ/YBDVnEYei4EQxH2EVFMOO/yRdU4fJczfT12KawgKhBrwBC1C5ydHEXXiZ4lwaajZVmKVLHcks6QyMjaZvEbuEMZni1Vxu3tsb+YWTR4sAH7oVEyyR54uvjZr5/Tane69evEUnm1h0ar/dURrZIz+Z2UZHU3eLi6jI/8n163YJPOn4g7fbFuDK4MMqN+MmYJqgS4PMzzbtVzzk7PVVaDkhhYk9xiz1ZOkuH+uSLHucdDS5s1ttvDW1lmiNAx8b0eq+IeRni8UQsSRpgJw/x3vKlwyMFzvVC8/X64Xdqpbo+wHNcKfn3KMIWQVfvnnfDGpQFB4BNlwWk9JwnPaEZ1bpkjkcWoOuOs8eB0bqdxwkSicGxIbQ8C0JhUw3v4HherEkFNqAtMQ27lGr3vD7pd6zKHBpDDfQyGrhoxzMkiXB315MxqMMKSQYr+83h9PmF5qS5rDrW4AmqUmktLn7nKf/u6fcUdQVv38PKRDm9h9mjWzwCfPOuLK9ofVW3ZqzFzY9RQXLe7sgrP1LvBr6U/DJAb+derKUTs6MQB2oXwrqazE7KBNXnymknYz/bNeJfV1WOYZzBgHdLBksZ9mS00C4aZM/5i/InbNKM0k2kDX9nl/TSe9YAVUAtbSvvwzbe03Csb0dlMvZatAo+TZ+58zMp4KM2VqL5VZvnRTG2gPrx+ZOUewCD9HBQ/S8QanC8yAMPBWSGK88/GO/pG8L3y53WlKDx0dwW+6YL8rtSl/cJfcVC5qQzSrX5QZ/nxHku+A2/6KKnEkhmD5aFwJP6XShybzHF7zaoIoCPMPYHI7oXfyeDU6K25E6+WuOtXbKIM+EX1qGCNR78Jaujyw1cIwJZlPKsuHs
 X45DZWbE
 OnjTLN8d7gnRREEty6o+WUiQ7DhQlMjBANTQYHqai/fD303t0/c+6iX1QOjYItlZifRUmVHzmIYPKdYIVotIccueAvxqWrFFy0yfMnv5ozh1mKwxuy5w4oQbP3kgRYLQGBH3NTzl6deRZWEMZzRYqLncQAP30zCgHu9PZRUFhJ4FRmeaGygYmHKeiLALQDDC8zlc5WTxBzY8H/PHhta8zGHtOl1WbjewqVwOxc64qzIYT7W0Ke9MgW3eyC15KsKR2jOeGHQjXwVBYL+DN++4fBDZjL74/9meDH6V+Q2ujvQS0w7TshdhXpAPm4eGep3qhj0mzNkSVclgcbHjTa5T5eZqLQ+FKKTd1VsRNWr2S9zSylFbmlCqiWalQE/BPzSEcob/YyW+X/aJveytgRzu0OO/witXZ3q2XM3Y3C2mxlgsEZfutLeUFBggPqyFLpXu8wbeeE8fiN1TzuMJtm6oMYtnaOd33vOrA9hsUc7imJotqqPBOLqxIXezfoAwSm4PKkcy1ndF0Gy6cmgg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/8/6 5:05, Matthew Wilcox (Oracle) wrote:
> If we fail to get a reference on the hugetlb folio, then it might be
> freed as we operate on it.  Prevent the freeing and the attendant races
> around manipulation of the raw_hwp list by holding the hugetlb_lock,
> which is also held by the hugetlb code when freeing hugetlb folios.
> 
> Fixes: ac5fcde0a96a ("mm, hwpoison: make unpoison aware of raw error info in hwpoisoned hugepage")
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Jane Chu <jane.chu@oracle.com>
> ---
>  include/linux/hugetlb.h | 19 +++++++++++++++++++
>  mm/memory-failure.c     |  6 +++++-
>  2 files changed, 24 insertions(+), 1 deletion(-)

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

