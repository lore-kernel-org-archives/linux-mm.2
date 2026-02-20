Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58CB9C5CFEB
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 23:28:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A06D6B0005; Fri, 20 Feb 2026 18:28:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 623366B0089; Fri, 20 Feb 2026 18:28:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 525C86B008A; Fri, 20 Feb 2026 18:28:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3EE146B0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 18:28:00 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CD772160397
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 23:27:59 +0000 (UTC)
X-FDA: 84466425078.22.592DA9D
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id DE414C0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 23:27:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="DQCaS+6/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771630078; a=rsa-sha256;
	cv=none;
	b=iCPYVV6IcQDNQS5u/Z62YoRvKdctuL/aBbTq+8hEdO5Iu/T0w9FWIg12Zl2by3ZSoyHfZO
	NHk4dlvW17hyconC/NhptwjFQWpo5wOt6S59Ko2mGpIP84S9RETx/uUW2vB0HjCOYuOlBU
	Ktbgy4GZmhgWiTENb2rg61jyQxbXVoE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="DQCaS+6/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771630078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=30uoeH+AlPDCZ37LMEKC4PrR1UY78Hb2TT9vay3KZ/8=;
	b=Eehn11SGx3hei6vL6o4e/uM3tRFVteZJzZXz9clzDnzwDyMZduAx5jYZ06SdgSG7/E8LQz
	n8JS9yY6+AT62+r1I/sUZ3qC7vblGENiT+VZ8x7DBLtAn80brkyH+YTtbOJHYLnEBKGXNm
	zf0PSg/LLLYdcXxs3DkrCy0LzDBR1E4=
Date: Fri, 20 Feb 2026 15:27:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771630075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=30uoeH+AlPDCZ37LMEKC4PrR1UY78Hb2TT9vay3KZ/8=;
	b=DQCaS+6/TRNwPYaxpUB+jukGRHtrwuC89qQ6d+q5RrmNF6SUeknsJxWBfB5Jwa4wwu/xBa
	lm502pGaTPLJv6A8xbLMlXrHFf7klFS+dTmoRfG8fAlQzdoz/dNluAMgpkzryi3jR8AwCm
	7DxJsoycODfPEpSLlEo1klONvHQ4Pv8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Jisheng Zhang <jszhang@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] arm64: remove HAVE_CMPXCHG_LOCAL
Message-ID: <aZjiHt7h2z3Ye81_@linux.dev>
References: <20260215033944.16374-1-jszhang@kernel.org>
 <aZY30X9bpsV-nPsm@linux.dev>
 <aZf9RsIUh8ARg_RP@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZf9RsIUh8ARg_RP@xhacker>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DE414C0005
X-Stat-Signature: 8g9nz6cbdqm73w4nxajx7hkriycespib
X-HE-Tag: 1771630077-20031
X-HE-Meta: U2FsdGVkX1+O2RVjQbTJ9MjwH0r285+tLiQH8e9OrtDZyFDIAn75+boQogDIynnlx6IW5RmWtoeY/u5cnJBO8cIPhDyskgz3DIda707RHIg8Qy3GTniadYI1lW75nF0bIT4ExUf+IfbXxezCKC7VJTy3UHIszWzI6/sn8E5BXjIvmkvsZEMtpwiyYTa+xfYfT/Rs2DrK+235Y6QLLpJIKytJPYJfiUfZOZR0VwEImbYr4qbhTUxo8C3Tri8f9DatL6JeuKD3OCr46RX55KZ/F6JeMb0cXSFm0LJtL4bQoCgkjIgiJYemLS7hxmrPxmgn8n0I1AgjYOcVVb7nsx4qvZ86FKogrmDtiYozUikRpW6C258OSdSHu+RMvFTAt13PL0DFcVCaPrYPGduHllvhLp8/Y7HRg4tQ1XUnZ+GFkIcdjgXfo6sj+y43v8MZL/6NWt/ygt3RwmJc1s4E+ePd6wFx9OldoOvic0HxT7tuwu7p+drEoXsz4p1g84/W/wlfsEuSrWWfyJ1TYplRhEbl0eJCormz+4eEa6mVRidwCRM1SlqrYw7KL/BQX+rq4sshf8Uen30KkZjqNo0KJZZXDzYZ+4eIc9vx6fn7iq/gDtSfYxmhpBKAVEaBKfjcO017XtO+cYfFJuI0J68WjZoy9EU/Ij90T24/G+GxIrGzgSgD175oWn6b32mA4KF/i2yv5fIAIJMrP9jG7avWRAFzzB/e7ZB2ClQtwbTJTOkPu3VLwYyy8TVGmXUT5U+QCHEvCrZmL2YcT1iYx9MULWAb0h1+YKjz5ErIEkhBBeXyOdheWxLhCeGxdatMLPkkcYVpKzmQnf0zT9gGbtlgAUpKKAuETKUeIH9cwwlUH17K2H73Xj4beYeb7F+Sxv0TgtuZUrQ2ZtV1eAwcw/1PfKhCVfhVNSi3WCPMSI5zBeAlyRp/1uDl1Rohb7967lrgfNxjZZxVJ3SZ3qXJ3g82WWP
 AebnoerD
 4PbMsqB1GRGkdI9DF8v1gBPVXRYQEp4l/mLx9ipKKLSR7vCHRBbIML7hG3skpEo9AULl7GPxnelFAVbZOyWLBgPLBXnkPjbZRdZ9v6aioEUGEEvRL8o67htt7+Wd3hEhT8HBjfRigPXLOK3KqzdoGgTLBgAKoD32xBKD+UCaRPj/4aJDIqI+5me8YD4eKcH5XliBnLZ+eXzMAwEoDCAJYyie2CEeFZrppqDpTNRjWiUU2OVyBk6jVtPngBghn0akcSb+tronKPfmzDmGGN1oASGfqWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 02:20:54PM +0800, Jisheng Zhang wrote:
> On Wed, Feb 18, 2026 at 02:07:57PM -0800, Shakeel Butt wrote:
> > On Sun, Feb 15, 2026 at 11:39:44AM +0800, Jisheng Zhang wrote:
> > > It turns out the generic disable/enable irq this_cpu_cmpxchg
> > > implementation is faster than LL/SC or lse implementation. Remove
> > > HAVE_CMPXCHG_LOCAL for better performance on arm64.
> > > 
> > > Tested on Quad 1.9GHZ CA55 platform:
> > > average mod_node_page_state() cost decreases from 167ns to 103ns
> > > the spawn (30 duration) benchmark in unixbench is improved
> > > from 147494 lps to 150561 lps, improved by 2.1%
> > > 
> > > Tested on Quad 2.1GHZ CA73 platform:
> > > average mod_node_page_state() cost decreases from 113ns to 85ns
> > > the spawn (30 duration) benchmark in unixbench is improved
> > > from 209844 lps to 212581 lps, improved by 1.3%
> > > 
> > > Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> > 
> > Please note that mod_node_page_state() can be called in NMI context and
> > generic disable/enable irq are not safe against NMIs (newer arm arch supports
> > NMI).
> 
> hmm, interesting...
> 
> fgrep HAVE_NMI arch/*/Kconfig
> then
> fgrep HAVE_CMPXCHG_LOCAL arch/*/Kconfig
> 
> shows that only x86, arm64, s390 and loongarch are safe, while arm,
> powerpc and mips enable HAVE_NMI but missing HAVE_CMPXCHG_LOCAL, so
> they rely on generic generic disable/enable irq version, so you imply
> that these three arch are not safe considering mod_node_page_state()
> in NMI context.

Yes it seems like it. For memcg stats, we use ARCH_HAVE_NMI_SAFE_CMPXCHG and
ARCH_HAS_NMI_SAFE_THIS_CPU_OPS config options to correctly handle the updates
from NMI context. Maybe we need something similar for vmstat as well.

So arm, powerpc and mips does not have ARCH_HAS_NMI_SAFE_THIS_CPU_OPS but
powerpc does have ARCH_HAVE_NMI_SAFE_CMPXCHG and arm has
it for CPU_V7, CPU_V7M & CPU_V6K models.

I wonder if we need to add complexity for these archs.

