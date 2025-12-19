Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84947E6688C
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 20:35:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1D266B009B; Fri, 19 Dec 2025 15:35:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCA9A6B009D; Fri, 19 Dec 2025 15:35:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A959E6B009E; Fri, 19 Dec 2025 15:35:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9931A6B009B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:35:39 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 44EC8535C5
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:35:39 +0000 (UTC)
X-FDA: 84237376398.28.55F8DA8
Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	by imf25.hostedemail.com (Postfix) with ESMTP id 37562A0015
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:35:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=kYZHsUm3;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="R g/gGMV";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf25.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.149 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766176537; a=rsa-sha256;
	cv=none;
	b=rumg2rUclJhpKA1BySOlJRyZmQm00aStoSn97vggCSxMoSV4FFH+PPdTXLr58ZUUEgerAf
	puVLIcWDOIGErzSaqfGXhVRKDJzlLT22mxXi2uvVAeavWQ/Qpu6umMxU3C743IXwO5GWsO
	H1OIovtRaLw5IEk2bfOMKYjlDxumYAU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=kYZHsUm3;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="R g/gGMV";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf25.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.149 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766176537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3d9fLzjQ/AZqtv2ZVueKEFb1bGfJIO9edpVZ3H1jqFw=;
	b=Kc0ZMXi9/v8yzNDmftLtzk9NN0jfI4A8SfjzxAmTNFtM+8sDQ6vydWUlLtBLLzfF3kDz4P
	JuSKq3ACpNQIHzP1aY9eVYt09ndIeggY5Uv9/NGguHo73+iR5qZA8SK0LdGCSY/b8EwZF+
	xoeIofQhutozS2AJDbEmy0/U9hKA+hY=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 29D571D000A9;
	Fri, 19 Dec 2025 15:35:36 -0500 (EST)
Received: from phl-imap-17 ([10.202.2.105])
  by phl-compute-04.internal (MEProxy); Fri, 19 Dec 2025 15:35:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1766176536;
	 x=1766262936; bh=3d9fLzjQ/AZqtv2ZVueKEFb1bGfJIO9edpVZ3H1jqFw=; b=
	kYZHsUm3yqBHaQvpro/+WVGIWBVYSVMFfzAK54GcyEOPEhFKvEFuAPrGR+cJTmUh
	WuqFNjPxZvQkkBDtAeuRT4Y6eEryMc/WKH8n1pZWJH0y0k42xCztHwa4qzaYSulv
	c8fjOxu/1OEcujcVhSJRl1VueSwH7a0Ugi7lgTQ5pJVnjDFeQ+QadG4vzWSUDkJf
	Gl2ii6dZ4T7T5QD5RZhU72HA+grnsmxMyM4UoZW8OJbUnvEkKRNTYf6Dyx7OFD1c
	z/BtnKw4w6z4ekb5gkp4VO5JU4ctwu672Z8pByzhuSQ+RGzGy4TN2hQsMMQkhZp4
	yDjEpWPhj/OnA/BzylISAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1766176536; x=
	1766262936; bh=3d9fLzjQ/AZqtv2ZVueKEFb1bGfJIO9edpVZ3H1jqFw=; b=R
	g/gGMV6hGJSilE/ezNtky0vmAjZSzpFmvQe4yQSfpUOWkGu4+khqfe+CKsUsbbH/
	NWhG+aLxCk7W9xlqRRomISPzMad0RNuBJ4JzW8+tV77CvLOrZwYZpBfBxOSSIz9v
	cJinNF6Ej5OguuUgo8Ffg2liakO4Iuak9WNah7aNB2NdDJH+Agy4cPQGpoTO0R1I
	E50NjYk69gfh6dHUbDP691rKb0j1Kwmm+hQck5oLYemr4vJt5HIyG0JkVIr8FnPc
	MEIR7CnWx/AMfasIuVZN8J6smZ16rnvAZK0DfZAWUSQvK/TV++Mw9B67WJ7GlM/n
	iHzqzayWG1vya99RM3gvg==
X-ME-Sender: <xms:F7dFaetfjsH_R0FrwIjtYohr1MfQyeE2o_Kf225FkyDcAyfvlGgXag>
    <xme:F7dFaeTM_mVgkLqy_zis7ZjunWXe23L2cRxu6fojMT-CUeK-upeQDeRRCMxTOLG3t
    PM_he3EDc61UZJY2PHV6HnMgC-TNEEwy52aM303P8LlBxIBV9FxxI4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdegledvkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpefhtdfhvddtfeehudekteeggffghfejgeegteefgffgvedugeduveelvdekhfdvieen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnug
    esrghrnhgusgdruggvpdhnsggprhgtphhtthhopeduhedpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtoheplhhinhhugiesrghrmhhlihhnuhigrdhorhhgrdhukhdprhgtphhtth
    hopegrnhgurhgvrghssehgrghishhlvghrrdgtohhmpdhrtghpthhtohepfihilhhlhies
    ihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopegrrhhnugeskhgvrhhnvghlrdhorh
    hgpdhrtghpthhtoheptghhlhgvrhhohieskhgvrhhnvghlrdhorhhgpdhrtghpthhtohep
    giekieeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtg
    hkrdhorhhgpdhrtghpthhtoheplhhinhhushdrfigrlhhlvghijheslhhinhgrrhhordho
    rhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrgh
X-ME-Proxy: <xmx:F7dFabR9fuVGLS8b2nH0EJEL7gMeVQyE2RmW6pjAmP-j5ztg66sWYA>
    <xmx:F7dFaSWdbgkitKG_ozO6MG4TRqQ12N7HBRnMw8O3mjcTSiNw9HFycw>
    <xmx:F7dFaaautW2GXmPM0khIdUKFWjjMT3nNkDSx5fj18akTdZS3YoKf0g>
    <xmx:F7dFab6-0sXi3QVEQ4kxkCC7Ickcc4xkhCmDssD-fi6cLmyMFZeyFA>
    <xmx:GLdFaZ8lTCnaSOSLz8dsTEi9P5rYOub2PGkiNAXcyFkNFyLQKKniTZRF>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 3E0EFC40054; Fri, 19 Dec 2025 15:35:35 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AQxZfb8dcq5J
Date: Fri, 19 Dec 2025 21:34:33 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Jason Gunthorpe" <jgg@nvidia.com>, "Arnd Bergmann" <arnd@kernel.org>
Cc: linux-mm@kvack.org, "Andrew Morton" <akpm@linux-foundation.org>,
 "Andreas Larsson" <andreas@gaisler.com>,
 "Christophe Leroy" <chleroy@kernel.org>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Linus Walleij" <linus.walleij@linaro.org>,
 "Matthew Wilcox" <willy@infradead.org>,
 "Richard Weinberger" <richard@nod.at>,
 "Russell King" <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org
Message-Id: <513078d3-976a-4e6d-b311-dcfcfea99238@app.fastmail.com>
In-Reply-To: <20251219171412.GG254720@nvidia.com>
References: <20251219161559.556737-1-arnd@kernel.org>
 <20251219161559.556737-4-arnd@kernel.org>
 <20251219171412.GG254720@nvidia.com>
Subject: Re: [PATCH 3/4] ARM: remove support for highmem on VIVT
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 37562A0015
X-Stat-Signature: hinsnhuy7qrx7ggpizs6qpxfgd8uh88e
X-Rspam-User: 
X-HE-Tag: 1766176537-568745
X-HE-Meta: U2FsdGVkX19TBehG8BOAfUo0Geeip3f43Gsipczw4LujZKXjcKLeK4NOighFbl+p6DjccHpQpnRP0FQzyEf5ztYNQOJVVMhrUmfBxSNkVcaiv+gFd4gC5/feTHgV8r/kb/Au1T2uKEBRwcNK11fmyXTb02JqFlEs5voFRayPbr6ZrKFC8kBkTB6KO8K/k2YKOGS2enuw3WTM680Wxwa3mzjcS1yAkD+IFHXCgH6bvUKXDQ+4BT69z7bkaTi4M1cJC0sSisjQ82bReHjjnwvnWkXygYzNeAAIAujV/3VoEIs9mKtMhoDhDevvBENGKgY+i8so07kHw6aMoTiRpR/Jp8wbrwLxYIDAmcBRvORy1kyz9bARM5KI2mXeKTyBu1UtHM8gnP1+b/gmj1GImhMmYmG1UWfm3/qKSEj4jJxmypKELYEIqO/ria8DuD2kT3m+CIf9EYM7asLolZZncyQPL98PS6VZdHt+40B+6W50sOEeHs37RJymMl9Xt9237+SSQ/q8UJRGouzuhYtOGDVEUDp07J6aF6+j+LxOEPHv5KTdbpu1MtKgY3lgsBVuicyCONnpm2SgkXb2U7yftFdB2lZbwKYJmQTYyPGzrmi+8DW1e2irn0uvZGyP6dPvJtyYj2FA4h7PP6y30rbukwHbkyP70VzAodDjKyMwCaqx/SUNSihHz9dk5S/s0vIJu4QelTUrotoED93YqtiQQb/zja2itR7bI6KSAcrSPsD1rbBYZSXpMGZfe7q3gbxyAf/zjcmDHZoXjySDJy0ih2Xw/3JaUsRyrsp5v/8Y1xXyRHOn/3lOTa3g3BVC4djspK+T0wMT5HvOR7GMyaSrv8sYHy6HpbB1rFM6hFiaa5HWWnM9CYdj/phDq5UxSlpM+XFAtp4DVJSp+0ONlcl529SnkMEfta1N6hB6WQN06G6r0HoFJNv2jwSuf38Vcls08dH1WFO6iHI1lSQneEG3bfh
 5SAyhbs4
 CMwdwcqnmGkj01UpfXYcwgB0PXDKq48XAN0M1zqgvjQAtRPFwBkjcSxfFJIgyRoBATrw2jH5eOmPBensoC20UmsIskttYPDCzHG0l5YH7AwLDS0lRS64UrKig9eLvKCZhCD8yX2xiryl0VSu1SiJQfs5Y7uAHBX3EYQcdysF5gPZBwpRMXRrFxMlBQKI/JVAAy0ZYR+lBUJlWtzs9u3+jEK7sYb/8mP9Ri859
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025, at 18:14, Jason Gunthorpe wrote:
> On Fri, Dec 19, 2025 at 05:15:58PM +0100, Arnd Bergmann wrote:
>>  arch/arm/Kconfig                    |  1 +
>>  arch/arm/configs/gemini_defconfig   |  1 -
>>  arch/arm/configs/multi_v5_defconfig |  1 -
>>  arch/arm/configs/mvebu_v5_defconfig |  1 -
>>  arch/arm/include/asm/highmem.h      | 56 ++---------------------------
>>  arch/arm/mm/cache-feroceon-l2.c     | 31 ++--------------
>>  arch/arm/mm/cache-xsc3l2.c          | 47 +++---------------------
>>  arch/arm/mm/dma-mapping.c           | 12 ++-----
>>  arch/arm/mm/flush.c                 | 19 +++-------
>>  9 files changed, 16 insertions(+), 153 deletions(-)
>
> This looks great, but do you think there should be a boot time crash
> if a VIVT and HIGHMEM are enabled, just incase?

Do you mean in the common code or just for Arm?

We could use the Arm specific cache_is_vivt() macro, but it feels like
the 'dpends on !CPU_CACHE_VIVT' Kconfig check I added is both
safer and simpler.

In common code I don't see a way to detect vivt caches. There is
cpu_dcache_is_aliasing(), but that also seems to cover ARM11
processors with aliasing VIPT caches, which are otherwise fine
here.

     Arnd

