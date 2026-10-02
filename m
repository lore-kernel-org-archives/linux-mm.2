Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BE1FCA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 01:07:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEEA26B0088; Thu,  1 Oct 2026 21:07:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D77276B008A; Thu,  1 Oct 2026 21:07:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C403E6B008C; Thu,  1 Oct 2026 21:07:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A0E56B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 21:07:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7E3DEC05DD
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 01:07:14 +0000 (UTC)
X-FDA: 85275897588.15.20A625B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id A752F160005
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 01:07:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TlGtHfJT;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790903232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2AK8IZM9OOCadsoGaRMWdYbctWhkNoTiiNTA/D93z4g=;
	b=kO5jT//ZLWlbu694/MS8PZ1N0xXAskx8BvtPbNbrtxt35fN8ogEGeYSXJwXAZWGQeVzmx0
	mJnxfjQ1rRTHlNwlEY5al1MqKQdZuMynPsiEvTNHyCRUTpcMIz/+vzg5CWMfhxndgoL4bV
	euDUPLlPdlbw5kezd9XTOvL3XkEDBUU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TlGtHfJT;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790903232;
	b=bki9i1Wqi9iRib4mgO90D+tcfrojAvVyfcxiMT6g88j6A+l15qbBZKCJNgF15hGw0HoSHD
	8rkwr6ax0j/lWbQqr7X+irKsLDM0DGmhIb3wCc9+mpnMOZjfze8PFaloQi2VoZ6ysSm2pg
	nBZ2xrLMzc+HKfJDm0ZIfUgwhJASVz4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1219660218;
	Fri,  2 Oct 2026 01:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8964D1F000FF;
	Fri,  2 Oct 2026 01:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790903231;
	bh=2AK8IZM9OOCadsoGaRMWdYbctWhkNoTiiNTA/D93z4g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=TlGtHfJT7BTCwfl7UgRhCotCOBkzppHZETcMeSBZuLUFP3y9S/xHMT/eRWGVg7sDW
	 CfTJl8T5zrYYYjNZPYEzeEmhwh3AfuyDJDlG8dB6E7O2gWWX8EI6+9w4MXPMUxnhq9
	 55baiGIVQw0377SKq2g/4cdZ1UQoeo0EtjpbtnUw=
Date: Thu, 1 Oct 2026 18:07:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: kernel test robot <lkp@intel.com>, Josh Law <objecting@objecting.org>,
 oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org, Linux Memory
 Management List <linux-mm@kvack.org>, linux-mips@vger.kernel.org, Bradley
 Morgan <brads@mainlining.org>
Subject: Re: arch/mips/boot/compressed/decompress.c:undefined reference to
 `__ashldi3'
Message-Id: <20261001180711.b206ee7ab13a1cadafdba4e7@linux-foundation.org>
In-Reply-To: <ar4050mdKL_W8yI9@pedro-suse.tail5790ac.ts.net>
References: <202609301826.MFaFMsmd-lkp@intel.com>
	<20260930120159.7e4f29a82d461bd8b040454e@linux-foundation.org>
	<ar4050mdKL_W8yI9@pedro-suse.tail5790ac.ts.net>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ywf6ceeurjzo6fnhnrm6itub8akac5wz
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A752F160005
X-HE-Tag: 1790903232-532912
X-HE-Meta: U2FsdGVkX1/p+iKVOh3IbE68zsYvX3jsGgwna1ylN9IxSFT9fV4ehCal8yz4CZL3GFxiKNAEeYwrZcgbBlOid3JGABuqCwwtDB4+L90Zu5VcnCgzE/pDSpZF7lk577zYWJGrE6AEVy+vnBoTiDeVKpf7HJ98OsNbOMv2MNO9DuDsSlbPb2OND9/WlaVAYRF+0sUU187p7ZDXX4IK/HvYhjY6M2ds6AaICXcnbMK0pZcLLu7+i0PfCNhlCsNRGwH92nRySJDOsci3TIT8gq88WYrhYeUbev0tqt3bvba4Ko5rbjKmQU0Kq2M3xSVW7WaGURrc5fKSl4dNcCP7727n/+YHPWsYLcRpS73t9omctZNjQt9wJUiaMC9xnsJrlDUNk830EdBF5MArZ1f7uJ9o29C2KrOvD/50IIyfXWow9BEr0QV39fYU39xlTPG63X7gKnVwQUk/U0p7c8scyhrVOKQoVgVAFbMi73HSliRq63ErQtWH7/siMzNwJHXH5H/yIB6P3r/PmodaMyZ5WPQgPonDZnO3I3tsYt9pIYFblrbIrA5JUMJ+Rir2AqcUkxrL/i2oBtuIBL27nfAqaSPo0WK0OjpO1LVZrUFnV+KFC2eubI2wjprfZeqZbQ+ItYbsRgJBCXuo1/kXVZXn8KQhrnuuDVKCnMd64q9wOzbyLkUXiqznFQG5RUo2knaDF5Rh9ikVBEWw3gl0cC9fiQkt/zfEvJgH+UYZxnP0q+eY1t5A+XuIAAH2q+cZ2AWgaxvGlu+5eVt2MVbxdtKAIKFcbwY7nuh5HzzTJnOHTzPlb87tTx1WerWi/C5b1SSMulsGB8U4QmXYO7WbWAHSD+oqjT4ZiO8XMaiIwGi50zUUEudkrCY49Cwv4Kbv5L1y60xQ5QgNzyZTKKNEgJ4QaZp3UgLIGAXsXdx4q4lON+cTfs31WcuZS9VSQAkGC5jSjekPbioy7X5Vlw7rx2VPPoU
 z9vIleKv
 eyztfUEfiLGLsWuGVvZSPqPF175UMHavAU3dFz/vvy7tAaHjGKGhRrrXu3hsFV0bypYECH3coVi+nQen79jdFhDslty4mujvhhY4XMLicG3b1mF8Lwbu3TbICnxweoexKq2QSHy0C+t5lsIwmzGgU+4qvq/BS7a7gU6L4mbStPUxViv4SU0gxvoRVpo3YF9dhX6vdUrArmMuCz9zVogItaIbD8pDMYm+4wJXsz5rxDZC9V1gyIL1zSZrOsiC1FtQBuc60/Wb5e+Pi+EwA8CsvYk7qdBkXZbqjdWAElctUxLEKnao=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 1 Oct 2026 11:30:09 +0100 Pedro Falcato <pfalcato@suse.de> wrote:

> > -	bits |= (bd->inbufBits >> bd->inbufBitCount)&((1 << bits_wanted)-1);
> > +	bits |= (bd->inbufBits >> bd->inbufBitCount) & ((1ULL << bits_wanted) - 1);
> >  
> >  	return bits;
> >  }
> > 
> > 32-bit MIPS should be able to do this?
> 
> FWIW the patch seems entirely bogus. I don't think you can have inbufBitCount >=
> 32. If you could, then the patch would still not fix anything, because
> bd->inbufBits is an (32-bit) unsigned int.
> 
> As per MIPS itself, MIPS does not link ashldi3.o into the decompressor for BZ2.
> It only does so for XZ and ZSTD.
> 
> Changing arch/mips/boot/compressed/Makefile would work, but since the change is
> entirely wrong I would suggest perhaps reverting?

Sure, thanks.  Do you have time to send a formal patch?

