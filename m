Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB946C54F5D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 06:39:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 149D56B0088; Fri, 20 Feb 2026 01:39:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F8476B0089; Fri, 20 Feb 2026 01:39:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 003806B008A; Fri, 20 Feb 2026 01:39:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E045D6B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 01:39:28 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9302C1B6420
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 06:39:28 +0000 (UTC)
X-FDA: 84463883616.11.7CF1163
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id ED584180006
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 06:39:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qcs0dJCf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of jszhang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jszhang@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771569567; a=rsa-sha256;
	cv=none;
	b=hLybGWaHMjM2PptrZoKqXVoZVaFSgxGkO126hjGX67yCS38lvjnWdQL50PfWiwVsgM0z9w
	X/1FyFvv3dT9tO+4OJYeJ6hhcQM4LqtOtqxaLU4cN3KYvdRRVIEuK/A8n9otdvCl1rcNW0
	z5JSH/PDzpZMf0D82qlh8zPv65ZPzsI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qcs0dJCf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of jszhang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jszhang@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771569567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G3RaLcbBsYZpw/Kku2JzT3wLKyDfDI2vlTE11UqWozw=;
	b=5ers0q4VK5m2IPTJ7CUaF9gSwZQGru5mZaPxvOp7SD3haGKnR9/7G3bHthjsfUprR5PZHq
	jvluBUHoLIykF9CEys1XUNMZwzTjSdWqANwzJv1L8FzZXv2z1SjaB8DZDpw6J2KkB+qKdH
	HxC83VxXX58i+26YgmdqwV9CAyK1nhI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B9D0244161;
	Fri, 20 Feb 2026 06:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FAD4C116D0;
	Fri, 20 Feb 2026 06:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771569565;
	bh=K03+flrCCAh9UJxfPcPWOWXMwX3CXYJoX3R9jdwQGFw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qcs0dJCf/unZIOC7XlsbZbpv/C3tIqkn4RXaO2yct+95urWJ3BZpYnTjBV7E7LPvb
	 /oiLU02RTjq2nXKnfZcRsXEE8L2v9ByxldwTPXWHYu4XwlShjAvnpZDiEdG9eGgwNu
	 ekibDgwO8HH27G+w09+tWvmgeweaU4eTSHdlGE72nLsP2xIOiD29cze2T/Z1IhIU6d
	 dtva5h9AzPheTIcVbftt63L/q4DQJYT9tNNFTeIMjztulncLuySUkyiX3agryZimoj
	 UPO9uKXSzcD6A3RDODXBUHmJ6GgMeXEVvssmwJ1SkuD1LTIIw4WZikNP7yP9/Rrpjp
	 LWMrvN41V+UWw==
Date: Fri, 20 Feb 2026 14:20:54 +0800
From: Jisheng Zhang <jszhang@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] arm64: remove HAVE_CMPXCHG_LOCAL
Message-ID: <aZf9RsIUh8ARg_RP@xhacker>
References: <20260215033944.16374-1-jszhang@kernel.org>
 <aZY30X9bpsV-nPsm@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aZY30X9bpsV-nPsm@linux.dev>
X-Stat-Signature: 68uc81qaeod711h3k1s1ydr6rbkhbqym
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ED584180006
X-HE-Tag: 1771569566-38202
X-HE-Meta: U2FsdGVkX19OXVRj/1cH5ykOFqZroDR8ceFOiEGbmOeM3ldWxAMahaA5GLYIdCyY/E7eXEQmKfm/jgNNjYBjedmjOw8Id4MqOwIBbZFhxPZ1wg+eClDSTm6zhcKjhD6tgLYh3HIvudXt9lVqoTV0Yh32718Tub1h1MjeGBsMgfy3HcsfUhwVHW4BflYuV20xdw3mKY3sKBTqkfPa2lAP/7EKKQ0aEe5wUDEk4acve/zRNECthxn37WUIgZBeHUjq8kT/kRFx+IhQnSn4MzNEfKjg37Pdw1UTfL6BAOp3lOpO6hUuWj6J4uH13ZqQc+j5zows0mdKKZoKlqwnEK/gsLQObrX09cKxgzSQ5jUbEBiXRqcSEA8QACrByDGPumtaxpfLB1dxBp6htnlt5a2obUqyjsS76uJb2nGXnWNEmkz7AHGWaGuXEPTumGNxmBat5bC5mujblQKOur8WjuCtf+s7R6vZhz8buuREzyXpNDNwTSwinoWd3Gviscr0JhBEHiGC4eE2FIEZUdnZQF1VZgIRnRlgmHFPMAn8EsthA6mdarfcVsq2+8+WvvzVgDNpGMN1k2SS6OcWslMoGlk5v4NysL4qQJ/SAOAeNX2v0wUQi4qg6JzpMkwKAONezjulw+4hmY3NTE0qM34vWoKEgiy4n6RU/H7BfaM/p4JCA/P3d5qw3mU9yW1ScwwDAqxmVlsfSX+xtPIUIhcCo/h1QHLLyzNxq3avvjpJIpJxVPk+0TdFOpxaJ039s0qilWGCuuJBFqmo+M84JIvFQTDjzMe/XcGp8BHHVtzw3btQXJS/wwpfs4yeAnHQ3hn6aaZ5gPQoBDxBPM6gt+wQoNpmXDUZxDl2y39ZtwakOal9XzpVHESk2yc181U1KqMG+mLxraveHsyR7NT8wV9EGTtxea/wje/HnpxlnNHo9Mxs7RTi++jcFZyPsGjMuCo2jxWGR45gjq0foxIR8v9u3r3
 lKAhlBPC
 LN8gnrFRm2u70OBDhN+6sGrLWlMeDC127xCvey9tlsSK7/4oo2Bt/axlrs3BUbCRCg3qKdAAGG8PMVl591y/nR76jD/AaXC9gaMXizu+Nn45PUswz2A4Pdc4jZjZmiVLkUEENqeT9MrP1Yg2JcPDIZ1ghhZZQzRtuiWx/EAOyQ5sNWFtSAxfJDtRDfmDWO5NgJAvGscGcrNOLL6+1u/22z/ciRt8R33H1d03iCLYbl+UMCWfFx1EVXOSubRjsvG/DYlaZPQPI/HvGWZrnSQK2hmpBIiDXIEcbnFT+G0u9Aj8cKt+TlRyPUJElbVSYGByghU5b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 02:07:57PM -0800, Shakeel Butt wrote:
> On Sun, Feb 15, 2026 at 11:39:44AM +0800, Jisheng Zhang wrote:
> > It turns out the generic disable/enable irq this_cpu_cmpxchg
> > implementation is faster than LL/SC or lse implementation. Remove
> > HAVE_CMPXCHG_LOCAL for better performance on arm64.
> > 
> > Tested on Quad 1.9GHZ CA55 platform:
> > average mod_node_page_state() cost decreases from 167ns to 103ns
> > the spawn (30 duration) benchmark in unixbench is improved
> > from 147494 lps to 150561 lps, improved by 2.1%
> > 
> > Tested on Quad 2.1GHZ CA73 platform:
> > average mod_node_page_state() cost decreases from 113ns to 85ns
> > the spawn (30 duration) benchmark in unixbench is improved
> > from 209844 lps to 212581 lps, improved by 1.3%
> > 
> > Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> 
> Please note that mod_node_page_state() can be called in NMI context and
> generic disable/enable irq are not safe against NMIs (newer arm arch supports
> NMI).

hmm, interesting...

fgrep HAVE_NMI arch/*/Kconfig
then
fgrep HAVE_CMPXCHG_LOCAL arch/*/Kconfig

shows that only x86, arm64, s390 and loongarch are safe, while arm,
powerpc and mips enable HAVE_NMI but missing HAVE_CMPXCHG_LOCAL, so
they rely on generic generic disable/enable irq version, so you imply
that these three arch are not safe considering mod_node_page_state()
in NMI context.

