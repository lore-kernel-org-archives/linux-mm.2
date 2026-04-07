Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D13CAEDB7E3
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 09:56:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3376C6B0088; Tue,  7 Apr 2026 05:56:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30F226B0089; Tue,  7 Apr 2026 05:56:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 225626B008A; Tue,  7 Apr 2026 05:56:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 15E856B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 05:56:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B28F0E23A6
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 09:56:26 +0000 (UTC)
X-FDA: 84631304772.16.F2B549D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 247AB140003
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 09:56:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hdhKKYt/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775555785; a=rsa-sha256;
	cv=none;
	b=ADyE8a3lWUMFEuDqJ0HNCDKEMogpNkZpW9z7jtzDSWpgcMb33KdyflODSy2XGumvh7bzch
	BHEI54EL90t+CFRFrrdfPFnOr/MOY9RRM83h6etTpu+e9Df4ugBEQ4C4GBJ+dsfN846sid
	zB0M0ip/xfJyQx5BiS+f18Kru1NWQ/Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hdhKKYt/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775555785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=beBIC3Tv3ETZyBCqe3MuUXtsMzhOPs+pKd8AmVrbSSE=;
	b=zsNzJTIpb0fseb2vMr2Of99C67/T83rYUAt4sAuC3eWvUghthFQ2J4iwlu2xtxn4W4fR/7
	hMjtLjId1c+g67Ji+ba9JqEo9a7XypcioB3PzsimvBNAjueAGWOj9zrFVmIVvq1lTy7NVI
	fdrax22PptCP4/GSqbCsyDyPP6r5G0w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 89F3A600CB;
	Tue,  7 Apr 2026 09:56:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDFBC116C6;
	Tue,  7 Apr 2026 09:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775555784;
	bh=EBvDDpF12kcA81k6wUaXBwL7M//ctd5NjSBhylt38Qw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hdhKKYt/iaxpTvu2bv2rSZrhdMFmEU8UQi8YHN79ERKBXZknv79pb77GuX4nmraoz
	 TZKXoJRaQQKyijGkz1O2EUWzwhmTORN58C4pD2W9kbmHk4O+0Da7L4LIDRu9uW4AFz
	 rAI1izyYf5TYdyfjxvo5+BdbXt9zrmbpZRSywKkC+1C4JMYgn3yb4rPo5GGqf6gKht
	 aIZL9iJXy0YlbzGy7i0jbT8ckbx8NOMQ24iLuTaLVIbKHPtWXa2XWbmBXRkzIAw5Lt
	 glojNen8PXvY7O6x0dd9MDDefYTnz9/mSVq8bYxLcnZ5+XGRZVUpVf6mgoNl3k2nY9
	 2TEXM+ZrFuzjg==
Date: Tue, 7 Apr 2026 10:56:19 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Julian Braha <julianbraha@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, vbabka@kernel.org, 
	hannes@cmpxchg.org, mhocko@suse.com, surenb@google.com, rppt@kernel.org, 
	Liam.Howlett@oracle.com, david@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/thp: dead code cleanup in Kconfig
Message-ID: <adTUrw46a1wP7HeH@lucifer>
References: <20260331070730.33915-1-julianbraha@gmail.com>
 <bfdfdb05-77e2-455d-b68d-9da3fd9d1c0d@lucifer.local>
 <20260331173744.925a6ee6fac299f86a07a7eb@linux-foundation.org>
 <3cf0c280-e5bd-4e5b-884e-6c734619b821@gmail.com>
 <20260405122749.4990dcb538d457769a3276e0@linux-foundation.org>
 <e4ca389c-882e-4757-8bc6-76563f448b14@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4ca389c-882e-4757-8bc6-76563f448b14@gmail.com>
X-Rspamd-Queue-Id: 247AB140003
X-Stat-Signature: yf8s1b7adok8wf3qu89aryagozceonu6
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775555784-15819
X-HE-Meta: U2FsdGVkX1/n5Tcs5ZfHHR9P1pCajU5ShbDOIIB+Oi5R3B7vY8CZ6wNKAHM1oMg1mgX9V4vXrNdafQa+GKIZhPEfFZEV8v9aJt4I47pzASSpZU32i4tCdTozewBt5orwAV2++xL5xQHNunElUt7Cl7YOai9GZR0RC7DuL29v7iQ5M/xsGH3poTAEm/ZQmid/FCAUXXwYMDDaZAQbk3vS6im9bXYZUAdk4KzkD/WMlAeoQSS1L7fEC/HYC53501+6Y5jNIv8DeOFtPprXHoSbPF/lXn7V53J/hwyIi8rkWrnUVOHoUPGJO8Evz+jdBP4AaQ5lv8ofnxK5LboV9APuCCKcipavo4M9NDjszezOzlYAPgICJf+1JNKT4Ou2KsfIxZNExUofuxYwmfdvgke/LVUSFM5lXPajhgoPwTlLsC/PPCJ+YwEgQexGs+9mLZWRlQMDcRVq6Qv0yShTkyK+99tnyVJ6QCcyRWgCekuCb5tMuqeklMov7K8jQVeGlCJqNslA/xvgCZGcZo/+D8fqglLizY97LZyymv4zjvpHs4bC/JmmeQqvAp74kAfeP7GeyAzxRaI+vh529B5fTujy/1T4Fl/ZWxEoj413YwSfFnv7X/vFYLr3jPKW3oYPi8zhnr15vuAW3KflG6cnoyIH526E1h36UOFqhI7Fppj1CRyLrBJ+vKwU2EZOr0Ugjh8Cm2KflJwO32DoBgr8Bw2kUyML5fYweGkraa4x6tOjo50NyKz3Mb7aSotkEu93DETATiY8bPO48/4VuDtEXdtJGJ2g79eCbbAiLt5MG9oCviMbpCZtumIfc+rUvUmBYPnM2rfzoVcXsJzcSCAWdhIYT+5O2QA+B/guGwjJUTqqXQc7rK41VPrMPMxqcuMjBe+K95vxAE+lbjPuue8STI23aSARS6+wWmtQ/GJeM3b+xeZF0mNpAZTVB+2jupMymuNaF0NaNMp2qUEuKoVKL5X
 wR4je/Ae
 pbDAgwFgypacNsEEOJh24gb2JDKpYszFm/lgMH9icoQgd8J41I4yFf5DBlbO2dtm4nAsbJf+3Znlz6Ukba+IavBM8s1MUpYjxUVCi5shcqQyU9NCzgk+i9TkuaOSvhIR14bLskidFbTw/Q4xGZmOPR6iDEPGxmyUOMQuZFJM7Jz1XOwS5vGPlyCrvsFrlyfNqyFbHwp1ua3pDrWu8YUv/zGbZpO2H3F/+N5GhANc4rSK4tTc27/gOSlGOsRh749ZH8IPH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 06, 2026 at 10:14:22PM +0100, Julian Braha wrote:
> > Have you considered adding kconfirm to the tree?  A top-level `make
> kconfirm' should help move things along?

+1 to this!

>
> Actually I would love to move the tool into the tree. I will clean up
> the code a bit and create an RFC soon.

Thanks :)

>
> Best regards,
> Julian Braha

Cheers, Lorenzo

