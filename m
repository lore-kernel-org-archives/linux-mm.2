Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4E48C55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 11:40:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB4296B0095; Thu, 30 Jul 2026 07:40:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D649D6B0096; Thu, 30 Jul 2026 07:40:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA2526B0098; Thu, 30 Jul 2026 07:40:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A93916B0095
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:40:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 570F91C0014
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:40:44 +0000 (UTC)
X-FDA: 85045250808.05.DA76D31
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6D1E616000C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:40:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=AwO3qBz2;
	spf=pass (imf08.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785411642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MR/BR2k1/LO34RHmGOvBqb2jzfFxevkLWrRtbLLGJa0=;
	b=tK3n2hqUDZoVLX+T0aPaCIxFxauxbpdvdhTdd7A1B8bTFdHdlgFLaaI1WLzHWjK83MU8km
	NMxpNxo9KRfFwM9EZfaETq6TNnhvyn3PkTV0WgneizFp7GlN4NdDcwXE1ov1q5kJ6a1urM
	uZZjCCgu9UsfFh4OaOUf69XN0yjAXcI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=AwO3qBz2;
	spf=pass (imf08.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785411642;
	b=sbGbOdVufGFVTSEwlakvlFoc6CuhEJ01qA/VNtQfk7Sjs5b69BvBAjrj5fbPZLHxNp62Zp
	45MOdlOLHqPl1KElIpgJ3J3D5ADKnT+m4pucwAvF9GU/1U1to/ZGXjWE4oBg8aROjn+bk/
	LL4aEYI1OpGomT+SaEOtA4Xn8dZYD6M=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=MR/BR2k1/LO34RHmGOvBqb2jzfFxevkLWrRtbLLGJa0=;
	b=AwO3qBz2tS38UtUlQJmB4nDKxPeo9EYut46MUmvJ0ihEAQ20O286IgZRMp9gzdCuj16jGr7wp
	afQV2kAbrv0YfdnMNpEQIyq2Xr6OhDdPHXh50Ky5HhwjbGcQ8sYfLfcJfiT4A9TU7cJBGRe8UVU
	z4dG4dpLbfirNVYHXB3jIs0=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4h9n8G0n8PzLlX5;
	Thu, 30 Jul 2026 19:31:10 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id C913740586;
	Thu, 30 Jul 2026 19:40:37 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 30 Jul 2026 19:40:37 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 30 Jul 2026 19:40:36 +0800
Subject: Re: [PATCH v7 05/13] hugetlb: Move poison to pages before clearing
 hugetlb page type
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
CC: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	<linux-fsdevel@vger.kernel.org>, Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>, Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, <linux-mm@kvack.org>
References: <20260728204409.3396238-1-willy@infradead.org>
 <20260728204409.3396238-6-willy@infradead.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <ff9f5060-347c-c18d-0bdb-ad1b90e704e7@huawei.com>
Date: Thu, 30 Jul 2026 19:40:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260728204409.3396238-6-willy@infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: 6D1E616000C
X-Rspam-User: 
X-Stat-Signature: mjubih7yy56wf34pufn8j4quk9phn6hc
X-Rspamd-Server: rspam04
X-HE-Tag: 1785411641-58227
X-HE-Meta: U2FsdGVkX19mMZgjtoCTtIkyPM0gZy0pXIqsqWgPdSYHFJcI9A9XLLimi+6LJd84wrufwkCZhlUZlEP7WFzTZf1RZOHwnvKXyRrn4LWt5jTzEZH9vIDHd+76qYbTJ3IRXyY1ZlEoqnZeouIx38jDKXQBJwPzAu3PZjSsM69Rx5n9Q/38jG8cZc4Lw/bwjqFT5zFRg/ybaVIQ+snnjVkn1TWzyAKMGvjUZo0KEOd+IW0+LUNzdICw1VE24N1GL4V6tD8DnKxxroOtFeghyl2/p6g7RgwEIYamKeGHpWgcJL2GV0HnqdICEb8wNFTT6jjn1aZSb0xtxxtY20lbEA/MU5nrIbJiB4sgzI8K4BYKitzKYEMSxZ8tUaDorXZim213ccPgQJ9AQZVL4ADJvBT9WcE9g6iY2OuSeuRyGQBTpo2Idnd8icEH/ffQBzxwjRWxdoirD7VbS/Af1NamXTq3FOODEkKe83e1xw+gwLz1Hib82JtdL8B3Pj+ZQRKbhA+8PF4xGK7Cn0kRr8T/4/2zC8eKpsYA97d6gfhSQdBU5JLX0wspgHokWvISGoOt5gu5n68/vvxu/z7EYTB+Jz/M2pRzMhPC9v+D04pluXWhg17n5vxFVo6WrBuoSEILof10mMEshDPhxEMZi/pVWCrxioVQtax5+vtFT5Qe1oQPCc3Ji4IRxWUu77q1gWPzm4Gn4ZhIpLlMnGny7MvpAz8/08Iu1P5YMNg1ehjbGKWYqmfHuXgvTCdkFo5wfshK3zOi1y1meYXsBcEC+j1cMNf9fI+cPc5CZMktIttgkWSEIJvy5kX66ZQjnoSy4YETiBdbM9ewP+ut5/vY3kudANeZHMPjuO7IefmyioPzbCjNiwuTMe7tvSsuZJjmJR6xbim8VhDu8nw2Ia3YiZ4ovS3kN/oRMoy1l02XkCv1fz4V3oUIMBKap/CZf+Lrs/B+Cj6CLbzvUKHOkXncvjno3uI
 13Nk6DvO
 VzqA88VbbdIzKHjZ8r+ZRPBopd0L6WvGLLlHHnSevwDoARIWCOv3GS6lttL3q4wGE5q3/eQQU7LNTJhvQ6hX/LqHdh/XRthkf+Vh5U1FOBDpyLhFmcCLJKJZMCjK4ZYV7y5bDIAOjvxnbiCvS7NPdkBPUwzC6MYcPgoNuGgnFUMUiztZ6Pa1eO8aFUM7Qrjh0KF17WI9ymk+NsYGJZpdonkVI/tqx+925JsbiXa6IxdBwg4ko1pYhg2nOeDXeZRa5hmDUrhyKIOeScZAnz5V8USdDJsCEvO9/Rf2bZ95B69KwxIPNuJUhAtL7jJuFW91bRaPIQRAPpnLAOBmPCvUkWpEipqpPFiapq3+x8hF/KKgZPttNGD1DZ9NsOQzr4ALgKDa0qzARiR3CepVj7bGouFfU8GubpLydmqj4wva4AzfBmjnYwMaJZXmtsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/7/29 4:43, Matthew Wilcox (Oracle) wrote:
> For is_page_hwpoison() to be reliable, we need to set the hwpoison
> flag on each page before clearing the hugetlb flag.  Introduce
> folio_clear_hugetlb() to make this easier.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.


