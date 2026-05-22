Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44724CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 13:04:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34C566B0093; Fri, 22 May 2026 09:04:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D5836B0095; Fri, 22 May 2026 09:04:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EB966B0096; Fri, 22 May 2026 09:04:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 09F7A6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:04:12 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 581971C08BD
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:04:11 +0000 (UTC)
X-FDA: 84795073902.29.1B08689
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9D67D4000C
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:04:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M3xCeJyx;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779455049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O03EFqY40yr84NHmdTZsOIzc8gUdPk222HuMfERftx0=;
	b=D8RyGR2fvZoFJAV1V58GKqG2DnU3ufssL4HCsr6YWAWtCY3FTom7+/SI9eVNIRhLougueW
	AJg5kNuo41XGSxACeRqszk1Cw8yXrdGZAmZN4FDboVcwj11SgM349NS5YKYS8fycmyZEZL
	y611B/F8pNGhkec3Vt9bB5YXENPcJ38=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M3xCeJyx;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779455049; a=rsa-sha256;
	cv=none;
	b=Oh2d3ue0yvziaV5fxDoZSWcgUFKnRDqYcb5DRwO7vG0wC1a4LUs+ojvUy8DaUyCQaP4Kyi
	2u8fDx+V1G2z6Bu+bm6OrFNvOaGl9UC2NSyssIOlErITUMgCdkiZ02b1AlOq2X4LnWsFvR
	IwWMbpHdBtQvEEiITI8jVsVgzpsXAnE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B0B6A42A57;
	Fri, 22 May 2026 13:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905151F000E9;
	Fri, 22 May 2026 13:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779455047;
	bh=O03EFqY40yr84NHmdTZsOIzc8gUdPk222HuMfERftx0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M3xCeJyxC374t2syxCskrtuPvHfNZvR/I4iyLwMEsBtz/zttNVyoZ9ptm2tKNYIxN
	 GR9DbP8QXbXo7LTCARFObUPM+hJIGLuDCJVkzdNURIlY5hiOYGPI1cS69zU39QWf0X
	 LqnOijrOX2t9wtLnJplVBkY4I1RbWGVYH2JdE/X+C79IsPBq4Ruh0pTBOWCLjDl2eA
	 DLXY3SvkoKyAULHBwASeZjoFVEp3N+OIIYY/WGI8h6D92TyDNj8oXnFC21el3csVT1
	 1Pr5Hnsu13Yx4GtRLEbx0LCV0jFweJpYKi1MPv49cMVKNbz0fwrXdlOto5iUrjjCwk
	 vEapF2nyQa4lA==
Date: Fri, 22 May 2026 14:04:02 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: ranxiaokai627@163.com
Cc: akpm@linux-foundation.org, baolin.wang@linux.alibaba.com, 
	hughd@google.com, leitao@debian.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ran.xiaokai@zte.com.cn
Subject: Re: [PATCH v2 1/2] mm: huge_memory: refactor
 thpsize_shmem_enabled_store() with sysfs_match_string()
Message-ID: <ahBQ59peQvHYfAOD@lucifer>
References: <20260518110816.79be9a7c71777c1876b0019d@linux-foundation.org>
 <20260520102922.63737-1-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520102922.63737-1-ranxiaokai627@163.com>
X-Rspamd-Queue-Id: 9D67D4000C
X-Stat-Signature: i99iumg87bxmcat6ztyrm337yaifm7e6
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779455048-707136
X-HE-Meta: U2FsdGVkX1+zxJ29Y5fu9ZCGQYQJvdYk66mDe8RMP/4+wDqC6iKuYA6hH7fBtp6u8qLNZPYt0gsHRbv+77nXLmVwviEtnkM7qmoKWcTHIbabNrj/io8ruyrI+RJE6Csn9SLnJNC/dl3ZDmpUHH35dJFNO6WdG9aiUgdyRlnBbYBpMYL0DDcESlkUy6MEnJgVaeeTIdWaU/P7gmFQZnsxDf52KCVP+otZTNIJQbFEfpA2hSIdyEzN/yB+CCY2SCcjBcEewH/KmvsfxiLwTnSW84Tn6TbRAm0A7TZ29/PZbnly5UIv6ql2/wMqCgeD94WbfGgEP1t0S4x+BS8/1/wGRPFxeA37vYyrYtvBcQL7CY00IxXQorKTgsWqZmX0BgAlXdhZNp5mscLCzKth63Q5Z01w9Of53wbtms3BrdPLV3/CwWhmw0oq5cyx6k6O5UUg5kiMNgrgtUPoMzpiAQBXzvAke6xg1nvwMpIFNIq37o9USWbQ1AmTcOJCpNc+KOXf42u3iV/BXtXSKvj984reZ3b1H4g9HSjW27t+yQ+ocmWfv8oRb0nRu0ELFxfUwNIlGs4cUkfz+GcweHZm4XXgplQulnLTnGwh/W5vNt/LMVgz9YdBh6BnazoHBg9dfWoZfSwuW7+7IqM67ujFBWULvYpAMLwGkr6/7yHoMKfOgIYjeAHpwdDYICDNGWnVwWYJYnRm4kOQtYftBvN3aaJWRxs1W9U68a+JCwm4LYs6Yp+a8gPJfJOu3kixjXMQAYiVKNoVD6ku6FtgDX6dvu439nGv3R11DToRwY2qEH/Y2bfQJYnHygk/Xg1SznkEPOmBifvDmzX6EA12pkpCtEJo/NRMGHOSPOlIvoefrfOLtFI1EyDF20bS6xTIAN93GVknPl35t1TpmBcZ6sbZruFkxB3VC4Uh5ucnlfVGfUeW+Mu5NKAtJ8eZrd4JIlXuZrxpwKIYLJeC2I0avk8nTDf
 GGueaQQa
 XxwnQ6bUpAlNO5p0DkaCDhObDQyEslkHL0tmSvQi42BSk8j0ShzsScBi+e/6PVbtaK0mLOy1XxL1UNWhEY/61Lcc4HL8o32Oi4wamRQ7gaaFX3snsod0EVGW8gcX/gu6xSExOHjCrykDYkUt/OdW/54I5E8lvFLxNcpScmuaH3HdkY4hbUDAlQuAwsxSq7PDNAdqVLkyj3c0CF8ik9K7GdLF02o+iJdVT0Bq9iX+6Cz9yoFf2wric4PdCvo0FWufhkLPFnMYHsnv7kWhUtvuP3X0r8z+bRI2el/T3HqiBOZ8msBzJT7ln8Gej6QPs8HvEQ4iUqycoO4ZVDche8sLCedNPC8fxRP5VJlG0MsQK5Iqo4Jpl+JYQj+X3OHl7oVxH6+NDZWKx+8US2qQRrWV0QAmyMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 10:29:22AM +0000, ranxiaokai627@163.com wrote:
> >On Thu, 14 May 2026 09:26:39 +0000 ranxiaokai627@163.com wrote:
> >
> >> Thanks for the detailed and thoughtful review! I'll fix this as
> >> suggested in the next version.
> >
> >AI review is asking about a couple of atomicity issues - please check it out?
> >	https://sashiko.dev/#/patchset/20260513094508.50888-1-ranxiaokai627@163.com
>
> The huge_shmem_orders_xxx global variables are of type unsigned long,
> which is 32-bit even on 32-bit systems. There is no reason for the
> store in __test_and_set_bit() to be split into two instructions,
> so I do not think this introduces a torn write issue.

Yep agreed, this doesn't look like a real issue.

>
> David also mentioned this optimization here:
> https://lore.kernel.org/all/4f2abf42-983f-4cc2-92f5-c81827e7b7e2@kernel.org/
>

Yup, I think it's fine as is!

Thanks, Lorenzo

