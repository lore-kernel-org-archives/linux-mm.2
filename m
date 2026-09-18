Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12275C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:42:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EE526B0098; Fri, 18 Sep 2026 06:42:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19F386B009B; Fri, 18 Sep 2026 06:42:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B5686B009D; Fri, 18 Sep 2026 06:42:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E150E6B0098
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:42:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3CBF91603A8
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:42:51 +0000 (UTC)
X-FDA: 85226544942.02.33B9826
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf13.hostedemail.com (Postfix) with ESMTP id A07AA20006
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:42:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="nK+0EYK/";
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf13.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789728169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ak8nh2SAnHlrH5Gov+HSivc8cOu/u80U/J5TpC+xpEQ=;
	b=ObSpgimnzFflzJhZtkUeToeoS96POBnC98xYuS0gYLS/GxcMBy8Kv+1VQgZvZEiPDRXtUR
	XP79JtUMpEQdv0BaRNKAXGLOyo4V3yECwqZ/nPdUobSg/+No6IROO/gzjzVLnhb5wknWyL
	S7W4g7MSwcO02L9f7xj0QnAwXnutE+M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789728169;
	b=DXyKjCOD/VsKX7ehA6O59Lu4jaeEhDvH3sti6f/5PSdP1WKj0zcXs46CxVl4/w7zArPp/p
	IrGLnsnnaUEK3ZLQ9poic9x7cc+2i1a2MYdqs+Y0E4jxxnPM831jCtYrm7hpv9wdt0CfWW
	yL1eT9nFwicA6a6vlcZF+PCM90baKXA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="nK+0EYK/";
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf13.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ak8nh2SAnHlrH5Gov+HSivc8cOu/u80U/J5TpC+xpEQ=; b=nK+0EYK/9BTfAlJwWP6AvOQJLF
	c15I5JymFF9K2yedwWqzusksKy4eQ5viR8nw3qriMok9WWjsTGTBJqyX7vUZOYQXAgOrEVMbNrZuv
	mjim6c7AEHBA7MnJy/903HNCuWnYczSfYXW5QC0F/OBJf0dY7ju2961gPIkDrOT5ExmqAFKwzqxcC
	XiYLMxnLjQ39eErgrwFWiMno2NauveXgtxV+dkki815BfVZ5ZzLxKpclYHT585S62SVGSmWuPCJin
	9MSZjVXwRNN1boS/jdHCenBQWO8ruAfwzANSV4/t21AyyOLxCm3iTBm1RVzeREYUe38b8ciyJaWu7
	GijK2PpQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x7W1x-006f1D-2W;
	Fri, 18 Sep 2026 10:41:22 +0000
Date: Fri, 18 Sep 2026 03:41:09 -0700
From: Breno Leitao <leitao@debian.org>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
	chenhuacai@kernel.org, kernel@xen0n.name, maddy@linux.ibm.com, mpe@ellerman.id.au, 
	npiggin@gmail.com, chleroy@kernel.org, ritesh.list@gmail.com, sshegde@linux.ibm.com, 
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, 
	hpa@zytor.com, gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, 
	akpm@linux-foundation.org, baoquan.he@linux.dev, rppt@kernel.org, pasha.tatashin@soleen.com, 
	pratyush@kernel.org, ruirui.yang@linux.dev, kees@kernel.org, thuth@redhat.com, 
	gshan@redhat.com, ardb@kernel.org, james.morse@arm.com, yeoreum.yun@arm.com, 
	sourabhjain@linux.ibm.com, robh@kernel.org, coxu@redhat.com, tangyouling@kylinos.cn, 
	liukexin@kylinos.cn, guodongtai@kylinos.cn, maqianga@uniontech.com, 
	zhangtianyang@loongson.cn, blum@kernel.org, adityag@linux.ibm.com, chao.gao@intel.com, 
	kas@kernel.org, vishal.l.verma@intel.com, seanjc@google.com, piliu@redhat.com, 
	jbouron@amazon.com, me@linux.beauty, mclapinski@google.com, graf@amazon.com, 
	bgwin@google.com, eric.devolder@oracle.com, hbathini@linux.ibm.com, 
	takahiro.akashi@linaro.org, lizhengyu3@huawei.com, palmer@rivosinc.com, x86@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, driver-core@lists.linux.dev, kexec@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v5 00/17] crash: Rework and add arm64 crash hotplug
 support
Message-ID: <aq0UR62q6gGJUQ49@gmail.com>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918100442.3841135-1-ruanjinjie@huawei.com>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A07AA20006
X-Stat-Signature: unzcyskupogde4unofbfn9ckgaxsiee1
X-HE-Tag: 1789728169-343923
X-HE-Meta: U2FsdGVkX1+C2Xx1BTxpO+z1KX4igynHhId9YVyClNAZGp7Iu+PuJcl1qxgcDoi9YTkoWShpuxeH35cXgWeQiFowUoyBV7LhenmU28vFyt5OvhBEmnmIeYNdXNzlp9cnDX9olnQGs+Ny5s6YkvaO8t4UVqDi4vQyNOGAFf7p3eTDkqRSAgHIJBoCcEizCoRGabRcf86ZRdb44NG2weZYtHOOBhNQArqXozyy/cW3u17L1W169ij7/nljZuOUfnwryv6V6w3gL4k9ssTkNr11xcEDN7RM94kikeRYr8JCUmNMK4yvzzju5k3g/FNjDCVC1sF88hv2QLcmKgSVhPm9dh6Of2mbNoCOqBFwSWw/X5nvXzCXGtvt4ByiqkLnzjTD8+tKRg9YV06/Qg68ed6MkUvitYJkwav7aXherxOJVF7lIq3EQtclcC8mq/vOyO5PA6szgm+/sLfncvktc+tJRibXl2HYyYFeADv3uMAIGSdHfnnahTx/zttuFg84RZwPkrRkW8zMfQ7yjlxaETkPnV3gKjJKARW2gwnDKRebXqCwlaWJbOro8Fr4jLejEr0awNAeMekMedYr/C8ccP4/VV0urF2frXp8rpABfSogc7Nmz74wDUNfwgJVhnyeRyqfobwa00p8eXJn46tlMbEssB3F7u+W9IRs9/QRLyjkmnRAkSDMpwvFTpTPXPu+XetRxL1WgixdBec5nWBa9uZ7D3wr9+ffzkYGrTfS6JBY0HeMrV8Ww7obQwpbqpNE3LIKcvFScw4UxAhpcaw2Z+sFpIQe37hCjKjVPE/1zJ3t8JGIWAnIZwpAx/BoCDP2vcKp4oPa2Wqu+RaG7L8TnIPV97+LcgTdby3Dt/AgGRFTkhtmfdyoc8lG5b+pXkkf1Sugy7i+CprKBx98y8kOpg6/tRFPRvDbvek/aUBYpak8IuOaLPtfl+snxsHi50s20Chr2UAuwmCBprt5hMpCox5
 LyS2OVdk
 qYKQPophwJVYgn8EfQDNimKYmOTPBWxVeKEorqAIH9vJ+FRbMFv5sYUMlePpzCrLRHdxNZMUQ0vk3GGQx7k3A9+7MgMVN8+wnmfjI5xZ41D2/jmaGJT5evfiz5mPkt6f9ft0dRDXZ0qwMOhHaSx2NTm4QWvNa/UpNbEBxED8keNKsvQUKiZIIzbmA107F9ryJNlBfAIdVA0JcSEWW/qbAi2RhftPe9dGnoUrPyEUEnTjruSkaFGzHwHzWolbIXWsA9t9QuD+Bqv1zQFKbWYoRsM41y/Bf1LztxZ5axuI/9kh72UDKvOiBlLl32tmHbK3QHrH8HWwwhrq/Qns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 06:04:25PM +0800, Jinjie Ruan wrote:
> When CPU or memory hotplug events occur, the elfcorehdr in the kdump
> image becomes stale, potentially leading to incomplete crash dumps.

Looking through the series, it seems to mix bug fixes with new
feature work. Would it make sense to split out the fixes so they
can land independently, and keep the new features as a separate
patchset?

I'm currently rolling out crashdump CMA across the Meta fleet, so
right now I care mostly about picking up isolated bug fixes. As it
stands, it's difficult to tell which patches are fixes and which
are features.

