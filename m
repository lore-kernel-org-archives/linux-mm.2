Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF982E9904A
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 08:19:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 037676B0005; Fri, 10 Apr 2026 04:19:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F23A76B0089; Fri, 10 Apr 2026 04:19:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E394F6B008A; Fri, 10 Apr 2026 04:19:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D11696B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 04:19:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 734571A0445
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:19:54 +0000 (UTC)
X-FDA: 84641947908.05.7026FC3
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6748710000A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:19:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=akl9dBtH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775809192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zoo8eGSkihm4pzVA3O7YxgtC1cJl7QU3sLX++hivSVg=;
	b=Nr5a8/HyxT5Bapd39vGF0FiL7o9nYkTRiWBjC329vU3+l6G6nPAZn3dPZjX9W+B99e60XJ
	DwOrB+cossdfdgPfUPh7Aa2IEcxOL5pzcfW2qYWVPoyojXokoxq/Sd6Ul6KNsblSMSAO54
	Wa+Z32moZWDNNiI/DurlDkVvcLtgBZs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775809192; a=rsa-sha256;
	cv=none;
	b=HQWeuiCfj40843yVkAHs9XcVm3wqVaYAjVoj7mL2uXWsijRZU25tM1DYSeQ4dJugo9/UeY
	euT66h4MeU5G8dJNNpCY3wevGHaOCt1dC9OVqpWAsxN3NCC/dijT5s83fYJtZmyD2JgLM4
	yMfOkLwSobSDcgql6GWIh1KdzVYiN/s=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=akl9dBtH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775809190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zoo8eGSkihm4pzVA3O7YxgtC1cJl7QU3sLX++hivSVg=;
	b=akl9dBtHidnFCQuw9V6gubcDZsWwzA37+wRfKcpHSp5J4giorE+9zz+ooqFWH2mlUxi2W9
	Qx+36gQebk6ImLIT4CXJKspYN9poyuLbh563Bd1vGEgEjdrNH31Rcmj6YDa9qa/NvqoQ1o
	Xanm0raswE1rD7u11I5yNr6+OJyysc4=
From: Lance Yang <lance.yang@linux.dev>
To: luizcap@redhat.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v3 02/10] mm: introduce pgtable_has_pmd_leaves()
Date: Fri, 10 Apr 2026 16:19:38 +0800
Message-Id: <20260410081938.51302-1-lance.yang@linux.dev>
In-Reply-To: <b65d560458b2488f715b5afc1603d786e786ccf7.1775679721.git.luizcap@redhat.com>
References: <b65d560458b2488f715b5afc1603d786e786ccf7.1775679721.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 6748710000A
X-Stat-Signature: f6sm51q4ezd3em7z31k7ka6b7pjxbxio
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775809192-826412
X-HE-Meta: U2FsdGVkX188UX7KbxWdK5LnmjHDBAwow5Zuvq0fMr5txfGkc3phlV6YNSs7b0TrECLzFW7f6LQnPdqOA5cpT5UkLjRArnU0vgeuZ56DQs7AOgTzYP6b9h1FgaT0VusCMvOlFLEwMsGlerjHCeepJtw6JsMKmU8eVlNUJMOosSmScmz/qYynTMpi3dWErlrWJgBhwgbDu+DeG/WxFemfp2jGhTKVfOxt7vDUitg/MGYlrK2cPramHf0kNjq5d3rt+TrIT/+Z2Cw/1HHt+A9ImaWhf9L8Hx7A5ATVfUsOUWjO5o163UsAC27l3+Iz/3585swmhaZ1TLLXQlaLoRiT4lKwt/mIpz4u8ILafZNh2B9+L9DtMDbwxPevgsCY72IQVzZFldRK4pyk2B3IFF3Mr5eqGJJ+/HnCZeKCJzqt2+sxjDsBigMT7kj+HRvcisqOt0qfR7qA2v+ajt/Pq5Z6JybOJQk+UNylkzyPAFGl3+ieWCh2TpdCKW5NPTbJ4QkSBfumugbMVzWmLKGXEjpUYFPmKG6nbVioG7ncgwIzS5HNbLDwI3PP8kvgmCx86JMxHcpjCSk9RAkZ1mDSzyq0p/lYtF5qZ7JsCk3Xzui8+VqsgScI2HKh8vwF6Q2WCk/rQR6azQ6jnp0RsI9UsC3FZK+DHGwmvvwcDrffdgQ80EqFrbT5xEF5/WKCJrAly8zETi5KWlOr7HzH2hAjfqBjIGYgJZdkTKJXjADHjfZpK62BChrJsy/8r0bADt0dqtI+WEcYPMpMaLr0ahFBTbndQWE25vMGfi6TvmX402ybMyR03FPlC9cBZzjfMy4CMDJParU7vWKm1Z1VBSJC47b99BrLyQS2nYJ60VztkypTMXZAf802PUc7z0/mvhGp5im+mHLA3hPI9N8BxFHEwNKJDONEyZv3UE130PFyGZkSVeY9f/q/rpGZzOZXk7q8tm2tLBOV1drq4WlZBGAkg0V
 gUuoBSn1
 VvGGaTfFSp7FaSECkPdt+7biIm6NIukuMMV+8U8CzNUyJz5nVdG7Y5bgWoLIjgzeiX65OD7d5RbNdBaSbKWMdtK/giekDSxgL2tOsiEnzcBojQcQdiCWs4iA07On47UgHSmLhwLwP/U/IGLIUV7kG9z05Hu1ym+JQnbkL2mJYTSDYHL+NkLt0PevVWHE5KnI8wG5XqkGGjCiV85UeBDtSCJ6AQeUNqWICGJL41ARxeMXMl866Yn7cXOFujhnRToQmNfgjDCA+BfALVsVYgAdwVyXSAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Apr 08, 2026 at 04:22:57PM -0400, Luiz Capitulino wrote:
>Currently, we have two helpers that check for PMD-sized pages but have
>different names and slightly different semantics:
>
>- has_transparent_hugepage(): the name suggests it checks if THP is
>  enabled, but when CONFIG_TRANSPARENT_HUGEPAGE=y and the architecture
>  implements this helper, it actually checks if the CPU supports
>  PMD-sized pages
>
>- thp_disabled_by_hw(): the name suggests it checks if THP is disabled
>  by the hardware, but it just returns a cached value acquired with
>  has_transparent_hugepage(). This helper is used in fast paths
>
>This commit introduces a new helper called pgtable_has_pmd_leaves()
>which is intended to replace both has_transparent_hugepage() and
>thp_disabled_by_hw(). pgtable_has_pmd_leaves() has very clear semantics:
>it returns true if the CPU supports PMD-sized pages and false otherwise.
>It always returns a cached value, so it can be used in fast paths.
>
>The new helper requires an initialization step which is performed by
>init_arch_has_pmd_leaves(). We call init_arch_has_pmd_leaves() early
>during boot in start_kernel() right after parse_early_param() but before
>parse_args(). This allows early_param() handlers to change CPU flags if
>needed (eg. parse_memopt() in x86-32) while also allowing users to use
>the API from __setup() handlers.
>
>The next commits will convert users of both has_transparent_hugepage()
>and thp_disabled_by_hw() to pgtable_has_pmd_leaves().
>
>Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>---
> include/linux/pgtable.h | 15 +++++++++++++++
> init/main.c             |  1 +
> mm/memory.c             |  8 ++++++++
> 3 files changed, 24 insertions(+)
>
>diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>index a50df42a893f..c4c5282f795c 100644
>--- a/include/linux/pgtable.h
>+++ b/include/linux/pgtable.h
>@@ -2192,6 +2192,21 @@ static inline const char *pgtable_level_to_str(enum pgtable_level level)
> 	}
> }
> 
>+#ifdef CONFIG_MMU
>+extern bool __arch_has_pmd_leaves;
>+static inline bool pgtable_has_pmd_leaves(void)
>+{
>+	return __arch_has_pmd_leaves;
>+}
>+void __init init_arch_has_pmd_leaves(void);
>+#else
>+static inline bool pgtable_has_pmd_leaves(void)
>+{
>+	return false;
>+}
>+static inline void __init init_arch_has_pmd_leaves(void) { }
>+#endif
>+
> #endif /* !__ASSEMBLY__ */
> 
> #if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)
>diff --git a/init/main.c b/init/main.c
>index 1cb395dd94e4..07f2ddbf9677 100644
>--- a/init/main.c
>+++ b/init/main.c
>@@ -1044,6 +1044,7 @@ void start_kernel(void)
> 	print_kernel_cmdline(saved_command_line);
> 	/* parameters may set static keys */
> 	parse_early_param();
>+	init_arch_has_pmd_leaves();

One more thought here: I don't see why we need boot-time caching.

has_transparent_hugepage() does *not* look expensive on the common
archs. On x86, it is just a CPU feature check. MIPS is different, yes,
only the first call there is more involved ...

But if we *really* want caching, couldn't we just do it lazily instead
of adding another early boot init step?

Something like:

bool pgtable_has_pmd_leaves(void)
{
	static int __arch_has_pmd_leaves = -1;

	if (READ_ONCE(__arch_has_pmd_leaves) < 0)
		WRITE_ONCE(__arch_has_pmd_leaves, has_transparent_hugepage());

	return READ_ONCE(__arch_has_pmd_leaves);
}

That would avoid depending on parse_early_param() / parse_args()
ordering, and it seems much simpler too :)

The boot-time init step looks a bit shaky to me ...

Thanks,
Lance

