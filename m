Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EFFCC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:17:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADC4E6B009D; Wed,  9 Sep 2026 09:17:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AACAB6B009E; Wed,  9 Sep 2026 09:17:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E9D06B009F; Wed,  9 Sep 2026 09:17:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 83DF06B009D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:17:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D40D6120165
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:17:23 +0000 (UTC)
X-FDA: 85194275166.28.326C671
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 51C728000D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:17:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R3LmLYbg;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788959842;
	b=mFlcAt10Ew/I6PBrYpTlW1Cqh4o+P3z35VPEcKtrT0wTaOFuiYHi0lBRWMLn/Npg6YmDY2
	6q9Kf06SeRZepA2kZfANzujLfQHJFq4Vc2pwzCvDxqfe6F7DAG8Q6+i9q3wWDXG1WXDoGm
	zVcNOKlbRPiiEXiSK3HvhbsKwIdWjdg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R3LmLYbg;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788959842;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bEJmZIALLcjQXIB+g3fXQRl6DWuBiippwKn6sn+DjEU=;
	b=duH72NTD4mIk+Jew5iffJK4PZrOWay0rdND8JGVwZ3s4ScbVIVaIC8gWyx2XVLh9WuqkXD
	E3QHeaEZpLReHT4m1/RgM25tac8IPzfXANtcyUvY88Cs4Bi7nO3SCJeLPSHHqIWtxiLQ2t
	wmRoa3xyN5lNikaUYyCZq6NZIpCTZgw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D7D160211;
	Wed,  9 Sep 2026 13:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1F01F00A3A;
	Wed,  9 Sep 2026 13:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788959840;
	bh=bEJmZIALLcjQXIB+g3fXQRl6DWuBiippwKn6sn+DjEU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R3LmLYbgntYK+I4UH4uaxCnCYpQyqZDM2PKlOOWsUfSoMifDN2Xn9LoMlaHh2l+Xn
	 CI4hf7aXtDaTdIs12+sG0yKD00WsPfl11cqaXLv4DoWFow+Wz/n8ybKaLvLXMfHgHL
	 /tnzmxAmYi4c+8FHMgbNhwF1Php8YRjwVCh+IOp72LY3QyAnTG9OEQOMhudzopLfES
	 vWoR0svfqF6zkAUEhH4hCx6zp/tOiAq/wpuyXfghP7qhI/xJZmPhJVm751wxtY7E83
	 8/4XUtkwIB42i1cCOjlyIBM3Lxa5Nc/V5CXWYi/703OAiVam5yVYcdM6w11KL0nZmW
	 BIBg6RLrYfjhA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 4/5] mm/memory-failure: efi: answer whether a range
 is poisoned
Reply-To: sashiko-reviews@lists.linux.dev
To: "H. Peter Anvin" <hpa@zytor.com>, "Borislav Petkov" <bp@alien8.de>, "Michal
 Hocko" <mhocko@suse.com>, "Zi Yan" <ziy@nvidia.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Breno
 Leitao" <leitao@debian.org>, "David Hildenbrand" <david@kernel.org>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, "Liam R. Howlett" <liam@infradead.org>, "Miaohe
 Lin" <linmiaohe@huawei.com>, "Lorenzo Stoakes" <ljs@kernel.org>, "Ard
 Biesheuvel" <ardb@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Suren Baghdasaryan" <surenb@google.com>, "Mike
 Rapoport" <rppt@kernel.org>, x86@kernel.org, "Dave Hansen" <dave.hansen@linux.intel.com>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Johannes Weiner" <hannes@cmpxchg.org>, kas@kernel.org
Cc: linux-kernel@vger.kernel.org, rmikey@meta.com, harry@kernel.org, linux-mm@kvack.org, kernel-team@meta.com, riel@surriel.com, kexec@lists.infradead.org, linux-efi@vger.kernel.org
In-Reply-To: <20260909-hwpoison-kho-v4-4-359313564495@debian.org>
References: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
 <20260909-hwpoison-kho-v4-4-359313564495@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 13:17:18 +0000
Message-Id: <20260909131719.5E1F01F00A3A@smtp.kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 51C728000D
X-Rspam-User: 
X-Stat-Signature: nwntrwcmqqpsbsxi779uduiubfuum9dk
X-HE-Tag: 1788959842-648358
X-HE-Meta: U2FsdGVkX19HsrTM+5oe1IRroILZ59zDw+IWJLRtSpXCiylsoQycwWgEUmoVJLgeBujTAnmBUTjEXHXRJyLjtWZ/05p3mC552vzaVt0mm8OqwYRDTMndZ2ezn0Uj1tZNu2YsLCEEftewvrRQmNmMhSzcWs1dSfLtKXMKtub7AFiXlME5hYnpxrPCw9nXYk84bW/coDz3j8gRwVY84+3R3k0s1OwdGFwcmj9fNTlHDsWh7vtt6cA+cH+epPCrBCiUWA9Y7FwSAh1iacVVZGuF6hyoOIETlcha96c1UntoYzjLK/0mSzh4Lq8afxlss27oCykuqfVpp0WG2uhkKs1TPb2ByUe9I9viGPcmG9yRooLW3mLJtw/dKUrRa5c9IDsue2MDl8jAOi4OIYGxcH5M4ZTzyH45Q9dKZVWQprgOOny1o+jNdTzlZTYO2ryzF0slMqji3HQ2PI/W/xeUNhQbpvfKFD8sow82ocV7AM8LQiiZClHjR8pJG6jFMNvn8OI4+MaA4CFB1uR6buy7BoSXkrdA8RZT/y5TCMs1nqfAqU+MChquZ96A/pZL5wzGivE3lazqN7ZzOqHgNIr00qK3SRl8JexaPQzps8b1DSYezmKYTj3aB1n8vf4Hbm8DbXnzysCeEV01u/wn3eoWFYI29WZXAl6AxXxxtTU8xmLYeE0ksaTjCr3ZiG7TZJeax24pPaN/58f1rJqthAnWrwTuCv3xVHMqLZMWxsnnBCR9gZXmd6JvoWSEGLwjJrSEaxqmXWJfxnA171UzdpswQV6W6ubVN71j2ALzJdj5Y3bn1/h48OkybcmRpGq7oZjUqdNsQK/DAkHPe7XQDyMIEd+WEquzKaEC/tz+8I8lGHEWHcFuCAbI/1rS6rTgSOV2Kk7trA7Ga2IDtpMjH9jZfvH6Te/sRn7wkVmkelwirTfGIsxXxMjjTKIt1fIfIJAPRY2Hcaw3dk2TC6EQzS3OQzm
 j0o1Jz5Y
 OexS0UyfX2dj57hBRqVcX84bVAX2Nmx4RDs5HCOBaHN7FsvSIAYTNGDLhfg0ijJq7Z+bAWUD8X/w2Pb59/V1K6KuC4kzwV0RPUsl2dFEijOWs6B2cn/fWheG67X374lL+Secm5/1yZZ8LQ0/MrdRDmBzoP4DJff0BP+wJQuZFrhJki+H4A62/kxqz+5hjJ3nOuD32j8hdpEdqibBCcaEfm46WAooczm5aLGK4dfMwrXWVGesndqmhpk/gvpwI4VM+i5wxBRZi3B++OuBuLQkfCNOx6UT3ffTk4SOG22SBMZukLfO9LSG7oxx7UIhw6U8S2Hl2F2SqQFlelBZSl750w7yjR2rc4Q8YE4nirE9pFZWXBWhy8qEKkjfRz0SiTHIzEmJNLA/UoNcX1TYwGNgJ5q+uq1hmJ1Z+8CH5b5A1Ssiek5FerefWob1WFSOY8MHdtbpoV4PkkA6i+VPTa3/8FoU66b+/nZsWBTCzq508RCK2C8+6uInoKuo+DQHUVTZ6ZCigJSuNlTmEKKqWX7F1+2yiAVJT4GVI6nbzj8RYseDsLyMWwPevqjPcRA2dXcwYzL09OfpE7Js3LxaR+0Q1IE+CW9i+4rfD6YarQrJZEaWutCrA+cki3up+WHWru5AuUbVncH1KNMcZ1sTBCZ85JrxCm1om9J+C+AZt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Adjusting `start` without proportionally shrinking `size` shifts t=
he checked memory range out of bounds, causing false positive poison detect=
ion.
--

commit b492314fda14ef47eff8ff738b90a4749a490163
Author: Breno Leitao <leitao@debian.org>

mm/memory-failure: efi: answer whether a range is poisoned

This commit introduces range_contains_poisoned_memory() which allows the
page allocator to query whether a memory block overlaps with regions
recorded as poisoned by an earlier kernel via EFI.

> diff --git a/drivers/firmware/efi/poison.c b/drivers/firmware/efi/poison.c
> index c18edf111c710..e16d43f4438ee 100644
> --- a/drivers/firmware/efi/poison.c
> +++ b/drivers/firmware/efi/poison.c
[ ... ]
> +/* Does the range cover a unit an earlier kernel recorded as bad? */
> +bool range_contains_poisoned_memory(phys_addr_t start, unsigned long siz=
e)
> +{
> +	struct linux_efi_poisoned_memory *pm =3D efi_poisoned_memory();
> +	u64 first, last, nbits;
> +
> +	if (!pm)
> +		return false;
> +
> +	nbits =3D pm->size * BITS_PER_BYTE;
> +
> +	if (start + size <=3D pm->phys_base)
> +		return false;
> +	if (start < pm->phys_base)
> +		start =3D pm->phys_base;
> +
> +	first =3D (start - pm->phys_base) / pm->unit_size;
> +	if (first >=3D nbits)
> +		return false;
> +
> +	last =3D (start + size - 1 - pm->phys_base) / pm->unit_size;

[Severity: High]
When start is clamped to pm->phys_base earlier in this function, size is
not proportionally decreased. Does this result in an end boundary calculati=
on
that exceeds the originally requested range?

If the allocator queries a block that starts before the EFI poisoned memory
table (start < pm->phys_base) but extends into it, the unadjusted size added
to the newly shifted start will push the last bit beyond the intended regio=
n.=20
Could this out-of-bounds query cause false positive poison detections for
healthy memory that resides just after the requested block?

> +	last =3D min(last, nbits - 1);
> +
> +	return find_next_bit(pm->bitmap, last + 1, first) <=3D last;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909-hwpoison-k=
ho-v4-0-359313564495@debian.org?part=3D4

