Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FBE0CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:08:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5A156B03B9; Mon,  1 Jun 2026 10:08:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0B736B03BD; Mon,  1 Jun 2026 10:08:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B20CC6B03BE; Mon,  1 Jun 2026 10:08:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A20536B03B9
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:08:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 434A21625DD
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:08:32 +0000 (UTC)
X-FDA: 84831524064.04.32C6FCE
Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1EB2220003
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:08:29 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="f 50Wdhm";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=CvRImn96;
	spf=pass (imf31.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780322910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6HDDCmBpB46gXJk6VrxDM/1W+kwWfioTlj1zjppZnik=;
	b=avzbd8kqur3CCKP4y+ruiKWOhzrp19lRCLpGinrbqxpFzkTPRRkkaU9tR4n1nLwjm96hN1
	AOKYLir490zdLvHwT4j1Pt0L6p6nklDjMHGYBfaYozoRtomvLpUrLfyRJEBfFDy0wAYpnv
	wGPbtrxkG7NmEumZQVkLDVf7wDIixgY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="f 50Wdhm";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=CvRImn96;
	spf=pass (imf31.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780322910; a=rsa-sha256;
	cv=none;
	b=jqnYTa0alkxwFDVHqXFjjJnmZ5L1HplN2SPw6mut9zudiA+tqr0hO8ZTFFM7J4cWt4rxJI
	WSNFa4qB2okkV34TX+BS6fX4GY4OYLheenyFwh+CXcAdl+jUWGFpM+2nYZtRnYa5eaG4QP
	KaL85nYE6LG07/YtJbzdQYSUctXfNnI=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.phl.internal (Postfix) with ESMTP id 6159D138036F;
	Mon,  1 Jun 2026 10:08:29 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 01 Jun 2026 10:08:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1780322909; x=
	1780330109; bh=6HDDCmBpB46gXJk6VrxDM/1W+kwWfioTlj1zjppZnik=; b=f
	50WdhmnpWrbof2mJ2n/2UVxDplIY7apqkAwaX3Q51n+2ecxAgDySUL5IDRrXlOJ+
	XbRK6eVw0o6T8SoGqO55t61lq8X0rJ8yqMg0Oj0/YTe4zDAhaRY0YTcDGO3gHmFh
	czlzNLS8l8aezOYXLkChuAzc9LgIqSoe9726YTGhhj9ITtx0nr0SXGb1w8039vFd
	KnkhoHTbarirYSdeTwHsKVo/wPbXA1z6sVEAyiP5d7lOwt9pzekFWAxtWY+euBqW
	/NpmyrU8tvyZ7Z1ezTjAcQUfL7mQN/DsKgAwVgHE5uXB18aP584jg1vXhYMv9ml+
	mO/orrjuFL5JKZP0sg+/w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1780322909; x=1780330109; bh=6HDDCmBpB46gXJk6VrxDM/1W+kwWfioTlj1
	zjppZnik=; b=CvRImn96/UrYQ85ylvZ+0YQu1dYcYhQrJ/EWqM44Rh9tjjq5Fwt
	gzbD9Tb5uAfRfjNQgH/bl9tUdCMF1C9CMXBoxgGtlWFCoGNwFS0kHTHpc20Xkg89
	UvzAp1IZCK33naObZ3XBHlRiIKw4gwE0dcYOa/rb+b7g2Tb8qoL3JHTEB5GT5J+z
	qNe3zHcvfBQ+CEs3UTNzCp0OtIu+PSY8iGaIMCl5OeQ3q3YphRddj5dh8Snop3Df
	76p14boGljDfykuPIiIkGYOQU88+iTlDSudW6zwA6Mzqj5Qj6UOT6O+yiMMCAfXj
	eGIFbPZsfPnfC4KyqVS6qYPKCRdUbhy24Pg==
X-ME-Sender: <xms:XJIdau2xNcew9NuQylE1EIgpeCCBoXgEIiNeyCvfv3YVoQsMtPd0Kw>
    <xme:XJIdapc4kaGaDMTxpX3X_zoIxOSPfYSVC60hylGhnwS-lA32IZI0ScXXKwz4yKcut
    i_8brCswi5BjvknID5IOPoUTtUYbILWoLsXXpyCTec49HVfMYGCxg>
X-ME-Received: <xmr:XJIdahIIGAJBaKj_iMiMWKvfNDVSRON2K1MTGdr5WQkvP7b7PX2fIIsvKSIvKg>
X-ME-Proxy-Cause: dmFkZTGG+BPfjueacM86TULJZov8aM9JltReYywddMsHkqeW/iXnPY1AlEvzFqfAb+8UuU
    kNZHKVUMC+w9mwOzblnHRrtqxDaCmrUv/w7iNRp49/rvhBpC6pp2Swn/kZehABqD2cas8k
    c7UzhEknhBUQfFoiS8CgQAYkLul89H8iAHdZwrIlcSNrtueukIU4xMTcEr3noYPBWYPZ8z
    FCDhZwW33wsmILwqnP7FOfhpiydyfG9hXHD9CoZmhGqLrO/ZbcH2ceeBPWg6GWHjlZNaqR
    8anKZkuTcuSdvA3dV3YHI+bnCc3KKaMj5+rUrICdWNQjrGH5IxkwUmhQSTbe1ETCoSh9k7
    4ZswLeUvtjDvkt6SjVF9kYNeKgo8aFf6uELdJS1viU1f0BPI4tnaINv0np9GS7PRcPA5G9
    bUkGBC0T3ZTuE4a6BfYMiEwk2LaO2YDWmnRqoePtX60Swro9wEwSIPr/b8cZF6zA5i/vrv
    lrwPbjGWbwr5itaeEWnKSSXSrUtpMEtegzzTZkEEkPw6OqaW0oLCTgZqfpBPi3HnoRo1kX
    JbKctXg5jHu40wteAc43cnOuKAeNDk8JoIlk6NJptZmMCCWlBrv8shWoiPjVfLEENw/5G0
    OPU/Ws4E79PtJv3m0XGXAB1jkEkO2lr3PBmZrz3LPLjCRRe+xEWl36bYb3rg
X-ME-Proxy: <xmx:XJIdakal8p8R3wKv36P5NSisGj24SHLqTswt3mM6zbz94vDWNziDJw>
    <xmx:XZIdaubBXAFmCZRBzTWPlVl0h_jFWbBAuv-VeiR3TSqUfPoqAcnROQ>
    <xmx:XZIdavESF8h6R9fgi4zd8woXO5T7hTOwp3PBvHm7IL3ja1NE16Nhnw>
    <xmx:XZIdahB-ks8xcu_DK9fRzojzqK_O165xdaQHcEtMz6sZVebn1u_Ucg>
    <xmx:XZIdaiiQqxWjmz2-jomWktoe-Ad9M2KvZNTEjuPzcrurOEvoP6zwpDcI>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 1 Jun 2026 10:08:27 -0400 (EDT)
Date: Mon, 1 Jun 2026 15:08:19 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Mike Rapoport <rppt@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, akpm@linux-foundation.org, 
	peterx@redhat.com, david@kernel.org, surenb@google.com, vbabka@kernel.org, 
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, 
	sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kvm@vger.kernel.org, kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH v5 04/18] mm: skip out-of-range bits in mk_vma_flags()
Message-ID: <ah2SL2c0nMj0KBtP@thinkstation>
References: <20260526130509.2748441-1-kirill@shutemov.name>
 <20260526130509.2748441-5-kirill@shutemov.name>
 <ahmQvfNk7S4F0LBj@lucifer>
 <ahsVyQZ5UXhJLct2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahsVyQZ5UXhJLct2@kernel.org>
X-Stat-Signature: pghi8jh98cgdrguzrwdid1og6ti5rty5
X-Rspamd-Queue-Id: 1EB2220003
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780322909-990909
X-HE-Meta: U2FsdGVkX1/GYsrXkb0cR5SFR2RPL+a9T04WoAxzE6IxNmvkV4SpIZra+1K7vjzqmkf7vopaoazHAdg2GuzXoDbG2V6R52Bx+MQqb8G5m1y9qapz4bPWyEQy3Yqt1TuXZxg5kiGKE3IiujRAw5vXh670pHmPvacaTnYXxdoGMKVpx/noe6rgQ6ceDISBNt315yUdTH6hEIz9gjlKQYIWfcQgecc7Vu+AHunf4pScw+fwDUxp0TnO37/uXNWtF2eNRntQIYiNqyAnG4Q0HQD1EOnG3xqpnauH5UmiVc4Fwu/WY+Nh/iA0OC4dUBlGV7HZuJwh7hwigXAvGtRPld6ajjuOSGkb8FoHWY/fLd1uG+zi57tEjts0tQtYbM7wYjtZoY3RIdyzhYI/MBxzFSjz0KBFGBPBSsPi61efywbtily3PUE8UKJTu1Rr5r6BILixnJMCv75PH0tqsAEccgeaoFwESt53x+1HzdgIgI577803a/mrN11zfe5+UqPI9vOOrkkVdYYkDWIzjNEvZBICUkzNFasOv/T4T+yAfC/+xVrX1lyi+FoyQ/8SBJ67QXuAxlGCdiIuvhGqhyUI7Jl4ijllixKFD+4R6pDs1UCBPOUhbabLKu0CzmQkCW4/RR2RGRZ6WIl/AvwWqjRPLNE4dxSYD2S0eY18UQUMcF0Fg5oc+Y/zh9zsocM9YIR598+cK35zvWyp4SrhPCmAU/CB7tbWsr0NvX+kqVLcLHxY+oNWnnYdK+BwedfEOcdNZgvHAddwmzoyrCgwxkfOrifVUg8wcvkL3dCudRPFqTfNonoqxrf9GpOWIfSohrrxoBx0LMDs5VlPCv6y8YDYeXle/Bjqsq+G0HlJOIH2ZGhrU5yQZ8zlcaVsHZtLKSYrOeMeJzPwxA73Tt0yBFauem1UcJ1dyJl9w+qyuTHW3L2sxWi3k+yEFULKh5s79t8nlPFHn9VKq1KlKT2X/Y5gz3a
 nmmRS6xT
 pJ+wOmDUCAc4s6nqw0sftvI8bYwvTim0Q4LVXzinOcB/413ym3P6bE0UN0ptmYgA1BMnCF4Hb9wCsf2KpKWIhNo3ptKvHF4+Tb9HLxSOkc7tmpr6nGbEMmq83K262sLBzUPsQ/TPLw3PGxEBO21BRMoBipCkri38j61+L6tivLVw+NY+4QUfwRrokchMlyaX+5O2cE2ghzcfWWqDDEKbu7FP301QeL84ABHwZJffUkNk7noIreO9xMKhuu0CUJ2wTjKUt3gcm98acrN2rH6OWnCiSaVTPsnIx28Wh4h95JRuLlgFCAdlr+w11ZmvqEaZF/cIaB4X6QVt1NOTclUELemUl1Tz7di00x75FmcGi6DDWjZXKXVThLC7HAcBcVp0GctGW49as7PxGRV9iDW7cvMiTaZZvsNacgqfiqyi+jcEHnQiysXijBHNavKsmDidYbEABL8IHL0+lUdGo/HKnitu4meRM1b+ZaKN4B+8S3E860lGxGwMgBO+q2gnEyVReVrSb2fazrQzFM/E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 30, 2026 at 07:52:25PM +0300, Mike Rapoport wrote:
> I have a PoC of yet another alternative:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=uffd/vm-flags
> 
> The idea there is to keep a single VMA flag, VMA_UFFD_BIT/VM_UFFD and move
> all the rest into what's now struct vm_userfaultfd_ctx.

Nice!

I assume it can go on top what I did, right?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

