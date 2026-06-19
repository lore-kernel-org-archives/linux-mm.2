Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97EA3CD98F6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 10:59:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 712156B008C; Fri, 19 Jun 2026 06:59:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EA3C6B0092; Fri, 19 Jun 2026 06:59:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FED86B0093; Fri, 19 Jun 2026 06:59:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 33DDD6B008C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 06:59:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 92680A03FA
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:59:04 +0000 (UTC)
X-FDA: 84896365008.08.81B08FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id E9A74180002
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 10:59:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gsdvNACW;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781866743;
	b=5So2DjmCfKIfeGLelRshglFZaru8V9rPe8qG34N933ehxagsXpwG/ThKMfjfQ9d3eE7dQx
	ioAgeEX5lO8O5rNmhh1QBynIZAOYoqghcpuiZyiuvA2R/TlgUkrg5RNLWTNNRjxQmOLnV8
	a7939aXWdHHoQ6j8IcaxEJ4SE19hrqw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gsdvNACW;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781866743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vwdODZErkmq9zFiN5f+/KCnxhZZSgb/Gucmnhz4o3/8=;
	b=oMtrMvMzeWLyKEO+pRwVxORonQZ+PPas8pENQX+aTpvH6SmAnsgEuJ5Fk3xPzVVNeLV9Ty
	5KPtImI06Eg4+LTJpBZwV3Uoxqy7fYe3n4zKdTG4F9zu+ut0xyJIOkvKhPWIRGGRkEots4
	pCM8USKqx/gIOmPw+FW+dxfoVkhTuLM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5FDE0601E1;
	Fri, 19 Jun 2026 10:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE321F000E9;
	Fri, 19 Jun 2026 10:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781866742;
	bh=vwdODZErkmq9zFiN5f+/KCnxhZZSgb/Gucmnhz4o3/8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gsdvNACWZjgB+tnNLYPZOc5Vad1o0T/5N1Ua+tRAbo4pammFvs3vGp4FBb1q5HB+n
	 RirBUJ64NhS768KtBjmg0+LPWHzLEQJvsPf8+meziUJtOisjnktkkc8DUg7r6ajXHY
	 8KwU7V9FEp6vMTKUDfhRJnnYP+ik5QQ7uF3xHY51Cd+RlPQKPoK6BVwBL7QzxUoLWv
	 cY7AV/R5X0ERcW6+IFW57TDGW0owu0PxXARcSF4rJSwKp1fo6CHphFjRo4QETGpNed
	 qK09b5ncbrFw/GbAw/uerjxFThoZPz2rJald1hBy0GgTCwPUcga0F8ICXH+cZ7Xcxi
	 J1fsp/SzncFJQ==
Date: Fri, 19 Jun 2026 13:58:54 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, David Hildenbrand <david@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: [RFC PATCH 4/6] arm64: mm: add helper to fill execmem with
 trapping instructions
Message-ID: <ajUg7gzX-F4Xg-5R@kernel.org>
References: <20260611130144.1385343-1-abarnas@google.com>
 <20260611130144.1385343-5-abarnas@google.com>
 <666a981f-44b6-4c19-a641-c1eff44fe54f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <666a981f-44b6-4c19-a641-c1eff44fe54f@arm.com>
X-Stat-Signature: mrbasaa6sy74iw5gowd4hemretp1b64b
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E9A74180002
X-Rspam-User: 
X-HE-Tag: 1781866742-477570
X-HE-Meta: U2FsdGVkX1/4u0uSPp5EnSGRST0ClZhESYVMQMZIOg7IQXMrQDJ0WDgkTB0MKm5/r98jORfkwGE9OpD716u4VEckM6VU4h9pk3kSFpSmjZ/8IehzuUg9dhXtl2697lVgFYhDvJ2kBuNkhV2en6HghAubtOojfbOU2COGONiZi2R1jt9k+JiirTnSk+QK+bl5XyMy9oCjVu3FeZx2dJNwjU/4ZYh74Js8nhizx5uxiB6pT87icpAd2DHIqiLynPoDFbjQ6kvT9egQhWyTgGFA/avoVbHAUCC3sKp++LsZFOvZ9WdTesQdo1LBqT8AWq4UVg0rAltHM6zT8PRlUrN1Xw3Xqr074P6vAOyNnJmez9TZ+tUkK7jPuUWcZabKGRuAqJKEM9D+RCptsWZ9mQ/JkhMBdMMgDvsn+lz4ihJTM9JFBg+V+kbfrpONjjQve3Ysod2RNhMKHtwsusNYv+dkX2pBOvFl2eEMi+8NL+ZNrU6Q6+ehSMeUPGnK3zgXiycvXcUSzB583+aVp+QZN72KqBt5rNHhuyg8Co/Z8kK1vhg3/qdwtUDyhp07zYJPl1GemQtMd9bGcz/rl2YVk6nafIph+sRbucVGeKEWgna8Y7EtbsIddrSgSH9jFvjIBeeCfUKyad7NrkXQoDaz4hxFMJabdClRImzZ+Bw8f2cwKuiQh4L9d2IOCU1A8P94ytKKqN/Onp5Kp5Vp8eRcWXz4Oa2BomfAYqOeP0PKkJUltaj7sTCVwGaQ1dqujNagVNX3aPfaXD7f6T+Z0ruTx4fUDFvnXw2sTxI23glRsG15QraQr0Dptcv4BxEHBirxHM3cg+Ox35DlkLZtrtgkcr0fQIqT7frUxojHjvSDf+78OKOfxCpC9HmswC9JeNvuBYSAu4n5lLZNaLi0KL4iNP/VMOQMmTBQDAJ0P2J6OuwFNL0UtVvyrBgSLYlGeo7P3vLOc3E3EYf77tv9ppHakSi
 W/qsP2mE
 lV26jxvcIQC4LQqeLNaHaCfyEjjw3fub4fECpUr5/IIQETPNoNe+9tJLwDU/bHlee6kc0q5fPDJm51gFfXC/DLHnSagF5uoWSCvS8GxJVBc6hXb527F1HN7PgRoMaWca4adahbQBd8UVG6iDeUlJPv5cE2BVobYJQCPTS4h7k5H9OQCDRwpC/vEsuZzIBCyCKjCwn3OFNszGaPrltBuI3z9kkHvQtX4AZ1J1TtD1O4LCn4y+RzRWWmuGmyPe3P+HMxBehUQxk1+fj/RgRIxddwFqMTR/xJUlTQg8vuy3CWFRFCKo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 11:54:25AM +0100, Ryan Roberts wrote:
> On 11/06/2026 14:01, Adrian Barnaś wrote:
> > Implement the architecture-specific execmem_fill_trapping_insns() helper
> > to poison executable memory regions.
> > 
> > When CONFIG_ARCH_HAS_EXECMEM_ROX is enabled, the execmem subsystem
> > requires a way to fill unused or freed executable memory with
> > architecture-specific trapping instructions. This implementation fills
> > the specified region with AARCH64_BREAK_FAULT instructions and flushes
> > the icache to ensure the traps are immediately visible to execution.
> > 
> > Signed-off-by: Adrian Barnaś <abarnas@google.com>
> > ---
> >  arch/arm64/mm/init.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> > index c673a9a839dd..71aa745e0bef 100644
> > --- a/arch/arm64/mm/init.c
> > +++ b/arch/arm64/mm/init.c
> > @@ -408,6 +408,20 @@ void dump_mem_limit(void)
> >  }
> >  
> >  #ifdef CONFIG_EXECMEM
> > +
> > +#ifdef CONFIG_ARCH_HAS_EXECMEM_ROX
> > +void execmem_fill_trapping_insns(void *ptr, size_t size)
> > +{
> > +	int nr_inst = size / AARCH64_INSN_SIZE;
> 
> The x86 instruction is 1 byte, so it can exactly fill any provided buffer. For
> arm64, the instruction is 4 bytes so we can only exactly fill the buffer if it's
> size is 4 byte aligned.
> 
> I'm guessing that in practice, size will always be page aligned so we are good?

The size is always page aligned:

void *execmem_alloc(enum execmem_type type, size_t size)
{
	...

	size = PAGE_ALIGN(size);

-- 
Sincerely yours,
Mike.

