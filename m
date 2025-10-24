Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A628CCCD193
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 01:12:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 961FE8E0023; Thu, 23 Oct 2025 21:12:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912568E0002; Thu, 23 Oct 2025 21:12:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8285B8E0023; Thu, 23 Oct 2025 21:12:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6DBEE8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 21:12:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1096EBE0D2
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 01:12:15 +0000 (UTC)
X-FDA: 84031231830.29.4765D63
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 51797140007
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 01:12:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lIouTQuM;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761268333; a=rsa-sha256;
	cv=none;
	b=MFCFGc+kKJTIUlw+WXHVNGPrpKXotRiDr9e35ccI2jWAznG8XNp8IynakUsDNkf0YrAmvN
	qgJKhYh9VY+syRbc2al2/4sT3jyrYUHzrTa22pzt3HdC72Hpek9BO24DEHe4UR9FKKhaZQ
	UTi6pY3MvyOprsRs6i/2XyrhfUcPGAY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lIouTQuM;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761268333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o9AsJei2PfNoyZjDNHwcydMvKfYQBIOQ2aIPzKu5N5g=;
	b=OeA5DIJVHbjknKDwWz2ZwI9hPsdUTnnrBvvZGBT9ejguZ+JafmhR78CTDp/WJlw+bzu7S+
	CkpendRNNBtHAK2ZwAj0pZ/jxXgXvSPPOITJMRjFmLdootSfl+O0kk6e+9jy7aGQX5q3MS
	lkWZuaxyVens+AWSbmafQDv4QWgG8tQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 690D36044E;
	Fri, 24 Oct 2025 01:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FC6C4CEE7;
	Fri, 24 Oct 2025 01:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761268332;
	bh=YZ+0DV5LEATfnFvA/YpzRGzHISuk/B5IaqGoFG5GEz0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lIouTQuMSETzy3+LGcLhB4cGdTFU5WiaXcT8u2Qj5SsJRrWCPbhamfDVwsCfG5EUQ
	 a6aME0ZhIfzadKPY4qgdV178BcYbayESvu8uo3Msj8m6MWRQk2k6MnGQUvXbUhaYre
	 xIHlpNQxTiSBGr+DZdO6ixlVRoOhg4E0QFi90P1Q=
Date: Thu, 23 Oct 2025 18:12:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>, Oscar Salvador
 <osalvador@suse.de>, Muchun Song <muchun.song@linux.dev>,
 <linux-mm@kvack.org>, <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>,
 Zi Yan <ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
 <willy@infradead.org>
Subject: Re: [PATCH v4 5/6] mm: cma: add cma_alloc_frozen{_compound}()
Message-Id: <20251023181211.5884d84bd48d3d5ef9448741@linux-foundation.org>
In-Reply-To: <20251023115940.3573158-6-wangkefeng.wang@huawei.com>
References: <20251023115940.3573158-1-wangkefeng.wang@huawei.com>
	<20251023115940.3573158-6-wangkefeng.wang@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 51797140007
X-Stat-Signature: 8jjy93n5c5u8uymoyqqtizq1g18ja3wt
X-HE-Tag: 1761268333-717601
X-HE-Meta: U2FsdGVkX1+CGzxHAYd/psMQd87coe2Jl9kKAaZIcTqVpi0UjBdG+NgX6SWBRPQ8qrXbSXs27tD17m9qiWTGqtFcRl5mlFDVs7gM0F4h3jw8x0i5NjD1wIZ5WNP523b2eqlhXSJqMB6Q8Rz198jX3vdT/T1xjFs8Wfva7qtOGxCm2vZjnXzic3OE68JfaSzmv5F33NG9IykPWYSQ0/4meoLwAmm38I9AFeKHfetLGSIXem+QZqYRRJILD6nFvAhCfhVVm8GblOUzj6NCVCDFBKfDkCvmkPTZZX8A3l4hFUlYAUKaIKRl1onn/h6MBKT7lotVVxyh/2ENJKFnWZe/3NBw1BAXSh3I1O7jEBvZeq5BCegfRnt3gNzeZHiv019ucj33vR7gYdXxYL4PZUycWR2n3dyT51sFFMdkYbsOsaD0qzF1f7tyQMjVMxM0BdKux6PkHzOdaImFxp9gVirZiuRI5X2f0CaPoGGbjqT/MZvdJSnbv/nWyeYQn8Dv2XpTxYWTXLtDQeZLrVsOruvnj7rmMtGyE8baS7q9NDSe1pjNPFR9/J4DMLbsN+/7rFeNEY1xb4GtUwSruDLmNWu2btkeaYzDHroJqLhDuMRaJBPSVQs2HMUj/08K9hyi2bkTVroo6cRmBBuwmcwagWXkZPxIoZxb4O3yVXNjuZ7zlw//q2AeLIIc7rQ9wCz8QT2+I7TGPQHsR7lzH/zKYWj36wpa9Ox6IXc2m3nyIBOfB45fM5ZJ1qzhgd2hwVkNn+arb0JrXV5bC3cfTKePGtNqslW5W/xcg6VMoXP/TWM4tu8r5jSGoezF/4IUIhEG0+TpJyvPYyfVEOBkMEajQsIuIlBzzSTPYl/cMG69D7I9hEVhAm22vBrTiTWBzYySxmirMy4cDzk6+SWn4KnNZnmIpG/6+/h6EsGRqzsbtU3U18iZZT8766JYD1B/vyQL9csOBj5vQ8u0kjSweD+P6iu
 TvpsAODL
 VzfExkhn/SF6BXSEbjzA2b0dLokxNE2dq3buXj1VA6hqiTV0ld1SHH9Ufzzk7+F+54eSlffs6fOwAtY96k7kvwxfJo9NrQAM0Khtph0ZgWDlSFfASyTNn0XO+A/1kTN/gn1vWpj4aqMl/XLPi4USU8ZB714lAcCs0RqQiPsn+OhpuqfUBtgMo0ZsdrKjcaeDH6bbpk3T2389erS403WXQzsuoDbZvUXG+/f6y6ojYosUL2ZbWUCqO2HuEIlYvI3e6w7LyOKf8Qo7tfCX79JYwUecNoA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Oct 2025 19:59:39 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:

> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -515,13 +515,6 @@ static inline void set_page_refcounted(struct page *page)
>  
>  static inline void set_pages_refcounted(struct page *page, unsigned long nr_pages)
>  {
> -	unsigned long pfn = page_to_pfn(page);
> -
> -	if (PageHead(page)) {
> -		set_page_refcounted(page);
> -		return;
> -	}
> -
>  	for (; nr_pages--; pfn++)
>  		set_page_refcounted(pfn_to_page(pfn));
>  }

pfn is undefined here.

I could fix, but what you sent clearly wasn't what you tested, so I'll
drop this version of this series.


