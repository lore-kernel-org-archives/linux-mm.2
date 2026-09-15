Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 090B7C88E72
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 02:31:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D7326B0088; Mon, 14 Sep 2026 22:31:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AF396B009D; Mon, 14 Sep 2026 22:31:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EF296B009E; Mon, 14 Sep 2026 22:31:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE6E26B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:31:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 406B71C20C3
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:31:52 +0000 (UTC)
X-FDA: 85214421264.10.55B45F4
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf18.hostedemail.com (Postfix) with ESMTP id 271751C0004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:31:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=epZV88N2;
	spf=pass (imf18.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789439510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qSXFbfpOKnuvaEbNiDn4HfVO50MtuTzZ+yYBsK0eDiI=;
	b=dvB970aV9CI7rTzLLtgBBjtgzBRZVUAPs624/Yeeo8uaR3205JqA8/4yK8G+7JQ2ctlc2j
	tFexNUdkIU91wL/lWx9bskMZDEuybpxzk9iN2ZkGMwWZuRq4wdXODE91fd15GBk263zef0
	7+JfaerbX5KGBXi3deyB6LZcqN3yt60=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789439510;
	b=XaCCDcvxuD/pfXGYBsXNVHtstQWLhPJ0T+ocoz89UKLTtTyIFXX/a3NVE1dArSRqU/I6u/
	LRCiv1rveRQPmhUkJkoY/tIPPvS0pKH5vE4FolCFNefgdCK32fyIchv1JXKzW/n/YYS0rc
	NpFV15uqthtj+bWMJycBd3YJJpC10jk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=epZV88N2;
	spf=pass (imf18.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E5CF340E022C;
	Tue, 15 Sep 2026 02:31:46 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id qjc-Nwnlwtg8; Tue, 15 Sep 2026 02:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1789439496; bh=qSXFbfpOKnuvaEbNiDn4HfVO50MtuTzZ+yYBsK0eDiI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=epZV88N2/8zazLMcKvlccwrylVOewX/+KHOEExwCUJZyMLMKCWdHEWrFddkaGlHo3
	 /rAkqnMLs7Mv1O7gPyalgGsZ8dOdjbczGw2Njwgpys5PAhwuem40BaZo3s+hypRWNe
	 q3Yrxy7XscBDptePVIXSiMXYuxfykS2Z8RkkK1BHI8HqMxrizOpyGEhWKfjzxcSc8t
	 AlUFtRN0q4KjqtEBIWkERV0jvgmC51eiighIb0vTjfehho381YFscFIAy1RTLqTAud
	 jiRLdMRFT5dsNWff0ULOIflPBioo4eIvsF3rjqNyDWcVBh2MQMUVAXh0pQkOmtSAkE
	 Xlj2tcMorNeP2JtXhKWRASpEKkHgW/cCRzWx7nALLiycLmx3p0uLLbKyvzoOqSaNhB
	 HxuqcOgpdoUFJf7m/J8McpSUHbnvjPeFvK/yXJ02YAbBLy15DXsInlAEYdtJd7y8Iw
	 LxlhhpBXDHHLv8DHlM88rBAECYVlLxDxM1Sb6UoGNDSGMtV/3NWk8tYbkrno69CIsN
	 /p9kOKTWjTJ/CyOgiYlvFJtsnEKGLVy/ICnxoO20cuYkqnZS2yRFL+EVLcrJ48TfsP
	 NZVIP2MgDtk66smtyDcdMOALcHCtAPdqOOkJHC6aj1MRsKb0t7dZebPa9zjc3vwGh1
	 LrMYUBg8VAsjRJKk75Dgf9Mc=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6408F40E00B9;
	Tue, 15 Sep 2026 02:31:19 +0000 (UTC)
Date: Mon, 14 Sep 2026 19:31:15 -0700
From: Borislav Petkov <bp@alien8.de>
To: Ihor Solodrai <ihor.solodrai@linux.dev>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	linux-kernel@vger.kernel.org, x86@kernel.org, bpf@vger.kernel.org,
	kasan-dev@googlegroups.com, linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/5] x86/cpu: Initialize boot CPU cpuinfo defaults
 early
Message-ID: <20260915023115.GFaqit8zcWHGkAdHD5@fat_crate.local>
References: <20260814235134.3461435-1-ihor.solodrai@linux.dev>
 <20260814235134.3461435-3-ihor.solodrai@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260814235134.3461435-3-ihor.solodrai@linux.dev>
X-Stat-Signature: nbknrg6xthpsxr48x4giwr6bp6o7frqo
X-Rspam-User: 
X-Rspamd-Queue-Id: 271751C0004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789439510-811508
X-HE-Meta: U2FsdGVkX1/aDUmrmNprnkk8xc69HGaweQpmPxVe8+mgL4RMFsl4Ov+l9jUDq94C9zytPdIczOVRIymlIbbFOh0u1E9LF2tZw0s6hpGqBgDRRFXAghDpEJxm/P9GobHgimstPu9R4ugE9wIoUbhtiJ6n7Ns0nwwZbiFLsRwuUYPfKICF9D2CJ1NMh3CbF7hJcz150lJi9LM1McyloAQmv4LPL93fxO+6UOYz4069wGrr468DdfvR52+Nj2GJaqZwCvcgit0WHbwmxf64SRomi2y1ykrYUneYVBrGNfDY96utVOapP6V0kVr7i97EbYzbnCtscA7XneK3ImHCb+Gf2h9eCnoLmxfjQMK4Sgd+KQ7L9P2/W02LSUCKLXPbqcZhUjNlvc8kNDE8kzcQz83ST6LRWIUb/I6b0QGv/BYXoZ3DZ3hUkNSVRv4W8DCegtdDxCSMobdyS7cmp2BwPXKGot6JSQ5lbECrNgeB/+vfHgnnrcub+8FaTbWVVh+1zm7dwsM1aNPfLq4nOpZyBzIaut1PW5B+ehW9nKVluXUX+zzT5IPYNQicI8DAIXMkIxLkcjoqNL5hi10El0+06vw+Mt4A/LCkgMO8MIApa0MLOYrfSaIyUgHumCAKulPcyOZnW0ZouEPWQEFgra2YKIISXwlpktbTXsxYtrUZZCKCLcaRfpQWCSn8QiD+/rSLn2wmtoXEQln+gpw0zHySx9q0PpOu69W2Cua14w90ioZhIuXXpdmlJQe4DFqxJ8v30kuYuQUw15anOiQbxC1IbXPYy9gSibhBvp0G+eZVgwGHFQQAB3Logn6QJR/CoBdHQunzTK/kj6XawdnLWdLT/oODDFikrV1JKof+EX+72ztleDSxn5ie1EYNppO8ahN4IX8hMAazhfrdErdZLtqZNPn6S/tNuAt85xn7+xY1ylcvAsCN3g1s+cgSiwH8fkSc2Q4qa9SV/k3gbQzmDnOKZKz
 T6tcFJ46
 +HxsHVLsWAy2KYvlHZd0tHh3mDLDIcH+7QFCT4EAghzM8By46TY9PyXehO9obMMaaIi7HqJSpjKAkqKtPrbSOUcWMhtUGbhMS4XSAm0nDi/Gl673SYCaMYfNFysKJopDdRhIKFt4Njr6tblwEc9R75gxncO0gnLQMk1aKisxKmH2piVAUmD4MoiD6DR1NAqmxzgJGnhLbQWOzCfWsKxNp5waV51W4wa57HhvqRaAJ+S4EXBnwjZ1K1TNPtE20wbVnfB4A6THYKGMq1NczOHfY0Umvd+cLrFa9lvcOfhbqUpRQL8rOX0rKn/qfEkUfoTrukie+kbQv7y+CJg3P57uk7lcNEP1/hoGr8KdkzBtQS2ct1WzVWtfOWBJAcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 04:51:31PM -0700, Ihor Solodrai wrote:
> early_identify_cpu() clears the capability array, the CPUID table and
> extended_cpuid_level, but the architectural defaults for the rest of
> struct cpuinfo_x86 are set only later, in identify_cpu().

And I would've stopped here. I don't think we care too much about a CPU which
doesn't enumerate CLFLUSH. Or is there an aspect I am missing.

I mean, you can say something along the lines that now things like
->x86_cache_alignment are more correct but I don't think you need to go that
much into detail.

> On x86_64 x86_clflush_size defaults to 64. Until that default is
> applied it reads as zero, which get_cpu_address_sizes() interprets as
> "not enumerated" and replaces with 32. So on a CPU which does not
> enumerate CLFLUSH the boot CPU runs with an x86_clflush_size and an
> x86_cache_alignment of 32 until identify_cpu() resets them to 64.
> 
> Use the same defaults from the start, so that the boot CPU does not
> depend on a later reset to end up with the right ones.
> 
> The values the boot CPU ends up with do not change. Early users of
> cache_line_size() on a CPU which does not enumerate CLFLUSH now see the
> architectural 64 instead of the 32 fallback, which is what they should
> have been seeing all along.
> 
> This change comes before the last patch because that one removes the
> reset: without the defaults established here the boot CPU would be
> left at 32 instead of 64 on an x86_64 CPU which does not enumerate
> CLFLUSH.

This paragraph goes...

> 
> Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
> ---

... here, after the "---" delimiter as it doesn't really belong in the commit
message.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

