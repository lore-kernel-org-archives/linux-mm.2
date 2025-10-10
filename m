Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B87ACCD184
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 01:16:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9874C8E00A9; Thu,  9 Oct 2025 21:16:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95EB28E0002; Thu,  9 Oct 2025 21:16:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89B898E00A9; Thu,  9 Oct 2025 21:16:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 76DE88E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:16:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 07B59B3AF6
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:16:04 +0000 (UTC)
X-FDA: 83980438248.08.2394753
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3079E1A000E
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:16:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vKsenpAg;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760058962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JglsMyJtrNUqltqkNac1S2I95PDciblz/Yf1g4dJwoU=;
	b=fpXkqrBXohqfMdGhFsw+nzNtvlMQxkKwoHI4TovP91bbZhMmtvYELrtGxNEkrRmTrvhLYC
	RO+upljq14Qt73YkMz7bmdz0weJVDUqsFguJygQREc6Z7o59ynSdINKvpGVZ00NySdgmBi
	kl6J/sPs07daq6ysJPCnvwT+hc8R13k=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vKsenpAg;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760058962; a=rsa-sha256;
	cv=none;
	b=jxHUE4Tw29r1Feqp9D7X0LCVQO3WvmQcpL9iRD8rTHgImKhCgVjber1kqeBN8+ZmriGgMH
	QTgScBRdEaos0QMOSm6MUs34RVsFleezuBfTj0ryr0kkplf1gdqvKwtlUGV79/YTIC7PJ+
	0KJeClRdXkfpzy5/fBU79NTBGFBTaiE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1336B48C3A;
	Fri, 10 Oct 2025 01:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF5FC4CEE7;
	Fri, 10 Oct 2025 01:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760058960;
	bh=RmFN50/tFdDWu0Lu1oLgK6Ek0UwcaDtGkskQjflrkSU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vKsenpAgWw4PdXzyPEvRPTtM55CEkmIuOB06QpIL1HFkJaREveyrGwluU/V2fuGGi
	 q5TX7S4AkHAZd7NNOwoSKw4Q9atEptf5m3QREyryBOZ6qV8TyjDyjvN90WleZ6Id1/
	 W86zK2v0N2lj5WYbHcSmtpC+EsAstPuLctnj85O0=
Date: Thu, 9 Oct 2025 18:15:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Samuel Holland <samuel.holland@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, Conor Dooley
 <conor@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>, Emil Renner Berthing
 <kernel@esmil.dk>, Rob Herring <robh+dt@kernel.org>, Krzysztof Kozlowski
 <krzk+dt@kernel.org>
Subject: Re: [PATCH v2 00/18] riscv: Memory type control for platforms with
 physical memory aliases
Message-Id: <20251009181559.7bfa3dce6cb7265822b2d5c5@linux-foundation.org>
In-Reply-To: <20251009015839.3460231-1-samuel.holland@sifive.com>
References: <20251009015839.3460231-1-samuel.holland@sifive.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3079E1A000E
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: hpenysm64h6t6xyeigqgs681na56my4c
X-HE-Tag: 1760058962-728215
X-HE-Meta: U2FsdGVkX181ZzK43FP6nsKA47oysVuW514QQJGq27g8h5wteHVwjtVjg/C8iadbZ7yDw23YukH++p7kp14r54JdNZVmD8J/6kliTF9mjDGS70AzO+dXMH9zNuepZ0H7Jxf9RSfxBLZm85+Xx5any+k+nYRazGSMHWktX6RtCoo9ZEe353I4sWO+rooZ3hmUJxMqyNGeTu4sY0Cj0hQwqwCIuEvSnTwJN8/aWfxLo7dcY+m+qvPEnpbGL5RYiCNZ5dYckOTrq0aImZxZa9hbeaoXRVYB2l8NkxgfegcXJUF2uKq9nwljoN8Rg1pelvTzJH5WYyCIlAyGIEWkwEb5Ar/GrRUOUcqXMJaVnKt6o3N/ENnTXNWQuW2CieTAHvfqL1dNWzzzRPToeDOn12EeVWne19o6vsJSH1Xvq6bo3O2zZFCQo/r//FIefvMyJGghmQoLA3wOOfdgyj7HjmDvYzqP1C2vo/Sq7pBtS1GGAXds0ryBeD+0I2ebFfcMcTCFrzRoyzqG6DtvQbest0eKABJiVOSiRieK5VW1KskW3H0MDkZ18i05uGVOji2mEDn0fweD/nlJ/9ZnKbXV2PhsGqHokBRyyPk8o9a79Dpc0xE5w3vzA5BuVAPdQLCT8kGAds74ZVgBOEXFX7YyY5maK6OfMdWfPPhV3UhAYz0LE2pSvu/EqHoHh/yARC0Jay5FPTwIdxXj2efBRjYhxmHH/a92EQkHIopV5tYVUHMVEJWPqeUx6/m7NL5pvjdRN+UlwdsLJH7uAo2nc/k3wigwDOYuTW8E2iwxCeMZi+U/VPbscUm0k51JRCTHz8mG0gePp1v/0BfB4PJV6PjnbHAGq45Ys6F5MbeXN2Ro7+9RpTIdqor4HDaVQ3mJ7OIV3tOKlh/nBGUzo729Sb4co4BtW1rfvwFmF5uH/tjyZMKlP/QUaH0E3MpPRezIH+68Q+3u5QbDeqrPqPKTCbcrv3D
 0FIHSx0/
 Jp7ACUVA8timojQjsUhWYihW7OcQSovFwUgWRIMXCn/l33V9TmMMp37ekgh625EmQbM+T6MB0Dolq81TKBZIlrf9hKljVGR8qyD4sLC6rMQR/fekmvWhYnPsEblphWC8vXb7wR3mLqlTK+NoL+2b3OtQMdgiYqsbR2Qy968Udq8AY+E/mhj067sQn6fNLWeazUl9Rb0RBGp/FSf1zsVfJ7WcigSofYx0TiFf7HWDxu6djYjiHYwajH0ZI5KFGEV9aqgtBtb0tIb7JCk8j58mNxSY9Odi2H6512CpNKhxWcup5ycfxXUMeTApq/UNJf3DxF69UxKM7qSXb8ftwL7LUb3sf8G+XL+7YHQZAYsGH5lTABxP+3aRqTrVqf4sxZaGKAvjT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  8 Oct 2025 18:57:36 -0700 Samuel Holland <samuel.holland@sifive.com> wrote:

> On some RISC-V platforms, including StarFive JH7100 and ESWIN EIC7700,
> DRAM is mapped to multiple physical address ranges, with each alias
> having a different set of statically-determined Physical Memory
> Attributes (PMAs), such as cacheability. Software can alter the PMAs for
> a page by selecting a PFN from the corresponding physical address range.
> On these platforms, this is the only way to allocate noncached memory
> for use with noncoherent DMA.

Well that's weird.

> --- a/mm/ptdump.c
> +++ b/mm/ptdump.c
> @@ -31,7 +31,7 @@ static int ptdump_pgd_entry(pgd_t *pgd, unsigned long addr,
>  			    unsigned long next, struct mm_walk *walk)
>  {
>  	struct ptdump_state *st = walk->private;
> -	pgd_t val = READ_ONCE(*pgd);
> +	pgd_t val = pgdp_get(pgd);
>  
>  #if CONFIG_PGTABLE_LEVELS > 4 && \
>  		(defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))

OK, but how are we to maintain this?  Will someone be running
grep/coccinelle/whatever on each kernel release?

Please give some thought to finding a way to break the build if someone
uses a plain dereference or a READ_ONCE().  Or add a checkpatch rule. 
Or something.  Let's not rely upon the whole world knowing about this.


