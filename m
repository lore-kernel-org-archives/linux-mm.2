Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13EDBCC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 04:18:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 762A76B0088; Fri, 16 Oct 2026 00:18:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 712A86B008A; Fri, 16 Oct 2026 00:18:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 629086B008C; Fri, 16 Oct 2026 00:18:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D4EC6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:18:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AD84D14028A
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:18:36 +0000 (UTC)
X-FDA: 85327183032.18.D1DE62C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id DEB8A100006
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:18:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=E4Dct8Vk;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792124315;
	b=P7J9qOzZv24mm/3C8Qgan8KvGDfDI7Jr7B7HhtIBUKziKtI07PIr3qX5j4MJ/XzBLE3Sw6
	+vh+QUcV+ACCHrwZjooBjGKdy/AeYpsG6ZNFxQ5iy922+fcqN+oFkG4Hbjyu42IAR5q8TE
	de+AaxfAngSdtboJ5gYReLTxigbRPFE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=E4Dct8Vk;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792124315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QbDnuNasrWjaITOnoYmeUW3ewMNkOQ1kcGgALUd7mpQ=;
	b=H+8UUoDgkRd2B3djJsmhmndh2vgdi/l1e6dnHZoQlKoBXFKCV3qs+Vmv6+lKjguTKMhvQk
	sod2mf3JMGydMBCM4Y70XNj+A4/drpjTdyF/2Vn7/RFMTZcjDtHYxzUtvw/5GDx/bgGX3M
	4uobhuixXWzR3Sto3I5oSQ661cudpdI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A5472600D4;
	Fri, 16 Oct 2026 04:18:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D286A1F000C4;
	Fri, 16 Oct 2026 04:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792124313;
	bh=QbDnuNasrWjaITOnoYmeUW3ewMNkOQ1kcGgALUd7mpQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=E4Dct8Vkz+SkJCejpYR4oJW6gZTakV7zWa0h8ODzWS48qDXN2E1XzVmUEqGwRKBp6
	 TraIq7ebzd27NoSIfORpuGISEved2+C9w2L9gqxnQs/MGyr49s9rS+pkz/lUoj9cL8
	 I8LuLAasSR4327SGNDjGiYoyP+jZRj+Rf4oqk/BQ=
Date: Thu, 15 Oct 2026 21:18:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>, David Laight
 <david.laight.linux@gmail.com>, Rik van Riel <riel@surriel.com>,
 ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 david@kernel.org, Mike Rapoport <rppt@kernel.org>, Dave Hansen
 <dave.hansen@linux.intel.com>, Pedro Falcato <pfalcato@suse.de>, Kiryl
 Shutsemau <kas@kernel.org>, luizcap@redhat.com, pbonzini@redhat.com, Tal
 Zussman <tz2294@columbia.edu>, Matt Fleming <matt@readmodwrite.com>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-Id: <20261015211832.45d87fab15bb3e0bbc2f47cb@linux-foundation.org>
In-Reply-To: <20261016031242.GDatGWKo98YSOhEOOn@fat_crate.local>
References: <asKdhWiJb3qXeopz@pcnci.linuxbox.cz>
	<bd8e9b01ad88cafb12da33331f32a1ce315f590b.camel@surriel.com>
	<20261005132113.43548696@pumpkin>
	<asP5xK4axiUk7jun@pcnci.linuxbox.cz>
	<aseMsMGpGPT/G548@pcnci.linuxbox.cz>
	<20261008182356.GBasffvDuTemTu1VUY@fat_crate.local>
	<20261009090042.39ba9c06@pumpkin>
	<aszH4vpXFAOQP1WG@pcnci.linuxbox.cz>
	<20261014235736.GCatAW8GD0GlYumL4l@fat_crate.local>
	<20261015172820.7961d2c0def74d41cc6c4b0c@linux-foundation.org>
	<20261016031242.GDatGWKo98YSOhEOOn@fat_crate.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DEB8A100006
X-Stat-Signature: rooxbrh753gnjzousb8ibdq9c5mwrqe3
X-HE-Tag: 1792124314-930830
X-HE-Meta: U2FsdGVkX196RcL9eCq83Q9LvTl9ULs6/tp8TF92sj2dWuFTL7GAvWoPRZeIeE9cH4Z/AJXBP8ljymrFKXvbHXCp/kH+gcoqSFzJqNg4zSLx1176s9bCTOcQXb9UcUCN9Q6EyN7KzRqbKHNNUfAoXL9o9WPJeBi2oc4FfTSau6RE1lQu0ar4wSCisSTA0jl+yRvkeebAYQP0tQxvNFY8A+diNdYmbris0kvB5VgUZZePxcvlbn8BiK8Y1DBA6Y/mk4p/FLk5qGXLLJPRzq3FzxzERdNEpNzGl+ivz1H1uYA+0ppqKF3AP07AYPWxQB+U0s4lU9n6dPIwnv2fP3Mqev6pkKjenNPhGeZyWhof4MxPs7WE5oQftSycBkPicOj4wGYjYmir/5DeDmVYDXBRgoXvm8ZVidtcQr3vkbPNgBKW7ljBTw3kVvWrx88NATGcNkWWYMWMptlq5dM21phcUqrCKi8+EZVzT6zM9Wk2RZppHoodM+eq5rZkE+jvW9+sVWpZPtPVHdw6gfzyEkVB7ODAFRv+dciI8r4NszPIGc69CLhyHEYR3ITkBw9dMcAlkWnv+YWd0X4AEHzsSKxSNq9DduBqUJt3SKvqQRayocjoVzdOhaFiZcdG13gDqsHrjACQOKCPO+aF7aCx5WBEVJjznjmGXC24rJ/dwlL/SMvDfnYwu5C7xHaEZRG80Fgc/SOz5qQQLhmCHju2MBC4ZwxQdh0KLvz1xhaEwBSmEC/JoPaGx4MH9uJDsyAHAOvIyPDz2Ut335gUQHKEkGs/u43eSsZm6I9RFmm+HLXd3ZTUTQeTjtGkUCm8Lt9InqnMxBU/xUP+4KW0hc8APl3b8aLoFHv9da72gV2a5/xpBI4G9BJymNtxtOJkFLwkuM4Ci2IJV2aLlyQWY/YDAr7GM7EOHyc0UgJjZGFK8KPYBipt3AyI1EzfPZ+juSnzWe/LSlqaR6CyjgaB2OegFP3
 zsc8lKqa
 42mhvWm3SZhis+H93FuRQJzZmk/cC5IH/tlaHSDpfS//+2nD8af1F7YZ7wGK5kTgDgMJSW4bwQVdruhytzvvcngNzz5Ze/MydTQ8pxeBbKy9VPJJ4AvzKxlpyw1T0e3nglaQXKSDgQ04BAX3eQ93jIesMcAwWfD+Y/PHPA4KqUqUQywsjZNdwWJ5GxwQNyIqgBTwWj89pqwehKif+ZuoMbIsmDAXQpH0rGvJkwcqW1rU+XubiVomJ4uXFoW0WQxN7EHAa92NJnQXICOcIu3plR4LXuXXC7uLvl2M898ddVnxuyntJjpyz0oiYzhE/nJM9PlH21KTPRDvFV1c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Oct 2026 20:12:42 -0700 Borislav Petkov <bp@alien8.de> wrote:

> > If that sounds sane then testing 55780d8a1dcc on that 6.18.x kernel
> > would be useful.
> 
> Hmm, dunno if that LLM sent you into the weeds. Because I ain't no virt guy
> but if vmcb01 and vmcb02 and "L2" in that commit message refer to nested virt,
> I don't think any of those crash dumps do nested virtualization.

LLM said "oops, my bad".  Then


The corruption patterns strongly resemble AMD VMCB state, particularly
FS/GS segment data appearing at the expected VMCB offsets in unrelated
host memory.  This suggests that a VMSAVE operation may have written to
an incorrect physical address.  Ordinary KVM performs VMLOAD/VMSAVE
without nested virtualization, so Boris's objection doesn't eliminate
this possibility.  However, the relevant assembly is essentially
unchanged between 6.18.55 and 7.3-rc6, and I haven't identified a newer
commit that convincingly explains why the corruption apparently stopped
reproducing.  The earlier candidate 55780d8a1dcc remains poorly
motivated without evidence of nested virtualization.

Two investigations look worthwhile.  First, test 6.18.55 with both the
KVM TLB-flush fix (26505e1b5b54) and tlbi=ipi; the existing results
don't conclusively establish whether that combination was tested. 
Second, examine the vmcore to determine whether the corrupted host
pages contain complete FS/GS state matching a legitimate VMCB, rather
than merely a few matching values.  If they do, inspect the VMCB's
VMLOAD/VMSAVE interception and virtualization-enable bits.  That could
establish whether a hardware VMSAVE was allowed to write to an
unintended physical page.  The successful 7.3-rc6/rc7 testing is
encouraging, but it doesn't yet prove that all the reported corruption
symptoms share one cause or have been fixed.

