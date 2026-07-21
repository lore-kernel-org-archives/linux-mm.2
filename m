Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50059C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 09:04:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 451736B00A9; Tue, 21 Jul 2026 05:04:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 402A46B00AB; Tue, 21 Jul 2026 05:04:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F22E6B00AC; Tue, 21 Jul 2026 05:04:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EA5296B00A9
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:04:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6253912040F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:04:26 +0000 (UTC)
X-FDA: 85012197732.10.8F02A72
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	by imf08.hostedemail.com (Postfix) with ESMTP id 759CC160003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:04:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b="P94M0N/P";
	spf=pass (imf08.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.4 as permitted sender) smtp.mailfrom=guillaume@morinfr.org;
	dmarc=pass (policy=quarantine) header.from=morinfr.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784624664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NZctf2Fog7xaH9DdJ/fwk/RMNH/0G9k26p/jbrap3x8=;
	b=p0wpITD6+0IK9WWuSYGLuNjx52tnWmYFLZzjZ0LfIGm4AHVAilIco/vMPVwuqWwBhns5i+
	v/jldzxFNAmrLKyB49fWFQue7AT1gX1mXJUnglG0j9aD8g2qAlcRYQlG5jSYvG1OjxpqPQ
	lL/1XQtZMEsazmJJq9D9Ob/LpGNdV1s=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b="P94M0N/P";
	spf=pass (imf08.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.4 as permitted sender) smtp.mailfrom=guillaume@morinfr.org;
	dmarc=pass (policy=quarantine) header.from=morinfr.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784624664;
	b=YduADQCv8PdDbBL0J1umFBv4jb4VbG/KMCrRo/WZh6vX3bH5ySzuT9zW3nTfeIHKVx2yog
	LSgowGy5kIjoDte3YRHaH2XeLJ39+medpU48WfQCMZJcEAMeLUwcGZ7g/CHIBVYRElSYB2
	7BZc9SpgAFtmvx7URZ4v5pfCnb0JG1k=
Received: from bender.morinfr.org (unknown [82.66.66.112])
	by smtp4-g21.free.fr (Postfix) with ESMTPS id C43BE19F5A5;
	Tue, 21 Jul 2026 11:04:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
	; s=20170427; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NZctf2Fog7xaH9DdJ/fwk/RMNH/0G9k26p/jbrap3x8=; b=P94M0N/PYZO5OiqaxYGIFkwbBP
	7X5G7eTgLxMyMET4tjU44rh3PEtPLw5Xb2KEL+TjnhYXiHl6e4LgXodT+wDsSf2jhPvNp27tda0ah
	Ces+LSs+xqmZ6G1LMl10bkP8nbswzwfHoLKZ15U+BtIgUhA2A1433ULgMoLwOK3yba8o=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.98.2)
	(envelope-from <guillaume@morinfr.org>)
	id 1wm6Od-00000007VQ3-43cf;
	Tue, 21 Jul 2026 11:04:16 +0200
Date: Tue, 21 Jul 2026 11:04:15 +0200
From: Guillaume Morin <guillaume@morinfr.org>
To: Breno Leitao <leitao@debian.org>
Cc: Guillaume Morin <guillaume@morinfr.org>, osalvador@suse.de,
	avid@kernel.org, linux-mm@kvack.org, riel@surriel.com,
	Muchun Song <muchun.song@linux.dev>
Subject: Re: [BUG] mm/hugetlb: possible temporary resv underflow
Message-ID: <al82D3-mumVFAezH@bender.morinfr.org>
References: <alEJkwn5VlTTH_ZX@bender.morinfr.org>
 <alSyhslcItgtqSHT@gmail.com>
 <alYT8J9aRQDx_8pP@bender.morinfr.org>
 <alYZ7fso3zp3j3jv@gmail.com>
 <aleSDxoADBD0Qkb-@bender.morinfr.org>
 <aleyArKTozc4ml5g@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aleyArKTozc4ml5g@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 759CC160003
X-Rspamd-Server: rspam01
X-Stat-Signature: z7phhiufg67dy8xore9cw51cdibnrtaf
X-HE-Tag: 1784624664-18013
X-HE-Meta: U2FsdGVkX1+eWNTtEKuxfkUEMbu9uyhyfhKNg3xGcMG+3diyDp9NNeJ4e7bLDBoaYXdeWmTK71z4u1myy54rIWnYUpED/3HEoi5Ti4ZoMapv2Zqc+pCQl1EboBAMZQ33oQ/egB3jV751StzjVsZuIeXEvOm8/YFMSzAAxa39mwrUXLquclDSLbzuYA3YmLVU7QHgjU9/6YW5i5JrCl3NfP2kLUQfJuZH1jXu8PIt7BlZ7GMB/48oLPw4sOXWm3p5IfcyzxyHk3UiEA8F/kCFDfGzeCT2PgC8XIaLo9xMl3FkGOJwM9d+BlppGxyOfk1kJG3ud9IlBfMX7Ils9Rr+krwADhEBLFj8Rs0aRFqz56mSMssQVHX+Rt8T9dLvovd45EGAJ2om0VpNgFK3Ga2t30LS/mt6hXMFFRG2IQB1Gq6thdzFlkSWOLv2F2T4K2TOLZ44LVx2xQRxuayFAjFNU4Wp1vrb3973aEGia1olyC7+tZrszHIfo7HQT87e315+Fjot/m444P6yFUJ6LYiSTgYNxt85IzvAfaHmqBwvE/XKmOx1HOBfxfCdqf+xLcdS0jehaleDcTWBeEniRQFuIZcjo4Zyrtt3DTy/6NX5xqeHerQAe/Ss5YwPG69GI1mdJXAF9BH4mM8WwXnd4L+9dZ0cYYU8TgXKsHDs1m5aN93tTaJbk8JoT1Yodwuj14npJ8JTMEKv1DzFoRkrE5EUJnNapY2Jk2JhyDx8CT3f8IAz8qjlIzAH8P8pxw6fLtOSs1IjUWsyD67d0xyCnISP5tu3Bq2wOAkz6buL4VllMaFAc0cSpcwZtB2rbh84W46bHO2d128OZdrtm97+XXRA45TMVFesqxt7f318eLFbiTiFa3jJmIa1buaR0hNpgslWrc6QLioW0PETh+AShueOxTzslGWf7RE/SMCCWr3g2uyQR7dadtbXQIgyJj6eVbJRIab2hce6aYvHO9Je3Zq
 uDMaMIvg
 P4j7js+BUKT6xaySDV8I2ZBRAPSmJ3EkG56Ebf3JS6gwx1f7LayPLx/5Lx0qE7U71FyEfBe4a6QU334WbWiLlced9+HljHcMfBGsl0YgTwADqiXvZCgBsCRYjBqGOiZO7R7DBxs9litY8Auhw92ji8ajwyyCPXD9xlSwMdrMOX+KWZYMkiS8LUWwgclLaviJbQxx8KYA2p/U1Rce4R6YweI/7caNJ9EoNZE2t9diRF7GOlnN0rvjxqEz56H675hWPILH9cU76ve2fl2Km4G47QAy4/iRGK+6jNjKUiiNMZ2QJbtI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15 Jul  9:15, Breno Leitao wrote:
>
> On Wed, Jul 15, 2026 at 03:58:39PM +0200, Guillaume Morin wrote:
> > Did you have the chance of looking at the selftest version of the repro?
> > Should I spin up a patch for this as well?
> 
> I've skimmed over it, and it seems fine. please send it in a proper
> patch and I will review it.

Will do once the fix is reviewed, no point in adding a selftest which
fails everytime I think but let me know if you feel otherwise

I do not know if you had the chance to take a look at the patch:
https://lore.kernel.org/linux-mm/aleRuVBaWu6eTCJb@bender.morinfr.org/

-- 
Guillaume Morin <guillaume@morinfr.org>

