Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 934CDCD4F3C
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 03:12:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E06D6B008A; Thu, 14 May 2026 23:12:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9918D6B008C; Thu, 14 May 2026 23:12:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CE0C6B0092; Thu, 14 May 2026 23:12:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7ED0F6B008A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 23:12:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1B8491C06DA
	for <linux-mm@kvack.org>; Fri, 15 May 2026 03:12:03 +0000 (UTC)
X-FDA: 84768180126.03.CD65569
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf08.hostedemail.com (Postfix) with ESMTP id A46C2160006
	for <linux-mm@kvack.org>; Fri, 15 May 2026 03:12:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=CaZ7+99x;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778814721; a=rsa-sha256;
	cv=none;
	b=O07tk1sWWn15moa69/TYqsxtdJuMqohDQ5P12hv2ksIbCqqJ23AQFHB6duhcwHTTnBfL7i
	tliGkbCkdM6x0QOL3v1keXEI6mK7RMJm2DkvoxhakZPO7JpYhu4HdifvLGfhwU6HpfhMoo
	wfSp+QxpOxMQknJe/5+B0N8tZ653ePQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=CaZ7+99x;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778814721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iDAP5qswLMAaL3iKA7iN482knbgPKbvSgtEV4A3UGvE=;
	b=hb3l5b0Pc6YTc/OJn9qIlZxaXLNfXYKrysfAWYUY+gUQYgl4mNfCWa6UcfREyUQpbtu8JM
	FnYri8P0EVepAO8Y6LJq9F7Pz2o8o97jKCPjXP1o2wQCyONRKH4Zs8flO4bihaemiRhuJQ
	hEQ5QJzvx6Cz0Oj1CfNlBwZFEYfTwsE=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=iDAP5qswLMAaL3iKA7iN482knbgPKbvSgtEV4A3UGvE=;
	b=CaZ7+99xUY4qYsSV0/JrKh4GX817rgqyfLviq9bz9wEqB7Sdamk9fDe5nlNC9Bo6p5v9lZ3/2
	9LOQpxtkbNXGeplN/UjKHBNpFDgYgbwDn3AtBYAnQEVCjeUXe8mf49F/lsXBsIJeQ+XlURy/ppQ
	MOKzPlvQd9VJzw48hFExblk=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4gGsW73fq8zpTK1;
	Fri, 15 May 2026 11:04:51 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id E687C4048F;
	Fri, 15 May 2026 11:11:55 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 15 May 2026 11:11:55 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 15 May 2026 11:11:55 +0800
Subject: Re: [PATCH v2] mm/memory-failure: remove hugetlb output parameter
 from try_memory_failure_hugetlb()
To: Ye Liu <ye.liu@linux.dev>
CC: Ye Liu <liuye@kylinos.cn>, Oscar Salvador <osalvador@suse.de>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
References: <20260515020144.164941-1-ye.liu@linux.dev>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <1ee68dcc-41d0-1606-64e0-e071634ec64b@huawei.com>
Date: Fri, 15 May 2026 11:11:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260515020144.164941-1-ye.liu@linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: hg9u3aceu78baembihw7bi1gokipjbbu
X-Rspam-User: 
X-Rspamd-Queue-Id: A46C2160006
X-Rspamd-Server: rspam07
X-HE-Tag: 1778814720-382979
X-HE-Meta: U2FsdGVkX1/579POdxcgLqdnuDo87fGcYfPmb37A0urLJ7JgrKmI5/6oCZpT79WZ4F6U7osZpWivDJjsFGjLZfj1aVDpVzBG/+AbV3BwvIA9eDQW6SrI7zGOBhd98O6VlTEwtr1xeKix/t0rU8dptYehngGcRBvgg7a6l6RrX9SQ+pMCgGnChhGUXEbJ0YyHRkB08U4EqiF1jRYSZE5f/w6v+WCd+XL1dvwTyhzpHjxBuuSpE8YBFo1kZP1V+9E/nG8cRpKs67VAxvBbtMlRCZrKzkvoiUaqeimCHJNiGSvveY/IhqbuKFPHT3hz9Tu2E1QTPpLDD9q05kyrWkO5R5bfAamZRKpx4f5Dljf5t3RlT8fNAL8GxK5FegjpJQ8JE/L8AhcE0PUtn0hgyCQDCAodqZ8UZgORRK5K7cfu1vs8oBmXU6Bz6EGZQuEJuXTcB3NHaHXF8WlDz+hefhuXY0h7OSUBakOv+i3N9D8g7Y4LaN5uInB/O7hibG1IYRQydBQxO4hx9fmJqQDoUgsgNA0QG6bDQnQ/nK0GK9GQoD6YyZmXLha3PByDSEP6yMBoLK7p4Jc9o0fxQoV+Pd+oM4fMWV8xap32ZOE4QODMOQKQaugwpXGNle8wkUt4uDD6eL41AleZgtBhA+QFApk4FS+o92Y+KBtHb3v/JiIRyshViuBVorQuQY7Tm61qy2br3+trMTqzNd/qrIEu4BIkoaX3QyMlplEgEyHBKllvPAaIONAu3Xtr1XdWX3/1gOFu4gS2r1dwkzdY9TKGeaL7UDE0Bo493aanTE2XCoODtZxwcKjHDjZ2KKYOVdOofjnuJhdji0u0QTAwBrQV7nEviGX1RR+1V2gsm+vTXA/sgJGkcvPkn60My9TKs0s+6kV49pXnKeZY2B5hPotNwlB24jZvnrJewQWED+9fUTw2TVAy89DA2BEp5PTt8j4A+h6Bx6zINW/1qxrbE2RvAAB
 H2trylKm
 FdLBcxAorUsZNkmk1+tML3PXYb5x0NNay3UAea4+AfhorllAH95RZfbQPTSlnLYXd3EhjDHrDMEjVMbhDhZYTWT8RuhKEDcQFzzi2KXInrNq/tn1tBl40lDTI7pSRUeDzt8n9zzXlzDnQfkMME5YBXVie2tPtU8ZW+KbbgKtZxTBxFBk5F+FC/UVeZBU4ervPIpZuGYf4gPS6sNzDTDsuWdGnZf7bd5zEMvLVZ+9KIkmdt9Nj5E3tgz8MR94NuvSbBt/VpoKcyM8DL4WmY7s5IJACjhMnYw0x20XG/8l/Dm88C1iUjL1k2YjJLoL7BIu19s3hBa+bWHxHHKbgduuetVGPAaL04P59gBeSfKP7RMQCv27sr/rp9IVOdc5LvM917PCosfV97zyEb6rpVfOZNqZloIdF/oIeYFdsSzhnKp68xZ2vGDDOk8bBuyv5UehC3zgycz22clTJwA0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/5/15 10:01, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Use -ENOENT return value to distinguish "not a hugetlb page" from
> "hugetlb handled", instead of carrying an extra output parameter.
> 
> Suggested-by: Oscar Salvador <osalvador@suse.de>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>

Thanks for your cleanup.

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

