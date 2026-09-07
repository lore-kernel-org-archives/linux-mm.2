Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5477C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 06:03:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1AD66B00A1; Mon,  7 Sep 2026 02:03:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF2E86B00A2; Mon,  7 Sep 2026 02:03:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B309B6B00A3; Mon,  7 Sep 2026 02:03:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 974566B00A1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:03:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A5DF91A0664
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:03:38 +0000 (UTC)
X-FDA: 85185924516.15.003B5E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0CE671A0003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:03:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QIPJIqcn;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788761017;
	b=iLg3H8CmRh8MQn0zhbEETVWz75OdURheNrqvLW+ptQPVqutzXEkiUWw4BG+LSe1To0vBpL
	5E8r1v/1izPrgNAYsLQqSRa1cxOdTM6qiwJgFIMJE0UGAanLefxWj+caocDCq6+10BoAWV
	DDvb0zRgpZv4Q0yjPlFh+EJD1VckrCg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788761017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KWBg4m2wDtJRgYbxKBLwGfw2dBRi+ov6pvH3X93gXJg=;
	b=ATXOuMXNxcLfDlpBNLhmtJ/ROE6pmdvDCzI3HevAQRn/7f5+odbzcGdZTUKP4pugD3Jkuz
	rEdMfyAcWSwaUmSdiPbCiOeA4FJQxwVgdVYWPwmfAJTOjOnFykcsn8FOEdtSnfcpVekhAf
	vM+v/azFmdQ5frUtFR/aQiuGIDjpkc4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QIPJIqcn;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 63C6043BBB;
	Mon,  7 Sep 2026 06:03:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8080E1F00A3A;
	Mon,  7 Sep 2026 06:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788761015;
	bh=KWBg4m2wDtJRgYbxKBLwGfw2dBRi+ov6pvH3X93gXJg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QIPJIqcnFHP0Lub1MpXj6uRKUv0FSKOwY+sKSOczIkurDFVg8DJ/zw7OLg5EB1ma2
	 4f0nD1HaGoa20C0MK76SEYuvFrXMDliytjO0IYEiTMoFIOq+M5I138pybc42UHA94d
	 FOCqIBC6kJ76AIN2jWAkgAIjdaufr79vdXXUWUzVc+bl6XxXw5qNChplpmxaw0oQIt
	 64JewSBIMk61QWyocXlPGeqiA5+54lMnNUrXjwqq2CMadvw+trfiqKrzs+JZxbVx1D
	 czt5lT+NJ/uSVNKO9dDRZFe50OVsDUXIcboFdDYOzOx2mjo5h5nLUzUCYAY0hL7gnx
	 asXnfjRtMbFSw==
Date: Mon, 7 Sep 2026 09:03:22 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	usama.arif@linux.dev, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	kas@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org,
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	luto@kernel.org, peterz@infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/3] mm: make persistent huge zero folio read-only
Message-ID: <ap5Tqu5yswJrj5UM@kernel.org>
References: <20260901151818.3191443-1-xueyuan.chen21@gmail.com>
 <20260901151818.3191443-2-xueyuan.chen21@gmail.com>
 <apk8ZRr6do_YAlzf@kernel.org>
 <CA+qSx6wqd5VSR=9yarFFmyN1SyvLJqEHpA7BwmzuxNQTHbS=Xg@mail.gmail.com>
 <ap05ue1pq3TgHOS6@kernel.org>
 <CA+qSx6y=OaMsvTKUbPP2DOan3Ym6c8L5z60512-tCYeUjLZz3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+qSx6y=OaMsvTKUbPP2DOan3Ym6c8L5z60512-tCYeUjLZz3w@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0CE671A0003
X-Stat-Signature: huyn38k15jg4biszu768bnagj87rg8pg
X-HE-Tag: 1788761016-36385
X-HE-Meta: U2FsdGVkX1+Z2tKtwXdL7ewoBGfngscyjjVt0rK4wEI9hTi4kT6ROhsIsIFDT4bWDycGADY0K8aKM0JXmw9hoHu/h0JMJS9DM8AEgD9PThpQaeY3mfc/1f00z0LXuByt3kQ+Gd4u4vCcxIgvuY0ospxlBVujvAsEQH/vNub4JmDmyxtS49CLEmenjLMpHoS0i00EeS1iS3XKsocPkJ/B9YatCDhZ1w6+0dDxRHi4mAzyK0Ek6JLxrT3L+Zd4hXLgdjXgR1Pe0PaVKlHcOluxocYt+4N+VYhBQu2yKCx/69D9QRK2pLozFg5gVegbNt902AzVltA+IMSmL29yDYhhMQeKupi1omwxTl5ooOX7w/ansVnX/0MhYX38ZPHTmcGS+gAcoceJD85K8e26CMiXIOJhrIyg+dSwWk5Jwa5bIlTl72Vqkkjxv2jdDUbT1Ae7hgUJUdAhszUsK22Ero2eQpXAxIgY0lRFExvkQBqzkiFDiT7NuteBZluuX9CKgYZEt3F5ADxh839ssaAc31mzCwVyFM9wtuD4m3E3kxqDDvlkJvxCNt8jPXBH5h+Okd7wRtSWCCpbiDaHbtxFJSx1bnEDkOxOOmyxH7SHVPgWyqB4qMmCT5DWc4fq3kuLBs31v74cF9i1uIKpt026+N62nUFBNvn9precp5y1la6dYBleyqldO6ijorCR3I8geo1Qc1aC2sEWxsIL68HzPQfsHJMBalsH2IeZzMMA0Re3TSu2PqUpuVSU36KtS4jNmTfXNEn0ceOA1flxVa52PQpZi8jvzj2QndIAhwsrSZi9Qn+Bge2TIK59S94mH12MLx+LtmPXRCjHJCEx2PlU9wia+rqXTkQrFHGVzdFQXjrLmRAxYFQzHmu3C2TQL1mqpc70sI6ujfU5RwaSB9deBqIebvQIFCUa6WlFdTSAvVRILzlxjaZTzON33YcY357gf5wDb/yHwn2FsAz84gKBz3t
 BKiLHPhB
 RG2Z5lq+afZzEnpZXE/K+gNphuLHLT91HDOJjyRKSLPoSKMWsDlR91PmJyGwPQc8+XNJFXm7njozKm51FFGAV5Zv0sDeesvwAkHevPfP/Rv8rSd4zXBjQ6QwAtH6RPOEYxU4n2FaFe71xmYtMrw+VoWF0BRCtOu0/aTEAeAGWY+Y6IQkAQkZ/rTm+Qnhz1g2MZTlehcqsj4hHm+ZFMsoKMtWEys5dDrp9Xx6UGkaTuUbrn9EGpV8a0AGQ9eU1JYnRf/CXdZzaJHGqM3SwOtGhM5hslTLOJ7E9fsCCMk6EaIXEfXX9MqJCJsH5tgvUf9I6wk7mdvUwfR/efeavILLvWQEOooqpMjHiSZSNY9Iw4dNioT/e5XpwgRuJdQoTUE7VQ2R6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Xueyuan,

On Mon, Sep 07, 2026 at 09:11:14AM +0800, Xueyuan Chen wrote:
> On Sun, Sep 6, 2026 at 6:00 PM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > > > > +
> > > > > +     /* Highmem folios have no permanent direct-map mapping to protect. */
> > > > > +     if (!folio_test_highmem(huge_zero_folio))
> > > > > +             set_direct_map_ro(folio_page(huge_zero_folio, 0), HPAGE_PMD_NR);
> > > >
> > > > Sorry, I don't remember if it was discussed previously, but why can't we
> > > > use the existing set_memory_ro() here?
> > >
> > > Hi Mike,
> > >
> > > We want to change the linear map here, but arm64 set_memory_ro() only
> > > works on vmalloc addresses.
> >
> > I believe this is an historical artifact. change_memory_common() already
> > updates the linear map when a vmalloc mapping switches to RO and the system
> > supports it.
> 
> On x86, set_memory_ro() does work on direct-map addresses.
> 
> >
> > I believe arm64::set_memory_ro() can change the linear map in the general
> > case as well as long as can_set_direct_map() is true.
> >
> 
> On arm64, I'm reading arch/arm64/mm/pageattr.c, and the linear-map
> update in change_memory_common() is only reachable for vmalloc
> addresses:
> 
>   set_memory_ro
>     change_memory_common
>        area = find_vm_area((void *)addr);
>        if (!area || ...)
>           return -EINVAL;
> 
> So set_memory_ro() on a linear-map address returns -EINVAL on arm64.

And I believe this is an historical artifact rather than necessity. For
configurations that allow set_direct_map on arm64, change_memory_common can
update direct map too, it just need to be implemented there.

-- 
Sincerely yours,
Mike.

