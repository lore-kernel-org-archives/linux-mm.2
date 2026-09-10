Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72D5EC79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:03:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 883CF6B008A; Thu, 10 Sep 2026 07:03:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85B186B008C; Thu, 10 Sep 2026 07:03:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 773326B0092; Thu, 10 Sep 2026 07:03:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4798F6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:03:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D2F0112048E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:03:23 +0000 (UTC)
X-FDA: 85197566286.24.816C829
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 16BF218000D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:03:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dXMfGLih;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789038202;
	b=zWcoYcks8kjsuVJkP6Iklej5WHwY8RKilwIw+cw9gQ1RTK1BD8deYpd3RpTA2g4UYlivG3
	AnlxAx5w0c9NA7y9tBodzeO2Pa8HiDmB/46auYkXnCzpxEpV/Yr2n/UkwPsenytC/F/EJQ
	JYBpPQWDu+owGDIiFd26qvRgjptNrEo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dXMfGLih;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789038202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xs5N6d4Q3VeK4CPw8sjumPscyGSXs4KBPkCsQSrD/Fg=;
	b=cdyhL8jor386xqlrIMjkgpGC0WLDzTqBnUYbNACkdhl623Foc1h3d8ZlvdgJjEN6nqUfUE
	0pwzLydgtDUNpmPH3xqQLm+FtMDvohQ8cgL7yxO5afmIbb2WJUF4QbR4xSfSvykMf1u73e
	qBZt+zHFgL/PHFa50SoujebOFvisflo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9CA48600CB;
	Thu, 10 Sep 2026 11:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B37C1F000FF;
	Thu, 10 Sep 2026 11:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789038201;
	bh=Xs5N6d4Q3VeK4CPw8sjumPscyGSXs4KBPkCsQSrD/Fg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dXMfGLihXvyR0gahQ2AIkqMeQkGub8BMfOB+ZZ98l5ud+Ms7cAsxntVKUZ1utDJEM
	 nQ4//pg74UjHHC8mPasRfMu8FSDkOatRrczqiiC3LaTIfHBHPmv858G9GISLwMrdX3
	 5t3/073kFkvaDHBaTdhFkEOMDmGpUKKC4E2Cj0V1n40/0ffKbTF+hIGUn0USrigbVC
	 D6iE/rxT2btCRdq9PqG7qeHgFtHMEe2GvT962NY0ILA2s/3pNyarm41S82N//cyR8P
	 iMhJW8tTmz6rcSiviTtdveTTrlyb320BlmbnPfWLAUCYZfF23wyaCs92UlD0YEhg6S
	 GHLaU697xvBxQ==
Message-ID: <bc96d00c-f343-42d2-99fa-e1f5fb11a72e@kernel.org>
Date: Thu, 10 Sep 2026 13:03:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 13/21] x86: mm: use pgtable_level enum in
 effective_prot_pXd()
To: Yeoreum Yun <yeoreum.yun@arm.com>, Russell King <linux@armlinux.org.uk>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonas Bonn <jonas@southpole.se>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-openrisc@vger.kernel.org
References: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
 <20260902-dummy_ptxp3-v3-13-5d8f5b17c25c@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260902-dummy_ptxp3-v3-13-5d8f5b17c25c@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 16BF218000D
X-Stat-Signature: 6hsx5q58ytnykze8decjjt9rkrctkpfp
X-Rspam-User: 
X-HE-Tag: 1789038201-442326
X-HE-Meta: U2FsdGVkX1/NN8HsbnLVCcXlrCAZhUFlD9CduBSAfDNU/pg/FuWs2xFonumWFp35gF9pBtUrGvr3pbIeKv+DFojpqPnn91X53LJN+nFNeLzopEo/0SVkuvOMfFmEMp+eAdnJ0APDfgiaAcwV2dpSW5kICeUcdZY9+/ZbHI36l06W/kmMSSL8qF5dE8BV2rOYoKDjLYo1yxZ9jFZuXEn9T164nj1llounSTCekJyrBFc81C2WiSr0vsvf9tWAeMZC99DJ9mH7bwAjYXKKokKcyXevyRVuxcxdTLhDFAr3zkSNnMn6HcxZT4QMK4o41A0P8HammO5d4JLVnCmkRBcy4y7bosP1GfaDtVoH+bK+9t/j0rklswMnQWFwn/cQArMIllZIgOfMSHdZfPfhKedo6Sy2uYk1DkSNRPRql1bwXsS452QdaIiiB43rH4GyLuXXn4U8cZTDCnwXa89RWqt/nd4yzIJbMWIaCoFOAmJYPyvOmxRoQBR0DBXrLQMuliSXCv8taCkwms2vmk+vORX1xGIRtJi0HpBZi4di/QQqHblpqI+kY4LeUjmbI5rBARNaQrQDRwWK5fKxRFEFF+BNX/6zSD5YT5ONZyg9esLktTZPeFjNWa5XA6TjK98TWWpNVfpxRJ5yfLpsqNebiKgyWr8ck3Yos4/9lwORp/tovtddM7On2jSD0/vCAKF64aBKoKe/RdSx6AOiWrcmgn4QfBHLePU3FKtfOI3az2yF+eo88UHABBqCO/WxIxF/5ctP8iAdEmUTcgDzKWMPwuzswL1/gyWClP1SKad6V+ENZMnBsFoDovzrlGyAZABVS/NimTu447xXbKP2n0olI0IixD2sRl7cEbSzh8CrAHsbHyPqCC3Mr2XAxd63LxsN/YQLH+IskJiv7yLSCnan39ryRiXVwr8YOJQccjmqCLENyZtqhk7sFS0k/OJ1a+d4V76gNCpXCRQuYdas9GYOB8v
 CD0HJ2bS
 PDBFssm+4QuGYcfIxjuETo0EGm9dlvtNqMcH8/dl6/4EOvfoV549nOLa9ulgOtE1GcHUOuzmiYlTj0bQ43Z3utaGzcaFZK2nLtVeFNnw3nPxHM6t6LoNoUb3hkNTt2Scy4axljtah6IUm0NzQRHVAJ706kjdae0zgIhX/TVSxUJBcXB+GnUFuNV9q24rqjALHJS6aobO+GSyd17E/yC5NWFLG78rmD6QMZANHhQ0lHOGINTMyR349OeRmGEig/Teh6N7d7HvBUK1XeSsuP1W6SWj3Xl0l6PXv/sPYQuXkC9ZscuQEcza5H/9OC29PkTdyGLKsf1D8HaQuoYgy4r6YaUI1fkFDVV6tJudeC0gixTRsZaDFa2a6F/Uxli+RDZNWTzKB6zwa61+zUyc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/26 13:56, Yeoreum Yun wrote:
> Instead of using hard-coded integer in effective_prot_pXd(), use
> pgtable level enum.
> 
> There should be no functional change.
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

