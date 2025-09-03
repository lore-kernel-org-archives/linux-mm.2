Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF0E5CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 19:15:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 212F98E000B; Wed,  3 Sep 2025 15:15:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C3BE8E0001; Wed,  3 Sep 2025 15:15:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D9838E000B; Wed,  3 Sep 2025 15:15:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E59A28E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 15:15:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9FB60160584
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 19:15:31 +0000 (UTC)
X-FDA: 83848892862.19.3AEFFF0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0F6AC20007
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 19:15:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf13.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756926930; a=rsa-sha256;
	cv=none;
	b=Y9BtANN5eKnvEgEeQYQSFVpVElhGaqxxo/pQhz2Vd3dRdJsXlsBJpavgGzhYDVbrFZuOFR
	5CY6RMQ8E1xmAVu6TnrxhdlK03yi9RUx9zcFPgFaciruKZw2ERbf7Yclr0Fa5fPlxKlwAz
	uGPq4seoCBJafaUYEGvcBcfuKKoPy90=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf13.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756926930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tRNrGXPL9T6MFAobFuX6q6GgkpC51qH78rhQEJ0d8TY=;
	b=kgQiW/lkXdD+XBNp6HpSGG9DEchH5AFRC+IQk0CijgDYDVDYrzyncD1oT/BqyTp7AM2MhE
	4S9ZXBk25Xz1vM/pb7wxQDOZ3rbQNNuJgEpfgpZfNzoUi+chK1Aq/u1FQ3evihWutfufO+
	KWe2XX3pcuojygthJTqfacfh3/+Qrkg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5534D6013F;
	Wed,  3 Sep 2025 19:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB42C4CEE7;
	Wed,  3 Sep 2025 19:15:26 +0000 (UTC)
Date: Wed, 3 Sep 2025 20:15:24 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Ard Biesheuvel <ardb@kernel.org>, Dev Jain <dev.jain@arm.com>,
	scott@os.amperecomputing.com, cl@gentwo.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v7 3/6] arm64: mm: support large block mapping when
 rodata=full
Message-ID: <aLiTzJ6E-YBIYuGo@arm.com>
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
 <20250829115250.2395585-4-ryan.roberts@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829115250.2395585-4-ryan.roberts@arm.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 0F6AC20007
X-Stat-Signature: u14p8a1xnbp6mxogeup3q7x636jj4d6o
X-HE-Tag: 1756926929-661378
X-HE-Meta: U2FsdGVkX1/WKruUbrT0lnASsov0MW7j7PXQeOvUTXOoiNFcwQo/hcYY5FY4K2EbV9obXUlDPJgfzEeO6JRAWiyYcfFv9irufehX86k1RLY+yFGBHn5f8D8VFsNqoAttd3qDM8DSz4wZN36bYfccJ/AkhZS5aVUVfBzln6sTTt3HYgOYYEPbjKySmFCUDslCo0KFWyawdUGlsXeGuBFwMw7Wn5jIr39gO1wnCSUZBV6aOgAECW1r7OK1aCxb1i6rPEaprAdNgfg36yXhxQ6wbRPuRLxP5JwDRVE+Qs/kZr5F1a4t+D3nX8905LEDRdeJtxPIReUh/YuLQOzlrjmAuzmvaL3pYNiALRV3ep3Y1N2xpHI07df7YwfVgczJCYAJu51W59xxtiGu0oVhRIYHWUj7ZlTLtCa5240nSC8SKV7XsyyCUtAhuN/1sPKUV4emgBrotf7YCprsnt0yOtCLBCpLMyxg4lNMc377mASUl5KwFAsr2FHF2BgxfUGvBosGHeYKOTgN3haB9EbUDw7JrBXNwAJfmp0l2vKwFZorgWd9Y+M8ptsHsG7ZZp7gMnzmuhu8snsQkEvFCKULtP5/oiR1CdQ5AIfcSp6LFHZxZXhTVWlUU+an8eb36+msG3AWFDhhe9WgywS65xjlK3iJUvrtnod3CZ/ojNrlBXlJbyaOZvUSM6XIH0jkmJYuOuscvxEoHBKFrk+pItdPYovvE5fLKb3UBBxPImH1XMl+Wjz5Z6gicgXQYNpa92LO9RUTXobmdy7Flh+kwZK67bqJgtIPRxhOyJtYAH5cIroX6iPxBhyyOaKfCSUJmMZo4mPxA86O0ab+xMW9qCDQvUEnu6F7LpBsRKPKn/WsimFAA11R16KKemhovG9GYWXFHdoFRQeSqSjXkt3zL2DeKPPbEVfLwUdoNqZJXyKtDdeMq2YoNnwGWRmoB9wvT+rjt4XxaZgPG1TkVuYBQXJSvyl
 C6LYOCw3
 /In9wsk9eyszatluQIUcx73xG3WJbzSb5mc07IB1dqYxNGlGDyNmQck+ecPiQr5W+vAO4pQEJCu/7C01xl7WBbqqIjsMynAH80rJ2f8IqeBEGSvc5JBbNLkxuGMCDSy+RkaLRJFDp1wsTdNxNBNgC1OJmedUjffTFCYjnD6qPkYoO64On79zdn39A4/VXtJtHwNKznyFZ+rEz+bV7ByCDxcciMQdzARMPqmjwaJyNk8g15MJpW83s1v10tsetrVAmcKE36wWzqdwEYjLvesjCrCXPuIFWR9a+1iwCFLz1ac7xf81CZHfdq9tFJaXUNl30X2JjFf8yJzUFDlfwbDlOrzd/ro5TX+OB6AznSeCaa7J4n6JlyuFMC47NI5tI4xLZvvIjMOv/V9lB+AX7gaDUX/FDJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 12:52:44PM +0100, Ryan Roberts wrote:
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 34e5d78af076..114b88216b0c 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -481,6 +481,8 @@ void create_kpti_ng_temp_pgd(pgd_t *pgdir, phys_addr_t phys, unsigned long virt,
>  			     int flags);
>  #endif
>  
> +#define INVALID_PHYS_ADDR	-1

Nitpick: (-1UL) (or (-1ULL), KVM_PHYS_INVALID is defined as the latter).

Otherwise the patch looks fine.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

