Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FD98C54F4D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 17:45:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0026B6B008A; Tue, 28 Jul 2026 13:45:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF5A56B008C; Tue, 28 Jul 2026 13:45:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0B006B0093; Tue, 28 Jul 2026 13:45:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BBA136B008A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:45:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A92D0A1663
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 17:45:47 +0000 (UTC)
X-FDA: 85038913134.21.CB5B4AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 118BD4000A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 17:45:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FVzER59y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785260746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YWcOuz2FCk2M/N4hPo/RfjZ4wgMZydAAPFWNhRgyIZk=;
	b=HEPv1b92cNfKfABuaLPH51jLjvIwouq8vOBkN/O0XO1Aciy6m5KH58GUpwPfliIGxnSXVB
	pO2VVhGAJCDWgkCbkCaU/q0ECSZnlrECFfQx9NUdmzdX+VKltamKA4m+hBgqtQwKiNhs3a
	w9zGQ+uW1xvcCxblOcoyDxr0jPiDtbc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FVzER59y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785260746;
	b=VdF8RlhSTaNTo5+KTB/IJWY4HKBYmgPEMRXQ1iLZSke0jcrGa6kenKO5IONwKXTa9XRG2m
	3/WO3t8YpfQZc68s36XWCoB5Icr7LayLmHipIhfaFCqopBEP2W13urgDBJxiH4HXu/W7Lu
	2EdwWHU0tQ0dKqF4S/eP+jnYYUMGeak=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F2D7960AA4;
	Tue, 28 Jul 2026 17:45:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF991F000E9;
	Tue, 28 Jul 2026 17:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785260744;
	bh=YWcOuz2FCk2M/N4hPo/RfjZ4wgMZydAAPFWNhRgyIZk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FVzER59y3LnsZPz15yo4AC8e7/M/vcFnKF3tIZSYNB1SZ0cQxWVt9kgUaV5bm+YDe
	 xyFScO5UJgXzpbR1FS0DHEMnp+HdxrqFY4odmatBbI5gGa9FVOTiTByo1GouzNQ5qD
	 ZfScDcSGGCtJsVBuGCFwOe7Fe/v1vp86pHMpGIccPMtGyoqhLeiKCoq+biPLHnVXoA
	 Xufi/amjsgf9qbEEhJK4b1mmdNpoSKtRZ5SrO7YDrlK+3b58eFCYpQFYsfoOmiRFzu
	 LHRNBpb3t94bHxyfavFNXfVD9d8/I7tjHkuve5VWRsEGyMT7vFvKiAZ1VebjyCJrsX
	 jR3LiTzNR9OWA==
Date: Tue, 28 Jul 2026 20:45:36 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 19/21] memblock: make HugeTLB bootmem allocation work
 with KHO
Message-ID: <amjqwKoF0XrvYw9N@kernel.org>
References: <20260725172133.4018491-1-pratyush@kernel.org>
 <20260725172133.4018491-20-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260725172133.4018491-20-pratyush@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 118BD4000A
X-Rspam-User: 
X-Stat-Signature: qpuuke6y9sf1zbazxqmhofwj14545p13
X-HE-Tag: 1785260745-912976
X-HE-Meta: U2FsdGVkX18k3YFWKbcpfxQ+3W9qkh09w+Vwi7egX8Ai+oDdmVM4iPko4eseVocMqTNUD/IFnLEyLA+GFOQwMfgSwejt0WSqu+gz9qUIY60qt6lP1FOm7fA7Y6279/nt4iweW7Jn+y9MgOPbwtexjAwMfOjRhkAwDQQrpst1PBw5sMTFvw4hTqTR+eiomXhcHVCY+V1bbNsOBbeW30+l9DfTdCWwGu0ruhjUbAfpBlDt09b18z08Wnb82qQz7RR3kLVg06Av2xpmr/NFA6UfOVsPk8ncg9wtarN1tLtqL8MQBqXIYwXC7K/UfOD62UYV9H/yunhHMJ32TjNJomojMt6D4pGtzqI9I90X+Y7PUzB+IzH0m29spIreOD/1++xEnT+LaNfHd9kTJf594XfMtM/9LWJHrFKu1NMSRo4LHGupuQ7Px5odFOS66lAF64w5i7munTZ7HMncDRlf8kR+HOKFPBCqsguv+AEtXRpuKMSifhatjz61WwWvcgZyG7UjmuZ4XrWJ19Z1NBPTyGFAIekLM/BzSzftt/4n2MZfGS0S19KC0iQUd6gHCP+QbT4HMDqdWMMQp4jmlGMLfRilAwPMLN7BJ5n0smrVPKyI3Jg4I7dzTRXiZ7aJBAFwD7gK8vtN0ZsOiMlcpXO4uDomnN4a18C2804pyMH20QzjYDOvLJV2ZgypyuTKAig/u4TDKiN0Foi4GRTanVlpgbo5Ox+/x/TslHjXbDtNvf7e+pv/Vh22qE6Dwpb2EwEw6+GEhPNDQFSoJuavjcfbLb1GSETil1yG30Vb9qqft7LnBqO12tuqoIKNDe/ArvRGwAUZBb1a2J+ES6yJcnVp9DLQjajL9YPmgVBw3rr35q/qFrIlTla9FkBEFzg9O6FrfNWmqBxLrSuh5LZrrzBXDCe7LRV2pZudbeoF3U4BM1HWHP/NL0UPTjNtAgewbdrt/evIW1ZYVKBHs+MP1OCZNIK
 M9JKtM+t
 YPt3gB5yZRzUC/X3DzTP8YeHN0OVRnvNiUQEkHMZkU6QuYcRfFuBYvjlA+2QiC3nmP9EGzqXGMN/Ztx3y4RsA1DfzVDoYbtcGupwQ07sFw7HGFTb4b84K7XtjHDrI6GJI0pqwtzv7YoIx/OA5vE3MkdWY09Vy5vVAe1P3hVQo5j4/aFnwc7DMam+BuEK4fdQHSKKfklvmWeNnuZqsJ8JKKJCy97l61cikyV0opkSkF+LUC8XccO4x296zqk425S09sur7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 25, 2026 at 07:21:19PM +0200, Pratyush Yadav wrote:
>
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 8b2e551435ae..ff470fd0fd10 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -19,11 +19,9 @@
>  #include <linux/mutex.h>
>  #include <linux/string_helpers.h>
>  
> -#ifdef CONFIG_KEXEC_HANDOVER
>  #include <linux/libfdt.h>
>  #include <linux/kexec_handover.h>
>  #include <linux/kho/abi/memblock.h>
> -#endif /* CONFIG_KEXEC_HANDOVER */

This breaks memblock tests, can you please add stubs for these in
tools/testing/memblock?
  
-- 
Sincerely yours,
Mike.

