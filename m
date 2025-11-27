Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F10F2CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 19:19:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 366736B002D; Thu, 27 Nov 2025 14:19:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3169E6B0095; Thu, 27 Nov 2025 14:19:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22C646B0098; Thu, 27 Nov 2025 14:19:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 155466B002D
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:19:45 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C40A3B7BB5
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 19:19:44 +0000 (UTC)
X-FDA: 84157351488.01.FABCDD3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id A954FC000C
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 19:19:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ElJMCl2O;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764271182; a=rsa-sha256;
	cv=none;
	b=XrQbFrN7LuupSwvElbowbeSaHnFK0WvB+WdTxEyaVDw2eZeGIC9RyCQWgP65b9bGKdCEE9
	OiPf8qj621l//y6TBEGCoswBgHfAERzRIgA4HiSXv1GQRv4Zx1DyDwEQ1mrybIoH7gxCKx
	tyd10wpBZMcVfdWMiLXZuGzxTcAysfc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ElJMCl2O;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764271182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lFl+9yBh6HzJeenYsOozHNbeB1WeA78wq/bgtcQN7n0=;
	b=W5VqArKQWqY92cAFlMij4e1wAkccpn50BJoDXhcPqVAUg9yXKwdrdKX7wRGT7PhgNOpUdT
	Fq2E4+13YVH7s3ioDIsOJAxRIEtfxgLKpmqcI+o1/TA8F5p6LPmtyzIKyE2817aCW2lFuY
	Rrqj749GTzpsyeojzFfU2Xg1GMklA1w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 768B140BF1;
	Thu, 27 Nov 2025 19:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1801BC113D0;
	Thu, 27 Nov 2025 19:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764271181;
	bh=JHUup27yTsZNR/RUWfn/oMkV/KkDpaYB3fWjoRPhd1U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ElJMCl2ON+8u2jbqVFImaNpjKgvwsiEzdmTXkR15Xmg230hLoqmlSHXBv647f6r0W
	 7eCr/h4he7KLgGg4DeCFqFEFGW/wHLzleVbTRopXCWgaAxZjr1FZeUQonCHBMpyBsA
	 Zn+gsWL6Y83Jjo3I8rTGS/kyNSXKBDu5aSdvL4Cg=
Date: Thu, 27 Nov 2025 11:19:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/kfence: add reboot notifier to disable KFENCE on
 shutdown
Message-Id: <20251127111940.8549bd7aa82cfae5e9be1b0e@linux-foundation.org>
In-Reply-To: <nqzny5rxn27exzhfzaaxg4tfbshhmr5aum76ygficd46b54c4r@tqrelxeucsti>
References: <20251126-kfence-v1-1-5a6e1d7c681c@debian.org>
	<20251126101453.3ba9b3184aa6dd3c718287e6@linux-foundation.org>
	<nqzny5rxn27exzhfzaaxg4tfbshhmr5aum76ygficd46b54c4r@tqrelxeucsti>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A954FC000C
X-Stat-Signature: nktipxzyh4smj7f6zx5uahsiyney9by6
X-Rspam-User: 
X-HE-Tag: 1764271182-24974
X-HE-Meta: U2FsdGVkX18U2cSU0saNgS+jEEMbx1ifPZDEWotIsDcR62W31aqywDg0umZL9zPLD944SvOfYBTZlBCoNQFPXrZbN22nkPDSdIpUnKcFJOK4rnYX+CL0LIq03avj/zz74MBfOIzUpDj/7FA/6fxkgYWBoWJe1z9jUL2zYKaPrwVDua+LjT8ulli79a22tAyv68kwUZ2a4NwSCdfOc9RlxJBZdOCz6hz+nHVVAC0AC3IS180oNYn/op/PJAsX+mNPUAzf08dvxbMn/p/Ram/u/v83/y/SEpT5FkOReXKhXeT7cpl29+c8iGpNToA5QbrTYhnjD9xDPUlGti2/+WuHEdrgJTsGO7cRXeVxsx8q/bNCWIG3hdJfj/FQ7oci5dS/y9AsN+Xq9/Ju3vCrCatTGB9hyPofkXDBWvMQrq/ho/l+93zuoPmAiBlT/C1QwZ1zAtf0vOK2BB+uqxVXkA9tKy7018xjUs7tyl7JuwcbKy0GWWIX7grcTYfE0Mi1bksh5AhJt+XCzZJmz+YphLy1SCWJ+Rr1uZ3FVtVJO3PhyOwnCoVAockUr58mJzLXKPJEDZ9ihT9PfdJSj2TliywaElCfq1I7BPHhyiOqju7yBj2Z19xnvWEfCOmCHUBUMQWggtoRlSAx+XSaD6fE3/y7Tb2MeAoCGcqzcjSjVsnvRsKgg+zWSAkXtzNrGyns+Dp+xxm1ybJuzuuZDxCJr98e/3ypqIJPqAuywsX2gCqwX5y8E7CqV5+lbh3jNxt8A+UTvFNc/REiStr0K0dKmqafHm7t1MJ6fUJw1P1ViXV8plEm06UjE8BhRVUB/RI3RunUmtN3BIZeq/rBIMaAK6IHSaoHycUFy2f9H+9T8VAJ9OCw03436e6C8e2usMuteWYmQg2XP2OpyXI0WWDNdnXuwoiJn4yU8VC5sggsjz49WJZLEZruHjiYxdjLL58Pb8pIWNd/9dP1R3FvZL2fg6g
 ANjHF3qk
 xSnE+y2puuyVcm9y0BGp58rzgWBs6Cy6Jgqn/1TOgzgbw7XyZKFkIGKDxxze6vWOABaqytAoRQE+SeLLC2ePLzRhxuq7WWnRnIDDl7hbefgbEA+Dzw1b06Utpy/jA2BfYiz2zIBLWkPuREhW4naXwK7UvjKciRvyAggFI1P1gqnuT+iSO0ZJ3nKuRiFdf0KDeZLje6Et+DSMyDbViABbo4z9DhcgwRGGxw4dT17+A8Z0ZaiUGMOMXf794DukIfCSZr46Kpj+pnvZ/BSEs70kR9u5rnEHSbqVsr5M0SeuEP8M2OH0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 27 Nov 2025 03:12:10 -0800 Breno Leitao <leitao@debian.org> wrote:

> > > This fixes a late kexec CSD lockup[1] when kfence is trying to IPI a CPU
> > > that is busy in a IRQ-disabled context printing characters to the
> > > console.
> > > 
> > > Link: https://lore.kernel.org/all/sqwajvt7utnt463tzxgwu2yctyn5m6bjwrslsnupfexeml6hkd@v6sqmpbu3vvu/ [1]
> > 
> > 6.13 kernels and earlier, so I assume we'll want a cc:stable on this. 
> > And I assume there's really no identifiable Fixes: target.
> 
> This infrastructure showed up when kfence was created, so, a possible
> Fixes: target would point to commit 0ce20dd84089  ("mm: add Kernel
> Electric-Fence infrastructure")

Great, thanks, I added that.

