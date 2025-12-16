Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC0DED5E370
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 14:26:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18C566B0005; Tue, 16 Dec 2025 09:26:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1640D6B0089; Tue, 16 Dec 2025 09:26:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 063AD6B008A; Tue, 16 Dec 2025 09:26:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E67646B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 09:26:30 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 55039C0125
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:26:30 +0000 (UTC)
X-FDA: 84225559740.24.045724A
Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	by imf13.hostedemail.com (Postfix) with ESMTP id 10A3520011
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:26:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=si2J9e0u;
	spf=pass (imf13.hostedemail.com: domain of "prvs=438402146=epetron@amazon.de" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=438402146=epetron@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765895188; a=rsa-sha256;
	cv=none;
	b=S8FhA27MRYsegCE8MuoSWfLPTjAfkSz0M+Y6Pfug4EhaP7dd0zVnlAzw+IIwTXColfVRqb
	Vk6+jP2RN9C7N+BI9e6IwXO2Dn83fYOm4O18hx4QUBUuw8hwXtl5nUplMhcyQudlARoXOb
	ebKNz/uMlT0cIgDTSuid3SJ7TepfWFs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=si2J9e0u;
	spf=pass (imf13.hostedemail.com: domain of "prvs=438402146=epetron@amazon.de" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=438402146=epetron@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765895188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nNRRhRk29YGlyqb/BwG6GiFKvUFmbiQmfGQYctzC5Yk=;
	b=tLlU1nG6RLTWREg68xeIH7vA/xyZLu7sesW7U+UREkxuN0cLdeUuP4S+V9lfHWsL2YB6IT
	DTIvxSKNB4pgHz14ASfh2ZHiqv64qB8U8JHF+8MhSIn41ayY/7OBSDegwVDlk7S4lnfqwv
	kCspGWXa9CoSTMZgH53slL0tTIc4Xvk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1765895188; x=1797431188;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nNRRhRk29YGlyqb/BwG6GiFKvUFmbiQmfGQYctzC5Yk=;
  b=si2J9e0uSO71Dk3fyWcn84OowXiEaGXC8uKQZN3GQZq2+Xf/di/aaTWr
   kLjKGlVYG8kkIVvO495/mEsll6xI9BLxGI87QLV6enLefw3AQn6DMqZxm
   N7t1bZuGKTFSIVyimdjjUUx3OzgzyErtFa+4PgAD6GUOXFprX1Do7MPiO
   mZBTQURQlwHd/LyGeSax33VO7EAmhLBwDY68uewNKF0fN98e9GzUrMwTf
   1xPut1dTBOK+crS9nS2gF3fzELj8BNCvoDFM4lU7DpicBlc8jfEr5MYy9
   hvaiTgg0rX8Gjjf1B7+CAXqoE+dNdL+ZKvpCktnWF0J9M0kO8TbQvKBpp
   w==;
X-CSE-ConnectionGUID: 9TfYceSuRdWsExS5XeUv6g==
X-CSE-MsgGUID: mI+/LehNRlOk7YLzSag9nA==
X-IronPort-AV: E=Sophos;i="6.21,153,1763424000"; 
   d="scan'208";a="8968327"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 14:26:24 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:31014]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.31.61:2525] with esmtp (Farcaster)
 id a8fb656a-8250-4090-9976-2807247da5e7; Tue, 16 Dec 2025 14:26:24 +0000 (UTC)
X-Farcaster-Flow-ID: a8fb656a-8250-4090-9976-2807247da5e7
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Tue, 16 Dec 2025 14:26:22 +0000
Received: from dev-dsk-epetron-1c-1d4d9719.eu-west-1.amazon.com
 (10.253.109.105) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29; Tue, 16 Dec 2025
 14:26:20 +0000
Date: Tue, 16 Dec 2025 14:26:17 +0000
From: Evangelos Petrongonas <epetron@amazon.de>
To: Mike Rapoport <rppt@kernel.org>
CC: Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav
	<pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, Andrew Morton
	<akpm@linux-foundation.org>, Jason Miu <jasonmiu@google.com>,
	<linux-kernel@vger.kernel.org>, <kexec@lists.infradead.org>,
	<linux-mm@kvack.org>, <nh-open-source@amazon.com>
Subject: Re: [PATCH] kho: add support for deferred struct page init
Message-ID: <aUFsCQclDWFu3KDE@dev-dsk-epetron-1c-1d4d9719.eu-west-1.amazon.com>
References: <20251216084913.86342-1-epetron@amazon.de>
 <aUFJH9xzJXYOt_X8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aUFJH9xzJXYOt_X8@kernel.org>
X-Originating-IP: [10.253.109.105]
X-ClientProxiedBy: EX19D046UWB002.ant.amazon.com (10.13.139.181) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Rspamd-Queue-Id: 10A3520011
X-Rspamd-Server: rspam04
X-Stat-Signature: qw17fgo81kkhzbnr55bku7j1etjsujoj
X-HE-Tag: 1765895187-828046
X-HE-Meta: U2FsdGVkX18iq+S3zLMIyoHlWL8n/TBTVM0oyu3BHSeO7UF0GM2hiU5/GUECdaEkNrMEGga64naIOq0pr4/7ieouf1XwI4qPYRpmwAx4QdPtGuFm4xQ1Jyh8adgUz3YTiCoiZkilisOHZa92HqI+AaKB91BdvGPJY1sTwt/Ee2ZPFyzVxieefkT68a/RgDY2RG+ja7LTmEujR1mcBbKKOEY/EeL7Uj44OyIbIKG0ThuH0feryV3PXVA/A39TxZSaxRFa5ELmUj2qImtm6n+AyuEHZR2CXCLeQhn2S5E81gtCoA45Q7DJNjCI/fvKgwDRvxnlxBzr77nDQSY6GJUvoP797xZgA/B5rxLYEM52KZcpYft86kmzg6RxOGU7ZrdJ4aB0DGZFZ5zDo5mD6o2l/h9VL7n2we7p9xbL2F8XDMwqdDf0r3rYC6y0XfcZZBgKfu0hcWuruykHRxLaPf8wn7oNxvzO8N8us2TXCpjaKVpWIWDfBhY+E8UiDLawTzZRVRUxguUlGrMga0F7AxRC7tf8cKjjyyhvm0k3k72LO6MIANta7i1VOuoXkft8N+aCPSDYtgK84+KHzIX4k0BdbSe+xRru6x+ek31Nifc/5PtFgnbFoCumsT4oJyUSQ9XYb92BDehiPeqvifVHLuHKgEC4pYOOIYuRE5hChtqB0nvJsBvVaLHhKf2PkhVZ+d82RtpndtBX/uC0lBUp3YUXF/+2FdWwe1qnQoGp8gX3RbzOip8TUjDgwd4vOeCh8GkPM0rQUjd91DSszC5LYQr7RPRoYC0xV/v0SSnXtg/xvvSHMzjXP2SXjjzk0Y6BdLsdZkvBypZihLtFoV9uKzSOVvRDgM6XTm4y+crFooFOc5A1A7hmhyk/342afgM/3bOn7UXK6gPsRAQhRhrwqcxwmabSbV1dHK9Ed3PmVWaxfGlCRKsPo5H/8OxzHvoVJS1H5uu1ASWkpGrlrTp7BDf
 N3GaJEFQ
 j5gnVUOWmlagrOKGzfl4JqnbQERxHzby27o9BRnDLbNhDNH9RaZ0IWxNhFziRiofTNxGXZvn3114DHebwYYXY6DLCAteUObOO5Prt9w6xOijtLcNnLtbwP9z6pteqfPemZ+lchMsubqllk2IympwWId+k9XebAHrfm5uyZxhZceH0grHVuD3a+uW+UcvkL61UG0V/fe9neClZcqYqQCHUn/UmD9b/d2tSGQ2n1TOI6QiquM9goNa7tDcLVMR+ptpF1j8061Q9s2u0SFhwszsDOfj3WaLt9aZV9kpluWFv2mKzYnkrovEyuGmmo4486QxOnvoZ3mzDXH4TJlyGRkCvo7jCsKyRlj4r4riGNbG2yB19EojzbhXDeER2FOThWEBqznJpsZUGLb6D8eCU7PXF2poT+rip4a9mFCFp4j9J7eR5A2w0OZLA/w/gvODwnubSm8MKSGOual3t+g4cdcx5ou/bSwsM9QmqXd1tXg8zA7lBaArv9AsKpXzHS7SNMLIJosxGP2iUEYz+cSAbdzBiCVx9qvT/i7Vw1BG6p5sEOtSiEa5Yru7RBJtp4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 01:57:19PM +0200 Mike Rapoport wrote:
> Hi Evangelos,
> 
> On Tue, Dec 16, 2025 at 08:49:12AM +0000, Evangelos Petrongonas wrote:
> > When `CONFIG_DEFERRED_STRUCT_PAGE_INIT` is enabled, struct page
> 
> No need for markup formatting in the changelog.
> 
ack

> > initialization is deferred to parallel kthreads that run later
> > in the boot process.
> > 
> > During KHO restoration, `deserialize_bitmap()` writes metadata for
> > each preserved memory region. However, if the struct page has not been
> > initialized, this write targets uninitialized memory, potentially
> > leading to errors like:
> > ```
> > BUG: unable to handle page fault for address: ...
> > ```
> > 
> > Fix this by introducing `kho_get_preserved_page()`,  which ensures
> > all struct pages in a preserved region are initialized by calling
> > `init_deferred_page()` which is a no-op when deferred init is disabled
> > or when the struct page is already initialized.
> > 
> > Fixes: 8b66ed2c3f42 ("kho: mm: don't allow deferred struct page with KHO")
> > Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
> > ---
> 
> ...
> 
> > +static struct page *__init kho_get_preserved_page(phys_addr_t phys,
> > +						  unsigned int order)
> > +{
> > +	unsigned long pfn = PHYS_PFN(phys);
> > +	int nid = early_pfn_to_nid(pfn);
> > +
> > +	for (int i = 0; i < (1 << order); i++)
> > +		init_deferred_page(pfn + i, nid);
> 
> This will skip pages below node->first_deferred_pfn, we need to use
> __init_page_from_nid() here.
> 
Right, __init_page_from_nid() unconditionally initializes the page.

> > +
> > +	return pfn_to_page(pfn);
> > +}
> > +
> >  static void __init deserialize_bitmap(unsigned int order,
> >  				      struct khoser_mem_bitmap_ptr *elm)
> >  {
> > @@ -449,7 +466,7 @@ static void __init deserialize_bitmap(unsigned int order,
> >  		int sz = 1 << (order + PAGE_SHIFT);
> >  		phys_addr_t phys =
> >  			elm->phys_start + (bit << (order + PAGE_SHIFT));
> > -		struct page *page = phys_to_page(phys);
> > +		struct page *page = kho_get_preserved_page(phys, order);
> 
> I think it's better to initialize deferred struct pages later in
> kho_restore_page. deserialize_bitmap() runs before SMP and it already does
> heavy lifting of memblock_reserve()s. Delaying struct page initialization
> until restore makes it at least run in parallel with other initialization
> tasks.
> 
> I started to work on this just before plumbers and I have something
> untested here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=kho/deferred-page/v0.1
> 

Nice suggestion! I looked at your branch and I agree, your
approach seems better.

I also noticed your debug check:
```
	if (IS_ENABLED(CONFIG_KEXEC_HANDOVER_DEBUG))
		WARN_ON(nid != early_pfn_to_nid(pfn + i));
```

This catches, or at least allows for easier debugging of,
another potential (although unlinkely (?)) issue that my patch missed:
preserved pages spanning multiple NUMA nodes within a single higher-order
allocation. Nice to have this :)

I am happy to drop my patch in favor of yours. FWIW I have quickly
tested it both using the modified selftest and a custom payload and it
seems to be working fine. Please let me know once you post the patches.

> >  		union kho_page_info info;
> >  
> >  		memblock_reserve(phys, sz);
> > -- 
> > 2.43.0
> > 
> > 
> > 
> > 
> > Amazon Web Services Development Center Germany GmbH
> > Tamara-Danz-Str. 13
> > 10243 Berlin
> > Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
> > Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
> > Sitz: Berlin
> > Ust-ID: DE 365 538 597
> > 
> 
> -- 
> Sincerely yours,
> Mike.

Kind Regards,
Evangelos



Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


