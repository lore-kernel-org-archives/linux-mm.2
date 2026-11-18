Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB3DE606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 00:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G/v5cxLh
Received: by kanga.kvack.org (Postfix)
	id 84FCA6B05B4; Tue, 17 Nov 2026 19:37:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8280F6B05B6; Tue, 17 Nov 2026 19:37:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 765C26B05B7; Tue, 17 Nov 2026 19:37:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 473E16B05B4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:37:08 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4218B405F9
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:37:07 +0000 (UTC)
X-FDA: 85446375294.14.8F2F540
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id B764440005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:37:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="G/v5cxLh";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794962225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4kbBk37SUYvMVJny9GfKjjQos42kqXBJeWxGUOyaU2E=;
	b=v9UKzOfUg4L6mcnQYce1D0DslSSRQ5+7X4IanfaRRGbsNLutEK21UTh6SieTWjp4/b7rYN
	Tm3sxBnDBCcD8VeMPMbdaGosSyE9Ds7D9sNsBf1lZHz6PILD/UeXzNManIG3cYDeDBdO2h
	VGRX7KvaF8mmubQ0wUYrkk+KUje2XWI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="G/v5cxLh";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794962225;
	b=3NOn25FaBSLFjZZFzWBm37sGgaHRkS8H++6sM+isWovj6KAN6o/WoclYgEb+/2SmDS/tFu
	Ta4VhtidzEyoKgUJ7Fh3k3fNxAf+6Kb20MYPZk40zeuFr/cSNHDo+D1mAkdaibBIp09LYx
	PshbHuSMXZP0GcZNQ4L3fDcOZof1TYc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B25E561205;
	Wed, 18 Nov 2026 00:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9419F1F000C5;
	Wed, 18 Nov 2026 00:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794962224;
	bh=4kbBk37SUYvMVJny9GfKjjQos42kqXBJeWxGUOyaU2E=;
	h=Date:From:To:cc:Subject:In-Reply-To:References;
	b=G/v5cxLhB1/dgV5Xl4goxSccn7AlW8fiE46777Hs9OGguTbq4AVahrtcMrkZAxsRp
	 CkHKfhKDSUQozc4kaG/isS8F9+wNaQyf2aogoLhx21hHs75+24Or1WlZLzBhGNN34+
	 HW3ehV/A6A9BGnUJWeBJ68PF/ehdNtSQBuX2yPMcOdnXqvEqN3KOdRvRAakhekJEFU
	 sSFKFCig4yJdhauT0zTrQGVXsNS6DuTpmWJkK8ISxIAp3owW0612Sy8F824Qkt4q/2
	 Ysx5CZst9jrsCyQEtK1PP+/PQ8UkF0ZxMTGXX6i0/ohUyjvAQr3dhVxFO6LH5X5uM6
	 cM+oNRMSrzOSw==
Date: Tue, 17 Nov 2026 17:37:03 -0700 (MST)
From: Paul Walmsley <pjw@kernel.org>
To: Chen Pei <cp0613@linux.alibaba.com>
cc: pjw@kernel.org, palmer@dabbelt.com, alex@ghiti.fr, rppt@kernel.org, 
    pasha.tatashin@soleen.com, pratyush@kernel.org, graf@amazon.com, 
    shuah@kernel.org, guoren@kernel.org, linux-riscv@lists.infradead.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
    linux-kselftest@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v3 2/4] riscv: Add support for kexec handover (KHO)
In-Reply-To: <20261106071459.2003-3-cp0613@linux.alibaba.com>
Message-ID: <8259aea2-c8f7-b9c2-9e31-bb852bffb83b@kernel.org>
References: <20261106071459.2003-1-cp0613@linux.alibaba.com> <20261106071459.2003-3-cp0613@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: c5upj774hnh6h1pmsf943gopxww3799c
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B764440005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794962225-302693
X-HE-Meta: U2FsdGVkX1938GuhMMVz9lcbTh9t26qpaegXr/RB3XqadCJl/NCWfhf3TqozxIpiF7mtutVpQHAr2mFQ9xeVBW4BR/QXoann6kqSeNoBC6GB+jAYW8Xaeiibfo9R2UnueD9YCBwtiOOmugcMWTCNX7ftes4e2SxXUt210DGqQ3TmWHdN7GqX1+W8kcJJvsb6isYEPgptyf2Hn7JNviY8q5Bzf8kOoC3JD/QHXnO4vpW1Jmbek+VfPlldusi4mjjKuhq8hVTia5+jmkeJTM2jTP6r5SJFUaXw2WF1CEPGFNyHJN/krWjASJFbEwIhcJrLsPd0xo/qzTc5QsOUYzhBz2OFqYm+Ao4B9d7JTxImx8eMd2hjafi+NfZ2CVQgvLQdcAnOljumoN3LndcDmgeQP+5ZmGC+Ws71FKenkmNsLglm17xMC1yR7TEFNSZ6xQcYQh5BYhBPHYLn7Li+Q1r8vofCYU4Cahp/3I8SD48BvZX7uvhMjOOrvvVQfAtWUYV6BpQEifm/ZbJ5VY3xy/OpUyncFPtJ2uqf9d7dk79+OscFqMcqNRUJSa7UXO6Bw0kN/uVX2Tfo+rwduSz86rEaWEs7CrZNajaPL3VcFh4W+JaGx4ISlFbRFhJoNrz41NTEl0yuw1C0knqCTX+b+2JKcp/CZmgXEF+7QQ4DZnkfMm7mfb5Jw/2uTzvrcBJWe711diw3gpkPG9gn3sEWCafaqvjvT8zGxAjHCLxJZgR5b7jyFfyhh6i4XegiM7aO46iwihZZknfNUQprx6Ofyyy+qgcNrGvm7AJTxBgeyj9Fy8Eqk3dnEeNBBBWae4wOyrxDn03+hyOpDvm5CIgOT97fqQYpAIbPnwWSSQuzfOJ14f1apnD/K1igZbOyZJXAV34swuEjU13kSbN5RlViRGtBHdR52nk5Q6dvVllRhmtBVDMgNWy8TRBfIptZMZD675izOprH9dE1IvT8H8XbvuF
 ENSAMxHX
 iuHGqxBEAb/5Sgg0ieAZFX6hCV+nF6QtyqURF4mAkpM0OUznJ+epLiX8yvA+wQPuQR007eQ5gZbLf4lzEfLBx4ZQXldHaBDsPWQQbnwfnwr4OwBlY7LUGWi/quIjEtr3cUhou9iqtGC1mkxarLDybmPvLeXu2RJl8wmhLgrI65v4jlMnpCYbR1NEKMssKk9/iPINXXDceALSzI9JbA1x25tf2E7e8VP+JiOdS4l67SUQlNgswxnSgNx3GEhk2RRHa1WoOP8UNNHqw87QnkSGyz4CkrZoqpgf/LLaliyGtoeEfhAc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 6 Nov 2026, Chen Pei wrote:

> The generic handover paths are already in place on RISC-V: the outgoing
> kernel publishes the handover FDT and the bootmem list in /chosen of the
> DTB built by of_kexec_alloc_and_setup_fdt(), and the incoming kernel
> picks both up while scanning that node. Only the architecture symbol is
> missing.
> 
> Set it to 64BIT && MMU: ARCH_SUPPORTS_KEXEC_FILE is already 64BIT only,
> and KEXEC_HANDOVER selects CMA, which depends on MMU.
> 
> Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>

Acked-by: Paul Walmsley <pjw@kernel.org> # arch/riscv

... since MikeR is planning to take these.


- Paul

