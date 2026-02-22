Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE31CC636B3
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 19:42:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D81036B0088; Sun, 22 Feb 2026 14:42:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2EB96B0089; Sun, 22 Feb 2026 14:42:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3AC66B008A; Sun, 22 Feb 2026 14:42:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AED076B0088
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 14:42:05 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 28F9A1606EB
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 19:42:05 +0000 (UTC)
X-FDA: 84473113410.15.C9C300A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7AABF40010
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 19:42:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="t1KLx/Nd";
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771789323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/UFAnP9ZBaS7xnkgNUK0vVoqnc19aHstwiQa9i2pzms=;
	b=W78lOw3kfl2dVX+MxaY6HDT2Y4P9tj361K7G/zNqYJs+jB9HW1OgrJBuWPfDTlXk1FdxQr
	toCbKeaJ9QMhdAd/PhnPVahehnjsRi8FAOool2NEHQtOxLlAVbi+h19aMYW/bdG+ki1aoh
	99ymQdwVwWV0qct7n2UzpKBv/mfmLHI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="t1KLx/Nd";
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771789323; a=rsa-sha256;
	cv=none;
	b=Qgek4ub1gHLsZUc2NWl0musGn545FZNJLtktzQ4wyPtYEk0cc5OkyYo2Xk1aLHMmaQUfYi
	Y8kQu5ZCKN6U9hLfQX4CHu8yeEMtaaRspzTQP0Ckgy8IwDGDwpFwFru9F2Puu0pjm0mYmr
	nUPWQaQwQSzLfaAYEFEwC1mfmo/d0fs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CC19F6001D;
	Sun, 22 Feb 2026 19:42:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D40C116D0;
	Sun, 22 Feb 2026 19:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771789322;
	bh=WSWutob4EOAt5DkaggBIrCV8MoWbhp++zfA32xz8roc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=t1KLx/NdrNsWfrGrfuTViwSseXvCj72+/EPMEMP3/KwAxs1cYn9RV823rHFgsBmi5
	 UvvyQ/UGaVRoFpZoVzVZhpfp94aqoQABL4891Q/kvGyYENNSw36h4BjGE2Nd7vzsy2
	 iHpAqjPkGWZyawz7rhr4NREdKl1PlOSMr44ZcnRE=
Date: Sun, 22 Feb 2026 11:42:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 peterz@infradead.org, linux-arch@vger.kernel.org, linux-mm@kvack.org, Qi
 Zheng <qi.zheng@linux.dev>, "David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH] mm/mmu_gather: define RCU version
 tlb_remove_table_one() in CONFIG_MMU_GATHER_RCU_TABLE_FREE
Message-Id: <20260222114201.095379dd766b68dcecbab1c5@linux-foundation.org>
In-Reply-To: <20260222004512.839-1-richard.weiyang@gmail.com>
References: <20260222004512.839-1-richard.weiyang@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: h4gxue13k3zjkferexp1yci7nttg4m7n
X-Rspam-User: 
X-Rspamd-Queue-Id: 7AABF40010
X-Rspamd-Server: rspam01
X-HE-Tag: 1771789323-634792
X-HE-Meta: U2FsdGVkX18MSh6SXvwWhE7BBlR0avHQMmztlX6h+SnRIhRCep/H4s6i66PnmoVUeedUtTvisQCI9piiLybhp2houXGmo6Yg93SlhJHrODnM7w6FIsy2W7+RiS2jxxORIBxewJXAmlSgBwQhuOPgHxMXmC4/QBt88cOSeBqZBRY84lUiNCoz0D0SQQz7pCy8NRhpp+0YXFu9J/CcGacaHkjGWn5Gi4iy+b8+MznxjiSr+KUHYi8bVQVWKVfQks82RnHSaxyVdKLIANjuZd5uQmMpVt/W3XxP2bHzS0KvfvLx8abRNNPVe5q1uYyGEk6Dna97sS8dzi5XNhwkV9l4xfY7xKqO1TsAC8W76QRx+yo31fV0x+R/7deEnKbD0nfAZQFsbDLF/WCX0aoNKqPrXMzGYc4VstFyD7xi9l+IZwnlOLzd88R12NjcwWfEtQoCnCsnHVXXp2a9SxFqcHZOsobisJ1BW7YgOzPVTD0XsSFIWQI3n7bc4GFi/rhThSoeB9FWDcrS7gKMh1HAY0j5GPECEVUYgUjY2ojUwudWs4V8f7j63zPirlu/mM1MC7VwCZKl0CWMXkL1sAl31sXyrF/+yFHIY6B+fsOdXhzTwEakyAcsBaqLrtssrbg+JDm2L5VyEIqIZGj98GBthjU6vahgj6Oxe7OK7QK+IUvwwERErIY+ZU40bEZtpH66v2ES+80y/dyoi/CFQzClmKn7wVV7sBnp5qeIOqgzL21yYq28xp4/pGaMhQzxl/h4do9LIVN+999V6OkNzlwkOuMrV5e2jT2uXRo5jcDA+Ffm6vAScVYjjw7efdyjtNnWe7gC1IypfRlpn+Lf8VmXrJW7YbLHGIr4TOwBdoekNLxbm4QxLXNnY9gBKLauH9TOLr+90nMDI9RCEBoZREKTtNtazakjgp1y2kPIUMYZT8UjAxlahiKHBOvgSooZL0G5l5DoSirGPDr6Nvq4u8r+Ilk
 WNdkxIi0
 J0ydKzq9zf3EeQYETpW+FbI5eUa4b1w346NVvy/19tx9TAwWqr1knMWsbfVW6LCfkgHFToEX50T4aPfQic6J36Zko1wVpp8unjfNPKjJJplLbFKr2AFYpLXb2BkczlZVt39Cc1Eq7illuk6zh3CdrbkIKbXe9PWLksHuUj3KPFyPN2uHj6D5YZPdYfKNYdTuH/OP3IYS0EuiG+0pW5p2tuqw+dSSOxcdOiL/qXqLZyp5WoKOshV+RSo9XU1I+CGBWB2e/V298XCBzKD9vBlo9QvO7FRx2GsdIFXnyhBgLhW1Q7XCzzeKogHCU8hOZ5u+q7tz0a16pvd6UXTGyvL+yTOXNhA47j6OvL/180u+ZoqrzkKexCPPQZhxpU31DbNxhs2Nd+l8d/41CrFo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 22 Feb 2026 00:45:12 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> Before commit 718b13861d22 ("x86: mm: free page table pages by RCU
> instead of semi RCU"), the page table pages will be freed by semi RCU,
> that is:
> 
>   - batch table freeing: asynchronous free by RCU
>   - single table freeing: IPI + synchronous free
> 
> This commit introduce a RCU version for single table freeing to support
> PT_RECLAIM. While it is not necessary to limit the RCU version only in
> CONFIG_PT_RECLAIM. It is reasonable to asynchronous free single table by
> RCU if CONFIG_MMU_GATHER_RCU_TABLE_FREE.
> 
> This patch moves the definition of single table freeing in
> CONFIG_MMU_GATHER_RCU_TABLE_FREE, so we have both RCU version
> batch/single table freeing if CONFIG_MMU_GATHER_RCU_TABLE_FREE.

What are the expected (and measured!) benefits of this?



