Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A037910FC450
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 21:58:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10DFF6B0005; Wed,  8 Apr 2026 17:58:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BF166B0088; Wed,  8 Apr 2026 17:58:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF0336B0089; Wed,  8 Apr 2026 17:58:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF7466B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:58:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 507851B712C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 21:58:43 +0000 (UTC)
X-FDA: 84636753726.04.66C54CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8A6F040002
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 21:58:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jK/fHVBB";
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775685521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gLhQk/GcRQzTBdz6Sgw1idF6hAS9xniYesYPBlEvfFA=;
	b=Rd3sopyKamx1VWMXKqVK8NzaaJ32I8mH995d20WcasM7e70P7/VwDd15Nn+FAF1IJQYv8I
	q3dPGQV/KGHcA2eJItgIq4qq6BxWqZ3O9rFtoFw4nwam8wXV0Shu6Vstj0L9XmusqPlP7Y
	gdFyFQ90HsYXG4gEzQie4U+oNdKywJM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775685521; a=rsa-sha256;
	cv=none;
	b=LkkdgosBCkg6F5H7xnc63iiA/e101fNazXREBIOkhYzPbIM8NT+TOsjRWapy0V3VzQjtXS
	bxtCz7PWmD8z3kdwZ4yIVvIdkA09aIQdwng4DGOnCnlyjvdCl9BsmRdIZg73sIxXdCD5g6
	ZiuhSB2rcEqSexvt5X7qjQ0u/pbnsPQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jK/fHVBB";
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B16E6011F
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 21:58:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3007C19421
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 21:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775685520;
	bh=gLhQk/GcRQzTBdz6Sgw1idF6hAS9xniYesYPBlEvfFA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jK/fHVBBlK8Ch5c2VQhERNpXDMnvynf/9nH2KPuDEBFwZfWST6DQyIjTJL3EvSm5f
	 XPUnFmF6vlE22ttrL3Jxm5IeUhengTQK6+LQNaMQs7boykglCj82Fd6Y9n16TeJm8f
	 FqIGhZGd8h2h+OkzfU/p7JCtkxvEQ0RsnFQ7UGzn4e+ROFoxZLKZ1M/5/2EW188Sc/
	 6c3qeqfu+SKjWSpP2MuiMHWLyd6oWHCqJHIvhcKD5eJyCR4mlBSDvTfZuVcMS1wocG
	 1iFw2S0xyciWKypOtwhhwuy4DQsAYGEdMZWH0b8DxtbdffzjYzm4HNx7dDfWBPtxeW
	 meWXSRtBZgU2g==
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-50d58c513dbso2186211cf.2
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 14:58:40 -0700 (PDT)
X-Gm-Message-State: AOJu0Ywe6Ys72Emh1S86SYKe4vTWFNfEuce5lagXZDstc+mE6JNC8Z/H
	yTaE78mBxO0r5/yMVKz5koQ2wK2QfYxYE+jKM/qguf80Q/ziTcs881SKh49+0+kvARNm1NrdS6g
	3eOSDm9GP/9B1iEl90kU7lnuj0Gmxkko=
X-Received: by 2002:a05:620a:280c:b0:8cd:7271:65f0 with SMTP id
 af79cd13be357-8d41da56bfcmr3255803085a.44.1775685520089; Wed, 08 Apr 2026
 14:58:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260408025115.27368-1-baohua@kernel.org> <20260408025115.27368-8-baohua@kernel.org>
 <90cfbbb4-9f75-4c67-a1c5-34780b2f7108@arm.com>
In-Reply-To: <90cfbbb4-9f75-4c67-a1c5-34780b2f7108@arm.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 9 Apr 2026 05:58:28 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zn9KcA-KXTp3-F6uCe-AEiqrawdwFffBvxTJbDVwgyvQ@mail.gmail.com>
X-Gm-Features: AQROBzCoMjacDMsJOO1TbJJq704JVsHCBUimPGPOnAYdW4abGNDECmY_PU-x9sA
Message-ID: <CAGsJ_4zn9KcA-KXTp3-F6uCe-AEiqrawdwFffBvxTJbDVwgyvQ@mail.gmail.com>
Subject: Re: [RFC PATCH 7/8] mm/vmalloc: Coalesce same page_shift mappings in
 vmap to avoid pgtable zigzag
To: Dev Jain <dev.jain@arm.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org, 
	urezki@gmail.com, linux-kernel@vger.kernel.org, anshuman.khandual@arm.com, 
	ryan.roberts@arm.com, ajd@linux.ibm.com, rppt@kernel.org, david@kernel.org, 
	Xueyuan.chen21@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8A6F040002
X-Stat-Signature: 34q49a8ak15w5zgroengmmmtukdb8pq6
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775685521-746862
X-HE-Meta: U2FsdGVkX1+7MAWWdaSvHQKBGJdL2bhtAe0UvIIPGnpoWK2h8XU8DREVJIf2y/88EtoSUZn+T6cXTZz09C0VG9t4LjZ0bddHuUF8UA2M8ijGC6j+PeVpyCKVd1W2MLhyL7VPWTkUbasp+qutTKOcPFOsqLxZTeyXPJvtvM0Dlx3pLzE/9S8VKchdWlQpZwe0Bkb3EmyOtncMH6PWZvNgafgy0BKwZYqqpgw/nTHk1MlU/oShAvNIH7iMhSwr4J++nLqRt4mAkBVPpIvPQSLsIZRoN0RH4/01om4MKww72wFv53RWLcfSgzWpROoNV2bHD0N16p54gc2zCGIOGXICIYHyk1rH9y8fFUm2FAAQ2Q/sHgW/FVbVqC3OsncM68uxQrWwLWWW05ZuovhDNZb56jdMhp9ZIxHGxSzYOBWVu5OgC/H4+skLVhqWPzRbiX/SCPuz6OLxizLha7/fT1dQ19rk4S2rRsjtTDqq51tc6Z1yyj+utA+sK5TpaJrElVZQb9j3mfjmmWyZ7RhugX61lpNWE5z096AKNJevnQar/hh5TZ6crrYpsirh3ZKU3GufFM4LaZKsQ/OI3An5rE+Z/BxLGNeyJ1wQlfizwJ9yaODd2aivC7P3Tg2P3GyJp5x/kSyCLzeVE0BtWXPyiRIMDrgFFS3ZZQL6JtzaII6Y5Ml7kP3RGeHlQSoQ+bZCNqNuZGmlbx/s2HSIqGZNhEutYE3SqC9KZolmGIU7QZ5wSB7XeCkbeORD2zLrL+h5mqZr39vdqPdrBnJ0Pj/9BnLIM0hwsHCsc9YfysUSXvzJc9Vs96GvoUra9a/V5aNBVBFjhpgJYg2MrxlbCYXPWgX/Ment+WaDqPgBBnBDSrie7E4Mmum6Smp49pAGJlh4m2OabRKDfhl+6Xy2pjJvh6SeoHTnTZES5vKcHk0cPyUygAzD2BgVARG0K2dS5j+el8WeJUry4QECEb6X8JUYcf+
 XAotFs3Y
 cCAyEyQAKZRCnlkjRyXDh7zDS75TjaNtzjwGm9mMzXQBbaAHb5DYIRGpLXNjqG++1ffZoVLPP5XfSoHkz0rg7TjllHea1mJRaCPZ8bgboZVESBmNw5HYvplMsrZzI9O1aOxHofxg1BsiFvtFQ9k8Kjc2xZR137jhNWRwUZEEHSdoDIkcTDFtrJy3lbmR3sE7Yg7721aUCy6f1s3/xuHYY39scihhiKUceBjE9ed6tU35QNNRw75vRLoaMziQQzQCAMGE1yUW0io/t1tAwB4IlZ6u4WPlZLFwXu449AotA784oCBkLe4oCTpxpsdSalgmxsUC96cH8PxYFiO3kxKT302tIilZm+O4FPqU6i9ES+qUtCTZhb6mV1b/5Z1OCMcA1R0xVS9VxqtEufsnDKw4zJA2EweKfEAW1Ect5UdBTwCVz5Jbkrh7U3RZ5NjaK2DsO7Iwa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 8, 2026 at 7:36=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
>
>
> On 08/04/26 8:21 am, Barry Song (Xiaomi) wrote:
> > For vmap(), detect pages with the same page_shift and map them in
> > batches, avoiding the pgtable zigzag caused by per-page mapping.
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
>
> In patch 4, you eliminate the pagetable rewalk, and in patch 5,
> you re-introduce it, then in this patch you eliminate it again.
> So please just squash this into #5.
>

Sure. I guess I revealed some of the development process in this
patchset. The patch was initially written with page table rewalks
for simplicity and then iteratively improved. I agree that nobody
really cares how it was originally written :-)

Best Regards
Barry

