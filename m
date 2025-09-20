Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44AAACAC59A
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 00:14:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 303C08E0002; Fri, 19 Sep 2025 20:14:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DBAD8E0001; Fri, 19 Sep 2025 20:14:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 217518E0002; Fri, 19 Sep 2025 20:14:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E3008E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 20:14:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6355459B63
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 00:14:43 +0000 (UTC)
X-FDA: 83907707646.25.A723F72
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id A3D7F8000A
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 00:14:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L3hzw6hs;
	spf=pass (imf02.hostedemail.com: domain of pjw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758327281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xrat+1ehp3aNhtXJsdSFFasDy/c5q7k1BfU1KQsUgQo=;
	b=pAOPaFHG0AtQVJxHJZ/pxaD7YRTm23t87iUcIPIU3pjCkry1RFkIkxQv+IehrBxCoHjlzA
	upraEoOQxdvZHrZAhQV4BhDhBGAzHlcG4GRyrLTuDdmk4KTzs+Ig0XxhqxXT5QLaYGNXFz
	76e4uX/AExJWBfrsh82RpQc+ETqVCzE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L3hzw6hs;
	spf=pass (imf02.hostedemail.com: domain of pjw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758327281; a=rsa-sha256;
	cv=none;
	b=rFc7Rtiz+bitnthjpYsJNgUbPAJ5Oys8X9JqVu6NpNbl0iRV1va+xEfcC6hR/vEgjCvHQJ
	KCiNyAY3x3+aW1xBla7DTU0TLlci/INfqzrWeP1LmygsIbK7226B12HxuVSWeUJYDAJaQr
	Lo7RGlsvwdY3wCpiM9dlNOOk6AAZ8yE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6DEB844961;
	Sat, 20 Sep 2025 00:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F96FC4CEF0;
	Sat, 20 Sep 2025 00:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758327280;
	bh=O0bDy6Ix2CSa2N0Q4JTxtP6HuLT6aOmOzysAyCGa/JQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=L3hzw6hsVszuDiJHPBCY82Amym8WdjwMr0g4coY501cIx1Z/cbkmYyw7MErPFCgVY
	 9zOiRwZwy5zm841JL2MsK2jzXeQ3zuoERdnS/L8wMExSvv1T0o7mYbdFrsEWlA4SkK
	 3svAd1LFwZ7z30kKWvM0DWesAGVpKsw7bZJco19Lm5M47zZgjVJZtlKLQMBsZ7yYaA
	 FJfwNW5bTkOWmd9ZQMsw1BtXtJxClMXZcosYuHHq5MUc0nBPwOIMN0/MJI58CzbCdH
	 z1MYamA/HTdmcm+e+/bELj1O9aqgYTVQyFTPfnXkV3EothiEolqhY+/B6Fha//O50S
	 IdN4mLe8ZgdZQ==
Date: Fri, 19 Sep 2025 18:14:34 -0600 (MDT)
From: Paul Walmsley <pjw@kernel.org>
To: Christophe Leroy <christophe.leroy@csgroup.eu>
cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org, 
    Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
    linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
    linux-riscv@lists.infradead.org, Catalin Marinas <catalin.marinas@arm.com>, 
    Will Deacon <will@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
    Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
    Alexandre Ghiti <alex@ghiti.fr>, Peter Xu <peterx@redhat.com>, 
    Oscar Salvador <osalvador@suse.de>, 
    Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: Re: [PATCH v2] asm-generic: Remove pud_user() from pgtable-nopmd.h
In-Reply-To: <c2c9fc69871a7caaa205e237ff73557f19f5e176.1755509286.git.christophe.leroy@csgroup.eu>
Message-ID: <d9f45fdb-4ecd-23b0-6c98-846be24976aa@kernel.org>
References: <c2c9fc69871a7caaa205e237ff73557f19f5e176.1755509286.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: A3D7F8000A
X-Stat-Signature: oihwczbj3rh9zpg6s6ts9psaya7cddq3
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758327281-141952
X-HE-Meta: U2FsdGVkX1+hrD/BbXcpy+IMG/489YglvcaJBVOTOnjEo0ZV/7Q/YQczEaBwYVXB+DSyaE2YZWKosKU9j30n61OPxLTKPJa0DOQzkDP9GOweE2BI2a764jrzSywNlhkJe6ApRU2vvDCofCCj3eJSr/6CEdgXBDQ6nJmsuyoqHrNM/QzcXSNRKejnjxKeGV3ObhhS/UDBhlAAl9ren8o4gP58EAjdOpredESCciAovp9OJWfdikFg9SMcB2/rrIv268vNtfmkg7oKJXBZkBvPJmewCZD0tnkLNSrqVHtuZKyatlrC0oFBEEexbiA+TlEOxCFxGhAxkb//zVIX5BP2GdPecM7TfYbkTUuelXA+fW2RwLuhVdUnee28FQ8yeiN7L4O1dmnrHip8pUr4/InOThw/F0K+Ns6yfX/GQv8BMQD3yyQ4BwqmX0dJyJpPahs09nXjLVGF+VpH3oij6FRfVeKKc/GlZD5jquccIPMfPTN1CrVXQY332hAp3tQUVAaa4QoJQXdb0bOibAzEF9bC3+zfmkvrKP63dPDpwjK+56XyCChqj5gMviz9LyjIwdImeDNIGxrH2Z8S8Ua2icoOH1CWcLq2xAZBooS7jnkpXjcf9xn2SxgR5s/EbdFIN2sKYo/XsIsIxMdxxVrO6jayPYq4lUkFiWzDZuKudydktSYc8RnPQ37KacuzjwgqwxwlO8XA3p8DlV/OeqsjVIaXv5yIJP4xNf2agbJpAm7lFH8wNaeo5qhcUT+Yp/uL6y74IPJFkF/02yH6YMpHOyYstNdvdIDhaHAB3XxtKDD97QU3Ch5qn0Z132/+/3SSgx4XGcjoaiUTbDZhjhgXSCoFRj8u5IXVHrCnl+qBUuO9Y+5xmJGngKgz/1wY7EgyohfRWo5f9A3MSX8Zm5q495DuFS3soY/9KGLL0IW19oeXs8PxFYKssbGAIhFkj4xy+xEiBSB+du7HrWC4Qy69OTB
 VZvruxVm
 6n+kxEe6bwFgXcR1mjJU/GULSUhHp0itl7+I2Snj8NJtg4Hz6ov7AlWS1OHqUtcQONN03qs7GZWQpPJKxeuyD2FTgxrTGHVhToDfOP0o/2I4NxYtbwMS8iuu6qgWOy2yNFPF7llJqkYy6+wBjENJ34KoQPFq8Yauj8YEVQlakCIRHz4+ebqq/aBqCJnSZ/FoeDQB6RvjUTaTj7uUKIMC7qnSZQpBbCh418CcpclBqZ58AxW8gskdt1GzH/1ASiHVRLWF1xFsap3v1H43HpD/+k+qtT81gfu5tSfl6kra5l9SpzQkJTgdplsi+exHlapiJQyOZjvVpdeT0VsNmbVERhucaMh8VA1OiRS8+IKewiOmyd0+CFend9yV6+TQex9QLXzPTmenz62HAuT62khRe1MalyFrLUFxT518D8nBQJskVMZbtsrhVeceGMx0O+Eed7lKBu4rGp6kYgKX2nugY3u2LcPPb2oWUjnfd9mxmJZBarE+YNNP+k68UkPqxmM7cNf2tcklwHH2ra8USEzzAg+wLTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 Aug 2025, Christophe Leroy wrote:

> Commit 2c8a81dc0cc5 ("riscv/mm: fix two page table check related
> issues") added pud_user() in include/asm-generic/pgtable-nopmd.h
> 
> But pud_user() only exists on ARM64 and RISCV and is not expected
> by any part of MM.
> 
> Add the missing definition in arch/riscv/include/asm/pgtable-32.h
> and remove it from asm-generic/pgtable-nopmd.h
> 
> A stub pud_user() is also required for ARM64 after
> commit ed928a3402d8 ("arm64/mm: fix page table check compile
> error for CONFIG_PGTABLE_LEVELS=2")
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> Reviewed-by: Peter Xu <peterx@redhat.com>
> Reviewed-by: Oscar Salvador <osalvador@suse.de>
> Acked-by: Alexandre Ghiti <alexghiti@rivosinc.com> # riscv
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Acked-by: Paul Walmsley <pjw@kernel.org> # riscv


- Paul

