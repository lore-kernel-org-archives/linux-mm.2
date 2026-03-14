Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5FD9107BCD1
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 00:40:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC15D6B0088; Fri, 13 Mar 2026 20:40:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6F016B0089; Fri, 13 Mar 2026 20:40:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7A6D6B008A; Fri, 13 Mar 2026 20:40:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C54616B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 20:40:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 63FBFB9169
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 00:40:22 +0000 (UTC)
X-FDA: 84542812284.08.EFD0638
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id ACC848000C
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 00:40:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SymjV1g9;
	spf=pass (imf02.hostedemail.com: domain of nathan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773448820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F1DDtY9fjmpKBpmubkSHsVzxzirYmZVR7AyKdOu0bEU=;
	b=CZHXW0Jezt19++aw39j6urMJc/UensyFYpoqzyU7vLOFESbmYcZF2a2PHVcFPvMJq7HNTw
	zyp08dAoQnolfKYhCfyafyvcpYDiunAjor1/eHYTrGTZprHYBoa3TzjzdpZSgu7FOMbWNX
	cfiZ8bVB1NGDW4S7FVJxSQthCeYOyyI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SymjV1g9;
	spf=pass (imf02.hostedemail.com: domain of nathan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773448820; a=rsa-sha256;
	cv=none;
	b=uusu1qtkH62yFx6uDaNLvX7zALKLfbYmCpGn+6xuI7knYS4+gjmbKFZHab7v8VGJQQjrk1
	xtQST4WodzhQa62olO1bmZwya0xzcXDPfcY1Honp2y0QWE33ORmzQOEi99RDfdfO8Zqd4d
	VNOepbfgDNm2SG9+JKaEXXgcRzaWgdk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ACB0B43A74;
	Sat, 14 Mar 2026 00:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F20C19421;
	Sat, 14 Mar 2026 00:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773448819;
	bh=0gr9KSxldAsVL37ewdEm7gS+QwXkMqtMYEStjECI/A0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SymjV1g9y9ackIFgNet5bLgMQiyOi+sQJ3HWOAAavOgS556/ugt+dfQ6Wl/j1jzc8
	 Tm87cle8BQTjx1hOok2oZek/8PSILyrU8EaUm1CDgBGexy+w3hbhdYxgLYFBXlJcGm
	 xQ4/vGTpHXi1lLJMWPqrir6QkVZVjMYdp3R7oZrrV3TRfd5O3bouY9utN6q2p3OrH9
	 bA1J3HOjBlmxaSdTsY6Y6uOerD+hwaRY93rHxGCzwWuvk4Jt6cMQAPBPlLRnpATnUv
	 zDFR7eI4UJ5e+bfXP5qKuS0ptUR2JKTATZ1bd54cYt3Ow1OSpnduBdc9czgQHEr4ig
	 M7Xtxnz3uxMjg==
Date: Fri, 13 Mar 2026 17:40:12 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
	Matthew Maurer <mmaurer@google.com>
Subject: Re: [PATCH v2 3/3] build: rust: provide an option to inline C
 helpers into Rust
Message-ID: <20260314004012.GD534169@ax162>
References: <20260203-inline-helpers-v2-0-beb8547a03c9@google.com>
 <20260203-inline-helpers-v2-3-beb8547a03c9@google.com>
 <aasPsbMEsX6iGUl8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aasPsbMEsX6iGUl8@google.com>
X-Rspamd-Queue-Id: ACC848000C
X-Stat-Signature: jiek6rcrbwyaoi9fi7hxdbaem8p8cdup
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773448820-398164
X-HE-Meta: U2FsdGVkX18hK7Vq4kZVpJftwedtwyjS6OvnqOzY5YHddJGFzGVrwRjjaRYQXbsIZowe4zS1EzxN5mOneLd4I+X642d4AB9diV1wKs2VB9hnE4kSMeP/dJx1dpucOYaT3JInhfwOEtfEKUZMNwuUjk36S8+gjfgIFHiPQG+7hGD1F5OJezJaVcA17hcscWh2r4f48bBaOJ8fVl+aHjY46h4wy+366CL+eNqs9T7bH0nihfMpp23vkGZSePhHAvs8YfE86MG0hh3SMHPyM5pntXasrDd+VW+jYqp4OA7PwSqjyf1dRxB/bdbN25VNWWoOR234MkxlI2Y6zg0sRTpYADtoB7EvYXELVsUMaSgijNOS1b6uOFSku3OhsmLZOEI7MZjvhqz6aQy4CbblCyV9TSvdm8iy02lbREVK8dUdPHalxQ4UWpJvJa2zA3VO/GUjmBqG22Fg9nMYXcAfCUBH3C3/x6zN66GBLj2NDLjeeuwRU/N7M4uJVZKryrgHqh4dmvtnKWar+wwmjIGGEDmXG2Wu2/vnoOY/sYRlTRbz+Q9v8fIfrKbVgQJXvrQYS8zz6lv/2N0Wos+xnTThGoxrVgamyImRAPJaWkbxbLpPUy93rBm2wrRbs+GV2PB/GY9ngZG7ZssC1SeG3Kix0qb9gvud2Akn53LAhEhRFg0tb/cNhY6ZRxh9cs0NNflpXRmwYgjT5C4mM8dsayeRU20ajMVWvhJ1UHhyQwPOPOHEMX9L3HZYggddvD8V96gvWO6hIpDmmlQOb64VdITZ/EdDN19cEqZSOPY9Zlw3/qQfXC4yWHGr0xXzaYmcbQE9ORzYRlPXXp1xXWQrnW+SNSLYDaioLFU0oHtmc6qWHIiV9AnXAbioTYrf4L+lKDnxe6sdSJJHzYbPG8iS09iId+3qFZmms0UBRtsjPWBoeXpV55CB/2SuzCSXY+m8t71dPbiSqcFs14rWFLD7bkkG49h
 +etwJsPi
 kVKsOEgSmvjDGfBm/hlzKeMJRqMGZYSKyC3GIFzhT9FCCIe3uVkPa+HjNrhP/sf5tyej9uKO4nHuvcAx1hJurFs8Q5cvy7PPSSQOKpnwN1iWVvvVIx7Y/kwTueyFOnAJIC1uUDPLgHjFRMBt16czHTnz30cMCPQiv2IgeTUsS/GECZd2zzuzP6luMU5AkzypqhIS3HpQ6Cfa6x0yXUPaSKAdAQ0u+zGsFs95sO2jTSL8VwrCmuU9bnPIf//7E2A0yNdWuVYv4aq2DDD//7HugHwfGauGYa+8Pg3vvQ+b7U6Dpa2T+2XsuxudRHXByY8qh1/Hd0+a0U80ju7o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 05:32:33PM +0000, Alice Ryhl wrote:
> On Tue, Feb 03, 2026 at 11:34:10AM +0000, Alice Ryhl wrote:
> >  $(obj)/bindings/bindings_helpers_generated.rs: $(src)/helpers/helpers.c FORCE
> >  	$(call if_changed_dep,bindgen)
> >  
> > +quiet_cmd_rust_helper = HELPER  $@
> > +      cmd_rust_helper = \
> > +	$(CC) $(filter-out $(CFLAGS_REMOVE_helpers/helpers.o), $(c_flags)) \
> > +		-c -g0 $< $(if $(filter %_module.bc,$@),-DMODULE) -emit-llvm -o $@
> > +
> > +$(obj)/helpers/helpers.bc $(obj)/helpers/helpers_module.bc: $(src)/helpers/helpers.c FORCE
> > +	+$(call if_changed_dep,rust_helper)
> 
> I think this needs:
> 
> $(obj)/helpers/helpers.bc: private part-of-builtin := y
> $(obj)/helpers/helpers_module.bc: private part-of-module := y
> 
> at least it seems to make a difference for AutoFDO.

Would

  $(obj)/helpers/helpers.bc $(obj)/helpers/helpers_module.bc: private is-kernel-object := y

work as well? Presumably, this is because c_flags only has the AutoFDO
flags when is-kernel-object is set, which is only true when
helpers/helpers.o is a part of obj-y.

Cheers,
Nathan

