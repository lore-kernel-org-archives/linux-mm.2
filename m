Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 128F0C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 02:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EF166B007B; Thu, 31 Jul 2025 22:43:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0336B0095; Thu, 31 Jul 2025 22:43:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DCF06B0098; Thu, 31 Jul 2025 22:43:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6CC7F6B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 22:43:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C3EA140ECD
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 02:43:57 +0000 (UTC)
X-FDA: 83726643714.14.2B80121
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6484F80009
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 02:43:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZtnN84kH
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754016235; a=rsa-sha256;
	cv=none;
	b=YOHtgzjNHi51ThiyUJn82mSab5KSyi0rqKlLEpPVpN90B0buLIALkQtmjs21paFQEHf32s
	BtJJG/XRkImoHCDO4ZpRLmEUzYPRMrfddHoFXaZGkhGaNmyWquoOqnkQ2hZkg7MiAliuqL
	pY12NZL7R1MhQI+sUJGGn29GwodzbfA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZtnN84kH;
	dmarc=none;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754016235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kPdQmsE5jOGdkbbgGZrGpYgomQOUn1rDoqq145A7Kbw=;
	b=0T5maNEh08jFSbrJ69yyeQxSIuzlyj+QwAs4fjEgClroC8NqE2Y67H2WiWPyXzAC0ELvsC
	9mOuVLBDZSJsSYgsS9QlsHnCvtSIo4GWOGzu8WHu2sNETMH8uP5wLrq3SyyUDuOJVv7Etx
	s+8O4rVObu9ipZG8Lx0MOFaMMXrlcwk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kPdQmsE5jOGdkbbgGZrGpYgomQOUn1rDoqq145A7Kbw=; b=ZtnN84kHM6zjnfcu7Sa+6qdu7d
	fcDCmImqtU5xO4xNDLNgDBuhunT6amFniv3RnQkgKMKYlVnHbbFOtTs2OwTMZya2IJJacMCapps0p
	YaYo0HL/rtCPeeHJHFg1qszlvdFjk6JvdoouQE6/lHxaUbkumEc+LB+x3Pyl3V9hRxfLa4O7/JnDo
	yVMjqCb05WW5Hh2G5mBU/kLzqBZnA21luQzpL98ZfSaH8QE6tKBp2BSsSAtaUzp5xsF03e62BPHbq
	3Kc96qjT2ZNes7VAUMu4MuKUw4847/yXB6aJdkwY6e5RZiVOBTATulQa/Qzft+aXKrQXmsH5vuMRo
	nhPuQ/hg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uhfkK-000000061Ju-0ers;
	Fri, 01 Aug 2025 02:43:48 +0000
Date: Fri, 1 Aug 2025 03:43:47 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>, linux-mm@kvack.org,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: Re: [PATCH 3/4] mm: Support only one page_type per page
Message-ID: <aIwp48CTft68fssD@casper.infradead.org>
References: <20240821173914.2270383-1-willy@infradead.org>
 <20240821173914.2270383-4-willy@infradead.org>
 <2d19c48a-c550-4345-bf36-d05cd303c5de@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d19c48a-c550-4345-bf36-d05cd303c5de@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6484F80009
X-Stat-Signature: kwx711zihmh7z777go414jt7tbkkhjjm
X-HE-Tag: 1754016234-484209
X-HE-Meta: U2FsdGVkX18Mckm5YrWk3kzt4UgwWToql29KvUGCwKkIvLvsEXYu3dSCc7A52gZlvE3X4LkBPe+BCj2WXVshv9VVPQ20xbFS1th0839FCjaYGaEOktPjrAFGgfZZV4fyFixtClVWPO/0zWG4jMRQPESNc8nZmAP9Fli9jxXCUmelzS/NNMqEWDSLRDAxOAxHjIP6z2Z/qN2Kbbg24FghtKMIIEq0QCw5kOa7gVrnPLU9wUpedwvw91mCqPx7bSf3pvzy2vzYfIIvmg6exsuLPX0qFmXpsNV8z90v++v4dpeJ93K5FdVh/Jztz+KbS2h/23ck6j8IrWJqmhpwiJh3Ocom6FN60L4Q/ym0RiNH54GaUSrylhM3f1hWK+v/vCpL4cyX45vrMHntcxK7GzCpSM7L0PHthmg0m0m2+8lRukSTjZuS98YWAVAOzIAdr1YHTbl2hMxAKUxQAS5ZptpO0l20aqTlfBNL+LWFKoFLCbNiGzexuY82CsetFtHDaziWfqphNw00fCeptt001OwZ6eXncF5BmlfU5oWEkDno9RmVc8r/RTKj9nT89PL2uYNV+pm9ZRTSxjazUvMLNa98m2aAhAxO8bJQFb7tCuI0ifTqUPia+RfZOQzrKdeI0/2Ya72Q+rMeg/Ubk4hXujhOnRFamzJGOI7aS6T97Yl3zn2ugAU9dhsGiuI4aUBrZkJw8egFKRzc06Y754ibzgzS82VgvyEEZY7Gw+4VW5GufvDwJbQP6NligJLUMU+qn22Cs7XSJ342NMiaQYV+5w5TbpqRorApP/GTTJES+GpfGGAl0rFrc/mwxbsqLBzZSbyVj05VSgpquc/MHU129ntM6fv8FiSKeP6VCBdiI7plHZKf1mD1TqCuRnsTCRVkI6LbdjaHS+JcgAHZ3yscZ0rHeL6istaoktWb1P1sKZuqgudsIf4z9k6RZpKvjONG9LtL97eZxEDyrAH8wXfhPtR
 f/jrpba4
 Oc+9eyw8REwBRqhiyeZ24wojT+ioLnk+fIm9vU6CeBM8+YLSGmxrYbilqrym1aBl5hulCaiC+OeDj+hcMQeQrzaKbb5GhoY+kgw6Jsu7GTbAgMx5+PSD4tIT96omgNla4FBuku0XxPkRCAPGfKsfHTe5xyCJTeqWZKYva6wvctyG9ZlOUVUbCs7uxUgX2vriq1ZJprlfHb3VqC6GjiQQpdJH9hKSVk9nDimDNsQuq8VxRzqSDWdwwSmhzB3IYvEhv9pqFXEFIywS2tfhdHC/3VoxNdcPtsbdz7pug
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 28, 2024 at 11:35:28AM +0800, Kefeng Wang wrote:
> There are some UBSAN warning about  __folio_set_##fname/__SetPage##uname,
> 
> UBSAN: shift-out-of-bounds in ../include/linux/page-flags.h:998:1
> left shift of 240 by 24 places cannot be represented in type 'int'

I can't reproduce this.  I know Andrew merged this patch in, but I
tried backing it out and enabling UBSAN and it doesn't show up for me.
Relevant part of .config:

CONFIG_ARCH_HAS_UBSAN=y
CONFIG_UBSAN=y
CONFIG_UBSAN_TRAP=y
CONFIG_CC_HAS_UBSAN_BOUNDS_STRICT=y
CONFIG_UBSAN_BOUNDS=y
CONFIG_UBSAN_BOUNDS_STRICT=y
CONFIG_UBSAN_SHIFT=y
# CONFIG_UBSAN_DIV_ZERO is not set
CONFIG_UBSAN_BOOL=y
CONFIG_UBSAN_ENUM=y
# CONFIG_TEST_UBSAN is not set

(I tried CONFIG_UBSAN_TRAP both on and off)

> Changing significant bit to unsigned to fix it.
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 28d2337525d1..2175ebceb41c 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -966,7 +966,7 @@ static __always_inline void __folio_set_##fname(struct
> folio *folio)        \
>  {                                                                      \
>         VM_BUG_ON_FOLIO(data_race(folio->page.page_type) != UINT_MAX,   \
>                         folio);                                         \
> -       folio->page.page_type = PGTY_##lname << 24;                     \
> +       folio->page.page_type = (unsigned int)PGTY_##lname << 24;       \
>  }                                                                      \
>  static __always_inline void __folio_clear_##fname(struct folio *folio) \
>  {                                                                      \
> @@ -983,7 +983,7 @@ static __always_inline int Page##uname(const struct page
> *page)             \
>  static __always_inline void __SetPage##uname(struct page *page)         \
>  {                                                                      \
>         VM_BUG_ON_PAGE(data_race(page->page_type) != UINT_MAX, page);   \
> -       page->page_type = PGTY_##lname << 24;                           \
> +       page->page_type = (unsigned int)PGTY_##lname << 24;             \
>  }                                                                      \
> 
> 
> 

