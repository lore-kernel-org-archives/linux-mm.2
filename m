Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B492C8303F
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 03:21:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64ACC8E008E; Mon, 25 Aug 2025 23:21:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 622D88E0038; Mon, 25 Aug 2025 23:21:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55F4A8E008E; Mon, 25 Aug 2025 23:21:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 441868E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 23:21:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CB18A160608
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:21:48 +0000 (UTC)
X-FDA: 83817459096.13.CE46B45
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4895E14000B
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:21:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VvH4P9Lp;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756178507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gDWTvF6BmDxoWohIIWxk4CZjLYF0kTQu96WIqr9r/5E=;
	b=R8oMdGJ6YZQngAI8dizTbzbpIed8mcDWH9BclcjcsNXsb0XMHMQuNgiWC657ucudLrxMZD
	BuLvLGDrMoIKLFx6nDmInDyFREIyCj2Lc/8vctjQRvbTJd4iNJtBqh06KriiqyvSgpqmiT
	PeZKkmptSxFKjEIAbhOa5Hnqd920UT0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VvH4P9Lp;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756178507; a=rsa-sha256;
	cv=none;
	b=c0Waq3dwpmTvTkRNMsibowGUqTYMouMXi2fm3iKuaRxJnmX7ACX5gar/oPUPOpMV6GnWy5
	L75PcXaCkgGHJDJZ5UbRaHg6oVazodwUuSAYUlzJAeUlLwaE69hNZnoqUdU3ErQU8+ElrH
	YdjlRtjOS7vOpuYLDBdU8rjD2y4a7q8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 221445C503A;
	Tue, 26 Aug 2025 03:21:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F63C4CEF1;
	Tue, 26 Aug 2025 03:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756178505;
	bh=d34m/47r/gW2GjojamdCWHSBbGXyInVrT1/39iuDcD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VvH4P9LpSYd94n3iE4sPzDcQ5/ChVR4EK/bjjtdwrzaHWi4J0OWSOLZ12n6IUPVf+
	 j8XYw4knhalBrX8elCacnZubPpMrQuQibfMquhN8s9qD3WftFlra71MTDUK70xTVwC
	 5Ka7mG816aYss450yQ8M07tCgQQYm6uQ+saukJ5VeJvbFA2Dk8MBbbjL2Rt53RLbmv
	 zgbrdBq63J3F18MVDABo5G37nCokCCk0+1W8jSjyPsdP7IzTbwYNJ0ihl8JEAxLzDu
	 yIeETEe/GPxsp27ox1QzWXtSMUG8qdE99/wMh4nOxR6d400H7JnQPn73nLYANehgWm
	 4S9fVIJz0rh6g==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com,
	kernel-team@meta.com,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2 03/11] mm/damon/paddr: support addr_unit for DAMOS_PAGEOUT
Date: Mon, 25 Aug 2025 20:21:43 -0700
Message-Id: <20250826032144.49491-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <7de69c95-bbf7-4dd0-91e9-640da8b8cd5c@huawei.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4895E14000B
X-Stat-Signature: 11y693yw6174rochqno77nsdnec89qdk
X-Rspam-User: 
X-HE-Tag: 1756178507-346966
X-HE-Meta: U2FsdGVkX1+OrzLcJYQ675OvU3vzgt5s8MNV0xPzilH7i7Aj1GFployiFibKucV1kPMcc2WbsCZLQexUByynQQ5gYaRBAAhR9+CR9fVU3VG8lpNA8EPPYpTENuBcB/gW/1j/33k6i4zFNhxMX9fSoOBeCDPvijwEHNizAo1ZA/18vZvPbep9nHmAQuojZAu3viuL40uxReynqg8rHXWnINKhM3KSkxVLWQdTw5lxU2oF2f8dzYVusyV2doYefwVBmgKDzMnt5hRBQ9p7+MrV7J0XVirNo/MSEqX/QCk4SATICH5wLXgjK+9NnLRw1NTqLW/AZzCW/84TE2zUPFZJjOp2oBELlnqdgSFazN1MNmoknX8HdAYvfqG9RFlH1RfKipv4hKf0GYSHWf7fGn2/rNnqNYSk/1vVBY1Nw6e/Fbmhh/hDhzNZxigkrBuzcgNlfnTMV2j93aiDL0ju1KbMBsMACrOIfhnfbgAyiL1mxmV1qbeM/KKkzzbMBYq6RON3vHd/ehe+eljWSWOsqgxqmmuv2C4oM5PhomwCyKlOt29viOWbtRai3Qw6ZxyzDcUVF20zxIiE81pCbuLj6NCD8W9Bww3S5KgrgXH68GE6j0GXylDYzK8PTuDSYOZLTE0BjsP9hSXBNZls7e/a0soI6QNrgHP4EYIvGV1PdFKuF4Re/uSVimdzv0lPf4oQP4e1FPHejMVvy3YbVxfLQP445JSCZ3QCfNTY1DikdYCbTM+xUJJ4zrz/2iiKnter2XU5B6KvHAvUVs1YUGIRHfaqWCEhnDfufF8cYX0Y71zMp+fBBqSHqVS6qPWhYppsUB9xMssOPYwUSb6kRnnQTaAWQA2KxRo2yP66Vwjj4FCx0eWoDI5kZfrefwzhtW4YpjJKUOuo0PywVT8j/IAAuOK7s7xhGkOoGHqrKsjrc2qvVQTa1LsWvl527CHmKpo8JwuVGpFws8fc2KEinGB32e6
 H74HxOii
 jkYlW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 26 Aug 2025 11:16:56 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> 
> 在 2025/8/25 23:12, SeongJae Park 写道:
> > On Fri, 22 Aug 2025 17:34:11 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
[...]
> > ==== Attachment 0 (0001-mm-damon-paddr-use-do_div-on-i386-for-damon_pa_pageo.patch) ====
> >  From hackermail Thu Jan  1 00:00:00 1970
> > From: SeongJae Park <sj@kernel.org>
> > To: Andrew Morton <akpm@linux-foundation.org>
> > Cc: SeongJae Park <sj@kernel.org>
> > Cc: damon@lists.linux.dev
> > Cc: kernel-team@meta.com
> > Cc: linux-kernel@vger.kernel.org
> > Cc: linux-mm@kvack.org
> > Date: Mon, 25 Aug 2025 07:41:33 -0700
> > Subject: [PATCH 1/3] mm/damon/paddr: use do_div() on i386 for damon_pa_pageout()
> >           return value
> >
> > Otherwise, __udidi3 linking problem happens on certain configs.
> >
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: https://lore.kernel.org/oe-kbuild-all/202508241831.EKwdwXZL-lkp@intel.com/
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> > ---
> >   mm/damon/paddr.c | 14 +++++++++++++-
> >   1 file changed, 13 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> > index 5fad2f9a99a0..09c87583af6c 100644
> > --- a/mm/damon/paddr.c
> > +++ b/mm/damon/paddr.c
> > @@ -135,6 +135,18 @@ static bool damon_pa_invalid_damos_folio(struct folio *folio, struct damos *s)
> >   	return false;
> >   }
> >   
> > +/* convert physical address to core-layer address */
> > +static unsigned long damon_pa_core_addr(phys_addr_t pa,
> > +		unsigned long addr_unit)
> > +{
> > +#ifdef __i386__
> 
> Can we use the following condition instead?
> 
> #if !defined(CONFIG_64BIT) && defined(CONFIG_PHYS_ADDR_T_64BIT)

To my understanding, this issue happens only on i386, not every 32bit
architectures.  So I think i386 specific condition is better.


Thanks,
SJ

[...]

