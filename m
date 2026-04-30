Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E26CFF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 03:25:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8DB26B008A; Wed, 29 Apr 2026 23:25:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D655B6B008C; Wed, 29 Apr 2026 23:25:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7B9F6B0092; Wed, 29 Apr 2026 23:25:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B6CCB6B008A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:25:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4BCC6C1B4A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:25:57 +0000 (UTC)
X-FDA: 84713783154.04.7063F3C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 858A4160009
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:25:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S3K5G1Xo;
	spf=pass (imf08.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777519555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9h+2+l6YOgSv4xQuuSp6Pxc+vCf1Cm2WPNMAxO5dvrY=;
	b=FhEB61qG0eG963IDOVqPLJghPrKDsyRExfZ4FpKdLu87F9OBgmsgcOEuaVjKTFuF9hQ5AF
	LBDqd+DZ71Bav5lPln78OxHUBqGj6RsAWDH9kLkgp3SlwPTp+Hlxr+WyoMbNoc3bDW8sVR
	Lf0MoLfLWfoHp7xT3gXgzjMR2Bme79g=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S3K5G1Xo;
	spf=pass (imf08.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777519555; a=rsa-sha256;
	cv=none;
	b=6xJiimNaXcUY54qt4AamuQbPXWxtPsbTV4Ax/kjAkGeIEdNj20of5h6PPIMjzbrm3sjGXK
	P11juitWBjRdVl4GFXFgK9uNQz1r/kl7SDxfUMpTva8W0NyCl4VjJLLbSWigEPOeKZqMmd
	fgpAzgdHs4ce9KtlmIH+0r9/NRgYhkE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D8204457C;
	Thu, 30 Apr 2026 03:25:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F0EC2BCB8;
	Thu, 30 Apr 2026 03:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777519554;
	bh=7DUN2QuqQEe+BONI1ESG4SkIz1fzsjbqa3ckTuuKON0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=S3K5G1XovhD07R5O5Cfcy7lVvTxvdUAegkMVL4L8Mtzf9fKcNC7CadGfDm94ncYW3
	 /b3gcg0/YcLg9Als2F8ssWaUxHQUhQMOrsInNGp23YyNVEoZesnW9na1KfzAJGwADp
	 KTU1UQLuwoaLC0FxYgCBT9ErRd1+nqtKD6J1vJmiEmkbMPNMtG+lgotURJHsePS61S
	 RLCqfSNYiEnZojyCuQbicPLDo3ywac2PmflqikQdR6Ir9LNvsPRYjNWI6Ol8jDiw5K
	 s6K1opc7+K/SSJ8ToRvLUcMAZC9t1wDEJ2EBfwZ5oF2rytHLJHY/YtizCxlNq2AgJI
	 UMoMxqu7YBolw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BA0123809A07;
	Thu, 30 Apr 2026 03:25:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 0/4] arch, mm: consolidate empty_zero_page
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177751950929.2274119.3965174046465654804.git-patchwork-notify@kernel.org>
Date: Thu, 30 Apr 2026 03:25:09 +0000
References: <20260211103141.3215197-1-rppt@kernel.org>
In-Reply-To: <20260211103141.3215197-1-rppt@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-riscv@lists.infradead.org, akpm@linux-foundation.org,
 andreas@gaisler.com, bp@alien8.de, bcain@kernel.org, catalin.marinas@arm.com,
 chleroy@kernel.org, davem@davemloft.net, dave.hansen@linux.intel.com,
 david@kernel.org, dinguyen@kernel.org, geert@linux-m68k.org,
 guoren@kernel.org, deller@gmx.de, chenhuacai@kernel.org, mingo@redhat.com,
 johannes@sipsolutions.net, glaubitz@physik.fu-berlin.de,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, maddy@linux.ibm.com,
 linmag7@gmail.com, mattst88@gmail.com, jcmvbkbc@gmail.com,
 mpe@ellerman.id.au, mhocko@suse.com, monstr@monstr.eu, palmer@dabbelt.com,
 richard@nod.at, linux@armlinux.org.uk, shorne@gmail.com, surenb@google.com,
 tglx@kernel.org, vgupta@kernel.org, vbabka@suse.cz, will@kernel.org,
 linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
 loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org,
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-um@lists.infradead.org, linux-mm@kvack.org,
 x86@kernel.org
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 858A4160009
X-Stat-Signature: sshtda7wbks76ip7w1ny856y4td3chs5
X-HE-Tag: 1777519555-711500
X-HE-Meta: U2FsdGVkX181ORYaBOur1k+vvrA1SgWYQDKb+wfVIPMplsuTj6nVqJgo3TdUWIWcWC8Qib9BD9SyUjNzlrYsfWH1qAB0H3+fqKMU6I2NMeNZIGFN8X3TJUe9XnqyJ9zihkpreVIcZdVihiMPGtZTGJclcmt0se9B180XosZ12pCzxZsjuV8oG66EfumiUB+rtQz5N6CGwM0G6uR6+piFRH3tJYiUR00TN6bih3pNSAr3UInYaO0LGffBZ8R2a1gYYtO8daN6klqiv0gCyzySr/lCWERQmq+0DQEHBF7sRUgl5RppFgcLMSdgBH8z12V5UNAJ585c+wyhESNuar5r0JTf+tAk4RWKI38ktiGC+xJfhA5bDcvTiD+AUAPEXnxInLtQsoLMVh1wuiV6pfrKxSnIlNbXkzVuHSxoWDuTaBVTkI0iedwRuRadIEq0l7AOC2TAmBz7ape+qp6Dusgi8wkQRM6TLsYAajIgF4g6PM2qguaf+k5LT4kfEWPlRz2q8phF9nIfkhbG4Z2Twef0ykqJrTz5LZhx4VLqh8TDimSfUJJWtK6bqHtE5OJ8gF5b9YxXgGjSHkswIQpnxeCYytsQTcTXV/3mJNDSvbnh39ZxAmFsW0cIoBcSmywPhRB5dnL6ukgdltQ0jDPYiN72e1DSabBMZotVab+wvhGoJzHC+ZwGAV2XrrWQuGjc2TGj/jzCbppVC9SK7ov21KpBWDIVo5Kg6zC040eUvhx4pxYC5x0Vwf0vMF4xwvawGnBjI33UJid7uZMxQ+ZTSDZHGiYDuQDMOAT/Lvvo0shxX19U30Nu83xVowJyLw/+ObiujEgQFS77zoI8ezXhp1U87SxklTEwdvges2wA6G5MygoNXjdRD9CDRAKatXKPuxuQCO2EkTn0Jpd5Vs45w4P5LpZrWF3nwr3zFTkyvvMAuOAxVwqyr1DE+qdwz2AgblEi26PqFenfGjpfZdTNys6
 60yU/Bnw
 2HuGwcHEI7oeoeyuSZRkutIUFdip5yENedc3vdOr8UpR+6j6sHD+uoSlb0jmHUeuMZhOQBrDkh3tE6CUhMp7rpwamBrDTnd3Mk1sCDcv0HYJlLvVwyurOJW9M77TGn4JM2/Nm4rrwxKYAoGA2rvDURRbjPBsNj7uMASfvq8HXfDAHj496KO6kJ+wfwjTSA7IWaZ2xjS8OOR5dVElgEoPvAI6hVch3Kir4F9bXsAG7LeF7PKrBzSxg4lxlGc1CrHP78nQSGImf3btn3X1jarzUACrEx8MVZH+KKyjEqboonE5kzbzpvXGufw6KuFG7B/8krdMwbEQpxR1eP0hBsELkRLUmmgUdNPfVz4zQtLL63pfUqjmd1tVs9k9nmZl4XtM+6ijLYN7mIPM+KzShEo56BVMIui5jZEVzaldhdP7V1gejaf7CgnwwlNzffHIRbxgONjL4/7h4x8SrYOXH/llHXVvAQqbL4PO00XDP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This series was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Wed, 11 Feb 2026 12:31:37 +0200 you wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Hi,
> 
> These patches cleanup handling of ZERO_PAGE() and zero_pfn.
> 
> v3 changes:
> * move zero_page_pfn extern declaration back inside the helpers
> * add tags, thanks all!
> 
> [...]

Here is the summary with links:
  - [v3,1/4] mm: don't special case !MMU for is_zero_pfn() and my_zero_pfn()
    https://git.kernel.org/riscv/c/652d12bc74a0
  - [v3,2/4] mm: rename my_zero_pfn() to zero_pfn()
    https://git.kernel.org/riscv/c/9a1d0c738b45
  - [v3,3/4] arch, mm: consolidate empty_zero_page
    https://git.kernel.org/riscv/c/6215d9f4470f
  - [v3,4/4] mm: cache struct page for empty_zero_page and return it from ZERO_PAGE()
    https://git.kernel.org/riscv/c/26513781d1b3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



