Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9049D3B985
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 17:21:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D0636B0007; Tue,  9 Dec 2025 12:21:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A87D6B0008; Tue,  9 Dec 2025 12:21:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E5B46B000A; Tue,  9 Dec 2025 12:21:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2D7906B0007
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 12:21:55 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C065E12C5C
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 17:21:54 +0000 (UTC)
X-FDA: 84200600148.20.38DB021
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id E71BE1C0022
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 17:21:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Psg4CKLA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of patchwork-bot+f2fs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+f2fs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765300913; a=rsa-sha256;
	cv=none;
	b=oeMILwxhBhDVUYQ82RQl7JJpdS/grjbVGpiECTNO41jcTpLuzxB5mqsGnIL1i8hp4hDu9U
	YfHu/eL1BefcPAfJ+EAljXNsk2N4IR+4FZh8utgMYV8h4HQ8XxIt4VNvTmvhhi2DdlTQVA
	8fRSDM5lHslQftq0gJhxZcRcllQLbJY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Psg4CKLA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of patchwork-bot+f2fs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+f2fs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765300913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2OfZnJKQD65zAnOpqdjAiOAqDFP91IDQbUjGaeDV9mA=;
	b=DlvGl6wv3XaypawTbZXNF83VDApBZBd3vqs6HnofPovprjAK9K6yfWog2PHwXJ1t8VkXo7
	oIbOesqum3MzHJN7YLcrS0yivRziCltm/Q2L3lpHRdW1aQS1//waAjpxp/1B+YGd78GXfb
	Gd1PvZjEgoQJxHeGD0W2FG+yfDoYlFs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CE7F43D14;
	Tue,  9 Dec 2025 17:21:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713EEC4CEF5;
	Tue,  9 Dec 2025 17:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765300911;
	bh=6JzHwVMsw3oVBaLB929QEwdcMxFilfqVMX3zcgp6eKA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Psg4CKLAi9h/A9vrvljHnRqp9p5yz8B5YCapKgSBCEr6kmloaOVwmNaYxp96nI0Jm
	 E1pbyJ1ln1w7L+cwykG7ZYqv4qRzAcWJFrrDoVllnAKtP9kV9HNNc0yvVFDPPFwIkZ
	 zlIrgsKzfz9N31t7zC7ENkzXvNMPaNLtaoUlwGSCq0lbSmlyoP3LMxcO1rKyc+86dE
	 NNhWUd3A/NHLJln9jL7sW0vI/gKw88UtIG56vYvOYlGCOJt2PmPeBPQ+WVB8pAbtZB
	 YUlzouJwNa/r7jfn9C9CtIGicL5PvCAPTPMpQEpILvgU65s/m796Uhb97EubDbNHcQ
	 BLbAhrtl11WCQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B591F3808200;
	Tue,  9 Dec 2025 17:18:47 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [f2fs-dev] [PATCH kvm-next V11 0/7] Add NUMA mempolicy support
 for
 KVM guest-memfd
From: patchwork-bot+f2fs@kernel.org
Message-Id: 
 <176530072652.4018985.15391772848132749035.git-patchwork-notify@kernel.org>
Date: Tue, 09 Dec 2025 17:18:46 +0000
References: <20250827175247.83322-2-shivankg@amd.com>
In-Reply-To: <20250827175247.83322-2-shivankg@amd.com>
To: Garg@aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org,
	Shivank <shivankg@amd.com>
Cc: willy@infradead.org, akpm@linux-foundation.org, david@redhat.com,
 pbonzini@redhat.com, shuah@kernel.org, seanjc@google.com, vbabka@suse.cz,
 jgowans@amazon.com, mhocko@suse.com, jack@suse.cz, kvm@vger.kernel.org,
 dhavale@google.com, linux-btrfs@vger.kernel.org, aik@amd.com,
 papaluri@amd.com, kalyazin@amazon.com, peterx@redhat.com, linux-mm@kvack.org,
 clm@fb.com, ddutile@redhat.com, linux-kselftest@vger.kernel.org,
 shdhiman@amd.com, gshan@redhat.com, ying.huang@linux.alibaba.com,
 ira.weiny@intel.com, roypat@amazon.co.uk, matthew.brost@intel.com,
 linux-coco@lists.linux.dev, zbestahu@gmail.com, lorenzo.stoakes@oracle.com,
 linux-bcachefs@vger.kernel.org, apopple@nvidia.com, jmorris@namei.org,
 hch@infradead.org, chao.gao@intel.com, cgzones@googlemail.com,
 ziy@nvidia.com, rientjes@google.com, yuzhao@google.com, xiang@kernel.org,
 nikunj@amd.com, gourry@gourry.net, serge@hallyn.com, thomas.lendacky@amd.com,
 ashish.kalra@amd.com, chao.p.peng@intel.com, yan.y.zhao@intel.com,
 byungchul@sk.com, michael.day@amd.com, Neeraj.Upadhyay@amd.com,
 michael.roth@amd.com, bfoster@redhat.com, bharata@amd.com,
 josef@toxicpanda.com, Liam.Howlett@oracle.com, ackerleytng@google.com,
 dsterba@suse.com, viro@zeniv.linux.org.uk, jefflexu@linux.alibaba.com,
 jaegeuk@kernel.org, dan.j.williams@intel.com, surenb@google.com,
 tabba@google.com, paul@paul-moore.com, joshua.hahnjy@gmail.com,
 brauner@kernel.org, quic_eberman@quicinc.com, rakie.kim@sk.com,
 pvorel@suse.cz, linux-erofs@lists.ozlabs.org, kent.overstreet@linux.dev,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 pankaj.gupta@amd.com, linux-security-module@vger.kernel.org,
 lihongbo22@huawei.com, amit@infradead.org, linux-fsdevel@vger.kernel.org,
 vannapurve@google.com, suzuki.poulose@arm.com, rppt@kernel.org,
 jgg@nvidia.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E71BE1C0022
X-Stat-Signature: yc9fm5z56cssgz4ffynmkahqzcitchbp
X-Rspam-User: 
X-HE-Tag: 1765300912-644044
X-HE-Meta: U2FsdGVkX1+UtRRI94zN2fPwxeqN5lSJR+crR36alwwk5jJj9S3scjWvv8YLPZ2t9arz/CVquh2ZtsY1ZHkvFaLs1N04Z6MCZeWAxOflAG59luJ/uoEXjEwIYDR32RPfwS9Lvm/r+dlaHrpvLcLRI0azRz6W3opmIC8pDFXxZbkXxsnck+zXpxNRmryYzzFE6ZiLQbwtBLPzpU0WPYzDoO7c+9ge028l3+4dotZeVti9N0aZ4cf9SAPlGq7+WkWD4ptBtXShrW7OLsBpoKuu6Ey9stmYs58mV9AvG7Z66pb3xyI9/b1RnEg731E19IywuPEwRgjBeM/ITIt/+6oLiR+3txkpLK2NKhYFq0mJ20cyvup9oh8Ytg2k+nCZTFL6uAQh0m+ADnRgMdlwU02Q9qKJdokgmA+Q8LzqrFzSBL5ijfoSr4kRJ5B9QfdTcSZdZU2c1eWkglXR662Go9FZO3cRsimETyIRqdi17QY7cvPIi9hu9inppoVOIRPi+bSHaXZSNZj8l2fQAzB8h84FVfIEa7Jvrq/D2wNo6mkK+rCObExoqIZ5t/5bWVAvZo8VDddyci60DaxHLs3LkBtvEbiyKwroPr52RfVCsw9dULc1DokOeIDrAMw2CWmZGLyOOgtgRPP/YaThSKnVnQ2xsTKiWE0F6hI3/y45Sqbsfml07U4TueaaFWwkzw2UwbwegESrREuaRfkHl23E6farRFnSAXWurdmn9fs5OYf2imgbFHf5eYiMmM/NSABgxf1NFD5BiFisIkkc1mwQ3UFzMWZZz/EMWvRpqpxVD+6/Tl+zCZwLRERP8/v5zmGGJkpzGguK///mTDVNOL8dBx70oSfSIg14Rx1t1XGsMN4DlvyaHuVhtQNByPX+GzEtBhK8suSwirCou5f1Sy7pMpPnhVYqN7HMwfSF/l/Rq+vJbbIkjgl4JGCfE0kNi9xqkbcPjXV1hLIp283jdd6GhGD
 qpyC64qr
 136nWcW4DdagNaB7cT9bBKxQmkSIMH+RNWdZOcCmjN8ATE+vz6KmlR3BSeeXHqFPfK1OKrQFT08VRIYZwKs7DDiKWkgwqRhQGZvMLR9m16rgcZrxee/448drkWAnMwGZFsE321US1U1gyU3VUz/RhP0VOlEHEZvYZJpnCn9LbTw7nmbOb+XFpRXC8VoNpUIHpAbkjcFM5me/JdQd5rPwlkNFawS7WNZ/ZdiRMepoZuwO1WnFgEzs+Z22etd4TzxV538TMjy5LE1MuOUYxJDKKvUHEx8mW4r1PIMiEgLU3QTR50FCzEdPhnAyLtsS6qgsvRGCs4xjPbpomNVixTOmB0hAvCaVHHyYGzBJPhpb6SkDNzdpYrTWK/B/R4rbTR7eifz/cDrnbLFW2dK4UHIYGXAJJh0ksIqfg9hD1TexqidSUrGGsMmOzLdrXyrxLGcZTASyGvJEf2BOH8B8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This series was applied to jaegeuk/f2fs.git (dev)
by Sean Christopherson <seanjc@google.com>:

On Wed, 27 Aug 2025 17:52:41 +0000 you wrote:
> This series introduces NUMA-aware memory placement support for KVM guests
> with guest_memfd memory backends. It builds upon Fuad Tabba's work (V17)
> that enabled host-mapping for guest_memfd memory [1] and can be applied
> directly applied on KVM tree [2] (branch kvm-next, base commit: a6ad5413,
> Merge branch 'guest-memfd-mmap' into HEAD)
> 
> == Background ==
> KVM's guest-memfd memory backend currently lacks support for NUMA policy
> enforcement, causing guest memory allocations to be distributed across host
> nodes  according to kernel's default behavior, irrespective of any policy
> specified by the VMM. This limitation arises because conventional userspace
> NUMA control mechanisms like mbind(2) don't work since the memory isn't
> directly mapped to userspace when allocations occur.
> Fuad's work [1] provides the necessary mmap capability, and this series
> leverages it to enable mbind(2).
> 
> [...]

Here is the summary with links:
  - [f2fs-dev,kvm-next,V11,1/7] mm/filemap: Add NUMA mempolicy support to filemap_alloc_folio()
    (no matching commit)
  - [f2fs-dev,kvm-next,V11,2/7] mm/filemap: Extend __filemap_get_folio() to support NUMA memory policies
    https://git.kernel.org/jaegeuk/f2fs/c/16a542e22339
  - [f2fs-dev,kvm-next,V11,3/7] mm/mempolicy: Export memory policy symbols
    https://git.kernel.org/jaegeuk/f2fs/c/f634f10809ec
  - [f2fs-dev,kvm-next,V11,4/7] KVM: guest_memfd: Use guest mem inodes instead of anonymous inodes
    (no matching commit)
  - [f2fs-dev,kvm-next,V11,5/7] KVM: guest_memfd: Add slab-allocated inode cache
    (no matching commit)
  - [f2fs-dev,kvm-next,V11,6/7] KVM: guest_memfd: Enforce NUMA mempolicy using shared policy
    (no matching commit)
  - [f2fs-dev,kvm-next,V11,7/7] KVM: guest_memfd: selftests: Add tests for mmap and NUMA policy support
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



