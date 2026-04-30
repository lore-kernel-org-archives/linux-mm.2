Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 385D2CD1297
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 03:26:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E5486B0099; Wed, 29 Apr 2026 23:26:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BD976B009B; Wed, 29 Apr 2026 23:26:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F9016B009D; Wed, 29 Apr 2026 23:26:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7ED416B0099
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:26:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 44E911A0224
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:11 +0000 (UTC)
X-FDA: 84713783742.12.E94C236
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 925444000D
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=juZ89lUU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777519569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nAkMS0ZZXpVpDwoF2mFprcRHCHlEnToRGAdKS0OEKbU=;
	b=vLfHtrxh8UB5lg9Xc/bDOKkvZZ0+sX9o7+syx/nUbnuV8A2/JSx8fsK9GObKaV98h8UHzD
	NobRV0nh5bmAnJpLKQO9+IisNIEMkXGP2gPLt9UFR3vAa2kjPj378jZ3973P7/7W4ze/S6
	ziKTygtVjPk6DPN2TMKl8+25t67EZ6E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777519569; a=rsa-sha256;
	cv=none;
	b=48XlA6oHVkbqX3GRDnfjCwUhCKSaRMbmwJAtLfr0vEoe2ITFCJ2lTcKFNQQ3oW9GNwEW8s
	FIguUG/3912FhjttOS5k2mLv+ufgjpBZUxkfjSuSjm0tAhDwz1iRATlwLCU/E20HM99abx
	LJnRBJBOD6v7fRZNxVcxtIO2F8o/Q6k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=juZ89lUU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C5CC6445ED;
	Thu, 30 Apr 2026 03:26:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64A6C2BCC7;
	Thu, 30 Apr 2026 03:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777519568;
	bh=Mv9m+6QFE5X2BSGU25QtTcnJE8P+nH7SNS4s/QHDQxg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=juZ89lUUjlVInyNLudhGL6gKUdYypOgVutLeQYu7+Zv9S1ojQMn1fsbg4/q8HA9kf
	 uytXyHEjScBl37xivNSPE4ryJhsH6K+fNiVEE3Tibqd01DfSHLLdV6DIGHiyfLM0j1
	 7lINbKqurIbK3kXn8ov3jBGtqjt9zr1HJOqGLUPQmNjzT4ay7v/AFZ6L1jO6UnQ4rh
	 0keCg/YHJh/PxXoT6xU3vqXVkdyYSyavz0pn2sGolZ+WXuho12ORsn1aVio9mo8Pvg
	 7/PlMZGkUL4uMfmMsq6/Hm8MqMlXxt9gGwLkoqjr+NZqDNUWGsEQTi8myDrLsVuFeA
	 HFH46Dai3te4g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02CFE3809A07;
	Thu, 30 Apr 2026 03:25:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv7 03/18] mm: Rename the 'compound_head' field in the
 'struct
 page' to 'compound_info'
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177751952355.2274119.4433106526683678449.git-patchwork-notify@kernel.org>
Date: Thu, 30 Apr 2026 03:25:23 +0000
References: <20260227193030.272078-3-kas@kernel.org>
In-Reply-To: <20260227193030.272078-3-kas@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 925444000D
X-Rspamd-Server: rspam04
X-Stat-Signature: epaeddtztzyt3kxeq8xzd1k6rhdhcu4k
X-HE-Tag: 1777519569-718382
X-HE-Meta: U2FsdGVkX1/CC7HhHAPh678hPv6HuvvEwE4aW67izOec1OC8KLZ1dCwh8+x7dzHWpuJbLmPe7/dzjv0MN12kI9mvVslPagXxLI9qNSkA3M+uKD4rFni97BtRiTQuq5patrkunC7eXH7Y/4eBiUPP5JB3xzO0jimr/DDEBo3FB5l+1eiDKS2qwh9P+u4m/KerDImp2IrwUm9NOCcgA6f3Eomdl1fGEY6O8DL2DbEsx0SXm/yejO0T05vLjuWVmJaYSU3Vf3MEN3hU35DfBtUviw5SskeQdZUOdJWy9rodz4vfJhIgfRuOzw5Eim4ws654sj5QCltDnS2xsGVIsbNHpFcozjOVejYyZsHfr6o+1c8sCo0+A8qbSuKRPnZkoz0ZyBQi3AqKnyj35QzZJwnbHAO80gOcJEFdl83i7TdSSafHtxDuB1MnzR+3ayUUuT3RqcDlwDWrDBsSXASYJuZLGt6Jy8yzvV2o6Xxr7n1Y+yScMyNv87j6vJYe4xw4Et2s1wb5gJ6E3sRL6t0XwgBhLxCaRcCmTZzBu8q9avksACpwrNDgyr+eEPcbrD3/yaChG7I3vsUcDQbTxp6Y0ETWkrrwDM6jd0e3hllYDg8FsAfdkRiQC2NAE1DEBSf7tqUuR6b6DNg6XkD+L4hS723DedmtcWd8u4UZYPJkDWopmg8ANm1KOn7Uot9UsXMazChURZDwxw8/C79unev6WBXBnjXWqHP7vcIfoMAhUZjFJkgzuNjCRxHYTdKSj9AtGSgUd3iKk6YwNNBbjt6Z+wZY2L+37Uq25qE7X8t2zI0+GUgTsI5N5TcYpYsigxnB8JvRmqCQ3CIuraay27qBwCIStv0kqFClPynTV+AjEH178nCAHTyTccf4E+eIQzA5lXYMbaktKwdraoWPwcjA1u2Q7wq1Ux07BGGoA4qCb3+taSF1L09vqKtVlWEHLgqiqz+FlD/+ergbcLDAqETZgyy
 D5by3jBb
 ppo7ki8REC8re7KwrSIiFGt4mVC2BoCtVCaAWPvsVgGv7pzVpH42lrFnRpm3gtbmzfJf6RBHmjhjA43/kmg/ASB6sKpG5q0h2dD1DphC/RpNxhh58A60p9tTwc2NP7o7GueIJwT1yy4vJJbe61mxG7EcXMgOwCcGontgXbBvS7HRl/DdFbBHLW+FUzju4IXd3/jXtlqGPUqWdgQLIvwOcXKUz2oXfjpGZBTbNYeqZg+k2/zfPdf54RdEZxzT1ZT5gOHuCspitZHnW35ZZS1nJDMPQz6aT39cnMCPtruo6QVOtgQJZqenvuNv8/FpOYK2fZhEYx+MugXhKjbAElgXVWXGfgWMNMTkNDeGtH9pqfiIJkr7/r+UfPXmW79cJaHYwMHy5m2BNjklTYTuhugkInF/adky+SevqSrpHJ94gTWnIdpkaRUfK0XXKXcBv4uuCmMBF6NpzrQ4YrxJnaSQdb3f6IdCD1vFPqXSk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Fri, 27 Feb 2026 19:30:04 +0000 you wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> The 'compound_head' field in the 'struct page' encodes whether the page
> is a tail and where to locate the head page. Bit 0 is set if the page is
> a tail, and the remaining bits in the field point to the head page.
> 
> As preparation for changing how the field encodes information about the
> head page, rename the field to 'compound_info'.
> 
> [...]

Here is the summary with links:
  - [PATCHv7,03/18] mm: Rename the 'compound_head' field in the 'struct page' to 'compound_info'
    https://git.kernel.org/riscv/c/d50569612c29

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



