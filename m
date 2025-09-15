Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00BB6CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 10:48:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A56F8E0018; Mon, 15 Sep 2025 06:48:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 455F38E0001; Mon, 15 Sep 2025 06:48:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 344888E0018; Mon, 15 Sep 2025 06:48:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C1978E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:48:15 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C0C9116059D
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:48:14 +0000 (UTC)
X-FDA: 83891160108.06.735633C
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf27.hostedemail.com (Postfix) with ESMTP id E15C04000C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:48:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=Zy2j7Trj;
	spf=pass (imf27.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.52 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757933293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T1HmJL9+VKEbFuhKNn/wLWZD0HnPqeDLmIfK2aizEXU=;
	b=HfWgtGMus43YKsA8h4wLTgHpH0bPWayoFfH2eNa8luelxTkafOWmsPfUItt3sDkeEfgIzO
	NCDmiXCQjlQO5rCOb1Dpuws6VzjN+7epOxuQSPwImsbaH1rkbTjd7XsYMJHc2qT9NpRJmp
	WoMQJPMJgxTLn6mLG3Sh5agi3p3FZ4Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757933293; a=rsa-sha256;
	cv=none;
	b=dBHBO1NMQrrl7qmNmLGSACGbRTSNGkFEoiaLEZcbIJy0fk83ZJejjDvsy/08hM0kNAsr7U
	xE3irlkqypmffdLw12s2ZSU44pH9g0NnH6yRvmh3w65YbJ+WIZd2R5yiUMtCxtAGDFfwI6
	poBqxvkbwi1wYGTNlNAiZO6MJvN/oAs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=Zy2j7Trj;
	spf=pass (imf27.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.52 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45f2fa8a1adso3388135e9.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757933291; x=1758538091; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=T1HmJL9+VKEbFuhKNn/wLWZD0HnPqeDLmIfK2aizEXU=;
        b=Zy2j7TrjZhGQPZrDyNM3DKQ9lIa8KGCay6lYFW2C6/5uz1ElO/47+r6QYzruv0xrkA
         rBjbek6AtgOuvOVZovCiUlEia4FJmu6c1LvKd3IcEbCYMummb8CndQhAUHqgI+S7Wwe9
         rmuil7syGMhKyYQiVtmS0jRxW8XoUVeQ3huncqPrC/NlYtkvhHlw2ayZOZYbTJNjUlJ0
         ktdO0ob5po7HYHaM8mdPe6RHxd4PzxAmmUtv2u9rTKGhYbRhL7z3Q01/EbLQBoZ3YrtL
         OSYn3M7SdsnIbwnf6FECWuSESHrmBiUEMxxBZaHofZfLi2jx00u4uX0i8fqRzv0CObhZ
         tHmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757933291; x=1758538091;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T1HmJL9+VKEbFuhKNn/wLWZD0HnPqeDLmIfK2aizEXU=;
        b=OSlJgDV5V/1IEaNZs9Ft1VAWrVjEalIx/5zbGuYYVInTYxPPuNf2RnixiA/LGQi0ZZ
         4iy6HFDUDWboSQGRDJ4rFMkfCf55eZljMsadV0ES8uSQ8PxYP2A5wD9pvMMwOud4GPBz
         ZTaputRg8+aPDjmed0mWKJ7zFHw4JEKBc7bghG8TN6S7pJv+61neWKYCPH1s5EJrQ+uh
         DN9wjrud30iv+aIvEJx0KCnN+GNrPh6NYElk0QwDo7ZEid0J17iMWg9U3Vh0+8Fym+vO
         Z1dq8m25SBR0vbjooc02sOCoaCRb4E+j+o6oXIbH6kMgF/cNERSuhXj/ttSmyyh9/596
         f8pw==
X-Gm-Message-State: AOJu0YxhP2n0tejBXm60C0g9SXX2VhHF30kt0Ni/4oh9A1jxrPpF4cW4
	3CFLObM6W+RLskvdGzBrENqKsdiSRIb3agCcWmX4u2Fy7B/Y6svM+xIKOPLVHUpD06I=
X-Gm-Gg: ASbGncv6C1xv2ldsEvTozDaPp4SlfWIeQLqTy+obPA+XD+ia+VoPoLgLGz0WwtggqwM
	yBlDJD0phIENW2hWAjGZOgB60UMNvJJPfhKj6LeIo5/d3XvNG+xarBUP19YT+BKlCUP8z4Hxa1J
	nZYOSbyeW59Eb8RZfXsYFk2fcg9/Wi2vRSlPxcfPF6bvG+rSjSdvcZxQl0Z73YnggVwizlfN65J
	FsqviW+ASV/yG1jgyPsaRLRuJTsZ79omNcqmji7HJKHJix+wsVFQ8ex7OLCj8bBanRGnkYnf8PD
	S8a90wV+S8pCFxf4+3WHXPaQbZ4ML5oZ7u0MpnuGYUS7dNthWxF5ICyV10RQy9jhPTPt+5rrhA4
	ioLeyzR5Ft731a1WBOigrbVR5Mmw=
X-Google-Smtp-Source: AGHT+IFgXvCtVTbIVTBJVQ9HeovSDOGU6p7kTKmEw28zufXdYoi87L2068i0E0SX/gT9/QVrhsWP4Q==
X-Received: by 2002:a05:6000:400f:b0:3df:22a3:d240 with SMTP id ffacd0b85a97d-3e75e0f032cmr13460040f8f.4.1757933291141;
        Mon, 15 Sep 2025 03:48:11 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3e7607cd6absm17408269f8f.34.2025.09.15.03.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 03:48:10 -0700 (PDT)
Date: Mon, 15 Sep 2025 13:48:07 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-mm@kvack.org
Subject: Re: [bug report] lib/test_hmm: add zone device private THP test
 infrastructure
Message-ID: <aMfu5z5l6q4IFpro@stanley.mountain>
References: <aMepD1FRu-2DfBwo@stanley.mountain>
 <d792f1c0-f393-4e16-97f0-36b4028c46e4@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d792f1c0-f393-4e16-97f0-36b4028c46e4@nvidia.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E15C04000C
X-Stat-Signature: ut4z6d5icykaihjfico3emeny67wzace
X-Rspam-User: 
X-HE-Tag: 1757933292-299626
X-HE-Meta: U2FsdGVkX1/je/KI84+bGzrnGYpDZKDgXkxI/VXj43BXv4LJC5QZ1vU52kXBb/MSePXtk50Snav5jRcj2nAEg4wlZ4B34NHGyV8/pZm8+ngaKmdE1R2SD1f3Ip/t/rZnDQOHAn8/MLGlHaUn97dON2phVUe6C5Nrohxg/27l/QNbYBO+iOVVonB95yUi3+hVZqBUxdcdExDv0Au76SJbIDtMGfsEumoflghMt7eT/qmLk8dCfC/Zi7kBw4DGKWvngJ0nqNOpyGSier8Ul1OW0msaUdL+r85/pcCCX7xGsH4HCC2H/26C3OxdxBnzeq2W/TWGi6JtdDFZzdmySUdeXX6Z3G8axXrcoE7D4v8i2/1+bIaEATMIFtrKHfo/JmWUmFajSIjYLehi5astRgml4htah2yIcFM/XUqEkpZUeMbD5YfwhBvK4R5pDiCQwBPYRinxIdyfURhcnrEzbKl7mcsq3IfCt/M84cEprcZdzCmvSKMCfG3sGwJ1+i3ExwNVpBGmTDXGv1G5SX4qg+9TqPRSMFq6qU8h8100H5BkN2qHHoKwEUGp/liaBNhixDsaAzqhD8y8++piYfgP3DZKXWG8sbIhqiZZmPPd9vk/7WA71AlNGdG4CRIG2MK3wxP2gpfJHjNxfs7VeD9orvb70iV3rUzVAtyr5iDdMinqx9/SjsHj5oHXYjO2jfcTHAWtzuZgFlSmm5UtWw8tiovDE9afimsumdlEpfzfZULjcx4UVVePp6VQl4sR7+elm3lceFNjuE///iBzE+jsu9YZ8w0ghG0tUsj8pxu+dkkf3eP1nLBvsuGyyfyTuAbx62AoKK0ulwrOJLyftsREcVqD/HvpYxWgC6jqWqjQrUhBU82z61lXC4GFAR64mxEjSpc0OBnTacrhELjgQFP2qSjNpYT/TMKjvwJZ1ejrvT4ZfzvSrzR6MRzGnBxNVjpzw/Z6nC+/31NbYwxU2VaXUUn
 lzA8NdS4
 T6iVfgfoabEJCjd13jlqsk2fROS8WoSdtYaYveToIbhdc91IiZV9gTocBtkWu6Hx3cdTs47kmNOo02OzShXircx/UXQZVbeaSyGni+vvFhTHAfwinImx/xDDfovQC7ONXjVAwRyOmDdnlxaK+4bKK/KJRnyraXdOeveW1RDO3sgFQqMe0tCE3R2wg83Oov1SoFw5DYY80s6mROHBbjq7xEUTuy+IF/Xx6uWg7lP8j2XStXVLd+t7n0tcTtvsum+xlGcD7D5vXNo8uyvo0y04rMNMc51cNKpYdhHgBJctXOYFyu6tqeE9EDvPqrtpYtEPTBz4P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 07:49:33PM +1000, Balbir Singh wrote:
> On 9/15/25 15:50, Dan Carpenter wrote:
> > Hello Balbir Singh,
> > 
> > Commit 6098c878b175 ("lib/test_hmm: add zone device private THP test
> > infrastructure") from Sep 8, 2025 (linux-next), leads to the
> > following Smatch static checker warning:
> > 
> > 	lib/test_hmm.c:721 dmirror_migrate_alloc_and_copy()
> > 	error: we previously assumed 'spage' could be null (see line 718)
> > 
> > lib/test_hmm.c
> >     675 static void dmirror_migrate_alloc_and_copy(struct migrate_vma *args,
> >     676                                            struct dmirror *dmirror)
> >     677 {
> >     678         const unsigned long *src = args->src;
> >     679         unsigned long *dst = args->dst;
> >     680         unsigned long addr;
> >     681 
> >     682         for (addr = args->start; addr < args->end; ) {
> >     683                 struct page *spage;
> >     684                 struct page *dpage;
> >     685                 struct page *rpage;
> >     686                 bool is_large = *src & MIGRATE_PFN_COMPOUND;
> >     687                 int write = (*src & MIGRATE_PFN_WRITE) ? MIGRATE_PFN_WRITE : 0;
> >     688                 unsigned long nr = 1;
> >     689 
> >     690                 if (!(*src & MIGRATE_PFN_MIGRATE))
> >     691                         goto next;
> >     692 
> >     693                 /*
> >     694                  * Note that spage might be NULL which is OK since it is an
> >     695                  * unallocated pte_none() or read-only zero page.
> >     696                  */
> >     697                 spage = migrate_pfn_to_page(*src);
> >     698                 if (WARN(spage && is_zone_device_page(spage),
> >     699                      "page already in device spage pfn: 0x%lx\n",
> >     700                      page_to_pfn(spage)))
> >     701                         goto next;
> >     702 
> >     703                 if (dmirror->flags & HMM_DMIRROR_FLAG_FAIL_ALLOC) {
> >     704                         dmirror->flags &= ~HMM_DMIRROR_FLAG_FAIL_ALLOC;
> >     705                         dpage = NULL;
> >     706                 } else
> >     707                         dpage = dmirror_devmem_alloc_page(dmirror, is_large);
> >     708 
> >     709                 if (!dpage) {
> >     710                         struct folio *folio;
> >     711                         unsigned long i;
> >     712                         unsigned long spfn = *src >> MIGRATE_PFN_SHIFT;
> >     713                         struct page *src_page;
> >     714 
> >     715                         if (!is_large)
> >     716                                 goto next;
> >     717 
> >     718                         if (!spage && is_large) {
> >                                     ^^^^^^    ^^^^^^^^
> > If spage is NULL but is_large is false
> 
> Isn't is_large being false ruled out two lines above?
> 

Ah, yes.  When Smatch sees an impossible condition like that, the
assumption is that probably the static checker has messed up.  So there
isn't special code to filter out impossible conditions.

For some Smatch checks like the uninitialized variable warning, then
warnings in dead code are filtered out.  But the line with the warning
is not dead code so it's more complicated.

regards,
dan carpenter

> > 
> >     719                                 nr = HPAGE_PMD_NR;
> >     720                         } else {
> > --> 721                                 folio = page_folio(spage);
> >                                                            ^^^^^
> > the this will crash.
> > 
> >     722                                 nr = folio_nr_pages(folio);
> >     723                         }
> >     724 
> >     725                         for (i = 0; i < nr && addr < args->end; i++) {
> > 
> > regards,
> > dan carpenter
> 
> Thanks,
> Balbir

