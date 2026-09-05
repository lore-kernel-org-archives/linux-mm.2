Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A86D3C624D3
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 11:41:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81D856B0088; Sat,  5 Sep 2026 07:41:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CF066B0092; Sat,  5 Sep 2026 07:41:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 699416B0095; Sat,  5 Sep 2026 07:41:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F09526B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 07:41:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 78B6DA02FD
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 11:41:26 +0000 (UTC)
X-FDA: 85179518172.06.51946E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id EABE818000A
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 11:41:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SP9btzWR;
	spf=pass (imf06.hostedemail.com: domain of ojeda@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ojeda@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788608485;
	b=lMEn9EmiSnAJFGxDRPplyxvQlRsyZ6Zhw7xZJyGq0IIJqT+Py2EZ2ml0ddyM0DoxrpJt4Z
	VStMDHCQyGUt+Soy+d8q2bL6xR+uuQ5UiuZz+Oe89TeYasV7gDZqoQYLjuTLIltUW091Cc
	W43ji9U9gZFtQHiMX0BLAKC2cHyQtcI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788608484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gifpKp+5IUGA4WQodiCfcIPD/2OT99dXfSnF8EVtxEs=;
	b=Sftyswoz/Q08OpLLhEL0aScjPq8EKViQEE+aVxsmcvtZtWYVZUCHhflt9rwQ4V+RGG5gak
	MQtBCovXCH1jHyArDXZPYqpZojgeARZZ9JD8SahqNxSFhnv0+DhGOO5JVHk/cJEi8C1Kfq
	+X2hlBu9f9TpEwnxFYoHDC6tJIzMf3U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SP9btzWR;
	spf=pass (imf06.hostedemail.com: domain of ojeda@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ojeda@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2EC9060209;
	Sat,  5 Sep 2026 11:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFF51F00A3D;
	Sat,  5 Sep 2026 11:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788608483;
	bh=gifpKp+5IUGA4WQodiCfcIPD/2OT99dXfSnF8EVtxEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SP9btzWReG/xJYvsSXWsDIu1nOJVPRa3uwEDuoAxydkW8CMPwLdmwTBMWJTIVEiki
	 lLptHyBO9lBdRVmXHCu2yz/ycY1PGpJyvh1iyv+GgAtajrPZGY+G5taeqTj+wvtog6
	 r36Ecu/sRvqiOyhSYWJ39M+i81Ke2+07gMZPUCLmOKfsIB+NT/si45b2A2rWo0/Ltn
	 jKvDNqg3hoxZgvJbTkMYSRooma8H5PFu2LD2pQH9vskfq8qR7ffN7lObU+Hm8SR69K
	 7d9eEBRkBhGdmvn2XXHA0TtDtRpYyvuNThreJ9ixlXtx91pzkxrqOo9HERGIbmtzCl
	 0oBuHK3prhxug==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org,
	Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-um@lists.infradead.org
Subject: Re: [PATCH 6.18 000/552] 6.18.50-rc1 review
Date: Sat,  5 Sep 2026 13:41:11 +0200
Message-ID: <20260905114111.124795-1-ojeda@kernel.org>
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EABE818000A
X-Stat-Signature: mgi6n9o5f95dc1h7xt6e514d14rxs14t
X-HE-Tag: 1788608484-774649
X-HE-Meta: U2FsdGVkX19AGsvI011JHyF7/SH42zQwnSCj1VlGqetHA+sFsiPJnnIMUu//l9t/l77zdJki3J6zdK/YuZbul+AUpIbsNlJeJQLPxVvXcF+IDoEqXreZ9SJBSUK8rq/WyM/5yj211S8/AqNNJY7zcxrCw8ZoXftnHcEdaKH3kaJrlP/rGT35ocaEeDsRVvhhJ48ZK9+G309R0+ZSWaMl8RilnwJRclDeHLVcJDye8bcsrLPE2EKlvpSCYjgVL1ruyKtGUvEvYcade9cQ1qmuq4h2wamNHkW0NBV8wbClkLgG6aYNQaFKXXp0EDoB8XQPxBZI10L7dqwUP8l/osNqxd16PupBBsBX5kMLX7PzomJLRrwwnoSeqwygU6JHGgqnVgnHpObz5o+X95C5sNAR9fW6H+aaDPY084anSCerBmwLNHoUw2OT6uDVhmE5HbdKkk9euu7DtUjwK6ciDgcmzvBl/oiyJAFJSQgNO6IhCejt/Afz0PIM5HM5SE7/D9nbrT7qgtUoXPGci9vgHf/m+7ElSUaNhoR3lQxGnv3OyAHudJlAYay6yxZTwLwZ5Am/plA+lOmbMx+HYoHFJ8QH8LrgXt0rf4Bcm8RYrJDriawHy/9bdUlCGGo2Z58Yghmn1IkUxLtpgLxRfCSSH9AInySuCYBzx2elG/UlNbNmQPl48p/KEGODs67/9O71l9tPmXivUMlV/0dNmf0AzQYVqcq6+ZapPMEJO2apRbntFWXjRPpxHOCD7PglbZ9g6DINlQhBsHPxtF06OFlY9IySiL0uTx3W8zzOYXO+mYBqi1Fpw5MJYR4yKUm/1niOwstK7R/3ePSN4qe/HyVCkd8inGQoK+bYh4ClkPv1Z0Gr2ny+pMr5vbZ3LUGhP2cCzhIbSaObt1LkW7QiGPvdxSwJ6k2AdyPmtqy9WfhMEjI/4a5en8fsqqgWKkbrj5hi2JYTgOMcm09T+kuGtcxwek8
 WpyVTCfy
 5OP3Zd6G9LspVRwya21YlGJiE8mXlTFlbFxRVVEUdm6WBSli/cKdyFLVBHjMAEu90nC/EH77jS5Jy1A95rPdBgShWoqY0rPQ7wayaYASfahlaU8RvYuBumO6dOUjZqm+dXK9WSMR0Qs3FnO8BmpfiP/V0V4azl2n8hGw/kzaArVAvPPtMs6NffNzB+WCLpZLi+nhqQUcPTYT5YzkW08Xjg5p/C3hdxLt/ZtIxPvkTzw3uwB2sWhiY5TTFOMU3a8WMV/Pn0FBlrz+eCsV/3jBeV7y+PFmQw0h4efFvkowDESGl5h8uUFLARfZz3C9CZlGZVSYVm1lRET53qZFf+unppE+t2xLc6wF7x6xZkUs5vZuwUUOgrbpmocY22IlZuvWE04ZKGAuRsAXr3Ujwc9PmaAfrf8XAJS8LDMbmNy4RI/iVctIwYJFgVFRrVrV74ORHKViZKcf4X4/VE6MsBEvcNg5utTuGV2qdV6AgtBPDLrIap9oeKQoQHDT9uJZh6scvhcItR7v/Jffb3OcFjXvPYIK2ZRbRqcsmIZCHP3DDGHBBiPrby1vBu7eNK03CSNum4EcunnpvobzaVb5tahjan+fV3I+M8hnAhxgy/5FYM5bm9tPmUNnCsj1LopmNcZroD/DOGXavVPnXjsXRqrfDDnwaL1sKKgpkVJwIVvzvxnRBD7pfJI8JANlfjcmkr3kxtbseMvWDep+83+Y2CwV8+0mEi4r1gcHrUdnlBDktmEc0Iq2GDqX9AcKZ/lmlqm5aaQgVCs9Pl8+VRQhiZGiIrWzG51RCoZjRPu1XTDcML+bF+tPQ8esE8pHQkhb6dMG7rGo1Hx/+S9BGKWNgeNEZDH+LRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 04 Sep 2026 06:52:37 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.50 release.
> There are 552 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 06 Sep 2026 04:56:59 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

I see the same arm32 build issue:

    mm/page_vma_mapped.c:110:11: error: call to undeclared function 'huge_ptep_get'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
      110 |                 ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
          |                         ^

In addition, in UML (x86_64) there is also nearby:

    mm/page_vma_mapped.c:110:9: error: assigning to 'pte_t' from incompatible type 'int'
      110 |                 ptent = huge_ptep_get(pvmw->vma->vm_mm, pvmw->address,
          |                       ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      111 |                                       pvmw->pte);
          |                                       ~~~~~~~~~~

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org

Cc: Russell King <linux@armlinux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org

Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-um@lists.infradead.org

Thanks!

Cheers,
Miguel

