Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8A47FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 03:26:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6BB26B00A1; Wed, 29 Apr 2026 23:26:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF5036B00A2; Wed, 29 Apr 2026 23:26:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E3E56B00A3; Wed, 29 Apr 2026 23:26:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8373F6B00A1
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:26:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 27A8040384
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:30 +0000 (UTC)
X-FDA: 84713784540.12.D18F4D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 636E340003
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZJ6OmXOM;
	spf=pass (imf27.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777519588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z1Bc9EV5y+bhYycUp6wLBzpUNqNF28WMRZLrHkhnHUE=;
	b=ze4BQhNo/e+DHYQHUxe+Vaf/k0loX2x0pYOVTErukRVCNqoWR0JXiD/RKIBj/36X4BwpNm
	liBniQJWe1j56VoAISpA7+bMvRUqVNmH+/klLjJb4cDPK+n8iVCfuaheq6eDPhdbyFgzvy
	fK1vnRuYa0ZXdeDZ5kjtsed7umWbOvE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZJ6OmXOM;
	spf=pass (imf27.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777519588; a=rsa-sha256;
	cv=none;
	b=0XWYMksP2zCdx6OHKIDd6+KH7xWQZbSISczmtBvlgVPL7Fh3xwQX/HxWr51FenOO35ti9Y
	6Ngw/XyM51F36L/uL4qUQ5cKdVDrrOqwQixTh7EccXJkxhsnCOYI8GAy2B3c/NDPxfLN8n
	L0+eqZ/6kxt6T8aSQ1lmawmE0RqDikU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8CAA9444D1;
	Thu, 30 Apr 2026 03:26:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68048C2BCB9;
	Thu, 30 Apr 2026 03:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777519587;
	bh=013+JQB3BOWcgJhPqdubZ1XsxYbnthONCnm8Hl39HsQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ZJ6OmXOMpE+dTJPzp+xtAqL+VAk4ePieug406a8qk2/dHpymUK1JjCTkKOHPysOIj
	 INPaAGoTWRR3yYCB5hELjnfdvAfGK4/sGDb+7eKy4KcyPn66lNIN1AaypMkVLUWRno
	 7mvTCzzvR+eFzmFD0As9ZNiX2e/asCEu9Bt/Ir1neq8SH3sHmTB1VpBR5W91Ed2cp8
	 vwrXvOOhet4pbTRNVpG8lw5+rnuaKpNo6/Hy8IdkRQBmQg6ZuAtLQfTaHppkkwkHi8
	 +xwHkUQkz6fLJPc01QgnX70Wy4T0kzoqFakSpqhh5J9lYDGXyJBUznVtbJbQXiu6wY
	 hb5+2ZtbiY3QA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B9F543809A07;
	Thu, 30 Apr 2026 03:25:43 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv7 06/18] LoongArch/mm: Align vmemmap to maximal folio size
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177751954230.2274119.12654930976338727655.git-patchwork-notify@kernel.org>
Date: Thu, 30 Apr 2026 03:25:42 +0000
References: <20260227193030.272078-6-kas@kernel.org>
In-Reply-To: <20260227193030.272078-6-kas@kernel.org>
To: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: linux-riscv@lists.infradead.org, akpm@linux-foundation.org,
 muchun.song@linux.dev, david@redhat.com, willy@infradead.org,
 usamaarif642@gmail.com, fvdl@google.com, osalvador@suse.de, rppt@kernel.org,
 vbabka@suse.cz, lorenzo.stoakes@oracle.com, ziy@nvidia.com, bhe@redhat.com,
 mhocko@suse.com, hannes@cmpxchg.org, corbet@lwn.net, chenhuacai@kernel.org,
 kernel@xen0n.name, palmer@dabbelt.com, paul.walmsley@sifive.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, kernel-team@meta.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev
X-Stat-Signature: t3zyowcmwq9pi6rj6hu18sw4qbn9jf1r
X-Rspamd-Queue-Id: 636E340003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777519588-314007
X-HE-Meta: U2FsdGVkX19VoAOxLvEALVX8o2rKbD1G8XdJkYap6LzOTrgWQFyJV61ZzwhnsVHAWgdNOaC0ijWCTBTZQWXD3A/delg/zZGfDMWS9DG6I00HOsJuHzyblfrH5Zrb/JBSd6cW8LG2I+oCf9w0AvWDbL7suJqENYrrrm2zjjHF2XHniq0Jk/4mfTh0S196zK5R6TAGDWqQ11nNsBFJn1OcW1J4X6XUb0G7a9wSmPIpUk+zV3VK4kOg6hoWW+h25sJNuJ1Ubj5HaPxqdIc6O/CFsG+oL3Sc6MX1P6T/EWgE+9hki0ynLtD5G4q5QDPEcCqFEJbMgBE36CPDQEYdvz5IZfjCdut9M65lwDUJC1VtapK2/jghi7AN1STP3q+c9HIeBZmgMqoKkxETD9RKAbH0fL0jM2KnMaWSqZZ/U6n/0GjKZXEjK8w4nhdC3T5yg6IB73wcOJ/XFKRXXb02Ty+xUm+yvdzNgTi8C/jNC05+oi0Fs3chSU2vOFSfuVeZ167iYVlHA50xcWK1BROHySSHK2yh0JgxaKuSGFWkEPiisvjVgeaoHoOl87IgSEmzm12978p6d8otahsXOVmm8JdAjfA8EDZcbkDFhqfXnZSWED7o9YRxShU068mz85UpxpUgorm6MVXB51z8FddKdRlb3sTV+YdKhdOVPJgkMCQMVgihFePPxhcYuhBRVl6wyYkcdyknh2xag2NRFWECyx2MsJaicZnt5vIAV2BlIplnWm7hxO+8gDk3j+gqmtqmZJdgM3OTCDmsAGIyYncBiyZN/bEHFXCyjb4yIiORbEyV/M+fwrExXltA917Ome+t4VHOD7y/ML26mLjZBnvIZ8uuYX76m/pAUy9J9HqDZIKDXJS+CSmUkY+oyH+sNe2hLfGrRUvMDIDoUUnUR9EbhLttvlYmYtUTuRD41mmYpQ6oihFIaOrFXOBxQiMEXwrM+/W13uYbP1SKW4PfMxfjL2a
 CthhSNp5
 +7Scy5urCBnoJ5i2furjgaesZdo0pG83Z2YdCYBHIaDxVkVfHiwGjEFiZSy4awj58HJY37bwkm+lgeSwTK7fSeHK59Gd+fqRvhuELpeHe9PVI3cLYJem+d64cpx6RoDqXKlkGW7QHE0Pt3DBgDodrR5OVe9dadKqb5EnuvV9wrMJ4MS2qNW6mLjzP3fr1kAFoESU97T+Z5s+KCljNFUTv/ry00Yk4vI/X1tb7MDJXjfZy3FM5iqRpj4PysbLp4OXBwa4c8egKUUpe7lPAe8ky+0Tvp4j1SQjdj9rzT0qH05WKEVRv7CrUCAx3HoDHNBscjvOz0bR5W6eSgOQb/fnThHMc/AJwy89j4hB4DBPuCPmOGdb8iNeGEv36TDAFcda/ZiYHFp9Hx0g4HtpTO6aLiVo8G6hymcvmvd0ujBMTOZlVyTzKcz/OCe9sog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Fri, 27 Feb 2026 19:30:07 +0000 you wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> The upcoming change to the HugeTLB vmemmap optimization (HVO) requires
> struct pages of the head page to be naturally aligned with regard to the
> folio size.
> 
> Align vmemmap to MAX_FOLIO_VMEMMAP_ALIGN.
> 
> [...]

Here is the summary with links:
  - [PATCHv7,06/18] LoongArch/mm: Align vmemmap to maximal folio size
    https://git.kernel.org/riscv/c/2969b42c8f99

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



