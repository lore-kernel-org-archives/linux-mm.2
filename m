Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDBCCC5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 07:25:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C36AF6B008A; Thu, 20 Aug 2026 03:25:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBFFB6B008C; Thu, 20 Aug 2026 03:25:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A87406B0092; Thu, 20 Aug 2026 03:25:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7FFBD6B008A
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 03:25:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E0DCAA3436
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:25:33 +0000 (UTC)
X-FDA: 85120812546.09.7F82881
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf10.hostedemail.com (Postfix) with ESMTP id 16923C0002
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:25:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=GCbbos1z;
	spf=pass (imf10.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787210731;
	b=5GhKbV4EC60Ijxsp+3k6oLON5/q4cxaSXmR18a9GyQCqTUIlHGqdWyju0cAQZELpswILMM
	8UDL+JHf6JpEokIHM1/rUCk9Y8fpF6qIk616w1lk+w4kdRZwbXxrVfvqHDJkMCobS7tLap
	yFlnesKhWkW5DC9OmOIA5As8wh+3t4s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=GCbbos1z;
	spf=pass (imf10.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787210731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0aS8nJQuIv6WMeImqkSlMoHWqr3+monhbt6PSzVNU1o=;
	b=Y9kSIN0hNWIUs6uRTJUjR3zn0wBZ5gPBZ9QOoDtN5bN1cu48DAyH1MLwLuQ1zTR9j0jJOI
	kEA+CkF/gmVm4zfjCu9QZkdtTiYX8dlaEBhXy/eoYb7LLpu+TyP88P+cwYHp6LmKfeqZ/y
	MPgJmmh+QwQjXtcr0YkcS51xb5cj0I8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=0aS8nJQuIv6WMeImqkSlMoHWqr3+monhbt6PSzVNU1o=;
	b=GCbbos1zv5wzpHRtr03X6Nnbm9Ni29G7TcsC/96HDOiOFkhywpm7If5MfQDqbM
	n/GlAMXZoNxKvhDo0n0c9CLWZcOwkLbG72iayXOOOHpdt1stp9q+kgePKbij1KJJ
	IQcTi9RsxL6CGr2mS9WYTEPUZJSvBmrZl/8sGlB+tGbYk=
Received: from [198.18.0.1] (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgDXnzrVq4ZqKaNENQ--.9035S2;
	Thu, 20 Aug 2026 15:25:11 +0800 (CST)
Message-ID: <4efb053e-a4c5-4fb2-9a95-f7ad70ff963c@163.com>
Date: Thu, 20 Aug 2026 15:25:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/hugetlb: do not dissolve gigantic pages without
 runtime support
To: "David Hildenbrand (Arm)" <david@kernel.org>, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org
Cc: mike.kravetz@oracle.com, mhocko@suse.com, linmiaohe@huawei.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Longlong Xia <xialonglong@kylinos.cn>
References: <20260817162039.1511838-1-xialonglong2025@163.com>
 <206cb1f2-b66c-4b7b-b0ad-14cca9d8e0bd@kernel.org>
From: Longlong Xia <xialonglong2025@163.com>
In-Reply-To: <206cb1f2-b66c-4b7b-b0ad-14cca9d8e0bd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgDXnzrVq4ZqKaNENQ--.9035S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WFW5JF1fXr45Zr1rGr4xCrg_yoW8Wry8pF
	WUWws5Ka10qa42yrs7Kr1DJry5AryfZ34jv3yaqFy3AF1fJw13KFyjgr1jgayFkrs5Ga15
	GF4DG39rX3WvqaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U3UUbUUUUU=
X-Originating-IP: [61.171.229.236]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC9xdcVWqGq9cj9wAA3t
X-Rspamd-Queue-Id: 16923C0002
X-Rspam-User: 
X-Stat-Signature: wygfcqpikpo77new8bxnfr6tni5gwq4u
X-Rspamd-Server: rspam06
X-HE-Tag: 1787210730-746756
X-HE-Meta: U2FsdGVkX1/RuIxP+BFRwnPwBKfSVoNQtPZBEvLkM9aP/GRYYVGqFsip8rOgGB1HJ4a1O4AbUxbHVOM0mFiv13+PsI0UTpUOSosqwPRm1kGlOa/0g2dCkOYPeE9fnnaByOVjxWzAUpA/D5MkJiGdlCY9TT7XxfNIbGfzcvMpSR74Fitom5TWDhSvgfi/XnZ6NunHZwtzkpTqrm35zP2IzyvLTVATgDKDcrcROL+9UNdtbDVgg59kpZjQkkmNyLnm20kOBEXtNF2CqLxZwZh/vn7/kjdVpH2lEIJEYgU7aWIBKdg68b7l6hEj7e4TJ1gwYq08+bfDBXUzDAI39ZzYWBTf9hcQ/Xk1PkmriwWVXzA7MenvVQIa9rTK1t9kBvKBpVzlxLvwkfgsuPoUWCe4IZskMVeknd9Zg1NDZVt9NSxKsiQYAWDtUs0wtojwaoqf2dS4w0+/79Y38+FWcWldfb63Yt8OoU0ArpHvnFdLI6VyySJ5riDfBkZ9/5fI8E7cxR9IWYUe6VaGm4vMbiAn/EOWxr+XXeoxE8y9AseHl8g7aAMCZmIXaqsMc8twT/IQducXAa/tdkusOA4KmKZsaNj7hXYIMzwBzvqklEJZyhae2U9ADdKDChVUSxLHhnTsferCdPFJc8t/6hiT0XqcaxA2stZzDCqk8yii2eF5TF4U/wohOokxB4VZu1/pUfsp+FDaVSokeNR9fCovo2DRr36DKhLKXnqTASO8aU2ZkTYB7kM+TOhZl6iyh4ozawvhei+RAmZ5YjUa8u10gXby+c1pgKGWvjUADp3dAUpS4Bjm/8oyugbWjzApZQjL3LARK9WjsfHPn35GdwQ8ytKH/22/22sja9qsn/8YdtCq0PSy3RVr9ZNMRuIFBn3dodu+umEgwBWQASy5WTeWIUtwbmSHASo8ijKgVwSNJAKeMHc/7lO4HoRRscV+0btfEQKahe5fd/DoNRw1nHrlDvp
 gr2dF7eb
 LHtRagF7XmdJRvI0kj3FzqF+XwTNh02H/p+Yp8TQGj/vwj8pW/g/5969ry67VnAEcanjJkMSx/Z0xmtp5J1Hti4OK5Hky+Abs7+Z4LEexuY56dhewHfiOLNYPdRYwNaw4mwqBTEjF2f2H2vC993QyVIyip5S3Sap9IYIrTH2jv7zeqaoYe3JXknlP2Vu0xZFMOoUbLfCl32R5hB/VLQp6vmqLyOzevI2zm/ZZC5A3At9+M3r5LvkAuyMfWNAg9kOyd2pWVodMuC6GMF1BCuPjgDeTo+IvurPaXFPC6ZmgpdFzlHy6OzInYsToQXgZU/3J7x5XMhqDJ9E4al2aKfoWuhMoJQcebqTLa53uSdywjMyjKxvOVqM4GyhiFO5R6mna/OIe6rnkWXsGJxGC7RkIWlQKf6VtBUjnVT4W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/8/19 16:52, David Hildenbrand (Arm) 写道:
> On 8/17/26 18:20, Longlong Xia wrote:
>> From: Longlong Xia <xialonglong@kylinos.cn>
>>
>> dissolve_free_hugetlb_folio() doesn't check hstate_is_gigantic_no_runtime(h)
>> though remove_hugetlb_folio()/update_and_free_hugetlb_folio() silently
>> bail for such folios
> That's odd. Why do they silently skip such folios instead of warning that
> something unexpected is happening?
>
> This screams for a cleanup unless I am missing something :)
Because until this patch, dissolve_free_hugetlb_folio() was the one caller
that didn't filter hstate_is_gigantic_no_runtime() upstream. A WARN
would have fired on a real path: hotplug or hwpoison dissolving
a boot gigantic page on a no-runtime arch. So it had to stay silent.


This patch guards that last caller. The rest either check
hstate_is_gigantic_no_runtime() before calling, or operate on folios that
can't be gigantic_no_runtime (surplus/temporary gigantic folios aren't
created once alloc_gigantic_frozen_folio() returns NULL).

With the gap closed the bail can become a VM_WARN_ON_ONCE:

   // mm/hugetlb.c:1401  remove_hugetlb_folio
   if (hstate_is_gigantic_no_runtime(h)) {
+       /* Callers must filter gigantic_no_runtime upstream. */
+       VM_WARN_ON_ONCE(1);
         return;
   }

   // mm/hugetlb.c:1463  __update_and_free_hugetlb_folio
   if (hstate_is_gigantic_no_runtime(h)) {
+       /* Callers must filter gigantic_no_runtime upstream. */
+       VM_WARN_ON_ONCE(1);
         return;
   }

Separate follow-up, or fold into a v2 of this patch?

Thanks,

Longlong


