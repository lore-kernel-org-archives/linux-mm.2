Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F413BC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 18:24:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7F3A6B00A8; Wed,  1 Jul 2026 14:24:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A30196B00A9; Wed,  1 Jul 2026 14:24:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91FC46B00AB; Wed,  1 Jul 2026 14:24:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E2706B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:24:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E33B7140468
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 18:24:29 +0000 (UTC)
X-FDA: 84941033058.08.B6ECDB5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 372E0C0002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 18:24:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vKeuLLIB;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782930268;
	b=FR6jSo4zKBtteu5w/IGl/lz0cvjnKAk3UGNNf7+Hbx55dtuxdQBVRDZDnalEc4gkIp8y3b
	DJBdlIWaG6MVPjJ8vEGi3+vrMuklRIU9YTPcg4lsxz0LBK1giK93GS9AmCU55u6KAfZjG0
	Qulgq1nwGHD3lTdXjQqlgsK4tkeSzbQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782930268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0nplHAzewLFGw01ADbGFb7toUr2E4XH9Jn7R3QO/etM=;
	b=S/Z1d2+V09aCD3Rb7KQl/o7P2f1p1EntXjrBSpIlyqYRVgognlnP/RyA5hoyc15GmJkq85
	aehmCKHK2gfuOi5dJVou3L+nbOOEe/nQuc9QTHRwGksK7gY3BW42vdhQ4itrLf75mzOQSy
	noFHewi2gZ8Sy2JQw6WxmjAEeTw6bG8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vKeuLLIB;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D76A43479;
	Wed,  1 Jul 2026 18:24:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20211F000E9;
	Wed,  1 Jul 2026 18:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782930266;
	bh=0nplHAzewLFGw01ADbGFb7toUr2E4XH9Jn7R3QO/etM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=vKeuLLIBmHGOfXbUtuzNxtIYFr2U2a8UPR1jbyfUuY/5b4R8cRnJqVAKN3d1KXwAr
	 jzK7/SKZPNTjcT5jAf/wg/vwmnf+d+Y3S7QF86P8O+IcR3Jj4BkRAj5OfHsBaCwADx
	 aI0OaYa7KxniN1HFwyIEDFyVcIaJrmHL0dlcBf0c=
Date: Wed, 1 Jul 2026 11:24:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <linux-mm@kvack.org>, "Liam R. Howlett" <liam@infradead.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, David Hildenbrand
 <david@kernel.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH mm-new 0/5] mm: mincore: reduce lock contention and misc
 cleanups
Message-Id: <20260701112426.e2bf5b892eedaaee3d0ac36b@linux-foundation.org>
In-Reply-To: <20260701144047.3786939-1-wangkefeng.wang@huawei.com>
References: <20260701144047.3786939-1-wangkefeng.wang@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: csegspuiwbcw3nzq8rcfbxfqsm8itxi3
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 372E0C0002
X-HE-Tag: 1782930268-852204
X-HE-Meta: U2FsdGVkX19Qr7T4M76ARqbCk30A6Piyb0fljONODtcT0Fex61cUPQhOrGXxrhf92w7iHQFbDeKpivbMz4cT7CkjIkbN4eG+FTZQmUu6VE84EMRd6BtMQJNt/kLM1os4cjxTbfnurkAwXxcBbtKVnf0zgQtD9XuURo+OQYpMFXJsq39Ew6xvoc0VAsxAwLecJGrLHQPQaV1aPyfypi7T9Tq9XDHBWtYyjCNdfNd6f7b53Zt14wjd7YT7Q1hfK4R0xXWMjkeV8G9SuOTgbnhVWoTuy24d3i4897QOHeXjCFVWoTDyAO941DYnyyfK6GmHspxZKEhsJdz/dWjNWdS6Nrw8DmaRGmo6e2M6sbuO6M+imeKXqHWkw1jjid3X60ZReTPwjKoMzqt+EbWk4iFU0HZYa7T1kbLceN5z6ryMkKd951JBU5ool/0dC0goROEDuLGYTwl4FYj6okadVcZHOIENaemimBj0y4aJ3OGpXnkTVWXeZRcEXW0YsAL3Hd9POHmM1gNgO178pjkOIZR4hAJPEqlM6z4gOfWO+cGZVQq/3R6CK676H9+jKz9BqrFpopZ2IFhATq0YAiKrEdW1w1IA4ydJsf0bB+CtRoELLd2EYIwWubLJsolIqCorYL6nCqnk/bJkWkjD2+EToXaDe13VpJ7uCpfLLNtrby/VShFfCql/3ZbXliZ/qpR5LFpiLjyORgPVfDsyMGzaJt3/95g4svVt5p1gmAAP+rXX0NGQxaNOjk/+aXCQtOTireghCPx5wbg9KDGdTU0zxEK/HIERcim8rIQk9W5wwlFUzphuUQ+bdiyUCQnwnV1ts1Xy6F5Jkt+zIHL8IElMGQigyoJBMrXI//QlCDlljQXIxGpURzCoyrXoIRXhSbZRKaKDs25pTunjLR/Rwqwdc4qtLiQXvuPSTDOOYDuCWcHv1UbfbL94yuZwQbYFErH9RiduQcn+MhRPMngvmo7cAis
 3D8gditV
 Jy8U9SpupR4rdCFExXX7uczaLOIxvujuchBeitIDWWr8nwiYAWE05+qfxbZNIXFESYr5BGBl0BAUxA2yjpIeYOJKgUrLZEZOJV8PpfzSOnFH/UDolGI1CMululLG+oE7BZjFTAGTsVgyZ3W/lZ2FTxGuA/tJXSjgGpdn0vn2U6mqU5pIBVu5rdwXapknTcFE0yZWtt+nNYDMOguPLS5JXY6Ap+Ly7IF0ykLAqYxHiX6b6zlQUhOCl6aNNx2Z1DqjQRSWduHgnIVPz8bn8QUTe2AWPgy2WvMp8AhmwVwdxCOnQkhE70RRVW4DMSzvc9YVcfShdO4Kvi87915HGcz+2daGl2WU1+ENbdKEPqbhgu4L4VF4uv2kdoOYRG5ISR2kdAXQs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 1 Jul 2026 22:40:42 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:

> Kefeng Wang (5):
>   mm: mincore: attempt per-vma lock during page table walk
>   mm: mincore: remove special handing for VM_PFNMAP
>   mm: mincore: replace __get_free_page() with kmalloc()
>   mm: mincore: remove xa_is_value() in mincore_swap()
>   mm: mincore: improve mincore_hugetlb()
> 
>  mm/mincore.c | 96 +++++++++++++++++++++++++---------------------------
>  1 file changed, 47 insertions(+), 49 deletions(-)

That was brief ;)

Thanks, I'll await reviewer input on this series.  AI review said a
couple of things:
	https://sashiko.dev/#/patchset/20260701144047.3786939-1-wangkefeng.wang@huawei.com

