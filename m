Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7769D711CE
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 23:58:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 429236B0088; Thu, 18 Dec 2025 18:58:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E07D6B0089; Thu, 18 Dec 2025 18:58:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32B636B008A; Thu, 18 Dec 2025 18:58:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 21F206B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 18:58:25 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B992F13AABD
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 23:58:24 +0000 (UTC)
X-FDA: 84234258528.09.E570C71
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1D3451C0002
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 23:58:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zoDH5EiM;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766102303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=evpGQd403RyTq2+Wy7kNHnZPf39hVGXm3tsfr/+j2c8=;
	b=rhk1oBwBIbOHofGBc+B9//09tCQpSzzHIuEvNl1sAzL1F7YPs4cldAhAKMKJWa7PMI1AOa
	LbbLNVdk0lGm1QRHiaR3uOXYrEdX/Rvq6iX0+bmkXZO5ZWRQIIV/O6P5Hgc3OteS1Ix8vz
	XmIWH9HNVq4PqnNVIYaslqaJ3PMFI7U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zoDH5EiM;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766102303; a=rsa-sha256;
	cv=none;
	b=bG4OgAFccuOUiCk8b5jSVFHuHRkOYCb6n/O6QSzLSbJJOoPa7jg+SDf0oSdOpxjkDTwAyR
	Qnkqg1SJ1CEXLgBZbOV6dna4NsvJengAuy8hjSsj/Pfn+LqeKwwr9wyqEpJrSRZ/1h2Oyq
	H2k/MgPOgR5d8X+kbHTL7HXSGH6Nl1w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F68D6000A;
	Thu, 18 Dec 2025 23:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0087C4CEFB;
	Thu, 18 Dec 2025 23:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766102302;
	bh=pOn3UTGNCr6gmFU7RxZHh2NZLgeMIttvJru0dCb1H1M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=zoDH5EiMwoBZY4/l3xdzNG7igyTT2ee76o7UEog+gPVKWyzyP+R3uiwNBrOUV1x21
	 x4xqGKcupy93UJd+zwJSQpPwhdkutqaSJZWeyVDJFXGwY+M0Sz6vafNoHGO/uZuPu9
	 h36x8YYM+XF9tZO3N9TRdwRxzpJ+3VTgbi2WtI8Y=
Date: Thu, 18 Dec 2025 15:58:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: yuan linyu <yuanlinyu@honor.com>
Cc: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, <kasan-dev@googlegroups.com>,
 <linux-mm@kvack.org>, <loongarch@lists.linux.dev>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] kfence: allow change number of object by early
 parameter
Message-Id: <20251218155821.92454cbb7117c27c1b914ce0@linux-foundation.org>
In-Reply-To: <20251218015849.1414609-4-yuanlinyu@honor.com>
References: <20251218015849.1414609-1-yuanlinyu@honor.com>
	<20251218015849.1414609-4-yuanlinyu@honor.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: su8kemtzpa36p69kjkndmn9shyei9zxd
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1D3451C0002
X-HE-Tag: 1766102302-786483
X-HE-Meta: U2FsdGVkX1/BH/ZF20wzCe1U8S8aEvf660WVHbL7Wi2V06Jdo0txyvZI0YwEjLjwNUThef/ZhE957wmxs4EDbffSMv9o3HlogxHZbOO8Ch0CPThAqZQOmOE2wfPu63Z++bMdpjHq+32Ln0ioCcP0gdrcluGeT+v0jzrS3U2iVs8UiXCS61S3EIPTXqPSKBhaKsSS4L63f/UPxeC96v0wFu5wZrycW8/SAHLFtHrYHbiVDf8A3XWjxHvVnmmSDJBE6FnNAqDAg6vUGVvSTgnAW6/S62Gr5nTJT99TNa7AZtWse6YRQS2QzVX76cRYy1jpN5EsRh31LgWpBEsmR8FMv7i688StKne+enWv8Oe9/PM6LehL/ka28mfXhL3PvqRx6Ze2kTANZN+WESYBT+2my1NAVZ1sQ4q3pgkeyNAV6mtmrki1/ZF+3E9moJlSI+eQwrW7pJKENa35OswNZjOvX5UV9jhjZJBW1HTidh6tOyqG41ipJSZp2hBZT6sDFR2w3y2MhrhPEA4nEbzWyiP26V5qBJRguCaU1DYWgCVTLvVRY53zyo4aIyFYC0BTx5lqkJVBVDDcZQJHayezaR3WfGGEAOcMVbHjd5cS2EKeR7/V2D+a3zNtjWL+sAxPE9tIvPvOz74TGDEv9B415grgPjButVCqbMgxNEXCYkHKrREVXZmFOGBb4DES3axEGttL/rNc9TXE+f4P/rzzPIpNfFAB/yJzQeNqZejp07JxvzDB9kfjnmKzSx3DISdiWjS7FhDZ0Rgm0FSf63/6WRXJ1REroYngOhrXgb3hCe/JABsoAmHLXX2cX+ydyqDuLuAwWl+IZP5D9dbXRGuR7SY4T1t9ppsnuD2Pc+HsC+pFMWVeC0dB0RDBfpe69Fs4HjqxcFy54GKNxcx0L2hpQKkbn84yTT+/LEMwMab3j+iwi69DJCCWMVf4WVUCuzl75m6G97SBVNqV5YavW39xpRU
 uGqdKkKT
 mC8sSHIsIMVkC/YXX0BWincA+xsMUh/vz7zwpTDpad1UEKbCjkNcwb8LrZlJoGuf5wZOaSqgNRCUGtf4zYay3uiFllcQvlGqNSsyPfd5n4p6B2jcOkDT3gz3t5M+67mjkS9pTIF+yw0/9nRx1Rd7BVqV1ANtLB/06YEb9EVaksfUsl1U+UknyXZqwxtzx9RlCx/Lh/q5hqR4C1n8RtFMoePp2+tG7G1g8LvGgd2EBZQXrVyuZaYR1OBlmJwhug6nSyGIbO959C4UpMTE012cx1+NFs36wTNtWXNEL3yap6ZpEcL6sLRcpf0LLZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Dec 2025 09:58:49 +0800 yuan linyu <yuanlinyu@honor.com> wrote:

> when want to change the kfence pool size, currently it is not easy and
> need to compile kernel.
> 
> Add an early boot parameter kfence.num_objects to allow change kfence
> objects number and allow increate total pool to provide high failure
> rate.
> 
> ...
>
>  include/linux/kfence.h  |   5 +-
>  mm/kfence/core.c        | 122 +++++++++++++++++++++++++++++-----------
>  mm/kfence/kfence.h      |   4 +-
>  mm/kfence/kfence_test.c |   2 +-

Can you please add some documentation in Documentation/dev-tools/kfence.rst?

Also, this should be described in
Documentation/admin-guide/kernel-parameters.txt.  That file doesn't
mention kfence at all, which might be an oversight.

Meanwhile, I'll queue these patches in mm.git's mm-nonmm-unstable
branch for some testing.  I'll await reviewer input before proceeding
further.  Thanks.

