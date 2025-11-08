Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA284CCFA13
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 16:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F8B08E000C; Sat,  8 Nov 2025 11:47:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D0078E0003; Sat,  8 Nov 2025 11:47:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0395A8E000C; Sat,  8 Nov 2025 11:47:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E74E48E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 11:47:28 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 98F2F1A07BD
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 16:47:28 +0000 (UTC)
X-FDA: 84088020576.16.05FCF85
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id E3E3B180010
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 16:47:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gxvyVDo1;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762620447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sepav7DQLeeSPIHiDKWYoMmXRnTQK7/Jb1JaZBPiu2g=;
	b=nGKRKo4jSqneo1WQ2Ta8SkspPwY2t2WML/iaJEziCyTByQE9KRXb8ROYGPyiOuprEteBdK
	vsA/8uP/FnqPFjLaGdhANIfvIuwS9cuogjWeOXIUeu6r3TKLPU//qqwzRmM4yyBrQw3t1g
	e8ljB1f0RUZtxuw5HOkP2pAzc547VW4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762620447; a=rsa-sha256;
	cv=none;
	b=phjF8A9TADs1d8ENemJKNEBA1NGYXKQiofdwQZoVRWDO66zZtLBIysNZKKgpBHWCiv4C6b
	5vtv3P0H7htUz6GaKi2Xg7bClvE6Fn+xQOVG6/lP5mwy86PReB+gORKW7KGUApatN1A2tj
	kU7y2TGhaXLXyleXc31TKu8LdF/wTgo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gxvyVDo1;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EFBFD40482;
	Sat,  8 Nov 2025 16:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA43C4CEFB;
	Sat,  8 Nov 2025 16:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762620445;
	bh=U9xaDAQiKEtdqRiUxXf+jkJqFleNQgrXm3B00EJk9jY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gxvyVDo1dmbhZXPx7hxq+/HrVPkk7Kc5qQrB7x5mYVjMdlCaBOhfDZX1m+3xeKOui
	 VzOyGeRM63eKiCjGHPv1/m5t7RFtp8kmoSUAUcH7s7WqHPDaUhswdYh84gc/3XbLXW
	 IOva6olKK51Jq+1xZ8A5E/zabqEax8ie1v879nQk=
Date: Sat, 8 Nov 2025 08:47:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, Huacai Chen
 <chenhuacai@loongson.cn>, Arnd Bergmann <arnd@arndb.de>, Kevin Brodsky
 <kevin.brodsky@arm.com>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH Resend] mm: Refine __{pgd,p4d,pud,pmd,pte}_alloc_one_*()
 about HIGHMEM
Message-Id: <20251108084724.3e389b6597294900347b0476@linux-foundation.org>
In-Reply-To: <CAAhV-H5C_Af72a5QcJs25qUMsJqO26=8oNvvLrJ7z+xHZh8oKQ@mail.gmail.com>
References: <20251107095922.3106390-1-chenhuacai@loongson.cn>
	<aQ4lU02gPNCO9eXB@fedora>
	<CAAhV-H5C_Af72a5QcJs25qUMsJqO26=8oNvvLrJ7z+xHZh8oKQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: E3E3B180010
X-Stat-Signature: hranp4s6b4iprp1dynxrxs69kn5fobps
X-HE-Tag: 1762620446-585358
X-HE-Meta: U2FsdGVkX1/YiPldNnJj4s6ig9nlJD4s+NoIbbg3o0olQudJT2knh7uKQ0hpnxWoU9b3OKbTmuGRW3uBnzESEOZ14LPAt94HMFxYrpnoMUo94T5DJexMUu2ihmNUryqkpsctf6WP/qQobpj88gKUBFsx2CjGCrMtmUnZsdU+nGmlGn2hYEtHceW4TAjA/I/u76TW6f9wnAJYFwEfazJFJtTHA2/At50hkSfPCbSUmutKU5qXXPYvaNPikBdgJdEq3ufQ9uIV5T4OE0rFeMGrbswhZ7SGMoenGqNzb6xEWuBv7IF+gqOKYSyT71wZRoTLInvLuPoi2qMvlWRoa74zZQQKQTLXmoJPot14B4G4mHjC/2T4ZqElUx7qPJYVBrbRnw/KWgMeh0QIZH3aphBVJOIW3t0gCA82gnwa0deQwSo+lCrmVbcG43vFr6RFCyPNJBbu/biixGsuu1XZmFuIlNICxGLmYyn0nWwR04fjmvXVLb4ZTBpCH5KsryB3KzVwT00Rsu5Mm//LMAVbGYO4dWMnQEGiHZyCYEei7CktIoiM1xJSsLl12igWxacNyzvhi/0/YFDwZSR0QZ7fdWOnZjekZ/d4kZjrNQHQnbkj0zO/myV/OTXJiUbwR2MjG67hV/UpS2Geg0AyvwnBBFtVvrEL8Z1I/gRmOKCgxLhaFpf2HSsTBbDE0qxnmok/fsB0fMTucLPcomgZRso6+AgcsoTsgszdz46Mp/rFoBG31OpHhQndDrj/Ek5/En6CXjgvBo4J1Fh522ZZQvIHyNg/NbmJ96Ky4/KgyA+WpKbMrIsQXCJOGHXEve/8cQ2u9w0KLjwgdkucJVp3Tp1451D6cfYdbYF+i/Z4pd61sy+L8Nul0E9fObF/FZszsSZD4xqPhUH+TtnmQCkjYh0RunTEdhp/tZoCTfvJPb9U07hLbVhIeT+/fhsgQMl2GUgn1ayDax3SKAElRp9oKLOQ5vD
 KbuKnW7V
 1KUA+8IHG8TyqEhyH4eMoF7aNDwHFR/s2E8A/P+aZbrMxhwxAgdzHL+uTBxwqTtfuc78zRov4fiSomJqrhakWoQo2vMakude7+b/OgTLnfB4ZBxJG+oSShCCQB2jQPrhGLrUSwx93o6PVVK3psZ1hPKpCBIXb6BX48bsxdtPUBL2jXyf2EReAM4lx3xDjcOSLDkw1vV1CKf7tMVsQuNGSI7jOqdvK5TTlPULXBTWQ+6jhuFJWB4QqmJuVkOOsSgEHUZQ+JRhGCArXvQJerms+2yKuaEftZyyNYfeTUvwqP9EQ/juG/vX8Q785BHngT6my8bNQtOCXK8N7N27JMixS2MZA5SjvWN2CoGv4gbQl/F+Mid0T3k+RrmH4W7RDBplqkuDF3jJUuOHkz0OLIygQTcerW+vwuFeo1XJXJKUFjs+HwfLWfkh908dC1Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 8 Nov 2025 16:34:20 +0800 Huacai Chen <chenhuacai@kernel.org> wrote:

> Hi, Vishal,
> 
> On Sat, Nov 8, 2025 at 12:59 AM Vishal Moola (Oracle)
> <vishal.moola@gmail.com> wrote:
> >
> > On Fri, Nov 07, 2025 at 05:59:22PM +0800, Huacai Chen wrote:
> > > __{pgd,p4d,pud,pmd,pte}_alloc_one_*() always allocate pages with GFP
> > > flag GFP_PGTABLE_KERNEL/GFP_PGTABLE_USER. These two macros are defined
> > > as follows:
> > >
> > >  #define GFP_PGTABLE_KERNEL   (GFP_KERNEL | __GFP_ZERO)
> > >  #define GFP_PGTABLE_USER     (GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)
> > >
> > > There is no __GFP_HIGHMEM in them, so we needn't to clear __GFP_HIGHMEM
> > > explicitly.
> > >
> > > Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> > > ---
> >
> > I'm not really sure what "Refine ... about HIGHMEM" is supposed to mean.
> > Might it be clearer to title this something like "Remove unnecessary
> > highmem in ..."?
> Yes, that is better, but Andrew has picked this patch, should I resend
> a new version?

Please just send along a v2 in the usual fashion.

