Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23A86D47CA4
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 00:19:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51B796B0089; Thu, 15 Jan 2026 19:19:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C92D6B008A; Thu, 15 Jan 2026 19:19:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F20D6B008C; Thu, 15 Jan 2026 19:19:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2D7806B0089
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:19:03 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 842B7B9D68
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 00:19:02 +0000 (UTC)
X-FDA: 84335916924.10.321967F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id C6D7F180004
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 00:19:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oTyrgtvf;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768522740; a=rsa-sha256;
	cv=none;
	b=vcRK9GcIpsUxwVjAt5u26Ihfk5bszHog3KOVOFqC6ww4RHoRI3bLMA1R1KTy6Zs/5896ez
	37OJubroEJjAFK+XxmvSuj2X7B4aOMNWLvW1XteNxKK56xLgsZbecEY90hLLNBVVpKoHJs
	TWNwl9YaEqlVVZsAjVSkYMvuWFSITd4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oTyrgtvf;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768522740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8dZ9oxt9FWn/F9+lO/IJZ9dkf3WC43EemNdOt09jeRI=;
	b=qJV+0+Hka3n7nnJQW9+f3jEHzEyQ1Bmc5PVbWvt+yr1b1KN3ZX9xDJ/yIrHj3g/0nvmM3B
	VJEWkF3TW1ZDjk/1hDlkGEVUu1Y+aNGni0/VgLDzXUMk1dQ9WOXikF+AP1U9ofOPYKkd8M
	Byl1ffD7Z4A8wp5TCuxLqGLyZe/IwQU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7FD3D60160;
	Fri, 16 Jan 2026 00:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBC0C116D0;
	Fri, 16 Jan 2026 00:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768522739;
	bh=xmezwQxgXFBOE+WsEI8kzMdBQ/Vtj0ziay1CjIV7d/0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oTyrgtvfzdS6SXwpo1a618aiclgOz0Sosdc70f8yw78SvJDgJcbGQ4l+n163A+84S
	 GtOC/DHsdsuWPAUiEYgrvES4udeex059kh0yHGa7HIOVi7c0lI6djZDMrpXSzDE6TI
	 6esn++KQCSZ991FCXwGinH0epC8qjUoqV4yZ1PiQ=
Date: Thu, 15 Jan 2026 16:18:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrew Donnellan <ajd@linux.ibm.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>, Rohan McLure <rmclure@nvidia.com>,
 Alexandre Ghiti <alex@ghiti.fr>, x86@kernel.org, Nicholas Miehlbradt
 <nicholas@linux.ibm.com>, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Andrew Donnellan <andrew+kernel@donnellan.id.au>, Srish Srinivasan
 <ssrish@linux.ibm.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH v18 00/12] Support page table check on PowerPC
Message-Id: <20260115161857.ad9952cf1ebd1b37839aa652@linux-foundation.org>
In-Reply-To: <cc97397d3c75d796ee71081cc842c867a62ce39a.camel@linux.ibm.com>
References: <20251219-pgtable_check_v18rebase-v18-0-755bc151a50b@linux.ibm.com>
	<CA+CK2bBjoQmheEstv1MacGev_srdx=m5v=hwxdyfAKogbpG3FA@mail.gmail.com>
	<bf0def77b07a34c00928cedb46030ea17be4fceb.camel@linux.ibm.com>
	<b6c39059-faed-41a8-80b2-addaa229c143@kernel.org>
	<cc97397d3c75d796ee71081cc842c867a62ce39a.camel@linux.ibm.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rkmzzo1eirwyg4zri14o1xpxxzhs48em
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C6D7F180004
X-Rspam-User: 
X-HE-Tag: 1768522740-797780
X-HE-Meta: U2FsdGVkX1+B6hYSaIgHTfwQtCSCVwOY3sRsv54VHyxR4b4HXUTX1ox3Rz5pOQ1oGBVhHODGbTForAHk2STG73ymAWd8F1a9D52kklszzDtQhDIu6PRTxAjINs6ZG7nz9k2c6c4a8uolQlzxzgO9HxLHMTNzIXcXcRLb44aWV1BJOLpfJbHvaDSzQKsusCpXZy2at9mWHL+4FoxZovyugO6KQYZJ1zxb66YCxjaPdkqQgFtA/9JbSQjFnbtonPST6IUv1bMIyigExbMCuwYEoX2tGymimbXHLX9k0+aYPv02AgyzRrr8XIbG/LJMLuqyzoPrZ0Q41slH25ybLtbh0hTHsd2UQU1zHoL6iiKdDzfgu0xlDi31QEpIGNvc2DVcIobEzRPwsTHegSmDC0A8PzDJoUcBsnJ2XuiHsmnn5q5yp+LLT406wJcSNzaioNc8UyuohDFryIy23oa9hbuygGBHx6Q4o321jexP+Xir/bBdLd6g6uVAxiVKipLkX1FZfsbYSUFESVB+w3Ba4w9lJ6RKCSOlZO4xG2KX9Xrykc7fnrQ9jQC8+M8NnWtcqWAfNLTCVJHTeDOnEFuUjjfjiU+5gJ+iIIATP4NduJOn+GzbQkrqE2V/u0D5zwQmUJ3QCHFD6240ABTvK4fO2ozkbaFTocyui18/whi1oMl7n749JfYGjbIUJflR7TSx1om8lzMQ+r87sHbP+PlEN3R23YK+m5TGP4cEj1crkvV6eWxGUDFtVBkePvJUmZwx6fDrz4oqy6V9xgs+D+E5TasrBcrFrT3MkaBr/cpC1hd7Q/QlnE26bKUrtQhsFQr4TQ+EZMLXqSYVOV67aj/pn3XA+EyGxgbxkuomL3lVSrZ+FFCeC7bUfvceUFplVCeVHZ1rOdSVfTWGOO/vochIwc/dMWyxlacb7CzynLc0DNqIM3eKBbbeIOYzavBAlbxrqH17e2jraxBFNSTSVxir2Pj
 PNZo5DuK
 ov/FG6t0CvfRQaiMdyh6PCwzY8CKKjKCMdCSAq0abT87Al5jMFR3U2fEVvNfMqGaXw2Ng7bea23si0P2e4HPTuqu+9Q3OEjKteeW6+48FQ/OK8yj4+QlG9yCD1vi5csvWE+yMEtEo8rg8qmoOglUCLrNmyFx427M1vQ3RTI/qN2cM0TOHZLY2wXE34qKmFRw3b2uQZBTXW8B678a5E/t/sxz5nTwXXmtccVE5DDqG4K/Zoh3XDuXo9KliOzOPmiswIr07l/aGeE6Zl+rxMnu2toQaSlK7Uow/bFZF5Ud2596QMhvsSW+ZC4GMkN9XyrThgcqfbBbpY/Iue0IWoXMC1qEqh73iHVZxkx4w
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 17:13:26 +1100 Andrew Donnellan <ajd@linux.ibm.com> wrote:

> On Wed, 2026-01-14 at 10:34 +0100, Christophe Leroy (CS GROUP) wrote:
> > What is the merge plan ? I see all powerpc commits are acked by Maddy, 
> > will the series be merged by Andrew into the mm tree ?
> 
> This is what I was expecting - this revision is rebased on mm-new as it stood
> around when I sent it.

Ouch, sorry, I did not understand this.  So we've lost 4 weeks testing :(

The core MM and ARM changes are trival, in the if-it-compiles-it-works
category.  Is the mm tree really the best place for this?  It'll get
more testing in the powerpc tree?

But if you're OK with it, I'm OK with it.

> By the way it doesn't apply on top of powerpc/merge branch:

I guess we'll be hearing from Mark when this hits linux-next. 
Hopefully the resolution isn't horrible.

As I'm adding this to mm.git's mm-new branch, Mark won't actually be
seeing it.  I'll aim to move this into mm-unstable (and hence
linux-next) after just a single day.


