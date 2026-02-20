Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39CDEC53213
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 04:10:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D6776B008A; Thu, 19 Feb 2026 23:10:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 000C16B008C; Thu, 19 Feb 2026 23:10:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1A906B0092; Thu, 19 Feb 2026 23:10:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CA6A96B008A
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:10:36 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 827C31B61F8
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:10:36 +0000 (UTC)
X-FDA: 84463508472.20.7C94191
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id D7E50120006
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:10:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BY31bXLu;
	spf=pass (imf29.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771560634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UmtwuF9rplNR1YcI1IPERFnu/d2QeRotv3msVVu+S8Y=;
	b=lzthmBjmuylZ8NjZBDDOG3dkwiELBeV9MVGz+Dr8SgCv/S2hA8Bkdy/WjD0YP3SnFCHjJz
	1fG5oVHhhDvdxUddn6sqgl3S6G/EUhlxeqGamEN6nErwmydb83U9tBo1bNMJlxp98e7Aog
	VAG8mL5B6cS3t/7zTNQ1fO8139RoTxI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BY31bXLu;
	spf=pass (imf29.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771560634; a=rsa-sha256;
	cv=none;
	b=F1S8QRTr5HmgnC9VgqM9PMZUd7Pu5b9az5HFZSAxMNmrZ5+5nhM+3L4NsUhGRLtMP3iKb4
	XVDLf6PNRtPSWjaZFY4IGgH82iQ7cnU1AKMKZWpo8UapcxA7ScSklISc9cf+owkswq3N4c
	/EoBbI6hVeb9tBaVV50+axOXfceiG8Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4DD1061853;
	Fri, 20 Feb 2026 04:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E068FC116D0;
	Fri, 20 Feb 2026 04:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771560633;
	bh=im5T2AhfGDyXaPXyhpLfgJGQ91DbQgM5VZmwKBunt1A=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=BY31bXLuYwaDNUvbU0KhmqMJP3M/Awj2XilOUUrqfd5tse5Bs+Sof47ei7f2ySnfn
	 tFNi7q7K9gluSvI0HlMVWVeaLxpkyoeKBDi/rrNOewr0OuAFpDC7j/iRqwMKPlJ5Wa
	 P3ScJYlX18vFMmmARgpPLIChzrvUE2kp6Q3jnE9jYkAe7srv3PTOOcxMtCzqbU7qAw
	 IToOjDmvHez/A8mTg3Q3sBsLUBSNAWxLa0iZsksGoJ/G/rax+WVfDfh7lH4OceXS15
	 qVM1jLAxgENfoZP8fJU+Wp+4V3bOt53kAg6T75fF/G3mbGiObvL/fXyvhcTJ2XNYm0
	 uwW0QrKe9zoGw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7CFE83809A88;
	Fri, 20 Feb 2026 04:10:43 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 00/29] arch, mm: consolidate hugetlb early reservation
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177156064229.189817.6698956997773300471.git-patchwork-notify@kernel.org>
Date: Fri, 20 Feb 2026 04:10:42 +0000
References: <20260111082105.290734-1-rppt@kernel.org>
In-Reply-To: <20260111082105.290734-1-rppt@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-riscv@lists.infradead.org, akpm@linux-foundation.org,
 alexs@kernel.org, agordeev@linux.ibm.com, andreas@gaisler.com, bp@alien8.de,
 bcain@kernel.org, chleroy@kernel.org, catalin.marinas@arm.com,
 davem@davemloft.net, dave.hansen@linux.intel.com, david@kernel.org,
 dinguyen@kernel.org, geert@linux-m68k.org, guoren@kernel.org,
 hca@linux.ibm.com, deller@gmx.de, chenhuacai@kernel.org, mingo@redhat.com,
 johannes@sipsolutions.net, glaubitz@physik.fu-berlin.de, corbet@lwn.net,
 klarasmodin@gmail.com, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 linmag7@gmail.com, mattst88@gmail.com, jcmvbkbc@gmail.com,
 mpe@ellerman.id.au, mhocko@suse.com, monstr@monstr.eu, muchun.song@linux.dev,
 osalvador@suse.de, palmer@dabbelt.com, pratyush@kernel.org, richard@nod.at,
 ritesh.list@gmail.com, linux@armlinux.org.uk, shorne@gmail.com,
 surenb@google.com, tsbogend@alpha.franken.de, tglx@linutronix.de,
 gor@linux.ibm.com, vgupta@kernel.org, vbabka@suse.cz, will@kernel.org,
 x86@kernel.org, linux-alpha@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
 linux-mm@kvack.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org, linux-snps-arc@lists.infradead.org,
 linux-um@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 loongarch@lists.linux.dev, sparclinux@vger.kernel.org
X-Rspam-User: 
X-Rspamd-Queue-Id: D7E50120006
X-Rspamd-Server: rspam02
X-Stat-Signature: d39ja4oqfyacp7iiwbn1tkzg9nc3417f
X-HE-Tag: 1771560634-448116
X-HE-Meta: U2FsdGVkX1/Vyhaly2+rt3kd6XBWgTc+f3foGe4vwk0YL7s0FdFZIo5qQdGCK9tNrsSg9T9ILrDZVjqaMacdW7TetQ0TOJq/Xd4tKPoo2w4R281yOEQa6/iXVqvS0aGYEf0HJJphvsMNIBRaPEstPnHgmMe+RFFxpcuIJmeR2f5hqwTF4whA9wJUNaJt/Y/8I5Z5r+Vv+MZzC/XHUzxwDPkpGv0DYUE9SUCn4+1sD9ycMF2Qq86an7i//A24xSy8hlWn6fCc1uS/FDOvsXoLvdcWpnfnz/4DwOVCtHKHS/CCP8cMzYDRK7Y59cAeWkWH8biXRAVMBbJ7qdiSyaLFlTdYyuqX4cXmTjKpqCF3ojIJ6nQzkJiA1EeEGj+t2SbQSCEuTerE5K8b6bn4m24Wb48JeSSE7r5UYNAX1hxH4xW0B5n/Vr5wZd8mGJw9HVCEC7bUzlavr/biZdSE5JeKqNftrsRT+HaxvX/qbkLxS/L9Yo/NUFEstRPD33/WAfbDB0QECStkr0R3Nc5eFUrB/NfqBsD7cvdTshBd65u5hht5Wmw6vDO2V3ypOzPKjprYyciUoLlgeSie7z1AHTMxyrFXCMNv7Y1bKukbnzue2ic4sfgl4KTLExeeGa4ZrHVyxcTBVhth/nn2r0ugEBZpVVvxMPKzqz/7frMXRo4kECT17HaMWHKyAsZ9nCRRq7dski2s1+1NZPGwSJitFrD/Ah0q+5UnGXwujp+/KS4wkqmlSyisXbiUZExt6CsPKYWHeZ0om4x3Ig+m6LQ+e2YzWltBJaTX6M3PFEQNgBUDZQOkrVTPxYVjDy+Xfh1M53TGNmWyy6WuyhI3e3b3sKPrg84Ggx05v6ho67RVYlaMVyRYUvhdmQbQ0zl5bRBzOMmgVMWRa7MTO3hwGdDhSKUoQNhK2Jj+AKqJANymwLLmF83iRLDMXr86Nm4Nuz1Vv2LlRXJ43cQj981oPN2RocV
 6VyULKaO
 JkT9QtXIuSSrwxiD1M+/5OnB3Nq6uZbyoMDeU53j0g77e9ZIRdwQCm/C8hLxcpSDOyiRChJjC+YLzrdBIfCjFpZgH+WaHvg6En9/9+mccDQeYcB5IPEghPyuM4+8B9ztj1Dd/oLqPCBnWs32sDjtGjrEqdH8rlq+/7PqcHlwFJfetkFlnMqoab18zPSLXlABQjpQBcKGg9CVQYF5wBHPJFUWe//Z5AuiZqyiWEGTMQkPjTljNfomlC9F6lI7Ek1SXI/bSTNbeC5k5K2hfVhySrK4X6hu9Rckvkbx2KcHlXoYp35kBAfLcCY0T+GxH/ZqBUcB84DKEO/x8gj5al5h/mZpNv4Ouv3wbGwnqGQmnUpWb6SBkb1hN5T0G4gFcxuhhcfJcyKDZIkD6eS37xgrHEXhvObsUSL5lnRC10jibH25XFFoXkL+gn3fVR4ePcjnATyq1TmAAbYII4zRgs4uEeYvndcWlv4nszRZCK5U8q0L9GOpzAt3a4BPCgw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This series was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Sun, 11 Jan 2026 10:20:34 +0200 you wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Hi,
> 
> Order in which early memory reservation for hugetlb happens depends on
> architecture, on configuration options and on command line parameters.
> 
> [...]

Here is the summary with links:
  - [v3,01/29] alpha: introduce arch_zone_limits_init()
    https://git.kernel.org/riscv/c/ba1c86874e25
  - [v3,02/29] arc: introduce arch_zone_limits_init()
    https://git.kernel.org/riscv/c/7988e8518904
  - [v3,03/29] arm: introduce arch_zone_limits_init()
    https://git.kernel.org/riscv/c/30a66f8a8cd3
  - [v3,04/29] arm: make initialization of zero page independent of the memory map
    https://git.kernel.org/riscv/c/18b7cc70dea8
  - [v3,05/29] arm64: introduce arch_zone_limits_init()
    https://git.kernel.org/riscv/c/60b35af0a6aa
  - [v3,06/29] csky: introduce arch_zone_limits_init()
    https://git.kernel.org/riscv/c/37318eb97f23
  - [v3,07/29] hexagon: introduce arch_zone_limits_init()
    https://git.kernel.org/riscv/c/934afdf7f4cc
  - [v3,08/29] loongarch: introduce arch_zone_limits_init()
    https://git.kernel.org/riscv/c/63cadcb731c9
  - [v3,09/29] m68k: introduce arch_zone_limits_init()
    https://git.kernel.org/riscv/c/41b08a7abf89
  - [v3,10/29] microblaze: introduce arch_zone_limits_init()
    https://git.kernel.org/riscv/c/2ce38c9ae840
  - [v3,11/29] mips: introduce arch_zone_limits_init()
    https://git.kernel.org/riscv/c/f61385e29444
  - [v3,12/29] nios2: introduce arch_zone_limits_init()
    https://git.kernel.org/riscv/c/3b1b0e5797bd
  - [v3,13/29] openrisc: introduce arch_zone_limits_init()
    https://git.kernel.org/riscv/c/1d28b1142383
  - [v3,14/29] parisc: introduce arch_zone_limits_init()
    https://git.kernel.org/riscv/c/950696afe400
  - [v3,15/29] powerpc: introduce arch_zone_limits_init()
    https://git.kernel.org/riscv/c/27bebe446f8d
  - [v3,16/29] riscv: introduce arch_zone_limits_init()
    https://git.kernel.org/riscv/c/db8cdb0ad603
  - [v3,17/29] s390: introduce arch_zone_limits_init()
    https://git.kernel.org/riscv/c/76c4c463bbc0
  - [v3,18/29] sh: introduce arch_zone_limits_init()
    https://git.kernel.org/riscv/c/8bfa6c2259f4
  - [v3,19/29] sparc: introduce arch_zone_limits_init()
    https://git.kernel.org/riscv/c/6ad7ea22cf6f
  - [v3,20/29] um: introduce arch_zone_limits_init()
    https://git.kernel.org/riscv/c/531de7f02d51
  - [v3,21/29] x86: introduce arch_zone_limits_init()
    https://git.kernel.org/riscv/c/34f6b9c6e417
  - [v3,22/29] xtensa: introduce arch_zone_limits_init()
    https://git.kernel.org/riscv/c/2d3c8c5f33e0
  - [v3,23/29] arch, mm: consolidate initialization of nodes, zones and memory map
    https://git.kernel.org/riscv/c/d49004c5f0c1
  - [v3,24/29] arch, mm: consolidate initialization of SPARSE memory model
    https://git.kernel.org/riscv/c/4267739cabb8
  - [v3,25/29] mips: drop paging_init()
    https://git.kernel.org/riscv/c/5dea39496c68
  - [v3,26/29] x86: don't reserve hugetlb memory in setup_arch()
    https://git.kernel.org/riscv/c/6632314fddc4
  - [v3,27/29] mm, arch: consolidate hugetlb CMA reservation
    https://git.kernel.org/riscv/c/9fac145b6d3f
  - [v3,28/29] mm/hugetlb: drop hugetlb_cma_check()
    https://git.kernel.org/riscv/c/7a9c0bf0aec6
  - [v3,29/29] Revert "mm/hugetlb: deal with multiple calls to hugetlb_bootmem_alloc"
    https://git.kernel.org/riscv/c/743758ccf8be

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



