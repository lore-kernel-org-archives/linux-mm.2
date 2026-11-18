Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96C75606A331
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 13:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bbKcnKh8
Received: by kanga.kvack.org (Postfix)
	id AAF776B05B2; Wed, 18 Nov 2026 08:08:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A868E6B05B3; Wed, 18 Nov 2026 08:08:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99C3C6B05B4; Wed, 18 Nov 2026 08:08:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 756886B05B2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:08:51 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6DAE94071F
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:08:49 +0000 (UTC)
X-FDA: 85448269578.22.4918B95
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9A9504000B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:08:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bbKcnKh8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of linusw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linusw@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795007327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tKDarfxiWOcLoTCSjE7AeoaPEMMkfbEBqcBYvqId7kA=;
	b=E/lmORLQSy9osDq82x03prYuAVNEKc1EhPBAPHooCRr9NOcsCElI0kv5r46CWzeujZ7bHB
	kCHszwtj4Lcxu9CuhzChNL2pj+2jodAyKAtD94ypXOAWdwSYB6jOWv9nikxty+pxgxj41y
	MmdnIAQIe29nGRXlLZ8Ovz5FdQMh0fA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bbKcnKh8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of linusw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linusw@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795007327;
	b=pUu+DdttfWpWuE8MhgkN41EsJNxv2rDZdbVi6GcOTmBSsWbrUUsjI1sS89GVko1J3CfZaZ
	tCePrCdOy+Fqg0yG2nVfRNhNKUm1l1So2xPBU3UtAkv5E/ROPtI/jBU15EUSzTyHUh6ZHK
	j6xslVVOLfWL7edOpbjjF8luw29JNMo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 21963621A2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D01A61F000CC
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795007326;
	bh=tKDarfxiWOcLoTCSjE7AeoaPEMMkfbEBqcBYvqId7kA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bbKcnKh85P28vFyNGpKeAdp1qViEiDSgoqPdjYPR299BJgFPfL94OkecOTx6woA/9
	 L+oosXTLjnKzdNTy+6PlD9YCL0ZTvby/CoJ4TuOt3+iI8hmjM1Pv5bCglCBG5PuZu7
	 7qokjmhy/uT2UWKAu8Tng42SxTVS1nBRXm9heMStVq2ODZH6MJ6Z+WpQ6kwIu9HlZX
	 7oLchHaGmy89HszFBZVRgbAXOKcPUWkOFoT9xAMbngtlXPnKj8bHjeHWIFnqYXHthn
	 AGJkSgPHvtnMU3n84GXHnTb+8SmOHdWNaBpZU0fhhllz/4ZtipbvClGWnL+YEqQJN5
	 SVV7UvR8WUavw==
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5c17ef1e18cso638530e87.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:08:46 -0800 (PST)
X-Gm-Message-State: APuU4Z/2YVpo3Z/Gx2B2Zl4OUC2Mvif0uoTiH+FgI852g7OvOp9GKYr/
	GGf9SngP4a/t+LOCDILO+0TYtsstEDJZyq0ylSjvPe9tayxzn8MuqCUYnMS8Nyqb0nOeQSmKCkj
	Jml6MSght0CTl7nOi0br0+4MT/YPNubI=
X-Received: by 2002:a05:6512:3192:b0:5c1:5a83:4285 with SMTP id
 2adb3069b0e04-5c1aa2b16ddmr1030883e87.60.1795007325480; Wed, 18 Nov 2026
 05:08:45 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116124832.662455-1-arnd@kernel.org> <20261116124832.662455-2-arnd@kernel.org>
In-Reply-To: <20261116124832.662455-2-arnd@kernel.org>
From: Linus Walleij <linusw@kernel.org>
Date: Wed, 18 Nov 2026 14:08:31 +0100
X-Gmail-Original-Message-ID: <CAD++jL=Ugp2MH1nvBr=+_o6a9UZ4VCU04KY7Z22pzEnGwHAWTg@mail.gmail.com>
X-Gm-Features: Aa3M54rGSDqneypUHMmdmL7dJMYPaYSAWAq3AteQhJuMu5nbQzZhIjBnrf8_3UI
Message-ID: <CAD++jL=Ugp2MH1nvBr=+_o6a9UZ4VCU04KY7Z22pzEnGwHAWTg@mail.gmail.com>
Subject: Re: [PATCH v3 01/10] ARM: remove support for highmem on VIVT
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
X-Rspamd-Queue-Id: 9A9504000B
X-Stat-Signature: bympmsummz14od8zoudprjmscbm1xima
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795007327-726830
X-HE-Meta: U2FsdGVkX1/ocU34KLZICIDiBrSQQIla3WFJ/fcAD+om3x9UpP2wdRqJlS39/8qdr/65JgAJB8xfw+mkhbl26Mgtc0EAxDSvHM1886azfACHTy+JYjCNrBMBslr2sjNpiZGZMnka63RtKw3bKEnbqgBO8optBrQfyiBbA397KXBnyIkVSmhhZSMyihkhwFifOjUs6v1hlJ7qwuREPImHGkP9OzO13HYhHP0kne+JyU13FvHtKclbIgITwKc15GsRU+NmthNYJvKFk9vW6Qq3TbjmwAOsjpEldn9mkzBthLqo7vOiVeKJ90bJjeX6Bma//n07rp3xi9iS8oKNuzm8k+Jf2J9IXuqefwU/lxtQbmGgx/FuoXm/wMW/yRczt0hs+0xz8qMqFzPblWa6AhH6rQ8vbQ6NPeFCOiwQUw9yZD4NoFz7uAbiUwULqK3teMk37kMzKtLbq03KQ5ucb8CGjO+ZVycZCMponXThKmn4G0o2RF7FasqxW+AGBCOIxifQqjdo2i+ZOVhQZ9xyM2rfzpeSXFFtILeQsExJSnpkwmHEyC+ISqHp+FGc50yTfjAaw1zjq2v2ivN1kW/e2GkSUcA20AvATl92XvHH9kBZiq89CkTTXI1LoSP6F4rU0kQmk5MuuDOxldX9NWGdgn8WKL5TM+krnO9Sm4WWEK4n4lXbu7iBNBx5eUFIZkTIOjDy5XAYtqj8TyBGxU339U6DUe8+qLz0T0FLjyQ92V4Ss1GF4VoRfyLIenMvPHMJ4OSjPRNQo9RMvE1juheVMJmhVOMirTzOQLzvTl1ftvlsUfMQUr75dQvaLFNqNrjyKjs1LZf9lJCb5iYsZnGs/HnsVFs8gDB3ra4kzLM5mjCc17Es8ddQHK7RF8Aht9Sc2zQFXgp1chtrx4dSFPM05opY3NpDO4qS7kruG1wZgxnn8I/lNgV6aK3BbBrZ8D7WCAzNWvZVd1GBDD8CBgnQUvg
 eTOmntzs
 YkiFI0DMpMFjIKVJ4EuY5hFuxAftY6pJHOZHQMTeveCUo4vCpcv1XT1yPDypQAUx8jpMlgGUQPi3aAXeoPU+5edcZJKxszzTBhSzJR1EhRST1YoOOQ9nOokOkcfgw2X5oSMtbmHZs48nMxGgh1GVvMYcQPiq0KI9B4CYUbwN+yGbHEn5NNOxCU/MMXs4+/t3sVOWNgiRZlzzMaayI3bUU2qzN+WX7XhWWybmJohWOQ7XDkwjMzw5HhtP9xUsk+O8Y97DoYXc4TznSGm60S6DxQSpsYm4OJEVskzHo/cjvSmqI4L9hdh4c6j44Zmns72HxPfRy/OOVhjl9KL4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 1:48=E2=80=AFPM Arnd Bergmann <arnd@kernel.org> wro=
te:

> From: Arnd Bergmann <arnd@arndb.de>
>
> As Jason Gunthorpe noticed, supporting VIVT caches adds some complication=
s
> to highmem that can be avoided these days:
>
> While all ARMv4 and ARMv5 CPUs use virtually indexed caches, they no
> longer really need highmem because we have practically discontinued
> support for large-memory configurations already.  The only machines I
> could find anywhere for memory on ARMv5 are:
>
>  - The Intel IOP platform was used on relatively large memory
>    configurations but we dropped kernel support in 2019 and 2022,
>    respectively.
>
>  - The Marvell mv78xx0 platform was the initial user of Arm highmem,
>    with the DB-78x00-BP supporting 2GB of memory. The only remaining
>    board file is for Buffalo WLX (Terastation Duo), which has only
>    512MB and is going to be removed soon.
>
>  - The Kirkwood platform supports 2GB, and there are actually boards
>    with that configuration that can still work. However, there are
>    no known users of the OpenBlocks A7, and the Freebox V6 is already
>    using CONFIG_VMSPLIT_2G to avoid enabling highmem.
>
> Remove the Arm specific portions here, making CONFIG_HIGHMEM conditional
> on modern caches. Since the cache type is enforced by Kconfig, no
> boot time check is needed here.
>
> Link: https://lore.kernel.org/all/20251219171412.GG254720@nvidia.com/
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Good riddance I'd say. I'd choose VMSPLIT_2G over highmem
any day.
Reviewed-by: Linus Walleij <linusw@kernel.org>

Yours,
Linus Walleij

