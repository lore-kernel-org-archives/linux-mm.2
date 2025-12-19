Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D43ED74961
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 08:13:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C0056B0088; Fri, 19 Dec 2025 03:13:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76E7F6B0089; Fri, 19 Dec 2025 03:13:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66D236B008A; Fri, 19 Dec 2025 03:13:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5553A6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:13:11 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 66E7E1A04BD
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:13:10 +0000 (UTC)
X-FDA: 84235505340.01.38C7B4D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id A9CE540005
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:13:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Xo2kx7m/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766131988; a=rsa-sha256;
	cv=none;
	b=5R8yu2Le0ksBcCfJx1O9Rq+QntTVA4nxJ9kT7jE5UpyXKWGFjfM6Z7gmZ6xrJUpvNlWKz/
	de+PXWRoWMsiiDNed3RP8LPm+Tga7Oh/kGuVnPHJgGKT27mikQfC4kEaYGn01BEkeV9AMU
	3x5bqrALPcJ4o6RU/cyo/FR3Z5i9/q0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Xo2kx7m/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766131988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tB6ydqr+knJOoPlaqCHSfhlz3T+hyKZR7Yi4q/uoGos=;
	b=Dr9U1K9+bN1jbpXkHE1PTZwKsW9i8J9SY+GMn2Lmv/Q8xw/p03wqckG2ZlOb8Z0QGLClRH
	1Bud+h1VT9jpgqm6oScyoYgJMF5zVWPHJWUvbCiQWYDN5pK4NVydGK30/p64PNA8nPdFLw
	WofL0aGf0dt+xmk9GP+Rc5AOcDvq3IY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D80743F28;
	Fri, 19 Dec 2025 08:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4893CC4CEF1;
	Fri, 19 Dec 2025 08:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766131987;
	bh=Da1igU9nJRPnZ5L4W+6oiwIrxZfJDMP73Owv2lIqQYo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Xo2kx7m/wag5DqzcA3vxDHxKhWOgdPOuJESlc1/0Bw4zijQRvGwcYF8sgefqxVOUH
	 Zw7Jq6c5KKya3qz84l3oCzhyv+f3Hl5QN6IR/gQco94/zBQsFWJdUZMRarmcE3Ll17
	 OQ7tjezH9QvsQp+tDWb38i+rSMT0jcobYPSBIFuOov4nLe+6ZCUeTdTun+6WS/hhTx
	 W5N1PVgKEmBDep/c+MpJ7ASaed7AYRm9hypU4jHMnojPqCCBuQmDlX2Msq21NunqfC
	 TPT3nmO8DeMmdKSb9GRyluaIuOy7isHD9uVzuPGv9qibqFkmE44JdEtsdo/sYFbVcX
	 QY19z9sJx1rpA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 78C73380AA50;
	Fri, 19 Dec 2025 08:09:57 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V14 0/6] riscv: mm: Add soft-dirty and uffd-wp support
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <176613179607.3684357.9882444672528861382.git-patchwork-notify@kernel.org>
Date: Fri, 19 Dec 2025 08:09:56 +0000
References: <20250918083731.1820327-1-zhangchunyan@iscas.ac.cn>
In-Reply-To: <20250918083731.1820327-1-zhangchunyan@iscas.ac.cn>
To: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Cc: linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, robh@kernel.org, krzk+dt@kernel.org,
 conor@kernel.org, debug@rivosinc.com, ved@rivosinc.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
 akpm@linux-foundation.org, peterx@redhat.com, arnd@arndb.de,
 david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 axelrasmussen@google.com, yuanchu@google.com, zhang.lyra@gmail.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A9CE540005
X-Stat-Signature: k6zrtj1nr3xy4awqip6ncqpeeame66n6
X-Rspam-User: 
X-HE-Tag: 1766131988-133693
X-HE-Meta: U2FsdGVkX19hGp02gb0RKl4mTpQVblk8b9Oswyw/QXOrsELkQtdKAFZZGgarDe5AQ8+K9VMiIdD5POekicxnXnDA74yQd/q03qmY+q/2O5riL7lG4Y5lPBM2pojjvH/mB1MzS0VizsG71OT0sy4EiI9W7BMS5VVPueJPF4oTKsdnoR27VBNMqUzONWcsEh7/w2VAhz/JWS50U6kMmBP/f9lXoLXzjU1Inu+nrB4zdba7kKdV1vet1xCejpP/PvoykT+gMa8R+hvnX0h7hCuKFT7qrJXXKYJnZ4pxmaFwiBgu/ba05ckLMPmaTyVsjw/ts4PThkgUKKGlHNMQagmDO2qZhQ+QaqAqrV1LAi+eX2a8di2Y+8VXtPAAta/SzoqyuegAhAgbOH9FPCCJ2unkv9iiUIevCjFvi0bfeG2Cf+8yl4UDchnC36KCa3iz6/kxIAzftNvOOl7V08EPv9C4OPcWlix2rIAAwAVDDn6X0DL/+b0XgV/3Ry661z5AL/DC2vt5EbmypAneDIcR7oIeKvUJzf5NL1vMqyfhvnplolIbOHY/+vof3udnbbLJ7P4GM7S2sIOzPmadCWCnkpbMPQJMBSvXSMbjr+7CJvqZWimXEAxSKmZ7V01RfHT9ePGecPWueSiKGPgO237W5paJuClYzf4cplo86cXjUjTlPh0sl86wk0URTfT9kQcNc3Z6VofjFWnTFR3O1qgfbPeLuJfOIz5QzY0ueg+ZgJS2oHb+EgcbMEWXP5gFe9kq7oTyykTUOd2Ffy5VgpUt4MDzh6IVlMpJ06xgzy1DxODPEmQ6ef6isb0O06xDCMwKdaCQMX5RLHRPUcd57+gwMEqAo227X1RziQgjxkfYBOh+AZgW0iI8S6lSvKlxZKzEcKvkVAX/lwK3XlRe/d/2jOt5Pkohc3FoOTwb7kWfxch93jTPCjYBJh1s0uugQh2oiPJWVNcaQMjhQTI9qpQ7BSF
 ys4OHP0W
 Z+tVTWklOkhw2ssAHVohRePNJw8s/Nw/uYLtAvlueDCXzeEjxvaq/WMcO7SXJuu1FwdZP5QV5lCTmk08eiRDitISPYMo2kmFoqsnxoVyk+d1yKnJ9te1DueqIkCvJnKe1a1pQg4ttW9KVgv8wzWEMp0TnBIS8duGdZgj5xdRwM7w4tIDiqtTDmIyfjrqMmMxZLlA3Z1+TCWjFqlmu2SgzrLd5Ou1lkkh4tnjojMurI2K5grxMF4wFWCb3Tfj8y8B3BZolzCIlvIilqxMv98KSUIFA36sD7TlmWtGP6gezT1lGPOh/71vOCAxILFYUYoRHts2q0hETyBK62rbLJzWncv61m2qDviCYSqsA+CDWZfkN0DRopMH34be1VwmIwXtzFozhfw/wHFQZxTGECHV9wMeNL11iOVJPGDqPiGEcmAxiNtazHE237bky90V2aScJrqUR0qD/OBVDXh3YCmoL8LI6vnCdt+x8DXTKawgOYZMB3x8ddtrNUlCW2sopQLoOhrVf
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

On Thu, 18 Sep 2025 16:37:25 +0800 you wrote:
> This patchset adds support for Svrsw60t59b [1] extension which is ratified now,
> also add soft dirty and userfaultfd write protect tracking for RISC-V.
> 
> The patches 1 and 2 add macros to allow architectures to define their own checks
> if the soft-dirty / uffd_wp PTE bits are available, in other words for RISC-V,
> the Svrsw60t59b extension is supported on which device the kernel is running.
> Also patch1-2 are removing "ifdef CONFIG_MEM_SOFT_DIRTY"
> "ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP" and
> "ifdef CONFIG_PTE_MARKER_UFFD_WP" in favor of checks which if not overridden by
> the architecture, no change in behavior is expected.
> 
> [...]

Here is the summary with links:
  - [V14,1/6] mm: softdirty: Add pgtable_supports_soft_dirty()
    (no matching commit)
  - [V14,2/6] mm: userfaultfd: Add pgtable_supports_uffd_wp()
    (no matching commit)
  - [V14,3/6] riscv: Add RISC-V Svrsw60t59b extension support
    https://git.kernel.org/riscv/c/59f6acb4be02
  - [V14,4/6] riscv: mm: Add soft-dirty page tracking support
    https://git.kernel.org/riscv/c/2a3ebad4db63
  - [V14,5/6] riscv: mm: Add userfaultfd write-protect support
    https://git.kernel.org/riscv/c/c64da3950cf4
  - [V14,6/6] dt-bindings: riscv: Add Svrsw60t59b extension description
    https://git.kernel.org/riscv/c/519912bdaee8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



