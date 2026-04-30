Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C47CCD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 03:25:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BCD06B0088; Wed, 29 Apr 2026 23:25:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06DC66B008A; Wed, 29 Apr 2026 23:25:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC51F6B008C; Wed, 29 Apr 2026 23:25:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DACC16B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:25:50 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3BB111B9681
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:25:50 +0000 (UTC)
X-FDA: 84713782860.28.445C798
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 76B85C0010
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:25:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oK4W1kKQ;
	spf=pass (imf22.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777519548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e5TaI9M8cOEzzxA3yKmeoFjtnYXZChCt4lKYDYwQv14=;
	b=S6ls8TyLh6VfIfklad9/UeXoJTju3RcfVQ25UxjwxfqHc+Ou3JNrk6H6Br9rsPmo/UlFnj
	SbI0qhfCPhxkOOBK5nKEkt99cpr7QxtcJVBguVEHkNHpWOccwzgzVx5rbGGclilb9sELuy
	smrx/vvE/tJkdwiGMErPGvye1fwY0kI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oK4W1kKQ;
	spf=pass (imf22.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777519548; a=rsa-sha256;
	cv=none;
	b=oEDIix3NF/PVLKp+/gWGYlt7Zyfv9zIzhHoLUg5Cg9gUruaG4M+9IDxJOVFGHTb0WICXjr
	FQsZdW/mGl1LqYxQ4SJHgk+UwCePbPXnKN6wS1hy8dghJC88add9sYfEMRtxgQMm5Wb+4K
	Mp7G8RZhzW5l9KKf1mqUM3RqgP+10MA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 146F844455;
	Thu, 30 Apr 2026 03:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE62C2BCB9;
	Thu, 30 Apr 2026 03:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777519547;
	bh=dFN6b0A1gSAjmpxBdfCzLd7sjLkkLRUt90cBNTEzJS4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=oK4W1kKQ5frD7xBp2Peo4k+zymjuUiJnLNz1vcnh5EFW4Atm0o1eacKZFX3kxsdMB
	 Z/9Bybkbt3e4DSKls2D0XjOElY/uAFwJmkXI/D33yiz2mgpn1fh1pHq8wwtdcupk2H
	 lxsRxcmcLT6uUAPcxQs3YzTqZheDJf8qP4uhFGhGgLv/DTlHLkFL3nUxAt6MFMm3Wn
	 udAWzPlFVeqX0qf5lNmUGifS42MtZaKyGgO3cIqnJJYyJsJWf51lM0MqpG8QFB2ry2
	 1jlaoCGMchkNV4IFNSmAKO5kJWwGEnpPKMc5ZEWOTjjRj0oKTos1CMGgTRvfcPXQMF
	 j0NI9CkIJOSPQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FDA63809A07;
	Thu, 30 Apr 2026 03:25:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] mm: remove CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE and
 cleanup CONFIG_MIGRATION
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177751950193.2274119.6306882784421764696.git-patchwork-notify@kernel.org>
Date: Thu, 30 Apr 2026 03:25:01 +0000
References: <20260319-config_migration-v1-0-42270124966f@kernel.org>
In-Reply-To: <20260319-config_migration-v1-0-42270124966f@kernel.org>
To: David Hildenbrand (Arm) <david@kernel.org>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org,
 kernel@xen0n.name, maddy@linux.ibm.com, mpe@ellerman.id.au,
 npiggin@gmail.com, chleroy@kernel.org, pjw@kernel.org, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, hca@linux.ibm.com, gor@linux.ibm.com,
 agordeev@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, akpm@linux-foundation.org, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 bigeasy@linutronix.de, clrkwllms@kernel.org, rostedt@goodmis.org,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
 linux-mm@kvack.org, linux-rt-devel@lists.linux.dev
X-Stat-Signature: xug6d76bppdsy87ta8jpq5orry6ab7d5
X-Rspamd-Queue-Id: 76B85C0010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777519548-294558
X-HE-Meta: U2FsdGVkX1+VQCkkB5FpYZBcUEDPXd1KjG9zMoB4kY5t3jJr7GMPKvqgK0TIrENTfpqXE/PhDgbbgkFZMT7wPd0R8tg+DyX6HfhIUzDQ0b/lpsjtliGjCNGKpp5M7vlLdU7DJ4mESAdbZyYlOYxHNCEBjXTYs/H+OADUwScUeXblEGj05+uinpnstxQpSjyeMiPdna4JRBdYj+fLFAKDuefSPTT9nck/d3UVTreG+s1NYwXMbODblY5JPvcfHLxG9PHul0ltlPA+CDs+4bEcEytoFObM9qa5kpYpVnrjpCq3YAva5ItW3hG0VqydU2lnIaE0O9MCyJlx/pGjGUYt08ZNknMF/TNiwUgAa/7E0+nViHpOUkIua9oPAm6pnQ/TSChREdF9V09Ct6ifSMKk6hJfN8JKG7eAAOYn3bonY/RKys7NZ4wQyu1ucdGweyBrp0efXLINyzGEYEPzrBejUgUk3qCgf8NVq/1jjoxDcU3FXPrddFG1zg0j9eaHuzY3oH8nlatB7w4B/55fWKKSABOVXSdRvImDDw9TZSnpUCl5Wc5Qgesa1Bit1+0sAyRAa4RvvswrxtKesrfO2zgkdKNCQrQPaPjtwu39ep4bBNfEYtGSbwLrPAXbg64Ak5pa4hIDiDSS0rISD1FckxhlFE2Mw67hCsa6BaxtNYhNKLkU2c8ZZvO99bkXvnwGzdkUQxx75Tm9DEXYHE4NUM74ndMP49vC/o2NLrACzINmksl0sQPg+OAmq69mp0LPvAI+eGTnq83XHmOY5vkkr+K35FoEYSHmW/gbAh8v9jNSig5jrPB49Me1FhIS9DgeG4lBAJVXCYuKiwL0Up2gMFIbxOpCmetqDBG27yy39pKuz0VLe4EGOs6IghnkAktgvx/Cg3XQGL5HBhs+lIvwnfUtTega47BkTuWJHbyNEX21d2MqDkOmKMMZz8gILQs+XBK/MaEaASyH0d5YG8Sq0T1
 jJTUGVDB
 ZImQB888sZ6cRQ9lKkI+fC+cu76ekO5tPyOeyeYROehEAnVgqyLArv9sn7byE4F/PXftkz3ej/v3GrSR/GfXLl/5IDtTIi7uw1EFRi0aQyOAulEQ9y+HCe465kRuGKA9hFzs//JMQ6qIqJhMlUAdqUE7icBfRaYLSfyvejqQKZMdTz8+YDQMBUV9YpQpv1YC1PJCxpyHi+a72xTq3+AgOi5ZPJBuwZNaI4LgAlm59TA2Y7lIZuk8jw/14zyhktaNCPEtTW58Z+PZc4bGkqliqLJMfC0e4Niv5tanBkevpT6GWvZgMNOK7xummoOOYBBWOxFwz7bl5SjMVY3tVpotdLNnzUAiOPevTjOaZgar8F4vP0fKldI+JzlJ0dob8/mafrwnK51bAj6YmEnxfYG6De1RPF98co4XhhqII0NLz5MwyCrTMb8RbdGPLX7V8efPie7/cK1IAHe3aE5H0TEGPBAvIsd7tcxfxG4V6bdhZ6tC+BedjNHI9Umj3MAI98KntXMX3L+lZWV7JmbwEMBniu9CSkYdZgms3zvhl2xd+W6OQE1M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This series was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Thu, 19 Mar 2026 09:19:39 +0100 you wrote:
> While working on memory hotplug code cleanups, I realized that
> CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE is not really required anymore.
> 
> Changing that revealed some rather nasty looking CONFIG_MIGRATION
> handling.
> 
> Let's clean that up by introducing a dedicated CONFIG_NUMA_MIGRATION
> option and reducing the dependencies that CONFIG_MIGRATION has.
> 
> [...]

Here is the summary with links:
  - [1/2] mm: remove CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE
    https://git.kernel.org/riscv/c/078f80f909ba
  - [2/2] mm: introduce CONFIG_NUMA_MIGRATION and simplify CONFIG_MIGRATION
    https://git.kernel.org/riscv/c/6ebf98d71f9b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



