Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFB07CD4F54
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 20:17:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC69A6B0005; Tue, 19 May 2026 16:17:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D76726B0088; Tue, 19 May 2026 16:17:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8CB66B008A; Tue, 19 May 2026 16:17:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B876E6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:17:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5DA191A09EA
	for <linux-mm@kvack.org>; Tue, 19 May 2026 20:17:42 +0000 (UTC)
X-FDA: 84785279964.15.4DFAEB1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id B0BEB10000B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 20:17:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BS7h5UyL;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779221860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JgwMblJfIxEmaANWEuRgc49UNNTEJj4iwpCYVZQxH64=;
	b=Ufz0FK59Gbukw5gzsk57Gb1pEdZMTA80cAmP31Vzd9ux10TbItKxh/gJOHOXirOA31sbFn
	DM3n3jTRmiMzRlnZQY3XyEfAyhu/7AXqxknzVaNyFdv1AEnBoh2WEr7UwqBazwRdrpSrlC
	KOyq1t0VS7QNheyer4eBsfEAeM2nEuc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BS7h5UyL;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779221860; a=rsa-sha256;
	cv=none;
	b=FEW71bYkvfNuF7EMI2SBIsDwaEQcoXUIt0NrNAw6QqDGhtq3113uW4dSzTl6pYLCCRuS5G
	nWlmrcjFbyGqTzsyQzTiHKLBOkT3AJUh+mD7a1WnUnHQNLF5ftK/tBDfHzP3G1/Af3gqnM
	/XlZI3gLTTbfqlMRSvoBGMUosfT/aIE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 14C1260216;
	Tue, 19 May 2026 20:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503B81F000E9;
	Tue, 19 May 2026 20:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779221859;
	bh=JgwMblJfIxEmaANWEuRgc49UNNTEJj4iwpCYVZQxH64=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=BS7h5UyLvMIY/o09LiVQZ5odLA7cvPjyIpzG2hY0oyp57jnKokHf9goMsQ8jOlvwn
	 7J7BT1MuRvlHydrdp9IFLZAzIyrf3jwDV7jsK4nsYIh2N7RHXQ9Q6NRwcF2yuVOzTm
	 srRO+peKwLofUYR8xTKXKos1EE0OUwgvE+G13Kp8=
Date: Tue, 19 May 2026 13:17:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 catalin.marinas@arm.com, will@kernel.org, urezki@gmail.com,
 baohua@kernel.org, Xueyuan.chen21@gmail.com, dev.jain@arm.com,
 rppt@kernel.org, david@kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, ajd@linux.ibm.com, linux-kernel@vger.kernel.org,
 Wen Jiang <jiangwen6@xiaomi.com>
Subject: Re: [PATCH v2 0/7] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
Message-Id: <20260519131738.11a78ba88e1be28ba5cb26eb@linux-foundation.org>
In-Reply-To: <20260514094108.2016201-1-jiangwen6@xiaomi.com>
References: <20260514094108.2016201-1-jiangwen6@xiaomi.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B0BEB10000B
X-Stat-Signature: bpp7adbnezeg8o9hgm59a3q1yyuadmek
X-HE-Tag: 1779221860-193351
X-HE-Meta: U2FsdGVkX1+nHtievOvytplBUp+mOdx2CAEHAmZGMabl+VOoWsljmYYs4FRm92IkQC4ryuWO7mcKqMhZ8HQHuBX+jpYkSGSnD/qx60v6PwRloXXmEnJQZ1rATno1b5mVEFLecqma6UTQRCGHVfSFyS1ui4sA9PnMyNj6U538GR2slnCB2NqPisyn9APMHGr7cfGWDT8jz91ojRSU+fgaNFznQI2J6f5DJkx1H+0tgcXrf1HogudDwmUUcmgpHK5GNHF6keale2LPRtVT6XsIfq2ynhDjmkSzCeAoscQNXubtJTS2OCd9IbkUGis+1FD1pH5Zt98kEGnSzmz2Lszl+TIyDVir+wsdpAyIpQ4NQPZ+/LRgsH1Fgryvd+ySZbn02dw6xVs8u2S1p6ZD2VdzzmjZItOfLm1Y6easVe35KE1Jss4w10mqHcpOmLeprin4PNLBrepSGZbxqOAIJ5pLx5jlkr5vqcNaEQPE9DOWtmOGe+ArUiGMindbjxgXeZ8gRb3AhL9ZCm1Dz7AxkYtCy0AgZ5iTSAl1Pnu4USrIMmcArUQQYshq4gULuUVqoxiShOtNbZwvX8V9q8coKPsk5gv2wLv/0Yudl02lp7WXgeyDn0QhyhGZigNAHekqccKZKD4IXc3chW3zDJmeP16R0dPVuKMFRQ9qBLIJbTKchre96U+Fhfhk++4ymAt88cmt5h2SX2JIkzm4kvJjThnvhPYELB3h4yR7PkikaS1fnXrMm/fJMC8JQbwZueNRkal9ZRqvLaebjnbGICNN+cfcZNRMAiqcqKvVygLmIMh4RnFveln9xebukQ92x5PCNq2tMfzbvV31NrjIEB+nL9DqJyLibkZ3cY3xAj6Rlg50NfW4E5QJygwo0cktMGttUuBIxCJMkDfXlm7ElT6XgdWm6Fa91mhjAzOCcHn4c77H14gzc8n4DSafCxxBSVillMfq/dpjGb4t4GR7pEH7ZVa
 5x7B6+Cu
 A+dFvag+6uD84nFGC0K3PJdNAKUVczm8ZRggQAOUztnkw4kp2NoU2G60sePCcr2mhU2pq88r8jdTVHhizWoEDo9dMqeuV2bu2MmdnfPz6wRkzXQiSFw+wZBg10G5pFBR5PaF0BrDjG4SqMXC5H/4+XuCCV9LVy4o4uj8HPV1AwgfPueHqNN72N2NHS8wI86oGGPadQwoj/4LYFFTDf8TgdbFucSJvEY92uYgfgoNUUXxxpinPz4z5gBvBmmyF4hOZpLztagxP0j4wEBkovQrK7+NEbqoe+pLVzcSNTI03XkI0/XiWOiif7FzWy9rS+woCLv3qRzu8W4Ia3uFk4npQ2ApYgkRevRNKhT7CIvZ4NzWnY/9s9xtIymGz3gmCl/qUf4FfywjYdQyfCJ0RR/beR3CUEeN+5INxx+u9wjPJB/lRAQo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 May 2026 17:41:01 +0800 Wen Jiang <jiangwenxiaomi@gmail.com> wro=
te:

> This patchset accelerates ioremap, vmalloc, and vmap when the memory
> is physically fully or partially contiguous.
>=20
> ...
>=20
> On the RK3588 8-core ARM64 SoC, with tasks pinned to a little core and
> the performance CPUfreq policy enabled, benchmark results:
>=20
> * ioremap(1 MB): 1.35=D7 faster (3407 ns -> 2526 ns)
> * vmalloc(1 MB) mapping time (excluding allocation) with
>   VM_ALLOW_HUGE_VMAP: 1.42=D7 faster (5.00 us -> 3.53us)
> * vmap(100MB) with order-8 pages: 8.3=D7 faster (1235 us -> 149 us)

Nice.

AI review found a bunch of things to ask about:
	https://sashiko.dev/#/patchset/20260514094108.2016201-1-jiangwen6@xiaomi.c=
om

It doesn't appear that you'll be getting any more review on this
series, so please check the above questions and resend?


