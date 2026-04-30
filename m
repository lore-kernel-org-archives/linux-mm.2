Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8366FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 03:26:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B9A76B00B7; Wed, 29 Apr 2026 23:26:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26AC46B00B9; Wed, 29 Apr 2026 23:26:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A7E16B00BA; Wed, 29 Apr 2026 23:26:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08F166B00B7
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:26:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C23F21C0170
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:47 +0000 (UTC)
X-FDA: 84713785254.15.B8DEFCC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 37C9140004
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="NG/keSn0";
	spf=pass (imf27.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777519606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6v0rUdgnzxiEmQVki0fjHoaNjayirc6nPjzNRAFlLsM=;
	b=OdqACxFHFbbMAFUJurZiZW733Id1I0/vc4PkSMBxpqS7AaRqD5gQuAOuz1Wxsux96MH+tL
	sAsLfZeZToAG0lXHtY0txP4IaxyX/nDuT/eBbS0Ze+UtkmnUnndPcoHlA+aNmKSOewD0Uf
	epGregKEL+hBcpUGeNsHfnFnyl5Ai2M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="NG/keSn0";
	spf=pass (imf27.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777519606; a=rsa-sha256;
	cv=none;
	b=gM7cX/rosdHUF4CMpyvqlun3JAg+PBEcb9cGyxSYJKDFE58XHozp8x9B1HQ9XdrLI3fefN
	RnrE3hUwZBV+6J9HoIlKftltJggZaJf5i2fMXoef8CntXDXAM/NjGEyIe6sBH7NckFR2hs
	0LDoI5W1x+ONSZI8DIyGv52IIiJlA7U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BECBD6133D;
	Thu, 30 Apr 2026 03:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68BC9C2BCC9;
	Thu, 30 Apr 2026 03:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777519605;
	bh=fhSNmqrG5HsEC/X36MILLZcbTZ/au30iHuph+y5PVBY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=NG/keSn0FdCovg8MaqpF8Evbj/6L9DumthcIlwwxhgqo4krFVNquz8+s6I6cAbdTk
	 F7gB7AFBovML2uNA08fug18O6ouheKOBf7t2Cnd7nzLWNimtDo+aiOW2df5uW2tRMT
	 rjTagxlakUXzJK5UOaOgiNsPLEmBzI0SrCWLU0VLJ0JlqZw+7s1UFWYN+UsHMoS2Qd
	 iECXbmORVBx8yix7TpNhGpQ4YIOkqqw/43+B09zOhAKOAI6t3lqj+2vCV+m4mWAT9q
	 7VgoHD8YmgUg9LVrLh8uiVHBbs9Yxff6nj7MkquNCz6a+id9IgGedB0JwH8SAImjFL
	 engiwcFkxaZoQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B9E0C3809A07;
	Thu, 30 Apr 2026 03:26:01 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv7 02/18] mm: Change the interface of prep_compound_tail()
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177751956029.2274119.5996274092422873804.git-patchwork-notify@kernel.org>
Date: Thu, 30 Apr 2026 03:26:00 +0000
References: <20260227193030.272078-2-kas@kernel.org>
In-Reply-To: <20260227193030.272078-2-kas@kernel.org>
To: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: linux-riscv@lists.infradead.org, akpm@linux-foundation.org,
 muchun.song@linux.dev, david@redhat.com, willy@infradead.org,
 usamaarif642@gmail.com, fvdl@google.com, osalvador@suse.de, rppt@kernel.org,
 vbabka@suse.cz, lorenzo.stoakes@oracle.com, ziy@nvidia.com, bhe@redhat.com,
 mhocko@suse.com, hannes@cmpxchg.org, corbet@lwn.net, chenhuacai@kernel.org,
 kernel@xen0n.name, palmer@dabbelt.com, paul.walmsley@sifive.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, kernel-team@meta.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, david@kernel.org
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 37C9140004
X-Rspam-User: 
X-Stat-Signature: mnqhwk7bdi5iqwszh8qhaeyi7ej7g8j9
X-HE-Tag: 1777519606-2839
X-HE-Meta: U2FsdGVkX18/HJwmq/NIKUbqFB/5toTFro7qboQUBEY31A7GS4kxRdj03bNCIv9sZhjPnivKGmHSTQCh9YNLrfeB3anKQSqdlNQg0vehgJj0gTERE/eAzDXedn+uTmAENmP08GZq2/LdPKodt7hTBL8F/2JISrqmbcjDkn3ZyVEEdPEwes+zp+mjD1baymePN9gJEynsuxlIe2PrpFKtGHcISxo/P4It3kDvsjfP1tg/wMzGyoMpoQnb/Osf1GCbIjeC/L3nkAm7tRLxj68kiNUPTS48PVLvfX4YlzDTGMHplksd0oBUfqXSof8AhPpFrTHvcluHDjY/9GN8aDK7KgMdTgh6mKfsmfBYd/GuII/RBGnxY2e94WkXD9nwlKZJw8+HHAW7v8INoL6ckSPD5TQ31Vk2zRZxYnWPBmV8c2N/1VNQaCDC0lGUe/EHudi7s14geRyczpKJpi5bPqn5npqQebqjTnCg2KOxs2evPWckP9pRQ6UVAx+DSWRiupW8Ipt2p++WOxIz9Fp8jHexRI5KYZ6nqkAJdEzi0q9/A4/Iy/dZue+h5SF0k3dvnl2065urHVNmlxYUxWmO3GLducZaiCwMie/dERljKHsvuOEwsstR1tagYtXfR6YuzBNSuLwtIiun/VIFK/cSOgnvFehpCzKW3JoMnwjv3sS8Ud/VVu5rsikAOVrJgOHr+rJifodwAgEGRnyOrzcTlj0NkaMLurc65us8O7M7urYj2NI8GmjTemImvLiPF+jWMmQyqaEgOw9MIrmNHkubpXSpbPqWiOvmBkqUdWJ0AvAmXkK3RvPigbx28KCJpRbq43BVyeFFKg/+orjGSUTy6W7IqBa3XZr+4tKKXM9Vdeioit2sQbUNxjrUvJj+2xZPuj2rUpCjndUqg0uMVnD39fNsgeeci+wshuxkNPEHIxUP472lDAims6eHRNgyY+Qod6Jpw4a926AAZG1QFytj5V8
 axQgudg8
 qLBHABC9/sue3P/ZMnXxluv9dF/CPjOjznuvuypRs896hfdyd5dit+VjbHLs4/TDhJ2K8i3l+xWuHu6Wzvf6Q33enMlxLaojn+BMJF0+zIf+QDA4EAd7doZDXNm0KbAh7EWDpgy3vPTdDzZFu/KzBd/l0OPtH6u8zV8u7X3HRyNq4yVyKgUT/GRjJ/E/tHSRTycJjAg1dD5f3XILyudkKeMEzwBKQ2KlR6tkDcgUnBQ0JK76C/KZbVj+3m9JsAvIWHpZBw8QbV8YrA8A4SkUKneoRyO+RTIWZfmsKNIesH0l3Y3oGCzLyhwdgeghH6fNh8m0aJN5khJeuOyMRE0VYtZXd4aEqRnCzJikHUxMqGnVVusSQibYb+RpOGPWbrpJ/GOoeNzfOcEWR/bA28eTzJyKRkZasG/SaRI3Y2fNCcj5RPZ4uoAFH3c0MHRmakpABtG6Jl7E0Pzog5TLMt9MwqXf1SPmSMKpsfoxJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Fri, 27 Feb 2026 19:30:03 +0000 you wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> Instead of passing down the head page and tail page index, pass the tail
> and head pages directly, as well as the order of the compound page.
> 
> This is a preparation for changing how the head position is encoded in
> the tail page.
> 
> [...]

Here is the summary with links:
  - [PATCHv7,02/18] mm: Change the interface of prep_compound_tail()
    https://git.kernel.org/riscv/c/f0369fb13619

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



