Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E44C606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 06:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=f3kI8JMu
Received: by kanga.kvack.org (Postfix)
	id 0E8936B05B0; Sat,  7 Nov 2026 01:21:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 074526B05B1; Sat,  7 Nov 2026 01:21:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECA196B05B2; Sat,  7 Nov 2026 01:21:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C471A6B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 01:21:36 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CCD231602AB
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 06:21:35 +0000 (UTC)
X-FDA: 85407326550.28.8E63F66
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0871620005
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 06:21:33 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=f3kI8JMu;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794032494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rue7DrFJizzJaq9mJMBOWdT76HmG+xTQGYkTLJeaIcw=;
	b=TLgzbMsowblnN6Z2YjtUS+twWqM1sqFlzwpOuWuoMuetY9lkCzBxQUgg7TatTSi6dAtRj1
	vBRjE0y1u+PYCEvHd5+DjalxIzHjK9fq47X8HgmsqerWnRY1Xb2lnkSW3h8VFxy7oZ8+/C
	P56OgQCjI8PAOzdMqQc8we6CUI9QgtM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=f3kI8JMu;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794032494;
	b=ONVs5Xy+GbcwnlO8Vs+XyiaPe2UBsu9ijZKXOmBOy2ly6dmr1UVbEP+HKTN5pgUByxszeK
	debCqFByuPlBU7tfK5eYWffkOAj5o2GCWflqCXvxidxv8pxR0qwT/75Ai/wrmfMMtS4+Hq
	wsdyJlqnHtwk7DkcJ3bpkfF++0W65zg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B03D60E25;
	Sat,  7 Nov 2026 06:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02801F0089F;
	Sat,  7 Nov 2026 06:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794032492;
	bh=Rue7DrFJizzJaq9mJMBOWdT76HmG+xTQGYkTLJeaIcw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=f3kI8JMuI2gAX6UrdrGzy9z6n4NuTB0jebBgdw93BDOJewkqBm84gwaRIeWmJ18hn
	 50WNn42R0DMvWJVVi2AZq4qwJGfr2oX+ajjqf+xsmkg6kJz23gcQYXe/ySEC9qpW3R
	 0l6mS0KpLjx6LhNIaYE8b+zghg132qOtdni6G/D4=
Date: Fri, 6 Nov 2026 22:21:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, David Hildenbrand
 <david@kernel.org>, Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>
Subject: Re: [akpm-mm:mm-unstable 225/232] include/linux/alloc_tag.h:159:24:
 error: duplicate 'inline' declaration specifier
Message-Id: <20261106222131.6fdd74ac14178fbe4470e33d@linux-foundation.org>
In-Reply-To: <202611071330.7rHbLZ6C-lkp@intel.com>
References: <202611071330.7rHbLZ6C-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0871620005
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: onatewiuhprr4gkga59za5dnjs5e5sxd
X-HE-Tag: 1794032493-542598
X-HE-Meta: U2FsdGVkX1+pkPiBzlpTE62XQyuSkDHBBge6jvQ6hEO0fmG02+zlSMNv6w++fnofmMtRF2YBKfE8erBrUvV7YNN7MB+SpiCg3EbfKiICpROYs7/MwBnj59HYUxHRbpIGaU6BGzTFZ2ZZmih+mLP6Gc6h2hk6dyIR3+P9X6OcDiUEvkUh678IqgXOVRI55o99aI/Hm8T2oMWy9jI64OQbiatsZWDgzWNKOFjnvl6D3gCYxnE1NIpnra8JTFhUM46upNIn6TE2McpCTKC4n75mQ56Hpo1S/+X+5u08NR986QfibcmijwWyWUFPd6QITuC1CE9Z37UrDqDvVETzN+OrGV7q4nrBIm0s89c+LGZPXvNPsOf7lAAJR9v7+aHbKKEkBVI/xwfN8zM+VoL9if+QaPF43smeMW+IUu/jyLTqxmQaCfTVhzvA8FgB5jLN2qvzynuhjTGMv2EdwjBaOT74yOEFx662IzpK560nhnlq06iEihvnm7YQgX4IY7MUJB53D2/kbjY/K/7oVwM2UlD4A0uW7XTzPZwaA/wYFjEpXuFMvRXclrqyyeQx2tA8OjfPisbuNlQSS6RUIGeGVrICIb14ZCbt2dmTiuASsunwnHpU9QRAZ4YzJaYDQV57NtOmy2TnGQQ/N4ufo42Fdq1hemtJIFP1FMTaRy5hquAdPf4kkqE2pVbxOezBNmtMHSyGxV0SJPQzxeEWxmhB9xt1ex4UakLAUA4RHwIuMjR26nQvgrA29KbNfMd14ZmEQc+mHyfNSoK7Tww6nD0Z2jLdb1jA4d3AZyUwwpXoZXSlO/tlt1abfCIHLuy/SLUVqEdl5XgsGwljhL6HUr2HBKn/7XqlQPtR++nuqUULVFaoVrfO8GV0DOkWiueAMatKnv8+smNCWNpqKE9A45n2KQOo8yIoAeAtffgxXLTXiFPqu9V6ZtrQfdTVIr2KWftRGq72Aoby5iXc14p0B2Ygg/W
 BfvagVWl
 A+9RtlUJZ4XlMU+K/uqAC1wU3xjKg/gOpiW7E1xr1ebpHlTg7c/2qWwF28cs+dSbUwuyS1n70Qhkw7n0Xj8uSLW+pVFgSgYxcKD4pSWL0dNxg4cWjJoXJpOz4nw/bDZCeQJaKMK+DrWJF7w6dGcDG0m7mI7FvrLl2PaHDoYZ+8q++QpRZtYKjmpAIbA5sUD2RnxGYClyZaYBFEDKmnAB/EEiymJWInaecfIxQhGzVaZ5y2g7re9OseEStXZJTGYRFO+mDjCDq4h9soFwgTG8T99E2RzZgbAMIDl6LmixCGL0oQBK+Uo3bNNMIuigc+d3OPgYIDVOO5sSokt/6Bx5dLN33cxBKvlepC06kQiXxUQdWC1Un7qHDbKiZZve7QPjMrbmtHuGxrr4d0iVIRVQWShFW9egKkDE3mCBFnbiZ7ivRXUo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 07 Nov 2026 14:10:12 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   a3d27154a205f6b32000e7e2734b2a6a4d22c65b
> commit: cb335644ac2611749ab17d3eb6f29c8f77450fa6 [225/232] alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix
> config: hexagon-allmodconfig (https://download.01.org/0day-ci/archive/20261107/202611071330.7rHbLZ6C-lkp@intel.com/config)
> compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project fc9576e3b179738d99c5babe5cd9d6c1f883e0db)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261107/202611071330.7rHbLZ6C-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202611071330.7rHbLZ6C-lkp@intel.com/
> 
> All error/warnings (new ones prefixed by >>):
> 
>    In file included from arch/hexagon/kernel/asm-offsets.c:13:
>    In file included from include/linux/compat.h:14:
>    In file included from include/linux/sem.h:5:
>    In file included from include/uapi/linux/sem.h:5:
>    In file included from include/linux/ipc.h:7:
>    In file included from include/linux/rhashtable-types.h:12:
> >> include/linux/alloc_tag.h:159:24: warning: duplicate 'inline' declaration specifier [-Wduplicate-decl-specifier]
>      159 | static __always_inline inline bool alloc_tag_is_traced(const struct alloc_tag *tag)

bah, thanks, fixed and pushed.

