Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3D3FC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 10:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C61DD6B0088; Wed,  8 Jul 2026 06:00:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C38D46B008A; Wed,  8 Jul 2026 06:00:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4F196B008C; Wed,  8 Jul 2026 06:00:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 934546B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 06:00:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 19D681C3D4D
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:00:36 +0000 (UTC)
X-FDA: 84965164872.07.1FA5AEA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 49A10160002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:00:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=K2QzZNWS;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783504834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=ddJSAPVz9NkXc1bzGsPcnDtadMHor6sj1Pq8riASaWE=;
	b=MnAYNdEL+/cZTsl6kqAzHHHbIcZWpkDDDCLh1ky3Oljf2mJS7HgcEiGqTwEsJWGpG2XjcQ
	wgoCTP9aWed+BQLMJ6fUwSUbCoc6Exva9WQOZikIpGJzjjhRIBdQMhyO+rAOn2CgcUOw/w
	oUaJcksQ48kD0caXeDFfNvsp2kuEkxM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=K2QzZNWS;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783504834;
	b=sGRKvT/8ommJsPno07lxXiVGCqObiD6jITnDz3Pct2x/1haYGbPAcV3uVkP0zeut8bf2Yf
	a45/g4mpDoCyM7w4hkyfY2tU0XL7fdfrLRYq5jfImQYD3rpk5FwlwyVs5F4OeEnNyEX19U
	m4A46l04Lv7qdbucAU/+Vv65oxZKYSA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B75871E5E;
	Wed,  8 Jul 2026 03:00:28 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 31A4B3F85F;
	Wed,  8 Jul 2026 03:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783504833; bh=8oFU73UDNb1/JzzX/59Hz8/SUvhrGo6jInm1l2EOvkk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=K2QzZNWS5qvtc90qr2P/bmEBxGozBIkajd4g2BYgXL6Gp07XfQg2fDAaRimBjytR3
	 AnMyVUC1k+1MwDKxSrlcekXCA+Xo6jxwuhPGUKvb9LNjSYAl8jWKoOD6L8rj1fhHUR
	 MBLQpicTg0GtL6aQ3jsYy8mAbKKMKwErUf1HScIM=
Date: Wed, 8 Jul 2026 11:00:27 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Shyam Saini <shyamsaini@linux.microsoft.com>
Cc: Mike Rapoport <rppt@kernel.org>, ardb@kernel.org, david@kernel.org,
	will@kernel.org, linux-arm-kernel@lists.infradead.org,
	akpm@linux-foundation.org, bboscaccy@linux.microsoft.com,
	bp@alien8.de, dapeng1.mi@linux.intel.com, ebiggers@kernel.org,
	elver@google.com, enelsonmoore@gmail.com,
	feng.tang@linux.alibaba.com, gpiccoli@igalia.com, kees@kernel.org,
	kuba@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lirongqing@baidu.com, peterz@infradead.org, rdunlap@infradead.org,
	tgopinath@linux.microsoft.com, tony.luck@intel.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Hanjun Guo <guohanjun@huawei.com>,
	Sudeep Holla <sudeep.holla@kernel.org>
Subject: Re: [RFC v2 PATCH] reserve_mem: add support for static memory
Message-ID: <ak4fu1qINGyAQUEl@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630170911.43521-1-shyamsaini@linux.microsoft.com>
X-Rspamd-Queue-Id: 49A10160002
X-Stat-Signature: ugwfnq7qq883i1ro16j78g8wyjd1izjq
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783504834-887013
X-HE-Meta: U2FsdGVkX1+Xq67m+yfFGUnqccdb55cmgDuJlSorejLAzizKWlmwrdFbAOewzzs+aPDGB9gAkEkTexRrO8021E57iELhVNVbMzaHBUGbGqwsrI9bCkmN8YT2Q2BTESPPwodhusdl7Ghn7eeSUa74+/bsnxp192iU3RcLDQ8yA9KJEMHqr+aKIi2DmoXkT96qzC6bSyr+f+V2xcgGL/ZoOKqsD+HWuEujVZR2ElNtbH2uIhQnb7BoBpfJimOYFj6oOUktQMZBWd5FTz1OG17BUGrg9t/43v8xj6Y3J7JspT8mfS67U3jh0lUt/NTiwjWX9EV5B3YYnn5tuwSgxt0F3p+VDHG15IafpyTK1H9XEpQoxjKropfOeDLaqeZVChbjjq11p3rNYdzulNcNw1sVeM9edHczs8i2krHpk1TQcNou0p/LXXtip22cm0P7lbkxX7v2UP0M+wFhHfR9ZWmKerez+twTpMNced1uqa2QKMVRj2htwIomWM9v+fckiAeT+5DF8vWf2dQZ5D7dt+VGx6zMw8diqbIs+NInAAsEPoRTVNwwKeW6OrCOkEMaw+aPWpyvupZHxbl2Zxtvr0CyKdy4JgLN7QJ0l+5z0AH5tFkmFgz4rYmbBoUK+nj5wsib7N4Cqx1Hmbr/0nxcywEJsFDIPGRiWhtl7Rc1JSfKpGgwf6NfQigPQS4bOtdIFZsOR2Y5yCf8VNid56RxJG3fmFBk+EFIyDcTuMYPN4ALAjAcp3BEdBHEpGVxDxtzL/4qDjPJJ97w7oezM4vw3p1DxJE/4TTR/qs5gNS3AyfaA4LApKqBAg65Tg1KL/cVxx61cm64Asev9HlBGVA8WniT7kh2xioWwIftxsF3BbiJEfS4hKN850ZpGMrirKB4WT1BJkLhQi/P1Asur35PkIEXQqhk4dAO8K7ohQ9qtAq7Iozrb4N78+YxiBO7pardg+6OIA6f2u9EFar0AJYZaiW
 ycBMcS8k
 /cK08w1o5/WJz1FNDRgZpo4qK+hL203ck/+Ww6whnOYgS41Irl1hyIndH77J0wrushStQWWUN/pLXT0SD2ni/T4QU6eGvnIQRNf/B7ilVNm88E43RTZnOt4DoHXLwdZOSEW9I5NKhWXnUfWdiN3E3w1KfiyTnPz6vgCRulzef5ShELbVKn2K8s2r7acm4Mg6fga8suVSzxMrJsJdI5AvJuPiW5DLUyeJzJ9/D2lbY0HUY7734ldq8OsKWEU9mRYYPuaO3ZXHVLY1VtJRdwy0BWhei9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Shyam,

Adding Lorenzo, Hanjun, Sudeep.

On Tue, Jun 30, 2026 at 10:09:11AM -0700, Shyam Saini wrote:
> Following up on this, As Mike pointed that reserve_mem is best effort
> reservation mechanism, so what is the recommended reliable Linux
> mechanism, if any, to reserve a predetermined memory range during
> early boot on ARM64/ACPI platforms for warm boot scenarios? KHO is
> one option, but I'm specifically looking for a solution that preserves
> the region across warm reboots.

If you need ramoops-like support, I think ACPI ERST is a better fit and
we don't need any memory reservation tricks. I'll let the arm ACPI
maintainers comment further.

-- 
Catalin

