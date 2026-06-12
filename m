Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 639A9CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 18:10:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C95636B0098; Fri, 12 Jun 2026 14:10:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C46656B0099; Fri, 12 Jun 2026 14:10:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B355B6B009B; Fri, 12 Jun 2026 14:10:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9DD206B0098
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:10:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5DD79163F04
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:10:20 +0000 (UTC)
X-FDA: 84872050200.16.8AC40A4
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	by imf16.hostedemail.com (Postfix) with ESMTP id 626B1180015
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:10:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KU9a2Al8;
	spf=pass (imf16.hostedemail.com: domain of devnexen@gmail.com designates 209.85.161.43 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781287818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6aby2FKrKYk5ooc5hnv8BMPkFpApSAX719sJ5cVOIJc=;
	b=7OgOa4b9hPX7iYRWlpL+3xH++mTlDaG5oVzZWXBVIuDYMtGrL8jEhg1TEEIU9yYXjKcADK
	y+HbOAUQcvrdmqidQPeo5ICfsY/kKJ0Sl8v/N+DTPNiyV5iyJUJP8TGj/DUktKXmrp6+Vu
	wq2I/BuQEJYGedQpHv/VdnksAtCoHF8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781287818;
	b=kMK7Za8whqtJKNd3GtVnYOrr32Ot141x9zo9RP3PHPBTMapYj+XagZ4CxEW3cqIuAvEPsf
	kJBMQCGgZg0mprAIiY3eYqllbwSyI6HtA3ggxBiCBP+MbFbN+hY3hUOa5oCOY9jzm7SHbf
	AsbhP3BuBLZXXcpYVlVAmS6QNoV9+kk=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KU9a2Al8;
	spf=pass (imf16.hostedemail.com: domain of devnexen@gmail.com designates 209.85.161.43 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-69e59978deeso543695eaf.0
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:10:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781287817; cv=none;
        d=google.com; s=arc-20240605;
        b=EPNWGPRWLgZjFxkIjmwKjA1iXNRxXJjVd+u6Ml7PXJ9pW/pUWzpeddTEY2bTYrrXL1
         GqWhvH32l0bP3QdAcarklKuSCv8bIFdULzhmY6oy4LfiNcRAN1XBA1LYac3AoKLTT9Uj
         pjhoVQuZwaPhIElOhS2ZeG2vnHvQ3f7+uLmRZLigs+3PQTBO1D0L/KsI4wxBWPTdDXIV
         aa03JUFaVq07geYBLtIXeJ7X3Ol3Tc5Ltq5lHUadaOWogGN22dY3sKZrOACUp+PRKoYi
         TiUuLC8bw0RJ0rG2m5a1YPcRlRo4yg70BeDDk09qlPY/el/5dzXwa935GmiY+ZTPGeXA
         rCfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=6aby2FKrKYk5ooc5hnv8BMPkFpApSAX719sJ5cVOIJc=;
        fh=srtMIkPy+8kqtObJ6t5j4UsFZ1nRf7k+OFoG07qCImQ=;
        b=LwQ+WlzX9C6QlcjEFaqNtQFNc4dHnipX783uCu/pc/49DU6d4MkeNy1Te2XK7e8JMn
         fX99+zpM/gJXnBRAw631Sm+ygwj1bBDFDHN+ty6bXK6sXeI2Q6O8LMeU4mmagtYC2yIp
         EjEFBH7WX0zILpdHugDAHh1ZIbGmGNveWG6tOdN/fPQv9ILdXoYtLJVbZn5kD0FNGMJ4
         KaygA4p5/Uez4R2bNKR7BqikNfHFvLrNyMwhuk/IAYGKkdFQt4hK03vy2HAj4v0eywtj
         8+QU48bILcGc6g+YGQcRoHb2EEt4IiyqN5cs2p8lLtYh0KTvL/KWta2nqmyUKFzdDX8c
         RTeA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781287817; x=1781892617; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6aby2FKrKYk5ooc5hnv8BMPkFpApSAX719sJ5cVOIJc=;
        b=KU9a2Al8vHcG2QPYHdGOSWlVIQ4SYAWYYEnJ5bQySDExy+RkGH0NWvLRVdp8xBaoxX
         qvl5fprU/0y2gtDDuYmAhpF/+tO5+e+B0jRQ4HPbSYsi7Vm1+YQiiDxlsARye/4MoYxf
         Uf1HogTPLQn5gh0nvHcGDPncO26GFXslEG53NvVYUNe1zKbh9TmMI/vm6Sy82rOOVqzW
         UPBrFbctkTwABgvY6fUDuz3IOv18m/P8+xgYKCyvSnUfgL5aEzScDUllvgD7owkZww4o
         ZXCIbt0DUxPxYSdZucjLQCMTY6Jroch3rh8Es+FWqJOxBzb0KyAD/Hhng84E8wmbEQJi
         XYNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781287817; x=1781892617;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6aby2FKrKYk5ooc5hnv8BMPkFpApSAX719sJ5cVOIJc=;
        b=kBW/tSUjGd8wWM5B95TVQa3bnO4DFD9F608hMCiiQ9134FO73MWxjGUORCVRLCQTrG
         7RWXMQUwp1R0XdYUOOts8skrOmxaTTouUYf9Lax7OnqslOcZLrS7hLBJMzA3YsT6H/SB
         sdbzd0dwYF7MrCu5B78CaVpB+px8fmx90fjILWo3GdGNLCp0VeA6CiKrTGGna6UGzh9J
         Uel82gfDKDgZ27qSYYsFlVKQE3UGKrBN5EST97MN281rIMCWkVYHPqkHCcNhMUlkjll6
         tu5ayfBIY+akx/rSMyxBMhSY3ryUu6sUtV5jpFXh8IXRQSaplJMIr3MYY0hM6wUGuzL2
         95GQ==
X-Forwarded-Encrypted: i=1; AFNElJ/cYlzVD/PB2wdCE/2x3WrttztTAG7LzJR/5aYPsm3HJNF1PJNM3ZyFsge5kTzneqfSACYUHCN8bg==@kvack.org
X-Gm-Message-State: AOJu0YzB1+3hcN76DIRVN+DNSlVjMFNgXN6nShdsgsU4XAbTVrfPJ16U
	zpLio3d/Kx+jyDr2tliLJVvC5pp4H6VX3yAq6iu1bq89Gjr7xTfsNl9t7r4g8Ghju8WYs7Negtu
	4ZvIi+iH83HO4dxK43K1ZkJ8ybpXuMv4=
X-Gm-Gg: Acq92OEUz2aLcyfRHI4KrfCazgSUKGsDIN+xxH24W4bWboXBlubVDDWHiZKiOLuiOnS
	FN6keqXSHkHvNTwOK40U5Xqne+xmmJpzOIigUHiHHMl13avx6RBWksj8OGor6hbkRRArexsFtOw
	3jJDxsi3tDRSWjJKc3G09zxSOifJVC/xkgpgZFlS0Emue/7iW48vjEpjbY/qGInHg6/yq0jtMLc
	av001qbrxmuL3BAaXQFtPNelGP1TQZHnEWRte23S6Myj94b8r+OaFKu+SVQ17uyTu5+FUJT0vxC
	gOMbixWXkssbDHxTU19oj/GBTAHm7ZBgwcp4IQ==
X-Received: by 2002:a05:6820:f00d:b0:69e:5d3b:e7d9 with SMTP id
 006d021491bc7-69eeca2e7d0mr349022eaf.39.1781287817237; Fri, 12 Jun 2026
 11:10:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260612091215.b06dc7dc9dc894a5bfc75429@linux-foundation.org>
 <20260612172356.356894-1-devnexen@gmail.com> <aixEbMI0kK9in7AF@casper.infradead.org>
In-Reply-To: <aixEbMI0kK9in7AF@casper.infradead.org>
From: David CARLIER <devnexen@gmail.com>
Date: Fri, 12 Jun 2026 19:10:03 +0100
X-Gm-Features: AVVi8CckXRmq6Rwf0WCSj37ewMxBVGl3bUVMWmj2vu8KsBT1OPL_8kRIm58xVyI
Message-ID: <CA+XhMqwR6LA0gWf7SCUB8ZWFswCZg7tN8P4nBr1zbFLweVOZRQ@mail.gmail.com>
Subject: Re: [PATCH v3] mm: pgtable: protect lockless kernel page table walks
 with RCU
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, 
	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kevin Tian <kevin.tian@intel.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Dave Hansen <dave.hansen@linux.intel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 626B1180015
X-Stat-Signature: i16z9iqbn9jtuk7ndzawxee6q5oowzz1
X-HE-Tag: 1781287818-358061
X-HE-Meta: U2FsdGVkX19vFYm9KdhHv0oQz0nljCqS+TsV/oUplSSvENaCJRABcputcBikXKM2HesAylygGA73f59Hx4O1ExZL6bLg0/JSWW2s3Iskr+ZVIwxUg6OFw1v5EhOK/3Zv4Mls6v+SDb7V78vaC/K+wsxJPSS0hqcSbRT/IS479lx+CvK2b5AbPaLqz61Kx4ScUvkuyUZS6/J5aGRQFgoblmc06g9jkrXUvJX8cbYE6ITF6jTAfnP2v293mqRzzkAKopdiIrQ8ftP38yhdPTYJbB3Ovd2EDdat7e8naWt1nAhMoSyVESbjqSHeRiLgOZZ7+gE1MUPYH4kIVfEsCh6VvYDuoHMueBOa4DvrdurOfodS1VXbXDdhXdE55eHHbAq6zSuXmNnbPQRdWosRIQs8xy62eDzOuOm3UqFenizb5264tBcRfbxL0TMzAW/2nbpKmFGknntlnQ0xCx9dWrfyh1d6xOBfL4io/EoaXQJh+VBhkKdYJfMqAGwrOpuy95juW4d4M4DgLxIrUmFToLWf0wkRMRVM1R4wSbo4ZoxapXAOqDkSA6YFIFGL+o6FvDwSHjq6x6LPSy32ROp96lfwOoDkivpWaWnQ3JUICuzT+0I0vKV8VMAPsKo1efzLIyGKKPNUvqSi5qrQexhMo3QL174vePMuoUu7+RhaRCAizqwEUJLuliZGkyrJteupnS6po7HJwlNJ4lltsE+zappyp/zi5Bh9sZlXycT2JhTm+36H2d0rfC9Aq6FzGnE011rVSfCyO2JsE8mKkaNVjOG0WKlRkLQWlvQe45VUED2+965k5/45HlvlV28r/A1NgPk6NVgEgZlxdxYPEqY/Wp2iiXCM9/M+PhZdHm5Oz9KgRcayWRmFAKi5UpwEjLJePVcmqWLTbzO6T127ETueULwM1OSVqKCfqQxje6dYzbsZv6adEyiECLf2HFuKYmXdy7OeE90osi2dG7FVP1JQpHr
 dP8AbfKk
 o94S9JAO101TOmyxthScK5eXY8jQ/TVjI5fRUHyUQGr5r/HUJWs2vMyoSOQokMXJDCFscn3By/cxtAHebp8H/wpK/PEcDT2T7p3OYznTIKKZkN6fwzg2u8zm/6Ba/0XA7u269YH0yTq8blRkmIQfwc03ONYURv8+wtNmiqVhQ3qRUivxL6lbjvpJVqD3kL25Uksz8PHrHUhwE31CbLmYiY1ZeMfptzrQxVH3OL7EQtSZ91xYAwYQHAlmFFb53qRtfBmZt1ivifpaWGTTGTSGXpSYV3eA444LGxI/d9k1AaRIUlyqiJrnfarjQJvK4015tDfe90AqargilHBzh2ztI91F3hjzshaKfPFlOyOWOt0LwTsBUoJ5jkctfXo5SwX3JrTJcpApT43r/W134U6H9iUBlVDSHTEtADlhdQyjU1pD4ZHY4+n+bCm+iT1pDrPTc7LH7NvvKNCQhcnEDexUFyeKySgPcZKKjJhgItGHTGfHX36xWS4FG9bkN7lf7MD2PapYd0k0uN1QTIz7wlEnUruq1SgKjeoSt7aDQc2w5XnVv583qVLh5EGjDY06pAt5PAhc4GIf9VMz6k9NGdyUsGXda0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Jun 2026 at 18:39, Matthew Wilcox <willy@infradead.org> wrote:
>
> On Fri, Jun 12, 2026 at 06:23:55PM +0100, David Carlier wrote:
> > ptdump walks the kernel page tables locklessly through
> > walk_kernel_page_table_range_lockless().  It only holds the init_mm
> > mmap lock and the memory hotplug lock, and neither excludes
> > vmalloc/ioremap teardown from freeing kernel PTE pages via
> > pmd_free_pte_page() -> pagetable_free_kernel().  syzbot hit a
> > use-after-free in ptdump_pte_entry() reading a PTE page that was freed
> > underneath the walk.
>
> Does it make sense to walk the iomap / vmap ranges in ptdump?  I can't
> really tell if this is something that's useful, or something that nobody
> thought to exclude.

Yes, it's intentional. ptdump_check_wx() walks the whole kernel half
(_PAGE_OFFSET..~0UL on arm64, equivalent on x86) precisely to audit
W+X mappings, and those live
  in the module/vmalloc/BPF JIT ranges. The debugfs dump labels the
vmalloc and modules markers for the same reason. Skipping those ranges
would defeat the W^X check,
  so the walk has to cover them, which is why it needs the RCU
protection rather than an exclusion.

