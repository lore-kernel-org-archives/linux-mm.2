Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D27CAEDF17E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 17:23:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F9E26B0005; Fri, 13 Feb 2026 12:23:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A74A6B0088; Fri, 13 Feb 2026 12:23:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A9C66B008A; Fri, 13 Feb 2026 12:23:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 19F8A6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 12:23:41 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C29D314050F
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 17:23:40 +0000 (UTC)
X-FDA: 84440105400.25.F350073
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 07EC040008
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 17:23:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ES8WK39v;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771003419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wNl7dpTWRVmeABtEaOgG5j6kz78db6OCbD9diNRw44E=;
	b=SIZ0s3SgMBNkgDsteh8eRrWoaWbY5hKjrkB+v1LTeSkz6NU24MYLG7NhDyTOQrQ2ccNCnR
	Ov+IZ54rc/Fs/xTRWYzgfoQffH95fZnIZdqNVWknoq2w3rc53Cq6uo7WyhUGxd3Y7g/D/x
	z7yywn5sLHcVOF2NUAdlhyMDYLbQUtA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ES8WK39v;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771003419; a=rsa-sha256;
	cv=none;
	b=b5tvYn60Kel6hgrZgoTPJismLSE+SXbVcjRisK23Y1GYUmVmM6TWIa40SJcxp5VmP8BkzY
	T+R0xtQNRbD//Hm6oLoW7YZG1ijhJRHPIJhfXKA+F9gRheLHV3nVBaPg9vqYkzrJkbk4G4
	UIRil9sLCm973xNfczEX2eQfcDy90h0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 07AA140D6B;
	Fri, 13 Feb 2026 17:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D530C2BC9E;
	Fri, 13 Feb 2026 17:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771003417;
	bh=GOkUPZVXOwDq9FSpdZJkLdBr0dSwWUaE8V8I4dJqcUE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ES8WK39vvoGESzTed4NVICd3ff7Wwz7GjtVdhcPiai0qa4UMnAytDMt5C+ZU9g0b2
	 Ggvq8RvYnrZLXFsTGMQZtMAQhMnQ1gSAVsCfjAMJbOM1fLA+aZ5WyZ2Kl8UrMZK4cI
	 /Zkair0tOk3/fRPChmrAn/LZZojJCAS0QG1v3rjs=
Date: Fri, 13 Feb 2026 09:23:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Arnd Bergmann" <arnd@kernel.org>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Axel Rasmussen" <axelrasmussen@google.com>,
 "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>, "Michal Hocko"
 <mhocko@kernel.org>, "Qi Zheng" <zhengqi.arch@bytedance.com>,
 "Shakeel Butt" <shakeel.butt@linux.dev>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Kairui Song" <kasong@tencent.com>,
 "Davidlohr Bueso" <dave@stgolabs.net>, "Koichiro Den"
 <koichiro.den@canonical.com>, "Jiayuan Chen" <jiayuan.chen@shopee.com>,
 "Bertrand Wlodarczyk" <bertrand.wlodarczyk@intel.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: avoid false-positive -Wuninitialized warning
Message-Id: <20260213092336.c2b0f2d1be17f1e2e9856f11@linux-foundation.org>
In-Reply-To: <b8f5244e-4ad8-4499-9cc4-c875121cdc2f@app.fastmail.com>
References: <20260213123902.3466040-1-arnd@kernel.org>
	<20260213085842.0654f70a73ec05d88908ec25@linux-foundation.org>
	<b8f5244e-4ad8-4499-9cc4-c875121cdc2f@app.fastmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: bf1z13pkiomm8hqb854prmc3pcwfwo7a
X-Rspamd-Queue-Id: 07EC040008
X-Rspam-User: 
X-HE-Tag: 1771003418-667748
X-HE-Meta: U2FsdGVkX18NmVdAQqW6ckJbFeEoY2FZY374lV4xZH0hlbyvu3Suqdai0eTBuP5EE0UZpPrUBstOHN7yMLKRELohL/ZF5xaY+l9rpR/alxhHOLoKoUKfImaSihkZ9hwUqzhL30Cgu5n2eryNiAU+9XG8sCl3p1OfCCuKR6yh3/zYBCYumHlDwHvVI0yR4X8jsuxwpOTD0RvDaqaQkM0FnSayTtLMcih8kpRQCqEdCEvoICR9zwuYJUxRN7ow9VKshOKHtwrz1ZBY8sGZ46xQkSgXwBhuwxUpZtOhHYuHf9Lemlw5gFvZTuefDkXGv9L+2xInwn9UpAEEBRKy7d8vY8pTGmF06S9QMOXx7LQSJL67aAOVhcUiOJ1qdBEPqlJXfQ8gCuqsotUxFdA7MK1PtlCvrz4Ck3EqjpzGkOLfvNSdzqw2nvGiMHhQy3jEo4tdWsKW/KYT+yRst2vynajysmIq3eYLtjyqaIkrAbqQ8xbDRf99j1tqXxHiO+boZngeJCYBbcXe7XBAkQlVydN6W84YjRIuY49HEBOcxgSYIxbOPd1J2tR0CExg0xdsAoYXvaZcpJ2l2ugP3bThJ+dH8B4/9qPLMOtvoWC632gHvgZdt61i+ETnypcX7bDgliOY4ywUaVtgBCYLVvKfKTA128O6wlgjuM5n/JVdiNQwxXRcMz9t/yH+3elr4XMJiXHhy74SSNAb3vOyjulFeSrrxu6M/KjAmTAjV3yNEJ4lW8kewtWNwKNqI3p3Xx6HtfsUYzUJUZOAMztXViLhd3zTyQv3hQ0QqHj496f6ifP5FEuAXzjakk36wByydC/0VnDHLBmXppbrffuTo+So20W1usr7DHcCAxWT/sR6n82iGthKG66LaUpMolCsPbWgl8xf9wAVVtuTjGXIt++uPGuT8HKzfWkCzDBlECaEc3ZDg1AZ8D2VvdD/PY8JYZuZifLbw91nA99GCnpiuXMkU7S
 bxu8Jr8Y
 9nGWRcWy+dviFF17vDRCbOI2sGSG6lUto8pmQM+NeKvYBgUbahi4QqXIrnaykZXyiziiq8HbwDjrkhnlzX95MUMJpMj/iRxOAVMW+nBh3ox/iKI+yAkybgENDtLbtii9cdIpucuD1z/NX8pugOmsIInV/IhEBh2YaHrlna0TJHaj7n41bkxWXShA32ektL1QGBK/PGFqQU6CBrg5pVP0rF4FeojWH9kiTod0A214RR4BBIm54oAFoVT2GYMraTweboVIl3J5MEJjP9evkBMONfJdFiA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Feb 2026 18:07:04 +0100 "Arnd Bergmann" <arnd@arndb.de> wrote:

> On Fri, Feb 13, 2026, at 17:58, Andrew Morton wrote:
> > On Fri, 13 Feb 2026 13:38:56 +0100 Arnd Bergmann <arnd@kernel.org> wrote:
> >
> >> From: Arnd Bergmann <arnd@arndb.de>
> >> 
> >> When the -fsanitize=bounds sanitizer is enabled,
> >
> > Is this an option in current kernels?
> 
> Yes, this is CONFIG_UBSAN_ARRAY_BOUNDS. The actual warning
> only shows up in some configurations with that, so either there
> is some other dependency, or an element of chance based on gcc
> optimizations.

OK, I'll put a cc:stable on this, as people will want to compile older
kernels with gcc-16.

Aiming for upstreaming into 7.1-rc1 unless it's more urgent than I
think.

> > Seems a large change just to squish a compiler warning.  People might
> > prefer a simple 
> >
> > -	struct ctrl_pos sp, pv;
> > +	struct ctrl_pos sp, pv = {};
> 
> Right, that would clearly also shut up the warning.
> 
> To me this seems less intuitive without an extra comment,
> since read_ctrl_pos() is meant to initialize the entire
> struct, but please pick whichever you find most readable
> here.

Let's see what the MGLRU maintainers have to say.

