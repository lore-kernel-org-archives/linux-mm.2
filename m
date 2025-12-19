Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B67CD711D6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 08:13:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0D396B0089; Fri, 19 Dec 2025 03:13:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B79C16B008A; Fri, 19 Dec 2025 03:13:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8EDE6B008C; Fri, 19 Dec 2025 03:13:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 999366B0089
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:13:11 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5C1011A04D1
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:13:11 +0000 (UTC)
X-FDA: 84235505382.30.DF374CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id A46EC180002
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:13:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="k3+Ld/gM";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766131989; a=rsa-sha256;
	cv=none;
	b=EMExIonDoJ5wk8VdIS6q/jM3AY/4AX/zjT3AZuJZeDOpR4e6YZ5M5FaJqPSad/gYKkQIJ8
	hzOqYXyNCkZjdn9zFBJFA8kub2zfeQXd+lZv5lJ6akuC54PCbP3PjBHsMlJL92Fd+XVcat
	r42999pqLxOn/Rvgm2wNcNGRJK4SZt8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="k3+Ld/gM";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766131989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2v7RKZadUXAV0Q2emGoQzJ+lO/DOaMJyHLYdZ/vVZDA=;
	b=QKrsayFk8rIe9ud2ziT/mZbIR/xNrXOFclFM66ZjyCGz0eivOI9pnGKMb48eVQiuKUvA5B
	TCfE7G07AMZmOTLPmDypx/K9qdsl8D/6aoIK/1u4SVjEsIlkhrJicu5D7XM0dgXCOdqlKW
	0GJWw/YXI4216EE1HRE79ssT2ZzjW+8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A036B4446B;
	Fri, 19 Dec 2025 08:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FFBCC116D0;
	Fri, 19 Dec 2025 08:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766131988;
	bh=d8hfIZrr4/YXPj8cN2Cj2/92hRyCmo8T5+xN5aVcRQQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=k3+Ld/gMgJdQln6OYHiKMS1MJHb7f7DcLdsqE0tNLr1lddoHDAG2kbDRMYAqOiZC0
	 ljyJ/uW1xSSjlmHEnwdR5HTtwuKGqrR4nnfjNto4oUq0/ZKPv52jdgz3sMpSwa5INl
	 w2WrclITAvmoSbYgAq9UJ50/LqzbUQTrUKzDS3SutXXJ7ulB8ZC0ShLlpfH2KVddgi
	 GLh76tDdnwFtoBFaFbN0H/CeqSn35onbRnoNNuqJAshypHMNPP9j3HzDwHVFExFWW4
	 RiJBPscY5fyO/An3piZdVOGDZCVvtVPYlWtWiSB39EfTtQNoCI5TtJbo/Butp7rBWY
	 Vt7k192nPv08g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BAFFF380AA50;
	Fri, 19 Dec 2025 08:09:58 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V15 0/6] mm: Add soft-dirty and uffd-wp support for RISC-V
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <176613179753.3684357.9232536876700383473.git-patchwork-notify@kernel.org>
Date: Fri, 19 Dec 2025 08:09:57 +0000
References: <20251113072806.795029-1-zhangchunyan@iscas.ac.cn>
In-Reply-To: <20251113072806.795029-1-zhangchunyan@iscas.ac.cn>
To: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Cc: linux-riscv@lists.infradead.org, akpm@linux-foundation.org,
 paul.walmsley@sifive.com, palmer@dabbelt.com, robh@kernel.org,
 krzk+dt@kernel.org, viro@zeniv.linux.org.uk, linux-mm@kvack.org,
 peterx@redhat.com, arnd@arndb.de, david@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 axelrasmussen@google.com, yuanchu@google.com, aou@eecs.berkeley.edu,
 alex@ghiti.fr, devicetree@vger.kernel.org, conor@kernel.org,
 debug@rivosinc.com, ved@rivosinc.com, linux-fsdevel@vger.kernel.org,
 brauner@kernel.org, jack@suse.cz, linux-kernel@vger.kernel.org,
 zhang.lyra@gmail.com
X-Rspam-User: 
X-Rspamd-Queue-Id: A46EC180002
X-Rspamd-Server: rspam10
X-Stat-Signature: kzx753segzwar5ifdrzkkhizf5ew4w1q
X-HE-Tag: 1766131989-851028
X-HE-Meta: U2FsdGVkX1+ntqURZX8ZqbWLpzXF0K7cJMcIcE/jojQxdLWd4WVg3V8cSiOQ65ZPiNdFOw0Y3uJ/xwBgcnYTTbHS6T+TvTTRQ/uMxnS1AfeqGIXcBEt3QkpzycRzeyK7oEZQ07mcynb+lIjTnjbimCj0OS87XbIKlC2nf0wRBs/32ddC2d401p1GBGB0Pj5vdUvYJQ/QT/vzm4SEqufXvjzM5cm4JJv5Uk0DNirdAsh53t2oT1CSn2EnbwNduKtDxawN2rYvkcNtUr9rbpf2e/ux5fz4L6MlnSRn18QHvct+FxTP/s/RESkPClsDsRacvmgta0P9Iuok4600Uhi7J9w29QsOnzrcdrObO/qzALZQsUHOZZFg5FgC5Af/zD4HSEBzWgCfsJ/3lhYUYW1Mr8q5HDPZJf3OrBdZF8wgA8d4F87edd0eHmcYWSj3GbwpkT4AKjj6T784rEJVSBTHkCgzyG6FKTSeuh9Td+seQBP4hQbwVjvkBJzmpTSnaChi2TmX+IE+Oaahd7ocB5APDI8b0rB+lxunUUUdfufSQ8zNZechTAm549X0D5g+5NL0Rr2rMLSSAyPPxGv3CNjzcRyTkFfi/Hqtc2DcFDfU2H565WyrtV+W19WxegEuHUlTxfcZ9Dm3lnHKioGpBRnt7NPOY+n3NlGr35Id0AbHWeNnVDKSEZnP2BC4IiwyC4M4uVqfGK+OVtGBqRfXWltn5x8RHi42k+b0UAPj99xtYoSWRuupn3O22+oDcPNM7lXwdOg1m0E+cSTnhHs77Kc9fVtEanrv55asYHX2IoY4fHlEdUCggKD2PPK8/8Pd59J6mTFsxmRx2UEeZg3Jo9NjnarKMHWSSf+WL2meElwAQLSTlM1hTlpuSYCVwfrGo3ujrG9x0Sb3CUkg4ggYu55Lmt/z7fOY2aWhC/pVZlty0D58piOqp+O3NHy59xtLy2MC/vJ8xRtAwxhbaeZdOOq
 jynkhHsn
 XPl3RC5ReCH1IxBEgE0IR91h9SlyvCWS0dwH6FyUybBFYbZ0EhvOBSw49HHQsKyTRxjHA21BUGy5B5zj4TkvTscM6McM8dp03VMwYUtOwzJRNxGUDLR0OGDh9bOGdzu4Cih7r/SkpGzw2X+x/o8BVyAUfZOfeaQz6ntIlre7XKzyFDGPLP/Zt0iju4jfggvf391quwky7JxZ7b1rgame/gZO8jpwvBmJ6XWWpwd5nYLxtNvCDyr9919azHmrPPGH9NdyMMoo5pz0nPmdTSndqDpXpoMUte74wkpZGXworh5wGyDQPV7dVJ0dBG2baLH9WLGnPwiS8CjspunzgW4e+BL2dcA7fm9mRgUpqh221riT9OO0BpsoUK6+ncVuXU+H3n9Yvs4pVa4lU7G/ypZrdAu/uE5zWxguCQth5cVIpsFyqOp3PBTCE4jOtFRosN8crgsDG27PP7WefQ8FXezyUrP/grw==
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

On Thu, 13 Nov 2025 15:28:00 +0800 you wrote:
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
  - [V15,1/6] mm: softdirty: Add pgtable_supports_soft_dirty()
    (no matching commit)
  - [V15,2/6] mm: userfaultfd: Add pgtable_supports_uffd_wp()
    https://git.kernel.org/riscv/c/f59c0924d61a
  - [V15,3/6] riscv: Add RISC-V Svrsw60t59b extension support
    https://git.kernel.org/riscv/c/59f6acb4be02
  - [V15,4/6] riscv: mm: Add soft-dirty page tracking support
    https://git.kernel.org/riscv/c/2a3ebad4db63
  - [V15,5/6] riscv: mm: Add userfaultfd write-protect support
    https://git.kernel.org/riscv/c/c64da3950cf4
  - [V15,6/6] dt-bindings: riscv: Add Svrsw60t59b extension description
    https://git.kernel.org/riscv/c/519912bdaee8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



