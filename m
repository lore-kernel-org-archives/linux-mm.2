Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7621DC531C9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 15:25:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C88D6B007B; Sun, 26 Jul 2026 11:25:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 251D66B0088; Sun, 26 Jul 2026 11:25:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11B546B008A; Sun, 26 Jul 2026 11:25:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CFC566B007B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 11:25:12 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 53323A051C
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:25:12 +0000 (UTC)
X-FDA: 85031301264.24.4CA965E
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7C8891C0009
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:25:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HatXcHc5;
	spf=pass (imf20.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785079510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hrZzytWG33HIkttwtiI0GBdDtPqgitxwYOUNbEboLhQ=;
	b=RTN+4B+3CDRmMmwNlpdCpp2Zw2dBmd8O5reEdxb21KghFh0RiuaEtO+KGeoFleIwnukzqP
	JA2V+OCQ/CwEeiZnE2Xh+XWMwwtYLKcAW/hD8COl1eP+s6kF4vfqo/uQpR+KfWJE+0/5Tx
	jmfUb4cd7LGqnssRkeHCbTFFUTg2vi8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785079510;
	b=58LfeRg43Td9KirXbi3LIQydWAlLch5w3eyx9vVWX9tfcAHRQdl1hzqI2hKSPujEucOxuz
	4imty66Wy5B/B5OyHIU9UZmDnyu2hN1SQbTG+CBJxBd7RNqndZ+VEAwkhqP9afQwOzet8X
	Ot28IpBK6FxM8wDDCl4F6R9/4ug8B6o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HatXcHc5;
	spf=pass (imf20.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c197f968b3cso270814066b.2
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 08:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785079509; x=1785684309; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hrZzytWG33HIkttwtiI0GBdDtPqgitxwYOUNbEboLhQ=;
        b=HatXcHc5F1VBBM8YT2y19ADqte562ZS1cMS5CfJvOrWGsBHMZNYI4bWsqvFxORLkC6
         d1m7NyRQh2sitpsUyVuTmCwaTcX0UeS1OUcq4oeiEgOwOtQPH84QvmmjxBS3Q9ICj5uk
         QSuYKlH9tM97egY1QOQ35spmIemKfRrdH8aaMwXGjSlXs1oARPfbBPWdpSCh0EIN9DPV
         JthdLKUNFGlWg+dq5kX1BPTJv9Ob/Gm8rH3iyoN8DpZreYrNhKUkgeoEFoKZsGTfi9aI
         wI1uUcX24l39MMri+jMsaimJtuhmYrmzBUDBLAGavKjBw3HVXMOaXyHVkhzDFjiMsLR6
         RjXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785079509; x=1785684309;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hrZzytWG33HIkttwtiI0GBdDtPqgitxwYOUNbEboLhQ=;
        b=jlhqsP06VhIL3vWyAujOZBcwvgOxtrmlVRv0Ki2cNTovdF4O3w1timD8BU3foMBMxc
         EXCE0XArlrgFDL4w8kbumQ3Y544UPeQKgeJmNjCdUCDRPJJM5EA4xa0DgHmJx88fnie0
         KlcE7bnb4scxCErcxX1bcWNBmh1McHQMxqRB31FI43lw+me1LfWUov2g9jaZ7RSIVO13
         OMRxyONcCakOk9byGrp+mbmQUqUjKPhDOO37utuN74pnPOMDNq/7IezdFbhebyW9+8Be
         z56H+PD1lyxrYLZt9ZpMvmcsvQ7fsHYH5fNdKfeco9tpbsUXEigvDBLILa1C/uR28yXX
         cvkw==
X-Forwarded-Encrypted: i=1; AHgh+RqJ7FXaGnB12LzweG2feCD2AC+Yu1uIBo7qJqhyk0yawLNbm5jqX4siIKo2HoRlUvSBmQ5ZyMMU6g==@kvack.org
X-Gm-Message-State: AOJu0Yw0qjCLb5i4WUXXG998lQ51PTJGBdLH9t5IS65Dy4joF39bh9/l
	r9LgFzie7V5oYDFZl9ab/93HU/S6YaTeS2s0On8PLcqjxNsnOgY0/05Q
X-Gm-Gg: AR+sD10aqwVNW5Ntoo3JOXwpYMlpDutBfWmgXsyzsweLpo90SxIdTBgOLwWLyQdIV3u
	j024IxGeEcybiFSNCQEW572DT/O4CUoJW52S8Ufr+YgDcJMzVbSZY1VQ72mZlZPGaPahDJzHeb6
	GBO6pfh1b2WAI/LTMMlOmYJXnvS/jbuY7Y1nFJZ6m6qGhwAGN0qjqf14XBshd2PoyOsYmM33QUy
	tEhzbkUx8LD/H8Wrvl2SntPQ7o29rN/91gd5auX81QYYFghPK2PMVWME+E2maLbDujPxJLHkZWw
	uOuwc7+fdYsFS6NvLG3zHc38rhrAjtdosRCdAZtwMNGG0Qe2141lhCjsH2VOVMZ2HTPLUlUeUXJ
	fNPMd9/DewIk1oauBM4amCf/KQDfjv+GpMkrnENWGBBc=
X-Received: by 2002:a17:906:794a:b0:c15:c1ad:36dd with SMTP id a640c23a62f3a-c1f1eabbad5mr214982866b.6.1785079508823;
        Sun, 26 Jul 2026 08:25:08 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1c32ac936dsm559433666b.22.2026.07.26.08.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 08:25:08 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Sun, 26 Jul 2026 17:25:06 +0200
To: Andrew Morton <akpm@linux-foundation.org>,
	Artem Lytkin <iprintercanon@gmail.com>
Cc: Artem Lytkin <iprintercanon@gmail.com>, linux-mm@kvack.org,
	urezki@gmail.com, shivamkalra98@zohomail.in,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/vmalloc: fix 32-bit truncation of the area size
 in vread_iter()
Message-ID: <amYm0nL7fn6qsTF2@milan>
References: <20260725132201.88279-1-iprintercanon@gmail.com>
 <20260725144834.76cd9aa557e72aa02688948f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260725144834.76cd9aa557e72aa02688948f@linux-foundation.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7C8891C0009
X-Stat-Signature: dwrogim8zx6t51gt44557ywph4idy36p
X-Rspam-User: 
X-HE-Tag: 1785079510-876074
X-HE-Meta: U2FsdGVkX1/QwGD2MBYqoshPFJ68p4XxejrmC/zAMRiGdP5K/oXZIL/8afxYY1XftrGkqG3X5tQNau5CXsRaXgtqZXph4gFqGtE414s63/KDSvuqaglNCeqOh6SIoIwEBb3xWf1947I76kXP73PXxpi8Y8zFNG4JgS9a8P0xv0ANJDQQwTmo/qUx5IeP3s/DA1Or8lqRfsp6aRoRRK+1fNTGet4zBGog1qjNU9iJczoKQRAxzOm4T3NTKzyHdxejv08llnfL6J0A/aLtcsUpxwxHjkf6fM8OrpCKbopGJeTQHxiaWAIuKWdroLwKOj87ybY3P9UqCrJMeeItIOGs4f5nzmYGRiwItvnHVRkN0eTQmwvh9UP3g1oo6rtP9hkr8t3bu9Mod7SpOkJmBT35EcfBd/8wIA8mM0JoIsQOuKE75PAJgtJYZXoYeLU0TJZiG3bDHNKeWVY53I1xvdE9WVoMksygUxAxEE6wXkYoIgth1I8RUDf8tHuRI7EXuc342PyPdXhbohpZlUiJD7gxHDpQtkA0WPrLhYUJA3euQ/DSKlCES+PTmEx1x8fAhB0CzxTqOztN79dxpk7gN0zsNl79jbnr2Dv7RHsBSzpGxiT2k+H34AP97qsbyQ5TNVxamNAu59GvcAL0PNQFyp/VNtVoMkGI91loqIu4tAKtbVfKeLrr749tDAK2GfN1eTAK+vVykjIAXXLaUPfwwdaqYP4reuN1dKP8hrdm7rYsujGi2HBCQHf3UFdPePDn8Nyx1gECJWTE7t/chglCddsDCSl2ILfBPisQMRJICHwYYteGYJRSP/aCxYNUqNU6/SnuDrgZ/EVnjZkLCIIkme9R8NWgsovkEIc4JH1+uAS96Q5IA6xFZJ6vFBHJquGVEL9WAsG10N7TUE8LTsK0NCx/H/OmWg7o6GFpGNsqLCn6RnyQeCI+1zyUdyVHRlzV1aruWtoiSHWDYUX53HclC5C
 n0t0Wswk
 d6HI+gFik5yHeD8v9mDu5+7y3X9hgpHc5vrOWZACdkgdFZOY5OzTK2sBI2gBaflZWfckn+UtHxr4E62cxUwhPmDTKYCcuWwKl5PJ+lvcSBgNOYSHm+JRckYlJ+QmKFgXXyyoBGz3p1Naf4sElWvrd8USZM4RukErYTo+YadTTesZ9QYb+pm1IlzYvfGyoo7Ap/T+m7qGgxg1HU4bs6rxcql1aNTQgHFlHdyISXGPat9Bgh6aD2BDJkctQIXuZ6g1A40ZrwQDvU1PL4lcHS3hiHdvbfuJyBsSmobx3l/Iq1ixE/AotYsNuMubX9ENP2YkUStjjwkXqnnryzLBCdHRK1rFuJgR86PEgwjqDYuXnV6Gw7IQilkDdNIA2GhTlHgzy8EUwMCv5mqYIV+PuQx5wbX0i5OMgF2OZ4saVM57O7c2x8Y6LEz4KozlwWDEEzlzhNbgxrTBZhmHckh5z2IAJUI1LPEhP+dKaB+bDecHy3vk/bHSt2BVqeECkHw6yrVODa5DcKa9/G7xCpZs6XXYs3OtzVkfzETltGZGmlxXr41jwq6s7uS4c0pDMAYfWB4gMv6FE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 25, 2026 at 02:48:34PM -0700, Andrew Morton wrote:
> On Sat, 25 Jul 2026 16:22:00 +0300 Artem Lytkin <iprintercanon@gmail.com> wrote:
> 
> > Commit 0bca23804632 ("mm/vmalloc: use physical page count in
> > vread_iter() for VM_ALLOC areas") replaced get_vm_area_size(vm), which
> > returns a size_t, with vm->nr_pages << PAGE_SHIFT.
> > 
> > struct vm_struct::nr_pages is an unsigned int. The shift operator does
> > not perform the usual arithmetic conversions: the integer promotions are
> > applied to each operand and the type of the result is that of the
> > promoted left operand. The expression is therefore evaluated in 32-bit
> > arithmetic no matter how PAGE_SHIFT is typed, and no matter that the
> > result is assigned to a size_t. Once an area reaches 4 GiB the byte
> > count wraps, at 1 << 20 pages with 4 KiB pages, 1 << 18 with 16 KiB and
> > 1 << 16 with 64 KiB.
> > 
> > ...
> > 
> > Fix it by widening the shift, which also makes the expression consistent
> > with the four (unsigned long)nr_pages << PAGE_SHIFT expressions in
> > vrealloc_node_align_noprof().
> > 
> > On 32-bit a widening cast cannot help, size_t being 32 bits there as
> > well, but a 4 GiB vmalloc area is not reachable on 32-bit either. On
> > 64-bit the cast removes the truncation entirely, which is why replacing
> > get_vm_area_size() introduced a regression rather than inheriting a
> > pre-existing wart.
> > 
> 
> Thanks.  AI review might have found a few things.  Most are
> pre-existing but they are basically "more of the same thing", so you
> may choose to address them?
> 
> 	https://sashiko.dev/#/patchset/20260725132201.88279-1-iprintercanon@gmail.com
> 
> I wonder how much of this stuff would go away if we were to make
> vm_struct.nr_pages an unsigned long?  It's already using 64 bits in the
> CONFIG_HAVE_ARCH_HUGE_VMALLOC=n case.
>
I was thinking about it in same direction. Just to convert and get rid of
casting. It is safe.

--
Uladzislau Rezki

