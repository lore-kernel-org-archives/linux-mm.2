Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0665D1170E
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 16:35:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7FF36B0026; Tue,  2 Dec 2025 11:35:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B57726B0027; Tue,  2 Dec 2025 11:35:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A944D6B0028; Tue,  2 Dec 2025 11:35:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9AA676B0026
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 11:35:31 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 55BD486D1B
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 16:35:26 +0000 (UTC)
X-FDA: 84175081452.19.1FE1EA2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 78CBB40018
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 16:35:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NPe3ok8n;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764693324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n/ucUR2savlJdlRsAB8Ua/zzHH9A/STh55e1ZFGoMok=;
	b=VT8LHbOSeTDkhF+5C4BpdtFtFn8Ao2zhu4uXLs++/qz9sFdUUphLSnsSqUM05tqs3MfDad
	Xwhlo57TdxLP6eBFXLNOsS+fuNFTGtvuXkn/sArxiU1ObjHMwSM6A+26U39Vg9Kc6A+9rI
	0RLOTyh2VrnLWMcTXZx2X4txUlKji5I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NPe3ok8n;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764693324; a=rsa-sha256;
	cv=none;
	b=fJ6tTSMTTtqoxi43D6PggJDgsuSItCnmq+hC4H1iy9WGFrgdQyYZfYDcX5iw3uRn4rWHLN
	yAUHz5zD6pIPdKhbUJw4nFjK8LPlMLYrZm1BUktdOsX/rJm2EJLMpo9I8pJUqbMvlHa1se
	5T07meVUWatkfvbhOSbHBguJsCRe04c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3572643F71;
	Tue,  2 Dec 2025 16:35:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1859C4CEF1;
	Tue,  2 Dec 2025 16:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764693323;
	bh=c+Kw4G6wwW9KQPvFyW4u+wQDqUJ09F/jHiMPVKzRiuk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NPe3ok8nBKe2DJvZhBsyauenQK8LKJFBFScGEqUtqR2a2ikTZsDl/eK7D/l+2u+bZ
	 tY8neLan5PBXVDYTxW4ojOg6p8ZrgkSAOPMXnAymaL3qvFhYiybjklQ/6as4LeeFwJ
	 ej2vkymWpEg3pf+3vPreHggtPcFWrc52DWbkJ2TI=
Date: Tue, 2 Dec 2025 08:35:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: urezki@gmail.com, elver@google.com, vincenzo.frascino@arm.com,
 glider@google.com, dvyukov@google.com, ryabinin.a.a@gmail.com,
 andreyknvl@gmail.com, kasan-dev@googlegroups.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 maciej.wieczor-retman@intel.com, Jiayuan Chen <jiayuan.chen@linux.dev>
Subject: Re: [PATCH v2 0/2] kasan: vmalloc: Fix incorrect tag assignment
 with multiple vm_structs
Message-Id: <20251202083522.1b0349117b9159b891808532@linux-foundation.org>
In-Reply-To: <cover.1764685296.git.m.wieczorretman@pm.me>
References: <cover.1764685296.git.m.wieczorretman@pm.me>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 78CBB40018
X-Stat-Signature: ykp4hjrmk7a8k6hoi7mpgr8rin1modgb
X-Rspam-User: 
X-HE-Tag: 1764693324-94438
X-HE-Meta: U2FsdGVkX1+x2C1GGFYCjgjHV5/xEuKUrLHQ4qd6NmU4nt0dNDZgDSn98K5ysUbizHET94lwNpOLLUeGoGUl7DiFuru2nvFY38xfVP+rv73B6p9m+fpwv2p9ev5GdDErqeazIRp45GAL2BExglMMQBCKOyWK8Se0oy2gPgtfUpySWu6ddxM23GGS1GErStBGpP9vz9UDQ11zcQ5WvuEaCzDl1xrm2A/FkUdU4VYnyYfp7/n8aQNxmcoeg573UTiIKHB70X9iOzx2XechkPWosbhNhbZd5O5xerdO81uhZM3IOPK9SW4dVQiL2iOLKQg0cRTSqMtKBvVkN9ePjmK7U7zYpyNawesbLK4x1Qm52bbwHNh0US5lRHukIVMHDCZoNLC95wqkea3qINe6Bwz/tXv/Xwj299dml+U3/5LBNvHfNQ0JfsHnBQUmzdOwRoVN3RgabwgXWzwdEJpjoZ7wcuANk/y5epnZaorVRKYD/J/SxJwrkCHZ3q+MEYe5LCWar4qns+LwEvr+smZv5V/yNLuigYfqw3QezVE2LVgYV/B87oY/Q1nlFW8FsASJwyz2Q5ELESzQK0fCaCuiwUgieEpRU1kfN/45wN+T2QOwDHXKBb3l+k1oMHBQvond9XkPtjrvCtEgivpVh8Eb7wlNndufgQ6HenMqBHRd3nJVhIuk9d96ateAPhpN9XHFJPa5Egv3D2Dkb5XAXaQn5FLi1FgsGOIwxcJBc8ti8hm2/me0EP7fI+oZeuWBuCwjS1ypkIrBIox4vEky1+eFebERNiqRtX+tj8AgI63fDqXotOQq5CDiBdxeH1LskJFxTyT40dK/EqSJFS3UD0vaoNnB0eK0qZsxY0yIDoUfB7yXlnkwS1DuBRiSfJMOiAJXsVb/fhgZyvFW/wIwoWoUyBpP6z0EfOkPRZf4ee0YjkdNS8wWxpzydls0IY7ETTg6LlhxcbUDaRif2dsS6QFee0Z
 JcYrY7JA
 7QjCWSzQwRqJuhfKLkKit+beasTy8z8MJ4CsfGiSRDQUyoevcOaPf7HTL90p+RDGfqai+6FbzWI/5r/I1+YN6k5UZbqTP6W5sDfg3L/vNasSjyir8oD+WO+lcwAdR7OP+LEBuISeB8NHWCWzX0jrNEJVIAbJYdGc9Z15hWJfF10c/+VBz5SFiF9D3M2fqgIPhgvm2tb2ck6tzO4hYsciZ6C1z1DRO+VmrDwknBiKKLOfiBsasWe8mSSQDe7on2lP795NnhNqcFbFx2Hiiq2/hlVW7ep6MWpKJbGC/3Mg2CEqSlMtHCsObb5Po3eJmHyse+zMrwHKuy/hPfXLCTVSWjgsuwKoc9KKmFP+DW3pVxaYcXUkaBZnmGBYiH4SVl7r7iFgyCBxlSYKbvLIoViWE28KqpGOJTBprLCBvSWAM8n1Q18aS+k3PkYSSZLthsLHKsX3b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 02 Dec 2025 14:27:56 +0000 Maciej Wieczor-Retman <m.wieczorretman@pm.me> wrote:

> A KASAN tag mismatch, possibly resulting in a kernel panic, can be
> observed on systems with a tag-based KASAN enabled and with multiple
> NUMA nodes. Initially it was only noticed on x86 [1] but later a similar
> issue was also reported on arm64 [2].
> 
> Specifically the problem is related to how vm_structs interact with
> pcpu_chunks - both when they are allocated, assigned and when pcpu_chunk
> addresses are derived.
> 
> When vm_structs are allocated they are tagged if vmalloc support is
> enabled along the KASAN mode. Later when first pcpu chunk is allocated
> it gets its 'base_addr' field set to the first allocated vm_struct.
> With that it inherits that vm_struct's tag.
> 
> When pcpu_chunk addresses are later derived (by pcpu_chunk_addr(), for
> example in pcpu_alloc_noprof()) the base_addr field is used and offsets
> are added to it. If the initial conditions are satisfied then some of
> the offsets will point into memory allocated with a different vm_struct.
> So while the lower bits will get accurately derived the tag bits in the
> top of the pointer won't match the shadow memory contents.
> 
> The solution (proposed at v2 of the x86 KASAN series [3]) is to tag the
> vm_structs the same when allocating them for the per cpu allocator (in
> pcpu_get_vm_areas()).
> 
> Originally these patches were part of the x86 KASAN series [4].
> 
> The series is based on 6.18.

This series overlaps a lot with

https://lkml.kernel.org/r/20251128111516.244497-1-jiayuan.chen@linux.dev

Please discuss!

> [1] https://lore.kernel.org/all/e7e04692866d02e6d3b32bb43b998e5d17092ba4.1738686764.git.maciej.wieczor-retman@intel.com/
> [2] https://lore.kernel.org/all/aMUrW1Znp1GEj7St@MiWiFi-R3L-srv/
> [3] https://lore.kernel.org/all/CAPAsAGxDRv_uFeMYu9TwhBVWHCCtkSxoWY4xmFB_vowMbi8raw@mail.gmail.com/
> [4] https://lore.kernel.org/all/cover.1761763681.git.m.wieczorretman@pm.me/
> 


