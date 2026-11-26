Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49669606A331
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 13:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OKjmQFPo
Received: by kanga.kvack.org (Postfix)
	id 55A756B05B6; Thu, 26 Nov 2026 08:28:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 531B96B05B7; Thu, 26 Nov 2026 08:28:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4482A6B05B8; Thu, 26 Nov 2026 08:28:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1ED6F6B05B6
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 08:28:48 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A23D216044F
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:28:47 +0000 (UTC)
X-FDA: 85477350294.12.8484174
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id BB074A0012
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:28:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OKjmQFPo;
	spf=pass (imf15.hostedemail.com: domain of linusw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795699725;
	b=pjf67N7O6RqWeOOSerbqVjtISZQfYg0E2vQRQxkX1mkv7vQj3LzvyDuVDwiE6HyIfFvctL
	Q+TvylhXzNKJDuOhjncVxTY7KU/d0Rsh1L2ZWcNeIZJFZPbB2LTIXkTOhf8wEYT7q4v7uA
	j7CJZqvJSoeNN9PQph4uRAYZFVcz28U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795699725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cjfeIB7Jh9Ac/AfayNnL1Yf0x7S27z/ryKSokFRvmis=;
	b=vgng8NYshNvBIFMEWoCOAT0dU4TgFkKwgJqZJzuVWywZk+0O8gmugc9lTHSD/uWTmxzS5s
	zhEozp6h7e+zkmfb9CASsP4ZUw3Nbeluj2UWlH9ROIk901qeV0g15gC5Iz/v9YViLeFdO+
	GSRkow3SoTcEYh3iScJFrlio8fAhjQo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OKjmQFPo;
	spf=pass (imf15.hostedemail.com: domain of linusw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0727745669
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 616841F00A3E
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795699724;
	bh=cjfeIB7Jh9Ac/AfayNnL1Yf0x7S27z/ryKSokFRvmis=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OKjmQFPo1M75NXkW1bHMDWybQdIuae5BfdUB+xGnCd8WnZUl/pDfDcBO7rB3WwRBS
	 /Ob1mY//DhcXEHQ/uv6PMdV+zDPkCmw026DdqzRidvVfO57zNsZ5lx19VY8mEJEfRI
	 NbQBvzhp+gPFFwQBIh98wVGgz0sVb5J2qhuKj3w2sLjZLC+2Jz3xd/iXOMiHZuSFhu
	 VXk/8CCos/vN9KGdGMsSfxA8Ueh0PcXCmFe3AY2A44UJ4PQrSBxPd/ZTi4mfET6X/v
	 ExJt6R9GcDL0CkqyBHW7iQlwm4AKk2/6tvRSIaioKBzEDyuHPX6sX/aLjG/Prito3n
	 cJnEjZgWJdwjA==
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5c126f80426so6743898e87.1
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 05:28:44 -0800 (PST)
X-Gm-Message-State: APuU4Z/3Yt65LlXBoCWdWoVYo+S0VAOgpxpZVxC54bxMbV2abkY2VQT/
	9+ja+dzL7k+werqDhcmggee82Oms3cBUj4b+Y2fwDbOqyt3QPBCDrEYJuXQfsltVcakKbKfjRtf
	qska9cuCxZkE+HnOhpeZqtH9EGSFxosM=
X-Received: by 2002:a05:6512:124d:b0:5c1:56f2:fda4 with SMTP id
 2adb3069b0e04-5c1bc89530fmr5518571e87.49.1795699723141; Thu, 26 Nov 2026
 05:28:43 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116124832.662455-1-arnd@kernel.org> <20261116124832.662455-8-arnd@kernel.org>
In-Reply-To: <20261116124832.662455-8-arnd@kernel.org>
From: Linus Walleij <linusw@kernel.org>
Date: Thu, 26 Nov 2026 14:28:30 +0100
X-Gmail-Original-Message-ID: <CAD++jLmT3dgWNhwXnxBbMWT4FPtM85j7pGqphVhofVDn6bgq4w@mail.gmail.com>
X-Gm-Features: Aa3M54qt87pVcinKxHwHL_cdEyu5uWkoYM1H8TRwnc8234Hd9kxa6PUDkX4jAZc
Message-ID: <CAD++jLmT3dgWNhwXnxBbMWT4FPtM85j7pGqphVhofVDn6bgq4w@mail.gmail.com>
Subject: Re: [PATCH v3 07/10] ARM: defconfig: turn off highmem in favor of CONFIG_VMSPLIT_2G_OPT
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BB074A0012
X-Rspam-User:
X-Stat-Signature: wzz5drx67nkq1fx5cymt1scnf6for3pi
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1795699725-869573
X-HE-Meta: U2FsdGVkX19cNVL4bT3VNMBDj7MVlN4i5a45mKyXGHP8dMuSXcDnlBxf4vuSnJaDETSzDdbCFsFZxOF4dUcVZBXgFgC8+tdz2BE8uUfhgvE+zdGVFYFUCDH8nWlAZe51FQO4io7IcdfMxp5HCTVZT9CmnJ/SC4moyUW6pHz4dTn76AqG9QGyVx9BxjAZ9sYDArKi1FRzrVTgkYlkI0ywc0+pOQlWvRdmo8T0IHC+g+k5+ArFuWpA/bxkHnWHffnTP+DTNiEoUuzsJivVuVp9CynYAXsN5KIneU1exnKOlapvr5cBxtAbgefsCJrUU2x6lKhqEIPschQjhVVQ3pQpShSXv8Cw9OVBtSGWGqFd3C15gHbUtDpc8PJWhnvuwFv74r9ndh8tIVAGTenhxAb2PJvSTAu5TidKzQCJdy8yYYFTFfPy4AOZKcIPm9L+YoNofLGdvuYFIgAJ4wSLDyW4Y/KC248VbvHfFUqVrMV1fHCxik5Q5P2y/eKx+9MTK9wwnUG/cXemmXxBB7MCSpgwo70TKkUF4T5vLe8Lzbedwb898xTedygGDYAd7fbe9wEQQ40mKv+MvrvJ3xFyZiCwHa7YTBZBUXrDzhRJthToyqc318QPpVp3FEMW/bOL0aLM2gWYFrgWXxhY+ZiYd+wy1Z8hPWOKLsHJZ70mQ0YuohVFHrVN3cZsI+KCpntEQQv4IfacQYqhUeo6RkFT5LZzglQLH4zmvzjugwQkcvr3MX9X6ZuBBr5Kr6gzXUNEP+K3FAy3vhrCkZ+7Ufu9oZs4jGXMQKiVAQUPeKMR2Tv6ECH+JHXW0QMG8nbX2EjWGxaMMb4BMtOm2mcxjwVZE4C4CO5mvftpnxNq3NS2xtDtAf+cxtg1DKjHN725/ri78Jr2rCbqYHcjm+9zCAjDCjfFcqwn3jpdjvajlKdWEuuKutU039qL6M5KSpcsfE+/+RBUvxbGPGsX/8eU00TUTIC
 GK7D+m9Y
 QSNafvZqTIdE/rJhLBKlnngnSIdiO4KkWx5DGCITBjuRef6w5zu129Z3KptRqkduAhgiLvpKC3oZ8H1Q8CRtk6wBO4tT6C/x8VS8XjJC898sh/8xnxIhE+5UbrPeAGvOEKB9uHno+FHY/KdWQFs6tZzGp6RcAxG4OenVNFxbGZVGPOkR6FJ9irTX7G4X0A9rzud0Y+WwTy2rDcH9TfuUpM7KvbxKobr+38tdT5Aw4ssOB/QY00Zr0ikCT+0laixRZMKeI4vxcUY3kHEQTMl4YY+vVVAwCJV6zOqzWXK3NXRArniigGyaSSjMaSbVExAvMJgTgj8tk6ELJ4Z4yVlzpAfPEIilSW8SvOQYaQbGlYtfHsZ4hAF3MQ3aDIM773EUYjhWMtHCM01zJJuQecI6W84CPU1Skfa3HJJ6bToG8ufL7dlGGC0VIHzrCjBGNfl8D9killS/PuGP62smYtVqP3qhciDXCqWIf0Y3vbSo/OUVfeq2lH3RAEWJosmncOjUzJeMCT4DtYikrkj8tWCoeB92a73kznBguXkaw2fbNZGqyYQ2lTC7UseReBRr78hsJnkMf4L56cFaEuw0=
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
> The multi_v7_defconfig and omap2plus_defconfig attempt to support a
> broad range of hardware. This is at odds with the setting for highmem
> being slowly phased out on the one hand but still enabled by means of
> CONFIG_ARCH_OMAP2PLUS_TYPICAL, leading to a default CONFIG_VMSPLIT_2G_OPT
> split.
>
> None of the upstream OMAP2+ DTS files actually list more than 2GiB
> of RAM, so it seems fine to just turn off highmem by default and use
> CONFIG_VMSPLIT_2G_OPT from the defconfig to still support the same
> hardware but not require highmem.
>
> This also changes multi_v7_defconfig, which currently supports all sorts
> of ARMv7 systems except those that require LPAE.
>
> The best comprimise I can think of again is to use VMSPLIT_2G_OPT in
> place of highmem. Compared to highmem configurations, this should be
> an improvement on most machines with 2GiB of installed memory for the
> lower overhead and complexity, but it does degrade machines that rely
> on highmem to access all memory, as well as reduce the available user
> address space (1.75GiB instead of the traditional 3GiB).
>
> For aspeed_g5_defconfig, the decision is trivial, as there are no
> 4GiB configurations we need to support, but g6 is known to use
> up to 2GiB.
>
> If you run into problems on production machines with the new default,
> with the absence of highmem, or the smaller user area, please complain.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Linus Walleij <linusw@kernel.org>

Yours,
Linus Walleij

