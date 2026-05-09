Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D888FCD3447
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 16:22:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6BBA6B0005; Sat,  9 May 2026 12:22:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1CE56B0088; Sat,  9 May 2026 12:22:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B31F36B008A; Sat,  9 May 2026 12:22:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F1646B0005
	for <linux-mm@kvack.org>; Sat,  9 May 2026 12:22:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 41E8B160186
	for <linux-mm@kvack.org>; Sat,  9 May 2026 16:22:28 +0000 (UTC)
X-FDA: 84748399176.03.6B65752
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 335AC180004
	for <linux-mm@kvack.org>; Sat,  9 May 2026 16:22:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EoqRzVoP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778343746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IrBxZZNXFxb+Zp58pdnBC5MsiFvdod6aFhJlsBndR3w=;
	b=pi9DaoSNVme6x+IdaIB2F0Th+jWBvtkS2BkvX92AIWLcUKV/AZy+DKi2Pkm7eMm5krD61f
	trCL+tJnUsdglrJYOEw16bU/6nHq/ym2+TIu5AVMu/6pX7vct1lNsthoHmPFJPli7U7xrk
	1OLWGy7899eiqx2L8DiD9mNIjqDfR+c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778343746; a=rsa-sha256;
	cv=none;
	b=FXW7m+MYECGO8YZCxE7XLQitr3Eosnb/WE7lhtmTBdf49TtZApmgEAwWlqLdNGSn6ObgW3
	7jpxwXrFy+smiLiunnO7V5ZeD2r1KI7R8CDgVjq30TuqYXh5yVg6gTb6acmEymiopwbtpd
	K/+JPnB/zjL0PsGfVHUlTE5oBaZmuUY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EoqRzVoP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CB37D43047;
	Sat,  9 May 2026 16:22:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F7FC2BCB2;
	Sat,  9 May 2026 16:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778343744;
	bh=q+bBnUic3jJEdxGsCmvC4w3BR+OKv2m8On+Qe3HOB2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EoqRzVoPlrwY3Nev52tdMLwdD+AXArV8TgWwFCzDQcEecTZZe3pkuipRM6vRVG+tq
	 DZVXwLgpxLSH1ZYQOXNDtpBhXx3bQsxyAjeIZ8BYjqyt965SwIjphmEpkj+/cpuTU1
	 ujUIKHDTQC+M087iAcdOgDqmlnCOmNI1DnePcCxmGUOa2P2VQnQyW1d1R+7nA9HwOT
	 cCe/wx4N9CJW0NzVDG8ual/d+FHPGcOr9rgWdbAZbRGSoi4uNX6oVQT83T1WkNyNh+
	 E0cquw3bDTSnS62hyuCHmpUQ50cDHFy5dvHDvPZbExw5LzVCRK3Q5eBY+xG8jAlUdR
	 mZ+IW64+Vrkdw==
From: SeongJae Park <sj@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: SeongJae Park <sj@kernel.org>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	oe-kbuild-all@lists.linux.dev,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	mm-commits@vger.kernel.org,
	damon@lists.linux.dev
Subject: Re: [akpm-mm:mm-new 222/223] include/linux/damon.h:869 damon_rand() warn: always true condition '(span <= (~0)) => (0-u32max <= u32max)'
Date: Sat,  9 May 2026 09:22:01 -0700
Message-ID: <20260509162202.114645-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <202605092036.9mdDJbEZ-lkp@intel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 335AC180004
X-Stat-Signature: 1scowwtxwmahx3mmo317jx7xchsx7pi8
X-Rspam-User: 
X-HE-Tag: 1778343745-317027
X-HE-Meta: U2FsdGVkX1/gjsNfU8WjXSHQ3BkAFHyQH811NygAxVZUPYKBouT8sL7bgR1/bUnJH0gXvyuzPD5myNRV9RNGD/uL8hvcgH7lC9j/r1cLXBWTJJRhr5N/Eq1J2gk5tSQ4H3nU5eMlOj1bzYvBWTwX1MfbtYIrC4Gof6SXuALjHP0VHCs9cnZDZO6I7nEoubm/zg7EUJ/YquzP7hO1pAmhfj8wth5SBrS38y1d200E0KclbjriYPdtu25Q1lXY31RHaUAvTc+ykhD4VGu3g/nxc3JTRIchN5ScfIzsSPJ87E3LG9JyxsgOx//taqJ6SMbH/jQYFpnSYpktd7RVmRmuasvzXBsaY8/DEJHiuGRg25MIkVBC0UJQumAWdVu8lwXamTNOvlQBXmOrxQOUApH0tzFF3IePfXTShmwLFBNZ8gH4MQpxk7vGEmeLN+EllKug8EJLqWg+VebwzJgojUc1lSP9gakV8z9ORjnEdz5+jKPo3s44Zd6xJgVoOwBRpkldtPyZoX4Hun545gvJS8kc2wdlT+c4lo0ErcwtQXB16mOblZ3GRP+EkHLk3MwRBJgKsQrMEJRaMgBwl4QxvXBBxOPqKG/zrp7kybfMfyK0ID7a4BeV3dDy19OFDdb2jX+mjXlr/qQD86KiOdqfCNNOToWlfCaYwjaGb5iWAtXp4YxizHCJ6Jf1X1a3CCMxhQOsLnaQAfM21Qp+0I/v7mp5blnLdjHr+PfhtF3wXCWyTYI0LwgESNCH7ipODW0PSklC1gokAY2jLJEMhyk+TZYwqLwxGzFpcX1c3cDoZL6AlquO7TOpCSku/WyjThjymk+DxdOEYhu/eAaFvc55CKsjtlMDnCl6z9HhUeM+Cy3iibOiy9iYqRMGZvtiD7aYVM0FszHUKpMApgGUVKt0AIu3Q55jjOeYgo646w3RyXDmSHhO2xKiA5ihw782dWmMOt1ayhSvcVhRjHkRhfVFbKY
 cGAgPUEf
 /ulPxo8anIJXsnOt2myhet/eAHfsqprmwuTpR7blhFC47PbNJS+Qq5bPcdDBGsWztVYn4jrlQxBX0oesH+raqNONglpPx8jnw0HSw+Kz6f+0vY2iXNlQ9uchyjeFtwrbTaBNzhowXGMafuKe2m7bX1y/31FNOXHtP3ehIzrAKTAQM6jHChwQA+dflTBRwYXaDnsYpOgFQbWpeAOCOvss/Fe1YWOu+zi8lFCNdmlx2gG8QVr8n0msw4CRf9Pr7z5wpT01oXkrPJvGVvFti2z9pPrxGK+BOK5h0TofHBvNRk/s1gKxLtgXxwE3zkNX1bS3+A5MZ5v2CVUWTZVPXYZFCm3+cJ8XpGo9qXaEv+o8d6SjpEoj3zTMJinZ4DXnEZObh13oOh/wHuaW7MhU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 09 May 2026 20:44:33 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   7505bb13a9bb1f214310915ccc06643119fdafc9
> commit: 8b7c38eb9621c71d288eca45c8dd4dc92357dc07 [222/223] mm/damon: replace damon_rand() with a per-ctx lockless PRNG
> config: riscv-randconfig-r071-20260509 (https://download.01.org/0day-ci/archive/20260509/202605092036.9mdDJbEZ-lkp@intel.com/config)
> compiler: riscv32-linux-gcc (GCC) 8.5.0
> smatch: v0.5.0-9065-ge9cc34fd
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202605092036.9mdDJbEZ-lkp@intel.com/
> 
> smatch warnings:
> include/linux/damon.h:869 damon_rand() warn: always true condition '(span <= (~0)) => (0-u32max <= u32max)'
> 
> vim +869 include/linux/damon.h
> 
>    861	
>    862	/* Get a random number in [@l, @r) using @ctx's lockless PRNG. */
>    863	static inline unsigned long damon_rand(struct damon_ctx *ctx,
>    864					       unsigned long l, unsigned long r)
>    865	{
>    866		unsigned long span = r - l;
>    867		u64 rnd;
>    868	
>  > 869		if (span <= U32_MAX) {
>    870			rnd = prandom_u32_state(&ctx->rnd_state);
>    871			return l + (unsigned long)((rnd * span) >> 32);
>    872		}
>    873		rnd = ((u64)prandom_u32_state(&ctx->rnd_state) << 32) |
>    874		      prandom_u32_state(&ctx->rnd_state);
>    875		return l + mul_u64_u64_shr(rnd, span, 64);
>    876	}
>    877	

The check is for 64bit systems.  I think this warning is ok to be ignored.
Please let me know if I'm missing something.


Thanks,
SJ

[...]

