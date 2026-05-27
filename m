Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E380CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 16:24:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 158B96B00BE; Wed, 27 May 2026 12:24:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131036B00BF; Wed, 27 May 2026 12:24:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06E096B00C0; Wed, 27 May 2026 12:24:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC2616B00BE
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:24:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B30E74065B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:24:42 +0000 (UTC)
X-FDA: 84813723204.23.4BB28D7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 21B2280014
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:24:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CQ9xkxQG;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779899081; a=rsa-sha256;
	cv=none;
	b=rspoh7YsuNB8iC2eLyskTxTBJ+73/9/q8SgYLH71AXC8aBm7huwJcZ3rUxpBoVxB/gheJV
	oABwObgKOngt8VAsX5mCewWjjVCQHVwBSYoyi8LznTV6uXtBVWrEnoJqynrHExz/eDSrTd
	R4S0vocvdkPJQ67TE8alyZ/njUEM5rI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CQ9xkxQG;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779899081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QhRe9HWwf69DSd30E/Hpvx+gBmO3NQardItpSdvJddY=;
	b=FjVyWkOmd5RpPGenediKt8r7HCbQoRdA2mhLANFrcca0K4nNM+XtNAYt3qqZWsguyh/h3m
	xw4zqQf3G704B6IAWcbYXFGE2FqCt5okmeFVPiyBJ6ROiTcMYDMdXwormhJfwPzKimG0ko
	fCTXmiIRnYnHN9ZQLZ6EFNbePHoVnBM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9E0CA6021C;
	Wed, 27 May 2026 16:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6764C1F000E9;
	Wed, 27 May 2026 16:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779899080;
	bh=QhRe9HWwf69DSd30E/Hpvx+gBmO3NQardItpSdvJddY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CQ9xkxQGDfK5oYUS6+HDl+tbyUrsMFSpZDebP6wO2/cDp5duntQYPhsV+g0xq95lx
	 3JFBW1PKLgNXbNR8nHepLjUF+/i0JakTtjLNmQbpbdrqP5v8/SM2Kub5dpAFPzpljY
	 vQRvo2/uq8SKDf1nZ6SbwptyjVzu79uVamrVEJ1GW4l6Y0W319q98Qbh8MInDWrHBF
	 QiODZXOJLC/Pr8CMvf5+FaK8yX8YNy2ZOWoS50TCCIWW5AYevSkiXCFK3rZcDfq5TR
	 KV1+fn7EbVyznpNF0/8rnfwb/vn1lOSoF2UUT1BQcDps/dJrTmJSMv4YC6lKoArULo
	 4DP0F4yAEZbow==
Date: Wed, 27 May 2026 17:24:33 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	mhocko@suse.com, rppt@kernel.org, shuah@kernel.org, surenb@google.com, 
	vbabka@kernel.org
Subject: Re: [PATCH v2 0/2] selftests/mm: refactor pkey helpers and fix mmap
 error handling
Message-ID: <ahcatXuo1pI9Z59G@lucifer>
References: <20260525130200.fa26a0456979d8f1045dc930@linux-foundation.org>
 <20260526070518.630740-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526070518.630740-1-lihongfu@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Queue-Id: 21B2280014
X-Rspamd-Server: rspam03
X-Stat-Signature: ca7b9i49jfqh865rbw7tzp6rta7sf9kf
X-HE-Tag: 1779899081-367259
X-HE-Meta: U2FsdGVkX1+g5vyp8g2Ikob6AT81/iouxKRZ1iXZ0h1igaqLEeh1cHWZUB92ndYMN4GPvRI0sWBICV/ScNfSTEvSaJZaGAiGcmoihNRMRwExqWgbVClkEPNrjQdTnMzN0rys5Ttdb98WOOonlfJgAVudE821RsWC3URqOOESL1xtx1PPpg26w2A7sxUVsnM+1Z3iscqmxX1ZLMG9xCQ11E7+3R1eUugn7HBdI7DAvGeMxUa3GdurKTdaimqBE+hUGmUm7qYk/ibg5EDU4h2QlQw5dA/eNfUlGwBf9J1DpFVbqkae1G8Gg54fo3wAmc75NF3tujShPBM+9Fyi2DK0qkOcl42XRl6cCLU+kBogEINLMiLxFIGaO8vSwPzyxuMwOCBWsz1EdMwkcDTX+qqzd10+lgH2IfKwArvhUamll7WY5v8SXyKnZLuBGZqDsa41pFj4VOhnnJDXJlc2iVLtKKOLCv0sIGc/ui8adkW1qhp4u8o+xnK8FBnIkmYPvYafxOzM0MfcP2C8XckDIHH3cDRuVQoYvVrB6WwVBCtvbAjf914VjlKbcG3N8rEaia6x4RwX3ZjOSltoyJnT53VEIFBuKL7Z8CKvkZ8rf+fpUlLwUjBsw7x+ouGriwjusa7/JCIotbQ3ZM8zHLh18ltebzinMpCJE+he9ltzGkLUh2864m2PU4TzUBBrPVkvhWf3gqTgHUMP/ZgwldNU/gIV/pxdi6UdrsorQ+EE7MCbOSjOUec1lqjlIpl8NjvImZWMuw6e+g0MMqANexaB/xH8oAuCxEluUDidjcgbdAmS4BFE8LTZPNeUSZNREtwkfx7or+LM0bzru/GmjMQc0RB0ZlSsureAOgLw60uYYcP2sRUJdMsT0rwIcWsOIuJQjgC/h2/YeZ7bnnqXCKEHsM6vHRepIh6IAcPWM8v5MYtLntQJ3GsUvM99g8UxOOtENAHh7AMdSjc90BbW5P7yuZC
 C2z2/AYg
 uzWH8V7bT+mlC0SXO2aNaAa3np20qSC0wSrs+s1RMpNJ8U+h4C8PvX2/d7QNLyAsPDLbTHOtx0Cp70Qm5t5YdYSwn2IkJjnXr7gCFq+2lxZ1w0SlP2VZxFAF/XyNpDH9cTlPaStiqlDsQ0ujjEt7lhSmeJtfiyXcwqt3LfKFef9g6NS9OmLhvjrL0RuVg25u0yzt7U/gkRsjC73R6tfPN21l8K+ydEPFHuVdXhKGhloV+vFFphUr1LmHTAgAd/sBGBw343kToZ42zYXgC6e8MFIs10VK6q63QgjlsIQd4qRF7s9CVS2Bp0Gmt9jr0kc93J/SOm/MwtjVOSNYebs3jbXYV5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 03:05:18PM +0800, Hongfu Li wrote:
> > > This series is version 2 of the previous patch [0].  In v2, the changes are
> > > split into two patches for easier review.
> > > [0] https://lore.kernel.org/all/20260518082120.3890552-1-lihongfu@kylinos.cn/
> > >
> > > The main changes in this series are to refactor shared tracing and assertion
> > > helpers into a common file, unify both pkey selftests on pkey_assert() and
> > > per-test tracing for consistent diagnostics, and add missing mmap() return
> > > checks with MAP_FAILED used throughout for readability and consistency.
> >
> > Thanks.  AI review seems to have found a legitimate problem:
> > 	https://sashiko.dev/#/patchset/20260525073026.27594-1-lihongfu@kylinos.cn
>
> Thanks. I'll go through the problem reported by the AI review and make
> corresponding fixes in v2.

You mean v3? :P

>
> Best regards,
> Hongfu
>

Cheers, Lorenzo

