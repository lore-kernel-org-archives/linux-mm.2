Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2A2ACE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 17:45:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F7B08E001E; Mon, 17 Nov 2025 12:45:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 081F98E0002; Mon, 17 Nov 2025 12:45:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED9788E001E; Mon, 17 Nov 2025 12:45:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D50358E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:45:19 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6C714140231
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:45:19 +0000 (UTC)
X-FDA: 84120825558.24.0525FF5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7CB87140019
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:45:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FhoO3Xzk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763401517; a=rsa-sha256;
	cv=none;
	b=FNPr0AaOQF2419BeV73i2oAu8P3lgJajo3dwdh8RunJgdxRJoRfBn/yA42phGL991fP1mp
	YbrS0II7rBWGAk7/4Lj3w3vR6fXI1//ynCMCm3mUFvaEDbVLliPfeFzy/aNHFVKGk6z878
	ZRFBht0eWHJpjowDYg3gd9bf7fasJ10=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FhoO3Xzk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763401517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pRtIJ4qCQtEEElXVJZqTHhupadCQC/ExBHLLhNzxYuw=;
	b=z3gSyctfPLw1RREIAcrLIU37u2JZe1p1A35rTiJTQBzzAZ7Jli7CNQoVv9kahd/naBgw0x
	ApABuxXxB43PS0p0o2ztYCaplhD4po5gexeSv79KGvwGYnKwNY/02u2bRuHq+DBUkIDJ4b
	eeS8H52Qk/p0744ZsIkxUJ08AnVjHRo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 44FFB408C0;
	Mon, 17 Nov 2025 17:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A7AC4AF11;
	Mon, 17 Nov 2025 17:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763401516;
	bh=Wer16b+rB3LiI3HuFjf+ijnokfMhiJQbIGr33VdxFh4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FhoO3Xzk+6TFF2+9lQvnd9thOGHPmFq+yW7QFxuM5oJ0rYfpvHmLTjxk7216nTp6s
	 NPXhLHo4++b90aHHXVknKIZc7YuPqrB9BQaFWNOXGdmCzUMpUdF/W5sM+FjT+UAmbX
	 rLSLZhmUhLLhsO4y1eptazqJDNa6duGnehI3XL2CFbSHATAOTNKuQz8X2Ig+DqXmZZ
	 yzkumyAk4vMoV0mEFfPd2n9NvDv4kSY5WKwT7feGYeMiX5SsdgJ6pfgQHTtGCL2DfG
	 rhe9nrSNMboTGxMEXR9SD3EmuUAD3iyUb3RG28NJejM204eTI9ne90JT23hSLWo3EV
	 YyH2+xOjexiaQ==
Message-ID: <a64e9422-5474-46cf-9058-73aa29b7906e@kernel.org>
Date: Mon, 17 Nov 2025 18:45:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 07/10] treewide: rename has_transparent_hugepage() to
 arch_has_pmd_leaves()
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1762464515.git.luizcap@redhat.com>
 <9b56da53df2f0da40be68de9a7208d527b144afa.1762464515.git.luizcap@redhat.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <9b56da53df2f0da40be68de9a7208d527b144afa.1762464515.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7CB87140019
X-Stat-Signature: dz6nu5rc9xni4ba1kombykpfdwfc1e57
X-HE-Tag: 1763401517-51758
X-HE-Meta: U2FsdGVkX1+qWyCpduRW4EGxBGtv9z1iVrKvMebvbygw2jqNEul8yAJBF2FpVVR2OBlIjOp+bik4SUNTYj877vBPovWHLMXp4qan1WiL5DlH6MpH9XUEYYe1MDjCzgtK6rdxffM4zIcZcPW0Z1iE3KPhooSl2KXm6MykB78lNzDqG9cPpj6bzS0R0V0RNkxWsm6tcvh9nswdelwhcTnqukniwPO5XcIulHc+YHJNFsdcyPOS9TWgt91TwAsvBTyAdMOCX2qFa1MAZW8bjqkal3kzDcCNbJFxUiZ5tRCQr/Ne8Vgbway7b/hu19QbLQx3yoXDBTNwiDUxNpIzPnJQzFcQpn9dLJqeWB879ruoYlpUiuUk2no83h+iE95WZuMXhxXdsPN3DDelR78GNHAPhtkp9p2EQ7Z8x2bmSdKcy9ix8ent6KkJMT6v159dcxLvEkNOcTPmKmeB1YtL/NfiDhCKN3zCQyn3mQPj+ahFGvSLyoUSjkx98nvxpKg7M4ql3b5plkTZbc96kmtcdvw+5RIjJe3CMlLf+LyWV+cegdkRXAvRnM9O+xAVZwgotY3pFuyFxBa5l1e8wuWYh/c2wUF+RN/wI4sonAa/IMnIcLpRhcaN/kzhLIEpwUZ281orbPQlfDP/y6mEhkcTJdPXqOYKHSFsqYywnKYMzNC/wI0YE0wvVMf42s+uh0Sqo3g5FmZZqacMn8rysmdTxfw+cb27qMXhqYa2f5MIF+HbUg1jJpZBDoP5w7VUfMzTWaY5l0xZ6w/j8W4hRISh5GmNTWFTVVui//k0Y0UB49ZsEDyMyQ1Tnr8yS4ykw43LtPq0UY0MqFZ6ExIUTDm+OeVndzjlMh6QuaG3jFeJvdAkMhMF47yoUSoB5TTSxO8y9F0se3+0hq4LMPLQida3lQ4aZFtKPAtxFLVc742MNDHOqhgrQ3WJK50MiVAJziOwvhcJYgeTRx8ESNOy0VgsS8P
 Uty3fpS3
 uxAHJOW0VQHY0IBQTejHgR9PgT3NE4iOCzSk/gy5hQQ+gZKzp0ng8zZY7pVWMDd3zMbJkZhnmH1PQxZysPg4r8DLu9FUWeJEUMwF6sg4Ou3sAI49rx8lPQypR1tBqJqKsMBLCXQz6aTkvMuV+0ZrqTgsHdDkTEDm7JJ8U3pX5Jp7lctd5daj0WgTFEVaRgyPqvjsh82ha6kGYTBE/ho8hL1IxaEMGIZhuM3lTKG3NFtDqeQPq3ZowO+715rhPzkje5+HZVLWwjLKIFOILB+QMDo2Ruh+vj+iLsQ2qbpXc30VDjCbNTy8vSbqrnPyst/WBf1MU+4g1qSXrxVM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.11.25 22:28, Luiz Capitulino wrote:
> Now that the majority of has_transparent_hugepage() callers have been
> converted to pgtable_has_pmd_leaves(), rename has_transparent_hugepage()
> to arch_has_pmd_leaves() since that's what the helper checks for.
> 
> arch_has_pmd_leaves() is supposed to be called only by
> init_arch_has_pmd_leaves(), except for two exeptions:
> 
> 1. shmem: shmem code runs very early during boot so it can't use
>     pgtable_has_pmd_leaves()

Can't we just initialize pgtable_has_pmd_leaves() earlier then?

> 2. hugepage_init(): just a temporary exception, this function will be
>     converted in a future commit
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---


[...]

> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index e4c5f70b0a01..02a2772ec548 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -2026,8 +2026,8 @@ static inline bool pgtable_has_pmd_leaves(void)
>   #endif
>   #endif
>   
> -#ifndef has_transparent_hugepage
> -#define has_transparent_hugepage() IS_BUILTIN(CONFIG_TRANSPARENT_HUGEPAGE)
> +#ifndef arch_has_pmd_leaves
> +#define arch_has_pmd_leaves() IS_BUILTIN(CONFIG_TRANSPARENT_HUGEPAGE)
>   #endif

Ah, so it stays for now only set with CONFIG_TRANSPARENT_HUGEPAGE. I 
guess that's something to sort out later :)


-- 
Cheers

David

