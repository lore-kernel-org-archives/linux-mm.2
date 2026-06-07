Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E87BCCD8C8C
	for <linux-mm@archiver.kernel.org>; Sun,  7 Jun 2026 17:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E9A96B008C; Sun,  7 Jun 2026 13:59:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 373756B0092; Sun,  7 Jun 2026 13:59:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 262BC6B0093; Sun,  7 Jun 2026 13:59:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 10D7A6B008C
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 13:59:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CACAE1C25F4
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 17:59:48 +0000 (UTC)
X-FDA: 84853879656.13.628EC59
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 20A4E40004
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 17:59:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Id3zNGSu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780855187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p13qmOJLATrPkWrp+bXLKA89GU/CFXpglcWbzZhweFA=;
	b=jqF1HaITI+xiaO3XlFJ8a5KaYnagViIygAritxt8wEYLbPeEEDhX/+G/2u0yEigX9+b6v2
	9O/iF4Go3fu1XPUYJuAK5KivStDHLW6qKwTL1TEtuQbXVTylw9HTYjnyylWe3cD9T9LbkG
	9LCVokqiQiId0oSF0fH4p9gRERM45RY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Id3zNGSu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780855187;
	b=26Ni2DoEOXJaIMKBvpa4fOVKy7u1wfY1AKY5/MgoAQpuaEG/S+J/xhJxLGi/Ml+jq05KjR
	Wk8kG7LtNMJqUMM7JPZ/c1pSxOqEn2McRReoKEJ25aC2XWVE+ibAyiiDV57nVUfTczR/WW
	nsFGxX7lCjMusbhC0299IVsDU1mIQaU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1416F436B8;
	Sun,  7 Jun 2026 17:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78311F00893;
	Sun,  7 Jun 2026 17:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780855186;
	bh=p13qmOJLATrPkWrp+bXLKA89GU/CFXpglcWbzZhweFA=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Id3zNGSuQQrCyIBS1HT+yPq9MzOB1URA4ipc2w9gwWuXsYJn+RSzuj+IRWSYArMz/
	 r2bAdENTeVv0i296ZT9xYlRvUGSy/MYOg6/1g60IR+s+L+Z+6wjl3Wlv27sFTA+ZHa
	 g+ku3trRQZyP9yzZcg0Vuyx4YrhE77Uy3qJ55T6Hv3trt2dCAmenIsRF5fwiIv5biq
	 iRzVn6CToE8JnrsJWUN9g0yy2GhPrzhWdQIknmaM8x+miwJ8IiaZm8ScgYlklx3qpF
	 ysbiSHI8rHT/3stcctQKFTJKJtX9u/iaa+55KrYHvQ9k1KsqRNPGZym/EjN5c38y0t
	 HQeZuTcMbavag==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC v1 1/9] kho: split out radix tree tracker into
 kho_radix.c
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kselftest@vger.kernel.org, 
 shuah@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
 skhan@linuxfoundation.org, linux-doc@vger.kernel.org, jasonmiu@google.com, 
 linux-kernel@vger.kernel.org, corbet@lwn.net, ran.xiaokai@zte.com.cn, 
 kexec@lists.infradead.org, pratyush@kernel.org, graf@amazon.com
In-Reply-To: <aiWYZhoSOAruIIM3@plex>
References: <20260605033235.717351-1-pasha.tatashin@soleen.com>
 <20260605033235.717351-2-pasha.tatashin@soleen.com>
 <178083348873.1648214.11020626647820932506.b4-review@b4>
 <aiWYZhoSOAruIIM3@plex>
Date: Sun, 07 Jun 2026 20:59:40 +0300
Message-Id: <178085518028.1648214.13339471022594901667.b4-reply@b4>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 20A4E40004
X-Stat-Signature: 1m6gabrbutwz9fyff9hhyk3xx13xtpfb
X-HE-Tag: 1780855186-949690
X-HE-Meta: U2FsdGVkX19s7zwHjdXOOfHzIBboZPiu5SDcy/brE/dmZcxkyB6vzqGMCV290KVPh0vxgBlIWGmsfEUpEDsYlCuxAFzqP9Z/vx3nu1G1J/TazUlyj4OL7CLL0J4b/MjuO789GpHacw4FcnqFFiLSjpeRLBDu4dkInIPlCMwSwbH5Q2GxbGAA25wbd+YTiGC4xppDDC5MIIvI2Ti5U3+pF+c4vC3w+OGIScL9fIlcxJn0C4wPF0HBAAwmi2aWcpAvr5mS6qDnvNYSG6u0UHPPWk3aPNGYmp0oDNuRPnDpB+jH8VTDXcHQ/Ju5JTgltHGl1PVB5wQOB33cBC/8CSCCsE0uPy/UGG8B4sFYE2Y/ygU42RJ02uR5NJ7u8vSUWw3k2nNK1trDLya+Q98ZQzLiBHjRSxGRwZcwjF3MQ8kAR63X0WWCls7caXxN4PjUH55GalX0RBRa7tnKYE1dxGQmQA/YKXnjgrAIbBimTQLXizreCMwwzF/dpCF8sxVh3kxYJFXvmPUQAoXd5Bjq0rFm8RXXKtgffdqiWFq0pGkjTbcBtYuF7btM7apRnDmaHJVVyqPHnZzhlFfY8gBtZfyLqv/gPn0GD2qCTH1D3D3fWzA04sga5UzO4Qqh+Uveq6p5lU8ieoEUBT+y63OX0Rf1QWjViqIF1CkruSaF7S4tJ2rZ+Hz5OZBzlNXee6u3HdIpz4mrGAbsUACE+36p5AqRiHAci53WAfz28b0gyciaORrjDYdxp5LqVS+QQsMrlzMw7kPo4/fmKUhi1QcAKTbrLzycaknM+mLxhXRP49vy5BUvjp09Krxf/cQ6jv5vH5V5TymS/3P5nKBH3aOpz/jmwd5y6TOEhdMxzf8IlgL0HMKkfw1krQUzrg/3V5xAq+6cVMQXx4EgDTBq4RRnAgMd4Fm4FeGnGYGpv1YwYASW/5IoV9uhtrsdksZMjjflNHwKKZIzXe+45z9Tg1yi1tC
 u4zGgxn1
 erfavjR1VtF8obMS+ADMSXCKV+tb/sMUtK3QYUTTsy93l/Apzd59RMUJaKcWpdxLGadFxIVHgSL04+IB/vNFSGfnRCWDFewkKbwwZD+H7DxpRQbNwnlBibndyw4krOi70j/QQHtU5DX3nW0egiwwXhmK5RInmI4EGic85h1qPO8dd3TpqzbIujW70Y7pEf3JozBuGw8FQcBIq4yMIFkwTPj/yrDU3zH5MXyMa835ez01212MiFXdY2+x4f0LdtYASjpLfovVDziHw1+c30URTBGgonI7qZMdUleiGCsJAha20sUo9RROFhZ7YwwCOjlYHKHWJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-07 16:20:50+00:00, Pasha Tatashin wrote:
> On 06-07 14:58, Mike Rapoport wrote:
> 
> > On Fri, 05 Jun 2026 03:32:27 +0000, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> > 
> > It's radix tree data structure implementation, kho memory tracker is it's
> > user. Please rephrase to keep the semantics clear.
> 
> Yeap, I will update it.
> 
> > I don't see much value in moving kexec_handover.o to a separate line,
> > btw, the same is true for luo_core.o, but it's not important enough to
> > change.
> 
> This is purely for consistency. I wanted to use the exact same style in 
> the Makefile instead of having two different ways of declaring the 
> object lists.
> 
> This:
>     luo-y :=                                \
>             luo_core.o                      \
>             luo_file.o                      \
>             luo_flb.o                       \
>             luo_session.o
> 
>     kho-y :=                                \
>             kexec_handover.o                \
>             kho_radix.o                     \
>             kho_block.o                     \
>             kho_vmalloc.o
 
I mean this:

luo-y := luo_core.o		\
	luo_file.o		\
	luo_flb.o		\
	luo_session.o
 
kho-y := kexec_handover.o	\
	kho_radix.o		\
	kho_block.o		\
	kho_vmalloc.o



