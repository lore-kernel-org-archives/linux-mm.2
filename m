Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91A5DE63FEA
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 20:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA5246B0088; Sat,  4 Apr 2026 16:30:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B568D6B0089; Sat,  4 Apr 2026 16:30:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6C846B008A; Sat,  4 Apr 2026 16:30:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 98D8B6B0088
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 16:30:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 27BC21B8B96
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 20:30:51 +0000 (UTC)
X-FDA: 84622017102.01.EBEB849
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 51FDD1A0007
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 20:30:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XyCj31tI;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775334649; a=rsa-sha256;
	cv=none;
	b=S5APMFTv8FAaWkjcEpJh3l/6STqG7y2Y3WVRaZJlBIZbSVWeb3L4PjGBcQSHBpMYMxYs80
	h5ex4tZ/vFEgoU85TDIdutPRYfNXT6tZyFzf6u4R8qNsLueOO6dPRmcjU8AS/ZV9zttZ+9
	FXxJvZq4osVHDVw49ldvfiIT73F7ltA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775334649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5sW1dSERzOWcRphiHoPGWOIs6s+M/xXjhSO4m7qejjo=;
	b=cerqEZT7e0qK6unXz53nupxFYmXczhnP2Ps5jdh2Jvk520cGEcxY7DEcIMaMn/4VhpEHan
	1OgJEuvEgb8obO7T30xZu06wJn19T6rF2WCvx3XUtIuVT/afhExfMo95/gCkDvpzpM8bbP
	5ms2u/O9CnRlnQBP+z9gMGi4aTz/Hhk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XyCj31tI;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 287E5416E0;
	Sat,  4 Apr 2026 20:30:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18E8C19421;
	Sat,  4 Apr 2026 20:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775334648;
	bh=eyo7n4gEymA/anCOsd3jdjhMzGS2OqiPLSgYmJnzpss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XyCj31tIAacXS19WGcdqw44RoN76uMuppNOsyscTfV4QRF2xieP4DTjIOPVmlrSAH
	 WkHplbMoOZP7cBGzgouaWtjmPQ1PVvQ/ubOYyhfayJH4/d0Ufp9YvoRtsgTmOFcaNe
	 6Kr43RvwqcZKeDGCoN7aDCwgdizJXHtjyUK5Eu8/hVE9yFRS1QO9iXhfwTqwIrv2AL
	 mpAZtSIbxduxR/xB7uiMA8TJV4xPZX3DcAg74DpXXIz1WccJGPpTViT2fHpuHwUhfN
	 vZKtrv0YJwnVQzVjFluTO1jNEmZCLSvkmymRDXpUY9r8+8RT11ef+rWeJcI1uW+28W
	 wvXutwVHglfIw==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 1/2] mm/damon/lru_sort: validate min_region_size to be power of 2
Date: Sat,  4 Apr 2026 13:30:43 -0700
Message-ID: <20260404203044.86655-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260404091122.6255-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 51FDD1A0007
X-Stat-Signature: xhdgojeeadmsjcom94d39o7x1s7tnnzj
X-HE-Tag: 1775334649-63048
X-HE-Meta: U2FsdGVkX18ieu8OxvqpRH/ZwJpT7/XG9dRmPmG+cDvrCBrkZGe9CAXZzB0WMxd/tUD2eGh7yUDuBy28mxPMcbWbEWxE0AgHHk7tzZKxExDiOxixMSnkNtCHkey91BabMPDvnKGRvTfwBSyE3NQGZUFabnMmK4U3iBO1JkIqCwER8m/vd7w+n5yHVHX8K0cv8UKWQmug07b/XJt4hwH/mHlDNVMnYcjXPjzAsIPQQChwqCXWDX/0jItlmKZOHI7hcZzIf97iVP5h8SV5yFVaMqqxbuL4V4OfxD8Im8wZurxF/qP5drCfFfQVsob8ygyJcGfHZ8pJoyIZTALNSYRbS5paVZD1UtoZpMtYUHNhJkNz53hixrF0o8g7pOPbG+FzsGWYICpwihqE/8G5kXEGk/9iU86Kvn+x81hgOlKw4d/Oiax1XTsdbuEnrErY1nbQXiuwD/yWa8rRkhplNopnC8b8EN5eVddR1DNkPTRSHDUej/zMm9DejYd9CdFBPgNw7XIHeCGFFEtpP03nzS/gSXMDonayU/5YU86XgD1dpG32FihZrBTn+LfdyFqaMfzj6JMVJE1w5GCEUXWKU7afM2spN6fGGQ+1EGWnq7l7DYyq1xtiJrKi3QOKlMuiWQcJPoukBwHreKa+uZ0DJW6Lu/sgZwjacBa8ldXTTOQ2tbmXpD58m4G/yoNE/nKOSbZtZpRRWOH5lrSv8klXOolJRafWOjqt6efN0My6ZaMn/9JsIo+UcH7F6nzjnYopLrL2UzcM/XpEONZOrXRkXkcmEDoOehFfCDbKtE9Mgkm1LwADPdyt0Ii8iX/te9keVTfXuIZiravw2jAfN7BE1fIo4mHfbOmTp237BmeR3jEZ6UsfMFy+6t8EOfz2yBWiN24C9d+wSbPKPRRrqFNeMPPYXYK4rbaOcHMvnwKdiqdxU7ov80hvz8SxX6zYr01E0/Q/7MZmEzZ/Nix5W1vCvci
 OdWw0qs4
 AFqT2kDXcDfW33SsC06DX5N9Czl9srV7gU8+1BQ3nOrfNtzqdAq5JLgUkKixMkh/zyHGqKoX8QZCdMaJ7XV3dzn4cAlNaz7h+JgcAe3RLBHmgF+uAuWsk5aM0SHDR7EfwFuoiX6RZ1Xok0Afc3TEaLihXK8JeWieRGzSRfpWefOq2xRzcGz9ekNZvC+VeE/pAXPW2ColcLRfFnDaM6EP1ORVB7kBPBoBcdJkV4OHW+vNUjF/XaA6W8b05+6TPLZCFhw+C8dPOBBuCfTo27teZty/+IHV5bv6qbyZ5otht60tMpq0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  4 Apr 2026 17:11:22 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi SeongJae,
> 
> On Fri,  3 Apr 2026 09:19:06 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > As Quanmin also asked, clarifying the unexpected termination would be nice.
> 
> I will clarify "unexpected termination" in v4's commit message:
> 
>     "Unexpectedly" here means the kdamond terminates without the user
>     requesting it (e.g., not by wrtting "N" to 'enabled').
> 
> > I remember I suggested adding stable@, but only if you think it deserve.  I'm
> > now not very sure if this deserves Cc-ing stable@.  As I mentioned before,
> 
> I think this deserves Cc stable@ because:
> - The issue can be triggered by accidental user misconfiguration
> - It causes kdamond termination and hard to recover/restart. Once
>   triggered, kdamond remains in an unusable state, and I have not found
>   a way to recover/restart it through the sysfs interface without a
>   system reboot.
> - The fix is small and low-risk
> - It improves user experience on stable kernels

Thank you for elaborating this.  I now think this deserves Cc-ing stable@.
Let's make sure the user impact is clearly documented on the commit message.
Also, the code change itself and the current commit message is not clearly
explaining how the real problem (DAMON cannot be restarted) can happen.  Please
add the description in the next revision.

> 
> But I'm open to dropping it if you think otherwise.
> 
> > there are multiple patches to review in parallel (you are also having such
> > multiple patches in the queue).  Please don't expect I will follow full
> > contexts especially when a single person posting multiple patches in parallel
> > every day or two, and bear in mind with me.
> > 
> > Sorry about the limited bandwidth from my side.  You could also simply slow
> > down your pace, though.
> 
> I will try to adjust my pace. I've also noticed that the quality of my
> recent replies/patches hasn't been ideal, and I will try to be less
> rushed in the future. Thank you for your understanding and suggestion.

Sounds good :)

> 
> > For stable@ Cc-ing patches, more clearly describing the user impact would be
> > nice, and helpful for judging if it deserves that.  Could you please elaborate?
> 
> I will add a "User Impact" section in v4's commit message:

Yes, please add this kind of message that make clear what is the user impact.

> 
>     User Impact
>     ===========
>     Currently, if a user commit an invalid 'addr_unit', kdamond may
>     terminate abruptly. Once terminated, it cannot be easily restarted
>     via sysfs, pontentially requiring a system reboot to restore DAMON
>     functionality. This patch prevent such termination by validating
>     parameters (addr_unit and min_region_sz) early.

You mentioned it cannot be restarted above.  The above message sounds like
there is a way to restart it via sysfs, though it is not easy.  Please make it
clear and consistent.  As I also requested above, please add the internal
mechanism of how that makes restart unable.  This itself doesn't explain it.


Thanks,
SJ

[...]

