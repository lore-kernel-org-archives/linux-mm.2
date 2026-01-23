Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FA39D72361
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 09:37:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C42366B0499; Fri, 23 Jan 2026 04:37:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C10056B049A; Fri, 23 Jan 2026 04:37:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3DFA6B049B; Fri, 23 Jan 2026 04:37:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A34566B0499
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:37:48 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 73E5913A336
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:37:48 +0000 (UTC)
X-FDA: 84362726616.27.DE9CF55
Received: from mail-43100.protonmail.ch (mail-43100.protonmail.ch [185.70.43.100])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9E19040009
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:37:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=XPuf3GD3;
	spf=pass (imf04.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.100 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769161066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rp2VULi0fBLTwGA/yaOsvDnY5wjUVyKvQyK7cbRL0CY=;
	b=z7o6oo66jOZ9C2MrFjZK+zJMDV4B4CY5zxvm+zz00NPXQ0KRuFzdAtu0tjvTcVGjlCTF39
	70ib3KsGL0KavIPB9qrNvxXDhgJKKX/rXv3n/D/myVWoTYGgLC08yOTcFrTwdivHggg65b
	QJtiyX3DrVqU8nJ0pSzmW2kRyQb1/0I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=XPuf3GD3;
	spf=pass (imf04.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.100 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769161066; a=rsa-sha256;
	cv=none;
	b=14pVrvCsCFq6feYSr9pQO7l7uIxIdl2voWSGURjOhoWfYGSg5Rwj/bzWygt1MiM4UUphRR
	MUQy61r3wUnbUo3UZZg4JfkpbSB3k19fL0pBQtgFADTy2SM2YHlDL8fjK61tY4+TSP1kvO
	8qU1XXS7XFjF9AzdErTyLP2BIzk1syI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1769161064; x=1769420264;
	bh=Rp2VULi0fBLTwGA/yaOsvDnY5wjUVyKvQyK7cbRL0CY=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=XPuf3GD3SuKsSc/v9LiPv5pLh9ApRBMe+Uxxgx+XrC2nOiqeBLEqxnTHo25QW0+4g
	 bFiHP8gUTVtmizCYGudMPmsLIuH6COSg/TXAhCud5iYutrRYynGoIq8h3RsO+9Ec+P
	 7zH0f0WoicQuUAT4DXqX8jO3g0Qg8NgJ9WOFfLfGfW83x5te6l/mipoHg30sHpvdkl
	 PI+EFux1+Pv0i6UfB1e+C8xX1zcAh5wMZT5mky3Cd6YmubEJjT5jMLv13g0IuG+Y9H
	 /Rk1wvOcCi6Mi9VaEIWcAuI8WQNYaS5VLa7Ws9q8tfzLx3QlGQKIQwXHsgYAcG9Ag5
	 T95GrR+R1Nghg==
Date: Fri, 23 Jan 2026 09:37:40 +0000
To: Mike Rapoport <rppt@kernel.org>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, Alexander Potapenko <glider@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 06/13] mm/execmem: Untag addresses in EXECMEM_ROX related pointer arithmetic
Message-ID: <aXNBTJzIKeRjQM6O@wieczorr-mobl1.localdomain>
In-Reply-To: <aXH8wQbyjFqlueNS@kernel.org>
References: <cover.1768845098.git.m.wieczorretman@pm.me> <50701245bae3d2c543f518d206539ba71367075c.1768845098.git.m.wieczorretman@pm.me> <aXH8wQbyjFqlueNS@kernel.org>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 9c1f3083fa95ea7cc89356969f370676767d2ed7
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E19040009
X-Rspamd-Server: rspam07
X-Stat-Signature: ew6nc7xmfq6k3wyyk3kqttdj47qat1qx
X-HE-Tag: 1769161066-256079
X-HE-Meta: U2FsdGVkX18nG2xSrFTntCNyQlLpBR9LQNVm7UvRkswsBdyUSaHr09r8FouKQYP4jZbm+eawvYg8BnLzbCfWJbu6Hwe2Ww3poY597kMRyo16gYM+pkgB7EgTum4BBZDUdFFRJyqciPFPxqv6+WF2XZNZWF0jaSm3RQnOHSwm4fwkTuGiEKkGO6Bdo4vg6zG9t/Zf5ShY/ZVhsxmhBXqhbnXVPxz21c3xwqAyVisSV+H36wxvRZANtU5g74rrVNnta2OGGVM6wcBuXlpLbFPl5pT/Vh/rM34iHB4aSHsxltRqJSr0j++vXLEgZIR0PaF2xEUi1BZji9hc19Nk8V5xvp6GGYxMhaL8m+PUhdd03DuyMZvc3njbhpYZ4Y1FHli1OOp4MIX9MYqq8xgX0QN0rS4m1iU0GsjPxByG0L8a9LwU0nwjnjrSqo4C1aCnXt9IAdxDJOCMyWMo/UsrcOINDjV4k4MEEf8+6eDgRmPJZkrVrEwoC+vq2K4/vtJyQA3EHJ1Lptj67HxaTg/zQb7Cpn23MEJW2QFnkTMqt69xAeWE9R84LcQe9++znzrhMMb12pMFR7jo4mgJeKLR+1/3SH8tdtmLod7peCPYUs3BlGVDxCt6EuTufqBEm047LBYuAPXuZwAg+kcjlUHrNg7gm8aSYaMLHCKaBbz8JQFbUjhZDD9qRHNkX5ElyAkAOYSxgc4vwZbuG1/1v1Y5+eAsM1EvFkcBYwBpYDElqlIOPGSlZH8Kr9IqdE1A1wPesk4W8AstxhSqZzEHUiZDTqGiMAvXyYwPt1ok9XLsAhPr1xv8sSfvYQVfS2JAIOY7Kay/dmFOj/sTrnWZIcEe3sJF5YdsoZjMbW6hUi9kiTp81QnkSwbkN5hqwfi9/tTbPATz/r5bfd23+kaWpzNcySmX7kl7CGdpLf26VvqDgZo597mYSdxZwDFJuWbROGYrX/nn78rBORwVp/t5pXRP0sh
 Xc58EqYl
 ZXPvPX/FN2ywEoUVHbEL/r+caLXR/gf/NoTQ09SS/sv5vWBTKQiZkOKLl3acX/56B6CpyBBs0dRlNUfZwykFvy+TgJ+AOxLpMzplUJlrafwMR05ZwR3wi8HRahUpyhlZrfHJMp/4dUhX35CqVfmxgWK10UMoI0D+IfuBsPXCmzialvC6KY6vei31PEOyWgN7XVNYWe20t+5gtuovwM7LSwacCjGgoKBpUrlN9Sac5IE15V9GMPtjNTaPWP05r60YrwykhO4Toal+FcY1jBuKmqW7r6uDb1ZFQf0nX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks!

Kind regards
Maciej Wiecz=C3=B3r-Retman

On 2026-01-22 at 12:32:33 +0200, Mike Rapoport wrote:
>On Tue, Jan 20, 2026 at 02:41:43PM +0000, Maciej Wieczor-Retman wrote:
>> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>>=20
>> ARCH_HAS_EXECMEM_ROX was re-enabled in x86 at Linux 6.14 release.
>> vm_reset_perms() calculates range's start and end addresses using min()
>> and max() functions. To do that it compares pointers but, with KASAN
>> software tags mode enabled, some are tagged - addr variable is, while
>> start and end variables aren't. This can cause the wrong address to be
>> chosen and result in various errors in different places.
>>=20
>> Reset tags in the address used as function argument in min(), max().
>>=20
>> execmem_cache_add() adds tagged pointers to a maple tree structure,
>> which then are incorrectly compared when walking the tree. That results
>> in different pointers being returned later and page permission violation
>> errors panicking the kernel.
>>=20
>> Reset tag of the address range inserted into the maple tree inside
>> execmem_vmalloc() which then gets propagated to execmem_cache_add().
>>=20
>> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>> Acked-by: Alexander Potapenko <glider@google.com>
>
>Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>
>--=20
>Sincerely yours,
>Mike.


