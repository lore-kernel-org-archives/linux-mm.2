Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C07ECC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 17:02:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CB886B0093; Fri,  1 Aug 2025 13:02:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A3386B0096; Fri,  1 Aug 2025 13:02:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B97B6B0098; Fri,  1 Aug 2025 13:02:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3C6F16B0093
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 13:02:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B05F658660
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 17:02:36 +0000 (UTC)
X-FDA: 83728807512.20.4BEFEE6
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf26.hostedemail.com (Postfix) with ESMTP id 060C9140006
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 17:02:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="X/UTCOQc";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754067755; a=rsa-sha256;
	cv=none;
	b=45p5vzn81TLJviPuNcoJltoImqvTaz00e6h7sKZJewLkp3YK0nsloJ2O0g9SoAgE8VZqjV
	39/dKYlRU5ulj6Dwi6UDaWwpOiiCUkYPti/K0ZFDNIBTwvj4nACptG42ebepthlzWu9mus
	QpweVaJilczOO440QoAHYx/rUVlxxwc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="X/UTCOQc";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754067755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B0K65Ou1ZrDTo0CD+g+qMDJCatPT/nxLwNJQiBg59ak=;
	b=yjnMPOflZ9b1t/2Hn+XBLjN/Ycxdy3e77++XZddegaFEVKSRbWqTFcdxAbAcz6YZXHAYlB
	EdJaX6n5QsRamtzPLI1LRWy4yiYOwiXZyEk2sxiNuWHCOmAGieAuZO2BHyTUwzuKtku91G
	a8eG2LY7vUttNkUVRsVJ+daTc5xS8xQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 4D575A555A3;
	Fri,  1 Aug 2025 17:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1ECC4CEE7;
	Fri,  1 Aug 2025 17:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754067754;
	bh=UcW2O+y87SzU13pq/hmDWWAZ/pxri1/7132KbeXpyMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X/UTCOQcXcyIQd1cFZ95Gx8uHlZCZT1BawtuiTbHHW9WrS0EyoVSe3HUUymBPEuIA
	 2XazgA7JBNBm4FktMi8wDjMTJXFo+MDyjqCMocOVgmptxPRQ3NM1hIMQHZerOML004
	 X66XVgljocps091k6fR/y2fgsnCbWPjTo+2SFwNuhq4h8bmY/vWK9KHgdcSuhHfDY3
	 wY5sBUJF764SpcFD9ySMNRcu76OcxsnrWXt/OHBGAQHZYJmyNHpnLUnf02Y7keuZxF
	 eirQXyUJ+FP7b2faz5aa0LMFhOAbnmRs7S5jN9WkO2kgXyJQPaD99dmDqraV33+9fh
	 QI7yu1HChdNdA==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: update expired description of damos_action
Date: Fri,  1 Aug 2025 10:02:31 -0700
Message-Id: <20250801170231.8532-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CABFDxMGh7-vDgNzepJKtrhdOF40_U7=NT6Jvm85qtdwGpBZawg@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 060C9140006
X-Stat-Signature: qbe1nisxchdymet56yb6jcrkyfprrxas
X-Rspam-User: 
X-HE-Tag: 1754067754-62781
X-HE-Meta: U2FsdGVkX1+yoZjgusEAp6Xh/26x1CKtX3Nr73sQtYSbVA+L82FxG5Y8iAe5Sr4z98tssr99tnZG1gPl7lU9ZIfj0TctUYJPVt9T9wGz2yC5n/Xo/DOs69mpltf8jiOIbsh1fA/ilyFPwmIOL03VxAtQon9REEwdC9uRyIID1aqGc5E18k/ojaJ95uE1PESaS1htDRpwkFo5bwwx0lZkqhvohi+wGMC0oIafDkgIdRDa8btqiW2XWbjrvLhBPeI14+pNI1NdO1C2ubp3M04YAQmnGfu4x7wdlWcvY0sDZCQ5bXY62hLiBiMsKvp4ELJpzat+f7sor3K2qSjv86venGKbxs9vmxjrihbR8f8eMjR+jVtYvv4d75A7lw+j8UJqG/1tBHtQlzegqlTs41+YqrCoQc6VJ4fzcnf5UHjjY7GdRatD3ZhADutOIe4+0q5XYaiZSEdEAyWqdMPbyuPunUPcZebNc6kJL5c8PbvRPzeLyO6+7c5O8mzqA4VQMA4+oZZHyvybk96bPfPXTcCU9gMnk2orYTmAxJBqB9yZN5w9WblM8GmopSRZJNuRoaPGVMQe4zhzxiUk12xa2UDCpFlLozC0mG+WThJfu2S5XgwVRNNA7EjHt0ku32Loz/FQtimX/TiEKsI+yprnLZIj8tIyEMRuND+vFUQbKOldxBnYW/WZaZMk1KZ8L3GFNJoDG8CaHuj7RSL+Ou0e/UrbQ3cTFXYla+KOTSVW3ErmCBKc/IxeDEUlPuxz47yRW3zFUJpwz1NExZ/p/+pBAkmXrUsgJ+8GU+0bR9ZG+8gv7DEAKJgml9bVMt0KAGNhJSMtiaUYLMfeZkd3dMtHq+tjo3RJKZ7q9AZqZYcStH5IraZTtzY2V5ZzSxP7remSdOOdo43qqz7VLHoBoGEa5C2t7HncdR8aWvZtW8LC8+jX3Gemw3CzQKxWrRoN3NnY4ghUgQGB5FrpCJWu/hgmQZe
 Hrz6rDLN
 jxxIP5JX8HKBcE9mW2dG8V7C+U3g++3pcmgRM8MfmNovO2wMFWKJFUC1VWM9QBrZk5LZ8xkreyOyaDhHm9ey55vgvZRYe11ozFo8CXE+WKu5rQaFxAfKgt1XsRf8n3s6GTAvbhr343bL03DpLLOaKyQNBMZXfUBW5YTBkkgTIcS7RM/+K3NBp6tYK5FxLWA4jPdTA+P0rjopdnnj7M96PpsPzzR9V6xkJQxnq+U9AWw3PkQH3CqEjlU0JbHS6rHN3XSxlF3AorBuCJn3MJfhHVGEAi/lE14WoRDFsbdpZpRgb79WIGKyhZh9cL02V1b5ohfWSLG9WHFpdyTU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 2 Aug 2025 00:34:30 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Hi, SeongJae
> 
> On Fri, Aug 1, 2025 at 2:58 AM SeongJae Park <sj@kernel.org> wrote:
> >
> > Hello Sang-Heon,
> >
> > On Thu, 31 Jul 2025 22:22:30 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> >
> > > Nowadays, damos operation actions support more various operation set.
> > > But comments(also, generated documentation) doesn't updated.
> > > So, fix the comments with current support status.
> >
> > Thank you for catching this and fixing!
> 
> :)
> 
> > >
> > > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > > ---
> > > I also found below patch(https://lore.kernel.org/damon/20250730200239.60984-1-sj@kernel.org/T/#t)
> > > So, Is it means that DAMOS_STAT is only supported by paddr now?
> >
> > No.  'vaddr' supports DAMOS_STAT.  The patch is not adding DAMOS_STAT support
> > on vaddr, but extending the support for DAMOS filters.
> >
> > Thank you for checking the thread and asking this question, though.  I see this
> > as an important signal of another rooms to improve on the documentation.
> 
> Thanks for your kind review. I really don't want to bother you
> anymore. But I would like to check my understanding.

No worry, questions about DAMON never bother me.

> 
> So the basic operation of stat is covered by outside of
> `damon_pa_apply_scheme` and `damon_va_apply_scheme`.
> If it's not too much trouble, could you point me to where they are?

It is covered by damos_update_stat() in core.c file.

> 
> And some extension stat (maybe it only renewed that filter exists) is
> covered inside of upper functions. Is it also right point?

Depending on what you mean with "upper functions".

damos_apply_scheme() in DAMON core layer calls
damon_operationss->apply_scheme() callback of the current operations set.  The
callback may handle DAMOS filters or not.  The callback of paddr.c handles the
filters for DAMOS_STAT.  The callback of vaddr.c does not, and Pan is extending
it to handle filters.

[...]
> So, I think that I need to send v2 patch, If that's right, which way
> would you prefer?
> reply to this thread or make a new thread?

I prefer making a new thread :)


Thanks,
SJ

[...]

