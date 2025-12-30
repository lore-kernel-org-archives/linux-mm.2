Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10B5FEE4997
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 18:17:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 765446B0088; Tue, 30 Dec 2025 13:17:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E4E86B0089; Tue, 30 Dec 2025 13:17:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F5166B008A; Tue, 30 Dec 2025 13:17:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 503706B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 13:17:11 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DB3C91402B7
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 18:17:10 +0000 (UTC)
X-FDA: 84276944220.09.0898000
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2B33FC0011
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 18:17:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Cltr9Pqt;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767118629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5zKXF7fKWMXbJUfjN8FDrekFqEhVp25U+n1Pt79ip3c=;
	b=QsvD+2bqRZAj/ChNfUp3tWAH02A19UWhEycg8h4rn/m5r52KoUsii1SEDtjWqwkzN33J5l
	9t9T6lc1UbD34+pFOZAmEOL5GcSdgvxFM/HmI0yRm7Bo3bKJ6m9PZvcPJCVdd6EZHLaiAk
	98hVg/hng2iXmJKRInK+Tdt+GxZ9Wd4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Cltr9Pqt;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767118629; a=rsa-sha256;
	cv=none;
	b=ps/R/X/8fJ5f18IbXT+/BJm41hdv66bngKaJqlJWgdZyBEV8a3adkuw8CQdqhPAt/vOGt/
	uMwKNbon2YI7oBSLvTZ36mF+RclOP6ze7CbUaXmZRG96emmbATiOuaRl70iEsQxPsVjtcx
	h/cKCUSVmpG7lg11DMVVq0bUWh1XUOI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C5F941B2A;
	Tue, 30 Dec 2025 18:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE4FC4CEFB;
	Tue, 30 Dec 2025 18:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767118627;
	bh=5zKXF7fKWMXbJUfjN8FDrekFqEhVp25U+n1Pt79ip3c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Cltr9Pqto7qf8194bUvhPFxxylcqpwCauZOjPvRj4eCUGBretoQ7dl1xlY1YWwrf7
	 wHHQOSTVdC5MkE+QKhNB6DRnhN3UaJpURt7nIT/qASeHzIdhQ3A4t5O2B9We4H7I3b
	 xepxUXTZV8RpimURMAmUFZ4tAsUDri7lZnACEBTQ=
Date: Tue, 30 Dec 2025 10:17:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>, Oscar Salvador
 <osalvador@suse.de>, Muchun Song <muchun.song@linux.dev>,
 <linux-mm@kvack.org>, <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>,
 Zi Yan <ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
 <willy@infradead.org>
Subject: Re: [PATCH v5 mm-new 0/6] mm: hugetlb: allocate frozen gigantic
 folio
Message-Id: <20251230101706.a56d0f06584bc10e1343007a@linux-foundation.org>
In-Reply-To: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
References: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2B33FC0011
X-Stat-Signature: yi8rtimucanck1b1c1ywgonp4fkmfp8m
X-HE-Tag: 1767118628-164859
X-HE-Meta: U2FsdGVkX1+yA28YpOoONBfH0gLykMfhOh/uIC56GlKagK741gcYU4MDx1m7UP/e1Jr2uQ8ESXPxg66gPuBApjRWe4hN0a1X97QHNjnSPO7pRiA0iWCCvuac5Y4WHewqOZHnVMKsJ3E8hj4JolY1JdBEM0r6agcuXSQPCLcsEbYF597XIQU0uWIcvFA3K55oIDc0hdUzxXKPxfvKJbRXMtfmFFzXU1DhfSrNVQU/MQP8w60ElPG9vz3Jc98En9NeF4lZZveKOq5hQr3TNUwai/dpPYX8d1WeEI5pLxrauHWUqQVs+JI0sxabAPGzYLbtvO5PN08J3QaGZCIfkeNJzTOM5F2uj9x0lxpe37ZqUhH+hdm+1SV5HO14qjsaDHRJVs4eQSJDbyVyIrWPXaWrxVJh67w2IQNOajSFDTDdyg0lVpUPGNtzT3P/ZbCeP0W+bAHlqPChYNGOXnqxNZoZkaBSNUalnzZNi+yY+cLmPyO+P+5rk0JdUKTMfqtDYjMrTi6tvkVTWlc2JtDtAjqYziw2cqbVj65/Xw03NXj9lCev3ElcpapKoUYFFumQRg1d+OgKexsQDEEM48wJnSIXuf/R549uqfXTwncqAEVbxv3/JcEQSuF5LEvHUCrKviSm15T3GhlRfcUBww54LR27OlVnzleBFpvnJ9dpW28Gk3RjEXm0y1X58Q+8tV+7UIXwPYnES7QqkVGgLgxlNXRmsLfl+lQa/5XMssDLUuA7PEGALAyi57AyaibW1zFZfsLb+TYfHV5Wz9jSM98YDTTTuQ/csD6HEG6LvZco/3xbEkcUMUnGMTLlUUKQqwcLvRZb9uIZXHsb8QM0+aocaczGJkS0cGUVWNB5r1G7Z6Kr8nCPDppFTsaYfajw1i8d8+0T20yuT4ZA1Ap/Je6D1RbrI9Mnc6P7/G1tR6xGoNXMy3hulMSvirjYrOKfj5NyyZ5rqxc4iuVPxSXVrAXDMsT
 qI7/cLxI
 rEPG7uodNGjgsoBTwzMnpNgqr0XyijEAxc9sWSW672UckfMfnp9VXlZMrxECcCNVU0ezte6G3QU0NQlWaggwxoFNgpeSSWJak0jua0dt8x8kOSK1yiJlylYSqfpO5m0HeCtrtw8EIu8uds+K0XtguCibQy01tlZJSr5N9SYZdb6qo6llRvWbXgYbkOH+8e8GILAkviyubajE4bvaP7qqI2Qf7M0RPe3Q6LeZdAzusyNtFpqlBpRgjkEsMzwpuo+G10FOW7DsWAOxH5qEpza1SqQ7n2NG0H83Thf7ENThMWZmbA20=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Dec 2025 15:24:16 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:

> Introduce alloc_contig_frozen_pages() and cma_alloc_frozen_compound()
> which avoid atomic operation about page refcount, and then convert to
> allocate frozen gigantic folio by the new helpers in hugetlb to cleanup
> the alloc_gigantic_folio().

Thanks, I queued this for testing along with a note that review input
on patches 4, 5 and 6 is desired.

