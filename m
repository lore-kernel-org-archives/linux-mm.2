Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDB4B606A320
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 22:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=byCLO5TS
Received: by kanga.kvack.org (Postfix)
	id 515026B0601; Wed, 18 Nov 2026 17:30:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EC946B0603; Wed, 18 Nov 2026 17:30:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 402BD6B0604; Wed, 18 Nov 2026 17:30:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 17DCE6B0601
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:30:41 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A67481C3F85
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:30:40 +0000 (UTC)
X-FDA: 85449685440.25.078BE2B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id DC59EC0003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:30:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=byCLO5TS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795041039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5HiEgnJ4vXkw0UUO+Qmnim5ib/OYOiSX2+Q+cBS3EWI=;
	b=rmVNW+P/Mc6h5leEmQKI5NpvwhAvb8Pu459nViXDa9NRp90qsZi7TAnI+0knN4qQ5hGNGC
	WUr899bUkxnaEBzoqwkLdT9sz0SdpEHMRoNy+NwP4KQTk5W2Iu1wN/8SCYSVkAv6/md7qM
	i8eTu4e0qy44oFiIduWLtlTHJM4xLVg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=byCLO5TS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795041039;
	b=7fFelm6jGBFfSBgE1glrFwbiaehbADxL0jq5XJpSa+YKfxQoC6ED6FU42d1m/39OJxRrSJ
	qJ669gYh+PF08Pz4E74I00zON1krgx68FK5L85EqyBlB0f2+96Xo38PuLf/seJxKAAkb4y
	Pw4V0bIdoSOhjD3n8trhADT4O4ppCs0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BD0BB64024;
	Wed, 18 Nov 2026 22:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C361F000C4;
	Wed, 18 Nov 2026 22:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795041037;
	bh=5HiEgnJ4vXkw0UUO+Qmnim5ib/OYOiSX2+Q+cBS3EWI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=byCLO5TSgk5MX23zS3L3eJl3Y8OffgcGLhmZBmk83SFsqgpsUc+/h4Cz7A0xBeiEj
	 5WA32cYDUaDG9vw2NczJuXXxY/GMuDUAyHHLDzahXS9IlG6v+R52XnF3F7xohh24s/
	 +amuX3K99aIi9CKsQhUupBL5urpZOuotoxpVZJ1/kLhyWKXvp+uCr78EY/rDFt1bFG
	 hcahzk0chCmhuHN10pHAP2ajfruvC9VX0woMFAhgFxE/JGBDjH5B5KiZ8MdqiwphAC
	 FQqo023lFQf2rCpuBE9+839cVyQt4bzE6lDnz5Kbk4KCM8daKc5tLmNK7jQjLvfLE6
	 p5ft4dppSbjuA==
Message-ID: <92f7177a-a48d-4824-9b63-4ff5b9b3b47d@kernel.org>
Date: Wed, 18 Nov 2026 23:30:33 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: consolidate the memory mapping entries into
 a VMA entry
Content-Language: en-US
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
 Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261118-maintainers-consolidate-vma-entry-v1-1-8019b0e9928f@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261118-maintainers-consolidate-vma-entry-v1-1-8019b0e9928f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DC59EC0003
X-Stat-Signature: kemjx15giht9ra3zk6z3e8j8dms1p7ur
X-Spam-Status: No, score=-22.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795041038-463802
X-HE-Meta: U2FsdGVkX1+u2VOC5KpleWDT/T5fi61J0kbo0+bS0F7fLCdDVo196dDetuhO8B7sdhHeOQfv4shEs50tDHy/4jf4GZS9qzlw2NEfNw4uyHj3aFhj5qhz9NOk1tEFTlTPvc3q8xE1PxB3MIjhVH8MIk+AYDXpN+wIrHbIJ7kC65omBwJjwxRQQiARWWY/Iw9Ra/LGyZgYHSOAZj/Vy6fce8vhmqNj51/0NpUfJouz99bnbbAxYexJf5ZiAcxs4PmCzk9ROkfECQiW03eeZs/8Qe7NnnDMn0P6RIY4Jld5aFWLStWkm8ViTWfeQKMqeZ9+x0HG1BUDJXyY2F0slFyQT8gGlPokcRmEgIn2DRyyShMk5nBPwwocsxvbsKGni9K+10YrMPTddtEgn2WC1Qx7KDUwAAz2Wkz34edbxrI+mRY7AwQf/u45FFnrvKkrrRxow49NkvPGEqdpWWr4F34srsnpmYhXgb0wk6Hj1lET+sDZqskwxNagl4B5tuZbogempjKykUxEqhce5jHT0iFFrJS3DHr230viuw+EHoRd1ZuVEr4c/gr0YiT8YjAVIF2mo69fXeXfsQ6WPxeYuNiEI03/py12j1C4Lbt5VZXXuiEHj+gRJU6qZpBf6d98m1Ai7dMysswbVnqsXnfCfZWwRZQzspba2au8z/wf8K/y9eOUSS0pZkQc7EFPz0g1pByf3wG84DmZD6449vYhf1s4sRuf68wZ0r/qMmf933e3d3XW3PzEFLvfyRq0oDtdZQTIStxbER0Xn0Wxzph693eaUMw124QbKsK4K0gm5SNQhtfArKHnf/EHe2TuYK9Rk758GIk8uEGHYjEbjyidcsWrh0oe0hPT2xOpB9wftmfjAsPS/mtoghvJds7wzZVIuHzXfJ/qRE2QUBlM5EUgSmMtWlIM27OOHRA6D1Mcbf2gPjF1JPD7P9LcuQA42rkzM1Eax+7wTpXP7gOJ82fStMA
 Hk77k+gq
 bF/7mUtXD9lihaV1XVm9XIEePXytEeM7Z6eYT33OU4kZFy9sfTqNeWg+uP6BIAnjr/sysLZnsWh84A3f2HsHyOUxiOsIOSBlSvFZ9XRDaz3oMnBQYqj8JQrFvLOzyRth9zYmdK9nORwsFs2ALHg/gmxXnJap0ERhb3xLMO55REloi39beLoYRXKEtXLxEf0J/IWwcKiVRMX0as57I8n+0VjqkJQMxIyBIRtEsh1VhGQzDwY8XxulDDJFVIk56uWWyDt7LJ5KfJaXd0BCvFNsx4y19NCoo/9sZ9+rLpyM2WffVt2hIt4W8nUp5Qo8Zpy/LQfiXDMamM6YSOnIVNYqCwhRgp8abbG7BbYwLxGPKj6M+vKFgOsOyR29nF7+guA1NllfWeNY1bOSo5/XCjjbvqxTsTIIQKWlRfeiR02Gyy7rF7vcRLVWYzsXVgm4AA0Za2+r38uXt4uwHqygADIa+pif+aIAJN4MN6Dy2MiiffKUWnY6JUoJG4dkTkEnPlMFfFWO/lDSUcCmyz5bL29fW/J8Vl8l9XROCrXpgK3DLSHiZO217egL7nydRqWJ/KjeUJF1AySnE0E90YfwAQSHJ0Ef99b8ZFKF5uZAtgBDq8ShAXZsbzte9OtOZEtufXY4UjcvZ3MHljRLZxAeUe7W8l72FfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/18/26 19:22, Lorenzo Stoakes (ARM) wrote:
> Memory mapping entries were kept in three different sections in order that
> those maintaining/reviewing each distinct part would be made responsible
> for/cc'd on only those parts.
> 
> However this creates confusion as to what files belong to which component,
> so simplify things by consolidating them into one.
> 
> Expand Suren's maintainership to the entire component, as he is a trusted
> and valued member of the VMA kernel team and very much deserving of the
> position.

Nice!

> Additionally, drop Suren's core and misc reviewerships in order to focus
> upon VMA.
> 
> As David is receiving pull requests directly, make him a reviewer, purely
> as an administrative change.
> 
> Also specify the new tree location in preparation for the tree being
> established for next cycle, and remove the link to the not so regularly
> updated linux-mm website.
> 
> Given that, from next cycle, the tree will sit outside of Andrew's current
> process, remove his entry, also purely as an administrative change.
> 
> With that said, I'd like to take the opportunity to express gratitude for
> Andrew's huge contribution to mm, and for his being both generous and
> gracious throughout this period of change in the subsystem.
> 
> Co-developed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  MAINTAINERS | 51 +++++++++++++--------------------------------------
>  1 file changed, 13 insertions(+), 38 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 222b7fc2c3aa..59496dd1d11e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17509,7 +17509,6 @@ R:	Lorenzo Stoakes <ljs@kernel.org>
>  R:	Liam R. Howlett <liam@infradead.org>
>  R:	Vlastimil Babka <vbabka@kernel.org>
>  R:	Mike Rapoport <rppt@kernel.org>
> -R:	Suren Baghdasaryan <surenb@google.com>
>  R:	Michal Hocko <mhocko@suse.com>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> @@ -17680,7 +17679,6 @@ R:	Lorenzo Stoakes <ljs@kernel.org>
>  R:	Liam R. Howlett <liam@infradead.org>
>  R:	Vlastimil Babka <vbabka@kernel.org>
>  R:	Mike Rapoport <rppt@kernel.org>
> -R:	Suren Baghdasaryan <surenb@google.com>
>  R:	Michal Hocko <mhocko@suse.com>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> @@ -17974,30 +17972,37 @@ F:	rust/kernel/mm.rs
>  F:	rust/kernel/mm/
>  F:	rust/kernel/page.rs
>  
> -MEMORY MAPPING
> -M:	Andrew Morton <akpm@linux-foundation.org>
> -M:	Liam R. Howlett <liam@infradead.org>
> +MEMORY MANAGEMENT - VMA
>  M:	Lorenzo Stoakes <ljs@kernel.org>
> +M:	Liam R. Howlett <liam@infradead.org>
> +M:	Suren Baghdasaryan <surenb@google.com>
>  R:	Vlastimil Babka <vbabka@kernel.org>
> -R:	Jann Horn <jannh@google.com>
> +R:	Shakeel Butt <shakeel.butt@linux.dev>
>  R:	Pedro Falcato <pfalcato@suse.de>
> +R:	David Hildenbrand <david@kernel.org>
> +R:	Jann Horn <jannh@google.com>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> -W:	http://www.linux-mm.org
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/vma.git for-next
>  F:	Documentation/core-api/protection-keys.rst
>  F:	Documentation/filesystems/mmap_prepare.rst
> +F:	Documentation/mm/process_addrs.rst
>  F:	Documentation/userspace-api/mseal.rst
>  F:	fs/proc/task_mmu.c
>  F:	fs/proc/task_nommu.c
>  F:	include/linux/mman.h
> +F:	include/linux/mmap_lock.h
>  F:	include/linux/pkeys.h
>  F:	include/trace/events/mmap.h
> +F:	include/trace/events/mmap_lock.h
> +F:	include/uapi/asm-generic/mman-common.h
>  F:	include/uapi/linux/mman.h
>  F:	mm/char-mem.c
> +F:	mm/madvise.c
>  F:	mm/mincore.c
>  F:	mm/mlock.c
>  F:	mm/mmap.c
> +F:	mm/mmap_lock.c
>  F:	mm/mprotect.c
>  F:	mm/mremap.c
>  F:	mm/mseal.c
> @@ -18011,36 +18016,6 @@ F:	mm/vma_internal.h
>  F:	tools/testing/selftests/mm/merge.c
>  F:	tools/testing/vma/
>  
> -MEMORY MAPPING - LOCKING
> -M:	Andrew Morton <akpm@linux-foundation.org>
> -M:	Suren Baghdasaryan <surenb@google.com>
> -M:	Liam R. Howlett <liam@infradead.org>
> -M:	Lorenzo Stoakes <ljs@kernel.org>
> -R:	Vlastimil Babka <vbabka@kernel.org>
> -R:	Shakeel Butt <shakeel.butt@linux.dev>
> -L:	linux-mm@kvack.org
> -S:	Maintained
> -W:	http://www.linux-mm.org
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> -F:	Documentation/mm/process_addrs.rst
> -F:	include/linux/mmap_lock.h
> -F:	include/trace/events/mmap_lock.h
> -F:	mm/mmap_lock.c
> -
> -MEMORY MAPPING - MADVISE (MEMORY ADVICE)
> -M:	Andrew Morton <akpm@linux-foundation.org>
> -M:	Liam R. Howlett <liam@infradead.org>
> -M:	Lorenzo Stoakes <ljs@kernel.org>
> -M:	David Hildenbrand <david@kernel.org>
> -R:	Vlastimil Babka <vbabka@kernel.org>
> -R:	Jann Horn <jannh@google.com>
> -L:	linux-mm@kvack.org
> -S:	Maintained
> -W:	http://www.linux-mm.org
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> -F:	include/uapi/asm-generic/mman-common.h
> -F:	mm/madvise.c
> -
>  MEMORY TECHNOLOGY DEVICES (MTD)
>  M:	Miquel Raynal <miquel.raynal@bootlin.com>
>  M:	Richard Weinberger <richard@nod.at>
> 
> ---
> base-commit: 0c524518413094607a6178c53a65815762bc9c45
> change-id: 20261118-maintainers-consolidate-vma-entry-ff6a360ab069
> 
> Cheers,


