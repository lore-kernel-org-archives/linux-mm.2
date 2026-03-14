Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6963710706E2
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 16:52:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6019D6B0088; Sat, 14 Mar 2026 12:52:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A5706B0089; Sat, 14 Mar 2026 12:52:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ADFC6B008A; Sat, 14 Mar 2026 12:52:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 397C36B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 12:52:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E66A31D08F
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 16:52:06 +0000 (UTC)
X-FDA: 84545261052.08.DA54CC1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5DFCE140006
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 16:52:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XnXToGGR;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773507125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wyU1YAdKQlDzo9xsab9cmhz22pPLJIhSCvdabTJTT+Y=;
	b=FEPmPBfhAYpirVfMGQ7T4DI5zIv2cWvg6DKVDosROoWycRG2p1cpHnjM3ydwcDuzRWncYx
	nBGoO54AXvPG50DM75xtQJnPkZWmV7zyvrXPNbdSO8u8yniIAnIh0xXhfSfWcP/SantrTI
	vXXSm3xdvBtybGZLuGT9F+DHhNdUVJk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XnXToGGR;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773507125; a=rsa-sha256;
	cv=none;
	b=yKbByJmdYHEu7eazv2ZStlyXzwMJ6C0FCXSmK4tEO+kge35r6vsO9H0MhBlnzYfiXgXAq/
	HwRBMYWd0BgfXRHhZ9fzvqe1IFDRSdAL0Gt+trOiLBobjfY2WYNyBUX+XhK9oXb8OuHIZ/
	ySmVLji3XlOmq7TboXRTfZZZF4uHGpA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BE32D60008;
	Sat, 14 Mar 2026 16:52:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35980C116C6;
	Sat, 14 Mar 2026 16:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773507124;
	bh=1471jLWOVZSrytB0F0IZoWYqDTHN7f7eGn8EP41SErM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XnXToGGRBghGk8QXZ5uceCRea0ly29YIpSx7ha2B+5ePTL9ebpNTeVkpNdaKQqDb6
	 i5lSJ5MPX+mhTnnOmuxpGjxCzfZrc5xHXOabOq2rWtaVi7Ch5aqoMYmqIoNXztOpxZ
	 Z/r2AAscSLPW8nGDuJi6OvQxJpge7H2BpW+wxb7v8Bh/sjY2gv1zKLBK6N84RBB+lJ
	 P6FvUakr84i76y7UvuewFUQxqjRgI0C9gXqlm1048c13uN2gJrGm6iNUoVD/R8IZEs
	 2/XyRI9JrxeFbBE1At38Md9Y0CWTrXT8FjZAHGXXFIjGal7uUBXscyakEfxtxFfm+i
	 UqQ8/tvHCHZAw==
From: SeongJae Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/damon: guard THP-specific DAMOS actions with CONFIG_TRANSPARENT_HUGEPAGE
Date: Sat, 14 Mar 2026 09:51:55 -0700
Message-ID: <20260314165156.86647-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260314093813.1359737-1-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5DFCE140006
X-Stat-Signature: j6aed359q9rwr4jwny9o7ip5xjwcwtzb
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773507125-149632
X-HE-Meta: U2FsdGVkX1/hhtlze6aA1h9kOtoCxRfDBGkG413daXpg1/tUN0WF2Fpj1/Vifn1QELC11TJsm4FCPmIJ4Xqf1qGazrz/bkr6gmc4P0IzSk98Bl/sR3ggPmNqiln/QMfPCuCiJpvgYwOg3c852xo1qGLKywXgj0jZ2lEFi5Gnim3fkCEJsfflhbLqgeqwT8O9UQtZiVaLxIgLakQL2SEw6ewu3u1LeB1GSN6ad9/Q1xj9Kpal0Neg17gS9g2CSJD9Adr7eRhgVXFUcUQRTDsa1zlAQHuDSOLxUrI7hhLw/7W6zDBLZYZTcSueLD94VRbg+7l5PfuXN5/6oZBa6tDk+M2pFv1Q4XVvzvk/1sNHvjNROu00qSMGIcB5yz6uYgSX3FE8Dv9Lthth41pnxYoWcKoFAvJz01JjHEJzwNhIblmM0f4WH+a+701v1nrLI9rV3d8BFCFdgX+7qUMiLDF/xR7vb9V33j1zMvy5vD3EpW3lysipwutEOYAk2hQH5OaC6EC0oFP+MlTOpIq/bZ8Y6D/0J/JKyYaSkH7+qPsRHu9TEYIx3/4bE5zIhb75coCVZBIf00AIx1Y+/YV+4Pd5plVZM/+9SGEWBltgva58ZFWHSyB8vKe/DdoqCwHg0895MlQqZswq8sxZNZ65LEoAhsLyiECNp1q+g29/btLDLazXNJq2m4i7NOvG5vPkpz8NPp59PMbZvCm66sY47EFRY2DaLLAzdkhqZJH1EMozk9DjbjyLKsUhsf1rPRKk6+OLGJDXNQ1FuVlZstVcJ+PtJCns3COuhYyOoj4U732FBBgzx0WwfYAWrVGIz0X09RcxN+QeOnKkcO5+bEUtsHHXGURgrLlR0U8fr3xA4urPHfLKY/eB6nBS3zCvoRviC3DrwKrouwINsyVPorCWh+nYHC0cSjMlwb0P7bELsMTkzQw5F0ZqVEX6cS3MuaBQSbfoX4g1j552h+LDxNl0dAz
 voZW+rlk
 sVT8eeEJa4AFVEA5pESEy6dG8/Ep9ifJuyaS8GgDP+jKcXGRQSxbm/SsxZGfely2c/kfo3r5k1RLl+Dg4FzttdzVJmgLTqrp//erHs4i5RxnepZ29d4EFV44BSkgW3fjnDOnsXadUXUfREJqfyV8i2z/2g6bjPufZaPIYsKp5wcB0lzjKrg50MHFTeKABdf+gynT5o7ENAWv/XPySyqip4M71MWuS681qfJ+uKn8R2z6RHflpVVzxu1Xbwv2+FPsrmvGZJaSZxifVZ7jo7jkDIdC8rB+MLrHDZe4VyxznVOBpsdF1OD8NO1VxH0VOHRt4sRvwHKfhNf5B7ax1jjMhCbbRGfhoYbDH2B11iqTmiRsAgyTovZbcFpPzdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Asier,

On Sat, 14 Mar 2026 09:38:12 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> MADV_HUGEPAGE and MADV_NOHUGEPAGE are guarded and they are not
> available when compiling the kernel without TRANSPARENT_HUGEPAGE
> option. Therefore, DAMOS_HUGEPAGE and DAMOS_NOHUGEPAGE shouldn't be
> available to the user either.

That makes many sense to me.  But, I'd prefer having ifdef as minimum as
possible because ifdef increases amount of code that I need to maintain per
different configurations.  I understand use of ifdef can make the resulting
kernel image more optimized.  But, unless the benefit of optimization is
obviously big enough, I'd prefer simplicity of the code in general.

When TRASPARENT_HUGEPAGE is off, DAMOS_[NO]HUGEPAGE will just silently fail.  I
think that's not a bad user experience if the silently fail is kindly informed.
How about updating document for that, but keeping the code as is?

> 
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> ---
>  Documentation/mm/damon/design.rst | 6 ++++--
>  include/linux/damon.h             | 2 ++
>  mm/damon/sysfs-schemes.c          | 2 ++
>  mm/damon/vaddr.c                  | 2 ++
>  4 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
> index 29fff20b3c2a..207219ee10d4 100644
> --- a/Documentation/mm/damon/design.rst
> +++ b/Documentation/mm/damon/design.rst
> @@ -460,9 +460,11 @@ that supports each action are as below.
>   - ``pageout``: Reclaim the region.
>     Supported by ``vaddr``, ``fvaddr`` and ``paddr`` operations set.
>   - ``hugepage``: Call ``madvise()`` for the region with ``MADV_HUGEPAGE``.
> -   Supported by ``vaddr`` and ``fvaddr`` operations set.
> +   Supported by ``vaddr`` and ``fvaddr`` operations set when
> +   TRANSPARENT_HUGEPAGE is enabled.
>   - ``nohugepage``: Call ``madvise()`` for the region with ``MADV_NOHUGEPAGE``.
> -   Supported by ``vaddr`` and ``fvaddr`` operations set.
> +   Supported by ``vaddr`` and ``fvaddr`` operations set when
> +   TRANSPARENT_HUGEPAGE is enabled.

I like the above change.  I'd suggest make it just describe the current
behavior in a better way.  E.g., "Supported by vaddr and fvaddr.  When
CONFIG_TRANSPARENT_HUGEPAG is disabled, however, the application of the action
will just fail always.

>   - ``lru_prio``: Prioritize the region on its LRU lists.
>     Supported by ``paddr`` operations set.
>   - ``lru_deprio``: Deprioritize the region on its LRU lists.
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index 3a441fbca170..b3fcbe84b5d7 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -138,8 +138,10 @@ enum damos_action {
>  	DAMOS_WILLNEED,
>  	DAMOS_COLD,
>  	DAMOS_PAGEOUT,
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  	DAMOS_HUGEPAGE,
>  	DAMOS_NOHUGEPAGE,
> +#endif
>  	DAMOS_LRU_PRIO,
>  	DAMOS_LRU_DEPRIO,
>  	DAMOS_MIGRATE_HOT,

Also, sashiko.dev commented [1] some conrens as below:

'''
Does adding this #ifdef shift the integer values of subsequent actions like
DAMOS_STAT when CONFIG_TRANSPARENT_HUGEPAGE is disabled?
The kernel selftest tools/testing/selftests/damon/sysfs.py uses drgn to read
the internal damos->action enum value and expects hardcoded integer values
(such as 'stat': 9).
Additionally, modifying enum layouts based on kernel configuration can break
BPF and drgn tracing tools that rely on stable DWARF/BTF types.
'''

There is no selftest using DAMOS action that defined after DAMOS_HUGEPAGE, so
this change should be _safe_.  But the code does have a hard-coded mapping of
DAMOS action to value, in sysfs.py file under the DAMON selftests directory.
Maintaining it correctly with future tests for different configuration may be
challenging.

So I'd again prefer not adding ifdef.

[...]

To summarize again, how about fixing the document but keeping the code as is?

[1] https://sashiko.dev/#/patchset/20260314093813.1359737-1-gutierrez.asier%40huawei-partners.com


Thanks,
SJ

