Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAD81606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 13:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EPHU4bh1
Received: by kanga.kvack.org (Postfix)
	id 929756B05B4; Thu, 26 Nov 2026 08:28:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9004C6B05B5; Thu, 26 Nov 2026 08:28:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F2516B05B6; Thu, 26 Nov 2026 08:28:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4039E6B05B4
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 08:28:00 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 77805A0450
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:27:59 +0000 (UTC)
X-FDA: 85477348278.07.DFA2864
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8BFD0180006
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:27:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EPHU4bh1;
	spf=pass (imf16.hostedemail.com: domain of linusw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795699677;
	b=Av5s5Lm8kkX4hHd/Jn2m97mPQqdoGdlOyU6CyvUxSaNS4hh4DfUdOAs8Rlq90Cy65GkIXV
	6zNmKiG893sm0ZUFilJUq1NRivsPpQwR48bP9YSbrYmHvdSj3UeVrBUMb4HCe0nwL7kS1n
	3hVMKDAj7ol6Wkm8GME1gtTADxc2hZI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795699677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0SuygBFJgQJDPEHL8vg5eLv9glUvVL4TbpwchKTOKc8=;
	b=eKUuzWxBTEPEXtJMoZEt5fPmo2HeVZR2vCYmG6RJk9mk2paHaqVZmsTs1d2FufbTTB/sel
	ZgVK3jLFFXIyO7vjfcnbIEWPFsM6YKjf8HuXjOBOx93N/v+SimY6SqiyWw4qgJUwSm19UM
	bL7ENtzwnNfBFnPdOGNYuilgp5BqNVo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EPHU4bh1;
	spf=pass (imf16.hostedemail.com: domain of linusw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D1DC14637A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:27:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99CDB1F01563
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795699676;
	bh=0SuygBFJgQJDPEHL8vg5eLv9glUvVL4TbpwchKTOKc8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=EPHU4bh1rQUynF67I/BLiAYnpMItWNnTQ9AParYyhIyJ+y6H3njJ4HyIE0s6Jx202
	 xCNzY4EbdFEUvhIGV7u89sr9xvmTk/hzD3usLMoUVQo7zRS1mVOEOGXKaU7srd0lqN
	 QJ8zgMkZSbzwDG6k/Q8gKHxK2xOwoNZh0rfmPcgTWzKzVzQoVxEJRXus9AvWUL1U2G
	 poRlMVnD4ZVArgDu1nm8eFgis+FkVYb/7yrTihelucyhtlDiutnGbPYYQd1IeXPRF1
	 uMR3MT3fEDrUV6O3qWBar39ZOF0tAC8l88Y7GgJIURjBmPo17gy3FHsqx2yCKI3NPh
	 QpwxgY4N6hLRw==
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5be47aa555cso438598e87.3
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 05:27:56 -0800 (PST)
X-Gm-Message-State: APuU4Z+xxig2ow1g1/tWZMukK0L+Q6lFACgoeSlHLPj3klTafAmrGI7R
	oShVEh/9kV5kPOT578IQWvXhu1PGCmz4i/F+CZi7046sYTUPu+hkWmVcMDJKjSDw3K8xOvVJMzV
	0OGzA5mtFwo4YMiM64Pa7t06/ELMgw50=
X-Received: by 2002:a05:6512:36d9:b0:5c1:5976:1d30 with SMTP id
 2adb3069b0e04-5c1bc8206cdmr4300123e87.57.1795699675392; Thu, 26 Nov 2026
 05:27:55 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116124832.662455-1-arnd@kernel.org> <20261116124832.662455-6-arnd@kernel.org>
In-Reply-To: <20261116124832.662455-6-arnd@kernel.org>
From: Linus Walleij <linusw@kernel.org>
Date: Thu, 26 Nov 2026 14:27:42 +0100
X-Gmail-Original-Message-ID: <CAD++jL=ZyHZcJRUTpVghs3xYH0OGOKauKVWTF8tiPpHPjuad+g@mail.gmail.com>
X-Gm-Features: Aa3M54pIH7xhTLEiVGxFItiuCxGTTC1f9B6RJQ9R1KEb9x9xI611Qqdum1NmRD8
Message-ID: <CAD++jL=ZyHZcJRUTpVghs3xYH0OGOKauKVWTF8tiPpHPjuad+g@mail.gmail.com>
Subject: Re: [PATCH v3 05/10] ARM: add CONFIG_VMSPLIT_2G_OPT option
To: Arnd Bergmann <arnd@kernel.org>
Cc: linux-mm@kvack.org, Arnd Bergmann <arnd@arndb.de>, 
	Andreas Larsson <andreas@gaisler.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Lucas Stach <l.stach@pengutronix.de>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Malin Jonsson <malin.jonsson@est.tech>, 
	Matthew Wilcox <willy@infradead.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Michal Simek <monstr@monstr.eu>, Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, 
	Nishanth Menon <nm@ti.com>, Richard Weinberger <richard@nod.at>, Russell King <linux@armlinux.org.uk>, 
	Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8BFD0180006
X-Stat-Signature: 9aaf3uyuuhgxon74xpock3yzbgqpw77d
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1795699677-299317
X-HE-Meta: U2FsdGVkX1835IiZtThRfTrXmbyeL/+IU8Xbdx6GRj6FohV8vQsereWWa4cmS8p8MI//wMmcIE4IkQAJpPM0CKPpdNL6d+R4I+2L7Xw2OCwyOr4cjRvtmzl1ur6s0soq3XohV86LW0GCbTbYr6UtmOp/PAqLCqcqifc4vi27IVnRpsOhBSgYQM0t4Yu6yPQxbSQbOGOjvf95jzTHiuqCRrqXnAOVSd9fXbgSaj88ZgUagdvMUNNdxCVcHPYEAPpePerSODdYnb6p1f6tcDALGp3e0J1sQBtZ09EWfkE28AalMgMm/eIm40+U22ox0Px7OqGMuMVMV+oAR96gj44cEq1deZ5Ew2vM2AYrQlGNBZRnNrdi0dEEWe9WKvM4Fc2T15g4BcVyIStgscZmV/61IQf+QBim1ATfWYnlgg97sBZLrJ5Upp+kpfHo0Eb2AXSRHmYIndlpx+DvTqPICEnMc0YDZqH1pciBaWN8rCCkYUs5vJhDyynEK0W9GFocmhK2jml4vA5pvTRdSsfOjvGmx1i6PiLd0x9k6xsVnwwKOQqsh1HGJT6q5//GBLrVxc/yVnxKg/tGjARoO2Pwg1JuS5NQvRbS2Gr8ib++nfVsgOWSuE8pSWP8i2YkNGVf4Gs3p5flMEicIAhEdZ0pYtY4ATAx0vgiNMuw0smCwYu2EVjWdZQ7EAyf1vTOcntCCJjDgydEBqLaiAs8/Gixz5GO3JTv5tPDMCeC0/Vioc7qVUsL0Y4qpWrESXJjk4hUc/LHW/GuJxjnGcKEAidOOO6vZ8CRkAMuyWT3rx1dmH+iGMBHKS7A7CeBXhPt/I1n8PMqcDJoHZVa9WJ1M8js31NFti5hxea5mpKoBXSLLzbWJoxVwyqnDEZDVlMk9/HZhtJ7U0aLFKPJgKkTm3Q8xhb5Z7tTPZl6CDKqyw4UCyGUff+kIaOXLXHnWAGlf6GwF4redO0kXHyym4BhB6NoId5
 OW6aofgO
 314dJU1RphanqC1fzYrGSJD1qyHaSMTh1Oy630LLqgH2jf4rky6tln2WIBtZhMAM2SVcjECMtXnICH2HbrBntZ+LtiPbF4upWWBQRLC2OqPQtvtGer44YNxPveyGX2Pvehq3JfBae85PzKZeMuYH/vbzxT8ILEDPYIAADAFOJCD9YmIOdzrBzyRXWf55jd8knVgpXCI3e9mI+KmBn/Udibcvuk3xL+xzvKSNapt3XWueZRyJCyq7SM6BLjFlEEk9DwPJ41GPv5Zd4TS6rX/3DRQ+/G8txU1R57Ljs766w4zq05D0RjpI9zK2KqEKp4XgXakYVKq2d4ZM1yLm97lwDtd3NkFSY21VZYtivdWmf50Ng8NchuXT4dKj1VYvtawoXVIS5XAnb/QAzQkeab0hrTMovc3sX5VJP3728UoJkAzt5ZJkoiUQSzgO2zI3i87w02E2gkdHjp7qS+AZjJys1d79OGBHPXITnpmYgU1pu7wqe0iUOaI2AlcbaixP1fgjozEgLHDLl5vkqSFPUj6o7xzx4AVSOWhAxTPw5NEoHEOOKHSTF0zh4hzQAgU6BIDEZ8N7pAFGWyO0NukReP7tNtD2lgpOzWrMyVeIN+ufWOEZaY2s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 1:49=E2=80=AFPM Arnd Bergmann <arnd@kernel.org> wro=
te:

> From: Arnd Bergmann <arnd@arndb.de>
>
> Unlike x86 and powerpc, there is currently no option to use exactly 2GiB
> of lowmem on Arm. Since 2GiB is still a relatively common configuration
> on embedded systems, it makes sense to allow this to be used in
> non-highmem builds.
>
> Add the Kconfig option and make this the default for non-LPAE builds
> with highmem enabled instead of CONFIG_VMSPLIT_2G.  LPAE still requires
> the vmsplit to be on a gigabyte boundary, so this is only available for
> classic pagetables at the moment, same as CONFIG_VMSPLIT_3G_OPT.
> Keep ARCH_MMAP_RND_BITS_MAX at 15 for this.
>
> Tested in qemu -M virt, both with and without HIGHMEM enabled.
>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Linus Walleij <linusw@kernel.org>

Yours,
Linus Walleij

