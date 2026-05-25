Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 257E7CD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 07:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 476E46B0093; Mon, 25 May 2026 03:48:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44DB26B0095; Mon, 25 May 2026 03:48:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 389D96B0096; Mon, 25 May 2026 03:48:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2547C6B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 03:48:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C8096A0159
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:48:24 +0000 (UTC)
X-FDA: 84805164528.10.BCF3B32
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 159A21C0006
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:48:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J6Ums5B+;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779695303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ffTsCl52tDDJ9WJMBEtPkp7+qwtVftVHOsX4VQzd+hQ=;
	b=QWqqhImE911fiFa3MFOUUKS3/LTrtuL7vo/g+4WrdJZH6kE1H87KoTCYPlWIyH4I3CH8a7
	9rw4789vB9nuX9qtunhln+NaB7GMmNTOXBZfySuJg5kwsUnfGeCalnCmPoTB3kjSTauLjy
	jors+u+KzP2+H+RtO40Kl7twJyVADSw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J6Ums5B+;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779695303; a=rsa-sha256;
	cv=none;
	b=sNqigkVufZZPNnJH/hZEaZWu2VLZuCohO5M9b4aXgR36vVqLoMxTBk2WSTP5ZF8VUg10IH
	H9fIr6qnfcnqGSN/NrPK+tVgGHe1h9g5kCdy+vB9jnqfr7/HHftn1fsksy6dI2S83+AxcP
	BuEwYsd6T+kT2F31UObXRu3nCA/TQuQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DBACD44037;
	Mon, 25 May 2026 07:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00941F000E9;
	Mon, 25 May 2026 07:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779695301;
	bh=ffTsCl52tDDJ9WJMBEtPkp7+qwtVftVHOsX4VQzd+hQ=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=J6Ums5B+7Lu3MakC2zVCTCT3gKG+WJsmtE0pvAGhRPT1rudrXkgUpO07M33BcCgEN
	 TMXK2GayHABOZ6GioC9+c7H6qHOZMwl1ZL64YTN0J8aVvt1OD9DCpfL9h4rofi0RuI
	 4KB9Fsx4prdeFZvt4Z97sNj92YQDvrXqtvszS/ZLnSlsre9eF0/hfmcd5nhL+PIqy1
	 nIznVI0znL3PR+eHwnsK9TtjgufBF0B6T7eJo1woXIR/y60oWcP9mejxnyv1xkLRoW
	 ttIb9AYZPRhR+FlF3lzPS10iGRR7fxbNPi6+EfjOSo1nE7O5vsAKNNgKCJDKQ+3Zl1
	 e95B8kRLjRc+g==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 0/7] LoongArch: add KHO support and selftests
From: Mike Rapoport <rppt@kernel.org>
To: George Guo <dongtai.guo@linux.dev>
Cc: chenhuacai@kernel.org, rppt@kernel.org, pasha.tatashin@soleen.com, 
 pratyush@kernel.org, kernel@xen0n.name, graf@amazon.com, shuah@kernel.org, 
 loongarch@lists.linux.dev, kexec@lists.infradead.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 George Guo <guodongtai@kylinos.cn>
In-Reply-To: <20260525062810.103367-1-dongtai.guo@linux.dev>
References: <20260525062810.103367-1-dongtai.guo@linux.dev>
Date: Mon, 25 May 2026 10:48:14 +0300
Message-Id: <177969529480.4047269.2120994507098781563.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 159A21C0006
X-Rspam-User: 
X-Stat-Signature: 54wmxdja59z4y64wmn3zkwgdyzdwnoaq
X-HE-Tag: 1779695302-406941
X-HE-Meta: U2FsdGVkX1+OeiDk16oNcPkKkx6qc7j5y3rJNRTLHv4yWkWTbrYOe+tZoMBITVH8HZMo8lwhFXEVdgeU3obMQeJcfDDHeRTQUYXJ3QgNLNve9slEviWNPNkGv0oByWk1aU/1LDDgZnNtVlzgGPPZXrR3cnFyY/tkrw3J94O1sGTXab2YTe17IjzPcXSjlCxvyfHNDMjXPQttuNC6g8v0P/1370xzXg93k0LnAwiLwyG72oZSGZZ7qZ3KtZXmehcWJwqV5XAVlXFHL7yIfjLHpRKSQAmYBS7hDgmyOFpVihieZZTjM5f2/aODO/XmPgzYywgzXyHgfNECF9bfpyfZ4NNsNirVH5BIOIHA2y3wkjwpuUt5mRAxWmokKxyQmWD9xSsrgSjHSBHGj97xjqrnVvzjDyEp5FYv2rCuTX+mI/nk0mDm0XHzM94f7DoXNc6jPyXOFohJ1e9L1blTo/jOAKtKkguPLZkiMUq1YaM1SB3RvXsehaPI1IQACyPzFQ1clhm2T5JY887qSnG4/X8oKdQ2Y0GDqIDGmuRIRcIppTa91xyoDHzb4KaWUEgzSyiQCscelyls6rUK/1wwzWxupnH5XLRF9tQ83QFVcYnKN2hlWvol/O0hwsjYBtBAmGF7x+adzocPi9eaGDf7I22vi8shK1j5Bbfq+g6f1OeUWsq5KKbXOUfkWacMTP3mZLPsLy4UaL9o7ZGhqvvnGsLIuYGzyHQT4P1bd8uBWmK+eO2MejsCBysgfCNRLyfYKU6xdpzlmc8PLZX5G+iEu4eH2pI1BnnfOzcN8Aom+eG3R1Mvl8/3yyDZG6Zqsf0R/E4TAgsmVi2kxoPDkEvCckvRwD48oOtayF2KnjU1TyWSScDPLAbRIUYZiAemQVzjQyrIJHxowoBk8As6z90jsChFto22+k/vxBsT1IYfj3tWhLYQEoOhYD8mQc2Dy6VOBNOEv4MdR5A+Jfz8k0D+l9X
 reY6MCvb
 TGmu2jCRAazwAj8l3cv215czzdWN8dUe0dtB7uB7ZOwWFt07iXEu3DeAIjBG1j/nqYBSSk5A5Eyt/lpomr5vJOwrQWhaD5DZUQ7rib5zAC+uUax87iduzkXiSIwW3SN9VjJ98ilR0u40OrrbHvf+pQD7aEhgo0r0F9/0L+g2mhOJqLK8JUeixAR/BY3mYlvOCHznM8LI4roVQRGxHqw9IxfGFlr/GoY0Kj9US
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 May 2026 14:28:03 +0800, George Guo <dongtai.guo@linux.dev> wrote:

Hi,

> [...]
> 
> Bug fixes (patches 3-4)
> ------------------------
> Patch 3 fixes a build failure with CONFIG_KFENCE=y: virt_to_phys() and
> phys_to_virt() in asm/io.h expand to use offset_in_page() and
> page_address(), which require <linux/mm.h> that was not included.

This fix looks unrelated to KHO, it makes sense to send it as a separate
patch.

> 
> Patch 4 moves KEXEC_CONTROL_CODE from 0x100000 to 0x180000.  QEMU
> places its machine FDT at 0x100000 when booting with '-kernel'; the
> previous placement silently overwrote the FDT with the relocation

And I believe that patch 2 and patch 4 can be folded into patch 1 so
that addition of KHO support will be a single patch.

> trampoline, breaking earlycon in the kexec'd kernel.
> 
> Selftest support (patches 5-7)
> -------------------------------
> Patch 5 adds loongarch.conf and extends vmtest.sh to recognise
> loongarch64 as a build target.  QEMU's LoongArch virt machine is
> FDT-only (no ACPI), so 'earlycon' must appear on the kernel cmdline or
> the console UART is never discovered and the test log stays empty.
> 
> Patch 6 disables SERIO_I8042 and its dependents in the QEMU_KCONFIG
> fragment.  QEMU's LoongArch virt machine has no i8042 controller; the
> fallback port probe hits a page fault on the memory-mapped I/O range and
> panics before reaching userspace.

This should be folded into patch 5 for sure.

> 
> Patch 7 polls the serial output for the test verdict and kills QEMU once
> it appears.  QEMU provides no EFI runtime services on LoongArch, so
> machine_restart() falls through to an infinite idle loop and QEMU never
> exits after kexec.

And since without this selftest would hang on loongarch, the timeout
handing should be folded into patch 5.

In general, the rationale when adding new features is to make sure that
after each patch there are no regressions and the new functionality
either works or cannot be enabled until completely implemented.

-- 
Sincerely yours,
Mike.


