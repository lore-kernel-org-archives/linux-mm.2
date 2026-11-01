Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E63A606B9CF
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 22:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l4nmcWS6
Received: by kanga.kvack.org (Postfix)
	id 8C2F16B05B4; Sun,  1 Nov 2026 17:16:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874206B05B5; Sun,  1 Nov 2026 17:16:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B17C6B05B6; Sun,  1 Nov 2026 17:16:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3DE006B05B4
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:16:18 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8B8AA1C4468
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:16:17 +0000 (UTC)
X-FDA: 85387959594.23.41E6367
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id DEB6E14000A
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:16:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l4nmcWS6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793571375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k1DWd8TsBWg5NBBxBu42AFkg72eDnbidrtlPTmYRtJY=;
	b=EuAzXRx4Itfyu28mUBcLPlkYqVNPrLMijQSFTzPsJ5kEGaJM71qlbaYFf6DAMiGVzrCVTG
	HmDWar4RSTmYWittwugFQP7DSynoBZ77MugsuTWHPI47fFZTLl9PFnOyM/octrtT0WHP1x
	LlNte9WRVaUWXyqW9204S7UxJaHNtSs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l4nmcWS6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793571375;
	b=3x1tbRTEUALJFVRx4rLtusBNyKa0bHDlyw2AFCJ/rzzWDLhBsafg373aElmdGKllzTVOKE
	ElAb8WRkAriJAx367LK/vkOOZae8DzbDQpqwX45WDDYTLJcmsOFeKwavMmwC+Q6ValP52r
	WxTWn92IIoIa8Lxs6XFICShW4zYb/V4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 68EB0605CE;
	Sun,  1 Nov 2026 22:16:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE641F00A2C;
	Sun,  1 Nov 2026 22:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793571374;
	bh=k1DWd8TsBWg5NBBxBu42AFkg72eDnbidrtlPTmYRtJY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=l4nmcWS6A/4Hr5O71oODbuTRUfO0NkWJ85KjSmxpc4wtkYxkpb1bOMwK0jr4BmFWY
	 lYIEM9ylgDV6SUrYMpJIE2KKFpoD2nnt+UGewiExEhxyhKTMOjm+T52MFPeK8Yd0J+
	 p4q/4axVz0UfZx3L63VYvsm1IdHUsRWd2LlParmpMe2U//B6WU2rzsRD4qt6poBS3X
	 9nvXcpbi8Wvh3JxnKjFOreSdRvTy7KVewOW8UsbJ5RSKNcsm8ZfOb0TAb1yKpjZZPl
	 L41yoUudqhZYHKnzicNfUykC9EKnM+e9w4aN1yX+WbAJDCsXR56xtkURsIUpOdA2Bn
	 Z4trFEgXz6Wyg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 030DB38003B8;
	Sun,  1 Nov 2026 22:16:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 0/6] arch, mm/execmem: resolve confusion about
 set_direct_map_valid_noflush()
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <179357137254.2624073.6914916059318534007.git-patchwork-notify@kernel.org>
Date: Sun, 01 Nov 2026 22:16:12 +0000
References: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
In-Reply-To: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-riscv@lists.infradead.org, akpm@linux-foundation.org,
 abarnas@google.com, aou@eecs.berkeley.edu, agordeev@linux.ibm.com,
 alex@ghiti.fr, luto@kernel.org, bp@alien8.de, brendan.jackman@linux.dev,
 catalin.marinas@arm.com, borntraeger@linux.ibm.com,
 dave.hansen@linux.intel.com, david@kernel.org, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, chenhuacai@kernel.org, mingo@redhat.com, lenb@kernel.org,
 palmer@dabbelt.com, pjw@kernel.org, pavel@kernel.org, peterz@infradead.org,
 hpa@zytor.com, rafael@kernel.org, ryan.roberts@arm.com, svens@linux.ibm.com,
 tglx@kernel.org, urezki@gmail.com, gor@linux.ibm.com, kernel@xen0n.name,
 will@kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org,
 linux-s390@vger.kernel.org, loongarch@lists.linux.dev
X-Rspamd-Queue-Id: DEB6E14000A
X-Stat-Signature: iqkwaz9oufi93asytgeyyi3ixwpjhhor
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793571375-321709
X-HE-Meta: U2FsdGVkX1+c79hHc1D9qqY97AHfnBpveoUsFHct0Jun4v3PiniSMW3cJ5vGxgTP+3nWrZIzUz8DzGdXSkbeoydfMHOtbQ3bMMPCPehiv8+P1N7ZyGgj+6jsmsGw3HhfUeiVj4AidBQ3f3eEXhVve6vq5uJb6BL7D5eqvEhAUjHiT5RCtqY+C6JiCznR9M1x/qSag8BdElJ7te6FU8X14VK4nA8blSibmVFMAc34HOA2vJyp4MbJ0EBtwcYAkRxrOyJzh9q7D+QvpSeGcRI13dS+Qo0O3amPR3dwYqiLRuLU6jLtwWkSSGuYCagZ2jHp/ct8lnN3y+ceMqCC9QlEBEWHOFPFlPOHW2xd7FTiw36J8XJGS+kWDDh+0SCPbyULeRHHfgDwdFFdEAdwv4gthKs5XbLY57nkKBjaKXMQrhiEpNdgm2Yuqo9nkSdGxl83njYoiODB7LqDX18ZJm6IhXsPwgtVbh7rsgtsESQdPf51LJx5rwMeL74IvDkyJX+k4Uc2JoffYj9WX8fHww6WvQt8lPRgs7DegsXQsbaqESyYRIpLsXvC1utur9R0CzrNEOrpe49/vdBkVMV+T+mEbcptGxcdnAejq9PCGDxDqs/Ci++R/M1SKAE0FMFism62+0RRs7O+hjuWep8Jik3If7zgeHYr6G3dpWVnbN3ZTk7hdrmCO6p+rGPPRbdkAEuw0Z2QWvF2o0fKNBPO5wjJpRSFR/YES+Yib7lL3jeKj6wec4GrzcBfjrmf24EWfdPl9s37gBeWv9OV6ps0CSI+s2htT5XgeEk4zSEwvJV7J0jbmhhQXbKUFb4M7Lh9yJwTXVhNOCMjFlwbIz37pRqrID9NuYAplCBFqAkCqqq+PuNAzE/USoFZ90rTn7z0n7O0pWisC999tASfB9uTaHY/10Miai+5acj+pHxQl6VrFYDgIXFcq/cd8v2pF0LD54pyjzJ84SSn/otfuKSyZne
 NCizJ97c
 UxtzfYFlWaHSObl/xWePB51/jtqeOBrJFpERuDDf6boIwMyhFH4n9iBG5s8dlLDbo7IEtktCSF5MycndziEiY8dZ2vxamAGsVMW9n6Y807c8qnLhZFuV/M8XGcSXcsq8/31DYKQOmoUkVUW3tWmerY+OAXIQVG6Mngu6PvnLYhKBB4GQB2IkF+kahqvXIHWfO6KSn+nkk2g9DNB1GQv2xnbQHXOmGfU+gK9e88WLIA4E4BPJhKHDHa+P5ZVa0UW0xRA5B2HbxnaIA/urgiNAVvLyCazT/1gyOcg0RbPk/s2DO6zwbG4aZze8hOOOGpMccvu3h22IBaevs2lG21xn5S7Bi9+FPLNTy/yiR2WaDYyRqoeWkKwvVh/ACw4LsJGZkdUTM9jEuUGSwtc2lUj6Un0KkJsebEdAGP5E34jlif634n5SYbon88M759nGb8qae70jkJBIDtzwPzK13ZHQOTvhm1PyvqJpNs2NSaFpp8IhomkTtjLZWaTWdo3UxWzaNQJPV+tSJ55hy5+4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello:

This series was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Thu, 03 Sep 2026 12:28:26 +0300 you wrote:
> Recent discussion about implementation of execmem's ROX caches on arm64
> revealed a confusion about how set_direct_map_valid_noflush()
> implemented on different architectures.
> 
> On arm64 it sets or clears the PTE_VALID bit marking a PTE as present or
> not present.
> 
> [...]

Here is the summary with links:
  - [v3,1/6] set_memory: add number of pages parameter to set_direct_map APIs
    https://git.kernel.org/riscv/c/be7dacb9c1d4
  - [v3,2/6] mm/vmalloc: set area's page_order after allocation succeeds
    https://git.kernel.org/riscv/c/40702f168a9e
  - [v3,3/6] mm/vmalloc: constify vm parameter of get_vm_area_page_order()
    https://git.kernel.org/riscv/c/1f73dfdeb9c2
  - [v3,4/6] mm/vmalloc: make set_area_direct_map HUGE_VMAP friendly
    https://git.kernel.org/riscv/c/86dc0280b807
  - [v3,5/6] mm/execmem: use VM_FLUSH_RESET_PERMS for ROX cache allocations
    https://git.kernel.org/riscv/c/4c4b2ed5b783
  - [v3,6/6] Revert "arch: introduce set_direct_map_valid_noflush()"
    https://git.kernel.org/riscv/c/0e774fdb2ed6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



