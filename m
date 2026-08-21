Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B161C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 14:04:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F00A56B009D; Fri, 21 Aug 2026 10:04:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED74C6B009F; Fri, 21 Aug 2026 10:04:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEDE66B00A0; Fri, 21 Aug 2026 10:04:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B6A826B009D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:04:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 14D614012B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:04:43 +0000 (UTC)
X-FDA: 85125447246.28.DDF60C1
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6AEBA80014
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:04:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=T7sUuy38;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf30.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787321081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SdBGGRg8n21wLsq1Rr/9aeWOWntBAs5V69fUplLxRqk=;
	b=SYO+qETiuSyxwj7+HX6zgcvG+HKW9afUr9GPiauyBk0X12ceAiOyAyJRj/T1rOVio/OqDc
	Ltplm2+oPAbkicQAA7nzLw2po18y+PRPe7dMvj+dY1pXfrO/4rx9IU6YP8flozCqo+gGy9
	H+3P2029kAx55bDYAAELGK9aIZkmW+8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=T7sUuy38;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf30.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787321081;
	b=EIIDNq3jjnFovp0OD5uVAmoT/8JzYtUIyZZqxzyWKPCSZvEpPDJVuC4WJfspZYWCxw8zt0
	VoLJwpe+/97C3er3assatTPsby0vvZEdePLkCoGlODpY9ESbxZ3ZwkCpt1m2aSN0tZuCOX
	Z9maJx4/gRvIdGeodP1CNr1ZuepdzqQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SdBGGRg8n21wLsq1Rr/9aeWOWntBAs5V69fUplLxRqk=; b=T7sUuy381KVuQSt4ma4ewlJSTw
	e7l+OZDvXvcr8tEVVR9NJzHPlp2E5/WOGVam1eErJmCrIbBUSvoPajkqNgUanMiTlPkV6F6weqzsV
	UEPbfwuT9WOknpJvCqZSimfzcRZ+IM+6zQBfKHVV6CtFir+a2vmC0D5jhn8vp90zRMxqKdMenoKdW
	KDfG9PHMmg30GcbAW9e1gnuNmqWM5Bvx31mfdSwRPY406L1w5tISz5D68wGxzvQpdq1Mc2pDrOIfv
	gSdhdgyS1EDWs7VYqYGtri5BH1maCKBTVXMTkVfBUISBT5CACU3iLX0u9XD5FAAWn9JGN0EqV7EJy
	tJy0+N5g==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wxPrE-00BOLF-0L;
	Fri, 21 Aug 2026 14:04:32 +0000
Date: Fri, 21 Aug 2026 07:04:27 -0700
From: Breno Leitao <leitao@debian.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rmikey@meta.com, riel@surriel.com, kexec@lists.infradead.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/6] efi: add the LINUX_EFI_POISONED_MEMORY
 configuration table
Message-ID: <aohavv-xpcNkDP48@gmail.com>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
 <20260821-hwpoison-kho-v2-2-5743791e48e6@debian.org>
 <aog7bwfMVpSy9LcY@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aog7bwfMVpSy9LcY@thinkstation>
X-Debian-User: leitao
X-Rspamd-Queue-Id: 6AEBA80014
X-Stat-Signature: kotgeijgngqg4s6hf5f3831uipbdfnhz
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787321081-953047
X-HE-Meta: U2FsdGVkX1+1o69hzqUxduy5ZjyljSnXnAHbRTfaYtjnnrEyHSMzKmeV/SYkUK0k4G4cFerA8Khnt5clAdXFxZ+wWWizpkh9Zls9MNsjj5qXVoAX6ND7FFCvow4Dn+yG8Jgcx1eTpvyRgM4kgH1gkbBKcTEhpKJEVDFP9FK6xxe98nQeCqUsmkCr2aFn4q1CykuU6rHA054VA92nKUGWEOmgcrv/OmDTkcw5PI7ayyTbzmvCO17gSfx7xO7YeTtEORwMpy7GdOc5IXO7wfKEZHD8uFzSC7dMyQmGYMH7cwOYaC7BI/QZrInGmaxmocTc64jeVRpQ4jkSMgGCb7IjiXccww4FWvlQIf1HVFs7Vtrya9ux894ESgPpUWZVCBmStxSqXptgpFwPhdgMpZi3PoNQHkbJwK6+4GlGUs3OmKhiUoaBWUf/Ch9j8d7oSDpUjkXMVsN9tc+5flRfHBhIUXNt9hjriVt8xQNL+qu5UiXOyr5jvHmbo6H05AGjdJ95zajlEPJFYC40JAD+4hBRHOjVk6lJneR4Dhact+tNx7IL6jHDfw7c8vGlzYhidI9ZskDVfansR824B5RZnEw5LhByF55FGucLbN2sHIzxTuvCAsjUJrruQ9LDbBZP5Q7Fz+Rx/EN5EHSon0A+oGkIes1XKYQRGJASJGfVoVplRJHBTF5V6QZBavUZSrn9Q8VPAsowcL3m56MYtWqb22wQzc2sZyHlbNpSfO8lHe0Fx71TEFHDaE4HQhxsUwhN1bT1WylnGKhNE0CwhXEWybao8DTmkGy603MSvZr7IAUuJ+2GBoOXNoDcu8uUhOZ7qYXZggzmrtCswKN72uIUNObFeznRztYMsaoofzXxZ1Y/CShF6jaU4ulE6XBgIL2AQtGlbaN55l2z4hSFCMhpKnbeDO6T9BiVBduHLyoj0woWdt5JaR+f1h5uwrz6zXEZqk1sbe9AoHiqpv7jPtmKtqx
 0oMVmm3+
 DMirAtPqcUK8HpayYkI5CppHhmRNBCQFCeCSM3zuQS3Ra+TS9p1dxH4CCSpwdywODmakQxEtRbOYps6I34IraL5WYhocApfIHOnlPJSW+wLHYlLL1ru9KgDw2ccd1i+WZY+966aXLax8hPjgN/euRzCpvWfRgEfvqSx2DcCqCNJECuh/uECsrhCmZgYltTazSixC2DLl46K/WQrK3vkmuK+hDZEf6aasv0unlni9AeLxkdn50f+PK2RensR8t80cNvvj+oD4b3eJZ6O7nQ9fqU0x3QmC3kKVu+rz1Pp2MmFbRfptIqZw3RnuftS6eBFwN5RzHvXs4HIB3/6oNvEN7ACj/R6IkfKccqPd3Vlsx2HXIWyd7BfTvI3a3eIiL/akYC2rJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 12:51:34PM +0100, Kiryl Shutsemau wrote:
> On Fri, Aug 21, 2026 at 03:06:02AM -0700, Breno Leitao wrote:
> > diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
> > index 29e0729299f5b..69c0dc02bc112 100644
> > --- a/drivers/firmware/efi/Kconfig
> > +++ b/drivers/firmware/efi/Kconfig
> > @@ -263,6 +263,16 @@ config EFI_COCO_SECRET
> >  	  virt/coco/efi_secret module to access the secrets, which in turn
> >  	  allows userspace programs to access the injected secrets.
> >  
> > +config EFI_POISONED_MEMORY
> > +	bool "Carry hardware-poisoned pages across kexec"
> > +	depends on EFI_STUB && MEMORY_FAILURE && 64BIT
> > +	help
> > +	  Record page frames that are hardware-poisoned while this kernel runs
> > +	  into an EFI configuration table, and honor that table early on the
> > +	  next kernel so a kexec does not hand known-bad RAM back out.
> > +
> > +	  If unsure, say N.
> > +
> 
> Do we want to make it conditional? Maybe just for everyone with EFI_STUB
> && MEMORY_FAILURE?
> 
> Where 64BIT limitation comes from?

That simplifies a bit the maths for memory operations, and 
make them more digestible.

Do we really care about it on non 64 bits platform?

