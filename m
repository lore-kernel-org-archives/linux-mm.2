Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDA90C79F80
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 06:37:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D294A6B008C; Fri,  4 Sep 2026 02:37:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDA666B0092; Fri,  4 Sep 2026 02:37:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF1776B0095; Fri,  4 Sep 2026 02:37:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9EFB56B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:37:25 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3E54C140755
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:37:25 +0000 (UTC)
X-FDA: 85175123250.25.85C2C4D
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3E98518000C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:37:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=YEtxI0FR;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788503843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LWLs0SHkrM24MSInQ2XpsIeq1uN6XlQiC8ArRKGi6VU=;
	b=NTmscSVr3C3kbSowE5U88eLZxim9rKdig5MXZk4EEs3P7mNlJzHcZpyP0R2WguXNE+0kyC
	gZfnshKk6cOvw1/0KFW4gM0MVBbsOByJ5LbRA/Du5J5JKERs+4dxTRCa2ygUTg6SY+ZP0l
	u6P73FD3Z45+SYUwtInfj+RRJw9peY8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=YEtxI0FR;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788503843;
	b=jdYhHshD7ognxtN1ABJQNiSQLHDOOhei3wXFjlcTyBEg1yGvPZXxn1XthWJQ9D9ZyS4u85
	3GgPWSyk1wOtmsrc0TcqNfC1PbuFXUWA4m0QO8wIjVHChKMtF6YdRr7p61UdIk7NYQy8Kc
	evxyV4efxC3uerfKzjNJzG4HxX+SZxs=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=LWLs0SHkrM24MSInQ2XpsIeq1uN6XlQiC8ArRKGi6VU=;
	b=YEtxI0FRow7IvcmxoAJBY+ae55mUabDb/bjKQgeX9SS7QQ+8nfXAva973oSdhRtKxwQYZTtDj
	utiknF5qkpjoK4A8MV8LYD1sQzyp6engTnsbd6jrwFXKN5N+dLXDlaKZYUmSX/WSyLp3qpmKbMF
	jmVGXE5qkc4hBMnG5NPOM6c=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hbmgf3nTdznTVx;
	Fri,  4 Sep 2026 14:26:06 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 9A03140572;
	Fri,  4 Sep 2026 14:37:18 +0800 (CST)
Received: from [10.173.124.160] (10.173.124.160) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 4 Sep 2026 14:37:16 +0800
Subject: Re: [PATCH v9 10/15] mm: Check individual hugetlb pages for poison
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
CC: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	<linux-fsdevel@vger.kernel.org>, Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>, "Gregory Price (Meta)" <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>, Jane Chu <jane.chu@oracle.com>,
	<linux-mm@kvack.org>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-11-willy@infradead.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <0ca31092-bfc1-af3d-a588-bb6bb7d5d9d8@huawei.com>
Date: Fri, 4 Sep 2026 14:37:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260805210557.1118966-11-willy@infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Stat-Signature: enaqj4exaus8itm1kidjbyxh3o68angu
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3E98518000C
X-Rspam-User: 
X-HE-Tag: 1788503842-225172
X-HE-Meta: U2FsdGVkX1+XyZd253p5cXXSJfOOKAqNJKzkPbzW6Snv5vKT+gWTM6WojpI4Sg0k+2uysfgb9MMVcy5ekfaR5JsmlM2lFVjWb+GIeEydJg2oplCcMWleo9Rh8cwi3tV8r5vnuU0XVXOnj4kgD1vPD/2M7WcJ7CaEELEMlfwKq7VLTO42E4TqrZxl/0X61P4080xjfOVj2Tlx1IlQGDHctM/5e0ldmffUjaxX4/QCb84bIT2Oepkdq4VIeSoN7q6vSraaelMdKe2+OYqLt84MmbqcEq7wXbcLYTP6GCCNUsLGBkbM11P3G4HOEEt8q3LtOJaPPjZ2fsomRHvzJVKOrW+8u88omADNz2gLXSNMananeUGLvi5hygGDcxSz9B6FBTtsSGLS1ZlFxSrbTKdNMSk93bhDWRVsvudDH1O6vKOZwhf45bJv+G+v4fqW2MqcyHV8iZ4zU/ssYmGmIGDf+D+W3GxQ5y/QpAeyQoHkTg9QNcFX29ygqss+0lNkOcIgXOr8VxnQXFjjm8cO32uVoGTY5FoiqvDpZR8MihpeHQWVr/wnfWOc2U6C2U1KKZhcLAU8Y8KACYWpV0R83JfY1gDAa+H072Td39w/vvZIXHVEnuBf88iRsGt5Qz0OkDXIqSvnMjRwylbD4+vq+AHvtg0sGkb1ijDRhFmWD3QQnYKM+NOb10tVHHM8mOo/dh4dMm0xH++LqNelNiGR+G3vfcRqE11wtdU3nKJ1ztEVWCDm8LTkNwmJPM4vcrTwhcRcG4QLMv3qy0EoBYT+RQweLc3MB1ptOhjI9RYb+ak8t9QGpmxeZaWJjCa5kC7AotAxtQ1SK735i75uhRDeFM87i/tWjHftZ/njAI/rSSbNkpT9eNc8ARlIygekHwYH7NmYweWZ77mybgY6Op3W26OGJLjDwBeeFSJU2Wc0kfgIMMPYgUy+GCss6z1Z3DsXDym8FnZvpsulCsRAR8KOFUh
 FeSXakmZ
 56dhl2L3XGf2bHrRQdqu+t/UkJW1PIKBa0XIxKLW0OujZED6JNiXab4wsX2r3mW7A/GmcRbC2dARdRzydUWCwoiWv3iTT8SYyurMzjNdlShIJemUiu+Ix9mNmMWjl78BAR3BwvhDb7ZceepSUbtHbw/iKHlgcLIjkYjY/BWUCaSzNS/E8weiCSYEMAFLpTxXHM8gi3E4BJs/8mSSjzw7bpvkE3i7OFyPid74ZYjhlNLiFoK5eUhUWkecMFqOorPpZMlq20BoGprOhx4B0Rf0q1xKQN9X8t/G2YYUnAUCc0pNV8deJUODXGQrUMgr4DbIjiWUB5yEEO0l5cQfQy4AUmwIQzGkYU6MSi8OLmaHuzEY1JyLLAIoa5ZQG5Z63RyKmbgN5d8JYu+gMSSxYj5OFNlr7MAP4sU+GqqwO0C8WKB5mtr9M6ayoxr/NJanjv26lakvT0bKdHxU2O/PUQ8GDFoBeFuNcino0D9Jjq49HYMyFZlwTQ2s06LMsYnu+HgX6EHNgDXapNNKHL8yeYcklzc6dDivR13kq4cq4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/8/6 5:05, Matthew Wilcox (Oracle) wrote:
> So far, is_page_hwpoison() has returned true for the entire poisoned
> hugetlb folio, but we can usually allow access to the pages which
> aren't poisoned.  It's slightly tricky due to not having a reference
> to the folio, but the hugetlb lock can save us here.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Jane Chu <jane.chu@oracle.com>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  include/linux/page-flags.h |  4 +++-
>  mm/memory-failure.c        | 43 +++++++++++++++++++++++++++++++-------
>  2 files changed, 39 insertions(+), 8 deletions(-)

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

