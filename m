Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFBABFF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 11:09:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62CAB6B008A; Sun, 26 Apr 2026 07:09:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DCF86B008C; Sun, 26 Apr 2026 07:09:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51A1E6B0092; Sun, 26 Apr 2026 07:09:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4265C6B008A
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 07:09:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DBBF91B8532
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 11:09:29 +0000 (UTC)
X-FDA: 84700436058.06.F6739D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 19F1610000A
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 11:09:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LBhlIXrl;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777201768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7wHPK2qiAWP541LNIZUE2iRjUCI+lxAiteZ8VOWogGs=;
	b=tGfidd2kPSmocFp0c9JdmprOt2k5lhOWqhc69C0YdlOmTPmmW4dXg0FcaqXvx1f1TNCAsO
	dwH2aaTNv6stFFGVnCdCPLTuPFvdd5I4FoXGdgZeBgXe2MxMu/iRLDA8iiHIB8yfj0uHUK
	XJi+u5H+9tOnhKCyL8qHV67mO/VINGs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777201768; a=rsa-sha256;
	cv=none;
	b=FuF/gUSj7lKqUYBJM/G7byRzAXGyiSKnzRTnVFYZ+/EuUDG1X1qRvdr0ha0digqQIa56hM
	ZkL5AZXlg6yhNcnVDg81DnqbWXY8sJQEWElOtkQgJazRQg1iBMpWO2X6UlFp5wGvonOOTM
	GxRHRepO8dRMQcUHfyQB+CsYMqldikw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LBhlIXrl;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E739041929;
	Sun, 26 Apr 2026 11:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4F2C2BCAF;
	Sun, 26 Apr 2026 11:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777201766;
	bh=pbIEORir0Ac/K2INhsvTrLmqOd8GXcfOwlVr+xdk80c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=LBhlIXrlz7FDITo83KiESVr8Z6pZkiZQQn1pWmi8jVCmJwkpwXlYYhaje6yhNNl7N
	 HM1B4KVo/xcTuEyTdoPQYDa6hTU4m5djY4XkWF8j+0dgHedNIlm7FUEEEVO25q40Gt
	 N8GjHLYgmEK0ujoWeJLH4e5KZmGAu9U1ZkQTcmCw=
Date: Sun, 26 Apr 2026 04:09:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Min-Hsun Chang <chmh0624@gmail.com>, arnd@arndb.de, msalter@redhat.com,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic: replace ________addr with
 __UNIQUE_ID(addr)
Message-Id: <20260426040925.b25cb2a32680bfe884431abf@linux-foundation.org>
In-Reply-To: <20260426114938.4dff28c8@pumpkin>
References: <20260307092119.20733-1-chmh0624@gmail.com>
	<20260322144032.7353997c@pumpkin>
	<20260425135737.e79c4b546d22b5ebfd96c0b5@linux-foundation.org>
	<20260425230134.5449498a@pumpkin>
	<20260425151240.2a46e3a8640fde3902461d41@linux-foundation.org>
	<20260426114938.4dff28c8@pumpkin>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 19F1610000A
X-Rspam-User: 
X-Stat-Signature: h8jjh1fsdmr5o4fw5pwgj7516h7co9t6
X-HE-Tag: 1777201767-244640
X-HE-Meta: U2FsdGVkX19yfGosy1kN3RYfzqB1FOJaf5diqYet/HtGyNnhwjqbVpp98rMgcnRM4WhnuD+j6TMeGEt9+PIdBBmRm0iqYP9R5PB89XM2Mfcj3eUhqK4wmQZi4NxoMgHcpBque7x1Da1qw5sSrOVn4t40d9+wfZ9t8QjTI6P51/aNHb9AwC/AtTlnXLD0Jj84M48vBLzhtd7EL8XbU7UPK8zeUlUwAYb8DYlSF4PJBpgC5KscEj+DU0lLg9V5SQgKq22DxZtDvhl503LTQjpiP1lHa+6MwCQDl5xzDEvDJIlrdFIaI2TFelx4NgDj0rQPNHWm8nuXYOUPZDVPoeWeyRCnV00orP9eqoRUiCmJq9v08Tmzi/YSf4jiibp0JPokNmTl2ojUTLyCduC7ZYznUl5AxFdp7ibSXFYiEcPFn2D2Xxrheasgn9BC6Ap7EaRKBobUNuZWGISsKBrp9Ywn7lIgiHgUOXMKh+t8Ns5OOJpt4n+YsNq3vEyLx6vDyd/C7sEHQP9URLUdV9Qfzzi3/UPvdhYMDrIN5BWDGd5EzqtrBN6xPar1qpCHDWh/Rgjvfi6VnKIDzCInQXbEhmJC994wgVRfeZWIPFDu5KMfcV2sfELUFWTQL8OfkqHklytJAlI5C+/AEmxp6fc//8SB35iCb24/b1Fak2ivTZ8nIHJIq9gzrae0EziJKGa53yzni6jl2vvtQvXUYV9CBLVWr13aEbNzdoBCRCiDcctkAV/hii9FMWKf+r9WgH8GZF7+bljUcUGiJriudSgzwgU2eAbtuj+eDJQBr9hQ0DnUurermNiPNimEOYSPQs+UV2MchZbJoer+gbxyuWB0t0ePUDMSI3P5qQTfcKoixOZT2JjOeBw5Im3yJrBiAskWi5jRp1JXTXO46dkY6uhvcR6pnf/drkZuBS5g/pF26YIoAx6L5lkfMPOHJQtm0h+7GA7wrkfolGIq2VNZDuGoATm
 IBwnlgzD
 A58JdczC1IE6ovlqX8FhzwH53EOQYjIigMjgQYN+7p0utLYiPvoRhQujNbad1fzoQV2ZG6+f7u5GiaMToMlL3DqjO0E5nSiqCyVQabUEAfbYwwR1ygxErs428ScgNeGrrIWXhP5sB1Q+/QhayyvWlEakkqDoLmSjZ8JJJ6L8IXjAOiizTbtOtdMIL0fpDEmYKXCydAzAEzHy++hN1X/E0WrxKk1jJwfDfcWNOgCuww9UKiL+IEPH95bzHQ/2A9lNtHI4XWaBtPBAxvEHEskiE57r7Kem4oq/u66XlsKdHRAPB56cFKTsANsl4bK12byy++cZ/z96AdjOZ5eEmnQ+cueB0IRnOI2BKkmhh9j8X9FXrgYRe4i+BxX9lA3GTPQg1BkhE5jskZfMc315kDJr+oQWVYuL6RhJDnxsaEdmgTK1Z6x+fjheNFUt1kbd7s0RpwKkq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 26 Apr 2026 11:49:38 +0100 David Laight <david.laight.linux@gmail.com> wrote:

> On Sat, 25 Apr 2026 15:12:40 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Sat, 25 Apr 2026 23:01:34 +0100 David Laight <david.laight.linux@gmail.com> wrote:
> > 
> > > > > The real problem with this define is that both idx and phys are
> > > > > expanded twice.    
> > > > 
> > > > The real problem with this define is that it's a define.  Why oh why do
> > > > we keep doing this to ourselves?  
> > > 
> > > Sometimes #defines generate better code because they are expanded earlier,
> > > and sometimes you want type-agnostic 'functions'.
> > > But neither is true here.
> > > 
> > > But I think I'd go for 'always_inline'.
> > > Sometimes the compilers make silly decisions.  
> > 
> > Gee, if `static inline' misbehaves then we have big problems!
> > 
> > What's special about the fixmap code anyway?  It's not exactly
> > fastpath.  Perhaps this stuff can simply be uninlined.
> 
> Some of the inlines are trivial - just adding an extra parameter.
> But this set would be simpler if the last function
> (__native_set_fixmap() for x86) returned (address & ~PAGE_MASK)

I don't understand this?

> > 
> > Pet peeves:
> > 
> > We use too many macros.
> 
> Indeed, I get fed up of looking things up to find they are trivial.
> Some of the 'helpers' do nothing for core readability.
> Even things like BIT() can have unexpected consequences.

Sure.

> Not to say I haven't got the pre-processor to do odd things in the past.
> But it is usually trying to avoid having to keep multiple definitions
> aligned with each other.
> 
> > We inline too much stuff.
> 
> True - don't look at what strlcpy() can generate.
> The inline code should just get the constants from the compiler and
> then call the appropriate function.

I can't actually find an in-kernel strlcpy()?

> As does the compiler.
> pixpaper_panel_hw_init() repeatedly calls two static functions that
> contain sleeps. They all get inlined bloating the code size and
> exploding the stack when clang separately allocates all the buffers
> in the called functions.

Poor thing.  I guess compiler developers are more focused on userspace
code and aren't especially concerned about kernel's particular
requirements.  And that's understandable - it's down to us to persuade
them to add options to permit us to tune the compiler behavior.


