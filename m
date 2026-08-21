Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BB0FC5DF94
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 17:21:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE9CA6B009B; Fri, 21 Aug 2026 13:21:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9A876B009D; Fri, 21 Aug 2026 13:21:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB1206B009F; Fri, 21 Aug 2026 13:21:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB5F96B009B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 13:21:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4CC091C0A7F
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:21:35 +0000 (UTC)
X-FDA: 85125943350.28.5665EA7
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8D1D8C0004
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:21:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="P/gO3+OX";
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf28.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787332893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ujreQuq/VbmIvSks87pTDL9ws/ca+3fQw+q8D7dPgig=;
	b=KolAjLoddKvOGk8w+W+mzEvcIWQ80Zz89ihkjngOiqrBwQ5x1WJkNnEFvKlqgjMmry84oZ
	gVpoudODAs/DHN4kldV2El4RgMkcPErX5citnffuBXSXZAn2XoovjIEbFI34kXxA5XrNq4
	FQFhkZ1EJU8y8EKVD4zcHbIe6rVCGU4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="P/gO3+OX";
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf28.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787332893;
	b=uaK6qAQHB3OvNfM6k36uizUygbnVr8O+vYOLQbqNQaq5LPVGn1nhB1Cws1EnlA0LmPRBuv
	rsw+Ka7fwz9uFb5DHcH6JdtHMJnhLdIyB5QrpuYIM9yxItQjVI/+uLYm5txizZT176Ciad
	ntCQufFLXVGq4CrZRGyga2aCFFTXNb4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=ujreQuq/VbmIvSks87pTDL9ws/ca+3fQw+q8D7dPgig=; b=P/gO3+OXjKhdklMG70E4d9i1Pv
	CTtOyI7PTR1PUPuVw5nC9U8ZjLepIYCzm58FlRYPQE9FCZOapdf7XZ7JFcU4z/+/nzKPP0geDGkbA
	vkbBZayX61CN3UmI7yXulNL7qsEmI/lbaPowvDacKmuCYmQM+tQBme1JhhlOmpkcHInMUiDw6cuq3
	gEDuvuNXW9ZS+qluH8M8vSYdyab8wzGX5wpNR7ZsrFyTLtnXLrLggMTPZMxR1Gme4QQYwBtYQX//5
	Ar6oAAK9X34bZCPBrnt3mY/YnES6I92rb4yIJxHbQJSoidhzxWQ1tbrOXyWPeBdNKWPyDzfSREq+y
	yaBnCfpQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wxSLG-00BTcG-28;
	Fri, 21 Aug 2026 16:43:43 +0000
Date: Fri, 21 Aug 2026 09:43:37 -0700
From: Breno Leitao <leitao@debian.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rmikey@meta.com, riel@surriel.com, kexec@lists.infradead.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 6/6] efi: respect the poisoned pages coming from
 previous kernel
Message-ID: <aoh-3XJw82O8SmsA@gmail.com>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
 <20260821-hwpoison-kho-v2-6-5743791e48e6@debian.org>
 <aog_uH5fTsJzXjjx@thinkstation>
 <aohIF6MmjiQpbz5j@gmail.com>
 <aohldTtzE2GJ76md@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aohldTtzE2GJ76md@thinkstation>
X-Debian-User: leitao
X-Stat-Signature: pdthqbjrgk46n5ppbzon45w39if9q9t5
X-Rspamd-Queue-Id: 8D1D8C0004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787332893-251006
X-HE-Meta: U2FsdGVkX18PcEP8DXin28OpzI3uDwfZMI5qMZCKdbAF1Bti3LXJNqqxDMQGe5WtIO2kS8q6N3wm9eLnVMkvJbtm39Cu0X8uch6NjHv98MMyxbGo/lzQeIB6RTSE2izO0JIxAiCrDDz5gsnPVm5typuWMGoHZxSHit/FzgJICdLMaCzXRylpIBpkfV807dbl1cVqYeSnFWvzIWNIgw7H93OxDI/WnxUIN9IMbEIhJvABdlZUNFpfAlT8myvAviT0Qd7ml5rRblb2OUBtMnef4fewuZ6qR79Hd0vgp68o7J7fIGzzkDFDC4a0bdq9ikM9Et5gLWYGiArKKZcmKK3fRT80n1q/8s+aiO7caZdVHOE2qVdkdsW4+6Brxr+u0ecWYC64VRSgWNeTH+YVPaXSTOrvO2a2rGrZ16JSdworC8jyMz5T2tZH/Q7tMdo7Sih3llM4iRApFjhUI7jDXTfarnmtOp8ObuYtAZ5NAx3Tb11pp9rrnt1ccVoc+DMyxGHOB82c/assy5uvPwbzHyvewpBl/y6S4aNkIJMhPDdyq3xoRU3LfxWik/BcejO70OA5niangqMVxB4p8FuodCjfZfDj7VhBCYqd2rPvy8JRDEf5taasqxjvMNwErKE8dBC0jVvdu/JUhBzvaJNLulL91LQAJ1iNifJ6Sbg/+ScoEPyy+cpEeiGoyIs+1Zqp+mYef4KBHNDY9uPua+Uk/SPkKDyoaOffe6vtytpmpjInnwKewqEptpRq86zuZX9Njt8I6a8SzBYW8LVbFZeA+t32y1G/IX8qD50oetrpFRkFLyiXwPhN/znbDONFSmZ4tgm9A1JaQQ1e857M9yC/xarJUNzLAoPlJhU0OEPzLqtT7vDvXfoV0QA3jAW5KnbDkASQdaRBTUZYtvV3nn0t8XpG6IoJFOJ2fTLJIQkBxBes07AlNhh6WQejCtrHwMEEpJFLa9mXuQoXcQhzREt7Zge
 yM0Sx+ru
 VoEzxx+5woIHp/JR1erPV5IRYVdp+Hw1lzIDRFdW6z8xx/8VaZudBKqArhTWQqt/xwHtei1954ABsXY2xaAWnHo6xt3JxIApGCa04TDTBZjIPP33UEVH3M4xdnr+4cmssJdTG4kCeaaETZGQDCJzkqjX3XCtm9/OOdDZ8odztm0N51WnlHosrJo4yPUsKexH6Gu2DqgM/6wpEisi8jCQr5dTCHfSeyCEzMkLMvq2J5lwzrXwWpkP4xVHOQbdxKr5gro3NJ4mQlAzbg8p0vz7n1AjaLbicL9FXw/NctDqCwzXPf0yKoKDychDSt6QnBWzjoWMAr4lT4U6g3Dkny2xCslNViDm5re/pkMQho1CQiKhXN3czg3TNguvCLZDoXXijL1dYaJMggVEbdMirIDCPzsnhYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 03:53:32PM +0100, Kiryl Shutsemau wrote:
> On Fri, Aug 21, 2026 at 07:03:06AM -0700, Breno Leitao wrote:
> > On Fri, Aug 21, 2026 at 01:13:55PM +0100, Kiryl Shutsemau wrote:
> > > On Fri, Aug 21, 2026 at 03:06:06AM -0700, Breno Leitao wrote:
> > > > +	/* Reserve the table itself so it survives a further kexec. */
> > > > +	memblock_reserve(PAGE_ALIGN_DOWN(ppm),
> > > > +			 PAGE_ALIGN(ppm + sizeof(*pm) + bitmap_size) -
> > > > +			 PAGE_ALIGN_DOWN(ppm));
> > > 
> > > Hm. I don't think it is enough.
> > > 
> > > On x86, kernel doesn't keep memblock around after boot (see
> > > CONFIG_ARCH_KEEP_MEMBLOCK). Reserving in memblock exclude the memory
> > > from page allocator. But kexec can place the image there.
> > 
> > You mean the third kexec?
> > 
> > 1) Kernel A hits an ECC error and marks page X poisoned.
> > 2) Kernel A kexecs into kernel B, which won't use that page since
> >    it's in EFI_POISONED_PAGE and memblock-reserved.
> > 3) Kernel B kexecs into kernel C, which doesn't respect
> >    EFI_POISONED_PAGE.
> > 
> > Is this the scenario you mean?
> 
> No. I think nothing prevents kernel B from putting kernel C image into
> the reserved space in !CONFIG_ARCH_KEEP_MEMBLOCK case.
> 
> Kernel B excludes poisoned memory from buddy allocator, but kexec
> doesn't care about this when look for placement for the next image.

Right, that is exactly the case I meant above — sorry for not being
clearer.

Agreed, this is a gap.

Can we keep it separate for now and address it as a follow-up? Similar
to the one covered the initial issue [1] first.

Link: https://lore.kernel.org/all/20260812-kexec_posioned-v6-0-e477887086f0@debian.org/ [1]

