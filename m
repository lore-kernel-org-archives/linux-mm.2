Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F28AACD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:50:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC9FB6B0005; Thu, 28 May 2026 05:50:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C79D16B0088; Thu, 28 May 2026 05:50:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8F8C6B008A; Thu, 28 May 2026 05:50:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A69DE6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:50:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3E8721A07DC
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:50:00 +0000 (UTC)
X-FDA: 84816357360.29.1C25811
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id A684E4000C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:49:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hTggJ2xA;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779961798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NFfgee4KJN7CaFHQFyefaFVIdlWaWFayLfKlgnxXDKg=;
	b=rIRQ06yVzsjz9yvuQvV8OcdtXaQQ7a+O/PXgtjwEc1052ZOtnEa6vWXjGZoABCoaoZrL4e
	Ai3U2NZ0KZmvyDdJFcijFvz1TGSZL5xA4quSmWXCJEYsd/73ZFKNJO4V9SCR/pKD/JYIEo
	tUByDFMgpx3DYIWlqR/xw7BzuM4DYUU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hTggJ2xA;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779961798; a=rsa-sha256;
	cv=none;
	b=ok9j27oAWpFPT0FJM0YYjwJSOa+ZZxfnCGdZK5uTu/GGygue8rjRCCB8x/vurBDFqRdyye
	xfM9eU6hsUUswQXPVHbHKZqHOIJxNXbJPo8N4vto6jizCecqKGEiDsUtVBOqwzQTZ82TJf
	cXQKYGC9aKsoJgd6ko6BYBaLrKdi2Lo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0BF2F605A8;
	Thu, 28 May 2026 09:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95CBA1F000E9;
	Thu, 28 May 2026 09:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779961797;
	bh=NFfgee4KJN7CaFHQFyefaFVIdlWaWFayLfKlgnxXDKg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hTggJ2xA9vUCE88ZExAMAIk2r9IAq4H8LLgE0KyTsqkpBHLyQXgylvOniRKr9fnqW
	 bgGOCN5FByHNGnh4uJz9Apen59PIy0pKbhgZnfOuPJPd4j7SoF9k5Sj6K6Vo3WPptJ
	 LvUbVDUu5LclcAUrWxBppzcxqsweJKpPs7lr6hlqO39zMgRaX4twvQ22BiPl1YoFsN
	 82MAOrGfV4/LYZ2/IaRl9wrbRGawsKMj+lDUioHFc1hrQYU+Ru60wafkTGStT+0w+l
	 5dGjiKV9yeX0ECDGoPGifn8AObraKM5k2XqKj54e3r4d1uItE+U/4IKGQQj3wUQD6S
	 lE1iS6pk1XcEQ==
Date: Thu, 28 May 2026 12:49:51 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Laight <david.laight.linux@gmail.com>,
	Li Nan <linan122@huawei.com>, Song Liu <song@kernel.org>,
	Xiao Ni <xiao@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH v3 1/2] xor: use kmalloc() in calibrate_xor_blocks()
Message-ID: <ahgPv4DoUlZOQQLD@kernel.org>
References: <20260528-lib-v3-0-feccddf1cb6d@kernel.org>
 <20260528-lib-v3-1-feccddf1cb6d@kernel.org>
 <ahgC1PDFtFrJrsKC@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahgC1PDFtFrJrsKC@infradead.org>
X-Stat-Signature: zkpxogwiuuqycy9bunzj1nmcwgmmfagq
X-Rspamd-Queue-Id: A684E4000C
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779961798-807076
X-HE-Meta: U2FsdGVkX1+lUwaH76JlYEk0IGIKsI3p8E6MPkr6Lstxv8ye7Wigv9TH0163Xl4Dp8FVf3zO5KPXi2r+RazdgAucOGQEpChhygw1gdOd3jQmkwO11NRqJghdB6DR8aCk5lBIe+Rkiccsx3OnuYAQ3EoC1s+Bx70haKBzWQYBTYGiIFLMbLVXtocaoi19Nek+sb9Uw6P6w92B26PRD31XP3iVnDSZsFpvE4dvrdotZccajsX98vyR/O7C9XXmdNA7FZJakwITWSqpxnGEAHR/9WbcnZ4Ezef9JBRltdrqZ5dVsywS1HNqVObEJMmMSHM4baCyVIuFVQ5i+P+9f313+KDSC6NoL07eh81T4XT0twaNgQuduOC0w3laXXnYkATFsalujM3OZfsm8uVQbLb6pFgebjfEWs6QwmpfhrMktiZ7SV+aElcZHvYCPLTUbm+m/kqh/hhW18LtESoElNOyBllr1BuBd4dnb9C+H+psR+j73Q/TGANza1JDH2twHg83cYUDFnmA6LKnlZxbXf98PRVtKhJj4COZelM4xsvXG7HR7ASc+riQxbNlMzbbHYzJl7ow1RMSpQ+DShiTgnXgZ3CEcDPWcC+HDXx2ZrV7l8iZ6l1ZocU3hKXQjTwGSKma0joXxhSP027iEImgbMWVJReArLjRR0Wrs0LeAd/b2jEuaBS/Jxa6/DLzYG+xYDRGioJ+fDcTHWCRg6FDOSzsB8rV4sUv5SvuSmHiJytnf8yVM5poAyuR+8M/D7WkuhqyETbk1ONzFoXxBuMZD2iwvbVAJj7JrUFj+buXBGw9J8EEhuPnghrRNLwSOdTyjtZVcA2IJmndgdyFXxEecdujTmsW2sUSl4hxN/agt+XA+OVPuVDkr1Tt+/QWIKsUOJrMK9B2FhSLVRR/PXiFNJmw1OxnX2uy/JpP+2E5PLOxg5Crru7i+VUSDQcEJG2t1KLua9JZDUFd2XIRZZoZqba
 Ndz3qLww
 bBMi+IpbzV8mGqdly+Fca0JpIBFghil2lEZyOBm7J+vS9uDfWGqW4ikNS5t2weDIagPc0lqOtIBo4ceKGmMQsDNYmU+HqVJtSZ0zptHCdID5fqQb/DDIDcy3jXwcKXbGUpuR5HweQBSegsBbjdZ0w7FpuY6SSv1Efk5phBNWbZqDYF4QAAzZ+t5K6BlVDQibP7ntuTqq82eoKh9yz3firhwrM7wkow2hmQPKHcgGL6tZJ+kM8uxYGKGeBxw+mCkQ2iLPtyXtXegWuCEM/OSuygkGrWmXW5I391EV6kTFah66whEvnv/vRvhrm9e/NYmb0Hx4ShRO0I+Btt0xGuK/nTdm16nhV/dKiwYVwqRvtV0x/QtVVrtDQP+isSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 01:54:44AM -0700, Christoph Hellwig wrote:
> On Thu, May 28, 2026 at 10:27:55AM +0300, Mike Rapoport (Microsoft) wrote:
> > -	b1 = (void *) __get_free_pages(GFP_KERNEL, 2);
> > +	b1 = kmalloc(PAGE_SIZE * 4, GFP_KERNEL);
> >  	if (!b1) {
> >  		pr_warn("xor: Yikes!  No memory available.\n");
> >  		return -ENOMEM;
> > @@ -132,7 +133,7 @@ static int __init calibrate_xor_blocks(void)
> >  	pr_info("xor: using function: %s (%d MB/sec)\n",
> >  	       fastest->name, fastest->speed);
> >  
> > -	free_pages((unsigned long)b1, 2);
> > +	kvfree(b1);
> 
> This should be kfree now.

kvfree still works, but I'll send v4 for pedantry sake ;-P

-- 
Sincerely yours,
Mike.

