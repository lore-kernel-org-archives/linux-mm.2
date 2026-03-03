Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 515A9E67A69
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 06:09:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A1566B0005; Tue,  3 Mar 2026 01:09:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74EA06B0088; Tue,  3 Mar 2026 01:09:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65A7C6B0089; Tue,  3 Mar 2026 01:09:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 52B4E6B0005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 01:09:55 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D74421A05FD
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:09:54 +0000 (UTC)
X-FDA: 84503725908.09.6F8A4AE
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf19.hostedemail.com (Postfix) with ESMTP id 818431A000B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:09:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=leLPw+e5;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772518192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D0Oz/gBHMRnkmhHlWpJAtY0D0OpxHNbkfHskxgg3IuM=;
	b=0Wir49PgwLUA9WINYWH+uTEamrVVEWtXCZ3b9d0yBJ7RkPP8BW9r248mr3at0Ix86eti3Q
	g45YoQfhzlRcXQmJWJdXNuDp3L+mzQfw8e7X5gLrHpQsa4jCnT3jZ2J2MGO4NjGG1hDZg4
	AJi1209IftdcQRuG9UqiRo1N61jzCrA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=leLPw+e5;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772518192; a=rsa-sha256;
	cv=none;
	b=gWgy9dzVQLuBfOP+PJHlts87JQsa6uyMcbCoxWJqGdN+nL4Gd6ym4TL4h9ZQ0g80khdNjB
	OUOk3JNuNCUkMR6mNQ5XOrpFxx8kGuenRzFm7IES+RIH+VZcmfKqtHzOwA+YMyR8u1rS8/
	gLUPOjuQVlhu4MO59oUIBl9Hg9EBzMs=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772518186; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=D0Oz/gBHMRnkmhHlWpJAtY0D0OpxHNbkfHskxgg3IuM=;
	b=leLPw+e5XBisWm+cKsVEnP/YlhHKtUhArd0erSjvaJZpATzqj7I8oMrw6F1A9+64zI4esoGzqPcZdIDenW9L4WOwQYLCnASJiV91neUOz9pwI7+LBgYZkLShDtZjrT0FY6brmA+ABJ2GLHj5sW6kO/sy5keIjzpry3Yubvay+Ys=
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X-8iZBK_1772518175 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Mar 2026 14:09:45 +0800
Message-ID: <b075109d-1f7e-470a-a84b-26ce6edff3b8@linux.alibaba.com>
Date: Tue, 3 Mar 2026 14:09:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/huge_memory: fix a folio_split() race condition
 with folio_try_get()
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Hugh Dickins
 <hughd@google.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Bas van Dijk <bas@dfinity.org>, Eero Kelly <eero.kelly@dfinity.org>,
 Andrew Battat <andrew.battat@dfinity.org>,
 Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260302203159.3208341-1-ziy@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260302203159.3208341-1-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 818431A000B
X-Stat-Signature: 1tqr7wanywmca8ute4kxqqcowwakskwu
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772518191-726972
X-HE-Meta: U2FsdGVkX1/6rVhN7kGMTBRh9zFxZhq57WLm/zbOGr+FnSvRIp/tp0CJ8Vth9jtBp/W6KEC4/mi6bpLc8s7QELSDQHQx8J1IG9d+uY3hn+Jq3Vetq0/1Us5eC8Yi8R0i5wRbtUQJ+SqOAhsu1fGYex/N6lSG5rcPF46xJrw8Y9EqoWIXChNzeCOXytgecIVcXix1UJoGQ230MxQdda58D+722DAR28N9FybgtNNiAs3KCJmXML/nv97046ydmlfrX7b5tYeKF6wAElYcjT2E6E2cDS9js/DskYW0vU1iMQNim62+O5iyOVMNG/kSn/G7+rwtOZ/OTZJQVWqqqD+bjNzt4belHFL0IiH+KMk2+f8iaeCMIiGXZU2l2czi8MZS4d0uFUjTiJlE72COhSANUTAyqvMwIgCQujb0kzCzPEKGGk5WKvnwD4C5jVawg8sQ9E3RrFVIH6qxOAjKYkgh4kFD/hqH9KU+2KQE6mKp8+oWkWUI4ETO27D2ojIW1GJAdo18xYzgJia+9U5+vOm8lJ1TcHPP4us7spD1/gocv0oVTEoByP2A00PgZwNhSCPV5mqYvVf097wXF4YtjypYDHkqIukbq6Qy6T95Cmfic6q9nU2fcvauGg/PW2b+JvLFVryNVXm/g6I0vwoVEw+lGUpWDcrvryoNvx55jhORJPc3K6S20jCNksbL3mdu8FzMQHVD/48VZL64Mg5ve03OFzx2VOa1Opg3JDbv68SSVwEUvpSESPiyMDhG1SbgTVZKDHgyX63Pq1rg8updIuP46r6AeviUiYFZC4V7RMBNIFkSch2ew9dEhVhhpUQJu1tqrHvt72c/Yj9PLOSK5wo9qrDVgHEngREitns0NbC4LaZ1zsSsz19KDPRUCkl1g1vBXVpnr/3B0AgaZpLvJvbZarHVLmZ5NqS1cUFRdt7UDf2CSXUd3bN+6hhqWZsQaGua0STU0ilBHkTfWlELK9v
 xrxUAhv0
 +qEflFv480V9N7d6frZVuE21QSoyBbAkOu7r+88fXwjmztP2PKlOfCVmBSh8cHJPxh2c0TYq8+XxFiNFu5I8HRr5aXdYzO7ZSg1Knln/CUlJWVyCPbt6t1va5ZOivektpI1pWA7ggSih8yQ0Wdi1qZkTAgbS6/5252JfpEPM+BuiZooiL/cbMSRmmyGFitAujVKHIf1+K9Oj1M8Dqv15amgZXI0FoStQQvxmxbRMAO1HKTDAvZ0k/rcDw7AcU+0n44r4WbXLQKTsqCsBkqxo5CsXorhsQB7W6JZwxypZ7U+X4LGTcL54Kh60krgH4aC+cw5cymUWOSJ8KJa3X+QgHlW6+Ar539frJMmI9bxP2ozbvOESVQpiTjAg+QqZl++OZHBWK+LkP4ec+cbNv2rpA0/E0NUwVDfHrHQh61rPTw2hMTtW01i0cNtpYeTO29p6ZSB/CZX74o/aW8cmbOtlAFu4ofhN2dhpH+P0NX9jKqgXzRgbbn1rDiy4UXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/3/26 4:31 AM, Zi Yan wrote:
> During a pagecache folio split, the values in the related xarray should not
> be changed from the original folio at xarray split time until all
> after-split folios are well formed and stored in the xarray. Current use
> of xas_try_split() in __split_unmapped_folio() lets some after-split folios
> show up at wrong indices in the xarray. When these misplaced after-split
> folios are unfrozen, before correct folios are stored via __xa_store(), and
> grabbed by folio_try_get(), they are returned to userspace at wrong file
> indices, causing data corruption. More detailed explanation is at the
> bottom.
> 
> The reproducer is at: https://github.com/dfinity/thp-madv-remove-test
> It
> 1. creates a memfd,
> 2. forks,
> 3. in the child process, maps the file with large folios (via shmem code
>     path) and reads the mapped file continuously with 16 threads,
> 4. in the parent process, uses madvise(MADV_REMOVE) to punch poles in the
>     large folio.
> 
> Data corruption can be observed without the fix. Basically, data from a
> wrong page->index is returned.
> 
> Fix it by using the original folio in xas_try_split() calls, so that
> folio_try_get() can get the right after-split folios after the original
> folio is unfrozen.
> 
> Uniform split, split_huge_page*(), is not affected, since it uses
> xas_split_alloc() and xas_split() only once and stores the original folio
> in the xarray. Change xas_split() used in uniform split branch to use
> the original folio to avoid confusion.
> 
> Fixes below points to the commit introduces the code, but folio_split() is
> used in a later commit 7460b470a131f ("mm/truncate: use folio_split() in
> truncate operation").
> 
> More details:
> 
> For example, a folio f is split non-uniformly into f, f2, f3, f4 like
> below:
> +----------------+---------+----+----+
> |       f        |    f2   | f3 | f4 |
> +----------------+---------+----+----+
> but the xarray would look like below after __split_unmapped_folio() is
> done:
> +----------------+---------+----+----+
> |       f        |    f2   | f3 | f3 |
> +----------------+---------+----+----+
> 
> After __split_unmapped_folio(), the code changes the xarray and unfreezes
> after-split folios:
> 
> 1. unfreezes f2, __xa_store(f2)
> 2. unfreezes f3, __xa_store(f3)
> 3. unfreezes f4, __xa_store(f4), which overwrites the second f3 to f4.
> 4. unfreezes f.
> 
> Meanwhile, a parallel filemap_get_entry() can read the second f3 from the
> xarray and use folio_try_get() on it at step 2 when f3 is unfrozen. Then,
> f3 is wrongly returned to user.
> 
> After the fix, the xarray looks like below after __split_unmapped_folio():
> +----------------+---------+----+----+
> |       f        |    f    | f  | f  |
> +----------------+---------+----+----+
> so that the race window no longer exists.

Thanks for the detailed explanation. Make sense to me.

> Fixes: 00527733d0dc8 ("mm/huge_memory: add two new (not yet used) functions for folio_split()")
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reported-by: Bas van Dijk <bas@dfinity.org>
> Closes: https://lore.kernel.org/all/CAKNNEtw5_kZomhkugedKMPOG-sxs5Q5OLumWJdiWXv+C9Yct0w@mail.gmail.com/
> Tested-by: Lance Yang <lance.yang@linux.dev>
> Cc: <stable@vger.kernel.org>
> ---

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

