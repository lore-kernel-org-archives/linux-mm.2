Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 724DCFF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 03:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8EC06B00B5; Wed, 29 Apr 2026 23:26:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D66AA6B00B7; Wed, 29 Apr 2026 23:26:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7E546B00B8; Wed, 29 Apr 2026 23:26:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A3CC16B00B5
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:26:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B52A402B6
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:44 +0000 (UTC)
X-FDA: 84713785128.14.ACDB323
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id D0046A0002
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EeR+2fmK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777519602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nptF5hZgW1FffxgE36jNhmQlvtyzpl/7gCc4KELiWzQ=;
	b=Cg142QrxneLFz3Tgnm/kWEJJKKKMETzV8/8e/lqInRYvsOut9wQXmRRLZbLs3hytwjtHNp
	Fqj51TYf8383XFv8kwGA3lpxcfP2fdk9/EDTYo0q/GzQZkpT/gxI482o/DILrkFlhl1E6f
	xydFKGzFSqs+nP0HSr1TXd+RAP5PpQc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777519602; a=rsa-sha256;
	cv=none;
	b=RSKMV9+sfNLnuaa9YjJRzVETjCDz2C1aJaGmUWXavCWmhP0gL1lu0j77OB4oO+T9QbhdU3
	phhEwFInSU++kBNM+HSA9NHAvoAJRyTB+eOr6Zr2NJcbjbDxYSVdN3lyyNyHont4JKwVpi
	rXGCuGQuxBEJxxotntgHeTIT9EbWS7Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EeR+2fmK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 55CF461331;
	Thu, 30 Apr 2026 03:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0920CC2BCC4;
	Thu, 30 Apr 2026 03:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777519602;
	bh=jOQ6F/qbqPQvr86AWUfO60sG0ahit7mDPYuhhIPcxY8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=EeR+2fmKlkkC3zXJwh38hlAoE2ur0kbazDdCl1B0MzT/OzLC7NC+ZFsu3TPGh+796
	 1/Fwn9HhrPzwpstx5GId8w3mBHNX+inZaFjWNZCcKAt3Hx5c7c9X6uhDHJ7nHFEuTH
	 Mr3HXQraGn7ohoz860VHeqXMnOfcBHYMb4T4DMOb4BFIN5FcUNgi39M2UCuTGwL7hT
	 In6FDxyUbEFipwzNGL+OYqMERE9GjsYnTUp2l1+SjCm14W/kgT4XbCAnl39BDschFA
	 SmzEX01qhFEt2udL9WTiIjiVW38Jch76j0dr7SJpWdZA6RjuNd5fQQuQw3af4SB2gc
	 gWvic7yeoMu2Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7CD553809A07;
	Thu, 30 Apr 2026 03:25:57 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv7 08/18] mm/sparse: Check memmap alignment for
 compound_info_has_mask()
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177751955604.2274119.1021480725497900179.git-patchwork-notify@kernel.org>
Date: Thu, 30 Apr 2026 03:25:56 +0000
References: <20260227193030.272078-8-kas@kernel.org>
In-Reply-To: <20260227193030.272078-8-kas@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: D0046A0002
X-Rspamd-Server: rspam04
X-Stat-Signature: iisjg5mkw6uy56w44h9y1cfnsqtnffst
X-HE-Tag: 1777519602-259309
X-HE-Meta: U2FsdGVkX1+mNkD1JtJFJSxlSctr6hYC1+5L+0NWh47P7ZzSR+1e7pOxrXPdCBwFROs3+vygtKizIkH4lWD5+em0n/PalPMyLp/QHhGuxfEEcBXi5wb1CfnZlaqSLwAcqRXY5UE7HQfLMdKnl/RUPDrW8n4yIkWn47VgFKBVNJMWEBhESuGBpTFxCLJmk4bmYrChgqQZPvrMNkqC3jcroUmTnJzFNLXtsWYs45ObJpJvzFf3myaSTlDiQvL+p1xAbz23ylD7OVItBwdlHy8hNzUBPItHgAJj1LDATHoN9QAFOA5Z919Tk3Y+yjlAaBm+jPz7owCd+XgW2vRuj0yZZR9RQau7CDlciG/gOGW21mwI2Dkou7B2rrfyzm8HQMi7XbGiLOA0VJLq2usQR0/en1OZUQKGafPGd4W2vSbAn/0z0cda6l2mcy4Y9ajqzCwqSxRJX5T52Lb+ju+os5PuyOeWFx3HVVh+ACyAkBLa9W8EKMnPyMWmimKKTHQAy7/61lB264GDx/QvMc/R9ERkAW9TDyMNyaDzzpVsvS6m+sAbHn+weAhbb00SCgEY9A+wkwfoOkK4WERKk2KSsOxSNQlT/k8GMYku04jLyPJ0oemM0SZpO7oYesOYs8f6xLrMxcypu5R0CbPLktRP5RC5btxrVpAFJsF8jUbGhZH9a0HH76woxp4jGtmsxv4S/w3J7A2IcB7murLCEsHIkzAcdNgMIVD5O4tmiCq2F9x6nhLwD2p/SedbFdDpwZHwQOGHebccGXKJWMY2SAm+XMLRb5G5+wAJv2u9YMbuzLkSlC6WMJs3QQKmmThfmenYQt3rVwQEwi0tTWzdC1fVBMsfiE1mqxaww+KMP10G7ZGTOYfefMrIWm2r7agRN/lvigHyvnO2W9Lnm0WqagZPqtnPscFOtp6Pf9l8duR0K8ERxmVU2P8txqZcfKpvAkUaggYKPvcuZbI90gHKZS5eUsR
 06bCXNUa
 e8f7QPeUn7YCQPeuseTHMwTJaylgqj6aJbuKK1nwznMGUEj3KqP/ruHi7i9zvKnRuTg5l6TSJaOIwVo8yRO7eR7jx6y/6FfYaZhAfaqiz/RSmGDd0fbGRIhU55Ialv4ZEs3lOaxsUDX+w+YYTMk6tL4pqUOC05GeM/IyLD0il4hhdVbk8xqAx7Hc2PKDXWO6Ji9Nw1AA4rdt7hsj3J9ioB7pv516L3ZR80d+IydrXq3hqkWXKR3UsQTcrsRXeVicn/nTRhl3zgBJ3FEcBh61olUWKfh2YfCwxCUoWDPwPqJFF3/btBcuZ3CyY8iFl9X+fch4H7dpZgXbJjzuWeSxPbiOniEX515riVn1ZC6K27jS0suBhlfBR4tyYhCMDk6nCWsf4rVCEJtsiBGI01cjfLbJDbZ1BEpARoMMOrXrqxU9SmhHBll9LYYjf9rv+YgwuMLEduh2i5wXqRNEOur4fbN/9IuCobFN061s/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Fri, 27 Feb 2026 19:30:09 +0000 you wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> If page->compound_info encodes a mask, it is expected that vmemmap to be
> naturally aligned to the maximum folio size.
> 
> Add a VM_WARN_ON_ONCE() to check the alignment.
> 
> [...]

Here is the summary with links:
  - [PATCHv7,08/18] mm/sparse: Check memmap alignment for compound_info_has_mask()
    https://git.kernel.org/riscv/c/9f94db4c7eaa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



